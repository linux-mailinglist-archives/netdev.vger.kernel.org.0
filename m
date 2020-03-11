Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87D0F18208D
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 19:17:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730818AbgCKSQ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 14:16:58 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:44781 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730808AbgCKSQ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 14:16:57 -0400
Received: by mail-ed1-f68.google.com with SMTP id g19so4016400eds.11
        for <netdev@vger.kernel.org>; Wed, 11 Mar 2020 11:16:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=H0ejefJkzyVxMt4r3E5BOHqparUAk3E79XeQrcheTXI=;
        b=NHB5oaS7OGjWukDazVV7yfM6MwI+9sPZIHIoZMIGvza4TH4jmXn2w1O1Gibv4WfHbU
         fDqxkwAi/XMOND8umKf2Ert6GhsSE4yV/M4hZJmAq7rGaCt5icjZZZf3ekh4coJyGPK1
         LIxiN49Wg2qi2Fkrnu5vHmzCQSS1zmwAUuv3dGRgCFdU51EAl7YjNhFlMV7tDVyO+nY+
         X4GeylLzAiEk1JK7WoVUP8C9ZSi3mGHEp6GjeCdJ0hsLmfWwZG1HOSc1cHPjL/pSeQaI
         Yzb1gh0/E8yeQk/GxbXR0Lz8A6jm0DVqL8vKGdxefqNCzcJp51YIoEghZ8NeNYdPYFII
         kAaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=H0ejefJkzyVxMt4r3E5BOHqparUAk3E79XeQrcheTXI=;
        b=dW1wcWnWXZLoS5i9l0ybBCvW94TclWFRThFG0S8hLB8c6r2eMil9uhkQ4HTx6rifw1
         +K6djqD20M9LmtjdH7rAZ65kl37Oxt/k/XXsxDm3u9FuDnpVfFWoMnoVi9oASouUVEj7
         l+n+uUExiweriVROqPsm4zb0C/6loRKxO8L9fPwLh7ix0DJsrY7Oq+d3DolbBYFeB93t
         Px4R4VMAyQ48X4Prc1OTTnpJhU4gdoSqmzeaXmV0jFdBVHhTi47YNEkxcuUTSEw6gAYJ
         OMHWjewsDSMejOiCIySfrEesVOwpgXpWjvZiM+GBQ29shp+ZThlr010abdgaYi2XaQ4j
         +wVg==
X-Gm-Message-State: ANhLgQ0SMuD4gODYWrdZvWCd47bBHiqe/J1a6TvUWuZVVCORUpYPhrZt
        9FRTTBPm3JtUNnfQIWSz91u1eDwBo7o3cA5ou38HvR0q
X-Google-Smtp-Source: ADFU+vvSJAXIuGrABfmZOko840ueS2xPlnMfS8T6cLhRHO1MvIQMSEZRRScyMmApGoB/eSL+Vp8Q3hDGlevs2lJRBUE=
X-Received: by 2002:a05:6402:128c:: with SMTP id w12mr4246098edv.368.1583950615821;
 Wed, 11 Mar 2020 11:16:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200311120643.GN25745@shell.armlinux.org.uk> <CA+h21hoq2qkmxDFEb2QgLfrbC0PYRBHsca=0cDcGOr3txy9hsg@mail.gmail.com>
 <20200311125445.GO25745@shell.armlinux.org.uk> <CA+h21hpk+TMofHFjg_Z-UZOPp+7zn29ZNLFP+JKreJtbZouiZQ@mail.gmail.com>
 <20200311170541.GP25745@shell.armlinux.org.uk>
In-Reply-To: <20200311170541.GP25745@shell.armlinux.org.uk>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 11 Mar 2020 20:16:44 +0200
Message-ID: <CA+h21hq7nTW+qE=0roPVV8h8BQmL8z90Y+6wTTW4xX4dRoQAxA@mail.gmail.com>
Subject: Re: [PATCH net-next 0/5] add phylink support for PCS
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

On Wed, 11 Mar 2020 at 19:05, Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
>
> On Wed, Mar 11, 2020 at 03:57:18PM +0200, Vladimir Oltean wrote:
> > On Wed, 11 Mar 2020 at 14:54, Russell King - ARM Linux admin
> > <linux@armlinux.org.uk> wrote:
> > >
> > > On Wed, Mar 11, 2020 at 02:46:33PM +0200, Vladimir Oltean wrote:
> > > > Hi Russell,
> > > >
> > > > On Wed, 11 Mar 2020 at 14:09, Russell King - ARM Linux admin
> > > > <linux@armlinux.org.uk> wrote:
> > > > >
> > > > > Hi,
> > > > >
> > > > > This series adds support for IEEE 802.3 register set compliant PCS
> > > > > for phylink.  In order to do this, we:
> > > > >
> > > > > 1. convert the existing (unused) mii_lpa_to_ethtool_lpa_x() function
> > > > >    to a linkmode variant.
> > > > > 2. add a helper for clause 37 advertisements, supporting both the
> > > > >    1000baseX and defacto 2500baseX variants. Note that ethtool does
> > > > >    not support half duplex for either of these, and we make no effort
> > > > >    to do so.
> > > > > 3. add accessors for modifying a MDIO device register, and use them in
> > > > >    phylib, rather than duplicating the code from phylib.
> > > >
> > > > Have you considered accessing the PCS as a phy_device structure, a la
> > > > drivers/net/dsa/ocelot/felix_vsc9959.c?
> > >
> > > I don't want to tie this into phylib, because I don't think phylib
> > > should be dealing with PCS.  It brings with it many problems, such as:
> > >
> >
> > Agree that the struct mdio_device -> struct phy_device diff is pretty
> > much useless to a PCS.
> >
> > > 1. how do we know whether the Clause 22 registers are supposed to be
> > >    Clause 37 format.
> >
> > Well, they are, aren't they?
>
> For a PCS, yes, but phylib generally deals with clause 22 format
> registers (which define the copper capabilities rather than 1000baseX
> which clause 37 covers.)
>

I still don't get the point of why would [phylib] be confused about
whether to interpret capabilities as copper or fiber. Because in my
proposal, the MAC driver would populate the capabilities and not
phylib (genphy_read_abilities).

> >
> > > 2. how do we program the PCS appropriately for the negotiation results
> > >    (which phylib doesn't support).
> >
> > You mean how to read the LPA and logically-AND it with ADV?
> > The PCS doesn't need to be "programmed" according to the resolved link
> > state. Maybe the MAC does.
>
> No, I'm talking about configuring the PCS for SGMII mode when in-band
> AN is not being used.
>

Again, not with phylib.

> > > 3. how do we deal with selecting the appropriate device for the mode
> > >    selected (LX2160A has multiple different PCS which depend on the
> > >    mode selected.)
> >
> > What I've been doing is to call get_phy_device with an is_c45 argument
> > depending on the PHY interface type.
> > Actually the real problem in your case is that the LX2160A doesn't
> > expose a valid PHY ID in registers 2&3 (unlike other Layerscape PCS
> > implementations), so get_phy_device is likely going to fail unless
> > some sort of PHY ID fixup is not done.
>
> What SolidRun are pressing NXP for on the LX2160A is to move the
> networking support to a more dynamic arrangement than it is at
> present - I know there was a conference call on Monday about this,
> but I only found out about it too late to be part of it, and so far
> no one has filled me in on what was discussed.
>
> However, SolidRun wish the networking to be more dynamically
> configurable on the LX2160A - right now, we have a problem that we
> can either configure _all_ the QSFP+ and SFP ports (e.g.) to 10G
> mode, or _all_ QSFP+ and SFP ports to 1G mode - which basically
> makes the QSFP+ useless.  It's too inflexible.
>
> What I would like to see are individual ports or groups of ports
> being able to be reconfigured on the fly, which means sticking to
> one particular PCS will not be possible.
>
> Other platforms do support dynamically switching between different
> components depending on the speed, and I see no reason to prevent
> such flexibility in phylink by designing into it a "you can only
> have one PCS device" assumption.
>

DPAA2 is not exactly my turf anyway, but let's keep the discussion on point.
I think that neither your or my proposal would be inherently limited
to having a static PCS object, be it an mdio_device or a phy_device.
I'm not really sure how this came to be an argument. Hardware design
limitations are a separate topic.

> > > Note that a phy_device structure embeds a mdio_device structure, and
> > > so these helpers can be used inside phylib if one desires - so this
> > > approach is more flexible than "bolt it into phylib" approach would
> > > be.
> > >
> >
> > It's hard to really say without seeing more than one caller of these
> > new helpers.
> > For example the sja1105 DSA switch has a PCS for SGMII (not supported
> > yet in mainline) that kind-of-emulates a C22 register map, except that
> > it's accessed over SPI, and that the "pcs_get_state" needs to look at
> > some vendor-specific registers too.
>
> I don't think "it's accessed over SPI" is much of an issue at all.
> The solution to that is trivial - as has been already shown with
> PHYs that are accessed over I2C.
>

So your recommendation is to write an mdio-to-spi bridge, and keep
using the mdio_device object for a SPI-controlled PCS. Basically
another container.

> > From that perspective, I was
> > thinking that PHYLINK could be given a phy_device structure with the
> > advertising, supported and lp_advertising linkmode bit fields
> > populated who-knows-how, and PHYLINK just resolves that into its
> > phylink_link_state structure.
> > But then I guess that sort of hardware is not among your target
> > candidates for the generic helpers. Whoever can't expose an MDIO bus
> > or needs to access any vendor-specific register just shouldn't use
> > these functions. And maybe you're right, I don't really know what the
> > balance in practice will be.
>
> I don't see why you'd think that having a phy_device structure would
> make it easier to access a SPI based PHY.  If you can't access the
> PHY over MDIO, none of the phylib helpers can be used,

Same can be said when using the mdio_device structure for the PCS, really.

> so you're
> just using struct phy_device as a container and wrapping it with a
> load of custom code.
>

Yes.

> As long as the phy_device structure is registered with the device
> model, phy drivers can potentially bind with the "special" phy device
> and attempt to access it via the MDIO bus - it sounds like that's
> something you don't want to happen.
>

Yes, correct. But it's not registered with the device model. It's just
a data structure privately used by the MAC driver.

> So, I'd question whether it makes any sense to (ab)use struct phy_device
> for something that is not going to use phylib at all.
>

My reasoning was that I didn't want to do the bit twiddling with the
config word in the driver, and PHYLIB already having helpers for that
sounded good.
At no point had it crossed my mind that PHYLINK would even be a
candidate for hosting these functions. I guess PHYLINK is the new
PHYLIB now?

> It seems way more sensible to have a "struct pcs_device" that operates
> entirely separately to phylib - and maybe we can lift some of the phylib
> functionality to mdio_device level (such as what I've done with
> accessors, but maybe more stuff) so it can be spared between PCS and
> conventional phylib users.
>

Yes, with a little more feedback on the "Convert Felix DSA switch to
PHYLINK" series, I would have probably ended up doing exactly that.
Abusing a phy_device structure is not exactly amazing.

> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
