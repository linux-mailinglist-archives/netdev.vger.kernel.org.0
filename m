Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD8CF3CBC07
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 20:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232172AbhGPSt0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 14:49:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231918AbhGPStY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 14:49:24 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E8B6C06175F
        for <netdev@vger.kernel.org>; Fri, 16 Jul 2021 11:46:28 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id f10-20020a05600c4e8ab029023e8d74d693so1420532wmq.3
        for <netdev@vger.kernel.org>; Fri, 16 Jul 2021 11:46:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Npf5cLlY6KTjQ9swpv1f+uS4uOMu45apumgk9FOQpP8=;
        b=sFCBoZO1faE/vbaPeDKkBm0Nm/2tFY1MZfYT0ZjHh2rJOG8w0yz49To0mkCFz2n88I
         Vf/bnALinPkM3u51AmZ8tr1HMcavUin2o/YEeFFQq4kluIcC/vLISxCwR9QWbUFqw3mw
         phP4ohmyt+fUACvyNlW+z/V6TVT01kjBn7UwlFf+r9qwxgEKt6o7bMLsWNujl5EujFsb
         Suq0sbnXul8IKcQm9YIH0XqmIoX+tubT0HVLfTHp9Jx0p4c9E0hLiCT0Y4tAQTUb6ug2
         D2qxOtBRObrkykDsAI9iB6Y3d1p7bBo3JWHvj6sR4im4DM2qIwh14Pq4qSEFRlsRkBhO
         +oAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Npf5cLlY6KTjQ9swpv1f+uS4uOMu45apumgk9FOQpP8=;
        b=gterAhnKYD162UYZ0GgicJ48rvrL5NMyflzJORVaDIVBr2HAvs75HL13eMRZPWErai
         pv4hga4VdOONq+4y/Ko3Cu1a2poFH5ni7PhfJcYkofUyIfdePuNoII8vET7Ktb6kKL4z
         Fdm+AGdCxO+kMM7t0NKOJAOakZ2Rkxd7FhSfP8vJ8MSsKIlnhhDCSA6fYG9+tKtbstut
         15i4dG0kt/IUpB5M4IgpB/mI9FH2fUm/ZPCM/IpvU+HPacRkGYOBo+BBUxEXdkvzjn6H
         VLEajmBMzfqW+3RClrTjtmbhONLSpDB3jAlpPSEZR0bFmWWjkm4hBYq7UBtQdi7p41H0
         9KRQ==
X-Gm-Message-State: AOAM530sLtA7rga2nq3iV7h781gxYSSm95+LLWQyEVJIg5w9xET1xn+D
        QM1eg3aHzpy7GcULqB7yjyNX5CR31iyvGroPCyk=
X-Google-Smtp-Source: ABdhPJyUE+yomToFo5cLM52QqCQAe32DpiCDRz+VE/zdSIe2uIOcb/aIMAL9M7SDzRJP4auC+Fwsd9SJSkXksUhSj3A=
X-Received: by 2002:a05:600c:358d:: with SMTP id p13mr18746946wmq.12.1626461186659;
 Fri, 16 Jul 2021 11:46:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210716105417.7938-1-vfedorenko@novek.ru> <20210716105417.7938-2-vfedorenko@novek.ru>
In-Reply-To: <20210716105417.7938-2-vfedorenko@novek.ru>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Fri, 16 Jul 2021 14:46:16 -0400
Message-ID: <CADvbK_eJEY_-4sJM-up_L2G47HqdV2q3XSkexYSm9vDmpmD9pA@mail.gmail.com>
Subject: Re: [PATCH net v2 1/2] udp: check encap socket in __udp_lib_err_encap
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     David Ahern <dsahern@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        network dev <netdev@vger.kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 16, 2021 at 6:54 AM Vadim Fedorenko <vfedorenko@novek.ru> wrote:
>
> Commit d26796ae5894 ("udp: check udp sock encap_type in __udp_lib_err")
> added checks for encapsulated sockets but it broke cases when there is
> no implementation of encap_err_lookup for encapsulation, i.e. ESP in
> UDP encapsulation. Fix it by calling encap_err_lookup only if socket
> implements this method otherwise treat it as legal socket.
>
> Fixes: d26796ae5894 ("udp: check udp sock encap_type in __udp_lib_err")
> Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
> ---
>  net/ipv4/udp.c | 23 +++++++++++++++++------
>  net/ipv6/udp.c | 23 +++++++++++++++++------
>  2 files changed, 34 insertions(+), 12 deletions(-)
>
> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> index 62cd4cd52e84..963275b94f00 100644
> --- a/net/ipv4/udp.c
> +++ b/net/ipv4/udp.c
> @@ -645,10 +645,12 @@ static struct sock *__udp4_lib_err_encap(struct net *net,
>                                          const struct iphdr *iph,
>                                          struct udphdr *uh,
>                                          struct udp_table *udptable,
> +                                        struct sock *sk,
>                                          struct sk_buff *skb, u32 info)
>  {
> +       int (*lookup)(struct sock *sk, struct sk_buff *skb);
>         int network_offset, transport_offset;
> -       struct sock *sk;
> +       struct udp_sock *up;
>
>         network_offset = skb_network_offset(skb);
>         transport_offset = skb_transport_offset(skb);
> @@ -659,12 +661,19 @@ static struct sock *__udp4_lib_err_encap(struct net *net,
>         /* Transport header needs to point to the UDP header */
>         skb_set_transport_header(skb, iph->ihl << 2);
>
> +       if (sk) {
> +               up = udp_sk(sk);
> +
> +               lookup = READ_ONCE(up->encap_err_lookup);
> +               if (!lookup || !lookup(sk, skb))
> +                       goto out;
> +       }
> +
Currently SCTP reuses lookup() to handle some of ICMP error packets by itself
in lookup(), for these packets it will return 1, in which case we should
set sk = NULL, and not let udp4_lib_err() handle these packets again.

Can you change this part to this below?

+       if (sk) {
+               up = udp_sk(sk);
+
+               lookup = READ_ONCE(up->encap_err_lookup);
+               if (lookup && lookup(sk, skb))
+                       sk = NULL;
+
+               goto out;
+       }
+

thanks.

>         sk = __udp4_lib_lookup(net, iph->daddr, uh->source,
>                                iph->saddr, uh->dest, skb->dev->ifindex, 0,
>                                udptable, NULL);
>         if (sk) {
> -               int (*lookup)(struct sock *sk, struct sk_buff *skb);
> -               struct udp_sock *up = udp_sk(sk);
> +               up = udp_sk(sk);
>
>                 lookup = READ_ONCE(up->encap_err_lookup);
>                 if (!lookup || lookup(sk, skb))
> @@ -674,6 +683,7 @@ static struct sock *__udp4_lib_err_encap(struct net *net,
>         if (!sk)
>                 sk = ERR_PTR(__udp4_lib_err_encap_no_sk(skb, info));
>
> +out:
>         skb_set_transport_header(skb, transport_offset);
>         skb_set_network_header(skb, network_offset);
>
> @@ -707,15 +717,16 @@ int __udp4_lib_err(struct sk_buff *skb, u32 info, struct udp_table *udptable)
>         sk = __udp4_lib_lookup(net, iph->daddr, uh->dest,
>                                iph->saddr, uh->source, skb->dev->ifindex,
>                                inet_sdif(skb), udptable, NULL);
> +
>         if (!sk || udp_sk(sk)->encap_type) {
>                 /* No socket for error: try tunnels before discarding */
> -               sk = ERR_PTR(-ENOENT);
>                 if (static_branch_unlikely(&udp_encap_needed_key)) {
> -                       sk = __udp4_lib_err_encap(net, iph, uh, udptable, skb,
> +                       sk = __udp4_lib_err_encap(net, iph, uh, udptable, sk, skb,
>                                                   info);
>                         if (!sk)
>                                 return 0;
> -               }
> +               } else
> +                       sk = ERR_PTR(-ENOENT);
>
>                 if (IS_ERR(sk)) {
>                         __ICMP_INC_STATS(net, ICMP_MIB_INERRORS);
> diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
> index 0cc7ba531b34..0210ec93d21d 100644
> --- a/net/ipv6/udp.c
> +++ b/net/ipv6/udp.c
> @@ -502,12 +502,14 @@ static struct sock *__udp6_lib_err_encap(struct net *net,
>                                          const struct ipv6hdr *hdr, int offset,
>                                          struct udphdr *uh,
>                                          struct udp_table *udptable,
> +                                        struct sock *sk,
>                                          struct sk_buff *skb,
>                                          struct inet6_skb_parm *opt,
>                                          u8 type, u8 code, __be32 info)
>  {
> +       int (*lookup)(struct sock *sk, struct sk_buff *skb);
>         int network_offset, transport_offset;
> -       struct sock *sk;
> +       struct udp_sock *up;
>
>         network_offset = skb_network_offset(skb);
>         transport_offset = skb_transport_offset(skb);
> @@ -518,12 +520,19 @@ static struct sock *__udp6_lib_err_encap(struct net *net,
>         /* Transport header needs to point to the UDP header */
>         skb_set_transport_header(skb, offset);
>
> +       if (sk) {
> +               up = udp_sk(sk);
> +
> +               lookup = READ_ONCE(up->encap_err_lookup);
> +               if (!lookup || !lookup(sk, skb))
> +                       goto out;
> +       }
> +
>         sk = __udp6_lib_lookup(net, &hdr->daddr, uh->source,
>                                &hdr->saddr, uh->dest,
>                                inet6_iif(skb), 0, udptable, skb);
>         if (sk) {
> -               int (*lookup)(struct sock *sk, struct sk_buff *skb);
> -               struct udp_sock *up = udp_sk(sk);
> +               up = udp_sk(sk);
>
>                 lookup = READ_ONCE(up->encap_err_lookup);
>                 if (!lookup || lookup(sk, skb))
> @@ -535,6 +544,7 @@ static struct sock *__udp6_lib_err_encap(struct net *net,
>                                                         offset, info));
>         }
>
> +out:
>         skb_set_transport_header(skb, transport_offset);
>         skb_set_network_header(skb, network_offset);
>
> @@ -558,16 +568,17 @@ int __udp6_lib_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
>
>         sk = __udp6_lib_lookup(net, daddr, uh->dest, saddr, uh->source,
>                                inet6_iif(skb), inet6_sdif(skb), udptable, NULL);
> +
>         if (!sk || udp_sk(sk)->encap_type) {
>                 /* No socket for error: try tunnels before discarding */
> -               sk = ERR_PTR(-ENOENT);
>                 if (static_branch_unlikely(&udpv6_encap_needed_key)) {
>                         sk = __udp6_lib_err_encap(net, hdr, offset, uh,
> -                                                 udptable, skb,
> +                                                 udptable, sk, skb,
>                                                   opt, type, code, info);
>                         if (!sk)
>                                 return 0;
> -               }
> +               } else
> +                       sk = ERR_PTR(-ENOENT);
>
>                 if (IS_ERR(sk)) {
>                         __ICMP6_INC_STATS(net, __in6_dev_get(skb->dev),
> --
> 2.18.4
>
