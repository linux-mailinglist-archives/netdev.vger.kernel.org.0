Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 647AE13D118
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 01:26:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729143AbgAPAZU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 19:25:20 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:51113 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730255AbgAPAZN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 19:25:13 -0500
Received: by mail-io1-f69.google.com with SMTP id e13so11490456iob.17
        for <netdev@vger.kernel.org>; Wed, 15 Jan 2020 16:25:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=5Q0/s70I04zkYXmwGyibITI228DfglQLra6W2tkH+R4=;
        b=mv4VvhpmdXO7o+Eq434PhrptlBQKtb/7MFSfnnIaaW3nXwwJmar3DnkhlrNrEQcqqd
         Tn3mKUS8AyTEtbEPs4jKlu9nsT6clzzz8TguyXQpwb8t4126izqj09ihascYgAt+jjD2
         qYlpZIXx98MW1joAkgvNxAHx5uMSphi5O5O3JuUa0ymLIsmYAgWrk5wcjwgAYlv7RNlo
         NUzvEavOjEN2XiECahv6LPkxd8tRCRwyE+Ogh/GanIqWyfxhe3fMIqQyGDNURUdgU2Rw
         JGE+b34zLeSCdLfvx5/FaKqVo9F7SR/m+ficBk3gYG8Ist1KmvCXULS6h3/oYVpu6dV/
         HB/w==
X-Gm-Message-State: APjAAAWUvY9K5cVskt1zMNSUw3AXundJUos8MoB5QfoiMHK7gYiUTqwM
        BpK21t2uwXNGBGVyU1kJuGXafg4VC6JXKfknycGV3tA+bN7U
X-Google-Smtp-Source: APXvYqx32xVicDGczPj5NgHpnTvtiGY3C0Z7tUd5DYmqSfMs6r4DbtcZAzA3KPW6BgcJDHTDYRMzlJuhjLjQi7kAMGjaRzj46dU2
MIME-Version: 1.0
X-Received: by 2002:a6b:c884:: with SMTP id y126mr486954iof.246.1579134312279;
 Wed, 15 Jan 2020 16:25:12 -0800 (PST)
Date:   Wed, 15 Jan 2020 16:25:12 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000bc757e059c36db18@google.com>
Subject: BUG: corrupted list in nft_obj_del
From:   syzbot <syzbot+6ca99af7e70e298bd09d@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    8b792f84 Merge branch 'mlxsw-Various-fixes'
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=1766b349e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7e89bd00623fe71e
dashboard link: https://syzkaller.appspot.com/bug?extid=6ca99af7e70e298bd09d
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=168b95e1e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10f29b3ee00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+6ca99af7e70e298bd09d@syzkaller.appspotmail.com

list_del corruption, ffff8880a46b1500->prev is LIST_POISON2  
(dead000000000122)
------------[ cut here ]------------
kernel BUG at lib/list_debug.c:48!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 9787 Comm: syz-executor290 Not tainted 5.5.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:__list_del_entry_valid.cold+0x37/0x4f lib/list_debug.c:48
Code: be fd 0f 0b 4c 89 ea 4c 89 f6 48 c7 c7 a0 65 71 88 e8 a0 bb be fd 0f  
0b 4c 89 e2 4c 89 f6 48 c7 c7 00 66 71 88 e8 8c bb be fd <0f> 0b 4c 89 f6  
48 c7 c7 c0 66 71 88 e8 7b bb be fd 0f 0b cc cc cc
RSP: 0018:ffffc900020e7338 EFLAGS: 00010286
RAX: 000000000000004e RBX: ffff8880a46b1500 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff815e53a6 RDI: fffff5200041ce59
RBP: ffffc900020e7350 R08: 000000000000004e R09: ffffed1015d26621
R10: ffffed1015d26620 R11: ffff8880ae933107 R12: dead000000000122
R13: ffff88809e9c3970 R14: ffff8880a46b1500 R15: ffff8880a46b1508
FS:  0000000000837880(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000280 CR3: 000000008f0b6000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  __list_del_entry include/linux/list.h:131 [inline]
  list_del_rcu include/linux/rculist.h:148 [inline]
  nft_obj_del+0xcb/0x1f0 net/netfilter/nf_tables_api.c:6970
  nf_tables_commit+0x1339/0x3b30 net/netfilter/nf_tables_api.c:7171
  nfnetlink_rcv_batch+0xc78/0x17a0 net/netfilter/nfnetlink.c:485
  nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:543 [inline]
  nfnetlink_rcv+0x3e7/0x460 net/netfilter/nfnetlink.c:561
  netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
  netlink_unicast+0x58c/0x7d0 net/netlink/af_netlink.c:1328
  netlink_sendmsg+0x91c/0xea0 net/netlink/af_netlink.c:1917
  sock_sendmsg_nosec net/socket.c:639 [inline]
  sock_sendmsg+0xd7/0x130 net/socket.c:659
  ____sys_sendmsg+0x753/0x880 net/socket.c:2330
  ___sys_sendmsg+0x100/0x170 net/socket.c:2384
  __sys_sendmsg+0x105/0x1d0 net/socket.c:2417
  __do_sys_sendmsg net/socket.c:2426 [inline]
  __se_sys_sendmsg net/socket.c:2424 [inline]
  __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2424
  do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4406a9
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fff37625bc8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 00000000004406a9
RDX: 0000000000042000 RSI: 0000000020000140 RDI: 0000000000000004
RBP: 00000000006ca018 R08: 0000000000000001 R09: 00000000004002c8
R10: 0000000000000009 R11: 0000000000000246 R12: 0000000000401f30
R13: 0000000000401fc0 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
---[ end trace 7b3c7a3aadb229c5 ]---
RIP: 0010:__list_del_entry_valid.cold+0x37/0x4f lib/list_debug.c:48
Code: be fd 0f 0b 4c 89 ea 4c 89 f6 48 c7 c7 a0 65 71 88 e8 a0 bb be fd 0f  
0b 4c 89 e2 4c 89 f6 48 c7 c7 00 66 71 88 e8 8c bb be fd <0f> 0b 4c 89 f6  
48 c7 c7 c0 66 71 88 e8 7b bb be fd 0f 0b cc cc cc
RSP: 0018:ffffc900020e7338 EFLAGS: 00010286
RAX: 000000000000004e RBX: ffff8880a46b1500 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff815e53a6 RDI: fffff5200041ce59
RBP: ffffc900020e7350 R08: 000000000000004e R09: ffffed1015d26621
R10: ffffed1015d26620 R11: ffff8880ae933107 R12: dead000000000122
R13: ffff88809e9c3970 R14: ffff8880a46b1500 R15: ffff8880a46b1508
FS:  0000000000837880(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000280 CR3: 000000008f0b6000 CR4: 00000000001406e0
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
