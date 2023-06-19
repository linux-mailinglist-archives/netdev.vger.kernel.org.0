Return-Path: <netdev+bounces-12051-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 45040735D1D
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 19:39:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 710BE2810DB
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 17:39:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D1DB13AF9;
	Mon, 19 Jun 2023 17:39:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 596AA111A9
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 17:39:35 +0000 (UTC)
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21082198
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 10:39:33 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id d75a77b69052e-3ff25ca795eso159981cf.1
        for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 10:39:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687196372; x=1689788372;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ayFQ487CT2QWVLe89ol8oaf4LIGITCKdns22LRz/IOM=;
        b=Rj9+1YIlGspvfIoMsqXyXUHu/gVREXZ5JQk+8lQe5N/2gnaPKb7SOMg6ZpfGxJIqy2
         2zQDPOCTMiphGT2xFp+d2IpqWhjHnZ3EgTLIp20vo5UmIdXLiam55Q7Sr32ClFODureW
         Og840jJUpQauEM0yqDEns9Eb/IUZGM02wdT1lXuGGKXhUH72q1zg2+4O6HsA+DK/9Bg8
         7UImItJghZGXILNpNgelch5LHmU9sTK+6eIeVstIOKBHvsgEetRNeurA9xPOTCWzNmIx
         MHJm0Sq7gEkNl/xlSsvsJPS/aBBxa5UkprAeZOFnkX2nAi0AhFke82U7c3o0KqMO/7Ag
         LEpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687196372; x=1689788372;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ayFQ487CT2QWVLe89ol8oaf4LIGITCKdns22LRz/IOM=;
        b=g9af0otoLSviWDmrrZg9TR4X09yXCP/uDAATx9oYhlezITz5/6rHVEGIpUe6xY0mSB
         79zKSdy+IrEqvA6Sliubi0MajLFMNUDxuhzkyMlyaNoAnVGnXz3GXEoVlAf4CG39HlZ5
         arIEyjE9f5MamjhJhY+5B9PlHg6Higqu4jV1KjLKTKL44hN/svMQibFIk4Ew0aGuza2M
         cSjBq9+0stOWlCOdyCXz9RVUwoRRNGNh/68Qw/2tTQzWTtNEybq5jAxC2EYTfiQYZI7w
         E/fUwu/c0AtxH6mfrY4/OUyYCphQx2OBW1Bwwhax0EIJcuPfhkzPe/E4FDm1rHnhpzNu
         H+QQ==
X-Gm-Message-State: AC+VfDzkM7vR0LfDxYtpynDs9GUO6fXOTfgP1H720Xx4ztlhoWAAsMeI
	KL/tlCPCG4FZNqWgcH6XwhSurNVxJJfG4ykCi3MNAfWbZBEz12+WQ5U=
X-Google-Smtp-Source: ACHHUZ50YyrkRcC6nQ0Lj4z90xWO7RSjCup/6bvJMa8KX9+hRkKPSCr3gqg0bwMLD4XPX335JhbVRZskLWfV6R9J60s=
X-Received: by 2002:a05:622a:2c1:b0:3ef:343b:fe7e with SMTP id
 a1-20020a05622a02c100b003ef343bfe7emr1034110qtx.2.1687196371936; Mon, 19 Jun
 2023 10:39:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CANn89iK8snOz8TYOhhwfimC7ykYA78GA3Nyv8x06SZYa1nKdyA@mail.gmail.com>
 <20230619170314.42333-1-kuniyu@amazon.com>
In-Reply-To: <20230619170314.42333-1-kuniyu@amazon.com>
From: Eric Dumazet <edumazet@google.com>
Date: Mon, 19 Jun 2023 19:39:20 +0200
Message-ID: <CANn89iJCWnG0p_5C1ams264_kA97_zaQBSx-akH_SsHFg5gG6A@mail.gmail.com>
Subject: Re: [PATCH v2] tcp: fix connection reset due to tw hashdance race.
To: Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: duanmuquan@baidu.com, davem@davemloft.net, dsahern@kernel.org, 
	kuba@kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	pabeni@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 19, 2023 at 7:03=E2=80=AFPM Kuniyuki Iwashima <kuniyu@amazon.co=
m> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
> Date: Thu, 8 Jun 2023 08:35:20 +0200
> > On Thu, Jun 8, 2023 at 7:48=E2=80=AFAM Kuniyuki Iwashima <kuniyu@amazon=
.com> wrote:
> > >
> > > From: Eric Dumazet <edumazet@google.com>
> > > Date: Wed, 7 Jun 2023 15:32:57 +0200
> > > > On Wed, Jun 7, 2023 at 1:59=E2=80=AFPM Duan,Muquan <duanmuquan@baid=
u.com> wrote:
> > > > >
> > > > > Hi, Eric,
> > > > >
> > > > >  Thanks for your comments!
> > > > >
> > > > >  About the second lookup, I am sorry that I did not give enough e=
xplanations about it. Here are some details:
> > > > >
> > > > >  1.  The second lookup can find the tw sock and avoid the connect=
ion refuse error on userland applications:
> > > > >
> > > > > If the original sock is found, but when validating its refcnt, it=
 has been destroyed and sk_refcnt has become 0 after decreased by tcp_time_=
wait()->tcp_done()->inet_csk_destory_sock()->sock_put().The validation for =
refcnt fails and the lookup process gets a listener sock.
> > > > >
> > > > > When this case occurs, the hashdance has definitely finished=EF=
=BC=8Cbecause tcp_done() is executed after inet_twsk_hashdance(). Then if l=
ook up the ehash table again, hashdance has already finished, tw sock will =
be found.
> > > > >
> > > > >  With this fix, logically we can solve the connection reset issue=
 completely when no established sock is found due to hashdance race.In my r=
eproducing environment, the connection refuse error will occur about every =
6 hours with only the fix of bad case (2). But with both of the 2 fixes, I =
tested it many times, the longest test continues for 10 days, it does not o=
ccur again,
> > > > >
> > > > >
> > > > >
> > > > > 2. About the performance impact:
> > > > >
> > > > >      A similar scenario is that __inet_lookup_established() will =
do inet_match() check for the second time, if fails it will look up    the =
list again. It is the extra effort to reduce the race impact without using =
reader lock. inet_match() failure occurs with about the same probability wi=
th refcnt validation failure in my test environment.
> > > > >
> > > > >  The second lookup will only be done in the condition that FIN se=
gment gets a listener sock.
> > > > >
> > > > >   About the performance impact:
> > > > >
> > > > > 1)  Most of the time, this condition will not met, the added code=
s introduces at most 3 comparisons for each segment.
> > > > >
> > > > > The second inet_match() in __inet_lookup_established()  does leas=
t 3 comparisons for each segmet.
> > > > >
> > > > >
> > > > > 2)  When this condition is met, the probability is very small. Th=
e impact is similar to the second try due to inet_match() failure. Since tw=
 sock can definitely be found in the second try, I think this cost is worth=
y to avoid connection reused error on userland applications.
> > > > >
> > > > >
> > > > >
> > > > > My understanding is, current philosophy is avoiding the reader lo=
ck by tolerating the minor defect which occurs in a small probability.For e=
xample, if the FIN from passive closer is dropped due to the found sock is =
destroyed, a retransmission can be tolerated, it only makes the connection =
termination slower. But I think the bottom line is that it does not affect =
the userland applications=E2=80=99 functionality. If application fails to c=
onnect due to the hashdance race, it can=E2=80=99t be tolerated. In fact, g=
uys from product department push hard on the connection refuse error.
> > > > >
> > > > >
> > > > > About bad case (2):
> > > > >
> > > > >  tw sock is found, but its tw_refcnt has not been set to 3, it is=
 still 0, validating for sk_refcnt will fail.
> > > > >
> > > > > I do not know the reason why setting tw_refcnt after adding it in=
to list, could anyone help point out the reason? It adds  extra race becaus=
e the new added tw sock may be found and checked in other CPU concurrently =
before =C6=92setting tw_refcnt to 3.
> > > > >
> > > > > By setting tw_refcnt to 3 before adding it into list, this case w=
ill be solved, and almost no cost. In my reproducing environment, it occurs=
 more frequently than bad case (1), it appears about every 20 minutes, bad =
case (1) appears about every 6 hours.
> > > > >
> > > > >
> > > > >
> > > > > About the bucket spinlock, the original established sock and tw s=
ock are stored in the ehash table, I concern about the performance when the=
re are lots of short TCP connections, the reader lock may affect the perfor=
mance of connection creation and termination. Could you share some details =
of your idea? Thanks in advance.
> > > > >
> > > > >
> > > >
> > > > Again, you can write a lot of stuff, the fact is that your patch do=
es
> > > > not solve the issue.
> > > >
> > > > You could add 10 lookups, and still miss some cases, because they a=
re
> > > > all RCU lookups with no barriers.
> > > >
> > > > In order to solve the issue of packets for the same 4-tuple being
> > > > processed by many cpus, the only way to solve races is to add mutua=
l
> > > > exclusion.
> > > >
> > > > Note that we already have to lock the bucket spinlock every time we
> > > > transition a request socket to socket, a socket to timewait, or any
> > > > insert/delete.
> > > >
> > > > We need to expand the scope of this lock, and cleanup things that w=
e
> > > > added in the past, because we tried too hard to 'detect races'
> > >
> > > How about this ?  This is still a workaround though, retry sounds
> > > better than expanding the scope of the lock given the race is rare.
> >
> > The chance of two cpus having to hold the same spinlock is rather small=
.
> >
> > Algo is the following:
> >
> > Attempt a lockless/RCU lookup.
> >
> > 1) Socket is found, we are good to go. Fast path is still fast.
> >
> > 2) Socket  is not found in ehash
> >    - We lock the bucket spinlock.
> >    - We retry the lookup
> >    - If socket found, continue with it (release the spinlock when
> > appropriate, after all write manipulations in the bucket are done)
> >    - If socket still not found, we lookup a listener.
> >       We insert a TCP_NEW_SYN_RECV ....
> >        Again, we release the spinlock when appropriate, after all
> > write manipulations in the bucket are done)
> >
> > No more races, and the fast path is the same.
>
> I was looking around the issue this weekend.  Is this what you were
> thinking ?  I'm wondering if you were also thinking another races like
> found_dup_sk/own_req things. e.g.) acquire ehash lock when we start to
> process reqsk ?

No.

Idea is to hold the bucket lock and keep it until all write operations
in the bucket have been done.



>
> Duan, could you test the diff below ?
>
> If this resolves the FIN issue, we can also revert 3f4ca5fafc08 ("tcp:
> avoid the lookup process failing to get sk in ehash table").
>
> ---8<---
> diff --git a/include/net/inet6_hashtables.h b/include/net/inet6_hashtable=
s.h
> index 56f1286583d3..bb8e49a6e80f 100644
> --- a/include/net/inet6_hashtables.h
> +++ b/include/net/inet6_hashtables.h
> @@ -48,6 +48,11 @@ struct sock *__inet6_lookup_established(struct net *ne=
t,
>                                         const u16 hnum, const int dif,
>                                         const int sdif);
>
> +struct sock *__inet6_lookup_established_lock(struct net *net, struct ine=
t_hashinfo *hashinfo,
> +                                            const struct in6_addr *saddr=
, const __be16 sport,
> +                                            const struct in6_addr *daddr=
, const u16 hnum,
> +                                            const int dif, const int sdi=
f);
> +
>  struct sock *inet6_lookup_listener(struct net *net,
>                                    struct inet_hashinfo *hashinfo,
>                                    struct sk_buff *skb, int doff,
> @@ -70,9 +75,15 @@ static inline struct sock *__inet6_lookup(struct net *=
net,
>         struct sock *sk =3D __inet6_lookup_established(net, hashinfo, sad=
dr,
>                                                      sport, daddr, hnum,
>                                                      dif, sdif);
> -       *refcounted =3D true;
> -       if (sk)
> +
> +       if (!sk)
> +               sk =3D __inet6_lookup_established_lock(net, hashinfo, sad=
dr, sport,
> +                                                    daddr, hnum, dif, sd=
if);
> +       if (sk) {
> +               *refcounted =3D true;
>                 return sk;
> +       }
> +
>         *refcounted =3D false;
>         return inet6_lookup_listener(net, hashinfo, skb, doff, saddr, spo=
rt,
>                                      daddr, hnum, dif, sdif);
> diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.=
h
> index 99bd823e97f6..ad97fec63d7a 100644
> --- a/include/net/inet_hashtables.h
> +++ b/include/net/inet_hashtables.h
> @@ -379,6 +379,12 @@ struct sock *__inet_lookup_established(struct net *n=
et,
>                                        const __be32 daddr, const u16 hnum=
,
>                                        const int dif, const int sdif);
>
> +struct sock *__inet_lookup_established_lock(struct net *net,
> +                                           struct inet_hashinfo *hashinf=
o,
> +                                           const __be32 saddr, const __b=
e16 sport,
> +                                           const __be32 daddr, const u16=
 hnum,
> +                                           const int dif, const int sdif=
);
> +
>  static inline struct sock *
>         inet_lookup_established(struct net *net, struct inet_hashinfo *ha=
shinfo,
>                                 const __be32 saddr, const __be16 sport,
> @@ -402,9 +408,14 @@ static inline struct sock *__inet_lookup(struct net =
*net,
>
>         sk =3D __inet_lookup_established(net, hashinfo, saddr, sport,
>                                        daddr, hnum, dif, sdif);
> -       *refcounted =3D true;
> -       if (sk)
> +       if (!sk)
> +               sk =3D __inet_lookup_established_lock(net, hashinfo, sadd=
r, sport,
> +                                                   daddr, hnum, dif, sdi=
f);
> +       if (sk) {
> +               *refcounted =3D true;
>                 return sk;
> +       }
> +
>         *refcounted =3D false;
>         return __inet_lookup_listener(net, hashinfo, skb, doff, saddr,
>                                       sport, daddr, hnum, dif, sdif);
> diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
> index e7391bf310a7..1eeadaf1c9f9 100644
> --- a/net/ipv4/inet_hashtables.c
> +++ b/net/ipv4/inet_hashtables.c
> @@ -514,6 +514,41 @@ struct sock *__inet_lookup_established(struct net *n=
et,
>  }
>  EXPORT_SYMBOL_GPL(__inet_lookup_established);
>
> +struct sock *__inet_lookup_established_lock(struct net *net, struct inet=
_hashinfo *hashinfo,
> +                                           const __be32 saddr, const __b=
e16 sport,
> +                                           const __be32 daddr, const u16=
 hnum,
> +                                           const int dif, const int sdif=
)
> +{
> +       const __portpair ports =3D INET_COMBINED_PORTS(sport, hnum);
> +       INET_ADDR_COOKIE(acookie, saddr, daddr);
> +       const struct hlist_nulls_node *node;
> +       struct inet_ehash_bucket *head;
> +       unsigned int hash;
> +       spinlock_t *lock;
> +       struct sock *sk;
> +
> +       hash =3D inet_ehashfn(net, daddr, hnum, saddr, sport);
> +       head =3D inet_ehash_bucket(hashinfo, hash);
> +       lock =3D inet_ehash_lockp(hashinfo, hash);
> +
> +       spin_lock(lock);
> +       sk_nulls_for_each(sk, node, &head->chain) {
> +               if (sk->sk_hash !=3D hash)
> +                       continue;
> +
> +               if (unlikely(!inet_match(net, sk, acookie, ports, dif, sd=
if)))
> +                       continue;
> +
> +               sock_hold(sk);
> +               spin_unlock(lock);
> +               return sk;
> +       }
> +       spin_unlock(lock);

Here we need to keep the lock held, and release it later.

> +
> +       return NULL;
> +}
> +EXPORT_SYMBOL_GPL(__inet_lookup_established_lock);
> +
>  /* called with local bh disabled */
>  static int __inet_check_established(struct inet_timewait_death_row *deat=
h_row,
>                                     struct sock *sk, __u16 lport,
> diff --git a/net/ipv6/inet6_hashtables.c b/net/ipv6/inet6_hashtables.c
> index b64b49012655..1b2c971859c0 100644
> --- a/net/ipv6/inet6_hashtables.c
> +++ b/net/ipv6/inet6_hashtables.c
> @@ -89,6 +89,40 @@ struct sock *__inet6_lookup_established(struct net *ne=
t,
>  }
>  EXPORT_SYMBOL(__inet6_lookup_established);
>
> +struct sock *__inet6_lookup_established_lock(struct net *net, struct ine=
t_hashinfo *hashinfo,
> +                                            const struct in6_addr *saddr=
, const __be16 sport,
> +                                            const struct in6_addr *daddr=
, const u16 hnum,
> +                                            const int dif, const int sdi=
f)
> +{
> +       const __portpair ports =3D INET_COMBINED_PORTS(sport, hnum);
> +       const struct hlist_nulls_node *node;
> +       struct inet_ehash_bucket *head;
> +       unsigned int hash;
> +       spinlock_t *lock;
> +       struct sock *sk;
> +
> +       hash =3D inet6_ehashfn(net, daddr, hnum, saddr, sport);
> +       head =3D inet_ehash_bucket(hashinfo, hash);
> +       lock =3D inet_ehash_lockp(hashinfo, hash);
> +
> +       spin_lock(lock);
> +       sk_nulls_for_each(sk, node, &head->chain) {
> +               if (sk->sk_hash !=3D hash)
> +                       continue;
> +
> +               if (unlikely(!inet6_match(net, sk, saddr, daddr, ports, d=
if, sdif)))
> +                       continue;
> +
> +               sock_hold(sk);
> +               spin_unlock(lock);
> +               return sk;
> +       }
> +       spin_unlock(lock);

/* Same here. */

> +
> +       return NULL;
> +}
> +EXPORT_SYMBOL(__inet6_lookup_established_lock);
> +
>  static inline int compute_score(struct sock *sk, struct net *net,
>                                 const unsigned short hnum,
>                                 const struct in6_addr *daddr,
> ---8<---

