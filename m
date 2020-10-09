Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B09BA2880C6
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 05:44:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731527AbgJIDoO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 23:44:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731508AbgJIDoO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 23:44:14 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84F82C0613D2
        for <netdev@vger.kernel.org>; Thu,  8 Oct 2020 20:44:12 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id d20so9314487qka.5
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 20:44:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=rnokm4ExtvEJSv/7qKTingivUqdsSMzAazkHgkumQMc=;
        b=ljMPhrv3y+oIQ1RtFF0ZxpSVyT1Zx8hvyR5Nl6nxJaU1k/mQLi9pc4+PAtvmxDnKf6
         NeWJKAxXIRK1EeT7Tr/zIADJp/FtaUKIXiqd2U8JJUJTEBdvrPP1ZaENZquC8jf7C4jE
         28KED4bkaAe/gs0ymJkug2a5Nzd3A1NRtsTInu1pmTzReXvejhpWX1loCqf5CiiHZsyV
         jSEA3+0YoQgm075RU5pSTkEaGMNscuLju9BsA+2e3181UodGgwM1J/vxpuq2ESVs/Pnc
         Rmvi/3fogD0s1VCycFHCYmdBtqyAOmHQuD1mmc6najlu/99ODWg1MembXdptktKPcUop
         uOQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=rnokm4ExtvEJSv/7qKTingivUqdsSMzAazkHgkumQMc=;
        b=XPN623AGUn+oRQnrqUWT+p/Hyy7+wgqx78bCk24QuGlCHWYF3BBq3DE7lMUsqf1uCF
         1qNQ9v6XmOUCM+ep25RcjLJ+TTcvdTBGfXbo3QwokJpRlbt0AyOfrjwxvMZtPntzxpyU
         8lTuw+I6ELx5Gp7g9FYIWhjWtpg7XAaRRCcqqhE8K40zGOnwc1bqlTQheXm3A+7YMnxt
         fMTSKbd2n8OCJJgwzAmkVFrJtn5fSciRQFAUmpfP5VHhE7tAhiv8+vsK0pq0pZAxuqza
         PdjoB/29nz40cgtbeUKJ7JFoBXE+ykGkl+UIQ1+QS5h33vPLkZRuEG7hBiMsWWDsM71D
         NU1g==
X-Gm-Message-State: AOAM5314NjIUidfmW8+V1ul8GR5N5XqbuhICuUC1GWVCDwNMFTbK23iF
        F0zM3+iUdw5fgdrlIZxS5vBDe6JPI0hgHt8F4aoKaw==
X-Google-Smtp-Source: ABdhPJy6TCb6LYYLP++Y76eo24OCtuB5SwX3BVaYoYBNLCu3yPX9fDB6lOFD2wX/DXtr2Lbix3NpYgGbixaIRGG/oW4=
X-Received: by 2002:a37:7843:: with SMTP id t64mr11523831qkc.140.1602215051444;
 Thu, 08 Oct 2020 20:44:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200620092047.GR1551@shell.armlinux.org.uk> <E1jmZgq-0001UG-1c@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1jmZgq-0001UG-1c@rmk-PC.armlinux.org.uk>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Fri, 9 Oct 2020 05:43:56 +0200
Message-ID: <CAPv3WKdJKAEwCoj5z6NzP2xRFfT1HG+2o0wigt=Czi4bG7EQcg@mail.gmail.com>
Subject: Re: [PATCH net-next 2/4] net: mvpp2: add mvpp2_phylink_to_port() helper
To:     stable@vger.kernel.org
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
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

Hi,

sob., 20 cze 2020 o 11:21 Russell King <rmk+kernel@armlinux.org.uk> napisa=
=C5=82(a):
>
> Add a helper to convert the struct phylink_config pointer passed in
> from phylink to the drivers internal struct mvpp2_port.
>
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> ---
>  .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 29 +++++++++----------
>  1 file changed, 14 insertions(+), 15 deletions(-)
>
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/ne=
t/ethernet/marvell/mvpp2/mvpp2_main.c
> index 7653277d03b7..313f5a60a605 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> @@ -4767,12 +4767,16 @@ static void mvpp2_port_copy_mac_addr(struct net_d=
evice *dev, struct mvpp2 *priv,
>         eth_hw_addr_random(dev);
>  }
>
> +static struct mvpp2_port *mvpp2_phylink_to_port(struct phylink_config *c=
onfig)
> +{
> +       return container_of(config, struct mvpp2_port, phylink_config);
> +}
> +
>  static void mvpp2_phylink_validate(struct phylink_config *config,
>                                    unsigned long *supported,
>                                    struct phylink_link_state *state)
>  {
> -       struct mvpp2_port *port =3D container_of(config, struct mvpp2_por=
t,
> -                                              phylink_config);
> +       struct mvpp2_port *port =3D mvpp2_phylink_to_port(config);
>         __ETHTOOL_DECLARE_LINK_MODE_MASK(mask) =3D { 0, };
>
>         /* Invalid combinations */
> @@ -4913,8 +4917,7 @@ static void mvpp2_gmac_pcs_get_state(struct mvpp2_p=
ort *port,
>  static void mvpp2_phylink_mac_pcs_get_state(struct phylink_config *confi=
g,
>                                             struct phylink_link_state *st=
ate)
>  {
> -       struct mvpp2_port *port =3D container_of(config, struct mvpp2_por=
t,
> -                                              phylink_config);
> +       struct mvpp2_port *port =3D mvpp2_phylink_to_port(config);
>
>         if (port->priv->hw_version =3D=3D MVPP22 && port->gop_id =3D=3D 0=
) {
>                 u32 mode =3D readl(port->base + MVPP22_XLG_CTRL3_REG);
> @@ -4931,8 +4934,7 @@ static void mvpp2_phylink_mac_pcs_get_state(struct =
phylink_config *config,
>
>  static void mvpp2_mac_an_restart(struct phylink_config *config)
>  {
> -       struct mvpp2_port *port =3D container_of(config, struct mvpp2_por=
t,
> -                                              phylink_config);
> +       struct mvpp2_port *port =3D mvpp2_phylink_to_port(config);
>         u32 val =3D readl(port->base + MVPP2_GMAC_AUTONEG_CONFIG);
>
>         writel(val | MVPP2_GMAC_IN_BAND_RESTART_AN,
> @@ -5105,13 +5107,12 @@ static void mvpp2_gmac_config(struct mvpp2_port *=
port, unsigned int mode,
>  static void mvpp2_mac_config(struct phylink_config *config, unsigned int=
 mode,
>                              const struct phylink_link_state *state)
>  {
> -       struct net_device *dev =3D to_net_dev(config->dev);
> -       struct mvpp2_port *port =3D netdev_priv(dev);
> +       struct mvpp2_port *port =3D mvpp2_phylink_to_port(config);
>         bool change_interface =3D port->phy_interface !=3D state->interfa=
ce;
>
>         /* Check for invalid configuration */
>         if (mvpp2_is_xlg(state->interface) && port->gop_id !=3D 0) {
> -               netdev_err(dev, "Invalid mode on %s\n", dev->name);
> +               netdev_err(port->dev, "Invalid mode on %s\n", port->dev->=
name);
>                 return;
>         }
>
> @@ -5151,8 +5152,7 @@ static void mvpp2_mac_link_up(struct phylink_config=
 *config,
>                               int speed, int duplex,
>                               bool tx_pause, bool rx_pause)
>  {
> -       struct net_device *dev =3D to_net_dev(config->dev);
> -       struct mvpp2_port *port =3D netdev_priv(dev);
> +       struct mvpp2_port *port =3D mvpp2_phylink_to_port(config);
>         u32 val;
>
>         if (mvpp2_is_xlg(interface)) {
> @@ -5199,14 +5199,13 @@ static void mvpp2_mac_link_up(struct phylink_conf=
ig *config,
>
>         mvpp2_egress_enable(port);
>         mvpp2_ingress_enable(port);
> -       netif_tx_wake_all_queues(dev);
> +       netif_tx_wake_all_queues(port->dev);
>  }
>
>  static void mvpp2_mac_link_down(struct phylink_config *config,
>                                 unsigned int mode, phy_interface_t interf=
ace)
>  {
> -       struct net_device *dev =3D to_net_dev(config->dev);
> -       struct mvpp2_port *port =3D netdev_priv(dev);
> +       struct mvpp2_port *port =3D mvpp2_phylink_to_port(config);
>         u32 val;
>
>         if (!phylink_autoneg_inband(mode)) {
> @@ -5223,7 +5222,7 @@ static void mvpp2_mac_link_down(struct phylink_conf=
ig *config,
>                 }
>         }
>
> -       netif_tx_stop_all_queues(dev);
> +       netif_tx_stop_all_queues(port->dev);
>         mvpp2_egress_disable(port);
>         mvpp2_ingress_disable(port);
>
> --
> 2.20.1
>

This patch fixes a regression that was introduced in v5.3:
Commit 44cc27e43fa3 ("net: phylink: Add struct phylink_config to PHYLINK AP=
I")

Above results in a NULL pointer dereference when booting the
Armada7k8k/CN913x with ACPI between 5.3 and 5.8, which will be
problematic especially for the distros using LTSv5.4 and above (the
issue was reported on Fedora 32).

Please help with backporting to the stable v5.3+ branches (it applies
smoothly on v5.4/v5.6/v5.8).

Best regards,
Marcin
