Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1523A68BF30
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 15:02:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbjBFOCN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 09:02:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230397AbjBFOBn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 09:01:43 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2052.outbound.protection.outlook.com [40.107.237.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81830298C0
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 06:00:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PjGyfGh4DDgROYIibZ034Bzw+DnxkLt3l8vh/sTmii5iiRbtvkkV43Gn6NMMz8f0AeYe0ykStOApYwsMAlridcV09/cY1DOG09DFLo2HZf9u6zEfYeoqCznOBVUzUc4PJnqavh9/Zi/Yx1LrcQ0uwBuTBJbZxqYZIQS6qdNazA/aZahmUjUGO8y5HP4LN9gZwFsEsK2B/+4sGZoAKI9nr+ixr75VFCHfun6oN9dGPFAM2xslZGMly2UO+U5ZacK7ASX1b9X9dmMCCAwW1pM5dsz1KwQ1QU9aekwOEJRyFzEkFzH/uLWGE8WJDD8j4EvxjBaIjKmC+z3turnKjVGoXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1sMqnR4oR+k4VRZsqbv44XBPr1lbX+AunSGunTtjB00=;
 b=MN+Qx3MNzc5jZsYUV7cF/nGztruuYO4wcqi3jyl2hd9zJO0FqLiaHCceFGKFhupq40xUeAyPJk0pm/XVrwt9qGxgz8QDtg/jbT96IGUwzlREE6Hxn3RvxxWWmd8itx/PuY2/tzXoe16sfsgO9Lqhd9qcHWuaSH94+/nV2jGRz1KdhfBChL80e7WlSZdOFWwNnkvjiG8nFAdF/8gEYcBTaC4DG2Cd8dUr2jBxxKy7oBCZ1+HoqLRhTWGJkp+mQtgpbwASFOfkBRpGSjRfcQ3VF9m8EDB9IAnqCCPmrttnuQfbr8lTlFUtIEWH3WBTpEqP5KbesgPH7RAQcdYQ/J5dbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1sMqnR4oR+k4VRZsqbv44XBPr1lbX+AunSGunTtjB00=;
 b=Xr8aghGCAx7HABUQssg0ore377H2uWJyCi3C/NHsdLisl0rHmGiUQqHWLbo0iDG4IK+Fj45Iplyoz0nPFPav/aT3XrJ1W8lm15wzSZ1zmGIh4ztCLcfE90gQmvcGSJ8GubouY7oKTI3a6GYLcDPdAiU2hyf+eVqhK88bEIBh53R1rfxnxOrsWF04xz581T+AbIB6fsPX+v/sthq3lSN+5vHyVrw7sZsJHOo1xGto99YKULupUhKmdIx8e3ZvyQBd0mXu9TO2m6iGMRCd735l89GRhz9ZND5kNW4XNpbQfRdRsu7KfBbO+J6+W0kMMdPXyaoMaZqHmbkXMXAgkNBkYQ==
Received: from DM6PR02CA0153.namprd02.prod.outlook.com (2603:10b6:5:332::20)
 by CH2PR12MB4085.namprd12.prod.outlook.com (2603:10b6:610:79::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Mon, 6 Feb
 2023 14:00:46 +0000
Received: from DM6NAM11FT076.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:332:cafe::fe) by DM6PR02CA0153.outlook.office365.com
 (2603:10b6:5:332::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.35 via Frontend
 Transport; Mon, 6 Feb 2023 14:00:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 DM6NAM11FT076.mail.protection.outlook.com (10.13.173.204) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.34 via Frontend Transport; Mon, 6 Feb 2023 14:00:45 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 6 Feb 2023
 06:00:31 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Mon, 6 Feb 2023 06:00:31 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.126.190.180) with Microsoft SMTP Server id 15.2.986.36
 via Frontend Transport; Mon, 6 Feb 2023 06:00:28 -0800
From:   Oz Shlomo <ozsh@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Saeed Mahameed <saeedm@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        "Jiri Pirko" <jiri@nvidia.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        "Simon Horman" <simon.horman@corigine.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        "Oz Shlomo" <ozsh@nvidia.com>
Subject: [PATCH  net-next v3 9/9] net/mlx5e: TC, support per action stats
Date:   Mon, 6 Feb 2023 15:54:42 +0200
Message-ID: <20230206135442.15671-10-ozsh@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230206135442.15671-1-ozsh@nvidia.com>
References: <20230206135442.15671-1-ozsh@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT076:EE_|CH2PR12MB4085:EE_
X-MS-Office365-Filtering-Correlation-Id: 00ab5b53-d6db-46d6-d405-08db084a8b45
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7+FZavZkQoZ0RNQBzKcNrT+rj1GuU1r6vKsp8qMmML7d/IMg3Rz+23kyb7KfIB3UfMbsbVFTo1x2qsklhpysDttiGbhOGSKAviKwuCM7zXp+eVpwr8DovUzzqSqVazUYLDoZJ9UVBtYpKtgwPaDItbq+Yn856SOAUOQ1lt0IAh/8LoGJCE4p6TCIgNuYbt0wVgZ2vajey17gxT1V52iDpIFiB8jzkU3xg78lPzL/xivgDk9717l6fWvZgMo9AC3Zp2Aln3cKJimtW5icWSwTOK22TSsEsLF1JV6+OdzuxZ3OvTsJyyD3a5bSmAmcJ2lnq5tHzLZTNirdGxBjMFqMBtWMB7Xhu/cR5PHyuEQvxqOTq4mBbO2dfvgJTa11POwfuFNLSR725k2Z1bcsxfP25ypqi54UJKebk5QrqUY8BE5nJgzEd/wMsN1qZmyV/m/Cy+YfKAHNVsqqCD0lRopUSbJuVUz3plLYCjlnBp5yvCayBqVS8KBzyIcFMIceh4gXRbmTK5Rt/2jNUZ0u2mhDF3uAHmyhDAIyvTpX1MPSRD3CHPPXccrQv5OLGR0FArj9mciUVZvUp1ykBCZKJSK95rZ0YuARNiwwHxoegD19VSc8MMFHaO8XN36cggGol/CTIA21AGTOfjs2spCtTXVp2pT9QJJIFnp2oMT8Phd9luflrFi7/6Jf61LccIA0fvgwNU59UyN1kX8PgkMfdlTBqw==
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(136003)(39860400002)(376002)(451199018)(36840700001)(46966006)(40470700004)(36860700001)(36756003)(26005)(82740400003)(70586007)(70206006)(54906003)(316002)(82310400005)(8676002)(4326008)(41300700001)(6916009)(8936002)(5660300002)(86362001)(356005)(7636003)(186003)(6666004)(1076003)(107886003)(2906002)(47076005)(426003)(40460700003)(40480700001)(478600001)(83380400001)(2616005)(336012);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 14:00:45.9018
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 00ab5b53-d6db-46d6-d405-08db084a8b45
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT076.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4085
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend the action stats callback implementation to update stats for actions
that are associated with hw counters.
Note that the callback may be called from tc action utility or from tc
flower. Both apis expect the driver to return the stats difference from
the last update. As such, query the raw counter value and maintain
the diff from the last api call in the tc layer, instead of the fs_core
layer.

Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>

---
Change log:

V2 -> V3:
    - Change commit message title
---
 .../net/ethernet/mellanox/mlx5/core/en/rep/tc.c    |  2 +-
 .../ethernet/mellanox/mlx5/core/en/tc/act_stats.c  | 44 ++++++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/en/tc/act_stats.h  |  4 ++
 .../net/ethernet/mellanox/mlx5/core/en/tc_priv.h   |  1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 39 +++++++++++++------
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h    |  2 +
 .../net/ethernet/mellanox/mlx5/core/fs_counters.c  | 10 +++++
 include/linux/mlx5/fs.h                            |  2 +
 8 files changed, 91 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
index b08339d986d5..3b590cfe33b8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
@@ -589,7 +589,7 @@ static bool mlx5e_rep_macvlan_mode_supported(const struct net_device *dev)
 
 	act = mlx5e_tc_act_get(fl_act->id, ns_type);
 	if (!act || !act->stats_action)
-		return -EOPNOTSUPP;
+		return mlx5e_tc_fill_action_stats(priv, fl_act);
 
 	return act->stats_action(priv, fl_act);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act_stats.c
index d1272c0f883c..f71766dca660 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act_stats.c
@@ -102,6 +102,9 @@ void mlx5e_tc_act_stats_free(struct mlx5e_tc_act_stats_handle *handle)
 	struct mlx5e_tc_act_stats *act_stats;
 	int i;
 
+	if (!flow_flag_test(flow, USE_ACT_STATS))
+		return;
+
 	list_for_each_entry(attr, &flow->attrs, list) {
 		for (i = 0; i < attr->tc_act_cookies_count; i++) {
 			struct rhashtable *ht = &handle->ht;
@@ -130,6 +133,9 @@ void mlx5e_tc_act_stats_free(struct mlx5e_tc_act_stats_handle *handle)
 	int err;
 	int i;
 
+	if (!flow_flag_test(flow, USE_ACT_STATS))
+		return 0;
+
 	list_for_each_entry(attr, &flow->attrs, list) {
 		if (attr->counter)
 			curr_counter = attr->counter;
@@ -151,3 +157,41 @@ void mlx5e_tc_act_stats_free(struct mlx5e_tc_act_stats_handle *handle)
 	mlx5e_tc_act_stats_del_flow(handle, flow);
 	return err;
 }
+
+int
+mlx5e_tc_act_stats_fill_stats(struct mlx5e_tc_act_stats_handle *handle,
+			      struct flow_offload_action *fl_act)
+{
+	struct rhashtable *ht = &handle->ht;
+	struct mlx5e_tc_act_stats *item;
+	struct mlx5e_tc_act_stats key;
+	u64 pkts, bytes, lastused;
+	int err = 0;
+
+	key.tc_act_cookie = fl_act->cookie;
+
+	rcu_read_lock();
+	item = rhashtable_lookup(ht, &key, act_counters_ht_params);
+	if (!item) {
+		rcu_read_unlock();
+		err = -ENOENT;
+		goto err_out;
+	}
+
+	mlx5_fc_query_cached_raw(item->counter,
+				 &bytes, &pkts, &lastused);
+
+	flow_stats_update(&fl_act->stats,
+			  bytes - item->lastbytes,
+			  pkts - item->lastpackets,
+			  0, lastused, FLOW_ACTION_HW_STATS_DELAYED);
+
+	item->lastpackets = pkts;
+	item->lastbytes = bytes;
+	rcu_read_unlock();
+
+	return 0;
+
+err_out:
+	return err;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act_stats.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act_stats.h
index 4929301a5260..002292c2567c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act_stats.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act_stats.h
@@ -20,4 +20,8 @@
 mlx5e_tc_act_stats_del_flow(struct mlx5e_tc_act_stats_handle *handle,
 			    struct mlx5e_tc_flow *flow);
 
+int
+mlx5e_tc_act_stats_fill_stats(struct mlx5e_tc_act_stats_handle *handle,
+			      struct flow_offload_action *fl_act);
+
 #endif /* __MLX5_EN_ACT_STATS_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
index f575646d2f50..451fd4342a5a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
@@ -30,6 +30,7 @@ enum {
 	MLX5E_TC_FLOW_FLAG_TUN_RX                = MLX5E_TC_FLOW_BASE + 9,
 	MLX5E_TC_FLOW_FLAG_FAILED                = MLX5E_TC_FLOW_BASE + 10,
 	MLX5E_TC_FLOW_FLAG_SAMPLE                = MLX5E_TC_FLOW_BASE + 11,
+	MLX5E_TC_FLOW_FLAG_USE_ACT_STATS	 = MLX5E_TC_FLOW_BASE + 12,
 };
 
 struct mlx5e_tc_flow_parse_attr {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index ec5d1fbae22e..50432c9d78c0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4128,6 +4128,7 @@ struct mlx5_flow_attr *
 
 	/* branching action requires its own counter */
 	attr->action |= MLX5_FLOW_CONTEXT_ACTION_COUNT;
+	flow_flag_set(flow, USE_ACT_STATS);
 
 	return 0;
 
@@ -4978,6 +4979,12 @@ int mlx5e_delete_flower(struct net_device *dev, struct mlx5e_priv *priv,
 	return err;
 }
 
+int mlx5e_tc_fill_action_stats(struct mlx5e_priv *priv,
+			       struct flow_offload_action *fl_act)
+{
+	return mlx5e_tc_act_stats_fill_stats(get_act_stats_handle(priv), fl_act);
+}
+
 int mlx5e_stats_flower(struct net_device *dev, struct mlx5e_priv *priv,
 		       struct flow_cls_offload *f, unsigned long flags)
 {
@@ -5004,11 +5011,15 @@ int mlx5e_stats_flower(struct net_device *dev, struct mlx5e_priv *priv,
 	}
 
 	if (mlx5e_is_offloaded_flow(flow) || flow_flag_test(flow, CT)) {
-		counter = mlx5e_tc_get_counter(flow);
-		if (!counter)
-			goto errout;
+		if (flow_flag_test(flow, USE_ACT_STATS)) {
+			f->use_act_stats = true;
+		} else {
+			counter = mlx5e_tc_get_counter(flow);
+			if (!counter)
+				goto errout;
 
-		mlx5_fc_query_cached(counter, &bytes, &packets, &lastuse);
+			mlx5_fc_query_cached(counter, &bytes, &packets, &lastuse);
+		}
 	}
 
 	/* Under multipath it's possible for one rule to be currently
@@ -5024,14 +5035,18 @@ int mlx5e_stats_flower(struct net_device *dev, struct mlx5e_priv *priv,
 		u64 packets2;
 		u64 lastuse2;
 
-		counter = mlx5e_tc_get_counter(flow->peer_flow);
-		if (!counter)
-			goto no_peer_counter;
-		mlx5_fc_query_cached(counter, &bytes2, &packets2, &lastuse2);
-
-		bytes += bytes2;
-		packets += packets2;
-		lastuse = max_t(u64, lastuse, lastuse2);
+		if (flow_flag_test(flow, USE_ACT_STATS)) {
+			f->use_act_stats = true;
+		} else {
+			counter = mlx5e_tc_get_counter(flow->peer_flow);
+			if (!counter)
+				goto no_peer_counter;
+			mlx5_fc_query_cached(counter, &bytes2, &packets2, &lastuse2);
+
+			bytes += bytes2;
+			packets += packets2;
+			lastuse = max_t(u64, lastuse, lastuse2);
+		}
 	}
 
 no_peer_counter:
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
index 75b34e632916..e8e39fdcda73 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -199,6 +199,8 @@ int mlx5e_delete_flower(struct net_device *dev, struct mlx5e_priv *priv,
 
 int mlx5e_stats_flower(struct net_device *dev, struct mlx5e_priv *priv,
 		       struct flow_cls_offload *f, unsigned long flags);
+int mlx5e_tc_fill_action_stats(struct mlx5e_priv *priv,
+			       struct flow_offload_action *fl_act);
 
 int mlx5e_tc_configure_matchall(struct mlx5e_priv *priv,
 				struct tc_cls_matchall_offload *f);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c
index b406e0367af6..17fe30a4c06c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c
@@ -504,6 +504,16 @@ void mlx5_fc_query_cached(struct mlx5_fc *counter,
 	counter->lastpackets = c.packets;
 }
 
+void mlx5_fc_query_cached_raw(struct mlx5_fc *counter,
+			      u64 *bytes, u64 *packets, u64 *lastuse)
+{
+	struct mlx5_fc_cache c = counter->cache;
+
+	*bytes = c.bytes;
+	*packets = c.packets;
+	*lastuse = c.lastuse;
+}
+
 void mlx5_fc_queue_stats_work(struct mlx5_core_dev *dev,
 			      struct delayed_work *dwork,
 			      unsigned long delay)
diff --git a/include/linux/mlx5/fs.h b/include/linux/mlx5/fs.h
index ba6958b49a8e..90a2fe5839fa 100644
--- a/include/linux/mlx5/fs.h
+++ b/include/linux/mlx5/fs.h
@@ -296,6 +296,8 @@ int mlx5_modify_rule_destination(struct mlx5_flow_handle *handler,
 u64 mlx5_fc_query_lastuse(struct mlx5_fc *counter);
 void mlx5_fc_query_cached(struct mlx5_fc *counter,
 			  u64 *bytes, u64 *packets, u64 *lastuse);
+void mlx5_fc_query_cached_raw(struct mlx5_fc *counter,
+			      u64 *bytes, u64 *packets, u64 *lastuse);
 int mlx5_fc_query(struct mlx5_core_dev *dev, struct mlx5_fc *counter,
 		  u64 *packets, u64 *bytes);
 u32 mlx5_fc_id(struct mlx5_fc *counter);
-- 
1.8.3.1

