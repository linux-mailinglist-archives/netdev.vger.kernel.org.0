Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3277C43E7EE
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 20:02:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbhJ1SFG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 14:05:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbhJ1SFG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 14:05:06 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90625C061570
        for <netdev@vger.kernel.org>; Thu, 28 Oct 2021 11:02:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=dTWLBobelvfm74btBNS5oMUe8LVxL6psLU7+W/vwjU0=; b=mN0tLxGyj0VXj4BVy09tRTqLuA
        ieU+HqKX8r7Vy2efIds9SZYRHWSGXuF4ZUbIeuJ0hy0bvshcKZPmGvthjRgo9YMhOU8ke9BnIZUZb
        JBnY19SBax3sk7SxVmsCQrdezxM3/NBzeAUnKmhOlPB/etz7VwKNcYytg6OSAg63z06cc3Q4+nKCG
        0EBU+Syg79NbzaITSBs7erK4OvQOJ0jv7WQ4LuJua9CJQWMxWF5BPOKXUJT0XLA13NUdZG5MlQcBv
        Du9WPovz12Zo5Bk/zKnjNJwEcz4el6c0AlGBuFkJicf+/wsbv1g4kL1pmy/TfCj1bbgxffgUmsi/t
        SQVxsx4g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55360)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mg9jW-0007rU-T5; Thu, 28 Oct 2021 19:02:34 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mg9jV-0000Xx-Jj; Thu, 28 Oct 2021 19:02:33 +0100
Date:   Thu, 28 Oct 2021 19:02:33 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: populate supported_interfaces member
Message-ID: <YXrluU0Rtq5NqsaH@shell.armlinux.org.uk>
References: <E1mg8lC-0020Yn-DA@rmk-PC.armlinux.org.uk>
 <75ed3a04-30dc-6df9-d336-1d908ec5316e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <75ed3a04-30dc-6df9-d336-1d908ec5316e@gmail.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 28, 2021 at 10:05:40AM -0700, Florian Fainelli wrote:
> On 10/28/21 10:00 AM, Russell King (Oracle) wrote:
> > From: =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
> > 
> > Add a new DSA switch operation, phylink_get_interfaces, which should
> > fill in which PHY_INTERFACE_MODE_* are supported by given port.
> > 
> > Use this before phylink_create() to fill phylinks supported_interfaces
> > member, allowing phylink to determine which PHY_INTERFACE_MODEs are
> > supported.
> > 
> > Signed-off-by: Marek Behún <kabel@kernel.org>
> > [tweaked patch and description to add more complete support -- rmk]
> > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> 
> No objection per-se, but don't we want to see a companion patch in the
> same series that make at least one driver implement phylink_get_interfaces?

The reason for posting it is so that Prasanna Vengateshan can start
making use of it with the lan937x driver.

I have mv88e6xxx _partially_ converted, but it's a right headache with
that one because of the shere number of devices - and I also don't have
full information for them. That said, those that do not fill out the
supported_interfaces won't change behaviour.

The patch is below, but it depends on another patch adding
mv88e6352_g2_scratch_port_has_serdes() since we need to know which
6352 port has been configured for use with the serdes, not which port
_happens_ to be indicating at boot time that it is in a mode that is
using the serdes. These are two entirely different things with the
6352.

I have no other DSA bridges, and the necessary information is probably
hidden behind NDAs, so will not be converting any others.

However, getting this hook in place in DSA so we can encourage new DSA
drivers to use this would be good.

8<=====
From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Subject: [PATCH] net: dsa: mv88e6xxx: populate supported_interfaces

Populate the supported interfaces for Marvell 88E6352, 88E6341,
88E6390, 88E6390X and 88E6393X family of switches.

We do the best effort for 88E6393X based on the information we have
available, but this is incomplete; for the 88E6391X, apparently only
one serdes port supports speeds greater than 1G, but we don't know
which port it is.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 207 ++++++++++++++++++++++++++++++-
 drivers/net/dsa/mv88e6xxx/chip.h |   2 +
 drivers/net/dsa/mv88e6xxx/port.h |   5 +
 3 files changed, 210 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 272b0535d946..6f9bdbbefcf6 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -676,11 +676,195 @@ static void mv88e6xxx_validate(struct dsa_switch *ds, int port,
 	bitmap_and(supported, supported, mask, __ETHTOOL_LINK_MODE_MASK_NBITS);
 	bitmap_and(state->advertising, state->advertising, mask,
 		   __ETHTOOL_LINK_MODE_MASK_NBITS);
+}
 
-	/* We can only operate at 2500BaseX or 1000BaseX.  If requested
-	 * to advertise both, only report advertising at 2500BaseX.
-	 */
-	phylink_helper_basex_speed(state);
+static const u8 mv88e6185_phy_interface_modes[] = {
+	[MV88E6185_PORT_STS_CMODE_GMII_FD]	 = PHY_INTERFACE_MODE_GMII,
+	[MV88E6185_PORT_STS_CMODE_MII_100_FD_PS] = PHY_INTERFACE_MODE_MII,
+	[MV88E6185_PORT_STS_CMODE_MII_100]	 = PHY_INTERFACE_MODE_MII,
+	[MV88E6185_PORT_STS_CMODE_MII_10]	 = PHY_INTERFACE_MODE_MII,
+	[MV88E6185_PORT_STS_CMODE_SERDES]	 = PHY_INTERFACE_MODE_1000BASEX,
+	[MV88E6185_PORT_STS_CMODE_1000BASE_X]	 = PHY_INTERFACE_MODE_1000BASEX,
+	[MV88E6185_PORT_STS_CMODE_PHY]		 = PHY_INTERFACE_MODE_SGMII,
+};
+
+static void mv88e6185_phylink_get_interfaces(struct mv88e6xxx_chip *chip,
+					     int port, unsigned long *supported)
+{
+	u8 cmode = chip->ports[port].cmode;
+
+	if (cmode <= ARRAY_SIZE(mv88e6185_phy_interface_modes) &&
+	    mv88e6185_phy_interface_modes[cmode])
+		__set_bit(mv88e6185_phy_interface_modes[cmode], supported);
+}
+
+static const u8 mv88e6xxx_phy_interface_modes[] = {
+	[MV88E6XXX_PORT_STS_CMODE_MII_PHY]	= PHY_INTERFACE_MODE_MII,
+	[MV88E6XXX_PORT_STS_CMODE_MII]		= PHY_INTERFACE_MODE_MII,
+	[MV88E6XXX_PORT_STS_CMODE_GMII]		= PHY_INTERFACE_MODE_GMII,
+	[MV88E6XXX_PORT_STS_CMODE_RMII_PHY]	= PHY_INTERFACE_MODE_RMII,
+	[MV88E6XXX_PORT_STS_CMODE_RMII]		= PHY_INTERFACE_MODE_RMII,
+	[MV88E6XXX_PORT_STS_CMODE_100BASEX]	= PHY_INTERFACE_MODE_100BASEX,
+	[MV88E6XXX_PORT_STS_CMODE_1000BASEX]	= PHY_INTERFACE_MODE_1000BASEX,
+	[MV88E6XXX_PORT_STS_CMODE_SGMII]	= PHY_INTERFACE_MODE_SGMII,
+	[MV88E6XXX_PORT_STS_CMODE_2500BASEX]	= PHY_INTERFACE_MODE_2500BASEX,
+	[MV88E6XXX_PORT_STS_CMODE_XAUI]		= PHY_INTERFACE_MODE_XAUI,
+	[MV88E6XXX_PORT_STS_CMODE_RXAUI]	= PHY_INTERFACE_MODE_RXAUI,
+};
+
+static void mv88e6xxx_translate_cmode(u8 cmode, unsigned long *supported)
+{
+	if (cmode < ARRAY_SIZE(mv88e6xxx_phy_interface_modes) &&
+		 mv88e6xxx_phy_interface_modes[cmode])
+		__set_bit(mv88e6xxx_phy_interface_modes[cmode], supported);
+	else if (cmode == MV88E6XXX_PORT_STS_CMODE_RGMII)
+		phy_interface_set_rgmii(supported);
+}
+
+static int mv88e6352_get_port4_serdes_cmode(struct mv88e6xxx_chip *chip)
+{
+	u16 reg, val;
+	int err;
+
+	mv88e6xxx_reg_lock(chip);
+	err = mv88e6xxx_port_read(chip, 4, MV88E6XXX_PORT_STS, &reg);
+	if (err)
+		goto unlock;
+
+	/* If PHY_DETECT is zero, then we are not in auto-media mode */
+	if (!(reg & MV88E6XXX_PORT_STS_PHY_DETECT)) {
+		val = 0xf;
+		goto unlock;
+	}
+
+	val = reg & ~MV88E6XXX_PORT_STS_PHY_DETECT;
+	err = mv88e6xxx_port_write(chip, 4, MV88E6XXX_PORT_STS, val);
+	if (err)
+		goto unlock;
+
+	err = mv88e6xxx_port_read(chip, 4, MV88E6XXX_PORT_STS, &val);
+	if (err)
+		goto unlock;
+
+	/* Restore PHY_DETECT value */
+	err = mv88e6xxx_port_write(chip, 4, MV88E6XXX_PORT_STS, reg);
+unlock:
+	mv88e6xxx_reg_unlock(chip);
+
+	return err ? err : (val & MV88E6XXX_PORT_STS_CMODE_MASK);
+}
+
+static void mv88e6352_phylink_get_interfaces(struct mv88e6xxx_chip *chip,
+					     int port, unsigned long *supported)
+{
+	int err, cmode;
+
+	/* Translate the default cmode */
+	mv88e6xxx_translate_cmode(chip->ports[port].cmode, supported);
+
+	/* Port 4 supports automedia if the serdes is associated with it. */
+	if (port == 4) {
+		mv88e6xxx_reg_lock(chip);
+		err = mv88e6352_g2_scratch_port_has_serdes(chip, port);
+		mv88e6xxx_reg_unlock(chip);
+		if (err <= 0)
+			return;
+
+		cmode = mv88e6352_get_port4_serdes_cmode(chip);
+		if (cmode >= 0)
+			mv88e6xxx_translate_cmode(cmode, supported);
+	}
+}
+
+static void mv88e6341_phylink_get_interfaces(struct mv88e6xxx_chip *chip,
+					     int port,
+					     unsigned long *supported)
+{
+	/* Translate the default cmode */
+	mv88e6xxx_translate_cmode(chip->ports[port].cmode, supported);
+}
+
+static void mv88e6390_phylink_get_interfaces(struct mv88e6xxx_chip *chip,
+					     int port,
+					     unsigned long *supported)
+{
+	/* Translate the default cmode */
+	mv88e6xxx_translate_cmode(chip->ports[port].cmode, supported);
+
+	/* The C_Mode field is programmable on ports 9 and 10 */
+	if (port == 9 || port == 10) {
+		__set_bit(PHY_INTERFACE_MODE_SGMII, supported);
+		__set_bit(PHY_INTERFACE_MODE_1000BASEX, supported);
+		__set_bit(PHY_INTERFACE_MODE_2500BASEX, supported);
+	}
+}
+
+static void mv88e6390x_phylink_get_interfaces(struct mv88e6xxx_chip *chip,
+					      int port,
+					      unsigned long *supported)
+{
+	mv88e6390_phylink_get_interfaces(chip, port, supported);
+
+	/* The C_Mode field can also be programmed for 10G speeds */
+	if (port == 9 || port == 10) {
+		__set_bit(PHY_INTERFACE_MODE_XAUI, supported);
+		__set_bit(PHY_INTERFACE_MODE_RXAUI, supported);
+	}
+}
+
+static const u8 mv88e6393x_phy_interface_modes[] = {
+	[MV88E6XXX_PORT_STS_CMODE_MII_PHY]	= PHY_INTERFACE_MODE_MII,
+	[MV88E6XXX_PORT_STS_CMODE_MII]		= PHY_INTERFACE_MODE_MII,
+	[MV88E6XXX_PORT_STS_CMODE_GMII]		= PHY_INTERFACE_MODE_GMII,
+	[MV88E6XXX_PORT_STS_CMODE_RMII_PHY]	= PHY_INTERFACE_MODE_RMII,
+	[MV88E6XXX_PORT_STS_CMODE_RMII]		= PHY_INTERFACE_MODE_RMII,
+	[MV88E6XXX_PORT_STS_CMODE_100BASEX]	= PHY_INTERFACE_MODE_100BASEX,
+	[MV88E6XXX_PORT_STS_CMODE_1000BASEX]	= PHY_INTERFACE_MODE_1000BASEX,
+	[MV88E6XXX_PORT_STS_CMODE_SGMII]	= PHY_INTERFACE_MODE_SGMII,
+	[MV88E6XXX_PORT_STS_CMODE_2500BASEX]	= PHY_INTERFACE_MODE_2500BASEX,
+	[MV88E6393X_PORT_STS_CMODE_5GBASER]	= PHY_INTERFACE_MODE_5GBASER,
+	[MV88E6393X_PORT_STS_CMODE_10GBASER]	= PHY_INTERFACE_MODE_10GBASER,
+	[MV88E6393X_PORT_STS_CMODE_USXGMII]	= PHY_INTERFACE_MODE_USXGMII,
+};
+
+static void mv88e6393x_phylink_get_interfaces(struct mv88e6xxx_chip *chip,
+					      int port,
+					      unsigned long *supported)
+{
+	u8 cmode = chip->ports[port].cmode;
+
+	if (cmode < ARRAY_SIZE(mv88e6393x_phy_interface_modes) &&
+	    mv88e6393x_phy_interface_modes[cmode])
+		__set_bit(mv88e6393x_phy_interface_modes[cmode], supported);
+
+	if (port == 0 || port == 9 || port == 10) {
+		/* Ports 0, 9 and 10 have read/write cmodes according to the
+		 * datasheet and erratum documents.
+		 *
+		 * FIXME: The original commit also says: "SERDESes can do
+		 * USXGMII, 10GBASER and 5GBASER (on 6191X only one SERDES
+		 * is capable of more than 1g; USXGMII is not yet supported
+		 * with this change)" We don't know which port supports 10G,
+		 * so lets assume they all do for the time being.
+		 */
+		__set_bit(PHY_INTERFACE_MODE_5GBASER, supported);
+		__set_bit(PHY_INTERFACE_MODE_10GBASER, supported);
+		__set_bit(PHY_INTERFACE_MODE_USXGMII, supported);
+	}
+}
+
+static void mv88e6xxx_get_interfaces(struct dsa_switch *ds, int port,
+				     unsigned long *supported)
+{
+	struct mv88e6xxx_chip *chip = ds->priv;
+
+	if (chip->info->ops->phylink_get_interfaces) {
+		chip->info->ops->phylink_get_interfaces(chip, port, supported);
+
+		/* Internal ports need GMII for PHYLIB */
+		if (mv88e6xxx_phy_is_internal(ds, port))
+			__set_bit(PHY_INTERFACE_MODE_GMII, supported);
+	}
 }
 
 static void mv88e6xxx_mac_config(struct dsa_switch *ds, int port,
@@ -3628,6 +3812,7 @@ static const struct mv88e6xxx_ops mv88e6141_ops = {
 	.serdes_get_stats = mv88e6390_serdes_get_stats,
 	.serdes_get_regs_len = mv88e6390_serdes_get_regs_len,
 	.serdes_get_regs = mv88e6390_serdes_get_regs,
+	.phylink_get_interfaces = mv88e6341_phylink_get_interfaces,
 	.phylink_validate = mv88e6341_phylink_validate,
 };
 
@@ -3803,6 +3988,7 @@ static const struct mv88e6xxx_ops mv88e6172_ops = {
 	.serdes_get_regs_len = mv88e6352_serdes_get_regs_len,
 	.serdes_get_regs = mv88e6352_serdes_get_regs,
 	.gpio_ops = &mv88e6352_gpio_ops,
+	.phylink_get_interfaces = mv88e6352_phylink_get_interfaces,
 	.phylink_validate = mv88e6352_phylink_validate,
 };
 
@@ -3903,6 +4089,7 @@ static const struct mv88e6xxx_ops mv88e6176_ops = {
 	.serdes_get_regs_len = mv88e6352_serdes_get_regs_len,
 	.serdes_get_regs = mv88e6352_serdes_get_regs,
 	.gpio_ops = &mv88e6352_gpio_ops,
+	.phylink_get_interfaces = mv88e6352_phylink_get_interfaces,
 	.phylink_validate = mv88e6352_phylink_validate,
 };
 
@@ -3942,6 +4129,7 @@ static const struct mv88e6xxx_ops mv88e6185_ops = {
 	.reset = mv88e6185_g1_reset,
 	.vtu_getnext = mv88e6185_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6185_g1_vtu_loadpurge,
+	.phylink_get_interfaces = mv88e6185_phylink_get_interfaces,
 	.phylink_validate = mv88e6185_phylink_validate,
 	.set_max_frame_size = mv88e6185_g1_set_max_frame_size,
 };
@@ -4004,6 +4192,7 @@ static const struct mv88e6xxx_ops mv88e6190_ops = {
 	.serdes_get_regs_len = mv88e6390_serdes_get_regs_len,
 	.serdes_get_regs = mv88e6390_serdes_get_regs,
 	.gpio_ops = &mv88e6352_gpio_ops,
+	.phylink_get_interfaces = mv88e6390_phylink_get_interfaces,
 	.phylink_validate = mv88e6390_phylink_validate,
 };
 
@@ -4065,6 +4254,7 @@ static const struct mv88e6xxx_ops mv88e6190x_ops = {
 	.serdes_get_regs_len = mv88e6390_serdes_get_regs_len,
 	.serdes_get_regs = mv88e6390_serdes_get_regs,
 	.gpio_ops = &mv88e6352_gpio_ops,
+	.phylink_get_interfaces = mv88e6390x_phylink_get_interfaces,
 	.phylink_validate = mv88e6390x_phylink_validate,
 };
 
@@ -4125,6 +4315,7 @@ static const struct mv88e6xxx_ops mv88e6191_ops = {
 	.serdes_get_regs = mv88e6390_serdes_get_regs,
 	.avb_ops = &mv88e6390_avb_ops,
 	.ptp_ops = &mv88e6352_ptp_ops,
+	.phylink_get_interfaces = mv88e6390_phylink_get_interfaces,
 	.phylink_validate = mv88e6390_phylink_validate,
 };
 
@@ -4185,6 +4376,7 @@ static const struct mv88e6xxx_ops mv88e6240_ops = {
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.avb_ops = &mv88e6352_avb_ops,
 	.ptp_ops = &mv88e6352_ptp_ops,
+	.phylink_get_interfaces = mv88e6352_phylink_get_interfaces,
 	.phylink_validate = mv88e6352_phylink_validate,
 };
 
@@ -4287,6 +4479,7 @@ static const struct mv88e6xxx_ops mv88e6290_ops = {
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.avb_ops = &mv88e6390_avb_ops,
 	.ptp_ops = &mv88e6352_ptp_ops,
+	.phylink_get_interfaces = mv88e6390_phylink_get_interfaces,
 	.phylink_validate = mv88e6390_phylink_validate,
 };
 
@@ -4439,6 +4632,7 @@ static const struct mv88e6xxx_ops mv88e6341_ops = {
 	.serdes_get_stats = mv88e6390_serdes_get_stats,
 	.serdes_get_regs_len = mv88e6390_serdes_get_regs_len,
 	.serdes_get_regs = mv88e6390_serdes_get_regs,
+	.phylink_get_interfaces = mv88e6341_phylink_get_interfaces,
 	.phylink_validate = mv88e6341_phylink_validate,
 };
 
@@ -4588,6 +4782,7 @@ static const struct mv88e6xxx_ops mv88e6352_ops = {
 	.serdes_get_stats = mv88e6352_serdes_get_stats,
 	.serdes_get_regs_len = mv88e6352_serdes_get_regs_len,
 	.serdes_get_regs = mv88e6352_serdes_get_regs,
+	.phylink_get_interfaces = mv88e6352_phylink_get_interfaces,
 	.phylink_validate = mv88e6352_phylink_validate,
 };
 
@@ -4653,6 +4848,7 @@ static const struct mv88e6xxx_ops mv88e6390_ops = {
 	.serdes_get_stats = mv88e6390_serdes_get_stats,
 	.serdes_get_regs_len = mv88e6390_serdes_get_regs_len,
 	.serdes_get_regs = mv88e6390_serdes_get_regs,
+	.phylink_get_interfaces = mv88e6390_phylink_get_interfaces,
 	.phylink_validate = mv88e6390_phylink_validate,
 };
 
@@ -4717,6 +4913,7 @@ static const struct mv88e6xxx_ops mv88e6390x_ops = {
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.avb_ops = &mv88e6390_avb_ops,
 	.ptp_ops = &mv88e6352_ptp_ops,
+	.phylink_get_interfaces = mv88e6390x_phylink_get_interfaces,
 	.phylink_validate = mv88e6390x_phylink_validate,
 };
 
@@ -4781,6 +4978,7 @@ static const struct mv88e6xxx_ops mv88e6393x_ops = {
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.avb_ops = &mv88e6390_avb_ops,
 	.ptp_ops = &mv88e6352_ptp_ops,
+	.phylink_get_interfaces = mv88e6393x_phylink_get_interfaces,
 	.phylink_validate = mv88e6393x_phylink_validate,
 };
 
@@ -6072,6 +6270,7 @@ static const struct dsa_switch_ops mv88e6xxx_switch_ops = {
 	.change_tag_protocol	= mv88e6xxx_change_tag_protocol,
 	.setup			= mv88e6xxx_setup,
 	.teardown		= mv88e6xxx_teardown,
+	.phylink_get_interfaces	= mv88e6xxx_get_interfaces,
 	.phylink_validate	= mv88e6xxx_validate,
 	.phylink_mac_link_state	= mv88e6xxx_serdes_pcs_get_state,
 	.phylink_mac_config	= mv88e6xxx_mac_config,
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 675b1f3e43b7..601c995cf4c7 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -599,6 +599,8 @@ struct mv88e6xxx_ops {
 	const struct mv88e6xxx_ptp_ops *ptp_ops;
 
 	/* Phylink */
+	void (*phylink_get_interfaces)(struct mv88e6xxx_chip *chip, int port,
+				       unsigned long *supported);
 	void (*phylink_validate)(struct mv88e6xxx_chip *chip, int port,
 				 unsigned long *mask,
 				 struct phylink_link_state *state);
diff --git a/drivers/net/dsa/mv88e6xxx/port.h b/drivers/net/dsa/mv88e6xxx/port.h
index b10e5aebacf6..e1ec966b7be9 100644
--- a/drivers/net/dsa/mv88e6xxx/port.h
+++ b/drivers/net/dsa/mv88e6xxx/port.h
@@ -42,6 +42,11 @@
 #define MV88E6XXX_PORT_STS_TX_PAUSED		0x0020
 #define MV88E6XXX_PORT_STS_FLOW_CTL		0x0010
 #define MV88E6XXX_PORT_STS_CMODE_MASK		0x000f
+#define MV88E6XXX_PORT_STS_CMODE_MII_PHY	0x0001
+#define MV88E6XXX_PORT_STS_CMODE_MII		0x0002
+#define MV88E6XXX_PORT_STS_CMODE_GMII		0x0003
+#define MV88E6XXX_PORT_STS_CMODE_RMII_PHY	0x0004
+#define MV88E6XXX_PORT_STS_CMODE_RMII		0x0005
 #define MV88E6XXX_PORT_STS_CMODE_RGMII		0x0007
 #define MV88E6XXX_PORT_STS_CMODE_100BASEX	0x0008
 #define MV88E6XXX_PORT_STS_CMODE_1000BASEX	0x0009
-- 
2.30.2


-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
