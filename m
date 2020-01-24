Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19D37148EF6
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 20:57:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392411AbgAXT51 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 14:57:27 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:49910 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391004AbgAXT5L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 14:57:11 -0500
Received: by mail-il1-f199.google.com with SMTP id p67so2352010ill.16
        for <netdev@vger.kernel.org>; Fri, 24 Jan 2020 11:57:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=iR9z4vIJabebYnBx68Ih627P7v8+wtpN81Q+/YbfLE8=;
        b=Su5nCZoQe+P3RMJompZnAKKuFabolwDtjvHddxnX+egD6A7W+TUgZj3pIBFJJ016zN
         6myrGo6s93p19UvI0DXDj0j83u2S/XcCKaawTc1o6/8aO6mTHoPLmUzIBtBZKJAHGhiP
         upZ1WNhdJrL/WooR632RiH2y67+wTJpJ/pzZhIUjr3tsrg9qt/3IppE7S3fX65OTw1Mp
         VlezVMAP0DZIQUTn/pPdDgc8UIBoKugiWypUULNQE2opXw0SJ1NXxFQuqm8bW75ybMeE
         ooUMA5/Un6QGhjqXNPEoS3nq64tMNTcM5H8gnRiAbWKZz/dldsh5dUlhy99iMsVLltQg
         MEZA==
X-Gm-Message-State: APjAAAVztDY6jz8g9tCFFN1jQUPXj6pr+xHYtYiRQ+F3dW//mPGQZ0IJ
        fJpw+/jjT9W0yUhzzstUPuYx03YHDs1GsqCyxJM71J6vekyU
X-Google-Smtp-Source: APXvYqyip0V2OsdbZFxeLo84jDXMxE2KNUFfKym9OQJ94+hL4kn223tfSeeQ/q+vhDxKNDo8psnFuwcOgz4uWyCyXtBUsiyTQ9I7
MIME-Version: 1.0
X-Received: by 2002:a92:901:: with SMTP id y1mr4499492ilg.274.1579895830913;
 Fri, 24 Jan 2020 11:57:10 -0800 (PST)
Date:   Fri, 24 Jan 2020 11:57:10 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c8a983059ce8298c@google.com>
Subject: INFO: rcu detected stall in ip_set_udel
From:   syzbot <syzbot+c27b8d5010f45c666ed1@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        info@metux.net, jeremy@azazel.net, kadlec@netfilter.org,
        kstewart@linuxfoundation.org, linux-kernel@vger.kernel.org,
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
console output: https://syzkaller.appspot.com/x/log.txt?x=10ecd479e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=83c00afca9cf5153
dashboard link: https://syzkaller.appspot.com/bug?extid=c27b8d5010f45c666ed1
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1568f9c9e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17db3611e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+c27b8d5010f45c666ed1@syzkaller.appspotmail.com

rcu: INFO: rcu_preempt self-detected stall on CPU
rcu: 	1-....: (10500 ticks this GP) idle=b52/1/0x4000000000000002 softirq=13996/13996 fqs=5248 
	(t=10502 jiffies g=7337 q=2939)
NMI backtrace for cpu 1
CPU: 1 PID: 8895 Comm: syz-executor098 Not tainted 5.5.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1fb/0x318 lib/dump_stack.c:118
 nmi_cpu_backtrace+0xaa/0x190 lib/nmi_backtrace.c:101
 nmi_trigger_cpumask_backtrace+0x16f/0x290 lib/nmi_backtrace.c:62
 arch_trigger_cpumask_backtrace+0x10/0x20 arch/x86/kernel/apic/hw_nmi.c:38
 trigger_single_cpu_backtrace include/linux/nmi.h:164 [inline]
 rcu_dump_cpu_stacks+0x15a/0x220 kernel/rcu/tree_stall.h:254
 print_cpu_stall kernel/rcu/tree_stall.h:455 [inline]
 check_cpu_stall kernel/rcu/tree_stall.h:529 [inline]
 rcu_pending kernel/rcu/tree.c:2827 [inline]
 rcu_sched_clock_irq+0x1521/0x1ab0 kernel/rcu/tree.c:2271
 update_process_times+0x12d/0x180 kernel/time/timer.c:1726
 tick_sched_handle kernel/time/tick-sched.c:171 [inline]
 tick_sched_timer+0x263/0x420 kernel/time/tick-sched.c:1314
 __run_hrtimer kernel/time/hrtimer.c:1517 [inline]
 __hrtimer_run_queues+0x3f3/0x840 kernel/time/hrtimer.c:1579
 hrtimer_interrupt+0x37c/0xda0 kernel/time/hrtimer.c:1641
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1110 [inline]
 smp_apic_timer_interrupt+0x109/0x280 arch/x86/kernel/apic/apic.c:1135
 apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:829
 </IRQ>
RIP: 0010:arch_local_irq_restore arch/x86/include/asm/paravirt.h:752 [inline]
RIP: 0010:lock_is_held_type+0x25c/0x2b0 kernel/locking/lockdep.c:4523
Code: 28 91 0a 89 48 c1 e8 03 42 80 3c 30 00 74 0c 48 c7 c7 28 91 0a 89 e8 c3 2b 57 00 48 83 3d 63 fe ae 07 00 74 56 4c 89 e7 57 9d <0f> 1f 44 00 00 89 d8 48 83 c4 28 5b 41 5c 41 5d 41 5e 41 5f 5d c3
RSP: 0018:ffffc90002077120 EFLAGS: 00000282 ORIG_RAX: ffffffffffffff13
RAX: 1ffffffff1215225 RBX: 0000000000000001 RCX: 0000000000000000
RDX: 00000000ffffffff RSI: ffff88809fa54638 RDI: 0000000000000282
RBP: ffffc90002077170 R08: ffffffff86a708bc R09: ffffffff83b538c7
R10: ffff8880a861c1c0 R11: 0000000000000004 R12: 0000000000000282
R13: ffff8880a861ca54 R14: dffffc0000000000 R15: 1ffff110150c394a
 lock_is_held include/linux/lockdep.h:361 [inline]
 hash_ip4_del+0xa5/0xb50 net/netfilter/ipset/ip_set_hash_gen.h:847
 hash_ip4_uadt+0x589/0x810 net/netfilter/ipset/ip_set_hash_ip.c:151
 call_ad+0x10a/0x5b0 net/netfilter/ipset/ip_set_core.c:1716
 ip_set_ad+0x6a9/0x860 net/netfilter/ipset/ip_set_core.c:1804
 ip_set_udel+0x3a/0x50 net/netfilter/ipset/ip_set_core.c:1838
 nfnetlink_rcv_msg+0x9ae/0xcd0 net/netfilter/nfnetlink.c:229
 netlink_rcv_skb+0x19e/0x3e0 net/netlink/af_netlink.c:2477
 nfnetlink_rcv+0x1e0/0x1e50 net/netfilter/nfnetlink.c:563
 netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
 netlink_unicast+0x767/0x920 net/netlink/af_netlink.c:1328
 netlink_sendmsg+0xa2c/0xd50 net/netlink/af_netlink.c:1917
 sock_sendmsg_nosec net/socket.c:639 [inline]
 sock_sendmsg net/socket.c:659 [inline]
 ____sys_sendmsg+0x4f7/0x7f0 net/socket.c:2330
 ___sys_sendmsg net/socket.c:2384 [inline]
 __sys_sendmsg+0x1ed/0x290 net/socket.c:2417
 __do_sys_sendmsg net/socket.c:2426 [inline]
 __se_sys_sendmsg net/socket.c:2424 [inline]
 __x64_sys_sendmsg+0x7f/0x90 net/socket.c:2424
 do_syscall_64+0xf7/0x1c0 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x440509
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffd23b04ed8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 0000000000440509
RDX: 0000000000000040 RSI: 0000000020000080 RDI: 0000000000000004
RBP: 00000000006ca018 R08: 0000000000000018 R09: 00000000004002c8
R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000401d90
R13: 0000000000401e20 R14: 0000000000000000 R15: 0000000000000000


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
