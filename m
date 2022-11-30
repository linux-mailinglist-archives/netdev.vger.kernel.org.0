Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4037063D506
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 12:54:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234371AbiK3LyA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 06:54:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235223AbiK3LxP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 06:53:15 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2052.outbound.protection.outlook.com [40.107.93.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 312A742983
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 03:53:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mb25SWgjbl6bsXjpe9kuZU/4GsBo/zv111FOK1bW+Z4Y8K7IUKt81+eT+2qqtfMdXu8urmPyJfu+dYVgHYzFj+FCOVcYhckUB3vIe4LHlKPNGAInnYqxFsbN5ZTYy6l/GPxHXozXvHqBQ+kSelvTBNthfKIoRLUElXfwBZCiicAS4j8Kh7Xlb46qOEZy+OT+OvfHyaSQxL+qI7R1a6nvxQTw6OaxNuKg6xAhB1WWSIBphuWfzD3xlzDJQzPltnbXkT4mUHt0wczzTecdOy4+eaiP7sc7msrH/WW0Z8P9Y6AHdAalJo/mKL9NufGlO/0XTnDYmd2HlybLAczhsK+j+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iTK0rw6/TyJv2+ihI9Aw/f1x/BS+vQNhqWpeJCpL33o=;
 b=IxbvP8u15dA/6pU110L7dI6CNx7z2PMpvjBUmHSAm5CJbDx5/kdxV7BpsAsoZu6VIDYH9w36QkQx6iC8sT+TzcKeIWUBqPEJcJJJUiQ5ygq8fmpQAcOIkPmfnOBI4002hdCRv5XC4jM8IvkyIMyC7USruXtYKa2vLY+R+0Q8aZXcYiIW93D1qOTF4KKT3ybYKXX19+Tn4d9EZ+cglU4AtuKWmR/g3r/8lRvXNNtvXkvQ8UxRyhXuCSoc6LWoETu8TxHWD4uD01ZlrHQMucraD5ml4ae28SwJijCAiKNmpfuYLauQs4EDg8q5q2kaq/Z2zQgoFgR0a2qQLgg8+5SdGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iTK0rw6/TyJv2+ihI9Aw/f1x/BS+vQNhqWpeJCpL33o=;
 b=ElbSwY9ZTosd181GGa4xCerGJsqK6asfMLzqzz+9eFGnyZY3E6y/14Z/w2PVzvQHpoac+SUtF5BBs8pnflSR5X9lQMY+SJN1ULlNCz6fNanciMJ59wPYcAOLKZz81cvErPZYlZqgbrVuqNdIGtJwyPQ0E+AMDjjZ2DueqPn9DzC4KSGijlnMy/4ls7D209UkAeOo3gmWf8VNPAoyOLXUmxd9uSPCNZ5q03AtkrHDlij0XiTqFphxhmeE1Ay4K038B+LjhGJYoILr2PPikJ8JNinlwKp/gVbArAdoxLgC0bhq7vhgqHvfbA8pX/Kp0QiZOeFU0cXL9zz2ar/E2dQ9yw==
Received: from BN1PR13CA0025.namprd13.prod.outlook.com (2603:10b6:408:e2::30)
 by IA1PR12MB6556.namprd12.prod.outlook.com (2603:10b6:208:3a0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Wed, 30 Nov
 2022 11:53:00 +0000
Received: from BN8NAM11FT106.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e2:cafe::c0) by BN1PR13CA0025.outlook.office365.com
 (2603:10b6:408:e2::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8 via Frontend
 Transport; Wed, 30 Nov 2022 11:53:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT106.mail.protection.outlook.com (10.13.177.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.22 via Frontend Transport; Wed, 30 Nov 2022 11:53:00 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 30 Nov
 2022 03:52:49 -0800
Received: from nps-server-23.mtl.labs.mlnx (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Wed, 30 Nov 2022 03:52:45 -0800
From:   Shay Drory <shayd@nvidia.com>
To:     <netdev@vger.kernel.org>, <kuba@kernel.org>, <davem@davemloft.net>
CC:     <danielj@nvidia.com>, <yishaih@nvidia.com>, <jiri@nvidia.com>,
        <saeedm@nvidia.com>, <parav@nvidia.com>
Subject: [PATCH net-next 4/8] devlink: Expose port function commands to control RoCE
Date:   Wed, 30 Nov 2022 13:52:13 +0200
Message-ID: <20221130115217.7171-5-shayd@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130115217.7171-1-shayd@nvidia.com>
References: <20221130115217.7171-1-shayd@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT106:EE_|IA1PR12MB6556:EE_
X-MS-Office365-Filtering-Correlation-Id: c3614b9c-354a-441d-f060-08dad2c96e1b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T9vUxto5JJ6cOoplSYMMWTnLi5RA93misNXWkjSfeXzIykxb3/v0hQnqxfNxOltGn00WWi0Qv6XusEsTCy2pux7OBeEsypzH4rdJ18ApgKPWOfMGsHVDUz/lmPnQeP2LTxrL7v8bUaXWdLn05UIMVES4+mAZ4lG1hasO6UV+s/R8xAtqTgNGinwoSHJX0TQSuqEMq4v3Qm7jpLeGuMzg+EjoXwBEggrIg+Lrn5W8QM48CVFBaiwW7FIhgTo9beHjGvshgPWohJgWYNOSo1BbcBJSYx80Ko1XlMGvTKaryiRQ4hGjhF2wM+hMJW1ekPsemMhI1wiBvwL4t2bPOqnaBuhh+2MTavsp0dL5HZMLt5V3sQ41zBc31mddGidmvOmIw5k8D4RThdSnifViumd/WW9UUBl9DR6cTDJz0sFkp1DvRuu365i3gQOXc2Bo3gzBeaauFkaCOcXHFQSUJhMRuEicQAwFIRYk/LFMm6FHuy48iq0DUj3NDWL5TLO1pu5egswJif6p9IfbTtxYH+60G+QSRNg/KxzG5oBJIJA4RQtruS6b5QW1m6PTTfYRNQ0F3fC04HMdzZHJOUuoXJZvWOoapYa3hqLkSwf+x6D+RUPOSVRs3Wwx7QQ0iI22TVrWANSdX4FJWcTPvvgEiuDsX9iP5lkQ7hC7DSsPSB+gXKJRdILXgdpjbGuR5MS5so8tLwGk1NAuc06hPh9Uo4UEkg==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(376002)(396003)(136003)(451199015)(46966006)(40470700004)(36840700001)(107886003)(336012)(2906002)(426003)(26005)(6666004)(478600001)(40460700003)(1076003)(82740400003)(86362001)(40480700001)(7636003)(356005)(83380400001)(186003)(16526019)(47076005)(2616005)(36756003)(36860700001)(82310400005)(41300700001)(8936002)(8676002)(70586007)(4326008)(5660300002)(110136005)(70206006)(54906003)(316002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2022 11:53:00.1899
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c3614b9c-354a-441d-f060-08dad2c96e1b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT106.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6556
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
index 074a79b8933f..7f75100e8b26 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1435,6 +1435,25 @@ struct devlink_ops {
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
index 498d0d5d0957..c6f1fbe54095 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -656,11 +656,23 @@ enum devlink_resource_unit {
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
index 485348697290..88846ad635a0 100644
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

