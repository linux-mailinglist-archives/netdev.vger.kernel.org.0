Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F2AC396858
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 21:27:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232023AbhEaT3J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 15:29:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231201AbhEaT3H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 15:29:07 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16811C06174A
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 12:27:26 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id b13so17870813ybk.4
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 12:27:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YaMl4hY+yuZOtEDwcdF7xmfj7nQN6TzRsyNwIeXiUWs=;
        b=XAlgrQ1fY9ojsBt/YYDQGsJM8rjHda5/JeVAYUJCJqNIb5Nc4ucPyOvBppbLTyL5QF
         7zBO+p11vzb+lY+s39qNrdPUpHLVcu9ZhLEny2c1cyg48jJeyxuwzbBmArgU+4F/1OaR
         piRxZrk0trWRmwf3pXQsjJI4vUqOXXHI7m5CfTs+d5a0FFhdaaOEEFdfLzbQVcuAdbVk
         oLLWyT9hXaOus2QX4OP8lHHehPLzmidbijb6yHDLuUOSh02xbPKNIiIpXxOPNYvQs1+U
         GvKjw51ByNv5Jcf4FZ28Iy03QkuKkgK1uwWH68TxfsdbeL62fjjyj24T0oFeP9RLp0lm
         X1Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YaMl4hY+yuZOtEDwcdF7xmfj7nQN6TzRsyNwIeXiUWs=;
        b=UvfN7UW0X2Pj6gOYQ2UIXCs8S+0CdS6GyesY7Bn0YG3WNn5sdvAcKsHSvVLK48E68m
         dOl4GsP0Ng8SZxwgHt4bz0tad5bhwS2hil3mT/HQilGBefJ5lGvXqCi/LBVcnpUFPFll
         cFti/+UjSuW6KiYkoPT+3j0iwJ6haU4c93Mo5uj57LqcGm5/bTaQuanu81lTXhEjtIOx
         3mEwBTl/Bje3KDGD2R4K3cutXjnzKBEuJTGRtS8O1hivRKlmbVqs9povcxVkG6Rc+w2k
         krIzfPpgMz55mWt5NHfVWO/vlqgaWsV/Pq08vNVvCPeLuJZ9QdJWyjxGnOsbBLpTizVr
         2aVA==
X-Gm-Message-State: AOAM533eG0yuKrdptuZWLrwotldFrmYXIc8jUwcskHT0WC4a/SHUzs1t
        6ZKEmBgAx72f7QpMyqRxlsVRlHLhWF/GsDqYczwp9eRDyIA=
X-Google-Smtp-Source: ABdhPJw9rly7xEwfbSw6PIINop5zUqFo4lC6dTaqh0RHhmepKUvoa14ZpLWm0Y9DafntW2OtjYoApw03soM447bCDkc=
X-Received: by 2002:a25:850b:: with SMTP id w11mr32708649ybk.518.1622489244893;
 Mon, 31 May 2021 12:27:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210529110746.6796-1-w@1wt.eu>
In-Reply-To: <20210529110746.6796-1-w@1wt.eu>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 31 May 2021 21:27:13 +0200
Message-ID: <CANn89iJsTNoWNZ1rvkQB8a6ROTvh_85P+TuffS0_w5CpJW+4bg@mail.gmail.com>
Subject: Re: [PATCH net-next] ipv6: use prandom_u32() for ID generation
To:     Willy Tarreau <w@1wt.eu>
Cc:     netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Amit Klein <aksecurity@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 29, 2021 at 1:08 PM Willy Tarreau <w@1wt.eu> wrote:
>
> This is a complement to commit aa6dd211e4b1 ("inet: use bigger hash
> table for IP ID generation"), but focusing on some specific aspects
> of IPv6.
>
> Contary to IPv4, IPv6 only uses packet IDs with fragments, and with a
> minimum MTU of 1280, it's much less easy to force a remote peer to
> produce many fragments to explore its ID sequence. In addition packet
> IDs are 32-bit in IPv6, which further complicates their analysis. On
> the other hand, it is often easier to choose among plenty of possible
> source addresses and partially work around the bigger hash table the
> commit above permits, which leaves IPv6 partially exposed to some
> possibilities of remote analysis at the risk of weakening some
> protocols like DNS if some IDs can be predicted with a good enough
> probability.
>
> Given the wide range of permitted IDs, the risk of collision is extremely
> low so there's no need to rely on the positive increment algorithm that
> is shared with the IPv4 code via ip_idents_reserve(). We have a fast
> PRNG, so let's simply call prandom_u32() and be done with it.
>
> Performance measurements at 10 Gbps couldn't show any difference with
> the previous code, even when using a single core, because due to the
> large fragments, we're limited to only ~930 kpps at 10 Gbps and the cost
> of the random generation is completely offset by other operations and by
> the network transfer time. In addition, this change removes the need to
> update a shared entry in the idents table so it may even end up being
> slightly faster on large scale systems where this matters.
>
> The risk of at least one collision here is about 1/80 million among
> 10 IDs, 1/850k among 100 IDs, and still only 1/8.5k among 1000 IDs,
> which remains very low compared to IPv4 where all IDs are reused
> every 4 to 80ms on a 10 Gbps flow depending on packet sizes.
>
> Reported-by: Amit Klein <aksecurity@gmail.com>
> Cc: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Willy Tarreau <w@1wt.eu>

Reviewed-by: Eric Dumazet <edumazet@google.com>

> ---
>  net/ipv6/output_core.c | 28 +++++-----------------------
>  1 file changed, 5 insertions(+), 23 deletions(-)
>
> diff --git a/net/ipv6/output_core.c b/net/ipv6/output_core.c
> index af36acc1a644..2880dc7d9a49 100644
> --- a/net/ipv6/output_core.c
> +++ b/net/ipv6/output_core.c
> @@ -15,29 +15,11 @@ static u32 __ipv6_select_ident(struct net *net,
>                                const struct in6_addr *dst,
>                                const struct in6_addr *src)
>  {
> -       const struct {
> -               struct in6_addr dst;
> -               struct in6_addr src;
> -       } __aligned(SIPHASH_ALIGNMENT) combined = {
> -               .dst = *dst,
> -               .src = *src,
> -       };
> -       u32 hash, id;
> -
> -       /* Note the following code is not safe, but this is okay. */
> -       if (unlikely(siphash_key_is_zero(&net->ipv4.ip_id_key)))
> -               get_random_bytes(&net->ipv4.ip_id_key,
> -                                sizeof(net->ipv4.ip_id_key));
> -
> -       hash = siphash(&combined, sizeof(combined), &net->ipv4.ip_id_key);
> -
> -       /* Treat id of 0 as unset and if we get 0 back from ip_idents_reserve,
> -        * set the hight order instead thus minimizing possible future
> -        * collisions.
> -        */
> -       id = ip_idents_reserve(hash, 1);
> -       if (unlikely(!id))
> -               id = 1 << 31;
> +       u32 id;
> +
> +       do {
> +               id = prandom_u32();
> +       } while (!id);
>
>         return id;
>  }
> --
> 2.17.5
>
