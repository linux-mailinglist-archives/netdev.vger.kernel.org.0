Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A8A44C8F14
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 16:28:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233163AbiCAP3Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 10:29:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230369AbiCAP3Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 10:29:25 -0500
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F8DF13F58
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 07:28:43 -0800 (PST)
Received: by mail-lj1-x22c.google.com with SMTP id 29so22295129ljv.10
        for <netdev@vger.kernel.org>; Tue, 01 Mar 2022 07:28:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zT4QMG8d8ebgFHX32WWkf7Z5v9Q81C3atFiBsRon+LE=;
        b=DJ5q5nwEABjmE6en9CaJDJUXyfHwIzfOMRLeQ8Z44R1SDvHlSAM3pWMWNG0X+V2/2Y
         yZK0q1Qi8RV3rGiyRdAxqttttYziAk9rYCK1VPcrUmicJcERUJeILVTqiItwrHHbv0zO
         u7nlk33F0a7S7boyLEZcN8WZwQQCTtTSIPArvdfVDK2mN8Vg8HfT8/M7t6LpADOEJMA8
         qo10Td70BoiiyAn6co/F3szLyfCutgo687lyMrhJ2NzyZ4HNTCdz65HWNqOQc2HpPM3T
         hi9UP23d9V0j9Jvf6NDzwhiydSon//MCg0FPCnI3VpNzbcxmC8E0tNe14kma655lvk9l
         vo/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zT4QMG8d8ebgFHX32WWkf7Z5v9Q81C3atFiBsRon+LE=;
        b=IkSUusNDZrCAKb7Km7Sm6ofMvAc04237jpPr3/esyYuoHeSGpVPP5JLmnQbb6DOlkZ
         yH5h+Ar3vs5E30dM9qufOUxbgCLY5rKlUYKbHrpipS/eyOnRe5832gfNqg+mZMNMNpIh
         T6k/TYVda7Ow4QF3RiROkm/WlfrJ+0BG4Rs+1DDLykm//1SI1lQze5aVOnXa/bxRH83R
         aZlPWxbd+00r0aJfCdbI2Q7AABN2jL7cq8LIoTOxAIj8U/BScEpxi681rlA/8TgXFh4i
         QTJnslBGBmFYCnMaUVccM3W3mBSZ9Ho+p6c/eJFk9X6agosZbuL7fQmMmWCp9jI7JgwL
         FZEg==
X-Gm-Message-State: AOAM530IDgo9/ckA2Ggp+driiJvPMC+rhVOnKThcqVXgspUh9jUdaXk4
        CdocXMQSgyUfUYOtyc7SvNGA1N8ictI6Vykeypmq+w==
X-Google-Smtp-Source: ABdhPJxx+0PTf+OXSkf7zNbrfh2Jz0fFVf/mjV88ypzAD66qYLrZKUA5CDcMyV4KAYPbbk2OZl+q1axweAXkWVEW/Rs=
X-Received: by 2002:a2e:b52f:0:b0:23e:2fe6:af10 with SMTP id
 z15-20020a2eb52f000000b0023e2fe6af10mr16966817ljm.46.1646148520398; Tue, 01
 Mar 2022 07:28:40 -0800 (PST)
MIME-Version: 1.0
References: <20220301001153.1608374-1-jeffreyjilinux@gmail.com>
In-Reply-To: <20220301001153.1608374-1-jeffreyjilinux@gmail.com>
From:   Brian Vazquez <brianvv@google.com>
Date:   Tue, 1 Mar 2022 07:28:28 -0800
Message-ID: <CAMzD94Re5jakJ=hMNgiPBh-B-a8DGrCmNMA98r8-Gw8413FjKQ@mail.gmail.com>
Subject: Re: [PATCH net-next] net-core: add rx_otherhost_dropped counter
To:     Jeffrey Ji <jeffreyjilinux@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
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

Hey Jeffrey,

Looking at it in patchwork
(https://patchwork.kernel.org/project/netdevbpf/patch/20220301001153.1608374-1-jeffreyjilinux@gmail.com/),
it is complaining about kdoc.

Seems that you're missing the kdoc comment about rx_otherhost_dropped
in the include/linux/netdevice.h file, other than that LGTM.

On Mon, Feb 28, 2022 at 4:12 PM Jeffrey Ji <jeffreyjilinux@gmail.com> wrote:
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
> Signed-off-by: jeffreyji <jeffreyji@google.com>
> ---
>  include/linux/netdevice.h    | 1 +
>  include/uapi/linux/if_link.h | 5 +++++
>  net/core/dev.c               | 2 ++
>  net/ipv4/ip_input.c          | 1 +
>  net/ipv6/ip6_input.c         | 1 +
>  5 files changed, 10 insertions(+)
>
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index c79ee2296296..96c2030f4c1f 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -2025,6 +2025,7 @@ struct net_device {
>         atomic_long_t           rx_dropped;
>         atomic_long_t           tx_dropped;
>         atomic_long_t           rx_nohandler;
> +       atomic_long_t           rx_otherhost_dropped;
>
>         /* Stats to monitor link on/off, flapping */
>         atomic_t                carrier_up_count;
> diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
> index be09d2ad4b5d..834382317889 100644
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
> 2.35.1.574.g5d30c73bfb-goog
>
