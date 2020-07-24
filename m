Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 315C322BDA8
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 07:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbgGXFoQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 01:44:16 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:43191 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726543AbgGXFoQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 01:44:16 -0400
Received: by mail-il1-f197.google.com with SMTP id y13so5030547ila.10
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 22:44:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=OMRIqu8obzB7sqBNMSf9FQ4q4I4IeW7Bg8oejJNF6U0=;
        b=EtLUowdYINxwMgYc7hRfvRRxktFSUyZEJ4Ws3Ty1cZJHg9LDk0SBSMxt2L2GYzDcj2
         P53g05np+BhyO0szJvnBGmNFPC4nBPrQfS4AQjKQJ5NnkmcHQdghr9uM9J3FBUqL2ybC
         S1ZvPmwRYQBpOexUR4XVdIlQTy6XGUIcSi9iw5ItfT7PfDSO61V10zr7HHB6dmV3YpFB
         JHZYwUeUuGtBtxmdqjfgqKsn/aTwbgh8AwilFrkLdxZjZKmW4B8WY1jRra1bxJxPYqb6
         8P7eqZjGz6XZx7sAKgF4tp7Ei7YmhI9uqsyqBXjJiqSx9JrKZEhDDe1UEGplEluw6eaI
         LCag==
X-Gm-Message-State: AOAM532G1RV216po9YH3d5HBm5kqF0xcUJIPfZ+SpzOpFm49CgJV6o7T
        M5KfiaPUU6R7Lf58V3NAOlaeAG7U5NOexkX6cD6FcWxLvFTv
X-Google-Smtp-Source: ABdhPJz+cEqTGRpwSTZo9WNIglVqLWwOEuLvSiDPE+iKmJWXKYSfuDsc4pBL0flCRkMB3teDVKLvV6dIV7FLzDJdqlvUlkIIrxWx
MIME-Version: 1.0
X-Received: by 2002:a92:d602:: with SMTP id w2mr4817149ilm.247.1595569454951;
 Thu, 23 Jul 2020 22:44:14 -0700 (PDT)
Date:   Thu, 23 Jul 2020 22:44:14 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000093b26605ab2976f0@google.com>
Subject: INFO: rcu detected stall in rtnl_newlink
From:   syzbot <syzbot+d46d08c4209a3a86ccc5@syzkaller.appspotmail.com>
To:     fweisbec@gmail.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    e6827d1a cxgb4: add missing release on skb in uld_send()
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=17a227b4900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=dddbcb5a9f4192db
dashboard link: https://syzkaller.appspot.com/bug?extid=d46d08c4209a3a86ccc5
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15a38228900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1302e4c4900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d46d08c4209a3a86ccc5@syzkaller.appspotmail.com

rcu: INFO: rcu_preempt self-detected stall on CPU
rcu: 	1-....: (10491 ticks this GP) idle=5d2/1/0x4000000000000000 softirq=10100/10100 fqs=5226 
	(t=10500 jiffies g=8229 q=552)
NMI backtrace for cpu 1
CPU: 1 PID: 6812 Comm: syz-executor138 Not tainted 5.8.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 nmi_cpu_backtrace.cold+0x70/0xb1 lib/nmi_backtrace.c:101
 nmi_trigger_cpumask_backtrace+0x1b3/0x223 lib/nmi_backtrace.c:62
 trigger_single_cpu_backtrace include/linux/nmi.h:164 [inline]
 rcu_dump_cpu_stacks+0x194/0x1cf kernel/rcu/tree_stall.h:320
 print_cpu_stall kernel/rcu/tree_stall.h:553 [inline]
 check_cpu_stall kernel/rcu/tree_stall.h:627 [inline]
 rcu_pending kernel/rcu/tree.c:3489 [inline]
 rcu_sched_clock_irq.cold+0x5b3/0xccc kernel/rcu/tree.c:2504
 update_process_times+0x25/0x60 kernel/time/timer.c:1726
 tick_sched_handle+0x9b/0x180 kernel/time/tick-sched.c:176
 tick_sched_timer+0x108/0x290 kernel/time/tick-sched.c:1320
 __run_hrtimer kernel/time/hrtimer.c:1520 [inline]
 __hrtimer_run_queues+0x1d5/0xfc0 kernel/time/hrtimer.c:1584
 hrtimer_interrupt+0x32a/0x930 kernel/time/hrtimer.c:1646
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1080 [inline]
 __sysvec_apic_timer_interrupt+0x142/0x5e0 arch/x86/kernel/apic/apic.c:1097
 asm_call_on_stack+0xf/0x20 arch/x86/entry/entry_64.S:711
 </IRQ>
 __run_on_irqstack arch/x86/include/asm/irq_stack.h:22 [inline]
 run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:48 [inline]
 sysvec_apic_timer_interrupt+0xe0/0x120 arch/x86/kernel/apic/apic.c:1091
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:587
RIP: 0010:should_resched arch/x86/include/asm/preempt.h:102 [inline]
RIP: 0010:__local_bh_enable_ip+0x189/0x250 kernel/softirq.c:196
Code: 89 48 ba 00 00 00 00 00 fc ff df 48 c1 e8 03 80 3c 10 00 0f 85 c4 00 00 00 48 83 3d 60 5a 6e 08 00 74 7b fb 66 0f 1f 44 00 00 <65> 8b 05 80 78 bb 7e 85 c0 74 6b 5b 5d 41 5c c3 80 3d a3 6a 63 09
RSP: 0018:ffffc90001816d80 EFLAGS: 00000286
RAX: 1ffffffff1369c12 RBX: 0000000000000201 RCX: 0000000000000002
RDX: dffffc0000000000 RSI: 0000000000000000 RDI: ffffffff81468609
RBP: ffffffff87cdbce5 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: ffff8880a9298400
R13: 0000000000000001 R14: 0000000000000034 R15: dffffc0000000000
 spin_unlock_bh include/linux/spinlock.h:398 [inline]
 batadv_tt_local_purge+0x285/0x370 net/batman-adv/translation-table.c:1446
 batadv_tt_local_resize_to_mtu+0x8e/0x130 net/batman-adv/translation-table.c:4197
 batadv_hardif_activate_interface.part.0.cold+0x14c/0x1ba net/batman-adv/hard-interface.c:653
 batadv_hardif_activate_interface net/batman-adv/hard-interface.c:800 [inline]
 batadv_hardif_enable_interface+0xa7d/0xb10 net/batman-adv/hard-interface.c:792
 batadv_softif_slave_add+0x92/0x150 net/batman-adv/soft-interface.c:892
 do_set_master+0x1c8/0x220 net/core/rtnetlink.c:2476
 do_setlink+0x903/0x35c0 net/core/rtnetlink.c:2611
 __rtnl_newlink+0xc21/0x1750 net/core/rtnetlink.c:3272
 rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3398
 rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5461
 netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2469
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2352
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2406
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2439
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:384
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x4437d9
Code: Bad RIP value.
RSP: 002b:00007ffdfad85898 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00000000004437d9
RDX: 0000000000000000 RSI: 0000000020000140 RDI: 0000000000000004
RBP: 00007ffdfad858a0 R08: 0000000001bbbbbb R09: 0000000001bbbbbb
R10: 0000000001bbbbbb R11: 0000000000000246 R12: 00007ffdfad858b0
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
