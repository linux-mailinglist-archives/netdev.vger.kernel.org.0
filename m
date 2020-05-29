Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D2B31E8282
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 17:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727826AbgE2Pvj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 11:51:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726838AbgE2Pvi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 11:51:38 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BD83C03E969;
        Fri, 29 May 2020 08:51:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Qwf1Oga74KLnmz4Cm9wol7+EzSDL+0sA3Q9FJM19WOs=; b=b4fjaANCE4eYTTiT6/qFihwwI
        CAqdeEXO+U4gxZ69XncoyAlkseDYab19h6ZbcJpfJuX2bmyJ/UShrsmKFhjoItoQgKpSDLrxeEOfr
        VccXwy5sXZqq5tfCihRAAwm/UPSQjdzDEolYyngb0SMeYVNGLdPtK9FluEqowizgjXqW3PabNWzVW
        CAtdRKM+rJi0lCdFLXdErogyiarPPeLnRPuixcNacd9sv33MA/z65I3sJH1EjG1m4yse7HosWJwp5
        8jLsLf5lcQsiUO2oAswkpATaBp25XNHCwf42/heYf3efOqy8KoLdq4kZd/+eDwx2GpoDSyIRnnS/2
        cdVv9kpeA==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:36150)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jehI5-0000DN-JQ; Fri, 29 May 2020 16:51:25 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jehI2-00009T-3L; Fri, 29 May 2020 16:51:22 +0100
Date:   Fri, 29 May 2020 16:51:22 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Thomas Bogendoerfer <tbogendoerfer@suse.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: mvpp2: Enable autoneg bypass for
 1000BaseX/2500BaseX ports
Message-ID: <20200529155121.GA1551@shell.armlinux.org.uk>
References: <20200528121121.125189-1-tbogendoerfer@suse.de>
 <20200528130738.GT1551@shell.armlinux.org.uk>
 <20200528151733.f1bc2fcdcb312b19b2919be9@suse.de>
 <20200528135608.GU1551@shell.armlinux.org.uk>
 <20200528163335.8f730b5a3ddc8cd9beab367f@suse.de>
 <20200528144805.GW1551@shell.armlinux.org.uk>
 <20200528204312.df9089425162a22e89669cf1@suse.de>
 <20200528220420.GY1551@shell.armlinux.org.uk>
 <20200529130539.3fe944fed7228e2b061a1e46@suse.de>
 <20200529145928.GF869823@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200529145928.GF869823@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 29, 2020 at 04:59:28PM +0200, Andrew Lunn wrote:
> On Fri, May 29, 2020 at 01:05:39PM +0200, Thomas Bogendoerfer wrote:
> > On Thu, 28 May 2020 23:04:20 +0100
> > Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:
> > 
> > > Can you explain this please?  Just as we think we understand what's
> > > going on here, you throw in a new comment that makes us confused.
> > 
> > sorry about that.
> > 
> > > You said previously that the mvpp2 was connected to a switch, which
> > > makes us think that you've got some DSA-like setup going on here.
> > > Does your switch drop its serdes link when all the external links
> > > (presumably the 10G SFP+ cages) fail?
> > > 
> > > Both Andrew and myself wish to have a complete picture before we
> > > move forward with this.
> > 
> > full understandable, I'll try by a small picture, which just
> > covers one switch:
> > 
> >         external ports
> >       |  |          |  |
> > *-----------------------------*
> > |     1  1          2  2      |
> > |                             |
> > |           switch            |
> > |                             |
> > |   1   2            1   2    |
> > *-----------------------------*
> >     |   |            |   |
> >     |   |            |   |
> > *----------*     *----------*
> > |   1   2  |     |   1   2  |
> > |          |     |          |
> > |  node 1  | ... |  node 8  |
> > |          |     |          |
> > *----------*     *----------*
> > 
> > External ports a grouped in ports to network 1 and network 2. If one of the
> > external ports has an established link, this link state will be propagated
> > to the internal ports. Same when both external ports of a network are down.
> 
> By propagated, you mean if the external link is down, the link between
> the switch and node 1 will also be forced down, at the SERDES level?
> And if external ports are down, the nodes cannot talk to each other?
> External link down causes the whole in box network to fall apart? That
> seems a rather odd design.
> 
> > I have no control over the software running on the switch, therefore I can't
> > enable autoneg on the internal links.
> 
> O.K. So that means using in-band signalling in DT is clearly
> wrong. There is no signalling....
> 
> What you are actually interested in is the sync state of the SERDES?
> The link is up if the SERDES has sync.

Right now we force the link up/down for fixed-link mode, depending on
the state that phylink is given (either via the callback, or the gpio,
or in the absence of either of those, we assume link up.)

In the case of a serdes link, where we also have the sync state to
consider, that doesn't sound sane - if in fixed link mode, phylink is
told that the link is up, yet we can clearly see that the serdes we
are attached to is not, we aren't going to receive anything and
anything we try to transmit isn't going to go anywhere.

I wonder how much risk there is to changing that, so we force the link
down if phylink says the link should be down, otherwise we force the
speed/duplex, disable AN, and allow the link to come up depending on
the serdes status.  It /sounds/ like something sane to do.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC for 0.8m (est. 1762m) line in suburbia: sync at 13.1Mbps down 424kbps up
