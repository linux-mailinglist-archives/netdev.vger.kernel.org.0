Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBEC935A8CF
	for <lists+netdev@lfdr.de>; Sat, 10 Apr 2021 00:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235290AbhDIWjD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 18:39:03 -0400
Received: from mail-ej1-f44.google.com ([209.85.218.44]:44664 "EHLO
        mail-ej1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234602AbhDIWjC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 18:39:02 -0400
Received: by mail-ej1-f44.google.com with SMTP id e14so10967306ejz.11;
        Fri, 09 Apr 2021 15:38:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WnPKFMtfhSLVnqHsKOr4n3p6UHXAjM0KTUn3EX9S5lk=;
        b=ULVTJAep0M4PhS/8kj0/+0wnVsYgBWeJT4+Gr7MKAsmScdNF1sVUkMo+DAwkLq6EdR
         Ui1PSWRf1mr76VplXF3/7UULdCEPWisr7WmHOh3OudSiR39ePXWSZkIGXlfmCSg4Nmdt
         T1jKGYmuoHcOV5PjoBGLJPvYFbU/J8BMH/GcxW/oH+3L4GnGYpsMEReYxtSiNehOcjzA
         ZjSNUTkhvFVd1f/iPvnn3mAIyfumey+Hb9XCqkHUnmytP9kEai8GJtnggK1p6FTBD9/+
         8Hp/VyFVOPPyzZfx8QxJG8tvWHctmjSKe6xYNaxcBK8uqhhA0bGM0JzePigIIeL+vut3
         8ciA==
X-Gm-Message-State: AOAM530n5IiTnxbA2esXm73enrddyvfemTS7XWkU4TtTZEMWupi3B8j7
        odJVfJiDe4C5Lf2i8G2Io12foFU97MgteA==
X-Google-Smtp-Source: ABdhPJwZUB++JXfyXp3fEVkjnhLtKdZvPEwn6hIKwd5D3ixTXi4hn4Q80nn/2cJloLRuQHZ3JRaqZQ==
X-Received: by 2002:a17:907:75cc:: with SMTP id jl12mr8220890ejc.52.1618007927405;
        Fri, 09 Apr 2021 15:38:47 -0700 (PDT)
Received: from msft-t490s.teknoraver.net (net-93-66-21-119.cust.vodafonedsl.it. [93.66.21.119])
        by smtp.gmail.com with ESMTPSA id s20sm2108726edu.93.2021.04.09.15.38.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Apr 2021 15:38:46 -0700 (PDT)
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
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Cong Wang <cong.wang@bytedance.com>, wenxu <wenxu@ucloud.cn>,
        Kevin Hao <haokexin@gmail.com>,
        Aleksandr Nogikh <nogikh@google.com>,
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
        Andrew Lunn <andrew@lunn.ch>, Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next v3 3/5] page_pool: Allow drivers to hint on SKB recycling
Date:   Sat, 10 Apr 2021 00:37:59 +0200
Message-Id: <20210409223801.104657-4-mcroce@linux.microsoft.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210409223801.104657-1-mcroce@linux.microsoft.com>
References: <20210409223801.104657-1-mcroce@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ilias Apalodimas <ilias.apalodimas@linaro.org>

Up to now several high speed NICs have custom mechanisms of recycling
the allocated memory they use for their payloads.
Our page_pool API already has recycling capabilities that are always
used when we are running in 'XDP mode'.  So let's tweak the API and the
kernel network stack slightly and allow the recycling to happen even
during the standard operation.
The API doesn't take into account 'split page' policies used by those
drivers currently, but can be extended once we have users for that.

The idea is to be able to intercept the packet on skb_release_data().
If it's a buffer coming from our page_pool API recycle it back to the
pool for further usage or just release the packet entirely.

To achieve that we introduce a bit in struct sk_buff (pp_recycle:1) and
store the xdp_mem_info in page->private.  Storing the information in
page->private allows us to recycle both SKBs and their fragments.
The SKB bit is needed for a couple of reasons. First of all in an
effort to affect the free path as less as possible, reading a single bit,
is better that trying to derive identical information for the page stored
data. Moreover page->private is used by skb_copy_ubufs.  We do have a
special mark in the page, that won't allow this to happen, but again
deciding without having to read the entire page is preferable.

The driver has to take care of the sync operations on it's own
during the buffer recycling since the buffer is, after opting-in to the
recycling, never unmapped.

Since the gain on the drivers depends on the architecture, we are not
enabling recycling by default if the page_pool API is used on a driver.
In order to enable recycling the driver must call skb_mark_for_recycle()
to store the information we need for recycling in page->private and
enabling the recycling bit, or page_pool_store_mem_info() for a fragment

Since we added an extra argument on __skb_frag_unref() to handle
recycling, update the current users of the function with that.

Co-developed-by: Jesper Dangaard Brouer <brouer@redhat.com>
Co-developed-by: Matteo Croce <mcroce@microsoft.com>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Matteo Croce <mcroce@microsoft.com>
Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
---
 .../chelsio/inline_crypto/ch_ktls/chcr_ktls.c |  2 +-
 drivers/net/ethernet/marvell/sky2.c           |  2 +-
 drivers/net/ethernet/mellanox/mlx4/en_rx.c    |  2 +-
 include/linux/skbuff.h                        | 35 ++++++++++++---
 include/net/page_pool.h                       | 13 ++++++
 include/net/xdp.h                             |  1 +
 net/core/page_pool.c                          | 43 +++++++++++++++++++
 net/core/skbuff.c                             | 20 ++++++++-
 net/core/xdp.c                                |  6 +++
 net/tls/tls_device.c                          |  2 +-
 10 files changed, 115 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
index 1115b8f9ea4e..8f815ebb59ae 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
@@ -2125,7 +2125,7 @@ static int chcr_ktls_xmit(struct sk_buff *skb, struct net_device *dev)
 		/* clear the frag ref count which increased locally before */
 		for (i = 0; i < record->num_frags; i++) {
 			/* clear the frag ref count */
-			__skb_frag_unref(&record->frags[i]);
+			__skb_frag_unref(&record->frags[i], false);
 		}
 		/* if any failure, come out from the loop. */
 		if (ret) {
diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index 68c154d715d6..9dc25c4fb359 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -2503,7 +2503,7 @@ static void skb_put_frags(struct sk_buff *skb, unsigned int hdr_space,
 
 		if (length == 0) {
 			/* don't need this page */
-			__skb_frag_unref(frag);
+			__skb_frag_unref(frag, false);
 			--skb_shinfo(skb)->nr_frags;
 		} else {
 			size = min(length, (unsigned) PAGE_SIZE);
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
index e35e4d7ef4d1..cea62b8f554c 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
@@ -526,7 +526,7 @@ static int mlx4_en_complete_rx_desc(struct mlx4_en_priv *priv,
 fail:
 	while (nr > 0) {
 		nr--;
-		__skb_frag_unref(skb_shinfo(skb)->frags + nr);
+		__skb_frag_unref(skb_shinfo(skb)->frags + nr, false);
 	}
 	return 0;
 }
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index dbf820a50a39..869f248204b9 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -40,6 +40,9 @@
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
 #include <linux/netfilter/nf_conntrack_common.h>
 #endif
+#if IS_BUILTIN(CONFIG_PAGE_POOL)
+#include <net/page_pool.h>
+#endif
 
 /* The interface for checksum offload between the stack and networking drivers
  * is as follows...
@@ -247,6 +250,7 @@ struct napi_struct;
 struct bpf_prog;
 union bpf_attr;
 struct skb_ext;
+struct xdp_mem_info;
 
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
 struct nf_bridge_info {
@@ -667,6 +671,8 @@ typedef unsigned char *sk_buff_data_t;
  *	@head_frag: skb was allocated from page fragments,
  *		not allocated by kmalloc() or vmalloc().
  *	@pfmemalloc: skbuff was allocated from PFMEMALLOC reserves
+ *	@pp_recycle: mark the packet for recycling instead of freeing (implies
+ *		page_pool support on driver)
  *	@active_extensions: active extensions (skb_ext_id types)
  *	@ndisc_nodetype: router type (from link layer)
  *	@ooo_okay: allow the mapping of a socket to a queue to be changed
@@ -791,10 +797,12 @@ struct sk_buff {
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
@@ -3081,12 +3089,20 @@ static inline void skb_frag_ref(struct sk_buff *skb, int f)
 /**
  * __skb_frag_unref - release a reference on a paged fragment.
  * @frag: the paged fragment
+ * @recycle: recycle the page if allocated via page_pool
  *
- * Releases a reference on the paged fragment @frag.
+ * Releases a reference on the paged fragment @frag
+ * or recycles the page via the page_pool API.
  */
-static inline void __skb_frag_unref(skb_frag_t *frag)
+static inline void __skb_frag_unref(skb_frag_t *frag, bool recycle)
 {
-	put_page(skb_frag_page(frag));
+	struct page *page = skb_frag_page(frag);
+
+#if IS_BUILTIN(CONFIG_PAGE_POOL)
+	if (recycle && page_pool_return_skb_page(page_address(page)))
+		return;
+#endif
+	put_page(page);
 }
 
 /**
@@ -3098,7 +3114,7 @@ static inline void __skb_frag_unref(skb_frag_t *frag)
  */
 static inline void skb_frag_unref(struct sk_buff *skb, int f)
 {
-	__skb_frag_unref(&skb_shinfo(skb)->frags[f]);
+	__skb_frag_unref(&skb_shinfo(skb)->frags[f], skb->pp_recycle);
 }
 
 /**
@@ -4697,5 +4713,14 @@ static inline u64 skb_get_kcov_handle(struct sk_buff *skb)
 #endif
 }
 
+#if IS_BUILTIN(CONFIG_PAGE_POOL)
+static inline void skb_mark_for_recycle(struct sk_buff *skb, struct page *page,
+					struct xdp_mem_info *mem)
+{
+	skb->pp_recycle = 1;
+	page_pool_store_mem_info(page, mem);
+}
+#endif
+
 #endif	/* __KERNEL__ */
 #endif	/* _LINUX_SKBUFF_H */
diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index b30405e84b5e..75fffc15788b 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -65,6 +65,8 @@
 #define PP_ALLOC_CACHE_REFILL	64
 #define PP_SIGNATURE		0x20210303
 
+struct xdp_mem_info;
+
 struct pp_alloc_cache {
 	u32 count;
 	void *cache[PP_ALLOC_CACHE_SIZE];
@@ -148,6 +150,8 @@ inline enum dma_data_direction page_pool_get_dma_dir(struct page_pool *pool)
 	return pool->p.dma_dir;
 }
 
+bool page_pool_return_skb_page(void *data);
+
 struct page_pool *page_pool_create(const struct page_pool_params *params);
 
 #ifdef CONFIG_PAGE_POOL
@@ -243,4 +247,13 @@ static inline void page_pool_ring_unlock(struct page_pool *pool)
 		spin_unlock_bh(&pool->ring.producer_lock);
 }
 
+/* Store mem_info on struct page and use it while recycling skb frags */
+static inline
+void page_pool_store_mem_info(struct page *page, struct xdp_mem_info *mem)
+{
+	u32 *xmi = (u32 *)mem;
+
+	set_page_private(page, *xmi);
+}
+
 #endif /* _NET_PAGE_POOL_H */
diff --git a/include/net/xdp.h b/include/net/xdp.h
index c35864d59113..5d7316f1f195 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -235,6 +235,7 @@ void xdp_return_buff(struct xdp_buff *xdp);
 void xdp_flush_frame_bulk(struct xdp_frame_bulk *bq);
 void xdp_return_frame_bulk(struct xdp_frame *xdpf,
 			   struct xdp_frame_bulk *bq);
+void xdp_return_skb_frame(void *data, struct xdp_mem_info *mem);
 
 /* When sending xdp_frame into the network stack, then there is no
  * return point callback, which is needed to release e.g. DMA-mapping
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 2ae9b554ef98..43bfd2e3d8df 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -9,6 +9,7 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/device.h>
+#include <linux/skbuff.h>
 
 #include <net/page_pool.h>
 #include <net/xdp.h>
@@ -17,12 +18,19 @@
 #include <linux/dma-mapping.h>
 #include <linux/page-flags.h>
 #include <linux/mm.h> /* for __put_page() */
+#include <net/xdp.h>
 
 #include <trace/events/page_pool.h>
 
 #define DEFER_TIME (msecs_to_jiffies(1000))
 #define DEFER_WARN_INTERVAL (60 * HZ)
 
+/* Used to store/retrieve hi/lo bytes from xdp_mem_info to page->private */
+union page_pool_xmi {
+	u32 raw;
+	struct xdp_mem_info mem_info;
+};
+
 static int page_pool_init(struct page_pool *pool,
 			  const struct page_pool_params *params)
 {
@@ -587,3 +595,38 @@ void page_pool_update_nid(struct page_pool *pool, int new_nid)
 	}
 }
 EXPORT_SYMBOL(page_pool_update_nid);
+
+bool page_pool_return_skb_page(void *data)
+{
+	struct xdp_mem_info mem_info;
+	union page_pool_xmi info;
+	struct page *page;
+
+	page = virt_to_head_page(data);
+	if (unlikely(page->signature != PP_SIGNATURE))
+		return false;
+
+	info.raw = page_private(page);
+	mem_info = info.mem_info;
+
+	/* If a buffer is marked for recycle and does not belong to
+	 * MEM_TYPE_PAGE_POOL, the buffers will be eventually freed from the
+	 * network stack and kfree_skb, but the DMA region will *not* be
+	 * correctly unmapped. WARN here for the recycling misusage
+	 */
+	if (unlikely(mem_info.type != MEM_TYPE_PAGE_POOL)) {
+		WARN_ONCE(true, "Tried to recycle non MEM_TYPE_PAGE_POOL");
+		return false;
+	}
+
+	/* Driver set this to memory recycling info. Reset it on recycle
+	 * This will *not* work for NIC using a split-page memory model.
+	 * The page will be returned to the pool here regardless of the
+	 * 'flipped' fragment being in use or not
+	 */
+	set_page_private(page, 0);
+	xdp_return_skb_frame(data, &mem_info);
+
+	return true;
+}
+EXPORT_SYMBOL(page_pool_return_skb_page);
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 3ad9e8425ab2..650f517565dd 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -69,6 +69,9 @@
 #include <net/xfrm.h>
 #include <net/mpls.h>
 #include <net/mptcp.h>
+#if IS_BUILTIN(CONFIG_PAGE_POOL)
+#include <net/page_pool.h>
+#endif
 
 #include <linux/uaccess.h>
 #include <trace/events/skb.h>
@@ -644,6 +647,11 @@ static void skb_free_head(struct sk_buff *skb)
 {
 	unsigned char *head = skb->head;
 
+#if IS_BUILTIN(CONFIG_PAGE_POOL)
+	if (skb->pp_recycle && page_pool_return_skb_page(head))
+		return;
+#endif
+
 	if (skb->head_frag)
 		skb_free_frag(head);
 	else
@@ -663,7 +671,7 @@ static void skb_release_data(struct sk_buff *skb)
 	skb_zcopy_clear(skb, true);
 
 	for (i = 0; i < shinfo->nr_frags; i++)
-		__skb_frag_unref(&shinfo->frags[i]);
+		__skb_frag_unref(&shinfo->frags[i], skb->pp_recycle);
 
 	if (shinfo->frag_list)
 		kfree_skb_list(shinfo->frag_list);
@@ -1045,6 +1053,7 @@ static struct sk_buff *__skb_clone(struct sk_buff *n, struct sk_buff *skb)
 	n->nohdr = 0;
 	n->peeked = 0;
 	C(pfmemalloc);
+	C(pp_recycle);
 	n->destructor = NULL;
 	C(tail);
 	C(end);
@@ -3494,7 +3503,7 @@ int skb_shift(struct sk_buff *tgt, struct sk_buff *skb, int shiftlen)
 		fragto = &skb_shinfo(tgt)->frags[merge];
 
 		skb_frag_size_add(fragto, skb_frag_size(fragfrom));
-		__skb_frag_unref(fragfrom);
+		__skb_frag_unref(fragfrom, skb->pp_recycle);
 	}
 
 	/* Reposition in the original skb */
@@ -5275,6 +5284,13 @@ bool skb_try_coalesce(struct sk_buff *to, struct sk_buff *from,
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
diff --git a/net/core/xdp.c b/net/core/xdp.c
index 3dd47ed83778..d89b827e54a9 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -372,6 +372,12 @@ static void __xdp_return(void *data, struct xdp_mem_info *mem, bool napi_direct,
 	}
 }
 
+void xdp_return_skb_frame(void *data, struct xdp_mem_info *mem)
+{
+	__xdp_return(data, mem, false, NULL);
+}
+EXPORT_SYMBOL_GPL(xdp_return_skb_frame);
+
 void xdp_return_frame(struct xdp_frame *xdpf)
 {
 	__xdp_return(xdpf->data, &xdpf->mem, false, NULL);
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 790c6b7ecb26..8027a58c76a2 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -127,7 +127,7 @@ static void destroy_record(struct tls_record_info *record)
 	int i;
 
 	for (i = 0; i < record->num_frags; i++)
-		__skb_frag_unref(&record->frags[i]);
+		__skb_frag_unref(&record->frags[i], false);
 	kfree(record);
 }
 
-- 
2.30.2

