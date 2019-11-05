Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8A2DEF474
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 05:22:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730472AbfKEEWO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 23:22:14 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:34161 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730378AbfKEEWM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 23:22:12 -0500
Received: by mail-io1-f71.google.com with SMTP id a13so5635030iol.1
        for <netdev@vger.kernel.org>; Mon, 04 Nov 2019 20:22:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=nzhB6t6GYqWdTuZxa3n2pSbQxzrHEwMlNU6t70A2zlE=;
        b=D17yylIrceAHwDfLShI12qCwqqLPrPn5Bt98cyzedJBh32nOsofMaa82q0EXXT0fmJ
         M89hQCV0N2UGyFIpEW6lCpX78V5/eQayBnYWqlWHbL06dPTlWmIVtj0p4MojtLk7H/H6
         oBCnz/nsEAcl6RaGSSP8VmvdEwLYSKDxnFmEn41/SB5I9z9lSoUqfd1VpP2M+vEAtisl
         vCY/H/VTrT/u0NZOGgHb7Yp7JhEG6QCqmeHTg6mnLcBPPHO7fn8yytQCA+wRruj9JhHy
         C35O1W0hFc5ENVGQxMdDnItobeFQYkOtAkPn6tYE6U5y0rOPtkmhErKViLACUuhF1nj0
         1pdA==
X-Gm-Message-State: APjAAAVu3tDb1UjFn6JfKZkj9PkhFcIltl44b1nTjq1/CpC2QPUlKBSy
        oWMlF+Q5kde/W6T40KJzozq6KHoFX0cgf7IptOapfBqEtorT
X-Google-Smtp-Source: APXvYqy8pZUlkeERPGzDv0JhsIytR2Tg4h/QzXsYn8TLLS1lgg87O7g7dIwap4iABmt9CGpWO0F7z5Vg08qm06NJzIQRDTvyUF5v
MIME-Version: 1.0
X-Received: by 2002:a6b:7c42:: with SMTP id b2mr7400167ioq.184.1572927730236;
 Mon, 04 Nov 2019 20:22:10 -0800 (PST)
Date:   Mon, 04 Nov 2019 20:22:10 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009e481a059691c6fe@google.com>
Subject: general protection fault in j1939_netdev_notify
From:   syzbot <syzbot+95c8e0d9dffde15b6c5c@syzkaller.appspotmail.com>
To:     bst@pengutronix.de, davem@davemloft.net,
        dev.kurt@vandijck-laurijssen.be, ecathinds@gmail.com,
        kernel@pengutronix.de, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@rempel-privat.de,
        lkp@intel.com, maxime.jayat@mobile-devices.fr, mkl@pengutronix.de,
        netdev@vger.kernel.org, o.rempel@pengutronix.de, robin@protonic.nl,
        socketcan@hartkopp.net, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    a99d8080 Linux 5.4-rc6
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14303cdce00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=896c87b73c6fcda6
dashboard link: https://syzkaller.appspot.com/bug?extid=95c8e0d9dffde15b6c5c
compiler:       clang version 9.0.0 (/home/glider/llvm/clang  
80fee25776c2fb61e74c1ecb1a523375c2500b69)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12a4e444e00000

The bug was bisected to:

commit 9d71dd0c70099914fcd063135da3c580865e924c
Author: The j1939 authors <linux-can@vger.kernel.org>
Date:   Mon Oct 8 09:48:36 2018 +0000

     can: add support of SAE J1939 protocol

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14f90314e00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=16f90314e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=12f90314e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+95c8e0d9dffde15b6c5c@syzkaller.appspotmail.com
Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")

kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 8092 Comm: syz-executor.0 Not tainted 5.4.0-rc6 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:j1939_ndev_to_priv net/can/j1939/main.c:210 [inline]
RIP: 0010:j1939_priv_get_by_ndev_locked net/can/j1939/main.c:222 [inline]
RIP: 0010:j1939_priv_get_by_ndev net/can/j1939/main.c:234 [inline]
RIP: 0010:j1939_netdev_notify+0x10a/0x2c0 net/can/j1939/main.c:344
Code: 88 05 00 00 4c 89 e0 48 c1 e8 03 42 80 3c 28 00 74 08 4c 89 e7 e8 36  
95 fc fa bb 28 60 00 00 49 03 1c 24 48 89 d8 48 c1 e8 03 <42> 80 3c 28 00  
74 08 48 89 df e8 17 95 fc fa 4c 8b 2b 4d 85 ed 0f
RSP: 0018:ffff8880a58579d0 EFLAGS: 00010206
RAX: 0000000000000c05 RBX: 0000000000006028 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000118 RDI: 0000000000000118
RBP: ffff8880a5857a00 R08: ffffffff86afeeb1 R09: ffffed1014b0af2f
R10: ffffed1014b0af2f R11: 0000000000000000 R12: ffff8880a5a90588
R13: dffffc0000000000 R14: ffff8880a5a9023c R15: 1ffff11014b52047
FS:  0000000001356940(0000) GS:ffff8880aeb00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f1d28a0616b CR3: 0000000099ed7000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  notifier_call_chain kernel/notifier.c:95 [inline]
  __raw_notifier_call_chain kernel/notifier.c:396 [inline]
  raw_notifier_call_chain+0xec/0x190 kernel/notifier.c:403
  call_netdevice_notifiers_info net/core/dev.c:1668 [inline]
  call_netdevice_notifiers_extack net/core/dev.c:1680 [inline]
  call_netdevice_notifiers net/core/dev.c:1694 [inline]
  rollback_registered_many+0xbd6/0x11c0 net/core/dev.c:8522
  rollback_registered net/core/dev.c:8564 [inline]
  unregister_netdevice_queue+0x2ce/0x480 net/core/dev.c:9656
  unregister_netdevice include/linux/netdevice.h:2637 [inline]
  unregister_netdev+0x1c/0x30 net/core/dev.c:9697
  slip_close+0x160/0x190 drivers/net/slip/slip.c:895
  tty_ldisc_close+0x126/0x180 drivers/tty/tty_ldisc.c:494
  tty_ldisc_kill drivers/tty/tty_ldisc.c:642 [inline]
  tty_ldisc_release+0x248/0x5a0 drivers/tty/tty_ldisc.c:814
  tty_release_struct+0x2a/0xe0 drivers/tty/tty_io.c:1612
  tty_release+0xce9/0xfa0 drivers/tty/tty_io.c:1785
  __fput+0x2e4/0x740 fs/file_table.c:280
  ____fput+0x15/0x20 fs/file_table.c:313
  task_work_run+0x17e/0x1b0 kernel/task_work.c:113
  tracehook_notify_resume include/linux/tracehook.h:188 [inline]
  exit_to_usermode_loop arch/x86/entry/common.c:163 [inline]
  prepare_exit_to_usermode+0x459/0x580 arch/x86/entry/common.c:194
  syscall_return_slowpath+0x113/0x4a0 arch/x86/entry/common.c:274
  do_syscall_64+0x11f/0x1c0 arch/x86/entry/common.c:300
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x413d90
Code: 01 f0 ff ff 0f 83 30 1b 00 00 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f  
44 00 00 83 3d 7d 42 66 00 00 75 14 b8 03 00 00 00 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 04 1b 00 00 c3 48 83 ec 08 e8 0a fc ff ff
RSP: 002b:00007ffec2dd6688 EFLAGS: 00000246 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000004 RCX: 0000000000413d90
RDX: 0000001b33020000 RSI: 0000000000000000 RDI: 0000000000000003
RBP: 0000000000000001 R08: 0000000000000000 R09: ffffffffffffffff
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000075bf20
R13: 0000000000000003 R14: 00000000007601c8 R15: 000000000075bf2c
Modules linked in:
---[ end trace 8207e28d10fcf54c ]---
RIP: 0010:j1939_ndev_to_priv net/can/j1939/main.c:210 [inline]
RIP: 0010:j1939_priv_get_by_ndev_locked net/can/j1939/main.c:222 [inline]
RIP: 0010:j1939_priv_get_by_ndev net/can/j1939/main.c:234 [inline]
RIP: 0010:j1939_netdev_notify+0x10a/0x2c0 net/can/j1939/main.c:344
Code: 88 05 00 00 4c 89 e0 48 c1 e8 03 42 80 3c 28 00 74 08 4c 89 e7 e8 36  
95 fc fa bb 28 60 00 00 49 03 1c 24 48 89 d8 48 c1 e8 03 <42> 80 3c 28 00  
74 08 48 89 df e8 17 95 fc fa 4c 8b 2b 4d 85 ed 0f
RSP: 0018:ffff8880a58579d0 EFLAGS: 00010206
RAX: 0000000000000c05 RBX: 0000000000006028 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000118 RDI: 0000000000000118
RBP: ffff8880a5857a00 R08: ffffffff86afeeb1 R09: ffffed1014b0af2f
R10: ffffed1014b0af2f R11: 0000000000000000 R12: ffff8880a5a90588
R13: dffffc0000000000 R14: ffff8880a5a9023c R15: 1ffff11014b52047
FS:  0000000001356940(0000) GS:ffff8880aeb00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f1d28a0616b CR3: 0000000099ed7000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
