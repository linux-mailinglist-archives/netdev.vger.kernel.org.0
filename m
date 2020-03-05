Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6DF317AE67
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 19:45:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbgCESpP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 13:45:15 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:44347 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726440AbgCESpM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 13:45:12 -0500
Received: by mail-io1-f71.google.com with SMTP id q13so4685500iob.11
        for <netdev@vger.kernel.org>; Thu, 05 Mar 2020 10:45:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Us+arUmf9LULLEoI/2RUiRYdXpjh+bbbhvxTGcbSIJI=;
        b=XpHRTk/OyMzheP5TQu3yaxuf9dTNs4rnN5YXkeIcxCUXd3atCN4EiGIsNFtVjq05cW
         oifXiBgpZXn3Qy9aZGiEmlIOrpmrNF1RHZIsZGifCl/zqtqa8XeQBjYhg5ICJ1MHw1yq
         kGiiQSlr7vf/mvc/7nSi8r+WoOUJ+jPKkz8YTEnBt7qVxQHLDdm7lbKFLC+VMnb0uoeL
         1LRHjigonxx6ngvLPRRDlCcbBq7WFrWQOhyQlTag7rV8hTEgSpbj08JxWJn/ZjsXLQP3
         /GR4nSyXO4R50UQ1R+SpVKgSNLoFG+cOLHOy66f2griOaljg1jnWqawZVegoKWIgDZ6r
         RPbw==
X-Gm-Message-State: ANhLgQ1t9boHRhdWoO3e604cchi1dn0i0u1XwQ8Laj/fB8NzwjOxFd50
        /fisGzpg8EYX3l6cLGczffgbB2PPcA9kS2783/cxkS9rDn3D
X-Google-Smtp-Source: ADFU+vu+HBroAP8GhX4MgZZrEGf61yyeDI3yT6EXMomMaEI8pFEs2q62sNcHi5xcO3sBL5wVv+Omd3OdQPMp01s4UvTQ+s36wQBm
MIME-Version: 1.0
X-Received: by 2002:a92:3c8d:: with SMTP id j13mr295375ilf.267.1583433910278;
 Thu, 05 Mar 2020 10:45:10 -0800 (PST)
Date:   Thu, 05 Mar 2020 10:45:10 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000bf5ff105a01fef33@google.com>
Subject: WARNING: ODEBUG bug in tcf_queue_work
From:   syzbot <syzbot+9c2df9fd5e9445b74e01@syzkaller.appspotmail.com>
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
console output: https://syzkaller.appspot.com/x/log.txt?x=10535e45e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9833e26bab355358
dashboard link: https://syzkaller.appspot.com/bug?extid=9c2df9fd5e9445b74e01
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=168c4839e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10587419e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+9c2df9fd5e9445b74e01@syzkaller.appspotmail.com

------------[ cut here ]------------
ODEBUG: activate active (active state 1) object type: rcu_head hint: 0x0
WARNING: CPU: 0 PID: 9599 at lib/debugobjects.c:485 debug_print_object+0x168/0x250 lib/debugobjects.c:485
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 9599 Comm: syz-executor772 Not tainted 5.6.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x197/0x210 lib/dump_stack.c:118
 panic+0x2e3/0x75c kernel/panic.c:221
 __warn.cold+0x2f/0x3e kernel/panic.c:582
 report_bug+0x289/0x300 lib/bug.c:195
 fixup_bug arch/x86/kernel/traps.c:174 [inline]
 fixup_bug arch/x86/kernel/traps.c:169 [inline]
 do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:267
 do_invalid_op+0x37/0x50 arch/x86/kernel/traps.c:286
 invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
RIP: 0010:debug_print_object+0x168/0x250 lib/debugobjects.c:485
Code: dd 00 e7 91 88 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 b5 00 00 00 48 8b 14 dd 00 e7 91 88 48 c7 c7 60 dc 91 88 e8 07 6e 9f fd <0f> 0b 83 05 03 6c ff 06 01 48 83 c4 20 5b 41 5c 41 5d 41 5e 5d c3
RSP: 0018:ffffc90005cd70b0 EFLAGS: 00010286
RAX: 0000000000000000 RBX: 0000000000000003 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff815ebe46 RDI: fffff52000b9ae08
RBP: ffffc90005cd70f0 R08: ffff888093472400 R09: fffffbfff16a3370
R10: fffffbfff16a336f R11: ffffffff8b519b7f R12: 0000000000000001
R13: ffffffff89bac220 R14: 0000000000000000 R15: 1ffff92000b9ae24
 debug_object_activate+0x346/0x470 lib/debugobjects.c:652
 debug_rcu_head_queue kernel/rcu/rcu.h:176 [inline]
 __call_rcu kernel/rcu/tree.c:2597 [inline]
 call_rcu+0x2f/0x700 kernel/rcu/tree.c:2683
 queue_rcu_work+0x8a/0xa0 kernel/workqueue.c:1742
 tcf_queue_work+0xd3/0x110 net/sched/cls_api.c:206
 route4_change+0x19e8/0x2250 net/sched/cls_route.c:550
 tc_new_tfilter+0xb82/0x2480 net/sched/cls_api.c:2103
 rtnetlink_rcv_msg+0x824/0xaf0 net/core/rtnetlink.c:5427
 netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2478
 rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5454
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x59e/0x7e0 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x91c/0xea0 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xd7/0x130 net/socket.c:672
 ____sys_sendmsg+0x753/0x880 net/socket.c:2343
 ___sys_sendmsg+0x100/0x170 net/socket.c:2397
 __sys_sendmsg+0x105/0x1d0 net/socket.c:2430
 __do_sys_sendmsg net/socket.c:2439 [inline]
 __se_sys_sendmsg net/socket.c:2437 [inline]
 __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2437
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x446709
Code: e8 1c ba 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 ab 0e fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fb9e0c67d98 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
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
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
