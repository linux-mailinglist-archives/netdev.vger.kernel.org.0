Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B6897A5C9
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 12:15:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732235AbfG3KPD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 06:15:03 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41242 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727115AbfG3KPC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 06:15:02 -0400
Received: by mail-wr1-f66.google.com with SMTP id c2so61908031wrm.8;
        Tue, 30 Jul 2019 03:15:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NZp0tiWYWeflnEAC5FTPRrIF191ca+yE63dpLeeohbM=;
        b=iqhUW7gefyNQWxi/AXgQJi+mke0tyoTCIeeGxHaI6DdwOXdqhrhInZxksGWxXUgapU
         y5bEkAyakQ9F0vbaKPrKgUGGM9ZA65jwfaJ1nnxLkiurfGohERRKsTn0ELKgsLS69c+R
         OSy3eBJMnVK39CjFjJJxUc+liMePZo73QRvLnFNttmkot7m2UyPVktUh2rHfz2Z7n/nH
         zqKuAyTw3wzca4aX4pqMYpbtFWSNZsMvqJYQ/qsnqWkHsgh43H6bzbZXSrlSmAY8u1fk
         QXK3KbpJqOxD+/FdTDrXu0v7z2+HF59OKEewDePjz4fh1plYVIFu0Ci651RloEuNtKLY
         JCPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NZp0tiWYWeflnEAC5FTPRrIF191ca+yE63dpLeeohbM=;
        b=NcMlb4Qsw7J3EG0OvUx63Qt6ZB66/wk5xMaknNwmPbd9nd+zU127lf77V8rgnTnIQI
         Q+K8zP23+tVujQjTFnMCBuyw1Sn7Gb/kl7s55B1hRZwddMya1BVOs2C+iQml/ga/oH4r
         sTEvXxuY38XsL5df2ntr/GUplSYr72+LzIATH3Jt53kUbMkKpvPoEwo868ggEL5u5DTh
         Um6t8DgXp5LGp0+ev+NlYWETreaM71k4fWcL9IHGzjIfTS2fYiUsmKUjuYw5pXwilfWj
         SJ7Erl7bzwPFodmCQVQhVSWM2VuT7vcSkDvTM9eRIpa4qJFhEXtbIvAlQ+hRu6fGvphK
         O1rA==
X-Gm-Message-State: APjAAAXMOG2fzvHiUGJZQqg4+/1qBWjpLWvve/FUogIIZauRRRRtNgXr
        oIwShLhvUTB9RCBuvJySWG5szHW0
X-Google-Smtp-Source: APXvYqw5TctgZNI/sY48QsAhxzUoVbouLp3+D3FvBMNnPX+HyBGTpWPdbtz149ad4H0CNj4/lJ0w6g==
X-Received: by 2002:adf:8364:: with SMTP id 91mr125855137wrd.13.1564481699090;
        Tue, 30 Jul 2019 03:14:59 -0700 (PDT)
Received: from vd-lxpc-hfe.ad.vahle.at ([80.110.31.209])
        by smtp.gmail.com with ESMTPSA id w14sm50923832wrk.44.2019.07.30.03.14.58
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 30 Jul 2019 03:14:58 -0700 (PDT)
From:   Hubert Feurstein <h.feurstein@gmail.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Hubert Feurstein <h.feurstein@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 1/2] net: dsa: mv88e6xxx: add support to setup led-control register through device-tree
Date:   Tue, 30 Jul 2019 12:14:50 +0200
Message-Id: <20190730101451.845-1-h.feurstein@gmail.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

So it is possible to change the default behaviour of the switch LEDs.

Signed-off-by: Hubert Feurstein <h.feurstein@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 52 ++++++++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/chip.h |  2 ++
 drivers/net/dsa/mv88e6xxx/port.c | 13 ++++++++
 drivers/net/dsa/mv88e6xxx/port.h | 10 ++++++
 4 files changed, 77 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 85638b868d8e..e5a11454e1e0 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1985,6 +1985,52 @@ static int mv88e6xxx_switch_reset(struct mv88e6xxx_chip *chip)
 	return mv88e6xxx_software_reset(chip);
 }
 
+static void mv88e6xxx_led_control_init(struct mv88e6xxx_chip *chip,
+				       const struct device_node *np)
+{
+	struct device_node *ports, *port;
+	struct mv88e6xxx_port *chip_port;
+	u32 led_control, reg;
+	int err;
+
+	if (!np)
+		return;
+
+	/* Read LED Control register value from device-tree */
+	ports = of_get_child_by_name(np, "ports");
+	if (!ports)
+		return;
+
+	for_each_available_child_of_node(ports, port) {
+		err = of_property_read_u32(port, "reg", &reg);
+		if (err || reg >= ARRAY_SIZE(chip->ports))
+			break;
+
+		err = of_property_read_u32(port, "marvell,led-control",
+					   &led_control);
+		if (!err) {
+			chip_port = &chip->ports[reg];
+			chip_port->led_control = led_control |
+						 MV88E6XXX_LED_CONTROL_VALID;
+			dev_dbg(chip->dev, "LED control value for port%d = 0x%02x\n",
+				reg, led_control);
+		}
+	}
+
+	of_node_put(ports);
+}
+
+static int mv88e6xxx_led_control_setup(struct mv88e6xxx_chip *chip, int port)
+{
+	u16 led_control = chip->ports[port].led_control;
+
+	if ((led_control & MV88E6XXX_LED_CONTROL_VALID) == 0)
+		return 0;
+
+	led_control &= ~MV88E6XXX_LED_CONTROL_VALID;
+	return mv88e6xxx_port_set_led_control(chip, port, led_control);
+}
+
 static int mv88e6xxx_set_port_mode(struct mv88e6xxx_chip *chip, int port,
 				   enum mv88e6xxx_frame_mode frame,
 				   enum mv88e6xxx_egress_mode egress, u16 etype)
@@ -2120,6 +2166,11 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
 	chip->ports[port].chip = chip;
 	chip->ports[port].port = port;
 
+	/* Setup LED Control before link-up or link-unforce */
+	err = mv88e6xxx_led_control_setup(chip, port);
+	if (err)
+		return err;
+
 	/* MAC Forcing register: don't force link, speed, duplex or flow control
 	 * state to any particular values on physical ports, but force the CPU
 	 * port and all DSA ports to their maximum bandwidth and full duplex.
@@ -4851,6 +4902,7 @@ static int mv88e6xxx_probe(struct mdio_device *mdiodev)
 		goto out;
 
 	mv88e6xxx_phy_init(chip);
+	mv88e6xxx_led_control_init(chip, np);
 
 	if (chip->info->ops->get_eeprom) {
 		if (np)
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 64872251e479..1bb775855d62 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -24,6 +24,7 @@
 #define MV88E6XXX_MAX_PVT_PORTS		16
 
 #define MV88E6XXX_MAX_GPIO	16
+#define MV88E6XXX_LED_CONTROL_VALID	0x8000
 
 enum mv88e6xxx_egress_mode {
 	MV88E6XXX_EGRESS_MODE_UNMODIFIED,
@@ -194,6 +195,7 @@ struct mv88e6xxx_port {
 	u64 vtu_member_violation;
 	u64 vtu_miss_violation;
 	u8 cmode;
+	u16 led_control;
 	int serdes_irq;
 };
 
diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
index 04309ef0a1cc..111bb686b764 100644
--- a/drivers/net/dsa/mv88e6xxx/port.c
+++ b/drivers/net/dsa/mv88e6xxx/port.c
@@ -1183,6 +1183,19 @@ int mv88e6351_port_set_ether_type(struct mv88e6xxx_chip *chip, int port,
 	return mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_ETH_TYPE, etype);
 }
 
+/* Offset 0x16: LED Control Register */
+
+int mv88e6xxx_port_set_led_control(struct mv88e6xxx_chip *chip, int port,
+				   u16 led_control)
+{
+	led_control &= MV88E6XXX_PORT_LED_CONTROL_DATA_MASK;
+	led_control |= MV88E6XXX_PORT_LED_CONTROL_POINTER_CONTROL_LED01
+		    |  MV88E6XXX_PORT_LED_CONTROL_UPDATE;
+
+	return mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_LED_CONTROL,
+				    led_control);
+}
+
 /* Offset 0x18: Port IEEE Priority Remapping Registers [0-3]
  * Offset 0x19: Port IEEE Priority Remapping Registers [4-7]
  */
diff --git a/drivers/net/dsa/mv88e6xxx/port.h b/drivers/net/dsa/mv88e6xxx/port.h
index 141df2988cd1..5aacbccf81e3 100644
--- a/drivers/net/dsa/mv88e6xxx/port.h
+++ b/drivers/net/dsa/mv88e6xxx/port.h
@@ -239,6 +239,14 @@
 /* Offset 0x13: OutFiltered Counter */
 #define MV88E6XXX_PORT_OUT_FILTERED	0x13
 
+/* Offset 0x16: LED Control Register */
+#define MV88E6XXX_PORT_LED_CONTROL				0x16
+#define MV88E6XXX_PORT_LED_CONTROL_DATA_MASK			0x07ff
+#define MV88E6XXX_PORT_LED_CONTROL_UPDATE			0x8000
+#define MV88E6XXX_PORT_LED_CONTROL_POINTER_CONTROL_LED01	0x0000
+#define MV88E6XXX_PORT_LED_CONTROL_POINTER_STRECH_BLINK_RATE	0x6000
+#define MV88E6XXX_PORT_LED_CONTROL_POINTER_CONTROL_SPECIAL	0x7000
+
 /* Offset 0x18: IEEE Priority Mapping Table */
 #define MV88E6390_PORT_IEEE_PRIO_MAP_TABLE			0x18
 #define MV88E6390_PORT_IEEE_PRIO_MAP_TABLE_UPDATE		0x8000
@@ -323,6 +331,8 @@ int mv88e6352_port_set_egress_floods(struct mv88e6xxx_chip *chip, int port,
 				     bool unicast, bool multicast);
 int mv88e6351_port_set_ether_type(struct mv88e6xxx_chip *chip, int port,
 				  u16 etype);
+int mv88e6xxx_port_set_led_control(struct mv88e6xxx_chip *chip, int port,
+				   u16 led_control);
 int mv88e6xxx_port_set_message_port(struct mv88e6xxx_chip *chip, int port,
 				    bool message_port);
 int mv88e6165_port_set_jumbo_size(struct mv88e6xxx_chip *chip, int port,
-- 
2.22.0

