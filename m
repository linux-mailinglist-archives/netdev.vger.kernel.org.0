Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 619C731B207
	for <lists+netdev@lfdr.de>; Sun, 14 Feb 2021 19:36:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbhBNSfJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Feb 2021 13:35:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbhBNSfI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Feb 2021 13:35:08 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A16E8C061574
        for <netdev@vger.kernel.org>; Sun, 14 Feb 2021 10:34:28 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id y128so4997218ybf.10
        for <netdev@vger.kernel.org>; Sun, 14 Feb 2021 10:34:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UWFAImDiwIAk4Aqi7kE6zrK33/wl3037RungXx+wiBA=;
        b=FpF70F6fsuMpa4RWpc7WNilVbYiUy8axr+Bu4JJWTrp/q3ZN8YoOAClEYW1db9cRMg
         4muGBh3Y5hv0vreYSULpbnk1/5Pr1ghuWiWnnYsGDxzZaP6rOsb+s9MZDJ3SKc94oPFb
         xZYF8SpdXs67htFRS4Hb7Ra1/XbQ0qVYkaiYLGxqDtn9cAX3+26ccvTMHNPFg6m6l3+i
         5cfP+9ZMH2GFGpEDI9OEJ/lhTualnV3MPs162nk+C0XBXeJkRaaVbRnvTxd/P54Io7BI
         ZzRr5BhIZjGorjMnVs7bG3pyWnNbWuMzTKm5PO55o2+i+8YFxYWuX8V2wlQQPDoVtldB
         FFOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UWFAImDiwIAk4Aqi7kE6zrK33/wl3037RungXx+wiBA=;
        b=UfnZeMWESe8OLShrCMr8dK3SelcaGnKFpEFZrqFQ0r5fgK02LWevkF4ElfZG7ejPYN
         DqS5gmwiusguYMTQukSVLNlgMHpMd+SDvIyQlJAholuBhJ3fP8HDkul8SQzEjvPqp7qe
         YOmxOFvuNBCXP8gxIuxQ73qVy2XkmN0W2ll4Kkr5pzH/88mHI2b5t2onps475Yz4R8aw
         731UT6Nj1J8fABbJQ8YGrNE/PtWGlVS+ewZ2sRAIzb0rj+Di0nPzkwUmayMZtXprdqZG
         8GigOwpvU+6zhaM34kZcwMxt3fzPxJx5gNlmwCIaDbzxSVGhlLyjR8VLCTT4Hq6VCML5
         wB5Q==
X-Gm-Message-State: AOAM533jQLfphdc2VGWzu0WQ0UrStwe1II8gtenqdL0mvUGpQHISpQlG
        kGZMLXOKm6ONV5ObCH+YjKv7p3W8tZG2pCBwBPfExgCZW0c=
X-Google-Smtp-Source: ABdhPJxg/mn9mKSZe2PCCBtspxS+os7DO6WivcBs41yKdLjOH3XMvWSKy4Ijuf0+5NpVI67MC9l0Pi1Kme9OCrmvIZc=
X-Received: by 2002:a25:fc3:: with SMTP id 186mr17867018ybp.452.1613327667513;
 Sun, 14 Feb 2021 10:34:27 -0800 (PST)
MIME-Version: 1.0
References: <20210213142634.3237642-1-eric.dumazet@gmail.com>
In-Reply-To: <20210213142634.3237642-1-eric.dumazet@gmail.com>
From:   Wei Wang <weiwan@google.com>
Date:   Sun, 14 Feb 2021 10:34:15 -0800
Message-ID: <CAEA6p_AUsnEW4BacV1uW_own6QJaMSGiDjX1Up0j8J5rzY9s0A@mail.gmail.com>
Subject: Re: [PATCH net-next] tcp: tcp_data_ready() must look at SOCK_DONE
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Arjun Roy <arjunroy@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 13, 2021 at 6:26 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
>
> My prior cleanup missed that tcp_data_ready() has to look at SOCK_DONE.
> Otherwise, an application using SO_RCVLOWAT will not get EPOLLIN event
> if a FIN is received in the middle of expected payload.
>
> The reason SOCK_DONE is not examined in tcp_epollin_ready()
> is that tcp_poll() catches the FIN because tcp_fin()
> is also setting RCV_SHUTDOWN into sk->sk_shutdown
>
> Fixes: 05dc72aba364 ("tcp: factorize logic into tcp_epollin_ready()")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Wei Wang <weiwan@google.com>
> Cc: Arjun Roy <arjunroy@google.com>
> ---
Thanks Eric for the fix!

Reviewed-by: Wei Wang <weiwan@google.com>

>  net/ipv4/tcp_input.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index e32a7056cb7640c67ef2d6a4d9484684d2602fcd..69a545db80d2ead47ffcf2f3819a6d066e95f35d 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -4924,7 +4924,7 @@ int tcp_send_rcvq(struct sock *sk, struct msghdr *msg, size_t size)
>
>  void tcp_data_ready(struct sock *sk)
>  {
> -       if (tcp_epollin_ready(sk, sk->sk_rcvlowat))
> +       if (tcp_epollin_ready(sk, sk->sk_rcvlowat) || sock_flag(sk, SOCK_DONE))
>                 sk->sk_data_ready(sk);
>  }
>
> --
> 2.30.0.478.g8a0d178c01-goog
>
