Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3A43ED264
	for <lists+netdev@lfdr.de>; Sun,  3 Nov 2019 08:32:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727156AbfKCHcK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Nov 2019 02:32:10 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:37022 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726408AbfKCHcK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Nov 2019 02:32:10 -0500
Received: by mail-il1-f198.google.com with SMTP id u68so12851393ilc.4
        for <netdev@vger.kernel.org>; Sun, 03 Nov 2019 00:32:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=OxWi94xHP31q5a9KApVWh0caRuymGgMlgK/O/hLQdiM=;
        b=O7UsxztovR83WJCuEzNfXsklPcTF+zJJ89XFfpbqCnLJVBgl85qUCD68QT38enmnKt
         kZTRaT9PZhiBoRS/Ok1UWVU9e8UDR6ztmmWpwAzlxSAJxZgs3Qm7UjeyEdH/Ci7yVDu0
         NgqXJ3nZIzuGHpQMSsvkd7GCsm1cc7dYR3TjGqFC4BBRH5X4xD5srWCBXuyJK/AmYJN5
         FQk0d4lIGQ1hmwr+Gd7+EdxrHKX2igm27CvYgnsVNSZoOhXGvkiVzPx5NPJxnt0ei/1L
         V4hki65iQMrL2jPKiw8RyxjIT/yZ4OVFtJOPElMnhYZUmxVLiTkhaRyNlhsx29/NrX8P
         GSdg==
X-Gm-Message-State: APjAAAUjHg7fgWxBQWFkDfkgkJsZEs7CjjCKPZaVUHSA7a+o83bUbzh2
        e5vA3S+R13ixweFpisFteuGhjPNKE9V7NCelVzl/x91k0odo
X-Google-Smtp-Source: APXvYqwx8axyi1n5oNv2qIOcSdMZnOXjXYppWlnlU7QlEY9jEb/qgC3xcn5wilu8IkYhXVt7AUijeM9eL4UP8M/HfH/aw6wSSlno
MIME-Version: 1.0
X-Received: by 2002:a05:6638:626:: with SMTP id h6mr2440063jar.113.1572766328902;
 Sun, 03 Nov 2019 00:32:08 -0700 (PDT)
Date:   Sun, 03 Nov 2019 00:32:08 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000595be405966c3231@google.com>
Subject: general protection fault in j1939_priv_get_by_ndev_locked
From:   syzbot <syzbot+feff46f1778030d14234@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kernel@pengutronix.de,
        linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux@rempel-privat.de, mkl@pengutronix.de, netdev@vger.kernel.org,
        robin@protonic.nl, socketcan@hartkopp.net,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    7de08690 powerpc/bpf: Fix tail call implementation
git tree:       bpf
console output: https://syzkaller.appspot.com/x/log.txt?x=178ba242e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2cc209e226c8fbbd
dashboard link: https://syzkaller.appspot.com/bug?extid=feff46f1778030d14234
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1726e97ce00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1678e4ece00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+feff46f1778030d14234@syzkaller.appspotmail.com

kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 8769 Comm: syz-executor448 Not tainted 5.4.0-rc3+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:j1939_ndev_to_priv net/can/j1939/main.c:210 [inline]
RIP: 0010:j1939_priv_get_by_ndev_locked+0xf5/0x190 net/can/j1939/main.c:222
Code: 03 80 3c 02 00 0f 85 ae 00 00 00 48 8b 9b 88 05 00 00 48 b8 00 00 00  
00 00 fc ff df 48 8d bb 28 60 00 00 48 89 fa 48 c1 ea 03 <80> 3c 02 00 75  
7f 4c 8b a3 28 60 00 00 4d 85 e4 74 12 e8 e4 9c f4
RSP: 0018:ffff8880949bf8e8 EFLAGS: 00010206
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff867e77c7
RDX: 0000000000000c05 RSI: ffffffff867e77d4 RDI: 0000000000006028
RBP: ffff8880949bf900 R08: ffff8880a879c340 R09: ffffed1012937f10
R10: ffffed1012937f0f R11: 0000000000000003 R12: 0000000000000000
R13: 0000000000000118 R14: dffffc0000000000 R15: 0000000000000000
FS:  0000000000789880(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f8c146c1518 CR3: 000000009fc92000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  j1939_priv_get_by_ndev net/can/j1939/main.c:234 [inline]
  j1939_netdev_notify+0x47/0x120 net/can/j1939/main.c:344
  notifier_call_chain+0xc2/0x230 kernel/notifier.c:95
  __raw_notifier_call_chain kernel/notifier.c:396 [inline]
  raw_notifier_call_chain+0x2e/0x40 kernel/notifier.c:403
  call_netdevice_notifiers_info+0x3f/0x90 net/core/dev.c:1668
  call_netdevice_notifiers_extack net/core/dev.c:1680 [inline]
  call_netdevice_notifiers net/core/dev.c:1694 [inline]
  rollback_registered_many+0x9b9/0xfc0 net/core/dev.c:8521
  rollback_registered+0x109/0x1d0 net/core/dev.c:8563
  unregister_netdevice_queue net/core/dev.c:9655 [inline]
  unregister_netdevice_queue+0x1ee/0x2c0 net/core/dev.c:9648
  unregister_netdevice include/linux/netdevice.h:2637 [inline]
  __tun_detach+0xd8a/0x1040 drivers/net/tun.c:723
  tun_detach drivers/net/tun.c:740 [inline]
  tun_chr_close+0xe0/0x180 drivers/net/tun.c:3448
  __fput+0x2ff/0x890 fs/file_table.c:280
  ____fput+0x16/0x20 fs/file_table.c:313
  task_work_run+0x145/0x1c0 kernel/task_work.c:113
  exit_task_work include/linux/task_work.h:22 [inline]
  do_exit+0x904/0x2e60 kernel/exit.c:817
  do_group_exit+0x135/0x360 kernel/exit.c:921
  __do_sys_exit_group kernel/exit.c:932 [inline]
  __se_sys_exit_group kernel/exit.c:930 [inline]
  __x64_sys_exit_group+0x44/0x50 kernel/exit.c:930
  do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x43ee08
Code: Bad RIP value.
RSP: 002b:00007fff3faf5578 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 000000000043ee08
RDX: 0000000000000000 RSI: 000000000000003c RDI: 0000000000000000
RBP: 00000000004be608 R08: 00000000000000e7 R09: ffffffffffffffd0
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
R13: 00000000006d0180 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
---[ end trace 78c1c985ae8b77ec ]---
RIP: 0010:j1939_ndev_to_priv net/can/j1939/main.c:210 [inline]
RIP: 0010:j1939_priv_get_by_ndev_locked+0xf5/0x190 net/can/j1939/main.c:222
Code: 03 80 3c 02 00 0f 85 ae 00 00 00 48 8b 9b 88 05 00 00 48 b8 00 00 00  
00 00 fc ff df 48 8d bb 28 60 00 00 48 89 fa 48 c1 ea 03 <80> 3c 02 00 75  
7f 4c 8b a3 28 60 00 00 4d 85 e4 74 12 e8 e4 9c f4
RSP: 0018:ffff8880949bf8e8 EFLAGS: 00010206
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff867e77c7
RDX: 0000000000000c05 RSI: ffffffff867e77d4 RDI: 0000000000006028
RBP: ffff8880949bf900 R08: ffff8880a879c340 R09: ffffed1012937f10
R10: ffffed1012937f0f R11: 0000000000000003 R12: 0000000000000000
R13: 0000000000000118 R14: dffffc0000000000 R15: 0000000000000000
FS:  0000000000789880(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000043edde CR3: 000000009fc92000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
