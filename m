Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FBAC5A1FA2
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 06:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230308AbiHZEIE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 00:08:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236697AbiHZEIC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 00:08:02 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6833FC6FC7;
        Thu, 25 Aug 2022 21:07:59 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MDR5j4bKhzYcp9;
        Fri, 26 Aug 2022 12:03:37 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Fri, 26 Aug
 2022 12:07:56 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>
CC:     <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <shaozhengchao@huawei.com>
Subject: [PATCH net-next] net: sched: using TCQ_MIN_PRIO_BANDS in prio_tune()
Date:   Fri, 26 Aug 2022 12:10:35 +0800
Message-ID: <20220826041035.80129-1-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
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

Using TCQ_MIN_PRIO_BANDS instead of magic number in prio_tune().

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 net/sched/sch_prio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_prio.c b/net/sched/sch_prio.c
index 3b8d7197c06b..fbbd4f7015be 100644
--- a/net/sched/sch_prio.c
+++ b/net/sched/sch_prio.c
@@ -187,7 +187,7 @@ static int prio_tune(struct Qdisc *sch, struct nlattr *opt,
 		return -EINVAL;
 	qopt = nla_data(opt);
 
-	if (qopt->bands > TCQ_PRIO_BANDS || qopt->bands < 2)
+	if (qopt->bands > TCQ_PRIO_BANDS || qopt->bands < TCQ_MIN_PRIO_BANDS)
 		return -EINVAL;
 
 	for (i = 0; i <= TC_PRIO_MAX; i++) {
-- 
2.17.1

