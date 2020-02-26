Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 464E016FF67
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 14:00:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbgBZNAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 08:00:44 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:34583 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbgBZNAo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 08:00:44 -0500
Received: by mail-ed1-f67.google.com with SMTP id dm3so2826630edb.1;
        Wed, 26 Feb 2020 05:00:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=i7Xarv2hD9KM3iFuS54Ru9bKcOGPu5KjR9uTv1osMOg=;
        b=fp1uLlhoEDIppUss2KYKNKY4d1mhmPRC8g4ZZUX2FUtGF4674dqcrGEiFURI8s6IJ/
         Lp5unYBiTaL6m5d8S4+hSSJ/mpPym7jo17nCg6ct8tGl/I++fEao4abWZZNE1j/UDMye
         Zk+LzdgZ2JEunZiAgYnqCYbwBoeH2US7tG/sYmEG8C3wcGD/k+6d/fh3frvL3kaVmU8Y
         Fu8atlRj/0Yd332oHmPz+IEYX26/DolqLcp4/mwVAuajSUjedJL3+I/cxgc77IQ7bo2b
         1onH8FIsA0aSR6jcVhz6kuWiIMLeTN7B6XdNUjPMHrlcLIuVgB5NV2AdtcqQT/q9NuDt
         oPQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=i7Xarv2hD9KM3iFuS54Ru9bKcOGPu5KjR9uTv1osMOg=;
        b=fLSHvSq/q0289xp57ap3zj+7ovZIupG2+hLQZr0EvcBwwBJ1vi81TeX976Y78Wy16F
         0AY7MiOxn36J+2+/0fZiUu5AABNVZR/JG0L/sO5TdYx8hjkb1jErBi+JsTdIYvrpeFeo
         ufuw9exoCZq6An/nfM717PlN9PELHZi7lZsv3+oy/iWKYjAxVtmJHVHvhQxl1GsjuzQR
         laAKJJs2Yj0wVy8rPmvu1YVuf6YFQlLWOm9SYr+7CkSsiUYykJI1jfdMqaZmBIGc7p4U
         5IM0PkudeyzRSDwmgCwR6EA9RmTTZxYffgmxyHZuvObJ7TvGWq3Wf5gvOxShiue851i+
         kWRw==
X-Gm-Message-State: APjAAAV8TvYY2T2eQB/GT5fxKuje2IxGG1L5wGFJVuUiigmilRB+XRJo
        o7I+rNfu4yh8qoGGO858ZXnC/xu0UXnVMlUy2UQ=
X-Google-Smtp-Source: APXvYqzP5j9YFugxizJBSHCcJcie/58YM/x3+plzu9o9NKjOQ2J0PzX1ZNdCx8ey6OabcsuTekBFd565F0sozXWKY14=
X-Received: by 2002:a17:906:af99:: with SMTP id mj25mr4363408ejb.293.1582722041507;
 Wed, 26 Feb 2020 05:00:41 -0800 (PST)
MIME-Version: 1.0
References: <20200226102312.GX25745@shell.armlinux.org.uk> <E1j6tqv-0003G6-BO@rmk-PC.armlinux.org.uk>
 <CA+h21hrR1Xkx9gwAT2FHqcH38L=xjWiPxmF2Er7-4fHFTrA8pQ@mail.gmail.com> <20200226115549.GZ25745@shell.armlinux.org.uk>
In-Reply-To: <20200226115549.GZ25745@shell.armlinux.org.uk>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 26 Feb 2020 15:00:30 +0200
Message-ID: <CA+h21hqjMBjgQDee8t=Csy5DXVUk9f=PP0hHSDfkuA746ZKzSQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/8] net: phylink: propagate resolved link
 config via mac_link_up()
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Michal Simek <michal.simek@xilinx.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        John Crispin <john@phrozen.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Felix Fietkau <nbd@nbd.name>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 26 Feb 2020 at 13:56, Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
>
> On Wed, Feb 26, 2020 at 01:06:06PM +0200, Vladimir Oltean wrote:
> > Hi Russell,
> >
> > On Wed, 26 Feb 2020 at 12:23, Russell King <rmk+kernel@armlinux.org.uk> wrote:
> > >
> > > Propagate the resolved link parameters via the mac_link_up() call for
> > > MACs that do not automatically track their PCS state. We propagate the
> > > link parameters via function arguments so that inappropriate members
> > > of struct phylink_link_state can't be accessed, and creating a new
> > > structure just for this adds needless complexity to the API.
> > >
> > > Tested-by: Andre Przywara <andre.przywara@arm.com>
> > > Tested-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
> > > Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> > > ---
> > >  Documentation/networking/sfp-phylink.rst      | 17 +++++-
> > >  drivers/net/ethernet/cadence/macb_main.c      |  7 ++-
> > >  .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  |  7 ++-
> > >  drivers/net/ethernet/marvell/mvneta.c         |  8 ++-
> > >  .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 19 +++++--
> > >  drivers/net/ethernet/mediatek/mtk_eth_soc.c   |  7 ++-
> > >  .../net/ethernet/stmicro/stmmac/stmmac_main.c |  4 +-
> > >  .../net/ethernet/xilinx/xilinx_axienet_main.c |  7 ++-
> > >  drivers/net/phy/phylink.c                     |  9 ++-
> > >  include/linux/phylink.h                       | 57 ++++++++++++++-----
> > >  net/dsa/port.c                                |  4 +-
> > >  11 files changed, 105 insertions(+), 41 deletions(-)
> > >
> > > diff --git a/Documentation/networking/sfp-phylink.rst b/Documentation/networking/sfp-phylink.rst
> > > index d753a309f9d1..8d7af28cd835 100644
> > > --- a/Documentation/networking/sfp-phylink.rst
> > > +++ b/Documentation/networking/sfp-phylink.rst
> > > @@ -74,10 +74,13 @@ phylib to the sfp/phylink support.  Please send patches to improve
> > >  this documentation.
> > >
> > >  1. Optionally split the network driver's phylib update function into
> > > -   three parts dealing with link-down, link-up and reconfiguring the
> > > -   MAC settings. This can be done as a separate preparation commit.
> > > +   two parts dealing with link-down and link-up. This can be done as
> > > +   a separate preparation commit.
> > >
> > > -   An example of this preparation can be found in git commit fc548b991fb0.
> > > +   An older example of this preparation can be found in git commit
> > > +   fc548b991fb0, although this was splitting into three parts; the
> > > +   link-up part now includes configuring the MAC for the link settings.
> > > +   Please see :c:func:`mac_link_up` for more information on this.
> > >
> > >  2. Replace::
> > >
> > > @@ -207,6 +210,14 @@ this documentation.
> > >     using. This is particularly important for in-band negotiation
> > >     methods such as 1000base-X and SGMII.
> > >
> > > +   The :c:func:`mac_link_up` method is used to inform the MAC that the
> > > +   link has come up. The call includes the negotiation mode and interface
> > > +   for reference only. The finalised link parameters are also supplied
> > > +   (speed, duplex and flow control/pause enablement settings) which
> > > +   should be used to configure the MAC when the MAC and PCS are not
> > > +   tightly integrated, or when the settings are not coming from in-band
> > > +   negotiation.
> > > +
> > >     The :c:func:`mac_config` method is used to update the MAC with the
> > >     requested state, and must avoid unnecessarily taking the link down
> > >     when making changes to the MAC configuration.  This means the
> >
> > Just to make sure I understand the changes:
> > - A MAC with no PCS can be configured in either .mac_config or .mac_link_up
>
> I would much prefer mac_link_up to be used for setting the speed,
> duplex and pause modes for future-proofing in all cases except for
> the case where these parameters are automatically updated in the
> MAC from its associated PCS.
>
> mac_link_up must not be used to configure the AN mode or interface
> mode; these must be configured in mac_config().
>
> > - A MAC that needs to be manually reconfigured to the link mode
> > negotiated by its PCS needs to have the PCS configured in .mac_config
> > and the MAC in .mac_link_up
>
> I do have further changes that split the PCS ops from the MAC ops, so
> what is in this series is not the full story yet - some of the further
> patches can be found in my "phy" branch and "cex7" branches where I add
> support to dpaa2 for automatically switching between SGMII and
> 1000BASE-X.  dpaa2 is one of these split PCS/MAC setups, but with the
> extra complication that there's a firmware layer between the PCS and
> MAC.
>
> However, this series is the first stand-alone step along the road to
> supporting split PCS/MAC setups in a sane manner.
>
> I discussed with Andrew Lunn how much to send, and the conclusion was
> to make the changes in a number of small patch series, as large patch
> series tend not to get reviewed.  My experience with _this_ series is
> that even this is very difficult to get feedback for, so adding any
> additional patches will just make that worse.
>
> > - A MAC with PCS where the MAC follows the PCS negotiation
> > automatically in hardware is basically equivalent with a MAC with no
> > PCS, and therefore can be configured in either .mac_config or
> > .mac_link_up
>
> In this case, mac_link_up doesn't do anything with the speed/duplex/
> pause stuff when those are automatically passed from the PCS.
>
> I'm afraid that sentence contains a subtlety that's going to get
> people: it is not clear cut because of the different natures of the
> various links.
>
> In 1000BASE-X, speed is fixed at 1G, and the PCS autonegotiates the
> duplex and pause with the remote end.  For mvneta (an example of a
> combined PCS/MAC implementation) operating in-band:
> - In mac_config():
>   - configures for 1000BASE-X interface type with in-band AN.
>   - configures fixed 1G.
>   - As mvneta only supports full duplex, we disable duplex negotiation
>     and force full duplex.
>   - Only symmetric pause is supported, and we set the symmetric pause
>     advertisement appropriately, with pause negotiation enabled.
> - In mac_link_up():
>   - merely allow the device to transmit and receive.
>
> The MAC will be forced to 1G, full duplex, and will automatically be
> configured by the PCS for pause support depending on the hardware
> based pause resolution.
>
> The situation is different for SGMII operating in-band:
> - In mac_config():
>   - configures for SGMII interface type with in-band AN.
>   - configures speed and duplex negotiation.
>   - disables pause negotiation; SGMII has no support for this.
> - In mac_link_up():
>   - enables or disables pause frames depending on the tx_pause/
>     rx_pause flags, since this is not available from the MAC.
>   - allow the device to transmit and receive.
>
> If we aren't operating in in-band mode, then:
> - In mac_config():
>   - configures for the interface type without in-band AN.
>   - disables speed, duplex and pause negotiation.
> - In mac_link_up():
>   - sets the speed, duplex and pause frames depending on the passed
>     parameters.

But there shouldn't be any requirement for this to be configured at
this step and not earlier?

>   - allow the device to transmit and receive.
>
> Please see patch 7 of this series which implements this for mvneta.
>
> So, there is a split between what mac_config() should be doing and what
> mac_link_up() should be doing; this is why I've said in the
> documentation that the "mode" and "interface" are for reference only in
> mac_link_up() - mac_link_up() can use these to decide _how_ to program
> the resolved parameters, but should _not_ use them to determine the
> link configuration (such as changing the interface between SGMII and
> 1000BASE-X - that is the responsibility of mac_config().)

Does any driver currently make any use of the phy_interface_t argument
provided as reference in .mac_link_up?

>
> I hope that helps clarify the situation.
>
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
> According to speedtest.net: 11.9Mbps down 500kbps up

Ok, so basically what is known early, as well as whatever is needed
for the in-band AN preparation, is configured in .mac_config and what
is known late is configured in .mac_link_up.
Except that you would like to slowly move everything MAC-related to
.mac_link_up, and everything PCS-related to .mac_config, presumably in
an effort to convert .mac_config to .pcs_config and .mac_link_up to
.mac_config. I don't actually know what other patches you have in the
cex7 branch you mentioned. Please consider that people don't
necessarily bookmark your git trees. I've spent some good 10 minutes
searching for the "cex7" and "phy" keywords in emails received from
you, and haven't found the git links.

Regards,
-Vladimir
