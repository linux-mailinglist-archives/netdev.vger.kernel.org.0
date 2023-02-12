Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48D38693789
	for <lists+netdev@lfdr.de>; Sun, 12 Feb 2023 14:26:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbjBLN0J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Feb 2023 08:26:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbjBLN0G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Feb 2023 08:26:06 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2052.outbound.protection.outlook.com [40.107.94.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CD27126EE
        for <netdev@vger.kernel.org>; Sun, 12 Feb 2023 05:26:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oO+O3FfDoxmGgY9etMp6KfG3pJbBNsHL5M3LGsTFW3twiDO4iu369MdGLIOD5p5zW+FQtG64IGhIf1kcTZiw3uS+yiM3fYvy7LlE/pldIvG+zu+mzgGfY4g5YyBZ+fbMAP0ytR5HqsTGwqVCBxAfjpru6LiDCzumrNvdWYUAaBjKsI2reELNsMK8Z9YQ8QQW+JVinwM6SQ3mQatwiSp1tjvl3SoYzm3WQoha6jtmdzpgHFHO7dAtjhIIB86Enci0Wn1CysWZI/9gt3IAVcH4rEWXDzh9wq8Hq/JziymOKiUoIGtWs4FV8I4m3p1iexBcMceRo6/z1w5Fs4c7S6DfXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dnArYJSINm0ldiKEqtgZ6wzZhB1KmIgF0uMxsoBZRK4=;
 b=RF5yIqDXBvtjqBl5hXlIs0H65e4+L/CFj2PTwmSX5BSVf/Bbla8y8qAfq+AeNqYnXRUNzkHe+UdZR/L3GuX/XNq4kro3k+sQNobV/611Cgo+QIbSEHlSspsTrOM2GcQBF0vlrg1D7p7gx5GqjfP+Ia0hX7Hv422FWIkBsUcWxM7Wllm+YB/PULktmxUEH2ROZQ4M2COFNXXPNzdxgMRX+6JJ2wTYcJ33EPOqvHuFamCmBeQW57q35D7IzWS/i8iKk12X3ijTCUzKJiO6Bq1OYONuO7+rOymKeF8v8H4GEUCt90dbnXlIpHYRvvrk5Xwxd/OL3sPUMpZShVBd9Xl5qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dnArYJSINm0ldiKEqtgZ6wzZhB1KmIgF0uMxsoBZRK4=;
 b=jhx2lYCrBnG5Lk8nk1ZVZmn7ySKkKNTq+7I/yqyZuQXycaqRgZOZQaIf84I/XIIit3QvJhhOygTtfarduCVH1NhUN3TJZbCGBxJd03Q3dfGQ1UraQiI/pTlXF6JKJQENhF0aWWMAsjHrmA+egUst15LJp9mAz+mt8fSEg6sO+44iZEiUFwBUFQPaEyBrpo4D6BkTu/gCEY8mzpNBqvBz+P+QERhnpKVymt+zy8Pt/PblhDgPRv0bglNLvd8Ce+rzc/w4h+ManWgx94+BP1xxEZrR/ltdG+bqhlrwhjfbGS1NqLuhEIWfQGRaMSFmWfbVqd7oZVG5uSsurDa9/3qeLQ==
Received: from DM6PR08CA0060.namprd08.prod.outlook.com (2603:10b6:5:1e0::34)
 by SJ2PR12MB7867.namprd12.prod.outlook.com (2603:10b6:a03:4cd::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.23; Sun, 12 Feb
 2023 13:26:01 +0000
Received: from DM6NAM11FT044.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1e0:cafe::44) by DM6PR08CA0060.outlook.office365.com
 (2603:10b6:5:1e0::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.23 via Frontend
 Transport; Sun, 12 Feb 2023 13:26:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT044.mail.protection.outlook.com (10.13.173.185) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.22 via Frontend Transport; Sun, 12 Feb 2023 13:26:00 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 12 Feb
 2023 05:25:49 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 12 Feb
 2023 05:25:49 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.10) with Microsoft SMTP Server id 15.2.986.36 via
 Frontend Transport; Sun, 12 Feb 2023 05:25:45 -0800
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
Subject: [PATCH  net-next v4 3/9] net/sched: pass flow_stats instead of multiple stats args
Date:   Sun, 12 Feb 2023 15:25:14 +0200
Message-ID: <20230212132520.12571-4-ozsh@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230212132520.12571-1-ozsh@nvidia.com>
References: <20230212132520.12571-1-ozsh@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT044:EE_|SJ2PR12MB7867:EE_
X-MS-Office365-Filtering-Correlation-Id: ac7aaff8-c5ef-4d58-7d2d-08db0cfcaf04
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iAx/IpR2zhxrj8SvdqKwZePDVmKYup/ddqFacEIZNssxXXBQ1MFIFM6SlGYNvRmdHdU9lnTV0XHIJMdVMeGAZiV4Y/QQI678jKqQfdk7bJJLC2xZfkoowwRgglOSMPC5U7KzzyPv1utaXrMk5VzTeOdSxO0Iv13TMV8u+nNgj/RGv4EsQtFS1wjQ8wki93LG8j/CEdimQ8DOBA/NQis1+PUzdMxsPbPkjz0YMnGDJ/7pDwGG+0/tofGL+8JZmFIXIB6U0GTBfgcaccehztnNMk2vJeYG4a4GCbxpttLom3V3OjJ6Ir0a0gIhRxlYDvbbRebSY2OsxIgpE4vh0oKzfVjnJ2+lD1ltjqHdeiFnEr7j/WpR43ze8ZbeTP+Cava2cNAqfYu8k0nMTLtgA/SlxPtrNo6ep0diJJVbEiiATGhOTpz/rQZ1tQG0Pf9uajszfNPvQ66kSSyOejkTDZXZm62VBohsj/A/zu9aQFbHmWpJEMI27y4FHod3geOW+/U+1ywK3W89XCFlZFDhMTheA+kqJL31em3eu1c0ij+GeqvwkptmGcV+sMsqup0Uwv/tXq8YSD4URJ4w2RIy7kfCPkSoHFHSI0IJWJXI4PDS4Dpzai08AD6HjxlAXWwKKpFjy3iRgziejevIWcl27ND9Qhppxiof7DP282ZpyBuCTUuejVzDkasxEyFcmYvyeHNjnQ/T/YUA8KN8q005McsLYg==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(346002)(39860400002)(376002)(451199018)(36840700001)(46966006)(40470700004)(82310400005)(82740400003)(426003)(47076005)(7636003)(86362001)(316002)(40480700001)(54906003)(70586007)(70206006)(41300700001)(36756003)(8676002)(4326008)(6916009)(36860700001)(5660300002)(8936002)(2906002)(83380400001)(40460700003)(356005)(1076003)(6666004)(2616005)(26005)(186003)(336012)(478600001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2023 13:26:00.9093
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ac7aaff8-c5ef-4d58-7d2d-08db0cfcaf04
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT044.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7867
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
Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
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

