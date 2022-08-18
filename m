Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89A47597A97
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 02:24:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242455AbiHRAWg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 20:22:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242421AbiHRAWf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 20:22:35 -0400
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49A2DA59A4
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 17:22:33 -0700 (PDT)
Received: by mail-il1-f198.google.com with SMTP id n20-20020a056e02101400b002e60d4e76e6so146426ilj.15
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 17:22:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc;
        bh=ZIKDpbFX642X5vnYdY8s/VU8pIu2Qztp1WXjfE8cGUc=;
        b=aNqiKzHAi57SFA3qM1tXGnir2J3DMXUhpaX5bXMnZLOPLgOnsV3yIu9RKo0vd0j8Z2
         sF/liL2f4rRtJjmsFDjAgRNZY4RQyqwEgI8X4+xnyfYHI2XtgCCsN0yGq/BmAqvx6+Ln
         NWmf7eYyw7lGfsL93FaVdMMM+4nKzkQHLAX1vBie2dErdzkahZT9a1wW/A/SjFDvvapA
         tLlHfc3HE3/a3ewUZuC4KD0vMirjuS4ANuBq6TxzTbKegXxQ/9FPJIPd93uWZjfYZN8D
         HKzzl2dFZ84RyUboG6Uytpb0LdM4Vqce/o/Yj4ViOUd7VrmwNKXoqRZYpclI8nCLYa26
         r7IA==
X-Gm-Message-State: ACgBeo2AsI9WXS+6UbL94KZ7F9EUChJgO1sNHPaXnnWtW0qU1B4wouBC
        UERxFBLq29DtqbtlGWTfE01oY+m4XCcEo6V1NTBEyGbPs3RL
X-Google-Smtp-Source: AA6agR4dqDdT8a8bAUZPqzCu/s3zdYXTuiryDyfGOnBSSuQKpJ2csgAad08EpHMiyf6tBUj2GyPW7FRB+8zjzh6lmVrTD/LOk/hf
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:158a:b0:2d5:12f0:4dce with SMTP id
 m10-20020a056e02158a00b002d512f04dcemr294460ilu.159.1660782152641; Wed, 17
 Aug 2022 17:22:32 -0700 (PDT)
Date:   Wed, 17 Aug 2022 17:22:32 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000041f5bc05e678fa9f@google.com>
Subject: [syzbot] WARNING in __cancel_work
From:   syzbot <syzbot+10e37d0d88cbc2ea19e4@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, johan.hedberg@gmail.com,
        kuba@kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, luiz.dentz@gmail.com,
        marcel@holtmann.org, netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    7ebfc85e2cd7 Merge tag 'net-6.0-rc1' of git://git.kernel.o..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=176e9685080000
kernel config:  https://syzkaller.appspot.com/x/.config?x=20bc0b329895d963
dashboard link: https://syzkaller.appspot.com/bug?extid=10e37d0d88cbc2ea19e4
compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13537803080000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12e68315080000

Bisection is inconclusive: the issue happens on the oldest tested release.

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1639b2a5080000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1539b2a5080000
console output: https://syzkaller.appspot.com/x/log.txt?x=1139b2a5080000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+10e37d0d88cbc2ea19e4@syzkaller.appspotmail.com

------------[ cut here ]------------
ODEBUG: assert_init not available (active state 0) object type: timer_list hint: 0x0
WARNING: CPU: 1 PID: 3621 at lib/debugobjects.c:505 debug_print_object lib/debugobjects.c:502 [inline]
WARNING: CPU: 1 PID: 3621 at lib/debugobjects.c:505 debug_object_assert_init+0x1fa/0x250 lib/debugobjects.c:892
Modules linked in:
CPU: 1 PID: 3621 Comm: syz-executor370 Not tainted 5.19.0-syzkaller-13930-g7ebfc85e2cd7 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/22/2022
RIP: 0010:debug_print_object lib/debugobjects.c:502 [inline]
RIP: 0010:debug_object_assert_init+0x1fa/0x250 lib/debugobjects.c:892
Code: e8 db 3a a3 fd 4c 8b 45 00 48 c7 c7 c0 5e 0a 8b 48 c7 c6 c0 5b 0a 8b 48 c7 c2 60 60 0a 8b 31 c9 49 89 d9 31 c0 e8 86 73 17 fd <0f> 0b ff 05 da a3 eb 09 48 83 c5 38 48 89 e8 48 c1 e8 03 42 80 3c
RSP: 0018:ffffc90003d5f8d8 EFLAGS: 00010046
RAX: e412196666895900 RBX: 0000000000000000 RCX: ffff88801fda3b00
RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
RBP: ffffffff8aafbf60 R08: ffffffff816d56dd R09: ffffed1017364f14
R10: ffffed1017364f14 R11: 1ffff11017364f13 R12: dffffc0000000000
R13: ffff8880253f3200 R14: 0000000000000002 R15: ffffffff91a40048
FS:  0000555556182300(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000045b630 CR3: 0000000070ee9000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 debug_timer_assert_init kernel/time/timer.c:792 [inline]
 debug_assert_init kernel/time/timer.c:837 [inline]
 del_timer+0xa5/0x3d0 kernel/time/timer.c:1257
 try_to_grab_pending+0x150/0x820 kernel/workqueue.c:1275
 __cancel_work+0xb8/0x380 kernel/workqueue.c:3250
 l2cap_clear_timer include/net/bluetooth/l2cap.h:884 [inline]
 l2cap_chan_del+0x41c/0x610 net/bluetooth/l2cap_core.c:688
 l2cap_sock_shutdown+0x39f/0x860 net/bluetooth/l2cap_sock.c:1377
 l2cap_sock_release+0x68/0x1c0 net/bluetooth/l2cap_sock.c:1420
 __sock_release net/socket.c:650 [inline]
 sock_close+0xd7/0x260 net/socket.c:1365
 __fput+0x3b9/0x820 fs/file_table.c:320
 task_work_run+0x146/0x1c0 kernel/task_work.c:177
 ptrace_notify+0x29a/0x340 kernel/signal.c:2353
 ptrace_report_syscall include/linux/ptrace.h:420 [inline]
 ptrace_report_syscall_exit include/linux/ptrace.h:482 [inline]
 syscall_exit_work+0x8c/0xe0 kernel/entry/common.c:249
 syscall_exit_to_user_mode_prepare+0x6b/0xc0 kernel/entry/common.c:276
 __syscall_exit_to_user_mode_work kernel/entry/common.c:281 [inline]
 syscall_exit_to_user_mode+0xa/0x60 kernel/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f4b18cac08b
Code: 0f 05 48 3d 00 f0 ff ff 77 45 c3 0f 1f 40 00 48 83 ec 18 89 7c 24 0c e8 63 fc ff ff 8b 7c 24 0c 41 89 c0 b8 03 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 35 44 89 c7 89 44 24 0c e8 a1 fc ff ff 8b 44
RSP: 002b:00007ffe515692a0 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000005 RCX: 00007f4b18cac08b
RDX: ffffffffffffffb8 RSI: 0000000020000000 RDI: 0000000000000004
RBP: 0000000000000003 R08: 0000000000000000 R09: 000000ff00000001
R10: 0000000000000004 R11: 0000000000000293 R12: 00005555561822b8
R13: 0000000000000009 R14: 00007ffe51569310 R15: 0000000000000003
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
