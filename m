Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3783E6B8F57
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 11:10:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbjCNKKp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 06:10:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbjCNKKh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 06:10:37 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6616199D53;
        Tue, 14 Mar 2023 03:10:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=VQ33iZJmnaGPLs1JKyJHobUOGjRoWRzrCfXEf5N8Wt0=; b=PZcFPjanUJDU928agC8qijdUmR
        qSng2Mtwp9Oy2jB626Q4/beZ4eFmgF5zs5aL3oTiNCMKpDGEM0VaPJKoHLU19mZ1gPxfKlOClVdSf
        V1iFa7hnRvYCpguQ/tLf6OiIZLLk1sFLkYhr1Unt/5hyj9LIlWoyQycFXjaKNyAnbPJcKngv9QV+r
        yt/uCe6Xan1qhoKXBhiyUZi2MHWuJb+aVjXf9MJTKYVM/Mo9WhK71Wk0fLdxk6stGVhGB02O/1fYo
        /HIODuxEfnROsx2wOT4/iSm5F7Z9z8+k6wbVHhOR1J21J1ZCVdzmUVgwA2dxpMrGk2gR6cj7JoEpD
        E+ptmNAw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:38744)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pc1bq-0004o6-Nh; Tue, 14 Mar 2023 10:10:22 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pc1bq-0000GN-3D; Tue, 14 Mar 2023 10:10:22 +0000
Date:   Tue, 14 Mar 2023 10:10:22 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Frank Wunderlich <frank-w@public-files.de>
Cc:     Daniel Golle <daniel@makrotopia.org>, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v12 08/18] net: ethernet: mtk_eth_soc: fix
 1000Base-X and 2500Base-X modes
Message-ID: <ZBBIDqZaqdSfwu9g@shell.armlinux.org.uk>
References: <4B891976-C29E-4D98-B604-3AC4507D3661@public-files.de>
 <ZAzk71mTxgV/pRxC@shell.armlinux.org.uk>
 <trinity-8577978d-1c11-4f6d-ae11-aef37e8b78b0-1678624836722@3c-app-gmx-bap51>
 <ZA4wlQ8P48aDhDly@shell.armlinux.org.uk>
 <ZA8B/kI0fLx4gkQm@shell.armlinux.org.uk>
 <trinity-93681801-f99c-40e2-9fbd-45888b3069aa-1678732740564@3c-app-gmx-bs66>
 <ZA+qTyQ3n6YiURkQ@shell.armlinux.org.uk>
 <trinity-e2c457f1-c897-45f1-907a-8ea3664b7512-1678783872771@3c-app-gmx-bap66>
 <ZBA6gszARdJY26Mz@shell.armlinux.org.uk>
 <trinity-bc4bbf4e-812a-4682-ac8c-5178320467f5-1678788102813@3c-app-gmx-bap66>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <trinity-bc4bbf4e-812a-4682-ac8c-5178320467f5-1678788102813@3c-app-gmx-bap66>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 11:01:42AM +0100, Frank Wunderlich wrote:
> Hi
> 
> > Gesendet: Dienstag, 14. März 2023 um 10:12 Uhr
> > Von: "Russell King (Oracle)" <linux@armlinux.org.uk>
> > On Tue, Mar 14, 2023 at 09:51:12AM +0100, Frank Wunderlich wrote:
> > > Hi,
> > > 
> > > at least the error-message is gone, and interface gets up when i call ethtoo to switch off autoneg.
> ...
> > > [   34.400860] mtk_soc_eth 15100000.ethernet eth1: phylink_mac_config: mode=inband/2500base-x/Unknown/Unknown/none adv=00,00000000,00000000,0000e400 pause=04 link=0 an=1
> > 
> > Looking good - apart from that pesky an=1 (which isn't used by the PCS
> > driver, and I've been thinking of killing it off anyway.) Until such
> > time that happens, we really ought to set that correctly, which means
> > an extra bit is needed in phylink_sfp_set_config(). However, this
> > should not affect anything.
> > 
> > > root@bpi-r3:~# 
> > > root@bpi-r3:~# ethtool -s eth1 autoneg off
> > > root@bpi-r3:~# [  131.031902] mtk_soc_eth 15100000.ethernet eth1: Link is Up - 2.5Gbps/Full - flow control off
> > > [  131.040366] IPv6: ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
> > > 
> > > full log here:
> > > https://pastebin.com/yDC7PuM2
> > > 
> > > i see that an is still 1..maybe because of the fixed value here?
> > > 
> > > https://elixir.bootlin.com/linux/v6.3-rc1/source/drivers/net/phy/phylink.c#L3038
> > 
> > Not sure what that line has to do with it - this is what the above
> > points to:
> > 
> >         phylink_sfp_set_config(pl, MLO_AN_INBAND, pl->sfp_support, &config);
> 
> MLO_AN_INBAND => may cause the an=1 and mode=inband if previously (?) disabled :)

For 802.3z modes, MLO_AN_INBAND with Autoneg clear in the advertising mode
disables in-band negotiation. This is exactly how "ethtool -s ethX
autoneg off" works.

> > The patch below should result in ethtool reporting 2500baseT rather than
> > 2500baseX, and that an=1 should now be an=0. Please try it, and dump the
> > ethtool eth1 before asking for autoneg to be manually disabled, and also
> > report the kernel messages.
> 
> i see no Patch below ;)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 1a2f074685fa..b8844dfcbf51 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -2898,6 +2898,10 @@ static void phylink_sfp_set_config(struct phylink *pl, u8 mode,
 		changed = true;
 	}
 
+	if (pl->link_config.an_enabled != state->an_enabled)
+		changed = true;
+	pl->link_config.an_enabled = state->an_enabled;
+
 	if (pl->cur_link_an_mode != mode ||
 	    pl->link_config.interface != state->interface) {
 		pl->cur_link_an_mode = mode;
@@ -3001,7 +3005,8 @@ static int phylink_sfp_config_optical(struct phylink *pl)
 	config.speed = SPEED_UNKNOWN;
 	config.duplex = DUPLEX_UNKNOWN;
 	config.pause = MLO_PAUSE_AN;
-	config.an_enabled = true;
+	config.an_enabled = linkmode_test_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
+					      support);
 
 	/* For all the interfaces that are supported, reduce the sfp_support
 	 * mask to only those link modes that can be supported.
diff --git a/drivers/net/phy/sfp-bus.c b/drivers/net/phy/sfp-bus.c
index daac293e8ede..1dd50f2ca05d 100644
--- a/drivers/net/phy/sfp-bus.c
+++ b/drivers/net/phy/sfp-bus.c
@@ -151,6 +151,10 @@ void sfp_parse_support(struct sfp_bus *bus, const struct sfp_eeprom_id *id,
 	unsigned int br_min, br_nom, br_max;
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(modes) = { 0, };
 
+	phylink_set(modes, Autoneg);
+	phylink_set(modes, Pause);
+	phylink_set(modes, Asym_Pause);
+
 	/* Decode the bitrate information to MBd */
 	br_min = br_nom = br_max = 0;
 	if (id->base.br_nominal) {
@@ -329,10 +333,6 @@ void sfp_parse_support(struct sfp_bus *bus, const struct sfp_eeprom_id *id,
 		bus->sfp_quirk->modes(id, modes, interfaces);
 
 	linkmode_or(support, support, modes);
-
-	phylink_set(support, Autoneg);
-	phylink_set(support, Pause);
-	phylink_set(support, Asym_Pause);
 }
 EXPORT_SYMBOL_GPL(sfp_parse_support);
 
diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 39e3095796d0..9c1fa0b1737f 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -360,6 +360,23 @@ static void sfp_quirk_2500basex(const struct sfp_eeprom_id *id,
 	__set_bit(PHY_INTERFACE_MODE_2500BASEX, interfaces);
 }
 
+static void sfp_quirk_disable_autoneg(const struct sfp_eeprom_id *id,
+				      unsigned long *modes,
+				      unsigned long *interfaces)
+{
+	linkmode_clear_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, modes);
+}
+
+static void sfp_quirk_oem_2_5g(const struct sfp_eeprom_id *id,
+			       unsigned long *modes,
+			       unsigned long *interfaces)
+{
+	/* Copper 2.5G SFP */
+	linkmode_set_bit(ETHTOOL_LINK_MODE_2500baseT_Full_BIT, modes);
+	__set_bit(PHY_INTERFACE_MODE_2500BASEX, interfaces);
+	sfp_quirk_disable_autoneg(id, modes, interfaces);
+}
+
 static void sfp_quirk_ubnt_uf_instant(const struct sfp_eeprom_id *id,
 				      unsigned long *modes,
 				      unsigned long *interfaces)
@@ -401,6 +418,7 @@ static const struct sfp_quirk sfp_quirks[] = {
 	SFP_QUIRK_M("UBNT", "UF-INSTANT", sfp_quirk_ubnt_uf_instant),
 
 	SFP_QUIRK_F("OEM", "SFP-10G-T", sfp_fixup_rollball_cc),
+	SFP_QUIRK_M("OEM", "SFP-2.5G-T", sfp_quirk_oem_2_5g),
 	SFP_QUIRK_F("OEM", "RTSFP-10", sfp_fixup_rollball_cc),
 	SFP_QUIRK_F("OEM", "RTSFP-10G", sfp_fixup_rollball_cc),
 	SFP_QUIRK_F("Turris", "RTSFP-10", sfp_fixup_rollball),

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
