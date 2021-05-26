Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14FCE391701
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 14:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234632AbhEZMEi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 08:04:38 -0400
Received: from mail-co1nam11on2073.outbound.protection.outlook.com ([40.107.220.73]:25410
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234681AbhEZMDj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 08:03:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E9G2aK5eVF2or+PFYD7j7R1AZFrybjwLo8EGYIAcx4NRRJTJvt0DmTIn3x7mtRsBE/mgaFUVrRWy4D+9mgslOpY1CLhQWKhGp9J4XBXUIfz38fLMu+gc4dSaVsImsCoKCUSsn1NhkbGCV3CQrSXBK5IPe9X8kN2fQ/mvHfQ8QXLD3614NEbXZ/VbR94d4NRbgPFFOlbX2ROqkEERDQOddb5C1QJM9WONjcqnvYefx/EG4ySZ8nC1OXl/XEOF/xcXXlf96KX/BmfAxxLs5c4SI/jWS1D3WELpsoU2nYQ8/JXs38Z0d/RAXHQSzVY/FcMFa7S/+DvBkTNZvOQSNwq06A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yrNTdEwIcEHg4zBufGcXn6KEFuJqqFn9RDKKmFS25NQ=;
 b=SLSrZl8rLgajGnlxkNm5SnovlEKQRmIU9c8ljjtYhCp4KnrZWdeYDuE4mdZo4R19GUMEcQPniWvu2aRRLgkkxJaSwRFTpcMLdZke/CmiNLDIcnzUrlPw8Jr80rWBKMjxkV3h9PUAd0h5ApPYJzCi0/qrIXrRD3H1m7v4u19E+OgWbX2/74gqNNQBjzCNKB1ab4FIbsLNEElN2JgsgC3I0Y+iIbM29O+2ikJ6x9daAa70lmjAmGghn9zwxfFVAuJ7CnbG/ITJBz41IcwfUC2HDmyrLK5EjNGKcXuK+CP8802dMfq4KDCboxuWNBfShgM18W+su+5/SlYiZuZ626TZiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yrNTdEwIcEHg4zBufGcXn6KEFuJqqFn9RDKKmFS25NQ=;
 b=R5cRboY47J8sJ/3rhJLjknJQttpy12Zbjn40WVZ0QUiYqmtC1p4E3rILT8q6QRkthDyTt/qdY/QS3IHoWKIraHypLEfiMToiT23O07doykEw5f3Xf1VryvTqTROlCVoWZ9+bJjzmfShFmDpsfMpgdbfMrFGHg1Fxqfb3TNR4NhVUfCxLW7iAxCgfHjdb/5mJJt6MYbA4C0x+IixfPgLZXmAERQmf8hJJtv9C3v1VTt7xT7cXo36/TGBXU70nd5gZXv43J5yJll4SLdVWvOdDEOG7JvPcpimE6PSPPphC2eZtSDaDKZs+ITE6Iiy4PaOh8Gpzi2/2ERUXhslcJtfLMQ==
Received: from DM6PR13CA0072.namprd13.prod.outlook.com (2603:10b6:5:134::49)
 by BY5PR12MB3698.namprd12.prod.outlook.com (2603:10b6:a03:194::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.25; Wed, 26 May
 2021 12:02:07 +0000
Received: from DM6NAM11FT048.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:134:cafe::b7) by DM6PR13CA0072.outlook.office365.com
 (2603:10b6:5:134::49) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.12 via Frontend
 Transport; Wed, 26 May 2021 12:02:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT048.mail.protection.outlook.com (10.13.173.114) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Wed, 26 May 2021 12:02:07 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 26 May
 2021 12:01:58 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 26 May 2021 12:01:55 +0000
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <stephen@networkplumber.org>, <dsahern@gmail.com>,
        <vladbu@nvidia.com>, <parav@nvidia.com>, <huyn@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>
Subject: [PATCH RFC net-next v3 15/18] devlink: Allow setting parent node of rate objects
Date:   Wed, 26 May 2021 15:01:07 +0300
Message-ID: <1622030470-21434-16-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1622030470-21434-1-git-send-email-dlinkin@nvidia.com>
References: <1622030470-21434-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 244f2216-580e-4ad0-29f6-08d9203e15a2
X-MS-TrafficTypeDiagnostic: BY5PR12MB3698:
X-Microsoft-Antispam-PRVS: <BY5PR12MB36980994388F8C5268FEBE48CB249@BY5PR12MB3698.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:121;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IZmqK679MXy5ToLuqVEcs+OEKoIOCmlmd/0Ax1paBuiBllunJpPuhlgsCsljU3T7ZthjFfUWjn0sw5A4r8dWj5Y76Pa8yCjZ3aqrhHdg9lKNFN8XEjzkLWcH5cQfnSFxgP83or++DdtV0udOnX1moQa0bjD5fVHfIvZAXQ9XwNPjM5+m8r99xX8zFjYhHXQl3yAh/1WDX9LIY/ZwG+zrzKjN9uW123FGwjFVjnwytO4f/0r6J/HxxNRnQNrOi7Ok+g60IRD5T1KCqi3ekh58BaQ32v4jYl18gjN9bOdOepYkL+cMmSmtyymg+h1i0hiWA7V4v/lPixGPpJ4SpPNwYWWlRYffUbk3twj7h94yo+9mHtPqXa9t6exMJN2SZni5Xj/fc34Ek460WNIi3K0zgOM5+qypuoHKmvTzTs3FhPjommCBGl3B0DHW3ESA6c+MCwkLz0BNTT52PZP1NOm5FuEKLEQ0pHfGqxH9lpMQn2jMoq8sgnWYZLj4upilgHHpX6aIy3yOqQz4aGr0fPcBGV4nxRwwFAyfwdoH1yHNf8jcZOpkwkOWxkdxH+rTgIxzi6x72vHLirGLy/FF0uLjeX/NwNzIt2nR39bkPP6xEsYwPBnNkK1v4CbnQ7VKraZSfrKdGAmuN8ccM6Y4yl27Eykt6jKmzbLrhUbUZPfhOi0=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(136003)(396003)(39860400002)(346002)(46966006)(36840700001)(6666004)(7636003)(54906003)(70586007)(47076005)(316002)(426003)(8936002)(8676002)(36860700001)(82310400003)(356005)(2616005)(2876002)(7696005)(5660300002)(186003)(82740400003)(36906005)(83380400001)(6916009)(4326008)(478600001)(2906002)(70206006)(86362001)(36756003)(107886003)(26005)(336012);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2021 12:02:07.1506
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 244f2216-580e-4ad0-29f6-08d9203e15a2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT048.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3698
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmytro Linkin <dlinkin@nvidia.com>

Refactor DEVLINK_CMD_RATE_{GET|SET} command handlers to support setting
a node as a parent for another rate object (leaf or node) by means of
new attribute DEVLINK_ATTR_RATE_PARENT_NODE_NAME. Extend devlink ops
with new callbacks rate_{leaf|node}_parent_set() to set node as a parent
for rate object to allow supporting drivers to implement rate grouping
through devlink. Driver implementations are allowed to support leafs
or node children only. Invoking callback with NULL as parent should be
threated by the driver as unset parent action.
Extend rate object struct with reference counter to disallow deleting a
node with any child pointing to it. User should unset parent for the
child explicitly.

Example:

$ devlink port function rate add netdevsim/netdevsim10/group1

$ devlink port function rate add netdevsim/netdevsim10/group2

$ devlink port function rate set netdevsim/netdevsim10/group1 parent group2

$ devlink port function rate show netdevsim/netdevsim10/group1
netdevsim/netdevsim10/group1: type node parent group2

$ devlink port function rate set netdevsim/netdevsim10/group1 noparent

Co-developed-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Dmytro Linkin <dlinkin@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---

Notes:
    v1->v2:
    - s/func/function/ at commit message

    v2->v3:
    - unset parents for all rate objects at devlink_rate_nodes_destroy()

 include/net/devlink.h        |  14 ++++-
 include/uapi/linux/devlink.h |   1 +
 net/core/devlink.c           | 125 ++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 137 insertions(+), 3 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 13162b5..eb045f1 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -142,9 +142,13 @@ struct devlink_rate {
 	u64 tx_share;
 	u64 tx_max;
 
+	struct devlink_rate *parent;
 	union {
 		struct devlink_port *devlink_port;
-		char *name;
+		struct {
+			char *name;
+			refcount_t refcnt;
+		};
 	};
 };
 
@@ -1486,6 +1490,14 @@ struct devlink_ops {
 			     struct netlink_ext_ack *extack);
 	int (*rate_node_del)(struct devlink_rate *rate_node, void *priv,
 			     struct netlink_ext_ack *extack);
+	int (*rate_leaf_parent_set)(struct devlink_rate *child,
+				    struct devlink_rate *parent,
+				    void *priv_child, void *priv_parent,
+				    struct netlink_ext_ack *extack);
+	int (*rate_node_parent_set)(struct devlink_rate *child,
+				    struct devlink_rate *parent,
+				    void *priv_child, void *priv_parent,
+				    struct netlink_ext_ack *extack);
 };
 
 static inline void *devlink_priv(struct devlink *devlink)
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 7e15853..32f53a00 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -549,6 +549,7 @@ enum devlink_attr {
 	DEVLINK_ATTR_RATE_TX_SHARE,		/* u64 */
 	DEVLINK_ATTR_RATE_TX_MAX,		/* u64 */
 	DEVLINK_ATTR_RATE_NODE_NAME,		/* string */
+	DEVLINK_ATTR_RATE_PARENT_NODE_NAME,	/* string */
 
 	/* add new attributes above here, update the policy in devlink.c */
 
diff --git a/net/core/devlink.c b/net/core/devlink.c
index d520fb5..04cc5e5 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -880,6 +880,11 @@ static int devlink_nl_rate_fill(struct sk_buff *msg,
 			      devlink_rate->tx_max, DEVLINK_ATTR_PAD))
 		goto nla_put_failure;
 
+	if (devlink_rate->parent)
+		if (nla_put_string(msg, DEVLINK_ATTR_RATE_PARENT_NODE_NAME,
+				   devlink_rate->parent->name))
+			goto nla_put_failure;
+
 	genlmsg_end(msg, hdr);
 	return 0;
 
@@ -1152,6 +1157,18 @@ static int devlink_nl_cmd_rate_get_doit(struct sk_buff *skb,
 	return genlmsg_reply(msg, info);
 }
 
+static bool
+devlink_rate_is_parent_node(struct devlink_rate *devlink_rate,
+			    struct devlink_rate *parent)
+{
+	while (parent) {
+		if (parent == devlink_rate)
+			return true;
+		parent = parent->parent;
+	}
+	return false;
+}
+
 static int devlink_nl_cmd_get_doit(struct sk_buff *skb, struct genl_info *info)
 {
 	struct devlink *devlink = info->user_ptr[0];
@@ -1572,11 +1589,75 @@ static int devlink_nl_cmd_port_del_doit(struct sk_buff *skb,
 	return devlink->ops->port_del(devlink, port_index, extack);
 }
 
+static int
+devlink_nl_rate_parent_node_set(struct devlink_rate *devlink_rate,
+				struct genl_info *info,
+				struct nlattr *nla_parent)
+{
+	struct devlink *devlink = devlink_rate->devlink;
+	const char *parent_name = nla_data(nla_parent);
+	const struct devlink_ops *ops = devlink->ops;
+	size_t len = strlen(parent_name);
+	struct devlink_rate *parent;
+	int err = -EOPNOTSUPP;
+
+	parent = devlink_rate->parent;
+	if (parent && len) {
+		NL_SET_ERR_MSG_MOD(info->extack, "Rate object already has parent.");
+		return -EBUSY;
+	} else if (parent && !len) {
+		if (devlink_rate_is_leaf(devlink_rate))
+			err = ops->rate_leaf_parent_set(devlink_rate, NULL,
+							devlink_rate->priv, NULL,
+							info->extack);
+		else if (devlink_rate_is_node(devlink_rate))
+			err = ops->rate_node_parent_set(devlink_rate, NULL,
+							devlink_rate->priv, NULL,
+							info->extack);
+		if (err)
+			return err;
+
+		refcount_dec(&parent->refcnt);
+		devlink_rate->parent = NULL;
+	} else if (!parent && len) {
+		parent = devlink_rate_node_get_by_name(devlink, parent_name);
+		if (IS_ERR(parent))
+			return -ENODEV;
+
+		if (parent == devlink_rate) {
+			NL_SET_ERR_MSG_MOD(info->extack, "Parent to self is not allowed");
+			return -EINVAL;
+		}
+
+		if (devlink_rate_is_node(devlink_rate) &&
+		    devlink_rate_is_parent_node(devlink_rate, parent->parent)) {
+			NL_SET_ERR_MSG_MOD(info->extack, "Node is already a parent of parent node.");
+			return -EEXIST;
+		}
+
+		if (devlink_rate_is_leaf(devlink_rate))
+			err = ops->rate_leaf_parent_set(devlink_rate, parent,
+							devlink_rate->priv, parent->priv,
+							info->extack);
+		else if (devlink_rate_is_node(devlink_rate))
+			err = ops->rate_node_parent_set(devlink_rate, parent,
+							devlink_rate->priv, parent->priv,
+							info->extack);
+		if (err)
+			return err;
+
+		refcount_inc(&parent->refcnt);
+		devlink_rate->parent = parent;
+	}
+
+	return 0;
+}
+
 static int devlink_nl_rate_set(struct devlink_rate *devlink_rate,
 			       const struct devlink_ops *ops,
 			       struct genl_info *info)
 {
-	struct nlattr **attrs = info->attrs;
+	struct nlattr *nla_parent, **attrs = info->attrs;
 	int err = -EOPNOTSUPP;
 	u64 rate;
 
@@ -1606,6 +1687,14 @@ static int devlink_nl_rate_set(struct devlink_rate *devlink_rate,
 		devlink_rate->tx_max = rate;
 	}
 
+	nla_parent = attrs[DEVLINK_ATTR_RATE_PARENT_NODE_NAME];
+	if (nla_parent) {
+		err = devlink_nl_rate_parent_node_set(devlink_rate, info,
+						      nla_parent);
+		if (err)
+			return err;
+	}
+
 	return 0;
 }
 
@@ -1624,6 +1713,11 @@ static bool devlink_rate_set_ops_supported(const struct devlink_ops *ops,
 			NL_SET_ERR_MSG_MOD(info->extack, "TX max set isn't supported for the leafs");
 			return false;
 		}
+		if (attrs[DEVLINK_ATTR_RATE_PARENT_NODE_NAME] &&
+		    !ops->rate_leaf_parent_set) {
+			NL_SET_ERR_MSG_MOD(info->extack, "Parent set isn't supported for the leafs");
+			return false;
+		}
 	} else if (type == DEVLINK_RATE_TYPE_NODE) {
 		if (attrs[DEVLINK_ATTR_RATE_TX_SHARE] && !ops->rate_node_tx_share_set) {
 			NL_SET_ERR_MSG_MOD(info->extack, "TX share set isn't supported for the nodes");
@@ -1633,6 +1727,11 @@ static bool devlink_rate_set_ops_supported(const struct devlink_ops *ops,
 			NL_SET_ERR_MSG_MOD(info->extack, "TX max set isn't supported for the nodes");
 			return false;
 		}
+		if (attrs[DEVLINK_ATTR_RATE_PARENT_NODE_NAME] &&
+		    !ops->rate_node_parent_set) {
+			NL_SET_ERR_MSG_MOD(info->extack, "Parent set isn't supported for the nodes");
+			return false;
+		}
 	} else {
 		WARN_ON("Unknown type of rate object");
 		return false;
@@ -1702,6 +1801,7 @@ static int devlink_nl_cmd_rate_new_doit(struct sk_buff *skb,
 	if (err)
 		goto err_rate_set;
 
+	refcount_set(&rate_node->refcnt, 1);
 	list_add(&rate_node->list, &devlink->rate_list);
 	devlink_rate_notify(rate_node, DEVLINK_CMD_RATE_NEW);
 	return 0;
@@ -1723,8 +1823,15 @@ static int devlink_nl_cmd_rate_del_doit(struct sk_buff *skb,
 	const struct devlink_ops *ops = devlink->ops;
 	int err;
 
+	if (refcount_read(&rate_node->refcnt) > 1) {
+		NL_SET_ERR_MSG_MOD(info->extack, "Node has children. Cannot delete node.");
+		return -EBUSY;
+	}
+
 	devlink_rate_notify(rate_node, DEVLINK_CMD_RATE_DEL);
 	err = ops->rate_node_del(rate_node, rate_node->priv, info->extack);
+	if (rate_node->parent)
+		refcount_dec(&rate_node->parent->refcnt);
 	list_del(&rate_node->list);
 	kfree(rate_node->name);
 	kfree(rate_node);
@@ -8224,6 +8331,7 @@ static int devlink_nl_cmd_trap_policer_set_doit(struct sk_buff *skb,
 	[DEVLINK_ATTR_RATE_TX_SHARE] = { .type = NLA_U64 },
 	[DEVLINK_ATTR_RATE_TX_MAX] = { .type = NLA_U64 },
 	[DEVLINK_ATTR_RATE_NODE_NAME] = { .type = NLA_NUL_STRING },
+	[DEVLINK_ATTR_RATE_PARENT_NODE_NAME] = { .type = NLA_NUL_STRING },
 };
 
 static const struct genl_small_ops devlink_nl_ops[] = {
@@ -9135,7 +9243,8 @@ void devlink_rate_leaf_destroy(struct devlink_port *devlink_port)
  *
  * @devlink: devlink instance
  *
- * Destroy all rate nodes on specified device
+ * Unset parent for all rate object and destroy all rate nodes
+ * on specified device.
  *
  * Context: Takes and release devlink->lock <mutex>.
  */
@@ -9145,6 +9254,18 @@ void devlink_rate_nodes_destroy(struct devlink *devlink)
 	const struct devlink_ops *ops = devlink->ops;
 
 	mutex_lock(&devlink->lock);
+	list_for_each_entry(devlink_rate, &devlink->rate_list, list) {
+		if (!devlink_rate->parent)
+			continue;
+
+		refcount_dec(&devlink_rate->parent->refcnt);
+		if (devlink_rate_is_leaf(devlink_rate))
+			ops->rate_leaf_parent_set(devlink_rate, NULL, devlink_rate->priv,
+						  NULL, NULL);
+		else if (devlink_rate_is_node(devlink_rate))
+			ops->rate_node_parent_set(devlink_rate, NULL, devlink_rate->priv,
+						  NULL, NULL);
+	}
 	list_for_each_entry_safe(devlink_rate, tmp, &devlink->rate_list, list) {
 		if (devlink_rate_is_node(devlink_rate)) {
 			ops->rate_node_del(devlink_rate, devlink_rate->priv, NULL);
-- 
1.8.3.1

