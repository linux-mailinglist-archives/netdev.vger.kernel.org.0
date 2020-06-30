Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2F8A21001E
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 00:38:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726171AbgF3Wip (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 18:38:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725763AbgF3Wio (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 18:38:44 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5BCDC061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 15:38:44 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id h39so10930076ybj.3
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 15:38:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GUMmR1bCbl8Toix//XFEea01nhUYad+cjY3JyG8gXsE=;
        b=C1qW1/fZTX+3AmLLkkwA9JHG+ginoQf0GbKzdeNuuEjqGb2cWzJBLVIq9rGQerTqUC
         7VMZE9UZZ/3qo88odW+ZD50UtQ4nDN2BnruoxiNp5j//JsQTA24kV9+EeJxbu1Io7OHc
         wSnZ74IuTToY93nms4/buEo1719ZjA/KBvC1sWozlCLnqtsQUkdcWaw1vXg5VdK+RoTo
         kNIAUtWYl0/tXOjyN7F4fEjTTVNPePZzRWkFMNQV1SuQOhGo7c4LwVJ8O+4Lqc+lvs+3
         HqYV+24GjuPvDelt6NBeg2tVwbVX61FkkU6B/TEzsod4cSYlhkC+RRBT9QAryuWIY9If
         QBrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GUMmR1bCbl8Toix//XFEea01nhUYad+cjY3JyG8gXsE=;
        b=CMt4llc11WlsoEzXjnjgN1Q+kGditZEIOhP5ahhJRM9QeAA0nRYs9xTiLBUmhofv88
         ydn5f251wmg7cDGtMed6hKBX6njQ3JBHJnLApDENwwmWosfsVH7EJ2CfGgdyV4t0jkZC
         IquTuSwZdCOZYOIVlV3AF4y1iAtCNSwu5EoOOxcnALuw+AP3il/jQzWDEV7M97kmZZu+
         NitBLZpMuZVhLNNKJnw1VfTpMVMqh3M+7O7tvnL2ZNuNHFeiDfTSlpbARXpXdHPbojeN
         hoXqZgd9UUBXelSh9AZvA3zYjbuyFVU619iaIzwFLXIq3AEm8i02U4eZ+7JLmqGVLmP8
         9yiA==
X-Gm-Message-State: AOAM530mfWu2NofEsOaJs6jlLHD8beg2ROjrWYN8dF9IEG6p//rkPPN4
        69Rw6fjLfRN5UVl0a+536XgWnkWlYwgx5/Q7PXoQ3A==
X-Google-Smtp-Source: ABdhPJy9Pb5IHmIWcD95/roK2Wg/B531qJsb0LdE7Uv/xxSdLITRGFilp+pp5r1gmUm2NadF7LEK+QTm9hBN9d+oNt8=
X-Received: by 2002:a25:b7cc:: with SMTP id u12mr22224608ybj.173.1593556723565;
 Tue, 30 Jun 2020 15:38:43 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wjEghg5_pX_GhNP+BfcUK6CRZ+4mh3bciitm9JwXvR7aQ@mail.gmail.com>
 <312079189.17903.1593549293094.JavaMail.zimbra@efficios.com>
 <CANn89iJ+rkMrLrHrKXO-57frXNb32epB93LYLRuHX00uWc-0Uw@mail.gmail.com>
 <20200630.134429.1590957032456466647.davem@davemloft.net> <CANn89i+b-LeaPvaaHvj0yc0mJ2qwZ0981fQHVp0+sqXYp=kdkA@mail.gmail.com>
 <474095696.17969.1593551866537.JavaMail.zimbra@efficios.com>
 <CANn89iKK2+pznYZoKZzdCu4qkA7BjJZFqc6ABof4iaS-T-9_aw@mail.gmail.com>
 <CANn89i+_DUrKROb1Zkk_nmngkD=oy9UjbxwnkgyzGB=z+SKg3g@mail.gmail.com> <CANn89iJJ_WR-jGQogU3-arjD6=xcU9VWzJYSOLbyD94JQo-zAQ@mail.gmail.com>
In-Reply-To: <CANn89iJJ_WR-jGQogU3-arjD6=xcU9VWzJYSOLbyD94JQo-zAQ@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 30 Jun 2020 15:38:31 -0700
Message-ID: <CANn89iLPqtJG0iESCHF+RcOjo95ukan1oSzjkPjoSJgKpO2wSQ@mail.gmail.com>
Subject: Re: [regression] TCP_MD5SIG on established sockets
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
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

On Tue, Jun 30, 2020 at 3:07 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Tue, Jun 30, 2020 at 2:54 PM Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Tue, Jun 30, 2020 at 2:23 PM Eric Dumazet <edumazet@google.com> wrote:
> > >
> > > On Tue, Jun 30, 2020 at 2:17 PM Mathieu Desnoyers
> > > <mathieu.desnoyers@efficios.com> wrote:
> > > >
> > > > ----- On Jun 30, 2020, at 4:56 PM, Eric Dumazet edumazet@google.com wrote:
> > > >
> > > > > On Tue, Jun 30, 2020 at 1:44 PM David Miller <davem@davemloft.net> wrote:
> > > > >>
> > > > >> From: Eric Dumazet <edumazet@google.com>
> > > > >> Date: Tue, 30 Jun 2020 13:39:27 -0700
> > > > >>
> > > > >> > The (C) & (B) case are certainly doable.
> > > > >> >
> > > > >> > A) case is more complex, I have no idea of breakages of various TCP
> > > > >> > stacks if a flow got SACK
> > > > >> > at some point (in 3WHS) but suddenly becomes Reno.
> > > > >>
> > > > >> I agree that C and B are the easiest to implement without having to
> > > > >> add complicated code to handle various negotiated TCP option
> > > > >> scenerios.
> > > > >>
> > > > >> It does seem to be that some entities do A, or did I misread your
> > > > >> behavioral analysis of various implementations Mathieu?
> > > > >>
> > > > >> Thanks.
> > > > >
> > > > > Yes, another question about Mathieu cases is do determine the behavior
> > > > > of all these stacks vs :
> > > > > SACK option
> > > > > TCP TS option.
> > > >
> > > > I will ask my customer's networking team to investigate these behaviors,
> > > > which will allow me to prepare a thorough reply to the questions raised
> > > > by Eric and David. I expect to have an answer within 2-3 weeks at most.
> > > >
> > > > Thank you!
> > >
> > >
> > > Great, I am working on adding back support for (B) & (C) by the end of
> > > this week.
> >
> > Note that the security issue (of sending uninit bytes to the wire) has
> > been independently fixed with [1]
> >
> > This means syzbot was able to have MD5+TS+SACK  ~6 months ago.
> >
> > It seems we (linux) do not enable this combination for PASSIVE flows,
> > (according to tcp_synack_options()),
> > but  for ACTIVE flows we do nothing special.
> >
> > So maybe code in tcp_synack_options() should be mirrored to
> > tcp_syn_options() for consistency.
> > (disabling TS if  both MD5 and SACK are enabled)
>
> Oh well, tcp_syn_options() is supposed to have the same logic.
>
> Maybe we have an issue with SYNCOOKIES (with MD5 + TS + SACK)
>
> Nice can of worms.
>

For updates of keys, it seems existing code lacks some RCU care.

MD5 keys use RCU for lookups/hashes, but the replacement of a key does
not allocate a new piece of memory.

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 810cc164f795f8e1e8ca747ed5df51bb20fec8a2..ecc0e3fabce8b03bef823cbfc5c1b0a9e24df124
100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4034,9 +4034,12 @@ EXPORT_SYMBOL(tcp_md5_hash_skb_data);
 int tcp_md5_hash_key(struct tcp_md5sig_pool *hp, const struct
tcp_md5sig_key *key)
 {
        struct scatterlist sg;
+       u8 keylen = key->keylen;

-       sg_init_one(&sg, key->key, key->keylen);
-       ahash_request_set_crypt(hp->md5_req, &sg, NULL, key->keylen);
+       smp_rmb(); /* paired with smp_wmb() in tcp_md5_do_add() */
+
+       sg_init_one(&sg, key->key, keylen);
+       ahash_request_set_crypt(hp->md5_req, &sg, NULL, keylen);
        return crypto_ahash_update(hp->md5_req);
 }
 EXPORT_SYMBOL(tcp_md5_hash_key);
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index ad6435ba6d72ffd8caf783bb25cad7ec151d6909..99916fcc15ca0be12c2c133ff40516f79e6fdf7f
100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1113,6 +1113,9 @@ int tcp_md5_do_add(struct sock *sk, const union
tcp_md5_addr *addr,
        if (key) {
                /* Pre-existing entry - just update that one. */
                memcpy(key->key, newkey, newkeylen);
+
+               smp_wmb(); /* pairs with smp_rmb() in tcp_md5_hash_key() */
+
                key->keylen = newkeylen;
                return 0;
        }
