Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5409D5A439D
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 09:15:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbiH2HPK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 03:15:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiH2HPH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 03:15:07 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5576918B35;
        Mon, 29 Aug 2022 00:15:00 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MGM952bKSzGptd;
        Mon, 29 Aug 2022 15:13:13 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Mon, 29 Aug
 2022 15:14:57 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>
CC:     <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <shaozhengchao@huawei.com>
Subject: [PATCH net-next] net/sched: cls_api: remove redundant 0 check in tcf_qevent_init()
Date:   Mon, 29 Aug 2022 15:17:20 +0800
Message-ID: <20220829071720.211589-1-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
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

tcf_qevent_parse_block_index() has been checked the value of block_index.
Therefore, it is unnecessary to check the value of block_index in
tcf_qevent_init().

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 net/sched/cls_api.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 790d6809be81..72f5fd6e8e2d 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3639,9 +3639,6 @@ int tcf_qevent_init(struct tcf_qevent *qe, struct Qdisc *sch,
 	if (err)
 		return err;
 
-	if (!block_index)
-		return 0;
-
 	qe->info.binder_type = binder_type;
 	qe->info.chain_head_change = tcf_chain_head_change_dflt;
 	qe->info.chain_head_change_priv = &qe->filter_chain;
-- 
2.17.1

