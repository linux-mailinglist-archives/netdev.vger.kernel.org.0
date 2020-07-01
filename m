Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FBED210ED6
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 17:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731851AbgGAPPX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 11:15:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731649AbgGAPPX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 11:15:23 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E549AC08C5DB
        for <netdev@vger.kernel.org>; Wed,  1 Jul 2020 08:15:22 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id x8so6140469ybl.9
        for <netdev@vger.kernel.org>; Wed, 01 Jul 2020 08:15:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1OXCzKlm/ajG5X9F9mYOppVckbS/UtVwRERIIxYgAF0=;
        b=gm7DKZndG5xIUYp+pckIqDJmVIxEdJ7mokqKBpWulCAJXdFJpoRETrlva80b8BWqri
         JfzgfjH1Wfp5e4nkEu/uKtEzZtsWfbvgyKfIbpucXnVhHTqsEePdXkjcdheSmeC2udk9
         bJcg4gANj48YwTwHPaWhoC3J8VsheYwWi0m1XwNuIGnKdeMOy0OsWOFK/w/sRiLEDHe0
         vcdWjg8T7zs4KZFrKCnyiVRl7fRxYbIA7pWPSRoYp6i93GCrQ92p0mNitS70hGi4Q0ip
         9iUrnQttT1sBktCWpJzmQ7Ay+LfJI4YBNXkzUaAQiHpqn5F13JgJaofExLIp+GFKGtEa
         spTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1OXCzKlm/ajG5X9F9mYOppVckbS/UtVwRERIIxYgAF0=;
        b=fNX4wEDcnK6Oav9SekmjauCD9LOhptDg4jwH2qDPwYvHv0zNvdISkicuDQSQaS9rFj
         EY5LNnKwAS24APeuKWm0HT++SDqB3bnuEhoXwZAJngZ6AWoLrgm29uRww+ew4xP3j1RG
         97Hyh4UsI28+TwroPD8OnDNjyyZ7ofSw4KZyET62mALIoyoMq/i6+iTCc2rgDOcIoDby
         PSDdvbE1L+c8MLnkNcGTDPu7GI5S6NvQDGCwStJzYyOB7ucF5X+HEYqy7v7QkxwXQGdk
         x/ilcqfX5DxIHPNlUCQS43xN1ztzpvB1pRJHTos9P0jGgn6vdnZaWA5t8gUTKsSnq5tU
         QTuA==
X-Gm-Message-State: AOAM530rsCk6vtRVFfuUmzXeIfs4SD3EQ7D/LVxUhAsky2G3DCXRrtng
        i73Z+liW6ZZ7pMAKmxxtyVHIhbv9iAdihH0aOhsb3Q==
X-Google-Smtp-Source: ABdhPJzGtgnKdXHNer1rjRzDXoB0nKorJWKbUBcfkGsR9/EkL6I8d+nQZeuowgjlrinMb8zZNxHZ/e6tbOmtSAMrAw0=
X-Received: by 2002:a25:b7cc:: with SMTP id u12mr27806815ybj.173.1593616521698;
 Wed, 01 Jul 2020 08:15:21 -0700 (PDT)
MIME-Version: 1.0
References: <CANn89iLPqtJG0iESCHF+RcOjo95ukan1oSzjkPjoSJgKpO2wSQ@mail.gmail.com>
 <20200701020211.GA6875@gondor.apana.org.au> <CANn89iKP-evuLxeLo6p_98T+FuJ-J5YaMTRG230nqj3R=43tVA@mail.gmail.com>
 <20200701022241.GA7167@gondor.apana.org.au> <CANn89iLKZQAtpejcLHmOu3dsrGf5eyFfHc8JqoMNYisRPWQ8kQ@mail.gmail.com>
 <20200701025843.GA7254@gondor.apana.org.au> <CANn89iKnf6=RFd-XRjPv=qaU8P-LGCBcw6JU5Ywwb16gU2iQqQ@mail.gmail.com>
 <338284155.18826.1593605982156.JavaMail.zimbra@efficios.com>
In-Reply-To: <338284155.18826.1593605982156.JavaMail.zimbra@efficios.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 1 Jul 2020 08:15:10 -0700
Message-ID: <CANn89iLLuUG-6QaOzTt8UFszpOKkjKhXqDmgDMW1L5GctsqL-g@mail.gmail.com>
Subject: Re: [regression] TCP_MD5SIG on established sockets
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Jonathan Rajotte-Julien <joraj@efficios.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 1, 2020 at 5:19 AM Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:

> The approach below looks good to me, but you'll also need to annotate
> both tcp_md5_hash_key and tcp_md5_do_add with __no_kcsan or use
> data_race(expr) to let the concurrency sanitizer know that there is
> a known data race which is there on purpose (triggered by memcpy in tcp_md5_do_add
> and somewhere within crypto_ahash_update). See Documentation/dev-tools/kcsan.rst
> for details.

Sure, I can add a data_race() and let stable teams handle the
backports without it ;)

>
> Thanks,
>
> Mathieu
>
> >
> > diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> > index
> > f111660453241692a17c881dd6dc2910a1236263..c3af8180c7049d5c4987bf5c67e4aff2ed6967c9
> > 100644
> > --- a/net/ipv4/tcp.c
> > +++ b/net/ipv4/tcp.c
> > @@ -4033,11 +4033,9 @@ EXPORT_SYMBOL(tcp_md5_hash_skb_data);
> >
> > int tcp_md5_hash_key(struct tcp_md5sig_pool *hp, const struct
> > tcp_md5sig_key *key)
> > {
> > -       u8 keylen = key->keylen;
> > +       u8 keylen = READ_ONCE(key->keylen); /* paired with
> > WRITE_ONCE() in tcp_md5_do_add */
> >        struct scatterlist sg;
> >
> > -       smp_rmb(); /* paired with smp_wmb() in tcp_md5_do_add() */
> > -
> >        sg_init_one(&sg, key->key, keylen);
> >        ahash_request_set_crypt(hp->md5_req, &sg, NULL, keylen);
> >        return crypto_ahash_update(hp->md5_req);
> > diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> > index
> > 99916fcc15ca0be12c2c133ff40516f79e6fdf7f..0d08e0134335a21d23702e6a5c24a0f2b3c61c6f
> > 100644
> > --- a/net/ipv4/tcp_ipv4.c
> > +++ b/net/ipv4/tcp_ipv4.c
> > @@ -1114,9 +1114,13 @@ int tcp_md5_do_add(struct sock *sk, const union
> > tcp_md5_addr *addr,
> >                /* Pre-existing entry - just update that one. */
> >                memcpy(key->key, newkey, newkeylen);
> >
> > -               smp_wmb(); /* pairs with smp_rmb() in tcp_md5_hash_key() */
> > +               /* Pairs with READ_ONCE() in tcp_md5_hash_key().
> > +                * Also note that a reader could catch new key->keylen value
> > +                * but old key->key[], this is the reason we use __GFP_ZERO
> > +                * at sock_kmalloc() time below these lines.
> > +                */
> > +               WRITE_ONCE(key->keylen, newkeylen);
> >
> > -               key->keylen = newkeylen;
> >                return 0;
> >        }
> >
> > @@ -1132,7 +1136,7 @@ int tcp_md5_do_add(struct sock *sk, const union
> > tcp_md5_addr *addr,
> >                rcu_assign_pointer(tp->md5sig_info, md5sig);
> >        }
> >
> > -       key = sock_kmalloc(sk, sizeof(*key), gfp);
> > +       key = sock_kmalloc(sk, sizeof(*key), gfp | __GFP_ZERO);
> >        if (!key)
> >                return -ENOMEM;
> >         if (!tcp_alloc_md5sig_pool()) {
>
> --
> Mathieu Desnoyers
> EfficiOS Inc.
> http://www.efficios.com
