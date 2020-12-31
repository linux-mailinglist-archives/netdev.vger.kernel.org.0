Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F0AA2E81A8
	for <lists+netdev@lfdr.de>; Thu, 31 Dec 2020 19:54:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbgLaSwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Dec 2020 13:52:07 -0500
Received: from mail-ot1-f52.google.com ([209.85.210.52]:33432 "EHLO
        mail-ot1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbgLaSwH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Dec 2020 13:52:07 -0500
Received: by mail-ot1-f52.google.com with SMTP id b24so18680286otj.0;
        Thu, 31 Dec 2020 10:51:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3s0Zd41XA96gD+4GxhcC8fTWK819UxIpZXhCAJrLsmk=;
        b=lldz/P/yKnXwjlqqCJWe7ZLUOHlS3lMd2xeLRJOUZcKFShcgVZ4u10gIZuieazCd8B
         kvj4vRr/R7ELrbEDrbBwwnP2lDwL19xBOszsET06GlEWJr3kUM1UKaD5niubS40e0ID/
         EnrTM0ps1HuiCazRsBSKcZj2sPhsNVpJFfzs2xdo5MNi9vrqmmGLjY2buWe/2Cjt2Cq+
         gRKrLNBxVGKlsuiEb8rWqywO20qr7HOlSBPlM/ClvtrwBjdOnQ0faz87zU9OArA4T0sA
         tWs5p2V4W7I+Wa5uhPiXZEoCx7wfzWM2HuMLXwpxpwgE3waHOtapxIIPjb6IpC4pgRvQ
         S1gQ==
X-Gm-Message-State: AOAM533F3qhJjN/o2jKCfVidQtzgqxowhT4i3pSr2+K2KcSGlqKUrjHX
        GakZJm2Hk8S/2rI60psAgkUYoe+BbQurQzChOk4IC9OtK1dkNA==
X-Google-Smtp-Source: ABdhPJz/FCgr3ulkjceyF5vEllTJ235pnsX5pfw+BtGvGWOKqBnXfgL155EOsrLi83YDQWsO7HF7Uc98YTBBmsfJ2ZE=
X-Received: by 2002:a05:6830:1bc6:: with SMTP id v6mr43231547ota.135.1609440686313;
 Thu, 31 Dec 2020 10:51:26 -0800 (PST)
MIME-Version: 1.0
References: <20201222184926.35382198@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201224032116.2453938-1-roland@kernel.org> <X+RJEI+1AR5E0z3z@kroah.com>
 <20201228133036.3a2e9fb5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAG4TOxNM8du=xadLeVwNU5Zq=MW7Kj74-1d9ThZ0q2OrXHE5qQ@mail.gmail.com>
 <24c6faa2a4f91c721d9a7f14bb7b641b89ae987d.camel@neukum.org>
 <CAG4TOxOc2OJnzJg9mwd2h+k0mj250S6NdNQmhK7BbHhT4_KdVA@mail.gmail.com> <12f345107c0832a00c43767ac6bb3aeda4241d4e.camel@suse.com>
In-Reply-To: <12f345107c0832a00c43767ac6bb3aeda4241d4e.camel@suse.com>
From:   Roland Dreier <roland@kernel.org>
Date:   Thu, 31 Dec 2020 10:51:09 -0800
Message-ID: <CAG4TOxOOPgAqUtX14V7k-qPCbOm7+5gaHOqBvgWBYQwJkO6v8g@mail.gmail.com>
Subject: Re: [PATCH] CDC-NCM: remove "connected" log message
To:     Oliver Neukum <oneukum@suse.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I haven't tried these patches yet but they don't look quite right to
me.  inlining the first 0001 patch:

 > diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
 > index 1447da1d5729..bcd17f6d6de6 100644
 > --- a/drivers/net/usb/usbnet.c
 > +++ b/drivers/net/usb/usbnet.c
 > @@ -944,7 +944,7 @@ EXPORT_SYMBOL_GPL(usbnet_open);
 >   * they'll probably want to use this base set.
 >   */
 >
 > -int usbnet_get_link_ksettings(struct net_device *net,
 > +int usbnet_get_link_ksettings_mdio(struct net_device *net,
 >                    struct ethtool_link_ksettings *cmd)
 >  {
 >      struct usbnet *dev = netdev_priv(net);
 > @@ -956,6 +956,32 @@ int usbnet_get_link_ksettings(struct net_device *net,
 >
 >      return 0;
 >  }
 > +EXPORT_SYMBOL_GPL(usbnet_get_link_ksettings_mdio);

why keep and export the old function when it will have no callers?

 > +int usbnet_get_link_ksettings(struct net_device *net,
 > +                    struct ethtool_link_ksettings *cmd)
 > +{
 > +    struct usbnet *dev = netdev_priv(net);
 > +
 > +    /* the assumption that speed is equal on tx and rx
 > +     * is deeply engrained into the networking layer.
 > +     * For wireless stuff it is not true.
 > +     * We assume that rxspeed matters more.
 > +     */
 > +    if (dev->rxspeed != SPEED_UNKNOWN)
 > +        cmd->base.speed = dev->rxspeed / 1000000;
 > +    else if (dev->txspeed != SPEED_UNKNOWN)
 > +        cmd->base.speed = dev->txspeed / 1000000;
 > +    /* if a minidriver does not record speed we try to
 > +     * fall back on MDIO
 > +     */
 > +    else if (!dev->mii.mdio_read)
 > +        cmd->base.speed = SPEED_UNKNOWN;
 > +    else
 > +        mii_ethtool_get_link_ksettings(&dev->mii, cmd);
 > +
 > +    return 0;

This is a change in behavior for every driver that doesn't set rxspeed
/ txspeed - the old get_link function would return EOPNOTSUPP if
mdio_read isn't implemented, now we give SPEED_UNKNOWN with a
successful return code.

 > @@ -1661,6 +1687,8 @@ usbnet_probe (struct usb_interface *udev,
const struct usb_device_id *prod)
 >      dev->intf = udev;
 >      dev->driver_info = info;
 >      dev->driver_name = name;
 > +    dev->rxspeed = -1; /* unknown or handled by MII */
 > +    dev->txspeed = -1;

Minor nit: if we're going to test these against SPEED_UNKNOWN above,
then I think it's clearer to initialize them to that value via the
same constant.

 > diff --git a/include/linux/usb/usbnet.h b/include/linux/usb/usbnet.h
 > index 88a7673894d5..f748c758f82a 100644
 > --- a/include/linux/usb/usbnet.h
 > +++ b/include/linux/usb/usbnet.h
 > @@ -267,8 +269,11 @@ extern void usbnet_purge_paused_rxq(struct usbnet *);
 >
 >  extern int usbnet_get_link_ksettings(struct net_device *net,
 >                       struct ethtool_link_ksettings *cmd);
 > -extern int usbnet_set_link_ksettings(struct net_device *net,
 > +extern int usbnet_set_link_ksettings_mdio(struct net_device *net,
 >                       const struct ethtool_link_ksettings *cmd);
 > +/* Legacy - to be used if you really need an error to be returned */
 > +extern int usbnet_set_link_ksettings(struct net_device *net,
 > +                    const struct ethtool_link_ksettings *cmd);
 >  extern u32 usbnet_get_link(struct net_device *net);
 >  extern u32 usbnet_get_msglevel(struct net_device *);
 >  extern void usbnet_set_msglevel(struct net_device *, u32);

I think this was meant to be changing get_link, not set_link.

Also I don't understand the "Legacy" comment.  Is that referring to
the EOPNOTSUPP change I mentioned above?  If so, wouldn't it be better
to preserve the legacy behavior rather than changing the behavior of
every usbnet driver all at once?  Like make a new
usbnet_get_link_ksettings_nonmdio and update only cdc_ncm to use it?

 - R.
