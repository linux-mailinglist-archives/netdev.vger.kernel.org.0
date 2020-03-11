Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75AD018234F
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 21:32:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729180AbgCKUc4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 16:32:56 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:59360 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725834AbgCKUcz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 16:32:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=filNL41M+8g9UDlvxvVFpr8uUIgTsbcC+lpBeiHu+tE=; b=JF1RwxipL5nAiAvy+I24l3ouO
        wNrp5aktsNXJqVIUvMQH1wG4wFsM6H9cEUR+CJR3FJ1J1I01y6a2/earo/qoGheMYGlOPWJulZ3Nq
        BnVFHKFnJ82eONVBsyiZN3hTSTYya//NmxqNcNTVG+PpV+iJ7D03Y7whupiXBLv1C1936+tBm8ZRr
        C2E1j+NgFtKhVJNRDJBMfVi6p+CM/juuU5/byFIJtPYX/7qJuZHk8H0UWWz1HV9Yz7xE9Wxgri70w
        H65W5Z4aeeAfjOcr+//vL6D9l9ZsR8njKlDP3CINMhHucoH+3g/QPj57c6XpYOhfAe4YjJA23LSUL
        w2tAKkn/Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35138)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jC823-0005Nu-QR; Wed, 11 Mar 2020 20:32:47 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jC821-0005cW-La; Wed, 11 Mar 2020 20:32:45 +0000
Date:   Wed, 11 Mar 2020 20:32:45 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 4/5] net: phylink: pcs: add 802.3 clause 22
 helpers
Message-ID: <20200311203245.GS25745@shell.armlinux.org.uk>
References: <20200311120643.GN25745@shell.armlinux.org.uk>
 <E1jC099-0001cZ-U2@rmk-PC.armlinux.org.uk>
 <CA+h21ho9eWTCJp2+hD0id_e3mfVXw_KRJziACJQMDXxmCnE5xA@mail.gmail.com>
 <20200311170918.GQ25745@shell.armlinux.org.uk>
 <CA+h21hooqWCqPT2gWtjx2hadXga9e4fAjf4xwavvzyzmdqGNfg@mail.gmail.com>
 <20200311193223.GR25745@shell.armlinux.org.uk>
 <CA+h21hqnQd=SdQXiNVW5UPuZug8zcM64DUMRvjojZVgMs-tmBQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hqnQd=SdQXiNVW5UPuZug8zcM64DUMRvjojZVgMs-tmBQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 11, 2020 at 09:59:18PM +0200, Vladimir Oltean wrote:
> On Wed, 11 Mar 2020 at 21:32, Russell King - ARM Linux admin
> <linux@armlinux.org.uk> wrote:
> > So, why abuse some other subsystem's datastructure for something that
> > is entirely separate, potentially making the maintanence of that
> > subsystem more difficult for the maintainers?  I don't get why one
> > would think this is an acceptable approach.
> >
> > What you've said is that you want to use struct phy_device, but you
> > don't want to publish it into the device model, you don't want to
> > use mdio accesses, you don't want to use phylib helpers.  So, what's
> > the point of using struct phy_device?  I don't see _any_ reason to
> > do that and make things unnecessarily more difficult for the phylib
> > maintainers.
> >
> 
> So if it's such a big mistake...
> 
> > > > Sorry, but you need to explain better what you would like to see here.
> > > > The additions I'm adding are to the SGMII specification; I find your
> > > > existing definitions to be obscure because they conflate two different
> > > > bit fields together to produce something for the ethtool linkmodes
> > > > (which I think is a big mistake.)
> > >
> > > I'm saying that there were already LPA_SGMII definitions in there.
> > > There are 2 "generic" solutions proposed now and yet they cannot agree
> > > on config_reg definitions. Omitting the fact that you did have a
> > > chance to point out that big mistake before it got merged, I'm
> > > wondering why you didn't remove them and add your new ones instead.
> > > The code rework is minimal. Is it because the definitions are in UAPI?
> > > If so, isn't it an even bigger mistake to put more stuff in UAPI? Why
> > > would user space care about the SGMII config_reg? There's no user even
> > > of the previous SGMII definitions as far as I can tell.
> >
> > I don't see it as a big deal - certainly not the kind of fuss you're
> > making over it.
> >
> 
> ...why keep it?
> I'm all for creating a common interface for configuring this. It just
> makes me wonder how common it is going to be, if there's already a
> driver in-tree, from the same PCS hardware vendor, which after the
> patchset you're proposing is still going to use a different
> infrastructure.

Do you see any reason why felix_vsc9959 couldn't make use of the code
I'm proposing?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
