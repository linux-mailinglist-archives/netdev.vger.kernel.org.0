Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81BDB5A8A60
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 03:14:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232257AbiIABN6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 21:13:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232007AbiIABN4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 21:13:56 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 806C612EC6C;
        Wed, 31 Aug 2022 18:13:55 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MJ2ys3kPhz1N7jG;
        Thu,  1 Sep 2022 09:10:13 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 1 Sep
 2022 09:13:52 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>
CC:     <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <shaozhengchao@huawei.com>
Subject: [PATCH net-next,v2] net/sched: cls_api: remove redundant 0 check in tcf_qevent_init()
Date:   Thu, 1 Sep 2022 09:16:17 +0800
Message-ID: <20220901011617.14105-1-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
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

tcf_qevent_parse_block_index() never returns a zero block_index.
Therefore, it is unnecessary to check the value of block_index in
tcf_qevent_init().

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 net/sched/cls_api.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 1ebab4b11262..5d0d57dc5cb7 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3629,9 +3629,6 @@ int tcf_qevent_init(struct tcf_qevent *qe, struct Qdisc *sch,
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

