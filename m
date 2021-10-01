Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96D6141ECE4
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 14:05:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354273AbhJAMHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 08:07:12 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:40634 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354253AbhJAMHK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 08:07:10 -0400
Received: by mail-il1-f197.google.com with SMTP id b7-20020a92ce07000000b00258bc19c33cso2706592ilo.7
        for <netdev@vger.kernel.org>; Fri, 01 Oct 2021 05:05:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=6XR7AcFwJGCAhR4U8M+rl8QBYvsM2ERoXA6/OjrO3zU=;
        b=7KO1tB8Ins61Jpri/w1d+9Yy6+topIzanlW0kGQkJ6V9TII/+/CXxyxobXy9hbL4Sl
         SU9z6wVeyvtaWrG5+aHKh8MWM2hVUtBvYaoO9CSYBQ3s1NRHK20K+nsHz1dZiWGG/qGN
         T/Hh8SPW6zDoiLpU6sb89KbhxEVucFdRoUBG0ZrPGueyL0zpaaRnHOXcrtNIys3W+/u1
         j5/3bDO4RQoy20AztfBLoRXSSB69vpo1KPxo0McPfQO6p7PTni02z7wJ6I1cLHiKiDkM
         NPV8k1TgjK/LjlZENxQBnFLSeW255sXkv8Id9HLbqtPoWeRN2KArGstFSWWwUxwCgFnK
         VcqA==
X-Gm-Message-State: AOAM5335ryTCGmwhK1k60r4CDGtYoKFfUJwvg5RoHl/jzw8JVuID19Qh
        +0fPFzBZlzAblTNeT04bEvgJnWKFcGDyS+hwpLvTM/uZfOqX
X-Google-Smtp-Source: ABdhPJwZrhf9uro0TwU2UOZIoHBcW5RwGMHaI/lnR0Z6n+s/V1okJosAbQA4JH0TJt6dPG7/SbUbRK7nnzUVOKsuaZLFQp/Q5dMY
MIME-Version: 1.0
X-Received: by 2002:a5d:9f44:: with SMTP id u4mr3449828iot.155.1633089926290;
 Fri, 01 Oct 2021 05:05:26 -0700 (PDT)
Date:   Fri, 01 Oct 2021 05:05:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f1645705cd496085@google.com>
Subject: [syzbot] general protection fault in perf_tp_event (3)
From:   syzbot <syzbot+f27ed6d2b22fe3b92377@syzkaller.appspotmail.com>
To:     acme@kernel.org, alexander.shishkin@linux.intel.com,
        andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, john.fastabend@gmail.com, jolsa@redhat.com,
        kafai@fb.com, kpsingh@kernel.org, linux-kernel@vger.kernel.org,
        linux-perf-users@vger.kernel.org, mark.rutland@arm.com,
        mingo@redhat.com, namhyung@kernel.org, netdev@vger.kernel.org,
        peterz@infradead.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    a3debf177f21 libbpf: Fix segfault in static linker for obj..
git tree:       bpf
console output: https://syzkaller.appspot.com/x/log.txt?x=122fa35f300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c31c0936547df9ea
dashboard link: https://syzkaller.appspot.com/bug?extid=f27ed6d2b22fe3b92377
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f27ed6d2b22fe3b92377@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xfe001bea7e002090: 0000 [#1] PREEMPT SMP KASAN
KASAN: maybe wild-memory-access in range [0xf000ff53f0010480-0xf000ff53f0010487]
CPU: 0 PID: 29889 Comm: syz-executor.4 Not tainted 5.14.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:perf_tp_filter_match kernel/events/core.c:9622 [inline]
RIP: 0010:perf_tp_event_match kernel/events/core.c:9639 [inline]
RIP: 0010:perf_tp_event_match kernel/events/core.c:9627 [inline]
RIP: 0010:perf_tp_event+0x2af/0xb70 kernel/events/core.c:9682
Code: 3c 20 00 0f 85 d7 07 00 00 4c 8b bb e8 02 00 00 4d 85 ff 4c 0f 44 fb e8 df 37 e1 ff 49 8d bf 30 05 00 00 48 89 fa 48 c1 ea 03 <42> 80 3c 22 00 0f 85 a1 07 00 00 4d 8b 87 30 05 00 00 4d 85 c0 0f
RSP: 0018:ffffc90002137540 EFLAGS: 00010806
RAX: 0000000000000a8c RBX: ffff887fffffffa0 RCX: ffffc90012317000
RDX: 1e001fea7e002090 RSI: ffffffff8194d811 RDI: f000ff53f0010483
RBP: ffffc900021377b0 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff8194d7ac R11: 0000000000000000 R12: dffffc0000000000
R13: ffff8880b9c2c800 R14: 0000000000000001 R15: f000ff53f000ff53
FS:  00007fb42500a700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fb424fe9718 CR3: 0000000021c6d000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
Call Trace:
 perf_trace_run_bpf_submit+0x11c/0x210 kernel/events/core.c:9657
 perf_trace_lock+0x2ef/0x4d0 include/trace/events/lock.h:39
 trace_lock_release include/trace/events/lock.h:58 [inline]
 lock_release+0x4a8/0x720 kernel/locking/lockdep.c:5636
 __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:158 [inline]
 _raw_spin_unlock_irqrestore+0x16/0x70 kernel/locking/spinlock.c:194
 spin_unlock_irqrestore include/linux/spinlock.h:418 [inline]
 pcpu_alloc+0x848/0x1350 mm/percpu.c:1851
 bpf_prog_alloc+0x4b/0x1a0 kernel/bpf/core.c:125
 bpf_prog_load+0x651/0x21f0 kernel/bpf/syscall.c:2248
 __sys_bpf+0x67e/0x5df0 kernel/bpf/syscall.c:4587
 __do_sys_bpf kernel/bpf/syscall.c:4691 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:4689 [inline]
 __x64_sys_bpf+0x75/0xb0 kernel/bpf/syscall.c:4689
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fb427a93709
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fb42500a188 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 00007fb427b97f60 RCX: 00007fb427a93709
RDX: 0000000000000070 RSI: 0000000020000440 RDI: 0000000000000005
RBP: 00007fb427aedcb4 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fffe8ec545f R14: 00007fb42500a300 R15: 0000000000022000
Modules linked in:
---[ end trace 01ae9f661067bd97 ]---
RIP: 0010:perf_tp_filter_match kernel/events/core.c:9622 [inline]
RIP: 0010:perf_tp_event_match kernel/events/core.c:9639 [inline]
RIP: 0010:perf_tp_event_match kernel/events/core.c:9627 [inline]
RIP: 0010:perf_tp_event+0x2af/0xb70 kernel/events/core.c:9682
Code: 3c 20 00 0f 85 d7 07 00 00 4c 8b bb e8 02 00 00 4d 85 ff 4c 0f 44 fb e8 df 37 e1 ff 49 8d bf 30 05 00 00 48 89 fa 48 c1 ea 03 <42> 80 3c 22 00 0f 85 a1 07 00 00 4d 8b 87 30 05 00 00 4d 85 c0 0f
RSP: 0018:ffffc90002137540 EFLAGS: 00010806
RAX: 0000000000000a8c RBX: ffff887fffffffa0 RCX: ffffc90012317000
RDX: 1e001fea7e002090 RSI: ffffffff8194d811 RDI: f000ff53f0010483
RBP: ffffc900021377b0 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff8194d7ac R11: 0000000000000000 R12: dffffc0000000000
R13: ffff8880b9c2c800 R14: 0000000000000001 R15: f000ff53f000ff53
FS:  00007fb42500a700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fb424fe9718 CR3: 0000000021c6d000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
----------------
Code disassembly (best guess), 1 bytes skipped:
   0:	20 00                	and    %al,(%rax)
   2:	0f 85 d7 07 00 00    	jne    0x7df
   8:	4c 8b bb e8 02 00 00 	mov    0x2e8(%rbx),%r15
   f:	4d 85 ff             	test   %r15,%r15
  12:	4c 0f 44 fb          	cmove  %rbx,%r15
  16:	e8 df 37 e1 ff       	callq  0xffe137fa
  1b:	49 8d bf 30 05 00 00 	lea    0x530(%r15),%rdi
  22:	48 89 fa             	mov    %rdi,%rdx
  25:	48 c1 ea 03          	shr    $0x3,%rdx
* 29:	42 80 3c 22 00       	cmpb   $0x0,(%rdx,%r12,1) <-- trapping instruction
  2e:	0f 85 a1 07 00 00    	jne    0x7d5
  34:	4d 8b 87 30 05 00 00 	mov    0x530(%r15),%r8
  3b:	4d 85 c0             	test   %r8,%r8
  3e:	0f                   	.byte 0xf


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
