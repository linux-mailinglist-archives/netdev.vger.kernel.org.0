Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 591C440AD2C
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 14:12:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232554AbhINMN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 08:13:59 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:19974 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232199AbhINMN6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 08:13:58 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4H82Dy0k1gzbmN9;
        Tue, 14 Sep 2021 20:08:34 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Tue, 14 Sep 2021 20:12:39 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Tue, 14 Sep 2021 20:12:38 +0800
From:   Yunsheng Lin <linyunsheng@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@openeuler.org>, <hawk@kernel.org>,
        <ilias.apalodimas@linaro.org>, <jonathan.lemon@gmail.com>,
        <alobakin@pm.me>, <willemb@google.com>, <cong.wang@bytedance.com>,
        <pabeni@redhat.com>, <haokexin@gmail.com>, <nogikh@google.com>,
        <elver@google.com>, <memxor@gmail.com>, <edumazet@google.com>,
        <alexander.duyck@gmail.com>, <dsahern@gmail.com>
Subject: [PATCH net-next v2 0/3] some optimization for page pool
Date:   Tue, 14 Sep 2021 20:11:11 +0800
Message-ID: <20210914121114.28559-1-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch 1: support non-split page when PP_FLAG_PAGE_FRAG is set.
patch 2: avoid calling compound_head() for skb frag page
Patch 3: keep track of pp page when __skb_frag_ref() is called.

V2: add patch 2, adjust the commit log accroding to the discussion
    in V1, and fix a compiler error reported by kernel test robot.

Yunsheng Lin (3):
  page_pool: support non-split page with PP_FLAG_PAGE_FRAG
  pool_pool: avoid calling compound_head() for skb frag page
  skbuff: keep track of pp page when __skb_frag_ref() is called

 include/linux/skbuff.h  | 40 ++++++++++++++++++++++++++++++++++++----
 include/net/page_pool.h | 34 +++++++++++++++++++++++++++++++++-
 net/core/page_pool.c    | 30 +++++++++---------------------
 3 files changed, 78 insertions(+), 26 deletions(-)

-- 
2.33.0

