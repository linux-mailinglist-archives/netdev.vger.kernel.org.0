Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C059618E22
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 03:18:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231292AbiKDCSE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 22:18:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231144AbiKDCSD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 22:18:03 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20FE620F
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 19:18:02 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4N3PN85wjMzJnSx;
        Fri,  4 Nov 2022 10:15:04 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 4 Nov
 2022 10:18:00 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <shaozhengchao@huawei.com>
Subject: [PATCH net-next] net: remove redundant check in ip_metrics_convert()
Date:   Fri, 4 Nov 2022 10:25:13 +0800
Message-ID: <20221104022513.168868-1-shaozhengchao@huawei.com>
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

Now ip_metrics_convert() is only called by ip_fib_metrics_init(). Before
ip_fib_metrics_init() invokes ip_metrics_convert(), it checks whether
input parameter fc_mx is NULL. Therefore, ip_metrics_convert() doesn't
need to check fc_mx.

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 net/ipv4/metrics.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/ipv4/metrics.c b/net/ipv4/metrics.c
index 25ea6ac44db9..7fcfdfd8f9de 100644
--- a/net/ipv4/metrics.c
+++ b/net/ipv4/metrics.c
@@ -14,9 +14,6 @@ static int ip_metrics_convert(struct net *net, struct nlattr *fc_mx,
 	struct nlattr *nla;
 	int remaining;
 
-	if (!fc_mx)
-		return 0;
-
 	nla_for_each_attr(nla, fc_mx, fc_mx_len, remaining) {
 		int type = nla_type(nla);
 		u32 val;
-- 
2.17.1

