Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE17309D63
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 16:24:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231843AbhAaOPR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jan 2021 09:15:17 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:4589 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231875AbhAaN3J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jan 2021 08:29:09 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10VD7Nxf023047;
        Sun, 31 Jan 2021 05:11:34 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=N6krvuQ9Ff6zj+S7+gkde0zCq4jwEc+77p1nDtJ7j/o=;
 b=XwIo65AAefllDXr1yuvT/Iq05itivihHOZIwBmsgtiT1jRX0I7mC2uM01m+tf0Vce8G1
 SxNKWudHOTGbnBHIgf4cm9sNopyzPaWnHHHcU6Hr1kv1I5dmvEAcG31vQB02oxtgXc0Q
 nnIL9rs+0I14whQYoduOul4RxSaMWLfMAlJlI2V19mtt63WeGJIPkkYOGtS8LL7NGWug
 qLBPzbHgmKpOt4X0f9/gADbuUKy+aP1TkU6BOgcWZ7E2IkpxK7UoSVh2+YMfSX754wup
 XAeAwR1qaTP9LQf+f1Qt35fgqEKoNLyiIOmTXSKs0vqZmxotVpdYjSt/gDxNhdlD29lZ Hg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 36d5psss69-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 31 Jan 2021 05:11:34 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 31 Jan
 2021 05:11:33 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 31 Jan 2021 05:11:33 -0800
Received: from hyd1soter2.marvell.com (unknown [10.29.37.45])
        by maili.marvell.com (Postfix) with ESMTP id C00583F7040;
        Sun, 31 Jan 2021 05:11:29 -0800 (PST)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>,
        <willemdebruijn.kernel@gmail.com>, <andrew@lunn.ch>,
        <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, <jerinj@marvell.com>, <sbhatta@marvell.com>,
        <hkelam@marvell.com>
Subject: [Patch v3 net-next 6/7] octeontx2-pf: ethtool physical link status
Date:   Sun, 31 Jan 2021 18:41:04 +0530
Message-ID: <1612098665-187767-7-git-send-email-hkelam@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1612098665-187767-1-git-send-email-hkelam@marvell.com>
References: <1612098665-187767-1-git-send-email-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-01-31_04:2021-01-29,2021-01-31 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christina Jacob <cjacob@marvell.com>

Register get_link_ksettings callback to get link status information
from the driver. As virtual function (vf) shares same physical link
same API is used for both the drivers and for loop back drivers
simply returns the fixed values as its does not have physical link.

ethtool eth3
Settings for eth3:
        Supported ports: [ ]
        Supported link modes:   10baseT/Half 10baseT/Full
                                100baseT/Half 100baseT/Full
                                1000baseT/Half 1000baseT/Full
                                10000baseKR/Full
                                1000baseX/Full
        Supports auto-negotiation: No
        Supported FEC modes: BaseR RS
        Advertised link modes:  Not reported
        Advertised pause frame use: No
        Advertised auto-negotiation: No
        Advertised FEC modes: None

ethtool lbk0
Settings for lbk0:
	Speed: 100000Mb/s
        Duplex: Full

Signed-off-by: Christina Jacob <cjacob@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
---
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  | 151 +++++++++++++++++++++
 1 file changed, 151 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
index e5b1a57..d637815 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -14,6 +14,7 @@
 #include <linux/etherdevice.h>
 #include <linux/log2.h>
 #include <linux/net_tstamp.h>
+#include <linux/linkmode.h>
 
 #include "otx2_common.h"
 #include "otx2_ptp.h"
@@ -32,6 +33,24 @@ struct otx2_stat {
 	.index = offsetof(struct otx2_dev_stats, stat) / sizeof(u64), \
 }
 
+/* Physical link config */
+#define OTX2_ETHTOOL_SUPPORTED_MODES 0x638CCBF //110001110001100110010111111
+#define OTX2_RESERVED_ETHTOOL_LINK_MODE	0
+
+static const int otx2_sgmii_features_array[6] = {
+	ETHTOOL_LINK_MODE_10baseT_Half_BIT,
+	ETHTOOL_LINK_MODE_10baseT_Full_BIT,
+	ETHTOOL_LINK_MODE_100baseT_Half_BIT,
+	ETHTOOL_LINK_MODE_100baseT_Full_BIT,
+	ETHTOOL_LINK_MODE_1000baseT_Half_BIT,
+	ETHTOOL_LINK_MODE_1000baseT_Full_BIT,
+};
+
+enum link_mode {
+	OTX2_MODE_SUPPORTED,
+	OTX2_MODE_ADVERTISED
+};
+
 static const struct otx2_stat otx2_dev_stats[] = {
 	OTX2_DEV_STAT(rx_ucast_frames),
 	OTX2_DEV_STAT(rx_bcast_frames),
@@ -1034,6 +1053,123 @@ static int otx2_set_fecparam(struct net_device *netdev,
 	return err;
 }
 
+static void otx2_get_fec_info(u64 index, int req_mode,
+			      struct ethtool_link_ksettings *link_ksettings)
+{
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(otx2_fec_modes) = { 0, };
+
+	switch (index) {
+	case OTX2_FEC_NONE:
+		linkmode_set_bit(ETHTOOL_LINK_MODE_FEC_NONE_BIT, otx2_fec_modes);
+		break;
+	case OTX2_FEC_BASER:
+		linkmode_set_bit(ETHTOOL_LINK_MODE_FEC_BASER_BIT, otx2_fec_modes);
+		break;
+	case OTX2_FEC_RS:
+		linkmode_set_bit(ETHTOOL_LINK_MODE_FEC_RS_BIT, otx2_fec_modes);
+		break;
+	case OTX2_FEC_BASER | OTX2_FEC_RS:
+		linkmode_set_bit(ETHTOOL_LINK_MODE_FEC_BASER_BIT, otx2_fec_modes);
+		linkmode_set_bit(ETHTOOL_LINK_MODE_FEC_RS_BIT, otx2_fec_modes);
+		break;
+	}
+
+	/* Add fec modes to existing modes */
+	if (req_mode == OTX2_MODE_ADVERTISED)
+		linkmode_or(link_ksettings->link_modes.advertising,
+			    link_ksettings->link_modes.advertising,
+			    otx2_fec_modes);
+	else
+		linkmode_or(link_ksettings->link_modes.supported,
+			    link_ksettings->link_modes.supported,
+			    otx2_fec_modes);
+}
+
+static void otx2_get_link_mode_info(u64 link_mode_bmap,
+				    bool req_mode,
+				    struct ethtool_link_ksettings
+				    *link_ksettings)
+{
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(otx2_link_modes) = { 0, };
+	u8 bit;
+
+	/* CGX link modes to Ethtool link mode mapping */
+	const int cgx_link_mode[27] = {
+		0, /* SGMII  Mode */
+		ETHTOOL_LINK_MODE_1000baseX_Full_BIT,
+		ETHTOOL_LINK_MODE_10000baseT_Full_BIT,
+		ETHTOOL_LINK_MODE_10000baseSR_Full_BIT,
+		ETHTOOL_LINK_MODE_10000baseLR_Full_BIT,
+		ETHTOOL_LINK_MODE_10000baseKR_Full_BIT,
+		OTX2_RESERVED_ETHTOOL_LINK_MODE,
+		ETHTOOL_LINK_MODE_25000baseSR_Full_BIT,
+		OTX2_RESERVED_ETHTOOL_LINK_MODE,
+		OTX2_RESERVED_ETHTOOL_LINK_MODE,
+		ETHTOOL_LINK_MODE_25000baseCR_Full_BIT,
+		ETHTOOL_LINK_MODE_25000baseKR_Full_BIT,
+		ETHTOOL_LINK_MODE_40000baseSR4_Full_BIT,
+		ETHTOOL_LINK_MODE_40000baseLR4_Full_BIT,
+		ETHTOOL_LINK_MODE_40000baseCR4_Full_BIT,
+		ETHTOOL_LINK_MODE_40000baseKR4_Full_BIT,
+		OTX2_RESERVED_ETHTOOL_LINK_MODE,
+		ETHTOOL_LINK_MODE_50000baseSR_Full_BIT,
+		OTX2_RESERVED_ETHTOOL_LINK_MODE,
+		ETHTOOL_LINK_MODE_50000baseLR_ER_FR_Full_BIT,
+		ETHTOOL_LINK_MODE_50000baseCR_Full_BIT,
+		ETHTOOL_LINK_MODE_50000baseKR_Full_BIT,
+		OTX2_RESERVED_ETHTOOL_LINK_MODE,
+		ETHTOOL_LINK_MODE_100000baseSR4_Full_BIT,
+		ETHTOOL_LINK_MODE_100000baseLR4_ER4_Full_BIT,
+		ETHTOOL_LINK_MODE_100000baseCR4_Full_BIT,
+		ETHTOOL_LINK_MODE_100000baseKR4_Full_BIT
+	};
+
+	link_mode_bmap = link_mode_bmap & OTX2_ETHTOOL_SUPPORTED_MODES;
+
+	for_each_set_bit(bit, (unsigned long *)&link_mode_bmap, 27) {
+		/* SGMII mode is set */
+		if (bit  ==  0)
+			linkmode_set_bit_array(otx2_sgmii_features_array,
+					       ARRAY_SIZE(otx2_sgmii_features_array),
+					       otx2_link_modes);
+		else
+			linkmode_set_bit(cgx_link_mode[bit], otx2_link_modes);
+	}
+
+	if (req_mode == OTX2_MODE_ADVERTISED)
+		linkmode_copy(link_ksettings->link_modes.advertising, otx2_link_modes);
+	else
+		linkmode_copy(link_ksettings->link_modes.supported, otx2_link_modes);
+}
+
+static int otx2_get_link_ksettings(struct net_device *netdev,
+				   struct ethtool_link_ksettings *cmd)
+{
+	struct otx2_nic *pfvf = netdev_priv(netdev);
+	struct cgx_fw_data *rsp = NULL;
+
+	cmd->base.duplex  = pfvf->linfo.full_duplex;
+	cmd->base.speed   = pfvf->linfo.speed;
+	cmd->base.autoneg = pfvf->linfo.an;
+
+	rsp = otx2_get_fwdata(pfvf);
+	if (IS_ERR(rsp))
+		return PTR_ERR(rsp);
+
+	if (rsp->fwdata.supported_an)
+		ethtool_link_ksettings_add_link_mode(cmd,
+						     supported,
+						     Autoneg);
+
+	otx2_get_link_mode_info(rsp->fwdata.advertised_link_modes, OTX2_MODE_ADVERTISED, cmd);
+	otx2_get_fec_info(rsp->fwdata.advertised_fec, OTX2_MODE_ADVERTISED, cmd);
+
+	otx2_get_link_mode_info(rsp->fwdata.supported_link_modes, OTX2_MODE_SUPPORTED, cmd);
+	otx2_get_fec_info(rsp->fwdata.supported_fec, OTX2_MODE_SUPPORTED, cmd);
+
+	return 0;
+}
+
 static const struct ethtool_ops otx2_ethtool_ops = {
 	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
 				     ETHTOOL_COALESCE_MAX_FRAMES,
@@ -1063,6 +1199,7 @@ static const struct ethtool_ops otx2_ethtool_ops = {
 	.get_ts_info		= otx2_get_ts_info,
 	.get_fecparam		= otx2_get_fecparam,
 	.set_fecparam		= otx2_set_fecparam,
+	.get_link_ksettings     = otx2_get_link_ksettings,
 };
 
 void otx2_set_ethtool_ops(struct net_device *netdev)
@@ -1137,6 +1274,19 @@ static int otx2vf_get_sset_count(struct net_device *netdev, int sset)
 	return otx2_n_dev_stats + otx2_n_drv_stats + qstats_count + 1;
 }
 
+static int otx2vf_get_link_ksettings(struct net_device *netdev,
+				     struct ethtool_link_ksettings *cmd)
+{
+	struct otx2_nic *pfvf = netdev_priv(netdev);
+
+	if (is_otx2_lbkvf(pfvf->pdev)) {
+		cmd->base.duplex = DUPLEX_FULL;
+		cmd->base.speed = SPEED_100000;
+	} else {
+		return	otx2_get_link_ksettings(netdev, cmd);
+	}
+	return 0;
+}
 static const struct ethtool_ops otx2vf_ethtool_ops = {
 	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
 				     ETHTOOL_COALESCE_MAX_FRAMES,
@@ -1163,6 +1313,7 @@ static const struct ethtool_ops otx2vf_ethtool_ops = {
 	.set_msglevel		= otx2_set_msglevel,
 	.get_pauseparam		= otx2_get_pauseparam,
 	.set_pauseparam		= otx2_set_pauseparam,
+	.get_link_ksettings     = otx2vf_get_link_ksettings,
 };
 
 void otx2vf_set_ethtool_ops(struct net_device *netdev)
-- 
2.7.4

