Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 083849BDC5
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 14:49:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728001AbfHXMto (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Aug 2019 08:49:44 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:32804 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727604AbfHXMtn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Aug 2019 08:49:43 -0400
Received: by mail-ed1-f65.google.com with SMTP id s15so18302735edx.0
        for <netdev@vger.kernel.org>; Sat, 24 Aug 2019 05:49:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8T0SGy04KEj892kJFP3YzDqvLn2YzCNcA7YZ9o4NAuk=;
        b=ln+UodIgkj404Ew/2ieeS455PXRmpnfhHyw695pHlhoTbS/E5Z1KG/+m+bUB/HnAH5
         mtoIIXjQ316TIal4AhiVikf0g3zMs7i0N4jo665Lmzdefrqjqp1P9lxbOBnvom6k8Il3
         8BL3F5q7e6JSjn6dmPkhLduD1w0x7xJsQKIz6ZiHqVQdYyNh1y0eEHhi/I++NOUOsGt4
         HR2VxX12Y2Tr4SZGgh4hmk1qN6X06PHtFWKqwtY9s6jxWZPNc0yqm29yySVamPWDcxJJ
         zdAsM0I1gra2Joh3ObPV7AXMbH4cuhApjHFsrlpmmqyfLAc65AXUehsYUsk4iT90HF6f
         FVpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8T0SGy04KEj892kJFP3YzDqvLn2YzCNcA7YZ9o4NAuk=;
        b=uRCm2gANymZtK1PN3EUzXGKI+PT7N4W4W8SNqMxotSNLzxlaBkHjKGnQucB2TN/Ho8
         2K3g645fomdzh0jfL+J7XYrheGMjOPt6a9NO0PXezhJtIAwZPnh7MCnZJlr7wnUBFvZU
         T5KlqeXJcncdLnJBIEJDnJqVI9oEB3AG5Sw2PHrBr7RAlIFRyZt/XfO/9/5fLZNwvyVQ
         JhrYGW/jEJeRC1OqPL6K2ogxcrGnFuJDEcoBgzDCyqpEsqmi1iSkk7GOXRtULHx8fFyW
         zB5wVm12WY9ql3ltTcLXI9AeAWvlodsyKJviVLkf/Ed62PmyDnPQTN7lPPcz0ekY3ER4
         3V5w==
X-Gm-Message-State: APjAAAXyZZkp9DoKVKbWQHL8YtX4NfUnn+LtxQDGBmEiZQ4akw7x132U
        Rvn0p9WDWIMmpANU1w4mgAFn6e/1XOVFlqwqiKQ=
X-Google-Smtp-Source: APXvYqzy4OJZdmNlBilSMdFchzw+k5zngSGbPv75tN/dFux418nHOeCHfISS7SEplzzOXkCZqAGtmHu9jlweq0BrGVM=
X-Received: by 2002:aa7:c508:: with SMTP id o8mr9418357edq.123.1566650981298;
 Sat, 24 Aug 2019 05:49:41 -0700 (PDT)
MIME-Version: 1.0
References: <20190723151702.14430-1-asolokha@kb.kras.ru> <20190723151702.14430-2-asolokha@kb.kras.ru>
 <CA+h21hpacLmKzoeKrdE-frZSTsiYCi4rKCObJ4LfAmfrCJ6H9g@mail.gmail.com> <20190730102329.GZ1330@shell.armlinux.org.uk>
In-Reply-To: <20190730102329.GZ1330@shell.armlinux.org.uk>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sat, 24 Aug 2019 15:49:30 +0300
Message-ID: <CA+h21hqp4L5z3QQ6KV+TkegVg_i+veEXRLSmv7670Tw22t2sSA@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] gianfar: convert to phylink
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Arseny Solokha <asolokha@kb.kras.ru>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

On Tue, 30 Jul 2019 at 13:23, Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
>
> On Tue, Jul 30, 2019 at 02:39:58AM +0300, Vladimir Oltean wrote:
> > To be honest I don't have a complete answer to that question. The
> > literature recommends writing 0x01a0 to the MII_ADVERTISE (0x4)
> > register of the MAC PCS for 1000Base-X, and 0x4001 for SGMII.
>
> That looks entirely sane for both modes.
>
> 0x01a0 for 802.3z (1000BASE-X) is defined in 802.3 37.2.5.1.3 as:
>         bit 5 - full duplex = 1
>         bit 6 - half duplex = 0
>         bit 7 - pause = 1
>         bit 8 - asym_pause = 1
>
> The description of the bits match the config word that is sent in the
> link with the exception of bit 14, which is the acknowledgement bit.
> Normally, in 802.3z, bit 14 will not be set in the transmitted config
> word until we have received the config word from the other end of the
> link.
>
> For SGMII, 0x4001 is the acknowledgement code word, which is defined
> in the SGMII spec as "tx_config_Reg[15:0] sent from the MAC to the
> PHY" which requires:
>         bit 0 - must be 1
>         bit 1 .. 13, 15 - must be 0, reserved for future use
>         bit 14 - must be 1 (auto-negotiation acknowledgement in 802.3z)
>
> > The FMan driver which uses the TSEC MAC does exactly that:
> > https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/tree/drivers/net/ethernet/freescale/fman/fman_dtsec.c#n58
> > However I can't seem to be able to trace down the definition of bit 14
> > from 0x4001 - it's reserved in all the manuals I see. I have a hunch
> > that it selects the format of the Config_Reg base page between
> > 1000Base-X and SGMII.
>
> It could be that is what bit 14 is being used for, or it could just be
> that they've taken the values from the appropriate specs, and the
> hardware behaves the same way irrespective of whether it is in SGMII
> or 1000BASE-X mode.
>

Mystery solved - indeed it appears that there is no hardware logic for
propagating the AN results from the PCS to the MAC. Hence there is no
hardware distinction between 1000Base-X and SGMII. That must be
handled in PHYLINK.

> > > +static int gfar_mac_link_state(struct phylink_config *config,
> > > +                              struct phylink_link_state *state)
> > > +{
> > > +       if (state->interface == PHY_INTERFACE_MODE_SGMII ||
> > > +           state->interface == PHY_INTERFACE_MODE_1000BASEX) {
> >
> > What if you reduce the indentation level by 1 here, by just exiting if
> > the interface mode is not SGMII?
>
> It's only called for in-band negotiation modes anyway, so the above
> protection probably doesn't gain much.
>

Or that.

> > > +               struct gfar_private *priv =
> > > +                       netdev_priv(to_net_dev(config->dev));
> > > +               u16 tbi_cr;
> > > +
> > > +               if (!priv->tbi_phy)
> > > +                       return -ENODEV;
> > > +
> > > +               tbi_cr = phy_read(priv->tbi_phy, MII_TBI_CR);
> > > +
> > > +               state->duplex = !!(tbi_cr & TBI_CR_FULL_DUPLEX);
> >
> > Woah there. Aren't you supposed to first ensure state->an_complete is
> > ok, based on TBI_MII_Register_Set_SR[AN_Done]? There's also a
> > Link_Status bit in that register that you could retrieve.
>
> Indeed.
>
> > > +               if ((tbi_cr & TBI_CR_SPEED_1000_MASK) == TBI_CR_SPEED_1000_MASK)
> > > +                       state->speed = SPEED_1000;
> > > +       }
> >
> > See the Speed_Bit table from TBI_MII_Register_Set_ANLPBPA_SGMII for
> > the link partner (aka SGMII PHY) advertisement. You have to do a
> > logical-and between that and your own. Also please make sure you
> > really are in SGMII AN and not 1000 Base-X when interpreting registers
> > 4 & 5 as one way or another.
>
> From what you've said above, yes, this needs to do exactly that.
>
> > > -static noinline void gfar_update_link_state(struct gfar_private *priv)
> > > +static void gfar_mac_config(struct phylink_config *config, unsigned int mode,
> > > +                           const struct phylink_link_state *state)
> > >  {
> > > +       struct gfar_private *priv = netdev_priv(to_net_dev(config->dev));
> > >         struct gfar __iomem *regs = priv->gfargrp[0].regs;
> > > -       struct net_device *ndev = priv->ndev;
> > > -       struct phy_device *phydev = ndev->phydev;
> > > -       struct gfar_priv_rx_q *rx_queue = NULL;
> > > -       int i;
> > > +       u32 maccfg1, new_maccfg1;
> > > +       u32 maccfg2, new_maccfg2;
> > > +       u32 ecntrl, new_ecntrl;
> > > +       u32 tx_flow, new_tx_flow;
> >
> > Don't introduce new_ variables. Is there any issue if you
> > unconditionally write to the MAC registers?
>
> We do this in every driver, as mac_config() can be called with only a
> small number of changes in the settings, and it is important not to
> upset the MAC for minor updates.
>
> An example of this is when we are in SGMII mode with an attached PHY.
> SGMII will communicate the speed and duplex, but not the results of
> the pause negotiation.  We read that from the attached PHY and report
> it back by calling mac_config() - but at that point, we don't want to
> cause the established link to bounce.
>
> So, mac_config() should be implemented to avoid upsetting an already
> established link where possible (unless the configuration items that
> affect the link have changed.)
>

Ok.

> > > +static void gfar_mac_an_restart(struct phylink_config *config)
> > > +{
> > > +       /* Not supported */
> > > +}
> >
> > What about running gfar_configure_serdes again?
>
> The intention here is to cause the 802.3z link to renegotiate...
>

Yes, gfar_configure_serdes does this:

    phy_write(tbiphy, MII_BMCR,
          BMCR_ANENABLE | BMCR_ANRESTART | BMCR_FULLDPLX |
          BMCR_SPEED1000);

> >
> > > +
> > > +static void gfar_mac_link_down(struct phylink_config *config, unsigned int mode,
> > > +                              phy_interface_t interface)
> > > +{
> > > +       /* Not supported */
> > > +}
> > > +
> >
> > What about disabling RX_EN and TX_EN from MACCFG1?
> >
> > > +static void gfar_mac_link_up(struct phylink_config *config, unsigned int mode,
> > > +                            phy_interface_t interface, struct phy_device *phy)
> > > +{
> > > +       /* Not supported */
> > >  }
> > >
> >
> > What about enabling RX_EN and TX_EN from MACCFG1?
>
> Note that both of these functions must still allow the link to be
> established if we are using in-band negotiation - but they are
> expected to start/stop the transmission of packets.
>

I don't think AN pages count as Ethernet frames, and the RX_EN and
TX_EN bits are MAC settings anyway - it is the PCS below it that would
process them.

> > > @@ -149,8 +148,13 @@ extern const char gfar_driver_version[];
> > >  #define GFAR_SUPPORTED_GBIT SUPPORTED_1000baseT_Full
> > >
> > >  /* TBI register addresses */
> > > +#define MII_TBI_CR             0x00
> > >  #define MII_TBICON             0x11
> > >
> > > +/* TBI_CR register bit fields */
> > > +#define TBI_CR_FULL_DUPLEX     0x0100
> > > +#define TBI_CR_SPEED_1000_MASK 0x0040
> > > +
> >
> > I think BIT() definitions are preferred, even if that means you have
> > to convert existing code first.
>
> If MII_TBI_CR is the BMCR of the PCS, how about using the definitions
> that we already have in the kernel:
>
> BMCR_SPEED1000 is TBI_CR_SPEED_1000_MASK
> BMCR_FULLDPLX is TBI_CR_FULL_DUPLEX
>
> ?

Or that, yes.

>
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
> According to speedtest.net: 11.9Mbps down 500kbps up

Thanks,
-Vladimir
