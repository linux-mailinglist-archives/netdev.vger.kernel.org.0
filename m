Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC00029D768
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 23:24:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732815AbgJ1WYE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:24:04 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:45608 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732768AbgJ1WYA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 18:24:00 -0400
Received: by mail-io1-f69.google.com with SMTP id q3so611305iow.12
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 15:23:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=XCSAEIF7yxudBBUUr3qUjTib7D5OltngZoG8wvpMOQI=;
        b=Yhwx6srCTYRHI0zUCyug8Y93L4lwHC4D82bT6A8dnUxmdSh3n48n6eSMppZBmozkno
         k92ZLhL07xiN5tfQqsQDm+NBZhfpLvyF7/rTiR3/pS1Xm0uuMeNH/b9EJyheoXScltsx
         D1kdG/wfd32Jsg1FL9YGm+/MSeoOXqtcuCHIfqYoFbIwl2PkSsyaojzNHiQiDXMzaByN
         X2X/4TEtFOw2rIR06QkYK2y+QgxQ5tT1ajwBIIVA5I/JfCOcO2Qcr4JBaX6xCMjRj9Za
         e42wmKDJrGDXVSbHwj9kARaUZi4qM0Co/7XA80zXzT0mqV9K+R5U/L19hL2iXCjoCeRi
         feHg==
X-Gm-Message-State: AOAM533NDVFqRaNVi0MYMBxHWtFK4bpHfhzIRjI4bM1qrZPGR1WB8G+G
        7KXxv0XLRfoMe+u2X0iJPmceORvikPSO2Y1G1HXUsQ6jNC5m
X-Google-Smtp-Source: ABdhPJzl37aBwYIDKept4UZfHp9QtamUc+1RORwkGP8e3BHgiENeCyDaGrdCvVxp9qvnK94gNCfZZZnYqc+M4UYPzQ7LeWwLnF2x
MIME-Version: 1.0
X-Received: by 2002:a92:98c5:: with SMTP id a66mr6545587ill.50.1603902742690;
 Wed, 28 Oct 2020 09:32:22 -0700 (PDT)
Date:   Wed, 28 Oct 2020 09:32:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003b856d05b2bdb5f7@google.com>
Subject: general protection fault in wext_handle_ioctl
From:   syzbot <syzbot+8b2a88a09653d4084179@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    8c2ab803 Merge tag 'orphan-handling-v5.10-rc2' of git://gi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12e57870500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3140f5be49a06bf9
dashboard link: https://syzkaller.appspot.com/bug?extid=8b2a88a09653d4084179
compiler:       clang version 11.0.0 (https://github.com/llvm/llvm-project.git ca2dcbd030eadbf0aa9b660efe864ff08af6e18b)

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8b2a88a09653d4084179@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 1 PID: 10716 Comm: syz-executor.0 Not tainted 5.10.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:call_commit_handler net/wireless/wext-core.c:900 [inline]
RIP: 0010:ioctl_standard_call net/wireless/wext-core.c:1029 [inline]
RIP: 0010:wireless_process_ioctl net/wireless/wext-core.c:954 [inline]
RIP: 0010:wext_ioctl_dispatch net/wireless/wext-core.c:987 [inline]
RIP: 0010:wext_handle_ioctl+0x974/0xb20 net/wireless/wext-core.c:1048
Code: e8 a1 87 a3 f8 eb 6c 48 8b 44 24 18 42 80 3c 20 00 48 8b 5c 24 20 74 08 48 89 df e8 d6 78 e5 f8 48 8b 1b 48 89 d8 48 c1 e8 03 <42> 80 3c 20 00 74 08 48 89 df e8 bd 78 e5 f8 48 8b 1b 48 89 d8 48
RSP: 0018:ffffc900018afe00 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffffff88d17b88
RDX: ffff88801a3ccec0 RSI: 0000000000000001 RDI: 0000000000000000
RBP: ffff88802b398000 R08: ffffffff88d17baf R09: ffffed1005673009
R10: ffffed1005673009 R11: 0000000000000000 R12: dffffc0000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000008b04
FS:  00007f0710ce1700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b2ce26000 CR3: 000000001efa8000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 sock_ioctl+0xdc/0x690 net/socket.c:1119
 vfs_ioctl fs/ioctl.c:48 [inline]
 __do_sys_ioctl fs/ioctl.c:753 [inline]
 __se_sys_ioctl+0xfb/0x170 fs/ioctl.c:739
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45de49
Code: 0d b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b3 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f0710ce0c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000013440 RCX: 000000000045de49
RDX: 00000000200000c0 RSI: 0000000000008b04 RDI: 0000000000000003
RBP: 000000000118bf60 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000118bf2c
R13: 00007fff190b875f R14: 00007f0710ce19c0 R15: 000000000118bf2c
Modules linked in:
---[ end trace 82d7ada5671b3a90 ]---
RIP: 0010:call_commit_handler net/wireless/wext-core.c:900 [inline]
RIP: 0010:ioctl_standard_call net/wireless/wext-core.c:1029 [inline]
RIP: 0010:wireless_process_ioctl net/wireless/wext-core.c:954 [inline]
RIP: 0010:wext_ioctl_dispatch net/wireless/wext-core.c:987 [inline]
RIP: 0010:wext_handle_ioctl+0x974/0xb20 net/wireless/wext-core.c:1048
Code: e8 a1 87 a3 f8 eb 6c 48 8b 44 24 18 42 80 3c 20 00 48 8b 5c 24 20 74 08 48 89 df e8 d6 78 e5 f8 48 8b 1b 48 89 d8 48 c1 e8 03 <42> 80 3c 20 00 74 08 48 89 df e8 bd 78 e5 f8 48 8b 1b 48 89 d8 48
RSP: 0018:ffffc900018afe00 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffffff88d17b88
RDX: ffff88801a3ccec0 RSI: 0000000000000001 RDI: 0000000000000000
RBP: ffff88802b398000 R08: ffffffff88d17baf R09: ffffed1005673009
R10: ffffed1005673009 R11: 0000000000000000 R12: dffffc0000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000008b04
FS:  00007f0710ce1700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f04025f6000 CR3: 000000001efa8000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
