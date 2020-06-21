Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A4DE202C9D
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 22:03:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730581AbgFUUDC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 16:03:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730288AbgFUUDB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jun 2020 16:03:01 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 660DBC061794
        for <netdev@vger.kernel.org>; Sun, 21 Jun 2020 13:03:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=YnGEkAbcdPh8y0mY0AUxFoJMh+37//I3Ue5jhV0giYo=; b=hDif5lCQ7hvOv41B0bbtYj+J7
        pLOVckJdQJa8HrOtyXBVrBV9NAJ1XJDqtSP/2daTFj0QjZa06sOJ59NMpQD1s8xTfCWrq7WPB9eGF
        T88/52MsqXRQpT4Nl/5UYynvIGjBv9vPdA1kXvEWEQJFDu6j1EA3pbnVBl1x6Y27Av55HqK/hTnj1
        2TrULdA/VW48N3QMMEgK7bg4HsJA1IVNC/tY889tbafrjjvjmWfXcjdBzPyCeUiG2dgfq+S6sYDmR
        /M7DfvqmawMsGVekaKxNKfY3+OK3Euf2JamJ1gceBSbXg6TIXE/lLNBto/427Nk18tQUNTNSYCaKI
        e9Bh5xevA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58916)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jn6At-000872-4a; Sun, 21 Jun 2020 21:02:43 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jn6Ah-0007nO-Bh; Sun, 21 Jun 2020 21:02:31 +0100
Date:   Sun, 21 Jun 2020 21:02:31 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Felix Fietkau <nbd@openwrt.org>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [CFT 0/8] rework phylink interface for split MAC/PCS support
Message-ID: <20200621200231.GX1551@shell.armlinux.org.uk>
References: <20200217172242.GZ25745@shell.armlinux.org.uk>
 <20200621143340.GI1605@shell.armlinux.org.uk>
 <CA+h21ho2Papr2gXqap2LGE3N4LJAbor2WxzX1quDckVvw-mQ5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21ho2Papr2gXqap2LGE3N4LJAbor2WxzX1quDckVvw-mQ5Q@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 21, 2020 at 10:37:43PM +0300, Vladimir Oltean wrote:
> Hi Russell,
> 
> On Sun, 21 Jun 2020 at 17:34, Russell King - ARM Linux admin
> <linux@armlinux.org.uk> wrote:
> >
> > All,
> >
> > This is now almost four months old, but I see that I didn't copy the
> > message to everyone who should've been, especially for the five
> > remaining drivers.
> >
> > I had asked for input from maintainers to help me convert their
> > phylink-using drivers to the new style where mac_link_up() performs
> > the speed, duplex and pause setup rather than mac_config(). So far,
> > I have had very little assistance with this, and it is now standing
> > in the way of further changes to phylink, particularly with proper
> > PCS support. You are effectively blocking this work; I can't break
> > your code as that will cause a kernel regression.
> >
> > This is one of the reasons why there were not many phylink patches
> > merged for the last merge window.
> >
> > The following drivers in current net-next remain unconverted:
> >
> > drivers/net/ethernet/mediatek/mtk_eth_soc.c
> > drivers/net/dsa/ocelot/felix.c
> > drivers/net/dsa/qca/ar9331.c
> > drivers/net/dsa/bcm_sf2.c
> > drivers/net/dsa/b53/b53_common.c
> >
> > These can be easily identified by grepping for conditionals where the
> > expression matches the "MLO_PAUSE_.X" regexp.
> >
> > I have an untested patch that I will be sending out today for
> > mtk_eth_soc.c, but the four DSA ones definitely require their authors
> > or maintainers to either make the changes, or assist with that since
> > their code is not straight forward.
> >
> > Essentially, if you are listed in this email's To: header, then you
> > are listed as a maintainer for one of the affected drivers, and I am
> > requesting assistance from you for this task please.
> >
> > Thanks.
> >
> > Russell.
> >
> 
> If forcing MAC speed is to be moved in mac_link_up(), and if (as you
> requested in the mdio-lynx-pcs thread) configuring the PCS is to be
> moved in pcs_link_up() and pcs_config() respectively, then what
> remains to be done in mac_config()?

Hopefully very little, but I suspect there will still be a need for
some kind of interface to configure the MAC interface type at the MAC.

Note that I have said many many many times that using state->{speed,
duplex,pause} in mac_config() when in in-band mode is unreliable, yet
still people insist on using them.  There _are_ and always _have been_
paths in phylink where these members will be passed with an unresolved
state, and they will corrupt the link settings when that happens.

I know that phylink was deficient in its handling of a split PCS, but
I have worked to correct that.  That job still is not complete, because
because I'm held up by these drivers that have not yet converted.  I've
already waited a kernel cycle, despite having the next series of
phylink patches ready and waiting since early February.

I'm getting to the point of wishing that phylink did not have users
except my own.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
