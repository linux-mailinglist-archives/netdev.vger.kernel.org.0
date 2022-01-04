Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3924348410B
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 12:41:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232434AbiADLlt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 06:41:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232327AbiADLls (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 06:41:48 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B350C061761;
        Tue,  4 Jan 2022 03:41:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=titoXQwkTQtPF0RW5RLXQyPOz3CoNfy3Us8bQFyRxUU=; b=V28Os2e9tG5qOMQm1tOh+sV0oG
        LMbJkmxjVzumYkf4Oi1e0V0qHh9f78zvfHfHXgyxnDtTOITJ4uhnhY3bhh0coJcgWumC1JLo3qAxf
        UWEbi2gjpmHm07yBqfE20wt1dYXZpRZTsAc8EAPFcNWbwR0TVi5+iK1mdlxchNpLvH2Oy32NhGRYs
        csFnqv27u6B2QMcKVB60I7vdNMsc4A0upm9qQaBj8okEY/WUNXk7J0YnSPuAI35GIAC+LuW+GAndT
        h6otIgSRX3pXfbXIpTGn5eAtAzHMt59YuJ/ZQCOkzzv+NABOyNhUCQbeX50IEjkvkdjuLx6xmwHen
        Uw84RKeg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56554)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1n4iCE-0006w1-MZ; Tue, 04 Jan 2022 11:41:42 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1n4iCC-0007Cn-T3; Tue, 04 Jan 2022 11:41:40 +0000
Date:   Tue, 4 Jan 2022 11:41:40 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
Cc:     linus.walleij@linaro.org, ulli.kroll@googlemail.com,
        kuba@kernel.org, davem@davemloft.net, andrew@lunn.ch,
        hkallweit1@gmail.com, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: net: phy: marvell: network working with generic PHY and not with
 marvell PHY
Message-ID: <YdQydK4GhI0P5RYL@shell.armlinux.org.uk>
References: <YdQoOSXS98+Af1wO@Red>
 <YdQsJnfqjaFrtC0m@shell.armlinux.org.uk>
 <YdQwexJVfrdzEfZK@Red>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YdQwexJVfrdzEfZK@Red>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 04, 2022 at 12:33:15PM +0100, Corentin Labbe wrote:
> Le Tue, Jan 04, 2022 at 11:14:46AM +0000, Russell King (Oracle) a écrit :
> > On Tue, Jan 04, 2022 at 11:58:01AM +0100, Corentin Labbe wrote:
> > > Hello
> > > 
> > > I have a gemini SSI 1328 box which has a cortina ethernet MAC with a Marvell 88E1118 as given by:
> > > Marvell 88E1118 gpio-0:01: attached PHY driver (mii_bus:phy_addr=gpio-0:01, irq=POLL)
> > > So booting with CONFIG_MARVELL_PHY=y lead to a non-working network with link set at 1Gbit
> > > Setting 'max-speed = <100>;' (as current state in mainline dtb) lead to a working network.
> > > By not working, I mean kernel started with ip=dhcp cannot get an IP.
> > 
> > How is the PHY connected to the host (which interface mode?) If it's
> > RGMII, it could be that the wrong RGMII interface mode is specified in
> > DT.
> > 
> 
> The PHY is set as RGMII in DT (arch/arm/boot/dts/gemini-ssi1328.dts)
> The only change to the mainline dtb is removing the max-speed.

So, it's using "rgmii" with no delay configured at the PHY with the
speed limited to 100Mbps. You then remove the speed limitation and
it doesn't work at 1Gbps.

I think I've seen this on other platforms (imx6 + ar8035) when the
RGMII delay is not correctly configured - it will work at slower
speeds but not 1G.

The RGMII spec specifies that there will be a delay - and the delay can
be introduced by either the MAC, PHY or by PCB track routing. It sounds
to me like your boot environment configures the PHY to introduce the
necessary delay, but then, because the DT "rgmii" mode means "no delay
at the PHY" when you use the Marvell driver (which respects that), the
Marvell driver configures the PHY for no delay, resulting in a non-
working situation at 1G.

I would suggest checking how the boot environment configures the PHY,
and change the "rgmii" mode in DT to match. There is a description of
the four RGMII modes in Documentation/networking/phy.rst that may help
understand what each one means.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
