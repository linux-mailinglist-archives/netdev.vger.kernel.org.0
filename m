Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9291F2941F8
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 20:13:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408969AbgJTSNK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 14:13:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408962AbgJTSNE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 14:13:04 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F6D4C0613CE
        for <netdev@vger.kernel.org>; Tue, 20 Oct 2020 11:13:04 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id u24so1560807pfh.4
        for <netdev@vger.kernel.org>; Tue, 20 Oct 2020 11:13:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=bLdHyw9yyFYrB+wCMFmIAIhDsPNPkqwmgKiz9u0Imv8=;
        b=EqjdkIATBAqcm+Nqm2hhV9UNMLau+J5UKl9GF+h1agII6P+Ncn/PQfA0ymPAHIJ7BQ
         QeP6IeORTdn5Cg8PddwSZ78cFt+AjAL7qGa4bI3eL50IGOzvB7GKQYeKZ4MyqHdWNH7f
         i4TlCNxvsUwy6VxkmdSVm9eVvFfn6Jo8GSNoNNIlWRvkFOzRRsCb66Lue+0X+4DEPKAS
         MNxo2l4v3EC6RIdfrdIApMjUs2xIFJJnlsQKxDvfXDu6DfH7HEmcqlOvVRhmGpmsG2o5
         tu/a4UVb2Ec8fxeD7u1nGOJ0pVzRVaBq3f4y9VuD06wM6PSUCd1j6UD0RDdsWtO4/FU5
         0cog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=bLdHyw9yyFYrB+wCMFmIAIhDsPNPkqwmgKiz9u0Imv8=;
        b=FeSG1WvbRYJ/UZb7MHAlL2ibPkGss2ihRFfHYZa2KmwXUl7o6OLKzcvd0y0HBSBBLf
         EEpwbDaxBqxWHCioeAdizD5ya5jG3nIxrp2hQMnUuIU8sZOddrYyMvkU+Fd9aTnYSzeV
         Evn44Pf19rqyoA8mnlqI8+ci/QFsbHhgNlgt680DEMLB6KJWc+dTdeglGQ1Y8Q5mXAE4
         XtAAFK9zxCE1gclQIDLNZjELo0OmoXS0E7N1KFejLedrHb3dW0K3xBgvqEe3nZXeIvv2
         Z9JxIZ1Ms74ofgkdINYc3INmR6UhXiakr2l+Z4o+MpRfs+IhL97sGaiei4up4JX6qycS
         O5uw==
X-Gm-Message-State: AOAM533mymHku48J7lW26q0CgrAQaR331jUXgE394l/GQHr645Pk21YG
        DKQM75jYlr6BGzPKe8h5kLQ89UxXkv+E1bFuvQNGmoGZXlHhMieKw0UtacD7tIK/AUyWwh54K9V
        tcoqmqkPaVbY0aFP7YyGRN0sDpF4yk9PHh60LisQYR81ciasXBCNmOlN8JcS9207of5oNBF/r
X-Google-Smtp-Source: ABdhPJzR66bHrtKmPNTExsMz3k3HlrczGpI9Z/Kj98JAA0N4+/72KaMqUcLt8zc5XlsKgS3ntVXfFtaJU7+U+s2E
Sender: "awogbemila via sendgmr" <awogbemila@awogbemila.sea.corp.google.com>
X-Received: from awogbemila.sea.corp.google.com ([2620:15c:100:202:1ea0:b8ff:fe73:6cc0])
 (user=awogbemila job=sendgmr) by 2002:a17:902:23:b029:d5:b88a:c782 with SMTP
 id 32-20020a1709020023b02900d5b88ac782mr4080544pla.5.1603217583752; Tue, 20
 Oct 2020 11:13:03 -0700 (PDT)
Date:   Tue, 20 Oct 2020 11:12:52 -0700
In-Reply-To: <20201020181252.753330-1-awogbemila@google.com>
Message-Id: <20201020181252.753330-5-awogbemila@google.com>
Mime-Version: 1.0
References: <20201020181252.753330-1-awogbemila@google.com>
X-Mailer: git-send-email 2.29.0.rc1.297.gfa9743e501-goog
Subject: [PATCH net-next v5 4/4] gve: Add support for raw addressing in the tx path
From:   David Awogbemila <awogbemila@google.com>
To:     netdev@vger.kernel.org
Cc:     Catherine Sullivan <csully@google.com>,
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
 drivers/net/ethernet/google/gve/gve.h        |  18 +-
 drivers/net/ethernet/google/gve/gve_adminq.c |   4 +-
 drivers/net/ethernet/google/gve/gve_desc.h   |   8 +-
 drivers/net/ethernet/google/gve/gve_tx.c     | 207 +++++++++++++++----
 4 files changed, 194 insertions(+), 43 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
index 9cce2b356235..2d87d67718e4 100644
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
@@ -140,13 +148,16 @@ struct gve_tx_ring {
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
+	bool raw_addressing; /* use raw_addressing? */
 
 	/* Slow-path fields */
 	u32 q_num ____cacheline_aligned; /* queue idx */
@@ -442,7 +453,10 @@ static inline u32 gve_rx_idx_to_ntfy(struct gve_priv *priv, u32 queue_idx)
  */
 static inline u32 gve_num_tx_qpls(struct gve_priv *priv)
 {
-	return priv->tx_cfg.num_queues;
+	if (priv->raw_addressing)
+		return 0;
+	else
+		return priv->tx_cfg.num_queues;
 }
 
 /* Returns the number of rx queue page lists
diff --git a/drivers/net/ethernet/google/gve/gve_adminq.c b/drivers/net/ethernet/google/gve/gve_adminq.c
index 3a7a12b3d144..1b3715e21ae4 100644
--- a/drivers/net/ethernet/google/gve/gve_adminq.c
+++ b/drivers/net/ethernet/google/gve/gve_adminq.c
@@ -318,8 +318,10 @@ static int gve_adminq_create_tx_queue(struct gve_priv *priv, u32 queue_index)
 {
 	struct gve_tx_ring *tx = &priv->tx[queue_index];
 	union gve_adminq_command cmd;
+	u32 qpl_id;
 	int err;
 
+	qpl_id = priv->raw_addressing ? GVE_RAW_ADDRESSING_QPL_ID : tx->tx_fifo.qpl->id;
 	memset(&cmd, 0, sizeof(cmd));
 	cmd.opcode = cpu_to_be32(GVE_ADMINQ_CREATE_TX_QUEUE);
 	cmd.create_tx_queue = (struct gve_adminq_create_tx_queue) {
@@ -328,7 +330,7 @@ static int gve_adminq_create_tx_queue(struct gve_priv *priv, u32 queue_index)
 		.queue_resources_addr =
 			cpu_to_be64(tx->q_resources_bus),
 		.tx_ring_addr = cpu_to_be64(tx->bus),
-		.queue_page_list_id = cpu_to_be32(tx->tx_fifo.qpl->id),
+		.queue_page_list_id = cpu_to_be32(qpl_id),
 		.ntfy_id = cpu_to_be32(tx->ntfy_id),
 	};
 
diff --git a/drivers/net/ethernet/google/gve/gve_desc.h b/drivers/net/ethernet/google/gve/gve_desc.h
index 0aad314aefaf..a7da364e81c8 100644
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
diff --git a/drivers/net/ethernet/google/gve/gve_tx.c b/drivers/net/ethernet/google/gve/gve_tx.c
index d0244feb0301..b7935ded1736 100644
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
 
@@ -390,22 +417,22 @@ static void gve_tx_fill_seg_desc(union gve_tx_desc *seg_desc,
 	seg_desc->seg.seg_addr = cpu_to_be64(addr);
 }
 
-static void gve_dma_sync_for_device(struct device *dev, dma_addr_t *page_buses,
+static void gve_dma_sync_for_device(struct gve_priv *priv,
+				    dma_addr_t *page_buses,
 				    u64 iov_offset, u64 iov_len)
 {
 	u64 last_page = (iov_offset + iov_len - 1) / PAGE_SIZE;
 	u64 first_page = iov_offset / PAGE_SIZE;
-	dma_addr_t dma;
 	u64 page;
 
 	for (page = first_page; page <= last_page; page++) {
-		dma = page_buses[page];
-		dma_sync_single_for_device(dev, dma, PAGE_SIZE, DMA_TO_DEVICE);
+		dma_addr_t dma = page_buses[page];
+
+		dma_sync_single_for_device(&priv->pdev->dev, dma, PAGE_SIZE, DMA_TO_DEVICE);
 	}
 }
 
-static int gve_tx_add_skb(struct gve_tx_ring *tx, struct sk_buff *skb,
-			  struct device *dev)
+static int gve_tx_add_skb_copy(struct gve_priv *priv, struct gve_tx_ring *tx, struct sk_buff *skb)
 {
 	int pad_bytes, hlen, hdr_nfrags, payload_nfrags, l4_hdr_offset;
 	union gve_tx_desc *pkt_desc, *seg_desc;
@@ -429,7 +456,7 @@ static int gve_tx_add_skb(struct gve_tx_ring *tx, struct sk_buff *skb,
 	hlen = is_gso ? l4_hdr_offset + tcp_hdrlen(skb) :
 			skb_headlen(skb);
 
-	info->skb =  skb;
+	info->skb = skb;
 	/* We don't want to split the header, so if necessary, pad to the end
 	 * of the fifo and then put the header at the beginning of the fifo.
 	 */
@@ -447,7 +474,7 @@ static int gve_tx_add_skb(struct gve_tx_ring *tx, struct sk_buff *skb,
 	skb_copy_bits(skb, 0,
 		      tx->tx_fifo.base + info->iov[hdr_nfrags - 1].iov_offset,
 		      hlen);
-	gve_dma_sync_for_device(dev, tx->tx_fifo.qpl->page_buses,
+	gve_dma_sync_for_device(priv, tx->tx_fifo.qpl->page_buses,
 				info->iov[hdr_nfrags - 1].iov_offset,
 				info->iov[hdr_nfrags - 1].iov_len);
 	copy_offset = hlen;
@@ -463,7 +490,7 @@ static int gve_tx_add_skb(struct gve_tx_ring *tx, struct sk_buff *skb,
 		skb_copy_bits(skb, copy_offset,
 			      tx->tx_fifo.base + info->iov[i].iov_offset,
 			      info->iov[i].iov_len);
-		gve_dma_sync_for_device(dev, tx->tx_fifo.qpl->page_buses,
+		gve_dma_sync_for_device(priv, tx->tx_fifo.qpl->page_buses,
 					info->iov[i].iov_offset,
 					info->iov[i].iov_len);
 		copy_offset += info->iov[i].iov_len;
@@ -472,6 +499,98 @@ static int gve_tx_add_skb(struct gve_tx_ring *tx, struct sk_buff *skb,
 	return 1 + payload_nfrags;
 }
 
+static int gve_tx_add_skb_no_copy(struct gve_priv *priv, struct gve_tx_ring *tx,
+				  struct sk_buff *skb)
+{
+	const struct skb_shared_info *shinfo = skb_shinfo(skb);
+	int hlen, payload_nfrags, l4_hdr_offset, seg_idx_bias;
+	union gve_tx_desc *pkt_desc, *seg_desc;
+	struct gve_tx_buffer_state *info;
+	bool is_gso = skb_is_gso(skb);
+	u32 idx = tx->req & tx->mask;
+	struct gve_tx_dma_buf *buf;
+	int last_mapped = 0;
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
+	hlen = is_gso ? l4_hdr_offset + tcp_hdrlen(skb) :
+			skb_headlen(skb);
+	len = skb_headlen(skb);
+
+	info->skb =  skb;
+
+	addr = dma_map_single(tx->dev, skb->data, len, DMA_TO_DEVICE);
+	if (unlikely(dma_mapping_error(tx->dev, addr))) {
+		priv->dma_mapping_error++;
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
+		seg_desc = &tx->desc[(tx->req + 1) & tx->mask];
+		seg_idx_bias = 2;
+		gve_tx_fill_seg_desc(seg_desc, skb, is_gso, len, addr);
+	} else {
+		seg_idx_bias = 1;
+		gve_tx_fill_pkt_desc(pkt_desc, skb, is_gso, l4_hdr_offset,
+				     1 + payload_nfrags, hlen, addr);
+	}
+	idx = (tx->req + seg_idx_bias) & tx->mask;
+
+	for (i = 0; i < payload_nfrags - (seg_idx_bias - 1); i++) {
+		const skb_frag_t *frag = &shinfo->frags[i];
+
+		seg_desc = &tx->desc[idx];
+		len = skb_frag_size(frag);
+		addr = skb_frag_dma_map(tx->dev, frag, 0, len, DMA_TO_DEVICE);
+		if (unlikely(dma_mapping_error(tx->dev, addr))) {
+			priv->dma_mapping_error++;
+			goto unmap_drop;
+		}
+		buf = &tx->info[idx].buf;
+		tx->info[idx].skb = NULL;
+		dma_unmap_len_set(buf, len, len);
+		dma_unmap_addr_set(buf, dma, addr);
+
+		gve_tx_fill_seg_desc(seg_desc, skb, is_gso, len, addr);
+		idx = (idx + 1) & tx->mask;
+	}
+
+	return 1 + payload_nfrags;
+
+unmap_drop:
+	i--;
+	for (last_mapped = i + seg_idx_bias; last_mapped >= 0; last_mapped--) {
+		idx = (tx->req + last_mapped) & tx->mask;
+		gve_tx_unmap_buf(tx->dev, &tx->info[idx]);
+	}
+drop:
+	tx->dropped_pkt++;
+	return 0;
+}
+
 netdev_tx_t gve_tx(struct sk_buff *skb, struct net_device *dev)
 {
 	struct gve_priv *priv = netdev_priv(dev);
@@ -490,12 +609,20 @@ netdev_tx_t gve_tx(struct sk_buff *skb, struct net_device *dev)
 		gve_tx_put_doorbell(priv, tx->q_resources, tx->req);
 		return NETDEV_TX_BUSY;
 	}
-	nsegs = gve_tx_add_skb(tx, skb, &priv->pdev->dev);
-
-	netdev_tx_sent_queue(tx->netdev_txq, skb->len);
-	skb_tx_timestamp(skb);
+	if (tx->raw_addressing)
+		nsegs = gve_tx_add_skb_no_copy(priv, tx, skb);
+	else
+		nsegs = gve_tx_add_skb_copy(priv, tx, skb);
+
+	/* If the packet is getting sent, we need to update the skb */
+	if (nsegs) {
+		netdev_tx_sent_queue(tx->netdev_txq, skb->len);
+		skb_tx_timestamp(skb);
+	}
 
-	/* give packets to NIC */
+	/* Give packets to NIC. Even if this packet failed to send the doorbell
+	 * might need to be rung because of xmit_more.
+	 */
 	tx->req += nsegs;
 
 	if (!netif_xmit_stopped(tx->netdev_txq) && netdev_xmit_more())
@@ -525,24 +652,30 @@ static int gve_clean_tx_done(struct gve_priv *priv, struct gve_tx_ring *tx,
 		info = &tx->info[idx];
 		skb = info->skb;
 
+		/* Unmap the buffer */
+		if (tx->raw_addressing)
+			gve_tx_unmap_buf(tx->dev, info);
 		/* Mark as free */
 		if (skb) {
 			info->skb = NULL;
 			bytes += skb->len;
 			pkts++;
 			dev_consume_skb_any(skb);
-			/* FIFO free */
-			for (i = 0; i < ARRAY_SIZE(info->iov); i++) {
-				space_freed += info->iov[i].iov_len +
-					       info->iov[i].iov_padding;
-				info->iov[i].iov_len = 0;
-				info->iov[i].iov_padding = 0;
+			if (!tx->raw_addressing) {
+				/* FIFO free */
+				for (i = 0; i < ARRAY_SIZE(info->iov); i++) {
+					space_freed += info->iov[i].iov_len +
+						       info->iov[i].iov_padding;
+					info->iov[i].iov_len = 0;
+					info->iov[i].iov_padding = 0;
+				}
 			}
 		}
 		tx->done++;
 	}
 
-	gve_tx_free_fifo(&tx->tx_fifo, space_freed);
+	if (!tx->raw_addressing)
+		gve_tx_free_fifo(&tx->tx_fifo, space_freed);
 	u64_stats_update_begin(&tx->statss);
 	tx->bytes_done += bytes;
 	tx->pkt_done += pkts;
-- 
2.29.0.rc1.297.gfa9743e501-goog

