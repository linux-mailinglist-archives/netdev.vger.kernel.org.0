Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9259A268821
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 11:19:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbgINJTV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 05:19:21 -0400
Received: from mail-il1-f206.google.com ([209.85.166.206]:52162 "EHLO
        mail-il1-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbgINJTU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 05:19:20 -0400
Received: by mail-il1-f206.google.com with SMTP id i80so12117061ild.18
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 02:19:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=PopK2tlLDApo/coeVBR5hxOMNG+Fyhkdx0BjdaxPuXg=;
        b=OSfRDTBvUjwFpyGBSi5Er5qAsQhktZpGvBMKWocAVw4YJyJ6F2dUGPtmlS0+sMQ16v
         tRZqN7Mzmea2NfBW3G0IyaPSdXyzZ0t7AxvHUJ8Kv4GJXF1ePcP3yJIiDETbnjK5nh7o
         r0yBb1KSaMwortct7Hqm8nhUatlS2pkObebhWQYQrjY/bfAo3njTAcgpEy7VxY16i4/I
         HjYjJnGxxkgivCUgcqCl50HhdmDXnHk0akdSI2oYgNeMHrdS6ZiXZ41ZlyTqGwRKxHIi
         3zIgbGX04lk8G4OEJMZiwFizXOJo3zQj2vBtpEK2F0ABgeIWkK6egNugWMzv3ijpPsli
         37Hg==
X-Gm-Message-State: AOAM532pSO+My1JwFwUbJ6BWD5nhm76xlPbGZ35i+cn1G5OknQ2ulGpD
        RlpjyLGE73TVlW1p6bYa1qSP2r1o/Sdn930dCWG65cfVq4+U
X-Google-Smtp-Source: ABdhPJyfAVpGu+Ap2ZipojX71v/uVILYtXP1eQDZ7okPmqpE5TLsKyaXV4LC/jLyDrgDuXfR80TtB4kX8ZpQdEVt95N51tsXLwSn
MIME-Version: 1.0
X-Received: by 2002:a02:c8c6:: with SMTP id q6mr12316526jao.76.1600075159144;
 Mon, 14 Sep 2020 02:19:19 -0700 (PDT)
Date:   Mon, 14 Sep 2020 02:19:19 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000799c1c05af42878b@google.com>
Subject: WARNING in taprio_change
From:   syzbot <syzbot+d50710fd0873a9c6b40c@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        vinicius.gomes@intel.com, xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    5760d9ac net: ethernet: ti: cpsw_new: fix suspend/resume
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=14c4e053900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bd46548257448703
dashboard link: https://syzkaller.appspot.com/bug?extid=d50710fd0873a9c6b40c
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=123345a5900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15727cf1900000

The issue was bisected to:

commit b5b73b26b3ca34574124ed7ae9c5ba8391a7f176
Author: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Date:   Thu Sep 10 00:03:11 2020 +0000

    taprio: Fix allowing too small intervals

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14cf2d59900000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=16cf2d59900000
console output: https://syzkaller.appspot.com/x/log.txt?x=12cf2d59900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d50710fd0873a9c6b40c@syzkaller.appspotmail.com
Fixes: b5b73b26b3ca ("taprio: Fix allowing too small intervals")

netdevsim netdevsim0 netdevsim1: set [1, 0] type 2 family 0 port 6081 - 0
netdevsim netdevsim0 netdevsim2: set [1, 0] type 2 family 0 port 6081 - 0
netdevsim netdevsim0 netdevsim3: set [1, 0] type 2 family 0 port 6081 - 0
------------[ cut here ]------------
WARNING: CPU: 1 PID: 6841 at net/sched/sch_taprio.c:998 taprio_get_start_time net/sched/sch_taprio.c:998 [inline]
WARNING: CPU: 1 PID: 6841 at net/sched/sch_taprio.c:998 taprio_change+0x1e12/0x2b60 net/sched/sch_taprio.c:1549
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 6841 Comm: syz-executor809 Not tainted 5.9.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x198/0x1fd lib/dump_stack.c:118
 panic+0x347/0x7c0 kernel/panic.c:231
 __warn.cold+0x20/0x46 kernel/panic.c:600
 report_bug+0x1bd/0x210 lib/bug.c:198
 handle_bug+0x38/0x90 arch/x86/kernel/traps.c:234
 exc_invalid_op+0x14/0x40 arch/x86/kernel/traps.c:254
 asm_exc_invalid_op+0x12/0x20 arch/x86/include/asm/idtentry.h:536
RIP: 0010:taprio_get_start_time net/sched/sch_taprio.c:998 [inline]
RIP: 0010:taprio_change+0x1e12/0x2b60 net/sched/sch_taprio.c:1549
Code: 8b 44 24 08 41 bf ea ff ff ff 48 c7 00 c0 af 03 89 e8 52 9b 06 fb 48 8b 7c 24 10 e8 28 63 89 01 e9 6b eb ff ff e8 3e 9b 06 fb <0f> 0b 48 83 7c 24 08 00 74 2e e8 2f 9b 06 fb 48 8b 54 24 08 48 b8
RSP: 0018:ffffc9000515f2b8 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffffff866dab09
RDX: ffff8880a643a240 RSI: ffffffff866dafc2 RDI: 0000000000000007
RBP: 16341fa0ca8d0652 R08: 0000000000000001 R09: ffffffff8c5f4aa7
R10: 0000000000000000 R11: 0000000000086848 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000002 R15: 0000000000000000
 taprio_init+0x52e/0x670 net/sched/sch_taprio.c:1693
 qdisc_create+0x4b6/0x12e0 net/sched/sch_api.c:1246
 tc_modify_qdisc+0x4c8/0x1990 net/sched/sch_api.c:1662
 rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5563
 netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2470
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
RIP: 0033:0x443839
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 fb 0f fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffe06fb51e8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000443839
RDX: 0000000000000000 RSI: 00000000200007c0 RDI: 0000000000000004
RBP: 00007ffe06fb51f0 R08: 0000000001bbbbbb R09: 0000000001bbbbbb
R10: 0000000001bbbbbb R11: 0000000000000246 R12: 00007ffe06fb5200
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
