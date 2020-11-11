Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7433D2AEE32
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 10:55:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727296AbgKKJz2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 04:55:28 -0500
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:57902 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726755AbgKKJz1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 04:55:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1605088526; x=1636624526;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=23idBd3O0JKpB50W0Okk4fGadp4AYDO8EO9WHPr9aNE=;
  b=Cw7TBZ9qQfpyX+fMlOErjQeKRiHRZzUWTzOXBm6wwORK3a19gges5yR0
   9Ew0lgfmmhCV+dSanGqWW+Ddb9N3Qgqp8L3/R0WGFv9YfADxHRUG5LHTV
   Y3MKj70nT0wgNXlgf5rUi0yRXOPIc0d2m76xtj88ggr31XTWG4rNqPAdS
   HYKRmhWHET8XmO6INj6GbXbjg8TdZMFjSPBE99AZRs9BsophH1r3dHzEY
   71v/2S5M9lLGsczUjugoc7GlbYgID6F4zmOJ31vBzhAAsDlAJh7MTa0r6
   h4qMibahJVZE8YxP8m5lUk1gC463JdbpYTq3SoooLCZrJbOONxmMBUMWi
   w==;
IronPort-SDR: bP8keLyxeGHJX6FMIO5a/y66iHo6CbPbtDf55MwnaFy8XdjhjHEwHAmLt3p2ywJNvtOhp1uana
 jSQvQEVzFPt8TXiBOVCnkqELaGw5oLWW/oPMDIQjAX01TEPQ8/iz5+M/ldbN3az1JtDgE/OSLE
 S50tkiTu86ECS6+g5vYJr1utN5GiJ8A36iUHHhtut0phad3a0VPhmBO6GBRYgpn+Nkx52EOCwd
 UBlC4w+jGM40sPrunPEMAXFK2dagAsluqIc/v9t9qjmvuFwZktZS6uqX49sP0JMenGPP+CwCJP
 Vg8=
X-IronPort-AV: E=Sophos;i="5.77,469,1596524400"; 
   d="scan'208";a="93267840"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Nov 2020 02:55:25 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 11 Nov 2020 02:55:24 -0700
Received: from mchp-dev-shegelun.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Wed, 11 Nov 2020 02:55:22 -0700
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Antoine Tenart <atenart@kernel.org>,
        Quentin Schulz <quentin.schulz@bootlin.com>,
        "Bryan Whitehead" <Bryan.Whitehead@microchip.com>
CC:     Steen Hegelund <steen.hegelund@microchip.com>,
        Microchip UNG Driver List <UNGLinuxDriver@microchip.com>,
        John Haechten <John.Haechten@microchip.com>,
        Netdev List <netdev@vger.kernel.org>,
        Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: [net] net: phy: mscc: adjust the phy support for PTP and MACsec
Date:   Wed, 11 Nov 2020 10:55:11 +0100
Message-ID: <20201111095511.671539-1-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MSCC PHYs selected for PTP and MACSec was not correct

- PTP
    - Add VSC8572 and VSC8574

- MACsec
    - Removed VSC8575

The relevant datasheets can be found here:
  - VSC8572: https://www.microchip.com/wwwproducts/en/VSC8572
  - VSC8574: https://www.microchip.com/wwwproducts/en/VSC8574
  - VSC8575: https://www.microchip.com/wwwproducts/en/VSC8575

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 drivers/net/phy/mscc/mscc_macsec.c | 1 -
 drivers/net/phy/mscc/mscc_ptp.c    | 2 ++
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/mscc/mscc_macsec.c b/drivers/net/phy/mscc/mscc_macsec.c
index 1d4c012194e9..72292bf6c51c 100644
--- a/drivers/net/phy/mscc/mscc_macsec.c
+++ b/drivers/net/phy/mscc/mscc_macsec.c
@@ -981,7 +981,6 @@ int vsc8584_macsec_init(struct phy_device *phydev)

 	switch (phydev->phy_id & phydev->drv->phy_id_mask) {
 	case PHY_ID_VSC856X:
-	case PHY_ID_VSC8575:
 	case PHY_ID_VSC8582:
 	case PHY_ID_VSC8584:
 		INIT_LIST_HEAD(&vsc8531->macsec_flows);
diff --git a/drivers/net/phy/mscc/mscc_ptp.c b/drivers/net/phy/mscc/mscc_ptp.c
index b97ee79f3cdf..f0537299c441 100644
--- a/drivers/net/phy/mscc/mscc_ptp.c
+++ b/drivers/net/phy/mscc/mscc_ptp.c
@@ -1510,6 +1510,8 @@ void vsc8584_config_ts_intr(struct phy_device *phydev)
 int vsc8584_ptp_init(struct phy_device *phydev)
 {
 	switch (phydev->phy_id & phydev->drv->phy_id_mask) {
+	case PHY_ID_VSC8572:
+	case PHY_ID_VSC8574:
 	case PHY_ID_VSC8575:
 	case PHY_ID_VSC8582:
 	case PHY_ID_VSC8584:
--
2.29.2

