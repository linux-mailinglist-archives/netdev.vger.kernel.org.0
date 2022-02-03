Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23BB24A8529
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 14:30:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350815AbiBCNan (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 08:30:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350812AbiBCNam (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 08:30:42 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 871A3C061714
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 05:30:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=4ppb0C8iJqg0uzgQRqkbvoHKMw0BsHTg41tAJsEznt8=; b=Ph84L4UYnkOjLmTFw3NE/pk5aB
        +rvTT9vLiSJ5eFyAvDmfqRDdrHAUu563tFDWPkzw50VA0XxmMzllRadPuaOxVMwAZyAb+SB5DJnSQ
        y0miVIuzGhNmtZSeMc2ran7pIG8tiZbmpnbH/D6TzZ85cMOLkcq02WgZxEyaHa0gPNcS9mzFNOdBO
        Of7qJ+cLZmqpKc4Ccin5/p08WU0BYQ6sYgXxFrP8EX/u1d18m/X/B/wFL9yMte+ExE+08l5X44skg
        9zEOyhRdU3+NYzjne6dT83Xjy3P5S68g3Spmp3JIi6CDOKJlQaZdfjzdlcLS2XWDQlfO4MprFgc7Y
        Yg4wB6Tw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:53932 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nFcC5-0002ft-N3; Thu, 03 Feb 2022 13:30:37 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nFcC4-006WMi-WE; Thu, 03 Feb 2022 13:30:37 +0000
In-Reply-To: <YfvYxNAkOZ6aNxql@shell.armlinux.org.uk>
References: <YfvYxNAkOZ6aNxql@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     Marek Beh__n <kabel@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 1/4] net: dsa: mv88e6xxx: add
 mv88e6352_g2_scratch_port_has_serdes()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nFcC4-006WMi-WE@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Thu, 03 Feb 2022 13:30:36 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Read the hardware configuration to determine which port is attached
to the serdes.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/mv88e6xxx/global2.h         |  3 +++
 drivers/net/dsa/mv88e6xxx/global2_scratch.c | 28 +++++++++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/global2.h b/drivers/net/dsa/mv88e6xxx/global2.h
index f3e27573a386..807aeaad9830 100644
--- a/drivers/net/dsa/mv88e6xxx/global2.h
+++ b/drivers/net/dsa/mv88e6xxx/global2.h
@@ -299,6 +299,8 @@
 #define MV88E6352_G2_SCRATCH_CONFIG_DATA1_NO_CPU	BIT(2)
 #define MV88E6352_G2_SCRATCH_CONFIG_DATA2	0x72
 #define MV88E6352_G2_SCRATCH_CONFIG_DATA2_P0_MODE_MASK	0x3
+#define MV88E6352_G2_SCRATCH_CONFIG_DATA3	0x73
+#define MV88E6352_G2_SCRATCH_CONFIG_DATA3_S_SEL		BIT(1)
 
 #define MV88E6352_G2_SCRATCH_GPIO_PCTL_GPIO	0
 #define MV88E6352_G2_SCRATCH_GPIO_PCTL_TRIG	1
@@ -370,6 +372,7 @@ extern const struct mv88e6xxx_gpio_ops mv88e6352_gpio_ops;
 
 int mv88e6xxx_g2_scratch_gpio_set_smi(struct mv88e6xxx_chip *chip,
 				      bool external);
+int mv88e6352_g2_scratch_port_has_serdes(struct mv88e6xxx_chip *chip, int port);
 int mv88e6xxx_g2_atu_stats_set(struct mv88e6xxx_chip *chip, u16 kind, u16 bin);
 int mv88e6xxx_g2_atu_stats_get(struct mv88e6xxx_chip *chip, u16 *stats);
 
diff --git a/drivers/net/dsa/mv88e6xxx/global2_scratch.c b/drivers/net/dsa/mv88e6xxx/global2_scratch.c
index eda710062933..a9d6e40321a2 100644
--- a/drivers/net/dsa/mv88e6xxx/global2_scratch.c
+++ b/drivers/net/dsa/mv88e6xxx/global2_scratch.c
@@ -289,3 +289,31 @@ int mv88e6xxx_g2_scratch_gpio_set_smi(struct mv88e6xxx_chip *chip,
 
 	return mv88e6xxx_g2_scratch_write(chip, misc_cfg, val);
 }
+
+/**
+ * mv88e6352_g2_scratch_port_has_serdes - indicate if a port can have a serdes
+ * @chip: chip private data
+ * @port: port number to check for serdes
+ *
+ * Indicates whether the port may have a serdes attached according to the
+ * pin strapping. Returns negative error number, 0 if the port is not
+ * configured to have a serdes, and 1 if the port is configured to have a
+ * serdes attached.
+ */
+int mv88e6352_g2_scratch_port_has_serdes(struct mv88e6xxx_chip *chip, int port)
+{
+	u8 config3, p;
+	int err;
+
+	err = mv88e6xxx_g2_scratch_read(chip, MV88E6352_G2_SCRATCH_CONFIG_DATA3,
+					&config3);
+	if (err)
+		return err;
+
+	if (config3 & MV88E6352_G2_SCRATCH_CONFIG_DATA3_S_SEL)
+		p = 5;
+	else
+		p = 4;
+
+	return port == p;
+}
-- 
2.30.2

