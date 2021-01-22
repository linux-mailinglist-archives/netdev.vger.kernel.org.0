Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7367B2FFAB7
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 03:58:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726570AbhAVC5w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 21:57:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725967AbhAVC5u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 21:57:50 -0500
Received: from mail-vs1-xe2c.google.com (mail-vs1-xe2c.google.com [IPv6:2607:f8b0:4864:20::e2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FFFBC0613D6
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 18:57:10 -0800 (PST)
Received: by mail-vs1-xe2c.google.com with SMTP id o125so2284451vsc.6
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 18:57:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ckMgjO2IVxFZ4Dh566RtuYaM9o3+GyogXHKQlgKt1Pk=;
        b=m0DkEOQ3bCQygwfpvLtWN79Slfcz368F9bS3l0JXqylE0BqpIQJ0VIfvstJVL6G9CK
         qDqBlAEjO/NXKAqW5mUr5O5SiOuD3ULS+lDWHnRnCEg+bKSiybxjVjtdSPNkNK4faDny
         xekUbtTygD9/1dK7t6JgXF46j3tIkFEnpw8uM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ckMgjO2IVxFZ4Dh566RtuYaM9o3+GyogXHKQlgKt1Pk=;
        b=OcDHpJu+V48WJf8rV0eKdTmG28uNEh8i3XMzEy/TG3zydu/zAnTm2tqj2hUPt17WAC
         ixWCpoCAvHLwVZCGPwK3nLFvmsXGuv0dj6LASe07pbMWldfENhz9j1MHsALsbpTGqYLD
         lY5+0Ub4mfP8/bhd2VG9UAuu5WRNZudDENEM+ghbwV6DgLboujLvknphn5T+w1IH/dWu
         8bOA+B8uqe3uM/DNOrUkY0Q9vr0tC8PL7esMRzYoV5mjtop8PheprUGve8GZ8ujHneHf
         cn1M8sUSaNg+McVpKNP7UJUdr27o7A391OS7B4w6PJl4VJdGQuoHb+n3lttr/31S+LuL
         1TpA==
X-Gm-Message-State: AOAM530giId2K0/76I8sI6+aVGyeOksyiE66tf2i5DX1LVxs7fndtZ5q
        DIKEX/ICtWPZM2dJEhYv+4qIg5P6i0pf2ast+Om+Hw==
X-Google-Smtp-Source: ABdhPJzfDAkJ9y6g6gO2/bAA1876KqjlX+W8WF0Kxr6lPLW9mLWbcROvl9gOgwRBlxjfrf7iR3Dk8YWZMspIQl1+sHw=
X-Received: by 2002:a67:2a46:: with SMTP id q67mr2224684vsq.40.1611284229157;
 Thu, 21 Jan 2021 18:57:09 -0800 (PST)
MIME-Version: 1.0
References: <20210121125731.19425-1-oneukum@suse.com> <20210121125731.19425-3-oneukum@suse.com>
In-Reply-To: <20210121125731.19425-3-oneukum@suse.com>
From:   Grant Grundler <grundler@chromium.org>
Date:   Fri, 22 Jan 2021 02:56:57 +0000
Message-ID: <CANEJEGteGiFRySiSV8gMkiCN8nFGX7N+zL9_udRJzG-knng71Q@mail.gmail.com>
Subject: Re: [PATCHv2 2/3] usbnet: add method for reporting speed without MDIO
To:     Oliver Neukum <oneukum@suse.com>
Cc:     Hayes Wang <hayeswang@realtek.com>,
        Grant Grundler <grundler@chromium.org>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, linux-usb@vger.kernel.org,
        Roland Dreier <roland@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 21, 2021 at 12:57 PM Oliver Neukum <oneukum@suse.com> wrote:
>
> The old method for reporting network speed upwards
> assumed that a device uses MDIO and uses the generic phy
> functions based on that.
> Add a a primitive internal version not making the assumption
> reporting back directly what the status operations record.
>
> v2: adjusted to recent changes
>
> Signed-off-by: Oliver Neukum <oneukum@suse.com>
> Tested-by: Roland Dreier <roland@kernel.org>
> ---
>  drivers/net/usb/usbnet.c   | 23 +++++++++++++++++++++++
>  include/linux/usb/usbnet.h |  4 ++++
>  2 files changed, 27 insertions(+)
>
> diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
> index e2ca88259b05..6f8fcc276ca7 100644
> --- a/drivers/net/usb/usbnet.c
> +++ b/drivers/net/usb/usbnet.c
> @@ -961,6 +961,27 @@ int usbnet_get_link_ksettings_mdio(struct net_device *net,
>  }
>  EXPORT_SYMBOL_GPL(usbnet_get_link_ksettings_mdio);
>
> +int usbnet_get_link_ksettings_internal(struct net_device *net,
> +                                       struct ethtool_link_ksettings *cmd)
> +{
> +       struct usbnet *dev = netdev_priv(net);
> +
> +       /* the assumption that speed is equal on tx and rx
> +        * is deeply engrained into the networking layer.

Another nit: s/engrained/ingrained

Also, the word "symmetric" is more commonly used to describe when RX
speed == TX speed (vs "equal").

cheers,
grant

> +        * For wireless stuff it is not true.
> +        * We assume that rxspeed matters more.
> +        */
> +       if (dev->rxspeed != SPEED_UNKNOWN)
> +               cmd->base.speed = dev->rxspeed / 1000000;
> +       else if (dev->txspeed != SPEED_UNKNOWN)
> +               cmd->base.speed = dev->txspeed / 1000000;
> +       else
> +               cmd->base.speed = SPEED_UNKNOWN;
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL_GPL(usbnet_get_link_ksettings_internal);
> +
>  int usbnet_set_link_ksettings_mdio(struct net_device *net,
>                               const struct ethtool_link_ksettings *cmd)
>  {
> @@ -1664,6 +1685,8 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
>         dev->intf = udev;
>         dev->driver_info = info;
>         dev->driver_name = name;
> +       dev->rxspeed = SPEED_UNKNOWN; /* unknown or handled by MII */
> +       dev->txspeed = SPEED_UNKNOWN;
>
>         net->tstats = netdev_alloc_pcpu_stats(struct pcpu_sw_netstats);
>         if (!net->tstats)
> diff --git a/include/linux/usb/usbnet.h b/include/linux/usb/usbnet.h
> index fd65b7a5ee15..a91c6defb104 100644
> --- a/include/linux/usb/usbnet.h
> +++ b/include/linux/usb/usbnet.h
> @@ -53,6 +53,8 @@ struct usbnet {
>         u32                     hard_mtu;       /* count any extra framing */
>         size_t                  rx_urb_size;    /* size for rx urbs */
>         struct mii_if_info      mii;
> +       long                    rxspeed;        /* if MII is not used */
> +       long                    txspeed;        /* if MII is not used */
>
>         /* various kinds of pending driver work */
>         struct sk_buff_head     rxq;
> @@ -269,6 +271,8 @@ extern void usbnet_purge_paused_rxq(struct usbnet *);
>
>  extern int usbnet_get_link_ksettings_mdio(struct net_device *net,
>                                      struct ethtool_link_ksettings *cmd);
> +extern int usbnet_get_link_ksettings_internal(struct net_device *net,
> +                                       struct ethtool_link_ksettings *cmd);
>  extern int usbnet_set_link_ksettings_mdio(struct net_device *net,
>                                      const struct ethtool_link_ksettings *cmd);
>  extern u32 usbnet_get_link(struct net_device *net);
> --
> 2.26.2
>
