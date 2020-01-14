Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B020513A144
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 08:03:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728959AbgANHDW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 02:03:22 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:40599 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728949AbgANHDV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 02:03:21 -0500
Received: by mail-pj1-f67.google.com with SMTP id bg7so5424694pjb.5
        for <netdev@vger.kernel.org>; Mon, 13 Jan 2020 23:03:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=PgzoK+t8aqGu59vDTKyhOTNQX3+wVPG72HdrimXf5qU=;
        b=QzjyAxF3OJZvfdsgxkj6TmjXNCBQWRwpYUIl0kKc0xWtICSsA4lw/tqjNoe33Uj5PV
         0D9l8oYLNh7FwF8x9As62Ps5NtTgZy54Thhj2KaTCJG1NoUNFoM5oVbloMZz9mEG5LH6
         QaOdKbAMOxFb7hmXsCM8fnilVFK8MQGRNduDrvt7X+vhtMZGudq1xQJPQBii3OJPBhqR
         bb6kXG/eENh+hh5qhg++AX+EEyQ6dAFqrEAcoabtanlEgJSLLZMeNAVmRo0OgVduJ0Fw
         wLts37TAPZX8um+Gwg1fxbaNfZU0UVdU7RGOokA+ZvZC+SYFFUq96dWS9hu3H8CAk/0X
         Tw5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=PgzoK+t8aqGu59vDTKyhOTNQX3+wVPG72HdrimXf5qU=;
        b=judjfkYQx5V7S3vjutdHlYJo8FEyn3oRumxxK8C3lqsxlsyv+hlZYWK+GjFTUK/UXp
         NBBX4IdXkl+l0EZWsRpsBK9V8HUhvDMSsj57t82HufTeKKbLqQWU2vu2QKeDc8CXeIbQ
         L8YyAiw35Uuo5UQ1CoLltLXpOVPdAa/Tpqd41k2+i3VcYCK6dHGyL0vxnvx5mZmbYZs6
         oFHR4kQy7yv7+HwqKzhhKH2k51K1D7Q9ADfDyDpMIGkQi4z+cgqTsDRbqfXdAAwNFtxf
         KcaOzZshHO6999wxrxYorrfbOP7S0Qp3AQln3MaecQXzSDD0zz+9CHHAe0Me7eL1iL5Z
         fDvQ==
X-Gm-Message-State: APjAAAXeAT8PUdBpn4uXh0ktcKeCV+iNzRAVX2Er9I9KWGKYrNMiBb7G
        PORLOcFlCSy+S0vPaeT4MNWnu2paQ8E=
X-Google-Smtp-Source: APXvYqzhR4eTGNa2LBd6F5UxKZMYQRmRfoDGZ3TRHtxJSWAQ0WHC4kT9FB3+aOYnuHdJbP9yNPS1lg==
X-Received: by 2002:a17:902:d205:: with SMTP id t5mr7407163ply.138.1578985400180;
        Mon, 13 Jan 2020 23:03:20 -0800 (PST)
Received: from machine421.marvell.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id o19sm2241014pjr.2.2020.01.13.23.03.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 13 Jan 2020 23:03:19 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kubakici@wp.pl,
        Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH v2 12/17] octeontx2-pf: TCP segmentation offload support
Date:   Tue, 14 Jan 2020 12:32:15 +0530
Message-Id: <1578985340-28775-13-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1578985340-28775-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1578985340-28775-1-git-send-email-sunil.kovvuri@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sunil Goutham <sgoutham@marvell.com>

Adds TCP segmentation offload (TSO) support. First version
of the silicon didn't support TSO offload, for this driver
level TSO support is added.

Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   |   8 +
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |  11 +
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |   7 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c | 247 ++++++++++++++++++++-
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.h |   2 +
 5 files changed, 272 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 8585d30..fb4d09d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -10,6 +10,7 @@
 
 #include <linux/interrupt.h>
 #include <linux/pci.h>
+#include <net/tso.h>
 
 #include "otx2_reg.h"
 #include "otx2_common.h"
@@ -518,6 +519,11 @@ static int otx2_sq_init(struct otx2_nic *pfvf, u16 qidx, u16 sqb_aura)
 	if (err)
 		return err;
 
+	err = qmem_alloc(pfvf->dev, &sq->tso_hdrs, qset->sqe_cnt,
+			 TSO_HEADER_SIZE);
+	if (err)
+		return err;
+
 	sq->sqe_base = sq->sqe->base;
 	sq->sg = kcalloc(qset->sqe_cnt, sizeof(struct sg_list), GFP_KERNEL);
 	if (!sq->sg)
@@ -1210,6 +1216,8 @@ void mbox_handler_nix_lf_alloc(struct otx2_nic *pfvf,
 	pfvf->hw.sqb_size = rsp->sqb_size;
 	pfvf->hw.rx_chan_base = rsp->rx_chan_base;
 	pfvf->hw.tx_chan_base = rsp->tx_chan_base;
+	pfvf->hw.lso_tsov4_idx = rsp->lso_tsov4_idx;
+	pfvf->hw.lso_tsov6_idx = rsp->lso_tsov6_idx;
 }
 
 void mbox_handler_msix_offset(struct otx2_nic *pfvf,
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index c032210..2733f9a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -129,6 +129,11 @@ struct otx2_hw {
 	u16			rq_skid;
 	u8			cq_time_wait;
 
+	/* For TSO segmentation */
+	u8			lso_tsov4_idx;
+	u8			lso_tsov6_idx;
+	u8			hw_tso;
+
 	/* MSI-X*/
 	u8			cint_cnt; /* CQ interrupt count */
 	u16			npa_msixoff; /* Offset of NPA vectors */
@@ -189,11 +194,17 @@ static inline bool is_96xx_B0(struct pci_dev *pdev)
 
 static inline void otx2_setup_dev_hw_settings(struct otx2_nic *pfvf)
 {
+	struct otx2_hw *hw = &pfvf->hw;
+
 	pfvf->hw.cq_time_wait = CQ_TIMER_THRESH_DEFAULT;
 	pfvf->hw.cq_ecount_wait = CQ_CQE_THRESH_DEFAULT;
 	pfvf->hw.cq_qcount_wait = CQ_QCOUNT_DEFAULT;
 
+	hw->hw_tso = true;
+
 	if (is_96xx_A0(pfvf->pdev)) {
+		hw->hw_tso = false;
+
 		/* Time based irq coalescing is not supported */
 		pfvf->hw.cq_qcount_wait = 0x0;
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index fe5b3de..f163573 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -616,6 +616,7 @@ static void otx2_free_sq_res(struct otx2_nic *pf)
 	for (qidx = 0; qidx < pf->hw.tx_queues; qidx++) {
 		sq = &qset->sq[qidx];
 		qmem_free(pf->dev, sq->sqe);
+		qmem_free(pf->dev, sq->tso_hdrs);
 		kfree(sq->sg);
 		kfree(sq->sqb_ptrs);
 	}
@@ -988,7 +989,8 @@ static netdev_tx_t otx2_xmit(struct sk_buff *skb, struct net_device *netdev)
 	struct netdev_queue *txq;
 
 	/* Check for minimum and maximum packet length */
-	if (skb->len <= ETH_HLEN) {
+	if (skb->len <= ETH_HLEN ||
+	    (!skb_shinfo(skb)->gso_size && skb->len > pf->max_frs)) {
 		dev_kfree_skb(skb);
 		return NETDEV_TX_OK;
 	}
@@ -1255,11 +1257,12 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	netdev->hw_features = (NETIF_F_RXCSUM | NETIF_F_IP_CSUM |
 			       NETIF_F_IPV6_CSUM | NETIF_F_RXHASH |
-			       NETIF_F_SG);
+			       NETIF_F_SG | NETIF_F_TSO | NETIF_F_TSO6);
 	netdev->features |= netdev->hw_features;
 
 	netdev->hw_features |= NETIF_F_LOOPBACK | NETIF_F_RXALL;
 
+	netdev->gso_max_segs = OTX2_MAX_GSO_SEGS;
 	netdev->watchdog_timeo = OTX2_TX_TIMEOUT;
 
 	netdev->netdev_ops = &otx2_netdev_ops;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
index f2de352..993e045 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
@@ -10,6 +10,7 @@
 
 #include <linux/etherdevice.h>
 #include <net/ip.h>
+#include <net/tso.h>
 
 #include "otx2_reg.h"
 #include "otx2_common.h"
@@ -437,6 +438,38 @@ static bool otx2_sqe_add_sg(struct otx2_nic *pfvf, struct otx2_snd_queue *sq,
 	return true;
 }
 
+/* Add SQE extended header subdescriptor */
+static void otx2_sqe_add_ext(struct otx2_nic *pfvf, struct otx2_snd_queue *sq,
+			     struct sk_buff *skb, int *offset)
+{
+	struct nix_sqe_ext_s *ext;
+
+	ext = (struct nix_sqe_ext_s *)(sq->sqe_base + *offset);
+	ext->subdc = NIX_SUBDC_EXT;
+	if (skb_shinfo(skb)->gso_size) {
+		ext->lso = 1;
+		ext->lso_sb = skb_transport_offset(skb) + tcp_hdrlen(skb);
+		ext->lso_mps = skb_shinfo(skb)->gso_size;
+
+		/* Only TSOv4 and TSOv6 GSO offloads are supported */
+		if (skb_shinfo(skb)->gso_type & SKB_GSO_TCPV4) {
+			ext->lso_format = pfvf->hw.lso_tsov4_idx;
+
+			/* HW adds payload size to 'ip_hdr->tot_len' while
+			 * sending TSO segment, hence set payload length
+			 * in IP header of the packet to just header length.
+			 */
+			ip_hdr(skb)->tot_len =
+				htons(ext->lso_sb - skb_network_offset(skb));
+		} else {
+			ext->lso_format = pfvf->hw.lso_tsov6_idx;
+			ipv6_hdr(skb)->payload_len =
+				htons(ext->lso_sb - skb_network_offset(skb));
+		}
+	}
+	*offset += sizeof(*ext);
+}
+
 /* Add SQE header subdescriptor structure */
 static void otx2_sqe_add_hdr(struct otx2_nic *pfvf, struct otx2_snd_queue *sq,
 			     struct nix_sqe_hdr_s *sqe_hdr,
@@ -484,6 +517,209 @@ static void otx2_sqe_add_hdr(struct otx2_nic *pfvf, struct otx2_snd_queue *sq,
 	}
 }
 
+static int otx2_dma_map_tso_skb(struct otx2_nic *pfvf,
+				struct otx2_snd_queue *sq,
+				struct sk_buff *skb, int sqe, int hdr_len)
+{
+	int num_segs = skb_shinfo(skb)->nr_frags + 1;
+	struct sg_list *sg = &sq->sg[sqe];
+	u64 dma_addr;
+	int seg, len;
+
+	sg->num_segs = 0;
+
+	/* Get payload length at skb->data */
+	len = skb_headlen(skb) - hdr_len;
+
+	for (seg = 0; seg < num_segs; seg++) {
+		/* Skip skb->data, if there is no payload */
+		if (!seg && !len)
+			continue;
+		dma_addr = otx2_dma_map_skb_frag(pfvf, skb, seg, &len);
+		if (dma_mapping_error(pfvf->dev, dma_addr))
+			goto unmap;
+
+		/* Save DMA mapping info for later unmapping */
+		sg->dma_addr[sg->num_segs] = dma_addr;
+		sg->size[sg->num_segs] = len;
+		sg->num_segs++;
+	}
+	return 0;
+unmap:
+	otx2_dma_unmap_skb_frags(pfvf, sg);
+	return -EINVAL;
+}
+
+static u64 otx2_tso_frag_dma_addr(struct otx2_snd_queue *sq,
+				  struct sk_buff *skb, int seg,
+				  u64 seg_addr, int hdr_len, int sqe)
+{
+	struct sg_list *sg = &sq->sg[sqe];
+	const skb_frag_t *frag;
+	int offset;
+
+	if (seg < 0)
+		return sg->dma_addr[0] + (seg_addr - (u64)skb->data);
+
+	frag = &skb_shinfo(skb)->frags[seg];
+	offset = seg_addr - (u64)skb_frag_address(frag);
+	if (skb_headlen(skb) - hdr_len)
+		seg++;
+	return sg->dma_addr[seg] + offset;
+}
+
+static void otx2_sqe_tso_add_sg(struct otx2_snd_queue *sq,
+				struct sg_list *list, int *offset)
+{
+	struct nix_sqe_sg_s *sg = NULL;
+	u16 *sg_lens = NULL;
+	u64 *iova = NULL;
+	int seg;
+
+	/* Add SG descriptors with buffer addresses */
+	for (seg = 0; seg < list->num_segs; seg++) {
+		if ((seg % MAX_SEGS_PER_SG) == 0) {
+			sg = (struct nix_sqe_sg_s *)(sq->sqe_base + *offset);
+			sg->ld_type = NIX_SEND_LDTYPE_LDD;
+			sg->subdc = NIX_SUBDC_SG;
+			sg->segs = 0;
+			sg_lens = (void *)sg;
+			iova = (void *)sg + sizeof(*sg);
+			/* Next subdc always starts at a 16byte boundary.
+			 * So if sg->segs is whether 2 or 3, offset += 16bytes.
+			 */
+			if ((list->num_segs - seg) >= (MAX_SEGS_PER_SG - 1))
+				*offset += sizeof(*sg) + (3 * sizeof(u64));
+			else
+				*offset += sizeof(*sg) + sizeof(u64);
+		}
+		sg_lens[frag_num(seg % MAX_SEGS_PER_SG)] = list->size[seg];
+		*iova++ = list->dma_addr[seg];
+		sg->segs++;
+	}
+}
+
+static void otx2_sq_append_tso(struct otx2_nic *pfvf, struct otx2_snd_queue *sq,
+			       struct sk_buff *skb, u16 qidx)
+{
+	struct netdev_queue *txq = netdev_get_tx_queue(pfvf->netdev, qidx);
+	int hdr_len = skb_transport_offset(skb) + tcp_hdrlen(skb);
+	int tcp_data, seg_len, pkt_len, offset;
+	struct nix_sqe_hdr_s *sqe_hdr;
+	int first_sqe = sq->head;
+	struct sg_list list;
+	struct tso_t tso;
+
+	/* Map SKB's fragments to DMA.
+	 * It's done here to avoid mapping for every TSO segment's packet.
+	 */
+	if (otx2_dma_map_tso_skb(pfvf, sq, skb, first_sqe, hdr_len)) {
+		dev_kfree_skb_any(skb);
+		return;
+	}
+
+	netdev_tx_sent_queue(txq, skb->len);
+
+	tso_start(skb, &tso);
+	tcp_data = skb->len - hdr_len;
+	while (tcp_data > 0) {
+		char *hdr;
+
+		seg_len = min_t(int, skb_shinfo(skb)->gso_size, tcp_data);
+		tcp_data -= seg_len;
+
+		/* Set SQE's SEND_HDR */
+		memset(sq->sqe_base, 0, sq->sqe_size);
+		sqe_hdr = (struct nix_sqe_hdr_s *)(sq->sqe_base);
+		otx2_sqe_add_hdr(pfvf, sq, sqe_hdr, skb, qidx);
+		offset = sizeof(*sqe_hdr);
+
+		/* Add TSO segment's pkt header */
+		hdr = sq->tso_hdrs->base + (sq->head * TSO_HEADER_SIZE);
+		tso_build_hdr(skb, hdr, &tso, seg_len, tcp_data == 0);
+		list.dma_addr[0] =
+			sq->tso_hdrs->iova + (sq->head * TSO_HEADER_SIZE);
+		list.size[0] = hdr_len;
+		list.num_segs = 1;
+
+		/* Add TSO segment's payload data fragments */
+		pkt_len = hdr_len;
+		while (seg_len > 0) {
+			int size;
+
+			size = min_t(int, tso.size, seg_len);
+
+			list.size[list.num_segs] = size;
+			list.dma_addr[list.num_segs] =
+				otx2_tso_frag_dma_addr(sq, skb,
+						       tso.next_frag_idx - 1,
+						       (u64)tso.data, hdr_len,
+						       first_sqe);
+			list.num_segs++;
+			pkt_len += size;
+			seg_len -= size;
+			tso_build_data(skb, &tso, size);
+		}
+		sqe_hdr->total = pkt_len;
+		otx2_sqe_tso_add_sg(sq, &list, &offset);
+
+		/* DMA mappings and skb needs to be freed only after last
+		 * TSO segment is transmitted out. So set 'PNC' only for
+		 * last segment. Also point last segment's sqe_id to first
+		 * segment's SQE index where skb address and DMA mappings
+		 * are saved.
+		 */
+		if (!tcp_data) {
+			sqe_hdr->pnc = 1;
+			sqe_hdr->sqe_id = first_sqe;
+			sq->sg[first_sqe].skb = (u64)skb;
+		} else {
+			sqe_hdr->pnc = 0;
+		}
+
+		sqe_hdr->sizem1 = (offset / 16) - 1;
+
+		/* Flush SQE to HW */
+		otx2_sqe_flush(sq, offset);
+	}
+}
+
+static bool is_hw_tso_supported(struct otx2_nic *pfvf,
+				struct sk_buff *skb)
+{
+	int payload_len, last_seg_size;
+
+	if (!pfvf->hw.hw_tso)
+		return false;
+
+	/* HW has an issue due to which when the payload of the last LSO
+	 * segment is shorter than 16 bytes, some header fields may not
+	 * be correctly modified, hence don't offload such TSO segments.
+	 */
+	if (!is_96xx_B0(pfvf->pdev))
+		return true;
+
+	payload_len = skb->len - (skb_transport_offset(skb) + tcp_hdrlen(skb));
+	last_seg_size = payload_len % skb_shinfo(skb)->gso_size;
+	if (last_seg_size && last_seg_size < 16)
+		return false;
+
+	return true;
+}
+
+static int otx2_get_sqe_count(struct otx2_nic *pfvf, struct sk_buff *skb)
+{
+	if (!skb_shinfo(skb)->gso_size)
+		return 1;
+
+	/* HW TSO */
+	if (is_hw_tso_supported(pfvf, skb))
+		return 1;
+
+	/* SW TSO */
+	return skb_shinfo(skb)->gso_segs;
+}
+
 bool otx2_sq_append_skb(struct net_device *netdev, struct otx2_snd_queue *sq,
 			struct sk_buff *skb, u16 qidx)
 {
@@ -498,7 +734,8 @@ bool otx2_sq_append_skb(struct net_device *netdev, struct otx2_snd_queue *sq,
 	 */
 	free_sqe = (sq->num_sqbs - *sq->aura_fc_addr) * sq->sqe_per_sqb;
 
-	if (!free_sqe || free_sqe < sq->sqe_thresh)
+	if (free_sqe < sq->sqe_thresh ||
+	    free_sqe < otx2_get_sqe_count(pfvf, skb))
 		return false;
 
 	num_segs = skb_shinfo(skb)->nr_frags + 1;
@@ -514,6 +751,11 @@ bool otx2_sq_append_skb(struct net_device *netdev, struct otx2_snd_queue *sq,
 		num_segs = skb_shinfo(skb)->nr_frags + 1;
 	}
 
+	if (skb_shinfo(skb)->gso_size && !is_hw_tso_supported(pfvf, skb)) {
+		otx2_sq_append_tso(pfvf, sq, skb, qidx);
+		return true;
+	}
+
 	/* Set SQE's SEND_HDR.
 	 * Do not clear the first 64bit as it contains constant info.
 	 */
@@ -522,6 +764,9 @@ bool otx2_sq_append_skb(struct net_device *netdev, struct otx2_snd_queue *sq,
 	otx2_sqe_add_hdr(pfvf, sq, sqe_hdr, skb, qidx);
 	offset = sizeof(*sqe_hdr);
 
+	/* Add extended header if needed */
+	otx2_sqe_add_ext(pfvf, sq, skb, &offset);
+
 	/* Add SG subdesc with data frags */
 	if (!otx2_sqe_add_sg(pfvf, sq, skb, num_segs, &offset)) {
 		otx2_dma_unmap_skb_frags(pfvf, &sq->sg[sq->head]);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
index a889b49..107a261 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
@@ -26,6 +26,7 @@
 #define	OTX2_MIN_MTU		64
 #define	OTX2_MAX_MTU		(9212 - OTX2_ETH_HLEN)
 
+#define OTX2_MAX_GSO_SEGS	255
 #define OTX2_MAX_FRAGS_IN_SQE	9
 
 /* Rx buffer size should be in multiples of 128bytes */
@@ -79,6 +80,7 @@ struct otx2_snd_queue {
 	u64			*lmt_addr;
 	void			*sqe_base;
 	struct qmem		*sqe;
+	struct qmem		*tso_hdrs;
 	struct sg_list		*sg;
 	u16			sqb_count;
 	u64			*sqb_ptrs;
-- 
2.7.4

