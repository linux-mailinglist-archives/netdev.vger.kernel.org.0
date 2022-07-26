Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE375809C0
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 05:04:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237400AbiGZDEI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 23:04:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236795AbiGZDEH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 23:04:07 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6208A240AA;
        Mon, 25 Jul 2022 20:04:06 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4LsM8q4Tr4zWf95;
        Tue, 26 Jul 2022 11:00:11 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Tue, 26 Jul
 2022 11:03:47 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <shaozhengchao@huawei.com>
Subject: [PATCH net-next] net/sched: sch_cbq: change the type of cbq_set_lss to void
Date:   Tue, 26 Jul 2022 11:07:48 +0800
Message-ID: <20220726030748.243505-1-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change the type of cbq_set_lss to void.

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 net/sched/sch_cbq.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/sched/sch_cbq.c b/net/sched/sch_cbq.c
index 599e26fc2fa8..91a0dc463c48 100644
--- a/net/sched/sch_cbq.c
+++ b/net/sched/sch_cbq.c
@@ -979,7 +979,7 @@ cbq_reset(struct Qdisc *sch)
 }
 
 
-static int cbq_set_lss(struct cbq_class *cl, struct tc_cbq_lssopt *lss)
+static void cbq_set_lss(struct cbq_class *cl, struct tc_cbq_lssopt *lss)
 {
 	if (lss->change & TCF_CBQ_LSS_FLAGS) {
 		cl->share = (lss->flags & TCF_CBQ_LSS_ISOLATED) ? NULL : cl->tparent;
@@ -997,7 +997,6 @@ static int cbq_set_lss(struct cbq_class *cl, struct tc_cbq_lssopt *lss)
 	}
 	if (lss->change & TCF_CBQ_LSS_OFFTIME)
 		cl->offtime = lss->offtime;
-	return 0;
 }
 
 static void cbq_rmprio(struct cbq_sched_data *q, struct cbq_class *cl)
-- 
2.17.1

