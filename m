Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3823637C0AD
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 16:50:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231660AbhELOvm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 10:51:42 -0400
Received: from mail-bn8nam12on2064.outbound.protection.outlook.com ([40.107.237.64]:22465
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231560AbhELOup (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 May 2021 10:50:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iMYmGdLn3sHu6PWWzP8YMOpljBXgtSybaAkN2yzhejvDiIy+/uQYdqjt4udvmCAmEGAp0ZnrWld6qkm9WRmB+rSg6mEBXjFRbO55njnvjkUbydg0MH4zXWNsWviGWMfDHbrjeKEEu8bz30eTtJlkMaNR8XJd64bzy9yHcwijCEcUGSTE9tZr0SualzXUX/w1bi/S98pYkTKF06BkrjpSV+ZL+XkyJpx9IFPrZx28Z2pYFylD3TqeR5eAwBMyhcRe9fCfm89XtUWB/2CMc7gW5rJDsBQLSZOXx3aWeBwKEkXr5PP6/GojvUOmaCAe9BL+A9QaJ0XijJyk4sLVz+O7Zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9j/8IM/TzWgguCPmZfqzlpzccCD0NsFcMeza4cpbhSY=;
 b=GrArx7xQPEOPovzwpvBTHWv8mmTFUBKVr4iBPX3SxzfDGYupaiTWXKKWAVKtHFYkJRg/YxoG5+Z9OrMRKy+9XLJfCsQsQE6FrJqXnVCLa3iIrSlRjMWuK13nIz1IHOyRbwx2abtP67TWoKrt1sUbszD9byAl2uX/17sFkVR/76Ts9Q3vYMkJMlepcaPMH+7YP5dPXqvuo/FB3S/b/7yr6sKOuGciVP8YYXgz78DlOxmMJsS9yrVLEVaqWTBXTAnIAUC5HQ56wNtBBNiph073rAjdwPB1PzlsV0exBRkZR9DbAEj47HuQSAsI0h6ZEL99rE7fEXBUHTN/niN3DgOo9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9j/8IM/TzWgguCPmZfqzlpzccCD0NsFcMeza4cpbhSY=;
 b=ddgyJ6dtlxMUo8yH4ESegUauvzVVDOmgkeliTue85ONOh9fiUzngEKTIHrkCWcF8Fa+PacvEtL4kuIiIF0uUspamsf2cHK7sV31EhRrripzakgew4+CWS9o4vmcOr3G6L01/CvkQr6gXQ6ljwgEjZzNvPGsOrNj1ummmO8hAOGlvk4Vaw2lA325/Qj/Ok6k4OsOY4Nj1oK8wNgitvXLcSb68gG3T//k0/q1sK+F8q0UGFqZxch789ZwJH5jh71cQyARpCYZOMj8AkFs8zIwRvZBI5WAigiy1dcwP9A1JKPqhZkH1jJW6rdXXBPH1/9dOOtalEPUatGcr+0obQixEXQ==
Received: from DM6PR02CA0083.namprd02.prod.outlook.com (2603:10b6:5:1f4::24)
 by BN6PR12MB1298.namprd12.prod.outlook.com (2603:10b6:404:17::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.28; Wed, 12 May
 2021 14:49:35 +0000
Received: from DM6NAM11FT037.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1f4:cafe::19) by DM6PR02CA0083.outlook.office365.com
 (2603:10b6:5:1f4::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.50 via Frontend
 Transport; Wed, 12 May 2021 14:49:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 DM6NAM11FT037.mail.protection.outlook.com (10.13.172.122) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Wed, 12 May 2021 14:49:35 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 12 May
 2021 14:49:34 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 12 May 2021 14:49:32 +0000
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <stephen@networkplumber.org>, <dsahern@gmail.com>,
        <vladbu@nvidia.com>, <parav@nvidia.com>, <huyn@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>
Subject: [PATCH RFC net-next v2 15/18] devlink: Allow setting parent node of rate objects
Date:   Wed, 12 May 2021 17:48:44 +0300
Message-ID: <1620830927-11828-16-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1620830927-11828-1-git-send-email-dlinkin@nvidia.com>
References: <1620830927-11828-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7a29e8b8-fd85-439d-233e-08d915552914
X-MS-TrafficTypeDiagnostic: BN6PR12MB1298:
X-Microsoft-Antispam-PRVS: <BN6PR12MB1298B2D757BA2090E98BA540CB529@BN6PR12MB1298.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:222;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fPecxnSwFIznPv3/wYzFjW4fCUnr9A3UZvdL5skoj8+or+rkiZFnvtetAZgLjua2lu4bXwL/0V7zLST7lHtvedXhrJMqUlQtFkh52rn1qJ4YKP/3FyrMxk/NPas1DCOiuCg9qwjCEtgd5dpbGcZmdcWm7IJ2OL/zMwCipMd4bBIh4Y8Z2wIYZTaexPQE2usY2scHe/1l7LESPYvRQi7ztpWDmTn/jT1esU705gAgKt0TEgjR9TBNSQh8m37Fc5xpjE2DjSsLaeNT6bAjqybDFiC/dy4OkfkgWK4a5Kr1Sg08Z6J05nT2BewiFgOg9Jl7wjlsMgy/0AAQInIdvGP7kWG/JrC5VKRp6/mwX4Lv1jKouXumESM6Cj1g1M9USPx+iv3BRo/9ia4gm6EOe3/snvDldoSEVQDQ2gtQ7GMsnr/ICOVJ7qKiT7r03vcHRmjbuwN3lAm1C3/smmpn0Sjc8RESDCnXIZ4LQRcLGU3IEe2s89nxOfILFmU09+RfJUyd9oXu4Ic3ovaam/C6uv/nFomT4SXY7SWA4bzjuThcSz/+kK+4jg7lCwCxemU18f5Q/VHDvF1s2tT/NbQfA+72gkLl1FsgXIzVNv+7//1U8qERYQAGEC/HUBhdrJvOyMWHSDiNlqfHLBIjRr6q904l7EKCc+KvF0oilbEWYG7JIqA=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(396003)(39860400002)(376002)(346002)(46966006)(36840700001)(107886003)(6666004)(82740400003)(356005)(6916009)(4326008)(478600001)(2906002)(7696005)(7636003)(86362001)(47076005)(336012)(426003)(2616005)(36756003)(36906005)(26005)(316002)(83380400001)(186003)(70586007)(54906003)(36860700001)(8676002)(70206006)(82310400003)(8936002)(2876002)(5660300002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2021 14:49:35.3675
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a29e8b8-fd85-439d-233e-08d915552914
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT037.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1298
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

 include/net/devlink.h        |  14 +++++-
 include/uapi/linux/devlink.h |   1 +
 net/core/devlink.c           | 110 ++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 123 insertions(+), 2 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index af6f06f..8b5b884 100644
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
index fe920b7..69d0336 100644
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
-- 
1.8.3.1

