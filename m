Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09DC22A31C2
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 18:39:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725933AbgKBRjG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 12:39:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbgKBRjG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 12:39:06 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B7CEC0617A6
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 09:39:06 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id g12so15574541wrp.10
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 09:39:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=beug8rSGdVv9nknm2eq8FdDcTPsIcs2+dxy9NZYSMV4=;
        b=qKmkrDYaYqf1dBku92wDvzwkTAc6Eb5QdBkKEM87z60/oloJGnMe38EdFLWbDnQkao
         Oz+/YbMk9wUHs7NcE9C71eqYi/Fb+iePybmgEZxck1ufzKfvuyH3eGt3XkuEvw2KV0Q3
         2CewRmTwOIpvoukYiRRZ3boCkHWhmLWBw8YdBsV/8IsFgB9ayc/MdBxtgd9hDVkTtSNl
         PDJ9qf2NQB+pIBAiSlEHK1CBJYYwvvl3QIBRV+PsvrvskjokC8qx0B1NosYV2zSG4zON
         iPHH8lxpAk0UX7zPiaMdWVSG0CQv7Tb+TOKKzsD77wfyj2RNabc9X1VVAHnUpCZnx9s2
         6ZAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=beug8rSGdVv9nknm2eq8FdDcTPsIcs2+dxy9NZYSMV4=;
        b=pyZyHroa/Wa46LqF1k96XH4nAQFb5dicTHsSBlI+xlsxogWE5fnL6CUjGAm+JoUslE
         NQMG54SF+gAF3E3cdrz/NIw2HyoRlOSN9FQhAhLaEAuIPCJBhf0bhc3xm5COGKqv9HdW
         vFSoWGcecofuoQl+48OgrqyhlrhoV2rS7IscZI61fBTxaLgkz2cHeNr5In6H+1Uw1eF5
         72Y08x8VJB9KA/AycncTtJo+1uyS9b0diRp4Ly8vT3bDZR7UmgzE8WVrkezzqIXGBChG
         CptMFXtGeOPx24XURwoop7i8jaYCo5L6VNyiYCrfaPMRDtf/S9TRh+Hiqja90ghM0rSo
         SCXw==
X-Gm-Message-State: AOAM533RCKv+alHkAXg1Y39KTjIxa2cKgq/nzxEGQ61LhMOfbbLsfosu
        kIndNf6dF7UMxNRup4i7mv5nQrZGQkUPYzr/S3qXuw==
X-Google-Smtp-Source: ABdhPJz/9lQHF7e//RPYuva9mSXOpNErgoDuVi5s7iKr9ImN5gVVwjO810HocraK0F9tZpai0gEl7VTMyThFxlo7Uiw=
X-Received: by 2002:adf:e80d:: with SMTP id o13mr20433888wrm.3.1604338744929;
 Mon, 02 Nov 2020 09:39:04 -0800 (PST)
MIME-Version: 1.0
References: <20200620092047.GR1551@shell.armlinux.org.uk> <E1jmZgq-0001UG-1c@rmk-PC.armlinux.org.uk>
 <CAPv3WKdJKAEwCoj5z6NzP2xRFfT1HG+2o0wigt=Czi4bG7EQcg@mail.gmail.com>
In-Reply-To: <CAPv3WKdJKAEwCoj5z6NzP2xRFfT1HG+2o0wigt=Czi4bG7EQcg@mail.gmail.com>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Mon, 2 Nov 2020 18:38:54 +0100
Message-ID: <CAPv3WKfEN22cKbM8=+qDANefQE67KQ1zwURrCqAsrbo1+gBCDA@mail.gmail.com>
Subject: Re: [PATCH net-next 2/4] net: mvpp2: add mvpp2_phylink_to_port() helper
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>, sashal@kernel.org
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        stable@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Gabor Samu <samu_gabor@yahoo.ca>,
        Jon Nettleton <jon@solid-run.com>,
        Andrew Elwell <andrew.elwell@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Greg and Sasha,

pt., 9 pa=C5=BA 2020 o 05:43 Marcin Wojtas <mw@semihalf.com> napisa=C5=82(a=
):
>
> Hi,
>
> sob., 20 cze 2020 o 11:21 Russell King <rmk+kernel@armlinux.org.uk> napis=
a=C5=82(a):
> >
> > Add a helper to convert the struct phylink_config pointer passed in
> > from phylink to the drivers internal struct mvpp2_port.
> >
> > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> > ---
> >  .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 29 +++++++++----------
> >  1 file changed, 14 insertions(+), 15 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/=
net/ethernet/marvell/mvpp2/mvpp2_main.c
> > index 7653277d03b7..313f5a60a605 100644
> > --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > @@ -4767,12 +4767,16 @@ static void mvpp2_port_copy_mac_addr(struct net=
_device *dev, struct mvpp2 *priv,
> >         eth_hw_addr_random(dev);
> >  }
> >
> > +static struct mvpp2_port *mvpp2_phylink_to_port(struct phylink_config =
*config)
> > +{
> > +       return container_of(config, struct mvpp2_port, phylink_config);
> > +}
> > +
> >  static void mvpp2_phylink_validate(struct phylink_config *config,
> >                                    unsigned long *supported,
> >                                    struct phylink_link_state *state)
> >  {
> > -       struct mvpp2_port *port =3D container_of(config, struct mvpp2_p=
ort,
> > -                                              phylink_config);
> > +       struct mvpp2_port *port =3D mvpp2_phylink_to_port(config);
> >         __ETHTOOL_DECLARE_LINK_MODE_MASK(mask) =3D { 0, };
> >
> >         /* Invalid combinations */
> > @@ -4913,8 +4917,7 @@ static void mvpp2_gmac_pcs_get_state(struct mvpp2=
_port *port,
> >  static void mvpp2_phylink_mac_pcs_get_state(struct phylink_config *con=
fig,
> >                                             struct phylink_link_state *=
state)
> >  {
> > -       struct mvpp2_port *port =3D container_of(config, struct mvpp2_p=
ort,
> > -                                              phylink_config);
> > +       struct mvpp2_port *port =3D mvpp2_phylink_to_port(config);
> >
> >         if (port->priv->hw_version =3D=3D MVPP22 && port->gop_id =3D=3D=
 0) {
> >                 u32 mode =3D readl(port->base + MVPP22_XLG_CTRL3_REG);
> > @@ -4931,8 +4934,7 @@ static void mvpp2_phylink_mac_pcs_get_state(struc=
t phylink_config *config,
> >
> >  static void mvpp2_mac_an_restart(struct phylink_config *config)
> >  {
> > -       struct mvpp2_port *port =3D container_of(config, struct mvpp2_p=
ort,
> > -                                              phylink_config);
> > +       struct mvpp2_port *port =3D mvpp2_phylink_to_port(config);
> >         u32 val =3D readl(port->base + MVPP2_GMAC_AUTONEG_CONFIG);
> >
> >         writel(val | MVPP2_GMAC_IN_BAND_RESTART_AN,
> > @@ -5105,13 +5107,12 @@ static void mvpp2_gmac_config(struct mvpp2_port=
 *port, unsigned int mode,
> >  static void mvpp2_mac_config(struct phylink_config *config, unsigned i=
nt mode,
> >                              const struct phylink_link_state *state)
> >  {
> > -       struct net_device *dev =3D to_net_dev(config->dev);
> > -       struct mvpp2_port *port =3D netdev_priv(dev);
> > +       struct mvpp2_port *port =3D mvpp2_phylink_to_port(config);
> >         bool change_interface =3D port->phy_interface !=3D state->inter=
face;
> >
> >         /* Check for invalid configuration */
> >         if (mvpp2_is_xlg(state->interface) && port->gop_id !=3D 0) {
> > -               netdev_err(dev, "Invalid mode on %s\n", dev->name);
> > +               netdev_err(port->dev, "Invalid mode on %s\n", port->dev=
->name);
> >                 return;
> >         }
> >
> > @@ -5151,8 +5152,7 @@ static void mvpp2_mac_link_up(struct phylink_conf=
ig *config,
> >                               int speed, int duplex,
> >                               bool tx_pause, bool rx_pause)
> >  {
> > -       struct net_device *dev =3D to_net_dev(config->dev);
> > -       struct mvpp2_port *port =3D netdev_priv(dev);
> > +       struct mvpp2_port *port =3D mvpp2_phylink_to_port(config);
> >         u32 val;
> >
> >         if (mvpp2_is_xlg(interface)) {
> > @@ -5199,14 +5199,13 @@ static void mvpp2_mac_link_up(struct phylink_co=
nfig *config,
> >
> >         mvpp2_egress_enable(port);
> >         mvpp2_ingress_enable(port);
> > -       netif_tx_wake_all_queues(dev);
> > +       netif_tx_wake_all_queues(port->dev);
> >  }
> >
> >  static void mvpp2_mac_link_down(struct phylink_config *config,
> >                                 unsigned int mode, phy_interface_t inte=
rface)
> >  {
> > -       struct net_device *dev =3D to_net_dev(config->dev);
> > -       struct mvpp2_port *port =3D netdev_priv(dev);
> > +       struct mvpp2_port *port =3D mvpp2_phylink_to_port(config);
> >         u32 val;
> >
> >         if (!phylink_autoneg_inband(mode)) {
> > @@ -5223,7 +5222,7 @@ static void mvpp2_mac_link_down(struct phylink_co=
nfig *config,
> >                 }
> >         }
> >
> > -       netif_tx_stop_all_queues(dev);
> > +       netif_tx_stop_all_queues(port->dev);
> >         mvpp2_egress_disable(port);
> >         mvpp2_ingress_disable(port);
> >
> > --
> > 2.20.1
> >
>
> This patch fixes a regression that was introduced in v5.3:
> Commit 44cc27e43fa3 ("net: phylink: Add struct phylink_config to PHYLINK =
API")
>
> Above results in a NULL pointer dereference when booting the
> Armada7k8k/CN913x with ACPI between 5.3 and 5.8, which will be
> problematic especially for the distros using LTSv5.4 and above (the
> issue was reported on Fedora 32).
>
> Please help with backporting to the stable v5.3+ branches (it applies
> smoothly on v5.4/v5.6/v5.8).
>

Any chances to backport this patch to relevant v5.3+ stable branches?

Best regards,
Marcin
