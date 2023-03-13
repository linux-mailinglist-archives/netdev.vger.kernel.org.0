Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B08C6B8572
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 23:59:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbjCMW7M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 18:59:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbjCMW7I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 18:59:08 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF6E33C78D;
        Mon, 13 Mar 2023 15:58:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=hQAhFIXkwSE0gRmxGtQZbDk7OJOVM3UvlPBLhtkap6I=; b=LV2ZMtfcORpFnX1jZ25qRSnGtH
        qFW724J4HbDIezqqUiJKid+N9fsY1F4FlYNjsE7tMcy915S84c6JOV4n4egaqZw426u14AHUiJFBP
        nkeOcJIlFqX/4pTfpu9Z19oka20uxoMZXgWCM/Ly8gnlaiIR7XCizXT7Crx73R/4g4wnwAmiG0lYw
        2VcARPZkRVi96OZh322tp+2/D1O8jsRMSD2Z2fqKcpxKa4h/c/qJDB7N7RNjfyAGYQJV5rgTa+UwI
        pdsEdarMy4cen5NuWw1rRM64kE8y4qDs0AGQmUmVOlE4Wq166H3nJlbu3Ubk+ab+OmS2E2pAi8ZCS
        eX0RVCDQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:46584)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pbr6d-000425-Ox; Mon, 13 Mar 2023 22:57:27 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pbr6V-00088s-Rz; Mon, 13 Mar 2023 22:57:19 +0000
Date:   Mon, 13 Mar 2023 22:57:19 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Frank Wunderlich <frank-w@public-files.de>
Cc:     Daniel Golle <daniel@makrotopia.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Jianhui Zhao <zhaojh329@gmail.com>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        Alexander Couzens <lynxis@fe80.eu>
Subject: Re: Re: Re: Re: [PATCH net-next v12 08/18] net: ethernet:
 mtk_eth_soc: fix 1000Base-X and 2500Base-X modes
Message-ID: <ZA+qTyQ3n6YiURkQ@shell.armlinux.org.uk>
References: <ZAik+I1Ei+grJdUQ@makrotopia.org>
 <ZAioqp21521NsttV@shell.armlinux.org.uk>
 <trinity-79e9f0b8-a267-4bf9-a3d4-1ec691eb5238-1678536337569@3c-app-gmx-bs24>
 <ZAzd1A0SAKZK0hF5@shell.armlinux.org.uk>
 <4B891976-C29E-4D98-B604-3AC4507D3661@public-files.de>
 <ZAzk71mTxgV/pRxC@shell.armlinux.org.uk>
 <trinity-8577978d-1c11-4f6d-ae11-aef37e8b78b0-1678624836722@3c-app-gmx-bap51>
 <ZA4wlQ8P48aDhDly@shell.armlinux.org.uk>
 <ZA8B/kI0fLx4gkQm@shell.armlinux.org.uk>
 <trinity-93681801-f99c-40e2-9fbd-45888b3069aa-1678732740564@3c-app-gmx-bs66>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <trinity-93681801-f99c-40e2-9fbd-45888b3069aa-1678732740564@3c-app-gmx-bs66>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 13, 2023 at 07:39:00PM +0100, Frank Wunderlich wrote:
> > Gesendet: Montag, 13. März 2023 um 11:59 Uhr
> > Von: "Russell King (Oracle)" <linux@armlinux.org.uk>
> 
> > Since describing what I wanted you to test didn't work, here's a patch
> > instead, based upon the quirk that you provided (which is what I'd have
> > written anyway). Add a "#define DEBUG" to the top of
> > drivers/net/phy/phylink.c in addition to applying this patch, and please
> > test the resulting kernel, sending me the resulting kernel messages, and
> > also reporting whether this works or not.
> 
> Hi
> 
> thx for the patch...sorry for misunderstanding. i thought the sfp quirk only sets a flag and i need to change
> something in phylink.c to do the same as done on userspace, so i tried to simulate the userspace call there only for testing.
> 
> here relevant parts of debug
> 
> [    1.990637] sfp sfp-1: module OEM              SFP-2.5G-T       rev 1.0  sn SK2301110008     dc 230110  
> [    2.000147] mtk_soc_eth 15100000.ethernet eth1: optical SFP: interfaces=[mac=2-4,21-22, sfp=]

First thing... why are the SFP interfaces here empty? They should be
listing at least 22 for this SFP. Looking at the full log, you have
omitted:

[    2.008678] mtk_soc_eth 15100000.ethernet eth1: unsupported SFP module: no common interface modes

which seems to suggest that we need more than what I provided - and
is a big pointer to why it isn't working... and I guess has been there
all along.

This means that the interface configuration never gets updated, so
its pointless trying to add quirks etc. Error messages are rather
a key point.

So everything after this is just not relevant. Let's fix that. Here's
an updated patch which sets an interface mode for this SFP and sets a
link mode for it (although we use 2500baseX rather than baseT here
just to test this). I'm guessing it also does rate adaption, which we
will have to work out later.

Thanks.

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 1a2f074685fa..08eeffa96ae4 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -3001,7 +3001,8 @@ static int phylink_sfp_config_optical(struct phylink *pl)
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
index 39e3095796d0..5910c0e936a0 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -360,6 +360,21 @@ static void sfp_quirk_2500basex(const struct sfp_eeprom_id *id,
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
+	sfp_quirk_2500basex(id, modes, interfaces);
+	sfp_quirk_disable_autoneg(id, modes, interfaces);
+}
+
 static void sfp_quirk_ubnt_uf_instant(const struct sfp_eeprom_id *id,
 				      unsigned long *modes,
 				      unsigned long *interfaces)
@@ -401,6 +416,7 @@ static const struct sfp_quirk sfp_quirks[] = {
 	SFP_QUIRK_M("UBNT", "UF-INSTANT", sfp_quirk_ubnt_uf_instant),
 
 	SFP_QUIRK_F("OEM", "SFP-10G-T", sfp_fixup_rollball_cc),
+	SFP_QUIRK_M("OEM", "SFP-2.5G-T", sfp_quirk_oem_2_5g),
 	SFP_QUIRK_F("OEM", "RTSFP-10", sfp_fixup_rollball_cc),
 	SFP_QUIRK_F("OEM", "RTSFP-10G", sfp_fixup_rollball_cc),
 	SFP_QUIRK_F("Turris", "RTSFP-10", sfp_fixup_rollball),

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
