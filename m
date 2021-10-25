Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF7443A7FE
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 01:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232792AbhJYXMz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 19:12:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230464AbhJYXMz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 19:12:55 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 693D1C061767
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 16:10:32 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id u13so5728700edy.10
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 16:10:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=q9nYLFY16TpSUSeiU/susrMvUEGG5Bn8jAFAq+AkdM0=;
        b=cS3cstA4yfOqBjNC7/3/JTw8AyVUEWpvTJdGLaho2Vp2S9kxsTxXWbL21IMlEZc7GL
         iXSJQNu6tpgzO9kuFx8xzQOT5+8Hf6fCOwzXRZvrBqKRcdIzw2ARFV4taK3taL1Jwpaw
         wxqSg+CQ3s27fp9tI8tKSGoRjoiXaiy+DT781/lVowFfgzQK3Hd6lxOZRorfBfW32BFh
         XPUS4KvqVu1aNif1fT/78/G2HgHoO6gWhfg2wCfSJ4Kvq1XTJJgfe79O8jcRxfApnSur
         YThIGWx8+qWgiUTvskA8A1tZJCMmHJFa6iun+3Kupr860TaTMBR9luY1RPqcp/l9HJrn
         IOww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=q9nYLFY16TpSUSeiU/susrMvUEGG5Bn8jAFAq+AkdM0=;
        b=TbWHYhXGaLHCgxWJXI/yZOU+taF2JbvIAnGNkpO5vc1KCQvxKYi43gqyDaBQ35TJNK
         cYFJq/SbW5ttoMA4vpDHVsjioAsNR15p8/DavBB+5WCdJYuHxTfVFsxRJkoQJKjpvvZx
         RNTJZXb6z1fU/LEUlwUWya7T/fCbHIvtFQtDyNtijMB3Xzps8RPVvQGoYIQf3AGMC5tK
         60ua8ZBBAEze7743puDZB5cBXU4bJgcSzVHGSbX2mVi3iA3lLnFDJfNF1ZxaDYejjavp
         baqZHKHwaThBaM2GJxQtkZCjDhXftitz7SfKODFXEXGDJpGjQ+VRVFi6+K8Q9RkfHMJ7
         +7fA==
X-Gm-Message-State: AOAM5309PbvCWRQ2+AhoShMiioglAVWPJs9xYvelyYr1AFj5Fs5fewYs
        u+N0/94Fa6I6qL8rpUmBopp+6B4yqddiArVZo7wFBg==
X-Google-Smtp-Source: ABdhPJzJSLBhJuaQI88QwX1JmYhOhevLFc/6Vp/N5jcHcU5ZTRnrtXntToP0wZxpTIEVDMSon9NvQv+vZb+nKKEQknM=
X-Received: by 2002:a05:6402:2d0:: with SMTP id b16mr15142194edx.193.1635203430784;
 Mon, 25 Oct 2021 16:10:30 -0700 (PDT)
MIME-Version: 1.0
References: <20211025221342.806029-1-eric.dumazet@gmail.com> <20211025221342.806029-4-eric.dumazet@gmail.com>
In-Reply-To: <20211025221342.806029-4-eric.dumazet@gmail.com>
From:   Soheil Hassas Yeganeh <soheil@google.com>
Date:   Mon, 25 Oct 2021 19:09:54 -0400
Message-ID: <CACSApva-YtkNDw7a=zJ1QuFdhv8tiLsavfbNp6+93yW62k0g2A@mail.gmail.com>
Subject: Re: [PATCH net-next 3/3] tcp: remove unneeded code from tcp_stream_alloc_skb()
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
> Aligning @size argument to 4 bytes is not needed.
>
> The header alignment has nothing to do with @size.
>
> It really depends on skb->head alignment and MAX_TCP_HEADER.
>
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Acked-by: Soheil Hassas Yeganeh <soheil@google.com>

> ---
>  net/ipv4/tcp.c | 3 ---
>  1 file changed, 3 deletions(-)
>
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index 121400557fde898283a8eae3b09d93479c4a089e..0a27b7ef1a9db8aea8d98cff4b8ab7092994febd 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -861,9 +861,6 @@ struct sk_buff *tcp_stream_alloc_skb(struct sock *sk, int size, gfp_t gfp,
>  {
>         struct sk_buff *skb;
>
> -       /* The TCP header must be at least 32-bit aligned.  */
> -       size = ALIGN(size, 4);
> -
>         if (unlikely(tcp_under_memory_pressure(sk)))
>                 sk_mem_reclaim_partial(sk);
>
> --
> 2.33.0.1079.g6e70778dc9-goog
>
