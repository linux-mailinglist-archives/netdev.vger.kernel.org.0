Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9353B21C566
	for <lists+netdev@lfdr.de>; Sat, 11 Jul 2020 19:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728652AbgGKRDV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jul 2020 13:03:21 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:48806 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728412AbgGKRDV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jul 2020 13:03:21 -0400
Received: by mail-il1-f197.google.com with SMTP id q9so5984888ilt.15
        for <netdev@vger.kernel.org>; Sat, 11 Jul 2020 10:03:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=zx+wcMN9XwcOE9Jwr6b7EFyTsUN+BF3ioh+EWC9OsoU=;
        b=ZopZGieKdyJDoyo6ojBfgcg5lSMgonKGjlro8bneqd1Ua+GDvXCV8HpMJkYEmDYwJj
         /k1xfl6iafVDVN67j8WVIzYyMLZ2wHW06cXaZTZ0/LQNQ3HozyEE6XG+tIM/WHqhS2sO
         dn5zSMpVhL336p7vujmCWACYNWrM6oWKQLGSPyfJhBskrEtbPE5evfIO01jcRZPoM14r
         /ORNY1pEakpwY+re/PuNztfvJGRkDIYa0RXVrisqsORyeYqXFIMUjWRvXk2pEGCr2zgZ
         +sDHWmOF5KYoKD8/+GSjzqlvZ3UQs2pdRQiT4ZPF7EnFc1MBA7jgIcrqkJTR0/BDON6L
         iZ6Q==
X-Gm-Message-State: AOAM5325bbe9TElTpZagbUlqqKESQ7X/Nl0W+gVNUIEVSdfAXgbkVK9j
        etyUYwQM+rXIr6jmmfMo0yDmxXgyYZst32+IUThYKU2Xllbm
X-Google-Smtp-Source: ABdhPJxCNrQ7mwfVu4cyIs1iVuRfd7CVfH485Y1eSUaP3CBGERIgIgOaI+mZPbaGNgwQVkMDXgoVmaJWisdQH/1M/dyre4UOH0UL
MIME-Version: 1.0
X-Received: by 2002:a5e:9b08:: with SMTP id j8mr6336861iok.116.1594486999819;
 Sat, 11 Jul 2020 10:03:19 -0700 (PDT)
Date:   Sat, 11 Jul 2020 10:03:19 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000392a0a05aa2d6faf@google.com>
Subject: general protection fault in htab_elem_free_rcu
From:   syzbot <syzbot+a9db0ab6a8e0ca14351d@syzkaller.appspotmail.com>
To:     andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, john.fastabend@gmail.com, kafai@fb.com,
        kpsingh@chromium.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    d31958b3 Add linux-next specific files for 20200710
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=13935857100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3fe4fccb94cbc1a6
dashboard link: https://syzkaller.appspot.com/bug?extid=a9db0ab6a8e0ca14351d
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=133db22b100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16fe6f1f100000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+a9db0ab6a8e0ca14351d@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xf33bb70012bc003b: 0000 [#1] PREEMPT SMP KASAN
KASAN: maybe wild-memory-access in range [0x99ddd80095e001d8-0x99ddd80095e001df]
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.8.0-rc4-next-20200710-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:htab_elem_free kernel/bpf/hashtab.c:769 [inline]
RIP: 0010:htab_elem_free_rcu+0x4a/0x110 kernel/bpf/hashtab.c:779
Code: 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 bc 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 8b 6b f8 48 8d 7d 18 48 89 fa 48 c1 ea 03 <0f> b6 04 02 84 c0 74 08 3c 03 0f 8e 82 00 00 00 44 8b 65 18 bf 05
RSP: 0018:ffffc90000007e48 EFLAGS: 00010a03
RAX: dffffc0000000000 RBX: ffff888084800010 RCX: 0000000000000001
RDX: 133bbb0012bc003b RSI: ffffffff8186891e RDI: 99ddd80095e001de
RBP: 99ddd80095e001c6 R08: 0000000000000000 R09: ffffffff8c5b09f7
R10: fffffbfff18b613e R11: 0000000000000000 R12: ffffc90000007ed8
R13: ffff888084800000 R14: 0000000000000000 R15: ffffffff89a86580
FS:  0000000000000000(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000004c6368 CR3: 0000000009a79000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
 rcu_do_batch kernel/rcu/tree.c:2418 [inline]
 rcu_core+0x5dc/0x11d0 kernel/rcu/tree.c:2645
 __do_softirq+0x34c/0xa60 kernel/softirq.c:292
 asm_call_on_stack+0xf/0x20 arch/x86/entry/entry_64.S:706
 </IRQ>
 __run_on_irqstack arch/x86/include/asm/irq_stack.h:22 [inline]
 run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:48 [inline]
 do_softirq_own_stack+0x111/0x170 arch/x86/kernel/irq_64.c:77
 invoke_softirq kernel/softirq.c:387 [inline]
 __irq_exit_rcu kernel/softirq.c:417 [inline]
 irq_exit_rcu+0x229/0x270 kernel/softirq.c:429
 sysvec_apic_timer_interrupt+0x54/0x120 arch/x86/kernel/apic/apic.c:1090
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:587
RIP: 0010:native_safe_halt+0xe/0x10 arch/x86/include/asm/irqflags.h:61
Code: ff 4c 89 ef e8 93 66 c6 f9 e9 8e fe ff ff 48 89 df e8 86 66 c6 f9 eb 8a cc cc cc cc e9 07 00 00 00 0f 00 2d 34 9b 5b 00 fb f4 <c3> 90 e9 07 00 00 00 0f 00 2d 24 9b 5b 00 f4 c3 cc cc 55 53 e8 09
RSP: 0018:ffffffff89a07c70 EFLAGS: 00000293
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffffffff89a86580 RSI: ffffffff87ed2968 RDI: ffffffff87ed293e
RBP: ffff8880a6a93064 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: ffff8880a6a93064
R13: 1ffffffff1340f98 R14: ffff8880a6a93065 R15: 0000000000000001
 arch_safe_halt arch/x86/include/asm/paravirt.h:150 [inline]
 acpi_safe_halt+0x8d/0x110 drivers/acpi/processor_idle.c:111
 acpi_idle_do_entry+0x15c/0x1b0 drivers/acpi/processor_idle.c:525
 acpi_idle_enter+0x3f9/0xab0 drivers/acpi/processor_idle.c:651
 cpuidle_enter_state+0xff/0x960 drivers/cpuidle/cpuidle.c:235
 cpuidle_enter+0x4a/0xa0 drivers/cpuidle/cpuidle.c:346
 call_cpuidle kernel/sched/idle.c:126 [inline]
 cpuidle_idle_call kernel/sched/idle.c:214 [inline]
 do_idle+0x431/0x6d0 kernel/sched/idle.c:276
 cpu_startup_entry+0x14/0x20 kernel/sched/idle.c:372
 start_kernel+0x9cb/0xa06 init/main.c:1045
 secondary_startup_64+0xa4/0xb0 arch/x86/kernel/head_64.S:243
Modules linked in:
---[ end trace 5ce7b44eaacf6c96 ]---
RIP: 0010:htab_elem_free kernel/bpf/hashtab.c:769 [inline]
RIP: 0010:htab_elem_free_rcu+0x4a/0x110 kernel/bpf/hashtab.c:779
Code: 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 bc 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 8b 6b f8 48 8d 7d 18 48 89 fa 48 c1 ea 03 <0f> b6 04 02 84 c0 74 08 3c 03 0f 8e 82 00 00 00 44 8b 65 18 bf 05
RSP: 0018:ffffc90000007e48 EFLAGS: 00010a03
RAX: dffffc0000000000 RBX: ffff888084800010 RCX: 0000000000000001
RDX: 133bbb0012bc003b RSI: ffffffff8186891e RDI: 99ddd80095e001de
RBP: 99ddd80095e001c6 R08: 0000000000000000 R09: ffffffff8c5b09f7
R10: fffffbfff18b613e R11: 0000000000000000 R12: ffffc90000007ed8
R13: ffff888084800000 R14: 0000000000000000 R15: ffffffff89a86580
FS:  0000000000000000(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000004c6368 CR3: 0000000009a79000 CR4: 00000000001506f0
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
