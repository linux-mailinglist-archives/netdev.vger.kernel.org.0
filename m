Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52E9A5A7A32
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 11:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231877AbiHaJ1Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 05:27:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231934AbiHaJ1A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 05:27:00 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7707537FAD;
        Wed, 31 Aug 2022 02:26:56 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MHdyC5Xzrz1N7H8;
        Wed, 31 Aug 2022 17:23:15 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 31 Aug
 2022 17:26:54 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <vinicius.gomes@intel.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>
CC:     <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <shaozhengchao@huawei.com>
Subject: [PATCH net-next] net: sched: etf: remove true check in etf_enable_offload()
Date:   Wed, 31 Aug 2022 17:29:19 +0800
Message-ID: <20220831092919.146149-1-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
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

etf_enable_offload() is only called when q->offload is false in
etf_init(). So remove true check in etf_enable_offload().

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 net/sched/sch_etf.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/sched/sch_etf.c b/net/sched/sch_etf.c
index d96103b0e2bf..61d1f0e32cf3 100644
--- a/net/sched/sch_etf.c
+++ b/net/sched/sch_etf.c
@@ -323,9 +323,6 @@ static int etf_enable_offload(struct net_device *dev, struct etf_sched_data *q,
 	struct tc_etf_qopt_offload etf = { };
 	int err;
 
-	if (q->offload)
-		return 0;
-
 	if (!ops->ndo_setup_tc) {
 		NL_SET_ERR_MSG(extack, "Specified device does not support ETF offload");
 		return -EOPNOTSUPP;
-- 
2.17.1

