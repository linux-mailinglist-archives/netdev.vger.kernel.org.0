Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 270242141F2
	for <lists+netdev@lfdr.de>; Sat,  4 Jul 2020 01:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbgGCXbY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 19:31:24 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:34903 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726760AbgGCXbX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 19:31:23 -0400
Received: by mail-il1-f199.google.com with SMTP id v12so1795604ilg.2
        for <netdev@vger.kernel.org>; Fri, 03 Jul 2020 16:31:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=H0iGMpy4exjQVL4rDbP48TGrJhUE2zdneUofNpOKNJo=;
        b=k8rH4DDYzuWCNQew3CR/fFpqgVEbj/TmS3NEpQfIrMz00QJbCPf+5Cjjevui1ALYAG
         wtS0uKUYMnIOqN8hzQTfQLu7emXd53BzRcl7T1K3gnf0xQ5TXlYracCudcGJGJGv5mbe
         bnhlXXP78PXThrIyEpmCrSnrCn70sIopOnTfHEf4C+udxKf+Yf/I+8AaXBhnyIz3DrAs
         JwY9MQ+FA7qi1dz++dmrZruTDKEmwHSEmCgQnysATmC+gvyNtlkLR5Ec/QTqTchISwTq
         Qv01KBlCNJjbf131S7AYK2vqNyI+szyr+dLDuDFoHlaNr01DYpe6gsord5Z6O3sq8kMG
         3kuQ==
X-Gm-Message-State: AOAM533+wThtr9DDN+8p1OaNLykl3TR41YMcHre2LQ3+jpeOz/vNUTrE
        a8evJfuMrAWmik4rgJEcRLEsmwAMfk+6KbNJKBP1Vj4N0N5b
X-Google-Smtp-Source: ABdhPJwgp0BiqIyuN6PjAHbTrpNVwKpT0IHdyDfLXfIrqnoHWXq5bT1Z3SZQTUTpFNsrg+dyNeHgiiehR2y/e/mITjWfO/hJ7OkG
MIME-Version: 1.0
X-Received: by 2002:a92:c7c3:: with SMTP id g3mr20035625ilk.164.1593819082292;
 Fri, 03 Jul 2020 16:31:22 -0700 (PDT)
Date:   Fri, 03 Jul 2020 16:31:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003c861205a991ec2c@google.com>
Subject: kernel BUG at net/rxrpc/recvmsg.c:LINE!
From:   syzbot <syzbot+b54969381df354936d96@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dhowells@redhat.com, kuba@kernel.org,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    aab20039 Add linux-next specific files for 20200701
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=17a00a5b100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=739f6fbf326049f4
dashboard link: https://syzkaller.appspot.com/bug?extid=b54969381df354936d96
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17ee0fe5100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12ea774b100000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+b54969381df354936d96@syzkaller.appspotmail.com

------------[ cut here ]------------
kernel BUG at net/rxrpc/recvmsg.c:605!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 6856 Comm: syz-executor134 Not tainted 5.8.0-rc3-next-20200701-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:rxrpc_recvmsg+0x18ab/0x1a03 net/rxrpc/recvmsg.c:605
Code: 89 e7 e8 58 39 6b fa e9 eb fc ff ff e8 4e 39 6b fa e9 33 ef ff ff 48 8b 7c 24 10 e8 3f 39 6b fa e9 dc ee ff ff e8 35 a4 2b fa <0f> 0b 48 8b 7c 24 10 e8 29 39 6b fa e9 76 ee ff ff 48 89 ef e8 0c
RSP: 0018:ffffc90001637858 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffff8880a182c278 RCX: ffffffff874835d7
RDX: ffff888096f4c000 RSI: ffffffff8748473b RDI: 0000000000000001
RBP: ffff888096ffe740 R08: 0000000000000000 R09: ffff8880a182c327
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
R13: ffff8880a182c080 R14: 0000000000000000 R15: ffff8880a182c320
FS:  00007f23bbcf5700(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000006da0f0 CR3: 000000009ec2f000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 sock_recvmsg_nosec net/socket.c:886 [inline]
 sock_recvmsg net/socket.c:904 [inline]
 sock_recvmsg net/socket.c:900 [inline]
 ____sys_recvmsg+0x2c4/0x640 net/socket.c:2575
 ___sys_recvmsg+0x127/0x200 net/socket.c:2617
 do_recvmmsg+0x24d/0x6d0 net/socket.c:2715
 __sys_recvmmsg net/socket.c:2794 [inline]
 __do_sys_recvmmsg net/socket.c:2817 [inline]
 __se_sys_recvmmsg net/socket.c:2810 [inline]
 __x64_sys_recvmmsg+0x20b/0x260 net/socket.c:2810
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:359
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x446899
Code: Bad RIP value.
RSP: 002b:00007f23bbcf4d98 EFLAGS: 00000246 ORIG_RAX: 000000000000012b
RAX: ffffffffffffffda RBX: 00000000006dbc38 RCX: 0000000000446899
RDX: 0000000000000001 RSI: 0000000020000100 RDI: 0000000000000003
RBP: 00000000006dbc30 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000006dbc3c
R13: 0000000000000007 R14: 0000000100000110 R15: 0000000000000018
Modules linked in:
---[ end trace abf499f6a2f7b5ae ]---
RIP: 0010:rxrpc_recvmsg+0x18ab/0x1a03 net/rxrpc/recvmsg.c:605
Code: 89 e7 e8 58 39 6b fa e9 eb fc ff ff e8 4e 39 6b fa e9 33 ef ff ff 48 8b 7c 24 10 e8 3f 39 6b fa e9 dc ee ff ff e8 35 a4 2b fa <0f> 0b 48 8b 7c 24 10 e8 29 39 6b fa e9 76 ee ff ff 48 89 ef e8 0c
RSP: 0018:ffffc90001637858 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffff8880a182c278 RCX: ffffffff874835d7
RDX: ffff888096f4c000 RSI: ffffffff8748473b RDI: 0000000000000001
RBP: ffff888096ffe740 R08: 0000000000000000 R09: ffff8880a182c327
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
R13: ffff8880a182c080 R14: 0000000000000000 R15: ffff8880a182c320
FS:  00007f23bbcf5700(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000006da0f0 CR3: 000000009ec2f000 CR4: 00000000001506f0
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
