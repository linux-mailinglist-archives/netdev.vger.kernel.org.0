Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF29F2001D0
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 08:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728851AbgFSF7y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 01:59:54 -0400
Received: from mail-vi1eur05on2047.outbound.protection.outlook.com ([40.107.21.47]:28096
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725446AbgFSF7v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Jun 2020 01:59:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=maIWKtUN+2qM2bYgZGOLWhc2Pbd1C7ljNSHXAMT4N2SXCdamMxYjazloyEciFzQmz7RgN2zjq9KtmOt/OgLGC7yCOeOEcl/jGK/rN6Iqe4RWr7wvyS5YiZT/w6QMjjE3jnm7Ou0D7auVk5Qa6ur7uOJBnylt4MZ3Wf7GsnzyESwmbzL9oEtsKu10EzneQob6Nja2qR+nJXBMe+ZNxOEJ9qJVwUtg/ISxtdUiuMoaW7O7r9hkHohbBLsA/jPHTUFHKHxtXNnBRfv0aFveHnan+OSHbSzrXRFoA7HtQ4qGnwF9ZRCBuInnjJEGzSNQ/YuGinyA/jy02UcINami98HOug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hp0CqdilllcOye+0I0DAV+BSpR42yDhv3YTOvh7b5EM=;
 b=mU/LcoS+/kouzsB8KfmRRw+kqqaMGVHNQFH03C3Lf6vLrJ4/V6o3sGe6Y2UxoL3jZpprkG5Y1kKmYIF1bivbTQ5MTCKVGoSzvEOquLITV9qxDreAyKYSqOpZWywuAdMloUSLPKhNZcUlp+PBEUy3B3itYfAXZ+5/0gM7B5Dr1tnmff0Dqyh2GhwUZ5taV32wdMjwpeM3XOROK0rlUC0uwKXmpWN/NZ7AQQ2cPQPrX0QdSM2RW7opFMKp51Vc887KLscaLrpTtNpTq4ojVe0O6ZeKuAUMgDwDnE5T6Y9f7s5oCfuEtSwNOEjB81m+HVD4f7LzBR2GeQ8BCe0fGutLWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hp0CqdilllcOye+0I0DAV+BSpR42yDhv3YTOvh7b5EM=;
 b=Z4ZpN6M4GI6stLmm+uDkhu2CsJyP5PW50paizSinuu2x95C0Gx22Vvf7m1OaFEgR5t3QVSWgxU8hUOwHycDpw8C/nhkX7ajGDprbxt7R8x8Cc/lrqEVBbmirVDOt6HLZsN63Vp162v+cYPu5AhRfNJSwRh7MLOgdQoPyPOsz+tM=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (2603:10a6:803:11c::29)
 by VE1PR04MB6589.eurprd04.prod.outlook.com (2603:10a6:803:128::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.23; Fri, 19 Jun
 2020 05:59:46 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::c1ea:5943:40e8:58f1]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::c1ea:5943:40e8:58f1%3]) with mapi id 15.20.3109.021; Fri, 19 Jun 2020
 05:59:46 +0000
From:   Po Liu <po.liu@nxp.com>
To:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, jiri@resnulli.us
Cc:     vinicius.gomes@intel.com, vlad@buslov.dev, claudiu.manoil@nxp.com,
        vladimir.oltean@nxp.com, alexandru.marginean@nxp.com,
        michael.chan@broadcom.com, vishal@chelsio.com, saeedm@mellanox.com,
        leon@kernel.org, jiri@mellanox.com, idosch@mellanox.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        kuba@kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        simon.horman@netronome.com, pablo@netfilter.org,
        moshe@mellanox.com, m-karicheri2@ti.com,
        andre.guedes@linux.intel.com, stephen@networkplumber.org,
        Po Liu <Po.Liu@nxp.com>
Subject: [v2,net-next] net: qos offload add flow status with dropped count
Date:   Fri, 19 Jun 2020 14:01:07 +0800
Message-Id: <20200619060107.6325-1-po.liu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200324034745.30979-1-Po.Liu@nxp.com>
References: <20200324034745.30979-1-Po.Liu@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR03CA0115.apcprd03.prod.outlook.com
 (2603:1096:4:91::19) To VE1PR04MB6496.eurprd04.prod.outlook.com
 (2603:10a6:803:11c::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tsn.ap.freescale.net (119.31.174.73) by SG2PR03CA0115.apcprd03.prod.outlook.com (2603:1096:4:91::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.10 via Frontend Transport; Fri, 19 Jun 2020 05:59:38 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.73]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 280bf300-eeb4-4ce9-8a36-08d81415f7f1
X-MS-TrafficTypeDiagnostic: VE1PR04MB6589:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB6589BE46ACA1B97608E68A5A92980@VE1PR04MB6589.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-Forefront-PRVS: 0439571D1D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ab+qIskTU+53IR6HxQ0R/6w2y+RY0+iPMgS7558p0pP6jpdSvF4GxYTk5ryPPmyDnIpfyMZMqV3OdGwsxTMS3kz3UpOeDrho5T+ksfI8VYx6MZX7wQ9kY0vt8GHtOta6T+ODphSEzvxZWxH4QZGaiW0sTC155MlHmMfn8kN97rPZUSzqO9Aphwv1sNDP2pYsKKH4dnO17UqKVtiHAbpKP3HsA/tniu9XFCAEDt4i8L858vsBLdu3rti09sLkQtj2jbjcR++eSPvMQE3w20K/I5MfCuzDNe1O2Ur1c/CFUMF41LKWfnSyiFiKRwi6gUb8E34vpYgIZFFgEGsY6QkxJg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6496.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(136003)(39860400002)(376002)(396003)(346002)(316002)(26005)(186003)(44832011)(83380400001)(8936002)(16526019)(6486002)(30864003)(6506007)(5660300002)(4326008)(6512007)(2906002)(52116002)(66556008)(66476007)(66946007)(1076003)(956004)(2616005)(478600001)(6666004)(7416002)(36756003)(8676002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: B7yL8Pm3qiink9mRLMtvZXrjz04ZHzzouh4WF+HgjnmRmQCpL4aeXrXNz0xHyO36RPq0D6JAPDiIt4XxzWFodWwsd5Fms22yKamPEju22kNfuIKe+9JkPMgcHPopTzc30yP5Zs+i6rykPRSnrxGciR8v1/TIpudDe4V4c2piWx0goTnxvkCjO1g8HA2GAlrVvFRGa+Ur//LaIryEhZKv3/2vdnSg9TMxWpHbcZZ36mkQU6abOIsnuFbYSe0pz6CgOFMKlPpGvRr5MBt4/k3Rs09EYpCyZjy2T7/DyF80Y1V4yFSMykRrdjXiKnOSaXhmaVRenoR9FokKDq7vG9QyTzccvWrlNzgKTS3UOt6j3P/3oDMo2hyDdHA3V9HZgycPp2xB8/21mv2YBdyLDAJ5yqRSLiDC/CFWAaoc7DP7vShuAgQwz0mi+4FbvtVRpyDGKsW4YCZsbbhFSdIEjLYsjlKXUQBL6CPbY3ieFbpDXfs=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 280bf300-eeb4-4ce9-8a36-08d81415f7f1
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2020 05:59:46.4433
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZVy9gADs+DgwvHe+9LWjmrN8sLI43/s8e0WxErUQX2GJr62G/I2zYRFHrgc62auz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6589
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Po Liu <Po.Liu@nxp.com>

This patch adds a drop frames counter to tc flower offloading.
Reporting h/w dropped frames is necessary for some actions.
Some actions like police action and the coming introduced stream gate
action would produce dropped frames which is necessary for user. Status
update shows how many filtered packets increasing and how many dropped
in those packets.

v2: Changes
 - Update commit comments suggest by Jiri Pirko.

Signed-off-by: Po Liu <Po.Liu@nxp.com>
---
This patch is continue the thread 20200324034745.30979-1-Po.Liu@nxp.com

 drivers/net/dsa/sja1105/sja1105_vl.c                  |  2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c          |  2 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c  |  2 +-
 .../net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.c    |  2 +-
 drivers/net/ethernet/freescale/enetc/enetc_qos.c      |  7 +++++--
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c    |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c       |  4 ++--
 drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c |  2 +-
 drivers/net/ethernet/mscc/ocelot_flower.c             |  2 +-
 drivers/net/ethernet/netronome/nfp/flower/offload.c   |  2 +-
 drivers/net/ethernet/netronome/nfp/flower/qos_conf.c  |  2 +-
 include/net/act_api.h                                 | 11 ++++++-----
 include/net/flow_offload.h                            |  5 ++++-
 include/net/pkt_cls.h                                 |  5 +++--
 net/sched/act_api.c                                   | 10 ++++------
 net/sched/act_ct.c                                    |  6 +++---
 net/sched/act_gact.c                                  |  7 ++++---
 net/sched/act_gate.c                                  |  6 +++---
 net/sched/act_mirred.c                                |  6 +++---
 net/sched/act_pedit.c                                 |  6 +++---
 net/sched/act_police.c                                |  4 ++--
 net/sched/act_skbedit.c                               |  5 +++--
 net/sched/act_vlan.c                                  |  6 +++---
 net/sched/cls_flower.c                                |  1 +
 net/sched/cls_matchall.c                              |  3 ++-
 25 files changed, 60 insertions(+), 50 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_vl.c b/drivers/net/dsa/sja1105/sja1105_vl.c
index bdfd6c4e190d..9ddc49b7eb8f 100644
--- a/drivers/net/dsa/sja1105/sja1105_vl.c
+++ b/drivers/net/dsa/sja1105/sja1105_vl.c
@@ -771,7 +771,7 @@ int sja1105_vl_stats(struct sja1105_private *priv, int port,
 
 	pkts = timingerr + unreleased + lengtherr;
 
-	flow_stats_update(stats, 0, pkts - rule->vl.stats.pkts,
+	flow_stats_update(stats, 0, pkts - rule->vl.stats.pkts, 0,
 			  jiffies - rule->vl.stats.lastused,
 			  FLOW_ACTION_HW_STATS_IMMEDIATE);
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
index 0eef4f5e4a46..4d482d75a20b 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
@@ -1638,7 +1638,7 @@ static int bnxt_tc_get_flow_stats(struct bnxt *bp,
 	lastused = flow->lastused;
 	spin_unlock(&flow->stats_lock);
 
-	flow_stats_update(&tc_flow_cmd->stats, stats.bytes, stats.packets,
+	flow_stats_update(&tc_flow_cmd->stats, stats.bytes, stats.packets, 0,
 			  lastused, FLOW_ACTION_HW_STATS_DELAYED);
 	return 0;
 }
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
index 4a5fa9eba0b6..030de20a5d27 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
@@ -902,7 +902,7 @@ int cxgb4_tc_flower_stats(struct net_device *dev,
 		if (ofld_stats->prev_packet_count != packets)
 			ofld_stats->last_used = jiffies;
 		flow_stats_update(&cls->stats, bytes - ofld_stats->byte_count,
-				  packets - ofld_stats->packet_count,
+				  packets - ofld_stats->packet_count, 0,
 				  ofld_stats->last_used,
 				  FLOW_ACTION_HW_STATS_IMMEDIATE);
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.c
index c88c47a14fbb..c439b5bce9c9 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.c
@@ -346,7 +346,7 @@ int cxgb4_tc_matchall_stats(struct net_device *dev,
 		flow_stats_update(&cls_matchall->stats,
 				  bytes - tc_port_matchall->ingress.bytes,
 				  packets - tc_port_matchall->ingress.packets,
-				  tc_port_matchall->ingress.last_used,
+				  0, tc_port_matchall->ingress.last_used,
 				  FLOW_ACTION_HW_STATS_IMMEDIATE);
 
 		tc_port_matchall->ingress.packets = packets;
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
index fd3df19eaa32..fb76903eca90 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -1291,12 +1291,15 @@ static int enetc_psfp_get_stats(struct enetc_ndev_priv *priv,
 
 	spin_lock(&epsfp.psfp_lock);
 	stats.pkts = counters.matching_frames_count - filter->stats.pkts;
+	stats.drops = counters.not_passing_frames_count -
+					filter->stats.drops;
 	stats.lastused = filter->stats.lastused;
 	filter->stats.pkts += stats.pkts;
+	filter->stats.drops += stats.drops;
 	spin_unlock(&epsfp.psfp_lock);
 
-	flow_stats_update(&f->stats, 0x0, stats.pkts, stats.lastused,
-			  FLOW_ACTION_HW_STATS_DELAYED);
+	flow_stats_update(&f->stats, 0x0, stats.pkts, stats.drops,
+			  stats.lastused, FLOW_ACTION_HW_STATS_DELAYED);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index 430025550fad..c7107da03212 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -672,7 +672,7 @@ mlx5_tc_ct_block_flow_offload_stats(struct mlx5_ct_ft *ft,
 		return -ENOENT;
 
 	mlx5_fc_query_cached(entry->counter, &bytes, &packets, &lastuse);
-	flow_stats_update(&f->stats, bytes, packets, lastuse,
+	flow_stats_update(&f->stats, bytes, packets, 0, lastuse,
 			  FLOW_ACTION_HW_STATS_DELAYED);
 
 	return 0;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 7fc84f58e28a..bc9c0ac15f99 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4828,7 +4828,7 @@ int mlx5e_stats_flower(struct net_device *dev, struct mlx5e_priv *priv,
 no_peer_counter:
 	mlx5_devcom_release_peer_data(devcom, MLX5_DEVCOM_ESW_OFFLOADS);
 out:
-	flow_stats_update(&f->stats, bytes, packets, lastuse,
+	flow_stats_update(&f->stats, bytes, packets, 0, lastuse,
 			  FLOW_ACTION_HW_STATS_DELAYED);
 	trace_mlx5e_stats_flower(f);
 errout:
@@ -4946,7 +4946,7 @@ void mlx5e_tc_stats_matchall(struct mlx5e_priv *priv,
 	dpkts = cur_stats.rx_packets - rpriv->prev_vf_vport_stats.rx_packets;
 	dbytes = cur_stats.rx_bytes - rpriv->prev_vf_vport_stats.rx_bytes;
 	rpriv->prev_vf_vport_stats = cur_stats;
-	flow_stats_update(&ma->stats, dbytes, dpkts, jiffies,
+	flow_stats_update(&ma->stats, dbytes, dpkts, 0, jiffies,
 			  FLOW_ACTION_HW_STATS_DELAYED);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
index 51e1b3930c56..61d21043d83a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
@@ -633,7 +633,7 @@ int mlxsw_sp_flower_stats(struct mlxsw_sp *mlxsw_sp,
 	if (err)
 		goto err_rule_get_stats;
 
-	flow_stats_update(&f->stats, bytes, packets, lastuse, used_hw_stats);
+	flow_stats_update(&f->stats, bytes, packets, 0, lastuse, used_hw_stats);
 
 	mlxsw_sp_acl_ruleset_put(mlxsw_sp, ruleset);
 	return 0;
diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index 5ce172e22b43..c90bafbd651f 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -244,7 +244,7 @@ int ocelot_cls_flower_stats(struct ocelot *ocelot, int port,
 	if (ret)
 		return ret;
 
-	flow_stats_update(&f->stats, 0x0, ace.stats.pkts, 0x0,
+	flow_stats_update(&f->stats, 0x0, ace.stats.pkts, 0, 0x0,
 			  FLOW_ACTION_HW_STATS_IMMEDIATE);
 	return 0;
 }
diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index 695d24b9dd92..234c652700e1 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -1491,7 +1491,7 @@ nfp_flower_get_stats(struct nfp_app *app, struct net_device *netdev,
 		nfp_flower_update_merge_stats(app, nfp_flow);
 
 	flow_stats_update(&flow->stats, priv->stats[ctx_id].bytes,
-			  priv->stats[ctx_id].pkts, priv->stats[ctx_id].used,
+			  priv->stats[ctx_id].pkts, 0, priv->stats[ctx_id].used,
 			  FLOW_ACTION_HW_STATS_DELAYED);
 
 	priv->stats[ctx_id].pkts = 0;
diff --git a/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c b/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c
index d18a830e4264..bb327d48d1ab 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c
@@ -319,7 +319,7 @@ nfp_flower_stats_rate_limiter(struct nfp_app *app, struct net_device *netdev,
 	prev_stats->bytes = curr_stats->bytes;
 	spin_unlock_bh(&fl_priv->qos_stats_lock);
 
-	flow_stats_update(&flow->stats, diff_bytes, diff_pkts,
+	flow_stats_update(&flow->stats, diff_bytes, diff_pkts, 0,
 			  repr_priv->qos_table.last_update,
 			  FLOW_ACTION_HW_STATS_DELAYED);
 	return 0;
diff --git a/include/net/act_api.h b/include/net/act_api.h
index 8c3934880670..cb382a89ea58 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -106,7 +106,7 @@ struct tc_action_ops {
 			struct netlink_callback *, int,
 			const struct tc_action_ops *,
 			struct netlink_ext_ack *);
-	void	(*stats_update)(struct tc_action *, u64, u32, u64, bool);
+	void	(*stats_update)(struct tc_action *, u64, u64, u64, u64, bool);
 	size_t  (*get_fill_size)(const struct tc_action *act);
 	struct net_device *(*get_dev)(const struct tc_action *a,
 				      tc_action_priv_destructor *destructor);
@@ -232,8 +232,8 @@ static inline void tcf_action_inc_overlimit_qstats(struct tc_action *a)
 	spin_unlock(&a->tcfa_lock);
 }
 
-void tcf_action_update_stats(struct tc_action *a, u64 bytes, u32 packets,
-			     bool drop, bool hw);
+void tcf_action_update_stats(struct tc_action *a, u64 bytes, u64 packets,
+			     u64 drops, bool hw);
 int tcf_action_copy_stats(struct sk_buff *, struct tc_action *, int);
 
 int tcf_action_check_ctrlact(int action, struct tcf_proto *tp,
@@ -244,13 +244,14 @@ struct tcf_chain *tcf_action_set_ctrlact(struct tc_action *a, int action,
 #endif /* CONFIG_NET_CLS_ACT */
 
 static inline void tcf_action_stats_update(struct tc_action *a, u64 bytes,
-					   u64 packets, u64 lastuse, bool hw)
+					   u64 packets, u64 drops,
+					   u64 lastuse, bool hw)
 {
 #ifdef CONFIG_NET_CLS_ACT
 	if (!a->ops->stats_update)
 		return;
 
-	a->ops->stats_update(a, bytes, packets, lastuse, hw);
+	a->ops->stats_update(a, bytes, packets, drops, lastuse, hw);
 #endif
 }
 
diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index f2c8311a0433..00c15f14c434 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -389,17 +389,20 @@ static inline bool flow_rule_match_key(const struct flow_rule *rule,
 struct flow_stats {
 	u64	pkts;
 	u64	bytes;
+	u64	drops;
 	u64	lastused;
 	enum flow_action_hw_stats used_hw_stats;
 	bool used_hw_stats_valid;
 };
 
 static inline void flow_stats_update(struct flow_stats *flow_stats,
-				     u64 bytes, u64 pkts, u64 lastused,
+				     u64 bytes, u64 pkts,
+				     u64 drops, u64 lastused,
 				     enum flow_action_hw_stats used_hw_stats)
 {
 	flow_stats->pkts	+= pkts;
 	flow_stats->bytes	+= bytes;
+	flow_stats->drops	+= drops;
 	flow_stats->lastused	= max_t(u64, flow_stats->lastused, lastused);
 
 	/* The driver should pass value with a maximum of one bit set.
diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index ed65619cbc47..ff017e5b3ea2 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -262,7 +262,7 @@ static inline void tcf_exts_put_net(struct tcf_exts *exts)
 
 static inline void
 tcf_exts_stats_update(const struct tcf_exts *exts,
-		      u64 bytes, u64 packets, u64 lastuse,
+		      u64 bytes, u64 packets, u64 drops, u64 lastuse,
 		      u8 used_hw_stats, bool used_hw_stats_valid)
 {
 #ifdef CONFIG_NET_CLS_ACT
@@ -273,7 +273,8 @@ tcf_exts_stats_update(const struct tcf_exts *exts,
 	for (i = 0; i < exts->nr_actions; i++) {
 		struct tc_action *a = exts->actions[i];
 
-		tcf_action_stats_update(a, bytes, packets, lastuse, true);
+		tcf_action_stats_update(a, bytes, packets, drops,
+					lastuse, true);
 		a->used_hw_stats = used_hw_stats;
 		a->used_hw_stats_valid = used_hw_stats_valid;
 	}
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 8ac7eb0a8309..4c4466f18801 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -1059,14 +1059,13 @@ int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
 	return err;
 }
 
-void tcf_action_update_stats(struct tc_action *a, u64 bytes, u32 packets,
-			     bool drop, bool hw)
+void tcf_action_update_stats(struct tc_action *a, u64 bytes, u64 packets,
+			     u64 drops, bool hw)
 {
 	if (a->cpu_bstats) {
 		_bstats_cpu_update(this_cpu_ptr(a->cpu_bstats), bytes, packets);
 
-		if (drop)
-			this_cpu_ptr(a->cpu_qstats)->drops += packets;
+		this_cpu_ptr(a->cpu_qstats)->drops += drops;
 
 		if (hw)
 			_bstats_cpu_update(this_cpu_ptr(a->cpu_bstats_hw),
@@ -1075,8 +1074,7 @@ void tcf_action_update_stats(struct tc_action *a, u64 bytes, u32 packets,
 	}
 
 	_bstats_update(&a->tcfa_bstats, bytes, packets);
-	if (drop)
-		a->tcfa_qstats.drops += packets;
+	a->tcfa_qstats.drops += drops;
 	if (hw)
 		_bstats_update(&a->tcfa_bstats_hw, bytes, packets);
 }
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index e9f3576cbf71..1b9c6d4a1b6b 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -1450,12 +1450,12 @@ static int tcf_ct_search(struct net *net, struct tc_action **a, u32 index)
 	return tcf_idr_search(tn, a, index);
 }
 
-static void tcf_stats_update(struct tc_action *a, u64 bytes, u32 packets,
-			     u64 lastuse, bool hw)
+static void tcf_stats_update(struct tc_action *a, u64 bytes, u64 packets,
+			     u64 drops, u64 lastuse, bool hw)
 {
 	struct tcf_ct *c = to_ct(a);
 
-	tcf_action_update_stats(a, bytes, packets, false, hw);
+	tcf_action_update_stats(a, bytes, packets, drops, hw);
 	c->tcf_tm.lastuse = max_t(u64, c->tcf_tm.lastuse, lastuse);
 }
 
diff --git a/net/sched/act_gact.c b/net/sched/act_gact.c
index 416065772719..410e3bbfb9ca 100644
--- a/net/sched/act_gact.c
+++ b/net/sched/act_gact.c
@@ -171,14 +171,15 @@ static int tcf_gact_act(struct sk_buff *skb, const struct tc_action *a,
 	return action;
 }
 
-static void tcf_gact_stats_update(struct tc_action *a, u64 bytes, u32 packets,
-				  u64 lastuse, bool hw)
+static void tcf_gact_stats_update(struct tc_action *a, u64 bytes, u64 packets,
+				  u64 drops, u64 lastuse, bool hw)
 {
 	struct tcf_gact *gact = to_gact(a);
 	int action = READ_ONCE(gact->tcf_action);
 	struct tcf_t *tm = &gact->tcf_tm;
 
-	tcf_action_update_stats(a, bytes, packets, action == TC_ACT_SHOT, hw);
+	tcf_action_update_stats(a, bytes, packets,
+				action == TC_ACT_SHOT ? packets : drops, hw);
 	tm->lastuse = max_t(u64, tm->lastuse, lastuse);
 }
 
diff --git a/net/sched/act_gate.c b/net/sched/act_gate.c
index 9c628591f452..c818844846b1 100644
--- a/net/sched/act_gate.c
+++ b/net/sched/act_gate.c
@@ -568,13 +568,13 @@ static int tcf_gate_walker(struct net *net, struct sk_buff *skb,
 	return tcf_generic_walker(tn, skb, cb, type, ops, extack);
 }
 
-static void tcf_gate_stats_update(struct tc_action *a, u64 bytes, u32 packets,
-				  u64 lastuse, bool hw)
+static void tcf_gate_stats_update(struct tc_action *a, u64 bytes, u64 packets,
+				  u64 drops, u64 lastuse, bool hw)
 {
 	struct tcf_gate *gact = to_gate(a);
 	struct tcf_t *tm = &gact->tcf_tm;
 
-	tcf_action_update_stats(a, bytes, packets, false, hw);
+	tcf_action_update_stats(a, bytes, packets, drops, hw);
 	tm->lastuse = max_t(u64, tm->lastuse, lastuse);
 }
 
diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index 83dd82fc9f40..b2705318993b 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -312,13 +312,13 @@ static int tcf_mirred_act(struct sk_buff *skb, const struct tc_action *a,
 	return retval;
 }
 
-static void tcf_stats_update(struct tc_action *a, u64 bytes, u32 packets,
-			     u64 lastuse, bool hw)
+static void tcf_stats_update(struct tc_action *a, u64 bytes, u64 packets,
+			     u64 drops, u64 lastuse, bool hw)
 {
 	struct tcf_mirred *m = to_mirred(a);
 	struct tcf_t *tm = &m->tcf_tm;
 
-	tcf_action_update_stats(a, bytes, packets, false, hw);
+	tcf_action_update_stats(a, bytes, packets, drops, hw);
 	tm->lastuse = max_t(u64, tm->lastuse, lastuse);
 }
 
diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index d41d6200d9de..66986db062ed 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -409,13 +409,13 @@ static int tcf_pedit_act(struct sk_buff *skb, const struct tc_action *a,
 	return p->tcf_action;
 }
 
-static void tcf_pedit_stats_update(struct tc_action *a, u64 bytes, u32 packets,
-				   u64 lastuse, bool hw)
+static void tcf_pedit_stats_update(struct tc_action *a, u64 bytes, u64 packets,
+				   u64 drops, u64 lastuse, bool hw)
 {
 	struct tcf_pedit *d = to_pedit(a);
 	struct tcf_t *tm = &d->tcf_tm;
 
-	tcf_action_update_stats(a, bytes, packets, false, hw);
+	tcf_action_update_stats(a, bytes, packets, drops, hw);
 	tm->lastuse = max_t(u64, tm->lastuse, lastuse);
 }
 
diff --git a/net/sched/act_police.c b/net/sched/act_police.c
index 8b7a0ac96c51..0b431d493768 100644
--- a/net/sched/act_police.c
+++ b/net/sched/act_police.c
@@ -288,13 +288,13 @@ static void tcf_police_cleanup(struct tc_action *a)
 }
 
 static void tcf_police_stats_update(struct tc_action *a,
-				    u64 bytes, u32 packets,
+				    u64 bytes, u64 packets, u64 drops,
 				    u64 lastuse, bool hw)
 {
 	struct tcf_police *police = to_police(a);
 	struct tcf_t *tm = &police->tcf_tm;
 
-	tcf_action_update_stats(a, bytes, packets, false, hw);
+	tcf_action_update_stats(a, bytes, packets, drops, hw);
 	tm->lastuse = max_t(u64, tm->lastuse, lastuse);
 }
 
diff --git a/net/sched/act_skbedit.c b/net/sched/act_skbedit.c
index b125b2be4467..361b863e0634 100644
--- a/net/sched/act_skbedit.c
+++ b/net/sched/act_skbedit.c
@@ -74,12 +74,13 @@ static int tcf_skbedit_act(struct sk_buff *skb, const struct tc_action *a,
 }
 
 static void tcf_skbedit_stats_update(struct tc_action *a, u64 bytes,
-				     u32 packets, u64 lastuse, bool hw)
+				     u64 packets, u64 drops,
+				     u64 lastuse, bool hw)
 {
 	struct tcf_skbedit *d = to_skbedit(a);
 	struct tcf_t *tm = &d->tcf_tm;
 
-	tcf_action_update_stats(a, bytes, packets, false, hw);
+	tcf_action_update_stats(a, bytes, packets, drops, hw);
 	tm->lastuse = max_t(u64, tm->lastuse, lastuse);
 }
 
diff --git a/net/sched/act_vlan.c b/net/sched/act_vlan.c
index c91d3958fcbb..a5ff9f68ab02 100644
--- a/net/sched/act_vlan.c
+++ b/net/sched/act_vlan.c
@@ -302,13 +302,13 @@ static int tcf_vlan_walker(struct net *net, struct sk_buff *skb,
 	return tcf_generic_walker(tn, skb, cb, type, ops, extack);
 }
 
-static void tcf_vlan_stats_update(struct tc_action *a, u64 bytes, u32 packets,
-				  u64 lastuse, bool hw)
+static void tcf_vlan_stats_update(struct tc_action *a, u64 bytes, u64 packets,
+				  u64 drops, u64 lastuse, bool hw)
 {
 	struct tcf_vlan *v = to_vlan(a);
 	struct tcf_t *tm = &v->tcf_tm;
 
-	tcf_action_update_stats(a, bytes, packets, false, hw);
+	tcf_action_update_stats(a, bytes, packets, drops, hw);
 	tm->lastuse = max_t(u64, tm->lastuse, lastuse);
 }
 
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index b2da37286082..391971672d54 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -491,6 +491,7 @@ static void fl_hw_update_stats(struct tcf_proto *tp, struct cls_fl_filter *f,
 
 	tcf_exts_stats_update(&f->exts, cls_flower.stats.bytes,
 			      cls_flower.stats.pkts,
+			      cls_flower.stats.drops,
 			      cls_flower.stats.lastused,
 			      cls_flower.stats.used_hw_stats,
 			      cls_flower.stats.used_hw_stats_valid);
diff --git a/net/sched/cls_matchall.c b/net/sched/cls_matchall.c
index 8d39dbcf1746..cafb84480bab 100644
--- a/net/sched/cls_matchall.c
+++ b/net/sched/cls_matchall.c
@@ -338,7 +338,8 @@ static void mall_stats_hw_filter(struct tcf_proto *tp,
 	tc_setup_cb_call(block, TC_SETUP_CLSMATCHALL, &cls_mall, false, true);
 
 	tcf_exts_stats_update(&head->exts, cls_mall.stats.bytes,
-			      cls_mall.stats.pkts, cls_mall.stats.lastused,
+			      cls_mall.stats.pkts, cls_mall.stats.drops,
+			      cls_mall.stats.lastused,
 			      cls_mall.stats.used_hw_stats,
 			      cls_mall.stats.used_hw_stats_valid);
 }
-- 
2.17.1

