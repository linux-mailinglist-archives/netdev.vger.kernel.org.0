Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACC042F710A
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 04:36:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732619AbhAODfJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 22:35:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730600AbhAODfJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 22:35:09 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BABAFC061575
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 19:34:28 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id z5so15601324iob.11
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 19:34:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M7pp+9RVN01JAXoDUg8A3unV9n4IrQJXmOBGOKKm20w=;
        b=Rpe+o+MhLBkOXdLdTYVPaTVNcs3PH3KwNVRQsie6lEOYzKH9ymdl12cs7vd9WdOoT9
         pPnqZSqJtedr+fxA7c8MkV2h/iERCzrRkFVKXyJuIN4ogXRZocpvi1Ai5TiHORyrfWdk
         dgNS/nlqYWjOZE3musBSjXNuZ/m2zs7BidAF814Gn0s9lx3GME4hZ6oeUvP8jyWnIf6c
         ujMDJzE/2bGSYC7YJIEgbnCMMMlCWns7SuK4O7duaLZQsxcN1DgU7lOzOdUANYqFsp8N
         blt3nfgdUIv5yR7NyNHgxIO3Cat0Gu9S8jTSJc3iD10tTNdDZ+mBf/sxZ8XF5b9WKGmK
         DMwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=M7pp+9RVN01JAXoDUg8A3unV9n4IrQJXmOBGOKKm20w=;
        b=Ze1ZgWeHlJDXEjv8o3HMA04+9SxHd6Z93xZTcw9eoG/2Ip/zTsZ/lgovPdBJbQr6Nl
         zrDpDkqkoTdZOewfVo0mzS/ApYUJt/JQiMzv9iSfz8HnDFkbI+5a7cGtlyPI0c9tTy37
         JqhXvpW5okRd8iO0LEgNW6lfOv5qQ9npDujnHQNiFHCUHYBqLwt/T9hMOy1W7quuCj2v
         SxKHSrQDQUXwE3qqR6iBcx/Jjpbxu1MqDraZ29/t/6S0hI8knQweEiuJWRInxNJiLqdh
         pPAnvot+DrKODITuDJd1eaVAZDwkrwudCm/JFL0onhnd2xgVvl/QZMtqN8aAU+OxNBM4
         9eCA==
X-Gm-Message-State: AOAM533IlyyUlS2KkfTWKarukkJBeWGdVX+Hk4zbrlguFhi7FY3swbh5
        u1FDhFNK/LfL3Xt+kiGYomrBO14N27v5zIQASoo=
X-Google-Smtp-Source: ABdhPJzgntAES5LNzCduhNHZJYKuoEnfGGOXGPQJzI9T49mwk8Z8Yk4458PdhXKUnA5Jkft835Ar4mvCJmZ/UmzKSjw=
X-Received: by 2002:a05:6602:200a:: with SMTP id y10mr7282215iod.5.1610681667960;
 Thu, 14 Jan 2021 19:34:27 -0800 (PST)
MIME-Version: 1.0
References: <20210115003123.1254314-1-weiwan@google.com> <20210115003123.1254314-4-weiwan@google.com>
In-Reply-To: <20210115003123.1254314-4-weiwan@google.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 14 Jan 2021 19:34:17 -0800
Message-ID: <CAKgT0UdRK=KXT40nPmHbCeLixDkwdYEEFbwECnAKBFBjUsPOHQ@mail.gmail.com>
Subject: Re: [PATCH net-next v6 3/3] net: add sysfs attribute to control napi
 threaded mode
To:     Wei Wang <weiwan@google.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Felix Fietkau <nbd@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 14, 2021 at 4:34 PM Wei Wang <weiwan@google.com> wrote:
>
> This patch adds a new sysfs attribute to the network device class.
> Said attribute provides a per-device control to enable/disable the
> threaded mode for all the napi instances of the given network device.
>
> Co-developed-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> Co-developed-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
> Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
> Co-developed-by: Felix Fietkau <nbd@nbd.name>
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> Signed-off-by: Wei Wang <weiwan@google.com>
> ---
>  include/linux/netdevice.h |  2 ++
>  net/core/dev.c            | 28 +++++++++++++++++
>  net/core/net-sysfs.c      | 63 +++++++++++++++++++++++++++++++++++++++
>  3 files changed, 93 insertions(+)
>
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index c24ed232c746..11ae0c9b9350 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -497,6 +497,8 @@ static inline bool napi_complete(struct napi_struct *n)
>         return napi_complete_done(n, 0);
>  }
>
> +int dev_set_threaded(struct net_device *dev, bool threaded);
> +
>  /**
>   *     napi_disable - prevent NAPI from scheduling
>   *     @n: NAPI context
> diff --git a/net/core/dev.c b/net/core/dev.c
> index edcfec1361e9..d5fb95316ea8 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -6754,6 +6754,34 @@ static int napi_set_threaded(struct napi_struct *n, bool threaded)
>         return err;
>  }
>
> +static void dev_disable_threaded_all(struct net_device *dev)
> +{
> +       struct napi_struct *napi;
> +
> +       list_for_each_entry(napi, &dev->napi_list, dev_list)
> +               napi_set_threaded(napi, false);
> +}
> +
> +int dev_set_threaded(struct net_device *dev, bool threaded)
> +{
> +       struct napi_struct *napi;
> +       int ret;
> +
> +       dev->threaded = threaded;
> +       list_for_each_entry(napi, &dev->napi_list, dev_list) {
> +               ret = napi_set_threaded(napi, threaded);
> +               if (ret) {
> +                       /* Error occurred on one of the napi,
> +                        * reset threaded mode on all napi.
> +                        */
> +                       dev_disable_threaded_all(dev);
> +                       break;
> +               }
> +       }
> +
> +       return ret;

This doesn't seem right. The NAPI instances can be active while this
is occuring can they not? I would think at a minimum you need to go
through a napi_disable/napi_enable in order to toggle this value for
each NAPI instance. Otherwise aren't you at risk for racing and having
a napi_schedule attempt to wake up the thread before it has been
allocated?

> +}
> +
>  void netif_napi_add(struct net_device *dev, struct napi_struct *napi,
>                     int (*poll)(struct napi_struct *, int), int weight)
>  {
> diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
> index daf502c13d6d..2017f8f07b8d 100644
> --- a/net/core/net-sysfs.c
> +++ b/net/core/net-sysfs.c
> @@ -538,6 +538,68 @@ static ssize_t phys_switch_id_show(struct device *dev,
>  }
>  static DEVICE_ATTR_RO(phys_switch_id);
>
> +static ssize_t threaded_show(struct device *dev,
> +                            struct device_attribute *attr, char *buf)
> +{
> +       struct net_device *netdev = to_net_dev(dev);
> +       struct napi_struct *n;
> +       bool enabled;
> +       int ret;
> +
> +       if (!rtnl_trylock())
> +               return restart_syscall();
> +
> +       if (!dev_isalive(netdev)) {
> +               ret = -EINVAL;
> +               goto unlock;
> +       }
> +
> +       if (list_empty(&netdev->napi_list)) {
> +               ret = -EOPNOTSUPP;
> +               goto unlock;
> +       }
> +
> +       /* Only return true if all napi have threaded mode.
> +        * The inconsistency could happen when the device driver calls
> +        * napi_disable()/napi_enable() with dev->threaded set to true,
> +        * but napi_kthread_create() fails.
> +        * We return false in this case to remind the user that one or
> +        * more napi did not have threaded mode enabled properly.
> +        */
> +       list_for_each_entry(n, &netdev->napi_list, dev_list) {
> +               enabled = !!test_bit(NAPI_STATE_THREADED, &n->state);
> +               if (!enabled)
> +                       break;
> +       }
> +

This logic seems backwards to me. If we have it enabled for any of
them it seems like we should report it was enabled. Otherwise we are
going to be leaking out instances of threaded napi and not be able to
easily find where they are coming from. If nothing else it might make
sense to have this as a ternary value where it is either enabled,
disabled, or partial/broken.

Also why bother testing each queue when you already have dev->threaded?

> +       ret = sprintf(buf, fmt_dec, enabled);
> +
> +unlock:
> +       rtnl_unlock();
> +       return ret;
> +}
> +
> +static int modify_napi_threaded(struct net_device *dev, unsigned long val)
> +{
> +       struct napi_struct *napi;
> +       int ret;
> +
> +       if (list_empty(&dev->napi_list))
> +               return -EOPNOTSUPP;
> +
> +       ret = dev_set_threaded(dev, !!val);
> +
> +       return ret;
> +}
> +
> +static ssize_t threaded_store(struct device *dev,
> +                             struct device_attribute *attr,
> +                             const char *buf, size_t len)
> +{
> +       return netdev_store(dev, attr, buf, len, modify_napi_threaded);
> +}
> +static DEVICE_ATTR_RW(threaded);
> +
>  static struct attribute *net_class_attrs[] __ro_after_init = {
>         &dev_attr_netdev_group.attr,
>         &dev_attr_type.attr,
> @@ -570,6 +632,7 @@ static struct attribute *net_class_attrs[] __ro_after_init = {
>         &dev_attr_proto_down.attr,
>         &dev_attr_carrier_up_count.attr,
>         &dev_attr_carrier_down_count.attr,
> +       &dev_attr_threaded.attr,
>         NULL,
>  };
>  ATTRIBUTE_GROUPS(net_class);
> --
> 2.30.0.284.gd98b1dd5eaa7-goog
>
