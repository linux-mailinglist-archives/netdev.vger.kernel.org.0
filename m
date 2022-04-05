Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F7944F41CA
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 23:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349586AbiDEUCH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 16:02:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1573367AbiDES5u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 14:57:50 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F0C3C8BF5
        for <netdev@vger.kernel.org>; Tue,  5 Apr 2022 11:55:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=NX3oZ68N8cBADa9iIhw5WvRWV9qY5iTZ7eFVhCIexyo=; b=io2h4mOh0ZBY6ZWULGwhUdaslp
        MQKIGNzYgjblJDOV6ue60NrxUbYZGAEZL/i/NIdj9pXLES/ACjBsfmMU7EcMaaVBn0B7qtxCxur6O
        1fDKXkEcY6UT7qFpVTsuzoHmxxHJOuN1ImCT9WTdQoWLdrksXLZiMptSyqqEHsNfoJbFHitAROp8t
        r2iOh0iRvH7TUDgI/EVg0qQ14+U9vwDt5dUCBlk65UMiyZC2L5NsoT9PYuv8dolvN87HX7BRTVO5K
        +I+6b34QN8JgfZMDjkrfjT/Bzs6RdGNBRD+932dGYpaO3EN8oBTqflkV8+enwVpnf8W2TiE/sgQMY
        CiB37CRw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58136)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nboLB-0001no-8j; Tue, 05 Apr 2022 19:55:44 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nboL8-0004QI-N0; Tue, 05 Apr 2022 19:55:42 +0100
Date:   Tue, 5 Apr 2022 19:55:42 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Conor Dooley <mail@conchuod.ie>
Cc:     Conor.Dooley@microchip.com, palmer@rivosinc.com,
        apatel@ventanamicro.com, netdev@vger.kernel.org,
        Nicolas.Ferre@microchip.com, Claudiu.Beznea@microchip.com,
        andrew@lunn.ch, hkallweit1@gmail.com,
        linux-riscv@lists.infradead.org
Subject: Re: riscv defconfig CONFIG_PM/macb/generic PHY regression in
 v5.18-rc1
Message-ID: <YkyQrgUCyLd1A2A1@shell.armlinux.org.uk>
References: <9f4b057d-1985-5fd3-65c0-f944161c7792@microchip.com>
 <Ykxl4m1uPPDktZnD@shell.armlinux.org.uk>
 <0415ff44-34fd-2f00-833d-fbcea3a967cb@conchuod.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0415ff44-34fd-2f00-833d-fbcea3a967cb@conchuod.ie>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 05, 2022 at 05:58:50PM +0100, Conor Dooley wrote:
> On 05/04/2022 16:53, Russell King (Oracle) wrote:
> > On Tue, Apr 05, 2022 at 01:05:12PM +0000, Conor.Dooley@microchip.com wrote:
> > > Hey,
> > > I seem to have come across a regression in the default riscv defconfig
> > > between riscv-for-linus-5.18-mw0 (bbde015227e8) & v5.18-rc1, exposed by
> > > c5179ef1ca0c ("RISC-V: Enable RISC-V SBI CPU Idle driver for QEMU virt
> > > machine") which causes the ethernet phy to not come up on my Icicle kit:
> > > [ 3.179864] macb 20112000.ethernet eth0: validation of sgmii with support 0000000,00000000,00006280 and advertisement 0000000,00000000,00004280 failed: -EINVAL
> > > [ 3.194490] macb 20112000.ethernet eth0: Could not attach PHY (-22)
> > 
> > I don't think that would be related to the idle driver. This looks like
> > the PHY hasn't filled in the supported mask at probe time - do you have
> > the driver for the PHY built-in or the PHY driver module loaded?
> 
> Hey Russel,
> The idle stuff enabled CONFIG_PM=y though in the default riscv
> defconfig, so it is not confined to just QEMU.
> 
> I am not sure what the symbol for the generic phy & I am not at work
> to properly check, so I hope this is the relevant part of the config:
> 
> CONFIG_PHYLINK=y
> CONFIG_PHYLIB=y
> CONFIG_SWPHY=y
> CONFIG_FIXED_PHY=y

The generic PHY is part of phylib, and will be used whenever phylib
wants to drive a PHY but no specific PHY driver is found at the point
the PHY device is attached in software to a network device.

For reference, that is a very important point to understand:

1) if the PHY driver is a module sitting on the root filesystem, but
the network driver attaches the PHY during boot before the root
filesystem is mounted, then the generic PHY driver will be used.

2) if the PHY driver is a module sitting on the root filesystem, and
the network driver attaches the PHY when the interface is brought up,
that is fine as long as the root filesystem is not network based.

> If you look at my response to Andrew [1] you'll see that my problems
> are not isolated to just the Generic PHY driver as a builtin Vitesse
> driver has issues too (although validation appears to have passed).

I've been catching up with email from the last three and a bit weeks,
so I haven't been reading all the threads before replying... there
will be some duplication between what Andrew and myself have said.

The right thing is certainly to use the Vitesse driver, and get to
the bottom of why the link won't come up when that driver is used.
I think from what I've been reading that it feels like a timing
issue - when cpu idle is enabled, then something affects the PHY
meaning that link never comes up.

The way this works with phylink in SGMII and in-band mode is that we
expect to read the link up/down, speed and duplex parameters from the
MAC/PCS end of the link, and the pause and link parameters from the
PHY. phylink will only report link up in this mode when the PHY and
the MAC/PCS both report that the link is up.

phylink should already contain sufficient debugging to work that out -
it prints at debug level whenever phylib reports a change to the link
parameters, and it also reports when the MAC/PCS triggers a change in
link state. That should be just about enough to work out which end of
the link is failing.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
