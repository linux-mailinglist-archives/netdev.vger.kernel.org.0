Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 205983F3B25
	for <lists+netdev@lfdr.de>; Sat, 21 Aug 2021 17:19:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232215AbhHUPT7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Aug 2021 11:19:59 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:56951 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbhHUPT6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Aug 2021 11:19:58 -0400
Received: by mail-io1-f72.google.com with SMTP id c22-20020a5d9a960000b029059c9e04cd63so7177581iom.23
        for <netdev@vger.kernel.org>; Sat, 21 Aug 2021 08:19:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=MWvlGvJX3+lC+CEYrV+NJHyCqoKq7RyLbTXAsQO2CkQ=;
        b=kEiAnnLp9t4XLbgnfwBHxd2gTsHynwg31IApqH0n7gJxMv3IPfv1SQd+kY1oI1lVJj
         8d6vv4bWhPkyw0rRVlOZU0qB6TrKaXVbaRxM3YaDiuR6zVfisGMpwOwGh4QrsSAUvOtI
         J2N5M5Znueyn5j1fIhQ1FM3gkDKFdv6d7xiEpPRxiVbapm5sIHwv7beaGh7Lg7IYWSsz
         U1JdTiYKRsBEDUL4K5oFaqSYY2wOni6QjXhWhsAMsda6jY4cSa7hegL/U9j915QVlDs3
         vQco7j0cebpkqF7hnwkSng1vOPQ7oA4PIx9a3UXh9nU6oO6peQyW0uFZehYDxKc5ibI6
         FWiA==
X-Gm-Message-State: AOAM530Lc4q+Lr2GPJQGdfxBPeyHK+8P2pq/ubxyRFvPOjtaW1exW9CJ
        jMcil4WASKVgQc3YW9l4X1rG9Kk2gcCyBn9/D552zB7LPCAO
X-Google-Smtp-Source: ABdhPJwtfhWP2cfkdff8Z/zHnkfT0tZgwaUP5HKN+ka3i6qEb3FVDC/Z62GKMqghqbhutTFdaMU02QNNxsK63f/Qp3KIufdL9hPq
MIME-Version: 1.0
X-Received: by 2002:a92:6711:: with SMTP id b17mr17814117ilc.122.1629559158845;
 Sat, 21 Aug 2021 08:19:18 -0700 (PDT)
Date:   Sat, 21 Aug 2021 08:19:18 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000cdb89d05ca134e47@google.com>
Subject: [syzbot] BUG: unable to handle kernel NULL pointer dereference in unix_shutdown
From:   syzbot <syzbot+cd7ceee0d3b5892f07af@syzkaller.appspotmail.com>
To:     Rao.Shoaib@oracle.com, andrii@kernel.org, ast@kernel.org,
        bpf@vger.kernel.org, cong.wang@bytedance.com, daniel@iogearbox.net,
        davem@davemloft.net, john.fastabend@gmail.com, kafai@fb.com,
        kpsingh@kernel.org, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk,
        yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    9803fb968c8c Add linux-next specific files for 20210817
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1727c65e300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=681282daead30d81
dashboard link: https://syzkaller.appspot.com/bug?extid=cd7ceee0d3b5892f07af
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13fb6ff9300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15272861300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+cd7ceee0d3b5892f07af@syzkaller.appspotmail.com

BUG: kernel NULL pointer dereference, address: 0000000000000000
#PF: supervisor instruction fetch in kernel mode
#PF: error_code(0x0010) - not-present page
PGD 6f812067 P4D 6f812067 PUD 6fe2f067 PMD 0 
Oops: 0010 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 6569 Comm: syz-executor133 Not tainted 5.14.0-rc6-next-20210817-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:0x0
Code: Unable to access opcode bytes at RIP 0xffffffffffffffd6.
RSP: 0018:ffffc90002dcfe38 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: ffffffff8d27cfa0 RCX: 0000000000000000
RDX: 1ffffffff1a4fa0a RSI: ffffffff87d03085 RDI: ffff888077074d80
RBP: ffff888077074d80 R08: 0000000000000000 R09: 0000000000000001
R10: ffffffff87d03004 R11: 0000000000000001 R12: 0000000000000001
R13: ffff888077075398 R14: ffff888077075b58 R15: ffff888077074e00
FS:  0000000001747300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffffffffd6 CR3: 000000006f93f000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 unix_shutdown+0x28a/0x5b0 net/unix/af_unix.c:2857
 __sys_shutdown_sock net/socket.c:2242 [inline]
 __sys_shutdown_sock net/socket.c:2236 [inline]
 __sys_shutdown+0xf1/0x1b0 net/socket.c:2254
 __do_sys_shutdown net/socket.c:2262 [inline]
 __se_sys_shutdown net/socket.c:2260 [inline]
 __x64_sys_shutdown+0x50/0x70 net/socket.c:2260
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x43ee29
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffdc0b3c908 EFLAGS: 00000246 ORIG_RAX: 0000000000000030
RAX: ffffffffffffffda RBX: 0000000000400488 RCX: 000000000043ee29
RDX: 00000000004ac018 RSI: 0000000000000000 RDI: 0000000000000003
RBP: 0000000000402e10 R08: 0000000000000000 R09: 0000000000400488
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000402ea0
R13: 0000000000000000 R14: 00000000004ac018 R15: 0000000000400488
Modules linked in:
CR2: 0000000000000000
---[ end trace f541a02ac6ed69b5 ]---
RIP: 0010:0x0
Code: Unable to access opcode bytes at RIP 0xffffffffffffffd6.
RSP: 0018:ffffc90002dcfe38 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: ffffffff8d27cfa0 RCX: 0000000000000000
RDX: 1ffffffff1a4fa0a RSI: ffffffff87d03085 RDI: ffff888077074d80
RBP: ffff888077074d80 R08: 0000000000000000 R09: 0000000000000001
R10: ffffffff87d03004 R11: 0000000000000001 R12: 0000000000000001
R13: ffff888077075398 R14: ffff888077075b58 R15: ffff888077074e00
FS:  0000000001747300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffffffffd6 CR3: 000000006f93f000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	28 c3                	sub    %al,%bl
   2:	e8 2a 14 00 00       	callq  0x1431
   7:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
   e:	00 00 00 
  11:	48 89 f8             	mov    %rdi,%rax
  14:	48 89 f7             	mov    %rsi,%rdi
  17:	48 89 d6             	mov    %rdx,%rsi
  1a:	48 89 ca             	mov    %rcx,%rdx
  1d:	4d 89 c2             	mov    %r8,%r10
  20:	4d 89 c8             	mov    %r9,%r8
  23:	4c 8b 4c 24 08       	mov    0x8(%rsp),%r9
  28:	0f 05                	syscall 
  2a:	48 3d 01 f0 ff ff    	cmp    $0xfffffffffffff001,%rax <-- trapping instruction
  30:	73 01                	jae    0x33
  32:	c3                   	retq   
  33:	48 c7 c1 c0 ff ff ff 	mov    $0xffffffffffffffc0,%rcx
  3a:	f7 d8                	neg    %eax
  3c:	64 89 01             	mov    %eax,%fs:(%rcx)
  3f:	48                   	rex.W


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
