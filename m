Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3016548886
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 18:02:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241280AbiFMPbZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 11:31:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347413AbiFMP2e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 11:28:34 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62E7813F1D2
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 06:01:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=lvppQ1wElMwv5kuHOpgEF6MQXON/78hKq1pX8LKxJvg=; b=NXfxwomSJKGbyb3s0JpgzRET7R
        1WPK3ubZEBeZP1LJDg5b+wtth8XjLTqxe+MAqtedBnh2GkhOY77JqFxIeT2Tcndap8YELxE8uOMwf
        ejPb4YH+Ya34uf14kOiLBW8lkW6g9v53YaZ9NRGRFShhRdnMmIYTfqgi1NPD+yWWi6gFTPcueXPCO
        B616Wiz27w+XgxGzXWk875dMEu8sVKs1FSHISboVz8PqWRa4iKFlInCtS4zD8riOGd5MdVTbPQDGt
        lM3ulUPU3FsppAQcZQp+XuC6grgPBJ8OVO6C7toekfw4Z2Rol4OqO4SzdPorbI5xEP3eLnH1wKq4t
        9bAuiNBA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:52100 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1o0jh4-0001sp-Ui; Mon, 13 Jun 2022 14:01:22 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1o0jh4-000JZH-AX; Mon, 13 Jun 2022 14:01:22 +0100
In-Reply-To: <Yqc0lxn3ngWSuvdS@shell.armlinux.org.uk>
References: <Yqc0lxn3ngWSuvdS@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Robert Hancock <robert.hancock@calian.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 12/15] net: dsa: mv88e6xxx: convert 88e6185 to
 phylink_pcs
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1o0jh4-000JZH-AX@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Mon, 13 Jun 2022 14:01:22 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the 88E6185 SERDES code to use the phylink_pcs infrastructure.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/mv88e6xxx/Makefile   |   1 +
 drivers/net/dsa/mv88e6xxx/chip.c     |  17 +--
 drivers/net/dsa/mv88e6xxx/pcs-6185.c | 158 +++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/serdes.c   | 109 ------------------
 drivers/net/dsa/mv88e6xxx/serdes.h   |  11 +-
 5 files changed, 167 insertions(+), 129 deletions(-)
 create mode 100644 drivers/net/dsa/mv88e6xxx/pcs-6185.c

diff --git a/drivers/net/dsa/mv88e6xxx/Makefile b/drivers/net/dsa/mv88e6xxx/Makefile
index c8eca2b6f959..fd370e3bb1f1 100644
--- a/drivers/net/dsa/mv88e6xxx/Makefile
+++ b/drivers/net/dsa/mv88e6xxx/Makefile
@@ -9,6 +9,7 @@ mv88e6xxx-objs += global2.o
 mv88e6xxx-objs += global2_avb.o
 mv88e6xxx-objs += global2_scratch.o
 mv88e6xxx-$(CONFIG_NET_DSA_MV88E6XXX_PTP) += hwtstamp.o
+mv88e6xxx-objs += pcs-6185.o
 mv88e6xxx-objs += phy.o
 mv88e6xxx-objs += port.o
 mv88e6xxx-objs += port_hidden.o
diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 8f379a97ef55..7ca71b44666c 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -4164,9 +4164,8 @@ static const struct mv88e6xxx_ops mv88e6095_ops = {
 	.stats_get_strings = mv88e6095_stats_get_strings,
 	.stats_get_stats = mv88e6095_stats_get_stats,
 	.mgmt_rsvd2cpu = mv88e6185_g2_mgmt_rsvd2cpu,
-	.serdes_power = mv88e6185_serdes_power,
-	.serdes_get_lane = mv88e6185_serdes_get_lane,
-	.serdes_pcs_get_state = mv88e6185_serdes_pcs_get_state,
+	.pcs_init = mv88e6185_pcs_init,
+	.pcs_select = mv88e6xxx_pcs_select,
 	.ppu_enable = mv88e6185_g1_ppu_enable,
 	.ppu_disable = mv88e6185_g1_ppu_disable,
 	.reset = mv88e6185_g1_reset,
@@ -4208,12 +4207,9 @@ static const struct mv88e6xxx_ops mv88e6097_ops = {
 	.set_egress_port = mv88e6095_g1_set_egress_port,
 	.watchdog_ops = &mv88e6097_watchdog_ops,
 	.mgmt_rsvd2cpu = mv88e6352_g2_mgmt_rsvd2cpu,
-	.serdes_power = mv88e6185_serdes_power,
-	.serdes_get_lane = mv88e6185_serdes_get_lane,
-	.serdes_pcs_get_state = mv88e6185_serdes_pcs_get_state,
+	.pcs_init = mv88e6185_pcs_init,
+	.pcs_select = mv88e6xxx_pcs_select,
 	.serdes_irq_mapping = mv88e6390_serdes_irq_mapping,
-	.serdes_irq_enable = mv88e6097_serdes_irq_enable,
-	.serdes_irq_status = mv88e6097_serdes_irq_status,
 	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.reset = mv88e6352_g1_reset,
 	.rmu_disable = mv88e6085_g1_rmu_disable,
@@ -4685,9 +4681,8 @@ static const struct mv88e6xxx_ops mv88e6185_ops = {
 	.set_egress_port = mv88e6095_g1_set_egress_port,
 	.watchdog_ops = &mv88e6097_watchdog_ops,
 	.mgmt_rsvd2cpu = mv88e6185_g2_mgmt_rsvd2cpu,
-	.serdes_power = mv88e6185_serdes_power,
-	.serdes_get_lane = mv88e6185_serdes_get_lane,
-	.serdes_pcs_get_state = mv88e6185_serdes_pcs_get_state,
+	.pcs_init = mv88e6185_pcs_init,
+	.pcs_select = mv88e6xxx_pcs_select,
 	.set_cascade_port = mv88e6185_g1_set_cascade_port,
 	.ppu_enable = mv88e6185_g1_ppu_enable,
 	.ppu_disable = mv88e6185_g1_ppu_disable,
diff --git a/drivers/net/dsa/mv88e6xxx/pcs-6185.c b/drivers/net/dsa/mv88e6xxx/pcs-6185.c
new file mode 100644
index 000000000000..4bb710bd9206
--- /dev/null
+++ b/drivers/net/dsa/mv88e6xxx/pcs-6185.c
@@ -0,0 +1,158 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Marvell 88E6185 family SERDES PCS support
+ *
+ * Copyright (c) 2008 Marvell Semiconductor
+ *
+ * Copyright (c) 2017 Andrew Lunn <andrew@lunn.ch>
+ */
+#include <linux/phylink.h>
+
+#include "global2.h"
+#include "port.h"
+#include "serdes.h"
+
+struct mv88e6185_pcs {
+	struct phylink_pcs phylink_pcs;
+	unsigned int irq;
+	char name[64];
+
+	struct mv88e6xxx_chip *chip;
+	int port;
+};
+
+static struct mv88e6185_pcs *pcs_to_mv88e6185_pcs(struct phylink_pcs *pcs)
+{
+	return container_of(pcs, struct mv88e6185_pcs, phylink_pcs);
+}
+
+static irqreturn_t mv88e6185_pcs_handle_irq(int irq, void *dev_id)
+{
+	struct mv88e6185_pcs *mpcs = dev_id;
+	struct mv88e6xxx_chip *chip;
+	irqreturn_t ret = IRQ_NONE;
+	bool link_up;
+	u16 status;
+	int port;
+	int err;
+
+	chip = mpcs->chip;
+	port = mpcs->port;
+
+	mv88e6xxx_reg_lock(chip);
+	err = mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_STS, &status);
+	mv88e6xxx_reg_unlock(chip);
+
+	if (!err) {
+		link_up = !!(status & MV88E6XXX_PORT_STS_LINK);
+
+		dsa_port_phylink_mac_change(chip->ds, port, link_up);
+
+		ret = IRQ_HANDLED;
+	}
+
+	return ret;
+}
+
+static void mv88e6185_pcs_get_state(struct phylink_pcs *pcs,
+				    struct phylink_link_state *state)
+{
+	struct mv88e6185_pcs *mpcs = pcs_to_mv88e6185_pcs(pcs);
+	struct mv88e6xxx_chip *chip = mpcs->chip;
+	int port = mpcs->port;
+	u16 status;
+	int err;
+
+	mv88e6xxx_reg_lock(chip);
+	err = mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_STS, &status);
+	mv88e6xxx_reg_unlock(chip);
+
+	if (err)
+		status = 0;
+
+	state->link = !!(status & MV88E6XXX_PORT_STS_LINK);
+	if (state->link) {
+		state->duplex = status & MV88E6XXX_PORT_STS_DUPLEX ?
+			DUPLEX_FULL : DUPLEX_HALF;
+
+		switch (status & MV88E6XXX_PORT_STS_SPEED_MASK) {
+		case MV88E6XXX_PORT_STS_SPEED_1000:
+			state->speed = SPEED_1000;
+			break;
+
+		case MV88E6XXX_PORT_STS_SPEED_100:
+			state->speed = SPEED_100;
+			break;
+
+		case MV88E6XXX_PORT_STS_SPEED_10:
+			state->speed = SPEED_10;
+			break;
+
+		default:
+			state->link = false;
+			break;
+		}
+	}
+}
+
+static int mv88e6185_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
+				phy_interface_t interface,
+				const unsigned long *advertising,
+				bool permit_pause_to_mac)
+{
+	return 0;
+}
+
+static void mv88e6185_pcs_an_restart(struct phylink_pcs *pcs)
+{
+}
+
+static const struct phylink_pcs_ops mv88e6185_pcs_ops = {
+	.pcs_get_state = mv88e6185_pcs_get_state,
+	.pcs_config = mv88e6185_pcs_config,
+	.pcs_an_restart = mv88e6185_pcs_an_restart,
+};
+
+int mv88e6185_pcs_init(struct mv88e6xxx_chip *chip, int port)
+{
+	struct mv88e6185_pcs *mpcs;
+	struct device *dev;
+	unsigned int irq;
+	int err;
+
+	/* There are no configurable serdes lanes on this switch chip, so
+	 * we use the static cmode configuration to determine whether we
+	 * have a PCS or not.
+	 */
+	if (chip->ports[port].cmode != MV88E6185_PORT_STS_CMODE_SERDES &&
+	    chip->ports[port].cmode != MV88E6185_PORT_STS_CMODE_1000BASE_X)
+		return 0;
+
+	dev = chip->dev;
+
+	mpcs = devm_kzalloc(dev, sizeof(*mpcs), GFP_KERNEL);
+	if (!mpcs)
+		return -ENOMEM;
+
+	mpcs->chip = chip;
+	mpcs->port = port;
+	mpcs->phylink_pcs.ops = &mv88e6185_pcs_ops;
+
+	irq = mv88e6xxx_serdes_irq_mapping(chip, port);
+	if (irq) {
+		snprintf(mpcs->name, sizeof(mpcs->name),
+			 "mv88e6xxx-%s-serdes-%d", dev_name(dev), port);
+
+		err = devm_request_threaded_irq(dev, irq, NULL,
+						mv88e6185_pcs_handle_irq,
+						IRQF_ONESHOT, mpcs->name, mpcs);
+		if (err)
+			return err;
+	} else {
+		mpcs->phylink_pcs.poll = true;
+	}
+
+	chip->ports[port].pcs_private = &mpcs->phylink_pcs;
+
+	return 0;
+}
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index 28831118e551..1d05319d2ffd 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -464,115 +464,6 @@ int mv88e6341_serdes_get_lane(struct mv88e6xxx_chip *chip, int port)
 	return lane;
 }
 
-int mv88e6185_serdes_power(struct mv88e6xxx_chip *chip, int port, int lane,
-			   bool up)
-{
-	/* The serdes power can't be controlled on this switch chip but we need
-	 * to supply this function to avoid returning -EOPNOTSUPP in
-	 * mv88e6xxx_serdes_power_up/mv88e6xxx_serdes_power_down
-	 */
-	return 0;
-}
-
-int mv88e6185_serdes_get_lane(struct mv88e6xxx_chip *chip, int port)
-{
-	/* There are no configurable serdes lanes on this switch chip but we
-	 * need to return a non-negative lane number so that callers of
-	 * mv88e6xxx_serdes_get_lane() know this is a serdes port.
-	 */
-	switch (chip->ports[port].cmode) {
-	case MV88E6185_PORT_STS_CMODE_SERDES:
-	case MV88E6185_PORT_STS_CMODE_1000BASE_X:
-		return 0;
-	default:
-		return -ENODEV;
-	}
-}
-
-int mv88e6185_serdes_pcs_get_state(struct mv88e6xxx_chip *chip, int port,
-				   int lane, struct phylink_link_state *state)
-{
-	int err;
-	u16 status;
-
-	err = mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_STS, &status);
-	if (err)
-		return err;
-
-	state->link = !!(status & MV88E6XXX_PORT_STS_LINK);
-
-	if (state->link) {
-		state->duplex = status & MV88E6XXX_PORT_STS_DUPLEX ? DUPLEX_FULL : DUPLEX_HALF;
-
-		switch (status &  MV88E6XXX_PORT_STS_SPEED_MASK) {
-		case MV88E6XXX_PORT_STS_SPEED_1000:
-			state->speed = SPEED_1000;
-			break;
-		case MV88E6XXX_PORT_STS_SPEED_100:
-			state->speed = SPEED_100;
-			break;
-		case MV88E6XXX_PORT_STS_SPEED_10:
-			state->speed = SPEED_10;
-			break;
-		default:
-			dev_err(chip->dev, "invalid PHY speed\n");
-			return -EINVAL;
-		}
-	} else {
-		state->duplex = DUPLEX_UNKNOWN;
-		state->speed = SPEED_UNKNOWN;
-	}
-
-	return 0;
-}
-
-int mv88e6097_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port, int lane,
-				bool enable)
-{
-	u8 cmode = chip->ports[port].cmode;
-
-	/* The serdes interrupts are enabled in the G2_INT_MASK register. We
-	 * need to return 0 to avoid returning -EOPNOTSUPP in
-	 * mv88e6xxx_serdes_irq_enable/mv88e6xxx_serdes_irq_disable
-	 */
-	switch (cmode) {
-	case MV88E6185_PORT_STS_CMODE_SERDES:
-	case MV88E6185_PORT_STS_CMODE_1000BASE_X:
-		return 0;
-	}
-
-	return -EOPNOTSUPP;
-}
-
-static void mv88e6097_serdes_irq_link(struct mv88e6xxx_chip *chip, int port)
-{
-	u16 status;
-	int err;
-
-	err = mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_STS, &status);
-	if (err) {
-		dev_err(chip->dev, "can't read port status: %d\n", err);
-		return;
-	}
-
-	dsa_port_phylink_mac_change(chip->ds, port, !!(status & MV88E6XXX_PORT_STS_LINK));
-}
-
-irqreturn_t mv88e6097_serdes_irq_status(struct mv88e6xxx_chip *chip, int port,
-					int lane)
-{
-	u8 cmode = chip->ports[port].cmode;
-
-	switch (cmode) {
-	case MV88E6185_PORT_STS_CMODE_SERDES:
-	case MV88E6185_PORT_STS_CMODE_1000BASE_X:
-		mv88e6097_serdes_irq_link(chip, port);
-		return IRQ_HANDLED;
-	}
-
-	return IRQ_NONE;
-}
-
 int mv88e6390_serdes_get_lane(struct mv88e6xxx_chip *chip, int port)
 {
 	u8 cmode = chip->ports[port].cmode;
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.h b/drivers/net/dsa/mv88e6xxx/serdes.h
index 918306c2e287..72955f55e92c 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.h
+++ b/drivers/net/dsa/mv88e6xxx/serdes.h
@@ -108,7 +108,6 @@ struct phylink_link_state;
 int mv88e6xxx_pcs_decode_state(struct device *dev, u16 bmsr, u16 lpa,
 			       u16 status, struct phylink_link_state *state);
 
-int mv88e6185_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
 int mv88e6341_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
 int mv88e6352_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
 int mv88e6390_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
@@ -122,8 +121,6 @@ int mv88e6390_serdes_pcs_config(struct mv88e6xxx_chip *chip, int port,
 				int lane, unsigned int mode,
 				phy_interface_t interface,
 				const unsigned long *advertise);
-int mv88e6185_serdes_pcs_get_state(struct mv88e6xxx_chip *chip, int port,
-				   int lane, struct phylink_link_state *state);
 int mv88e6352_serdes_pcs_get_state(struct mv88e6xxx_chip *chip, int port,
 				   int lane, struct phylink_link_state *state);
 int mv88e6390_serdes_pcs_get_state(struct mv88e6xxx_chip *chip, int port,
@@ -142,8 +139,6 @@ unsigned int mv88e6352_serdes_irq_mapping(struct mv88e6xxx_chip *chip,
 					  int port);
 unsigned int mv88e6390_serdes_irq_mapping(struct mv88e6xxx_chip *chip,
 					  int port);
-int mv88e6185_serdes_power(struct mv88e6xxx_chip *chip, int port, int lane,
-			   bool up);
 int mv88e6352_serdes_power(struct mv88e6xxx_chip *chip, int port, int lane,
 			   bool on);
 int mv88e6390_serdes_power(struct mv88e6xxx_chip *chip, int port, int lane,
@@ -151,16 +146,12 @@ int mv88e6390_serdes_power(struct mv88e6xxx_chip *chip, int port, int lane,
 int mv88e6393x_serdes_power(struct mv88e6xxx_chip *chip, int port, int lane,
 			    bool on);
 int mv88e6393x_serdes_setup_errata(struct mv88e6xxx_chip *chip);
-int mv88e6097_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port, int lane,
-				bool enable);
 int mv88e6352_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port, int lane,
 				bool enable);
 int mv88e6390_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port, int lane,
 				bool enable);
 int mv88e6393x_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port,
 				 int lane, bool enable);
-irqreturn_t mv88e6097_serdes_irq_status(struct mv88e6xxx_chip *chip, int port,
-					int lane);
 irqreturn_t mv88e6352_serdes_irq_status(struct mv88e6xxx_chip *chip, int port,
 					int lane);
 irqreturn_t mv88e6390_serdes_irq_status(struct mv88e6xxx_chip *chip, int port,
@@ -250,4 +241,6 @@ mv88e6xxx_serdes_irq_status(struct mv88e6xxx_chip *chip, int port, int lane)
 	return chip->info->ops->serdes_irq_status(chip, port, lane);
 }
 
+int mv88e6185_pcs_init(struct mv88e6xxx_chip *chip, int port);
+
 #endif
-- 
2.30.2

