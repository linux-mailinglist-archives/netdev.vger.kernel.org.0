Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D6885A3487
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 06:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232315AbiH0EdR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Aug 2022 00:33:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiH0EdQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Aug 2022 00:33:16 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C809AB0B11;
        Fri, 26 Aug 2022 21:33:12 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MF3dF0BnBzkWKS;
        Sat, 27 Aug 2022 12:29:37 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Sat, 27 Aug
 2022 12:33:10 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>
CC:     <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <shaozhengchao@huawei.com>
Subject: [PATCH net-next] net: sched: red: remove unused input parameter in red_get_flags()
Date:   Sat, 27 Aug 2022 12:35:45 +0800
Message-ID: <20220827043545.248535-1-shaozhengchao@huawei.com>
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

The input parameter supported_mask is unused in red_get_flags().
Remove it.

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 include/net/red.h   | 1 -
 net/sched/sch_red.c | 4 ++--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/net/red.h b/include/net/red.h
index dad41eff8c62..4aed3b2d9725 100644
--- a/include/net/red.h
+++ b/include/net/red.h
@@ -192,7 +192,6 @@ static inline bool red_check_params(u32 qth_min, u32 qth_max, u8 Wlog,
 static inline int red_get_flags(unsigned char qopt_flags,
 				unsigned char historic_mask,
 				struct nlattr *flags_attr,
-				unsigned char supported_mask,
 				struct nla_bitfield32 *p_flags,
 				unsigned char *p_userbits,
 				struct netlink_ext_ack *extack)
diff --git a/net/sched/sch_red.c b/net/sched/sch_red.c
index cae3b80e4d9d..346c6c41ce56 100644
--- a/net/sched/sch_red.c
+++ b/net/sched/sch_red.c
@@ -258,8 +258,8 @@ static int __red_change(struct Qdisc *sch, struct nlattr **tb,
 		return -EINVAL;
 
 	err = red_get_flags(ctl->flags, TC_RED_HISTORIC_FLAGS,
-			    tb[TCA_RED_FLAGS], TC_RED_SUPPORTED_FLAGS,
-			    &flags_bf, &userbits, extack);
+			    tb[TCA_RED_FLAGS], &flags_bf, &userbits,
+			    extack);
 	if (err)
 		return err;
 
-- 
2.17.1

