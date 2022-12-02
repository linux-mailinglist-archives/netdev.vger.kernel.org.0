Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6973264021C
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 09:30:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232854AbiLBIaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 03:30:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232214AbiLBI3R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 03:29:17 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2063.outbound.protection.outlook.com [40.107.237.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE87BAE4EA
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 00:26:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lyl1wwpdinH4kj7uN9eOTwkBoYdhncTtiYdnuN5I1aqyRe1CRcnNSPgTLLUYfUdPN0+kugYAx2DtpJnPaU2I9Sd920Nj/nYS+YxgKfE3sePROq8zZSzsjsBL4sZbzYKCFyB6k/Pw+i72TRtGf2ZHNEsGzw3o2e7HE43cdpPUujUF3QTnTtyyDoJEBf6jLtM+VlGav2gfiC3ztNIqVc0Be6BABbI3OLwfa0dXiBrD01Ot+sATJA33rhpRAJlcNN6zkyOgsmxLBVFJBMiC/qDVrIucFVl02M683AyCbUKTrXO2NXru3M/GWinyrClw8VHJ1Pbx9pQEwZYWSLMcCjWo5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t4vdJuVLVBZrPBAuzIDidf+s+xbLYCiBco/upLX7rCI=;
 b=cCw/ZjbofNw27tBVDIPBiAOHwnLukiXfFDGwYt/0ZWU1aoPkiP9OZUXjOFz4nIam7pIBwKrpePmcWKGpL6OZYBkpxS8p7ciTMAF+4Jb337LfNf6r7l5vFs+msmltC7IdBVEy62AerG2kt7wo6BdIKjez4TlbHAGHkKQerx5vzY5s/3P/KKqDpatNOGZKxhPCfVZT63MD0MTTVygi4PdBNk48IgrXmtLbZZ2EN10FUz2H6RMyaUbM8LRRIklR5mAoUxIB2tMUwoQTu0liSB1l6zB3p9kaskO8nx/WVvaBZ2ijfFExV2qNiUt7AXnI+8q11aSpvvGiq+snVsLwvZGGFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t4vdJuVLVBZrPBAuzIDidf+s+xbLYCiBco/upLX7rCI=;
 b=QInmmJHHQdn41xP9nS/8Bzwyz1uXOLfih5KDrvOee69hItG+ULcoCddGt+tUAq+qJCDHYGOKmoUsbLqasZtvHHsj5kLhMPUp39eANyLLmIRf5khEr+FAwtbDr94XD2pIwf9SgesizcKteb4Dr2WVk+5s5GFJsSCVBJVbDVjNuK2onkXUUUvLFPoG3dCDUbZIUqiTcEYLQsiC10E+/6Wk1h1bvB+2nF6dMFnOoVCT7hximLCPBfp8n7JP6AQaKi7ltHZsr32+cdn/6cNbfC1B/H3Fx4ctZ6X1tZ/Txls7FUvT1txftADbPUCPtDsAArq3B/nsd/I7UZjBm3X208xC0A==
Received: from MW4PR03CA0150.namprd03.prod.outlook.com (2603:10b6:303:8c::35)
 by SA1PR12MB7128.namprd12.prod.outlook.com (2603:10b6:806:29c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Fri, 2 Dec
 2022 08:26:58 +0000
Received: from CO1NAM11FT087.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8c:cafe::4e) by MW4PR03CA0150.outlook.office365.com
 (2603:10b6:303:8c::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.10 via Frontend
 Transport; Fri, 2 Dec 2022 08:26:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT087.mail.protection.outlook.com (10.13.174.68) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.8 via Frontend Transport; Fri, 2 Dec 2022 08:26:57 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 2 Dec 2022
 00:26:45 -0800
Received: from nps-server-23.mtl.labs.mlnx (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Fri, 2 Dec 2022 00:26:42 -0800
From:   Shay Drory <shayd@nvidia.com>
To:     <netdev@vger.kernel.org>, <kuba@kernel.org>, <davem@davemloft.net>
CC:     <danielj@nvidia.com>, <yishaih@nvidia.com>, <jiri@nvidia.com>,
        <saeedm@nvidia.com>, <parav@nvidia.com>
Subject: [PATCH net-next V2 4/8] devlink: Expose port function commands to control RoCE
Date:   Fri, 2 Dec 2022 10:26:18 +0200
Message-ID: <20221202082622.57765-5-shayd@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221202082622.57765-1-shayd@nvidia.com>
References: <20221202082622.57765-1-shayd@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT087:EE_|SA1PR12MB7128:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e325e31-9a62-48e8-1a16-08dad43efa4b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h9y+k2C/N6D/IWXabz9JX/9htdxHCE/ud6RIdD0aZ3B5ZcD8wMIQSzl1u39Tft8jhvUyXEuwbyajVDIn9Dq4jbrOLGZQzoXwY4vaUcIKVEf1kfKvzGrar/hjB0qhiSalA6jwgCbfgV/vNH3oP2iUbwEftP1LPEemLpUlDhrKJWqotJ64I4+Nwf6vK6v1ZFfZG1P1otQbujFBRUZIJLOqFB6Pha/T/qUrwNFC057SxUgEJ3V+xZApFvInN0eYM/mMXzfI0XpMMttL3klflq8UsRH9Bqao3kkE+9T3Y+02oxpkJqpwUhaQrGIrLaBtzn413Ya2IACqlN74QxRZEdTggUUX+bhUPJev9uzHjaKd7tU1P+pD3eWbJUgeLJ/wx2vHF9zKzw1WW8tuRkDtRLMV0BzEuyGuTFgehruh1gEKfnvTj4DR+MGJLpgdHXJoc7mWO9M2Nr0Fj27wzjF1xBVyVBvEzx526ly7XZLEl48hLq1U7qK9agRpgP/tJSbWJwa3BBDp6CkOGNvNLawHLKP7XA7758gU1sPdRk+OXuKAvAzR5kvfRIIQWzXE3SRjaVcVp2XZIZyqIea+NlmpIFJ8xaXL2U8VnbRlQViJGrepOalmaZjbLxvc/44+B0jRgRSv06pfPikPPraBKxB3hekpyLwwLN+nMfjP7LgZF7E9d9er0yyFNnCwE5ALJzBmqCA6DLFvg8z0ERT8OTV9QnvqYg==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(39860400002)(376002)(396003)(451199015)(40470700004)(46966006)(36840700001)(40480700001)(7636003)(478600001)(82310400005)(40460700003)(70586007)(82740400003)(26005)(356005)(6666004)(8676002)(36756003)(70206006)(54906003)(336012)(316002)(4326008)(86362001)(110136005)(47076005)(426003)(5660300002)(41300700001)(186003)(8936002)(16526019)(1076003)(2616005)(107886003)(83380400001)(36860700001)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2022 08:26:57.6914
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e325e31-9a62-48e8-1a16-08dad43efa4b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT087.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7128
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
 .../networking/devlink/devlink-port.rst       |  34 +++++-
 include/net/devlink.h                         |  19 +++
 include/uapi/linux/devlink.h                  |  12 ++
 net/core/devlink.c                            | 114 ++++++++++++++++++
 4 files changed, 178 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/devlink/devlink-port.rst b/Documentation/networking/devlink/devlink-port.rst
index 0b520363c6af..79f9c0390b47 100644
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
 'devlink port function set hw_addr' command. For Ethernet port function
 this means a MAC address.
 
+Users may also set the RoCE capability of the function using
+'devlink port function set roce' command.
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
index 70191d96af89..830f8ffd69d1 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -658,11 +658,23 @@ enum devlink_resource_unit {
 	DEVLINK_RESOURCE_UNIT_ENTRY,
 };
 
+enum devlink_port_fn_attr_cap {
+	DEVLINK_PORT_FN_ATTR_CAP_ROCE,
+
+	/* Add new caps above */
+	__DEVLINK_PORT_FN_ATTR_CAPS_MAX,
+	DEVLINK_PORT_FN_ATTR_CAPS_MAX = __DEVLINK_PORT_FN_ATTR_CAPS_MAX - 1
+};
+
+#define DEVLINK_PORT_FN_ATTR_CAPS_VALID_MASK \
+	(_BITUL(__DEVLINK_PORT_FN_ATTR_CAPS_MAX) - 1)
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
index 70614dc90f9c..dcf6aae443a9 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -200,6 +200,8 @@ static const struct nla_policy devlink_function_nl_policy[DEVLINK_PORT_FUNCTION_
 	[DEVLINK_PORT_FN_ATTR_STATE] =
 		NLA_POLICY_RANGE(NLA_U8, DEVLINK_PORT_FN_STATE_INACTIVE,
 				 DEVLINK_PORT_FN_STATE_ACTIVE),
+	[DEVLINK_PORT_FN_ATTR_CAPS] =
+		NLA_POLICY_BITFIELD32(DEVLINK_PORT_FN_ATTR_CAPS_VALID_MASK),
 };
 
 static const struct nla_policy devlink_selftest_nl_policy[DEVLINK_ATTR_SELFTEST_ID_MAX + 1] = {
@@ -692,6 +694,64 @@ devlink_sb_tc_index_get_from_attrs(struct devlink_sb *devlink_sb,
 	return 0;
 }
 
+#define DEVLINK_PORT_FN_CAP(_name) \
+	BIT(DEVLINK_PORT_FN_ATTR_CAP_##_name)
+
+#define DEVLINK_PORT_FN_SET_CAP(caps, cap, enable)	\
+	do {						\
+		typeof(cap) cap_ = (cap); \
+		typeof(caps) caps_ = (caps); \
+		(caps_)->selector |= cap_;	\
+		if (enable)					\
+			(caps_)->value |= cap_; \
+	} while (0)
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
+	DEVLINK_PORT_FN_SET_CAP(caps, DEVLINK_PORT_FN_CAP(ROCE), is_enable);
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
@@ -1275,6 +1335,35 @@ static int devlink_port_fn_state_fill(const struct devlink_ops *ops,
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
+	if (caps.selector & DEVLINK_PORT_FN_CAP(ROCE)) {
+		err = devlink_port_fn_roce_set(devlink_port,
+					       caps_value & DEVLINK_PORT_FN_CAP(ROCE),
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
@@ -1293,6 +1382,10 @@ devlink_nl_port_function_attrs_put(struct sk_buff *msg, struct devlink_port *por
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
@@ -1665,6 +1758,7 @@ static int devlink_port_function_validate(struct devlink_port *devlink_port,
 					  struct netlink_ext_ack *extack)
 {
 	const struct devlink_ops *ops = devlink_port->devlink->ops;
+	struct nlattr *attr;
 
 	if (tb[DEVLINK_PORT_FUNCTION_ATTR_HW_ADDR] &&
 	    !ops->port_function_hw_addr_set) {
@@ -1676,6 +1770,18 @@ static int devlink_port_function_validate(struct devlink_port *devlink_port,
 				   "Function does not support state setting");
 		return -EOPNOTSUPP;
 	}
+	attr = tb[DEVLINK_PORT_FN_ATTR_CAPS];
+	if (attr) {
+		struct nla_bitfield32 caps;
+
+		caps = nla_get_bitfield32(attr);
+		if (caps.selector & DEVLINK_PORT_FN_CAP(ROCE) &&
+		    !ops->port_function_roce_set) {
+			NL_SET_ERR_MSG_ATTR(extack, attr,
+					    "Port doesn't support RoCE function attribute");
+			return -EOPNOTSUPP;
+		}
+	}
 	return 0;
 }
 
@@ -1703,6 +1809,14 @@ static int devlink_port_function_set(struct devlink_port *port,
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

