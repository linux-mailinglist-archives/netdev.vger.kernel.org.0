Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C22B1197502
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 09:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729442AbgC3HMP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 03:12:15 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:52903 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729376AbgC3HMP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 03:12:15 -0400
Received: by mail-io1-f69.google.com with SMTP id r11so7669106ioc.19
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 00:12:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=MFSC8P6n72+QZknw3Wa9jPREFMD3f1rap8iRXS3R1WU=;
        b=kJFG7RNSstvWnlN19rCSV1Fq28NTMZipgveZW68sGsS/FII5WVAz5HxIc9emtVUHvG
         H4XXgfmHMR4Oc5zHcC4lGFSeCjfegNsTEAn6f8JCiQKxJ8Psfn4rnVs2NoL0Pdi5RfT6
         mqRsewpyxgrXZL0H6einii87H598SE+RTFyrO/gvGBPe60HPMee1MUkLejYgTKHLMmVI
         MOqgBFNz6b0mOw28QTUzU8E7ofYIF1eIzmN0y8Htn/lbZyvlhtXL2iq9qMGLzGisVnd5
         XuUm4+t0X6kl8TBMd+820hY6VOXauOyMBFAAjZmd2zIWFZwWZ0Mww7zzBv12PHCMpENm
         lJQg==
X-Gm-Message-State: ANhLgQ1LWPY/1sKuxg98/RhPM76cvsk7ezO4soNb7mfOKmSBLY8yue7J
        U4TtjIdTq7q51hTAAcCq+mQI0YLdCeDoYvtL6YBR6quS+jKN
X-Google-Smtp-Source: ADFU+vumZ+nATuPEvPDWPMKt+rEMY5srBlT2wE4oqm2vBndmjM1TLSxp4v1laNAacVO4kiHIe2VqRkrO59Z6MS3HywezfruYRTUu
MIME-Version: 1.0
X-Received: by 2002:a02:3b4f:: with SMTP id i15mr9845804jaf.63.1585552333881;
 Mon, 30 Mar 2020 00:12:13 -0700 (PDT)
Date:   Mon, 30 Mar 2020 00:12:13 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a2490405a20d2b0f@google.com>
Subject: WARNING in dev_watchdog (2)
From:   syzbot <syzbot+d55372214aff0faa1f1f@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    76bb8b05 Merge tag 'kbuild-v5.5' of git://git.kernel.org/p..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12627e41e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=dd226651cb0f364b
dashboard link: https://syzkaller.appspot.com/bug?extid=d55372214aff0faa1f1f
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+d55372214aff0faa1f1f@syzkaller.appspotmail.com

hrtimer: interrupt took 23084 ns
------------[ cut here ]------------
NETDEV WATCHDOG: eth0 (e1000): transmit queue 0 timed out
WARNING: CPU: 0 PID: 8061 at net/sched/sch_generic.c:442 dev_watchdog+0xaf5/0xca0 net/sched/sch_generic.c:442
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 8061 Comm: syz-executor.0 Not tainted 5.4.0-syzkaller #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x197/0x210 lib/dump_stack.c:118
 panic+0x2e3/0x75c kernel/panic.c:221
 __warn.cold+0x2f/0x3e kernel/panic.c:582
 report_bug+0x289/0x300 lib/bug.c:195
 fixup_bug arch/x86/kernel/traps.c:174 [inline]
 fixup_bug arch/x86/kernel/traps.c:169 [inline]
 do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:267
 do_invalid_op+0x37/0x50 arch/x86/kernel/traps.c:286
 invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
RIP: 0010:dev_watchdog+0xaf5/0xca0 net/sched/sch_generic.c:442
Code: ff e8 8f 09 48 fb 4c 89 e7 c6 05 9b e3 26 04 01 e8 00 31 e8 ff 44 89 e9 4c 89 e6 48 c7 c7 00 34 d7 88 48 89 c2 e8 ea b3 18 fb <0f> 0b e9 06 fd ff ff 48 8b 7d d0 e8 db 79 85 fb e9 7d f8 ff ff 48
RSP: 0018:ffffc90000007c98 EFLAGS: 00010286
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000100 RSI: ffffffff815e5a26 RDI: fffff52000000f85
RBP: ffffc90000007d00 R08: ffff888021394140 R09: ffffed1005a46621
R10: ffffed1005a46620 R11: ffff88802d233107 R12: ffff888027b6c000
R13: 0000000000000000 R14: ffff888027b6c4f8 R15: ffffffffffffe721
 call_timer_fn+0x1ac/0x780 kernel/time/timer.c:1404
 expire_timers kernel/time/timer.c:1449 [inline]
 __run_timers kernel/time/timer.c:1773 [inline]
 __run_timers kernel/time/timer.c:1740 [inline]
 run_timer_softirq+0x6c3/0x1790 kernel/time/timer.c:1786
 __do_softirq+0x262/0x98c kernel/softirq.c:292
 invoke_softirq kernel/softirq.c:373 [inline]
 irq_exit+0x19b/0x1e0 kernel/softirq.c:413
 exiting_irq arch/x86/include/asm/apic.h:536 [inline]
 smp_apic_timer_interrupt+0x1a3/0x610 arch/x86/kernel/apic/apic.c:1137
 apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:829
 </IRQ>
RIP: 0010:arch_local_irq_restore arch/x86/include/asm/paravirt.h:752 [inline]
RIP: 0010:generic_exec_single+0x33a/0x4c0 kernel/smp.c:155
Code: 00 fc ff df 48 c1 e8 03 80 3c 10 00 0f 85 68 01 00 00 48 83 3d de 62 09 08 00 0f 84 e0 00 00 00 e8 bb 27 0b 00 48 89 df 57 9d <0f> 1f 44 00 00 45 31 ed e9 39 fe ff ff e8 a4 27 0b 00 0f 0b e9 23
RSP: 0018:ffffc90000ea7a80 EFLAGS: 00000216 ORIG_RAX: ffffffffffffff13
RAX: 0000000000040000 RBX: 0000000000000216 RCX: ffffc9000397a000
RDX: 000000000000129c RSI: ffffffff8169d2c5 RDI: 0000000000000216
RBP: ffffc90000ea7ab0 R08: 1ffffffff16161b8 R09: fffffbfff16161b9
R10: fffffbfff16161b8 R11: ffffffff8b0b0dc7 R12: 0000000000000200
R13: ffffc90000ea7b00 R14: ffffc90000ea7bd0 R15: ffffffff818beee0
 smp_call_function_single+0x17c/0x480 kernel/smp.c:308
 task_function_call+0xe9/0x180 kernel/events/core.c:114
 perf_install_in_context+0x308/0x5a0 kernel/events/core.c:2746
 __do_sys_perf_event_open+0x1cbc/0x2c70 kernel/events/core.c:11543
 __se_sys_perf_event_open kernel/events/core.c:11151 [inline]
 __x64_sys_perf_event_open+0xbe/0x150 kernel/events/core.c:11151
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x45a759
Code: bd b1 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 8b b1 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fa1443afc88 EFLAGS: 00000246 ORIG_RAX: 000000000000012a
RAX: ffffffffffffffda RBX: 000000000072bf00 RCX: 000000000045a759
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000020000180
RBP: 0000000000000005 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffffffffffff R11: 0000000000000246 R12: 00007fa1443b06d4
R13: 00000000004af4bf R14: 00000000006f3b98 R15: 00000000ffffffff
------------[ cut here ]------------
WARNING: CPU: 0 PID: 8061 at kernel/locking/mutex.c:1419 mutex_trylock+0x279/0x2f0 kernel/locking/mutex.c:1427
Modules linked in:
CPU: 0 PID: 8061 Comm: syz-executor.0 Not tainted 5.4.0-syzkaller #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
RIP: 0010:mutex_trylock+0x279/0x2f0 kernel/locking/mutex.c:1419
Code: c9 41 b8 01 00 00 00 31 c9 ba 01 00 00 00 31 f6 e8 ac 32 99 f9 58 48 8d 65 d8 b8 01 00 00 00 5b 41 5c 41 5d 41 5e 41 5f 5d c3 <0f> 0b e9 0c fe ff ff 48 c7 c7 e0 e4 41 8b 48 89 4d d0 e8 e0 be f0
RSP: 0018:ffffc90000007858 EFLAGS: 00010006
RAX: 0000000000000103 RBX: 1ffff92000000f13 RCX: 0000000000000004
RDX: 0000000000000100 RSI: ffffffff816be955 RDI: ffffffff897c27a0
RBP: ffffc90000007888 R08: 0000000000000001 R09: fffffbfff12f3855
R10: fffffbfff12f3854 R11: ffffffff8979c2a3 R12: ffffffff8b41e4e0
R13: 0000000000000000 R14: ffffffff862cf100 R15: ffffffff897c27a0
FS:  00007fa1443b0700(0000) GS:ffff88802d200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020001280 CR3: 0000000029896000 CR4: 00000000003406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
 __crash_kexec+0x91/0x200 kernel/kexec_core.c:948
 panic+0x308/0x75c kernel/panic.c:241
 __warn.cold+0x2f/0x3e kernel/panic.c:582
 report_bug+0x289/0x300 lib/bug.c:195
 fixup_bug arch/x86/kernel/traps.c:174 [inline]
 fixup_bug arch/x86/kernel/traps.c:169 [inline]
 do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:267
 do_invalid_op+0x37/0x50 arch/x86/kernel/traps.c:286
 invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
RIP: 0010:dev_watchdog+0xaf5/0xca0 net/sched/sch_generic.c:442
Code: ff e8 8f 09 48 fb 4c 89 e7 c6 05 9b e3 26 04 01 e8 00 31 e8 ff 44 89 e9 4c 89 e6 48 c7 c7 00 34 d7 88 48 89 c2 e8 ea b3 18 fb <0f> 0b e9 06 fd ff ff 48 8b 7d d0 e8 db 79 85 fb e9 7d f8 ff ff 48
RSP: 0018:ffffc90000007c98 EFLAGS: 00010286
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000100 RSI: ffffffff815e5a26 RDI: fffff52000000f85
RBP: ffffc90000007d00 R08: ffff888021394140 R09: ffffed1005a46621
R10: ffffed1005a46620 R11: ffff88802d233107 R12: ffff888027b6c000
R13: 0000000000000000 R14: ffff888027b6c4f8 R15: ffffffffffffe721
 call_timer_fn+0x1ac/0x780 kernel/time/timer.c:1404
 expire_timers kernel/time/timer.c:1449 [inline]
 __run_timers kernel/time/timer.c:1773 [inline]
 __run_timers kernel/time/timer.c:1740 [inline]
 run_timer_softirq+0x6c3/0x1790 kernel/time/timer.c:1786
 __do_softirq+0x262/0x98c kernel/softirq.c:292
 invoke_softirq kernel/softirq.c:373 [inline]
 irq_exit+0x19b/0x1e0 kernel/softirq.c:413
 exiting_irq arch/x86/include/asm/apic.h:536 [inline]
 smp_apic_timer_interrupt+0x1a3/0x610 arch/x86/kernel/apic/apic.c:1137
 apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:829
 </IRQ>
RIP: 0010:arch_local_irq_restore arch/x86/include/asm/paravirt.h:752 [inline]
RIP: 0010:generic_exec_single+0x33a/0x4c0 kernel/smp.c:155
Code: 00 fc ff df 48 c1 e8 03 80 3c 10 00 0f 85 68 01 00 00 48 83 3d de 62 09 08 00 0f 84 e0 00 00 00 e8 bb 27 0b 00 48 89 df 57 9d <0f> 1f 44 00 00 45 31 ed e9 39 fe ff ff e8 a4 27 0b 00 0f 0b e9 23
RSP: 0018:ffffc90000ea7a80 EFLAGS: 00000216 ORIG_RAX: ffffffffffffff13
RAX: 0000000000040000 RBX: 0000000000000216 RCX: ffffc9000397a000
RDX: 000000000000129c RSI: ffffffff8169d2c5 RDI: 0000000000000216
RBP: ffffc90000ea7ab0 R08: 1ffffffff16161b8 R09: fffffbfff16161b9
R10: fffffbfff16161b8 R11: ffffffff8b0b0dc7 R12: 0000000000000200
R13: ffffc90000ea7b00 R14: ffffc90000ea7bd0 R15: ffffffff818beee0
 smp_call_function_single+0x17c/0x480 kernel/smp.c:308
 task_function_call+0xe9/0x180 kernel/events/core.c:114
 perf_install_in_context+0x308/0x5a0 kernel/events/core.c:2746
 __do_sys_perf_event_open+0x1cbc/0x2c70 kernel/events/core.c:11543
 __se_sys_perf_event_open kernel/events/core.c:11151 [inline]
 __x64_sys_perf_event_open+0xbe/0x150 kernel/events/core.c:11151
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x45a759
Code: bd b1 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 8b b1 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fa1443afc88 EFLAGS: 00000246 ORIG_RAX: 000000000000012a
RAX: ffffffffffffffda RBX: 000000000072bf00 RCX: 000000000045a759
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000020000180
RBP: 0000000000000005 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffffffffffff R11: 0000000000000246 R12: 00007fa1443b06d4
R13: 00000000004af4bf R14: 00000000006f3b98 R15: 00000000ffffffff
irq event stamp: 2722971
hardirqs last  enabled at (2722970): [<ffffffff81006743>] trace_hardirqs_on_thunk+0x1a/0x1c arch/x86/entry/thunk_64.S:41
hardirqs last disabled at (2722971): [<ffffffff8100675f>] trace_hardirqs_off_thunk+0x1a/0x1c arch/x86/entry/thunk_64.S:42
softirqs last  enabled at (362): [<ffffffff8731cb72>] sctp_init_sock+0xed2/0x1450 net/sctp/socket.c:5169
softirqs last disabled at (605): [<ffffffff81475c8b>] invoke_softirq kernel/softirq.c:373 [inline]
softirqs last disabled at (605): [<ffffffff81475c8b>] irq_exit+0x19b/0x1e0 kernel/softirq.c:413
---[ end trace 1a7cb5e7e43d5cf6 ]---
------------[ cut here ]------------
WARNING: CPU: 0 PID: 8061 at kernel/locking/mutex.c:737 mutex_unlock+0x1d/0x30 kernel/locking/mutex.c:744
Modules linked in:
CPU: 0 PID: 8061 Comm: syz-executor.0 Tainted: G        W         5.4.0-syzkaller #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
RIP: 0010:mutex_unlock+0x1d/0x30 kernel/locking/mutex.c:737
Code: 4c 89 ff e8 35 ca f0 f9 e9 8c fb ff ff 55 65 8b 05 b0 7d 40 78 a9 00 ff 1f 00 48 89 e5 75 0b 48 8b 75 08 e8 45 f9 ff ff 5d c3 <0f> 0b 48 8b 75 08 e8 38 f9 ff ff 5d c3 66 0f 1f 44 00 00 48 b8 00
RSP: 0018:ffffc90000007888 EFLAGS: 00010006
RAX: 0000000000000103 RBX: 1ffff92000000f13 RCX: ffffffff816be96d
RDX: 0000000000000100 RSI: ffffffff816be9cf RDI: ffffffff897c27a0
RBP: ffffc90000007888 R08: ffff888021394140 R09: fffffbfff16161ba
R10: ffff888021394a78 R11: ffff888021394140 R12: 0000000000000001
R13: 0000000000000000 R14: ffffffff862cf100 R15: 00000000000001ba
FS:  00007fa1443b0700(0000) GS:ffff88802d200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020001280 CR3: 0000000029896000 CR4: 00000000003406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
 __crash_kexec+0x10b/0x200 kernel/kexec_core.c:957
 panic+0x308/0x75c kernel/panic.c:241
 __warn.cold+0x2f/0x3e kernel/panic.c:582
 report_bug+0x289/0x300 lib/bug.c:195
 fixup_bug arch/x86/kernel/traps.c:174 [inline]
 fixup_bug arch/x86/kernel/traps.c:169 [inline]
 do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:267
 do_invalid_op+0x37/0x50 arch/x86/kernel/traps.c:286
 invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
RIP: 0010:dev_watchdog+0xaf5/0xca0 net/sched/sch_generic.c:442
Code: ff e8 8f 09 48 fb 4c 89 e7 c6 05 9b e3 26 04 01 e8 00 31 e8 ff 44 89 e9 4c 89 e6 48 c7 c7 00 34 d7 88 48 89 c2 e8 ea b3 18 fb <0f> 0b e9 06 fd ff ff 48 8b 7d d0 e8 db 79 85 fb e9 7d f8 ff ff 48
RSP: 0018:ffffc90000007c98 EFLAGS: 00010286
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000100 RSI: ffffffff815e5a26 RDI: fffff52000000f85
RBP: ffffc90000007d00 R08: ffff888021394140 R09: ffffed1005a46621
R10: ffffed1005a46620 R11: ffff88802d233107 R12: ffff888027b6c000
R13: 0000000000000000 R14: ffff888027b6c4f8 R15: ffffffffffffe721
 call_timer_fn+0x1ac/0x780 kernel/time/timer.c:1404
 expire_timers kernel/time/timer.c:1449 [inline]
 __run_timers kernel/time/timer.c:1773 [inline]
 __run_timers kernel/time/timer.c:1740 [inline]
 run_timer_softirq+0x6c3/0x1790 kernel/time/timer.c:1786
 __do_softirq+0x262/0x98c kernel/softirq.c:292
 invoke_softirq kernel/softirq.c:373 [inline]
 irq_exit+0x19b/0x1e0 kernel/softirq.c:413
 exiting_irq arch/x86/include/asm/apic.h:536 [inline]
 smp_apic_timer_interrupt+0x1a3/0x610 arch/x86/kernel/apic/apic.c:1137
 apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:829
 </IRQ>
RIP: 0010:arch_local_irq_restore arch/x86/include/asm/paravirt.h:752 [inline]
RIP: 0010:generic_exec_single+0x33a/0x4c0 kernel/smp.c:155
Code: 00 fc ff df 48 c1 e8 03 80 3c 10 00 0f 85 68 01 00 00 48 83 3d de 62 09 08 00 0f 84 e0 00 00 00 e8 bb 27 0b 00 48 89 df 57 9d <0f> 1f 44 00 00 45 31 ed e9 39 fe ff ff e8 a4 27 0b 00 0f 0b e9 23
RSP: 0018:ffffc90000ea7a80 EFLAGS: 00000216 ORIG_RAX: ffffffffffffff13
RAX: 0000000000040000 RBX: 0000000000000216 RCX: ffffc9000397a000
RDX: 000000000000129c RSI: ffffffff8169d2c5 RDI: 0000000000000216
RBP: ffffc90000ea7ab0 R08: 1ffffffff16161b8 R09: fffffbfff16161b9
R10: fffffbfff16161b8 R11: ffffffff8b0b0dc7 R12: 0000000000000200
R13: ffffc90000ea7b00 R14: ffffc90000ea7bd0 R15: ffffffff818beee0
 smp_call_function_single+0x17c/0x480 kernel/smp.c:308
 task_function_call+0xe9/0x180 kernel/events/core.c:114
 perf_install_in_context+0x308/0x5a0 kernel/events/core.c:2746
 __do_sys_perf_event_open+0x1cbc/0x2c70 kernel/events/core.c:11543
 __se_sys_perf_event_open kernel/events/core.c:11151 [inline]
 __x64_sys_perf_event_open+0xbe/0x150 kernel/events/core.c:11151
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x45a759
Code: bd b1 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 8b b1 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fa1443afc88 EFLAGS: 00000246 ORIG_RAX: 000000000000012a
RAX: ffffffffffffffda RBX: 000000000072bf00 RCX: 000000000045a759
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000020000180
RBP: 0000000000000005 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffffffffffff R11: 0000000000000246 R12: 00007fa1443b06d4
R13: 00000000004af4bf R14: 00000000006f3b98 R15: 00000000ffffffff
irq event stamp: 2722971
hardirqs last  enabled at (2722970): [<ffffffff81006743>] trace_hardirqs_on_thunk+0x1a/0x1c arch/x86/entry/thunk_64.S:41
hardirqs last disabled at (2722971): [<ffffffff8100675f>] trace_hardirqs_off_thunk+0x1a/0x1c arch/x86/entry/thunk_64.S:42
softirqs last  enabled at (362): [<ffffffff8731cb72>] sctp_init_sock+0xed2/0x1450 net/sctp/socket.c:5169
softirqs last disabled at (605): [<ffffffff81475c8b>] invoke_softirq kernel/softirq.c:373 [inline]
softirqs last disabled at (605): [<ffffffff81475c8b>] irq_exit+0x19b/0x1e0 kernel/softirq.c:413
---[ end trace 1a7cb5e7e43d5cf7 ]---
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
