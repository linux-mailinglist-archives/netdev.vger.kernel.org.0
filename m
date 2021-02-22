Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE40D3212C7
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 10:10:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230214AbhBVJHy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 04:07:54 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:34920 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230175AbhBVJGz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 04:06:55 -0500
Received: by mail-il1-f197.google.com with SMTP id i7so7204317ilu.2
        for <netdev@vger.kernel.org>; Mon, 22 Feb 2021 01:06:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=xL5hX/oDoGOjx3JDAg4mOOJrAjuv89a9w3AdSyMiL84=;
        b=Pq0m536kf/erlLAF+7Ixcc5WwxazeVBOp21PtTPw3Kr9hwoFEk8VOgFkVoXV/36qUW
         5hVD2vKbdaFpJz5XfR/hoy77CRFFA/gXTUdG0CV/uRLqPTT+KkILscaJeQ4Qn5u6DQ5J
         XR+3TDNfapgWCcTFUUIFxuJKqdiaO0xJeQu4gGm4ausU4Xnwvj7gAUaIB6slpzHd/87b
         m9v61EF53ELxJ+ME3aOdu/GkPy6vxymLRsecKkTWDU1QzkjflK+Zy0dhuoOxnwCYW0Ml
         sBsK8qiJLSjpobMw017OP2L2Ww7+71IuUzqSZX6SNJ5hqwK5E7/uegeQWbJIM5BOWBcG
         56kA==
X-Gm-Message-State: AOAM531AMWNqvPmRC0J9FfxW8gq3UPLbKWYIWZREVWlC0yySgjOtw0zj
        dJNaXFvC1PC3AUpQAmhdqKr9gX6Xzxok+r8ISwXeZD/wYvRi
X-Google-Smtp-Source: ABdhPJxohqNYgnWb9GoJoQDPOEg1Pl8O07c4P5SbOusmUm+bNbtLozY34GKpxibPdJqi0jidHIbfWibdUNHzxZsGCA8cB+PvsWYC
MIME-Version: 1.0
X-Received: by 2002:a6b:c915:: with SMTP id z21mr11862087iof.32.1613984774297;
 Mon, 22 Feb 2021 01:06:14 -0800 (PST)
Date:   Mon, 22 Feb 2021 01:06:14 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000251ce705bbe91ddb@google.com>
Subject: WARNING in nbd_dev_add
From:   syzbot <syzbot+9b658439133becd38da1@syzkaller.appspotmail.com>
To:     axboe@kernel.dk, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    3af409ca net: enetc: fix destroyed phylink dereference dur..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=11e8c05cd00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8cb23303ddb9411f
dashboard link: https://syzkaller.appspot.com/bug?extid=9b658439133becd38da1

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+9b658439133becd38da1@syzkaller.appspotmail.com

RBP: 00000000004bcd1c R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf60
R13: 00007ffff04bfbdf R14: 00007f694f5fc300 R15: 0000000000022000
kobject_add_internal failed for 43:32 with -EEXIST, don't try to register things with the same name in the same directory.
------------[ cut here ]------------
WARNING: CPU: 0 PID: 9626 at block/genhd.c:749 __device_add_disk+0xfdc/0x12b0 block/genhd.c:749
Modules linked in:
CPU: 0 PID: 9626 Comm: syz-executor.4 Not tainted 5.11.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__device_add_disk+0xfdc/0x12b0 block/genhd.c:749
Code: f1 ff ff e8 46 e1 c3 fd 0f 0b e9 12 f7 ff ff 48 89 7c 24 20 e8 35 e1 c3 fd 0f 0b 48 8b 7c 24 20 e9 d6 f4 ff ff e8 24 e1 c3 fd <0f> 0b e9 f7 fb ff ff 4c 89 ef e8 c5 bb 06 fe e9 7d f1 ff ff 48 8b
RSP: 0018:ffffc9000257f340 EFLAGS: 00010246
RAX: 0000000000040000 RBX: 0000000000000001 RCX: ffffc90011d9d000
RDX: 0000000000040000 RSI: ffffffff83aef37c RDI: 0000000000000003
RBP: ffff88801909c800 R08: 0000000000000000 R09: ffffffff8f8667f7
R10: ffffffff83aeef71 R11: 0000000000000000 R12: 00000000ffffffef
R13: ffff88801909c858 R14: ffff88801a15aed0 R15: ffff888013cc8000
FS:  00007f694f5fc700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055ba23aa08d7 CR3: 000000006d4b7000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 add_disk include/linux/genhd.h:241 [inline]
 nbd_dev_add+0x6f3/0x8e0 drivers/block/nbd.c:1739
 nbd_genl_connect+0x557/0x1560 drivers/block/nbd.c:1849
 genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:739
 genl_family_rcv_msg net/netlink/genetlink.c:783 [inline]
 genl_rcv_msg+0x328/0x580 net/netlink/genetlink.c:800
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2494
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:811
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2345
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2399
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2432
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x465ef9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f694f5fc188 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 000000000056bf60 RCX: 0000000000465ef9
RDX: 0000000000000000 RSI: 0000000020000180 RDI: 0000000000000004
RBP: 00000000004bcd1c R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf60
R13: 00007ffff04bfbdf R14: 00007f694f5fc300 R15: 0000000000022000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
