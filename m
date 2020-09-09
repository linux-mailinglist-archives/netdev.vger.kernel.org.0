Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCEC7262BF1
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 11:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729005AbgIIJeg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 05:34:36 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:7972 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbgIIJeb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 05:34:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1599644070; x=1631180070;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=LAfgB1jqP412cl4V+7EuYf+QjFKubW9+J+4ICIUJxqA=;
  b=QWNcBJbgIbHbLAs0Scc+24+aJxrT8Uz1A9lXfQk47SyINM1cP2ZC9+pk
   ahagg+ViLPHpXHROp8WbTg0ceWYMvf1JmIwa8RtHppNfzkka0dkGpoW8G
   ay5nAcm1NedjxPuUs6BI/Xvsmi2NtVnbJuCoX6c0rkbpqjVmxT83VNtcg
   AlE+iXLIIspOKTZb1Bzk4Cb7t4Kc9IIkpFg4bHi989LduzW5j/OK8xL0c
   TTSLDgRA5TXPIQnj9A8AH2K/dNmtIDzb5CaYZyK6/Ul/vUk19sZi5No14
   xVk59oXA4T9HA5sGr5LnMVghO2VpzpgwRsv0PS/p3/dQlQeg10YJqg1UI
   A==;
IronPort-SDR: 2UjhJNsuBkIP+KE9133pQ3IFo7Zg0g3v+/KKxLeMKrAoK0Yi8bBo2fwJvSG9Orqv1boJsYK3j6
 gbtP8J7xPkJfPf86YicExLMKayhWdhcsJ+YxQi0+itgciusdxWfP95bi5vaoxMMtrAK+9qkugw
 VMUtrQc+4usFPYePW5BqOQRX6X4NfGIDOsXxND82pm0LFTqtfV8CTHdunEjr4RHNTVSlTeg0N3
 lpqKnABIRbKqmSOxgM0Q1SB7r4gMhiwoo/RsphAV4KzvlYpU/PUuXtsW/PZtGVhUbY+IfnLKpr
 jkM=
X-IronPort-AV: E=Sophos;i="5.76,409,1592895600"; 
   d="scan'208";a="91109851"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Sep 2020 02:34:29 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 9 Sep 2020 02:34:04 -0700
Received: from training-HP-280-G1-MT-PC.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Wed, 9 Sep 2020 02:33:59 -0700
From:   Divya Koppera <Divya.Koppera@microchip.com>
To:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>, <marex@denx.de>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>
Subject: [PATCH v1 net-next] net: phy: mchp: Add support for LAN8814 QUAD PHY
Date:   Wed, 9 Sep 2020 15:04:19 +0530
Message-ID: <20200909093419.32102-1-Divya.Koppera@microchip.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

LAN8814 is a low-power, quad-port triple-speed (10BASE-T/100BASETX/1000BASE-T)
Ethernet physical layer transceiver (PHY). It supports transmission and
reception of data on standard CAT-5, as well as CAT-5e and CAT-6, unshielded
twisted pair (UTP) cables.

LAN8814 supports industry-standard QSGMII (Quad Serial Gigabit Media
Independent Interface) and Q-USGMII (Quad Universal Serial Gigabit Media
Independent Interface) providing chip-to-chip connection to four Gigabit
Ethernet MACs using a single serialized link (differential pair) in each
direction.

The LAN8814 SKU supports high-accuracy timestamping functions to
support IEEE-1588 solutions using Microchip Ethernet switches, as well as
customer solutions based on SoCs and FPGAs.

The LAN8804 SKU has same features as that of LAN8814 SKU except that it does
not support 1588, SyncE, or Q-USGMII with PCH/MCH.

This adds support for 10BASE-T, 100BASE-TX, and 1000BASE-T,
QSGMII link with the MAC.

Signed-off-by: Divya Koppera<divya.koppera@microchip.com>
---
 drivers/net/phy/micrel.c   | 16 ++++++++++++++++
 include/linux/micrel_phy.h |  1 +
 2 files changed, 17 insertions(+)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 3fe552675dd2..9f60865587ea 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -1314,6 +1314,21 @@ static struct phy_driver ksphy_driver[] = {
 	.get_stats	= kszphy_get_stats,
 	.suspend	= genphy_suspend,
 	.resume		= kszphy_resume,
+}, {
+	.phy_id		= PHY_ID_LAN8814,
+	.phy_id_mask	= MICREL_PHY_ID_MASK,
+	.name		= "Microchip INDY Gigabit Quad PHY",
+	.driver_data	= &ksz9021_type,
+	.probe		= kszphy_probe,
+	.get_features	= ksz9031_get_features,
+	.config_init	= ksz9031_config_init,
+	.soft_reset	= genphy_soft_reset,
+	.read_status	= ksz9031_read_status,
+	.get_sset_count	= kszphy_get_sset_count,
+	.get_strings	= kszphy_get_strings,
+	.get_stats	= kszphy_get_stats,
+	.suspend	= genphy_suspend,
+	.resume		= kszphy_resume,
 }, {
 	.phy_id		= PHY_ID_KSZ9131,
 	.phy_id_mask	= MICREL_PHY_ID_MASK,
@@ -1387,6 +1402,7 @@ static struct mdio_device_id __maybe_unused micrel_tbl[] = {
 	{ PHY_ID_KSZ8081, MICREL_PHY_ID_MASK },
 	{ PHY_ID_KSZ8873MLL, MICREL_PHY_ID_MASK },
 	{ PHY_ID_KSZ886X, MICREL_PHY_ID_MASK },
+	{ PHY_ID_LAN8814, MICREL_PHY_ID_MASK },
 	{ }
 };
 
diff --git a/include/linux/micrel_phy.h b/include/linux/micrel_phy.h
index 75f880c25bb8..416ee6dd2574 100644
--- a/include/linux/micrel_phy.h
+++ b/include/linux/micrel_phy.h
@@ -27,6 +27,7 @@
 #define PHY_ID_KSZ8061		0x00221570
 #define PHY_ID_KSZ9031		0x00221620
 #define PHY_ID_KSZ9131		0x00221640
+#define PHY_ID_LAN8814		0x00221660
 
 #define PHY_ID_KSZ886X		0x00221430
 #define PHY_ID_KSZ8863		0x00221435
-- 
2.17.1

