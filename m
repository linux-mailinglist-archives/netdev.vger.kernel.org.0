Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A36D2E0BF6
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 15:45:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727689AbgLVOo5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 09:44:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727452AbgLVOo4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 09:44:56 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56378C061793
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 06:44:16 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id g20so18604354ejb.1
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 06:44:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/apQBmIE+eRmGfxUP2AaP3keXDSxAJxxcb6srxtXySA=;
        b=lQnkPWxQH/f4zHFjB577T5xdaPOP/85mW9iN+kWsKZLHZPGHQ83o/9sE3Kb3DK+Eyz
         RNS4veOVNk6oVoDScSfIHysv86J99eF0awMopRNfTac3ncXkZSz7u2yXC1Nk98hBmZ9z
         TXnrg0JKBP9zaClGXcUaECwNoGG2i83wV5JTgtzsx7SGuP3rX50twhG/eSKNzH6NKRG8
         v13zjit2QHbPCn6/m18/nVXQoYknskcqOcsecpFufR/NtaWqGdmOnvuofXHo/0vomLTq
         D/WDPEfNOVDy/o4WuZd5hqpeJg2U1LDTVp6vZelUSGK//Uii1xkFVgBrJaJjBOnxADrZ
         JQ3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/apQBmIE+eRmGfxUP2AaP3keXDSxAJxxcb6srxtXySA=;
        b=Q+mavEYsDgJWLhkRY1Tve1b/1d1jKU45EGuyLDHiZ948M4ykeJ7sObIAcuW3MIXTvW
         n5L6+uTVwJ7Nm4vHvrhgU5uduhrqE1N5FBR4Bo+E1mjP4/75Q1QzV2dKbgagxCEOpgJ0
         A884BKlSJhk7b5TBcVOfBfBf2Wk31LocGdKRVK0gpN6d5zLLBsrBmIT7H7vrxB+OsJxq
         kNQQiJDi3yKvKZpEx5SDpDO2RcpiiYJO4EaN30vLWXt4pkWrK72dhxEFPRYe0hCPMGDo
         K/9l+ObM2lCji1IHBJFhVnzu/Sm9WLlltRuB2VM4Axeb8m55/Qy2aeW8MnoDDwb6Vo3L
         CZSA==
X-Gm-Message-State: AOAM532E+cH0d2Pp7Qn5msoO3/m6EjP762eM+Ao7h6r56p7duSpmUhJs
        eKNlA6RQEBy6VM8dkCPWhbWaBzefITuCkADNCV40tstY
X-Google-Smtp-Source: ABdhPJz2KNfAhl6tCGwqtHnEDR8tQvRvmwOLihT1StN/sZbri+RuIjFUnuhK9vR+e7Q6bMeGPseQhkdeRrPIpGntW5c=
X-Received: by 2002:a17:906:e94c:: with SMTP id jw12mr20615624ejb.56.1608648255147;
 Tue, 22 Dec 2020 06:44:15 -0800 (PST)
MIME-Version: 1.0
References: <20201222000926.1054993-1-jonathan.lemon@gmail.com> <20201222000926.1054993-5-jonathan.lemon@gmail.com>
In-Reply-To: <20201222000926.1054993-5-jonathan.lemon@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 22 Dec 2020 09:43:39 -0500
Message-ID: <CAF=yD-K7bWE-U-O2J2Bwwi3E0NrX+horDARRgmBUU8Pqh6pH3Q@mail.gmail.com>
Subject: Re: [PATCH 04/12 v2 RFC] skbuff: Push status and refcounts into sock_zerocopy_callback
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 21, 2020 at 7:09 PM Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
>
> From: Jonathan Lemon <bsd@fb.com>
>
> Before this change, the caller of sock_zerocopy_callback would
> need to save the zerocopy status, decrement and check the refcount,
> and then call the callback function - the callback was only invoked
> when the refcount reached zero.
>
> Now, the caller just passes the status into the callback function,
> which saves the status and handles its own refcounts.
>
> This makes the behavior of the sock_zerocopy_callback identical
> to the tpacket and vhost callbacks.
>
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> ---
>  include/linux/skbuff.h |  3 ---
>  net/core/skbuff.c      | 14 +++++++++++---
>  2 files changed, 11 insertions(+), 6 deletions(-)
>
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index fb6dd6af0f82..c9d7de9d624d 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -1482,9 +1482,6 @@ static inline void skb_zcopy_clear(struct sk_buff *skb, bool zerocopy)
>         if (uarg) {
>                 if (skb_zcopy_is_nouarg(skb)) {
>                         /* no notification callback */
> -               } else if (uarg->callback == sock_zerocopy_callback) {
> -                       uarg->zerocopy = uarg->zerocopy && zerocopy;
> -                       sock_zerocopy_put(uarg);
>                 } else {
>                         uarg->callback(uarg, zerocopy);
>                 }
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index ea32b3414ad6..73699dbdc4a1 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -1194,7 +1194,7 @@ static bool skb_zerocopy_notify_extend(struct sk_buff *skb, u32 lo, u16 len)
>         return true;
>  }
>
> -void sock_zerocopy_callback(struct ubuf_info *uarg, bool success)
> +static void __sock_zerocopy_callback(struct ubuf_info *uarg)
>  {
>         struct sk_buff *tail, *skb = skb_from_uarg(uarg);
>         struct sock_exterr_skb *serr;
> @@ -1222,7 +1222,7 @@ void sock_zerocopy_callback(struct ubuf_info *uarg, bool success)
>         serr->ee.ee_origin = SO_EE_ORIGIN_ZEROCOPY;
>         serr->ee.ee_data = hi;
>         serr->ee.ee_info = lo;
> -       if (!success)
> +       if (!uarg->zerocopy)
>                 serr->ee.ee_code |= SO_EE_CODE_ZEROCOPY_COPIED;
>
>         q = &sk->sk_error_queue;
> @@ -1241,11 +1241,19 @@ void sock_zerocopy_callback(struct ubuf_info *uarg, bool success)
>         consume_skb(skb);
>         sock_put(sk);
>  }
> +
> +void sock_zerocopy_callback(struct ubuf_info *uarg, bool success)
> +{
> +       uarg->zerocopy = uarg->zerocopy & success;
> +
> +       if (refcount_dec_and_test(&uarg->refcnt))
> +               __sock_zerocopy_callback(uarg);
> +}
>  EXPORT_SYMBOL_GPL(sock_zerocopy_callback);

I still think this helper is unnecessary. Just return immediately in
existing sock_zerocopy_callback if refcount is not zero.

>  void sock_zerocopy_put(struct ubuf_info *uarg)
>  {
> -       if (uarg && refcount_dec_and_test(&uarg->refcnt))
> +       if (uarg)
>                 uarg->callback(uarg, uarg->zerocopy);
>  }
>  EXPORT_SYMBOL_GPL(sock_zerocopy_put);

This does increase the number of indirect function calls. Which are
not cheap post spectre.

In the common case for msg_zerocopy we only have two clones, one sent
out and one on the retransmit queue. So I guess the cost will be
acceptable.
