Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22DDF641D64
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 15:17:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbiLDORP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 09:17:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230122AbiLDORE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 09:17:04 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2067.outbound.protection.outlook.com [40.107.223.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F4001741A
        for <netdev@vger.kernel.org>; Sun,  4 Dec 2022 06:17:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GLPe9DbzG+Dg1u2xKbQtv3eXEWIQcEwcNhQeYYdE8zAjtbHroHcA0gVVHIqgye4riuPiMAQs/skaPDmHL2yqg7kFLPuXDxL0D65AFlcpuBDjA0EC+fuQUvbmxP7JbVQFehCAyxvyKojTTXgF9K1oLxHcWoax61OwPqbZ64t9nyU1y33JOn3AF9IXyK9nDdHqJZOlqY84ziYO3Q2zqCa3bLChoVUNe+2QCgwcFe3LQ/OvfnM1Gu1xZXyxqLH+X/YREwxwg4Z1HmxDG5Q7cCEx8RSmhtSY5w2iVFSB4fyUKkFN5uBE2mGCA41o60egz4BXi+DTlohuKNsGLbqjLXLYWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6+0ub8Y60/IvhYN8EY32hTLsVvQva2YYjsQ2fqyozzw=;
 b=FzHWamz+9pLSLkbZU0b62adjxly3S7o8dPcoiTsTQioP6BxOsfxALkF0Co76Ur57sRt+YIj6ezmnpPBLbzXldByphWm7mi2XFedRRPAdfikJVTGwP0/uxwNu+T/Esd9Of5xs0iPRrNM3Zk+dREPhQVZYa+GGvSJoALH5wYLnioAfOkKuLDWnRZp4z6yhzWQJkSaILInTYaOfT11+sIzcrdiKNVSFVpd58fM+RpCdonMUW5CXfBHzW71Y2FkDvs0Bw19jn9X3horZ+1Nb2A3uT2T51422jZ0jQ/dys/dU40FqZFC8UlwpsIHcFgi9UENdgN8qeaRGA7NaKRYrelCO0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6+0ub8Y60/IvhYN8EY32hTLsVvQva2YYjsQ2fqyozzw=;
 b=BDXWYrUbnrDnV7IWfYsA4AqUICcGJ5E1tlARXgGOSowqvG6MCruoCUgQiT81m0mcdUduUWi4KXtWR3j/EFCRUYBYyOrFTEXRtuTkiLfueDcZchB5Q91iw1SQuXdqeFolOFirvg/SsDf64vkWywpYWJUrWChrtAhYaqlLQqGrAl1/ygJJTzS43HZGEzQdXseen1tssowUiTU7KPUZ8gGekZDTK/BhHeUaPo/vjPuxecMGwyGHkEXOj2ln+51WLpMCX1pZqFVPZzJ+oiZLF4+j11OybGGFsnsRVHiuzsCPgfChTDmXFEtQY277qCIDsdL7MqIfuz9Pxv5xKuVsIv/nkg==
Received: from DS7PR03CA0292.namprd03.prod.outlook.com (2603:10b6:5:3ad::27)
 by DM4PR12MB5375.namprd12.prod.outlook.com (2603:10b6:5:389::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.13; Sun, 4 Dec
 2022 14:17:01 +0000
Received: from DM6NAM11FT018.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3ad:cafe::62) by DS7PR03CA0292.outlook.office365.com
 (2603:10b6:5:3ad::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.13 via Frontend
 Transport; Sun, 4 Dec 2022 14:17:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT018.mail.protection.outlook.com (10.13.172.110) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.13 via Frontend Transport; Sun, 4 Dec 2022 14:17:01 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 4 Dec 2022
 06:16:55 -0800
Received: from nps-server-23.mtl.labs.mlnx (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Sun, 4 Dec 2022 06:16:51 -0800
From:   Shay Drory <shayd@nvidia.com>
To:     <netdev@vger.kernel.org>, <kuba@kernel.org>, <davem@davemloft.net>
CC:     <danielj@nvidia.com>, <yishaih@nvidia.com>, <jiri@nvidia.com>,
        <saeedm@nvidia.com>, <parav@nvidia.com>,
        Shay Drory <shayd@nvidia.com>
Subject: [PATCH net-next V3 4/8] devlink: Expose port function commands to control RoCE
Date:   Sun, 4 Dec 2022 16:16:28 +0200
Message-ID: <20221204141632.201932-5-shayd@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221204141632.201932-1-shayd@nvidia.com>
References: <20221204141632.201932-1-shayd@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT018:EE_|DM4PR12MB5375:EE_
X-MS-Office365-Filtering-Correlation-Id: 9012b1f9-8900-4da0-03c0-08dad6023638
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dyZ9TnAVhlXMjJoCbnYFlhJylohQcNVA/P1GHNfXU4OBeYYJot3lE7dRqVK3UjU47WonzRTZHDDJkYhXLMzlTVMd7T+4uDk9Bn5X6HceRGo5Y52AMUgfiwuuJcqJa7h4zoBk8I914RmbKXlyJt3zQ0SNPotgY9/sKB+Yx8enOaKp5H4VV6EA4kohkHqpIjYy/7QafhG1WuK4mmuC1q0OY6D8jAYf13xQMwWYh0/1dx1HgppG/OWbQI3Qdt4ieaOKQnGIc698VcAzFR/cVMmxhHbOFbDZZDTmR1zEJygxG5qHDkLsZHdP+Zk4S+BnCWAPIpYrpwuAa7PW2NvgO1tzTgZq5sy9ufk1RiZYTLJAR2oCB16hwPRD+jcjNME2ABlhBGIhF35+nFdUU0EAoJd7aM3MtIGAJiEpISTl3sOugFx7A2TOEHovpO+Ue2MbC1XTtijXjF/DNhLEfIzDhqXMnoi1NVnegD5nJNjjcmXEC7RAvQGYMU8CncyqgKx7i//qLVUUX378epnW1rFIX3Suo/ZjUx/k6C5pm9k0plhlBojAnqDzGcAV4Ty8smi7F0+Wo1IQQGlqOzKwljcOl45sSwqr80rPEBCb1unRKGi3c8vpEUYSVSGvUBEQTCseUtgAGN9C3JvfuCWrObQLPxt5WZXujHHa4Xg1+J/A9qS/XUoMtLuWj9aWGcxEH+E35snkaqkPctfyj8ClP6XkN++KZw==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(376002)(346002)(39860400002)(451199015)(40470700004)(36840700001)(46966006)(40480700001)(36756003)(86362001)(40460700003)(478600001)(82310400005)(26005)(36860700001)(186003)(30864003)(107886003)(6666004)(5660300002)(8676002)(4326008)(316002)(8936002)(41300700001)(54906003)(110136005)(2906002)(70206006)(70586007)(82740400003)(7636003)(356005)(1076003)(2616005)(336012)(16526019)(83380400001)(47076005)(426003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2022 14:17:01.2859
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9012b1f9-8900-4da0-03c0-08dad6023638
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT018.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5375
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
v2->v3:
 - change DEVLINK_PORT_FN_SET_CAP to devlink_port_fn_cap_fill.
 - move out DEVLINK_PORT_FN_CAPS_VALID_MASK from UAPI.
 - introduce DEVLINK_PORT_FN_CAP_ROCE and add _BIT suffix to
   devlink_port_fn_attr_cap.
 - remove DEVLINK_PORT_FN_ATTR_CAPS_MAX
---
 .../networking/devlink/devlink-port.rst       |  34 +++++-
 include/net/devlink.h                         |  19 +++
 include/uapi/linux/devlink.h                  |  10 ++
 net/core/devlink.c                            | 113 ++++++++++++++++++
 4 files changed, 175 insertions(+), 1 deletion(-)

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
index 5f6eca5e4a40..20306fb8a1d9 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1451,6 +1451,25 @@ struct devlink_ops {
 	int (*port_function_hw_addr_set)(struct devlink_port *port,
 					 const u8 *hw_addr, int hw_addr_len,
 					 struct netlink_ext_ack *extack);
+	/**
+	 * @port_function_roce_get: Port function's roce get function.
+	 *
+	 * Query RoCE state of a function managed by the devlink port.
+	 * Return -EOPNOTSUPP if port function RoCE handling is not supported.
+	 */
+	int (*port_function_roce_get)(struct devlink_port *devlink_port,
+				      bool *is_enable,
+				      struct netlink_ext_ack *extack);
+	/**
+	 * @port_function_roce_set: Port function's roce set function.
+	 *
+	 * Enable/Disable the RoCE state of a function managed by the devlink
+	 * port.
+	 * Return -EOPNOTSUPP if port function RoCE handling is not supported.
+	 */
+	int (*port_function_roce_set)(struct devlink_port *devlink_port,
+				      bool enable,
+				      struct netlink_ext_ack *extack);
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
index 2b6e11277837..5c4d3abd7677 100644
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
@@ -692,6 +697,60 @@ devlink_sb_tc_index_get_from_attrs(struct devlink_sb *devlink_sb,
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
+	if (!ops->port_function_roce_get)
+		return 0;
+
+	err = ops->port_function_roce_get(devlink_port, &is_enable, extack);
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
@@ -1275,6 +1334,35 @@ static int devlink_port_fn_state_fill(const struct devlink_ops *ops,
 	return 0;
 }
 
+static int
+devlink_port_fn_roce_set(struct devlink_port *devlink_port, bool enable,
+			 struct netlink_ext_ack *extack)
+{
+	const struct devlink_ops *ops = devlink_port->devlink->ops;
+
+	return ops->port_function_roce_set(devlink_port, enable, extack);
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
@@ -1293,6 +1381,10 @@ devlink_nl_port_function_attrs_put(struct sk_buff *msg, struct devlink_port *por
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
@@ -1665,6 +1757,7 @@ static int devlink_port_function_validate(struct devlink_port *devlink_port,
 					  struct netlink_ext_ack *extack)
 {
 	const struct devlink_ops *ops = devlink_port->devlink->ops;
+	struct nlattr *attr;
 
 	if (tb[DEVLINK_PORT_FUNCTION_ATTR_HW_ADDR] &&
 	    !ops->port_function_hw_addr_set) {
@@ -1677,6 +1770,18 @@ static int devlink_port_function_validate(struct devlink_port *devlink_port,
 				   "Function does not support state setting");
 		return -EOPNOTSUPP;
 	}
+	attr = tb[DEVLINK_PORT_FN_ATTR_CAPS];
+	if (attr) {
+		struct nla_bitfield32 caps;
+
+		caps = nla_get_bitfield32(attr);
+		if (caps.selector & DEVLINK_PORT_FN_CAP_ROCE &&
+		    !ops->port_function_roce_set) {
+			NL_SET_ERR_MSG_ATTR(extack, attr,
+					    "Port doesn't support RoCE function attribute");
+			return -EOPNOTSUPP;
+		}
+	}
 	return 0;
 }
 
@@ -1704,6 +1809,14 @@ static int devlink_port_function_set(struct devlink_port *port,
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

