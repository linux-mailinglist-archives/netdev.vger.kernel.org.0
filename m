Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C42F51830F4
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 14:13:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726436AbgCLNNg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 09:13:36 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:42676 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725978AbgCLNNf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 09:13:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=lTvYZWgPWaTaFg1b+bfuiBFIRb/R+MEnYUklQ05qCKc=; b=gF1G7v7EqqFfLm/mk26lPKUNr
        47xui8/a6p3o8pXXS6evu0pgeNuiMhKRAyCACaxnprktmgz/DvKOlUPNnZADpLYeXcGgEwjG+zJwH
        6bX6KZR4R7dDLjrPX6CK04KbjQ9PlKE5BNTwzrgASbpC5SVO5QPDv3WYRNM5YuN8pEDznFIwfwiy0
        f9zn/DR6x6rzi+hd5HeeUpqKBT4I+ZTKOQ/SoAu0IVJ1nuu2NxYvPpq14mLtCgRYzlQiI9b9qYsGt
        gCJmZp2V2LlJ/lsbOrjvmTb4tmxYKSekrKsEza4dwIzWFox9Ir+aXAsRY1/WTRPML3g7WQm0Fmv4o
        pjrngGwoA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35466)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jCNeT-0001NB-7Z; Thu, 12 Mar 2020 13:13:29 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jCNeQ-0006Mn-U3; Thu, 12 Mar 2020 13:13:26 +0000
Date:   Thu, 12 Mar 2020 13:13:26 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 4/5] net: phylink: pcs: add 802.3 clause 22
 helpers
Message-ID: <20200312131326.GA25745@shell.armlinux.org.uk>
References: <20200311120643.GN25745@shell.armlinux.org.uk>
 <E1jC099-0001cZ-U2@rmk-PC.armlinux.org.uk>
 <CA+h21ho9eWTCJp2+hD0id_e3mfVXw_KRJziACJQMDXxmCnE5xA@mail.gmail.com>
 <20200311170918.GQ25745@shell.armlinux.org.uk>
 <CA+h21hooqWCqPT2gWtjx2hadXga9e4fAjf4xwavvzyzmdqGNfg@mail.gmail.com>
 <20200311193223.GR25745@shell.armlinux.org.uk>
 <CA+h21hqnQd=SdQXiNVW5UPuZug8zcM64DUMRvjojZVgMs-tmBQ@mail.gmail.com>
 <20200311203245.GS25745@shell.armlinux.org.uk>
 <CA+h21ho9wkWC5E+PwAshjtvKEaFuftewYOauG8yPzf_6F8oVFQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21ho9wkWC5E+PwAshjtvKEaFuftewYOauG8yPzf_6F8oVFQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 12, 2020 at 02:54:55PM +0200, Vladimir Oltean wrote:
> On Wed, 11 Mar 2020 at 22:32, Russell King - ARM Linux admin
> <linux@armlinux.org.uk> wrote:
> >
> > On Wed, Mar 11, 2020 at 09:59:18PM +0200, Vladimir Oltean wrote:
> > > On Wed, 11 Mar 2020 at 21:32, Russell King - ARM Linux admin
> > > <linux@armlinux.org.uk> wrote:
> > > > So, why abuse some other subsystem's datastructure for something that
> > > > is entirely separate, potentially making the maintanence of that
> > > > subsystem more difficult for the maintainers?  I don't get why one
> > > > would think this is an acceptable approach.
> > > >
> > > > What you've said is that you want to use struct phy_device, but you
> > > > don't want to publish it into the device model, you don't want to
> > > > use mdio accesses, you don't want to use phylib helpers.  So, what's
> > > > the point of using struct phy_device?  I don't see _any_ reason to
> > > > do that and make things unnecessarily more difficult for the phylib
> > > > maintainers.
> > > >
> > >
> > > So if it's such a big mistake...
> > >
> > > > > > Sorry, but you need to explain better what you would like to see here.
> > > > > > The additions I'm adding are to the SGMII specification; I find your
> > > > > > existing definitions to be obscure because they conflate two different
> > > > > > bit fields together to produce something for the ethtool linkmodes
> > > > > > (which I think is a big mistake.)
> > > > >
> > > > > I'm saying that there were already LPA_SGMII definitions in there.
> > > > > There are 2 "generic" solutions proposed now and yet they cannot agree
> > > > > on config_reg definitions. Omitting the fact that you did have a
> > > > > chance to point out that big mistake before it got merged, I'm
> > > > > wondering why you didn't remove them and add your new ones instead.
> > > > > The code rework is minimal. Is it because the definitions are in UAPI?
> > > > > If so, isn't it an even bigger mistake to put more stuff in UAPI? Why
> > > > > would user space care about the SGMII config_reg? There's no user even
> > > > > of the previous SGMII definitions as far as I can tell.
> > > >
> > > > I don't see it as a big deal - certainly not the kind of fuss you're
> > > > making over it.
> > > >
> > >
> > > ...why keep it?
> > > I'm all for creating a common interface for configuring this. It just
> > > makes me wonder how common it is going to be, if there's already a
> > > driver in-tree, from the same PCS hardware vendor, which after the
> > > patchset you're proposing is still going to use a different
> > > infrastructure.
> >
> > Do you see any reason why felix_vsc9959 couldn't make use of the code
> > I'm proposing?
> >
> 
> No. But the intentions just from reading the cover letter and the
> patches seemed a bit unclear. The fact that there are no proposed
> users in this series, and that in your private cex7 branch only dpaa2
> uses it, it seemed to me that at least some clarification was due.
> I have no further comments. The patches themselves are fairly trivial.

I have been told by Andrew to send small series, so that's what I do.

I have not included the DPAA2 changes in this series because it was
not ready for submission - I had to initially hard-code the physical
addresses of the MDIO blocks, but I've later moved to describing them
in the DTS, which now brings with it additional complexities since
(a) existing DTS need to continue working and (b) working out how to
submit those changes since the DTS changes and the net changes should
go via different paths, and ensuring that no breakage will occur
should they become separated.

If you look at the branches that I publish, you will notice that they
are based on v5.5, and so do not contain your changes to felix_vsc9959
that you have been talking about, so felix_vsc9959 is not yet on my
radar.

However, it seems we take different approaches to contributing code to
the kernel; I look to see whether there is value to providing common
infrastructure and then provide it, whereas you seem to take the
approach of writing specific drivers and hope that someone else spots
the code in your driver and converts it to something generic.  I
disagree with your approach because it's been well proven over the
years that the kernel has been around that relying on others to spot
code that could be refactored into common helpers just doesn't happen.
Yes, it happens but only occasionally, and not always when common
helpers get introduced.

You have already proven the worth of having a set of common helpers -
it seems that felix_vsc9959 and DPAA2 can both make use of these,
which does not surprise me one bit, since these helpers are only
implementing what is published in industry standards or defacto
industry standards - and as such are likely to be implemented by a lot
of vendors.  Sure, there will be exceptions and augmentations, which
is something I considered when creating these common helpers.  That's
why they are helpers rather than being mandatory implementations.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
