Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 755F74CC877
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 23:00:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236707AbiCCWBB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 17:01:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236706AbiCCWA7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 17:00:59 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2277948334
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 14:00:12 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id u20so10908124lff.2
        for <netdev@vger.kernel.org>; Thu, 03 Mar 2022 14:00:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=B/wWxO70VsbRWbkBNYeysd8PjZWhNsydI8SGtYmrmUE=;
        b=OF7gv1/RXdd0nABLes0yv4StAtx74Mo5Ug13VUe6weTNGjuV4E4T0W88MozzXiY0fI
         lV5XfBh4ZEzkEsC5SyBGXljO7ih/HoeEWLy64bQkjayhyNPqC/2F0mw879ii0ot5SPNb
         Vdw8eSYN4EHalFhIyOtGmdEizcKf8TzwXSgUHUqKr8OOVjho0Eiy+TGi6RFNZ/C8sFGg
         /N4V1k9mpLgY/stpOyklIbZdTzDgs085xW+qoG8ZhZKRvr7Am8hUo79RB+HA0gkivTmY
         QZ1OfPZMOGC6/sZ+mD3K6hbPUUAOgLE7mOq9kBmM3wrDdEPGMMR2Rmma0s6sgKai/AuG
         Gk6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=B/wWxO70VsbRWbkBNYeysd8PjZWhNsydI8SGtYmrmUE=;
        b=H8PwGwc3kHDmxGD0Q7VlXYoNGiJWRuTtXeZ01ppZqiOE9D1N+YMAVWemdtzVktJMAe
         hQOH9CKlBZpyMTK66M2NLnpmTmmacqVj6DauG4/EfTFxdwIkKtohDn5P5C08ELW/Fe7H
         zeKAFm4ZP4B077JnzS7cBs/J+Zvg92Lyl21KWs1aqzSJM1dd4YDJYeOG597IsO9Y1u6q
         zA0yxm9Xt8kpXhnD9btCp7orj3GaMyOzlS9hcWq3Z/wpxQEYSgCCZN3of4q2A3599jA7
         dqHbB30PJ8q/+yf+g78eNNyTAxUfqs+K+D5EG8Af7GZQcxhU2t3KZWerZ4uNUttMas0i
         fEqQ==
X-Gm-Message-State: AOAM533ecfCWmSDpTcelIdanMi0dnk/R8d2JlLpKG9OnkCQjpODkQlL2
        dxGcbZgzJ4ncbX79jw80iTWcLnv2FZouYw3IkkuaYw==
X-Google-Smtp-Source: ABdhPJzwX9/pwl2KATvTK6EinGHCxhIoZPk7sG4YV/u64Zyckk8VI4lq/flRYvYh5sdUM6LasuIk7wDy/VD9cLVM45I=
X-Received: by 2002:a05:6512:3d90:b0:437:73cb:8e76 with SMTP id
 k16-20020a0565123d9000b0043773cb8e76mr22691498lfv.187.1646344810110; Thu, 03
 Mar 2022 14:00:10 -0800 (PST)
MIME-Version: 1.0
References: <20220303003034.1906898-1-jeffreyjilinux@gmail.com>
In-Reply-To: <20220303003034.1906898-1-jeffreyjilinux@gmail.com>
From:   Brian Vazquez <brianvv@google.com>
Date:   Thu, 3 Mar 2022 13:59:58 -0800
Message-ID: <CAMzD94SRmG12Zot+eZTDcSDaviceBqn6egCdGZBoy_cbJLa5xw@mail.gmail.com>
Subject: Re: [PATCH v2 net-next] net-core: add rx_otherhost_dropped counter
To:     Jeffrey Ji <jeffreyjilinux@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Antoine Tenart <atenart@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jeffreyji <jeffreyji@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

LGTM, thanks Jeffrey!

Reviewed-by: Brian Vazquez <brianvv@google.com>

On Wed, Mar 2, 2022 at 4:30 PM Jeffrey Ji <jeffreyjilinux@gmail.com> wrote:
>
> From: jeffreyji <jeffreyji@google.com>
>
> Increment rx_otherhost_dropped counter when packet dropped due to
> mismatched dest MAC addr.
>
> An example when this drop can occur is when manually crafting raw
> packets that will be consumed by a user space application via a tap
> device. For testing purposes local traffic was generated using trafgen
> for the client and netcat to start a server
>
> Tested: Created 2 netns, sent 1 packet using trafgen from 1 to the other
> with "{eth(daddr=$INCORRECT_MAC...}", verified that iproute2 showed the
> counter was incremented. (Also had to modify iproute2 to show the stat,
> additional patch for that coming next.)
>
> changelog:
>
> v2: add kdoc comment
>
> Signed-off-by: jeffreyji <jeffreyji@google.com>
> ---
>  include/linux/netdevice.h    | 3 +++
>  include/uapi/linux/if_link.h | 5 +++++
>  net/core/dev.c               | 2 ++
>  net/ipv4/ip_input.c          | 1 +
>  net/ipv6/ip6_input.c         | 1 +
>  5 files changed, 12 insertions(+)
>
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index c79ee2296296..e4073c38bd77 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -1741,6 +1741,8 @@ enum netdev_ml_priv_type {
>   *                     do not use this in drivers
>   *     @rx_nohandler:  nohandler dropped packets by core network on
>   *                     inactive devices, do not use this in drivers
> + *     @rx_otherhost_dropped:  Dropped packets due to mismatch in packet dest
> + *                             MAC address
>   *     @carrier_up_count:      Number of times the carrier has been up
>   *     @carrier_down_count:    Number of times the carrier has been down
>   *
> @@ -2025,6 +2027,7 @@ struct net_device {
>         atomic_long_t           rx_dropped;
>         atomic_long_t           tx_dropped;
>         atomic_long_t           rx_nohandler;
> +       atomic_long_t           rx_otherhost_dropped;
>
>         /* Stats to monitor link on/off, flapping */
>         atomic_t                carrier_up_count;
> diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
> index e315e53125f4..17e74385fca8 100644
> --- a/include/uapi/linux/if_link.h
> +++ b/include/uapi/linux/if_link.h
> @@ -211,6 +211,9 @@ struct rtnl_link_stats {
>   * @rx_nohandler: Number of packets received on the interface
>   *   but dropped by the networking stack because the device is
>   *   not designated to receive packets (e.g. backup link in a bond).
> + *
> + * @rx_otherhost_dropped: Number of packets dropped due to mismatch in
> + * packet's destination MAC address.
>   */
>  struct rtnl_link_stats64 {
>         __u64   rx_packets;
> @@ -243,6 +246,8 @@ struct rtnl_link_stats64 {
>         __u64   rx_compressed;
>         __u64   tx_compressed;
>         __u64   rx_nohandler;
> +
> +       __u64   rx_otherhost_dropped;
>  };
>
>  /* The struct should be in sync with struct ifmap */
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 2d6771075720..d039d8fdc16a 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -10037,6 +10037,8 @@ struct rtnl_link_stats64 *dev_get_stats(struct net_device *dev,
>         storage->rx_dropped += (unsigned long)atomic_long_read(&dev->rx_dropped);
>         storage->tx_dropped += (unsigned long)atomic_long_read(&dev->tx_dropped);
>         storage->rx_nohandler += (unsigned long)atomic_long_read(&dev->rx_nohandler);
> +       storage->rx_otherhost_dropped +=
> +               (unsigned long)atomic_long_read(&dev->rx_otherhost_dropped);
>         return storage;
>  }
>  EXPORT_SYMBOL(dev_get_stats);
> diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
> index d94f9f7e60c3..ef97b0a4c77f 100644
> --- a/net/ipv4/ip_input.c
> +++ b/net/ipv4/ip_input.c
> @@ -450,6 +450,7 @@ static struct sk_buff *ip_rcv_core(struct sk_buff *skb, struct net *net)
>          * that it receives, do not try to analyse it.
>          */
>         if (skb->pkt_type == PACKET_OTHERHOST) {
> +               atomic_long_inc(&skb->dev->rx_otherhost_dropped);
>                 drop_reason = SKB_DROP_REASON_OTHERHOST;
>                 goto drop;
>         }
> diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
> index d4b1e2c5aa76..3f0cbe126d82 100644
> --- a/net/ipv6/ip6_input.c
> +++ b/net/ipv6/ip6_input.c
> @@ -150,6 +150,7 @@ static struct sk_buff *ip6_rcv_core(struct sk_buff *skb, struct net_device *dev,
>         struct inet6_dev *idev;
>
>         if (skb->pkt_type == PACKET_OTHERHOST) {
> +               atomic_long_inc(&skb->dev->rx_otherhost_dropped);
>                 kfree_skb(skb);
>                 return NULL;
>         }
> --
> 2.35.1.616.g0bdcbb4464-goog
>
