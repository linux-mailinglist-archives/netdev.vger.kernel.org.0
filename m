Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4173C2611E8
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 15:14:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730023AbgIHNOv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 09:14:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729479AbgIHLZg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 07:25:36 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47DCCC061755
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 04:25:33 -0700 (PDT)
Received: from dude02.hi.pengutronix.de ([2001:67c:670:100:1d::28])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mfe@pengutronix.de>)
        id 1kFbka-0006xP-CF; Tue, 08 Sep 2020 13:25:24 +0200
Received: from mfe by dude02.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <mfe@pengutronix.de>)
        id 1kFbkW-0001jd-Up; Tue, 08 Sep 2020 13:25:20 +0200
From:   Marco Felsch <m.felsch@pengutronix.de>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, zhengdejin5@gmail.com,
        richard.leitner@skidata.com
Cc:     netdev@vger.kernel.org, kernel@pengutronix.de,
        devicetree@vger.kernel.org
Subject: [PATCH v2 5/5] net: phy: smsc: LAN8710/20: remove PHY_RST_AFTER_CLK_EN flag
Date:   Tue,  8 Sep 2020 13:25:20 +0200
Message-Id: <20200908112520.3439-6-m.felsch@pengutronix.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200908112520.3439-1-m.felsch@pengutronix.de>
References: <20200908112520.3439-1-m.felsch@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::28
X-SA-Exim-Mail-From: mfe@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Don't reset the phy without respect to the phy-state-machine because
this breaks the phy IRQ mode. We can archive the same behaviour if the
refclk in is specified.

Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
---
v2:
- adapt the subject to align with previous patch

 drivers/net/phy/smsc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index 7a1a7e13db85..0e618d2b6aba 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -331,7 +331,6 @@ static struct phy_driver smsc_phy_driver[] = {
 	.name		= "SMSC LAN8710/LAN8720",
 
 	/* PHY_BASIC_FEATURES */
-	.flags		= PHY_RST_AFTER_CLK_EN,
 
 	.probe		= smsc_phy_probe,
 	.remove		= smsc_phy_remove,
-- 
2.20.1

