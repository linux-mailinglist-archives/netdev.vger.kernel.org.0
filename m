Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 712712CC502
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 19:26:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387815AbgLBSZI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 13:25:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730798AbgLBSZG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 13:25:06 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0391CC061A47
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 10:24:26 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id c9so2830549ybs.8
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 10:24:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=ejyBujW0lcuoHH5ZNBZnwgpG1YjtUm9xVpBh0a92UKw=;
        b=s+6bzsFX3SIerTyPedrq4kL0IdZwDqcTC52D13EEng2AaM/lW8lCJfpm5HkDcAuYNs
         shNGouwmt6+hZLVBiNb/Qw1owrHelyBLkyUKBT6y9Rs9LF8q/tcMKGUvQbz8etvqCNcd
         zflDCP+S5vPH1AU3R6fTunSVQac/HTpYt/i55GH4aBqaErvTWYOCfVLwLlFXwHDtAiZY
         JgZfvvQf7mIv+UfJR6p/Y8OiiZtmYLdwAl4YtrIR0EIzEnJBO+rXLnDMuuE6gC9TOAk0
         U1BWSdv7Igvqzln1qdcSsWtUqWnNgU8jwAIN+NyrKkPle+9N/AMxRBYKNDgtxHFuY1Ff
         Obzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ejyBujW0lcuoHH5ZNBZnwgpG1YjtUm9xVpBh0a92UKw=;
        b=SKLyFvHgpyHvmklUDle9BbKGVR5XsHlWpVGHZlxarkimdjx0z80MIzexhQCl5UD5gi
         DPJTEu7tzXM2P0kFHqskcOtdD864VVtF0VYojcR2PJi/UMIDdZ/8y7KC/4eoxOAq4Mp9
         FZTrHqCLN9/cspiaAsHjfO+KhTahr6FB87Yoo0+tEbZIe/tYyJ6W8/oxbh8kaOAONP3z
         OYEkkkYpDBBgpTfXIrqt03iNg3XDTUvF9/j/U/JNaCOEL4aX04woBvNzstXoFIVB5evI
         enejkYSpE8azLH9WIz9X/WA+IRiLk7M4x7+V5+5e6fVyExPWloO7J127nyxM3K33pDxA
         H9Mw==
X-Gm-Message-State: AOAM530kNUcl6yF3//0ge4nDavyEUbq47k7MxxFizguuchzniY5P5uya
        xw6j89pz1oTKwtiMjaiNL0Q1EZ40CxMILYKV7QYlKAqUE020u8yJrQUiPjBS9LJRiRGTw9zcskx
        gqaVTALtFsYNBQJOxidK95r/9W8iEpel/PgT5Z9xZqZoBa6oaUTFhYHhZ0WRm3WMLx7jVkExC
X-Google-Smtp-Source: ABdhPJzuLdwcAlftxsKZnIhdhDO+jWyMaHZ5THOeFOlNtBgJcPCpgbUBI4+z/W5fEpx0jZsvkAEt+tQusKkaEQUi
Sender: "awogbemila via sendgmr" <awogbemila@awogbemila.sea.corp.google.com>
X-Received: from awogbemila.sea.corp.google.com ([2620:15c:100:202:1ea0:b8ff:fe73:6cc0])
 (user=awogbemila job=sendgmr) by 2002:a25:830e:: with SMTP id
 s14mr5664802ybk.213.1606933465198; Wed, 02 Dec 2020 10:24:25 -0800 (PST)
Date:   Wed,  2 Dec 2020 10:24:13 -0800
In-Reply-To: <20201202182413.232510-1-awogbemila@google.com>
Message-Id: <20201202182413.232510-5-awogbemila@google.com>
Mime-Version: 1.0
References: <20201202182413.232510-1-awogbemila@google.com>
X-Mailer: git-send-email 2.29.2.576.ga3fc446d84-goog
Subject: [PATCH net-next v9 4/4] gve: Add support for raw addressing in the tx path
From:   David Awogbemila <awogbemila@google.com>
To:     netdev@vger.kernel.org
Cc:     alexander.duyck@gmail.com, saeed@kernel.org,
        eric.dumazet@gmail.com, Catherine Sullivan <csully@google.com>,
        Yangchun Fu <yangchun@google.com>,
        David Awogbemila <awogbemila@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Catherine Sullivan <csully@google.com>

During TX, skbs' data addresses are dma_map'ed and passed to the NIC.
This means that the device can perform DMA directly from these addresses
and the driver does not have to copy the buffer content into
pre-allocated buffers/qpls (as in qpl mode).

Reviewed-by: Yangchun Fu <yangchun@google.com>
Signed-off-by: Catherine Sullivan <csully@google.com>
Signed-off-by: David Awogbemila <awogbemila@google.com>
---
 drivers/net/ethernet/google/gve/gve.h         |  16 +-
 drivers/net/ethernet/google/gve/gve_adminq.c  |   4 +-
 drivers/net/ethernet/google/gve/gve_desc.h    |   8 +-
 drivers/net/ethernet/google/gve/gve_ethtool.c |   2 +
 drivers/net/ethernet/google/gve/gve_tx.c      | 197 ++++++++++++++----
 5 files changed, 185 insertions(+), 42 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
index 8aad4af2aa2b..9888fa92be86 100644
--- a/drivers/net/ethernet/google/gve/gve.h
+++ b/drivers/net/ethernet/google/gve/gve.h
@@ -112,12 +112,20 @@ struct gve_tx_iovec {
 	u32 iov_padding; /* padding associated with this segment */
 };
 
+struct gve_tx_dma_buf {
+	DEFINE_DMA_UNMAP_ADDR(dma);
+	DEFINE_DMA_UNMAP_LEN(len);
+};
+
 /* Tracks the memory in the fifo occupied by the skb. Mapped 1:1 to a desc
  * ring entry but only used for a pkt_desc not a seg_desc
  */
 struct gve_tx_buffer_state {
 	struct sk_buff *skb; /* skb for this pkt */
-	struct gve_tx_iovec iov[GVE_TX_MAX_IOVEC]; /* segments of this pkt */
+	union {
+		struct gve_tx_iovec iov[GVE_TX_MAX_IOVEC]; /* segments of this pkt */
+		struct gve_tx_dma_buf buf;
+	};
 };
 
 /* A TX buffer - each queue has one */
@@ -140,19 +148,23 @@ struct gve_tx_ring {
 	__be32 last_nic_done ____cacheline_aligned; /* NIC tail pointer */
 	u64 pkt_done; /* free-running - total packets completed */
 	u64 bytes_done; /* free-running - total bytes completed */
+	u32 dropped_pkt; /* free-running - total packets dropped */
 
 	/* Cacheline 2 -- Read-mostly fields */
 	union gve_tx_desc *desc ____cacheline_aligned;
 	struct gve_tx_buffer_state *info; /* Maps 1:1 to a desc */
 	struct netdev_queue *netdev_txq;
 	struct gve_queue_resources *q_resources; /* head and tail pointer idx */
+	struct device *dev;
 	u32 mask; /* masks req and done down to queue size */
+	u8 raw_addressing; /* use raw_addressing? */
 
 	/* Slow-path fields */
 	u32 q_num ____cacheline_aligned; /* queue idx */
 	u32 stop_queue; /* count of queue stops */
 	u32 wake_queue; /* count of queue wakes */
 	u32 ntfy_id; /* notification block index */
+	u32 dma_mapping_error; /* count of dma mapping errors */
 	dma_addr_t bus; /* dma address of the descr ring */
 	dma_addr_t q_resources_bus; /* dma address of the queue resources */
 	struct u64_stats_sync statss; /* sync stats for 32bit archs */
@@ -442,7 +454,7 @@ static inline u32 gve_rx_idx_to_ntfy(struct gve_priv *priv, u32 queue_idx)
  */
 static inline u32 gve_num_tx_qpls(struct gve_priv *priv)
 {
-	return priv->tx_cfg.num_queues;
+	return priv->raw_addressing ? 0 : priv->tx_cfg.num_queues;
 }
 
 /* Returns the number of rx queue page lists
diff --git a/drivers/net/ethernet/google/gve/gve_adminq.c b/drivers/net/ethernet/google/gve/gve_adminq.c
index a1b9370db1e4..53864f200599 100644
--- a/drivers/net/ethernet/google/gve/gve_adminq.c
+++ b/drivers/net/ethernet/google/gve/gve_adminq.c
@@ -369,8 +369,10 @@ static int gve_adminq_create_tx_queue(struct gve_priv *priv, u32 queue_index)
 {
 	struct gve_tx_ring *tx = &priv->tx[queue_index];
 	union gve_adminq_command cmd;
+	u32 qpl_id;
 	int err;
 
+	qpl_id = priv->raw_addressing ? GVE_RAW_ADDRESSING_QPL_ID : tx->tx_fifo.qpl->id;
 	memset(&cmd, 0, sizeof(cmd));
 	cmd.opcode = cpu_to_be32(GVE_ADMINQ_CREATE_TX_QUEUE);
 	cmd.create_tx_queue = (struct gve_adminq_create_tx_queue) {
@@ -379,7 +381,7 @@ static int gve_adminq_create_tx_queue(struct gve_priv *priv, u32 queue_index)
 		.queue_resources_addr =
 			cpu_to_be64(tx->q_resources_bus),
 		.tx_ring_addr = cpu_to_be64(tx->bus),
-		.queue_page_list_id = cpu_to_be32(tx->tx_fifo.qpl->id),
+		.queue_page_list_id = cpu_to_be32(qpl_id),
 		.ntfy_id = cpu_to_be32(tx->ntfy_id),
 	};
 
diff --git a/drivers/net/ethernet/google/gve/gve_desc.h b/drivers/net/ethernet/google/gve/gve_desc.h
index a1c0aaa60139..05ae6300e984 100644
--- a/drivers/net/ethernet/google/gve/gve_desc.h
+++ b/drivers/net/ethernet/google/gve/gve_desc.h
@@ -16,9 +16,11 @@
  * Base addresses encoded in seg_addr are not assumed to be physical
  * addresses. The ring format assumes these come from some linear address
  * space. This could be physical memory, kernel virtual memory, user virtual
- * memory. gVNIC uses lists of registered pages. Each queue is assumed
- * to be associated with a single such linear address space to ensure a
- * consistent meaning for seg_addrs posted to its rings.
+ * memory.
+ * If raw dma addressing is not supported then gVNIC uses lists of registered
+ * pages. Each queue is assumed to be associated with a single such linear
+ * address space to ensure a consistent meaning for seg_addrs posted to its
+ * rings.
  */
 
 struct gve_tx_pkt_desc {
diff --git a/drivers/net/ethernet/google/gve/gve_ethtool.c b/drivers/net/ethernet/google/gve/gve_ethtool.c
index 7b44769bd87c..07ec957ae091 100644
--- a/drivers/net/ethernet/google/gve/gve_ethtool.c
+++ b/drivers/net/ethernet/google/gve/gve_ethtool.c
@@ -50,6 +50,7 @@ static const char gve_gstrings_rx_stats[][ETH_GSTRING_LEN] = {
 static const char gve_gstrings_tx_stats[][ETH_GSTRING_LEN] = {
 	"tx_posted_desc[%u]", "tx_completed_desc[%u]", "tx_bytes[%u]",
 	"tx_wake[%u]", "tx_stop[%u]", "tx_event_counter[%u]",
+	"tx_dma_mapping_error[%u]",
 };
 
 static const char gve_gstrings_adminq_stats[][ETH_GSTRING_LEN] = {
@@ -322,6 +323,7 @@ gve_get_ethtool_stats(struct net_device *netdev,
 			data[i++] = tx->stop_queue;
 			data[i++] = be32_to_cpu(gve_tx_load_event_counter(priv,
 									  tx));
+			data[i++] = tx->dma_mapping_error;
 			/* stats from NIC */
 			if (skip_nic_stats) {
 				/* skip NIC tx stats */
diff --git a/drivers/net/ethernet/google/gve/gve_tx.c b/drivers/net/ethernet/google/gve/gve_tx.c
index d0244feb0301..6938f3a939d6 100644
--- a/drivers/net/ethernet/google/gve/gve_tx.c
+++ b/drivers/net/ethernet/google/gve/gve_tx.c
@@ -158,9 +158,11 @@ static void gve_tx_free_ring(struct gve_priv *priv, int idx)
 			  tx->q_resources, tx->q_resources_bus);
 	tx->q_resources = NULL;
 
-	gve_tx_fifo_release(priv, &tx->tx_fifo);
-	gve_unassign_qpl(priv, tx->tx_fifo.qpl->id);
-	tx->tx_fifo.qpl = NULL;
+	if (!tx->raw_addressing) {
+		gve_tx_fifo_release(priv, &tx->tx_fifo);
+		gve_unassign_qpl(priv, tx->tx_fifo.qpl->id);
+		tx->tx_fifo.qpl = NULL;
+	}
 
 	bytes = sizeof(*tx->desc) * slots;
 	dma_free_coherent(hdev, bytes, tx->desc, tx->bus);
@@ -206,11 +208,15 @@ static int gve_tx_alloc_ring(struct gve_priv *priv, int idx)
 	if (!tx->desc)
 		goto abort_with_info;
 
-	tx->tx_fifo.qpl = gve_assign_tx_qpl(priv);
+	tx->raw_addressing = priv->raw_addressing;
+	tx->dev = &priv->pdev->dev;
+	if (!tx->raw_addressing) {
+		tx->tx_fifo.qpl = gve_assign_tx_qpl(priv);
 
-	/* map Tx FIFO */
-	if (gve_tx_fifo_init(priv, &tx->tx_fifo))
-		goto abort_with_desc;
+		/* map Tx FIFO */
+		if (gve_tx_fifo_init(priv, &tx->tx_fifo))
+			goto abort_with_desc;
+	}
 
 	tx->q_resources =
 		dma_alloc_coherent(hdev,
@@ -228,7 +234,8 @@ static int gve_tx_alloc_ring(struct gve_priv *priv, int idx)
 	return 0;
 
 abort_with_fifo:
-	gve_tx_fifo_release(priv, &tx->tx_fifo);
+	if (!tx->raw_addressing)
+		gve_tx_fifo_release(priv, &tx->tx_fifo);
 abort_with_desc:
 	dma_free_coherent(hdev, bytes, tx->desc, tx->bus);
 	tx->desc = NULL;
@@ -301,27 +308,47 @@ static inline int gve_skb_fifo_bytes_required(struct gve_tx_ring *tx,
 	return bytes;
 }
 
-/* The most descriptors we could need are 3 - 1 for the headers, 1 for
- * the beginning of the payload at the end of the FIFO, and 1 if the
- * payload wraps to the beginning of the FIFO.
+/* The most descriptors we could need is MAX_SKB_FRAGS + 3 : 1 for each skb frag,
+ * +1 for the skb linear portion, +1 for when tcp hdr needs to be in separate descriptor,
+ * and +1 if the payload wraps to the beginning of the FIFO.
  */
-#define MAX_TX_DESC_NEEDED	3
+#define MAX_TX_DESC_NEEDED	(MAX_SKB_FRAGS + 3)
+static void gve_tx_unmap_buf(struct device *dev, struct gve_tx_buffer_state *info)
+{
+	if (info->skb) {
+		dma_unmap_single(dev, dma_unmap_addr(&info->buf, dma),
+				 dma_unmap_len(&info->buf, len),
+				 DMA_TO_DEVICE);
+		dma_unmap_len_set(&info->buf, len, 0);
+	} else {
+		dma_unmap_page(dev, dma_unmap_addr(&info->buf, dma),
+			       dma_unmap_len(&info->buf, len),
+			       DMA_TO_DEVICE);
+		dma_unmap_len_set(&info->buf, len, 0);
+	}
+}
 
 /* Check if sufficient resources (descriptor ring space, FIFO space) are
  * available to transmit the given number of bytes.
  */
 static inline bool gve_can_tx(struct gve_tx_ring *tx, int bytes_required)
 {
-	return (gve_tx_avail(tx) >= MAX_TX_DESC_NEEDED &&
-		gve_tx_fifo_can_alloc(&tx->tx_fifo, bytes_required));
+	bool can_alloc = true;
+
+	if (!tx->raw_addressing)
+		can_alloc = gve_tx_fifo_can_alloc(&tx->tx_fifo, bytes_required);
+
+	return (gve_tx_avail(tx) >= MAX_TX_DESC_NEEDED && can_alloc);
 }
 
 /* Stops the queue if the skb cannot be transmitted. */
 static int gve_maybe_stop_tx(struct gve_tx_ring *tx, struct sk_buff *skb)
 {
-	int bytes_required;
+	int bytes_required = 0;
+
+	if (!tx->raw_addressing)
+		bytes_required = gve_skb_fifo_bytes_required(tx, skb);
 
-	bytes_required = gve_skb_fifo_bytes_required(tx, skb);
 	if (likely(gve_can_tx(tx, bytes_required)))
 		return 0;
 
@@ -395,17 +422,13 @@ static void gve_dma_sync_for_device(struct device *dev, dma_addr_t *page_buses,
 {
 	u64 last_page = (iov_offset + iov_len - 1) / PAGE_SIZE;
 	u64 first_page = iov_offset / PAGE_SIZE;
-	dma_addr_t dma;
 	u64 page;
 
-	for (page = first_page; page <= last_page; page++) {
-		dma = page_buses[page];
-		dma_sync_single_for_device(dev, dma, PAGE_SIZE, DMA_TO_DEVICE);
-	}
+	for (page = first_page; page <= last_page; page++)
+		dma_sync_single_for_device(dev, page_buses[page], PAGE_SIZE, DMA_TO_DEVICE);
 }
 
-static int gve_tx_add_skb(struct gve_tx_ring *tx, struct sk_buff *skb,
-			  struct device *dev)
+static int gve_tx_add_skb_copy(struct gve_priv *priv, struct gve_tx_ring *tx, struct sk_buff *skb)
 {
 	int pad_bytes, hlen, hdr_nfrags, payload_nfrags, l4_hdr_offset;
 	union gve_tx_desc *pkt_desc, *seg_desc;
@@ -447,7 +470,7 @@ static int gve_tx_add_skb(struct gve_tx_ring *tx, struct sk_buff *skb,
 	skb_copy_bits(skb, 0,
 		      tx->tx_fifo.base + info->iov[hdr_nfrags - 1].iov_offset,
 		      hlen);
-	gve_dma_sync_for_device(dev, tx->tx_fifo.qpl->page_buses,
+	gve_dma_sync_for_device(&priv->pdev->dev, tx->tx_fifo.qpl->page_buses,
 				info->iov[hdr_nfrags - 1].iov_offset,
 				info->iov[hdr_nfrags - 1].iov_len);
 	copy_offset = hlen;
@@ -463,7 +486,7 @@ static int gve_tx_add_skb(struct gve_tx_ring *tx, struct sk_buff *skb,
 		skb_copy_bits(skb, copy_offset,
 			      tx->tx_fifo.base + info->iov[i].iov_offset,
 			      info->iov[i].iov_len);
-		gve_dma_sync_for_device(dev, tx->tx_fifo.qpl->page_buses,
+		gve_dma_sync_for_device(&priv->pdev->dev, tx->tx_fifo.qpl->page_buses,
 					info->iov[i].iov_offset,
 					info->iov[i].iov_len);
 		copy_offset += info->iov[i].iov_len;
@@ -472,6 +495,94 @@ static int gve_tx_add_skb(struct gve_tx_ring *tx, struct sk_buff *skb,
 	return 1 + payload_nfrags;
 }
 
+static int gve_tx_add_skb_no_copy(struct gve_priv *priv, struct gve_tx_ring *tx,
+				  struct sk_buff *skb)
+{
+	const struct skb_shared_info *shinfo = skb_shinfo(skb);
+	int hlen, payload_nfrags, l4_hdr_offset;
+	union gve_tx_desc *pkt_desc, *seg_desc;
+	struct gve_tx_buffer_state *info;
+	bool is_gso = skb_is_gso(skb);
+	u32 idx = tx->req & tx->mask;
+	struct gve_tx_dma_buf *buf;
+	u64 addr;
+	u32 len;
+	int i;
+
+	info = &tx->info[idx];
+	pkt_desc = &tx->desc[idx];
+
+	l4_hdr_offset = skb_checksum_start_offset(skb);
+	/* If the skb is gso, then we want only up to the tcp header in the first segment
+	 * to efficiently replicate on each segment otherwise we want the linear portion
+	 * of the skb (which will contain the checksum because skb->csum_start and
+	 * skb->csum_offset are given relative to skb->head) in the first segment.
+	 */
+	hlen = is_gso ? l4_hdr_offset + tcp_hdrlen(skb) : skb_headlen(skb);
+	len = skb_headlen(skb);
+
+	info->skb =  skb;
+
+	addr = dma_map_single(tx->dev, skb->data, len, DMA_TO_DEVICE);
+	if (unlikely(dma_mapping_error(tx->dev, addr))) {
+		tx->dma_mapping_error++;
+		goto drop;
+	}
+	buf = &info->buf;
+	dma_unmap_len_set(buf, len, len);
+	dma_unmap_addr_set(buf, dma, addr);
+
+	payload_nfrags = shinfo->nr_frags;
+	if (hlen < len) {
+		/* For gso the rest of the linear portion of the skb needs to
+		 * be in its own descriptor.
+		 */
+		payload_nfrags++;
+		gve_tx_fill_pkt_desc(pkt_desc, skb, is_gso, l4_hdr_offset,
+				     1 + payload_nfrags, hlen, addr);
+
+		len -= hlen;
+		addr += hlen;
+		idx = (tx->req + 1) & tx->mask;
+		seg_desc = &tx->desc[idx];
+		gve_tx_fill_seg_desc(seg_desc, skb, is_gso, len, addr);
+	} else {
+		gve_tx_fill_pkt_desc(pkt_desc, skb, is_gso, l4_hdr_offset,
+				     1 + payload_nfrags, hlen, addr);
+	}
+
+	for (i = 0; i < shinfo->nr_frags; i++) {
+		const skb_frag_t *frag = &shinfo->frags[i];
+
+		idx = (idx + 1) & tx->mask;
+		seg_desc = &tx->desc[idx];
+		len = skb_frag_size(frag);
+		addr = skb_frag_dma_map(tx->dev, frag, 0, len, DMA_TO_DEVICE);
+		if (unlikely(dma_mapping_error(tx->dev, addr))) {
+			tx->dma_mapping_error++;
+			goto unmap_drop;
+		}
+		buf = &tx->info[idx].buf;
+		tx->info[idx].skb = NULL;
+		dma_unmap_len_set(buf, len, len);
+		dma_unmap_addr_set(buf, dma, addr);
+
+		gve_tx_fill_seg_desc(seg_desc, skb, is_gso, len, addr);
+	}
+
+	return 1 + payload_nfrags;
+
+unmap_drop:
+	i += (payload_nfrags == shinfo->nr_frags ? 1 : 2);
+	while (i--) {
+		idx--;
+		gve_tx_unmap_buf(tx->dev, &tx->info[idx & tx->mask]);
+	}
+drop:
+	tx->dropped_pkt++;
+	return 0;
+}
+
 netdev_tx_t gve_tx(struct sk_buff *skb, struct net_device *dev)
 {
 	struct gve_priv *priv = netdev_priv(dev);
@@ -490,17 +601,26 @@ netdev_tx_t gve_tx(struct sk_buff *skb, struct net_device *dev)
 		gve_tx_put_doorbell(priv, tx->q_resources, tx->req);
 		return NETDEV_TX_BUSY;
 	}
-	nsegs = gve_tx_add_skb(tx, skb, &priv->pdev->dev);
-
-	netdev_tx_sent_queue(tx->netdev_txq, skb->len);
-	skb_tx_timestamp(skb);
-
-	/* give packets to NIC */
-	tx->req += nsegs;
+	if (tx->raw_addressing)
+		nsegs = gve_tx_add_skb_no_copy(priv, tx, skb);
+	else
+		nsegs = gve_tx_add_skb_copy(priv, tx, skb);
+
+	/* If the packet is getting sent, we need to update the skb */
+	if (nsegs) {
+		netdev_tx_sent_queue(tx->netdev_txq, skb->len);
+		skb_tx_timestamp(skb);
+		tx->req += nsegs;
+	} else {
+		dev_kfree_skb_any(skb);
+	}
 
 	if (!netif_xmit_stopped(tx->netdev_txq) && netdev_xmit_more())
 		return NETDEV_TX_OK;
 
+	/* Give packets to NIC. Even if this packet failed to send the doorbell
+	 * might need to be rung because of xmit_more.
+	 */
 	gve_tx_put_doorbell(priv, tx->q_resources, tx->req);
 	return NETDEV_TX_OK;
 }
@@ -525,24 +645,29 @@ static int gve_clean_tx_done(struct gve_priv *priv, struct gve_tx_ring *tx,
 		info = &tx->info[idx];
 		skb = info->skb;
 
+		/* Unmap the buffer */
+		if (tx->raw_addressing)
+			gve_tx_unmap_buf(tx->dev, info);
+		tx->done++;
 		/* Mark as free */
 		if (skb) {
 			info->skb = NULL;
 			bytes += skb->len;
 			pkts++;
 			dev_consume_skb_any(skb);
+			if (tx->raw_addressing)
+				continue;
 			/* FIFO free */
 			for (i = 0; i < ARRAY_SIZE(info->iov); i++) {
-				space_freed += info->iov[i].iov_len +
-					       info->iov[i].iov_padding;
+				space_freed += info->iov[i].iov_len + info->iov[i].iov_padding;
 				info->iov[i].iov_len = 0;
 				info->iov[i].iov_padding = 0;
 			}
 		}
-		tx->done++;
 	}
 
-	gve_tx_free_fifo(&tx->tx_fifo, space_freed);
+	if (!tx->raw_addressing)
+		gve_tx_free_fifo(&tx->tx_fifo, space_freed);
 	u64_stats_update_begin(&tx->statss);
 	tx->bytes_done += bytes;
 	tx->pkt_done += pkts;
-- 
2.29.2.576.ga3fc446d84-goog

