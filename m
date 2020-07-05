Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 905C5214EED
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 21:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728148AbgGETi2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 15:38:28 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47668 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727892AbgGETiX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Jul 2020 15:38:23 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jsASw-003jY3-Je; Sun, 05 Jul 2020 21:38:18 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 3/4] net: dsa: mv88e6xxx: Remove set but unused variable
Date:   Sun,  5 Jul 2020 21:38:09 +0200
Message-Id: <20200705193810.890020-4-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200705193810.890020-1-andrew@lunn.ch>
References: <20200705193810.890020-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We don't act on any errors reading registers while handling watchdog
interrupt. Since this is an interrupt handler, we cannot return such
errors. So just remove the variable.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/mv88e6xxx/global2.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/global2.c b/drivers/net/dsa/mv88e6xxx/global2.c
index 8fd483020c5b..75b227d0f73b 100644
--- a/drivers/net/dsa/mv88e6xxx/global2.c
+++ b/drivers/net/dsa/mv88e6xxx/global2.c
@@ -876,19 +876,18 @@ static int mv88e6390_watchdog_setup(struct mv88e6xxx_chip *chip)
 
 static int mv88e6390_watchdog_action(struct mv88e6xxx_chip *chip, int irq)
 {
-	int err;
 	u16 reg;
 
 	mv88e6xxx_g2_write(chip, MV88E6390_G2_WDOG_CTL,
 			   MV88E6390_G2_WDOG_CTL_PTR_EVENT);
-	err = mv88e6xxx_g2_read(chip, MV88E6390_G2_WDOG_CTL, &reg);
+	mv88e6xxx_g2_read(chip, MV88E6390_G2_WDOG_CTL, &reg);
 
 	dev_info(chip->dev, "Watchdog event: 0x%04x",
 		 reg & MV88E6390_G2_WDOG_CTL_DATA_MASK);
 
 	mv88e6xxx_g2_write(chip, MV88E6390_G2_WDOG_CTL,
 			   MV88E6390_G2_WDOG_CTL_PTR_HISTORY);
-	err = mv88e6xxx_g2_read(chip, MV88E6390_G2_WDOG_CTL, &reg);
+	mv88e6xxx_g2_read(chip, MV88E6390_G2_WDOG_CTL, &reg);
 
 	dev_info(chip->dev, "Watchdog history: 0x%04x",
 		 reg & MV88E6390_G2_WDOG_CTL_DATA_MASK);
-- 
2.27.0.rc2

