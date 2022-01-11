Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B2D448B10A
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 16:40:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343497AbiAKPkJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 10:40:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241797AbiAKPkJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 10:40:09 -0500
Received: from mail-vk1-xa34.google.com (mail-vk1-xa34.google.com [IPv6:2607:f8b0:4864:20::a34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8752C06173F
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 07:40:08 -0800 (PST)
Received: by mail-vk1-xa34.google.com with SMTP id m57so2528734vkf.9
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 07:40:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MNebTMoFC3mE7Sb+no0J2oxGNQv4XmAbLVXLd+UEUyw=;
        b=pXwP/jcIuLM+IcI980XIV7p4VTv5FB5nJnvayqGHsBeSl4jdL7hIC913ZrBKn7IuF3
         ra+kEajmLo6eflU1DXVD5iOzlOB8O88saVLahQoak/bdn49bOy5OF7+XYHD/8uEcfJEV
         Lh1O/zBkIWL78ZA7stBZ0soH6IfZDD0c1WHsVHx47PQiURfvG6WfS+qbNb4f6zo8Zn4V
         oRorzM2K/QmQVmnPOb00ZhKU8YSEAJ5+s84XBM71eAywAnJ+seOCNyng1t2Dnf7vJp+J
         3QjnFkR0yIAm1P/LZV9gpGqpEnQSFtYXs2s6kWtK5dTSdNAzi6/hBqxfeKQLwBLi/uUM
         l7zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MNebTMoFC3mE7Sb+no0J2oxGNQv4XmAbLVXLd+UEUyw=;
        b=UsOGd2JJ63ovrUekG8OBk+hSWnkhwHwEFkyBqdOf1bH8Yzt3xNHZTw5DvyuWJgtFbO
         nnHr2nOVUW34YP3j5csG4rpnhdVsGVxCXc7/YfFhH05/j1srIblbVzaYrrOVRI9I/Wvm
         vE3MfU/igaxY9EvZzQsa3hO9vAM2007F/bFh+xV/p3jGDqWavP9hBsfnQyycxBebG2ky
         y+MO3AMm3SC+EqA2C44H37TsHiVDCi4VBdZjMjl+H0nWkAKddZGhahRm2161mYVy/gsx
         0tdW3BhjSLLKMojncN6PbcACAJbMvGs+Y+mPMGB73SiGpo6HD597X0jTgmcBusPgUfVI
         +qmA==
X-Gm-Message-State: AOAM531hm5s53Qi53T0NqVeZ5nvOq+R+X67FFpHe3Juy+D0o+a4kero5
        v1+X6f6CgPSPYydmtzE0QcCk2bbb0Ds=
X-Google-Smtp-Source: ABdhPJzeZGg69vzUxY6KFgxbUppH+sxX98PGGarkGpXnNGk+VOn5LGIp2+4avopMNct4T2bVq740/w==
X-Received: by 2002:a05:6122:e76:: with SMTP id bj54mr2450023vkb.38.1641915607304;
        Tue, 11 Jan 2022 07:40:07 -0800 (PST)
Received: from mail-ua1-f44.google.com (mail-ua1-f44.google.com. [209.85.222.44])
        by smtp.gmail.com with ESMTPSA id f132sm5925696vkf.18.2022.01.11.07.40.06
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Jan 2022 07:40:06 -0800 (PST)
Received: by mail-ua1-f44.google.com with SMTP id x33so29181664uad.12
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 07:40:06 -0800 (PST)
X-Received: by 2002:a67:a409:: with SMTP id n9mr2204137vse.74.1641915606014;
 Tue, 11 Jan 2022 07:40:06 -0800 (PST)
MIME-Version: 1.0
References: <cover.1641863490.git.asml.silence@gmail.com> <07031c43d3e5c005fbfc76b60a58e30c66d7c620.1641863490.git.asml.silence@gmail.com>
In-Reply-To: <07031c43d3e5c005fbfc76b60a58e30c66d7c620.1641863490.git.asml.silence@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 11 Jan 2022 10:39:30 -0500
X-Gmail-Original-Message-ID: <CA+FuTSdJYwN=vxpj4nkpSxdyJ5_47PZuPTjQkRphYvLt47KdjQ@mail.gmail.com>
Message-ID: <CA+FuTSdJYwN=vxpj4nkpSxdyJ5_47PZuPTjQkRphYvLt47KdjQ@mail.gmail.com>
Subject: Re: [PATCH 09/14] ipv6: hand dst refs to cork setup
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 10, 2022 at 8:25 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>
> During cork->dst setup, ip6_make_skb() gets an additional reference to
> a passed in dst. However, udpv6_sendmsg() doesn't need dst after calling
> ip6_make_skb(), and so we can save two additional atomics by passing
> dst references to ip6_make_skb(). udpv6_sendmsg() is the only caller, so
> it's enough to make sure it doesn't use dst afterwards.
>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---

There are two patches 9/14

>  net/ipv6/ip6_output.c | 9 ++++++---
>  net/ipv6/udp.c        | 3 ++-
>  2 files changed, 8 insertions(+), 4 deletions(-)
>
> diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
> index 0cc490f2cfbf..6a7bba4dd04d 100644
> --- a/net/ipv6/ip6_output.c
> +++ b/net/ipv6/ip6_output.c
> @@ -1356,6 +1356,8 @@ static int ip6_setup_cork(struct sock *sk, struct inet_cork_full *cork,
>         unsigned int mtu;
>         struct ipv6_txoptions *nopt, *opt = ipc6->opt;
>
> +       cork->base.dst = &rt->dst;
> +

Is there a reason to move this up from its original location next to
the other cork initialization assignments?

That the reference is taken in ip6_append_data for corked requests
(once, in setup cork branch) and inherited from udpv6_send_skb
otherwise is non-trivial. Worth a comment.

>         /*
>          * setup for corking
>          */
> @@ -1389,8 +1391,6 @@ static int ip6_setup_cork(struct sock *sk, struct inet_cork_full *cork,
>
>                 /* need source address above miyazawa*/
>         }
> -       dst_hold(&rt->dst);
> -       cork->base.dst = &rt->dst;
>         v6_cork->hop_limit = ipc6->hlimit;
>         v6_cork->tclass = ipc6->tclass;
>         if (rt->dst.flags & DST_XFRM_TUNNEL)
> @@ -1784,6 +1784,7 @@ int ip6_append_data(struct sock *sk,
>                 /*
>                  * setup for corking
>                  */
> +               dst_hold(&rt->dst);
>                 err = ip6_setup_cork(sk, &inet->cork, &np->cork,
>                                      ipc6, rt);
>                 if (err)
> @@ -1974,8 +1975,10 @@ struct sk_buff *ip6_make_skb(struct sock *sk,
>         int exthdrlen = (ipc6->opt ? ipc6->opt->opt_flen : 0);
>         int err;
>
> -       if (flags & MSG_PROBE)
> +       if (flags & MSG_PROBE) {
> +               dst_release(&rt->dst);
>                 return NULL;
> +       }
>
>         __skb_queue_head_init(&queue);
>
> diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
> index eec83e34ae27..3039dff7fe64 100644
> --- a/net/ipv6/udp.c
> +++ b/net/ipv6/udp.c
> @@ -1541,7 +1541,8 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
>                 err = PTR_ERR(skb);
>                 if (!IS_ERR_OR_NULL(skb))
>                         err = udp_v6_send_skb(skb, fl6, &cork.base);
> -               goto out;
> +               /* ip6_make_skb steals dst reference */
> +               goto out_no_dst;
>         }
>
>         lock_sock(sk);
> --
> 2.34.1
>
