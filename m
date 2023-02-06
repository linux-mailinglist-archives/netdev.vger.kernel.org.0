Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98B4968BF26
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 15:01:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbjBFOBk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 09:01:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230349AbjBFOBD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 09:01:03 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2062e.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eb2::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C712279AF
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 06:00:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VrFdFyTSrp61ISbbNKdoJJhprcLfBmU1jSIhDHfoFNTmk5T6CMZmvvyUB/Z1y4RLWYhSEX7OEjrzZbVxkRRghAIjrOEWgxw5DEyIUyhj5AVVfJBKKXg9gdrDJABkkkmUrZOX2bujRWThaMRApu/2LvGD3FdroPK759PJwbMyBbJd4O8tE8Xr7eKO0XtwpVP2rTxG6xN8WPVSjOa1GObyRDTv/K2h7GasIxtkyMvEoF8mc3tOGZCAE621gpojFqsDsmUzX6/svy+7sThmWk2YtsymBaSSoRkG6cP5hYxK325kESFsMuWppj1CxCs9bn3rNgBalzJJklDKU458hHxoSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+8gk9+i5chFDjQultlfx9RPgT8sSmRN3Vmu2kVHrVxY=;
 b=WOMmkIUxGYAuPoz/mBKqW5J8cNGv3atr440K9e1NQtR84wgrutDGNDsqoVUKXBD8Dfo5eGIXH4i9HedBpvuSGzdwfzRuez0LcXnuKU35VowzZwJCB/IGWqd1keJ4tKrYca2aQaDd21y/Gx7RGGkaqZNMVZvc7mBgHB8Zgi+S081sfrk+8mlc9vnh0RLWIvWzlc9gzv//82/JYgSmEYYctwo02RHNlIzfX49mfiskf1y7L4/u7+F7bAq3NqEqU0MReV0HxT9UuDnV4ZFPlib0SplMjzCfljj6Z5K5GBB1cL9HSDq966eKAPfHI43inCkZ2IWet1tbHotdML/O/ANOFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+8gk9+i5chFDjQultlfx9RPgT8sSmRN3Vmu2kVHrVxY=;
 b=gLy1eDj/yD8TTALnuvvhmGY9MEN/BGk35JmLV23+dRVQy7U8R85KDUA2D68IcNBVK1+BK/q0VcAunCOllkS1M7EXwOwxS0SCK96GHU58zgULIb8trRZl3xGbz9sFMEM6oGwDPRYyWA11Kj/mN0jD4GPQuNeEjWI0LVayx1s7r4vCbbCb2iuL/BPYpZs1F27nvvQ9RsGBsN+zp+UTwtEhE1G1EeWV9Xsi4Vrb+U8cOBPxrLhib906s4TB++oej+JYhMpfkZz2td+MllkJPyrjpoFwbr5DV6QHg/70CCxD1m4E3G7JdI1bdC1XHONzoLHvHqVjkZmJNlwHko8ZQo1uMw==
Received: from DM6PR03CA0022.namprd03.prod.outlook.com (2603:10b6:5:40::35) by
 CH2PR12MB4184.namprd12.prod.outlook.com (2603:10b6:610:a7::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.34; Mon, 6 Feb 2023 14:00:33 +0000
Received: from DM6NAM11FT025.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:40:cafe::18) by DM6PR03CA0022.outlook.office365.com
 (2603:10b6:5:40::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.35 via Frontend
 Transport; Mon, 6 Feb 2023 14:00:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 DM6NAM11FT025.mail.protection.outlook.com (10.13.172.197) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.34 via Frontend Transport; Mon, 6 Feb 2023 14:00:32 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 6 Feb 2023
 06:00:19 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Mon, 6 Feb 2023 06:00:19 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.126.190.180) with Microsoft SMTP Server id 15.2.986.36
 via Frontend Transport; Mon, 6 Feb 2023 06:00:17 -0800
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
Subject: [PATCH  net-next v3 5/9] net/sched: support per action hw stats
Date:   Mon, 6 Feb 2023 15:54:38 +0200
Message-ID: <20230206135442.15671-6-ozsh@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230206135442.15671-1-ozsh@nvidia.com>
References: <20230206135442.15671-1-ozsh@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT025:EE_|CH2PR12MB4184:EE_
X-MS-Office365-Filtering-Correlation-Id: 837b8d6d-8d74-4e3e-dfd1-08db084a835e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CqpbTmoaHtI2E1OfNntw4SvHQgOydpqZjQ4ky8o1qRwLejJ0K3dkXUuC4bKm+W3H5ROS8LPbuT7DSI9nTBisCQrALqtx37L7C0LuHkA9E34wyPriQjum/4L85bVcFivYNuUGu5fwa9gaX41gOKTpU1Z4jrZVCj5gvr05PAMwkoyYfzTumATmMbKLqULNMoxh3I8R1XetK8R5RMDKUMcsmrKISLuzGdFL0ND0HK5rsCkBa7Dv0Mg1UInIpGoCDdd4dGI8Dc+4HeExMWe7y+u0VWHPLA8Rrzi/RcIen6FWtbp6NkdkxPOpNPGxOCpFY8lPGDC3MSG1q+jwptTLB5MFTbQ/cOlx+D08V8yFFAnkq2djTuhGiws12Uc4v4cZw9LAGd4a/KpUypVk1ZIvE422U1hCYeSkggte50BpLXKYWl7dC8IyOh/7T3RHlYB8ROvB1jlziRlL3cwnkJvH7nT1HeKJWA+zwZbo085ZqMCb/V9P+Mr8XYHkpmbrt4B+TLvNpkTWeOGvc8Hhwad/x9wPWRfcbMeSwHcc/ei27FOMvtomsWqNb8fWv3j7wbKYBbfZz9Rqnpmuw7p8ZuV/0Tv+QtRjbmEGwcSanEA7xFiV1vpJblWEAZsHP0hMJOvVzkg1hGbWBa7XwmOryfjJU1P0LL5lLWIwYlkawWJ0eTqPOPqwA0kqrHHrKO9E4Fj4u5ezMG0NqF0eqfB5Cwv8s8U5O8s8VfEf2G3X71rfl+wa0iA=
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(376002)(396003)(39860400002)(451199018)(46966006)(40470700004)(36840700001)(82310400005)(47076005)(36756003)(40460700003)(356005)(7636003)(40480700001)(86362001)(26005)(82740400003)(36860700001)(2616005)(426003)(478600001)(186003)(83380400001)(336012)(8676002)(1076003)(107886003)(6666004)(54906003)(316002)(4326008)(70206006)(41300700001)(6916009)(70586007)(8936002)(5660300002)(2906002)(309714004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 14:00:32.6129
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 837b8d6d-8d74-4e3e-dfd1-08db084a835e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT025.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4184
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are currently two mechanisms for populating hardware stats:
1. Using flow_offload api to query the flow's statistics.
   The api assumes that the same stats values apply to all
   the flow's actions.
   This assumption breaks when action drops or jumps over following
   actions.
2. Using hw_action api to query specific action stats via a driver
   callback method. This api assures the correct action stats for
   the offloaded action, however, it does not apply to the rest of the
   actions in the flow's actions array.

Extend the flow_offload stats callback to indicate that a per action
stats update is required.
Use the existing flow_offload_action api to query the action's hw stats.
In addition, currently the tc action stats utility only updates hw actions.
Reuse the existing action stats cb infrastructure to query any action
stats.

Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>

---
Change log:

V1 -> V2
    - Fix static function without inline keyword in header file
    - Rearrange flow_cls_offload members such that stats and use_act stats
      will be on the same cache line
    - Fall-through to flow stats when hw_stats update returns an error
      (this aligns with current behavior).
---
 include/net/flow_offload.h |  1 +
 include/net/pkt_cls.h      | 29 +++++++++++++++++++----------
 net/sched/act_api.c        |  8 --------
 net/sched/cls_flower.c     |  2 +-
 net/sched/cls_matchall.c   |  2 +-
 5 files changed, 22 insertions(+), 20 deletions(-)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index d177bf5f0e1a..8c05455b1e34 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -594,6 +594,7 @@ struct flow_cls_common_offload {
 struct flow_cls_offload {
 	struct flow_cls_common_offload common;
 	enum flow_cls_command command;
+	bool use_act_stats;
 	unsigned long cookie;
 	struct flow_rule *rule;
 	struct flow_stats stats;
diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index bf50829d9255..ace437c6754b 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -292,9 +292,15 @@ static inline void tcf_exts_put_net(struct tcf_exts *exts)
 #define tcf_act_for_each_action(i, a, actions) \
 	for (i = 0; i < TCA_ACT_MAX_PRIO && ((a) = actions[i]); i++)
 
+static inline bool tc_act_in_hw(struct tc_action *act)
+{
+	return !!act->in_hw_count;
+}
+
 static inline void
 tcf_exts_hw_stats_update(const struct tcf_exts *exts,
-			 struct flow_stats *stats)
+			 struct flow_stats *stats,
+			 bool use_act_stats)
 {
 #ifdef CONFIG_NET_CLS_ACT
 	int i;
@@ -302,16 +308,18 @@ static inline void tcf_exts_put_net(struct tcf_exts *exts)
 	for (i = 0; i < exts->nr_actions; i++) {
 		struct tc_action *a = exts->actions[i];
 
-		/* if stats from hw, just skip */
-		if (tcf_action_update_hw_stats(a)) {
-			preempt_disable();
-			tcf_action_stats_update(a, stats->bytes, stats->pkts, stats->drops,
-						stats->lastused, true);
-			preempt_enable();
-
-			a->used_hw_stats = stats->used_hw_stats;
-			a->used_hw_stats_valid = stats->used_hw_stats_valid;
+		if (use_act_stats || tc_act_in_hw(a)) {
+			if (!tcf_action_update_hw_stats(a))
+				continue;
 		}
+
+		preempt_disable();
+		tcf_action_stats_update(a, stats->bytes, stats->pkts, stats->drops,
+					stats->lastused, true);
+		preempt_enable();
+
+		a->used_hw_stats = stats->used_hw_stats;
+		a->used_hw_stats_valid = stats->used_hw_stats_valid;
 	}
 #endif
 }
@@ -769,6 +777,7 @@ struct tc_cls_matchall_offload {
 	enum tc_matchall_command command;
 	struct flow_rule *rule;
 	struct flow_stats stats;
+	bool use_act_stats;
 	unsigned long cookie;
 };
 
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 917827199102..eda58b78da13 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -169,11 +169,6 @@ static bool tc_act_skip_sw(u32 flags)
 	return (flags & TCA_ACT_FLAGS_SKIP_SW) ? true : false;
 }
 
-static bool tc_act_in_hw(struct tc_action *act)
-{
-	return !!act->in_hw_count;
-}
-
 /* SKIP_HW and SKIP_SW are mutually exclusive flags. */
 static bool tc_act_flags_valid(u32 flags)
 {
@@ -308,9 +303,6 @@ int tcf_action_update_hw_stats(struct tc_action *action)
 	struct flow_offload_action fl_act = {};
 	int err;
 
-	if (!tc_act_in_hw(action))
-		return -EOPNOTSUPP;
-
 	err = offload_action_init(&fl_act, action, FLOW_ACT_STATS, NULL);
 	if (err)
 		return err;
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index cb04739a13ce..885c95191ccf 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -502,7 +502,7 @@ static void fl_hw_update_stats(struct tcf_proto *tp, struct cls_fl_filter *f,
 	tc_setup_cb_call(block, TC_SETUP_CLSFLOWER, &cls_flower, false,
 			 rtnl_held);
 
-	tcf_exts_hw_stats_update(&f->exts, &cls_flower.stats);
+	tcf_exts_hw_stats_update(&f->exts, &cls_flower.stats, cls_flower.use_act_stats);
 }
 
 static void __fl_put(struct cls_fl_filter *f)
diff --git a/net/sched/cls_matchall.c b/net/sched/cls_matchall.c
index b3883d3d4dbd..fa3bbd187eb9 100644
--- a/net/sched/cls_matchall.c
+++ b/net/sched/cls_matchall.c
@@ -331,7 +331,7 @@ static void mall_stats_hw_filter(struct tcf_proto *tp,
 
 	tc_setup_cb_call(block, TC_SETUP_CLSMATCHALL, &cls_mall, false, true);
 
-	tcf_exts_hw_stats_update(&head->exts, &cls_mall.stats);
+	tcf_exts_hw_stats_update(&head->exts, &cls_mall.stats, cls_mall.use_act_stats);
 }
 
 static int mall_dump(struct net *net, struct tcf_proto *tp, void *fh,
-- 
1.8.3.1

