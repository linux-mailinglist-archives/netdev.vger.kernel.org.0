Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30408243386
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 07:12:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbgHMFMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Aug 2020 01:12:21 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:45113 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbgHMFMV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Aug 2020 01:12:21 -0400
Received: by mail-il1-f199.google.com with SMTP id 65so3523017ilb.12
        for <netdev@vger.kernel.org>; Wed, 12 Aug 2020 22:12:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=jXaa6f30UjZ+KgTcwoAEIKRrU8me7hO1ssQHO/9rkbY=;
        b=LMcdMH9gezjisnxcd9bmJ2A10HZ6bnw/Rw8LVr7f8/Ia9w83zMBm6mE5h3t7AJIYP8
         s5YsaJwqE8O1iZbaIuJWm6J/aipSfpyttzCX0fUSj8SfqtOfpiVeIZ+XXlSW7Da5YBHe
         CEX+qixJY3EgrWHqXXAlFWKl5R6Le8qExrxQnsjI7JEOLvwkfg9I6T2IYIqEQAZ7PYwC
         26RBIZaCdGlPUT3w/0GLgMMAmxFbJxnyONEL/MipjwpA+2CjGXoGCuqcwlqcS2o3nnGj
         3FsbTtLsCqgRNB/8o/iJ0lQYSwJTXvcJ/YqcjO2G9b1t3x0Dq/gBjaqLI2WGWZLga+pI
         AnHQ==
X-Gm-Message-State: AOAM533+4UKNyI8gNa2PSLFMQLw1Ov8kpykQWeAyOLKTnGMHSgBZUxgP
        Dv3FDxsHagdbLPRiezgmTShbV20dV2zICIBhhRgfVo9shKpA
X-Google-Smtp-Source: ABdhPJy0dXezTISQ9rWm2hLbHY+mB2ToOBqf7JKyY3/kOoYGG3UGHRn7IhU62DNKGaQhBBPqj0ImI/NP9yysx5Ox9WTfhkh5Clm2
MIME-Version: 1.0
X-Received: by 2002:a02:820b:: with SMTP id o11mr3217959jag.136.1597295540129;
 Wed, 12 Aug 2020 22:12:20 -0700 (PDT)
Date:   Wed, 12 Aug 2020 22:12:20 -0700
In-Reply-To: <000000000000c3cfbd05ac744f16@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004553bf05acbb592b@google.com>
Subject: Re: KMSAN: uninit-value in can_receive (2)
From:   syzbot <syzbot+3f3837e61a48d32b495f@syzkaller.appspotmail.com>
To:     davem@davemloft.net, glider@google.com, kuba@kernel.org,
        linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        mkl@pengutronix.de, netdev@vger.kernel.org, socketcan@hartkopp.net,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    ce8056d1 wip: changed copy_from_user where instrumented
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=1041a3be900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3afe005fb99591f
dashboard link: https://syzkaller.appspot.com/bug?extid=3f3837e61a48d32b495f
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=160fbd06900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12a14e6e900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3f3837e61a48d32b495f@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in can_receive+0x26b/0x630 net/can/af_can.c:650
CPU: 1 PID: 8475 Comm: syz-executor984 Not tainted 5.8.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x21c/0x280 lib/dump_stack.c:118
 kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:121
 __msan_warning+0x58/0xa0 mm/kmsan/kmsan_instr.c:215
 can_receive+0x26b/0x630 net/can/af_can.c:650
 can_rcv+0x1fb/0x410 net/can/af_can.c:686
 __netif_receive_skb_one_core net/core/dev.c:5281 [inline]
 __netif_receive_skb+0x265/0x670 net/core/dev.c:5395
 process_backlog+0x50d/0xba0 net/core/dev.c:6239
 napi_poll+0x43b/0xfd0 net/core/dev.c:6684
 net_rx_action+0x35c/0xd40 net/core/dev.c:6752
 __do_softirq+0x2ea/0x7f5 kernel/softirq.c:293
 asm_call_on_stack+0xf/0x20 arch/x86/entry/entry_64.S:711
 </IRQ>
 __run_on_irqstack arch/x86/include/asm/irq_stack.h:23 [inline]
 run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:50 [inline]
 do_softirq_own_stack+0x7c/0xa0 arch/x86/kernel/irq_64.c:77
 invoke_softirq kernel/softirq.c:390 [inline]
 __irq_exit_rcu+0x226/0x270 kernel/softirq.c:420
 irq_exit_rcu+0xe/0x10 kernel/softirq.c:432
 sysvec_apic_timer_interrupt+0x107/0x130 arch/x86/kernel/apic/apic.c:1091
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:593
RIP: 0010:_raw_spin_unlock_irqrestore+0x4b/0x70 kernel/locking/spinlock.c:192
Code: 00 8b b8 88 0c 00 00 48 8b 00 48 85 c0 75 28 48 89 df e8 b8 6e 4b f1 c6 00 00 c6 03 00 4d 85 e4 75 1c 4c 89 7d d8 ff 75 d8 9d <48> 83 c4 08 5b 41 5c 41 5e 41 5f 5d c3 e8 53 74 4b f1 eb d1 44 89
RSP: 0018:ffff8880b8b0f880 EFLAGS: 00000282
RAX: ffff88821fd3bc00 RBX: ffff88812fd1dc00 RCX: 000000021fc9cc00
RDX: ffff88821fc9cc00 RSI: 00000000000004a0 RDI: ffff88812fd1dc00
RBP: ffff8880b8b0f8a8 R08: ffffea000000000f R09: ffff88812fffa000
R10: 0000000000000004 R11: 0000000000000000 R12: 0000000000000000
R13: ffff8880b656c2e8 R14: 0000000000000000 R15: 0000000000000282
 unlock_hrtimer_base kernel/time/hrtimer.c:898 [inline]
 hrtimer_start_range_ns+0x459/0x4e0 kernel/time/hrtimer.c:1136
 hrtimer_start include/linux/hrtimer.h:421 [inline]
 j1939_tp_schedule_txtimer+0x132/0x1b0 net/can/j1939/transport.c:671
 j1939_sk_send_loop net/can/j1939/socket.c:1047 [inline]
 j1939_sk_sendmsg+0x1cc0/0x2950 net/can/j1939/socket.c:1160
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg net/socket.c:672 [inline]
 ____sys_sendmsg+0xc82/0x1240 net/socket.c:2352
 ___sys_sendmsg net/socket.c:2406 [inline]
 __sys_sendmsg+0x6d1/0x840 net/socket.c:2439
 __do_sys_sendmsg net/socket.c:2448 [inline]
 __se_sys_sendmsg+0x97/0xb0 net/socket.c:2446
 __x64_sys_sendmsg+0x4a/0x70 net/socket.c:2446
 do_syscall_64+0xad/0x160 arch/x86/entry/common.c:386
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x443559
Code: Bad RIP value.
RSP: 002b:00007ffffdad8558 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000443559
RDX: 0000000000000000 RSI: 0000000020000180 RDI: 0000000000000003
RBP: 00007ffffdad8560 R08: 0000000001bbbbbb R09: 0000000001bbbbbb
R10: 0000000001bbbbbb R11: 0000000000000246 R12: 00007ffffdad8570
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:144 [inline]
 kmsan_internal_poison_shadow+0x66/0xd0 mm/kmsan/kmsan.c:127
 kmsan_slab_alloc+0x8a/0xe0 mm/kmsan/kmsan_hooks.c:80
 slab_alloc_node mm/slub.c:2839 [inline]
 __kmalloc_node_track_caller+0xeab/0x12e0 mm/slub.c:4478
 __kmalloc_reserve net/core/skbuff.c:142 [inline]
 __alloc_skb+0x35f/0xb30 net/core/skbuff.c:210
 alloc_skb include/linux/skbuff.h:1083 [inline]
 j1939_tp_tx_dat_new net/can/j1939/transport.c:568 [inline]
 j1939_xtp_do_tx_ctl net/can/j1939/transport.c:628 [inline]
 j1939_tp_tx_ctl net/can/j1939/transport.c:646 [inline]
 j1939_session_tx_rts net/can/j1939/transport.c:714 [inline]
 j1939_xtp_txnext_transmiter net/can/j1939/transport.c:832 [inline]
 j1939_tp_txtimer+0x402c/0x6980 net/can/j1939/transport.c:1095
 __run_hrtimer+0x7cd/0xf00 kernel/time/hrtimer.c:1520
 __hrtimer_run_queues kernel/time/hrtimer.c:1584 [inline]
 hrtimer_run_softirq+0x3bf/0x690 kernel/time/hrtimer.c:1601
 __do_softirq+0x2ea/0x7f5 kernel/softirq.c:293
=====================================================

