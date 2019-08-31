Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0B19A461E
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 22:19:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728582AbfHaUTE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Aug 2019 16:19:04 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:42320 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728567AbfHaUTC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Aug 2019 16:19:02 -0400
Received: by mail-qk1-f196.google.com with SMTP id f13so9169499qkm.9
        for <netdev@vger.kernel.org>; Sat, 31 Aug 2019 13:19:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HW6MmMo9x91xDNRXrwgQ7XOS3yrVpyhQ4yh3Fy6kf1Y=;
        b=b9Z2GfzoyzWRrEycWFPEW94cUikGUd0qupP9/UiJzuL2+DHthR2g2Uh2F+ZgSkxljK
         LjmwqQpY6+qB+gxiQ6CqZ0cXM1OP25pyJ6sJmXo3Awy4S2PVgoBZ+Q3flo7+aJWFCduj
         F5bWZpTq5Xxarc2F09+vM3O5NX1LyOl33S2J96d8vVczQ8Z1Fbil85x4MiD84a+Uq7Xe
         J+V/mxZ33dlHfXveBFZumWd0saI8ernGo7WkQw9LjIGeAb+ycMTOdVXN20w3thGVZpIx
         5INCDxiRr07/3I5N1qEpw+uj3iuVW08O2VV7xrWpN/qXSivLVoJkp4t5EptOCotRJ2gx
         JQ2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HW6MmMo9x91xDNRXrwgQ7XOS3yrVpyhQ4yh3Fy6kf1Y=;
        b=LZFSUxH3VN82ti/r9TjabZ0kU8PiYsZXtmOVpkqPPoSIKYh4fhxOVXJakg9W7RVNNe
         reUtODRpDnBKSOn+ej6AzJ7hzCLerVU67K06xlPVppqx607RLJHJ2A+CoI05k0sco5UC
         wsblwHRTHXbt36kHY87hV2AUfSMySr9uk7Vb/NrdB+tsLkHzkztgbk0XoiFXK/ifLyyT
         MD5e3sZlsFXpwHcXD2x8A4yc538n4ZLOdnrVWQ8foobLNAvb4fRSLMBsscZIba16/d9F
         yFNkM4omz2bQwm5g11g+fe0QmK7yJpOmyh47v9k3opVKdnMx7B3gA4Dg8AwMN5gsDLZv
         WyWQ==
X-Gm-Message-State: APjAAAVGKAzPPlSTTA+8y0lCc4PbSQyaWhwP8qUB7lkgF4gijWdwcJNb
        r3pau5ReztPUoEiK2ECOuY6FNyc4
X-Google-Smtp-Source: APXvYqzoqie8Mke/H19LsKHSQ0k04Smnjd8lzZbdkIZeNTlQpqE58Gv69PsB2223azbfjBg2tb3tNw==
X-Received: by 2002:a37:8d6:: with SMTP id 205mr21530340qki.308.1567282740821;
        Sat, 31 Aug 2019 13:19:00 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id w5sm4274252qki.13.2019.08.31.13.19.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Aug 2019 13:19:00 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>,
        f.fainelli@gmail.com, andrew@lunn.ch,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next 04/10] net: dsa: mv88e6xxx: simplify .serdes_get_lane
Date:   Sat, 31 Aug 2019 16:18:30 -0400
Message-Id: <20190831201836.19957-5-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190831201836.19957-1-vivien.didelot@gmail.com>
References: <20190831201836.19957-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Because the mapping between a SERDES interface and its lane is static,
we don't need to stick with negative error codes actually and we can
simply return 0 if there is no lane, just like the IRQ mapping.

This way we can keep a simple and intuitive API using unsigned lane
numbers while simplifying the implementations with single return
statements. Last but not least, fix the reverse chrismas tree in
mv88e6390x_serdes_get_lane.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.h   |   2 +-
 drivers/net/dsa/mv88e6xxx/port.c   |  13 +--
 drivers/net/dsa/mv88e6xxx/serdes.c | 152 +++++++++++------------------
 drivers/net/dsa/mv88e6xxx/serdes.h |  29 +++---
 4 files changed, 74 insertions(+), 122 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index b116bd7f6109..add0ec5188ec 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -444,7 +444,7 @@ struct mv88e6xxx_ops {
 	int (*serdes_power)(struct mv88e6xxx_chip *chip, int port, bool on);
 
 	/* SERDES lane mapping */
-	int (*serdes_get_lane)(struct mv88e6xxx_chip *chip, int port, u8 *lane);
+	u8 (*serdes_get_lane)(struct mv88e6xxx_chip *chip, int port);
 
 	/* SERDES interrupt handling */
 	unsigned int (*serdes_irq_mapping)(struct mv88e6xxx_chip *chip,
diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
index 4f841335ea32..06e2bdf6fa82 100644
--- a/drivers/net/dsa/mv88e6xxx/port.c
+++ b/drivers/net/dsa/mv88e6xxx/port.c
@@ -431,11 +431,8 @@ static int mv88e6xxx_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
 	if (cmode == chip->ports[port].cmode)
 		return 0;
 
-	err = mv88e6xxx_serdes_get_lane(chip, port, &lane);
-	if (err && err != -ENODEV)
-		return err;
-
-	if (err != -ENODEV) {
+	lane = mv88e6xxx_serdes_get_lane(chip, port);
+	if (lane) {
 		if (chip->ports[port].serdes_irq) {
 			err = mv88e6390_serdes_irq_disable(chip, port, lane);
 			if (err)
@@ -463,9 +460,9 @@ static int mv88e6xxx_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
 
 		chip->ports[port].cmode = cmode;
 
-		err = mv88e6xxx_serdes_get_lane(chip, port, &lane);
-		if (err)
-			return err;
+		lane = mv88e6xxx_serdes_get_lane(chip, port);
+		if (!lane)
+			return -ENODEV;
 
 		err = mv88e6390_serdes_power(chip, port, true);
 		if (err)
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index 4fb1dca64ef1..ce6d97e5caf8 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -295,149 +295,119 @@ void mv88e6352_serdes_irq_free(struct mv88e6xxx_chip *chip, int port)
 	chip->ports[port].serdes_irq = 0;
 }
 
-int mv88e6341_serdes_get_lane(struct mv88e6xxx_chip *chip, int port, u8 *lane)
+u8 mv88e6341_serdes_get_lane(struct mv88e6xxx_chip *chip, int port)
 {
 	u8 cmode = chip->ports[port].cmode;
+	u8 lane = 0;
 
-	if (port != 5)
-		return -ENODEV;
-
-	if (cmode == MV88E6XXX_PORT_STS_CMODE_1000BASEX ||
-	    cmode == MV88E6XXX_PORT_STS_CMODE_SGMII ||
-	    cmode == MV88E6XXX_PORT_STS_CMODE_2500BASEX) {
-		*lane = MV88E6341_PORT5_LANE;
-		return 0;
+	switch (port) {
+	case 5:
+		if (cmode == MV88E6XXX_PORT_STS_CMODE_1000BASEX ||
+		    cmode == MV88E6XXX_PORT_STS_CMODE_SGMII ||
+		    cmode == MV88E6XXX_PORT_STS_CMODE_2500BASEX)
+			lane = MV88E6341_PORT5_LANE;
+		break;
 	}
 
-	return -ENODEV;
+	return lane;
 }
 
-int mv88e6390_serdes_get_lane(struct mv88e6xxx_chip *chip, int port, u8 *lane)
+u8 mv88e6390_serdes_get_lane(struct mv88e6xxx_chip *chip, int port)
 {
 	u8 cmode = chip->ports[port].cmode;
+	u8 lane = 0;
 
 	switch (port) {
 	case 9:
 		if (cmode == MV88E6XXX_PORT_STS_CMODE_1000BASEX ||
 		    cmode == MV88E6XXX_PORT_STS_CMODE_SGMII ||
-		    cmode == MV88E6XXX_PORT_STS_CMODE_2500BASEX) {
-			*lane = MV88E6390_PORT9_LANE0;
-			return 0;
-		}
+		    cmode == MV88E6XXX_PORT_STS_CMODE_2500BASEX)
+			lane = MV88E6390_PORT9_LANE0;
 		break;
 	case 10:
 		if (cmode == MV88E6XXX_PORT_STS_CMODE_1000BASEX ||
 		    cmode == MV88E6XXX_PORT_STS_CMODE_SGMII ||
-		    cmode == MV88E6XXX_PORT_STS_CMODE_2500BASEX) {
-			*lane = MV88E6390_PORT10_LANE0;
-			return 0;
-		}
-		break;
-	default:
+		    cmode == MV88E6XXX_PORT_STS_CMODE_2500BASEX)
+			lane = MV88E6390_PORT10_LANE0;
 		break;
 	}
 
-	return -ENODEV;
+	return lane;
 }
 
-int mv88e6390x_serdes_get_lane(struct mv88e6xxx_chip *chip, int port, u8 *lane)
+u8 mv88e6390x_serdes_get_lane(struct mv88e6xxx_chip *chip, int port)
 {
-	u8 cmode_port9, cmode_port10, cmode_port;
-
-	cmode_port9 = chip->ports[9].cmode;
-	cmode_port10 = chip->ports[10].cmode;
-	cmode_port = chip->ports[port].cmode;
+	u8 cmode_port = chip->ports[port].cmode;
+	u8 cmode_port10 = chip->ports[10].cmode;
+	u8 cmode_port9 = chip->ports[9].cmode;
+	u8 lane = 0;
 
 	switch (port) {
 	case 2:
 		if (cmode_port9 == MV88E6XXX_PORT_STS_CMODE_1000BASEX ||
 		    cmode_port9 == MV88E6XXX_PORT_STS_CMODE_SGMII ||
-		    cmode_port9 == MV88E6XXX_PORT_STS_CMODE_2500BASEX) {
-			if (cmode_port == MV88E6XXX_PORT_STS_CMODE_1000BASEX) {
-				*lane = MV88E6390_PORT9_LANE1;
-				return 0;
-			}
-		}
+		    cmode_port9 == MV88E6XXX_PORT_STS_CMODE_2500BASEX)
+			if (cmode_port == MV88E6XXX_PORT_STS_CMODE_1000BASEX)
+				lane = MV88E6390_PORT9_LANE1;
 		break;
 	case 3:
 		if (cmode_port9 == MV88E6XXX_PORT_STS_CMODE_1000BASEX ||
 		    cmode_port9 == MV88E6XXX_PORT_STS_CMODE_SGMII ||
 		    cmode_port9 == MV88E6XXX_PORT_STS_CMODE_2500BASEX ||
-		    cmode_port9 == MV88E6XXX_PORT_STS_CMODE_RXAUI) {
-			if (cmode_port == MV88E6XXX_PORT_STS_CMODE_1000BASEX) {
-				*lane = MV88E6390_PORT9_LANE2;
-				return 0;
-			}
-		}
+		    cmode_port9 == MV88E6XXX_PORT_STS_CMODE_RXAUI)
+			if (cmode_port == MV88E6XXX_PORT_STS_CMODE_1000BASEX)
+				lane = MV88E6390_PORT9_LANE2;
 		break;
 	case 4:
 		if (cmode_port9 == MV88E6XXX_PORT_STS_CMODE_1000BASEX ||
 		    cmode_port9 == MV88E6XXX_PORT_STS_CMODE_SGMII ||
 		    cmode_port9 == MV88E6XXX_PORT_STS_CMODE_2500BASEX ||
-		    cmode_port9 == MV88E6XXX_PORT_STS_CMODE_RXAUI) {
-			if (cmode_port == MV88E6XXX_PORT_STS_CMODE_1000BASEX) {
-				*lane = MV88E6390_PORT9_LANE3;
-				return 0;
-			}
-		}
+		    cmode_port9 == MV88E6XXX_PORT_STS_CMODE_RXAUI)
+			if (cmode_port == MV88E6XXX_PORT_STS_CMODE_1000BASEX)
+				lane = MV88E6390_PORT9_LANE3;
 		break;
 	case 5:
 		if (cmode_port10 == MV88E6XXX_PORT_STS_CMODE_1000BASEX ||
 		    cmode_port10 == MV88E6XXX_PORT_STS_CMODE_SGMII ||
-		    cmode_port10 == MV88E6XXX_PORT_STS_CMODE_2500BASEX) {
-			if (cmode_port == MV88E6XXX_PORT_STS_CMODE_1000BASEX) {
-				*lane = MV88E6390_PORT10_LANE1;
-				return 0;
-			}
-		}
+		    cmode_port10 == MV88E6XXX_PORT_STS_CMODE_2500BASEX)
+			if (cmode_port == MV88E6XXX_PORT_STS_CMODE_1000BASEX)
+				lane = MV88E6390_PORT10_LANE1;
 		break;
 	case 6:
 		if (cmode_port10 == MV88E6XXX_PORT_STS_CMODE_1000BASEX ||
 		    cmode_port10 == MV88E6XXX_PORT_STS_CMODE_SGMII ||
 		    cmode_port10 == MV88E6XXX_PORT_STS_CMODE_2500BASEX ||
-		    cmode_port10 == MV88E6XXX_PORT_STS_CMODE_RXAUI) {
-			if (cmode_port == MV88E6XXX_PORT_STS_CMODE_1000BASEX) {
-				*lane = MV88E6390_PORT10_LANE2;
-				return 0;
-			}
-		}
+		    cmode_port10 == MV88E6XXX_PORT_STS_CMODE_RXAUI)
+			if (cmode_port == MV88E6XXX_PORT_STS_CMODE_1000BASEX)
+				lane = MV88E6390_PORT10_LANE2;
 		break;
 	case 7:
 		if (cmode_port10 == MV88E6XXX_PORT_STS_CMODE_1000BASEX ||
 		    cmode_port10 == MV88E6XXX_PORT_STS_CMODE_SGMII ||
 		    cmode_port10 == MV88E6XXX_PORT_STS_CMODE_2500BASEX ||
-		    cmode_port10 == MV88E6XXX_PORT_STS_CMODE_RXAUI) {
-			if (cmode_port == MV88E6XXX_PORT_STS_CMODE_1000BASEX) {
-				*lane = MV88E6390_PORT10_LANE3;
-				return 0;
-			}
-		}
+		    cmode_port10 == MV88E6XXX_PORT_STS_CMODE_RXAUI)
+			if (cmode_port == MV88E6XXX_PORT_STS_CMODE_1000BASEX)
+				lane = MV88E6390_PORT10_LANE3;
 		break;
 	case 9:
 		if (cmode_port9 == MV88E6XXX_PORT_STS_CMODE_1000BASEX ||
 		    cmode_port9 == MV88E6XXX_PORT_STS_CMODE_SGMII ||
 		    cmode_port9 == MV88E6XXX_PORT_STS_CMODE_2500BASEX ||
 		    cmode_port9 == MV88E6XXX_PORT_STS_CMODE_XAUI ||
-		    cmode_port9 == MV88E6XXX_PORT_STS_CMODE_RXAUI) {
-			*lane = MV88E6390_PORT9_LANE0;
-			return 0;
-		}
+		    cmode_port9 == MV88E6XXX_PORT_STS_CMODE_RXAUI)
+			lane = MV88E6390_PORT9_LANE0;
 		break;
 	case 10:
 		if (cmode_port10 == MV88E6XXX_PORT_STS_CMODE_1000BASEX ||
 		    cmode_port10 == MV88E6XXX_PORT_STS_CMODE_SGMII ||
 		    cmode_port10 == MV88E6XXX_PORT_STS_CMODE_2500BASEX ||
 		    cmode_port10 == MV88E6XXX_PORT_STS_CMODE_XAUI ||
-		    cmode_port10 == MV88E6XXX_PORT_STS_CMODE_RXAUI) {
-			*lane = MV88E6390_PORT10_LANE0;
-			return 0;
-		}
-		break;
-	default:
+		    cmode_port10 == MV88E6XXX_PORT_STS_CMODE_RXAUI)
+			lane = MV88E6390_PORT10_LANE0;
 		break;
 	}
 
-	return -ENODEV;
+	return lane;
 }
 
 /* Set the power on/off for 10GBASE-R and 10GBASE-X4/X2 */
@@ -497,14 +467,10 @@ int mv88e6390_serdes_power(struct mv88e6xxx_chip *chip, int port, bool on)
 {
 	u8 cmode = chip->ports[port].cmode;
 	u8 lane;
-	int err;
 
-	err = mv88e6xxx_serdes_get_lane(chip, port, &lane);
-	if (err) {
-		if (err == -ENODEV)
-			err = 0;
-		return err;
-	}
+	lane = mv88e6xxx_serdes_get_lane(chip, port);
+	if (!lane)
+		return 0;
 
 	switch (cmode) {
 	case MV88E6XXX_PORT_STS_CMODE_SGMII:
@@ -657,8 +623,8 @@ static irqreturn_t mv88e6390_serdes_thread_fn(int irq, void *dev_id)
 
 	mv88e6xxx_reg_lock(chip);
 
-	err = mv88e6xxx_serdes_get_lane(chip, port->port, &lane);
-	if (err)
+	lane = mv88e6xxx_serdes_get_lane(chip, port->port);
+	if (!lane)
 		goto out;
 
 	switch (cmode) {
@@ -691,12 +657,9 @@ int mv88e6390_serdes_irq_setup(struct mv88e6xxx_chip *chip, int port)
 	int err;
 	u8 lane;
 
-	err = mv88e6xxx_serdes_get_lane(chip, port, &lane);
-	if (err) {
-		if (err == -ENODEV)
-			err = 0;
-		return err;
-	}
+	lane = mv88e6xxx_serdes_get_lane(chip, port);
+	if (!lane)
+		return 0;
 
 	irq = mv88e6xxx_serdes_irq_mapping(chip, port);
 	if (!irq)
@@ -725,16 +688,11 @@ int mv88e6390_serdes_irq_setup(struct mv88e6xxx_chip *chip, int port)
 
 void mv88e6390_serdes_irq_free(struct mv88e6xxx_chip *chip, int port)
 {
-	int err;
 	u8 lane;
 
-	err = mv88e6xxx_serdes_get_lane(chip, port, &lane);
-	if (err) {
-		if (err != -ENODEV)
-			dev_err(chip->dev, "Unable to free SERDES irq: %d\n",
-				err);
+	lane = mv88e6xxx_serdes_get_lane(chip, port);
+	if (!lane)
 		return;
-	}
 
 	mv88e6390_serdes_irq_disable(chip, port, lane);
 
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.h b/drivers/net/dsa/mv88e6xxx/serdes.h
index cb8d287c9388..4718dcca6b3c 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.h
+++ b/drivers/net/dsa/mv88e6xxx/serdes.h
@@ -74,22 +74,9 @@
 #define MV88E6390_SGMII_PHY_STATUS_SPD_DPL_VALID BIT(11)
 #define MV88E6390_SGMII_PHY_STATUS_LINK		BIT(10)
 
-/* Put the SERDES lane address a port is using into *lane. If a port has
- * multiple lanes, should put the first lane the port is using. If a port does
- * not have a lane, return -ENODEV.
- */
-static inline int mv88e6xxx_serdes_get_lane(struct mv88e6xxx_chip *chip,
-					    int port, u8 *lane)
-{
-	if (!chip->info->ops->serdes_get_lane)
-		return -EOPNOTSUPP;
-
-	return chip->info->ops->serdes_get_lane(chip, port, lane);
-}
-
-int mv88e6341_serdes_get_lane(struct mv88e6xxx_chip *chip, int port, u8 *lane);
-int mv88e6390_serdes_get_lane(struct mv88e6xxx_chip *chip, int port, u8 *lane);
-int mv88e6390x_serdes_get_lane(struct mv88e6xxx_chip *chip, int port, u8 *lane);
+u8 mv88e6341_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
+u8 mv88e6390_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
+u8 mv88e6390x_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
 unsigned int mv88e6352_serdes_irq_mapping(struct mv88e6xxx_chip *chip,
 					  int port);
 unsigned int mv88e6390_serdes_irq_mapping(struct mv88e6xxx_chip *chip,
@@ -110,6 +97,16 @@ int mv88e6390_serdes_irq_disable(struct mv88e6xxx_chip *chip, int port,
 int mv88e6352_serdes_irq_setup(struct mv88e6xxx_chip *chip, int port);
 void mv88e6352_serdes_irq_free(struct mv88e6xxx_chip *chip, int port);
 
+/* Return the (first) SERDES lane address a port is using, 0 otherwise. */
+static inline u8 mv88e6xxx_serdes_get_lane(struct mv88e6xxx_chip *chip,
+					   int port)
+{
+	if (!chip->info->ops->serdes_get_lane)
+		return 0;
+
+	return chip->info->ops->serdes_get_lane(chip, port);
+}
+
 static inline unsigned int
 mv88e6xxx_serdes_irq_mapping(struct mv88e6xxx_chip *chip, int port)
 {
-- 
2.23.0

