Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59F7D20E554
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 00:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403770AbgF2Vfs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 17:35:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:60648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728494AbgF2Skq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 14:40:46 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DBD6206A1;
        Mon, 29 Jun 2020 12:56:09 +0000 (UTC)
Date:   Mon, 29 Jun 2020 08:56:08 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     syzbot <syzbot+721aa903751db87aa244@syzkaller.appspotmail.com>
Cc:     linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca,
        mingo@elte.hu, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <frederic@kernel.org>
Subject: Re: WARNING in tracepoint_add_func
Message-ID: <20200629085608.42ede213@oasis.local.home>
In-Reply-To: <000000000000a6348d05a9234041@google.com>
References: <000000000000a6348d05a9234041@google.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Cc'd Frederic and Peter.

-- Steve


On Sun, 28 Jun 2020 04:29:17 -0700
syzbot <syzbot+721aa903751db87aa244@syzkaller.appspotmail.com> wrote:

> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    7a64135f libbpf: Adjust SEC short cut for expected attach ..
> git tree:       bpf
> console output: https://syzkaller.appspot.com/x/log.txt?x=142782e3100000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=dcc6334acae363d4
> dashboard link: https://syzkaller.appspot.com/bug?extid=721aa903751db87aa244
> compiler:       gcc (GCC) 10.1.0-syz 20200507
> 
> Unfortunately, I don't have any reproducer for this crash yet.
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+721aa903751db87aa244@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 16762 at kernel/tracepoint.c:243 tracepoint_add_func+0x254/0x880 kernel/tracepoint.c:243
> Kernel panic - not syncing: panic_on_warn set ...
> CPU: 1 PID: 16762 Comm: syz-executor.4 Not tainted 5.8.0-rc1-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x18f/0x20d lib/dump_stack.c:118
>  panic+0x2e3/0x75c kernel/panic.c:231
>  __warn.cold+0x20/0x45 kernel/panic.c:600
>  report_bug+0x1bd/0x210 lib/bug.c:198
>  exc_invalid_op+0x24d/0x400 arch/x86/kernel/traps.c:235
>  asm_exc_invalid_op+0x12/0x20 arch/x86/include/asm/idtentry.h:563
> RIP: 0010:tracepoint_add_func+0x254/0x880 kernel/tracepoint.c:243
> Code: 44 24 20 48 8b 5b 08 80 38 00 0f 85 6b 05 00 00 48 8b 44 24 08 48 3b 58 08 0f 85 2d ff ff ff 41 bc ef ff ff ff e8 4c 78 fe ff <0f> 0b e8 45 78 fe ff 44 89 e0 48 83 c4 38 5b 5d 41 5c 41 5d 41 5e
> RSP: 0018:ffffc90001497a98 EFLAGS: 00010216
> RAX: 000000000000199a RBX: ffffffff89b99040 RCX: ffffc90011df4000
> RDX: 0000000000040000 RSI: ffffffff8174d824 RDI: ffff8880979adb30
> RBP: ffffffff814f1b80 R08: 0000000000000000 R09: ffffffff89bf9867
> R10: 000000000000000a R11: 0000000000000000 R12: 00000000ffffffef
> R13: 0000000000000001 R14: dffffc0000000000 R15: ffff8880979adb10
>  tracepoint_probe_register_prio kernel/tracepoint.c:315 [inline]
>  tracepoint_probe_register+0x9c/0xe0 kernel/tracepoint.c:335
>  trace_event_reg+0x28f/0x350 kernel/trace/trace_events.c:304
>  perf_trace_event_reg kernel/trace/trace_event_perf.c:129 [inline]
>  perf_trace_event_init+0x532/0x9a0 kernel/trace/trace_event_perf.c:204
>  perf_trace_init+0x176/0x240 kernel/trace/trace_event_perf.c:228
>  perf_tp_event_init+0xa2/0x120 kernel/events/core.c:9330
>  perf_try_init_event+0x12a/0x560 kernel/events/core.c:10782
>  perf_init_event kernel/events/core.c:10834 [inline]
>  perf_event_alloc.part.0+0xdee/0x36f0 kernel/events/core.c:11110
>  perf_event_alloc kernel/events/core.c:11489 [inline]
>  __do_sys_perf_event_open+0x72c/0x2b50 kernel/events/core.c:11605
>  do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:359
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> RIP: 0033:0x45cb19
> Code: Bad RIP value.
> RSP: 002b:00007f2d99608c78 EFLAGS: 00000246 ORIG_RAX: 000000000000012a
> RAX: ffffffffffffffda RBX: 00000000004fa640 RCX: 000000000045cb19
> RDX: 0000000000000000 RSI: ffffffffffffffff RDI: 0000000020000100
> RBP: 000000000078bf00 R08: 0000000000000000 R09: 0000000000000000
> R10: ffffffffffffffff R11: 0000000000000246 R12: 00000000ffffffff
> R13: 0000000000000841 R14: 00000000004cb320 R15: 00007f2d996096d4
> Kernel Offset: disabled
> 
> 
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

