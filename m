Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6BB21ED07
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 11:37:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbgGNJhZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 05:37:25 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:60420 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726187AbgGNJhY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jul 2020 05:37:24 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 1A24920270;
        Tue, 14 Jul 2020 11:37:21 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id JfxDVEaTlLts; Tue, 14 Jul 2020 11:37:19 +0200 (CEST)
Received: from cas-essen-01.secunet.de (201.40.53.10.in-addr.arpa [10.53.40.201])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id C691A200AC;
        Tue, 14 Jul 2020 11:37:19 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 14 Jul 2020 11:37:19 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Tue, 14 Jul
 2020 11:37:19 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 0B18431800C5; Tue, 14 Jul 2020 11:37:19 +0200 (CEST)
Date:   Tue, 14 Jul 2020 11:37:19 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     syzbot <syzbot+ea9832f8ae588deb0205@syzkaller.appspotmail.com>,
        Xin Long <lucien.xin@gmail.com>
CC:     <davem@davemloft.net>, <herbert@gondor.apana.org.au>,
        <kuba@kernel.org>, <kuznet@ms2.inr.ac.ru>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <syzkaller-bugs@googlegroups.com>, <yoshfuji@linux-ipv6.org>
Subject: Re: KASAN: slab-out-of-bounds Read in __xfrm6_tunnel_spi_lookup
Message-ID: <20200714093718.GQ20687@gauss3.secunet.de>
References: <0000000000003011fb05aa59df1e@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <0000000000003011fb05aa59df1e@google.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Xin,

this looks a bit like it was introduced with one of your recent
patches. Can you please look into that?

Thanks!

On Mon, Jul 13, 2020 at 03:04:16PM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    be978f8f Add linux-next specific files for 20200713
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=1225f8c7100000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3fe4fccb94cbc1a6
> dashboard link: https://syzkaller.appspot.com/bug?extid=ea9832f8ae588deb0205
> compiler:       gcc (GCC) 10.1.0-syz 20200507
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17270713100000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=126c0ffb100000
> 
> Bisection is inconclusive: the first bad commit could be any of:
> 
> 08622869 ip6_vti: support IP6IP6 tunnel processing with .cb_handler
> e6ce6457 ip_vti: support IPIP6 tunnel processing
> 2ab110cb ip6_vti: support IP6IP tunnel processing
> 87e66b96 ip_vti: support IPIP tunnel processing with .cb_handler
> 86afc703 tunnel6: add tunnel6_input_afinfo for ipip and ipv6 tunnels
> d5a7a505 ipcomp: assign if_id to child tunnel from parent tunnel
> 6df2db5d tunnel4: add cb_handler to struct xfrm_tunnel
> d7b360c2 xfrm: interface: support IP6IP6 and IP6IP tunnels processing with .cb_handler
> 1475ee0a xfrm: add is_ipip to struct xfrm_input_afinfo
> da9bbf05 xfrm: interface: support IPIP and IPIP6 tunnels processing with .cb_handler
> 2d4c7986 Merge remote-tracking branch 'origin/testing'
> 428d2459 xfrm: introduce oseq-may-wrap flag
> bdf0acad Merge remote-tracking branch 'ipsec-next/master'
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=137de95d100000
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+ea9832f8ae588deb0205@syzkaller.appspotmail.com
> 
> ==================================================================
> BUG: KASAN: slab-out-of-bounds in __xfrm6_tunnel_spi_lookup+0x3a9/0x3b0 net/ipv6/xfrm6_tunnel.c:79
> Read of size 8 at addr ffff88809a0d6b80 by task syz-executor016/7061
> CPU: 1 PID: 7061 Comm: syz-executor016 Not tainted 5.8.0-rc4-next-20200713-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  <IRQ>
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x18f/0x20d lib/dump_stack.c:118
>  print_address_description.constprop.0.cold+0xae/0x497 mm/kasan/report.c:383
>  __kasan_report mm/kasan/report.c:513 [inline]
>  kasan_report.cold+0x1f/0x37 mm/kasan/report.c:530
>  __xfrm6_tunnel_spi_lookup+0x3a9/0x3b0 net/ipv6/xfrm6_tunnel.c:79
>  xfrm6_tunnel_spi_lookup+0x8a/0x1d0 net/ipv6/xfrm6_tunnel.c:95
>  xfrmi6_rcv_tunnel+0xb9/0x100 net/xfrm/xfrm_interface.c:810
>  tunnel46_rcv+0xef/0x2b0 net/ipv6/tunnel6.c:193
>  ip6_protocol_deliver_rcu+0x2e8/0x1670 net/ipv6/ip6_input.c:433
>  ip6_input_finish+0x7f/0x160 net/ipv6/ip6_input.c:474
>  NF_HOOK include/linux/netfilter.h:307 [inline]
>  NF_HOOK include/linux/netfilter.h:301 [inline]
>  ip6_input+0x9c/0xd0 net/ipv6/ip6_input.c:483
>  ip6_mc_input+0x411/0xea0 net/ipv6/ip6_input.c:577
>  dst_input include/net/dst.h:449 [inline]
>  ip6_rcv_finish net/ipv6/ip6_input.c:76 [inline]
>  NF_HOOK include/linux/netfilter.h:307 [inline]
>  NF_HOOK include/linux/netfilter.h:301 [inline]
>  ipv6_rcv+0x28e/0x3c0 net/ipv6/ip6_input.c:307
>  __netif_receive_skb_one_core+0x114/0x180 net/core/dev.c:5287
>  __netif_receive_skb+0x27/0x1c0 net/core/dev.c:5401
>  process_backlog+0x28d/0x7f0 net/core/dev.c:6245
>  napi_poll net/core/dev.c:6690 [inline]
>  net_rx_action+0x4a1/0xe80 net/core/dev.c:6760
>  __do_softirq+0x34c/0xa60 kernel/softirq.c:292
>  asm_call_on_stack+0xf/0x20 arch/x86/entry/entry_64.S:706
>  </IRQ>
>  __run_on_irqstack arch/x86/include/asm/irq_stack.h:22 [inline]
>  run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:48 [inline]
>  do_softirq_own_stack+0x111/0x170 arch/x86/kernel/irq_64.c:77
>  do_softirq kernel/softirq.c:337 [inline]
>  do_softirq+0x16b/0x1e0 kernel/softirq.c:324
>  netif_rx_ni+0x3c5/0x650 net/core/dev.c:4836
>  dev_loopback_xmit+0x204/0x590 net/core/dev.c:3852
>  NF_HOOK include/linux/netfilter.h:307 [inline]
>  NF_HOOK include/linux/netfilter.h:301 [inline]
>  ip6_finish_output2+0x108f/0x17b0 net/ipv6/ip6_output.c:81
>  ip6_fragment+0xbdb/0x2490 net/ipv6/ip6_output.c:920
>  __ip6_finish_output net/ipv6/ip6_output.c:141 [inline]
>  __ip6_finish_output+0x578/0xab0 net/ipv6/ip6_output.c:128
>  ip6_finish_output+0x34/0x1f0 net/ipv6/ip6_output.c:153
>  NF_HOOK_COND include/linux/netfilter.h:296 [inline]
>  ip6_output+0x1db/0x520 net/ipv6/ip6_output.c:176
>  dst_output include/net/dst.h:443 [inline]
>  ip6_local_out+0xaf/0x1a0 net/ipv6/output_core.c:179
>  ip6_send_skb+0xb7/0x340 net/ipv6/ip6_output.c:1865
>  ip6_push_pending_frames+0xbd/0xe0 net/ipv6/ip6_output.c:1885
>  rawv6_push_pending_frames net/ipv6/raw.c:613 [inline]
>  rawv6_sendmsg+0x2add/0x38f0 net/ipv6/raw.c:956
>  inet_sendmsg+0x99/0xe0 net/ipv4/af_inet.c:817
>  sock_sendmsg_nosec net/socket.c:652 [inline]
>  sock_sendmsg+0xcf/0x120 net/socket.c:672
>  sock_no_sendpage+0xee/0x130 net/core/sock.c:2873
>  kernel_sendpage net/socket.c:3653 [inline]
>  sock_sendpage+0xe5/0x140 net/socket.c:945
>  pipe_to_sendpage+0x2ad/0x380 fs/splice.c:365
>  splice_from_pipe_feed fs/splice.c:419 [inline]
>  __splice_from_pipe+0x3dc/0x830 fs/splice.c:543
>  splice_from_pipe fs/splice.c:578 [inline]
>  generic_splice_sendpage+0xd4/0x140 fs/splice.c:724
>  do_splice_from fs/splice.c:736 [inline]
>  do_splice+0xbb8/0x17a0 fs/splice.c:1043
>  __do_sys_splice fs/splice.c:1318 [inline]
>  __se_sys_splice fs/splice.c:1300 [inline]
>  __x64_sys_splice+0x198/0x250 fs/splice.c:1300
>  do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:384
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> RIP: 0033:0x448bc9
> Code: Bad RIP value.
> RSP: 002b:00007f17b19a4da8 EFLAGS: 00000246 ORIG_RAX: 0000000000000113
> RAX: ffffffffffffffda RBX: 00000000006dec58 RCX: 0000000000448bc9
> RDX: 0000000000000005 RSI: 0000000000000000 RDI: 0000000000000003
> RBP: 00000000006dec50 R08: 000000000804ffe2 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 00000000006dec5c
> R13: 00007ffe929ff2df R14: 00007f17b19a59c0 R15: 00000000006dec5c
> Allocated by task 6840:
>  kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
>  kasan_set_track mm/kasan/common.c:56 [inline]
>  __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:461
>  __do_kmalloc mm/slab.c:3655 [inline]
>  __kmalloc+0x1a8/0x320 mm/slab.c:3664
>  kmalloc include/linux/slab.h:559 [inline]
>  kzalloc include/linux/slab.h:666 [inline]
>  ops_init+0xfb/0x470 net/core/net_namespace.c:141
>  setup_net+0x2d8/0x850 net/core/net_namespace.c:341
>  copy_net_ns+0x2cf/0x5e0 net/core/net_namespace.c:482
>  create_new_namespaces+0x3f6/0xb10 kernel/nsproxy.c:110
>  unshare_nsproxy_namespaces+0xbd/0x1f0 kernel/nsproxy.c:231
>  ksys_unshare+0x445/0x8e0 kernel/fork.c:2927
>  __do_sys_unshare kernel/fork.c:2995 [inline]
>  __se_sys_unshare kernel/fork.c:2993 [inline]
>  __x64_sys_unshare+0x2d/0x40 kernel/fork.c:2993
>  do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:384
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> The buggy address belongs to the object at ffff88809a0d6800
>  which belongs to the cache kmalloc-512 of size 512
> The buggy address is located 384 bytes to the right of
>  512-byte region [ffff88809a0d6800, ffff88809a0d6a00)
> The buggy address belongs to the page:
> page:000000008c78ee7f refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x9a0d6
> flags: 0xfffe0000000200(slab)
> raw: 00fffe0000000200 ffffea0002783b08 ffffea00026054c8 ffff8880aa000600
> raw: 0000000000000000 ffff88809a0d6000 0000000100000004 0000000000000000
> page dumped because: kasan: bad access detected
> Memory state around the buggy address:
>  ffff88809a0d6a80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>  ffff88809a0d6b00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> >ffff88809a0d6b80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>                    ^
>  ffff88809a0d6c00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  ffff88809a0d6c80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> ==================================================================
> 
> 
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> syzbot can test patches for this bug, for details see:
> https://goo.gl/tpsmEJ#testing-patches
