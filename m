Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA017AB36
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 16:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731503AbfG3Okp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 10:40:45 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:22452 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731479AbfG3Okl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 10:40:41 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x6UEdXmR005635
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 07:40:37 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 2u2p4b0dpf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 07:40:36 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 30 Jul 2019 07:40:35 -0700
Received: by devvm34215.prn1.facebook.com (Postfix, from userid 172786)
        id 92BF72576FD11; Tue, 30 Jul 2019 07:40:34 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm34215.prn1.facebook.com
To:     <willy@infradead.org>, <davem@davemloft.net>,
        <jakub.kicinski@netronome.com>
CC:     <kernel-team@fb.com>, <netdev@vger.kernel.org>
Smtp-Origin-Cluster: prn1c35
Subject: [PATCH v2 2/3 net-next] net: Use skb_frag_off accessors
Date:   Tue, 30 Jul 2019 07:40:33 -0700
Message-ID: <20190730144034.444022-3-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190730144034.444022-1-jonathan.lemon@gmail.com>
References: <20190730144034.444022-1-jonathan.lemon@gmail.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-30_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1034 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907300152
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use accessor functions for skb fragment's page_offset instead
of direct references, in preparation for bvec conversion.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/atm/eni.c                             |  2 +-
 drivers/hsi/clients/ssi_protocol.c            |  2 +-
 drivers/infiniband/hw/hfi1/vnic_sdma.c        |  2 +-
 drivers/infiniband/ulp/ipoib/ipoib_ib.c       |  3 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  2 +-
 .../ethernet/cavium/thunder/nicvf_queues.c    |  2 +-
 drivers/net/ethernet/chelsio/cxgb3/sge.c      |  2 +-
 drivers/net/ethernet/emulex/benet/be_main.c   | 12 ++---
 .../ethernet/freescale/fs_enet/fs_enet-main.c |  2 +-
 drivers/net/ethernet/ibm/ibmvnic.c            |  2 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c   |  2 +-
 drivers/net/ethernet/intel/iavf/iavf_txrx.c   |  2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |  4 +-
 drivers/net/ethernet/jme.c                    |  4 +-
 drivers/net/ethernet/marvell/mv643xx_eth.c    |  2 +-
 .../net/ethernet/myricom/myri10ge/myri10ge.c  |  6 +--
 drivers/net/ethernet/sfc/tx.c                 |  2 +-
 drivers/net/ethernet/sun/cassini.c            |  8 +--
 drivers/net/ethernet/sun/niu.c                |  2 +-
 drivers/net/ethernet/sun/sunvnet_common.c     |  4 +-
 drivers/net/ethernet/ti/netcp_core.c          |  2 +-
 drivers/net/hyperv/netvsc_drv.c               |  4 +-
 drivers/net/thunderbolt.c                     |  2 +-
 drivers/net/usb/usbnet.c                      |  2 +-
 drivers/net/vmxnet3/vmxnet3_drv.c             |  2 +-
 drivers/net/xen-netback/netback.c             |  6 +--
 drivers/net/xen-netfront.c                    |  8 +--
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c             |  2 +-
 drivers/scsi/fcoe/fcoe.c                      |  3 +-
 drivers/scsi/fcoe/fcoe_transport.c            |  2 +-
 drivers/scsi/qedf/qedf_main.c                 |  2 +-
 .../staging/unisys/visornic/visornic_main.c   |  2 +-
 drivers/target/iscsi/cxgbit/cxgbit_target.c   |  4 +-
 net/appletalk/ddp.c                           |  4 +-
 net/core/datagram.c                           |  6 +--
 net/core/dev.c                                |  2 +-
 net/core/pktgen.c                             |  2 +-
 net/core/skbuff.c                             | 54 ++++++++++---------
 net/ipv4/tcp.c                                |  6 +--
 net/ipv4/tcp_output.c                         |  2 +-
 net/kcm/kcmsock.c                             |  2 +-
 net/tls/tls_device.c                          |  8 +--
 net/tls/tls_device_fallback.c                 |  2 +-
 net/xfrm/xfrm_ipcomp.c                        |  2 +-
 44 files changed, 100 insertions(+), 98 deletions(-)

diff --git a/drivers/atm/eni.c b/drivers/atm/eni.c
index 79b718430cd1..b23d1e4bad33 100644
--- a/drivers/atm/eni.c
+++ b/drivers/atm/eni.c
@@ -1136,7 +1136,7 @@ DPRINTK("doing direct send\n"); /* @@@ well, this doesn't work anyway */
 			else
 				put_dma(tx->index,eni_dev->dma,&j,(unsigned long)
 				    skb_frag_page(&skb_shinfo(skb)->frags[i]) +
-					skb_shinfo(skb)->frags[i].page_offset,
+					skb_frag_off(&skb_shinfo(skb)->frags[i]),
 				    skb_frag_size(&skb_shinfo(skb)->frags[i]));
 	}
 	if (skb->len & 3) {
diff --git a/drivers/hsi/clients/ssi_protocol.c b/drivers/hsi/clients/ssi_protocol.c
index c9e3f928b93d..0253e76f1df2 100644
--- a/drivers/hsi/clients/ssi_protocol.c
+++ b/drivers/hsi/clients/ssi_protocol.c
@@ -182,7 +182,7 @@ static void ssip_skb_to_msg(struct sk_buff *skb, struct hsi_msg *msg)
 		BUG_ON(!sg);
 		frag = &skb_shinfo(skb)->frags[i];
 		sg_set_page(sg, skb_frag_page(frag), skb_frag_size(frag),
-				frag->page_offset);
+				skb_frag_off(frag));
 	}
 }
 
diff --git a/drivers/infiniband/hw/hfi1/vnic_sdma.c b/drivers/infiniband/hw/hfi1/vnic_sdma.c
index 05a140504a99..7d90b900131b 100644
--- a/drivers/infiniband/hw/hfi1/vnic_sdma.c
+++ b/drivers/infiniband/hw/hfi1/vnic_sdma.c
@@ -108,7 +108,7 @@ static noinline int build_vnic_ulp_payload(struct sdma_engine *sde,
 		ret = sdma_txadd_page(sde->dd,
 				      &tx->txreq,
 				      skb_frag_page(frag),
-				      frag->page_offset,
+				      skb_frag_off(frag),
 				      skb_frag_size(frag));
 		if (unlikely(ret))
 			goto bail_txadd;
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index 78fa777c87b1..c332b4761816 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -293,7 +293,8 @@ int ipoib_dma_map_tx(struct ib_device *ca, struct ipoib_tx_buf *tx_req)
 		const skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 		mapping[i + off] = ib_dma_map_page(ca,
 						 skb_frag_page(frag),
-						 frag->page_offset, skb_frag_size(frag),
+						 skb_frag_off(frag),
+						 skb_frag_size(frag),
 						 DMA_TO_DEVICE);
 		if (unlikely(ib_dma_mapping_error(ca, mapping[i + off])))
 			goto partial_error;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index ac61c9352535..c23fbb34f0e9 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -957,7 +957,7 @@ static struct sk_buff *bnxt_rx_page_skb(struct bnxt *bp,
 
 	frag = &skb_shinfo(skb)->frags[0];
 	skb_frag_size_sub(frag, payload);
-	frag->page_offset += payload;
+	skb_frag_off_add(frag, payload);
 	skb->data_len -= payload;
 	skb->tail += payload;
 
diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_queues.c b/drivers/net/ethernet/cavium/thunder/nicvf_queues.c
index c0266a87794c..4ab57d33a87e 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_queues.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_queues.c
@@ -1594,7 +1594,7 @@ int nicvf_sq_append_skb(struct nicvf *nic, struct snd_queue *sq,
 		size = skb_frag_size(frag);
 		dma_addr = dma_map_page_attrs(&nic->pdev->dev,
 					      skb_frag_page(frag),
-					      frag->page_offset, size,
+					      skb_frag_off(frag), size,
 					      DMA_TO_DEVICE,
 					      DMA_ATTR_SKIP_CPU_SYNC);
 		if (dma_mapping_error(&nic->pdev->dev, dma_addr)) {
diff --git a/drivers/net/ethernet/chelsio/cxgb3/sge.c b/drivers/net/ethernet/chelsio/cxgb3/sge.c
index 310a232e00f0..6dabbf1502c7 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/sge.c
@@ -2182,7 +2182,7 @@ static void lro_add_page(struct adapter *adap, struct sge_qset *qs,
 
 	rx_frag += nr_frags;
 	__skb_frag_set_page(rx_frag, sd->pg_chunk.page);
-	rx_frag->page_offset = sd->pg_chunk.offset + offset;
+	skb_frag_off_set(rx_frag, sd->pg_chunk.offset + offset);
 	skb_frag_size_set(rx_frag, len);
 
 	skb->len += len;
diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
index e00a94a03879..1c9883019767 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -2346,8 +2346,8 @@ static void skb_fill_rx_data(struct be_rx_obj *rxo, struct sk_buff *skb,
 		memcpy(skb->data, start, hdr_len);
 		skb_shinfo(skb)->nr_frags = 1;
 		skb_frag_set_page(skb, 0, page_info->page);
-		skb_shinfo(skb)->frags[0].page_offset =
-					page_info->page_offset + hdr_len;
+		skb_frag_off_set(&skb_shinfo(skb)->frags[0],
+				 page_info->page_offset + hdr_len);
 		skb_frag_size_set(&skb_shinfo(skb)->frags[0],
 				  curr_frag_len - hdr_len);
 		skb->data_len = curr_frag_len - hdr_len;
@@ -2372,8 +2372,8 @@ static void skb_fill_rx_data(struct be_rx_obj *rxo, struct sk_buff *skb,
 			/* Fresh page */
 			j++;
 			skb_frag_set_page(skb, j, page_info->page);
-			skb_shinfo(skb)->frags[j].page_offset =
-							page_info->page_offset;
+			skb_frag_off_set(&skb_shinfo(skb)->frags[j],
+					 page_info->page_offset);
 			skb_frag_size_set(&skb_shinfo(skb)->frags[j], 0);
 			skb_shinfo(skb)->nr_frags++;
 		} else {
@@ -2454,8 +2454,8 @@ static void be_rx_compl_process_gro(struct be_rx_obj *rxo,
 			/* First frag or Fresh page */
 			j++;
 			skb_frag_set_page(skb, j, page_info->page);
-			skb_shinfo(skb)->frags[j].page_offset =
-							page_info->page_offset;
+			skb_frag_off_set(&skb_shinfo(skb)->frags[j],
+					 page_info->page_offset);
 			skb_frag_size_set(&skb_shinfo(skb)->frags[j], 0);
 		} else {
 			put_page(page_info->page);
diff --git a/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c b/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c
index 5fad73b2e123..3981c06f082f 100644
--- a/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c
+++ b/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c
@@ -501,7 +501,7 @@ fs_enet_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		nr_frags = skb_shinfo(skb)->nr_frags;
 		frag = skb_shinfo(skb)->frags;
 		for (i = 0; i < nr_frags; i++, frag++) {
-			if (!IS_ALIGNED(frag->page_offset, 4)) {
+			if (!IS_ALIGNED(skb_frag_off(frag), 4)) {
 				is_aligned = 0;
 				break;
 			}
diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 3da680073265..81a05ea38237 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1485,7 +1485,7 @@ static netdev_tx_t ibmvnic_xmit(struct sk_buff *skb, struct net_device *netdev)
 
 			memcpy(dst + cur,
 			       page_address(skb_frag_page(frag)) +
-			       frag->page_offset, skb_frag_size(frag));
+			       skb_frag_off(frag), skb_frag_size(frag));
 			cur += skb_frag_size(frag);
 		}
 	} else {
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index f162252f01b5..e3f29dc8b290 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -3306,7 +3306,7 @@ bool __i40e_chk_linearize(struct sk_buff *skb)
 		 * descriptor associated with the fragment.
 		 */
 		if (stale_size > I40E_MAX_DATA_PER_TXD) {
-			int align_pad = -(stale->page_offset) &
+			int align_pad = -(skb_frag_off(stale)) &
 					(I40E_MAX_READ_REQ_SIZE - 1);
 
 			sum -= align_pad;
diff --git a/drivers/net/ethernet/intel/iavf/iavf_txrx.c b/drivers/net/ethernet/intel/iavf/iavf_txrx.c
index fae7cd1c618a..7a30d5d5ef53 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_txrx.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_txrx.c
@@ -2205,7 +2205,7 @@ bool __iavf_chk_linearize(struct sk_buff *skb)
 		 * descriptor associated with the fragment.
 		 */
 		if (stale_size > IAVF_MAX_DATA_PER_TXD) {
-			int align_pad = -(stale->page_offset) &
+			int align_pad = -(skb_frag_off(stale)) &
 					(IAVF_MAX_READ_REQ_SIZE - 1);
 
 			sum -= align_pad;
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index e12d23d1fa64..dc7b128c780e 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -1807,7 +1807,7 @@ static void ixgbe_pull_tail(struct ixgbe_ring *rx_ring,
 
 	/* update all of the pointers */
 	skb_frag_size_sub(frag, pull_len);
-	frag->page_offset += pull_len;
+	skb_frag_off_add(frag, pull_len);
 	skb->data_len -= pull_len;
 	skb->tail += pull_len;
 }
@@ -1844,7 +1844,7 @@ static void ixgbe_dma_sync_frag(struct ixgbe_ring *rx_ring,
 
 		dma_sync_single_range_for_cpu(rx_ring->dev,
 					      IXGBE_CB(skb)->dma,
-					      frag->page_offset,
+					      skb_frag_off(frag),
 					      skb_frag_size(frag),
 					      DMA_FROM_DEVICE);
 	}
diff --git a/drivers/net/ethernet/jme.c b/drivers/net/ethernet/jme.c
index 9c3ab00643bd..6d52cf5ce20e 100644
--- a/drivers/net/ethernet/jme.c
+++ b/drivers/net/ethernet/jme.c
@@ -2040,8 +2040,8 @@ jme_map_tx_skb(struct jme_adapter *jme, struct sk_buff *skb, int idx)
 		ctxbi = txbi + ((idx + i + 2) & (mask));
 
 		ret = jme_fill_tx_map(jme->pdev, ctxdesc, ctxbi,
-				skb_frag_page(frag),
-				frag->page_offset, skb_frag_size(frag), hidma);
+				      skb_frag_page(frag), skb_frag_off(frag),
+				      skb_frag_size(frag), hidma);
 		if (ret) {
 			jme_drop_tx_map(jme, idx, i);
 			goto out;
diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
index 88ea5ac83c93..82ea55ae5053 100644
--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -659,7 +659,7 @@ static inline unsigned int has_tiny_unaligned_frags(struct sk_buff *skb)
 	for (frag = 0; frag < skb_shinfo(skb)->nr_frags; frag++) {
 		const skb_frag_t *fragp = &skb_shinfo(skb)->frags[frag];
 
-		if (skb_frag_size(fragp) <= 8 && fragp->page_offset & 7)
+		if (skb_frag_size(fragp) <= 8 && skb_frag_off(fragp) & 7)
 			return 1;
 	}
 
diff --git a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
index 9ead6ecb7586..99eaadba555f 100644
--- a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
+++ b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
@@ -1306,8 +1306,8 @@ myri10ge_vlan_rx(struct net_device *dev, void *addr, struct sk_buff *skb)
 		skb->len -= VLAN_HLEN;
 		skb->data_len -= VLAN_HLEN;
 		frag = skb_shinfo(skb)->frags;
-		frag->page_offset += VLAN_HLEN;
-		skb_frag_size_set(frag, skb_frag_size(frag) - VLAN_HLEN);
+		skb_frag_off_add(frag, VLAN_HLEN);
+		skb_frag_size_sub(frag, VLAN_HLEN);
 	}
 }
 
@@ -1364,7 +1364,7 @@ myri10ge_rx_done(struct myri10ge_slice_state *ss, int len, __wsum csum)
 	}
 
 	/* remove padding */
-	rx_frags[0].page_offset += MXGEFW_PAD;
+	skb_frag_off_add(&rx_frags[0], MXGEFW_PAD);
 	skb_frag_size_sub(&rx_frags[0], MXGEFW_PAD);
 	len -= MXGEFW_PAD;
 
diff --git a/drivers/net/ethernet/sfc/tx.c b/drivers/net/ethernet/sfc/tx.c
index 31ec56091a5d..65e81ec1b314 100644
--- a/drivers/net/ethernet/sfc/tx.c
+++ b/drivers/net/ethernet/sfc/tx.c
@@ -274,7 +274,7 @@ static void efx_skb_copy_bits_to_pio(struct efx_nic *efx, struct sk_buff *skb,
 
 		vaddr = kmap_atomic(skb_frag_page(f));
 
-		efx_memcpy_toio_aligned_cb(efx, piobuf, vaddr + f->page_offset,
+		efx_memcpy_toio_aligned_cb(efx, piobuf, vaddr + skb_frag_off(f),
 					   skb_frag_size(f), copy_buf);
 		kunmap_atomic(vaddr);
 	}
diff --git a/drivers/net/ethernet/sun/cassini.c b/drivers/net/ethernet/sun/cassini.c
index 6fc05c106afc..c91876f8c536 100644
--- a/drivers/net/ethernet/sun/cassini.c
+++ b/drivers/net/ethernet/sun/cassini.c
@@ -2034,7 +2034,7 @@ static int cas_rx_process_pkt(struct cas *cp, struct cas_rx_comp *rxc,
 
 		__skb_frag_set_page(frag, page->buffer);
 		__skb_frag_ref(frag);
-		frag->page_offset = off;
+		skb_frag_off_set(frag, off);
 		skb_frag_size_set(frag, hlen - swivel);
 
 		/* any more data? */
@@ -2058,7 +2058,7 @@ static int cas_rx_process_pkt(struct cas *cp, struct cas_rx_comp *rxc,
 
 			__skb_frag_set_page(frag, page->buffer);
 			__skb_frag_ref(frag);
-			frag->page_offset = 0;
+			skb_frag_off_set(frag, 0);
 			skb_frag_size_set(frag, hlen);
 			RX_USED_ADD(page, hlen + cp->crc_size);
 		}
@@ -2816,7 +2816,7 @@ static inline int cas_xmit_tx_ringN(struct cas *cp, int ring,
 		mapping = skb_frag_dma_map(&cp->pdev->dev, fragp, 0, len,
 					   DMA_TO_DEVICE);
 
-		tabort = cas_calc_tabort(cp, fragp->page_offset, len);
+		tabort = cas_calc_tabort(cp, skb_frag_off(fragp), len);
 		if (unlikely(tabort)) {
 			void *addr;
 
@@ -2827,7 +2827,7 @@ static inline int cas_xmit_tx_ringN(struct cas *cp, int ring,
 
 			addr = cas_page_map(skb_frag_page(fragp));
 			memcpy(tx_tiny_buf(cp, ring, entry),
-			       addr + fragp->page_offset + len - tabort,
+			       addr + skb_frag_off(fragp) + len - tabort,
 			       tabort);
 			cas_page_unmap(addr);
 			mapping = tx_tiny_map(cp, ring, entry, tentry);
diff --git a/drivers/net/ethernet/sun/niu.c b/drivers/net/ethernet/sun/niu.c
index 0bc5863bffeb..f5fd1f3c07cc 100644
--- a/drivers/net/ethernet/sun/niu.c
+++ b/drivers/net/ethernet/sun/niu.c
@@ -6695,7 +6695,7 @@ static netdev_tx_t niu_start_xmit(struct sk_buff *skb,
 
 		len = skb_frag_size(frag);
 		mapping = np->ops->map_page(np->device, skb_frag_page(frag),
-					    frag->page_offset, len,
+					    skb_frag_off(frag), len,
 					    DMA_TO_DEVICE);
 
 		rp->tx_buffs[prod].skb = NULL;
diff --git a/drivers/net/ethernet/sun/sunvnet_common.c b/drivers/net/ethernet/sun/sunvnet_common.c
index baa3088b475c..646e67236b65 100644
--- a/drivers/net/ethernet/sun/sunvnet_common.c
+++ b/drivers/net/ethernet/sun/sunvnet_common.c
@@ -1088,7 +1088,7 @@ static inline int vnet_skb_map(struct ldc_channel *lp, struct sk_buff *skb,
 			vaddr = kmap_atomic(skb_frag_page(f));
 			blen = skb_frag_size(f);
 			blen += 8 - (blen & 7);
-			err = ldc_map_single(lp, vaddr + f->page_offset,
+			err = ldc_map_single(lp, vaddr + skb_frag_off(f),
 					     blen, cookies + nc, ncookies - nc,
 					     map_perm);
 			kunmap_atomic(vaddr);
@@ -1124,7 +1124,7 @@ static inline struct sk_buff *vnet_skb_shape(struct sk_buff *skb, int ncookies)
 	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
 		skb_frag_t *f = &skb_shinfo(skb)->frags[i];
 
-		docopy |= f->page_offset & 7;
+		docopy |= skb_frag_off(f) & 7;
 	}
 	if (((unsigned long)skb->data & 7) != VNET_PACKET_SKIP ||
 	    skb_tailroom(skb) < pad ||
diff --git a/drivers/net/ethernet/ti/netcp_core.c b/drivers/net/ethernet/ti/netcp_core.c
index 642843945031..1b2702f74455 100644
--- a/drivers/net/ethernet/ti/netcp_core.c
+++ b/drivers/net/ethernet/ti/netcp_core.c
@@ -1116,7 +1116,7 @@ netcp_tx_map_skb(struct sk_buff *skb, struct netcp_intf *netcp)
 	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
 		skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 		struct page *page = skb_frag_page(frag);
-		u32 page_offset = frag->page_offset;
+		u32 page_offset = skb_frag_off(frag);
 		u32 buf_len = skb_frag_size(frag);
 		dma_addr_t desc_dma;
 		u32 desc_dma_32;
diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 3544e1991579..86884c863013 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -435,7 +435,7 @@ static u32 init_page_array(void *hdr, u32 len, struct sk_buff *skb,
 		skb_frag_t *frag = skb_shinfo(skb)->frags + i;
 
 		slots_used += fill_pg_buf(skb_frag_page(frag),
-					frag->page_offset,
+					skb_frag_off(frag),
 					skb_frag_size(frag), &pb[slots_used]);
 	}
 	return slots_used;
@@ -449,7 +449,7 @@ static int count_skb_frag_slots(struct sk_buff *skb)
 	for (i = 0; i < frags; i++) {
 		skb_frag_t *frag = skb_shinfo(skb)->frags + i;
 		unsigned long size = skb_frag_size(frag);
-		unsigned long offset = frag->page_offset;
+		unsigned long offset = skb_frag_off(frag);
 
 		/* Skip unused frames from start of page */
 		offset &= ~PAGE_MASK;
diff --git a/drivers/net/thunderbolt.c b/drivers/net/thunderbolt.c
index fcf31335a8b6..dacb4f680fd4 100644
--- a/drivers/net/thunderbolt.c
+++ b/drivers/net/thunderbolt.c
@@ -1005,7 +1005,7 @@ static void *tbnet_kmap_frag(struct sk_buff *skb, unsigned int frag_num,
 	const skb_frag_t *frag = &skb_shinfo(skb)->frags[frag_num];
 
 	*len = skb_frag_size(frag);
-	return kmap_atomic(skb_frag_page(frag)) + frag->page_offset;
+	return kmap_atomic(skb_frag_page(frag)) + skb_frag_off(frag);
 }
 
 static netdev_tx_t tbnet_start_xmit(struct sk_buff *skb,
diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index ace7ffaf3913..58952a79b05f 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -1328,7 +1328,7 @@ static int build_dma_sg(const struct sk_buff *skb, struct urb *urb)
 
 		total_len += skb_frag_size(f);
 		sg_set_page(&urb->sg[i + s], skb_frag_page(f), skb_frag_size(f),
-				f->page_offset);
+			    skb_frag_off(f));
 	}
 	urb->transfer_buffer_length = total_len;
 
diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index 03feaeae89cd..216acf37ca7c 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -662,7 +662,7 @@ vmxnet3_append_frag(struct sk_buff *skb, struct Vmxnet3_RxCompDesc *rcd,
 	BUG_ON(skb_shinfo(skb)->nr_frags >= MAX_SKB_FRAGS);
 
 	__skb_frag_set_page(frag, rbi->page);
-	frag->page_offset = 0;
+	skb_frag_off_set(frag, 0);
 	skb_frag_size_set(frag, rcd->len);
 	skb->data_len += rcd->len;
 	skb->truesize += PAGE_SIZE;
diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index a96c5c2a2c5a..3ef07b63613e 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -136,12 +136,12 @@ static inline struct xenvif_queue *ubuf_to_queue(const struct ubuf_info *ubuf)
 
 static u16 frag_get_pending_idx(skb_frag_t *frag)
 {
-	return (u16)frag->page_offset;
+	return (u16)skb_frag_off(frag);
 }
 
 static void frag_set_pending_idx(skb_frag_t *frag, u16 pending_idx)
 {
-	frag->page_offset = pending_idx;
+	skb_frag_off_set(frag, pending_idx);
 }
 
 static inline pending_ring_idx_t pending_index(unsigned i)
@@ -1068,7 +1068,7 @@ static int xenvif_handle_frag_list(struct xenvif_queue *queue, struct sk_buff *s
 
 		offset += len;
 		__skb_frag_set_page(&frags[i], page);
-		frags[i].page_offset = 0;
+		skb_frag_off_set(&frags[i], 0);
 		skb_frag_size_set(&frags[i], len);
 	}
 
diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 8d33970a2950..b930d5f95222 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -531,7 +531,7 @@ static int xennet_count_skb_slots(struct sk_buff *skb)
 	for (i = 0; i < frags; i++) {
 		skb_frag_t *frag = skb_shinfo(skb)->frags + i;
 		unsigned long size = skb_frag_size(frag);
-		unsigned long offset = frag->page_offset;
+		unsigned long offset = skb_frag_off(frag);
 
 		/* Skip unused frames from start of page */
 		offset &= ~PAGE_MASK;
@@ -674,8 +674,8 @@ static netdev_tx_t xennet_start_xmit(struct sk_buff *skb, struct net_device *dev
 	/* Requests for all the frags. */
 	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
 		skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
-		tx = xennet_make_txreqs(queue, tx, skb,
-					skb_frag_page(frag), frag->page_offset,
+		tx = xennet_make_txreqs(queue, tx, skb, skb_frag_page(frag),
+					skb_frag_off(frag),
 					skb_frag_size(frag));
 	}
 
@@ -1040,7 +1040,7 @@ static int xennet_poll(struct napi_struct *napi, int budget)
 		if (NETFRONT_SKB_CB(skb)->pull_to > RX_COPY_THRESHOLD)
 			NETFRONT_SKB_CB(skb)->pull_to = RX_COPY_THRESHOLD;
 
-		skb_shinfo(skb)->frags[0].page_offset = rx->offset;
+		skb_frag_off_set(&skb_shinfo(skb)->frags[0], rx->offset);
 		skb_frag_size_set(&skb_shinfo(skb)->frags[0], rx->status);
 		skb->data_len = rx->status;
 		skb->len += rx->status;
diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 7796799bf04a..9ff9429395eb 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -346,7 +346,7 @@ static int bnx2fc_xmit(struct fc_lport *lport, struct fc_frame *fp)
 			return -ENOMEM;
 		}
 		frag = &skb_shinfo(skb)->frags[skb_shinfo(skb)->nr_frags - 1];
-		cp = kmap_atomic(skb_frag_page(frag)) + frag->page_offset;
+		cp = kmap_atomic(skb_frag_page(frag)) + skb_frag_off(frag);
 	} else {
 		cp = skb_put(skb, tlen);
 	}
diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 00dd47bcbb1e..587d4bbb7d22 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1522,8 +1522,7 @@ static int fcoe_xmit(struct fc_lport *lport, struct fc_frame *fp)
 			return -ENOMEM;
 		}
 		frag = &skb_shinfo(skb)->frags[skb_shinfo(skb)->nr_frags - 1];
-		cp = kmap_atomic(skb_frag_page(frag))
-			+ frag->page_offset;
+		cp = kmap_atomic(skb_frag_page(frag)) + skb_frag_off(frag);
 	} else {
 		cp = skb_put(skb, tlen);
 	}
diff --git a/drivers/scsi/fcoe/fcoe_transport.c b/drivers/scsi/fcoe/fcoe_transport.c
index d0550384cc38..a20ddc301c89 100644
--- a/drivers/scsi/fcoe/fcoe_transport.c
+++ b/drivers/scsi/fcoe/fcoe_transport.c
@@ -318,7 +318,7 @@ u32 fcoe_fc_crc(struct fc_frame *fp)
 
 	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
 		frag = &skb_shinfo(skb)->frags[i];
-		off = frag->page_offset;
+		off = skb_frag_off(frag);
 		len = skb_frag_size(frag);
 		while (len > 0) {
 			clen = min(len, PAGE_SIZE - (off & ~PAGE_MASK));
diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index a42babde036d..42542720962f 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -1077,7 +1077,7 @@ static int qedf_xmit(struct fc_lport *lport, struct fc_frame *fp)
 			return -ENOMEM;
 		}
 		frag = &skb_shinfo(skb)->frags[skb_shinfo(skb)->nr_frags - 1];
-		cp = kmap_atomic(skb_frag_page(frag)) + frag->page_offset;
+		cp = kmap_atomic(skb_frag_page(frag)) + skb_frag_off(frag);
 	} else {
 		cp = skb_put(skb, tlen);
 	}
diff --git a/drivers/staging/unisys/visornic/visornic_main.c b/drivers/staging/unisys/visornic/visornic_main.c
index b889b04a6e25..6fa7726185de 100644
--- a/drivers/staging/unisys/visornic/visornic_main.c
+++ b/drivers/staging/unisys/visornic/visornic_main.c
@@ -284,7 +284,7 @@ static int visor_copy_fragsinfo_from_skb(struct sk_buff *skb,
 		for (frag = 0; frag < numfrags; frag++) {
 			count = add_physinfo_entries(page_to_pfn(
 				  skb_frag_page(&skb_shinfo(skb)->frags[frag])),
-				  skb_shinfo(skb)->frags[frag].page_offset,
+				  skb_frag_off(&skb_shinfo(skb)->frags[frag]),
 				  skb_frag_size(&skb_shinfo(skb)->frags[frag]),
 				  count, frags_max, frags);
 			/* add_physinfo_entries only returns
diff --git a/drivers/target/iscsi/cxgbit/cxgbit_target.c b/drivers/target/iscsi/cxgbit/cxgbit_target.c
index c25315431ad0..fcdc4211e3c2 100644
--- a/drivers/target/iscsi/cxgbit/cxgbit_target.c
+++ b/drivers/target/iscsi/cxgbit/cxgbit_target.c
@@ -900,7 +900,7 @@ cxgbit_handle_immediate_data(struct iscsi_cmd *cmd, struct iscsi_scsi_req *hdr,
 
 		sg_init_table(&ccmd->sg, 1);
 		sg_set_page(&ccmd->sg, skb_frag_page(dfrag),
-				skb_frag_size(dfrag), dfrag->page_offset);
+				skb_frag_size(dfrag), skb_frag_off(dfrag));
 		get_page(skb_frag_page(dfrag));
 
 		cmd->se_cmd.t_data_sg = &ccmd->sg;
@@ -1403,7 +1403,7 @@ static void cxgbit_lro_skb_dump(struct sk_buff *skb)
 			pdu_cb->ddigest, pdu_cb->frags);
 	for (i = 0; i < ssi->nr_frags; i++)
 		pr_info("skb 0x%p, frag %d, off %u, sz %u.\n",
-			skb, i, ssi->frags[i].page_offset,
+			skb, i, skb_frag_off(&ssi->frags[i]),
 			skb_frag_size(&ssi->frags[i]));
 }
 
diff --git a/net/appletalk/ddp.c b/net/appletalk/ddp.c
index a8cb6b2e20c1..4072e9d394d6 100644
--- a/net/appletalk/ddp.c
+++ b/net/appletalk/ddp.c
@@ -953,8 +953,8 @@ static unsigned long atalk_sum_skb(const struct sk_buff *skb, int offset,
 			if (copy > len)
 				copy = len;
 			vaddr = kmap_atomic(skb_frag_page(frag));
-			sum = atalk_sum_partial(vaddr + frag->page_offset +
-						  offset - start, copy, sum);
+			sum = atalk_sum_partial(vaddr + skb_frag_off(frag) +
+						offset - start, copy, sum);
 			kunmap_atomic(vaddr);
 
 			if (!(len -= copy))
diff --git a/net/core/datagram.c b/net/core/datagram.c
index 45a162ef5e02..4cc8dc5db2b7 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -442,8 +442,8 @@ static int __skb_datagram_iter(const struct sk_buff *skb, int offset,
 
 			if (copy > len)
 				copy = len;
-			n = cb(vaddr + frag->page_offset +
-				offset - start, copy, data, to);
+			n = cb(vaddr + skb_frag_off(frag) + offset - start,
+			       copy, data, to);
 			kunmap(page);
 			offset += n;
 			if (n != copy)
@@ -573,7 +573,7 @@ int skb_copy_datagram_from_iter(struct sk_buff *skb, int offset,
 			if (copy > len)
 				copy = len;
 			copied = copy_page_from_iter(skb_frag_page(frag),
-					  frag->page_offset + offset - start,
+					  skb_frag_off(frag) + offset - start,
 					  copy, from);
 			if (copied != copy)
 				goto fault;
diff --git a/net/core/dev.c b/net/core/dev.c
index fc676b2610e3..e2a11c62197b 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5481,7 +5481,7 @@ static void gro_pull_from_frag0(struct sk_buff *skb, int grow)
 	skb->data_len -= grow;
 	skb->tail += grow;
 
-	pinfo->frags[0].page_offset += grow;
+	skb_frag_off_add(&pinfo->frags[0], grow);
 	skb_frag_size_sub(&pinfo->frags[0], grow);
 
 	if (unlikely(!skb_frag_size(&pinfo->frags[0]))) {
diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index bb9915291644..c5dbdc87342a 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -2652,7 +2652,7 @@ static void pktgen_finalize_skb(struct pktgen_dev *pkt_dev, struct sk_buff *skb,
 			}
 			get_page(pkt_dev->page);
 			skb_frag_set_page(skb, i, pkt_dev->page);
-			skb_shinfo(skb)->frags[i].page_offset = 0;
+			skb_frag_off_set(&skb_shinfo(skb)->frags[i], 0);
 			/*last fragment, fill rest of data*/
 			if (i == (frags - 1))
 				skb_frag_size_set(&skb_shinfo(skb)->frags[i],
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 0b788df5a75b..ea8e8d332d85 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -785,7 +785,7 @@ void skb_dump(const char *level, const struct sk_buff *skb, bool full_pkt)
 		struct page *p;
 		u8 *vaddr;
 
-		skb_frag_foreach_page(frag, frag->page_offset,
+		skb_frag_foreach_page(frag, skb_frag_off(frag),
 				      skb_frag_size(frag), p, p_off, p_len,
 				      copied) {
 			seg_len = min_t(int, p_len, len);
@@ -1375,7 +1375,7 @@ int skb_copy_ubufs(struct sk_buff *skb, gfp_t gfp_mask)
 		struct page *p;
 		u8 *vaddr;
 
-		skb_frag_foreach_page(f, f->page_offset, skb_frag_size(f),
+		skb_frag_foreach_page(f, skb_frag_off(f), skb_frag_size(f),
 				      p, p_off, p_len, copied) {
 			u32 copy, done = 0;
 			vaddr = kmap_atomic(p);
@@ -2144,10 +2144,12 @@ void *__pskb_pull_tail(struct sk_buff *skb, int delta)
 			skb_frag_unref(skb, i);
 			eat -= size;
 		} else {
-			skb_shinfo(skb)->frags[k] = skb_shinfo(skb)->frags[i];
+			skb_frag_t *frag = &skb_shinfo(skb)->frags[k];
+
+			*frag = skb_shinfo(skb)->frags[i];
 			if (eat) {
-				skb_shinfo(skb)->frags[k].page_offset += eat;
-				skb_frag_size_sub(&skb_shinfo(skb)->frags[k], eat);
+				skb_frag_off_add(frag, eat);
+				skb_frag_size_sub(frag, eat);
 				if (!i)
 					goto end;
 				eat = 0;
@@ -2219,7 +2221,7 @@ int skb_copy_bits(const struct sk_buff *skb, int offset, void *to, int len)
 				copy = len;
 
 			skb_frag_foreach_page(f,
-					      f->page_offset + offset - start,
+					      skb_frag_off(f) + offset - start,
 					      copy, p, p_off, p_len, copied) {
 				vaddr = kmap_atomic(p);
 				memcpy(to + copied, vaddr + p_off, p_len);
@@ -2395,7 +2397,7 @@ static bool __skb_splice_bits(struct sk_buff *skb, struct pipe_inode_info *pipe,
 		const skb_frag_t *f = &skb_shinfo(skb)->frags[seg];
 
 		if (__splice_segment(skb_frag_page(f),
-				     f->page_offset, skb_frag_size(f),
+				     skb_frag_off(f), skb_frag_size(f),
 				     offset, len, spd, false, sk, pipe))
 			return true;
 	}
@@ -2498,7 +2500,7 @@ int skb_send_sock_locked(struct sock *sk, struct sk_buff *skb, int offset,
 
 		while (slen) {
 			ret = kernel_sendpage_locked(sk, skb_frag_page(frag),
-						     frag->page_offset + offset,
+						     skb_frag_off(frag) + offset,
 						     slen, MSG_DONTWAIT);
 			if (ret <= 0)
 				goto error;
@@ -2580,7 +2582,7 @@ int skb_store_bits(struct sk_buff *skb, int offset, const void *from, int len)
 				copy = len;
 
 			skb_frag_foreach_page(frag,
-					      frag->page_offset + offset - start,
+					      skb_frag_off(frag) + offset - start,
 					      copy, p, p_off, p_len, copied) {
 				vaddr = kmap_atomic(p);
 				memcpy(vaddr + p_off, from + copied, p_len);
@@ -2660,7 +2662,7 @@ __wsum __skb_checksum(const struct sk_buff *skb, int offset, int len,
 				copy = len;
 
 			skb_frag_foreach_page(frag,
-					      frag->page_offset + offset - start,
+					      skb_frag_off(frag) + offset - start,
 					      copy, p, p_off, p_len, copied) {
 				vaddr = kmap_atomic(p);
 				csum2 = INDIRECT_CALL_1(ops->update,
@@ -2759,7 +2761,7 @@ __wsum skb_copy_and_csum_bits(const struct sk_buff *skb, int offset,
 				copy = len;
 
 			skb_frag_foreach_page(frag,
-					      frag->page_offset + offset - start,
+					      skb_frag_off(frag) + offset - start,
 					      copy, p, p_off, p_len, copied) {
 				vaddr = kmap_atomic(p);
 				csum2 = csum_partial_copy_nocheck(vaddr + p_off,
@@ -3234,7 +3236,7 @@ static inline void skb_split_no_header(struct sk_buff *skb,
 				 * 2. Split is accurately. We make this.
 				 */
 				skb_frag_ref(skb, i);
-				skb_shinfo(skb1)->frags[0].page_offset += len - pos;
+				skb_frag_off_add(&skb_shinfo(skb1)->frags[0], len - pos);
 				skb_frag_size_sub(&skb_shinfo(skb1)->frags[0], len - pos);
 				skb_frag_size_set(&skb_shinfo(skb)->frags[i], len - pos);
 				skb_shinfo(skb)->nr_frags++;
@@ -3316,7 +3318,7 @@ int skb_shift(struct sk_buff *tgt, struct sk_buff *skb, int shiftlen)
 	 */
 	if (!to ||
 	    !skb_can_coalesce(tgt, to, skb_frag_page(fragfrom),
-			      fragfrom->page_offset)) {
+			      skb_frag_off(fragfrom))) {
 		merge = -1;
 	} else {
 		merge = to - 1;
@@ -3333,7 +3335,7 @@ int skb_shift(struct sk_buff *tgt, struct sk_buff *skb, int shiftlen)
 
 			skb_frag_size_add(fragto, shiftlen);
 			skb_frag_size_sub(fragfrom, shiftlen);
-			fragfrom->page_offset += shiftlen;
+			skb_frag_off_add(fragfrom, shiftlen);
 
 			goto onlymerged;
 		}
@@ -3364,11 +3366,11 @@ int skb_shift(struct sk_buff *tgt, struct sk_buff *skb, int shiftlen)
 
 		} else {
 			__skb_frag_ref(fragfrom);
-			fragto->bv_page = fragfrom->bv_page;
-			fragto->page_offset = fragfrom->page_offset;
+			skb_frag_page_copy(fragto, fragfrom);
+			skb_frag_off_copy(fragto, fragfrom);
 			skb_frag_size_set(fragto, todo);
 
-			fragfrom->page_offset += todo;
+			skb_frag_off_add(fragfrom, todo);
 			skb_frag_size_sub(fragfrom, todo);
 			todo = 0;
 
@@ -3493,7 +3495,7 @@ unsigned int skb_seq_read(unsigned int consumed, const u8 **data,
 			if (!st->frag_data)
 				st->frag_data = kmap_atomic(skb_frag_page(frag));
 
-			*data = (u8 *) st->frag_data + frag->page_offset +
+			*data = (u8 *) st->frag_data + skb_frag_off(frag) +
 				(abs_offset - st->stepped_offset);
 
 			return block_limit - abs_offset;
@@ -3630,8 +3632,8 @@ static inline skb_frag_t skb_head_frag_to_page_desc(struct sk_buff *frag_skb)
 
 	page = virt_to_head_page(frag_skb->head);
 	__skb_frag_set_page(&head_frag, page);
-	head_frag.page_offset = frag_skb->data -
-		(unsigned char *)page_address(page);
+	skb_frag_off_set(&head_frag, frag_skb->data -
+			 (unsigned char *)page_address(page));
 	skb_frag_size_set(&head_frag, skb_headlen(frag_skb));
 	return head_frag;
 }
@@ -3875,7 +3877,7 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
 			size = skb_frag_size(nskb_frag);
 
 			if (pos < offset) {
-				nskb_frag->page_offset += offset - pos;
+				skb_frag_off_add(nskb_frag, offset - pos);
 				skb_frag_size_sub(nskb_frag, offset - pos);
 			}
 
@@ -3996,7 +3998,7 @@ int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb)
 			*--frag = *--frag2;
 		} while (--i);
 
-		frag->page_offset += offset;
+		skb_frag_off_add(frag, offset);
 		skb_frag_size_sub(frag, offset);
 
 		/* all fragments truesize : remove (head size + sk_buff) */
@@ -4026,7 +4028,7 @@ int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb)
 		pinfo->nr_frags = nr_frags + 1 + skbinfo->nr_frags;
 
 		__skb_frag_set_page(frag, page);
-		frag->page_offset = first_offset;
+		skb_frag_off_set(frag, first_offset);
 		skb_frag_size_set(frag, first_size);
 
 		memcpy(frag + 1, skbinfo->frags, sizeof(*frag) * skbinfo->nr_frags);
@@ -4042,7 +4044,7 @@ int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb)
 	if (offset > headlen) {
 		unsigned int eat = offset - headlen;
 
-		skbinfo->frags[0].page_offset += eat;
+		skb_frag_off_add(&skbinfo->frags[0], eat);
 		skb_frag_size_sub(&skbinfo->frags[0], eat);
 		skb->data_len -= eat;
 		skb->len -= eat;
@@ -4167,7 +4169,7 @@ __skb_to_sgvec(struct sk_buff *skb, struct scatterlist *sg, int offset, int len,
 			if (copy > len)
 				copy = len;
 			sg_set_page(&sg[elt], skb_frag_page(frag), copy,
-					frag->page_offset+offset-start);
+				    skb_frag_off(frag) + offset - start);
 			elt++;
 			if (!(len -= copy))
 				return elt;
@@ -5838,7 +5840,7 @@ static int pskb_carve_inside_nonlinear(struct sk_buff *skb, const u32 off,
 				 *    where splitting is expensive.
 				 * 2. Split is accurately. We make this.
 				 */
-				shinfo->frags[0].page_offset += off - pos;
+				skb_frag_off_add(&shinfo->frags[0], off - pos);
 				skb_frag_size_sub(&shinfo->frags[0], off - pos);
 			}
 			skb_frag_ref(skb, i);
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index f62f0e7e3cdd..a0a66321c0ee 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1782,12 +1782,12 @@ static int tcp_zerocopy_receive(struct sock *sk,
 				frags++;
 			}
 		}
-		if (skb_frag_size(frags) != PAGE_SIZE || frags->page_offset) {
+		if (skb_frag_size(frags) != PAGE_SIZE || skb_frag_off(frags)) {
 			int remaining = zc->recv_skip_hint;
 			int size = skb_frag_size(frags);
 
 			while (remaining && (size != PAGE_SIZE ||
-					     frags->page_offset)) {
+					     skb_frag_off(frags))) {
 				remaining -= size;
 				frags++;
 				size = skb_frag_size(frags);
@@ -3784,7 +3784,7 @@ int tcp_md5_hash_skb_data(struct tcp_md5sig_pool *hp,
 
 	for (i = 0; i < shi->nr_frags; ++i) {
 		const skb_frag_t *f = &shi->frags[i];
-		unsigned int offset = f->page_offset;
+		unsigned int offset = skb_frag_off(f);
 		struct page *page = skb_frag_page(f) + (offset >> PAGE_SHIFT);
 
 		sg_set_page(&sg, page, skb_frag_size(f),
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 6e4afc48d7bb..e6d02e05bb1c 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1402,7 +1402,7 @@ static int __pskb_trim_head(struct sk_buff *skb, int len)
 		} else {
 			shinfo->frags[k] = shinfo->frags[i];
 			if (eat) {
-				shinfo->frags[k].page_offset += eat;
+				skb_frag_off_add(&shinfo->frags[k], eat);
 				skb_frag_size_sub(&shinfo->frags[k], eat);
 				eat = 0;
 			}
diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
index 05f63c4300e9..4ff75c3a8d6e 100644
--- a/net/kcm/kcmsock.c
+++ b/net/kcm/kcmsock.c
@@ -642,7 +642,7 @@ static int kcm_write_msgs(struct kcm_sock *kcm)
 
 			ret = kernel_sendpage(psock->sk->sk_socket,
 					      skb_frag_page(frag),
-					      frag->page_offset + frag_offset,
+					      skb_frag_off(frag) + frag_offset,
 					      skb_frag_size(frag) - frag_offset,
 					      MSG_DONTWAIT);
 			if (ret <= 0) {
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 4ec8a06fa5d1..d184230665eb 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -244,12 +244,12 @@ static void tls_append_frag(struct tls_record_info *record,
 
 	frag = &record->frags[record->num_frags - 1];
 	if (skb_frag_page(frag) == pfrag->page &&
-	    frag->page_offset + skb_frag_size(frag) == pfrag->offset) {
+	    skb_frag_off(frag) + skb_frag_size(frag) == pfrag->offset) {
 		skb_frag_size_add(frag, size);
 	} else {
 		++frag;
 		__skb_frag_set_page(frag, pfrag->page);
-		frag->page_offset = pfrag->offset;
+		skb_frag_off_set(frag, pfrag->offset);
 		skb_frag_size_set(frag, size);
 		++record->num_frags;
 		get_page(pfrag->page);
@@ -301,7 +301,7 @@ static int tls_push_record(struct sock *sk,
 		frag = &record->frags[i];
 		sg_unmark_end(&offload_ctx->sg_tx_data[i]);
 		sg_set_page(&offload_ctx->sg_tx_data[i], skb_frag_page(frag),
-			    skb_frag_size(frag), frag->page_offset);
+			    skb_frag_size(frag), skb_frag_off(frag));
 		sk_mem_charge(sk, skb_frag_size(frag));
 		get_page(skb_frag_page(frag));
 	}
@@ -324,7 +324,7 @@ static int tls_create_new_record(struct tls_offload_context_tx *offload_ctx,
 
 	frag = &record->frags[0];
 	__skb_frag_set_page(frag, pfrag->page);
-	frag->page_offset = pfrag->offset;
+	skb_frag_off_set(frag, pfrag->offset);
 	skb_frag_size_set(frag, prepend_size);
 
 	get_page(pfrag->page);
diff --git a/net/tls/tls_device_fallback.c b/net/tls/tls_device_fallback.c
index 9070d68a92a4..28895333701e 100644
--- a/net/tls/tls_device_fallback.c
+++ b/net/tls/tls_device_fallback.c
@@ -273,7 +273,7 @@ static int fill_sg_in(struct scatterlist *sg_in,
 
 		__skb_frag_ref(frag);
 		sg_set_page(sg_in + i, skb_frag_page(frag),
-			    skb_frag_size(frag), frag->page_offset);
+			    skb_frag_size(frag), skb_frag_off(frag));
 
 		remaining -= skb_frag_size(frag);
 
diff --git a/net/xfrm/xfrm_ipcomp.c b/net/xfrm/xfrm_ipcomp.c
index 32c364d3bfb3..4d422447aadc 100644
--- a/net/xfrm/xfrm_ipcomp.c
+++ b/net/xfrm/xfrm_ipcomp.c
@@ -85,7 +85,7 @@ static int ipcomp_decompress(struct xfrm_state *x, struct sk_buff *skb)
 		if (dlen < len)
 			len = dlen;
 
-		frag->page_offset = 0;
+		skb_frag_off_set(frag, 0);
 		skb_frag_size_set(frag, len);
 		memcpy(skb_frag_address(frag), scratch, len);
 
-- 
2.17.1

