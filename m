Return-Path: <netdev+bounces-9141-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CFAC72774F
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 08:35:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D754F281629
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 06:35:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14539EA3;
	Thu,  8 Jun 2023 06:35:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0188628
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 06:35:36 +0000 (UTC)
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A07A26B3
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 23:35:34 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id 5b1f17b1804b1-3f7024e66adso27815e9.1
        for <netdev@vger.kernel.org>; Wed, 07 Jun 2023 23:35:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686206132; x=1688798132;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m9Vl4ABRewq295PiB1q/uGKAE9GH3l1uZl5KsGwaN50=;
        b=Ty0KWHdNznpyoeR71XQYWOy7u9k2yDrm42I9jRgpE9xz4g3X3aCHGXA2HapJ9XuRY8
         qY3FHmjV8PCj/BxKVf6q9eF3U17uj5/oCYLdYwwXDFW0uc0z4427tdrSQXEsomInYag/
         r9K7ivZb5R7lYCDlL0urPyhKGXQ3BeBk8xhGa1AVgt5LXKC+4nSfwBmNIDQNLGSAuHB4
         SmhGQHcH2JOZ9mV0II/HZDsqrtnksHJQDBOSSJf2Gl8g/bZm2kLzp6YwXAufRbNeLkpn
         A9myQj/gz636GyuVJxmBNEjqmjj00a9ZUJW4CK/tJTJIracLeCwHI48RsJlYVB+I4uat
         qCyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686206132; x=1688798132;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m9Vl4ABRewq295PiB1q/uGKAE9GH3l1uZl5KsGwaN50=;
        b=RJ0932eZD5dESLsX/ro8PmmmDtvtpZrhYdHPLeXGl4nslUgSNDv8FbfN5WE+r7roIz
         iZFu5PxSapmbq1k4LWZsfelt+YtwEtwoyYaZ3GGGXtKf7q6z91Yy3PpH/U3xcbW+ZGPe
         Y0A6cFPtj+LO8tzBdNZmTsk9PLpdP6nOE9poRt7h04WdeXuXGHbv5VS5oFecpXTy0a+G
         Oqr+l7AkW7gL37fV1gfHrJATGH7ekntxylBo0W14j/xFoa2jEz6yZNGxbADgN/hXA9ZM
         VnZLNoeSPBac7vbyLKudFfUcIqEi6nkkBTlpgKe1vo2njWnA5NUpel7N1ofK/hZerYb5
         opVg==
X-Gm-Message-State: AC+VfDzNE4mLDoL0w+ihLV8PkMIh2wxJK38KLxMIDqnUBZrsR2CrNzDC
	6bDR+nZIbpXvsfvbuBTXCthHQXC8cD0aOm7lPhMy8A==
X-Google-Smtp-Source: ACHHUZ4MCw0ilBh9dCkko9CoioJS8+sP6ZHvbun8UUaAkEBSI1PWxnMEV4smoz9sV3XwLyaEYyW5eyQ6YMogvuLc1zI=
X-Received: by 2002:a05:600c:1c28:b0:3f7:32d4:60d0 with SMTP id
 j40-20020a05600c1c2800b003f732d460d0mr112191wms.4.1686206132138; Wed, 07 Jun
 2023 23:35:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CANn89iLm=UeSLBVjACnqyaLo7oMTrY7Ok8RXP9oGDHVwe8LVng@mail.gmail.com>
 <20230608054740.11256-1-kuniyu@amazon.com>
In-Reply-To: <20230608054740.11256-1-kuniyu@amazon.com>
From: Eric Dumazet <edumazet@google.com>
Date: Thu, 8 Jun 2023 08:35:20 +0200
Message-ID: <CANn89iK8snOz8TYOhhwfimC7ykYA78GA3Nyv8x06SZYa1nKdyA@mail.gmail.com>
Subject: Re: [PATCH v2] tcp: fix connection reset due to tw hashdance race.
To: Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: davem@davemloft.net, dsahern@kernel.org, duanmuquan@baidu.com, 
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

On Thu, Jun 8, 2023 at 7:48=E2=80=AFAM Kuniyuki Iwashima <kuniyu@amazon.com=
> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
> Date: Wed, 7 Jun 2023 15:32:57 +0200
> > On Wed, Jun 7, 2023 at 1:59=E2=80=AFPM Duan,Muquan <duanmuquan@baidu.co=
m> wrote:
> > >
> > > Hi, Eric,
> > >
> > >  Thanks for your comments!
> > >
> > >  About the second lookup, I am sorry that I did not give enough expla=
nations about it. Here are some details:
> > >
> > >  1.  The second lookup can find the tw sock and avoid the connection =
refuse error on userland applications:
> > >
> > > If the original sock is found, but when validating its refcnt, it has=
 been destroyed and sk_refcnt has become 0 after decreased by tcp_time_wait=
()->tcp_done()->inet_csk_destory_sock()->sock_put().The validation for refc=
nt fails and the lookup process gets a listener sock.
> > >
> > > When this case occurs, the hashdance has definitely finished=EF=BC=8C=
because tcp_done() is executed after inet_twsk_hashdance(). Then if look up=
 the ehash table again, hashdance has already finished, tw sock will be fou=
nd.
> > >
> > >  With this fix, logically we can solve the connection reset issue com=
pletely when no established sock is found due to hashdance race.In my repro=
ducing environment, the connection refuse error will occur about every 6 ho=
urs with only the fix of bad case (2). But with both of the 2 fixes, I test=
ed it many times, the longest test continues for 10 days, it does not occur=
 again,
> > >
> > >
> > >
> > > 2. About the performance impact:
> > >
> > >      A similar scenario is that __inet_lookup_established() will do i=
net_match() check for the second time, if fails it will look up    the list=
 again. It is the extra effort to reduce the race impact without using read=
er lock. inet_match() failure occurs with about the same probability with r=
efcnt validation failure in my test environment.
> > >
> > >  The second lookup will only be done in the condition that FIN segmen=
t gets a listener sock.
> > >
> > >   About the performance impact:
> > >
> > > 1)  Most of the time, this condition will not met, the added codes in=
troduces at most 3 comparisons for each segment.
> > >
> > > The second inet_match() in __inet_lookup_established()  does least 3 =
comparisons for each segmet.
> > >
> > >
> > > 2)  When this condition is met, the probability is very small. The im=
pact is similar to the second try due to inet_match() failure. Since tw soc=
k can definitely be found in the second try, I think this cost is worthy to=
 avoid connection reused error on userland applications.
> > >
> > >
> > >
> > > My understanding is, current philosophy is avoiding the reader lock b=
y tolerating the minor defect which occurs in a small probability.For examp=
le, if the FIN from passive closer is dropped due to the found sock is dest=
royed, a retransmission can be tolerated, it only makes the connection term=
ination slower. But I think the bottom line is that it does not affect the =
userland applications=E2=80=99 functionality. If application fails to conne=
ct due to the hashdance race, it can=E2=80=99t be tolerated. In fact, guys =
from product department push hard on the connection refuse error.
> > >
> > >
> > > About bad case (2):
> > >
> > >  tw sock is found, but its tw_refcnt has not been set to 3, it is sti=
ll 0, validating for sk_refcnt will fail.
> > >
> > > I do not know the reason why setting tw_refcnt after adding it into l=
ist, could anyone help point out the reason? It adds  extra race because th=
e new added tw sock may be found and checked in other CPU concurrently befo=
re =C6=92setting tw_refcnt to 3.
> > >
> > > By setting tw_refcnt to 3 before adding it into list, this case will =
be solved, and almost no cost. In my reproducing environment, it occurs mor=
e frequently than bad case (1), it appears about every 20 minutes, bad case=
 (1) appears about every 6 hours.
> > >
> > >
> > >
> > > About the bucket spinlock, the original established sock and tw sock =
are stored in the ehash table, I concern about the performance when there a=
re lots of short TCP connections, the reader lock may affect the performanc=
e of connection creation and termination. Could you share some details of y=
our idea? Thanks in advance.
> > >
> > >
> >
> > Again, you can write a lot of stuff, the fact is that your patch does
> > not solve the issue.
> >
> > You could add 10 lookups, and still miss some cases, because they are
> > all RCU lookups with no barriers.
> >
> > In order to solve the issue of packets for the same 4-tuple being
> > processed by many cpus, the only way to solve races is to add mutual
> > exclusion.
> >
> > Note that we already have to lock the bucket spinlock every time we
> > transition a request socket to socket, a socket to timewait, or any
> > insert/delete.
> >
> > We need to expand the scope of this lock, and cleanup things that we
> > added in the past, because we tried too hard to 'detect races'
>
> How about this ?  This is still a workaround though, retry sounds
> better than expanding the scope of the lock given the race is rare.

The chance of two cpus having to hold the same spinlock is rather small.

Algo is the following:

Attempt a lockless/RCU lookup.

1) Socket is found, we are good to go. Fast path is still fast.

2) Socket  is not found in ehash
   - We lock the bucket spinlock.
   - We retry the lookup
   - If socket found, continue with it (release the spinlock when
appropriate, after all write manipulations in the bucket are done)
   - If socket still not found, we lookup a listener.
      We insert a TCP_NEW_SYN_RECV ....
       Again, we release the spinlock when appropriate, after all
write manipulations in the bucket are done)

No more races, and the fast path is the same.




>
> ---8<---
> diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
> index e7391bf310a7..b034be2f37c8 100644
> --- a/net/ipv4/inet_hashtables.c
> +++ b/net/ipv4/inet_hashtables.c
> @@ -484,14 +484,24 @@ struct sock *__inet_lookup_established(struct net *=
net,
>         unsigned int hash =3D inet_ehashfn(net, daddr, hnum, saddr, sport=
);
>         unsigned int slot =3D hash & hashinfo->ehash_mask;
>         struct inet_ehash_bucket *head =3D &hashinfo->ehash[slot];
> +       bool should_retry =3D true;
>
>  begin:
>         sk_nulls_for_each_rcu(sk, node, &head->chain) {
>                 if (sk->sk_hash !=3D hash)
>                         continue;
>                 if (likely(inet_match(net, sk, acookie, ports, dif, sdif)=
)) {
> -                       if (unlikely(!refcount_inc_not_zero(&sk->sk_refcn=
t)))
> +                       if (unlikely(!refcount_inc_not_zero(&sk->sk_refcn=
t))) {

Because of SLAB_TYPESAFE_BY_RCU, we can not really do this kind of stuff.

Really this RCU lookup should be a best effort, not something
potentially looping X times .

We only need a proper fallback to spinlock protected lookup.

> +                               if (sk->sk_state =3D=3D TCP_TIME_WAIT)
> +                                       goto begin;
> +
> +                               if (sk->sk_state =3D=3D TCP_CLOSE && shou=
ld_retry) {
> +                                       should_retry =3D false;
> +                                       goto begin;
> +                               }
> +
>                                 goto out;
> +                       }
>                         if (unlikely(!inet_match(net, sk, acookie,
>                                                  ports, dif, sdif))) {
>                                 sock_gen_put(sk);
> ---8<---
>
>
> >

