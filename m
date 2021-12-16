Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A06C477604
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 16:33:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238540AbhLPPdB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 10:33:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235182AbhLPPdA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 10:33:00 -0500
Received: from mail-ua1-x930.google.com (mail-ua1-x930.google.com [IPv6:2607:f8b0:4864:20::930])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 872CDC061574
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 07:33:00 -0800 (PST)
Received: by mail-ua1-x930.google.com with SMTP id y23so6079789uay.7
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 07:33:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JmhBJ966IXvIbxeXrjk51TUKCLp9Oo/lfODsrxqr2RE=;
        b=VuQMd2yjFlPuo14MpPXNy/1cIa3A94jU9RKt1zXVxW7dWEExcKq8iuM+Ukz2kmDoxs
         fILe5WDxmmDF+zL+C5Fri4TlknlgykvWn/5cITbh47sh+bWyef4A9/+iOgkiyGy8K7Fy
         6v2ytSbptbAIu7hn+6WS7q0og82FDdONp59q384Y6C2e7eZZHNx/eLL1Y2ald5OM4lqk
         1lCWmR7sAnZ7Dk2PVnhUJiLutGSoLwMC4Rs96+c3BlSFVEa+u/460aXpbRfSQDP0g0qL
         Pf2JNCPN4rlJvE62NlgHWosdA7ZJaDrQov9KzpjuWaMudantc5qlDQKd3o0bY2+8kM+a
         E+8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JmhBJ966IXvIbxeXrjk51TUKCLp9Oo/lfODsrxqr2RE=;
        b=vq+dnAJZY9ZYPHbmjf/YLhb5pWgy5E2Ub8USd7sA8eg9QMF/TpVopKeBO6OjEOqxMB
         1TLlXz7D3FgK/b4o7ig83ST5q1m4hAg1pGWQRCkcr3YZ7RHG785/rCUu6oof7DdggwV+
         mALpYJAr+I/Cqyz2ThFS/CV2ZpIufFp/X40HQCbX5JFlf/I16i0ryDz+R+XFh4cyQRC9
         Fa006jN4yvHW5u5CmhKcdppRBZSdHVQCYI+thfwZVGrP3sSYBuCKFvY9sTVuvN2C/DzD
         3Vj9iQFGn+xVZT2XMQx7MCBUYN6XjJoYkayaKDHQMdHgNSUUXbhAOAXZx4OhuBnrBw1D
         mE5A==
X-Gm-Message-State: AOAM533YF9iWN3LDbgX+V3FdjX77OP4Qvidz0pe+cbKefl8XJmJNjUcK
        MNQnQ3wMc7Jr9Nlaq+Zy/DsOsJ0E5ZbezF5oXxwdvtAyREyP0w==
X-Google-Smtp-Source: ABdhPJxltS6ECbwThMAkW/A+VA6XbEQjoBMsy78rh8QP2Jah3vk5Bcw05JwYIWqp9DSGgr5eOgnBKFBorz1KvuS8gBE=
X-Received: by 2002:a05:6102:4192:: with SMTP id cd18mr5474168vsb.35.1639668779227;
 Thu, 16 Dec 2021 07:32:59 -0800 (PST)
MIME-Version: 1.0
References: <20211215201158.271976-1-kafai@fb.com>
In-Reply-To: <20211215201158.271976-1-kafai@fb.com>
From:   Willem de Bruijn <willemb@google.com>
Date:   Thu, 16 Dec 2021 10:32:23 -0500
Message-ID: <CA+FuTSdR0yPwXAZZjziGOeujJ_Ac19fX1DsqfRXX3Dsn1uFPAQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 net-next] net: Preserve skb delivery time during forward
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, kernel-team@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

h

On Wed, Dec 15, 2021 at 3:12 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> The skb->skb_mstamp_ns is used as the EDT (Earliest Department Time)
> in TCP.  skb->skb_mstamp_ns is a union member of skb->tstamp.
>
> When the skb traveling veth and being forwarded like below, the skb->tstamp
> is reset to 0 at multiple points.
>
>                                                                         (c: skb->tstamp = 0)
>                                                                          vv
> tcp-sender => veth@netns => veth@hostns(b: rx: skb->tstamp = real_clock) => fq@eth0
>                          ^^
>                         (a: skb->tstamp = 0)
>
> (a) veth@netns TX to veth@hostns:
>     skb->tstamp (mono clock) is a EDT and it is in future time.
>     Reset to 0 so that it won't skip the net_timestamp_check at the
>     RX side in (b).
> (b) RX (netif_rx) in veth@hostns:
>     net_timestamp_check puts a current time (real clock) in skb->tstamp.
> (c) veth@hostns forward to fq@eth0:
>     skb->tstamp is reset back to 0 again because fq is using
>     mono clock.
>
> This leads to an unstable TCP throughput issue described by Daniel in [0].
>
> We also have a use case that a bpf runs at ingress@veth@hostns
> to set EDT in skb->tstamp to limit the bandwidth usage
> of a particular netns.  This EDT currently also gets
> reset in step (c) as described above.
>
> Unlike RFC v1 trying to migrate rx tstamp to mono first,
> this patch is to preserve the EDT in skb->skb_mstamp_ns during forward.

Sucks we have to do this complex dance, because there is no room for
an skb->delivery_time.

> The idea is to temporarily store skb->skb_mstamp_ns during forward.
> skb_shinfo(skb)->hwtstamps is used as a temporary store and
> it is union-ed with the newly added "u64 tx_delivery_tstamp".
> hwtstamps should only be used when a packet is received or
> sent out of a hw device.
>
> During forward, skb->tstamp will be temporarily stored in
> skb_shinfo(skb)->tx_delivery_tstamp and a new bit
> (SKBTX_DELIVERY_TSTAMP) in skb_shinfo(skb)->tx_flags
> will also be set to tell tx_delivery_tstamp is in use.
> hwtstamps is accessed through the skb_hwtstamps() getter,
> so unlikely(tx_flags & SKBTX_DELIVERY_TSTAMP) can
> be tested in there and reset tx_delivery_tstamp to 0
> before hwtstamps is used.
>
> After moving the skb->tstamp to skb_shinfo(skb)->tx_delivery_tstamp,
> the skb->tstamp will still be reset to 0 during forward.  Thus,
> on the RX side (__netif_receive_skb_core), all existing code paths
> will still get the received time in real clock and will work as-is.
>
> When this skb finally xmit-ing out in __dev_queue_xmit(),
> it will check the SKBTX_DELIVERY_TSTAMP bit in skb_shinfo(skb)->tx_flags
> and restore the skb->tstamp from skb_shinfo(skb)->tx_delivery_tstamp
> if needed.  This bit test is done immediately after another existing
> bit test 'skb_shinfo(skb)->tx_flags & SKBTX_SCHED_TSTAMP'.
>
> Another bit SKBTX_DELIVERY_TSTAMP_ALLOW_FWD is added
> to skb_shinfo(skb)->tx_flags.  It is used to specify
> the skb->tstamp is set as a delivery time and can be
> temporarily stored during forward.  This bit is now set
> when EDT is stored in skb->skb_mstamp_ns in tcp_output.c
> This will avoid packet received from a NIC with real-clock
> in skb->tstamp being forwarded without reset.
>
> The change in af_packet.c is to avoid it calling skb_hwtstamps()
> which will reset the skb_shinfo(skb)->tx_delivery_tstamp.
> af_packet.c only wants to read the hwtstamps instead of
> storing a time in it, so a new read only getter skb_hwtstamps_ktime()
> is added.  Otherwise, a tcpdump will trigger this code path
> and unnecessarily reset the EDT stored in tx_delivery_tstamp.
>
> [Note: not all skb->tstamp=0 reset has been changed in this RFC yet]
>
> [0] (slide 22): https://linuxplumbersconf.org/event/11/contributions/953/attachments/867/1658/LPC_2021_BPF_Datapath_Extensions.pdf
>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---
>  include/linux/skbuff.h  | 52 ++++++++++++++++++++++++++++++++++++++++-
>  net/bridge/br_forward.c |  2 +-
>  net/core/dev.c          |  1 +
>  net/core/filter.c       |  6 ++---
>  net/core/skbuff.c       |  2 +-
>  net/ipv4/ip_forward.c   |  2 +-
>  net/ipv4/tcp_output.c   | 21 +++++++++++------
>  net/ipv6/ip6_output.c   |  2 +-
>  net/packet/af_packet.c  |  8 +++----
>  9 files changed, 77 insertions(+), 19 deletions(-)
>
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 6535294f6a48..9bf0a1e2a1bd 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -435,9 +435,17 @@ enum {
>         /* device driver is going to provide hardware time stamp */
>         SKBTX_IN_PROGRESS = 1 << 2,
>
> +       /* shinfo stores a future tx_delivery_tstamp instead of hwtstamps */
> +       SKBTX_DELIVERY_TSTAMP = 1 << 3,
> +
>         /* generate wifi status information (where possible) */
>         SKBTX_WIFI_STATUS = 1 << 4,
>
> +       /* skb->tstamp stored a future delivery time which
> +        * was set by a local sk and it can be fowarded.
> +        */
> +       SKBTX_DELIVERY_TSTAMP_ALLOW_FWD = 1 << 5,
> +
>         /* generate software time stamp when entering packet scheduling */
>         SKBTX_SCHED_TSTAMP = 1 << 6,
>  };
> @@ -530,7 +538,14 @@ struct skb_shared_info {
>         /* Warning: this field is not always filled in (UFO)! */
>         unsigned short  gso_segs;
>         struct sk_buff  *frag_list;
> -       struct skb_shared_hwtstamps hwtstamps;
> +       union {
> +               /* If SKBTX_DELIVERY_TSTAMP is set in tx_flags,
> +                * tx_delivery_tstamp is stored instead of
> +                * hwtstamps.
> +                */

Should we just encode the timebase and/or type { timestamp,
delivery_time } in th lower bits of the timestamp field? Its
resolution is higher than actual clock precision.

> +               struct skb_shared_hwtstamps hwtstamps;
> +               u64 tx_delivery_tstamp;
> +       };
>         unsigned int    gso_type;
>         u32             tskey;
>
> @@ -1463,9 +1478,44 @@ static inline unsigned int skb_end_offset(const struct sk_buff *skb)
>
>  static inline struct skb_shared_hwtstamps *skb_hwtstamps(struct sk_buff *skb)
>  {
> +       if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_DELIVERY_TSTAMP)) {
> +               skb_shinfo(skb)->tx_flags &= ~SKBTX_DELIVERY_TSTAMP;
> +               skb_shinfo(skb)->tx_delivery_tstamp = 0;
> +       }
>         return &skb_shinfo(skb)->hwtstamps;
>  }
>
> +/* Caller only needs to read the hwtstamps as ktime.
> + * To update hwtstamps,  HW device driver should call the writable
> + * version skb_hwtstamps() that returns a pointer.
> + */
> +static inline ktime_t skb_hwtstamps_ktime(const struct sk_buff *skb)
> +{
> +       if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_DELIVERY_TSTAMP))
> +               return 0;
> +       return skb_shinfo(skb)->hwtstamps.hwtstamp;
> +}
> +
> +static inline void skb_scrub_tstamp(struct sk_buff *skb)

skb_save_delivery_time?

is non-zero skb->tstamp test not sufficient, instead of
SKBTX_DELIVERY_TSTAMP_ALLOW_FWD.

It is if only called on the egress path. Is bpf on ingress the only
reason for this?

> +{
> +       if (skb_shinfo(skb)->tx_flags & SKBTX_DELIVERY_TSTAMP_ALLOW_FWD) {
> +               skb_shinfo(skb)->tx_delivery_tstamp = skb->tstamp;
> +               skb_shinfo(skb)->tx_flags |= SKBTX_DELIVERY_TSTAMP;
> +               skb_shinfo(skb)->tx_flags &= ~SKBTX_DELIVERY_TSTAMP_ALLOW_FWD;
> +       }

Is this only called when there are no clones/shares?

> +       skb->tstamp = 0;
> +}
> +
> +static inline void skb_restore_delivery_time(struct sk_buff *skb)
> +{
> +       if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_DELIVERY_TSTAMP)) {
> +               skb->tstamp = skb_shinfo(skb)->tx_delivery_tstamp;
> +               skb_shinfo(skb)->tx_delivery_tstamp = 0;
> +               skb_shinfo(skb)->tx_flags &= ~SKBTX_DELIVERY_TSTAMP;
> +               skb_shinfo(skb)->tx_flags |= SKBTX_DELIVERY_TSTAMP_ALLOW_FWD;
> +       }
> +}
> +
>  static inline struct ubuf_info *skb_zcopy(struct sk_buff *skb)
>  {
>         bool is_zcopy = skb && skb_shinfo(skb)->flags & SKBFL_ZEROCOPY_ENABLE;
> diff --git a/net/bridge/br_forward.c b/net/bridge/br_forward.c
> index ec646656dbf1..a3ba6195f2e3 100644
> --- a/net/bridge/br_forward.c
> +++ b/net/bridge/br_forward.c
> @@ -62,7 +62,7 @@ EXPORT_SYMBOL_GPL(br_dev_queue_push_xmit);
>
>  int br_forward_finish(struct net *net, struct sock *sk, struct sk_buff *skb)
>  {
> -       skb->tstamp = 0;
> +       skb_scrub_tstamp(skb);
>         return NF_HOOK(NFPROTO_BRIDGE, NF_BR_POST_ROUTING,
>                        net, sk, skb, NULL, skb->dev,
>                        br_dev_queue_push_xmit);
> diff --git a/net/core/dev.c b/net/core/dev.c
> index a855e41bbe39..e9e7de758cba 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
