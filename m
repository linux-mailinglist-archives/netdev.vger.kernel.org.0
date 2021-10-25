Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B88C943A7FD
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 01:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232664AbhJYXMe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 19:12:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231478AbhJYXMd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 19:12:33 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8918AC061745
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 16:10:10 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id y12so6251764eda.4
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 16:10:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lFwaPl5bxAdhvr1VVYuzXHbRgwNQI9ZonkHn/942SIo=;
        b=V6arbEeuSuth9mDxKkUDr5DX0EVPt8DEsx/6sBHsNZ0Mnus3jBTodAxKoFEFuLif2Y
         IAbq3kCDwUXn/HUtpTdFwq52wHqCbEc8qaYwBwjyXX6Z5sI0EpbMcRmfrn6LCqkr+I7Z
         2WF45+XJcC4rHcfV4pw2mc5PHaVfuT4AvAaX+Cl1eKTwG6zyrih++9iPjeuzyDgNntXI
         SuelY6DNyH95ZXa2EXtBYHS9UL+/qomgeMh+ddb5TAJXEqJomw75lmrW0dfDQ6ML5xAI
         aGfSpqgj7w86vxD5BKYkKVBXRUt2EVH44DOymUj+DwUrutZdW6rL93MZCZlOPfgFbi1K
         uZ+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lFwaPl5bxAdhvr1VVYuzXHbRgwNQI9ZonkHn/942SIo=;
        b=Ry28NegiyfaGOTADiKbuGWV+3s5uHmxmxfurUmg64rxALrCt11WgGWhqqS6Pli2JYq
         ADImWk0+fupDzXb16AcR59IjdlZYGfVwzunP3po53bm+YLpgOhLS4Xw3Va7YsQZMxeXI
         kbRWAsxGRekwDopyCrvwODAWdQZJnfq31ev9V62Q6x8JPxNti6FY+oLmcyfB5dqV5KBD
         aELkgtspnysp9Cy4quX0hPjhfI9UkCd0TUGXyTAFP5ha2MvNLrmW2rKj5Iy0NsW7Iq9A
         S3KAvWSPTvpQju6woGPTO9kWp8KlpZ52UiwPO9COEwFpFmDf3kOpwRCHZUDGQHZFBD8V
         ZoHQ==
X-Gm-Message-State: AOAM531eO3ubzVLF5Jrvmje1M78F1v/NYFt50ccF+04sEsV4AZk6an+O
        2l/CmC/ETuFWC0khlBbRq5KMuBb4ClLadDYfBkwBB8he4EU=
X-Google-Smtp-Source: ABdhPJyddl9SBuAs2L2+JGa+624CDN8bdd1NGfKRh0uAk1JPFBa1fAAjEQgW8KKdk1x5n4uqVZ2kdE5Wb7a9qtjhDZg=
X-Received: by 2002:a17:906:7304:: with SMTP id di4mr25909099ejc.179.1635203408832;
 Mon, 25 Oct 2021 16:10:08 -0700 (PDT)
MIME-Version: 1.0
References: <20211025221342.806029-1-eric.dumazet@gmail.com> <20211025221342.806029-3-eric.dumazet@gmail.com>
In-Reply-To: <20211025221342.806029-3-eric.dumazet@gmail.com>
From:   Soheil Hassas Yeganeh <soheil@google.com>
Date:   Mon, 25 Oct 2021 19:09:31 -0400
Message-ID: <CACSApvZiBpLG-CO64BuhjoVypGJwqCNF5AnTWsPCbN3M_vtqFg@mail.gmail.com>
Subject: Re: [PATCH net-next 2/3] tcp: use MAX_TCP_HEADER in tcp_stream_alloc_skb
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 25, 2021 at 6:13 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
>
> Both IPv4 and IPv6 uses same reserve, no need risking
> cache line misses to fetch its value.
>
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Acked-by: Soheil Hassas Yeganeh <soheil@google.com>

> ---
>  net/ipv4/tcp.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index 68dd580dba3d0e04412466868135c49225a4a33b..121400557fde898283a8eae3b09d93479c4a089e 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -867,7 +867,7 @@ struct sk_buff *tcp_stream_alloc_skb(struct sock *sk, int size, gfp_t gfp,
>         if (unlikely(tcp_under_memory_pressure(sk)))
>                 sk_mem_reclaim_partial(sk);
>
> -       skb = alloc_skb_fclone(size + sk->sk_prot->max_header, gfp);
> +       skb = alloc_skb_fclone(size + MAX_TCP_HEADER, gfp);
>         if (likely(skb)) {
>                 bool mem_scheduled;
>
> @@ -878,7 +878,7 @@ struct sk_buff *tcp_stream_alloc_skb(struct sock *sk, int size, gfp_t gfp,
>                         mem_scheduled = sk_wmem_schedule(sk, skb->truesize);
>                 }
>                 if (likely(mem_scheduled)) {
> -                       skb_reserve(skb, sk->sk_prot->max_header);
> +                       skb_reserve(skb, MAX_TCP_HEADER);
>                         /*
>                          * Make sure that we have exactly size bytes
>                          * available to the caller, no more, no less.
> --
> 2.33.0.1079.g6e70778dc9-goog
>
