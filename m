Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 980793E580E
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 12:14:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239765AbhHJKOs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 06:14:48 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:45945 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239746AbhHJKOq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 06:14:46 -0400
Received: by mail-io1-f69.google.com with SMTP id w19-20020a5d8a130000b0290590514c1e55so7326598iod.12
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 03:14:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=O1g4JrkA9NjMeeDfGiKWUc6Pg4ez/f2UwNV15GU1aBI=;
        b=kE9kzhbJMBcXjl0n7u5XsnRkidXgLGLX/GtutCZY2w2zlL8P0IL+thrmw3EeYzcPlj
         UFY0LRfiDTOPzvUhdVqhA8L7mNSUmoGiHaGExwDwpp0S5CpwzG21gbxYpqRnL5Zv3P9p
         IEmrlVG9zD9sgnlS/pMcGI4qfz3XDgGM0AQdvWEX6L0/0WD5+5Hxzr58s2YLQZu/R0G7
         cfjHyHwNsmdgeQaZDrHPg9tsS8AVS37BUsqnxn/bVLCdt8VvLRShbH24AUu/pOOHUBU6
         YB+1lAmXc1SMedzReMSI+26c+FQD4BtHKx1rnn2IdfqOfU9Uq0FGZZ5ww20O35PNBxpO
         k+JA==
X-Gm-Message-State: AOAM532RPVEItpbC4TmI7pleiyRWbb7slFcN93AYrfgeb7ksAO4Fmqe0
        oax5Kxh24ozglQRb9s//rXveMF1NYvT+imX4azgFfdYvPp31
X-Google-Smtp-Source: ABdhPJzmhgIjrzV3NpaMAd2D5Q0SdpgSxy9cM3nVw2Rsj/wtKGs5LQiCEQOnpA0FqudfW+b74QzVFBI6Fsdt3mN77yK0k28Ax7wQ
MIME-Version: 1.0
X-Received: by 2002:a05:6638:1b9:: with SMTP id b25mr22902549jaq.23.1628590464559;
 Tue, 10 Aug 2021 03:14:24 -0700 (PDT)
Date:   Tue, 10 Aug 2021 03:14:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001fefaf05c931c476@google.com>
Subject: [syzbot] UBSAN: array-index-out-of-bounds in taprio_change
From:   syzbot <syzbot+2b3e5fb6c7ef285a94f6@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        vinicius.gomes@intel.com, xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    36a21d51725a Linux 5.14-rc5
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=127f3379300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=730106bfb5bf8ace
dashboard link: https://syzkaller.appspot.com/bug?extid=2b3e5fb6c7ef285a94f6
compiler:       Debian clang version 11.0.1-2, GNU ld (GNU Binutils for Debian) 2.35.1

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+2b3e5fb6c7ef285a94f6@syzkaller.appspotmail.com

UBSAN: array-index-out-of-bounds in net/sched/sch_taprio.c:1519:10
index 16 is out of range for type '__u16 [16]'
CPU: 0 PID: 13032 Comm: syz-executor.2 Not tainted 5.14.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x1d3/0x29f lib/dump_stack.c:105
 ubsan_epilogue lib/ubsan.c:148 [inline]
 __ubsan_handle_out_of_bounds+0xdb/0x130 lib/ubsan.c:288
 taprio_change+0x33d0/0x5c90 net/sched/sch_taprio.c:1519
 qdisc_create+0x7c2/0x1480 net/sched/sch_api.c:1247
 tc_modify_qdisc+0xa88/0x1ea0 net/sched/sch_api.c:1646
 rtnetlink_rcv_msg+0x91c/0xe50 net/core/rtnetlink.c:5574
 netlink_rcv_skb+0x1f0/0x460 net/netlink/af_netlink.c:2504
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x7de/0x9b0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x9e7/0xe00 net/netlink/af_netlink.c:1929
 sock_sendmsg_nosec net/socket.c:703 [inline]
 sock_sendmsg net/socket.c:723 [inline]
 ____sys_sendmsg+0x5a2/0x900 net/socket.c:2392
 ___sys_sendmsg net/socket.c:2446 [inline]
 __sys_sendmsg+0x319/0x400 net/socket.c:2475
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4665e9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f399085a188 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 000000000056bf80 RCX: 00000000004665e9
RDX: 0000000000000000 RSI: 00000000200007c0 RDI: 0000000000000007
RBP: 00000000004bfcc4 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf80
R13: 00007ffe9b94383f R14: 00007f399085a300 R15: 0000000000022000
================================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
