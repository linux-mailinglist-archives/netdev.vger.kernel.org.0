Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ED2D3492DE
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 14:14:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230416AbhCYNNh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 09:13:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:52498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230204AbhCYNN0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 09:13:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7329861A1B;
        Thu, 25 Mar 2021 13:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616678005;
        bh=bSW+N5ry56/YWkLrCH8XHXA47hNF8phNSn+g3PtO5iM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tJ73AcVoahEUoOwFjt2t2rfE3Mq0CtbM8LXwpuTCopjBx0DV+5YQ8ihEkDfTNaM9+
         FpIbHx1KFPrbZqHdThvi5FE7G28k1HWoJeYOhOZhQUSfvZnwiTQYur3m5799sibRzK
         kY9k1lv0bIoUUIvgeRIF7Yk9kTMwwp/e/7cUMiYEhlnTynbaLMgyf1FoHtToI9eR1N
         ut7tnvJtuPk8Gg40KlCuO9HndvghmHsxSthhtxzDFY1vS7lsAxxovQ4fBkQ5M7yJWJ
         Vha2+bk+2iTUHCwg4XAhdwGFmfoiia/JyumBlOuGFrkInC3ZIYJULCe/U+P5X5vI7Z
         KR+vNVnTiuFHQ==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>, kuba@kernel.org
Cc:     =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next v2 01/12] net: phy: marvell10g: rename register
Date:   Thu, 25 Mar 2021 14:12:39 +0100
Message-Id: <20210325131250.15901-2-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210325131250.15901-1-kabel@kernel.org>
References: <20210325131250.15901-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MV_V2_PORT_MAC_TYPE_* is part of the CTRL register. Rename to
MV_V2_PORT_CTRL_MACTYPE_*.

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/net/phy/marvell10g.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index 74b64e52ffa2..9b514124af0d 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -80,8 +80,8 @@ enum {
 	MV_V2_PORT_CTRL		= 0xf001,
 	MV_V2_PORT_CTRL_SWRST	= BIT(15),
 	MV_V2_PORT_CTRL_PWRDOWN = BIT(11),
-	MV_V2_PORT_MAC_TYPE_MASK = 0x7,
-	MV_V2_PORT_MAC_TYPE_RATE_MATCH = 0x6,
+	MV_V2_PORT_CTRL_MACTYPE_MASK = 0x7,
+	MV_V2_PORT_CTRL_MACTYPE_RATE_MATCH = 0x6,
 	/* Temperature control/read registers (88X3310 only) */
 	MV_V2_TEMP_CTRL		= 0xf08a,
 	MV_V2_TEMP_CTRL_MASK	= 0xc000,
@@ -477,8 +477,8 @@ static int mv3310_config_init(struct phy_device *phydev)
 	val = phy_read_mmd(phydev, MDIO_MMD_VEND2, MV_V2_PORT_CTRL);
 	if (val < 0)
 		return val;
-	priv->rate_match = ((val & MV_V2_PORT_MAC_TYPE_MASK) ==
-			MV_V2_PORT_MAC_TYPE_RATE_MATCH);
+	priv->rate_match = ((val & MV_V2_PORT_CTRL_MACTYPE_MASK) ==
+			MV_V2_PORT_CTRL_MACTYPE_RATE_MATCH);
 
 	/* Enable EDPD mode - saving 600mW */
 	return mv3310_set_edpd(phydev, ETHTOOL_PHY_EDPD_DFLT_TX_MSECS);
-- 
2.26.2

