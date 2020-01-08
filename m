Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D68BA134767
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 17:13:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729401AbgAHQNz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 11:13:55 -0500
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:32926 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729220AbgAHQNy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 11:13:54 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us4.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id A6D02BC0064;
        Wed,  8 Jan 2020 16:13:52 +0000 (UTC)
Received: from amm-opti7060.uk.solarflarecom.com (10.17.20.147) by
 ukex01.SolarFlarecom.com (10.17.10.4) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Wed, 8 Jan 2020 16:13:46 +0000
From:   "Alex Maftei (amaftei)" <amaftei@solarflare.com>
Subject: [PATCH net-next 13/14] sfc: move common rx code
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>
CC:     <linux-net-drivers@solarflare.com>, <scrum-linux@solarflare.com>
References: <a0cfb828-b98e-3a63-15d9-592675e81b5f@solarflare.com>
Message-ID: <827f0e50-29c8-db98-8b75-a9e3c0a36589@solarflare.com>
Date:   Wed, 8 Jan 2020 16:13:43 +0000
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
X-TM-AS-Result: No-0.980600-8.000000-10
X-TMASE-MatchedRID: BhyxFQquqX82jeY+Udg/IlMsVuL5ry7dUQdoCHfd3T+4zlF1pkNzlq6P
        KQSZCnDq8XVI39JCRnSjfNAVYAJRAvI1YbpS1+avPwKTD1v8YV5UENBIMyKD0cSiwizsgluQ/m6
        Z4rBhqJB6VOFM24GbsWm7zSiPnz7Qm1+Cvw6ldDUaPMGCcVm9Di9Xl/s/QdUMnc419+1VHFrQdM
        su4pDKGP0QzT0YRV1bb/sbz+8ciHPkX7lKgLAYPPzTlJK+gA8330ZykK+rMdqo8aocg8ZmI996V
        2NgrEHi2K1EWxOa8ez+5FJTwERScH7cyNXthByNnMQdNQ64xff5xwgg6ThjjiYphvQnii6iEvfX
        VFdC2JK3nUbrvp5Ak7tz0Y8who03QiNolKxpXqqOjIrMSa2sR5nmyveoINN21JVSTP0E9d41PTa
        GqNsVqXvy+E2bBJrMGzdq9U/09E0O9fZKTjt+zw97mDMXdNW3hj6De48DqJ9Wm0JlHAu9AfEpS5
        F3HWQz7ssfVa1xEkfmSdrJmXz7WNMsGRKm0bkEh2VzUlo4HVPdXhRKGhNdp6cxvibtoCq3jQb0Z
        ijHcXDHHdMIKYAczi2Z94RgI54onEMCM6PzyYGwVIp8Y8imtfy3gqNDWibmNWdAxATiIiU30EeC
        x5K2Kzs6ZGXga+hLgdJYFwmRvv7uCneWeJlGL4eMWfCwoMwMazzS+36ix9xUjspoiX02F3iVB3z
        9o3PE0dwJVv4qk4qt99+WNHfE7cd/u6Zu3u0xvmT2VURehlqVLkhtDy7dOhpX1zEL4nq3E9xmna
        TegLiCrB/vDmCkLick6z82qGIzLVLChO4s5burm7DrUlmNkJGTpe1iiCJqb5ic6rRyh48LbigRn
        pKlKTpcQTtiHDgWVnahAqeXdJXhJJ/shHMF/h77f2czh7vEOYMujF4m2kXSosP0wEqNeKfF0HMy
        WdxrFHQedA3lgzXPYgbPB0KfHpw9UNtv6dqgF8WOpmrvCxtyCYeHQXFONn+IaU6aARfSasRgksx
        Q/TKvQ1bcoZECoQ==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--0.980600-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25154.003
X-MDID: 1578500033-eDIjjemV9Up5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The moved code deals with managing rx buffers and queues.
A tiny bit of refactoring was required in other files to stitch the
code together.

Signed-off-by: Alexandru-Mihai Maftei <amaftei@solarflare.com>
---
 drivers/net/ethernet/sfc/Makefile    |   2 +-
 drivers/net/ethernet/sfc/ef10.c      |   1 +
 drivers/net/ethernet/sfc/efx.c       |  11 -
 drivers/net/ethernet/sfc/efx.h       |   3 +
 drivers/net/ethernet/sfc/rx.c        | 366 +-------------------------
 drivers/net/ethernet/sfc/rx_common.c | 375 +++++++++++++++++++++++++++
 6 files changed, 383 insertions(+), 375 deletions(-)
 create mode 100644 drivers/net/ethernet/sfc/rx_common.c

diff --git a/drivers/net/ethernet/sfc/Makefile b/drivers/net/ethernet/sfc/Makefile
index dacfa42beffe..03c63317a869 100644
--- a/drivers/net/ethernet/sfc/Makefile
+++ b/drivers/net/ethernet/sfc/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 sfc-y			+= efx.o efx_common.o efx_channels.o nic.o \
 			   farch.o siena.o ef10.o \
-			   tx.o rx.o \
+			   tx.o rx.o rx_common.o \
 			   selftest.o ethtool.o ptp.o tx_tso.o \
 			   mcdi.o mcdi_port.o \
 			   mcdi_mon.o
diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index de6e6cd4469b..d752ed34672d 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -5,6 +5,7 @@
  */
 
 #include "net_driver.h"
+#include "rx_common.h"
 #include "ef10_regs.h"
 #include "io.h"
 #include "mcdi.h"
diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 4bce5c739974..655424e83d97 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -128,17 +128,6 @@ static int efx_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **xdpfs,
 			ASSERT_RTNL();			\
 	} while (0)
 
-/**************************************************************************
- *
- * Channel handling
- *
- *************************************************************************/
-
-void efx_schedule_slow_fill(struct efx_rx_queue *rx_queue)
-{
-	mod_timer(&rx_queue->slow_fill, jiffies + msecs_to_jiffies(10));
-}
-
 /**************************************************************************
  *
  * Port handling
diff --git a/drivers/net/ethernet/sfc/efx.h b/drivers/net/ethernet/sfc/efx.h
index 2b417e779e82..3920f29b2fed 100644
--- a/drivers/net/ethernet/sfc/efx.h
+++ b/drivers/net/ethernet/sfc/efx.h
@@ -37,6 +37,9 @@ static inline void efx_rx_flush_packet(struct efx_channel *channel)
 		__efx_rx_packet(channel);
 }
 
+void efx_init_rx_recycle_ring(struct efx_rx_queue *rx_queue);
+struct page *efx_reuse_page(struct efx_rx_queue *rx_queue);
+
 #define EFX_MAX_DMAQ_SIZE 4096UL
 #define EFX_DEFAULT_DMAQ_SIZE 1024UL
 #define EFX_MIN_DMAQ_SIZE 512UL
diff --git a/drivers/net/ethernet/sfc/rx.c b/drivers/net/ethernet/sfc/rx.c
index 26b5c36237fe..0e04ed7f6382 100644
--- a/drivers/net/ethernet/sfc/rx.c
+++ b/drivers/net/ethernet/sfc/rx.c
@@ -43,23 +43,10 @@
 /* Size of buffer allocated for skb header area. */
 #define EFX_SKB_HEADERS  128u
 
-/* This is the percentage fill level below which new RX descriptors
- * will be added to the RX descriptor ring.
- */
-static unsigned int rx_refill_threshold;
-
 /* Each packet can consume up to ceil(max_frame_len / buffer_size) buffers */
 #define EFX_RX_MAX_FRAGS DIV_ROUND_UP(EFX_MAX_FRAME_LEN(EFX_MAX_MTU), \
 				      EFX_RX_USR_BUF_SIZE)
 
-/*
- * RX maximum head room required.
- *
- * This must be at least 1 to prevent overflow, plus one packet-worth
- * to allow pipelined receives.
- */
-#define EFX_RXD_HEAD_ROOM (1 + EFX_RX_MAX_FRAGS)
-
 static inline u8 *efx_rx_buf_va(struct efx_rx_buffer *buf)
 {
 	return page_address(buf->page) + buf->page_offset;
@@ -86,22 +73,8 @@ static inline void efx_sync_rx_buffer(struct efx_nic *efx,
 				DMA_FROM_DEVICE);
 }
 
-void efx_rx_config_page_split(struct efx_nic *efx)
-{
-	efx->rx_page_buf_step = ALIGN(efx->rx_dma_len + efx->rx_ip_align +
-				      XDP_PACKET_HEADROOM,
-				      EFX_RX_BUF_ALIGNMENT);
-	efx->rx_bufs_per_page = efx->rx_buffer_order ? 1 :
-		((PAGE_SIZE - sizeof(struct efx_rx_page_state)) /
-		efx->rx_page_buf_step);
-	efx->rx_buffer_truesize = (PAGE_SIZE << efx->rx_buffer_order) /
-		efx->rx_bufs_per_page;
-	efx->rx_pages_per_batch = DIV_ROUND_UP(EFX_RX_PREFERRED_BATCH,
-					       efx->rx_bufs_per_page);
-}
-
 /* Check the RX page recycle ring for a page that can be reused. */
-static struct page *efx_reuse_page(struct efx_rx_queue *rx_queue)
+struct page *efx_reuse_page(struct efx_rx_queue *rx_queue)
 {
 	struct efx_nic *efx = rx_queue->efx;
 	struct page *page;
@@ -134,106 +107,6 @@ static struct page *efx_reuse_page(struct efx_rx_queue *rx_queue)
 	return NULL;
 }
 
-/**
- * efx_init_rx_buffers - create EFX_RX_BATCH page-based RX buffers
- *
- * @rx_queue:		Efx RX queue
- *
- * This allocates a batch of pages, maps them for DMA, and populates
- * struct efx_rx_buffers for each one. Return a negative error code or
- * 0 on success. If a single page can be used for multiple buffers,
- * then the page will either be inserted fully, or not at all.
- */
-int efx_init_rx_buffers(struct efx_rx_queue *rx_queue, bool atomic)
-{
-	struct efx_nic *efx = rx_queue->efx;
-	struct efx_rx_buffer *rx_buf;
-	struct page *page;
-	unsigned int page_offset;
-	struct efx_rx_page_state *state;
-	dma_addr_t dma_addr;
-	unsigned index, count;
-
-	count = 0;
-	do {
-		page = efx_reuse_page(rx_queue);
-		if (page == NULL) {
-			page = alloc_pages(__GFP_COMP |
-					   (atomic ? GFP_ATOMIC : GFP_KERNEL),
-					   efx->rx_buffer_order);
-			if (unlikely(page == NULL))
-				return -ENOMEM;
-			dma_addr =
-				dma_map_page(&efx->pci_dev->dev, page, 0,
-					     PAGE_SIZE << efx->rx_buffer_order,
-					     DMA_FROM_DEVICE);
-			if (unlikely(dma_mapping_error(&efx->pci_dev->dev,
-						       dma_addr))) {
-				__free_pages(page, efx->rx_buffer_order);
-				return -EIO;
-			}
-			state = page_address(page);
-			state->dma_addr = dma_addr;
-		} else {
-			state = page_address(page);
-			dma_addr = state->dma_addr;
-		}
-
-		dma_addr += sizeof(struct efx_rx_page_state);
-		page_offset = sizeof(struct efx_rx_page_state);
-
-		do {
-			index = rx_queue->added_count & rx_queue->ptr_mask;
-			rx_buf = efx_rx_buffer(rx_queue, index);
-			rx_buf->dma_addr = dma_addr + efx->rx_ip_align +
-					   XDP_PACKET_HEADROOM;
-			rx_buf->page = page;
-			rx_buf->page_offset = page_offset + efx->rx_ip_align +
-					      XDP_PACKET_HEADROOM;
-			rx_buf->len = efx->rx_dma_len;
-			rx_buf->flags = 0;
-			++rx_queue->added_count;
-			get_page(page);
-			dma_addr += efx->rx_page_buf_step;
-			page_offset += efx->rx_page_buf_step;
-		} while (page_offset + efx->rx_page_buf_step <= PAGE_SIZE);
-
-		rx_buf->flags = EFX_RX_BUF_LAST_IN_PAGE;
-	} while (++count < efx->rx_pages_per_batch);
-
-	return 0;
-}
-
-/* Unmap a DMA-mapped page.  This function is only called for the final RX
- * buffer in a page.
- */
-void efx_unmap_rx_buffer(struct efx_nic *efx,
-			 struct efx_rx_buffer *rx_buf)
-{
-	struct page *page = rx_buf->page;
-
-	if (page) {
-		struct efx_rx_page_state *state = page_address(page);
-		dma_unmap_page(&efx->pci_dev->dev,
-			       state->dma_addr,
-			       PAGE_SIZE << efx->rx_buffer_order,
-			       DMA_FROM_DEVICE);
-	}
-}
-
-void efx_free_rx_buffers(struct efx_rx_queue *rx_queue,
-			 struct efx_rx_buffer *rx_buf,
-			 unsigned int num_bufs)
-{
-	do {
-		if (rx_buf->page) {
-			put_page(rx_buf->page);
-			rx_buf->page = NULL;
-		}
-		rx_buf = efx_rx_buf_next(rx_queue, rx_buf);
-	} while (--num_bufs);
-}
-
 /* Attempt to recycle the page if there is an RX recycle ring; the page can
  * only be added if this is the final RX buffer, to prevent pages being used in
  * the descriptor ring and appearing in the recycle ring simultaneously.
@@ -270,21 +143,6 @@ static void efx_recycle_rx_page(struct efx_channel *channel,
 	put_page(rx_buf->page);
 }
 
-static void efx_fini_rx_buffer(struct efx_rx_queue *rx_queue,
-			       struct efx_rx_buffer *rx_buf)
-{
-	/* Release the page reference we hold for the buffer. */
-	if (rx_buf->page)
-		put_page(rx_buf->page);
-
-	/* If this is the last buffer in a page, unmap and free it. */
-	if (rx_buf->flags & EFX_RX_BUF_LAST_IN_PAGE) {
-		efx_unmap_rx_buffer(rx_queue->efx, rx_buf);
-		efx_free_rx_buffers(rx_queue, rx_buf, 1);
-	}
-	rx_buf->page = NULL;
-}
-
 /* Recycle the pages that are used by buffers that have just been received. */
 static void efx_recycle_rx_pages(struct efx_channel *channel,
 				 struct efx_rx_buffer *rx_buf,
@@ -309,78 +167,6 @@ static void efx_discard_rx_packet(struct efx_channel *channel,
 	efx_free_rx_buffers(rx_queue, rx_buf, n_frags);
 }
 
-/**
- * efx_fast_push_rx_descriptors - push new RX descriptors quickly
- * @rx_queue:		RX descriptor queue
- *
- * This will aim to fill the RX descriptor queue up to
- * @rx_queue->@max_fill. If there is insufficient atomic
- * memory to do so, a slow fill will be scheduled.
- *
- * The caller must provide serialisation (none is used here). In practise,
- * this means this function must run from the NAPI handler, or be called
- * when NAPI is disabled.
- */
-void efx_fast_push_rx_descriptors(struct efx_rx_queue *rx_queue, bool atomic)
-{
-	struct efx_nic *efx = rx_queue->efx;
-	unsigned int fill_level, batch_size;
-	int space, rc = 0;
-
-	if (!rx_queue->refill_enabled)
-		return;
-
-	/* Calculate current fill level, and exit if we don't need to fill */
-	fill_level = (rx_queue->added_count - rx_queue->removed_count);
-	EFX_WARN_ON_ONCE_PARANOID(fill_level > rx_queue->efx->rxq_entries);
-	if (fill_level >= rx_queue->fast_fill_trigger)
-		goto out;
-
-	/* Record minimum fill level */
-	if (unlikely(fill_level < rx_queue->min_fill)) {
-		if (fill_level)
-			rx_queue->min_fill = fill_level;
-	}
-
-	batch_size = efx->rx_pages_per_batch * efx->rx_bufs_per_page;
-	space = rx_queue->max_fill - fill_level;
-	EFX_WARN_ON_ONCE_PARANOID(space < batch_size);
-
-	netif_vdbg(rx_queue->efx, rx_status, rx_queue->efx->net_dev,
-		   "RX queue %d fast-filling descriptor ring from"
-		   " level %d to level %d\n",
-		   efx_rx_queue_index(rx_queue), fill_level,
-		   rx_queue->max_fill);
-
-
-	do {
-		rc = efx_init_rx_buffers(rx_queue, atomic);
-		if (unlikely(rc)) {
-			/* Ensure that we don't leave the rx queue empty */
-			efx_schedule_slow_fill(rx_queue);
-			goto out;
-		}
-	} while ((space -= batch_size) >= batch_size);
-
-	netif_vdbg(rx_queue->efx, rx_status, rx_queue->efx->net_dev,
-		   "RX queue %d fast-filled descriptor ring "
-		   "to level %d\n", efx_rx_queue_index(rx_queue),
-		   rx_queue->added_count - rx_queue->removed_count);
-
- out:
-	if (rx_queue->notified_count != rx_queue->added_count)
-		efx_nic_notify_rx_desc(rx_queue);
-}
-
-void efx_rx_slow_fill(struct timer_list *t)
-{
-	struct efx_rx_queue *rx_queue = from_timer(rx_queue, t, slow_fill);
-
-	/* Post an event to cause NAPI to run and refill the queue */
-	efx_nic_generate_fill_event(rx_queue);
-	++rx_queue->slow_fill_count;
-}
-
 static void efx_rx_packet__check_len(struct efx_rx_queue *rx_queue,
 				     struct efx_rx_buffer *rx_buf,
 				     int len)
@@ -797,41 +583,10 @@ void __efx_rx_packet(struct efx_channel *channel)
 	channel->rx_pkt_n_frags = 0;
 }
 
-int efx_probe_rx_queue(struct efx_rx_queue *rx_queue)
-{
-	struct efx_nic *efx = rx_queue->efx;
-	unsigned int entries;
-	int rc;
-
-	/* Create the smallest power-of-two aligned ring */
-	entries = max(roundup_pow_of_two(efx->rxq_entries), EFX_MIN_DMAQ_SIZE);
-	EFX_WARN_ON_PARANOID(entries > EFX_MAX_DMAQ_SIZE);
-	rx_queue->ptr_mask = entries - 1;
-
-	netif_dbg(efx, probe, efx->net_dev,
-		  "creating RX queue %d size %#x mask %#x\n",
-		  efx_rx_queue_index(rx_queue), efx->rxq_entries,
-		  rx_queue->ptr_mask);
-
-	/* Allocate RX buffers */
-	rx_queue->buffer = kcalloc(entries, sizeof(*rx_queue->buffer),
-				   GFP_KERNEL);
-	if (!rx_queue->buffer)
-		return -ENOMEM;
-
-	rc = efx_nic_probe_rx(rx_queue);
-	if (rc) {
-		kfree(rx_queue->buffer);
-		rx_queue->buffer = NULL;
-	}
-
-	return rc;
-}
-
-static void efx_init_rx_recycle_ring(struct efx_nic *efx,
-				     struct efx_rx_queue *rx_queue)
+void efx_init_rx_recycle_ring(struct efx_rx_queue *rx_queue)
 {
 	unsigned int bufs_in_recycle_ring, page_ring_size;
+	struct efx_nic *efx = rx_queue->efx;
 
 	/* Set the RX recycle ring size */
 #ifdef CONFIG_PPC64
@@ -850,121 +605,6 @@ static void efx_init_rx_recycle_ring(struct efx_nic *efx,
 	rx_queue->page_ptr_mask = page_ring_size - 1;
 }
 
-void efx_init_rx_queue(struct efx_rx_queue *rx_queue)
-{
-	struct efx_nic *efx = rx_queue->efx;
-	unsigned int max_fill, trigger, max_trigger;
-	int rc = 0;
-
-	netif_dbg(rx_queue->efx, drv, rx_queue->efx->net_dev,
-		  "initialising RX queue %d\n", efx_rx_queue_index(rx_queue));
-
-	/* Initialise ptr fields */
-	rx_queue->added_count = 0;
-	rx_queue->notified_count = 0;
-	rx_queue->removed_count = 0;
-	rx_queue->min_fill = -1U;
-	efx_init_rx_recycle_ring(efx, rx_queue);
-
-	rx_queue->page_remove = 0;
-	rx_queue->page_add = rx_queue->page_ptr_mask + 1;
-	rx_queue->page_recycle_count = 0;
-	rx_queue->page_recycle_failed = 0;
-	rx_queue->page_recycle_full = 0;
-
-	/* Initialise limit fields */
-	max_fill = efx->rxq_entries - EFX_RXD_HEAD_ROOM;
-	max_trigger =
-		max_fill - efx->rx_pages_per_batch * efx->rx_bufs_per_page;
-	if (rx_refill_threshold != 0) {
-		trigger = max_fill * min(rx_refill_threshold, 100U) / 100U;
-		if (trigger > max_trigger)
-			trigger = max_trigger;
-	} else {
-		trigger = max_trigger;
-	}
-
-	rx_queue->max_fill = max_fill;
-	rx_queue->fast_fill_trigger = trigger;
-	rx_queue->refill_enabled = true;
-
-	/* Initialise XDP queue information */
-	rc = xdp_rxq_info_reg(&rx_queue->xdp_rxq_info, efx->net_dev,
-			      rx_queue->core_index);
-
-	if (rc) {
-		netif_err(efx, rx_err, efx->net_dev,
-			  "Failure to initialise XDP queue information rc=%d\n",
-			  rc);
-		efx->xdp_rxq_info_failed = true;
-	} else {
-		rx_queue->xdp_rxq_info_valid = true;
-	}
-
-	/* Set up RX descriptor ring */
-	efx_nic_init_rx(rx_queue);
-}
-
-void efx_fini_rx_queue(struct efx_rx_queue *rx_queue)
-{
-	int i;
-	struct efx_nic *efx = rx_queue->efx;
-	struct efx_rx_buffer *rx_buf;
-
-	netif_dbg(rx_queue->efx, drv, rx_queue->efx->net_dev,
-		  "shutting down RX queue %d\n", efx_rx_queue_index(rx_queue));
-
-	del_timer_sync(&rx_queue->slow_fill);
-
-	/* Release RX buffers from the current read ptr to the write ptr */
-	if (rx_queue->buffer) {
-		for (i = rx_queue->removed_count; i < rx_queue->added_count;
-		     i++) {
-			unsigned index = i & rx_queue->ptr_mask;
-			rx_buf = efx_rx_buffer(rx_queue, index);
-			efx_fini_rx_buffer(rx_queue, rx_buf);
-		}
-	}
-
-	/* Unmap and release the pages in the recycle ring. Remove the ring. */
-	for (i = 0; i <= rx_queue->page_ptr_mask; i++) {
-		struct page *page = rx_queue->page_ring[i];
-		struct efx_rx_page_state *state;
-
-		if (page == NULL)
-			continue;
-
-		state = page_address(page);
-		dma_unmap_page(&efx->pci_dev->dev, state->dma_addr,
-			       PAGE_SIZE << efx->rx_buffer_order,
-			       DMA_FROM_DEVICE);
-		put_page(page);
-	}
-	kfree(rx_queue->page_ring);
-	rx_queue->page_ring = NULL;
-
-	if (rx_queue->xdp_rxq_info_valid)
-		xdp_rxq_info_unreg(&rx_queue->xdp_rxq_info);
-
-	rx_queue->xdp_rxq_info_valid = false;
-}
-
-void efx_remove_rx_queue(struct efx_rx_queue *rx_queue)
-{
-	netif_dbg(rx_queue->efx, drv, rx_queue->efx->net_dev,
-		  "destroying RX queue %d\n", efx_rx_queue_index(rx_queue));
-
-	efx_nic_remove_rx(rx_queue);
-
-	kfree(rx_queue->buffer);
-	rx_queue->buffer = NULL;
-}
-
-
-module_param(rx_refill_threshold, uint, 0444);
-MODULE_PARM_DESC(rx_refill_threshold,
-		 "RX descriptor ring refill threshold (%)");
-
 #ifdef CONFIG_RFS_ACCEL
 
 static void efx_filter_rfs_work(struct work_struct *data)
diff --git a/drivers/net/ethernet/sfc/rx_common.c b/drivers/net/ethernet/sfc/rx_common.c
new file mode 100644
index 000000000000..f4b5c3d828f6
--- /dev/null
+++ b/drivers/net/ethernet/sfc/rx_common.c
@@ -0,0 +1,375 @@
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
+#include <linux/module.h>
+#include "efx.h"
+#include "nic.h"
+#include "rx_common.h"
+
+/* This is the percentage fill level below which new RX descriptors
+ * will be added to the RX descriptor ring.
+ */
+static unsigned int rx_refill_threshold;
+module_param(rx_refill_threshold, uint, 0444);
+MODULE_PARM_DESC(rx_refill_threshold,
+		 "RX descriptor ring refill threshold (%)");
+
+/* RX maximum head room required.
+ *
+ * This must be at least 1 to prevent overflow, plus one packet-worth
+ * to allow pipelined receives.
+ */
+#define EFX_RXD_HEAD_ROOM (1 + EFX_RX_MAX_FRAGS)
+
+static void efx_fini_rx_buffer(struct efx_rx_queue *rx_queue,
+			       struct efx_rx_buffer *rx_buf)
+{
+	/* Release the page reference we hold for the buffer. */
+	if (rx_buf->page)
+		put_page(rx_buf->page);
+
+	/* If this is the last buffer in a page, unmap and free it. */
+	if (rx_buf->flags & EFX_RX_BUF_LAST_IN_PAGE) {
+		efx_unmap_rx_buffer(rx_queue->efx, rx_buf);
+		efx_free_rx_buffers(rx_queue, rx_buf, 1);
+	}
+	rx_buf->page = NULL;
+}
+
+int efx_probe_rx_queue(struct efx_rx_queue *rx_queue)
+{
+	struct efx_nic *efx = rx_queue->efx;
+	unsigned int entries;
+	int rc;
+
+	/* Create the smallest power-of-two aligned ring */
+	entries = max(roundup_pow_of_two(efx->rxq_entries), EFX_MIN_DMAQ_SIZE);
+	EFX_WARN_ON_PARANOID(entries > EFX_MAX_DMAQ_SIZE);
+	rx_queue->ptr_mask = entries - 1;
+
+	netif_dbg(efx, probe, efx->net_dev,
+		  "creating RX queue %d size %#x mask %#x\n",
+		  efx_rx_queue_index(rx_queue), efx->rxq_entries,
+		  rx_queue->ptr_mask);
+
+	/* Allocate RX buffers */
+	rx_queue->buffer = kcalloc(entries, sizeof(*rx_queue->buffer),
+				   GFP_KERNEL);
+	if (!rx_queue->buffer)
+		return -ENOMEM;
+
+	rc = efx_nic_probe_rx(rx_queue);
+	if (rc) {
+		kfree(rx_queue->buffer);
+		rx_queue->buffer = NULL;
+	}
+
+	return rc;
+}
+
+void efx_init_rx_queue(struct efx_rx_queue *rx_queue)
+{
+	unsigned int max_fill, trigger, max_trigger;
+	struct efx_nic *efx = rx_queue->efx;
+	int rc = 0;
+
+	netif_dbg(rx_queue->efx, drv, rx_queue->efx->net_dev,
+		  "initialising RX queue %d\n", efx_rx_queue_index(rx_queue));
+
+	/* Initialise ptr fields */
+	rx_queue->added_count = 0;
+	rx_queue->notified_count = 0;
+	rx_queue->removed_count = 0;
+	rx_queue->min_fill = -1U;
+	efx_init_rx_recycle_ring(rx_queue);
+
+	rx_queue->page_remove = 0;
+	rx_queue->page_add = rx_queue->page_ptr_mask + 1;
+	rx_queue->page_recycle_count = 0;
+	rx_queue->page_recycle_failed = 0;
+	rx_queue->page_recycle_full = 0;
+
+	/* Initialise limit fields */
+	max_fill = efx->rxq_entries - EFX_RXD_HEAD_ROOM;
+	max_trigger =
+		max_fill - efx->rx_pages_per_batch * efx->rx_bufs_per_page;
+	if (rx_refill_threshold != 0) {
+		trigger = max_fill * min(rx_refill_threshold, 100U) / 100U;
+		if (trigger > max_trigger)
+			trigger = max_trigger;
+	} else {
+		trigger = max_trigger;
+	}
+
+	rx_queue->max_fill = max_fill;
+	rx_queue->fast_fill_trigger = trigger;
+	rx_queue->refill_enabled = true;
+
+	/* Initialise XDP queue information */
+	rc = xdp_rxq_info_reg(&rx_queue->xdp_rxq_info, efx->net_dev,
+			      rx_queue->core_index);
+
+	if (rc) {
+		netif_err(efx, rx_err, efx->net_dev,
+			  "Failure to initialise XDP queue information rc=%d\n",
+			  rc);
+		efx->xdp_rxq_info_failed = true;
+	} else {
+		rx_queue->xdp_rxq_info_valid = true;
+	}
+
+	/* Set up RX descriptor ring */
+	efx_nic_init_rx(rx_queue);
+}
+
+void efx_fini_rx_queue(struct efx_rx_queue *rx_queue)
+{
+	struct efx_nic *efx = rx_queue->efx;
+	struct efx_rx_buffer *rx_buf;
+	int i;
+
+	netif_dbg(rx_queue->efx, drv, rx_queue->efx->net_dev,
+		  "shutting down RX queue %d\n", efx_rx_queue_index(rx_queue));
+
+	del_timer_sync(&rx_queue->slow_fill);
+
+	/* Release RX buffers from the current read ptr to the write ptr */
+	if (rx_queue->buffer) {
+		for (i = rx_queue->removed_count; i < rx_queue->added_count;
+		     i++) {
+			unsigned int index = i & rx_queue->ptr_mask;
+
+			rx_buf = efx_rx_buffer(rx_queue, index);
+			efx_fini_rx_buffer(rx_queue, rx_buf);
+		}
+	}
+
+	/* Unmap and release the pages in the recycle ring. Remove the ring. */
+	for (i = 0; i <= rx_queue->page_ptr_mask; i++) {
+		struct page *page = rx_queue->page_ring[i];
+		struct efx_rx_page_state *state;
+
+		if (page == NULL)
+			continue;
+
+		state = page_address(page);
+		dma_unmap_page(&efx->pci_dev->dev, state->dma_addr,
+			       PAGE_SIZE << efx->rx_buffer_order,
+			       DMA_FROM_DEVICE);
+		put_page(page);
+	}
+	kfree(rx_queue->page_ring);
+	rx_queue->page_ring = NULL;
+
+	if (rx_queue->xdp_rxq_info_valid)
+		xdp_rxq_info_unreg(&rx_queue->xdp_rxq_info);
+
+	rx_queue->xdp_rxq_info_valid = false;
+}
+
+void efx_remove_rx_queue(struct efx_rx_queue *rx_queue)
+{
+	netif_dbg(rx_queue->efx, drv, rx_queue->efx->net_dev,
+		  "destroying RX queue %d\n", efx_rx_queue_index(rx_queue));
+
+	efx_nic_remove_rx(rx_queue);
+
+	kfree(rx_queue->buffer);
+	rx_queue->buffer = NULL;
+}
+
+/* Unmap a DMA-mapped page.  This function is only called for the final RX
+ * buffer in a page.
+ */
+void efx_unmap_rx_buffer(struct efx_nic *efx,
+			 struct efx_rx_buffer *rx_buf)
+{
+	struct page *page = rx_buf->page;
+
+	if (page) {
+		struct efx_rx_page_state *state = page_address(page);
+
+		dma_unmap_page(&efx->pci_dev->dev,
+			       state->dma_addr,
+			       PAGE_SIZE << efx->rx_buffer_order,
+			       DMA_FROM_DEVICE);
+	}
+}
+
+void efx_free_rx_buffers(struct efx_rx_queue *rx_queue,
+			 struct efx_rx_buffer *rx_buf,
+			 unsigned int num_bufs)
+{
+	do {
+		if (rx_buf->page) {
+			put_page(rx_buf->page);
+			rx_buf->page = NULL;
+		}
+		rx_buf = efx_rx_buf_next(rx_queue, rx_buf);
+	} while (--num_bufs);
+}
+
+void efx_rx_slow_fill(struct timer_list *t)
+{
+	struct efx_rx_queue *rx_queue = from_timer(rx_queue, t, slow_fill);
+
+	/* Post an event to cause NAPI to run and refill the queue */
+	efx_nic_generate_fill_event(rx_queue);
+	++rx_queue->slow_fill_count;
+}
+
+void efx_schedule_slow_fill(struct efx_rx_queue *rx_queue)
+{
+	mod_timer(&rx_queue->slow_fill, jiffies + msecs_to_jiffies(10));
+}
+
+/* efx_init_rx_buffers - create EFX_RX_BATCH page-based RX buffers
+ *
+ * @rx_queue:		Efx RX queue
+ *
+ * This allocates a batch of pages, maps them for DMA, and populates
+ * struct efx_rx_buffers for each one. Return a negative error code or
+ * 0 on success. If a single page can be used for multiple buffers,
+ * then the page will either be inserted fully, or not at all.
+ */
+static int efx_init_rx_buffers(struct efx_rx_queue *rx_queue, bool atomic)
+{
+	unsigned int page_offset, index, count;
+	struct efx_nic *efx = rx_queue->efx;
+	struct efx_rx_page_state *state;
+	struct efx_rx_buffer *rx_buf;
+	dma_addr_t dma_addr;
+	struct page *page;
+
+	count = 0;
+	do {
+		page = efx_reuse_page(rx_queue);
+		if (page == NULL) {
+			page = alloc_pages(__GFP_COMP |
+					   (atomic ? GFP_ATOMIC : GFP_KERNEL),
+					   efx->rx_buffer_order);
+			if (unlikely(page == NULL))
+				return -ENOMEM;
+			dma_addr =
+				dma_map_page(&efx->pci_dev->dev, page, 0,
+					     PAGE_SIZE << efx->rx_buffer_order,
+					     DMA_FROM_DEVICE);
+			if (unlikely(dma_mapping_error(&efx->pci_dev->dev,
+						       dma_addr))) {
+				__free_pages(page, efx->rx_buffer_order);
+				return -EIO;
+			}
+			state = page_address(page);
+			state->dma_addr = dma_addr;
+		} else {
+			state = page_address(page);
+			dma_addr = state->dma_addr;
+		}
+
+		dma_addr += sizeof(struct efx_rx_page_state);
+		page_offset = sizeof(struct efx_rx_page_state);
+
+		do {
+			index = rx_queue->added_count & rx_queue->ptr_mask;
+			rx_buf = efx_rx_buffer(rx_queue, index);
+			rx_buf->dma_addr = dma_addr + efx->rx_ip_align +
+					   XDP_PACKET_HEADROOM;
+			rx_buf->page = page;
+			rx_buf->page_offset = page_offset + efx->rx_ip_align +
+					      XDP_PACKET_HEADROOM;
+			rx_buf->len = efx->rx_dma_len;
+			rx_buf->flags = 0;
+			++rx_queue->added_count;
+			get_page(page);
+			dma_addr += efx->rx_page_buf_step;
+			page_offset += efx->rx_page_buf_step;
+		} while (page_offset + efx->rx_page_buf_step <= PAGE_SIZE);
+
+		rx_buf->flags = EFX_RX_BUF_LAST_IN_PAGE;
+	} while (++count < efx->rx_pages_per_batch);
+
+	return 0;
+}
+
+void efx_rx_config_page_split(struct efx_nic *efx)
+{
+	efx->rx_page_buf_step = ALIGN(efx->rx_dma_len + efx->rx_ip_align +
+				      XDP_PACKET_HEADROOM,
+				      EFX_RX_BUF_ALIGNMENT);
+	efx->rx_bufs_per_page = efx->rx_buffer_order ? 1 :
+		((PAGE_SIZE - sizeof(struct efx_rx_page_state)) /
+		efx->rx_page_buf_step);
+	efx->rx_buffer_truesize = (PAGE_SIZE << efx->rx_buffer_order) /
+		efx->rx_bufs_per_page;
+	efx->rx_pages_per_batch = DIV_ROUND_UP(EFX_RX_PREFERRED_BATCH,
+					       efx->rx_bufs_per_page);
+}
+
+/* efx_fast_push_rx_descriptors - push new RX descriptors quickly
+ * @rx_queue:		RX descriptor queue
+ *
+ * This will aim to fill the RX descriptor queue up to
+ * @rx_queue->@max_fill. If there is insufficient atomic
+ * memory to do so, a slow fill will be scheduled.
+ *
+ * The caller must provide serialisation (none is used here). In practise,
+ * this means this function must run from the NAPI handler, or be called
+ * when NAPI is disabled.
+ */
+void efx_fast_push_rx_descriptors(struct efx_rx_queue *rx_queue, bool atomic)
+{
+	struct efx_nic *efx = rx_queue->efx;
+	unsigned int fill_level, batch_size;
+	int space, rc = 0;
+
+	if (!rx_queue->refill_enabled)
+		return;
+
+	/* Calculate current fill level, and exit if we don't need to fill */
+	fill_level = (rx_queue->added_count - rx_queue->removed_count);
+	EFX_WARN_ON_ONCE_PARANOID(fill_level > rx_queue->efx->rxq_entries);
+	if (fill_level >= rx_queue->fast_fill_trigger)
+		goto out;
+
+	/* Record minimum fill level */
+	if (unlikely(fill_level < rx_queue->min_fill)) {
+		if (fill_level)
+			rx_queue->min_fill = fill_level;
+	}
+
+	batch_size = efx->rx_pages_per_batch * efx->rx_bufs_per_page;
+	space = rx_queue->max_fill - fill_level;
+	EFX_WARN_ON_ONCE_PARANOID(space < batch_size);
+
+	netif_vdbg(rx_queue->efx, rx_status, rx_queue->efx->net_dev,
+		   "RX queue %d fast-filling descriptor ring from"
+		   " level %d to level %d\n",
+		   efx_rx_queue_index(rx_queue), fill_level,
+		   rx_queue->max_fill);
+
+	do {
+		rc = efx_init_rx_buffers(rx_queue, atomic);
+		if (unlikely(rc)) {
+			/* Ensure that we don't leave the rx queue empty */
+			efx_schedule_slow_fill(rx_queue);
+			goto out;
+		}
+	} while ((space -= batch_size) >= batch_size);
+
+	netif_vdbg(rx_queue->efx, rx_status, rx_queue->efx->net_dev,
+		   "RX queue %d fast-filled descriptor ring "
+		   "to level %d\n", efx_rx_queue_index(rx_queue),
+		   rx_queue->added_count - rx_queue->removed_count);
+
+ out:
+	if (rx_queue->notified_count != rx_queue->added_count)
+		efx_nic_notify_rx_desc(rx_queue);
+}
-- 
2.20.1


