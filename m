Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 153D52FF59A
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 21:13:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726847AbhAUUNs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 15:13:48 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:43876 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727825AbhAUHzW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 02:55:22 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10L7fgXm026671;
        Wed, 20 Jan 2021 23:54:36 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=B5a17WyU/OZr4U7uGw5QtlPvkgWdSyq5QxGhl+rMTuA=;
 b=Soxt1fL3mOfoNfhITUmsgp1szT0JMzBHOnztffCla4p7n2uv6X7TMqye/ttD7ft9m5Mp
 VLqOzH7fbEQ67ibML86zpmS6yR9GPDAe7oW2CpjVPTrwtW75VfgrnrUmsl/FZN0Ol+28
 QAdI2DZCcro22M457AVnvsGQLi5NuRUKI2cbUu8VA8JrACcBXWK2HF60980b1ndmDY9T
 m1Nr1SDI7zEYumBIJX/kzLnzd5zJHDkXo4AeFak+Z6Css1ftx6VnYaorvW1SeQSfj7zg
 fHeTuCMrt1RaefQXli0t99cHtIJ8WUXqRCZ4Km1I4k46Y2qd/Vy5O07e5Tj347o01kaq 5Q== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 3668p7nchx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 20 Jan 2021 23:54:36 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 20 Jan
 2021 23:54:34 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 20 Jan 2021 23:54:34 -0800
Received: from hyd1soter2.marvell.com (unknown [10.29.37.45])
        by maili.marvell.com (Postfix) with ESMTP id 6177B3F7044;
        Wed, 20 Jan 2021 23:54:31 -0800 (PST)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>, Christina Jacob <cjacob@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>
Subject: [net-next PATCH 6/7] octeontx2-pf: ethtool physical link status
Date:   Thu, 21 Jan 2021 13:23:28 +0530
Message-ID: <1611215609-92301-7-git-send-email-hkelam@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1611215609-92301-1-git-send-email-hkelam@marvell.com>
References: <1611215609-92301-1-git-send-email-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-21_03:2021-01-20,2021-01-21 signatures=0
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
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  | 157 +++++++++++++++++++++
 1 file changed, 157 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
index 9cec341..ef79ecf 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -32,6 +32,7 @@ struct otx2_stat {
 	.index = offsetof(struct otx2_dev_stats, stat) / sizeof(u64), \
 }
 
+#define OTX2_ETHTOOL_SUPPORTED_MODES 0x638CCBF //110001110001100110010111111
 static const struct otx2_stat otx2_dev_stats[] = {
 	OTX2_DEV_STAT(rx_ucast_frames),
 	OTX2_DEV_STAT(rx_bcast_frames),
@@ -992,6 +993,147 @@ end:	mutex_unlock(&mbox->lock);
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
+	int cgx_link_mode[29] = {0,
+		ETHTOOL_LINK_MODE_1000baseX_Full_BIT,
+		ETHTOOL_LINK_MODE_10000baseT_Full_BIT,
+		ETHTOOL_LINK_MODE_10000baseSR_Full_BIT,
+		ETHTOOL_LINK_MODE_10000baseLR_Full_BIT,
+		ETHTOOL_LINK_MODE_10000baseKR_Full_BIT,
+		0,
+		ETHTOOL_LINK_MODE_25000baseSR_Full_BIT,
+		0,
+		0,
+		ETHTOOL_LINK_MODE_25000baseCR_Full_BIT,
+		ETHTOOL_LINK_MODE_25000baseKR_Full_BIT,
+		ETHTOOL_LINK_MODE_40000baseSR4_Full_BIT,
+		ETHTOOL_LINK_MODE_40000baseLR4_Full_BIT,
+		ETHTOOL_LINK_MODE_40000baseCR4_Full_BIT,
+		ETHTOOL_LINK_MODE_40000baseKR4_Full_BIT,
+		0,
+		ETHTOOL_LINK_MODE_50000baseSR_Full_BIT,
+		0,
+		ETHTOOL_LINK_MODE_50000baseLR_ER_FR_Full_BIT,
+		ETHTOOL_LINK_MODE_50000baseCR_Full_BIT,
+		ETHTOOL_LINK_MODE_50000baseKR_Full_BIT,
+		0,
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
@@ -1021,6 +1163,7 @@ static const struct ethtool_ops otx2_ethtool_ops = {
 	.get_ts_info		= otx2_get_ts_info,
 	.get_fecparam		= otx2_get_fecparam,
 	.set_fecparam		= otx2_set_fecparam,
+	.get_link_ksettings     = otx2_get_link_ksettings,
 };
 
 void otx2_set_ethtool_ops(struct net_device *netdev)
@@ -1095,6 +1238,19 @@ static int otx2vf_get_sset_count(struct net_device *netdev, int sset)
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
@@ -1121,6 +1277,7 @@ static const struct ethtool_ops otx2vf_ethtool_ops = {
 	.set_msglevel		= otx2_set_msglevel,
 	.get_pauseparam		= otx2_get_pauseparam,
 	.set_pauseparam		= otx2_set_pauseparam,
+	.get_link_ksettings     = otx2vf_get_link_ksettings,
 };
 
 void otx2vf_set_ethtool_ops(struct net_device *netdev)
-- 
2.7.4

