Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D0BF68BF24
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 15:01:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231287AbjBFOBS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 09:01:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjBFOAy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 09:00:54 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2050.outbound.protection.outlook.com [40.107.223.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 915E11EFCD
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 06:00:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OFKwEasGJicf3PTvMJOFUGJZB5e3xd1M8wsWAZ5DcKXELRyJs9pdHFSIEXP5eMhFqnbfs4KWMymG2XuXdv7NFgmKz7SRbfrqpnqao8CfnJvHBaEMPO3nVP/1TD4ZlGyXqeSmRGcVYQTIvHiiXSLKDF2gj7M1/thUngf8qZv19gOvQbE1HObaWM1Dxb51qlcS+gqu8yU/U4NRjXFmVl2H2Ekn+ZAQPprqCWI8J0cDMEjefAqKE6yjaQbmCoeIItwBeqVeXrVQYIKTu1+RuKNNDmr2iWiub68m4982tyhMIzxHDH+lXQPPK0UolSiYDrIT1wd/Tfdmt8WA39y8p5wfLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EEhkDS06X5QHgDdvQADms1spQZ2RgBw0yubZ/8t+ebM=;
 b=njRsmTyseg6goOVVSq6306EIn0zBZvzGIxZohcX0puExyVClp+6EtVy1MSetl9EXztaW0Q3/32b4bLojQ49KToZKUkPeY0pJ5am5QtM/JqV0BcCt7gd8qQPGmpC6FaxmoHvHblb8vNNgD00iXTWIZ3c9yXs81zRe78FcyEBc4HN7E30sc+Zz1srvAo5NuyprOkGzyc5D6R1mdOIDD8A0SiRYdytdRIw9Q/axLPIwt+8TuzYGTwwDX3kwCRJKlLf2meDJO/r2nmgvPh8157GaNZMGGMEY4O0L9xtnymgHK/WOW/GR26FrFmjitvT3xDqSEw6NI1Z7uELp0ignzkfNng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EEhkDS06X5QHgDdvQADms1spQZ2RgBw0yubZ/8t+ebM=;
 b=rhH/xQnKGrBkgj4tfx+7A78JeIi4UFf65Pdi9C4LKydOmgJmPyOLBUTT5BaG7bl8dasg5AaNND8OS71v9AqZ5sw0D1kJ5vi6CsVOT0E0YrTEjLLYbggzlSScuafoeiBhHH5nWNhAfPsi310JpCT/YLySseFPtN2bxkshThqPAMoFS+BStx6pJXf+s+9r/AIfK4SeTiEHsNPH7oQJJQpg5iZ79oM4mSKGX0E0l/ZFpJ9MJ+Oc+sANHrGUvm3rb+mskn8cRy6eDrI0camSvFLF3u+cYKHSMsNcOw1cL0/ooC72LAIWAePkmLU5sPbqAnTrhi5r0cGF/ethA9HPGUnHdQ==
Received: from DM6PR11CA0043.namprd11.prod.outlook.com (2603:10b6:5:14c::20)
 by PH7PR12MB6441.namprd12.prod.outlook.com (2603:10b6:510:1fb::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Mon, 6 Feb
 2023 14:00:28 +0000
Received: from DM6NAM11FT059.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:14c:cafe::ab) by DM6PR11CA0043.outlook.office365.com
 (2603:10b6:5:14c::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.32 via Frontend
 Transport; Mon, 6 Feb 2023 14:00:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 DM6NAM11FT059.mail.protection.outlook.com (10.13.172.92) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.34 via Frontend Transport; Mon, 6 Feb 2023 14:00:27 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 6 Feb 2023
 06:00:14 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Mon, 6 Feb 2023 06:00:13 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.126.190.180) with Microsoft SMTP Server id 15.2.986.36
 via Frontend Transport; Mon, 6 Feb 2023 06:00:11 -0800
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
Subject: [PATCH  net-next v3 3/9] net/sched: pass flow_stats instead of multiple stats args
Date:   Mon, 6 Feb 2023 15:54:36 +0200
Message-ID: <20230206135442.15671-4-ozsh@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230206135442.15671-1-ozsh@nvidia.com>
References: <20230206135442.15671-1-ozsh@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT059:EE_|PH7PR12MB6441:EE_
X-MS-Office365-Filtering-Correlation-Id: 6627ae75-7f61-444b-bf64-08db084a8064
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LQAxuzGPVdAYMeqxLLJlvEdq+Excw3se8PahOlFwVy/ApcNMmFoXMoQnEVa724zrGX4a+m6yEt1sJqPB45AqjGTUo8SHEG8ePcbyOG0Q1TeUG//H9ipHmEVzKjnKHgZCbJlP4fuABj1gIc3FzOgqA8YxkxOU+XwHNt9b73W3S0PbHg2v3+H7dg/fLvH+Z6RT/DZ8hSVgT4mPHIyh0S48uLWrCptpwEtzDpFPr2vOSJdD6eAXqgeQxulLSdJIT+rpOnD1dv5/V672+56zTNQsFL7Zgy5x3BjAMDPn9Ewi6SHnfGPFC18M9JToC4Ne5i/NCHeVbw/xK0vX9Pkqd7gBnKkTIxqOMUhtlhL/WoCdHGT7u4FRqaTLjrEo+/2koJrYL2UDx37zlbhPnhVTXkd4kHeMKvsh33tkQ/r15yhviDKYLiQ6B9xYcFwi2hiqZgd8+1GV+BjLCee77Cp9qJU5WxCdKqzSmmz81FBZHrAAlcaVQ2M1ncaUIAXe/vyHELRAJ25TUri8FZ8eeLaQJd7yWYkJisrvEWYr8pJsexPwB4qqDP5phQOHMMBuwxeg52xuPUF9sWlCqKZXBg9ZeRVxwrSApbKyIjcOUlh4gDWYGmZpMH23EcaHExm11UPCtvRoBCAx4LG8k5G6wbfXeKQKPcImIekvEIDQuOifshAkU3kU9Zu905Rruapgizn4cA/bCDB6fi/mRT+a7M7WAF89OQ==
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(346002)(39860400002)(136003)(451199018)(40470700004)(36840700001)(46966006)(5660300002)(6916009)(41300700001)(4326008)(8676002)(2906002)(70586007)(70206006)(316002)(54906003)(36860700001)(36756003)(426003)(478600001)(47076005)(6666004)(82310400005)(107886003)(2616005)(336012)(1076003)(8936002)(26005)(186003)(86362001)(40480700001)(356005)(40460700003)(82740400003)(83380400001)(7636003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 14:00:27.6339
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6627ae75-7f61-444b-bf64-08db084a8064
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT059.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6441
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index cd410a87517b..bf50829d9255 100644
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

