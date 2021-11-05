Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B92DF446243
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 11:35:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233153AbhKEKiR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 06:38:17 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:40662 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233151AbhKEKiC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Nov 2021 06:38:02 -0400
Received: by mail-io1-f70.google.com with SMTP id t1-20020a5d81c1000000b005de76e9e20cso5940938iol.7
        for <netdev@vger.kernel.org>; Fri, 05 Nov 2021 03:35:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=cNB+tE4AKA8z8YAxBjN+ixj7uS5g86EAeIE4JxHKPoo=;
        b=DRBsT82ex9T6GlmbhDRz+LpPLMK+N/eq07I6G+3WVPrSLpivK1pygVrYr7yD7g2aCS
         IavGP1mYF3LQLbam3F0jnMOmeS6leE0nyMMQLa7picPBVPhBHEbaKY5XGErZu0l0hmV9
         epez3VL+XHSLej5h3lh8zvdkr35/neax8Oz9ibVsXHOD6TIOiPdGLqwc2jOpt3SWAkFh
         XeaU30U5be38j9XtndDL7B0cVa1qh4Ax5h7KN1b+vefFp+pzqqiHisy7tXrhOfTIAcwF
         MaKweyo2Q6bFJl5uDI6zXD3wQSEPGk0zXeMVROSflGIAkzinRnFC5sgytLbCqCJdSdQ0
         1XUA==
X-Gm-Message-State: AOAM530uhQJIIPNSzAtUT3DzRhRFcFEBzcrFu2k2mzST2hPOWkK7MwOr
        M9BAMz0IJpOiE/flzPeT1U7G3gvUyPb6yXR/I8iJVgrs+mVC
X-Google-Smtp-Source: ABdhPJwZyhCRYGxypk9hITyt4FJuVw8c6uF2lWTTkViU6A1fb9h1Z8EvFd7jxNjiaE0qXkiFQwmStZY/sok1Z366jRHSVsrE291r
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:933:: with SMTP id o19mr6913868ilt.92.1636108522273;
 Fri, 05 Nov 2021 03:35:22 -0700 (PDT)
Date:   Fri, 05 Nov 2021 03:35:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000048c15c05d0083397@google.com>
Subject: [syzbot] general protection fault in cgroup_file_write
From:   syzbot <syzbot+50f5cf33a284ce738b62@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        cgroups@vger.kernel.org, christian@brauner.io,
        daniel@iogearbox.net, hannes@cmpxchg.org, john.fastabend@gmail.com,
        kafai@fb.com, kpsingh@kernel.org, linux-kernel@vger.kernel.org,
        lizefan.x@bytedance.com, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com,
        tj@kernel.org, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    d4439a1189f9 Merge tag 'hsi-for-5.16' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1656d30ab00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ff3ea6b218615239
dashboard link: https://syzkaller.appspot.com/bug?extid=50f5cf33a284ce738b62
compiler:       Debian clang version 11.0.1-2, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+50f5cf33a284ce738b62@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000008: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000040-0x0000000000000047]
CPU: 1 PID: 11182 Comm: syz-executor.1 Not tainted 5.15.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:cgroup_file_write+0xbe/0x790 kernel/cgroup/cgroup.c:3831
Code: 81 c3 88 08 00 00 48 89 d8 48 c1 e8 03 42 80 3c 38 00 74 08 48 89 df e8 c0 5c 52 00 48 8b 1b 48 83 c3 40 48 89 d8 48 c1 e8 03 <42> 80 3c 38 00 74 08 48 89 df e8 a3 5c 52 00 48 8b 03 48 89 44 24
RSP: 0018:ffffc9000a79f2a0 EFLAGS: 00010202
RAX: 0000000000000008 RBX: 0000000000000040 RCX: ffff888074320000
RDX: 0000000000000000 RSI: ffff88801d008980 RDI: ffff88806b48ac00
RBP: ffffc9000a79f390 R08: ffffffff8207dab3 R09: fffffbfff1fedffb
R10: fffffbfff1fedffb R11: 0000000000000000 R12: 1ffff920014f3e5c
R13: ffff88806b48ac00 R14: ffff88806b48ac00 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fe6fd24a1b8 CR3: 000000002c740000 CR4: 00000000003526e0
Call Trace:
 <TASK>
 kernfs_fop_write_iter+0x3b6/0x510 fs/kernfs/file.c:296
 __kernel_write+0x5d1/0xaf0 fs/read_write.c:535
 do_acct_process+0x112a/0x17b0 kernel/acct.c:518
 acct_pin_kill+0x27/0x130 kernel/acct.c:173
 pin_kill+0x2a6/0x940 fs/fs_pin.c:44
 mnt_pin_kill+0xc1/0x170 fs/fs_pin.c:81
 cleanup_mnt+0x4bc/0x510 fs/namespace.c:1130
 task_work_run+0x146/0x1c0 kernel/task_work.c:164
 exit_task_work include/linux/task_work.h:32 [inline]
 do_exit+0x705/0x24f0 kernel/exit.c:832
 do_group_exit+0x168/0x2d0 kernel/exit.c:929
 get_signal+0x16b0/0x2090 kernel/signal.c:2820
 arch_do_signal_or_restart+0x9c/0x730 arch/x86/kernel/signal.c:868
 handle_signal_work kernel/entry/common.c:148 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
 exit_to_user_mode_prepare+0x191/0x220 kernel/entry/common.c:207
 __syscall_exit_to_user_mode_work kernel/entry/common.c:289 [inline]
 syscall_exit_to_user_mode+0x2e/0x70 kernel/entry/common.c:300
 do_syscall_64+0x53/0xd0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f0054d5fae9
Code: Unable to access opcode bytes at RIP 0x7f0054d5fabf.
RSP: 002b:00007f00522d5218 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: fffffffffffffe00 RBX: 00007f0054e72f68 RCX: 00007f0054d5fae9
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00007f0054e72f68
RBP: 00007f0054e72f60 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f0054e72f6c
R13: 00007ffd99a378af R14: 00007f00522d5300 R15: 0000000000022000
 </TASK>
Modules linked in:
---[ end trace 54fd0e4a1cf7068c ]---
RIP: 0010:cgroup_file_write+0xbe/0x790 kernel/cgroup/cgroup.c:3831
Code: 81 c3 88 08 00 00 48 89 d8 48 c1 e8 03 42 80 3c 38 00 74 08 48 89 df e8 c0 5c 52 00 48 8b 1b 48 83 c3 40 48 89 d8 48 c1 e8 03 <42> 80 3c 38 00 74 08 48 89 df e8 a3 5c 52 00 48 8b 03 48 89 44 24
RSP: 0018:ffffc9000a79f2a0 EFLAGS: 00010202
RAX: 0000000000000008 RBX: 0000000000000040 RCX: ffff888074320000
RDX: 0000000000000000 RSI: ffff88801d008980 RDI: ffff88806b48ac00
RBP: ffffc9000a79f390 R08: ffffffff8207dab3 R09: fffffbfff1fedffb
R10: fffffbfff1fedffb R11: 0000000000000000 R12: 1ffff920014f3e5c
R13: ffff88806b48ac00 R14: ffff88806b48ac00 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fe6fd24a1b8 CR3: 000000000c88e000 CR4: 00000000003526e0
----------------
Code disassembly (best guess):
   0:	81 c3 88 08 00 00    	add    $0x888,%ebx
   6:	48 89 d8             	mov    %rbx,%rax
   9:	48 c1 e8 03          	shr    $0x3,%rax
   d:	42 80 3c 38 00       	cmpb   $0x0,(%rax,%r15,1)
  12:	74 08                	je     0x1c
  14:	48 89 df             	mov    %rbx,%rdi
  17:	e8 c0 5c 52 00       	callq  0x525cdc
  1c:	48 8b 1b             	mov    (%rbx),%rbx
  1f:	48 83 c3 40          	add    $0x40,%rbx
  23:	48 89 d8             	mov    %rbx,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	42 80 3c 38 00       	cmpb   $0x0,(%rax,%r15,1) <-- trapping instruction
  2f:	74 08                	je     0x39
  31:	48 89 df             	mov    %rbx,%rdi
  34:	e8 a3 5c 52 00       	callq  0x525cdc
  39:	48 8b 03             	mov    (%rbx),%rax
  3c:	48                   	rex.W
  3d:	89                   	.byte 0x89
  3e:	44                   	rex.R
  3f:	24                   	.byte 0x24


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
