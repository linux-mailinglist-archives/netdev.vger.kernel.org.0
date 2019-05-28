Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87BE02BD13
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 03:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727890AbfE1B6G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 21:58:06 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:43647 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727858AbfE1B6F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 21:58:05 -0400
Received: by mail-io1-f72.google.com with SMTP id y15so14841500iod.10
        for <netdev@vger.kernel.org>; Mon, 27 May 2019 18:58:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=f50L0/gM15p3IwCPfAp/JpyNmK+MV7NE0qtjgZoia8w=;
        b=uPSXH/cvggBS6Y1uS0+vdGqisio4xy88cT8KgVIuZYXKvTGSGqq+QKIjVGFSnheWc9
         LPEZ1K4Q/NuOicFrnhX+JAnbJo9WmuNAKD+z3hZkem+c/v3Is617ODgiAk6hm2X8y4qi
         lkjnPEJkV+VkxPSNumGyXf9s/Oh4uTNVtTc1szPfrs9H9pSAmkQLEwxru2SY0+RNl9G4
         vdoKwYc3MF5AOH8icu/QCPpwVVmkjpW0YloHK+sZgXqW0A1IjNSXL1G314QjkcVQHa1J
         X/4o4YFSEvUNgsJi9Uaiox3uW/EdjATRT+mFV8cPa6gOpQjzFzO088xlA2em1O2qr50W
         x4Lg==
X-Gm-Message-State: APjAAAVvVTED/8Rrk8NqBa/gDDkzt9Po6KWpyx/7cnlf5/HJ8qDhiIU/
        zE6H/8JNwvLWmXqOcOOvDZb0UjMGyVivn8n/Sl6FsjggsSnf
X-Google-Smtp-Source: APXvYqzVah2+cIKF3bNv+ldrb/eL3LShn6Bo3r2PtgArFDsnpRzi6BB9x7k7hUGuAqFYiZ6g0C8CpB6LIWzOBGdB4kBxtF29IOrF
MIME-Version: 1.0
X-Received: by 2002:a6b:7605:: with SMTP id g5mr2679266iom.79.1559008684703;
 Mon, 27 May 2019 18:58:04 -0700 (PDT)
Date:   Mon, 27 May 2019 18:58:04 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000da88840589e8fe2c@google.com>
Subject: memory leak in nr_rx_frame
From:   syzbot <syzbot+d6636a36d3c34bd88938@syzkaller.appspotmail.com>
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

HEAD commit:    c5b44095 Merge tag 'trace-v5.2-rc1-2' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=135dcac4a00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=61dd9e15a761691d
dashboard link: https://syzkaller.appspot.com/bug?extid=d6636a36d3c34bd88938
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=159ca182a00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13ac4c5ca00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+d6636a36d3c34bd88938@syzkaller.appspotmail.com

DRCONF(NETDEV_CHANGE): hsr_slave_0: link becomes ready
executing program
executing program
BUG: memory leak
unreferenced object 0xffff88812393a800 (size 2048):
   comm "softirq", pid 0, jiffies 4294941705 (age 14.320s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     06 00 07 40 00 00 00 00 00 00 00 00 00 00 00 00  ...@............
   backtrace:
     [<0000000040c90168>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<0000000040c90168>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<0000000040c90168>] slab_alloc mm/slab.c:3326 [inline]
     [<0000000040c90168>] __do_kmalloc mm/slab.c:3658 [inline]
     [<0000000040c90168>] __kmalloc+0x161/0x2c0 mm/slab.c:3669
     [<00000000cf430504>] kmalloc include/linux/slab.h:552 [inline]
     [<00000000cf430504>] sk_prot_alloc+0xd6/0x170 net/core/sock.c:1608
     [<00000000d895dd9d>] sk_alloc+0x35/0x2f0 net/core/sock.c:1662
     [<000000006dfffbd8>] nr_make_new net/netrom/af_netrom.c:479 [inline]
     [<000000006dfffbd8>] nr_rx_frame+0x3ba/0x8a0 net/netrom/af_netrom.c:962
     [<000000007e984676>] nr_loopback_timer+0x4e/0xd0  
net/netrom/nr_loopback.c:62
     [<0000000080a4b335>] call_timer_fn+0x45/0x1e0 kernel/time/timer.c:1322
     [<00000000b58aba8b>] expire_timers kernel/time/timer.c:1366 [inline]
     [<00000000b58aba8b>] __run_timers kernel/time/timer.c:1685 [inline]
     [<00000000b58aba8b>] __run_timers kernel/time/timer.c:1653 [inline]
     [<00000000b58aba8b>] run_timer_softirq+0x256/0x740  
kernel/time/timer.c:1698
     [<00000000c8260f2e>] __do_softirq+0x115/0x35e kernel/softirq.c:293
     [<00000000a50d1686>] invoke_softirq kernel/softirq.c:374 [inline]
     [<00000000a50d1686>] irq_exit+0xbb/0xe0 kernel/softirq.c:414
     [<00000000fb3290a8>] exiting_irq arch/x86/include/asm/apic.h:536  
[inline]
     [<00000000fb3290a8>] smp_apic_timer_interrupt+0x7b/0x170  
arch/x86/kernel/apic/apic.c:1068
     [<000000001caa821f>] apic_timer_interrupt+0xf/0x20  
arch/x86/entry/entry_64.S:806
     [<0000000092c5e05c>] native_safe_halt+0xe/0x10  
arch/x86/include/asm/irqflags.h:60
     [<000000006b3a6a48>] arch_cpu_idle+0xa/0x10  
arch/x86/kernel/process.c:571
     [<00000000a7e7084a>] default_idle_call+0x1e/0x40 kernel/sched/idle.c:94
     [<00000000f6ad9bb1>] cpuidle_idle_call kernel/sched/idle.c:154 [inline]
     [<00000000f6ad9bb1>] do_idle+0x1ea/0x2c0 kernel/sched/idle.c:263
     [<00000000711ac4f4>] cpu_startup_entry+0x1b/0x20 kernel/sched/idle.c:354

BUG: memory leak
unreferenced object 0xffff88811f3ca1e0 (size 32):
   comm "softirq", pid 0, jiffies 4294941705 (age 14.320s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     03 00 00 00 03 00 00 00 0f 00 00 00 00 00 00 00  ................
   backtrace:
     [<000000005fe8e8f4>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<000000005fe8e8f4>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<000000005fe8e8f4>] slab_alloc mm/slab.c:3326 [inline]
     [<000000005fe8e8f4>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<000000003ffaa535>] kmalloc include/linux/slab.h:547 [inline]
     [<000000003ffaa535>] kzalloc include/linux/slab.h:742 [inline]
     [<000000003ffaa535>] selinux_sk_alloc_security+0x48/0xb0  
security/selinux/hooks.c:5059
     [<000000001306812e>] security_sk_alloc+0x49/0x70  
security/security.c:2030
     [<00000000bbbf2d36>] sk_prot_alloc+0xf1/0x170 net/core/sock.c:1611
     [<00000000d895dd9d>] sk_alloc+0x35/0x2f0 net/core/sock.c:1662
     [<000000006dfffbd8>] nr_make_new net/netrom/af_netrom.c:479 [inline]
     [<000000006dfffbd8>] nr_rx_frame+0x3ba/0x8a0 net/netrom/af_netrom.c:962
     [<000000007e984676>] nr_loopback_timer+0x4e/0xd0  
net/netrom/nr_loopback.c:62
     [<0000000080a4b335>] call_timer_fn+0x45/0x1e0 kernel/time/timer.c:1322
     [<00000000b58aba8b>] expire_timers kernel/time/timer.c:1366 [inline]
     [<00000000b58aba8b>] __run_timers kernel/time/timer.c:1685 [inline]
     [<00000000b58aba8b>] __run_timers kernel/time/timer.c:1653 [inline]
     [<00000000b58aba8b>] run_timer_softirq+0x256/0x740  
kernel/time/timer.c:1698
     [<00000000c8260f2e>] __do_softirq+0x115/0x35e kernel/softirq.c:293
     [<00000000a50d1686>] invoke_softirq kernel/softirq.c:374 [inline]
     [<00000000a50d1686>] irq_exit+0xbb/0xe0 kernel/softirq.c:414
     [<00000000fb3290a8>] exiting_irq arch/x86/include/asm/apic.h:536  
[inline]
     [<00000000fb3290a8>] smp_apic_timer_interrupt+0x7b/0x170  
arch/x86/kernel/apic/apic.c:1068
     [<000000001caa821f>] apic_timer_interrupt+0xf/0x20  
arch/x86/entry/entry_64.S:806
     [<0000000092c5e05c>] native_safe_halt+0xe/0x10  
arch/x86/include/asm/irqflags.h:60
     [<000000006b3a6a48>] arch_cpu_idle+0xa/0x10  
arch/x86/kernel/process.c:571
     [<00000000a7e7084a>] default_idle_call+0x1e/0x40 kernel/sched/idle.c:94



---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
