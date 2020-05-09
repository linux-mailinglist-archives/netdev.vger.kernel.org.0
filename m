Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D1401CC10F
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 13:45:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728272AbgEILpi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 07:45:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726063AbgEILpi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 07:45:38 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85BB9C061A0C;
        Sat,  9 May 2020 04:45:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=KiW60T3hTB2qpy6736Bxcw2MHOpni1wIvO5W/zMNZ1U=; b=dScxEOEPFAX93tSikUpNlmorU
        Ud2kA2lUknBqfsPTkWQ2niqbdThBKyTUvRHH3rKqgp5Ikovwkw3E1j5LwaXgrODtJ1Q34TqSdZ3Lc
        DJuqL9okq9w+0UJ+gG49wEiY7SbY7URGE520Z3WoWT3zGowMr1bQqXeX25ddgdWGmRWeuO4GZIcmo
        tahxCA17P2BuoHENH/I0g5X9Ewa0e/vcpS25lTh7AE+nbBee1eNOLNGOrtA93dL19erh1olQjeALZ
        8yG0PBo7SFlNS8hsROxrwr+tIRxsjNRl9qi5n94y8FuAvcAupkRKteByPPXw5GAK/bkoaFLlaBZID
        CmNhNf3dA==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:55720)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jXNv1-0003gT-TW; Sat, 09 May 2020 12:45:24 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jXNuw-0002pE-BR; Sat, 09 May 2020 12:45:18 +0100
Date:   Sat, 9 May 2020 12:45:18 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Stefan Chulski <stefanc@marvell.com>,
        Matteo Croce <mcroce@redhat.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "gregory.clement@bootlin.com" <gregory.clement@bootlin.com>,
        "miquel.raynal@bootlin.com" <miquel.raynal@bootlin.com>,
        Nadav Haklai <nadavh@marvell.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Subject: Re: [EXT] Re: [PATCH net-next 3/5] net: mvpp2: cls: Use RSS contexts
 to handle RSS tables
Message-ID: <20200509114518.GB1551@shell.armlinux.org.uk>
References: <20190524100554.8606-1-maxime.chevallier@bootlin.com>
 <20190524100554.8606-4-maxime.chevallier@bootlin.com>
 <CAGnkfhzsx_uEPkZQC-_-_NamTigD8J0WgcDioqMLSHVFa3V6GQ@mail.gmail.com>
 <20200423170003.GT25745@shell.armlinux.org.uk>
 <CAGnkfhwOavaeUjcm4_+TG-xLxQA519o+fR8hxBCCfSy3qpcYhQ@mail.gmail.com>
 <DM5PR18MB1146686527DE66495F75D0DAB0A30@DM5PR18MB1146.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM5PR18MB1146686527DE66495F75D0DAB0A30@DM5PR18MB1146.namprd18.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 09, 2020 at 11:15:58AM +0000, Stefan Chulski wrote:
> 
> 
> > -----Original Message-----
> > From: Matteo Croce <mcroce@redhat.com>
> > Sent: Saturday, May 9, 2020 3:13 AM
> > To: David S . Miller <davem@davemloft.net>
> > Cc: Maxime Chevallier <maxime.chevallier@bootlin.com>; netdev
> > <netdev@vger.kernel.org>; LKML <linux-kernel@vger.kernel.org>; Antoine
> > Tenart <antoine.tenart@bootlin.com>; Thomas Petazzoni
> > <thomas.petazzoni@bootlin.com>; gregory.clement@bootlin.com;
> > miquel.raynal@bootlin.com; Nadav Haklai <nadavh@marvell.com>; Stefan
> > Chulski <stefanc@marvell.com>; Marcin Wojtas <mw@semihalf.com>; Linux
> > ARM <linux-arm-kernel@lists.infradead.org>; Russell King - ARM Linux admin
> > <linux@armlinux.org.uk>
> > Subject: [EXT] Re: [PATCH net-next 3/5] net: mvpp2: cls: Use RSS contexts to
> > handle RSS tables
> > 
> > Hi,
> > 
> > What do you think about temporarily disabling it like this?
> > 
> > --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > @@ -5775,7 +5775,8 @@ static int mvpp2_port_probe(struct platform_device
> > *pdev,
> >                             NETIF_F_HW_VLAN_CTAG_FILTER;
> > 
> >         if (mvpp22_rss_is_supported()) {
> > -               dev->hw_features |= NETIF_F_RXHASH;
> > +               if (port->phy_interface != PHY_INTERFACE_MODE_SGMII)
> > +                       dev->hw_features |= NETIF_F_RXHASH;
> >                 dev->features |= NETIF_F_NTUPLE;
> >         }
> > 
> > 
> > David, is this "workaround" too bad to get accepted?
> 
> Not sure that RSS related to physical interface(SGMII), better just remove NETIF_F_RXHASH as "workaround".

Hmm, I'm not sure this is the right way forward.  This patch has the
effect of disabling:

d33ec4525007 ("net: mvpp2: add an RSS classification step for each flow")

but the commit you're pointing at which caused the regression is:

895586d5dc32 ("net: mvpp2: cls: Use RSS contexts to handle RSS tables")


Looking at the timeline here, it looks like Matteo raised the issue
very quickly after the patch was sent on the 14th April, and despite
following up on it, despite me following up on it, bootlin have
remained quiet.  For a regression, that's not particularly good, and
doesn't leave many options but to ask davem to revert a commit, or
if possible fix it (which there doesn't seem to be any willingness
for either - maybe it's a feature no one uses on this platform?)

Would reverting the commit you point to as the cause (895586d5dc32)
resolve the problem, and have any advantage over entirely disabling
RSS?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
