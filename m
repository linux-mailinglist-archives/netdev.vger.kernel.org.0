Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DDF7134768
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 17:14:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729333AbgAHQOM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 11:14:12 -0500
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:35654 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728499AbgAHQOM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 11:14:12 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id C1D08940075;
        Wed,  8 Jan 2020 16:14:09 +0000 (UTC)
Received: from amm-opti7060.uk.solarflarecom.com (10.17.20.147) by
 ukex01.SolarFlarecom.com (10.17.10.4) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Wed, 8 Jan 2020 16:14:04 +0000
From:   "Alex Maftei (amaftei)" <amaftei@solarflare.com>
Subject: [PATCH net-next 14/14] sfc: move common tx code
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>
CC:     <linux-net-drivers@solarflare.com>, <scrum-linux@solarflare.com>
References: <a0cfb828-b98e-3a63-15d9-592675e81b5f@solarflare.com>
Message-ID: <17ab8038-fce7-2eb3-90d9-cb785e15f5da@solarflare.com>
Date:   Wed, 8 Jan 2020 16:14:00 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <a0cfb828-b98e-3a63-15d9-592675e81b5f@solarflare.com>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.147]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-25154.003
X-TM-AS-Result: No-13.780300-8.000000-10
X-TMASE-MatchedRID: HMnje8wiUeCbII6cSoXysxbwCXv1ucAPcVr+FAe3UDVwh5cseF+Y9npn
        GiDiSyyD8XVI39JCRnSjfNAVYAJRAq0iin8P0KjVT7O/YHJhINBLXPA26IG0hJTx+2LIqNmtsLN
        r5TqhtfhNDlMjEx+1qzwY1aN94yb112zwq47MVQYnEamhyVW/p4v8yhR3Ab/7WkvncDztols/m/
        RVggRPLV8lXIcB25jc/b7hivPvvfwpuiLJxR150AnxCJVNCszYE3EgF0+MVuBsMPuLZB/IRylA/
        rS07QvhHMxLH9dA68yAK51JsktnfPzEorjs/fJlkr0W/BDHWEUvKK/+8XMSRLuqk4cq52pz4iqq
        D3wNGvr3OCj7jrqx3USxo0LIglac56XkomU2m5Uc9jA4mLo8uabfIJmIYD3gVMUpAF7vXidhCtQ
        ZJIvd6Ts1e7E/1DErkyW0UcpBYBM+xnrp+e79HG6HurDH4PpPMVx/3ZYby7+ZfDRE1uqSglPzm1
        QSSld2pzYzXM5CUAO/JoeG61f1PL3QjTjprqDD0XO+Yq6CqgIQtuqs6BbPJ0krZ4mFjTbDHP39F
        6H4hvet47NVP/i0QsDegOGWH69s8/+9MwUuFosHtOpEBhWiFgqiBO2qhCIGGP0M/F8V3KhPH2OE
        h/+ebEKDFP8YaJthPaFxH2N+nVopcZda/ugaiCQ7ls378/zHMI2NtA9qrmLpd478qvmyFnlsGJX
        t79WM2tmoqiGUvaILcZ5+vRDUdZRVSDjZnBHdcxMkBeI9K3fcca9Pxjh25WPZr2NA6vZGa4orGl
        /kSnqtXNEx7F7VaEEJnXKOZem8OsQVBHJwgWSrm7DrUlmNkJGTpe1iiCJqb5ic6rRyh48LbigRn
        pKlKXb6cSLExxx2OMB0shqXhHqIgXXmPMcd6qr83Oig5KG/tWktdr5CxQX5XZU6I9XAuroJB1t6
        7LUu
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--13.780300-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25154.003
X-MDID: 1578500051-N_EXDQUPzj6K
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Once again, a tiny bit of refactoring was required to stitch the code
together (i.e. adding headers). The moved code deals with managing tx
queues and mappings.

Signed-off-by: Alexandru-Mihai Maftei <amaftei@solarflare.com>
---
 drivers/net/ethernet/sfc/Makefile    |   2 +-
 drivers/net/ethernet/sfc/tx.c        | 295 -------------------------
 drivers/net/ethernet/sfc/tx_common.c | 310 +++++++++++++++++++++++++++
 3 files changed, 311 insertions(+), 296 deletions(-)
 create mode 100644 drivers/net/ethernet/sfc/tx_common.c

diff --git a/drivers/net/ethernet/sfc/Makefile b/drivers/net/ethernet/sfc/Makefile
index 03c63317a869..40a54df34647 100644
--- a/drivers/net/ethernet/sfc/Makefile
+++ b/drivers/net/ethernet/sfc/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 sfc-y			+= efx.o efx_common.o efx_channels.o nic.o \
 			   farch.o siena.o ef10.o \
-			   tx.o rx.o rx_common.o \
+			   tx.o tx_common.o rx.o rx_common.o \
 			   selftest.o ethtool.o ptp.o tx_tso.o \
 			   mcdi.o mcdi_port.o \
 			   mcdi_mon.o
diff --git a/drivers/net/ethernet/sfc/tx.c b/drivers/net/ethernet/sfc/tx.c
index 1c30354e098c..c9599fcab0b4 100644
--- a/drivers/net/ethernet/sfc/tx.c
+++ b/drivers/net/ethernet/sfc/tx.c
@@ -57,72 +57,6 @@ u8 *efx_tx_get_copy_buffer_limited(struct efx_tx_queue *tx_queue,
 	return efx_tx_get_copy_buffer(tx_queue, buffer);
 }
 
-void efx_dequeue_buffer(struct efx_tx_queue *tx_queue,
-			struct efx_tx_buffer *buffer,
-			unsigned int *pkts_compl,
-			unsigned int *bytes_compl)
-{
-	if (buffer->unmap_len) {
-		struct device *dma_dev = &tx_queue->efx->pci_dev->dev;
-		dma_addr_t unmap_addr = buffer->dma_addr - buffer->dma_offset;
-		if (buffer->flags & EFX_TX_BUF_MAP_SINGLE)
-			dma_unmap_single(dma_dev, unmap_addr, buffer->unmap_len,
-					 DMA_TO_DEVICE);
-		else
-			dma_unmap_page(dma_dev, unmap_addr, buffer->unmap_len,
-				       DMA_TO_DEVICE);
-		buffer->unmap_len = 0;
-	}
-
-	if (buffer->flags & EFX_TX_BUF_SKB) {
-		struct sk_buff *skb = (struct sk_buff *)buffer->skb;
-
-		EFX_WARN_ON_PARANOID(!pkts_compl || !bytes_compl);
-		(*pkts_compl)++;
-		(*bytes_compl) += skb->len;
-		if (tx_queue->timestamping &&
-		    (tx_queue->completed_timestamp_major ||
-		     tx_queue->completed_timestamp_minor)) {
-			struct skb_shared_hwtstamps hwtstamp;
-
-			hwtstamp.hwtstamp =
-				efx_ptp_nic_to_kernel_time(tx_queue);
-			skb_tstamp_tx(skb, &hwtstamp);
-
-			tx_queue->completed_timestamp_major = 0;
-			tx_queue->completed_timestamp_minor = 0;
-		}
-		dev_consume_skb_any((struct sk_buff *)buffer->skb);
-		netif_vdbg(tx_queue->efx, tx_done, tx_queue->efx->net_dev,
-			   "TX queue %d transmission id %x complete\n",
-			   tx_queue->queue, tx_queue->read_count);
-	} else if (buffer->flags & EFX_TX_BUF_XDP) {
-		xdp_return_frame_rx_napi(buffer->xdpf);
-	}
-
-	buffer->len = 0;
-	buffer->flags = 0;
-}
-
-unsigned int efx_tx_max_skb_descs(struct efx_nic *efx)
-{
-	/* Header and payload descriptor for each output segment, plus
-	 * one for every input fragment boundary within a segment
-	 */
-	unsigned int max_descs = EFX_TSO_MAX_SEGS * 2 + MAX_SKB_FRAGS;
-
-	/* Possibly one more per segment for option descriptors */
-	if (efx_nic_rev(efx) >= EFX_REV_HUNT_A0)
-		max_descs += EFX_TSO_MAX_SEGS;
-
-	/* Possibly more for PCIe page boundaries within input fragments */
-	if (PAGE_SIZE > EFX_PAGE_SIZE)
-		max_descs += max_t(unsigned int, MAX_SKB_FRAGS,
-				   DIV_ROUND_UP(GSO_MAX_SIZE, EFX_PAGE_SIZE));
-
-	return max_descs;
-}
-
 static void efx_tx_maybe_stop_queue(struct efx_tx_queue *txq1)
 {
 	/* We need to consider both queues that the net core sees as one */
@@ -334,107 +268,6 @@ static int efx_enqueue_skb_pio(struct efx_tx_queue *tx_queue,
 }
 #endif /* EFX_USE_PIO */
 
-struct efx_tx_buffer *efx_tx_map_chunk(struct efx_tx_queue *tx_queue,
-				       dma_addr_t dma_addr,
-				       size_t len)
-{
-	const struct efx_nic_type *nic_type = tx_queue->efx->type;
-	struct efx_tx_buffer *buffer;
-	unsigned int dma_len;
-
-	/* Map the fragment taking account of NIC-dependent DMA limits. */
-	do {
-		buffer = efx_tx_queue_get_insert_buffer(tx_queue);
-		dma_len = nic_type->tx_limit_len(tx_queue, dma_addr, len);
-
-		buffer->len = dma_len;
-		buffer->dma_addr = dma_addr;
-		buffer->flags = EFX_TX_BUF_CONT;
-		len -= dma_len;
-		dma_addr += dma_len;
-		++tx_queue->insert_count;
-	} while (len);
-
-	return buffer;
-}
-
-/* Map all data from an SKB for DMA and create descriptors on the queue.
- */
-int efx_tx_map_data(struct efx_tx_queue *tx_queue, struct sk_buff *skb,
-		    unsigned int segment_count)
-{
-	struct efx_nic *efx = tx_queue->efx;
-	struct device *dma_dev = &efx->pci_dev->dev;
-	unsigned int frag_index, nr_frags;
-	dma_addr_t dma_addr, unmap_addr;
-	unsigned short dma_flags;
-	size_t len, unmap_len;
-
-	nr_frags = skb_shinfo(skb)->nr_frags;
-	frag_index = 0;
-
-	/* Map header data. */
-	len = skb_headlen(skb);
-	dma_addr = dma_map_single(dma_dev, skb->data, len, DMA_TO_DEVICE);
-	dma_flags = EFX_TX_BUF_MAP_SINGLE;
-	unmap_len = len;
-	unmap_addr = dma_addr;
-
-	if (unlikely(dma_mapping_error(dma_dev, dma_addr)))
-		return -EIO;
-
-	if (segment_count) {
-		/* For TSO we need to put the header in to a separate
-		 * descriptor. Map this separately if necessary.
-		 */
-		size_t header_len = skb_transport_header(skb) - skb->data +
-				(tcp_hdr(skb)->doff << 2u);
-
-		if (header_len != len) {
-			tx_queue->tso_long_headers++;
-			efx_tx_map_chunk(tx_queue, dma_addr, header_len);
-			len -= header_len;
-			dma_addr += header_len;
-		}
-	}
-
-	/* Add descriptors for each fragment. */
-	do {
-		struct efx_tx_buffer *buffer;
-		skb_frag_t *fragment;
-
-		buffer = efx_tx_map_chunk(tx_queue, dma_addr, len);
-
-		/* The final descriptor for a fragment is responsible for
-		 * unmapping the whole fragment.
-		 */
-		buffer->flags = EFX_TX_BUF_CONT | dma_flags;
-		buffer->unmap_len = unmap_len;
-		buffer->dma_offset = buffer->dma_addr - unmap_addr;
-
-		if (frag_index >= nr_frags) {
-			/* Store SKB details with the final buffer for
-			 * the completion.
-			 */
-			buffer->skb = skb;
-			buffer->flags = EFX_TX_BUF_SKB | dma_flags;
-			return 0;
-		}
-
-		/* Move on to the next fragment. */
-		fragment = &skb_shinfo(skb)->frags[frag_index++];
-		len = skb_frag_size(fragment);
-		dma_addr = skb_frag_dma_map(dma_dev, fragment,
-				0, len, DMA_TO_DEVICE);
-		dma_flags = 0;
-		unmap_len = len;
-		unmap_addr = dma_addr;
-
-		if (unlikely(dma_mapping_error(dma_dev, dma_addr)))
-			return -EIO;
-	} while (1);
-}
-
 /* Remove buffers put into a tx_queue for the current packet.
  * None of the buffers must have an skb attached.
  */
@@ -877,131 +710,3 @@ void efx_xmit_done(struct efx_tx_queue *tx_queue, unsigned int index)
 		}
 	}
 }
-
-static unsigned int efx_tx_cb_page_count(struct efx_tx_queue *tx_queue)
-{
-	return DIV_ROUND_UP(tx_queue->ptr_mask + 1, PAGE_SIZE >> EFX_TX_CB_ORDER);
-}
-
-int efx_probe_tx_queue(struct efx_tx_queue *tx_queue)
-{
-	struct efx_nic *efx = tx_queue->efx;
-	unsigned int entries;
-	int rc;
-
-	/* Create the smallest power-of-two aligned ring */
-	entries = max(roundup_pow_of_two(efx->txq_entries), EFX_MIN_DMAQ_SIZE);
-	EFX_WARN_ON_PARANOID(entries > EFX_MAX_DMAQ_SIZE);
-	tx_queue->ptr_mask = entries - 1;
-
-	netif_dbg(efx, probe, efx->net_dev,
-		  "creating TX queue %d size %#x mask %#x\n",
-		  tx_queue->queue, efx->txq_entries, tx_queue->ptr_mask);
-
-	/* Allocate software ring */
-	tx_queue->buffer = kcalloc(entries, sizeof(*tx_queue->buffer),
-				   GFP_KERNEL);
-	if (!tx_queue->buffer)
-		return -ENOMEM;
-
-	tx_queue->cb_page = kcalloc(efx_tx_cb_page_count(tx_queue),
-				    sizeof(tx_queue->cb_page[0]), GFP_KERNEL);
-	if (!tx_queue->cb_page) {
-		rc = -ENOMEM;
-		goto fail1;
-	}
-
-	/* Allocate hardware ring */
-	rc = efx_nic_probe_tx(tx_queue);
-	if (rc)
-		goto fail2;
-
-	return 0;
-
-fail2:
-	kfree(tx_queue->cb_page);
-	tx_queue->cb_page = NULL;
-fail1:
-	kfree(tx_queue->buffer);
-	tx_queue->buffer = NULL;
-	return rc;
-}
-
-void efx_init_tx_queue(struct efx_tx_queue *tx_queue)
-{
-	struct efx_nic *efx = tx_queue->efx;
-
-	netif_dbg(efx, drv, efx->net_dev,
-		  "initialising TX queue %d\n", tx_queue->queue);
-
-	tx_queue->insert_count = 0;
-	tx_queue->write_count = 0;
-	tx_queue->packet_write_count = 0;
-	tx_queue->old_write_count = 0;
-	tx_queue->read_count = 0;
-	tx_queue->old_read_count = 0;
-	tx_queue->empty_read_count = 0 | EFX_EMPTY_COUNT_VALID;
-	tx_queue->xmit_more_available = false;
-	tx_queue->timestamping = (efx_ptp_use_mac_tx_timestamps(efx) &&
-				  tx_queue->channel == efx_ptp_channel(efx));
-	tx_queue->completed_desc_ptr = tx_queue->ptr_mask;
-	tx_queue->completed_timestamp_major = 0;
-	tx_queue->completed_timestamp_minor = 0;
-
-	tx_queue->xdp_tx = efx_channel_is_xdp_tx(tx_queue->channel);
-
-	/* Set up default function pointers. These may get replaced by
-	 * efx_nic_init_tx() based off NIC/queue capabilities.
-	 */
-	tx_queue->handle_tso = efx_enqueue_skb_tso;
-
-	/* Set up TX descriptor ring */
-	efx_nic_init_tx(tx_queue);
-
-	tx_queue->initialised = true;
-}
-
-void efx_fini_tx_queue(struct efx_tx_queue *tx_queue)
-{
-	struct efx_tx_buffer *buffer;
-
-	netif_dbg(tx_queue->efx, drv, tx_queue->efx->net_dev,
-		  "shutting down TX queue %d\n", tx_queue->queue);
-
-	if (!tx_queue->buffer)
-		return;
-
-	/* Free any buffers left in the ring */
-	while (tx_queue->read_count != tx_queue->write_count) {
-		unsigned int pkts_compl = 0, bytes_compl = 0;
-		buffer = &tx_queue->buffer[tx_queue->read_count & tx_queue->ptr_mask];
-		efx_dequeue_buffer(tx_queue, buffer, &pkts_compl, &bytes_compl);
-
-		++tx_queue->read_count;
-	}
-	tx_queue->xmit_more_available = false;
-	netdev_tx_reset_queue(tx_queue->core_txq);
-}
-
-void efx_remove_tx_queue(struct efx_tx_queue *tx_queue)
-{
-	int i;
-
-	if (!tx_queue->buffer)
-		return;
-
-	netif_dbg(tx_queue->efx, drv, tx_queue->efx->net_dev,
-		  "destroying TX queue %d\n", tx_queue->queue);
-	efx_nic_remove_tx(tx_queue);
-
-	if (tx_queue->cb_page) {
-		for (i = 0; i < efx_tx_cb_page_count(tx_queue); i++)
-			efx_nic_free_buffer(tx_queue->efx,
-					    &tx_queue->cb_page[i]);
-		kfree(tx_queue->cb_page);
-		tx_queue->cb_page = NULL;
-	}
-
-	kfree(tx_queue->buffer);
-	tx_queue->buffer = NULL;
-}
diff --git a/drivers/net/ethernet/sfc/tx_common.c b/drivers/net/ethernet/sfc/tx_common.c
new file mode 100644
index 000000000000..e29ade21c4b9
--- /dev/null
+++ b/drivers/net/ethernet/sfc/tx_common.c
@@ -0,0 +1,310 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/****************************************************************************
+ * Driver for Solarflare network controllers and boards
+ * Copyright 2018 Solarflare Communications Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation, incorporated herein by reference.
+ */
+
+#include "net_driver.h"
+#include "efx.h"
+#include "nic.h"
+#include "tx_common.h"
+
+static unsigned int efx_tx_cb_page_count(struct efx_tx_queue *tx_queue)
+{
+	return DIV_ROUND_UP(tx_queue->ptr_mask + 1,
+			    PAGE_SIZE >> EFX_TX_CB_ORDER);
+}
+
+int efx_probe_tx_queue(struct efx_tx_queue *tx_queue)
+{
+	struct efx_nic *efx = tx_queue->efx;
+	unsigned int entries;
+	int rc;
+
+	/* Create the smallest power-of-two aligned ring */
+	entries = max(roundup_pow_of_two(efx->txq_entries), EFX_MIN_DMAQ_SIZE);
+	EFX_WARN_ON_PARANOID(entries > EFX_MAX_DMAQ_SIZE);
+	tx_queue->ptr_mask = entries - 1;
+
+	netif_dbg(efx, probe, efx->net_dev,
+		  "creating TX queue %d size %#x mask %#x\n",
+		  tx_queue->queue, efx->txq_entries, tx_queue->ptr_mask);
+
+	/* Allocate software ring */
+	tx_queue->buffer = kcalloc(entries, sizeof(*tx_queue->buffer),
+				   GFP_KERNEL);
+	if (!tx_queue->buffer)
+		return -ENOMEM;
+
+	tx_queue->cb_page = kcalloc(efx_tx_cb_page_count(tx_queue),
+				    sizeof(tx_queue->cb_page[0]), GFP_KERNEL);
+	if (!tx_queue->cb_page) {
+		rc = -ENOMEM;
+		goto fail1;
+	}
+
+	/* Allocate hardware ring */
+	rc = efx_nic_probe_tx(tx_queue);
+	if (rc)
+		goto fail2;
+
+	return 0;
+
+fail2:
+	kfree(tx_queue->cb_page);
+	tx_queue->cb_page = NULL;
+fail1:
+	kfree(tx_queue->buffer);
+	tx_queue->buffer = NULL;
+	return rc;
+}
+
+void efx_init_tx_queue(struct efx_tx_queue *tx_queue)
+{
+	struct efx_nic *efx = tx_queue->efx;
+
+	netif_dbg(efx, drv, efx->net_dev,
+		  "initialising TX queue %d\n", tx_queue->queue);
+
+	tx_queue->insert_count = 0;
+	tx_queue->write_count = 0;
+	tx_queue->packet_write_count = 0;
+	tx_queue->old_write_count = 0;
+	tx_queue->read_count = 0;
+	tx_queue->old_read_count = 0;
+	tx_queue->empty_read_count = 0 | EFX_EMPTY_COUNT_VALID;
+	tx_queue->xmit_more_available = false;
+	tx_queue->timestamping = (efx_ptp_use_mac_tx_timestamps(efx) &&
+				  tx_queue->channel == efx_ptp_channel(efx));
+	tx_queue->completed_desc_ptr = tx_queue->ptr_mask;
+	tx_queue->completed_timestamp_major = 0;
+	tx_queue->completed_timestamp_minor = 0;
+
+	tx_queue->xdp_tx = efx_channel_is_xdp_tx(tx_queue->channel);
+
+	/* Set up default function pointers. These may get replaced by
+	 * efx_nic_init_tx() based off NIC/queue capabilities.
+	 */
+	tx_queue->handle_tso = efx_enqueue_skb_tso;
+
+	/* Set up TX descriptor ring */
+	efx_nic_init_tx(tx_queue);
+
+	tx_queue->initialised = true;
+}
+
+void efx_fini_tx_queue(struct efx_tx_queue *tx_queue)
+{
+	struct efx_tx_buffer *buffer;
+
+	netif_dbg(tx_queue->efx, drv, tx_queue->efx->net_dev,
+		  "shutting down TX queue %d\n", tx_queue->queue);
+
+	if (!tx_queue->buffer)
+		return;
+
+	/* Free any buffers left in the ring */
+	while (tx_queue->read_count != tx_queue->write_count) {
+		unsigned int pkts_compl = 0, bytes_compl = 0;
+
+		buffer = &tx_queue->buffer[tx_queue->read_count & tx_queue->ptr_mask];
+		efx_dequeue_buffer(tx_queue, buffer, &pkts_compl, &bytes_compl);
+
+		++tx_queue->read_count;
+	}
+	tx_queue->xmit_more_available = false;
+	netdev_tx_reset_queue(tx_queue->core_txq);
+}
+
+void efx_remove_tx_queue(struct efx_tx_queue *tx_queue)
+{
+	int i;
+
+	if (!tx_queue->buffer)
+		return;
+
+	netif_dbg(tx_queue->efx, drv, tx_queue->efx->net_dev,
+		  "destroying TX queue %d\n", tx_queue->queue);
+	efx_nic_remove_tx(tx_queue);
+
+	if (tx_queue->cb_page) {
+		for (i = 0; i < efx_tx_cb_page_count(tx_queue); i++)
+			efx_nic_free_buffer(tx_queue->efx,
+					    &tx_queue->cb_page[i]);
+		kfree(tx_queue->cb_page);
+		tx_queue->cb_page = NULL;
+	}
+
+	kfree(tx_queue->buffer);
+	tx_queue->buffer = NULL;
+}
+
+void efx_dequeue_buffer(struct efx_tx_queue *tx_queue,
+			struct efx_tx_buffer *buffer,
+			unsigned int *pkts_compl,
+			unsigned int *bytes_compl)
+{
+	if (buffer->unmap_len) {
+		struct device *dma_dev = &tx_queue->efx->pci_dev->dev;
+		dma_addr_t unmap_addr = buffer->dma_addr - buffer->dma_offset;
+
+		if (buffer->flags & EFX_TX_BUF_MAP_SINGLE)
+			dma_unmap_single(dma_dev, unmap_addr, buffer->unmap_len,
+					 DMA_TO_DEVICE);
+		else
+			dma_unmap_page(dma_dev, unmap_addr, buffer->unmap_len,
+				       DMA_TO_DEVICE);
+		buffer->unmap_len = 0;
+	}
+
+	if (buffer->flags & EFX_TX_BUF_SKB) {
+		struct sk_buff *skb = (struct sk_buff *)buffer->skb;
+
+		EFX_WARN_ON_PARANOID(!pkts_compl || !bytes_compl);
+		(*pkts_compl)++;
+		(*bytes_compl) += skb->len;
+		if (tx_queue->timestamping &&
+		    (tx_queue->completed_timestamp_major ||
+		     tx_queue->completed_timestamp_minor)) {
+			struct skb_shared_hwtstamps hwtstamp;
+
+			hwtstamp.hwtstamp =
+				efx_ptp_nic_to_kernel_time(tx_queue);
+			skb_tstamp_tx(skb, &hwtstamp);
+
+			tx_queue->completed_timestamp_major = 0;
+			tx_queue->completed_timestamp_minor = 0;
+		}
+		dev_consume_skb_any((struct sk_buff *)buffer->skb);
+		netif_vdbg(tx_queue->efx, tx_done, tx_queue->efx->net_dev,
+			   "TX queue %d transmission id %x complete\n",
+			   tx_queue->queue, tx_queue->read_count);
+	} else if (buffer->flags & EFX_TX_BUF_XDP) {
+		xdp_return_frame_rx_napi(buffer->xdpf);
+	}
+
+	buffer->len = 0;
+	buffer->flags = 0;
+}
+
+struct efx_tx_buffer *efx_tx_map_chunk(struct efx_tx_queue *tx_queue,
+				       dma_addr_t dma_addr, size_t len)
+{
+	const struct efx_nic_type *nic_type = tx_queue->efx->type;
+	struct efx_tx_buffer *buffer;
+	unsigned int dma_len;
+
+	/* Map the fragment taking account of NIC-dependent DMA limits. */
+	do {
+		buffer = efx_tx_queue_get_insert_buffer(tx_queue);
+		dma_len = nic_type->tx_limit_len(tx_queue, dma_addr, len);
+
+		buffer->len = dma_len;
+		buffer->dma_addr = dma_addr;
+		buffer->flags = EFX_TX_BUF_CONT;
+		len -= dma_len;
+		dma_addr += dma_len;
+		++tx_queue->insert_count;
+	} while (len);
+
+	return buffer;
+}
+
+/* Map all data from an SKB for DMA and create descriptors on the queue. */
+int efx_tx_map_data(struct efx_tx_queue *tx_queue, struct sk_buff *skb,
+		    unsigned int segment_count)
+{
+	struct efx_nic *efx = tx_queue->efx;
+	struct device *dma_dev = &efx->pci_dev->dev;
+	unsigned int frag_index, nr_frags;
+	dma_addr_t dma_addr, unmap_addr;
+	unsigned short dma_flags;
+	size_t len, unmap_len;
+
+	nr_frags = skb_shinfo(skb)->nr_frags;
+	frag_index = 0;
+
+	/* Map header data. */
+	len = skb_headlen(skb);
+	dma_addr = dma_map_single(dma_dev, skb->data, len, DMA_TO_DEVICE);
+	dma_flags = EFX_TX_BUF_MAP_SINGLE;
+	unmap_len = len;
+	unmap_addr = dma_addr;
+
+	if (unlikely(dma_mapping_error(dma_dev, dma_addr)))
+		return -EIO;
+
+	if (segment_count) {
+		/* For TSO we need to put the header in to a separate
+		 * descriptor. Map this separately if necessary.
+		 */
+		size_t header_len = skb_transport_header(skb) - skb->data +
+				(tcp_hdr(skb)->doff << 2u);
+
+		if (header_len != len) {
+			tx_queue->tso_long_headers++;
+			efx_tx_map_chunk(tx_queue, dma_addr, header_len);
+			len -= header_len;
+			dma_addr += header_len;
+		}
+	}
+
+	/* Add descriptors for each fragment. */
+	do {
+		struct efx_tx_buffer *buffer;
+		skb_frag_t *fragment;
+
+		buffer = efx_tx_map_chunk(tx_queue, dma_addr, len);
+
+		/* The final descriptor for a fragment is responsible for
+		 * unmapping the whole fragment.
+		 */
+		buffer->flags = EFX_TX_BUF_CONT | dma_flags;
+		buffer->unmap_len = unmap_len;
+		buffer->dma_offset = buffer->dma_addr - unmap_addr;
+
+		if (frag_index >= nr_frags) {
+			/* Store SKB details with the final buffer for
+			 * the completion.
+			 */
+			buffer->skb = skb;
+			buffer->flags = EFX_TX_BUF_SKB | dma_flags;
+			return 0;
+		}
+
+		/* Move on to the next fragment. */
+		fragment = &skb_shinfo(skb)->frags[frag_index++];
+		len = skb_frag_size(fragment);
+		dma_addr = skb_frag_dma_map(dma_dev, fragment, 0, len,
+					    DMA_TO_DEVICE);
+		dma_flags = 0;
+		unmap_len = len;
+		unmap_addr = dma_addr;
+
+		if (unlikely(dma_mapping_error(dma_dev, dma_addr)))
+			return -EIO;
+	} while (1);
+}
+
+unsigned int efx_tx_max_skb_descs(struct efx_nic *efx)
+{
+	/* Header and payload descriptor for each output segment, plus
+	 * one for every input fragment boundary within a segment
+	 */
+	unsigned int max_descs = EFX_TSO_MAX_SEGS * 2 + MAX_SKB_FRAGS;
+
+	/* Possibly one more per segment for option descriptors */
+	if (efx_nic_rev(efx) >= EFX_REV_HUNT_A0)
+		max_descs += EFX_TSO_MAX_SEGS;
+
+	/* Possibly more for PCIe page boundaries within input fragments */
+	if (PAGE_SIZE > EFX_PAGE_SIZE)
+		max_descs += max_t(unsigned int, MAX_SKB_FRAGS,
+				   DIV_ROUND_UP(GSO_MAX_SIZE, EFX_PAGE_SIZE));
+
+	return max_descs;
+}
-- 
2.20.1

