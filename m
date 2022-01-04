Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E913D484187
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 13:12:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232933AbiADMMC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 07:12:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232904AbiADMMC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 07:12:02 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5D2AC061761;
        Tue,  4 Jan 2022 04:12:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=TFFCZLl2eneLOZlZGY6q1GbZK+goF4stAeNLc8bB24Y=; b=JCsLKVY7+IepRwzG9OQSMg6lT+
        /uyxZw8iWsDVhcp+SZvOAmra5nAV9LuRlZaqkLF7tqh72Q0ShevMHPEKRbl8w6+q2pVQXba8+8n/M
        57REDZWuEiMI7FndL/P4ASTgetgSuP1VQNGus36htmpQLr0ZuzW2iAeZc064CdDopwWqk7lI9f8er
        K5JUbmK9xibXOKguOlREFBmL+C/nCHTnseyoloKuOEMU/oL3uUnz1KUjHk6J/ET/zAkSTDlE4dHE+
        ujEi7eCNqGrvoRiAhGf69TjN7s6e+/FF1JIJDs6J2eRrBceWFoW2SRZoP1NEpZns3oXzNaoaccIbL
        Lofdm+Bw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56556)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1n4ifU-0006ym-SF; Tue, 04 Jan 2022 12:11:56 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1n4ifT-0007Dp-Rq; Tue, 04 Jan 2022 12:11:55 +0000
Date:   Tue, 4 Jan 2022 12:11:55 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
Cc:     linus.walleij@linaro.org, ulli.kroll@googlemail.com,
        kuba@kernel.org, davem@davemloft.net, andrew@lunn.ch,
        hkallweit1@gmail.com, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: net: phy: marvell: network working with generic PHY and not with
 marvell PHY
Message-ID: <YdQ5i+//UITSbxS/@shell.armlinux.org.uk>
References: <YdQoOSXS98+Af1wO@Red>
 <YdQsJnfqjaFrtC0m@shell.armlinux.org.uk>
 <YdQwexJVfrdzEfZK@Red>
 <YdQydK4GhI0P5RYL@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YdQydK4GhI0P5RYL@shell.armlinux.org.uk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 04, 2022 at 11:41:40AM +0000, Russell King (Oracle) wrote:
> On Tue, Jan 04, 2022 at 12:33:15PM +0100, Corentin Labbe wrote:
> > Le Tue, Jan 04, 2022 at 11:14:46AM +0000, Russell King (Oracle) a écrit :
> > > On Tue, Jan 04, 2022 at 11:58:01AM +0100, Corentin Labbe wrote:
> > > > Hello
> > > > 
> > > > I have a gemini SSI 1328 box which has a cortina ethernet MAC with a Marvell 88E1118 as given by:
> > > > Marvell 88E1118 gpio-0:01: attached PHY driver (mii_bus:phy_addr=gpio-0:01, irq=POLL)
> > > > So booting with CONFIG_MARVELL_PHY=y lead to a non-working network with link set at 1Gbit
> > > > Setting 'max-speed = <100>;' (as current state in mainline dtb) lead to a working network.
> > > > By not working, I mean kernel started with ip=dhcp cannot get an IP.
> > > 
> > > How is the PHY connected to the host (which interface mode?) If it's
> > > RGMII, it could be that the wrong RGMII interface mode is specified in
> > > DT.
> > > 
> > 
> > The PHY is set as RGMII in DT (arch/arm/boot/dts/gemini-ssi1328.dts)
> > The only change to the mainline dtb is removing the max-speed.
> 
> So, it's using "rgmii" with no delay configured at the PHY with the
> speed limited to 100Mbps. You then remove the speed limitation and
> it doesn't work at 1Gbps.
> 
> I think I've seen this on other platforms (imx6 + ar8035) when the
> RGMII delay is not correctly configured - it will work at slower
> speeds but not 1G.
> 
> The RGMII spec specifies that there will be a delay - and the delay can
> be introduced by either the MAC, PHY or by PCB track routing. It sounds
> to me like your boot environment configures the PHY to introduce the
> necessary delay, but then, because the DT "rgmii" mode means "no delay
> at the PHY" when you use the Marvell driver (which respects that), the
> Marvell driver configures the PHY for no delay, resulting in a non-
> working situation at 1G.
> 
> I would suggest checking how the boot environment configures the PHY,
> and change the "rgmii" mode in DT to match. There is a description of
> the four RGMII modes in Documentation/networking/phy.rst that may help
> understand what each one means.

Hmm. Sorry, I'm leading you stray. It looks like the 88E1118 code does
not program any delays depending on the interface mode, so changing that
will have no effect.

I suspect, looking at m88e1118_config_init(), that the write to register
0x15 in the MSCR page could be the problem.

0x15 is 21, which is MII_88E1121_PHY_MSCR_REG. In other Marvell PHYs,
bits 4 and 5 are the tx and rx delays, both of which are set. Looking
at m88e1121_config_aneg_rgmii_delays(), this would seem to indicate
that the PHY is being placed into rgmii-id mode.

Can you try changing:

	err = phy_write(phydev, 0x15, 0x1070);

to:

	err = phy_write(phydev, 0x15, 0x1040);

and see what happens? Maybe trying other combinations of bits 4 and 5
to find a working combination.

I think if we discover a setting there that works, we may have a problem,
since changing this could end up breaking some platforms. Looking at the
commit history...

2f495c398edc net/phy/marvell: Expose IDs and flags in a .h and add dns323 LEDs setup flag
605f196efbf8 phy: Add support for Marvell 88E1118 PHY

and the second is a less than helpful commit message...

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
