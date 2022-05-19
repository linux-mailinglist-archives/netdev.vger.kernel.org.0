Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A472152D73B
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 17:16:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240623AbiESPQW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 11:16:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234118AbiESPPx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 11:15:53 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD06AEBEA1;
        Thu, 19 May 2022 08:15:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Dc2ke5NcQ5lIuFlKoA7A3ChISVicawrM3SfBe9e5al0=; b=tYaeLioJ6Vr4CMOiQCTASxyU0Q
        AdLcgN5gVnKse0kFX0Qz57VnRgcJ4bCIaxAdJfvKiQ8pUPhUtt19ebmo6wgBNcBSFKIxotA3Zr2pB
        eI2c2/fwtmhv57UI9F/GCFatDCNKcqAh32hPcIQKq7XmgeR1hBsJTJEY4G+OZGHwxCj98dtjpX03B
        6bN7outbhnlpLTA5V4csr3OOH5P/jUWJNCFeySXO+yrBsyUIXMOM37GghUqLfsilrTJEUVuk1dHwr
        wYuYdB3X5eThTakugqrA57+ITmwi9DLEkRdbi96a1M1QJ8A0NQ4EjJ8XarX4StQ+EylGvrr6Rln+O
        OXEAA/8g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:60776)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nrhsF-000476-MW; Thu, 19 May 2022 16:15:36 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nrhsC-0006fR-Bo; Thu, 19 May 2022 16:15:32 +0100
Date:   Thu, 19 May 2022 16:15:32 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Saravana Kannan <saravanak@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        John Stultz <jstultz@google.com>,
        Alvin =?utf-8?B?4pS8w6FpcHJhZ2E=?= <alsi@bang-olufsen.dk>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [RFC PATCH net 0/2] Make phylink and DSA wait for PHY driver
 that defers probe
Message-ID: <YoZfFDdSDLUtn42S@shell.armlinux.org.uk>
References: <20220513233640.2518337-1-vladimir.oltean@nxp.com>
 <Yn72l3O6yI7YstMf@lunn.ch>
 <20220519145936.3ofmmnrehydba7t6@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220519145936.3ofmmnrehydba7t6@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 19, 2022 at 02:59:36PM +0000, Vladimir Oltean wrote:
> Hi Andrew,
> 
> On Sat, May 14, 2022 at 02:23:51AM +0200, Andrew Lunn wrote:
> > There is a very different approach, which might be simpler.
> > 
> > We know polling will always work. And it should be possible to
> > transition between polling and interrupt at any point, so long as the
> > phylock is held. So if you get -EPROBE_DEFFER during probe, mark some
> > state in phydev that there should be an irq, but it is not around yet.
> > When the phy is started, and phylib starts polling, look for the state
> > and try getting the IRQ again. If successful, swap to interrupts, if
> > not, keep polling. Maybe after 60 seconds of polling and trying, give
> > up trying to find the irq and stick with polling.
> 
> That doesn't sound like something that I'd backport to stable kernels.
> Letting the PHY driver dynamically switch from poll to IRQ mode risks
> racing with phylink's workqueue, and generally speaking, phylink doesn't
> seem to be built around the idea that "bool poll" can change after
> phylink_start().

I think you're confused. Andrew is merely talking about phylib's
polling, not phylink's.

Phylink's polling is only ever used in two circumstances:

1. In fixed-link mode where we have an interruptless GPIO.
2. In in-band mode when the PCS specifies it needs to be polled.

This is not used to poll ethernet PHYs - ethernet PHY polling is
handled entirely by phylib itself.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
