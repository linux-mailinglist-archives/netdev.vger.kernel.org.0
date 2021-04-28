Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81CAA36DD8E
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 18:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241381AbhD1QwJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 12:52:09 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:51798 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241362AbhD1QwD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Apr 2021 12:52:03 -0400
Received: by mail-il1-f199.google.com with SMTP id i2-20020a056e021b02b029018159d70cffso22288039ilv.18
        for <netdev@vger.kernel.org>; Wed, 28 Apr 2021 09:51:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=2EHzha25OiaVzXnMbSyW5BA4rWrDD90XuiP853UfWsw=;
        b=nUwR0fHg2GRSGbM2v+aOkNnvlz2I4W0hOheKf3jOq72EEVN+HkSWTMZp4fEsyCE1gx
         IenGoUOwGcpbblqbZ0x0w1Col5UpOiBXudO+05kI9Q45IEoyjXDZVd60lBg5ExkyD92U
         IsD324SmsbHdyVgbb+Rmr3K9tx983ekNYbuoO9V7+5md4KDVNUem2dmXIQVgvyQNkMwI
         P6PTr23aWLTl/es3SXaq6AcZMozYJlYuKoxchppSZ4LPbXkuHF0cQWP6IaN104qKo02A
         x4nqYsEvMjmlvv0/t8c/MppEEQZwlFqpCHP79yFoFYJXSWQqLeaID8cywCWXMsxIKUgn
         AFWg==
X-Gm-Message-State: AOAM533EDe6JunAiaoweWb6o67PMj7secxDzk3DYlReW7+rgVVaVm7Ad
        hTYJJG2norbRu+ks2FrTBKylE4d/eIaW47kpI+qU1UG8ataY
X-Google-Smtp-Source: ABdhPJzDBDL15zCcKRMN/8ppzJ60mDtXTi0p4ttkmlOa5hbyQo/rwGSNsHbMkfaOMK3yzqU2J0CD1kcRiJdhOv9vQ5QPNTNkbLX+
MIME-Version: 1.0
X-Received: by 2002:a05:6638:3bc:: with SMTP id z28mr2533847jap.133.1619628677452;
 Wed, 28 Apr 2021 09:51:17 -0700 (PDT)
Date:   Wed, 28 Apr 2021 09:51:17 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000fcdbf905c10b2f2e@google.com>
Subject: [syzbot] BUG: corrupted list in team_priority_option_set
From:   syzbot <syzbot+7deae1e5de1fc51f6c5d@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jiri@resnulli.us, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    57fa2369 Merge tag 'cfi-v5.13-rc1' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=138843cdd00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c37352b2923ef305
dashboard link: https://syzkaller.appspot.com/bug?extid=7deae1e5de1fc51f6c5d
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17741ee1d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13b73aedd00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+7deae1e5de1fc51f6c5d@syzkaller.appspotmail.com

list_del corruption, ffff8881411f0b80->prev is LIST_POISON2 (dead000000000122)
------------[ cut here ]------------
kernel BUG at lib/list_debug.c:48!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 9747 Comm: syz-executor132 Not tainted 5.12.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__list_del_entry_valid.cold+0x37/0x4a lib/list_debug.c:48
Code: f2 ff 0f 0b 4c 89 ea 48 89 ee 48 c7 c7 40 53 c2 89 e8 4d ac f2 ff 0f 0b 4c 89 e2 48 89 ee 48 c7 c7 a0 53 c2 89 e8 39 ac f2 ff <0f> 0b 48 89 ee 48 c7 c7 60 54 c2 89 e8 28 ac f2 ff 0f 0b 83 c3 01
RSP: 0018:ffffc9000b437438 EFLAGS: 00010286
RAX: 000000000000004e RBX: 00000000ffffffff RCX: 0000000000000000
RDX: ffff888015a49c40 RSI: ffffffff815c3fc5 RDI: fffff52001686e79
RBP: ffff8881411f0b80 R08: 000000000000004e R09: 0000000000000000
R10: ffffffff815bcd5e R11: 0000000000000000 R12: dead000000000122
R13: ffff88801213bc70 R14: ffff8881411f0b80 R15: 0000000000000000
FS:  00007ff078be7700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 00000000200f1000 CR4: 0000000000350ef0
Call Trace:
 __list_del_entry include/linux/list.h:132 [inline]
 list_del_rcu include/linux/rculist.h:166 [inline]
 __team_queue_override_port_del drivers/net/team/team.c:819 [inline]
 team_queue_override_port_prio_changed drivers/net/team/team.c:876 [inline]
 team_priority_option_set+0x169/0x2e0 drivers/net/team/team.c:1519
 team_option_set drivers/net/team/team.c:374 [inline]
 team_nl_cmd_options_set+0x6cb/0xc40 drivers/net/team/team.c:2645
 genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:739
 genl_family_rcv_msg net/netlink/genetlink.c:783 [inline]
 genl_rcv_msg+0x328/0x580 net/netlink/genetlink.c:800
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2502
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:811
 netlink_unicast_kernel net/netlink/af_netlink.c:1312 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1338
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1927
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:674
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2350
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2404
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2433
 do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x44afb9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 01 16 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ff078be7308 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004d6338 RCX: 000000000044afb9
RDX: 0000000000000000 RSI: 0000000020000100 RDI: 000000000000000d
RBP: 00000000004d6330 R08: 0000000000000040 R09: 0000000000000000
R10: 0000000000000044 R11: 0000000000000246 R12: 00000000004d633c
R13: 000000000049f534 R14: 0030656c69662f2e R15: 0000000000022000
Modules linked in:
---[ end trace d7d0cba5daa525c4 ]---
RIP: 0010:__list_del_entry_valid.cold+0x37/0x4a lib/list_debug.c:48
Code: f2 ff 0f 0b 4c 89 ea 48 89 ee 48 c7 c7 40 53 c2 89 e8 4d ac f2 ff 0f 0b 4c 89 e2 48 89 ee 48 c7 c7 a0 53 c2 89 e8 39 ac f2 ff <0f> 0b 48 89 ee 48 c7 c7 60 54 c2 89 e8 28 ac f2 ff 0f 0b 83 c3 01
RSP: 0018:ffffc9000b437438 EFLAGS: 00010286
RAX: 000000000000004e RBX: 00000000ffffffff RCX: 0000000000000000
RDX: ffff888015a49c40 RSI: ffffffff815c3fc5 RDI: fffff52001686e79
RBP: ffff8881411f0b80 R08: 000000000000004e R09: 0000000000000000
R10: ffffffff815bcd5e R11: 0000000000000000 R12: dead000000000122
R13: ffff88801213bc70 R14: ffff8881411f0b80 R15: 0000000000000000
FS:  00007ff078be7700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f2cdd4f6020 CR3: 00000000200f1000 CR4: 0000000000350ef0


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
