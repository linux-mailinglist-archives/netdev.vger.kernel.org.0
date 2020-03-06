Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49C3017BDE8
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 14:14:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbgCFNOs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 08:14:48 -0500
Received: from mail-eopbgr70070.outbound.protection.outlook.com ([40.107.7.70]:21511
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726054AbgCFNOr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Mar 2020 08:14:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PFsz7631PkEK1PnXIwM6HFfZ++wwyTDHEW160x8Ix0z8Pvi6cLJGFAaDaPNUo4aEnGlROWPI0Amgiq6vry5bYnC2sVft30a5WwL880T19z80GNZTXsASBAbwmGUuaL7T1I8XJ9YN1G/W2DV2vnn08icxS92n8uW052Te6PYybXJsv+CDH7iFw9z0nP3jUjJzHfYQJUCazJDTioV6gxC1PSki+tYlPgfI1qxb3YYMuDuirljqfQep/CkmXMqXleUw3A7gcgxZngs/gGdqYRrkAKm4NmNDkv61eDt3NZLRbNIs05Ajkr+CqvH3uei9/Z5rCa+IQDlz6HAHv3iYjiaHFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gn7RifxkNQfCwPmSoiW2erXYE625S0lpkpAO25nkksQ=;
 b=ik+2z2lVr07cknEvEopReX0q02nKZMBwuSvNbiCGYlTREyK/i4vhcoeeBDKI8ej84ysGneifpIVZVGs93Gi2nXnM3HyBGlZXjTr7/RKuSwQKrpJDzAiaWX1RLtxAdy79Ml1j13m41e/DMBTnUHd2a0jksM3d4etwgUmd22vf/Kxm9+C8Hni+G0NPxtIHNm61+anL/lGIrmO3r1vuo/PBAjMiEDbPa0dKOt8Cy+cUUKsRFmF94aKellz3zzalUkyMJojMzWn2dox7fcRv5o/TNBZTQO3ijYkUyiVtDabDVc2dDwLmAZW8VdPFEp4U4TLHs8IiQBIuRwsLAJVjiUeOPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gn7RifxkNQfCwPmSoiW2erXYE625S0lpkpAO25nkksQ=;
 b=fw11nZaL2Cn9zJLqOnRg9FD0Abd6Ioaj09OM03psjV8jj0+92EjbL68Fr3Vic8er99Q3tmyg2i/HBcqh+paZamDOuSjvi7oWkbbUc5cpUXawpPhdpjaCWu7xhFZKS5JzKlmEnbhjORX7VuhwgFPmAlmsAJEW9ld65YqZlVChWn4=
Authentication-Results: spf=none (sender IP is ) smtp.mailfrom=po.liu@nxp.com; 
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (20.179.232.221) by
 VE1PR04MB6718.eurprd04.prod.outlook.com (20.179.234.221) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.16; Fri, 6 Mar 2020 13:14:40 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::8cb8:5c41:d843:b66d]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::8cb8:5c41:d843:b66d%5]) with mapi id 15.20.2772.019; Fri, 6 Mar 2020
 13:14:40 +0000
From:   Po Liu <Po.Liu@nxp.com>
To:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     vinicius.gomes@intel.com, po.liu@nxp.com, claudiu.manoil@nxp.com,
        vladimir.oltean@nxp.com, alexandru.marginean@nxp.com,
        xiaoliang.yang_1@nxp.com, roy.zang@nxp.com, mingkai.hu@nxp.com,
        jerry.huang@nxp.com, leoyang.li@nxp.com, michael.chan@broadcom.com,
        vishal@chelsio.com, saeedm@mellanox.com, leon@kernel.org,
        jiri@mellanox.com, idosch@mellanox.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        kuba@kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        john.hurley@netronome.com, simon.horman@netronome.com,
        pieter.jansenvanvuuren@netronome.com, pablo@netfilter.org,
        moshe@mellanox.com, ivan.khoronzhuk@linaro.org,
        m-karicheri2@ti.com, andre.guedes@linux.intel.com,
        jakub.kicinski@netronome.com, Po Liu <Po.Liu@nxp.com>
Subject: [RFC,net-next  1/9] net: qos offload add flow status with dropped count
Date:   Fri,  6 Mar 2020 20:55:59 +0800
Message-Id: <20200306125608.11717-2-Po.Liu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200306125608.11717-1-Po.Liu@nxp.com>
References: <20200306125608.11717-1-Po.Liu@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0205.apcprd06.prod.outlook.com
 (2603:1096:4:68::13) To VE1PR04MB6496.eurprd04.prod.outlook.com
 (2603:10a6:803:11c::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.73) by SG2PR06CA0205.apcprd06.prod.outlook.com (2603:1096:4:68::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.14 via Frontend Transport; Fri, 6 Mar 2020 13:14:30 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.73]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0b997e97-661e-4d11-acc5-08d7c1d05363
X-MS-TrafficTypeDiagnostic: VE1PR04MB6718:|VE1PR04MB6718:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB6718F813165D2D993DA8D9E492E30@VE1PR04MB6718.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-Forefront-PRVS: 0334223192
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(376002)(39860400002)(396003)(346002)(136003)(199004)(189003)(36756003)(5660300002)(66946007)(66476007)(66556008)(6666004)(478600001)(316002)(2616005)(86362001)(956004)(4326008)(26005)(6506007)(6486002)(6512007)(52116002)(16526019)(8936002)(186003)(69590400007)(81166006)(1076003)(81156014)(7416002)(30864003)(8676002)(2906002)(142933001);DIR:OUT;SFP:1101;SCL:1;SRVR:VE1PR04MB6718;H:VE1PR04MB6496.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X+2pnhObq/Hjb1woy5aQ7s9I/eApmsz2spDby4EN5wnvzYN36gPO14uaW4Jn5h6aMO1kLjPx4AUDUnNLalutyBBteCRbbnrdguywZ7pZ9mmqzbOHD9mEU46qlysdutKXnBDdKujuXMjtjVH6TsCfBRH32GIciJVkBtmMZKefHkW53/66ZEOtpnVK3dOvZ8QYSAsqxMZsqFlcnDyI2q38w9NOiHaXllHAXkjrt3AydCEc6VTflTCkEM5KyPkGnLf15cgdItNFD2vGOF3lcdr/1gU5FN4t+H33tLh7mbfejc2DV55jFGHa+YuBRo1l0GgCdZMuI3AmChFGfqRtxBiiZcYPp1cr3fZU7oIblxlBjM65UDXJxO5z6CsPhlYjqOpmzchY1/qGZ3tFFeFOr8Nc4SiShonvT4JTPp8IzalbK2pjIAfcPRqxIwwp9Vr1JZbVeKNQI+ba4Zv19MRKhYjTEhDeRumJYpetoL0GPvfki/f1WCz6nVpc0oWAWg4aHcPZ0hcbJ0mYXukpFj4ej2osTA==
X-MS-Exchange-AntiSpam-MessageData: J6cr8TeP4I3NHdC34q4dS2Y4JuzDVKp+WOeakp/RJJH9MyjGm34wUw74UApb/3xJxN3TObfr3Pyl8I/blv29ffY0sIXrFy/WJiY6KBAdrMDxlV8wGGpeZFMp0xQICpW/FRx8YPF+lYt37yUbO1uA5A==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b997e97-661e-4d11-acc5-08d7c1d05363
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2020 13:14:40.1079
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XxoOO/b25bGcSXSU1qK+VNyYosCoJdFc+UHotvCIBkRzEdGpYmKzCmN5kKkbVXc7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6718
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the hardware tc flower offloading with dropped frame counter for
status update. action ops->stats_update only loaded by the
tcf_exts_stats_update() and tcf_exts_stats_update() only loaded by
matchall and tc flower hardware filter. But the stats_update only set
the dropped count as default false in the ops->stats_update. This
patch add the dropped counter to action stats update. Its dropped counter
update by the hardware offloading driver.
This is changed by replacing the drop flag with dropped frame counter.

Driver side should update how many "packets" it filtered and how many
"dropped" in those "packets".

Signed-off-by: Po Liu <Po.Liu@nxp.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c         |  2 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c |  2 +-
 .../net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.c   |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c      |  4 ++--
 .../net/ethernet/mellanox/mlxsw/spectrum_flower.c    |  2 +-
 drivers/net/ethernet/mscc/ocelot_flower.c            |  2 +-
 drivers/net/ethernet/netronome/nfp/flower/offload.c  |  2 +-
 drivers/net/ethernet/netronome/nfp/flower/qos_conf.c |  2 +-
 include/net/act_api.h                                | 11 ++++++-----
 include/net/flow_offload.h                           |  5 ++++-
 include/net/pkt_cls.h                                |  5 +++--
 net/sched/act_api.c                                  | 12 ++++++------
 net/sched/act_ct.c                                   |  6 +++---
 net/sched/act_gact.c                                 |  7 ++++---
 net/sched/act_mirred.c                               |  6 +++---
 net/sched/act_police.c                               |  6 +++---
 net/sched/act_vlan.c                                 |  6 +++---
 net/sched/cls_flower.c                               |  3 ++-
 net/sched/cls_matchall.c                             |  3 ++-
 19 files changed, 48 insertions(+), 40 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
index 9bec256b0934..93d4c596940b 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
@@ -1634,7 +1634,7 @@ static int bnxt_tc_get_flow_stats(struct bnxt *bp,
 	spin_unlock(&flow->stats_lock);
 
 	flow_stats_update(&tc_flow_cmd->stats, stats.bytes, stats.packets,
-			  lastused);
+			  lastused, 0);
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
index bb5513bdd293..b8c8a7e24144 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
@@ -836,7 +836,7 @@ int cxgb4_tc_flower_stats(struct net_device *dev,
 			ofld_stats->last_used = jiffies;
 		flow_stats_update(&cls->stats, bytes - ofld_stats->byte_count,
 				  packets - ofld_stats->packet_count,
-				  ofld_stats->last_used);
+				  ofld_stats->last_used, 0);
 
 		ofld_stats->packet_count = packets;
 		ofld_stats->byte_count = bytes;
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.c
index 1b7681a4eb32..8b049e2133e7 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.c
@@ -353,7 +353,7 @@ int cxgb4_tc_matchall_stats(struct net_device *dev,
 		flow_stats_update(&cls_matchall->stats,
 				  bytes - tc_port_matchall->ingress.bytes,
 				  packets - tc_port_matchall->ingress.packets,
-				  tc_port_matchall->ingress.last_used);
+				  tc_port_matchall->ingress.last_used, 0);
 
 		tc_port_matchall->ingress.packets = packets;
 		tc_port_matchall->ingress.bytes = bytes;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 4eb2f2392d2d..1b110e67dc2d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4091,7 +4091,7 @@ int mlx5e_stats_flower(struct net_device *dev, struct mlx5e_priv *priv,
 no_peer_counter:
 	mlx5_devcom_release_peer_data(devcom, MLX5_DEVCOM_ESW_OFFLOADS);
 out:
-	flow_stats_update(&f->stats, bytes, packets, lastuse);
+	flow_stats_update(&f->stats, bytes, packets, lastuse, 0);
 	trace_mlx5e_stats_flower(f);
 errout:
 	mlx5e_flow_put(priv, flow);
@@ -4199,7 +4199,7 @@ void mlx5e_tc_stats_matchall(struct mlx5e_priv *priv,
 	dpkts = cur_stats.rx_packets - rpriv->prev_vf_vport_stats.rx_packets;
 	dbytes = cur_stats.rx_bytes - rpriv->prev_vf_vport_stats.rx_bytes;
 	rpriv->prev_vf_vport_stats = cur_stats;
-	flow_stats_update(&ma->stats, dpkts, dbytes, jiffies);
+	flow_stats_update(&ma->stats, dpkts, dbytes, jiffies, 0);
 }
 
 static void mlx5e_tc_hairpin_update_dead_peer(struct mlx5e_priv *priv,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
index 0011a71114e3..c2f058d8b861 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
@@ -565,7 +565,7 @@ int mlxsw_sp_flower_stats(struct mlxsw_sp *mlxsw_sp,
 	if (err)
 		goto err_rule_get_stats;
 
-	flow_stats_update(&f->stats, bytes, packets, lastuse);
+	flow_stats_update(&f->stats, bytes, packets, lastuse, 0);
 
 	mlxsw_sp_acl_ruleset_put(mlxsw_sp, ruleset);
 	return 0;
diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index 8993dadf063c..9e60a43783c2 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -220,7 +220,7 @@ int ocelot_cls_flower_stats(struct ocelot *ocelot, int port,
 	if (ret)
 		return ret;
 
-	flow_stats_update(&f->stats, 0x0, ace.stats.pkts, 0x0);
+	flow_stats_update(&f->stats, 0x0, ace.stats.pkts, 0x0, 0x0);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(ocelot_cls_flower_stats);
diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index 7ca5c1becfcf..053f647c1ec6 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -1490,7 +1490,7 @@ nfp_flower_get_stats(struct nfp_app *app, struct net_device *netdev,
 		nfp_flower_update_merge_stats(app, nfp_flow);
 
 	flow_stats_update(&flow->stats, priv->stats[ctx_id].bytes,
-			  priv->stats[ctx_id].pkts, priv->stats[ctx_id].used);
+			  priv->stats[ctx_id].pkts, priv->stats[ctx_id].used, 0);
 
 	priv->stats[ctx_id].pkts = 0;
 	priv->stats[ctx_id].bytes = 0;
diff --git a/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c b/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c
index 124a43dc136a..354d64edbec0 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c
@@ -320,7 +320,7 @@ nfp_flower_stats_rate_limiter(struct nfp_app *app, struct net_device *netdev,
 	spin_unlock_bh(&fl_priv->qos_stats_lock);
 
 	flow_stats_update(&flow->stats, diff_bytes, diff_pkts,
-			  repr_priv->qos_table.last_update);
+			  repr_priv->qos_table.last_update, 0);
 	return 0;
 }
 
diff --git a/include/net/act_api.h b/include/net/act_api.h
index 71347a90a9d1..59a40ea7aed6 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -99,7 +99,7 @@ struct tc_action_ops {
 			struct netlink_callback *, int,
 			const struct tc_action_ops *,
 			struct netlink_ext_ack *);
-	void	(*stats_update)(struct tc_action *, u64, u32, u64, bool);
+	void	(*stats_update)(struct tc_action *, u64, u64, u64, u64, bool);
 	size_t  (*get_fill_size)(const struct tc_action *act);
 	struct net_device *(*get_dev)(const struct tc_action *a,
 				      tc_action_priv_destructor *destructor);
@@ -225,8 +225,8 @@ static inline void tcf_action_inc_overlimit_qstats(struct tc_action *a)
 	spin_unlock(&a->tcfa_lock);
 }
 
-void tcf_action_update_stats(struct tc_action *a, u64 bytes, u32 packets,
-			     bool drop, bool hw);
+void tcf_action_update_stats(struct tc_action *a, u64 bytes, u64 packets,
+			     u64 dropped, bool hw);
 int tcf_action_copy_stats(struct sk_buff *, struct tc_action *, int);
 
 int tcf_action_check_ctrlact(int action, struct tcf_proto *tp,
@@ -237,13 +237,14 @@ struct tcf_chain *tcf_action_set_ctrlact(struct tc_action *a, int action,
 #endif /* CONFIG_NET_CLS_ACT */
 
 static inline void tcf_action_stats_update(struct tc_action *a, u64 bytes,
-					   u64 packets, u64 lastuse, bool hw)
+					   u64 packets, u64 lastuse,
+					   u64 dropped, bool hw)
 {
 #ifdef CONFIG_NET_CLS_ACT
 	if (!a->ops->stats_update)
 		return;
 
-	a->ops->stats_update(a, bytes, packets, lastuse, hw);
+	a->ops->stats_update(a, bytes, packets, lastuse, dropped, hw);
 #endif
 }
 
diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index cd3510ac66b0..eb013ffc24f3 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -268,14 +268,17 @@ struct flow_stats {
 	u64	pkts;
 	u64	bytes;
 	u64	lastused;
+	u64	dropped;
 };
 
 static inline void flow_stats_update(struct flow_stats *flow_stats,
-				     u64 bytes, u64 pkts, u64 lastused)
+				     u64 bytes, u64 pkts,
+				     u64 lastused, u64 dropped)
 {
 	flow_stats->pkts	+= pkts;
 	flow_stats->bytes	+= bytes;
 	flow_stats->lastused	= max_t(u64, flow_stats->lastused, lastused);
+	flow_stats->dropped	+= dropped;
 }
 
 enum flow_block_command {
diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 341a66af8d59..d59916a8a95f 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -249,7 +249,7 @@ static inline void tcf_exts_put_net(struct tcf_exts *exts)
 
 static inline void
 tcf_exts_stats_update(const struct tcf_exts *exts,
-		      u64 bytes, u64 packets, u64 lastuse)
+		      u64 bytes, u64 packets, u64 lastuse, u64 dropped)
 {
 #ifdef CONFIG_NET_CLS_ACT
 	int i;
@@ -259,7 +259,8 @@ tcf_exts_stats_update(const struct tcf_exts *exts,
 	for (i = 0; i < exts->nr_actions; i++) {
 		struct tc_action *a = exts->actions[i];
 
-		tcf_action_stats_update(a, bytes, packets, lastuse, true);
+		tcf_action_stats_update(a, bytes, packets,
+					lastuse, dropped, true);
 	}
 
 	preempt_enable();
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 8c466a712cda..4377ee2ee791 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -1017,14 +1017,13 @@ int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
 	return err;
 }
 
-void tcf_action_update_stats(struct tc_action *a, u64 bytes, u32 packets,
-			     bool drop, bool hw)
+void tcf_action_update_stats(struct tc_action *a, u64 bytes, u64 packets,
+			     u64 dropped, bool hw)
 {
 	if (a->cpu_bstats) {
 		_bstats_cpu_update(this_cpu_ptr(a->cpu_bstats), bytes, packets);
 
-		if (drop)
-			this_cpu_ptr(a->cpu_qstats)->drops += packets;
+		this_cpu_ptr(a->cpu_qstats)->drops += dropped;
 
 		if (hw)
 			_bstats_cpu_update(this_cpu_ptr(a->cpu_bstats_hw),
@@ -1033,8 +1032,9 @@ void tcf_action_update_stats(struct tc_action *a, u64 bytes, u32 packets,
 	}
 
 	_bstats_update(&a->tcfa_bstats, bytes, packets);
-	if (drop)
-		a->tcfa_qstats.drops += packets;
+
+	a->tcfa_qstats.drops += dropped;
+
 	if (hw)
 		_bstats_update(&a->tcfa_bstats_hw, bytes, packets);
 }
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 23eba61f0f81..3cd9d7e97a05 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -1232,12 +1232,12 @@ static int tcf_ct_search(struct net *net, struct tc_action **a, u32 index)
 	return tcf_idr_search(tn, a, index);
 }
 
-static void tcf_stats_update(struct tc_action *a, u64 bytes, u32 packets,
-			     u64 lastuse, bool hw)
+static void tcf_stats_update(struct tc_action *a, u64 bytes, u64 packets,
+			     u64 lastuse, u64 dropped, bool hw)
 {
 	struct tcf_ct *c = to_ct(a);
 
-	tcf_action_update_stats(a, bytes, packets, false, hw);
+	tcf_action_update_stats(a, bytes, packets, dropped, hw);
 	c->tcf_tm.lastuse = max_t(u64, c->tcf_tm.lastuse, lastuse);
 }
 
diff --git a/net/sched/act_gact.c b/net/sched/act_gact.c
index 416065772719..173908368dcc 100644
--- a/net/sched/act_gact.c
+++ b/net/sched/act_gact.c
@@ -171,14 +171,15 @@ static int tcf_gact_act(struct sk_buff *skb, const struct tc_action *a,
 	return action;
 }
 
-static void tcf_gact_stats_update(struct tc_action *a, u64 bytes, u32 packets,
-				  u64 lastuse, bool hw)
+static void tcf_gact_stats_update(struct tc_action *a, u64 bytes, u64 packets,
+				  u64 lastuse, u64 dropped, bool hw)
 {
 	struct tcf_gact *gact = to_gact(a);
 	int action = READ_ONCE(gact->tcf_action);
 	struct tcf_t *tm = &gact->tcf_tm;
 
-	tcf_action_update_stats(a, bytes, packets, action == TC_ACT_SHOT, hw);
+	tcf_action_update_stats(a, bytes, packets,
+				(action == TC_ACT_SHOT) ? packets : 0, hw);
 	tm->lastuse = max_t(u64, tm->lastuse, lastuse);
 }
 
diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index 1ad300e6dbc0..1c56f59e86a8 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -314,13 +314,13 @@ static int tcf_mirred_act(struct sk_buff *skb, const struct tc_action *a,
 	return retval;
 }
 
-static void tcf_stats_update(struct tc_action *a, u64 bytes, u32 packets,
-			     u64 lastuse, bool hw)
+static void tcf_stats_update(struct tc_action *a, u64 bytes, u64 packets,
+			     u64 lastuse, u64 dropped, bool hw)
 {
 	struct tcf_mirred *m = to_mirred(a);
 	struct tcf_t *tm = &m->tcf_tm;
 
-	tcf_action_update_stats(a, bytes, packets, false, hw);
+	tcf_action_update_stats(a, bytes, packets, dropped, hw);
 	tm->lastuse = max_t(u64, tm->lastuse, lastuse);
 }
 
diff --git a/net/sched/act_police.c b/net/sched/act_police.c
index 8b7a0ac96c51..7dcc418043fc 100644
--- a/net/sched/act_police.c
+++ b/net/sched/act_police.c
@@ -288,13 +288,13 @@ static void tcf_police_cleanup(struct tc_action *a)
 }
 
 static void tcf_police_stats_update(struct tc_action *a,
-				    u64 bytes, u32 packets,
-				    u64 lastuse, bool hw)
+				    u64 bytes, u64 packets,
+				    u64 lastuse, u64 dropped, bool hw)
 {
 	struct tcf_police *police = to_police(a);
 	struct tcf_t *tm = &police->tcf_tm;
 
-	tcf_action_update_stats(a, bytes, packets, false, hw);
+	tcf_action_update_stats(a, bytes, packets, dropped, hw);
 	tm->lastuse = max_t(u64, tm->lastuse, lastuse);
 }
 
diff --git a/net/sched/act_vlan.c b/net/sched/act_vlan.c
index c91d3958fcbb..d579ce23b479 100644
--- a/net/sched/act_vlan.c
+++ b/net/sched/act_vlan.c
@@ -302,13 +302,13 @@ static int tcf_vlan_walker(struct net *net, struct sk_buff *skb,
 	return tcf_generic_walker(tn, skb, cb, type, ops, extack);
 }
 
-static void tcf_vlan_stats_update(struct tc_action *a, u64 bytes, u32 packets,
-				  u64 lastuse, bool hw)
+static void tcf_vlan_stats_update(struct tc_action *a, u64 bytes, u64 packets,
+				  u64 lastuse, u64 dropped, bool hw)
 {
 	struct tcf_vlan *v = to_vlan(a);
 	struct tcf_t *tm = &v->tcf_tm;
 
-	tcf_action_update_stats(a, bytes, packets, false, hw);
+	tcf_action_update_stats(a, bytes, packets, dropped, hw);
 	tm->lastuse = max_t(u64, tm->lastuse, lastuse);
 }
 
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 258dc45ab7e3..8afaaabef15d 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -492,7 +492,8 @@ static void fl_hw_update_stats(struct tcf_proto *tp, struct cls_fl_filter *f,
 
 	tcf_exts_stats_update(&f->exts, cls_flower.stats.bytes,
 			      cls_flower.stats.pkts,
-			      cls_flower.stats.lastused);
+			      cls_flower.stats.lastused,
+			      cls_flower.stats.dropped);
 }
 
 static void __fl_put(struct cls_fl_filter *f)
diff --git a/net/sched/cls_matchall.c b/net/sched/cls_matchall.c
index a34b36adb9b7..606c131d4df7 100644
--- a/net/sched/cls_matchall.c
+++ b/net/sched/cls_matchall.c
@@ -338,7 +338,8 @@ static void mall_stats_hw_filter(struct tcf_proto *tp,
 	tc_setup_cb_call(block, TC_SETUP_CLSMATCHALL, &cls_mall, false, true);
 
 	tcf_exts_stats_update(&head->exts, cls_mall.stats.bytes,
-			      cls_mall.stats.pkts, cls_mall.stats.lastused);
+			      cls_mall.stats.pkts, cls_mall.stats.lastused,
+			      cls_mall.stats.dropped);
 }
 
 static int mall_dump(struct net *net, struct tcf_proto *tp, void *fh,
-- 
2.17.1

