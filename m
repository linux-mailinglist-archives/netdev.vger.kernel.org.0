Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EEEC595761
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 12:02:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234228AbiHPKBn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 06:01:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233160AbiHPKA6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 06:00:58 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2050.outbound.protection.outlook.com [40.107.244.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EF49271A
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 02:23:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M46DUd0ka2Ebmn/y+y+ahO1/LSb0PTx6H8C71/EdQ5SfNJxmRUMgIQQTdRVVIn9BKoQk8NBfJF4g30IMorBcQA4Wkqj20BrrrtcnE586+0X+9ewsUMyp0fINgB43qLUl4/+x8VXg1bwsBUbuvyzIfBPCHIi1IOxU88M5OZA5YBh/JcLMfFU2UUMCf/JGOyaIOc8sLXZL6V22f5rdQcUrGYgQnqlPtB0y06zWprsxFBB3H4v5+kZUHhnN4z++hz7kPe2/W/CIqN8lwv9Li6SS7eGK5fW13PrWn2gU7fDFM2NZOPxGS5Yd+CSPLHPtmbTqmXx1i82hhqn6MOxG/VZT0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6/5eQiFgJjA7JjTrExvqwPLqcGOzVSTA9b6b0iScNmM=;
 b=ifxfHj2GWzz7axJfrSWjIV+Hgb3pF343m6DL8jhUEvJUOv39SXI+oL10vjLcxWL0zslruREbQ2+eyTwcf+TAdphTeyTxrPsAT/7MM1wfsTSZXkvAk9RRiFH81o7rQOl+pOjX1rXkKyEWpeebKNLvyYNQj52eNo0oQ/6Z2ku1v2aM3Y8587qS9Tfz4N77MqrJAqMNPaSt4MemlxqMZ0Q2ffJ0D8LKXsNmB4UC+nus2UkaRT7AhKbUA4vFvhhWsXrSI1NEwzueMixfjPz4nIlZi1X+MoB/1/HxyQYI7rXm2f1NnIpVFt00oL37hM0zJTmOHt8TG0K1tn5XNNAsBxjVAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=corigine.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6/5eQiFgJjA7JjTrExvqwPLqcGOzVSTA9b6b0iScNmM=;
 b=cC2+MP4mKrYq7Q7l5dycNVtoLqJEyPerWSw0m3XnMDCne+G1Ns8jk1WeCSV4HIgkKiqoBqWQ5AByBI8vmCp+4SsGvKca/TlhJU9r6w8ptCsxgU3xHWuc58WmMRr5SsgNF5k4aGoV6jLs4C++IimcGkF4mjWnWr1y/IzmBXBj5OEgIOr+4UOyO4TiZRfo2mibBk3Yi2+tcPP64tZmgU+D16IN78LCTDHezNOb3bPyvoEqIFBPbVqfm6vfnVFL0D1VygRjctHtkKE8DCaRFbLXoQC2hjd+RQfWl+S4zJ3R92m4XNxVGNVaLHksOAvYetSs6ov99cp8Ju97so+V2yFhyA==
Received: from MW2PR16CA0046.namprd16.prod.outlook.com (2603:10b6:907:1::23)
 by MWHPR1201MB0239.namprd12.prod.outlook.com (2603:10b6:301:50::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.17; Tue, 16 Aug
 2022 09:23:49 +0000
Received: from CO1NAM11FT005.eop-nam11.prod.protection.outlook.com
 (2603:10b6:907:1:cafe::4b) by MW2PR16CA0046.outlook.office365.com
 (2603:10b6:907:1::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.18 via Frontend
 Transport; Tue, 16 Aug 2022 09:23:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT005.mail.protection.outlook.com (10.13.174.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5525.11 via Frontend Transport; Tue, 16 Aug 2022 09:23:48 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Tue, 16 Aug
 2022 09:23:48 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Tue, 16 Aug
 2022 02:23:47 -0700
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.6) with Microsoft SMTP Server id 15.2.986.29 via
 Frontend Transport; Tue, 16 Aug 2022 02:23:45 -0700
From:   Oz Shlomo <ozsh@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Jiri Pirko <jiri@nvidia.com>, Jamal Hadi Salim <jhs@mojatatu.com>,
        "Simon Horman" <simon.horman@corigine.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>
Subject: [ RFC  net-next 1/3] net: sched: Pass flow_stats instead of multiple stats args
Date:   Tue, 16 Aug 2022 12:23:36 +0300
Message-ID: <20220816092338.12613-2-ozsh@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20220816092338.12613-1-ozsh@nvidia.com>
References: <20220816092338.12613-1-ozsh@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0de14785-8693-455a-22f5-08da7f6906de
X-MS-TrafficTypeDiagnostic: MWHPR1201MB0239:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eSVNv78LBVBJ+xFA+XiIuIYnaQ3u0HrHqdc8lUBnvY/QssWc7V7n7JUK8hK0uJlJp9yCDtwAd8hJkk3QIKDIB7p6dJulsmVr2ubPFORhZcZcczKpFyVH7ENvdwO4Oy3y40uxdmnZSsgWcjYSxXNF6BSNhfWaYN9ySP6xerCS0IY6dMWWgeLNpLgjPnnaLSaWzyO3oLGSTNTpzQUMV4HIrbkvYkp9WC6nEVC8bHmJlMv8p+lAGri3OmULiOafz1yplO5Yje6kOj0QVF/TeLMTt/gFunbcm5unvISjipQggoU9Zqnn/D1hjwhg6pxjo3Y6X+1VqXLXn90atF1HCjp7BD6LmJ5YjoqpZBeXLzKr9mFyBNnkAR2SEXDxVfa9LWf94JG3/vOOT6v/eZSB/9KSTc30yJDmfS3Z6NUP2m3asdGKhxzLKES1OrW+7KcDuQTiyWyNoQvJ/VkTE27hZKxXRkgHWxk/d3sug5z0HxcN3CDghsTkO8lZa/Dndz1IWUrogufe+768QJRHwQeP+CEkOMHgv9gFXzMffiX9qyxv0Ar3Irc/dfqcdrCtBkHOeulYiH/aBpBYb+zeibCd8Yu2fAtOvGYv6sLFsDYQi5VF1BDXHfsQ1jYGoKxam3xfq/Hq7IIiANcsAJXC0ZBCtjSiz5dF++Viw3TIhTF7MXCb6ul7fg+vkP0iHVWoySEBnELURHGOzIK4ZX7GiYXkGdP/MHJul7VxEuO97FxHAAoSq6KQalo+m5znAyksRnGpJo9ykvCLN5jWmau1U5qidB+8sx65plgUJ1YONQTNaIhejaVyLr/QXJqFg0jC80PkS0uVEqqqcQ+fx7YV8wlgzm0pJA==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(136003)(39860400002)(396003)(46966006)(40470700004)(36840700001)(5660300002)(82740400003)(36860700001)(82310400005)(40480700001)(2906002)(356005)(40460700003)(86362001)(336012)(81166007)(47076005)(186003)(41300700001)(83380400001)(478600001)(26005)(8676002)(426003)(4326008)(70586007)(8936002)(6666004)(107886003)(36756003)(70206006)(54906003)(6916009)(2616005)(316002)(1076003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2022 09:23:48.8611
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0de14785-8693-455a-22f5-08da7f6906de
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT005.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0239
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
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
index d9d90e6925e1..27eac9e73c61 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -269,8 +269,7 @@ static inline void tcf_exts_put_net(struct tcf_exts *exts)
 
 static inline void
 tcf_exts_hw_stats_update(const struct tcf_exts *exts,
-			 u64 bytes, u64 packets, u64 drops, u64 lastuse,
-			 u8 used_hw_stats, bool used_hw_stats_valid)
+			 struct flow_stats *stats)
 {
 #ifdef CONFIG_NET_CLS_ACT
 	int i;
@@ -281,12 +280,12 @@ static inline void tcf_exts_put_net(struct tcf_exts *exts)
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
index 041d63ff809a..7da3337c4356 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -499,12 +499,7 @@ static void fl_hw_update_stats(struct tcf_proto *tp, struct cls_fl_filter *f,
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
index 06cf22adbab7..b5520a9c35e6 100644
--- a/net/sched/cls_matchall.c
+++ b/net/sched/cls_matchall.c
@@ -332,11 +332,7 @@ static void mall_stats_hw_filter(struct tcf_proto *tp,
 
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

