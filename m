Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE46016589D
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 08:42:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726805AbgBTHmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 02:42:11 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:37574 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726771AbgBTHmK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 02:42:10 -0500
Received: by mail-wm1-f67.google.com with SMTP id a6so887492wme.2
        for <netdev@vger.kernel.org>; Wed, 19 Feb 2020 23:42:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MrExRVHfCTUA2yAPQFKdTX7r389hISwczuvvDXnDLbI=;
        b=sIU/Mc5WMqwVU314KSuaJzl5Pq6BEM5wROsfrj/OQsm7tWKpzgJveZxi42zHayBrFO
         r7giKeC8t1GtCD+i2qAi0Fd50+2tupd/X8ZZyKXdeVKCLms5q1rcQlY0xJqPsKCrBPk8
         fAmEweVFFzvHP+ejY+KYE0JZIu1nHGbRTpMU7uDzLaGWj0q5rzDQL2Z772aqnZfhTuGx
         ABS+/dcpW2Lh5+d16GBv0NRO14EctK6RzolCiNO6JATDZRZ7f7Fs7TA70Exq3q+mSczR
         rhuwisIk62WyRJdbwatMeQ91dUzayndBD+6ZaeyBSr58R7MWTnOfoqZYTs5une/P/KTe
         ufmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MrExRVHfCTUA2yAPQFKdTX7r389hISwczuvvDXnDLbI=;
        b=MqY9uKBip0GxhuUyz9UlgxwAEVeZvoF+Lb+UvLEL508m2gv8JAg2dcRlG4luASKmun
         40CBqCdFXN5pX7oTMrHJbfH+n9/KPJK0IDI+tRVcYwJJHkxircCofCZ0webo7EXS+5qi
         ozce3ViV1q9HaW8XAspLra0PzL98o8mR0s54TnR2si/g4i2D/7g/srRUGC37djDxN0PP
         MTwb+IwhE9nEdFS0Y+P9kAaHuQcYBQt92ShZyCetd1qYxUrrtNQcD7kuszQ4Sd6xVc9r
         8pNsWFTuIcAdat3G/4jw77/Tx3B8DfAdyWBQw+Q4Qmn4Ek8EMN9wJDLZnwkySwIgI6c1
         /uug==
X-Gm-Message-State: APjAAAXV2rx/uwzAA+8kiJxUnuAEF4r1Z6MRLgfKjQ65sP3D4k7in9r/
        16JfAi9ZGoGSyFYyMlVVPV4g9VIE/wc=
X-Google-Smtp-Source: APXvYqzXJT0ymvqA0333og2fBQPI+h9ZejsFqB6ROkT5iajY7grWfPDkpfV6f49ugWuSKCZgSMOS0A==
X-Received: by 2002:a05:600c:20f:: with SMTP id 15mr2695232wmi.128.1582184526641;
        Wed, 19 Feb 2020 23:42:06 -0800 (PST)
Received: from apalos.home ([2a02:587:4655:3a80:2e56:dcff:fe9a:8f06])
        by smtp.gmail.com with ESMTPSA id y12sm3265294wrw.88.2020.02.19.23.42.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2020 23:42:05 -0800 (PST)
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     netdev@vger.kernel.org
Cc:     jonathan.lemon@gmail.com, lorenzo@kernel.org, toke@redhat.com,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, bpf@vger.kernel.org
Subject: [PATCH net-next v5] net: page_pool: API cleanup and comments
Date:   Thu, 20 Feb 2020 09:41:55 +0200
Message-Id: <20200220074155.765234-1-ilias.apalodimas@linaro.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Functions starting with __ usually indicate those which are exported,
but should not be called directly. Update some of those declared in the
API and make it more readable.

page_pool_unmap_page() and page_pool_release_page() were doing
exactly the same thing calling __page_pool_clean_page().  Let's
rename __page_pool_clean_page() to page_pool_release_page() and
export it in order to show up on perf logs and get rid of
page_pool_unmap_page().

Finally rename __page_pool_put_page() to page_pool_put_page() since we
can now directly call it from drivers and rename the existing
page_pool_put_page() to page_pool_put_full_page() since they do the same
thing but the latter is trying to sync the full DMA area.

This patch also updates netsec, mvneta and stmmac drivers which use
those functions.

Suggested-by: Jonathan Lemon <jonathan.lemon@gmail.com>
Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
---
Changes since
v1:
- Fixed netsec driver compilation error
v2:
- Improved comment description of page_pool_put_page()
v3:
- Properly define page_pool_release_page() in the header file
  within an ifdef since xdp.c uses it even if CONFIG_PAGE_POOL is not selected
- rename __page_pool_clean_page -> page_pool_release_page and get rid of
another redundant helper
v4:
- Rebase on top of master

 drivers/net/ethernet/marvell/mvneta.c         | 19 +++--
 drivers/net/ethernet/socionext/netsec.c       | 23 +++---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  4 +-
 include/net/page_pool.h                       | 36 ++++------
 net/core/page_pool.c                          | 70 ++++++++++---------
 net/core/xdp.c                                |  2 +-
 6 files changed, 74 insertions(+), 80 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 8e1feb678cea..1c391f63a26f 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -1956,7 +1956,7 @@ static void mvneta_rxq_drop_pkts(struct mvneta_port *pp,
 		if (!data || !(rx_desc->buf_phys_addr))
 			continue;
 
-		page_pool_put_page(rxq->page_pool, data, false);
+		page_pool_put_full_page(rxq->page_pool, data, false);
 	}
 	if (xdp_rxq_info_is_reg(&rxq->xdp_rxq))
 		xdp_rxq_info_unreg(&rxq->xdp_rxq);
@@ -2154,9 +2154,9 @@ mvneta_run_xdp(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
 		err = xdp_do_redirect(pp->dev, xdp, prog);
 		if (err) {
 			ret = MVNETA_XDP_DROPPED;
-			__page_pool_put_page(rxq->page_pool,
-					     virt_to_head_page(xdp->data),
-					     len, true);
+			page_pool_put_page(rxq->page_pool,
+					   virt_to_head_page(xdp->data), len,
+					   true);
 		} else {
 			ret = MVNETA_XDP_REDIR;
 			stats->xdp_redirect++;
@@ -2166,9 +2166,9 @@ mvneta_run_xdp(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
 	case XDP_TX:
 		ret = mvneta_xdp_xmit_back(pp, xdp);
 		if (ret != MVNETA_XDP_TX)
-			__page_pool_put_page(rxq->page_pool,
-					     virt_to_head_page(xdp->data),
-					     len, true);
+			page_pool_put_page(rxq->page_pool,
+					   virt_to_head_page(xdp->data), len,
+					   true);
 		break;
 	default:
 		bpf_warn_invalid_xdp_action(act);
@@ -2177,9 +2177,8 @@ mvneta_run_xdp(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
 		trace_xdp_exception(pp->dev, prog, act);
 		/* fall through */
 	case XDP_DROP:
-		__page_pool_put_page(rxq->page_pool,
-				     virt_to_head_page(xdp->data),
-				     len, true);
+		page_pool_put_page(rxq->page_pool,
+				   virt_to_head_page(xdp->data), len, true);
 		ret = MVNETA_XDP_DROPPED;
 		stats->xdp_drop++;
 		break;
diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index 6266926fe054..58b9b7ce7195 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -896,9 +896,9 @@ static u32 netsec_run_xdp(struct netsec_priv *priv, struct bpf_prog *prog,
 	case XDP_TX:
 		ret = netsec_xdp_xmit_back(priv, xdp);
 		if (ret != NETSEC_XDP_TX)
-			__page_pool_put_page(dring->page_pool,
-					     virt_to_head_page(xdp->data),
-					     len, true);
+			page_pool_put_page(dring->page_pool,
+					   virt_to_head_page(xdp->data), len,
+					   true);
 		break;
 	case XDP_REDIRECT:
 		err = xdp_do_redirect(priv->ndev, xdp, prog);
@@ -906,9 +906,9 @@ static u32 netsec_run_xdp(struct netsec_priv *priv, struct bpf_prog *prog,
 			ret = NETSEC_XDP_REDIR;
 		} else {
 			ret = NETSEC_XDP_CONSUMED;
-			__page_pool_put_page(dring->page_pool,
-					     virt_to_head_page(xdp->data),
-					     len, true);
+			page_pool_put_page(dring->page_pool,
+					   virt_to_head_page(xdp->data), len,
+					   true);
 		}
 		break;
 	default:
@@ -919,9 +919,8 @@ static u32 netsec_run_xdp(struct netsec_priv *priv, struct bpf_prog *prog,
 		/* fall through -- handle aborts by dropping packet */
 	case XDP_DROP:
 		ret = NETSEC_XDP_CONSUMED;
-		__page_pool_put_page(dring->page_pool,
-				     virt_to_head_page(xdp->data),
-				     len, true);
+		page_pool_put_page(dring->page_pool,
+				   virt_to_head_page(xdp->data), len, true);
 		break;
 	}
 
@@ -1020,8 +1019,8 @@ static int netsec_process_rx(struct netsec_priv *priv, int budget)
 			 * cache state. Since we paid the allocation cost if
 			 * building an skb fails try to put the page into cache
 			 */
-			__page_pool_put_page(dring->page_pool, page,
-					     pkt_len, true);
+			page_pool_put_page(dring->page_pool, page, pkt_len,
+					   true);
 			netif_err(priv, drv, priv->ndev,
 				  "rx failed to build skb\n");
 			break;
@@ -1195,7 +1194,7 @@ static void netsec_uninit_pkt_dring(struct netsec_priv *priv, int id)
 		if (id == NETSEC_RING_RX) {
 			struct page *page = virt_to_page(desc->addr);
 
-			page_pool_put_page(dring->page_pool, page, false);
+			page_pool_put_full_page(dring->page_pool, page, false);
 		} else if (id == NETSEC_RING_TX) {
 			dma_unmap_single(priv->dev, desc->dma_addr, desc->len,
 					 DMA_TO_DEVICE);
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 5836b21edd7e..37920b4da091 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1251,11 +1251,11 @@ static void stmmac_free_rx_buffer(struct stmmac_priv *priv, u32 queue, int i)
 	struct stmmac_rx_buffer *buf = &rx_q->buf_pool[i];
 
 	if (buf->page)
-		page_pool_put_page(rx_q->page_pool, buf->page, false);
+		page_pool_put_full_page(rx_q->page_pool, buf->page, false);
 	buf->page = NULL;
 
 	if (buf->sec_page)
-		page_pool_put_page(rx_q->page_pool, buf->sec_page, false);
+		page_pool_put_full_page(rx_q->page_pool, buf->sec_page, false);
 	buf->sec_page = NULL;
 }
 
diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index cfbed00ba7ee..81d7773f96cd 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -151,6 +151,7 @@ struct page_pool *page_pool_create(const struct page_pool_params *params);
 #ifdef CONFIG_PAGE_POOL
 void page_pool_destroy(struct page_pool *pool);
 void page_pool_use_xdp_mem(struct page_pool *pool, void (*disconnect)(void *));
+void page_pool_release_page(struct page_pool *pool, struct page *page);
 #else
 static inline void page_pool_destroy(struct page_pool *pool)
 {
@@ -160,41 +161,32 @@ static inline void page_pool_use_xdp_mem(struct page_pool *pool,
 					 void (*disconnect)(void *))
 {
 }
+static inline void page_pool_release_page(struct page_pool *pool,
+					  struct page *page)
+{
+}
 #endif
 
-/* Never call this directly, use helpers below */
-void __page_pool_put_page(struct page_pool *pool, struct page *page,
-			  unsigned int dma_sync_size, bool allow_direct);
+void page_pool_put_page(struct page_pool *pool, struct page *page,
+			unsigned int dma_sync_size, bool allow_direct);
 
-static inline void page_pool_put_page(struct page_pool *pool,
-				      struct page *page, bool allow_direct)
+/* Same as above but will try to sync the entire area pool->max_len */
+static inline void page_pool_put_full_page(struct page_pool *pool,
+					   struct page *page, bool allow_direct)
 {
 	/* When page_pool isn't compiled-in, net/core/xdp.c doesn't
 	 * allow registering MEM_TYPE_PAGE_POOL, but shield linker.
 	 */
 #ifdef CONFIG_PAGE_POOL
-	__page_pool_put_page(pool, page, -1, allow_direct);
+	page_pool_put_page(pool, page, -1, allow_direct);
 #endif
 }
-/* Very limited use-cases allow recycle direct */
+
+/* Same as above but the caller must guarantee safe context. e.g NAPI */
 static inline void page_pool_recycle_direct(struct page_pool *pool,
 					    struct page *page)
 {
-	__page_pool_put_page(pool, page, -1, true);
-}
-
-/* Disconnects a page (from a page_pool).  API users can have a need
- * to disconnect a page (from a page_pool), to allow it to be used as
- * a regular page (that will eventually be returned to the normal
- * page-allocator via put_page).
- */
-void page_pool_unmap_page(struct page_pool *pool, struct page *page);
-static inline void page_pool_release_page(struct page_pool *pool,
-					  struct page *page)
-{
-#ifdef CONFIG_PAGE_POOL
-	page_pool_unmap_page(pool, page);
-#endif
+	page_pool_put_full_page(pool, page, true);
 }
 
 static inline dma_addr_t page_pool_get_dma_addr(struct page *page)
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 10d2b255df5e..626db912fce4 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -96,7 +96,7 @@ struct page_pool *page_pool_create(const struct page_pool_params *params)
 }
 EXPORT_SYMBOL(page_pool_create);
 
-static void __page_pool_return_page(struct page_pool *pool, struct page *page);
+static void page_pool_return_page(struct page_pool *pool, struct page *page);
 
 noinline
 static struct page *page_pool_refill_alloc_cache(struct page_pool *pool)
@@ -136,7 +136,7 @@ static struct page *page_pool_refill_alloc_cache(struct page_pool *pool)
 			 * (2) break out to fallthrough to alloc_pages_node.
 			 * This limit stress on page buddy alloactor.
 			 */
-			__page_pool_return_page(pool, page);
+			page_pool_return_page(pool, page);
 			page = NULL;
 			break;
 		}
@@ -274,18 +274,25 @@ static s32 page_pool_inflight(struct page_pool *pool)
 	return inflight;
 }
 
-/* Cleanup page_pool state from page */
-static void __page_pool_clean_page(struct page_pool *pool,
-				   struct page *page)
+/* Disconnects a page (from a page_pool).  API users can have a need
+ * to disconnect a page (from a page_pool), to allow it to be used as
+ * a regular page (that will eventually be returned to the normal
+ * page-allocator via put_page).
+ */
+void page_pool_release_page(struct page_pool *pool, struct page *page)
 {
 	dma_addr_t dma;
 	int count;
 
 	if (!(pool->p.flags & PP_FLAG_DMA_MAP))
+		/* Always account for inflight pages, even if we didn't
+		 * map them
+		 */
 		goto skip_dma_unmap;
 
 	dma = page->dma_addr;
-	/* DMA unmap */
+
+	/* When page is unmapped, it cannot be returned our pool */
 	dma_unmap_page_attrs(pool->p.dev, dma,
 			     PAGE_SIZE << pool->p.order, pool->p.dma_dir,
 			     DMA_ATTR_SKIP_CPU_SYNC);
@@ -297,21 +304,12 @@ static void __page_pool_clean_page(struct page_pool *pool,
 	count = atomic_inc_return(&pool->pages_state_release_cnt);
 	trace_page_pool_state_release(pool, page, count);
 }
-
-/* unmap the page and clean our state */
-void page_pool_unmap_page(struct page_pool *pool, struct page *page)
-{
-	/* When page is unmapped, this implies page will not be
-	 * returned to page_pool.
-	 */
-	__page_pool_clean_page(pool, page);
-}
-EXPORT_SYMBOL(page_pool_unmap_page);
+EXPORT_SYMBOL(page_pool_release_page);
 
 /* Return a page to the page allocator, cleaning up our state */
-static void __page_pool_return_page(struct page_pool *pool, struct page *page)
+static void page_pool_return_page(struct page_pool *pool, struct page *page)
 {
-	__page_pool_clean_page(pool, page);
+	page_pool_release_page(pool, page);
 
 	put_page(page);
 	/* An optimization would be to call __free_pages(page, pool->p.order)
@@ -320,8 +318,7 @@ static void __page_pool_return_page(struct page_pool *pool, struct page *page)
 	 */
 }
 
-static bool __page_pool_recycle_into_ring(struct page_pool *pool,
-				   struct page *page)
+static bool page_pool_recycle_in_ring(struct page_pool *pool, struct page *page)
 {
 	int ret;
 	/* BH protection not needed if current is serving softirq */
@@ -338,7 +335,7 @@ static bool __page_pool_recycle_into_ring(struct page_pool *pool,
  *
  * Caller must provide appropriate safe context.
  */
-static bool __page_pool_recycle_direct(struct page *page,
+static bool page_pool_recycle_in_cache(struct page *page,
 				       struct page_pool *pool)
 {
 	if (unlikely(pool->alloc.count == PP_ALLOC_CACHE_SIZE))
@@ -357,8 +354,14 @@ static bool pool_page_reusable(struct page_pool *pool, struct page *page)
 	return !page_is_pfmemalloc(page);
 }
 
-void __page_pool_put_page(struct page_pool *pool, struct page *page,
-			  unsigned int dma_sync_size, bool allow_direct)
+/* If the page refcnt == 1, this will try to recycle the page.
+ * if PP_FLAG_DMA_SYNC_DEV is set, we'll try to sync the DMA area for
+ * the configured size min(dma_sync_size, pool->max_len).
+ * If the page refcnt != 1, then the page will be returned to memory
+ * subsystem.
+ */
+void page_pool_put_page(struct page_pool *pool, struct page *page,
+			unsigned int dma_sync_size, bool allow_direct)
 {
 	/* This allocator is optimized for the XDP mode that uses
 	 * one-frame-per-page, but have fallbacks that act like the
@@ -375,12 +378,12 @@ void __page_pool_put_page(struct page_pool *pool, struct page *page,
 						      dma_sync_size);
 
 		if (allow_direct && in_serving_softirq())
-			if (__page_pool_recycle_direct(page, pool))
+			if (page_pool_recycle_in_cache(page, pool))
 				return;
 
-		if (!__page_pool_recycle_into_ring(pool, page)) {
+		if (!page_pool_recycle_in_ring(pool, page)) {
 			/* Cache full, fallback to free pages */
-			__page_pool_return_page(pool, page);
+			page_pool_return_page(pool, page);
 		}
 		return;
 	}
@@ -397,12 +400,13 @@ void __page_pool_put_page(struct page_pool *pool, struct page *page,
 	 * doing refcnt based recycle tricks, meaning another process
 	 * will be invoking put_page.
 	 */
-	__page_pool_clean_page(pool, page);
+	/* Do not replace this with page_pool_return_page() */
+	page_pool_release_page(pool, page);
 	put_page(page);
 }
-EXPORT_SYMBOL(__page_pool_put_page);
+EXPORT_SYMBOL(page_pool_put_page);
 
-static void __page_pool_empty_ring(struct page_pool *pool)
+static void page_pool_empty_ring(struct page_pool *pool)
 {
 	struct page *page;
 
@@ -413,7 +417,7 @@ static void __page_pool_empty_ring(struct page_pool *pool)
 			pr_crit("%s() page_pool refcnt %d violation\n",
 				__func__, page_ref_count(page));
 
-		__page_pool_return_page(pool, page);
+		page_pool_return_page(pool, page);
 	}
 }
 
@@ -443,7 +447,7 @@ static void page_pool_empty_alloc_cache_once(struct page_pool *pool)
 	 */
 	while (pool->alloc.count) {
 		page = pool->alloc.cache[--pool->alloc.count];
-		__page_pool_return_page(pool, page);
+		page_pool_return_page(pool, page);
 	}
 }
 
@@ -455,7 +459,7 @@ static void page_pool_scrub(struct page_pool *pool)
 	/* No more consumers should exist, but producers could still
 	 * be in-flight.
 	 */
-	__page_pool_empty_ring(pool);
+	page_pool_empty_ring(pool);
 }
 
 static int page_pool_release(struct page_pool *pool)
@@ -529,7 +533,7 @@ void page_pool_update_nid(struct page_pool *pool, int new_nid)
 	/* Flush pool alloc cache, as refill will check NUMA node */
 	while (pool->alloc.count) {
 		page = pool->alloc.cache[--pool->alloc.count];
-		__page_pool_return_page(pool, page);
+		page_pool_return_page(pool, page);
 	}
 }
 EXPORT_SYMBOL(page_pool_update_nid);
diff --git a/net/core/xdp.c b/net/core/xdp.c
index 8310714c47fd..4c7ea85486af 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -372,7 +372,7 @@ static void __xdp_return(void *data, struct xdp_mem_info *mem, bool napi_direct,
 		xa = rhashtable_lookup(mem_id_ht, &mem->id, mem_id_rht_params);
 		page = virt_to_head_page(data);
 		napi_direct &= !xdp_return_frame_no_direct();
-		page_pool_put_page(xa->page_pool, page, napi_direct);
+		page_pool_put_full_page(xa->page_pool, page, napi_direct);
 		rcu_read_unlock();
 		break;
 	case MEM_TYPE_PAGE_SHARED:
-- 
2.25.1

