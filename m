Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D9222D2A3F
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 13:05:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727074AbgLHMEh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 07:04:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725807AbgLHMEg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 07:04:36 -0500
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93789C061749
        for <netdev@vger.kernel.org>; Tue,  8 Dec 2020 04:03:50 -0800 (PST)
Received: by mail-qv1-xf44.google.com with SMTP id dm12so8084917qvb.3
        for <netdev@vger.kernel.org>; Tue, 08 Dec 2020 04:03:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=JqVHWWBDBBxSvRaR1tW5Rn/C8vUBOLXV4bKVY5ZsIoA=;
        b=kvhnBbBZb3Y0U2wQE3kNtKJctU+YCW/rWo1EzUXhV6q1MZteONIIHzNmM9NMxMkS/G
         zDAEyM7akBtoEpQ7hAA2adDqTGBjPrWTh8JfiuJPe2p31RIbFQiLfZPieyE21HZ5N6Z4
         fq1LbwZmUHlH6RgIS9Fy0AwrIo3G2TpDV7QwAMo6KgeOo/wbATlHPI8cjWORSLdpIpJp
         fOPlP9Z8++ZIXkk6yvtyrg+2I1WiclfT1fSJ+OzwrL8Xh85IlgaqI/kxeiXl3z08Xg+j
         TTv1seJpeIdTqkbKVRXUURMB3O+kB6+v/LDEzR7IJ+Jg7vFF2rPnEp7EODc67AczTeIR
         wruQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=JqVHWWBDBBxSvRaR1tW5Rn/C8vUBOLXV4bKVY5ZsIoA=;
        b=p6GP/m5B6rQ8CrmL6+dj3lN9XevKkUwlK+5LNivsO8qaVT3X0Zju4Xl093kZ2A5b1F
         x1cFCFSO38QfHe3Ga1DnWIYDr9zUA4DZSafEqWgdr8KioUfrxZknIA8hkjhMZVOxIMkS
         BqMthOlkirrmlH3u84xCAUiHyV0953r9vGRilEc4G6cUiVm+blcqL8BLKp+c6sa3LSj8
         /zpdb+QhODquuHJprM8/a9Z8iixxB8fEcaJEbHB+U3nDtdc9L2Mf+NXu0vsaX44hhM8b
         1NwZZ4Qu8iYhow+QNbxJ67dg6VMdr43Xo/NnBwPvseSeHYAhEqLqIB3kAIo7TjnQhFQC
         5akg==
X-Gm-Message-State: AOAM530Fk4AX/lMzdzpCk++t+eX/mwMno13AlIGThmFEANTEFsqXmame
        UKTbpGPplTQI6OYCXg0cAdEDRj1AUnf6u/T1aZdmbA==
X-Google-Smtp-Source: ABdhPJznqjtNgbjty8elOv0hKSAm1DYaYORoqAeEGsnCPEebvyDqI2sOZpKBkfrxM35kQMSYFFdl4skjEq1h7xa0Gxw=
X-Received: by 2002:a0c:b3d6:: with SMTP id b22mr26526561qvf.10.1607429029687;
 Tue, 08 Dec 2020 04:03:49 -0800 (PST)
MIME-Version: 1.0
References: <20200620092047.GR1551@shell.armlinux.org.uk> <E1jmZgq-0001UG-1c@rmk-PC.armlinux.org.uk>
 <CAPv3WKdJKAEwCoj5z6NzP2xRFfT1HG+2o0wigt=Czi4bG7EQcg@mail.gmail.com>
 <CAPv3WKfEN22cKbM8=+qDANefQE67KQ1zwURrCqAsrbo1+gBCDA@mail.gmail.com> <20201102180326.GA2416734@kroah.com>
In-Reply-To: <20201102180326.GA2416734@kroah.com>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Tue, 8 Dec 2020 13:03:38 +0100
Message-ID: <CAPv3WKf0fNOOovq9UzoxoAXwGLMe_MHdfCZ6U9sjgKxarUKA+Q@mail.gmail.com>
Subject: Re: [PATCH net-next 2/4] net: mvpp2: add mvpp2_phylink_to_port() helper
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     sashal@kernel.org, Antoine Tenart <antoine.tenart@bootlin.com>,
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

Hi Greg,

Apologies for delayed response:.


pon., 2 lis 2020 o 19:02 Greg Kroah-Hartman
<gregkh@linuxfoundation.org> napisa=C5=82(a):
>
> On Mon, Nov 02, 2020 at 06:38:54PM +0100, Marcin Wojtas wrote:
> > Hi Greg and Sasha,
> >
> > pt., 9 pa=C5=BA 2020 o 05:43 Marcin Wojtas <mw@semihalf.com> napisa=C5=
=82(a):
> > >
> > > Hi,
> > >
> > > sob., 20 cze 2020 o 11:21 Russell King <rmk+kernel@armlinux.org.uk> n=
apisa=C5=82(a):
> > > >
> > > > Add a helper to convert the struct phylink_config pointer passed in
> > > > from phylink to the drivers internal struct mvpp2_port.
> > > >
> > > > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> > > > ---
> > > >  .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 29 +++++++++------=
----
> > > >  1 file changed, 14 insertions(+), 15 deletions(-)
> > > >
> > > > diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/driv=
ers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > > > index 7653277d03b7..313f5a60a605 100644
> > > > --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > > > +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > > > @@ -4767,12 +4767,16 @@ static void mvpp2_port_copy_mac_addr(struct=
 net_device *dev, struct mvpp2 *priv,
> > > >         eth_hw_addr_random(dev);
> > > >  }
> > > >
> > > > +static struct mvpp2_port *mvpp2_phylink_to_port(struct phylink_con=
fig *config)
> > > > +{
> > > > +       return container_of(config, struct mvpp2_port, phylink_conf=
ig);
> > > > +}
> > > > +
> > > >  static void mvpp2_phylink_validate(struct phylink_config *config,
> > > >                                    unsigned long *supported,
> > > >                                    struct phylink_link_state *state=
)
> > > >  {
> > > > -       struct mvpp2_port *port =3D container_of(config, struct mvp=
p2_port,
> > > > -                                              phylink_config);
> > > > +       struct mvpp2_port *port =3D mvpp2_phylink_to_port(config);
> > > >         __ETHTOOL_DECLARE_LINK_MODE_MASK(mask) =3D { 0, };
> > > >
> > > >         /* Invalid combinations */
> > > > @@ -4913,8 +4917,7 @@ static void mvpp2_gmac_pcs_get_state(struct m=
vpp2_port *port,
> > > >  static void mvpp2_phylink_mac_pcs_get_state(struct phylink_config =
*config,
> > > >                                             struct phylink_link_sta=
te *state)
> > > >  {
> > > > -       struct mvpp2_port *port =3D container_of(config, struct mvp=
p2_port,
> > > > -                                              phylink_config);
> > > > +       struct mvpp2_port *port =3D mvpp2_phylink_to_port(config);
> > > >
> > > >         if (port->priv->hw_version =3D=3D MVPP22 && port->gop_id =
=3D=3D 0) {
> > > >                 u32 mode =3D readl(port->base + MVPP22_XLG_CTRL3_RE=
G);
> > > > @@ -4931,8 +4934,7 @@ static void mvpp2_phylink_mac_pcs_get_state(s=
truct phylink_config *config,
> > > >
> > > >  static void mvpp2_mac_an_restart(struct phylink_config *config)
> > > >  {
> > > > -       struct mvpp2_port *port =3D container_of(config, struct mvp=
p2_port,
> > > > -                                              phylink_config);
> > > > +       struct mvpp2_port *port =3D mvpp2_phylink_to_port(config);
> > > >         u32 val =3D readl(port->base + MVPP2_GMAC_AUTONEG_CONFIG);
> > > >
> > > >         writel(val | MVPP2_GMAC_IN_BAND_RESTART_AN,
> > > > @@ -5105,13 +5107,12 @@ static void mvpp2_gmac_config(struct mvpp2_=
port *port, unsigned int mode,
> > > >  static void mvpp2_mac_config(struct phylink_config *config, unsign=
ed int mode,
> > > >                              const struct phylink_link_state *state=
)
> > > >  {
> > > > -       struct net_device *dev =3D to_net_dev(config->dev);
> > > > -       struct mvpp2_port *port =3D netdev_priv(dev);
> > > > +       struct mvpp2_port *port =3D mvpp2_phylink_to_port(config);
> > > >         bool change_interface =3D port->phy_interface !=3D state->i=
nterface;
> > > >
> > > >         /* Check for invalid configuration */
> > > >         if (mvpp2_is_xlg(state->interface) && port->gop_id !=3D 0) =
{
> > > > -               netdev_err(dev, "Invalid mode on %s\n", dev->name);
> > > > +               netdev_err(port->dev, "Invalid mode on %s\n", port-=
>dev->name);
> > > >                 return;
> > > >         }
> > > >
> > > > @@ -5151,8 +5152,7 @@ static void mvpp2_mac_link_up(struct phylink_=
config *config,
> > > >                               int speed, int duplex,
> > > >                               bool tx_pause, bool rx_pause)
> > > >  {
> > > > -       struct net_device *dev =3D to_net_dev(config->dev);
> > > > -       struct mvpp2_port *port =3D netdev_priv(dev);
> > > > +       struct mvpp2_port *port =3D mvpp2_phylink_to_port(config);
> > > >         u32 val;
> > > >
> > > >         if (mvpp2_is_xlg(interface)) {
> > > > @@ -5199,14 +5199,13 @@ static void mvpp2_mac_link_up(struct phylin=
k_config *config,
> > > >
> > > >         mvpp2_egress_enable(port);
> > > >         mvpp2_ingress_enable(port);
> > > > -       netif_tx_wake_all_queues(dev);
> > > > +       netif_tx_wake_all_queues(port->dev);
> > > >  }
> > > >
> > > >  static void mvpp2_mac_link_down(struct phylink_config *config,
> > > >                                 unsigned int mode, phy_interface_t =
interface)
> > > >  {
> > > > -       struct net_device *dev =3D to_net_dev(config->dev);
> > > > -       struct mvpp2_port *port =3D netdev_priv(dev);
> > > > +       struct mvpp2_port *port =3D mvpp2_phylink_to_port(config);
> > > >         u32 val;
> > > >
> > > >         if (!phylink_autoneg_inband(mode)) {
> > > > @@ -5223,7 +5222,7 @@ static void mvpp2_mac_link_down(struct phylin=
k_config *config,
> > > >                 }
> > > >         }
> > > >
> > > > -       netif_tx_stop_all_queues(dev);
> > > > +       netif_tx_stop_all_queues(port->dev);
> > > >         mvpp2_egress_disable(port);
> > > >         mvpp2_ingress_disable(port);
> > > >
> > > > --
> > > > 2.20.1
> > > >
> > >
> > > This patch fixes a regression that was introduced in v5.3:
> > > Commit 44cc27e43fa3 ("net: phylink: Add struct phylink_config to PHYL=
INK API")
> > >
> > > Above results in a NULL pointer dereference when booting the
> > > Armada7k8k/CN913x with ACPI between 5.3 and 5.8, which will be
> > > problematic especially for the distros using LTSv5.4 and above (the
> > > issue was reported on Fedora 32).
> > >
> > > Please help with backporting to the stable v5.3+ branches (it applies
> > > smoothly on v5.4/v5.6/v5.8).
> > >
> >
> > Any chances to backport this patch to relevant v5.3+ stable branches?
>
> What patch?  What git commit id needs to be backported?
>

The actual patch is:
Commit 6c2b49eb9671  ("net: mvpp2: add mvpp2_phylink_to_port() helper").

URL for reference:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/d=
rivers/net/ethernet/marvell/mvpp2?h=3Dv5.10-rc7&id=3D6c2b49eb96716e91f20275=
6bfbd3f5fea3b2b172

Do you think it would be possible to get it merged to v5.3+ stable branches=
?

Best regards,
Marcin
