Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2D5331AD4E
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 18:08:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbhBMRHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 12:07:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbhBMRHi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 12:07:38 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5D8CC061574
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 09:06:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=kscZZj7OEmskBUNrRl3vhYJqVlISwgaRyT5HskIk08g=; b=fnRl4gnRT8G4LazJa7c6Nsrmu
        G71Qs/rjMOQBEdXS3e7IlpS6I0icyKnZ9Ju71KEloa7ZCO2LYKQZpcTifdnNOho9Dnd+KTJCfdyeY
        Upzr3tkj+xAFatRRO8Or4Qll3Faa3N1+r75/ArNFjpBSmTrwhvFrRKrTnIeRoc9hLfh//mWc1EbRY
        qtEMzdf7ir1c5n+mUfcWzHx7T/r16nKZ3HU1DrNkCBQ1lIZYX6QUKijRY4Co+71LnNvNwg0mZpr5n
        SIZ1S2s9J2GMCfyk91Kw3fQ0k0rmnbM1J6bvfO/hRejhWHYevB+W0WKatMD8RLvh1PJ6lpn6RK7bT
        DPBMi2T5A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:42946)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lAyNe-0008NU-Df; Sat, 13 Feb 2021 17:06:50 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lAyNb-0008GH-0Z; Sat, 13 Feb 2021 17:06:47 +0000
Date:   Sat, 13 Feb 2021 17:06:46 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Michael Walle <michael@walle.cc>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Antoine Tenart <atenart@kernel.org>,
        Quentin Schulz <quentin.schulz@bootlin.com>,
        netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Steen Hegelund <steen.hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next 1/2] net: phylink: explicitly configure in-band
 autoneg for PHYs that support it
Message-ID: <20210213170646.GR1463@shell.armlinux.org.uk>
References: <20210212172341.3489046-1-olteanv@gmail.com>
 <20210212172341.3489046-2-olteanv@gmail.com>
 <eb7b911f4fe008e1412058f219623ee2@walle.cc>
 <20210213001808.GN1463@shell.armlinux.org.uk>
 <db9f5988d7d135b3588bf9f6a5b10b08@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <db9f5988d7d135b3588bf9f6a5b10b08@walle.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 13, 2021 at 05:41:55PM +0100, Michael Walle wrote:
> Am 2021-02-13 01:18, schrieb Russell King - ARM Linux admin:
> > That is a function of the interface mode and the PHY capabilities.
> > 
> > 1) if the PHY supports rate adaption, and is programmed for that, then
> >    the PHY link normally operates at a fixed speed (e.g. 1G for SGMII)
> >    and the PHY converts to the appropriate speed.
> > 
> >    We don't actually support this per se, since the parameters we give
> >    to the MAC via mac_link_up() are the media side parameters, not the
> >    link parameters.
> > 
> > 2) if the PHY does not support rate adaption, then the MAC to PHY link
> >    needs to follow the media speed and duplex. phylink will be in "PHY"
> >    mode, where it passes the media side negotiation results to the MAC
> >    just like phylib would, and the MAC should be programmed
> >    appropriately. In the case of a SGMII link, the link needs to be
> >    programmed to do the appropriate symbol repetition for 100M and 10M
> >    speeds. The PHY /should/ do that automatically, but if it doesn't,
> >    then the PHY also needs to be programmed to conform. (since if
> >    there's no rate adaption in the PHY, the MAC side and the media side
> >    must match.)
> 
> Thanks, but I'm not sure I understand the difference between "rate
> adaption" and symbol repetition. The SGMII link is always 1.25Gb,
> right? If the media side is 100Mbit it will repeat the symbol 10
> times or 100 times in case of 10Mbit. What is "rate adaption" then?

You are correct about SGMII.

Bear in mind that there is very little difference between SGMII and
1000base-X when you don't have AN. SGMII can be forced to do the
symbol repetition.  Symbol repetition does not exist in 1000base-X.

Some PHYs, particularly 10G multi-speed PHYs, have a "rate adaption"
block that can be used when the media side is operating at slower-
than-10G speed when the media side is fixed at 10G. What this means
is the MAC side always operates at full 10G speed, but the PHY
queues packets for transmission at the media rate. Received packets
are received by the PHY and then forwarded to the MAC at 10G speed.

To add to that, some PHYs have the ability to send pause frames
when their internal buffer fills up. Others stipulate that the MAC
needs to rate-limit the transmitted packets to match the media side
speed.

Whether such a feature exists in 1G PHYs is unknown. If a PHY is
capable of 1G/100M/10M speeds, but if SGMII AN is disabled and
there is no way to force the symbol repetition, the SGMII side
will be fixed at 1G speed. The only way this can work with a
slower media speed is if the PHY performs rate adaption internally,
converting between the 1G speed on the host side and whatever speed
the media side is operating.

So, for example, if the PHY was to have rate adaption, the media
side would operate at 100M but the MAC side would continue operating
at 1G speed without symbol repetition.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
