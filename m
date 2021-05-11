Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BB2337A7A9
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 15:32:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231591AbhEKNdu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 09:33:50 -0400
Received: from mail-ed1-f41.google.com ([209.85.208.41]:35479 "EHLO
        mail-ed1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231329AbhEKNdX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 09:33:23 -0400
Received: by mail-ed1-f41.google.com with SMTP id di13so22888235edb.2;
        Tue, 11 May 2021 06:32:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SA9lohQYxhGLdlQ+KBA3mdh85O1OGBRy/S/batCNgmQ=;
        b=KJcqAO5oBfJEuoFhE/CiYlX3wsNkD8PMHS8C5SxAzHontQWvBQpUeHrfDxgTMSbbDM
         CIyujnobiqMCxfzKswtmpfAnkCkYEqgg1PPOSXKqbuIwpd4NPqEeb0nebvHJfnjK/+5I
         0Q07xqhaDjSrFfyJ0NYkImpSyidicEGTqK6CKwTDsk790+4+0n8aUxO5XngvqXx44Z43
         4q6C9V7Gnx9F990ywijqq4w+fVqXEDlmh3fHABEgUSrZvzQGh3wGxpecXyRXaOhvKWip
         Qi2UwW8cMFQVko1RytikUaOwQRNDhzK4OPqwbt3YGb6F4NYoNp9ul95+lkelR3n/Wvhd
         B63A==
X-Gm-Message-State: AOAM530+dVFCJp2IXta1Bw0ZnkpV3Z8r4vxUR8zcxM581Rh9Li4Qwxez
        bbl4+2cj0wq++V1IDxtW2GL97asKBqOJLgdC
X-Google-Smtp-Source: ABdhPJxx3fKxANo5sv/PCWfn142ozELfU67r+XZZvcGfUaXMNo9pyYtX4mXtzM+4roaGwdm2L6cSpw==
X-Received: by 2002:a05:6402:8d3:: with SMTP id d19mr36146321edz.302.1620739932378;
        Tue, 11 May 2021 06:32:12 -0700 (PDT)
Received: from msft-t490s.teknoraver.net (net-5-94-253-60.cust.vodafonedsl.it. [5.94.253.60])
        by smtp.gmail.com with ESMTPSA id b12sm14577136eds.23.2021.05.11.06.32.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 06:32:11 -0700 (PDT)
From:   Matteo Croce <mcroce@linux.microsoft.com>
To:     netdev@vger.kernel.org, linux-mm@kvack.org
Cc:     Ayush Sawal <ayush.sawal@chelsio.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>, Yu Zhao <yuzhao@google.com>,
        Will Deacon <will@kernel.org>,
        Michel Lespinasse <walken@google.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Roman Gushchin <guro@fb.com>, Hugh Dickins <hughd@google.com>,
        Peter Xu <peterx@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Cong Wang <cong.wang@bytedance.com>, wenxu <wenxu@ucloud.cn>,
        Kevin Hao <haokexin@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Marco Elver <elver@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Guillaume Nault <gnault@redhat.com>,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        bpf@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>, Paolo Abeni <pabeni@redhat.com>,
        Sven Auhagen <sven.auhagen@voleatech.de>
Subject: [PATCH net-next v4 1/4] mm: add a signature in struct page
Date:   Tue, 11 May 2021 15:31:15 +0200
Message-Id: <20210511133118.15012-2-mcroce@linux.microsoft.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210511133118.15012-1-mcroce@linux.microsoft.com>
References: <20210511133118.15012-1-mcroce@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matteo Croce <mcroce@microsoft.com>

This is needed by the page_pool to avoid recycling a page not allocated
via page_pool.

Signed-off-by: Matteo Croce <mcroce@microsoft.com>
---
 include/linux/mm_types.h | 1 +
 include/net/page_pool.h  | 2 ++
 net/core/page_pool.c     | 4 ++++
 3 files changed, 7 insertions(+)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 5aacc1c10a45..77c04210e474 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -101,6 +101,7 @@ struct page {
 			 * 32-bit architectures.
 			 */
 			unsigned long dma_addr[2];
+			unsigned long signature;
 		};
 		struct {	/* slab, slob and slub */
 			union {
diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index b4b6de909c93..9814e36becc1 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -63,6 +63,8 @@
  */
 #define PP_ALLOC_CACHE_SIZE	128
 #define PP_ALLOC_CACHE_REFILL	64
+#define PP_SIGNATURE		0x20210303
+
 struct pp_alloc_cache {
 	u32 count;
 	struct page *cache[PP_ALLOC_CACHE_SIZE];
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 3c4c4c7a0402..2e5e2b8c3a02 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -221,6 +221,8 @@ static struct page *__page_pool_alloc_page_order(struct page_pool *pool,
 		return NULL;
 	}
 
+	page->signature = PP_SIGNATURE;
+
 	/* Track how many pages are held 'in-flight' */
 	pool->pages_state_hold_cnt++;
 	trace_page_pool_state_hold(pool, page, pool->pages_state_hold_cnt);
@@ -341,6 +343,8 @@ void page_pool_release_page(struct page_pool *pool, struct page *page)
 			     DMA_ATTR_SKIP_CPU_SYNC);
 	page_pool_set_dma_addr(page, 0);
 skip_dma_unmap:
+	page->signature = 0;
+
 	/* This may be the last page returned, releasing the pool, so
 	 * it is not safe to reference pool afterwards.
 	 */
-- 
2.31.1

