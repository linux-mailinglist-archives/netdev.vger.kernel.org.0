Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17178398946
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 14:18:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbhFBMUb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 08:20:31 -0400
Received: from mail-mw2nam10on2064.outbound.protection.outlook.com ([40.107.94.64]:59616
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229762AbhFBMUE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 08:20:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BhtYGLOGpPEytYiCeh3japh9EaJ9QH8r1ZvLHaY1O78M0WrFk5bC+gLTVPlHKz1jF2teRgZLCE+KqbbYLqWQfLq94T4ndgvl4t/tZkDAN3JkRieSItAh0WExHla5X7vHL2aLMMoTo9bRWAeUw7GclP/sj+n5jsFU+JPagQeXlQQdn/vIqg9+j5sHZxzn0XGkzWZOiYqkFMfVtlVkihEqlKAtHOnG5p3euSYagb/oRWH1kLp9gwNOhMNA8ziCaJ6rAZWoEhrxP0QOMAjmkqDmwEscm6mD1rKbUikGmI2u8pigQiE7TBXc6OrLVJqZyeg3Xa5u0lHKJ1rxya9VEcTTxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l38TADw6uTKrPt/uwljOd7X1kJKoyrfOyloFQ8G+6/4=;
 b=JDVdfpSJ4lKzqiz7UbUalA/uK4A1Hb4WM9nKMWLzSHpU68fEDt/nuOYItbwoS9+/fkXhyiZtEG7kNzAq+5tsqmm6j9teTBaAdcdQW0yg9dposeiE/65QpkVqyAAFwlO8ZjV0ccuYaTrtvHPFjX78kYGQ15aLJwXGSHvaxE9GyHDcs+MWHV2frg27m6CSc5WNE+YW15MqYfNaDQbFT/F+TeWXkzTA+EvXQ98WXCF7aOddDH18z5JEzYuYXMCzscbFIMzIPyM1s/gN4HVG9q/GZSRrOnnJx/cFfMc4IfkVSDQWqVkinf8XhhbJLmP+yDIqn2+EFpwp2tLzg2egdRxbIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l38TADw6uTKrPt/uwljOd7X1kJKoyrfOyloFQ8G+6/4=;
 b=pUnCz4yZNPIBtqiLZcULI/l7/kFKJrB+sPODENFOYT4ulh+g4bn4pXHG4RCxBPEAAJEPhjZGp6TAgsSJilDiFR9mhSfzEQCOVTQkzUgoOZwIpfdZsCXgYQ9z9WTU1VmCiP6b6ZYtKzoc66ggrU4OjYHyGo8UWr2uHqxWBcRh+dA6L18ySL9iTcz8r540a4ji3p0RB4ZRNa9d3I0jPJxMKTs9ZRW2d24qNUHkOeTanaP/SZ0PVTcTlcMvTZIDN5M/CKJDcUUmm0aQCoHvMwTJnNaALyX4DC5Uk+EsprrM4aMUQDt+bv4t/Bhhmt7TWFkwVfmLxOmOBZNMsmDfm1En9w==
Received: from MWHPR18CA0070.namprd18.prod.outlook.com (2603:10b6:300:39::32)
 by MN2PR12MB3936.namprd12.prod.outlook.com (2603:10b6:208:16a::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.21; Wed, 2 Jun
 2021 12:18:19 +0000
Received: from CO1NAM11FT004.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:39:cafe::2e) by MWHPR18CA0070.outlook.office365.com
 (2603:10b6:300:39::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend
 Transport; Wed, 2 Jun 2021 12:18:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 CO1NAM11FT004.mail.protection.outlook.com (10.13.175.89) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4150.30 via Frontend Transport; Wed, 2 Jun 2021 12:18:18 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 2 Jun
 2021 12:18:18 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 2 Jun 2021 05:18:15 -0700
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <stephen@networkplumber.org>, <dsahern@gmail.com>,
        <vladbu@nvidia.com>, <parav@nvidia.com>, <huyn@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>
Subject: [PATCH RESEND net-next v3 15/18] devlink: Allow setting parent node of rate objects
Date:   Wed, 2 Jun 2021 15:17:28 +0300
Message-ID: <1622636251-29892-16-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1622636251-29892-1-git-send-email-dlinkin@nvidia.com>
References: <1622636251-29892-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b2f99019-9f49-4b13-e4c1-08d925c081be
X-MS-TrafficTypeDiagnostic: MN2PR12MB3936:
X-Microsoft-Antispam-PRVS: <MN2PR12MB39369C86EB1EC8FF885986E2CB3D9@MN2PR12MB3936.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:121;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 44D+HgEMs7VvEDi6AtEG16CtGMgR4Ao9PRP/ADw/E16zEB8ISWH7sKTm77fmKa3IwIiZcONlJP231HsvYdFW10qo2UaFv282UgBzXlDCwD4oMHiVAL6XV6UMArG2bs1wGR+x10XvlzrrqRP1jkxZo4qN+g9rkyVS1uhF74a6qSrCQ7tVoFLhYx1IXsV0PBA3THdJpHnt1LR2QXMPYWLAkvyh2bQdmndq01EHg7ybvo59RzePDSzyz7wU/Tc+VDUD1JmogmfJOSHyGI/dpk4DbkMrU03g9Ax+ONF1ZvZLNPL6pEu4mzYS0SPmHfON3uQ6lDIsN0Eq584Gt6Br95fjpXhE11Eb+oHwf3rNoLYvXjTIpcYD/yq8N6CsV71lbFmVii9N+v98vlhPGAN7IKxq2RJZydotro7Uq5w2SAzVsmaWUT7d82IbmW7Ik+SoCKM1CvnmKSjnqZ3aFrwGV2Yen5VgyMWiSUOj1voHWFY1dYc8X9qGg/RdWzyI95/awBt54xfmum7DdqnPZdFZgZLr7sDZ0LHi6BJLq93M+28BpdmYjiVyAgQe93GSgja7q3m9jM0Mpmn4WClgvwwyDGJj1kvq6uf1R16ktij9yuim7fCwUOdNI+CESFJ3r+s1zgH9sdr/WtvBvKVaGnHOUB4szT66vr4JS6E4n9KE8oVVMM0=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(346002)(39860400002)(376002)(136003)(46966006)(36840700001)(26005)(54906003)(7696005)(336012)(86362001)(36906005)(8936002)(82310400003)(5660300002)(7636003)(70206006)(186003)(36756003)(356005)(2616005)(36860700001)(83380400001)(4326008)(47076005)(6666004)(107886003)(6916009)(426003)(2906002)(82740400003)(70586007)(8676002)(316002)(478600001)(2876002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 12:18:18.9056
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b2f99019-9f49-4b13-e4c1-08d925c081be
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT004.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3936
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
+ * Unset parent for all rate objects and destroy all rate nodes
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

