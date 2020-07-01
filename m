Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 283972109A4
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 12:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729978AbgGAKrk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 06:47:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729791AbgGAKrk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 06:47:40 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA618C061755
        for <netdev@vger.kernel.org>; Wed,  1 Jul 2020 03:47:39 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id z17so19209134edr.9
        for <netdev@vger.kernel.org>; Wed, 01 Jul 2020 03:47:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vSklkYPAVI6KSNJ+MvH80HtarGkvnPtlhTFK8HmSrD4=;
        b=p3zvdKRMwSxhnFuOU4eFM8WaImx6d0F+UZdv1g+PnAvtj7Gcrxjy0J5BNtVlOHDhzd
         y2sVPq+7053iuTa/e7bkDvjMh4SyPekpE0lKoLup5GRUvXKrSVqpD5mJ1g2X+LNV3C3p
         G+GzNMGd+WxcEpl5EIaeCiFfVp+rSHv3/znr4ybmZLGRgOskoVwYNnQJd/SMrZNJT0JN
         T/wHKWWVdZ2AHkpSV4y6Sri9az82fnBsFrgENmETHkurasR1ZnneKIWMB07w5Qk/eSsL
         HWiTtJuISIIB8xzqh083Xsz7qw9ucsnXQp2SbV7PUY0mDed3Wh7foGnr0kj2E+Fa7mRh
         +aww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vSklkYPAVI6KSNJ+MvH80HtarGkvnPtlhTFK8HmSrD4=;
        b=VAEXQPAvw3DhyFy8WDMzISSaurguAuGVUvREhYti3W4VP2Y6v6x7qw5QFpQ72BC2OQ
         phOC49uYzyPGxSczScHp65uuKH5bsm04EIUDbMQKomDUR/aoxM2edQ6BhyzJhi2Q+kHW
         dtRjz/AGOb9+M+M7fUj1fEDIZywEsG1HT9ZfZN1J65ZaxY9sB5A0Ci+I+piDUip6YUk2
         cAPCfYiU/+nXvNnwbllsua5kq6zH40zR9/4fTL4iMbuSvJ7a532Kyhv7vZCC3aq0yuOi
         KlcoPl+h5pHIObBRavFf62joBN6Tvi4A6EZAXikn3v+KXc/mEo5extfmkyYMDCBNJBkZ
         OMVQ==
X-Gm-Message-State: AOAM533fcFdb7zNSYY1eLdTiV1UiytbVKGA/4JnTn2HEt4bmissuS5r7
        sbU/fFDoGZmt5apZdlP7rzNtQgZBuBN0mJk5f/E=
X-Google-Smtp-Source: ABdhPJzIf8GG0DSV4GP+kS41+DL81dTDf87/8XYgJMWjNw6UwUH8JUii+r5bYUC7mGRS2/jYJ/qhKwtzKNl4WtPl33M=
X-Received: by 2002:a05:6402:2d7:: with SMTP id b23mr15954988edx.145.1593600458472;
 Wed, 01 Jul 2020 03:47:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200630142754.GC1551@shell.armlinux.org.uk> <E1jqHGO-0006QN-Hw@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1jqHGO-0006QN-Hw@rmk-PC.armlinux.org.uk>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 1 Jul 2020 13:47:27 +0300
Message-ID: <CA+h21hokR=966wRCWctN+gNALjZmr3tXU1D4uHhoFDwos7vNdQ@mail.gmail.com>
Subject: Re: [PATCH RFC net-next 12/13] net: phylink: add struct phylink_pcs
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "michael@walle.cc" <michael@walle.cc>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

On Tue, 30 Jun 2020 at 17:29, Russell King <rmk+kernel@armlinux.org.uk> wrote:
>
> Add a way for MAC PCS to have private data while keeping independence
> from struct phylink_config, which is used for the MAC itself. We need
> this independence as we will have stand-alone code for PCS that is
> independent of the MAC.  Introduce struct phylink_pcs, which is
> designed to be embedded in a driver private data structure.
>
> This structure does not include a mdio_device as there are PCS
> implementations such as the Marvell DSA and network drivers where this
> is not necessary.
>
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> ---
>  drivers/net/phy/phylink.c | 25 ++++++++++++++++------
>  include/linux/phylink.h   | 45 ++++++++++++++++++++++++++-------------
>  2 files changed, 48 insertions(+), 22 deletions(-)
>
> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> index a31a00fb4974..fbc8591b474b 100644
> --- a/drivers/net/phy/phylink.c
> +++ b/drivers/net/phy/phylink.c
> @@ -43,6 +43,7 @@ struct phylink {
>         const struct phylink_mac_ops *mac_ops;
>         const struct phylink_pcs_ops *pcs_ops;
>         struct phylink_config *config;
> +       struct phylink_pcs *pcs;
>         struct device *dev;
>         unsigned int old_link_state:1;
>
> @@ -427,7 +428,7 @@ static void phylink_mac_pcs_an_restart(struct phylink *pl)
>             phy_interface_mode_is_8023z(pl->link_config.interface) &&
>             phylink_autoneg_inband(pl->cur_link_an_mode)) {
>                 if (pl->pcs_ops)
> -                       pl->pcs_ops->pcs_an_restart(pl->config);
> +                       pl->pcs_ops->pcs_an_restart(pl->pcs);
>                 else
>                         pl->mac_ops->mac_an_restart(pl->config);
>         }
> @@ -453,7 +454,7 @@ static void phylink_change_interface(struct phylink *pl, bool restart,
>         phylink_mac_config(pl, state);
>
>         if (pl->pcs_ops) {
> -               err = pl->pcs_ops->pcs_config(pl->config, pl->cur_link_an_mode,
> +               err = pl->pcs_ops->pcs_config(pl->pcs, pl->cur_link_an_mode,
>                                               state->interface,
>                                               state->advertising,
>                                               !!(pl->link_config.pause &
> @@ -533,7 +534,7 @@ static void phylink_mac_pcs_get_state(struct phylink *pl,
>         state->link = 1;
>
>         if (pl->pcs_ops)
> -               pl->pcs_ops->pcs_get_state(pl->config, state);
> +               pl->pcs_ops->pcs_get_state(pl->pcs, state);
>         else
>                 pl->mac_ops->mac_pcs_get_state(pl->config, state);
>  }
> @@ -604,7 +605,7 @@ static void phylink_link_up(struct phylink *pl,
>         pl->cur_interface = link_state.interface;
>
>         if (pl->pcs_ops && pl->pcs_ops->pcs_link_up)
> -               pl->pcs_ops->pcs_link_up(pl->config, pl->cur_link_an_mode,
> +               pl->pcs_ops->pcs_link_up(pl->pcs, pl->cur_link_an_mode,
>                                          pl->cur_interface,
>                                          link_state.speed, link_state.duplex);
>
> @@ -863,11 +864,19 @@ struct phylink *phylink_create(struct phylink_config *config,
>  }
>  EXPORT_SYMBOL_GPL(phylink_create);
>
> -void phylink_add_pcs(struct phylink *pl, const struct phylink_pcs_ops *ops)
> +/**
> + * phylink_set_pcs() - set the current PCS for phylink to use
> + * @pl: a pointer to a &struct phylink returned from phylink_create()
> + * @pcs: a pointer to the &struct phylink_pcs
> + *
> + * Bind the MAC PCS to phylink.
> + */
> +void phylink_set_pcs(struct phylink *pl, struct phylink_pcs *pcs)
>  {
> -       pl->pcs_ops = ops;
> +       pl->pcs = pcs;
> +       pl->pcs_ops = pcs->ops;
>  }
> -EXPORT_SYMBOL_GPL(phylink_add_pcs);
> +EXPORT_SYMBOL_GPL(phylink_set_pcs);
>
>  /**
>   * phylink_destroy() - cleanup and destroy the phylink instance
> @@ -1212,6 +1221,8 @@ void phylink_start(struct phylink *pl)
>                 break;
>         case MLO_AN_INBAND:
>                 poll |= pl->config->pcs_poll;
> +               if (pl->pcs)
> +                       poll |= pl->pcs->poll;

Do we see a need for yet another way to request phylink to poll the
PCS for link status?

>                 break;
>         }
>         if (poll)
> diff --git a/include/linux/phylink.h b/include/linux/phylink.h
> index 2f1315f32113..057f78263a46 100644
> --- a/include/linux/phylink.h
> +++ b/include/linux/phylink.h
> @@ -321,6 +321,21 @@ void mac_link_up(struct phylink_config *config, struct phy_device *phy,
>                  int speed, int duplex, bool tx_pause, bool rx_pause);
>  #endif
>
> +struct phylink_pcs_ops;
> +
> +/**
> + * struct phylink_pcs - PHYLINK PCS instance
> + * @ops: a pointer to the &struct phylink_pcs_ops structure
> + * @poll: poll the PCS for link changes
> + *
> + * This structure is designed to be embedded within the PCS private data,
> + * and will be passed between phylink and the PCS.
> + */
> +struct phylink_pcs {
> +       const struct phylink_pcs_ops *ops;
> +       bool poll;
> +};
> +
>  /**
>   * struct phylink_pcs_ops - MAC PCS operations structure.
>   * @pcs_get_state: read the current MAC PCS link state from the hardware.
> @@ -330,21 +345,21 @@ void mac_link_up(struct phylink_config *config, struct phy_device *phy,
>   *               (where necessary).
>   */
>  struct phylink_pcs_ops {
> -       void (*pcs_get_state)(struct phylink_config *config,
> +       void (*pcs_get_state)(struct phylink_pcs *pcs,
>                               struct phylink_link_state *state);
> -       int (*pcs_config)(struct phylink_config *config, unsigned int mode,
> +       int (*pcs_config)(struct phylink_pcs *pcs, unsigned int mode,
>                           phy_interface_t interface,
>                           const unsigned long *advertising,
>                           bool permit_pause_to_mac);
> -       void (*pcs_an_restart)(struct phylink_config *config);
> -       void (*pcs_link_up)(struct phylink_config *config, unsigned int mode,
> +       void (*pcs_an_restart)(struct phylink_pcs *pcs);
> +       void (*pcs_link_up)(struct phylink_pcs *pcs, unsigned int mode,
>                             phy_interface_t interface, int speed, int duplex);
>  };
>
>  #if 0 /* For kernel-doc purposes only. */
>  /**
>   * pcs_get_state() - Read the current inband link state from the hardware
> - * @config: a pointer to a &struct phylink_config.
> + * @pcs: a pointer to a &struct phylink_pcs.
>   * @state: a pointer to a &struct phylink_link_state.
>   *
>   * Read the current inband link state from the MAC PCS, reporting the
> @@ -357,12 +372,12 @@ struct phylink_pcs_ops {
>   * When present, this overrides mac_pcs_get_state() in &struct
>   * phylink_mac_ops.
>   */
> -void pcs_get_state(struct phylink_config *config,
> +void pcs_get_state(struct phylink_pcs *pcs,
>                    struct phylink_link_state *state);
>
>  /**
>   * pcs_config() - Configure the PCS mode and advertisement
> - * @config: a pointer to a &struct phylink_config.
> + * @pcs: a pointer to a &struct phylink_pcs.
>   * @mode: one of %MLO_AN_FIXED, %MLO_AN_PHY, %MLO_AN_INBAND.
>   * @interface: interface mode to be used
>   * @advertising: adertisement ethtool link mode mask
> @@ -382,21 +397,21 @@ void pcs_get_state(struct phylink_config *config,
>   *
>   * For most 10GBASE-R, there is no advertisement.
>   */
> -int (*pcs_config)(struct phylink_config *config, unsigned int mode,
> -                 phy_interface_t interface, const unsigned long *advertising);
> +int pcs_config(struct phylink_pcs *pcs, unsigned int mode,
> +              phy_interface_t interface, const unsigned long *advertising);
>
>  /**
>   * pcs_an_restart() - restart 802.3z BaseX autonegotiation
> - * @config: a pointer to a &struct phylink_config.
> + * @pcs: a pointer to a &struct phylink_pcs.
>   *
>   * When PCS ops are present, this overrides mac_an_restart() in &struct
>   * phylink_mac_ops.
>   */
> -void (*pcs_an_restart)(struct phylink_config *config);
> +void pcs_an_restart(struct phylink_pcs *pcs);
>
>  /**
>   * pcs_link_up() - program the PCS for the resolved link configuration
> - * @config: a pointer to a &struct phylink_config.
> + * @pcs: a pointer to a &struct phylink_pcs.
>   * @mode: link autonegotiation mode
>   * @interface: link &typedef phy_interface_t mode
>   * @speed: link speed
> @@ -407,14 +422,14 @@ void (*pcs_an_restart)(struct phylink_config *config);
>   * mode without in-band AN needs to be manually configured for the link
>   * and duplex setting. Otherwise, this should be a no-op.
>   */
> -void (*pcs_link_up)(struct phylink_config *config, unsigned int mode,
> -                   phy_interface_t interface, int speed, int duplex);
> +void pcs_link_up(struct phylink_pcs *pcs, unsigned int mode,
> +                phy_interface_t interface, int speed, int duplex);
>  #endif
>
>  struct phylink *phylink_create(struct phylink_config *, struct fwnode_handle *,
>                                phy_interface_t iface,
>                                const struct phylink_mac_ops *mac_ops);
> -void phylink_add_pcs(struct phylink *, const struct phylink_pcs_ops *ops);
> +void phylink_set_pcs(struct phylink *, struct phylink_pcs *pcs);
>  void phylink_destroy(struct phylink *);
>
>  int phylink_connect_phy(struct phylink *, struct phy_device *);
> --
> 2.20.1
>

Thank you,
-Vladimir
