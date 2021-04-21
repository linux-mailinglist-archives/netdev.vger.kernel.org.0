Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 410E7366F80
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 17:54:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244185AbhDUPyj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 11:54:39 -0400
Received: from mail-bn8nam12on2077.outbound.protection.outlook.com ([40.107.237.77]:9569
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244207AbhDUPyV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 11:54:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L5u7/OyiHpkYCbPQlvRwwfWEOpOihLkDAovWFTxL2Qsbf4Mp28psUGAVhj0PFKdru2V8xFsTU8s5qaV8dJbzZXvdMK9ZMttdEtirA4wIemF2suGg1AE03v2YF4CpJPcM9x0WLca3t74evyT/6rBHNeWqshpUM1m1PAELbpArmNvSAgtAE2fnnabmgWxXcuklnQWG+N2h3aKQNJvM7rgxnkLK6QM6eLOwlDXoH36iS4VyzQcWbev2Z/8s/clhRIJ6AJI/mNMecEl0YSGsbENg0zFJrjI5yPkEobQgdHFSuNUWGV48s4Oi+bXULNnQUaRv1w6AkY4NNCoKalqB1FRO2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=87Q6yS2Nt9/uUx/tpswXTTxS2gVCcoI6E/sftvcISVI=;
 b=b4CLrnBNX1m5lNk4+pqMJlMo0ninmi7dHtQB97MMw2g9aaGSZYlVGFBf53sJz/stSW/tYaNkxViRT/hx2Pc+Rvm6B9h6YJyY42xAQdPzXxXEffHRSsm0tXclJnvYV56GLwo5iG401R21/EaxriIoo2VYDImAzozDWWZyTvTMmNzj25+/W7so6IUy5m5wvhigrGrjjq2+4YHYKs4w/Vjo5KnurclO0keutUDVwWq8VRysrvPox8TM8VBiydgaDEPBcQ81WMb0Khy5wvsF6N0En08N6nEKBcB0sGRaM/LyYFy6pvytpUeN66u3zKhIhx64//avE200CIqdxDDBc/dH+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=87Q6yS2Nt9/uUx/tpswXTTxS2gVCcoI6E/sftvcISVI=;
 b=CqDtdHqQX6YlLg6Cne2PvYNvaL76ZgtrPkuaWo6X8ySxDZHCNqcxgcPK6tb4SDyiHp8iTkGzDTS1TIpBuX3rvfNeSAcdaaOx3ar1EVcWlJtJburCJziIdfnn+yvo+k7N1zFeVw9MrJungUABnWowOTmMhgAty4z//vimTet1uv2oIdSALZ9iCTaLRbXE/1qP9Okn7GaX+IPYuQz+nGIxOtcr8fLg7jb6Nqp9HMmsxvqpgYlox39tqhJ++Ly+QFAS/kSw7+vWoeKFnxwumM7Rw8vAq9xr0ZDhr0k3w14XwPWuPjCeeHJ4E97IPIwnztJtIGdbsBVdb8CJxARMgTFGrA==
Received: from DM5PR07CA0120.namprd07.prod.outlook.com (2603:10b6:4:ae::49) by
 DM4PR12MB5055.namprd12.prod.outlook.com (2603:10b6:5:38a::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4065.21; Wed, 21 Apr 2021 15:53:46 +0000
Received: from DM6NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:ae:cafe::8e) by DM5PR07CA0120.outlook.office365.com
 (2603:10b6:4:ae::49) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.19 via Frontend
 Transport; Wed, 21 Apr 2021 15:53:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 DM6NAM11FT010.mail.protection.outlook.com (10.13.172.222) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4065.21 via Frontend Transport; Wed, 21 Apr 2021 15:53:46 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 21 Apr
 2021 08:53:45 -0700
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 21 Apr 2021 15:53:43 +0000
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <stephen@networkplumber.org>, <dsahern@gmail.com>,
        <vladbu@nvidia.com>, Dmytro Linkin <dlinkin@nvidia.com>
Subject: [PATCH RESEND-2 RFC net-next 15/18] devlink: Allow setting parent node of rate objects
Date:   Wed, 21 Apr 2021 18:53:02 +0300
Message-ID: <1619020385-20220-16-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1619020385-20220-1-git-send-email-dlinkin@nvidia.com>
References: <1619020385-20220-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c094bee8-ec4d-4512-7224-08d904dda5ad
X-MS-TrafficTypeDiagnostic: DM4PR12MB5055:
X-Microsoft-Antispam-PRVS: <DM4PR12MB5055C9A11B28E3B1ED96C2E6CB479@DM4PR12MB5055.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1186;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kliIvkykQlhSjL5F52YgWPo1BYMa66F6V/5jNW/n4ho6/xVUlw7br/LFibDFkUZHngKcvuYYH0uykYbty6yiNYBQxILKJLbvj3yYy6VbiYuWNo4pVwgmXmJ0tQywJwp6iPHqzYoeZz+6JPZ0XdKP1qoyBvlnxGvXQhtrNlMFcPWKHSZXH0NNQJgqdZHqAXSjAQ5ez4pYh88SjOZbCBYXga2/2sz2V4ES9tCpAlHjdd7DX+oqU3U2hkDCnNcAUzand84jfVfovbdEFDRgzV8+wmn3YYI7ZCOSsNU1ISa0alqqmus8O1FpPL3qE438Mc3gMiZlAKcUxHke6uRvLFmy9tXqVzA1RJDzVFDWxuemgQzNaxBRqumjeYF+P6xv8sjyBXAgDkLPFfNZJh8Zz5GuopNdE55Lixe2IQ78RPItWd4/Dw+hkVQ6Wu9z4ArJ2RosWG3iagsbmriH/Pe0Fx5H1U1jZnAK/frJqN6FJ1EBD3u5Jzp4ORBDAQJn48yJpxc34/E4Rfx+gStrumfKkhzmMQaTWq6+MEpUhOzlkc4R+SPHu9YxZfsc9RKrlui+KwwasFir40k75+5YzuEhC2T0MfgjwnOScGqF6It5CqQjLAo8v6RLpz01biCCEDXCpOncDE5qPVZ4cX7R/iAdiXOObw==
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(39860400002)(376002)(396003)(346002)(36840700001)(46966006)(6916009)(107886003)(4326008)(478600001)(5660300002)(70206006)(86362001)(70586007)(2876002)(2906002)(6666004)(356005)(36860700001)(7636003)(82740400003)(336012)(426003)(2616005)(186003)(83380400001)(26005)(8676002)(36756003)(54906003)(82310400003)(7696005)(8936002)(47076005)(316002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2021 15:53:46.1927
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c094bee8-ec4d-4512-7224-08d904dda5ad
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5055
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

$ devlink port func rate add netdevsim/netdevsim10/group1

$ devlink port func rate add netdevsim/netdevsim10/group2

$ devlink port func rate set netdevsim/netdevsim10/group1 parent group2

$ devlink port func rate show netdevsim/netdevsim10/group1
netdevsim/netdevsim10/group1: type node parent group2

$ devlink port func rate set netdevsim/netdevsim10/group1 noparent

Co-developed-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Dmytro Linkin <dlinkin@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 include/net/devlink.h        |  14 +++++-
 include/uapi/linux/devlink.h |   1 +
 net/core/devlink.c           | 110 ++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 123 insertions(+), 2 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index ac0b5eb..530513e 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -140,9 +140,13 @@ struct devlink_rate {
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
 
@@ -1484,6 +1488,14 @@ struct devlink_ops {
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
index eca3f28..20f3056 100644
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
 	u64 rate;
 	int err;
 
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

