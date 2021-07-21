Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB923D10DE
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 16:08:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238404AbhGUN2N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 09:28:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234380AbhGUN17 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 09:27:59 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A60D7C0613C1
        for <netdev@vger.kernel.org>; Wed, 21 Jul 2021 07:08:34 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id d2so2401051wrn.0
        for <netdev@vger.kernel.org>; Wed, 21 Jul 2021 07:08:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5KcyAraSENTnUj0crmbd6dP1ckLfXC9ZK0LsccjlpYY=;
        b=FVgsxJ+CPh+wg3AqI52L4yXNtSJxAfZ4URUGHi1kRJywnGwAlR73rohgjk6TzDhZhX
         e7quQxPNiRMx6TN+An0ZXoDWDsulbWUsguzYEUvbHrXGlcuU/h6OVFbcMMOBuDg3J0EM
         iMBTOT1FiFRPVO4S1RApTVQP8xsAgyRrlfEsdVQ6JLjD8rSwX1y+ffM4y29dLEs3+Vfx
         ucDbHbw/jGOyMSs0mgiuSEXFh2t0y7ctJhBjwHllrpdriu1jx/sfDg/hW9/tvItR5xNG
         vjE12nVS8bDNrPR2iBN0t5UXzDnN9b91A7l+eAy8/O1hj+LaPVNcC2h1/o35qMGyRelW
         Uy2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5KcyAraSENTnUj0crmbd6dP1ckLfXC9ZK0LsccjlpYY=;
        b=XNR5tISL/0890IIWbn01ES/IVqo9njmd4NCWVeoPCjHH21KRAKW6/zkWTDdMnJuHTZ
         9d1oRHi3QXYhUut8bx0qdd/svOGyAo+1maI1uBWeetazjh0RRwssXnifTrlCpqgcUBPD
         KhkRzTUB2pHaF5q5czVh1M2E8LOu4QsMOxCPBncdr+WBdIC76pfhJ+JF81qzBxD8T6Yu
         o3DjmWEaGs8PVo8AaFFzCPUfkvTVj934GWVL87/nhqmcuOEwkfxNT6QAWOShPZHHXFFe
         CsM2Xo2PJwY/uHThBc4JSFLYGK+gvhnmGRHG0wVhqd0p9YUOB/uztDuGM9A4iBAucaZG
         LYMQ==
X-Gm-Message-State: AOAM531PtQSO/7wN7U8IpDilXwER9ojDAeD2xIOdQlnDuVgJrEq6Le3D
        9X/abW3L1I7G5NYUR1onAFfhwvsGgVDXaZqoG98=
X-Google-Smtp-Source: ABdhPJyKM5/Y6AgTi+PePPitHT3YImACpSIMQ+4cgLOMe1A/zBv3p3/Pj1Nxh7cmK+16skV7dAzrxyzmRw5VG1EJ3gY=
X-Received: by 2002:adf:a287:: with SMTP id s7mr42357120wra.120.1626876513295;
 Wed, 21 Jul 2021 07:08:33 -0700 (PDT)
MIME-Version: 1.0
References: <20210720203529.21601-1-vfedorenko@novek.ru> <20210720203529.21601-2-vfedorenko@novek.ru>
In-Reply-To: <20210720203529.21601-2-vfedorenko@novek.ru>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Wed, 21 Jul 2021 10:08:22 -0400
Message-ID: <CADvbK_cWOAL5foeumNbS-FN==uCR5sHX9Y8EXX+svKh0ZZRVQQ@mail.gmail.com>
Subject: Re: [PATCH net v3 1/2] udp: check encap socket in __udp_lib_err
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     David Ahern <dsahern@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        network dev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 20, 2021 at 4:35 PM Vadim Fedorenko <vfedorenko@novek.ru> wrote:
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
>  net/ipv4/udp.c | 25 +++++++++++++++++++------
>  net/ipv6/udp.c | 25 +++++++++++++++++++------
>  2 files changed, 38 insertions(+), 12 deletions(-)
>
> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> index 62cd4cd52e84..1a742b710e54 100644
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
> @@ -659,18 +661,28 @@ static struct sock *__udp4_lib_err_encap(struct net *net,
>         /* Transport header needs to point to the UDP header */
>         skb_set_transport_header(skb, iph->ihl << 2);
>
> +       if (sk) {
> +               up = udp_sk(sk);
> +
> +               lookup = READ_ONCE(up->encap_err_lookup);
> +               if (lookup && lookup(sk, skb))
> +                       sk = NULL;
> +
> +               goto out;
> +       }
> +
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
>                         sk = NULL;
>         }
>
> +out:
>         if (!sk)
>                 sk = ERR_PTR(__udp4_lib_err_encap_no_sk(skb, info));
>
> @@ -707,15 +719,16 @@ int __udp4_lib_err(struct sk_buff *skb, u32 info, struct udp_table *udptable)
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
> index 0cc7ba531b34..c5e15e94bb00 100644
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
> @@ -518,18 +520,28 @@ static struct sock *__udp6_lib_err_encap(struct net *net,
>         /* Transport header needs to point to the UDP header */
>         skb_set_transport_header(skb, offset);
>
> +       if (sk) {
> +               up = udp_sk(sk);
> +
> +               lookup = READ_ONCE(up->encap_err_lookup);
> +               if (lookup && lookup(sk, skb))
> +                       sk = NULL;
> +
> +               goto out;
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
>                         sk = NULL;
>         }
>
> +out:
>         if (!sk) {
>                 sk = ERR_PTR(__udp6_lib_err_encap_no_sk(skb, opt, type, code,
>                                                         offset, info));
> @@ -558,16 +570,17 @@ int __udp6_lib_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
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
Reviewed-by: Xin Long <lucien.xin@gmail.com>
