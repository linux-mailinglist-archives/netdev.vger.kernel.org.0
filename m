Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AA25182118
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 19:45:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730784AbgCKSpI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 14:45:08 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:37976 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730691AbgCKSpH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 14:45:07 -0400
Received: by mail-ed1-f68.google.com with SMTP id h5so4161662edn.5
        for <netdev@vger.kernel.org>; Wed, 11 Mar 2020 11:45:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dRlnwXWMAPmIaUgKt52LuaocF5ofK2dRFgnYtCVjwAo=;
        b=bWaVAAvDDIVJCM4tl2MYR+XyG8O7FGJgJul2HjjxzOcrF44C3XYKd/yywxjLbt647p
         r7lOWsQcvr2fMvLtfc4qAqcdlz4BDUOVlst9zI0BOKn7iYPJbAaMWWLbsO4JkXnZHCdq
         P67mjJNnMNQyFmLU/MbXe0auHSXXjnkTGraoMonyX8DfUN2CxllEzlFVsSwcrqkkjorF
         Ax2bud+SJtDZLldFrZYQxtepPYlBMNPws1KT2fiXFpKr48deJN/jcFaAhuf32Ekfrp7K
         +Dcs2k1+nnJN7kFjPVGrX8XyVahfHOYKEfvNo0cM8DvVrvOWkRINfMS+DG5DT6Gfu9/r
         P+EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dRlnwXWMAPmIaUgKt52LuaocF5ofK2dRFgnYtCVjwAo=;
        b=o2RKxMkweoXfciYeyEoY4l3FW60ux74XK7vBHGBjeAKFqXvJ8ntyObUB9N2WIj2Hqi
         WAAREjI1PPndO4pucgastly6i6HDGP5j9IkBABS/0XvLRQ3xMf5mP0YlqvdZbSQkXM67
         ADHSTcNOBzekO4yyUpORVLKH9vyH9pk/Bk7TSL8VS+k3iaAoZohUt8ap1ie+ikDnUTNN
         P5OxkS6TNdP3abfjPkHTZ9xsdzERHP9I5BEDyNU4M4OgIDiaozNJ+mXABwlKzOS0fp1E
         DwxSMPbiJDqOHBVrPgUgcrrVnCFk4hNtVtC6yZTRq1vGUjk3tbJPyN6HzrGEV6bXtf+2
         D6hA==
X-Gm-Message-State: ANhLgQ2+6rWeDS/QGik17vQXO0tnLz7/2O14onKWdL/rJi8gPtt693an
        T+PdtTAEX0x4SQV6y2n5Ix9vQTaVmZODVVdQTq4=
X-Google-Smtp-Source: ADFU+vs99TPvOnVxxYmv2US1ZtvxptsoVdjyDnOfnA9LBjuWmCbbGe4v5InFfi2P9Bd/Z2CxNZIfZSCV3mPaTIDJvGs=
X-Received: by 2002:a05:6402:c:: with SMTP id d12mr4279455edu.337.1583952305814;
 Wed, 11 Mar 2020 11:45:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200311120643.GN25745@shell.armlinux.org.uk> <E1jC099-0001cZ-U2@rmk-PC.armlinux.org.uk>
 <CA+h21ho9eWTCJp2+hD0id_e3mfVXw_KRJziACJQMDXxmCnE5xA@mail.gmail.com> <20200311170918.GQ25745@shell.armlinux.org.uk>
In-Reply-To: <20200311170918.GQ25745@shell.armlinux.org.uk>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 11 Mar 2020 20:44:54 +0200
Message-ID: <CA+h21hooqWCqPT2gWtjx2hadXga9e4fAjf4xwavvzyzmdqGNfg@mail.gmail.com>
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

On Wed, 11 Mar 2020 at 19:09, Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
>
> On Wed, Mar 11, 2020 at 04:06:52PM +0200, Vladimir Oltean wrote:
> > On Wed, 11 Mar 2020 at 14:08, Russell King <rmk+kernel@armlinux.org.uk> wrote:
> > >
> > > Implement helpers for PCS accessed via the MII bus using 802.3 clause
> > > 22 cycles, conforming to 802.3 clause 37 and Cisco SGMII specifications
> > > for the advertisement word.
> > >
> > > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> > > ---
> > >  drivers/net/phy/phylink.c | 206 ++++++++++++++++++++++++++++++++++++++
> > >  include/linux/phylink.h   |   6 ++
> > >  include/uapi/linux/mii.h  |   5 +
> > >  3 files changed, 217 insertions(+)
> > >
> > > diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> > > index 19db68d74cb4..3ef20b34f5d6 100644
> > > --- a/drivers/net/phy/phylink.c
> > > +++ b/drivers/net/phy/phylink.c
> > > @@ -2035,4 +2035,210 @@ void phylink_helper_basex_speed(struct phylink_link_state *state)
> > >  }
> > >  EXPORT_SYMBOL_GPL(phylink_helper_basex_speed);
> > >
> > > +static void phylink_decode_c37_word(struct phylink_link_state *state,
> > > +                                   uint16_t config_reg, int speed)
> > > +{
> > > +       bool tx_pause, rx_pause;
> > > +       int fd_bit;
> > > +
> > > +       if (speed == SPEED_2500)
> > > +               fd_bit = ETHTOOL_LINK_MODE_2500baseX_Full_BIT;
> > > +       else
> > > +               fd_bit = ETHTOOL_LINK_MODE_1000baseX_Full_BIT;
> > > +
> > > +       mii_lpa_mod_linkmode_x(state->lp_advertising, config_reg, fd_bit);
> > > +
> > > +       if (linkmode_test_bit(fd_bit, state->advertising) &&
> > > +           linkmode_test_bit(fd_bit, state->lp_advertising)) {
> > > +               state->speed = speed;
> > > +               state->duplex = DUPLEX_FULL;
> > > +       } else {
> > > +               /* negotiation failure */
> > > +               state->link = false;
> > > +       }
> > > +
> > > +       linkmode_resolve_pause(state->advertising, state->lp_advertising,
> > > +                              &tx_pause, &rx_pause);
> > > +
> > > +       if (tx_pause)
> > > +               state->pause |= MLO_PAUSE_TX;
> > > +       if (rx_pause)
> > > +               state->pause |= MLO_PAUSE_RX;
> > > +}
> > > +
> > > +static void phylink_decode_sgmii_word(struct phylink_link_state *state,
> > > +                                     uint16_t config_reg)
> > > +{
> > > +       if (!(config_reg & LPA_SGMII_LINK)) {
> > > +               state->link = false;
> > > +               return;
> > > +       }
> > > +
> > > +       switch (config_reg & LPA_SGMII_SPD_MASK) {
> >
> > Did you consider using or adapting the mii_lpa_mod_linkmode_adv_sgmii helper?
>
> Yes, and we _do not_ want to be touching state->lp_advertising here.
> The link partner advertisement comes from the attached PHY, not from
> this information.
>

Understood, and I never suggested to touch state->lp_advertising, but
rather pcs->lp_advertising.

> The config_reg information is not an advertisement - it is a
> _configuration word_ coming from the PHY to tell the MAC what speed
> and duplex to operate at.

Arguably the abuse here is Cisco's, since config_reg _was_ supposed to
be an auto-neg advertisement as per clause 37. It is just the SGMII
spec that makes it asymmetrical.

> It conveys nothing about whether it's
> 1000baseT or 1000baseX, so link modes mean nothing as far as a SGMII
> configuration word is concerned.

My initial point was that _for this pcs device_, the link partner _is_
the PHY if it's SGMII. Otherwise you wouldn't find the config_reg in
register 5.

>
> Hence, _this_ is a more correct implementation than
> mii_lpa_mod_linkmode_adv_sgmii().
>
> > > +       case LPA_SGMII_10:
> > > +               state->speed = SPEED_10;
> > > +               break;
> > > +       case LPA_SGMII_100:
> > > +               state->speed = SPEED_100;
> > > +               break;
> > > +       case LPA_SGMII_1000:
> > > +               state->speed = SPEED_1000;
> > > +               break;
> > > +       default:
> > > +               state->link = false;
> > > +               return;
> > > +       }
> > > +       if (config_reg & LPA_SGMII_FULL_DUPLEX)
> > > +               state->duplex = DUPLEX_FULL;
> > > +       else
> > > +               state->duplex = DUPLEX_HALF;
> > > +}
> > > +
> > > +/**
> > > + * phylink_mii_c22_pcs_get_state() - read the MAC PCS state
> > > + * @pcs: a pointer to a &struct mdio_device.
> > > + * @state: a pointer to a &struct phylink_link_state.
> > > + *
> > > + * Helper for MAC PCS supporting the 802.3 clause 22 register set for
> > > + * clause 37 negotiation and/or SGMII control.
> > > + *
> > > + * Read the MAC PCS state from the MII device configured in @config and
> > > + * parse the Clause 37 or Cisco SGMII link partner negotiation word into
> > > + * the phylink @state structure. This is suitable to be directly plugged
> > > + * into the mac_pcs_get_state() member of the struct phylink_mac_ops
> > > + * structure.
> > > + */
> > > +void phylink_mii_c22_pcs_get_state(struct mdio_device *pcs,
> > > +                                  struct phylink_link_state *state)
> > > +{
> > > +       struct mii_bus *bus = pcs->bus;
> > > +       int addr = pcs->addr;
> > > +       int bmsr, lpa;
> > > +
> > > +       bmsr = mdiobus_read(bus, addr, MII_BMSR);
> > > +       lpa = mdiobus_read(bus, addr, MII_LPA);
> > > +       if (bmsr < 0 || lpa < 0) {
> > > +               state->link = false;
> > > +               return;
> > > +       }
> > > +
> > > +       state->link = !!(bmsr & BMSR_LSTATUS);
> > > +       state->an_complete = !!(bmsr & BMSR_ANEGCOMPLETE);
> > > +       if (!state->link)
> > > +               return;
> > > +
> > > +       switch (state->interface) {
> > > +       case PHY_INTERFACE_MODE_1000BASEX:
> > > +               phylink_decode_c37_word(state, lpa, SPEED_1000);
> > > +               break;
> > > +
> > > +       case PHY_INTERFACE_MODE_2500BASEX:
> > > +               phylink_decode_c37_word(state, lpa, SPEED_2500);
> > > +               break;
> > > +
> > > +       case PHY_INTERFACE_MODE_SGMII:
> > > +               phylink_decode_sgmii_word(state, lpa);
> > > +               break;
> > > +
> > > +       default:
> > > +               state->link = false;
> > > +               break;
> > > +       }
> > > +}
> > > +EXPORT_SYMBOL_GPL(phylink_mii_c22_pcs_get_state);
> > > +
> > > +/**
> > > + * phylink_mii_c22_pcs_set_advertisement() - configure the clause 37 PCS
> > > + *     advertisement
> > > + * @pcs: a pointer to a &struct mdio_device.
> > > + * @state: a pointer to the state being configured.
> > > + *
> > > + * Helper for MAC PCS supporting the 802.3 clause 22 register set for
> > > + * clause 37 negotiation and/or SGMII control.
> > > + *
> > > + * Configure the clause 37 PCS advertisement as specified by @state. This
> > > + * does not trigger a renegotiation; phylink will do that via the
> > > + * mac_an_restart() method of the struct phylink_mac_ops structure.
> > > + *
> > > + * Returns negative error code on failure to configure the advertisement,
> > > + * zero if no change has been made, or one if the advertisement has changed.
> > > + */
> > > +int phylink_mii_c22_pcs_set_advertisement(struct mdio_device *pcs,
> > > +                                       const struct phylink_link_state *state)
> > > +{
> > > +       struct mii_bus *bus = pcs->bus;
> > > +       int addr = pcs->addr;
> > > +       int val, ret;
> > > +       u16 adv;
> > > +
> > > +       switch (state->interface) {
> > > +       case PHY_INTERFACE_MODE_1000BASEX:
> > > +       case PHY_INTERFACE_MODE_2500BASEX:
> > > +               adv = ADVERTISE_1000XFULL;
> > > +               if (linkmode_test_bit(ETHTOOL_LINK_MODE_Pause_BIT,
> > > +                                     state->advertising))
> > > +                       adv |= ADVERTISE_1000XPAUSE;
> > > +               if (linkmode_test_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
> > > +                                     state->advertising))
> > > +                       adv |= ADVERTISE_1000XPSE_ASYM;
> > > +
> > > +               val = mdiobus_read(bus, addr, MII_ADVERTISE);
> > > +               if (val < 0)
> > > +                       return val;
> > > +
> > > +               if (val == adv)
> > > +                       return 0;
> > > +
> > > +               ret = mdiobus_write(bus, addr, MII_ADVERTISE, adv);
> > > +               if (ret < 0)
> > > +                       return ret;
> > > +
> > > +               return 1;
> > > +
> > > +       case PHY_INTERFACE_MODE_SGMII:
> > > +               val = mdiobus_read(bus, addr, MII_ADVERTISE);
> > > +               if (val < 0)
> > > +                       return val;
> > > +
> > > +               if (val == 0x0001)
> > > +                       return 0;
> > > +
> > > +               ret = mdiobus_write(bus, addr, MII_ADVERTISE, 0x0001);
> > > +               if (ret < 0)
> > > +                       return ret;
> > > +
> > > +               return 1;
> > > +
> > > +       default:
> > > +               /* Nothing to do for other modes */
> > > +               return 0;
> > > +       }
> > > +}
> > > +EXPORT_SYMBOL_GPL(phylink_mii_c22_pcs_set_advertisement);
> > > +
> > > +/**
> > > + * phylink_mii_c22_pcs_an_restart() - restart 802.3z autonegotiation
> > > + * @pcs: a pointer to a &struct mdio_device.
> > > + *
> > > + * Helper for MAC PCS supporting the 802.3 clause 22 register set for
> > > + * clause 37 negotiation.
> > > + *
> > > + * Restart the clause 37 negotiation with the link partner. This is
> > > + * suitable to be directly plugged into the mac_pcs_get_state() member
> > > + * of the struct phylink_mac_ops structure.
> > > + */
> > > +void phylink_mii_c22_pcs_an_restart(struct mdio_device *pcs)
> > > +{
> > > +       struct mii_bus *bus = pcs->bus;
> > > +       int val, addr = pcs->addr;
> > > +
> > > +       val = mdiobus_read(bus, addr, MII_BMCR);
> > > +       if (val >= 0) {
> > > +               val |= BMCR_ANRESTART;
> > > +
> > > +               mdiobus_write(bus, addr, MII_BMCR, val);
> > > +       }
> > > +}
> > > +EXPORT_SYMBOL_GPL(phylink_mii_c22_pcs_an_restart);
> > > +
> > >  MODULE_LICENSE("GPL v2");
> > > diff --git a/include/linux/phylink.h b/include/linux/phylink.h
> > > index 2180eb1aa254..de591c2fb37e 100644
> > > --- a/include/linux/phylink.h
> > > +++ b/include/linux/phylink.h
> > > @@ -317,4 +317,10 @@ int phylink_mii_ioctl(struct phylink *, struct ifreq *, int);
> > >  void phylink_set_port_modes(unsigned long *bits);
> > >  void phylink_helper_basex_speed(struct phylink_link_state *state);
> > >
> > > +void phylink_mii_c22_pcs_get_state(struct mdio_device *pcs,
> > > +                                  struct phylink_link_state *state);
> > > +int phylink_mii_c22_pcs_set_advertisement(struct mdio_device *pcs,
> > > +                                       const struct phylink_link_state *state);
> > > +void phylink_mii_c22_pcs_an_restart(struct mdio_device *pcs);
> > > +
> > >  #endif
> > > diff --git a/include/uapi/linux/mii.h b/include/uapi/linux/mii.h
> > > index 0b9c3beda345..90f9b4e1ba27 100644
> > > --- a/include/uapi/linux/mii.h
> > > +++ b/include/uapi/linux/mii.h
> > > @@ -134,11 +134,16 @@
> > >  /* MAC and PHY tx_config_Reg[15:0] for SGMII in-band auto-negotiation.*/
> > >  #define ADVERTISE_SGMII                0x0001  /* MAC can do SGMII            */
> > >  #define LPA_SGMII              0x0001  /* PHY can do SGMII            */
> > > +#define LPA_SGMII_SPD_MASK     0x0c00  /* SGMII speed mask            */
> > > +#define LPA_SGMII_FULL_DUPLEX  0x1000  /* SGMII full duplex           */
> > >  #define LPA_SGMII_DPX_SPD_MASK 0x1C00  /* SGMII duplex and speed bits */
> > > +#define LPA_SGMII_10           0x0000  /* 10Mbps                      */
> > >  #define LPA_SGMII_10HALF       0x0000  /* Can do 10mbps half-duplex   */
> > >  #define LPA_SGMII_10FULL       0x1000  /* Can do 10mbps full-duplex   */
> > > +#define LPA_SGMII_100          0x0400  /* 100Mbps                     */
> > >  #define LPA_SGMII_100HALF      0x0400  /* Can do 100mbps half-duplex  */
> > >  #define LPA_SGMII_100FULL      0x1400  /* Can do 100mbps full-duplex  */
> > > +#define LPA_SGMII_1000         0x0800  /* 1000Mbps                    */
> >
> > These seem a bit mixed up to say the least.
> > If you're not going to use the (minimal) existing infrastructure could
> > you also refactor the one existing user? I think it would be better
> > than just keeping adding conflicting definitions.
>
> Sorry, but you need to explain better what you would like to see here.
> The additions I'm adding are to the SGMII specification; I find your
> existing definitions to be obscure because they conflate two different
> bit fields together to produce something for the ethtool linkmodes
> (which I think is a big mistake.)
>

I'm saying that there were already LPA_SGMII definitions in there.
There are 2 "generic" solutions proposed now and yet they cannot agree
on config_reg definitions. Omitting the fact that you did have a
chance to point out that big mistake before it got merged, I'm
wondering why you didn't remove them and add your new ones instead.
The code rework is minimal. Is it because the definitions are in UAPI?
If so, isn't it an even bigger mistake to put more stuff in UAPI? Why
would user space care about the SGMII config_reg? There's no user even
of the previous SGMII definitions as far as I can tell.

> >
> > >  #define LPA_SGMII_1000HALF     0x0800  /* Can do 1000mbps half-duplex */
> > >  #define LPA_SGMII_1000FULL     0x1800  /* Can do 1000mbps full-duplex */
> > >  #define LPA_SGMII_LINK         0x8000  /* PHY link with copper-side partner */
> > > --
> > > 2.20.1
> > >
> >
> > Regards,
> > -Vladimir
> >
>
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
