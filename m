Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D783129005
	for <lists+netdev@lfdr.de>; Sun, 22 Dec 2019 22:20:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbfLVVUh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Dec 2019 16:20:37 -0500
Received: from mail-yw1-f67.google.com ([209.85.161.67]:38171 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbfLVVUh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Dec 2019 16:20:37 -0500
Received: by mail-yw1-f67.google.com with SMTP id 10so6411769ywv.5
        for <netdev@vger.kernel.org>; Sun, 22 Dec 2019 13:20:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=azxX+U8X2a5KwfeoIJrzhhFHBOPllF5pimX+og6FL88=;
        b=Toj/uXbq7Gza1Nw3sM86tZknbN78KmjP4J6/pRBW56sLpVtZJJQuWDLzBfdEFyi3HI
         WC5r5RkKBAnHvJODja6jIwXzlF/FdQGuBDeg/CXv+VpwNhxVn2JEtuoj+ZG2GLC0I9py
         xRYnw3goxv7zt4fOP+ErjRrVUphx62cTa8rUm8DWaje8LjVkpoC2JdbZC0meYPrkSqzP
         snf3qDUmAXB4rS8uwk0WdSYywjs9jUKLFticJ7LNL9tL49AbFH23in0VNesvbneV6qLZ
         SiiJm93pXXQL+/u3XvpDFpC8WiD7NxzB8hiaYxs2p39PChVLv1jWH1PLFg1MfSXaTuMc
         xwlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=azxX+U8X2a5KwfeoIJrzhhFHBOPllF5pimX+og6FL88=;
        b=L3EHCgxqOj//X/x7Pqsz8r6XWlEyjLioJ7q8oXsOy5v7F+C/xtGJYFJt23Udp0Etqk
         W0VRGJBNtQUMuDha3AIt7fg5dgU+qF30ZWxwY+E7HdQOPZFM8jcrK6QskTjg1pxVJxMp
         JwNkLbES4ivXBKjEK3kw9G9duZJS9nJaLW3Ll8PT8pN4SIE2Pcqu5/Rn939M1M2G9Kgj
         vwQZYSEPi42gWe6GfY5BRBVvV6OYwAQiKdo76mmkKj9ZXs6VUNxkRSZLhSs83r1OH2mu
         8VXzhx3eO46vAU33y3eWmB/abNLR/JNZpl/n0f/vMUD7+kFjzecF1jq9WEvScy5+VqgD
         O9mA==
X-Gm-Message-State: APjAAAXYf1MRJV3MXVK1wxrTBjVNYTAuVeJ1MIWOk6jwM8h2ipXOZuu0
        qOvXAkayyv9JWYMD1AP8eORkLADB
X-Google-Smtp-Source: APXvYqy6qZw6JHGBFpU+KlcH6fOg+tyn4+COWiRVNR+BcZeD6e1V46h8oUdPel+98NTPbIg/z+3SDw==
X-Received: by 2002:a81:b701:: with SMTP id v1mr20763825ywh.54.1577049635757;
        Sun, 22 Dec 2019 13:20:35 -0800 (PST)
Received: from mail-yb1-f177.google.com (mail-yb1-f177.google.com. [209.85.219.177])
        by smtp.gmail.com with ESMTPSA id q16sm7086310ywa.110.2019.12.22.13.20.34
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Dec 2019 13:20:34 -0800 (PST)
Received: by mail-yb1-f177.google.com with SMTP id w126so4483278yba.3
        for <netdev@vger.kernel.org>; Sun, 22 Dec 2019 13:20:34 -0800 (PST)
X-Received: by 2002:a25:dd04:: with SMTP id u4mr18686042ybg.419.1577049633799;
 Sun, 22 Dec 2019 13:20:33 -0800 (PST)
MIME-Version: 1.0
References: <20191219205410.5961-1-cforno12@linux.vnet.ibm.com> <20191219205410.5961-2-cforno12@linux.vnet.ibm.com>
In-Reply-To: <20191219205410.5961-2-cforno12@linux.vnet.ibm.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sun, 22 Dec 2019 16:19:56 -0500
X-Gmail-Original-Message-ID: <CA+FuTSeJ_3T5K3NrZnqcG6qadOHsoqKRt_ZMPM=fqUqJknDP_Q@mail.gmail.com>
Message-ID: <CA+FuTSeJ_3T5K3NrZnqcG6qadOHsoqKRt_ZMPM=fqUqJknDP_Q@mail.gmail.com>
Subject: Re: [PATCH, net-next, v3, 1/2] ethtool: Factored out similar ethtool
 link settings for virtual devices to core
To:     Cris Forno <cforno12@linux.vnet.ibm.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, haiyangz@microsoft.com,
        sthemmin@microsoft.com, sashal@kernel.org, tlfalcon@linux.ibm.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 19, 2019 at 3:54 PM Cris Forno <cforno12@linux.vnet.ibm.com> wrote:
>
> Three virtual devices (ibmveth, virtio_net, and netvsc) all have
> similar code to set/get link settings and validate ethtool command. To
> eliminate duplication of code, it is factored out into core/ethtool.c.
>
> Signed-off-by: Cris Forno <cforno12@linux.vnet.ibm.com>
> ---
>  include/linux/ethtool.h |  2 ++
>  net/core/ethtool.c      | 58 +++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 60 insertions(+)
>
> diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
> index 95991e43..1b0417b 100644
> --- a/include/linux/ethtool.h
> +++ b/include/linux/ethtool.h
> @@ -394,6 +394,8 @@ struct ethtool_ops {
>                                           struct ethtool_coalesce *);
>         int     (*set_per_queue_coalesce)(struct net_device *, u32,
>                                           struct ethtool_coalesce *);
> +       bool    (*virtdev_validate_link_ksettings)(const struct
> +                                                  ethtool_link_ksettings *);
>         int     (*get_link_ksettings)(struct net_device *,
>                                       struct ethtool_link_ksettings *);
>         int     (*set_link_ksettings)(struct net_device *,
> diff --git a/net/core/ethtool.c b/net/core/ethtool.c
> index cd9bc67..4091a94 100644
> --- a/net/core/ethtool.c
> +++ b/net/core/ethtool.c
> @@ -579,6 +579,32 @@ static int load_link_ksettings_from_user(struct ethtool_link_ksettings *to,
>         return 0;
>  }
>
> +/* Check if the user is trying to change anything besides speed/duplex */
> +static bool
> +ethtool_virtdev_validate_cmd(const struct ethtool_link_ksettings *cmd)

If called from other modules like drivers/net/virtio_net.ko, these
functions cannot be static, need a declaration in
include/linux/ethtool.h and an EXPORT_SYMBOL_GPL.

Also return type should be on the same line.

> +{
> +       struct ethtool_link_ksettings diff1 = *cmd;
> +       struct ethtool_link_ksettings diff2 = {};
> +
> +       /* cmd is always set so we need to clear it, validate the port type
> +        * and also without autonegotiation we can ignore advertising
> +        */
> +       diff1.base.speed = 0;
> +       diff2.base.port = PORT_OTHER;
> +       ethtool_link_ksettings_zero_link_mode(&diff1, advertising);
> +       diff1.base.duplex = 0;
> +       diff1.base.cmd = 0;
> +       diff1.base.link_mode_masks_nwords = 0;
> +
> +       return !memcmp(&diff1.base, &diff2.base, sizeof(diff1.base)) &&
> +               bitmap_empty(diff1.link_modes.supported,
> +                            __ETHTOOL_LINK_MODE_MASK_NBITS) &&
> +               bitmap_empty(diff1.link_modes.advertising,
> +                            __ETHTOOL_LINK_MODE_MASK_NBITS) &&
> +               bitmap_empty(diff1.link_modes.lp_advertising,
> +                            __ETHTOOL_LINK_MODE_MASK_NBITS);
> +}
> +
>  /* convert a kernel internal ethtool_link_ksettings to
>   * ethtool_link_usettings in user space. return 0 on success, errno on
>   * error.
> @@ -660,6 +686,17 @@ static int ethtool_get_link_ksettings(struct net_device *dev,
>         return store_link_ksettings_for_user(useraddr, &link_ksettings);
>  }
>
> +static int
> +ethtool_virtdev_get_link_ksettings(struct net_device *dev,
> +                                  struct ethtool_link_ksettings *cmd,
> +                                  u32 *speed, u8 *duplex)

No need to pass by reference, really. Indeed, the virtio_net caller
passes vi->speed and vi->duplex instead of &vi->speed and &vi->duplex.

More fundamentally, these three assignments are simple enough that I
don't think a helper actually simplifies anything here.



> +{
> +       cmd->base.speed = *speed;
> +       cmd->base.duplex = *duplex;
> +       cmd->base.port = PORT_OTHER;
> +       return 0;
> +}
> +
>  /* Update device ethtool_link_settings. */
>  static int ethtool_set_link_ksettings(struct net_device *dev,
>                                       void __user *useraddr)
> @@ -696,6 +733,27 @@ static int ethtool_set_link_ksettings(struct net_device *dev,
>         return dev->ethtool_ops->set_link_ksettings(dev, &link_ksettings);
>  }
>
> +static int
> +ethtool_virtdev_set_link_ksettings(struct net_device *dev,
> +                                  const struct ethtool_link_ksettings *cmd,
> +                                  u32 *dev_speed, u8 *dev_duplex)
> +{
> +       u32 speed;
> +       u8 duplex;
> +
> +       speed = cmd->base.speed;
> +       duplex = cmd->base.duplex;
> +       /* don't allow custom speed and duplex */
> +       if (!ethtool_validate_speed(speed) ||
> +           !ethtool_validate_duplex(duplex) ||
> +           !dev->ethtool_ops->virtdev_validate_link_ksettings(cmd))
> +               return -EINVAL;
> +       *dev_speed = speed;
> +       *dev_duplex = duplex;
> +
> +       return 0;
> +}
> +
>  /* Query device for its ethtool_cmd settings.
>   *
>   * Backward compatibility note: for compatibility with legacy ethtool, this is
> --
> 1.8.3.1
>
