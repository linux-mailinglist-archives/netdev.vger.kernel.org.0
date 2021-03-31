Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 731753507DE
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 22:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236492AbhCaUJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 16:09:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236447AbhCaUJY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 16:09:24 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 455B9C061574;
        Wed, 31 Mar 2021 13:09:24 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id b7so31931967ejv.1;
        Wed, 31 Mar 2021 13:09:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pbfYOKlFHsXF40sLBKyQ78Q/VfFbjPutp9+/RisrADk=;
        b=R0m3jt6ky2SsYhQnDS9197xHhBtr0x3/hPzCkGuFmr8XCgP3JROVUaGkVoQ+LO3rYJ
         W/bo9rgU8iaGQy6EFjklxb7g+wiq04PCVEzB5gLBf8eK4FH+DgOcPp0brRbNW8x23Khd
         F6RSGUIbIm/+jjteVLF5Ti3Svv7w0YF53J2uYzdMZ6m3dYOo6ienPrcBTDP8FwQycK8T
         zvZ87X4GpS0r1zwuBzdd3j2izLPlYLz3YrR7DafoUrQDMgboQlA6atRP+Z/kBe1rhmnS
         +QJXjFXoKu1+TJgU5Bw9OnsLQuhjyGVDc/9IiijEDo4c3HP6DvxhioXGpFXJe9RGXkuL
         LkCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pbfYOKlFHsXF40sLBKyQ78Q/VfFbjPutp9+/RisrADk=;
        b=XHBiV6rwhRP9/QM1ulrUvI2tYE9crQv5R1Q9cmKfE5InoJ8FxyUtPiyfmAwv3Yz0X8
         WUbheS8sOEhHuLLIm4Tb0OrbgG/DLHYdG4WtFDcFlcYbdvRUlHFtsNjGmHyGTAmGu5+q
         fZSeRqK01n3Hzcg0Y03yYiRrsfDsbn99k7y4Quu6sfeTeR74QcC1HeEq6tzzgcTaXUId
         4Y1rXHtB9VMwoCQSIR2Lsuam/3pu8or4+ZfSsbFPhxmyUNZ6+hSU4pJsfGHviNvodhuU
         XkOAXjpERKEnyLVV796AHdLhFOcl+kmkvTDFHO0E1vQrBBJ1g3hB13dcALdHfgSt0ggj
         XOLw==
X-Gm-Message-State: AOAM532aG657jsCZatd0s7dDghRI6ZxIu6ydKPycXAWRtiSbZmdNeeDz
        ufr/0L8pxR32uQu7UV8zfrY=
X-Google-Smtp-Source: ABdhPJzNsEM/kAjNBL++KAz4+hneduzX59nEPlzi/ZwE7wBkDI0YO3vq19NP6Zex0Z+jWE+52JAT9A==
X-Received: by 2002:a17:906:3648:: with SMTP id r8mr5635018ejb.58.1617221362875;
        Wed, 31 Mar 2021 13:09:22 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id r19sm1691305ejr.55.2021.03.31.13.09.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Mar 2021 13:09:22 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 7/9] net: enetc: add support for XDP_TX
Date:   Wed, 31 Mar 2021 23:08:55 +0300
Message-Id: <20210331200857.3274425-8-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210331200857.3274425-1-olteanv@gmail.com>
References: <20210331200857.3274425-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

For reflecting packets back into the interface they came from, we create
an array of TX software BDs derived from the RX software BDs. Therefore,
we need to extend the TX software BD structure to contain most of the
stuff that's already present in the RX software BD structure, for
reasons that will become evident in a moment.

For a frame with the XDP_TX verdict, we don't reuse any buffer right
away as we do for XDP_DROP (the same page half) or XDP_PASS (the other
page half, same as the skb code path).

Because the buffer transfers ownership from the RX ring to the TX ring,
reusing any page half right away is very dangerous. So what we can do is
we can recycle the same page half as soon as TX is complete.

The code path is:
enetc_poll
-> enetc_clean_rx_ring_xdp
   -> enetc_xdp_tx
   -> enetc_refill_rx_ring
(time passes, another MSI interrupt is raised)
enetc_poll
-> enetc_clean_tx_ring
   -> enetc_recycle_xdp_tx_buff

But that creates a problem, because there is a potentially large time
window between enetc_xdp_tx and enetc_recycle_xdp_tx_buff, period in
which we'll have less and less RX buffers.

Basically, when the ship starts sinking, the knee-jerk reaction is to
let enetc_refill_rx_ring do what it does for the standard skb code path
(refill every 16 consumed buffers), but that turns out to be very
inefficient. The problem is that we have no rx_swbd->page at our
disposal from the enetc_reuse_page path, so enetc_refill_rx_ring would
have to call enetc_new_page for every buffer that we refill (if we
choose to refill at this early stage). Very inefficient, it only makes
the problem worse, because page allocation is an expensive process, and
CPU time is exactly what we're lacking.

Additionally, there is an even bigger problem: if we let
enetc_refill_rx_ring top up the ring's buffers again from the RX path,
remember that the buffers sent to transmission haven't disappeared
anywhere. They will be eventually sent, and processed in
enetc_clean_tx_ring, and an attempt will be made to recycle them.
But surprise, the RX ring is already full of new buffers, because we
were premature in deciding that we should refill. So not only we took
the expensive decision of allocating new pages, but now we must throw
away perfectly good and reusable buffers.

So what we do is we implement an elastic refill mechanism, which keeps
track of the number of in-flight XDP_TX buffer descriptors. We top up
the RX ring only up to the total ring capacity minus the number of BDs
that are in flight (because we know that those BDs will return to us
eventually).

The enetc driver manages 1 RX ring per CPU, and the default TX ring
management is the same. So we do XDP_TX towards the TX ring of the same
index, because it is affined to the same CPU. This will probably not
produce great results when we have a tc-taprio/tc-mqprio qdisc on the
interface, because in that case, the number of TX rings might be
greater, but I didn't add any checks for that yet (mostly because I
didn't know what checks to add).

It should also be noted that we need to change the DMA mapping direction
for RX buffers, since they may now be reflected into the TX ring of the
same device. We choose to use DMA_BIDIRECTIONAL instead of unmapping and
remapping as DMA_TO_DEVICE, because performance is better this way.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c  | 217 ++++++++++++++++--
 drivers/net/ethernet/freescale/enetc/enetc.h  |  25 ++
 .../ethernet/freescale/enetc/enetc_ethtool.c  |  11 +-
 3 files changed, 228 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 58bb0b78585a..ba5313a5d7a4 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -8,21 +8,20 @@
 #include <linux/vmalloc.h>
 #include <net/pkt_sched.h>
 
-/* ENETC overhead: optional extension BD + 1 BD gap */
-#define ENETC_TXBDS_NEEDED(val)	((val) + 2)
-/* max # of chained Tx BDs is 15, including head and extension BD */
-#define ENETC_MAX_SKB_FRAGS	13
-#define ENETC_TXBDS_MAX_NEEDED	ENETC_TXBDS_NEEDED(ENETC_MAX_SKB_FRAGS + 1)
-
 static void enetc_unmap_tx_buff(struct enetc_bdr *tx_ring,
 				struct enetc_tx_swbd *tx_swbd)
 {
+	/* For XDP_TX, pages come from RX, whereas for the other contexts where
+	 * we have is_dma_page_set, those come from skb_frag_dma_map. We need
+	 * to match the DMA mapping length, so we need to differentiate those.
+	 */
 	if (tx_swbd->is_dma_page)
 		dma_unmap_page(tx_ring->dev, tx_swbd->dma,
-			       tx_swbd->len, DMA_TO_DEVICE);
+			       tx_swbd->is_xdp_tx ? PAGE_SIZE : tx_swbd->len,
+			       tx_swbd->dir);
 	else
 		dma_unmap_single(tx_ring->dev, tx_swbd->dma,
-				 tx_swbd->len, DMA_TO_DEVICE);
+				 tx_swbd->len, tx_swbd->dir);
 	tx_swbd->dma = 0;
 }
 
@@ -38,6 +37,13 @@ static void enetc_free_tx_skb(struct enetc_bdr *tx_ring,
 	}
 }
 
+/* Let H/W know BD ring has been updated */
+static void enetc_update_tx_ring_tail(struct enetc_bdr *tx_ring)
+{
+	/* includes wmb() */
+	enetc_wr_reg_hot(tx_ring->tpir, tx_ring->next_to_use);
+}
+
 static int enetc_map_tx_buffs(struct enetc_bdr *tx_ring, struct sk_buff *skb,
 			      int active_offloads)
 {
@@ -68,6 +74,7 @@ static int enetc_map_tx_buffs(struct enetc_bdr *tx_ring, struct sk_buff *skb,
 	tx_swbd->dma = dma;
 	tx_swbd->len = len;
 	tx_swbd->is_dma_page = 0;
+	tx_swbd->dir = DMA_TO_DEVICE;
 	count++;
 
 	do_vlan = skb_vlan_tag_present(skb);
@@ -150,6 +157,7 @@ static int enetc_map_tx_buffs(struct enetc_bdr *tx_ring, struct sk_buff *skb,
 		tx_swbd->dma = dma;
 		tx_swbd->len = len;
 		tx_swbd->is_dma_page = 1;
+		tx_swbd->dir = DMA_TO_DEVICE;
 		count++;
 	}
 
@@ -166,8 +174,7 @@ static int enetc_map_tx_buffs(struct enetc_bdr *tx_ring, struct sk_buff *skb,
 
 	skb_tx_timestamp(skb);
 
-	/* let H/W know BD ring has been updated */
-	enetc_wr_reg_hot(tx_ring->tpir, i); /* includes wmb() */
+	enetc_update_tx_ring_tail(tx_ring);
 
 	return count;
 
@@ -320,6 +327,43 @@ static void enetc_tstamp_tx(struct sk_buff *skb, u64 tstamp)
 	}
 }
 
+static void enetc_recycle_xdp_tx_buff(struct enetc_bdr *tx_ring,
+				      struct enetc_tx_swbd *tx_swbd)
+{
+	struct enetc_ndev_priv *priv = netdev_priv(tx_ring->ndev);
+	struct enetc_bdr *rx_ring = priv->rx_ring[tx_ring->index];
+	struct enetc_rx_swbd rx_swbd = {
+		.dma = tx_swbd->dma,
+		.page = tx_swbd->page,
+		.page_offset = tx_swbd->page_offset,
+		.dir = tx_swbd->dir,
+		.len = tx_swbd->len,
+	};
+
+	if (likely(enetc_swbd_unused(rx_ring))) {
+		enetc_reuse_page(rx_ring, &rx_swbd);
+
+		/* sync for use by the device */
+		dma_sync_single_range_for_device(rx_ring->dev, rx_swbd.dma,
+						 rx_swbd.page_offset,
+						 ENETC_RXB_DMA_SIZE_XDP,
+						 rx_swbd.dir);
+
+		rx_ring->stats.recycles++;
+	} else {
+		/* RX ring is already full, we need to unmap and free the
+		 * page, since there's nothing useful we can do with it.
+		 */
+		rx_ring->stats.recycle_failures++;
+
+		dma_unmap_page(rx_ring->dev, rx_swbd.dma, PAGE_SIZE,
+			       rx_swbd.dir);
+		__free_page(rx_swbd.page);
+	}
+
+	rx_ring->xdp.xdp_tx_in_flight--;
+}
+
 static bool enetc_clean_tx_ring(struct enetc_bdr *tx_ring, int napi_budget)
 {
 	struct net_device *ndev = tx_ring->ndev;
@@ -351,7 +395,9 @@ static bool enetc_clean_tx_ring(struct enetc_bdr *tx_ring, int napi_budget)
 			}
 		}
 
-		if (likely(tx_swbd->dma))
+		if (tx_swbd->is_xdp_tx)
+			enetc_recycle_xdp_tx_buff(tx_ring, tx_swbd);
+		else if (likely(tx_swbd->dma))
 			enetc_unmap_tx_buff(tx_ring, tx_swbd);
 
 		if (tx_swbd->skb) {
@@ -405,6 +451,7 @@ static bool enetc_clean_tx_ring(struct enetc_bdr *tx_ring, int napi_budget)
 static bool enetc_new_page(struct enetc_bdr *rx_ring,
 			   struct enetc_rx_swbd *rx_swbd)
 {
+	bool xdp = !!(rx_ring->xdp.prog);
 	struct page *page;
 	dma_addr_t addr;
 
@@ -412,7 +459,10 @@ static bool enetc_new_page(struct enetc_bdr *rx_ring,
 	if (unlikely(!page))
 		return false;
 
-	addr = dma_map_page(rx_ring->dev, page, 0, PAGE_SIZE, DMA_FROM_DEVICE);
+	/* For XDP_TX, we forgo dma_unmap -> dma_map */
+	rx_swbd->dir = xdp ? DMA_BIDIRECTIONAL : DMA_FROM_DEVICE;
+
+	addr = dma_map_page(rx_ring->dev, page, 0, PAGE_SIZE, rx_swbd->dir);
 	if (unlikely(dma_mapping_error(rx_ring->dev, addr))) {
 		__free_page(page);
 
@@ -536,6 +586,10 @@ static void enetc_get_offloads(struct enetc_bdr *rx_ring,
 #endif
 }
 
+/* This gets called during the non-XDP NAPI poll cycle as well as on XDP_PASS,
+ * so it needs to work with both DMA_FROM_DEVICE as well as DMA_BIDIRECTIONAL
+ * mapped buffers.
+ */
 static struct enetc_rx_swbd *enetc_get_rx_buff(struct enetc_bdr *rx_ring,
 					       int i, u16 size)
 {
@@ -543,7 +597,7 @@ static struct enetc_rx_swbd *enetc_get_rx_buff(struct enetc_bdr *rx_ring,
 
 	dma_sync_single_range_for_cpu(rx_ring->dev, rx_swbd->dma,
 				      rx_swbd->page_offset,
-				      size, DMA_FROM_DEVICE);
+				      size, rx_swbd->dir);
 	return rx_swbd;
 }
 
@@ -561,10 +615,10 @@ static void enetc_put_rx_buff(struct enetc_bdr *rx_ring,
 		/* sync for use by the device */
 		dma_sync_single_range_for_device(rx_ring->dev, rx_swbd->dma,
 						 rx_swbd->page_offset,
-						 buffer_size, DMA_FROM_DEVICE);
+						 buffer_size, rx_swbd->dir);
 	} else {
-		dma_unmap_page(rx_ring->dev, rx_swbd->dma,
-			       PAGE_SIZE, DMA_FROM_DEVICE);
+		dma_unmap_page(rx_ring->dev, rx_swbd->dma, PAGE_SIZE,
+			       rx_swbd->dir);
 	}
 
 	rx_swbd->page = NULL;
@@ -718,6 +772,61 @@ static int enetc_clean_rx_ring(struct enetc_bdr *rx_ring,
 	return rx_frm_cnt;
 }
 
+static void enetc_xdp_map_tx_buff(struct enetc_bdr *tx_ring, int i,
+				  struct enetc_tx_swbd *tx_swbd,
+				  int frm_len)
+{
+	union enetc_tx_bd *txbd = ENETC_TXBD(*tx_ring, i);
+
+	prefetchw(txbd);
+
+	enetc_clear_tx_bd(txbd);
+	txbd->addr = cpu_to_le64(tx_swbd->dma + tx_swbd->page_offset);
+	txbd->buf_len = cpu_to_le16(tx_swbd->len);
+	txbd->frm_len = cpu_to_le16(frm_len);
+
+	memcpy(&tx_ring->tx_swbd[i], tx_swbd, sizeof(*tx_swbd));
+}
+
+/* Puts in the TX ring one XDP frame, mapped as an array of TX software buffer
+ * descriptors.
+ */
+static bool enetc_xdp_tx(struct enetc_bdr *tx_ring,
+			 struct enetc_tx_swbd *xdp_tx_arr, int num_tx_swbd)
+{
+	struct enetc_tx_swbd *tmp_tx_swbd = xdp_tx_arr;
+	int i, k, frm_len = tmp_tx_swbd->len;
+
+	if (unlikely(enetc_bd_unused(tx_ring) < ENETC_TXBDS_NEEDED(num_tx_swbd)))
+		return false;
+
+	while (unlikely(!tmp_tx_swbd->is_eof)) {
+		tmp_tx_swbd++;
+		frm_len += tmp_tx_swbd->len;
+	}
+
+	i = tx_ring->next_to_use;
+
+	for (k = 0; k < num_tx_swbd; k++) {
+		struct enetc_tx_swbd *xdp_tx_swbd = &xdp_tx_arr[k];
+
+		enetc_xdp_map_tx_buff(tx_ring, i, xdp_tx_swbd, frm_len);
+
+		/* last BD needs 'F' bit set */
+		if (xdp_tx_swbd->is_eof) {
+			union enetc_tx_bd *txbd = ENETC_TXBD(*tx_ring, i);
+
+			txbd->flags = ENETC_TXBD_FLAGS_F;
+		}
+
+		enetc_bdr_idx_inc(tx_ring, &i);
+	}
+
+	tx_ring->next_to_use = i;
+
+	return true;
+}
+
 static void enetc_map_rx_buff_to_xdp(struct enetc_bdr *rx_ring, int i,
 				     struct xdp_buff *xdp_buff, u16 size)
 {
@@ -725,6 +834,9 @@ static void enetc_map_rx_buff_to_xdp(struct enetc_bdr *rx_ring, int i,
 	void *hard_start = page_address(rx_swbd->page) + rx_swbd->page_offset;
 	struct skb_shared_info *shinfo;
 
+	/* To be used for XDP_TX */
+	rx_swbd->len = size;
+
 	xdp_prepare_buff(xdp_buff, hard_start - rx_ring->buffer_offset,
 			 rx_ring->buffer_offset, size, false);
 
@@ -739,6 +851,9 @@ static void enetc_add_rx_buff_to_xdp(struct enetc_bdr *rx_ring, int i,
 	struct enetc_rx_swbd *rx_swbd = enetc_get_rx_buff(rx_ring, i, size);
 	skb_frag_t *frag = &shinfo->frags[shinfo->nr_frags];
 
+	/* To be used for XDP_TX */
+	rx_swbd->len = size;
+
 	skb_frag_off_set(frag, rx_swbd->page_offset);
 	skb_frag_size_set(frag, size);
 	__skb_frag_set_page(frag, rx_swbd->page);
@@ -780,15 +895,48 @@ static void enetc_put_xdp_buff(struct enetc_bdr *rx_ring,
 {
 	enetc_reuse_page(rx_ring, rx_swbd);
 
-	/* sync for use by the device */
 	dma_sync_single_range_for_device(rx_ring->dev, rx_swbd->dma,
 					 rx_swbd->page_offset,
 					 ENETC_RXB_DMA_SIZE_XDP,
-					 DMA_FROM_DEVICE);
+					 rx_swbd->dir);
 
 	rx_swbd->page = NULL;
 }
 
+/* Convert RX buffer descriptors to TX buffer descriptors. These will be
+ * recycled back into the RX ring in enetc_clean_tx_ring. We need to scrub the
+ * RX software BDs because the ownership of the buffer no longer belongs to the
+ * RX ring, so enetc_refill_rx_ring may not reuse rx_swbd->page.
+ */
+static int enetc_rx_swbd_to_xdp_tx_swbd(struct enetc_tx_swbd *xdp_tx_arr,
+					struct enetc_bdr *rx_ring,
+					int rx_ring_first, int rx_ring_last)
+{
+	int n = 0;
+
+	for (; rx_ring_first != rx_ring_last;
+	     n++, enetc_bdr_idx_inc(rx_ring, &rx_ring_first)) {
+		struct enetc_rx_swbd *rx_swbd = &rx_ring->rx_swbd[rx_ring_first];
+		struct enetc_tx_swbd *tx_swbd = &xdp_tx_arr[n];
+
+		/* No need to dma_map, we already have DMA_BIDIRECTIONAL */
+		tx_swbd->dma = rx_swbd->dma;
+		tx_swbd->dir = rx_swbd->dir;
+		tx_swbd->page = rx_swbd->page;
+		tx_swbd->page_offset = rx_swbd->page_offset;
+		tx_swbd->len = rx_swbd->len;
+		tx_swbd->is_dma_page = true;
+		tx_swbd->is_xdp_tx = true;
+		tx_swbd->is_eof = false;
+		memset(rx_swbd, 0, sizeof(*rx_swbd));
+	}
+
+	/* We rely on caller providing an rx_ring_last > rx_ring_first */
+	xdp_tx_arr[n - 1].is_eof = true;
+
+	return n;
+}
+
 static void enetc_xdp_drop(struct enetc_bdr *rx_ring, int rx_ring_first,
 			   int rx_ring_last)
 {
@@ -804,6 +952,10 @@ static int enetc_clean_rx_ring_xdp(struct enetc_bdr *rx_ring,
 				   struct napi_struct *napi, int work_limit,
 				   struct bpf_prog *prog)
 {
+	struct enetc_tx_swbd xdp_tx_arr[ENETC_MAX_SKB_FRAGS] = {0};
+	struct enetc_ndev_priv *priv = netdev_priv(rx_ring->ndev);
+	struct enetc_bdr *tx_ring = priv->tx_ring[rx_ring->index];
+	int xdp_tx_bd_cnt, xdp_tx_frm_cnt = 0;
 	int rx_frm_cnt = 0, rx_byte_cnt = 0;
 	int cleaned_cnt, i;
 	u32 xdp_act;
@@ -819,10 +971,6 @@ static int enetc_clean_rx_ring_xdp(struct enetc_bdr *rx_ring,
 		struct sk_buff *skb;
 		u32 bd_status;
 
-		if (cleaned_cnt >= ENETC_RXBD_BUNDLE)
-			cleaned_cnt -= enetc_refill_rx_ring(rx_ring,
-							    cleaned_cnt);
-
 		rxbd = enetc_rxbd(rx_ring, i);
 		bd_status = le32_to_cpu(rxbd->r.lstatus);
 		if (!bd_status)
@@ -865,6 +1013,20 @@ static int enetc_clean_rx_ring_xdp(struct enetc_bdr *rx_ring,
 
 			napi_gro_receive(napi, skb);
 			break;
+		case XDP_TX:
+			xdp_tx_bd_cnt = enetc_rx_swbd_to_xdp_tx_swbd(xdp_tx_arr,
+								     rx_ring,
+								     orig_i, i);
+
+			if (!enetc_xdp_tx(tx_ring, xdp_tx_arr, xdp_tx_bd_cnt)) {
+				enetc_xdp_drop(rx_ring, orig_i, i);
+				tx_ring->stats.xdp_tx_drops++;
+			} else {
+				tx_ring->stats.xdp_tx += xdp_tx_bd_cnt;
+				rx_ring->xdp.xdp_tx_in_flight += xdp_tx_bd_cnt;
+				xdp_tx_frm_cnt++;
+			}
+			break;
 		default:
 			bpf_warn_invalid_xdp_action(xdp_act);
 		}
@@ -877,6 +1039,13 @@ static int enetc_clean_rx_ring_xdp(struct enetc_bdr *rx_ring,
 	rx_ring->stats.packets += rx_frm_cnt;
 	rx_ring->stats.bytes += rx_byte_cnt;
 
+	if (xdp_tx_frm_cnt)
+		enetc_update_tx_ring_tail(tx_ring);
+
+	if (cleaned_cnt > rx_ring->xdp.xdp_tx_in_flight)
+		enetc_refill_rx_ring(rx_ring, enetc_bd_unused(rx_ring) -
+				     rx_ring->xdp.xdp_tx_in_flight);
+
 	return rx_frm_cnt;
 }
 
@@ -1141,8 +1310,8 @@ static void enetc_free_rx_ring(struct enetc_bdr *rx_ring)
 		if (!rx_swbd->page)
 			continue;
 
-		dma_unmap_page(rx_ring->dev, rx_swbd->dma,
-			       PAGE_SIZE, DMA_FROM_DEVICE);
+		dma_unmap_page(rx_ring->dev, rx_swbd->dma, PAGE_SIZE,
+			       rx_swbd->dir);
 		__free_page(rx_swbd->page);
 		rx_swbd->page = NULL;
 	}
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index 5815addfe966..864da962ae21 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -21,11 +21,15 @@
 struct enetc_tx_swbd {
 	struct sk_buff *skb;
 	dma_addr_t dma;
+	struct page *page;	/* valid only if is_xdp_tx */
+	u16 page_offset;	/* valid only if is_xdp_tx */
 	u16 len;
+	enum dma_data_direction dir;
 	u8 is_dma_page:1;
 	u8 check_wb:1;
 	u8 do_tstamp:1;
 	u8 is_eof:1;
+	u8 is_xdp_tx:1;
 };
 
 #define ENETC_RX_MAXFRM_SIZE	ENETC_MAC_MAXFRM_SIZE
@@ -40,18 +44,31 @@ struct enetc_rx_swbd {
 	dma_addr_t dma;
 	struct page *page;
 	u16 page_offset;
+	enum dma_data_direction dir;
+	u16 len;
 };
 
+/* ENETC overhead: optional extension BD + 1 BD gap */
+#define ENETC_TXBDS_NEEDED(val)	((val) + 2)
+/* max # of chained Tx BDs is 15, including head and extension BD */
+#define ENETC_MAX_SKB_FRAGS	13
+#define ENETC_TXBDS_MAX_NEEDED	ENETC_TXBDS_NEEDED(ENETC_MAX_SKB_FRAGS + 1)
+
 struct enetc_ring_stats {
 	unsigned int packets;
 	unsigned int bytes;
 	unsigned int rx_alloc_errs;
 	unsigned int xdp_drops;
+	unsigned int xdp_tx;
+	unsigned int xdp_tx_drops;
+	unsigned int recycles;
+	unsigned int recycle_failures;
 };
 
 struct enetc_xdp_data {
 	struct xdp_rxq_info rxq;
 	struct bpf_prog *prog;
+	int xdp_tx_in_flight;
 };
 
 #define ENETC_RX_RING_DEFAULT_SIZE	512
@@ -104,6 +121,14 @@ static inline int enetc_bd_unused(struct enetc_bdr *bdr)
 	return bdr->bd_count + bdr->next_to_clean - bdr->next_to_use - 1;
 }
 
+static inline int enetc_swbd_unused(struct enetc_bdr *bdr)
+{
+	if (bdr->next_to_clean > bdr->next_to_alloc)
+		return bdr->next_to_clean - bdr->next_to_alloc - 1;
+
+	return bdr->bd_count + bdr->next_to_clean - bdr->next_to_alloc - 1;
+}
+
 /* Control BD ring */
 #define ENETC_CBDR_DEFAULT_SIZE	64
 struct enetc_cbdr {
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
index 0183c13f8c1e..37821a8b225e 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
@@ -193,10 +193,14 @@ static const char rx_ring_stats[][ETH_GSTRING_LEN] = {
 	"Rx ring %2d frames",
 	"Rx ring %2d alloc errors",
 	"Rx ring %2d XDP drops",
+	"Rx ring %2d recycles",
+	"Rx ring %2d recycle failures",
 };
 
 static const char tx_ring_stats[][ETH_GSTRING_LEN] = {
 	"Tx ring %2d frames",
+	"Tx ring %2d XDP frames",
+	"Tx ring %2d XDP drops",
 };
 
 static int enetc_get_sset_count(struct net_device *ndev, int sset)
@@ -268,13 +272,18 @@ static void enetc_get_ethtool_stats(struct net_device *ndev,
 	for (i = 0; i < ARRAY_SIZE(enetc_si_counters); i++)
 		data[o++] = enetc_rd64(hw, enetc_si_counters[i].reg);
 
-	for (i = 0; i < priv->num_tx_rings; i++)
+	for (i = 0; i < priv->num_tx_rings; i++) {
 		data[o++] = priv->tx_ring[i]->stats.packets;
+		data[o++] = priv->tx_ring[i]->stats.xdp_tx;
+		data[o++] = priv->tx_ring[i]->stats.xdp_tx_drops;
+	}
 
 	for (i = 0; i < priv->num_rx_rings; i++) {
 		data[o++] = priv->rx_ring[i]->stats.packets;
 		data[o++] = priv->rx_ring[i]->stats.rx_alloc_errs;
 		data[o++] = priv->rx_ring[i]->stats.xdp_drops;
+		data[o++] = priv->rx_ring[i]->stats.recycles;
+		data[o++] = priv->rx_ring[i]->stats.recycle_failures;
 	}
 
 	if (!enetc_si_is_pf(priv->si))
-- 
2.25.1

