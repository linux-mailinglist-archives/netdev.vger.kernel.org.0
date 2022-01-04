Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B36848418E
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 13:17:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232959AbiADMRS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 07:17:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232527AbiADMRS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 07:17:18 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAB08C061761;
        Tue,  4 Jan 2022 04:17:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=QqWNNemBUxEL73cqzXct8FhwcLpCWeQp6HEGpBCZd58=; b=Cpl6L30xc2G9MnJjhbKZB6Csyo
        HnS/0WSvJfxIfiYlIvE1dNSdlzeMqdBTZOhSfdDYp/UMnkGk+peNb6vIFc2H3sck1lP7NRhTiC61T
        Vzcj8/Rg0vme1rQHjSbkQcNad1ORYuOAJzKcsKZhtT1X9OZYcd7K+M4hF8BtvoIA1MJZnP21e5jfP
        vs3anQNVkdeSiL+RgoOc5XZZ86aNnWMCd3krdz9xlkcSF5xiAQ+x112naoHIFC1+6R9f0SLAhPfkR
        BQfMpC7zO7RAYUQUAOwdq2ysXhVUQQn6psuxbkGUh4X87ab8t+zrllexaAFF8JEgMCmGxptgLY0sY
        ADlKL/RQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56558)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1n4ika-0006zG-VR; Tue, 04 Jan 2022 12:17:12 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1n4ikZ-0007E0-R6; Tue, 04 Jan 2022 12:17:11 +0000
Date:   Tue, 4 Jan 2022 12:17:11 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
Cc:     linus.walleij@linaro.org, ulli.kroll@googlemail.com,
        kuba@kernel.org, davem@davemloft.net, andrew@lunn.ch,
        hkallweit1@gmail.com, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: net: phy: marvell: network working with generic PHY and not with
 marvell PHY
Message-ID: <YdQ6x2Mz2lOJOQdp@shell.armlinux.org.uk>
References: <YdQoOSXS98+Af1wO@Red>
 <YdQsJnfqjaFrtC0m@shell.armlinux.org.uk>
 <YdQwexJVfrdzEfZK@Red>
 <YdQydK4GhI0P5RYL@shell.armlinux.org.uk>
 <YdQ46conUeZ3Qaac@Red>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YdQ46conUeZ3Qaac@Red>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 04, 2022 at 01:09:13PM +0100, Corentin Labbe wrote:
> Le Tue, Jan 04, 2022 at 11:41:40AM +0000, Russell King (Oracle) a écrit :
> > On Tue, Jan 04, 2022 at 12:33:15PM +0100, Corentin Labbe wrote:
> > > Le Tue, Jan 04, 2022 at 11:14:46AM +0000, Russell King (Oracle) a écrit :
> > > > On Tue, Jan 04, 2022 at 11:58:01AM +0100, Corentin Labbe wrote:
> > > > > Hello
> > > > > 
> > > > > I have a gemini SSI 1328 box which has a cortina ethernet MAC with a Marvell 88E1118 as given by:
> > > > > Marvell 88E1118 gpio-0:01: attached PHY driver (mii_bus:phy_addr=gpio-0:01, irq=POLL)
> > > > > So booting with CONFIG_MARVELL_PHY=y lead to a non-working network with link set at 1Gbit
> > > > > Setting 'max-speed = <100>;' (as current state in mainline dtb) lead to a working network.
> > > > > By not working, I mean kernel started with ip=dhcp cannot get an IP.
> > > > 
> > > > How is the PHY connected to the host (which interface mode?) If it's
> > > > RGMII, it could be that the wrong RGMII interface mode is specified in
> > > > DT.
> > > > 
> > > 
> > > The PHY is set as RGMII in DT (arch/arm/boot/dts/gemini-ssi1328.dts)
> > > The only change to the mainline dtb is removing the max-speed.
> > 
> > So, it's using "rgmii" with no delay configured at the PHY with the
> > speed limited to 100Mbps. You then remove the speed limitation and
> > it doesn't work at 1Gbps.
> > 
> > I think I've seen this on other platforms (imx6 + ar8035) when the
> > RGMII delay is not correctly configured - it will work at slower
> > speeds but not 1G.
> > 
> > The RGMII spec specifies that there will be a delay - and the delay can
> > be introduced by either the MAC, PHY or by PCB track routing. It sounds
> > to me like your boot environment configures the PHY to introduce the
> > necessary delay, but then, because the DT "rgmii" mode means "no delay
> > at the PHY" when you use the Marvell driver (which respects that), the
> > Marvell driver configures the PHY for no delay, resulting in a non-
> > working situation at 1G.
> > 
> > I would suggest checking how the boot environment configures the PHY,
> > and change the "rgmii" mode in DT to match. There is a description of
> > the four RGMII modes in Documentation/networking/phy.rst that may help
> > understand what each one means.
> > 
> 
> So if I understand, the generic PHY does not touch delays and so values set by bootloader are kept.

Correct - the RGMII delays are not part of the standard 802.3 clause 22
register set, so the generic driver has no knowledge how to change
these.

> The boot environment give no clue on how the PHY is set.
> Only debug showed is:
> PHY 0 Addr 1 Vendor ID: 0x01410e11
> mii_write: phy_addr=0x1 reg_addr=0x4 value=0x5e1 
> mii_write: phy_addr=0x1 reg_addr=0x9 value=0x300 
> mii_write: phy_addr=0x1 reg_addr=0x0 value=0x1200 
> mii_write: phy_addr=0x1 reg_addr=0x0 value=0x9200 
> mii_write: phy_addr=0x1 reg_addr=0x0 value=0x1200

Hmm, it doesn't. The first two register writes set the advertisement.
The last three are just the PHY reset.

> Does it is possible to dump PHY registers when using generic PHY and
> find delay values ? For example ethtool -d eth0 ?

Even if that were possible, Marvell PHYs use a paged scheme to access
configuration registers, so merely reading the 32 registers would
probably not help. However, see my follow-up to my previous reply for
some further thoughts.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
