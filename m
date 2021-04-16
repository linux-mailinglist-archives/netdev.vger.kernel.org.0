Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35A3A361712
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 03:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237637AbhDPBNZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 21:13:25 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:17345 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235109AbhDPBNY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 21:13:24 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4FLynT11LJz9yf6;
        Fri, 16 Apr 2021 09:10:37 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.498.0; Fri, 16 Apr 2021 09:12:51 +0800
From:   Yunsheng Lin <linyunsheng@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <olteanv@gmail.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <andriin@fb.com>, <edumazet@google.com>, <weiwan@google.com>,
        <cong.wang@bytedance.com>, <ap420073@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@openeuler.org>, <mkl@pengutronix.de>,
        <linux-can@vger.kernel.org>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <andrii@kernel.org>, <kafai@fb.com>, <songliubraving@fb.com>,
        <yhs@fb.com>, <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
        <bpf@vger.kernel.org>, <jonas.bonn@netrounds.com>,
        <pabeni@redhat.com>, <mzhivich@akamai.com>, <johunt@akamai.com>,
        <albcamus@gmail.com>, <kehuan.feng@gmail.com>,
        <a.fatoum@pengutronix.de>, <atenart@kernel.org>,
        <alexander.duyck@gmail.com>, <hdanton@sina.com>, <jgross@suse.com>,
        <JKosina@suse.com>
Subject: [PATCH net v4 0/2] fix packet stuck problem for lockless qdisc
Date:   Fri, 16 Apr 2021 09:13:12 +0800
Message-ID: <1618535592-11845-1-git-send-email-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset fixes the packet stuck problem mentioned in [1].

Patch 1: Add STATE_MISSED flag to fix packet stuck problem.
Patch 2: Fix a tx_action rescheduling problem after STATE_MISSED
         flag is added in patch 1.

V4: Change STATE_NEED_RESCHEDULE to STATE_MISSED and add patch 2.

[1]. https://lkml.org/lkml/2019/10/9/42

Yunsheng Lin (2):
  net: sched: fix packet stuck problem for lockless qdisc
  net: sched: fix endless tx action reschedule during deactivation

 include/net/pkt_sched.h   |  7 +------
 include/net/sch_generic.h | 37 ++++++++++++++++++++++++++++++++++++-
 net/core/dev.c            | 26 ++++++++++++++++++++++----
 net/sched/sch_generic.c   | 16 +++++++++++++++-
 4 files changed, 74 insertions(+), 12 deletions(-)

-- 
2.7.4

