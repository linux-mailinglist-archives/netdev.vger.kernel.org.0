Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE256E7C23
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 16:17:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232389AbjDSOQ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 10:16:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232405AbjDSOQi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 10:16:38 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8325E1793E
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 07:16:09 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id a23so28280803qtj.8
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 07:16:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681913768; x=1684505768;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+eQqn8O8PBxwQC//+x27I6ihrALCnpS5EC2jX3A51E8=;
        b=g++4rzuINJz3OJd+N0SyjG7vOUD0R/rMqQABoKQTRzMW3tBs/bo2tMTcoUYZcgz66F
         tIKGHszoG5w6nvDBJ+wRsDrAdUehiHY5kI3GHSN5tyWVh2qZFh2jCtmiha89lFnLmUNu
         PHP97pcEgK7hwZknf0IhHrhncPSMZ6oRwG0gkyXpaNCjULVlsXiMzRSD/pd/YLNmLfFP
         2MK/qDUQSb/khrDhgk5VU95K+b3i4XO+2L5FeQUybVFBA6YLBs31+WlmVH0oW7rDTisg
         PePyw3P1tonHTrWZEKw17OxHnF2aCKzO5+U6SaJtSG2uFztbDQTKC0Hf0dxOQWnUiUBB
         uA6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681913768; x=1684505768;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+eQqn8O8PBxwQC//+x27I6ihrALCnpS5EC2jX3A51E8=;
        b=K32qnaMamCz4MD/QVsNcbPE1+9eLS+Om6YSa3uAMCMC1HtvuCmXX1SgacQUYO03P6v
         w3//54r2KnnVgqttFNCn5vH3PvfYJ0FBnfbVqU8ncSRaJ6Jmo+KPmuFg1GT0PhxqJ4Ga
         i/fE2ZBY+KaMpfhSR9VQTXPkSQNhPqV1UKNr7zMOcGFY2NjXYgoCCD1MJZT+E+MtHgrJ
         x9TjgEHQPWH/mcDNSIdMFetCW0/akNgdzMAh4QcCP95CxBZmQsYNicKVYHte7lAeH2O7
         UGj6ERDCMP3cMpZO3os0yiUgxOMxUftUw3+6R8P7Y8fv0yLCIZQ2b7HhC24g0O6IPK0m
         Xslg==
X-Gm-Message-State: AAQBX9dVZxYesBk0Tr3fGgxX8a6g++ecWmFx545KAxnQc/g/gVsbBIi8
        Gs0sl+lOpu4jXoBU09XXjTo=
X-Google-Smtp-Source: AKy350a/bB9PfgJ4OTa2qdowyp/WjP/MY11fB/aWiD2dPQ7J8Nd9wBA/WX3RyaSEYXxsLyNVnh/7YQ==
X-Received: by 2002:a05:622a:201:b0:3e4:488c:9325 with SMTP id b1-20020a05622a020100b003e4488c9325mr6578456qtx.15.1681913768590;
        Wed, 19 Apr 2023 07:16:08 -0700 (PDT)
Received: from localhost (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id j20-20020a05620a289400b0074a0051fcd4sm4653494qkp.88.2023.04.19.07.16.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 07:16:07 -0700 (PDT)
Date:   Wed, 19 Apr 2023 10:16:07 -0400
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     Eric Dumazet <edumazet@google.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     davem@davemloft.net, kuba@kernel.org, kuni1840@gmail.com,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller@googlegroups.com, willemb@google.com
Message-ID: <643ff7a7a551f_38347529475@willemb.c.googlers.com.notmuch>
In-Reply-To: <CANn89iJyUrASSCAWxZ5rUnUBrQzrS0KW=mrYUCLvjj+_QVBceg@mail.gmail.com>
References: <CANn89iJ3MhBYtU3vCNjLLo45tu3eyp4TbJBGP1t8yxarK2Sziw@mail.gmail.com>
 <20230418192504.98991-1-kuniyu@amazon.com>
 <CANn89iJyUrASSCAWxZ5rUnUBrQzrS0KW=mrYUCLvjj+_QVBceg@mail.gmail.com>
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

Eric Dumazet wrote:
> On Tue, Apr 18, 2023 at 9:25=E2=80=AFPM Kuniyuki Iwashima <kuniyu@amazo=
n.com> wrote:
> >
> > From:   Eric Dumazet <edumazet@google.com>
> > Date:   Tue, 18 Apr 2023 21:04:32 +0200
> > > On Tue, Apr 18, 2023 at 8:44=E2=80=AFPM Kuniyuki Iwashima <kuniyu@a=
mazon.com> wrote:
> > > >
> > > > From:   Eric Dumazet <edumazet@google.com>
> > > > Date:   Tue, 18 Apr 2023 20:33:44 +0200
> > > > > On Tue, Apr 18, 2023 at 8:09=E2=80=AFPM Kuniyuki Iwashima <kuni=
yu@amazon.com> wrote:
> > > > > >
> > > > > > syzkaller reported [0] memory leaks of an UDP socket and ZERO=
COPY
> > > > > > skbs.  We can reproduce the problem with these sequences:
> > > > > >
> > > > > >   sk =3D socket(AF_INET, SOCK_DGRAM, 0)
> > > > > >   sk.setsockopt(SOL_SOCKET, SO_TIMESTAMPING, SOF_TIMESTAMPING=
_TX_SOFTWARE)
> > > > > >   sk.setsockopt(SOL_SOCKET, SO_ZEROCOPY, 1)
> > > > > >   sk.sendto(b'', MSG_ZEROCOPY, ('127.0.0.1', 53))
> > > > > >   sk.close()
> > > > > >
> > > > > > sendmsg() calls msg_zerocopy_alloc(), which allocates a skb, =
sets
> > > > > > skb->cb->ubuf.refcnt to 1, and calls sock_hold().  Here, stru=
ct
> > > > > > ubuf_info_msgzc indirectly holds a refcnt of the socket.  Whe=
n the
> > > > > > skb is sent, __skb_tstamp_tx() clones it and puts the clone i=
nto
> > > > > > the socket's error queue with the TX timestamp.
> > > > > >
> > > > > > When the original skb is received locally, skb_copy_ubufs() c=
alls
> > > > > > skb_unclone(), and pskb_expand_head() increments skb->cb->ubu=
f.refcnt.
> > > > > > This additional count is decremented while freeing the skb, b=
ut struct
> > > > > > ubuf_info_msgzc still has a refcnt, so __msg_zerocopy_callbac=
k() is
> > > > > > not called.
> > > > > >
> > > > > > The last refcnt is not released unless we retrieve the TX tim=
estamped
> > > > > > skb by recvmsg().  When we close() the socket holding such sk=
b, we
> > > > > > never call sock_put() and leak the count, skb, and sk.
> > > > > >
> > > > > > To avoid this problem, we must (i) call skb_queue_purge() aft=
er
> > > > > > flagging SOCK_DEAD during close() and (ii) make sure that TX =
tstamp
> > > > > > skb is not queued when SOCK_DEAD is flagged.  UDP lacks (i) a=
nd (ii),
> > > > > > and TCP lacks (ii).
> > > > > >
> > > > > > Without (ii), a skb queued in a qdisc or device could be put =
into
> > > > > > the error queue after skb_queue_purge().
> > > > > >
> > > > > >   sendmsg() /* return immediately, but packets
> > > > > >              * are queued in a qdisc or device
> > > > > >              */
> > > > > >                                     close()
> > > > > >                                       skb_queue_purge()
> > > > > >   __skb_tstamp_tx()
> > > > > >     __skb_complete_tx_timestamp()
> > > > > >       sock_queue_err_skb()
> > > > > >         skb_queue_tail()
> > > > > >
> > > > > > Also, we need to check SOCK_DEAD under sk->sk_error_queue.loc=
k
> > > > > > in sock_queue_err_skb() to avoid this race.
> > > > > >
> > > > > >   if (!sock_flag(sk, SOCK_DEAD))
> > > > > >                                     sock_set_flag(sk, SOCK_DE=
AD)
> > > > > >                                     skb_queue_purge()
> > > > > >
> > > > > >     skb_queue_tail()
> > > > > >
> > > > > > [0]:
> > > > >
> > > > > > Fixes: f214f915e7db ("tcp: enable MSG_ZEROCOPY")
> > > > > > Fixes: b5947e5d1e71 ("udp: msg_zerocopy")
> > > > > > Reported-by: syzbot <syzkaller@googlegroups.com>
> > > > > > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> > > > > > ---
> > > > > > v2:
> > > > > >   * Move skb_queue_purge() after setting SOCK_DEAD in udp_des=
troy_sock()
> > > > > >   * Check SOCK_DEAD in sock_queue_err_skb() with sk_error_que=
ue.lock
> > > > > >   * Add Fixes tag for TCP
> > > > > >
> > > > > > v1: https://lore.kernel.org/netdev/20230417171155.22916-1-kun=
iyu@amazon.com/
> > > > > > ---
> > > > > >  net/core/skbuff.c | 15 ++++++++++++---
> > > > > >  net/ipv4/udp.c    |  5 +++++
> > > > > >  2 files changed, 17 insertions(+), 3 deletions(-)
> > > > > >
> > > > > > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > > > > > index 4c0879798eb8..287b834df9c8 100644
> > > > > > --- a/net/core/skbuff.c
> > > > > > +++ b/net/core/skbuff.c
> > > > > > @@ -4979,6 +4979,8 @@ static void skb_set_err_queue(struct sk=
_buff *skb)
> > > > > >   */
> > > > > >  int sock_queue_err_skb(struct sock *sk, struct sk_buff *skb)=

> > > > > >  {
> > > > > > +       unsigned long flags;
> > > > > > +
> > > > > >         if (atomic_read(&sk->sk_rmem_alloc) + skb->truesize >=
=3D
> > > > > >             (unsigned int)READ_ONCE(sk->sk_rcvbuf))
> > > > > >                 return -ENOMEM;
> > > > > > @@ -4992,9 +4994,16 @@ int sock_queue_err_skb(struct sock *sk=
, struct sk_buff *skb)
> > > > > >         /* before exiting rcu section, make sure dst is refco=
unted */
> > > > > >         skb_dst_force(skb);
> > > > > >
> > > > > > -       skb_queue_tail(&sk->sk_error_queue, skb);
> > > > > > -       if (!sock_flag(sk, SOCK_DEAD))
> > > > > > -               sk_error_report(sk);
> > > > > > +       spin_lock_irqsave(&sk->sk_error_queue.lock, flags);
> > > > > > +       if (sock_flag(sk, SOCK_DEAD)) {
> > > > >
> > > > > SOCK_DEAD is set without holding sk_error_queue.lock, so I wond=
er why you
> > > > > want to add a confusing construct.
> > > > >
> > > > > Just bail early ?
> > > > >
> > > > > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > > > > index ef81452759be3fd251faaf76d89cfd002ee79256..fda05cb44f95821=
e98f8c5c05fba840a9d276abb
> > > > > 100644
> > > > > --- a/net/core/skbuff.c
> > > > > +++ b/net/core/skbuff.c
> > > > > @@ -4983,6 +4983,9 @@ int sock_queue_err_skb(struct sock *sk, s=
truct
> > > > > sk_buff *skb)
> > > > >             (unsigned int)READ_ONCE(sk->sk_rcvbuf))
> > > > >                 return -ENOMEM;
> > > > >
> > > > > +       if (sock_flag(sk, SOCK_DEAD))
> > > > > +               return -EINVAL;
> > > > > +
> > > >
> > > > Isn't it possible that these sequences happen
> > > >
> > > >   close()
> > > >     sock_set_flag(sk, SOCK_DEAD);
> > > >     skb_queue_purge(&sk->sk_error_queue)
> > > >
> > > > between the skb_queue_tail() below ? (2nd race mentioned in chang=
elog)
> > > >
> > > > I thought we can guarantee the ordering by taking the same lock.
> > > >
> > >
> > > This is fragile.
> >
> > Yes, but I didn't have better idea to avoid the race...
> >
> > >
> > > We could very well rewrite skb_queue_purge() to not acquire the loc=
k
> > > in the common case.
> > > I had the following in my tree for a while, to avoid many atomic an=
d
> > > irq masking operations...
> >
> > Cool, and it still works with my patch, no ?
> >
> =

> =

> Really the only thing that ensures a race is not possible is the
> typical sk_refcnt acquisition.
> =

> But I do not see why an skb stored in error_queue should keep the
> refcnt on the socket.
> This seems like a chicken and egg problem, and caused various issues
> in the past,
> see for instance [1]
> =

> We better make sure error queue is purged at socket dismantle (after
> refcnt reached 0)

The problem here is that the timestamp queued on the error queue
holds a reference on a ubuf if MSG_ZEROCOPY and that ubuf holds an
sk_ref.

The timestamped packet may contain packet contents, so the ubuf
ref is not superfluous.

Come to think of it, we've always maintained that zerocopy packets
should not be looped to sockets where they can be queued indefinitely,
including packet sockets.

If we enforce that for these tx timestamps too, then that also
solves this issue.

A process that wants efficient MSG_ZEROCOPY will have to request
timestamping with SOF_TIMESTAMPING_OPT_TSONLY to avoid returning the
data along with the timestamp.

> I suggest we generalize fix that went in this patch :
> =

> dd4f10722aeb10f4f582948839f066bebe44e5fb net: fix socket refcounting
> in skb_complete_wifi_ack()
> =

> Instead of adding yet another rule about a queue lock, and a socket
> flag, this would keep things tied to sk_refcnt.
> =

> Also I do not think TCP has an issue, please take a look at
> =

> [1]
> commit e0c8bccd40fc1c19e1d246c39bcf79e357e1ada3    net: stream: purge
> sk_error_queue in sk_stream_kill_queues()
> =

> (A leak in TCP would be caught in a few hours by syzbot really)


