Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B90F1DE1AF
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 10:20:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729152AbgEVIUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 04:20:17 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:43246 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728839AbgEVIUM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 04:20:12 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04M8FoDo019591;
        Fri, 22 May 2020 01:20:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=Ljw+kj6hqr72C4AGSF5aAH/KQgQCA2S+DXuoDlkWCpA=;
 b=HfbLM0C5GXxnekN8QH/vY7lIvKHDNyxbgkYiQrlCuEX1jEHQ6jNHbqO1JQm3VB2gDvvD
 u3q2+qGdp3AdmgZS969A8zWSb6bA6K76NQ73ZInYrtzNEuvUANlaP2fGfue4fq12Q4yZ
 JIXbHT+zF4HeYad5d8u5eonA2b1a221UIs2rcNj0IK+je/RGl1F8cUiLBcxugb1OBMmV
 9pVs0voU7Cm/utmZiHw/t/RvfJ+MiTbb/RhIQMfKuP6HVgSHBdFzLR5exgmwQ+k+mKc2
 tKTt5xA38lfOorz9Yd7yfhUtW8M19EtOkgoW0OlWRUBMo//5DoiFAQPqw0yC7vVnb1BP fQ== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 312fpphewn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 22 May 2020 01:20:10 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 22 May
 2020 01:20:07 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 22 May 2020 01:20:08 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.39.5])
        by maili.marvell.com (Postfix) with ESMTP id 5BFCD3F704A;
        Fri, 22 May 2020 01:20:06 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH v2 net-next 06/12] net: atlantic: make TCVEC2RING accept nic_cfg
Date:   Fri, 22 May 2020 11:19:42 +0300
Message-ID: <20200522081948.167-7-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200522081948.167-1-irusskikh@marvell.com>
References: <20200522081948.167-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-22_04:2020-05-21,2020-05-22 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Starovoytov <mstarovoitov@marvell.com>

This patch updates TCVEC2RING to accept nic_cfg, which is needed to be able
to use it from hw_atl.
The name is updated to reflect the changes.

Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c |  2 +-
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c     |  9 +++++----
 drivers/net/ethernet/aquantia/atlantic/aq_nic.h     | 13 +++++++------
 drivers/net/ethernet/aquantia/atlantic/aq_vec.c     |  3 ++-
 4 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
index 440a7d129848..90a52a4b2d48 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
@@ -254,7 +254,7 @@ static void aq_ethtool_get_strings(struct net_device *ndev,
 					snprintf(p, ETH_GSTRING_LEN,
 					     aq_ethtool_queue_stat_names[si],
 					     tc_string,
-					     AQ_NIC_TCVEC2RING(nic, tc, i));
+					     AQ_NIC_CFG_TCVEC2RING(cfg, tc, i));
 					p += ETH_GSTRING_LEN;
 				}
 			}
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index 851f22aadea1..b2ef0115c293 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -701,15 +701,16 @@ unsigned int aq_nic_map_skb(struct aq_nic_s *self, struct sk_buff *skb,
 
 int aq_nic_xmit(struct aq_nic_s *self, struct sk_buff *skb)
 {
-	unsigned int vec = skb->queue_mapping % self->aq_nic_cfg.vecs;
-	unsigned int tc = skb->queue_mapping / self->aq_nic_cfg.vecs;
+	struct aq_nic_cfg_s *cfg = aq_nic_get_cfg(self);
+	unsigned int vec = skb->queue_mapping % cfg->vecs;
+	unsigned int tc = skb->queue_mapping / cfg->vecs;
 	struct aq_ring_s *ring = NULL;
 	unsigned int frags = 0U;
 	int err = NETDEV_TX_OK;
 
 	frags = skb_shinfo(skb)->nr_frags + 1;
 
-	ring = self->aq_ring_tx[AQ_NIC_TCVEC2RING(self, tc, vec)];
+	ring = self->aq_ring_tx[AQ_NIC_CFG_TCVEC2RING(cfg, tc, vec)];
 
 	if (frags > AQ_CFG_SKB_FRAGS_MAX) {
 		dev_kfree_skb_any(skb);
@@ -718,7 +719,7 @@ int aq_nic_xmit(struct aq_nic_s *self, struct sk_buff *skb)
 
 	aq_ring_update_queue_state(ring);
 
-	if (self->aq_nic_cfg.priv_flags & BIT(AQ_HW_LOOPBACK_DMA_NET)) {
+	if (cfg->priv_flags & BIT(AQ_HW_LOOPBACK_DMA_NET)) {
 		err = NETDEV_TX_BUSY;
 		goto err_exit;
 	}
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.h b/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
index 29e129411945..6cc2ebfe6a44 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
@@ -81,15 +81,16 @@ struct aq_nic_cfg_s {
 #define AQ_NIC_WOL_MODES        (WAKE_MAGIC |\
 				 WAKE_PHY)
 
-#define AQ_NIC_RING_PER_TC(_NIC_) \
-	(((_NIC_)->aq_nic_cfg.tc_mode == AQ_TC_MODE_4TCS) ? 8 : 4)
+#define AQ_NIC_CFG_RING_PER_TC(_NIC_CFG_) \
+	(((_NIC_CFG_)->tc_mode == AQ_TC_MODE_4TCS) ? 8 : 4)
 
-#define AQ_NIC_TCVEC2RING(_NIC_, _TC_, _VEC_) \
-	((_TC_) * AQ_NIC_RING_PER_TC(_NIC_) + (_VEC_))
+#define AQ_NIC_CFG_TCVEC2RING(_NIC_CFG_, _TC_, _VEC_) \
+	((_TC_) * AQ_NIC_CFG_RING_PER_TC(_NIC_CFG_) + (_VEC_))
 
 #define AQ_NIC_RING2QMAP(_NIC_, _ID_) \
-	((_ID_) / AQ_NIC_RING_PER_TC(_NIC_) * (_NIC_)->aq_vecs + \
-	((_ID_) % AQ_NIC_RING_PER_TC(_NIC_)))
+	((_ID_) / AQ_NIC_CFG_RING_PER_TC(&(_NIC_)->aq_nic_cfg) * \
+		(_NIC_)->aq_vecs + \
+	((_ID_) % AQ_NIC_CFG_RING_PER_TC(&(_NIC_)->aq_nic_cfg)))
 
 struct aq_hw_rx_fl2 {
 	struct aq_rx_filter_vlan aq_vlans[AQ_VLAN_MAX_FILTERS];
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_vec.c b/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
index 41826c10700f..d1d43c8ce400 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
@@ -135,7 +135,8 @@ int aq_vec_ring_alloc(struct aq_vec_s *self, struct aq_nic_s *aq_nic,
 	int err = 0;
 
 	for (i = 0; i < aq_nic_cfg->tcs; ++i) {
-		unsigned int idx_ring = AQ_NIC_TCVEC2RING(aq_nic, i, idx);
+		const unsigned int idx_ring = AQ_NIC_CFG_TCVEC2RING(aq_nic_cfg,
+								    i, idx);
 
 		ring = aq_ring_tx_alloc(&self->ring[i][AQ_VEC_TX_ID], aq_nic,
 					idx_ring, aq_nic_cfg);
-- 
2.25.1

