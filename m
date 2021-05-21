Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C38B38CAA7
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 18:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235360AbhEUQN0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 12:13:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236522AbhEUQN0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 12:13:26 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11ADFC061574
        for <netdev@vger.kernel.org>; Fri, 21 May 2021 09:12:03 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id ne24-20020a17090b3758b029015f2dafecb0so6247032pjb.4
        for <netdev@vger.kernel.org>; Fri, 21 May 2021 09:12:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Qg39hQlAq19vHdFcBq8NvG4CDwowpREHnm0puW3V86o=;
        b=Q5CpW09NM55Tw8ZKSTDVkJNvGwVLRnAABW9YEi/6wuqd96E5RC09qXBnubLLY5hEl1
         raZAcDki0jsPfNH89oQ+spcxEYQpB2Y4uSLRiN+BDnMsxA8wAIXU6gBWEkrMxGifOS05
         s6KLpDm2M0dnXb595/QBZSCNFz/Hpr7X6HH/CWOTHelm6a9PFzUhyRbQEyJxVeBsnxr1
         93pcVStaL/bQ6gAyOInZlXEb8QWwpQoUD11Jac/VD7lkxRXJzcuKv46pHww83Gy9KD1G
         dTaHVPl9dARejXFBg0prVP8nIjQRCuFmYdBcbV2tI72CFiXzcN9R3aYQqW7DMcrof67u
         3m/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Qg39hQlAq19vHdFcBq8NvG4CDwowpREHnm0puW3V86o=;
        b=mrtc+inj5UYVyBfClHJ9Gf1n5LKqgyXMVknTW2bIzdjoA1J6KAy5ktNcqV5NZilajz
         S9DgnWIx2nBncipMR7tjkkN37a8nB41bSLriky/jifWUOCUVptFKlCbCikFB2FnURvJ2
         Q/D+pjd3PP7mIF/iZ/mab07M/vEe2+s6dMmia/nW8EaJFdvKGRV+U185Qc5p1Micxbcc
         wmNrLqmzA+dDfCcldN0emI5Vs8fKjvmADl63Jr0FT/wW6lgReijBk4mwdBHfflNdE32t
         rqwmTxOPgurdeaXKwUoE28P6Pe9StjZEreSpNFzpHMqbkT6jAk4U1JpYNN/PWmKHv1KC
         9WUw==
X-Gm-Message-State: AOAM531hasiomqF4HNk5G/ta7Mmu0dD/Sdt2a13M9LDxXTV91tn5K+tE
        whbbcoTaTfYmQRC5+sX4O5dyrhLSXWOJpw==
X-Google-Smtp-Source: ABdhPJwp2cC5XwDDe7OPf5NUNTcrFkUqmjMo59z+IDV7yaz1EAk8MkkpLX6rRnoF9gCH2vy9erEIkA==
X-Received: by 2002:a17:90b:1003:: with SMTP id gm3mr11553411pjb.126.1621613522451;
        Fri, 21 May 2021 09:12:02 -0700 (PDT)
Received: from [192.168.0.4] ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id g13sm4686521pfr.75.2021.05.21.09.11.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 May 2021 09:12:01 -0700 (PDT)
Subject: Re: [PATCH v2 net] mld: fix panic in mld_newpack()
To:     Eric Dumazet <eric.dumazet@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, dsahern@kernel.org, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, xiyou.wangcong@gmail.com
References: <20210516144442.4838-1-ap420073@gmail.com>
 <00922799-f302-b17b-2f2c-032c4a562315@gmail.com>
From:   Taehee Yoo <ap420073@gmail.com>
Message-ID: <905ec725-3d38-e110-e1ef-1300da80c2de@gmail.com>
Date:   Sat, 22 May 2021 01:11:57 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <00922799-f302-b17b-2f2c-032c4a562315@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/21/21 2:20 AM, Eric Dumazet wrote:

Hi Eric,
Thank you for your review!

 >
 >
 > On 5/16/21 4:44 PM, Taehee Yoo wrote:
 >> mld_newpack() doesn't allow to allocate high order page,
 >> only order-0 allocation is allowed.
 >> If headroom size is too large, a kernel panic could occur in skb_put().
 >>
 >> Test commands:
 >>      ip netns del A
 >>      ip netns del B
 >>      ip netns add A
 >>      ip netns add B
 >>      ip link add veth0 type veth peer name veth1
 >>      ip link set veth0 netns A
 >>      ip link set veth1 netns B
 >>
 >>      ip netns exec A ip link set lo up
 >>      ip netns exec A ip link set veth0 up
 >>      ip netns exec A ip -6 a a 2001:db8:0::1/64 dev veth0
 >>      ip netns exec B ip link set lo up
 >>      ip netns exec B ip link set veth1 up
 >>      ip netns exec B ip -6 a a 2001:db8:0::2/64 dev veth1
 >>      for i in {1..99}
 >>      do
 >>          let A=$i-1
 >>          ip netns exec A ip link add ip6gre$i type ip6gre \
 >> 	local 2001:db8:$A::1 remote 2001:db8:$A::2 encaplimit 100
 >>          ip netns exec A ip -6 a a 2001:db8:$i::1/64 dev ip6gre$i
 >>          ip netns exec A ip link set ip6gre$i up
 >>
 >>          ip netns exec B ip link add ip6gre$i type ip6gre \
 >> 	local 2001:db8:$A::2 remote 2001:db8:$A::1 encaplimit 100
 >>          ip netns exec B ip -6 a a 2001:db8:$i::2/64 dev ip6gre$i
 >>          ip netns exec B ip link set ip6gre$i up
 >>      done
 >>
 >> Splat looks like:
 >> kernel BUG at net/core/skbuff.c:110!
 >> invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC KASAN PTI
 >> CPU: 0 PID: 7 Comm: kworker/0:1 Not tainted 5.12.0+ #891
 >> Workqueue: ipv6_addrconf addrconf_dad_work
 >> RIP: 0010:skb_panic+0x15d/0x15f
 >> Code: 92 fe 4c 8b 4c 24 10 53 8b 4d 70 45 89 e0 48 c7 c7 00 ae 79 83
 >> 41 57 41 56 41 55 48 8b 54 24 a6 26 f9 ff <0f> 0b 48 8b 6c 24 20 89
 >> 34 24 e8 4a 4e 92 fe 8b 34 24 48 c7 c1 20
 >> RSP: 0018:ffff88810091f820 EFLAGS: 00010282
 >> RAX: 0000000000000089 RBX: ffff8881086e9000 RCX: 0000000000000000
 >> RDX: 0000000000000089 RSI: 0000000000000008 RDI: ffffed1020123efb
 >> RBP: ffff888005f6eac0 R08: ffffed1022fc0031 R09: ffffed1022fc0031
 >> R10: ffff888117e00187 R11: ffffed1022fc0030 R12: 0000000000000028
 >> R13: ffff888008284eb0 R14: 0000000000000ed8 R15: 0000000000000ec0
 >> FS:  0000000000000000(0000) GS:ffff888117c00000(0000)
 >> knlGS:0000000000000000
 >> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 >> CR2: 00007f8b801c5640 CR3: 0000000033c2c006 CR4: 00000000003706f0
 >> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 >> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 >> Call Trace:
 >>   ? ip6_mc_hdr.isra.26.constprop.46+0x12a/0x600
 >>   ? ip6_mc_hdr.isra.26.constprop.46+0x12a/0x600
 >>   skb_put.cold.104+0x22/0x22
 >>   ip6_mc_hdr.isra.26.constprop.46+0x12a/0x600
 >>   ? rcu_read_lock_sched_held+0x91/0xc0
 >>   mld_newpack+0x398/0x8f0
 >>   ? ip6_mc_hdr.isra.26.constprop.46+0x600/0x600
 >>   ? lock_contended+0xc40/0xc40
 >>   add_grhead.isra.33+0x280/0x380
 >>   add_grec+0x5ca/0xff0
 >>   ? mld_sendpack+0xf40/0xf40
 >>   ? lock_downgrade+0x690/0x690
 >>   mld_send_initial_cr.part.34+0xb9/0x180
 >>   ipv6_mc_dad_complete+0x15d/0x1b0
 >>   addrconf_dad_completed+0x8d2/0xbb0
 >>   ? lock_downgrade+0x690/0x690
 >>   ? addrconf_rs_timer+0x660/0x660
 >>   ? addrconf_dad_work+0x73c/0x10e0
 >>   addrconf_dad_work+0x73c/0x10e0
 >>
 >> Allowing high order page allocation could fix this problem.
 >>
 >> Fixes: 72e09ad107e7 ("ipv6: avoid high order allocations")
 >> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
 >> ---
 >>
 >> v1 -> v2:
 >>   - Wait for mld-sleepable patchset to be merged.
 >>
 >>   net/ipv6/mcast.c | 3 ---
 >>   1 file changed, 3 deletions(-)
 >>
 >> diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
 >> index 0d59efb6b49e..d36ef9d25e73 100644
 >> --- a/net/ipv6/mcast.c
 >> +++ b/net/ipv6/mcast.c
 >> @@ -1745,10 +1745,7 @@ static struct sk_buff *mld_newpack(struct 
inet6_dev *idev, unsigned int mtu)
 >>   		     IPV6_TLV_PADN, 0 };
 >>
 >>   	/* we assume size > sizeof(ra) here */
 >> -	/* limit our allocations to order-0 page */
 >> -	size = min_t(int, size, SKB_MAX_ORDER(0, 0));
 >>   	skb = sock_alloc_send_skb(sk, size, 1, &err);
 >> -
 >>   	if (!skb)
 >>   		return NULL;
 >>
 >>
 >
 > Sorry for being late to the party.
 >
 > This is forcing high-order allocations for devices with big mtu,
 > even for non pathological cases.
 >
 > (lo has MTU 65535, so we attempt order-5 allocations :/ )
 >
 > I think this could be smarter [1], addressing both the common case
 > and syzbot-like abuses.
 >
 > XMIT_RECURSION_LIMIT being 8, I doubt the repro makes any sense in 
real world.
 > Maybe it is time to limit netdev chains to 8 as well.
 >
 > Also, veth MTU being 1500, I fail to understand how your script
 > was crashing your host.

The root problem is that dev->need_headroom can be abnormally big.
Because when the tunneling interface begins to send a packet, it 
recalculates dev->needed_headroom.

int ip6_tnl_xmit(struct sk_buff *skb, struct net_device *dev, __u8 dsfield,
                  struct flowi6 *fl6, int encap_limit, __u32 *pmtu,
                  __u8 proto)
{
...
         max_headroom = LL_RESERVED_SPACE(dst->dev) + sizeof(struct ipv6hdr)
                         + dst->header_len + t->hlen;
         if (max_headroom > dev->needed_headroom)
                 dev->needed_headroom = max_headroom;

Every time an interface sends a packet, this function is called and it 
increases dev->needed_headroom.
The first time, ip6gre1 will recalculate its own needed_headroom value.
Then, when ip6gre2 is used and if a dst interface is ip6gre1, it 
increases ip6gre->needed_headroom.
This logic will be repeated until it uses ip6gre100.
Actually, most packets will be drop because of XMIT_RECURSION_LIMIT.
But updating dev->needed_headroom will be updated regardless of the 
success of sending packets.
So, the needed_headroom value can be too big.

I think your suggestion can fix this problem more smartly because It can 
avoid high-order allocation by mtu and it allows high-order if hlen or 
tlen is too big.
So, I think it deserves to be used.
And If we deny setting ->needed_headrom to a too big value at the 
ip6_tnl_xmit(), it's safer I think.
How do you think about it?

 >
 > [1]
 > diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
 > index 
d36ef9d25e73cb14eed45701acafcaf78e08451e..420bf2038e810173fc6f86622378b5151463f204 
100644
 > --- a/net/ipv6/mcast.c
 > +++ b/net/ipv6/mcast.c
 > @@ -1738,13 +1738,16 @@ static struct sk_buff *mld_newpack(struct 
inet6_dev *idev, unsigned int mtu)
 >          const struct in6_addr *saddr;
 >          int hlen = LL_RESERVED_SPACE(dev);
 >          int tlen = dev->needed_tailroom;
 > -       unsigned int size = mtu + hlen + tlen;
 > +       unsigned int size;
 >          int err;
 >          u8 ra[8] = { IPPROTO_ICMPV6, 0,
 >                       IPV6_TLV_ROUTERALERT, 2, 0, 0,
 >                       IPV6_TLV_PADN, 0 };
 >
 > -       /* we assume size > sizeof(ra) here */
 > +       /* We assume size > sizeof(ra) here.
 > +        * Also try to not allocate high-order pages for big MTU.
 > +        */
 > +       size = min_t(int, mtu, PAGE_SIZE/2) + hlen + tlen;
 >          skb = sock_alloc_send_skb(sk, size, 1, &err);
 >          if (!skb)
 >                  return NULL;
