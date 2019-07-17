Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A83D6BF78
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 18:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbfGQQLI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 12:11:08 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:54860 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726880AbfGQQLH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jul 2019 12:11:07 -0400
Received: by mail-io1-f70.google.com with SMTP id n8so27542635ioo.21
        for <netdev@vger.kernel.org>; Wed, 17 Jul 2019 09:11:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=rznHhz6UR9RpcHcT8XfZrhnFDIOeYCD490okbjUsAYw=;
        b=pO4WLYb0D2+xkNdpUZS5ORuKLN+KgIbPrC75HM27F1Y22ZZaORV1SfJWDJjkTfuKd2
         yTws+Foc4kI1C14HksF/kyA5sfuqdAYy8idvOT+6KrbMzdQ2gSG1RyymQG3WIU0g06pG
         xnjaS+1c7ZrdO0h06EE6smNtgolfU4J/jMXE8niMsZDb6cLzGlRsylkrd84kwhhr3N5o
         FJ4b7iG/+6UdAE0SX0adCSySNPpa9+Kqr7HGjoee41igKetm6pyZiYpP/wcwwztEffB7
         rGNr/Hene6fkq96IyZy0LjNRAF6dhR8GVDYYw+8R3DwBKD4rup2rAhpsAQ9sDfBzKHXq
         TgDw==
X-Gm-Message-State: APjAAAWU0XJN+8fN70+7QXOCLtM7XJ/vX31gLR64v8Y2EE5FoyYfB9UR
        jopNR6rRkhA870t2+ih6++2ljJbA5EzJ6krInsOr6A5hD18Q
X-Google-Smtp-Source: APXvYqwACPBpbV5wsPYyMzDE22X/uYrItnCT7cPC7RRmKv7ql5SOAaGnJ2LdB1Am7yion4/QROwFTRRea0vjnu7JCJ9ggW6p9nLn
MIME-Version: 1.0
X-Received: by 2002:a02:2245:: with SMTP id o66mr11641188jao.53.1563379866525;
 Wed, 17 Jul 2019 09:11:06 -0700 (PDT)
Date:   Wed, 17 Jul 2019 09:11:06 -0700
In-Reply-To: <0000000000007e8b70058acbd60f@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000097ea0e058de2bd2d@google.com>
Subject: Re: KASAN: use-after-free Read in nr_release
From:   syzbot <syzbot+6eaef7158b19e3fec3a0@syzkaller.appspotmail.com>
To:     davem@davemloft.net, hdanton@sina.com, linux-hams@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        ralf@linux-mips.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    192f0f8e Merge tag 'powerpc-5.3-1' of git://git.kernel.org..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=171bde00600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=87305c3ca9c25c70
dashboard link: https://syzkaller.appspot.com/bug?extid=6eaef7158b19e3fec3a0
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15882cd0600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+6eaef7158b19e3fec3a0@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in atomic_read  
/./include/asm-generic/atomic-instrumented.h:26 [inline]
BUG: KASAN: use-after-free in refcount_inc_not_zero_checked+0x81/0x200  
/lib/refcount.c:123
Read of size 4 at addr ffff88807be6b6c0 by task syz-executor.0/11548

CPU: 0 PID: 11548 Comm: syz-executor.0 Not tainted 5.2.0+ #66
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack /lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 /lib/dump_stack.c:113
  print_address_description.cold+0xd4/0x306 /mm/kasan/report.c:351
  __kasan_report.cold+0x1b/0x36 /mm/kasan/report.c:482
  kasan_report+0x12/0x20 /mm/kasan/common.c:612
  check_memory_region_inline /mm/kasan/generic.c:185 [inline]
  check_memory_region+0x134/0x1a0 /mm/kasan/generic.c:192
  __kasan_check_read+0x11/0x20 /mm/kasan/common.c:92
  atomic_read /./include/asm-generic/atomic-instrumented.h:26 [inline]
  refcount_inc_not_zero_checked+0x81/0x200 /lib/refcount.c:123
  refcount_inc_checked+0x17/0x70 /lib/refcount.c:156
  sock_hold /./include/net/sock.h:649 [inline]
  nr_release+0x62/0x3e0 /net/netrom/af_netrom.c:520
  __sock_release+0xce/0x280 /net/socket.c:586
  sock_close+0x1e/0x30 /net/socket.c:1264
  __fput+0x2ff/0x890 /fs/file_table.c:280
  ____fput+0x16/0x20 /fs/file_table.c:313
  task_work_run+0x145/0x1c0 /kernel/task_work.c:113
  tracehook_notify_resume /./include/linux/tracehook.h:185 [inline]
  exit_to_usermode_loop+0x316/0x380 /arch/x86/entry/common.c:163
  prepare_exit_to_usermode /arch/x86/entry/common.c:194 [inline]
  syscall_return_slowpath /arch/x86/entry/common.c:274 [inline]
  do_syscall_64+0x5a9/0x6a0 /arch/x86/entry/common.c:299
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x413501
Code: 75 14 b8 03 00 00 00 0f 05 48 3d 01 f0 ff ff 0f 83 04 1b 00 00 c3 48  
83 ec 08 e8 0a fc ff ff 48 89 04 24 b8 03 00 00 00 0f 05 <48> 8b 3c 24 48  
89 c2 e8 53 fc ff ff 48 89 d0 48 83 c4 08 48 3d 01
RSP: 002b:00007ffe5eb40550 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000004 RCX: 0000000000413501
RDX: 0000001b2be20000 RSI: 0000000000000000 RDI: 0000000000000003
RBP: 0000000000000001 R08: ffffffffffffffff R09: ffffffffffffffff
R10: 00007ffe5eb40630 R11: 0000000000000293 R12: 000000000075c9a0
R13: 000000000075c9a0 R14: 0000000000760a68 R15: ffffffffffffffff

Allocated by task 0:
  save_stack+0x23/0x90 /mm/kasan/common.c:69
  set_track /mm/kasan/common.c:77 [inline]
  __kasan_kmalloc /mm/kasan/common.c:487 [inline]
  __kasan_kmalloc.constprop.0+0xcf/0xe0 /mm/kasan/common.c:460
  kasan_kmalloc+0x9/0x10 /mm/kasan/common.c:501
  __do_kmalloc /mm/slab.c:3655 [inline]
  __kmalloc+0x163/0x780 /mm/slab.c:3664
  kmalloc /./include/linux/slab.h:557 [inline]
  sk_prot_alloc+0x23a/0x310 /net/core/sock.c:1603
  sk_alloc+0x39/0xf70 /net/core/sock.c:1657
  nr_make_new /net/netrom/af_netrom.c:476 [inline]
  nr_rx_frame+0x733/0x1e80 /net/netrom/af_netrom.c:959
  nr_loopback_timer+0x7b/0x170 /net/netrom/nr_loopback.c:59
  call_timer_fn+0x1ac/0x780 /kernel/time/timer.c:1322
  expire_timers /kernel/time/timer.c:1366 [inline]
  __run_timers /kernel/time/timer.c:1685 [inline]
  __run_timers /kernel/time/timer.c:1653 [inline]
  run_timer_softirq+0x697/0x17a0 /kernel/time/timer.c:1698
  __do_softirq+0x262/0x98c /kernel/softirq.c:292

Freed by task 11551:
  save_stack+0x23/0x90 /mm/kasan/common.c:69
  set_track /mm/kasan/common.c:77 [inline]
  __kasan_slab_free+0x102/0x150 /mm/kasan/common.c:449
  kasan_slab_free+0xe/0x10 /mm/kasan/common.c:457
  __cache_free /mm/slab.c:3425 [inline]
  kfree+0x10a/0x2c0 /mm/slab.c:3756
  sk_prot_free /net/core/sock.c:1640 [inline]
  __sk_destruct+0x4f7/0x6e0 /net/core/sock.c:1726
  sk_destruct+0x86/0xa0 /net/core/sock.c:1734
  __sk_free+0xfb/0x360 /net/core/sock.c:1745
  sk_free+0x42/0x50 /net/core/sock.c:1756
  sock_put /./include/net/sock.h:1725 [inline]
  sock_efree+0x61/0x80 /net/core/sock.c:2042
  skb_release_head_state+0xeb/0x260 /net/core/skbuff.c:652
  skb_release_all+0x16/0x60 /net/core/skbuff.c:663
  __kfree_skb /net/core/skbuff.c:679 [inline]
  kfree_skb /net/core/skbuff.c:697 [inline]
  kfree_skb+0x101/0x3c0 /net/core/skbuff.c:691
  nr_accept+0x570/0x720 /net/netrom/af_netrom.c:819
  __sys_accept4+0x34e/0x6a0 /net/socket.c:1750
  __do_sys_accept4 /net/socket.c:1785 [inline]
  __se_sys_accept4 /net/socket.c:1782 [inline]
  __x64_sys_accept4+0x97/0xf0 /net/socket.c:1782
  do_syscall_64+0xfd/0x6a0 /arch/x86/entry/common.c:296
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff88807be6b640
  which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 128 bytes inside of
  2048-byte region [ffff88807be6b640, ffff88807be6be40)
The buggy address belongs to the page:
page:ffffea0001ef9a80 refcount:1 mapcount:0 mapping:ffff8880aa400e00  
index:0x0 compound_mapcount: 0
flags: 0x1fffc0000010200(slab|head)
raw: 01fffc0000010200 ffffea0001ef9708 ffffea0002453708 ffff8880aa400e00
raw: 0000000000000000 ffff88807be6a540 0000000100000003 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff88807be6b580: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
  ffff88807be6b600: fc fc fc fc fc fc fc fc fb fb fb fb fb fb fb fb
> ffff88807be6b680: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                            ^
  ffff88807be6b700: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff88807be6b780: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================
------------[ cut here ]------------
ODEBUG: activate not available (active state 0) object type: timer_list  
hint: nr_t1timer_expiry+0x0/0x340 /net/netrom/nr_timer.c:157
WARNING: CPU: 0 PID: 11548 at lib/debugobjects.c:481  
debug_print_object+0x168/0x250 /lib/debugobjects.c:481
Modules linked in:
CPU: 0 PID: 11548 Comm: syz-executor.0 Tainted: G    B             5.2.0+  
#66
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:debug_print_object+0x168/0x250 /lib/debugobjects.c:481
Code: dd a0 48 c5 87 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 b5 00 00 00 48  
8b 14 dd a0 48 c5 87 48 c7 c7 00 3e c5 87 e8 f0 b1 07 fe <0f> 0b 83 05 13  
86 66 06 01 48 83 c4 20 5b 41 5c 41 5d 41 5e 5d c3
RSP: 0018:ffff88809151faf0 EFLAGS: 00010082
RAX: 0000000000000000 RBX: 0000000000000005 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff815c1016 RDI: ffffed10122a3f50
RBP: ffff88809151fb30 R08: ffff8880943fe300 R09: ffffed1015d040f1
R10: ffffed1015d040f0 R11: ffff8880ae820787 R12: 0000000000000001
R13: ffffffff88db4ca0 R14: ffffffff8161a860 R15: 1ffff110122a3f6c
FS:  0000555555737940(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fada90cddb8 CR3: 00000000a7f80000 CR4: 00000000001406f0
Call Trace:
  debug_object_activate+0x2e5/0x470 /lib/debugobjects.c:680
  debug_timer_activate /kernel/time/timer.c:710 [inline]
  __mod_timer /kernel/time/timer.c:1035 [inline]
  mod_timer+0x452/0xc10 /kernel/time/timer.c:1096
  sk_reset_timer+0x24/0x60 /net/core/sock.c:2821
  nr_start_t1timer+0x6e/0xa0 /net/netrom/nr_timer.c:52
  nr_release+0x1de/0x3e0 /net/netrom/af_netrom.c:537
  __sock_release+0xce/0x280 /net/socket.c:586
  sock_close+0x1e/0x30 /net/socket.c:1264
  __fput+0x2ff/0x890 /fs/file_table.c:280
  ____fput+0x16/0x20 /fs/file_table.c:313
  task_work_run+0x145/0x1c0 /kernel/task_work.c:113
  tracehook_notify_resume /./include/linux/tracehook.h:185 [inline]
  exit_to_usermode_loop+0x316/0x380 /arch/x86/entry/common.c:163
  prepare_exit_to_usermode /arch/x86/entry/common.c:194 [inline]
  syscall_return_slowpath /arch/x86/entry/common.c:274 [inline]
  do_syscall_64+0x5a9/0x6a0 /arch/x86/entry/common.c:299
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x413501
Code: 75 14 b8 03 00 00 00 0f 05 48 3d 01 f0 ff ff 0f 83 04 1b 00 00 c3 48  
83 ec 08 e8 0a fc ff ff 48 89 04 24 b8 03 00 00 00 0f 05 <48> 8b 3c 24 48  
89 c2 e8 53 fc ff ff 48 89 d0 48 83 c4 08 48 3d 01
RSP: 002b:00007ffe5eb40550 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000004 RCX: 0000000000413501
RDX: 0000001b2be20000 RSI: 0000000000000000 RDI: 0000000000000003
RBP: 0000000000000001 R08: ffffffffffffffff R09: ffffffffffffffff
R10: 00007ffe5eb40630 R11: 0000000000000293 R12: 000000000075c9a0
R13: 000000000075c9a0 R14: 0000000000760a68 R15: ffffffffffffffff
irq event stamp: 1316
hardirqs last  enabled at (1315): [<ffffffff873119e8>]  
__raw_spin_unlock_irq /./include/linux/spinlock_api_smp.h:168 [inline]
hardirqs last  enabled at (1315): [<ffffffff873119e8>]  
_raw_spin_unlock_irq+0x28/0x90 /kernel/locking/spinlock.c:199
hardirqs last disabled at (1316): [<ffffffff8731216f>]  
__raw_spin_lock_irqsave /./include/linux/spinlock_api_smp.h:108 [inline]
hardirqs last disabled at (1316): [<ffffffff8731216f>]  
_raw_spin_lock_irqsave+0x6f/0xcd /kernel/locking/spinlock.c:159
softirqs last  enabled at (1168): [<ffffffff812923fe>] memcpy  
/./include/linux/string.h:359 [inline]
softirqs last  enabled at (1168): [<ffffffff812923fe>]  
fpu__copy+0x17e/0x8c0 /arch/x86/kernel/fpu/core.c:195
softirqs last disabled at (1166): [<ffffffff81292327>] fpu__copy+0xa7/0x8c0  
/arch/x86/kernel/fpu/core.c:183
---[ end trace c9359faa0df5eab0 ]---

