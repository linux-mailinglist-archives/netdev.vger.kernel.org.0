Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 962DF4998A
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 08:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbfFRG5K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 02:57:10 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:38256 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbfFRG5J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 02:57:09 -0400
Received: by mail-io1-f68.google.com with SMTP id d12so19317005iod.5
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 23:57:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CXnIyZ8/qpmB9O/IQNXwE4xcVL/UEsoKm7waO42Vrhc=;
        b=b6pEESMTIYW1rETynyENJ8kZq2eRzhHdArMeVYV4OlYd8GEe0UWHcsFoQ85ltX2lB1
         7/mZR0HWFEuuTntZ2V9EDJprv6wiqunqmpXh0lPIjyyxiqDLtff7UTDH0dBMIoMmb82/
         BJ80aRIYEMInyuiAkLixiRkY8yVbOWntAeQm7/rXli2yHmYXfKHEaNBxJXBi4pPS90Ap
         1voK+mEVg9DMsxNuyKJEjz/FYHjy+LTRAYuo+dU1lM70Dpzj+D/119WhW3cjaxr4MH4t
         LB8ys+g10lKKVIFKCsoFN+Q2OfDB1b9r0t39F2e1UNOiGONW0MVoHXIcZB/WW/URNfuY
         CH0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CXnIyZ8/qpmB9O/IQNXwE4xcVL/UEsoKm7waO42Vrhc=;
        b=X7ywzrXM2WSFJ8Niko6MZYga4n6oMZtc3mSHTkRQAvJB40BQDiSeLrLfJcJcyfVd33
         5D51ZQ6DXB36CWYajP270SbfM7FVxrdED8usBwSCVhnqrFrUZOSZO/aQrQ0lNnvYSnIo
         Rtjz9NZ7T4NH4qsI/OWQAfoMzUpHrTY4JqOyen+wdKt32Zye+1dClgJ1TqoWEX10dbzu
         UbW6VCiCmcf/UkTnMYPgikPFBGVJp89OiKOK4nuqoeylnQ9l7JTqna2VB9KgcvgOOdOc
         /EPzdGAFtbUuLYg5GTdlOfw7oYFl+d+UHZMxIT15ZFCtWh2FI3j/u8OcVVcuqiMmap8z
         b0Fw==
X-Gm-Message-State: APjAAAVM0aUQI6I5GggdL/4JAdrBE0lHZD3J3bjSgAj066kUR6fFFDxc
        /LI/vxCEgNresjLlb+SPA9gTL2+oz3wYn8MpB9qNtw==
X-Google-Smtp-Source: APXvYqzf64Vvjzwa7BoV29fPQU32R2jtJBqmw6Kf38W7cFU4LGqvkEX6o0py4xYF6b3Uv4Iosiofvwx7c8sS4eNBf6U=
X-Received: by 2002:a05:6602:98:: with SMTP id h24mr15093820iob.49.1560841028753;
 Mon, 17 Jun 2019 23:57:08 -0700 (PDT)
MIME-Version: 1.0
References: <20190617080933.32152-1-ard.biesheuvel@linaro.org> <20190618041408.GB2266@sol.localdomain>
In-Reply-To: <20190618041408.GB2266@sol.localdomain>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Tue, 18 Jun 2019 08:56:57 +0200
Message-ID: <CAKv+Gu9O0YjyftEEQgZqBcTtZ37co5_H1m6s2GCqk+onza7A-g@mail.gmail.com>
Subject: Re: [PATCH v3] net: ipv4: move tcp_fastopen server side code to
 SipHash library
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, Jason Baron <jbaron@akamai.com>,
        cpaasch@apple.com, David Laight <David.Laight@aculab.com>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Jun 2019 at 06:14, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Mon, Jun 17, 2019 at 10:09:33AM +0200, Ard Biesheuvel wrote:
> > diff --git a/include/linux/tcp.h b/include/linux/tcp.h
> > index c23019a3b264..9ea0e71f5c6a 100644
> > --- a/include/linux/tcp.h
> > +++ b/include/linux/tcp.h
> > @@ -58,12 +58,7 @@ static inline unsigned int tcp_optlen(const struct sk_buff *skb)
> >
> >  /* TCP Fast Open Cookie as stored in memory */
> >  struct tcp_fastopen_cookie {
> > -     union {
> > -             u8      val[TCP_FASTOPEN_COOKIE_MAX];
> > -#if IS_ENABLED(CONFIG_IPV6)
> > -             struct in6_addr addr;
> > -#endif
> > -     };
> > +     u64     val[TCP_FASTOPEN_COOKIE_MAX / sizeof(u64)];
> >       s8      len;
> >       bool    exp;    /* In RFC6994 experimental option format */
> >  };
>
> Is it okay that the cookies will depend on CPU endianness?
>

That depends on whether keys shared between hosts with different
endiannesses are expected to produce cookies that can be shared.

> > diff --git a/include/net/tcp.h b/include/net/tcp.h
> > index 96e0e53ff440..184930b02779 100644
> > --- a/include/net/tcp.h
> > +++ b/include/net/tcp.h
> > @@ -1628,9 +1628,9 @@ bool tcp_fastopen_defer_connect(struct sock *sk, int *err);
> >
> >  /* Fastopen key context */
> >  struct tcp_fastopen_context {
> > -     struct crypto_cipher    *tfm[TCP_FASTOPEN_KEY_MAX];
> > -     __u8                    key[TCP_FASTOPEN_KEY_BUF_LENGTH];
> > -     struct rcu_head         rcu;
> > +     __u8            key[TCP_FASTOPEN_KEY_MAX][TCP_FASTOPEN_KEY_LENGTH];
> > +     int             num;
> > +     struct rcu_head rcu;
> >  };
>
> Why not use 'siphash_key_t' here?  Then the (potentially alignment-violating)
> cast in __tcp_fastopen_cookie_gen_cipher() wouldn't be needed.
>

These data structures are always kmalloc'ed so the alignment is never
violated in practice. But I do take your point. My idea at the time of
the first RFC was that the actual MAC algo should be an implementation
detail, and so the key is just a buffer. However, after Eric pointed
out that setting the same key across different hosts should produce
compatible cookies (module the upgrade scenario), it is true that the
algorithm is an externally visible property, so it might be better to
change this into siphash_key_t[] here.

> >  int tcp_fastopen_reset_cipher(struct net *net, struct sock *sk,
> >                             void *primary_key, void *backup_key,
> >                             unsigned int len)
> > @@ -115,11 +75,20 @@ int tcp_fastopen_reset_cipher(struct net *net, struct sock *sk,
> >       struct fastopen_queue *q;
> >       int err = 0;
> >
> > -     ctx = tcp_fastopen_alloc_ctx(primary_key, backup_key, len);
> > -     if (IS_ERR(ctx)) {
> > -             err = PTR_ERR(ctx);
> > +     ctx = kmalloc(sizeof(*ctx), GFP_KERNEL);
> > +     if (!ctx) {
> > +             err = -ENOMEM;
> >               goto out;
> >       }
> > +
> > +     memcpy(ctx->key[0], primary_key, len);
> > +     if (backup_key) {
> > +             memcpy(ctx->key[1], backup_key, len);
> > +             ctx->num = 2;
> > +     } else {
> > +             ctx->num = 1;
> > +     }
> > +
> >       spin_lock(&net->ipv4.tcp_fastopen_ctx_lock);
> >       if (sk) {
> >               q = &inet_csk(sk)->icsk_accept_queue.fastopenq;
>
> Shouldn't there be a check that 'len == TCP_FASTOPEN_KEY_LENGTH'?  I see that
> all callers pass that, but it seems unnecessarily fragile for this to accept
> short lengths and leave uninitialized memory in that case.
>

Sure, I can add back the error handling path the previously handled
any errors from crypto_cipher_setkey() [which would perform the input
length checking in that case]

I'll spin an incremental patch covering the above.
