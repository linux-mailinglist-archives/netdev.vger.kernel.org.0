Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30ADF2941F5
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 20:13:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408959AbgJTSND (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 14:13:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437331AbgJTSNB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 14:13:01 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E21B9C0613CE
        for <netdev@vger.kernel.org>; Tue, 20 Oct 2020 11:13:00 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id x34so1992708qvx.7
        for <netdev@vger.kernel.org>; Tue, 20 Oct 2020 11:13:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=8hagiknBBLu1jxtog/12zVbRdBwOhUzJs2S4ceWD7+I=;
        b=AaztTQObsHrIqPhU6JGFkwDtV1UZ9APFnJZBHUim6BtIwvKmcd/BsQDiUhRy/As4PP
         iskzooIa6clzCkJK+U1hz+XseVJxcdKbAOvcNLgZcdqJms0se/o8wyflV992XE2l0XPu
         7CCBN1hDybZOW/50GmD6eatN/8S0zVx3VH8zI/zqR85gN+8xQVYwpLp5HKDBXjJycxDN
         mTuwAGdwJBAs+3DaQeFKeB1zUYMHquUON5jM5oDIx+8rsltuSARipQFhFuFWkVIeJwxy
         5Tbo6nRBXUf6TyShPIxofA6ICGTzWX3apchs0gZ5tZCgheP3rFY0H0mKQgQUK8KVcs+t
         +MxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=8hagiknBBLu1jxtog/12zVbRdBwOhUzJs2S4ceWD7+I=;
        b=Q656CZcsNxxM4oMqJHJT1QUbWrkan7XdNS+OXF3hFjR138hfDp9oJpwNHkG7KSbV4r
         YCjDZ996Yaufuu8HzhDRUivyNVgVsevHthnyeACtfzJcMlC7/7lq0QrD6XDenbvBuF81
         pMTKhw8MuvuPN/gDWJYbF6cTd4WbAxQsnQFtOv80UuLNZH/MvIcUdEx7gxNJd2Ug1sXr
         8JZp6WrpVQY2ZvXawsUM0i1KywgFVibqWxoTBhnXv0UYicZ/UbFcjVW/X/m4+0cWg8Df
         X8sRTeg3DIKcj56n/oZOScJlu4jfwpszVLtadymoeInOGM2PsJ0KCph3loAksI2at33d
         TaJw==
X-Gm-Message-State: AOAM533m8DpdEJnGulBjlET3RDVsBPED09djULi7UiLTwpEt0KOhU3/G
        raEHqexbRTqy88yTWg5AlLxK1EVSS9Y31ZMC8ZiH3boKIIvjHSA2/Z+L2/2E0wJ+5D+TbAo1dIy
        M44mNJJTZdSFKKhHXuDImjTWUi3y+diOl+GRejXhhpRklELLoKEZr51XSojoB9UTOPVFNjt0G
X-Google-Smtp-Source: ABdhPJwMe9ZRORIXaA9EQXGY1n7PVINqIkNKKYDvDSQbPMP0SqR0kFYRqzY+zZr2No8Hj7yt9OdUc/EthmbjOSTK
Sender: "awogbemila via sendgmr" <awogbemila@awogbemila.sea.corp.google.com>
X-Received: from awogbemila.sea.corp.google.com ([2620:15c:100:202:1ea0:b8ff:fe73:6cc0])
 (user=awogbemila job=sendgmr) by 2002:a05:6214:1267:: with SMTP id
 r7mr4607510qvv.50.1603217579937; Tue, 20 Oct 2020 11:12:59 -0700 (PDT)
Date:   Tue, 20 Oct 2020 11:12:50 -0700
In-Reply-To: <20201020181252.753330-1-awogbemila@google.com>
Message-Id: <20201020181252.753330-3-awogbemila@google.com>
Mime-Version: 1.0
References: <20201020181252.753330-1-awogbemila@google.com>
X-Mailer: git-send-email 2.29.0.rc1.297.gfa9743e501-goog
Subject: [PATCH net-next v5 2/4] gve: Add support for raw addressing to the rx path
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

Add support to use raw dma addresses in the rx path. Due to this new
support we can alloc a new buffer instead of making a copy.

RX buffers are handed to the networking stack and are
re-allocated as needed, avoiding the need to use
skb_copy_to_linear_data() as in "qpl" mode.

Reviewed-by: Yangchun Fu <yangchun@google.com>
Signed-off-by: Catherine Sullivan <csully@google.com>
Signed-off-by: David Awogbemila <awogbemila@google.com>
---
 drivers/net/ethernet/google/gve/gve.h        |  11 +-
 drivers/net/ethernet/google/gve/gve_adminq.c |  14 +-
 drivers/net/ethernet/google/gve/gve_desc.h   |  10 +-
 drivers/net/ethernet/google/gve/gve_main.c   |   3 +-
 drivers/net/ethernet/google/gve/gve_rx.c     | 220 +++++++++++++++----
 5 files changed, 205 insertions(+), 53 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
index 80cdae06ee39..b853efb0b17f 100644
--- a/drivers/net/ethernet/google/gve/gve.h
+++ b/drivers/net/ethernet/google/gve/gve.h
@@ -68,6 +68,7 @@ struct gve_rx_data_queue {
 	dma_addr_t data_bus; /* dma mapping of the slots */
 	struct gve_rx_slot_page_info *page_info; /* page info of the buffers */
 	struct gve_queue_page_list *qpl; /* qpl assigned to this queue */
+	bool raw_addressing; /* use raw_addressing? */
 };
 
 struct gve_priv;
@@ -82,11 +83,14 @@ struct gve_rx_ring {
 	u32 cnt; /* free-running total number of completed packets */
 	u32 fill_cnt; /* free-running total number of descs and buffs posted */
 	u32 mask; /* masks the cnt and fill_cnt to the size of the ring */
+	u32 db_threshold; /* threshold for posting new buffs and descs */
 	u64 rx_copybreak_pkt; /* free-running count of copybreak packets */
 	u64 rx_copied_pkt; /* free-running total number of copied packets */
 	u64 rx_skb_alloc_fail; /* free-running count of skb alloc fails */
 	u64 rx_buf_alloc_fail; /* free-running count of buffer alloc fails */
 	u64 rx_desc_err_dropped_pkt; /* free-running count of packets dropped by descriptor error */
+	/* free-running count of packets dropped because of lack of buffer refill */
+	u64 rx_no_refill_dropped_pkt;
 	u32 q_num; /* queue index */
 	u32 ntfy_id; /* notification block index */
 	struct gve_queue_resources *q_resources; /* head and tail pointer idx */
@@ -194,7 +198,7 @@ struct gve_priv {
 	u16 tx_desc_cnt; /* num desc per ring */
 	u16 rx_desc_cnt; /* num desc per ring */
 	u16 tx_pages_per_qpl; /* tx buffer length */
-	u16 rx_pages_per_qpl; /* rx buffer length */
+	u16 rx_data_slot_cnt; /* rx buffer length */
 	u64 max_registered_pages;
 	u64 num_registered_pages; /* num pages registered with NIC */
 	u32 rx_copybreak; /* copy packets smaller than this */
@@ -444,7 +448,10 @@ static inline u32 gve_num_tx_qpls(struct gve_priv *priv)
  */
 static inline u32 gve_num_rx_qpls(struct gve_priv *priv)
 {
-	return priv->rx_cfg.num_queues;
+	if (priv->raw_addressing)
+		return 0;
+	else
+		return priv->rx_cfg.num_queues;
 }
 
 /* Returns a pointer to the next available tx qpl in the list of qpls
diff --git a/drivers/net/ethernet/google/gve/gve_adminq.c b/drivers/net/ethernet/google/gve/gve_adminq.c
index 0b7a2653fe33..3a7a12b3d144 100644
--- a/drivers/net/ethernet/google/gve/gve_adminq.c
+++ b/drivers/net/ethernet/google/gve/gve_adminq.c
@@ -357,8 +357,10 @@ static int gve_adminq_create_rx_queue(struct gve_priv *priv, u32 queue_index)
 {
 	struct gve_rx_ring *rx = &priv->rx[queue_index];
 	union gve_adminq_command cmd;
+	u32 qpl_id;
 	int err;
 
+	qpl_id = priv->raw_addressing ? GVE_RAW_ADDRESSING_QPL_ID : rx->data.qpl->id;
 	memset(&cmd, 0, sizeof(cmd));
 	cmd.opcode = cpu_to_be32(GVE_ADMINQ_CREATE_RX_QUEUE);
 	cmd.create_rx_queue = (struct gve_adminq_create_rx_queue) {
@@ -369,7 +371,7 @@ static int gve_adminq_create_rx_queue(struct gve_priv *priv, u32 queue_index)
 		.queue_resources_addr = cpu_to_be64(rx->q_resources_bus),
 		.rx_desc_ring_addr = cpu_to_be64(rx->desc.bus),
 		.rx_data_ring_addr = cpu_to_be64(rx->data.data_bus),
-		.queue_page_list_id = cpu_to_be32(rx->data.qpl->id),
+		.queue_page_list_id = cpu_to_be32(qpl_id),
 	};
 
 	err = gve_adminq_issue_cmd(priv, &cmd);
@@ -514,11 +516,11 @@ int gve_adminq_describe_device(struct gve_priv *priv)
 	mac = descriptor->mac;
 	dev_info(&priv->pdev->dev, "MAC addr: %pM\n", mac);
 	priv->tx_pages_per_qpl = be16_to_cpu(descriptor->tx_pages_per_qpl);
-	priv->rx_pages_per_qpl = be16_to_cpu(descriptor->rx_pages_per_qpl);
-	if (priv->rx_pages_per_qpl < priv->rx_desc_cnt) {
-		dev_err(&priv->pdev->dev, "rx_pages_per_qpl cannot be smaller than rx_desc_cnt, setting rx_desc_cnt down to %d.\n",
-			priv->rx_pages_per_qpl);
-		priv->rx_desc_cnt = priv->rx_pages_per_qpl;
+	priv->rx_data_slot_cnt = be16_to_cpu(descriptor->rx_pages_per_qpl);
+	if (priv->rx_data_slot_cnt < priv->rx_desc_cnt) {
+		dev_err(&priv->pdev->dev, "rx_data_slot_cnt cannot be smaller than rx_desc_cnt, setting rx_desc_cnt down to %d.\n",
+			priv->rx_data_slot_cnt);
+		priv->rx_desc_cnt = priv->rx_data_slot_cnt;
 	}
 	priv->default_num_queues = be16_to_cpu(descriptor->default_num_queues);
 	dev_opt = (void *)(descriptor + 1);
diff --git a/drivers/net/ethernet/google/gve/gve_desc.h b/drivers/net/ethernet/google/gve/gve_desc.h
index 54779871d52e..0aad314aefaf 100644
--- a/drivers/net/ethernet/google/gve/gve_desc.h
+++ b/drivers/net/ethernet/google/gve/gve_desc.h
@@ -72,12 +72,14 @@ struct gve_rx_desc {
 } __packed;
 static_assert(sizeof(struct gve_rx_desc) == 64);
 
-/* As with the Tx ring format, the qpl_offset entries below are offsets into an
- * ordered list of registered pages.
+/* If the device supports raw dma addressing then the addr in data slot is
+ * the dma address of the buffer.
+ * If the device only supports registered segments than the addr is a byte
+ * offset into the registered segment (an ordered list of pages) where the
+ * buffer is.
  */
 struct gve_rx_data_slot {
-	/* byte offset into the rx registered segment of this slot */
-	__be64 qpl_offset;
+	__be64 addr;
 };
 
 /* GVE Recive Packet Descriptor Seq No */
diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 70685c10db0e..225e17dd1ae5 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -596,6 +596,7 @@ int gve_alloc_page(struct gve_priv *priv, struct device *dev,
 	if (dma_mapping_error(dev, *dma)) {
 		priv->dma_mapping_error++;
 		put_page(*page);
+		*page = NULL;
 		return -ENOMEM;
 	}
 	return 0;
@@ -694,7 +695,7 @@ static int gve_alloc_qpls(struct gve_priv *priv)
 	}
 	for (; i < num_qpls; i++) {
 		err = gve_alloc_queue_page_list(priv, i,
-						priv->rx_pages_per_qpl);
+						priv->rx_data_slot_cnt);
 		if (err)
 			goto free_qpls;
 	}
diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
index 008fa897a3e6..6d1ca6985eec 100644
--- a/drivers/net/ethernet/google/gve/gve_rx.c
+++ b/drivers/net/ethernet/google/gve/gve_rx.c
@@ -16,12 +16,39 @@ static void gve_rx_remove_from_block(struct gve_priv *priv, int queue_idx)
 	block->rx = NULL;
 }
 
+static void gve_rx_free_buffer(struct device *dev,
+			       struct gve_rx_slot_page_info *page_info,
+			       struct gve_rx_data_slot *data_slot)
+{
+	dma_addr_t dma = (dma_addr_t)(be64_to_cpu(data_slot->addr) -
+				      page_info->page_offset);
+
+	gve_free_page(dev, page_info->page, dma, DMA_FROM_DEVICE);
+}
+
+static void gve_rx_unfill_pages(struct gve_priv *priv, struct gve_rx_ring *rx)
+{
+	u32 slots = rx->mask + 1;
+	int i;
+
+	if (rx->data.raw_addressing) {
+		for (i = 0; i < slots; i++)
+			gve_rx_free_buffer(&priv->pdev->dev, &rx->data.page_info[i],
+					   &rx->data.data_ring[i]);
+	} else {
+		gve_unassign_qpl(priv, rx->data.qpl->id);
+		rx->data.qpl = NULL;
+	}
+	kvfree(rx->data.page_info);
+	rx->data.page_info = NULL;
+}
+
 static void gve_rx_free_ring(struct gve_priv *priv, int idx)
 {
 	struct gve_rx_ring *rx = &priv->rx[idx];
 	struct device *dev = &priv->pdev->dev;
+	u32 slots = rx->mask + 1;
 	size_t bytes;
-	u32 slots;
 
 	gve_rx_remove_from_block(priv, idx);
 
@@ -33,11 +60,8 @@ static void gve_rx_free_ring(struct gve_priv *priv, int idx)
 			  rx->q_resources, rx->q_resources_bus);
 	rx->q_resources = NULL;
 
-	gve_unassign_qpl(priv, rx->data.qpl->id);
-	rx->data.qpl = NULL;
-	kvfree(rx->data.page_info);
+	gve_rx_unfill_pages(priv, rx);
 
-	slots = rx->mask + 1;
 	bytes = sizeof(*rx->data.data_ring) * slots;
 	dma_free_coherent(dev, bytes, rx->data.data_ring,
 			  rx->data.data_bus);
@@ -52,13 +76,14 @@ static void gve_setup_rx_buffer(struct gve_rx_slot_page_info *page_info,
 	page_info->page = page;
 	page_info->page_offset = 0;
 	page_info->page_address = page_address(page);
-	slot->qpl_offset = cpu_to_be64(addr);
+	slot->addr = cpu_to_be64(addr);
 }
 
 static int gve_prefill_rx_pages(struct gve_rx_ring *rx)
 {
 	struct gve_priv *priv = rx->gve;
 	u32 slots;
+	int err;
 	int i;
 
 	/* Allocate one page per Rx queue slot. Each page is split into two
@@ -71,12 +96,31 @@ static int gve_prefill_rx_pages(struct gve_rx_ring *rx)
 	if (!rx->data.page_info)
 		return -ENOMEM;
 
-	rx->data.qpl = gve_assign_rx_qpl(priv);
-
+	if (!rx->data.raw_addressing)
+		rx->data.qpl = gve_assign_rx_qpl(priv);
 	for (i = 0; i < slots; i++) {
-		struct page *page = rx->data.qpl->pages[i];
-		dma_addr_t addr = i * PAGE_SIZE;
+		struct page *page;
+		dma_addr_t addr;
+
+		if (rx->data.raw_addressing) {
+			err = gve_alloc_page(priv, &priv->pdev->dev, &page,
+					     &addr, DMA_FROM_DEVICE);
+			if (err) {
+				int j;
 
+				u64_stats_update_begin(&rx->statss);
+				rx->rx_buf_alloc_fail++;
+				u64_stats_update_end(&rx->statss);
+				for (j = 0; j < i; j++)
+					gve_rx_free_buffer(&priv->pdev->dev,
+							   &rx->data.page_info[j],
+							   &rx->data.data_ring[j]);
+				return err;
+			}
+		} else {
+			page = rx->data.qpl->pages[i];
+			addr = i * PAGE_SIZE;
+		}
 		gve_setup_rx_buffer(&rx->data.page_info[i],
 				    &rx->data.data_ring[i], addr, page);
 	}
@@ -110,8 +154,9 @@ static int gve_rx_alloc_ring(struct gve_priv *priv, int idx)
 	rx->gve = priv;
 	rx->q_num = idx;
 
-	slots = priv->rx_pages_per_qpl;
+	slots = priv->rx_data_slot_cnt;
 	rx->mask = slots - 1;
+	rx->data.raw_addressing = priv->raw_addressing;
 
 	/* alloc rx data ring */
 	bytes = sizeof(*rx->data.data_ring) * slots;
@@ -156,8 +201,8 @@ static int gve_rx_alloc_ring(struct gve_priv *priv, int idx)
 		err = -ENOMEM;
 		goto abort_with_q_resources;
 	}
-	rx->mask = slots - 1;
 	rx->cnt = 0;
+	rx->db_threshold = priv->rx_desc_cnt / 2;
 	rx->desc.seqno = 1;
 	gve_rx_add_to_block(priv, idx);
 
@@ -168,7 +213,7 @@ static int gve_rx_alloc_ring(struct gve_priv *priv, int idx)
 			  rx->q_resources, rx->q_resources_bus);
 	rx->q_resources = NULL;
 abort_filled:
-	kvfree(rx->data.page_info);
+	gve_rx_unfill_pages(priv, rx);
 abort_with_slots:
 	bytes = sizeof(*rx->data.data_ring) * slots;
 	dma_free_coherent(hdev, bytes, rx->data.data_ring, rx->data.data_bus);
@@ -251,8 +296,7 @@ static struct sk_buff *gve_rx_copy(struct gve_rx_ring *rx,
 	return skb;
 }
 
-static struct sk_buff *gve_rx_add_frags(struct net_device *dev,
-					struct napi_struct *napi,
+static struct sk_buff *gve_rx_add_frags(struct napi_struct *napi,
 					struct gve_rx_slot_page_info *page_info,
 					u16 len)
 {
@@ -268,14 +312,49 @@ static struct sk_buff *gve_rx_add_frags(struct net_device *dev,
 	return skb;
 }
 
+static int gve_rx_alloc_buffer(struct gve_priv *priv, struct device *dev,
+			       struct gve_rx_slot_page_info *page_info,
+			       struct gve_rx_data_slot *data_slot,
+			       struct gve_rx_ring *rx)
+{
+	struct page *page;
+	dma_addr_t dma;
+	int err;
+
+	err = gve_alloc_page(priv, dev, &page, &dma, DMA_FROM_DEVICE);
+	if (err) {
+		u64_stats_update_begin(&rx->statss);
+		rx->rx_buf_alloc_fail++;
+		u64_stats_update_end(&rx->statss);
+		return err;
+	}
+
+	gve_setup_rx_buffer(page_info, data_slot, dma, page);
+	return 0;
+}
+
 static void gve_rx_flip_buff(struct gve_rx_slot_page_info *page_info,
 			     struct gve_rx_data_slot *data_ring)
 {
-	u64 addr = be64_to_cpu(data_ring->qpl_offset);
+	u64 addr = be64_to_cpu(data_ring->addr);
 
 	page_info->page_offset ^= PAGE_SIZE / 2;
 	addr ^= PAGE_SIZE / 2;
-	data_ring->qpl_offset = cpu_to_be64(addr);
+	data_ring->addr = cpu_to_be64(addr);
+}
+
+static struct sk_buff *
+gve_rx_raw_addressing(struct device *dev, struct net_device *netdev,
+		      struct gve_rx_slot_page_info *page_info, u16 len,
+		      struct napi_struct *napi,
+		      struct gve_rx_data_slot *data_slot)
+{
+	struct sk_buff *skb = gve_rx_add_frags(napi, page_info, len);
+
+	if (!skb)
+		return NULL;
+
+	return skb;
 }
 
 static bool gve_rx(struct gve_rx_ring *rx, struct gve_rx_desc *rx_desc,
@@ -285,7 +364,9 @@ static bool gve_rx(struct gve_rx_ring *rx, struct gve_rx_desc *rx_desc,
 	struct gve_priv *priv = rx->gve;
 	struct napi_struct *napi = &priv->ntfy_blocks[rx->ntfy_id].napi;
 	struct net_device *dev = priv->dev;
-	struct sk_buff *skb;
+	struct gve_rx_data_slot *data_slot;
+	struct sk_buff *skb = NULL;
+	dma_addr_t page_bus;
 	int pagecount;
 	u16 len;
 
@@ -294,18 +375,18 @@ static bool gve_rx(struct gve_rx_ring *rx, struct gve_rx_desc *rx_desc,
 		u64_stats_update_begin(&rx->statss);
 		rx->rx_desc_err_dropped_pkt++;
 		u64_stats_update_end(&rx->statss);
-		return true;
+		return false;
 	}
 
 	len = be16_to_cpu(rx_desc->len) - GVE_RX_PAD;
 	page_info = &rx->data.page_info[idx];
-	dma_sync_single_for_cpu(&priv->pdev->dev, rx->data.qpl->page_buses[idx],
-				PAGE_SIZE, DMA_FROM_DEVICE);
 
-	/* gvnic can only receive into registered segments. If the buffer
-	 * can't be recycled, our only choice is to copy the data out of
-	 * it so that we can return it to the device.
-	 */
+	data_slot = &rx->data.data_ring[idx];
+	page_bus = (rx->data.raw_addressing) ?
+					be64_to_cpu(data_slot->addr) - page_info->page_offset :
+					rx->data.qpl->page_buses[idx];
+	dma_sync_single_for_cpu(&priv->pdev->dev, page_bus,
+				PAGE_SIZE, DMA_FROM_DEVICE);
 
 	if (PAGE_SIZE == 4096) {
 		if (len <= priv->rx_copybreak) {
@@ -316,6 +397,12 @@ static bool gve_rx(struct gve_rx_ring *rx, struct gve_rx_desc *rx_desc,
 			u64_stats_update_end(&rx->statss);
 			goto have_skb;
 		}
+		if (rx->data.raw_addressing) {
+			skb = gve_rx_raw_addressing(&priv->pdev->dev, dev,
+						    page_info, len, napi,
+						     data_slot);
+			goto have_skb;
+		}
 		if (unlikely(!gve_can_recycle_pages(dev))) {
 			skb = gve_rx_copy(rx, dev, napi, page_info, len);
 			goto have_skb;
@@ -326,12 +413,12 @@ static bool gve_rx(struct gve_rx_ring *rx, struct gve_rx_desc *rx_desc,
 			 * the page fragment to a new SKB and pass it up the
 			 * stack.
 			 */
-			skb = gve_rx_add_frags(dev, napi, page_info, len);
+			skb = gve_rx_add_frags(napi, page_info, len);
 			if (!skb) {
 				u64_stats_update_begin(&rx->statss);
 				rx->rx_skb_alloc_fail++;
 				u64_stats_update_end(&rx->statss);
-				return true;
+				return false;
 			}
 			/* Make sure the kernel stack can't release the page */
 			get_page(page_info->page);
@@ -347,7 +434,12 @@ static bool gve_rx(struct gve_rx_ring *rx, struct gve_rx_desc *rx_desc,
 			return false;
 		}
 	} else {
-		skb = gve_rx_copy(rx, dev, napi, page_info, len);
+		if (rx->data.raw_addressing)
+			skb = gve_rx_raw_addressing(&priv->pdev->dev, dev,
+						    page_info, len, napi,
+						    data_slot);
+		else
+			skb = gve_rx_copy(rx, dev, napi, page_info, len);
 	}
 
 have_skb:
@@ -358,7 +450,7 @@ static bool gve_rx(struct gve_rx_ring *rx, struct gve_rx_desc *rx_desc,
 		u64_stats_update_begin(&rx->statss);
 		rx->rx_skb_alloc_fail++;
 		u64_stats_update_end(&rx->statss);
-		return true;
+		return false;
 	}
 
 	if (likely(feat & NETIF_F_RXCSUM)) {
@@ -399,19 +491,45 @@ static bool gve_rx_work_pending(struct gve_rx_ring *rx)
 	return (GVE_SEQNO(flags_seq) == rx->desc.seqno);
 }
 
+static bool gve_rx_refill_buffers(struct gve_priv *priv, struct gve_rx_ring *rx)
+{
+	bool empty = rx->fill_cnt == rx->cnt;
+	u32 fill_cnt = rx->fill_cnt;
+
+	while (empty || ((fill_cnt & rx->mask) != (rx->cnt & rx->mask))) {
+		struct gve_rx_slot_page_info *page_info;
+		struct device *dev = &priv->pdev->dev;
+		struct gve_rx_data_slot *data_slot;
+		u32 idx = fill_cnt & rx->mask;
+
+		page_info = &rx->data.page_info[idx];
+		data_slot = &rx->data.data_ring[idx];
+		gve_rx_free_buffer(dev, page_info, data_slot);
+		page_info->page = NULL;
+		if (gve_rx_alloc_buffer(priv, dev, page_info, data_slot, rx))
+			break;
+		empty = false;
+		fill_cnt++;
+	}
+	rx->fill_cnt = fill_cnt;
+	return true;
+}
+
 bool gve_clean_rx_done(struct gve_rx_ring *rx, int budget,
 		       netdev_features_t feat)
 {
 	struct gve_priv *priv = rx->gve;
+	u32 work_done = 0, packets = 0;
 	struct gve_rx_desc *desc;
 	u32 cnt = rx->cnt;
 	u32 idx = cnt & rx->mask;
-	u32 work_done = 0;
 	u64 bytes = 0;
 
 	desc = rx->desc.desc_ring + idx;
 	while ((GVE_SEQNO(desc->flags_seq) == rx->desc.seqno) &&
 	       work_done < budget) {
+		bool dropped;
+
 		netif_info(priv, rx_status, priv->dev,
 			   "[%d] idx=%d desc=%p desc->flags_seq=0x%x\n",
 			   rx->q_num, idx, desc, desc->flags_seq);
@@ -419,9 +537,11 @@ bool gve_clean_rx_done(struct gve_rx_ring *rx, int budget,
 			   "[%d] seqno=%d rx->desc.seqno=%d\n",
 			   rx->q_num, GVE_SEQNO(desc->flags_seq),
 			   rx->desc.seqno);
-		bytes += be16_to_cpu(desc->len) - GVE_RX_PAD;
-		if (!gve_rx(rx, desc, feat, idx))
-			gve_schedule_reset(priv);
+		dropped = !gve_rx(rx, desc, feat, idx);
+		if (!dropped) {
+			bytes += be16_to_cpu(desc->len) - GVE_RX_PAD;
+			packets++;
+		}
 		cnt++;
 		idx = cnt & rx->mask;
 		desc = rx->desc.desc_ring + idx;
@@ -429,15 +549,35 @@ bool gve_clean_rx_done(struct gve_rx_ring *rx, int budget,
 		work_done++;
 	}
 
-	if (!work_done)
+	if (!work_done && rx->fill_cnt - cnt > rx->db_threshold) {
 		return false;
+	} else if (work_done) {
+		u64_stats_update_begin(&rx->statss);
+		rx->rpackets += packets;
+		rx->rbytes += bytes;
+		u64_stats_update_end(&rx->statss);
+		rx->cnt = cnt;
+	}
 
-	u64_stats_update_begin(&rx->statss);
-	rx->rpackets += work_done;
-	rx->rbytes += bytes;
-	u64_stats_update_end(&rx->statss);
-	rx->cnt = cnt;
-	rx->fill_cnt += work_done;
+	/* restock ring slots */
+	if (!rx->data.raw_addressing) {
+		/* In QPL mode buffs are refilled as the desc are processed */
+		rx->fill_cnt += work_done;
+	} else if (rx->fill_cnt - cnt <= rx->db_threshold) {
+		/* In raw addressing mode buffs are only refilled if the avail
+		 * falls below a threshold.
+		 */
+		if (!gve_rx_refill_buffers(priv, rx))
+			return false;
+
+		/* If we were not able to completely refill buffers, we'll want
+		 * to schedule this queue for work again to refill buffers.
+		 */
+		if (rx->fill_cnt - cnt <= rx->db_threshold) {
+			gve_rx_write_doorbell(priv, rx);
+			return true;
+		}
+	}
 
 	gve_rx_write_doorbell(priv, rx);
 	return gve_rx_work_pending(rx);
-- 
2.29.0.rc1.297.gfa9743e501-goog

