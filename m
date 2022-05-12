Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 563B45241D9
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 03:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349801AbiELBJY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 21:09:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349802AbiELBJX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 21:09:23 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D27653E08
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 18:09:21 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id j2so7202319ybu.0
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 18:09:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6sLq+8SIqqfU1WzreqY17l157NABkTzmR/wywPXgxlI=;
        b=Rb4WJWgfP6Id3CBuULkrLRDNwIURTYRc09M8tB9atZ//ICL0Lq9s668bTH6xcUHRdF
         PRiUSUWCjjxImXFG6aIhmMASio/ES+FoaDif85qO8ryvaVKHubKegwEmRjXaGMCE1gzc
         WaHC7LZApLYBe/1Lkyp/aXn+OZP9TAI2uBRpqkv42hvO22jDYtm93dzw+K75fcBgeAQQ
         wAJfPGbrPM0xR87QH7QSPFl/KLiHsACO4HfPQaFXk2+GMwbSMIhSXdCOKkr4B/h/LAZG
         g0E/8V6X+a4JJLmkRmYBx5zyi6xw/T6Fo+LW/+sLdq97K+O9XoD4jQtdNEpcJtiMUpyS
         UAzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6sLq+8SIqqfU1WzreqY17l157NABkTzmR/wywPXgxlI=;
        b=x2UjLRY0olX9wlN9Y0sJp0dNajuaW3clawwd61Cprd5C/KJgu6vc8RDE0OKkUdl+5A
         DwMMop55JjGkifVevBblD0R8fx0C+u4lAOEVH+hsIrbBMQBWdiKHxrgddPHoA2pVG+im
         D2czrDufT0MjTeIgIZz8oAKwaZ6DQUqo+I1/qi9jND7ovWp8ZKOrjdnErqmh/8jvg40r
         qMK/jhfavrB0EkY+cVqcEd516uGpaTchqUinOhH+uD0TV7iM/XPFLv3tAuBcaucNzt6Y
         TCDMTZvBscgvbhwcu0AO88+wIlXnA+88A6YSJXUMlNxIxR9iAoAEKqVNnS5K1Sd7FUT1
         2gjQ==
X-Gm-Message-State: AOAM5331uPRC7NS+77UCL5lXoXU/FkeY5eSKqknzGqxYD9J/E7uqsNjT
        F2sBLEFh/5G5y6ObES9Mv36Nc4w8kzbpybV46dntR5jV
X-Google-Smtp-Source: ABdhPJy5/LKin2bm5kb5j4u4SiSLp+lv12Hb9LGweBTM7cQmGbmsm1wCdeEDYjlaKU4mrSlJgGhWmGKzccKM7tubSbk=
X-Received: by 2002:a5b:64b:0:b0:64b:52b:6ffd with SMTP id o11-20020a5b064b000000b0064b052b6ffdmr12128539ybq.340.1652317760314;
 Wed, 11 May 2022 18:09:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220511000424.2223932-1-joannelkoong@gmail.com>
 <20220511000424.2223932-2-joannelkoong@gmail.com> <CANn89i+nAZAYB+VcrO3fAW9F7RmbFcKzmFUr=-dSvL-v61DJEQ@mail.gmail.com>
In-Reply-To: <CANn89i+nAZAYB+VcrO3fAW9F7RmbFcKzmFUr=-dSvL-v61DJEQ@mail.gmail.com>
From:   Joanne Koong <joannelkoong@gmail.com>
Date:   Wed, 11 May 2022 18:09:09 -0700
Message-ID: <CAJnrk1Z+33HXn+5UGF-3146QfUGnLjNxmU60QbCsm=yYtitRZA@mail.gmail.com>
Subject: Re: [PATCH net-next v3 1/2] net: Add a second bind table hashed by
 port and address
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev <netdev@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 10, 2022 at 7:05 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Tue, May 10, 2022 at 5:05 PM Joanne Koong <joannelkoong@gmail.com> wrote:
> >
> > We currently have one tcp bind table (bhash) which hashes by port
> > number only. In the socket bind path, we check for bind conflicts by
> > traversing the specified port's inet_bind2_bucket while holding the
> > bucket's spinlock (see inet_csk_get_port() and inet_csk_bind_conflict()).
> >
> > In instances where there are tons of sockets hashed to the same port
> > at different addresses, checking for a bind conflict is time-intensive
> > and can cause softirq cpu lockups, as well as stops new tcp connections
> > since __inet_inherit_port() also contests for the spinlock.
> >
> > This patch proposes adding a second bind table, bhash2, that hashes by
> > port and ip address. Searching the bhash2 table leads to significantly
> > faster conflict resolution and less time holding the spinlock.
> >
> > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > ---
> >  include/net/inet_connection_sock.h |   3 +
> >  include/net/inet_hashtables.h      |  56 ++++++-
> >  include/net/sock.h                 |  14 ++
> >  net/dccp/proto.c                   |  34 ++++-
> >  net/ipv4/inet_connection_sock.c    | 227 +++++++++++++++++++++--------
> >  net/ipv4/inet_hashtables.c         | 188 ++++++++++++++++++++++--
> >  net/ipv4/tcp.c                     |  14 +-
> >  7 files changed, 454 insertions(+), 82 deletions(-)
> >
> > diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
> > index 3908296d103f..d89a78d10294 100644
> > --- a/include/net/inet_connection_sock.h
> > +++ b/include/net/inet_connection_sock.h
> > @@ -25,6 +25,7 @@
> >  #undef INET_CSK_CLEAR_TIMERS
> >
> >  struct inet_bind_bucket;
> > +struct inet_bind2_bucket;
> >  struct tcp_congestion_ops;
> >
> >  /*
> > @@ -57,6 +58,7 @@ struct inet_connection_sock_af_ops {
> >   *
> >   * @icsk_accept_queue:    FIFO of established children
> >   * @icsk_bind_hash:       Bind node
> > + * @icsk_bind2_hash:      Bind node in the bhash2 table
> >   * @icsk_timeout:         Timeout
> >   * @icsk_retransmit_timer: Resend (no ack)
> >   * @icsk_rto:             Retransmit timeout
> > @@ -84,6 +86,7 @@ struct inet_connection_sock {
> >         struct inet_sock          icsk_inet;
> >         struct request_sock_queue icsk_accept_queue;
> >         struct inet_bind_bucket   *icsk_bind_hash;
> > +       struct inet_bind2_bucket  *icsk_bind2_hash;
> >         unsigned long             icsk_timeout;
> >         struct timer_list         icsk_retransmit_timer;
> >         struct timer_list         icsk_delack_timer;
> > diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.h
> > index 98e1ec1a14f0..17e97dc64b04 100644
> > --- a/include/net/inet_hashtables.h
> > +++ b/include/net/inet_hashtables.h
> > @@ -90,11 +90,30 @@ struct inet_bind_bucket {
> >         struct hlist_head       owners;
> >  };
> >
> > +struct inet_bind2_bucket {
> > +       possible_net_t          ib_net;
> > +       int                     l3mdev;
> > +       unsigned short          port;
> > +       union {
> > +#if IS_ENABLED(CONFIG_IPV6)
> > +               struct in6_addr         v6_rcv_saddr;
> > +#endif
> > +               __be32                  rcv_saddr;
> > +       };
> > +       struct hlist_node       node;           /* Node in the inet2_bind_hashbucket chain */
> > +       struct hlist_head       owners;         /* List of sockets hashed to this bucket */
> > +};
> > +
> >  static inline struct net *ib_net(struct inet_bind_bucket *ib)
> >  {
> >         return read_pnet(&ib->ib_net);
> >  }
> >
> > +static inline struct net *ib2_net(struct inet_bind2_bucket *ib)
> > +{
> > +       return read_pnet(&ib->ib_net);
> > +}
> > +
> >  #define inet_bind_bucket_for_each(tb, head) \
> >         hlist_for_each_entry(tb, head, node)
> >
> > @@ -103,6 +122,15 @@ struct inet_bind_hashbucket {
> >         struct hlist_head       chain;
> >  };
> >
> > +/* This is synchronized using the inet_bind_hashbucket's spinlock.
> > + * Instead of having separate spinlocks, the inet_bind2_hashbucket can share
> > + * the inet_bind_hashbucket's given that in every case where the bhash2 table
> > + * is useful, a lookup in the bhash table also occurs.
> > + */
> > +struct inet_bind2_hashbucket {
> > +       struct hlist_head       chain;
> > +};
> > +
> >  /* Sockets can be hashed in established or listening table.
> >   * We must use different 'nulls' end-of-chain value for all hash buckets :
> >   * A socket might transition from ESTABLISH to LISTEN state without
> > @@ -138,6 +166,11 @@ struct inet_hashinfo {
> >          */
> >         struct kmem_cache               *bind_bucket_cachep;
> >         struct inet_bind_hashbucket     *bhash;
> > +       /* The 2nd binding table hashed by port and address.
> > +        * This is used primarily for expediting the resolution of bind conflicts.
> > +        */
> > +       struct kmem_cache               *bind2_bucket_cachep;
> > +       struct inet_bind2_hashbucket    *bhash2;
> >         unsigned int                    bhash_size;
> >
> >         /* The 2nd listener table hashed by local port and address */
> > @@ -221,6 +254,27 @@ inet_bind_bucket_create(struct kmem_cache *cachep, struct net *net,
> >  void inet_bind_bucket_destroy(struct kmem_cache *cachep,
> >                               struct inet_bind_bucket *tb);
> >
> > +static inline bool check_bind_bucket_match(struct inet_bind_bucket *tb, struct net *net,
> > +                                          const unsigned short port, int l3mdev)
> > +{
> > +       return net_eq(ib_net(tb), net) && tb->port == port && tb->l3mdev == l3mdev;
> > +}
> > +
> > +struct inet_bind2_bucket *
> > +inet_bind2_bucket_create(struct kmem_cache *cachep, struct net *net,
> > +                        struct inet_bind2_hashbucket *head, const unsigned short port,
> > +                        int l3mdev, const struct sock *sk);
> > +
> > +void inet_bind2_bucket_destroy(struct kmem_cache *cachep, struct inet_bind2_bucket *tb);
> > +
> > +struct inet_bind2_bucket *
> > +inet_bind2_bucket_find(struct inet_hashinfo *hinfo, struct net *net, const unsigned short port,
> > +                      int l3mdev, struct sock *sk, struct inet_bind2_hashbucket **head);
> > +
> > +bool check_bind2_bucket_match_nulladdr(struct inet_bind2_bucket *tb, struct net *net,
> > +                                      const unsigned short port, int l3mdev,
> > +                                      const struct sock *sk);
> > +
> >  static inline u32 inet_bhashfn(const struct net *net, const __u16 lport,
> >                                const u32 bhash_size)
> >  {
> > @@ -228,7 +282,7 @@ static inline u32 inet_bhashfn(const struct net *net, const __u16 lport,
> >  }
> >
> >  void inet_bind_hash(struct sock *sk, struct inet_bind_bucket *tb,
> > -                   const unsigned short snum);
> > +                   struct inet_bind2_bucket *tb2, const unsigned short snum);
> >
> >  /* These can have wildcards, don't try too hard. */
> >  static inline u32 inet_lhashfn(const struct net *net, const unsigned short num)
> > diff --git a/include/net/sock.h b/include/net/sock.h
> > index 73063c88a249..c9c6f2d4232f 100644
> > --- a/include/net/sock.h
> > +++ b/include/net/sock.h
> > @@ -351,6 +351,7 @@ struct sk_filter;
> >    *    @sk_txtime_report_errors: set report errors mode for SO_TXTIME
> >    *    @sk_txtime_unused: unused txtime flags
> >    *    @ns_tracker: tracker for netns reference
> > +  *    @sk_bind2_node: bind node in the bhash2 table
> >    */
> >  struct sock {
> >         /*
> > @@ -540,6 +541,7 @@ struct sock {
> >  #endif
> >         struct rcu_head         sk_rcu;
> >         netns_tracker           ns_tracker;
> > +       struct hlist_node       sk_bind2_node;
> >  };
> >
> >  enum sk_pacing {
> > @@ -820,6 +822,16 @@ static inline void sk_add_bind_node(struct sock *sk,
> >         hlist_add_head(&sk->sk_bind_node, list);
> >  }
> >
> > +static inline void __sk_del_bind2_node(struct sock *sk)
> > +{
> > +       __hlist_del(&sk->sk_bind2_node);
> > +}
> > +
> > +static inline void sk_add_bind2_node(struct sock *sk, struct hlist_head *list)
> > +{
> > +       hlist_add_head(&sk->sk_bind2_node, list);
> > +}
> > +
> >  #define sk_for_each(__sk, list) \
> >         hlist_for_each_entry(__sk, list, sk_node)
> >  #define sk_for_each_rcu(__sk, list) \
> > @@ -837,6 +849,8 @@ static inline void sk_add_bind_node(struct sock *sk,
> >         hlist_for_each_entry_safe(__sk, tmp, list, sk_node)
> >  #define sk_for_each_bound(__sk, list) \
> >         hlist_for_each_entry(__sk, list, sk_bind_node)
> > +#define sk_for_each_bound_bhash2(__sk, list) \
> > +       hlist_for_each_entry(__sk, list, sk_bind2_node)
> >
> >  /**
> >   * sk_for_each_entry_offset_rcu - iterate over a list at a given struct offset
> > diff --git a/net/dccp/proto.c b/net/dccp/proto.c
> > index 58421f94427e..4b5ef44ad5c8 100644
> > --- a/net/dccp/proto.c
> > +++ b/net/dccp/proto.c
> > @@ -1121,6 +1121,12 @@ static int __init dccp_init(void)
> >                                   SLAB_HWCACHE_ALIGN | SLAB_ACCOUNT, NULL);
> >         if (!dccp_hashinfo.bind_bucket_cachep)
> >                 goto out_free_hashinfo2;
> > +       dccp_hashinfo.bind2_bucket_cachep =
> > +               kmem_cache_create("dccp_bind2_bucket",
> > +                                 sizeof(struct inet_bind2_bucket), 0,
> > +                                 SLAB_HWCACHE_ALIGN | SLAB_ACCOUNT, NULL);
> > +       if (!dccp_hashinfo.bind2_bucket_cachep)
> > +               goto out_free_bind_bucket_cachep;
> >
> >         /*
> >          * Size and allocate the main established and bind bucket
> > @@ -1151,7 +1157,7 @@ static int __init dccp_init(void)
> >
> >         if (!dccp_hashinfo.ehash) {
> >                 DCCP_CRIT("Failed to allocate DCCP established hash table");
> > -               goto out_free_bind_bucket_cachep;
> > +               goto out_free_bind2_bucket_cachep;
> >         }
> >
> >         for (i = 0; i <= dccp_hashinfo.ehash_mask; i++)
> > @@ -1170,21 +1176,31 @@ static int __init dccp_init(void)
> >                         continue;
> >                 dccp_hashinfo.bhash = (struct inet_bind_hashbucket *)
> >                         __get_free_pages(GFP_ATOMIC|__GFP_NOWARN, bhash_order);
> > +               dccp_hashinfo.bhash2 = (struct inet_bind2_hashbucket *)
> > +                       __get_free_pages(GFP_ATOMIC | __GFP_NOWARN, bhash_order);
>
> I do not think you fixed the issue.
>
> Imagine dccp_hashinfo.bhash allocation has failed, but  bhash2
> allocation succeeded.
>
> We will run another time this code, because of the while
> (!dccp_hashinfo.bhash && --bhash_order >= 0);
>
> So next allocation will overwrite dccp_hashinfo.bhash2 and memory is leaked.
>
> I suggest adding :
>         if (dccp_hashinfo.bhash)
>             dccp_hashinfo.bhash2 = (struct inet_bind2_hashbucket *)
>
> __get_free_pages(GFP_ATOMIC | __GFP_NOWARN, bhash_order);
>
> >         } while (!dccp_hashinfo.bhash && --bhash_order >= 0);
> >
> >         if (!dccp_hashinfo.bhash) {
> >                 DCCP_CRIT("Failed to allocate DCCP bind hash table");
> > +               if (dccp_hashinfo.bhash2)
> > +                       free_pages((unsigned long)dccp_hashinfo.bhash2, bhash_order);
>
>                  Then you can remove this part.
>
Ah I see. Thanks for your feedback - I really like your suggestion. Do
you want me to fix this and send another version or wait a bit?
>
> >                 goto out_free_dccp_locks;
> >         }
> >
> > +       if (!dccp_hashinfo.bhash2) {
> > +               DCCP_CRIT("Failed to allocate DCCP bind2 hash table");
> > +               goto out_free_dccp_bhash;
> > +       }
> > +
> >
