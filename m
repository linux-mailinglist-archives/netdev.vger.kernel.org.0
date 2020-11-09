Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBDBD2AC96F
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 00:37:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731338AbgKIXhN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 18:37:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731300AbgKIXhM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 18:37:12 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5275C0613CF
        for <netdev@vger.kernel.org>; Mon,  9 Nov 2020 15:37:09 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id k7so12674410ybm.13
        for <netdev@vger.kernel.org>; Mon, 09 Nov 2020 15:37:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=N8vzLRcFiBb85BBzt95yvvNBdMhNjguXcz1//KWnQ8I=;
        b=WZRX9Z2LrgiioCDwS3IVIqisD20zsq6qgyLvG4l1oHxDRkA/0XW62LJkpJYe9eJj94
         jDPANvQzjbkST5x8fEKMzn96WiK6yvnHnvrMRCXwv2Qcs7qc+A9sRZm64V2jgHhP/v4T
         Bp8TeXOfzS56Clf4nwb5ZaXfLj1bDQDiO4REhvecSZJtpWZrTmRFBmcww/jeNDYiy7hT
         YU6rYaRWHLrEYTZfDl9bPUc2WUzVbk+hyYEAYMRRxBlt8Kaa8AXmu0aR5hmEs3NCVrDr
         D5MjD8yqMWhFS+F1oMuA1TjqE1JbiBJNIAYeQyvd89Z8nmTiYqPXSqFCTn5nCqvVhvFq
         6t0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=N8vzLRcFiBb85BBzt95yvvNBdMhNjguXcz1//KWnQ8I=;
        b=IerSRZxe+nKo/IGdcntunOuHi/a6lQ2kFw5A3keso8Kl/+Ofg94UfyGpvQ2iTsR07j
         LDHre74p+vKNvnceUBcbeipuIXhFvRGrTGiyIaKMp0oi5G0fQPzP3g1QTQOQbRLBgUsM
         Xy9k5E+cdrZJwOJ/vimfgxZBjIbLjp2a2/aMfilc158XmfKgNLCogTMdBCsp/cdLg82J
         rgKmHUcRUFtexQj/ur4ohgjbQSdrESXpKLmwe98AiJI44TCkZWJx90Kxcp4gHHhquylH
         +eT1t4H7uoaWdwiirjujH9tRxzoK6+Dakaak1Pf56vBP4f8VNT0leryRbkHitsqOT9qj
         +F5A==
X-Gm-Message-State: AOAM532jA2R+JVKTYB3a+SpysWOkAKrVfEDYDP+x9LLAsSQOjIXcAiNr
        dun0xU/Mi3hpgvxE+mLmyHtDl4S16lSB9Y8df1hcNGPXCzZIt71dXsFbKiUr6RuzJyAaQvoQqvs
        5EupuywTxAowHwbptzgutCFqrIVx6RYCnGjj1euYN+W6yIMNdSfwdNsNbKWRUW50Y8Gzys/cY
X-Google-Smtp-Source: ABdhPJyNQU7JnL8y+jptRB3tYTCJq5rSBdszHiXMSQZXOGUQySnlgxCc2Fw1i5es9AAIdJjS1o2+PMzb+5IsR3Oc
Sender: "awogbemila via sendgmr" <awogbemila@awogbemila.sea.corp.google.com>
X-Received: from awogbemila.sea.corp.google.com ([2620:15c:100:202:1ea0:b8ff:fe73:6cc0])
 (user=awogbemila job=sendgmr) by 2002:a25:4058:: with SMTP id
 n85mr1065588yba.69.1604965028913; Mon, 09 Nov 2020 15:37:08 -0800 (PST)
Date:   Mon,  9 Nov 2020 15:36:58 -0800
In-Reply-To: <20201109233659.1953461-1-awogbemila@google.com>
Message-Id: <20201109233659.1953461-4-awogbemila@google.com>
Mime-Version: 1.0
References: <20201109233659.1953461-1-awogbemila@google.com>
X-Mailer: git-send-email 2.29.2.222.g5d2a92d10f8-goog
Subject: [PATCH net-next v6 3/4] gve: Rx Buffer Recycling
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
 drivers/net/ethernet/google/gve/gve_rx.c | 196 +++++++++++++++--------
 2 files changed, 131 insertions(+), 75 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
index a8c589dd14e4..9dcf9fd8d128 100644
--- a/drivers/net/ethernet/google/gve/gve.h
+++ b/drivers/net/ethernet/google/gve/gve.h
@@ -50,6 +50,7 @@ struct gve_rx_slot_page_info {
 	struct page *page;
 	void *page_address;
 	u32 page_offset; /* offset to write to in page */
+	bool can_flip;
 };
 
 /* A list of pages registered with the device during setup and used by a queue
@@ -500,15 +501,6 @@ static inline enum dma_data_direction gve_qpl_dma_dir(struct gve_priv *priv,
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
index 49646caf930c..ff28581f4427 100644
--- a/drivers/net/ethernet/google/gve/gve_rx.c
+++ b/drivers/net/ethernet/google/gve/gve_rx.c
@@ -287,8 +287,7 @@ static enum pkt_hash_types gve_rss_type(__be16 pkt_flags)
 	return PKT_HASH_TYPE_L2;
 }
 
-static struct sk_buff *gve_rx_copy(struct gve_rx_ring *rx,
-				   struct net_device *dev,
+static struct sk_buff *gve_rx_copy(struct net_device *dev,
 				   struct napi_struct *napi,
 				   struct gve_rx_slot_page_info *page_info,
 				   u16 len)
@@ -306,10 +305,6 @@ static struct sk_buff *gve_rx_copy(struct gve_rx_ring *rx,
 
 	skb->protocol = eth_type_trans(skb, dev);
 
-	u64_stats_update_begin(&rx->statss);
-	rx->rx_copied_pkt++;
-	u64_stats_update_end(&rx->statss);
-
 	return skb;
 }
 
@@ -334,22 +329,90 @@ static void gve_rx_flip_buff(struct gve_rx_slot_page_info *page_info,
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
 
@@ -363,7 +426,6 @@ static bool gve_rx(struct gve_rx_ring *rx, struct gve_rx_desc *rx_desc,
 	struct gve_rx_data_slot *data_slot;
 	struct sk_buff *skb = NULL;
 	dma_addr_t page_bus;
-	int pagecount;
 	u16 len;
 
 	/* drop this packet */
@@ -384,64 +446,37 @@ static bool gve_rx(struct gve_rx_ring *rx, struct gve_rx_desc *rx_desc,
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
+				if (!rx->data.raw_addressing)
+					gve_schedule_reset(priv);
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
@@ -494,16 +529,45 @@ static bool gve_rx_refill_buffers(struct gve_priv *priv, struct gve_rx_ring *rx)
 
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
+				if (!rx->data.raw_addressing)
+					gve_schedule_reset(priv);
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
2.29.2.222.g5d2a92d10f8-goog

