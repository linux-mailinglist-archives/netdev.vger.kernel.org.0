Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BFABF6AD9
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 19:39:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbfKJSjO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 13:39:14 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:48687 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726731AbfKJSjM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Nov 2019 13:39:12 -0500
Received: by mail-io1-f69.google.com with SMTP id q84so11573937iod.15
        for <netdev@vger.kernel.org>; Sun, 10 Nov 2019 10:39:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=bBjX1/WZV5dVArm8R4gMtXyuCmnSCpxSDT2V+2yMP80=;
        b=ctGGi6R2tg4jAsr+CZgn/C4iprPtZarOPq4qGyTWgX618gRWl9xSBvBJ0OiPsVehZ+
         J2rDNKEJ6U01hH2s/jxSrmfLwkzXqz6QpYqa2CAoY7oUDeCCIQUM3zg+gueTUpgD/+JM
         E7gkLVMnzE8yZ1efmADuPVVzhYS8OVeKbusCvfA/uSSOKRSrLmwsPk7Z265Gy40iPONi
         p/fzZB3EkciLupzvNJWpH+T7baLMSTp3JFMEocwcOuf9MRhDk0dC49FfpqJmirP1DQ28
         9mKVnbfXp3CihEde2wHkmW32F9WzVjT9vSIcrDX7TavV+eZjdbK9QNWHpPMukDvMUvBL
         URvg==
X-Gm-Message-State: APjAAAU2btF8gyl1sUYqSVWUN3TaVtoy3zEpXxrm6aSSFr5rxiJV7Uj9
        UMCPZvGG8kbJ2B+6kWqmkLj+o6q/uHR8a1GPMkxnhGDn//Gn
X-Google-Smtp-Source: APXvYqwemlfoW7unzmZY2i6t+gp24Xpq87u+OV/GMdRMxyTxEwUG+Zf+JS9W58A0Tt4KBk5nBky/Zx1ZQbjYPwf0SYPI/qj0eI/T
MIME-Version: 1.0
X-Received: by 2002:a92:5c4f:: with SMTP id q76mr25453059ilb.158.1573411149300;
 Sun, 10 Nov 2019 10:39:09 -0800 (PST)
Date:   Sun, 10 Nov 2019 10:39:09 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a3cc890597025437@google.com>
Subject: KASAN: use-after-free Read in j1939_sk_recv
From:   syzbot <syzbot+07ca5bce8530070a5650@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kernel@pengutronix.de,
        linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux@rempel-privat.de, mkl@pengutronix.de, netdev@vger.kernel.org,
        robin@protonic.nl, socketcan@hartkopp.net,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    5591cf00 Add linux-next specific files for 20191108
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=106b7c3ce00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e1036c6ef52866f9
dashboard link: https://syzkaller.appspot.com/bug?extid=07ca5bce8530070a5650
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=165ad206e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14cf9c3ce00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+07ca5bce8530070a5650@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in __lock_acquire+0x3a8b/0x4a00  
kernel/locking/lockdep.c:3828
Read of size 8 at addr ffff88808d6ad0c0 by task syz-executor171/8825

CPU: 1 PID: 8825 Comm: syz-executor171 Not tainted 5.4.0-rc6-next-20191108  
#0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  <IRQ>
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x197/0x210 lib/dump_stack.c:118
  print_address_description.constprop.0.cold+0xd4/0x30b mm/kasan/report.c:374
  __kasan_report.cold+0x1b/0x41 mm/kasan/report.c:506
  kasan_report+0x12/0x20 mm/kasan/common.c:634
  __asan_report_load8_noabort+0x14/0x20 mm/kasan/generic_report.c:132
  __lock_acquire+0x3a8b/0x4a00 kernel/locking/lockdep.c:3828
  lock_acquire+0x190/0x410 kernel/locking/lockdep.c:4487
  __raw_spin_lock_bh include/linux/spinlock_api_smp.h:135 [inline]
  _raw_spin_lock_bh+0x33/0x50 kernel/locking/spinlock.c:175
  spin_lock_bh include/linux/spinlock.h:343 [inline]
  j1939_sk_recv+0x2f/0x370 net/can/j1939/socket.c:345
  j1939_can_recv+0x4e5/0x620 net/can/j1939/main.c:105
  deliver net/can/af_can.c:568 [inline]
  can_rcv_filter+0x292/0x8e0 net/can/af_can.c:602
  can_receive+0x2e7/0x530 net/can/af_can.c:659
  can_rcv+0x133/0x1b0 net/can/af_can.c:685
  __netif_receive_skb_one_core+0x113/0x1a0 net/core/dev.c:5150
  __netif_receive_skb+0x2c/0x1d0 net/core/dev.c:5264
  process_backlog+0x206/0x750 net/core/dev.c:6096
  napi_poll net/core/dev.c:6533 [inline]
  net_rx_action+0x508/0x1110 net/core/dev.c:6601
  __do_softirq+0x262/0x98c kernel/softirq.c:292
  invoke_softirq kernel/softirq.c:373 [inline]
  irq_exit+0x19b/0x1e0 kernel/softirq.c:413
  exiting_irq arch/x86/include/asm/apic.h:536 [inline]
  smp_apic_timer_interrupt+0x1a3/0x610 arch/x86/kernel/apic/apic.c:1137
  apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:829
  </IRQ>
RIP: 0010:__sanitizer_cov_trace_switch+0x44/0x80 kernel/kcov.c:310
Code: 3a 48 83 f8 08 74 46 48 83 f8 10 75 27 bf 03 00 00 00 4d 8b 2c 24 31  
db 4d 85 ed 74 17 49 8b 74 dc 10 48 83 c3 01 48 8b 4d 08 <e8> 47 fe ff ff  
49 39 dd 75 e9 5b 41 5c 41 5d 5d c3 48 83 f8 40 bf
RSP: 0018:ffff88809caefbe8 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
RAX: 0000000000000000 RBX: 0000000000000003 RCX: ffffffff8168173c
RDX: 0000000000000000 RSI: 0000000000000003 RDI: 0000000000000005
RBP: ffff88809caefc00 R08: ffff8880a19f82c0 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff87ae1780
R13: 000000000000000c R14: 0000000000000000 R15: ffff88809caefdf0
  do_futex+0x2bc/0x1de0 kernel/futex.c:3639
  __do_sys_futex kernel/futex.c:3705 [inline]
  __se_sys_futex kernel/futex.c:3673 [inline]
  __x64_sys_futex+0x3f7/0x590 kernel/futex.c:3673
  do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x450699
Code: e8 2c d4 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 ab cc fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fd88d336cf8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: ffffffffffffffda RBX: 00000000006e2ca8 RCX: 0000000000450699
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00000000006e2ca8
RBP: 00000000006e2ca0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000006e2cac
R13: 00007ffc9e1c600f R14: 00007fd88d3379c0 R15: 0000000000000000

Allocated by task 8825:
  save_stack+0x23/0x90 mm/kasan/common.c:69
  set_track mm/kasan/common.c:77 [inline]
  __kasan_kmalloc mm/kasan/common.c:510 [inline]
  __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:483
  kasan_kmalloc+0x9/0x10 mm/kasan/common.c:524
  kmem_cache_alloc_trace+0x158/0x790 mm/slab.c:3551
  kmalloc include/linux/slab.h:556 [inline]
  kzalloc include/linux/slab.h:670 [inline]
  j1939_priv_create net/can/j1939/main.c:122 [inline]
  j1939_netdev_start+0xa4/0x550 net/can/j1939/main.c:251
  j1939_sk_bind+0x65a/0x8e0 net/can/j1939/socket.c:438
  __sys_bind+0x239/0x290 net/socket.c:1648
  __do_sys_bind net/socket.c:1659 [inline]
  __se_sys_bind net/socket.c:1657 [inline]
  __x64_sys_bind+0x73/0xb0 net/socket.c:1657
  do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 8824:
  save_stack+0x23/0x90 mm/kasan/common.c:69
  set_track mm/kasan/common.c:77 [inline]
  kasan_set_free_info mm/kasan/common.c:332 [inline]
  __kasan_slab_free+0x102/0x150 mm/kasan/common.c:471
  kasan_slab_free+0xe/0x10 mm/kasan/common.c:480
  __cache_free mm/slab.c:3426 [inline]
  kfree+0x10a/0x2c0 mm/slab.c:3757
  __j1939_priv_release net/can/j1939/main.c:154 [inline]
  kref_put include/linux/kref.h:65 [inline]
  j1939_priv_put+0x8b/0xb0 net/can/j1939/main.c:159
  j1939_netdev_stop+0x45/0x190 net/can/j1939/main.c:291
  j1939_sk_release+0x3bd/0x5c0 net/can/j1939/socket.c:580
  __sock_release+0xce/0x280 net/socket.c:591
  sock_close+0x1e/0x30 net/socket.c:1269
  __fput+0x2ff/0x890 fs/file_table.c:280
  ____fput+0x16/0x20 fs/file_table.c:313
  task_work_run+0x145/0x1c0 kernel/task_work.c:113
  tracehook_notify_resume include/linux/tracehook.h:188 [inline]
  exit_to_usermode_loop+0x316/0x380 arch/x86/entry/common.c:163
  prepare_exit_to_usermode arch/x86/entry/common.c:194 [inline]
  syscall_return_slowpath arch/x86/entry/common.c:274 [inline]
  do_syscall_64+0x65f/0x760 arch/x86/entry/common.c:300
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff88808d6ac000
  which belongs to the cache kmalloc-8k of size 8192
The buggy address is located 4288 bytes inside of
  8192-byte region [ffff88808d6ac000, ffff88808d6ae000)
The buggy address belongs to the page:
page:ffffea000235ab00 refcount:1 mapcount:0 mapping:ffff8880aa4021c0  
index:0x0 compound_mapcount: 0
flags: 0x1fffc0000010200(slab|head)
raw: 01fffc0000010200 ffffea0002289508 ffffea0002246008 ffff8880aa4021c0
raw: 0000000000000000 ffff88808d6ac000 0000000100000001 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff88808d6acf80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff88808d6ad000: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ffff88808d6ad080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                            ^
  ffff88808d6ad100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff88808d6ad180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
