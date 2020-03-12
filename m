Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2092A1831AA
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 14:36:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727170AbgCLNgC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 09:36:02 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:33976 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725978AbgCLNgC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 09:36:02 -0400
Received: by mail-ed1-f67.google.com with SMTP id i24so3569103eds.1
        for <netdev@vger.kernel.org>; Thu, 12 Mar 2020 06:36:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TfzYmDdFwMhi3rvAlx0N1b/v3RgpuLIScsO2kftWFRU=;
        b=Mh2Szyg3ON89etwHLVFWNzBHeUnn+eFzmlSkb8owykxM2pA1uxCf7F9Dg8rzn/UMvq
         TuwnxeY6uBai+NYJv6T0ljhnWbnCGYzEWDp0zKq8ZYTww/vWG8B/kN5wR6Z0rCYNetXE
         cmDmKm5+0+eJR7DxbaDzBFsPooK3aUXx5NYDu06EYFpZULzaR+Fep7XwAIqxjH43+FKD
         8fg39ZdLnft1S07D1VlErIck269GaBp3YN85tiOl3nycgxCfQu2p5tb+X1zeROkvIBLH
         uS6QgHKruImTFqxG/CH35mxOeynyi+w54jjn3gq32jTsMfPqdTfnAVFBVZSL1sv/c6HT
         Pmtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TfzYmDdFwMhi3rvAlx0N1b/v3RgpuLIScsO2kftWFRU=;
        b=fE4JSHxrSN4MnCujRnYY9ueplZs6ZfE4/iwgQLy4hL5HdSB1FVLbgoBQizyHAl4wH8
         VHbqXweBmQ0zmyEJFEZwscazQdIx07b123stGp8QQo/BXZROjGp6Ndkz+mQPU/E8KY/y
         dHTfAWD1S6r1gtfu6GB7c32JAgNSjdyU0fUx6SlUHHLQzj7qLzHZ10Kbk3TlYn7QEGij
         k+9vscOH0qiPJbMEaN+WAK0quAxQpeyqzEdemjCdaFy5Sq5N3x6Df1q8i5q0JJPSeWO/
         W24cFHkeIwKmPNhywBwFPZDXC5CDEaceeAJd3EFpmeNUl+B/va+CQXCXhuxtK2IS2JEH
         a2Nw==
X-Gm-Message-State: ANhLgQ3bEg1wNhl6SGdp00IbfhG5O85nPE/5RVls1JdQFvSC7U5OQLxE
        K/olIYpGXaHd1gIfCHLr2j6mhFw0KtaidZ6tOuc=
X-Google-Smtp-Source: ADFU+vunQGB3iCnXEW6hl+B9y+6rdlQpYzyG/xRadrVfHSBmMHbuVExWq1NX6umShlY41UCfRPQ7IiJrVirI8vMMrag=
X-Received: by 2002:aa7:d98b:: with SMTP id u11mr8190253eds.318.1584020159993;
 Thu, 12 Mar 2020 06:35:59 -0700 (PDT)
MIME-Version: 1.0
References: <20200311120643.GN25745@shell.armlinux.org.uk> <E1jC099-0001cZ-U2@rmk-PC.armlinux.org.uk>
 <CA+h21ho9eWTCJp2+hD0id_e3mfVXw_KRJziACJQMDXxmCnE5xA@mail.gmail.com>
 <20200311170918.GQ25745@shell.armlinux.org.uk> <CA+h21hooqWCqPT2gWtjx2hadXga9e4fAjf4xwavvzyzmdqGNfg@mail.gmail.com>
 <20200311193223.GR25745@shell.armlinux.org.uk> <CA+h21hqnQd=SdQXiNVW5UPuZug8zcM64DUMRvjojZVgMs-tmBQ@mail.gmail.com>
 <20200311203245.GS25745@shell.armlinux.org.uk> <CA+h21ho9wkWC5E+PwAshjtvKEaFuftewYOauG8yPzf_6F8oVFQ@mail.gmail.com>
 <20200312131326.GA25745@shell.armlinux.org.uk>
In-Reply-To: <20200312131326.GA25745@shell.armlinux.org.uk>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 12 Mar 2020 15:35:49 +0200
Message-ID: <CA+h21hoOpiz6bEh7ZvZ1b7pQMbkW5-u1ZYt+Z2M32kOdA+pO-g@mail.gmail.com>
Subject: Re: [PATCH net-next 4/5] net: phylink: pcs: add 802.3 clause 22 helpers
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Mar 2020 at 15:13, Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
>
> On Thu, Mar 12, 2020 at 02:54:55PM +0200, Vladimir Oltean wrote:
> > On Wed, 11 Mar 2020 at 22:32, Russell King - ARM Linux admin
> > <linux@armlinux.org.uk> wrote:
> > >
> > > On Wed, Mar 11, 2020 at 09:59:18PM +0200, Vladimir Oltean wrote:
> > > > On Wed, 11 Mar 2020 at 21:32, Russell King - ARM Linux admin
> > > > <linux@armlinux.org.uk> wrote:
> > > > > So, why abuse some other subsystem's datastructure for something that
> > > > > is entirely separate, potentially making the maintanence of that
> > > > > subsystem more difficult for the maintainers?  I don't get why one
> > > > > would think this is an acceptable approach.
> > > > >
> > > > > What you've said is that you want to use struct phy_device, but you
> > > > > don't want to publish it into the device model, you don't want to
> > > > > use mdio accesses, you don't want to use phylib helpers.  So, what's
> > > > > the point of using struct phy_device?  I don't see _any_ reason to
> > > > > do that and make things unnecessarily more difficult for the phylib
> > > > > maintainers.
> > > > >
> > > >
> > > > So if it's such a big mistake...
> > > >
> > > > > > > Sorry, but you need to explain better what you would like to see here.
> > > > > > > The additions I'm adding are to the SGMII specification; I find your
> > > > > > > existing definitions to be obscure because they conflate two different
> > > > > > > bit fields together to produce something for the ethtool linkmodes
> > > > > > > (which I think is a big mistake.)
> > > > > >
> > > > > > I'm saying that there were already LPA_SGMII definitions in there.
> > > > > > There are 2 "generic" solutions proposed now and yet they cannot agree
> > > > > > on config_reg definitions. Omitting the fact that you did have a
> > > > > > chance to point out that big mistake before it got merged, I'm
> > > > > > wondering why you didn't remove them and add your new ones instead.
> > > > > > The code rework is minimal. Is it because the definitions are in UAPI?
> > > > > > If so, isn't it an even bigger mistake to put more stuff in UAPI? Why
> > > > > > would user space care about the SGMII config_reg? There's no user even
> > > > > > of the previous SGMII definitions as far as I can tell.
> > > > >
> > > > > I don't see it as a big deal - certainly not the kind of fuss you're
> > > > > making over it.
> > > > >
> > > >
> > > > ...why keep it?
> > > > I'm all for creating a common interface for configuring this. It just
> > > > makes me wonder how common it is going to be, if there's already a
> > > > driver in-tree, from the same PCS hardware vendor, which after the
> > > > patchset you're proposing is still going to use a different
> > > > infrastructure.
> > >
> > > Do you see any reason why felix_vsc9959 couldn't make use of the code
> > > I'm proposing?
> > >
> >
> > No. But the intentions just from reading the cover letter and the
> > patches seemed a bit unclear. The fact that there are no proposed
> > users in this series, and that in your private cex7 branch only dpaa2
> > uses it, it seemed to me that at least some clarification was due.
> > I have no further comments. The patches themselves are fairly trivial.
>
> I have been told by Andrew to send small series, so that's what I do.
>
> I have not included the DPAA2 changes in this series because it was
> not ready for submission - I had to initially hard-code the physical
> addresses of the MDIO blocks, but I've later moved to describing them
> in the DTS, which now brings with it additional complexities since
> (a) existing DTS need to continue working and (b) working out how to
> submit those changes since the DTS changes and the net changes should
> go via different paths, and ensuring that no breakage will occur
> should they become separated.
>

I think even asking for firmware ABI changes in MC is worth a shot? It
might be preferable to get away with the firmware giving you the PCS
base address for a DPMAC rather than getting it from DT, for the
reasons that you've mentioned. Or even asking for ABI for the firmware
to perform the MDIO read/write itself.

> If you look at the branches that I publish, you will notice that they
> are based on v5.5, and so do not contain your changes to felix_vsc9959
> that you have been talking about, so felix_vsc9959 is not yet on my
> radar.
>

Yes, I noticed.

> However, it seems we take different approaches to contributing code to
> the kernel; I look to see whether there is value to providing common
> infrastructure and then provide it, whereas you seem to take the
> approach of writing specific drivers and hope that someone else spots
> the code in your driver and converts it to something generic.  I
> disagree with your approach because it's been well proven over the
> years that the kernel has been around that relying on others to spot
> code that could be refactored into common helpers just doesn't happen.
> Yes, it happens but only occasionally, and not always when common
> helpers get introduced.
>
> You have already proven the worth of having a set of common helpers -
> it seems that felix_vsc9959 and DPAA2 can both make use of these,
> which does not surprise me one bit, since these helpers are only
> implementing what is published in industry standards or defacto
> industry standards - and as such are likely to be implemented by a lot
> of vendors.  Sure, there will be exceptions and augmentations, which
> is something I considered when creating these common helpers.  That's
> why they are helpers rather than being mandatory implementations.
>

Nothing wrong with that. I'm willing to try to rework felix using
these helpers, but I just don't have the time right now. That and
DPAA2 make it look like it may take a while for the first users to
come... Apologies in advance if there are other immediate potential
users which are not on my radar.

> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up

-Vladimir
