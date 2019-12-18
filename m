Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49472124C5F
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 17:03:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727397AbfLRQDs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 11:03:48 -0500
Received: from mail-yw1-f66.google.com ([209.85.161.66]:40926 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727021AbfLRQDs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 11:03:48 -0500
Received: by mail-yw1-f66.google.com with SMTP id i126so953824ywe.7
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 08:03:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BsdOtnfA6X4lGR/BI0rp+eyaU4W8tfaltjNBF4imU+I=;
        b=kPGpQu5OUPoWMUfC6xql0arlmf0UQTTgLy/ZNxL8j0jDZqhUrXqUZ/VG3mU+e4jObV
         W8EV61xpOsZnaTvXkQhB/H/ScH1lrv3J8FaruLBhHi2Ob5Ib+tv/YsKppYZYwx/93mqa
         MGzYjRoRZhRUIDPlgkwxinwiBWKGL1tx3rZCdyeJ/NXZgrOrFZrnRlRZ//pD2grO0CEU
         s1ujD7l9GEfKXvAq+VPO5oV9TavmCzLLhCAqy0Yp5WCqcuzXbwiiCVx0KiIgD0o2BA3N
         GL6xsfAkYiXd7r2o+ldYScKBJXXAJ3acMjH+pwtmJFSrX8jFyifNWIbJ7Uv1BwDvjkbD
         f2AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BsdOtnfA6X4lGR/BI0rp+eyaU4W8tfaltjNBF4imU+I=;
        b=gcvYRXdf4jqT80rRnncR4VEgwSDmL+Rxf/A8Z0a1JAKpTydNvva3MAYJdVGVRe2rP+
         JK50mqmXDhn0moFuc9vWLXRfY88gZd86GyLWEB7jJC9VVy+KiNYxRz+pTjYarJVtwc+d
         8kiPO05e05sRPfJkvQ9RI3yXozXOLigN3B49mhcj+vqqm/X5T3pgANudoK1WHFWm/tzq
         eSei1LuvUoeyPqKboHiRpHNSOJW6bL3ODJ62LykykBSa6sKdrTgqUkcDu7fMufVpjFr6
         oFzXpYoLaqVGP9NgweRWG38+mxDVQfv48aizkngeyijERI1ij0F71P6buFEeYf0sePiM
         1BBw==
X-Gm-Message-State: APjAAAW+V6q4lXUmJ9wAHQpqib30a50oxGqdHB4hzfwhNC7DSLnpFNL2
        ylxSx6JJ2ejZfDFSFo1SsSvCURUR
X-Google-Smtp-Source: APXvYqzSX9M65EXjNQ5cn2+K5jGM/Hj0xnxv4aIrQwVq07n/0UwbgVGhxfRm2Prue4apAHd2p6AGng==
X-Received: by 2002:a0d:f685:: with SMTP id g127mr2768723ywf.412.1576685026982;
        Wed, 18 Dec 2019 08:03:46 -0800 (PST)
Received: from mail-yw1-f45.google.com (mail-yw1-f45.google.com. [209.85.161.45])
        by smtp.gmail.com with ESMTPSA id k6sm1092428ywh.56.2019.12.18.08.03.46
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Dec 2019 08:03:46 -0800 (PST)
Received: by mail-yw1-f45.google.com with SMTP id v126so945255ywc.10
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 08:03:46 -0800 (PST)
X-Received: by 2002:a0d:f481:: with SMTP id d123mr2451398ywf.411.1576685025562;
 Wed, 18 Dec 2019 08:03:45 -0800 (PST)
MIME-Version: 1.0
References: <20191218133458.14533-1-steffen.klassert@secunet.com> <20191218133458.14533-5-steffen.klassert@secunet.com>
In-Reply-To: <20191218133458.14533-5-steffen.klassert@secunet.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 18 Dec 2019 11:03:09 -0500
X-Gmail-Original-Message-ID: <CA+FuTScaqg8whAaS35n9TT+=7S38Sn_sMEN=KstYF6i83keSsw@mail.gmail.com>
Message-ID: <CA+FuTScaqg8whAaS35n9TT+=7S38Sn_sMEN=KstYF6i83keSsw@mail.gmail.com>
Subject: Re: [PATCH net-next 4/4] udp: Support UDP fraglist GRO/GSO.
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 18, 2019 at 8:35 AM Steffen Klassert
<steffen.klassert@secunet.com> wrote:
>
> This patch extends UDP GRO to support fraglist GRO/GSO
> by using the previously introduced infrastructure.
> If the feature is enabled, all UDP packets are going to
> fraglist GRO (local input and forward).
>
> Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>

> -INDIRECT_CALLABLE_DECLARE(struct sock *udp6_lib_lookup_skb(struct sk_buff *skb,
> -                                                  __be16 sport, __be16 dport));
>  struct sk_buff *udp_gro_receive(struct list_head *head, struct sk_buff *skb,
> -                               struct udphdr *uh, udp_lookup_t lookup)
> +                               struct udphdr *uh, struct sock *sk)
>  {
>         struct sk_buff *pp = NULL;
>         struct sk_buff *p;
>         struct udphdr *uh2;
>         unsigned int off = skb_gro_offset(skb);
>         int flush = 1;
> -       struct sock *sk;
>
> -       rcu_read_lock();
> -       sk = INDIRECT_CALL_INET(lookup, udp6_lib_lookup_skb,
> -                               udp4_lib_lookup_skb, skb, uh->source, uh->dest);
> -       if (!sk)
> -               goto out_unlock;
> +       if (skb->dev->features & NETIF_F_GRO_FRAGLIST)
> +               NAPI_GRO_CB(skb)->is_flist = sk ? !udp_sk(sk)->gro_enabled: 1;
>
> -       if (udp_sk(sk)->gro_enabled) {
> +       if ((sk && udp_sk(sk)->gro_enabled) ||  NAPI_GRO_CB(skb)->is_flist) {

nit: two spaces before NAPI_GRO_CB

> @@ -544,6 +585,18 @@ INDIRECT_CALLABLE_SCOPE int udp4_gro_complete(struct sk_buff *skb, int nhoff)
>         const struct iphdr *iph = ip_hdr(skb);
>         struct udphdr *uh = (struct udphdr *)(skb->data + nhoff);
>
> +       if (NAPI_GRO_CB(skb)->is_flist) {
> +               uh->len = htons(skb->len - nhoff);
> +
> +               skb_shinfo(skb)->gso_type |= (SKB_GSO_FRAGLIST|SKB_GSO_UDP_L4);
> +               skb_shinfo(skb)->gso_segs = NAPI_GRO_CB(skb)->count;
> +
> +               skb->ip_summed = CHECKSUM_UNNECESSARY;
> +               skb->csum_level = ~0;

why is this needed for ipv4 only?


> @@ -144,6 +150,15 @@ INDIRECT_CALLABLE_SCOPE int udp6_gro_complete(struct sk_buff *skb, int nhoff)
>         const struct ipv6hdr *ipv6h = ipv6_hdr(skb);
>         struct udphdr *uh = (struct udphdr *)(skb->data + nhoff);
>
> +       if (NAPI_GRO_CB(skb)->is_flist) {
> +               uh->len = htons(skb->len - nhoff);
> +
> +               skb_shinfo(skb)->gso_type |= (SKB_GSO_FRAGLIST|SKB_GSO_UDP_L4);
> +               skb_shinfo(skb)->gso_segs = NAPI_GRO_CB(skb)->count;
> +
> +               return 0;
> +       }
