Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B244031ACD9
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 17:10:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbhBMQJ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 11:09:57 -0500
Received: from mail.thelounge.net ([91.118.73.15]:36055 "EHLO
        mail.thelounge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbhBMQJy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 11:09:54 -0500
Received: from srv-rhsoft.rhsoft.net (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4DdFft4HwczXRq;
        Sat, 13 Feb 2021 17:09:05 +0100 (CET)
Subject: Re: [PATCH net 1/4] netfilter: xt_recent: Fix attempt to update
 deleted entry
From:   Reindl Harald <h.reindl@thelounge.net>
To:     Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
References: <20210205001727.2125-1-pablo@netfilter.org>
 <20210205001727.2125-2-pablo@netfilter.org>
 <69957353-7fe0-9faa-4ddd-1ac44d5386a5@thelounge.net>
 <alpine.DEB.2.23.453.2102051448220.10405@blackhole.kfki.hu>
 <a51d867a-3ca9-fd36-528a-353aa6c42f42@thelounge.net>
 <3018f068-62b1-6dae-2dde-39d1a62fbcb2@thelounge.net>
 <alpine.DEB.2.23.453.2102072036220.16338@blackhole.kfki.hu>
 <303fdd83-a324-5d0c-b45e-9584ea0c9cd5@thelounge.net>
Organization: the lounge interactive design
Message-ID: <9e18d3b2-e0d2-489e-43ae-c27c160df221@thelounge.net>
Date:   Sat, 13 Feb 2021 17:09:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <303fdd83-a324-5d0c-b45e-9584ea0c9cd5@thelounge.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Am 10.02.21 um 11:34 schrieb Reindl Harald:
> 
> 
> Am 07.02.21 um 20:38 schrieb Jozsef Kadlecsik:
>> On Sun, 7 Feb 2021, Reindl Harald wrote:
>>
>>>> well, the most important thing is that the firewall-vm stops to
>>>> kernel-panic
>>>
>>> why is that still not part of 5.10.14 given how old that issue is :-(
>>>
>>> https://cdn.kernel.org/pub/linux/kernel/v5.x/ChangeLog-5.10.14
>>
>> Probably we missed the window when patches were accepted for the new
>> release. That's all
> 
> probably something is broken in the whole process given that 5.10.15 
> still don't contain the fix while i am tired of a new "stable release" 
> every few days and 5.10.x like every LTS release in the past few years 
> has a peak of it
> 
> https://cdn.kernel.org/pub/linux/kernel/v5.x/ChangeLog-5.10.15

and another useless crash of something which has a ready patch from 
before 5.10.14

[165940.842226] kernel BUG at lib/list_debug.c:45!
[165940.874769] invalid opcode: 0000 [#1] SMP NOPTI
[165940.876680] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 
5.10.15-100.fc32.x86_64 #1
[165940.880198] Hardware name: VMware, Inc. VMware Virtual 
Platform/440BX Desktop Reference Platform, BIOS 6.00 12/12/2018
[165940.885314] RIP: 0010:__list_del_entry_valid.cold+0xf/0x47
[165940.886202] Code: fe ff 0f 0b 48 89 d1 4c 89 c6 4c 89 ca 48 c7 c7 60 
88 40 b2 e8 cf 45 fe ff 0f 0b 48 89 fe 48 c7 c7 f0 88 40 b2 e8 be 45 fe 
ff <0f> 0b 48 c7 c7 a0 89 40 b2 e8 b0 45 fe ff 0f 0b 48 89 f2 48 89 fe
[165940.889107] RSP: 0018:ffffaf0480003928 EFLAGS: 00010282
[165940.889943] RAX: 000000000000004e RBX: ffff9fa911148000 RCX: 
0000000000000000
[165940.891066] RDX: ffff9fa99d4269e0 RSI: ffff9fa99d418a80 RDI: 
0000000000000300
[165940.892190] RBP: ffffaf04800039a0 R08: 0000000000000000 R09: 
ffffaf0480003760
[165940.893313] R10: ffffaf0480003758 R11: ffffffffb2b44748 R12: 
ffff9fa9046000f8
[165940.894441] R13: ffff9fa911148010 R14: ffff9fa903329400 R15: 
ffff9fa904600000
[165940.895573] FS:  0000000000000000(0000) GS:ffff9fa99d400000(0000) 
knlGS:0000000000000000
[165940.896856] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[165940.897789] CR2: 00007fb9442e5000 CR3: 00000000030a0006 CR4: 
00000000003706f0
[165940.898954] Call Trace:
[165940.899400]  <IRQ>
[165940.899757]  recent_mt+0x1b5/0x39b [xt_recent]
[165940.900492]  ? set_match_v4+0x92/0xb0 [xt_set]
[165940.901236]  nft_match_large_eval+0x34/0x60 [nft_compat]
[165940.902104]  nft_do_chain+0x141/0x4e0 [nf_tables]
[165940.902869]  ? fib_validate_source+0x47/0xf0
[165940.903564]  ? ip_route_input_slow+0x722/0xaa0
[165940.904282]  nft_do_chain_ipv4+0x56/0x60 [nf_tables]
[165940.905086]  nf_hook_slow+0x3f/0xb0
[165940.905658]  ip_forward+0x441/0x480
[165940.906230]  ? ip4_key_hashfn+0xb0/0xb0
[165940.906856]  __netif_receive_skb_one_core+0x67/0x70
[165940.907639]  netif_receive_skb+0x35/0x110
[165940.908295]  br_handle_frame_finish+0x17a/0x450 [bridge]
[165940.909143]  ? ip_finish_output2+0x19b/0x560
[165940.909842]  ? br_handle_frame_finish+0x450/0x450 [bridge]
[165940.910718]  br_handle_frame+0x292/0x350 [bridge]
[165940.911483]  ? ip_sublist_rcv_finish+0x57/0x70
[165940.912199]  ? ___slab_alloc+0x127/0x5b0
[165940.912835]  __netif_receive_skb_core+0x196/0xf70
[165940.913590]  ? ip_list_rcv+0x125/0x140
[165940.914201]  __netif_receive_skb_list_core+0x12f/0x2b0
[165940.915024]  netif_receive_skb_list_internal+0x1bc/0x2e0
[165940.915873]  ? vmxnet3_rq_rx_complete+0x8bd/0xde0 [vmxnet3]
[165940.916769]  napi_complete_done+0x6f/0x190
[165940.917439]  vmxnet3_poll_rx_only+0x7b/0xa0 [vmxnet3]
[165940.918249]  net_rx_action+0x135/0x3b0
[165940.918863]  __do_softirq+0xca/0x288
[165940.919451]  asm_call_irq_on_stack+0xf/0x20
[165940.920146]  </IRQ>
[165940.920508]  do_softirq_own_stack+0x37/0x40
[165940.921187]  irq_exit_rcu+0xc2/0x100
[165940.921772]  common_interrupt+0x74/0x130
[165940.922410]  asm_common_interrupt+0x1e/0x40
