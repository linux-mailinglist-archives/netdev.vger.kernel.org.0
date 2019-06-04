Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFDE333E22
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 07:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbfFDFAG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 01:00:06 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:56156 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726136AbfFDFAG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 01:00:06 -0400
Received: by mail-io1-f72.google.com with SMTP id f22so15570568ioh.22
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 22:00:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=m0H82qKPLGC08pNSWqS6+ZK1CGm7k8VrXyLDBQA714Y=;
        b=j+qedqlvK7U+h+BuOXj5fUNp+zMLG+zC/rDqiREJSW3y8BTy4B1LrPM2vB7JFzxJ+h
         /Bjn8ipUnzMU3IMGhg1ajMkWk19zqL95Ni712DepPbaTPYo2V7Rj6EDPVOtTlQINbImr
         t+I3mS4jNhSLfjN03mY+LX7YXEIvJfV7jG/dcsyWa3/ty2u+L457OPeEAttzJ6UdEpct
         PJORTCoJjpED+CeeYOFdcNB6LClgfnt5F6DtcHRtA1fxI4aHcsSOQf09/YBk/p0eQFSD
         k75yxx9eM2FBa3qiBqEW6aPMi+E2yd7F3p5Oe28/0VohIgNtM58BaaekVTk/uChLIugm
         1KUQ==
X-Gm-Message-State: APjAAAXbvsQB2NuGl/tnrMuelZLafeZNHvO37ZU/z9scoS/8CrXGO1UF
        89O14aewQvtO2bbjZFqUm5HfIqutOI54AaGbctbJvIrwiH+y
X-Google-Smtp-Source: APXvYqzVTdF+nUlZMoiTaz4uhlaL49pZ3SxefQ1UTW2tT6mB4oLBn7rj41EBT4xmvubc5sURYW/gA+eeGwXDEooOy/rAyb5iYBPX
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2285:: with SMTP id d5mr145802iod.196.1559624405610;
 Mon, 03 Jun 2019 22:00:05 -0700 (PDT)
Date:   Mon, 03 Jun 2019 22:00:05 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ae08b2058a785a4c@google.com>
Subject: KASAN: slab-out-of-bounds Read in icmpv6_xrlim_allow
From:   syzbot <syzbot+14536436e78408172703@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    0462eaac Merge git://git.kernel.org/pub/scm/linux/kernel/g..
git tree:       bpf-next
console output: https://syzkaller.appspot.com/x/log.txt?x=12c82772a00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b7b54c66298f8420
dashboard link: https://syzkaller.appspot.com/bug?extid=14536436e78408172703
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+14536436e78408172703@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-out-of-bounds in icmpv6_xrlim_allow+0x409/0x440  
net/ipv6/icmp.c:216
Read of size 8 at addr ffff8880973ed8bf by task swapper/1/0

CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.2.0-rc2+ #12
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  <IRQ>
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  print_address_description.cold+0x7c/0x20d mm/kasan/report.c:188
  __kasan_report.cold+0x1b/0x40 mm/kasan/report.c:317
  kasan_report+0x12/0x20 mm/kasan/common.c:614
  __asan_report_load8_noabort+0x14/0x20 mm/kasan/generic_report.c:132
  icmpv6_xrlim_allow+0x409/0x440 net/ipv6/icmp.c:216
  icmp6_send+0x1107/0x1e50 net/ipv6/icmp.c:540
  icmpv6_send+0xec/0x230 net/ipv6/ip6_icmp.c:43
  ip6_link_failure+0x2b/0x530 net/ipv6/route.c:2367
  dst_link_failure include/net/dst.h:416 [inline]
  ndisc_error_report+0xce/0x1c0 net/ipv6/ndisc.c:712
  neigh_invalidate+0x245/0x570 net/core/neighbour.c:1000
  neigh_timer_handler+0xc33/0xf30 net/core/neighbour.c:1086
  call_timer_fn+0x193/0x720 kernel/time/timer.c:1322
  expire_timers kernel/time/timer.c:1366 [inline]
  __run_timers kernel/time/timer.c:1685 [inline]
  __run_timers kernel/time/timer.c:1653 [inline]
  run_timer_softirq+0x66f/0x1740 kernel/time/timer.c:1698
  __do_softirq+0x25c/0x94c kernel/softirq.c:293
  invoke_softirq kernel/softirq.c:374 [inline]
  irq_exit+0x180/0x1d0 kernel/softirq.c:414
  exiting_irq arch/x86/include/asm/apic.h:536 [inline]
  smp_apic_timer_interrupt+0x13b/0x550 arch/x86/kernel/apic/apic.c:1068
  apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:806
  </IRQ>
RIP: 0010:__raw_spin_unlock_irq include/linux/spinlock_api_smp.h:169  
[inline]
RIP: 0010:_raw_spin_unlock_irq+0x54/0x90 kernel/locking/spinlock.c:199
Code: c0 00 74 b2 88 48 ba 00 00 00 00 00 fc ff df 48 c1 e8 03 80 3c 10 00  
75 33 48 83 3d 85 ee 94 01 00 74 20 fb 66 0f 1f 44 00 00 <bf> 01 00 00 00  
e8 52 f5 2f fa 65 8b 05 f3 77 e4 78 85 c0 74 06 41
RSP: 0018:ffff8880a98e7c88 EFLAGS: 00000286 ORIG_RAX: ffffffffffffff13
RAX: 1ffffffff1164e80 RBX: ffff8880a98d4340 RCX: 0000000000000000
RDX: dffffc0000000000 RSI: 0000000000000006 RDI: ffff8880a98d4bbc
RBP: ffff8880a98e7c90 R08: ffff8880a98d4340 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffff8880ae935080
R13: ffff888096ef0640 R14: 0000000000000000 R15: 0000000000000001
  finish_lock_switch kernel/sched/core.c:2568 [inline]
  finish_task_switch+0x146/0x730 kernel/sched/core.c:2668
  context_switch kernel/sched/core.c:2821 [inline]
  __schedule+0x7d3/0x1560 kernel/sched/core.c:3445
  schedule_idle+0x58/0x80 kernel/sched/core.c:3537
  do_idle+0x192/0x560 kernel/sched/idle.c:287
  cpu_startup_entry+0x1b/0x20 kernel/sched/idle.c:354
  start_secondary+0x34e/0x4c0 arch/x86/kernel/smpboot.c:265
  secondary_startup_64+0xa4/0xb0 arch/x86/kernel/head_64.S:243

Allocated by task 0:
  save_stack+0x23/0x90 mm/kasan/common.c:71
  set_track mm/kasan/common.c:79 [inline]
  __kasan_kmalloc mm/kasan/common.c:489 [inline]
  __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:462
  kasan_slab_alloc+0xf/0x20 mm/kasan/common.c:497
  slab_post_alloc_hook mm/slab.h:437 [inline]
  slab_alloc mm/slab.c:3326 [inline]
  kmem_cache_alloc+0x11a/0x6f0 mm/slab.c:3488
  dst_alloc+0x10e/0x200 net/core/dst.c:93
  ip6_dst_alloc+0x34/0xa0 net/ipv6/route.c:356
  icmp6_dst_alloc+0x1a9/0x660 net/ipv6/route.c:2806
  ndisc_send_skb+0xfc1/0x14a0 net/ipv6/ndisc.c:488
  ndisc_send_rs+0x134/0x6d0 net/ipv6/ndisc.c:702
  addrconf_rs_timer+0x30f/0x680 net/ipv6/addrconf.c:3880
  call_timer_fn+0x193/0x720 kernel/time/timer.c:1322
  expire_timers kernel/time/timer.c:1366 [inline]
  __run_timers kernel/time/timer.c:1685 [inline]
  __run_timers kernel/time/timer.c:1653 [inline]
  run_timer_softirq+0x66f/0x1740 kernel/time/timer.c:1698
  __do_softirq+0x25c/0x94c kernel/softirq.c:293

Freed by task 0:
  save_stack+0x23/0x90 mm/kasan/common.c:71
  set_track mm/kasan/common.c:79 [inline]
  __kasan_slab_free+0x102/0x150 mm/kasan/common.c:451
  kasan_slab_free+0xe/0x10 mm/kasan/common.c:459
  __cache_free mm/slab.c:3432 [inline]
  kmem_cache_free+0x86/0x260 mm/slab.c:3698
  dst_destroy+0x29e/0x3c0 net/core/dst.c:129
  dst_destroy_rcu+0x16/0x19 net/core/dst.c:142
  __rcu_reclaim kernel/rcu/rcu.h:222 [inline]
  rcu_do_batch kernel/rcu/tree.c:2092 [inline]
  invoke_rcu_callbacks kernel/rcu/tree.c:2310 [inline]
  rcu_core+0xba5/0x1500 kernel/rcu/tree.c:2291
  __do_softirq+0x25c/0x94c kernel/softirq.c:293

The buggy address belongs to the object at ffff8880973ed780
  which belongs to the cache ip6_dst_cache of size 224
The buggy address is located 95 bytes to the right of
  224-byte region [ffff8880973ed780, ffff8880973ed860)
The buggy address belongs to the page:
page:ffffea00025cfb40 refcount:1 mapcount:0 mapping:ffff88809b0b8cc0  
index:0xffff8880973ed000
flags: 0x1fffc0000000200(slab)
raw: 01fffc0000000200 ffffea00017a6288 ffffea00022d3f88 ffff88809b0b8cc0
raw: ffff8880973ed000 ffff8880973ed000 0000000100000002 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff8880973ed780: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff8880973ed800: fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
> ffff8880973ed880: fc fc fc fc fc fc fc fc 00 00 00 00 00 00 00 00
                                         ^
  ffff8880973ed900: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  ffff8880973ed980: 00 00 00 00 fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
