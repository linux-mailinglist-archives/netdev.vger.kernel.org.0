Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C03575F71
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 09:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726138AbfGZHEG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 03:04:06 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:43472 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725878AbfGZHEG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 03:04:06 -0400
Received: by mail-io1-f71.google.com with SMTP id q26so57660821ioi.10
        for <netdev@vger.kernel.org>; Fri, 26 Jul 2019 00:04:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=iiEOnn150oGXJw06DVHiQhyleupZW2777rwDJN7+kIw=;
        b=dTBokfDfqkzXYQeAqMQ5O8IM9eIG/CqeMT8wGm4tF1ovfIDTY7K5RiKg+VGmK9csx+
         bigDigkZpGV3FcmqgzJpi2TkWT8qoFwraZLBMSJy/wcBvFcTpgTNPPz44qpeNcZEDRO6
         /SU97BHUkXqM/zUR3VW2wZ/dzuor7Wyznh+7A7xKlNkSH+MA0jNrQXEz50uiTngEsY8H
         xYMNfdHv5CzxcdURr5fDqBygwuO42K+IdNTLkZpY33Uqhd0jujrt9mFCBG+WbUqGL1hs
         5ro3ttUgQQg9gf8MPqlYhTo+CY5CHB5YEiCsoT7tsL6N+KuDt4BGpeudN/eV5XgFbXQh
         orrA==
X-Gm-Message-State: APjAAAVU78oakF7rVHm9If2Vvq7fGR+rmviRH9L6g+d6Tyaa4H7jmGkt
        fssEm3AFcA28auNQ4XvGrZ+NGtbbCONO+2d6vPjzR7d1l30F
X-Google-Smtp-Source: APXvYqwunFbZK1zg6km7akU93VhukcwvSUaVhVPNKnxq6iH/0hj/TI18yDx2Qfd/ldQdpljb4ZZJXLtziUb1rlcGF8paXAtAHduv
MIME-Version: 1.0
X-Received: by 2002:a6b:2b08:: with SMTP id r8mr42041503ior.34.1564124645291;
 Fri, 26 Jul 2019 00:04:05 -0700 (PDT)
Date:   Fri, 26 Jul 2019 00:04:05 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000de000a058e9025db@google.com>
Subject: KASAN: use-after-free Read in release_sock
From:   syzbot <syzbot+107429d62fb1d293602f@syzkaller.appspotmail.com>
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

HEAD commit:    6789f873 Merge tag 'pm-5.3-rc2' of git://git.kernel.org/pu..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1593573fa00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6efd5962fd8c1d39
dashboard link: https://syzkaller.appspot.com/bug?extid=107429d62fb1d293602f
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+107429d62fb1d293602f@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in debug_spin_lock_before  
kernel/locking/spinlock_debug.c:83 [inline]
BUG: KASAN: use-after-free in do_raw_spin_lock+0x28a/0x2e0  
kernel/locking/spinlock_debug.c:112
Read of size 4 at addr ffff88808b66578c by task syz-executor.5/30407

CPU: 0 PID: 30407 Comm: syz-executor.5 Not tainted 5.3.0-rc1+ #84
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  print_address_description.cold+0xd4/0x306 mm/kasan/report.c:351
  __kasan_report.cold+0x1b/0x36 mm/kasan/report.c:482
  kasan_report+0x12/0x17 mm/kasan/common.c:612
  __asan_report_load4_noabort+0x14/0x20 mm/kasan/generic_report.c:131
  debug_spin_lock_before kernel/locking/spinlock_debug.c:83 [inline]
  do_raw_spin_lock+0x28a/0x2e0 kernel/locking/spinlock_debug.c:112
  __raw_spin_lock_bh include/linux/spinlock_api_smp.h:136 [inline]
  _raw_spin_lock_bh+0x3b/0x50 kernel/locking/spinlock.c:175
  spin_lock_bh include/linux/spinlock.h:343 [inline]
  release_sock+0x20/0x1c0 net/core/sock.c:2932
  nr_release+0x303/0x3e0 net/netrom/af_netrom.c:553
  __sock_release+0xce/0x280 net/socket.c:590
  sock_close+0x1e/0x30 net/socket.c:1268
  __fput+0x2ff/0x890 fs/file_table.c:280
  ____fput+0x16/0x20 fs/file_table.c:313
  task_work_run+0x145/0x1c0 kernel/task_work.c:113
  tracehook_notify_resume include/linux/tracehook.h:188 [inline]
  exit_to_usermode_loop+0x316/0x380 arch/x86/entry/common.c:163
  prepare_exit_to_usermode arch/x86/entry/common.c:194 [inline]
  syscall_return_slowpath arch/x86/entry/common.c:274 [inline]
  do_syscall_64+0x5a9/0x6a0 arch/x86/entry/common.c:299
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x413511
Code: 75 14 b8 03 00 00 00 0f 05 48 3d 01 f0 ff ff 0f 83 04 1b 00 00 c3 48  
83 ec 08 e8 0a fc ff ff 48 89 04 24 b8 03 00 00 00 0f 05 <48> 8b 3c 24 48  
89 c2 e8 53 fc ff ff 48 89 d0 48 83 c4 08 48 3d 01
RSP: 002b:00007ffd3d6d51d0 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 000000000000000a RCX: 0000000000413511
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000009
RBP: 0000000000000001 R08: 000000007639d277 R09: 000000007639d27b
R10: 00007ffd3d6d52b0 R11: 0000000000000293 R12: 000000000075c9a0
R13: 000000000075c9a0 R14: 00000000007617a0 R15: ffffffffffffffff

Allocated by task 30409:
  save_stack+0x23/0x90 mm/kasan/common.c:69
  set_track mm/kasan/common.c:77 [inline]
  __kasan_kmalloc mm/kasan/common.c:487 [inline]
  __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:460
  kasan_kmalloc+0x9/0x10 mm/kasan/common.c:501
  __do_kmalloc mm/slab.c:3655 [inline]
  __kmalloc+0x163/0x770 mm/slab.c:3664
  kmalloc include/linux/slab.h:557 [inline]
  sk_prot_alloc+0x23a/0x310 net/core/sock.c:1603
  sk_alloc+0x39/0xf70 net/core/sock.c:1657
  nr_make_new net/netrom/af_netrom.c:476 [inline]
  nr_rx_frame+0x733/0x1e73 net/netrom/af_netrom.c:959
  nr_loopback_timer+0x7b/0x170 net/netrom/nr_loopback.c:59
  call_timer_fn+0x1ac/0x780 kernel/time/timer.c:1322
  expire_timers kernel/time/timer.c:1366 [inline]
  __run_timers kernel/time/timer.c:1685 [inline]
  __run_timers kernel/time/timer.c:1653 [inline]
  run_timer_softirq+0x697/0x17a0 kernel/time/timer.c:1698
  __do_softirq+0x262/0x98c kernel/softirq.c:292

Freed by task 30407:
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
  nr_destroy_socket+0x3ea/0x4a0 net/netrom/af_netrom.c:288
  nr_release+0x347/0x3e0 net/netrom/af_netrom.c:530
  __sock_release+0xce/0x280 net/socket.c:590
  sock_close+0x1e/0x30 net/socket.c:1268
  __fput+0x2ff/0x890 fs/file_table.c:280
  ____fput+0x16/0x20 fs/file_table.c:313
  task_work_run+0x145/0x1c0 kernel/task_work.c:113
  tracehook_notify_resume include/linux/tracehook.h:188 [inline]
  exit_to_usermode_loop+0x316/0x380 arch/x86/entry/common.c:163
  prepare_exit_to_usermode arch/x86/entry/common.c:194 [inline]
  syscall_return_slowpath arch/x86/entry/common.c:274 [inline]
  do_syscall_64+0x5a9/0x6a0 arch/x86/entry/common.c:299
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff88808b665700
  which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 140 bytes inside of
  2048-byte region [ffff88808b665700, ffff88808b665f00)
The buggy address belongs to the page:
page:ffffea00022d9900 refcount:1 mapcount:0 mapping:ffff8880aa400e00  
index:0x0 compound_mapcount: 0
flags: 0x1fffc0000010200(slab|head)
raw: 01fffc0000010200 ffffea000187ee08 ffffea00022d3f08 ffff8880aa400e00
raw: 0000000000000000 ffff88808b664600 0000000100000003 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff88808b665680: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
  ffff88808b665700: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ffff88808b665780: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                       ^
  ffff88808b665800: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff88808b665880: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
