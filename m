Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A72938A173
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 11:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232375AbhETJbQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 05:31:16 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3602 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232367AbhETJ3T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 05:29:19 -0400
Received: from dggems702-chm.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Fm47Y4l9BzQp8l;
        Thu, 20 May 2021 17:24:25 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggems702-chm.china.huawei.com (10.3.19.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 20 May 2021 17:27:56 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 20 May 2021 17:27:56 +0800
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
        <JKosina@suse.com>, <mkubecek@suse.cz>, <bjorn@kernel.org>,
        <alobakin@pm.me>
Subject: [PATCH RFC v4 0/3] Some optimization for lockless qdisc
Date:   Thu, 20 May 2021 17:27:50 +0800
Message-ID: <1621502873-62720-1-git-send-email-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch 1: remove unnecessary seqcount operation.
Patch 2: implement TCQ_F_CAN_BYPASS.
Patch 3: remove qdisc->empty.

RFC v4: Use STATE_MISSED and STATE_DRAINING to indicate non-empty
        qdisc, and add patch 1 and 3.

Yunsheng Lin (3):
  net: sched: avoid unnecessary seqcount operation for lockless qdisc
  net: sched: implement TCQ_F_CAN_BYPASS for lockless qdisc
  net: sched: remove qdisc->empty for lockless qdisc

 include/net/sch_generic.h | 26 +++++++++++++-------------
 net/core/dev.c            | 22 ++++++++++++++++++++--
 net/sched/sch_generic.c   | 23 ++++++++++++++++-------
 3 files changed, 49 insertions(+), 22 deletions(-)

-- 
2.7.4

