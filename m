Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B52545964C
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 21:51:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233163AbhKVUyZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 15:54:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:54866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229899AbhKVUyY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Nov 2021 15:54:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6598F60D42;
        Mon, 22 Nov 2021 20:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637614277;
        bh=bvO92IApOuY9qWCVUIWeT2usrA4hePiv6+VOd8aNjvA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NiNZETBYI7DDCinRzvrX6SFobJv2mvHR2upZSdTWSB0OVdz5ggH0JKhkvZKGniPgb
         vBoVIhGGYSFbl4mvjLz89vKX0Yy3P5EV4XTiXtMMlx/wB/EI6gFuhTd/cXfPyTecH7
         326ZAN7JF3OHPwAYrggEekL1IFfH0W2qR5y/S28X21O+tSiREWIg/Geu+yQMw4pJQl
         FZl1A4gxH+7p8TsrsJafvcb+y6lW6TDjPxWh6A1Oymvs2TkB8rgLASiXieAX/3KHTL
         E3Nj+GLwYXJwLYyiNJ9yLairTjDJJjRR2fu0Fltp0qRazS22+JHITIFqkSQjfr0tBz
         fHMMmnlw/Wo6w==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        davem@davemloft.net,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next 1/2] phy: marvell: phy-mvebu-cp110-comphy: add support for 5gbase-r
Date:   Mon, 22 Nov 2021 21:51:10 +0100
Message-Id: <20211122205111.10156-2-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211122205111.10156-1-kabel@kernel.org>
References: <20211122205111.10156-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for PHY_INTERFACE_MODE_5GBASER mode within the Marvell CP110
common PHY driver.

This is currently only supported via SMC calls to TF-A. Legacy support
may be added later, if needed.

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/phy/marvell/phy-mvebu-cp110-comphy.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/phy/marvell/phy-mvebu-cp110-comphy.c b/drivers/phy/marvell/phy-mvebu-cp110-comphy.c
index bbd6f2ad6f24..34672e868a1e 100644
--- a/drivers/phy/marvell/phy-mvebu-cp110-comphy.c
+++ b/drivers/phy/marvell/phy-mvebu-cp110-comphy.c
@@ -141,6 +141,7 @@
 #define COMPHY_FW_SPEED_1250	0
 #define COMPHY_FW_SPEED_3125	2
 #define COMPHY_FW_SPEED_5000	3
+#define COMPHY_FW_SPEED_515625	4
 #define COMPHY_FW_SPEED_103125	6
 #define COMPHY_FW_PORT_OFFSET	8
 #define COMPHY_FW_PORT_MASK	GENMASK(11, 8)
@@ -220,6 +221,7 @@ static const struct mvebu_comphy_conf mvebu_comphy_cp110_modes[] = {
 	ETH_CONF(2, 0, PHY_INTERFACE_MODE_SGMII, 0x1, COMPHY_FW_MODE_SGMII),
 	ETH_CONF(2, 0, PHY_INTERFACE_MODE_2500BASEX, 0x1, COMPHY_FW_MODE_2500BASEX),
 	ETH_CONF(2, 0, PHY_INTERFACE_MODE_RXAUI, 0x1, COMPHY_FW_MODE_RXAUI),
+	ETH_CONF(2, 0, PHY_INTERFACE_MODE_5GBASER, 0x1, COMPHY_FW_MODE_XFI),
 	ETH_CONF(2, 0, PHY_INTERFACE_MODE_10GBASER, 0x1, COMPHY_FW_MODE_XFI),
 	GEN_CONF(2, 0, PHY_MODE_USB_HOST_SS, COMPHY_FW_MODE_USB3H),
 	GEN_CONF(2, 0, PHY_MODE_SATA, COMPHY_FW_MODE_SATA),
@@ -234,6 +236,7 @@ static const struct mvebu_comphy_conf mvebu_comphy_cp110_modes[] = {
 	/* lane 4 */
 	ETH_CONF(4, 0, PHY_INTERFACE_MODE_SGMII, 0x2, COMPHY_FW_MODE_SGMII),
 	ETH_CONF(4, 0, PHY_INTERFACE_MODE_2500BASEX, 0x2, COMPHY_FW_MODE_2500BASEX),
+	ETH_CONF(4, 0, PHY_INTERFACE_MODE_5GBASER, 0x2, COMPHY_FW_MODE_XFI),
 	ETH_CONF(4, 0, PHY_INTERFACE_MODE_10GBASER, 0x2, COMPHY_FW_MODE_XFI),
 	ETH_CONF(4, 0, PHY_INTERFACE_MODE_RXAUI, 0x2, COMPHY_FW_MODE_RXAUI),
 	GEN_CONF(4, 0, PHY_MODE_USB_DEVICE_SS, COMPHY_FW_MODE_USB3D),
@@ -241,6 +244,7 @@ static const struct mvebu_comphy_conf mvebu_comphy_cp110_modes[] = {
 	GEN_CONF(4, 1, PHY_MODE_PCIE, COMPHY_FW_MODE_PCIE),
 	ETH_CONF(4, 1, PHY_INTERFACE_MODE_SGMII, 0x1, COMPHY_FW_MODE_SGMII),
 	ETH_CONF(4, 1, PHY_INTERFACE_MODE_2500BASEX, -1, COMPHY_FW_MODE_2500BASEX),
+	ETH_CONF(4, 1, PHY_INTERFACE_MODE_5GBASER, -1, COMPHY_FW_MODE_XFI),
 	ETH_CONF(4, 1, PHY_INTERFACE_MODE_10GBASER, -1, COMPHY_FW_MODE_XFI),
 	/* lane 5 */
 	ETH_CONF(5, 1, PHY_INTERFACE_MODE_RXAUI, 0x2, COMPHY_FW_MODE_RXAUI),
@@ -790,6 +794,11 @@ static int mvebu_comphy_power_on(struct phy *phy)
 				lane->id);
 			fw_speed = COMPHY_FW_SPEED_3125;
 			break;
+		case PHY_INTERFACE_MODE_5GBASER:
+			dev_dbg(priv->dev, "set lane %d to 5GBASE-R mode\n",
+				lane->id);
+			fw_speed = COMPHY_FW_SPEED_515625;
+			break;
 		case PHY_INTERFACE_MODE_10GBASER:
 			dev_dbg(priv->dev, "set lane %d to 10GBASE-R mode\n",
 				lane->id);
-- 
2.32.0

