Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E78B68B017
	for <lists+netdev@lfdr.de>; Sun,  5 Feb 2023 14:56:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbjBEN4E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Feb 2023 08:56:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbjBEN4C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Feb 2023 08:56:02 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2046.outbound.protection.outlook.com [40.107.220.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12D061E2AD
        for <netdev@vger.kernel.org>; Sun,  5 Feb 2023 05:56:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VS1Di3/7VtIl1Jtr+dcLA5CgJwRX0TQnbq8G9byHar9vP1clN7ohd3Aw3BjKH20JKLMZhg36XRdhvbvfuMW/AKjj4f/bV3ALfx1LmYwN8L8k6fOduM6zUs/jA2pAgJyHXhWOXZW8MzGwbOfDkddOnbAPSY28ncmYNvwvU04Dq0vH6W1Enoq7vXDdprDFFxlVPvFImx1rSWmdViiCS/xYYozIKV2ogHh/wyG8Tewjpb7lp4c/cS5Ev/maU2l5tJLCKSil1nECo1QEItKn5V8Pws56sFLCyrTTBVvyh7zB0y/rt7Jr6z9jee1kHGSaPc2WuNwl3bhwCvwkHA2aZHGpiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3dOEKEYURErDlY/x1qF4MnGpIzScEsMyQtfKIN6c6ZY=;
 b=NtTg74+cSp1zrltwdQpcJTf1TuWfmTxZ7pNiu+QnFzELwHl7Ok0QY8WUkk1lPo+NO9CGtd8O644eqFtMsIBL8FGYVrQMMkIjelR3kKiEw8GFEBt9Bo3vRmAXrn+SsZTkdFj/BlevKGNjbt4+e2okxvIik8aEDT7n4hqCoN4gwCnTD30WkvkfP04lUKQELpJ96aSzm4P0nziY7pV5Bef7cSezWM6scV+h0zxSuBH1uzbc4V0hPnK1zHB4ofFtp5HqrFyS3NKQraeWUNiGZDqd5B72J/SGX21AnksEkSSNI0EFV605LbZAV2m2fdLYNwbVR91dra2ax86dxzOOO1lFug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3dOEKEYURErDlY/x1qF4MnGpIzScEsMyQtfKIN6c6ZY=;
 b=hoJ51W6OLZLVSY6tXMrj7o+F6XKmWi4Zpz+zxG9wrjVF1v5VAIhqNXghTUAvL822PEwaLQvDcP3RlwjUaVNxI29rFPIdgCo5O7qSHbI/obrbkarwJPDSU1K51kxf1U4AMbHJuHoxfo1POUjeclpUYJpc053pYpqeZOeVMMd4IWbNANhgzDl8ocw+aHBJWTrfFbBu+EOcTrEzWVb5dlmRprALpPH+dJhKK1SoD+aGjCYo3dL3hhUY0+pm93Qm/sAGSgzd618Hhs+YL0g8A1oZSsfdbXsPotvOPfwIvNokWfx3eB7DaCh67/eitQOl1ya6zRQUNIxbgWscdSgnRghLnw==
Received: from BN7PR06CA0052.namprd06.prod.outlook.com (2603:10b6:408:34::29)
 by PH8PR12MB6939.namprd12.prod.outlook.com (2603:10b6:510:1be::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.31; Sun, 5 Feb
 2023 13:55:56 +0000
Received: from BN8NAM11FT054.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:34:cafe::8e) by BN7PR06CA0052.outlook.office365.com
 (2603:10b6:408:34::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.31 via Frontend
 Transport; Sun, 5 Feb 2023 13:55:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT054.mail.protection.outlook.com (10.13.177.102) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.32 via Frontend Transport; Sun, 5 Feb 2023 13:55:55 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 5 Feb 2023
 05:55:47 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 5 Feb 2023
 05:55:47 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.9) with Microsoft SMTP Server id 15.2.986.36 via
 Frontend Transport; Sun, 5 Feb 2023 05:55:44 -0800
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
Subject: [PATCH  net-next v2 5/9] net/sched: support per action hw stats
Date:   Sun, 5 Feb 2023 15:55:21 +0200
Message-ID: <20230205135525.27760-6-ozsh@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230205135525.27760-1-ozsh@nvidia.com>
References: <20230205135525.27760-1-ozsh@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT054:EE_|PH8PR12MB6939:EE_
X-MS-Office365-Filtering-Correlation-Id: 137b4ba6-b8f0-44df-2f5d-08db0780b3ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zxEgNW5a9FVGZq+WgnlM7Gf85PsDDx39H2mAeDBYHNtlXibvCCgLDsCSNfKlcf/WdidBm2ZX+5kA3k6HqyrqorwsxYn4osFK4ymYTSf7WN8xFjMKtqtClSqOmkiXqdBw4a56wnbyBeAO1WHi7TS/JpXRYX4Be6RqWDYj7U1HMQc1HBozah9QNIgPFRVwl1keZ6BxxkDjf+l90LtD2sJG0oye7GvryiptPWrxmorH8AfOxQzLkE6ogc3s2dFV2XQHd2EtVw9NM5xSFj+TiDtRH6nqwktx9+GemOFd4Q0cY6APswbHdUMdVYmyKyurrMsvSwtoDDSU1Y/UYu1Fw2mH9U8kNed0wigfXaQQDbFcrXGUGqNuay6KBsLN3nrZXGvyF0OC1rITDTqD5sfGd1exAYARYQQCePkPWWPQsOqh7g9ImwzhdENfA89Q0fb6ykjt4Y3U7NtfbWNwqInP56DoFsdCbqdEsni4EzJw/sY6xw9SzEMFqfYPoZQbQqCQc5Y6lQOBvU8plRFB+KnvxZxLfCpK2V0WFW+OKdw4F3krltZ+gR1nJkuzUeuySWzZ/+uPVkwxnnL0X/SgMoj8VX62ecMSxb2n0TBmCcTlb2m1aK2ldf5d5zHuaWM25PYRYTEA49L/PDDmwi3ii3UVMmN1/T1SRqVzPKD2eHWeLQJWvXFk7Y+ScxLQ6HmoEBAi+xtwyR3dSoNnbu0s4H5AxOIlL5utDz99dMeA6EyiEedZUeM=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(396003)(136003)(376002)(346002)(451199018)(36840700001)(40470700004)(46966006)(36756003)(2616005)(2906002)(186003)(26005)(86362001)(107886003)(6666004)(8676002)(478600001)(5660300002)(36860700001)(82310400005)(1076003)(336012)(426003)(4326008)(356005)(40480700001)(83380400001)(316002)(54906003)(8936002)(47076005)(70586007)(70206006)(6916009)(40460700003)(41300700001)(7636003)(82740400003)(309714004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2023 13:55:55.6965
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 137b4ba6-b8f0-44df-2f5d-08db0780b3ee
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT054.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6939
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

---
Change log:

V1 -> V2
    - Fix static function without inline keyword in header file
    - Rearrange flow_cls_offload members such that stats and use_act_stats
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
index be21764a3b34..4cb6022449dd 100644
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

