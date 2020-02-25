Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47AAB16BDB2
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 10:42:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730111AbgBYJl5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 04:41:57 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:55684 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729317AbgBYJl5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 04:41:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=d3VDUs9GECL3V7Id9j1fk72SoO2qfr/Dzvti38P06AQ=; b=pWKjtiSBO4vK2BJ1qSte9upRW2
        blbcnFqZrka33f8Smc2cQ8EUmFoDXOUV8Jm8NT0LFSCKMTroYL/KOjjCVvrV99RAQWF0CvLFft1+W
        IDc3BTIgR0J49TlWl5eQCjy4BZAlDkPK+K1QYb34rNa2MnemPKTFcDB5tI9othXZOrSWreScyu7qH
        5ASukZDNR9QvsvtxOPXyq4AlnO4Vy5hDT3fYpJJoiRYTrBMLMADnjnW6wiQ/4dIqAeXMnG+FSuv9X
        /IBkd7c71AqIitzgWYavkstoE4UFFWhUKDgxEShu+Taab9Q27F/PT1KdAAyOURy2Su4Tx2MJooqQE
        yFRV5sOA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2002:4e20:1eda:1:222:68ff:fe15:37dd]:58916 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j6WgF-0008PK-GB; Tue, 25 Feb 2020 09:39:08 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j6WgB-0000TB-95; Tue, 25 Feb 2020 09:39:03 +0000
In-Reply-To: <20200225093703.GS25745@shell.armlinux.org.uk>
References: <20200225093703.GS25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Felix Fietkau <nbd@nbd.name>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        John Crispin <john@phrozen.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Jose Abreu <joabreu@synopsys.com>,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>, netdev@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 4/8] net: axienet: use resolved link config in
 mac_link_up()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1j6WgB-0000TB-95@rmk-PC.armlinux.org.uk>
Date:   Tue, 25 Feb 2020 09:39:03 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the Xilinx AXI ethernet driver to use the finalised link
parameters in mac_link_up() rather than the parameters in mac_config().

Tested-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 38 +++++++++----------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 197740781157..c2f4c5ca2e80 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1440,6 +1440,22 @@ static void axienet_mac_an_restart(struct phylink_config *config)
 
 static void axienet_mac_config(struct phylink_config *config, unsigned int mode,
 			       const struct phylink_link_state *state)
+{
+	/* nothing meaningful to do */
+}
+
+static void axienet_mac_link_down(struct phylink_config *config,
+				  unsigned int mode,
+				  phy_interface_t interface)
+{
+	/* nothing meaningful to do */
+}
+
+static void axienet_mac_link_up(struct phylink_config *config,
+				struct phy_device *phy,
+				unsigned int mode, phy_interface_t interface,
+				int speed, int duplex,
+				bool tx_pause, bool rx_pause)
 {
 	struct net_device *ndev = to_net_dev(config->dev);
 	struct axienet_local *lp = netdev_priv(ndev);
@@ -1448,7 +1464,7 @@ static void axienet_mac_config(struct phylink_config *config, unsigned int mode,
 	emmc_reg = axienet_ior(lp, XAE_EMMC_OFFSET);
 	emmc_reg &= ~XAE_EMMC_LINKSPEED_MASK;
 
-	switch (state->speed) {
+	switch (speed) {
 	case SPEED_1000:
 		emmc_reg |= XAE_EMMC_LINKSPD_1000;
 		break;
@@ -1467,33 +1483,17 @@ static void axienet_mac_config(struct phylink_config *config, unsigned int mode,
 	axienet_iow(lp, XAE_EMMC_OFFSET, emmc_reg);
 
 	fcc_reg = axienet_ior(lp, XAE_FCC_OFFSET);
-	if (state->pause & MLO_PAUSE_TX)
+	if (tx_pause)
 		fcc_reg |= XAE_FCC_FCTX_MASK;
 	else
 		fcc_reg &= ~XAE_FCC_FCTX_MASK;
-	if (state->pause & MLO_PAUSE_RX)
+	if (rx_pause)
 		fcc_reg |= XAE_FCC_FCRX_MASK;
 	else
 		fcc_reg &= ~XAE_FCC_FCRX_MASK;
 	axienet_iow(lp, XAE_FCC_OFFSET, fcc_reg);
 }
 
-static void axienet_mac_link_down(struct phylink_config *config,
-				  unsigned int mode,
-				  phy_interface_t interface)
-{
-	/* nothing meaningful to do */
-}
-
-static void axienet_mac_link_up(struct phylink_config *config,
-				struct phy_device *phy,
-				unsigned int mode, phy_interface_t interface,
-				int speed, int duplex,
-				bool tx_pause, bool rx_pause)
-{
-	/* nothing meaningful to do */
-}
-
 static const struct phylink_mac_ops axienet_phylink_ops = {
 	.validate = axienet_validate,
 	.mac_pcs_get_state = axienet_mac_pcs_get_state,
-- 
2.20.1

