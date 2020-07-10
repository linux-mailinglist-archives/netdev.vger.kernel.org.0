Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C982721BD1C
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 20:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728089AbgGJSiT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 14:38:19 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:32917 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727065AbgGJSiT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 14:38:19 -0400
Received: by mail-io1-f71.google.com with SMTP id a12so4183141ioo.0
        for <netdev@vger.kernel.org>; Fri, 10 Jul 2020 11:38:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=WqdH68p6XjuG3WJATM6GmNbQRoflL6uFHqhjW36VFBI=;
        b=pSwXpQXXHig2qD2mpGkbiZR61s2lUbKOXkM66bi2MqrhgZNwpADcykRonOSttMKcQi
         Ti5hk3YJDS/u+NmD8RpOPGMwQE6REtMYOjxMMsKmkdNHDgRokuMIi4cvbq4dyU24lcYN
         3av6o/8+IlHbcGNbxPlINCSriSkRf6wYoko5mxzotWmJtUt6bAHBu6jqGxyiIEZTsSmk
         6zUHsBe67korSc4lXYzD69kPfm2W1YOU/HOP/ZN4GTA9vgw/zDOgjdzhlhXYR9n631J8
         S/meqL3uwM+BS+GODe3w1gRrn4XRWcFY3htaB/8DyH9KVGp9vAGYONkzbd1cyXvf1dxT
         UA5w==
X-Gm-Message-State: AOAM531o1p6GV+sDASBIJLqAqYSCJWElrEerxmzjzwLjzabwrqknv1Gs
        T8GYraM8ctLmF3UUzUFMnend/F8PBM1/s/Gqx1JIvPbLBVjs
X-Google-Smtp-Source: ABdhPJz4xg63WBLjem4rE0VTxzgBQIchhCQvKSZPrPVyR0wiGwBEI9XprvdZYiAjtwzQFWMSU9WwVDmpnGdw0BiCx2YmmHrBQdE0
MIME-Version: 1.0
X-Received: by 2002:a6b:730a:: with SMTP id e10mr49422839ioh.108.1594406298127;
 Fri, 10 Jul 2020 11:38:18 -0700 (PDT)
Date:   Fri, 10 Jul 2020 11:38:18 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000714f605aa1aa56c@google.com>
Subject: general protection fault in raw_notifier
From:   syzbot <syzbot+d2ff507f470081495266@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org, mkl@pengutronix.de,
        netdev@vger.kernel.org, socketcan@hartkopp.net,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    7cc2a8ea Merge tag 'block-5.8-2020-07-01' of git://git.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=111cddcb100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7be693511b29b338
dashboard link: https://syzkaller.appspot.com/bug?extid=d2ff507f470081495266
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+d2ff507f470081495266@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xe0000aeee00000aa: 0000 [#1] PREEMPT SMP KASAN
KASAN: probably user-memory-access in range [0x0000777700000550-0x0000777700000557]
CPU: 0 PID: 8345 Comm: syz-executor.5 Not tainted 5.8.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:read_pnet include/net/net_namespace.h:330 [inline]
RIP: 0010:dev_net include/linux/netdevice.h:2261 [inline]
RIP: 0010:raw_notifier+0x7c/0x740 net/can/raw.c:273
Code: 03 80 3c 02 00 0f 85 de 05 00 00 4d 8d b7 98 05 00 00 48 8b ab 70 fb ff ff 48 b8 00 00 00 00 00 fc ff df 4c 89 f2 48 c1 ea 03 <80> 3c 02 00 0f 85 cc 05 00 00 49 3b af 98 05 00 00 74 16 e8 0c 5d
RSP: 0018:ffffc9001ab27c78 EFLAGS: 00010206
RAX: dffffc0000000000 RBX: ffff88802521c4c0 RCX: ffffc90014660000
RDX: 00000eeee00000aa RSI: ffffffff871159dc RDI: ffff88802521c030
RBP: ffff88805602a180 R08: 0000000000000000 R09: ffffffff8a7b30cb
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000005
R13: ffffed1004a43898 R14: 0000777700000550 R15: 00007776ffffffb8
FS:  00007fe94efbf700(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b32d21000 CR3: 00000001e1c55000 CR4: 00000000001426f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 call_netdevice_notifier net/core/dev.c:1727 [inline]
 call_netdevice_register_notifiers net/core/dev.c:1735 [inline]
 call_netdevice_register_net_notifiers+0xdd/0x2b0 net/core/dev.c:1765
 register_netdevice_notifier+0xf5/0x260 net/core/dev.c:1816
 raw_init+0x296/0x340 net/can/raw.c:339
 can_create+0x27c/0x4d0 net/can/af_can.c:168
 __sock_create+0x3ca/0x740 net/socket.c:1428
 sock_create net/socket.c:1479 [inline]
 __sys_socket+0xef/0x200 net/socket.c:1521
 __do_sys_socket net/socket.c:1530 [inline]
 __se_sys_socket net/socket.c:1528 [inline]
 __x64_sys_socket+0x6f/0xb0 net/socket.c:1528
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:359
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45cb29
Code: Bad RIP value.
RSP: 002b:00007fe94efbec78 EFLAGS: 00000246 ORIG_RAX: 0000000000000029
RAX: ffffffffffffffda RBX: 00000000005084a0 RCX: 000000000045cb29
RDX: 0000000000000001 RSI: 0000000000000003 RDI: 000000000000001d
RBP: 000000000078bf00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 0000000000000bb8 R14: 00000000004ce1ab R15: 00007fe94efbf6d4
Modules linked in:
---[ end trace 8db5579e5986dda6 ]---
RIP: 0010:read_pnet include/net/net_namespace.h:330 [inline]
RIP: 0010:dev_net include/linux/netdevice.h:2261 [inline]
RIP: 0010:raw_notifier+0x7c/0x740 net/can/raw.c:273
Code: 03 80 3c 02 00 0f 85 de 05 00 00 4d 8d b7 98 05 00 00 48 8b ab 70 fb ff ff 48 b8 00 00 00 00 00 fc ff df 4c 89 f2 48 c1 ea 03 <80> 3c 02 00 0f 85 cc 05 00 00 49 3b af 98 05 00 00 74 16 e8 0c 5d
RSP: 0018:ffffc9001ab27c78 EFLAGS: 00010206
RAX: dffffc0000000000 RBX: ffff88802521c4c0 RCX: ffffc90014660000
RDX: 00000eeee00000aa RSI: ffffffff871159dc RDI: ffff88802521c030
RBP: ffff88805602a180 R08: 0000000000000000 R09: ffffffff8a7b30cb
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000005
R13: ffffed1004a43898 R14: 0000777700000550 R15: 00007776ffffffb8
FS:  00007fe94efbf700(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fe94ef7cdb8 CR3: 00000001e1c55000 CR4: 00000000001426f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
