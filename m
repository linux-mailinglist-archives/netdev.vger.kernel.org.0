Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C189639E716
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 21:03:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231530AbhFGTFP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 15:05:15 -0400
Received: from mail-wr1-f46.google.com ([209.85.221.46]:46034 "EHLO
        mail-wr1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230382AbhFGTFM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 15:05:12 -0400
Received: by mail-wr1-f46.google.com with SMTP id z8so18772139wrp.12;
        Mon, 07 Jun 2021 12:03:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gpCyRaWvrKvU/PVxSVlqs7O19Kt+5N+CG6yZ5xm4LxQ=;
        b=ESqJVSX7FcTzBe9BSWmDQB9qXJFW0Dg1zXZVVqFFjs55PLlB9L0BT7gI0NWT6ZFvlk
         6Ro6qYvL27SLa+9VKziPCM5pXV//xsE+N1lxokgWJWIR9U5I+P9dugtQMwR8OA4QL+5+
         5hHG215h8QDuyc0ullY15I99YkjrKDeVIn+bCpLS3kKaynE5oVfo5+GoeTZlh31ZEkQI
         2wAwp9rPAdccyB39h54ceFeB56wo7bZYPF5Bd5jyPLrEubiC4zAGU5NGntQyKQ7X2fy2
         ACHkoc0bZIHpjQh0V/dhGTBFdAJCLHtSqkBirn77Wan6fLfSSySw146P6AMR5GW2Iyjs
         VQvA==
X-Gm-Message-State: AOAM532mVd6iUH81dwCm4fv/Onhyk67RHnXKN9z3rPBPB9E0SueuHJ+n
        nk5lHNFdtYBSSOfHjMQ8Vfxp5YIDo4FBkQ==
X-Google-Smtp-Source: ABdhPJzmC4x5xCIwkqe1+nWEg0m9lr4FhVpHQo6ynPfRQVlyQhSSXDg3l8PQsFhoSNSw7Be1YbQe6A==
X-Received: by 2002:adf:f2ca:: with SMTP id d10mr18183035wrp.314.1623092599073;
        Mon, 07 Jun 2021 12:03:19 -0700 (PDT)
Received: from msft-t490s.teknoraver.net (net-37-119-128-179.cust.vodafonedsl.it. [37.119.128.179])
        by smtp.gmail.com with ESMTPSA id g17sm12185968wrp.61.2021.06.07.12.03.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Jun 2021 12:03:18 -0700 (PDT)
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
        Sven Auhagen <sven.auhagen@voleatech.de>,
        Yonghong Song <yhs@fb.com>,
        Michel Lespinasse <walken@google.com>,
        KP Singh <kpsingh@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        David Hildenbrand <david@redhat.com>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH net-next v8 1/5] mm: add a signature in struct page
Date:   Mon,  7 Jun 2021 21:02:36 +0200
Message-Id: <20210607190240.36900-2-mcroce@linux.microsoft.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210607190240.36900-1-mcroce@linux.microsoft.com>
References: <20210607190240.36900-1-mcroce@linux.microsoft.com>
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
 include/linux/mm.h       | 11 ++++++-----
 include/linux/mm_types.h |  7 +++++++
 include/linux/poison.h   |  3 +++
 net/core/page_pool.c     |  6 ++++++
 4 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index c274f75efcf9..a0434e8c2617 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1668,10 +1668,11 @@ struct address_space *page_mapping(struct page *page);
 static inline bool page_is_pfmemalloc(const struct page *page)
 {
 	/*
-	 * Page index cannot be this large so this must be
-	 * a pfmemalloc page.
+	 * lru.next has bit 1 set if the page is allocated from the
+	 * pfmemalloc reserves.  Callers may simply overwrite it if
+	 * they do not need to preserve that information.
 	 */
-	return page->index == -1UL;
+	return (uintptr_t)page->lru.next & BIT(1);
 }
 
 /*
@@ -1680,12 +1681,12 @@ static inline bool page_is_pfmemalloc(const struct page *page)
  */
 static inline void set_page_pfmemalloc(struct page *page)
 {
-	page->index = -1UL;
+	page->lru.next = (void *)BIT(1);
 }
 
 static inline void clear_page_pfmemalloc(struct page *page)
 {
-	page->index = 0;
+	page->lru.next = NULL;
 }
 
 /*
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 5aacc1c10a45..ed6862eacb52 100644
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

