Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 226282DF117
	for <lists+netdev@lfdr.de>; Sat, 19 Dec 2020 19:47:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727392AbgLSSrf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Dec 2020 13:47:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727218AbgLSSrf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Dec 2020 13:47:35 -0500
Received: from mail-vs1-xe2c.google.com (mail-vs1-xe2c.google.com [IPv6:2607:f8b0:4864:20::e2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8EA1C0613CF
        for <netdev@vger.kernel.org>; Sat, 19 Dec 2020 10:46:54 -0800 (PST)
Received: by mail-vs1-xe2c.google.com with SMTP id x4so3218812vsp.7
        for <netdev@vger.kernel.org>; Sat, 19 Dec 2020 10:46:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9ayo74a5X1APE7vZ7BNFur2Lc5fy7ljF2MI9q7oEV2A=;
        b=j6UQKoUqc7uJrgzzoXrfKAEwYcnAF27HN1lUCek1MELO958LGENZAYNo4TpnOiHP8b
         YFhnwfz8Cycfo1vKrpIA5ogFHl11NAdSby3k8f2tdb7sHkbOqldl2BMv+aC2Dx4psh4r
         PxVRjsmfBjAoJRufOIRgSILa6uHDri10b2S0ur7yQI/1b23RANsD1BodcFefcK4vwL+z
         8wFWEQEU1tocBOUYhyXHpiYji+yUXK+vUJUcQcaYffFdoZ0Wul3unWWmLNQfgSu76t0T
         iBtKs6kqSI3CdVXJ1O4+oENJaU6foCTYC3bRjsgaMOPks3EvhA3IpcjJvwZt1Qi67Frr
         TISQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9ayo74a5X1APE7vZ7BNFur2Lc5fy7ljF2MI9q7oEV2A=;
        b=kQRdr5tAIZaTu5P4P+XKrb8gfaOkILTUW1FnjUp9W2z4RtFiHU9knUGM4fKVYXXLrb
         +tNj7SArc4bYqOrWkOrLyiAWOv5VY55t7/70AdtTZCYFnwdpvQ6Q1MKWGaturj3BhZwX
         ZxdN0eH+aSwdabQsB24oMq7Q/ROHwCxgpcwGsLsZmxdjoLabdn9P6Z+umedmg0qy/UGy
         7kjDLIAbnK9jMU+xoDwC/6P8Y3O8xIJVc8JuCBlZVApEVcyZQ0eLevmbYcoA9tBjNv38
         IxGHJhnvB1caO9Mhd/6HwjyogbdcZsnmy6jPeDvhfB4mj6EbvMmdgynBEpue80GpqPrm
         Sxtw==
X-Gm-Message-State: AOAM533HbGKL2UIZkhKFSthSuYKWtASWJaomtqgajM+iPSc8rCUIfHAJ
        4thjULuzZxuOn3pRjeE+LO4UtY7yN4E=
X-Google-Smtp-Source: ABdhPJyDK1FQ9lE3Tn6efk9PPCREoMTXE+q3nMVl9MHfWKyEnWP4sVf9BDThvF+z85n3v8t7H4/V8g==
X-Received: by 2002:a67:a24e:: with SMTP id t14mr9613306vsh.36.1608403613053;
        Sat, 19 Dec 2020 10:46:53 -0800 (PST)
Received: from mail-ua1-f50.google.com (mail-ua1-f50.google.com. [209.85.222.50])
        by smtp.gmail.com with ESMTPSA id 45sm3848626uai.16.2020.12.19.10.46.51
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Dec 2020 10:46:52 -0800 (PST)
Received: by mail-ua1-f50.google.com with SMTP id t15so1997945ual.6
        for <netdev@vger.kernel.org>; Sat, 19 Dec 2020 10:46:51 -0800 (PST)
X-Received: by 2002:ab0:59af:: with SMTP id g44mr9374359uad.37.1608403610986;
 Sat, 19 Dec 2020 10:46:50 -0800 (PST)
MIME-Version: 1.0
References: <20201218201633.2735367-1-jonathan.lemon@gmail.com> <20201218201633.2735367-4-jonathan.lemon@gmail.com>
In-Reply-To: <20201218201633.2735367-4-jonathan.lemon@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sat, 19 Dec 2020 13:46:13 -0500
X-Gmail-Original-Message-ID: <CA+FuTSeaero7hwvDR=1M6z3SZgf_bm+KjQWVzqeS_a42hQ-91Q@mail.gmail.com>
Message-ID: <CA+FuTSeaero7hwvDR=1M6z3SZgf_bm+KjQWVzqeS_a42hQ-91Q@mail.gmail.com>
Subject: Re: [PATCH 3/9 v1 RFC] skbuff: replace sock_zerocopy_put() with skb_zcopy_put()
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 18, 2020 at 3:20 PM Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
>
> From: Jonathan Lemon <bsd@fb.com>
>
> In preparation for further work, the zcopy* routines will
> become basic building blocks, while the zerocopy* ones will
> be specific for the existing zerocopy implementation.

Plural. There already are multiple disjoint zerocopy implementations:
msg_zerocopy, tpacket and vhost_net.

Which API is each intended to use? After this patch
tcp_sendmsg_locked() calls both skb_zcopy_put and
sock_zerocopy_put_abort, so I don't think that that is simplifying the
situation.

This is tricky code. Perhaps best to change only what is needed
instead of targeting a larger cleanup. It's hard to reason that this
patch is safe in all three existing cases, for instance.

> All uargs should have a callback function, (unless nouarg
> is set), so push all special case logic handling down into
> the callbacks.  This slightly pessimizes the refcounted cases,

What does this mean?

> but makes the skb_zcopy_*() routines clearer.
>
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> ---
>  include/linux/skbuff.h | 19 +++++++++----------
>  net/core/skbuff.c      | 21 +++++++++------------
>  net/ipv4/tcp.c         |  2 +-
>  3 files changed, 19 insertions(+), 23 deletions(-)
>
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index fb6dd6af0f82..df98d61e8c51 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -499,7 +499,6 @@ static inline void sock_zerocopy_get(struct ubuf_info *uarg)
>         refcount_inc(&uarg->refcnt);
>  }
>
> -void sock_zerocopy_put(struct ubuf_info *uarg);
>  void sock_zerocopy_put_abort(struct ubuf_info *uarg, bool have_uref);

The rename of sock_zerocopy_put without rename of
sock_zerocopy_put_abort makes the API less consistent, I believe. See
how the calls are close together in tcp_sendmsg_locked.

>  void sock_zerocopy_callback(struct ubuf_info *uarg, bool success);
> @@ -1474,20 +1473,20 @@ static inline void *skb_zcopy_get_nouarg(struct sk_buff *skb)
>         return (void *)((uintptr_t) skb_shinfo(skb)->destructor_arg & ~0x1UL);
>  }
>
> +static inline void skb_zcopy_put(struct ubuf_info *uarg)
> +{
> +       if (uarg)
> +               uarg->callback(uarg, true);
> +}
> +

Can we just use skb_zcopy_clear?

>  /* Release a reference on a zerocopy structure */
> -static inline void skb_zcopy_clear(struct sk_buff *skb, bool zerocopy)
> +static inline void skb_zcopy_clear(struct sk_buff *skb, bool succsss)

succsss -> success. More importantly, why change the argument name?

>  {
>         struct ubuf_info *uarg = skb_zcopy(skb);
>
>         if (uarg) {
> -               if (skb_zcopy_is_nouarg(skb)) {
> -                       /* no notification callback */
> -               } else if (uarg->callback == sock_zerocopy_callback) {
> -                       uarg->zerocopy = uarg->zerocopy && zerocopy;
> -                       sock_zerocopy_put(uarg);
> -               } else {
> -                       uarg->callback(uarg, zerocopy);
> -               }
> +               if (!skb_zcopy_is_nouarg(skb))
> +                       uarg->callback(uarg, succsss);
>
>                 skb_shinfo(skb)->zc_flags &= ~SKBZC_FRAGMENTS;
>         }
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 327ee8938f78..984760dd670b 100644
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
> @@ -1241,18 +1241,15 @@ void sock_zerocopy_callback(struct ubuf_info *uarg, bool success)
>         consume_skb(skb);
>         sock_put(sk);
>  }
> -EXPORT_SYMBOL_GPL(sock_zerocopy_callback);
>
> -void sock_zerocopy_put(struct ubuf_info *uarg)
> +void sock_zerocopy_callback(struct ubuf_info *uarg, bool success)
>  {
> -       if (uarg && refcount_dec_and_test(&uarg->refcnt)) {
> -               if (uarg->callback)
> -                       uarg->callback(uarg, uarg->zerocopy);
> -               else
> -                       consume_skb(skb_from_uarg(uarg));

I suppose this can be removed after commit 0a4a060bb204 ("sock: fix
zerocopy_success regression with msg_zerocopy"). Cleaning that up
would better be a separate patch that explains why the removal is
safe.

It's also fine to bundle with moving refcount_dec_and_test into
sock_zerocopy_callback, which indeed follows from it.

> -       }
> +       uarg->zerocopy = uarg->zerocopy & success;
> +
> +       if (refcount_dec_and_test(&uarg->refcnt))
> +               __sock_zerocopy_callback(uarg);

This can be wrapped in existing sock_zerocopy_callback. No need for a
__sock_zerocopy_callback.

If you do want a separate API for existing msg_zerocopy distinct from
existing skb_zcopy, then maybe rename the functions only used by
msg_zerocopy to have prefix msg_zerocopy_ instead of sock_zerocopy_

>  }
> -EXPORT_SYMBOL_GPL(sock_zerocopy_put);
> +EXPORT_SYMBOL_GPL(sock_zerocopy_callback);
>
>  void sock_zerocopy_put_abort(struct ubuf_info *uarg, bool have_uref)
>  {
> @@ -1263,7 +1260,7 @@ void sock_zerocopy_put_abort(struct ubuf_info *uarg, bool have_uref)
>                 uarg->len--;
>
>                 if (have_uref)
> -                       sock_zerocopy_put(uarg);
> +                       skb_zcopy_put(uarg);
>         }
>  }
>  EXPORT_SYMBOL_GPL(sock_zerocopy_put_abort);
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index fea9bae370e4..5c38080df13f 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -1429,7 +1429,7 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
>                 tcp_push(sk, flags, mss_now, tp->nonagle, size_goal);
>         }
>  out_nopush:
> -       sock_zerocopy_put(uarg);
> +       skb_zcopy_put(uarg);
>         return copied + copied_syn;
>
>  do_error:
> --
> 2.24.1
>
