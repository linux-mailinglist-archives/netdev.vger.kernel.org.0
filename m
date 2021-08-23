Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0D003F4F78
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 19:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230506AbhHWR0k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 13:26:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbhHWR0j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 13:26:39 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89EA0C061575;
        Mon, 23 Aug 2021 10:25:56 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id n12so27318898edx.8;
        Mon, 23 Aug 2021 10:25:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Tn0lc6r/k3tCfWO6f7rPJPlrsVx45yPIfTd+tcFrbJo=;
        b=AG/Zg8l9PaDXmc4D/DOzzON5OglkFRojuTDyHl1iOkFSZMpGTmo9Dy4bxNJsiIbp/Y
         KsUvgMcqUsNFY0zyrqoSLJUHvJhfIJAvalDs/y5ZOObj3yBjsklZE0xDyxeM6AfYfHaf
         sxn8X2T++0A+8doFpXX977UuUf7M6g8ej5fLwiJ5dt4JDW9UUINV1iBeLy/7q4EwhJhn
         FXxCm60B3MWqB2I5pobH2d3u41IA7ItOpDEB3TKJ7nmY8kylLj8pKrkAVF0L4CF2o93W
         LAbYxQ73FU/OYUapYu7vN+sBHomDcouL5YsnTnGNcSgqahZ9C73Jx1TQrexII6Hp+jyp
         NxLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Tn0lc6r/k3tCfWO6f7rPJPlrsVx45yPIfTd+tcFrbJo=;
        b=ca9wPfG/73vAXlGKLqQNgsy4XgrWmXSRgwqTkAbU3fCrD9pigJ2h2iWvZ2yJHQWhRt
         GAwvJjkZDzAF1j4/4UXOXifPQTiekkP2o3VRmXJwnQMvipPVcR/DnFQfxyZkxo1eQpzS
         n6ZLxwCFV27ALFDRrPthzW4wpClvXyWfPjNmx0KYdm1AtlOMJabhJEPTjSF+V9BSrSQr
         5cbvvc5JdTlv19cj+uHvHODa3s2FWfhjlo8WGOUeFLEM5KBpIMbK2zH8aN6r8hGQpc0T
         LMXkjqCzmmA0uhSztcKPOwsSjXqe3jz1U+wsLObZGldsX8zC0A5fZonj5VO8lwAygooN
         LM2Q==
X-Gm-Message-State: AOAM533xlQwSs5QD2fGpqG+QgizcUr4Xkh/K5Rc+wuYbRgp/fjK+qr1S
        57GQDFNO8jMBqp1LEJPtwDJ5xTmtNv8+5iLI6TFVr43it6gPuw==
X-Google-Smtp-Source: ABdhPJwNkSiTV+ioCeqvpes518/x3+nsxexUHnGPIn3O5peCtfvMEUDfm3JualhXrZUgXsFnFnyRGKhuy2XchOWT3XY=
X-Received: by 2002:aa7:d681:: with SMTP id d1mr39260570edr.186.1629739554952;
 Mon, 23 Aug 2021 10:25:54 -0700 (PDT)
MIME-Version: 1.0
References: <6858f130-e6b4-1ba7-ed6f-58c00152be69@virtuozzo.com> <ef4458d9-c4d7-f419-00f2-0f1cea5140ce@virtuozzo.com>
In-Reply-To: <ef4458d9-c4d7-f419-00f2-0f1cea5140ce@virtuozzo.com>
From:   Christoph Paasch <christoph.paasch@gmail.com>
Date:   Mon, 23 Aug 2021 10:25:43 -0700
Message-ID: <CALMXkpZkW+ULMMFgeY=cag1F0=891F-v9NEVcdn7Tyd-VUWGYA@mail.gmail.com>
Subject: Re: [PATCH NET-NEXT] ipv6: skb_expand_head() adjust skb->truesize incorrectly
To:     Vasily Averin <vvs@virtuozzo.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, kernel@openvz.org,
        Julian Wiedmann <jwi@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Mon, Aug 23, 2021 at 12:56 AM Vasily Averin <vvs@virtuozzo.com> wrote:
>
> Christoph Paasch reports [1] about incorrect skb->truesize
> after skb_expand_head() call in ip6_xmit.
> This happen because skb_set_owner_w() for newly clone skb is called
> too early, before pskb_expand_head() where truesize is adjusted for
> (!skb-sk) case.
>
> [1] https://lkml.org/lkml/2021/8/20/1082
>
> Reported-by: Christoph Paasch <christoph.paasch@gmail.com>
> Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
> ---
>  net/core/skbuff.c | 24 +++++++++++++-----------
>  1 file changed, 13 insertions(+), 11 deletions(-)
>
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index f931176..508d5c4 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -1803,6 +1803,8 @@ struct sk_buff *skb_realloc_headroom(struct sk_buff *skb, unsigned int headroom)
>
>  struct sk_buff *skb_expand_head(struct sk_buff *skb, unsigned int headroom)
>  {
> +       struct sk_buff *oskb = skb;
> +       struct sk_buff *nskb = NULL;
>         int delta = headroom - skb_headroom(skb);
>
>         if (WARN_ONCE(delta <= 0,
> @@ -1811,21 +1813,21 @@ struct sk_buff *skb_expand_head(struct sk_buff *skb, unsigned int headroom)
>
>         /* pskb_expand_head() might crash, if skb is shared */
>         if (skb_shared(skb)) {
> -               struct sk_buff *nskb = skb_clone(skb, GFP_ATOMIC);
> -
> -               if (likely(nskb)) {
> -                       if (skb->sk)
> -                               skb_set_owner_w(nskb, skb->sk);
> -                       consume_skb(skb);
> -               } else {
> -                       kfree_skb(skb);
> -               }
> +               nskb = skb_clone(skb, GFP_ATOMIC);
>                 skb = nskb;
>         }
>         if (skb &&
> -           pskb_expand_head(skb, SKB_DATA_ALIGN(delta), 0, GFP_ATOMIC)) {
> -               kfree_skb(skb);
> +           pskb_expand_head(skb, SKB_DATA_ALIGN(delta), 0, GFP_ATOMIC))
>                 skb = NULL;
> +
> +       if (!skb) {
> +               kfree_skb(oskb);
> +               if (nskb)
> +                       kfree_skb(nskb);
> +       } else if (nskb) {
> +               if (oskb->sk)
> +                       skb_set_owner_w(nskb, oskb->sk);
> +               consume_skb(oskb);

sorry, this does not fix the problem. The syzkaller repro still
triggers the WARN.

When it happens, the skb in ip6_xmit() is not shared as it comes from
__tcp_transmit_skb, where it is skb_clone()'d.


Christoph

>         }
>         return skb;
>  }
> --
> 1.8.3.1
>
