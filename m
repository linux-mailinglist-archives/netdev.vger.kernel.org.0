Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 573E2686B42
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 17:12:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232954AbjBAQMI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 11:12:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232394AbjBAQMH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 11:12:07 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37F577640E
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 08:12:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fU3J1NTgBA85m3al876Zbx6vbu1PZM9ZuD6QTobGWuiBl5k3kupsNkUmiN7Pcdk5XrSVPYNUF3rfnm2P7c6bQS3jsy7utKajSwCnt7kUsrEcR/gecwHbOUi4iUYU1WGyHfe+wQkLQ05rKDJMkymToVfb4uVjioDjDUsWU5VfwhYpyK0/ZKINqMNxZFNqX5EukBv9tof16yS1fOrpdq779GY6ktIeFwAfJgY3Dy1DDxDJ8Rm/GNUO7y9IHqNZVO2Qsoh0GoFInhYcci6ZgG2uINFpr2rrrcJ6cPMOyBEkBZZpB2iVnvsNEuXcYuWf3EaUBW3he9cA0WomZIyVUbXs/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TG3Hfud968Ty635JdlT0H/qdo83zAV3Ssy7S9jtC/Wc=;
 b=GqLu0N5rnljyj9XKckM7KimWzvylKK7cydUc2DdJVbwLBYj68sBDzKUgtjxH5w3umLjQ/fk07wHrpg68IG1Lny6K7sd1b6yOts2EPWh378z3T3Yb2wB+iLx5SGx2ZCIBrGjOyn6Vk4vPTOfuZmEf9/xyETP/IaFeH8OwA5tr+wrNxHnBoRYgkPEwQBLYlCAbcQFlYBTH63RFKSsGOHCcXLdZt9gNaI6Sd8NqLprt4XVloKsNV89DW3eDhX8Ju6cIUnoZA7YRjA0r7rv7V/b6K5v1eQ0m6jaJSLtcNAdFsgPhnAPkB1pBKxV06FK2ufQpxlBOdurJTTDoKKwHlyzaDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TG3Hfud968Ty635JdlT0H/qdo83zAV3Ssy7S9jtC/Wc=;
 b=OiK9SGQQVAXpeygDxLtILln+1jVrCGyD2KqQGVBRk0n1t3Fd1IMEgxdXIvOjaM1WrW8glyU8mj3GVFmmdeJ87om46SRFltwEvXyXzv0dymmQQmGFqS2YGh1uofXks03vt2iDKvoI01Ozsi2YiVLUPxvPGY16di0alOQLvbJ1EHteMfZRyoU9OcjqjulSBTEJWx09Cgfsv4nZMSjjpQYrbfK9h7vL7oPhm2qwI7qKK5arHqrf4tRxm2AB45RegWFaxL18Bkn2IZhz4Xrb+3fkSF4IwiWk4Mgz8m7y/0DJlLY2OcJjrgbsYW+hfTR21fXCQjJlDK5EigSgFQE7UhrIiw==
Received: from BN0PR08CA0030.namprd08.prod.outlook.com (2603:10b6:408:142::9)
 by PH7PR12MB6396.namprd12.prod.outlook.com (2603:10b6:510:1fc::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Wed, 1 Feb
 2023 16:12:04 +0000
Received: from BN8NAM11FT075.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:142:cafe::99) by BN0PR08CA0030.outlook.office365.com
 (2603:10b6:408:142::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.23 via Frontend
 Transport; Wed, 1 Feb 2023 16:12:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT075.mail.protection.outlook.com (10.13.176.208) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.25 via Frontend Transport; Wed, 1 Feb 2023 16:12:03 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 1 Feb 2023
 08:11:52 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 1 Feb 2023
 08:11:52 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.6) with Microsoft SMTP Server id 15.2.986.36 via
 Frontend Transport; Wed, 1 Feb 2023 08:11:49 -0800
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
Subject: [PATCH  net-next 3/9] net/sched: pass flow_stats instead of multiple stats args
Date:   Wed, 1 Feb 2023 18:10:32 +0200
Message-ID: <20230201161039.20714-4-ozsh@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230201161039.20714-1-ozsh@nvidia.com>
References: <20230201161039.20714-1-ozsh@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT075:EE_|PH7PR12MB6396:EE_
X-MS-Office365-Filtering-Correlation-Id: b3e56401-debd-4f4a-fe81-08db046f0ed6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oGk8DrlM5LxSJM4G9aGske0BNuTZokqlYorzhQ6x7vz44x0km0vNbtIVQHX+CJi2+/w4yYL/Sxue+wHEq5i7CushOIlTz9EIm+gcfqWH3EfVqK1SnByc4EjBvKLcB30z6jmI4lSeAA8Jy0SFZ8/XovWgpBZSpf8QYuxoJgw7YSbUfm6FQ13RoAX1yJ65odaWRh7hsXqoXlgXwWAKsdGWREZhXM4IyD57Cigc/97rDVa5weU/BT07JZLqONDWfq8TMNzhfWM1VxrXlfPiGdl4DVXlnBblCwxFlI3Hwsn7U5JqdyFerMWK8Tpd6abNWZ1HAHyVTBHNXmKNYNdKOZmF1GeEGtwb4aJElC2xyNDsEEh+JLcyLWkFeywYX7x633FohwFuRyYBpY6ZO07/BmWC4tWtMFk/51qPnDFRsuqOnjTzMlBOuUydUOMaY7iFTft1bi2NTwotJSWv6DL3jUgg5GdUFFCRj5w/AOjLVf/fzP8V9IEMUUqlie1LN/ULtpf176qkIOx0KgbcrlSKhUEHmtrZsWTKVjnLxC7Zs2hvuhe+HlypB2tzpE1++DfXsu8oaKIIjKEZX0hlwJfnK50Rk0HZ3PFUKT6SaknJ0UMOl/TL7Y83340QrZCpBcZfMzl7u5qzbtGZFoG8n0wYQUoFAMHWTjtqKoWoD7iamsXtaUs2hUnfckNl1YQbrhX4XPgrI7FWBN0F5zzLLn8NQpepNQ==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(136003)(396003)(39860400002)(451199018)(46966006)(36840700001)(40470700004)(83380400001)(82310400005)(36756003)(186003)(26005)(54906003)(336012)(426003)(316002)(47076005)(2906002)(82740400003)(8676002)(7636003)(107886003)(70586007)(478600001)(86362001)(6666004)(4326008)(40460700003)(2616005)(1076003)(8936002)(36860700001)(70206006)(41300700001)(5660300002)(40480700001)(356005)(6916009);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2023 16:12:03.7877
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b3e56401-debd-4f4a-fe81-08db046f0ed6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT075.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6396
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

