Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6D482AA553
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 14:27:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727954AbgKGN1A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 08:27:00 -0500
Received: from m9785.mail.qiye.163.com ([220.181.97.85]:48279 "EHLO
        m9785.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727084AbgKGN1A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 08:27:00 -0500
Received: from [192.168.1.8] (unknown [114.92.196.101])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id 60CF55C1706;
        Sat,  7 Nov 2020 21:26:47 +0800 (CST)
Subject: Re: [PATCH v4 net-next 2/2] net/sched: act_frag: add implict packet
 fragment support.
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     kuba@kernel.org, marcelo.leitner@gmail.com, dcaratti@redhat.com,
        netdev@vger.kernel.org
References: <1604654056-24654-1-git-send-email-wenxu@ucloud.cn>
 <1604654056-24654-2-git-send-email-wenxu@ucloud.cn>
 <ygnhlffewdvz.fsf@nvidia.com>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <cdb2a62f-8a23-e8fa-806f-6f3f3bc9f675@ucloud.cn>
Date:   Sat, 7 Nov 2020 21:26:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <ygnhlffewdvz.fsf@nvidia.com>
Content-Type: text/plain; charset=gbk
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZGE5PTUNPTElJGB1LVkpNS09MTk5NS0xNTE1VGRETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hOT1VLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PhA6Vhw*Mz05EDk1OjICGDoZ
        KgxPCg5VSlVKTUtPTE5OTUtMQ05KVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpKT1VC
        SVVKQk1VSktKWVdZCAFZQUNOTUg3Bg++
X-HM-Tid: 0a75a2e350442087kuqy60cf55c1706
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2020/11/7 2:15, Vlad Buslov Ð´µÀ:
> [  558.577418] RIP: 0010:native_safe_halt+0xe/0x10
> [  558.578277] Code: 02 20 48 8b 00 a8 08 75 c4 e9 7b ff ff ff cc cc cc cc cc cc cc cc cc cc cc cc cc cc e9 07 00 00 00 0f 00 2d cc 01 55 00 fb f4 <c3> 90 e9 07 00 00 00 0f 00 2d bc 01 55 00 f4 c3 cc cc 0f 1f 44 00
> [  558.581470] RSP: 0018:ffffffff82403eb8 EFLAGS: 00000202
> [  558.583946] RAX: ffff8882f582c900 RBX: 0000000000000000 RCX: ffff8882f582c900
> [  558.585147] RDX: 00000000000ca6ea RSI: 7fffff7dff2b52f5 RDI: 0000000000000086
> [  558.586360] RBP: ffffffff82413940 R08: 000000cd42e4dffb R09: 00000082704a9c8a
> [  558.587556] R10: 00000000000302ee R11: 0000000000000000 R12: 0000000000000000
> [  558.588756] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> [  558.590118]  default_idle+0xa/0x10
> [  558.590769]  default_idle_call+0x38/0xb0
> [  558.591494]  do_idle+0x1f7/0x270
> [  558.592126]  cpu_startup_entry+0x19/0x20
> [  558.592857]  start_kernel+0x511/0x533
> [  558.603117]  secondary_startup_64_no_verify+0xa6/0xab
> [  558.604021] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.10.0-rc1+ #12
> [  558.605119] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
> [  558.606961] Call Trace:
> [  558.607462]  <IRQ>
> [  558.607903]  dump_stack+0x6b/0x83
> [  558.608529]  __warn.cold+0x24/0x75
> [  558.609177]  ? skb_warn_bad_offload+0x72/0xe0
> [  558.609959]  report_bug+0x9a/0xc0
> [  558.610581]  handle_bug+0x35/0x80
> [  558.611212]  exc_invalid_op+0x14/0x70
> [  558.611893]  asm_exc_invalid_op+0x12/0x20
> [  558.612618] RIP: 0010:skb_warn_bad_offload+0x72/0xe0
> [  558.613486] Code: 8d 95 c8 00 00 00 48 8d 88 e8 01 00 00 48 85 c0 48 c7 c0 18 3f 12 82 48 0f 44 c8 4c 89 e6 48 c7 c7 7f 0e 31 82 e8 b4 65 1a 00 <0f> 0b 5b 5d 41 5c c3 80 7d 00 00 49 c7 c4 b3 81 28 82 74 ac be 25
> [  558.616519] RSP: 0018:ffffc90000003768 EFLAGS: 00010286
> [  558.617431] RAX: 0000000000000000 RBX: ffff888104b4a900 RCX: 000000000000083f
> [  558.618619] RDX: 0000000000000000 RSI: 00000000000000f6 RDI: 000000000000083f
> [  558.619857] RBP: ffff888132900000 R08: ffffffff82621c28 R09: 0000000000013ffb
> [  558.621100] R10: 00000000ffffc000 R11: 3fffffffffffffff R12: ffffffffa0a03723
> [  558.622361] R13: ffffc90000003829 R14: 0000000000000000 R15: ffffc90000003828
> [  558.623617]  ? skb_warn_bad_offload+0x72/0xe0
> [  558.624439]  skb_checksum_help+0x10a/0x120
> [  558.625222]  ip_do_fragment+0x300/0x500
> [  558.625958]  ? tcf_frag_dst_get_mtu+0x10/0x10 [act_frag]
> [  558.626928]  ? fl_mask_lookup+0x164/0x4b0 [cls_flower]
> [  558.627866]  tcf_fragment+0x1a8/0x410 [act_frag]
> [  558.628725]  ? dst_discard_out+0x10/0x10
> [  558.629486]  ? dst_dev_put+0x60/0x60
> [  558.630191]  tcf_mirred_act+0x41f/0x457 [act_mirred]
> [  558.631128]  tcf_action_exec+0x75/0x120
> [  558.631884]  fl_classify+0x1c6/0x1d0 [cls_flower]
> [  558.632772]  __tcf_classify+0x52/0x100
> [  558.633516]  tcf_classify_ingress+0x65/0x140
> [  558.634344]  __netif_receive_skb_core+0x742/0xf10
> [  558.635235]  ? inet_gro_complete+0xa0/0xd0
> [  558.636019]  __netif_receive_skb_list_core+0xfa/0x200
> [  558.636965]  netif_receive_skb_list_internal+0x19f/0x2c0
> [  558.637969]  ? mlx5e_handle_rx_cqe_mpwrq_rep+0x158/0x200 [mlx5_core]
> [  558.639129]  napi_complete_done+0x6f/0x180
> [  558.639934]  mlx5e_napi_poll+0x13b/0x600 [mlx5_core]
> [  558.640877]  ? mlx5e_completion_event+0x3c/0x40 [mlx5_core]
> [  558.641900]  net_rx_action+0x130/0x3a0
> [  558.642630]  ? atomic_notifier_call_chain+0x54/0x70
> [  558.643543]  __do_softirq+0xc5/0x283
> [  558.644261]  asm_call_irq_on_stack+0xf/0x20
> [  558.645061]  </IRQ>
> [  558.645541]  do_softirq_own_stack+0x37/0x40
> [  558.646357]  irq_exit_rcu+0x9c/0xd0
> [  558.647053]  common_interrupt+0x74/0x130
> [  558.647816]  asm_common_interrupt+0x1e/0x40
> [  558.648627] RIP: 0010:native_safe_halt+0xe/0x10
> [  558.649498] Code: 02 20 48 8b 00 a8 08 75 c4 e9 7b ff ff ff cc cc cc cc cc cc cc cc cc cc cc cc cc cc e9 07 00 00 00 0f 00 2d cc 01 55 00 fb f4 <c3> 90 e9 07 00 00 00 0f 00 2d bc 01 55 00 f4 c3 cc cc 0f 1f 44 00
> [  558.652723] RSP: 0018:ffffffff82403eb8 EFLAGS: 00000202
> [  558.653764] RAX: ffff8882f582c900 RBX: 0000000000000000 RCX: ffff8882f582c900
> [  558.655116] RDX: 00000000000ca6ea RSI: 7fffff7dff2b52f5 RDI: 0000000000000086
> [  558.656387] RBP: ffffffff82413940 R08: 000000cd42e4dffb R09: 00000082704a9c8a
> [  558.657670] R10: 00000000000302ee R11: 0000000000000000 R12: 0000000000000000
> [  558.658939] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> [  558.660205]  default_idle+0xa/0x10
> [  558.660878]  default_idle_call+0x38/0xb0
> [  558.661643]  do_idle+0x1f7/0x270
> [  558.662298]  cpu_startup_entry+0x19/0x20
> [  558.663066]  start_kernel+0x511/0x533
> [  558.663787]  secondary_startup_64_no_verify+0xa6/0xab
> [  558.664746] ---[ end trace 1643bf725be8b62e ]---
> [  558.665713] skb len=7292 headroom=78 headlen=1500 tailroom=0
>                mac=(64,14) net=(78,20) trans=98
>                shinfo(txflags=0 nr_frags=4 gso(size=1448 type=1 segs=5))
>                csum(0x100062 ip_summed=3 complete_sw=0 valid=0 level=0)
>                hash(0x0 sw=0 l4=0) proto=0x0800 pkttype=3 iif=14
> [  558.670604] dev name=enp0s8f0_1 feat=0x0x0002010000116c13
> [  558.671613] skb linear:   00000000: 45 00 1c 7c 94 cf 40 00 40 06 6d 9c 07 07 07 01
> [  558.673039] skb linear:   00000010: 07 07 07 02 b9 42 13 89 7a 21 06 c9 fd 01 29 3e
> [  558.674473] skb linear:   00000020: 80 18 01 f6 38 7f 00 00 01 01 08 0a 44 e2 8a ea
> [  558.675894] skb linear:   00000030: 78 8a d7 32 30 31 32 33 34 35 36 37 38 39 30 31
> [  558.677323] skb linear:   00000040: 32 33 34 35 36 37 38 39 30 31 32 33 34 35 36 37
> [  558.678755] skb linear:   00000050: 38 39 30 31 32 33 34 35 36 37 38 39 30 31 32 33
> [  558.681051] skb linear:   00000060: 34 35 36 37 38 39 30 31 32 33 34 35 36 37 38 39
> [  558.682487] skb linear:   00000070: 30 31 32 33 34 35 36 37 38 39 30 31 32 33 34 35
> [  558.683940] skb linear:   00000080: 36 37 38 39 30 31 32 33 34 35 36 37 38 39 30 31
> [  558.685390] skb linear:   00000090: 32 33 34 35 36 37 38 39 30 31 32 33 34 35 36 37
> [  558.686844] skb linear:   000000a0: 38 39 30 31 32 33 34 35 36 37 38 39 30 31 32 33
> [  558.688298] skb linear:   000000b0: 34 35 36 37 38 39 30 31 32 33 34 35 36 37 38 39
> [  558.689751] skb linear:   000000c0: 30 31 32 33 34 35 36 37 38 39 30 31 32 33 34 35
> [  558.691204] skb linear:   000000d0: 36 37 38 39 30 31 32 33 34 35 36 37 38 39 30 31
> [  558.692657] skb linear:   000000e0: 32 33 34 35 36 37 38 39 30 31 32 33 34 35 36 37
> [  558.694101] skb linear:   000000f0: 38 39 30 31 32 33 34 35 36 37 38 39 30 31 32 33
> [  558.695523] skb linear:   00000100: 34 35 36 37 38 39 30 31 32 33 34 35 36 37 38 39

Hi Vlad,


I find the packet in the warning is not a defrag one. It is a gso packet.

The tcf_frag_xmit_hook should first check the mru. I think the

problem is qdisc_skb_cb(skb)->mru is not init in the sch_handle_ingress.


BR

wenxu

>
