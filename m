Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17AAD46838C
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 10:20:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354643AbhLDJXs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 04:23:48 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:34332 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235337AbhLDJXr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Dec 2021 04:23:47 -0500
Received: by mail-il1-f197.google.com with SMTP id h10-20020a056e021b8a00b002a3f246adeaso382426ili.1
        for <netdev@vger.kernel.org>; Sat, 04 Dec 2021 01:20:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=TaC0QVPJsV+s3B4z6Sw+T+4Q19LiHEd6dzUgZmid5ak=;
        b=5tfrH4gd/qckZPkiPlsQf2gKeotxYinxFvnk05DvlPYwopFcFKP0gSUDb32VjE+TCZ
         6Syn9m0Jfc1Ow2tCwmbWkp3J4FpQ9toW0RQTLmN4UnuaOCc3+PF7UC9aKDpVO3+8/cZ+
         V1d9vntRzf5Qom1HWn6FMascTD649Ifxn7HIleoB6LHgLs5L3cliqOkngaG/QFnYu2an
         Y8auSa2+HFXYA2rwF/oW7HvHJSTkBdYGBlmw8mIeWXuWhzyysyxALgeIi15OCyK0aDle
         D0dAKToGmXZm8Nw0fDcT2SOne4wsQW8BPnsc3ath02hThRSiSA8fgFrL9oSERRQ0MQQO
         XJRQ==
X-Gm-Message-State: AOAM532UtEJoKtYRFo7ql2/eyk9V4F9lhmEthNqdl0gVEB0oQxbKHjOQ
        vrANKQoi34xdCkjbyCz879Bwi9328/ZbuosWiDw1vPy3ftT4
X-Google-Smtp-Source: ABdhPJzVVgqieeiqWo2ZBoiCyubc0oISNRRiz4ysr54Y02fEpywP0nVAIAP1YiGviCyzLm3aRMDADaVPNQ2jBwHDiS5UHWejdlx/
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2144:: with SMTP id d4mr25271653ilv.11.1638609618767;
 Sat, 04 Dec 2021 01:20:18 -0800 (PST)
Date:   Sat, 04 Dec 2021 01:20:18 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000040972505d24e88e3@google.com>
Subject: [syzbot] general protection fault in tls_init
From:   syzbot <syzbot+1fd9b69cde42967d1add@syzkaller.appspotmail.com>
To:     borisp@nvidia.com, daniel@iogearbox.net, davem@davemloft.net,
        john.fastabend@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    3498e7f2bb41 Merge tag '5.16-rc2-ksmbd-fixes' of git://git..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17e50a29b00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=33f08a46bc9aea3d
dashboard link: https://syzkaller.appspot.com/bug?extid=1fd9b69cde42967d1add
compiler:       Debian clang version 11.0.1-2, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+1fd9b69cde42967d1add@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000004: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000020-0x0000000000000027]
CPU: 1 PID: 1083 Comm: syz-executor.3 Not tainted 5.16.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:tls_build_proto net/tls/tls_main.c:776 [inline]
RIP: 0010:tls_init+0x44b/0x940 net/tls/tls_main.c:844
Code: 8d 9d 80 04 00 00 48 89 d8 48 c1 e8 03 42 80 3c 20 00 74 08 48 89 df e8 a3 15 fa f8 48 8b 1b 48 83 c3 20 48 89 d8 48 c1 e8 03 <42> 80 3c 20 00 74 08 48 89 df e8 86 15 fa f8 48 8b 1b ba e0 00 00
RSP: 0018:ffffc90018ba79e8 EFLAGS: 00010202
RAX: 0000000000000004 RBX: 0000000000000020 RCX: 0000000000000000
RDX: 00000000000001b8 RSI: ffffffff8dc8dad8 RDI: ffffffff91040ae0
RBP: ffffffff8dc8d920 R08: dffffc0000000000 R09: fffffbfff2208158
R10: 0000000000000004 R11: 0000000000000000 R12: dffffc0000000000
R13: ffff888077c9b300 R14: 1ffff1100ef93665 R15: ffff888077c9b328
FS:  00007f618497c700(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f5df59d8004 CR3: 00000000a43f0000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __tcp_set_ulp net/ipv4/tcp_ulp.c:139 [inline]
 tcp_set_ulp+0x428/0x4c0 net/ipv4/tcp_ulp.c:160
 do_tcp_setsockopt+0x455/0x37c0 net/ipv4/tcp.c:3391
 mptcp_setsockopt+0x1b47/0x2400 net/mptcp/sockopt.c:638
 __sys_setsockopt+0x552/0x980 net/socket.c:2176
 __do_sys_setsockopt net/socket.c:2187 [inline]
 __se_sys_setsockopt net/socket.c:2184 [inline]
 __x64_sys_setsockopt+0xb1/0xc0 net/socket.c:2184
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x44/0xd0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f6187427ae9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f618497c188 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 00007f618753b020 RCX: 00007f6187427ae9
RDX: 000000000000001f RSI: 0000000000000006 RDI: 0000000000000003
RBP: 00007f6187481f6d R08: 0000000000000004 R09: 0000000000000000
R10: 0000000020000100 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffe6784d25f R14: 00007f618497c300 R15: 0000000000022000
 </TASK>
Modules linked in:
---[ end trace db2630bf612a55f1 ]---
RIP: 0010:tls_build_proto net/tls/tls_main.c:776 [inline]
RIP: 0010:tls_init+0x44b/0x940 net/tls/tls_main.c:844
Code: 8d 9d 80 04 00 00 48 89 d8 48 c1 e8 03 42 80 3c 20 00 74 08 48 89 df e8 a3 15 fa f8 48 8b 1b 48 83 c3 20 48 89 d8 48 c1 e8 03 <42> 80 3c 20 00 74 08 48 89 df e8 86 15 fa f8 48 8b 1b ba e0 00 00
RSP: 0018:ffffc90018ba79e8 EFLAGS: 00010202
RAX: 0000000000000004 RBX: 0000000000000020 RCX: 0000000000000000
RDX: 00000000000001b8 RSI: ffffffff8dc8dad8 RDI: ffffffff91040ae0
RBP: ffffffff8dc8d920 R08: dffffc0000000000 R09: fffffbfff2208158
R10: 0000000000000004 R11: 0000000000000000 R12: dffffc0000000000
R13: ffff888077c9b300 R14: 1ffff1100ef93665 R15: ffff888077c9b328
FS:  00007f618497c700(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020001580 CR3: 00000000a43f0000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	8d 9d 80 04 00 00    	lea    0x480(%rbp),%ebx
   6:	48 89 d8             	mov    %rbx,%rax
   9:	48 c1 e8 03          	shr    $0x3,%rax
   d:	42 80 3c 20 00       	cmpb   $0x0,(%rax,%r12,1)
  12:	74 08                	je     0x1c
  14:	48 89 df             	mov    %rbx,%rdi
  17:	e8 a3 15 fa f8       	callq  0xf8fa15bf
  1c:	48 8b 1b             	mov    (%rbx),%rbx
  1f:	48 83 c3 20          	add    $0x20,%rbx
  23:	48 89 d8             	mov    %rbx,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	42 80 3c 20 00       	cmpb   $0x0,(%rax,%r12,1) <-- trapping instruction
  2f:	74 08                	je     0x39
  31:	48 89 df             	mov    %rbx,%rdi
  34:	e8 86 15 fa f8       	callq  0xf8fa15bf
  39:	48 8b 1b             	mov    (%rbx),%rbx
  3c:	ba                   	.byte 0xba
  3d:	e0 00                	loopne 0x3f


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
