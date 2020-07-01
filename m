Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AD982112D3
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 20:33:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732976AbgGASdM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 14:33:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732542AbgGASdM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 14:33:12 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34F6DC08C5C1
        for <netdev@vger.kernel.org>; Wed,  1 Jul 2020 11:33:12 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id 187so12459742ybq.2
        for <netdev@vger.kernel.org>; Wed, 01 Jul 2020 11:33:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gkWolK5uCT85Nx5U2cYm/j4uFvyh/cdaUiw3he2DmtA=;
        b=RteHKaTnIehdGDHSZ5LjavpjbZT556NTH0S160D1gPPdVVO66Nz2i+X3nBnsXldSuo
         NC7/idS5+o28mM6BTGzO6cKrLaa2IB8ILEOl5q+edLlaO6UEebz7cO/gkI+AydcgFR1T
         SRzSeFCa2s1mBgNsyNXX+npUicUf8Jy2/5reSwzMfzbcC0NaYSPu2VZLCD/mHj2uDvBG
         Tln94erxnt0oWFzormkWUBqktT/hiCiZt2d5JFarwGqQVuTwIzdPvj9Z0M8ReDzlBgiZ
         20flsmbMkjgk6KYBHyNuAVmdSxER7fiZOT/Dxr8FdQjpOV7+m92LqRoEENmynDQ89+c8
         WrKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gkWolK5uCT85Nx5U2cYm/j4uFvyh/cdaUiw3he2DmtA=;
        b=t/OpGuJtZ1KbFVATx5WTNbC9Efz08vZnU310tguFlSwhZWFGd4GbJVWv0Pu9H6Yvfu
         QRk1x/9DSEAjYqiTwCOAbqLBvF+SozjUh0PMdJL8heTxuBMb6OgGOekvG47PTjrEhUoo
         WVssxc6xiFICCbWI3dobMXY5jEtP2Efczz7Aeuaf2ATOgAK3diddOAE3kvYinPGhFEu2
         IcJhNCPx1JT4z5Y95kWexwFsTaElFCFICuq+D3p+IG9Njx7sV9RH/sd5bWIINEXTwIPg
         nAeqL0sfBFw0sRQ22Pq9AFUvcWULIwcp15ZR2Zv4D++bhZeh9NpruMn+S8YeFXgbl3Qt
         Dzqg==
X-Gm-Message-State: AOAM5304f95I6ogHjqZ8lSGszwuTuN8FjEx8n/xoUE8XUGzTLXk32FCX
        TyvkV1xXxghS+Gg/basVoGe5MuA+dx8UzUpvxUKtqg==
X-Google-Smtp-Source: ABdhPJyYUXHt2LJz3LtWBD9GfzccCxSfKs90j3BtvAHhyMXXTfYSPins/xjBQLwVuw3lgdEBbvZ3HFVUvTmcX1lGtnA=
X-Received: by 2002:a25:b8c5:: with SMTP id g5mr6256597ybm.395.1593628391137;
 Wed, 01 Jul 2020 11:33:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200701155018.3502985-1-edumazet@google.com> <723842718.19296.1593619039697.JavaMail.zimbra@efficios.com>
 <CANn89i+x_OocNV=y1aP0uDUJ3HegXrhBCqZgSPTigEoj5rWx-g@mail.gmail.com> <CANpmjNONY346BYs3fZvgsGS=9P2ik6nOXZXDiAnXOR=O98uo5w@mail.gmail.com>
In-Reply-To: <CANpmjNONY346BYs3fZvgsGS=9P2ik6nOXZXDiAnXOR=O98uo5w@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 1 Jul 2020 11:32:59 -0700
Message-ID: <CANn89iK14ZSrasOF2Bg3B4YfEj0yJLPi9vOxgvM1=2YfcFY3tw@mail.gmail.com>
Subject: Re: [PATCH net] tcp: md5: refine tcp_md5_do_add()/tcp_md5_hash_key() barriers
To:     Marco Elver <elver@google.com>
Cc:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 1, 2020 at 11:25 AM Marco Elver <elver@google.com> wrote:
>
> On Wed, 1 Jul 2020 at 18:05, Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Wed, Jul 1, 2020 at 8:57 AM Mathieu Desnoyers
> > <mathieu.desnoyers@efficios.com> wrote:
> > >
> > > ----- On Jul 1, 2020, at 11:50 AM, Eric Dumazet edumazet@google.com wrote:
> > >
> > > > My prior fix went a bit too far, according to Herbert and Mathieu.
> > > >
> > > > Since we accept that concurrent TCP MD5 lookups might see inconsistent
> > > > keys, we can use READ_ONCE()/WRITE_ONCE() instead of smp_rmb()/smp_wmb()
> > > >
> > > > Clearing all key->key[] is needed to avoid possible KMSAN reports,
> > > > if key->keylen is increased. Since tcp_md5_do_add() is not fast path,
> > > > using __GFP_ZERO to clear all struct tcp_md5sig_key is simpler.
> > > >
> > > > data_race() was added in linux-5.8 and will prevent KCSAN reports,
> > > > this can safely be removed in stable backports, if data_race() is
> > > > not yet backported.
> > > >
> > > > Fixes: 6a2febec338d ("tcp: md5: add missing memory barriers in
> > > > tcp_md5_do_add()/tcp_md5_hash_key()")
> > > > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > > > Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> > > > Cc: Herbert Xu <herbert@gondor.apana.org.au>
> > > > ---
> > > > net/ipv4/tcp.c      |  4 +---
> > > > net/ipv4/tcp_ipv4.c | 19 ++++++++++++++-----
> > > > 2 files changed, 15 insertions(+), 8 deletions(-)
> > > >
> > > > diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> > > > index
> > > > f111660453241692a17c881dd6dc2910a1236263..c3af8180c7049d5c4987bf5c67e4aff2ed6967c9
> > > > 100644
> > > > --- a/net/ipv4/tcp.c
> > > > +++ b/net/ipv4/tcp.c
> > > > @@ -4033,11 +4033,9 @@ EXPORT_SYMBOL(tcp_md5_hash_skb_data);
> > > >
> > > > int tcp_md5_hash_key(struct tcp_md5sig_pool *hp, const struct tcp_md5sig_key
> > > > *key)
> > > > {
> > > > -     u8 keylen = key->keylen;
> > > > +     u8 keylen = READ_ONCE(key->keylen); /* paired with WRITE_ONCE() in
> > > > tcp_md5_do_add */
> > > >       struct scatterlist sg;
> > > >
> > > > -     smp_rmb(); /* paired with smp_wmb() in tcp_md5_do_add() */
> > > > -
> > > >       sg_init_one(&sg, key->key, keylen);
> > > >       ahash_request_set_crypt(hp->md5_req, &sg, NULL, keylen);
> > > >       return crypto_ahash_update(hp->md5_req);
> > >
> > > I think we should change this to:
> > >
> > >     return data_race(crypto_ahash_update(hp->md5_req));
> > >
> > > because both sides can race on the data. Hopefully that would let
> > > KCSAN know that deep within the ->update callback the data race
> > > is OK (?)
> > >
> >
> > Let's ask Marco.
> >
> > Before data_race() has been there, using READ_ONCE() or WRITE_ONCE()
> > was enough to silence KCSAN.
> > Not sure if this is the same for data_race().
> >
> > I would prefer not having to add annotations all over the places, to
> > reduce backport pains.
> >
> > Unless we have plans to backport data_race() to all stable versions.
>
> data_race() actually changed its final semantics. The first version of
> data_race() still expected all racing locations to be marked (whether
> with data_race(), or ONCE, or ..). The current version doesn't, and
> strictly speaking only marking the reader location with a data_race()
> will silence KCSAN for good. Although it is entirely up to preference,
> and marking both sides is certainly valid and documents what's
> happening, KCSAN doesn't care.
>
> If you only mark the writers, we may still get reports at the reader
> location with KCSAN's default config in the form of "race of unknown
> origin" because there is an observable race on the reader side, but
> the writer is entirely hidden (syzbot won't report them though,
> because we have CONFIG_KCSAN_REPORT_RACE_UNKNOWN_ORIGIN=n).
>
> Also, wrapping entire function calls in data_race() is valid.

Ok, I can do that, but it might hide other bugs.

Here only one of the inputs (the up to 80 bytes of MD5 key) might be
changed, but we would not expect other stuff to be changed under us.

I guess this is the same observation as adding
READ_ONCE()/WRITE_ONCE() all over the places to silence sanitizers :
Real bugs could be be hidden.

>
> Does this answer the question?

Yes thank you.

>
> > > > diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> > > > index
> > > > 99916fcc15ca0be12c2c133ff40516f79e6fdf7f..04bfcbbfee83aadf5bca0332275c57113abdbc75
> > > > 100644
> > > > --- a/net/ipv4/tcp_ipv4.c
> > > > +++ b/net/ipv4/tcp_ipv4.c
> > > > @@ -1111,12 +1111,21 @@ int tcp_md5_do_add(struct sock *sk, const union
> > > > tcp_md5_addr *addr,
> > > >
> > > >       key = tcp_md5_do_lookup_exact(sk, addr, family, prefixlen, l3index);
> > > >       if (key) {
> > > > -             /* Pre-existing entry - just update that one. */
> > > > -             memcpy(key->key, newkey, newkeylen);
> > > > +             /* Pre-existing entry - just update that one.
> > > > +              * Note that the key might be used concurrently.
> > > > +              * data_race() is telling kcsan that we do not care of
> > > > +              * key mismatches, since changing MD5 key on live flows
> > > > +              * can lead to packet drops.
> > > > +              */
> > > > +             data_race(memcpy(key->key, newkey, newkeylen));
> > > >
> > > > -             smp_wmb(); /* pairs with smp_rmb() in tcp_md5_hash_key() */
> > > > +             /* Pairs with READ_ONCE() in tcp_md5_hash_key().
> > > > +              * Also note that a reader could catch new key->keylen value
> > > > +              * but old key->key[], this is the reason we use __GFP_ZERO
> > > > +              * at sock_kmalloc() time below these lines.
> > > > +              */
> > > > +             WRITE_ONCE(key->keylen, newkeylen);
>
> From what I read, removing the barriers is safe; but in case it
> matters in future, KCSAN is certainly aware of other primitives such
> as smp_load_acquire/smp_store_release.
>
> > > > -             key->keylen = newkeylen;
> > > >               return 0;
> > > >       }
> > > >
> > > > @@ -1132,7 +1141,7 @@ int tcp_md5_do_add(struct sock *sk, const union
> > > > tcp_md5_addr *addr,
> > > >               rcu_assign_pointer(tp->md5sig_info, md5sig);
> > > >       }
> > > >
> > > > -     key = sock_kmalloc(sk, sizeof(*key), gfp);
> > > > +     key = sock_kmalloc(sk, sizeof(*key), gfp | __GFP_ZERO);
> > > >       if (!key)
> > > >               return -ENOMEM;
> > > >       if (!tcp_alloc_md5sig_pool()) {
> > > > --
> > > > 2.27.0.212.ge8ba1cc988-goog
