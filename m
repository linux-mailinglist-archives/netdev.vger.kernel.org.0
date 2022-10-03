Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC10A5F2889
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 08:18:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbiJCGSf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 02:18:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbiJCGSc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 02:18:32 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2063.outbound.protection.outlook.com [40.107.220.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 334043DF3B
        for <netdev@vger.kernel.org>; Sun,  2 Oct 2022 23:18:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AyDSiezguwCloSPDHoZIwXoKUaPpfxua6cmWRD40+TKDwJr3toxU8/FcukUG3vCIinipDj8RBOSjJemOdItOOJrfR8zcdx0KJz2Q8fYk9fWIMkoVOazoZMVi/aRIGa/8gsnqbK1oxTBmbDWwYuoA2Zzlp9CcoFTkGoRkxsyCV7DmHOnSKeGPQ4g4tfqzO6BLmIcA7419Slje1ZNwj5lOARymuNzHYe+zXTgj/ai3m6+rc+vD3wpytm2xoqhuIroIGp3enafpHAUmW5UsODFM5hY6kSPv2WQrLS4De7AZ9Fz80W5Xbph/RuxZpluxEGd/dX0Djs2T5sSA2o7cWGkD9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=egctI68NCuOG8qUhkPoTPAn9f9+QCoWjfJEsXaiAFTg=;
 b=ijJvZwnOWv7Ee4TeSS28LR/Dz31Bm7R4Q/jEwYo3NUqnRbrzMXCsL8hmlIw4cBJq6cvcpv9YSAQ0GzE9Wz8LKgE/1yOaWuO9BUOGaFJwpLcBaPGIF8B04BXoY0JATYLPOjk6rhaaLGleTl7elPrIZfRRZYHiqtWPDuo6O2kKzWJ3NQ+MSLDjP7Jk4HcFd30CmAJKJjhaTttqh6AxZvimTmUJFC3D5s43ijPZgPgExqeOcsJU56d8k53/6Kj59PxyCSIJniDyQ/Ap4bBAPyGoM1zEfQfwYmI8Ywp4kyqVuzSsSHgC+ugbJVElChqGB3EMOZLGR3W0/DP7ffEqYzI99w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=egctI68NCuOG8qUhkPoTPAn9f9+QCoWjfJEsXaiAFTg=;
 b=iO8bPk4OpSbdC5xk86fujmqpSCUshAoA3pk3IlBazBBgYbmZjqs9thM0WVXZSTCIMj1i0eskIOxdAPn0LJLxuXu0yaQ8SCuQWU0wZmutlnLgu0DFG81tGAJU2EiyGnqduxOTQ+dEWz85ss3vEbIKtu/Pi5kZM58DK/usrPtXtJQhh5krNM7PoLQVIdWCNoj19IhQ0j3IGYVOB6ZpJionnWRBkmV1N7RuQqe/Yiayd8OLu/jrx0xszZxYdOLV7g1p+ejoDj/o6lCyVGfup8IalEP1eu0jYMcWamy+AbPk8es/xsnTYShQVN8rSDELSM4UcF0oJ0EzuVodAgFWDTzhJQ==
Received: from MW4P220CA0027.NAMP220.PROD.OUTLOOK.COM (2603:10b6:303:115::32)
 by PH7PR12MB7164.namprd12.prod.outlook.com (2603:10b6:510:203::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.19; Mon, 3 Oct
 2022 06:18:25 +0000
Received: from CO1NAM11FT053.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:115:cafe::bf) by MW4P220CA0027.outlook.office365.com
 (2603:10b6:303:115::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.28 via Frontend
 Transport; Mon, 3 Oct 2022 06:18:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT053.mail.protection.outlook.com (10.13.175.63) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.17 via Frontend Transport; Mon, 3 Oct 2022 06:18:24 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Sun, 2 Oct 2022
 23:18:17 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Sun, 2 Oct 2022
 23:18:16 -0700
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.6) with Microsoft SMTP Server id 15.2.986.29 via
 Frontend Transport; Sun, 2 Oct 2022 23:18:13 -0700
From:   Oz Shlomo <ozsh@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Jiri Pirko <jiri@nvidia.com>, Jamal Hadi Salim <jhs@mojatatu.com>,
        "Simon Horman" <simon.horman@corigine.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Oz Shlomo <ozsh@nvidia.com>
Subject: [ RFC  net-next v2 2/2] net: flow_offload: add action stats api
Date:   Mon, 3 Oct 2022 09:17:43 +0300
Message-ID: <20221003061743.28171-3-ozsh@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20221003061743.28171-1-ozsh@nvidia.com>
References: <20221003061743.28171-1-ozsh@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT053:EE_|PH7PR12MB7164:EE_
X-MS-Office365-Filtering-Correlation-Id: 192870d9-32ff-49bd-df82-08daa5071448
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +ZxWJL1fBtRb4btYCNxKjlcmaR5Bxkn0BqBqZC6qi63+5MAstPGqmmImpDM3V2Rcx5RgSKPRbp8ceN272/tvIbQub0T5BfJJhMLtQRClf6okq43Nrx9x2JZjuAzbhJULeXvTzsP+kJTfAG0KOxZdRY4v8eJ/sAZWX8FMFShk1JVJqbKN9EtDH7wOaN6d5lfA9W+JfVQaPW7j6b33M+pJixcf5d3LZA0L8POy1+nPwdXv8xVftTReSiIaF4Wd2t1mMTGqwXC66kiDkYcnh9mUnV3l0CNM3LmmacY2aPydXbw0LQubKFo3x9BXWan5K+zy0wEdpk8e8H9voUOA9F74ssTEO9EQMZWdox17n7Sycydoom+/zmfbkmn+Yjd3Azs/qWdm/MFzEH1LE7wAsoj3Mqlr5ne4EegzXLkuuQT64n/BNrscBqnVXmcmQR3j3kd+4ZHTeO2b5o7p+kel0M6mXP9ExNWClDUkk34qaCLsihPNK0kVtXa8LbDFyjKwbiPgaI2ojYokWam9fUP5yKppVATU531/xdQvViLsnevIbWI9ahV2rbgmuKTpO2AEg4Qm022gyMa2LX2VHWOpBD6yXqwcDIlP4e0bCdy7Lf4IMwcdkr3IX3uJUaJcpDyQG78tXwqd6TfkKZaax3+x9cvc0F4LTAx+Is6qsZRElTd6EdtVcwAfRtHzhcohQsKhXVjmEJ10bYbI1fooLo55dUZWHMwmTVMJyrbFUm8CiGbBv3jZTaNAnTws9h4zhCzo7wYRzemPl39mO2Cs/5a+OLlzMg==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(136003)(396003)(39860400002)(451199015)(40470700004)(36840700001)(46966006)(86362001)(478600001)(107886003)(6666004)(70586007)(70206006)(36756003)(26005)(8936002)(41300700001)(8676002)(2616005)(316002)(54906003)(6916009)(4326008)(5660300002)(1076003)(40460700003)(186003)(47076005)(2906002)(336012)(40480700001)(82310400005)(83380400001)(426003)(82740400003)(356005)(7636003)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2022 06:18:24.8458
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 192870d9-32ff-49bd-df82-08daa5071448
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT053.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7164
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current offload api provides visibility to flow hw stats.
This works as long as the flow stats values apply to all the flow's
actions. However, this assumption breaks when an action, such as police,
drops or jumps over other actions.

Extend the flow_offload api to return stat record per action instance.
Use the specific action, identified with an action cookie, stats value
when updating the action's hardware stats.

Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
---
 include/net/flow_offload.h | 10 ++++++++++
 include/net/pkt_cls.h      | 18 ++++++++++++++++--
 net/sched/cls_api.c        |  1 +
 net/sched/cls_flower.c     |  3 ++-
 net/sched/cls_matchall.c   |  2 +-
 5 files changed, 30 insertions(+), 4 deletions(-)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index e343f9f8363e..1c88ca113544 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -213,6 +213,8 @@ struct flow_action_cookie {
 	u8 cookie[];
 };
 
+#define FLOW_OFFLOAD_MAX_ACT_STATS 32
+
 struct flow_action_cookie *flow_action_cookie_create(void *data,
 						     unsigned int len,
 						     gfp_t gfp);
@@ -221,6 +223,7 @@ struct flow_action_cookie *flow_action_cookie_create(void *data,
 struct flow_action_entry {
 	enum flow_action_id		id;
 	u32				hw_index;
+	unsigned long			act_cookie;
 	enum flow_action_hw_stats	hw_stats;
 	action_destr			destructor;
 	void				*destructor_priv;
@@ -442,6 +445,11 @@ struct flow_stats {
 	bool used_hw_stats_valid;
 };
 
+struct flow_act_stat {
+	unsigned long		act_cookie;
+	struct flow_stats	stats;
+};
+
 static inline void flow_stats_update(struct flow_stats *flow_stats,
 				     u64 bytes, u64 pkts,
 				     u64 drops, u64 lastused,
@@ -588,6 +596,8 @@ struct flow_cls_offload {
 	unsigned long cookie;
 	struct flow_rule *rule;
 	struct flow_stats stats;
+	struct flow_act_stat act_stats[FLOW_OFFLOAD_MAX_ACT_STATS];
+	bool use_act_stats;
 	u32 classid;
 };
 
diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index d5b8fa01da87..642e6f07cbf0 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -282,13 +282,27 @@ static inline void tcf_exts_put_net(struct tcf_exts *exts)
 
 static inline void
 tcf_exts_hw_stats_update(const struct tcf_exts *exts,
-			 struct flow_stats *stats)
+			 struct flow_stats *flow_stats,
+			 struct flow_act_stat *act_stats,
+			 bool use_act_stats)
 {
 #ifdef CONFIG_NET_CLS_ACT
+	int nr_actions = exts->nr_actions;
 	int i;
 
-	for (i = 0; i < exts->nr_actions; i++) {
+	if (use_act_stats)
+		nr_actions = FLOW_OFFLOAD_MAX_ACT_STATS;
+
+	for (i = 0; i < nr_actions; i++) {
 		struct tc_action *a = exts->actions[i];
+		struct flow_stats *stats = flow_stats;
+
+		if (use_act_stats) {
+			a = (struct tc_action *)act_stats[i].act_cookie;
+			if (!a)
+				break;
+			stats = &act_stats[i].stats;
+		}
 
 		/* if stats from hw, just skip */
 		if (tcf_action_update_hw_stats(a)) {
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 50566db45949..c5a6a0d7f7a1 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3553,6 +3553,7 @@ int tc_setup_action(struct flow_action *flow_action,
 		for (k = 0; k < index ; k++) {
 			entry[k].hw_stats = tc_act_hw_stats(act->hw_stats);
 			entry[k].hw_index = act->tcfa_index;
+			entry[k].act_cookie = (unsigned long)act;
 		}
 
 		j += index;
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 82b3e8ff656c..ff004f13d0c9 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -500,7 +500,8 @@ static void fl_hw_update_stats(struct tcf_proto *tp, struct cls_fl_filter *f,
 	tc_setup_cb_call(block, TC_SETUP_CLSFLOWER, &cls_flower, false,
 			 rtnl_held);
 
-	tcf_exts_hw_stats_update(&f->exts, &cls_flower.stats);
+	tcf_exts_hw_stats_update(&f->exts, &cls_flower.stats,
+				 cls_flower.act_stats, cls_flower.use_act_stats);
 }
 
 static void __fl_put(struct cls_fl_filter *f)
diff --git a/net/sched/cls_matchall.c b/net/sched/cls_matchall.c
index 225e87740ec5..3d441063113d 100644
--- a/net/sched/cls_matchall.c
+++ b/net/sched/cls_matchall.c
@@ -329,7 +329,7 @@ static void mall_stats_hw_filter(struct tcf_proto *tp,
 
 	tc_setup_cb_call(block, TC_SETUP_CLSMATCHALL, &cls_mall, false, true);
 
-	tcf_exts_hw_stats_update(&head->exts, &cls_mall.stats);
+	tcf_exts_hw_stats_update(&head->exts, &cls_mall.stats, NULL, false);
 }
 
 static int mall_dump(struct net *net, struct tcf_proto *tp, void *fh,
-- 
1.8.3.1

