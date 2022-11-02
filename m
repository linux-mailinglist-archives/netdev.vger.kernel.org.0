Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20083616984
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 17:44:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232051AbiKBQoz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 12:44:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231220AbiKBQog (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 12:44:36 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2061e.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e83::61e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D39EF5C
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 09:40:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mdV4K1IJhWsfbSca4494e7/zqL2rBLXMueUT67OKjTVD3PhxfW7lCFQohORyhAP8xW3Hif0IwuKEItBDil9ZZS4YT9VhYpfHsab/VIbeo5eswkOaljV7wwuDtPHK8dlxaE/xBuThUDvePQzsYgMqZZkAoRL0TCGR0cTBtWlp/PqXPX81UWqKKDNceaRy/y52k7g9mUxd4vtZtSxclpZIj08flSMHc//5iyOOtp6csDdJmCNvnw9d5VDcEokpFxlR3NHpcesvpquVN9Cg8izcmK0RYomqP1YToGGgK0HMEG74x84gvaCSfeUluzRK7KSVxKMt6Ilj+ACeilySaPcubQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FngUOfutiv9mSDrAOTtTQQtbPXNBwLLB/sQKdVbwdqE=;
 b=MoOXZUMRGTuSeYZ0BEZLXfSc75gM2xZCSChv+22BcBoJAq9vdgZAbYLAOowy5Aj3v2w50nPU1VwK0EnVB1yG69i+Um3mmjGeuG8jjPUPxCkY8ZhyvyyCDGqfLxzMtG/iHfc3tewm4cwrSuObqRT5jju0o1ZXiSOpdfCwRpE3JaZUIT4cU4tInY9yzHhb0WoscufSR/5x60nmEHXcOZ1zasnQb2iUlvf774K/Db4v1y9Z4pMd++XVhr863DySmlTelm83w9oHHl2pV6tmkww4bDbp3Of3IMprDhMJ1456y95pohYEEdm+f+UNU5NYtYKl6pwy+qg/4aLnwVlFoAFi9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FngUOfutiv9mSDrAOTtTQQtbPXNBwLLB/sQKdVbwdqE=;
 b=MrxdHmRfz62i/CLbe3O4TQ55y8cxqgQBC0LYcXyP4KLhnPPd3Kj4BPzkLwTBGWM+yadKL+x47XRUqOTpgjC2dPLJ+QT35DEtchCnyfvXOzZVK7N0sx67KtPEPL+QbkJOLd+OndB1kIRDho/dGJtSg3QEWW0t9MRovNOwA5ZSfWvd7Eiqq1e1O3y5+1muZv0nJupLSTBPUrt+rqlotSz6s4pNdeYtrNeDZFZzXrGcDr0c0x++ruAcisuD3RiDIS6al7uIzmnoxepeox6S+8d4PMCBu0OJPLCqli+c4tUMecnSDDQkzFEWIo7MMlAOtTPH7kAOi3VObuPJMXEg3edjmg==
Received: from BN0PR03CA0014.namprd03.prod.outlook.com (2603:10b6:408:e6::19)
 by CH0PR12MB5027.namprd12.prod.outlook.com (2603:10b6:610:e2::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.21; Wed, 2 Nov
 2022 16:40:29 +0000
Received: from BN8NAM11FT027.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e6:cafe::6c) by BN0PR03CA0014.outlook.office365.com
 (2603:10b6:408:e6::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.20 via Frontend
 Transport; Wed, 2 Nov 2022 16:40:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT027.mail.protection.outlook.com (10.13.177.96) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.20 via Frontend Transport; Wed, 2 Nov 2022 16:40:28 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Wed, 2 Nov 2022
 09:40:13 -0700
Received: from sw-mtx-036.mtx.labs.mlnx (10.126.230.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Wed, 2 Nov 2022 09:40:11 -0700
From:   Daniel Jurgens <danielj@nvidia.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <parav@nvidia.com>, <saeedm@nvidia.com>, <yishaih@nvidia.com>,
        "Daniel Jurgens" <danielj@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH 1/2] devlink: Expose port function commands to control roce
Date:   Wed, 2 Nov 2022 18:39:53 +0200
Message-ID: <20221102163954.279266-2-danielj@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20221102163954.279266-1-danielj@nvidia.com>
References: <20221102163954.279266-1-danielj@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT027:EE_|CH0PR12MB5027:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c48ee08-e9eb-469e-1a2c-08dabcf0f36d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dgsHk0CVDA9aIbUaYm2J4Oe/bFTVfVBLcsULeWFXxYJ9/5GABEaUXe6jgvl4AJn9uieR9A7Cam4rsVqNgyQ4SWbrhUoY4PEXwr5WCGwo9JOQVayX3D5D6uPBxGlJY9/9Gf/mqsCz8GMSia6kKK9hj2lpX3Nz0rqTL7D28DpsAQF3PQtTO9qmU3GJAMK2SpTeDkr1tpTDd6PEKTf5aI6YFGW9jAeM9Q6vDxJOjnwanMzqW3RQiDK2gPeX64j4DGE8uaXivfdmZ3RQnHqtIjYIVq3TTMs2vfKPo6xUDlt/H0YWXlYsj0mws7Y0amHGfaYiWGpN+nFqK+ytzTFFREw5SKB13BWxaUaymtkfTr+LDU8eEuGSEMzcwBJ2slnDhOa1gn311PpUaAw78CukRJON4XqV+BoFWWto1ItEhGCxPEbz+OLpvuvvxxo17P1SZYxxFe6D31ALQtYYszCuS5d3yaHHTTEbtcCldBOseiDd4ujBazX4xIWj4Z+Ph+JCqNqpH3O5CYQRoddheAWArQa2ZzLrMExPxCuO7tQMMjh7unD2a9Pshs40eAElkCqwV5VAy8kgx52SD/JwwB8IYKJ67o38VraOphzPc0emR3wUBLu7sEi9twUxkeofjVm6M9mWQlsG2KwZPfFROYJ29ogzX8pHv2l9CwmtPbrupQF30PptNbOI3uhVHEIw63DtHGmRizQvbt5l1su5vjldbwGZqEFac8Xl6wOuUxVHtgGLclTGiwNoqLquV5JeAtNuchtDiVQNtZjY74ztO3SOLteTTA==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(136003)(376002)(39860400002)(451199015)(46966006)(36840700001)(40470700004)(82740400003)(36756003)(40460700003)(7636003)(36860700001)(110136005)(70206006)(70586007)(40480700001)(54906003)(8676002)(4326008)(356005)(8936002)(1076003)(186003)(41300700001)(5660300002)(2616005)(426003)(2906002)(336012)(83380400001)(86362001)(107886003)(47076005)(316002)(478600001)(82310400005)(26005)(6666004)(16526019);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2022 16:40:28.6501
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c48ee08-e9eb-469e-1a2c-08dabcf0f36d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT027.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5027
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yishai Hadas <yishaih@nvidia.com>

Expose port function commands to turn on / off roce, this is used to
control the port roce device capabilities.

When roce is disabled for a function of the port, function cannot create
any roce specific resources (e.g GID table).
It also saves system memory utilization. For example disabling roce on a
VF/SF saves 1 Mbytes of system memory per function.

Example of a PCI VF port which supports function configuration:
Set roce of the VF's port function.

$ devlink port show pci/0000:06:00.0/2
pci/0000:06:00.0/2: type eth netdev enp6s0pf0vf1 flavour pcivf pfnum 0 vfnum 1
    function:
        hw_addr 00:00:00:00:00:00 roce on

$ devlink port function set pci/0000:06:00.0/2 roce off

$ devlink port show pci/0000:06:00.0/2
pci/0000:06:00.0/2: type eth netdev enp6s0pf0vf1 flavour pcivf pfnum 0 vfnum 1
    function:
        hw_addr 00:11:22:33:44:55 roce off

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Daniel Jurgens <danielj@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../networking/devlink/devlink-port.rst       |  5 +-
 include/net/devlink.h                         | 20 ++++++
 include/uapi/linux/devlink.h                  |  1 +
 net/core/devlink.c                            | 61 +++++++++++++++++++
 4 files changed, 86 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/devlink/devlink-port.rst b/Documentation/networking/devlink/devlink-port.rst
index 7627b1da01f2..fd191622ab68 100644
--- a/Documentation/networking/devlink/devlink-port.rst
+++ b/Documentation/networking/devlink/devlink-port.rst
@@ -110,7 +110,7 @@ devlink ports for both the controllers.
 Function configuration
 ======================
 
-A user can configure the function attribute before enumerating the PCI
+A user can configure one or more function attributes before enumerating the PCI
 function. Usually it means, user should configure function attribute
 before a bus specific device for the function is created. However, when
 SRIOV is enabled, virtual function devices are created on the PCI bus.
@@ -122,6 +122,9 @@ A user may set the hardware address of the function using
 'devlink port function set hw_addr' command. For Ethernet port function
 this means a MAC address.
 
+A user may set also the roce capability of the function using
+'devlink port function set roce' command.
+
 Subfunction
 ============
 
diff --git a/include/net/devlink.h b/include/net/devlink.h
index ba6b8b094943..c26edd5c72fa 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1414,6 +1414,26 @@ struct devlink_ops {
 	int (*port_function_hw_addr_set)(struct devlink_port *port,
 					 const u8 *hw_addr, int hw_addr_len,
 					 struct netlink_ext_ack *extack);
+	/**
+	 * @port_function_roce_get: Port function's roce get function.
+	 *
+	 * Should be used by device drivers to report the roce state of
+	 * a function managed by the devlink port. Driver should return
+	 * -EOPNOTSUPP if it doesn't support port function handling for
+	 * a particular port.
+	 */
+	int (*port_function_roce_get)(struct devlink_port *port, bool *on,
+				      struct netlink_ext_ack *extack);
+	/**
+	 * @port_function_roce_set: Port function's roce set function.
+	 *
+	 * Should be used by device drivers to enable/disable the roce state of
+	 * a function managed by the devlink port. Driver should return
+	 * -EOPNOTSUPP if it doesn't support port function handling for
+	 * a particular port.
+	 */
+	int (*port_function_roce_set)(struct devlink_port *port, bool on,
+				      struct netlink_ext_ack *extack);
 	/**
 	 * port_new() - Add a new port function of a specified flavor
 	 * @devlink: Devlink instance
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 2f24b53a87a5..16efff56fc0d 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -658,6 +658,7 @@ enum devlink_port_function_attr {
 	DEVLINK_PORT_FUNCTION_ATTR_HW_ADDR,	/* binary */
 	DEVLINK_PORT_FN_ATTR_STATE,	/* u8 */
 	DEVLINK_PORT_FN_ATTR_OPSTATE,	/* u8 */
+	DEVLINK_PORT_FN_ATTR_ROCE,	/* u8 */
 
 	__DEVLINK_PORT_FUNCTION_ATTR_MAX,
 	DEVLINK_PORT_FUNCTION_ATTR_MAX = __DEVLINK_PORT_FUNCTION_ATTR_MAX - 1
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 89baa7c0938b..4f9d81888699 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -199,6 +199,7 @@ static const struct nla_policy devlink_function_nl_policy[DEVLINK_PORT_FUNCTION_
 	[DEVLINK_PORT_FN_ATTR_STATE] =
 		NLA_POLICY_RANGE(NLA_U8, DEVLINK_PORT_FN_STATE_INACTIVE,
 				 DEVLINK_PORT_FN_STATE_ACTIVE),
+	[DEVLINK_PORT_FN_ATTR_ROCE] = NLA_POLICY_RANGE(NLA_U8, 0, 1),
 };
 
 static const struct nla_policy devlink_selftest_nl_policy[DEVLINK_ATTR_SELFTEST_ID_MAX + 1] = {
@@ -691,6 +692,33 @@ devlink_sb_tc_index_get_from_attrs(struct devlink_sb *devlink_sb,
 	return 0;
 }
 
+static int devlink_port_function_roce_fill(const struct devlink_ops *ops,
+					   struct devlink_port *port,
+					   struct sk_buff *msg,
+					   struct netlink_ext_ack *extack,
+					   bool *msg_updated)
+{
+	bool on;
+	int err;
+
+	if (!ops->port_function_roce_get)
+		return 0;
+
+	err = ops->port_function_roce_get(port, &on, extack);
+	if (err) {
+		if (err == -EOPNOTSUPP)
+			return 0;
+		return err;
+	}
+
+	err = nla_put_u8(msg, DEVLINK_PORT_FN_ATTR_ROCE, on);
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
@@ -1248,6 +1276,25 @@ static int devlink_port_fn_state_fill(const struct devlink_ops *ops,
 	return 0;
 }
 
+static int
+devlink_port_fn_roce_set(struct devlink_port *port,
+			 const struct nlattr *attr,
+			 struct netlink_ext_ack *extack)
+{
+	const struct devlink_ops *ops = port->devlink->ops;
+	bool on;
+
+	on = nla_get_u8(attr);
+
+	if (!ops->port_function_roce_set) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Port doesn't support roce function attribute");
+		return -EOPNOTSUPP;
+	}
+
+	return ops->port_function_roce_set(port, on, extack);
+}
+
 static int
 devlink_nl_port_function_attrs_put(struct sk_buff *msg, struct devlink_port *port,
 				   struct netlink_ext_ack *extack)
@@ -1266,6 +1313,12 @@ devlink_nl_port_function_attrs_put(struct sk_buff *msg, struct devlink_port *por
 					   &msg_updated);
 	if (err)
 		goto out;
+
+	err = devlink_port_function_roce_fill(ops, port, msg, extack,
+					      &msg_updated);
+	if (err)
+		goto out;
+
 	err = devlink_port_fn_state_fill(ops, port, msg, extack, &msg_updated);
 out:
 	if (err || !msg_updated)
@@ -1670,6 +1723,14 @@ static int devlink_port_function_set(struct devlink_port *port,
 		if (err)
 			return err;
 	}
+
+	attr = tb[DEVLINK_PORT_FN_ATTR_ROCE];
+	if (attr) {
+		err = devlink_port_fn_roce_set(port, attr, extack);
+		if (err)
+			return err;
+	}
+
 	/* Keep this as the last function attribute set, so that when
 	 * multiple port function attributes are set along with state,
 	 * Those can be applied first before activating the state.
-- 
2.27.0

