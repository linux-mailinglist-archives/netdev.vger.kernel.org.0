Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A3F028D40
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 00:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388320AbfEWWfV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 18:35:21 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:48508 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387546AbfEWWfU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 18:35:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ew8xy4i//m1i2IQG+g3sgcqn6gyWD36gj6XvX/yCd/U=; b=CjS664REjuaWcSZ/ZsJILYIEV
        Fw9p17vCoS+4hPxhvgMaMg1Hb1bUFK/gv2fV/8nCVxW0vqjwUy2lg0RWVDQeXM7aT830S4IurQrO0
        zIo2NOTnl7lRbB+SOHj6Kf7VTILGWfJuMd5bbPo6htsAz5wv4K3rGa/jzIYdoD17xpw4wHe8GP1V4
        UBfWdQxfDliw/Fo8UIRdq+DixxdY5/Rn/kIiBi5YvOjuie7ooVJmI3CWUHts2SwBYuQwd5I085sfg
        Re0/JDKNcVQIOq54EyapKuv/iGJUJvhHTRmuHwo7jg68SWqRT8NRqxAH67tP5/vftYlnki+5ON17W
        ZaNbMA2+A==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:55968)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hTwIs-0008VG-OS; Thu, 23 May 2019 23:35:14 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hTwIp-0007vm-B8; Thu, 23 May 2019 23:35:11 +0100
Date:   Thu, 23 May 2019 23:35:11 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "maxime.chevallier@bootlin.com" <maxime.chevallier@bootlin.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [RFC PATCH net-next 5/9] net: phylink: Add phylink_create_raw
Message-ID: <20190523223511.hjk5m3mxadkra26z@shell.armlinux.org.uk>
References: <20190523011958.14944-1-ioana.ciornei@nxp.com>
 <20190523011958.14944-6-ioana.ciornei@nxp.com>
 <20190523215522.gnz6l342zhzpi2ld@shell.armlinux.org.uk>
 <CA+h21hpU7-kcsX9Z4DA116qcMz2DjE3G2Fwj03=JDRyE7sAcwQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hpU7-kcsX9Z4DA116qcMz2DjE3G2Fwj03=JDRyE7sAcwQ@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 24, 2019 at 01:04:01AM +0300, Vladimir Oltean wrote:
> On Fri, 24 May 2019 at 00:55, Russell King - ARM Linux admin
> <linux@armlinux.org.uk> wrote:
> >
> > On Thu, May 23, 2019 at 01:20:40AM +0000, Ioana Ciornei wrote:
> > > +     if (pl->ops) {
> > > +             pl->ops->mac_link_up(ndev, pl->link_an_mode,
> > >                            pl->phy_state.interface,
> > >                            pl->phydev);
> > >
> > > +             netif_carrier_on(ndev);
> > >
> > > +             netdev_info(ndev,
> > > +                         "Link is Up - %s/%s - flow control %s\n",
> > > +                         phy_speed_to_str(link_state.speed),
> > > +                         phy_duplex_to_str(link_state.duplex),
> > > +                         phylink_pause_to_str(link_state.pause));
> > > +     } else {
> > > +             blocking_notifier_call_chain(&pl->notifier_chain,
> > > +                                          PHYLINK_MAC_LINK_UP, &info);
> > > +             phydev_info(pl->phydev,
> > > +                         "Link is Up - %s/%s - flow control %s\n",
> > > +                         phy_speed_to_str(link_state.speed),
> > > +                         phy_duplex_to_str(link_state.duplex),
> > > +                         phylink_pause_to_str(link_state.pause));
> > > +     }
> >
> > So if we don't have pl->ops, what happens when we call phydev_info()
> > with a NULL phydev, which is a very real possibility: one of phylink's
> > whole points is to support dynamic presence of a PHY.
> >
> > What will happen in that case is this will oops, due to dereferencing
> > an offset NULL pointer via:
> >
> > #define phydev_info(_phydev, format, args...)   \
> >         dev_info(&_phydev->mdio.dev, format, ##args)
> >
> > You can't just decide that if there's no netdev, we will be guaranteed
> > a phy.
> >
> > --
> > RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> > FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
> > According to speedtest.net: 11.9Mbps down 500kbps up
> 
> True, however it does not crash:
> 
> [    2.539949] (NULL device *): Link is Up - 1Gbps/Full - flow control off
> 
> I agree that a better printing system has to be established though.

The only reason that happens is because struct mdio_device is at the
start of struct phy_device, and struct device is at the start of
struct mdio_device.

Should either of these move, that breaks and we get an oops.  Sorry,
that's way too fragile.

Plus, of course, do we think that printing "(NULL device *):" is
really acceptable?  We completely lose any information about _what_
link came up or went down.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
