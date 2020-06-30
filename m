Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EFDE20EB04
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 03:42:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727917AbgF3BkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 21:40:18 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:55176 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726244AbgF3BkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 21:40:17 -0400
Received: by mail-il1-f199.google.com with SMTP id d18so13607149ill.21
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 18:40:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=DVPJaXq8nr9G6IHKqt0DmNnsDRQutcQhp/Mwl7GL7R4=;
        b=Yn2t5WaOKsM1lvAla26NnqD6HqPyksZAPZ5IIwdH/j9acZiG6e/40vif+Y0Pc2pi8a
         sdzlgAokt0xuZe6V0RX/dImeFWY277yJ8DKhUrzQoHbSs7KEqoKWy8iZatzMROl3Hoke
         fK6+y2ZWYkO9BuiAfHUQhuB/1hNCuz5qnvM+PggowmDROmHMIrGcgEqzxrkvswIAeX7p
         XIHfZ0MWFYQVFuIjTGUcZN+De372LzDoOxQ1AGEeCD3FaGv9+lHvmrSSZzZFaYtQdacX
         /Vr8/lEtoZMH9f+yQg6stdsTFlsFtpXSPEpKRydgNfe4Pfb5YM19fy7+tkxTuqHOCDez
         ISRQ==
X-Gm-Message-State: AOAM533DNmA2o50UP+Vrg5QFQB5nuu6I9pxQLa5K4FGWN2ilY5nCwfry
        rYt+KoLQLr8kRxsPftJ4CMfm4x7RCtfDG978nVLrjBSgGv3X
X-Google-Smtp-Source: ABdhPJxhwzyS8LFTf+rYLOiSoLXTtWde8CGWyq4QMeaWtnqvJsOY9xYww+yLayt/aXVcgwifCW5XwwMs4m2t2xXY9OqUUL8HeIFc
MIME-Version: 1.0
X-Received: by 2002:a5d:9306:: with SMTP id l6mr8695366ion.105.1593481216518;
 Mon, 29 Jun 2020 18:40:16 -0700 (PDT)
Date:   Mon, 29 Jun 2020 18:40:16 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ddeefc05a9434198@google.com>
Subject: kernel BUG at net/l2tp/l2tp_core.c:LINE!
From:   syzbot <syzbot+9f092552ba9a5efca5df@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, fw@strlen.de,
        gnault@redhat.com, jchapman@katalix.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pablo@netfilter.org, ridge.kennedy@alliedtelesis.co.nz,
        syzkaller-bugs@googlegroups.com, vulab@iscas.ac.cn
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    7ae77150 Merge tag 'powerpc-5.8-1' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15db7bb5100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=be4578b3f1083656
dashboard link: https://syzkaller.appspot.com/bug?extid=9f092552ba9a5efca5df
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=143f0f95100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=171ffe75100000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+9f092552ba9a5efca5df@syzkaller.appspotmail.com

------------[ cut here ]------------
kernel BUG at net/l2tp/l2tp_core.c:1572!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.7.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:l2tp_session_free+0x1ee/0x1f0 net/l2tp/l2tp_core.c:1572
Code: 44 89 e1 80 e1 07 80 c1 03 38 c1 0f 8c b8 fe ff ff 4c 89 e7 e8 03 64 37 fa e9 ab fe ff ff e8 d9 7f f8 f9 0f 0b e8 d2 7f f8 f9 <0f> 0b 55 41 57 41 56 41 55 41 54 53 49 89 fe 48 bd 00 00 00 00 00
RSP: 0018:ffffc90000da8da8 EFLAGS: 00010246
RAX: ffffffff877c235e RBX: 0000000000000000 RCX: ffff8880a99f4340
RDX: 0000000080000101 RSI: 0000000000000000 RDI: 0000000042114dda
RBP: ffff8880a7958238 R08: ffffffff877c220d R09: ffffed1014f2b01a
R10: ffffed1014f2b01a R11: 0000000000000000 R12: ffff8880a6f77800
R13: dffffc0000000000 R14: ffff8880a7958000 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000049f410 CR3: 0000000009279000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
 __sk_destruct+0x50/0x740 net/core/sock.c:1785
 rcu_do_batch kernel/rcu/tree.c:2396 [inline]
 rcu_core+0x90c/0x1200 kernel/rcu/tree.c:2623
 __do_softirq+0x268/0x80c kernel/softirq.c:292
 invoke_softirq kernel/softirq.c:373 [inline]
 irq_exit+0x223/0x230 kernel/softirq.c:413
 exiting_irq arch/x86/include/asm/apic.h:546 [inline]
 smp_apic_timer_interrupt+0x113/0x280 arch/x86/kernel/apic/apic.c:1107
 apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:829
 </IRQ>
RIP: 0010:native_safe_halt+0xe/0x10 arch/x86/include/asm/irqflags.h:61
Code: 80 e1 07 80 c1 03 38 c1 7c bc 48 89 df e8 9a 17 9b f9 eb b2 cc cc cc cc cc cc cc cc e9 07 00 00 00 0f 00 2d 56 46 4a 00 fb f4 <c3> 90 e9 07 00 00 00 0f 00 2d 46 46 4a 00 f4 c3 cc cc 41 56 53 65
RSP: 0018:ffffc90000d3fd60 EFLAGS: 00000286 ORIG_RAX: ffffffffffffff13
RAX: 1ffffffff12577b9 RBX: 0000000000000000 RCX: ffffffffffffffff
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8880a99f4ba4
RBP: 1ffff1104351244e R08: ffffffff817a4660 R09: ffffed101533e869
R10: ffffed101533e869 R11: 0000000000000000 R12: 0000000000000001
R13: dffffc0000000000 R14: dffffc0000000000 R15: ffff88821a892270
 arch_safe_halt arch/x86/include/asm/paravirt.h:150 [inline]
 acpi_safe_halt+0x87/0xe0 drivers/acpi/processor_idle.c:111
 acpi_idle_do_entry drivers/acpi/processor_idle.c:525 [inline]
 acpi_idle_enter+0x3f4/0xac0 drivers/acpi/processor_idle.c:651
 cpuidle_enter_state+0x2d7/0x7b0 drivers/cpuidle/cpuidle.c:234
 cpuidle_enter+0x59/0x90 drivers/cpuidle/cpuidle.c:345
 call_cpuidle kernel/sched/idle.c:117 [inline]
 cpuidle_idle_call kernel/sched/idle.c:207 [inline]
 do_idle+0x49c/0x650 kernel/sched/idle.c:269
 cpu_startup_entry+0x15/0x20 kernel/sched/idle.c:365
 start_secondary+0x213/0x240 arch/x86/kernel/smpboot.c:268
 secondary_startup_64+0xa4/0xb0 arch/x86/kernel/head_64.S:242
Modules linked in:
---[ end trace 1d65b89c4fe927df ]---
RIP: 0010:l2tp_session_free+0x1ee/0x1f0 net/l2tp/l2tp_core.c:1572
Code: 44 89 e1 80 e1 07 80 c1 03 38 c1 0f 8c b8 fe ff ff 4c 89 e7 e8 03 64 37 fa e9 ab fe ff ff e8 d9 7f f8 f9 0f 0b e8 d2 7f f8 f9 <0f> 0b 55 41 57 41 56 41 55 41 54 53 49 89 fe 48 bd 00 00 00 00 00
RSP: 0018:ffffc90000da8da8 EFLAGS: 00010246
RAX: ffffffff877c235e RBX: 0000000000000000 RCX: ffff8880a99f4340
RDX: 0000000080000101 RSI: 0000000000000000 RDI: 0000000042114dda
RBP: ffff8880a7958238 R08: ffffffff877c220d R09: ffffed1014f2b01a
R10: ffffed1014f2b01a R11: 0000000000000000 R12: ffff8880a6f77800
R13: dffffc0000000000 R14: ffff8880a7958000 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000049f410 CR3: 0000000009279000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
