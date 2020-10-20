Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7BC42941F6
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 20:13:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437337AbgJTSND (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 14:13:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437333AbgJTSNC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 14:13:02 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B8F1C0613D3
        for <netdev@vger.kernel.org>; Tue, 20 Oct 2020 11:13:02 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id x24so1532655pfi.18
        for <netdev@vger.kernel.org>; Tue, 20 Oct 2020 11:13:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=1lCWhWmWcJODaJWyb7OXpqA5JsVbTeGCYdmo0R9bH0U=;
        b=f260wvaR4toWgghVOoP5VTJHZlR6G0GOXCG6Yf910RwSpeMJUr98C1/WZe1X4q/1/Z
         SloCZ20MzKWBmFLBOXN8BHYyUd/IL+V6EHkyW94hv0aNds2r8PZV+Zgi538jE4Lrl58m
         H2pMQB/jxnbcP419Q+pNWIOggRGq+ts5Ba+sBFNgPKZrokTg6Fp0kaZE8pBnL7n4IJ3m
         GVWwM6betsSPaXoC0xnClbQQTN5Nmehuj1KMuyVVpYmkhxHkY0c8lGs+HFzZNzkuTg6C
         W498VTpzctQ6GPeqb0bHHu/4wVP6Wqcf2DZx67IikzC4fmeba5NSDb6T7FJtlCbxAIyn
         gvJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=1lCWhWmWcJODaJWyb7OXpqA5JsVbTeGCYdmo0R9bH0U=;
        b=KpqAtLsdz2USyIHHJoNO2WJH1k8E3DJFiEhNNnKUpAC96gGPMFJmBXXKu5b9SRPyrI
         nqkm14cKRoxkwJdY0lRsaMmQ0Qlwjsp+S7XN8XDzuKmF6/k4C4od4+1vPO6T0sG/t4Zp
         bEwuQ9DGE4Y1zWMsZ75/hKyA+g9XdoZ+clySL4AIaF9etwcS+4MSoYnHZNJYOVduyTSN
         mnGvLnpVdZW/9ZLrH7p6ZemtyPeHpIWpmTGgVbtV+3cepZA4AZe8dI06rPTJoR5OBYfq
         yasPTOjWdC+CjaNsQpPBpxfTJ4yS4bAYyYCqx0SEbeqxjqHLn7BbvcIlFo1GL9dA2VVV
         FLMw==
X-Gm-Message-State: AOAM532EQWZ2+63Ci5j2rk1hfofudC85pXDDwAmF1lzUYKBv/8WDKCpB
        Xu6o77aM4tlA73KIruav0rwDKyBwkEg5fc+yFMjQqEHrDuyrBoJ7cW/8XoEGEFAT7Vx98jc/5Mo
        BUk5z8ygAWptfYlLtYOi9l8d81hzPeoiNP/bRtnDgdmg92ari4UTpth3RWhF92QTe02GizUNg
X-Google-Smtp-Source: ABdhPJzboSkc6ELCEZhl42A9MGjmH5mExw6Cyh/au+wBtlCmdOnhXA1hoXB9X6gd2IeSgEApZKljj3iedonhaKv8
Sender: "awogbemila via sendgmr" <awogbemila@awogbemila.sea.corp.google.com>
X-Received: from awogbemila.sea.corp.google.com ([2620:15c:100:202:1ea0:b8ff:fe73:6cc0])
 (user=awogbemila job=sendgmr) by 2002:a62:1613:0:b029:152:743c:355c with SMTP
 id 19-20020a6216130000b0290152743c355cmr3918348pfw.15.1603217581741; Tue, 20
 Oct 2020 11:13:01 -0700 (PDT)
Date:   Tue, 20 Oct 2020 11:12:51 -0700
In-Reply-To: <20201020181252.753330-1-awogbemila@google.com>
Message-Id: <20201020181252.753330-4-awogbemila@google.com>
Mime-Version: 1.0
References: <20201020181252.753330-1-awogbemila@google.com>
X-Mailer: git-send-email 2.29.0.rc1.297.gfa9743e501-goog
Subject: [PATCH net-next v5 3/4] gve: Rx Buffer Recycling
From:   David Awogbemila <awogbemila@google.com>
To:     netdev@vger.kernel.org
Cc:     David Awogbemila <awogbemila@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch lets the driver reuse buffers that have been freed by the
networking stack.

In the raw addressing case, this allows the driver avoid allocating new
buffers.
In the qpl case, the driver can avoid copies.

Signed-off-by: David Awogbemila <awogbemila@google.com>
---
 drivers/net/ethernet/google/gve/gve.h    |  10 +-
 drivers/net/ethernet/google/gve/gve_rx.c | 194 +++++++++++++++--------
 2 files changed, 129 insertions(+), 75 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
index b853efb0b17f..9cce2b356235 100644
--- a/drivers/net/ethernet/google/gve/gve.h
+++ b/drivers/net/ethernet/google/gve/gve.h
@@ -50,6 +50,7 @@ struct gve_rx_slot_page_info {
 	struct page *page;
 	void *page_address;
 	u32 page_offset; /* offset to write to in page */
+	bool can_flip;
 };
 
 /* A list of pages registered with the device during setup and used by a queue
@@ -505,15 +506,6 @@ static inline enum dma_data_direction gve_qpl_dma_dir(struct gve_priv *priv,
 		return DMA_FROM_DEVICE;
 }
 
-/* Returns true if the max mtu allows page recycling */
-static inline bool gve_can_recycle_pages(struct net_device *dev)
-{
-	/* We can't recycle the pages if we can't fit a packet into half a
-	 * page.
-	 */
-	return dev->max_mtu <= PAGE_SIZE / 2;
-}
-
 /* buffers */
 int gve_alloc_page(struct gve_priv *priv, struct device *dev,
 		   struct page **page, dma_addr_t *dma,
diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
index 6d1ca6985eec..2e9d5c6fc411 100644
--- a/drivers/net/ethernet/google/gve/gve_rx.c
+++ b/drivers/net/ethernet/google/gve/gve_rx.c
@@ -270,8 +270,7 @@ static enum pkt_hash_types gve_rss_type(__be16 pkt_flags)
 	return PKT_HASH_TYPE_L2;
 }
 
-static struct sk_buff *gve_rx_copy(struct gve_rx_ring *rx,
-				   struct net_device *dev,
+static struct sk_buff *gve_rx_copy(struct net_device *dev,
 				   struct napi_struct *napi,
 				   struct gve_rx_slot_page_info *page_info,
 				   u16 len)
@@ -289,10 +288,6 @@ static struct sk_buff *gve_rx_copy(struct gve_rx_ring *rx,
 
 	skb->protocol = eth_type_trans(skb, dev);
 
-	u64_stats_update_begin(&rx->statss);
-	rx->rx_copied_pkt++;
-	u64_stats_update_end(&rx->statss);
-
 	return skb;
 }
 
@@ -338,22 +333,90 @@ static void gve_rx_flip_buff(struct gve_rx_slot_page_info *page_info,
 {
 	u64 addr = be64_to_cpu(data_ring->addr);
 
+	/* "flip" to other packet buffer on this page */
 	page_info->page_offset ^= PAGE_SIZE / 2;
 	addr ^= PAGE_SIZE / 2;
 	data_ring->addr = cpu_to_be64(addr);
 }
 
+static bool gve_rx_can_flip_buffers(struct net_device *netdev)
+{
+#if PAGE_SIZE == 4096
+	/* We can't flip a buffer if we can't fit a packet
+	 * into half a page.
+	 */
+	return netdev->mtu + GVE_RX_PAD + ETH_HLEN <= PAGE_SIZE / 2;
+#else
+	/* PAGE_SIZE != 4096 - don't try to reuse */
+	return false;
+#endif
+}
+
+static int gve_rx_can_recycle_buffer(struct page *page)
+{
+	int pagecount = page_count(page);
+
+	/* This page is not being used by any SKBs - reuse */
+	if (pagecount == 1)
+		return 1;
+	/* This page is still being used by an SKB - we can't reuse */
+	else if (pagecount >= 2)
+		return 0;
+	WARN(pagecount < 1, "Pagecount should never be < 1");
+	return -1;
+}
+
 static struct sk_buff *
 gve_rx_raw_addressing(struct device *dev, struct net_device *netdev,
 		      struct gve_rx_slot_page_info *page_info, u16 len,
 		      struct napi_struct *napi,
-		      struct gve_rx_data_slot *data_slot)
+		      struct gve_rx_data_slot *data_slot, bool can_flip)
 {
-	struct sk_buff *skb = gve_rx_add_frags(napi, page_info, len);
+	struct sk_buff *skb;
 
+	skb = gve_rx_add_frags(napi, page_info, len);
 	if (!skb)
 		return NULL;
 
+	/* Optimistically stop the kernel from freeing the page by increasing
+	 * the page bias. We will check the refcount in refill to determine if
+	 * we need to alloc a new page.
+	 */
+	get_page(page_info->page);
+	page_info->can_flip = can_flip;
+
+	return skb;
+}
+
+static struct sk_buff *
+gve_rx_qpl(struct device *dev, struct net_device *netdev,
+	   struct gve_rx_ring *rx, struct gve_rx_slot_page_info *page_info,
+	   u16 len, struct napi_struct *napi,
+	   struct gve_rx_data_slot *data_slot, bool recycle)
+{
+	struct sk_buff *skb;
+
+	/* if raw_addressing mode is not enabled gvnic can only receive into
+	 * registered segments. If the buffer can't be recycled, our only
+	 * choice is to copy the data out of it so that we can return it to the
+	 * device.
+	 */
+	if (recycle) {
+		skb = gve_rx_add_frags(napi, page_info, len);
+		/* No point in recycling if we didn't get the skb */
+		if (skb) {
+			/* Make sure the networking stack can't free the page */
+			get_page(page_info->page);
+			gve_rx_flip_buff(page_info, data_slot);
+		}
+	} else {
+		skb = gve_rx_copy(netdev, napi, page_info, len);
+		if (skb) {
+			u64_stats_update_begin(&rx->statss);
+			rx->rx_copied_pkt++;
+			u64_stats_update_end(&rx->statss);
+		}
+	}
 	return skb;
 }
 
@@ -367,7 +430,6 @@ static bool gve_rx(struct gve_rx_ring *rx, struct gve_rx_desc *rx_desc,
 	struct gve_rx_data_slot *data_slot;
 	struct sk_buff *skb = NULL;
 	dma_addr_t page_bus;
-	int pagecount;
 	u16 len;
 
 	/* drop this packet */
@@ -388,64 +450,36 @@ static bool gve_rx(struct gve_rx_ring *rx, struct gve_rx_desc *rx_desc,
 	dma_sync_single_for_cpu(&priv->pdev->dev, page_bus,
 				PAGE_SIZE, DMA_FROM_DEVICE);
 
-	if (PAGE_SIZE == 4096) {
-		if (len <= priv->rx_copybreak) {
-			/* Just copy small packets */
-			skb = gve_rx_copy(rx, dev, napi, page_info, len);
-			u64_stats_update_begin(&rx->statss);
-			rx->rx_copybreak_pkt++;
-			u64_stats_update_end(&rx->statss);
-			goto have_skb;
+	if (len <= priv->rx_copybreak) {
+		/* Just copy small packets */
+		skb = gve_rx_copy(dev, napi, page_info, len);
+		u64_stats_update_begin(&rx->statss);
+		rx->rx_copied_pkt++;
+		rx->rx_copybreak_pkt++;
+		u64_stats_update_end(&rx->statss);
+	} else {
+		bool can_flip = gve_rx_can_flip_buffers(dev);
+		int recycle = 0;
+
+		if (can_flip) {
+			recycle = gve_rx_can_recycle_buffer(page_info->page);
+			if (recycle < 0) {
+				gve_schedule_reset(priv);
+				return false;
+			}
 		}
 		if (rx->data.raw_addressing) {
 			skb = gve_rx_raw_addressing(&priv->pdev->dev, dev,
 						    page_info, len, napi,
-						     data_slot);
-			goto have_skb;
-		}
-		if (unlikely(!gve_can_recycle_pages(dev))) {
-			skb = gve_rx_copy(rx, dev, napi, page_info, len);
-			goto have_skb;
-		}
-		pagecount = page_count(page_info->page);
-		if (pagecount == 1) {
-			/* No part of this page is used by any SKBs; we attach
-			 * the page fragment to a new SKB and pass it up the
-			 * stack.
-			 */
-			skb = gve_rx_add_frags(napi, page_info, len);
-			if (!skb) {
-				u64_stats_update_begin(&rx->statss);
-				rx->rx_skb_alloc_fail++;
-				u64_stats_update_end(&rx->statss);
-				return false;
-			}
-			/* Make sure the kernel stack can't release the page */
-			get_page(page_info->page);
-			/* "flip" to other packet buffer on this page */
-			gve_rx_flip_buff(page_info, &rx->data.data_ring[idx]);
-		} else if (pagecount >= 2) {
-			/* We have previously passed the other half of this
-			 * page up the stack, but it has not yet been freed.
-			 */
-			skb = gve_rx_copy(rx, dev, napi, page_info, len);
+						    data_slot,
+						    can_flip && recycle);
 		} else {
-			WARN(pagecount < 1, "Pagecount should never be < 1");
-			return false;
+			skb = gve_rx_qpl(&priv->pdev->dev, dev, rx,
+					 page_info, len, napi, data_slot,
+					 can_flip && recycle);
 		}
-	} else {
-		if (rx->data.raw_addressing)
-			skb = gve_rx_raw_addressing(&priv->pdev->dev, dev,
-						    page_info, len, napi,
-						    data_slot);
-		else
-			skb = gve_rx_copy(rx, dev, napi, page_info, len);
 	}
 
-have_skb:
-	/* We didn't manage to allocate an skb but we haven't had any
-	 * reset worthy failures.
-	 */
 	if (!skb) {
 		u64_stats_update_begin(&rx->statss);
 		rx->rx_skb_alloc_fail++;
@@ -498,16 +532,44 @@ static bool gve_rx_refill_buffers(struct gve_priv *priv, struct gve_rx_ring *rx)
 
 	while (empty || ((fill_cnt & rx->mask) != (rx->cnt & rx->mask))) {
 		struct gve_rx_slot_page_info *page_info;
-		struct device *dev = &priv->pdev->dev;
-		struct gve_rx_data_slot *data_slot;
 		u32 idx = fill_cnt & rx->mask;
 
 		page_info = &rx->data.page_info[idx];
-		data_slot = &rx->data.data_ring[idx];
-		gve_rx_free_buffer(dev, page_info, data_slot);
-		page_info->page = NULL;
-		if (gve_rx_alloc_buffer(priv, dev, page_info, data_slot, rx))
-			break;
+		if (page_info->can_flip) {
+			/* The other half of the page is free because it was
+			 * free when we processed the descriptor. Flip to it.
+			 */
+			struct gve_rx_data_slot *data_slot =
+						&rx->data.data_ring[idx];
+
+			gve_rx_flip_buff(page_info, data_slot);
+			page_info->can_flip = false;
+		} else {
+			/* It is possible that the networking stack has already
+			 * finished processing all outstanding packets in the buffer
+			 * and it can be reused.
+			 * Flipping is unnecessary here - if the networking stack still
+			 * owns half the page it is impossible to tell which half. Either
+			 * the whole page is free or it needs to be replaced.
+			 */
+			int recycle = gve_rx_can_recycle_buffer(page_info->page);
+
+			if (recycle < 0) {
+				gve_schedule_reset(priv);
+				return false;
+			}
+			if (!recycle) {
+				/* We can't reuse the buffer - alloc a new one*/
+				struct gve_rx_data_slot *data_slot =
+						&rx->data.data_ring[idx];
+				struct device *dev = &priv->pdev->dev;
+
+				gve_rx_free_buffer(dev, page_info, data_slot);
+				page_info->page = NULL;
+				if (gve_rx_alloc_buffer(priv, dev, page_info, data_slot, rx))
+					break;
+			}
+		}
 		empty = false;
 		fill_cnt++;
 	}
-- 
2.29.0.rc1.297.gfa9743e501-goog

