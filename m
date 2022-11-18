Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05AEF62EA9E
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 01:56:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240769AbiKRA4O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 19:56:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233894AbiKRA4N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 19:56:13 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4C6F85EE5;
        Thu, 17 Nov 2022 16:56:11 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id n12so9305675eja.11;
        Thu, 17 Nov 2022 16:56:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=C9Cp/pdx1mSwIwBR/zDeu0tKQUbnxAQr0nZWkEreeLg=;
        b=LQY+9FOK4g90KK8JN2inWsSv5DLytzKK0s9yoCDLU9c8yOyq4qcf4egDVg9xuCkcMm
         HHS7Bk54O0bbODj/qmNxoroKCnnvgPtZUHgnRLYzZYZLu3uPpRWJA2u1HdCK4xXQCk5U
         YsiduLBWP87VhWqlb6w2Dif6gZoag/Ne6ddDWtsTIz+pjkYaCCUt3Uz11F68R5m9WI03
         PCEvEjP/t2+kmc6h2bPcJLhiI+1X4qFXPiQ71sXeQV6g6vOHClLfPlhUU+lRA4W8lOeg
         Whc9sO2qIflare1/7Kd0p/abIroG23NCglf+5px+q0XOmOcKW5EWnJwUE7RkV4l7joEP
         1Sew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C9Cp/pdx1mSwIwBR/zDeu0tKQUbnxAQr0nZWkEreeLg=;
        b=3mtkuNJXbH7F/UTS7ZpXZEq7vHq2atTdB6avc+vMnaO9vf6pfmnNwN4SxbAzYiHzfq
         BPxh/ph5S8za+SYGsr8xCVdQPwQIOAwf9wfLZZhZ4wHkywiuPQST4IMcbb8t21gap8+9
         doVmQmkisEajqKbcce7UB+CoMxOpyBarBQVFjy65euWmwT11HJxrvwgo/LGOP9k72yVA
         PuDidDV7S018Nj47wTrnxdi6v2rllQCCLbYZX4RxWIjUogGGTiidEBT2zvJTpjtii5ic
         6JRpErZYbxTBCytM5MDJO3uIdI2MCNE1qwpNgcBAJFRgoZsiVZIIxW4vJTDQiP0ACp6I
         jAhA==
X-Gm-Message-State: ANoB5pmK/JXSRbJp1JJ8x1Aupjr2TvcBTwPRDLWALJ9zWPNjUu7SjqGc
        ++w4yKmcdkvoVJuOhZi6hAMDGYEbkY8nEfxXb3M=
X-Google-Smtp-Source: AA0mqf7IpclMXQ4T47NdHLzh7PocC2UcxvS/p6KZNsX3PWwnoj2jH0Oo/XzGe31EpbIJLY4sVU9gIqPfyl8ttpYVNSY=
X-Received: by 2002:a17:906:b14b:b0:78d:cede:91f4 with SMTP id
 bt11-20020a170906b14b00b0078dcede91f4mr4038058ejb.764.1668732970265; Thu, 17
 Nov 2022 16:56:10 -0800 (PST)
MIME-Version: 1.0
References: <CAJnrk1Y=qBAYsJJRgL1_Vx8Cb+tvS9PKEiFpYXPmc1b3tFL2nQ@mail.gmail.com>
 <20221118000601.47966-1-kuniyu@amazon.com>
In-Reply-To: <20221118000601.47966-1-kuniyu@amazon.com>
From:   Joanne Koong <joannelkoong@gmail.com>
Date:   Thu, 17 Nov 2022 16:55:59 -0800
Message-ID: <CAJnrk1YJiFpj9RsQ8Wz0V-7nQA8c8gBm=5Y1GhNp+oc15u-bnQ@mail.gmail.com>
Subject: Re: [PATCH v2 net 3/4] dccp/tcp: Don't update saddr before unlinking
 sk from the old bucket
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     acme@mandriva.com, davem@davemloft.net, dccp@vger.kernel.org,
        dsahern@kernel.org, edumazet@google.com, kuba@kernel.org,
        kuni1840@gmail.com, martin.lau@kernel.org,
        mathew.j.martineau@linux.intel.com, netdev@vger.kernel.org,
        pabeni@redhat.com, pengfei.xu@intel.com,
        stephen@networkplumber.org, william.xuanziyang@huawei.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 17, 2022 at 4:06 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
>
> From:   Joanne Koong <joannelkoong@gmail.com>
> Date:   Thu, 17 Nov 2022 13:32:18 -0800
> > On Wed, Nov 16, 2022 at 2:29 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> > >
> > > Currently, we update saddr before calling inet_bhash2_update_saddr(), so
> > > another thread iterating over the bhash2 bucket might see an inconsistent
>
> Sorry this should be just bhash       ^^^ here.
>
> > > address.
> > >
> > > Let's update saddr after unlinking sk from the old bhash2 bucket.
> >
> > I'm not sure whether this patch is necessary and I'm curious to hear
> > your thoughts. There's no adverse effect that comes from updating the
> > sk's saddr before calling inet_bhash2_update_saddr() in the current
> > code. Another thread can be iterating over the bhash2 bucket, but it
> > has no effect whether they see this new address or not (eg when they
> > are iterating through the bucket they are trying to check for bind
> > conflicts on another socket, and the sk having the new address doesn't
> > affect this). What are your thoughts?
>
> You are right, it seems I was confused.
>
> I was thinking that lockless change of saddr could result in data race;
> another process iterating over bhash might see a corrupted address.
>
> So, we need to acquire the bhash lock before updating saddr, and then
> related code should be in inet_bhash2_update_saddr().
>
> But I seem to have forgot to add the lock part... :p

No worries! :) Is acquiring the bhash lock necessary before updating
saddr? I think the worst case scenario (which would only happen very
rarely) is that there is another process iterating over bhash, that
process tries to access the address the exact time the address is
being updated in this function, causing the other process to see the
corrupted address, that corrupted address matches that other process's
socket address, thus causing that other process to reject the bind
request.

It doesn't seem like that is a big deal, in the rare event where that
would happen. In my opinion, it's not worth solving for by making the
common case slower by grabbing the bhash lock.

What are your thoughts?

>
>
> > > Fixes: 28044fc1d495 ("net: Add a bhash2 table hashed by port and address")
> > > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> > > ---
> > >  include/net/inet_hashtables.h |  2 +-
> > >  net/dccp/ipv4.c               | 22 ++++------------------
> > >  net/dccp/ipv6.c               | 23 ++++-------------------
> > >  net/ipv4/af_inet.c            | 11 +----------
> > >  net/ipv4/inet_hashtables.c    | 31 ++++++++++++++++++++++++++++---
> > >  net/ipv4/tcp_ipv4.c           | 20 ++++----------------
> > >  net/ipv6/tcp_ipv6.c           | 19 +++----------------
> > >  7 files changed, 45 insertions(+), 83 deletions(-)
> > >
> > > diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.h
> > > index 3af1e927247d..ba06e8b52264 100644
> > > --- a/include/net/inet_hashtables.h
> > > +++ b/include/net/inet_hashtables.h
> > > @@ -281,7 +281,7 @@ inet_bhash2_addr_any_hashbucket(const struct sock *sk, const struct net *net, in
> > >   * sk_v6_rcv_saddr (ipv6) changes after it has been binded. The socket's
> > >   * rcv_saddr field should already have been updated when this is called.
> > >   */
> > > -int inet_bhash2_update_saddr(struct inet_bind_hashbucket *prev_saddr, struct sock *sk);
> > > +int inet_bhash2_update_saddr(struct sock *sk, void *saddr, int family);
> > >
> > >  void inet_bind_hash(struct sock *sk, struct inet_bind_bucket *tb,
> > >                     struct inet_bind2_bucket *tb2, unsigned short port);
> > > diff --git a/net/dccp/ipv4.c b/net/dccp/ipv4.c
> > > index 40640c26680e..95e376e3b911 100644
> > > --- a/net/dccp/ipv4.c
> > > +++ b/net/dccp/ipv4.c
> > > @@ -45,11 +45,10 @@ static unsigned int dccp_v4_pernet_id __read_mostly;
> > >  int dccp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
> > >  {
> > >         const struct sockaddr_in *usin = (struct sockaddr_in *)uaddr;
> > > -       struct inet_bind_hashbucket *prev_addr_hashbucket = NULL;
> > > -       __be32 daddr, nexthop, prev_sk_rcv_saddr;
> > >         struct inet_sock *inet = inet_sk(sk);
> > >         struct dccp_sock *dp = dccp_sk(sk);
> > >         __be16 orig_sport, orig_dport;
> > > +       __be32 daddr, nexthop;
> > >         struct flowi4 *fl4;
> > >         struct rtable *rt;
> > >         int err;
> > > @@ -91,26 +90,13 @@ int dccp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
> > >                 daddr = fl4->daddr;
> > >
> > >         if (inet->inet_saddr == 0) {
> > > -               if (inet_csk(sk)->icsk_bind2_hash) {
> > > -                       prev_addr_hashbucket =
> > > -                               inet_bhashfn_portaddr(&dccp_hashinfo, sk,
> > > -                                                     sock_net(sk),
> > > -                                                     inet->inet_num);
> > > -                       prev_sk_rcv_saddr = sk->sk_rcv_saddr;
> > > -               }
> > > -               inet->inet_saddr = fl4->saddr;
> > > -       }
> > > -
> > > -       sk_rcv_saddr_set(sk, inet->inet_saddr);
> > > -
> > > -       if (prev_addr_hashbucket) {
> > > -               err = inet_bhash2_update_saddr(prev_addr_hashbucket, sk);
> > > +               err = inet_bhash2_update_saddr(sk,  &fl4->saddr, AF_INET);
> > >                 if (err) {
> > > -                       inet->inet_saddr = 0;
> > > -                       sk_rcv_saddr_set(sk, prev_sk_rcv_saddr);
> > >                         ip_rt_put(rt);
> > >                         return err;
> > >                 }
> > > +       } else {
> > > +               sk_rcv_saddr_set(sk, inet->inet_saddr);
> > >         }
> > >
> > >         inet->inet_dport = usin->sin_port;
> > > diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
> > > index 626166cb6d7e..94c101ed57a9 100644
> > > --- a/net/dccp/ipv6.c
> > > +++ b/net/dccp/ipv6.c
> > > @@ -934,26 +934,11 @@ static int dccp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
> > >         }
> > >
> > >         if (saddr == NULL) {
> > > -               struct inet_bind_hashbucket *prev_addr_hashbucket = NULL;
> > > -               struct in6_addr prev_v6_rcv_saddr;
> > > -
> > > -               if (icsk->icsk_bind2_hash) {
> > > -                       prev_addr_hashbucket = inet_bhashfn_portaddr(&dccp_hashinfo,
> > > -                                                                    sk, sock_net(sk),
> > > -                                                                    inet->inet_num);
> > > -                       prev_v6_rcv_saddr = sk->sk_v6_rcv_saddr;
> > > -               }
> > > -
> > >                 saddr = &fl6.saddr;
> > > -               sk->sk_v6_rcv_saddr = *saddr;
> > > -
> > > -               if (prev_addr_hashbucket) {
> > > -                       err = inet_bhash2_update_saddr(prev_addr_hashbucket, sk);
> > > -                       if (err) {
> > > -                               sk->sk_v6_rcv_saddr = prev_v6_rcv_saddr;
> > > -                               goto failure;
> > > -                       }
> > > -               }
> > > +
> > > +               err = inet_bhash2_update_saddr(sk, saddr, AF_INET6);
> > > +               if (err)
> > > +                       goto failure;
> > >         }
> > >
> > >         /* set the source address */
> > > diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
> > > index 4728087c42a5..0da679411330 100644
> > > --- a/net/ipv4/af_inet.c
> > > +++ b/net/ipv4/af_inet.c
> > > @@ -1230,7 +1230,6 @@ EXPORT_SYMBOL(inet_unregister_protosw);
> > >
> > >  static int inet_sk_reselect_saddr(struct sock *sk)
> > >  {
> > > -       struct inet_bind_hashbucket *prev_addr_hashbucket;
> > >         struct inet_sock *inet = inet_sk(sk);
> > >         __be32 old_saddr = inet->inet_saddr;
> > >         __be32 daddr = inet->inet_daddr;
> > > @@ -1260,16 +1259,8 @@ static int inet_sk_reselect_saddr(struct sock *sk)
> > >                 return 0;
> > >         }
> > >
> > > -       prev_addr_hashbucket =
> > > -               inet_bhashfn_portaddr(tcp_or_dccp_get_hashinfo(sk), sk,
> > > -                                     sock_net(sk), inet->inet_num);
> > > -
> > > -       inet->inet_saddr = inet->inet_rcv_saddr = new_saddr;
> > > -
> > > -       err = inet_bhash2_update_saddr(prev_addr_hashbucket, sk);
> > > +       err = inet_bhash2_update_saddr(sk, &new_saddr, AF_INET);
> > >         if (err) {
> > > -               inet->inet_saddr = old_saddr;
> > > -               inet->inet_rcv_saddr = old_saddr;
> > >                 ip_rt_put(rt);
> > >                 return err;
> > >         }
> > > diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
> > > index d745f962745e..dcb6bc918966 100644
> > > --- a/net/ipv4/inet_hashtables.c
> > > +++ b/net/ipv4/inet_hashtables.c
> > > @@ -858,7 +858,20 @@ inet_bhash2_addr_any_hashbucket(const struct sock *sk, const struct net *net, in
> > >         return &hinfo->bhash2[hash & (hinfo->bhash_size - 1)];
> > >  }
> > >
> > > -int inet_bhash2_update_saddr(struct inet_bind_hashbucket *prev_saddr, struct sock *sk)
> > > +static void inet_update_saddr(struct sock *sk, void *saddr, int family)
> > > +{
> > > +#if IS_ENABLED(CONFIG_IPV6)
> > > +       if (family == AF_INET6) {
> > > +               sk->sk_v6_rcv_saddr = *(struct in6_addr *)saddr;
> > > +       } else
> > > +#endif
> > > +       {
> > > +               inet_sk(sk)->inet_saddr = *(__be32 *)saddr;
> > > +               sk_rcv_saddr_set(sk, inet_sk(sk)->inet_saddr);
> > > +       }
> > > +}
> > > +
> > > +int inet_bhash2_update_saddr(struct sock *sk, void *saddr, int family)
> > >  {
> > >         struct inet_hashinfo *hinfo = tcp_or_dccp_get_hashinfo(sk);
> > >         struct inet_bind2_bucket *tb2, *new_tb2;
> > > @@ -867,6 +880,12 @@ int inet_bhash2_update_saddr(struct inet_bind_hashbucket *prev_saddr, struct soc
> > >         int port = inet_sk(sk)->inet_num;
> > >         struct net *net = sock_net(sk);
> > >
> > > +       if (!inet_csk(sk)->icsk_bind2_hash) {
> > > +               /* Not bind()ed before. */
> > > +               inet_update_saddr(sk, saddr, family);
> > > +               return 0;
> > > +       }
> > > +
> > >         /* Allocate a bind2 bucket ahead of time to avoid permanently putting
> > >          * the bhash2 table in an inconsistent state if a new tb2 bucket
> > >          * allocation fails.
> > > @@ -875,12 +894,18 @@ int inet_bhash2_update_saddr(struct inet_bind_hashbucket *prev_saddr, struct soc
> > >         if (!new_tb2)
> > >                 return -ENOMEM;
> > >
> > > +       /* Unlink first not to show the wrong address for other threads. */
> > >         head2 = inet_bhashfn_portaddr(hinfo, sk, net, port);
> > >
> > > -       spin_lock_bh(&prev_saddr->lock);
> > > +       spin_lock_bh(&head2->lock);
> > >         __sk_del_bind2_node(sk);
> > >         inet_bind2_bucket_destroy(hinfo->bind2_bucket_cachep, inet_csk(sk)->icsk_bind2_hash);
> > > -       spin_unlock_bh(&prev_saddr->lock);
> > > +       spin_unlock_bh(&head2->lock);
> > > +
> > > +       inet_update_saddr(sk, saddr, family);
> > > +
> > > +       /* Update bhash2 bucket. */
> > > +       head2 = inet_bhashfn_portaddr(hinfo, sk, net, port);
> > >
> > >         spin_lock_bh(&head2->lock);
> > >         tb2 = inet_bind2_bucket_find(head2, net, port, l3mdev, sk);
> > > diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> > > index 6a3a732b584d..23dd7e9df2d5 100644
> > > --- a/net/ipv4/tcp_ipv4.c
> > > +++ b/net/ipv4/tcp_ipv4.c
> > > @@ -199,15 +199,14 @@ static int tcp_v4_pre_connect(struct sock *sk, struct sockaddr *uaddr,
> > >  /* This will initiate an outgoing connection. */
> > >  int tcp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
> > >  {
> > > -       struct inet_bind_hashbucket *prev_addr_hashbucket = NULL;
> > >         struct sockaddr_in *usin = (struct sockaddr_in *)uaddr;
> > >         struct inet_timewait_death_row *tcp_death_row;
> > > -       __be32 daddr, nexthop, prev_sk_rcv_saddr;
> > >         struct inet_sock *inet = inet_sk(sk);
> > >         struct tcp_sock *tp = tcp_sk(sk);
> > >         struct ip_options_rcu *inet_opt;
> > >         struct net *net = sock_net(sk);
> > >         __be16 orig_sport, orig_dport;
> > > +       __be32 daddr, nexthop;
> > >         struct flowi4 *fl4;
> > >         struct rtable *rt;
> > >         int err;
> > > @@ -251,24 +250,13 @@ int tcp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
> > >         tcp_death_row = &sock_net(sk)->ipv4.tcp_death_row;
> > >
> > >         if (!inet->inet_saddr) {
> > > -               if (inet_csk(sk)->icsk_bind2_hash) {
> > > -                       prev_addr_hashbucket = inet_bhashfn_portaddr(tcp_death_row->hashinfo,
> > > -                                                                    sk, net, inet->inet_num);
> > > -                       prev_sk_rcv_saddr = sk->sk_rcv_saddr;
> > > -               }
> > > -               inet->inet_saddr = fl4->saddr;
> > > -       }
> > > -
> > > -       sk_rcv_saddr_set(sk, inet->inet_saddr);
> > > -
> > > -       if (prev_addr_hashbucket) {
> > > -               err = inet_bhash2_update_saddr(prev_addr_hashbucket, sk);
> > > +               err = inet_bhash2_update_saddr(sk,  &fl4->saddr, AF_INET);
> > >                 if (err) {
> > > -                       inet->inet_saddr = 0;
> > > -                       sk_rcv_saddr_set(sk, prev_sk_rcv_saddr);
> > >                         ip_rt_put(rt);
> > >                         return err;
> > >                 }
> > > +       } else {
> > > +               sk_rcv_saddr_set(sk, inet->inet_saddr);
> > >         }
> > >
> > >         if (tp->rx_opt.ts_recent_stamp && inet->inet_daddr != daddr) {
> > > diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
> > > index 81b396e5cf79..2f3ca3190d26 100644
> > > --- a/net/ipv6/tcp_ipv6.c
> > > +++ b/net/ipv6/tcp_ipv6.c
> > > @@ -292,24 +292,11 @@ static int tcp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
> > >         tcp_death_row = &sock_net(sk)->ipv4.tcp_death_row;
> > >
> > >         if (!saddr) {
> > > -               struct inet_bind_hashbucket *prev_addr_hashbucket = NULL;
> > > -               struct in6_addr prev_v6_rcv_saddr;
> > > -
> > > -               if (icsk->icsk_bind2_hash) {
> > > -                       prev_addr_hashbucket = inet_bhashfn_portaddr(tcp_death_row->hashinfo,
> > > -                                                                    sk, net, inet->inet_num);
> > > -                       prev_v6_rcv_saddr = sk->sk_v6_rcv_saddr;
> > > -               }
> > >                 saddr = &fl6.saddr;
> > > -               sk->sk_v6_rcv_saddr = *saddr;
> > >
> > > -               if (prev_addr_hashbucket) {
> > > -                       err = inet_bhash2_update_saddr(prev_addr_hashbucket, sk);
> > > -                       if (err) {
> > > -                               sk->sk_v6_rcv_saddr = prev_v6_rcv_saddr;
> > > -                               goto failure;
> > > -                       }
> > > -               }
> > > +               err = inet_bhash2_update_saddr(sk, saddr, AF_INET6);
> > > +               if (err)
> > > +                       goto failure;
> > >         }
> > >
> > >         /* set the source address */
> > > --
> > > 2.30.2
