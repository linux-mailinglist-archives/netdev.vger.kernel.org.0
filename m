Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DBDD48C909
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 18:04:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348402AbiALRE1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 12:04:27 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:2184 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1355460AbiALRDO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 12:03:14 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20CBSxEH021154;
        Wed, 12 Jan 2022 09:03:03 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=gXQYsttVto3q2avSaIuX/Zbuj5P8ZtSBJxZBwJFW2B8=;
 b=XjFJgi9Cc6K2Pnlcb1r5SqnYHEmj6swxtASfwGOoh5+s984JdbiEHuvw7biaaeASfiVQ
 iAAwG8ehLiSKx6xZdu0j2RH6/xEPqim9oBwwGstkNSFQ+UjSAzVwDP5XAo6uyOHhkS2q
 15KXYNDZV7RG83KFGqBjFqI3IJHfxNJE7V8eu4LNEAehEgkcXZUzZcDz4UO+ks4k4lO2
 HttFVyLY6LVKxVVU6II1hBXsoy33ygy6UOtxtbJ6W+UlYEfrbFBZ3aOVkcElKkKXaHh6
 0fp1m4D7/Ws8NUREElF5bYgAgG4B9bst6EaxaqRNXVBh8YrxVLKyQggVv04HYNqZk7hm rQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3dh8nm5skp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 12 Jan 2022 09:03:03 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 12 Jan
 2022 09:03:01 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 12 Jan 2022 09:03:01 -0800
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id 7ADD53F70A6;
        Wed, 12 Jan 2022 09:02:58 -0800 (PST)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <hkelam@marvell.com>, <gakula@marvell.com>, <sgoutham@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net-next PATCH] octeontx2-pf: Change receive buffer size using ethtool
Date:   Wed, 12 Jan 2022 22:32:55 +0530
Message-ID: <1642006975-17580-1-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: gPHYHV7PC_KOqVhQHVwbtdcCNSsrTc7o
X-Proofpoint-ORIG-GUID: gPHYHV7PC_KOqVhQHVwbtdcCNSsrTc7o
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-12_04,2022-01-11_01,2021-12-02_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ethtool rx-buf-len is for setting receive buffer size,
support setting it via ethtool -G parameter and getting
it via ethtool -g parameter.

Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---

Hi,

This patch is reworked to use ethtool instead
of devlink paramter. Initial patch with devlink
was rejected and Jakub suggested to use ethtool
which was already work in progress by Huawei at
that moment.
https://lore.kernel.org/all/1633454136-14679-1-git-send-email-sbhatta@marvell.com/t/#me83fcb2ce41a2c054370b1ec75172c2f839f57e2

Thanks,
Sundeep

 .../net/ethernet/marvell/octeontx2/nic/otx2_common.c   |  7 +++++++
 .../net/ethernet/marvell/octeontx2/nic/otx2_common.h   |  1 +
 .../net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c  | 18 +++++++++++++++++-
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |  5 +++++
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c   |  3 +++
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
index 61e5281..6d11cb2 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -177,6 +177,7 @@ struct otx2_hw {
 	u16			pool_cnt;
 	u16			rqpool_cnt;
 	u16			sqpool_cnt;
+	u16			rbuf_len;
 
 	/* NPA */
 	u32			stack_pg_ptrs;  /* No of ptrs per stack page */
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
index d85db90..a100296 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -371,6 +371,7 @@ static void otx2_get_ringparam(struct net_device *netdev,
 	ring->rx_pending = qs->rqe_cnt ? qs->rqe_cnt : Q_COUNT(Q_SIZE_256);
 	ring->tx_max_pending = Q_COUNT(Q_SIZE_MAX);
 	ring->tx_pending = qs->sqe_cnt ? qs->sqe_cnt : Q_COUNT(Q_SIZE_4K);
+	kernel_ring->rx_buf_len = pfvf->hw.rbuf_len;
 }
 
 static int otx2_set_ringparam(struct net_device *netdev,
@@ -379,6 +380,7 @@ static int otx2_set_ringparam(struct net_device *netdev,
 			      struct netlink_ext_ack *extack)
 {
 	struct otx2_nic *pfvf = netdev_priv(netdev);
+	u32 rx_buf_len = kernel_ring->rx_buf_len;
 	bool if_up = netif_running(netdev);
 	struct otx2_qset *qs = &pfvf->qset;
 	u32 rx_count, tx_count;
@@ -386,6 +388,15 @@ static int otx2_set_ringparam(struct net_device *netdev,
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
@@ -403,7 +414,7 @@ static int otx2_set_ringparam(struct net_device *netdev,
 			   Q_COUNT(Q_SIZE_4K), Q_COUNT(Q_SIZE_MAX));
 	tx_count = Q_COUNT(Q_SIZE(tx_count, 3));
 
-	if (tx_count == qs->sqe_cnt && rx_count == qs->rqe_cnt)
+	if (tx_count == qs->sqe_cnt && rx_count == qs->rqe_cnt && !rx_buf_len)
 		return 0;
 
 	if (if_up)
@@ -413,6 +424,10 @@ static int otx2_set_ringparam(struct net_device *netdev,
 	qs->sqe_cnt = tx_count;
 	qs->rqe_cnt = rx_count;
 
+	if (rx_buf_len)
+		pfvf->hw.rbuf_len = ALIGN(rx_buf_len, OTX2_ALIGN) +
+				    OTX2_HEAD_ROOM;
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
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 6080ebd..37afffa 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -66,6 +66,8 @@ static int otx2_change_mtu(struct net_device *netdev, int new_mtu)
 		    netdev->mtu, new_mtu);
 	netdev->mtu = new_mtu;
 
+	pf->hw.rbuf_len = 0;
+
 	if (if_up)
 		err = otx2_open(netdev);
 
@@ -1306,6 +1308,9 @@ static int otx2_get_rbuf_size(struct otx2_nic *pf, int mtu)
 	int total_size;
 	int rbuf_size;
 
+	if (pf->hw.rbuf_len)
+		return pf->hw.rbuf_len;
+
 	/* The data transferred by NIX to memory consists of actual packet
 	 * plus additional data which has timestamp and/or EDSA/HIGIG2
 	 * headers if interface is configured in corresponding modes.
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
index 925b74e..3fe4c0a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -438,6 +438,7 @@ static void otx2vf_do_set_rx_mode(struct work_struct *work)
 
 static int otx2vf_change_mtu(struct net_device *netdev, int new_mtu)
 {
+	struct otx2_nic *vf = netdev_priv(netdev);
 	bool if_up = netif_running(netdev);
 	int err = 0;
 
@@ -448,6 +449,8 @@ static int otx2vf_change_mtu(struct net_device *netdev, int new_mtu)
 		    netdev->mtu, new_mtu);
 	netdev->mtu = new_mtu;
 
+	vf->hw.rbuf_len = 0;
+
 	if (if_up)
 		err = otx2vf_open(netdev);
 
-- 
2.7.4

