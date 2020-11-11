Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C089B2AF496
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 16:18:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbgKKPSH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 10:18:07 -0500
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:63990 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726104AbgKKPSH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 10:18:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1605107886; x=1636643886;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=65Tynn75RgpP8T+yxXaaqSS23is8krJbOCI3Iny+Zzs=;
  b=JbBq4xRTr2EkIJwK9NCaUlk8g11zZlxz+bf0YfegfWEcL6S+PGWKf1ab
   WV7OCrAVeukLgyFG0AdLnQv1M1OcEYXv2nKJf4eSzPjU7oUFAt1rdznAq
   pNX0QkVygpk+6PDAIW1u3MXxmba+Q2Bf877tN6nC48uDBp2D2RLW6VBYI
   f4dUujnu/hLe6J7Tx+VolHmJfSkLXP25lqGwzgVpSyZRDIs0JRb69VM2E
   v5aQJRAotL/Q27LRoCL1xfkBkMh/rk4vjW5t52g5DOL5dSFgWcZBHwQ2j
   TSpi2St2ob3oilLNMEz46RQuRckjqy2VSjj8X8YYECYrk1oxD3VKDO295
   Q==;
IronPort-SDR: P+R7/qioqfqZF8wkHmwNJTWQQ7RIgyM0e5tz1Bmt8VRoQLG/ou/XdsL8afFhYa4z+H7PxvLpwo
 FvthggixE6bCvk8irSMPLni18kPxwr4zF8SCzBE+UEDHX5yfrntDbV/kEKDRQlNYRKQkd5DDhP
 01AcpSbUMAKOAS8gSUR7q+PMIOddZc2vgh1YgJmEyHKR0pJ3LDj/e8OjR5UguVOwLiXbFMLnxc
 Gd8WHHlazzJp06FpHNdslB9HQnd+h3rNDvMnPnJTr91lpRWD0dsG252zLzX+IZU1xsNzlsOq/L
 ul8=
X-IronPort-AV: E=Sophos;i="5.77,469,1596524400"; 
   d="scan'208";a="93292656"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Nov 2020 08:18:06 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 11 Nov 2020 08:18:05 -0700
Received: from mchp-dev-shegelun.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Wed, 11 Nov 2020 08:18:03 -0700
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Antoine Tenart <atenart@kernel.org>,
        Bryan Whitehead <Bryan.Whitehead@microchip.com>
CC:     Steen Hegelund <steen.hegelund@microchip.com>,
        Microchip UNG Driver List <UNGLinuxDriver@microchip.com>,
        John Haechten <John.Haechten@microchip.com>,
        Netdev List <netdev@vger.kernel.org>,
        Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: [net v2] net: phy: mscc: adjust the phy support for PTP and MACsec
Date:   Wed, 11 Nov 2020 16:17:53 +0100
Message-ID: <20201111151753.840364-1-steen.hegelund@microchip.com>
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

History:
v1 -> v2:
  - Added "fixes:" tags to the commit message

Fixes: bb56c016a1257 ("net: phy: mscc: split the driver into separate files")
Fixes: ab2bf93393571 ("net: phy: mscc: 1588 block initialization")
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

