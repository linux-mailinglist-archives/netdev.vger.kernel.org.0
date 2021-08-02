Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E5033DCF1C
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 06:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230297AbhHBEH2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 00:07:28 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:56177 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbhHBEH2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 00:07:28 -0400
Received: by mail-il1-f200.google.com with SMTP id x16-20020a9206100000b02902166568c213so7715463ilg.22
        for <netdev@vger.kernel.org>; Sun, 01 Aug 2021 21:07:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=9Wk7WJ2AalfetOwN+B2EmORMek+8iV47E0Dl7NfLfdE=;
        b=cBKTErqt4uBBAz5LTg8eU4KfMaXCBoqJ2CEYluilhv1/oQhyfWkprFn7f19OU3y9Ec
         9UT9VFRD181mfRiu0BPxxYj/Qe2wpyhtgCuPxJcrm+DYgTSSMTG4WDNrOXe0QEpija6L
         Jptf/HzKdnn5yOvvGzDNazF7Q6tlDfjx0gaPFj2D5iYyWRpcYS75JwRxp3YK7Vga74W9
         vpSATTJbsw253+KJhK16q93kD+3G/fGH17VT1BR3CcJgpgA4YXBRC4aZN3QBZOLh+R7p
         7GDchjCkO78AJDWIL7hGykZGf7gRIXfUCGSJYXgjbK4Y/iw7uV/dOPZT+ROI3C23Lw4f
         2Zmw==
X-Gm-Message-State: AOAM531/3rBXi0I/FO1kM6wbjJLTW6BIXS8we5jYSHs2EXp5T8mb/Xw5
        xYcwuDNF8sBS30hoNdUorP52RfBsNwlwjU6t3k6nYx86GNIH
X-Google-Smtp-Source: ABdhPJxYKgvtJeSsOJsK3ivfttNjcCGN7qbfp5MXh+tl/+q9dLKCM9D7cpnrWBxCnwg7WtHfvFpmmkUn5lcFTjq9wJvq5y8eImxC
MIME-Version: 1.0
X-Received: by 2002:a5e:9918:: with SMTP id t24mr516718ioj.24.1627877238118;
 Sun, 01 Aug 2021 21:07:18 -0700 (PDT)
Date:   Sun, 01 Aug 2021 21:07:18 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000084201105c88bb48a@google.com>
Subject: [syzbot] general protection fault in hci_release_dev
From:   syzbot <syzbot+47c6d0efbb7fe2f7a5b8@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        luiz.dentz@gmail.com, luiz.von.dentz@intel.com,
        marcel@holtmann.org, netdev@vger.kernel.org,
        penguin-kernel@I-love.SAKURA.ne.jp,
        penguin-kernel@i-love.sakura.ne.jp, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    5a4cee98ea75 Add linux-next specific files for 20210728
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=146e451e300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=143f7094479da395
dashboard link: https://syzkaller.appspot.com/bug?extid=47c6d0efbb7fe2f7a5b8
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=118c3162300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10500872300000

The issue was bisected to:

commit 73333364afebb5e45807139bc79e6a6574c1874b
Author: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date:   Mon Jul 26 21:12:04 2021 +0000

    Bluetooth: defer cleanup of resources in hci_unregister_dev()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=169b6346300000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=159b6346300000
console output: https://syzkaller.appspot.com/x/log.txt?x=119b6346300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+47c6d0efbb7fe2f7a5b8@syzkaller.appspotmail.com
Fixes: 73333364afeb ("Bluetooth: defer cleanup of resources in hci_unregister_dev()")

general protection fault, probably for non-canonical address 0xdffffc0000000023: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000118-0x000000000000011f]
CPU: 1 PID: 8467 Comm: syz-executor744 Not tainted 5.14.0-rc3-next-20210728-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:workqueue_sysfs_unregister kernel/workqueue.c:5732 [inline]
RIP: 0010:destroy_workqueue+0x2e/0x800 kernel/workqueue.c:4386
Code: 49 89 fe 41 55 41 54 55 53 48 83 ec 08 e8 aa 5c 29 00 49 8d be 18 01 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 2e 07 00 00 49 8b 9e 18 01 00 00 48 85 db 74 19
RSP: 0018:ffffc90009577a98 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: dffffc0000000000 RCX: 0000000000000000
RDX: 0000000000000023 RSI: ffffffff814c5bc6 RDI: 0000000000000118
RBP: ffff8880131ad340 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff81a39748 R11: 0000000000000000 R12: ffff8880131ac000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000480da8 CR3: 000000000b68e000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 hci_release_dev+0x125/0xb70 net/bluetooth/hci_core.c:4048
 bt_host_release+0x15/0x20 net/bluetooth/hci_sysfs.c:86
 device_release+0x9f/0x240 drivers/base/core.c:2193
 kobject_cleanup lib/kobject.c:705 [inline]
 kobject_release lib/kobject.c:736 [inline]
 kref_put include/linux/kref.h:65 [inline]
 kobject_put+0x1c8/0x540 lib/kobject.c:753
 put_device+0x1b/0x30 drivers/base/core.c:3463
 hci_uart_tty_close+0x1e4/0x2a0 drivers/bluetooth/hci_ldisc.c:546
 tty_ldisc_close+0x110/0x190 drivers/tty/tty_ldisc.c:474
 tty_ldisc_kill+0x94/0x150 drivers/tty/tty_ldisc.c:629
 tty_ldisc_release+0xe3/0x2a0 drivers/tty/tty_ldisc.c:803
 tty_release_struct+0x20/0xe0 drivers/tty/tty_io.c:1706
 tty_release+0xc70/0x1200 drivers/tty/tty_io.c:1878
 __fput+0x288/0x920 fs/file_table.c:280
 task_work_run+0xdd/0x1a0 kernel/task_work.c:164
 exit_task_work include/linux/task_work.h:32 [inline]
 do_exit+0xbd4/0x2a60 kernel/exit.c:825
 do_group_exit+0x125/0x310 kernel/exit.c:922
 __do_sys_exit_group kernel/exit.c:933 [inline]
 __se_sys_exit_group kernel/exit.c:931 [inline]
 __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:931
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x43da49
Code: Unable to access opcode bytes at RIP 0x43da1f.
RSP: 002b:00007ffc6bba0fb8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 00000000004ae230 RCX: 000000000043da49
RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffffffffffffffc0 R09: 0000000000400488
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000004ae230
R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000001
Modules linked in:
---[ end trace 516dd52cdf23e662 ]---
RIP: 0010:workqueue_sysfs_unregister kernel/workqueue.c:5732 [inline]
RIP: 0010:destroy_workqueue+0x2e/0x800 kernel/workqueue.c:4386
Code: 49 89 fe 41 55 41 54 55 53 48 83 ec 08 e8 aa 5c 29 00 49 8d be 18 01 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 2e 07 00 00 49 8b 9e 18 01 00 00 48 85 db 74 19
RSP: 0018:ffffc90009577a98 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: dffffc0000000000 RCX: 0000000000000000
RDX: 0000000000000023 RSI: ffffffff814c5bc6 RDI: 0000000000000118
RBP: ffff8880131ad340 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff81a39748 R11: 0000000000000000 R12: ffff8880131ac000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000480da8 CR3: 000000000b68e000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
