Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50EF86E765D
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 11:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232926AbjDSJeZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 05:34:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230467AbjDSJeY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 05:34:24 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7754B83
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 02:34:23 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id ca18e2360f4ac-7606d44604aso355231539f.1
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 02:34:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681896863; x=1684488863;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ENp8JyYjIzBb3O17RqnAUNXIljBjcbzuHatI9LuxQ6o=;
        b=u34bf+s+OSKiPbAGsBX9gpVLcba7Yav/x6jkM13FbJia2eH8W8+XkFXYF1KbDrFweP
         fNY+M0ZH3VSTGN+naZktqajd7BpqmVVbFZmMZ1qNiNN2k6RzoWMCaS99OR0E88qtRYHy
         XfJL+Tc0jBUazpBMETZxcMG92lVAMMtu5OPkl57LhFq2UPQTtiukbZM2+E9KVjxk0Hrk
         zAzH+mazkD7z52yPv5rEJof0FtcKLljtS13BadJjyi2hyw0YER9Cc5XiXEkxzuCRBlA1
         5bMuHx0umgEksAed31Zx44Uxch/q/xS9v5rF6aPwRntohM0ZNbySm3JvpKhMAdARWNe4
         8Quw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681896863; x=1684488863;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ENp8JyYjIzBb3O17RqnAUNXIljBjcbzuHatI9LuxQ6o=;
        b=MhieAfnQJiLrkD2EJx2pAomulVDaBFXGrXBOqUukKNi97bxp2ScnfiZPVU6P6KDbY0
         Z9f7ZWZYhKZ4+/HnsdTrTXUFZE8Cs+owax/gWKj/sT1E9D+rbA4EkTrW1WWPzyrFx8fI
         gy8GUkGs93rjD0Bz8+jN1mzbagPO7R3hPhVMjCCCVgF2xzFDn4XxQJkME2bw0/CKpGPK
         V9WVD70WXMWHIRlMf9AWso4zn/zjMYCCvjw1fI9z94mm8WpRtyc7d9MD2Wzi7qkPogSE
         arcCzDAdN4Bcunr2urlkJmI49B+NSVtEciFgD6a8pvJsrceKvup7xp9M+jOVBIzKQ0j2
         IWMw==
X-Gm-Message-State: AAQBX9fkSuB5DvharV54glGOjPzoO1bQ7az7kVuBb68ZIuoO6hHEcILH
        RaBcTQ6lbeShMnVmA7jOcvGfgCoH9BV84+t6b2UAdA==
X-Google-Smtp-Source: AKy350aU5+QmH2TQ7yIurmQRRjnw5lCLjD+Ui8+q95mUjHF4NO0XQBUvJW48YguADqPN1kjgutybgqrpCTDf1HEnDnU=
X-Received: by 2002:a02:84c2:0:b0:40f:b4aa:62f8 with SMTP id
 f60-20020a0284c2000000b0040fb4aa62f8mr3315127jai.6.1681896862520; Wed, 19 Apr
 2023 02:34:22 -0700 (PDT)
MIME-Version: 1.0
References: <CANn89iJ3MhBYtU3vCNjLLo45tu3eyp4TbJBGP1t8yxarK2Sziw@mail.gmail.com>
 <20230418192504.98991-1-kuniyu@amazon.com>
In-Reply-To: <20230418192504.98991-1-kuniyu@amazon.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 19 Apr 2023 11:34:11 +0200
Message-ID: <CANn89iJyUrASSCAWxZ5rUnUBrQzrS0KW=mrYUCLvjj+_QVBceg@mail.gmail.com>
Subject: Re: [PATCH v2 net] tcp/udp: Fix memleaks of sk and zerocopy skbs with
 TX timestamp.
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     davem@davemloft.net, kuba@kernel.org, kuni1840@gmail.com,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller@googlegroups.com, willemb@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 18, 2023 at 9:25=E2=80=AFPM Kuniyuki Iwashima <kuniyu@amazon.co=
m> wrote:
>
> From:   Eric Dumazet <edumazet@google.com>
> Date:   Tue, 18 Apr 2023 21:04:32 +0200
> > On Tue, Apr 18, 2023 at 8:44=E2=80=AFPM Kuniyuki Iwashima <kuniyu@amazo=
n.com> wrote:
> > >
> > > From:   Eric Dumazet <edumazet@google.com>
> > > Date:   Tue, 18 Apr 2023 20:33:44 +0200
> > > > On Tue, Apr 18, 2023 at 8:09=E2=80=AFPM Kuniyuki Iwashima <kuniyu@a=
mazon.com> wrote:
> > > > >
> > > > > syzkaller reported [0] memory leaks of an UDP socket and ZEROCOPY
> > > > > skbs.  We can reproduce the problem with these sequences:
> > > > >
> > > > >   sk =3D socket(AF_INET, SOCK_DGRAM, 0)
> > > > >   sk.setsockopt(SOL_SOCKET, SO_TIMESTAMPING, SOF_TIMESTAMPING_TX_=
SOFTWARE)
> > > > >   sk.setsockopt(SOL_SOCKET, SO_ZEROCOPY, 1)
> > > > >   sk.sendto(b'', MSG_ZEROCOPY, ('127.0.0.1', 53))
> > > > >   sk.close()
> > > > >
> > > > > sendmsg() calls msg_zerocopy_alloc(), which allocates a skb, sets
> > > > > skb->cb->ubuf.refcnt to 1, and calls sock_hold().  Here, struct
> > > > > ubuf_info_msgzc indirectly holds a refcnt of the socket.  When th=
e
> > > > > skb is sent, __skb_tstamp_tx() clones it and puts the clone into
> > > > > the socket's error queue with the TX timestamp.
> > > > >
> > > > > When the original skb is received locally, skb_copy_ubufs() calls
> > > > > skb_unclone(), and pskb_expand_head() increments skb->cb->ubuf.re=
fcnt.
> > > > > This additional count is decremented while freeing the skb, but s=
truct
> > > > > ubuf_info_msgzc still has a refcnt, so __msg_zerocopy_callback() =
is
> > > > > not called.
> > > > >
> > > > > The last refcnt is not released unless we retrieve the TX timesta=
mped
> > > > > skb by recvmsg().  When we close() the socket holding such skb, w=
e
> > > > > never call sock_put() and leak the count, skb, and sk.
> > > > >
> > > > > To avoid this problem, we must (i) call skb_queue_purge() after
> > > > > flagging SOCK_DEAD during close() and (ii) make sure that TX tsta=
mp
> > > > > skb is not queued when SOCK_DEAD is flagged.  UDP lacks (i) and (=
ii),
> > > > > and TCP lacks (ii).
> > > > >
> > > > > Without (ii), a skb queued in a qdisc or device could be put into
> > > > > the error queue after skb_queue_purge().
> > > > >
> > > > >   sendmsg() /* return immediately, but packets
> > > > >              * are queued in a qdisc or device
> > > > >              */
> > > > >                                     close()
> > > > >                                       skb_queue_purge()
> > > > >   __skb_tstamp_tx()
> > > > >     __skb_complete_tx_timestamp()
> > > > >       sock_queue_err_skb()
> > > > >         skb_queue_tail()
> > > > >
> > > > > Also, we need to check SOCK_DEAD under sk->sk_error_queue.lock
> > > > > in sock_queue_err_skb() to avoid this race.
> > > > >
> > > > >   if (!sock_flag(sk, SOCK_DEAD))
> > > > >                                     sock_set_flag(sk, SOCK_DEAD)
> > > > >                                     skb_queue_purge()
> > > > >
> > > > >     skb_queue_tail()
> > > > >
> > > > > [0]:
> > > >
> > > > > Fixes: f214f915e7db ("tcp: enable MSG_ZEROCOPY")
> > > > > Fixes: b5947e5d1e71 ("udp: msg_zerocopy")
> > > > > Reported-by: syzbot <syzkaller@googlegroups.com>
> > > > > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> > > > > ---
> > > > > v2:
> > > > >   * Move skb_queue_purge() after setting SOCK_DEAD in udp_destroy=
_sock()
> > > > >   * Check SOCK_DEAD in sock_queue_err_skb() with sk_error_queue.l=
ock
> > > > >   * Add Fixes tag for TCP
> > > > >
> > > > > v1: https://lore.kernel.org/netdev/20230417171155.22916-1-kuniyu@=
amazon.com/
> > > > > ---
> > > > >  net/core/skbuff.c | 15 ++++++++++++---
> > > > >  net/ipv4/udp.c    |  5 +++++
> > > > >  2 files changed, 17 insertions(+), 3 deletions(-)
> > > > >
> > > > > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > > > > index 4c0879798eb8..287b834df9c8 100644
> > > > > --- a/net/core/skbuff.c
> > > > > +++ b/net/core/skbuff.c
> > > > > @@ -4979,6 +4979,8 @@ static void skb_set_err_queue(struct sk_buf=
f *skb)
> > > > >   */
> > > > >  int sock_queue_err_skb(struct sock *sk, struct sk_buff *skb)
> > > > >  {
> > > > > +       unsigned long flags;
> > > > > +
> > > > >         if (atomic_read(&sk->sk_rmem_alloc) + skb->truesize >=3D
> > > > >             (unsigned int)READ_ONCE(sk->sk_rcvbuf))
> > > > >                 return -ENOMEM;
> > > > > @@ -4992,9 +4994,16 @@ int sock_queue_err_skb(struct sock *sk, st=
ruct sk_buff *skb)
> > > > >         /* before exiting rcu section, make sure dst is refcounte=
d */
> > > > >         skb_dst_force(skb);
> > > > >
> > > > > -       skb_queue_tail(&sk->sk_error_queue, skb);
> > > > > -       if (!sock_flag(sk, SOCK_DEAD))
> > > > > -               sk_error_report(sk);
> > > > > +       spin_lock_irqsave(&sk->sk_error_queue.lock, flags);
> > > > > +       if (sock_flag(sk, SOCK_DEAD)) {
> > > >
> > > > SOCK_DEAD is set without holding sk_error_queue.lock, so I wonder w=
hy you
> > > > want to add a confusing construct.
> > > >
> > > > Just bail early ?
> > > >
> > > > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > > > index ef81452759be3fd251faaf76d89cfd002ee79256..fda05cb44f95821e98f=
8c5c05fba840a9d276abb
> > > > 100644
> > > > --- a/net/core/skbuff.c
> > > > +++ b/net/core/skbuff.c
> > > > @@ -4983,6 +4983,9 @@ int sock_queue_err_skb(struct sock *sk, struc=
t
> > > > sk_buff *skb)
> > > >             (unsigned int)READ_ONCE(sk->sk_rcvbuf))
> > > >                 return -ENOMEM;
> > > >
> > > > +       if (sock_flag(sk, SOCK_DEAD))
> > > > +               return -EINVAL;
> > > > +
> > >
> > > Isn't it possible that these sequences happen
> > >
> > >   close()
> > >     sock_set_flag(sk, SOCK_DEAD);
> > >     skb_queue_purge(&sk->sk_error_queue)
> > >
> > > between the skb_queue_tail() below ? (2nd race mentioned in changelog=
)
> > >
> > > I thought we can guarantee the ordering by taking the same lock.
> > >
> >
> > This is fragile.
>
> Yes, but I didn't have better idea to avoid the race...
>
> >
> > We could very well rewrite skb_queue_purge() to not acquire the lock
> > in the common case.
> > I had the following in my tree for a while, to avoid many atomic and
> > irq masking operations...
>
> Cool, and it still works with my patch, no ?
>


Really the only thing that ensures a race is not possible is the
typical sk_refcnt acquisition.

But I do not see why an skb stored in error_queue should keep the
refcnt on the socket.
This seems like a chicken and egg problem, and caused various issues
in the past,
see for instance [1]

We better make sure error queue is purged at socket dismantle (after
refcnt reached 0)

I suggest we generalize fix that went in this patch :

dd4f10722aeb10f4f582948839f066bebe44e5fb net: fix socket refcounting
in skb_complete_wifi_ack()

Instead of adding yet another rule about a queue lock, and a socket
flag, this would keep things tied to sk_refcnt.

Also I do not think TCP has an issue, please take a look at

[1]
commit e0c8bccd40fc1c19e1d246c39bcf79e357e1ada3    net: stream: purge
sk_error_queue in sk_stream_kill_queues()

(A leak in TCP would be caught in a few hours by syzbot really)
