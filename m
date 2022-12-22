Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91082653BCB
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 06:40:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230417AbiLVFkC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 00:40:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiLVFkB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 00:40:01 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B88713EBC;
        Wed, 21 Dec 2022 21:40:00 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id x11so1231061lfn.0;
        Wed, 21 Dec 2022 21:40:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Q2wMW4A7w/lGCoVRU7jKGf5pziTEUEGOvTu5cpMPFGo=;
        b=XgkriJeRzw3TuTEkJlMTg7lt3CW6sVRjPycUFqcEpyL9FvVk6lsAQHyOkjLZdi3NcL
         PMS3Nois69/vR34Dw3LTp+uiPy5L3WhXv9Nl5PiLTx9ZxhUQhKV9eiYzGfCSQFMUcPrq
         /luZFu22J2bkQzC1JWnu8Uih1qP+bznHo/k6aa9epHZhKh3vysuyz+sE4wz/xpej77fS
         E2Vr2zX8v3t8nlnizJR69Jf6acjEw06Pq/q0aWvuReRV2kGx6mdS97RJg3kKEfpvHac3
         YglDIippPwBDIZFnzm5TkHUZLyReUdHDUbZb6Pyblo4lvyDK5OYw7Q3Ju8T6krkqOcpN
         drCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Q2wMW4A7w/lGCoVRU7jKGf5pziTEUEGOvTu5cpMPFGo=;
        b=LQGJXv8k+Sjci7fAnEDkDNXVai4EsQc/QXaierE6J27OhmKPAENvM8JtSOpz6kLqqc
         ZKoSbTwDip7kNH8wHFsBPAwpfsVZl6Ub/fw8zCbtTllC7fgcp0kq3vSh7YritxXfCnxP
         CzGygBrxZMjHXIURb/8SLorEoyRNFvI15Rq05TkAgN+LEDVajH+dg6/6QacDfsnbawHZ
         4w0Yhb20ZmPL5CHplTnHtvZ+2A9O+9tGY8gAqJwKlzJ4Cig7dkIlkscWQwIKYx+Vk0h9
         BCLxWkGmadtJjX026HpJ/rvJXOslOYFTtPpV1TWkVMnWr5lIgHZR/GKEnvHjtI/25Mc+
         NERw==
X-Gm-Message-State: AFqh2kqt1ifv6pKBgZu9lgF5j1VhB0XRixwXjytI+/tp2iRq+/4d1u7O
        nv5R4ILFbyicUNr99qWP5ocW/bPFQ+Ba4219EVQ=
X-Google-Smtp-Source: AMrXdXs//td63oy92QcY5/viNOMn0IRgcHT2NuhED1i0wZii8vyvRQUIJzyAt9sgyqpem/sXH+ORnJyeeKxGeQ8WV7I=
X-Received: by 2002:ac2:41da:0:b0:4b4:af05:4a8d with SMTP id
 d26-20020ac241da000000b004b4af054a8dmr228392lfi.415.1671687598455; Wed, 21
 Dec 2022 21:39:58 -0800 (PST)
MIME-Version: 1.0
References: <20221218234801.579114-1-jmaxwell37@gmail.com> <9f145202ca6a59b48d4430ed26a7ab0fe4c5dfaf.camel@redhat.com>
 <bf56c3aa-85df-734d-f419-835a35e66e03@kernel.org> <CAGHK07BehyHXoS+27=cfZoKz4XNTcJjyB5us33sNS7P+_fudHQ@mail.gmail.com>
 <CAGHK07D2Dy4zFGHqwdyg+nsRC_iL4ArWTPk7L2ndA2PaLfOMYQ@mail.gmail.com>
In-Reply-To: <CAGHK07D2Dy4zFGHqwdyg+nsRC_iL4ArWTPk7L2ndA2PaLfOMYQ@mail.gmail.com>
From:   Jonathan Maxwell <jmaxwell37@gmail.com>
Date:   Thu, 22 Dec 2022 16:39:21 +1100
Message-ID: <CAGHK07DU15NhFvGuLB6WHUF0fffT3MefL3E3JWHmtWR6Wzm0bA@mail.gmail.com>
Subject: Re: [net-next] ipv6: fix routing cache overflow for raw sockets
To:     David Ahern <dsahern@kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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

On Wed, Dec 21, 2022 at 3:31 PM Jonathan Maxwell <jmaxwell37@gmail.com> wrote:
>
> On Wed, Dec 21, 2022 at 8:55 AM Jonathan Maxwell <jmaxwell37@gmail.com> wrote:
> >
> > On Wed, Dec 21, 2022 at 2:10 AM David Ahern <dsahern@kernel.org> wrote:
> > >
> > > On 12/20/22 5:35 AM, Paolo Abeni wrote:
> > > > On Mon, 2022-12-19 at 10:48 +1100, Jon Maxwell wrote:
> > > >> Sending Ipv6 packets in a loop via a raw socket triggers an issue where a
> > > >> route is cloned by ip6_rt_cache_alloc() for each packet sent. This quickly
> > > >> consumes the Ipv6 max_size threshold which defaults to 4096 resulting in
> > > >> these warnings:
> > > >>
> > > >> [1]   99.187805] dst_alloc: 7728 callbacks suppressed
> > > >> [2] Route cache is full: consider increasing sysctl net.ipv6.route.max_size.
> > > >> .
> > > >> .
> > > >> [300] Route cache is full: consider increasing sysctl net.ipv6.route.max_size.
> > > >
> > > > If I read correctly, the maximum number of dst that the raw socket can
> > > > use this way is limited by the number of packets it allows via the
> > > > sndbuf limit, right?
> > > >
> > > > Are other FLOWI_FLAG_KNOWN_NH users affected, too? e.g. nf_dup_ipv6,
> > > > ipvs, seg6?
> > > >
> > > > @DavidA: why do we need to create RTF_CACHE clones for KNOWN_NH flows?
> > > >
> > > > Thanks,
> > > >
> > > > Paolo
> > > >
> > >
> > > If I recall the details correctly: that sysctl limit was added back when
> > > ipv6 routes were managed as dst_entries and there was a desire to allow
> > > an admin to limit the memory consumed. At this point in time, IPv6 is
> > > more inline with IPv4 - a separate struct for fib entries from dst
> > > entries. That "Route cache is full" message is now out of date since
> > > this is dst_entries which have a gc mechanism.
> > >
> > > IPv4 does not limit the number of dst_entries that can be allocated
> > > (ip_rt_max_size is the sysctl variable behind the ipv4 version of
> > > max_size and it is a no-op). IPv6 can probably do the same here?
> > >
> >
> > diff --git a/net/ipv6/route.c b/net/ipv6/route.c
> > index dbc224023977..701aba7feaf5 100644
> > --- a/net/ipv6/route.c
> > +++ b/net/ipv6/route.c
> > @@ -6470,7 +6470,7 @@ static int __net_init ip6_route_net_init(struct net *net)
> >  #endif
> >
> >         net->ipv6.sysctl.flush_delay = 0;
> > -       net->ipv6.sysctl.ip6_rt_max_size = 4096;
> > +       net->ipv6.sysctl.ip6_rt_max_size = INT_MAX;
> >         net->ipv6.sysctl.ip6_rt_gc_min_interval = HZ / 2;
> >         net->ipv6.sysctl.ip6_rt_gc_timeout = 60*HZ;
> >         net->ipv6.sysctl.ip6_rt_gc_interval = 30*HZ;
> >
> > The above patch resolved it for the Ipv6 reproducer.
> >
> > Would that be sufficient?
> >
>
> Otherwise if you prefer to make Ipv6 behaviour similar to IPv4.
> Rather than upping max_size.
>
> Here is prototype patch that removes the max_size check for Ipv6:
>

There are some mistakes in this prototype patch. Let me come up with a
better one. I'll submit a new patch in the new year for review. Thanks for
the suggestion DavidA.

Regards

Jon

> diff --git a/include/net/dst_ops.h b/include/net/dst_ops.h
> index 88ff7bb2bb9b..632086b2f644 100644
> --- a/include/net/dst_ops.h
> +++ b/include/net/dst_ops.h
> @@ -16,7 +16,7 @@ struct dst_ops {
>         unsigned short          family;
>         unsigned int            gc_thresh;
>
> -       int                     (*gc)(struct dst_ops *ops);
> +       void                    (*gc)(struct dst_ops *ops);
>         struct dst_entry *      (*check)(struct dst_entry *, __u32 cookie);
>         unsigned int            (*default_advmss)(const struct dst_entry *);
>         unsigned int            (*mtu)(const struct dst_entry *);
> diff --git a/net/core/dst.c b/net/core/dst.c
> index 497ef9b3fc6a..dcb85267bc4c 100644
> --- a/net/core/dst.c
> +++ b/net/core/dst.c
> @@ -82,12 +82,8 @@ void *dst_alloc(struct dst_ops *ops, struct net_device *dev,
>
>         if (ops->gc &&
>             !(flags & DST_NOCOUNT) &&
> -           dst_entries_get_fast(ops) > ops->gc_thresh) {
> -               if (ops->gc(ops)) {
> -                       pr_notice_ratelimited("Route cache is full:
> consider increasing sysctl net.ipv6.route.max_size.\n");
> -                       return NULL;
> -               }
> -       }
> +           dst_entries_get_fast(ops) > ops->gc_thresh)
> +               ops->gc(ops);
>
>         dst = kmem_cache_alloc(ops->kmem_cachep, GFP_ATOMIC);
>         if (!dst)
> diff --git a/net/ipv6/route.c b/net/ipv6/route.c
> index dbc224023977..8db7c5436da4 100644
> --- a/net/ipv6/route.c
> +++ b/net/ipv6/route.c
> @@ -91,7 +91,7 @@ static struct dst_entry *ip6_negative_advice(struct
> dst_entry *);
>  static void            ip6_dst_destroy(struct dst_entry *);
>  static void            ip6_dst_ifdown(struct dst_entry *,
>                                        struct net_device *dev, int how);
> -static int              ip6_dst_gc(struct dst_ops *ops);
> +static void             ip6_dst_gc(struct dst_ops *ops);
>
>  static int             ip6_pkt_discard(struct sk_buff *skb);
>  static int             ip6_pkt_discard_out(struct net *net, struct
> sock *sk, struct sk_buff *skb);
> @@ -3295,32 +3295,21 @@ struct dst_entry *icmp6_dst_alloc(struct
> net_device *dev,
>         return dst;
>  }
>
> -static int ip6_dst_gc(struct dst_ops *ops)
> +static void ip6_dst_gc(struct dst_ops *ops)
>  {
>         struct net *net = container_of(ops, struct net, ipv6.ip6_dst_ops);
> -       int rt_min_interval = net->ipv6.sysctl.ip6_rt_gc_min_interval;
> -       int rt_max_size = net->ipv6.sysctl.ip6_rt_max_size;
>         int rt_elasticity = net->ipv6.sysctl.ip6_rt_gc_elasticity;
>         int rt_gc_timeout = net->ipv6.sysctl.ip6_rt_gc_timeout;
> -       unsigned long rt_last_gc = net->ipv6.ip6_rt_last_gc;
>         int entries;
>
>         entries = dst_entries_get_fast(ops);
> -       if (entries > rt_max_size)
> -               entries = dst_entries_get_slow(ops);
> -
> -       if (time_after(rt_last_gc + rt_min_interval, jiffies) &&
> -           entries <= rt_max_size)
> -               goto out;
>
>         net->ipv6.ip6_rt_gc_expire++;
>         fib6_run_gc(net->ipv6.ip6_rt_gc_expire, net, true);
>         entries = dst_entries_get_slow(ops);
>         if (entries < ops->gc_thresh)
>                 net->ipv6.ip6_rt_gc_expire = rt_gc_timeout>>1;
> -out:
>         net->ipv6.ip6_rt_gc_expire -= net->ipv6.ip6_rt_gc_expire>>rt_elasticity;
> -       return entries > rt_max_size;
>  }
>
>  static int ip6_nh_lookup_table(struct net *net, struct fib6_config *cfg,
>
> > > I do not believe the suggested flag is the right change.
> >
> > Regards
> >
> > Jon
