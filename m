Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A159D220460
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 07:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728485AbgGOF3R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 01:29:17 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:34702 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728390AbgGOF3Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 01:29:16 -0400
Received: by mail-io1-f72.google.com with SMTP id b133so721188iof.1
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 22:29:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=hV6gDoNEujJXR09Xve4tPCYU9mNFTuJaaSa8jwnMPP0=;
        b=Hx5Ju2ExBkEqVGSNONr4ScPXPPsNnBavFEkUuxjLDLxnbYrLeh/7secS6/nR/xwqOV
         KA9037Thj5J35nLmYxes9ONYP+dNaJYLIGgbQyPdoY0FcwbbfBZ7UW+zNYaSCEpffcmk
         EJfmgQlEs6FdjYL+7uzi7PI9DiPz3hA89irJlismlhzQYTHXek8ihw16yaKxT1paIncc
         osMi0jecpx1DGhPIXUbTGyFgGY0JQbsn0c/USdtUSKAC7jROI4jfRF2/KqFTMLrfbT+t
         xpIrX9Xe6yWPtQ3D6W8GtxrRD16tsIu7DEcCpohIbT2gIT5GuXRUAUbkxHh2BjqoNGx6
         GLEA==
X-Gm-Message-State: AOAM532hHqLNFZrOP9ZJhkFL4ainuE/X4tiFxFTkTzukH5ScBrON8DAY
        VKBOZ2/4a3DPUCCl7ld+GwcNgNv/rxWMQGTouXh50FYrAmk+
X-Google-Smtp-Source: ABdhPJyTwqmwwekbwNS1ArF4gR9aG13eAzwOXh/BLbfLQMb1otJ/DIiHulDT7EDtpVqpYAxo8Zpq2cQ9vOf5cYOuSHGjUAHzE9gs
MIME-Version: 1.0
X-Received: by 2002:a02:30c4:: with SMTP id q187mr9630643jaq.102.1594790955573;
 Tue, 14 Jul 2020 22:29:15 -0700 (PDT)
Date:   Tue, 14 Jul 2020 22:29:15 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000065e73d05aa743471@google.com>
Subject: INFO: rcu detected stall in __do_sys_clock_adjtime
From:   syzbot <syzbot+587a843fe6b38420a209@syzkaller.appspotmail.com>
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

syzbot found the following issue on:

HEAD commit:    a581387e Merge tag 'io_uring-5.8-2020-07-10' of git://git...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1312c277100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=66ad203c2bb6d8b
dashboard link: https://syzkaller.appspot.com/bug?extid=587a843fe6b38420a209
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14778a77100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15150e13100000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+587a843fe6b38420a209@syzkaller.appspotmail.com

rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
rcu: 	0-...0: (1 GPs behind) idle=c22/1/0x4000000000000000 softirq=10714/10715 fqs=5249 
	(detected by 1, t=10502 jiffies, g=10189, q=4119)
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 PID: 6820 Comm: syz-executor767 Not tainted 5.8.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:should_restart_cycle net/sched/sch_taprio.c:647 [inline]
RIP: 0010:advance_sched+0x236/0x990 net/sched/sch_taprio.c:723
Code: 00 0f 85 d1 06 00 00 48 8d 7d 28 4d 8b 65 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 cf 06 00 00 <4c> 39 64 24 20 4c 8b 7d 28 0f 84 3c 03 00 00 e8 26 aa 11 fb 4c 89
RSP: 0018:ffffc90000007d78 EFLAGS: 00000046
RAX: dffffc0000000000 RBX: ffff8880a0d9db40 RCX: ffffffff86620d01
RDX: 1ffff11013ee0ae5 RSI: ffffffff86620d0f RDI: ffff88809f705728
RBP: ffff88809f705700 R08: 0000000000000001 R09: 0000000000000003
R10: 17432cbe2e86597c R11: 0000000000000000 R12: ffff88809f705710
R13: ffff888094684700 R14: 17432cbe2e86597c R15: dffffc0000000000
FS:  0000000001fb4880(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000610 CR3: 000000009e890000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
 __run_hrtimer kernel/time/hrtimer.c:1520 [inline]
 __hrtimer_run_queues+0x6a9/0xfc0 kernel/time/hrtimer.c:1584
 hrtimer_interrupt+0x32a/0x930 kernel/time/hrtimer.c:1646
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1080 [inline]
 __sysvec_apic_timer_interrupt+0x142/0x5e0 arch/x86/kernel/apic/apic.c:1097
 asm_call_on_stack+0xf/0x20 arch/x86/entry/entry_64.S:711
 </IRQ>
 __run_on_irqstack arch/x86/include/asm/irq_stack.h:22 [inline]
 run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:48 [inline]
 sysvec_apic_timer_interrupt+0xe0/0x120 arch/x86/kernel/apic/apic.c:1091
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:587
RIP: 0010:arch_local_irq_restore arch/x86/include/asm/paravirt.h:765 [inline]
RIP: 0010:on_each_cpu+0x149/0x240 kernel/smp.c:702
Code: 00 fc ff df 48 c1 e8 03 80 3c 10 00 0f 85 e6 00 00 00 48 83 3d 97 12 4c 08 00 0f 84 af 00 00 00 e8 9c e9 0a 00 48 89 df 57 9d <0f> 1f 44 00 00 e8 8d e9 0a 00 bf 01 00 00 00 e8 83 a4 e6 ff 31 ff
RSP: 0018:ffffc900017f7b68 EFLAGS: 00000293
RAX: 0000000000000000 RBX: 0000000000000293 RCX: 0000000000000000
RDX: ffff88809e192500 RSI: ffffffff8168cdf4 RDI: 0000000000000293
RBP: 0000000000000200 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000000
R13: 001e89e9b1852336 R14: 003b9aca00000000 R15: 0000000000000000
 clock_was_set+0x18/0x20 kernel/time/hrtimer.c:872
 timekeeping_inject_offset+0x3e9/0x4d0 kernel/time/timekeeping.c:1305
 do_adjtimex+0x28f/0x990 kernel/time/timekeeping.c:2332
 do_clock_adjtime kernel/time/posix-timers.c:1109 [inline]
 __do_sys_clock_adjtime+0x155/0x250 kernel/time/posix-timers.c:1121
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:384
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x443949
Code: Bad RIP value.
RSP: 002b:00007ffef6e7f668 EFLAGS: 00000246 ORIG_RAX: 0000000000000131
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000443949
RDX: 0000000000443949 RSI: 0000000020000300 RDI: 0000000000000000
RBP: 00007ffef6e7f670 R08: 0000000001bbbbbb R09: 0000000001bbbbbb
R10: 0000000001bbbbbb R11: 0000000000000246 R12: 00007ffef6e7f680
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
INFO: NMI handler (nmi_cpu_backtrace_handler) took too long to run: 0.000 msecs


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
