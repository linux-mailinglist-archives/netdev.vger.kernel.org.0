Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0ABD3054FD
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 08:50:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234211AbhA0Htz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 02:49:55 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:6486 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229624AbhA0Hre (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 02:47:34 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10R7ddZ7019092;
        Tue, 26 Jan 2021 23:46:52 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=PUysU0htMDnwFEM81zh2w8WgQBHOCuAH6G2iWHIF+1s=;
 b=H3U/MItDXgIuw8UrOgOTE8roVP/FZbtPo4P7wPUn+zxYGvH8Pur/sc2EzqmaK2czNpjt
 rSK1v2q9Vk6eyx70SW0SQZglA92lWNDmoLG66w3e8not9JxIN1yQwu5VU2Gsn7XKnz7a
 SDv6O8Utoba4sL7eNmHwvIrg83QW26QkjrF51RSsVu4f5+xlnkE7f+EsYo6djfg7ZlRM
 VNg1XLCZFLoh5ukSAA/6s78s//6ajzxzLF0C+sz3wbz7FqOApyWshz/Jbn0Iqgj9ar5m
 DmKISQXvuVFRfzfP2YAqSL4N39oTdL+4FILN1HTuNrnRPPq4J3Dm55Xc3f8mulTz2Zem Zw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 368j1uaw79-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 26 Jan 2021 23:46:52 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 26 Jan
 2021 23:46:49 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 26 Jan 2021 23:46:49 -0800
Received: from hyd1soter2.marvell.com (unknown [10.29.37.45])
        by maili.marvell.com (Postfix) with ESMTP id 9E4913F7043;
        Tue, 26 Jan 2021 23:46:46 -0800 (PST)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>, Christina Jacob <cjacob@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>
Subject: [Patch v2 net-next 6/7] octeontx2-pf: ethtool physical link status
Date:   Wed, 27 Jan 2021 13:15:51 +0530
Message-ID: <1611733552-150419-7-git-send-email-hkelam@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1611733552-150419-1-git-send-email-hkelam@marvell.com>
References: <1611733552-150419-1-git-send-email-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-27_03:2021-01-26,2021-01-27 signatures=0
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
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  | 159 +++++++++++++++++++++
 1 file changed, 159 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
index e5b1a57..b99f4bb 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -32,6 +32,8 @@ struct otx2_stat {
 	.index = offsetof(struct otx2_dev_stats, stat) / sizeof(u64), \
 }
 
+#define OTX2_ETHTOOL_SUPPORTED_MODES 0x638CCBF //110001110001100110010111111
+#define OTX2_RESERVED_ETHTOOL_LINK_MODE	0
 static const struct otx2_stat otx2_dev_stats[] = {
 	OTX2_DEV_STAT(rx_ucast_frames),
 	OTX2_DEV_STAT(rx_bcast_frames),
@@ -1034,6 +1036,148 @@ static int otx2_set_fecparam(struct net_device *netdev,
 	return err;
 }
 
+static void otx2_get_fec_info(u64 index, int mode, struct ethtool_link_ksettings
+			      *link_ksettings)
+{
+	switch (index) {
+	case OTX2_FEC_NONE:
+		if (mode)
+			ethtool_link_ksettings_add_link_mode(link_ksettings,
+							     advertising,
+							     FEC_NONE);
+		else
+			ethtool_link_ksettings_add_link_mode(link_ksettings,
+							     supported,
+							     FEC_NONE);
+		break;
+	case OTX2_FEC_BASER:
+		if (mode)
+			ethtool_link_ksettings_add_link_mode(link_ksettings,
+							     advertising,
+							     FEC_BASER);
+		else
+			ethtool_link_ksettings_add_link_mode(link_ksettings,
+							     supported,
+							     FEC_BASER);
+		break;
+	case OTX2_FEC_RS:
+		if (mode)
+			ethtool_link_ksettings_add_link_mode(link_ksettings,
+							     advertising,
+							     FEC_RS);
+		else
+			ethtool_link_ksettings_add_link_mode(link_ksettings,
+							     supported,
+							     FEC_RS);
+		break;
+	case OTX2_FEC_BASER | OTX2_FEC_RS:
+		if (mode) {
+			ethtool_link_ksettings_add_link_mode(link_ksettings,
+							     advertising,
+							     FEC_BASER);
+			ethtool_link_ksettings_add_link_mode(link_ksettings,
+							     advertising,
+							     FEC_RS);
+		} else {
+			ethtool_link_ksettings_add_link_mode(link_ksettings,
+							     supported,
+							     FEC_BASER);
+			ethtool_link_ksettings_add_link_mode(link_ksettings,
+							     supported,
+							     FEC_RS);
+		}
+
+		break;
+	}
+}
+
+static void otx2_get_link_mode_info(u64 index, int mode,
+				    struct ethtool_link_ksettings
+				    *link_ksettings)
+{
+	u64 ethtool_link_mode = 0;
+	int bit_position = 0;
+	u64 link_modes = 0;
+
+	/* CGX link modes to Ethtool link mode mapping */
+	const int cgx_link_mode[29] = {0, /* SGMII  Mode */
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
+	link_modes = index & OTX2_ETHTOOL_SUPPORTED_MODES;
+
+	for (bit_position = 0; link_modes; bit_position++, link_modes >>= 1) {
+		if (!(link_modes & 1))
+			continue;
+
+		if (bit_position ==  0)
+			ethtool_link_mode = 0x3F;
+
+		if (cgx_link_mode[bit_position])
+			ethtool_link_mode |= 1ULL << cgx_link_mode[bit_position];
+
+		if (mode)
+			*link_ksettings->link_modes.advertising |=
+							ethtool_link_mode;
+		else
+			*link_ksettings->link_modes.supported |=
+							ethtool_link_mode;
+	}
+}
+
+static int otx2_get_link_ksettings(struct net_device *netdev,
+				   struct ethtool_link_ksettings *cmd)
+{
+	struct otx2_nic *pfvf = netdev_priv(netdev);
+	struct cgx_fw_data *rsp = NULL;
+	u32 supported = 0;
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
+		supported |= SUPPORTED_Autoneg;
+	ethtool_convert_legacy_u32_to_link_mode(cmd->link_modes.supported,
+						supported);
+	otx2_get_link_mode_info(rsp->fwdata.advertised_link_modes, 1, cmd);
+	otx2_get_fec_info(rsp->fwdata.advertised_fec, 1, cmd);
+
+	otx2_get_link_mode_info(rsp->fwdata.supported_link_modes, 0, cmd);
+	otx2_get_fec_info(rsp->fwdata.supported_fec, 0, cmd);
+
+	return 0;
+}
+
 static const struct ethtool_ops otx2_ethtool_ops = {
 	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
 				     ETHTOOL_COALESCE_MAX_FRAMES,
@@ -1063,6 +1207,7 @@ static const struct ethtool_ops otx2_ethtool_ops = {
 	.get_ts_info		= otx2_get_ts_info,
 	.get_fecparam		= otx2_get_fecparam,
 	.set_fecparam		= otx2_set_fecparam,
+	.get_link_ksettings     = otx2_get_link_ksettings,
 };
 
 void otx2_set_ethtool_ops(struct net_device *netdev)
@@ -1137,6 +1282,19 @@ static int otx2vf_get_sset_count(struct net_device *netdev, int sset)
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
@@ -1163,6 +1321,7 @@ static const struct ethtool_ops otx2vf_ethtool_ops = {
 	.set_msglevel		= otx2_set_msglevel,
 	.get_pauseparam		= otx2_get_pauseparam,
 	.set_pauseparam		= otx2_set_pauseparam,
+	.get_link_ksettings     = otx2vf_get_link_ksettings,
 };
 
 void otx2vf_set_ethtool_ops(struct net_device *netdev)
-- 
2.7.4

