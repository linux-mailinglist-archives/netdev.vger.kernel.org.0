Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B7622958DB
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 09:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505522AbgJVHNW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 03:13:22 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:52479 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2505496AbgJVHNV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 03:13:21 -0400
Received: by mail-io1-f71.google.com with SMTP id e10so596869ioq.19
        for <netdev@vger.kernel.org>; Thu, 22 Oct 2020 00:13:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=jKhvVYGza2z6DwAdCGTtRAQGQcgl6+fOtpFD9e3IahA=;
        b=caOQZPycq04GSc8K5UyIUEia5DZLuRA7g8WkWNzJPWi6yJjo6uXtjQHS/o6STHz7VO
         FW3XQQJSaiSTqjlnP6fDdejZDVgrsZHTycVwdLJcs2mVaNI311MeOBpqq+wf1LN8NKcH
         78IfyfeaU523yn16DMD27zVO92ZdjqYJV4k6Zqw0GRa7jlrB/Fw0DXaiPxL1FfigazD2
         4P4NBD+6O3jrtixC7q1BvcZyymwlh+bjGSnbZtkBsGAg3zN4mz00dRSOW6J88YvlNEhU
         1tmLe6OM+DmzS44sNeUK9a/Qpw+x4KdLAJ/wCHFnsJMHiRMSxZc4+CCciEqFEUmS+cl1
         r7Nw==
X-Gm-Message-State: AOAM531yNBstnujdnlbT2XHYI5obuYjLgjXCB7DcQeqyZJvq/FD8PO8F
        WWOGVBIlOUvXi+wl/qFsS+q6QAIhUP5rsdf0vmx5HJiFnY9A
X-Google-Smtp-Source: ABdhPJynOk7VmlvKDICWLW10O8Bf9qcfCvJrtCcamCDBoxJTqmFWiN7LM0wJA8MkEWZ7Q6ql7OUvmQjHAM7MnsZXt9HI2pju7KrZ
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:111:: with SMTP id t17mr943475ilm.79.1603350798738;
 Thu, 22 Oct 2020 00:13:18 -0700 (PDT)
Date:   Thu, 22 Oct 2020 00:13:18 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000cf2beb05b23d328f@google.com>
Subject: BUG: unable to handle kernel paging request in bpf_trace_run3
From:   syzbot <syzbot+83aa762ef23b6f0d1991@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, hawk@kernel.org,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@chromium.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com,
        mmullins@fb.com, netdev@vger.kernel.org, rostedt@goodmis.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    9ff9b0d3 Merge tag 'net-next-5.10' of git://git.kernel.org..
git tree:       bpf
console output: https://syzkaller.appspot.com/x/log.txt?x=140e3e78500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d13c3fa80bc4bcc1
dashboard link: https://syzkaller.appspot.com/bug?extid=83aa762ef23b6f0d1991
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14113907900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=130d3310500000

The issue was bisected to:

commit 9df1c28bb75217b244257152ab7d788bb2a386d0
Author: Matt Mullins <mmullins@fb.com>
Date:   Fri Apr 26 18:49:47 2019 +0000

    bpf: add writable context for raw tracepoints

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=159e3e78500000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=179e3e78500000
console output: https://syzkaller.appspot.com/x/log.txt?x=139e3e78500000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+83aa762ef23b6f0d1991@syzkaller.appspotmail.com
Fixes: 9df1c28bb752 ("bpf: add writable context for raw tracepoints")

FAULT_INJECTION: forcing a failure.
name failslab, interval 1, probability 0, space 0, times 0
BUG: unable to handle page fault for address: ffffc90000e84030
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD aa000067 
P4D aa000067 
PUD aa1ee067 
PMD a9074067 
PTE 0

Oops: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 6879 Comm: syz-executor875 Not tainted 5.9.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:bpf_dispatcher_nop_func include/linux/bpf.h:644 [inline]
RIP: 0010:__bpf_trace_run kernel/trace/bpf_trace.c:2045 [inline]
RIP: 0010:bpf_trace_run3+0x145/0x3f0 kernel/trace/bpf_trace.c:2083
Code: f7 ff 48 8d 7b 30 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 9f 02 00 00 48 8d 73 38 48 8d 7c 24 28 <ff> 53 30 e8 c3 00 f7 ff e8 fe 32 c3 06 31 ff 89 c3 89 c6 e8 13 fd
RSP: 0018:ffffc90005457838 EFLAGS: 00010082

RAX: 0000000000000000 RBX: ffffc90000e84000 RCX: ffffffff817e37b0
RDX: 0000000000000000 RSI: ffffc90000e84038 RDI: ffffc90005457860
RBP: 1ffff92000a8af08 R08: 0000000000000000 R09: ffffffff8d7149a7
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
R13: ffff888092df4440 R14: 0000000000000001 R15: ffff8880a8f2e300
FS:  0000000001666880(0000) GS:ffff8880ae400000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffc90000e84030 CR3: 000000009d9ab000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 __bpf_trace_sched_switch+0xdc/0x120 include/trace/events/sched.h:138
 __traceiter_sched_switch+0x64/0xb0 include/trace/events/sched.h:138
 trace_sched_switch include/trace/events/sched.h:138 [inline]
 __schedule+0x1197/0x2200 kernel/sched/core.c:4520
 preempt_schedule_common+0x45/0xc0 kernel/sched/core.c:4682
 preempt_schedule_thunk+0x16/0x18 arch/x86/entry/thunk_64.S:40
 vprintk_emit+0x2d7/0x6e0 kernel/printk/printk.c:2029
 vprintk_func+0x8d/0x1e0 kernel/printk/printk_safe.c:393
 printk+0xba/0xed kernel/printk/printk.c:2076
 fail_dump lib/fault-inject.c:45 [inline]
 should_fail+0x472/0x5a0 lib/fault-inject.c:146
 should_failslab+0x5/0x10 mm/slab_common.c:1194
 slab_pre_alloc_hook.constprop.0+0xf4/0x200 mm/slab.h:512
 slab_alloc mm/slab.c:3300 [inline]
 __do_kmalloc mm/slab.c:3655 [inline]
 __kmalloc+0x6f/0x360 mm/slab.c:3666
 kmalloc include/linux/slab.h:559 [inline]
 allocate_probes kernel/tracepoint.c:58 [inline]
 func_remove kernel/tracepoint.c:210 [inline]
 tracepoint_remove_func kernel/tracepoint.c:297 [inline]
 tracepoint_probe_unregister+0x1cf/0x890 kernel/tracepoint.c:382
 bpf_raw_tp_link_release+0x51/0xa0 kernel/bpf/syscall.c:2734
 bpf_link_free+0xe6/0x1b0 kernel/bpf/syscall.c:2327
 bpf_link_put+0x15e/0x1b0 kernel/bpf/syscall.c:2353
 bpf_link_release+0x33/0x40 kernel/bpf/syscall.c:2361
 __fput+0x285/0x920 fs/file_table.c:281
 task_work_run+0xdd/0x190 kernel/task_work.c:141
 tracehook_notify_resume include/linux/tracehook.h:188 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:165 [inline]
 exit_to_user_mode_prepare+0x20e/0x230 kernel/entry/common.c:192
 syscall_exit_to_user_mode+0x7a/0x2c0 kernel/entry/common.c:267
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x441509
Code: e8 ac e8 ff ff 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 8b 09 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffd2b2c6888 EFLAGS: 00000246 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000441509
RDX: fffffffffffffffd RSI: 0000000000000001 RDI: 0000000000000004
RBP: 00007ffd2b2c68a0 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: ffffffffffffffff
R13: 0000000000000003 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
CR2: ffffc90000e84030
---[ end trace a42c1d698c9da70b ]---
RIP: 0010:bpf_dispatcher_nop_func include/linux/bpf.h:644 [inline]
RIP: 0010:__bpf_trace_run kernel/trace/bpf_trace.c:2045 [inline]
RIP: 0010:bpf_trace_run3+0x145/0x3f0 kernel/trace/bpf_trace.c:2083
Code: f7 ff 48 8d 7b 30 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 9f 02 00 00 48 8d 73 38 48 8d 7c 24 28 <ff> 53 30 e8 c3 00 f7 ff e8 fe 32 c3 06 31 ff 89 c3 89 c6 e8 13 fd
RSP: 0018:ffffc90005457838 EFLAGS: 00010082
RAX: 0000000000000000 RBX: ffffc90000e84000 RCX: ffffffff817e37b0
RDX: 0000000000000000 RSI: ffffc90000e84038 RDI: ffffc90005457860
RBP: 1ffff92000a8af08 R08: 0000000000000000 R09: ffffffff8d7149a7
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
R13: ffff888092df4440 R14: 0000000000000001 R15: ffff8880a8f2e300
FS:  0000000001666880(0000) GS:ffff8880ae400000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffc90000e84030 CR3: 000000009d9ab000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
