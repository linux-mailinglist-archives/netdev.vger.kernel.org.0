Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E575E48FFAF
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 01:05:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236471AbiAQAFZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jan 2022 19:05:25 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:51924 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236464AbiAQAFZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jan 2022 19:05:25 -0500
Received: by mail-il1-f199.google.com with SMTP id d8-20020a056e02214800b002b766d01bf5so10549904ilv.18
        for <netdev@vger.kernel.org>; Sun, 16 Jan 2022 16:05:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=n0Q0139SFG+a05PCBICqsbFwpyWDdadFRS7jqfWkpqs=;
        b=nFb6AsxmhyHDLb2YzsbKItiHcbiMWUH8ZL8cEp5XuwcgisKagnHrgNkNaL+m9Xr1pm
         CDurdId5DGkiv7bD1dIyopcBQbPFIidCk/niev3u+pNj/sYfHJWnQ8JfNC56D8F3pur3
         Ady6kADz6C8QvfXEodby1FUywC2+t2Nfm2tUF50upUoedB6/fL1Mx4Gcm3OQLtpDuqMQ
         fH/+DRmPKhR0myePEHKGq2EO2+nLp+iEYCI/XRuvVopDz7bPLlsiQMYKkr9B7pJB6xCM
         BeEB12P/oUJUKKCipRd2geMiEMZkDTO3b2/oOvxyw8Cm7YN5EFyRC+qr47NxwvO+TUXC
         PQ0Q==
X-Gm-Message-State: AOAM533XuMO1+t2PI5MXeppH2aHgGBBHn/Mix+6kFl8IxvWdF+khHbbh
        Rx6c1xwQIq+bciZEQRsKByI98pIKUdxY2idFXo+Smf0fw9Vq
X-Google-Smtp-Source: ABdhPJxRLwLRgnFdUfT5aRwInjv9Q6N05LgHNwf1utr7rzaw6YiUKz8+e1THu35ngdTY2XLsKkVxVrcUy7xIUJ5NgBcyCI8nNUGD
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1c2f:: with SMTP id m15mr9296065ilh.206.1642377924688;
 Sun, 16 Jan 2022 16:05:24 -0800 (PST)
Date:   Sun, 16 Jan 2022 16:05:24 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c9c00e05d5bbe887@google.com>
Subject: [syzbot] WARNING in __cleanup_sighand
From:   syzbot <syzbot+985a662ba46639a7897f@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, andrii@kernel.org, ast@kernel.org,
        axboe@kernel.dk, bpf@vger.kernel.org, christian@brauner.io,
        daniel@iogearbox.net, david@redhat.com, ebiederm@xmission.com,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        legion@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, peterz@infradead.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    79e06c4c4950 Merge tag 'for-linus' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1285ed28700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=afd3ce8cd5cf174b
dashboard link: https://syzkaller.appspot.com/bug?extid=985a662ba46639a7897f
compiler:       Debian clang version 11.0.1-2, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+985a662ba46639a7897f@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 3640 at kernel/sched/wait.c:245 __wake_up_pollfree+0x1c7/0x1d0 kernel/sched/wait.c:246
Modules linked in:
CPU: 0 PID: 3640 Comm: syz-executor.3 Not tainted 5.16.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__wake_up_pollfree+0x1c7/0x1d0 kernel/sched/wait.c:245
Code: 0d 00 00 c6 44 08 0f 00 65 48 8b 04 25 28 00 00 00 48 3b 84 24 a0 00 00 00 75 13 48 8d 65 d8 5b 41 5c 41 5d 41 5e 41 5f 5d c3 <0f> 0b eb a7 e8 60 3e b0 08 55 41 57 41 56 41 55 41 54 53 48 83 ec
RSP: 0018:ffffc900028cf760 EFLAGS: 00010097
RAX: ffff88801ec1b130 RBX: 0000000000000046 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: 0000000000000004 RDI: 0000000000000001
RBP: ffffc900028cf848 R08: dffffc0000000000 R09: ffffed100850025a
R10: ffffed100850025a R11: 0000000000000000 R12: 0000000000000000
R13: ffffc900028cf7a0 R14: 1ffff92000519ef4 R15: ffff888042801308
FS:  0000555556549400(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fed83b131b8 CR3: 000000004a82a000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 000000000000802e DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __cleanup_sighand+0x48/0xa0 kernel/fork.c:1590
 __exit_signal kernel/exit.c:159 [inline]
 release_task+0x115f/0x15d0 kernel/exit.c:200
 wait_task_zombie kernel/exit.c:1114 [inline]
 wait_consider_task+0x1995/0x2fb0 kernel/exit.c:1341
 do_wait_thread kernel/exit.c:1404 [inline]
 do_wait+0x291/0x9d0 kernel/exit.c:1521
 kernel_wait4+0x2a3/0x3c0 kernel/exit.c:1684
 __do_sys_wait4 kernel/exit.c:1712 [inline]
 __se_sys_wait4 kernel/exit.c:1708 [inline]
 __x64_sys_wait4+0x130/0x1e0 kernel/exit.c:1708
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x44/0xd0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f2aff29e487
Code: 89 7c 24 10 48 89 4c 24 18 e8 35 50 02 00 4c 8b 54 24 18 8b 54 24 14 41 89 c0 48 8b 74 24 08 8b 7c 24 10 b8 3d 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 31 44 89 c7 89 44 24 10 e8 65 50 02 00 8b 44
RSP: 002b:00007ffeabee34f0 EFLAGS: 00000293 ORIG_RAX: 000000000000003d
RAX: ffffffffffffffda RBX: 0000000000000932 RCX: 00007f2aff29e487
RDX: 0000000040000001 RSI: 00007ffeabee357c RDI: 00000000ffffffff
RBP: 00007ffeabee357c R08: 0000000000000000 R09: 0000000000000010
R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000000032
R13: 00000000000af2e3 R14: 0000000000000009 R15: 00007ffeabee35e0
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
