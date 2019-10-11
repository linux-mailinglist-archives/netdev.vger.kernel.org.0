Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D54CD47FB
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 20:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728777AbfJKSw5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 14:52:57 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:39853 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728666AbfJKSw5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 14:52:57 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 31DED21165;
        Fri, 11 Oct 2019 14:52:54 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 11 Oct 2019 14:52:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=2636eo
        rwhH5wQVcS+k8Wsg/xtyYD31ImH5TYYz+lL2k=; b=LcObY+RbBx1m/evgsPy2wy
        l/9wx2/DYCOw503WSP6tYXaR+YPyz0PuQFh6OGRFADVRSY907rGD4z1n2C0sd6I3
        ksUjRxCkC/EmESo0c+p0EeypSbwHvsVzrxNFm6dzqx/dTMLtYy+UinOJogo7jDc/
        ouvUQ/wCJlDzMplWx67ptAH8jIBnarvFAhNNMfepquA2FLOXQuFPM1ByBL3qLyrF
        W3T+GojEksO66LfLUoJSUcAMV+GlidoQqUAWn187WtjXAkgrQ/yG0Vf9Cuzk5ZCP
        cHrNjhEAyqOg6tN2Ji2IYk4SZt0JnXtyT3uvPkedS8NdTjRhnTAbqdthNM42iS4g
        ==
X-ME-Sender: <xms:hc-gXQeOHwdGKJBCldemdwfDaVgLlibyO1U_tnLM4KTcutbWjtvYbQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrieehgddufedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuffhomhgrih
    hnpehkvghrnhgvlhdrohhrghdpfhhorhgvvhgvrhdrnhhonecukfhppeejledrudejjedr
    feekrddvtdehnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstg
    hhrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:hc-gXeivKCSw_bOnH44LBZX54VUTrhQ0hSUjmd3-mrP96dvyVd0CkA>
    <xmx:hc-gXURfPFxWwsI5IMMFmdh6mrGt5ycvsbgaE-okL3s3CHwHiJds0A>
    <xmx:hc-gXXxHjyYLvA6zk2Yu5Iy96488yK9BqeSc6WyLlJZbfgUdu5CwLQ>
    <xmx:hs-gXaP2r_paOnTO2D2vslQo9-1aLLLNFe1EoRcLuEnzG7OYHEZ9OA>
Received: from localhost (bzq-79-177-38-205.red.bezeqint.net [79.177.38.205])
        by mail.messagingengine.com (Postfix) with ESMTPA id 29D24D60063;
        Fri, 11 Oct 2019 14:52:52 -0400 (EDT)
Date:   Fri, 11 Oct 2019 21:52:50 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Wei Wang <weiwan@google.com>, jesse@mbuki-mvuki.org
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: Race condition in route lookup
Message-ID: <20191011185250.GA31385@splinter>
References: <CANSNSoV1M9stB7CnUcEhsz3FHi4NV_yrBtpYsZ205+rqnvMbvA@mail.gmail.com>
 <20191010083102.GA1336@splinter>
 <CANSNSoVM1Uo106xfJtGpTyXNed8kOL4JiXqf3A1eZHBa7z3=yg@mail.gmail.com>
 <20191011154224.GA23486@splinter>
 <CAEA6p_AFKwx_oLqNOjMw=oXcAX4ftJvEQWLo0aWCh=4Hs=QjVw@mail.gmail.com>
 <20191011181737.GA30138@splinter>
 <20191011182508.GA30970@splinter>
 <CAEA6p_CXZyUQf_DKhs7nQ5D0C7j1kM7bzgcyS2=D_k_U7Czu8w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEA6p_CXZyUQf_DKhs7nQ5D0C7j1kM7bzgcyS2=D_k_U7Czu8w@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 11, 2019 at 11:47:12AM -0700, Wei Wang wrote:
> On Fri, Oct 11, 2019 at 11:25 AM Ido Schimmel <idosch@idosch.org> wrote:
> >
> > On Fri, Oct 11, 2019 at 09:17:42PM +0300, Ido Schimmel wrote:
> > > On Fri, Oct 11, 2019 at 10:54:13AM -0700, Wei Wang wrote:
> > > > On Fri, Oct 11, 2019 at 8:42 AM Ido Schimmel <idosch@idosch.org> wrote:
> > > > >
> > > > > On Fri, Oct 11, 2019 at 09:36:51AM -0500, Jesse Hathaway wrote:
> > > > > > On Thu, Oct 10, 2019 at 3:31 AM Ido Schimmel <idosch@idosch.org> wrote:
> > > > > > > I think it's working as expected. Here is my theory:
> > > > > > >
> > > > > > > If CPU0 is executing both the route get request and forwarding packets
> > > > > > > through the directly connected interface, then the following can happen:
> > > > > > >
> > > > > > > <CPU0, t0> - In process context, per-CPU dst entry cached in the nexthop
> > > > > > > is found. Not yet dumped to user space
> > > > > > >
> > > > > > > <Any CPU, t1> - Routes are added / removed, therefore invalidating the
> > > > > > > cache by bumping 'net->ipv4.rt_genid'
> > > > > > >
> > > > > > > <CPU0, t2> - In softirq, packet is forwarded through the nexthop. The
> > > > > > > cached dst entry is found to be invalid. Therefore, it is replaced by a
> > > > > > > newer dst entry. dst_dev_put() is called on old entry which assigns the
> > > > > > > blackhole netdev to 'dst->dev'. This netdev has an ifindex of 0 because
> > > > > > > it is not registered.
> > > > > > >
> > > > > > > <CPU0, t3> - After softirq finished executing, your route get request
> > > > > > > from t0 is resumed and the old dst entry is dumped to user space with
> > > > > > > ifindex of 0.
> > > > > > >
> > > > > > > I tested this on my system using your script to generate the route get
> > > > > > > requests. I pinned it to the same CPU forwarding packets through the
> > > > > > > nexthop. To constantly invalidate the cache I created another script
> > > > > > > that simply adds and removes IP addresses from an interface.
> > > > > > >
> > > > > > > If I stop the packet forwarding or the script that invalidates the
> > > > > > > cache, then I don't see any '*' answers to my route get requests.
> > > > > >
> > > > > > Thanks for the reply and analysis Ido, I tested with an additional script which
> > > > > > adds and deletes a route in a loop, as you also saw this increased the
> > > > > > frequency of blackhole route replies from the first script.
> > > > > >
> > > > > > Questions:
> > > > > >
> > > > > > 1. We saw this behavior occurring with TCP connections traversing our routers,
> > > > > > though I was able to reproduce it with only local route requests on our router.
> > > > > > Would you expect this same behavior for TCP traffic only in the kernel which
> > > > > > does not go to userspace?
> > > > >
> > > > > Yes, the problem is in the input path where received packets need to be
> > > > > forwarded.
> > > > >
> > > > > >
> > > > > > 2. These blackhole routes occur even though our main routing table is not
> > > > > > changing, however a separate route table managed by bird on the Linux router is
> > > > > > changing. Is this still expected behavior given that the ip-rules and main
> > > > > > route table used by these route requests are not changing?
> > > > >
> > > > > Yes, there is a per-netns counter that is incremented whenever cached
> > > > > dst entries need to be invalidated. Since it is per-netns it is
> > > > > incremented regardless of the routing table to which your insert the
> > > > > route.
> > > > >
> > > > > >
> > > > > > 3. We were previously rejecting these packets with an iptables rule which sent
> > > > > > an ICMP prohibited message to the sender, this caused TCP connections to break
> > > > > > with a EHOSTUNREACH, should we be silently dropping these packets instead?
> > > > > >
> > > > > > 4. If we should just be dropping these packets, why does the kernel not drop
> > > > > > them instead of letting them traverse the iptables rules?
> > > > >
> > > > > I actually believe the current behavior is a bug that needs to be fixed.
> > > > > See below.
> > > > >
> > > > > >
> > > > > > > BTW, the blackhole netdev was added in 5.3. I assume (didn't test) that
> > > > > > > with older kernel versions you'll see 'lo' instead of '*'.
> > > > > >
> > > > > > Yes indeed! Thanks for solving that mystery as well, our routers are running
> > > > > > 5.1, but we upgraded to 5.4-rc2 to determine whether the issue was still
> > > > > > present in the latest kernel.
> > > > >
> > > > > Do you remember when you started seeing this behavior? I think it
> > > > > started in 4.13 with commit ffe95ecf3a2e ("Merge branch
> > > > > 'net-remove-dst-garbage-collector-logic'").
> > > > >
> > > > > Let me add Wei to see if/how this can be fixed.
> > > > >
> > > > > Wei, in case you don't have the original mail with the description of
> > > > > the problem, it can be found here [1].
> > > > >
> > > > > I believe that the issue Jesse is experiencing is the following:
> > > > >
> > > > > <CPU A, t0> - Received packet A is forwarded and cached dst entry is
> > > > > taken from the nexthop ('nhc->nhc_rth_input'). Calls skb_dst_set()
> > > > >
> > > > > <t1> - Given Jesse has busy routers ("ingesting full BGP routing tables
> > > > > from multiple ISPs"), route is added / deleted and rt_cache_flush() is
> > > > > called
> > > > >
> > > > > <CPU B, t2> - Received packet B tries to use the same cached dst entry
> > > > > from t0, but rt_cache_valid() is no longer true and it is replaced in
> > > > > rt_cache_route() by the newer one. This calls dst_dev_put() on the
> > > > > original dst entry which assigns the blackhole netdev to 'dst->dev'
> > > > >
> > > > > <CPU A, t3> - dst_input(skb) is called on packet A and it is dropped due
> > > > > to 'dst->dev' being the blackhole netdev
> > > > >
> > > > > The following patch "fixes" the problem for me:
> > > > >
> > > > > diff --git a/net/ipv4/route.c b/net/ipv4/route.c
> > > > > index 42221a12bdda..1c67bdb80fd5 100644
> > > > > --- a/net/ipv4/route.c
> > > > > +++ b/net/ipv4/route.c
> > > > > @@ -1482,7 +1482,6 @@ static bool rt_cache_route(struct fib_nh_common *nhc, struct rtable *rt)
> > > > >         prev = cmpxchg(p, orig, rt);
> > > > >         if (prev == orig) {
> > > > >                 if (orig) {
> > > > > -                       dst_dev_put(&orig->dst);
> > > > >                         dst_release(&orig->dst);
> > > > >                 }
> > > > >         } else {
> > > > >
> > > > > But if this dst entry is cached in some inactive socket and the netdev
> > > > > on which it took a reference needs to be unregistered, then we can
> > > > > potentially wait forever. No?
> > > > >
> > > > Yes. That's exactly the reason we need to free the dev here.
> > > > Otherwise as you described, we will see "unregister_netdevice: waiting
> > > > for xxx to become free. Usage count = x" flushing the screen... Not
> > > > fun...
> > > >
> > > >
> > > > > I'm thinking that it can be fixed by making 'nhc_rth_input' per-CPU, in
> > > > > a similar fashion to what Eric did in commit d26b3a7c4b3b ("ipv4: percpu
> > > > > nh_rth_output cache").
> > > > >
> > > > Hmm... Yes... I would think a per-CPU input cache should work for the
> > > > case above.
> > > > Another idea is: instead of calling dst_dev_put() in rt_cache_route()
> > > > to switch out the dev, we call, rt_add_uncached_list() to add this
> > > > obsolete dst cache to the uncached list. And if the device gets
> > > > unregistered, rt_flush_dev() takes care of all dst entries in the
> > > > uncached list. I think that would work too.
> > >
> > > It crossed my mind as well, but if the device is not unregistered, then
> > > I believe we can eventually consume all the memory and kill the machine?
> >
> > Ha, sorry no. I think this will actually work.
> >
> When every user releases the dst, it will be removed from the uncached
> list. 

Yea, that's the part I missed in my thinking. :(

> But potentially, if any user of the dst is inactive, the dst will be
> in the cached list for a while...

I think this is fine.

Jesse, can you please test Wei's patch?

Thanks

> 
> > >
> > > >
> > > > diff --git a/net/ipv4/route.c b/net/ipv4/route.c
> > > > index dc1f510a7c81..ee618d4234ce 100644
> > > > --- a/net/ipv4/route.c
> > > > +++ b/net/ipv4/route.c
> > > > @@ -1482,7 +1482,7 @@ static bool rt_cache_route(struct fib_nh_common
> > > > *nhc, struct rtable *rt)
> > > >         prev = cmpxchg(p, orig, rt);
> > > >         if (prev == orig) {
> > > >                 if (orig) {
> > > > -                       dst_dev_put(&orig->dst);
> > > > +                       rt_add_uncached_list(orig);
> > > >                         dst_release(&orig->dst);
> > > >                 }
> > > >         } else {
> > > >
> > > > + Martin for his idea and input.
> > > >
> > > > > Two questions:
> > > > >
> > > > > 1. Do you agree with the above analysis?
> > > > > 2. Do you have a simpler/better solution in mind?
> > > > >
> > > > > Thanks
> > > > >
> > > > > [1] https://lore.kernel.org/netdev/CANSNSoVM1Uo106xfJtGpTyXNed8kOL4JiXqf3A1eZHBa7z3=yg@mail.gmail.com/T/#medece9445d617372b4842d44525ef0d3ba1ea083
