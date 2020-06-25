Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2757520A244
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 17:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406003AbgFYPpE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 11:45:04 -0400
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:20125 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405962AbgFYPpA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 11:45:00 -0400
X-Originating-IP: 90.76.143.236
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id D579F24000E;
        Thu, 25 Jun 2020 15:44:57 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com
Subject: [PATCH net-next 7/8] net: phy: mscc: remove useless page configuration in the config init
Date:   Thu, 25 Jun 2020 17:42:10 +0200
Message-Id: <20200625154211.606591-8-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200625154211.606591-1-antoine.tenart@bootlin.com>
References: <20200625154211.606591-1-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the middle of vsc8584_config_init and vsc8514_config_init, the page
is set to 'standard'. This is the default value, and the page isn't set
to another value before. Those pages configuration can be safely
removed.

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 drivers/net/phy/mscc/mscc_main.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
index f625109df00a..04e1ef791cec 100644
--- a/drivers/net/phy/mscc/mscc_main.c
+++ b/drivers/net/phy/mscc/mscc_main.c
@@ -1443,8 +1443,6 @@ static int vsc8584_config_init(struct phy_device *phydev)
 	if (ret)
 		return ret;
 
-	phy_write(phydev, MSCC_EXT_PAGE_ACCESS, MSCC_PHY_PAGE_STANDARD);
-
 	val = phy_read(phydev, MSCC_PHY_EXT_PHY_CNTL_1);
 	val &= ~(MEDIA_OP_MODE_MASK | VSC8584_MAC_IF_SELECTION_MASK);
 	val |= (MEDIA_OP_MODE_COPPER << MEDIA_OP_MODE_POS) |
@@ -1892,11 +1890,6 @@ static int vsc8514_config_init(struct phy_device *phydev)
 
 	phy_unlock_mdio_bus(phydev);
 
-	ret = phy_write(phydev, MSCC_EXT_PAGE_ACCESS, MSCC_PHY_PAGE_STANDARD);
-
-	if (ret)
-		return ret;
-
 	ret = phy_modify(phydev, MSCC_PHY_EXT_PHY_CNTL_1, MEDIA_OP_MODE_MASK,
 			 MEDIA_OP_MODE_COPPER << MEDIA_OP_MODE_POS);
 
-- 
2.26.2

