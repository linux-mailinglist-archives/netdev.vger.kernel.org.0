Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C04A52B9673
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 16:44:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728632AbgKSPm1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 10:42:27 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:42633 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728615AbgKSPm0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 10:42:26 -0500
Received: by mail-io1-f72.google.com with SMTP id p67so5040901iod.9
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 07:42:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=FcdTaSWLdsax1Db4lxSAy+okurY2LoZrT3Xpi1qIi2I=;
        b=pMfYONKBJ8+deAolvQzz/ni6oNhStAlfHMXfAskZMNZtDe0SlZ76uPVnAQ9F7a/DCj
         kdssZ0z/cJYAaM5D2/Xc9D3f4tlvZlSrNM73x2ElvzI8JTVqrd7ixL3zynLJKn5Dc06I
         oiB4SgDFxLuJc/hVa0mga6vpQ3abvjNL/Jhm6Yb7HLP99LLGQ+vYXf/39O87ukFncn69
         JLquKVmNhK4x8yZq5LuCWN+8f+nNzIt8iu0TOnm8xw5r1aGFBSwB/BpoSBQEj+PEuf+t
         UIS2z0Pcj0sbmgaAcZ4s7bPmiLLtX9EztcgQEBkuVYkVuw14/HZmJSWHqhX7lVfmYlhc
         5IMQ==
X-Gm-Message-State: AOAM531v/MrPc/8Bun4tfaW+6RnF7SMfh11z7e9wG5+cjVWkW8re3z0v
        bfa93wBh9yrF2mB7lahfSLYpuAHxAveS0pc93bDF3UlKwuCd
X-Google-Smtp-Source: ABdhPJwhiP+INO67eVYmSG+nKKuDRo/zm2frUguSFnP+VYjAgDuFpWPtZO6cVLN1DKRwTabNu4evtr5xFBlZzn5a6z9kHyy0rPEg
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:90:: with SMTP id l16mr23259127ilm.228.1605800543910;
 Thu, 19 Nov 2020 07:42:23 -0800 (PST)
Date:   Thu, 19 Nov 2020 07:42:23 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000003ef05b477936c@google.com>
Subject: INFO: task can't die in perf_event_free_task
From:   syzbot <syzbot+f02b92479b7065807a2a@syzkaller.appspotmail.com>
To:     acme@kernel.org, alexander.shishkin@linux.intel.com,
        andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, john.fastabend@gmail.com, jolsa@redhat.com,
        kafai@fb.com, kpsingh@chromium.org, linux-kernel@vger.kernel.org,
        mark.rutland@arm.com, mingo@redhat.com, namhyung@kernel.org,
        netdev@vger.kernel.org, peterz@infradead.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    92edc4ae Add linux-next specific files for 20201113
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=15982d72500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=79ad4f8ad2d96176
dashboard link: https://syzkaller.appspot.com/bug?extid=f02b92479b7065807a2a
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=116fb7be500000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f02b92479b7065807a2a@syzkaller.appspotmail.com

INFO: task syz-executor.0:26152 can't die for more than 143 seconds.
task:syz-executor.0  state:D stack:28544 pid:26152 ppid:  8500 flags:0x00004004
Call Trace:
 context_switch kernel/sched/core.c:4269 [inline]
 __schedule+0x890/0x2030 kernel/sched/core.c:5019
 schedule+0xcf/0x270 kernel/sched/core.c:5098
 perf_event_free_task+0x514/0x6b0 kernel/events/core.c:12605
 copy_process+0x48e0/0x6f90 kernel/fork.c:2360
 kernel_clone+0xe7/0xab0 kernel/fork.c:2462
 __do_sys_clone+0xc8/0x110 kernel/fork.c:2579
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45deb9
Code: Unable to access opcode bytes at RIP 0x45de8f.
RSP: 002b:00007ffb605e6c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000038
RAX: ffffffffffffffda RBX: 0000000000002040 RCX: 000000000045deb9
RDX: 9999999999999999 RSI: 0000000000000000 RDI: 0000000000000100
RBP: 000000000118bf70 R08: ffffffffffffffff R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000118bf2c
R13: 00007fff8d97524f R14: 00007ffb605e79c0 R15: 000000000118bf2c
INFO: task syz-executor.0:26152 blocked for more than 143 seconds.
      Not tainted 5.10.0-rc3-next-20201113-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor.0  state:D stack:28544 pid:26152 ppid:  8500 flags:0x00004004
Call Trace:
 context_switch kernel/sched/core.c:4269 [inline]
 __schedule+0x890/0x2030 kernel/sched/core.c:5019
 schedule+0xcf/0x270 kernel/sched/core.c:5098
 perf_event_free_task+0x514/0x6b0 kernel/events/core.c:12605
 copy_process+0x48e0/0x6f90 kernel/fork.c:2360
 kernel_clone+0xe7/0xab0 kernel/fork.c:2462
 __do_sys_clone+0xc8/0x110 kernel/fork.c:2579
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45deb9
Code: Unable to access opcode bytes at RIP 0x45de8f.
RSP: 002b:00007ffb605e6c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000038
RAX: ffffffffffffffda RBX: 0000000000002040 RCX: 000000000045deb9
RDX: 9999999999999999 RSI: 0000000000000000 RDI: 0000000000000100
RBP: 000000000118bf70 R08: ffffffffffffffff R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000118bf2c
R13: 00007fff8d97524f R14: 00007ffb605e79c0 R15: 000000000118bf2c

Showing all locks held in the system:
1 lock held by khungtaskd/1567:
 #0: ffffffff8b339ce0 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:6252
1 lock held by in:imklog/8178:
 #0: ffff88801c937c70 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0xe9/0x100 fs/file.c:932

=============================================

NMI backtrace for cpu 0
CPU: 0 PID: 1567 Comm: khungtaskd Not tainted 5.10.0-rc3-next-20201113-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:120
 nmi_cpu_backtrace.cold+0x44/0xd7 lib/nmi_backtrace.c:105
 nmi_trigger_cpumask_backtrace+0x1b3/0x230 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:147 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:253 [inline]
 watchdog+0xd89/0xf30 kernel/hung_task.c:338
 kthread+0x3af/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1 skipped: idling at native_safe_halt arch/x86/include/asm/irqflags.h:60 [inline]
NMI backtrace for cpu 1 skipped: idling at arch_safe_halt arch/x86/include/asm/irqflags.h:103 [inline]
NMI backtrace for cpu 1 skipped: idling at acpi_safe_halt drivers/acpi/processor_idle.c:111 [inline]
NMI backtrace for cpu 1 skipped: idling at acpi_idle_do_entry+0x1c9/0x250 drivers/acpi/processor_idle.c:517


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
