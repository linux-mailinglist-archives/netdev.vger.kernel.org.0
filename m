Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1821818C449
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 01:38:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726975AbgCTAin (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 20:38:43 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:43990 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725787AbgCTAin (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 20:38:43 -0400
Received: by mail-ed1-f68.google.com with SMTP id n25so4154147eds.10
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 17:38:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SnMDiUsf0gLzR7Dht4JACDUEl2yuy7X2DACh6GqC7I8=;
        b=aDLugUvmVbLY1i9QzAhQGKNTMTAIDH+R6fdWI03dxNFqqWkuE3TcJjqU98gEkZN2qE
         i5NJoW0vWdDSLAF2Ad2RsosHAvniKaQ0GQ1Z5iByZOOdSuCInZiLmQsuW8ueo/45GT98
         hevhm2/Y2yjue+vq05lrWqN+qV8R+sSYd0rBqcXeNDVOdMMRPMX+w8EohjK8hS1zC5LQ
         tdq0MtLwA/VUB/E51Komr6PTmdF5vhGA6grF6kK+nMWI2Mb7PmlrQPtR2iQ6YRnyvTwy
         J3BT/IkoI4KuynSyIf/AxVhJJZ9KFmj1RyQ4f4YEDZmjCCTdf1Yq2uH56bXJRi/mxkUX
         vusg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SnMDiUsf0gLzR7Dht4JACDUEl2yuy7X2DACh6GqC7I8=;
        b=uaESvttUE08RX9uW4OM9K+cjnl0Z8MLec0b/VYcl3O3220oNiSgjxyUEE+2DXqY9XS
         ypM8DSQjyaiztER0lkU85jEuLiv9UDp9fPaoVLSeZaVvA4QWWS7cutWKpe9ILNggxgGA
         4TQtyv+UH7pjSjtFTim536L36bgYdyf9RIJ/x1doCGYuxmTHcffEmtpdOrmT9EOh474S
         gcQP2SUXb+5bnARWwoBRxoYXgvOcABfQEB7aZeP8X3MYG6xg50WeS0lgWlw6bwaiSslm
         H3dKitKny5ljDhy+FlLiZqn+suFJWK/vtDS64E5Bih1ydEzAylp8wsmiEcpGEPI5+0Y2
         mcAw==
X-Gm-Message-State: ANhLgQ0jQDiKA1sC5ObId16zE/Upl//1WfsVx1kf5EL/YDd9EDA0O2jl
        eGh2/ETTvouU1JGb98cQtxP8S32k06Bq4iCUsvY=
X-Google-Smtp-Source: ADFU+vsa1kiuxkyuUDwlu1eMkuhKVm3kxxqk7vYEBEnzgLen6vD/kwzbrTyQhECc/FlBtdlRkC3BQT7nrNa/MWVaE8s=
X-Received: by 2002:a17:906:1308:: with SMTP id w8mr5628496ejb.189.1584664721069;
 Thu, 19 Mar 2020 17:38:41 -0700 (PDT)
MIME-Version: 1.0
References: <20200319235313.26579-1-olteanv@gmail.com> <20200320000622.GI25745@shell.armlinux.org.uk>
In-Reply-To: <20200320000622.GI25745@shell.armlinux.org.uk>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Fri, 20 Mar 2020 02:38:30 +0200
Message-ID: <CA+h21howFajxEWhmRDDcZhvrA6Rr10pX8MJUkE9f0CAeOVOeSA@mail.gmail.com>
Subject: Re: [PATCH net-next] net: dsa: sja1105: Add support for the SGMII port
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 Mar 2020 at 02:06, Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
>
> On Fri, Mar 20, 2020 at 01:53:13AM +0200, Vladimir Oltean wrote:
> > @@ -774,10 +881,14 @@ static void sja1105_mac_config(struct dsa_switch *ds, int port,
> >               return;
> >       }
> >
> > -     if (link_an_mode == MLO_AN_INBAND) {
> > +     if (link_an_mode == MLO_AN_INBAND && !is_sgmii) {
> >               dev_err(ds->dev, "In-band AN not supported!\n");
> >               return;
> >       }
> > +
> > +     if (is_sgmii)
> > +             sja1105_sgmii_config(priv, port, link_an_mode == MLO_AN_INBAND,
> > +                                  state->speed);
>
> Please avoid new usages of state->speed in mac_config() - I'm trying
> to eliminate them now that the mac_link_up() patches are in.  If you
> need to set the PCS for the link speed, please hook that into
> mac_link_up() instead.
>

Well, duh. I forward-ported this from a 5.4 kernel and I simply forgot
to do this extra change. I'll still have to turn it around when I
backport it again, but whatever.

> >  }
> >
> >  static void sja1105_mac_link_down(struct dsa_switch *ds, int port,
> > @@ -833,7 +944,8 @@ static void sja1105_phylink_validate(struct dsa_switch *ds, int port,
> >       phylink_set(mask, 10baseT_Full);
> >       phylink_set(mask, 100baseT_Full);
> >       phylink_set(mask, 100baseT1_Full);
> > -     if (mii->xmii_mode[port] == XMII_MODE_RGMII)
> > +     if (mii->xmii_mode[port] == XMII_MODE_RGMII ||
> > +         mii->xmii_mode[port] == XMII_MODE_SGMII)
> >               phylink_set(mask, 1000baseT_Full);
> >
> >       bitmap_and(supported, supported, mask, __ETHTOOL_LINK_MODE_MASK_NBITS);
> > @@ -841,6 +953,82 @@ static void sja1105_phylink_validate(struct dsa_switch *ds, int port,
> >                  __ETHTOOL_LINK_MODE_MASK_NBITS);
> >  }
> >
> > +static int sja1105_mac_pcs_get_state(struct dsa_switch *ds, int port,
> > +                                  struct phylink_link_state *state)
> > +{
> > +     struct sja1105_private *priv = ds->priv;
> > +     int bmcr;
> > +
> > +     bmcr = sja1105_sgmii_read(priv, MII_BMCR);
> > +     if (bmcr < 0)
> > +             return bmcr;
> > +
> > +     state->an_enabled = !!(bmcr & BMCR_ANENABLE);
> > +
> > +     if (state->an_enabled) {
>
> mac_pcs_get_state() is only called when in in-band AN mode, so this
> is not useful.  If it's called with AN disabled, that's a bug.
>

Correct. In fact I only 'tested' in-band AN via register dumps. On my
board it is physically impossible to really make use of
mac_pcs_get_state because port 4 is a PHY-less interface (the CPU
port), and if there were any in-band AN to take place at all, this
switch port would have to be the AN master, and there isn't logic for
that at the moment.
Because there isn't more than 1 SGMII port in this 5-port switch, I
suspect that AN disabled is going to be the case for pretty much every
other board out there.
Since I did spend the time to figure out how it should work, I thought
it might have been useful to have some code, even if just
blind-tested, for whomever needed it. But after your comment, I'm not
willing to figure out now how to split the PCS config function to be
called from the AN as well as non-AN code paths. So I'll just drop any
sort of AN code in v2.

> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up

Thanks,
-Vladimir
