Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B671D66AB67
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 13:48:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbjANMso (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Jan 2023 07:48:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230036AbjANMsj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Jan 2023 07:48:39 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D2D57A85;
        Sat, 14 Jan 2023 04:48:38 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id v30so34732556edb.9;
        Sat, 14 Jan 2023 04:48:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bDaCVJRDxYMu/uLKuoJDE+ALuUA2Ewpy3DdTf3U9GeE=;
        b=L+MxyU7qhNnVu1AJjVj+vcD7bXjlqmaciO5zrMR5ELRVhCF21IcZdyy45Y/PuXL23K
         +iXuIJaU5H/77foCI2cLz9jtJqeBELo8Mw/ME+tI1qpzdJ0WhE+0Pujh1ikEGKVS1uxO
         sUBkVWDuSAfCy3SuBs8TX4KRbgpWJlC4L+WLmpAPqJpghk0c5zwhnKByQhOqD/SplVaT
         P7ZonDaucJY1PyPgrlHJrK0gECiEy7SAs5wYF9dfIWjdL/bNvmh+zX0gRiJ1ijpacKkS
         9n01GsqW447w3lW2UnFBGR9VbwxhkJefv2ib7wb+W//uSFteukJEmbmKet0o49/lKXXz
         +6TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bDaCVJRDxYMu/uLKuoJDE+ALuUA2Ewpy3DdTf3U9GeE=;
        b=mN0p0fzzbPqLyZttsIf2JdbOH46s9WOyMFlVICUH7xM9Y2qCH6sbIynvWTtZvd+Fb0
         mgOAouG+cpHRUrhAzrpc2EY8MB7RsEaHFyj7lTocf+r57Roa0VxrrERmX0n0WRTUjHcl
         mmb8jlp36OjgieAcBpnUpTwqFBBAEk1wLzHnpPJAn1tRjkdngdiH8cxqpeMJxXbzJVni
         lmMlt40v2DOe60CD0Xm2P+xsqol0FEEZ/WsuAMRzWv0aNn5Jel/CDGZQ33KxGrGWD/pR
         GTh/E+e1ILVo8zMGf9T2UWHTt1xORuu5uGFGDF6QxYWmY1/A8bf4QhhxyfQs6vnzDllE
         ZajA==
X-Gm-Message-State: AFqh2kraO43xpMoSXAJUGgKjvYqypCiMumhkyhlzq+Pqywxxj+7giBKb
        ficjfRoEcJew9U3V77Fo5uBWVm+1IptKdArIhF0=
X-Google-Smtp-Source: AMrXdXvS6F8M/A+fVgoB53NGYAjx+NHKYQrAKxceywI6uCxTfbX4zaBvyyTSIQZ5lQvaM40kub2Cye93huhBnY7WT7g=
X-Received: by 2002:a50:ff14:0:b0:49b:58ca:ebb7 with SMTP id
 a20-20020a50ff14000000b0049b58caebb7mr1085454edu.130.1673700516844; Sat, 14
 Jan 2023 04:48:36 -0800 (PST)
MIME-Version: 1.0
References: <20230112065336.41034-1-kerneljasonxing@gmail.com>
 <CANn89iKQjN1YiHqBTV3+zDYo0G11p-6=p7C-1GvFCp8Y=r4nvQ@mail.gmail.com>
 <CAL+tcoACCg+UQG+PAGh1k+-mTJdZ-5jNez5hSGO_i2oWjr7=+w@mail.gmail.com> <CANn89iKR6XoB6tfJ2wLK1LqkNE1FboFO-PeOpuLNM1_5KOM53Q@mail.gmail.com>
In-Reply-To: <CANn89iKR6XoB6tfJ2wLK1LqkNE1FboFO-PeOpuLNM1_5KOM53Q@mail.gmail.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Sat, 14 Jan 2023 20:48:00 +0800
Message-ID: <CAL+tcoDxe3-Cjd+yMc1cnYHoErH-QkDB5VVKZSCObqt64ovLdw@mail.gmail.com>
Subject: Re: [PATCH net] tcp: avoid the lookup process failing to get sk in
 ehash table
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Xing <kernelxing@tencent.com>,
        kuba@kernel.org
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

On Sat, Jan 14, 2023 at 8:31 PM Eric Dumazet <edumazet@google.com> wrote:
>
> ()
>
> On Sat, Jan 14, 2023 at 1:06 PM Jason Xing <kerneljasonxing@gmail.com> wrote:
> >
> > On Sat, Jan 14, 2023 at 5:45 PM Eric Dumazet <edumazet@google.com> wrote:
> > >
> > > On Thu, Jan 12, 2023 at 7:54 AM Jason Xing <kerneljasonxing@gmail.com> wrote:
> > > >
> > > > From: Jason Xing <kernelxing@tencent.com>
> > > >
> > > > While one cpu is working on looking up the right socket from ehash
> > > > table, another cpu is done deleting the request socket and is about
> > > > to add (or is adding) the big socket from the table. It means that
> > > > we could miss both of them, even though it has little chance.
> > > >
> > > > Let me draw a call trace map of the server side.
> > > >    CPU 0                           CPU 1
> > > >    -----                           -----
> > > > tcp_v4_rcv()                  syn_recv_sock()
> > > >                             inet_ehash_insert()
> > > >                             -> sk_nulls_del_node_init_rcu(osk)
> > > > __inet_lookup_established()
> > > >                             -> __sk_nulls_add_node_rcu(sk, list)
> > > >
> > > > Notice that the CPU 0 is receiving the data after the final ack
> > > > during 3-way shakehands and CPU 1 is still handling the final ack.
> > > >
> > > > Why could this be a real problem?
> > > > This case is happening only when the final ack and the first data
> > > > receiving by different CPUs. Then the server receiving data with
> > > > ACK flag tries to search one proper established socket from ehash
> > > > table, but apparently it fails as my map shows above. After that,
> > > > the server fetches a listener socket and then sends a RST because
> > > > it finds a ACK flag in the skb (data), which obeys RST definition
> > > > in RFC 793.
> > > >
> > > > Many thanks to Eric for great help from beginning to end.
> > > >
> > > > Fixes: 5e0724d027f0 ("tcp/dccp: fix hashdance race for passive sessions")
> > > > Signed-off-by: Jason Xing <kernelxing@tencent.com>
> > > > ---
> > > >  net/ipv4/inet_hashtables.c | 10 ++++++++++
> > > >  1 file changed, 10 insertions(+)
> > > >
> > > > diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
> > > > index 24a38b56fab9..18f88cb4efcb 100644
> > > > --- a/net/ipv4/inet_hashtables.c
> > > > +++ b/net/ipv4/inet_hashtables.c
> > > > @@ -650,7 +650,16 @@ bool inet_ehash_insert(struct sock *sk, struct sock *osk, bool *found_dup_sk)
> > > >         spin_lock(lock);
> > > >         if (osk) {
> > > >                 WARN_ON_ONCE(sk->sk_hash != osk->sk_hash);
> > > > +               if (sk_hashed(osk))
> > > > +                       /* Before deleting the node, we insert a new one to make
> > > > +                        * sure that the look-up=sk process would not miss either
> > > > +                        * of them and that at least one node would exist in ehash
> > > > +                        * table all the time. Otherwise there's a tiny chance
> > > > +                        * that lookup process could find nothing in ehash table.
> > > > +                        */
> > > > +                       __sk_nulls_add_node_rcu(sk, list);
> > >
> > > In our private email exchange, I suggested to insert sk at the _tail_
> > > of the hash bucket.
> > >
> >
> > Yes, I noticed that. At that time I kept considering the race
> > condition of the RCU itself, not the scene you mentioned as below.
> >
> > > Inserting it at the _head_ would still leave a race condition, because
> > > a concurrent reader might
> > > have already started the bucket traversal, and would not see 'sk'.
> >
> > Thanks for the detailed explanation. Now I see why. I'll replace it
> > with __sk_nulls_add_node_tail_rcu() function and send the v2 patch.
> >
> > By the way, I checked the removal of TIMEWAIT socket which is included
> > in this patch.
> > I write down the call-trace:
> > inet_hash_connect()
> >     -> __inet_hash_connect()
> >         -> if (sk_unhashed(sk)) {
> >                 inet_ehash_nolisten(sk, (struct sock *)tw, NULL);
> >                     -> inet_ehash_insert(sk, osk, found_dup_sk);
> > Therefore, this patch covers the timewait case.
>
> This is the path handling the TIME_WAIT ---> ESTABLISH case.
>
> I was referring to the more common opposite case which is the case
> where a race could possibly happen.
>
> This is inet_twsk_hashdance, and I suspect we want something like:
>

Thanks, Eric. I learned :)

> diff --git a/net/ipv4/inet_timewait_sock.c b/net/ipv4/inet_timewait_sock.c
> index 1d77d992e6e77f7d96bd061be6dbb802c2566b3f..6d681ef52bb24b984a9dbda25b19291fc4393914
> 100644
> --- a/net/ipv4/inet_timewait_sock.c
> +++ b/net/ipv4/inet_timewait_sock.c
> @@ -91,10 +91,10 @@ void inet_twsk_put(struct inet_timewait_sock *tw)
>  }
>  EXPORT_SYMBOL_GPL(inet_twsk_put);
>
> -static void inet_twsk_add_node_rcu(struct inet_timewait_sock *tw,
> +static void inet_twsk_add_node_tail_rcu(struct inet_timewait_sock *tw,
>                                    struct hlist_nulls_head *list)
>  {
> -       hlist_nulls_add_head_rcu(&tw->tw_node, list);
> +       hlist_nulls_add_tail_rcu(&tw->tw_node, list);
>  }
>
>  static void inet_twsk_add_bind_node(struct inet_timewait_sock *tw,
> @@ -147,7 +147,7 @@ void inet_twsk_hashdance(struct inet_timewait_sock
> *tw, struct sock *sk,
>
>         spin_lock(lock);
>
> -       inet_twsk_add_node_rcu(tw, &ehead->chain);
> +       inet_twsk_add_node_tail_rcu(tw, &ehead->chain);
>
>         /* Step 3: Remove SK from hash chain */
>         if (__sk_nulls_del_node_init_rcu(sk))

I'll put this part of the code into my next submission and add more
comments about it.

Thanks,
Jason
