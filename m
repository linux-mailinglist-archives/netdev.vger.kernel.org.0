Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA9F51E9C4D
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 06:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725847AbgFAECw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 00:02:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725290AbgFAECv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 00:02:51 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE3C0C08C5C0;
        Sun, 31 May 2020 21:02:51 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id g7so3856142qvx.11;
        Sun, 31 May 2020 21:02:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xSL4Rwko5/HkgdvMP+XVPOJGxcmAkk6sOYaPeEUCqWs=;
        b=dhgYMtAZEeWAExhBHdqQf59/QKRQyxWB/vLhKKsg0rm9pEwy6I59GMwCGvo5SANXY4
         Pls7AUyqNurVr6zMis8eZsqNeB7dqOq8NUYKqstH1/zO1JmLynPMkeHDpFHgw1HtaF9w
         8uSwNgVycJwagSAJh0eCjgC8IH9GK2wIvBDPD6FStGztfiHaAPEQZhrWyO0ur3XJUOan
         w2W9SkphsIB4Wg+4siK1UDjZK9GSb/E1+ZkOy6+x9DSwpMbUzCKF+JVw8EhdMAGZn5Rv
         G+P6DhiBNwIzJ03O25X0ZXZhCc37mVhbuF+WR3G5mKFlX3fJIeKdAy5Qdvy1wJ8tEDIk
         qSTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xSL4Rwko5/HkgdvMP+XVPOJGxcmAkk6sOYaPeEUCqWs=;
        b=qP5nAx5I4M3TCQFoaAAOMuLcpjUIrCPM+QzMM9uIpdJLL+fneIISIilQLR+oM5axi1
         4LtFuvN8VaZ9MCgAihxOkdizUCLYps2CF6oOkS1rSu6JnODlAk0Q97IG5KHOKXgrcHts
         YETagC+Mie73YRd0ifh/YUJRww2sD1dmpdfngy9/4VLIAgfiW9MpFfsHemaEdn+54kQG
         UyOk6UJ1CuEX/ZuWzegXtpR+e5Wr+kuv4pWq8n+ZEVxi1GsvYXr8gnde2fUNub/3up+x
         ukykQaHiMPx6yyhJFPgXIks0s9qj9j7JsFtjMqM8Ivon9ZiAkNn/FvYFOpssaYzLnZ12
         oCOw==
X-Gm-Message-State: AOAM533YQC6xnrQxj/iKYcYfdl6SUAsoskuCFkFgWz6kAaV3oucneVJs
        le+uBdUv+nCpqWmjGXKJPq1tK/DbPQ2xttpHjPdgjQVkCoPrag==
X-Google-Smtp-Source: ABdhPJzPQujoEuNuqjtKE11B/7zPGB5/YcSVwJAi84m26AKd9+hb7IuKojNpwCUwkCEEB0d2rz5QHcorYFJWOQ472NM=
X-Received: by 2002:ad4:4e14:: with SMTP id dl20mr6953824qvb.101.1590984170297;
 Sun, 31 May 2020 21:02:50 -0700 (PDT)
MIME-Version: 1.0
References: <20200601035503.3594635-1-liuhangbin@gmail.com>
In-Reply-To: <20200601035503.3594635-1-liuhangbin@gmail.com>
From:   Hangbin Liu <liuhangbin@gmail.com>
Date:   Mon, 1 Jun 2020 12:02:39 +0800
Message-ID: <CAPwn2JSeFK7LvMfiq9_LWDcP4=Mbi=ZTSh+BqbOvEWLbkysKRg@mail.gmail.com>
Subject: Re: [PATCH net] ipv6: fix IPV6_ADDRFORM operation logic
To:     network dev <netdev@vger.kernel.org>
Cc:     John Haxby <john.haxby@oracle.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>, stable@vger.kernel.org,
        Frantisek Hrbata <fhrbata@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

cc Frantisek

On Mon, 1 Jun 2020 at 12:00, Hangbin Liu <liuhangbin@gmail.com> wrote:
>
> Socket option IPV6_ADDRFORM supports UDP/UDPLITE and TCP at present.
> Previously the checking logic looks like:
> if (sk->sk_protocol == IPPROTO_UDP || sk->sk_protocol == IPPROTO_UDPLITE)
>         do_some_check;
> else if (sk->sk_protocol != IPPROTO_TCP)
>         break;
>
> After commit b6f6118901d1 ("ipv6: restrict IPV6_ADDRFORM operation"), TCP
> was blocked as the logic changed to:
> if (sk->sk_protocol == IPPROTO_UDP || sk->sk_protocol == IPPROTO_UDPLITE)
>         do_some_check;
> else if (sk->sk_protocol == IPPROTO_TCP)
>         do_some_check;
>         break;
> else
>         break;
>
> Then after commit 82c9ae440857 ("ipv6: fix restrict IPV6_ADDRFORM operation")
> UDP/UDPLITE were blocked as the logic changed to:
> if (sk->sk_protocol == IPPROTO_UDP || sk->sk_protocol == IPPROTO_UDPLITE)
>         do_some_check;
> if (sk->sk_protocol == IPPROTO_TCP)
>         do_some_check;
>
> if (sk->sk_protocol != IPPROTO_TCP)
>         break;
>
> Fix it by using Eric's code and simply remove the break in TCP check, which
> looks like:
> if (sk->sk_protocol == IPPROTO_UDP || sk->sk_protocol == IPPROTO_UDPLITE)
>         do_some_check;
> else if (sk->sk_protocol == IPPROTO_TCP)
>         do_some_check;
> else
>         break;
>
> Fixes: 82c9ae440857 ("ipv6: fix restrict IPV6_ADDRFORM operation")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  net/ipv6/ipv6_sockglue.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
>
> diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
> index 18d05403d3b5..5af97b4f5df3 100644
> --- a/net/ipv6/ipv6_sockglue.c
> +++ b/net/ipv6/ipv6_sockglue.c
> @@ -183,14 +183,15 @@ static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
>                                         retv = -EBUSY;
>                                         break;
>                                 }
> -                       }
> -                       if (sk->sk_protocol == IPPROTO_TCP &&
> -                           sk->sk_prot != &tcpv6_prot) {
> -                               retv = -EBUSY;
> +                       } else if (sk->sk_protocol == IPPROTO_TCP) {
> +                               if (sk->sk_prot != &tcpv6_prot) {
> +                                       retv = -EBUSY;
> +                                       break;
> +                               }
> +                       } else {
>                                 break;
>                         }
> -                       if (sk->sk_protocol != IPPROTO_TCP)
> -                               break;
> +
>                         if (sk->sk_state != TCP_ESTABLISHED) {
>                                 retv = -ENOTCONN;
>                                 break;
> --
> 2.25.4
>
