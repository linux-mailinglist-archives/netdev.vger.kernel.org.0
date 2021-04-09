Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1593335A51D
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 19:58:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234484AbhDIR6c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 13:58:32 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:33417 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234383AbhDIR6c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 13:58:32 -0400
Received: by mail-il1-f198.google.com with SMTP id a2so3999008ilq.0
        for <netdev@vger.kernel.org>; Fri, 09 Apr 2021 10:58:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=zjuLShoOJ9Ne+PRJM/8fkmqQZG9THBny186JcJESo9Y=;
        b=jWAc+uUoC51is+nEqE5VgmLyBk/SK17ZHs6lYHOw0bCU3iCcx1M3M+vM2UdAoLqQwa
         FdGCJz6wzCxAqlMtvI8u/YGhuJwBzpVVtwLwCLXwLmorr8hUFvTBNrX5L/3RBBmtpUEN
         k/I9TG+iJsf2aqbKX4MLwbGU/rZ1yOhRVGQOZ7Qkbwjexe2MQXFxZNw7bzDeKUSpBdry
         4vaSggQKACoCdNdj1NswcqM7m4J5cRKU44OYbZOyJmLWOhv7SYTC5POwMxfFC42zMhEs
         vKuvcX83icSnPk6Llf03jJlsvtEp6DqmkG3edBToDKkqo0Mm8ZpJklmRoXsmv5XhPmk2
         U8Fw==
X-Gm-Message-State: AOAM532HXM7aUz2XrKO6cUbyiZ2+d4WpkhmrfFIpBc6qpGhnw+E69X/j
        lWzFxPqtUUejs7dXKBEZ9N69JVgpJZI4MUpqjjrv9OIFsab4
X-Google-Smtp-Source: ABdhPJxo4qUor1He6liaGw+24llwAaoVro/IETpD0iVMXKU5p4Bm/U61C3RbFafzPccSl3ESIT7jja4HRfP0mFJn+vOqADLHiE2T
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a47:: with SMTP id u7mr11962473ilv.65.1617991098898;
 Fri, 09 Apr 2021 10:58:18 -0700 (PDT)
Date:   Fri, 09 Apr 2021 10:58:18 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b31fe105bf8de885@google.com>
Subject: [syzbot] kernel BUG in llc_sap_action_send_xid_c
From:   syzbot <syzbot+5e5a981ad7cc54c4b2b4@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    864db232 net: ipv6: check for validity before dereferencin..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=16377d16d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=daeff30c2474a60f
dashboard link: https://syzkaller.appspot.com/bug?extid=5e5a981ad7cc54c4b2b4
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=154f8e9ad00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16fe2fbed00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5e5a981ad7cc54c4b2b4@syzkaller.appspotmail.com

skbuff: skb_over_panic: text:ffffffff8717de50 len:692 put:3 head:ffff888025f6f000 data:ffff888025f6f00e tail:0x2c2 end:0x2c0 dev:bond0
------------[ cut here ]------------
kernel BUG at net/core/skbuff.c:109!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 8372 Comm: syz-executor543 Not tainted 5.12.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:skb_panic+0x16c/0x16e net/core/skbuff.c:109
Code: f8 4c 8b 4c 24 10 8b 4b 70 41 56 45 89 e8 4c 89 e2 41 57 48 89 ee 48 c7 c7 40 b2 65 8a ff 74 24 10 ff 74 24 20 e8 e7 c0 c4 ff <0f> 0b e8 d2 e0 75 f8 4c 8b 64 24 18 e8 c8 87 b9 f8 48 c7 c1 80 be
RSP: 0018:ffffc9000132f7b8 EFLAGS: 00010282
RAX: 0000000000000086 RBX: ffff888012a91140 RCX: 0000000000000000
RDX: ffff888021d6d4c0 RSI: ffffffff815c4d75 RDI: fffff52000265ee9
RBP: ffffffff8a65bec0 R08: 0000000000000086 R09: 0000000000000000
R10: ffffffff815bdb0e R11: 0000000000000000 R12: ffffffff8717de50
R13: 0000000000000003 R14: ffff88801aa24000 R15: 00000000000002c0
FS:  0000000001d53300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055acdca69398 CR3: 0000000020a7b000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 skb_over_panic net/core/skbuff.c:114 [inline]
 skb_put.cold+0x24/0x24 net/core/skbuff.c:1914
 llc_pdu_init_as_xid_cmd include/net/llc_pdu.h:377 [inline]
 llc_sap_action_send_xid_c+0x240/0x380 net/llc/llc_s_ac.c:84
 llc_exec_sap_trans_actions net/llc/llc_sap.c:153 [inline]
 llc_sap_next_state net/llc/llc_sap.c:182 [inline]
 llc_sap_state_process+0x22a/0x4f0 net/llc/llc_sap.c:209
 llc_ui_sendmsg+0x9ee/0x1040 net/llc/af_llc.c:964
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:674
 ____sys_sendmsg+0x331/0x810 net/socket.c:2350
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2404
 __sys_sendmmsg+0x195/0x470 net/socket.c:2490
 __do_sys_sendmmsg net/socket.c:2519 [inline]
 __se_sys_sendmmsg net/socket.c:2516 [inline]
 __x64_sys_sendmmsg+0x99/0x100 net/socket.c:2516
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x43f329
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc10253fb8 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
RAX: ffffffffffffffda RBX: 0000000000400488 RCX: 000000000043f329
RDX: 0000000000000006 RSI: 0000000020005bc0 RDI: 0000000000000003
RBP: 0000000000403310 R08: 0000000000400488 R09: 0000000000400488
R10: 0000000004000000 R11: 0000000000000246 R12: 00000000004033a0
R13: 0000000000000000 R14: 00000000004ad018 R15: 0000000000400488
Modules linked in:
---[ end trace 4d95aeb9a24efeaa ]---
RIP: 0010:skb_panic+0x16c/0x16e net/core/skbuff.c:109
Code: f8 4c 8b 4c 24 10 8b 4b 70 41 56 45 89 e8 4c 89 e2 41 57 48 89 ee 48 c7 c7 40 b2 65 8a ff 74 24 10 ff 74 24 20 e8 e7 c0 c4 ff <0f> 0b e8 d2 e0 75 f8 4c 8b 64 24 18 e8 c8 87 b9 f8 48 c7 c1 80 be
RSP: 0018:ffffc9000132f7b8 EFLAGS: 00010282
RAX: 0000000000000086 RBX: ffff888012a91140 RCX: 0000000000000000
RDX: ffff888021d6d4c0 RSI: ffffffff815c4d75 RDI: fffff52000265ee9
RBP: ffffffff8a65bec0 R08: 0000000000000086 R09: 0000000000000000
R10: ffffffff815bdb0e R11: 0000000000000000 R12: ffffffff8717de50
R13: 0000000000000003 R14: ffff88801aa24000 R15: 00000000000002c0
FS:  0000000001d53300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055acdca69398 CR3: 0000000020a7b000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
