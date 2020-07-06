Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D626215600
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 12:59:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729025AbgGFK7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 06:59:17 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:36241 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729016AbgGFK7Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 06:59:16 -0400
Received: by mail-io1-f71.google.com with SMTP id g17so23382318iob.3
        for <netdev@vger.kernel.org>; Mon, 06 Jul 2020 03:59:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=T4RpfvTzhxjKATtZUtnzpG2blvqRzQy3JNJvC30eupo=;
        b=LiaBOF0NwruNaWhiZC9MGLgbzkbke/viZa7BiSXxx5vumvv3Y0ITRxv72QUnNQUm3/
         wzsZydf/U4tKF4Sxxa2pZ08uIzX1oWpIVMZlU7NqDz8yMimLyWp907eFBGRfi975c+QD
         vem12GfXxdRU5L3eJXHkiw6VHmEd5C4Ib3qVDsVyPwKYC62MnGH32vnpiEe94C7iRUSa
         Hrcl2KGkMX//HwNqazcDapX9zEm+D7JBcuOw9pbzQvH1kljh3AIidYjimldXSfyBro+y
         x0J5Wedv1CPswLxdcdLzepdbTp+T1N4kouH96VYnnIrupd2E8hj7B5oza2yZtfr/iTuh
         4JDg==
X-Gm-Message-State: AOAM532x53R2mVdoWFtZJMKHDtuv2WmuNC70KbsorgJ6JkK5VxSedI72
        Iy0J87rQYJIY3WSP6d9JzUPeyBXIg8s+TYAyQoud9yBFHZWS
X-Google-Smtp-Source: ABdhPJz9bxB5JTkD1JA24MtdSVUbGWLRSgS863neUybfKjrmznz/FD+obvjwhRnuPJO1m8dmR3K+/FdW7wtxD+N7RUbvsYeYOWQS
MIME-Version: 1.0
X-Received: by 2002:a05:6638:dd3:: with SMTP id m19mr54095902jaj.106.1594033155348;
 Mon, 06 Jul 2020 03:59:15 -0700 (PDT)
Date:   Mon, 06 Jul 2020 03:59:15 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000fc1fb505a9c3c319@google.com>
Subject: general protection fault in perf_tp_event (2)
From:   syzbot <syzbot+740e88e3bac50daed3e2@syzkaller.appspotmail.com>
To:     acme@kernel.org, alexander.shishkin@linux.intel.com,
        andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, john.fastabend@gmail.com, jolsa@redhat.com,
        kafai@fb.com, kpsingh@chromium.org, linux-kernel@vger.kernel.org,
        mark.rutland@arm.com, mingo@redhat.com, namhyung@kernel.org,
        netdev@vger.kernel.org, peterz@infradead.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    cd77006e Merge tag 'hyperv-fixes-signed' of git://git.kern..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14ef7755100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=183dd243398ba7ec
dashboard link: https://syzkaller.appspot.com/bug?extid=740e88e3bac50daed3e2
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+740e88e3bac50daed3e2@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xe000025d40802049: 0000 [#1] PREEMPT SMP KASAN
KASAN: probably user-memory-access in range [0x000032ea04010248-0x000032ea0401024f]
CPU: 0 PID: 13034 Comm: syz-executor.1 Not tainted 5.8.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:perf_tp_event_match kernel/events/core.c:9226 [inline]
RIP: 0010:perf_tp_event+0x1bf/0xa70 kernel/events/core.c:9277
Code: 00 00 48 8b 44 24 40 4c 8d b0 88 00 00 00 0f 1f 00 66 2e 0f 1f 84 00 00 00 00 00 49 8d 9c 24 d8 01 00 00 48 89 d8 48 c1 e8 03 <42> 0f b6 04 38 84 c0 0f 85 c2 01 00 00 8b 1b 89 de 83 e6 01 31 ff
RSP: 0018:ffffc9000dc4f740 EFLAGS: 00010003
RAX: 0000065d40802049 RBX: 000032ea0401024c RCX: ffffffff8177b911
RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffff88804aa30480
RBP: ffffc9000dc4f9c8 R08: dffffc0000000000 R09: ffffed1009546091
R10: ffffed1009546091 R11: 0000000000000000 R12: 000032ea04010074
R13: ffff8880ae800000 R14: ffff8880ae8317f8 R15: dffffc0000000000
FS:  00007f5d24ad7700(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffd68dc03b8 CR3: 00000000a2cbd000 CR4: 00000000001426f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 perf_trace_run_bpf_submit+0x106/0x1a0 kernel/events/core.c:9252
 perf_trace_sched_wakeup_template+0x289/0x3c0 include/trace/events/sched.h:57
 trace_sched_wakeup+0xb2/0x190 include/trace/events/sched.h:96
 ttwu_do_wakeup+0x4e/0x300 kernel/sched/core.c:2204
 ttwu_do_activate kernel/sched/core.c:2248 [inline]
 ttwu_queue kernel/sched/core.c:2412 [inline]
 try_to_wake_up+0x901/0xc10 kernel/sched/core.c:2663
 wake_up_process kernel/sched/core.c:2733 [inline]
 wake_up_q+0x8c/0xe0 kernel/sched/core.c:498
 __mutex_unlock_slowpath+0x565/0x590 kernel/locking/mutex.c:1280
 perf_try_init_event+0x30a/0x3a0 kernel/events/core.c:10797
 perf_init_event kernel/events/core.c:10834 [inline]
 perf_event_alloc+0xdb1/0x2870 kernel/events/core.c:11110
 __do_sys_perf_event_open kernel/events/core.c:11605 [inline]
 __se_sys_perf_event_open+0x6e2/0x3fa0 kernel/events/core.c:11479
 do_syscall_64+0x73/0xe0 arch/x86/entry/common.c:359
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45cb29
Code: Bad RIP value.
RSP: 002b:00007f5d24ad6c78 EFLAGS: 00000246 ORIG_RAX: 000000000000012a
RAX: ffffffffffffffda RBX: 00000000004fa6e0 RCX: 000000000045cb29
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000020000100
RBP: 000000000078bf00 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffffffffffff R11: 0000000000000246 R12: 0000000000000003
R13: 0000000000000842 R14: 00000000004cb34b R15: 00007f5d24ad76d4
Modules linked in:
---[ end trace 11dff03731370b11 ]---
RIP: 0010:perf_tp_event_match kernel/events/core.c:9226 [inline]
RIP: 0010:perf_tp_event+0x1bf/0xa70 kernel/events/core.c:9277
Code: 00 00 48 8b 44 24 40 4c 8d b0 88 00 00 00 0f 1f 00 66 2e 0f 1f 84 00 00 00 00 00 49 8d 9c 24 d8 01 00 00 48 89 d8 48 c1 e8 03 <42> 0f b6 04 38 84 c0 0f 85 c2 01 00 00 8b 1b 89 de 83 e6 01 31 ff
RSP: 0018:ffffc9000dc4f740 EFLAGS: 00010003
RAX: 0000065d40802049 RBX: 000032ea0401024c RCX: ffffffff8177b911
RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffff88804aa30480
RBP: ffffc9000dc4f9c8 R08: dffffc0000000000 R09: ffffed1009546091
R10: ffffed1009546091 R11: 0000000000000000 R12: 000032ea04010074
R13: ffff8880ae800000 R14: ffff8880ae8317f8 R15: dffffc0000000000
FS:  00007f5d24ad7700(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffd68dc03b8 CR3: 00000000a2cbd000 CR4: 00000000001426f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
