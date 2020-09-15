Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C2FD26ABA9
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 20:20:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728003AbgIOSTO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 14:19:14 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:42972 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727683AbgIOSR4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 14:17:56 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 08FIHUmx119199;
        Tue, 15 Sep 2020 13:17:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1600193850;
        bh=9O1VHv+tQ8CeuoeX59nCI2lzZxErqiar7lWemFEzsE0=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=mVb7bLo4kf6CG7xewsdoFINJY0ppfqGe5j4qeuhs3G9MxmPfzGB8p8hbWqVmMYYKA
         2DvV1ymyHOtAWJlFNMrbrnbDVluc6kQww2wknO5AOMu4TD9FxU3Rx7DiNQSFV000Gs
         d5YpaCRnZyKkGGzsiyTrYdyHPQ/FOYgKJmLNc+kc=
Received: from DFLE111.ent.ti.com (dfle111.ent.ti.com [10.64.6.32])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 08FIHUw5123020
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 15 Sep 2020 13:17:30 -0500
Received: from DFLE104.ent.ti.com (10.64.6.25) by DFLE111.ent.ti.com
 (10.64.6.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 15
 Sep 2020 13:17:30 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE104.ent.ti.com
 (10.64.6.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 15 Sep 2020 13:17:30 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 08FIHUqu130526;
        Tue, 15 Sep 2020 13:17:30 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <davem@davemloft.net>, <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>
CC:     <mkubecek@suse.cz>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH net-next 3/3] net: phy: dp83822: Update the fiber advertisement for speed
Date:   Tue, 15 Sep 2020 13:17:08 -0500
Message-ID: <20200915181708.25842-4-dmurphy@ti.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200915181708.25842-1-dmurphy@ti.com>
References: <20200915181708.25842-1-dmurphy@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
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

