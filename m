Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADB822C9F42
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 11:33:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbgLAKbF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 05:31:05 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:51459 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729904AbgLAKbF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 05:31:05 -0500
Received: by mail-io1-f69.google.com with SMTP id h206so951249iof.18
        for <netdev@vger.kernel.org>; Tue, 01 Dec 2020 02:30:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=d7M+NKlCF9pjVVnPz94y4zGxYLT2FaaBIfAbvboyFIc=;
        b=ho3AkktFXF9cnVW999qctJRxQu4QXSde5cUc6lZ1HNAEqG6asmqTfv16bmvac9nEZO
         +6mQr0VgYpQH5EnnPXuptOgEvBwHrfPNSv8mUcBAyi+BsSw/atOrnqmOO+Otq+6JMj/z
         J9PxUhtPKHiAVKBxj26htQU3UXWAEyVZgR7G2JzUryvcsnN7joeJUNxj/kDC8X2OLtPK
         tREqzklWMQ6PFh/bZTL/DvXR8umaOsWSuQyOL02KjOOIg3iMAl1fI9NEk1JWi6J88a5s
         breP01lh0/25/XDncupwOZFN9OIB1uLD6GtBWu1zRMov5z2P7cuevoSN05uUGl4Cm+hE
         mO9w==
X-Gm-Message-State: AOAM533YteQfbSsPBPdK0dtLZaWaXaxcpFnHdyD0segcYfsbZRFvlJFI
        urenD98NssuTyITce10yyfrRmjJi1YufZshtRZu7FcnBnmfs
X-Google-Smtp-Source: ABdhPJwZTAyP00p2Op4WegyA8Tipw+xnSzukaJVz/NM4Lbdv4XET1Vlhx/hRAmqvRRfs1mPIQJOruL60VUaL/GCu942CmdVZjT88
MIME-Version: 1.0
X-Received: by 2002:a5d:9942:: with SMTP id v2mr1782431ios.78.1606818618093;
 Tue, 01 Dec 2020 02:30:18 -0800 (PST)
Date:   Tue, 01 Dec 2020 02:30:18 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f335f205b5649c70@google.com>
Subject: KASAN: out-of-bounds Read in lock_sock_nested
From:   syzbot <syzbot+664818c59309176d03ee@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    fb3158ea Merge branch 'add-chacha20-poly1305-cipher-to-ker..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=159594e9500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=df65150a33f23d8c
dashboard link: https://syzkaller.appspot.com/bug?extid=664818c59309176d03ee
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+664818c59309176d03ee@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: out-of-bounds in __lock_acquire+0x400f/0x5c00 kernel/locking/lockdep.c:4700
Read of size 8 at addr ffff8880687ab0a0 by task kworker/1:4/9766

CPU: 1 PID: 9766 Comm: kworker/1:4 Not tainted 5.10.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events l2cap_chan_timeout
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xae/0x4c8 mm/kasan/report.c:385
 __kasan_report mm/kasan/report.c:545 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:562
 __lock_acquire+0x400f/0x5c00 kernel/locking/lockdep.c:4700
 lock_acquire kernel/locking/lockdep.c:5435 [inline]
 lock_acquire+0x2a3/0x8c0 kernel/locking/lockdep.c:5400
 __raw_spin_lock_bh include/linux/spinlock_api_smp.h:135 [inline]
 _raw_spin_lock_bh+0x2f/0x40 kernel/locking/spinlock.c:175
 spin_lock_bh include/linux/spinlock.h:359 [inline]
 lock_sock_nested+0x3b/0x110 net/core/sock.c:3036
 l2cap_sock_teardown_cb+0xa1/0x660 net/bluetooth/l2cap_sock.c:1520
 l2cap_chan_del+0xbc/0xa80 net/bluetooth/l2cap_core.c:618
 l2cap_chan_close+0x1bc/0xaf0 net/bluetooth/l2cap_core.c:823
 l2cap_chan_timeout+0x17e/0x2f0 net/bluetooth/l2cap_core.c:436
 process_one_work+0x933/0x15a0 kernel/workqueue.c:2272
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2418
 kthread+0x3af/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296

Allocated by task 21553:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc.constprop.0+0xc2/0xd0 mm/kasan/common.c:461
 kmalloc include/linux/slab.h:557 [inline]
 sk_prot_alloc+0x17a/0x300 net/core/sock.c:1666
 sk_alloc+0x32/0xbd0 net/core/sock.c:1720
 __netlink_create+0x63/0x340 net/netlink/af_netlink.c:630
 netlink_create+0x3a1/0x5d0 net/netlink/af_netlink.c:693
 __sock_create+0x3de/0x780 net/socket.c:1405
 sock_create net/socket.c:1456 [inline]
 __sys_socket+0xef/0x200 net/socket.c:1498
 __do_sys_socket net/socket.c:1507 [inline]
 __se_sys_socket net/socket.c:1505 [inline]
 __x64_sys_socket+0x6f/0xb0 net/socket.c:1505
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Last call_rcu():
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_record_aux_stack+0xc0/0xf0 mm/kasan/generic.c:346
 __call_rcu kernel/rcu/tree.c:2953 [inline]
 call_rcu+0xbb/0x700 kernel/rcu/tree.c:3027
 netlink_release+0xd43/0x1cf0 net/netlink/af_netlink.c:802
 __sock_release+0xcd/0x280 net/socket.c:596
 sock_close+0x18/0x20 net/socket.c:1255
 __fput+0x285/0x920 fs/file_table.c:281
 task_work_run+0xdd/0x190 kernel/task_work.c:151
 tracehook_notify_resume include/linux/tracehook.h:188 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:164 [inline]
 exit_to_user_mode_prepare+0x17e/0x1a0 kernel/entry/common.c:191
 syscall_exit_to_user_mode+0x38/0x260 kernel/entry/common.c:266
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

The buggy address belongs to the object at ffff8880687ab000
 which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 160 bytes inside of
 2048-byte region [ffff8880687ab000, ffff8880687ab800)
The buggy address belongs to the page:
page:00000000f09df1cc refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x687a8
head:00000000f09df1cc order:3 compound_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head)
raw: 00fff00000010200 dead000000000100 dead000000000122 ffff888010042000
raw: 0000000000000000 0000000000080008 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8880687aaf80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff8880687ab000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff8880687ab080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                               ^
 ffff8880687ab100: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff8880687ab180: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
