Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B386B4712B0
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 09:02:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbhLKICV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 03:02:21 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:55291 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbhLKICU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Dec 2021 03:02:20 -0500
Received: by mail-io1-f72.google.com with SMTP id s8-20020a056602168800b005e96bba1363so11752214iow.21
        for <netdev@vger.kernel.org>; Sat, 11 Dec 2021 00:02:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=EeKz3j9vcR2GnxnTOQwUqGTOoJNYNfAixyeRxFWnQ+w=;
        b=tR4npnPfgYsG3sT3tP2O0FJxRcH6NDG5YQGcGB1uM9Y3uLL2Tx8OJe5lWS/1m4jQ77
         7/KHYGfL2D9Yxj9my1ovGFeluHyeMAEZqeIcFdAgzp6PU9FjfQOU3r+y8ajwTlp9+MNw
         5FbNUz0bXJQdVANwtITSfkoVmlNGyusx+zes1rs+f3wpA6BrBhuLpgbioImX5I1uZtyl
         ex2fzIXmH6nt4PXtt6NLy4t2S38DV2bXJqw+YuHQ+ol1RswWsaDcFv4Z/+OBmV4d0NxK
         CTMqDrT7ZjNNQPf8gkUVS50TRyN41tcX8dTavmLLM9/87B4MUHfPjP+rWxgTECle13Ks
         QlwQ==
X-Gm-Message-State: AOAM530kFmSAD2FDkIf3kgX2XzX8nbMF2AwgyHRGfHIQJ2b9NoO+2RxH
        VUxw1BWL3GWZOJRj1yQ0kK6tRMhQgQnUenvFrldZBgmdh55y
X-Google-Smtp-Source: ABdhPJzAAVYLQtbiWq2sMTo/heoqsyANjlK4dyHnef3EZdgOvjVxWnM0kL/5dz0hvRhw6lbo8DlR0hYeDkZG1yz6jIrgjSo5J9Ps
MIME-Version: 1.0
X-Received: by 2002:a05:6602:1410:: with SMTP id t16mr26122007iov.160.1639209739770;
 Sat, 11 Dec 2021 00:02:19 -0800 (PST)
Date:   Sat, 11 Dec 2021 00:02:19 -0800
In-Reply-To: <000000000000a2490405a20d2b0f@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000405dc605d2da425e@google.com>
Subject: Re: [syzbot] WARNING in dev_watchdog (2)
From:   syzbot <syzbot+d55372214aff0faa1f1f@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    b8a98b6bf66a Merge tag 'pci-v5.16-fixes-2' of git://git.ke..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12fa7fc5b00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7d5e878e3399b6cc
dashboard link: https://syzkaller.appspot.com/bug?extid=d55372214aff0faa1f1f
compiler:       Debian clang version 11.0.1-2, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1068a551b00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1146706db00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d55372214aff0faa1f1f@syzkaller.appspotmail.com

------------[ cut here ]------------
NETDEV WATCHDOG: sl14 (): transmit queue 0 timed out
WARNING: CPU: 1 PID: 20260 at net/sched/sch_generic.c:478 dev_watchdog+0x81d/0x860 net/sched/sch_generic.c:477
Modules linked in:
CPU: 1 PID: 20260 Comm: dhcpcd-run-hook Not tainted 5.16.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:dev_watchdog+0x81d/0x860 net/sched/sch_generic.c:477
Code: 99 51 44 f9 c6 05 0d 02 ab 05 01 4c 89 e7 e8 ba fd e2 ff 48 c7 c7 e0 fb 9c 8b 4c 89 e6 48 89 c2 44 89 e9 31 c0 e8 33 2b 0e f9 <0f> 0b e9 2b fe ff ff 44 89 e9 80 e1 07 80 c1 03 38 c1 0f 8c 3c fc
RSP: 0018:ffffc90000dc0b40 EFLAGS: 00010246
RAX: 994dcd9ba1567700 RBX: 00000000ffffddd0 RCX: ffff8880a7b69d00
RDX: 0000000000000102 RSI: 0000000000000102 RDI: 0000000000000000
RBP: 00000000ffffde41 R08: ffffffff816a1d52 R09: fffff520001b80b9
R10: fffff520001b80b9 R11: 0000000000000000 R12: ffff88807dc5e000
R13: 0000000000000000 R14: ffff88807a490068 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000562f1294c000 CR3: 0000000179f36000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
 call_timer_fn+0xf6/0x210 kernel/time/timer.c:1421
 expire_timers kernel/time/timer.c:1466 [inline]
 __run_timers+0x71a/0x910 kernel/time/timer.c:1734
 run_timer_softirq+0x63/0xf0 kernel/time/timer.c:1747
 __do_softirq+0x392/0x7a3 kernel/softirq.c:558
 __irq_exit_rcu+0xec/0x170 kernel/softirq.c:637
 irq_exit_rcu+0x5/0x20 kernel/softirq.c:649
 sysvec_apic_timer_interrupt+0x91/0xb0 arch/x86/kernel/apic/apic.c:1097
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x12/0x20
RIP: 0010:get_flush_tlb_info arch/x86/mm/tlb.c:966 [inline]
RIP: 0010:flush_tlb_mm_range+0x1a2/0x490 arch/x86/mm/tlb.c:1004
Code: e8 03 80 3c 18 00 74 05 e8 6b 78 94 00 4d 89 7d 10 4c 89 e8 48 c1 e8 03 80 3c 18 00 74 08 4c 89 ef e8 52 78 94 00 48 8b 04 24 <49> 89 45 00 49 8d 7d 24 48 89 f8 48 c1 e8 03 8a 04 18 84 c0 0f 85
RSP: 0018:ffffc90020abf660 EFLAGS: 00000246
RAX: ffff888152e71500 RBX: dffffc0000000000 RCX: dffffc0000000000
RDX: 0000000000000001 RSI: 0000000000000001 RDI: ffff8880b9b38d90
RBP: ffffc90020abf720 R08: dffffc0000000000 R09: ffffed102a5ce325
R10: ffffed102a5ce325 R11: 0000000000000000 R12: 0000000000000000
R13: ffff8880b9b38d80 R14: 0000000000000009 R15: ffffffffffffffff
 tlb_flush arch/x86/include/asm/tlb.h:23 [inline]
 tlb_flush_mmu_tlbonly include/asm-generic/tlb.h:426 [inline]
 tlb_flush_mmu+0x1a7/0x910 mm/mmu_gather.c:248
 tlb_finish_mmu+0xcb/0x200 mm/mmu_gather.c:340
 exit_mmap+0x3dd/0x6f0 mm/mmap.c:3172
 __mmput+0x111/0x3a0 kernel/fork.c:1113
 exec_mmap+0x589/0x610 fs/exec.c:1028
 begin_new_exec+0x6c9/0x1180 fs/exec.c:1286
 load_elf_binary+0x851/0x3c60 fs/binfmt_elf.c:1001
 search_binary_handler fs/exec.c:1723 [inline]
 exec_binprm fs/exec.c:1764 [inline]
 bprm_execve+0x8eb/0x1470 fs/exec.c:1833
 do_execveat_common+0x44c/0x590 fs/exec.c:1922
 do_execve fs/exec.c:1990 [inline]
 __do_sys_execve fs/exec.c:2066 [inline]
 __se_sys_execve fs/exec.c:2061 [inline]
 __x64_sys_execve+0x8e/0xa0 fs/exec.c:2061
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x44/0xd0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fb90670f337
Code: Unable to access opcode bytes at RIP 0x7fb90670f30d.
RSP: 002b:00007ffd8df132e8 EFLAGS: 00000246 ORIG_RAX: 000000000000003b
RAX: ffffffffffffffda RBX: 0000562f1294bf28 RCX: 00007fb90670f337
RDX: 0000562f1294bf78 RSI: 0000562f1294bf28 RDI: 0000562f1294c000
RBP: 0000562f1294c000 R08: 0000562f1294c009 R09: 0000000000000000
R10: 0000000000000008 R11: 0000000000000246 R12: 0000562f1294bf78
R13: 00007fb9068b4ff4 R14: 0000562f1294bf78 R15: 0000000000000000
 </TASK>
----------------
Code disassembly (best guess):
   0:	e8 03 80 3c 18       	callq  0x183c8008
   5:	00 74 05 e8          	add    %dh,-0x18(%rbp,%rax,1)
   9:	6b 78 94 00          	imul   $0x0,-0x6c(%rax),%edi
   d:	4d 89 7d 10          	mov    %r15,0x10(%r13)
  11:	4c 89 e8             	mov    %r13,%rax
  14:	48 c1 e8 03          	shr    $0x3,%rax
  18:	80 3c 18 00          	cmpb   $0x0,(%rax,%rbx,1)
  1c:	74 08                	je     0x26
  1e:	4c 89 ef             	mov    %r13,%rdi
  21:	e8 52 78 94 00       	callq  0x947878
  26:	48 8b 04 24          	mov    (%rsp),%rax
* 2a:	49 89 45 00          	mov    %rax,0x0(%r13) <-- trapping instruction
  2e:	49 8d 7d 24          	lea    0x24(%r13),%rdi
  32:	48 89 f8             	mov    %rdi,%rax
  35:	48 c1 e8 03          	shr    $0x3,%rax
  39:	8a 04 18             	mov    (%rax,%rbx,1),%al
  3c:	84 c0                	test   %al,%al
  3e:	0f                   	.byte 0xf
  3f:	85                   	.byte 0x85

