Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D6454C0182
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 19:39:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234123AbiBVSkE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 13:40:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234178AbiBVSkD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 13:40:03 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4E2CB5638
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 10:39:37 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21MGu0do025483;
        Tue, 22 Feb 2022 10:39:26 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=0Tm2DPuvIAiibcjtKNb7zv0j1BSBrgWIoVJloFC5QEE=;
 b=Mc5QfCX4vrtxDZfxPh3AHnWeH14R32t/cPAtk5510m2a1ECOoO11aXuFp4zEG6mi+EHH
 zzpFLy35xflOVrCrnQH/EBEVQGcNGotisMzTIr4iiyglXWNJqW8lDGY3Ldg4khx/q2qg
 za7+CDPNriwIKpBgixedgWd/bcxijqeYBoUsgJvhiIyHEdS+HlvwdIrAT/R8Zxq2m5ll
 LFpmTwcmJZ8f1XZJ/qNTrf+VIVMQa1ERoKNfQMhqZ/Sm1gewqinEeqQ8yO6lpz0w7dt2
 q9q4POmu/mOAs03Sa5hDO8e7+j92uTRV5SBc9fSibZtmSJwr78drL94pd41PcoCQdiVR nw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3ecw9y2d86-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 22 Feb 2022 10:39:26 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 22 Feb
 2022 10:39:24 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 22 Feb 2022 10:39:24 -0800
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id 9B13C3F7060;
        Tue, 22 Feb 2022 10:39:21 -0800 (PST)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <sundeep.lkml@gmail.com>
CC:     <hkelam@marvell.com>, <gakula@marvell.com>, <sgoutham@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [v2 net-next PATCH 2/2] octeontx2-pf: Vary completion queue event size
Date:   Wed, 23 Feb 2022 00:09:13 +0530
Message-ID: <1645555153-4932-3-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1645555153-4932-1-git-send-email-sbhatta@marvell.com>
References: <1645555153-4932-1-git-send-email-sbhatta@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: RFzzvO_HPMGlwScG2EqsF31_YEGt8gsJ
X-Proofpoint-ORIG-GUID: RFzzvO_HPMGlwScG2EqsF31_YEGt8gsJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-22_06,2022-02-21_02,2021-12-02_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Completion Queue Entry(CQE) is a descriptor written
by hardware to notify software about the send and
receive completion status. The CQE can be of size
128 or 512 bytes. A 512 bytes CQE can hold more receive
fragments pointers compared to 128 bytes CQE. This
patch enables to modify CQE size using:
<ethtool -G cqe-size N>.

Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/nic/otx2_common.c    |  4 ++--
 .../net/ethernet/marvell/octeontx2/nic/otx2_common.h    |  1 +
 .../net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c   | 17 ++++++++++++++---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c    |  2 ++
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c    |  2 ++
 5 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 2c97608..b9d7601 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -1048,7 +1048,7 @@ int otx2_config_nix(struct otx2_nic *pfvf)
 	struct nix_lf_alloc_rsp *rsp;
 	int err;
 
-	pfvf->qset.xqe_size = NIX_XQESZ_W16 ? 128 : 512;
+	pfvf->qset.xqe_size = pfvf->hw.xqe_size;
 
 	/* Get memory to put this msg */
 	nixlf = otx2_mbox_alloc_msg_nix_lf_alloc(&pfvf->mbox);
@@ -1061,7 +1061,7 @@ int otx2_config_nix(struct otx2_nic *pfvf)
 	nixlf->cq_cnt = pfvf->qset.cq_cnt;
 	nixlf->rss_sz = MAX_RSS_INDIR_TBL_SIZE;
 	nixlf->rss_grps = MAX_RSS_GROUPS;
-	nixlf->xqe_sz = NIX_XQESZ_W16;
+	nixlf->xqe_sz = pfvf->hw.xqe_size == 128 ? NIX_XQESZ_W16 : NIX_XQESZ_W64;
 	/* We don't know absolute NPA LF idx attached.
 	 * AF will replace 'RVU_DEFAULT_PF_FUNC' with
 	 * NPA LF attached to this RVU PF/VF.
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 65e31a2..c587c14 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -181,6 +181,7 @@ struct otx2_hw {
 
 #define OTX2_DEFAULT_RBUF_LEN	2048
 	u16			rbuf_len;
+	u32			xqe_size;
 
 	/* NPA */
 	u32			stack_pg_ptrs;  /* No of ptrs per stack page */
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
index abe5267..fc328de 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -372,6 +372,7 @@ static void otx2_get_ringparam(struct net_device *netdev,
 	ring->tx_max_pending = Q_COUNT(Q_SIZE_MAX);
 	ring->tx_pending = qs->sqe_cnt ? qs->sqe_cnt : Q_COUNT(Q_SIZE_4K);
 	kernel_ring->rx_buf_len = pfvf->hw.rbuf_len;
+	kernel_ring->cqe_size = pfvf->hw.xqe_size;
 }
 
 static int otx2_set_ringparam(struct net_device *netdev,
@@ -382,6 +383,7 @@ static int otx2_set_ringparam(struct net_device *netdev,
 	struct otx2_nic *pfvf = netdev_priv(netdev);
 	u32 rx_buf_len = kernel_ring->rx_buf_len;
 	u32 old_rx_buf_len = pfvf->hw.rbuf_len;
+	u32 xqe_size = kernel_ring->cqe_size;
 	bool if_up = netif_running(netdev);
 	struct otx2_qset *qs = &pfvf->qset;
 	u32 rx_count, tx_count;
@@ -398,6 +400,12 @@ static int otx2_set_ringparam(struct net_device *netdev,
 		return -EINVAL;
 	}
 
+	if (xqe_size != 128 && xqe_size != 512) {
+		netdev_err(netdev,
+			   "Completion event size must be 128 or 512");
+		return -EINVAL;
+	}
+
 	/* Permitted lengths are 16 64 256 1K 4K 16K 64K 256K 1M  */
 	rx_count = ring->rx_pending;
 	/* On some silicon variants a skid or reserved CQEs are
@@ -416,7 +424,7 @@ static int otx2_set_ringparam(struct net_device *netdev,
 	tx_count = Q_COUNT(Q_SIZE(tx_count, 3));
 
 	if (tx_count == qs->sqe_cnt && rx_count == qs->rqe_cnt &&
-	    rx_buf_len == old_rx_buf_len)
+	    rx_buf_len == old_rx_buf_len && xqe_size == pfvf->hw.xqe_size)
 		return 0;
 
 	if (if_up)
@@ -427,6 +435,7 @@ static int otx2_set_ringparam(struct net_device *netdev,
 	qs->rqe_cnt = rx_count;
 
 	pfvf->hw.rbuf_len = rx_buf_len;
+	pfvf->hw.xqe_size = xqe_size;
 
 	if (if_up)
 		return netdev->netdev_ops->ndo_open(netdev);
@@ -1222,7 +1231,8 @@ static int otx2_set_link_ksettings(struct net_device *netdev,
 static const struct ethtool_ops otx2_ethtool_ops = {
 	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
 				     ETHTOOL_COALESCE_MAX_FRAMES,
-	.supported_ring_params  = ETHTOOL_RING_USE_RX_BUF_LEN,
+	.supported_ring_params  = ETHTOOL_RING_USE_RX_BUF_LEN |
+				  ETHTOOL_RING_USE_CQE_SIZE,
 	.get_link		= otx2_get_link,
 	.get_drvinfo		= otx2_get_drvinfo,
 	.get_strings		= otx2_get_strings,
@@ -1342,7 +1352,8 @@ static int otx2vf_get_link_ksettings(struct net_device *netdev,
 static const struct ethtool_ops otx2vf_ethtool_ops = {
 	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
 				     ETHTOOL_COALESCE_MAX_FRAMES,
-	.supported_ring_params  = ETHTOOL_RING_USE_RX_BUF_LEN,
+	.supported_ring_params  = ETHTOOL_RING_USE_RX_BUF_LEN |
+				  ETHTOOL_RING_USE_CQE_SIZE,
 	.get_link		= otx2_get_link,
 	.get_drvinfo		= otx2vf_get_drvinfo,
 	.get_strings		= otx2vf_get_strings,
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index a536916..441aafc 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -2585,6 +2585,8 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	hw->tot_tx_queues = qcount;
 	hw->max_queues = qcount;
 	hw->rbuf_len = OTX2_DEFAULT_RBUF_LEN;
+	/* Use CQE of 128 byte descriptor size by default */
+	hw->xqe_size = 128;
 
 	num_vec = pci_msix_vec_count(pdev);
 	hw->irq_name = devm_kmalloc_array(&hw->pdev->dev, num_vec, NAME_SIZE,
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
index a232e20..9e87836 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -572,6 +572,8 @@ static int otx2vf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	hw->max_queues = qcount;
 	hw->tot_tx_queues = qcount;
 	hw->rbuf_len = OTX2_DEFAULT_RBUF_LEN;
+	/* Use CQE of 128 byte descriptor size by default */
+	hw->xqe_size = 128;
 
 	hw->irq_name = devm_kmalloc_array(&hw->pdev->dev, num_vec, NAME_SIZE,
 					  GFP_KERNEL);
-- 
2.7.4

