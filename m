Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21362732CB
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 17:33:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387489AbfGXPdA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 11:33:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:55834 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727589AbfGXPdA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jul 2019 11:33:00 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 228B4B0E2;
        Wed, 24 Jul 2019 15:32:58 +0000 (UTC)
From:   Andreas Schwab <schwab@suse.de>
To:     netdev@vger.kernel.org
Subject: [PATCH] net: phy: mscc: initialize stats array
CC:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
X-Yow:  I wonder if there's anything GOOD on tonight?
Date:   Wed, 24 Jul 2019 17:32:57 +0200
Message-ID: <mvmh87bih1y.fsf@suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.2.90 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The memory allocated for the stats array may contain arbitrary data.

Signed-off-by: Andreas Schwab <schwab@suse.de>
---
 drivers/net/phy/mscc.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/phy/mscc.c b/drivers/net/phy/mscc.c
index 28676af97b42..645d354ffb48 100644
--- a/drivers/net/phy/mscc.c
+++ b/drivers/net/phy/mscc.c
@@ -2226,8 +2226,8 @@ static int vsc8514_probe(struct phy_device *phydev)
 	vsc8531->supp_led_modes = VSC85XX_SUPP_LED_MODES;
 	vsc8531->hw_stats = vsc85xx_hw_stats;
 	vsc8531->nstats = ARRAY_SIZE(vsc85xx_hw_stats);
-	vsc8531->stats = devm_kmalloc_array(&phydev->mdio.dev, vsc8531->nstats,
-					    sizeof(u64), GFP_KERNEL);
+	vsc8531->stats = devm_kcalloc(&phydev->mdio.dev, vsc8531->nstats,
+				      sizeof(u64), GFP_KERNEL);
 	if (!vsc8531->stats)
 		return -ENOMEM;
 
@@ -2251,8 +2251,8 @@ static int vsc8574_probe(struct phy_device *phydev)
 	vsc8531->supp_led_modes = VSC8584_SUPP_LED_MODES;
 	vsc8531->hw_stats = vsc8584_hw_stats;
 	vsc8531->nstats = ARRAY_SIZE(vsc8584_hw_stats);
-	vsc8531->stats = devm_kmalloc_array(&phydev->mdio.dev, vsc8531->nstats,
-					    sizeof(u64), GFP_KERNEL);
+	vsc8531->stats = devm_kcalloc(&phydev->mdio.dev, vsc8531->nstats,
+				      sizeof(u64), GFP_KERNEL);
 	if (!vsc8531->stats)
 		return -ENOMEM;
 
@@ -2281,8 +2281,8 @@ static int vsc8584_probe(struct phy_device *phydev)
 	vsc8531->supp_led_modes = VSC8584_SUPP_LED_MODES;
 	vsc8531->hw_stats = vsc8584_hw_stats;
 	vsc8531->nstats = ARRAY_SIZE(vsc8584_hw_stats);
-	vsc8531->stats = devm_kmalloc_array(&phydev->mdio.dev, vsc8531->nstats,
-					    sizeof(u64), GFP_KERNEL);
+	vsc8531->stats = devm_kcalloc(&phydev->mdio.dev, vsc8531->nstats,
+				      sizeof(u64), GFP_KERNEL);
 	if (!vsc8531->stats)
 		return -ENOMEM;
 
@@ -2311,8 +2311,8 @@ static int vsc85xx_probe(struct phy_device *phydev)
 	vsc8531->supp_led_modes = VSC85XX_SUPP_LED_MODES;
 	vsc8531->hw_stats = vsc85xx_hw_stats;
 	vsc8531->nstats = ARRAY_SIZE(vsc85xx_hw_stats);
-	vsc8531->stats = devm_kmalloc_array(&phydev->mdio.dev, vsc8531->nstats,
-					    sizeof(u64), GFP_KERNEL);
+	vsc8531->stats = devm_kcalloc(&phydev->mdio.dev, vsc8531->nstats,
+				      sizeof(u64), GFP_KERNEL);
 	if (!vsc8531->stats)
 		return -ENOMEM;
 
-- 
2.22.0


-- 
Andreas Schwab, SUSE Labs, schwab@suse.de
GPG Key fingerprint = 0196 BAD8 1CE9 1970 F4BE  1748 E4D4 88E3 0EEA B9D7
"And now for something completely different."
