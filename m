Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85C503E92CE
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 15:38:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231612AbhHKNiU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 09:38:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231602AbhHKNiN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 09:38:13 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF9CBC0613D3
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 06:37:49 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id be20so4565570oib.8
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 06:37:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mceujzDMocY6frOpNnSWiH7SXb11WY8ROb0Xv29kl6o=;
        b=NYBiMbjcbCAQd9KFutym5IfTtpxN00v4c1m4bWY7/RPVtblbrd2Bu9kW/4njp/t96w
         mfNrI8xFMO5SZFqUE4cV0TCZbJrNs8sFCeyJtcU5JqNhlS/gMwG98rKlXPNbC6pxXvOP
         TXZ4CVsWO0NGg1RPUmPVf8WXrOHcep+ltQBV5Rlv7I0MUMJLMKW3r0RtURp4PKRnC++b
         kpaHoWK4VkIM41Mge0eM45D0rKujrF/FiLpLeD1X/vo/Ys+5QURcMS70e9JyqlMlEYT0
         ZL9Cbm1S1iebAaAzxlEsBGqkjAGXzJtkZphT6T68dsqYudHuW1n9k7f1c00V6BFV3TOU
         7/JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mceujzDMocY6frOpNnSWiH7SXb11WY8ROb0Xv29kl6o=;
        b=Yw+/cdt/OF54+NqiBbBunTce6TNtOXfyLfXZvDPm3UxoHllRc0kcvPssXwntNMbekU
         xi14W79wNYsO9dSeLR1NqCReMebVdJBfjTkPVfNHYlYysfvs0gQ3yx1jp5K9MNOuWGWm
         kt//1GpIzkMjd2oFD8i4D8pETnckNHba+pc8ePTOaNxEOxLZbfgzN3EXFTdJ+/1tcX9Q
         ZKm+wELSiVPU/nXjIG8zOFEQrVGLKjmdb1Exx/b6Akxv6qWyP7rtz3Hofp2sNkh1Hqfx
         5uxRnE8S8QLnw0Li2IEcKVWZxmHVgu/yHreyua0Mpmcks6kbD9kX2wIAL2GnqAiK/i1g
         ZH3A==
X-Gm-Message-State: AOAM533y6LLYm9rMoaXzkXaQzMz3DcFayqFBIE8BcWsjNh3wVP784eNt
        1hMscgUwf/mI5m0D+2QpdRhulAXB0KU=
X-Google-Smtp-Source: ABdhPJxQOSIUofDkCskZaIJLCO/WnmMGocd70FiBnAag8+QkVWDHwTdrdRH+FdFcYIXFPlm2GJQgvQ==
X-Received: by 2002:a05:6808:13c8:: with SMTP id d8mr701369oiw.169.1628689069017;
        Wed, 11 Aug 2021 06:37:49 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.45])
        by smtp.googlemail.com with ESMTPSA id t8sm2743848ool.20.2021.08.11.06.37.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Aug 2021 06:37:48 -0700 (PDT)
Subject: Re: dst remains in vxlan dst cache
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Taehee Yoo <ap420073@gmail.com>
Cc:     netdev@vger.kernel.org
References: <1628651099.3998537-1-xuanzhuo@linux.alibaba.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <09695b84-ef99-ffae-1da7-0f25dfd1e5a9@gmail.com>
Date:   Wed, 11 Aug 2021 07:37:47 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <1628651099.3998537-1-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ Adding author of suspected patch ]

On 8/10/21 9:04 PM, Xuan Zhuo wrote:
> 1. Problem and test environment description
> 
> $ tools/testing/selftest/net/pmtu.sh cleanup_ipv6_exception
> TEST: ipv6: cleanup of cached exceptions - nexthop objects          [FAIL]
>   can't delete veth device in a timely manner, PMTU dst likely leaked
> 
> This test will create several namespaces. After creation, the ip route and ip
> addr of ns-A are as follows:
> 
>     $ ip route
>     default nhid 41 via 10.0.1.2 dev veth_A-R1
>     10.0.1.0/24 dev veth_A-R1 proto kernel scope link src 10.0.1.1
>     10.0.2.0/24 dev veth_A-R2 proto kernel scope link src 10.0.2.1
>     10.0.4.1 nhid 42 via 10.0.2.2 dev veth_A-R2
>     192.168.2.0/24 dev vxlan_a proto kernel scope link src 192.168.2.1
> 
>     $ ip addr
>     1: lo: <LOOPBACK> mtu 65536 qdisc noop state DOWN group default qlen 1000
>         link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
>     2: veth_A-R1@if2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 5000 qdisc noqueue state UP group default qlen 1000
>         link/ether e2:41:9d:0e:3c:22 brd ff:ff:ff:ff:ff:ff link-netns ns-R1
>         inet 10.0.1.1/24 scope global veth_A-R1
>            valid_lft forever preferred_lft forever
>         inet6 fc00:1::1/64 scope global
>            valid_lft forever preferred_lft forever
>         inet6 fe80::e041:9dff:fe0e:3c22/64 scope link
>            valid_lft forever preferred_lft forever
>     3: veth_A-R2@if2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
>         link/ether 0e:96:7b:23:b4:44 brd ff:ff:ff:ff:ff:ff link-netns ns-R2
>         inet 10.0.2.1/24 scope global veth_A-R2
>            valid_lft forever preferred_lft forever
>         inet6 fc00:2::1/64 scope global
>            valid_lft forever preferred_lft forever
>         inet6 fe80::c96:7bff:fe23:b444/64 scope link
>            valid_lft forever preferred_lft forever
>     4: vxlan_a: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 5000 qdisc noqueue state UNKNOWN group default qlen 1000
>         link/ether 92:06:b4:f3:21:3e brd ff:ff:ff:ff:ff:ff
>         inet 192.168.2.1/24 scope global vxlan_a
>            valid_lft forever preferred_lft forever
>         inet6 fd00:2::a/64 scope global
>            valid_lft forever preferred_lft forever
>         inet6 fe80::9006:b4ff:fef3:213e/64 scope link
>            valid_lft forever preferred_lft forever
> 
>     $ ip -d link show vxlan_a
>     4: vxlan_a: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 5000 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
>         link/ether 1a:4c:20:0a:38:38 brd ff:ff:ff:ff:ff:ff promiscuity 0 minmtu 68 maxmtu 65535
>         vxlan id 1 remote fc00:3::1 local fc00:1::1 srcport 0 0 dstport 4789 ttl 64 ageing 300 udpcsum noudp6zerocsumtx noudp6zerocsumrx addrgenmode eui64 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
> 
> 
> The points we need to pay attention to are:
>     1. vxlan device is used
>     2. vxlan mtu is 5000
>     3. vxlan local device is veth_A-R1
>     4. nexthop is used. (If nexthop is not used, this test is no problem.)
> 
> Finally, the test will delete veth_A-R1 in ns-A.
> 
>     ${ns_a} ip link del dev veth_A-R1 &
> 
> Then check whether this operation is completed within 1s.
> 
> After the following patch, it is very easy to fail.
> 
>     commit 020ef930b826d21c5446fdc9db80fd72a791bc21
>     Author: Taehee Yoo <ap420073@gmail.com>
>     Date:   Sun May 16 14:44:42 2021 +0000
> 
>         mld: fix panic in mld_newpack()
> 
>         mld_newpack() doesn't allow to allocate high order page,
>         only order-0 allocation is allowed.
>         If headroom size is too large, a kernel panic could occur in skb_put().
> 
>     ......
> 
> 
>     diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
>     index 0d59efb6b49e..d36ef9d25e73 100644
>     --- a/net/ipv6/mcast.c
>     +++ b/net/ipv6/mcast.c
>     @@ -1745,10 +1745,7 @@ static struct sk_buff *mld_newpack(struct inet6_dev *idev, unsigned int mtu)
>                          IPV6_TLV_PADN, 0 };
> 
>             /* we assume size > sizeof(ra) here */
>     -       /* limit our allocations to order-0 page */
>     -       size = min_t(int, size, SKB_MAX_ORDER(0, 0));
>             skb = sock_alloc_send_skb(sk, size, 1, &err);
>     -
>             if (!skb)
>                     return NULL;
> 
> 
> 2. Description of the immediate cause
> 
> I analyzed the reason. It is because there is a dst in the dst cache of vxlan,
> which has a reference to veth_A-R1, and the network card cannot be deleted
> quickly.
> 
> After requesting to delete veth_A-R1, vxlan will destroy all dst caches, but
> after that, the DAD mechanism of ipv6 sends a packet, uses the dst cache, and
> adds a dst to the reinitialized dst cache, this dst references veth_A-R1,
> resulting in veth_A-R1 cannot be deleted.
> 
> 	# cat check.bpf
> 
> 	    kprobe: dst_cache_destroy{printf("dst cache dstroy: cache: %p\n", arg0)}
> 
> 	    kprobe: dst_cache_get_ip6{printf("dst cache get     cache: %p \n", arg0)}
> 	    kprobe: dst_cache_set_ip6{printf("dst cache set     cache: %p dst: %p\n", arg0, arg1)}
> 
> 	    kprobe: dst_cache_init{   printf("dst cache init    cache: %p\n", arg0)}
> 
> 	# bpftrace check.bpf
> 	    Attaching 4 probes...
> 	    dst cache dstroy: cache: 0xffffa09407c1fa10
> 	    dst cache dstroy: cache: 0xffffa094067cc230
> 	    dst cache dstroy: cache: 0xffffa094057085f0
> 	    dst cache dstroy: cache: 0xffffa09405708e30
> 	    dst cache init    cache: 0xffffa09405708110
> 	    dst cache init    cache: 0xffffa094025e3350
> 	    dst cache get     cache: 0xffffa09405708110
> 	    dst cache set     cache: 0xffffa09405708110 dst: 0xffffa09400f46200
> 	    dst cache init    cache: 0xffffa094025e34d0
> 	    dst cache init    cache: 0xffffa094200c1ad0
> 	    dst cache get     cache: 0xffffa094025e3350
> 	    dst cache set     cache: 0xffffa094025e3350 dst: 0xffffa09406e07500
> 	    dst cache get     cache: 0xffffa09405708110
> 	    dst cache get     cache: 0xffffa094025e3350
> 	    dst cache set     cache: 0xffffa094025e3350 dst: 0xffffa09461adee00
> 	    dst cache get     cache: 0xffffa09405708110
> 	    dst cache get     cache: 0xffffa094025e3350
> 
> From the above bpftrace trace, we can find that after re-init 0xffffa09405708110
> in the dst cache of vxlan, a dst will be set soon. I confirmed by adding printk
> that the dev of the newly cached dst is veth_A-R1.
> 
> Below is the stack of sending DAD packets and adding cache dst to vxlan dst
> cache.
> 
>     [   12.065978]  dump_stack+0x57/0x6a
>     [   12.065990]  dst_cache_set_ip6+0x29/0xe0
>     [   12.065997]  vxlan6_get_route+0x21f/0x330 [vxlan]
>     [   12.066001]  vxlan_xmit_one+0x337/0xe00 [vxlan]
>     [   12.066005]  ? vxlan_xmit+0x9c2/0xfd0 [vxlan]
>     [   12.066007]  ? vxlan_find_mac+0xa/0x30 [vxlan]
>     [   12.066009]  vxlan_xmit+0x9c2/0xfd0 [vxlan]
>     [   12.066014]  ? __kmalloc_node_track_caller+0x57/0x4a0
>     [   12.066017]  ? __alloc_skb+0x72/0x190
>     [   12.066021]  ? dev_hard_start_xmit+0xcc/0x1f0
>     [   12.066023]  dev_hard_start_xmit+0xcc/0x1f0
>     [   12.066028]  __dev_queue_xmit+0x786/0x9d0
>     [   12.066031]  ? ndisc_next_option+0x60/0x60
>     [   12.066033]  ? ___neigh_create+0x3c5/0x840
>     [   12.066038]  ? eth_header+0x25/0xc0
>     [   12.066041]  ? ip6_finish_output2+0x1ba/0x570
>     [   12.066042]  ip6_finish_output2+0x1ba/0x570
>     [   12.066047]  ? __slab_alloc+0xe/0x20
>     [   12.066048]  ? ip6_mtu+0x79/0xa0
>     [   12.066051]  ? ip6_output+0x60/0x110
>     [   12.066052]  ip6_output+0x60/0x110
>     [   12.066054]  ? nf_hook.constprop.28+0x74/0xd0
>     [   12.066055]  ? icmp6_dst_alloc+0xfa/0x1c0
>     [   12.066057]  ndisc_send_skb+0x283/0x2f0
>     [   12.066062]  addrconf_dad_completed+0x125/0x310
>     [   12.066064]  ? addrconf_dad_work+0x2e8/0x530
>     [   12.066065]  addrconf_dad_work+0x2e8/0x530
>     [   12.066068]  ? __switch_to_asm+0x42/0x70
>     [   12.066072]  ? process_one_work+0x18b/0x350
>     [   12.066073]  ? addrconf_dad_completed+0x310/0x310
>     [   12.066074]  process_one_work+0x18b/0x350
>     [   12.066078]  worker_thread+0x4c/0x380
>     [   12.066080]  ? rescuer_thread+0x300/0x300
>     [   12.066082]  kthread+0xfc/0x130
>     [   12.066084]  ? kthread_create_worker_on_cpu+0x50/0x50
>     [   12.066086]  ret_from_fork+0x22/0x30
> 
> This logic is not correct in my opinion. In theory, after vxlan destroys the dst
> cache, it should not add the dst information of a device that is about to be
> deleted in the dst cache. At the same time, I don’t understand the DAD too
> much. Why is it triggered?
> 
> In the case before patch 020ef930, soon, DAD will send another packet. This
> time, vxlan's dst cache will be used, and the state of dst will be detected, so
> dst will be deleted. So before this patch, this test is passable.
> 
>     [   86.666349]  vxlan_xmit_one+0xaa8/0xe00 [vxlan]
>     [   86.666352]  ? __alloc_skb+0x72/0x190
>     [   86.666354]  ? vxlan_xmit+0x9c2/0xfd0 [vxlan]
>     [   86.666356]  ? vxlan_find_mac+0xa/0x30 [vxlan]
>     [   86.666359]  vxlan_xmit+0x9c2/0xfd0 [vxlan]
>     [   86.666361]  ? vxlan_xmit+0x9c2/0xfd0 [vxlan]
>     [   86.666363]  ? vxlan_find_mac+0xa/0x30 [vxlan]
>     [   86.666365]  ? __kmalloc_node_track_caller+0x57/0x4a0
>     [   86.666367]  ? __alloc_skb+0x72/0x190
>     [   86.666369]  ? __kmalloc_node_track_caller+0x57/0x4a0
>     [   86.666370]  ? __alloc_skb+0x72/0x190
>     [   86.666373]  ? dev_hard_start_xmit+0xcc/0x1f0
>     [   86.666375]  dev_hard_start_xmit+0xcc/0x1f0
>     [   86.666377]  __dev_queue_xmit+0x786/0x9d0
>     [   86.666380]  ? ip6_finish_output2+0x27e/0x570
>     [   86.666381]  ip6_finish_output2+0x27e/0x570
>     [   86.666383]  ? mld_newpack+0x155/0x1b0
>     [   86.666385]  ? kmem_cache_alloc+0x28/0x3e0
>     [   86.666386]  ? ip6_mtu+0x79/0xa0
>     [   86.666388]  ? ip6_output+0x60/0x110
>     [   86.666390]  ip6_output+0x60/0x110
>     [   86.666392]  ? nf_hook.constprop.45+0x74/0xd0
>     [   86.666393]  ? icmp6_dst_alloc+0xfa/0x1c0
>     [   86.666395]  mld_sendpack+0x217/0x230
>     [   86.666398]  mld_ifc_timer_expire+0x192/0x300
>     [   86.666400]  ? mld_dad_timer_expire+0xa0/0xa0
>     [   86.666403]  call_timer_fn+0x29/0x100
>     [   86.666405]  run_timer_softirq+0x1b3/0x3a0
>     [   86.666407]  ? kvm_clock_get_cycles+0xd/0x10
>     [   86.666409]  ? ktime_get+0x3e/0xa0
>     [   86.666410]  ? kvm_sched_clock_read+0xd/0x20
>     [   86.666413]  ? sched_clock+0x5/0x10
>     [   86.666415]  __do_softirq+0x101/0x29e
>     [   86.666418]  asm_call_irq_on_stack+0x12/0x20
>     [   86.666419]  </IRQ>
>     [   86.666421]  do_softirq_own_stack+0x37/0x40
>     [   86.666424]  irq_exit_rcu+0xcb/0xd0
>     [   86.666426]  sysvec_apic_timer_interrupt+0x34/0x80
>     [   86.666428]  asm_sysvec_apic_timer_interrupt+0x12/0x20
> 
> 3. Why after patch 020ef930, dst cannot be deleted by the second DAD package
> 
> The reason is that the second packet sent by DAD will not use the cache. Because
> the skb->mark != 0 of the sent packet. In vxlan, if
> ip_tunnel_dst_cache_usable finds skb->mark != 0, the dst cache will not be used.
> So this time, it cannot be found that the cached dst should be deleted.
> 
> The reason for skb->mark != 0 is
> 
>     static struct sk_buff *mld_newpack(struct inet6_dev *idev, unsigned int mtu)
>     {
> 
>         int tlen = dev->needed_tailroom;
>         unsigned int size = mtu + hlen + tlen;
> 
>     	sk = net->ipv6.igmp_sk;
>     	/* we assume size > sizeof(ra) here
>     	 * Also try to not allocate high-order pages for big MTU
>     	 */
>     >   size = min_t(int, size, SKB_MAX_ORDER(0, 0));
>     	skb = sock_alloc_send_skb(sk, size, 1, &err);
>     	if (!skb)
>     		return NULL;
> 
>     	skb->priority = TC_PRIO_CONTROL;
>     	skb_reserve(skb, hlen);
>     >	skb_tailroom_reserve(skb, mtu, tlen);
> 
>         ......
> 
>     }
> 
> 
>     static inline void skb_tailroom_reserve(struct sk_buff *skb, unsigned int mtu,
>     					unsigned int needed_tailroom)
>     {
>     	SKB_LINEAR_ASSERT(skb);
>     	if (mtu < skb_tailroom(skb) - needed_tailroom)
>     		/* use at most mtu */
>     		skb->reserved_tailroom = skb_tailroom(skb) - mtu;
>     	else
>     		/* use up to all available space */
>     		skb->reserved_tailroom = needed_tailroom;
>     }
> 
> First of all, in my environment, dev->needed_tailroom == 0.
> 
> The DAD package sent for the second time is allocated by mld_newpack. Here
> skb_tailroom_reserve(skb, mtu, tlen) will be executed. In the original version,
> since skb was limited in size, finally
> 
>     skb->reserved_tailroom = needed_tailroom;
> 
> In the new version, since size is not limited, and in general, the actual
> allocated skb size will be larger than size, which leads to
> 
>         skb->reserved_tailroom = skb_tailroom(skb) - mtu;
> 
> AND
>         skb->reserved_tailroom > 0.
> 
> AND
> 
>         struct sk_buffer {
>         ......
> 
> 	        union {
> 	        	__u32		mark;
> 	        	__u32		reserved_tailroom;
> 	        };
>         ......
> 
>         }
> 
> So skb->mark is also greater than 0, so after this skb enters vxlan, the dst
> cache cannot be used. Therefore, the data sent by the second DAD cannot be used
> because the dst cache cannot be used, so the dst of the dst cache cannot be
> deleted.
> 
> After patch 020ef930b, another patch ffa85b73c3c4 also modified the logic here.
> 
>     size = min_t(int, mtu, PAGE_SIZE / 2) + hlen + tlen;
> 
> But as long as mtu is relatively small and not limited by PAGE_SIZE / 2, this
> situation will still occur.
> 
> Finally, the second DAD request did not delete dst, which affected the deletion
> of veth_A-R1.
> 
> 
> 3. No matter what, it will eventually be deleted
> 
> If the second DAD package cannot delete the cached dst, after about 2-4s, the rs
> timer will delete the dst, thus completing the deletion of veth_A-R1.
> 
>     [  116.793215]  vxlan_xmit_one+0xaa8/0xe00 [vxlan]
>     [  116.793220]  ? sock_def_readable+0x37/0x70
>     [  116.793223]  ? vxlan_xmit+0x9c2/0xfd0 [vxlan]
>     [  116.793225]  ? vxlan_find_mac+0xa/0x30 [vxlan]
>     [  116.793227]  vxlan_xmit+0x9c2/0xfd0 [vxlan]
>     [  116.793231]  ? find_match+0x4f/0x330
>     [  116.793236]  ? __kmalloc_node_track_caller+0x57/0x4a0
>     [  116.793241]  ? dev_hard_start_xmit+0xcc/0x1f0
>     [  116.793243]  dev_hard_start_xmit+0xcc/0x1f0
>     [  116.793245]  __dev_queue_xmit+0x786/0x9d0
>     [  116.793248]  ? cpumask_next_and+0x1a/0x20
>     [  116.793252]  ? update_sd_lb_stats.constprop.110+0x100/0x7a0
>     [  116.793255]  ? ip6_finish_output2+0x27e/0x570
>     [  116.793257]  ip6_finish_output2+0x27e/0x570
>     [  116.793260]  ? kmem_cache_alloc+0x28/0x3e0
>     [  116.793261]  ? ip6_mtu+0x79/0xa0
>     [  116.793263]  ? ip6_output+0x60/0x110
>     [  116.793265]  ip6_output+0x60/0x110
>     [  116.793267]  ? nf_hook.constprop.28+0x74/0xd0
>     [  116.793269]  ? icmp6_dst_alloc+0xfa/0x1c0
>     [  116.793271]  ndisc_send_skb+0x283/0x2f0
>     [  116.793273]  addrconf_rs_timer+0x152/0x220
>     [  116.793275]  ? ipv6_get_lladdr+0xc0/0xc0
>     [  116.793278]  ? call_timer_fn+0x29/0x100
>     [  116.793279]  ? ipv6_get_lladdr+0xc0/0xc0
>     [  116.793281]  call_timer_fn+0x29/0x100
>     [  116.793283]  run_timer_softirq+0x1b3/0x3a0
>     [  116.793287]  ? kvm_clock_get_cycles+0xd/0x10
>     [  116.793289]  ? ktime_get+0x3e/0xa0
>     [  116.793290]  ? kvm_sched_clock_read+0xd/0x20
>     [  116.793294]  ? sched_clock+0x5/0x10
>     [  116.793298]  __do_softirq+0x101/0x29e
>     [  116.793301]  asm_call_irq_on_stack+0x12/0x20
> 
> 
> 4. Finally
> 
> Although regardless of the version, the network card will be deleted. But I
> think this logic may still have some problems.
> 
> Moreover, I think that these two patches are not directly related to the problem
> here.
> 
> What we should pay attention to is that after veth_A-R1 is required to be
> deleted, the packets sent by the ipv6 layer should not be cached in the dst
> cache in vxlan.
> 
> How should we solve this problem:
> 
> 1. Ensure that vxlan cleans dst cache after route update?
> 2. dst cache checks the status of dev when adding cache?
> 3. ipv6 no longer sends rs or DAD packets when the settings are to be deleted?
> 4. Nexthop checks the status of dev?
> 
> 
> Thanks.
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 

