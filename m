Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 772961CF659
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 16:02:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730167AbgELOCO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 10:02:14 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:55129 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727859AbgELOCO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 10:02:14 -0400
Received: by mail-il1-f199.google.com with SMTP id l3so10808815ilk.21
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 07:02:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=ApUfbBKXss95NclLx9kM/XjXz1kDhacodR9DJdHbYjU=;
        b=myf27QLAGWPFwiYF5nuxWLAISltsOyDWf5qU3illM6NzTmq/eto6+dMO5afm7K30lJ
         UIrO6Lrc3mhpDZ5qr+mN/ZHo3Q7kY5oGeXrqEiCvOFFqDaVwviWwJg3b9ciDxxvvt36X
         Omk9PAED9YbvHqmF3ov19Pxp78S3qWYeTqKi/wO/HaEszyPrbdMcc6+nrJlNYJ1r33Og
         kNneDkyWvVXzUMuwN/oVuAb3ZrbYax6pIPyp9MqFLdoX/FyB/LlkehIfNM4qQ8KOeXFt
         DqeWnAIaNG71DJegnmwkl6dq7iS5YftRwXyBTEgEEcG4griHApmOcc8Oh5it1wMFzREP
         GRQQ==
X-Gm-Message-State: AGi0PuYsB1rX6YjaSeD9GnXSffHxUDUEVlO47x+qgH+ycf3vR6PRY972
        fyNtPgys2KAGrvwUHEe57VVJpaJFrokZ1+tsWFooB+pQB4ni
X-Google-Smtp-Source: APiQypJEGKAIOu+kFkxGEi88nzDtcQcrj6UeHvcIIMNofdDLC62Z5xNu1dlUmRUFAieqG61dAoLI8KwGpt1Zo0TLQ0ORFj2xPgjR
MIME-Version: 1.0
X-Received: by 2002:a02:cd03:: with SMTP id g3mr20050399jaq.61.1589292132614;
 Tue, 12 May 2020 07:02:12 -0700 (PDT)
Date:   Tue, 12 May 2020 07:02:12 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000002499105a573e9a4@google.com>
Subject: KMSAN: uninit-value in inet_gro_receive (3)
From:   syzbot <syzbot+a83a64bf2be17a4479cf@syzkaller.appspotmail.com>
To:     andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, glider@google.com,
        kafai@fb.com, kuba@kernel.org, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    21c44613 kmsan: page_alloc: more assuring comment
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=1533f00c100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a5915107b3106aaa
dashboard link: https://syzkaller.appspot.com/bug?extid=a83a64bf2be17a4479cf
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+a83a64bf2be17a4479cf@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in pskb_may_pull include/linux/skbuff.h:2333 [inline]
BUG: KMSAN: uninit-value in skb_gro_header_slow include/linux/netdevice.h:2768 [inline]
BUG: KMSAN: uninit-value in inet_gro_receive+0x451/0x1a10 net/ipv4/af_inet.c:1423
CPU: 0 PID: 9 Comm: ksoftirqd/0 Not tainted 5.6.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1c9/0x220 lib/dump_stack.c:118
 kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x58/0xa0 mm/kmsan/kmsan_instr.c:215
 pskb_may_pull include/linux/skbuff.h:2333 [inline]
 skb_gro_header_slow include/linux/netdevice.h:2768 [inline]
 inet_gro_receive+0x451/0x1a10 net/ipv4/af_inet.c:1423
 dev_gro_receive+0x2799/0x3260 net/core/dev.c:5774
 napi_gro_receive+0x619/0xf90 net/core/dev.c:5908
 gro_cell_poll+0x24c/0x400 net/core/gro_cells.c:60
 napi_poll net/core/dev.c:6571 [inline]
 net_rx_action+0x786/0x1aa0 net/core/dev.c:6639
 __do_softirq+0x311/0x83d kernel/softirq.c:293
 run_ksoftirqd+0x25/0x40 kernel/softirq.c:607
 smpboot_thread_fn+0x493/0x980 kernel/smpboot.c:165
 kthread+0x4b5/0x4f0 kernel/kthread.c:256
 ret_from_fork+0x35/0x40 arch/x86/entry/entry_64.S:353

Uninit was stored to memory at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:144 [inline]
 kmsan_internal_chain_origin+0xad/0x130 mm/kmsan/kmsan.c:310
 __msan_chain_origin+0x50/0x90 mm/kmsan/kmsan_instr.c:165
 __skb_pull include/linux/skbuff.h:2305 [inline]
 skb_pull_inline include/linux/skbuff.h:2312 [inline]
 eth_type_trans+0x684/0xa90 net/ethernet/eth.c:165
 ip_tunnel_rcv+0xe8b/0x1ae0 net/ipv4/ip_tunnel.c:416
 erspan_rcv net/ipv4/ip_gre.c:321 [inline]
 gre_rcv+0x155e/0x1940 net/ipv4/ip_gre.c:419
 gre_rcv+0x2dd/0x3c0 net/ipv4/gre_demux.c:163
 ip_protocol_deliver_rcu+0x700/0xbc0 net/ipv4/ip_input.c:204
 ip_local_deliver_finish net/ipv4/ip_input.c:231 [inline]
 NF_HOOK include/linux/netfilter.h:307 [inline]
 ip_local_deliver+0x62a/0x7c0 net/ipv4/ip_input.c:252
 dst_input include/net/dst.h:442 [inline]
 ip_rcv_finish net/ipv4/ip_input.c:428 [inline]
 NF_HOOK include/linux/netfilter.h:307 [inline]
 ip_rcv+0x6cf/0x750 net/ipv4/ip_input.c:538
 __netif_receive_skb_one_core net/core/dev.c:5187 [inline]
 __netif_receive_skb net/core/dev.c:5301 [inline]
 process_backlog+0xf0b/0x1410 net/core/dev.c:6133
 napi_poll net/core/dev.c:6571 [inline]
 net_rx_action+0x786/0x1aa0 net/core/dev.c:6639
 __do_softirq+0x311/0x83d kernel/softirq.c:293

Uninit was stored to memory at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:144 [inline]
 kmsan_internal_chain_origin+0xad/0x130 mm/kmsan/kmsan.c:310
 __msan_chain_origin+0x50/0x90 mm/kmsan/kmsan_instr.c:165
 __skb_pull include/linux/skbuff.h:2305 [inline]
 skb_pull_rcsum+0x2ca/0x4f0 net/core/skbuff.c:3621
 __iptunnel_pull_header+0x14b/0xbd0 net/ipv4/ip_tunnel_core.c:97
 erspan_rcv net/ipv4/ip_gre.c:279 [inline]
 gre_rcv+0x6d8/0x1940 net/ipv4/ip_gre.c:419
 gre_rcv+0x2dd/0x3c0 net/ipv4/gre_demux.c:163
 ip_protocol_deliver_rcu+0x700/0xbc0 net/ipv4/ip_input.c:204
 ip_local_deliver_finish net/ipv4/ip_input.c:231 [inline]
 NF_HOOK include/linux/netfilter.h:307 [inline]
 ip_local_deliver+0x62a/0x7c0 net/ipv4/ip_input.c:252
 dst_input include/net/dst.h:442 [inline]
 ip_rcv_finish net/ipv4/ip_input.c:428 [inline]
 NF_HOOK include/linux/netfilter.h:307 [inline]
 ip_rcv+0x6cf/0x750 net/ipv4/ip_input.c:538
 __netif_receive_skb_one_core net/core/dev.c:5187 [inline]
 __netif_receive_skb net/core/dev.c:5301 [inline]
 process_backlog+0xf0b/0x1410 net/core/dev.c:6133
 napi_poll net/core/dev.c:6571 [inline]
 net_rx_action+0x786/0x1aa0 net/core/dev.c:6639
 __do_softirq+0x311/0x83d kernel/softirq.c:293

Uninit was stored to memory at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:144 [inline]
 kmsan_internal_chain_origin+0xad/0x130 mm/kmsan/kmsan.c:310
 kmsan_memcpy_memmove_metadata+0x272/0x2e0 mm/kmsan/kmsan.c:247
 kmsan_memcpy_metadata+0xb/0x10 mm/kmsan/kmsan.c:267
 __msan_memcpy+0x43/0x50 mm/kmsan/kmsan_instr.c:116
 pskb_expand_head+0x38b/0x1b00 net/core/skbuff.c:1636
 __skb_cow include/linux/skbuff.h:3169 [inline]
 skb_cow_head include/linux/skbuff.h:3203 [inline]
 ip_tunnel_xmit+0x2a10/0x34f0 net/ipv4/ip_tunnel.c:811
 __gre_xmit net/ipv4/ip_gre.c:448 [inline]
 erspan_xmit+0x1779/0x2ae0 net/ipv4/ip_gre.c:683
 __netdev_start_xmit include/linux/netdevice.h:4523 [inline]
 netdev_start_xmit include/linux/netdevice.h:4537 [inline]
 xmit_one net/core/dev.c:3477 [inline]
 dev_hard_start_xmit+0x531/0xab0 net/core/dev.c:3493
 sch_direct_xmit+0x512/0x18b0 net/sched/sch_generic.c:314
 qdisc_restart net/sched/sch_generic.c:377 [inline]
 __qdisc_run+0x15ec/0x3350 net/sched/sch_generic.c:385
 qdisc_run include/net/pkt_sched.h:126 [inline]
 __dev_xmit_skb net/core/dev.c:3668 [inline]
 __dev_queue_xmit+0x23b7/0x3b20 net/core/dev.c:4021
 dev_queue_xmit+0x4b/0x60 net/core/dev.c:4085
 neigh_resolve_output+0xab0/0xb40 net/core/neighbour.c:1487
 neigh_output include/net/neighbour.h:510 [inline]
 ip_finish_output2+0x1acc/0x2610 net/ipv4/ip_output.c:228
 __ip_finish_output+0xaa7/0xd80 net/ipv4/ip_output.c:306
 ip_finish_output+0x166/0x410 net/ipv4/ip_output.c:316
 NF_HOOK_COND include/linux/netfilter.h:296 [inline]
 ip_mc_output+0xfbf/0x1090 net/ipv4/ip_output.c:415
 dst_output include/net/dst.h:436 [inline]
 ip_local_out net/ipv4/ip_output.c:125 [inline]
 ip_send_skb+0x179/0x360 net/ipv4/ip_output.c:1560
 udp_send_skb+0x1046/0x18b0 net/ipv4/udp.c:891
 udp_sendmsg+0x3bb5/0x4100 net/ipv4/udp.c:1178
 inet_sendmsg+0x276/0x2e0 net/ipv4/af_inet.c:807
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg net/socket.c:672 [inline]
 ____sys_sendmsg+0x1056/0x1350 net/socket.c:2345
 ___sys_sendmsg net/socket.c:2399 [inline]
 __sys_sendmmsg+0x5b6/0xc90 net/socket.c:2489
 __do_sys_sendmmsg net/socket.c:2518 [inline]
 __se_sys_sendmmsg+0xbd/0xe0 net/socket.c:2515
 __x64_sys_sendmmsg+0x56/0x70 net/socket.c:2515
 do_syscall_64+0xb8/0x160 arch/x86/entry/common.c:296
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:144 [inline]
 kmsan_internal_poison_shadow+0x66/0xd0 mm/kmsan/kmsan.c:127
 kmsan_slab_alloc+0x8a/0xe0 mm/kmsan/kmsan_hooks.c:80
 slab_alloc_node mm/slub.c:2801 [inline]
 __kmalloc_node_track_caller+0xb40/0x1200 mm/slub.c:4420
 __kmalloc_reserve net/core/skbuff.c:142 [inline]
 __alloc_skb+0x2fd/0xac0 net/core/skbuff.c:210
 alloc_skb include/linux/skbuff.h:1081 [inline]
 alloc_skb_with_frags+0x18c/0xa70 net/core/skbuff.c:5764
 sock_alloc_send_pskb+0xada/0xc60 net/core/sock.c:2245
 sock_alloc_send_skb+0xca/0xe0 net/core/sock.c:2262
 __ip_append_data+0x3b41/0x5660 net/ipv4/ip_output.c:1089
 ip_make_skb+0x394/0x880 net/ipv4/ip_output.c:1626
 udp_sendmsg+0x36dc/0x4100 net/ipv4/udp.c:1173
 inet_sendmsg+0x276/0x2e0 net/ipv4/af_inet.c:807
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg net/socket.c:672 [inline]
 ____sys_sendmsg+0x1056/0x1350 net/socket.c:2345
 ___sys_sendmsg net/socket.c:2399 [inline]
 __sys_sendmmsg+0x5b6/0xc90 net/socket.c:2489
 __do_sys_sendmmsg net/socket.c:2518 [inline]
 __se_sys_sendmmsg+0xbd/0xe0 net/socket.c:2515
 __x64_sys_sendmmsg+0x56/0x70 net/socket.c:2515
 do_syscall_64+0xb8/0x160 arch/x86/entry/common.c:296
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
=====================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
