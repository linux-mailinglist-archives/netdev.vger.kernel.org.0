Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF4C23080BE
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 22:50:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231489AbhA1Vt4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 16:49:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbhA1Vtz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 16:49:55 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBAC8C061573
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 13:49:14 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id w1so9978794ejf.11
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 13:49:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=k+b6pi0TuWBAA0sBiw2Zrq68l0mmRA56jJFDYITb6FA=;
        b=AgrBwmVpoXudophQYBakLO9xKpr4cDDtD+1V7tLti7vgqIE0ePhS9Uuulu9z7QeOs4
         nFZl/+dMByMCeWcnlFhVxYS2XH2p+IJNiaOuFoowv6YWOyRNPZcXYxEuZp48oGknFs93
         syBgCfk59weAS7EN5FVWn/EqgXnavlT62swaqx1bJvVdoEGZpoQuoKlvcs5MlEg0bxLg
         b81EPoVIQFNAE6I08KUyrta83B6nMo5vEyPW6QgezMYHrTo9hj+SDiBxGAlBK4rvub/f
         Djg1mYqzF1n7eVx+ZjHIqoUlUl2KvJttK1P3oh6H6RyPsacZVx7Tm0RKsBJVrG63e+dM
         Nd7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=k+b6pi0TuWBAA0sBiw2Zrq68l0mmRA56jJFDYITb6FA=;
        b=k0Lxy6VkD4lltvXnqiGCY7yrnMkvaXgZ+8zYCo02VDDC7YJntoj3shvQaPNlwjFr2n
         wBq7aq93I5u3opGFGguYkLK78mmnVA8vOKtDbifUdMze610w9oOcxTLuOkI/YHig9tBj
         RX+aLcibz4A5vFsEn9LSbxhu8wTFcgmxIK1s9VcP8ebX34LR5LMQBgbrDiz5qaXH6LjY
         AUrD3K+Rcu766WA7s/K7brJq2BP7SBy8A4JsifV3C0EwzdRtfUJeaRSKzgJpu7STTtep
         j7bwLrwQLoNHTTzIxPUp7IFGBt3/oNCrJ72qTM2ecvJmwxGxidlrJhRXQp1e8w25hKeJ
         fk6A==
X-Gm-Message-State: AOAM533C2g68QQ3aTBz8hCTWGsXSnr+FaC2T0/+e5RUIABgeL8r2R0aQ
        1+cYDtPA+hK/r+JI1kZTBrah4M3iuf6AaLj0wGI=
X-Google-Smtp-Source: ABdhPJwn8AeAY0f1dNoqIfREgd8AhjFbR1SFTdRb4dk+iIPPfSeNxMbMUOUNG6/7YwmS7ApwqmTbBYs9PzzrBIEiLRw=
X-Received: by 2002:a17:906:fc5:: with SMTP id c5mr1449268ejk.538.1611870553697;
 Thu, 28 Jan 2021 13:49:13 -0800 (PST)
MIME-Version: 1.0
References: <1611805733-25072-1-git-send-email-vfedorenko@novek.ru>
In-Reply-To: <1611805733-25072-1-git-send-email-vfedorenko@novek.ru>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 28 Jan 2021 16:48:37 -0500
Message-ID: <CAF=yD-JA7OPLWTxnhkEbvFwuY_SJm7SociVSTi+GG2_Qr72+KQ@mail.gmail.com>
Subject: Re: [net] net: ip_tunnel: fix mtu calculation
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Slava Bacherikov <mail@slava.cc>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 27, 2021 at 11:14 PM Vadim Fedorenko <vfedorenko@novek.ru> wrote:
>
> dev->hard_header_len for tunnel interface is set only when header_ops
> are set too and already contains full overhead of any tunnel encapsulation.
> That's why there is not need to use this overhead twice in mtu calc.
>
> Fixes: fdafed459998 ("ip_gre: set dev->hard_header_len and dev->needed_headroom properly")
> Reported-by: Slava Bacherikov <mail@slava.cc>
> Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
> ---
>  net/ipv4/ip_tunnel.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
> index 64594aa..ad78825 100644
> --- a/net/ipv4/ip_tunnel.c
> +++ b/net/ipv4/ip_tunnel.c
> @@ -317,7 +317,7 @@ static int ip_tunnel_bind_dev(struct net_device *dev)
>         }
>
>         dev->needed_headroom = t_hlen + hlen;
> -       mtu -= (dev->hard_header_len + t_hlen);
> +       mtu -= dev->hard_header_len ? : t_hlen;

Safety of this change also depends on whether any other ip tunnels
might have non-zero hard_header_len.

I haven't fully checked yet, but at first scan I only see one other
instance of header_ops, and that ip_tunnel_header_ops does not have a
create implementation.

>
>         if (mtu < IPV4_MIN_MTU)
>                 mtu = IPV4_MIN_MTU;
> @@ -347,7 +347,7 @@ static struct ip_tunnel *ip_tunnel_create(struct net *net,
>         nt = netdev_priv(dev);
>         t_hlen = nt->hlen + sizeof(struct iphdr);
>         dev->min_mtu = ETH_MIN_MTU;
> -       dev->max_mtu = IP_MAX_MTU - dev->hard_header_len - t_hlen;
> +       dev->max_mtu = IP_MAX_MTU - dev->hard_header_len ? : t_hlen;

here and elsewhere: subtraction takes precedence over ternary
conditional, so (IP_MAX_MTU - ..) always true.
