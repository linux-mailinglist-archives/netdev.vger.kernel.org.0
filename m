Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B41F4A9E24
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 18:46:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377195AbiBDRp7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 12:45:59 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:13143 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376994AbiBDRpw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 12:45:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1643996752; x=1675532752;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pn0zfKzE9zHZ0zQ3z4icWzVmwmuWSSChtsFs1RRNnm0=;
  b=c8wmK99Zbjf1zpZhKW7cjNJLWFVr1K/roVlrMUOnL956OBSoGdX/aNb8
   teV+xajTQWPd9owZ+M9fsxFuTTGRSAz/SHuFE2IQzmcG6yJmtqyEVBrXN
   Xhjxm2ZPBQ3bJXKdXreouPAl/XSjJ1iDIFAumM/o1rMmgsO7TUYueW8mK
   r1AtwPH/dcqXrpwIlbBWUFZdzdf/tQjd6uzZZRAuyQkbKv7k/ynBPstDf
   45NSRUuc1jaXJNeOxRwU1ofF1hDpC7/XhLy4kRTxgobiWNHG0cg6tdxFS
   YEsrDesJ4sPGy+1N3gAFoiDT6NeUZSnyTIs8sAt1EReqFypNlgfQpNdvN
   w==;
IronPort-SDR: Mnu0D3/n7leD16bLLL5cgLTIit1yGh+VPTdADn/hD0KQ0dxYoHXA4+ftZm4u6Yc51P/82oTOEj
 LJ2fCaKiPHW6ukg6Di79zFe/ylmz90qVAdoK5KueK2SmiD0zPeqGN4HwsTq0mXBbrEilEF8F4l
 QhE+OS66j2bijk0KkQUqMG9NBKNHQHSfvCDiWJa4Rcf90AMO2HxJiyHbe5YT8hKp/puN7RKYOH
 8Ty7zFgavZfYxLi4nfqzGMhfHg8sCPa0whrXQ9S0dGRXaATAdBcObHAZM54jEzAXEsefJln6vD
 2ZwbFc5HLOUqQRvXe7Ee2qa3
X-IronPort-AV: E=Sophos;i="5.88,343,1635231600"; 
   d="scan'208";a="144936439"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Feb 2022 10:45:51 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 4 Feb 2022 10:45:51 -0700
Received: from CHE-LT-I21427LX.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 4 Feb 2022 10:45:45 -0700
From:   Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
To:     <andrew@lunn.ch>, <netdev@vger.kernel.org>, <olteanv@gmail.com>,
        <robh+dt@kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <Woojung.Huh@microchip.com>,
        <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <devicetree@vger.kernel.org>
Subject: [PATCH v7 net-next 07/10] net: dsa: microchip: add support for ethtool port counters
Date:   Fri, 4 Feb 2022 23:14:57 +0530
Message-ID: <20220204174500.72814-8-prasanna.vengateshan@microchip.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220204174500.72814-1-prasanna.vengateshan@microchip.com>
References: <20220204174500.72814-1-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added support for get_eth_**_stats() (phy/mac/ctrl) and
get_stats64()

Reused the KSZ common APIs for get_ethtool_stats() & get_sset_count()
along with relevant lan937x hooks for KSZ common layer and added
support for get_strings()

Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
---
 drivers/net/dsa/microchip/lan937x_main.c | 165 +++++++++++++++++++++++
 1 file changed, 165 insertions(+)

diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
index 4a58f2a2929c..756272003172 100644
--- a/drivers/net/dsa/microchip/lan937x_main.c
+++ b/drivers/net/dsa/microchip/lan937x_main.c
@@ -45,6 +45,21 @@ static int lan937x_phy_write16(struct dsa_switch *ds, int addr, int reg,
 	return lan937x_internal_phy_write(dev, addr, reg, val);
 }
 
+static void lan937x_get_strings(struct dsa_switch *ds, int port, u32 stringset,
+				uint8_t *buf)
+{
+	struct ksz_device *dev = ds->priv;
+	int i;
+
+	if (stringset != ETH_SS_STATS)
+		return;
+
+	for (i = 0; i < dev->mib_cnt; i++) {
+		memcpy(buf + i * ETH_GSTRING_LEN, lan937x_mib_names[i].string,
+		       ETH_GSTRING_LEN);
+	}
+}
+
 static void lan937x_port_stp_state_set(struct dsa_switch *ds, int port,
 				       u8 state)
 {
@@ -339,12 +354,162 @@ static void lan937x_phylink_get_caps(struct dsa_switch *ds, int port,
 	}
 }
 
+static void lan937x_get_eth_phy_stats(struct dsa_switch *ds, int port,
+				      struct ethtool_eth_phy_stats *phy_stats)
+{
+	struct ksz_device *dev = ds->priv;
+	struct ksz_port_mib *mib = &dev->ports[port].mib;
+	u64 *cnt;
+
+	mutex_lock(&mib->cnt_mutex);
+
+	cnt = &mib->counters[lan937x_mib_rx_sym_err];
+	lan937x_r_mib_pkt(dev, port, lan937x_mib_rx_sym_err, NULL, cnt);
+
+	phy_stats->SymbolErrorDuringCarrier = *cnt;
+
+	mutex_unlock(&mib->cnt_mutex);
+}
+
+static void lan937x_get_eth_mac_stats(struct dsa_switch *ds, int port,
+				      struct ethtool_eth_mac_stats *mac_stats)
+{
+	struct ksz_device *dev = ds->priv;
+	struct ksz_port_mib *mib = &dev->ports[port].mib;
+	u64 *ctr = mib->counters;
+
+	mutex_lock(&mib->cnt_mutex);
+
+	while (mib->cnt_ptr < dev->mib_cnt) {
+		lan937x_r_mib_pkt(dev, port, mib->cnt_ptr,
+				  NULL, &mib->counters[mib->cnt_ptr]);
+		++mib->cnt_ptr;
+	}
+
+	mac_stats->FramesTransmittedOK = ctr[lan937x_mib_tx_mcast] +
+					 ctr[lan937x_mib_tx_bcast] +
+					 ctr[lan937x_mib_tx_ucast] +
+					 ctr[lan937x_mib_tx_pause];
+
+	mac_stats->SingleCollisionFrames = ctr[lan937x_mib_tx_single_col];
+	mac_stats->MultipleCollisionFrames = ctr[lan937x_mib_tx_mult_col];
+
+	mac_stats->FramesReceivedOK = ctr[lan937x_mib_rx_mcast] +
+				      ctr[lan937x_mib_rx_bcast] +
+				      ctr[lan937x_mib_rx_ucast] +
+				      ctr[lan937x_mib_rx_pause];
+
+	mac_stats->FrameCheckSequenceErrors = ctr[lan937x_mib_rx_crc_err];
+	mac_stats->AlignmentErrors = ctr[lan937x_mib_rx_align_err];
+	mac_stats->OctetsTransmittedOK = ctr[lan937x_mib_tx_total];
+	mac_stats->FramesWithDeferredXmissions = ctr[lan937x_mib_tx_deferred];
+	mac_stats->LateCollisions = ctr[lan937x_mib_tx_late_col];
+	mac_stats->FramesAbortedDueToXSColls = ctr[lan937x_mib_tx_exc_col];
+	mac_stats->FramesLostDueToIntMACXmitError = ctr[lan937x_mib_tx_discard];
+
+	mac_stats->OctetsReceivedOK = ctr[lan937x_mib_rx_total];
+	mac_stats->FramesLostDueToIntMACRcvError = ctr[lan937x_mib_rx_discard];
+	mac_stats->MulticastFramesXmittedOK = ctr[lan937x_mib_tx_mcast];
+	mac_stats->BroadcastFramesXmittedOK = ctr[lan937x_mib_tx_bcast];
+
+	mac_stats->MulticastFramesReceivedOK = ctr[lan937x_mib_rx_mcast];
+	mac_stats->BroadcastFramesReceivedOK = ctr[lan937x_mib_rx_bcast];
+	mac_stats->InRangeLengthErrors = ctr[lan937x_mib_rx_fragments];
+
+	mib->cnt_ptr = 0;
+	mutex_unlock(&mib->cnt_mutex);
+}
+
+static void lan937x_get_eth_ctrl_stats(struct dsa_switch *ds, int port,
+				       struct ethtool_eth_ctrl_stats *ctrl_sts)
+{
+	struct ksz_device *dev = ds->priv;
+	struct ksz_port_mib *mib = &dev->ports[port].mib;
+	u64 *cnt;
+
+	mutex_lock(&mib->cnt_mutex);
+
+	cnt = &mib->counters[lan937x_mib_rx_pause];
+	lan937x_r_mib_pkt(dev, port, lan937x_mib_rx_pause, NULL, cnt);
+	ctrl_sts->MACControlFramesReceived = *cnt;
+
+	cnt = &mib->counters[lan937x_mib_tx_pause];
+	lan937x_r_mib_pkt(dev, port, lan937x_mib_tx_pause, NULL, cnt);
+	ctrl_sts->MACControlFramesTransmitted = *cnt;
+
+	mutex_unlock(&mib->cnt_mutex);
+}
+
+static void lan937x_get_stats64(struct dsa_switch *ds, int port,
+				struct rtnl_link_stats64 *s)
+{
+	struct ksz_device *dev = ds->priv;
+	struct ksz_port_mib *mib = &dev->ports[port].mib;
+	u64 *ctr = mib->counters;
+
+	mutex_lock(&mib->cnt_mutex);
+
+	while (mib->cnt_ptr < dev->mib_cnt) {
+		lan937x_r_mib_pkt(dev, port, mib->cnt_ptr,
+				  NULL, &mib->counters[mib->cnt_ptr]);
+		++mib->cnt_ptr;
+	}
+
+	s->rx_packets = ctr[lan937x_mib_rx_mcast] +
+			ctr[lan937x_mib_rx_bcast] +
+			ctr[lan937x_mib_rx_ucast] +
+			ctr[lan937x_mib_rx_pause];
+
+	s->tx_packets = ctr[lan937x_mib_tx_mcast] +
+			ctr[lan937x_mib_tx_bcast] +
+			ctr[lan937x_mib_tx_ucast] +
+			ctr[lan937x_mib_tx_pause];
+
+	s->rx_bytes = ctr[lan937x_mib_rx_total];
+	s->tx_bytes = ctr[lan937x_mib_tx_total];
+
+	s->rx_errors = ctr[lan937x_mib_rx_fragments] +
+		       ctr[lan937x_mib_rx_jabbers] +
+		       ctr[lan937x_mib_rx_sym_err] +
+		       ctr[lan937x_mib_rx_align_err] +
+		       ctr[lan937x_mib_rx_crc_err];
+
+	s->tx_errors = ctr[lan937x_mib_tx_exc_col] +
+		       ctr[lan937x_mib_tx_late_col];
+
+	s->rx_dropped = ctr[lan937x_mib_rx_discard];
+	s->tx_dropped = ctr[lan937x_mib_tx_discard];
+	s->multicast = ctr[lan937x_mib_rx_mcast];
+
+	s->collisions = ctr[lan937x_mib_tx_late_col] +
+			ctr[lan937x_mib_tx_single_col] +
+			ctr[lan937x_mib_tx_mult_col];
+
+	s->rx_length_errors = ctr[lan937x_mib_rx_fragments] +
+			      ctr[lan937x_mib_rx_jabbers];
+
+	s->rx_crc_errors = ctr[lan937x_mib_rx_crc_err];
+	s->rx_frame_errors = ctr[lan937x_mib_rx_align_err];
+	s->tx_aborted_errors = ctr[lan937x_mib_tx_exc_col];
+	s->tx_window_errors = ctr[lan937x_mib_tx_late_col];
+
+	mib->cnt_ptr = 0;
+	mutex_unlock(&mib->cnt_mutex);
+}
+
 const struct dsa_switch_ops lan937x_switch_ops = {
 	.get_tag_protocol = lan937x_get_tag_protocol,
 	.setup = lan937x_setup,
 	.phy_read = lan937x_phy_read16,
 	.phy_write = lan937x_phy_write16,
 	.port_enable = ksz_enable_port,
+	.get_strings = lan937x_get_strings,
+	.get_ethtool_stats = ksz_get_ethtool_stats,
+	.get_sset_count = ksz_sset_count,
+	.get_eth_ctrl_stats = lan937x_get_eth_ctrl_stats,
+	.get_eth_mac_stats = lan937x_get_eth_mac_stats,
+	.get_eth_phy_stats = lan937x_get_eth_phy_stats,
+	.get_stats64 = lan937x_get_stats64,
 	.port_bridge_join = ksz_port_bridge_join,
 	.port_bridge_leave = ksz_port_bridge_leave,
 	.port_stp_state_set = lan937x_port_stp_state_set,
-- 
2.30.2

