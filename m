Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E52C4F9046
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 10:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230503AbiDHIDO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 04:03:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbiDHICD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 04:02:03 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F35016F055
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 00:59:53 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id kr12-20020a17090b490c00b001cb3ee2e4c1so1133085pjb.5
        for <netdev@vger.kernel.org>; Fri, 08 Apr 2022 00:59:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=nmgObYXcrOQ5R8444q3/NZd9xipZ0ZG3M0FCnQRG5aE=;
        b=dF3cNJkmsj5g5h5SDNd8GY7nPI4UxQtTW3Ei+eucIMBbzV7MB6mL7vzSVLajTbOD9n
         8i7iMr7j+OHMNmlerBtkTPzHLRLVqCUPiTXSuOFurlPmjNaNHXZ/7+zEP+YYR1Tm7642
         oKfA1qO9nITl8JXxuq3eaPXt22UM8O6ypEXSU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=nmgObYXcrOQ5R8444q3/NZd9xipZ0ZG3M0FCnQRG5aE=;
        b=X9NnzOh7jrMMNWjeyMMT/XzmFeeeRi+voQi7TtgvwCbi1uzJwkiCS3dpYBIsITbsP4
         RxYw7lC8vfr+CY2JApw/5JuTWaZmBnM5bYXYCMQyNVn+ZfxuUM7ArzzTbyk4HamzrMgV
         ifb1tkuy9ToUy4xZgiYbKNNkmonlR99LzTJcJ9NVWc+RCbY/fLXVVPscaoH8pDFKbjM5
         9BTxULXeakL6F/LTI52jdvd6dElTyPGYiv9H33TweOljOWmGnXvMIP8nfJlRYecLx8w4
         65bERVkj8vbN+aSOkGVNDuuudYa5nT9nY/l/TG68OSRjSMC8isCZv709aaatymRtg70O
         0LVw==
X-Gm-Message-State: AOAM531i42J466sgigzley+aHjXLOSfuY7u4b2Vtih1NkEj5X17erh7V
        f7IPd/GWcS9g7JvEAOZh7vFi/w==
X-Google-Smtp-Source: ABdhPJwdIlKsm+dVUX5KyBdP85TbsHyZVvC7p21ZoPGtwdZJepi34AUY477GyR0SrR7jOxCB3g71BQ==
X-Received: by 2002:a17:90b:3017:b0:1cb:10d1:93d with SMTP id hg23-20020a17090b301700b001cb10d1093dmr8356121pjb.217.1649404792171;
        Fri, 08 Apr 2022 00:59:52 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id l2-20020a637c42000000b003644cfa0dd1sm20507448pgn.79.2022.04.08.00.59.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Apr 2022 00:59:51 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com,
        bpf@vger.kernel.org, john.fastabend@gmail.com, toke@redhat.com,
        lorenzo@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        echaudro@redhat.com, pabeni@redhat.com
Subject: [PATCH net-next v4 10/11] bnxt: support transmit and free of aggregation buffers
Date:   Fri,  8 Apr 2022 03:59:05 -0400
Message-Id: <1649404746-31033-11-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1649404746-31033-1-git-send-email-michael.chan@broadcom.com>
References: <1649404746-31033-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000c6f2c305dc1ffa94"
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        MIME_HEADER_CTYPE_ONLY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,T_TVD_MIME_NO_HEADERS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000c6f2c305dc1ffa94

From: Andy Gospodarek <gospo@broadcom.com>

This patch adds the following features:
- Support for XDP_TX and XDP_DROP action when using xdp_buff
  with frags
- Support for freeing all frags attached to an xdp_buff
- Cleanup of TX ring buffers after transmits complete
- Slight change in definition of bnxt_sw_tx_bd since nr_frags
  and RX producer may both need to be used
- Clear out skb_shared_info at the end of the buffer

v2: Fix uninitialized variable warning in bnxt_xdp_buff_frags_free().

Signed-off-by: Andy Gospodarek <gospo@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  18 ++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |   7 +-
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c |   2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c | 117 ++++++++++++++++--
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h |   5 +-
 5 files changed, 126 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index f96f41c7927e..25d74c9030fd 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -1951,9 +1951,13 @@ static int bnxt_rx_pkt(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
 		skb = bnxt_copy_skb(bnapi, data_ptr, len, dma_addr);
 		bnxt_reuse_rx_data(rxr, cons, data);
 		if (!skb) {
-			if (agg_bufs)
-				bnxt_reuse_rx_agg_bufs(cpr, cp_cons, 0,
-						       agg_bufs, false);
+			if (agg_bufs) {
+				if (!xdp_active)
+					bnxt_reuse_rx_agg_bufs(cpr, cp_cons, 0,
+							       agg_bufs, false);
+				else
+					bnxt_xdp_buff_frags_free(rxr, &xdp);
+			}
 			cpr->sw_stats.rx.rx_oom_discards += 1;
 			rc = -ENOMEM;
 			goto next_rx;
@@ -1986,6 +1990,7 @@ static int bnxt_rx_pkt(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
 			skb = bnxt_xdp_build_skb(bp, skb, agg_bufs, rxr->page_pool, &xdp, rxcmp1);
 			if (!skb) {
 				/* we should be able to free the old skb here */
+				bnxt_xdp_buff_frags_free(rxr, &xdp);
 				cpr->sw_stats.rx.rx_oom_discards += 1;
 				rc = -ENOMEM;
 				goto next_rx;
@@ -2605,10 +2610,13 @@ static void __bnxt_poll_work_done(struct bnxt *bp, struct bnxt_napi *bnapi)
 	if ((bnapi->events & BNXT_RX_EVENT) && !(bnapi->in_reset)) {
 		struct bnxt_rx_ring_info *rxr = bnapi->rx_ring;
 
-		if (bnapi->events & BNXT_AGG_EVENT)
-			bnxt_db_write(bp, &rxr->rx_agg_db, rxr->rx_agg_prod);
 		bnxt_db_write(bp, &rxr->rx_db, rxr->rx_prod);
 	}
+	if (bnapi->events & BNXT_AGG_EVENT) {
+		struct bnxt_rx_ring_info *rxr = bnapi->rx_ring;
+
+		bnxt_db_write(bp, &rxr->rx_agg_db, rxr->rx_agg_prod);
+	}
 	bnapi->events = 0;
 }
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 319d6851eecc..a498ee297946 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -701,13 +701,12 @@ struct bnxt_sw_tx_bd {
 	};
 	DEFINE_DMA_UNMAP_ADDR(mapping);
 	DEFINE_DMA_UNMAP_LEN(len);
+	struct page		*page;
 	u8			is_gso;
 	u8			is_push;
 	u8			action;
-	union {
-		unsigned short		nr_frags;
-		u16			rx_prod;
-	};
+	unsigned short		nr_frags;
+	u16			rx_prod;
 };
 
 struct bnxt_sw_rx_bd {
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 22e965e18fbc..b3a48d6675fe 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -3491,7 +3491,7 @@ static int bnxt_run_loopback(struct bnxt *bp)
 		dev_kfree_skb(skb);
 		return -EIO;
 	}
-	bnxt_xmit_bd(bp, txr, map, pkt_size);
+	bnxt_xmit_bd(bp, txr, map, pkt_size, NULL);
 
 	/* Sync BD data before updating doorbell */
 	wmb();
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
index 5183357ca11c..c2905f0a8c6c 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
@@ -24,36 +24,91 @@ DEFINE_STATIC_KEY_FALSE(bnxt_xdp_locking_key);
 
 struct bnxt_sw_tx_bd *bnxt_xmit_bd(struct bnxt *bp,
 				   struct bnxt_tx_ring_info *txr,
-				   dma_addr_t mapping, u32 len)
+				   dma_addr_t mapping, u32 len,
+				   struct xdp_buff *xdp)
 {
-	struct bnxt_sw_tx_bd *tx_buf;
+	struct skb_shared_info *sinfo;
+	struct bnxt_sw_tx_bd *tx_buf, *first_buf;
 	struct tx_bd *txbd;
+	int num_frags = 0;
 	u32 flags;
 	u16 prod;
+	int i;
+
+	if (xdp && xdp_buff_has_frags(xdp)) {
+		sinfo = xdp_get_shared_info_from_buff(xdp);
+		num_frags = sinfo->nr_frags;
+	}
 
+	/* fill up the first buffer */
 	prod = txr->tx_prod;
 	tx_buf = &txr->tx_buf_ring[prod];
+	first_buf = tx_buf;
+	tx_buf->nr_frags = num_frags;
+	if (xdp)
+		tx_buf->page = virt_to_head_page(xdp->data);
 
 	txbd = &txr->tx_desc_ring[TX_RING(prod)][TX_IDX(prod)];
-	flags = (len << TX_BD_LEN_SHIFT) | (1 << TX_BD_FLAGS_BD_CNT_SHIFT) |
-		TX_BD_FLAGS_PACKET_END | bnxt_lhint_arr[len >> 9];
+	flags = ((len) << TX_BD_LEN_SHIFT) | ((num_frags + 1) << TX_BD_FLAGS_BD_CNT_SHIFT);
 	txbd->tx_bd_len_flags_type = cpu_to_le32(flags);
 	txbd->tx_bd_opaque = prod;
 	txbd->tx_bd_haddr = cpu_to_le64(mapping);
 
+	/* now let us fill up the frags into the next buffers */
+	for (i = 0; i < num_frags ; i++) {
+		skb_frag_t *frag = &sinfo->frags[i];
+		struct bnxt_sw_tx_bd *frag_tx_buf;
+		struct pci_dev *pdev = bp->pdev;
+		dma_addr_t frag_mapping;
+		int frag_len;
+
+		prod = NEXT_TX(prod);
+		txr->tx_prod = prod;
+
+		/* first fill up the first buffer */
+		frag_tx_buf = &txr->tx_buf_ring[prod];
+		frag_tx_buf->page = skb_frag_page(frag);
+
+		txbd = &txr->tx_desc_ring[TX_RING(prod)][TX_IDX(prod)];
+
+		frag_len = skb_frag_size(frag);
+		frag_mapping = skb_frag_dma_map(&pdev->dev, frag, 0,
+						frag_len, DMA_TO_DEVICE);
+
+		if (unlikely(dma_mapping_error(&pdev->dev, frag_mapping)))
+			return NULL;
+
+		dma_unmap_addr_set(frag_tx_buf, mapping, frag_mapping);
+
+		flags = frag_len << TX_BD_LEN_SHIFT;
+		txbd->tx_bd_len_flags_type = cpu_to_le32(flags);
+		txbd->tx_bd_opaque = prod;
+		txbd->tx_bd_haddr = cpu_to_le64(frag_mapping);
+
+		len = frag_len;
+	}
+
+	flags &= ~TX_BD_LEN;
+	txbd->tx_bd_len_flags_type = cpu_to_le32(((len) << TX_BD_LEN_SHIFT) | flags |
+			TX_BD_FLAGS_PACKET_END);
+	/* Sync TX BD */
+	wmb();
 	prod = NEXT_TX(prod);
 	txr->tx_prod = prod;
-	return tx_buf;
+
+	return first_buf;
 }
 
 static void __bnxt_xmit_xdp(struct bnxt *bp, struct bnxt_tx_ring_info *txr,
-			    dma_addr_t mapping, u32 len, u16 rx_prod)
+			    dma_addr_t mapping, u32 len, u16 rx_prod,
+			    struct xdp_buff *xdp)
 {
 	struct bnxt_sw_tx_bd *tx_buf;
 
-	tx_buf = bnxt_xmit_bd(bp, txr, mapping, len);
+	tx_buf = bnxt_xmit_bd(bp, txr, mapping, len, xdp);
 	tx_buf->rx_prod = rx_prod;
 	tx_buf->action = XDP_TX;
+
 }
 
 static void __bnxt_xmit_xdp_redirect(struct bnxt *bp,
@@ -63,7 +118,7 @@ static void __bnxt_xmit_xdp_redirect(struct bnxt *bp,
 {
 	struct bnxt_sw_tx_bd *tx_buf;
 
-	tx_buf = bnxt_xmit_bd(bp, txr, mapping, len);
+	tx_buf = bnxt_xmit_bd(bp, txr, mapping, len, NULL);
 	tx_buf->action = XDP_REDIRECT;
 	tx_buf->xdpf = xdpf;
 	dma_unmap_addr_set(tx_buf, mapping, mapping);
@@ -78,7 +133,7 @@ void bnxt_tx_int_xdp(struct bnxt *bp, struct bnxt_napi *bnapi, int nr_pkts)
 	struct bnxt_sw_tx_bd *tx_buf;
 	u16 tx_cons = txr->tx_cons;
 	u16 last_tx_cons = tx_cons;
-	int i;
+	int i, j, frags;
 
 	for (i = 0; i < nr_pkts; i++) {
 		tx_buf = &txr->tx_buf_ring[tx_cons];
@@ -96,6 +151,13 @@ void bnxt_tx_int_xdp(struct bnxt *bp, struct bnxt_napi *bnapi, int nr_pkts)
 		} else if (tx_buf->action == XDP_TX) {
 			rx_doorbell_needed = true;
 			last_tx_cons = tx_cons;
+
+			frags = tx_buf->nr_frags;
+			for (j = 0; j < frags; j++) {
+				tx_cons = NEXT_TX(tx_cons);
+				tx_buf = &txr->tx_buf_ring[tx_cons];
+				page_pool_recycle_direct(rxr->page_pool, tx_buf->page);
+			}
 		}
 		tx_cons = NEXT_TX(tx_cons);
 	}
@@ -103,6 +165,7 @@ void bnxt_tx_int_xdp(struct bnxt *bp, struct bnxt_napi *bnapi, int nr_pkts)
 	if (rx_doorbell_needed) {
 		tx_buf = &txr->tx_buf_ring[last_tx_cons];
 		bnxt_db_write(bp, &rxr->rx_db, tx_buf->rx_prod);
+
 	}
 }
 
@@ -133,6 +196,23 @@ void bnxt_xdp_buff_init(struct bnxt *bp, struct bnxt_rx_ring_info *rxr,
 	xdp_prepare_buff(xdp, *data_ptr - offset, offset, *len, false);
 }
 
+void bnxt_xdp_buff_frags_free(struct bnxt_rx_ring_info *rxr,
+			      struct xdp_buff *xdp)
+{
+	struct skb_shared_info *shinfo;
+	int i;
+
+	if (!xdp || !xdp_buff_has_frags(xdp))
+		return;
+	shinfo = xdp_get_shared_info_from_buff(xdp);
+	for (i = 0; i < shinfo->nr_frags; i++) {
+		struct page *page = skb_frag_page(&shinfo->frags[i]);
+
+		page_pool_recycle_direct(rxr->page_pool, page);
+	}
+	shinfo->nr_frags = 0;
+}
+
 /* returns the following:
  * true    - packet consumed by XDP and new buffer is allocated.
  * false   - packet should be passed to the stack.
@@ -145,6 +225,7 @@ bool bnxt_rx_xdp(struct bnxt *bp, struct bnxt_rx_ring_info *rxr, u16 cons,
 	struct bnxt_sw_rx_bd *rx_buf;
 	struct pci_dev *pdev;
 	dma_addr_t mapping;
+	u32 tx_needed = 1;
 	void *orig_data;
 	u32 tx_avail;
 	u32 offset;
@@ -180,18 +261,28 @@ bool bnxt_rx_xdp(struct bnxt *bp, struct bnxt_rx_ring_info *rxr, u16 cons,
 	case XDP_TX:
 		rx_buf = &rxr->rx_buf_ring[cons];
 		mapping = rx_buf->mapping - bp->rx_dma_offset;
+		*event = 0;
+
+		if (unlikely(xdp_buff_has_frags(&xdp))) {
+			struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(&xdp);
 
-		if (tx_avail < 1) {
+			tx_needed += sinfo->nr_frags;
+			*event = BNXT_AGG_EVENT;
+		}
+
+		if (tx_avail < tx_needed) {
 			trace_xdp_exception(bp->dev, xdp_prog, act);
+			bnxt_xdp_buff_frags_free(rxr, &xdp);
 			bnxt_reuse_rx_data(rxr, cons, page);
 			return true;
 		}
 
-		*event = BNXT_TX_EVENT;
 		dma_sync_single_for_device(&pdev->dev, mapping + offset, *len,
 					   bp->rx_dir);
+
+		*event |= BNXT_TX_EVENT;
 		__bnxt_xmit_xdp(bp, txr, mapping + offset, *len,
-				NEXT_RX(rxr->rx_prod));
+				NEXT_RX(rxr->rx_prod), &xdp);
 		bnxt_reuse_rx_data(rxr, cons, page);
 		return true;
 	case XDP_REDIRECT:
@@ -208,6 +299,7 @@ bool bnxt_rx_xdp(struct bnxt *bp, struct bnxt_rx_ring_info *rxr, u16 cons,
 		/* if we are unable to allocate a new buffer, abort and reuse */
 		if (bnxt_alloc_rx_data(bp, rxr, rxr->rx_prod, GFP_ATOMIC)) {
 			trace_xdp_exception(bp->dev, xdp_prog, act);
+			bnxt_xdp_buff_frags_free(rxr, &xdp);
 			bnxt_reuse_rx_data(rxr, cons, page);
 			return true;
 		}
@@ -227,6 +319,7 @@ bool bnxt_rx_xdp(struct bnxt *bp, struct bnxt_rx_ring_info *rxr, u16 cons,
 		trace_xdp_exception(bp->dev, xdp_prog, act);
 		fallthrough;
 	case XDP_DROP:
+		bnxt_xdp_buff_frags_free(rxr, &xdp);
 		bnxt_reuse_rx_data(rxr, cons, page);
 		break;
 	}
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h
index 27290f649be3..505911ae095d 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h
@@ -14,7 +14,8 @@ DECLARE_STATIC_KEY_FALSE(bnxt_xdp_locking_key);
 
 struct bnxt_sw_tx_bd *bnxt_xmit_bd(struct bnxt *bp,
 				   struct bnxt_tx_ring_info *txr,
-				   dma_addr_t mapping, u32 len);
+				   dma_addr_t mapping, u32 len,
+				   struct xdp_buff *xdp);
 void bnxt_tx_int_xdp(struct bnxt *bp, struct bnxt_napi *bnapi, int nr_pkts);
 bool bnxt_rx_xdp(struct bnxt *bp, struct bnxt_rx_ring_info *rxr, u16 cons,
 		 struct xdp_buff xdp, struct page *page, unsigned int *len,
@@ -28,6 +29,8 @@ bool bnxt_xdp_attached(struct bnxt *bp, struct bnxt_rx_ring_info *rxr);
 void bnxt_xdp_buff_init(struct bnxt *bp, struct bnxt_rx_ring_info *rxr,
 			u16 cons, u8 **data_ptr, unsigned int *len,
 			struct xdp_buff *xdp);
+void bnxt_xdp_buff_frags_free(struct bnxt_rx_ring_info *rxr,
+			      struct xdp_buff *xdp);
 struct sk_buff *bnxt_xdp_build_skb(struct bnxt *bp, struct sk_buff *skb,
 				   u8 num_frags, struct page_pool *pool,
 				   struct xdp_buff *xdp,
-- 
2.18.1


--000000000000c6f2c305dc1ffa94
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
xV4Em+0wQoEIR2kPG6yiZNtUK0tNCaZejYU/Mf/bzdKSwud3pLgHV8ls83y2OU/ha9xgJMLpRswv
xucFCxMsPmk0yoVmpbr92kIpLm+TomNZsL++LcDRa2ECAwEAAaOCAdowggHWMA4GA1UdDwEB/wQE
AwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUuZ2xvYmFs
c2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggrBgEFBQcw
AYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAw
TQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2Jh
bHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4aHR0cDov
L2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmwwJAYDVR0R
BB0wG4EZbWljaGFlbC5jaGFuQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUz2bMvqtXpXM0u3vAvRkalz60
CjswDQYJKoZIhvcNAQELBQADggEBAGUgeqqI/q2pkETeLr6oS7nnm1bkeNmtnJ2bnybNO/RdrbPj
DHVSiDCCrWr6xrc+q6OiZDKm0Ieq6BN+Wfr8h5mCkZMUdJikI85WcQTRk6EEF2lzIiaULmFD7U15
FSWQptLx+kiu63idTII4r3k/7+dJ5AhLRr4WCoXEme2GZkfSbYC3fEL46tb1w7w+25OEFCv1MtDZ
1CHkODrS2JGwDQxXKmyF64MhJiOutWHmqoGmLJVz1jnDvClsYtgT4zcNtoqKtjpWDYAefncWDPIQ
DauX1eWVM+KepL7zoSNzVbTipc65WuZFLR8ngOwkpknqvS9n/nKd885m23oIocC+GA4xggJtMIIC
aQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQD
EyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwQeU+Y6hbenPzRMJsw
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIIaDKPY0XwnyOnFsN2XMngzaOJqCEEeh
uRiFzJdkEAmVMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDQw
ODA3NTk1MlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQCws6SlkM1unTWOYQ8oaHhoqYbZMxQXR/8MG1AEF9w5mhjxXhMW
4Zux5xXh+EkF3B2HGY5RJw2a/Ejb1P3QW+bIMEwsWZVqQDgjtzB5Cg2KhntD+fiuXA17lGNeei0J
9cZlA/at9St42JlIgA1j4Rt/pezSp7K2zVFg7RGZ1tGCtNiQEAiUZwafg5iUr+/cmaJvhVvOjC9k
zTyned3FLDenlFkCS5034AKEZt5id/Ud8796PTx+6I9O7ecrK/cQo0nxSdErxVRnh0/0LLEsd+ZL
4ElOWt+480YAXwrF98ozRBwSv/1/QHpNBUN+ulSqxDdxj5RE6/j8kkXrXNitgMrn
--000000000000c6f2c305dc1ffa94--
