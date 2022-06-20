Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40E955520D1
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 17:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241614AbiFTP1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 11:27:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234611AbiFTP1f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 11:27:35 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2068.outbound.protection.outlook.com [40.107.220.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24F49CD
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 08:27:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y7Ca/bjdFdRWwrpdk3OlnQ3TTQMIqqTobrWj6UcXY4LNkkXAihJh98aj5znJ8s9rjYTpQvC7p/0jq9fqbb0lan3YVVTY2r0DprLOvYiMjXVC9vr2gOyLRahrUh5EwHKKORYEjGgvpZS/zDmfvoy6PkoW+gz73o79h21OvY9aYSP1LK0guiiQXmCak0rItcRR4aLS5UXk+SZovWBJz5jiNF4+eEw5rgkcDzNavIbRayOl0gAvIHa0/9PDczW+Z+cJwNPGAtSuPa5QyBhN39efwH6C7iAmemNjPZa1+PwwbJIIV1YVEqnmZ0Mmf02o8ErsuqLyy2BVjLoM/ZZIGs+3RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uhr5kYS54HvYUqUu7g2ruMA2nxBQjWC3dBq0Be8nQVg=;
 b=ly20smVMH3AQIUYupeUUXDk8rovbAixOMr6YYhNhrt4XSCb12wd41Kx9bAd15FLhQcy2Pa7mPCNoCScQysc4MiXOe0ENGms7scNT8Z+ZOOkPir/DSUoPTO9jyMOhPyLXd1OqYEnW6tK6qangHSN5RSLDG8l8bGZiqwcqZSHY23uRTCQE5Xp6jeFU4o1GpVHKTSTXNEeINlyrQXuLaWwxpaPapvGMQl6ENiFqIga3nm4T5pDnTQhDECYJO+u7W6dNo3F8iDUbM+yesyd09MOAW9I74VeJ33nZ/jUhkzovCJdiIMlq63PBHfRv6t7TRb07w0Nyd74vYy0ehNrOHFPH2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uhr5kYS54HvYUqUu7g2ruMA2nxBQjWC3dBq0Be8nQVg=;
 b=mFaQsKMpotPurIAGfY1LR8dcbJKsPeyG4+jb0moBWPBsIBbpftosnu4ryhUb2W3dpRPvhboQelEtMQXt0Qiof05LV41il2TYVSTKbnUsxtf/YBBeYaO0uifO2v5VYNACLLfvlCiUxPAF01rKcTlHYdDmXbaGct/tP/yXpgpTrFro03+2CTAGanlbUJX69wh98mwMXeRFXc5dnJhLVn4pqRTeUsx/ZTaDJKSBtbnBb4EjeOF1Q9R+2b841pyEn61ViTdUDcJLmsXsuJJUe6d1uv3hjnEpAwo8wyeJ+nCWcDe6gtVKv8FSs1dFQomiqA+e4J7jQoCeB91sfKg7EMmlEQ==
Received: from BN6PR16CA0047.namprd16.prod.outlook.com (2603:10b6:405:14::33)
 by PH7PR12MB6561.namprd12.prod.outlook.com (2603:10b6:510:213::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.15; Mon, 20 Jun
 2022 15:27:32 +0000
Received: from BN8NAM11FT015.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:14:cafe::a3) by BN6PR16CA0047.outlook.office365.com
 (2603:10b6:405:14::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.22 via Frontend
 Transport; Mon, 20 Jun 2022 15:27:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 BN8NAM11FT015.mail.protection.outlook.com (10.13.176.90) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5353.14 via Frontend Transport; Mon, 20 Jun 2022 15:27:31 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL109.nvidia.com (10.27.9.19) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Mon, 20 Jun 2022 15:27:31 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Mon, 20 Jun 2022 08:27:30 -0700
Received: from vdi.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Mon, 20 Jun 2022 08:27:28 -0700
From:   Dima Chumak <dchumak@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        Dima Chumak <dchumak@nvidia.com>
Subject: [PATCH net-next 1/5] devlink: Introduce limit_type attr for rate objects
Date:   Mon, 20 Jun 2022 18:26:43 +0300
Message-ID: <20220620152647.2498927-2-dchumak@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220620152647.2498927-1-dchumak@nvidia.com>
References: <20220620152647.2498927-1-dchumak@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 396bdf91-843d-4072-891c-08da52d164e5
X-MS-TrafficTypeDiagnostic: PH7PR12MB6561:EE_
X-Microsoft-Antispam-PRVS: <PH7PR12MB6561E7326A40F460D92BECB8D5B09@PH7PR12MB6561.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c6OJ/xhVLfPR9P1ke8kT9RvhZUY7JKzIis32/zGPPpk9XPI5FnKTsOGTFuW8sseengmqYdM66KEd3N4Gp7pGH3K4reeZXVoSmQdUsNeeyHXN5/ocl5tUAo+t1HSr1I0anKdRKLX6CqSYLxLwFnFh7LIA8ImOSnS0ac5hBPVAkkw6aHPMsxkvELIcaDe2kNLXvwXaJG9uADUD3EQd8F50cev2jb2fBZNfZqMN1qcscztrkS9Yyk3L35eUDNZ4+QJOl2kNAcV2x8upSUFp20BJPVD/QAz9GadBOt0DScfODySVnZeVjevQCUZndm8UBOD1jq4gPtHCggZuk+Lmfu6whR3+gREtC6k4+kD/DPOYi3Eo4N4EkLAPukEEmE2Aem5h4zWYIfes7oWNO9XMNreo10nx0ws6RsCvYGsS1n86XnJymcaXnUwn/50siZObIyuBRFBlUl1p6lFmtiX0tFYqMfDtRrd6yDGqXKthLmBhR1tCj1qjL6mZnV/GbPKqh0sjXVAuXRf4kL7srUd1rikUrgqq/jevkdbw/PQJDQe5UbxG+kW5AmqDtD4H2qzx3cvKEgY3AgMX4pnVqR4Dom+wjIk2Imza8wYduhghQHFJuHFGtbE3S5CsGu0xQb56/4P5q/uA0c94zdp27+c/s2/6rcbPbtqZkqkRnB0ViKwDoT6a6arWa3f1TPsLQI86mu1NS8kyZLM1BPQf5oVXkylT/heBa4K2CRxWdhO29baax+Briw1/liM00Y8pYJDaI2UK
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(39860400002)(346002)(136003)(46966006)(40470700004)(36840700001)(40460700003)(8676002)(4326008)(36860700001)(36756003)(336012)(7696005)(107886003)(47076005)(6666004)(70206006)(81166007)(26005)(40480700001)(1076003)(70586007)(54906003)(86362001)(83380400001)(2906002)(478600001)(356005)(41300700001)(426003)(8936002)(5660300002)(316002)(2616005)(82740400003)(186003)(30864003)(6916009)(82310400005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2022 15:27:31.8097
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 396bdf91-843d-4072-891c-08da52d164e5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT015.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6561
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lay foundation to support different kinds of rate limiting that may be
performed by rate objects.

Existing rate limiting type is dubbed as 'shaping' and it is assumed by
default when limit_type attribute isn't set explicitly. Following patch
in the series will introduce new limit type 'police'.

Leaf rate objects inherit their limit_type from a parent node object if
it hasn't been explicitly set for the leaf object.

Signed-off-by: Dima Chumak <dchumak@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/esw/qos.c |  28 +++-
 include/net/devlink.h                         |  12 +-
 include/uapi/linux/devlink.h                  |   7 +
 net/core/devlink.c                            | 123 ++++++++++++++----
 4 files changed, 140 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
index 694c54066955..50bd4536fab1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
@@ -874,8 +874,8 @@ int mlx5_esw_devlink_rate_node_tx_max_set(struct devlink_rate *rate_node, void *
 int mlx5_esw_devlink_rate_node_new(struct devlink_rate *rate_node, void **priv,
 				   struct netlink_ext_ack *extack)
 {
-	struct mlx5_esw_rate_group *group;
 	struct mlx5_eswitch *esw;
+	void *group;
 	int err = 0;
 
 	esw = mlx5_devlink_eswitch_get(rate_node->devlink);
@@ -890,7 +890,17 @@ int mlx5_esw_devlink_rate_node_new(struct devlink_rate *rate_node, void **priv,
 		goto unlock;
 	}
 
-	group = esw_qos_create_rate_group(esw, extack);
+	switch (rate_node->limit_type) {
+	case DEVLINK_RATE_LIMIT_TYPE_UNSET:
+		group = ERR_PTR(-EINVAL);
+		break;
+	case DEVLINK_RATE_LIMIT_TYPE_SHAPING:
+		group = esw_qos_create_rate_group(esw, extack);
+		break;
+	default:
+		group = ERR_PTR(-EOPNOTSUPP);
+	}
+
 	if (IS_ERR(group)) {
 		err = PTR_ERR(group);
 		goto unlock;
@@ -905,7 +915,6 @@ int mlx5_esw_devlink_rate_node_new(struct devlink_rate *rate_node, void **priv,
 int mlx5_esw_devlink_rate_node_del(struct devlink_rate *rate_node, void *priv,
 				   struct netlink_ext_ack *extack)
 {
-	struct mlx5_esw_rate_group *group = priv;
 	struct mlx5_eswitch *esw;
 	int err;
 
@@ -914,7 +923,18 @@ int mlx5_esw_devlink_rate_node_del(struct devlink_rate *rate_node, void *priv,
 		return PTR_ERR(esw);
 
 	mutex_lock(&esw->state_lock);
-	err = esw_qos_destroy_rate_group(esw, group, extack);
+
+	switch (rate_node->limit_type) {
+	case DEVLINK_RATE_LIMIT_TYPE_UNSET:
+		err = -EINVAL;
+		break;
+	case DEVLINK_RATE_LIMIT_TYPE_SHAPING:
+		err = esw_qos_destroy_rate_group(esw, priv, extack);
+		break;
+	default:
+		err = -EOPNOTSUPP;
+	}
+
 	mutex_unlock(&esw->state_lock);
 	return err;
 }
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 2a2a2a0c93f7..4fe8e657da44 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -98,13 +98,21 @@ struct devlink_port_attrs {
 	};
 };
 
+struct devlink_rate_shaping_attrs {
+	u64 tx_max;
+	u64 tx_share;
+};
+
 struct devlink_rate {
 	struct list_head list;
+	enum devlink_rate_limit_type limit_type;
 	enum devlink_rate_type type;
 	struct devlink *devlink;
 	void *priv;
-	u64 tx_share;
-	u64 tx_max;
+
+	union { /* on limit_type */
+		struct devlink_rate_shaping_attrs shaping_attrs;
+	};
 
 	struct devlink_rate *parent;
 	union {
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index b3d40a5d72ff..53aad0d09231 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -221,6 +221,11 @@ enum devlink_rate_type {
 	DEVLINK_RATE_TYPE_NODE,
 };
 
+enum devlink_rate_limit_type {
+	DEVLINK_RATE_LIMIT_TYPE_UNSET,
+	DEVLINK_RATE_LIMIT_TYPE_SHAPING,
+};
+
 enum devlink_param_cmode {
 	DEVLINK_PARAM_CMODE_RUNTIME,
 	DEVLINK_PARAM_CMODE_DRIVERINIT,
@@ -576,6 +581,8 @@ enum devlink_attr {
 	DEVLINK_ATTR_LINECARD_TYPE,		/* string */
 	DEVLINK_ATTR_LINECARD_SUPPORTED_TYPES,	/* nested */
 
+	DEVLINK_ATTR_RATE_LIMIT_TYPE,		/* u16 */
+
 	/* add new attributes above here, update the policy in devlink.c */
 
 	__DEVLINK_ATTR_MAX,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index db61f3a341cb..756d95c72b4d 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -354,6 +354,18 @@ devlink_rate_is_node(struct devlink_rate *devlink_rate)
 	return devlink_rate->type == DEVLINK_RATE_TYPE_NODE;
 }
 
+static inline bool
+devlink_rate_is_unset(struct devlink_rate *devlink_rate)
+{
+	return devlink_rate->limit_type == DEVLINK_RATE_LIMIT_TYPE_UNSET;
+}
+
+static inline bool
+devlink_rate_is_shaping(struct devlink_rate *devlink_rate)
+{
+	return devlink_rate->limit_type == DEVLINK_RATE_LIMIT_TYPE_SHAPING;
+}
+
 static struct devlink_rate *
 devlink_rate_leaf_get_from_info(struct devlink *devlink, struct genl_info *info)
 {
@@ -1093,13 +1105,27 @@ static int devlink_nl_rate_fill(struct sk_buff *msg,
 			goto nla_put_failure;
 	}
 
-	if (nla_put_u64_64bit(msg, DEVLINK_ATTR_RATE_TX_SHARE,
-			      devlink_rate->tx_share, DEVLINK_ATTR_PAD))
+	if (nla_put_u64_64bit(msg, DEVLINK_ATTR_RATE_LIMIT_TYPE,
+			      devlink_rate->limit_type, DEVLINK_ATTR_PAD))
 		goto nla_put_failure;
 
-	if (nla_put_u64_64bit(msg, DEVLINK_ATTR_RATE_TX_MAX,
-			      devlink_rate->tx_max, DEVLINK_ATTR_PAD))
-		goto nla_put_failure;
+	if (devlink_rate_is_unset(devlink_rate)) {
+		/* For backward compatibility with older user-space clients that
+		 * don't understatnd DEVLINK_ATTR_RATE_LIMIT_TYPE, report tx_max
+		 * and tx_share as being "unlimited".
+		 */
+		if (nla_put_u64_64bit(msg, DEVLINK_ATTR_RATE_TX_MAX, 0, DEVLINK_ATTR_PAD))
+			goto nla_put_failure;
+		if (nla_put_u64_64bit(msg, DEVLINK_ATTR_RATE_TX_SHARE, 0, DEVLINK_ATTR_PAD))
+			goto nla_put_failure;
+	} else if (devlink_rate_is_shaping(devlink_rate)) {
+		if (nla_put_u64_64bit(msg, DEVLINK_ATTR_RATE_TX_MAX,
+				      devlink_rate->shaping_attrs.tx_max, DEVLINK_ATTR_PAD))
+			goto nla_put_failure;
+		if (nla_put_u64_64bit(msg, DEVLINK_ATTR_RATE_TX_SHARE,
+				      devlink_rate->shaping_attrs.tx_share, DEVLINK_ATTR_PAD))
+			goto nla_put_failure;
+	}
 
 	if (devlink_rate->parent)
 		if (nla_put_string(msg, DEVLINK_ATTR_RATE_PARENT_NODE_NAME,
@@ -1850,6 +1876,12 @@ devlink_nl_rate_parent_node_set(struct devlink_rate *devlink_rate,
 			return -EEXIST;
 		}
 
+		if (parent->limit_type != devlink_rate->limit_type) {
+			NL_SET_ERR_MSG_MOD(info->extack,
+					   "Parent and object should be of the same limit_type");
+			return -EINVAL;
+		}
+
 		if (devlink_rate_is_leaf(devlink_rate))
 			err = ops->rate_leaf_parent_set(devlink_rate, parent,
 							devlink_rate->priv, parent->priv,
@@ -1873,44 +1905,82 @@ static int devlink_nl_rate_set(struct devlink_rate *devlink_rate,
 			       struct genl_info *info)
 {
 	struct nlattr *nla_parent, **attrs = info->attrs;
-	int err = -EOPNOTSUPP;
-	u64 rate;
+	struct devlink_rate *parent;
+	int err = 0;
+	u16 new_limit_type;
+	u64 new_val;
+
+	nla_parent = attrs[DEVLINK_ATTR_RATE_PARENT_NODE_NAME];
+
+	if (attrs[DEVLINK_ATTR_RATE_LIMIT_TYPE]) {
+		new_limit_type = nla_get_u16(attrs[DEVLINK_ATTR_RATE_LIMIT_TYPE]);
+		if (devlink_rate_is_unset(devlink_rate))
+			devlink_rate->limit_type = new_limit_type;
+		if (devlink_rate->limit_type != new_limit_type) {
+			if (devlink_rate_is_node(devlink_rate)) {
+				NL_SET_ERR_MSG_MOD(info->extack,
+						   "Cannot change limit_type of the rate node object, delete and add a new one instead.");
+				return -EINVAL;
+			}
+			NL_SET_ERR_MSG_MOD(info->extack,
+					   "Cannot change limit_type of the rate leaf object, reset current rate attributes first.");
+			return -EBUSY;
+		}
+	}
+
+	if (devlink_rate_is_unset(devlink_rate)) {
+		if (nla_parent) {
+			parent = devlink_rate_node_get_by_name(devlink_rate->devlink,
+							       nla_data(nla_parent));
+			if (!IS_ERR(parent))
+				devlink_rate->limit_type = parent->limit_type;
+			else
+				devlink_rate->limit_type = DEVLINK_RATE_LIMIT_TYPE_SHAPING;
+		} else {
+			devlink_rate->limit_type = DEVLINK_RATE_LIMIT_TYPE_SHAPING;
+		}
+	}
+
+	if (attrs[DEVLINK_ATTR_RATE_TX_SHARE] && devlink_rate_is_shaping(devlink_rate)) {
+		new_val = nla_get_u64(attrs[DEVLINK_ATTR_RATE_TX_SHARE]);
 
-	if (attrs[DEVLINK_ATTR_RATE_TX_SHARE]) {
-		rate = nla_get_u64(attrs[DEVLINK_ATTR_RATE_TX_SHARE]);
 		if (devlink_rate_is_leaf(devlink_rate))
 			err = ops->rate_leaf_tx_share_set(devlink_rate, devlink_rate->priv,
-							  rate, info->extack);
+							  new_val, info->extack);
 		else if (devlink_rate_is_node(devlink_rate))
 			err = ops->rate_node_tx_share_set(devlink_rate, devlink_rate->priv,
-							  rate, info->extack);
+							  new_val, info->extack);
 		if (err)
 			return err;
-		devlink_rate->tx_share = rate;
+		devlink_rate->shaping_attrs.tx_share = new_val;
 	}
 
 	if (attrs[DEVLINK_ATTR_RATE_TX_MAX]) {
-		rate = nla_get_u64(attrs[DEVLINK_ATTR_RATE_TX_MAX]);
+		new_val = nla_get_u64(attrs[DEVLINK_ATTR_RATE_TX_MAX]);
+
 		if (devlink_rate_is_leaf(devlink_rate))
 			err = ops->rate_leaf_tx_max_set(devlink_rate, devlink_rate->priv,
-							rate, info->extack);
+							new_val, info->extack);
 		else if (devlink_rate_is_node(devlink_rate))
 			err = ops->rate_node_tx_max_set(devlink_rate, devlink_rate->priv,
-							rate, info->extack);
+							new_val, info->extack);
 		if (err)
 			return err;
-		devlink_rate->tx_max = rate;
+		devlink_rate->shaping_attrs.tx_max = new_val;
 	}
 
-	nla_parent = attrs[DEVLINK_ATTR_RATE_PARENT_NODE_NAME];
-	if (nla_parent) {
-		err = devlink_nl_rate_parent_node_set(devlink_rate, info,
-						      nla_parent);
-		if (err)
-			return err;
-	}
+	if (nla_parent)
+		err = devlink_nl_rate_parent_node_set(devlink_rate, info, nla_parent);
 
-	return 0;
+	/* reset limit_type when all attrs have been cleared, relevant only for
+	 * leaf objects as node objects get deleted altogether
+	 */
+	if (devlink_rate_is_leaf(devlink_rate) && !devlink_rate->parent &&
+	    ((devlink_rate_is_shaping(devlink_rate) &&
+	      !devlink_rate->shaping_attrs.tx_max && !devlink_rate->shaping_attrs.tx_share)))
+		devlink_rate->limit_type = DEVLINK_RATE_LIMIT_TYPE_UNSET;
+
+	return err;
 }
 
 static bool devlink_rate_set_ops_supported(const struct devlink_ops *ops,
@@ -2002,6 +2072,10 @@ static int devlink_nl_cmd_rate_new_doit(struct sk_buff *skb,
 
 	rate_node->devlink = devlink;
 	rate_node->type = DEVLINK_RATE_TYPE_NODE;
+	if (info->attrs[DEVLINK_ATTR_RATE_LIMIT_TYPE])
+		rate_node->limit_type = nla_get_u16(info->attrs[DEVLINK_ATTR_RATE_LIMIT_TYPE]);
+	if (rate_node->limit_type == DEVLINK_RATE_LIMIT_TYPE_UNSET)
+		rate_node->limit_type = DEVLINK_RATE_LIMIT_TYPE_SHAPING;
 	rate_node->name = nla_strdup(info->attrs[DEVLINK_ATTR_RATE_NODE_NAME], GFP_KERNEL);
 	if (!rate_node->name) {
 		err = -ENOMEM;
@@ -9000,6 +9074,7 @@ static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
 	[DEVLINK_ATTR_RATE_PARENT_NODE_NAME] = { .type = NLA_NUL_STRING },
 	[DEVLINK_ATTR_LINECARD_INDEX] = { .type = NLA_U32 },
 	[DEVLINK_ATTR_LINECARD_TYPE] = { .type = NLA_NUL_STRING },
+	[DEVLINK_ATTR_RATE_LIMIT_TYPE] = { .type = NLA_U16 },
 };
 
 static const struct genl_small_ops devlink_nl_ops[] = {
-- 
2.36.1

