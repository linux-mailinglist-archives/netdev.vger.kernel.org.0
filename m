Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17F5E39BFAF
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 20:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230250AbhFDSgS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 14:36:18 -0400
Received: from mail-ed1-f52.google.com ([209.85.208.52]:35729 "EHLO
        mail-ed1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230210AbhFDSgR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 14:36:17 -0400
Received: by mail-ed1-f52.google.com with SMTP id ba2so10507852edb.2;
        Fri, 04 Jun 2021 11:34:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rABHcNSMbMSTtq6U4R3ZDnLi8VWhQ8MxkVRZq0z6MO8=;
        b=PvcYaii1ZDCd0CQNecWBkxD6wkVrO/E7tDfPgnaxHjdWMU8ZkwHtF2luITSm69vN6u
         ZTpVWpRvf6zuZuwUxW+ws25MJpdpFAlgEXRRHrWt63i3Tb7+Dcg7Gxls9zOncX45hRGK
         TU8EOJXRaxQGVqwCYc13UwmkyfxO3zjW5Bsc3GyM/E3mcK7KWchbY2mg9vivh2LZC86J
         SxF3bWRgXuFI0/SRF5SZ9OFS/oIFLOhthGNa+d/vrqeKeOEziGSLb0JIlX0AeLg8I08/
         /ZuGu0Hya6k1/Ajb4FVkALxeUszNBdKCY9lnXEuYbfCXDGByu7VAkbuNgBA4QnGsIB2N
         TJtA==
X-Gm-Message-State: AOAM530NcxZsgJ/I52nUXl0LTg/wp9IsSNOiMkeCcRSpm+E7VMsbf/c+
        1YZY1L1s0s3E+37oqL7n29WddQZ2CAWbgw==
X-Google-Smtp-Source: ABdhPJwVTSbX20acx+Ma5Fka4UHK7wy+7JB8YWFIUp4OQhlYxBE8dzHqI1IKFIo4RCyzrVxAOwHvkA==
X-Received: by 2002:aa7:d64f:: with SMTP id v15mr6058376edr.255.1622831660873;
        Fri, 04 Jun 2021 11:34:20 -0700 (PDT)
Received: from msft-t490s.teknoraver.net (net-37-119-128-179.cust.vodafonedsl.it. [37.119.128.179])
        by smtp.gmail.com with ESMTPSA id k12sm3732039edi.87.2021.06.04.11.34.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Jun 2021 11:34:20 -0700 (PDT)
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
Subject: [PATCH net-next v7 1/5] mm: add a signature in struct page
Date:   Fri,  4 Jun 2021 20:33:45 +0200
Message-Id: <20210604183349.30040-2-mcroce@linux.microsoft.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210604183349.30040-1-mcroce@linux.microsoft.com>
References: <20210604183349.30040-1-mcroce@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matteo Croce <mcroce@microsoft.com>

This is needed by the page_pool to avoid recycling a page not allocated
via page_pool.

The page->signature field is aliased to page->lru.next and
page->compound_head, but it can't be set by mistake because the
signature value is a bad pointer, and can't trigger a false positive
in PageTail() because the last bit is 0.

Co-developed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Matteo Croce <mcroce@microsoft.com>
---
 include/linux/mm.h       | 12 +++++++-----
 include/linux/mm_types.h | 12 +++++++++++-
 include/linux/poison.h   |  3 +++
 net/core/page_pool.c     |  6 ++++++
 4 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index c274f75efcf9..b71074a5e82b 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1668,10 +1668,12 @@ struct address_space *page_mapping(struct page *page);
 static inline bool page_is_pfmemalloc(const struct page *page)
 {
 	/*
-	 * Page index cannot be this large so this must be
-	 * a pfmemalloc page.
+	 * This is not a tail page; compound_head of a head page is unused
+	 * at return from the page allocator, and will be overwritten
+	 * by callers who do not care whether the page came from the
+	 * reserves.
 	 */
-	return page->index == -1UL;
+	return page->compound_head & BIT(1);
 }
 
 /*
@@ -1680,12 +1682,12 @@ static inline bool page_is_pfmemalloc(const struct page *page)
  */
 static inline void set_page_pfmemalloc(struct page *page)
 {
-	page->index = -1UL;
+	page->compound_head = BIT(1);
 }
 
 static inline void clear_page_pfmemalloc(struct page *page)
 {
-	page->index = 0;
+	page->compound_head = 0;
 }
 
 /*
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 5aacc1c10a45..09f90598ff63 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -96,6 +96,13 @@ struct page {
 			unsigned long private;
 		};
 		struct {	/* page_pool used by netstack */
+			/**
+			 * @pp_magic: magic value to avoid recycling non
+			 * page_pool allocated pages.
+			 */
+			unsigned long pp_magic;
+			struct page_pool *pp;
+			unsigned long _pp_mapping_pad;
 			/**
 			 * @dma_addr: might require a 64-bit value on
 			 * 32-bit architectures.
@@ -130,7 +137,10 @@ struct page {
 			};
 		};
 		struct {	/* Tail pages of compound page */
-			unsigned long compound_head;	/* Bit zero is set */
+			/* Bit zero is set
+			 * Bit one if pfmemalloc page
+			 */
+			unsigned long compound_head;
 
 			/* First tail page only */
 			unsigned char compound_dtor;
diff --git a/include/linux/poison.h b/include/linux/poison.h
index aff1c9250c82..d62ef5a6b4e9 100644
--- a/include/linux/poison.h
+++ b/include/linux/poison.h
@@ -78,4 +78,7 @@
 /********** security/ **********/
 #define KEY_DESTROY		0xbd
 
+/********** net/core/page_pool.c **********/
+#define PP_SIGNATURE		(0x40 + POISON_POINTER_DELTA)
+
 #endif
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 3c4c4c7a0402..e1321bc9d316 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -17,6 +17,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/page-flags.h>
 #include <linux/mm.h> /* for __put_page() */
+#include <linux/poison.h>
 
 #include <trace/events/page_pool.h>
 
@@ -221,6 +222,8 @@ static struct page *__page_pool_alloc_page_order(struct page_pool *pool,
 		return NULL;
 	}
 
+	page->pp_magic |= PP_SIGNATURE;
+
 	/* Track how many pages are held 'in-flight' */
 	pool->pages_state_hold_cnt++;
 	trace_page_pool_state_hold(pool, page, pool->pages_state_hold_cnt);
@@ -263,6 +266,7 @@ static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
 			put_page(page);
 			continue;
 		}
+		page->pp_magic |= PP_SIGNATURE;
 		pool->alloc.cache[pool->alloc.count++] = page;
 		/* Track how many pages are held 'in-flight' */
 		pool->pages_state_hold_cnt++;
@@ -341,6 +345,8 @@ void page_pool_release_page(struct page_pool *pool, struct page *page)
 			     DMA_ATTR_SKIP_CPU_SYNC);
 	page_pool_set_dma_addr(page, 0);
 skip_dma_unmap:
+	page->pp_magic = 0;
+
 	/* This may be the last page returned, releasing the pool, so
 	 * it is not safe to reference pool afterwards.
 	 */
-- 
2.31.1

