Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFC5A39E775
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 21:24:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230353AbhFGT0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 15:26:20 -0400
Received: from mail-dm6nam11on2042.outbound.protection.outlook.com ([40.107.223.42]:17953
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230261AbhFGT0T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 15:26:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DhWMbzWUsA/dj4PIn4z6n/2ww2BrCTgehL5YhJ/EoV5u+4oYzZNqXOPoimtwYapMw4xD/LaDJhWqhjQ0+/Xk6goXtyuBDleWPtpmmevvFxpK08SnOEuMHQXv9/AajKbG/qc0+y2U2HXHvu/Lj4z8gG4etcd/vUewTshoJp2oKfDGFg+K+ENWqZ6qb623I4EN5QHRNaLiMqph8pKwkmlQk8v5K+Esap0eULwTC4rZLOmzBnQjT5MRa7qlcUgPAzP22N6UkD8u//qm2LFhJ+pXNXEhoB4gc2lG8DgTZdRUNH1gvTAxoiHMXW/U1hqwFEu2hPJ9UQYb0muz/WyEDJBKlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=de7v57ZkxbGxBHsa9doFJSB8dALejaWDCAc1Lq2V1U8=;
 b=FbhYqHewLYFwpVibYLUIBE/nZ6MsQadcV2fKLLweI8Bj3jkjvir0WcnduQNrrgqXCBYiKFDt7WxTYTAQnx2mlFdlMOo119F8vPUY5tJnRfxvjjAw9LnjkaCRukcRvUtdaGzMOIC2fxX8DnO7JEfo2ruy3rC70x+gYdwiouiGM78Q5Go4GOHyb6vtY+fgbFk5V13tdpr6maqu1eN+zuuTdLu5vIMMVfzTuIcMaHU8XXDtDYZe+HSAP/fnIk7E4rmgAa0ejPTK9H2KhxnKA1gocQhyfKURJEB6v0k/agtnm9ue8Y5FwBHTjTbwHjDNKdWJqxXaUDULe2g4v1DQZ0IGhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=de7v57ZkxbGxBHsa9doFJSB8dALejaWDCAc1Lq2V1U8=;
 b=hyK53y4CFmYQ/vHVLHjmX51M63fH9ygPbJSJghD2ufvb82uo0p3o9tDZKHRRsmjf1HXNp6xZfm8V71QP2AMc4eSrKVqblAzfqwkC2Z1ge4YmhHMrjTWzYgYA7c0ffbXsrPzLjrIIeY7yLMmQa9AfOUybKIYgLjxc67sj4DZWcEK9Owogio5ONzCdFfUFB2RVfrPJVE2jEBhj1gCBLORQX+QYrtDkMiX5YTrrr1pJEbj5JIJzuGSnpabxv18mK2Et9jtgrmIiAsKtE8GGsX+e07NJebSqYK7rZL9Btm1dmQG/U6zmAmmcPrbkA53743CG261IscRhR6feie/E39veEQ==
Received: from DM3PR11CA0014.namprd11.prod.outlook.com (2603:10b6:0:54::24) by
 DM5PR12MB2343.namprd12.prod.outlook.com (2603:10b6:4:b3::38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4195.24; Mon, 7 Jun 2021 19:24:27 +0000
Received: from DM6NAM11FT035.eop-nam11.prod.protection.outlook.com
 (2603:10b6:0:54:cafe::41) by DM3PR11CA0014.outlook.office365.com
 (2603:10b6:0:54::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.22 via Frontend
 Transport; Mon, 7 Jun 2021 19:24:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT035.mail.protection.outlook.com (10.13.172.100) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4195.22 via Frontend Transport; Mon, 7 Jun 2021 19:24:26 +0000
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 7 Jun
 2021 19:24:25 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <dsahern@gmail.com>, <stephen@networkplumber.org>,
        <netdev@vger.kernel.org>
CC:     Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH iproute2-next v2] devlink: Add optional controller user input
Date:   Mon, 7 Jun 2021 22:24:06 +0300
Message-ID: <20210607192406.14884-1-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b5703e03-3ce8-47ab-47ff-08d929e9dd7b
X-MS-TrafficTypeDiagnostic: DM5PR12MB2343:
X-Microsoft-Antispam-PRVS: <DM5PR12MB2343C4A67455F46294FEA087DC389@DM5PR12MB2343.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1443;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qwFobqyzybxK5eX1XZmY1xENWrqDFnI56PE5pd5zbiELtVOdJN5adIATzRHgGv5CPjr21tKjjYuDRVVwOIhlhAqvcHV0ExR//rMVdYVUt17gDK2x32iSVG/Frg/gepC9osZa/NyFa8ukjQ3uQ6wQsvvwMdHFhI7FrP69VhrAbXeWG6NchemqFZV0RNzVbDzg/JBmZ/nfQXeqKpDO9TC6BuqRSF4J0iv015VXAoQbYFLM/tA+/xNU4XQUqDNzLr4JVs6YEtSWV26SBkvqxd7D/9dfXggUSVQjMw/KXqU4RakPzdWXiRAxyPW7cFJ7aZIWweLN+bbmpzg/U3X01HWNxAChqf4/xdKStjivKGmSGqpg3jDU9wHjJBcRDpLGcDkFObB6YcCrkzfGLOr9uFiSbSh4slAjs7Ay0qVxKMVTOSBSAdJvtr7BHSysj4pah0ENoRGAW6mABBzKAZhyiyoqmsTJEBMINkZY7E97IV0q4HTeKdDQmYiilQvPtGBlyVepABcIWkAAj52Ox2Y8/jkClIY784m3ZF5lau1vH+CN7pERQcdCP25BalixeCHpk8Q/wtZGzSiVPBc1k99KiD5+o56iJLWqAs3/Iceo149NM8BeAlhaFBcrOK122uuHKYGELKlYlYMMfq1k0K390sZruQ==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(39860400002)(376002)(346002)(396003)(36840700001)(46966006)(356005)(16526019)(186003)(2906002)(7636003)(47076005)(1076003)(478600001)(426003)(4326008)(5660300002)(36906005)(54906003)(110136005)(316002)(36756003)(8936002)(107886003)(83380400001)(36860700001)(8676002)(6666004)(26005)(82310400003)(70206006)(86362001)(82740400003)(336012)(2616005)(70586007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2021 19:24:26.8609
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b5703e03-3ce8-47ab-47ff-08d929e9dd7b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT035.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2343
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A user optionally provides the external controller number when user
wants to create devlink port for the external controller.

An example on eswitch system:
$ devlink dev eswitch set pci/0033:01:00.0 mode switchdev

$ devlink port show
pci/0033:01:00.0/196607: type eth netdev enP51p1s0f0np0 flavour physical port 0 splittable false
pci/0033:01:00.0/131072: type eth netdev eth0 flavour pcipf controller 1 pfnum 0 external true splittable false
  function:
    hw_addr 00:00:00:00:00:00

$ devlink port add pci/0033:01:00.0 flavour pcisf pfnum 0 sfnum 77 controller 1
pci/0033:01:00.0/163840: type eth netdev eth1 flavour pcisf controller 1 pfnum 0 sfnum 77 external true splittable false
  function:
    hw_addr 00:00:00:00:00:00 state inactive opstate detached

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
changelog:
v1->v2: (addresssed comments from David)
 - split the command help output and man page to multiple lines to make it readable
---
 devlink/devlink.c       | 21 ++++++++++++++++++---
 man/man8/devlink-port.8 | 21 +++++++++++++++++++++
 2 files changed, 39 insertions(+), 3 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 0b5548fb..30f15e07 100644
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
@@ -3795,7 +3806,9 @@ static void cmd_port_help(void)
 	pr_err("       devlink port param set DEV/PORT_INDEX name PARAMETER value VALUE cmode { permanent | driverinit | runtime }\n");
 	pr_err("       devlink port param show [DEV/PORT_INDEX name PARAMETER]\n");
 	pr_err("       devlink port health show [ DEV/PORT_INDEX reporter REPORTER_NAME ]\n");
-	pr_err("       devlink port add DEV/PORT_INDEX flavour FLAVOUR pfnum PFNUM [ sfnum SFNUM ]\n");
+	pr_err("       devlink port add DEV/PORT_INDEX flavour FLAVOUR pfnum PFNUM\n"
+	       "                      [ sfnum SFNUM ]\n"
+	       "                      [ controller CNUM ]\n");
 	pr_err("       devlink port del DEV/PORT_INDEX\n");
 }
 
@@ -4324,7 +4337,9 @@ static int __cmd_health_show(struct dl *dl, bool show_device, bool show_port);
 
 static void cmd_port_add_help(void)
 {
-	pr_err("       devlink port add { DEV | DEV/PORT_INDEX } flavour FLAVOUR pfnum PFNUM [ sfnum SFNUM ]\n");
+	pr_err("       devlink port add DEV/PORT_INDEX flavour FLAVOUR pfnum PFNUM\n"
+	       "                      [ sfnum SFNUM ]\n"
+	       "                      [ controller CNUM ]\n");
 }
 
 static int cmd_port_add(struct dl *dl)
@@ -4342,7 +4357,7 @@ static int cmd_port_add(struct dl *dl)
 
 	err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE | DL_OPT_HANDLEP |
 				DL_OPT_PORT_FLAVOUR | DL_OPT_PORT_PFNUMBER,
-				DL_OPT_PORT_SFNUMBER);
+				DL_OPT_PORT_SFNUMBER | DL_OPT_PORT_CONTROLLER);
 	if (err)
 		return err;
 
diff --git a/man/man8/devlink-port.8 b/man/man8/devlink-port.8
index 563c5833..78cfd076 100644
--- a/man/man8/devlink-port.8
+++ b/man/man8/devlink-port.8
@@ -52,9 +52,13 @@ devlink-port \- devlink port configuration
 .IR FLAVOUR " ]"
 .RB "[ " pcipf
 .IR PFNUMBER " ]"
+.br
 .RB "{ " pcisf
 .IR SFNUMBER " }"
 .br
+.RB "[ " controller
+.IR CNUM " ]"
+.br
 
 .ti -8
 .B devlink port del
@@ -174,6 +178,12 @@ Specifies sfnumber to assign to the device of the SF.
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
 
@@ -327,6 +337,17 @@ devlink dev param set pci/0000:01:00.0/1 name internal_error_reset value true cm
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

