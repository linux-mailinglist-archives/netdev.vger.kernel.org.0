Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08C8460244B
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 08:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbiJRGYJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 02:24:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbiJRGYI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 02:24:08 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCEB38A7D1
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 23:24:07 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Ms3bv3lBrzmV7X;
        Tue, 18 Oct 2022 14:19:23 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 18 Oct
 2022 14:24:05 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <cake@lists.bufferbloat.net>, <netdev@vger.kernel.org>,
        <toke@toke.dk>, <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>,
        <jiri@resnulli.us>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <dave.taht@gmail.com>, <weiyongjun1@huawei.com>,
        <yuehaibing@huawei.com>, <shaozhengchao@huawei.com>
Subject: [PATCH net,v2 0/3] fix null pointer access issue in qdisc
Date:   Tue, 18 Oct 2022 14:31:58 +0800
Message-ID: <20221018063201.306474-1-shaozhengchao@huawei.com>
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

These three patches fix the same type of problem. Set the default qdisc,
and then construct an init failure scenario when the dev qdisc is
configured on mqprio to trigger the reset process. NULL pointer access
may occur during the reset process.

---
v2: for fq_codel, revert the patch
---

Zhengchao Shao (3):
  net: sched: cake: fix null pointer access issue when cake_init() fails
  Revert "net: sched: fq_codel: remove redundant resource cleanup in
    fq_codel_init()"
  net: sched: sfb: fix null pointer access issue when sfb_init() fails

 net/sched/sch_cake.c     |  4 ++++
 net/sched/sch_fq_codel.c | 25 +++++++++++++++++--------
 net/sched/sch_sfb.c      |  3 ++-
 3 files changed, 23 insertions(+), 9 deletions(-)

-- 
2.17.1

