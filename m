Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6F62203A09
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 16:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729311AbgFVOxc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 10:53:32 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:42210 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729294AbgFVOxa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 10:53:30 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05MEZFAn003813;
        Mon, 22 Jun 2020 07:53:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=fOsgOaGZD28nnsuoiwP349L83ynZnVkebhvzIZuFx7U=;
 b=gv+CDbrER736hFPS4Vmo9Ieqt+zdRQU1mH3Kc4tkh838+INTlB1tgd6hdSzBRxd7OPcJ
 EmdI0UgeAyyIXVs2j7CWmg0x2Dp1IdR/xJmHQAOoq91eeERXvfyp62daQwwWVIwwAMDy
 JiR6SCh+dYifmsdm0QrjkR5W6XOYLcyHDamujdtD6Ubrh7+s+y6dcoqSGlWmRnVt3s2Q
 tZuAeb6MbZT8Xu0QYAuJ8gPzv9exPiDpUyDC1wgSxBNL+wFiI1oUzYOskiZWnfVWl0Tc
 /zgPHAi8H8Ks89dhU9DcP0ie2ARc+q+jtds1MIhMUIzCWVO6Kaz4w6X2LN6Rf+MSUqZb vw== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 31shynrhr9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 22 Jun 2020 07:53:28 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 22 Jun
 2020 07:53:27 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 22 Jun
 2020 07:53:26 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 22 Jun 2020 07:53:26 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.39.5])
        by maili.marvell.com (Postfix) with ESMTP id 066E13F703F;
        Mon, 22 Jun 2020 07:53:24 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Dmitry Bogdanov <dbogdanov@marvell.com>,
        "Igor Russkikh" <irusskikh@marvell.com>
Subject: [PATCH net-next 6/6] net: atlantic: A2: phy loopback support
Date:   Mon, 22 Jun 2020 17:53:09 +0300
Message-ID: <20200622145309.455-7-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200622145309.455-1-irusskikh@marvell.com>
References: <20200622145309.455-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-22_08:2020-06-22,2020-06-22 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmitry Bogdanov <dbogdanov@marvell.com>

This patch adds the phy loopback support on A2.

Signed-off-by: Dmitry Bogdanov <dbogdanov@marvell.com>
Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 .../ethernet/aquantia/atlantic/aq_ethtool.c   |  5 ++--
 .../aquantia/atlantic/hw_atl/hw_atl_b0.c      |  2 +-
 .../aquantia/atlantic/hw_atl/hw_atl_b0.h      |  1 +
 .../aquantia/atlantic/hw_atl2/hw_atl2.c       |  1 +
 .../atlantic/hw_atl2/hw_atl2_utils_fw.c       | 23 +++++++++++++++++++
 5 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
index 8225187eeef2..e53ba7bfaf61 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
@@ -836,6 +836,7 @@ static int aq_ethtool_set_priv_flags(struct net_device *ndev, u32 flags)
 	struct aq_nic_s *aq_nic = netdev_priv(ndev);
 	struct aq_nic_cfg_s *cfg;
 	u32 priv_flags;
+	int ret = 0;
 
 	cfg = aq_nic_get_cfg(aq_nic);
 	priv_flags = cfg->priv_flags;
@@ -857,10 +858,10 @@ static int aq_ethtool_set_priv_flags(struct net_device *ndev, u32 flags)
 			dev_open(ndev, NULL);
 		}
 	} else if ((priv_flags ^ flags) & AQ_HW_LOOPBACK_MASK) {
-		aq_nic_set_loopback(aq_nic);
+		ret = aq_nic_set_loopback(aq_nic);
 	}
 
-	return 0;
+	return ret;
 }
 
 const struct ethtool_ops aq_ethtool_ops = {
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
index 8ed6fd845969..b023c3324a59 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
@@ -1556,7 +1556,7 @@ static int hw_atl_b0_hw_vlan_ctrl(struct aq_hw_s *self, bool enable)
 	return aq_hw_err_from_flags(self);
 }
 
-static int hw_atl_b0_set_loopback(struct aq_hw_s *self, u32 mode, bool enable)
+int hw_atl_b0_set_loopback(struct aq_hw_s *self, u32 mode, bool enable)
 {
 	switch (mode) {
 	case AQ_HW_LOOPBACK_DMA_SYS:
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.h b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.h
index bd9a6fb005c9..66d158900141 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.h
@@ -63,6 +63,7 @@ void hw_atl_b0_hw_init_rx_rss_ctrl1(struct aq_hw_s *self);
 int hw_atl_b0_hw_mac_addr_set(struct aq_hw_s *self, u8 *mac_addr);
 
 int hw_atl_b0_set_fc(struct aq_hw_s *self, u32 fc, u32 tc);
+int hw_atl_b0_set_loopback(struct aq_hw_s *self, u32 mode, bool enable);
 
 int hw_atl_b0_hw_start(struct aq_hw_s *self);
 
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c
index c306c26e802b..c65e6daad0e5 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c
@@ -843,5 +843,6 @@ const struct aq_hw_ops hw_atl2_ops = {
 	.hw_get_hw_stats             = hw_atl2_utils_get_hw_stats,
 	.hw_get_fw_version           = hw_atl2_utils_get_fw_version,
 	.hw_set_offload              = hw_atl_b0_hw_offload_set,
+	.hw_set_loopback             = hw_atl_b0_set_loopback,
 	.hw_set_fc                   = hw_atl_b0_set_fc,
 };
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c
index c5d1a1404042..3a9352190816 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c
@@ -427,6 +427,28 @@ static u32 aq_a2_fw_get_flow_control(struct aq_hw_s *self, u32 *fcmode)
 	return 0;
 }
 
+static int aq_a2_fw_set_phyloopback(struct aq_hw_s *self, u32 mode, bool enable)
+{
+	struct link_options_s link_options;
+
+	hw_atl2_shared_buffer_get(self, link_options, link_options);
+
+	switch (mode) {
+	case AQ_HW_LOOPBACK_PHYINT_SYS:
+		link_options.internal_loopback = enable;
+		break;
+	case AQ_HW_LOOPBACK_PHYEXT_SYS:
+		link_options.external_loopback = enable;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	hw_atl2_shared_buffer_write(self, link_options, link_options);
+
+	return hw_atl2_shared_buffer_finish_ack(self);
+}
+
 u32 hw_atl2_utils_get_fw_version(struct aq_hw_s *self)
 {
 	struct version_s version;
@@ -468,4 +490,5 @@ const struct aq_fw_ops aq_a2_fw_ops = {
 	.get_eee_rate       = aq_a2_fw_get_eee_rate,
 	.set_flow_control   = aq_a2_fw_set_flow_control,
 	.get_flow_control   = aq_a2_fw_get_flow_control,
+	.set_phyloopback    = aq_a2_fw_set_phyloopback,
 };
-- 
2.25.1

