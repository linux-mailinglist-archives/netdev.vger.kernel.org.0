Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E765E3C257B
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 16:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232082AbhGIOE6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 10:04:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbhGIOE5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Jul 2021 10:04:57 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 852F0C0613DD
        for <netdev@vger.kernel.org>; Fri,  9 Jul 2021 07:02:14 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id y38so14805037ybi.1
        for <netdev@vger.kernel.org>; Fri, 09 Jul 2021 07:02:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WkW6fDyOZ+4zhT7qRRc0K4+EnrxH2x0ieuIpUvkKl9Y=;
        b=ZYpz3yp7Tr8GkYHNRZNhqiyEb2Gv0LV0qxgEQTFV4OQIac4tfbmCyr1nWx5aR6HzXi
         P5QcJOPda9mDJP3Ox8s/oEUJi3IYKoOOKZcNsHxXQUKn6S7xnNcTpAJVUvP1Qoq03mVP
         m7dCoSOkKItgBkuhdx4UJ4jX4PcyzVf2zOoZLd0NeJEpP+gL9V0y3IlAbXe3JLonO6yC
         /L22JKE7Y2p/No33YwmS1L2J2+Y+cr8l38ySz2rIqeECDh56yJLcz7r9MTxBCEef4D0/
         +98QVGbYVh2sBexHovnSgl7kIw9dboAtRKahxlurTqqnJB3rkyqhcBmTsgKDfF/dKswP
         khJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WkW6fDyOZ+4zhT7qRRc0K4+EnrxH2x0ieuIpUvkKl9Y=;
        b=qUoa4mK+g4t1IhdEoOJrYEzwkl8Q7wxEiy7eqrlsLvOlWtecWXWW1He/l1d6pEpnhQ
         Mr3jx6CSwiZPjk4A1BlSsrVtJloX8jlphVPDONLT8rbndDZrReymsVV9++YLoKVodrPt
         Wx3JKUiirRAXwXDZ7u6YizESf+2oHIziXozIQ56GDBBMnZ0gRUzHb4P0yyR1Z+opXekm
         jFJ6TKbLwlVWQpt6coMNWnEd6VuQmBvWMBjdyQ7J/FbheJL2+0IPuyd5/CeGHbwmFVRC
         WB90f7vipSaND67nIkmgd+8jiWYDMLyjGxrqMCQ4MbKErfraINgZXVXjjDegGFoRV7Im
         OSGg==
X-Gm-Message-State: AOAM533j8mqlFJaVX8TQWq/XF/1vMi4yksHaTEv8JrrMZo4WfEdJk3oG
        NXfOvleV3jOMJK93a8iQy8+sX8+evsmEIlPdGSiljQ==
X-Google-Smtp-Source: ABdhPJyoPdrlcPUMf6cNewrJXFDfeZJwVMKkMukMlY1e5R34QBOHvxYLK5v440hEnU71qfWEaa2n5V6u60yX0Xen6ts=
X-Received: by 2002:a25:afcd:: with SMTP id d13mr45655105ybj.504.1625839333205;
 Fri, 09 Jul 2021 07:02:13 -0700 (PDT)
MIME-Version: 1.0
References: <20210709123512.6853-1-ovov@yandex-team.ru>
In-Reply-To: <20210709123512.6853-1-ovov@yandex-team.ru>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 9 Jul 2021 16:02:02 +0200
Message-ID: <CANn89iL=3VegNxgVqDz3OgbfjGPMmeLRgFTZqEKFrByqXotX1g@mail.gmail.com>
Subject: Re: [PATCH] net: send SYNACK packet with accepted fwmark
To:     Alexander Ovechkin <ovov@yandex-team.ru>
Cc:     netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>, zeil@yandex-team.ru
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 9, 2021 at 2:35 PM Alexander Ovechkin <ovov@yandex-team.ru> wrote:
>
> commit e05a90ec9e16 ("net: reflect mark on tcp syn ack packets")
> fixed IPv4 only.
>
> This part is for the IPv6 side.
>
> Signed-off-by: Alexander Ovechkin <ovov@yandex-team.ru>
> Acked-by: Dmitry Yakunin <zeil@yandex-team.ru>

Please add a standard tool-friendly Fixes: tag.

Fixes: e05a90ec9e16 ("net: reflect mark on tcp syn ack packets")

> ---
>  net/ipv6/tcp_ipv6.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
> index 323989927a0a..0ce52d46e4f8 100644
> --- a/net/ipv6/tcp_ipv6.c
> +++ b/net/ipv6/tcp_ipv6.c
> @@ -555,7 +555,7 @@ static int tcp_v6_send_synack(const struct sock *sk, struct dst_entry *dst,
>                 opt = ireq->ipv6_opt;
>                 if (!opt)
>                         opt = rcu_dereference(np->opt);
> -               err = ip6_xmit(sk, skb, fl6, sk->sk_mark, opt,
> +               err = ip6_xmit(sk, skb, fl6, skb->mark ? : sk->sk_mark, opt,
>                                tclass, sk->sk_priority);
>                 rcu_read_unlock();
>                 err = net_xmit_eval(err);
> --
> 2.17.1
>

ip6_xmit() overwrites skb->mark with its 4th argument, while
ip_build_and_send_pkt()
does the write if skb->mark is zero, so your patch seems fine to me, thanks.


Reviewed-by: Eric Dumazet <edumazet@google.com>
