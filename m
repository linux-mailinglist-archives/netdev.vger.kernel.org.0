Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 037B0214E89
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 20:31:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728068AbgGESbS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 14:31:18 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47482 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727803AbgGESbR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Jul 2020 14:31:17 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1js9Q3-003itf-7Z; Sun, 05 Jul 2020 20:31:15 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 3/7] net: phy: Properly define genphy_c45_driver
Date:   Sun,  5 Jul 2020 20:29:17 +0200
Message-Id: <20200705182921.887441-4-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200705182921.887441-1-andrew@lunn.ch>
References: <20200705182921.887441-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Avoid the W=1 warning that symbol 'genphy_c45_driver' was not
declared. Should it be static?

Declare it on the phy header file.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/phy_device.c | 1 -
 include/linux/phy.h          | 3 +++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 29ef4456ac25..d2e1193b032c 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -226,7 +226,6 @@ static void phy_mdio_device_remove(struct mdio_device *mdiodev)
 }
 
 static struct phy_driver genphy_driver;
-extern struct phy_driver genphy_c45_driver;
 
 static LIST_HEAD(phy_fixup_list);
 static DEFINE_MUTEX(phy_fixup_lock);
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 6fb8f302978d..eb3252474b97 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1398,6 +1398,9 @@ int genphy_c45_pma_read_abilities(struct phy_device *phydev);
 int genphy_c45_read_status(struct phy_device *phydev);
 int genphy_c45_config_aneg(struct phy_device *phydev);
 
+/* Generic C45 PHY driver */
+extern struct phy_driver genphy_c45_driver;
+
 /* The gen10g_* functions are the old Clause 45 stub */
 int gen10g_config_aneg(struct phy_device *phydev);
 
-- 
2.27.0.rc2

