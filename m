Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 485D327A8BC
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 09:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbgI1HgR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 03:36:17 -0400
Received: from mail-il1-f206.google.com ([209.85.166.206]:52697 "EHLO
        mail-il1-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726600AbgI1HgQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 03:36:16 -0400
Received: by mail-il1-f206.google.com with SMTP id m1so91983iln.19
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 00:36:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=dQVM5rOfZiP72VmE11knrY/4zMQmueL+CPBBPaQD6Ls=;
        b=tHXYzV6MET9TcP5Aazco+f7CvPU8VzSf1cYXenHGR+dR0zB5STzrcDjDDprsZSd9yq
         4Doe5Zx49Bmeu8cAXQnRFW6EVvLg+ojvnRHgEr0gqJbJUQexk6seNFp5nFTjEIhbpf3u
         1Xmo+0W9J3d7qw4xYca35Z49bp0WsGSIC4BYSiZYEw7Z6tttbr5W4y8+4Lvez29NkMAf
         Fz4MHga/kRCzrqLRMOAza+fq7LZZ9wyVKKArJmTU3UXa5g+b2qAXFPu4jr81peVHkya6
         Y4sex3XAWtX+InmxyQfAz6bQiu/Cci8n95/tYOTZLaXqi2CCaKPV34W1D7nxFbvdeIgr
         FaOw==
X-Gm-Message-State: AOAM5313gHLLhjeWfn31c3BwwmF2zXWjUJEXeQC6Spd+NuzlJkfgBdE6
        DgTfkQnRgNdydmqKwoF7Vq65kAt0oqsBBTGWpBTpFpHbGcKE
X-Google-Smtp-Source: ABdhPJzrFpPk1jt+c/26RXCvjoiLQ4V9RVYmzNivbXg59VgdKnkQSOgo0y7aB0EiQYwVohU8RlaLrbDpZ4wtdIyfQ/tJRkshTCct
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:925:: with SMTP id o5mr125335ilt.20.1601278575890;
 Mon, 28 Sep 2020 00:36:15 -0700 (PDT)
Date:   Mon, 28 Sep 2020 00:36:15 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b3d57105b05ab856@google.com>
Subject: BUG: unable to handle kernel paging request in tcf_action_dump_terse
From:   syzbot <syzbot+5f66662adc70969940fd@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    307eea32 dt-bindings: net: renesas,ravb: Add support for r..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=13b7e29d900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=240e2ebab67245c7
dashboard link: https://syzkaller.appspot.com/bug?extid=5f66662adc70969940fd
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5f66662adc70969940fd@syzkaller.appspotmail.com

netlink: 8 bytes leftover after parsing attributes in process `syz-executor.5'.
BUG: unable to handle page fault for address: fffffffffffffff0
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 9e90067 P4D 9e90067 PUD 9e92067 PMD 0 
Oops: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 9876 Comm: syz-executor.5 Not tainted 5.9.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:tcf_action_dump_terse+0x8c/0x4e0 net/sched/act_api.c:766
Code: 3c 03 0f 8e 0a 03 00 00 48 89 da 44 8b ad b8 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 80 3c 02 00 0f 85 10 04 00 00 <48> 8b 03 4c 8d 60 10 4c 89 e7 e8 d5 2b 4e fd 4c 89 e1 be 01 00 00
RSP: 0018:ffffc9001604f170 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: fffffffffffffff0 RCX: ffffc900137c6000
RDX: 1ffffffffffffffe RSI: ffffffff868ac439 RDI: ffff88808f9dfdf8
RBP: ffff88808f9dfd40 R08: 0000000000000000 R09: ffff88805dd4a024
R10: 0000000000000000 R11: 0000000000000000 R12: fffffffffffffff0
R13: 0000000000000024 R14: ffff88805dd4a000 R15: ffff88808f9dfe00
FS:  00007ffbf7f0d700(0000) GS:ffff8880ae500000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffffffffffff0 CR3: 00000000a6cea000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 tcf_action_dump_1+0xd2/0x5a0 net/sched/act_api.c:795
 tcf_dump_walker net/sched/act_api.c:249 [inline]
 tcf_generic_walker+0x207/0xba0 net/sched/act_api.c:343
 tc_dump_action+0x6d5/0xe60 net/sched/act_api.c:1623
 netlink_dump+0x4cd/0xf60 net/netlink/af_netlink.c:2246
 __netlink_dump_start+0x643/0x900 net/netlink/af_netlink.c:2354
 netlink_dump_start include/linux/netlink.h:246 [inline]
 rtnetlink_rcv_msg+0x70f/0xad0 net/core/rtnetlink.c:5526
 netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2470
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:671
 ____sys_sendmsg+0x331/0x810 net/socket.c:2353
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2407
 __sys_sendmmsg+0x195/0x480 net/socket.c:2497
 __do_sys_sendmmsg net/socket.c:2526 [inline]
 __se_sys_sendmmsg net/socket.c:2523 [inline]
 __x64_sys_sendmmsg+0x99/0x100 net/socket.c:2523
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45e179
Code: 3d b2 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 0b b2 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffbf7f0cc78 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
RAX: ffffffffffffffda RBX: 0000000000027f40 RCX: 000000000045e179
RDX: 0492492492492805 RSI: 0000000020000140 RDI: 0000000000000003
RBP: 000000000118cf88 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000118cf4c
R13: 00007ffc4024440f R14: 00007ffbf7f0d9c0 R15: 000000000118cf4c
Modules linked in:
CR2: fffffffffffffff0
---[ end trace 8426deb8202e61ba ]---
RIP: 0010:tcf_action_dump_terse+0x8c/0x4e0 net/sched/act_api.c:766
Code: 3c 03 0f 8e 0a 03 00 00 48 89 da 44 8b ad b8 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 80 3c 02 00 0f 85 10 04 00 00 <48> 8b 03 4c 8d 60 10 4c 89 e7 e8 d5 2b 4e fd 4c 89 e1 be 01 00 00
RSP: 0018:ffffc9001604f170 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: fffffffffffffff0 RCX: ffffc900137c6000
RDX: 1ffffffffffffffe RSI: ffffffff868ac439 RDI: ffff88808f9dfdf8
RBP: ffff88808f9dfd40 R08: 0000000000000000 R09: ffff88805dd4a024
R10: 0000000000000000 R11: 0000000000000000 R12: fffffffffffffff0
R13: 0000000000000024 R14: ffff88805dd4a000 R15: ffff88808f9dfe00
FS:  00007ffbf7f0d700(0000) GS:ffff8880ae500000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffffffffffff0 CR3: 00000000a6cea000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
