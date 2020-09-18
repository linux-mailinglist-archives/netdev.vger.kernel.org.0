Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2EC62704DA
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 21:15:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726438AbgIRTPS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 15:15:18 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:48714 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726344AbgIRTPN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 15:15:13 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 08IJF5cB043776;
        Fri, 18 Sep 2020 14:15:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1600456505;
        bh=9O1VHv+tQ8CeuoeX59nCI2lzZxErqiar7lWemFEzsE0=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=kU9yp4o+bn3531AXTJb0zEhYdmdShdqP/0cNQLmwXG7WhFDDIYPzhh9dZcNmXHXSW
         MBMl2gMY7ITCJN9apKvNRY8TRp7qz9VGwDF4JKzTdgX0udahPgKT0cIKrCLh0OfFPJ
         NYUUai4ez6V7P0pkkQaxepdr0CnMC09KRwwLdkRM=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 08IJF499062206
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 18 Sep 2020 14:15:05 -0500
Received: from DLEE112.ent.ti.com (157.170.170.23) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 18
 Sep 2020 14:15:05 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 18 Sep 2020 14:15:05 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 08IJF5GT040005;
        Fri, 18 Sep 2020 14:15:05 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <davem@davemloft.net>, <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>
CC:     <mkubecek@suse.cz>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH net-next v2 3/3] net: phy: dp83822: Update the fiber advertisement for speed
Date:   Fri, 18 Sep 2020 14:14:53 -0500
Message-ID: <20200918191453.13914-4-dmurphy@ti.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200918191453.13914-1-dmurphy@ti.com>
References: <20200918191453.13914-1-dmurphy@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update the fiber advertisement for speed and duplex modes with the
100base-FX full and half linkmode entries.

Signed-off-by: Dan Murphy <dmurphy@ti.com>
---
 drivers/net/phy/dp83822.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/dp83822.c b/drivers/net/phy/dp83822.c
index 732c8bec7452..c162c9551bd1 100644
--- a/drivers/net/phy/dp83822.c
+++ b/drivers/net/phy/dp83822.c
@@ -110,9 +110,8 @@
 #define DP83822_RX_ER_SHIFT	8
 
 #define MII_DP83822_FIBER_ADVERTISE    (ADVERTISED_TP | ADVERTISED_MII | \
-					ADVERTISED_FIBRE | ADVERTISED_BNC |  \
-					ADVERTISED_Pause | ADVERTISED_Asym_Pause | \
-					ADVERTISED_100baseT_Full)
+					ADVERTISED_FIBRE | \
+					ADVERTISED_Pause | ADVERTISED_Asym_Pause)
 
 struct dp83822_private {
 	bool fx_signal_det_low;
@@ -406,6 +405,14 @@ static int dp83822_config_init(struct phy_device *phydev)
 				 phydev->supported);
 		linkmode_set_bit(ETHTOOL_LINK_MODE_FIBRE_BIT,
 				 phydev->advertising);
+		linkmode_set_bit(ETHTOOL_LINK_MODE_100baseFX_Full_BIT,
+				 phydev->supported);
+		linkmode_set_bit(ETHTOOL_LINK_MODE_100baseFX_Half_BIT,
+				 phydev->supported);
+		linkmode_set_bit(ETHTOOL_LINK_MODE_100baseFX_Full_BIT,
+				 phydev->advertising);
+		linkmode_set_bit(ETHTOOL_LINK_MODE_100baseFX_Half_BIT,
+				 phydev->advertising);
 
 		/* Auto neg is not supported in fiber mode */
 		bmcr = phy_read(phydev, MII_BMCR);
-- 
2.28.0

