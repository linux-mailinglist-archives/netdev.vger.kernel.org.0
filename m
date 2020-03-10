Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2103180B46
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 23:15:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727806AbgCJWPS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 18:15:18 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:34709 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727782AbgCJWPR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 18:15:17 -0400
Received: by mail-il1-f197.google.com with SMTP id l13so516ils.1
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 15:15:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=p9Z10uZr2dUftOQEwj/f8j0GgUMs/WLna+BjnNkGBVU=;
        b=SSuu7alMJcNewEYfaOLyaYSpVm927KBk7O39ZgxnohgqvXHNUGyQEvuVWSJFab2Oq/
         j12lxhEodcT3pn/cJAT+2TFoA1hXZluFXrdqvwIRtPvHkmNHJ1Rhin/a50rWHkuE+e07
         /FxEte5XIfyxj67mih+dqqiQzNJkCKCNz4eOFX3iZYVsak2udJr8skKJIKqbDKoC9xl6
         D6yTsvnlxeyNryiiu/DbJK1vbEOfJaaNjWgdMLPNrTabT0XxFHRU3+Fmm0upUF6OhhAx
         wuZ5fbKHAUqNh9kgAh6GIaVqN5Nsm+TDwOT0u8Sh+6IquHKYznGT0NHB6f9DtQl7fg5L
         PyUQ==
X-Gm-Message-State: ANhLgQ24nlbX0SwhWtFR19kGnTERNIWi5eIWRUjf1VdxXvUUFtsWxOcX
        4SkBsPtu6U/ux00DwAy4Kffen54Yz3mpGbDKuhdx23JURzT8
X-Google-Smtp-Source: ADFU+vsxsQZdpI/bjmW6FBVZ/hLlGOzNVlor54L+Ax5iFbdOzl+uyF9q3oHAjdk7lsfklf9+rDxKSWAqA8IMj0L9pNgb7HknZPTo
MIME-Version: 1.0
X-Received: by 2002:a02:3b24:: with SMTP id c36mr296767jaa.23.1583878517117;
 Tue, 10 Mar 2020 15:15:17 -0700 (PDT)
Date:   Tue, 10 Mar 2020 15:15:17 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000061573105a08774c2@google.com>
Subject: WARNING: ODEBUG bug in route4_change
From:   syzbot <syzbot+f9b32aaacd60305d9687@syzkaller.appspotmail.com>
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

HEAD commit:    2c523b34 Linux 5.6-rc5
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12a150b1e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c2e311dba9a02ba9
dashboard link: https://syzkaller.appspot.com/bug?extid=f9b32aaacd60305d9687
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=172ae81de00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16ffee2de00000

Bisection is inconclusive: the bug happens on the oldest tested release.

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14132075e00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=16132075e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=12132075e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+f9b32aaacd60305d9687@syzkaller.appspotmail.com

------------[ cut here ]------------
ODEBUG: activate active (active state 1) object type: rcu_head hint: 0x0
WARNING: CPU: 1 PID: 9831 at lib/debugobjects.c:485 debug_print_object+0x160/0x250 lib/debugobjects.c:485
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 9831 Comm: syz-executor043 Not tainted 5.6.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 panic+0x2e3/0x75c kernel/panic.c:221
 __warn.cold+0x2f/0x35 kernel/panic.c:582
 report_bug+0x27b/0x2f0 lib/bug.c:195
 fixup_bug arch/x86/kernel/traps.c:174 [inline]
 fixup_bug arch/x86/kernel/traps.c:169 [inline]
 do_error_trap+0x12b/0x220 arch/x86/kernel/traps.c:267
 do_invalid_op+0x32/0x40 arch/x86/kernel/traps.c:286
 invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
RIP: 0010:debug_print_object+0x160/0x250 lib/debugobjects.c:485
Code: dd c0 f3 51 88 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 bf 00 00 00 48 8b 14 dd c0 f3 51 88 48 c7 c7 20 e9 51 88 e8 78 d9 b1 fd <0f> 0b 83 05 0b b7 d3 06 01 48 83 c4 20 5b 5d 41 5c 41 5d c3 48 89
RSP: 0018:ffffc90002137178 EFLAGS: 00010282
RAX: 0000000000000000 RBX: 0000000000000003 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff815bf4f1 RDI: fffff52000426e21
RBP: 0000000000000001 R08: ffff888098cbc100 R09: ffffed1015ce6659
R10: ffffed1015ce6658 R11: ffff8880ae7332c7 R12: ffffffff897acba0
R13: 0000000000000000 R14: dffffc0000000000 R15: 1ffff92000426e3c
 debug_object_activate+0x346/0x470 lib/debugobjects.c:652
 debug_rcu_head_queue kernel/rcu/rcu.h:176 [inline]
 __call_rcu kernel/rcu/tree.c:2597 [inline]
 call_rcu+0x2c/0x690 kernel/rcu/tree.c:2683
 queue_rcu_work+0x82/0xa0 kernel/workqueue.c:1742
 route4_change+0x19e8/0x2250 net/sched/cls_route.c:550
 tc_new_tfilter+0xa59/0x20b0 net/sched/cls_api.c:2103
 rtnetlink_rcv_msg+0x810/0xad0 net/core/rtnetlink.c:5427
 netlink_rcv_skb+0x15a/0x410 net/netlink/af_netlink.c:2478
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x537/0x740 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x882/0xe10 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6b9/0x7d0 net/socket.c:2343
 ___sys_sendmsg+0x100/0x170 net/socket.c:2397
 __sys_sendmsg+0xec/0x1b0 net/socket.c:2430
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x446709
Code: e8 1c ba 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 ab 0e fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ff3a3e0dd98 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
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
