Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB671D58FE
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 02:23:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729494AbfJNAXQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Oct 2019 20:23:16 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:39354 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729296AbfJNAXP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Oct 2019 20:23:15 -0400
Received: by mail-io1-f68.google.com with SMTP id a1so34324479ioc.6
        for <netdev@vger.kernel.org>; Sun, 13 Oct 2019 17:23:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eaHtgB+28DIOQuUv7xzL4QtzfV4+ITT66x7Q1u5QYIk=;
        b=huHXRtK92wn0ivLRsS+wekx9lfsysNaaLWNjndiDXHUxPGCG7C+dXoIULGhjG1gFfK
         1W9kjOahvA14lygGOSgL/IAb1WWMnc7BCMbOleoE6kS9CjaoSVvAkl9DOIHltlboXGS1
         FvDssgOxDTLk3ejxWyl1TuqebkTgl7z71JWfrrmoA1OchZj8UxfpgQaQupFyBK92mSGy
         aVu9iL7aibe+9mkeZ+/A0QGE+0O8JYhZvlJVUqYSCSDLhuQMzV61PV0VqAERX5+/a8kD
         Y407szkag/M0kefZJZMyIgj0L4qB9t4hCyWsd6GxsM8NBmG2RmhpbQ9Miz0ZeKoY+Ear
         UQIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eaHtgB+28DIOQuUv7xzL4QtzfV4+ITT66x7Q1u5QYIk=;
        b=cnVH7BMm9P5wX6Im0pj8HcpbLcGD8tC/8bABYwa6DvONoo5ddG1Sd5dH2o65b91Wg2
         Y+EhnVxdfxbgzMlQ+zD7UKC9+7IqHbmj6/Z6V+1D4k7OopUOxEkJ0Zz819qsgM+AjJGO
         94cczfUJISurf+KdP2di1heGAmr+DpdL9hY0hqGd2tMEbNrxRAOMOSK5xFeMfke2cADo
         jpXyxxn2IXG90Eq0uoZFBHMP+CC/eMqfz4IgCuTa/XL1Aca9qBq6jH+lYH2HSyNPsxeA
         rrlYpxakNF5STE6kulF83lg+Gixhyc2YU97NHYfNlO5P8p5tc4nmzeNPvSxO1oGHMwXe
         3e5g==
X-Gm-Message-State: APjAAAUtHtefsB/pdSs1EF0WAubTUwX1kd40ZQ92m26+rkz6g+0qyx6/
        Ak/DrGfz3rvSzvLVl95bQsj5fOTIVSNZ9H8jdKhbPA==
X-Google-Smtp-Source: APXvYqwZtYG2m8VXUnQRMvkKiEip5YlJHsnj4hzWV6CkWZ7n/49/CCyIXxBFrwMjNfOxaIQXwIwkf6bDqAD61lRoZgg=
X-Received: by 2002:a6b:7c09:: with SMTP id m9mr16538836iok.286.1571012592768;
 Sun, 13 Oct 2019 17:23:12 -0700 (PDT)
MIME-Version: 1.0
References: <CANSNSoV1M9stB7CnUcEhsz3FHi4NV_yrBtpYsZ205+rqnvMbvA@mail.gmail.com>
 <20191010083102.GA1336@splinter> <CANSNSoVM1Uo106xfJtGpTyXNed8kOL4JiXqf3A1eZHBa7z3=yg@mail.gmail.com>
 <20191011154224.GA23486@splinter> <CAEA6p_AFKwx_oLqNOjMw=oXcAX4ftJvEQWLo0aWCh=4Hs=QjVw@mail.gmail.com>
 <20191012065608.igcba7tcjr4wkfsf@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20191012065608.igcba7tcjr4wkfsf@kafai-mbp.dhcp.thefacebook.com>
From:   Wei Wang <weiwan@google.com>
Date:   Sun, 13 Oct 2019 17:23:01 -0700
Message-ID: <CAEA6p_A_kNA8kVLmVn0e=fp=vx3xpHTTaVrx62NVCDLowVxaog@mail.gmail.com>
Subject: Re: Race condition in route lookup
To:     Martin Lau <kafai@fb.com>
Cc:     Ido Schimmel <idosch@idosch.org>,
        Jesse Hathaway <jesse@mbuki-mvuki.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 11, 2019 at 11:56 PM Martin Lau <kafai@fb.com> wrote:
>
> On Fri, Oct 11, 2019 at 10:54:13AM -0700, Wei Wang wrote:
> > On Fri, Oct 11, 2019 at 8:42 AM Ido Schimmel <idosch@idosch.org> wrote:
> > >
> > > On Fri, Oct 11, 2019 at 09:36:51AM -0500, Jesse Hathaway wrote:
> > > > On Thu, Oct 10, 2019 at 3:31 AM Ido Schimmel <idosch@idosch.org> wrote:
> > > > > I think it's working as expected. Here is my theory:
> > > > >
> > > > > If CPU0 is executing both the route get request and forwarding packets
> > > > > through the directly connected interface, then the following can happen:
> > > > >
> > > > > <CPU0, t0> - In process context, per-CPU dst entry cached in the nexthop
> > > > > is found. Not yet dumped to user space
> > > > >
> > > > > <Any CPU, t1> - Routes are added / removed, therefore invalidating the
> > > > > cache by bumping 'net->ipv4.rt_genid'
> > > > >
> > > > > <CPU0, t2> - In softirq, packet is forwarded through the nexthop. The
> > > > > cached dst entry is found to be invalid. Therefore, it is replaced by a
> > > > > newer dst entry. dst_dev_put() is called on old entry which assigns the
> > > > > blackhole netdev to 'dst->dev'. This netdev has an ifindex of 0 because
> > > > > it is not registered.
> > > > >
> > > > > <CPU0, t3> - After softirq finished executing, your route get request
> > > > > from t0 is resumed and the old dst entry is dumped to user space with
> > > > > ifindex of 0.
> > > > >
> > > > > I tested this on my system using your script to generate the route get
> > > > > requests. I pinned it to the same CPU forwarding packets through the
> > > > > nexthop. To constantly invalidate the cache I created another script
> > > > > that simply adds and removes IP addresses from an interface.
> > > > >
> > > > > If I stop the packet forwarding or the script that invalidates the
> > > > > cache, then I don't see any '*' answers to my route get requests.
> > > >
> > > > Thanks for the reply and analysis Ido, I tested with an additional script which
> > > > adds and deletes a route in a loop, as you also saw this increased the
> > > > frequency of blackhole route replies from the first script.
> > > >
> > > > Questions:
> > > >
> > > > 1. We saw this behavior occurring with TCP connections traversing our routers,
> > > > though I was able to reproduce it with only local route requests on our router.
> > > > Would you expect this same behavior for TCP traffic only in the kernel which
> > > > does not go to userspace?
> > >
> > > Yes, the problem is in the input path where received packets need to be
> > > forwarded.
> > >
> > > >
> > > > 2. These blackhole routes occur even though our main routing table is not
> > > > changing, however a separate route table managed by bird on the Linux router is
> > > > changing. Is this still expected behavior given that the ip-rules and main
> > > > route table used by these route requests are not changing?
> > >
> > > Yes, there is a per-netns counter that is incremented whenever cached
> > > dst entries need to be invalidated. Since it is per-netns it is
> > > incremented regardless of the routing table to which your insert the
> > > route.
> > >
> > > >
> > > > 3. We were previously rejecting these packets with an iptables rule which sent
> > > > an ICMP prohibited message to the sender, this caused TCP connections to break
> > > > with a EHOSTUNREACH, should we be silently dropping these packets instead?
> > > >
> > > > 4. If we should just be dropping these packets, why does the kernel not drop
> > > > them instead of letting them traverse the iptables rules?
> > >
> > > I actually believe the current behavior is a bug that needs to be fixed.
> > > See below.
> > >
> > > >
> > > > > BTW, the blackhole netdev was added in 5.3. I assume (didn't test) that
> > > > > with older kernel versions you'll see 'lo' instead of '*'.
> > > >
> > > > Yes indeed! Thanks for solving that mystery as well, our routers are running
> > > > 5.1, but we upgraded to 5.4-rc2 to determine whether the issue was still
> > > > present in the latest kernel.
> > >
> > > Do you remember when you started seeing this behavior? I think it
> > > started in 4.13 with commit ffe95ecf3a2e ("Merge branch
> > > 'net-remove-dst-garbage-collector-logic'").
> > >
> > > Let me add Wei to see if/how this can be fixed.
> > >
> > > Wei, in case you don't have the original mail with the description of
> > > the problem, it can be found here [1].
> > >
> > > I believe that the issue Jesse is experiencing is the following:
> > >
> > > <CPU A, t0> - Received packet A is forwarded and cached dst entry is
> > > taken from the nexthop ('nhc->nhc_rth_input'). Calls skb_dst_set()
> > >
> > > <t1> - Given Jesse has busy routers ("ingesting full BGP routing tables
> > > from multiple ISPs"), route is added / deleted and rt_cache_flush() is
> > > called
> > >
> > > <CPU B, t2> - Received packet B tries to use the same cached dst entry
> > > from t0, but rt_cache_valid() is no longer true and it is replaced in
> > > rt_cache_route() by the newer one. This calls dst_dev_put() on the
> > > original dst entry which assigns the blackhole netdev to 'dst->dev'
> > >
> > > <CPU A, t3> - dst_input(skb) is called on packet A and it is dropped due
> > > to 'dst->dev' being the blackhole netdev
> > >
> > > The following patch "fixes" the problem for me:
> > >
> > > diff --git a/net/ipv4/route.c b/net/ipv4/route.c
> > > index 42221a12bdda..1c67bdb80fd5 100644
> > > --- a/net/ipv4/route.c
> > > +++ b/net/ipv4/route.c
> > > @@ -1482,7 +1482,6 @@ static bool rt_cache_route(struct fib_nh_common *nhc, struct rtable *rt)
> > >         prev = cmpxchg(p, orig, rt);
> > >         if (prev == orig) {
> > >                 if (orig) {
> > > -                       dst_dev_put(&orig->dst);
> > >                         dst_release(&orig->dst);
> > >                 }
> > >         } else {
> > >
> > > But if this dst entry is cached in some inactive socket and the netdev
> > > on which it took a reference needs to be unregistered, then we can
> > > potentially wait forever. No?
> > >
> > Yes. That's exactly the reason we need to free the dev here.
> > Otherwise as you described, we will see "unregister_netdevice: waiting
> > for xxx to become free. Usage count = x" flushing the screen... Not
> > fun...
> >
> >
> > > I'm thinking that it can be fixed by making 'nhc_rth_input' per-CPU, in
> > > a similar fashion to what Eric did in commit d26b3a7c4b3b ("ipv4: percpu
> > > nh_rth_output cache").
> > >
> > Hmm... Yes... I would think a per-CPU input cache should work for the
> > case above.
> > Another idea is: instead of calling dst_dev_put() in rt_cache_route()
> > to switch out the dev, we call, rt_add_uncached_list() to add this
> > obsolete dst cache to the uncached list. And if the device gets
> > unregistered, rt_flush_dev() takes care of all dst entries in the
> > uncached list. I think that would work too.
> >
> > diff --git a/net/ipv4/route.c b/net/ipv4/route.c
> > index dc1f510a7c81..ee618d4234ce 100644
> > --- a/net/ipv4/route.c
> > +++ b/net/ipv4/route.c
> > @@ -1482,7 +1482,7 @@ static bool rt_cache_route(struct fib_nh_common
> > *nhc, struct rtable *rt)
> >         prev = cmpxchg(p, orig, rt);
> >         if (prev == orig) {
> >                 if (orig) {
> > -                       dst_dev_put(&orig->dst);
> > +                       rt_add_uncached_list(orig);
> >                         dst_release(&orig->dst);
> >                 }
> >         } else {
> >
> > + Martin for his idea and input.
> The above fix should work and a simple one liner for net.
> percpu may be a too big hammer for bug fix.
> It is only needed for input route?  A comment would be nice.
>
> While reading around, I am puzzling why a rt has to be recreated
> for the same route.  I could be missing something.
>
> I don't recall that is happening to ipv6 route even that tree-branch's
> fn_sernum has changed.
>
> It seems v4 sk has not stored the last lookup rt_genid.
> e.g. __sk_dst_check(sk, 0).  Everyone is sharing the rt->rt_genid
> to check for changes, so the rt must be re-created?
>
I think the reason rt has to be created is v4 code uses per net
rt_genid. So changes to any route in the namespace will invalidate all
other routes. (As David pointed out in his email.) However, v6 code
uses per fib_node fn_sernum, and has a way to only invalidate route
that are affected. (fib6_update_sernum_upto_root())
And v4 code not caching rt_genid seems to be separate issue, I think...


> >
> > > Two questions:
> > >
> > > 1. Do you agree with the above analysis?
> > > 2. Do you have a simpler/better solution in mind?
> > >
> > > Thanks
> > >
> > > [1] https://lore.kernel.org/netdev/CANSNSoVM1Uo106xfJtGpTyXNed8kOL4JiXqf3A1eZHBa7z3=yg@mail.gmail.com/T/#medece9445d617372b4842d44525ef0d3ba1ea083
