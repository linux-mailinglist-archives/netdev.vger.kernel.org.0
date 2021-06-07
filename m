Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E78CF39E721
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 21:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbhFGTFh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 15:05:37 -0400
Received: from mail-wm1-f52.google.com ([209.85.128.52]:38732 "EHLO
        mail-wm1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231565AbhFGTFd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 15:05:33 -0400
Received: by mail-wm1-f52.google.com with SMTP id t4-20020a1c77040000b029019d22d84ebdso352628wmi.3;
        Mon, 07 Jun 2021 12:03:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WFvvDHE28rBb9ZBkWikc+7gFy2OLKyvpJR4FRmz6gF4=;
        b=BbjW6BH1GkKYc7C+uspixt/HOhpDxVnRKDew07PFyZPxHbr87lCKXL7Rzqljz+C/Wi
         gtdDin/PC07yy5quXjqWuTR5++ea9KAp9EqPCDCnYL14hsa+PqOmTQ/IGlpkkZqTlq3N
         rgrsPXtIkdlxSNpCOflsdWTZF3i9YXCF2VWelGoiww4KWZY+TX74cYnI5w5Rqba8odTs
         eijTjzx/H4AEAVp2QVLfb2/I15WLFXRw13YRuaSq9G/j4GSf2X5ojWIZYMjwLQWylCIr
         1sqmODeCJN7G2ulD6EBEnHSqqXZbYYef9uYC/OaYB/LgpX5wNMn8wJ7j54dmt0Bf67oT
         qIHw==
X-Gm-Message-State: AOAM5301tD4Vdffv9cnkw76rLoXCCjFVaVFgXli+lcrL4HkpKl2x2gKj
        sdIEcXXJlZi7o70R1xweJVsUURUdSc7MhQ==
X-Google-Smtp-Source: ABdhPJwwJi22r4mlQh48N6e9FscAasjsEWdKNvTrwCLA0YThNr4JPgBKjLl9HfQKLtVCxzpLMqEVuQ==
X-Received: by 2002:a7b:c394:: with SMTP id s20mr576603wmj.24.1623092620430;
        Mon, 07 Jun 2021 12:03:40 -0700 (PDT)
Received: from msft-t490s.teknoraver.net (net-37-119-128-179.cust.vodafonedsl.it. [37.119.128.179])
        by smtp.gmail.com with ESMTPSA id g17sm12185968wrp.61.2021.06.07.12.03.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Jun 2021 12:03:40 -0700 (PDT)
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
Subject: [PATCH net-next v8 3/5] page_pool: Allow drivers to hint on SKB recycling
Date:   Mon,  7 Jun 2021 21:02:38 +0200
Message-Id: <20210607190240.36900-4-mcroce@linux.microsoft.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210607190240.36900-1-mcroce@linux.microsoft.com>
References: <20210607190240.36900-1-mcroce@linux.microsoft.com>
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
We could have skipped the skb bit entirely, since identical information
can bederived from struct page. However, in an effort to affect the free path
as less as possible, reading a single bit in the skb which is already
in cache, is better that trying to derive identical information for the
page stored data.

The driver or page_pool has to take care of the sync operations on it's own
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
 include/linux/skbuff.h  | 33 ++++++++++++++++++++++++++++++---
 include/net/page_pool.h |  9 +++++++++
 net/core/page_pool.c    | 22 ++++++++++++++++++++++
 net/core/skbuff.c       | 20 ++++++++++++++++----
 4 files changed, 77 insertions(+), 7 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 7fcfea7e7b21..b2db9cd9a73f 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -37,6 +37,7 @@
 #include <linux/in6.h>
 #include <linux/if_packet.h>
 #include <net/flow.h>
+#include <net/page_pool.h>
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
 #include <linux/netfilter/nf_conntrack_common.h>
 #endif
@@ -667,6 +668,8 @@ typedef unsigned char *sk_buff_data_t;
  *	@head_frag: skb was allocated from page fragments,
  *		not allocated by kmalloc() or vmalloc().
  *	@pfmemalloc: skbuff was allocated from PFMEMALLOC reserves
+ *	@pp_recycle: mark the packet for recycling instead of freeing (implies
+ *		page_pool support on driver)
  *	@active_extensions: active extensions (skb_ext_id types)
  *	@ndisc_nodetype: router type (from link layer)
  *	@ooo_okay: allow the mapping of a socket to a queue to be changed
@@ -791,10 +794,12 @@ struct sk_buff {
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
@@ -3088,7 +3093,13 @@ static inline void skb_frag_ref(struct sk_buff *skb, int f)
  */
 static inline void __skb_frag_unref(skb_frag_t *frag, bool recycle)
 {
-	put_page(skb_frag_page(frag));
+	struct page *page = skb_frag_page(frag);
+
+#ifdef CONFIG_PAGE_POOL
+	if (recycle && page_pool_return_skb_page(page))
+		return;
+#endif
+	put_page(page);
 }
 
 /**
@@ -3100,7 +3111,7 @@ static inline void __skb_frag_unref(skb_frag_t *frag, bool recycle)
  */
 static inline void skb_frag_unref(struct sk_buff *skb, int f)
 {
-	__skb_frag_unref(&skb_shinfo(skb)->frags[f], false);
+	__skb_frag_unref(&skb_shinfo(skb)->frags[f], skb->pp_recycle);
 }
 
 /**
@@ -4699,5 +4710,21 @@ static inline u64 skb_get_kcov_handle(struct sk_buff *skb)
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
+static inline bool skb_pp_recycle(struct sk_buff *skb, void *data)
+{
+	if (!IS_ENABLED(CONFIG_PAGE_POOL) || !skb->pp_recycle)
+		return false;
+	return page_pool_return_skb_page(virt_to_page(data));
+}
+
 #endif	/* __KERNEL__ */
 #endif	/* _LINUX_SKBUFF_H */
diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index b4b6de909c93..3dd62dd73027 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -146,6 +146,8 @@ inline enum dma_data_direction page_pool_get_dma_dir(struct page_pool *pool)
 	return pool->p.dma_dir;
 }
 
+bool page_pool_return_skb_page(struct page *page);
+
 struct page_pool *page_pool_create(const struct page_pool_params *params);
 
 #ifdef CONFIG_PAGE_POOL
@@ -251,4 +253,11 @@ static inline void page_pool_ring_unlock(struct page_pool *pool)
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
index e1321bc9d316..5e4eb45b139c 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -628,3 +628,25 @@ void page_pool_update_nid(struct page_pool *pool, int new_nid)
 	}
 }
 EXPORT_SYMBOL(page_pool_update_nid);
+
+bool page_pool_return_skb_page(struct page *page)
+{
+	struct page_pool *pp;
+
+	page = compound_head(page);
+	if (unlikely(page->pp_magic != PP_SIGNATURE))
+		return false;
+
+	pp = page->pp;
+
+	/* Driver set this to memory recycling info. Reset it on recycle.
+	 * This will *not* work for NIC using a split-page memory model.
+	 * The page will be returned to the pool here regardless of the
+	 * 'flipped' fragment being in use or not.
+	 */
+	page->pp = NULL;
+	page_pool_put_full_page(pp, page, false);
+
+	return true;
+}
+EXPORT_SYMBOL(page_pool_return_skb_page);
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 12b7e90dd2b5..a0b1d4847efe 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -70,6 +70,7 @@
 #include <net/xfrm.h>
 #include <net/mpls.h>
 #include <net/mptcp.h>
+#include <net/page_pool.h>
 
 #include <linux/uaccess.h>
 #include <trace/events/skb.h>
@@ -645,10 +646,13 @@ static void skb_free_head(struct sk_buff *skb)
 {
 	unsigned char *head = skb->head;
 
-	if (skb->head_frag)
+	if (skb->head_frag) {
+		if (skb_pp_recycle(skb, head))
+			return;
 		skb_free_frag(head);
-	else
+	} else {
 		kfree(head);
+	}
 }
 
 static void skb_release_data(struct sk_buff *skb)
@@ -664,7 +668,7 @@ static void skb_release_data(struct sk_buff *skb)
 	skb_zcopy_clear(skb, true);
 
 	for (i = 0; i < shinfo->nr_frags; i++)
-		__skb_frag_unref(&shinfo->frags[i], false);
+		__skb_frag_unref(&shinfo->frags[i], skb->pp_recycle);
 
 	if (shinfo->frag_list)
 		kfree_skb_list(shinfo->frag_list);
@@ -1046,6 +1050,7 @@ static struct sk_buff *__skb_clone(struct sk_buff *n, struct sk_buff *skb)
 	n->nohdr = 0;
 	n->peeked = 0;
 	C(pfmemalloc);
+	C(pp_recycle);
 	n->destructor = NULL;
 	C(tail);
 	C(end);
@@ -3495,7 +3500,7 @@ int skb_shift(struct sk_buff *tgt, struct sk_buff *skb, int shiftlen)
 		fragto = &skb_shinfo(tgt)->frags[merge];
 
 		skb_frag_size_add(fragto, skb_frag_size(fragfrom));
-		__skb_frag_unref(fragfrom, false);
+		__skb_frag_unref(fragfrom, skb->pp_recycle);
 	}
 
 	/* Reposition in the original skb */
@@ -5285,6 +5290,13 @@ bool skb_try_coalesce(struct sk_buff *to, struct sk_buff *from,
 	if (skb_cloned(to))
 		return false;
 
+	/* The page pool signature of struct page will eventually figure out
+	 * which pages can be recycled or not but for now let's prohibit slab
+	 * allocated and page_pool allocated SKBs from being coalesced.
+	 */
+	if (to->pp_recycle != from->pp_recycle)
+		return false;
+
 	if (len <= skb_tailroom(to)) {
 		if (len)
 			BUG_ON(skb_copy_bits(from, 0, skb_put(to, len), len));
-- 
2.31.1

