Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3229A2B8850
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 00:22:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbgKRXU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 18:20:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726300AbgKRXUZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 18:20:25 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D699C0613D4
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 15:20:25 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id a6so4872391ybi.0
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 15:20:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=MXTVgpW4x4MXB1N4LiuEFOyyBbgZlhqHPu9LGq5+68I=;
        b=qQ25IIdUhAUlmr6KliUTVyB7R8QKTF2c51jhxvm+KwspkTde8ja+kekqUiAL+fGJ33
         zTSfuQ5HvfcnMr8BXsoeudMhaC9ipNtOu1OkcWFymSmgR6qk/b8WOwlNff0YwmH/C0SR
         yh3nQf/15VjBRb1JBJeXMF50eHolwIsxcq++ndGj7dM6RQwRahdDooiZJL5ApYeW22Bm
         tIVM3+j3iXt6zooP+Ir3yEYWW1m+KWNOl6weFocpOQcuGqPSxgIbUGISIMZPUF65fhnV
         7UMKXvJ+7bwPYCTkX6/9NtaCSIDCxBGAAb8kWgjc06z4gR5TkwcdiqNQGCwlrd0NrGPL
         DyBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=MXTVgpW4x4MXB1N4LiuEFOyyBbgZlhqHPu9LGq5+68I=;
        b=CmOv9rjdaBcWmesscz2y2HX+fjJqcSe4h/YfMCe86lfF8Uktao79MPqfUB8bvLY+iv
         uuxumChM2zmln/Crc3QHEaEyzjweRljtyLrj3WDILPiXdCGCtj1uFG4Rzh19HPFhAASO
         g/qJoP4/qJ6Fkkkv9YvXE6V2nYTF/3gx4wGhO7C1TVtWPn0smhJXamyUXLPy+/xVPdnK
         sH00iPXx8NSSoa5andkqI5BC9zaotyF8IX03H/tJC5lEW4Hl4tiem8/I+o6fKb4okFBn
         Aoaps6LRdl6hZza96iuEub0hjgUTSMFNBsGRMfcNGtd66r1CpXDPbkelT5KNau8HU1SH
         Bs0g==
X-Gm-Message-State: AOAM531vkLcebvRQVw3wXd48amLliudDQX2hNLsRduLlzSlqByHn6gIR
        lejMt5yfVHLo7FQQe0L2gUaSwOhYGl9t5oJ+Zy0+UcObjPwdyPJyCeX/DokgnH1Ng2zoVzr6DlS
        zc0zZdo0Vjdwnkn0g8sVSvoQYxJ3jbMTJL07dMprLHMFx6N/8DCdzvyqgWvJB9I271N736w4k
X-Google-Smtp-Source: ABdhPJzZ0wqbCce4Gfgso2gEzAFl+F6/5iasSzbsXR7iNzGc0muxsPv8ZlBsZCYwtFSPBvBeB3qsdrQayFdSCybZ
Sender: "awogbemila via sendgmr" <awogbemila@awogbemila.sea.corp.google.com>
X-Received: from awogbemila.sea.corp.google.com ([2620:15c:100:202:1ea0:b8ff:fe73:6cc0])
 (user=awogbemila job=sendgmr) by 2002:a05:6902:6a7:: with SMTP id
 j7mr9095653ybt.462.1605741624322; Wed, 18 Nov 2020 15:20:24 -0800 (PST)
Date:   Wed, 18 Nov 2020 15:20:13 -0800
In-Reply-To: <20201118232014.2910642-1-awogbemila@google.com>
Message-Id: <20201118232014.2910642-4-awogbemila@google.com>
Mime-Version: 1.0
References: <20201118232014.2910642-1-awogbemila@google.com>
X-Mailer: git-send-email 2.29.2.299.gdc1121823c-goog
Subject: [PATCH net-next v7 3/4] gve: Rx Buffer Recycling
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
 drivers/net/ethernet/google/gve/gve_rx.c | 198 +++++++++++++++--------
 2 files changed, 134 insertions(+), 74 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
index d8bba0ba34e3..8aad4af2aa2b 100644
--- a/drivers/net/ethernet/google/gve/gve.h
+++ b/drivers/net/ethernet/google/gve/gve.h
@@ -52,6 +52,7 @@ struct gve_rx_slot_page_info {
 	struct page *page;
 	void *page_address;
 	u8 page_offset; /* flipped to second half? */
+	u8 can_flip;
 };
 
 /* A list of pages registered with the device during setup and used by a queue
@@ -502,15 +503,6 @@ static inline enum dma_data_direction gve_qpl_dma_dir(struct gve_priv *priv,
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
index ff395a6564f8..36bdeed2e691 100644
--- a/drivers/net/ethernet/google/gve/gve_rx.c
+++ b/drivers/net/ethernet/google/gve/gve_rx.c
@@ -279,8 +279,7 @@ static enum pkt_hash_types gve_rss_type(__be16 pkt_flags)
 	return PKT_HASH_TYPE_L2;
 }
 
-static struct sk_buff *gve_rx_copy(struct gve_rx_ring *rx,
-				   struct net_device *dev,
+static struct sk_buff *gve_rx_copy(struct net_device *dev,
 				   struct napi_struct *napi,
 				   struct gve_rx_slot_page_info *page_info,
 				   u16 len)
@@ -298,10 +297,6 @@ static struct sk_buff *gve_rx_copy(struct gve_rx_ring *rx,
 
 	skb->protocol = eth_type_trans(skb, dev);
 
-	u64_stats_update_begin(&rx->statss);
-	rx->rx_copied_pkt++;
-	u64_stats_update_end(&rx->statss);
-
 	return skb;
 }
 
@@ -330,6 +325,78 @@ static void gve_rx_flip_buff(struct gve_rx_slot_page_info *page_info, __be64 *sl
 	*(slot_addr) ^= offset;
 }
 
+static bool gve_rx_can_flip_buffers(struct net_device *netdev)
+{
+	return PAGE_SIZE == 4096
+		? netdev->mtu + GVE_RX_PAD + ETH_HLEN <= PAGE_SIZE / 2 : false;
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
+static struct sk_buff *
+gve_rx_raw_addressing(struct device *dev, struct net_device *netdev,
+		      struct gve_rx_slot_page_info *page_info, u16 len,
+		      struct napi_struct *napi,
+		      union gve_rx_data_slot *data_slot)
+{
+	struct sk_buff *skb = gve_rx_add_frags(napi, page_info, len);
+
+	if (!skb)
+		return NULL;
+
+	/* Optimistically stop the kernel from freeing the page by increasing
+	 * the page bias. We will check the refcount in refill to determine if
+	 * we need to alloc a new page.
+	 */
+	get_page(page_info->page);
+
+	return skb;
+}
+
+static struct sk_buff *
+gve_rx_qpl(struct device *dev, struct net_device *netdev,
+	   struct gve_rx_ring *rx, struct gve_rx_slot_page_info *page_info,
+	   u16 len, struct napi_struct *napi,
+	   union gve_rx_data_slot *data_slot)
+{
+	struct sk_buff *skb;
+
+	/* if raw_addressing mode is not enabled gvnic can only receive into
+	 * registered segments. If the buffer can't be recycled, our only
+	 * choice is to copy the data out of it so that we can return it to the
+	 * device.
+	 */
+	if (page_info->can_flip) {
+		skb = gve_rx_add_frags(napi, page_info, len);
+		/* No point in recycling if we didn't get the skb */
+		if (skb) {
+			/* Make sure that the page isn't freed. */
+			get_page(page_info->page);
+			gve_rx_flip_buff(page_info, &data_slot->qpl_offset);
+		}
+	} else {
+		skb = gve_rx_copy(netdev, napi, page_info, len);
+		if (skb) {
+			u64_stats_update_begin(&rx->statss);
+			rx->rx_copied_pkt++;
+			u64_stats_update_end(&rx->statss);
+		}
+	}
+	return skb;
+}
+
 static bool gve_rx(struct gve_rx_ring *rx, struct gve_rx_desc *rx_desc,
 		   netdev_features_t feat, u32 idx)
 {
@@ -340,7 +407,6 @@ static bool gve_rx(struct gve_rx_ring *rx, struct gve_rx_desc *rx_desc,
 	union gve_rx_data_slot *data_slot;
 	struct sk_buff *skb = NULL;
 	dma_addr_t page_bus;
-	int pagecount;
 	u16 len;
 
 	/* drop this packet */
@@ -361,60 +427,37 @@ static bool gve_rx(struct gve_rx_ring *rx, struct gve_rx_desc *rx_desc,
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
-		}
-		if (rx->data.raw_addressing) {
-			skb = gve_rx_add_frags(napi, page_info, len);
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
+	if (len <= priv->rx_copybreak) {
+		/* Just copy small packets */
+		skb = gve_rx_copy(dev, napi, page_info, len);
+		u64_stats_update_begin(&rx->statss);
+		rx->rx_copied_pkt++;
+		rx->rx_copybreak_pkt++;
+		u64_stats_update_end(&rx->statss);
+	} else {
+		u8 can_flip = gve_rx_can_flip_buffers(dev);
+		int recycle = 0;
+
+		if (can_flip) {
+			recycle = gve_rx_can_recycle_buffer(page_info->page);
+			if (recycle < 0) {
+				if (!rx->data.raw_addressing)
+					gve_schedule_reset(priv);
 				return false;
 			}
-			/* Make sure the kernel stack can't release the page */
-			get_page(page_info->page);
-			/* "flip" to other packet buffer on this page */
-			gve_rx_flip_buff(page_info, &rx->data.data_ring[idx].qpl_offset);
-		} else if (pagecount >= 2) {
-			/* We have previously passed the other half of this
-			 * page up the stack, but it has not yet been freed.
-			 */
-			skb = gve_rx_copy(rx, dev, napi, page_info, len);
+		}
+
+		page_info->can_flip = can_flip && recycle;
+		if (rx->data.raw_addressing) {
+			skb = gve_rx_raw_addressing(&priv->pdev->dev, dev,
+						    page_info, len, napi,
+						    data_slot);
 		} else {
-			WARN(pagecount < 1, "Pagecount should never be < 1");
-			return false;
+			skb = gve_rx_qpl(&priv->pdev->dev, dev, rx,
+					 page_info, len, napi, data_slot);
 		}
-	} else {
-		if (rx->data.raw_addressing)
-			skb = gve_rx_add_frags(napi, page_info, len);
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
@@ -467,19 +510,44 @@ static bool gve_rx_refill_buffers(struct gve_priv *priv, struct gve_rx_ring *rx)
 
 	while (empty || ((fill_cnt & rx->mask) != (rx->cnt & rx->mask))) {
 		struct gve_rx_slot_page_info *page_info;
-		struct device *dev = &priv->pdev->dev;
-		union gve_rx_data_slot *data_slot;
 		u32 idx = fill_cnt & rx->mask;
 
 		page_info = &rx->data.page_info[idx];
-		data_slot = &rx->data.data_ring[idx];
-		gve_rx_free_buffer(dev, page_info, data_slot);
-		page_info->page = NULL;
-		if (gve_rx_alloc_buffer(priv, dev, page_info, data_slot)) {
-			u64_stats_update_begin(&rx->statss);
-			rx->rx_buf_alloc_fail++;
-			u64_stats_update_end(&rx->statss);
-			break;
+		if (page_info->can_flip) {
+			/* The other half of the page is free because it was
+			 * free when we processed the descriptor. Flip to it.
+			 */
+			union gve_rx_data_slot *data_slot =
+						&rx->data.data_ring[idx];
+
+			gve_rx_flip_buff(page_info, &data_slot->addr);
+			page_info->can_flip = 0;
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
+				if (!rx->data.raw_addressing)
+					gve_schedule_reset(priv);
+				return false;
+			}
+			if (!recycle) {
+				/* We can't reuse the buffer - alloc a new one*/
+				union gve_rx_data_slot *data_slot =
+						&rx->data.data_ring[idx];
+				struct device *dev = &priv->pdev->dev;
+
+				gve_rx_free_buffer(dev, page_info, data_slot);
+				page_info->page = NULL;
+				if (gve_rx_alloc_buffer(priv, dev, page_info, data_slot))
+					break;
+			}
 		}
 		empty = false;
 		fill_cnt++;
-- 
2.29.2.299.gdc1121823c-goog

