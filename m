Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 706814EEBF5
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 13:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232608AbiDALEl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 07:04:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345296AbiDALEk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 07:04:40 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F256D26F202;
        Fri,  1 Apr 2022 04:02:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1648810971; x=1680346971;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iY2I1fkfLIGc5unC9i73TumxPpp4nrqcgFalw/9zoPo=;
  b=YQtyYyArBdwLLr2eT10XfJw1OXFW2lKBWuhT+5ELtqo9B2qpNDybNx5m
   cPUPpJn71Fe8fT1SJ9PG2k4gbHpiEoD3/WAKdhaoceePgTLMv5VN5qKly
   Q5rJYMFS2jgvTvYnwT5nluJRSvHSlvEeRWCYVa1RFkQ3Q4GFKbFuNs9rG
   1mGb9jTg0z8j0lbozg1yVrfn/iBbfkM1hOF9kqDRUxBK0v7oOk5ldoRez
   MsnHnudHpSvnJwZgozVSiLh3dRyAwtcjIC8qhZVrKQPQjn6GMBHSqrf6i
   apOz7wdOC7dDmSodxIGwXieSNRj6iqULikBnZ57aKAoOrqngUTCfeS89H
   A==;
X-IronPort-AV: E=Sophos;i="5.90,227,1643698800"; 
   d="scan'208";a="158520196"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Apr 2022 04:02:50 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 1 Apr 2022 04:02:50 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 1 Apr 2022 04:02:47 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <Divya.Koppera@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <richardcochran@gmail.com>,
        <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net v2 2/3] net: phy: micrel: Remove latency from driver
Date:   Fri, 1 Apr 2022 13:05:21 +0200
Message-ID: <20220401110522.3418258-3-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220401110522.3418258-1-horatiu.vultur@microchip.com>
References: <20220401110522.3418258-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Based on the discussions here[1], the PHY driver is the wrong place
to set the latencies, therefore remove them.

[1] https://lkml.org/lkml/2022/3/4/325

Fixes: ece19502834d84 ("net: phy: micrel: 1588 support for LAN8814 phy")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 drivers/net/phy/micrel.c | 102 +--------------------------------------
 1 file changed, 1 insertion(+), 101 deletions(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 19b11e896460..a873df07ad24 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -99,15 +99,6 @@
 #define PTP_TIMESTAMP_EN_PDREQ_			BIT(2)
 #define PTP_TIMESTAMP_EN_PDRES_			BIT(3)
 
-#define PTP_RX_LATENCY_1000			0x0224
-#define PTP_TX_LATENCY_1000			0x0225
-
-#define PTP_RX_LATENCY_100			0x0222
-#define PTP_TX_LATENCY_100			0x0223
-
-#define PTP_RX_LATENCY_10			0x0220
-#define PTP_TX_LATENCY_10			0x0221
-
 #define PTP_TX_PARSE_L2_ADDR_EN			0x0284
 #define PTP_RX_PARSE_L2_ADDR_EN			0x0244
 
@@ -268,15 +259,6 @@ struct lan8814_ptp_rx_ts {
 	u16 seq_id;
 };
 
-struct kszphy_latencies {
-	u16 rx_10;
-	u16 tx_10;
-	u16 rx_100;
-	u16 tx_100;
-	u16 rx_1000;
-	u16 tx_1000;
-};
-
 struct kszphy_ptp_priv {
 	struct mii_timestamper mii_ts;
 	struct phy_device *phydev;
@@ -296,7 +278,6 @@ struct kszphy_ptp_priv {
 
 struct kszphy_priv {
 	struct kszphy_ptp_priv ptp_priv;
-	struct kszphy_latencies latencies;
 	const struct kszphy_type *type;
 	int led_mode;
 	bool rmii_ref_clk_sel;
@@ -304,14 +285,6 @@ struct kszphy_priv {
 	u64 stats[ARRAY_SIZE(kszphy_hw_stats)];
 };
 
-static struct kszphy_latencies lan8814_latencies = {
-	.rx_10		= 0x22AA,
-	.tx_10		= 0x2E4A,
-	.rx_100		= 0x092A,
-	.tx_100		= 0x02C1,
-	.rx_1000	= 0x01AD,
-	.tx_1000	= 0x00C9,
-};
 static const struct kszphy_type ksz8021_type = {
 	.led_mode_reg		= MII_KSZPHY_CTRL_2,
 	.has_broadcast_disable	= true,
@@ -2618,55 +2591,6 @@ static int lan8814_ptp_probe_once(struct phy_device *phydev)
 	return 0;
 }
 
-static int lan8814_read_status(struct phy_device *phydev)
-{
-	struct kszphy_priv *priv = phydev->priv;
-	struct kszphy_latencies *latencies = &priv->latencies;
-	int err;
-	int regval;
-
-	err = genphy_read_status(phydev);
-	if (err)
-		return err;
-
-	switch (phydev->speed) {
-	case SPEED_1000:
-		lanphy_write_page_reg(phydev, 5, PTP_RX_LATENCY_1000,
-				      latencies->rx_1000);
-		lanphy_write_page_reg(phydev, 5, PTP_TX_LATENCY_1000,
-				      latencies->tx_1000);
-		break;
-	case SPEED_100:
-		lanphy_write_page_reg(phydev, 5, PTP_RX_LATENCY_100,
-				      latencies->rx_100);
-		lanphy_write_page_reg(phydev, 5, PTP_TX_LATENCY_100,
-				      latencies->tx_100);
-		break;
-	case SPEED_10:
-		lanphy_write_page_reg(phydev, 5, PTP_RX_LATENCY_10,
-				      latencies->rx_10);
-		lanphy_write_page_reg(phydev, 5, PTP_TX_LATENCY_10,
-				      latencies->tx_10);
-		break;
-	default:
-		break;
-	}
-
-	/* Make sure the PHY is not broken. Read idle error count,
-	 * and reset the PHY if it is maxed out.
-	 */
-	regval = phy_read(phydev, MII_STAT1000);
-	if ((regval & 0xFF) == 0xFF) {
-		phy_init_hw(phydev);
-		phydev->link = 0;
-		if (phydev->drv->config_intr && phy_interrupt_is_valid(phydev))
-			phydev->drv->config_intr(phydev);
-		return genphy_config_aneg(phydev);
-	}
-
-	return 0;
-}
-
 static int lan8814_config_init(struct phy_device *phydev)
 {
 	int val;
@@ -2690,27 +2614,6 @@ static int lan8814_config_init(struct phy_device *phydev)
 	return 0;
 }
 
-static void lan8814_parse_latency(struct phy_device *phydev)
-{
-	const struct device_node *np = phydev->mdio.dev.of_node;
-	struct kszphy_priv *priv = phydev->priv;
-	struct kszphy_latencies *latency = &priv->latencies;
-	u32 val;
-
-	if (!of_property_read_u32(np, "lan8814,latency_rx_10", &val))
-		latency->rx_10 = val;
-	if (!of_property_read_u32(np, "lan8814,latency_tx_10", &val))
-		latency->tx_10 = val;
-	if (!of_property_read_u32(np, "lan8814,latency_rx_100", &val))
-		latency->rx_100 = val;
-	if (!of_property_read_u32(np, "lan8814,latency_tx_100", &val))
-		latency->tx_100 = val;
-	if (!of_property_read_u32(np, "lan8814,latency_rx_1000", &val))
-		latency->rx_1000 = val;
-	if (!of_property_read_u32(np, "lan8814,latency_tx_1000", &val))
-		latency->tx_1000 = val;
-}
-
 static int lan8814_probe(struct phy_device *phydev)
 {
 	const struct device_node *np = phydev->mdio.dev.of_node;
@@ -2724,8 +2627,6 @@ static int lan8814_probe(struct phy_device *phydev)
 
 	priv->led_mode = -1;
 
-	priv->latencies = lan8814_latencies;
-
 	phydev->priv = priv;
 
 	if (!IS_ENABLED(CONFIG_PTP_1588_CLOCK) ||
@@ -2746,7 +2647,6 @@ static int lan8814_probe(struct phy_device *phydev)
 			return err;
 	}
 
-	lan8814_parse_latency(phydev);
 	lan8814_ptp_init(phydev);
 
 	return 0;
@@ -2928,7 +2828,7 @@ static struct phy_driver ksphy_driver[] = {
 	.config_init	= lan8814_config_init,
 	.probe		= lan8814_probe,
 	.soft_reset	= genphy_soft_reset,
-	.read_status	= lan8814_read_status,
+	.read_status	= ksz9031_read_status,
 	.get_sset_count	= kszphy_get_sset_count,
 	.get_strings	= kszphy_get_strings,
 	.get_stats	= kszphy_get_stats,
-- 
2.33.0

