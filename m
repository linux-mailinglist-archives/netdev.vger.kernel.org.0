Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8103A37FBF3
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 18:59:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbhEMRAp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 13:00:45 -0400
Received: from mail-ej1-f51.google.com ([209.85.218.51]:40674 "EHLO
        mail-ej1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229978AbhEMRAn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 13:00:43 -0400
Received: by mail-ej1-f51.google.com with SMTP id n2so40818203ejy.7;
        Thu, 13 May 2021 09:59:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rxLHJd8XD9Hb4Rf+opd9ZLjsRH1xJ79b5KXjgff+Bjc=;
        b=KFVwvMZ6Ja8A3NeQA9rMp2l9pQuoiku0t+WMOUaxmDPPM8rpg+8HFA//6tCVS00cpx
         Ja3U4aHxXNib682L5QfkRB2ueixxIB2xbYuN1kGRYjbrvX/MNXvfe/i5iwhFa1gZ10Ya
         jc5bnAhGdKMkW/I/z01ooI9UJmMn8q+qrN4GbnDu2xWY4NFx2lpFs8/CuRAVH/m7sDDj
         w2rrW2jMZBkhlHMgcEHPjGy090Sq89UMWIdic2aBBg4267jvmWKzaWyhtsq2xntTct9o
         mmKHXX8Yj/7ojHodx/b4nGXsDBKi5DYPqEGizegRdSwHZTRZK/7/QJC25LutVSwqF3Ff
         s3Iw==
X-Gm-Message-State: AOAM533IwMBqC5rxQOp8BvULF8KJb1FWpM29m9doeOZVi3JRQ/OgpBCT
        q8cOS7bNCAW2uhswJDpt1mO1siJj2ZamtyQR
X-Google-Smtp-Source: ABdhPJzNfQFARn/zPNO4hoyHVkKONaOFliYJKvo89sBhiZsOEvjF+mAbgI9X4R5U6JV8zjP2yJmHUQ==
X-Received: by 2002:a17:906:b6c5:: with SMTP id ec5mr44910742ejb.290.1620925171875;
        Thu, 13 May 2021 09:59:31 -0700 (PDT)
Received: from msft-t490s.teknoraver.net (net-5-94-253-60.cust.vodafonedsl.it. [5.94.253.60])
        by smtp.gmail.com with ESMTPSA id w11sm2959431ede.54.2021.05.13.09.59.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 09:59:31 -0700 (PDT)
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
Subject: [PATCH net-next v5 1/5] mm: add a signature in struct page
Date:   Thu, 13 May 2021 18:58:42 +0200
Message-Id: <20210513165846.23722-2-mcroce@linux.microsoft.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210513165846.23722-1-mcroce@linux.microsoft.com>
References: <20210513165846.23722-1-mcroce@linux.microsoft.com>
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
 include/linux/mm_types.h | 12 ++++++++++++
 include/net/page_pool.h  |  2 ++
 net/core/page_pool.c     |  4 ++++
 4 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 322ec61d0da7..48268d2d0282 100644
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
+	return page->compound_head & 2;
 }
 
 /*
@@ -1680,12 +1682,12 @@ static inline bool page_is_pfmemalloc(const struct page *page)
  */
 static inline void set_page_pfmemalloc(struct page *page)
 {
-	page->index = -1UL;
+	page->compound_head = 2;
 }
 
 static inline void clear_page_pfmemalloc(struct page *page)
 {
-	page->index = 0;
+	page->compound_head = 0;
 }
 
 /*
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 5aacc1c10a45..44cf328e94e2 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -96,6 +96,18 @@ struct page {
 			unsigned long private;
 		};
 		struct {	/* page_pool used by netstack */
+			/**
+			 * @pp_magic: magic value to avoid recycling non
+			 * page_pool allocated pages.
+			 * It aliases with page->lru.next
+			 */
+			unsigned long pp_magic;
+			/**
+			 * @pp: pointer to page_pool.
+			 * It aliases with page->lru.prev
+			 */
+			struct page_pool *pp;
+			unsigned long _pp_mapping_pad;
 			/**
 			 * @dma_addr: might require a 64-bit value on
 			 * 32-bit architectures.
diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index b4b6de909c93..24b3d42c62c0 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -63,6 +63,8 @@
  */
 #define PP_ALLOC_CACHE_SIZE	128
 #define PP_ALLOC_CACHE_REFILL	64
+#define PP_SIGNATURE		(POISON_POINTER_DELTA + 0x40)
+
 struct pp_alloc_cache {
 	u32 count;
 	struct page *cache[PP_ALLOC_CACHE_SIZE];
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 3c4c4c7a0402..9de5d8c08c17 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -221,6 +221,8 @@ static struct page *__page_pool_alloc_page_order(struct page_pool *pool,
 		return NULL;
 	}
 
+	page->pp_magic = PP_SIGNATURE;
+
 	/* Track how many pages are held 'in-flight' */
 	pool->pages_state_hold_cnt++;
 	trace_page_pool_state_hold(pool, page, pool->pages_state_hold_cnt);
@@ -341,6 +343,8 @@ void page_pool_release_page(struct page_pool *pool, struct page *page)
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

