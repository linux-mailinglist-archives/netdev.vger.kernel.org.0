Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7FCA17909E
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 13:48:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388074AbgCDMsQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 07:48:16 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:40773 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728953AbgCDMsP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 07:48:15 -0500
Received: by mail-il1-f199.google.com with SMTP id f68so1310830ilh.7
        for <netdev@vger.kernel.org>; Wed, 04 Mar 2020 04:48:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=3oxkV4FlYdubcsimPveT5+q9u8QBLd90Y7isE2K/UGU=;
        b=R3Q8b8pRh6jqGt851rar9oQ7wpGk4ZjhhoIZC+vAZa9VM+lgCLCZLEoyaEaNMJCpWE
         hecFqS+tkDwnWvp/mJF/aLOHa7tXrreUrHEfrXBgC/ZXQHsipm5tgsQKpTnoKEhxHrrG
         W+8iNqXDeTXMqCTxCR857qnStCYwv1w8ci+BTHuwHetVXZXWywxZkDpeEUadU7rhE06y
         jlu4XFOl0tYcGqWqPl5AC0z8001YIvYvlwmYzVD/1YTueElcELo0lHkT7ftHTqi64n61
         GwPqBIdWFeuCg0sbFbpyaTO5e1l3/epywlzANwkmp5OaX/pRbYoFzWuWAHKJewEvgy4o
         7NvQ==
X-Gm-Message-State: ANhLgQ1slkSpichiUgJEd7PlvTarqWdRB8cqWJ5/dXrqSP9Kv5VFDcbT
        BgBggniKOws6h96LpYEd8ZXvoVBbeldATCUYf/QoScNHQldb
X-Google-Smtp-Source: ADFU+vsHZXvBexw3BGYRk0n2HpnnxZhpOt2T811NCQ5LseKVc2WCBXe2+0J6GsoV0I9EK8U413zhR4klDqEj8rE0s6ZZ0FVrLlt/
MIME-Version: 1.0
X-Received: by 2002:a92:5e44:: with SMTP id s65mr2435239ilb.148.1583326093414;
 Wed, 04 Mar 2020 04:48:13 -0800 (PST)
Date:   Wed, 04 Mar 2020 04:48:13 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005c967305a006d54d@google.com>
Subject: WARNING: locking bug in __perf_event_task_sched_in
From:   syzbot <syzbot+3daecb3e8271380aeb51@syzkaller.appspotmail.com>
To:     acme@kernel.org, alexander.shishkin@linux.intel.com,
        andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, jolsa@redhat.com, kafai@fb.com,
        linux-kernel@vger.kernel.org, mark.rutland@arm.com,
        mingo@redhat.com, namhyung@kernel.org, netdev@vger.kernel.org,
        peterz@infradead.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    f8788d86 Linux 5.6-rc3
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13bcd8f9e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5d2e033af114153f
dashboard link: https://syzkaller.appspot.com/bug?extid=3daecb3e8271380aeb51
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+3daecb3e8271380aeb51@syzkaller.appspotmail.com

------------[ cut here ]------------
DEBUG_LOCKS_WARN_ON(1)
WARNING: CPU: 0 PID: 22488 at kernel/locking/lockdep.c:167 hlock_class kernel/locking/lockdep.c:167 [inline]
WARNING: CPU: 0 PID: 22488 at kernel/locking/lockdep.c:167 __lock_acquire+0x18b8/0x1bc0 kernel/locking/lockdep.c:3950
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 22488 Comm: syz-executor.1 Not tainted 5.6.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1fb/0x318 lib/dump_stack.c:118
 panic+0x264/0x7a9 kernel/panic.c:221
 __warn+0x209/0x210 kernel/panic.c:582
 report_bug+0x1b6/0x2f0 lib/bug.c:195
 fixup_bug arch/x86/kernel/traps.c:174 [inline]
 do_error_trap+0xcf/0x1c0 arch/x86/kernel/traps.c:267
 do_invalid_op+0x36/0x40 arch/x86/kernel/traps.c:286
 invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
RIP: 0010:hlock_class kernel/locking/lockdep.c:167 [inline]
RIP: 0010:__lock_acquire+0x18b8/0x1bc0 kernel/locking/lockdep.c:3950
Code: 08 00 0f 85 f5 f0 ff ff 45 31 f6 48 c7 c7 bd aa e3 88 48 c7 c6 76 6b e8 88 31 c0 e8 72 e8 ec ff 48 bf 00 00 00 00 00 fc ff df <0f> 0b e9 a4 f2 ff ff 45 31 f6 e9 92 f2 ff ff 48 c7 c1 c4 ea 69 89
RSP: 0018:ffffc90006e67720 EFLAGS: 00010046
RAX: 3b64cfd0d6c7a700 RBX: 0000000000000f7f RCX: ffff88809da745c0
RDX: 0000000040000002 RSI: 0000000000000001 RDI: dffffc0000000000
RBP: ffffc90006e67878 R08: ffffffff817cb4ba R09: fffffbfff125af8f
R10: fffffbfff125af8f R11: 0000000000000000 R12: 23bb989f87f92d60
R13: ffff88809da74e50 R14: 0000000000000000 R15: ffff88809da745c0
 lock_acquire+0x154/0x250 kernel/locking/lockdep.c:4484
 __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
 _raw_spin_lock+0x2d/0x40 kernel/locking/spinlock.c:151
 perf_ctx_lock kernel/events/core.c:154 [inline]
 perf_event_context_sched_in kernel/events/core.c:3567 [inline]
 __perf_event_task_sched_in+0x3de/0x7f0 kernel/events/core.c:3625
 perf_event_task_sched_in include/linux/perf_event.h:1179 [inline]
 finish_task_switch+0x103/0x550 kernel/sched/core.c:3217
 context_switch kernel/sched/core.c:3383 [inline]
 __schedule+0x887/0xcd0 kernel/sched/core.c:4080
 preempt_schedule_irq+0xca/0x150 kernel/sched/core.c:4337
 retint_kernel+0x1b/0x2b
RIP: 0010:arch_local_irq_restore arch/x86/include/asm/paravirt.h:752 [inline]
RIP: 0010:lock_acquire+0x1ae/0x250 kernel/locking/lockdep.c:4487
Code: c1 e8 03 42 80 3c 30 00 74 0c 48 c7 c7 10 d3 2a 89 e8 56 67 58 00 48 83 3d 6e 07 cf 07 00 0f 84 9c 00 00 00 48 8b 7d c0 57 9d <0f> 1f 44 00 00 48 83 c4 30 5b 41 5c 41 5d 41 5e 41 5f 5d c3 44 89
RSP: 0018:ffffc90006e67ba8 EFLAGS: 00000282 ORIG_RAX: ffffffffffffff13
RAX: 1ffffffff1255a62 RBX: 0000000000000000 RCX: ffffffff815cb150
RDX: dffffc0000000000 RSI: 0000000000000004 RDI: 0000000000000282
RBP: ffffc90006e67c00 R08: dffffc0000000000 R09: fffffbfff1384111
R10: fffffbfff1384111 R11: 0000000000000000 R12: 0000000000000001
R13: 0000000000000000 R14: dffffc0000000000 R15: ffff8880a3220d28
 flush_workqueue+0x10a/0x1820 kernel/workqueue.c:2775
 hci_dev_open+0x21d/0x2e0 net/bluetooth/hci_core.c:1626
 hci_sock_bind+0x1620/0x1b10 net/bluetooth/hci_sock.c:1200
 __sys_bind+0x2bd/0x3a0 net/socket.c:1662
 __do_sys_bind net/socket.c:1673 [inline]
 __se_sys_bind net/socket.c:1671 [inline]
 __x64_sys_bind+0x7a/0x90 net/socket.c:1671
 do_syscall_64+0xf7/0x1c0 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x45c449
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f1f400cac78 EFLAGS: 00000246 ORIG_RAX: 0000000000000031
RAX: ffffffffffffffda RBX: 00007f1f400cb6d4 RCX: 000000000045c449
RDX: 0000000000000006 RSI: 00000000200007c0 RDI: 0000000000000005
RBP: 000000000076bf20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 000000000000002c R14: 00000000004c28c9 R15: 000000000076bf2c
Shutting down cpus with NMI
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
