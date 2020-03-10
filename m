Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8D6E1802C0
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 17:05:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbgCJQFM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 12:05:12 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:33709 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726514AbgCJQFL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 12:05:11 -0400
Received: by mail-io1-f70.google.com with SMTP id b4so6428626iok.0
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 09:05:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=2tittrVpC8GmJL2+XcQBR4qTl4luAaKYdn6TyydRc6g=;
        b=GlvxbFlELAn1ePJSF26ZZM5iOcxDROhtomW+eKojyuUgWHs7g0kOp5tMYoSx59bBVs
         Dcj0gkTZqIb6OKeIMvvt+P5pmn387vo99vshD74xMvhB3IP6KJcTOAjmad+v6lfmzlZZ
         oIjJeiXOzUUAcGm5cpfbbBPMTVnRSsoXe8EBAvmKyJ22C/0waMEy1G/V4i0wkA0X1he+
         1HrePaN9DU+QqfiXmuwpOJcOnmo7PdTFSbtGC0/BdqHslZX8tqwJhvyLPYzIgLaFYT/f
         aCFz1i6dgBQXVMTPrf8dzPiLGZejqpY/opt/JjCL4/miKc7hiF1Id8Fpl7YoD14pOisf
         2feA==
X-Gm-Message-State: ANhLgQ3zO5V9XJXy3BmcWTGLQ+IuZz0EUiboXAs747bwWV6ZQcywqwdT
        evYspyNMQUhWZ16P+sEDAuufln1GkBN6x4Ts76CHK+/VmQcW
X-Google-Smtp-Source: ADFU+vvalPW8+C0hK5qjtHfHmng8Gm6maxgOCCp1Ire8CqVz0g6gRZq31tr6L1PJ4yBkiPEqRIwYqqgSwz0Y7c89u8eVX/ScwsKR
MIME-Version: 1.0
X-Received: by 2002:a92:4e:: with SMTP id 75mr20512712ila.276.1583856309487;
 Tue, 10 Mar 2020 09:05:09 -0700 (PDT)
Date:   Tue, 10 Mar 2020 09:05:09 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b3cfc805a0824881@google.com>
Subject: WARNING in call_rcu
From:   syzbot <syzbot+2f8c233f131943d6056d@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    63623fd4 Merge tag 'for-linus' of git://git.kernel.org/pub..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17039f29e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5d2e033af114153f
dashboard link: https://syzkaller.appspot.com/bug?extid=2f8c233f131943d6056d
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=117bdfa1e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1472e1fde00000

Bisection is inconclusive: the bug happens on the oldest tested release.

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=155b9f29e00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=175b9f29e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=135b9f29e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+2f8c233f131943d6056d@syzkaller.appspotmail.com

------------[ cut here ]------------
ODEBUG: activate active (active state 1) object type: rcu_head hint: 0x0
WARNING: CPU: 1 PID: 8979 at lib/debugobjects.c:488 debug_print_object lib/debugobjects.c:485 [inline]
WARNING: CPU: 1 PID: 8979 at lib/debugobjects.c:488 debug_object_activate+0x5a8/0x6f0 lib/debugobjects.c:652
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 8979 Comm: syz-executor219 Not tainted 5.6.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1fb/0x318 lib/dump_stack.c:118
 panic+0x264/0x7a9 kernel/panic.c:221
 __warn+0x209/0x210 kernel/panic.c:582
 report_bug+0x1b6/0x2f0 lib/bug.c:195
 fixup_bug arch/x86/kernel/traps.c:174 [inline]
 do_error_trap+0xcf/0x1c0 arch/x86/kernel/traps.c:267
 do_invalid_op+0x36/0x40 arch/x86/kernel/traps.c:286
 invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
RIP: 0010:debug_print_object lib/debugobjects.c:485 [inline]
RIP: 0010:debug_object_activate+0x5a8/0x6f0 lib/debugobjects.c:652
Code: 74 08 4c 89 f7 e8 d8 43 0f fe 4d 8b 06 48 c7 c7 13 ec f0 88 48 c7 c6 04 4f 06 89 4c 89 ea 89 d9 4d 89 e1 31 c0 e8 08 e0 a3 fd <0f> 0b 48 ba 00 00 00 00 00 fc ff df ff 05 da eb c4 05 48 8b 5d b8
RSP: 0018:ffffc900020f73a8 EFLAGS: 00010246
RAX: eb30c415fdb00600 RBX: 0000000000000001 RCX: ffff888095774280
RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
RBP: ffffc900020f73f0 R08: ffffffff81601324 R09: ffffed1015d66618
R10: ffffed1015d66618 R11: 0000000000000000 R12: 0000000000000000
R13: ffffffff88f4c97a R14: ffffffff892d99a8 R15: ffff88809f5ecc98
 debug_rcu_head_queue kernel/rcu/rcu.h:176 [inline]
 __call_rcu kernel/rcu/tree.c:2597 [inline]
 call_rcu+0x3a/0x660 kernel/rcu/tree.c:2683
 queue_rcu_work+0x79/0x90 kernel/workqueue.c:1742
 tcf_queue_work+0xc9/0xe0 net/sched/cls_api.c:206
 route4_change+0x18e8/0x1d90 net/sched/cls_route.c:550
 tc_new_tfilter+0x1490/0x2f50 net/sched/cls_api.c:2103
 rtnetlink_rcv_msg+0x8fb/0xd40 net/core/rtnetlink.c:5427
 netlink_rcv_skb+0x19e/0x3e0 net/netlink/af_netlink.c:2478
 rtnetlink_rcv+0x1c/0x20 net/core/rtnetlink.c:5454
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x766/0x920 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0xa2b/0xd40 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg net/socket.c:672 [inline]
 ____sys_sendmsg+0x4f7/0x7f0 net/socket.c:2343
 ___sys_sendmsg net/socket.c:2397 [inline]
 __sys_sendmsg+0x1ed/0x290 net/socket.c:2430
 __do_sys_sendmsg net/socket.c:2439 [inline]
 __se_sys_sendmsg net/socket.c:2437 [inline]
 __x64_sys_sendmsg+0x7f/0x90 net/socket.c:2437
 do_syscall_64+0xf7/0x1c0 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x446709
Code: e8 1c ba 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 ab 0e fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f823766ed98 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000006dbc68 RCX: 0000000000446709
RDX: 0000000000000000 RSI: 0000000020000280 RDI: 0000000000000003
RBP: 00000000006dbc60 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000006dbc6c
R13: 0000000000000005 R14: 00a3a20740000000 R15: 0507002400000038
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
