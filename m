Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5488B1DA97E
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 06:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726672AbgETExT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 00:53:19 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:55534 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726403AbgETExR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 00:53:17 -0400
Received: by mail-io1-f72.google.com with SMTP id o21so1334890ioo.22
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 21:53:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=DIiqMHtyvMnz5WMqNfkMUl4cSfa+AjoZJsXH1BmW5zg=;
        b=kkDvqSa3sVFkPL1e3cXc003OEIDA7AwBQlTG2bCWTPwj1N+N30UOL97/ulYgXV6brF
         BA5M06GC7xVp/qGK62giEQ7DxldAKueu032ZG/xUwFH2QoSDoZo3v5d5WZ6h2HK1otVb
         dN4wjpqJMaHhDyiNsbM1Pso7qsXAldBK6VN/dBINzagMIiMWDjWXLBfySQ7fmmZMM03y
         IN5yn39uge22NOLe+BslhTW2NudsCm0xXMoVJYE7hNcAlKXdbL9U5piX/XFybud+YoqH
         ENNnGXM+CFEsNuc3SlT6n5RDsPAN4nQdgVAkF/enALSW+GADJpKi9TEGGmUyYWX3PXdg
         Wy1A==
X-Gm-Message-State: AOAM5306e5Lo6BMXoGTP6klM9DuHHEv6aE95wauDAwSq1Z6nlUFNhvyD
        Podi/tN9wyYIAOz8fWf95wiX46VAeDOJTv2YtXy5DX+2MxMU
X-Google-Smtp-Source: ABdhPJyzCvrvypkSMKkv5ZvuKJ9z3mUZ9PJRbZLTUWeUvffIQWwP6Vv5CPR+iJVq6K7BY+mutJcJ4aECp/ThjthF5vZY2xA7lyRx
MIME-Version: 1.0
X-Received: by 2002:a6b:b5c6:: with SMTP id e189mr2026804iof.196.1589950396655;
 Tue, 19 May 2020 21:53:16 -0700 (PDT)
Date:   Tue, 19 May 2020 21:53:16 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009a6d4305a60d2c6b@google.com>
Subject: general protection fault in kobject_get (2)
From:   syzbot <syzbot+407fd358a932bbf639c6@syzkaller.appspotmail.com>
To:     gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, rafael@kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    d00f26b6 Merge git://git.kernel.org/pub/scm/linux/kernel/g..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1316343c100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=26d0bd769afe1a2c
dashboard link: https://syzkaller.appspot.com/bug?extid=407fd358a932bbf639c6
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+407fd358a932bbf639c6@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000013: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000098-0x000000000000009f]
CPU: 1 PID: 16682 Comm: syz-executor.3 Not tainted 5.7.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:kobject_get+0x30/0x150 lib/kobject.c:640
Code: 53 e8 d4 7e c6 fd 4d 85 e4 0f 84 a2 00 00 00 e8 c6 7e c6 fd 49 8d 7c 24 3c 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 04 02 48 89 fa 83 e2 07 38 d0 7f 08 84 c0 0f 85 e7 00 00 00
RSP: 0018:ffffc9000772f240 EFLAGS: 00010203
RAX: dffffc0000000000 RBX: ffffffff85acfca0 RCX: ffffc9000fc67000
RDX: 0000000000000013 RSI: ffffffff83acadfa RDI: 000000000000009c
RBP: 0000000000000060 R08: ffff8880a8dfa4c0 R09: ffffed100a03f403
R10: ffff8880501fa017 R11: ffffed100a03f402 R12: 0000000000000060
R13: ffffc9000772f3c0 R14: ffff88805d1ec4e8 R15: ffff88805d1ec580
FS:  00007f1ebed26700(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000004d88f0 CR3: 00000000a86c4000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 get_device+0x20/0x30 drivers/base/core.c:2620
 __ib_get_client_nl_info+0x1d4/0x2a0 drivers/infiniband/core/device.c:1863
 ib_get_client_nl_info+0x30/0x180 drivers/infiniband/core/device.c:1883
 nldev_get_chardev+0x52b/0xa40 drivers/infiniband/core/nldev.c:1625
 rdma_nl_rcv_msg drivers/infiniband/core/netlink.c:195 [inline]
 rdma_nl_rcv_skb drivers/infiniband/core/netlink.c:239 [inline]
 rdma_nl_rcv+0x586/0x900 drivers/infiniband/core/netlink.c:259
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x537/0x740 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x882/0xe10 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6e6/0x810 net/socket.c:2352
 ___sys_sendmsg+0x100/0x170 net/socket.c:2406
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2439
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x45c829
Code: 0d b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f1ebed25c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004ff720 RCX: 000000000045c829
RDX: 0000000000000000 RSI: 0000000020000200 RDI: 0000000000000003
RBP: 000000000078bf00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 00000000000009ad R14: 00000000004d5f10 R15: 00007f1ebed266d4
Modules linked in:
---[ end trace 239938a6c4c3c99f ]---
RIP: 0010:kobject_get+0x30/0x150 lib/kobject.c:640
Code: 53 e8 d4 7e c6 fd 4d 85 e4 0f 84 a2 00 00 00 e8 c6 7e c6 fd 49 8d 7c 24 3c 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 04 02 48 89 fa 83 e2 07 38 d0 7f 08 84 c0 0f 85 e7 00 00 00
RSP: 0018:ffffc9000772f240 EFLAGS: 00010203
RAX: dffffc0000000000 RBX: ffffffff85acfca0 RCX: ffffc9000fc67000
RDX: 0000000000000013 RSI: ffffffff83acadfa RDI: 000000000000009c
RBP: 0000000000000060 R08: ffff8880a8dfa4c0 R09: ffffed100a03f403
R10: ffff8880501fa017 R11: ffffed100a03f402 R12: 0000000000000060
R13: ffffc9000772f3c0 R14: ffff88805d1ec4e8 R15: ffff88805d1ec580
FS:  00007f1ebed26700(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000073fad4 CR3: 00000000a86c4000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
