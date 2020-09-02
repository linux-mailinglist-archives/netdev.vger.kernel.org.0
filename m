Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E55BB25A6C0
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 09:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727035AbgIBH1f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 03:27:35 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:36638 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726559AbgIBH1Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 03:27:24 -0400
Received: by mail-il1-f197.google.com with SMTP id f20so2859013ilg.3
        for <netdev@vger.kernel.org>; Wed, 02 Sep 2020 00:27:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=5tLgRxvQOWCfo/r3V+DZ1IXXNjzUtceuWlvB5zBJSxo=;
        b=uRvuLMvmoHQgMcOd2GaOQOTltu1stRTeJ2obimVrO/6crIMSBwiAdmMtl/+5goYpiY
         6JeIe+iTh4i3uXUEwZ9SgcD33eu4S5ZFIllfeH7P0x6eFMp+yC3IE1qSXUW5owmIHBWl
         od2gii0e69HIq7umD0OsQ65UISTsZGE8TCpVmgJKa0qyQ6SBE91cbz4qJ5pt6o5CkIN/
         QhK/fUfl/vgR47OS+51jySh1gwbfXfQInfLw6WwOl0+UxtWWlvPP7lSQUhrGgnf6ya6v
         XVWOCUbtYm3kVwVFA1piTP8/wHuIXnfMrxOR5ZmLp3QN8+OeeOsy44vXofLxyoOHLLHV
         1sGQ==
X-Gm-Message-State: AOAM533pZfYVL15XaLu9D/ntpv9SUwBvEGszuZhXr4Hcjah39oVG4LM5
        gLp5FJQR4cRXqa3WtKrYHZj4PUbEEZMu7NnODYZaH2f6vlzM
X-Google-Smtp-Source: ABdhPJyFpx8Fi0yKpksXV8ZtgK8FOtF5HrExECPjBTfHT6C755JHnTtPF9WoIK6UEOkQMmWAvQj6rc8DPV84V2aLhg5I+IQ2JFdy
MIME-Version: 1.0
X-Received: by 2002:a92:6612:: with SMTP id a18mr2438980ilc.94.1599031642986;
 Wed, 02 Sep 2020 00:27:22 -0700 (PDT)
Date:   Wed, 02 Sep 2020 00:27:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000109dde05ae4f916b@google.com>
Subject: general protection fault in xsk_diag_dump (2)
From:   syzbot <syzbot+3f04d36b7336f7868066@syzkaller.appspotmail.com>
To:     ast@kernel.org, bjorn.topel@intel.com, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, hawk@kernel.org,
        john.fastabend@gmail.com, jonathan.lemon@gmail.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        magnus.karlsson@intel.com, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    dc1a9bf2 octeontx2-pf: Add UDP segmentation offload support
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=146061d1900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b6856d16f78d8fa9
dashboard link: https://syzkaller.appspot.com/bug?extid=3f04d36b7336f7868066
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14590399900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13bd8615900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3f04d36b7336f7868066@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000001: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
CPU: 0 PID: 6881 Comm: syz-executor775 Not tainted 5.9.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:xsk_diag_put_umem net/xdp/xsk_diag.c:62 [inline]
RIP: 0010:xsk_diag_fill net/xdp/xsk_diag.c:129 [inline]
RIP: 0010:xsk_diag_dump+0xe27/0x15a0 net/xdp/xsk_diag.c:165
Code: 04 28 84 c0 74 08 3c 03 0f 8e bb 06 00 00 41 8b 44 24 10 89 84 24 fc 00 00 00 48 8b 44 24 40 48 8d 78 08 48 89 f8 48 c1 e8 03 <80> 3c 28 00 0f 85 91 05 00 00 48 8b 44 24 40 48 8b 40 08 48 85 c0
RSP: 0018:ffffc90000f4f400 EFLAGS: 00010202
RAX: 0000000000000001 RBX: ffff888094348000 RCX: 0000000000000000
RDX: ffff88809023c4c0 RSI: ffffffff87f057f2 RDI: 0000000000000008
RBP: dffffc0000000000 R08: 0000000000000001 R09: ffff888094348033
R10: 0000000000000000 R11: 0000000000097f68 R12: ffff88809598f280
R13: ffff88809989b018 R14: ffff8880a60c5000 R15: 0000000000000000
FS:  0000000001e13880(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000080 CR3: 000000009dec8000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 netlink_dump+0x4cd/0xf60 net/netlink/af_netlink.c:2246
 __netlink_dump_start+0x643/0x900 net/netlink/af_netlink.c:2354
 netlink_dump_start include/linux/netlink.h:246 [inline]
 xsk_diag_handler_dump+0x1a3/0x240 net/xdp/xsk_diag.c:192
 __sock_diag_cmd net/core/sock_diag.c:233 [inline]
 sock_diag_rcv_msg+0x2fe/0x3e0 net/core/sock_diag.c:264
 netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2470
 sock_diag_rcv+0x26/0x40 net/core/sock_diag.c:275
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:671
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2353
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2407
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2440
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x440369
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffe05e8e768 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 0000000000440369
RDX: 0000000000000000 RSI: 0000000020000080 RDI: 0000000000000003
RBP: 00000000006ca018 R08: 00000000004002c8 R09: 00000000004002c8
R10: 0000000000000048 R11: 0000000000000246 R12: 0000000000401b70
R13: 0000000000401c00 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
---[ end trace 7c46987c287e91b6 ]---
RIP: 0010:xsk_diag_put_umem net/xdp/xsk_diag.c:62 [inline]
RIP: 0010:xsk_diag_fill net/xdp/xsk_diag.c:129 [inline]
RIP: 0010:xsk_diag_dump+0xe27/0x15a0 net/xdp/xsk_diag.c:165
Code: 04 28 84 c0 74 08 3c 03 0f 8e bb 06 00 00 41 8b 44 24 10 89 84 24 fc 00 00 00 48 8b 44 24 40 48 8d 78 08 48 89 f8 48 c1 e8 03 <80> 3c 28 00 0f 85 91 05 00 00 48 8b 44 24 40 48 8b 40 08 48 85 c0
RSP: 0018:ffffc90000f4f400 EFLAGS: 00010202
RAX: 0000000000000001 RBX: ffff888094348000 RCX: 0000000000000000
RDX: ffff88809023c4c0 RSI: ffffffff87f057f2 RDI: 0000000000000008
RBP: dffffc0000000000 R08: 0000000000000001 R09: ffff888094348033
R10: 0000000000000000 R11: 0000000000097f68 R12: ffff88809598f280
R13: ffff88809989b018 R14: ffff8880a60c5000 R15: 0000000000000000
FS:  0000000001e13880(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f2f4414a000 CR3: 000000009dec8000 CR4: 00000000001506f0
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
