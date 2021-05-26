Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C92003916FE
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 14:03:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233983AbhEZMEa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 08:04:30 -0400
Received: from mail-bn8nam12on2046.outbound.protection.outlook.com ([40.107.237.46]:9825
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233092AbhEZMD1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 08:03:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WTYQGfCxOyo2qpL8sefyp7HRR25aY785EqBX/19ZJzaBAQh2fK6hGBrnp2Ny8P/Ef18dE1s7CBMu4ApOyHlCfKFA7iPT47R+RMQ8OEpR0Vjs5aJHJTdpbDP10w5/yCB/6BdX0Qxe2fGiSgz8Ipv8r9tq6I1b/RHw4Bvj8SmPc4eS1ErDZsm3jOa0ww1f5oFx84ZfSFTsbM6Qte+yziMBzOxjtlmR8VlTT8BK0pZ+NowHIZaij8loylo0f13VIM5ZCATU4pRlNgEnI/Y8eLtSk7e+gTc/+JsitWvzl602epEx7WNINYQnKg2ifzL3JeB179kB1FWVC0ois9I7McB5ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8GZVow037A9RI/Vs6/gtHQGW9Dr2Q9gdKBHu21DPjtg=;
 b=hp6gO68i/X5h7YUGlKNzP6mXM8uUf1mapDKUTINzH3rhKxwK7YH43WKfkzFEzOy5nN1nWMpNBcyQRMzqBCYviK5qjdPOYB0U4JTi/h7Kb5k+OSmbMIfvclIHlqXEd2BVBlP1qq5pX/Nv288IOBLKYNb7BHCU37oXDI3pCrv8KrcUVtnMc1Xbw3USiQi71El8r52VY/jkeEPGJk7VadcK4ZImMlSfuUrZ+kuc94LqDmRUz38VppXGnOmsyv+3NQKYlnnpkWGMjsQUUhc6mKQyiFat7bcPFLwxPhV/of8F07Agv5wPEUxpUNALRSYa6V7dHwAhFxjm6iWIdjYr8o1Hrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8GZVow037A9RI/Vs6/gtHQGW9Dr2Q9gdKBHu21DPjtg=;
 b=U7lc9uxoNXb8xZ51tZwrigP+U0d3JQP/VcrcDuuAuDnLeg1zI2eXLnlblDNwMjOah6vpTneVkc60B2FEtUNQoMInTGV5xy2hnf2WoV5Xm165RAu62eYO25SHD3WHqHTwD71pjTmrU1HXeIs1wmndSZHhzuuYKVe+gqicfvPJGnSp3+xxAOlL5KkzeEADIcVeW520tgoMhR6iAfaA8S5D1OsO6PBplHm4VQthX79gGdvomrjrenw8e24++EStuo+90Om9rxX75aODgy2wvtTcy917raEAODjQ6JptDkkePne9+BbJa0xfy9L66NyNG6mdvx6GP5UdcmhqLzjOOwX3ng==
Received: from DM6PR05CA0058.namprd05.prod.outlook.com (2603:10b6:5:335::27)
 by BL0PR12MB2418.namprd12.prod.outlook.com (2603:10b6:207:4d::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27; Wed, 26 May
 2021 12:01:54 +0000
Received: from DM6NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:335:cafe::48) by DM6PR05CA0058.outlook.office365.com
 (2603:10b6:5:335::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.12 via Frontend
 Transport; Wed, 26 May 2021 12:01:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT010.mail.protection.outlook.com (10.13.172.222) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Wed, 26 May 2021 12:01:54 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 26 May
 2021 12:01:49 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 26 May 2021 12:01:46 +0000
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <stephen@networkplumber.org>, <dsahern@gmail.com>,
        <vladbu@nvidia.com>, <parav@nvidia.com>, <huyn@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>
Subject: [PATCH RFC net-next v3 12/18] devlink: Introduce rate nodes
Date:   Wed, 26 May 2021 15:01:04 +0300
Message-ID: <1622030470-21434-13-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1622030470-21434-1-git-send-email-dlinkin@nvidia.com>
References: <1622030470-21434-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0967e30c-72e3-4058-fd0b-08d9203e0e11
X-MS-TrafficTypeDiagnostic: BL0PR12MB2418:
X-Microsoft-Antispam-PRVS: <BL0PR12MB2418AEE4EE2CD197EE0848E3CB249@BL0PR12MB2418.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:62;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iFG+VmWcSyHyMdsyyglqpkcygVuQbOI4jUMYjLMGkhoxeaugmWF2kp/a8115c0AHd7bzLeRWxjEPOaIx1VYuMidne6AHoAINs+rfwFZj/B85RSEkoSyjRsws31lBuQ03dgbUC1djwYDBF3gF+fGASMfhcLOv0ij989Co0alIvogH/IvtqvV5cpMrU/gSZ/7q8spvOPOSxu8wN2nrPZTmJ6qDE5xDKeVU9N16JEAYg30rguLBBQuAg5Kke7H45ANxpiXb0NbAjmf0FFYdG+s3u/wze4ICedXgC5q61LrM0PZrlhgvSDMcb8vEkkSxyvCggwSpfsTDWMBXr59fxgx0ohOr5vQ2NNm4zWsN4EFdGaFXrFdR9TRo1eZlMgxUYHMfPf27euy5MKGA7etPGZBcaWR6ztARyG5D7qwviXLhjo8oBwaA3frXqzaT3sGwmxLWIEFNOXbEgATjP2dv02SAyqqmEsYfhGqspx+ARJzJcxfk9AE+fgCoD2+TwzVl6+lFBoR6RY3hvmCRDPk+L1+mlZIcMiwr95u9fXyC0MoutQJQy9wzT2dGIcGAhGIluCXv1lspdHA1rLgObzdOcMJJXzBB4d8xLLzH4uJ6qE7DHbTrePYypHnOkCNL42vqECkeW3H3spwOQXiycGI60fpmLQdUNWzukkinxndDLVyza3U=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(136003)(396003)(376002)(346002)(46966006)(36840700001)(36906005)(356005)(82740400003)(426003)(86362001)(70206006)(7696005)(2876002)(336012)(316002)(186003)(26005)(54906003)(7636003)(30864003)(2616005)(5660300002)(6916009)(36756003)(70586007)(8936002)(6666004)(82310400003)(36860700001)(2906002)(47076005)(83380400001)(478600001)(8676002)(107886003)(4326008);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2021 12:01:54.4327
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0967e30c-72e3-4058-fd0b-08d9203e0e11
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2418
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmytro Linkin <dlinkin@nvidia.com>

Implement support for DEVLINK_CMD_RATE_{NEW|DEL} commands that are used
to create and delete devlink rate nodes. Add new attribute
DEVLINK_ATTR_RATE_NODE_NAME that specify node name string. The node name
is an alphanumeric identifier. No valid node name can be a devlink port
index, eg. decimal number. Extend devlink ops with new callbacks
rate_node_{new|del}() and rate_node_tx_{share|max}_set() to allow
supporting drivers to implement ports rate grouping and setting tx rate
of rate nodes through devlink.
Expose devlink_rate_nodes_destroy() function to allow vendor driver do
proper cleanup of internally allocated resources for the nodes if the
driver goes down or due to any other reasons which requires nodes to be
destroyed.
Disallow moving device from switchdev to legacy mode if any node exists
on that device. User must explicitly delete nodes before switching mode.

Example:

$ devlink port function rate add netdevsim/netdevsim10/group1

$ devlink port function rate set netdevsim/netdevsim10/group1 \
        tx_share 10mbit tx_max 100mbit

Add + set command can be combined:

$ devlink port function rate add netdevsim/netdevsim10/group1 \
        tx_share 10mbit tx_max 100mbit

$ devlink port function rate show netdevsim/netdevsim10/group1
netdevsim/netdevsim10/group1: type node tx_share 10mbit tx_max 100mbit

$ devlink port function rate del netdevsim/netdevsim10/group1

Co-developed-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Dmytro Linkin <dlinkin@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---

Notes:
    v1->v2:
    - s/func/function/ at commit message

    v2->v3:
    - added devlink_rate_nodes_destroy()

 include/net/devlink.h        |  14 ++-
 include/uapi/linux/devlink.h |   3 +
 net/core/devlink.c           | 238 +++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 247 insertions(+), 8 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 46d5535..13162b5 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -142,7 +142,10 @@ struct devlink_rate {
 	u64 tx_share;
 	u64 tx_max;
 
-	struct devlink_port *devlink_port;
+	union {
+		struct devlink_port *devlink_port;
+		char *name;
+	};
 };
 
 struct devlink_port {
@@ -1475,6 +1478,14 @@ struct devlink_ops {
 				      u64 tx_share, struct netlink_ext_ack *extack);
 	int (*rate_leaf_tx_max_set)(struct devlink_rate *devlink_rate, void *priv,
 				    u64 tx_max, struct netlink_ext_ack *extack);
+	int (*rate_node_tx_share_set)(struct devlink_rate *devlink_rate, void *priv,
+				      u64 tx_share, struct netlink_ext_ack *extack);
+	int (*rate_node_tx_max_set)(struct devlink_rate *devlink_rate, void *priv,
+				    u64 tx_max, struct netlink_ext_ack *extack);
+	int (*rate_node_new)(struct devlink_rate *rate_node, void **priv,
+			     struct netlink_ext_ack *extack);
+	int (*rate_node_del)(struct devlink_rate *rate_node, void *priv,
+			     struct netlink_ext_ack *extack);
 };
 
 static inline void *devlink_priv(struct devlink *devlink)
@@ -1536,6 +1547,7 @@ void devlink_port_attrs_pci_sf_set(struct devlink_port *devlink_port,
 				   bool external);
 int devlink_rate_leaf_create(struct devlink_port *port, void *priv);
 void devlink_rate_leaf_destroy(struct devlink_port *devlink_port);
+void devlink_rate_nodes_destroy(struct devlink *devlink);
 int devlink_sb_register(struct devlink *devlink, unsigned int sb_index,
 			u32 size, u16 ingress_pools_count,
 			u16 egress_pools_count, u16 ingress_tc_count,
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index ae94cd2..7e15853 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -213,6 +213,7 @@ enum devlink_port_flavour {
 
 enum devlink_rate_type {
 	DEVLINK_RATE_TYPE_LEAF,
+	DEVLINK_RATE_TYPE_NODE,
 };
 
 enum devlink_param_cmode {
@@ -547,6 +548,8 @@ enum devlink_attr {
 	DEVLINK_ATTR_RATE_TYPE,			/* u16 */
 	DEVLINK_ATTR_RATE_TX_SHARE,		/* u64 */
 	DEVLINK_ATTR_RATE_TX_MAX,		/* u64 */
+	DEVLINK_ATTR_RATE_NODE_NAME,		/* string */
+
 	/* add new attributes above here, update the policy in devlink.c */
 
 	__DEVLINK_ATTR_MAX,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index eea1f88..d520fb5 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -196,6 +196,12 @@ static struct devlink_port *devlink_port_get_from_info(struct devlink *devlink,
 	return devlink_rate->type == DEVLINK_RATE_TYPE_LEAF;
 }
 
+static inline bool
+devlink_rate_is_node(struct devlink_rate *devlink_rate)
+{
+	return devlink_rate->type == DEVLINK_RATE_TYPE_NODE;
+}
+
 static struct devlink_rate *
 devlink_rate_leaf_get_from_info(struct devlink *devlink, struct genl_info *info)
 {
@@ -209,6 +215,55 @@ static struct devlink_port *devlink_port_get_from_info(struct devlink *devlink,
 	return devlink_rate ?: ERR_PTR(-ENODEV);
 }
 
+static struct devlink_rate *
+devlink_rate_node_get_by_name(struct devlink *devlink, const char *node_name)
+{
+	static struct devlink_rate *devlink_rate;
+
+	list_for_each_entry(devlink_rate, &devlink->rate_list, list) {
+		if (devlink_rate_is_node(devlink_rate) &&
+		    !strcmp(node_name, devlink_rate->name))
+			return devlink_rate;
+	}
+	return ERR_PTR(-ENODEV);
+}
+
+static struct devlink_rate *
+devlink_rate_node_get_from_attrs(struct devlink *devlink, struct nlattr **attrs)
+{
+	const char *rate_node_name;
+	size_t len;
+
+	if (!attrs[DEVLINK_ATTR_RATE_NODE_NAME])
+		return ERR_PTR(-EINVAL);
+	rate_node_name = nla_data(attrs[DEVLINK_ATTR_RATE_NODE_NAME]);
+	len = strlen(rate_node_name);
+	/* Name cannot be empty or decimal number */
+	if (!len || strspn(rate_node_name, "0123456789") == len)
+		return ERR_PTR(-EINVAL);
+
+	return devlink_rate_node_get_by_name(devlink, rate_node_name);
+}
+
+static struct devlink_rate *
+devlink_rate_node_get_from_info(struct devlink *devlink, struct genl_info *info)
+{
+	return devlink_rate_node_get_from_attrs(devlink, info->attrs);
+}
+
+static struct devlink_rate *
+devlink_rate_get_from_info(struct devlink *devlink, struct genl_info *info)
+{
+	struct nlattr **attrs = info->attrs;
+
+	if (attrs[DEVLINK_ATTR_PORT_INDEX])
+		return devlink_rate_leaf_get_from_info(devlink, info);
+	else if (attrs[DEVLINK_ATTR_RATE_NODE_NAME])
+		return devlink_rate_node_get_from_info(devlink, info);
+	else
+		return ERR_PTR(-EINVAL);
+}
+
 struct devlink_sb {
 	struct list_head list;
 	unsigned int index;
@@ -428,12 +483,13 @@ struct devlink_snapshot {
 #define DEVLINK_NL_FLAG_NEED_PORT		BIT(0)
 #define DEVLINK_NL_FLAG_NEED_DEVLINK_OR_PORT	BIT(1)
 #define DEVLINK_NL_FLAG_NEED_RATE		BIT(2)
+#define DEVLINK_NL_FLAG_NEED_RATE_NODE		BIT(3)
 
 /* The per devlink instance lock is taken by default in the pre-doit
  * operation, yet several commands do not require this. The global
  * devlink lock is taken and protects from disruption by user-calls.
  */
-#define DEVLINK_NL_FLAG_NO_LOCK			BIT(3)
+#define DEVLINK_NL_FLAG_NO_LOCK			BIT(4)
 
 static int devlink_nl_pre_doit(const struct genl_ops *ops,
 			       struct sk_buff *skb, struct genl_info *info)
@@ -465,12 +521,21 @@ static int devlink_nl_pre_doit(const struct genl_ops *ops,
 	} else if (ops->internal_flags & DEVLINK_NL_FLAG_NEED_RATE) {
 		struct devlink_rate *devlink_rate;
 
-		devlink_rate = devlink_rate_leaf_get_from_info(devlink, info);
+		devlink_rate = devlink_rate_get_from_info(devlink, info);
 		if (IS_ERR(devlink_rate)) {
 			err = PTR_ERR(devlink_rate);
 			goto unlock;
 		}
 		info->user_ptr[1] = devlink_rate;
+	} else if (ops->internal_flags & DEVLINK_NL_FLAG_NEED_RATE_NODE) {
+		struct devlink_rate *rate_node;
+
+		rate_node = devlink_rate_node_get_from_info(devlink, info);
+		if (IS_ERR(rate_node)) {
+			err = PTR_ERR(rate_node);
+			goto unlock;
+		}
+		info->user_ptr[1] = rate_node;
 	}
 	return 0;
 
@@ -801,6 +866,10 @@ static int devlink_nl_rate_fill(struct sk_buff *msg,
 		if (nla_put_u32(msg, DEVLINK_ATTR_PORT_INDEX,
 				devlink_rate->devlink_port->index))
 			goto nla_put_failure;
+	} else if (devlink_rate_is_node(devlink_rate)) {
+		if (nla_put_string(msg, DEVLINK_ATTR_RATE_NODE_NAME,
+				   devlink_rate->name))
+			goto nla_put_failure;
 	}
 
 	if (nla_put_u64_64bit(msg, DEVLINK_ATTR_RATE_TX_SHARE,
@@ -1508,13 +1577,17 @@ static int devlink_nl_rate_set(struct devlink_rate *devlink_rate,
 			       struct genl_info *info)
 {
 	struct nlattr **attrs = info->attrs;
+	int err = -EOPNOTSUPP;
 	u64 rate;
-	int err;
 
 	if (attrs[DEVLINK_ATTR_RATE_TX_SHARE]) {
 		rate = nla_get_u64(attrs[DEVLINK_ATTR_RATE_TX_SHARE]);
-		err = ops->rate_leaf_tx_share_set(devlink_rate, devlink_rate->priv,
-						  rate, info->extack);
+		if (devlink_rate_is_leaf(devlink_rate))
+			err = ops->rate_leaf_tx_share_set(devlink_rate, devlink_rate->priv,
+							  rate, info->extack);
+		else if (devlink_rate_is_node(devlink_rate))
+			err = ops->rate_node_tx_share_set(devlink_rate, devlink_rate->priv,
+							  rate, info->extack);
 		if (err)
 			return err;
 		devlink_rate->tx_share = rate;
@@ -1522,8 +1595,12 @@ static int devlink_nl_rate_set(struct devlink_rate *devlink_rate,
 
 	if (attrs[DEVLINK_ATTR_RATE_TX_MAX]) {
 		rate = nla_get_u64(attrs[DEVLINK_ATTR_RATE_TX_MAX]);
-		err = ops->rate_leaf_tx_max_set(devlink_rate, devlink_rate->priv,
-						rate, info->extack);
+		if (devlink_rate_is_leaf(devlink_rate))
+			err = ops->rate_leaf_tx_max_set(devlink_rate, devlink_rate->priv,
+							rate, info->extack);
+		else if (devlink_rate_is_node(devlink_rate))
+			err = ops->rate_node_tx_max_set(devlink_rate, devlink_rate->priv,
+							rate, info->extack);
 		if (err)
 			return err;
 		devlink_rate->tx_max = rate;
@@ -1547,6 +1624,15 @@ static bool devlink_rate_set_ops_supported(const struct devlink_ops *ops,
 			NL_SET_ERR_MSG_MOD(info->extack, "TX max set isn't supported for the leafs");
 			return false;
 		}
+	} else if (type == DEVLINK_RATE_TYPE_NODE) {
+		if (attrs[DEVLINK_ATTR_RATE_TX_SHARE] && !ops->rate_node_tx_share_set) {
+			NL_SET_ERR_MSG_MOD(info->extack, "TX share set isn't supported for the nodes");
+			return false;
+		}
+		if (attrs[DEVLINK_ATTR_RATE_TX_MAX] && !ops->rate_node_tx_max_set) {
+			NL_SET_ERR_MSG_MOD(info->extack, "TX max set isn't supported for the nodes");
+			return false;
+		}
 	} else {
 		WARN_ON("Unknown type of rate object");
 		return false;
@@ -1573,6 +1659,78 @@ static int devlink_nl_cmd_rate_set_doit(struct sk_buff *skb,
 	return err;
 }
 
+static int devlink_nl_cmd_rate_new_doit(struct sk_buff *skb,
+					struct genl_info *info)
+{
+	struct devlink *devlink = info->user_ptr[0];
+	struct devlink_rate *rate_node;
+	const struct devlink_ops *ops;
+	int err;
+
+	ops = devlink->ops;
+	if (!ops || !ops->rate_node_new || !ops->rate_node_del) {
+		NL_SET_ERR_MSG_MOD(info->extack, "Rate nodes aren't supported");
+		return -EOPNOTSUPP;
+	}
+
+	if (!devlink_rate_set_ops_supported(ops, info, DEVLINK_RATE_TYPE_NODE))
+		return -EOPNOTSUPP;
+
+	rate_node = devlink_rate_node_get_from_attrs(devlink, info->attrs);
+	if (!IS_ERR(rate_node))
+		return -EEXIST;
+	else if (rate_node == ERR_PTR(-EINVAL))
+		return -EINVAL;
+
+	rate_node = kzalloc(sizeof(*rate_node), GFP_KERNEL);
+	if (!rate_node)
+		return -ENOMEM;
+
+	rate_node->devlink = devlink;
+	rate_node->type = DEVLINK_RATE_TYPE_NODE;
+	rate_node->name = nla_strdup(info->attrs[DEVLINK_ATTR_RATE_NODE_NAME], GFP_KERNEL);
+	if (!rate_node->name) {
+		err = -ENOMEM;
+		goto err_strdup;
+	}
+
+	err = ops->rate_node_new(rate_node, &rate_node->priv, info->extack);
+	if (err)
+		goto err_node_new;
+
+	err = devlink_nl_rate_set(rate_node, ops, info);
+	if (err)
+		goto err_rate_set;
+
+	list_add(&rate_node->list, &devlink->rate_list);
+	devlink_rate_notify(rate_node, DEVLINK_CMD_RATE_NEW);
+	return 0;
+
+err_rate_set:
+	ops->rate_node_del(rate_node, rate_node->priv, info->extack);
+err_node_new:
+	kfree(rate_node->name);
+err_strdup:
+	kfree(rate_node);
+	return err;
+}
+
+static int devlink_nl_cmd_rate_del_doit(struct sk_buff *skb,
+					struct genl_info *info)
+{
+	struct devlink_rate *rate_node = info->user_ptr[1];
+	struct devlink *devlink = rate_node->devlink;
+	const struct devlink_ops *ops = devlink->ops;
+	int err;
+
+	devlink_rate_notify(rate_node, DEVLINK_CMD_RATE_DEL);
+	err = ops->rate_node_del(rate_node, rate_node->priv, info->extack);
+	list_del(&rate_node->list);
+	kfree(rate_node->name);
+	kfree(rate_node);
+	return err;
+}
+
 static int devlink_nl_sb_fill(struct sk_buff *msg, struct devlink *devlink,
 			      struct devlink_sb *devlink_sb,
 			      enum devlink_command cmd, u32 portid,
@@ -2441,6 +2599,30 @@ static int devlink_nl_cmd_eswitch_get_doit(struct sk_buff *skb,
 	return genlmsg_reply(msg, info);
 }
 
+static int devlink_rate_nodes_check(struct devlink *devlink, u16 mode,
+				    struct netlink_ext_ack *extack)
+{
+	struct devlink_rate *devlink_rate;
+	u16 old_mode;
+	int err;
+
+	if (!devlink->ops->eswitch_mode_get)
+		return -EOPNOTSUPP;
+	err = devlink->ops->eswitch_mode_get(devlink, &old_mode);
+	if (err)
+		return err;
+
+	if (old_mode == mode)
+		return 0;
+
+	list_for_each_entry(devlink_rate, &devlink->rate_list, list)
+		if (devlink_rate_is_node(devlink_rate)) {
+			NL_SET_ERR_MSG_MOD(extack, "Rate node(s) exists.");
+			return -EBUSY;
+		}
+	return 0;
+}
+
 static int devlink_nl_cmd_eswitch_set_doit(struct sk_buff *skb,
 					   struct genl_info *info)
 {
@@ -2455,6 +2637,9 @@ static int devlink_nl_cmd_eswitch_set_doit(struct sk_buff *skb,
 		if (!ops->eswitch_mode_set)
 			return -EOPNOTSUPP;
 		mode = nla_get_u16(info->attrs[DEVLINK_ATTR_ESWITCH_MODE]);
+		err = devlink_rate_nodes_check(devlink, mode, info->extack);
+		if (err)
+			return err;
 		err = ops->eswitch_mode_set(devlink, mode, info->extack);
 		if (err)
 			return err;
@@ -8038,6 +8223,7 @@ static int devlink_nl_cmd_trap_policer_set_doit(struct sk_buff *skb,
 	[DEVLINK_ATTR_RATE_TYPE] = { .type = NLA_U16 },
 	[DEVLINK_ATTR_RATE_TX_SHARE] = { .type = NLA_U64 },
 	[DEVLINK_ATTR_RATE_TX_MAX] = { .type = NLA_U64 },
+	[DEVLINK_ATTR_RATE_NODE_NAME] = { .type = NLA_NUL_STRING },
 };
 
 static const struct genl_small_ops devlink_nl_ops[] = {
@@ -8077,6 +8263,17 @@ static int devlink_nl_cmd_trap_policer_set_doit(struct sk_buff *skb,
 		.internal_flags = DEVLINK_NL_FLAG_NEED_RATE,
 	},
 	{
+		.cmd = DEVLINK_CMD_RATE_NEW,
+		.doit = devlink_nl_cmd_rate_new_doit,
+		.flags = GENL_ADMIN_PERM,
+	},
+	{
+		.cmd = DEVLINK_CMD_RATE_DEL,
+		.doit = devlink_nl_cmd_rate_del_doit,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = DEVLINK_NL_FLAG_NEED_RATE_NODE,
+	},
+	{
 		.cmd = DEVLINK_CMD_PORT_SPLIT,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_port_split_doit,
@@ -8933,6 +9130,33 @@ void devlink_rate_leaf_destroy(struct devlink_port *devlink_port)
 }
 EXPORT_SYMBOL_GPL(devlink_rate_leaf_destroy);
 
+/**
+ * devlink_rate_nodes_destroy - destroy all devlink rate nodes on device
+ *
+ * @devlink: devlink instance
+ *
+ * Destroy all rate nodes on specified device
+ *
+ * Context: Takes and release devlink->lock <mutex>.
+ */
+void devlink_rate_nodes_destroy(struct devlink *devlink)
+{
+	static struct devlink_rate *devlink_rate, *tmp;
+	const struct devlink_ops *ops = devlink->ops;
+
+	mutex_lock(&devlink->lock);
+	list_for_each_entry_safe(devlink_rate, tmp, &devlink->rate_list, list) {
+		if (devlink_rate_is_node(devlink_rate)) {
+			ops->rate_node_del(devlink_rate, devlink_rate->priv, NULL);
+			list_del(&devlink_rate->list);
+			kfree(devlink_rate->name);
+			kfree(devlink_rate);
+		}
+	}
+	mutex_unlock(&devlink->lock);
+}
+EXPORT_SYMBOL_GPL(devlink_rate_nodes_destroy);
+
 static int __devlink_port_phys_port_name_get(struct devlink_port *devlink_port,
 					     char *name, size_t len)
 {
-- 
1.8.3.1

