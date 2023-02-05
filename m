Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6A1168B01C
	for <lists+netdev@lfdr.de>; Sun,  5 Feb 2023 14:56:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbjBEN4W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Feb 2023 08:56:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbjBEN4R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Feb 2023 08:56:17 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2068.outbound.protection.outlook.com [40.107.244.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 192441E5E5
        for <netdev@vger.kernel.org>; Sun,  5 Feb 2023 05:56:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bV9JpuNsL+Sq53rGAXig9coxuTSTnU+hQ9XPGQ/mORKKSiGsuDg0VhGpW5bkLvlCU8pKTPom4+u1Oc9hHGaXk3/CAOZ/LLkzbnAm74UQLoxBO44f7g90FvMq5IcaZN41874qX2myS9lVKuuPalQ//ek01Np8PU1di7yiMo0NsLkxqW/wZiDtuMqxlLh0mTg8TowL6lndtSfc9RblUlbEqU8izq36JwNl3CypVHoiUv5HVM0P/N10RuNGf75M8SqC5Q8LVGt3oYSQgJN3AfdbkXkBQFjo0iCGlgAZOUROBmQEWtz1k/molKiLFH5LeMIkBaeEp3oWos8VUUbDES8yeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=15hxJfE5/n3so+b8hViWCnmgZmQgoCIuXR/u2+vh3GU=;
 b=kkWuRdI0Laz6SAxxwJ/ZBZvsQLSamN/ck3uf6H5d4vZ62+5yFNUh4ywC8ntz5nN6+JW9frK/zYx1Vi57yohLGPPkTJQI0nPVoFlbPwU0JDUte3zdy+i5fhzcMB+3OlSQPglkuaLvu30EAftJsbT6La7OAsmahRfEuS2eFuY2Q9jYBWfdYaSu12nz7tQGnWdLpR95yPtgmvB6FfarbuKB6x5l0QuC9870m0wbvrxJnD59K8p7Ynbm4NHjTW51pyNh2pj5DIQ9OInyxg0jq/Hs7beGrsbPbqq+8oxYVMRfcNQuteYce77oiUrE9guT7UcKdQ+zXiqbZC/sJcEW23BGNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=15hxJfE5/n3so+b8hViWCnmgZmQgoCIuXR/u2+vh3GU=;
 b=U1gdTpiAz6JG2y0ECqW6veoRzimVkHuuJwFKB/AHvaCFJAxyr4dzun4gep4FdLeJqgqSmDWhZeoi1vDpVnAinGhOkTZRQRi9X+gh4tUAoOO/AL/JU4Nnzz3tbqzKDS+EenRYUMZoylaTsRHY59k2WXTMNQy4ldtOT+lyKPhFt0oDn8hBpKt3P5CyJmTe4dIZZm7XmRHfXb+re9N6M3x32+7fxidXQ6ld2g/Rfo4m8t6bXsVDcYPBFBmNbxoHQu/zAvDCFwmIi5SEFANW7tzvfI7ict8wpz6mYwI+ng8s3u/QrqqUjcWMErq7nP6jsvtVb8t2lWNECORqnUdiOrAsDQ==
Received: from BN9PR03CA0731.namprd03.prod.outlook.com (2603:10b6:408:110::16)
 by CH3PR12MB7714.namprd12.prod.outlook.com (2603:10b6:610:14e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.31; Sun, 5 Feb
 2023 13:56:11 +0000
Received: from BN8NAM11FT021.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:110:cafe::2a) by BN9PR03CA0731.outlook.office365.com
 (2603:10b6:408:110::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34 via Frontend
 Transport; Sun, 5 Feb 2023 13:56:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT021.mail.protection.outlook.com (10.13.177.114) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.32 via Frontend Transport; Sun, 5 Feb 2023 13:56:11 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 5 Feb 2023
 05:55:59 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 5 Feb 2023
 05:55:59 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.9) with Microsoft SMTP Server id 15.2.986.36 via
 Frontend Transport; Sun, 5 Feb 2023 05:55:56 -0800
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
Subject: [PATCH  net-next v2 9/9] net/sched: TC, support per action stats
Date:   Sun, 5 Feb 2023 15:55:25 +0200
Message-ID: <20230205135525.27760-10-ozsh@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230205135525.27760-1-ozsh@nvidia.com>
References: <20230205135525.27760-1-ozsh@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT021:EE_|CH3PR12MB7714:EE_
X-MS-Office365-Filtering-Correlation-Id: 38182ccc-c393-4689-ac68-08db0780bd4a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1ZGoCjlMs+/BAa3kWjSUJ9O1kUNZOh3ciJyWknaQTFVh2KeizdwH1EVsofJI9HWekUyX4xq1G+4UDNLX2PUfilLfXE4fENYPafGTNO/NNko7f+sTBiJMmgr6UdnYDxyXenSu4HH3qqqw+gFTtR+HKYdyjmn2WQJhZkyRUwqBaGD3VcjfDdWPdk338sfA5oVCclTQ2Wld9SJNlq8oCNuetMGXq79zaCdT01ZDSQqMHiYXRCzBLQpgFWnC9zY/IMSZswn7tekwGjpd6ixmtiln9Q7VQUsV8J+7KXtUh5tGbTTEb2apK5Wagh3zITGHUwliEKRAIab+BkHNCteCl2FuSYDlZszvx/7+n5K/zmjbNGVfX6JzLV2n0lOU93AZFsqXPCkAh3W6i60PgKinCaMw4Le02OBem+yYoFWNXof61KBEz9qTmDANN1c/JiGiJQsQsMMdafIfl0SLcAXjkhkMmIIWA9MVBAC9M0GXspIr+Yv95V+03KugCPTrNTp7IfeH7D0FiUCuzWUzqVLHkYMtfC4usdhkaLE+KWkdMSkPFFvfe2gXTjC0sH0oubVmjUYhPmZEWpmrRZxaewI7eOitHk+rjlHODGiWK2fhGiacfxiDlmE1riY6RHDI82/EjH9wa7z/j8gq2MiHLAWjqWfSvOvNMEVy+B5s0JY1ps8JYdH2ioEeH5x25KG5irairXEAUNXK1t3X7P37eWdyjgHXfA==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(39860400002)(346002)(136003)(396003)(451199018)(46966006)(36840700001)(40470700004)(1076003)(26005)(83380400001)(186003)(82310400005)(426003)(40460700003)(36756003)(107886003)(336012)(40480700001)(6666004)(82740400003)(5660300002)(2906002)(7636003)(4326008)(70206006)(70586007)(6916009)(316002)(54906003)(8936002)(8676002)(41300700001)(36860700001)(478600001)(356005)(86362001)(47076005)(2616005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2023 13:56:11.4021
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 38182ccc-c393-4689-ac68-08db0780bd4a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT021.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7714
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

