Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A50671247F5
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 14:21:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbfLRNVQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 08:21:16 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:46619 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726846AbfLRNVQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 08:21:16 -0500
Received: by mail-ed1-f68.google.com with SMTP id m8so1605636edi.13
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 05:21:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4RULlIWj5yi502WjKsqjdS6Hm50j5rn9PAaDKgSDq/4=;
        b=KEP2lkTtay93kH1yDtsegpl8MHkDDO7e/jiHQ6eCULx0caKc6sl+eJihA5P1OT/VZR
         l6BD/kNJoo8z4s5bA713b6O+A9ioC1BZfAogwMVc7NQs76rd8li8ec12loFZ+3MkaDUT
         An71mBehC6wuL2sAWHhTysVGXDTyEvn0ni0jilpD1q/VpNxgY2iRqcNxkbVRxlOHtxBq
         16v3mNXHNJQXx8ehU0+V6QontUo5JGwanNKl0KJOZJy1JxhK2Lo8C15M/3zhvpPLLuZ2
         jFHNtwDtsEoYgVL0Id6OIj3AKcNaDz5lR0z8qRiwKQKGPQqXJH/7aMRa2ptlxh1QHJEn
         50DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4RULlIWj5yi502WjKsqjdS6Hm50j5rn9PAaDKgSDq/4=;
        b=D73h8CRzpYdMuXR11ySOUnvG4SJc2cKVi1KoyYeQQzX7MtX/+HW1tipbz0Wqi8uTHe
         S9Lh7+cYih+0tiQDOarMGRzLmEA/z0YK+psz1Lgwr0K/wGyw5S0hcEg1RClz0hyLkznK
         UJ0Rg4ZxDSf0+qI+iWted0AC9D898XXoIcNBP43cljq+OvqaHQSdN45cKlrKY7w/x2Dh
         2zO0u693WA5M5PDzWKeBqMHNFR/TuDm9bnWL3DyXgDUvV7sImj9vbRHLWQ99BM0q1+bp
         DfsYGvnJv4+ihOcJlvCSu1eoz5gddrE5ybFjqRXIVoyIK6iJAHAQTQ8zsL+59rfgREh9
         C1IQ==
X-Gm-Message-State: APjAAAWuWBCOGQIBtUEyDpRZsvC9SH+13YRuJepcFtuTyXMSJ9s/wmPe
        QvLmzwkf2418vmEh1Ubf1cbaoO5Gp2+UttSfx8I=
X-Google-Smtp-Source: APXvYqw/8F52BBwquFg3it1fuwxTmKQR04DfFhx6CmkNsfLGI76RA/bmDhLGcEGo/B33y8oJ4uVLMjsQ+DhQnMRa17E=
X-Received: by 2002:a17:906:390d:: with SMTP id f13mr2562756eje.151.1576675273640;
 Wed, 18 Dec 2019 05:21:13 -0800 (PST)
MIME-Version: 1.0
References: <20191217221831.10923-1-olteanv@gmail.com> <20191218104008.GT25745@shell.armlinux.org.uk>
In-Reply-To: <20191218104008.GT25745@shell.armlinux.org.uk>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 18 Dec 2019 15:21:02 +0200
Message-ID: <CA+h21hrbqggYxzd6SGhBmy3fUbmG2EFqbOHAnkDu8xPYRP7ewg@mail.gmail.com>
Subject: Re: [RFC PATCH v2 0/8] Convert Felix DSA switch to PHYLINK
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "Y.b. Lu" <yangbo.lu@nxp.com>, netdev <netdev@vger.kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

On Wed, 18 Dec 2019 at 12:40, Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
>
> On Wed, Dec 18, 2019 at 12:18:23AM +0200, Vladimir Oltean wrote:
> > The SerDes protocol which the driver calls 2500Base-X mode (a misnomer) is more
> > interesting. There is a description of how it works and what can be done with
> > it in patch 8/8 (in a comment above vsc9959_pcs_init_2500basex).
> > In short, it is a fixed speed protocol with no auto-negotiation whatsoever.
> > From my research of the SGMII-2500 patent [1], it has nothing to do with
> > SGMII-2500. That one:
> > * does not define any change to the AN base page compared to plain 10/100/1000
> >   SGMII. This implies that the 2500 speed is not negotiable, but the other
> >   speeds are. In our case, when the SerDes is configured for this protocol it's
> >   configured for good, there's no going back to SGMII.
> > * runs at a higher base frequency than regular SGMII. So SGMII-2500 operating
> >   at 1000 Mbps wouldn't interoperate with plain SGMII at 1000 Mbps. Strange,
> >   but ok..
> > * Emulates lower link speeds than 2500 by duplicating the codewords twice, then
> >   thrice, then twice again etc (2.5/25/250 times on average). The Layerscape
> >   PCS doesn't do that (it is fixed at 2500 Mbaud).
> >
> > But on the other hand it isn't Base-X either, since it doesn't do 802.3z /
> > clause 37 auto negotiation (flow control, local/remote fault etc).
>
> Most documentation I've seen for these 2.5Gbps modes from a few vendors
> suggests that every vendor has its own ideas.
>
> With Marvell, for example, whether the gigabit MAC is operating at 1G
> or 2.5G is controlled by the serdes "comphy" block, and from what I can
> tell merely increases the clocking rate by 2.5x when 2.5G mode is
> selected.
>
> I suspect all the features of conventional 1G mode are also available
> when running at this higher speed, but many don't make sense. For
> example, if the MAC (there's no distinction of the PCS there) was
> configured for 100Mbps, but the comphy was configured for 2.5G, we'd
> end up with 250Mbps by 10x replication on the link. This has never been
> tested though.
>
> Whether in-band AN is enabled or not is separately configurable,
> although the Marvell Armada 370 documentation states that when the port
> is configured for 1000Base-X, in-band AN must be enabled. I suspect the
> same is stated for later devices. However, practical testing seems to
> suggest that it will work without in-band AN enabled if the other side
> doesn't want in-band AN.
>
> > So it is a protocol in its own right (a rather fixed one). If reviewers think
> > it should have its own phy-mode, different than 2500base-x, I'm in favor of
> > that. It's just that I couldn't find a suitable name for it. quarter-xaui?
> > 3125mhz-8b10b?
>
> I think just call it 2500base-x without in-band negotiation.
>

Ok, I already have the check in vsc9959_pcs_init_2500basex for
link_an_mode == MLO_AN_INBAND, so I guess that should be fine.

> > When inter-operating with the Aquantia AQR112 and AQR412 PHYs in this mode (for
> > which the PHY uses a proprietary name "OCSGMII"), we do still need to support
> > the lower link speeds negotiated by the PHY on copper side. So what we
> > typically do is we enable rate adaptation in the PHY firmware, with pause
> > frames and a fixed link speed on the system side. Raising this as a discussion
> > item to understand how we can model this quirky operating mode in Linux without
> > imposing limitations on others (we have some downstream patches on the Aquantia
> > PHY driver as well).
> >
> > Another item to discuss is whether we should be able to disable AN in the PCS
> > independently of whether we have a PHY as a peer or not. With an SGMII PHY-less
> > connection, there may be no auto-negotiation master so the link partners will
> > bounce for a while and then they'll settle on 10 Mbps as link speed. For those
> > connections (such as an SGMII link to a downstream switch) we need to disable
> > AN in the PCS and force the speed to 1000.
>
> With Marvell, there's the in-band AN enable bit, but there's also an
> in-band AN bypass bit, which allows the in-band AN to time out when
> the 16-bit configuration word is not received after a certain period
> of time after the link has been established.
>
> As for disabling AN... see below.
>
> > So:
> > * If we have a PHY we want to do auto-neg
> > * If we don't have a PHY, maybe we want AN, maybe we don't
> > * In the 2500Base-X mode, we can't do AN because the hardware doesn't support it
> >
> > I have found the 'managed = "in-band-status"' DTS binding to somewhat address
> > this concern, but I am a bit reluctant to disable SGMII AN if it isn't set.
>
> I believe the in-band-status thing came from mvneta prior to phylink.
> mvneta supports operating in SGMII with no in-band AN, and the default
> setup that the driver adopted in SGMII mode was without in-band AN
> enabled. When in-band AN was required, that's when this DT property
> came about.
>
> mvneta was the basis for phylink creation (as it was the first platform
> I had that we needed to support SFPs). Compatibility with mvneta had to
> be maintained to avoid regressions, so that got built-in to phylink.
>
> When we are not operating in in-band AN mode, then yes, we do disable
> in-band AN at the MAC for mvneta and mvpp2. What others do, I haven't
> delved into. However, it is important - I have a SFP that uses a
> Broadcom PHY that does not provide any in-band AN when in SGMII mode.
> It is SGMII mode, because it supports the symbol replication for 100
> and 10Mbps - but Broadcom's expectation is that the MAC is forced to
> the appropriate speed after reading the PHY registers.
>
> I think the reason it does this is because it's a NBASE-T PHY, and you
> have to read the PHY registers to know what protocol its using on the
> serdes lane, which could be one of 10GBASE-R, 5000BASE-X, 2500BASE-X
> or SGMII at 1G, 100M or 10M depending on the copper side negotiation
> results.
>
> This works with mvneta and mvpp2 since, when operating in fixed or
> phy mode in phylink, we disable in-band AN and force the MAC
> settings.
>
> Keeping this consistent across drivers (where possible) would be my
> preference to avoid different behaviours and surprises.
>
> > We have boards with device trees that need to be migrated from PHYLIB and I
> > am concerned that changing the behavior w.r.t. in-band AN (when the
> > "in-band-status" property is not present) is not going to be pleasant.
> > I do understand that the "in-band-status" property is primarily intended to be
> > used with PHY-less setups, and it looks like the fact it does work with PHYs as
> > well is more of an oversight (as patch 2/8 shows). So I'm not sure who else
> > really uses it with a phy-handle.
>
> That partly depends on the PHY. Given what I've said above, some PHYs
> require in-band AN to complete before they will pass data, other MACs
> will not establish a link if in-band AN is enabled but there is no
> in-band control word, even if the bypass bit is enabled.
>

I think the Layerscape PCS falls to 10 Mbps if AN is enabled but no
config word is received. At least that's how it behaves when it is put
in loopback mode. Naturally traffic doesn't pass through the PHY if
that has negotiated a gigabit link on copper side.

> Using in-band AN with a PHY results in faster link establishment, and
> also has the advantage that when the link goes down, the MAC responds
> a lot quicker than the 1sec phylib poll to stop transmitting.
>
> I tend to run my boards with in-band AN enabled even for on-board PHYs
> although I've not pushed those patches upstream.  Most PHYs on these
> boards come up with in-band AN bypass enabled, so it doesn't matter
> whether in-band AN is enabled or disabled.
>

Ok, makes some sense. We discussed a little bit internally and the
conclusion, as Alex put it, is that it takes two to AN.
Perhaps I would be more confident about this if the PHY driver had
awareness of the PHYLINK link_an_mode, in order to coordinate its
settings with what the PCS expects, and vice-versa.
On the LS1028A-RDB board we have 2 issues related to SGMII AN at the moment:

- The at803x.c driver explicitly checks for the ACK from the MAC PCS,
and prints "SGMII link is not ok" otherwise, and refuses to bring the
link up. This hurts us in 4.19 because I think the check is a bit
misplaced in the .aneg_done callback. To be precise, what we observe
is that this function is not called by the state machine a second,
third time etc to recheck if the AN has completed in the meantime. In
current net-next, as far as I could figure out, at803x_aneg_done is
dead code. What is ironic about the commit f62265b53ef3 ("at803x:
double check SGMII side autoneg") that introduced this function is
that it's for the gianfar driver (Freescale eTSEC), a MAC that has
never supported reprogramming itself based on the in-band config word.
In fact, if you look at gfar_configure_serdes, it even configures its
register 0x4 with an advertisement for 1000Base-X, not SGMII (0x4001).
So I really wonder if there is any real purpose to this check in
at803x_aneg_done, and if not, I would respectfully remove it.

- The vsc8514 PHY driver configures SerDes AN in U-Boot, but not in
Linux. So we observe that if we disable PHY configuration in U-Boot,
in-band AN breaks in Linux. We are actually wondering how we should
fix this: from what you wrote above, it seems ok to hardcode SGMII AN
in the PHY driver, and just ignore it in the PCS if managed =
"in-band-status" is not set with PHYLINK. But as you said, in the
general case maybe not all PHYs work until they haven't received the
ACK from the MAC PCS, which makes this insufficient as a general
solution.

But the 2 cases above illustrate the lack of consistency among PHY
drivers w.r.t. in-band aneg.

> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
> According to speedtest.net: 11.9Mbps down 500kbps up

Thanks,
-Vladimir
