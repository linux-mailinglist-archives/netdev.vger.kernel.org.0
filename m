Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B8D9686B41
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 17:12:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232614AbjBAQMJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 11:12:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232374AbjBAQMI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 11:12:08 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2064.outbound.protection.outlook.com [40.107.94.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1EC177502
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 08:12:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bjx6avri89DMMKEh3LbISDhs3ukX3vql60BXmjJ9USYgx35g36xXFNAYDuDoDGvQgDw0/7HOROx4lWvACNE545ldCLfqM0fjyK/v+0Q8bMLQU4tHhEmpEHR8Q0i0Za7ZZdab+LJmyHhf9brvkWYgl+OA+U4AcRBknpoe/b7vn9TypHVw8VhWyofzfcnTxNpkE6r/P3T5QfbbTWFyJ6b2XdRDsynYLqNbWw2nDVW5qNoYh/26EGPyXG61EOp9kHtuB1x9mxkRGCkmEb/r7lK5oO+Nf8Sk1DFSIh3DefSC6NKFO+M+i/eSPGCW5MIgZsJYUdTP4ix2aHGfdoGslOV/MA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AAOnkL5YXIgT/OTV2HYLmkny8BnH9vvNOKGbpb5jgeI=;
 b=bEdKBFJgNZ1gO0+aNTAcKTTBY+A7ebw4N/olATOKY7tuo1W7YB9bMppR1hO4srizOI8Vm8z/yt8fVqI63xan6BbMWcwd+kHU4lq7joUr2+T1zjY/lIemonFdthxjzS6un4+g2xslFbjh0HJGBw1ZNLIulh9wCUyjYTTQGUhyh+Xm+wsNzxgT7k5p1lMMZhlVvVHcwzbPkiw3+sfvtQZjV1DhnCl9xv22elGH1IX0pZAPkfBz0LGJt4GjuFjcbBp2UMCn0vYDI/SMu8Pe/HjjN4lFD2W4cCTVx/Q2ggKj6ygHhxW5L/67QHK8h4vrXMYToe1+g4sHr1YcFzHUeRUEvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AAOnkL5YXIgT/OTV2HYLmkny8BnH9vvNOKGbpb5jgeI=;
 b=Okpq+oB35bUvsKPK1HeDcd3LyGTiobw2Hz8M3JdTkQnusAKcEO54MXJLbXUQZV5pG4NHNr/sBTpvXuDWwb/tktCIydblyde2Rhb0ArCelOLy+God+yf3+f8qbsSpH8kbaFt/120UxAMrJAVZSRppzBuxWNi1pkI7w3UkE9jN1k1m1By6ytZF3kxzvgQ2ZsE7GgRzrRTBaf0A8u60e2afVVYnt1rNUzyyVpILTrmsbCWHhb0qm2wreKZt0f73lmwAmlfttWcCWoyfsIwntc0Bl44D64umFk15oCdD6doeaaKUJzSwotsQvZpXjyJmTHyqdrCFu+GswhXU5GZEfD0o5A==
Received: from DM6PR07CA0131.namprd07.prod.outlook.com (2603:10b6:5:330::19)
 by SA1PR12MB7127.namprd12.prod.outlook.com (2603:10b6:806:29e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.33; Wed, 1 Feb
 2023 16:12:05 +0000
Received: from DM6NAM11FT100.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:330:cafe::e9) by DM6PR07CA0131.outlook.office365.com
 (2603:10b6:5:330::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.25 via Frontend
 Transport; Wed, 1 Feb 2023 16:12:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT100.mail.protection.outlook.com (10.13.172.247) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.36 via Frontend Transport; Wed, 1 Feb 2023 16:12:05 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 1 Feb 2023
 08:11:58 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 1 Feb 2023
 08:11:58 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.6) with Microsoft SMTP Server id 15.2.986.36 via
 Frontend Transport; Wed, 1 Feb 2023 08:11:55 -0800
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
Subject: [PATCH  net-next 5/9] net/sched: support per action hw stats
Date:   Wed, 1 Feb 2023 18:10:34 +0200
Message-ID: <20230201161039.20714-6-ozsh@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230201161039.20714-1-ozsh@nvidia.com>
References: <20230201161039.20714-1-ozsh@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT100:EE_|SA1PR12MB7127:EE_
X-MS-Office365-Filtering-Correlation-Id: f692d22e-94b1-424f-3553-08db046f0faf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WhoBXNCuw882orCIEAOBc72HuQXH2Sg4F5yuwYnhU3qK6wbdffSE/vhRWG0PnuMeABB7V3qFYsxkwHKWkZXryaw5v6s/WmYBYrdlqpwTR3PbtGskICXGj8oCyPysKlbfFnQFXPRD7HNB6RPY7OPNC2pDmPQ4IwUc2XkHsZsV0DvglLAFSoIDalCq8Qm+XEGejYmdpp9NBm8X22WNmSzTySxlYs/aSnnDh8BwzURQqt0rQxssQE7Kk4/spdTYab9HK8qaBGS+1MMqAdJ+BCp/WJaqi9JXMPRxRuq6oM83uGira3FRKkTdD1bEfiaFwlfImX6vUtMsguBUKAy+5/HTSF0M53IoXVCvd7wA5sdZAioLzjWA84b9EbZSdIM4DemhCFMq5X8FjT7/Fgvde4V0SO1alZW/SIs8qfvTPSi/uTuCTsxjAa7C0WHO9mc92CcQfmfgOxCAg29vvm7sUnMdm/SshjfG88+zWg2wKs6NAWrNy0nrqGXJdy3TmRAk7jeooQ9Q/OmV2MbNd6PB8db2Qd+hZYGQOzeuEPx7NiZkpM5CGdNZ65gmnQJXMHZBceL5RaHF58hN9L3LrlvnXUhzdxjJCNI4G1vfy+8A6DShvXGNQr9/emVuaF7rL3eFa1+mZR37pOdRd5Hz7FPeKTh9PaUAAe/Whz3cPCg8a06fqV3lbxcPjoMKnsBNKDOZPL+s/8/cwGbxgsPLSrbd24LVxS7GvDYdvVIEGgF5SqKyQGk=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(39860400002)(136003)(346002)(451199018)(36840700001)(46966006)(40470700004)(2906002)(41300700001)(36756003)(478600001)(54906003)(107886003)(6666004)(86362001)(356005)(82310400005)(40460700003)(47076005)(426003)(6916009)(336012)(4326008)(8676002)(316002)(40480700001)(1076003)(5660300002)(26005)(8936002)(36860700001)(82740400003)(70586007)(70206006)(186003)(7636003)(83380400001)(2616005)(309714004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2023 16:12:05.2516
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f692d22e-94b1-424f-3553-08db046f0faf
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT100.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7127
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
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
---
 include/net/flow_offload.h |  1 +
 include/net/pkt_cls.h      | 29 +++++++++++++++++++----------
 net/sched/act_api.c        |  8 --------
 net/sched/cls_flower.c     |  2 +-
 net/sched/cls_matchall.c   |  2 +-
 5 files changed, 22 insertions(+), 20 deletions(-)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index d177bf5f0e1a..27decadd4f5f 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -597,6 +597,7 @@ struct flow_cls_offload {
 	unsigned long cookie;
 	struct flow_rule *rule;
 	struct flow_stats stats;
+	bool use_act_stats;
 	u32 classid;
 };
 
diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index be21764a3b34..d4315757d1a2 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -292,9 +292,15 @@ static inline void tcf_exts_put_net(struct tcf_exts *exts)
 #define tcf_act_for_each_action(i, a, actions) \
 	for (i = 0; i < TCA_ACT_MAX_PRIO && ((a) = actions[i]); i++)
 
+static bool tc_act_in_hw(struct tc_action *act)
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
+			tcf_action_update_hw_stats(a);
+			continue;
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

