Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C778190421
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 05:08:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726081AbgCXEIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 00:08:11 -0400
Received: from mail-eopbgr130070.outbound.protection.outlook.com ([40.107.13.70]:62438
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725784AbgCXEIL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Mar 2020 00:08:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l43ucXddk1kxcRj1wLH9WDBLddBBkuwQRnlAi1jlR3li3D/+RuqhgcUz7Ed5QuoKFsIYl6H5GeZBKlG+3xK3KvjE+B8Ad5pGg5dDCLW7hsJ3z/96CXsGtGyAWW8zMlUcsmGYv0Pmr7kNtO7yt6dA408Sywx6ILkDbegPOso2Kro7d5DKgJ7rkqu37+ZMUsaAtZBtfVB5DgptRg13U0oXp1JLlzGvZ+2pfZI/q953Kg3iEK9qKRZ9DLlygf1QGzz5MgIkvmM7VmVoxEnOVK8OQDabMROPUqergB91qD64oQsBdemUL0MzJ2XUuIoecRqj5vI3nuPju414PsMr6ZcCaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ahJkev7xepEXzNgGe15+m6LmTNhZBVbDOg6WV664PmI=;
 b=LG1PCG5lUZUgBuv5VZtvQa4HrWIp9s7UG84fUHIWHw7RXdapfqTifYFlj2+CUTjrahiJ4ka5ArrYYmFhNjg2tpV5kCo6i77OMlViCtDFYGtHABY8JBNuPmGqmcMGr28hW8IZO1qkfWehJwV2rFzwkpOdjXiUCCGCWapTsxUOOXiD//svjKnnG8Vo1tvECI/NFRr0+k7chwbOuEfyTMMamp50OaIxiegBze8w3aBJrJwFsRnUH42XJ7FOLdkAReGGvT8jJrnHF0FM0s5dPpXg/yzY27B861DaA0Ku3xJvAKnpUukbqIa3Jw2Lv1+l9hj54h2vn6nIWuhgPhtcBfjn3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ahJkev7xepEXzNgGe15+m6LmTNhZBVbDOg6WV664PmI=;
 b=W6iZY87LIy5aILgcawjIzZxfuF56kOQG2bzeXBqiMp2PzvjLB6oMEKajG7v0LgjMpLldqcIzNyVwUjAAC6L+oArw4YOoHoKRP/aRgoUvL8Z7bxrm0QoldjHsNEkoNwPSG9nYprFf1hh+c0leGLSJiLxpixCxjuiNrmbqvt1+h+4=
Authentication-Results: spf=none (sender IP is ) smtp.mailfrom=po.liu@nxp.com; 
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (20.179.232.221) by
 VE1PR04MB6413.eurprd04.prod.outlook.com (20.179.232.94) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.22; Tue, 24 Mar 2020 04:07:26 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::8cb8:5c41:d843:b66d]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::8cb8:5c41:d843:b66d%5]) with mapi id 15.20.2835.021; Tue, 24 Mar 2020
 04:07:26 +0000
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
        simon.horman@netronome.com, pablo@netfilter.org,
        moshe@mellanox.com, m-karicheri2@ti.com,
        andre.guedes@linux.intel.com, stephen@networkplumber.org,
        Po Liu <Po.Liu@nxp.com>
Subject: [v1,net-next  1/5] net: qos offload add flow status with dropped count
Date:   Tue, 24 Mar 2020 11:47:39 +0800
Message-Id: <20200324034745.30979-2-Po.Liu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200324034745.30979-1-Po.Liu@nxp.com>
References: <20200306125608.11717-11-Po.Liu@nxp.com>
 <20200324034745.30979-1-Po.Liu@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0204.apcprd06.prod.outlook.com (2603:1096:4:1::36)
 To VE1PR04MB6496.eurprd04.prod.outlook.com (2603:10a6:803:11c::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.73) by SG2PR06CA0204.apcprd06.prod.outlook.com (2603:1096:4:1::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.20 via Frontend Transport; Tue, 24 Mar 2020 04:07:17 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.73]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4adc7294-ae13-4c12-64a0-08d7cfa8dc69
X-MS-TrafficTypeDiagnostic: VE1PR04MB6413:|VE1PR04MB6413:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB64137949A58D98D4E971BCD992F10@VE1PR04MB6413.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-Forefront-PRVS: 03524FBD26
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(376002)(396003)(136003)(39860400002)(346002)(16526019)(30864003)(26005)(86362001)(69590400007)(1076003)(478600001)(52116002)(6506007)(186003)(4326008)(7416002)(6512007)(6486002)(8936002)(81166006)(8676002)(81156014)(2906002)(316002)(66556008)(6666004)(956004)(66476007)(5660300002)(66946007)(36756003)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:VE1PR04MB6413;H:VE1PR04MB6496.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
Received-SPF: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Rl5d6ADXbgiLuitGHEvc+ZI5zwYuFefd85o4mlQpEKWmpaMcxRCf86yFwRiOppQ+d3RpSyCNuFBHbfNcQ8DHEb+WMdQGukJh2Q6mdNeyx3wZ1tXlPgoQtVN9wcYYQibiaVaDNuovljNP3ERjaOFGcbxMeSCVKemOEBXABhGEE5VqKt8mqdCqtQqSKUJk+hxC7GWEJGZ82ocUWo4lcUPt8JU+cWyPYzNL93YEC9q7tBs1a/9PLRSL3eckP0VLLPkynHaX40hOmX5YA5VTv3prbzs110F+H9+2flsS4y0t+lKDs07lj/XCeH2HmYby5oujQQCG25AwLYcNikjZyYoYrxRVWewnZQ6PHr56ZlzGpDHWL4bL2H7d058MmD6cdSgBYxUmlftg0USH10z81w5C/4KWzjeZys/Y1TsjMItAQdDoSVXVR8omImNOy1RFBUaHCfOlRL+2pn7JlC7+Yyvbz42PXNLoF4BqquxNIt6qx7D1jjC7jhsT08H/F2QtjIUR
X-MS-Exchange-AntiSpam-MessageData: TvgxQySItPMfKGkThEj9iVPQGQmeIvd55439yCU9pwy5IIaKdKX2I735aXovdGWPOm4qeHFyO+CjvE2ePudCjxnWs/JphG6CdnjV7z0As8FWn2VptB3a2e9JQwRhrDH7TsIykhFpmg+KbOidmaXDmw==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4adc7294-ae13-4c12-64a0-08d7cfa8dc69
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2020 04:07:26.1131
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PeRjdwAALFM7OwbUloQVWlIUv+4WplLmHeR1t5ipDmos6zTnATUNyKeL4wj9ajXu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6413
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
index b19be7549aad..d14b33fe745c 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
@@ -1639,7 +1639,7 @@ static int bnxt_tc_get_flow_stats(struct bnxt *bp,
 	spin_unlock(&flow->stats_lock);
 
 	flow_stats_update(&tc_flow_cmd->stats, stats.bytes, stats.packets,
-			  lastused);
+			  lastused, 0);
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
index aec9b90313e7..c0d9bc9e6cb7 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
@@ -903,7 +903,7 @@ int cxgb4_tc_flower_stats(struct net_device *dev,
 			ofld_stats->last_used = jiffies;
 		flow_stats_update(&cls->stats, bytes - ofld_stats->byte_count,
 				  packets - ofld_stats->packet_count,
-				  ofld_stats->last_used);
+				  ofld_stats->last_used, 0);
 
 		ofld_stats->packet_count = packets;
 		ofld_stats->byte_count = bytes;
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.c
index 8a5ae8bc9b7d..d2451836d5fd 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.c
@@ -346,7 +346,7 @@ int cxgb4_tc_matchall_stats(struct net_device *dev,
 		flow_stats_update(&cls_matchall->stats,
 				  bytes - tc_port_matchall->ingress.bytes,
 				  packets - tc_port_matchall->ingress.packets,
-				  tc_port_matchall->ingress.last_used);
+				  tc_port_matchall->ingress.last_used, 0);
 
 		tc_port_matchall->ingress.packets = packets;
 		tc_port_matchall->ingress.bytes = bytes;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 901f88a886c8..ca1b694d13d4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4467,7 +4467,7 @@ int mlx5e_stats_flower(struct net_device *dev, struct mlx5e_priv *priv,
 no_peer_counter:
 	mlx5_devcom_release_peer_data(devcom, MLX5_DEVCOM_ESW_OFFLOADS);
 out:
-	flow_stats_update(&f->stats, bytes, packets, lastuse);
+	flow_stats_update(&f->stats, bytes, packets, lastuse, 0);
 	trace_mlx5e_stats_flower(f);
 errout:
 	mlx5e_flow_put(priv, flow);
@@ -4584,7 +4584,7 @@ void mlx5e_tc_stats_matchall(struct mlx5e_priv *priv,
 	dpkts = cur_stats.rx_packets - rpriv->prev_vf_vport_stats.rx_packets;
 	dbytes = cur_stats.rx_bytes - rpriv->prev_vf_vport_stats.rx_bytes;
 	rpriv->prev_vf_vport_stats = cur_stats;
-	flow_stats_update(&ma->stats, dpkts, dbytes, jiffies);
+	flow_stats_update(&ma->stats, dpkts, dbytes, jiffies, 0);
 }
 
 static void mlx5e_tc_hairpin_update_dead_peer(struct mlx5e_priv *priv,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
index 1cb023955d8f..f1d90ffa5eae 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
@@ -578,7 +578,7 @@ int mlxsw_sp_flower_stats(struct mlxsw_sp *mlxsw_sp,
 	if (err)
 		goto err_rule_get_stats;
 
-	flow_stats_update(&f->stats, bytes, packets, lastuse);
+	flow_stats_update(&f->stats, bytes, packets, lastuse, 0);
 
 	mlxsw_sp_acl_ruleset_put(mlxsw_sp, ruleset);
 	return 0;
diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index 873a9944fbfb..6cbca9b05520 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -224,7 +224,7 @@ int ocelot_cls_flower_stats(struct ocelot *ocelot, int port,
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
index 41337c7fc728..7bb03ee2f747 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -103,7 +103,7 @@ struct tc_action_ops {
 			struct netlink_callback *, int,
 			const struct tc_action_ops *,
 			struct netlink_ext_ack *);
-	void	(*stats_update)(struct tc_action *, u64, u32, u64, bool);
+	void	(*stats_update)(struct tc_action *, u64, u64, u64, u64, bool);
 	size_t  (*get_fill_size)(const struct tc_action *act);
 	struct net_device *(*get_dev)(const struct tc_action *a,
 				      tc_action_priv_destructor *destructor);
@@ -229,8 +229,8 @@ static inline void tcf_action_inc_overlimit_qstats(struct tc_action *a)
 	spin_unlock(&a->tcfa_lock);
 }
 
-void tcf_action_update_stats(struct tc_action *a, u64 bytes, u32 packets,
-			     bool drop, bool hw);
+void tcf_action_update_stats(struct tc_action *a, u64 bytes, u64 packets,
+			     u64 dropped, bool hw);
 int tcf_action_copy_stats(struct sk_buff *, struct tc_action *, int);
 
 int tcf_action_check_ctrlact(int action, struct tcf_proto *tp,
@@ -241,13 +241,14 @@ struct tcf_chain *tcf_action_set_ctrlact(struct tc_action *a, int action,
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
index 51b9893d4ccb..cae3658a1844 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -369,14 +369,17 @@ struct flow_stats {
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
index 1db8b27d4515..4d12d3edeb71 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -262,7 +262,7 @@ static inline void tcf_exts_put_net(struct tcf_exts *exts)
 
 static inline void
 tcf_exts_stats_update(const struct tcf_exts *exts,
-		      u64 bytes, u64 packets, u64 lastuse)
+		      u64 bytes, u64 packets, u64 lastuse, u64 dropped)
 {
 #ifdef CONFIG_NET_CLS_ACT
 	int i;
@@ -272,7 +272,8 @@ tcf_exts_stats_update(const struct tcf_exts *exts,
 	for (i = 0; i < exts->nr_actions; i++) {
 		struct tc_action *a = exts->actions[i];
 
-		tcf_action_stats_update(a, bytes, packets, lastuse, true);
+		tcf_action_stats_update(a, bytes, packets,
+					lastuse, dropped, true);
 	}
 
 	preempt_enable();
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index aa7b737fed2e..83ffb3fb63f4 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -1053,14 +1053,13 @@ int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
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
@@ -1069,8 +1068,9 @@ void tcf_action_update_stats(struct tc_action *a, u64 bytes, u32 packets,
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
index 56b66d215a89..f8eda414537c 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -1445,12 +1445,12 @@ static int tcf_ct_search(struct net *net, struct tc_action **a, u32 index)
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

