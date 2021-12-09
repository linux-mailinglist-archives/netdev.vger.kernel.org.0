Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD5F46F748
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 00:12:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234176AbhLIXPd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 18:15:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232906AbhLIXPd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 18:15:33 -0500
Received: from mail-ua1-x92e.google.com (mail-ua1-x92e.google.com [IPv6:2607:f8b0:4864:20::92e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46CD5C061746;
        Thu,  9 Dec 2021 15:11:59 -0800 (PST)
Received: by mail-ua1-x92e.google.com with SMTP id 30so13718942uag.13;
        Thu, 09 Dec 2021 15:11:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=t90L3S7+4XwkWY1LJpVnSi33lZyuu8i51tQ571m7Njw=;
        b=piGwu7vXNbvUA6sR8UA2U2SmY7WUaLla9MmDuHN3pu+Hl6WUxLBqvxj5kEv3oFhOLF
         VlcgRhwrI+lznKqXpHvcFRNSyj0SAMVpNshJaLmMOUAMyAwuDzdpAOtmz3nvqALxq2qw
         uYF8uVYBN42gsmTKuEr8SrTyvR5nz4flZHlFCgKFnl24JmB4dPD0d4+oayn2S1LaKjDf
         z6rK/AYubobhdaW/jwHcLA4ipwOIu0mDdXY/Kuanv6DjR/GDcUvjSmCRgB7xMR1oXsvf
         cOLuxLYJxMGB5AuZOHnlT6A0fyP0bQkDlZ3vge5oC96513sAgy6LJ28DLSZdCjpeavSL
         HGzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t90L3S7+4XwkWY1LJpVnSi33lZyuu8i51tQ571m7Njw=;
        b=nUSTSouXmmxqZiCR65kbbAB5QJdApgfB6Zg4Emy0jiymtZy52kEpK1Nwf8ki6bfgtl
         uslHkTl3+eXPiZxDi2angD5isTlVy8AeWCI9o0SOPyUiB5BfnxvfOkXXg9IT8Ag08PL/
         rciAzInQp9/ZNPrCxlc6sIikdF1xMuLeu/D9CPAMF0Mnwtayi3Kpkx46zuC2v8lk7enU
         lxC2toXNR22PZTv908RPM5kLY9Dt4ZbDUJWM/JRGFTCjLPP+DzwOwZdvEC3h1rWiPKlU
         +jYfN4dY+qm5CkngKosu2t3h+D2zM978rUHnPdYqgejh6V4J3GmySDOdexGKZob47Bc3
         ya1A==
X-Gm-Message-State: AOAM532l3iPT2lq0JeElVnEMZDmmGWRV88Ns7pXylf1HmsUUsF61cXh+
        t8svktkHcZnfJ6dFr8dUQ/xUXT7Ofh2wIXZb0Wo=
X-Google-Smtp-Source: ABdhPJy2uSaUjnYW/I+atopTiFJa6KCNT4olqPh3mUMm9EYylXZ5MFuQhSdWlhqERGQEva0ectYB+y+n8GS7aqg1oCw=
X-Received: by 2002:a05:6102:1614:: with SMTP id cu20mr12260459vsb.50.1639091518371;
 Thu, 09 Dec 2021 15:11:58 -0800 (PST)
MIME-Version: 1.0
References: <20211208040414.151960-1-xiayu.zhang@mediatek.com>
In-Reply-To: <20211208040414.151960-1-xiayu.zhang@mediatek.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Fri, 10 Dec 2021 02:11:47 +0300
Message-ID: <CAHNKnsRZpYsiWORgAejYwQqP5P=PSt-V7_i73G1yfh-UR2zFjw@mail.gmail.com>
Subject: Re: [PATCH] Add Multiple TX/RX Queues Support for WWAN Network Device
To:     xiayu.zhang@mediatek.com
Cc:     Loic Poulain <loic.poulain@linaro.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        netdev@vger.kernel.org, open list <linux-kernel@vger.kernel.org>,
        haijun.liu@mediatek.com, zhaoping.shu@mediatek.com,
        hw.he@mediatek.com, srv_heupstream@mediatek.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 8, 2021 at 7:04 AM <xiayu.zhang@mediatek.com> wrote:
> This patch adds 2 callback functions get_num_tx_queues() and
> get_num_rx_queues() to let WWAN network device driver customize its own
> TX and RX queue numbers. It gives WWAN driver a chance to implement its
> own software strategies, such as TX Qos.
>
> Currently, if WWAN device driver creates default bearer interface when
> calling wwan_register_ops(), there will be only 1 TX queue and 1 RX queue
> for the WWAN network device. In this case, driver is not able to enlarge
> the queue numbers by calling netif_set_real_num_tx_queues() or
> netif_set_real_num_rx_queues() to take advantage of the network device's
> capability of supporting multiple TX/RX queues.
>
> As for additional interfaces of secondary bearers, if userspace service
> doesn't specify the num_tx_queues or num_rx_queues in netlink message or
> iproute2 command, there also will be only 1 TX queue and 1 RX queue for
> each additional interface. If userspace service specifies the num_tx_queues
> and num_rx_queues, however, these numbers could be not able to match the
> capabilities of network device.
>
> Besides, userspace service is hard to learn every WWAN network device's
> TX/RX queue numbers.
>
> In order to let WWAN driver determine the queue numbers, this patch adds
> below callback functions in wwan_ops:
>     struct wwan_ops {
>         unsigned int priv_size;
>         ...
>         unsigned int (*get_num_tx_queues)(unsigned int hint_num);
>         unsigned int (*get_num_rx_queues)(unsigned int hint_num);
>     };
>
> WWAN subsystem uses the input parameters num_tx_queues and num_rx_queues of
> wwan_rtnl_alloc() as hint values, and passes the 2 values to the two
> callback functions. WWAN device driver should determine the actual numbers
> of network device's TX and RX queues according to the hint value and
> device's capabilities.

As already stated by Jakub, it is hard to understand a new API
suitability without an API user. I will try to describe possible
issues with the proposed API as far as I understand its usage and
possible solutions. Correct me if I am wrong.

There are actually two tasks related to the queues number selection:
1) default queues number selection if the userspace provides no
information about a wishful number of queues;
2) rejecting the new netdev (bearer) creation if a requested number of
queues seems to be invalid.

Your proposal tries to solve both of these tasks with a single hook
that silently increases or decreases the requested number of queues.
This is creative, but seems contradictory to regular RTNL behavior.
RTNL usually selects a correct default value if no value was
requested, or performs what is requested, or explicitly rejects
requested configuration.

You could handle an invalid queues configuration in the .newlink
callback. This callback is even able to return a string error
representation via the extack argument.

As for the default queues number selection it seems better to
implement the RTNL .get_num_rx_queues callback in the WWAN core and
call optional driver specific callback through it. Something like
this:

static unsigned int wwan_rtnl_get_num_tx_queues(struct nlattr *tb[])
{
    const char *devname = nla_data(tb[IFLA_PARENT_DEV_NAME]);
    struct wwan_device *wwandev = wwan_dev_get_by_name(devname);

    return wwandev && wwandev->ops && wwandev->ops->get_num_tx_queues ?
              wwandev->ops->get_num_tx_queues() : 1;
}

static struct rtnl_link_ops wwan_rtnl_link_ops __read_mostly = {
    ...
    .get_num_tx_queues = wwan_rtnl_get_num_tx_queues,
};

This way the default queues number selection will be implemented in a
less surprising way.

But to be able to implement this we need to modify the RTNL ops
.get_num_tx_queues/.get_num_rx_queues callback definitions to make
them able to accept the RTM_NEWLINK message attributes. This is not
difficult since the callbacks are implemented only by a few virtual
devices, but can be assumed too intrusive to implement a one feature
for a single subsystem.

> Signed-off-by: Xiayu Zhang <Xiayu.Zhang@mediatek.com>
> ---
>  drivers/net/wwan/wwan_core.c | 25 ++++++++++++++++++++++++-
>  include/linux/wwan.h         |  6 ++++++
>  2 files changed, 30 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wwan/wwan_core.c b/drivers/net/wwan/wwan_core.c
> index d293ab688044..00095c6987be 100644
> --- a/drivers/net/wwan/wwan_core.c
> +++ b/drivers/net/wwan/wwan_core.c
> @@ -823,6 +823,7 @@ static struct net_device *wwan_rtnl_alloc(struct nlattr *tb[],
>         struct wwan_device *wwandev = wwan_dev_get_by_name(devname);
>         struct net_device *dev;
>         unsigned int priv_size;
> +       unsigned int num_txqs, num_rxqs;
>
>         if (IS_ERR(wwandev))
>                 return ERR_CAST(wwandev);
> @@ -833,9 +834,31 @@ static struct net_device *wwan_rtnl_alloc(struct nlattr *tb[],
>                 goto out;
>         }
>
> +       /* let wwan device driver determine TX queue number if it wants */
> +       if (wwandev->ops->get_num_tx_queues) {
> +               num_txqs = wwandev->ops->get_num_tx_queues(num_tx_queues);
> +               if (num_txqs < 1 || num_txqs > 4096) {
> +                       dev = ERR_PTR(-EINVAL);
> +                       goto out;
> +               }
> +       } else {
> +               num_txqs = num_tx_queues;
> +       }
> +
> +       /* let wwan device driver determine RX queue number if it wants */
> +       if (wwandev->ops->get_num_rx_queues) {
> +               num_rxqs = wwandev->ops->get_num_rx_queues(num_rx_queues);
> +               if (num_rxqs < 1 || num_rxqs > 4096) {
> +                       dev = ERR_PTR(-EINVAL);
> +                       goto out;
> +               }
> +       } else {
> +               num_rxqs = num_rx_queues;
> +       }
> +
>         priv_size = sizeof(struct wwan_netdev_priv) + wwandev->ops->priv_size;
>         dev = alloc_netdev_mqs(priv_size, ifname, name_assign_type,
> -                              wwandev->ops->setup, num_tx_queues, num_rx_queues);
> +                              wwandev->ops->setup, num_txqs, num_rxqs);
>
>         if (dev) {
>                 SET_NETDEV_DEV(dev, &wwandev->dev);
> diff --git a/include/linux/wwan.h b/include/linux/wwan.h
> index 9fac819f92e3..69c0af7ab6af 100644
> --- a/include/linux/wwan.h
> +++ b/include/linux/wwan.h
> @@ -156,6 +156,10 @@ static inline void *wwan_netdev_drvpriv(struct net_device *dev)
>   * @setup: set up a new netdev
>   * @newlink: register the new netdev
>   * @dellink: remove the given netdev
> + * @get_num_tx_queues: determine number of transmit queues
> + *                     to create when creating a new device.
> + * @get_num_rx_queues: determine number of receive queues
> + *                     to create when creating a new device.
>   */
>  struct wwan_ops {
>         unsigned int priv_size;
> @@ -164,6 +168,8 @@ struct wwan_ops {
>                        u32 if_id, struct netlink_ext_ack *extack);
>         void (*dellink)(void *ctxt, struct net_device *dev,
>                         struct list_head *head);
> +       unsigned int (*get_num_tx_queues)(unsigned int hint_num);
> +       unsigned int (*get_num_rx_queues)(unsigned int hint_num);
>  };
>
>  int wwan_register_ops(struct device *parent, const struct wwan_ops *ops,

-- 
Sergey
