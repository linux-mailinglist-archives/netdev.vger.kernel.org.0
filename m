Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E81B216383
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 03:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727943AbgGGBuC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 21:50:02 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50158 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727791AbgGGBuA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jul 2020 21:50:00 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jsck6-003wBz-My; Tue, 07 Jul 2020 03:49:54 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v2 3/7] net: phy: Properly define genphy_c45_driver
Date:   Tue,  7 Jul 2020 03:49:35 +0200
Message-Id: <20200707014939.938621-4-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707014939.938621-1-andrew@lunn.ch>
References: <20200707014939.938621-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Avoid the W=1 warning that symbol 'genphy_c45_driver' was not
declared. Should it be static?

Declare it on the phy header file.

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/phy_device.c | 1 -
 include/linux/phy.h          | 3 +++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index eb1068a77ce1..98be28567c65 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -227,7 +227,6 @@ static void phy_mdio_device_remove(struct mdio_device *mdiodev)
 }
 
 static struct phy_driver genphy_driver;
-extern struct phy_driver genphy_c45_driver;
 
 static LIST_HEAD(phy_fixup_list);
 static DEFINE_MUTEX(phy_fixup_lock);
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 101a48fa6750..1592c3d0e12f 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1385,6 +1385,9 @@ int genphy_c45_pma_read_abilities(struct phy_device *phydev);
 int genphy_c45_read_status(struct phy_device *phydev);
 int genphy_c45_config_aneg(struct phy_device *phydev);
 
+/* Generic C45 PHY driver */
+extern struct phy_driver genphy_c45_driver;
+
 /* The gen10g_* functions are the old Clause 45 stub */
 int gen10g_config_aneg(struct phy_device *phydev);
 
-- 
2.27.0.rc2

