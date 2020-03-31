Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB02F199D25
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 19:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbgCaRnQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 13:43:16 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:45171 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726164AbgCaRnP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 13:43:15 -0400
Received: by mail-io1-f70.google.com with SMTP id h76so19805130iof.12
        for <netdev@vger.kernel.org>; Tue, 31 Mar 2020 10:43:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=bV9QEiuox3oTe+1g5OR3+ILPLH6kOwEiLYWW7f3FLMI=;
        b=ft0Vw34wgMiaBZYXWFvqOoFzgLaIK7BRuJQ5LWQMHE+OREsArarbublvCLmyHnk7xw
         UbKUc315udTNOZYeFUinx8luT3jXe0CRHE0Ax4rN+kfWbUM23Ze2g59FJAfWlSsvirtl
         t+No1qu/oRziiLSNzTZJ6J9SN0gqDFcYMQPoQ+4t+9IYKt2aSIwtCawHCCtQ1pbgVoWl
         5ly2YnuXB8ujz6le6xxvoNVbTB8CXiKCyzU7ZskeGneDhTpSAVi40Zy07Fqe7igXt7X5
         2fRDlW908qjSlcwP3KB0kDPjfVwiBzM9OPMczwn02y7Do+MXBx4vfV/vZTWniBvRHlnc
         uXUg==
X-Gm-Message-State: ANhLgQ3xxKeC0voS99YR0v0KSDlA+fnQR75FxWPOTVxA6BCunwGTxfM+
        4dQ42am5/DbOIPaRtUnLyWJUxYKCvx08InI5n1P6oDHrDTNe
X-Google-Smtp-Source: ADFU+vsDh4M0VhoHLp+T4aBKgf2nZSTUlLTxVgUMQ3NdfAJtCZoyExQ5CxOXvlxseISdPQw3B+V8nZJlIjTZOk+Wx6vsVYXizn6s
MIME-Version: 1.0
X-Received: by 2002:a92:498e:: with SMTP id k14mr15572167ilg.160.1585676592777;
 Tue, 31 Mar 2020 10:43:12 -0700 (PDT)
Date:   Tue, 31 Mar 2020 10:43:12 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000a8e8605a22a1ae0@google.com>
Subject: INFO: rcu detected stall in netlink_sendmsg (4)
From:   syzbot <syzbot+0fb70e87d8e0ac278fe9@syzkaller.appspotmail.com>
To:     a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org,
        davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        mareklindner@neomailbox.ch, netdev@vger.kernel.org,
        sven@narfation.org, sw@simonwunderlich.de,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    ae661dec Merge branch 'ifla_xdp_expected_fd'
git tree:       bpf-next
console output: https://syzkaller.appspot.com/x/log.txt?x=12245647e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b5acf5ac38a50651
dashboard link: https://syzkaller.appspot.com/bug?extid=0fb70e87d8e0ac278fe9
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+0fb70e87d8e0ac278fe9@syzkaller.appspotmail.com

rcu: INFO: rcu_preempt self-detected stall on CPU
rcu: 	0-....: (1 GPs behind) idle=5c2/1/0x4000000000000002 softirq=376075/376076 fqs=5176 
	(t=10500 jiffies g=506061 q=176208)
NMI backtrace for cpu 0
CPU: 0 PID: 17281 Comm: syz-executor.5 Not tainted 5.6.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 nmi_cpu_backtrace.cold+0x70/0xb1 lib/nmi_backtrace.c:101
 nmi_trigger_cpumask_backtrace+0x231/0x27e lib/nmi_backtrace.c:62
 trigger_single_cpu_backtrace include/linux/nmi.h:164 [inline]
 rcu_dump_cpu_stacks+0x169/0x1b3 kernel/rcu/tree_stall.h:254
 print_cpu_stall kernel/rcu/tree_stall.h:475 [inline]
 check_cpu_stall kernel/rcu/tree_stall.h:549 [inline]
 rcu_pending kernel/rcu/tree.c:3030 [inline]
 rcu_sched_clock_irq.cold+0x518/0xc55 kernel/rcu/tree.c:2276
 update_process_times+0x25/0x60 kernel/time/timer.c:1726
 tick_sched_handle+0x9b/0x180 kernel/time/tick-sched.c:171
 tick_sched_timer+0x4e/0x140 kernel/time/tick-sched.c:1314
 __run_hrtimer kernel/time/hrtimer.c:1517 [inline]
 __hrtimer_run_queues+0x32c/0xdd0 kernel/time/hrtimer.c:1579
 hrtimer_interrupt+0x312/0x770 kernel/time/hrtimer.c:1641
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1119 [inline]
 smp_apic_timer_interrupt+0x15b/0x600 arch/x86/kernel/apic/apic.c:1144
 apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:829
 </IRQ>
RIP: 0010:arch_local_irq_restore arch/x86/include/asm/paravirt.h:759 [inline]
RIP: 0010:lock_release+0x45f/0x7c0 kernel/locking/lockdep.c:4505
Code: 94 08 00 00 00 00 00 00 48 c1 e8 03 80 3c 10 00 0f 85 d0 02 00 00 48 83 3d 6d 1d 1b 08 00 0f 84 71 01 00 00 48 8b 3c 24 57 9d <0f> 1f 44 00 00 48 b8 00 00 00 00 00 fc ff df 48 01 c3 48 c7 03 00
RSP: 0018:ffffc90003d9ec30 EFLAGS: 00000282 ORIG_RAX: ffffffffffffff13
RAX: 1ffffffff12e7698 RBX: 1ffff920007b3d89 RCX: 1ffff110098769b9
RDX: dffffc0000000000 RSI: 1ffff110098769c5 RDI: 0000000000000282
RBP: ffff88804c3b4540 R08: 0000000000000004 R09: fffffbfff14cc269
R10: fffffbfff14cc268 R11: ffffffff8a661347 R12: bc95c6993a9665e0
R13: ffffffff87a36fb1 R14: ffff88804c3b4dd0 R15: 0000000000000003
 __raw_spin_unlock_bh include/linux/spinlock_api_smp.h:174 [inline]
 _raw_spin_unlock_bh+0x12/0x30 kernel/locking/spinlock.c:207
 spin_unlock_bh include/linux/spinlock.h:383 [inline]
 batadv_tt_local_purge_pending_clients+0x2a1/0x3b0 net/batman-adv/translation-table.c:3914
 batadv_tt_local_resize_to_mtu+0x96/0x130 net/batman-adv/translation-table.c:4198
 batadv_update_min_mtu net/batman-adv/hard-interface.c:626 [inline]
 batadv_hardif_activate_interface.part.0.cold+0xc6/0x294 net/batman-adv/hard-interface.c:653
 batadv_hardif_activate_interface net/batman-adv/hard-interface.c:800 [inline]
 batadv_hardif_enable_interface+0x9f2/0xaa0 net/batman-adv/hard-interface.c:792
 batadv_softif_slave_add+0x92/0x150 net/batman-adv/soft-interface.c:859
 do_set_master net/core/rtnetlink.c:2470 [inline]
 do_set_master+0x1d7/0x230 net/core/rtnetlink.c:2443
 do_setlink+0xaa2/0x3680 net/core/rtnetlink.c:2605
 __rtnl_newlink+0xad5/0x1590 net/core/rtnetlink.c:3266
 rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3391
 rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5454
 netlink_rcv_skb+0x15a/0x410 net/netlink/af_netlink.c:2478
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x537/0x740 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x882/0xe10 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6b9/0x7d0 net/socket.c:2343
 ___sys_sendmsg+0x100/0x170 net/socket.c:2397
 __sys_sendmsg+0xec/0x1b0 net/socket.c:2430
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x45c849
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f043b72fc78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f043b7306d4 RCX: 000000000045c849
RDX: 0000000000000000 RSI: 00000000200001c0 RDI: 0000000000000003
RBP: 000000000076bf00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 00000000000009f5 R14: 00000000004ccac9 R15: 000000000076bf0c


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
