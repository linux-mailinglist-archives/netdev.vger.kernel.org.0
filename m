Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD7E9400C2D
	for <lists+netdev@lfdr.de>; Sat,  4 Sep 2021 19:13:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237086AbhIDQrh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Sep 2021 12:47:37 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:40574 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237002AbhIDQrg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Sep 2021 12:47:36 -0400
Received: by mail-io1-f69.google.com with SMTP id i26-20020a5e851a000000b005bb55343e9bso1718545ioj.7
        for <netdev@vger.kernel.org>; Sat, 04 Sep 2021 09:46:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=fuW+4MqKJiYzuC4Fnb7eSQngJs0sX+MLsGSd3K9Aq9U=;
        b=d4tQNzufvTNXISzn50z1FwD/ppeTEdFVuNsMrFKBROgyUIZ/UcETv+4n0T+IHWJRYO
         tUTHHA31tOk5gCJ7KlB9CB4u1KlElspOy8Q3l1ewJQ0JaZWehfgpb6Te2ydqCBT17Yoa
         QUcRTKyEpulGxZY03B+Lq9ntRiBDoaNByNoAkU4ocZ/biaY47UI1yD/bwZyF0JtihSOM
         gxH4bqd4WtKjmBm/8gZeh4V0MddwPENtH+6NbR/B6yHOF/TOG7Hcm1aNiwKHtapBP01H
         uNahX8F+sTAG5WnLtxN/6un8upR5zYH4oE05CCh4rVre6ZyASfDuBHbEy744yWpTEKeG
         OPVw==
X-Gm-Message-State: AOAM5301kwyT7fnqOB264BX1T1OPtaKUXXXGlMJSGbv3/4wvlhvSzYb5
        MbllNVFOxgfG3Fn/7l/+LdzrGzpsjkfL80+tIxAFjx4Cq8+X
X-Google-Smtp-Source: ABdhPJxrrDj/F2+3t7pQsqQNFCxc2bh5eyetA6+4JRPhUeFw5QBXKTpMmAAwe9uwoLDKoY0B0x608l5Up3dnKMn+g6RZEdyFE6ty
MIME-Version: 1.0
X-Received: by 2002:a05:6602:200f:: with SMTP id y15mr3656258iod.64.1630773994591;
 Sat, 04 Sep 2021 09:46:34 -0700 (PDT)
Date:   Sat, 04 Sep 2021 09:46:34 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a81af205cb2e2878@google.com>
Subject: [syzbot] WARNING: ODEBUG bug in route4_destroy
From:   syzbot <syzbot+2e3efb5eb71cb5075ba7@syzkaller.appspotmail.com>
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

HEAD commit:    57f780f1c433 atlantic: Fix driver resume flow.
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=162590a5300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=765eea9a273a8879
dashboard link: https://syzkaller.appspot.com/bug?extid=2e3efb5eb71cb5075ba7
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11979286300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14391933300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+2e3efb5eb71cb5075ba7@syzkaller.appspotmail.com

------------[ cut here ]------------
ODEBUG: activate active (active state 1) object type: rcu_head hint: 0x0
WARNING: CPU: 0 PID: 8461 at lib/debugobjects.c:505 debug_print_object+0x16e/0x250 lib/debugobjects.c:505
Modules linked in:
CPU: 0 PID: 8461 Comm: syz-executor318 Not tainted 5.14.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:debug_print_object+0x16e/0x250 lib/debugobjects.c:505
Code: ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 af 00 00 00 48 8b 14 dd e0 c8 e3 89 4c 89 ee 48 c7 c7 e0 bc e3 89 e8 f0 de 0d 05 <0f> 0b 83 05 95 53 92 09 01 48 83 c4 18 5b 5d 41 5c 41 5d 41 5e c3
RSP: 0018:ffffc9000160efb0 EFLAGS: 00010286
RAX: 0000000000000000 RBX: 0000000000000003 RCX: 0000000000000000
RDX: ffff8880224a8000 RSI: ffffffff815d85b5 RDI: fffff520002c1de8
RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff815d23ee R11: 0000000000000000 R12: ffffffff898d3320
R13: ffffffff89e3c3a0 R14: 0000000000000000 R15: ffffffff898d3320
FS:  00007f00d3339700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f00d3318718 CR3: 0000000018f1d000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 debug_object_activate+0x2da/0x3e0 lib/debugobjects.c:672
 debug_rcu_head_queue kernel/rcu/rcu.h:176 [inline]
 __call_rcu kernel/rcu/tree.c:3013 [inline]
 call_rcu+0x2c/0x750 kernel/rcu/tree.c:3109
 queue_rcu_work+0x82/0xa0 kernel/workqueue.c:1754
 route4_queue_work net/sched/cls_route.c:272 [inline]
 route4_destroy+0x4b9/0x9a0 net/sched/cls_route.c:299
 tcf_proto_destroy+0x6a/0x2d0 net/sched/cls_api.c:297
 tcf_proto_put+0x8c/0xc0 net/sched/cls_api.c:309
 tcf_chain_flush+0x21a/0x360 net/sched/cls_api.c:615
 tcf_block_flush_all_chains net/sched/cls_api.c:1016 [inline]
 __tcf_block_put+0x15a/0x510 net/sched/cls_api.c:1178
 tcf_block_put_ext net/sched/cls_api.c:1383 [inline]
 tcf_block_put_ext net/sched/cls_api.c:1375 [inline]
 tcf_block_put+0xde/0x130 net/sched/cls_api.c:1393
 drr_destroy_qdisc+0x44/0x1d0 net/sched/sch_drr.c:458
 qdisc_destroy+0xc4/0x4d0 net/sched/sch_generic.c:1025
 qdisc_put+0xcd/0xe0 net/sched/sch_generic.c:1044
 notify_and_destroy net/sched/sch_api.c:1006 [inline]
 qdisc_graft+0xc7c/0x1260 net/sched/sch_api.c:1078
 tc_modify_qdisc+0xba4/0x1a60 net/sched/sch_api.c:1674
 rtnetlink_rcv_msg+0x413/0xb80 net/core/rtnetlink.c:5575
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
 sock_sendmsg_nosec net/socket.c:703 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:723
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2394
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2448
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2477
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x445ef9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 11 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f00d3339308 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004cb468 RCX: 0000000000445ef9
RDX: 0000000000000000 RSI: 0000000020000040 RDI: 0000000000000004
RBP: 00000000004cb460 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000008 R11: 0000000000000246 R12: 00000000004cb46c
R13: 000000000049b074 R14: 6d32cc5e8ead0600 R15: 0000000000022000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
