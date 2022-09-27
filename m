Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00F755EC305
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 14:41:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232258AbiI0MlG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 08:41:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232410AbiI0Mkz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 08:40:55 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9645AB6D05;
        Tue, 27 Sep 2022 05:40:44 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4McJyf325wzlW2D;
        Tue, 27 Sep 2022 20:36:26 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 27 Sep
 2022 20:40:40 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <martin.lau@linux.dev>, <song@kernel.org>, <yhs@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>, <sdf@google.com>,
        <haoluo@google.com>, <jolsa@kernel.org>, <weiyongjun1@huawei.com>,
        <yuehaibing@huawei.com>, <shaozhengchao@huawei.com>
Subject: [PATCH net-next 0/3] refactor duplicate codes in bind_class hook function
Date:   Tue, 27 Sep 2022 20:48:52 +0800
Message-ID: <20220927124855.252023-1-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All the bind_class callback duplicate the same logic, so we can refactor
them. First, ensure n arg not empty before call bind_class hook function.
Then, add tc_cls_bind_class() helper. Last, use tc_cls_bind_class() in
filter.

Zhengchao Shao (3):
  net: sched: ensure n arg not empty before call bind_class
  net: sched: cls_api: introduce tc_cls_bind_class() helper
  net: sched: use tc_cls_bind_class() in filter

 include/net/pkt_cls.h    | 12 ++++++++++++
 net/sched/cls_basic.c    |  7 +------
 net/sched/cls_bpf.c      |  7 +------
 net/sched/cls_flower.c   |  7 +------
 net/sched/cls_fw.c       |  7 +------
 net/sched/cls_matchall.c |  7 +------
 net/sched/cls_route.c    |  7 +------
 net/sched/cls_rsvp.h     |  7 +------
 net/sched/cls_tcindex.c  |  7 +------
 net/sched/cls_u32.c      |  7 +------
 net/sched/sch_api.c      |  2 +-
 11 files changed, 22 insertions(+), 55 deletions(-)

-- 
2.17.1

