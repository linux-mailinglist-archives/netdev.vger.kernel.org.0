Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3769640B603
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 19:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231438AbhINRit (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 13:38:49 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:35673 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbhINRiq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 13:38:46 -0400
Received: by mail-io1-f70.google.com with SMTP id g14-20020a6be60e000000b005b62a0c2a41so16856249ioh.2
        for <netdev@vger.kernel.org>; Tue, 14 Sep 2021 10:37:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=haN4VzRdJcgeC8n7ixJZsEGYZMjAa0jSxAQnlydaCsQ=;
        b=exUWhe0MxmPIXaDoe0R4Twy0o3+ppuZCrMGKmf7uRiCbsq6mclfMqLrbk4wtOWk10r
         geSZEPP8SNJncWRTuW01Gy4ld52o+FMHsB4qMTFveW1wMCtJTzk007L/8ctqfUun/DEL
         ypYeA8wcpXG/3OmnknmKrSeKBzLxWJC9LTrf8pzSZQgOLrVBpu8w5e6Hx1Rg90EEpWmf
         Dt/NveeUxgYn0uAmekq0St0CQ4g0JrG+C5sjrbdX0NWzIOtbTfv8FC/sUyelxsHCrA3n
         Gfaa/hZ8tIjOKj66VxGr5ipHe7CJVTxTlkskxYABlAhQ4vd2LnA0eZrWcJrYRt1NnOOt
         KEzw==
X-Gm-Message-State: AOAM5332QfbHCjXksi68fu6y2xeiT+sdIzDZHdjAJrDhPiaGs6WBOxen
        3VDSXsFVTuHdYJmkXIzkfRDe3q368IH+/a3Lt5FSfcj7qwsR
X-Google-Smtp-Source: ABdhPJxBXgqV5p+WXfOOi/irAItn8l8cR0niAPeE+KiIyHFKXn1wDJQZqyuH8cMUbs2NpymM4b95hrTo85qTIZOWYW2Z+rXGnw6o
MIME-Version: 1.0
X-Received: by 2002:a5d:8458:: with SMTP id w24mr14452905ior.168.1631641048521;
 Tue, 14 Sep 2021 10:37:28 -0700 (PDT)
Date:   Tue, 14 Sep 2021 10:37:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000019203305cbf809cf@google.com>
Subject: [syzbot] KASAN: use-after-free Write in sco_conn_del
From:   syzbot <syzbot+ba12d3e3c460f3c1d1e0@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        luiz.dentz@gmail.com, marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    aa14a3016182 Add linux-next specific files for 20210910
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=15982715300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e400f2d70a0ed309
dashboard link: https://syzkaller.appspot.com/bug?extid=ba12d3e3c460f3c1d1e0
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ba12d3e3c460f3c1d1e0@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in instrument_atomic_read_write include/linux/instrumented.h:101 [inline]
BUG: KASAN: use-after-free in atomic_fetch_add_relaxed include/linux/atomic/atomic-instrumented.h:111 [inline]
BUG: KASAN: use-after-free in __refcount_add include/linux/refcount.h:193 [inline]
BUG: KASAN: use-after-free in __refcount_inc include/linux/refcount.h:250 [inline]
BUG: KASAN: use-after-free in refcount_inc include/linux/refcount.h:267 [inline]
BUG: KASAN: use-after-free in sock_hold include/net/sock.h:702 [inline]
BUG: KASAN: use-after-free in sco_conn_del+0xbe/0x2c0 net/bluetooth/sco.c:193
Write of size 4 at addr ffff888080fb7080 by task syz-executor.0/2780

CPU: 0 PID: 2780 Comm: syz-executor.0 Not tainted 5.14.0-next-20210910-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description.constprop.0.cold+0x6c/0x309 mm/kasan/report.c:256
 __kasan_report mm/kasan/report.c:442 [inline]
 kasan_report.cold+0x83/0xdf mm/kasan/report.c:459
 check_region_inline mm/kasan/generic.c:183 [inline]
 kasan_check_range+0x13d/0x180 mm/kasan/generic.c:189
 instrument_atomic_read_write include/linux/instrumented.h:101 [inline]
 atomic_fetch_add_relaxed include/linux/atomic/atomic-instrumented.h:111 [inline]
 __refcount_add include/linux/refcount.h:193 [inline]
 __refcount_inc include/linux/refcount.h:250 [inline]
 refcount_inc include/linux/refcount.h:267 [inline]
 sock_hold include/net/sock.h:702 [inline]
 sco_conn_del+0xbe/0x2c0 net/bluetooth/sco.c:193
 sco_disconn_cfm+0x71/0xb0 net/bluetooth/sco.c:1384
 hci_disconn_cfm include/net/bluetooth/hci_core.h:1541 [inline]
 hci_conn_hash_flush+0x127/0x260 net/bluetooth/hci_conn.c:1742
 hci_dev_do_close+0x57d/0x1150 net/bluetooth/hci_core.c:1796
 hci_rfkill_set_block+0x19c/0x1d0 net/bluetooth/hci_core.c:2237
 rfkill_set_block+0x1f9/0x540 net/rfkill/core.c:344
 rfkill_fop_write+0x267/0x500 net/rfkill/core.c:1268
 vfs_write+0x28e/0xae0 fs/read_write.c:592
 ksys_write+0x1ee/0x250 fs/read_write.c:647
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4665f9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f65b5bc0188 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 000000000056c038 RCX: 00000000004665f9
RDX: 0000000000000008 RSI: 0000000020000040 RDI: 0000000000000004
RBP: 00000000004bfcc4 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056c038
R13: 00007ffed0072e9f R14: 00007f65b5bc0300 R15: 0000000000022000

Allocated by task 31886:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:434 [inline]
 ____kasan_kmalloc mm/kasan/common.c:513 [inline]
 ____kasan_kmalloc mm/kasan/common.c:472 [inline]
 __kasan_kmalloc+0xa4/0xd0 mm/kasan/common.c:522
 kmalloc include/linux/slab.h:599 [inline]
 kzalloc include/linux/slab.h:731 [inline]
 __reuseport_alloc+0x1b/0x90 net/core/sock_reuseport.c:94
 reuseport_alloc+0x1c1/0x370 net/core/sock_reuseport.c:136
 reuseport_attach_prog+0x1bb/0x300 net/core/sock_reuseport.c:595
 sk_reuseport_attach_filter+0xd1/0x230 net/core/filter.c:1554
 sock_setsockopt+0x110b/0x2520 net/core/sock.c:1185
 __sys_setsockopt+0x4f8/0x610 net/socket.c:2172
 __do_sys_setsockopt net/socket.c:2187 [inline]
 __se_sys_setsockopt net/socket.c:2184 [inline]
 __x64_sys_setsockopt+0xba/0x150 net/socket.c:2184
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Last potentially related work creation:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_record_aux_stack+0xe9/0x110 mm/kasan/generic.c:348
 __call_rcu kernel/rcu/tree.c:2985 [inline]
 call_rcu+0xb1/0x740 kernel/rcu/tree.c:3065
 reuseport_detach_sock+0x28f/0x4a0 net/core/sock_reuseport.c:370
 sk_destruct+0x7a/0xe0 net/core/sock.c:1951
 __sk_free+0xef/0x3d0 net/core/sock.c:1969
 sk_free+0x78/0xa0 net/core/sock.c:1980
 sock_put include/net/sock.h:1815 [inline]
 tcp_close+0x98/0xc0 net/ipv4/tcp.c:2883
 inet_release+0x12e/0x280 net/ipv4/af_inet.c:431
 __sock_release+0xcd/0x280 net/socket.c:649
 sock_close+0x18/0x20 net/socket.c:1314
 __fput+0x288/0x9f0 fs/file_table.c:280
 task_work_run+0xdd/0x1a0 kernel/task_work.c:164
 tracehook_notify_resume include/linux/tracehook.h:189 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:175 [inline]
 exit_to_user_mode_prepare+0x27e/0x290 kernel/entry/common.c:209
 __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:302
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Second to last potentially related work creation:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_record_aux_stack+0xe9/0x110 mm/kasan/generic.c:348
 __call_rcu kernel/rcu/tree.c:2985 [inline]
 call_rcu+0xb1/0x740 kernel/rcu/tree.c:3065
 netlink_release+0xdd4/0x1dd0 net/netlink/af_netlink.c:812
 __sock_release net/socket.c:649 [inline]
 sock_release+0x87/0x1b0 net/socket.c:677
 netlink_kernel_release+0x4b/0x60 net/netlink/af_netlink.c:2117
 xfrm_user_net_exit+0x62/0xb0 net/xfrm/xfrm_user.c:3560
 ops_exit_list+0x10d/0x160 net/core/net_namespace.c:171
 cleanup_net+0x4ea/0xb00 net/core/net_namespace.c:591
 process_one_work+0x9b2/0x1690 kernel/workqueue.c:2297
 worker_thread+0x658/0x11f0 kernel/workqueue.c:2444
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

The buggy address belongs to the object at ffff888080fb7000
 which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 128 bytes inside of
 2048-byte region [ffff888080fb7000, ffff888080fb7800)
The buggy address belongs to the page:
page:ffffea000203ec00 refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff888080fb1000 pfn:0x80fb0
head:ffffea000203ec00 order:3 compound_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 ffffea000213b208 ffffea00020ea008 ffff888010c42000
raw: ffff888080fb1000 0000000000080005 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 6566, ts 196075656127, free_ts 0
 prep_new_page mm/page_alloc.c:2424 [inline]
 get_page_from_freelist+0xa72/0x2f80 mm/page_alloc.c:4153
 __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5375
 alloc_pages+0x1a7/0x300 mm/mempolicy.c:2197
 alloc_slab_page mm/slub.c:1763 [inline]
 allocate_slab mm/slub.c:1900 [inline]
 new_slab+0x319/0x490 mm/slub.c:1963
 ___slab_alloc+0x921/0xfe0 mm/slub.c:2994
 __slab_alloc.constprop.0+0x4d/0xa0 mm/slub.c:3081
 slab_alloc_node mm/slub.c:3172 [inline]
 slab_alloc mm/slub.c:3214 [inline]
 __kmalloc+0x305/0x320 mm/slub.c:4387
 kmalloc_array include/linux/slab.h:636 [inline]
 kcalloc include/linux/slab.h:667 [inline]
 veth_alloc_queues drivers/net/veth.c:1314 [inline]
 veth_dev_init+0x114/0x2e0 drivers/net/veth.c:1341
 register_netdevice+0x51e/0x1500 net/core/dev.c:10225
 veth_newlink+0x58c/0xb20 drivers/net/veth.c:1726
 __rtnl_newlink+0x106d/0x1750 net/core/rtnetlink.c:3458
 rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3506
 rtnetlink_rcv_msg+0x413/0xb80 net/core/rtnetlink.c:5572
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
page_owner free stack trace missing

Memory state around the buggy address:
 ffff888080fb6f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888080fb7000: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff888080fb7080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                   ^
 ffff888080fb7100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888080fb7180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
