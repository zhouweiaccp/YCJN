﻿<%@ Page Language="C#" AutoEventWireup="true" Inherits="MenuManage_ManageRole" Codebehind="ManageRole.aspx.cs" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 4.01 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>角色管理</title>
        <link href="../jQueryEasyUI/themes/icon.css" rel="stylesheet" type="text/css" />
    <link href="../jQueryEasyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../jQueryEasyUI/css/djxt.css" rel="stylesheet" type="text/css" />
    <link href="../js/My97DatePicker/skin/WdatePicker.css" rel="stylesheet" type="text/css" />

    <script src="../jQueryEasyUI/jquery-1.6.2.js" type="text/javascript"></script>

    <script src="../jQueryEasyUI/jquery.easyui.min.js" type="text/javascript"></script>

    <script src="../js/My97DatePicker/WdatePicker.js" type="text/javascript"></script>

    <script language="javascript" type="text/javascript" src="../js/My97DatePicker/WdatePicker.js"></script>
    
    <style type="text/css">
        
        #menu
        {
        	border:1px solid #2a88bb;
        }

    .button
    {
    width:56px;  /*图片宽带*/
    background:url(../img/button.jpg) no-repeat left top;  /*图片路径*/
    border:none;  /*去掉边框*/
    height:24px; /*图片高度*/
    color:White;
    vertical-align: middle;
    text-align:center
    }

    .grid-head 
    { 
        font-size: 12px; 
        font-weight:bold; 
        color:White;
        background-image:url(../img/footer.jpg); 
        text-align:center; 
        vertical-align:middle; 
    }

    
    .style4
    {
    	font-size:12px;
        width:500px;
        color:#599ce0;
    }
    .style5
        {
            font-size:13px;     
            color:Black;
        }
        .style6
        {
        	font-size:13px;
        	color:#0a4869;
        	font-weight:bold;
        }

    </style>
<script type="text/javascript">
    var ihight;
    $(document).ready(function () {
        ihight = pageHeight();
        $('#dv_add').hide();
        Grid();
    });

    function Grid() {
        $('#test').datagrid({
            title: '角色列表',
            iconCls: 'icon-search',
            nowrap: true,
            autoRowHeight: false,
            striped: true,
            height: ihight - 130,
            align: 'center',
            collapsible: true,
            url: 'ManageRole.aspx',
            sortName: 'ID_KEY',
            sortOrder: 'asc',
            remoteSort: false,
            queryParams: { param: 'seachList' },
            idField: 'id',
            frozenColumns: [[
                { field: 'ck', checkbox: true }
			    ]],
            columns: [[
				    { field: 'T_GRPID', title: '角色编号', width: 120, align: 'center' },
				    { field: 'T_GRPDESC', title: '角色描述', width: 150, align: 'center' }
			    ]],
            pagination: true,
            rownumbers: true,
            toolbar: [{
                id: 'btnadd',
                text: '添加角色',
                iconCls: 'icon-add',
                handler: function () {
                    $('#dv_edit').show();
                    AddShow();
                }
            },
		        {
		            id: 'btnadd',
		            text: '编辑角色',
		            iconCls: 'icon-edit',
		            handler: function () {
		                var rows = $('#test').datagrid('getSelections');
		                var id = "";
		                var oid = "";
		                var name = "";
		                $.each(rows, function (i, n) {
		                    id += "" + n.T_GRPID + ",";
		                    oid += n.T_GRPID + ',';
		                    name += n.T_GRPDESC + ',';
		                });
		                id = id.substring(0, id.length - 1);
		                oid = oid.substring(0, oid.length - 1);
		                name = name.substring(0, name.length - 1);
		                $('#test').datagrid('clearSelections');
		                $('#txtID').val(id);
		                $('#txtOID').val(oid);
		                $('#txtName').val(name);
		                EditShow();
		            }
		        },
		        {
		            id: 'btnadd',
		            text: '删除角色',
		            iconCls: 'icon-remove',
		            handler: function () {
		                var rows = $('#test').datagrid('getSelections');
		                var id = "";
		                var name = "";
		                $.each(rows, function (i, n) {
		                    id += "" + n.T_GRPID + ",";
		                    name += n.T_GRPDESC + ',';
		                });
		                name = name.substring(0, name.length - 1);
		                id = id.substring(0, id.length - 1);
		                $.messager.confirm('删除角色信息', '你确定要删除 ' + id + '  吗?', function (ok) {
		                    if (ok) {
		                        Remove(id);
		                    } else {
		                        $.messager.alert('删除角色信息', '删除已取消!', 'info');
		                    }
		                });
		            }
		        }],
            onDblClickRow: function (rowIndex, rowData) {
                $('#test').datagrid('clearSelections');
                $('#txtID').val(rowData.T_GRPID);
                $('#txtOID').val(rowData.T_GRPID);
                $('#txtName').val(rowData.T_GRPDESC);
                EditShow();
            }
        });
    }

    function seachParment() {
        var query = { param: 'seachList' }; //把查询条件拼接成JSON
        $("#test").datagrid('reload'); //重新加载
    }

    function AddShow() {
        $("#dv_add").attr('title', '添加角色信息');
        $('#txtID').val('');
        $('#txtName').val('');
        $('#dv_add').show();
        $('#dv_add').dialog({
            buttons: [{
                text: '添加',
                iconCls: 'icon-ok',
                handler: function () {
                    Add($('#txtID').val(), $('#txtName').val());
                }
            }, {
                text: '重置',
                iconCls: 'icon-no',
                handler: function () {
                    $('#dv_add').dialog('close');
                }
            }]
        });
    }

    function Add(id, name) {

        $.post("ManageRole.aspx", { param: 'Add', id: id, name: name }, function (data) {
            seachParment();
            $('#dv_add').dialog('close');
            $.messager.alert('添加角色信息', data.message, 'info');
        }, 'json');
    }
    function Remove(id) {
        $.post("ManageRole.aspx", { param: 'Remove', id: id }, function (data) {
            seachParment();
            $.messager.alert('删除角色信息', data.message, 'info');
        }, 'json');
    }

    function EditShow() {
        $("#dv_add").attr('title', '编辑角色信息');
        $('#dv_add').show();
        $('#dv_add').dialog({
            buttons: [{
                text: '保存',
                iconCls: 'icon-ok',
                handler: function () {
                    Edit($('#txtID').val(), $('#txtOID').val(), $('#txtName').val());
                }
            }, {
                text: '取 消',
                iconCls: 'icon-no',
                handler: function () {
                    $('#dv_add').dialog('close');
                }
            }]
        });
    }

    function Edit(id, oid, name) {
        $.post("ManageRole.aspx", { param: 'Edit', id: id, oid: oid, name: name }, function (data) {
            seachParment();
            $('#dv_add').dialog('close');
            $.messager.alert('编辑角色信息', data.message, 'info');
        }, 'json');
    }
    function pageHeight() {
        if ($.browser.msie) {
            return document.compatMode == "CSS1Compat" ? document.documentElement.clientHeight :
            document.body.clientHeight;
        } else {
            return self.innerHeight;
        }
    };

    function pageWidth() {
        if ($.browser.msie) {
            return document.compatMode == "CSS1Compat" ? document.documentElement.clientWidth :
            document.body.clientWidth;
        } else {
            return self.innerWidth;
        }
    }; 
		
</script>
    
</head>
<body>
    <form id="form1" runat="server">
     <div id="menu" >
    <table id="__01" width="100%" height="92%" border="0" cellpadding="0" cellspacing="0"  bgcolor="#FFFFFF" >       
    <tr>
		<td background="../img/table-head.jpg" height="30px" valign="middle" class="style6">&nbsp;角色管理</td>
	</tr>
	<tr>
		<td background="../img/table-head-2.jpg" height="25px" valign="middle" class="style5">&nbsp;注意事项</td>
	</tr>
	<tr>
	<td align="left" valign="middle" height="30px">
    <div class="style4">
    &nbsp;&nbsp;角色ID必须唯一不可重复</div>
    </td>
    </tr>
	<tr>
	<td>
	<div>
    <table id="test">
    </table>
    </div>
    </td>
    </tr>
    
    
    <div id="dv_add" data-options="iconCls:'icon-save'" style="padding: 5px; width: 400px;
        height: 200px;">
        <p>
            &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; 角色编号&nbsp;
            <input id="txtID" class="easyui-validatebox" type="text" name="name" style="border: solid 1px #E0ECF9;
                text-align: center;" /><input type="text" id="txtOID" style="visibility:hidden" /></p>
        <p>
            &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; 角色名称&nbsp;
            <input id="txtName" class="easyui-validatebox" type="text" name="name" style="border: solid 1px #E0ECF9;
                text-align: center;" /></p>
                
    </div>
    </table>
    </div>
    </form>
</body>
</html>
