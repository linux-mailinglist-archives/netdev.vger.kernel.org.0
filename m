Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2524E1A4798
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 16:44:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726177AbgDJOoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 10:44:18 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:34102 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726080AbgDJOoS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Apr 2020 10:44:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=wXi1xUpKKSP8ThiT6cynG7U9Kwo7uR6YiRJE3Uf7hNQ=; b=Y3oOTMVpr3Bf86jn5zqRX69Tu
        w76YXA3Mm/lWY2pJnIGqESUG8RjR6OuXM4413NeSMVth1EzYWhOJYyR5SxpTYr+69MCDqhByvmu44
        zFWw4iWO2dmzpB6+zD27K8TRU/7Xkfdn5Oa6axoYUtI+NhJ1/vtOA6036IH4j8lP7PJ0FaVSzdvPw
        yw4vL3t4aKwqO2xZy/OUZoZMup/BH2ECsFa4exmbTDylCL2SIWUKgn2RCFiPbjkDT7P8gQTsjlZ+z
        bwcQDb0Y/K4MtsNu+lHzKoMRXYJV7wr2x/kBYzaNBE6+PK/yUv6VJXnMeYgWaIbI4Q1/3hko4kSsT
        vF0lwqRIg==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:44072)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jMut8-00023e-8l; Fri, 10 Apr 2020 15:44:10 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jMut6-0003rT-PD; Fri, 10 Apr 2020 15:44:08 +0100
Date:   Fri, 10 Apr 2020 15:44:08 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Matteo Croce <mcroce@redhat.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Luka Perkov <luka.perkov@sartura.hr>
Subject: Re: [PATCH net-next v2 3/3] net: phy: marvell10g: place in powersave
 mode at probe
Message-ID: <20200410144408.GZ25745@shell.armlinux.org.uk>
References: <20200303155347.GS25745@shell.armlinux.org.uk>
 <E1j99sC-00011f-22@rmk-PC.armlinux.org.uk>
 <CAGnkfhx+JkD6a_8ojU6tEL_vk6vtwQpxbwU9+beDepL4dxgLyQ@mail.gmail.com>
 <20200410141914.GY25745@shell.armlinux.org.uk>
 <20200410143658.GM5827@shell.armlinux.org.uk>
 <CAGnkfhxPm6UWj8Dyt9S08vHdh9nwkTums+WfY14D52dsBsBPgQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGnkfhxPm6UWj8Dyt9S08vHdh9nwkTums+WfY14D52dsBsBPgQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 10, 2020 at 04:39:48PM +0200, Matteo Croce wrote:
> On Fri, Apr 10, 2020 at 4:37 PM Russell King - ARM Linux admin
> <linux@armlinux.org.uk> wrote:
> >
> > On Fri, Apr 10, 2020 at 03:19:14PM +0100, Russell King - ARM Linux admin wrote:
> > > On Fri, Apr 10, 2020 at 03:48:34PM +0200, Matteo Croce wrote:
> > > > On Fri, Apr 10, 2020 at 3:24 PM Russell King <rmk+kernel@armlinux.org.uk> wrote:
> > > > >
> > > > > Place the 88x3310 into powersaving mode when probing, which saves 600mW
> > > > > per PHY. For both PHYs on the Macchiatobin double-shot, this saves
> > > > > about 10% of the board idle power.
> > > > >
> > > > > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> > > >
> > > > Hi,
> > > >
> > > > I have a Macchiatobin double shot, and my 10G ports stop working after
> > > > this change.
> > > > I reverted this commit on top of latest net-next and now the ports work again.
> > >
> > > Please describe the problem in more detail.
> > >
> > > Do you have the interface up?  Does the PHY link with the partner?
> > > Is the problem just that traffic isn't passed?
> >
> > I've just retested on my Macchiatobin double shot, and it works fine.
> > What revision PHYs do you have?  Unfortunately, you can't read the
> > PHY ID except using mii-diag:
> >
> > # mii-diag eth0 -p 32769
> >
> > or
> >
> > # mii-diag eth1 -p 33025
> >
> > Looking at word 3 and 4, it will be either:
> >
> > 002b 09aa
> > 002b 09ab
> >
> > Thanks.
> >
> > --
> > RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> > FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
> >
> 
> 
> Hi Russel,
> 
> I have the interface up connected via a DAC Cable to an i40e card.
> When I set the link up I detect the carrier:
> 
> mvpp2 f2000000.ethernet eth0: PHY [f212a600.mdio-mii:00] driver
> [mv88x3310] (irq=POLL)
> mvpp2 f2000000.ethernet eth0: configuring for phy/10gbase-r link mode
> mvpp2 f2000000.ethernet eth0: Link is Up - 10Gbps/Full - flow control off
> 
> No traffic is received or can be sent.
> 
> How can I read the PHY revision?

I gave details in the email you just replied to - you have to use
mii-diag, there's no other way.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
