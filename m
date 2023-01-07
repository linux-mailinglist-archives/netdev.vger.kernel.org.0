Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4BBB66129E
	for <lists+netdev@lfdr.de>; Sun,  8 Jan 2023 00:46:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232050AbjAGXqs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Jan 2023 18:46:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbjAGXqr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Jan 2023 18:46:47 -0500
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6764812D1A;
        Sat,  7 Jan 2023 15:46:45 -0800 (PST)
Received: by mail-lj1-x22d.google.com with SMTP id bn6so5165906ljb.13;
        Sat, 07 Jan 2023 15:46:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=SRndX3WqGmFsRynDQGKUwycLpR69tOwTWmK8G36K/K0=;
        b=UxNQbn5g9SG7tYwFsU0J8qPRrYgub3N4vwAGnQxV8qC2YyfiYlianRxkPgIqfJz+ea
         y0Sb3Lk+6qgP5WS4LplYq1k5M8YEu9m/oMOJ/Qer1GSVAf23NYFqATsTBiaC3qC34pzr
         PCNSxGvkabYm/lUz04hn+Pnkj3GnjcLacwtuOwQlh7GOzLq9lIWI3NL3yef5CBY2VySl
         Sv5N34I2YXuyWAbg/t8kjtjQUJ9ZMKmJYtMbK2/xaUcNDysmLLNodBpMFL94Gzr/AsyX
         L61Tzvu5lnepkkn099aH1yAJv3fgcBxLlXlg6WEsSOLhCOROFmtTxVj2k+BE+CTIyEv7
         UBAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SRndX3WqGmFsRynDQGKUwycLpR69tOwTWmK8G36K/K0=;
        b=DARfmgNkGUYXiXmZ/Q0FUyyK6w+hFshc8JClVt5uUKdMKAULwXlgI80l20481mZJr4
         ehwxVB4xxoLLkBjFvYhuAjWWhKHsYpaXxI57/FwOZk6+f7E71P+Mhk1FzP/2da5T4bcl
         KnJiip3Mm1Myo33+D/Zq46USMY0CPDQsh3riRwPUMXx3ImCEHwxnefjpmhYJdu32szG/
         c1ZwZPzuH1bjCaEqLijtexXaY8s4LP2HXLkl5b84Z3KvRShRl5246FrzysQHBtkDCZ6w
         tp8Dm2vx1qUrBzBHmjmrooIoihZei7EoCaEVOIjYOIxHkKHbGyyoLD3WPbXvqth4eQfo
         b3GQ==
X-Gm-Message-State: AFqh2koJPRVy4vwSfmJv73UGa2/LFyqW0wG0FSrMAGOh05Xihn/aVsSY
        sU2TXSKt405KLUxmqgLzFszbJpwBXr+2PydI7bM=
X-Google-Smtp-Source: AMrXdXsXbEQ++joMTavVri8eE2FFPqy9j2x+VTA7f9vNtzLK7Yq7gVeMMZJCkONfb634iaDE9C0PV68uuB3jG9ZGnVI=
X-Received: by 2002:a2e:be1d:0:b0:27b:5a9f:3bf5 with SMTP id
 z29-20020a2ebe1d000000b0027b5a9f3bf5mr3916221ljq.320.1673135203523; Sat, 07
 Jan 2023 15:46:43 -0800 (PST)
MIME-Version: 1.0
References: <20221218234801.579114-1-jmaxwell37@gmail.com> <9f145202ca6a59b48d4430ed26a7ab0fe4c5dfaf.camel@redhat.com>
 <CAGHK07ALtLTjRP-XOepqoc8xzWcT8=0v5ccL-98f4+SU9vwfsg@mail.gmail.com>
 <20221223212835.eb9d03f3f7db22360e34341d@uniroma2.it> <CAGHK07APOwLvhs73WKkQfZuEy2FoKEWJusSyejKVcth4D47g=w@mail.gmail.com>
 <CAGHK07Crj8s0wOivw62Q_N4Km6r1qsH-y-8YgfYhX-JJF6kZSA@mail.gmail.com>
 <20230103170711.819921d40132494b4bfd6a0d@uniroma2.it> <20230107002656.b732de6750a063d07cdb8a5f@uniroma2.it>
In-Reply-To: <20230107002656.b732de6750a063d07cdb8a5f@uniroma2.it>
From:   Jonathan Maxwell <jmaxwell37@gmail.com>
Date:   Sun, 8 Jan 2023 10:46:09 +1100
Message-ID: <CAGHK07CbJo_XPpTnfWtvy+_nxM267vhx3hUT5AR4-mpkfsh7pQ@mail.gmail.com>
Subject: Re: [net-next] ipv6: fix routing cache overflow for raw sockets
To:     Andrea Mayer <andrea.mayer@uniroma2.it>
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 7, 2023 at 10:27 AM Andrea Mayer <andrea.mayer@uniroma2.it> wrote:
>
> Hi Jon,
> please see after, thanks.
>
> >
> > > Any chance you could test this patch based on the latest net-next
> > > kernel and let me know the result?
> > >
> > > diff --git a/include/net/dst_ops.h b/include/net/dst_ops.h
> > > index 88ff7bb2bb9b..632086b2f644 100644
> > > --- a/include/net/dst_ops.h
> > > +++ b/include/net/dst_ops.h
> > > @@ -16,7 +16,7 @@ struct dst_ops {
> > >         unsigned short          family;
> > >         unsigned int            gc_thresh;
> > >
> > > -       int                     (*gc)(struct dst_ops *ops);
> > > +       void                    (*gc)(struct dst_ops *ops);
> > >         struct dst_entry *      (*check)(struct dst_entry *, __u32 cookie);
> > >         unsigned int            (*default_advmss)(const struct dst_entry *);
> > >         unsigned int            (*mtu)(const struct dst_entry *);
> > > diff --git a/net/core/dst.c b/net/core/dst.c
> > > index 6d2dd03dafa8..31c08a3386d3 100644
> > > --- a/net/core/dst.c
> > > +++ b/net/core/dst.c
> > > @@ -82,12 +82,8 @@ void *dst_alloc(struct dst_ops *ops, struct net_device *dev,
> > >
> > >         if (ops->gc &&
> > >             !(flags & DST_NOCOUNT) &&
> > > -           dst_entries_get_fast(ops) > ops->gc_thresh) {
> > > -               if (ops->gc(ops)) {
> > > -                       pr_notice_ratelimited("Route cache is full:
> > > consider increasing sysctl net.ipv6.route.max_size.\n");
> > > -                       return NULL;
> > > -               }
> > > -       }
> > > +           dst_entries_get_fast(ops) > ops->gc_thresh)
> > > +               ops->gc(ops);
> > >
> > >         dst = kmem_cache_alloc(ops->kmem_cachep, GFP_ATOMIC);
> > >         if (!dst)
> > > diff --git a/net/ipv6/route.c b/net/ipv6/route.c
> > > index e74e0361fd92..b643dda68d31 100644
> > > --- a/net/ipv6/route.c
> > > +++ b/net/ipv6/route.c
> > > @@ -91,7 +91,7 @@ static struct dst_entry *ip6_negative_advice(struct
> > > dst_entry *);
> > >  static void            ip6_dst_destroy(struct dst_entry *);
> > >  static void            ip6_dst_ifdown(struct dst_entry *,
> > >                                        struct net_device *dev, int how);
> > > -static int              ip6_dst_gc(struct dst_ops *ops);
> > > +static void             ip6_dst_gc(struct dst_ops *ops);
> > >
> > >  static int             ip6_pkt_discard(struct sk_buff *skb);
> > >  static int             ip6_pkt_discard_out(struct net *net, struct
> > > sock *sk, struct sk_buff *skb);
> > > @@ -3284,11 +3284,10 @@ struct dst_entry *icmp6_dst_alloc(struct
> > > net_device *dev,
> > >         return dst;
> > >  }
> > >
> > > -static int ip6_dst_gc(struct dst_ops *ops)
> > > +static void ip6_dst_gc(struct dst_ops *ops)
> > >  {
> > >         struct net *net = container_of(ops, struct net, ipv6.ip6_dst_ops);
> > >         int rt_min_interval = net->ipv6.sysctl.ip6_rt_gc_min_interval;
> > > -       int rt_max_size = net->ipv6.sysctl.ip6_rt_max_size;
> > >         int rt_elasticity = net->ipv6.sysctl.ip6_rt_gc_elasticity;
> > >         int rt_gc_timeout = net->ipv6.sysctl.ip6_rt_gc_timeout;
> > >         unsigned long rt_last_gc = net->ipv6.ip6_rt_last_gc;
> > > @@ -3296,11 +3295,10 @@ static int ip6_dst_gc(struct dst_ops *ops)
> > >         int entries;
> > >
> > >         entries = dst_entries_get_fast(ops);
> > > -       if (entries > rt_max_size)
> > > +       if (entries > ops->gc_thresh)
> > >                 entries = dst_entries_get_slow(ops);
> > >
> > > -       if (time_after(rt_last_gc + rt_min_interval, jiffies) &&
> > > -           entries <= rt_max_size)
> > > +       if (time_after(rt_last_gc + rt_min_interval, jiffies))
> > >                 goto out;
> > >
> > >         fib6_run_gc(atomic_inc_return(&net->ipv6.ip6_rt_gc_expire), net, true);
> > > @@ -3310,7 +3308,6 @@ static int ip6_dst_gc(struct dst_ops *ops)
> > >  out:
> > >         val = atomic_read(&net->ipv6.ip6_rt_gc_expire);
> > >         atomic_set(&net->ipv6.ip6_rt_gc_expire, val - (val >> rt_elasticity));
> > > -       return entries > rt_max_size;
> > >  }
> > >
> > >  static int ip6_nh_lookup_table(struct net *net, struct fib6_config *cfg,
> > > @@ -6512,7 +6509,7 @@ static int __net_init ip6_route_net_init(struct net *net)
> > >  #endif
> > >
> > >         net->ipv6.sysctl.flush_delay = 0;
> > > -       net->ipv6.sysctl.ip6_rt_max_size = 4096;
> > > +       net->ipv6.sysctl.ip6_rt_max_size = INT_MAX;
> > >         net->ipv6.sysctl.ip6_rt_gc_min_interval = HZ / 2;
> > >         net->ipv6.sysctl.ip6_rt_gc_timeout = 60*HZ;
> > >         net->ipv6.sysctl.ip6_rt_gc_interval = 30*HZ;
> > >
> >
> > Yes, I will apply this patch in the next days and check how it deals with the
> > seg6 subsystem. I will keep you posted.
> >
>
> I applied the patch* to the net-next (HEAD 6bd4755c7c49) and did some tests on
> the seg6 subsystem, specifically running the End.X/DX6 behaviors. They seem to
> work fine.

Thanks Andrea much appreciated. It worked fine in my raw socket tests as well.
I'll look at submitting it soon.

>
> (*) I had to slightly edit the patch because of the code formatting, e.g.
>     some incorrect line breaks, spaces, etc.
>

Sorry about that, I should have sent it from git to avoid that.

Regards

Jon

> Ciao,
> Andrea
>
> >
> > > On Sat, Dec 24, 2022 at 6:38 PM Jonathan Maxwell <jmaxwell37@gmail.com> wrote:
> > > >
> > > > On Sat, Dec 24, 2022 at 7:28 AM Andrea Mayer <andrea.mayer@uniroma2.it> wrote:
> > > > >
> > > > > Hi Jon,
> > > > > please see below, thanks.
> > > > >
> > > > > On Wed, 21 Dec 2022 08:48:11 +1100
> > > > > Jonathan Maxwell <jmaxwell37@gmail.com> wrote:
> > > > >
> > > > > > On Tue, Dec 20, 2022 at 11:35 PM Paolo Abeni <pabeni@redhat.com> wrote:
> > > > > > >
> > > > > > > On Mon, 2022-12-19 at 10:48 +1100, Jon Maxwell wrote:
> > > > > > > > Sending Ipv6 packets in a loop via a raw socket triggers an issue where a
> > > > > > > > route is cloned by ip6_rt_cache_alloc() for each packet sent. This quickly
> > > > > > > > consumes the Ipv6 max_size threshold which defaults to 4096 resulting in
> > > > > > > > these warnings:
> > > > > > > >
> > > > > > > > [1]   99.187805] dst_alloc: 7728 callbacks suppressed
> > > > > > > > [2] Route cache is full: consider increasing sysctl net.ipv6.route.max_size.
> > > > > > > > .
> > > > > > > > .
> > > > > > > > [300] Route cache is full: consider increasing sysctl net.ipv6.route.max_size.
> > > > > > >
> > > > > > > If I read correctly, the maximum number of dst that the raw socket can
> > > > > > > use this way is limited by the number of packets it allows via the
> > > > > > > sndbuf limit, right?
> > > > > > >
> > > > > >
> > > > > > Yes, but in my test sndbuf limit is never hit so it clones a route for
> > > > > > every packet.
> > > > > >
> > > > > > e.g:
> > > > > >
> > > > > > output from C program sending 5000000 packets via a raw socket.
> > > > > >
> > > > > > ip raw: total num pkts 5000000
> > > > > >
> > > > > > # bpftrace -e 'kprobe:dst_alloc {@count[comm] = count()}'
> > > > > > Attaching 1 probe...
> > > > > >
> > > > > > @count[a.out]: 5000009
> > > > > >
> > > > > > > Are other FLOWI_FLAG_KNOWN_NH users affected, too? e.g. nf_dup_ipv6,
> > > > > > > ipvs, seg6?
> > > > > > >
> > > > > >
> > > > > > Any call to ip6_pol_route(s) where no res.nh->fib_nh_gw_family is 0 can do it.
> > > > > > But we have only seen this for raw sockets so far.
> > > > > >
> > > > >
> > > > > In the SRv6 subsystem, the seg6_lookup_nexthop() is used by some
> > > > > cross-connecting behaviors such as End.X and End.DX6 to forward traffic to a
> > > > > specified nexthop. SRv6 End.X/DX6 can specify an IPv6 DA (i.e., a nexthop)
> > > > > different from the one carried by the IPv6 header. For this purpose,
> > > > > seg6_lookup_nexthop() sets the FLOWI_FLAG_KNOWN_NH.
> > > > >
> > > > Hi Andrea,
> > > >
> > > > Thanks for pointing that datapath out. The more generic approach we are
> > > > taking bringing Ipv6 closer to Ipv4 in this regard should fix all instances
> > > > of this.
> > > >
> > > > > > > > [1]   99.187805] dst_alloc: 7728 callbacks suppressed
> > > > > > > > [2] Route cache is full: consider increasing sysctl net.ipv6.route.max_size.
> > > > > > > > .
> > > > > > > > .
> > > > > > > > [300] Route cache is full: consider increasing sysctl net.ipv6.route.max_size.
> > > > >
> > > > > I can reproduce the same warning messages reported by you, by instantiating an
> > > > > End.X behavior whose nexthop is handled by a route for which there is no "via".
> > > > > In this configuration, the ip6_pol_route() (called by seg6_lookup_nexthop())
> > > > > triggers ip6_rt_cache_alloc() because i) the FLOWI_FLAG_KNOWN_NH is present ii)
> > > > > and the res.nh->fib_nh_gw_family is 0 (as already pointed out).
> > > > >
> > > >
> > > > Nice, when I get back after the holiday break I'll submit the next patch. It
> > > > would be great if you could test the new patch and let me know how it works in
> > > > your tests at that juncture. I'll keep you posted.
> > > >
> > > > Regards
> > > >
> > > > Jon
> > > >
> > > > > > Regards
> > > > > >
> > > > > > Jon
> > > > >
> > > > > Ciao,
> > > > > Andrea
> >
> >
> > --
> > Andrea Mayer <andrea.mayer@uniroma2.it>
>
>
> --
> Andrea Mayer <andrea.mayer@uniroma2.it>
