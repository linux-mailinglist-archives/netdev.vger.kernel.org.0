Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0265B644C07
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 19:52:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbiLFSwB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 13:52:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbiLFSv7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 13:51:59 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2074.outbound.protection.outlook.com [40.107.94.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C39023B9CE
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 10:51:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CjxrnS1RT2yy95cKE+V/LtUyIXna+jH7/Es32JyEa25ed9zhRRPkWh1NDVQFnv2nRF4kbjxG/c2nNl+awACLiLiJljpUhxauD5eB1YsFNL1WvKCI6u66FssIzvXDT8NLZs62FVft7Mis4/HX7FMmNebVIlqUbJ3MHfnE3+d2FoiahO+REa79rZeIk2lvxL5D7OSC4Jn/EIHfpAQjLTZzGFAeQlYVRV+jdszLjXB94fyq6uiAycgijXgyghKsKhsiXKf7k2+JzK4rlmpImZlgUyPx67GXjA6hbqiuoZMYx1ME9+aH4eQ1Z5R+L9efE7L4M8vaezStbwK09nD5htSGjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zpRDAUU0UvG5X5FYsrar0ok1kKUQteygubuyxk1Lo1M=;
 b=P9eOocMzJwVz3U8KabeGTyiTvEjc84iXsKHDDeaj6QoxkkLxdh7AHWIaWxsQFcXtpZuHsymc8azI626Nsm6GIlQFQZ3ju/Vsr4QGIBFFb01axKLzaLNDjyHS7ER2/y3rvAVyAYD8cIA1rTH+IRZEgFEzsuAPqvk40SUAFSWj3w7Eu1g0fT2uSVvQ/NgeoORD9Otr4PJqdRBluLuJu9SQO89yqBy/OrTfklf6+eo47k04v8Zed7QyWQs915WV2Wxb/Ltgh4qpZMBWsgwDHNFZrhCXe35PcUQMeM7HP6ZLWs3JqCUpAyq1M/D6F8uGvvf+hCZ/do0ZtynlDS/8usMCjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zpRDAUU0UvG5X5FYsrar0ok1kKUQteygubuyxk1Lo1M=;
 b=os/1gctkBwgP2MzuY50JtFro82ulmu2rMgHfeW7dLm5/PyEX/+nP5jnjZrbbd7DuIc63ybdNVVk2cC8sTTzaZd8M+NVqUhb8bUBvocEngP/NIR9fB/Ag53aEONZzkZyx+X0gno6yDivoTqhknIKCIGmDASjfoMxy9cW0BEF5eAf35AN/tcJ1ehA2ElG8s+CeYPcdH2/2bUXn/wj+sX0e88MnBEpMh+eZ7gUFWlsnA3dxYn6g2KKEFAqwnAAOOtPE/V9saIvo1FesjXH6xx0+XRZBcAk16H05PWqD+jEMhKEACqESyB/JW8JV1B1l6F5CK5ZlYWIUw3EPAFqoDrxmWg==
Received: from DM6PR17CA0032.namprd17.prod.outlook.com (2603:10b6:5:1b3::45)
 by CO6PR12MB5426.namprd12.prod.outlook.com (2603:10b6:5:35d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Tue, 6 Dec
 2022 18:51:53 +0000
Received: from DS1PEPF0000E643.namprd02.prod.outlook.com
 (2603:10b6:5:1b3:cafe::cf) by DM6PR17CA0032.outlook.office365.com
 (2603:10b6:5:1b3::45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8 via Frontend
 Transport; Tue, 6 Dec 2022 18:51:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS1PEPF0000E643.mail.protection.outlook.com (10.167.17.197) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.8 via Frontend Transport; Tue, 6 Dec 2022 18:51:52 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 6 Dec 2022
 10:51:43 -0800
Received: from nps-server-23.mtl.labs.mlnx (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Tue, 6 Dec 2022 10:51:40 -0800
From:   Shay Drory <shayd@nvidia.com>
To:     <netdev@vger.kernel.org>, <kuba@kernel.org>, <davem@davemloft.net>
CC:     <danielj@nvidia.com>, <yishaih@nvidia.com>, <jiri@nvidia.com>,
        <saeedm@nvidia.com>, <parav@nvidia.com>,
        Shay Drory <shayd@nvidia.com>
Subject: [PATCH net-next V4 4/8] devlink: Expose port function commands to control RoCE
Date:   Tue, 6 Dec 2022 20:51:15 +0200
Message-ID: <20221206185119.380138-5-shayd@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221206185119.380138-1-shayd@nvidia.com>
References: <20221206185119.380138-1-shayd@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E643:EE_|CO6PR12MB5426:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f3243c9-3ed1-48bc-e32d-08dad7baf0bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 62dx1VnxEq16GF3nmVwE2XbCSkQzDHG3nIrvwZbT7hvR/Ovf8nmyWGKzncqcFxDKIJSPR+1bq3uHyfuyMoB90PaCJR0eyRi+lwozi80d0X/prd4T7aQWZVFHnbeS0yep7hjvoBM71S+42qrSR3+epykfZB5Co2SrY2lZy9i3UCXcGA+JXyrVq7WClyaRnCxxntbrZd3uAoddcma9HLLuDx8BaVjf9yKk3JHHfA47i2RJehdqHPlnuhy3P7Jocdccdn9i76IcGpqE0zdiSdlh2zLw14mRLt/9ek2gIrS/NTXQTXrnTD1YrwHa6wHG93mOgF8KFXxlX6dSOQkIspiAhgm3TDiojZylTIzflATP7KBULOiVDWIm2oc7HEN2Y403W8p+HEg/3tB3iURpiFhMDxlOv1mIawJj5V9qzL0bpptR30KU4QzuPPzRYh+Cz2M/ZZj79GwRC3xs5IyhRjrBLlbK8NgYQY1ph4ZRpTkATLoEhvAzw2iWTmHIZpeH6RsjMeUQzqVNsCMnP/cFYP3F7qylq3l028b20cERBHs66JNtExo/VFwgFB3b9dttK8l6dO5uzP4sMOvt608RarNUTILWYaSNZcPXYGsn7ZFdJvvHhQkhYpFBzjaR366yVR94qzs3hWvKBIV6ALXlZX4w4bKBJVvp5MdAGNdpojszQ6VFFLhjbsdrW5XZg6PHAGvVFUn2c/fu5gENNhCvAISu9w==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(396003)(136003)(39860400002)(451199015)(40470700004)(46966006)(36840700001)(36756003)(82740400003)(5660300002)(86362001)(7636003)(356005)(8936002)(40460700003)(4326008)(41300700001)(30864003)(2906002)(36860700001)(83380400001)(54906003)(70586007)(316002)(70206006)(2616005)(110136005)(40480700001)(8676002)(16526019)(82310400005)(478600001)(107886003)(6666004)(426003)(1076003)(47076005)(186003)(26005)(336012);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2022 18:51:52.7583
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f3243c9-3ed1-48bc-e32d-08dad7baf0bc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E643.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5426
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Expose port function commands to enable / disable RoCE, this is used to
control the port RoCE device capabilities.

When RoCE is disabled for a function of the port, function cannot create
any RoCE specific resources (e.g GID table).
It also saves system memory utilization. For example disabling RoCE enable a
VF/SF saves 1 Mbytes of system memory per function.

Example of a PCI VF port which supports function configuration:
Set RoCE of the VF's port function.

$ devlink port show pci/0000:06:00.0/2
pci/0000:06:00.0/2: type eth netdev enp6s0pf0vf1 flavour pcivf pfnum 0
vfnum 1
    function:
        hw_addr 00:00:00:00:00:00 roce enable

$ devlink port function set pci/0000:06:00.0/2 roce disable

$ devlink port show pci/0000:06:00.0/2
pci/0000:06:00.0/2: type eth netdev enp6s0pf0vf1 flavour pcivf pfnum 0
vfnum 1
    function:
        hw_addr 00:00:00:00:00:00 roce disable

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
v3-v4:
 - change port_function_roce to port_fn_roce.
v2->v3:
 - change DEVLINK_PORT_FN_SET_CAP to devlink_port_fn_cap_fill.
 - move out DEVLINK_PORT_FN_CAPS_VALID_MASK from UAPI.
 - introduce DEVLINK_PORT_FN_CAP_ROCE and add _BIT suffix to
   devlink_port_fn_attr_cap.
---
 .../networking/devlink/devlink-port.rst       |  34 +++++-
 include/net/devlink.h                         |  18 +++
 include/uapi/linux/devlink.h                  |  10 ++
 net/core/devlink.c                            | 113 ++++++++++++++++++
 4 files changed, 174 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/devlink/devlink-port.rst b/Documentation/networking/devlink/devlink-port.rst
index 2c637f4aae8e..c3302d23e480 100644
--- a/Documentation/networking/devlink/devlink-port.rst
+++ b/Documentation/networking/devlink/devlink-port.rst
@@ -110,7 +110,7 @@ devlink ports for both the controllers.
 Function configuration
 ======================
 
-A user can configure the function attribute before enumerating the PCI
+Users can configure one or more function attributes before enumerating the PCI
 function. Usually it means, user should configure function attribute
 before a bus specific device for the function is created. However, when
 SRIOV is enabled, virtual function devices are created on the PCI bus.
@@ -122,6 +122,9 @@ A user may set the hardware address of the function using
 `devlink port function set hw_addr` command. For Ethernet port function
 this means a MAC address.
 
+Users may also set the RoCE capability of the function using
+`devlink port function set roce` command.
+
 Function attributes
 ===================
 
@@ -162,6 +165,35 @@ device created for the PCI VF/SF.
       function:
         hw_addr 00:00:00:00:88:88
 
+RoCE capability setup
+---------------------
+Not all PCI VFs/SFs require RoCE capability.
+
+When RoCE capability is disabled, it saves system memory per PCI VF/SF.
+
+When user disables RoCE capability for a VF/SF, user application cannot send or
+receive any RoCE packets through this VF/SF and RoCE GID table for this PCI
+will be empty.
+
+When RoCE capability is disabled in the device using port function attribute,
+VF/SF driver cannot override it.
+
+- Get RoCE capability of the VF device::
+
+    $ devlink port show pci/0000:06:00.0/2
+    pci/0000:06:00.0/2: type eth netdev enp6s0pf0vf1 flavour pcivf pfnum 0 vfnum 1
+        function:
+            hw_addr 00:00:00:00:00:00 roce enable
+
+- Set RoCE capability of the VF device::
+
+    $ devlink port function set pci/0000:06:00.0/2 roce disable
+
+    $ devlink port show pci/0000:06:00.0/2
+    pci/0000:06:00.0/2: type eth netdev enp6s0pf0vf1 flavour pcivf pfnum 0 vfnum 1
+        function:
+            hw_addr 00:00:00:00:00:00 roce disable
+
 Subfunction
 ============
 
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 5f6eca5e4a40..ce4c65d2f2e7 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1451,6 +1451,24 @@ struct devlink_ops {
 	int (*port_function_hw_addr_set)(struct devlink_port *port,
 					 const u8 *hw_addr, int hw_addr_len,
 					 struct netlink_ext_ack *extack);
+	/**
+	 * @port_fn_roce_get: Port function's roce get function.
+	 *
+	 * Query RoCE state of a function managed by the devlink port.
+	 * Return -EOPNOTSUPP if port function RoCE handling is not supported.
+	 */
+	int (*port_fn_roce_get)(struct devlink_port *devlink_port,
+				bool *is_enable,
+				struct netlink_ext_ack *extack);
+	/**
+	 * @port_fn_roce_set: Port function's roce set function.
+	 *
+	 * Enable/Disable the RoCE state of a function managed by the devlink
+	 * port.
+	 * Return -EOPNOTSUPP if port function RoCE handling is not supported.
+	 */
+	int (*port_fn_roce_set)(struct devlink_port *devlink_port,
+				bool enable, struct netlink_ext_ack *extack);
 	/**
 	 * port_new() - Add a new port function of a specified flavor
 	 * @devlink: Devlink instance
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 70191d96af89..6cc2925bd478 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -658,11 +658,21 @@ enum devlink_resource_unit {
 	DEVLINK_RESOURCE_UNIT_ENTRY,
 };
 
+enum devlink_port_fn_attr_cap {
+	DEVLINK_PORT_FN_ATTR_CAP_ROCE_BIT,
+
+	/* Add new caps above */
+	__DEVLINK_PORT_FN_ATTR_CAPS_MAX,
+};
+
+#define DEVLINK_PORT_FN_CAP_ROCE _BITUL(DEVLINK_PORT_FN_ATTR_CAP_ROCE_BIT)
+
 enum devlink_port_function_attr {
 	DEVLINK_PORT_FUNCTION_ATTR_UNSPEC,
 	DEVLINK_PORT_FUNCTION_ATTR_HW_ADDR,	/* binary */
 	DEVLINK_PORT_FN_ATTR_STATE,	/* u8 */
 	DEVLINK_PORT_FN_ATTR_OPSTATE,	/* u8 */
+	DEVLINK_PORT_FN_ATTR_CAPS,	/* bitfield32 */
 
 	__DEVLINK_PORT_FUNCTION_ATTR_MAX,
 	DEVLINK_PORT_FUNCTION_ATTR_MAX = __DEVLINK_PORT_FUNCTION_ATTR_MAX - 1
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 035249c5dd17..8c0ad52431c5 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -195,11 +195,16 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(devlink_hwmsg);
 EXPORT_TRACEPOINT_SYMBOL_GPL(devlink_hwerr);
 EXPORT_TRACEPOINT_SYMBOL_GPL(devlink_trap_report);
 
+#define DEVLINK_PORT_FN_CAPS_VALID_MASK \
+	(_BITUL(__DEVLINK_PORT_FN_ATTR_CAPS_MAX) - 1)
+
 static const struct nla_policy devlink_function_nl_policy[DEVLINK_PORT_FUNCTION_ATTR_MAX + 1] = {
 	[DEVLINK_PORT_FUNCTION_ATTR_HW_ADDR] = { .type = NLA_BINARY },
 	[DEVLINK_PORT_FN_ATTR_STATE] =
 		NLA_POLICY_RANGE(NLA_U8, DEVLINK_PORT_FN_STATE_INACTIVE,
 				 DEVLINK_PORT_FN_STATE_ACTIVE),
+	[DEVLINK_PORT_FN_ATTR_CAPS] =
+		NLA_POLICY_BITFIELD32(DEVLINK_PORT_FN_CAPS_VALID_MASK),
 };
 
 static const struct nla_policy devlink_selftest_nl_policy[DEVLINK_ATTR_SELFTEST_ID_MAX + 1] = {
@@ -680,6 +685,60 @@ devlink_sb_tc_index_get_from_attrs(struct devlink_sb *devlink_sb,
 	return 0;
 }
 
+static void devlink_port_fn_cap_fill(struct nla_bitfield32 *caps,
+				     u32 cap, bool is_enable)
+{
+	caps->selector |= cap;
+	if (is_enable)
+		caps->value |= cap;
+}
+
+static int devlink_port_fn_roce_fill(const struct devlink_ops *ops,
+				     struct devlink_port *devlink_port,
+				     struct nla_bitfield32 *caps,
+				     struct netlink_ext_ack *extack)
+{
+	bool is_enable;
+	int err;
+
+	if (!ops->port_fn_roce_get)
+		return 0;
+
+	err = ops->port_fn_roce_get(devlink_port, &is_enable, extack);
+	if (err) {
+		if (err == -EOPNOTSUPP)
+			return 0;
+		return err;
+	}
+
+	devlink_port_fn_cap_fill(caps, DEVLINK_PORT_FN_CAP_ROCE, is_enable);
+	return 0;
+}
+
+static int devlink_port_fn_caps_fill(const struct devlink_ops *ops,
+				     struct devlink_port *devlink_port,
+				     struct sk_buff *msg,
+				     struct netlink_ext_ack *extack,
+				     bool *msg_updated)
+{
+	struct nla_bitfield32 caps = {};
+	int err;
+
+	err = devlink_port_fn_roce_fill(ops, devlink_port, &caps, extack);
+	if (err)
+		return err;
+
+	if (!caps.selector)
+		return 0;
+	err = nla_put_bitfield32(msg, DEVLINK_PORT_FN_ATTR_CAPS, caps.value,
+				 caps.selector);
+	if (err)
+		return err;
+
+	*msg_updated = true;
+	return 0;
+}
+
 static int
 devlink_sb_tc_index_get_from_info(struct devlink_sb *devlink_sb,
 				  struct genl_info *info,
@@ -1263,6 +1322,35 @@ static int devlink_port_fn_state_fill(const struct devlink_ops *ops,
 	return 0;
 }
 
+static int
+devlink_port_fn_roce_set(struct devlink_port *devlink_port, bool enable,
+			 struct netlink_ext_ack *extack)
+{
+	const struct devlink_ops *ops = devlink_port->devlink->ops;
+
+	return ops->port_fn_roce_set(devlink_port, enable, extack);
+}
+
+static int devlink_port_fn_caps_set(struct devlink_port *devlink_port,
+				    const struct nlattr *attr,
+				    struct netlink_ext_ack *extack)
+{
+	struct nla_bitfield32 caps;
+	u32 caps_value;
+	int err;
+
+	caps = nla_get_bitfield32(attr);
+	caps_value = caps.value & caps.selector;
+	if (caps.selector & DEVLINK_PORT_FN_CAP_ROCE) {
+		err = devlink_port_fn_roce_set(devlink_port,
+					       caps_value & DEVLINK_PORT_FN_CAP_ROCE,
+					       extack);
+		if (err)
+			return err;
+	}
+	return 0;
+}
+
 static int
 devlink_nl_port_function_attrs_put(struct sk_buff *msg, struct devlink_port *port,
 				   struct netlink_ext_ack *extack)
@@ -1281,6 +1369,10 @@ devlink_nl_port_function_attrs_put(struct sk_buff *msg, struct devlink_port *por
 					   &msg_updated);
 	if (err)
 		goto out;
+	err = devlink_port_fn_caps_fill(ops, port, msg, extack,
+					&msg_updated);
+	if (err)
+		goto out;
 	err = devlink_port_fn_state_fill(ops, port, msg, extack, &msg_updated);
 out:
 	if (err || !msg_updated)
@@ -1653,6 +1745,7 @@ static int devlink_port_function_validate(struct devlink_port *devlink_port,
 					  struct netlink_ext_ack *extack)
 {
 	const struct devlink_ops *ops = devlink_port->devlink->ops;
+	struct nlattr *attr;
 
 	if (tb[DEVLINK_PORT_FUNCTION_ATTR_HW_ADDR] &&
 	    !ops->port_function_hw_addr_set) {
@@ -1665,6 +1758,18 @@ static int devlink_port_function_validate(struct devlink_port *devlink_port,
 				    "Function does not support state setting");
 		return -EOPNOTSUPP;
 	}
+	attr = tb[DEVLINK_PORT_FN_ATTR_CAPS];
+	if (attr) {
+		struct nla_bitfield32 caps;
+
+		caps = nla_get_bitfield32(attr);
+		if (caps.selector & DEVLINK_PORT_FN_CAP_ROCE &&
+		    !ops->port_fn_roce_set) {
+			NL_SET_ERR_MSG_ATTR(extack, attr,
+					    "Port doesn't support RoCE function attribute");
+			return -EOPNOTSUPP;
+		}
+	}
 	return 0;
 }
 
@@ -1692,6 +1797,14 @@ static int devlink_port_function_set(struct devlink_port *port,
 		if (err)
 			return err;
 	}
+
+	attr = tb[DEVLINK_PORT_FN_ATTR_CAPS];
+	if (attr) {
+		err = devlink_port_fn_caps_set(port, attr, extack);
+		if (err)
+			return err;
+	}
+
 	/* Keep this as the last function attribute set, so that when
 	 * multiple port function attributes are set along with state,
 	 * Those can be applied first before activating the state.
-- 
2.38.1

