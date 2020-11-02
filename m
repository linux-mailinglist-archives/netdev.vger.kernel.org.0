Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DAF12A36E3
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 00:02:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725921AbgKBXCU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 18:02:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725829AbgKBXCU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 18:02:20 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EAEDC0617A6;
        Mon,  2 Nov 2020 15:02:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=nHw9E+SMjN1sJhbbhpds3rD7YZc0/4l28nHNGj6UXLE=; b=ccPUVU4psoDYSLUoK48h6aUBu
        sBDa+NYAvYR3q/7Dk8reRPbcHCUJ3afwrBOSwd/vhbg6HuGb6Uh83p2wFxv76QtfYwUGrT3a1wS/6
        vcYYmzZVrULHolgq0ON9FNl1HLgLnLkxcSaHPFvAR769j5VGj3P+/uyI5a+kHKa2lb0RSV8gUiVwH
        ftkyRKoe6jnChL5hfpS3Q74znV+WhmNHpsCGlk4sEWwkU61DfIMkbrYo0OB5tmqo0cZXmwJ5AD5ih
        iVJHOcJ6AdwTF86so2OM69m1kb25lWt9Sp9axUTFYMrgHLsI5Qsavk46A+B0KJCYVkmd8bJd0Jn/9
        hN/MisQ6A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:54306)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kZiq5-00015y-4p; Mon, 02 Nov 2020 23:02:13 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kZiq1-000299-Cm; Mon, 02 Nov 2020 23:02:09 +0000
Date:   Mon, 2 Nov 2020 23:02:09 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>, sashal@kernel.org,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        stable@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Gabor Samu <samu_gabor@yahoo.ca>,
        Jon Nettleton <jon@solid-run.com>,
        Andrew Elwell <andrew.elwell@gmail.com>
Subject: Re: [PATCH net-next 2/4] net: mvpp2: add mvpp2_phylink_to_port()
 helper
Message-ID: <20201102230209.GM1551@shell.armlinux.org.uk>
References: <20200620092047.GR1551@shell.armlinux.org.uk>
 <E1jmZgq-0001UG-1c@rmk-PC.armlinux.org.uk>
 <CAPv3WKdJKAEwCoj5z6NzP2xRFfT1HG+2o0wigt=Czi4bG7EQcg@mail.gmail.com>
 <CAPv3WKfEN22cKbM8=+qDANefQE67KQ1zwURrCqAsrbo1+gBCDA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPv3WKfEN22cKbM8=+qDANefQE67KQ1zwURrCqAsrbo1+gBCDA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 02, 2020 at 06:38:54PM +0100, Marcin Wojtas wrote:
> Hi Greg and Sasha,
> 
> pt., 9 paź 2020 o 05:43 Marcin Wojtas <mw@semihalf.com> napisał(a):
> >
> > Hi,
> >
> > sob., 20 cze 2020 o 11:21 Russell King <rmk+kernel@armlinux.org.uk> napisał(a):
> > >
> > > Add a helper to convert the struct phylink_config pointer passed in
> > > from phylink to the drivers internal struct mvpp2_port.
> > >
> > > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> > > ---
> > >  .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 29 +++++++++----------
> > >  1 file changed, 14 insertions(+), 15 deletions(-)
> > >
> > > diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > > index 7653277d03b7..313f5a60a605 100644
> > > --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > > +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > > @@ -4767,12 +4767,16 @@ static void mvpp2_port_copy_mac_addr(struct net_device *dev, struct mvpp2 *priv,
> > >         eth_hw_addr_random(dev);
> > >  }
> > >
> > > +static struct mvpp2_port *mvpp2_phylink_to_port(struct phylink_config *config)
> > > +{
> > > +       return container_of(config, struct mvpp2_port, phylink_config);
> > > +}
> > > +
> > >  static void mvpp2_phylink_validate(struct phylink_config *config,
> > >                                    unsigned long *supported,
> > >                                    struct phylink_link_state *state)
> > >  {
> > > -       struct mvpp2_port *port = container_of(config, struct mvpp2_port,
> > > -                                              phylink_config);
> > > +       struct mvpp2_port *port = mvpp2_phylink_to_port(config);
> > >         __ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
> > >
> > >         /* Invalid combinations */
> > > @@ -4913,8 +4917,7 @@ static void mvpp2_gmac_pcs_get_state(struct mvpp2_port *port,
> > >  static void mvpp2_phylink_mac_pcs_get_state(struct phylink_config *config,
> > >                                             struct phylink_link_state *state)
> > >  {
> > > -       struct mvpp2_port *port = container_of(config, struct mvpp2_port,
> > > -                                              phylink_config);
> > > +       struct mvpp2_port *port = mvpp2_phylink_to_port(config);
> > >
> > >         if (port->priv->hw_version == MVPP22 && port->gop_id == 0) {
> > >                 u32 mode = readl(port->base + MVPP22_XLG_CTRL3_REG);
> > > @@ -4931,8 +4934,7 @@ static void mvpp2_phylink_mac_pcs_get_state(struct phylink_config *config,
> > >
> > >  static void mvpp2_mac_an_restart(struct phylink_config *config)
> > >  {
> > > -       struct mvpp2_port *port = container_of(config, struct mvpp2_port,
> > > -                                              phylink_config);
> > > +       struct mvpp2_port *port = mvpp2_phylink_to_port(config);
> > >         u32 val = readl(port->base + MVPP2_GMAC_AUTONEG_CONFIG);
> > >
> > >         writel(val | MVPP2_GMAC_IN_BAND_RESTART_AN,
> > > @@ -5105,13 +5107,12 @@ static void mvpp2_gmac_config(struct mvpp2_port *port, unsigned int mode,
> > >  static void mvpp2_mac_config(struct phylink_config *config, unsigned int mode,
> > >                              const struct phylink_link_state *state)
> > >  {
> > > -       struct net_device *dev = to_net_dev(config->dev);
> > > -       struct mvpp2_port *port = netdev_priv(dev);
> > > +       struct mvpp2_port *port = mvpp2_phylink_to_port(config);
> > >         bool change_interface = port->phy_interface != state->interface;
> > >
> > >         /* Check for invalid configuration */
> > >         if (mvpp2_is_xlg(state->interface) && port->gop_id != 0) {
> > > -               netdev_err(dev, "Invalid mode on %s\n", dev->name);
> > > +               netdev_err(port->dev, "Invalid mode on %s\n", port->dev->name);
> > >                 return;
> > >         }
> > >
> > > @@ -5151,8 +5152,7 @@ static void mvpp2_mac_link_up(struct phylink_config *config,
> > >                               int speed, int duplex,
> > >                               bool tx_pause, bool rx_pause)
> > >  {
> > > -       struct net_device *dev = to_net_dev(config->dev);
> > > -       struct mvpp2_port *port = netdev_priv(dev);
> > > +       struct mvpp2_port *port = mvpp2_phylink_to_port(config);
> > >         u32 val;
> > >
> > >         if (mvpp2_is_xlg(interface)) {
> > > @@ -5199,14 +5199,13 @@ static void mvpp2_mac_link_up(struct phylink_config *config,
> > >
> > >         mvpp2_egress_enable(port);
> > >         mvpp2_ingress_enable(port);
> > > -       netif_tx_wake_all_queues(dev);
> > > +       netif_tx_wake_all_queues(port->dev);
> > >  }
> > >
> > >  static void mvpp2_mac_link_down(struct phylink_config *config,
> > >                                 unsigned int mode, phy_interface_t interface)
> > >  {
> > > -       struct net_device *dev = to_net_dev(config->dev);
> > > -       struct mvpp2_port *port = netdev_priv(dev);
> > > +       struct mvpp2_port *port = mvpp2_phylink_to_port(config);
> > >         u32 val;
> > >
> > >         if (!phylink_autoneg_inband(mode)) {
> > > @@ -5223,7 +5222,7 @@ static void mvpp2_mac_link_down(struct phylink_config *config,
> > >                 }
> > >         }
> > >
> > > -       netif_tx_stop_all_queues(dev);
> > > +       netif_tx_stop_all_queues(port->dev);
> > >         mvpp2_egress_disable(port);
> > >         mvpp2_ingress_disable(port);
> > >
> > > --
> > > 2.20.1
> > >
> >
> > This patch fixes a regression that was introduced in v5.3:
> > Commit 44cc27e43fa3 ("net: phylink: Add struct phylink_config to PHYLINK API")
> >
> > Above results in a NULL pointer dereference when booting the
> > Armada7k8k/CN913x with ACPI between 5.3 and 5.8, which will be
> > problematic especially for the distros using LTSv5.4 and above (the
> > issue was reported on Fedora 32).
> >
> > Please help with backporting to the stable v5.3+ branches (it applies
> > smoothly on v5.4/v5.6/v5.8).
> 
> Any chances to backport this patch to relevant v5.3+ stable branches?

Who are you asking to do the backport? I guess you're asking me to
backport it, but I don't generally follow the stable kernels, and
I don't use ACPI on ARM systems, so I wouldn't be in a position to
test that a backported version fixes the problem you are reporting.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
