Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64E8831F060
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 20:51:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233131AbhBRTr7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 14:47:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231307AbhBRTcg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Feb 2021 14:32:36 -0500
Received: from mail-ua1-x935.google.com (mail-ua1-x935.google.com [IPv6:2607:f8b0:4864:20::935])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34A00C06178A
        for <netdev@vger.kernel.org>; Thu, 18 Feb 2021 11:31:54 -0800 (PST)
Received: by mail-ua1-x935.google.com with SMTP id j15so1063057uaa.9
        for <netdev@vger.kernel.org>; Thu, 18 Feb 2021 11:31:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/imHFy1Wzk70x/QNT6k9gYmtXpZ0Qm8M3H4mEiDsvG4=;
        b=aCbvGnbiy6Slepfq6xhtdg9HrXCf3lqrmjzLKZGwwYvaLmUQl+CGRVQxjci0oe1g5J
         O+auRckjGrDpB4eiPkWtdmDsQ7eVYxCZkk1l71qSevSvxPyFjJqKw2FDkTI0KhXZaHVJ
         18Il9KxpZfkK8brOb76GHTAUjyNgq66v2YwCw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/imHFy1Wzk70x/QNT6k9gYmtXpZ0Qm8M3H4mEiDsvG4=;
        b=A4zs0ti5DqY7VCg+jBmnhGf2FCMCrb53fPKqL82y8vDY+q6E3Yu+9veQVtb7D0q8X0
         spwrR4CSf4Q5I5d4ZQ4eA7NZP0wRLAhX1tQUBIPWrQ12GCeH5CweKboojfWrKaJal8Sf
         a+SdVDYldhEoBZY6DY4W1S7kO3F72OqW7D4SR/i1eezGtf/c/3Fu7Qak3Y0Sx7CDBYry
         SklnAWy0m7q0PKXa93dydDrMMhtU175NMzNMYQp7cyPNm7+aWdlMb3xd7c6MZ3waHdG5
         JlHX09fkdoNebQlH5u2OPL5HxTcNu3IYeUzvXEEWaJxbm1VzGWklVQrg7eWenSOLBhoa
         9mqA==
X-Gm-Message-State: AOAM531RMmHOJgBtHRJX4aVyyr++CtZioMtJdkHe8oMsHZAmkrE1FROh
        9HIpMiKX/436SRCgiWYO0aJ5xkaB0mqEse8yaa1AEA==
X-Google-Smtp-Source: ABdhPJx8mSt+FjyiQ5g+SGB1x1E8TCmagj+gupfc+lqJOZr9Uhd2xWPXdEXYl47G/MtbmvuDjkeO7gbMkBwYkJ7CzXA=
X-Received: by 2002:a9f:24c4:: with SMTP id 62mr4922709uar.84.1613676713023;
 Thu, 18 Feb 2021 11:31:53 -0800 (PST)
MIME-Version: 1.0
References: <20210218102038.2996-1-oneukum@suse.com> <20210218102038.2996-2-oneukum@suse.com>
In-Reply-To: <20210218102038.2996-2-oneukum@suse.com>
From:   Grant Grundler <grundler@chromium.org>
Date:   Thu, 18 Feb 2021 19:31:41 +0000
Message-ID: <CANEJEGu+fqkgu6whO_1BXFpnf5K6BG8Z7nUmHcJaYU9_tc7svg@mail.gmail.com>
Subject: Re: [PATCHv3 1/3] usbnet: specify naming of usbnet_set/get_link_ksettings
To:     Oliver Neukum <oneukum@suse.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Grant Grundler <grundler@chromium.org>,
        Andrew Lunn <andrew@lunn.ch>, davem@devemloft.org,
        Hayes Wang <hayeswang@realtek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Roland Dreier <roland@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Oliver, Jakub,
Can I post v4 and deal with the issues below?

I can compile and test against ToT for now and I'll like to get this
mess behind me.

I still think the first patch in this series should revert my previous
change (de658a195ee23ca6aaffe197d1d2ea040beea0a2).

On Thu, Feb 18, 2021 at 10:21 AM Oliver Neukum <oneukum@suse.com> wrote:
>
> The old generic functions assume that the devices includes
> an MDIO interface. This is true only for genuine ethernet.
> Devices with a higher level of abstraction or based on different
> technologies do not have it. So in preparation for
> supporting that, we rename the old functions to something specific.

I'd like to propose a rewrite of the commit message:
    usbnet: add _mii suffix to usbnet_set/get_link_ksettings

    The generic functions assumed devices provided an MDIO interface (accessed
    via older mii code, not phylib). This is true only for genuine ethernet.

    Devices with a higher level of abstraction or based on different
    technologies do not have MDIO. To support this case, first rename
    the existing functions with _mii suffix.

> v2: rebased on changed upstream
> v3: changed names to clearly say that this does NOT use phylib

Nit: The v2/v3 lines should be included BELOW the '---' line since
they don't belong in the commit message.

Nit2: V3 folds part of a successive patch into this one. If that was
intentional, the commit message needs further rewrite and the changes
to usbnet.h got lost.

> Signed-off-by : Oliver Neukum <oneukum@suse.com>
> Tested-by: Roland Dreier <roland@kernel.org>
> ---
>  drivers/net/usb/asix_devices.c | 12 ++++++------
>  drivers/net/usb/cdc_ncm.c      |  4 ++--
>  drivers/net/usb/dm9601.c       |  4 ++--
>  drivers/net/usb/mcs7830.c      |  4 ++--
>  drivers/net/usb/sierra_net.c   |  4 ++--
>  drivers/net/usb/smsc75xx.c     |  4 ++--
>  drivers/net/usb/sr9700.c       |  4 ++--
>  drivers/net/usb/sr9800.c       |  4 ++--
>  drivers/net/usb/usbnet.c       | 36 ++++++++++++++++++++++++++++------
>  include/linux/usb/usbnet.h     |  6 ++++--
>  10 files changed, 54 insertions(+), 28 deletions(-)
>
> diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
> index 6e13d8165852..19a8fafb8f04 100644
> --- a/drivers/net/usb/asix_devices.c
> +++ b/drivers/net/usb/asix_devices.c
> @@ -125,8 +125,8 @@ static const struct ethtool_ops ax88172_ethtool_ops = {
>         .get_eeprom             = asix_get_eeprom,
>         .set_eeprom             = asix_set_eeprom,
>         .nway_reset             = usbnet_nway_reset,
> -       .get_link_ksettings     = usbnet_get_link_ksettings,
> -       .set_link_ksettings     = usbnet_set_link_ksettings,
> +       .get_link_ksettings     = usbnet_get_link_ksettings_mii,
> +       .set_link_ksettings     = usbnet_set_link_ksettings_mii,
>  };
>
>  static void ax88172_set_multicast(struct net_device *net)
> @@ -291,8 +291,8 @@ static const struct ethtool_ops ax88772_ethtool_ops = {
>         .get_eeprom             = asix_get_eeprom,
>         .set_eeprom             = asix_set_eeprom,
>         .nway_reset             = usbnet_nway_reset,
> -       .get_link_ksettings     = usbnet_get_link_ksettings,
> -       .set_link_ksettings     = usbnet_set_link_ksettings,
> +       .get_link_ksettings     = usbnet_get_link_ksettings_mii,
> +       .set_link_ksettings     = usbnet_set_link_ksettings_mii,
>  };
>
>  static int ax88772_link_reset(struct usbnet *dev)
> @@ -782,8 +782,8 @@ static const struct ethtool_ops ax88178_ethtool_ops = {
>         .get_eeprom             = asix_get_eeprom,
>         .set_eeprom             = asix_set_eeprom,
>         .nway_reset             = usbnet_nway_reset,
> -       .get_link_ksettings     = usbnet_get_link_ksettings,
> -       .set_link_ksettings     = usbnet_set_link_ksettings,
> +       .get_link_ksettings     = usbnet_get_link_ksettings_mii,
> +       .set_link_ksettings     = usbnet_set_link_ksettings_mii,
>  };
>
>  static int marvell_phy_init(struct usbnet *dev)
> diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
> index 4087c9e33781..0d26cbeb6e04 100644
> --- a/drivers/net/usb/cdc_ncm.c
> +++ b/drivers/net/usb/cdc_ncm.c
> @@ -142,8 +142,8 @@ static const struct ethtool_ops cdc_ncm_ethtool_ops = {
>         .get_sset_count    = cdc_ncm_get_sset_count,
>         .get_strings       = cdc_ncm_get_strings,
>         .get_ethtool_stats = cdc_ncm_get_ethtool_stats,
> -       .get_link_ksettings      = usbnet_get_link_ksettings,
> -       .set_link_ksettings      = usbnet_set_link_ksettings,
> +       .get_link_ksettings      = usbnet_get_link_ksettings_internal,
> +       .set_link_ksettings      = usbnet_set_link_ksettings_mii,
>  };
>
>  static u32 cdc_ncm_check_rx_max(struct usbnet *dev, u32 new_rx)
> diff --git a/drivers/net/usb/dm9601.c b/drivers/net/usb/dm9601.c
> index b5d2ac55a874..89cc61d7a675 100644
> --- a/drivers/net/usb/dm9601.c
> +++ b/drivers/net/usb/dm9601.c
> @@ -282,8 +282,8 @@ static const struct ethtool_ops dm9601_ethtool_ops = {
>         .get_eeprom_len = dm9601_get_eeprom_len,
>         .get_eeprom     = dm9601_get_eeprom,
>         .nway_reset     = usbnet_nway_reset,
> -       .get_link_ksettings     = usbnet_get_link_ksettings,
> -       .set_link_ksettings     = usbnet_set_link_ksettings,
> +       .get_link_ksettings     = usbnet_get_link_ksettings_mii,
> +       .set_link_ksettings     = usbnet_set_link_ksettings_mii,
>  };
>
>  static void dm9601_set_multicast(struct net_device *net)
> diff --git a/drivers/net/usb/mcs7830.c b/drivers/net/usb/mcs7830.c
> index fc512b780d15..9f9352a4522f 100644
> --- a/drivers/net/usb/mcs7830.c
> +++ b/drivers/net/usb/mcs7830.c
> @@ -452,8 +452,8 @@ static const struct ethtool_ops mcs7830_ethtool_ops = {
>         .get_msglevel           = usbnet_get_msglevel,
>         .set_msglevel           = usbnet_set_msglevel,
>         .nway_reset             = usbnet_nway_reset,
> -       .get_link_ksettings     = usbnet_get_link_ksettings,
> -       .set_link_ksettings     = usbnet_set_link_ksettings,
> +       .get_link_ksettings     = usbnet_get_link_ksettings_mii,
> +       .set_link_ksettings     = usbnet_set_link_ksettings_mii,
>  };
>
>  static const struct net_device_ops mcs7830_netdev_ops = {
> diff --git a/drivers/net/usb/sierra_net.c b/drivers/net/usb/sierra_net.c
> index 55a244eca5ca..55025202dc4f 100644
> --- a/drivers/net/usb/sierra_net.c
> +++ b/drivers/net/usb/sierra_net.c
> @@ -629,8 +629,8 @@ static const struct ethtool_ops sierra_net_ethtool_ops = {
>         .get_msglevel = usbnet_get_msglevel,
>         .set_msglevel = usbnet_set_msglevel,
>         .nway_reset = usbnet_nway_reset,
> -       .get_link_ksettings = usbnet_get_link_ksettings,
> -       .set_link_ksettings = usbnet_set_link_ksettings,
> +       .get_link_ksettings = usbnet_get_link_ksettings_mii,
> +       .set_link_ksettings = usbnet_set_link_ksettings_mii,
>  };
>
>  static int sierra_net_get_fw_attr(struct usbnet *dev, u16 *datap)
> diff --git a/drivers/net/usb/smsc75xx.c b/drivers/net/usb/smsc75xx.c
> index 4353b370249f..f8cdabb9ef5a 100644
> --- a/drivers/net/usb/smsc75xx.c
> +++ b/drivers/net/usb/smsc75xx.c
> @@ -741,8 +741,8 @@ static const struct ethtool_ops smsc75xx_ethtool_ops = {
>         .set_eeprom     = smsc75xx_ethtool_set_eeprom,
>         .get_wol        = smsc75xx_ethtool_get_wol,
>         .set_wol        = smsc75xx_ethtool_set_wol,
> -       .get_link_ksettings     = usbnet_get_link_ksettings,
> -       .set_link_ksettings     = usbnet_set_link_ksettings,
> +       .get_link_ksettings     = usbnet_get_link_ksettings_mii,
> +       .set_link_ksettings     = usbnet_set_link_ksettings_mii,
>  };
>
>  static int smsc75xx_ioctl(struct net_device *netdev, struct ifreq *rq, int cmd)
> diff --git a/drivers/net/usb/sr9700.c b/drivers/net/usb/sr9700.c
> index 878557ad03ad..ce29261263cd 100644
> --- a/drivers/net/usb/sr9700.c
> +++ b/drivers/net/usb/sr9700.c
> @@ -250,8 +250,8 @@ static const struct ethtool_ops sr9700_ethtool_ops = {
>         .get_eeprom_len = sr9700_get_eeprom_len,
>         .get_eeprom     = sr9700_get_eeprom,
>         .nway_reset     = usbnet_nway_reset,
> -       .get_link_ksettings     = usbnet_get_link_ksettings,
> -       .set_link_ksettings     = usbnet_set_link_ksettings,
> +       .get_link_ksettings     = usbnet_get_link_ksettings_mii,
> +       .set_link_ksettings     = usbnet_set_link_ksettings_mii,
>  };
>
>  static void sr9700_set_multicast(struct net_device *netdev)
> diff --git a/drivers/net/usb/sr9800.c b/drivers/net/usb/sr9800.c
> index da56735d7755..a822d81310d5 100644
> --- a/drivers/net/usb/sr9800.c
> +++ b/drivers/net/usb/sr9800.c
> @@ -527,8 +527,8 @@ static const struct ethtool_ops sr9800_ethtool_ops = {
>         .get_eeprom_len = sr_get_eeprom_len,
>         .get_eeprom     = sr_get_eeprom,
>         .nway_reset     = usbnet_nway_reset,
> -       .get_link_ksettings     = usbnet_get_link_ksettings,
> -       .set_link_ksettings     = usbnet_set_link_ksettings,
> +       .get_link_ksettings     = usbnet_get_link_ksettings_mii,
> +       .set_link_ksettings     = usbnet_set_link_ksettings_mii,
>  };
>
>  static int sr9800_link_reset(struct usbnet *dev)
> diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
> index b4c8080e6f87..f3e5ad9befd0 100644
> --- a/drivers/net/usb/usbnet.c
> +++ b/drivers/net/usb/usbnet.c
> @@ -944,7 +944,10 @@ EXPORT_SYMBOL_GPL(usbnet_open);
>   * they'll probably want to use this base set.
>   */
>
> -int usbnet_get_link_ksettings(struct net_device *net,
> +/* These methods are written on the assumption that the device
> + * uses MII
> + */
> +int usbnet_get_link_ksettings_mii(struct net_device *net,
>                               struct ethtool_link_ksettings *cmd)
>  {
>         struct usbnet *dev = netdev_priv(net);
> @@ -956,9 +959,30 @@ int usbnet_get_link_ksettings(struct net_device *net,
>
>         return 0;
>  }
> -EXPORT_SYMBOL_GPL(usbnet_get_link_ksettings);
> +EXPORT_SYMBOL_GPL(usbnet_get_link_ksettings_mii);
> +
> +int usbnet_get_link_ksettings_internal(struct net_device *net,
> +                                       struct ethtool_link_ksettings *cmd)
> +{
> +       struct usbnet *dev = netdev_priv(net);
> +
> +       /* the assumption that speed is equal on tx and rx
> +        * is deeply engrained into the networking layer.
> +        * For wireless stuff it is not true.
> +        * We assume that rxspeed matters more.
> +        */
> +       if (dev->rxspeed != SPEED_UNKNOWN)

rxspeed doesn't exist yet - that was part of the successive patch
(added to usbnet.h)

cheers,
grant

> +               cmd->base.speed = dev->rxspeed / 1000000;
> +       else if (dev->txspeed != SPEED_UNKNOWN)
> +               cmd->base.speed = dev->txspeed / 1000000;
> +       else
> +               cmd->base.speed = SPEED_UNKNOWN;
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL_GPL(usbnet_get_link_ksettings_internal);
>
> -int usbnet_set_link_ksettings(struct net_device *net,
> +int usbnet_set_link_ksettings_mii(struct net_device *net,
>                               const struct ethtool_link_ksettings *cmd)
>  {
>         struct usbnet *dev = netdev_priv(net);
> @@ -978,7 +1002,7 @@ int usbnet_set_link_ksettings(struct net_device *net,
>
>         return retval;
>  }
> -EXPORT_SYMBOL_GPL(usbnet_set_link_ksettings);
> +EXPORT_SYMBOL_GPL(usbnet_set_link_ksettings_mii);
>
>  u32 usbnet_get_link (struct net_device *net)
>  {
> @@ -1043,8 +1067,8 @@ static const struct ethtool_ops usbnet_ethtool_ops = {
>         .get_msglevel           = usbnet_get_msglevel,
>         .set_msglevel           = usbnet_set_msglevel,
>         .get_ts_info            = ethtool_op_get_ts_info,
> -       .get_link_ksettings     = usbnet_get_link_ksettings,
> -       .set_link_ksettings     = usbnet_set_link_ksettings,
> +       .get_link_ksettings     = usbnet_get_link_ksettings_mii,
> +       .set_link_ksettings     = usbnet_set_link_ksettings_mii,
>  };
>
>  /*-------------------------------------------------------------------------*/
> diff --git a/include/linux/usb/usbnet.h b/include/linux/usb/usbnet.h
> index cfbfd6fe01df..132c1b5e14bb 100644
> --- a/include/linux/usb/usbnet.h
> +++ b/include/linux/usb/usbnet.h
> @@ -267,9 +267,11 @@ extern void usbnet_pause_rx(struct usbnet *);
>  extern void usbnet_resume_rx(struct usbnet *);
>  extern void usbnet_purge_paused_rxq(struct usbnet *);
>
> -extern int usbnet_get_link_ksettings(struct net_device *net,
> +extern int usbnet_get_link_ksettings_mii(struct net_device *net,
>                                      struct ethtool_link_ksettings *cmd);
> -extern int usbnet_set_link_ksettings(struct net_device *net,
> +extern int usbnet_get_link_ksettings_internal(struct net_device *net,
> +                                       struct ethtool_link_ksettings *cmd);
> +extern int usbnet_set_link_ksettings_mii(struct net_device *net,
>                                      const struct ethtool_link_ksettings *cmd);
>  extern u32 usbnet_get_link(struct net_device *net);
>  extern u32 usbnet_get_msglevel(struct net_device *);
> --
> 2.26.2
>
