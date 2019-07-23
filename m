Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5938D70F92
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 05:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387929AbfGWDIv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 23:08:51 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:36422 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387917AbfGWDIs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 23:08:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=GmiY3alQ7lRU+uEGBtfnWninzaRU2Vx70ZFCsrXGCJc=; b=rpo6BM3+WGMJgtoUad3S2bxBkZ
        pTOMJQll7qt02Ty7MZKhne7rCc5emwr1oZah2WA19BXKFpFvxJ+9KolHABtacI1DzMCauumY2W/Vk
        qHlJelVCmTq0zxhfQEktOLjAE+LgUUk1cz7WaxX7bsBAy94KQpmDr5jHh/RshqKxy84qt6W0Y1nci
        CXOx70jNTR+kmjT/abN6WR1a3RlqueSO6SatqrCzndKWjtw5coaPSG8lRhI/1jFG7rVG+XuMRBBdk
        SidiiVRlySBOAPXvatz52A1Wu8//RyVTiYic/hECIi4Vd/X3NBwASRX/niGR7kN2NhMWaGZpWr0x/
        V8Z2l33w==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hplAJ-00036b-AF; Tue, 23 Jul 2019 03:08:35 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     davem@davemloft.net
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>, hch@lst.de,
        netdev@vger.kernel.org
Subject: [PATCH v3 1/7] net: Use skb accessors in network drivers
Date:   Mon, 22 Jul 2019 20:08:25 -0700
Message-Id: <20190723030831.11879-2-willy@infradead.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190723030831.11879-1-willy@infradead.org>
References: <20190723030831.11879-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

In preparation for unifying the skb_frag and bio_vec, use the fine
accessors which already exist and use skb_frag_t instead of
struct skb_frag_struct.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 drivers/crypto/chelsio/chtls/chtls_io.c       |  6 +++--
 drivers/hsi/clients/ssi_protocol.c            |  3 ++-
 drivers/infiniband/hw/hfi1/vnic_sdma.c        |  2 +-
 drivers/net/ethernet/3com/3c59x.c             |  2 +-
 drivers/net/ethernet/agere/et131x.c           |  6 ++---
 drivers/net/ethernet/amd/xgbe/xgbe-desc.c     |  2 +-
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c      |  2 +-
 .../net/ethernet/apm/xgene/xgene_enet_main.c  |  3 ++-
 drivers/net/ethernet/atheros/alx/main.c       |  4 +---
 .../net/ethernet/atheros/atl1c/atl1c_main.c   |  4 +---
 .../net/ethernet/atheros/atl1e/atl1e_main.c   |  3 +--
 drivers/net/ethernet/atheros/atlx/atl1.c      |  3 +--
 drivers/net/ethernet/broadcom/bgmac.c         |  2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  2 +-
 drivers/net/ethernet/brocade/bna/bnad.c       |  2 +-
 drivers/net/ethernet/calxeda/xgmac.c          |  2 +-
 .../net/ethernet/cavium/liquidio/lio_main.c   | 23 +++++++++----------
 .../ethernet/cavium/liquidio/lio_vf_main.c    | 23 +++++++++----------
 .../ethernet/cavium/thunder/nicvf_queues.c    |  4 +---
 drivers/net/ethernet/chelsio/cxgb3/sge.c      |  2 +-
 drivers/net/ethernet/cortina/gemini.c         |  5 ++--
 drivers/net/ethernet/emulex/benet/be_main.c   |  2 +-
 drivers/net/ethernet/freescale/enetc/enetc.c  |  2 +-
 drivers/net/ethernet/freescale/fec_main.c     |  4 ++--
 drivers/net/ethernet/hisilicon/hix5hd2_gmac.c |  2 +-
 drivers/net/ethernet/hisilicon/hns/hns_enet.c |  4 ++--
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   |  8 +++----
 drivers/net/ethernet/huawei/hinic/hinic_tx.c  |  2 +-
 drivers/net/ethernet/ibm/emac/core.c          |  2 +-
 drivers/net/ethernet/intel/e1000/e1000_main.c |  3 +--
 drivers/net/ethernet/intel/e1000e/netdev.c    |  3 +--
 drivers/net/ethernet/intel/fm10k/fm10k_main.c |  5 ++--
 drivers/net/ethernet/intel/i40e/i40e_txrx.c   |  4 ++--
 drivers/net/ethernet/intel/i40e/i40e_txrx.h   |  2 +-
 drivers/net/ethernet/intel/iavf/iavf_txrx.c   |  4 ++--
 drivers/net/ethernet/intel/iavf/iavf_txrx.h   |  2 +-
 drivers/net/ethernet/intel/ice/ice_txrx.c     |  6 ++---
 drivers/net/ethernet/intel/igb/igb_main.c     |  5 ++--
 drivers/net/ethernet/intel/igbvf/netdev.c     |  2 +-
 drivers/net/ethernet/intel/igc/igc_main.c     |  5 ++--
 drivers/net/ethernet/intel/ixgb/ixgb_main.c   |  4 +---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |  9 ++++----
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c |  2 +-
 drivers/net/ethernet/jme.c                    |  5 ++--
 drivers/net/ethernet/marvell/mvneta.c         |  4 ++--
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |  7 +++---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c   |  4 ++--
 drivers/net/ethernet/mellanox/mlx4/en_tx.c    |  4 +---
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   |  2 +-
 drivers/net/ethernet/microchip/lan743x_main.c |  5 ++--
 .../net/ethernet/myricom/myri10ge/myri10ge.c  | 10 ++++----
 .../ethernet/netronome/nfp/nfp_net_common.c   |  6 ++---
 .../ethernet/qlogic/netxen/netxen_nic_main.c  |  4 ++--
 .../net/ethernet/qlogic/qlcnic/qlcnic_io.c    |  2 +-
 drivers/net/ethernet/qualcomm/emac/emac-mac.c | 12 ++++------
 .../net/ethernet/synopsys/dwc-xlgmac-desc.c   |  2 +-
 .../net/ethernet/synopsys/dwc-xlgmac-net.c    |  2 +-
 drivers/net/ethernet/tehuti/tehuti.c          |  2 +-
 drivers/net/usb/usbnet.c                      |  4 ++--
 drivers/net/vmxnet3/vmxnet3_drv.c             |  7 +++---
 drivers/net/wireless/ath/wil6210/debugfs.c    |  3 +--
 drivers/net/wireless/ath/wil6210/txrx.c       |  9 ++++----
 drivers/net/wireless/ath/wil6210/txrx_edma.c  |  2 +-
 drivers/net/xen-netback/netback.c             |  4 ++--
 drivers/s390/net/qeth_core_main.c             |  2 +-
 drivers/scsi/fcoe/fcoe_transport.c            |  2 +-
 drivers/staging/octeon/ethernet-tx.c          |  5 ++--
 .../staging/unisys/visornic/visornic_main.c   |  4 ++--
 drivers/target/iscsi/cxgbit/cxgbit_target.c   | 13 ++++++-----
 69 files changed, 149 insertions(+), 164 deletions(-)

diff --git a/drivers/crypto/chelsio/chtls/chtls_io.c b/drivers/crypto/chelsio/chtls/chtls_io.c
index 551bca6fef24..c70cb5f272cf 100644
--- a/drivers/crypto/chelsio/chtls/chtls_io.c
+++ b/drivers/crypto/chelsio/chtls/chtls_io.c
@@ -1134,7 +1134,9 @@ int chtls_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 			}
 			/* Update the skb. */
 			if (merge) {
-				skb_shinfo(skb)->frags[i - 1].size += copy;
+				skb_frag_size_add(
+						&skb_shinfo(skb)->frags[i - 1],
+						copy);
 			} else {
 				skb_fill_page_desc(skb, i, page, off, copy);
 				if (off + copy < pg_size) {
@@ -1247,7 +1249,7 @@ int chtls_sendpage(struct sock *sk, struct page *page,
 
 		i = skb_shinfo(skb)->nr_frags;
 		if (skb_can_coalesce(skb, i, page, offset)) {
-			skb_shinfo(skb)->frags[i - 1].size += copy;
+			skb_frag_size_add(&skb_shinfo(skb)->frags[i - 1], copy);
 		} else if (i < MAX_SKB_FRAGS) {
 			get_page(page);
 			skb_fill_page_desc(skb, i, page, offset, copy);
diff --git a/drivers/hsi/clients/ssi_protocol.c b/drivers/hsi/clients/ssi_protocol.c
index 9aeed98b87a1..c9e3f928b93d 100644
--- a/drivers/hsi/clients/ssi_protocol.c
+++ b/drivers/hsi/clients/ssi_protocol.c
@@ -181,7 +181,8 @@ static void ssip_skb_to_msg(struct sk_buff *skb, struct hsi_msg *msg)
 		sg = sg_next(sg);
 		BUG_ON(!sg);
 		frag = &skb_shinfo(skb)->frags[i];
-		sg_set_page(sg, frag->page.p, frag->size, frag->page_offset);
+		sg_set_page(sg, skb_frag_page(frag), skb_frag_size(frag),
+				frag->page_offset);
 	}
 }
 
diff --git a/drivers/infiniband/hw/hfi1/vnic_sdma.c b/drivers/infiniband/hw/hfi1/vnic_sdma.c
index af1b1ffcb38e..05a140504a99 100644
--- a/drivers/infiniband/hw/hfi1/vnic_sdma.c
+++ b/drivers/infiniband/hw/hfi1/vnic_sdma.c
@@ -102,7 +102,7 @@ static noinline int build_vnic_ulp_payload(struct sdma_engine *sde,
 		goto bail_txadd;
 
 	for (i = 0; i < skb_shinfo(tx->skb)->nr_frags; i++) {
-		struct skb_frag_struct *frag = &skb_shinfo(tx->skb)->frags[i];
+		skb_frag_t *frag = &skb_shinfo(tx->skb)->frags[i];
 
 		/* combine physically continuous fragments later? */
 		ret = sdma_txadd_page(sde->dd,
diff --git a/drivers/net/ethernet/3com/3c59x.c b/drivers/net/ethernet/3com/3c59x.c
index 147051404194..7be91e896f2d 100644
--- a/drivers/net/ethernet/3com/3c59x.c
+++ b/drivers/net/ethernet/3com/3c59x.c
@@ -2175,7 +2175,7 @@ boomerang_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 			dma_addr = skb_frag_dma_map(vp->gendev, frag,
 						    0,
-						    frag->size,
+						    skb_frag_size(frag),
 						    DMA_TO_DEVICE);
 			if (dma_mapping_error(vp->gendev, dma_addr)) {
 				for(i = i-1; i >= 0; i--)
diff --git a/drivers/net/ethernet/agere/et131x.c b/drivers/net/ethernet/agere/et131x.c
index ea34bcb868b5..e43d922f043e 100644
--- a/drivers/net/ethernet/agere/et131x.c
+++ b/drivers/net/ethernet/agere/et131x.c
@@ -2426,7 +2426,7 @@ static int nic_send_packet(struct et131x_adapter *adapter, struct tcb *tcb)
 	u32 thiscopy, remainder;
 	struct sk_buff *skb = tcb->skb;
 	u32 nr_frags = skb_shinfo(skb)->nr_frags + 1;
-	struct skb_frag_struct *frags = &skb_shinfo(skb)->frags[0];
+	skb_frag_t *frags = &skb_shinfo(skb)->frags[0];
 	struct phy_device *phydev = adapter->netdev->phydev;
 	dma_addr_t dma_addr;
 	struct tx_ring *tx_ring = &adapter->tx_ring;
@@ -2488,11 +2488,11 @@ static int nic_send_packet(struct et131x_adapter *adapter, struct tcb *tcb)
 				frag++;
 			}
 		} else {
-			desc[frag].len_vlan = frags[i - 1].size;
+			desc[frag].len_vlan = skb_frag_size(&frags[i - 1]);
 			dma_addr = skb_frag_dma_map(&adapter->pdev->dev,
 						    &frags[i - 1],
 						    0,
-						    frags[i - 1].size,
+						    desc[frag].len_vlan,
 						    DMA_TO_DEVICE);
 			desc[frag].addr_lo = lower_32_bits(dma_addr);
 			desc[frag].addr_hi = upper_32_bits(dma_addr);
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-desc.c b/drivers/net/ethernet/amd/xgbe/xgbe-desc.c
index 533094233659..230726d7b74f 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-desc.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-desc.c
@@ -526,7 +526,7 @@ static int xgbe_map_tx_skb(struct xgbe_channel *channel, struct sk_buff *skb)
 	struct xgbe_ring *ring = channel->tx_ring;
 	struct xgbe_ring_data *rdata;
 	struct xgbe_packet_data *packet;
-	struct skb_frag_struct *frag;
+	skb_frag_t *frag;
 	dma_addr_t skb_dma;
 	unsigned int start_index, cur_index;
 	unsigned int offset, tso, vlan, datalen, len;
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
index 3dd0cecddba8..98f8f2033154 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
@@ -1833,7 +1833,7 @@ static void xgbe_packet_info(struct xgbe_prv_data *pdata,
 			     struct xgbe_ring *ring, struct sk_buff *skb,
 			     struct xgbe_packet_data *packet)
 {
-	struct skb_frag_struct *frag;
+	skb_frag_t *frag;
 	unsigned int context_desc;
 	unsigned int len;
 	unsigned int i;
diff --git a/drivers/net/ethernet/apm/xgene/xgene_enet_main.c b/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
index 10b1c053e70a..949bff4d2921 100644
--- a/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
+++ b/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
@@ -340,7 +340,8 @@ static int xgene_enet_work_msg(struct sk_buff *skb, u64 *hopinfo)
 				nr_frags = skb_shinfo(skb)->nr_frags;
 
 				for (i = 0; i < 2 && i < nr_frags; i++)
-					len += skb_shinfo(skb)->frags[i].size;
+					len += skb_frag_size(
+						&skb_shinfo(skb)->frags[i]);
 
 				/* HW requires header must reside in 3 buffer */
 				if (unlikely(hdr_len > len)) {
diff --git a/drivers/net/ethernet/atheros/alx/main.c b/drivers/net/ethernet/atheros/alx/main.c
index e3538ba7d0e7..a3ec738da336 100644
--- a/drivers/net/ethernet/atheros/alx/main.c
+++ b/drivers/net/ethernet/atheros/alx/main.c
@@ -1465,9 +1465,7 @@ static int alx_map_tx_skb(struct alx_tx_queue *txq, struct sk_buff *skb)
 	tpd->len = cpu_to_le16(maplen);
 
 	for (f = 0; f < skb_shinfo(skb)->nr_frags; f++) {
-		struct skb_frag_struct *frag;
-
-		frag = &skb_shinfo(skb)->frags[f];
+		skb_frag_t *frag = &skb_shinfo(skb)->frags[f];
 
 		if (++txq->write_idx == txq->count)
 			txq->write_idx = 0;
diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index be7f9cebb675..179ad62a2bd2 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -2150,9 +2150,7 @@ static int atl1c_tx_map(struct atl1c_adapter *adapter,
 	}
 
 	for (f = 0; f < nr_frags; f++) {
-		struct skb_frag_struct *frag;
-
-		frag = &skb_shinfo(skb)->frags[f];
+		skb_frag_t *frag = &skb_shinfo(skb)->frags[f];
 
 		use_tpd = atl1c_get_tpd(adapter, type);
 		memcpy(use_tpd, tpd, sizeof(struct atl1c_tpd_desc));
diff --git a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
index 7f14e010bfeb..4f7b65825c15 100644
--- a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
+++ b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
@@ -1770,11 +1770,10 @@ static int atl1e_tx_map(struct atl1e_adapter *adapter,
 	}
 
 	for (f = 0; f < nr_frags; f++) {
-		const struct skb_frag_struct *frag;
+		const skb_frag_t *frag = &skb_shinfo(skb)->frags[f];
 		u16 i;
 		u16 seg_num;
 
-		frag = &skb_shinfo(skb)->frags[f];
 		buf_len = skb_frag_size(frag);
 
 		seg_num = (buf_len + MAX_TX_BUF_LEN - 1) / MAX_TX_BUF_LEN;
diff --git a/drivers/net/ethernet/atheros/atlx/atl1.c b/drivers/net/ethernet/atheros/atlx/atl1.c
index 7c767ce9aafa..c9e6d9768273 100644
--- a/drivers/net/ethernet/atheros/atlx/atl1.c
+++ b/drivers/net/ethernet/atheros/atlx/atl1.c
@@ -2258,10 +2258,9 @@ static void atl1_tx_map(struct atl1_adapter *adapter, struct sk_buff *skb,
 	}
 
 	for (f = 0; f < nr_frags; f++) {
-		const struct skb_frag_struct *frag;
+		const skb_frag_t *frag = &skb_shinfo(skb)->frags[f];
 		u16 i, nseg;
 
-		frag = &skb_shinfo(skb)->frags[f];
 		buf_len = skb_frag_size(frag);
 
 		nseg = (buf_len + ATL1_MAX_TX_BUF_LEN - 1) /
diff --git a/drivers/net/ethernet/broadcom/bgmac.c b/drivers/net/ethernet/broadcom/bgmac.c
index 4632dd5dbad1..148734b166f0 100644
--- a/drivers/net/ethernet/broadcom/bgmac.c
+++ b/drivers/net/ethernet/broadcom/bgmac.c
@@ -172,7 +172,7 @@ static netdev_tx_t bgmac_dma_tx_add(struct bgmac *bgmac,
 	flags = 0;
 
 	for (i = 0; i < nr_frags; i++) {
-		struct skb_frag_struct *frag = &skb_shinfo(skb)->frags[i];
+		skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 		int len = skb_frag_size(frag);
 
 		index = (index + 1) % BGMAC_TX_RING_SLOTS;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 3f632028eff0..75389d19f317 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -888,7 +888,7 @@ static struct sk_buff *bnxt_rx_page_skb(struct bnxt *bp,
 {
 	unsigned int payload = offset_and_len >> 16;
 	unsigned int len = offset_and_len & 0xffff;
-	struct skb_frag_struct *frag;
+	skb_frag_t *frag;
 	struct page *page = data;
 	u16 prod = rxr->rx_prod;
 	struct sk_buff *skb;
diff --git a/drivers/net/ethernet/brocade/bna/bnad.c b/drivers/net/ethernet/brocade/bna/bnad.c
index 7767ae6fa1fd..e338272931d1 100644
--- a/drivers/net/ethernet/brocade/bna/bnad.c
+++ b/drivers/net/ethernet/brocade/bna/bnad.c
@@ -3032,7 +3032,7 @@ bnad_start_xmit(struct sk_buff *skb, struct net_device *netdev)
 	head_unmap->nvecs++;
 
 	for (i = 0, vect_id = 0; i < vectors - 1; i++) {
-		const struct skb_frag_struct *frag = &skb_shinfo(skb)->frags[i];
+		const skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 		u32		size = skb_frag_size(frag);
 
 		if (unlikely(size == 0)) {
diff --git a/drivers/net/ethernet/calxeda/xgmac.c b/drivers/net/ethernet/calxeda/xgmac.c
index 99f49d059414..f96a42af1014 100644
--- a/drivers/net/ethernet/calxeda/xgmac.c
+++ b/drivers/net/ethernet/calxeda/xgmac.c
@@ -1104,7 +1104,7 @@ static netdev_tx_t xgmac_xmit(struct sk_buff *skb, struct net_device *dev)
 	for (i = 0; i < nfrags; i++) {
 		skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 
-		len = frag->size;
+		len = skb_frag_size(frag);
 
 		paddr = skb_frag_dma_map(priv->device, frag, 0, len,
 					 DMA_TO_DEVICE);
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_main.c b/drivers/net/ethernet/cavium/liquidio/lio_main.c
index eab805579f96..7f3b2e3b0868 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_main.c
@@ -1492,11 +1492,11 @@ static void free_netsgbuf(void *buf)
 
 	i = 1;
 	while (frags--) {
-		struct skb_frag_struct *frag = &skb_shinfo(skb)->frags[i - 1];
+		skb_frag_t *frag = &skb_shinfo(skb)->frags[i - 1];
 
 		pci_unmap_page((lio->oct_dev)->pci_dev,
 			       g->sg[(i >> 2)].ptr[(i & 3)],
-			       frag->size, DMA_TO_DEVICE);
+			       skb_frag_size(frag), DMA_TO_DEVICE);
 		i++;
 	}
 
@@ -1535,11 +1535,11 @@ static void free_netsgbuf_with_resp(void *buf)
 
 	i = 1;
 	while (frags--) {
-		struct skb_frag_struct *frag = &skb_shinfo(skb)->frags[i - 1];
+		skb_frag_t *frag = &skb_shinfo(skb)->frags[i - 1];
 
 		pci_unmap_page((lio->oct_dev)->pci_dev,
 			       g->sg[(i >> 2)].ptr[(i & 3)],
-			       frag->size, DMA_TO_DEVICE);
+			       skb_frag_size(frag), DMA_TO_DEVICE);
 		i++;
 	}
 
@@ -2424,7 +2424,7 @@ static netdev_tx_t liquidio_xmit(struct sk_buff *skb, struct net_device *netdev)
 
 	} else {
 		int i, frags;
-		struct skb_frag_struct *frag;
+		skb_frag_t *frag;
 		struct octnic_gather *g;
 
 		spin_lock(&lio->glist_lock[q_idx]);
@@ -2462,11 +2462,9 @@ static netdev_tx_t liquidio_xmit(struct sk_buff *skb, struct net_device *netdev)
 			frag = &skb_shinfo(skb)->frags[i - 1];
 
 			g->sg[(i >> 2)].ptr[(i & 3)] =
-				dma_map_page(&oct->pci_dev->dev,
-					     frag->page.p,
-					     frag->page_offset,
-					     frag->size,
-					     DMA_TO_DEVICE);
+				skb_frag_dma_map(&oct->pci_dev->dev,
+					         frag, 0, skb_frag_size(frag),
+						 DMA_TO_DEVICE);
 
 			if (dma_mapping_error(&oct->pci_dev->dev,
 					      g->sg[i >> 2].ptr[i & 3])) {
@@ -2478,7 +2476,7 @@ static netdev_tx_t liquidio_xmit(struct sk_buff *skb, struct net_device *netdev)
 					frag = &skb_shinfo(skb)->frags[j - 1];
 					dma_unmap_page(&oct->pci_dev->dev,
 						       g->sg[j >> 2].ptr[j & 3],
-						       frag->size,
+						       skb_frag_size(frag),
 						       DMA_TO_DEVICE);
 				}
 				dev_err(&oct->pci_dev->dev, "%s DMA mapping error 3\n",
@@ -2486,7 +2484,8 @@ static netdev_tx_t liquidio_xmit(struct sk_buff *skb, struct net_device *netdev)
 				return NETDEV_TX_BUSY;
 			}
 
-			add_sg_size(&g->sg[(i >> 2)], frag->size, (i & 3));
+			add_sg_size(&g->sg[(i >> 2)], skb_frag_size(frag),
+				    (i & 3));
 			i++;
 		}
 
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
index db0b90555acb..370d76822ee0 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
@@ -837,11 +837,11 @@ static void free_netsgbuf(void *buf)
 
 	i = 1;
 	while (frags--) {
-		struct skb_frag_struct *frag = &skb_shinfo(skb)->frags[i - 1];
+		skb_frag_t *frag = &skb_shinfo(skb)->frags[i - 1];
 
 		pci_unmap_page((lio->oct_dev)->pci_dev,
 			       g->sg[(i >> 2)].ptr[(i & 3)],
-			       frag->size, DMA_TO_DEVICE);
+			       skb_frag_size(frag), DMA_TO_DEVICE);
 		i++;
 	}
 
@@ -881,11 +881,11 @@ static void free_netsgbuf_with_resp(void *buf)
 
 	i = 1;
 	while (frags--) {
-		struct skb_frag_struct *frag = &skb_shinfo(skb)->frags[i - 1];
+		skb_frag_t *frag = &skb_shinfo(skb)->frags[i - 1];
 
 		pci_unmap_page((lio->oct_dev)->pci_dev,
 			       g->sg[(i >> 2)].ptr[(i & 3)],
-			       frag->size, DMA_TO_DEVICE);
+			       skb_frag_size(frag), DMA_TO_DEVICE);
 		i++;
 	}
 
@@ -1497,7 +1497,7 @@ static netdev_tx_t liquidio_xmit(struct sk_buff *skb, struct net_device *netdev)
 		ndata.reqtype = REQTYPE_NORESP_NET;
 
 	} else {
-		struct skb_frag_struct *frag;
+		skb_frag_t *frag;
 		struct octnic_gather *g;
 		int i, frags;
 
@@ -1535,11 +1535,9 @@ static netdev_tx_t liquidio_xmit(struct sk_buff *skb, struct net_device *netdev)
 			frag = &skb_shinfo(skb)->frags[i - 1];
 
 			g->sg[(i >> 2)].ptr[(i & 3)] =
-				dma_map_page(&oct->pci_dev->dev,
-					     frag->page.p,
-					     frag->page_offset,
-					     frag->size,
-					     DMA_TO_DEVICE);
+				skb_frag_dma_map(&oct->pci_dev->dev,
+						 frag, 0, skb_frag_size(frag),
+						 DMA_TO_DEVICE);
 			if (dma_mapping_error(&oct->pci_dev->dev,
 					      g->sg[i >> 2].ptr[i & 3])) {
 				dma_unmap_single(&oct->pci_dev->dev,
@@ -1550,7 +1548,7 @@ static netdev_tx_t liquidio_xmit(struct sk_buff *skb, struct net_device *netdev)
 					frag = &skb_shinfo(skb)->frags[j - 1];
 					dma_unmap_page(&oct->pci_dev->dev,
 						       g->sg[j >> 2].ptr[j & 3],
-						       frag->size,
+						       skb_frag_size(frag),
 						       DMA_TO_DEVICE);
 				}
 				dev_err(&oct->pci_dev->dev, "%s DMA mapping error 3\n",
@@ -1558,7 +1556,8 @@ static netdev_tx_t liquidio_xmit(struct sk_buff *skb, struct net_device *netdev)
 				return NETDEV_TX_BUSY;
 			}
 
-			add_sg_size(&g->sg[(i >> 2)], frag->size, (i & 3));
+			add_sg_size(&g->sg[(i >> 2)], skb_frag_size(frag),
+				    (i & 3));
 			i++;
 		}
 
diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_queues.c b/drivers/net/ethernet/cavium/thunder/nicvf_queues.c
index 192bc92da881..c0266a87794c 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_queues.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_queues.c
@@ -1588,9 +1588,7 @@ int nicvf_sq_append_skb(struct nicvf *nic, struct snd_queue *sq,
 		goto doorbell;
 
 	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
-		const struct skb_frag_struct *frag;
-
-		frag = &skb_shinfo(skb)->frags[i];
+		const skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 
 		qentry = nicvf_get_nxt_sqentry(sq, qentry);
 		size = skb_frag_size(frag);
diff --git a/drivers/net/ethernet/chelsio/cxgb3/sge.c b/drivers/net/ethernet/chelsio/cxgb3/sge.c
index 89db739b7819..310a232e00f0 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/sge.c
@@ -2132,7 +2132,7 @@ static void lro_add_page(struct adapter *adap, struct sge_qset *qs,
 	struct port_info *pi = netdev_priv(qs->netdev);
 	struct sk_buff *skb = NULL;
 	struct cpl_rx_pkt *cpl;
-	struct skb_frag_struct *rx_frag;
+	skb_frag_t *rx_frag;
 	int nr_frags;
 	int offset = 0;
 
diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
index 9003eb6716cd..46dd6b4886b6 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -1182,9 +1182,8 @@ static int gmac_map_tx_bufs(struct net_device *netdev, struct sk_buff *skb,
 			buflen = skb_headlen(skb);
 		} else {
 			skb_frag = skb_si->frags + frag;
-			buffer = page_address(skb_frag_page(skb_frag)) +
-				 skb_frag->page_offset;
-			buflen = skb_frag->size;
+			buffer = skb_frag_address(skb_frag);
+			buflen = skb_frag_size(skb_frag);
 		}
 
 		if (frag == last_frag) {
diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
index 82015c8a5ed7..7eee76bc7d69 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -1014,7 +1014,7 @@ static u32 be_xmit_enqueue(struct be_adapter *adapter, struct be_tx_obj *txo,
 	}
 
 	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
-		const struct skb_frag_struct *frag = &skb_shinfo(skb)->frags[i];
+		const skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 		len = skb_frag_size(frag);
 
 		busaddr = skb_frag_dma_map(dev, frag, 0, len, DMA_TO_DEVICE);
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 223709443ea4..b6ff89307409 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -110,7 +110,7 @@ static int enetc_map_tx_buffs(struct enetc_bdr *tx_ring, struct sk_buff *skb,
 			      int active_offloads)
 {
 	struct enetc_tx_swbd *tx_swbd;
-	struct skb_frag_struct *frag;
+	skb_frag_t *frag;
 	int len = skb_headlen(skb);
 	union enetc_tx_bd temp_bd;
 	union enetc_tx_bd *txbd;
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 9d459ccf251d..8a6107be1f95 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -365,7 +365,7 @@ fec_enet_txq_submit_frag_skb(struct fec_enet_priv_tx_q *txq,
 		status = fec16_to_cpu(bdp->cbd_sc);
 		status &= ~BD_ENET_TX_STATS;
 		status |= (BD_ENET_TX_TC | BD_ENET_TX_READY);
-		frag_len = skb_shinfo(skb)->frags[frag].size;
+		frag_len = skb_frag_size(&skb_shinfo(skb)->frags[frag]);
 
 		/* Handle the last BD specially */
 		if (frag == nr_frags - 1) {
@@ -387,7 +387,7 @@ fec_enet_txq_submit_frag_skb(struct fec_enet_priv_tx_q *txq,
 			ebdp->cbd_esc = cpu_to_fec32(estatus);
 		}
 
-		bufaddr = page_address(this_frag->page.p) + this_frag->page_offset;
+		bufaddr = skb_frag_address(this_frag);
 
 		index = fec_enet_get_bd_index(bdp, &txq->bd);
 		if (((unsigned long) bufaddr) & fep->tx_align ||
diff --git a/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c b/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
index 89ef764e1c4b..765fcdb65839 100644
--- a/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
+++ b/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
@@ -719,7 +719,7 @@ static int hix5hd2_fill_sg_desc(struct hix5hd2_priv *priv,
 
 	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
 		skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
-		int len = frag->size;
+		int len = skb_frag_size(frag);
 
 		addr = skb_frag_dma_map(priv->dev, frag, 0, len, DMA_TO_DEVICE);
 		ret = dma_mapping_error(priv->dev, addr);
diff --git a/drivers/net/ethernet/hisilicon/hns/hns_enet.c b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
index 2235dd55fab2..1545536ef769 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
@@ -245,7 +245,7 @@ static int hns_nic_maybe_stop_tso(
 	int frag_num;
 	struct sk_buff *skb = *out_skb;
 	struct sk_buff *new_skb = NULL;
-	struct skb_frag_struct *frag;
+	skb_frag_t *frag;
 
 	size = skb_headlen(skb);
 	buf_num = (size + BD_MAX_SEND_SIZE - 1) / BD_MAX_SEND_SIZE;
@@ -309,7 +309,7 @@ netdev_tx_t hns_nic_net_xmit_hw(struct net_device *ndev,
 	struct hnae_ring *ring = ring_data->ring;
 	struct device *dev = ring_to_dev(ring);
 	struct netdev_queue *dev_queue;
-	struct skb_frag_struct *frag;
+	skb_frag_t *frag;
 	int buf_num;
 	int seg_num;
 	dma_addr_t dma;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 310afa708831..69f7ef810654 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1033,7 +1033,7 @@ static int hns3_fill_desc(struct hns3_enet_ring *ring, void *priv,
 	struct hns3_desc_cb *desc_cb = &ring->desc_cb[ring->next_to_use];
 	struct hns3_desc *desc = &ring->desc[ring->next_to_use];
 	struct device *dev = ring_to_dev(ring);
-	struct skb_frag_struct *frag;
+	skb_frag_t *frag;
 	unsigned int frag_buf_num;
 	int k, sizeoflast;
 	dma_addr_t dma;
@@ -1086,7 +1086,7 @@ static int hns3_fill_desc(struct hns3_enet_ring *ring, void *priv,
 
 		dma = dma_map_single(dev, skb->data, size, DMA_TO_DEVICE);
 	} else {
-		frag = (struct skb_frag_struct *)priv;
+		frag = (skb_frag_t *)priv;
 		dma = skb_frag_dma_map(dev, frag, 0, size, DMA_TO_DEVICE);
 	}
 
@@ -1159,7 +1159,7 @@ static int hns3_nic_bd_num(struct sk_buff *skb)
 	bd_num = hns3_tx_bd_count(size);
 
 	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
-		struct skb_frag_struct *frag = &skb_shinfo(skb)->frags[i];
+		skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 		int frag_bd_num;
 
 		size = skb_frag_size(frag);
@@ -1290,7 +1290,7 @@ netdev_tx_t hns3_nic_net_xmit(struct sk_buff *skb, struct net_device *netdev)
 		&tx_ring_data(priv, skb->queue_mapping);
 	struct hns3_enet_ring *ring = ring_data->ring;
 	struct netdev_queue *dev_queue;
-	struct skb_frag_struct *frag;
+	skb_frag_t *frag;
 	int next_to_use_head;
 	int buf_num;
 	int seg_num;
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_tx.c b/drivers/net/ethernet/huawei/hinic/hinic_tx.c
index 9c78251f9c39..0e13d1c7e474 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_tx.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_tx.c
@@ -136,7 +136,7 @@ static int tx_map_skb(struct hinic_dev *nic_dev, struct sk_buff *skb,
 	struct hinic_hwdev *hwdev = nic_dev->hwdev;
 	struct hinic_hwif *hwif = hwdev->hwif;
 	struct pci_dev *pdev = hwif->pdev;
-	struct skb_frag_struct *frag;
+	skb_frag_t *frag;
 	dma_addr_t dma_addr;
 	int i, j;
 
diff --git a/drivers/net/ethernet/ibm/emac/core.c b/drivers/net/ethernet/ibm/emac/core.c
index 395dde444483..9e43c9ace9c2 100644
--- a/drivers/net/ethernet/ibm/emac/core.c
+++ b/drivers/net/ethernet/ibm/emac/core.c
@@ -1549,7 +1549,7 @@ emac_start_xmit_sg(struct sk_buff *skb, struct net_device *ndev)
 				       ctrl);
 	/* skb fragments */
 	for (i = 0; i < nr_frags; ++i) {
-		struct skb_frag_struct *frag = &skb_shinfo(skb)->frags[i];
+		skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 		len = skb_frag_size(frag);
 
 		if (unlikely(dev->tx_cnt + mal_tx_chunks(len) >= NUM_TX_BUFF))
diff --git a/drivers/net/ethernet/intel/e1000/e1000_main.c b/drivers/net/ethernet/intel/e1000/e1000_main.c
index f703fa58458e..6b6ba1c38235 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_main.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_main.c
@@ -2889,9 +2889,8 @@ static int e1000_tx_map(struct e1000_adapter *adapter,
 	}
 
 	for (f = 0; f < nr_frags; f++) {
-		const struct skb_frag_struct *frag;
+		const skb_frag_t *frag = &skb_shinfo(skb)->frags[f];
 
-		frag = &skb_shinfo(skb)->frags[f];
 		len = skb_frag_size(frag);
 		offset = 0;
 
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index e4baa13b3cda..a0c001d6d9d2 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -5579,9 +5579,8 @@ static int e1000_tx_map(struct e1000_ring *tx_ring, struct sk_buff *skb,
 	}
 
 	for (f = 0; f < nr_frags; f++) {
-		const struct skb_frag_struct *frag;
+		const skb_frag_t *frag = &skb_shinfo(skb)->frags[f];
 
-		frag = &skb_shinfo(skb)->frags[f];
 		len = skb_frag_size(frag);
 		offset = 0;
 
diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_main.c b/drivers/net/ethernet/intel/fm10k/fm10k_main.c
index 90270b4a1682..9ffff7886085 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_main.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_main.c
@@ -946,7 +946,7 @@ static void fm10k_tx_map(struct fm10k_ring *tx_ring,
 	struct sk_buff *skb = first->skb;
 	struct fm10k_tx_buffer *tx_buffer;
 	struct fm10k_tx_desc *tx_desc;
-	struct skb_frag_struct *frag;
+	skb_frag_t *frag;
 	unsigned char *data;
 	dma_addr_t dma;
 	unsigned int data_len, size;
@@ -1074,7 +1074,8 @@ netdev_tx_t fm10k_xmit_frame_ring(struct sk_buff *skb,
 	 * otherwise try next time
 	 */
 	for (f = 0; f < skb_shinfo(skb)->nr_frags; f++)
-		count += TXD_USE_COUNT(skb_shinfo(skb)->frags[f].size);
+		count += TXD_USE_COUNT(skb_frag_size(
+						&skb_shinfo(skb)->frags[f]));
 
 	if (fm10k_maybe_stop_tx(tx_ring, count + 3)) {
 		tx_ring->tx_stats.tx_busy++;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index 2a2fe3ec7926..f162252f01b5 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -3262,7 +3262,7 @@ int __i40e_maybe_stop_tx(struct i40e_ring *tx_ring, int size)
  **/
 bool __i40e_chk_linearize(struct sk_buff *skb)
 {
-	const struct skb_frag_struct *frag, *stale;
+	const skb_frag_t *frag, *stale;
 	int nr_frags, sum;
 
 	/* no need to check if number of frags is less than 7 */
@@ -3349,7 +3349,7 @@ static inline int i40e_tx_map(struct i40e_ring *tx_ring, struct sk_buff *skb,
 {
 	unsigned int data_len = skb->data_len;
 	unsigned int size = skb_headlen(skb);
-	struct skb_frag_struct *frag;
+	skb_frag_t *frag;
 	struct i40e_tx_buffer *tx_bi;
 	struct i40e_tx_desc *tx_desc;
 	u16 i = tx_ring->next_to_use;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.h b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
index 100e92d2982f..36d37f31a287 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
@@ -521,7 +521,7 @@ static inline u32 i40e_get_head(struct i40e_ring *tx_ring)
  **/
 static inline int i40e_xmit_descriptor_count(struct sk_buff *skb)
 {
-	const struct skb_frag_struct *frag = &skb_shinfo(skb)->frags[0];
+	const skb_frag_t *frag = &skb_shinfo(skb)->frags[0];
 	unsigned int nr_frags = skb_shinfo(skb)->nr_frags;
 	int count = 0, size = skb_headlen(skb);
 
diff --git a/drivers/net/ethernet/intel/iavf/iavf_txrx.c b/drivers/net/ethernet/intel/iavf/iavf_txrx.c
index 0cca1b589b56..fae7cd1c618a 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_txrx.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_txrx.c
@@ -2161,7 +2161,7 @@ static void iavf_create_tx_ctx(struct iavf_ring *tx_ring,
  **/
 bool __iavf_chk_linearize(struct sk_buff *skb)
 {
-	const struct skb_frag_struct *frag, *stale;
+	const skb_frag_t *frag, *stale;
 	int nr_frags, sum;
 
 	/* no need to check if number of frags is less than 7 */
@@ -2269,7 +2269,7 @@ static inline void iavf_tx_map(struct iavf_ring *tx_ring, struct sk_buff *skb,
 {
 	unsigned int data_len = skb->data_len;
 	unsigned int size = skb_headlen(skb);
-	struct skb_frag_struct *frag;
+	skb_frag_t *frag;
 	struct iavf_tx_buffer *tx_bi;
 	struct iavf_tx_desc *tx_desc;
 	u16 i = tx_ring->next_to_use;
diff --git a/drivers/net/ethernet/intel/iavf/iavf_txrx.h b/drivers/net/ethernet/intel/iavf/iavf_txrx.h
index 71e7d090f8db..dd3348f9da9d 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_txrx.h
+++ b/drivers/net/ethernet/intel/iavf/iavf_txrx.h
@@ -462,7 +462,7 @@ bool __iavf_chk_linearize(struct sk_buff *skb);
  **/
 static inline int iavf_xmit_descriptor_count(struct sk_buff *skb)
 {
-	const struct skb_frag_struct *frag = &skb_shinfo(skb)->frags[0];
+	const skb_frag_t *frag = &skb_shinfo(skb)->frags[0];
 	unsigned int nr_frags = skb_shinfo(skb)->nr_frags;
 	int count = 0, size = skb_headlen(skb);
 
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 3c83230434b6..dd7392f293bf 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -1521,7 +1521,7 @@ ice_tx_map(struct ice_ring *tx_ring, struct ice_tx_buf *first,
 {
 	u64 td_offset, td_tag, td_cmd;
 	u16 i = tx_ring->next_to_use;
-	struct skb_frag_struct *frag;
+	skb_frag_t *frag;
 	unsigned int data_len, size;
 	struct ice_tx_desc *tx_desc;
 	struct ice_tx_buf *tx_buf;
@@ -1923,7 +1923,7 @@ static unsigned int ice_txd_use_count(unsigned int size)
  */
 static unsigned int ice_xmit_desc_count(struct sk_buff *skb)
 {
-	const struct skb_frag_struct *frag = &skb_shinfo(skb)->frags[0];
+	const skb_frag_t *frag = &skb_shinfo(skb)->frags[0];
 	unsigned int nr_frags = skb_shinfo(skb)->nr_frags;
 	unsigned int count = 0, size = skb_headlen(skb);
 
@@ -1954,7 +1954,7 @@ static unsigned int ice_xmit_desc_count(struct sk_buff *skb)
  */
 static bool __ice_chk_linearize(struct sk_buff *skb)
 {
-	const struct skb_frag_struct *frag, *stale;
+	const skb_frag_t *frag, *stale;
 	int nr_frags, sum;
 
 	/* no need to check if number of frags is less than 7 */
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index b4df3e319467..749645d7f9b7 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -5918,7 +5918,7 @@ static int igb_tx_map(struct igb_ring *tx_ring,
 	struct sk_buff *skb = first->skb;
 	struct igb_tx_buffer *tx_buffer;
 	union e1000_adv_tx_desc *tx_desc;
-	struct skb_frag_struct *frag;
+	skb_frag_t *frag;
 	dma_addr_t dma;
 	unsigned int data_len, size;
 	u32 tx_flags = first->tx_flags;
@@ -6074,7 +6074,8 @@ netdev_tx_t igb_xmit_frame_ring(struct sk_buff *skb,
 	 * otherwise try next time
 	 */
 	for (f = 0; f < skb_shinfo(skb)->nr_frags; f++)
-		count += TXD_USE_COUNT(skb_shinfo(skb)->frags[f].size);
+		count += TXD_USE_COUNT(skb_frag_size(
+						&skb_shinfo(skb)->frags[f]));
 
 	if (igb_maybe_stop_tx(tx_ring, count + 3)) {
 		/* this is a hard error */
diff --git a/drivers/net/ethernet/intel/igbvf/netdev.c b/drivers/net/ethernet/intel/igbvf/netdev.c
index 34cd30d7162f..0f2b68f4bb0f 100644
--- a/drivers/net/ethernet/intel/igbvf/netdev.c
+++ b/drivers/net/ethernet/intel/igbvf/netdev.c
@@ -2174,7 +2174,7 @@ static inline int igbvf_tx_map_adv(struct igbvf_adapter *adapter,
 		goto dma_error;
 
 	for (f = 0; f < skb_shinfo(skb)->nr_frags; f++) {
-		const struct skb_frag_struct *frag;
+		const skb_frag_t *frag;
 
 		count++;
 		i++;
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 93f3b4e6185b..f0192fcdc635 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -861,7 +861,7 @@ static int igc_tx_map(struct igc_ring *tx_ring,
 	struct igc_tx_buffer *tx_buffer;
 	union igc_adv_tx_desc *tx_desc;
 	u32 tx_flags = first->tx_flags;
-	struct skb_frag_struct *frag;
+	skb_frag_t *frag;
 	u16 i = tx_ring->next_to_use;
 	unsigned int data_len, size;
 	dma_addr_t dma;
@@ -1015,7 +1015,8 @@ static netdev_tx_t igc_xmit_frame_ring(struct sk_buff *skb,
 	 * otherwise try next time
 	 */
 	for (f = 0; f < skb_shinfo(skb)->nr_frags; f++)
-		count += TXD_USE_COUNT(skb_shinfo(skb)->frags[f].size);
+		count += TXD_USE_COUNT(skb_frag_size(
+						&skb_shinfo(skb)->frags[f]));
 
 	if (igc_maybe_stop_tx(tx_ring, count + 3)) {
 		/* this is a hard error */
diff --git a/drivers/net/ethernet/intel/ixgb/ixgb_main.c b/drivers/net/ethernet/intel/ixgb/ixgb_main.c
index e5ac2d3fd816..0940a0da16f2 100644
--- a/drivers/net/ethernet/intel/ixgb/ixgb_main.c
+++ b/drivers/net/ethernet/intel/ixgb/ixgb_main.c
@@ -1331,9 +1331,7 @@ ixgb_tx_map(struct ixgb_adapter *adapter, struct sk_buff *skb,
 	}
 
 	for (f = 0; f < nr_frags; f++) {
-		const struct skb_frag_struct *frag;
-
-		frag = &skb_shinfo(skb)->frags[f];
+		const skb_frag_t *frag = &skb_shinfo(skb)->frags[f];
 		len = skb_frag_size(frag);
 		offset = 0;
 
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index cbaf712d6529..e12d23d1fa64 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -1785,7 +1785,7 @@ static bool ixgbe_is_non_eop(struct ixgbe_ring *rx_ring,
 static void ixgbe_pull_tail(struct ixgbe_ring *rx_ring,
 			    struct sk_buff *skb)
 {
-	struct skb_frag_struct *frag = &skb_shinfo(skb)->frags[0];
+	skb_frag_t *frag = &skb_shinfo(skb)->frags[0];
 	unsigned char *va;
 	unsigned int pull_len;
 
@@ -1840,7 +1840,7 @@ static void ixgbe_dma_sync_frag(struct ixgbe_ring *rx_ring,
 					      skb_headlen(skb),
 					      DMA_FROM_DEVICE);
 	} else {
-		struct skb_frag_struct *frag = &skb_shinfo(skb)->frags[0];
+		skb_frag_t *frag = &skb_shinfo(skb)->frags[0];
 
 		dma_sync_single_range_for_cpu(rx_ring->dev,
 					      IXGBE_CB(skb)->dma,
@@ -8186,7 +8186,7 @@ static int ixgbe_tx_map(struct ixgbe_ring *tx_ring,
 	struct sk_buff *skb = first->skb;
 	struct ixgbe_tx_buffer *tx_buffer;
 	union ixgbe_adv_tx_desc *tx_desc;
-	struct skb_frag_struct *frag;
+	skb_frag_t *frag;
 	dma_addr_t dma;
 	unsigned int data_len, size;
 	u32 tx_flags = first->tx_flags;
@@ -8605,7 +8605,8 @@ netdev_tx_t ixgbe_xmit_frame_ring(struct sk_buff *skb,
 	 * otherwise try next time
 	 */
 	for (f = 0; f < skb_shinfo(skb)->nr_frags; f++)
-		count += TXD_USE_COUNT(skb_shinfo(skb)->frags[f].size);
+		count += TXD_USE_COUNT(skb_frag_size(
+						&skb_shinfo(skb)->frags[f]));
 
 	if (ixgbe_maybe_stop_tx(tx_ring, count + 3)) {
 		tx_ring->tx_stats.tx_busy++;
diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index d2b41f9f87f8..bdfccaf38edd 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -3949,7 +3949,7 @@ static void ixgbevf_tx_map(struct ixgbevf_ring *tx_ring,
 	struct sk_buff *skb = first->skb;
 	struct ixgbevf_tx_buffer *tx_buffer;
 	union ixgbe_adv_tx_desc *tx_desc;
-	struct skb_frag_struct *frag;
+	skb_frag_t *frag;
 	dma_addr_t dma;
 	unsigned int data_len, size;
 	u32 tx_flags = first->tx_flags;
diff --git a/drivers/net/ethernet/jme.c b/drivers/net/ethernet/jme.c
index 76b7b7b85e35..865dc5b92578 100644
--- a/drivers/net/ethernet/jme.c
+++ b/drivers/net/ethernet/jme.c
@@ -2035,12 +2035,12 @@ jme_map_tx_skb(struct jme_adapter *jme, struct sk_buff *skb, int idx)
 	bool hidma = jme->dev->features & NETIF_F_HIGHDMA;
 	int i, nr_frags = skb_shinfo(skb)->nr_frags;
 	int mask = jme->tx_ring_mask;
-	const struct skb_frag_struct *frag;
 	u32 len;
 	int ret = 0;
 
 	for (i = 0 ; i < nr_frags ; ++i) {
-		frag = &skb_shinfo(skb)->frags[i];
+		const skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
+
 		ctxdesc = txdesc + ((idx + i + 2) & (mask));
 		ctxbi = txbi + ((idx + i + 2) & (mask));
 
@@ -2051,7 +2051,6 @@ jme_map_tx_skb(struct jme_adapter *jme, struct sk_buff *skb, int idx)
 			jme_drop_tx_map(jme, idx, i);
 			goto out;
 		}
-
 	}
 
 	len = skb_is_nonlinear(skb) ? skb_headlen(skb) : skb->len;
diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 895bfed26a8a..15cc678f5e5b 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -2350,10 +2350,10 @@ static int mvneta_tx_frag_process(struct mvneta_port *pp, struct sk_buff *skb,
 
 	for (i = 0; i < nr_frags; i++) {
 		skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
-		void *addr = page_address(frag->page.p) + frag->page_offset;
+		void *addr = skb_frag_address(frag);
 
 		tx_desc = mvneta_txq_next_desc_get(txq);
-		tx_desc->data_size = frag->size;
+		tx_desc->data_size = skb_frag_size(frag);
 
 		tx_desc->buf_phys_addr =
 			dma_map_single(pp->dev->dev.parent, addr,
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index c51f1d5b550b..937e4b928b94 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -2911,14 +2911,15 @@ static int mvpp2_tx_frag_process(struct mvpp2_port *port, struct sk_buff *skb,
 
 	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
 		skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
-		void *addr = page_address(frag->page.p) + frag->page_offset;
+		void *addr = skb_frag_address(frag);
 
 		tx_desc = mvpp2_txq_next_desc_get(aggr_txq);
 		mvpp2_txdesc_txq_set(port, tx_desc, txq->id);
-		mvpp2_txdesc_size_set(port, tx_desc, frag->size);
+		mvpp2_txdesc_size_set(port, tx_desc, skb_frag_size(frag));
 
 		buf_dma_addr = dma_map_single(port->dev->dev.parent, addr,
-					      frag->size, DMA_TO_DEVICE);
+					      skb_frag_size(frag),
+					      DMA_TO_DEVICE);
 		if (dma_mapping_error(port->dev->dev.parent, buf_dma_addr)) {
 			mvpp2_txq_desc_put(txq);
 			goto cleanup;
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index b20b3a5a1ebb..c3b3cf6a48ef 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -696,7 +696,7 @@ static int mtk_tx_map(struct sk_buff *skb, struct net_device *dev,
 	txd = itxd;
 	nr_frags = skb_shinfo(skb)->nr_frags;
 	for (i = 0; i < nr_frags; i++) {
-		struct skb_frag_struct *frag = &skb_shinfo(skb)->frags[i];
+		skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 		unsigned int offset = 0;
 		int frag_size = skb_frag_size(frag);
 
@@ -781,7 +781,7 @@ static int mtk_tx_map(struct sk_buff *skb, struct net_device *dev,
 static inline int mtk_cal_txd_req(struct sk_buff *skb)
 {
 	int i, nfrags;
-	struct skb_frag_struct *frag;
+	skb_frag_t *frag;
 
 	nfrags = 1;
 	if (skb_is_gso(skb)) {
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_tx.c b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
index 36a92b19e613..4d5ca302c067 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
@@ -772,9 +772,7 @@ static bool mlx4_en_build_dma_wqe(struct mlx4_en_priv *priv,
 
 	/* Map fragments if any */
 	for (i_frag = shinfo->nr_frags - 1; i_frag >= 0; i_frag--) {
-		const struct skb_frag_struct *frag;
-
-		frag = &shinfo->frags[i_frag];
+		const skb_frag_t *frag = &shinfo->frags[i_frag];
 		byte_count = skb_frag_size(frag);
 		dma = skb_frag_dma_map(ddev, frag,
 				       0, byte_count,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index 600e92cb629a..acf25cc38fa1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -210,7 +210,7 @@ mlx5e_txwqe_build_dsegs(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 	}
 
 	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
-		struct skb_frag_struct *frag = &skb_shinfo(skb)->frags[i];
+		skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 		int fsz = skb_frag_size(frag);
 
 		dma_addr = skb_frag_dma_map(sq->pdev, frag, 0, fsz,
diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index 13e6bf13ac4d..15a8be6bad27 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -1434,7 +1434,7 @@ static void lan743x_tx_frame_add_lso(struct lan743x_tx *tx,
 }
 
 static int lan743x_tx_frame_add_fragment(struct lan743x_tx *tx,
-					 const struct skb_frag_struct *fragment,
+					 const skb_frag_t *fragment,
 					 unsigned int frame_length)
 {
 	/* called only from within lan743x_tx_xmit_frame
@@ -1607,9 +1607,8 @@ static netdev_tx_t lan743x_tx_xmit_frame(struct lan743x_tx *tx,
 		goto finish;
 
 	for (j = 0; j < nr_frags; j++) {
-		const struct skb_frag_struct *frag;
+		const skb_frag_t *frag = &(skb_shinfo(skb)->frags[j]);
 
-		frag = &(skb_shinfo(skb)->frags[j]);
 		if (lan743x_tx_frame_add_fragment(tx, frag, frame_length)) {
 			/* upon error no need to call
 			 *	lan743x_tx_frame_end
diff --git a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
index d8b7fba96d58..9ead6ecb7586 100644
--- a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
+++ b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
@@ -1286,7 +1286,7 @@ myri10ge_vlan_rx(struct net_device *dev, void *addr, struct sk_buff *skb)
 {
 	u8 *va;
 	struct vlan_ethhdr *veh;
-	struct skb_frag_struct *frag;
+	skb_frag_t *frag;
 	__wsum vsum;
 
 	va = addr;
@@ -1318,7 +1318,7 @@ myri10ge_rx_done(struct myri10ge_slice_state *ss, int len, __wsum csum)
 {
 	struct myri10ge_priv *mgp = ss->mgp;
 	struct sk_buff *skb;
-	struct skb_frag_struct *rx_frags;
+	skb_frag_t *rx_frags;
 	struct myri10ge_rx_buf *rx;
 	int i, idx, remainder, bytes;
 	struct pci_dev *pdev = mgp->pdev;
@@ -1351,7 +1351,7 @@ myri10ge_rx_done(struct myri10ge_slice_state *ss, int len, __wsum csum)
 		return 0;
 	}
 	rx_frags = skb_shinfo(skb)->frags;
-	/* Fill skb_frag_struct(s) with data from our receive */
+	/* Fill skb_frag_t(s) with data from our receive */
 	for (i = 0, remainder = len; remainder > 0; i++) {
 		myri10ge_unmap_rx_page(pdev, &rx->info[idx], bytes);
 		skb_fill_page_desc(skb, i, rx->info[idx].page,
@@ -1365,7 +1365,7 @@ myri10ge_rx_done(struct myri10ge_slice_state *ss, int len, __wsum csum)
 
 	/* remove padding */
 	rx_frags[0].page_offset += MXGEFW_PAD;
-	rx_frags[0].size -= MXGEFW_PAD;
+	skb_frag_size_sub(&rx_frags[0], MXGEFW_PAD);
 	len -= MXGEFW_PAD;
 
 	skb->len = len;
@@ -2628,7 +2628,7 @@ static netdev_tx_t myri10ge_xmit(struct sk_buff *skb,
 	struct myri10ge_slice_state *ss;
 	struct mcp_kreq_ether_send *req;
 	struct myri10ge_tx_buf *tx;
-	struct skb_frag_struct *frag;
+	skb_frag_t *frag;
 	struct netdev_queue *netdev_queue;
 	dma_addr_t bus;
 	u32 low;
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 9903805717da..6f97b554f7da 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -975,7 +975,7 @@ static int nfp_net_prep_tx_meta(struct sk_buff *skb, u64 tls_handle)
 static int nfp_net_tx(struct sk_buff *skb, struct net_device *netdev)
 {
 	struct nfp_net *nn = netdev_priv(netdev);
-	const struct skb_frag_struct *frag;
+	const skb_frag_t *frag;
 	int f, nr_frags, wr_idx, md_bytes;
 	struct nfp_net_tx_ring *tx_ring;
 	struct nfp_net_r_vector *r_vec;
@@ -1155,7 +1155,7 @@ static void nfp_net_tx_complete(struct nfp_net_tx_ring *tx_ring, int budget)
 	todo = D_IDX(tx_ring, qcp_rd_p - tx_ring->qcp_rd_p);
 
 	while (todo--) {
-		const struct skb_frag_struct *frag;
+		const skb_frag_t *frag;
 		struct nfp_net_tx_buf *tx_buf;
 		struct sk_buff *skb;
 		int fidx, nr_frags;
@@ -1270,7 +1270,7 @@ static bool nfp_net_xdp_complete(struct nfp_net_tx_ring *tx_ring)
 static void
 nfp_net_tx_ring_reset(struct nfp_net_dp *dp, struct nfp_net_tx_ring *tx_ring)
 {
-	const struct skb_frag_struct *frag;
+	const skb_frag_t *frag;
 	struct netdev_queue *nd_q;
 
 	while (!tx_ring->is_xdp && tx_ring->rd_p != tx_ring->wr_p) {
diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
index 58e2eaf77014..c692a41e4548 100644
--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
@@ -1980,7 +1980,7 @@ netxen_map_tx_skb(struct pci_dev *pdev,
 		struct sk_buff *skb, struct netxen_cmd_buffer *pbuf)
 {
 	struct netxen_skb_frag *nf;
-	struct skb_frag_struct *frag;
+	skb_frag_t *frag;
 	int i, nr_frags;
 	dma_addr_t map;
 
@@ -2043,7 +2043,7 @@ netxen_nic_xmit_frame(struct sk_buff *skb, struct net_device *netdev)
 	struct pci_dev *pdev;
 	int i, k;
 	int delta = 0;
-	struct skb_frag_struct *frag;
+	skb_frag_t *frag;
 
 	u32 producer;
 	int frag_count;
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
index 14f26bf3b388..ac61f614de37 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
@@ -581,7 +581,7 @@ static int qlcnic_map_tx_skb(struct pci_dev *pdev, struct sk_buff *skb,
 			     struct qlcnic_cmd_buffer *pbuf)
 {
 	struct qlcnic_skb_frag *nf;
-	struct skb_frag_struct *frag;
+	skb_frag_t *frag;
 	int i, nr_frags;
 	dma_addr_t map;
 
diff --git a/drivers/net/ethernet/qualcomm/emac/emac-mac.c b/drivers/net/ethernet/qualcomm/emac/emac-mac.c
index 707665b62eb7..bebe38d74d66 100644
--- a/drivers/net/ethernet/qualcomm/emac/emac-mac.c
+++ b/drivers/net/ethernet/qualcomm/emac/emac-mac.c
@@ -1385,15 +1385,13 @@ static void emac_tx_fill_tpd(struct emac_adapter *adpt,
 	}
 
 	for (i = 0; i < nr_frags; i++) {
-		struct skb_frag_struct *frag;
-
-		frag = &skb_shinfo(skb)->frags[i];
+		skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 
 		tpbuf = GET_TPD_BUFFER(tx_q, tx_q->tpd.produce_idx);
-		tpbuf->length = frag->size;
-		tpbuf->dma_addr = dma_map_page(adpt->netdev->dev.parent,
-					       frag->page.p, frag->page_offset,
-					       tpbuf->length, DMA_TO_DEVICE);
+		tpbuf->length = skb_frag_size(frag);
+		tpbuf->dma_addr = skb_frag_dma_map(adpt->netdev->dev.parent,
+						   frag, 0, tpbuf->length,
+						   DMA_TO_DEVICE);
 		ret = dma_mapping_error(adpt->netdev->dev.parent,
 					tpbuf->dma_addr);
 		if (ret)
diff --git a/drivers/net/ethernet/synopsys/dwc-xlgmac-desc.c b/drivers/net/ethernet/synopsys/dwc-xlgmac-desc.c
index 031cf9c3435a..8c4195a9a2cc 100644
--- a/drivers/net/ethernet/synopsys/dwc-xlgmac-desc.c
+++ b/drivers/net/ethernet/synopsys/dwc-xlgmac-desc.c
@@ -503,7 +503,7 @@ static int xlgmac_map_tx_skb(struct xlgmac_channel *channel,
 	struct xlgmac_desc_data *desc_data;
 	unsigned int offset, datalen, len;
 	struct xlgmac_pkt_info *pkt_info;
-	struct skb_frag_struct *frag;
+	skb_frag_t *frag;
 	unsigned int tso, vlan;
 	dma_addr_t skb_dma;
 	unsigned int i;
diff --git a/drivers/net/ethernet/synopsys/dwc-xlgmac-net.c b/drivers/net/ethernet/synopsys/dwc-xlgmac-net.c
index 1f8e9601592a..a1f5a1e61040 100644
--- a/drivers/net/ethernet/synopsys/dwc-xlgmac-net.c
+++ b/drivers/net/ethernet/synopsys/dwc-xlgmac-net.c
@@ -116,7 +116,7 @@ static void xlgmac_prep_tx_pkt(struct xlgmac_pdata *pdata,
 			       struct sk_buff *skb,
 			       struct xlgmac_pkt_info *pkt_info)
 {
-	struct skb_frag_struct *frag;
+	skb_frag_t *frag;
 	unsigned int context_desc;
 	unsigned int len;
 	unsigned int i;
diff --git a/drivers/net/ethernet/tehuti/tehuti.c b/drivers/net/ethernet/tehuti/tehuti.c
index 5d6960fe3309..0f8a924fc60c 100644
--- a/drivers/net/ethernet/tehuti/tehuti.c
+++ b/drivers/net/ethernet/tehuti/tehuti.c
@@ -1501,7 +1501,7 @@ bdx_tx_map_skb(struct bdx_priv *priv, struct sk_buff *skb,
 	bdx_tx_db_inc_wptr(db);
 
 	for (i = 0; i < nr_frags; i++) {
-		const struct skb_frag_struct *frag;
+		const skb_frag_t *frag;
 
 		frag = &skb_shinfo(skb)->frags[i];
 		db->wptr->len = skb_frag_size(frag);
diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index 72514c46b478..ace7ffaf3913 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -1324,10 +1324,10 @@ static int build_dma_sg(const struct sk_buff *skb, struct urb *urb)
 	total_len += skb_headlen(skb);
 
 	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
-		struct skb_frag_struct *f = &skb_shinfo(skb)->frags[i];
+		skb_frag_t *f = &skb_shinfo(skb)->frags[i];
 
 		total_len += skb_frag_size(f);
-		sg_set_page(&urb->sg[i + s], f->page.p, f->size,
+		sg_set_page(&urb->sg[i + s], skb_frag_page(f), skb_frag_size(f),
 				f->page_offset);
 	}
 	urb->transfer_buffer_length = total_len;
diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index 3f48f05dd2a6..7072d5968142 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -657,8 +657,7 @@ static void
 vmxnet3_append_frag(struct sk_buff *skb, struct Vmxnet3_RxCompDesc *rcd,
 		    struct vmxnet3_rx_buf_info *rbi)
 {
-	struct skb_frag_struct *frag = skb_shinfo(skb)->frags +
-		skb_shinfo(skb)->nr_frags;
+	skb_frag_t *frag = skb_shinfo(skb)->frags + skb_shinfo(skb)->nr_frags;
 
 	BUG_ON(skb_shinfo(skb)->nr_frags >= MAX_SKB_FRAGS);
 
@@ -755,7 +754,7 @@ vmxnet3_map_pkt(struct sk_buff *skb, struct vmxnet3_tx_ctx *ctx,
 	}
 
 	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
-		const struct skb_frag_struct *frag = &skb_shinfo(skb)->frags[i];
+		const skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 		u32 buf_size;
 
 		buf_offset = 0;
@@ -956,7 +955,7 @@ static int txd_estimate(const struct sk_buff *skb)
 	int i;
 
 	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
-		const struct skb_frag_struct *frag = &skb_shinfo(skb)->frags[i];
+		const skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 
 		count += VMXNET3_TXD_NEEDED(skb_frag_size(frag));
 	}
diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 74834131cf7c..fd3b2b3d1b5c 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -1052,8 +1052,7 @@ static void wil_seq_print_skb(struct seq_file *s, struct sk_buff *skb)
 	if (nr_frags) {
 		seq_printf(s, "    nr_frags = %d\n", nr_frags);
 		for (i = 0; i < nr_frags; i++) {
-			const struct skb_frag_struct *frag =
-					&skb_shinfo(skb)->frags[i];
+			const skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 
 			len = skb_frag_size(frag);
 			p = skb_frag_address_safe(frag);
diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index eae00aafaa88..8b01ef8269da 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -1657,7 +1657,7 @@ static int __wil_tx_vring_tso(struct wil6210_priv *wil, struct wil6210_vif *vif,
 				     len);
 		} else {
 			frag = &skb_shinfo(skb)->frags[f];
-			len = frag->size;
+			len = skb_frag_size(frag);
 			wil_dbg_txrx(wil, "TSO: frag[%d]: len %u\n", f, len);
 		}
 
@@ -1678,8 +1678,8 @@ static int __wil_tx_vring_tso(struct wil6210_priv *wil, struct wil6210_vif *vif,
 
 			if (!headlen) {
 				pa = skb_frag_dma_map(dev, frag,
-						      frag->size - len, lenmss,
-						      DMA_TO_DEVICE);
+						      skb_frag_size(frag) - len,
+						      lenmss, DMA_TO_DEVICE);
 				vring->ctx[i].mapped_as = wil_mapped_as_page;
 			} else {
 				pa = dma_map_single(dev,
@@ -1900,8 +1900,7 @@ static int __wil_tx_ring(struct wil6210_priv *wil, struct wil6210_vif *vif,
 
 	/* middle segments */
 	for (; f < nr_frags; f++) {
-		const struct skb_frag_struct *frag =
-				&skb_shinfo(skb)->frags[f];
+		const skb_frag_t *frag = &skb_shinfo(skb)->frags[f];
 		int len = skb_frag_size(frag);
 
 		*_d = *d;
diff --git a/drivers/net/wireless/ath/wil6210/txrx_edma.c b/drivers/net/wireless/ath/wil6210/txrx_edma.c
index dc040cd4ab06..71b7ad4b6454 100644
--- a/drivers/net/wireless/ath/wil6210/txrx_edma.c
+++ b/drivers/net/wireless/ath/wil6210/txrx_edma.c
@@ -1471,7 +1471,7 @@ static int __wil_tx_ring_tso_edma(struct wil6210_priv *wil,
 	/* Rest of the descriptors are from the SKB fragments */
 	for (f = 0; f < nr_frags; f++) {
 		skb_frag_t *frag = &skb_shinfo(skb)->frags[f];
-		int len = frag->size;
+		int len = skb_frag_size(frag);
 
 		wil_dbg_txrx(wil, "TSO: frag[%d]: len %u, descs_used %d\n", f,
 			     len, descs_used);
diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index 1d9940d4e8c7..a96c5c2a2c5a 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -1055,7 +1055,7 @@ static int xenvif_handle_frag_list(struct xenvif_queue *queue, struct sk_buff *s
 			int j;
 			skb->truesize += skb->data_len;
 			for (j = 0; j < i; j++)
-				put_page(frags[j].page.p);
+				put_page(skb_frag_page(&frags[j]));
 			return -ENOMEM;
 		}
 
@@ -1067,7 +1067,7 @@ static int xenvif_handle_frag_list(struct xenvif_queue *queue, struct sk_buff *s
 			BUG();
 
 		offset += len;
-		frags[i].page.p = page;
+		__skb_frag_set_page(&frags[i], page);
 		frags[i].page_offset = 0;
 		skb_frag_size_set(&frags[i], len);
 	}
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 4d0caeebc802..5aa0f1268bca 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -3515,7 +3515,7 @@ static int qeth_get_elements_for_frags(struct sk_buff *skb)
 	int cnt, elements = 0;
 
 	for (cnt = 0; cnt < skb_shinfo(skb)->nr_frags; cnt++) {
-		struct skb_frag_struct *frag = &skb_shinfo(skb)->frags[cnt];
+		skb_frag_t *frag = &skb_shinfo(skb)->frags[cnt];
 
 		elements += qeth_get_elements_for_range(
 			(addr_t)skb_frag_address(frag),
diff --git a/drivers/scsi/fcoe/fcoe_transport.c b/drivers/scsi/fcoe/fcoe_transport.c
index ba4603d76284..d0550384cc38 100644
--- a/drivers/scsi/fcoe/fcoe_transport.c
+++ b/drivers/scsi/fcoe/fcoe_transport.c
@@ -308,7 +308,7 @@ EXPORT_SYMBOL_GPL(fcoe_get_wwn);
 u32 fcoe_fc_crc(struct fc_frame *fp)
 {
 	struct sk_buff *skb = fp_skb(fp);
-	struct skb_frag_struct *frag;
+	skb_frag_t *frag;
 	unsigned char *data;
 	unsigned long off, len, clen;
 	u32 crc;
diff --git a/drivers/staging/octeon/ethernet-tx.c b/drivers/staging/octeon/ethernet-tx.c
index 20f513fbaa85..cc12c78f73f1 100644
--- a/drivers/staging/octeon/ethernet-tx.c
+++ b/drivers/staging/octeon/ethernet-tx.c
@@ -280,11 +280,10 @@ int cvm_oct_xmit(struct sk_buff *skb, struct net_device *dev)
 		hw_buffer.s.size = skb_headlen(skb);
 		CVM_OCT_SKB_CB(skb)[0] = hw_buffer.u64;
 		for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
-			struct skb_frag_struct *fs = skb_shinfo(skb)->frags + i;
+			skb_frag_t *fs = skb_shinfo(skb)->frags + i;
 
 			hw_buffer.s.addr =
-				XKPHYS_TO_PHYS((u64)(page_address(fs->page.p) +
-					       fs->page_offset));
+				XKPHYS_TO_PHYS((u64)skb_frag_address(fs));
 			hw_buffer.s.size = fs->size;
 			CVM_OCT_SKB_CB(skb)[i + 1] = hw_buffer.u64;
 		}
diff --git a/drivers/staging/unisys/visornic/visornic_main.c b/drivers/staging/unisys/visornic/visornic_main.c
index 9d4f1dab0968..b889b04a6e25 100644
--- a/drivers/staging/unisys/visornic/visornic_main.c
+++ b/drivers/staging/unisys/visornic/visornic_main.c
@@ -285,8 +285,8 @@ static int visor_copy_fragsinfo_from_skb(struct sk_buff *skb,
 			count = add_physinfo_entries(page_to_pfn(
 				  skb_frag_page(&skb_shinfo(skb)->frags[frag])),
 				  skb_shinfo(skb)->frags[frag].page_offset,
-				  skb_shinfo(skb)->frags[frag].size, count,
-				  frags_max, frags);
+				  skb_frag_size(&skb_shinfo(skb)->frags[frag]),
+				  count, frags_max, frags);
 			/* add_physinfo_entries only returns
 			 * zero if the frags array is out of room
 			 * That should never happen because we
diff --git a/drivers/target/iscsi/cxgbit/cxgbit_target.c b/drivers/target/iscsi/cxgbit/cxgbit_target.c
index 24309d937d8c..93212b9fd310 100644
--- a/drivers/target/iscsi/cxgbit/cxgbit_target.c
+++ b/drivers/target/iscsi/cxgbit/cxgbit_target.c
@@ -899,9 +899,9 @@ cxgbit_handle_immediate_data(struct iscsi_cmd *cmd, struct iscsi_scsi_req *hdr,
 		skb_frag_t *dfrag = &ssi->frags[pdu_cb->dfrag_idx];
 
 		sg_init_table(&ccmd->sg, 1);
-		sg_set_page(&ccmd->sg, dfrag->page.p, skb_frag_size(dfrag),
-			    dfrag->page_offset);
-		get_page(dfrag->page.p);
+		sg_set_page(&ccmd->sg, skb_frag_page(dfrag),
+				skb_frag_size(dfrag), dfrag->page_offset);
+		get_page(skb_frag_page(dfrag));
 
 		cmd->se_cmd.t_data_sg = &ccmd->sg;
 		cmd->se_cmd.t_data_nents = 1;
@@ -1403,7 +1403,8 @@ static void cxgbit_lro_skb_dump(struct sk_buff *skb)
 			pdu_cb->ddigest, pdu_cb->frags);
 	for (i = 0; i < ssi->nr_frags; i++)
 		pr_info("skb 0x%p, frag %d, off %u, sz %u.\n",
-			skb, i, ssi->frags[i].page_offset, ssi->frags[i].size);
+			skb, i, ssi->frags[i].page_offset,
+			skb_frag_size(&ssi->frags[i]));
 }
 
 static void cxgbit_lro_hskb_reset(struct cxgbit_sock *csk)
@@ -1447,7 +1448,7 @@ cxgbit_lro_skb_merge(struct cxgbit_sock *csk, struct sk_buff *skb, u8 pdu_idx)
 		hpdu_cb->frags++;
 		hpdu_cb->hfrag_idx = hfrag_idx;
 
-		len = hssi->frags[hfrag_idx].size;
+		len = skb_frag_size(&hssi->frags[hfrag_idx]);;
 		hskb->len += len;
 		hskb->data_len += len;
 		hskb->truesize += len;
@@ -1467,7 +1468,7 @@ cxgbit_lro_skb_merge(struct cxgbit_sock *csk, struct sk_buff *skb, u8 pdu_idx)
 
 			get_page(skb_frag_page(&hssi->frags[dfrag_idx]));
 
-			len += hssi->frags[dfrag_idx].size;
+			len += skb_frag_size(&hssi->frags[dfrag_idx]);
 
 			hssi->nr_frags++;
 			hpdu_cb->frags++;
-- 
2.20.1

