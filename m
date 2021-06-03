Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E067399FA7
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 13:19:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbhFCLVG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 07:21:06 -0400
Received: from mail-bn1nam07on2061.outbound.protection.outlook.com ([40.107.212.61]:9577
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229746AbhFCLVG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 07:21:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XyFfnO7P+nCsAGOBX7xJc93h35vrr4PmEhxK6K6sFOxzKVhLgSzjkQ0LMFmMcDlL2Mm2x2ptURT8+Nu2mp+7A5NZJzfQjwcURU7WVocHziTej+NK5EsvsnjN8v76rwlvf0Dvs/lG9VAgOB0wrTJFxfoLHnl454LQLfOIMZ8Aq+iT4kZeMM7dL4YuSOLU3M6HnQ2+zsY0bmfFLllZ6q7atDZ6Il71V0jEY/WHI5smxGN2lf7xxDmRDSMkGMEDKElLF4sEubp2Rme+FH3oCeMVzFFSO9R0JBNd6ZrePP2k3ySrOnzOCReLdssWBJVFkXrvouaoaMlX7lNQqUoWaE9tgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0No4cLqDeq3kUNtypMU5VgkbBh0z6+w5dheemsk2iLU=;
 b=Sx7KHbjqILfzEVxkPpyYlAtnu8E4i408baLJURZzCj/+P6lACkLbsDgLOZF3xrenwDiosMBu/kMAg6mcT8oolCS4Gbad/0Ekhf+5JSeCaYwFRTwVdkP+2RxmuEHQE+gCBrzj7xu5wgXu+cNJdwJV/Ilbn4rmWWShNfAkRwTAvGErrU6WElGYwE//wfWOiq/HU/hK7Czv2XbvFw0+P2LIt5xqcw/gGjp/EmNC37CG5Eh8sAqA+hlaBayMoPDU7nr6zrdrErYuZ3KxA+PEXstHW60Ll04YsOnv7EVdGIIc+YqD+eJoSWEs3BmzLASz14+tREsXiaOYsXqp5MSZAAHp1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0No4cLqDeq3kUNtypMU5VgkbBh0z6+w5dheemsk2iLU=;
 b=BoJzHUv2eZqfDtoru52LONyy+Vo14sP7afxfoO17RBucYpNVzIgQHoyEvq1G348WjindI09r0FGjWC0fh0b5Md1QZkMv8ybajTxSNVZ+KnbinFQneyEPb31lE3j7VcXrVI8oblZ7AviuNjOgUHjeMFkSWK2xWJT85VjF0hUbdRYVoQE+jNJmLfZJbaAgnB/kFRxadvQ3qm/xiQEvx2j5LS49787IZm+ycHwOACgnL+sFM2LvUE9KN8gjRTOjaX0fkBnM05jgQiiLidhyoBBgI6rUXHIoCUA5Ba3D1BXnSSWZdEUu/J4Nh9xCZUOXzx1cvSY3TMGfoNwCX1oZHo8heA==
Received: from MWHPR12CA0068.namprd12.prod.outlook.com (2603:10b6:300:103::30)
 by DM4PR12MB5246.namprd12.prod.outlook.com (2603:10b6:5:399::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Thu, 3 Jun
 2021 11:19:20 +0000
Received: from CO1NAM11FT058.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:103:cafe::34) by MWHPR12CA0068.outlook.office365.com
 (2603:10b6:300:103::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.21 via Frontend
 Transport; Thu, 3 Jun 2021 11:19:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT058.mail.protection.outlook.com (10.13.174.164) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4195.22 via Frontend Transport; Thu, 3 Jun 2021 11:19:20 +0000
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 3 Jun
 2021 11:19:19 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <dsahern@gmail.com>, <stephen@networkplumber.org>,
        <netdev@vger.kernel.org>
CC:     Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH RESEND iproute2-next] devlink: Add optional controller user input
Date:   Thu, 3 Jun 2021 14:19:01 +0300
Message-ID: <20210603111901.9888-1-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4317a006-c0ff-493e-2f47-08d926816ed4
X-MS-TrafficTypeDiagnostic: DM4PR12MB5246:
X-Microsoft-Antispam-PRVS: <DM4PR12MB52461F7316F54D9C0ECB4E19DC3C9@DM4PR12MB5246.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1201;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zlntEEVBKPWHaQOVFt4c4tG1RLcyR6U4K0oIOYPnMr+OsqR/Yqd0ER+gsomAiC17clAJQl/R9hedMU5djN7pNYSYsr+43TvCN4taHtLRAvXdbUd+37XnafemALcRNTuKOwLwhYg1ccgPK/GitHMaPxO+QRfi3vIzzUv8I2csf0mLQVw0QwMLHSR8b9VUSkZwliCctvvBw15TjMHEg6T6WGCnJeqipppKBlHQ+Z22iJviqQ9j3wJle+eDZ7EFBnzLENUnmTJDIbnarxSBRc7HdNVe1/ugU+tN7rfaxXGjbmymfMarT6B9pARpaeZI3oDs1RRGf/blqm5r69wGqO3jLXayrXMYDZtqJCpX6sXBlnJsCASAGQhLjs+6MpIFZC31a3WuB1rhFvLq1KtqhcotqwCXPCCj2YJeTH+zdgoIMJ5tWFy6hTXhQzdMA/FM9Aigwk6r+VO154ZiVpR6/KDpuU8n+Tm4Q3iMNSSHyzWHx8TYagi6fFUipN24ZD4sxjQzcEj6WT8Idd9m4F0jtPSLC4xg5oP3Zlep3GO1nq8u3sdtjpqoRKeO5CP9tDbn6Z6oxLYQC30+zEcmyQrghFe92Z2gjvjZYrHc6mWbyPK0zXaN/6Kc7bHFSfzaYbx1aH+XxSHgf8upMNXjDS+NpTylaA==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(376002)(346002)(136003)(39860400002)(36840700001)(46966006)(86362001)(336012)(36860700001)(1076003)(47076005)(82310400003)(36756003)(8676002)(4326008)(2906002)(8936002)(82740400003)(426003)(54906003)(107886003)(110136005)(2616005)(36906005)(7636003)(356005)(478600001)(83380400001)(5660300002)(316002)(186003)(16526019)(26005)(70206006)(70586007)(6666004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2021 11:19:20.0562
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4317a006-c0ff-493e-2f47-08d926816ed4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT058.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5246
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A user optionally provides the external controller number when user
wants to create devlink port for the external controller.

An example on eswitch system:
$ devlink dev eswitch set pci/0033:01:00.0 mode switchdev

$ devlink port show
pci/0033:01:00.0/196607: type eth netdev enP51p1s0f0np0 flavour physical port 0 splittable false

$ devlink port add pci/0033:01:00.0 flavour pcisf pfnum 0 sfnum 77 controller 1
pci/0033:01:00.0/163840: type eth netdev eth0 flavour pcisf controller 1 pfnum 0 sfnum 77 external true splittable false
  function:
    hw_addr 00:00:00:00:00:00 state inactive opstate detached

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 devlink/devlink.c       | 17 ++++++++++++++---
 man/man8/devlink-port.8 | 19 +++++++++++++++++++
 2 files changed, 33 insertions(+), 3 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 0b5548fb..170e8616 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -286,6 +286,7 @@ static void ifname_map_free(struct ifname_map *ifname_map)
 #define DL_OPT_PORT_PFNUMBER BIT(43)
 #define DL_OPT_PORT_SFNUMBER BIT(44)
 #define DL_OPT_PORT_FUNCTION_STATE BIT(45)
+#define DL_OPT_PORT_CONTROLLER BIT(46)
 
 struct dl_opts {
 	uint64_t present; /* flags of present items */
@@ -336,6 +337,7 @@ struct dl_opts {
 	uint32_t overwrite_mask;
 	enum devlink_reload_action reload_action;
 	enum devlink_reload_limit reload_limit;
+	uint32_t port_controller;
 	uint32_t port_sfnumber;
 	uint16_t port_flavour;
 	uint16_t port_pfnumber;
@@ -1886,6 +1888,12 @@ static int dl_argv_parse(struct dl *dl, uint64_t o_required,
 			if (err)
 				return err;
 			o_found |= DL_OPT_PORT_SFNUMBER;
+		} else if (dl_argv_match(dl, "controller") && (o_all & DL_OPT_PORT_CONTROLLER)) {
+			dl_arg_inc(dl);
+			err = dl_argv_uint32_t(dl, &opts->port_controller);
+			if (err)
+				return err;
+			o_found |= DL_OPT_PORT_CONTROLLER;
 		} else {
 			pr_err("Unknown option \"%s\"\n", dl_argv(dl));
 			return -EINVAL;
@@ -2079,6 +2087,9 @@ static void dl_opts_put(struct nlmsghdr *nlh, struct dl *dl)
 		mnl_attr_put_u16(nlh, DEVLINK_ATTR_PORT_PCI_PF_NUMBER, opts->port_pfnumber);
 	if (opts->present & DL_OPT_PORT_SFNUMBER)
 		mnl_attr_put_u32(nlh, DEVLINK_ATTR_PORT_PCI_SF_NUMBER, opts->port_sfnumber);
+	if (opts->present & DL_OPT_PORT_CONTROLLER)
+		mnl_attr_put_u32(nlh, DEVLINK_ATTR_PORT_CONTROLLER_NUMBER,
+				 opts->port_controller);
 }
 
 static int dl_argv_parse_put(struct nlmsghdr *nlh, struct dl *dl,
@@ -3795,7 +3806,7 @@ static void cmd_port_help(void)
 	pr_err("       devlink port param set DEV/PORT_INDEX name PARAMETER value VALUE cmode { permanent | driverinit | runtime }\n");
 	pr_err("       devlink port param show [DEV/PORT_INDEX name PARAMETER]\n");
 	pr_err("       devlink port health show [ DEV/PORT_INDEX reporter REPORTER_NAME ]\n");
-	pr_err("       devlink port add DEV/PORT_INDEX flavour FLAVOUR pfnum PFNUM [ sfnum SFNUM ]\n");
+	pr_err("       devlink port add DEV/PORT_INDEX flavour FLAVOUR pfnum PFNUM [ sfnum SFNUM ] [ controller CNUM ]\n");
 	pr_err("       devlink port del DEV/PORT_INDEX\n");
 }
 
@@ -4324,7 +4335,7 @@ static int __cmd_health_show(struct dl *dl, bool show_device, bool show_port);
 
 static void cmd_port_add_help(void)
 {
-	pr_err("       devlink port add { DEV | DEV/PORT_INDEX } flavour FLAVOUR pfnum PFNUM [ sfnum SFNUM ]\n");
+	pr_err("       devlink port add { DEV | DEV/PORT_INDEX } flavour FLAVOUR pfnum PFNUM [ sfnum SFNUM ] [ controller CNUM ]\n");
 }
 
 static int cmd_port_add(struct dl *dl)
@@ -4342,7 +4353,7 @@ static int cmd_port_add(struct dl *dl)
 
 	err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE | DL_OPT_HANDLEP |
 				DL_OPT_PORT_FLAVOUR | DL_OPT_PORT_PFNUMBER,
-				DL_OPT_PORT_SFNUMBER);
+				DL_OPT_PORT_SFNUMBER | DL_OPT_PORT_CONTROLLER);
 	if (err)
 		return err;
 
diff --git a/man/man8/devlink-port.8 b/man/man8/devlink-port.8
index 563c5833..a5142c4e 100644
--- a/man/man8/devlink-port.8
+++ b/man/man8/devlink-port.8
@@ -54,6 +54,8 @@ devlink-port \- devlink port configuration
 .IR PFNUMBER " ]"
 .RB "{ " pcisf
 .IR SFNUMBER " }"
+.RB "{ " controller
+.IR CNUM " }"
 .br
 
 .ti -8
@@ -174,6 +176,12 @@ Specifies sfnumber to assign to the device of the SF.
 This field is optional for those devices which supports auto assignment of the
 SF number.
 
+.TP
+.BR controller " { " controller " } "
+Specifies controller number for which the SF port is created.
+This field is optional. It is used only when SF port is created for the
+external controller.
+
 .ti -8
 .SS devlink port function set - Set the port function attribute(s).
 
@@ -327,6 +335,17 @@ devlink dev param set pci/0000:01:00.0/1 name internal_error_reset value true cm
 .RS 4
 Sets the parameter internal_error_reset of specified devlink port (#1) to true.
 .RE
+.PP
+devlink port add pci/0000:06:00.0 flavour pcisf pfnum 0 sfnum 88 controller 1
+.RS 4
+Add a devlink port of flavour PCI SF on controller 1 which has PCI PF of number
+0 with SF number 88. To make use of the function an example sequence is to add
+a port, configure the function attribute and activate the function. Once
+the function usage is completed, deactivate the function and finally delete
+the port. When there is desire to reuse the port without deletion, it can be
+reconfigured and activated again when function is in inactive state and
+function's operational state is detached.
+.RE
 
 .SH SEE ALSO
 .BR devlink (8),
-- 
2.26.2

