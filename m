Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4708A5A5F36
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 11:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231703AbiH3JVZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 05:21:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231702AbiH3JVA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 05:21:00 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CE331583C;
        Tue, 30 Aug 2022 02:20:31 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MH1vQ6pgBzHnXQ;
        Tue, 30 Aug 2022 17:18:42 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Tue, 30 Aug
 2022 17:20:28 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>
CC:     <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <shaozhengchao@huawei.com>
Subject: [PATCH net-next,v3 1/2] net: sched: choke: remove unused variables in struct choke_sched_data
Date:   Tue, 30 Aug 2022 17:22:54 +0800
Message-ID: <20220830092255.281330-2-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220830092255.281330-1-shaozhengchao@huawei.com>
References: <20220830092255.281330-1-shaozhengchao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The variable "other" in the struct choke_sched_data is not used. Remove it.

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
v2: don't remove a field in UAPI
v1: qdisc_drop() already counts drops, unnecessary to use "other" to duplicate the same information.
---
 net/sched/sch_choke.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/sched/sch_choke.c b/net/sched/sch_choke.c
index 25d2daaa8122..3ac3e5c80b6f 100644
--- a/net/sched/sch_choke.c
+++ b/net/sched/sch_choke.c
@@ -60,7 +60,6 @@ struct choke_sched_data {
 		u32	forced_drop;	/* Forced drops, qavg > max_thresh */
 		u32	forced_mark;	/* Forced marks, qavg > max_thresh */
 		u32	pdrop;          /* Drops due to queue limits */
-		u32	other;          /* Drops due to drop() calls */
 		u32	matched;	/* Drops to flow match */
 	} stats;
 
@@ -464,7 +463,6 @@ static int choke_dump_stats(struct Qdisc *sch, struct gnet_dump *d)
 		.early	= q->stats.prob_drop + q->stats.forced_drop,
 		.marked	= q->stats.prob_mark + q->stats.forced_mark,
 		.pdrop	= q->stats.pdrop,
-		.other	= q->stats.other,
 		.matched = q->stats.matched,
 	};
 
-- 
2.17.1

