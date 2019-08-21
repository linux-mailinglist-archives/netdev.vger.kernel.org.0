Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F5CF987CA
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 01:27:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730545AbfHUX1a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 19:27:30 -0400
Received: from mail.nic.cz ([217.31.204.67]:38030 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730184AbfHUX12 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 19:27:28 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTP id 41571140C79;
        Thu, 22 Aug 2019 01:27:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1566430045; bh=8o91pcTrce2IoSeOrviOrCZyteiYiDcCoR+I1Ru2eI8=;
        h=From:To:Date;
        b=DKx/ak33UZ8Khavj9VZ76WzGZokngNCdSS3DARmzymW2Ow1n0vKSRGNT+6bsRLOMd
         ATZcTOgJhK7K8giteKuSXPgwLk0vyNSHUPbIWuZ77IUglqkrdPOlOT0ffKE09VI+zO
         RMKoY6bqideUkbQcrvvtvjXZiizLdjGfkgElEWX0=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
Subject: [PATCH net-next 04/10] net: dsa: mv88e6xxx: prefix hidden register macro names with MV88E6XXX_
Date:   Thu, 22 Aug 2019 01:27:18 +0200
Message-Id: <20190821232724.1544-5-marek.behun@nic.cz>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190821232724.1544-1-marek.behun@nic.cz>
References: <20190821232724.1544-1-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.100.3 at mail.nic.cz
X-Virus-Status: Clean
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,SHORTCIRCUIT,
        URIBL_BLOCKED shortcircuit=ham autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to be uniform with the rest of the driver, prepend hidden
register macro names with the MV88E6XXX_ prefix.

Signed-off-by: Marek Behún <marek.behun@nic.cz>
---
 drivers/net/dsa/mv88e6xxx/hidden.c | 36 ++++++++++++++++--------------
 drivers/net/dsa/mv88e6xxx/hidden.h | 16 ++++++-------
 2 files changed, 27 insertions(+), 25 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/hidden.c b/drivers/net/dsa/mv88e6xxx/hidden.c
index 6ea47b03679f..efa93c776a30 100644
--- a/drivers/net/dsa/mv88e6xxx/hidden.c
+++ b/drivers/net/dsa/mv88e6xxx/hidden.c
@@ -22,25 +22,26 @@ int mv88e6390_hidden_write(struct mv88e6xxx_chip *chip, int port,
 	u16 ctrl;
 	int err;
 
-	err = mv88e6xxx_port_write(chip, PORT_RESERVED_1A_DATA_PORT,
-				   PORT_RESERVED_1A, val);
+	err = mv88e6xxx_port_write(chip, MV88E6XXX_PORT_RESERVED_1A_DATA_PORT,
+				   MV88E6XXX_PORT_RESERVED_1A, val);
 	if (err)
 		return err;
 
-	ctrl = PORT_RESERVED_1A_BUSY | PORT_RESERVED_1A_WRITE |
-	       PORT_RESERVED_1A_BLOCK | port << PORT_RESERVED_1A_PORT_SHIFT |
-	       reg;
+	ctrl = MV88E6XXX_PORT_RESERVED_1A_BUSY |
+	       MV88E6XXX_PORT_RESERVED_1A_WRITE |
+	       MV88E6XXX_PORT_RESERVED_1A_BLOCK |
+	       port << MV88E6XXX_PORT_RESERVED_1A_PORT_SHIFT | reg;
 
-	return mv88e6xxx_port_write(chip, PORT_RESERVED_1A_CTRL_PORT,
-				    PORT_RESERVED_1A, ctrl);
+	return mv88e6xxx_port_write(chip, MV88E6XXX_PORT_RESERVED_1A_CTRL_PORT,
+				    MV88E6XXX_PORT_RESERVED_1A, ctrl);
 }
 
 int mv88e6390_hidden_wait(struct mv88e6xxx_chip *chip)
 {
-	int bit = __bf_shf(PORT_RESERVED_1A_BUSY);
+	int bit = __bf_shf(MV88E6XXX_PORT_RESERVED_1A_BUSY);
 
-	return mv88e6xxx_wait_bit(chip, PORT_RESERVED_1A_CTRL_PORT,
-				  PORT_RESERVED_1A, bit, 0);
+	return mv88e6xxx_wait_bit(chip, MV88E6XXX_PORT_RESERVED_1A_CTRL_PORT,
+				  MV88E6XXX_PORT_RESERVED_1A, bit, 0);
 }
 
 int mv88e6390_hidden_read(struct mv88e6xxx_chip *chip, int port,
@@ -49,12 +50,13 @@ int mv88e6390_hidden_read(struct mv88e6xxx_chip *chip, int port,
 	u16 ctrl;
 	int err;
 
-	ctrl = PORT_RESERVED_1A_BUSY | PORT_RESERVED_1A_READ |
-	       PORT_RESERVED_1A_BLOCK | port << PORT_RESERVED_1A_PORT_SHIFT |
-	       reg;
+	ctrl = MV88E6XXX_PORT_RESERVED_1A_BUSY |
+	       MV88E6XXX_PORT_RESERVED_1A_READ |
+	       MV88E6XXX_PORT_RESERVED_1A_BLOCK |
+	       port << MV88E6XXX_PORT_RESERVED_1A_PORT_SHIFT | reg;
 
-	err = mv88e6xxx_port_write(chip, PORT_RESERVED_1A_CTRL_PORT,
-				   PORT_RESERVED_1A, ctrl);
+	err = mv88e6xxx_port_write(chip, MV88E6XXX_PORT_RESERVED_1A_CTRL_PORT,
+				   MV88E6XXX_PORT_RESERVED_1A, ctrl);
 	if (err)
 		return err;
 
@@ -62,6 +64,6 @@ int mv88e6390_hidden_read(struct mv88e6xxx_chip *chip, int port,
 	if (err)
 		return err;
 
-	return mv88e6xxx_port_read(chip, PORT_RESERVED_1A_DATA_PORT,
-				   PORT_RESERVED_1A, val);
+	return mv88e6xxx_port_read(chip, MV88E6XXX_PORT_RESERVED_1A_DATA_PORT,
+				   MV88E6XXX_PORT_RESERVED_1A, val);
 }
diff --git a/drivers/net/dsa/mv88e6xxx/hidden.h b/drivers/net/dsa/mv88e6xxx/hidden.h
index 5e2de0a7f22d..632abbe4e139 100644
--- a/drivers/net/dsa/mv88e6xxx/hidden.h
+++ b/drivers/net/dsa/mv88e6xxx/hidden.h
@@ -13,14 +13,14 @@
 #include "chip.h"
 
 /* Offset 0x1a: Magic undocumented errata register */
-#define PORT_RESERVED_1A			0x1a
-#define PORT_RESERVED_1A_BUSY			BIT(15)
-#define PORT_RESERVED_1A_WRITE			BIT(14)
-#define PORT_RESERVED_1A_READ			0
-#define PORT_RESERVED_1A_PORT_SHIFT		5
-#define PORT_RESERVED_1A_BLOCK			(0xf << 10)
-#define PORT_RESERVED_1A_CTRL_PORT		4
-#define PORT_RESERVED_1A_DATA_PORT		5
+#define MV88E6XXX_PORT_RESERVED_1A		0x1a
+#define MV88E6XXX_PORT_RESERVED_1A_BUSY		BIT(15)
+#define MV88E6XXX_PORT_RESERVED_1A_WRITE	BIT(14)
+#define MV88E6XXX_PORT_RESERVED_1A_READ		0
+#define MV88E6XXX_PORT_RESERVED_1A_PORT_SHIFT	5
+#define MV88E6XXX_PORT_RESERVED_1A_BLOCK	(0xf << 10)
+#define MV88E6XXX_PORT_RESERVED_1A_CTRL_PORT	4
+#define MV88E6XXX_PORT_RESERVED_1A_DATA_PORT	5
 
 int mv88e6390_hidden_write(struct mv88e6xxx_chip *chip, int port,
 			   int reg, u16 val);
-- 
2.21.0

