Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B101A6E87E9
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 04:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233066AbjDTCUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 22:20:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233065AbjDTCUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 22:20:11 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 892B0448D
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 19:20:09 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id d75a77b69052e-3ed330f1ed2so1979931cf.2
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 19:20:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681957208; x=1684549208;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WKsezCxQJJ24EMN6sEly97AWkRDFF2ahUSrV5SKlCKE=;
        b=rzrk8hrzGWYkdSqPfvGQB0nXJEnzFcEbCXwNGBcVR9HcDeZnxGRSgE6ujDildXZoGC
         ulh7ObnlTzr6X+JxWt1iruu5qpsT6bqFqJs2TF6c01QwywRutgVU5eGrCCs8ljYvS5qw
         ynf7jQo5rZsO9U+WC4CGU2lSueWLqjN3eJkJEQrN2N/3PhAQTWj5oIwivGo609myb1+P
         oGM3TokSBIw7o6HddCY5Z33LmyBKPe6cliXbyvRm+4Lkn+T/L1HHdZAGdmmB+56OZbp6
         VNVKYDm1+UNRp8BTor4T5kzc/MOWKZvPIsbZ6uLw28VLpIoTG/VXcZIk9ZMTPGTV6BsD
         /Q0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681957208; x=1684549208;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=WKsezCxQJJ24EMN6sEly97AWkRDFF2ahUSrV5SKlCKE=;
        b=geOFTc57/9s/+ToU4QP9EhRzWHy0alW4ayJB7NceN9QIjAaXdXt/d+fmbifDsKhYQw
         QVPWr4xgCB/zUIzlYGB3RLQHBPZzxg6euZn8EW+/FW7o/g4ewqq2x6SntD/fcXFwRgeW
         rJ9YNJVH3jhmtElUO3yKQu9RhXx3uPDTO1vnVlP/gKUjikOsIrWMWJt1GR/00ci3Wb4F
         vB1J30ll+FsQz3MbWjdLo9wi/PCevVxwOcAYN/XFjo0XoRAry2KKVikOd6RW7Pf/5Flc
         yVVA38SEW4pbYWbwJEQQNDTtmJJKGTXCrmc6YBV1CWuvkAEGu2SfJ0/FORjUpp0czehf
         ssFQ==
X-Gm-Message-State: AAQBX9d0VUXk9034xN2ehflPVXQpaeT64lyXgsKM9qJOMIho1oXTeI7X
        GPX4p+i7OW3x7kkKuE721BXXdcShMpU=
X-Google-Smtp-Source: AKy350YItqGjdsmB2Ha3woMYOQt7WbbLmsekPUkxGvT9ETmlxoyZWEDJAITCIeAPac0RMc3cIIE87g==
X-Received: by 2002:ac8:5b03:0:b0:3ef:499a:dd99 with SMTP id m3-20020ac85b03000000b003ef499add99mr983607qtw.66.1681957208587;
        Wed, 19 Apr 2023 19:20:08 -0700 (PDT)
Received: from localhost (172.174.245.35.bc.googleusercontent.com. [35.245.174.172])
        by smtp.gmail.com with ESMTPSA id j15-20020a37ef0f000000b007468bf8362esm94219qkk.66.2023.04.19.19.20.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 19:20:07 -0700 (PDT)
Date:   Wed, 19 Apr 2023 22:20:07 -0400
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        willemdebruijn.kernel@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        kuni1840@gmail.com, kuniyu@amazon.com, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller@googlegroups.com, willemb@google.com
Message-ID: <6440a157b6113_128322942d@willemb.c.googlers.com.notmuch>
In-Reply-To: <20230419224358.98442-1-kuniyu@amazon.com>
References: <644029f7e7814_38cc8429476@willemb.c.googlers.com.notmuch>
 <20230419224358.98442-1-kuniyu@amazon.com>
Subject: Re: [PATCH v2 net] tcp/udp: Fix memleaks of sk and zerocopy skbs with
 TX timestamp.
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kuniyuki Iwashima wrote:
> From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> Date:   Wed, 19 Apr 2023 13:50:47 -0400
> > Kuniyuki Iwashima wrote:
> > > From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> > > Date:   Wed, 19 Apr 2023 10:16:07 -0400
> > > > Eric Dumazet wrote:
> > > > > On Tue, Apr 18, 2023 at 9:25=E2=80=AFPM Kuniyuki Iwashima <kuni=
yu@amazon.com> wrote:
> > > > > >
> > > > > > From:   Eric Dumazet <edumazet@google.com>
> > > > > > Date:   Tue, 18 Apr 2023 21:04:32 +0200
> > > > > > > On Tue, Apr 18, 2023 at 8:44=E2=80=AFPM Kuniyuki Iwashima <=
kuniyu@amazon.com> wrote:
> > > > > > > >
> > > > > > > > From:   Eric Dumazet <edumazet@google.com>
> > > > > > > > Date:   Tue, 18 Apr 2023 20:33:44 +0200
> > > > > > > > > On Tue, Apr 18, 2023 at 8:09=E2=80=AFPM Kuniyuki Iwashi=
ma <kuniyu@amazon.com> wrote:
> > > > > > > > > >
> > > > > > > > > > syzkaller reported [0] memory leaks of an UDP socket =
and ZEROCOPY
> > > > > > > > > > skbs.  We can reproduce the problem with these sequen=
ces:
> > > > > > > > > >
> > > > > > > > > >   sk =3D socket(AF_INET, SOCK_DGRAM, 0)
> > > > > > > > > >   sk.setsockopt(SOL_SOCKET, SO_TIMESTAMPING, SOF_TIME=
STAMPING_TX_SOFTWARE)
> > > > > > > > > >   sk.setsockopt(SOL_SOCKET, SO_ZEROCOPY, 1)
> > > > > > > > > >   sk.sendto(b'', MSG_ZEROCOPY, ('127.0.0.1', 53))
> > > > > > > > > >   sk.close()
> > > > > > > > > >
> > > > > > > > > > sendmsg() calls msg_zerocopy_alloc(), which allocates=
 a skb, sets
> > > > > > > > > > skb->cb->ubuf.refcnt to 1, and calls sock_hold().  He=
re, struct
> > > > > > > > > > ubuf_info_msgzc indirectly holds a refcnt of the sock=
et.  When the
> > > > > > > > > > skb is sent, __skb_tstamp_tx() clones it and puts the=
 clone into
> > > > > > > > > > the socket's error queue with the TX timestamp.
> > > > > > > > > >
> > > > > > > > > > When the original skb is received locally, skb_copy_u=
bufs() calls
> > > > > > > > > > skb_unclone(), and pskb_expand_head() increments skb-=
>cb->ubuf.refcnt.
> > > > > > > > > > This additional count is decremented while freeing th=
e skb, but struct
> > > > > > > > > > ubuf_info_msgzc still has a refcnt, so __msg_zerocopy=
_callback() is
> > > > > > > > > > not called.
> > > > > > > > > >
> > > > > > > > > > The last refcnt is not released unless we retrieve th=
e TX timestamped
> > > > > > > > > > skb by recvmsg().  When we close() the socket holding=
 such skb, we
> > > > > > > > > > never call sock_put() and leak the count, skb, and sk=
.
> > > > > > > > > >
> > > > > > > > > > To avoid this problem, we must (i) call skb_queue_pur=
ge() after
> > > > > > > > > > flagging SOCK_DEAD during close() and (ii) make sure =
that TX tstamp
> > > > > > > > > > skb is not queued when SOCK_DEAD is flagged.  UDP lac=
ks (i) and (ii),
> > > > > > > > > > and TCP lacks (ii).
> > > > > > > > > >
> > > > > > > > > > Without (ii), a skb queued in a qdisc or device could=
 be put into
> > > > > > > > > > the error queue after skb_queue_purge().
> > > > > > > > > >
> > > > > > > > > >   sendmsg() /* return immediately, but packets
> > > > > > > > > >              * are queued in a qdisc or device
> > > > > > > > > >              */
> > > > > > > > > >                                     close()
> > > > > > > > > >                                       skb_queue_purge=
()
> > > > > > > > > >   __skb_tstamp_tx()
> > > > > > > > > >     __skb_complete_tx_timestamp()
> > > > > > > > > >       sock_queue_err_skb()
> > > > > > > > > >         skb_queue_tail()
> > > > > > > > > >
> > > > > > > > > > Also, we need to check SOCK_DEAD under sk->sk_error_q=
ueue.lock
> > > > > > > > > > in sock_queue_err_skb() to avoid this race.
> > > > > > > > > >
> > > > > > > > > >   if (!sock_flag(sk, SOCK_DEAD))
> > > > > > > > > >                                     sock_set_flag(sk,=
 SOCK_DEAD)
> > > > > > > > > >                                     skb_queue_purge()=

> > > > > > > > > >
> > > > > > > > > >     skb_queue_tail()
> > > > > > > > > >
> > > > > > > > > > [0]:
> > > > > > > > >
> > > > > > > > > > Fixes: f214f915e7db ("tcp: enable MSG_ZEROCOPY")
> > > > > > > > > > Fixes: b5947e5d1e71 ("udp: msg_zerocopy")
> > > > > > > > > > Reported-by: syzbot <syzkaller@googlegroups.com>
> > > > > > > > > > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> > > > > > > > > > ---
> > > > > > > > > > v2:
> > > > > > > > > >   * Move skb_queue_purge() after setting SOCK_DEAD in=
 udp_destroy_sock()
> > > > > > > > > >   * Check SOCK_DEAD in sock_queue_err_skb() with sk_e=
rror_queue.lock
> > > > > > > > > >   * Add Fixes tag for TCP
> > > > > > > > > >
> > > > > > > > > > v1: https://lore.kernel.org/netdev/20230417171155.229=
16-1-kuniyu@amazon.com/
> > > > > > > > > > ---
> > > > > > > > > >  net/core/skbuff.c | 15 ++++++++++++---
> > > > > > > > > >  net/ipv4/udp.c    |  5 +++++
> > > > > > > > > >  2 files changed, 17 insertions(+), 3 deletions(-)
> > > > > > > > > >
> > > > > > > > > > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > > > > > > > > > index 4c0879798eb8..287b834df9c8 100644
> > > > > > > > > > --- a/net/core/skbuff.c
> > > > > > > > > > +++ b/net/core/skbuff.c
> > > > > > > > > > @@ -4979,6 +4979,8 @@ static void skb_set_err_queue(s=
truct sk_buff *skb)
> > > > > > > > > >   */
> > > > > > > > > >  int sock_queue_err_skb(struct sock *sk, struct sk_bu=
ff *skb)
> > > > > > > > > >  {
> > > > > > > > > > +       unsigned long flags;
> > > > > > > > > > +
> > > > > > > > > >         if (atomic_read(&sk->sk_rmem_alloc) + skb->tr=
uesize >=3D
> > > > > > > > > >             (unsigned int)READ_ONCE(sk->sk_rcvbuf))
> > > > > > > > > >                 return -ENOMEM;
> > > > > > > > > > @@ -4992,9 +4994,16 @@ int sock_queue_err_skb(struct =
sock *sk, struct sk_buff *skb)
> > > > > > > > > >         /* before exiting rcu section, make sure dst =
is refcounted */
> > > > > > > > > >         skb_dst_force(skb);
> > > > > > > > > >
> > > > > > > > > > -       skb_queue_tail(&sk->sk_error_queue, skb);
> > > > > > > > > > -       if (!sock_flag(sk, SOCK_DEAD))
> > > > > > > > > > -               sk_error_report(sk);
> > > > > > > > > > +       spin_lock_irqsave(&sk->sk_error_queue.lock, f=
lags);
> > > > > > > > > > +       if (sock_flag(sk, SOCK_DEAD)) {
> > > > > > > > >
> > > > > > > > > SOCK_DEAD is set without holding sk_error_queue.lock, s=
o I wonder why you
> > > > > > > > > want to add a confusing construct.
> > > > > > > > >
> > > > > > > > > Just bail early ?
> > > > > > > > >
> > > > > > > > > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > > > > > > > > index ef81452759be3fd251faaf76d89cfd002ee79256..fda05cb=
44f95821e98f8c5c05fba840a9d276abb
> > > > > > > > > 100644
> > > > > > > > > --- a/net/core/skbuff.c
> > > > > > > > > +++ b/net/core/skbuff.c
> > > > > > > > > @@ -4983,6 +4983,9 @@ int sock_queue_err_skb(struct soc=
k *sk, struct
> > > > > > > > > sk_buff *skb)
> > > > > > > > >             (unsigned int)READ_ONCE(sk->sk_rcvbuf))
> > > > > > > > >                 return -ENOMEM;
> > > > > > > > >
> > > > > > > > > +       if (sock_flag(sk, SOCK_DEAD))
> > > > > > > > > +               return -EINVAL;
> > > > > > > > > +
> > > > > > > >
> > > > > > > > Isn't it possible that these sequences happen
> > > > > > > >
> > > > > > > >   close()
> > > > > > > >     sock_set_flag(sk, SOCK_DEAD);
> > > > > > > >     skb_queue_purge(&sk->sk_error_queue)
> > > > > > > >
> > > > > > > > between the skb_queue_tail() below ? (2nd race mentioned =
in changelog)
> > > > > > > >
> > > > > > > > I thought we can guarantee the ordering by taking the sam=
e lock.
> > > > > > > >
> > > > > > >
> > > > > > > This is fragile.
> > > > > >
> > > > > > Yes, but I didn't have better idea to avoid the race...
> > > > > >
> > > > > > >
> > > > > > > We could very well rewrite skb_queue_purge() to not acquire=
 the lock
> > > > > > > in the common case.
> > > > > > > I had the following in my tree for a while, to avoid many a=
tomic and
> > > > > > > irq masking operations...
> > > > > >
> > > > > > Cool, and it still works with my patch, no ?
> > > > > >
> > > > > =

> > > > > =

> > > > > Really the only thing that ensures a race is not possible is th=
e
> > > > > typical sk_refcnt acquisition.
> > > > > =

> > > > > But I do not see why an skb stored in error_queue should keep t=
he
> > > > > refcnt on the socket.
> > > > > This seems like a chicken and egg problem, and caused various i=
ssues
> > > > > in the past,
> > > > > see for instance [1]
> > > > > =

> > > > > We better make sure error queue is purged at socket dismantle (=
after
> > > > > refcnt reached 0)
> > > > =

> > > > The problem here is that the timestamp queued on the error queue
> > > > holds a reference on a ubuf if MSG_ZEROCOPY and that ubuf holds a=
n
> > > > sk_ref.
> > > > =

> > > > The timestamped packet may contain packet contents, so the ubuf
> > > > ref is not superfluous.
> > > > =

> > > > Come to think of it, we've always maintained that zerocopy packet=
s
> > > > should not be looped to sockets where they can be queued indefini=
tely,
> > > > including packet sockets.
> > > > =

> > > > If we enforce that for these tx timestamps too, then that also
> > > > solves this issue.
> > > > =

> > > > A process that wants efficient MSG_ZEROCOPY will have to request
> > > > timestamping with SOF_TIMESTAMPING_OPT_TSONLY to avoid returning =
the
> > > > data along with the timestamp.
> > > =

> > > Actually, my first attempt was similar to this that avoids skb_clon=
e()
> > > silently if MSG_ZEROCOPY, but this kind of way could break users wh=
o
> > > were using tstamp and just added MSG_ZEROCOPY logic to their app, s=
o
> > > I placed skb_queue_purge() during close().
> > > =

> > > ---8<---
> > > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > > index eb7d33b41e71..9318b438888e 100644
> > > --- a/net/core/skbuff.c
> > > +++ b/net/core/skbuff.c
> > > @@ -5135,7 +5149,7 @@ void __skb_tstamp_tx(struct sk_buff *orig_skb=
,
> > >  	if (!skb_may_tx_timestamp(sk, tsonly))
> > >  		return;
> > >  =

> > > -	if (tsonly) {
> > > +	if (tsonly || skb_zcopy(orig_skb)) {
> > >  #ifdef CONFIG_INET
> > >  		if ((sk->sk_tsflags & SOF_TIMESTAMPING_OPT_STATS) &&
> > >  		    sk_is_tcp(sk)) {
> > > ---8<---
> > =

> > Actually, the skb_clone in __skb_tstamp_tx should already release
> > the reference on the ubuf.
> > =

> > With the same mechanism that we rely on for packet sockets, e.g.,
> > in dev_queue_xmit_nit.
> > =

> > skb_clone calls skb_orphan_frags calls skb_copy_ubufs for zerocopy
> > skbs. Which creates a copy of the data and calls skb_zcopy_clear.
> > =

> > The skb that gets queued onto the error queue should not have a
> > reference on an ubuf: skb_zcopy(skb) should return NULL.
> =

> Exactly, so how about this ?
> =

> ---8<---
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 768f9d04911f..0fa0b2ac7071 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -5166,6 +5166,9 @@ void __skb_tstamp_tx(struct sk_buff *orig_skb,
>  	if (!skb)
>  		return;
>  =

> +	if (skb_zcopy(skb) && skb_copy_ubufs(skb, GFP_ATOMIC))
> +		return;
> +
>  	if (tsonly) {
>  		skb_shinfo(skb)->tx_flags |=3D skb_shinfo(orig_skb)->tx_flags &
>  					     SKBTX_ANY_TSTAMP;
> ---8<---
> =


What I meant was that given this I don't understand how a packet
with ubuf references gets queued at all.

__skb_tstamp_tx does not queue orig_skb. It either allocates a new
skb or calls skb =3D skb_clone(orig_skb).

That existing call internally calls skb_orphan_frags and
skb_copy_ubufs.

So the extra test should not be needed. Indeed I would be surprised if
this triggers:

@@ -5164,6 +5164,8 @@ void __skb_tstamp_tx(struct sk_buff *orig_skb,
        if (!skb)
                return;
 =

+       WARN_ON_ONCE(skb_zcopy(sbk));
+

        if (tsonly) {
                skb_shinfo(skb)->tx_flags |=3D skb_shinfo(orig_skb)->tx_f=
lags &
                                             SKBTX_ANY_TSTAMP;
