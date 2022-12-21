Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2415F652C1D
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 05:31:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbiLUEbv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 23:31:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiLUEbt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 23:31:49 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 426071B7AA;
        Tue, 20 Dec 2022 20:31:48 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id g13so5030898lfv.7;
        Tue, 20 Dec 2022 20:31:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=QrfSpq2RuHitJmMx7OLWY9yENTrqHZf988KtFFSfC5U=;
        b=nR6AwJrYHhNYR2C08kUjWC96E2EqS4G24E4dNpLHsiWz0D4lFts7h4fINsvq+Xs7ZZ
         OZLxRTajFjIuTUMnVm5mOq6SrFVZXqmF+94iOElTK2s+JypsVn+nQjLaz5vaAkFDZ1g6
         Tx/beFVo8SoyrbByjrM8T5+DmKWT7Fz95xLaHEmgbaseRCcAN5DnIf1XCrIbYvxKgviL
         qjQ3IIccSeK1jYyJFe4zDJVCC3UkKrdV4bNa2Jn+gYQPLv1KALEkBNJybQDNk9z3oUHE
         QSeNzN8wwog088zTzR88M1fFCb1qyTk52LyCJtho5YcFNK5ed1BeMXKTUKj59xEL0YLh
         3Tug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QrfSpq2RuHitJmMx7OLWY9yENTrqHZf988KtFFSfC5U=;
        b=zAtvSPMVAjocXLCxTxgyad3OUy2I2x3X2QWSvrKFqGMX632OxphdjFMMxw3kzNQKPV
         lBJKQI2oZ4dkLrwGXIweRlPF1kafcq0o0wZv2kyDfYGpMwDx59CmylbfMC0nv3xPoHMx
         m9fQjVHR37zJVLUcmeKh8z/DUEPXxR+F9vATV3gBs29RsKo676tFUJP/dDnmcRibfJGP
         KuKQC7oZvjmGIqtddBz+2Ds7VoByjniX9T7zs6HCT814yzFJabaAqA5+KUbJGPpnHvSM
         fi8WvoLiPhnE3S+sQMQVJZIEC9KS2cXagqgEtHPH5z1aqoVQknaRVQFm/xwjWhvDqEXq
         rNIw==
X-Gm-Message-State: AFqh2kreglr+ZQjxJtWdcKDJmEaR0Ic/n6PI5Xq/r+yUVmEqC9w75Xfm
        GDWbxcqalEVCdLJL+Hu6ZGEGYCPuVrQce9MJtmw=
X-Google-Smtp-Source: AMrXdXte+h8LaeQHtFKwpjYSVuVNQShQ2R2LMleRAFjVwUFtXY5FeiDYocweZ97iX/rFecTBxEHHNCxqArxtDtd6Ye8=
X-Received: by 2002:a05:6512:20c1:b0:4b7:ba:3cf8 with SMTP id
 u1-20020a05651220c100b004b700ba3cf8mr64402lfr.511.1671597106453; Tue, 20 Dec
 2022 20:31:46 -0800 (PST)
MIME-Version: 1.0
References: <20221218234801.579114-1-jmaxwell37@gmail.com> <9f145202ca6a59b48d4430ed26a7ab0fe4c5dfaf.camel@redhat.com>
 <bf56c3aa-85df-734d-f419-835a35e66e03@kernel.org> <CAGHK07BehyHXoS+27=cfZoKz4XNTcJjyB5us33sNS7P+_fudHQ@mail.gmail.com>
In-Reply-To: <CAGHK07BehyHXoS+27=cfZoKz4XNTcJjyB5us33sNS7P+_fudHQ@mail.gmail.com>
From:   Jonathan Maxwell <jmaxwell37@gmail.com>
Date:   Wed, 21 Dec 2022 15:31:09 +1100
Message-ID: <CAGHK07D2Dy4zFGHqwdyg+nsRC_iL4ArWTPk7L2ndA2PaLfOMYQ@mail.gmail.com>
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

On Wed, Dec 21, 2022 at 8:55 AM Jonathan Maxwell <jmaxwell37@gmail.com> wrote:
>
> On Wed, Dec 21, 2022 at 2:10 AM David Ahern <dsahern@kernel.org> wrote:
> >
> > On 12/20/22 5:35 AM, Paolo Abeni wrote:
> > > On Mon, 2022-12-19 at 10:48 +1100, Jon Maxwell wrote:
> > >> Sending Ipv6 packets in a loop via a raw socket triggers an issue where a
> > >> route is cloned by ip6_rt_cache_alloc() for each packet sent. This quickly
> > >> consumes the Ipv6 max_size threshold which defaults to 4096 resulting in
> > >> these warnings:
> > >>
> > >> [1]   99.187805] dst_alloc: 7728 callbacks suppressed
> > >> [2] Route cache is full: consider increasing sysctl net.ipv6.route.max_size.
> > >> .
> > >> .
> > >> [300] Route cache is full: consider increasing sysctl net.ipv6.route.max_size.
> > >
> > > If I read correctly, the maximum number of dst that the raw socket can
> > > use this way is limited by the number of packets it allows via the
> > > sndbuf limit, right?
> > >
> > > Are other FLOWI_FLAG_KNOWN_NH users affected, too? e.g. nf_dup_ipv6,
> > > ipvs, seg6?
> > >
> > > @DavidA: why do we need to create RTF_CACHE clones for KNOWN_NH flows?
> > >
> > > Thanks,
> > >
> > > Paolo
> > >
> >
> > If I recall the details correctly: that sysctl limit was added back when
> > ipv6 routes were managed as dst_entries and there was a desire to allow
> > an admin to limit the memory consumed. At this point in time, IPv6 is
> > more inline with IPv4 - a separate struct for fib entries from dst
> > entries. That "Route cache is full" message is now out of date since
> > this is dst_entries which have a gc mechanism.
> >
> > IPv4 does not limit the number of dst_entries that can be allocated
> > (ip_rt_max_size is the sysctl variable behind the ipv4 version of
> > max_size and it is a no-op). IPv6 can probably do the same here?
> >
>
> diff --git a/net/ipv6/route.c b/net/ipv6/route.c
> index dbc224023977..701aba7feaf5 100644
> --- a/net/ipv6/route.c
> +++ b/net/ipv6/route.c
> @@ -6470,7 +6470,7 @@ static int __net_init ip6_route_net_init(struct net *net)
>  #endif
>
>         net->ipv6.sysctl.flush_delay = 0;
> -       net->ipv6.sysctl.ip6_rt_max_size = 4096;
> +       net->ipv6.sysctl.ip6_rt_max_size = INT_MAX;
>         net->ipv6.sysctl.ip6_rt_gc_min_interval = HZ / 2;
>         net->ipv6.sysctl.ip6_rt_gc_timeout = 60*HZ;
>         net->ipv6.sysctl.ip6_rt_gc_interval = 30*HZ;
>
> The above patch resolved it for the Ipv6 reproducer.
>
> Would that be sufficient?
>

Otherwise if you prefer to make Ipv6 behaviour similar to IPv4.
Rather than upping max_size.

Here is prototype patch that removes the max_size check for Ipv6:

diff --git a/include/net/dst_ops.h b/include/net/dst_ops.h
index 88ff7bb2bb9b..632086b2f644 100644
--- a/include/net/dst_ops.h
+++ b/include/net/dst_ops.h
@@ -16,7 +16,7 @@ struct dst_ops {
        unsigned short          family;
        unsigned int            gc_thresh;

-       int                     (*gc)(struct dst_ops *ops);
+       void                    (*gc)(struct dst_ops *ops);
        struct dst_entry *      (*check)(struct dst_entry *, __u32 cookie);
        unsigned int            (*default_advmss)(const struct dst_entry *);
        unsigned int            (*mtu)(const struct dst_entry *);
diff --git a/net/core/dst.c b/net/core/dst.c
index 497ef9b3fc6a..dcb85267bc4c 100644
--- a/net/core/dst.c
+++ b/net/core/dst.c
@@ -82,12 +82,8 @@ void *dst_alloc(struct dst_ops *ops, struct net_device *dev,

        if (ops->gc &&
            !(flags & DST_NOCOUNT) &&
-           dst_entries_get_fast(ops) > ops->gc_thresh) {
-               if (ops->gc(ops)) {
-                       pr_notice_ratelimited("Route cache is full:
consider increasing sysctl net.ipv6.route.max_size.\n");
-                       return NULL;
-               }
-       }
+           dst_entries_get_fast(ops) > ops->gc_thresh)
+               ops->gc(ops);

        dst = kmem_cache_alloc(ops->kmem_cachep, GFP_ATOMIC);
        if (!dst)
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index dbc224023977..8db7c5436da4 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -91,7 +91,7 @@ static struct dst_entry *ip6_negative_advice(struct
dst_entry *);
 static void            ip6_dst_destroy(struct dst_entry *);
 static void            ip6_dst_ifdown(struct dst_entry *,
                                       struct net_device *dev, int how);
-static int              ip6_dst_gc(struct dst_ops *ops);
+static void             ip6_dst_gc(struct dst_ops *ops);

 static int             ip6_pkt_discard(struct sk_buff *skb);
 static int             ip6_pkt_discard_out(struct net *net, struct
sock *sk, struct sk_buff *skb);
@@ -3295,32 +3295,21 @@ struct dst_entry *icmp6_dst_alloc(struct
net_device *dev,
        return dst;
 }

-static int ip6_dst_gc(struct dst_ops *ops)
+static void ip6_dst_gc(struct dst_ops *ops)
 {
        struct net *net = container_of(ops, struct net, ipv6.ip6_dst_ops);
-       int rt_min_interval = net->ipv6.sysctl.ip6_rt_gc_min_interval;
-       int rt_max_size = net->ipv6.sysctl.ip6_rt_max_size;
        int rt_elasticity = net->ipv6.sysctl.ip6_rt_gc_elasticity;
        int rt_gc_timeout = net->ipv6.sysctl.ip6_rt_gc_timeout;
-       unsigned long rt_last_gc = net->ipv6.ip6_rt_last_gc;
        int entries;

        entries = dst_entries_get_fast(ops);
-       if (entries > rt_max_size)
-               entries = dst_entries_get_slow(ops);
-
-       if (time_after(rt_last_gc + rt_min_interval, jiffies) &&
-           entries <= rt_max_size)
-               goto out;

        net->ipv6.ip6_rt_gc_expire++;
        fib6_run_gc(net->ipv6.ip6_rt_gc_expire, net, true);
        entries = dst_entries_get_slow(ops);
        if (entries < ops->gc_thresh)
                net->ipv6.ip6_rt_gc_expire = rt_gc_timeout>>1;
-out:
        net->ipv6.ip6_rt_gc_expire -= net->ipv6.ip6_rt_gc_expire>>rt_elasticity;
-       return entries > rt_max_size;
 }

 static int ip6_nh_lookup_table(struct net *net, struct fib6_config *cfg,

> > I do not believe the suggested flag is the right change.
>
> Regards
>
> Jon
