Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48AAF3575D6
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 22:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356083AbhDGUYD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 16:24:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:55632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1356085AbhDGUXq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 16:23:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C95A611C1;
        Wed,  7 Apr 2021 20:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617827016;
        bh=6wldpr+hTsALr9hUbIjmafvYQKRQa6/aGrR0cxZwLH4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NL2f8AvFXFQ1mA0A2K02qxD8qaiN0t5immrPsjijPUvKNq49F35GwUvIzh44bDIN9
         a/LKDMroPDHLjsGkyrayQioFwKkAilJ6Cg0PwAvZ39rzyfgnrQEfHKT9JNEwwuMVk7
         kWu+Fjh/dj40zborKwJe3T9Nb7MK1zZCIOQBy5mJtY6xt87BsOgcLH95PeltqhqSXe
         UWYXKOfAf5Lg37tathrPf3Yz1qI2ktPHuKYGFhmMDjjOkiB26/pM79aluuy7nFJ6OZ
         YYE8eOn2d1XFfLkje0kvUXZYUqo2mGEeRiwoVqcGgpQDHnEZEL3NkG34IJNyrjJ4dG
         OgUtTZjJbcToQ==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     "David S . Miller" <davem@davemloft.net>, kuba@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next v4 01/16] net: phy: marvell10g: rename register
Date:   Wed,  7 Apr 2021 22:22:39 +0200
Message-Id: <20210407202254.29417-2-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210407202254.29417-1-kabel@kernel.org>
References: <20210407202254.29417-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MV_V2_PORT_MAC_TYPE_* is part of the CTRL register. Rename to
MV_V2_PORT_CTRL_MACTYPE_*.

Signed-off-by: Marek Behún <kabel@kernel.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
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

