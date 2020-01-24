Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14CF1148EF4
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 20:57:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392353AbgAXT5L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 14:57:11 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:53361 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389023AbgAXT5L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 14:57:11 -0500
Received: by mail-il1-f200.google.com with SMTP id d3so2351617ilg.20
        for <netdev@vger.kernel.org>; Fri, 24 Jan 2020 11:57:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=hRlNBP7jXaxKThGmu6kTzQTXulJoKE1PBf05vPGZ+m8=;
        b=H01DHS7kpcHRL4zGPbFH5oDKTuYn0REPECrtA5FhQ31aVAkQKxBso+KpQTOwHtX73r
         Uv9MtS01y0eh+R3odOtoRmLWKgojXKas73xFI44TzoEHFbkU/+GPIudUIzlAe14Smle1
         FulhRA9HUvVLTFxAJpngToFhEezNm1Uf5JYIeMZNU8+zob6FDwHEm/Kx0ufrwoT+fU+3
         Zd5fRYNZKY0PsjDw6R332Yvptk0n5wZIhzFyJhsKuw3xZ3ENtVJCSMjYrkECKn/iMpzY
         Kzsetu7maqZD2k7D+5CyeS+Bf+FwYTgFSqrW4fcyU3QBl/ECki9qjkuv256LRYxGvXty
         3CWA==
X-Gm-Message-State: APjAAAW1CP9PUn54rxPEfeszbJxYgA8pyI8RRS/h1EAE6BoQUqu/wM2b
        YY0zjRMEbsOWq823TyLa3F33hLOMigW/nlHxxF/7yPGQ0r2Y
X-Google-Smtp-Source: APXvYqxnB9IwbeEOXDCmxIw+f0gZmRlEI4+jEupCgyq5rmtFCCfLR1NPxZkwL5degpD1KV5IRoiErEL9AKxqEC5eodDTKryCToQ2
MIME-Version: 1.0
X-Received: by 2002:a6b:b74a:: with SMTP id h71mr3429087iof.212.1579895830669;
 Fri, 24 Jan 2020 11:57:10 -0800 (PST)
Date:   Fri, 24 Jan 2020 11:57:10 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c4eeaf059ce82991@google.com>
Subject: INFO: rcu detected stall in ip_set_uadd
From:   syzbot <syzbot+4b0e9d4ff3cf117837e5@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        info@metux.net, jeremy@azazel.net, kadlec@blackhole.kfki.hu,
        kadlec@netfilter.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    4703d911 Merge tag 'xarray-5.5' of git://git.infradead.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=124c1b69e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cf8e288883e40aba
dashboard link: https://syzkaller.appspot.com/bug?extid=4b0e9d4ff3cf117837e5
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
userspace arch: i386
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16a8bb69e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1010c611e00000

The bug was bisected to:

commit 23c42a403a9cfdbad6004a556c927be7dd61a8ee
Author: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Date:   Sat Oct 27 13:07:40 2018 +0000

    netfilter: ipset: Introduction of new commands and protocol version 7

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10050376e00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=12050376e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=14050376e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+4b0e9d4ff3cf117837e5@syzkaller.appspotmail.com
Fixes: 23c42a403a9c ("netfilter: ipset: Introduction of new commands and protocol version 7")

rcu: INFO: rcu_preempt self-detected stall on CPU
rcu: 	0-...!: (10510 ticks this GP) idle=6ca/1/0x4000000000000002 softirq=16152/16155 fqs=7 
	(t=10500 jiffies g=8933 q=807)
rcu: rcu_preempt kthread starved for 10485 jiffies! g8933 f0x0 RCU_GP_WAIT_FQS(5) ->state=0x402 ->cpu=1
rcu: RCU grace-period kthread stack dump:
rcu_preempt     I29264    10      2 0x80004000
Call Trace:
 context_switch kernel/sched/core.c:3385 [inline]
 __schedule+0x934/0x1f90 kernel/sched/core.c:4081
 schedule+0xdc/0x2b0 kernel/sched/core.c:4155
 schedule_timeout+0x486/0xc50 kernel/time/timer.c:1895
 rcu_gp_fqs_loop kernel/rcu/tree.c:1661 [inline]
 rcu_gp_kthread+0x9b2/0x18d0 kernel/rcu/tree.c:1821
 kthread+0x361/0x430 kernel/kthread.c:255
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
NMI backtrace for cpu 0
CPU: 0 PID: 9819 Comm: syz-executor189 Not tainted 5.5.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x197/0x210 lib/dump_stack.c:118
 nmi_cpu_backtrace.cold+0x70/0xb2 lib/nmi_backtrace.c:101
 nmi_trigger_cpumask_backtrace+0x23b/0x28b lib/nmi_backtrace.c:62
 arch_trigger_cpumask_backtrace+0x14/0x20 arch/x86/kernel/apic/hw_nmi.c:38
 trigger_single_cpu_backtrace include/linux/nmi.h:164 [inline]
 rcu_dump_cpu_stacks+0x183/0x1cf kernel/rcu/tree_stall.h:254
 print_cpu_stall kernel/rcu/tree_stall.h:455 [inline]
 check_cpu_stall kernel/rcu/tree_stall.h:529 [inline]
 rcu_pending kernel/rcu/tree.c:2827 [inline]
 rcu_sched_clock_irq.cold+0x509/0xc0d kernel/rcu/tree.c:2271
 update_process_times+0x2d/0x70 kernel/time/timer.c:1726
 tick_sched_handle+0xa2/0x190 kernel/time/tick-sched.c:171
 tick_sched_timer+0x53/0x140 kernel/time/tick-sched.c:1314
 __run_hrtimer kernel/time/hrtimer.c:1517 [inline]
 __hrtimer_run_queues+0x364/0xe40 kernel/time/hrtimer.c:1579
 hrtimer_interrupt+0x314/0x770 kernel/time/hrtimer.c:1641
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1110 [inline]
 smp_apic_timer_interrupt+0x160/0x610 arch/x86/kernel/apic/apic.c:1135
 apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:829
 </IRQ>
RIP: 0010:__sanitizer_cov_trace_pc+0x1a/0x50 kernel/kcov.c:183
Code: c3 0f 1f 44 00 00 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 65 48 8b 04 25 c0 1e 02 00 65 8b 15 14 27 8d 7e 81 e2 00 01 1f 00 <48> 8b 75 08 75 2b 8b 90 80 13 00 00 83 fa 02 75 20 48 8b 88 88 13
RSP: 0018:ffffc90002146e08 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
RAX: ffff8880a8a0e380 RBX: 0000000000000002 RCX: ffffffff8676837f
RDX: 0000000000000000 RSI: 0000000000000002 RDI: 0000000000000004
RBP: ffffc90002146e08 R08: ffff8880a8a0e380 R09: ffffed10152ec273
R10: ffffed10152ec272 R11: ffff8880a9761397 R12: ffff8880a97613c0
R13: ffff8880a513e500 R14: 0000000000000003 R15: dffffc0000000000
 hash_ip4_expire.isra.0+0x2c1/0x8d0 net/netfilter/ipset/ip_set_hash_gen.h:476
 hash_ip4_add+0x178/0x1b6c net/netfilter/ipset/ip_set_hash_gen.h:709
 hash_ip4_uadt+0x546/0x7a0 net/netfilter/ipset/ip_set_hash_ip.c:151
 call_ad+0x1a0/0x5a0 net/netfilter/ipset/ip_set_core.c:1716
 ip_set_ad.isra.0+0x572/0xb20 net/netfilter/ipset/ip_set_core.c:1804
 ip_set_uadd+0x37/0x50 net/netfilter/ipset/ip_set_core.c:1829
 nfnetlink_rcv_msg+0xcf2/0xfb0 net/netfilter/nfnetlink.c:229
 netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
 nfnetlink_rcv+0x1ba/0x460 net/netfilter/nfnetlink.c:563
 netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
 netlink_unicast+0x58c/0x7d0 net/netlink/af_netlink.c:1328
 netlink_sendmsg+0x91c/0xea0 net/netlink/af_netlink.c:1917
 sock_sendmsg_nosec net/socket.c:639 [inline]
 sock_sendmsg+0xd7/0x130 net/socket.c:659
 ____sys_sendmsg+0x753/0x880 net/socket.c:2330
 ___sys_sendmsg+0x100/0x170 net/socket.c:2384
 __sys_sendmsg+0x105/0x1d0 net/socket.c:2417
 __compat_sys_sendmsg net/compat.c:642 [inline]
 __do_compat_sys_sendmsg net/compat.c:649 [inline]
 __se_compat_sys_sendmsg net/compat.c:646 [inline]
 __ia32_compat_sys_sendmsg+0x7a/0xb0 net/compat.c:646
 do_syscall_32_irqs_on arch/x86/entry/common.c:337 [inline]
 do_fast_syscall_32+0x27b/0xe16 arch/x86/entry/common.c:408
 entry_SYSENTER_compat+0x70/0x7f arch/x86/entry/entry_64_compat.S:139
RIP: 0023:0xf7f5e9a9
Code: 00 00 00 89 d3 5b 5e 5f 5d c3 b8 80 96 98 00 eb c4 8b 04 24 c3 8b 1c 24 c3 8b 34 24 c3 8b 3c 24 c3 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 eb 0d 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 002b:00000000ffcfea5c EFLAGS: 00000202 ORIG_RAX: 0000000000000172
RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 0000000020000d00
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 00000000ffcfeb74
RBP: 00000000ffcfeb7c R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
