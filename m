Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7661C1DB581
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 15:48:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726870AbgETNr6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 09:47:58 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:9752 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726439AbgETNrz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 09:47:55 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04KDeVfx003293;
        Wed, 20 May 2020 06:47:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=XMXA7UEEFFjbzOqns4JU0g6ZOP7m4XA15sY6js8Fxvw=;
 b=qDcs2BN0MB+AaL3Y9rMVgmqNc/L3A6WJCSwRCVDsAscuQ5zc/PJPbm80/Fok7Gq+cY6n
 zAaxqTIsrvSRnOff1MXAJYvfHbjMKLUNUMK4J4Lwa4jvGL5pZeVDM1I4iWjFx4axnOey
 Bhuckp0vyGqMlkTnk7GmSdVGnNAsic4hV1kAvmjygKfILk0mzHka9++inkkPryhzoQeg
 DrT+2htKROlIT3y+o4dP/o7C7FmQZ7i1LEyKZ/lRD+O2Gr0iJ9XlSQufjQqVbret4XVF
 E/w8CkJqcOnFIrb2rWD8fY5h+2B5i+1U+iERpKxNZ0LTBb7WlBRLZItl8YWevod7fQze UA== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 312dhqs5a5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 20 May 2020 06:47:55 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 20 May
 2020 06:47:53 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 20 May
 2020 06:47:52 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 20 May 2020 06:47:52 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.39.5])
        by maili.marvell.com (Postfix) with ESMTP id 434DF3F7041;
        Wed, 20 May 2020 06:47:51 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH net-next 06/12] net: atlantic: make TCVEC2RING accept nic_cfg
Date:   Wed, 20 May 2020 16:47:28 +0300
Message-ID: <20200520134734.2014-7-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200520134734.2014-1-irusskikh@marvell.com>
References: <20200520134734.2014-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-20_09:2020-05-20,2020-05-20 signatures=0
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
index 88021baf65fb..1346197c0b01 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -705,15 +705,16 @@ unsigned int aq_nic_map_skb(struct aq_nic_s *self, struct sk_buff *skb,
 
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
@@ -722,7 +723,7 @@ int aq_nic_xmit(struct aq_nic_s *self, struct sk_buff *skb)
 
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

