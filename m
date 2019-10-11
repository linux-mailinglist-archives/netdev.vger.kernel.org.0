Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62126D449F
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 17:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728140AbfJKPma (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 11:42:30 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:45527 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726521AbfJKPm3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 11:42:29 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id B841721391;
        Fri, 11 Oct 2019 11:42:28 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 11 Oct 2019 11:42:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=JmBCnY
        ZbCaZgiYppXViAaVqhV8l/6mNGGak957ySjZo=; b=na9Zif5U0MHh4vp23OCYBz
        2Fyq8yt0OmH7CF92d3FfejV4CNkHRghAwrNuyfjLhyVJU7JGynfgWvWRdYDdsNW7
        vtAA3UcgIj2IHoaV6TlGLSu4QbFgyIKTNa1D97TdHIScF+EYVbyxkh2jVmzFBsQn
        XFZ+iO7anW8z//bpwAF8V+anUkxyiQqQaJMbtTzCyZVdWrIkKobN8XhzqhhsS6wZ
        bjAw21jZQoa/M2ZMOE8upFxwfG5P4PaTAYTCbbzJ3WXECbWRWh0XrGbI7tPwYZLx
        jQtEsHuouS7p68sMJiZnf8h5L4qlLzX+XG3wu3GmaA/NaHsnox83AGRDy8U55c+w
        ==
X-ME-Sender: <xms:5KKgXfVuUdBojjhKVxsUfxHW1qTbl5P3qI-LQAZBvAB9aGGyK1U9_Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrieehgdelgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucffohhmrghinh
    epkhgvrhhnvghlrdhorhhgpdhfohhrvghvvghrrdhnohenucfkphepjeelrddujeejrdef
    kedrvddtheenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthh
    drohhrghenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:5KKgXRl6IRFASBN5KAZG5ydRGJugTeQyl0g_VRz4lQgwYGPkK1p3Ow>
    <xmx:5KKgXSABPsSvq9jz0454G0YdG24ZjIxXVlfqmVr6aryDiuGIKZ1IGw>
    <xmx:5KKgXYg4oe1M6m07-MiT54R4ZrscIwvRTaKHPis05aoHf0L769lmHg>
    <xmx:5KKgXeStce2NPUIls1hFbYSRnbuicm_xN5HUMyfxkzGpfbaKLQDalA>
Received: from localhost (bzq-79-177-38-205.red.bezeqint.net [79.177.38.205])
        by mail.messagingengine.com (Postfix) with ESMTPA id EED9DD6005F;
        Fri, 11 Oct 2019 11:42:27 -0400 (EDT)
Date:   Fri, 11 Oct 2019 18:42:24 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jesse Hathaway <jesse@mbuki-mvuki.org>, weiwan@google.com
Cc:     netdev@vger.kernel.org
Subject: Re: Race condition in route lookup
Message-ID: <20191011154224.GA23486@splinter>
References: <CANSNSoV1M9stB7CnUcEhsz3FHi4NV_yrBtpYsZ205+rqnvMbvA@mail.gmail.com>
 <20191010083102.GA1336@splinter>
 <CANSNSoVM1Uo106xfJtGpTyXNed8kOL4JiXqf3A1eZHBa7z3=yg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANSNSoVM1Uo106xfJtGpTyXNed8kOL4JiXqf3A1eZHBa7z3=yg@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 11, 2019 at 09:36:51AM -0500, Jesse Hathaway wrote:
> On Thu, Oct 10, 2019 at 3:31 AM Ido Schimmel <idosch@idosch.org> wrote:
> > I think it's working as expected. Here is my theory:
> >
> > If CPU0 is executing both the route get request and forwarding packets
> > through the directly connected interface, then the following can happen:
> >
> > <CPU0, t0> - In process context, per-CPU dst entry cached in the nexthop
> > is found. Not yet dumped to user space
> >
> > <Any CPU, t1> - Routes are added / removed, therefore invalidating the
> > cache by bumping 'net->ipv4.rt_genid'
> >
> > <CPU0, t2> - In softirq, packet is forwarded through the nexthop. The
> > cached dst entry is found to be invalid. Therefore, it is replaced by a
> > newer dst entry. dst_dev_put() is called on old entry which assigns the
> > blackhole netdev to 'dst->dev'. This netdev has an ifindex of 0 because
> > it is not registered.
> >
> > <CPU0, t3> - After softirq finished executing, your route get request
> > from t0 is resumed and the old dst entry is dumped to user space with
> > ifindex of 0.
> >
> > I tested this on my system using your script to generate the route get
> > requests. I pinned it to the same CPU forwarding packets through the
> > nexthop. To constantly invalidate the cache I created another script
> > that simply adds and removes IP addresses from an interface.
> >
> > If I stop the packet forwarding or the script that invalidates the
> > cache, then I don't see any '*' answers to my route get requests.
> 
> Thanks for the reply and analysis Ido, I tested with an additional script which
> adds and deletes a route in a loop, as you also saw this increased the
> frequency of blackhole route replies from the first script.
> 
> Questions:
> 
> 1. We saw this behavior occurring with TCP connections traversing our routers,
> though I was able to reproduce it with only local route requests on our router.
> Would you expect this same behavior for TCP traffic only in the kernel which
> does not go to userspace?

Yes, the problem is in the input path where received packets need to be
forwarded.

> 
> 2. These blackhole routes occur even though our main routing table is not
> changing, however a separate route table managed by bird on the Linux router is
> changing. Is this still expected behavior given that the ip-rules and main
> route table used by these route requests are not changing?

Yes, there is a per-netns counter that is incremented whenever cached
dst entries need to be invalidated. Since it is per-netns it is
incremented regardless of the routing table to which your insert the
route.

> 
> 3. We were previously rejecting these packets with an iptables rule which sent
> an ICMP prohibited message to the sender, this caused TCP connections to break
> with a EHOSTUNREACH, should we be silently dropping these packets instead?
> 
> 4. If we should just be dropping these packets, why does the kernel not drop
> them instead of letting them traverse the iptables rules?

I actually believe the current behavior is a bug that needs to be fixed.
See below.

> 
> > BTW, the blackhole netdev was added in 5.3. I assume (didn't test) that
> > with older kernel versions you'll see 'lo' instead of '*'.
> 
> Yes indeed! Thanks for solving that mystery as well, our routers are running
> 5.1, but we upgraded to 5.4-rc2 to determine whether the issue was still
> present in the latest kernel.

Do you remember when you started seeing this behavior? I think it
started in 4.13 with commit ffe95ecf3a2e ("Merge branch
'net-remove-dst-garbage-collector-logic'").

Let me add Wei to see if/how this can be fixed.

Wei, in case you don't have the original mail with the description of
the problem, it can be found here [1].

I believe that the issue Jesse is experiencing is the following:

<CPU A, t0> - Received packet A is forwarded and cached dst entry is
taken from the nexthop ('nhc->nhc_rth_input'). Calls skb_dst_set()

<t1> - Given Jesse has busy routers ("ingesting full BGP routing tables
from multiple ISPs"), route is added / deleted and rt_cache_flush() is
called

<CPU B, t2> - Received packet B tries to use the same cached dst entry
from t0, but rt_cache_valid() is no longer true and it is replaced in
rt_cache_route() by the newer one. This calls dst_dev_put() on the
original dst entry which assigns the blackhole netdev to 'dst->dev'

<CPU A, t3> - dst_input(skb) is called on packet A and it is dropped due
to 'dst->dev' being the blackhole netdev

The following patch "fixes" the problem for me:

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 42221a12bdda..1c67bdb80fd5 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1482,7 +1482,6 @@ static bool rt_cache_route(struct fib_nh_common *nhc, struct rtable *rt)
        prev = cmpxchg(p, orig, rt);
        if (prev == orig) {
                if (orig) {
-                       dst_dev_put(&orig->dst);
                        dst_release(&orig->dst);
                }
        } else {

But if this dst entry is cached in some inactive socket and the netdev
on which it took a reference needs to be unregistered, then we can
potentially wait forever. No?

I'm thinking that it can be fixed by making 'nhc_rth_input' per-CPU, in
a similar fashion to what Eric did in commit d26b3a7c4b3b ("ipv4: percpu
nh_rth_output cache").

Two questions:

1. Do you agree with the above analysis?
2. Do you have a simpler/better solution in mind?

Thanks

[1] https://lore.kernel.org/netdev/CANSNSoVM1Uo106xfJtGpTyXNed8kOL4JiXqf3A1eZHBa7z3=yg@mail.gmail.com/T/#medece9445d617372b4842d44525ef0d3ba1ea083
