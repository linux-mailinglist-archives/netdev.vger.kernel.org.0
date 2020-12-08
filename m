Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33B332D2DCA
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 16:04:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730036AbgLHPDt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 10:03:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730026AbgLHPDt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 10:03:49 -0500
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E86FC061749
        for <netdev@vger.kernel.org>; Tue,  8 Dec 2020 07:03:03 -0800 (PST)
Received: by mail-qk1-x744.google.com with SMTP id q22so16157100qkq.6
        for <netdev@vger.kernel.org>; Tue, 08 Dec 2020 07:03:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ZDx1D4ZYt3aRmfkKZb5yXSPAvlecUk2WejY0mQiJleM=;
        b=oAXTbHwbQ9hPhbuUawZVZ2mbKUdQEaYQLnGgiG3tNxuM/+plAaAI28/u7dBC/JP/1S
         z9aqXj9HS25NTVr1CmDkZAl5Xin9RNqrNTTPetgiI8AsPJK9Y/73oz9g8mi13gTSa4qC
         8kwU9L5ttM1B04+DUMAHVOZF3CtXNCkFRjZK8YfzRJJUYro3qWDg/CcgQUJ5RmpDZlKk
         dAvKIqI6QMsUdfun6cDM+dHmUOpXD0hctejd6WNb0dpZMWCcU3X4aGAh+GHyU+FpihP6
         Fwf/ET+bQEs1JPHqnZNXA8UE6xwwXLvx8isBKc2UkkqHpJP1Qd3GBbhWYscLTt9ZD1pG
         6vTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ZDx1D4ZYt3aRmfkKZb5yXSPAvlecUk2WejY0mQiJleM=;
        b=qRNhW7GK6yrXN+6z0zoDEnJep5+gyVAtXc9MiLRDwunReNuskx1R19u22mpxQN2sVe
         dOYoaUD5CoApTkB/kh7qP9liauxZCfJgvhQtnWDEw1HB30bB/QtADY5VSSIrO74FQK3K
         LZt0D4F1o5FN5J1dOF946oeFoHJYZgjfoilCCwgqvIpruAwgcAk4nZ3pSMpsRm8prmJn
         JMPpwSbsLGjgY03YXKlkVI5CHmxkjo67Xh0/3aT3KaIpxqwtmK8bmdrcmJfQh+lGB5bX
         /NkbHndmcj4G1hnh1K/3WJRJzcVPFIUyQaa8qWHJ78agu2POfvCbjyR18qNS5k1EL5XC
         ezhQ==
X-Gm-Message-State: AOAM532/8aHYrah5WOsM69PE4lOxYutJu8BtU4Nnd+IY+r7uFe0qpcio
        NKiu17oDMQ6gvEHxmOpcLkxI9dfJHqQwi/nMTeObjA==
X-Google-Smtp-Source: ABdhPJwweU646dAkCNpJCmUkSiZTFu/WrPQ1LhYyhJW3Drc4sGvlnbsCYyRCWtbn1uvBYHVe5tnEidX8EONPdApV9oU=
X-Received: by 2002:a37:4acb:: with SMTP id x194mr29969447qka.295.1607439782524;
 Tue, 08 Dec 2020 07:03:02 -0800 (PST)
MIME-Version: 1.0
References: <20200620092047.GR1551@shell.armlinux.org.uk> <E1jmZgq-0001UG-1c@rmk-PC.armlinux.org.uk>
 <CAPv3WKdJKAEwCoj5z6NzP2xRFfT1HG+2o0wigt=Czi4bG7EQcg@mail.gmail.com>
 <CAPv3WKfEN22cKbM8=+qDANefQE67KQ1zwURrCqAsrbo1+gBCDA@mail.gmail.com>
 <20201102180326.GA2416734@kroah.com> <CAPv3WKf0fNOOovq9UzoxoAXwGLMe_MHdfCZ6U9sjgKxarUKA+Q@mail.gmail.com>
 <20201208133532.GH643756@sasha-vm>
In-Reply-To: <20201208133532.GH643756@sasha-vm>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Tue, 8 Dec 2020 16:02:50 +0100
Message-ID: <CAPv3WKed9zhe0q2noGKiKdzd=jBNLtN6vRW0fnQddJhhiD=rkg@mail.gmail.com>
Subject: Re: [PATCH net-next 2/4] net: mvpp2: add mvpp2_phylink_to_port() helper
To:     Sasha Levin <sashal@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
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

Hi Sasha,

wt., 8 gru 2020 o 14:35 Sasha Levin <sashal@kernel.org> napisa=C5=82(a):
>
> On Tue, Dec 08, 2020 at 01:03:38PM +0100, Marcin Wojtas wrote:
> >Hi Greg,
> >
> >Apologies for delayed response:.
> >
> >
> >pon., 2 lis 2020 o 19:02 Greg Kroah-Hartman
> ><gregkh@linuxfoundation.org> napisa=C5=82(a):
> >>
> >> On Mon, Nov 02, 2020 at 06:38:54PM +0100, Marcin Wojtas wrote:
> >> > Hi Greg and Sasha,
> >> >
> >> > pt., 9 pa=C5=BA 2020 o 05:43 Marcin Wojtas <mw@semihalf.com> napisa=
=C5=82(a):
> >> > >
> >> > > Hi,
> >> > >
> >> > > sob., 20 cze 2020 o 11:21 Russell King <rmk+kernel@armlinux.org.uk=
> napisa=C5=82(a):
> >> > > >
> >> > > > Add a helper to convert the struct phylink_config pointer passed=
 in
> >> > > > from phylink to the drivers internal struct mvpp2_port.
> >> > > >
> >> > > > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> >> > > > ---
> >> > > >  .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 29 +++++++++---=
-------
> >> > > >  1 file changed, 14 insertions(+), 15 deletions(-)
> >> > > >
> >> > > > diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/d=
rivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> >> > > > index 7653277d03b7..313f5a60a605 100644
> >> > > > --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> >> > > > +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> >> > > > @@ -4767,12 +4767,16 @@ static void mvpp2_port_copy_mac_addr(str=
uct net_device *dev, struct mvpp2 *priv,
> >> > > >         eth_hw_addr_random(dev);
> >> > > >  }
> >> > > >
> >> > > > +static struct mvpp2_port *mvpp2_phylink_to_port(struct phylink_=
config *config)
> >> > > > +{
> >> > > > +       return container_of(config, struct mvpp2_port, phylink_c=
onfig);
> >> > > > +}
> >> > > > +
> >> > > >  static void mvpp2_phylink_validate(struct phylink_config *confi=
g,
> >> > > >                                    unsigned long *supported,
> >> > > >                                    struct phylink_link_state *st=
ate)
> >> > > >  {
> >> > > > -       struct mvpp2_port *port =3D container_of(config, struct =
mvpp2_port,
> >> > > > -                                              phylink_config);
> >> > > > +       struct mvpp2_port *port =3D mvpp2_phylink_to_port(config=
);
> >> > > >         __ETHTOOL_DECLARE_LINK_MODE_MASK(mask) =3D { 0, };
> >> > > >
> >> > > >         /* Invalid combinations */
> >> > > > @@ -4913,8 +4917,7 @@ static void mvpp2_gmac_pcs_get_state(struc=
t mvpp2_port *port,
> >> > > >  static void mvpp2_phylink_mac_pcs_get_state(struct phylink_conf=
ig *config,
> >> > > >                                             struct phylink_link_=
state *state)
> >> > > >  {
> >> > > > -       struct mvpp2_port *port =3D container_of(config, struct =
mvpp2_port,
> >> > > > -                                              phylink_config);
> >> > > > +       struct mvpp2_port *port =3D mvpp2_phylink_to_port(config=
);
> >> > > >
> >> > > >         if (port->priv->hw_version =3D=3D MVPP22 && port->gop_id=
 =3D=3D 0) {
> >> > > >                 u32 mode =3D readl(port->base + MVPP22_XLG_CTRL3=
_REG);
> >> > > > @@ -4931,8 +4934,7 @@ static void mvpp2_phylink_mac_pcs_get_stat=
e(struct phylink_config *config,
> >> > > >
> >> > > >  static void mvpp2_mac_an_restart(struct phylink_config *config)
> >> > > >  {
> >> > > > -       struct mvpp2_port *port =3D container_of(config, struct =
mvpp2_port,
> >> > > > -                                              phylink_config);
> >> > > > +       struct mvpp2_port *port =3D mvpp2_phylink_to_port(config=
);
> >> > > >         u32 val =3D readl(port->base + MVPP2_GMAC_AUTONEG_CONFIG=
);
> >> > > >
> >> > > >         writel(val | MVPP2_GMAC_IN_BAND_RESTART_AN,
> >> > > > @@ -5105,13 +5107,12 @@ static void mvpp2_gmac_config(struct mvp=
p2_port *port, unsigned int mode,
> >> > > >  static void mvpp2_mac_config(struct phylink_config *config, uns=
igned int mode,
> >> > > >                              const struct phylink_link_state *st=
ate)
> >> > > >  {
> >> > > > -       struct net_device *dev =3D to_net_dev(config->dev);
> >> > > > -       struct mvpp2_port *port =3D netdev_priv(dev);
> >> > > > +       struct mvpp2_port *port =3D mvpp2_phylink_to_port(config=
);
> >> > > >         bool change_interface =3D port->phy_interface !=3D state=
->interface;
> >> > > >
> >> > > >         /* Check for invalid configuration */
> >> > > >         if (mvpp2_is_xlg(state->interface) && port->gop_id !=3D =
0) {
> >> > > > -               netdev_err(dev, "Invalid mode on %s\n", dev->nam=
e);
> >> > > > +               netdev_err(port->dev, "Invalid mode on %s\n", po=
rt->dev->name);
> >> > > >                 return;
> >> > > >         }
> >> > > >
> >> > > > @@ -5151,8 +5152,7 @@ static void mvpp2_mac_link_up(struct phyli=
nk_config *config,
> >> > > >                               int speed, int duplex,
> >> > > >                               bool tx_pause, bool rx_pause)
> >> > > >  {
> >> > > > -       struct net_device *dev =3D to_net_dev(config->dev);
> >> > > > -       struct mvpp2_port *port =3D netdev_priv(dev);
> >> > > > +       struct mvpp2_port *port =3D mvpp2_phylink_to_port(config=
);
> >> > > >         u32 val;
> >> > > >
> >> > > >         if (mvpp2_is_xlg(interface)) {
> >> > > > @@ -5199,14 +5199,13 @@ static void mvpp2_mac_link_up(struct phy=
link_config *config,
> >> > > >
> >> > > >         mvpp2_egress_enable(port);
> >> > > >         mvpp2_ingress_enable(port);
> >> > > > -       netif_tx_wake_all_queues(dev);
> >> > > > +       netif_tx_wake_all_queues(port->dev);
> >> > > >  }
> >> > > >
> >> > > >  static void mvpp2_mac_link_down(struct phylink_config *config,
> >> > > >                                 unsigned int mode, phy_interface=
_t interface)
> >> > > >  {
> >> > > > -       struct net_device *dev =3D to_net_dev(config->dev);
> >> > > > -       struct mvpp2_port *port =3D netdev_priv(dev);
> >> > > > +       struct mvpp2_port *port =3D mvpp2_phylink_to_port(config=
);
> >> > > >         u32 val;
> >> > > >
> >> > > >         if (!phylink_autoneg_inband(mode)) {
> >> > > > @@ -5223,7 +5222,7 @@ static void mvpp2_mac_link_down(struct phy=
link_config *config,
> >> > > >                 }
> >> > > >         }
> >> > > >
> >> > > > -       netif_tx_stop_all_queues(dev);
> >> > > > +       netif_tx_stop_all_queues(port->dev);
> >> > > >         mvpp2_egress_disable(port);
> >> > > >         mvpp2_ingress_disable(port);
> >> > > >
> >> > > > --
> >> > > > 2.20.1
> >> > > >
> >> > >
> >> > > This patch fixes a regression that was introduced in v5.3:
> >> > > Commit 44cc27e43fa3 ("net: phylink: Add struct phylink_config to P=
HYLINK API")
> >> > >
> >> > > Above results in a NULL pointer dereference when booting the
> >> > > Armada7k8k/CN913x with ACPI between 5.3 and 5.8, which will be
> >> > > problematic especially for the distros using LTSv5.4 and above (th=
e
> >> > > issue was reported on Fedora 32).
> >> > >
> >> > > Please help with backporting to the stable v5.3+ branches (it appl=
ies
> >> > > smoothly on v5.4/v5.6/v5.8).
> >> > >
> >> >
> >> > Any chances to backport this patch to relevant v5.3+ stable branches=
?
> >>
> >> What patch?  What git commit id needs to be backported?
> >>
> >
> >The actual patch is:
> >Commit 6c2b49eb9671  ("net: mvpp2: add mvpp2_phylink_to_port() helper").
> >
> >URL for reference:
> >https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commi=
t/drivers/net/ethernet/marvell/mvpp2?h=3Dv5.10-rc7&id=3D6c2b49eb96716e91f20=
2756bfbd3f5fea3b2b172
> >
> >Do you think it would be possible to get it merged to v5.3+ stable branc=
hes?
>
> Could you explain how that patch fixes anything? It reads like a
> cleanup.
>

Indeed, I am aware of it, but I'm not sure about the best way to fix
it. In fact the mentioned patch is an unintentional fix. Commit
44cc27e43fa3 ("net: phylink: Add struct phylink_config to PHYLINK
API") reworked an argument list of mvpp2_mac_config() routine in a way
that resulted in a NULL pointer dereference when booting the
Armada7k8k/CN913x with ACPI between 5.3 and 5.8. Part of Russell's
patch resolves this issue.

What is the best way to handle that?

Thanks,
Marcin
