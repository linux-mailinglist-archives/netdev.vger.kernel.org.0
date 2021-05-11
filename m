Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D96E337A7B1
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 15:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231308AbhEKNeg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 09:34:36 -0400
Received: from mail-ed1-f44.google.com ([209.85.208.44]:38553 "EHLO
        mail-ed1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231259AbhEKNeY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 09:34:24 -0400
Received: by mail-ed1-f44.google.com with SMTP id n25so22893034edr.5;
        Tue, 11 May 2021 06:33:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Cwi7UBl7fw1WVCZR5ySz4Hv5hC5AJTdZV/EKBCrpo1o=;
        b=LOTWjd6bCA4tMMRC99AUZ0DTsjA0pEHCh0EjptsIuVcwDRUv51918Mlo4niW29TshI
         /4idxyQAklLdK7bPlCSFT55OrOU+T6DQhuZ13DrJxnfH3QgzSi9OBiWTs2QMiXx/toeL
         2PJ7ao+gwMNExydUS2D7TyKBjS+PABJqstMDUDZY+q48OBWCydlUQdrBMWWTSlSaVO5m
         7aWingrHdnJmfrqzk3THIAqHZBs+iku6OwUSZvZwOGZdE/0oVQ48laCNjfh1QaRv8aQJ
         M7z7NqNnvtEkZ4zPwXH0ARaqfeOdvOFfuve5fEKYJLW7BsUwSbfa9J2SaEUcOGiXMqXu
         0Qqg==
X-Gm-Message-State: AOAM533zoESzng+f4Jul8bvTSMIXKlsFCRfTgVyf4/LBO3rZpYZ53KCB
        KrJmwzWJ0rFgpm4MnC/HqvJnNYm98w/SpKix
X-Google-Smtp-Source: ABdhPJyJrxdzNaVlamBtfgeSBAfBiE98MVB0Z88lUR/BHplGzZtiVAa5k00sxansa+Up/zuFraMjcg==
X-Received: by 2002:a05:6402:8d3:: with SMTP id d19mr36153200edz.302.1620739995795;
        Tue, 11 May 2021 06:33:15 -0700 (PDT)
Received: from msft-t490s.teknoraver.net (net-5-94-253-60.cust.vodafonedsl.it. [5.94.253.60])
        by smtp.gmail.com with ESMTPSA id b12sm14577136eds.23.2021.05.11.06.33.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 06:33:15 -0700 (PDT)
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
Subject: [PATCH net-next v4 2/4] page_pool: Allow drivers to hint on SKB recycling
Date:   Tue, 11 May 2021 15:31:16 +0200
Message-Id: <20210511133118.15012-3-mcroce@linux.microsoft.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210511133118.15012-1-mcroce@linux.microsoft.com>
References: <20210511133118.15012-1-mcroce@linux.microsoft.com>
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
store the page_pool pointer in page->private. Storing the information in
page->private allows us to recycle both SKBs and their fragments.
The SKB bit is needed for a couple of reasons. First of all in an
effort to affect the free path as less as possible, reading a single bit,
is better that trying to derive identical information for the page stored
data. Moreover page->private is used by skb_copy_ubufs. We do have a
special mark in the page, that won't allow this to happen, but again
deciding without having to read the entire page is preferable.

The driver has to take care of the sync operations on it's own
during the buffer recycling since the buffer is, after opting-in to the
recycling, never unmapped.

Since the gain on the drivers depends on the architecture, we are not
enabling recycling by default if the page_pool API is used on a driver.
In order to enable recycling the driver must call skb_mark_for_recycle()
to store the information we need for recycling in page->private and
enabling the recycling bit, or page_pool_store_mem_info() for a fragment.

Since we added an extra argument on __skb_frag_unref() to handle
recycling, update the current users of the function with that.

Co-developed-by: Jesper Dangaard Brouer <brouer@redhat.com>
Co-developed-by: Matteo Croce <mcroce@microsoft.com>
Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Matteo Croce <mcroce@microsoft.com>
---
 drivers/net/ethernet/marvell/sky2.c        |  2 +-
 drivers/net/ethernet/mellanox/mlx4/en_rx.c |  2 +-
 include/linux/skbuff.h                     | 34 ++++++++++++++++++----
 include/net/page_pool.h                    |  9 ++++++
 net/core/page_pool.c                       | 23 +++++++++++++++
 net/core/skbuff.c                          | 20 +++++++++++--
 net/tls/tls_device.c                       |  2 +-
 7 files changed, 82 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index 222c32367b2c..aa0cde1dc5c0 100644
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
index dbf820a50a39..1a2ce52c29f9 100644
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
@@ -3081,12 +3088,20 @@ static inline void skb_frag_ref(struct sk_buff *skb, int f)
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
@@ -3098,7 +3113,7 @@ static inline void __skb_frag_unref(skb_frag_t *frag)
  */
 static inline void skb_frag_unref(struct sk_buff *skb, int f)
 {
-	__skb_frag_unref(&skb_shinfo(skb)->frags[f]);
+	__skb_frag_unref(&skb_shinfo(skb)->frags[f], skb->pp_recycle);
 }
 
 /**
@@ -4697,5 +4712,14 @@ static inline u64 skb_get_kcov_handle(struct sk_buff *skb)
 #endif
 }
 
+#if IS_BUILTIN(CONFIG_PAGE_POOL)
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
index 9814e36becc1..b34b8b128206 100644
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
+	set_page_private(page, (unsigned long)pp);
+}
+
 #endif /* _NET_PAGE_POOL_H */
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 2e5e2b8c3a02..52e4f16b5e92 100644
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
+	if (unlikely(page->signature != PP_SIGNATURE))
+		return false;
+
+	pp = (struct page_pool *)page_private(page);
+
+	/* Driver set this to memory recycling info. Reset it on recycle.
+	 * This will *not* work for NIC using a split-page memory model.
+	 * The page will be returned to the pool here regardless of the
+	 * 'flipped' fragment being in use or not.
+	 */
+	set_page_private(page, 0);
+	page_pool_put_full_page(pp, virt_to_head_page(data), false);
+
+	return true;
+}
+EXPORT_SYMBOL(page_pool_return_skb_page);
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 3ad22870298c..dc4a5c56b8dc 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -70,6 +70,9 @@
 #include <net/xfrm.h>
 #include <net/mpls.h>
 #include <net/mptcp.h>
+#if IS_BUILTIN(CONFIG_PAGE_POOL)
+#include <net/page_pool.h>
+#endif
 
 #include <linux/uaccess.h>
 #include <trace/events/skb.h>
@@ -645,6 +648,11 @@ static void skb_free_head(struct sk_buff *skb)
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
@@ -664,7 +672,7 @@ static void skb_release_data(struct sk_buff *skb)
 	skb_zcopy_clear(skb, true);
 
 	for (i = 0; i < shinfo->nr_frags; i++)
-		__skb_frag_unref(&shinfo->frags[i]);
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
@@ -3495,7 +3504,7 @@ int skb_shift(struct sk_buff *tgt, struct sk_buff *skb, int shiftlen)
 		fragto = &skb_shinfo(tgt)->frags[merge];
 
 		skb_frag_size_add(fragto, skb_frag_size(fragfrom));
-		__skb_frag_unref(fragfrom);
+		__skb_frag_unref(fragfrom, skb->pp_recycle);
 	}
 
 	/* Reposition in the original skb */
@@ -5285,6 +5294,13 @@ bool skb_try_coalesce(struct sk_buff *to, struct sk_buff *from,
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
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 76a6f8c2eec4..ad11db2c4f63 100644
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
2.31.1

