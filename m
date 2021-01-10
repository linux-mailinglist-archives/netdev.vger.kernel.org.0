Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABAE72F09EA
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 22:42:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbhAJVk5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 16:40:57 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:36909 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726303AbhAJVk4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jan 2021 16:40:56 -0500
Received: by mail-il1-f199.google.com with SMTP id g3so3771157ild.4
        for <netdev@vger.kernel.org>; Sun, 10 Jan 2021 13:40:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=vqRX58gw19moRyvxxVk/pkSjE/Asu+ADLfWC1WRibSs=;
        b=gpUO0/+EEpDI0EW6Swt87KCpfwnMQDJ08H3RHoqvp/0IEr6AmeQrzh9951dfc/jfxB
         QdFfu9QLy2ZGenefpdImY2yXdMb8CAWPYwaQWLhXHO7zKs/S6b41yGr7w5CYqAvubCjq
         lmMtDLWokRKojRgVce32Kc/C4O/quT8i4hQjKCo8uvX1rp6uUIKs4unsDKFeLRC3uaq3
         1xNwR1cpNxl+ECrPuf7MvveF9zP/mpmKIu7AmoG09TtLDOvRbQxk5VOZ6PiUBsLVZz/f
         AVtXalr1aHWgeV1asEvcRuzfKf7CCscQhdORIbBqQbObGXuhbrqBPRM62we7gDUFJX28
         UbAA==
X-Gm-Message-State: AOAM532Bv1q/9pt1gOnL3ha54vNNBNrkhV9OjXM/Le8Z8jNvRkT2yOLV
        ouOuB0gCqoa8ucT7O3LZ7C7WTs8wdpWhNZKOTqZovYnZDfK/
X-Google-Smtp-Source: ABdhPJy21HQLBF5eQ/hBlXueJExzdJRcuixCHDxOixvFNzhNk2ptWffZnmvrEuZ9hSbehxgcrukETy0JQd9W9PYFg9M0KT1VXdMu
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:20ee:: with SMTP id q14mr2073332ilv.259.1610314815490;
 Sun, 10 Jan 2021 13:40:15 -0800 (PST)
Date:   Sun, 10 Jan 2021 13:40:15 -0800
In-Reply-To: <000000000000f5964705b7d47d8c@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000008dd1f505b892a2a1@google.com>
Subject: Re: INFO: trying to register non-static key in l2cap_sock_teardown_cb
From:   syzbot <syzbot+a41dfef1d2e04910eb2e@syzkaller.appspotmail.com>
To:     davem@davemloft.net, hdanton@sina.com, johan.hedberg@gmail.com,
        kuba@kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, luiz.dentz@gmail.com,
        marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    73b7a604 net: dsa: bcm_sf2: support BCM4908's integrated s..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=12ec4a48d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9ce34124da4c882b
dashboard link: https://syzkaller.appspot.com/bug?extid=a41dfef1d2e04910eb2e
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=166ee4cf500000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1337172f500000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a41dfef1d2e04910eb2e@syzkaller.appspotmail.com

INFO: trying to register non-static key.
the code is fine but needs lockdep annotation.
turning off the locking correctness validator.
CPU: 0 PID: 9812 Comm: kworker/0:5 Not tainted 5.11.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events l2cap_chan_timeout
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:120
 assign_lock_key kernel/locking/lockdep.c:935 [inline]
 register_lock_class+0x1041/0x1100 kernel/locking/lockdep.c:1247
 __lock_acquire+0x101/0x54f0 kernel/locking/lockdep.c:4711
 lock_acquire kernel/locking/lockdep.c:5437 [inline]
 lock_acquire+0x29d/0x740 kernel/locking/lockdep.c:5402
 __raw_spin_lock_bh include/linux/spinlock_api_smp.h:135 [inline]
 _raw_spin_lock_bh+0x2f/0x40 kernel/locking/spinlock.c:175
 spin_lock_bh include/linux/spinlock.h:359 [inline]
 lock_sock_nested+0x3b/0x110 net/core/sock.c:3049
 l2cap_sock_teardown_cb+0xa1/0x660 net/bluetooth/l2cap_sock.c:1520
 l2cap_chan_del+0xbc/0xa80 net/bluetooth/l2cap_core.c:618
 l2cap_chan_close+0x1bc/0xaf0 net/bluetooth/l2cap_core.c:823
 l2cap_chan_timeout+0x17e/0x2f0 net/bluetooth/l2cap_core.c:436
 process_one_work+0x98d/0x15f0 kernel/workqueue.c:2275
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296
==================================================================
BUG: KASAN: use-after-free in l2cap_sock_teardown_cb+0x5c9/0x660 net/bluetooth/l2cap_sock.c:1522
Read of size 8 at addr ffff88802b6ce4c8 by task kworker/0:5/9812

CPU: 0 PID: 9812 Comm: kworker/0:5 Not tainted 5.11.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events l2cap_chan_timeout
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:120
 print_address_description.constprop.0.cold+0x5b/0x2f8 mm/kasan/report.c:230
 __kasan_report mm/kasan/report.c:396 [inline]
 kasan_report.cold+0x79/0xd5 mm/kasan/report.c:413
 l2cap_sock_teardown_cb+0x5c9/0x660 net/bluetooth/l2cap_sock.c:1522
 l2cap_chan_del+0xbc/0xa80 net/bluetooth/l2cap_core.c:618
 l2cap_chan_close+0x1bc/0xaf0 net/bluetooth/l2cap_core.c:823
 l2cap_chan_timeout+0x17e/0x2f0 net/bluetooth/l2cap_core.c:436
 process_one_work+0x98d/0x15f0 kernel/workqueue.c:2275
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296

Allocated by task 8493:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:401 [inline]
 ____kasan_kmalloc.constprop.0+0x82/0xa0 mm/kasan/common.c:429
 kmalloc_node include/linux/slab.h:575 [inline]
 kvmalloc_node+0x61/0xf0 mm/util.c:587
 kvmalloc include/linux/mm.h:781 [inline]
 xt_alloc_table_info+0x3c/0xa0 net/netfilter/x_tables.c:1176
 do_replace net/ipv6/netfilter/ip6_tables.c:1141 [inline]
 do_ip6t_set_ctl+0x4e5/0xb70 net/ipv6/netfilter/ip6_tables.c:1636
 nf_setsockopt+0x83/0xe0 net/netfilter/nf_sockopt.c:101
 ipv6_setsockopt+0x122/0x180 net/ipv6/ipv6_sockglue.c:1008
 tcp_setsockopt+0x136/0x2440 net/ipv4/tcp.c:3597
 __sys_setsockopt+0x2db/0x610 net/socket.c:2115
 __do_sys_setsockopt net/socket.c:2126 [inline]
 __se_sys_setsockopt net/socket.c:2123 [inline]
 __x64_sys_setsockopt+0xba/0x150 net/socket.c:2123
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Freed by task 8493:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track+0x1c/0x30 mm/kasan/common.c:46
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:356
 ____kasan_slab_free+0xe1/0x110 mm/kasan/common.c:362
 kasan_slab_free include/linux/kasan.h:188 [inline]
 slab_free_hook mm/slub.c:1547 [inline]
 slab_free_freelist_hook+0x5d/0x150 mm/slub.c:1580
 slab_free mm/slub.c:3142 [inline]
 kfree+0xdb/0x3b0 mm/slub.c:4124
 kvfree+0x42/0x50 mm/util.c:616
 __do_replace+0x6b7/0x8c0 net/ipv6/netfilter/ip6_tables.c:1103
 do_replace net/ipv6/netfilter/ip6_tables.c:1156 [inline]
 do_ip6t_set_ctl+0x8ec/0xb70 net/ipv6/netfilter/ip6_tables.c:1636
 nf_setsockopt+0x83/0xe0 net/netfilter/nf_sockopt.c:101
 ipv6_setsockopt+0x122/0x180 net/ipv6/ipv6_sockglue.c:1008
 tcp_setsockopt+0x136/0x2440 net/ipv4/tcp.c:3597
 __sys_setsockopt+0x2db/0x610 net/socket.c:2115
 __do_sys_setsockopt net/socket.c:2126 [inline]
 __se_sys_setsockopt net/socket.c:2123 [inline]
 __x64_sys_setsockopt+0xba/0x150 net/socket.c:2123
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

The buggy address belongs to the object at ffff88802b6ce000
 which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 1224 bytes inside of
 2048-byte region [ffff88802b6ce000, ffff88802b6ce800)
The buggy address belongs to the page:
page:0000000055ddf779 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x2b6c8
head:0000000055ddf779 order:3 compound_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head)
raw: 00fff00000010200 dead000000000100 dead000000000122 ffff888010042000
raw: 0000000000000000 0000000000080008 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88802b6ce380: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88802b6ce400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff88802b6ce480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                              ^
 ffff88802b6ce500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88802b6ce580: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================

