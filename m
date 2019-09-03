Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E041A6B9B
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 16:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729591AbfICOfI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 10:35:08 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:54289 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727667AbfICOfI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 10:35:08 -0400
Received: by mail-io1-f70.google.com with SMTP id a20so23247088iok.21
        for <netdev@vger.kernel.org>; Tue, 03 Sep 2019 07:35:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=jec/Ra5GNrcyEymYVqUVNgWogybFrHUiJN1qV6vB/yM=;
        b=Fn0OywfVv5GiFhJzrVH44Fb0vcSjKsQtN0k6/9pOXNA2Qc7rmnEcUhf7MtrZmGc3xA
         d5hobmN3O1RiYllBzy56Kp4LO97p+4hHGJje+b9Soz192R388vp7+J/DLxEKmm4Os22i
         wJCT2i8hX03U0zh0TpINUILZofwivB3bNLyB84nQHsOevtekt3DLG60PJIVm/b9AV4P7
         h+LpAefanafeUzmCVtotz/4YB1aXsgnxRchWjElXzy1mjvtesfQHQr3rrjvj3psWEDP/
         WpT/OavRx0wSNTTwr0WSVaRvRkMAmYOYPkJAGyTVjETFogx5x5n9scz4ITrbFRvcco4w
         WNhQ==
X-Gm-Message-State: APjAAAUk0RCzsnJrBKjFfgKCqRiZCTQ0jeXVkwAS7/320e1dKUSTxPB+
        r318BQ5xJN/R1XB8v0OkF9b9vqHWeLHj5PlevcAKhTkcxPQW
X-Google-Smtp-Source: APXvYqw+nyjc5WbikgKoPnYYpTrRUmgtztguYJaqolLr+QBCZEknaipFKO42lcVJW2dZSA/A32QEaW7dYivQX3L6KAwVKq9GDiBc
MIME-Version: 1.0
X-Received: by 2002:a6b:b494:: with SMTP id d142mr21230442iof.156.1567521307066;
 Tue, 03 Sep 2019 07:35:07 -0700 (PDT)
Date:   Tue, 03 Sep 2019 07:35:07 -0700
In-Reply-To: <0000000000003d789d05915a9fa3@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000af90d20591a6fea0@google.com>
Subject: Re: memory leak in nr_rx_frame (2)
From:   syzbot <syzbot+0145ea560de205bc09f0@syzkaller.appspotmail.com>
To:     davem@davemloft.net, linux-hams@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        ralf@linux-mips.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    089cf7f6 Linux 5.3-rc7
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14100532600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b10436cfda3838d9
dashboard link: https://syzkaller.appspot.com/bug?extid=0145ea560de205bc09f0
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=124dcf8e600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=115f2346600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+0145ea560de205bc09f0@syzkaller.appspotmail.com

executing program
executing program
executing program
executing program
executing program
BUG: memory leak
unreferenced object 0xffff88810de01800 (size 2048):
   comm "softirq", pid 0, jiffies 4294947090 (age 27.260s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     06 00 07 40 00 00 00 00 00 00 00 00 00 00 00 00  ...@............
   backtrace:
     [<0000000002377dcf>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<0000000002377dcf>] slab_post_alloc_hook mm/slab.h:522 [inline]
     [<0000000002377dcf>] slab_alloc mm/slab.c:3319 [inline]
     [<0000000002377dcf>] __do_kmalloc mm/slab.c:3653 [inline]
     [<0000000002377dcf>] __kmalloc+0x169/0x300 mm/slab.c:3664
     [<00000000af16d1f0>] kmalloc include/linux/slab.h:557 [inline]
     [<00000000af16d1f0>] sk_prot_alloc+0x112/0x170 net/core/sock.c:1603
     [<00000000b9033c4c>] sk_alloc+0x35/0x2f0 net/core/sock.c:1657
     [<00000000fb9e6269>] nr_make_new net/netrom/af_netrom.c:476 [inline]
     [<00000000fb9e6269>] nr_rx_frame+0x339/0x8ee net/netrom/af_netrom.c:959
     [<00000000fca3a307>] nr_loopback_timer+0x4e/0xd0  
net/netrom/nr_loopback.c:59
     [<0000000009d4e723>] call_timer_fn+0x45/0x1e0 kernel/time/timer.c:1322
     [<0000000047ea1d35>] expire_timers kernel/time/timer.c:1366 [inline]
     [<0000000047ea1d35>] __run_timers kernel/time/timer.c:1685 [inline]
     [<0000000047ea1d35>] __run_timers kernel/time/timer.c:1653 [inline]
     [<0000000047ea1d35>] run_timer_softirq+0x256/0x740  
kernel/time/timer.c:1698
     [<00000000e53c6536>] __do_softirq+0x115/0x33f kernel/softirq.c:292
     [<0000000024be59bc>] invoke_softirq kernel/softirq.c:373 [inline]
     [<0000000024be59bc>] irq_exit+0xbb/0xe0 kernel/softirq.c:413
     [<0000000080d19282>] exiting_irq arch/x86/include/asm/apic.h:537  
[inline]
     [<0000000080d19282>] smp_apic_timer_interrupt+0x96/0x190  
arch/x86/kernel/apic/apic.c:1133
     [<000000000e93dbd5>] apic_timer_interrupt+0xf/0x20  
arch/x86/entry/entry_64.S:830
     [<000000002864ce39>] native_safe_halt+0xe/0x10  
arch/x86/include/asm/irqflags.h:60
     [<000000007e3841ad>] arch_cpu_idle+0xa/0x10  
arch/x86/kernel/process.c:571
     [<00000000546bc34f>] default_idle_call+0x1e/0x40 kernel/sched/idle.c:94
     [<00000000e98df687>] cpuidle_idle_call kernel/sched/idle.c:154 [inline]
     [<00000000e98df687>] do_idle+0x1ea/0x2c0 kernel/sched/idle.c:263
     [<000000001e3f823f>] cpu_startup_entry+0x1b/0x20 kernel/sched/idle.c:354

BUG: memory leak
unreferenced object 0xffff88810fa3c9a0 (size 32):
   comm "softirq", pid 0, jiffies 4294947090 (age 27.260s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     03 00 00 00 03 00 00 00 0f 00 00 00 00 00 00 00  ................
   backtrace:
     [<00000000e9077829>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<00000000e9077829>] slab_post_alloc_hook mm/slab.h:522 [inline]
     [<00000000e9077829>] slab_alloc mm/slab.c:3319 [inline]
     [<00000000e9077829>] kmem_cache_alloc_trace+0x145/0x2c0 mm/slab.c:3548
     [<0000000037f78c54>] kmalloc include/linux/slab.h:552 [inline]
     [<0000000037f78c54>] kzalloc include/linux/slab.h:748 [inline]
     [<0000000037f78c54>] selinux_sk_alloc_security+0x48/0xb0  
security/selinux/hooks.c:5073
     [<00000000313a65ff>] security_sk_alloc+0x49/0x70  
security/security.c:2029
     [<00000000ffa4a0b0>] sk_prot_alloc+0x12d/0x170 net/core/sock.c:1606
     [<00000000b9033c4c>] sk_alloc+0x35/0x2f0 net/core/sock.c:1657
     [<00000000fb9e6269>] nr_make_new net/netrom/af_netrom.c:476 [inline]
     [<00000000fb9e6269>] nr_rx_frame+0x339/0x8ee net/netrom/af_netrom.c:959
     [<00000000fca3a307>] nr_loopback_timer+0x4e/0xd0  
net/netrom/nr_loopback.c:59
     [<0000000009d4e723>] call_timer_fn+0x45/0x1e0 kernel/time/timer.c:1322
     [<0000000047ea1d35>] expire_timers kernel/time/timer.c:1366 [inline]
     [<0000000047ea1d35>] __run_timers kernel/time/timer.c:1685 [inline]
     [<0000000047ea1d35>] __run_timers kernel/time/timer.c:1653 [inline]
     [<0000000047ea1d35>] run_timer_softirq+0x256/0x740  
kernel/time/timer.c:1698
     [<00000000e53c6536>] __do_softirq+0x115/0x33f kernel/softirq.c:292
     [<0000000024be59bc>] invoke_softirq kernel/softirq.c:373 [inline]
     [<0000000024be59bc>] irq_exit+0xbb/0xe0 kernel/softirq.c:413
     [<0000000080d19282>] exiting_irq arch/x86/include/asm/apic.h:537  
[inline]
     [<0000000080d19282>] smp_apic_timer_interrupt+0x96/0x190  
arch/x86/kernel/apic/apic.c:1133
     [<000000000e93dbd5>] apic_timer_interrupt+0xf/0x20  
arch/x86/entry/entry_64.S:830
     [<000000002864ce39>] native_safe_halt+0xe/0x10  
arch/x86/include/asm/irqflags.h:60
     [<000000007e3841ad>] arch_cpu_idle+0xa/0x10  
arch/x86/kernel/process.c:571
     [<00000000546bc34f>] default_idle_call+0x1e/0x40 kernel/sched/idle.c:94

BUG: memory leak
unreferenced object 0xffff88810de01800 (size 2048):
   comm "softirq", pid 0, jiffies 4294947090 (age 30.780s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     06 00 07 40 00 00 00 00 00 00 00 00 00 00 00 00  ...@............
   backtrace:
     [<0000000002377dcf>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<0000000002377dcf>] slab_post_alloc_hook mm/slab.h:522 [inline]
     [<0000000002377dcf>] slab_alloc mm/slab.c:3319 [inline]
     [<0000000002377dcf>] __do_kmalloc mm/slab.c:3653 [inline]
     [<0000000002377dcf>] __kmalloc+0x169/0x300 mm/slab.c:3664
     [<00000000af16d1f0>] kmalloc include/linux/slab.h:557 [inline]
     [<00000000af16d1f0>] sk_prot_alloc+0x112/0x170 net/core/sock.c:1603
     [<00000000b9033c4c>] sk_alloc+0x35/0x2f0 net/core/sock.c:1657
     [<00000000fb9e6269>] nr_make_new net/netrom/af_netrom.c:476 [inline]
     [<00000000fb9e6269>] nr_rx_frame+0x339/0x8ee net/netrom/af_netrom.c:959
     [<00000000fca3a307>] nr_loopback_timer+0x4e/0xd0  
net/netrom/nr_loopback.c:59
     [<0000000009d4e723>] call_timer_fn+0x45/0x1e0 kernel/time/timer.c:1322
     [<0000000047ea1d35>] expire_timers kernel/time/timer.c:1366 [inline]
     [<0000000047ea1d35>] __run_timers kernel/time/timer.c:1685 [inline]
     [<0000000047ea1d35>] __run_timers kernel/time/timer.c:1653 [inline]
     [<0000000047ea1d35>] run_timer_softirq+0x256/0x740  
kernel/time/timer.c:1698
     [<00000000e53c6536>] __do_softirq+0x115/0x33f kernel/softirq.c:292
     [<0000000024be59bc>] invoke_softirq kernel/softirq.c:373 [inline]
     [<0000000024be59bc>] irq_exit+0xbb/0xe0 kernel/softirq.c:413
     [<0000000080d19282>] exiting_irq arch/x86/include/asm/apic.h:537  
[inline]
     [<0000000080d19282>] smp_apic_timer_interrupt+0x96/0x190  
arch/x86/kernel/apic/apic.c:1133
     [<000000000e93dbd5>] apic_timer_interrupt+0xf/0x20  
arch/x86/entry/entry_64.S:830
     [<000000002864ce39>] native_safe_halt+0xe/0x10  
arch/x86/include/asm/irqflags.h:60
     [<000000007e3841ad>] arch_cpu_idle+0xa/0x10  
arch/x86/kernel/process.c:571
     [<00000000546bc34f>] default_idle_call+0x1e/0x40 kernel/sched/idle.c:94
     [<00000000e98df687>] cpuidle_idle_call kernel/sched/idle.c:154 [inline]
     [<00000000e98df687>] do_idle+0x1ea/0x2c0 kernel/sched/idle.c:263
     [<000000001e3f823f>] cpu_startup_entry+0x1b/0x20 kernel/sched/idle.c:354

BUG: memory leak
unreferenced object 0xffff88810fa3c9a0 (size 32):
   comm "softirq", pid 0, jiffies 4294947090 (age 30.780s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     03 00 00 00 03 00 00 00 0f 00 00 00 00 00 00 00  ................
   backtrace:
     [<00000000e9077829>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<00000000e9077829>] slab_post_alloc_hook mm/slab.h:522 [inline]
     [<00000000e9077829>] slab_alloc mm/slab.c:3319 [inline]
     [<00000000e9077829>] kmem_cache_alloc_trace+0x145/0x2c0 mm/slab.c:3548
     [<0000000037f78c54>] kmalloc include/linux/slab.h:552 [inline]
     [<0000000037f78c54>] kzalloc include/linux/slab.h:748 [inline]
     [<0000000037f78c54>] selinux_sk_alloc_security+0x48/0xb0  
security/selinux/hooks.c:5073
     [<00000000313a65ff>] security_sk_alloc+0x49/0x70  
security/security.c:2029
     [<00000000ffa4a0b0>] sk_prot_alloc+0x12d/0x170 net/core/sock.c:1606
     [<00000000b9033c4c>] sk_alloc+0x35/0x2f0 net/core/sock.c:1657
     [<00000000fb9e6269>] nr_make_new net/netrom/af_netrom.c:476 [inline]
     [<00000000fb9e6269>] nr_rx_frame+0x339/0x8ee net/netrom/af_netrom.c:959
     [<00000000fca3a307>] nr_loopback_timer+0x4e/0xd0  
net/netrom/nr_loopback.c:59
     [<0000000009d4e723>] call_timer_fn+0x45/0x1e0 kernel/time/timer.c:1322
     [<0000000047ea1d35>] expire_timers kernel/time/timer.c:1366 [inline]
     [<0000000047ea1d35>] __run_timers kernel/time/timer.c:1685 [inline]
     [<0000000047ea1d35>] __run_timers kernel/time/timer.c:1653 [inline]
     [<0000000047ea1d35>] run_timer_softirq+0x256/0x740  
kernel/time/timer.c:1698
     [<00000000e53c6536>] __do_softirq+0x115/0x33f kernel/softirq.c:292
     [<0000000024be59bc>] invoke_softirq kernel/softirq.c:373 [inline]
     [<0000000024be59bc>] irq_exit+0xbb/0xe0 kernel/softirq.c:413
     [<0000000080d19282>] exiting_irq arch/x86/include/asm/apic.h:537  
[inline]
     [<0000000080d19282>] smp_apic_timer_interrupt+0x96/0x190  
arch/x86/kernel/apic/apic.c:1133
     [<000000000e93dbd5>] apic_timer_interrupt+0xf/0x20  
arch/x86/entry/entry_64.S:830
     [<000000002864ce39>] native_safe_halt+0xe/0x10  
arch/x86/include/asm/irqflags.h:60
     [<000000007e3841ad>] arch_cpu_idle+0xa/0x10  
arch/x86/kernel/process.c:571
     [<00000000546bc34f>] default_idle_call+0x1e/0x40 kernel/sched/idle.c:94

BUG: memory leak
unreferenced object 0xffff88810de01800 (size 2048):
   comm "softirq", pid 0, jiffies 4294947090 (age 32.010s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     06 00 07 40 00 00 00 00 00 00 00 00 00 00 00 00  ...@............
   backtrace:
     [<0000000002377dcf>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<0000000002377dcf>] slab_post_alloc_hook mm/slab.h:522 [inline]
     [<0000000002377dcf>] slab_alloc mm/slab.c:3319 [inline]
     [<0000000002377dcf>] __do_kmalloc mm/slab.c:3653 [inline]
     [<0000000002377dcf>] __kmalloc+0x169/0x300 mm/slab.c:3664
     [<00000000af16d1f0>] kmalloc include/linux/slab.h:557 [inline]
     [<00000000af16d1f0>] sk_prot_alloc+0x112/0x170 net/core/sock.c:1603
     [<00000000b9033c4c>] sk_alloc+0x35/0x2f0 net/core/sock.c:1657
     [<00000000fb9e6269>] nr_make_new net/netrom/af_netrom.c:476 [inline]
     [<00000000fb9e6269>] nr_rx_frame+0x339/0x8ee net/netrom/af_netrom.c:959
     [<00000000fca3a307>] nr_loopback_timer+0x4e/0xd0  
net/netrom/nr_loopback.c:59
     [<0000000009d4e723>] call_timer_fn+0x45/0x1e0 kernel/time/timer.c:1322
     [<0000000047ea1d35>] expire_timers kernel/time/timer.c:1366 [inline]
     [<0000000047ea1d35>] __run_timers kernel/time/timer.c:1685 [inline]
     [<0000000047ea1d35>] __run_timers kernel/time/timer.c:1653 [inline]
     [<0000000047ea1d35>] run_timer_softirq+0x256/0x740  
kernel/time/timer.c:1698
     [<00000000e53c6536>] __do_softirq+0x115/0x33f kernel/softirq.c:292
     [<0000000024be59bc>] invoke_softirq kernel/softirq.c:373 [inline]
     [<0000000024be59bc>] irq_exit+0xbb/0xe0 kernel/softirq.c:413
     [<0000000080d19282>] exiting_irq arch/x86/include/asm/apic.h:537  
[inline]
     [<0000000080d19282>] smp_apic_timer_interrupt+0x96/0x190  
arch/x86/kernel/apic/apic.c:1133
     [<000000000e93dbd5>] apic_timer_interrupt+0xf/0x20  
arch/x86/entry/entry_64.S:830
     [<000000002864ce39>] native_safe_halt+0xe/0x10  
arch/x86/include/asm/irqflags.h:60
     [<000000007e3841ad>] arch_cpu_idle+0xa/0x10  
arch/x86/kernel/process.c:571
     [<00000000546bc34f>] default_idle_call+0x1e/0x40 kernel/sched/idle.c:94
     [<00000000e98df687>] cpuidle_idle_call kernel/sched/idle.c:154 [inline]
     [<00000000e98df687>] do_idle+0x1ea/0x2c0 kernel/sched/idle.c:263
     [<000000001e3f823f>] cpu_startup_entry+0x1b/0x20 kernel/sched/idle.c:354

BUG: memory leak
unreferenced object 0xffff88810fa3c9a0 (size 32):
   comm "softirq", pid 0, jiffies 4294947090 (age 32.010s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     03 00 00 00 03 00 00 00 0f 00 00 00 00 00 00 00  ................
   backtrace:
     [<00000000e9077829>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<00000000e9077829>] slab_post_alloc_hook mm/slab.h:522 [inline]
     [<00000000e9077829>] slab_alloc mm/slab.c:3319 [inline]
     [<00000000e9077829>] kmem_cache_alloc_trace+0x145/0x2c0 mm/slab.c:3548
     [<0000000037f78c54>] kmalloc include/linux/slab.h:552 [inline]
     [<0000000037f78c54>] kzalloc include/linux/slab.h:748 [inline]
     [<0000000037f78c54>] selinux_sk_alloc_security+0x48/0xb0  
security/selinux/hooks.c:5073
     [<00000000313a65ff>] security_sk_alloc+0x49/0x70  
security/security.c:2029
     [<00000000ffa4a0b0>] sk_prot_alloc+0x12d/0x170 net/core/sock.c:1606
     [<00000000b9033c4c>] sk_alloc+0x35/0x2f0 net/core/sock.c:1657
     [<00000000fb9e6269>] nr_make_new net/netrom/af_netrom.c:476 [inline]
     [<00000000fb9e6269>] nr_rx_frame+0x339/0x8ee net/netrom/af_netrom.c:959
     [<00000000fca3a307>] nr_loopback_timer+0x4e/0xd0  
net/netrom/nr_loopback.c:59
     [<0000000009d4e723>] call_timer_fn+0x45/0x1e0 kernel/time/timer.c:1322
     [<0000000047ea1d35>] expire_timers kernel/time/timer.c:1366 [inline]
     [<0000000047ea1d35>] __run_timers kernel/time/timer.c:1685 [inline]
     [<0000000047ea1d35>] __run_timers kernel/time/timer.c:1653 [inline]
     [<0000000047ea1d35>] run_timer_softirq+0x256/0x740  
kernel/time/timer.c:1698
     [<00000000e53c6536>] __do_softirq+0x115/0x33f kernel/softirq.c:292
     [<0000000024be59bc>] invoke_softirq kernel/softirq.c:373 [inline]
     [<0000000024be59bc>] irq_exit+0xbb/0xe0 kernel/softirq.c:413
     [<0000000080d19282>] exiting_irq arch/x86/include/asm/apic.h:537  
[inline]
     [<0000000080d19282>] smp_apic_timer_interrupt+0x96/0x190  
arch/x86/kernel/apic/apic.c:1133
     [<000000000e93dbd5>] apic_timer_interrupt+0xf/0x20  
arch/x86/entry/entry_64.S:830
     [<000000002864ce39>] native_safe_halt+0xe/0x10  
arch/x86/include/asm/irqflags.h:60
     [<000000007e3841ad>] arch_cpu_idle+0xa/0x10  
arch/x86/kernel/process.c:571
     [<00000000546bc34f>] default_idle_call+0x1e/0x40 kernel/sched/idle.c:94

BUG: memory leak
unreferenced object 0xffff88810de01800 (size 2048):
   comm "softirq", pid 0, jiffies 4294947090 (age 32.080s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     06 00 07 40 00 00 00 00 00 00 00 00 00 00 00 00  ...@............
   backtrace:
     [<0000000002377dcf>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<0000000002377dcf>] slab_post_alloc_hook mm/slab.h:522 [inline]
     [<0000000002377dcf>] slab_alloc mm/slab.c:3319 [inline]
     [<0000000002377dcf>] __do_kmalloc mm/slab.c:3653 [inline]
     [<0000000002377dcf>] __kmalloc+0x169/0x300 mm/slab.c:3664
     [<00000000af16d1f0>] kmalloc include/linux/slab.h:557 [inline]
     [<00000000af16d1f0>] sk_prot_alloc+0x112/0x170 net/core/sock.c:1603
     [<00000000b9033c4c>] sk_alloc+0x35/0x2f0 net/core/sock.c:1657
     [<00000000fb9e6269>] nr_make_new net/netrom/af_netrom.c:476 [inline]
     [<00000000fb9e6269>] nr_rx_frame+0x339/0x8ee net/netrom/af_netrom.c:959
     [<00000000fca3a307>] nr_loopback_timer+0x4e/0xd0  
net/netrom/nr_loopback.c:59
     [<0000000009d4e723>] call_timer_fn+0x45/0x1e0 kernel/time/timer.c:1322
     [<0000000047ea1d35>] expire_timers kernel/time/timer.c:1366 [inline]
     [<0000000047ea1d35>] __run_timers kernel/time/timer.c:1685 [inline]
     [<0000000047ea1d35>] __run_timers kernel/time/timer.c:1653 [inline]
     [<0000000047ea1d35>] run_timer_softirq+0x256/0x740  
kernel/time/timer.c:1698
     [<00000000e53c6536>] __do_softirq+0x115/0x33f kernel/softirq.c:292
     [<0000000024be59bc>] invoke_softirq kernel/softirq.c:373 [inline]
     [<0000000024be59bc>] irq_exit+0xbb/0xe0 kernel/softirq.c:413
     [<0000000080d19282>] exiting_irq arch/x86/include/asm/apic.h:537  
[inline]
     [<0000000080d19282>] smp_apic_timer_interrupt+0x96/0x190  
arch/x86/kernel/apic/apic.c:1133
     [<000000000e93dbd5>] apic_timer_interrupt+0xf/0x20  
arch/x86/entry/entry_64.S:830
     [<000000002864ce39>] native_safe_halt+0xe/0x10  
arch/x86/include/asm/irqflags.h:60
     [<000000007e3841ad>] arch_cpu_idle+0xa/0x10  
arch/x86/kernel/process.c:571
     [<00000000546bc34f>] default_idle_call+0x1e/0x40 kernel/sched/idle.c:94
     [<00000000e98df687>] cpuidle_idle_call kernel/sched/idle.c:154 [inline]
     [<00000000e98df687>] do_idle+0x1ea/0x2c0 kernel/sched/idle.c:263
     [<000000001e3f823f>] cpu_startup_entry+0x1b/0x20 kernel/sched/idle.c:354

BUG: memory leak
unreferenced object 0xffff88810fa3c9a0 (size 32):
   comm "softirq", pid 0, jiffies 4294947090 (age 32.080s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     03 00 00 00 03 00 00 00 0f 00 00 00 00 00 00 00  ................
   backtrace:
     [<00000000e9077829>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<00000000e9077829>] slab_post_alloc_hook mm/slab.h:522 [inline]
     [<00000000e9077829>] slab_alloc mm/slab.c:3319 [inline]
     [<00000000e9077829>] kmem_cache_alloc_trace+0x145/0x2c0 mm/slab.c:3548
     [<0000000037f78c54>] kmalloc include/linux/slab.h:552 [inline]
     [<0000000037f78c54>] kzalloc include/linux/slab.h:748 [inline]
     [<0000000037f78c54>] selinux_sk_alloc_security+0x48/0xb0  
security/selinux/hooks.c:5073
     [<00000000313a65ff>] security_sk_alloc+0x49/0x70  
security/security.c:2029
     [<00000000ffa4a0b0>] sk_prot_alloc+0x12d/0x170 net/core/sock.c:1606
     [<00000000b9033c4c>] sk_alloc+0x35/0x2f0 net/core/sock.c:1657
     [<00000000fb9e6269>] nr_make_new net/netrom/af_netrom.c:476 [inline]
     [<00000000fb9e6269>] nr_rx_frame+0x339/0x8ee net/netrom/af_netrom.c:959
     [<00000000fca3a307>] nr_loopback_timer+0x4e/0xd0  
net/netrom/nr_loopback.c:59
     [<0000000009d4e723>] call_timer_fn+0x45/0x1e0 kernel/time/timer.c:1322
     [<0000000047ea1d35>] expire_timers kernel/time/timer.c:1366 [inline]
     [<0000000047ea1d35>] __run_timers kernel/time/timer.c:1685 [inline]
     [<0000000047ea1d35>] __run_timers kernel/time/timer.c:1653 [inline]
     [<0000000047ea1d35>] run_timer_softirq+0x256/0x740  
kernel/time/timer.c:1698
     [<00000000e53c6536>] __do_softirq+0x115/0x33f kernel/softirq.c:292
     [<0000000024be59bc>] invoke_softirq kernel/softirq.c:373 [inline]
     [<0000000024be59bc>] irq_exit+0xbb/0xe0 kernel/softirq.c:413
     [<0000000080d19282>] exiting_irq arch/x86/include/asm/apic.h:537  
[inline]
     [<0000000080d19282>] smp_apic_timer_interrupt+0x96/0x190  
arch/x86/kernel/apic/apic.c:1133
     [<000000000e93dbd5>] apic_timer_interrupt+0xf/0x20  
arch/x86/entry/entry_64.S:830
     [<000000002864ce39>] native_safe_halt+0xe/0x10  
arch/x86/include/asm/irqflags.h:60
     [<000000007e3841ad>] arch_cpu_idle+0xa/0x10  
arch/x86/kernel/process.c:571
     [<00000000546bc34f>] default_idle_call+0x1e/0x40 kernel/sched/idle.c:94

BUG: memory leak
unreferenced object 0xffff88810de01800 (size 2048):
   comm "softirq", pid 0, jiffies 4294947090 (age 32.150s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     06 00 07 40 00 00 00 00 00 00 00 00 00 00 00 00  ...@............
   backtrace:
     [<0000000002377dcf>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<0000000002377dcf>] slab_post_alloc_hook mm/slab.h:522 [inline]
     [<0000000002377dcf>] slab_alloc mm/slab.c:3319 [inline]
     [<0000000002377dcf>] __do_kmalloc mm/slab.c:3653 [inline]
     [<0000000002377dcf>] __kmalloc+0x169/0x300 mm/slab.c:3664
     [<00000000af16d1f0>] kmalloc include/linux/slab.h:557 [inline]
     [<00000000af16d1f0>] sk_prot_alloc+0x112/0x170 net/core/sock.c:1603
     [<00000000b9033c4c>] sk_alloc+0x35/0x2f0 net/core/sock.c:1657
     [<00000000fb9e6269>] nr_make_new net/netrom/af_netrom.c:476 [inline]
     [<00000000fb9e6269>] nr_rx_frame+0x339/0x8ee net/netrom/af_netrom.c:959
     [<00000000fca3a307>] nr_loopback_timer+0x4e/0xd0  
net/netrom/nr_loopback.c:59
     [<0000000009d4e723>] call_timer_fn+0x45/0x1e0 kernel/time/timer.c:1322
     [<0000000047ea1d35>] expire_timers kernel/time/timer.c:1366 [inline]
     [<0000000047ea1d35>] __run_timers kernel/time/timer.c:1685 [inline]
     [<0000000047ea1d35>] __run_timers kernel/time/timer.c:1653 [inline]
     [<0000000047ea1d35>] run_timer_softirq+0x256/0x740  
kernel/time/timer.c:1698
     [<00000000e53c6536>] __do_softirq+0x115/0x33f kernel/softirq.c:292
     [<0000000024be59bc>] invoke_softirq kernel/softirq.c:373 [inline]
     [<0000000024be59bc>] irq_exit+0xbb/0xe0 kernel/softirq.c:413
     [<0000000080d19282>] exiting_irq arch/x86/include/asm/apic.h:537  
[inline]
     [<0000000080d19282>] smp_apic_timer_interrupt+0x96/0x190  
arch/x86/kernel/apic/apic.c:1133
     [<000000000e93dbd5>] apic_timer_interrupt+0xf/0x20  
arch/x86/entry/entry_64.S:830
     [<000000002864ce39>] native_safe_halt+0xe/0x10  
arch/x86/include/asm/irqflags.h:60
     [<000000007e3841ad>] arch_cpu_idle+0xa/0x10  
arch/x86/kernel/process.c:571
     [<00000000546bc34f>] default_idle_call+0x1e/0x40 kernel/sched/idle.c:94
     [<00000000e98df687>] cpuidle_idle_call kernel/sched/idle.c:154 [inline]
     [<00000000e98df687>] do_idle+0x1ea/0x2c0 kernel/sched/idle.c:263
     [<000000001e3f823f>] cpu_startup_entry+0x1b/0x20 kernel/sched/idle.c:354

BUG: memory leak
unreferenced object 0xffff88810fa3c9a0 (size 32):
   comm "softirq", pid 0, jiffies 4294947090 (age 32.150s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     03 00 00 00 03 00 00 00 0f 00 00 00 00 00 00 00  ................
   backtrace:
     [<00000000e9077829>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<00000000e9077829>] slab_post_alloc_hook mm/slab.h:522 [inline]
     [<00000000e9077829>] slab_alloc mm/slab.c:3319 [inline]
     [<00000000e9077829>] kmem_cache_alloc_trace+0x145/0x2c0 mm/slab.c:3548
     [<0000000037f78c54>] kmalloc include/linux/slab.h:552 [inline]
     [<0000000037f78c54>] kzalloc include/linux/slab.h:748 [inline]
     [<0000000037f78c54>] selinux_sk_alloc_security+0x48/0xb0  
security/selinux/hooks.c:5073
     [<00000000313a65ff>] security_sk_alloc+0x49/0x70  
security/security.c:2029
     [<00000000ffa4a0b0>] sk_prot_alloc+0x12d/0x170 net/core/sock.c:1606
     [<00000000b9033c4c>] sk_alloc+0x35/0x2f0 net/core/sock.c:1657
     [<00000000fb9e6269>] nr_make_new net/netrom/af_netrom.c:476 [inline]
     [<00000000fb9e6269>] nr_rx_frame+0x339/0x8ee net/netrom/af_netrom.c:959
     [<00000000fca3a307>] nr_loopback_timer+0x4e/0xd0  
net/netrom/nr_loopback.c:59
     [<0000000009d4e723>] call_timer_fn+0x45/0x1e0 kernel/time/timer.c:1322
     [<0000000047ea1d35>] expire_timers kernel/time/timer.c:1366 [inline]
     [<0000000047ea1d35>] __run_timers kernel/time/timer.c:1685 [inline]
     [<0000000047ea1d35>] __run_timers kernel/time/timer.c:1653 [inline]
     [<0000000047ea1d35>] run_timer_softirq+0x256/0x740  
kernel/time/timer.c:1698
     [<00000000e53c6536>] __do_softirq+0x115/0x33f kernel/softirq.c:292
     [<0000000024be59bc>] invoke_softirq kernel/softirq.c:373 [inline]
     [<0000000024be59bc>] irq_exit+0xbb/0xe0 kernel/softirq.c:413
     [<0000000080d19282>] exiting_irq arch/x86/include/asm/apic.h:537  
[inline]
     [<0000000080d19282>] smp_apic_timer_interrupt+0x96/0x190  
arch/x86/kernel/apic/apic.c:1133
     [<000000000e93dbd5>] apic_timer_interrupt+0xf/0x20  
arch/x86/entry/entry_64.S:830
     [<000000002864ce39>] native_safe_halt+0xe/0x10  
arch/x86/include/asm/irqflags.h:60
     [<000000007e3841ad>] arch_cpu_idle+0xa/0x10  
arch/x86/kernel/process.c:571
     [<00000000546bc34f>] default_idle_call+0x1e/0x40 kernel/sched/idle.c:94

executing program
executing program
executing program

