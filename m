Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9E931193B
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 04:00:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231666AbhBFC7f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 21:59:35 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:34500 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231934AbhBFCt2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 21:49:28 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 115MffLs030875;
        Fri, 5 Feb 2021 14:52:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=tv7ugfv5+BHZHw4envOXaRJZpH0qW/nPIiCUpOqdKo0=;
 b=UymPt9+EUXQB7SgAXGK9KaL/0/HT0VZUhZMfmdQuB2SclSfKXHJ08rWXz45Azl97uOxn
 kUOLQFNJ24S1LII7VYTY/MopGMksUytidLm18z84hSZseSgrdNRzH9hLX3GRMm8z4cf4
 ljP+vNsBLJU/wyTgk5A8JGuszTn8Nsydtg88UktyrjW3c24g5c1KurLSjEeZyWj3iMR9
 07XsNA6kGfe3LGWeAZlTawyj9qKBZdjvV4tizlYpoZpylNWDUJCnLNR4MiRxhqa8Qe6c
 HBu7f1khVTkk7W0v82CRDTU/vIb7UUXqtUcLfUpzBSusfrc8/9prc8u+GmCy4nTH4fPj uQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 36fnr6ag2y-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 05 Feb 2021 14:52:04 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 5 Feb
 2021 14:52:02 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 5 Feb
 2021 14:52:02 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 5 Feb 2021 14:52:02 -0800
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 508C03F703F;
        Fri,  5 Feb 2021 14:51:58 -0800 (PST)
From:   Geetha sowjanya <gakula@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>, <jerinj@marvell.com>,
        <lcherian@marvell.com>, <bbrezillon@kernel.org>,
        <arno@natisbad.org>, <schalla@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>
Subject: [net-next v4 11/14] octeontx2-pf: cn10k: Get max mtu supported from admin function
Date:   Sat, 6 Feb 2021 04:20:10 +0530
Message-ID: <20210205225013.15961-12-gakula@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210205225013.15961-1-gakula@marvell.com>
References: <20210205225013.15961-1-gakula@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-05_13:2021-02-05,2021-02-05 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hariprasad Kelam <hkelam@marvell.com>

CN10K supports max MTU of 16K on LMAC links and 64k on LBK
links and Octeontx2 silicon supports 9K mtu on both links.
Get the same from nix_get_hw_info mbox message in netdev probe.

This patch also calculates receive buffer size required based
on the MTU set.

Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c |  2 +-
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   | 43 +++++++++++++++++++++-
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |  2 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   | 35 ++++++++++++++++--
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c | 27 ++++++++++----
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.h |  1 -
 .../net/ethernet/marvell/octeontx2/nic/otx2_vf.c   |  2 +-
 7 files changed, 95 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c
index 70548d1..da82f9f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c
@@ -108,7 +108,7 @@ int cn10k_sq_aq_init(void *dev, u16 qidx, u16 sqb_aura)
 	/* Only one SMQ is allocated, map all SQ's to that SMQ  */
 	aq->sq.smq = pfvf->hw.txschq_list[NIX_TXSCH_LVL_SMQ][0];
 	/* FIXME: set based on NIX_AF_DWRR_RPM_MTU*/
-	aq->sq.smq_rr_weight = OTX2_MAX_MTU;
+	aq->sq.smq_rr_weight = pfvf->netdev->mtu;
 	aq->sq.default_chan = pfvf->hw.tx_chan_base;
 	aq->sq.sqe_stype = NIX_STYPE_STF; /* Cache SQB */
 	aq->sq.sqb_aura = sqb_aura;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index fe62bfd..c496629 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -217,7 +217,6 @@ int otx2_hw_set_mtu(struct otx2_nic *pfvf, int mtu)
 		return -ENOMEM;
 	}
 
-	pfvf->max_frs = mtu +  OTX2_ETH_HLEN;
 	req->maxlen = pfvf->max_frs;
 
 	err = otx2_sync_mbox_msg(&pfvf->mbox);
@@ -592,7 +591,7 @@ int otx2_txschq_config(struct otx2_nic *pfvf, int lvl)
 	/* Set topology e.t.c configuration */
 	if (lvl == NIX_TXSCH_LVL_SMQ) {
 		req->reg[0] = NIX_AF_SMQX_CFG(schq);
-		req->regval[0] = ((OTX2_MAX_MTU + OTX2_ETH_HLEN) << 8) |
+		req->regval[0] = ((pfvf->netdev->max_mtu + OTX2_ETH_HLEN) << 8) |
 				   OTX2_MIN_MTU;
 
 		req->regval[0] |= (0x20ULL << 51) | (0x80ULL << 39) |
@@ -1619,6 +1618,46 @@ void otx2_set_cints_affinity(struct otx2_nic *pfvf)
 	}
 }
 
+u16 otx2_get_max_mtu(struct otx2_nic *pfvf)
+{
+	struct nix_hw_info *rsp;
+	struct msg_req *req;
+	u16 max_mtu;
+	int rc;
+
+	mutex_lock(&pfvf->mbox.lock);
+
+	req = otx2_mbox_alloc_msg_nix_get_hw_info(&pfvf->mbox);
+	if (!req) {
+		rc =  -ENOMEM;
+		goto out;
+	}
+
+	rc = otx2_sync_mbox_msg(&pfvf->mbox);
+	if (!rc) {
+		rsp = (struct nix_hw_info *)
+		       otx2_mbox_get_rsp(&pfvf->mbox.mbox, 0, &req->hdr);
+
+		/* HW counts VLAN insertion bytes (8 for double tag)
+		 * irrespective of whether SQE is requesting to insert VLAN
+		 * in the packet or not. Hence these 8 bytes have to be
+		 * discounted from max packet size otherwise HW will throw
+		 * SMQ errors
+		 */
+		max_mtu = rsp->max_mtu - 8 - OTX2_ETH_HLEN;
+	}
+
+out:
+	mutex_unlock(&pfvf->mbox.lock);
+	if (rc) {
+		dev_warn(pfvf->dev,
+			 "Failed to get MTU from hardware setting default value(1500)\n");
+		max_mtu = 1500;
+	}
+	return max_mtu;
+}
+EXPORT_SYMBOL(otx2_get_max_mtu);
+
 #define M(_name, _id, _fn_name, _req_type, _rsp_type)			\
 int __weak								\
 otx2_mbox_up_handler_ ## _fn_name(struct otx2_nic *pfvf,		\
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 52205cb..23e1c24 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -790,5 +790,5 @@ int otx2_del_macfilter(struct net_device *netdev, const u8 *mac);
 int otx2_add_macfilter(struct net_device *netdev, const u8 *mac);
 int otx2_enable_rxvlan(struct otx2_nic *pf, bool enable);
 int otx2_install_rxvlan_offload_flow(struct otx2_nic *pfvf);
-
+u16 otx2_get_max_mtu(struct otx2_nic *pfvf);
 #endif /* OTX2_COMMON_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 8b6a012..01458fe 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1285,6 +1285,33 @@ static void otx2_free_sq_res(struct otx2_nic *pf)
 	}
 }
 
+static int otx2_get_rbuf_size(struct otx2_nic *pf, int mtu)
+{
+	int frame_size;
+	int total_size;
+	int rbuf_size;
+
+	/* The data transferred by NIX to memory consists of actual packet
+	 * plus additional data which has timestamp and/or EDSA/HIGIG2
+	 * headers if interface is configured in corresponding modes.
+	 * NIX transfers entire data using 6 segments/buffers and writes
+	 * a CQE_RX descriptor with those segment addresses. First segment
+	 * has additional data prepended to packet. Also software omits a
+	 * headroom of 128 bytes and sizeof(struct skb_shared_info) in
+	 * each segment. Hence the total size of memory needed
+	 * to receive a packet with 'mtu' is:
+	 * frame size =  mtu + additional data;
+	 * memory = frame_size + (headroom + struct skb_shared_info size) * 6;
+	 * each receive buffer size = memory / 6;
+	 */
+	frame_size = mtu + OTX2_ETH_HLEN + OTX2_HW_TIMESTAMP_LEN;
+	total_size = frame_size + (OTX2_HEAD_ROOM +
+		     OTX2_DATA_ALIGN(sizeof(struct skb_shared_info))) * 6;
+	rbuf_size = total_size / 6;
+
+	return ALIGN(rbuf_size, 2048);
+}
+
 static int otx2_init_hw_resources(struct otx2_nic *pf)
 {
 	struct nix_lf_free_req *free_req;
@@ -1301,9 +1328,9 @@ static int otx2_init_hw_resources(struct otx2_nic *pf)
 	hw->sqpool_cnt = hw->tx_queues;
 	hw->pool_cnt = hw->rqpool_cnt + hw->sqpool_cnt;
 
-	/* Get the size of receive buffers to allocate */
-	pf->rbsize = RCV_FRAG_LEN(OTX2_HW_TIMESTAMP_LEN + pf->netdev->mtu +
-				  OTX2_ETH_HLEN);
+	pf->max_frs = pf->netdev->mtu + OTX2_ETH_HLEN + OTX2_HW_TIMESTAMP_LEN;
+
+	pf->rbsize = otx2_get_rbuf_size(pf, pf->netdev->mtu);
 
 	mutex_lock(&mbox->lock);
 	/* NPA init */
@@ -2426,7 +2453,7 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	/* MTU range: 64 - 9190 */
 	netdev->min_mtu = OTX2_MIN_MTU;
-	netdev->max_mtu = OTX2_MAX_MTU;
+	netdev->max_mtu = otx2_get_max_mtu(pf);
 
 	err = register_netdev(netdev);
 	if (err) {
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
index cdae83c..00e9e65 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
@@ -256,12 +256,11 @@ static bool otx2_check_rcv_errors(struct otx2_nic *pfvf,
 		/* For now ignore all the NPC parser errors and
 		 * pass the packets to stack.
 		 */
-		if (cqe->sg.segs == 1)
-			return false;
+		return false;
 	}
 
 	/* If RXALL is enabled pass on packets to stack. */
-	if (cqe->sg.segs == 1 && (pfvf->netdev->features & NETIF_F_RXALL))
+	if (pfvf->netdev->features & NETIF_F_RXALL)
 		return false;
 
 	/* Free buffer back to pool */
@@ -276,9 +275,14 @@ static void otx2_rcv_pkt_handler(struct otx2_nic *pfvf,
 				 struct nix_cqe_rx_s *cqe)
 {
 	struct nix_rx_parse_s *parse = &cqe->parse;
+	struct nix_rx_sg_s *sg = &cqe->sg;
 	struct sk_buff *skb = NULL;
+	void *end, *start;
+	u64 *seg_addr;
+	u16 *seg_size;
+	int seg;
 
-	if (unlikely(parse->errlev || parse->errcode || cqe->sg.segs > 1)) {
+	if (unlikely(parse->errlev || parse->errcode)) {
 		if (otx2_check_rcv_errors(pfvf, cqe, cq->cq_idx))
 			return;
 	}
@@ -287,9 +291,18 @@ static void otx2_rcv_pkt_handler(struct otx2_nic *pfvf,
 	if (unlikely(!skb))
 		return;
 
-	otx2_skb_add_frag(pfvf, skb, cqe->sg.seg_addr, cqe->sg.seg_size, parse);
-	cq->pool_ptrs++;
-
+	start = (void *)sg;
+	end = start + ((cqe->parse.desc_sizem1 + 1) * 16);
+	while (start < end) {
+		sg = (struct nix_rx_sg_s *)start;
+		seg_addr = &sg->seg_addr;
+		seg_size = (void *)sg;
+		for (seg = 0; seg < sg->segs; seg++, seg_addr++) {
+			otx2_skb_add_frag(pfvf, skb, *seg_addr, seg_size[seg], parse);
+			cq->pool_ptrs++;
+		}
+		start += sizeof(*sg);
+	}
 	otx2_set_rxhash(pfvf, cqe, skb);
 
 	skb_record_rx_queue(skb, cq->cq_idx);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
index d2b26b3..52486c1 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
@@ -24,7 +24,6 @@
 
 #define	OTX2_ETH_HLEN		(VLAN_ETH_HLEN + VLAN_HLEN)
 #define	OTX2_MIN_MTU		64
-#define	OTX2_MAX_MTU		(9212 - OTX2_ETH_HLEN)
 
 #define OTX2_MAX_GSO_SEGS	255
 #define OTX2_MAX_FRAGS_IN_SQE	9
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
index 31e0325..085be90 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -586,7 +586,7 @@ static int otx2vf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	/* MTU range: 68 - 9190 */
 	netdev->min_mtu = OTX2_MIN_MTU;
-	netdev->max_mtu = OTX2_MAX_MTU;
+	netdev->max_mtu = otx2_get_max_mtu(vf);
 
 	INIT_WORK(&vf->reset_task, otx2vf_reset_task);
 
-- 
2.7.4

