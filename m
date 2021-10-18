Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D665643289B
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 22:49:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbhJRUve (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 16:51:34 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:52112 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbhJRUvd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 16:51:33 -0400
Received: by mail-il1-f200.google.com with SMTP id a14-20020a927f0e000000b002597075cb35so7487689ild.18
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 13:49:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=z1Usp68k2V+t9Wysdl4FaxRyMvsaxNLopVhfKi5kpqo=;
        b=AW1OZmIfEzJICaAjYA6oMxht4ccEiFFomD7dBrXEuNI7sLNfMnwtiWkbkDKCQCAA5R
         VT75jls33AtslRrMhCAp4zXeNHHL45eal1NkhrSc+w6hqSVIDLHXmeocFNQ14tWH+K24
         hKk2rKMEHcW+jlv0v7ObE/QK1GAg0AX1RmDsZXVnqb8iEQ9g2NCbi/RUlXovahH36mey
         ckfNhAFUu+vS1t3wqidUJId4Jsc7J+pr9mNHS2oOr0tb7si3brQPcHrXEVH6kQvtBbRa
         X50QwXJcec3ytpdhk8yUZnWP/l1QKVNCSqdLeIwUBFvju6l2IiCpZc83e2G1CfSIuHIQ
         0DQw==
X-Gm-Message-State: AOAM530QvSrqqLP5rmE+pbcUGGi5gN/7y8A0Bq1iVVhA3e01q9k2Jelb
        CqLNiHxw+TrrV9YtsPZW1ZAW87yc3qUGaqZAoKiCGLH5uoEi
X-Google-Smtp-Source: ABdhPJxa//Gc+WKOl9FRpzi3LJXJE8UrJuT9/SdA1qYQQgxyKKrkmw0Wu1o3m2WZPM3xGRBtAygp/FwAw/FEMJjV0OVZy0IVgb8m
MIME-Version: 1.0
X-Received: by 2002:a02:ccc9:: with SMTP id k9mr1444397jaq.60.1634590161730;
 Mon, 18 Oct 2021 13:49:21 -0700 (PDT)
Date:   Mon, 18 Oct 2021 13:49:21 -0700
In-Reply-To: <000000000000d9b3aa05c30fce61@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f182a705cea6ad05@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in dump_schedule (2)
From:   syzbot <syzbot+a6e609c672ce997c14a8@syzkaller.appspotmail.com>
To:     chouhan.shreyansh630@gmail.com, davem@davemloft.net,
        jhs@mojatatu.com, jiri@resnulli.us, kuba@kernel.org,
        leandro.maciel.dorileo@intel.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        vedang.patel@intel.com, vinicius.gomes@intel.com,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    cf52ad5ff16c Merge tag 'driver-core-5.15-rc6' of git://git..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1028c158b00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6d3b157700b617b8
dashboard link: https://syzkaller.appspot.com/bug?extid=a6e609c672ce997c14a8
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14e85344b00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1137bcaf300000

The issue was bisected to:

commit 7b9eba7ba0c1b24df42b70b62d154b284befbccf
Author: Leandro Dorileo <leandro.maciel.dorileo@intel.com>
Date:   Mon Apr 8 17:12:17 2019 +0000

    net/sched: taprio: fix picos_per_byte miscalculation

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1261f09dd00000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1161f09dd00000
console output: https://syzkaller.appspot.com/x/log.txt?x=1661f09dd00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a6e609c672ce997c14a8@syzkaller.appspotmail.com
Fixes: 7b9eba7ba0c1 ("net/sched: taprio: fix picos_per_byte miscalculation")

==================================================================
BUG: KASAN: use-after-free in dump_schedule+0x79c/0x830 net/sched/sch_taprio.c:1841
Read of size 8 at addr ffff888079b90040 by task syz-executor038/30374

CPU: 1 PID: 30374 Comm: syz-executor038 Not tainted 5.15.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description.constprop.0.cold+0x6c/0x2d6 mm/kasan/report.c:256
 __kasan_report mm/kasan/report.c:442 [inline]
 kasan_report.cold+0x83/0xdf mm/kasan/report.c:459
 dump_schedule+0x79c/0x830 net/sched/sch_taprio.c:1841
 taprio_dump+0x53d/0xdf0 net/sched/sch_taprio.c:1910
 tc_fill_qdisc+0x60e/0x12e0 net/sched/sch_api.c:923
 qdisc_notify.isra.0+0x2b1/0x310 net/sched/sch_api.c:990
 tc_modify_qdisc+0xf85/0x1a60 net/sched/sch_api.c:1642
 rtnetlink_rcv_msg+0x413/0xb80 net/core/rtnetlink.c:5572
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2510
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1935
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:724
 sock_no_sendpage+0xf3/0x130 net/core/sock.c:2998
 kernel_sendpage.part.0+0x1a0/0x340 net/socket.c:3504
 kernel_sendpage net/socket.c:3501 [inline]
 sock_sendpage+0xe5/0x140 net/socket.c:1003
 pipe_to_sendpage+0x2ad/0x380 fs/splice.c:364
 splice_from_pipe_feed fs/splice.c:418 [inline]
 __splice_from_pipe+0x43e/0x8a0 fs/splice.c:562
 splice_from_pipe fs/splice.c:597 [inline]
 generic_splice_sendpage+0xd4/0x140 fs/splice.c:746
 do_splice_from fs/splice.c:767 [inline]
 do_splice+0xb7e/0x1960 fs/splice.c:1079
 __do_splice+0x134/0x250 fs/splice.c:1144
 __do_sys_splice fs/splice.c:1350 [inline]
 __se_sys_splice fs/splice.c:1332 [inline]
 __x64_sys_splice+0x198/0x250 fs/splice.c:1332
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f46c5794669
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 d1 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff2ed06cc8 EFLAGS: 00000246 ORIG_RAX: 0000000000000113
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f46c5794669
RDX: 0000000000000004 RSI: 0000000000000000 RDI: 0000000000000003
RBP: 0000000000000000 R08: 0000000000010976 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fff2ed06cf8
R13: 00007fff2ed06d30 R14: 00007fff2ed06d10 R15: 0000000000000e44

Allocated by task 30364:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:434 [inline]
 ____kasan_kmalloc mm/kasan/common.c:513 [inline]
 ____kasan_kmalloc mm/kasan/common.c:472 [inline]
 __kasan_kmalloc+0xa1/0xd0 mm/kasan/common.c:522
 kasan_kmalloc include/linux/kasan.h:264 [inline]
 kmem_cache_alloc_trace+0x1e4/0x480 mm/slab.c:3575
 kmalloc include/linux/slab.h:591 [inline]
 kzalloc include/linux/slab.h:721 [inline]
 taprio_change+0x5fb/0x4160 net/sched/sch_taprio.c:1477
 qdisc_change net/sched/sch_api.c:1338 [inline]
 tc_modify_qdisc+0xd9a/0x1a60 net/sched/sch_api.c:1640
 rtnetlink_rcv_msg+0x413/0xb80 net/core/rtnetlink.c:5572
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2510
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1935
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:724
 sock_no_sendpage+0xf3/0x130 net/core/sock.c:2998
 kernel_sendpage.part.0+0x1a0/0x340 net/socket.c:3504
 kernel_sendpage net/socket.c:3501 [inline]
 sock_sendpage+0xe5/0x140 net/socket.c:1003
 pipe_to_sendpage+0x2ad/0x380 fs/splice.c:364
 splice_from_pipe_feed fs/splice.c:418 [inline]
 __splice_from_pipe+0x43e/0x8a0 fs/splice.c:562
 splice_from_pipe fs/splice.c:597 [inline]
 generic_splice_sendpage+0xd4/0x140 fs/splice.c:746
 do_splice_from fs/splice.c:767 [inline]
 do_splice+0xb7e/0x1960 fs/splice.c:1079
 __do_splice+0x134/0x250 fs/splice.c:1144
 __do_sys_splice fs/splice.c:1350 [inline]
 __se_sys_splice fs/splice.c:1332 [inline]
 __x64_sys_splice+0x198/0x250 fs/splice.c:1332
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Freed by task 19:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track+0x1c/0x30 mm/kasan/common.c:46
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:360
 ____kasan_slab_free mm/kasan/common.c:366 [inline]
 ____kasan_slab_free mm/kasan/common.c:328 [inline]
 __kasan_slab_free+0xd1/0x110 mm/kasan/common.c:374
 kasan_slab_free include/linux/kasan.h:230 [inline]
 __cache_free mm/slab.c:3445 [inline]
 kfree+0x10a/0x2c0 mm/slab.c:3803
 rcu_do_batch kernel/rcu/tree.c:2508 [inline]
 rcu_core+0x7ab/0x1470 kernel/rcu/tree.c:2743
 __do_softirq+0x29b/0x9c2 kernel/softirq.c:558

Last potentially related work creation:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_record_aux_stack+0xa7/0xd0 mm/kasan/generic.c:348
 __call_rcu kernel/rcu/tree.c:2987 [inline]
 call_rcu+0xb1/0x750 kernel/rcu/tree.c:3067
 taprio_change+0x2fe5/0x4160 net/sched/sch_taprio.c:1597
 qdisc_change net/sched/sch_api.c:1338 [inline]
 tc_modify_qdisc+0xd9a/0x1a60 net/sched/sch_api.c:1640
 rtnetlink_rcv_msg+0x413/0xb80 net/core/rtnetlink.c:5572
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2510
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1935
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:724
 sock_no_sendpage+0xf3/0x130 net/core/sock.c:2998
 kernel_sendpage.part.0+0x1a0/0x340 net/socket.c:3504
 kernel_sendpage net/socket.c:3501 [inline]
 sock_sendpage+0xe5/0x140 net/socket.c:1003
 pipe_to_sendpage+0x2ad/0x380 fs/splice.c:364
 splice_from_pipe_feed fs/splice.c:418 [inline]
 __splice_from_pipe+0x43e/0x8a0 fs/splice.c:562
 splice_from_pipe fs/splice.c:597 [inline]
 generic_splice_sendpage+0xd4/0x140 fs/splice.c:746
 do_splice_from fs/splice.c:767 [inline]
 do_splice+0xb7e/0x1960 fs/splice.c:1079
 __do_splice+0x134/0x250 fs/splice.c:1144
 __do_sys_splice fs/splice.c:1350 [inline]
 __se_sys_splice fs/splice.c:1332 [inline]
 __x64_sys_splice+0x198/0x250 fs/splice.c:1332
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Second to last potentially related work creation:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_record_aux_stack+0xa7/0xd0 mm/kasan/generic.c:348
 __call_rcu kernel/rcu/tree.c:2987 [inline]
 call_rcu+0xb1/0x750 kernel/rcu/tree.c:3067
 taprio_change+0x2fe5/0x4160 net/sched/sch_taprio.c:1597
 qdisc_change net/sched/sch_api.c:1338 [inline]
 tc_modify_qdisc+0xd9a/0x1a60 net/sched/sch_api.c:1640
 rtnetlink_rcv_msg+0x413/0xb80 net/core/rtnetlink.c:5572
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2510
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1935
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:724
 sock_no_sendpage+0xf3/0x130 net/core/sock.c:2998
 kernel_sendpage.part.0+0x1a0/0x340 net/socket.c:3504
 kernel_sendpage net/socket.c:3501 [inline]
 sock_sendpage+0xe5/0x140 net/socket.c:1003
 pipe_to_sendpage+0x2ad/0x380 fs/splice.c:364
 splice_from_pipe_feed fs/splice.c:418 [inline]
 __splice_from_pipe+0x43e/0x8a0 fs/splice.c:562
 splice_from_pipe fs/splice.c:597 [inline]
 generic_splice_sendpage+0xd4/0x140 fs/splice.c:746
 do_splice_from fs/splice.c:767 [inline]
 do_splice+0xb7e/0x1960 fs/splice.c:1079
 __do_splice+0x134/0x250 fs/splice.c:1144
 __do_sys_splice fs/splice.c:1350 [inline]
 __se_sys_splice fs/splice.c:1332 [inline]
 __x64_sys_splice+0x198/0x250 fs/splice.c:1332
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

The buggy address belongs to the object at ffff888079b90000
 which belongs to the cache kmalloc-96 of size 96
The buggy address is located 64 bytes inside of
 96-byte region [ffff888079b90000, ffff888079b90060)
The buggy address belongs to the page:
page:ffffea0001e6e400 refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff888079b90f80 pfn:0x79b90
flags: 0xfff00000000200(slab|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000000200 ffffea00006bcf88 ffffea0001e3b588 ffff888010c40300
raw: ffff888079b90f80 ffff888079b90000 0000000100000006 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x242220(__GFP_HIGH|__GFP_ATOMIC|__GFP_NOWARN|__GFP_COMP|__GFP_THISNODE), pid 8434, ts 1000501276831, free_ts 996338348587
 prep_new_page mm/page_alloc.c:2424 [inline]
 get_page_from_freelist+0xa72/0x2f80 mm/page_alloc.c:4153
 __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5375
 __alloc_pages_node include/linux/gfp.h:570 [inline]
 kmem_getpages mm/slab.c:1377 [inline]
 cache_grow_begin+0x75/0x460 mm/slab.c:2593
 cache_alloc_refill+0x27f/0x380 mm/slab.c:2965
 ____cache_alloc mm/slab.c:3048 [inline]
 ____cache_alloc mm/slab.c:3031 [inline]
 __do_cache_alloc mm/slab.c:3275 [inline]
 slab_alloc mm/slab.c:3316 [inline]
 kmem_cache_alloc_trace+0x38c/0x480 mm/slab.c:3573
 kmalloc include/linux/slab.h:591 [inline]
 dst_cow_metrics_generic+0x48/0x1e0 net/core/dst.c:199
 dst_metrics_write_ptr include/net/dst.h:118 [inline]
 dst_metric_set include/net/dst.h:179 [inline]
 icmp6_dst_alloc+0x4f5/0x6c0 net/ipv6/route.c:3284
 mld_sendpack+0x56f/0xe40 net/ipv6/mcast.c:1815
 mld_send_cr net/ipv6/mcast.c:2127 [inline]
 mld_ifc_work+0x71c/0xdc0 net/ipv6/mcast.c:2659
 process_one_work+0x9bf/0x16b0 kernel/workqueue.c:2297
 worker_thread+0x658/0x11f0 kernel/workqueue.c:2444
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1338 [inline]
 free_pcp_prepare+0x2c5/0x780 mm/page_alloc.c:1389
 free_unref_page_prepare mm/page_alloc.c:3315 [inline]
 free_unref_page+0x19/0x690 mm/page_alloc.c:3394
 slab_destroy mm/slab.c:1627 [inline]
 slabs_destroy+0x89/0xc0 mm/slab.c:1647
 cache_flusharray mm/slab.c:3418 [inline]
 ___cache_free+0x4c6/0x610 mm/slab.c:3480
 qlink_free mm/kasan/quarantine.c:146 [inline]
 qlist_free_all+0x4e/0x110 mm/kasan/quarantine.c:165
 kasan_quarantine_reduce+0x180/0x200 mm/kasan/quarantine.c:272
 __kasan_slab_alloc+0x92/0xa0 mm/kasan/common.c:444
 kasan_slab_alloc include/linux/kasan.h:254 [inline]
 slab_post_alloc_hook mm/slab.h:519 [inline]
 slab_alloc mm/slab.c:3323 [inline]
 kmem_cache_alloc+0x25f/0x540 mm/slab.c:3507
 prepare_kernel_cred+0x27/0x890 kernel/cred.c:724
 call_usermodehelper_exec_async+0x10e/0x580 kernel/umh.c:91
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

Memory state around the buggy address:
 ffff888079b8ff00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888079b8ff80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff888079b90000: fa fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
                                           ^
 ffff888079b90080: fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
 ffff888079b90100: fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
==================================================================

