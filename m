Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D22A21CC1EE
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 15:51:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727810AbgEINvV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 09:51:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726904AbgEINvU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 09:51:20 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E42E9C061A0C;
        Sat,  9 May 2020 06:51:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=2uygEucO5eCGyC1Yl+l/qEGrNAjV1cjP3RBl/px8ykw=; b=LYvqtNTkAfpe2zWTtXqs0AlVr
        JSY/8pWu8EKEKUpiD3KHRAIrqtN/gZWHmvDAyeY6MYSSAmSw+HjwcOoURlbOlMtkwKx/eYWaE8NAe
        estJ6I3KznNOQ+XT5SNmMxkySCAiYeQP46EeJpLbeso6Y8i7JQkzn6aN7sAwovHwQVrnnSLUoWnMD
        ilbvI8F/q0AhjOMwccK28a53kaB6tg7R3G2bnyHC/TP5TqmVJrbWwsESPcr/dVb8e4e1p590UHxg/
        o8aW5eD5kKR+Vb8IK/zowKmzjpCn3Fzib3PAmwVQNiVk4K6VhAboF9Et6ayykFoPahOH1R55nlk/S
        tFwQiXG3w==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:38036)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jXPsk-00044H-Uh; Sat, 09 May 2020 14:51:11 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jXPsf-0002u4-W2; Sat, 09 May 2020 14:51:06 +0100
Date:   Sat, 9 May 2020 14:51:05 +0100
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
Message-ID: <20200509135105.GE1551@shell.armlinux.org.uk>
References: <20190524100554.8606-1-maxime.chevallier@bootlin.com>
 <20190524100554.8606-4-maxime.chevallier@bootlin.com>
 <CAGnkfhzsx_uEPkZQC-_-_NamTigD8J0WgcDioqMLSHVFa3V6GQ@mail.gmail.com>
 <20200423170003.GT25745@shell.armlinux.org.uk>
 <CAGnkfhwOavaeUjcm4_+TG-xLxQA519o+fR8hxBCCfSy3qpcYhQ@mail.gmail.com>
 <DM5PR18MB1146686527DE66495F75D0DAB0A30@DM5PR18MB1146.namprd18.prod.outlook.com>
 <20200509114518.GB1551@shell.armlinux.org.uk>
 <CAGnkfhx8fEZCoLPzGxSzQnj1ZWcQtBMn+g_jO1Jxc4zF7pQwjQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGnkfhx8fEZCoLPzGxSzQnj1ZWcQtBMn+g_jO1Jxc4zF7pQwjQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 09, 2020 at 03:14:05PM +0200, Matteo Croce wrote:
> On Sat, May 9, 2020 at 1:45 PM Russell King - ARM Linux admin
> <linux@armlinux.org.uk> wrote:
> >
> > On Sat, May 09, 2020 at 11:15:58AM +0000, Stefan Chulski wrote:
> > >
> > >
> > > > -----Original Message-----
> > > > From: Matteo Croce <mcroce@redhat.com>
> > > > Sent: Saturday, May 9, 2020 3:13 AM
> > > > To: David S . Miller <davem@davemloft.net>
> > > > Cc: Maxime Chevallier <maxime.chevallier@bootlin.com>; netdev
> > > > <netdev@vger.kernel.org>; LKML <linux-kernel@vger.kernel.org>; Antoine
> > > > Tenart <antoine.tenart@bootlin.com>; Thomas Petazzoni
> > > > <thomas.petazzoni@bootlin.com>; gregory.clement@bootlin.com;
> > > > miquel.raynal@bootlin.com; Nadav Haklai <nadavh@marvell.com>; Stefan
> > > > Chulski <stefanc@marvell.com>; Marcin Wojtas <mw@semihalf.com>; Linux
> > > > ARM <linux-arm-kernel@lists.infradead.org>; Russell King - ARM Linux admin
> > > > <linux@armlinux.org.uk>
> > > > Subject: [EXT] Re: [PATCH net-next 3/5] net: mvpp2: cls: Use RSS contexts to
> > > > handle RSS tables
> > > >
> > > > Hi,
> > > >
> > > > What do you think about temporarily disabling it like this?
> > > >
> > > > --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > > > +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > > > @@ -5775,7 +5775,8 @@ static int mvpp2_port_probe(struct platform_device
> > > > *pdev,
> > > >                             NETIF_F_HW_VLAN_CTAG_FILTER;
> > > >
> > > >         if (mvpp22_rss_is_supported()) {
> > > > -               dev->hw_features |= NETIF_F_RXHASH;
> > > > +               if (port->phy_interface != PHY_INTERFACE_MODE_SGMII)
> > > > +                       dev->hw_features |= NETIF_F_RXHASH;
> > > >                 dev->features |= NETIF_F_NTUPLE;
> > > >         }
> > > >
> > > >
> > > > David, is this "workaround" too bad to get accepted?
> > >
> > > Not sure that RSS related to physical interface(SGMII), better just remove NETIF_F_RXHASH as "workaround".
> >
> > Hmm, I'm not sure this is the right way forward.  This patch has the
> > effect of disabling:
> >
> > d33ec4525007 ("net: mvpp2: add an RSS classification step for each flow")
> >
> > but the commit you're pointing at which caused the regression is:
> >
> > 895586d5dc32 ("net: mvpp2: cls: Use RSS contexts to handle RSS tables")
> >
> >
> 
> Hi,
> 
> When git bisect pointed to 895586d5dc32 ("net: mvpp2: cls: Use RSS
> contexts to handle RSS tables"), which was merged
> almost an year after d33ec4525007 ("net: mvpp2: add an RSS
> classification step for each flow"), so I assume that between these
> two commits either the feature was working or it was disable and we
> didn't notice
> 
> Without knowing what was happening, which commit should my Fixes tag point to?

Let me make sure that I get this clear:

- Prior to 895586d5dc32, you can turn on and off rxhash without issue
  on any port.
- After 895586d5dc32, turning rxhash on eth2 prevents reception.

Prior to 895586d5dc32, with rxhash on, it looks like hashing using
CRC32 is supported but only one context.  So, if it's possible to
enable rxhash on any port on the mcbin without 895586d5dc32, and the
port continues to work, I'd say the bug was introduced by
895586d5dc32.

Of course, that would be reinforced if there was a measurable
difference in performance due to rxhash on each port.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
