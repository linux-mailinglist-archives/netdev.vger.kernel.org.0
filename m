Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE319161FBB
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 05:07:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726403AbgBREHP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 23:07:15 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:42533 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726383AbgBREHP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 23:07:15 -0500
Received: by mail-io1-f72.google.com with SMTP id e7so13086441iog.9
        for <netdev@vger.kernel.org>; Mon, 17 Feb 2020 20:07:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=uHglhlTsZL9nYXC1SuW5n8zSraL5OSomR7EKPnnITWs=;
        b=lc86WA3Tb82KH1ZotXEXHBX79E7xa0Cn0sEMbujuuf7btDeVHny/Q9SFsBvoIs+LXO
         JTN+OY7CIAfP0NEWQ3AzsYRncKE/tg+4bj7l8PuH1RvoYLdjnPXGruFRRPnqsg1BS0r2
         hkg9XIDboRLaBx92zdyYgQepE3VoHTEhpMFXhWMDuKtzIAyjh6w6pRTGSfwRWCTrTVjE
         qSWHejvl/9oens/7iVw367T8jbTU39//vyNdB6TpcOffMCqivvgXM2LWcqBGGsRhWA6O
         TleKIUljmt9jJQSG7dxb4kjBCxuUSFiQFIb8q2e4F3RmHZlybAqLzkPira0Tq9H3F7xd
         gItw==
X-Gm-Message-State: APjAAAW2dSYgXtJaEi37+vkZa+0b1KJNJJSicWyxc2ZKFn8/OyJGHJM3
        mzxtykXELGyvMYfEJ8f3BFeMBCDCWZaLvera+3ndepl9+O4G
X-Google-Smtp-Source: APXvYqykvr5lZYYJzLA1G3jokmMLxLQMutu/6LzMIis/OPHm53DIYqPrXMQ1lTAZYZ7MZTpQKx8uB0HWAK4G5RctK5UqXjFwwjDg
MIME-Version: 1.0
X-Received: by 2002:a6b:d912:: with SMTP id r18mr13781201ioc.306.1581998832890;
 Mon, 17 Feb 2020 20:07:12 -0800 (PST)
Date:   Mon, 17 Feb 2020 20:07:12 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007838f1059ed1cea5@google.com>
Subject: general protection fault in l2cap_sock_getsockopt
From:   syzbot <syzbot+6446a589a5ca34dd6e8b@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    c25a951c Add linux-next specific files for 20200217
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=171b1a29e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c727d8fc485ff049
dashboard link: https://syzkaller.appspot.com/bug?extid=6446a589a5ca34dd6e8b
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10465579e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16dabb11e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+6446a589a5ca34dd6e8b@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 0 PID: 9844 Comm: syz-executor679 Not tainted 5.6.0-rc2-next-20200217-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:l2cap_sock_getsockopt+0x7d3/0x1200 net/bluetooth/l2cap_sock.c:613
Code: 00 00 00 00 00 fc ff df 48 c1 ea 03 80 3c 02 00 0f 85 a0 09 00 00 48 b8 00 00 00 00 00 fc ff df 49 8b 1f 48 89 da 48 c1 ea 03 <80> 3c 02 00 0f 85 75 09 00 00 48 8b 3b e8 cb be f6 ff be 67 02 00
RSP: 0018:ffffc900062f7d20 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff87253e8c
RDX: 0000000000000000 RSI: ffffffff87253f44 RDI: 0000000000000001
RBP: ffffc900062f7e00 R08: ffff88808a5001c0 R09: fffffbfff16a3f80
R10: fffffbfff16a3f7f R11: ffffffff8b51fbff R12: 0000000000000000
R13: 1ffff92000c5efa7 R14: ffff8880a9a79000 R15: ffff8880a1d92000
FS:  0000000001ccd880(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000140 CR3: 0000000097113000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 __sys_getsockopt+0x16d/0x310 net/socket.c:2175
 __do_sys_getsockopt net/socket.c:2190 [inline]
 __se_sys_getsockopt net/socket.c:2187 [inline]
 __x64_sys_getsockopt+0xbe/0x150 net/socket.c:2187
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x440149
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffcb256f088 EFLAGS: 00000246 ORIG_RAX: 0000000000000037
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 0000000000440149
RDX: 000000000000000e RSI: 0000000000000112 RDI: 0000000000000003
RBP: 00000000006ca018 R08: 0000000020000140 R09: 00000000004002c8
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000004019d0
R13: 0000000000401a60 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
---[ end trace 63f0b6416dbaab7d ]---
RIP: 0010:l2cap_sock_getsockopt+0x7d3/0x1200 net/bluetooth/l2cap_sock.c:613
Code: 00 00 00 00 00 fc ff df 48 c1 ea 03 80 3c 02 00 0f 85 a0 09 00 00 48 b8 00 00 00 00 00 fc ff df 49 8b 1f 48 89 da 48 c1 ea 03 <80> 3c 02 00 0f 85 75 09 00 00 48 8b 3b e8 cb be f6 ff be 67 02 00
RSP: 0018:ffffc900062f7d20 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff87253e8c
RDX: 0000000000000000 RSI: ffffffff87253f44 RDI: 0000000000000001
RBP: ffffc900062f7e00 R08: ffff88808a5001c0 R09: fffffbfff16a3f80
R10: fffffbfff16a3f7f R11: ffffffff8b51fbff R12: 0000000000000000
R13: 1ffff92000c5efa7 R14: ffff8880a9a79000 R15: ffff8880a1d92000
FS:  0000000001ccd880(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000140 CR3: 0000000097113000 CR4: 00000000001406f0
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
