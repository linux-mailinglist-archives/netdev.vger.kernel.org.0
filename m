Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 387443F86C7
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 13:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242374AbhHZLz2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 07:55:28 -0400
Received: from mail-mw2nam10on2083.outbound.protection.outlook.com ([40.107.94.83]:22369
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242147AbhHZLz1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 07:55:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mmw2N4TyJ2mr9jaMEonZrwzi1ACZulXwO51Xv1NdyNwxLW9m80RVgBwYfwfiX4C1IN1+YrrIMSF/R/RNheIkahBaVdsc6sNmBvW4qOQvyCFhQpnoAKsa/I8JWatTcHfRHY84iBF1yOT6x4NSiv6WKVfxCKy5MPXxe0MU349kk3RSnA4IH4qAjuwTy8NsWvNXQl5TcwBtkeTNCYSAAjrkI+EUitTRkldpVluC2H4TZiqfZ3FA2EzjxGaM6WddygCs5kgaq2uCgp5WrXndWI39NwcKRK2yfH1mDAFTuG7LtlQIKlf4nEp3KHX1DtQiuRSuZWClnZuQMKiK4o84mw3vkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HBSTFdkFY0X2s1BgvMja9V4l1Now47s9lt4j2fD72Jk=;
 b=Hp7O4rTOu8mp6B1OxWZ17WPWDFRSv6XxLWVbiiT3XfjbEf9R9fPO6dW2cpzF5SFlaHUhUO1zQwbdAJ9Mw7A4AG2VgxxheX81swBVW3Mrs+z6vy/BzRKQWFFYsFQ/ZHe4gez+LH03lEA4c34ojsEWGOChX/fSnlrBUm1IfBFyKOEy2ksCXjjJNu6lnBLiY54vCLxr1sWYbpha2pDTAp/5NB390LwDgXhijnJ52Lpzy9LGSwjlZwPBbWK2zRkgqaZ1RT5s9MkTjQRxYMzBeFiyqjLyer13G8fXwiWzs4KZUXsiWVt6S+WvzOJjLqjJQGi7OBGICbrinhNnRuxfiQ6otA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=mojatatu.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HBSTFdkFY0X2s1BgvMja9V4l1Now47s9lt4j2fD72Jk=;
 b=g0pNa2/pFDkhMRlXPDV0MFg9553CI4Il2VKp+IMOk2+AEiPtcJGHJWSfspkLSpWpErz+rKfG6hix4b9j5AogiA1kIwPAhJWYFKJk9NPwP9r6RB//R6pAAenNGQk38Zcl69MCBrh89XnpHihDRFSrHoAgyPXuFN2dtOzT+0T6lHHoVvrz2aMHGEsbc9mDL40hOhUhk5dMItRWZWXXduzyv0i3nkUTlqwVslAdsdxTeiz9ryAex/8F87tknBFHwDbeyuOZxu9dc4VuMy4ncWD5ig4N3+gyQOSe0lL5sjIpecizA3WvtBFJSK2NMyXHJyLP52XpW9d/k9GEkgfovLedCA==
Received: from BN9PR03CA0092.namprd03.prod.outlook.com (2603:10b6:408:fd::7)
 by MWHPR1201MB0079.namprd12.prod.outlook.com (2603:10b6:301:52::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17; Thu, 26 Aug
 2021 11:54:39 +0000
Received: from BN8NAM11FT032.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fd:cafe::2) by BN9PR03CA0092.outlook.office365.com
 (2603:10b6:408:fd::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend
 Transport; Thu, 26 Aug 2021 11:54:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; mojatatu.com; dkim=none (message not signed)
 header.d=none;mojatatu.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 BN8NAM11FT032.mail.protection.outlook.com (10.13.177.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4457.17 via Frontend Transport; Thu, 26 Aug 2021 11:54:38 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 26 Aug
 2021 11:54:37 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 26 Aug
 2021 11:54:37 +0000
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 26 Aug 2021 11:54:34 +0000
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
CC:     Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>, <netdev@vger.kernel.org>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [PATCH net] sch_htb: Fix inconsistency when leaf qdisc creation fails
Date:   Thu, 26 Aug 2021 14:54:25 +0300
Message-ID: <20210826115425.1744053-1-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4b6823eb-7659-4be0-73f5-08d96888485c
X-MS-TrafficTypeDiagnostic: MWHPR1201MB0079:
X-Microsoft-Antispam-PRVS: <MWHPR1201MB0079133B01B8FD908A33207CDCC79@MWHPR1201MB0079.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:268;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KuO+95dVt9S5zbSZytf9PuQNLEKcvay3+jDn4S9dHR7rgd0AkkUvrpicIFqNxCj+c63lB7sU3SNLadMAy7HnmWI188xoHkaT7/SdMRheOYVkbqEYEoWwXdbdEFxzaEeD+/RmcxblPuGDT97nXTMbt3W7QYmQQBDSrG0vHm/hBXzK0MvwwCCALiLpiyOR5dcdpSpj1VRmMd5mc4l9TrF1tthaR0y0mznhLdCosj5NsxR80H3zah10gFdA2DSqkk/G9AS34yA8M5nFTm3qW/N/XnaSsolFSn7khd3ToFIRhzZrXJVq4IKip51Cl8Zzx39onXaW9ZcDBnfMUJ6JlcirSe8WtHv7IhnxH0LwDgXBN1UjNuYMJXxheD7njQ70seSk8dRwVe20C0LZKLxN/LgYXXAFPLt6Bs/C1vaATWUUk2IRNa6J1jRg1WvMGFfzpr/vV67k1jxBEdUdvRazvdhgHya5urnCOxLyFMN6au469TXOtihQi3/l/eGg6H2ZMXfW1iJqiqlL5bpLUNpbXDkBM+sBDr9gSr6ueP21S0LpbzW9XtsJ7ODvUZKslGtCY7hsIbdbFkWjxzvuafpxP2AfZ2c7HlLjQKe+meLBPd1495pzbG8DoGP8KosMbYKfaw+bOFgHiAW7YcjizEK0W5xwaQ3iMZQ+lWRZPftfj37nS410eJSx7mpOi9sNs1AAs5r8sjELTFPZQl5aBi052l0R7Q==
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(346002)(136003)(376002)(396003)(46966006)(36840700001)(6666004)(356005)(316002)(107886003)(110136005)(54906003)(82310400003)(86362001)(30864003)(8936002)(82740400003)(5660300002)(4326008)(36906005)(7636003)(47076005)(70586007)(36756003)(8676002)(26005)(83380400001)(7696005)(1076003)(426003)(2906002)(478600001)(186003)(70206006)(36860700001)(336012)(2616005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2021 11:54:38.6946
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b6823eb-7659-4be0-73f5-08d96888485c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT032.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0079
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In HTB offload mode, qdiscs of leaf classes are grafted to netdev
queues. sch_htb expects the dev_queue field of these qdiscs to point to
the corresponding queues. However, qdisc creation may fail, and in that
case noop_qdisc is used instead. Its dev_queue doesn't point to the
right queue, so sch_htb can lose track of used netdev queues, which will
cause internal inconsistencies.

This commit fixes this bug by keeping track of the netdev queue inside
struct htb_class. All reads of cl->leaf.q->dev_queue are replaced by the
new field, the two values are synced on writes, and WARNs are added to
assert equality of the two values.

The driver API has changed: when TC_HTB_LEAF_DEL needs to move a queue,
the driver used to pass the old and new queue IDs to sch_htb. Now that
there is a new field (offload_queue) in struct htb_class that needs to
be updated on this operation, the driver will pass the old class ID to
sch_htb instead (it already knows the new class ID).

Fixes: d03b195b5aa0 ("sch_htb: Hierarchical QoS hardware offload")
Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/qos.c  | 15 ++-
 .../net/ethernet/mellanox/mlx5/core/en/qos.h  |  4 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  3 +-
 include/net/pkt_cls.h                         |  3 +-
 net/sched/sch_htb.c                           | 97 ++++++++++++-------
 5 files changed, 72 insertions(+), 50 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c b/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
index 5efe3278b0f6..1fd8baf19829 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
@@ -733,8 +733,8 @@ static void mlx5e_reset_qdisc(struct net_device *dev, u16 qid)
 	spin_unlock_bh(qdisc_lock(qdisc));
 }
 
-int mlx5e_htb_leaf_del(struct mlx5e_priv *priv, u16 classid, u16 *old_qid,
-		       u16 *new_qid, struct netlink_ext_ack *extack)
+int mlx5e_htb_leaf_del(struct mlx5e_priv *priv, u16 *classid,
+		       struct netlink_ext_ack *extack)
 {
 	struct mlx5e_qos_node *node;
 	struct netdev_queue *txq;
@@ -742,11 +742,9 @@ int mlx5e_htb_leaf_del(struct mlx5e_priv *priv, u16 classid, u16 *old_qid,
 	bool opened;
 	int err;
 
-	qos_dbg(priv->mdev, "TC_HTB_LEAF_DEL classid %04x\n", classid);
-
-	*old_qid = *new_qid = 0;
+	qos_dbg(priv->mdev, "TC_HTB_LEAF_DEL classid %04x\n", *classid);
 
-	node = mlx5e_sw_node_find(priv, classid);
+	node = mlx5e_sw_node_find(priv, *classid);
 	if (!node)
 		return -ENOENT;
 
@@ -764,7 +762,7 @@ int mlx5e_htb_leaf_del(struct mlx5e_priv *priv, u16 classid, u16 *old_qid,
 	err = mlx5_qos_destroy_node(priv->mdev, node->hw_id);
 	if (err) /* Not fatal. */
 		qos_warn(priv->mdev, "Failed to destroy leaf node %u (class %04x), err = %d\n",
-			 node->hw_id, classid, err);
+			 node->hw_id, *classid, err);
 
 	mlx5e_sw_node_delete(priv, node);
 
@@ -826,8 +824,7 @@ int mlx5e_htb_leaf_del(struct mlx5e_priv *priv, u16 classid, u16 *old_qid,
 	if (opened)
 		mlx5e_reactivate_qos_sq(priv, moved_qid, txq);
 
-	*old_qid = mlx5e_qid_from_qos(&priv->channels, moved_qid);
-	*new_qid = mlx5e_qid_from_qos(&priv->channels, qid);
+	*classid = node->classid;
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/qos.h b/drivers/net/ethernet/mellanox/mlx5/core/en/qos.h
index 5af7991fcd19..757682b7c0e0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/qos.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/qos.h
@@ -34,8 +34,8 @@ int mlx5e_htb_leaf_alloc_queue(struct mlx5e_priv *priv, u16 classid,
 			       struct netlink_ext_ack *extack);
 int mlx5e_htb_leaf_to_inner(struct mlx5e_priv *priv, u16 classid, u16 child_classid,
 			    u64 rate, u64 ceil, struct netlink_ext_ack *extack);
-int mlx5e_htb_leaf_del(struct mlx5e_priv *priv, u16 classid, u16 *old_qid,
-		       u16 *new_qid, struct netlink_ext_ack *extack);
+int mlx5e_htb_leaf_del(struct mlx5e_priv *priv, u16 *classid,
+		       struct netlink_ext_ack *extack);
 int mlx5e_htb_leaf_del_last(struct mlx5e_priv *priv, u16 classid, bool force,
 			    struct netlink_ext_ack *extack);
 int mlx5e_htb_node_modify(struct mlx5e_priv *priv, u16 classid, u64 rate, u64 ceil,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 24f919ef9b8e..1a111af6ef7f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3445,8 +3445,7 @@ static int mlx5e_setup_tc_htb(struct mlx5e_priv *priv, struct tc_htb_qopt_offloa
 		return mlx5e_htb_leaf_to_inner(priv, htb->parent_classid, htb->classid,
 					       htb->rate, htb->ceil, htb->extack);
 	case TC_HTB_LEAF_DEL:
-		return mlx5e_htb_leaf_del(priv, htb->classid, &htb->moved_qid, &htb->qid,
-					  htb->extack);
+		return mlx5e_htb_leaf_del(priv, &htb->classid, htb->extack);
 	case TC_HTB_LEAF_DEL_LAST:
 	case TC_HTB_LEAF_DEL_LAST_FORCE:
 		return mlx5e_htb_leaf_del_last(priv, htb->classid,
diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 298a8d10168b..fb34b66aefa7 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -824,10 +824,9 @@ enum tc_htb_command {
 struct tc_htb_qopt_offload {
 	struct netlink_ext_ack *extack;
 	enum tc_htb_command command;
-	u16 classid;
 	u32 parent_classid;
+	u16 classid;
 	u16 qid;
-	u16 moved_qid;
 	u64 rate;
 	u64 ceil;
 };
diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index 5f7ac27a5264..f22d26a2c89f 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -125,6 +125,7 @@ struct htb_class {
 		struct htb_class_leaf {
 			int		deficit[TC_HTB_MAXDEPTH];
 			struct Qdisc	*q;
+			struct netdev_queue *offload_queue;
 		} leaf;
 		struct htb_class_inner {
 			struct htb_prio clprio[TC_HTB_NUMPRIO];
@@ -1411,24 +1412,47 @@ htb_graft_helper(struct netdev_queue *dev_queue, struct Qdisc *new_q)
 	return old_q;
 }
 
-static void htb_offload_move_qdisc(struct Qdisc *sch, u16 qid_old, u16 qid_new)
+static struct netdev_queue *htb_offload_get_queue(struct htb_class *cl)
+{
+	struct netdev_queue *queue;
+
+	queue = cl->leaf.offload_queue;
+	if (!(cl->leaf.q->flags & TCQ_F_BUILTIN))
+		WARN_ON(cl->leaf.q->dev_queue != queue);
+
+	return queue;
+}
+
+static void htb_offload_move_qdisc(struct Qdisc *sch, struct htb_class *cl_old,
+				   struct htb_class *cl_new, bool destroying)
 {
 	struct netdev_queue *queue_old, *queue_new;
 	struct net_device *dev = qdisc_dev(sch);
-	struct Qdisc *qdisc;
 
-	queue_old = netdev_get_tx_queue(dev, qid_old);
-	queue_new = netdev_get_tx_queue(dev, qid_new);
+	queue_old = htb_offload_get_queue(cl_old);
+	queue_new = htb_offload_get_queue(cl_new);
 
-	if (dev->flags & IFF_UP)
-		dev_deactivate(dev);
-	qdisc = dev_graft_qdisc(queue_old, NULL);
-	qdisc->dev_queue = queue_new;
-	qdisc = dev_graft_qdisc(queue_new, qdisc);
-	if (dev->flags & IFF_UP)
-		dev_activate(dev);
+	if (!destroying) {
+		struct Qdisc *qdisc;
 
-	WARN_ON(!(qdisc->flags & TCQ_F_BUILTIN));
+		if (dev->flags & IFF_UP)
+			dev_deactivate(dev);
+		qdisc = dev_graft_qdisc(queue_old, NULL);
+		WARN_ON(qdisc != cl_old->leaf.q);
+	}
+
+	if (!(cl_old->leaf.q->flags & TCQ_F_BUILTIN))
+		cl_old->leaf.q->dev_queue = queue_new;
+	cl_old->leaf.offload_queue = queue_new;
+
+	if (!destroying) {
+		struct Qdisc *qdisc;
+
+		qdisc = dev_graft_qdisc(queue_new, cl_old->leaf.q);
+		if (dev->flags & IFF_UP)
+			dev_activate(dev);
+		WARN_ON(!(qdisc->flags & TCQ_F_BUILTIN));
+	}
 }
 
 static int htb_graft(struct Qdisc *sch, unsigned long arg, struct Qdisc *new,
@@ -1442,10 +1466,8 @@ static int htb_graft(struct Qdisc *sch, unsigned long arg, struct Qdisc *new,
 	if (cl->level)
 		return -EINVAL;
 
-	if (q->offload) {
-		dev_queue = new->dev_queue;
-		WARN_ON(dev_queue != cl->leaf.q->dev_queue);
-	}
+	if (q->offload)
+		dev_queue = htb_offload_get_queue(cl);
 
 	if (!new) {
 		new = qdisc_create_dflt(dev_queue, &pfifo_qdisc_ops,
@@ -1514,6 +1536,8 @@ static void htb_parent_to_leaf(struct Qdisc *sch, struct htb_class *cl,
 	parent->ctokens = parent->cbuffer;
 	parent->t_c = ktime_get_ns();
 	parent->cmode = HTB_CAN_SEND;
+	if (q->offload)
+		parent->leaf.offload_queue = cl->leaf.offload_queue;
 }
 
 static void htb_parent_to_leaf_offload(struct Qdisc *sch,
@@ -1534,6 +1558,7 @@ static int htb_destroy_class_offload(struct Qdisc *sch, struct htb_class *cl,
 				     struct netlink_ext_ack *extack)
 {
 	struct tc_htb_qopt_offload offload_opt;
+	struct netdev_queue *dev_queue;
 	struct Qdisc *q = cl->leaf.q;
 	struct Qdisc *old = NULL;
 	int err;
@@ -1542,16 +1567,15 @@ static int htb_destroy_class_offload(struct Qdisc *sch, struct htb_class *cl,
 		return -EINVAL;
 
 	WARN_ON(!q);
-	if (!destroying) {
-		/* On destroy of HTB, two cases are possible:
-		 * 1. q is a normal qdisc, but q->dev_queue has noop qdisc.
-		 * 2. q is a noop qdisc (for nodes that were inner),
-		 *    q->dev_queue is noop_netdev_queue.
+	dev_queue = htb_offload_get_queue(cl);
+	old = htb_graft_helper(dev_queue, NULL);
+	if (destroying)
+		/* Before HTB is destroyed, the kernel grafts noop_qdisc to
+		 * all queues.
 		 */
-		old = htb_graft_helper(q->dev_queue, NULL);
-		WARN_ON(!old);
+		WARN_ON(!(old->flags & TCQ_F_BUILTIN));
+	else
 		WARN_ON(old != q);
-	}
 
 	if (cl->parent) {
 		cl->parent->bstats_bias.bytes += q->bstats.bytes;
@@ -1570,18 +1594,17 @@ static int htb_destroy_class_offload(struct Qdisc *sch, struct htb_class *cl,
 	if (!err || destroying)
 		qdisc_put(old);
 	else
-		htb_graft_helper(q->dev_queue, old);
+		htb_graft_helper(dev_queue, old);
 
 	if (last_child)
 		return err;
 
-	if (!err && offload_opt.moved_qid != 0) {
-		if (destroying)
-			q->dev_queue = netdev_get_tx_queue(qdisc_dev(sch),
-							   offload_opt.qid);
-		else
-			htb_offload_move_qdisc(sch, offload_opt.moved_qid,
-					       offload_opt.qid);
+	if (!err && offload_opt.classid != TC_H_MIN(cl->common.classid)) {
+		u32 classid = TC_H_MAJ(sch->handle) |
+			      TC_H_MIN(offload_opt.classid);
+		struct htb_class *moved_cl = htb_find(classid, sch);
+
+		htb_offload_move_qdisc(sch, moved_cl, cl, destroying);
 	}
 
 	return err;
@@ -1704,9 +1727,11 @@ static int htb_delete(struct Qdisc *sch, unsigned long arg,
 	}
 
 	if (last_child) {
-		struct netdev_queue *dev_queue;
+		struct netdev_queue *dev_queue = sch->dev_queue;
+
+		if (q->offload)
+			dev_queue = htb_offload_get_queue(cl);
 
-		dev_queue = q->offload ? cl->leaf.q->dev_queue : sch->dev_queue;
 		new_q = qdisc_create_dflt(dev_queue, &pfifo_qdisc_ops,
 					  cl->parent->common.classid,
 					  NULL);
@@ -1878,7 +1903,7 @@ static int htb_change_class(struct Qdisc *sch, u32 classid,
 			}
 			dev_queue = netdev_get_tx_queue(dev, offload_opt.qid);
 		} else { /* First child. */
-			dev_queue = parent->leaf.q->dev_queue;
+			dev_queue = htb_offload_get_queue(parent);
 			old_q = htb_graft_helper(dev_queue, NULL);
 			WARN_ON(old_q != parent->leaf.q);
 			offload_opt = (struct tc_htb_qopt_offload) {
@@ -1935,6 +1960,8 @@ static int htb_change_class(struct Qdisc *sch, u32 classid,
 
 		/* leaf (we) needs elementary qdisc */
 		cl->leaf.q = new_q ? new_q : &noop_qdisc;
+		if (q->offload)
+			cl->leaf.offload_queue = dev_queue;
 
 		cl->parent = parent;
 
-- 
2.25.1

