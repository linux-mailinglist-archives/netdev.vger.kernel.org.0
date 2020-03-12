Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C1EC1830AF
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 13:55:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727228AbgCLMzK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 08:55:10 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:38130 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726632AbgCLMzK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 08:55:10 -0400
Received: by mail-ed1-f66.google.com with SMTP id h5so7289857edn.5
        for <netdev@vger.kernel.org>; Thu, 12 Mar 2020 05:55:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3yKL7jsqK+3wpc14FIaG4QRvbMT9unVl8AB8+pecxhM=;
        b=fY0IngtJfBrIu8P65WJ2ZxRiiVGHc/Vi5tRkwmFB+9081RT/jK126yuMFw4xmLw+/B
         YqfMJr+Vjv2Fk7I059eMiGcNftvK3emuLkYpqQnf1vnMgP92kV3IMB/A9OLPVKIfwo4N
         4UC6PxO9MLyCvy4sJQUPNuVZAOBBu42zxCsURDQuogl6xpfhPsSY3NAHJePLQAtE/rff
         IceBkMGEtabEfRZbXO5xL4G/Tjt1XLmHiOCDoggGiuwCksnB8tDg2VOkWuj0W8ivA3nh
         BXvETCXwcGJaSj4hrFFYySb4fi+5D5pgiqiQe7zP2/vlihm/Mdx58v2JMN6JMmi5Nm/n
         cm6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3yKL7jsqK+3wpc14FIaG4QRvbMT9unVl8AB8+pecxhM=;
        b=HRaoj3q1WSvqZ0v1Oryb1XV2UPg5nbr39Qy9/Tv1rctbToaPlRbRBYlhivP0UWSbNQ
         Ybydng721n++OfNNBVh89yOgrtvEFzM0ZsEjSMckPCjdy7f1QfTLt5+qezeB3k7iWybG
         KEwZxgdk7aRrZmXxZZBJ8JVOh+icHJm4JC/pmRkSStHXaWHPyuI2HDy23yzFLJcTlcHb
         pOoKtOH/SBNe2RQopBJSRMvB40EgOPYs/xAslT6NRqPFg/YvrnNWMvajXBFx1m5AbdhR
         rmNIlu2Ui9g3Ic674ek/C+I5gpSkafyjq7j/g7aBEHmgWkLzET3B5zjb7fddc6s+D3wd
         w2NA==
X-Gm-Message-State: ANhLgQ39gpG1c7G01fZeM4xj/FbzugFUF0gZBeY6XtsnIz6Q8g0xtdXS
        YsqT3YNWNAzgoPwbF8sUCfuF+sYnvBG17HKuaYw=
X-Google-Smtp-Source: ADFU+vtugg/g78mit92A81pNTgsAsPYmG9/UpLJg+4fGUHjoPq9+6rXEGJ572odG2IZG/jj5BE74NQA6TWLxjLJEAXg=
X-Received: by 2002:a50:fd89:: with SMTP id o9mr7821469edt.179.1584017708528;
 Thu, 12 Mar 2020 05:55:08 -0700 (PDT)
MIME-Version: 1.0
References: <20200311120643.GN25745@shell.armlinux.org.uk> <E1jC099-0001cZ-U2@rmk-PC.armlinux.org.uk>
 <CA+h21ho9eWTCJp2+hD0id_e3mfVXw_KRJziACJQMDXxmCnE5xA@mail.gmail.com>
 <20200311170918.GQ25745@shell.armlinux.org.uk> <CA+h21hooqWCqPT2gWtjx2hadXga9e4fAjf4xwavvzyzmdqGNfg@mail.gmail.com>
 <20200311193223.GR25745@shell.armlinux.org.uk> <CA+h21hqnQd=SdQXiNVW5UPuZug8zcM64DUMRvjojZVgMs-tmBQ@mail.gmail.com>
 <20200311203245.GS25745@shell.armlinux.org.uk>
In-Reply-To: <20200311203245.GS25745@shell.armlinux.org.uk>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 12 Mar 2020 14:54:55 +0200
Message-ID: <CA+h21ho9wkWC5E+PwAshjtvKEaFuftewYOauG8yPzf_6F8oVFQ@mail.gmail.com>
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

On Wed, 11 Mar 2020 at 22:32, Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
>
> On Wed, Mar 11, 2020 at 09:59:18PM +0200, Vladimir Oltean wrote:
> > On Wed, 11 Mar 2020 at 21:32, Russell King - ARM Linux admin
> > <linux@armlinux.org.uk> wrote:
> > > So, why abuse some other subsystem's datastructure for something that
> > > is entirely separate, potentially making the maintanence of that
> > > subsystem more difficult for the maintainers?  I don't get why one
> > > would think this is an acceptable approach.
> > >
> > > What you've said is that you want to use struct phy_device, but you
> > > don't want to publish it into the device model, you don't want to
> > > use mdio accesses, you don't want to use phylib helpers.  So, what's
> > > the point of using struct phy_device?  I don't see _any_ reason to
> > > do that and make things unnecessarily more difficult for the phylib
> > > maintainers.
> > >
> >
> > So if it's such a big mistake...
> >
> > > > > Sorry, but you need to explain better what you would like to see here.
> > > > > The additions I'm adding are to the SGMII specification; I find your
> > > > > existing definitions to be obscure because they conflate two different
> > > > > bit fields together to produce something for the ethtool linkmodes
> > > > > (which I think is a big mistake.)
> > > >
> > > > I'm saying that there were already LPA_SGMII definitions in there.
> > > > There are 2 "generic" solutions proposed now and yet they cannot agree
> > > > on config_reg definitions. Omitting the fact that you did have a
> > > > chance to point out that big mistake before it got merged, I'm
> > > > wondering why you didn't remove them and add your new ones instead.
> > > > The code rework is minimal. Is it because the definitions are in UAPI?
> > > > If so, isn't it an even bigger mistake to put more stuff in UAPI? Why
> > > > would user space care about the SGMII config_reg? There's no user even
> > > > of the previous SGMII definitions as far as I can tell.
> > >
> > > I don't see it as a big deal - certainly not the kind of fuss you're
> > > making over it.
> > >
> >
> > ...why keep it?
> > I'm all for creating a common interface for configuring this. It just
> > makes me wonder how common it is going to be, if there's already a
> > driver in-tree, from the same PCS hardware vendor, which after the
> > patchset you're proposing is still going to use a different
> > infrastructure.
>
> Do you see any reason why felix_vsc9959 couldn't make use of the code
> I'm proposing?
>

No. But the intentions just from reading the cover letter and the
patches seemed a bit unclear. The fact that there are no proposed
users in this series, and that in your private cex7 branch only dpaa2
uses it, it seemed to me that at least some clarification was due.
I have no further comments. The patches themselves are fairly trivial.

> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up

Thanks
-Vladimir
