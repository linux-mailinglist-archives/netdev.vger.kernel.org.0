Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A37E69378F
	for <lists+netdev@lfdr.de>; Sun, 12 Feb 2023 14:26:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbjBLN01 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Feb 2023 08:26:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbjBLN0Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Feb 2023 08:26:25 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2041.outbound.protection.outlook.com [40.107.92.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64DEF13DFD
        for <netdev@vger.kernel.org>; Sun, 12 Feb 2023 05:26:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k7EH6MMUopIbeUdoL7SmLu8646oCmn0c1pqpgThSL99I5SWt7gqucb2LCSSVmknaKSD/gIhaI2uPLs030DIvsPYDuElETgAAcSLZ7cD2R0ohACRCpbVAAtUhRW1i4by7sb6RzLY+WETj9gqQAySgmqSK3kpzbcujol5smLxfsWhkNeReLH3QN7dd8exI+GQJQf0UntuigWyyPjsryljwhPAuNmwhNkQxX86x9DzH35dRCEkka4z303mEfF+L3foVMLqg/INOAsB271YYnamPkQl0F8Fy2uWobhtBXihamuHhFOM9RHYnuW8IJjEFuEWtV8hz43yy2cFyknNbFtSM6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q5GxK3vQJJfDeETUfDiU/FxGsRXOffls6HjKtn9pQ48=;
 b=IhfRV+cz+fuVRfEBQcJDZ8k3gi/jzqUYWn4gY3NSCQ132t0whTtj8vsrQMI4jrweMemIG93IKYN5e/w/J/+P/XAn8ztd2ZlHFDFHr8Ck8Oe3nJwgqrjrwx8BqFVJG40n7TJBlZl8QSY5z3bXgOTEdriB+g+BVAxpIOWRbifoZHZkOZBWmasdd1BHBDU9YgtW++8XzWrkOfGgBf//40GyNkQPD3k8OO2qleDOe1qMrjT4qv5hkZ26cs9mBnhSMTKQDiveinSLQ1X4fQuuzP7ttmHCIDYjZ59zn7GxSqaZAYvM3pQj3zTc9I5ZVRuoz+F30hSlWyCjzy0vLuOg0+lhNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q5GxK3vQJJfDeETUfDiU/FxGsRXOffls6HjKtn9pQ48=;
 b=RPsJT26LWA33C4DWCDtoOFDfALbvTEqnKS00qgLWFH4UoBQcl5EIMV/HyolPlwgrAXOYvJUURjiKPvaGnRNegpbvM6nMtgkHx8GQDZe/lzN5rtKrV5WSwJSipuz3t9ZJ65Mb6XV+laud36MfyDY41X0D0pMxxboS9X2eO6UQhR3jAByVnU1EKO0tLZldSlaLxLWmSIl9bwHCsQJGq7gZkYhVd8r0s2tEsFRnKW2+nU9ddcoVU2quQAvnCzh0Yyn1noYRgu9rP1DnX8Uq0rgjDI6w31DU5CIUGcj0FElfv8vF3J9Q+mCFe28xunzMa7QbKQWErlfLFR1vBFhJThCr0Q==
Received: from DS7PR03CA0333.namprd03.prod.outlook.com (2603:10b6:8:55::15) by
 CH2PR12MB4184.namprd12.prod.outlook.com (2603:10b6:610:a7::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.23; Sun, 12 Feb 2023 13:26:14 +0000
Received: from DM6NAM11FT066.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:55:cafe::25) by DS7PR03CA0333.outlook.office365.com
 (2603:10b6:8:55::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.23 via Frontend
 Transport; Sun, 12 Feb 2023 13:26:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT066.mail.protection.outlook.com (10.13.173.179) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.23 via Frontend Transport; Sun, 12 Feb 2023 13:26:14 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 12 Feb
 2023 05:26:09 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 12 Feb
 2023 05:26:08 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.10) with Microsoft SMTP Server id 15.2.986.36 via
 Frontend Transport; Sun, 12 Feb 2023 05:26:05 -0800
From:   Oz Shlomo <ozsh@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Saeed Mahameed <saeedm@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        "Jiri Pirko" <jiri@nvidia.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        "Simon Horman" <simon.horman@corigine.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Oz Shlomo <ozsh@nvidia.com>
Subject: [PATCH  net-next v4 9/9] net/mlx5e: TC, support per action stats
Date:   Sun, 12 Feb 2023 15:25:20 +0200
Message-ID: <20230212132520.12571-10-ozsh@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230212132520.12571-1-ozsh@nvidia.com>
References: <20230212132520.12571-1-ozsh@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT066:EE_|CH2PR12MB4184:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d2fb9d0-01b5-4023-2b1d-08db0cfcb6d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r7Dkvelj7vhjraL9H7Kc1VEOqRVO+S88JGGYO2BuAV2gPkAZmD0TpSpXM2LKbyH4dYqqTxi4TMyq/nPY3DYkhfyVtSN39rBfuoIUuvyvgDVzZP8cKCqkiJCoyNowNb6GXHiZu27kQB+HnKdU4Y8q8+txlRT19Blj/1s0NY4HDML0kvvxkiwrIgFbtug9riMtxtwSpm+B2wpDNUDxVrHgnExRoJeHeA9cVneLP80po1vpVq9RyhIV3nkkHKjTuMu8eHJwmPW0RGlBMTnJ98xBm4A7sNK3W72UEfPAdxcKeuOO0FCm6UCZwfshsNxBNhdwHW6MoQvh87OWvf3ZGMJfC8ibKbc2Uj9bqCUmMqqQZrGd6abkUl6kMXRDfAaUdneHSheOZ+PVtd42qZS6zJFAJs9tkFqtZeQuQyFGLz7xvdxJVxfpxLqQIxRjsjsvYqtIpS/HmgExZCU9WzL/tfSrht6p5aCjUDoOGGGJvMjJS11eKlFUNkyrW2kJ1l1SBmJe+53HD7AwRLszj5Nt8FHmawo4WQEw3ytTfCJBzMyu256Gt1HM/Y+AQBsKV1xnZfakSzX5Cd490ioQTIdB1eRmoqLFgj7IrLG2s3kCuJGtg4jc81yl3Z83t8QllsgUa2UpWx0gMtSJjSwjeN3gFPJq2PQUqpaYR72vH1i0nkMLgjcykFKhzm7XA37nPII2PXND9zL1JIV5h43Uv51unhNjHw==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(39860400002)(396003)(136003)(451199018)(36840700001)(40470700004)(46966006)(478600001)(40480700001)(36860700001)(336012)(36756003)(426003)(47076005)(83380400001)(356005)(82310400005)(86362001)(82740400003)(7636003)(6666004)(107886003)(26005)(186003)(2616005)(40460700003)(1076003)(70586007)(6916009)(70206006)(4326008)(8936002)(54906003)(316002)(5660300002)(8676002)(2906002)(41300700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2023 13:26:14.0144
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d2fb9d0-01b5-4023-2b1d-08db0cfcb6d4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT066.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4184
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
index f1dd25701406..2d06b4412762 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4117,6 +4117,7 @@ struct mlx5_flow_attr *
 
 	/* branching action requires its own counter */
 	attr->action |= MLX5_FLOW_CONTEXT_ACTION_COUNT;
+	flow_flag_set(flow, USE_ACT_STATS);
 
 	return 0;
 
@@ -4967,6 +4968,12 @@ int mlx5e_delete_flower(struct net_device *dev, struct mlx5e_priv *priv,
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
@@ -4993,11 +5000,15 @@ int mlx5e_stats_flower(struct net_device *dev, struct mlx5e_priv *priv,
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
@@ -5013,14 +5024,18 @@ int mlx5e_stats_flower(struct net_device *dev, struct mlx5e_priv *priv,
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

