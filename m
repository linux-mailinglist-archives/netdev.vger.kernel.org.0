Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34F3D49475D
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 07:37:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237233AbiATGhS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 01:37:18 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:37883 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237313AbiATGhR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 01:37:17 -0500
Received: by mail-io1-f72.google.com with SMTP id a10-20020a6b6d0a000000b0060a6d881105so3287546iod.4
        for <netdev@vger.kernel.org>; Wed, 19 Jan 2022 22:37:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=UEInTtfNisGGLNBrKhERkfyR+uWPZmiP7HXeUQKkbQ0=;
        b=kBqOvxs7mI2cuvYi89Y6sDDvupmkDFvqktm4giY8XOVzMfnEoSkeXBXA/nkEgLtfGs
         Osj0aqWHE0ICren0/fqMh9d377HqYl56zuvn7XLLp2RvvaTKvv/0bVUNr5nOvDjUZxfS
         urMo0S7zMxWtC5OhtZskE8vk/GRc8e4eGdkmeoQpw1ZlOOWeSE09sKxYADZ8Dh/XQqt5
         xLPiBQRLnnjWqGYHTPq8Z7Khq6B+rSb2sV5bw72h5ASz6Nd3hmtXlLgHskybEfzVw3wg
         5YyN/0KoEIkcwdzBCMhVgoXc0Kt3OCBHW+ZkHVcfEewQSNuruzKDN6p+3cZ8Clioolk0
         ujXg==
X-Gm-Message-State: AOAM531s+IBm+mC/qfdvcciEvc3XHE82eovEnNm7+ZiBc4x8lshPYELf
        7XOfHnvbeZKbBtVo4HExGqj9fx9vwOGUGGZ9QGJDOFIZ8zax
X-Google-Smtp-Source: ABdhPJzbIfYwA0lep5uvW+KigMItbjJh86sBnRCq6/clwau6EN1n4eZnnJW6KSuQWyt27PspVZETMqT9DmXLcs5Nnoi5p+DjJnsH
MIME-Version: 1.0
X-Received: by 2002:a02:62c2:: with SMTP id d185mr15523435jac.76.1642660636945;
 Wed, 19 Jan 2022 22:37:16 -0800 (PST)
Date:   Wed, 19 Jan 2022 22:37:16 -0800
In-Reply-To: <000000000000c9c00e05d5bbe887@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c077c605d5fdbb29@google.com>
Subject: Re: [syzbot] WARNING in __cleanup_sighand
From:   syzbot <syzbot+985a662ba46639a7897f@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, andrii@kernel.org, ast@kernel.org,
        axboe@kernel.dk, bpf@vger.kernel.org, christian@brauner.io,
        daniel@iogearbox.net, david@redhat.com, ebiederm@xmission.com,
        ebiggers@kernel.org, john.fastabend@gmail.com, kafai@fb.com,
        kpsingh@kernel.org, legion@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        peterz@infradead.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    1d1df41c5a33 Merge tag 'f2fs-for-5.17-rc1' of git://git.ke..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=135e0637b00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a8db61f521ec3155
dashboard link: https://syzkaller.appspot.com/bug?extid=985a662ba46639a7897f
compiler:       Debian clang version 11.0.1-2, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13381237b00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15160867b00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+985a662ba46639a7897f@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 3600 at kernel/sched/wait.c:245 __wake_up_pollfree+0x1c7/0x1d0 kernel/sched/wait.c:246
Modules linked in:
CPU: 1 PID: 3600 Comm: syz-executor582 Not tainted 5.16.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__wake_up_pollfree+0x1c7/0x1d0 kernel/sched/wait.c:245
Code: 0d 00 00 c6 44 08 0f 00 65 48 8b 04 25 28 00 00 00 48 3b 84 24 a0 00 00 00 75 13 48 8d 65 d8 5b 41 5c 41 5d 41 5e 41 5f 5d c3 <0f> 0b eb a7 e8 f0 89 b1 08 55 41 57 41 56 41 55 41 54 53 48 83 ec
RSP: 0018:ffffc90001aaf760 EFLAGS: 00010016
RAX: ffff8880787693f0 RBX: 0000000000000046 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: 0000000000000004 RDI: 0000000000000001
RBP: ffffc90001aaf848 R08: dffffc0000000000 R09: ffffed10046325d2
R10: ffffed10046325d2 R11: 0000000000000000 R12: 0000000000000000
R13: ffffc90001aaf7a0 R14: 1ffff92000355ef4 R15: ffff888023192ec8
FS:  000055555695d300(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000200000c0 CR3: 000000002374c000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __cleanup_sighand+0x48/0xa0 kernel/fork.c:1588
 __exit_signal kernel/exit.c:159 [inline]
 release_task+0x115f/0x15d0 kernel/exit.c:200
 wait_task_zombie kernel/exit.c:1121 [inline]
 wait_consider_task+0x1995/0x3020 kernel/exit.c:1348
 do_wait_thread kernel/exit.c:1411 [inline]
 do_wait+0x291/0x9d0 kernel/exit.c:1528
 kernel_wait4+0x2a3/0x3c0 kernel/exit.c:1691
 __do_sys_wait4 kernel/exit.c:1719 [inline]
 __se_sys_wait4 kernel/exit.c:1715 [inline]
 __x64_sys_wait4+0x130/0x1e0 kernel/exit.c:1715
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x44/0xd0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fb66a5bb386
Code: 0f 1f 40 00 31 c9 e9 09 00 00 00 66 0f 1f 84 00 00 00 00 00 49 89 ca 64 8b 04 25 18 00 00 00 85 c0 75 11 b8 3d 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 5a c3 90 48 83 ec 28 89 54 24 14 48 89 74 24
RSP: 002b:00007ffe9339ed58 EFLAGS: 00000246 ORIG_RAX: 000000000000003d
RAX: ffffffffffffffda RBX: 000000000000ce97 RCX: 00007fb66a5bb386
RDX: 0000000040000001 RSI: 00007ffe9339ed74 RDI: 00000000ffffffff
RBP: 0000000000001284 R08: 00007ffe933e2080 R09: 0000000000000010
R10: 0000000000000000 R11: 0000000000000246 R12: 431bde82d7b634db
R13: 00007ffe9339ed74 R14: 0000000000000000 R15: 0000000000000000
 </TASK>

