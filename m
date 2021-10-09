Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B10E42787F
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 11:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244500AbhJIJlM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 05:41:12 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:23359 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231801AbhJIJlF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Oct 2021 05:41:05 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HRKds49zHzRgMb;
        Sat,  9 Oct 2021 17:34:41 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Sat, 9 Oct 2021 17:39:06 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Sat, 9 Oct 2021 17:39:06 +0800
From:   Yunsheng Lin <linyunsheng@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@openeuler.org>, <akpm@linux-foundation.org>,
        <hawk@kernel.org>, <ilias.apalodimas@linaro.org>,
        <peterz@infradead.org>, <yuzhao@google.com>, <jhubbard@nvidia.com>,
        <will@kernel.org>, <willy@infradead.org>, <jgg@ziepe.ca>,
        <mcroce@microsoft.com>, <willemb@google.com>,
        <cong.wang@bytedance.com>, <pabeni@redhat.com>,
        <haokexin@gmail.com>, <nogikh@google.com>, <elver@google.com>,
        <memxor@gmail.com>, <vvs@virtuozzo.com>, <linux-mm@kvack.org>,
        <edumazet@google.com>, <alexander.duyck@gmail.com>,
        <dsahern@gmail.com>
Subject: [PATCH net-next -v5 2/4] page_pool: change BIAS_MAX to support incrementing
Date:   Sat, 9 Oct 2021 17:37:22 +0800
Message-ID: <20211009093724.10539-3-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211009093724.10539-1-linyunsheng@huawei.com>
References: <20211009093724.10539-1-linyunsheng@huawei.com>
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

As the page->pp_frag_count need incrementing for pp page
frag tracking support, so change BIAS_MAX to (LONG_MAX / 2)
to avoid overflowing.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
---
 net/core/page_pool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 9b60e4301a44..2c643b72ce16 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -24,7 +24,7 @@
 #define DEFER_TIME (msecs_to_jiffies(1000))
 #define DEFER_WARN_INTERVAL (60 * HZ)
 
-#define BIAS_MAX	LONG_MAX
+#define BIAS_MAX	(LONG_MAX / 2)
 
 static int page_pool_init(struct page_pool *pool,
 			  const struct page_pool_params *params)
-- 
2.33.0

