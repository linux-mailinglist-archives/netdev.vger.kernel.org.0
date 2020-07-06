Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AE0A215B07
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 17:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729650AbgGFPmn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 11:42:43 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:38661 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729525AbgGFPmZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 11:42:25 -0400
Received: by mail-il1-f197.google.com with SMTP id c12so25409198ilf.5
        for <netdev@vger.kernel.org>; Mon, 06 Jul 2020 08:42:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=DY+QZek1Wbu3XeWKS2p3CLC4ByQyovd34PXDobirkfE=;
        b=JcB+8RCYNRxZEBF7eE0eJQVUXH/9ZFh77swZrSfpGYByRVSUvo4Z1/8XxkyEq2szyK
         T29KbpU6tD7jd35j4cXG2lGlxShYZpadJAsFaIvRwsCLEcrxYgdhynBCd54lKbDSKscG
         iJxr2KnXRRao9bzP79qsur8M1r5JUhK5rhdzTx5kaG5USISdZAXEjCzrCth75qRSZRds
         kEUxsXKVHR1P669WC6kaMc46MNjOOEVTA93ulJ2bGll1vMjTUC9qvH4XPhopn8GZl72h
         uY0Fi2rrY15hxd9MphdO5G0Fh5jjQBWLLKDxG/jR3Jzs5aqus5yRYpG8Z1fhwXdm2wbI
         m/oA==
X-Gm-Message-State: AOAM533PZjw7rbqjDzA8mAXjwD54utj0Kpm6fzrhE/NJXy0xxdNWT9Fz
        0ArrFfp3BikLWkmVm/TQGki+MGY53xTPD++pxRtxyIcdbztU
X-Google-Smtp-Source: ABdhPJzT6Hr6mNFVK0y20scXTICwcpAfAZZPTcTrLhBECpSZm3zsw3/7VTMozGtha2p+aJZOO5cG76IVoE0+FgKI0pbkwJ2ubMeb
MIME-Version: 1.0
X-Received: by 2002:a05:6602:58a:: with SMTP id v10mr25963484iox.203.1594050144123;
 Mon, 06 Jul 2020 08:42:24 -0700 (PDT)
Date:   Mon, 06 Jul 2020 08:42:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000983e0405a9c7b870@google.com>
Subject: INFO: rcu detected stall in __sys_sendmsg
From:   syzbot <syzbot+f517075b510306f61903@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    7cc2a8ea Merge tag 'block-5.8-2020-07-01' of git://git.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12c4e36d100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=183dd243398ba7ec
dashboard link: https://syzkaller.appspot.com/bug?extid=f517075b510306f61903
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11f01c1f100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16c40ba7100000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+f517075b510306f61903@syzkaller.appspotmail.com

rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
rcu: 	0-...0: (1 GPs behind) idle=59a/1/0x4000000000000000 softirq=8266/8267 fqs=5250 
	(detected by 1, t=10502 jiffies, g=6117, q=61)
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 PID: 6826 Comm: syz-executor019 Not tainted 5.8.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:preempt_count_add+0xe/0x150 kernel/sched/core.c:3873
Code: 07 80 c1 03 38 c1 0f 8c 40 ff ff ff 48 89 ef e8 48 f2 62 00 e9 33 ff ff ff 0f 1f 00 41 57 41 56 53 89 fb 65 01 3d 4e 75 b1 7e <48> c7 c0 30 7d 5a 8b 48 c1 e8 03 49 bf 00 00 00 00 00 fc ff df 42
RSP: 0018:ffffc90000007cf0 EFLAGS: 00000006
RAX: 1ffff11012ddc459 RBX: 0000000000000001 RCX: ffff8880a8c44300
RDX: 0000000000010202 RSI: 0000000000000000 RDI: 0000000000000001
RBP: ffff888096ee2000 R08: ffffffff8164ef7e R09: fffffbfff12da576
R10: fffffbfff12da576 R11: 0000000000000000 R12: ffff888096ee2340
R13: dffffc0000000000 R14: ffff888096ee22e8 R15: ffff888096ee2340
FS:  0000000000753880(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000610 CR3: 00000000a9a34000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
 __raw_spin_lock include/linux/spinlock_api_smp.h:141 [inline]
 _raw_spin_lock+0xe/0x40 kernel/locking/spinlock.c:151
 spin_lock include/linux/spinlock.h:353 [inline]
 advance_sched+0x47/0x8c0 net/sched/sch_taprio.c:699
 __run_hrtimer kernel/time/hrtimer.c:1520 [inline]
 __hrtimer_run_queues+0x47f/0x930 kernel/time/hrtimer.c:1584
 hrtimer_interrupt+0x373/0xd60 kernel/time/hrtimer.c:1646
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1080 [inline]
 __sysvec_apic_timer_interrupt+0xf0/0x260 arch/x86/kernel/apic/apic.c:1097
 asm_call_on_stack+0xf/0x20 arch/x86/entry/entry_64.S:711
 </IRQ>
 __run_on_irqstack arch/x86/include/asm/irq_stack.h:22 [inline]
 run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:48 [inline]
 sysvec_apic_timer_interrupt+0xb9/0x130 arch/x86/kernel/apic/apic.c:1091
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:596
RIP: 0010:arch_local_irq_restore arch/x86/include/asm/paravirt.h:765 [inline]
RIP: 0010:__raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:160 [inline]
RIP: 0010:_raw_spin_unlock_irqrestore+0xa5/0xd0 kernel/locking/spinlock.c:191
Code: b9 00 00 00 00 00 fc ff df 80 3c 08 00 74 0c 48 c7 c7 f0 c7 2b 89 e8 ea 7c 94 f9 48 83 3d d2 c9 0c 01 00 74 2c 4c 89 f7 57 9d <0f> 1f 44 00 00 bf 01 00 00 00 e8 cc 8b 31 f9 65 8b 05 d1 ff e2 77
RSP: 0018:ffffc90001277408 EFLAGS: 00000282
RAX: 1ffffffff12578fe RBX: ffff888096ee22e8 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: 0000000000000008 RDI: 0000000000000282
RBP: ffffc90001277600 R08: dffffc0000000000 R09: fffffbfff16334b8
R10: fffffbfff16334b8 R11: 0000000000000000 R12: ffff888096ee2340
R13: 0000000000000000 R14: 0000000000000282 R15: 161f1f2ad520785b
 spin_unlock_irqrestore include/linux/spinlock.h:408 [inline]
 taprio_change+0x4245/0x51f0 net/sched/sch_taprio.c:1557
 qdisc_create+0x7d1/0x1410 net/sched/sch_api.c:1246
 tc_modify_qdisc+0x962/0x1d90 net/sched/sch_api.c:1662
 rtnetlink_rcv_msg+0x889/0xd40 net/core/rtnetlink.c:5460
 netlink_rcv_skb+0x190/0x3a0 net/netlink/af_netlink.c:2469
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x786/0x940 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0xa57/0xd70 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg net/socket.c:672 [inline]
 ____sys_sendmsg+0x519/0x800 net/socket.c:2352
 ___sys_sendmsg net/socket.c:2406 [inline]
 __sys_sendmsg+0x2b1/0x360 net/socket.c:2439
 do_syscall_64+0x73/0xe0 arch/x86/entry/common.c:359
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x443799
Code: Bad RIP value.
RSP: 002b:00007ffe68f74b78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000443799
RDX: 0000000000000000 RSI: 00000000200007c0 RDI: 0000000000000004
RBP: 00007ffe68f74b80 R08: 0000000001bbbbbb R09: 0000000001bbbbbb
R10: 0000000001bbbbbb R11: 0000000000000246 R12: 00007ffe68f74b90
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
INFO: NMI handler (nmi_cpu_backtrace_handler) took too long to run: 0.000 msecs


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
