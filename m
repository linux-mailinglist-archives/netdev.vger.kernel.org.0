Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE4859294B
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 08:07:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232611AbiHOGHX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 02:07:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230350AbiHOGHW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 02:07:22 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CBF318358;
        Sun, 14 Aug 2022 23:07:20 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4M5kHh0DFRz1M8wc;
        Mon, 15 Aug 2022 14:04:00 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Mon, 15 Aug
 2022 14:07:17 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <shaozhengchao@huawei.com>
Subject: [PATCH net-next] net: sched: delete unused input parameter in qdisc_create
Date:   Mon, 15 Aug 2022 14:10:23 +0800
Message-ID: <20220815061023.51318-1-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
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

The input parameter p is unused in qdisc_create. Delete it.

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 net/sched/sch_api.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index fe596bf3cb99..8abb85c51e45 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -1164,7 +1164,7 @@ static int qdisc_block_indexes_set(struct Qdisc *sch, struct nlattr **tca,
 
 static struct Qdisc *qdisc_create(struct net_device *dev,
 				  struct netdev_queue *dev_queue,
-				  struct Qdisc *p, u32 parent, u32 handle,
+				  u32 parent, u32 handle,
 				  struct nlattr **tca, int *errp,
 				  struct netlink_ext_ack *extack)
 {
@@ -1634,7 +1634,7 @@ static int tc_modify_qdisc(struct sk_buff *skb, struct nlmsghdr *n,
 	}
 	if (clid == TC_H_INGRESS) {
 		if (dev_ingress_queue(dev)) {
-			q = qdisc_create(dev, dev_ingress_queue(dev), p,
+			q = qdisc_create(dev, dev_ingress_queue(dev),
 					 tcm->tcm_parent, tcm->tcm_parent,
 					 tca, &err, extack);
 		} else {
@@ -1651,7 +1651,7 @@ static int tc_modify_qdisc(struct sk_buff *skb, struct nlmsghdr *n,
 		else
 			dev_queue = netdev_get_tx_queue(dev, 0);
 
-		q = qdisc_create(dev, dev_queue, p,
+		q = qdisc_create(dev, dev_queue,
 				 tcm->tcm_parent, tcm->tcm_handle,
 				 tca, &err, extack);
 	}
-- 
2.17.1

