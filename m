Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CADA67BAB5
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 09:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727753AbfGaHaH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 03:30:07 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:33766 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726276AbfGaHaG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 03:30:06 -0400
Received: by mail-io1-f72.google.com with SMTP id 132so74328043iou.0
        for <netdev@vger.kernel.org>; Wed, 31 Jul 2019 00:30:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=fEqW5tuvMUBK4ukFw+FCuX0JST0YS4Tm9idRhLasMrk=;
        b=GrtyjnwgSYPeafoEhyHMt69b6y3p/2ZfF41KTwHuVoZcgVYGtV1Z654i0eWHw7VCRe
         BlcZqHF6Fk1W46b/jXlOM8pkHTurcWacdz4feCI64W3LFKXlu87C/71zuGSz2fmHNpMO
         mI3lr6hKHm5N9nP7M3iquBX+m/15q/m+FlS5Sh/zSfdtRizU9veccZwxSlABMoIYFSlD
         3YXKchBRIUQpUNcC1cs2aHRCLy0br6HUqXWoCw0qCWDuPeM0c7cjC8rc6AEviRZHpkpS
         jQs+BvYP0GLGT/87SX0eUCofqD3yGgGvwdChpI3WUSB72mPhK6eLYY1pazKan8xyLdiC
         MMrw==
X-Gm-Message-State: APjAAAW/K8Xm65bt2vHZsdJ7N8USML5s/P3nJrJt16YTyAik6rWOugkI
        7J/V8yfCKBS537MNV4A5mICFXfhpGP+QbKtGi1XIe6t2s9eu
X-Google-Smtp-Source: APXvYqzu4CVrgVzYDlhPnSDYUmksKHIY1zZlsfbdP+ygr+lQEooU1SLSELesosm2gWyYBcng8YcmsER7g2ip9FHHGGjygBKhp8Y6
MIME-Version: 1.0
X-Received: by 2002:a02:528a:: with SMTP id d132mr117378564jab.68.1564558205838;
 Wed, 31 Jul 2019 00:30:05 -0700 (PDT)
Date:   Wed, 31 Jul 2019 00:30:05 -0700
In-Reply-To: <000000000000e42667058e554371@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000016ecdd058ef518f3@google.com>
Subject: Re: KASAN: use-after-free Read in nr_rx_frame (2)
From:   syzbot <syzbot+701728447042217b67c1@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dvyukov@google.com,
        linux-hams@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, ralf@linux-mips.org,
        syzkaller-bugs@googlegroups.com, xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    629f8205 Merge tag 'for-linus-20190730' of git://git.kerne..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15856062600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e397351d2615e10
dashboard link: https://syzkaller.appspot.com/bug?extid=701728447042217b67c1
compiler:       clang version 9.0.0 (/home/glider/llvm/clang  
80fee25776c2fb61e74c1ecb1a523375c2500b69)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14a6e008600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11937d92600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+701728447042217b67c1@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in atomic_read  
include/asm-generic/atomic-instrumented.h:26 [inline]
BUG: KASAN: use-after-free in refcount_inc_not_zero_checked+0x7c/0x280  
lib/refcount.c:123
Read of size 4 at addr ffff8880893ccec0 by task swapper/0/0

CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.3.0-rc2+ #56
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  <IRQ>
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x1d8/0x2f8 lib/dump_stack.c:113
  print_address_description+0x75/0x5b0 mm/kasan/report.c:351
  __kasan_report+0x14b/0x1c0 mm/kasan/report.c:482
  kasan_report+0x26/0x50 mm/kasan/common.c:612
  check_memory_region_inline mm/kasan/generic.c:182 [inline]
  check_memory_region+0x2cf/0x2e0 mm/kasan/generic.c:192
  __kasan_check_read+0x11/0x20 mm/kasan/common.c:92
  atomic_read include/asm-generic/atomic-instrumented.h:26 [inline]
  refcount_inc_not_zero_checked+0x7c/0x280 lib/refcount.c:123
  refcount_inc_checked+0x15/0x50 lib/refcount.c:156
  sock_hold include/net/sock.h:649 [inline]
  sk_add_node include/net/sock.h:701 [inline]
  nr_insert_socket net/netrom/af_netrom.c:137 [inline]
  nr_rx_frame+0x17bc/0x1e40 net/netrom/af_netrom.c:1023
  nr_loopback_timer+0x6a/0x140 net/netrom/nr_loopback.c:59
  call_timer_fn+0xec/0x200 kernel/time/timer.c:1322
  expire_timers kernel/time/timer.c:1366 [inline]
  __run_timers+0x7cd/0x9c0 kernel/time/timer.c:1685
  run_timer_softirq+0x4a/0x90 kernel/time/timer.c:1698
  __do_softirq+0x333/0x7c4 arch/x86/include/asm/paravirt.h:778
  invoke_softirq kernel/softirq.c:373 [inline]
  irq_exit+0x227/0x230 kernel/softirq.c:413
  exiting_irq arch/x86/include/asm/apic.h:537 [inline]
  smp_apic_timer_interrupt+0x113/0x280 arch/x86/kernel/apic/apic.c:1095
  apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:828
  </IRQ>
RIP: 0010:native_safe_halt+0xe/0x10 arch/x86/include/asm/irqflags.h:61
Code: 01 fa eb ae 89 d9 80 e1 07 80 c1 03 38 c1 7c ba 48 89 df e8 74 3b 01  
fa eb b0 90 90 e9 07 00 00 00 0f 00 2d d6 36 51 00 fb f4 <c3> 90 e9 07 00  
00 00 0f 00 2d c6 36 51 00 f4 c3 90 90 55 48 89 e5
RSP: 0018:ffffffff88c07cd8 EFLAGS: 00000286 ORIG_RAX: ffffffffffffff13
RAX: 1ffffffff11950f3 RBX: ffffffff88c75a00 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: ffffffff812d2b3a RDI: ffffffff87b14d9a
RBP: ffffffff88c07ce0 R08: ffffffff817d8974 R09: fffffbfff118eb41
R10: fffffbfff118eb41 R11: 0000000000000000 R12: 0000000000000000
R13: 1ffffffff118eb40 R14: dffffc0000000000 R15: dffffc0000000000
  arch_cpu_idle+0xa/0x10 arch/x86/kernel/process.c:571
  default_idle_call+0x59/0xa0 kernel/sched/idle.c:94
  cpuidle_idle_call kernel/sched/idle.c:154 [inline]
  do_idle+0x180/0x780 kernel/sched/idle.c:263
  cpu_startup_entry+0x25/0x30 kernel/sched/idle.c:354
  rest_init+0x29d/0x2b0 init/main.c:451
  arch_call_rest_init+0xe/0x10
  start_kernel+0x751/0x871 init/main.c:785
  x86_64_start_reservations+0x18/0x2e arch/x86/kernel/head64.c:472
  x86_64_start_kernel+0x7a/0x7d arch/x86/kernel/head64.c:453
  secondary_startup_64+0xa4/0xb0 arch/x86/kernel/head_64.S:241

Allocated by task 0:
  save_stack mm/kasan/common.c:69 [inline]
  set_track mm/kasan/common.c:77 [inline]
  __kasan_kmalloc+0x11c/0x1b0 mm/kasan/common.c:487
  kasan_kmalloc+0x9/0x10 mm/kasan/common.c:501
  __do_kmalloc mm/slab.c:3655 [inline]
  __kmalloc+0x254/0x340 mm/slab.c:3664
  kmalloc include/linux/slab.h:557 [inline]
  sk_prot_alloc+0xb0/0x290 net/core/sock.c:1603
  sk_alloc+0x38/0x950 net/core/sock.c:1657
  nr_make_new net/netrom/af_netrom.c:476 [inline]
  nr_rx_frame+0xabc/0x1e40 net/netrom/af_netrom.c:959
  nr_loopback_timer+0x6a/0x140 net/netrom/nr_loopback.c:59
  call_timer_fn+0xec/0x200 kernel/time/timer.c:1322
  expire_timers kernel/time/timer.c:1366 [inline]
  __run_timers+0x7cd/0x9c0 kernel/time/timer.c:1685
  run_timer_softirq+0x4a/0x90 kernel/time/timer.c:1698
  __do_softirq+0x333/0x7c4 arch/x86/include/asm/paravirt.h:778

Freed by task 23150:
  save_stack mm/kasan/common.c:69 [inline]
  set_track mm/kasan/common.c:77 [inline]
  __kasan_slab_free+0x12a/0x1e0 mm/kasan/common.c:449
  kasan_slab_free+0xe/0x10 mm/kasan/common.c:457
  __cache_free mm/slab.c:3425 [inline]
  kfree+0x115/0x200 mm/slab.c:3756
  sk_prot_free net/core/sock.c:1640 [inline]
  __sk_destruct+0x567/0x660 net/core/sock.c:1726
  sk_destruct net/core/sock.c:1734 [inline]
  __sk_free+0x317/0x3e0 net/core/sock.c:1745
  sk_free net/core/sock.c:1756 [inline]
  sock_put include/net/sock.h:1725 [inline]
  sock_efree+0x60/0x80 net/core/sock.c:2042
  skb_release_head_state+0x100/0x220 net/core/skbuff.c:652
  skb_release_all net/core/skbuff.c:663 [inline]
  __kfree_skb+0x25/0x170 net/core/skbuff.c:679
  kfree_skb+0x6f/0xb0 net/core/skbuff.c:697
  nr_accept+0x4ef/0x650 net/netrom/af_netrom.c:819
  __sys_accept4+0x5bc/0x9a0 net/socket.c:1754
  __do_sys_accept net/socket.c:1795 [inline]
  __se_sys_accept net/socket.c:1792 [inline]
  __x64_sys_accept+0x7d/0x90 net/socket.c:1792
  do_syscall_64+0xfe/0x140 arch/x86/entry/common.c:296
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff8880893cce40
  which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 128 bytes inside of
  2048-byte region [ffff8880893cce40, ffff8880893cd640)
The buggy address belongs to the page:
page:ffffea000224f300 refcount:1 mapcount:0 mapping:ffff8880aa400e00  
index:0x0 compound_mapcount: 0
flags: 0x1fffc0000010200(slab|head)
raw: 01fffc0000010200 ffffea0002924d08 ffffea00027f7288 ffff8880aa400e00
raw: 0000000000000000 ffff8880893cc5c0 0000000100000003 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff8880893ccd80: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
  ffff8880893cce00: fc fc fc fc fc fc fc fc fb fb fb fb fb fb fb fb
> ffff8880893cce80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                            ^
  ffff8880893ccf00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff8880893ccf80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================
------------[ cut here ]------------
ODEBUG: activate not available (active state 0) object type: timer_list  
hint: nr_heartbeat_expiry+0x0/0x420 net/netrom/nr_timer.c:193
WARNING: CPU: 0 PID: 0 at lib/debugobjects.c:484 debug_print_object  
lib/debugobjects.c:481 [inline]
WARNING: CPU: 0 PID: 0 at lib/debugobjects.c:484  
debug_object_activate+0x33d/0x6f0 lib/debugobjects.c:680
Modules linked in:
CPU: 0 PID: 0 Comm: swapper/0 Tainted: G    B             5.3.0-rc2+ #56
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:debug_print_object lib/debugobjects.c:481 [inline]
RIP: 0010:debug_object_activate+0x33d/0x6f0 lib/debugobjects.c:680
Code: f7 e8 47 04 4a fe 4d 8b 06 48 c7 c7 ba 55 88 88 48 c7 c6 00 2d a1 88  
48 c7 c2 c3 68 81 88 31 c9 49 89 d9 31 c0 e8 93 6a e0 fd <0f> 0b 48 ba 00  
00 00 00 00 fc ff df ff 05 55 99 95 05 49 83 c6 20
RSP: 0018:ffff8880aea09928 EFLAGS: 00010046
RAX: ec91b22b9b388e00 RBX: ffffffff86dc4cc0 RCX: ffffffff88c75a00
RDX: 0000000000000102 RSI: 0000000000000102 RDI: 0000000000000000
RBP: ffff8880aea09970 R08: ffffffff816068e4 R09: fffffbfff119a975
R10: fffffbfff119a975 R11: 0000000000000000 R12: ffff888218471280
R13: 1ffff1104308e250 R14: ffffffff88cda040 R15: ffff8880893cd108
FS:  0000000000000000(0000) GS:ffff8880aea00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f5db7f62db8 CR3: 00000000a0178000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  <IRQ>
  debug_timer_activate kernel/time/timer.c:710 [inline]
  __mod_timer+0x960/0x16e0 kernel/time/timer.c:1035
  mod_timer+0x1f/0x30 kernel/time/timer.c:1096
  sk_reset_timer+0x22/0x50 net/core/sock.c:2821
  nr_start_heartbeat+0x54/0x60 net/netrom/nr_timer.c:79
  nr_rx_frame+0x184c/0x1e40 net/netrom/af_netrom.c:1025
  nr_loopback_timer+0x6a/0x140 net/netrom/nr_loopback.c:59
  call_timer_fn+0xec/0x200 kernel/time/timer.c:1322
  expire_timers kernel/time/timer.c:1366 [inline]
  __run_timers+0x7cd/0x9c0 kernel/time/timer.c:1685
  run_timer_softirq+0x4a/0x90 kernel/time/timer.c:1698
  __do_softirq+0x333/0x7c4 arch/x86/include/asm/paravirt.h:778
  invoke_softirq kernel/softirq.c:373 [inline]
  irq_exit+0x227/0x230 kernel/softirq.c:413
  exiting_irq arch/x86/include/asm/apic.h:537 [inline]
  smp_apic_timer_interrupt+0x113/0x280 arch/x86/kernel/apic/apic.c:1095
  apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:828
  </IRQ>
RIP: 0010:native_safe_halt+0xe/0x10 arch/x86/include/asm/irqflags.h:61
Code: 01 fa eb ae 89 d9 80 e1 07 80 c1 03 38 c1 7c ba 48 89 df e8 74 3b 01  
fa eb b0 90 90 e9 07 00 00 00 0f 00 2d d6 36 51 00 fb f4 <c3> 90 e9 07 00  
00 00 0f 00 2d c6 36 51 00 f4 c3 90 90 55 48 89 e5
RSP: 0018:ffffffff88c07cd8 EFLAGS: 00000286 ORIG_RAX: ffffffffffffff13
RAX: 1ffffffff11950f3 RBX: ffffffff88c75a00 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: ffffffff812d2b3a RDI: ffffffff87b14d9a
RBP: ffffffff88c07ce0 R08: ffffffff817d8974 R09: fffffbfff118eb41
R10: fffffbfff118eb41 R11: 0000000000000000 R12: 0000000000000000
R13: 1ffffffff118eb40 R14: dffffc0000000000 R15: dffffc0000000000
  arch_cpu_idle+0xa/0x10 arch/x86/kernel/process.c:571
  default_idle_call+0x59/0xa0 kernel/sched/idle.c:94
  cpuidle_idle_call kernel/sched/idle.c:154 [inline]
  do_idle+0x180/0x780 kernel/sched/idle.c:263
  cpu_startup_entry+0x25/0x30 kernel/sched/idle.c:354
  rest_init+0x29d/0x2b0 init/main.c:451
  arch_call_rest_init+0xe/0x10
  start_kernel+0x751/0x871 init/main.c:785
  x86_64_start_reservations+0x18/0x2e arch/x86/kernel/head64.c:472
  x86_64_start_kernel+0x7a/0x7d arch/x86/kernel/head64.c:453
  secondary_startup_64+0xa4/0xb0 arch/x86/kernel/head_64.S:241
irq event stamp: 101048
hardirqs last  enabled at (101047): [<ffffffff816b39fd>]  
tick_nohz_idle_exit+0x2bd/0x3a0 kernel/time/tick-sched.c:1180
hardirqs last disabled at (101048): [<ffffffff87b07f01>]  
__schedule+0x121/0xcd0 kernel/sched/core.c:3821
softirqs last  enabled at (100320): [<ffffffff814a5627>] invoke_softirq  
kernel/softirq.c:373 [inline]
softirqs last  enabled at (100320): [<ffffffff814a5627>]  
irq_exit+0x227/0x230 kernel/softirq.c:413
softirqs last disabled at (100307): [<ffffffff814a5627>] invoke_softirq  
kernel/softirq.c:373 [inline]
softirqs last disabled at (100307): [<ffffffff814a5627>]  
irq_exit+0x227/0x230 kernel/softirq.c:413
---[ end trace c1ceb269b6c91467 ]---

