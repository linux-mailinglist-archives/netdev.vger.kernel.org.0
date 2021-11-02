Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A7C24429AE
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 09:41:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231165AbhKBIng (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 04:43:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbhKBInf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 04:43:35 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 386DEC061764
        for <netdev@vger.kernel.org>; Tue,  2 Nov 2021 01:41:01 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id y11so638849oih.7
        for <netdev@vger.kernel.org>; Tue, 02 Nov 2021 01:41:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E8uts31KP1x8Vwf2R26LKxne8Xd07z9YxFVKxZRVcaM=;
        b=Dxtiz28ltW1Att3Q8CC+m+np4BTD/7U1Oa//7aYrDjKyyLizB2L7Ail53JQKs6WF4V
         l2a2tC9CDYgFumK/41aZnGHy3bOhpTsOFIUcCwTmAbF97Q5zzENjE5WQYbE1U69VHtGM
         pWjRckFfIWdjU+kuMWkcONV6DSTFUWMZaFcebDYgyEv2nXcXod6YSDLHtWHQ4zVjgrHG
         pSlu+HhBKFNcQMDYL0aMlKDbsryKmj21X62/Q2WBEcHxqmLZQnSqpltOFT4FJOoah84L
         pmYhCrSH1PWVtFmHG5Xn5cbvrRraTP1mi+wx4Qv24LDy/IgltOAfcZJtfxk+0m0PzSCw
         0suA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E8uts31KP1x8Vwf2R26LKxne8Xd07z9YxFVKxZRVcaM=;
        b=zdGrz9KxM+TfdpYnXO/BR0UNJpEkeSSiJJSwZIxgFT5UJvUOWrFzr3shZuIGvkjTZE
         TL+YX2jDKsJf+tCHyCk1S62KA/BfNNTaszuTEh6m7w/0XSwoZR2ktG934p7hwbuOFkX0
         EkcM9eTFDBIsW3Ss+BJ5iflSHEaFnpBZMb3Kj7KI/jHXJZpgen2IaUGhOtcMAYSDHUmQ
         fi5Zry22cB3lbpsrvsVaEIgqyxtgo+Ng4L7Ey0MHQG94APzfzKh+5a7Ya3Hp84z2UnD3
         YizlfEen7z9ltmG4vhSTLVVZs2axZMZmJXAZdfVGd8gwiTGZIwXrXPYZSURTVcpldgF+
         2lbQ==
X-Gm-Message-State: AOAM531U+fqhJL251jIBF4g8y3RnTbUbonE5Ky1xaibFXlrNw68igh/j
        wxr+6TRYJmEXcrmQnjZYAq7NmsWdoKyJBt7kSVZpPtH1d4Q70A==
X-Google-Smtp-Source: ABdhPJyz6AmF2GK+V2NPE5KnY0oEb21zSKH+4ZIAJ7AH+wUDvM96bmGWCqoE/QCRsgvAPIS3Jt2rzBBjXeUQh6dMTms=
X-Received: by 2002:a05:6808:6ce:: with SMTP id m14mr3718570oih.134.1635842460236;
 Tue, 02 Nov 2021 01:41:00 -0700 (PDT)
MIME-Version: 1.0
References: <20211102004555.1359210-1-eric.dumazet@gmail.com>
In-Reply-To: <20211102004555.1359210-1-eric.dumazet@gmail.com>
From:   Marco Elver <elver@google.com>
Date:   Tue, 2 Nov 2021 09:40:48 +0100
Message-ID: <CANpmjNM0iTZjrsxCam6JJ_gjJP+bXMfaVsw6Vfd56oD6d1rV0w@mail.gmail.com>
Subject: Re: [PATCH net] net: add and use skb_unclone_keeptruesize() helper
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2 Nov 2021 at 01:46, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
>
> While commit 097b9146c0e2 ("net: fix up truesize of cloned
> skb in skb_prepare_for_shift()") fixed immediate issues found
> when KFENCE was enabled/tested, there are still similar issues,
> when tcp_trim_head() hits KFENCE while the master skb
> is cloned.
>
> This happens under heavy networking TX workloads,
> when the TX completion might be delayed after incoming ACK.
>
> This patch fixes the WARNING in sk_stream_kill_queues
> when sk->sk_mem_queued/sk->sk_forward_alloc are not zero.
>
> Fixes: d3fb45f370d9 ("mm, kfence: insert KFENCE hooks for SLAB")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Marco Elver <elver@google.com>

Acked-by: Marco Elver <elver@google.com>

Thanks.

> ---
>  include/linux/skbuff.h | 16 ++++++++++++++++
>  net/core/skbuff.c      | 14 +-------------
>  net/ipv4/tcp_output.c  |  6 +++---
>  3 files changed, 20 insertions(+), 16 deletions(-)
>
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 841e2f0f5240ba9e210bb9a3fc1cbedc2162b2a8..b8c273af2910c780dcfbc8f18fc05e115089010b 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -1671,6 +1671,22 @@ static inline int skb_unclone(struct sk_buff *skb, gfp_t pri)
>         return 0;
>  }
>
> +/* This variant of skb_unclone() makes sure skb->truesize is not changed */
> +static inline int skb_unclone_keeptruesize(struct sk_buff *skb, gfp_t pri)
> +{
> +       might_sleep_if(gfpflags_allow_blocking(pri));
> +
> +       if (skb_cloned(skb)) {
> +               unsigned int save = skb->truesize;
> +               int res;
> +
> +               res = pskb_expand_head(skb, 0, 0, pri);
> +               skb->truesize = save;
> +               return res;
> +       }
> +       return 0;
> +}
> +
>  /**
>   *     skb_header_cloned - is the header a clone
>   *     @skb: buffer to check
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index fe9358437380c826d6438efe939afc4b38135cff..38d7dee4bbe9e96a811ff9cfca33429b5f7dbff1 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -3449,19 +3449,7 @@ EXPORT_SYMBOL(skb_split);
>   */
>  static int skb_prepare_for_shift(struct sk_buff *skb)
>  {
> -       int ret = 0;
> -
> -       if (skb_cloned(skb)) {
> -               /* Save and restore truesize: pskb_expand_head() may reallocate
> -                * memory where ksize(kmalloc(S)) != ksize(kmalloc(S)), but we
> -                * cannot change truesize at this point.
> -                */
> -               unsigned int save_truesize = skb->truesize;
> -
> -               ret = pskb_expand_head(skb, 0, 0, GFP_ATOMIC);
> -               skb->truesize = save_truesize;
> -       }
> -       return ret;
> +       return skb_unclone_keeptruesize(skb, GFP_ATOMIC);
>  }
>
>  /**
> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> index 6d72f3ea48c4ef0d193ec804653e4d4321f3f20a..0492f6942778db21f855216bf4387682fb37091e 100644
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -1562,7 +1562,7 @@ int tcp_fragment(struct sock *sk, enum tcp_queue tcp_queue,
>                 return -ENOMEM;
>         }
>
> -       if (skb_unclone(skb, gfp))
> +       if (skb_unclone_keeptruesize(skb, gfp))
>                 return -ENOMEM;
>
>         /* Get a new skb... force flag on. */
> @@ -1672,7 +1672,7 @@ int tcp_trim_head(struct sock *sk, struct sk_buff *skb, u32 len)
>  {
>         u32 delta_truesize;
>
> -       if (skb_unclone(skb, GFP_ATOMIC))
> +       if (skb_unclone_keeptruesize(skb, GFP_ATOMIC))
>                 return -ENOMEM;
>
>         delta_truesize = __pskb_trim_head(skb, len);
> @@ -3184,7 +3184,7 @@ int __tcp_retransmit_skb(struct sock *sk, struct sk_buff *skb, int segs)
>                                  cur_mss, GFP_ATOMIC))
>                         return -ENOMEM; /* We'll try again later. */
>         } else {
> -               if (skb_unclone(skb, GFP_ATOMIC))
> +               if (skb_unclone_keeptruesize(skb, GFP_ATOMIC))
>                         return -ENOMEM;
>
>                 diff = tcp_skb_pcount(skb);
> --
> 2.33.1.1089.g2158813163f-goog
>
