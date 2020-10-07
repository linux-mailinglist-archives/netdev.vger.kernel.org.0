Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACA4E285656
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 03:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbgJGBfD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 21:35:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725996AbgJGBfD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 21:35:03 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76367C061755
        for <netdev@vger.kernel.org>; Tue,  6 Oct 2020 18:35:03 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id o18so851609ill.2
        for <netdev@vger.kernel.org>; Tue, 06 Oct 2020 18:35:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WbAQh8C0h6y8G0tZ7rEd84Fjo4zyCxaOwhMAGhjzwXU=;
        b=Nv308T7r2Hb3GRsrKeOMfoOGlyaH44UgJy/AliRW6CHSCJWj+a3mvUgBZ6xRAJNO90
         Hr5QgPgM0X6Tz65fTVNEMRNfw0B8H2G25Bie1gRjhicVPheFN5cdZDGchKTTerlLK8Ui
         otleHAcfBHq/aqcCz+qmgdRwf7S9/IWvN5HzmxPal2t2MeDpY4ul8I4WLsyQzzIDuWHx
         xq23nrL4ZwOy+nRS2a0ME3DZBElhODKvcl1KtkalDZDzYLYQmw7Mlt+og3UBiokDsFz8
         9DE8sjp/tFNQBuw5kuI2GSmKDqnRme/iocsvHyX7hMz48EOmf0iEjbR4RjLOKbQtUcBR
         4tdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WbAQh8C0h6y8G0tZ7rEd84Fjo4zyCxaOwhMAGhjzwXU=;
        b=fIz7UztOxXujzsCm85xCf7IPnspn2W4fu9ouDFawy21Rd6GHNlYaO/Pm3EsrL/ry7O
         vBM28t05Pr9XGX94saKFnn0q7YvhcGTj2AX7mahwNSHjCSZIX36TKURUfYPwLIFXhQoc
         L20C6D0pOse6Rg1rknzaz/mOW/HZgLvJNazzvp4wE/3xTu+TOGtC5acIcw/3FucrTaVP
         nTWCquwmJTDzK1xQ3YvChRsNaZj3TZGlrtsR8s/eZ6hpqCemSMtANZkGAwfavwBUygO2
         ms5cm2RTI5JzpfBE+6A94jXUy/SxRDA5pmHsj9RWbpt89Rt68xogCoBNDyo+DbjjUyd5
         v0gA==
X-Gm-Message-State: AOAM531SciSD2zz1wmNyXrL+DEzw8IjiyoODpx/IVJvvwQKExVovv9o5
        i7e0XWGsvdyiuUuwXfQ3H1BmP4uQJoaV7dnAnf0Z3jfFuUk=
X-Google-Smtp-Source: ABdhPJyalYBcevNEBx7J1p9X7/pq6jIdi79SC7hofy8N7GE6pTXo6QdA4Cco9PAUwdwEJMRqjvnlks4vnjraxvlgfSU=
X-Received: by 2002:a92:ccc2:: with SMTP id u2mr761898ilq.278.1602034502395;
 Tue, 06 Oct 2020 18:35:02 -0700 (PDT)
MIME-Version: 1.0
References: <160200013701.719143.12665708317930272219.stgit@firesoul> <160200017655.719143.17344942455389603664.stgit@firesoul>
In-Reply-To: <160200017655.719143.17344942455389603664.stgit@firesoul>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date:   Tue, 6 Oct 2020 18:34:50 -0700
Message-ID: <CANP3RGfeh=a=h2C4voLtfWtvKG7ezaPb7y6r0W1eOjA2ZoNHaw@mail.gmail.com>
Subject: Re: [PATCH bpf-next V1 2/6] bpf: bpf_fib_lookup return MTU value as
 output when looked up
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     bpf <bpf@vger.kernel.org>, Linux NetDev <netdev@vger.kernel.org>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Shaun Crampton <shaun@tigera.io>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Marek Majkowski <marek@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 6, 2020 at 9:03 AM Jesper Dangaard Brouer <brouer@redhat.com> wrote:
>
> The BPF-helpers for FIB lookup (bpf_xdp_fib_lookup and bpf_skb_fib_lookup)
> can perform MTU check and return BPF_FIB_LKUP_RET_FRAG_NEEDED.  The BPF-prog
> don't know the MTU value that caused this rejection.
>
> If the BPF-prog wants to implement PMTU (Path MTU Discovery) (rfc1191) it
> need to know this MTU value for the ICMP packet.
>
> Patch change lookup and result struct bpf_fib_lookup, to contain this MTU
> value as output via a union with 'tot_len' as this is the value used for
> the MTU lookup.
>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>  include/uapi/linux/bpf.h |   11 +++++++++--
>  net/core/filter.c        |   17 ++++++++++++-----
>  2 files changed, 21 insertions(+), 7 deletions(-)
>
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index c446394135be..50ce65e37b16 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -2216,6 +2216,9 @@ union bpf_attr {
>   *             * > 0 one of **BPF_FIB_LKUP_RET_** codes explaining why the
>   *               packet is not forwarded or needs assist from full stack
>   *
> + *             If lookup fails with BPF_FIB_LKUP_RET_FRAG_NEEDED, then the MTU
> + *             was exceeded and result params->mtu contains the MTU.
> + *
>   * long bpf_sock_hash_update(struct bpf_sock_ops *skops, struct bpf_map *map, void *key, u64 flags)
>   *     Description
>   *             Add an entry to, or update a sockhash *map* referencing sockets.
> @@ -4844,9 +4847,13 @@ struct bpf_fib_lookup {
>         __be16  sport;
>         __be16  dport;
>
> -       /* total length of packet from network header - used for MTU check */
> -       __u16   tot_len;
> +       union { /* used for MTU check */
> +               /* input to lookup */
> +               __u16   tot_len; /* total length of packet from network hdr */
>
> +               /* output: MTU value (if requested check_mtu) */
> +               __u16   mtu;
> +       };
>         /* input: L3 device index for lookup
>          * output: device index from FIB lookup
>          */
> diff --git a/net/core/filter.c b/net/core/filter.c
> index fed239e77bdc..d84723f347c0 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -5185,13 +5185,14 @@ static const struct bpf_func_proto bpf_skb_get_xfrm_state_proto = {
>  #if IS_ENABLED(CONFIG_INET) || IS_ENABLED(CONFIG_IPV6)
>  static int bpf_fib_set_fwd_params(struct bpf_fib_lookup *params,
>                                   const struct neighbour *neigh,
> -                                 const struct net_device *dev)
> +                                 const struct net_device *dev, u32 mtu)
>  {
>         memcpy(params->dmac, neigh->ha, ETH_ALEN);
>         memcpy(params->smac, dev->dev_addr, ETH_ALEN);
>         params->h_vlan_TCI = 0;
>         params->h_vlan_proto = 0;
>         params->ifindex = dev->ifindex;
> +       params->mtu = mtu;
>
>         return 0;
>  }
> @@ -5275,8 +5276,10 @@ static int bpf_ipv4_fib_lookup(struct net *net, struct bpf_fib_lookup *params,
>
>         if (check_mtu) {
>                 mtu = ip_mtu_from_fib_result(&res, params->ipv4_dst);
> -               if (params->tot_len > mtu)
> +               if (params->tot_len > mtu) {
> +                       params->mtu = mtu; /* union with tot_len */
>                         return BPF_FIB_LKUP_RET_FRAG_NEEDED;
> +               }
>         }
>
>         nhc = res.nhc;
> @@ -5309,7 +5312,7 @@ static int bpf_ipv4_fib_lookup(struct net *net, struct bpf_fib_lookup *params,
>         if (!neigh)
>                 return BPF_FIB_LKUP_RET_NO_NEIGH;
>
> -       return bpf_fib_set_fwd_params(params, neigh, dev);
> +       return bpf_fib_set_fwd_params(params, neigh, dev, mtu);
>  }
>  #endif
>
> @@ -5401,8 +5404,10 @@ static int bpf_ipv6_fib_lookup(struct net *net, struct bpf_fib_lookup *params,
>
>         if (check_mtu) {
>                 mtu = ipv6_stub->ip6_mtu_from_fib6(&res, dst, src);
> -               if (params->tot_len > mtu)
> +               if (params->tot_len > mtu) {
> +                       params->mtu = mtu; /* union with tot_len */
>                         return BPF_FIB_LKUP_RET_FRAG_NEEDED;
> +               }
>         }
>
>         if (res.nh->fib_nh_lws)
> @@ -5421,7 +5426,7 @@ static int bpf_ipv6_fib_lookup(struct net *net, struct bpf_fib_lookup *params,
>         if (!neigh)
>                 return BPF_FIB_LKUP_RET_NO_NEIGH;
>
> -       return bpf_fib_set_fwd_params(params, neigh, dev);
> +       return bpf_fib_set_fwd_params(params, neigh, dev, mtu);
>  }
>  #endif
>
> @@ -5490,6 +5495,8 @@ BPF_CALL_4(bpf_skb_fib_lookup, struct sk_buff *, skb,
>                 dev = dev_get_by_index_rcu(net, params->ifindex);
>                 if (!is_skb_forwardable(dev, skb))
>                         rc = BPF_FIB_LKUP_RET_FRAG_NEEDED;
> +
> +               params->mtu = dev->mtu; /* union with tot_len */
>         }
>
>         return rc;
>
>

It would be beneficial to be able to fetch the route advmss, initcwnd,
etc as well...
But I take it the struct can't be extended?
