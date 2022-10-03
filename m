Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 613BD5F2888
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 08:18:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbiJCGSh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 02:18:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbiJCGSd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 02:18:33 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2051.outbound.protection.outlook.com [40.107.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7714B3E761
        for <netdev@vger.kernel.org>; Sun,  2 Oct 2022 23:18:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LuWnGt4G7kDIgzXa27gzzX2mQLoswohxl0avv1s3Ul/hfLdnH9eSMn1HA7ubb7V9zmjaNnx0w4aAkjLWy8ueTChigaz101fqxYzHqY71w8G8FQnKwVCWCSove6Dh6P4+gNJeQjIJZg7vUS8REMIWoCybl/7Ag3533jzNP/XePpezU/BOP+csmsg5wZWqNYj8m7zz0sbluA3+aW3XTbHR20Vt3VrbqpWU1DgIun0YUtbhBAKFkUpkMlYdP3r8ZK63ZepdhWOdgB/0XxOXxq1FGuQvjSi+abZITDKVlffCQC0437WWsoUYhi8Qql6TOAfIzlLd84YqV22XtB/FE6m98w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yc/wEROpEuFnSEizp9CjtEXC2m3onZfMlPV/wZlNLMs=;
 b=ROF499qWqRvIiYyR/AuA9QCbWIQF5s8S6obM9+nlbcRaLyxUIJRlI8jgSXJOCqefvrh53s+uZgcaxWTFr8+pzOp/t5uIaWCcW9lLqY9pSyksNTntArnxKpgwLK/LmlPc7muqZbKJLPf1Dh/ERdUYhUxf8lvdDAGP2TWDclChRxKWLjkoWL3ButCXHcv2po9d24zCiHk0V0kHdwWmTbADS0QuJq3BHAr/VnRn3y2kGVtv2P7pqf+Q5h0tvTQ2pWa7l+Dx0DFk9+Xfuw8dxiW8f4GtBrwihRZcn5oDfsKEBMGyusWepb2K/HfemNwdWQgrxFoKF+Amqu4VnLmr91fboA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yc/wEROpEuFnSEizp9CjtEXC2m3onZfMlPV/wZlNLMs=;
 b=Qafv1PuHgrU4DGd9W3pffK0hRShsUVuTiPiD6+z4YTovYQiNf4doypI9Vy3lCW+5Hg7cZkktfQFrG1Qc16yMA6HNdfaTp4lBZr5WYFMa2wC9fsEEXOZ1lryZdAfIKyqLjzkHHLg3/+VwBe0F1jNWFlLBKbhNOoiFY6Eo4YsPm8/u4W/Tdmrb0xrP7DMtXZdFU89aSpUCPXGzuaxCqXmGlMV0q0X6WgGXAiFd1cGnRPeMOpOkXscAgZLKHmPN/75HvShBxosHIm1z4auDG6zlGIwxabY99j4p9JeHJ5hQjisK9vkUAFTOi69mtVvXs8PgVj91LG9dIadhva8+9ErbgA==
Received: from BN0PR02CA0045.namprd02.prod.outlook.com (2603:10b6:408:e5::20)
 by CH2PR12MB4232.namprd12.prod.outlook.com (2603:10b6:610:a4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.28; Mon, 3 Oct
 2022 06:18:26 +0000
Received: from BN8NAM11FT051.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e5:cafe::eb) by BN0PR02CA0045.outlook.office365.com
 (2603:10b6:408:e5::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.26 via Frontend
 Transport; Mon, 3 Oct 2022 06:18:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT051.mail.protection.outlook.com (10.13.177.66) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.17 via Frontend Transport; Mon, 3 Oct 2022 06:18:26 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Sun, 2 Oct 2022
 23:18:12 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Sun, 2 Oct 2022
 23:18:12 -0700
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.6) with Microsoft SMTP Server id 15.2.986.29 via
 Frontend Transport; Sun, 2 Oct 2022 23:18:09 -0700
From:   Oz Shlomo <ozsh@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Jiri Pirko <jiri@nvidia.com>, Jamal Hadi Salim <jhs@mojatatu.com>,
        "Simon Horman" <simon.horman@corigine.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Oz Shlomo <ozsh@nvidia.com>
Subject: [ RFC  net-next v2 1/2] net: sched: Pass flow_stats instead of multiple stats args
Date:   Mon, 3 Oct 2022 09:17:42 +0300
Message-ID: <20221003061743.28171-2-ozsh@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20221003061743.28171-1-ozsh@nvidia.com>
References: <20221003061743.28171-1-ozsh@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT051:EE_|CH2PR12MB4232:EE_
X-MS-Office365-Filtering-Correlation-Id: 2acf964f-9bc0-424b-b44a-08daa507151f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o2WUS/BghRltOzrsbqRjDrlkUXNJnjIeassJjlD/GrPjpM6HpQ/Kjl0eYviOYPvYy/WLNrbb7BsaTx0FIXYbwBvLmX5yAS7zD9KdxB3SBdYIRd/HxuiZPcavk5jxJMqfxRQN4nQBQl7uExXKeJmQwuKPddsMW6rQi9XQ6cOlSUotiKvEJsOSXfOBqQPQa18MMaG77njBgTujTbBNZU/ZDPMwAw28j3GCOPjhQa8cgVAi/nv94K6pAc0u4sPuSVkA3kSDOKw7b5XZRlqtxIIwdNtst/zKV+77rBHlCAm/X3Y3dqs1jL38heeA0ctfujZ3D+arH6Ullfr0UQJCz7U4zI6HGINTHlt2vZ65wa/yvdMIs0qv0K45q1heqsvwZVlvsx1pMHO1hKOp4KqbqdJcgAJCDgBGbGStzvk+R4nuWdOEC4iFN3iLgrj322fYjQpRTqZsCgy+i9VWStHL3WnWP/5CoC7cup1krSKyKh5k0XEvEQ2EEziOXSyi8orVc0M6Hfh+evTCDTCudmXosRXake5ryhcfhPTnXdD2cA7bCzs3SmXwpph4btoLHy7xVTRTCQeESHUW/HAck68KhJBDP5QqknOSBDH+MfdpVJ8Wj4E+sajv2Vdmi8aaJz1TTgVlaxNDSRTYtm6+FpCZLhsDEaL3BqjUrDlQJgjuGo3vWm3jTHRPb1/sNandjrFKvCUPmdTNyUY26H8+/uf5upn5jbWcCN9DLjBsTblu80xgy7A9eBQsAKqNg/6SYI6UrAZYfVjjFrurjoFleVoUm20yQQ==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(396003)(39860400002)(376002)(451199015)(36840700001)(46966006)(40470700004)(70586007)(70206006)(6666004)(4326008)(41300700001)(8676002)(1076003)(186003)(107886003)(2906002)(47076005)(426003)(40460700003)(2616005)(83380400001)(36860700001)(336012)(26005)(86362001)(36756003)(8936002)(5660300002)(40480700001)(82310400005)(54906003)(7636003)(6916009)(356005)(478600001)(82740400003)(316002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2022 06:18:26.2225
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2acf964f-9bc0-424b-b44a-08daa507151f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT051.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4232
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

Instead of passing 6 stats related args, pass the flow_stats.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
---
 include/net/pkt_cls.h    | 11 +++++------
 net/sched/cls_flower.c   |  7 +------
 net/sched/cls_matchall.c |  6 +-----
 3 files changed, 7 insertions(+), 17 deletions(-)

diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index d376c995d906..d5b8fa01da87 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -282,8 +282,7 @@ static inline void tcf_exts_put_net(struct tcf_exts *exts)
 
 static inline void
 tcf_exts_hw_stats_update(const struct tcf_exts *exts,
-			 u64 bytes, u64 packets, u64 drops, u64 lastuse,
-			 u8 used_hw_stats, bool used_hw_stats_valid)
+			 struct flow_stats *stats)
 {
 #ifdef CONFIG_NET_CLS_ACT
 	int i;
@@ -294,12 +293,12 @@ static inline void tcf_exts_put_net(struct tcf_exts *exts)
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
index 22d32b82bc09..82b3e8ff656c 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -500,12 +500,7 @@ static void fl_hw_update_stats(struct tcf_proto *tp, struct cls_fl_filter *f,
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
index 63b99ffb7dbc..225e87740ec5 100644
--- a/net/sched/cls_matchall.c
+++ b/net/sched/cls_matchall.c
@@ -329,11 +329,7 @@ static void mall_stats_hw_filter(struct tcf_proto *tp,
 
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

