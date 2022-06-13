Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31C00548DA0
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 18:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345168AbiFMP3W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 11:29:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353857AbiFMP25 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 11:28:57 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 962B213F924
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 06:01:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=GnPUcciBsNHuHtc8e8A+9JTQ3Zlg1dFERbLWHWxlr7o=; b=Cc09cWgVuot1VfVaXb9i2xD+MT
        h5aADWOK9ejUL7WS0tszGGpB3MCJPf68zdKI5owMDgmmGiL2zWwrRvLEzT6BWDIV+8/U1/R9/kFzU
        7x5HDpeGCO9puiYucXU62FcWZiEm/INRyRel8ZwJgFsLfH7+q4j8MymP57i6EMdlTnL113JIpB/Fb
        HDwKm/wEVYIJFHMzxSwh2oSr4w6A7PSqBMj8e5LDlu9XieuhR3KlBVgulqETgGkEMcNgsq57/UmmH
        d6rfwUA0KY9Q9uV7mGK0Ksdwjz4zD8YS1cKfpdGcmj5HwYP7MPK+ppARxM++VpqAV9jY2Woe+/m04
        ii7O7NrA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:52106 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1o0jhK-0001tb-Ed; Mon, 13 Jun 2022 14:01:38 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1o0jhJ-000JZZ-Q5; Mon, 13 Jun 2022 14:01:37 +0100
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
Subject: [PATCH net-next 15/15] net: dsa: mv88e6xxx: cleanup after phylink_pcs
 conversion
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1o0jhJ-000JZZ-Q5@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Mon, 13 Jun 2022 14:01:37 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that mv88e6xxx is completely converted to using phylink_pcs
support, we have no need for the serdes methods. Remove all this
infrastructure. Also remove the __maybe_unused from
mv88e6xxx_pcs_select()

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/mv88e6xxx/chip.c   | 236 +----------------------------
 drivers/net/dsa/mv88e6xxx/chip.h   |  21 ---
 drivers/net/dsa/mv88e6xxx/port.c   |  30 ----
 drivers/net/dsa/mv88e6xxx/serdes.h |  45 ------
 4 files changed, 5 insertions(+), 327 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index a3cd3dadeb1f..39542b52f24a 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -495,81 +495,6 @@ static int mv88e6xxx_port_ppu_updates(struct mv88e6xxx_chip *chip, int port)
 	return !!(reg & MV88E6XXX_PORT_STS_PHY_DETECT);
 }
 
-static int mv88e6xxx_serdes_pcs_get_state(struct dsa_switch *ds, int port,
-					  struct phylink_link_state *state)
-{
-	struct mv88e6xxx_chip *chip = ds->priv;
-	int lane;
-	int err;
-
-	mv88e6xxx_reg_lock(chip);
-	lane = mv88e6xxx_serdes_get_lane(chip, port);
-	if (lane >= 0 && chip->info->ops->serdes_pcs_get_state)
-		err = chip->info->ops->serdes_pcs_get_state(chip, port, lane,
-							    state);
-	else
-		err = -EOPNOTSUPP;
-	mv88e6xxx_reg_unlock(chip);
-
-	return err;
-}
-
-static int mv88e6xxx_serdes_pcs_config(struct mv88e6xxx_chip *chip, int port,
-				       unsigned int mode,
-				       phy_interface_t interface,
-				       const unsigned long *advertise)
-{
-	const struct mv88e6xxx_ops *ops = chip->info->ops;
-	int lane;
-
-	if (ops->serdes_pcs_config) {
-		lane = mv88e6xxx_serdes_get_lane(chip, port);
-		if (lane >= 0)
-			return ops->serdes_pcs_config(chip, port, lane, mode,
-						      interface, advertise);
-	}
-
-	return 0;
-}
-
-static void mv88e6xxx_serdes_pcs_an_restart(struct dsa_switch *ds, int port)
-{
-	struct mv88e6xxx_chip *chip = ds->priv;
-	const struct mv88e6xxx_ops *ops;
-	int err = 0;
-	int lane;
-
-	ops = chip->info->ops;
-
-	if (ops->serdes_pcs_an_restart) {
-		mv88e6xxx_reg_lock(chip);
-		lane = mv88e6xxx_serdes_get_lane(chip, port);
-		if (lane >= 0)
-			err = ops->serdes_pcs_an_restart(chip, port, lane);
-		mv88e6xxx_reg_unlock(chip);
-
-		if (err)
-			dev_err(ds->dev, "p%d: failed to restart AN\n", port);
-	}
-}
-
-static int mv88e6xxx_serdes_pcs_link_up(struct mv88e6xxx_chip *chip, int port,
-					unsigned int mode,
-					int speed, int duplex)
-{
-	const struct mv88e6xxx_ops *ops = chip->info->ops;
-	int lane;
-
-	if (!phylink_autoneg_inband(mode) && ops->serdes_pcs_link_up) {
-		lane = mv88e6xxx_serdes_get_lane(chip, port);
-		if (lane >= 0)
-			return ops->serdes_pcs_link_up(chip, port, lane,
-						       speed, duplex);
-	}
-
-	return 0;
-}
-
 static const u8 mv88e6185_phy_interface_modes[] = {
 	[MV88E6185_PORT_STS_CMODE_GMII_FD]	 = PHY_INTERFACE_MODE_GMII,
 	[MV88E6185_PORT_STS_CMODE_MII_100_FD_PS] = PHY_INTERFACE_MODE_MII,
@@ -833,15 +758,8 @@ static void mv88e6xxx_get_caps(struct dsa_switch *ds, int port,
 		__set_bit(PHY_INTERFACE_MODE_GMII,
 			  config->supported_interfaces);
 
-	/* If we have a .pcs_init, or don't have a .serdes_pcs_get_state,
-	 * serdes_pcs_config, serdes_pcs_an_restart, or serdes_pcs_link_up,
-	 * we are not legacy.
-	 */
-	if (chip->info->ops->pcs_init ||
-	    (!chip->info->ops->serdes_pcs_get_state &&
-	     !chip->info->ops->serdes_pcs_config &&
-	     !chip->info->ops->serdes_pcs_an_restart &&
-	     !chip->info->ops->serdes_pcs_link_up))
+	/* If we have a .pcs_init, we are not legacy. */
+	if (chip->info->ops->pcs_init)
 		config->legacy_pre_march2020 = false;
 }
 
@@ -852,9 +770,9 @@ static struct phylink_pcs *mv88e6xxx_pcs_select(struct mv88e6xxx_chip *chip,
 	return chip->ports[port].pcs_private;
 }
 
-static struct phylink_pcs *__maybe_unused
-mv88e6xxx_mac_select_pcs(struct dsa_switch *ds, int port,
-			 phy_interface_t interface)
+static struct phylink_pcs *mv88e6xxx_mac_select_pcs(struct dsa_switch *ds,
+						    int port,
+						    phy_interface_t interface)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	struct phylink_pcs *pcs = NULL;
@@ -901,16 +819,6 @@ static void mv88e6xxx_mac_config(struct dsa_switch *ds, int port,
 						      state->interface);
 		if (err && err != -EOPNOTSUPP)
 			goto err_unlock;
-
-		err = mv88e6xxx_serdes_pcs_config(chip, port, mode,
-						  state->interface,
-						  state->advertising);
-		/* FIXME: we should restart negotiation if something changed -
-		 * which is something we get if we convert to using phylinks
-		 * PCS operations.
-		 */
-		if (err > 0)
-			err = 0;
 	}
 
 err_unlock:
@@ -994,17 +902,6 @@ static void mv88e6xxx_mac_link_up(struct dsa_switch *ds, int port,
 	 */
 	if (!mv88e6xxx_port_ppu_updates(chip, port) ||
 	    mode == MLO_AN_FIXED) {
-		/* FIXME: for an automedia port, should we force the link
-		 * down here - what if the link comes up due to "other" media
-		 * while we're bringing the port up, how is the exclusivity
-		 * handled in the Marvell hardware? E.g. port 2 on 88E6390
-		 * shared between internal PHY and Serdes.
-		 */
-		err = mv88e6xxx_serdes_pcs_link_up(chip, port, mode, speed,
-						   duplex);
-		if (err)
-			goto error;
-
 		if (ops->port_set_speed_duplex) {
 			err = ops->port_set_speed_duplex(chip, port,
 							 speed, duplex);
@@ -3175,102 +3072,6 @@ static int mv88e6xxx_setup_egress_floods(struct mv88e6xxx_chip *chip, int port)
 	return 0;
 }
 
-static irqreturn_t mv88e6xxx_serdes_irq_thread_fn(int irq, void *dev_id)
-{
-	struct mv88e6xxx_port *mvp = dev_id;
-	struct mv88e6xxx_chip *chip = mvp->chip;
-	irqreturn_t ret = IRQ_NONE;
-	int port = mvp->port;
-	int lane;
-
-	mv88e6xxx_reg_lock(chip);
-	lane = mv88e6xxx_serdes_get_lane(chip, port);
-	if (lane >= 0)
-		ret = mv88e6xxx_serdes_irq_status(chip, port, lane);
-	mv88e6xxx_reg_unlock(chip);
-
-	return ret;
-}
-
-static int mv88e6xxx_serdes_irq_request(struct mv88e6xxx_chip *chip, int port,
-					int lane)
-{
-	struct mv88e6xxx_port *dev_id = &chip->ports[port];
-	unsigned int irq;
-	int err;
-
-	/* Nothing to request if this SERDES port has no IRQ */
-	irq = mv88e6xxx_serdes_irq_mapping(chip, port);
-	if (!irq)
-		return 0;
-
-	snprintf(dev_id->serdes_irq_name, sizeof(dev_id->serdes_irq_name),
-		 "mv88e6xxx-%s-serdes-%d", dev_name(chip->dev), port);
-
-	/* Requesting the IRQ will trigger IRQ callbacks, so release the lock */
-	mv88e6xxx_reg_unlock(chip);
-	err = request_threaded_irq(irq, NULL, mv88e6xxx_serdes_irq_thread_fn,
-				   IRQF_ONESHOT, dev_id->serdes_irq_name,
-				   dev_id);
-	mv88e6xxx_reg_lock(chip);
-	if (err)
-		return err;
-
-	dev_id->serdes_irq = irq;
-
-	return mv88e6xxx_serdes_irq_enable(chip, port, lane);
-}
-
-static int mv88e6xxx_serdes_irq_free(struct mv88e6xxx_chip *chip, int port,
-				     int lane)
-{
-	struct mv88e6xxx_port *dev_id = &chip->ports[port];
-	unsigned int irq = dev_id->serdes_irq;
-	int err;
-
-	/* Nothing to free if no IRQ has been requested */
-	if (!irq)
-		return 0;
-
-	err = mv88e6xxx_serdes_irq_disable(chip, port, lane);
-
-	/* Freeing the IRQ will trigger IRQ callbacks, so release the lock */
-	mv88e6xxx_reg_unlock(chip);
-	free_irq(irq, dev_id);
-	mv88e6xxx_reg_lock(chip);
-
-	dev_id->serdes_irq = 0;
-
-	return err;
-}
-
-static int mv88e6xxx_serdes_power(struct mv88e6xxx_chip *chip, int port,
-				  bool on)
-{
-	int lane;
-	int err;
-
-	lane = mv88e6xxx_serdes_get_lane(chip, port);
-	if (lane < 0)
-		return 0;
-
-	if (on) {
-		err = mv88e6xxx_serdes_power_up(chip, port, lane);
-		if (err)
-			return err;
-
-		err = mv88e6xxx_serdes_irq_request(chip, port, lane);
-	} else {
-		err = mv88e6xxx_serdes_irq_free(chip, port, lane);
-		if (err)
-			return err;
-
-		err = mv88e6xxx_serdes_power_down(chip, port, lane);
-	}
-
-	return err;
-}
-
 static int mv88e6xxx_set_egress_port(struct mv88e6xxx_chip *chip,
 				     enum mv88e6xxx_egress_direction direction,
 				     int port)
@@ -3593,29 +3394,6 @@ static int mv88e6xxx_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
 	return ret;
 }
 
-static int mv88e6xxx_port_enable(struct dsa_switch *ds, int port,
-				 struct phy_device *phydev)
-{
-	struct mv88e6xxx_chip *chip = ds->priv;
-	int err;
-
-	mv88e6xxx_reg_lock(chip);
-	err = mv88e6xxx_serdes_power(chip, port, true);
-	mv88e6xxx_reg_unlock(chip);
-
-	return err;
-}
-
-static void mv88e6xxx_port_disable(struct dsa_switch *ds, int port)
-{
-	struct mv88e6xxx_chip *chip = ds->priv;
-
-	mv88e6xxx_reg_lock(chip);
-	if (mv88e6xxx_serdes_power(chip, port, false))
-		dev_err(chip->dev, "failed to power off SERDES\n");
-	mv88e6xxx_reg_unlock(chip);
-}
-
 static int mv88e6xxx_set_ageing_time(struct dsa_switch *ds,
 				     unsigned int ageing_time)
 {
@@ -6839,18 +6617,14 @@ static const struct dsa_switch_ops mv88e6xxx_switch_ops = {
 	.port_teardown		= mv88e6xxx_port_teardown,
 	.phylink_get_caps	= mv88e6xxx_get_caps,
 	.phylink_mac_select_pcs	= mv88e6xxx_mac_select_pcs,
-	.phylink_mac_link_state	= mv88e6xxx_serdes_pcs_get_state,
 	.phylink_mac_prepare	= mv88e6xxx_mac_prepare,
 	.phylink_mac_config	= mv88e6xxx_mac_config,
 	.phylink_mac_finish	= mv88e6xxx_mac_finish,
-	.phylink_mac_an_restart	= mv88e6xxx_serdes_pcs_an_restart,
 	.phylink_mac_link_down	= mv88e6xxx_mac_link_down,
 	.phylink_mac_link_up	= mv88e6xxx_mac_link_up,
 	.get_strings		= mv88e6xxx_get_strings,
 	.get_ethtool_stats	= mv88e6xxx_get_ethtool_stats,
 	.get_sset_count		= mv88e6xxx_get_sset_count,
-	.port_enable		= mv88e6xxx_port_enable,
-	.port_disable		= mv88e6xxx_port_disable,
 	.port_max_mtu		= mv88e6xxx_get_max_mtu,
 	.port_change_mtu	= mv88e6xxx_change_mtu,
 	.get_mac_eee		= mv88e6xxx_get_mac_eee,
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 55e1baa614af..88814583f4c6 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -277,8 +277,6 @@ struct mv88e6xxx_port {
 	u8 cmode;
 	bool mirror_ingress;
 	bool mirror_egress;
-	unsigned int serdes_irq;
-	char serdes_irq_name[64];
 	struct devlink_region *region;
 	void *pcs_private;
 };
@@ -573,10 +571,6 @@ struct mv88e6xxx_ops {
 
 	int (*mgmt_rsvd2cpu)(struct mv88e6xxx_chip *chip);
 
-	/* Power on/off a SERDES interface */
-	int (*serdes_power)(struct mv88e6xxx_chip *chip, int port, int lane,
-			    bool up);
-
 	/* SERDES lane mapping */
 	int (*serdes_get_lane)(struct mv88e6xxx_chip *chip, int port);
 
@@ -585,24 +579,9 @@ struct mv88e6xxx_ops {
 	struct phylink_pcs *(*pcs_select)(struct mv88e6xxx_chip *chip, int port,
 					  phy_interface_t mode);
 
-	int (*serdes_pcs_get_state)(struct mv88e6xxx_chip *chip, int port,
-				    int lane, struct phylink_link_state *state);
-	int (*serdes_pcs_config)(struct mv88e6xxx_chip *chip, int port,
-				 int lane, unsigned int mode,
-				 phy_interface_t interface,
-				 const unsigned long *advertise);
-	int (*serdes_pcs_an_restart)(struct mv88e6xxx_chip *chip, int port,
-				     int lane);
-	int (*serdes_pcs_link_up)(struct mv88e6xxx_chip *chip, int port,
-				  int lane, int speed, int duplex);
-
 	/* SERDES interrupt handling */
 	unsigned int (*serdes_irq_mapping)(struct mv88e6xxx_chip *chip,
 					   int port);
-	int (*serdes_irq_enable)(struct mv88e6xxx_chip *chip, int port, int lane,
-				 bool enable);
-	irqreturn_t (*serdes_irq_status)(struct mv88e6xxx_chip *chip, int port,
-					 int lane);
 
 	/* Statistics from the SERDES interface */
 	int (*serdes_get_sset_count)(struct mv88e6xxx_chip *chip, int port);
diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
index 795b3128768f..4209008b51e9 100644
--- a/drivers/net/dsa/mv88e6xxx/port.c
+++ b/drivers/net/dsa/mv88e6xxx/port.c
@@ -539,7 +539,6 @@ static int mv88e6xxx_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
 				    phy_interface_t mode, bool force)
 {
 	u16 cmode;
-	int lane;
 	u16 reg;
 	int err;
 
@@ -583,19 +582,6 @@ static int mv88e6xxx_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
 	if (cmode == chip->ports[port].cmode && !force)
 		return 0;
 
-	lane = mv88e6xxx_serdes_get_lane(chip, port);
-	if (lane >= 0) {
-		if (chip->ports[port].serdes_irq) {
-			err = mv88e6xxx_serdes_irq_disable(chip, port, lane);
-			if (err)
-				return err;
-		}
-
-		err = mv88e6xxx_serdes_power_down(chip, port, lane);
-		if (err)
-			return err;
-	}
-
 	chip->ports[port].cmode = 0;
 
 	if (cmode) {
@@ -611,22 +597,6 @@ static int mv88e6xxx_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
 			return err;
 
 		chip->ports[port].cmode = cmode;
-
-		lane = mv88e6xxx_serdes_get_lane(chip, port);
-		if (lane == -ENODEV)
-			return 0;
-		if (lane < 0)
-			return lane;
-
-		err = mv88e6xxx_serdes_power_up(chip, port, lane);
-		if (err)
-			return err;
-
-		if (chip->ports[port].serdes_irq) {
-			err = mv88e6xxx_serdes_irq_enable(chip, port, lane);
-			if (err)
-				return err;
-		}
 	}
 
 	return 0;
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.h b/drivers/net/dsa/mv88e6xxx/serdes.h
index d29d4d10a16d..a354a48d057b 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.h
+++ b/drivers/net/dsa/mv88e6xxx/serdes.h
@@ -150,24 +150,6 @@ static inline int mv88e6xxx_serdes_get_lane(struct mv88e6xxx_chip *chip,
 	return chip->info->ops->serdes_get_lane(chip, port);
 }
 
-static inline int mv88e6xxx_serdes_power_up(struct mv88e6xxx_chip *chip,
-					    int port, int lane)
-{
-	if (!chip->info->ops->serdes_power)
-		return -EOPNOTSUPP;
-
-	return chip->info->ops->serdes_power(chip, port, lane, true);
-}
-
-static inline int mv88e6xxx_serdes_power_down(struct mv88e6xxx_chip *chip,
-					      int port, int lane)
-{
-	if (!chip->info->ops->serdes_power)
-		return -EOPNOTSUPP;
-
-	return chip->info->ops->serdes_power(chip, port, lane, false);
-}
-
 static inline unsigned int
 mv88e6xxx_serdes_irq_mapping(struct mv88e6xxx_chip *chip, int port)
 {
@@ -177,33 +159,6 @@ mv88e6xxx_serdes_irq_mapping(struct mv88e6xxx_chip *chip, int port)
 	return chip->info->ops->serdes_irq_mapping(chip, port);
 }
 
-static inline int mv88e6xxx_serdes_irq_enable(struct mv88e6xxx_chip *chip,
-					      int port, int lane)
-{
-	if (!chip->info->ops->serdes_irq_enable)
-		return -EOPNOTSUPP;
-
-	return chip->info->ops->serdes_irq_enable(chip, port, lane, true);
-}
-
-static inline int mv88e6xxx_serdes_irq_disable(struct mv88e6xxx_chip *chip,
-					       int port, int lane)
-{
-	if (!chip->info->ops->serdes_irq_enable)
-		return -EOPNOTSUPP;
-
-	return chip->info->ops->serdes_irq_enable(chip, port, lane, false);
-}
-
-static inline irqreturn_t
-mv88e6xxx_serdes_irq_status(struct mv88e6xxx_chip *chip, int port, int lane)
-{
-	if (!chip->info->ops->serdes_irq_status)
-		return IRQ_NONE;
-
-	return chip->info->ops->serdes_irq_status(chip, port, lane);
-}
-
 int mv88e6185_pcs_init(struct mv88e6xxx_chip *chip, int port);
 
 int mv88e6352_pcs_init(struct mv88e6xxx_chip *chip, int port);
-- 
2.30.2

