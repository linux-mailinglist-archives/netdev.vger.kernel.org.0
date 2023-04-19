Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB0306E80A3
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 19:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232570AbjDSRu6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 13:50:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbjDSRu4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 13:50:56 -0400
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E084194
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 10:50:50 -0700 (PDT)
Received: by mail-qv1-xf35.google.com with SMTP id oo30so363167qvb.12
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 10:50:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681926648; x=1684518648;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pj57cZsRL6y+8QXYLlujWyQMbq7+ciJraEZpBShbDP4=;
        b=bfqkf5W3jtfLtSThQZZDsn5dUQ1zfDoQSrjTrn1wtDYI7DXlAIuMtmiBoFuoV4P4Pm
         bpQqz6sw4ZgiOOBYI44NdInGsuPWi2kdeZYRaDBWDxHZ8j/5pObPhML1xPcaYERd7+JR
         2lwOLuv2EbeQBUptZVcXFmx4hbUKO7i1yctnUhH/nvXKThL4qgm5ysG6UEwvD8A/gCbU
         EqNFPUTUhgIMK+5/V/MUbDv5hecIkck4BjEbYIUnfzYp9YUlwUlMTxDiFn2GfRbO6FOY
         JlK6IFk/PZJ8ynO0YPs8mWBI9np+XqPIKnjdYMHjDNvvif/oUHVBtV0vC23PgBokewYU
         v1bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681926648; x=1684518648;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=pj57cZsRL6y+8QXYLlujWyQMbq7+ciJraEZpBShbDP4=;
        b=ErCh9MaJiSixh57oiMYMhoE9dFYdQOx/5erkClpAzfmT6I09vXiZy1dAfxiywM8xPZ
         kW6r72zbctHodEsmfiOJlt/QiYw+zouuEEJNfj8MPjMao7XjQmKLmxRebXXUkUlYUfvz
         621scbfnAPZ04SRN61O5BRGhcNMUMZV0/kV6K2i/F60FUpW2JzTZ1M1nsaYBYlAv/+6O
         9ECz6flNkrpRvsr7jWHORhXzsOxWipvoGnNPeB7CaQfTzTudKCTCDvhdZkuon4/oszkc
         B4SFFUL9MpwthJQ1TEaAFdwtlXkXMhRX3Y0YfoqkyHsdEF39fyFfur6ScTx61w3nJVez
         KLig==
X-Gm-Message-State: AAQBX9f70eRJnSF3Hxy/huZPPN6ShqFC8zMsndA4Xi7D40K8O4QaJd9t
        aN1xoSh/KvnFaBPKZeOyY84=
X-Google-Smtp-Source: AKy350aLmLUnii1nrldMtbC44e+XKPPbNDdapmFLzOihq7+xlKKWZe2VRTQezOOMGtjduAUdsfFaSQ==
X-Received: by 2002:a05:6214:c89:b0:5ef:4254:d6f0 with SMTP id r9-20020a0562140c8900b005ef4254d6f0mr31638975qvr.36.1681926648547;
        Wed, 19 Apr 2023 10:50:48 -0700 (PDT)
Received: from localhost (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id l11-20020a056214028b00b005ef4ad380cesm4554099qvv.10.2023.04.19.10.50.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 10:50:48 -0700 (PDT)
Date:   Wed, 19 Apr 2023 13:50:47 -0400
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        willemdebruijn.kernel@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        kuni1840@gmail.com, kuniyu@amazon.com, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller@googlegroups.com, willemb@google.com
Message-ID: <644029f7e7814_38cc8429476@willemb.c.googlers.com.notmuch>
In-Reply-To: <20230419170727.29740-1-kuniyu@amazon.com>
References: <643ff7a7a551f_38347529475@willemb.c.googlers.com.notmuch>
 <20230419170727.29740-1-kuniyu@amazon.com>
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
> Date:   Wed, 19 Apr 2023 10:16:07 -0400
> > Eric Dumazet wrote:
> > > On Tue, Apr 18, 2023 at 9:25=E2=80=AFPM Kuniyuki Iwashima <kuniyu@a=
mazon.com> wrote:
> > > >
> > > > From:   Eric Dumazet <edumazet@google.com>
> > > > Date:   Tue, 18 Apr 2023 21:04:32 +0200
> > > > > On Tue, Apr 18, 2023 at 8:44=E2=80=AFPM Kuniyuki Iwashima <kuni=
yu@amazon.com> wrote:
> > > > > >
> > > > > > From:   Eric Dumazet <edumazet@google.com>
> > > > > > Date:   Tue, 18 Apr 2023 20:33:44 +0200
> > > > > > > On Tue, Apr 18, 2023 at 8:09=E2=80=AFPM Kuniyuki Iwashima <=
kuniyu@amazon.com> wrote:
> > > > > > > >
> > > > > > > > syzkaller reported [0] memory leaks of an UDP socket and =
ZEROCOPY
> > > > > > > > skbs.  We can reproduce the problem with these sequences:=

> > > > > > > >
> > > > > > > >   sk =3D socket(AF_INET, SOCK_DGRAM, 0)
> > > > > > > >   sk.setsockopt(SOL_SOCKET, SO_TIMESTAMPING, SOF_TIMESTAM=
PING_TX_SOFTWARE)
> > > > > > > >   sk.setsockopt(SOL_SOCKET, SO_ZEROCOPY, 1)
> > > > > > > >   sk.sendto(b'', MSG_ZEROCOPY, ('127.0.0.1', 53))
> > > > > > > >   sk.close()
> > > > > > > >
> > > > > > > > sendmsg() calls msg_zerocopy_alloc(), which allocates a s=
kb, sets
> > > > > > > > skb->cb->ubuf.refcnt to 1, and calls sock_hold().  Here, =
struct
> > > > > > > > ubuf_info_msgzc indirectly holds a refcnt of the socket. =
 When the
> > > > > > > > skb is sent, __skb_tstamp_tx() clones it and puts the clo=
ne into
> > > > > > > > the socket's error queue with the TX timestamp.
> > > > > > > >
> > > > > > > > When the original skb is received locally, skb_copy_ubufs=
() calls
> > > > > > > > skb_unclone(), and pskb_expand_head() increments skb->cb-=
>ubuf.refcnt.
> > > > > > > > This additional count is decremented while freeing the sk=
b, but struct
> > > > > > > > ubuf_info_msgzc still has a refcnt, so __msg_zerocopy_cal=
lback() is
> > > > > > > > not called.
> > > > > > > >
> > > > > > > > The last refcnt is not released unless we retrieve the TX=
 timestamped
> > > > > > > > skb by recvmsg().  When we close() the socket holding suc=
h skb, we
> > > > > > > > never call sock_put() and leak the count, skb, and sk.
> > > > > > > >
> > > > > > > > To avoid this problem, we must (i) call skb_queue_purge()=
 after
> > > > > > > > flagging SOCK_DEAD during close() and (ii) make sure that=
 TX tstamp
> > > > > > > > skb is not queued when SOCK_DEAD is flagged.  UDP lacks (=
i) and (ii),
> > > > > > > > and TCP lacks (ii).
> > > > > > > >
> > > > > > > > Without (ii), a skb queued in a qdisc or device could be =
put into
> > > > > > > > the error queue after skb_queue_purge().
> > > > > > > >
> > > > > > > >   sendmsg() /* return immediately, but packets
> > > > > > > >              * are queued in a qdisc or device
> > > > > > > >              */
> > > > > > > >                                     close()
> > > > > > > >                                       skb_queue_purge()
> > > > > > > >   __skb_tstamp_tx()
> > > > > > > >     __skb_complete_tx_timestamp()
> > > > > > > >       sock_queue_err_skb()
> > > > > > > >         skb_queue_tail()
> > > > > > > >
> > > > > > > > Also, we need to check SOCK_DEAD under sk->sk_error_queue=
.lock
> > > > > > > > in sock_queue_err_skb() to avoid this race.
> > > > > > > >
> > > > > > > >   if (!sock_flag(sk, SOCK_DEAD))
> > > > > > > >                                     sock_set_flag(sk, SOC=
K_DEAD)
> > > > > > > >                                     skb_queue_purge()
> > > > > > > >
> > > > > > > >     skb_queue_tail()
> > > > > > > >
> > > > > > > > [0]:
> > > > > > >
> > > > > > > > Fixes: f214f915e7db ("tcp: enable MSG_ZEROCOPY")
> > > > > > > > Fixes: b5947e5d1e71 ("udp: msg_zerocopy")
> > > > > > > > Reported-by: syzbot <syzkaller@googlegroups.com>
> > > > > > > > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> > > > > > > > ---
> > > > > > > > v2:
> > > > > > > >   * Move skb_queue_purge() after setting SOCK_DEAD in udp=
_destroy_sock()
> > > > > > > >   * Check SOCK_DEAD in sock_queue_err_skb() with sk_error=
_queue.lock
> > > > > > > >   * Add Fixes tag for TCP
> > > > > > > >
> > > > > > > > v1: https://lore.kernel.org/netdev/20230417171155.22916-1=
-kuniyu@amazon.com/
> > > > > > > > ---
> > > > > > > >  net/core/skbuff.c | 15 ++++++++++++---
> > > > > > > >  net/ipv4/udp.c    |  5 +++++
> > > > > > > >  2 files changed, 17 insertions(+), 3 deletions(-)
> > > > > > > >
> > > > > > > > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > > > > > > > index 4c0879798eb8..287b834df9c8 100644
> > > > > > > > --- a/net/core/skbuff.c
> > > > > > > > +++ b/net/core/skbuff.c
> > > > > > > > @@ -4979,6 +4979,8 @@ static void skb_set_err_queue(struc=
t sk_buff *skb)
> > > > > > > >   */
> > > > > > > >  int sock_queue_err_skb(struct sock *sk, struct sk_buff *=
skb)
> > > > > > > >  {
> > > > > > > > +       unsigned long flags;
> > > > > > > > +
> > > > > > > >         if (atomic_read(&sk->sk_rmem_alloc) + skb->truesi=
ze >=3D
> > > > > > > >             (unsigned int)READ_ONCE(sk->sk_rcvbuf))
> > > > > > > >                 return -ENOMEM;
> > > > > > > > @@ -4992,9 +4994,16 @@ int sock_queue_err_skb(struct sock=
 *sk, struct sk_buff *skb)
> > > > > > > >         /* before exiting rcu section, make sure dst is r=
efcounted */
> > > > > > > >         skb_dst_force(skb);
> > > > > > > >
> > > > > > > > -       skb_queue_tail(&sk->sk_error_queue, skb);
> > > > > > > > -       if (!sock_flag(sk, SOCK_DEAD))
> > > > > > > > -               sk_error_report(sk);
> > > > > > > > +       spin_lock_irqsave(&sk->sk_error_queue.lock, flags=
);
> > > > > > > > +       if (sock_flag(sk, SOCK_DEAD)) {
> > > > > > >
> > > > > > > SOCK_DEAD is set without holding sk_error_queue.lock, so I =
wonder why you
> > > > > > > want to add a confusing construct.
> > > > > > >
> > > > > > > Just bail early ?
> > > > > > >
> > > > > > > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > > > > > > index ef81452759be3fd251faaf76d89cfd002ee79256..fda05cb44f9=
5821e98f8c5c05fba840a9d276abb
> > > > > > > 100644
> > > > > > > --- a/net/core/skbuff.c
> > > > > > > +++ b/net/core/skbuff.c
> > > > > > > @@ -4983,6 +4983,9 @@ int sock_queue_err_skb(struct sock *s=
k, struct
> > > > > > > sk_buff *skb)
> > > > > > >             (unsigned int)READ_ONCE(sk->sk_rcvbuf))
> > > > > > >                 return -ENOMEM;
> > > > > > >
> > > > > > > +       if (sock_flag(sk, SOCK_DEAD))
> > > > > > > +               return -EINVAL;
> > > > > > > +
> > > > > >
> > > > > > Isn't it possible that these sequences happen
> > > > > >
> > > > > >   close()
> > > > > >     sock_set_flag(sk, SOCK_DEAD);
> > > > > >     skb_queue_purge(&sk->sk_error_queue)
> > > > > >
> > > > > > between the skb_queue_tail() below ? (2nd race mentioned in c=
hangelog)
> > > > > >
> > > > > > I thought we can guarantee the ordering by taking the same lo=
ck.
> > > > > >
> > > > >
> > > > > This is fragile.
> > > >
> > > > Yes, but I didn't have better idea to avoid the race...
> > > >
> > > > >
> > > > > We could very well rewrite skb_queue_purge() to not acquire the=
 lock
> > > > > in the common case.
> > > > > I had the following in my tree for a while, to avoid many atomi=
c and
> > > > > irq masking operations...
> > > >
> > > > Cool, and it still works with my patch, no ?
> > > >
> > > =

> > > =

> > > Really the only thing that ensures a race is not possible is the
> > > typical sk_refcnt acquisition.
> > > =

> > > But I do not see why an skb stored in error_queue should keep the
> > > refcnt on the socket.
> > > This seems like a chicken and egg problem, and caused various issue=
s
> > > in the past,
> > > see for instance [1]
> > > =

> > > We better make sure error queue is purged at socket dismantle (afte=
r
> > > refcnt reached 0)
> > =

> > The problem here is that the timestamp queued on the error queue
> > holds a reference on a ubuf if MSG_ZEROCOPY and that ubuf holds an
> > sk_ref.
> > =

> > The timestamped packet may contain packet contents, so the ubuf
> > ref is not superfluous.
> > =

> > Come to think of it, we've always maintained that zerocopy packets
> > should not be looped to sockets where they can be queued indefinitely=
,
> > including packet sockets.
> > =

> > If we enforce that for these tx timestamps too, then that also
> > solves this issue.
> > =

> > A process that wants efficient MSG_ZEROCOPY will have to request
> > timestamping with SOF_TIMESTAMPING_OPT_TSONLY to avoid returning the
> > data along with the timestamp.
> =

> Actually, my first attempt was similar to this that avoids skb_clone()
> silently if MSG_ZEROCOPY, but this kind of way could break users who
> were using tstamp and just added MSG_ZEROCOPY logic to their app, so
> I placed skb_queue_purge() during close().
> =

> ---8<---
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index eb7d33b41e71..9318b438888e 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -5135,7 +5149,7 @@ void __skb_tstamp_tx(struct sk_buff *orig_skb,
>  	if (!skb_may_tx_timestamp(sk, tsonly))
>  		return;
>  =

> -	if (tsonly) {
> +	if (tsonly || skb_zcopy(orig_skb)) {
>  #ifdef CONFIG_INET
>  		if ((sk->sk_tsflags & SOF_TIMESTAMPING_OPT_STATS) &&
>  		    sk_is_tcp(sk)) {
> ---8<---

Actually, the skb_clone in __skb_tstamp_tx should already release
the reference on the ubuf.

With the same mechanism that we rely on for packet sockets, e.g.,
in dev_queue_xmit_nit.

skb_clone calls skb_orphan_frags calls skb_copy_ubufs for zerocopy
skbs. Which creates a copy of the data and calls skb_zcopy_clear.

The skb that gets queued onto the error queue should not have a
reference on an ubuf: skb_zcopy(skb) should return NULL.

> =

> > =

> > > I suggest we generalize fix that went in this patch :
> > > =

> > > dd4f10722aeb10f4f582948839f066bebe44e5fb net: fix socket refcountin=
g
> > > in skb_complete_wifi_ack()
> > > =

> > > Instead of adding yet another rule about a queue lock, and a socket=

> > > flag, this would keep things tied to sk_refcnt.
> > > =

> > > Also I do not think TCP has an issue, please take a look at
> > > =

> > > [1]
> > > commit e0c8bccd40fc1c19e1d246c39bcf79e357e1ada3    net: stream: pur=
ge
> > > sk_error_queue in sk_stream_kill_queues()
> > > =

> > > (A leak in TCP would be caught in a few hours by syzbot really)
> =

> I have tested TCP before posting v1 and found this skb_queue_purge()
> was to prevent the same issue, but Willem's point sounds reasonable
> that packets queued in qdisc or device could be put in the error queue
> after close() completes.  That's why I mentioned TCP since v2.


