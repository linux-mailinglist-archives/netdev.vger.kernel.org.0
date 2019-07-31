Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AA137B9C7
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 08:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727645AbfGaGiH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 02:38:07 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:46692 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725871AbfGaGiH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 02:38:07 -0400
Received: by mail-io1-f69.google.com with SMTP id s83so74199261iod.13
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 23:38:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=6yKSeJNr2BYN7aBiSCvvnqV2xPBW5i0aG/kIbGxlERg=;
        b=f6twV7d6culVLqWp0AAvG6uaqNXpdYIkI3dvN/m1o2gvCy5TCnZAdE2K4tFiOu4dW9
         3t1NpErjOleJmF6OLA7xwaaZ+hq+8qRIrJOVNgwL+2EYzLZ3adt0qR73Z+xQ5itXi+O2
         RypworgsyIO5w+RopcMH9q8Tfce+DCFlXGRDLSPH8RbsIznT79KL0PUxlIsUr6vO3Odm
         tlY2NFvprFHRtWbvFBGImb2meT+p5Dh7u7AJ6n1MGiILVMFqWMqTjchxylSrVLQuFQC6
         LSDUUhB0wQgTtuYDx9dKHoq22TN7aM0n/CVeXhiiCVdMpkDepReUVvJQ4u2R2U9x3KRT
         bn2A==
X-Gm-Message-State: APjAAAWrkNsMoTkma1CLE9JEIZhHbZ0yTm55VYvQ0hMrCwSlmtm7UwyH
        jIa4Gchetflh6ZHDkwIoBUxAwfcrZb9TmfgsmJ7PnZxfUHPQ
X-Google-Smtp-Source: APXvYqyeyuPk+l63DTI3i0/25ez2LGjhQ7W9DJg78KvP89ffMYtM2Ui+XBNXRHB/zbsXwMXwTABk1v6eV/6wyajv/hAs1Mcf4XrB
MIME-Version: 1.0
X-Received: by 2002:a5e:9701:: with SMTP id w1mr26363715ioj.294.1564555086293;
 Tue, 30 Jul 2019 23:38:06 -0700 (PDT)
Date:   Tue, 30 Jul 2019 23:38:06 -0700
In-Reply-To: <000000000000de000a058e9025db@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002677cc058ef45ea5@google.com>
Subject: Re: KASAN: use-after-free Read in release_sock
From:   syzbot <syzbot+107429d62fb1d293602f@syzkaller.appspotmail.com>
To:     davem@davemloft.net, linux-hams@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        ralf@linux-mips.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    629f8205 Merge tag 'for-linus-20190730' of git://git.kerne..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11a27744600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4c7b914a2680c9c6
dashboard link: https://syzkaller.appspot.com/bug?extid=107429d62fb1d293602f
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16a7c8dc600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1498cfa2600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+107429d62fb1d293602f@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in debug_spin_lock_before  
kernel/locking/spinlock_debug.c:83 [inline]
BUG: KASAN: use-after-free in do_raw_spin_lock+0x28a/0x2e0  
kernel/locking/spinlock_debug.c:112
Read of size 4 at addr ffff8880a81b540c by task syz-executor143/10205

CPU: 1 PID: 10205 Comm: syz-executor143 Not tainted 5.3.0-rc2+ #90
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
  exit_task_work include/linux/task_work.h:22 [inline]
  do_exit+0x92f/0x2e50 kernel/exit.c:879
  do_group_exit+0x135/0x360 kernel/exit.c:983
  get_signal+0x47c/0x2500 kernel/signal.c:2729
  do_signal+0x87/0x1700 arch/x86/kernel/signal.c:815
  exit_to_usermode_loop+0x286/0x380 arch/x86/entry/common.c:159
  prepare_exit_to_usermode arch/x86/entry/common.c:194 [inline]
  syscall_return_slowpath arch/x86/entry/common.c:274 [inline]
  do_syscall_64+0x5a9/0x6a0 arch/x86/entry/common.c:299
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x447d09
Code: Bad RIP value.
RSP: 002b:00007fca48b63db8 EFLAGS: 00000246 ORIG_RAX: 000000000000002b
RAX: fffffffffffffe00 RBX: 00000000006ddc58 RCX: 0000000000447d09
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000007
RBP: 00000000006ddc50 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000006ddc5c
R13: 00007ffe913f3ebf R14: 00007fca48b649c0 R15: 0000000000000001

Allocated by task 0:
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

Freed by task 10205:
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
  exit_task_work include/linux/task_work.h:22 [inline]
  do_exit+0x92f/0x2e50 kernel/exit.c:879
  do_group_exit+0x135/0x360 kernel/exit.c:983
  get_signal+0x47c/0x2500 kernel/signal.c:2729
  do_signal+0x87/0x1700 arch/x86/kernel/signal.c:815
  exit_to_usermode_loop+0x286/0x380 arch/x86/entry/common.c:159
  prepare_exit_to_usermode arch/x86/entry/common.c:194 [inline]
  syscall_return_slowpath arch/x86/entry/common.c:274 [inline]
  do_syscall_64+0x5a9/0x6a0 arch/x86/entry/common.c:299
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff8880a81b5380
  which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 140 bytes inside of
  2048-byte region [ffff8880a81b5380, ffff8880a81b5b80)
The buggy address belongs to the page:
page:ffffea0002a06d00 refcount:1 mapcount:0 mapping:ffff8880aa400e00  
index:0x0 compound_mapcount: 0
flags: 0x1fffc0000010200(slab|head)
raw: 01fffc0000010200 ffffea0002a0ec88 ffffea0002a07708 ffff8880aa400e00
raw: 0000000000000000 ffff8880a81b4280 0000000100000003 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff8880a81b5300: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
  ffff8880a81b5380: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ffff8880a81b5400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                       ^
  ffff8880a81b5480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff8880a81b5500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================

