Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECD9668B015
	for <lists+netdev@lfdr.de>; Sun,  5 Feb 2023 14:55:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbjBENzv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Feb 2023 08:55:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbjBENzt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Feb 2023 08:55:49 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2053.outbound.protection.outlook.com [40.107.220.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D07411E29B
        for <netdev@vger.kernel.org>; Sun,  5 Feb 2023 05:55:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i1qo9rqCaLZkD8W5T7ZpmEV1bkmWrbq8c3tceE64WMNRw08wlppz2aSAldVFgt8JNx1VW88R9bwLsxwSCE+iPpvIbJZf0noPGhmg43yEfAmdkSOZpVKGKsAA4KJXNlLr0ms4gD+kdQLyEHyJpoafUgeBgOu5xZwaOedtsxof0Ul9cRIHCjerapgR+Qf7uM8Tz6GjG7a3zhDG4NzMbw68NkVI9znF6l2YRSoGA4TxdSYoFuVxW9OnYPrPuLkROf3PlBMo/hnYPmIARwMJkHAiC4WZyYd92rOrr7L0vX2kfuNd+OX7qub78zGan0/QchIvEbHPfUIuwlLIiqNsheUP3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QRKUjVuKtymUxy4OKbYSD1KuqGcgNQTGUiqtVq3Ote8=;
 b=XcJDZ8REB5GR7iQ9HPPQ3tAC23iVkW8TfHHRIpjeJ5MOdtajGp1GK5qRO5s01uqr0ZXF/nDsWb+5e+MaOJRxZ+L+7NavbCkWd3HVtv37KyLUAqsc3T+WCGg3yU/DdJB7JQ8BxkhWowChq54JgMS7IB3NRGLehXcYdrNrPHezZuvAFeVeDPkPcwMHEiL2/fhQYw6Ak0lZ0c5Ro1P+YteOz1XHAUXKu3u0+eRDjB1ypUWKv82vXjjw2B0PEesDRKOdSZdkGAZ/nBA8NaopWiV+FAjujwkpyaQk76G6gFxDh248AijD4BX0oxQW+olaZyBmRNQY4b2p3tkFc/C3+/MLcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QRKUjVuKtymUxy4OKbYSD1KuqGcgNQTGUiqtVq3Ote8=;
 b=eVLoRMbC5zNK6c9W3Z8H3tHBDgQmI3hmVb0e9HRAW1a5X3sEnT3Td5jecFDxBADQjGf3Rven4WKK0ytV5uBFoz7zYALLGZDMEu0Ob1MW0nJ/NlRBf4wiDphfrniBQ3bdiPMlD0IPWCO2oRb48hirQf4ExO9Ebxt2nGpP4AK0HuRU/WxFQdH/IUCMy4maiEjjCq3Su5fz9PjrUUuflci/aCTGagKcg4JYvlX8lPZ2MG/1a5fKfR7HrpvBrfuWUyTzYQp5xvPzzfo51vnfBCeG8YvCMw6RgjxbsiPx6+H4N+TP4Me9BMIz3yRNvj7Rbl/PGAa8K+h1izznVLCsyjEORw==
Received: from DM6PR08CA0010.namprd08.prod.outlook.com (2603:10b6:5:80::23) by
 SA3PR12MB7903.namprd12.prod.outlook.com (2603:10b6:806:307::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.32; Sun, 5 Feb
 2023 13:55:45 +0000
Received: from DM6NAM11FT104.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:80:cafe::d6) by DM6PR08CA0010.outlook.office365.com
 (2603:10b6:5:80::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34 via Frontend
 Transport; Sun, 5 Feb 2023 13:55:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT104.mail.protection.outlook.com (10.13.173.232) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.34 via Frontend Transport; Sun, 5 Feb 2023 13:55:45 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 5 Feb 2023
 05:55:41 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 5 Feb 2023
 05:55:40 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.9) with Microsoft SMTP Server id 15.2.986.36 via
 Frontend Transport; Sun, 5 Feb 2023 05:55:38 -0800
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
Subject: [PATCH  net-next v2 3/9] net/sched: pass flow_stats instead of multiple stats args
Date:   Sun, 5 Feb 2023 15:55:19 +0200
Message-ID: <20230205135525.27760-4-ozsh@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230205135525.27760-1-ozsh@nvidia.com>
References: <20230205135525.27760-1-ozsh@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT104:EE_|SA3PR12MB7903:EE_
X-MS-Office365-Filtering-Correlation-Id: 850f1859-86ea-4265-00ec-08db0780adeb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Mmb7HmBKy4r+DtPaMjzv7Y1QOITaQLEgt8PjDzuu85Mk62KFF8IT1UJFPB1/9OJYdTs9dRh4jgLSfj0SfbnVsmyg8bIxDQLokKx897hnLvxNVQLR32tOIFh1ZZu4nPZR6xbjFma25MjeXlxin9rTlalFmJq9U2fFAoXbV7K/GNO8m46t6PdFGTES3orSVpj6Qbsk2FnJX0oO8PsS9Lm98FzAfPofWglGpt/Q0bqDna1uXlRDrUDRS8Np9J8PFvXr1Mt7T2iPzdHbR4uhY1d2nbECvk7ZbB6DurRpeP/BjebhLm/HbKyWYKf8bx8QocTAASQn5AfNKOCqo5jZEGCLbplt1XYeGVlPQ8JdhOd/yJQwnvEywuZ1htkj0U8QIMLCtbY8Vc35ayTClUTM9TE2058J18aUCuBfTklaTni7DciP/s8UT8ZG93cO3tbWaPLn6l2GoZtzsSR7YQ2dBTr29RTIQz8lW3bI/McA5nNpF9K25GeG04NTeD8XhwtQNEs5ofr5dWrOUMRxwEuG2nK9TiXnY6Lwht2SljKKcV6vCYAIlDaFjz3BgYhNeO41mOGUjKjjNjjdC9Ugbhi2E13PHzlgG/NoBDgODBoLfzfhIsNIjVg2Gc/NnP3JjnMRSKE6iESwqKFW8bxlPr5bnV73Ot1KTEvoilk7LhbO+/hLkDB6mARUe5MAcvKKtPO1WE+GP8TPqKRjg29DXP1BVXt7Eg==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(136003)(39860400002)(346002)(451199018)(36840700001)(46966006)(40470700004)(2906002)(6916009)(70586007)(336012)(8676002)(70206006)(4326008)(2616005)(47076005)(426003)(86362001)(36756003)(82310400005)(36860700001)(83380400001)(8936002)(40480700001)(41300700001)(107886003)(6666004)(186003)(54906003)(82740400003)(1076003)(478600001)(26005)(316002)(40460700003)(356005)(5660300002)(7636003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2023 13:55:45.6562
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 850f1859-86ea-4265-00ec-08db0780adeb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT104.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7903
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of passing 6 stats related args, pass the flow_stats.

Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
 include/net/pkt_cls.h    | 11 +++++------
 net/sched/cls_flower.c   |  7 +------
 net/sched/cls_matchall.c |  6 +-----
 3 files changed, 7 insertions(+), 17 deletions(-)

diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 4cabb32a2ad9..be21764a3b34 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -294,8 +294,7 @@ static inline void tcf_exts_put_net(struct tcf_exts *exts)
 
 static inline void
 tcf_exts_hw_stats_update(const struct tcf_exts *exts,
-			 u64 bytes, u64 packets, u64 drops, u64 lastuse,
-			 u8 used_hw_stats, bool used_hw_stats_valid)
+			 struct flow_stats *stats)
 {
 #ifdef CONFIG_NET_CLS_ACT
 	int i;
@@ -306,12 +305,12 @@ static inline void tcf_exts_put_net(struct tcf_exts *exts)
 		/* if stats from hw, just skip */
 		if (tcf_action_update_hw_stats(a)) {
 			preempt_disable();
-			tcf_action_stats_update(a, bytes, packets, drops,
-						lastuse, true);
+			tcf_action_stats_update(a, stats->bytes, stats->pkts, stats->drops,
+						stats->lastused, true);
 			preempt_enable();
 
-			a->used_hw_stats = used_hw_stats;
-			a->used_hw_stats_valid = used_hw_stats_valid;
+			a->used_hw_stats = stats->used_hw_stats;
+			a->used_hw_stats_valid = stats->used_hw_stats_valid;
 		}
 	}
 #endif
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 0b15698b3531..cb04739a13ce 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -502,12 +502,7 @@ static void fl_hw_update_stats(struct tcf_proto *tp, struct cls_fl_filter *f,
 	tc_setup_cb_call(block, TC_SETUP_CLSFLOWER, &cls_flower, false,
 			 rtnl_held);
 
-	tcf_exts_hw_stats_update(&f->exts, cls_flower.stats.bytes,
-				 cls_flower.stats.pkts,
-				 cls_flower.stats.drops,
-				 cls_flower.stats.lastused,
-				 cls_flower.stats.used_hw_stats,
-				 cls_flower.stats.used_hw_stats_valid);
+	tcf_exts_hw_stats_update(&f->exts, &cls_flower.stats);
 }
 
 static void __fl_put(struct cls_fl_filter *f)
diff --git a/net/sched/cls_matchall.c b/net/sched/cls_matchall.c
index 705f63da2c21..b3883d3d4dbd 100644
--- a/net/sched/cls_matchall.c
+++ b/net/sched/cls_matchall.c
@@ -331,11 +331,7 @@ static void mall_stats_hw_filter(struct tcf_proto *tp,
 
 	tc_setup_cb_call(block, TC_SETUP_CLSMATCHALL, &cls_mall, false, true);
 
-	tcf_exts_hw_stats_update(&head->exts, cls_mall.stats.bytes,
-				 cls_mall.stats.pkts, cls_mall.stats.drops,
-				 cls_mall.stats.lastused,
-				 cls_mall.stats.used_hw_stats,
-				 cls_mall.stats.used_hw_stats_valid);
+	tcf_exts_hw_stats_update(&head->exts, &cls_mall.stats);
 }
 
 static int mall_dump(struct net *net, struct tcf_proto *tp, void *fh,
-- 
1.8.3.1

