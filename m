Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82005399F9E
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 13:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbhFCLSI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 07:18:08 -0400
Received: from mail-co1nam11on2078.outbound.protection.outlook.com ([40.107.220.78]:54152
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229629AbhFCLSH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 07:18:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ur0Txv4ebVl7TSG0Q58QW6IZBHat7TUAbZxe1TJiVGjm7b6rFgRhwIIbQhOm2/mRPQi5XgIWhE6T5+V+ZW6mmWudp6OGSj7oXa+1HF8zt2gMQbRPhfni+2n5UW78C9pZbu6ZMoyecsoCe7fISWUAGGru/fKh4Kx/MMy/Xov7AQZ/vU528V8Yim+edvnctyhAUk2vFyrFrSBcQlFQjKkiyfCwkLSlHSdi2h/31PULM23YlI2AAfNGPxWGZ4m5aPUVST7jL08BoYoM9lZVHAJYxKCzxF5BHIuyVW8anZmH1sdUJcrhHWh03z51f+P9EvIv1JLJmesdziExAXLdp2Pz7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0No4cLqDeq3kUNtypMU5VgkbBh0z6+w5dheemsk2iLU=;
 b=i2KhgcCWqSh+ZXkPJwtc6Exg8f/xgGni3pCJ9Prvai97DqrbxMKfg7XclgqXAgYpbz48vEJdXQ9hg1k20zH2149wXmVV/Xg4OcTmJRxFugZhmZqZlhL8HUIsjrRA20cIDOmD9Y6iR+dH4cnRDrJNeTkUymHRl+ObjsQdqY87pXTuZi/ucQPGKjuvPhpzeHRpZnpiSidGh2t3GD2DrLFG95WIcJKQZELuuV6RCUhFuUinXaZXl7xZ52Hi9aJWTqdReg0YQqstsW9ZLyUueUxkZr2odxmrfN2zlrMJqb4zZE6YCMjVx2vuDh14QWDEsMn6Q7ed3bap5niLctYxCmGYpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0No4cLqDeq3kUNtypMU5VgkbBh0z6+w5dheemsk2iLU=;
 b=Z7t7ylnmGXJ/hZZtUpZPP0DSjAz0UJXNKywqM+v3qqX5fP422MZ9+EECsDJtrq0GIIrAzRNxWwReh5rk1Ou0QKw6GqCnOlUxJmty03ssxHNn3aoz1b8i+esjskZ5i1j54fXcKqx5z5hYY/FtCLB/E4MFcpunTpa6lWA038MHj3s3ycRQxiuJl6FFDwjBmrhgLA7nDROBQQ41VNcLJ1y/UEKzwjwxissv8avbQpeZiBHTKPSqfKO30Yl2g+u3tJxcCVR9lOI/9k2l4YABWCgHc5TRm5LtnlV6p0QbOjgpQWgeDJrtYOhuVKWZmj7G44qN2Cw/PLVHhVDj/HqCOPPUTA==
Received: from DM6PR02CA0159.namprd02.prod.outlook.com (2603:10b6:5:332::26)
 by MWHPR1201MB2524.namprd12.prod.outlook.com (2603:10b6:300:eb::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Thu, 3 Jun
 2021 11:16:22 +0000
Received: from DM6NAM11FT014.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:332:cafe::57) by DM6PR02CA0159.outlook.office365.com
 (2603:10b6:5:332::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.23 via Frontend
 Transport; Thu, 3 Jun 2021 11:16:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT014.mail.protection.outlook.com (10.13.173.132) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4195.22 via Frontend Transport; Thu, 3 Jun 2021 11:16:22 +0000
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 3 Jun
 2021 11:16:20 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <dsahern@gmail.com>, <stephen@networkplumber.org>,
        <netdev@vger.kernel.org>
CC:     Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH iproute2-next internal] devlink: Add optional controller user input
Date:   Thu, 3 Jun 2021 14:16:03 +0300
Message-ID: <20210603111603.9822-1-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7c3fe4af-42d8-47c6-ff2f-08d9268104c8
X-MS-TrafficTypeDiagnostic: MWHPR1201MB2524:
X-Microsoft-Antispam-PRVS: <MWHPR1201MB2524DF695FF9266A4E40E8A5DC3C9@MWHPR1201MB2524.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1201;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ulSstV0ADWBawUtOWJL0pwkFoIj+Ua0+pwkAo2fdYc4BwsLgeNKuDlxlacGIGrJ8COMnS5i1NYBZYY6ycLOkxCxKWyan0K6foRXwL62i86ye3jG4ujbZf/kXSSKeYlZwnU1usG0R0no3FPJi5fi7kt1GzCDumBVCjKjtcreUJwDbFS1D6zmSwTsQk+GM6i26NckGEyuNsEDzIPLgaYxkHQNc695bqYd7b3AI0fTn1fvfUQ4C1kFeNj40W5yTrzU5t65EscSYoBAvg819lpfEMbxd+b1d+RyUwnvPB81EyHrFU/vNrYB7VXnYtEWHXchdRkKfXQYgGaskRX7TSY5W7kqviO/gPLIiZBdVFvTzxBChYz9oy5+zP4lwvDQGtlV6/hTbYxDgx8mkcz/OhnxMANXIBkXLP33+J99L3txynOkPmlWl0PansrOFj9pBBBAXw0sHL8iVeWCUSl6zQ5bVC0yUb3nxaePFyQJZdKGvi6jdxLOmt2U5QOJ6hHEZAAJMQeJanHWLcwGwqO1/T5hgdhFdkPzvsr4JFQqFn7z0M/KiMfIpGOVDnFMpVtxCiMz780gVA8kbXlixDm/sgV30bHkvIVBC6OGM5f8zTBUzZLi+L3JOIFl1fdfm0zGT7+OCY4dlG1RxSYeCL8mW1F1vaw==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(39860400002)(376002)(346002)(396003)(46966006)(36840700001)(7636003)(47076005)(6666004)(107886003)(82740400003)(336012)(4326008)(478600001)(5660300002)(36906005)(316002)(426003)(83380400001)(82310400003)(8676002)(70206006)(2906002)(70586007)(26005)(86362001)(1076003)(2616005)(36756003)(356005)(54906003)(16526019)(110136005)(36860700001)(8936002)(186003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2021 11:16:22.1316
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c3fe4af-42d8-47c6-ff2f-08d9268104c8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT014.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB2524
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

