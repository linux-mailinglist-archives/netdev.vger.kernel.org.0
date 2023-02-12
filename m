Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C90269378D
	for <lists+netdev@lfdr.de>; Sun, 12 Feb 2023 14:26:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbjBLN0L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Feb 2023 08:26:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbjBLN0H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Feb 2023 08:26:07 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2048.outbound.protection.outlook.com [40.107.92.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 295B5126C1
        for <netdev@vger.kernel.org>; Sun, 12 Feb 2023 05:26:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m5uMSbsTQiEuqHg1w8bmdNlevWSUxdDNTzeeej64vZ0bYO5r47JACLMd28idEcKYmsaa5gtsalKOq0mA9IWvdrHWn/y7JMgdlnVF2+wDGt/C4wBi+LycFH6CUs35x4ScozYLuwHpIrcGCc3DPg61DDNt6FXWXH4mezPbwIYRIIvh3Wut5pqbubnoRUV2A7dYI2Qb7r1bXNQq8dNTMeRSf3ERnAMFjtSYySWkOT9hMttKkBRmKmb+ftlz1IU2Ed/+E+z4MitoJR9LhOuDOS/YUonNVaMXSPzBhAAKCulaoa0c1sRLsTNpXGDCvKOlMFdlyT7rEvSPcGBptNi0GUymQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ePHJOi3U/H08LdoM8e44OgbN5MPTMtT9ATbb8BAaxh8=;
 b=at+9TqlxMoJcuPyQwf2OyQ0wB1M4noIZAbsokhsnZ3Azcp/DnQLhALosd7HPp0/D1W9XqdaluOAvrkA9VYG1ImLE7ZUMLl9VaMmo4K4LD25wol9voIMSEuU+90cA6MJ2NdXEY9b8FC14dWBgnZ+P3rQk03ldzPi0bSkiz0B3j/dL9f+FWfE50d6SEFDHpu+2gIEL6l6B4PqSM2VFyxllu7BCcqA9nG8vur/6QS3SqxVZuzwTbB6z9qnH/Oi1uZAFaZMb07/JiW8QOqvvYpCzFsjNCJ+L3c65lvrMAUCMRFZq57MRuKjFhCD1UgRBj7NaN++PGtv+Jg33Ys6asi4xlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ePHJOi3U/H08LdoM8e44OgbN5MPTMtT9ATbb8BAaxh8=;
 b=klEOQ65rajY0FJFdNBZDZhdFLpt6rsLn6mB6JdJgH3iu6MJxAuGp7jVKC4qkd0Cdr8zJQpASDrw6Hyp07mb9WBbNZ9mpbh7znpTBIqEKwlB36f275Ta655lBHhMvOBx+x10VbKQL1dVCeeMLyCbLNa40W6eEMfRybcdC+jOK/Y9WgOToTqEA/ehtvaW+LUd/CXXPTOpWN9UE77qlMiBHvHoUQhSxbM6FBEIng5RGEZ+oprjdWYe8iOq84tQz5qe5W+dS45qnXP5sK+Q5uf6pOgyrm6GuM5WEpTtJ+xRoj81ygbkr7JQRgVkJjzWRV0dFi0TQW4baCUBBpnhVRZhWPQ==
Received: from DM6PR01CA0006.prod.exchangelabs.com (2603:10b6:5:296::11) by
 DM6PR12MB4314.namprd12.prod.outlook.com (2603:10b6:5:211::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.23; Sun, 12 Feb 2023 13:26:04 +0000
Received: from DM6NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:296:cafe::ef) by DM6PR01CA0006.outlook.office365.com
 (2603:10b6:5:296::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.23 via Frontend
 Transport; Sun, 12 Feb 2023 13:26:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT010.mail.protection.outlook.com (10.13.172.222) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.23 via Frontend Transport; Sun, 12 Feb 2023 13:26:04 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 12 Feb
 2023 05:25:56 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 12 Feb
 2023 05:25:55 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.10) with Microsoft SMTP Server id 15.2.986.36 via
 Frontend Transport; Sun, 12 Feb 2023 05:25:52 -0800
From:   Oz Shlomo <ozsh@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Saeed Mahameed <saeedm@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        "Jiri Pirko" <jiri@nvidia.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        "Simon Horman" <simon.horman@corigine.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Oz Shlomo <ozsh@nvidia.com>,
        "Marcelo Ricardo Leitner" <marcelo.leitner@gmail.com>
Subject: [PATCH  net-next v4 5/9] net/sched: support per action hw stats
Date:   Sun, 12 Feb 2023 15:25:16 +0200
Message-ID: <20230212132520.12571-6-ozsh@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230212132520.12571-1-ozsh@nvidia.com>
References: <20230212132520.12571-1-ozsh@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT010:EE_|DM6PR12MB4314:EE_
X-MS-Office365-Filtering-Correlation-Id: 339536ae-e68b-43ba-37fb-08db0cfcb0f2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UnIWo1jJ4Hwh1hFX4XJPOstSnAeUl43XmN+pPszkkFLfloOo2qyKCe/C/xfz+lrSNBAvEhh4WaFIfgD0nFdpAqvMF/nI/RreF+DJCXnziZSVf336G7BLryPgVHrQyrc3srpSRJNI441UBM0RW18OSym59XtF4PHNzPbXi/qIAcxi2sNz/RCxUR9S2ZkRLW3WIUYuanMjI87JDEOvabKs731+C1Wm6tMZmNhKoR6PUJQggRoi4TFwVL6brnN2x9wlzZn1IayXUvGyEcBXEXb0uP2EvU6Rp2Exqx3bsKcdNXY8IV/PvWjYkUokMHWb7a2/gM43VNnHi+S2MB7KRlyp66K+O3qnyceQeQhB9RuMcsVqHaGYT/BMcyMkgQpxdlh2W8cYOIs5zMCAP/+GuHKjg2u0XopoSUc5IBU6NYV4/wRrYI11Dy+NiLsTG0tYgbqXr8UJpOTeyHnzAsvvhgwICGcdSSo1u+RBTdqC3YVCCVAsH/UqzxclrNxjH6V+pN1Y3mFkZJpyCLl9B08NiwXVkN4nYETMbyMt4383gl6MZ5ULHKGVbpTjcCqv3qv7i1YeUNsouBkACSGfexsURX8PkFH5eG9D/jah97g1at+qMpqZRbc/JZs83yKL6FWehkKrv9HT9i/dGQnAltSkGkJ/hwo5HG+VBC5AoEZCUDT5yQhsw+1Ea+qKEyTgnqA1YSUGEBS/O9y5P8ydak9VXoUXFfhcWn4xbwi6IaVQMj3CmX0=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(136003)(396003)(39860400002)(451199018)(36840700001)(46966006)(40470700004)(83380400001)(5660300002)(41300700001)(8936002)(426003)(47076005)(7636003)(36860700001)(82740400003)(82310400005)(86362001)(36756003)(40480700001)(356005)(40460700003)(2906002)(316002)(54906003)(1076003)(26005)(186003)(4326008)(6916009)(6666004)(336012)(478600001)(2616005)(8676002)(70586007)(70206006)(309714004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2023 13:26:04.1450
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 339536ae-e68b-43ba-37fb-08db0cfcb0f2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4314
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

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

