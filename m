Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95F523507D9
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 22:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236465AbhCaUJx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 16:09:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236421AbhCaUJX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 16:09:23 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB346C06174A;
        Wed, 31 Mar 2021 13:09:22 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id a7so31925315ejs.3;
        Wed, 31 Mar 2021 13:09:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=j5CGryKzNfO/b/2j2Zt95ia8ciPSb8SKAQXMHdOsDPU=;
        b=qfgUjtbKR+PNknsiwrSNPxn0RLDbm6TQuaXMCWA6VrcFNVQ5IL4967e9sUKVC+COw2
         cMZhsDVypftNJPRxfc62i5D4yEh4bUvXrn82nPCCwS/TWM/ZgcrMJQykzZAXzCLGQmD0
         +3ooaJbTrBwzSh6L9+eYignk6sHDj8eOqOThcUb0m8BOFJ9cjMtIcEDZmK1bE/N6oTNz
         cVfN8ses01TEpvT8YzZ+7AcrYNDoyWB9SHZXI+RvcbEudaqw1CokFhEZNNyaGOr52nwv
         TaG48pJU07zaUJalHzFAsnPZQnIKfXqXvf6QVyOxAmuqZW1uvccHKVRPXkQ71Zpivxiq
         TDrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=j5CGryKzNfO/b/2j2Zt95ia8ciPSb8SKAQXMHdOsDPU=;
        b=ePO8M7fLBTgdq1MonGRdQYssBvitexig3nFUkwz0C2M3z+mcQn5IlbfomWOXZW4H4e
         /Lzp7fNIiM85OoiGzHMVYsQg1FM3AnxQl8Oji82TzHK9uP7KVPpTqXWAxuFc0XE0fzXF
         iKwYkbqP6zHrwo/PublWqR/eeQdK6KpcM+PfRvLO1ltlhtVLD55+/YB3EtPOvWjLCdGb
         LEgOqI7V7oN7qjDRHFLFq2M62eDsYZJfOoh9BnOZ6kqDRFbg6AuFJ88w5fScotKC1oKs
         7xIv/0/zFZWUy99P5tCBYwyc0bDy790yJS4WSrYCzYjJ2XiNKjhg/aM1P5HxNx8Y7Np0
         yjaA==
X-Gm-Message-State: AOAM530qGK3ZxMviGcJAGC9OJPcyVQqM+LnZpXbjNAzb895OnNSCgj7X
        yy3sp359Twh1OnqGNNpcabU=
X-Google-Smtp-Source: ABdhPJzlld0T9y+/visjkyjinbCUMSCHbRqyrOlA9PeTIximnavwLfoJLEK1yxUml+JcViB3h/Szng==
X-Received: by 2002:a17:906:dfcc:: with SMTP id jt12mr5507911ejc.31.1617221361380;
        Wed, 31 Mar 2021 13:09:21 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id r19sm1691305ejr.55.2021.03.31.13.09.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Mar 2021 13:09:20 -0700 (PDT)
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
Subject: [PATCH net-next 6/9] net: enetc: add support for XDP_DROP and XDP_PASS
Date:   Wed, 31 Mar 2021 23:08:54 +0300
Message-Id: <20210331200857.3274425-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210331200857.3274425-1-olteanv@gmail.com>
References: <20210331200857.3274425-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

For the RX ring, enetc uses an allocation scheme based on pages split
into two buffers, which is already very efficient in terms of preventing
reallocations / maximizing reuse, so I see no reason why I would change
that.

 +--------+--------+--------+--------+--------+--------+--------+
 |        |        |        |        |        |        |        |
 | half B | half B | half B | half B | half B | half B | half B |
 |        |        |        |        |        |        |        |
 +--------+--------+--------+--------+--------+--------+--------+
 |        |        |        |        |        |        |        |
 | half A | half A | half A | half A | half A | half A | half A | RX ring
 |        |        |        |        |        |        |        |
 +--------+--------+--------+--------+--------+--------+--------+
     ^                                                     ^
     |                                                     |
 next_to_clean                                       next_to_alloc
                                                      next_to_use

                   +--------+--------+--------+--------+--------+
                   |        |        |        |        |        |
                   | half B | half B | half B | half B | half B |
                   |        |        |        |        |        |
 +--------+--------+--------+--------+--------+--------+--------+
 |        |        |        |        |        |        |        |
 | half B | half B | half A | half A | half A | half A | half A | RX ring
 |        |        |        |        |        |        |        |
 +--------+--------+--------+--------+--------+--------+--------+
 |        |        |   ^                                   ^
 | half A | half A |   |                                   |
 |        |        | next_to_clean                   next_to_use
 +--------+--------+
              ^
              |
         next_to_alloc

then when enetc_refill_rx_ring is called, whose purpose is to advance
next_to_use, it sees that it can take buffers up to next_to_alloc, and
it says "oh, hey, rx_swbd->page isn't NULL, I don't need to allocate
one!".

The only problem is that for default PAGE_SIZE values of 4096, buffer
sizes are 2048 bytes. While this is enough for normal skb allocations at
an MTU of 1500 bytes, for XDP it isn't, because the XDP headroom is 256
bytes, and including skb_shared_info and alignment, we end up being able
to make use of only 1472 bytes, which is insufficient for the default
MTU.

To solve that problem, we implement scatter/gather processing in the
driver, because we would really like to keep the existing allocation
scheme. A packet of 1500 bytes is received in a buffer of 1472 bytes and
another one of 28 bytes.

Because the headroom required by XDP is different (and much larger) than
the one required by the network stack, whenever a BPF program is added
or deleted on the port, we drain the existing RX buffers and seed new
ones with the required headroom. We also keep the required headroom in
rx_ring->buffer_offset.

The simplest way to implement XDP_PASS, where an skb must be created, is
to create an xdp_buff based on the next_to_clean RX BDs, but not clear
those BDs from the RX ring yet, just keep the original index at which
the BDs for this frame started. Then, if the verdict is XDP_PASS,
instead of converting the xdb_buff to an skb, we replay a call to
enetc_build_skb (just as in the normal enetc_clean_rx_ring case),
starting from the original BD index.

We would also like to be minimally invasive to the regular RX data path,
and not check whether there is a BPF program attached to the ring on
every packet. So we create a separate RX ring processing function for
XDP.

Because we only install/remove the BPF program while the interface is
down, we forgo the rcu_read_lock() in enetc_clean_rx_ring, since there
shouldn't be any circumstance in which we are processing packets and
there is a potentially freed BPF program attached to the RX ring.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c  | 284 ++++++++++++++++--
 drivers/net/ethernet/freescale/enetc/enetc.h  |  14 +
 .../ethernet/freescale/enetc/enetc_ethtool.c  |   2 +
 .../net/ethernet/freescale/enetc/enetc_pf.c   |   1 +
 4 files changed, 281 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 38301d0d7f0c..58bb0b78585a 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -2,6 +2,7 @@
 /* Copyright 2017-2019 NXP */
 
 #include "enetc.h"
+#include <linux/bpf_trace.h>
 #include <linux/tcp.h>
 #include <linux/udp.h>
 #include <linux/vmalloc.h>
@@ -420,7 +421,7 @@ static bool enetc_new_page(struct enetc_bdr *rx_ring,
 
 	rx_swbd->dma = addr;
 	rx_swbd->page = page;
-	rx_swbd->page_offset = ENETC_RXB_PAD;
+	rx_swbd->page_offset = rx_ring->buffer_offset;
 
 	return true;
 }
@@ -550,6 +551,8 @@ static void enetc_put_rx_buff(struct enetc_bdr *rx_ring,
 			      struct enetc_rx_swbd *rx_swbd)
 {
 	if (likely(enetc_page_reusable(rx_swbd->page))) {
+		size_t buffer_size = ENETC_RXB_TRUESIZE - rx_ring->buffer_offset;
+
 		rx_swbd->page_offset ^= ENETC_RXB_TRUESIZE;
 		page_ref_inc(rx_swbd->page);
 
@@ -558,8 +561,7 @@ static void enetc_put_rx_buff(struct enetc_bdr *rx_ring,
 		/* sync for use by the device */
 		dma_sync_single_range_for_device(rx_ring->dev, rx_swbd->dma,
 						 rx_swbd->page_offset,
-						 ENETC_RXB_DMA_SIZE,
-						 DMA_FROM_DEVICE);
+						 buffer_size, DMA_FROM_DEVICE);
 	} else {
 		dma_unmap_page(rx_ring->dev, rx_swbd->dma,
 			       PAGE_SIZE, DMA_FROM_DEVICE);
@@ -576,13 +578,13 @@ static struct sk_buff *enetc_map_rx_buff_to_skb(struct enetc_bdr *rx_ring,
 	void *ba;
 
 	ba = page_address(rx_swbd->page) + rx_swbd->page_offset;
-	skb = build_skb(ba - ENETC_RXB_PAD, ENETC_RXB_TRUESIZE);
+	skb = build_skb(ba - rx_ring->buffer_offset, ENETC_RXB_TRUESIZE);
 	if (unlikely(!skb)) {
 		rx_ring->stats.rx_alloc_errs++;
 		return NULL;
 	}
 
-	skb_reserve(skb, ENETC_RXB_PAD);
+	skb_reserve(skb, rx_ring->buffer_offset);
 	__skb_put(skb, size);
 
 	enetc_put_rx_buff(rx_ring, rx_swbd);
@@ -625,7 +627,7 @@ static bool enetc_check_bd_errors_and_consume(struct enetc_bdr *rx_ring,
 
 static struct sk_buff *enetc_build_skb(struct enetc_bdr *rx_ring,
 				       u32 bd_status, union enetc_rx_bd **rxbd,
-				       int *i, int *cleaned_cnt)
+				       int *i, int *cleaned_cnt, int buffer_size)
 {
 	struct sk_buff *skb;
 	u16 size;
@@ -644,7 +646,7 @@ static struct sk_buff *enetc_build_skb(struct enetc_bdr *rx_ring,
 	/* not last BD in frame? */
 	while (!(bd_status & ENETC_RXBD_LSTATUS_F)) {
 		bd_status = le32_to_cpu((*rxbd)->r.lstatus);
-		size = ENETC_RXB_DMA_SIZE;
+		size = buffer_size;
 
 		if (bd_status & ENETC_RXBD_LSTATUS_F) {
 			dma_rmb();
@@ -698,7 +700,7 @@ static int enetc_clean_rx_ring(struct enetc_bdr *rx_ring,
 			break;
 
 		skb = enetc_build_skb(rx_ring, bd_status, &rxbd, &i,
-				      &cleaned_cnt);
+				      &cleaned_cnt, ENETC_RXB_DMA_SIZE);
 		if (!skb)
 			break;
 
@@ -716,10 +718,174 @@ static int enetc_clean_rx_ring(struct enetc_bdr *rx_ring,
 	return rx_frm_cnt;
 }
 
+static void enetc_map_rx_buff_to_xdp(struct enetc_bdr *rx_ring, int i,
+				     struct xdp_buff *xdp_buff, u16 size)
+{
+	struct enetc_rx_swbd *rx_swbd = enetc_get_rx_buff(rx_ring, i, size);
+	void *hard_start = page_address(rx_swbd->page) + rx_swbd->page_offset;
+	struct skb_shared_info *shinfo;
+
+	xdp_prepare_buff(xdp_buff, hard_start - rx_ring->buffer_offset,
+			 rx_ring->buffer_offset, size, false);
+
+	shinfo = xdp_get_shared_info_from_buff(xdp_buff);
+	shinfo->nr_frags = 0;
+}
+
+static void enetc_add_rx_buff_to_xdp(struct enetc_bdr *rx_ring, int i,
+				     u16 size, struct xdp_buff *xdp_buff)
+{
+	struct skb_shared_info *shinfo = xdp_get_shared_info_from_buff(xdp_buff);
+	struct enetc_rx_swbd *rx_swbd = enetc_get_rx_buff(rx_ring, i, size);
+	skb_frag_t *frag = &shinfo->frags[shinfo->nr_frags];
+
+	skb_frag_off_set(frag, rx_swbd->page_offset);
+	skb_frag_size_set(frag, size);
+	__skb_frag_set_page(frag, rx_swbd->page);
+
+	shinfo->nr_frags++;
+}
+
+static void enetc_build_xdp_buff(struct enetc_bdr *rx_ring, u32 bd_status,
+				 union enetc_rx_bd **rxbd, int *i,
+				 int *cleaned_cnt, struct xdp_buff *xdp_buff)
+{
+	u16 size = le16_to_cpu((*rxbd)->r.buf_len);
+
+	xdp_init_buff(xdp_buff, ENETC_RXB_TRUESIZE, &rx_ring->xdp.rxq);
+
+	enetc_map_rx_buff_to_xdp(rx_ring, *i, xdp_buff, size);
+	(*cleaned_cnt)++;
+	enetc_rxbd_next(rx_ring, rxbd, i);
+
+	/* not last BD in frame? */
+	while (!(bd_status & ENETC_RXBD_LSTATUS_F)) {
+		bd_status = le32_to_cpu((*rxbd)->r.lstatus);
+		size = ENETC_RXB_DMA_SIZE_XDP;
+
+		if (bd_status & ENETC_RXBD_LSTATUS_F) {
+			dma_rmb();
+			size = le16_to_cpu((*rxbd)->r.buf_len);
+		}
+
+		enetc_add_rx_buff_to_xdp(rx_ring, *i, size, xdp_buff);
+		(*cleaned_cnt)++;
+		enetc_rxbd_next(rx_ring, rxbd, i);
+	}
+}
+
+/* Reuse the current page without performing half-page buffer flipping */
+static void enetc_put_xdp_buff(struct enetc_bdr *rx_ring,
+			       struct enetc_rx_swbd *rx_swbd)
+{
+	enetc_reuse_page(rx_ring, rx_swbd);
+
+	/* sync for use by the device */
+	dma_sync_single_range_for_device(rx_ring->dev, rx_swbd->dma,
+					 rx_swbd->page_offset,
+					 ENETC_RXB_DMA_SIZE_XDP,
+					 DMA_FROM_DEVICE);
+
+	rx_swbd->page = NULL;
+}
+
+static void enetc_xdp_drop(struct enetc_bdr *rx_ring, int rx_ring_first,
+			   int rx_ring_last)
+{
+	while (rx_ring_first != rx_ring_last) {
+		enetc_put_xdp_buff(rx_ring,
+				   &rx_ring->rx_swbd[rx_ring_first]);
+		enetc_bdr_idx_inc(rx_ring, &rx_ring_first);
+	}
+	rx_ring->stats.xdp_drops++;
+}
+
+static int enetc_clean_rx_ring_xdp(struct enetc_bdr *rx_ring,
+				   struct napi_struct *napi, int work_limit,
+				   struct bpf_prog *prog)
+{
+	int rx_frm_cnt = 0, rx_byte_cnt = 0;
+	int cleaned_cnt, i;
+	u32 xdp_act;
+
+	cleaned_cnt = enetc_bd_unused(rx_ring);
+	/* next descriptor to process */
+	i = rx_ring->next_to_clean;
+
+	while (likely(rx_frm_cnt < work_limit)) {
+		union enetc_rx_bd *rxbd, *orig_rxbd;
+		int orig_i, orig_cleaned_cnt;
+		struct xdp_buff xdp_buff;
+		struct sk_buff *skb;
+		u32 bd_status;
+
+		if (cleaned_cnt >= ENETC_RXBD_BUNDLE)
+			cleaned_cnt -= enetc_refill_rx_ring(rx_ring,
+							    cleaned_cnt);
+
+		rxbd = enetc_rxbd(rx_ring, i);
+		bd_status = le32_to_cpu(rxbd->r.lstatus);
+		if (!bd_status)
+			break;
+
+		enetc_wr_reg_hot(rx_ring->idr, BIT(rx_ring->index));
+		dma_rmb(); /* for reading other rxbd fields */
+
+		if (enetc_check_bd_errors_and_consume(rx_ring, bd_status,
+						      &rxbd, &i))
+			break;
+
+		orig_rxbd = rxbd;
+		orig_cleaned_cnt = cleaned_cnt;
+		orig_i = i;
+
+		enetc_build_xdp_buff(rx_ring, bd_status, &rxbd, &i,
+				     &cleaned_cnt, &xdp_buff);
+
+		xdp_act = bpf_prog_run_xdp(prog, &xdp_buff);
+
+		switch (xdp_act) {
+		case XDP_ABORTED:
+			trace_xdp_exception(rx_ring->ndev, prog, xdp_act);
+			fallthrough;
+		case XDP_DROP:
+			enetc_xdp_drop(rx_ring, orig_i, i);
+			break;
+		case XDP_PASS:
+			rxbd = orig_rxbd;
+			cleaned_cnt = orig_cleaned_cnt;
+			i = orig_i;
+
+			skb = enetc_build_skb(rx_ring, bd_status, &rxbd,
+					      &i, &cleaned_cnt,
+					      ENETC_RXB_DMA_SIZE_XDP);
+			if (unlikely(!skb))
+				/* Exit the switch/case, not the loop */
+				break;
+
+			napi_gro_receive(napi, skb);
+			break;
+		default:
+			bpf_warn_invalid_xdp_action(xdp_act);
+		}
+
+		rx_frm_cnt++;
+	}
+
+	rx_ring->next_to_clean = i;
+
+	rx_ring->stats.packets += rx_frm_cnt;
+	rx_ring->stats.bytes += rx_byte_cnt;
+
+	return rx_frm_cnt;
+}
+
 static int enetc_poll(struct napi_struct *napi, int budget)
 {
 	struct enetc_int_vector
 		*v = container_of(napi, struct enetc_int_vector, napi);
+	struct enetc_bdr *rx_ring = &v->rx_ring;
+	struct bpf_prog *prog;
 	bool complete = true;
 	int work_done;
 	int i;
@@ -730,7 +896,11 @@ static int enetc_poll(struct napi_struct *napi, int budget)
 		if (!enetc_clean_tx_ring(&v->tx_ring[i], budget))
 			complete = false;
 
-	work_done = enetc_clean_rx_ring(&v->rx_ring, napi, budget);
+	prog = rx_ring->xdp.prog;
+	if (prog)
+		work_done = enetc_clean_rx_ring_xdp(rx_ring, napi, budget, prog);
+	else
+		work_done = enetc_clean_rx_ring(rx_ring, napi, budget);
 	if (work_done == budget)
 		complete = false;
 	if (work_done)
@@ -1120,7 +1290,10 @@ static void enetc_setup_rxbdr(struct enetc_hw *hw, struct enetc_bdr *rx_ring)
 	enetc_rxbdr_wr(hw, idx, ENETC_RBLENR,
 		       ENETC_RTBLENR_LEN(rx_ring->bd_count));
 
-	enetc_rxbdr_wr(hw, idx, ENETC_RBBSR, ENETC_RXB_DMA_SIZE);
+	if (rx_ring->xdp.prog)
+		enetc_rxbdr_wr(hw, idx, ENETC_RBBSR, ENETC_RXB_DMA_SIZE_XDP);
+	else
+		enetc_rxbdr_wr(hw, idx, ENETC_RBBSR, ENETC_RXB_DMA_SIZE);
 
 	enetc_rxbdr_wr(hw, idx, ENETC_RBPIR, 0);
 
@@ -1511,6 +1684,54 @@ int enetc_setup_tc(struct net_device *ndev, enum tc_setup_type type,
 	}
 }
 
+static int enetc_setup_xdp_prog(struct net_device *dev, struct bpf_prog *prog,
+				struct netlink_ext_ack *extack)
+{
+	struct enetc_ndev_priv *priv = netdev_priv(dev);
+	struct bpf_prog *old_prog;
+	bool is_up;
+	int i;
+
+	/* The buffer layout is changing, so we need to drain the old
+	 * RX buffers and seed new ones.
+	 */
+	is_up = netif_running(dev);
+	if (is_up)
+		dev_close(dev);
+
+	old_prog = xchg(&priv->xdp_prog, prog);
+	if (old_prog)
+		bpf_prog_put(old_prog);
+
+	for (i = 0; i < priv->num_rx_rings; i++) {
+		struct enetc_bdr *rx_ring = priv->rx_ring[i];
+
+		rx_ring->xdp.prog = prog;
+
+		if (prog)
+			rx_ring->buffer_offset = XDP_PACKET_HEADROOM;
+		else
+			rx_ring->buffer_offset = ENETC_RXB_PAD;
+	}
+
+	if (is_up)
+		return dev_open(dev, extack);
+
+	return 0;
+}
+
+int enetc_setup_bpf(struct net_device *dev, struct netdev_bpf *xdp)
+{
+	switch (xdp->command) {
+	case XDP_SETUP_PROG:
+		return enetc_setup_xdp_prog(dev, xdp->prog, xdp->extack);
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 struct net_device_stats *enetc_get_stats(struct net_device *ndev)
 {
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
@@ -1727,6 +1948,28 @@ int enetc_alloc_msix(struct enetc_ndev_priv *priv)
 
 		priv->int_vector[i] = v;
 
+		bdr = &v->rx_ring;
+		bdr->index = i;
+		bdr->ndev = priv->ndev;
+		bdr->dev = priv->dev;
+		bdr->bd_count = priv->rx_bd_count;
+		bdr->buffer_offset = ENETC_RXB_PAD;
+		priv->rx_ring[i] = bdr;
+
+		err = xdp_rxq_info_reg(&bdr->xdp.rxq, priv->ndev, i, 0);
+		if (err) {
+			kfree(v);
+			goto fail;
+		}
+
+		err = xdp_rxq_info_reg_mem_model(&bdr->xdp.rxq,
+						 MEM_TYPE_PAGE_SHARED, NULL);
+		if (err) {
+			xdp_rxq_info_unreg(&bdr->xdp.rxq);
+			kfree(v);
+			goto fail;
+		}
+
 		/* init defaults for adaptive IC */
 		if (priv->ic_mode & ENETC_IC_RX_ADAPTIVE) {
 			v->rx_ictt = 0x1;
@@ -1754,22 +1997,20 @@ int enetc_alloc_msix(struct enetc_ndev_priv *priv)
 			bdr->bd_count = priv->tx_bd_count;
 			priv->tx_ring[idx] = bdr;
 		}
-
-		bdr = &v->rx_ring;
-		bdr->index = i;
-		bdr->ndev = priv->ndev;
-		bdr->dev = priv->dev;
-		bdr->bd_count = priv->rx_bd_count;
-		priv->rx_ring[i] = bdr;
 	}
 
 	return 0;
 
 fail:
 	while (i--) {
-		netif_napi_del(&priv->int_vector[i]->napi);
-		cancel_work_sync(&priv->int_vector[i]->rx_dim.work);
-		kfree(priv->int_vector[i]);
+		struct enetc_int_vector *v = priv->int_vector[i];
+		struct enetc_bdr *rx_ring = &v->rx_ring;
+
+		xdp_rxq_info_unreg_mem_model(&rx_ring->xdp.rxq);
+		xdp_rxq_info_unreg(&rx_ring->xdp.rxq);
+		netif_napi_del(&v->napi);
+		cancel_work_sync(&v->rx_dim.work);
+		kfree(v);
 	}
 
 	pci_free_irq_vectors(pdev);
@@ -1783,7 +2024,10 @@ void enetc_free_msix(struct enetc_ndev_priv *priv)
 
 	for (i = 0; i < priv->bdr_int_num; i++) {
 		struct enetc_int_vector *v = priv->int_vector[i];
+		struct enetc_bdr *rx_ring = &v->rx_ring;
 
+		xdp_rxq_info_unreg_mem_model(&rx_ring->xdp.rxq);
+		xdp_rxq_info_unreg(&rx_ring->xdp.rxq);
 		netif_napi_del(&v->napi);
 		cancel_work_sync(&v->rx_dim.work);
 	}
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index d9e75644b89c..5815addfe966 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -33,6 +33,8 @@ struct enetc_tx_swbd {
 #define ENETC_RXB_PAD		NET_SKB_PAD /* add extra space if needed */
 #define ENETC_RXB_DMA_SIZE	\
 	(SKB_WITH_OVERHEAD(ENETC_RXB_TRUESIZE) - ENETC_RXB_PAD)
+#define ENETC_RXB_DMA_SIZE_XDP	\
+	(SKB_WITH_OVERHEAD(ENETC_RXB_TRUESIZE) - XDP_PACKET_HEADROOM)
 
 struct enetc_rx_swbd {
 	dma_addr_t dma;
@@ -44,6 +46,12 @@ struct enetc_ring_stats {
 	unsigned int packets;
 	unsigned int bytes;
 	unsigned int rx_alloc_errs;
+	unsigned int xdp_drops;
+};
+
+struct enetc_xdp_data {
+	struct xdp_rxq_info rxq;
+	struct bpf_prog *prog;
 };
 
 #define ENETC_RX_RING_DEFAULT_SIZE	512
@@ -72,6 +80,9 @@ struct enetc_bdr {
 	};
 	void __iomem *idr; /* Interrupt Detect Register pointer */
 
+	int buffer_offset;
+	struct enetc_xdp_data xdp;
+
 	struct enetc_ring_stats stats;
 
 	dma_addr_t bd_dma_base;
@@ -276,6 +287,8 @@ struct enetc_ndev_priv {
 	struct phylink *phylink;
 	int ic_mode;
 	u32 tx_ictt;
+
+	struct bpf_prog *xdp_prog;
 };
 
 /* Messaging */
@@ -315,6 +328,7 @@ int enetc_set_features(struct net_device *ndev,
 int enetc_ioctl(struct net_device *ndev, struct ifreq *rq, int cmd);
 int enetc_setup_tc(struct net_device *ndev, enum tc_setup_type type,
 		   void *type_data);
+int enetc_setup_bpf(struct net_device *dev, struct netdev_bpf *xdp);
 
 /* ethtool */
 void enetc_set_ethtool_ops(struct net_device *ndev);
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
index 89e558135432..0183c13f8c1e 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
@@ -192,6 +192,7 @@ static const struct {
 static const char rx_ring_stats[][ETH_GSTRING_LEN] = {
 	"Rx ring %2d frames",
 	"Rx ring %2d alloc errors",
+	"Rx ring %2d XDP drops",
 };
 
 static const char tx_ring_stats[][ETH_GSTRING_LEN] = {
@@ -273,6 +274,7 @@ static void enetc_get_ethtool_stats(struct net_device *ndev,
 	for (i = 0; i < priv->num_rx_rings; i++) {
 		data[o++] = priv->rx_ring[i]->stats.packets;
 		data[o++] = priv->rx_ring[i]->stats.rx_alloc_errs;
+		data[o++] = priv->rx_ring[i]->stats.xdp_drops;
 	}
 
 	if (!enetc_si_is_pf(priv->si))
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 5e95afd61c87..0484dbe13422 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -707,6 +707,7 @@ static const struct net_device_ops enetc_ndev_ops = {
 	.ndo_set_features	= enetc_pf_set_features,
 	.ndo_do_ioctl		= enetc_ioctl,
 	.ndo_setup_tc		= enetc_setup_tc,
+	.ndo_bpf		= enetc_setup_bpf,
 };
 
 static void enetc_pf_netdev_setup(struct enetc_si *si, struct net_device *ndev,
-- 
2.25.1

