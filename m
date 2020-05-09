Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F4E21CC23E
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 16:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728117AbgEIOtE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 10:49:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726782AbgEIOtE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 10:49:04 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E3A7C061A0C;
        Sat,  9 May 2020 07:49:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Z6vD6PmD89Ixku9rc/p9RR0bXWZL+mPNX4ud5gSu6aw=; b=v2bazMjSOW3QuO3Cwm/AZIlGa
        QeYz/rk2irlMaD9bOX5DGoy2dgTbaKVEEuxct7DZEYERsw3AyqIhgYeZJ4cC5B2iu49Dyg7rmeJme
        pOxw6mHkyeeD7VtZiuGXi0MNe4qAPoKKdfO5WF2F9v4xHYz7P4IvG+F+7tKc86Pm1UB6zjeUdDSzD
        vpVdafAM1t2inbCi87XoqvbloXpzK4paV0goJ+ZcoP8SJBZYewsCvGgi6EHl7ed9Tz2CLUIXEXhQV
        NSLlu15mJI8+ZvmzC3QzHzbwqTaNygMdsWwXp26pl1AiLyBNy2sjZ0Q7IggWUB7ur18sdRbtzEAoI
        eL2Qx7waA==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:55780)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jXQmd-0004EY-W2; Sat, 09 May 2020 15:48:56 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jXQmT-0002wF-PJ; Sat, 09 May 2020 15:48:45 +0100
Date:   Sat, 9 May 2020 15:48:45 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Matteo Croce <mcroce@redhat.com>
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        netdev <netdev@vger.kernel.org>,
        "gregory.clement@bootlin.com" <gregory.clement@bootlin.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Nadav Haklai <nadavh@marvell.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "miquel.raynal@bootlin.com" <miquel.raynal@bootlin.com>,
        Stefan Chulski <stefanc@marvell.com>,
        Marcin Wojtas <mw@semihalf.com>,
        "David S . Miller" <davem@davemloft.net>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Subject: Re: [EXT] Re: [PATCH net-next 3/5] net: mvpp2: cls: Use RSS contexts
 to handle RSS tables
Message-ID: <20200509144845.GF1551@shell.armlinux.org.uk>
References: <20190524100554.8606-1-maxime.chevallier@bootlin.com>
 <20190524100554.8606-4-maxime.chevallier@bootlin.com>
 <CAGnkfhzsx_uEPkZQC-_-_NamTigD8J0WgcDioqMLSHVFa3V6GQ@mail.gmail.com>
 <20200423170003.GT25745@shell.armlinux.org.uk>
 <CAGnkfhwOavaeUjcm4_+TG-xLxQA519o+fR8hxBCCfSy3qpcYhQ@mail.gmail.com>
 <DM5PR18MB1146686527DE66495F75D0DAB0A30@DM5PR18MB1146.namprd18.prod.outlook.com>
 <20200509114518.GB1551@shell.armlinux.org.uk>
 <CAGnkfhx8fEZCoLPzGxSzQnj1ZWcQtBMn+g_jO1Jxc4zF7pQwjQ@mail.gmail.com>
 <20200509135105.GE1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200509135105.GE1551@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 09, 2020 at 02:51:05PM +0100, Russell King - ARM Linux admin wrote:
> On Sat, May 09, 2020 at 03:14:05PM +0200, Matteo Croce wrote:
> > On Sat, May 9, 2020 at 1:45 PM Russell King - ARM Linux admin
> > <linux@armlinux.org.uk> wrote:
> > >
> > > On Sat, May 09, 2020 at 11:15:58AM +0000, Stefan Chulski wrote:
> > > >
> > > >
> > > > > -----Original Message-----
> > > > > From: Matteo Croce <mcroce@redhat.com>
> > > > > Sent: Saturday, May 9, 2020 3:13 AM
> > > > > To: David S . Miller <davem@davemloft.net>
> > > > > Cc: Maxime Chevallier <maxime.chevallier@bootlin.com>; netdev
> > > > > <netdev@vger.kernel.org>; LKML <linux-kernel@vger.kernel.org>; Antoine
> > > > > Tenart <antoine.tenart@bootlin.com>; Thomas Petazzoni
> > > > > <thomas.petazzoni@bootlin.com>; gregory.clement@bootlin.com;
> > > > > miquel.raynal@bootlin.com; Nadav Haklai <nadavh@marvell.com>; Stefan
> > > > > Chulski <stefanc@marvell.com>; Marcin Wojtas <mw@semihalf.com>; Linux
> > > > > ARM <linux-arm-kernel@lists.infradead.org>; Russell King - ARM Linux admin
> > > > > <linux@armlinux.org.uk>
> > > > > Subject: [EXT] Re: [PATCH net-next 3/5] net: mvpp2: cls: Use RSS contexts to
> > > > > handle RSS tables
> > > > >
> > > > > Hi,
> > > > >
> > > > > What do you think about temporarily disabling it like this?
> > > > >
> > > > > --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > > > > +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > > > > @@ -5775,7 +5775,8 @@ static int mvpp2_port_probe(struct platform_device
> > > > > *pdev,
> > > > >                             NETIF_F_HW_VLAN_CTAG_FILTER;
> > > > >
> > > > >         if (mvpp22_rss_is_supported()) {
> > > > > -               dev->hw_features |= NETIF_F_RXHASH;
> > > > > +               if (port->phy_interface != PHY_INTERFACE_MODE_SGMII)
> > > > > +                       dev->hw_features |= NETIF_F_RXHASH;
> > > > >                 dev->features |= NETIF_F_NTUPLE;
> > > > >         }
> > > > >
> > > > >
> > > > > David, is this "workaround" too bad to get accepted?
> > > >
> > > > Not sure that RSS related to physical interface(SGMII), better just remove NETIF_F_RXHASH as "workaround".
> > >
> > > Hmm, I'm not sure this is the right way forward.  This patch has the
> > > effect of disabling:
> > >
> > > d33ec4525007 ("net: mvpp2: add an RSS classification step for each flow")
> > >
> > > but the commit you're pointing at which caused the regression is:
> > >
> > > 895586d5dc32 ("net: mvpp2: cls: Use RSS contexts to handle RSS tables")
> > >
> > >
> > 
> > Hi,
> > 
> > When git bisect pointed to 895586d5dc32 ("net: mvpp2: cls: Use RSS
> > contexts to handle RSS tables"), which was merged
> > almost an year after d33ec4525007 ("net: mvpp2: add an RSS
> > classification step for each flow"), so I assume that between these
> > two commits either the feature was working or it was disable and we
> > didn't notice
> > 
> > Without knowing what was happening, which commit should my Fixes tag point to?
> 
> Let me make sure that I get this clear:
> 
> - Prior to 895586d5dc32, you can turn on and off rxhash without issue
>   on any port.
> - After 895586d5dc32, turning rxhash on eth2 prevents reception.
> 
> Prior to 895586d5dc32, with rxhash on, it looks like hashing using
> CRC32 is supported but only one context.  So, if it's possible to
> enable rxhash on any port on the mcbin without 895586d5dc32, and the
> port continues to work, I'd say the bug was introduced by
> 895586d5dc32.
> 
> Of course, that would be reinforced if there was a measurable
> difference in performance due to rxhash on each port.

I've just run this test, but I can detect no difference in performance
with or without 895586d5dc32 on eth0 or eth2 on the mcbin (apart from
eth2 stopping working with 895586d5dc32 applied.)  I tested this by
reverting almost all changes to the mvpp2 driver between 5.6 and that
commit.

That's not too surprising; I'm using my cex7 platform with the Mellanox
card in for one end of the 10G link, and that platform doesn't seem to
be able to saturdate a 10G link - it only seems to manage around 4Gbps.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
