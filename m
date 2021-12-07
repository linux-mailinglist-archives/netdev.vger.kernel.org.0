Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EA4946C417
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 21:00:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240823AbhLGUEH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 15:04:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbhLGUEG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 15:04:06 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CE70C061574
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 12:00:36 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id v64so519815ybi.5
        for <netdev@vger.kernel.org>; Tue, 07 Dec 2021 12:00:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p8vmdZaeSUK3baymkLeLOriLyyJ2gahMFlwj7hbrpPw=;
        b=M/47etuBzu41E2g+48gbYDZfxdRQdXNoPUjrpt9ezIY0Fyt9DOqZp4wgwXRyJvK33S
         zapXmTDd8mLL7w1MiXi45mRhNaxSYby+o0NvSzF8zwXfdefkoH/sJqEqDA4Kyb2g0e7m
         EJtNgXFd4FHW9itVvI8kWlIYMQ0yRjiS3o9h41YDX2P/rqnbmpz4lrOOi0hYfTiKtumk
         zRqQ5k9JjOp3c2rSn0rQKRMetuL2qwEnxf2YUafeQZl1BjqKub1lFe7yt7/fAON3M7Xb
         VPYh7tQELrO8GsX0iMpQ2XEyUGFO3cGFSRD1o9M4daGY01/bJF68NjMyhgT7av3ezdf4
         NkFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p8vmdZaeSUK3baymkLeLOriLyyJ2gahMFlwj7hbrpPw=;
        b=iGqMCznFds1lGH27fyfCkpZZcYscX2ohieuMRJ0M3AxpvCqvyvgZz/X9BOJMkPbs23
         kgjdFoQEyP6MqLGW5bO/cT03krAlYNenyFLF/R0hmHt9fdi9JHz4D5yDjLtpzmQjh++o
         qmoMgedhTRrFnob2RZNeS/YeaRHFi3G4Xa0m+MicL/q2QsSSMy6pvpQuspdoxU2EGqxP
         QDOQI+oiYJ1hFHpkt77xsEOpono74HySoyacI5GzcNQg+C5o8F+Py+cLDpzJcPxZm/X4
         dg1pNGCn9EFWrhCi9p/u/yVS1hlnvQzJFV9abmrKYUM9BSBQYNanQltxuqRXYUgO2RRr
         +lUg==
X-Gm-Message-State: AOAM531PNYYTBlA6yKFhEtandSRsTTRlzQOd25yP/gWCRKT9ErySeiDZ
        8zoD7aojAHLqrLwhS+LSL4p85mAbpdGTIDlXPsyhog==
X-Google-Smtp-Source: ABdhPJw62D8MErfvK3Maoa3Bsr3X20ukrkxAZnOaHUekvz+VLpJB8LnbfNzGjGdwMdVsdzAis/UHyf7w7aAbbqDYoYM=
X-Received: by 2002:a25:3252:: with SMTP id y79mr51539656yby.5.1638907234763;
 Tue, 07 Dec 2021 12:00:34 -0800 (PST)
MIME-Version: 1.0
References: <20211205042217.982127-1-eric.dumazet@gmail.com>
 <Ya6bj2nplJ57JPml@lunn.ch> <CANn89iLPSianJ7TjzrpOw+a0PTgX_rpQmiNYbgxbn2K-PNouFg@mail.gmail.com>
 <Ya6kJhUtJt5c8tEk@lunn.ch> <CANn89iL4nVf+N1R=XV5VRSm4193CcU1N8XTNZzpBV9-mS3vxig@mail.gmail.com>
 <Ya6m1kIqVo52FkLV@lunn.ch> <CANn89i+b_6R820Om9ZjK-E5DyvnNUKXxYODpmt1B6UHM1q7eoQ@mail.gmail.com>
 <Ya6qewYtxoRn7BTo@lunn.ch> <CANn89iKbAr2aqiOLWuyYADW7b4fc3fy=DFRJ5dUG7F=BPiWKZQ@mail.gmail.com>
 <Ya+7YlIZgQ1Lz9SI@lunn.ch>
In-Reply-To: <Ya+7YlIZgQ1Lz9SI@lunn.ch>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 7 Dec 2021 12:00:23 -0800
Message-ID: <CANn89iKdh3SMT_OED10cBKek5OC6Y8ELPK1jOzmnu9tfBPYh1A@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 00/23] net: add preliminary netdev refcount tracking
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 7, 2021 at 11:52 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > I just sent the netns tracker series.
> >
> > I will shortly send the remainder of netdev tracking patches.
>
> Hi Eric
>
> Thanks for sending the full set of patches.
>
> I applied them on top of net-next. And i can still reproduce my
> issue. This is without any changes of mine, just net-next plus your
> two new patchsets.
>
> It is not easy to reproduce. I needed to start/stop the GNS3
> simulation around 8 times before i triggered it. I don't know how GNS3
> does it tairdown. It could be there are active daemons running in the
> name spaces as it removes the veth and tap devices? That might explain
> why some of the leaks seem to be from TCP connection setup attempts?
>
> Given i now have your full patchset, do you think these traces are
> valid? Are they pointing at real leaks?
>
> [ 1423.515246] unregister_netdevice: waiting for eth0 to become free. Usage count = 9
> [ 1423.515747] leaked reference.
> [ 1423.515755]  dst_alloc+0x7a/0x180
> [ 1423.515765]  ip6_dst_alloc+0x27/0x90
> [ 1423.515771]  ip6_pol_route+0x257/0x430
> [ 1423.515777]  ip6_pol_route_output+0x19/0x20
> [ 1423.515781]  fib6_rule_lookup+0x18b/0x270
> [ 1423.515789]  ip6_route_output_flags_noref+0xaa/0x110
> [ 1423.515793]  ip6_route_output_flags+0x32/0xa0
> [ 1423.515797]  ip6_dst_lookup_tail.constprop.0+0x181/0x240
> [ 1423.515803]  ip6_dst_lookup_flow+0x43/0xa0
> [ 1423.515808]  inet6_csk_route_socket+0x166/0x200
> [ 1423.515815]  inet6_csk_xmit+0x56/0x130
> [ 1423.515818]  __tcp_transmit_skb+0x53b/0xc30
> [ 1423.515825]  __tcp_send_ack.part.0+0xc6/0x1a0
> [ 1423.515829]  tcp_send_ack+0x1c/0x20
> [ 1423.515834]  __tcp_ack_snd_check+0x42/0x200
> [ 1423.515838]  tcp_rcv_established+0x27a/0x6f0
> [ 1423.515842] leaked reference.
> [ 1423.515843]  dst_alloc+0x7a/0x180
> [ 1423.515848]  ip6_dst_alloc+0x27/0x90
> [ 1423.515851]  ip6_pol_route+0x257/0x430
> [ 1423.515855]  ip6_pol_route_output+0x19/0x20
> [ 1423.515860]  fib6_rule_lookup+0x18b/0x270
> [ 1423.515865]  ip6_route_output_flags_noref+0xaa/0x110
> [ 1423.515869]  ip6_route_output_flags+0x32/0xa0
> [ 1423.515872]  seg6_output_core+0x28d/0x320
> [ 1423.515878]  seg6_output+0x33/0x120
> [ 1423.515884]  lwtunnel_output+0x72/0xc0
> [ 1423.515890]  ip6_local_out+0x61/0x70
> [ 1423.515894]  ip6_send_skb+0x23/0x70
> [ 1423.515898]  udp_v6_send_skb+0x207/0x460
> [ 1423.515905]  udpv6_sendmsg+0xb13/0xdb0
> [ 1423.515908]  inet6_sendmsg+0x65/0x70
> [ 1423.515916]  sock_sendmsg+0x48/0x70
> [ 1423.515920] leaked reference.
> [ 1423.515922]  dst_alloc+0x7a/0x180
> [ 1423.515926]  ip6_dst_alloc+0x27/0x90
> [ 1423.515929]  ip6_pol_route+0x257/0x430
> [ 1423.515933]  ip6_pol_route_output+0x19/0x20
> [ 1423.515938]  fib6_rule_lookup+0x18b/0x270
> [ 1423.515943]  ip6_route_output_flags_noref+0xaa/0x110
> [ 1423.515946]  ip6_route_output_flags+0x32/0xa0
> [ 1423.515949]  seg6_output_core+0x28d/0x320
> [ 1423.515955]  seg6_output+0x33/0x120
> [ 1423.515961]  lwtunnel_output+0x72/0xc0
> [ 1423.515965]  ip6_local_out+0x61/0x70
> [ 1423.515968]  ip6_send_skb+0x23/0x70
> [ 1423.515973]  udp_v6_send_skb+0x207/0x460
> [ 1423.515979]  udpv6_sendmsg+0xb13/0xdb0
> [ 1423.515982]  inet6_sendmsg+0x65/0x70
> [ 1423.515985]  sock_sendmsg+0x48/0x70
> [ 1423.515988] leaked reference.
> [ 1423.515990]  dst_alloc+0x7a/0x180
> [ 1423.515993]  ip6_dst_alloc+0x27/0x90
> [ 1423.515997]  ip6_pol_route+0x257/0x430
> [ 1423.516001]  ip6_pol_route_output+0x19/0x20
> [ 1423.516005]  fib6_rule_lookup+0x18b/0x270
> [ 1423.516010]  ip6_route_output_flags_noref+0xaa/0x110
> [ 1423.516014]  ip6_route_output_flags+0x32/0xa0
> [ 1423.516017]  seg6_output_core+0x28d/0x320
> [ 1423.516022]  seg6_output+0x33/0x120
> [ 1423.516028]  lwtunnel_output+0x72/0xc0
> [ 1423.516032]  ip6_local_out+0x61/0x70
> [ 1423.516036]  ip6_send_skb+0x23/0x70
> [ 1423.516040]  udp_v6_send_skb+0x207/0x460
> [ 1423.516046]  udpv6_sendmsg+0xb13/0xdb0
> [ 1423.516049]  inet6_sendmsg+0x65/0x70
> [ 1423.516052]  sock_sendmsg+0x48/0x70
> [ 1423.516055] leaked reference.
> [ 1423.516057]  dst_alloc+0x7a/0x180
> [ 1423.516061]  ip6_dst_alloc+0x27/0x90
> [ 1423.516064]  ip6_pol_route+0x257/0x430
> [ 1423.516068]  ip6_pol_route_output+0x19/0x20
> [ 1423.516072]  fib6_rule_lookup+0x18b/0x270
> [ 1423.516078]  ip6_route_output_flags_noref+0xaa/0x110
> [ 1423.516081]  ip6_route_output_flags+0x32/0xa0
> [ 1423.516084]  ip6_dst_lookup_tail.constprop.0+0x181/0x240
> [ 1423.516088]  ip6_dst_lookup_flow+0x43/0xa0
> [ 1423.516092]  inet6_csk_route_socket+0x166/0x200
> [ 1423.516099]  inet6_csk_xmit+0x56/0x130
> [ 1423.516102]  __tcp_transmit_skb+0x53b/0xc30
> [ 1423.516106]  tcp_write_xmit+0x3d4/0x13f0
> [ 1423.516110]  __tcp_push_pending_frames+0x37/0x100
> [ 1423.516114]  tcp_push+0xd2/0x100
> [ 1423.516122]  tcp_sendmsg_locked+0x2a7/0xdb0
> [ 1423.516128] leaked reference.
> [ 1423.516130]  dst_alloc+0x7a/0x180
> [ 1423.516134]  ip6_dst_alloc+0x27/0x90
> [ 1423.516137]  ip6_pol_route+0x257/0x430
> [ 1423.516141]  ip6_pol_route_output+0x19/0x20
> [ 1423.516146]  fib6_rule_lookup+0x18b/0x270
> [ 1423.516151]  ip6_route_output_flags_noref+0xaa/0x110
> [ 1423.516154]  ip6_route_output_flags+0x32/0xa0
> [ 1423.516157]  ip6_dst_lookup_tail.constprop.0+0xde/0x240
> [ 1423.516161]  ip6_dst_lookup_flow+0x43/0xa0
> [ 1423.516166]  tcp_v6_connect+0x2a7/0x670
> [ 1423.516171]  __inet_stream_connect+0xd1/0x3b0
> [ 1423.516175]  inet_stream_connect+0x3b/0x60
> [ 1423.516178]  __sys_connect_file+0x5f/0x70
> [ 1423.516182]  __sys_connect+0xa2/0xd0
> [ 1423.516186]  __x64_sys_connect+0x18/0x20
> [ 1423.516190]  do_syscall_64+0x3b/0xc0
> [ 1423.516197] leaked reference.
> [ 1423.516198]  fib6_nh_init+0x30d/0x9c0
> [ 1423.516203]  rtm_new_nexthop+0x68a/0x13a0
> [ 1423.516208]  rtnetlink_rcv_msg+0x14f/0x380
> [ 1423.516216]  netlink_rcv_skb+0x55/0x100
> [ 1423.516222]  rtnetlink_rcv+0x15/0x20
> [ 1423.516228]  netlink_unicast+0x230/0x340
> [ 1423.516232]  netlink_sendmsg+0x252/0x4b0
> [ 1423.516236]  sock_sendmsg+0x65/0x70
> [ 1423.516240]  ____sys_sendmsg+0x24e/0x290
> [ 1423.516243]  ___sys_sendmsg+0x81/0xc0
> [ 1423.516247]  __sys_sendmsg+0x62/0xb0
> [ 1423.516252]  __x64_sys_sendmsg+0x1d/0x20
> [ 1423.516256]  do_syscall_64+0x3b/0xc0
> [ 1423.516260]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [ 1423.516266] leaked reference.
> [ 1423.516267]  ipv6_add_dev+0x13e/0x4f0
> [ 1423.516273]  addrconf_notify+0x2ca/0x950
> [ 1423.516280]  raw_notifier_call_chain+0x49/0x60
> [ 1423.516288]  call_netdevice_notifiers_info+0x50/0x90
> [ 1423.516293]  __dev_change_net_namespace+0x30d/0x6c0
> [ 1423.516299]  do_setlink+0xdc/0x10b0
> [ 1423.516306]  __rtnl_newlink+0x608/0xa10
> [ 1423.516312]  rtnl_newlink+0x49/0x70
> [ 1423.516318]  rtnetlink_rcv_msg+0x14f/0x380
> [ 1423.516323]  netlink_rcv_skb+0x55/0x100
> [ 1423.516328]  rtnetlink_rcv+0x15/0x20
> [ 1423.516333]  netlink_unicast+0x230/0x340
> [ 1423.516337]  netlink_sendmsg+0x252/0x4b0
> [ 1423.516345]  sock_sendmsg+0x65/0x70
> [ 1423.516348]  ____sys_sendmsg+0x24e/0x290
> [ 1423.516352]  ___sys_sendmsg+0x81/0xc0

Thanks for the report.

This all involves IPv6, and this might point to something I hinted
about last week.

Can you try :

Note that I am about to travel, and will be unable to respond to
emails for about 20 hours.
Thanks !

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 8d834f901b48..043d270b65d6 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -163,9 +163,6 @@ static void rt6_uncached_list_flush_dev(struct net
*net, struct net_device *dev)
        struct net_device *loopback_dev = net->loopback_dev;
        int cpu;

-       if (dev == loopback_dev)
-               return;
-
        for_each_possible_cpu(cpu) {
                struct uncached_list *ul = per_cpu_ptr(&rt6_uncached_list, cpu);
                struct rt6_info *rt;
@@ -175,12 +172,13 @@ static void rt6_uncached_list_flush_dev(struct
net *net, struct net_device *dev)
                        struct inet6_dev *rt_idev = rt->rt6i_idev;
                        struct net_device *rt_dev = rt->dst.dev;

-                       if (rt_idev->dev == dev) {
+                       if (rt_idev->dev == dev && dev != loopback_dev) {
                                rt->rt6i_idev = in6_dev_get(loopback_dev);
                                in6_dev_put(rt_idev);
                        }

                        if (rt_dev == dev) {
+                               WARN_ON_ONCE(dev == loopback_dev);
                                rt->dst.dev = blackhole_netdev;
                                dev_replace_track(rt_dev, blackhole_netdev,
                                                  &rt->dst.dev_tracker,
