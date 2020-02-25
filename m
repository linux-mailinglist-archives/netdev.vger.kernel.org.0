Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0E7D16BB84
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 09:08:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729674AbgBYIIP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 03:08:15 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:34659 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729111AbgBYIIO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 03:08:14 -0500
Received: by mail-io1-f70.google.com with SMTP id n26so19758656ioj.1
        for <netdev@vger.kernel.org>; Tue, 25 Feb 2020 00:08:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=oBN7oAkwhJVbDOrp7SHliafS7zMYsi6zrfd5xebUUMY=;
        b=Qq2kgfcclnXwjQMuUTvkhhoJWFjCCodgLrqlbo8L9nO3ixwEU28a+lv+wBnoe5bomu
         sVh9pLz04/oAykF6Bc8TM59DyFmdtPFsR+4RzIlk6zmPxdZ0JNoRrlor15cpoonwy+Tg
         j2gZ5d7ZpE/BXPlHsknJz7r3jXPanWpipWiEbp5VTdmJp/2KBmrSEXEmuVGft9q2a5p2
         Fhh/whtbv8P9Vf0xAt5f5vet3RBL7+tJ1529xq81mQyq5eYhkHN5b4uZWlFmyukR2NZa
         7ar4mFWnev2awNEfn199KKKBlMzmC9Yv72TuRJHiozxGsdifb9iK0hxF5uZbtkayMi14
         94kQ==
X-Gm-Message-State: APjAAAXrYs2QyzXgCV2+LnFeom4fXpCKxo2+/dk2bfmHQ6e9/3AWZGRH
        hvXFWGjRd62ornXIeGaI9H+tZ2JtuSdRl4Z9ATllbMJa/9iW
X-Google-Smtp-Source: APXvYqwVT2913CZ9DmaHsTWnMfMyzl+yPM99L45ZuUJFLfuF0xfQmiUugmqk4q+DNzUnn8LFfOxEA/PPyut8NcjwQmAU2MZZLYbD
MIME-Version: 1.0
X-Received: by 2002:a5e:8e4d:: with SMTP id r13mr50829768ioo.60.1582618094122;
 Tue, 25 Feb 2020 00:08:14 -0800 (PST)
Date:   Tue, 25 Feb 2020 00:08:14 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000050bd7c059f61fd8c@google.com>
Subject: BUG: unable to handle kernel NULL pointer dereference in inet_release
From:   syzbot <syzbot+1938db17e275e85dc328@syzkaller.appspotmail.com>
To:     andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, kafai@fb.com,
        kuba@kernel.org, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    54dedb5b Merge tag 'for-linus-5.6-rc3-tag' of git://git.ke..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=168f7de9e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3e57a6b450fb9883
dashboard link: https://syzkaller.appspot.com/bug?extid=1938db17e275e85dc328
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1681fe09e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+1938db17e275e85dc328@syzkaller.appspotmail.com

BUG: kernel NULL pointer dereference, address: 0000000000000000
#PF: supervisor instruction fetch in kernel mode
#PF: error_code(0x0010) - not-present page
PGD a0113067 P4D a0113067 PUD a8771067 PMD 0 
Oops: 0010 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 10686 Comm: syz-executor.0 Not tainted 5.6.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:0x0
Code: Bad RIP value.
RSP: 0018:ffffc9000281fce0 EFLAGS: 00010246
RAX: 1ffffffff15f48ac RBX: ffffffff8afa4560 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8880a69a8f40
RBP: ffffc9000281fd10 R08: ffffffff86ed9b0c R09: ffffed1014d351f5
R10: ffffed1014d351f5 R11: 0000000000000000 R12: ffff8880920d3098
R13: 1ffff1101241a613 R14: ffff8880a69a8f40 R15: 0000000000000000
FS:  00007f2ae75db700(0000) GS:ffff8880aea00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffffffffd6 CR3: 00000000a3b85000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 inet_release+0x165/0x1c0 net/ipv4/af_inet.c:427
 __sock_release net/socket.c:605 [inline]
 sock_close+0xe1/0x260 net/socket.c:1283
 __fput+0x2e4/0x740 fs/file_table.c:280
 ____fput+0x15/0x20 fs/file_table.c:313
 task_work_run+0x176/0x1b0 kernel/task_work.c:113
 tracehook_notify_resume include/linux/tracehook.h:188 [inline]
 exit_to_usermode_loop arch/x86/entry/common.c:164 [inline]
 prepare_exit_to_usermode+0x480/0x5b0 arch/x86/entry/common.c:195
 syscall_return_slowpath+0x113/0x4a0 arch/x86/entry/common.c:278
 do_syscall_64+0x11f/0x1c0 arch/x86/entry/common.c:304
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x45c429
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f2ae75dac78 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
RAX: 0000000000000000 RBX: 00007f2ae75db6d4 RCX: 000000000045c429
RDX: 0000000000000001 RSI: 000000000000011a RDI: 0000000000000004
RBP: 000000000076bf20 R08: 0000000000000038 R09: 0000000000000000
R10: 0000000020000180 R11: 0000000000000246 R12: 00000000ffffffff
R13: 0000000000000a9d R14: 00000000004ccfb4 R15: 000000000076bf2c
Modules linked in:
CR2: 0000000000000000
---[ end trace 82567b5207e87bae ]---
RIP: 0010:0x0
Code: Bad RIP value.
RSP: 0018:ffffc9000281fce0 EFLAGS: 00010246
RAX: 1ffffffff15f48ac RBX: ffffffff8afa4560 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8880a69a8f40
RBP: ffffc9000281fd10 R08: ffffffff86ed9b0c R09: ffffed1014d351f5
R10: ffffed1014d351f5 R11: 0000000000000000 R12: ffff8880920d3098
R13: 1ffff1101241a613 R14: ffff8880a69a8f40 R15: 0000000000000000
FS:  00007f2ae75db700(0000) GS:ffff8880aea00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffffffffd6 CR3: 00000000a3b85000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
