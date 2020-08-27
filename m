Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2669A253BC5
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 04:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727772AbgH0CBC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 22:01:02 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54374 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726952AbgH0CAy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Aug 2020 22:00:54 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kB7Dc-00C1gP-L0; Thu, 27 Aug 2020 04:00:48 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v4 2/5] net/phy/mdio-i2c: Move header file to include/linux/mdio
Date:   Thu, 27 Aug 2020 04:00:29 +0200
Message-Id: <20200827020032.2866339-3-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200827020032.2866339-1-andrew@lunn.ch>
References: <20200827020032.2866339-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for moving all MDIO drivers into drivers/net/mdio, move
the mdio-i2c header file into include/linux/mdio so it can be used by
both the MDIO driver and the SFP code which instantiates I2C MDIO
busses.

v2:
Add include/linux/mdio

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 MAINTAINERS                                        | 1 +
 drivers/net/phy/mdio-i2c.c                         | 3 +--
 drivers/net/phy/sfp.c                              | 2 +-
 {drivers/net/phy => include/linux/mdio}/mdio-i2c.h | 0
 4 files changed, 3 insertions(+), 3 deletions(-)
 rename {drivers/net/phy => include/linux/mdio}/mdio-i2c.h (100%)

diff --git a/MAINTAINERS b/MAINTAINERS
index 347ed6904fdf..af25e8d003e7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -15647,6 +15647,7 @@ L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/phy/phylink.c
 F:	drivers/net/phy/sfp*
+F:	include/linux/mdio/mdio-i2c.h
 F:	include/linux/phylink.h
 F:	include/linux/sfp.h
 K:	phylink\.h|struct\s+phylink|\.phylink|>phylink_|phylink_(autoneg|clear|connect|create|destroy|disconnect|ethtool|helper|mac|mii|of|set|start|stop|test|validate)
diff --git a/drivers/net/phy/mdio-i2c.c b/drivers/net/phy/mdio-i2c.c
index 0746e2cc39ae..09200a70b315 100644
--- a/drivers/net/phy/mdio-i2c.c
+++ b/drivers/net/phy/mdio-i2c.c
@@ -10,10 +10,9 @@
  * of their settings.
  */
 #include <linux/i2c.h>
+#include <linux/mdio/mdio-i2c.h>
 #include <linux/phy.h>
 
-#include "mdio-i2c.h"
-
 /*
  * I2C bus addresses 0x50 and 0x51 are normally an EEPROM, which is
  * specified to be present in SFP modules.  These correspond with PHY
diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index c24b0e83dd32..5250dcdf46a4 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -7,6 +7,7 @@
 #include <linux/i2c.h>
 #include <linux/interrupt.h>
 #include <linux/jiffies.h>
+#include <linux/mdio/mdio-i2c.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/of.h>
@@ -16,7 +17,6 @@
 #include <linux/slab.h>
 #include <linux/workqueue.h>
 
-#include "mdio-i2c.h"
 #include "sfp.h"
 #include "swphy.h"
 
diff --git a/drivers/net/phy/mdio-i2c.h b/include/linux/mdio/mdio-i2c.h
similarity index 100%
rename from drivers/net/phy/mdio-i2c.h
rename to include/linux/mdio/mdio-i2c.h
-- 
2.28.0

