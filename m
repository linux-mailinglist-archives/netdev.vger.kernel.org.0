Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74E473B7FCF
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 11:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233875AbhF3JVA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 05:21:00 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:13045 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233749AbhF3JU6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Jun 2021 05:20:58 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GFG093FxxzYrcj;
        Wed, 30 Jun 2021 17:15:21 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 30 Jun 2021 17:18:27 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 30 Jun 2021 17:18:27 +0800
From:   Yunsheng Lin <linyunsheng@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <linuxarm@openeuler.org>, <yisen.zhuang@huawei.com>,
        <salil.mehta@huawei.com>, <thomas.petazzoni@bootlin.com>,
        <mw@semihalf.com>, <linux@armlinux.org.uk>, <hawk@kernel.org>,
        <ilias.apalodimas@linaro.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <john.fastabend@gmail.com>,
        <akpm@linux-foundation.org>, <peterz@infradead.org>,
        <will@kernel.org>, <willy@infradead.org>, <vbabka@suse.cz>,
        <fenghua.yu@intel.com>, <guro@fb.com>, <peterx@redhat.com>,
        <feng.tang@intel.com>, <jgg@ziepe.ca>, <mcroce@microsoft.com>,
        <hughd@google.com>, <jonathan.lemon@gmail.com>, <alobakin@pm.me>,
        <willemb@google.com>, <wenxu@ucloud.cn>, <cong.wang@bytedance.com>,
        <haokexin@gmail.com>, <nogikh@google.com>, <elver@google.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bpf@vger.kernel.org>
Subject: [PATCH net-next RFC 0/2] add elevated refcnt support for page pool
Date:   Wed, 30 Jun 2021 17:17:54 +0800
Message-ID: <1625044676-12441-1-git-send-email-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset adds elevated refcnt support for page pool
and enable skb's page frag recycling based on page pool
in hns3 drvier.

Yunsheng Lin (2):
  page_pool: add page recycling support based on elevated refcnt
  net: hns3: support skb's frag page recycling based on page pool

 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  79 +++++++-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |   3 +
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |   1 +
 drivers/net/ethernet/marvell/mvneta.c              |   6 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |   2 +-
 include/linux/mm_types.h                           |   2 +-
 include/linux/skbuff.h                             |   4 +-
 include/net/page_pool.h                            |  30 ++-
 net/core/page_pool.c                               | 215 +++++++++++++++++----
 9 files changed, 285 insertions(+), 57 deletions(-)

-- 
2.7.4

