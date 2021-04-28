Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C472F36D392
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 10:00:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236872AbhD1IBa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 04:01:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbhD1IB3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Apr 2021 04:01:29 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75499C061574;
        Wed, 28 Apr 2021 01:00:45 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id s15so3940154plg.6;
        Wed, 28 Apr 2021 01:00:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eufsFB+S24G/unfRfydnL4H9u1yNCzVjk0IokgKRUiI=;
        b=JOah+FPFTGcu+RHTWSDG1UpKCDTjyBZbQ7+gW9gPxivcyiPotTdUgohHgBDPcC2IOa
         ySnC0wj6PHwhCl2uEZT3KDkyAe7+HqkQk+nWpBYHRZSMuYcTqwZb/4+7GCdpsagDd1/U
         duSKT9Gn7g2VSs3QcCGrt+Uhg9nIBY1WwDkyFbGg64PM1ZUk8y2OHIOkkQHaXMPcAOQU
         I8P/FrerSG/v1dEpIzbOJv773BdIi//MYQchPq1I6JVpFInbNKe6KdRkufiIFJSs/Sno
         0wxZfKcGkyh0ItTQ9AjEOOH7yJlwkG81Ba8n/09GAvoquqWyZ2J3q8trIr+vSeCrQGdW
         rwww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eufsFB+S24G/unfRfydnL4H9u1yNCzVjk0IokgKRUiI=;
        b=SPwXUUOWQ8iyN491bc7bURgLjNVlqw6q124TkzJrhIxbjKDYprhiipVnXJ5gRMhLe2
         ghpecVppUo6qUpriLEIXuUU8PL7fbXORQNmvAtpVYK3Sv42KLKLg8jMeopEkZrcCDWBh
         ojCzICFjeynnlxGvkABM6l75XS6YTfyVQWHhANJTGLgxdb7C6GIlJjXZRr0lED74cqeF
         ecDLaXxvbI25bv95bAeoz6cyUNaASC0zQIjuKddVZ84zqaDuDuyu4mUkdcfGEA6YaOLa
         CqvqqeMN//nrISZWCPPV6OUSltaBSV2CEAT+CuoEkxUqHeAp9ph38rgVPXMVLETMydOm
         Ufeg==
X-Gm-Message-State: AOAM5320JMThnArE5Z5MrftbCXtISujFlQGDkl/BDt+y01gmz56Ng9+g
        Vxh2Wls6uCNK/HuFnZpplo6y7iD9KA2ZuJ+A90k=
X-Google-Smtp-Source: ABdhPJwQwjXljH6I0hk9H1ANsV+D67h79AzDUrQ+DqFIcjXt68IrZfNDkL2S6BW8bF+jbUCuqBk4Fq7rWa9TOe32q80=
X-Received: by 2002:a17:902:b494:b029:e7:36be:9ce7 with SMTP id
 y20-20020a170902b494b02900e736be9ce7mr28836917plr.43.1619596844874; Wed, 28
 Apr 2021 01:00:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210427121903.76556-1-xuanzhuo@linux.alibaba.com>
In-Reply-To: <20210427121903.76556-1-xuanzhuo@linux.alibaba.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Wed, 28 Apr 2021 10:00:33 +0200
Message-ID: <CAJ8uoz3fphwV9115NLpOi94w2N0j1Cn3DRJFJ2NvwA91zf+uBw@mail.gmail.com>
Subject: Re: [PATCH bpf] xsk: fix for xp_aligned_validate_desc() when len == chunk_size
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     bpf <bpf@vger.kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 27, 2021 at 2:19 PM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
>
> When desc->len is equal to chunk_size, it is legal. But
> xp_aligned_validate_desc() got "chunk_end" by desc->addr + desc->len
> pointing to the next chunk during the check, which caused the check to
> fail.

Thanks Xuan for the fix. Off-by-one error. A classic unfortunately.

Think your fix also makes it easier to understand the code too, so good.

> Fixes: 35fcde7f8deb ("xsk: support for Tx")
> Fixes: bbff2f321a86 ("xsk: new descriptor addressing scheme")

Just did some quick research and it seems the bug was introduced in
the bbff2f321a86 commit above, not the first one 35fcde7f8deb. Or am I
mistaken?

> Fixes: 2b43470add8c ("xsk: Introduce AF_XDP buffer allocation API")
> Fixes: 26062b185eee ("xsk: Explicitly inline functions and move definitions")

And in these two, the code was moved around first to a new function in
2b43470add8c, then this function was moved to a new file in
26062b185eee. I believe documenting this in your commit message would
make life simpler for the nice people backporting this fix. Or is this
implicit in the multiple Fixes tags? Could someone with more
experience in these things comment please.

Thank you: Magnus

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>  net/xdp/xsk_queue.h | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
> index 2823b7c3302d..40f359bf2044 100644
> --- a/net/xdp/xsk_queue.h
> +++ b/net/xdp/xsk_queue.h
> @@ -128,13 +128,12 @@ static inline bool xskq_cons_read_addr_unchecked(struct xsk_queue *q, u64 *addr)
>  static inline bool xp_aligned_validate_desc(struct xsk_buff_pool *pool,
>                                             struct xdp_desc *desc)
>  {
> -       u64 chunk, chunk_end;
> +       u64 chunk;
>
> -       chunk = xp_aligned_extract_addr(pool, desc->addr);
> -       chunk_end = xp_aligned_extract_addr(pool, desc->addr + desc->len);
> -       if (chunk != chunk_end)
> +       if (desc->len > pool->chunk_size)
>                 return false;
>
> +       chunk = xp_aligned_extract_addr(pool, desc->addr);
>         if (chunk >= pool->addrs_cnt)
>                 return false;
>
> --
> 2.31.0
>
