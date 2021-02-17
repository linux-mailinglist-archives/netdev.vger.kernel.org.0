Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19A5931DE31
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 18:33:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232196AbhBQRbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 12:31:09 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:49558 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231483AbhBQRbD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 12:31:03 -0500
Received: by mail-io1-f71.google.com with SMTP id u24so3849190ioc.16
        for <netdev@vger.kernel.org>; Wed, 17 Feb 2021 09:30:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=W7PZMoQ6/2ZuncEHOYXVO/E5fVdcQhSl2dwt9WT7asE=;
        b=DnAjpN7I8nZXN7eNE1gGhpvWzGq75BAQSeIQiROFrHpdQ0L9Xb2pCJnRxzZM65O5rD
         dBIJtpG7lTXfVeF3M2+kcovQSV4/G5tLrMG81no/7DtGKJdS/iGLhYvZSwyUXvTWKwe3
         +WKeTkDyMIt6qTggjNdWTlfgh+RAX+LcjY3Hj+u3+qUe8KLldZi78ufKWz08Q4CW1ZPI
         5N5cskPIbac4UNR+orwlDMjmP3MRWdxN6Ay0+rMvTL8FNp2zf9d/kBEz7Z5cWIK8Ohay
         RB9TnxjrYarEHJDqVF3FMe0dIXqSqoJeEguXm1p7HCUzXbHYxHzWOWCrsHBqCKM4UNfW
         CfHg==
X-Gm-Message-State: AOAM532njpNdx60VLpLUOo6acm+jgvybxp0Yfd455mWBOnYrzCND2Gyk
        rrqXh2An20n5XBIqRDMami1jzHutATPvptuLgTXdfA2lUZZK
X-Google-Smtp-Source: ABdhPJynh6K4gj10z49orQ6DtNdBbnCCeOmfa43dNXzkStpp20ndApto9zr330a3hQKBZBOzGQJjkcZqoQt9s9wKIG4xn1BdvUAc
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:152c:: with SMTP id i12mr145560ilu.46.1613583022725;
 Wed, 17 Feb 2021 09:30:22 -0800 (PST)
Date:   Wed, 17 Feb 2021 09:30:22 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e29ec405bb8b9251@google.com>
Subject: general protection fault in mptcp_sendmsg_frag
From:   syzbot <syzbot+409b0354a6ba83a86aaf@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        mptcp@lists.01.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    773dc50d Merge branch 'Xilinx-axienet-updates'
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1744ba4cd00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=dbc1ca9e55dc1f9f
dashboard link: https://syzkaller.appspot.com/bug?extid=409b0354a6ba83a86aaf
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16548404d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=150c2914d00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+409b0354a6ba83a86aaf@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000007: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000038-0x000000000000003f]
CPU: 0 PID: 8763 Comm: syz-executor836 Not tainted 5.11.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:mptcp_sendmsg_frag+0xa3f/0x1220 net/mptcp/protocol.c:1330
Code: 80 3c 02 00 0f 85 04 07 00 00 48 8b 04 24 48 8b 98 20 07 00 00 48 b8 00 00 00 00 00 fc ff df 48 8d 7b 38 48 89 fa 48 c1 ea 03 <0f> b6 04 02 84 c0 74 08 3c 03 0f 8e d6 04 00 00 48 8d 7d 10 44 8b
RSP: 0018:ffffc90001dff7e8 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000007 RSI: 0000000000000000 RDI: 0000000000000038
RBP: ffff8880120d9e10 R08: 0000000000000001 R09: ffff8880120d9e10
R10: ffffed100241b3c4 R11: 0000000000000000 R12: ffff88801bf51800
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000008000
FS:  00007f0f56768700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000084 CR3: 000000001b547000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 mptcp_push_pending+0x2cc/0x650 net/mptcp/protocol.c:1477
 mptcp_sendmsg+0x1ffb/0x2830 net/mptcp/protocol.c:1692
 inet6_sendmsg+0x99/0xe0 net/ipv6/af_inet6.c:638
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 sock_write_iter+0x289/0x3c0 net/socket.c:999
 call_write_iter include/linux/fs.h:1901 [inline]
 new_sync_write+0x426/0x650 fs/read_write.c:518
 vfs_write+0x791/0xa30 fs/read_write.c:605
 ksys_write+0x1ee/0x250 fs/read_write.c:658
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x4492d9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 a1 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f0f56768318 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00000000004cf4c8 RCX: 00000000004492d9
RDX: 0000000000000001 RSI: 0000000020000000 RDI: 0000000000000003
RBP: 00000000004cf4c0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000004cf4cc
R13: 00007fff4b6baf0f R14: 00007f0f56768400 R15: 0000000000022000
Modules linked in:
---[ end trace a30ad1b3e9650ce6 ]---
RIP: 0010:mptcp_sendmsg_frag+0xa3f/0x1220 net/mptcp/protocol.c:1330
Code: 80 3c 02 00 0f 85 04 07 00 00 48 8b 04 24 48 8b 98 20 07 00 00 48 b8 00 00 00 00 00 fc ff df 48 8d 7b 38 48 89 fa 48 c1 ea 03 <0f> b6 04 02 84 c0 74 08 3c 03 0f 8e d6 04 00 00 48 8d 7d 10 44 8b
RSP: 0018:ffffc90001dff7e8 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000007 RSI: 0000000000000000 RDI: 0000000000000038
RBP: ffff8880120d9e10 R08: 0000000000000001 R09: ffff8880120d9e10
R10: ffffed100241b3c4 R11: 0000000000000000 R12: ffff88801bf51800
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000008000
FS:  00007f0f56768700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f97dbf78000 CR3: 000000001b547000 CR4: 00000000001506e0
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
