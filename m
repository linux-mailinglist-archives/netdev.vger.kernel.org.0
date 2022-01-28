Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A03AC49F243
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 05:11:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235930AbiA1ELx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 23:11:53 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:4880 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231222AbiA1ELw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 23:11:52 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20RKAvL3027128;
        Thu, 27 Jan 2022 20:11:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=dswPibX9UreF4IHHfOLbw85LAEcCpr9DV0oFUqS3KTE=;
 b=bjtpdpxqXnXg8KTFQEKZavj+3+wZDwJymfZlSy9E05F569hjTx7JMo892SzTa4EHiRa2
 PvcoWlF57oBLkM541iajtMijXhOfTUI7nlnyjUwcvrRCytfGJLX7FmsjBjyUI8toZ7s4
 N5VzfeLC8O6CWGHiUf3fWHhLphb3tsDRpBsORdn86ZIs6s88dfObLMwBGIvkqsC8q+Fq
 Fu6KYA1fsdT/q+I+3XM7dha3aBztIj6/aQlIVL7BaQT9EZc0tFc2D4z0Zj+DIEB5HrVp
 X6a80C4ZMT2U5Jw08NTlHq7j5m9fBpf+/EgFMc4s4hWEbKWu29vd3k9CRy9LPIX2w1b2 1g== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3dv1jj9cmm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 27 Jan 2022 20:11:43 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 27 Jan
 2022 20:11:41 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 27 Jan 2022 20:11:41 -0800
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id C20083F7065;
        Thu, 27 Jan 2022 20:11:38 -0800 (PST)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <sundeep.lkml@gmail.com>
CC:     <hkelam@marvell.com>, <gakula@marvell.com>, <sgoutham@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net-next PATCH v2] octeontx2-pf: Change receive buffer size using ethtool
Date:   Fri, 28 Jan 2022 09:41:36 +0530
Message-ID: <1643343096-31954-1-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: NC7hkrDL2Y0uFyY-exFdhW9ProzB5G7_
X-Proofpoint-GUID: NC7hkrDL2Y0uFyY-exFdhW9ProzB5G7_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-27_06,2022-01-27_01,2021-12-02_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ethtool rx-buf-len is for setting receive buffer size,
support setting it via ethtool -G parameter and getting
it via ethtool -g parameter.

Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---

v3:
 No changes. Submitting after net-next is opened.
v2:
 As per Jakub comments, changed logic not to reset
 receive buffer length when user changes mtu.

 .../net/ethernet/marvell/octeontx2/nic/otx2_common.c  |  7 +++++++
 .../net/ethernet/marvell/octeontx2/nic/otx2_common.h  |  3 +++
 .../net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c | 19 ++++++++++++++++++-
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c  |  4 ++++
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c  |  1 +
 5 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 66da31f..92c0ddb 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -222,8 +222,11 @@ EXPORT_SYMBOL(otx2_set_mac_address);
 int otx2_hw_set_mtu(struct otx2_nic *pfvf, int mtu)
 {
 	struct nix_frs_cfg *req;
+	u16 maxlen;
 	int err;
 
+	maxlen = otx2_get_max_mtu(pfvf) + OTX2_ETH_HLEN + OTX2_HW_TIMESTAMP_LEN;
+
 	mutex_lock(&pfvf->mbox.lock);
 	req = otx2_mbox_alloc_msg_nix_set_hw_frs(&pfvf->mbox);
 	if (!req) {
@@ -233,6 +236,10 @@ int otx2_hw_set_mtu(struct otx2_nic *pfvf, int mtu)
 
 	req->maxlen = pfvf->netdev->mtu + OTX2_ETH_HLEN + OTX2_HW_TIMESTAMP_LEN;
 
+	/* Use max receive length supported by hardware for loopback devices */
+	if (is_otx2_lbkvf(pfvf->pdev))
+		req->maxlen = maxlen;
+
 	err = otx2_sync_mbox_msg(&pfvf->mbox);
 	mutex_unlock(&pfvf->mbox.lock);
 	return err;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 61e5281..8a6539b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -178,6 +178,9 @@ struct otx2_hw {
 	u16			rqpool_cnt;
 	u16			sqpool_cnt;
 
+#define OTX2_DEFAULT_RBUF_LEN	2048
+	u16			rbuf_len;
+
 	/* NPA */
 	u32			stack_pg_ptrs;  /* No of ptrs per stack page */
 	u32			stack_pg_bytes; /* Size of stack page */
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
index d85db90..abe5267 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -371,6 +371,7 @@ static void otx2_get_ringparam(struct net_device *netdev,
 	ring->rx_pending = qs->rqe_cnt ? qs->rqe_cnt : Q_COUNT(Q_SIZE_256);
 	ring->tx_max_pending = Q_COUNT(Q_SIZE_MAX);
 	ring->tx_pending = qs->sqe_cnt ? qs->sqe_cnt : Q_COUNT(Q_SIZE_4K);
+	kernel_ring->rx_buf_len = pfvf->hw.rbuf_len;
 }
 
 static int otx2_set_ringparam(struct net_device *netdev,
@@ -379,6 +380,8 @@ static int otx2_set_ringparam(struct net_device *netdev,
 			      struct netlink_ext_ack *extack)
 {
 	struct otx2_nic *pfvf = netdev_priv(netdev);
+	u32 rx_buf_len = kernel_ring->rx_buf_len;
+	u32 old_rx_buf_len = pfvf->hw.rbuf_len;
 	bool if_up = netif_running(netdev);
 	struct otx2_qset *qs = &pfvf->qset;
 	u32 rx_count, tx_count;
@@ -386,6 +389,15 @@ static int otx2_set_ringparam(struct net_device *netdev,
 	if (ring->rx_mini_pending || ring->rx_jumbo_pending)
 		return -EINVAL;
 
+	/* Hardware supports max size of 32k for a receive buffer
+	 * and 1536 is typical ethernet frame size.
+	 */
+	if (rx_buf_len && (rx_buf_len < 1536 || rx_buf_len > 32768)) {
+		netdev_err(netdev,
+			   "Receive buffer range is 1536 - 32768");
+		return -EINVAL;
+	}
+
 	/* Permitted lengths are 16 64 256 1K 4K 16K 64K 256K 1M  */
 	rx_count = ring->rx_pending;
 	/* On some silicon variants a skid or reserved CQEs are
@@ -403,7 +415,8 @@ static int otx2_set_ringparam(struct net_device *netdev,
 			   Q_COUNT(Q_SIZE_4K), Q_COUNT(Q_SIZE_MAX));
 	tx_count = Q_COUNT(Q_SIZE(tx_count, 3));
 
-	if (tx_count == qs->sqe_cnt && rx_count == qs->rqe_cnt)
+	if (tx_count == qs->sqe_cnt && rx_count == qs->rqe_cnt &&
+	    rx_buf_len == old_rx_buf_len)
 		return 0;
 
 	if (if_up)
@@ -413,6 +426,8 @@ static int otx2_set_ringparam(struct net_device *netdev,
 	qs->sqe_cnt = tx_count;
 	qs->rqe_cnt = rx_count;
 
+	pfvf->hw.rbuf_len = rx_buf_len;
+
 	if (if_up)
 		return netdev->netdev_ops->ndo_open(netdev);
 
@@ -1207,6 +1222,7 @@ static int otx2_set_link_ksettings(struct net_device *netdev,
 static const struct ethtool_ops otx2_ethtool_ops = {
 	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
 				     ETHTOOL_COALESCE_MAX_FRAMES,
+	.supported_ring_params  = ETHTOOL_RING_USE_RX_BUF_LEN,
 	.get_link		= otx2_get_link,
 	.get_drvinfo		= otx2_get_drvinfo,
 	.get_strings		= otx2_get_strings,
@@ -1326,6 +1342,7 @@ static int otx2vf_get_link_ksettings(struct net_device *netdev,
 static const struct ethtool_ops otx2vf_ethtool_ops = {
 	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
 				     ETHTOOL_COALESCE_MAX_FRAMES,
+	.supported_ring_params  = ETHTOOL_RING_USE_RX_BUF_LEN,
 	.get_link		= otx2_get_link,
 	.get_drvinfo		= otx2vf_get_drvinfo,
 	.get_strings		= otx2vf_get_strings,
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 6080ebd..3699b58 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1306,6 +1306,9 @@ static int otx2_get_rbuf_size(struct otx2_nic *pf, int mtu)
 	int total_size;
 	int rbuf_size;
 
+	if (pf->hw.rbuf_len)
+		return ALIGN(pf->hw.rbuf_len, OTX2_ALIGN) + OTX2_HEAD_ROOM;
+
 	/* The data transferred by NIX to memory consists of actual packet
 	 * plus additional data which has timestamp and/or EDSA/HIGIG2
 	 * headers if interface is configured in corresponding modes.
@@ -2620,6 +2623,7 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	hw->tx_queues = qcount;
 	hw->tot_tx_queues = qcount;
 	hw->max_queues = qcount;
+	hw->rbuf_len = OTX2_DEFAULT_RBUF_LEN;
 
 	num_vec = pci_msix_vec_count(pdev);
 	hw->irq_name = devm_kmalloc_array(&hw->pdev->dev, num_vec, NAME_SIZE,
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
index 925b74e..d96c890 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -586,6 +586,7 @@ static int otx2vf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	hw->tx_queues = qcount;
 	hw->max_queues = qcount;
 	hw->tot_tx_queues = qcount;
+	hw->rbuf_len = OTX2_DEFAULT_RBUF_LEN;
 
 	hw->irq_name = devm_kmalloc_array(&hw->pdev->dev, num_vec, NAME_SIZE,
 					  GFP_KERNEL);
-- 
2.7.4

