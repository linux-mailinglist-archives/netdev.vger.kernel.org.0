Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33E69BB47A
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 14:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439712AbfIWMyU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Sep 2019 08:54:20 -0400
Received: from mail-yw1-f65.google.com ([209.85.161.65]:42402 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437411AbfIWMyU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Sep 2019 08:54:20 -0400
Received: by mail-yw1-f65.google.com with SMTP id i207so5131089ywc.9
        for <netdev@vger.kernel.org>; Mon, 23 Sep 2019 05:54:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5e3TSSpWpWh14Yk+auWyvBzyMGefL1Rq22LRXpNKBi0=;
        b=DX0t+C232smUMFvIYKsiyWx7jFPSiiDO/1SnwkSeFYGGodOYK3k86S5tC5juDqiLYs
         xkySfGPuEFGfss1E4uINK32a8JdutcdhnRv3eHBab58blMPIZsaXQeYzHYxpVcVHc8zR
         2/EIKWpDp2XlzsLurogh2DIgzCvnz+vtdUbI+sWYEAI3gPsenYPZamGBreCl9q6kdL1Z
         O6ibdFZAryjy8lJV+2aDIgjBpJsgFJTdB2E39iinSl66g1YfihTDtjxwzw/lJCWeTwcX
         yzfgMVgoq2w/1M1PddP6dNZtKbkTV0Lv/HueHsfAAwWoLAKzVqq6khY6i77V7Ejs6deq
         AHoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5e3TSSpWpWh14Yk+auWyvBzyMGefL1Rq22LRXpNKBi0=;
        b=eEjx4buFxvNlMCY8+02yiSymQI1JP5TzEppHYMgbdqkedz+DYEnsjUjClzd7zYutR/
         W/42bizmEIHYUTYnQergWFrriYw20P39yS/9FNOBhBX/cmGUPN13QjthgX48TuNUw5U6
         6nklLhZxV3WmOH7WxtBH+/O4G6odYwAfwx40sG8as1BZiO+4Pkt1MnZxDqCvkQl5BJ4g
         FJ9dvolD/8gdYtInm0PXrd4MVUHQN2imqfTNYw8c/QPFTQgJv6QpG5gnpQ/Po6MKnWiT
         TqaAww8MVQNdOTlQdCAETAmhPKYUqU+CIdM0ezjH27zGAGlHvYUjw2mpPqVl+JNEY9S9
         79Ug==
X-Gm-Message-State: APjAAAXsDJLa3zmjbmeutrPx4xK5ptq4WrR3MD1x1CniYPQgi9hDV/q5
        qwg7/3q31iaXcuRsB5XBCHQOF0ix
X-Google-Smtp-Source: APXvYqxu11wu8ezMc8vMX04ykxwX99K0IJSqU+fSOFCOxhi1mPQbgUiHAhqLX9VQ2HmFaYp82fDBmw==
X-Received: by 2002:a0d:df4e:: with SMTP id i75mr24383481ywe.483.1569243258549;
        Mon, 23 Sep 2019 05:54:18 -0700 (PDT)
Received: from mail-yw1-f48.google.com (mail-yw1-f48.google.com. [209.85.161.48])
        by smtp.gmail.com with ESMTPSA id r67sm2629474ywr.48.2019.09.23.05.54.17
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Sep 2019 05:54:17 -0700 (PDT)
Received: by mail-yw1-f48.google.com with SMTP id h73so5149257ywa.1
        for <netdev@vger.kernel.org>; Mon, 23 Sep 2019 05:54:17 -0700 (PDT)
X-Received: by 2002:a81:2849:: with SMTP id o70mr21821700ywo.389.1569243256569;
 Mon, 23 Sep 2019 05:54:16 -0700 (PDT)
MIME-Version: 1.0
References: <20190920044905.31759-1-steffen.klassert@secunet.com> <20190920044905.31759-2-steffen.klassert@secunet.com>
In-Reply-To: <20190920044905.31759-2-steffen.klassert@secunet.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 23 Sep 2019 08:53:40 -0400
X-Gmail-Original-Message-ID: <CA+FuTScee60of_g1Mg7hJnMLu=mjM7w289mj3L4TNZ6WnTkvdA@mail.gmail.com>
Message-ID: <CA+FuTScee60of_g1Mg7hJnMLu=mjM7w289mj3L4TNZ6WnTkvdA@mail.gmail.com>
Subject: Re: [PATCH RFC 1/5] UDP: enable GRO by default.
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 20, 2019 at 12:49 AM Steffen Klassert
<steffen.klassert@secunet.com> wrote:
>
> This patch enables UDP GRO regardless if a GRO capable
> socket is present. With this GRO is done by default
> for the local input and forwarding path.
>
> Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
>  struct sk_buff *__udp_gso_segment(struct sk_buff *gso_skb,
> diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
> index a3908e55ed89..929b12fc7bc5 100644
> --- a/net/ipv4/udp_offload.c
> +++ b/net/ipv4/udp_offload.c
> @@ -401,36 +401,25 @@ static struct sk_buff *udp_gro_receive_segment(struct list_head *head,
>         return NULL;
>  }
>
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
> -
> -       if (udp_sk(sk)->gro_enabled) {
> +       if (!sk || !udp_sk(sk)->gro_receive) {

Not critical, but the use of sk->gro_enabled and sk->gro_receive to
signal whether sockets are willing to accept large packets or are udp
tunnels, respectively, is subtle and possibly confusing.

Wrappers udp_sock_is_tunnel and udp_sock_accepts_gso could perhaps
help document the logic a bit.

static inline bool udp_sock_is_tunnel(struct udp_sock *up)
{
    return up->gro_receive;
}

And perhaps only pass a non-zero sk to udp_gro_receive if it is a
tunnel and thus skips the new default path:

static inline struct sock *sk = udp4_lookup_tunnel(const struct
sk_buff *skb, __be16 sport, __be16_dport)
{
    struct sock *sk;

    if (!static_branch_unlikely(&udp_encap_needed_key))
      return NULL;

    rcu_read_lock();
    sk = udp4_lib_lookup_skb(skb, source, dest);
    rcu_read_unlock();

    return udp_sock_is_tunnel(udp_sk(sk)) ? sk  : NULL;
}

>                 pp = call_gro_receive(udp_gro_receive_segment, head, skb);
> -               rcu_read_unlock();
>                 return pp;
>         }

Just a suggestion. It may be too verbose as given.

> @@ -468,8 +456,10 @@ INDIRECT_CALLABLE_SCOPE
>  struct sk_buff *udp4_gro_receive(struct list_head *head, struct sk_buff *skb)
>  {
>         struct udphdr *uh = udp_gro_udphdr(skb);
> +       struct sk_buff *pp;
> +       struct sock *sk;
>
> -       if (unlikely(!uh) || !static_branch_unlikely(&udp_encap_needed_key))
> +       if (unlikely(!uh))
>                 goto flush;
>
>         /* Don't bother verifying checksum if we're going to flush anyway. */
> @@ -484,7 +474,11 @@ struct sk_buff *udp4_gro_receive(struct list_head *head, struct sk_buff *skb)
>                                              inet_gro_compute_pseudo);
>  skip:
>         NAPI_GRO_CB(skb)->is_ipv6 = 0;
> -       return udp_gro_receive(head, skb, uh, udp4_lib_lookup_skb);
> +       rcu_read_lock();
> +       sk = static_branch_unlikely(&udp_encap_needed_key) ? udp4_lib_lookup_skb(skb, uh->source, uh->dest) : NULL;
> +       pp = udp_gro_receive(head, skb, uh, sk);
> +       rcu_read_unlock();
> +       return pp;
