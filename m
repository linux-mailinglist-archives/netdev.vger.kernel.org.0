Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C091345E6CE
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 05:22:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346082AbhKZEZm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 23:25:42 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:51857 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357950AbhKZEXk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 23:23:40 -0500
Received: by mail-io1-f71.google.com with SMTP id s199-20020a6b2cd0000000b005ed3e776ad0so10328889ios.18
        for <netdev@vger.kernel.org>; Thu, 25 Nov 2021 20:20:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=iDo2YE1P0V4UvagSeNAWE7aLeLcYy2LwCFQUzfvdNwY=;
        b=BNnj72jxdPCNt/Den4izILkqdM+pc/gJoiNkWRHdAK1IP99ZAt2qjaritDI46jgpXN
         6u64tipXUDY4ibIDvFPveg3d6y1d0zlnyhJ7q4OlI6Y7om4wxxtXy6y6HDbke3aGYr+W
         DXtvN6loPVsRhdccwZSS0YrDgBUAvabiIA+kIcM0y2j8mLTP9JAHfSv0YjnP8MB8DC6u
         PByeeQzomcH8w0VEpM2QQa29eavSE7+nb+KNeMA2qpC4cVUdZ9KA5vlu9G0jS3HflLwo
         q5O+S8FjEg2Ua0RFb3vEYSMyQ0em9YzBZBSUyf6xeUZuB0ktm0F8VIu7A/5UsSBgNEnW
         aLIg==
X-Gm-Message-State: AOAM533CEzH8dZTbvL861Vc4gN8/fwvp82t/EyPGbmrhzyr3RAJw5fBt
        j4cti6AuLLxEc+l0P2Itm5qcGhX7H+H3Nqd83jdeu8YNb+xb
X-Google-Smtp-Source: ABdhPJw9B/j4yQX6juojIIaPZgm9fEGZAYOMyRAI6QZnmayGTvKfIbhoWkKCpg/7gH9IkHyaP9RyhMvgnJ7q1bFvWlGJTQFV9J+L
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:114f:: with SMTP id o15mr27695772ill.307.1637900428223;
 Thu, 25 Nov 2021 20:20:28 -0800 (PST)
Date:   Thu, 25 Nov 2021 20:20:28 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000033acbf05d1a969aa@google.com>
Subject: [syzbot] WARNING: kmalloc bug in bpf
From:   syzbot <syzbot+cecf5b7071a0dfb76530@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, hawk@kernel.org,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    e4f7ac90c2b0 selftests/bpf: Mix legacy (maps) and modern (..
git tree:       bpf-next
console output: https://syzkaller.appspot.com/x/log.txt?x=17418e09b00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a262045c4c15a9e0
dashboard link: https://syzkaller.appspot.com/bug?extid=cecf5b7071a0dfb76530
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+cecf5b7071a0dfb76530@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 372 at mm/util.c:597 kvmalloc_node+0x111/0x120 mm/util.c:597
Modules linked in:
CPU: 1 PID: 372 Comm: syz-executor.4 Not tainted 5.15.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:kvmalloc_node+0x111/0x120 mm/util.c:597
Code: 01 00 00 00 4c 89 e7 e8 7d f7 0c 00 49 89 c5 e9 69 ff ff ff e8 60 20 d1 ff 41 89 ed 41 81 cd 00 20 01 00 eb 95 e8 4f 20 d1 ff <0f> 0b e9 4c ff ff ff 0f 1f 84 00 00 00 00 00 55 48 89 fd 53 e8 36
RSP: 0018:ffffc90002bf7c98 EFLAGS: 00010216
RAX: 00000000000000ec RBX: 1ffff9200057ef9f RCX: ffffc9000ac63000
RDX: 0000000000040000 RSI: ffffffff81a6a621 RDI: 0000000000000003
RBP: 0000000000102cc0 R08: 000000007fffffff R09: 00000000ffffffff
R10: ffffffff81a6a5de R11: 0000000000000000 R12: 00000000ffff9aaa
R13: 0000000000000000 R14: 00000000ffffffff R15: 0000000000000000
FS:  00007f05f2573700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b2f424000 CR3: 0000000027d2c000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 kvmalloc include/linux/slab.h:741 [inline]
 map_lookup_elem kernel/bpf/syscall.c:1090 [inline]
 __sys_bpf+0x3a5b/0x5f00 kernel/bpf/syscall.c:4603
 __do_sys_bpf kernel/bpf/syscall.c:4722 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:4720 [inline]
 __x64_sys_bpf+0x75/0xb0 kernel/bpf/syscall.c:4720
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f05f4ffdae9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f05f2573188 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 00007f05f5110f60 RCX: 00007f05f4ffdae9
RDX: 0000000000000020 RSI: 0000000020000100 RDI: 0000000000000001
RBP: 00007f05f5057f6d R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fffa4b9a31f R14: 00007f05f2573300 R15: 0000000000022000
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
