Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 210AC37FBFE
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 19:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230327AbhEMRBT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 13:01:19 -0400
Received: from mail-ej1-f53.google.com ([209.85.218.53]:38804 "EHLO
        mail-ej1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230181AbhEMRBH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 13:01:07 -0400
Received: by mail-ej1-f53.google.com with SMTP id b25so40762631eju.5;
        Thu, 13 May 2021 09:59:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RPSD4rOiIyDkht9dP550Ooc8Tm65GKpSWccVLOdF3gM=;
        b=QJuoC3i6YjeUKQkRU5kJr+wXHcgO+ZVTatAwf/Qp8QUUiS+b+8dSulH6vFKVCre8Nv
         VQQDB4EM5I5aRe4KvyylEtlOu2Tqd8hwD1YjMXK1palq2VJGV1Nnxs+GxlfYBiAPF1Jj
         R153geiLxE5O+jUNKColwIpaUz4IkMGEMv6ybZ0vYsKxJBWGxABP1q9jnu0hIWsMYAy5
         hF01lDIhWtQDu6CgAlFGU2yVs4GQpPtoPiGuUzrHF5/EGkJ/UZ+FjZSHlQYO6rRuweIO
         PqUcGAECsjOqiVLvXjxpOuF5gUXpgUbbl4ugCcJvVajEOfmvhqOjiVuS5WLqKMOpBt7v
         gvHw==
X-Gm-Message-State: AOAM533da4lcSM36GO/CF21Js2xwamVHVFOqjib5fMoofho5ON5XzRbe
        nZP4K1dueWdZ1dIJZNp8S5+72eeLAyEYRygf
X-Google-Smtp-Source: ABdhPJxPZCw2XIJAUpflxEPjc17/7uk7FOVIVX32n26xoKnr/ktO77VFQ9fqBHaaR6utmNEDAbN2+Q==
X-Received: by 2002:a17:906:57c3:: with SMTP id u3mr45648755ejr.162.1620925195918;
        Thu, 13 May 2021 09:59:55 -0700 (PDT)
Received: from msft-t490s.teknoraver.net (net-5-94-253-60.cust.vodafonedsl.it. [5.94.253.60])
        by smtp.gmail.com with ESMTPSA id w11sm2959431ede.54.2021.05.13.09.59.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 09:59:55 -0700 (PDT)
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
Subject: [PATCH net-next v5 3/5] page_pool: Allow drivers to hint on SKB recycling
Date:   Thu, 13 May 2021 18:58:44 +0200
Message-Id: <20210513165846.23722-4-mcroce@linux.microsoft.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210513165846.23722-1-mcroce@linux.microsoft.com>
References: <20210513165846.23722-1-mcroce@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ilias Apalodimas <ilias.apalodimas@linaro.org>

Up to now several high speed NICs have custom mechanisms of recycling
the allocated memory they use for their payloads.
Our page_pool API already has recycling capabilities that are always
used when we are running in 'XDP mode'. So let's tweak the API and the
kernel network stack slightly and allow the recycling to happen even
during the standard operation.
The API doesn't take into account 'split page' policies used by those
drivers currently, but can be extended once we have users for that.

The idea is to be able to intercept the packet on skb_release_data().
If it's a buffer coming from our page_pool API recycle it back to the
pool for further usage or just release the packet entirely.

To achieve that we introduce a bit in struct sk_buff (pp_recycle:1) and
a field in struct page (page->pp) to store the page_pool pointer.
Storing the information in page->pp allows us to recycle both SKBs and
their fragments.
The SKB bit is needed for a couple of reasons. First of all in an effort
to affect the free path as less as possible, reading a single bit,
is better that trying to derive identical information for the page stored
data. We do have a special mark in the page, that won't allow this to
happen, but again deciding without having to read the entire page is
preferable.

The driver has to take care of the sync operations on it's own
during the buffer recycling since the buffer is, after opting-in to the
recycling, never unmapped.

Since the gain on the drivers depends on the architecture, we are not
enabling recycling by default if the page_pool API is used on a driver.
In order to enable recycling the driver must call skb_mark_for_recycle()
to store the information we need for recycling in page->pp and
enabling the recycling bit, or page_pool_store_mem_info() for a fragment.

Co-developed-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Co-developed-by: Matteo Croce <mcroce@microsoft.com>
Signed-off-by: Matteo Croce <mcroce@microsoft.com>
Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
---
 include/linux/skbuff.h  | 28 +++++++++++++++++++++++++---
 include/net/page_pool.h |  9 +++++++++
 net/core/page_pool.c    | 23 +++++++++++++++++++++++
 net/core/skbuff.c       | 25 +++++++++++++++++++++----
 4 files changed, 78 insertions(+), 7 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 7fcfea7e7b21..057b40ad29bd 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -40,6 +40,9 @@
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
 #include <linux/netfilter/nf_conntrack_common.h>
 #endif
+#ifdef CONFIG_PAGE_POOL
+#include <net/page_pool.h>
+#endif
 
 /* The interface for checksum offload between the stack and networking drivers
  * is as follows...
@@ -667,6 +670,8 @@ typedef unsigned char *sk_buff_data_t;
  *	@head_frag: skb was allocated from page fragments,
  *		not allocated by kmalloc() or vmalloc().
  *	@pfmemalloc: skbuff was allocated from PFMEMALLOC reserves
+ *	@pp_recycle: mark the packet for recycling instead of freeing (implies
+ *		page_pool support on driver)
  *	@active_extensions: active extensions (skb_ext_id types)
  *	@ndisc_nodetype: router type (from link layer)
  *	@ooo_okay: allow the mapping of a socket to a queue to be changed
@@ -791,10 +796,12 @@ struct sk_buff {
 				fclone:2,
 				peeked:1,
 				head_frag:1,
-				pfmemalloc:1;
+				pfmemalloc:1,
+				pp_recycle:1; /* page_pool recycle indicator */
 #ifdef CONFIG_SKB_EXTENSIONS
 	__u8			active_extensions;
 #endif
+
 	/* fields enclosed in headers_start/headers_end are copied
 	 * using a single memcpy() in __copy_skb_header()
 	 */
@@ -3088,7 +3095,13 @@ static inline void skb_frag_ref(struct sk_buff *skb, int f)
  */
 static inline void __skb_frag_unref(skb_frag_t *frag, bool recycle)
 {
-	put_page(skb_frag_page(frag));
+	struct page *page = skb_frag_page(frag);
+
+#ifdef CONFIG_PAGE_POOL
+	if (recycle && page_pool_return_skb_page(page_address(page)))
+		return;
+#endif
+	put_page(page);
 }
 
 /**
@@ -3100,7 +3113,7 @@ static inline void __skb_frag_unref(skb_frag_t *frag, bool recycle)
  */
 static inline void skb_frag_unref(struct sk_buff *skb, int f)
 {
-	__skb_frag_unref(&skb_shinfo(skb)->frags[f], false);
+	__skb_frag_unref(&skb_shinfo(skb)->frags[f], skb->pp_recycle);
 }
 
 /**
@@ -4699,5 +4712,14 @@ static inline u64 skb_get_kcov_handle(struct sk_buff *skb)
 #endif
 }
 
+#ifdef CONFIG_PAGE_POOL
+static inline void skb_mark_for_recycle(struct sk_buff *skb, struct page *page,
+					struct page_pool *pp)
+{
+	skb->pp_recycle = 1;
+	page_pool_store_mem_info(page, pp);
+}
+#endif
+
 #endif	/* __KERNEL__ */
 #endif	/* _LINUX_SKBUFF_H */
diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index 24b3d42c62c0..ce75abeddb29 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -148,6 +148,8 @@ inline enum dma_data_direction page_pool_get_dma_dir(struct page_pool *pool)
 	return pool->p.dma_dir;
 }
 
+bool page_pool_return_skb_page(void *data);
+
 struct page_pool *page_pool_create(const struct page_pool_params *params);
 
 #ifdef CONFIG_PAGE_POOL
@@ -253,4 +255,11 @@ static inline void page_pool_ring_unlock(struct page_pool *pool)
 		spin_unlock_bh(&pool->ring.producer_lock);
 }
 
+/* Store mem_info on struct page and use it while recycling skb frags */
+static inline
+void page_pool_store_mem_info(struct page *page, struct page_pool *pp)
+{
+	page->pp = pp;
+}
+
 #endif /* _NET_PAGE_POOL_H */
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 9de5d8c08c17..fa9f17db7c48 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -626,3 +626,26 @@ void page_pool_update_nid(struct page_pool *pool, int new_nid)
 	}
 }
 EXPORT_SYMBOL(page_pool_update_nid);
+
+bool page_pool_return_skb_page(void *data)
+{
+	struct page_pool *pp;
+	struct page *page;
+
+	page = virt_to_head_page(data);
+	if (unlikely(page->pp_magic != PP_SIGNATURE))
+		return false;
+
+	pp = (struct page_pool *)page->pp;
+
+	/* Driver set this to memory recycling info. Reset it on recycle.
+	 * This will *not* work for NIC using a split-page memory model.
+	 * The page will be returned to the pool here regardless of the
+	 * 'flipped' fragment being in use or not.
+	 */
+	page->pp = NULL;
+	page_pool_put_full_page(pp, virt_to_head_page(data), false);
+
+	return true;
+}
+EXPORT_SYMBOL(page_pool_return_skb_page);
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 12b7e90dd2b5..9581af44d587 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -70,6 +70,9 @@
 #include <net/xfrm.h>
 #include <net/mpls.h>
 #include <net/mptcp.h>
+#ifdef CONFIG_PAGE_POOL
+#include <net/page_pool.h>
+#endif
 
 #include <linux/uaccess.h>
 #include <trace/events/skb.h>
@@ -645,10 +648,15 @@ static void skb_free_head(struct sk_buff *skb)
 {
 	unsigned char *head = skb->head;
 
-	if (skb->head_frag)
+	if (skb->head_frag) {
+#ifdef CONFIG_PAGE_POOL
+		if (skb->pp_recycle && page_pool_return_skb_page(head))
+			return;
+#endif
 		skb_free_frag(head);
-	else
+	} else {
 		kfree(head);
+	}
 }
 
 static void skb_release_data(struct sk_buff *skb)
@@ -664,7 +672,7 @@ static void skb_release_data(struct sk_buff *skb)
 	skb_zcopy_clear(skb, true);
 
 	for (i = 0; i < shinfo->nr_frags; i++)
-		__skb_frag_unref(&shinfo->frags[i], false);
+		__skb_frag_unref(&shinfo->frags[i], skb->pp_recycle);
 
 	if (shinfo->frag_list)
 		kfree_skb_list(shinfo->frag_list);
@@ -1046,6 +1054,7 @@ static struct sk_buff *__skb_clone(struct sk_buff *n, struct sk_buff *skb)
 	n->nohdr = 0;
 	n->peeked = 0;
 	C(pfmemalloc);
+	C(pp_recycle);
 	n->destructor = NULL;
 	C(tail);
 	C(end);
@@ -1725,6 +1734,7 @@ int pskb_expand_head(struct sk_buff *skb, int nhead, int ntail,
 	skb->cloned   = 0;
 	skb->hdr_len  = 0;
 	skb->nohdr    = 0;
+	skb->pp_recycle = 0;
 	atomic_set(&skb_shinfo(skb)->dataref, 1);
 
 	skb_metadata_clear(skb);
@@ -3495,7 +3505,7 @@ int skb_shift(struct sk_buff *tgt, struct sk_buff *skb, int shiftlen)
 		fragto = &skb_shinfo(tgt)->frags[merge];
 
 		skb_frag_size_add(fragto, skb_frag_size(fragfrom));
-		__skb_frag_unref(fragfrom, false);
+		__skb_frag_unref(fragfrom, skb->pp_recycle);
 	}
 
 	/* Reposition in the original skb */
@@ -5285,6 +5295,13 @@ bool skb_try_coalesce(struct sk_buff *to, struct sk_buff *from,
 	if (skb_cloned(to))
 		return false;
 
+	/* We can't coalesce skb that are allocated from slab and page_pool
+	 * The recycle mark is on the skb, so that might end up trying to
+	 * recycle slab allocated skb->head
+	 */
+	if (to->pp_recycle != from->pp_recycle)
+		return false;
+
 	if (len <= skb_tailroom(to)) {
 		if (len)
 			BUG_ON(skb_copy_bits(from, 0, skb_put(to, len), len));
-- 
2.31.1

