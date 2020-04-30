Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1502B1BF294
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 10:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbgD3IVk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 04:21:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726127AbgD3IVk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 04:21:40 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2816C035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 01:21:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Fz9AT+5CWoqBwEvzTeAHf79roCOKmAmcoZtptaiLK/A=; b=f8zfSDgP29mskzSb6A1y1gceDC
        GL6a+txAdHiD1/+bM6MHYtlAHYvqoY2b+ro6NB6JO3CCYKrlssFqqTPey1F7CbIOaB5Y6dUFGAl2o
        MQmQjQN76kAwjquYz5XzNxyAe7rqQQh7pu/upl6fHjb51J4Ij0okjdqjvkyEq2oZfR546SAQfbyYr
        6XtZxnrlKC71BzL86C4yi5X2tltDC/uXifrRxlAsUA3TrhkpWw4JINFemDHf313eGDdx22NLLgX/9
        j7rni6DMuYOIo5DsTEysCgAekF5Ix8GM8/yBayYM/fIGO95Dn1NoCTA3CJzBZ6mfslv0dCbaTluh5
        2ogW/Mbg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:41716 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jU4Rq-0004iP-Nv; Thu, 30 Apr 2020 09:21:34 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jU4Rq-0001JT-4I; Thu, 30 Apr 2020 09:21:34 +0100
In-Reply-To: <20200430082104.GO1551@shell.armlinux.org.uk>
References: <20200430082104.GO1551@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next 1/2] net: dsa: mv88e6xxx: use generic clause 45
 definitions
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jU4Rq-0001JT-4I@rmk-PC.armlinux.org.uk>
Date:   Thu, 30 Apr 2020 09:21:34 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The private MV88E6390_PCS_CONTROL_1 definitions in serdes.h reflects
the IEEE 802.3 standard PCS control register 1 definitions, only
offset by 0x1000 in the PHYXS register space.  Rather than inventing
our own, use those that already exist, and name the register
MV88E6390_10G_CTRL1.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/mv88e6xxx/serdes.c | 12 ++++++------
 drivers/net/dsa/mv88e6xxx/serdes.h |  6 +-----
 2 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index 2098f19b534d..33d9923cf7c5 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -534,21 +534,21 @@ static int mv88e6390_serdes_power_10g(struct mv88e6xxx_chip *chip, u8 lane,
 	int err;
 
 	err = mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
-				    MV88E6390_PCS_CONTROL_1, &val);
+				    MV88E6390_10G_CTRL1, &val);
 
 	if (err)
 		return err;
 
 	if (up)
-		new_val = val & ~(MV88E6390_PCS_CONTROL_1_RESET |
-				  MV88E6390_PCS_CONTROL_1_LOOPBACK |
-				  MV88E6390_PCS_CONTROL_1_PDOWN);
+		new_val = val & ~(MDIO_CTRL1_RESET |
+				  MDIO_PCS_CTRL1_LOOPBACK |
+				  MDIO_CTRL1_LPOWER);
 	else
-		new_val = val | MV88E6390_PCS_CONTROL_1_PDOWN;
+		new_val = val | MDIO_CTRL1_LPOWER;
 
 	if (val != new_val)
 		err = mv88e6390_serdes_write(chip, lane, MDIO_MMD_PHYXS,
-					     MV88E6390_PCS_CONTROL_1, new_val);
+					     MV88E6390_10G_CTRL1, new_val);
 
 	return err;
 }
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.h b/drivers/net/dsa/mv88e6xxx/serdes.h
index 7990cadba4c2..71e3c3d0a24e 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.h
+++ b/drivers/net/dsa/mv88e6xxx/serdes.h
@@ -40,11 +40,7 @@
 #define MV88E6390_PORT10_LANE3		0x17
 
 /* 10GBASE-R and 10GBASE-X4/X2 */
-#define MV88E6390_PCS_CONTROL_1		0x1000
-#define MV88E6390_PCS_CONTROL_1_RESET		BIT(15)
-#define MV88E6390_PCS_CONTROL_1_LOOPBACK	BIT(14)
-#define MV88E6390_PCS_CONTROL_1_SPEED		BIT(13)
-#define MV88E6390_PCS_CONTROL_1_PDOWN		BIT(11)
+#define MV88E6390_10G_CTRL1		(0x1000 + MDIO_CTRL1)
 
 /* 1000BASE-X and SGMII */
 #define MV88E6390_SGMII_BMCR		(0x2000 + MII_BMCR)
-- 
2.20.1

