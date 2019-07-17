Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 452D46B8B8
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 11:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729374AbfGQI6I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 04:58:08 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:53560 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbfGQI6H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jul 2019 04:58:07 -0400
Received: by mail-io1-f69.google.com with SMTP id h3so26407796iob.20
        for <netdev@vger.kernel.org>; Wed, 17 Jul 2019 01:58:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=j6y32OJPWourfE4drRSdflRccTKGtBjM7b1HH25HQhc=;
        b=DbcbUCQtd8yzM16FrzQROwmmNScFrErJmNEsYUo7qoznBmG0FdlQs9Mxr4T0oT4PGV
         fvngntQUvvy3T5IaiKKYZdop6BCvfhUUpiRiK8us23qxnnhLS9OTv2isAuo7QsnKEi8J
         7qRFI4I0gKl5TLphf4Ynsx3We08xVUc4AdRXRwogVOzlLozQqP2Cowu9cD94hJ3dE2F4
         pNm5kzgs3KPHKhwAyfd9xe48DeMmIf1io46PCXnxTUJ8BXYordl3QufoRbaBOLJw4pT5
         HxW8TzdFcYjem7U5NFjt6k0yCh0EAT7shkSEZL63jVHld7vOf0sdAu2HLGoqZTFdLW/E
         esUg==
X-Gm-Message-State: APjAAAXZJvG8oDyJqrkRQ+e29Rqe19zcRA255mrwLhhQH7etX5kD7Y4C
        B4jg2FFVC0AuvlYDccJNsuZQ4ahCfAP5K9HZbVGXjARiTWuD
X-Google-Smtp-Source: APXvYqy1NCmoglbmmEAsNgNifu1CY90YIrXe+oNUErPBYbJ/PlTbwfrEJH6eHVLKmyedcnxfYAX4sXRMNA8vECUomYEvaZEd3/1H
MIME-Version: 1.0
X-Received: by 2002:a02:b710:: with SMTP id g16mr39633583jam.88.1563353886870;
 Wed, 17 Jul 2019 01:58:06 -0700 (PDT)
Date:   Wed, 17 Jul 2019 01:58:06 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000015d943058ddcb1b3@google.com>
Subject: WARNING: held lock freed in nr_release
From:   syzbot <syzbot+a34e5f3d0300163f0c87@syzkaller.appspotmail.com>
To:     davem@davemloft.net, linux-hams@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        ralf@linux-mips.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    3eb51486 Merge tag 'arc-5.3-rc1' of git://git.kernel.org/p..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=144104d0600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1044f14a33f8bb44
dashboard link: https://syzkaller.appspot.com/bug?extid=a34e5f3d0300163f0c87
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=174ef948600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12475834600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+a34e5f3d0300163f0c87@syzkaller.appspotmail.com

=========================
WARNING: held lock freed!
5.2.0+ #66 Not tainted
-------------------------
syz-executor290/9125 is freeing memory ffff8880936e02c0-ffff8880936e0abf,  
with a lock still held there!
000000005bf1c8ae (sk_lock-AF_NETROM){+.+.}, at: lock_sock  
include/net/sock.h:1522 [inline]
000000005bf1c8ae (sk_lock-AF_NETROM){+.+.}, at: nr_release+0x130/0x3e0  
net/netrom/af_netrom.c:522
2 locks held by syz-executor290/9125:
  #0: 0000000027c540ab (&sb->s_type->i_mutex_key#12){+.+.}, at: inode_lock  
include/linux/fs.h:778 [inline]
  #0: 0000000027c540ab (&sb->s_type->i_mutex_key#12){+.+.}, at:  
__sock_release+0x89/0x280 net/socket.c:585
  #1: 000000005bf1c8ae (sk_lock-AF_NETROM){+.+.}, at: lock_sock  
include/net/sock.h:1522 [inline]
  #1: 000000005bf1c8ae (sk_lock-AF_NETROM){+.+.}, at: nr_release+0x130/0x3e0  
net/netrom/af_netrom.c:522

stack backtrace:
CPU: 0 PID: 9125 Comm: syz-executor290 Not tainted 5.2.0+ #66
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  print_freed_lock_bug kernel/locking/lockdep.c:5185 [inline]
  debug_check_no_locks_freed.cold+0x9d/0xa9 kernel/locking/lockdep.c:5218
  kfree+0xec/0x2c0 mm/slab.c:3753
  sk_prot_free net/core/sock.c:1640 [inline]
  __sk_destruct+0x4f7/0x6e0 net/core/sock.c:1726
  sk_destruct+0x86/0xa0 net/core/sock.c:1734
  __sk_free+0xfb/0x360 net/core/sock.c:1745
  sk_free+0x42/0x50 net/core/sock.c:1756
  sock_put include/net/sock.h:1725 [inline]
  nr_destroy_socket+0x3ea/0x4b0 net/netrom/af_netrom.c:288
  nr_release+0x347/0x3e0 net/netrom/af_netrom.c:530
  __sock_release+0xce/0x280 net/socket.c:586
  sock_close+0x1e/0x30 net/socket.c:1264
  __fput+0x2ff/0x890 fs/file_table.c:280
  ____fput+0x16/0x20 fs/file_table.c:313
  task_work_run+0x145/0x1c0 kernel/task_work.c:113
  exit_task_work include/linux/task_work.h:22 [inline]
  do_exit+0x904/0x2eb0 kernel/exit.c:877
  do_group_exit+0x135/0x370 kernel/exit.c:981
  get_signal+0x48a/0x2510 kernel/signal.c:2728
  do_signal+0x87/0x1670 arch/x86/kernel/signal.c:815
  exit_to_usermode_loop+0x286/0x380 arch/x86/entry/common.c:159
  prepare_exit_to_usermode arch/x86/entry/common.c:194 [inline]
  syscall_return_slowpath arch/x86/entry/common.c:274 [inline]
  do_syscall_64+0x5a9/0x6a0 arch/x86/entry/common.c:299
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x442609
Code: Bad RIP value.
RSP: 002b:00007ffc16869ec8 EFLAGS: 00000246 ORIG_RAX: 000000000000002b
RAX: 0000000000000003 RBX: 0000000000000003 RCX: 0000000000442609
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000004
RBP: 0000000000017e2c R08: 0000000000000003 R09: 0000000400000009
R10: 0000000400000009 R11: 0000000000000246 R12: 0000000000403440
R13: 00000000004034d0 R14: 0000000000000000 R15: 0000000000000000
==================================================================
BUG: KASAN: use-after-free in debug_spin_lock_before  
kernel/locking/spinlock_debug.c:83 [inline]
BUG: KASAN: use-after-free in do_raw_spin_lock+0x28a/0x2e0  
kernel/locking/spinlock_debug.c:112
Read of size 4 at addr ffff8880936e034c by task syz-executor290/9125

CPU: 0 PID: 9125 Comm: syz-executor290 Not tainted 5.2.0+ #66
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  print_address_description.cold+0xd4/0x306 mm/kasan/report.c:351
  __kasan_report.cold+0x1b/0x36 mm/kasan/report.c:482
  kasan_report+0x12/0x20 mm/kasan/common.c:612
  __asan_report_load4_noabort+0x14/0x20 mm/kasan/generic_report.c:131
  debug_spin_lock_before kernel/locking/spinlock_debug.c:83 [inline]
  do_raw_spin_lock+0x28a/0x2e0 kernel/locking/spinlock_debug.c:112
  __raw_spin_lock_bh include/linux/spinlock_api_smp.h:136 [inline]
  _raw_spin_lock_bh+0x3b/0x50 kernel/locking/spinlock.c:175
  spin_lock_bh include/linux/spinlock.h:343 [inline]
  release_sock+0x20/0x1c0 net/core/sock.c:2932
  nr_release+0x303/0x3e0 net/netrom/af_netrom.c:553
  __sock_release+0xce/0x280 net/socket.c:586
  sock_close+0x1e/0x30 net/socket.c:1264
  __fput+0x2ff/0x890 fs/file_table.c:280
  ____fput+0x16/0x20 fs/file_table.c:313
  task_work_run+0x145/0x1c0 kernel/task_work.c:113
  exit_task_work include/linux/task_work.h:22 [inline]
  do_exit+0x904/0x2eb0 kernel/exit.c:877
  do_group_exit+0x135/0x370 kernel/exit.c:981
  get_signal+0x48a/0x2510 kernel/signal.c:2728
  do_signal+0x87/0x1670 arch/x86/kernel/signal.c:815
  exit_to_usermode_loop+0x286/0x380 arch/x86/entry/common.c:159
  prepare_exit_to_usermode arch/x86/entry/common.c:194 [inline]
  syscall_return_slowpath arch/x86/entry/common.c:274 [inline]
  do_syscall_64+0x5a9/0x6a0 arch/x86/entry/common.c:299
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x442609
Code: Bad RIP value.
RSP: 002b:00007ffc16869ec8 EFLAGS: 00000246 ORIG_RAX: 000000000000002b
RAX: 0000000000000003 RBX: 0000000000000003 RCX: 0000000000442609
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000004
RBP: 0000000000017e2c R08: 0000000000000003 R09: 0000000400000009
R10: 0000000400000009 R11: 0000000000000246 R12: 0000000000403440
R13: 00000000004034d0 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 9130:
  save_stack+0x23/0x90 mm/kasan/common.c:69
  set_track mm/kasan/common.c:77 [inline]
  __kasan_kmalloc mm/kasan/common.c:487 [inline]
  __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:460
  kasan_kmalloc+0x9/0x10 mm/kasan/common.c:501
  __do_kmalloc mm/slab.c:3655 [inline]
  __kmalloc+0x163/0x780 mm/slab.c:3664
  kmalloc include/linux/slab.h:557 [inline]
  sk_prot_alloc+0x23a/0x310 net/core/sock.c:1603
  sk_alloc+0x39/0xf70 net/core/sock.c:1657
  nr_make_new net/netrom/af_netrom.c:476 [inline]
  nr_rx_frame+0x733/0x1e80 net/netrom/af_netrom.c:959
  nr_loopback_timer+0x7b/0x170 net/netrom/nr_loopback.c:59
  call_timer_fn+0x1ac/0x780 kernel/time/timer.c:1322
  expire_timers kernel/time/timer.c:1366 [inline]
  __run_timers kernel/time/timer.c:1685 [inline]
  __run_timers kernel/time/timer.c:1653 [inline]
  run_timer_softirq+0x697/0x17a0 kernel/time/timer.c:1698
  __do_softirq+0x262/0x98c kernel/softirq.c:292

Freed by task 9125:
  save_stack+0x23/0x90 mm/kasan/common.c:69
  set_track mm/kasan/common.c:77 [inline]
  __kasan_slab_free+0x102/0x150 mm/kasan/common.c:449
  kasan_slab_free+0xe/0x10 mm/kasan/common.c:457
  __cache_free mm/slab.c:3425 [inline]
  kfree+0x10a/0x2c0 mm/slab.c:3756
  sk_prot_free net/core/sock.c:1640 [inline]
  __sk_destruct+0x4f7/0x6e0 net/core/sock.c:1726
  sk_destruct+0x86/0xa0 net/core/sock.c:1734
  __sk_free+0xfb/0x360 net/core/sock.c:1745
  sk_free+0x42/0x50 net/core/sock.c:1756
  sock_put include/net/sock.h:1725 [inline]
  nr_destroy_socket+0x3ea/0x4b0 net/netrom/af_netrom.c:288
  nr_release+0x347/0x3e0 net/netrom/af_netrom.c:530
  __sock_release+0xce/0x280 net/socket.c:586
  sock_close+0x1e/0x30 net/socket.c:1264
  __fput+0x2ff/0x890 fs/file_table.c:280
  ____fput+0x16/0x20 fs/file_table.c:313
  task_work_run+0x145/0x1c0 kernel/task_work.c:113
  exit_task_work include/linux/task_work.h:22 [inline]
  do_exit+0x904/0x2eb0 kernel/exit.c:877
  do_group_exit+0x135/0x370 kernel/exit.c:981
  get_signal+0x48a/0x2510 kernel/signal.c:2728
  do_signal+0x87/0x1670 arch/x86/kernel/signal.c:815
  exit_to_usermode_loop+0x286/0x380 arch/x86/entry/common.c:159
  prepare_exit_to_usermode arch/x86/entry/common.c:194 [inline]
  syscall_return_slowpath arch/x86/entry/common.c:274 [inline]
  do_syscall_64+0x5a9/0x6a0 arch/x86/entry/common.c:299
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff8880936e02c0
  which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 140 bytes inside of
  2048-byte region [ffff8880936e02c0, ffff8880936e0ac0)
The buggy address belongs to the page:
page:ffffea00024db800 refcount:1 mapcount:0 mapping:ffff8880aa400e00  
index:0x0 compound_mapcount: 0
flags: 0x1fffc0000010200(slab|head)
raw: 01fffc0000010200 ffffea000257f988 ffffea00024ef988 ffff8880aa400e00
raw: 0000000000000000 ffff8880936e02c0 0000000100000003 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff8880936e0200: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
  ffff8880936e0280: fc fc fc fc fc fc fc fc fb fb fb fb fb fb fb fb
> ffff8880936e0300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                               ^
  ffff8880936e0380: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff8880936e0400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
