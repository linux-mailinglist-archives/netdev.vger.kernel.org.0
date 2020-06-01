Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B73071EA2A6
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 13:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726152AbgFALaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 07:30:18 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:44490 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726110AbgFALaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 07:30:16 -0400
Received: by mail-il1-f197.google.com with SMTP id b8so8631170ilr.11
        for <netdev@vger.kernel.org>; Mon, 01 Jun 2020 04:30:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=76PgSi7ResbwYMoKhrS40AD0iAVzBpr5sDnEwLJNnTo=;
        b=sWyAJrYkDetY3rQ0riQlnkZejRzGq2RY6QzISokNjA4QhRPacCd/ElpCkcE+pBdrjr
         PJT2tjCAGbjQmQu/9Iza19q0EK5LpA9rlPdJpQn/dsFwIa3+oH9cMwh+0FdQTxO+M5Rk
         Wm2ww+bZJA3Yur6JP6BXU0OEKjZ2eUXVWXpBvKEXKhQA970DaDQEU8RmyCE2g4lpxuKj
         YmncJBFbm9do5AX58jip89apJ3ggnmS/gyHvmCf8PEXT1/rpLSEf0RGJs2Ay7rfKCW4S
         MGTp2xyXDZkHlbdEAq9tSsnf68IcA/t/xFekN+l8tbNUfLZcL5MjMpeEGh1gJpB7C52P
         kipA==
X-Gm-Message-State: AOAM530rEi8wgPpQCqdW652c8wAzTXV7dZby41kCYYlqFRlP7124pHRX
        FcPGESbuCl1GxBK2TJsFuBroYmDpo9iMyVklo6iCZhouhlKm
X-Google-Smtp-Source: ABdhPJyMgiZwLMzTP7ETQx/N6ZG11Lld0kQLasITnalB2IjInuV1ea3mw0JD+y+B2rshyB5xvx0ErBq8LfZ010fdRISNmjkVV3f1
MIME-Version: 1.0
X-Received: by 2002:a92:9a1a:: with SMTP id t26mr7096774ili.8.1591011013489;
 Mon, 01 Jun 2020 04:30:13 -0700 (PDT)
Date:   Mon, 01 Jun 2020 04:30:13 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004afcae05a7041e98@google.com>
Subject: INFO: task hung in corrupted (2)
From:   syzbot <syzbot+6921abfb75d6fc79c0eb@syzkaller.appspotmail.com>
To:     amir73il@gmail.com, andreyknvl@google.com, balbi@kernel.org,
        davem@davemloft.net, gregkh@linuxfoundation.org, jack@suse.cz,
        kuba@kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, mathew.j.martineau@linux.intel.com,
        matthieu.baerts@tessares.net, mptcp@lists.01.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    b0c3ba31 Merge tag 'fsnotify_for_v5.7-rc8' of git://git.ke..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14089eee100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ce116858301bc2ea
dashboard link: https://syzkaller.appspot.com/bug?extid=6921abfb75d6fc79c0eb
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14947d26100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=172726d2100000

The bug was bisected to:

commit f2c2e717642c66f7fe7e5dd69b2e8ff5849f4d10
Author: Andrey Konovalov <andreyknvl@google.com>
Date:   Mon Feb 24 16:13:03 2020 +0000

    usb: gadget: add raw-gadget interface

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=119e4702100000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=139e4702100000
console output: https://syzkaller.appspot.com/x/log.txt?x=159e4702100000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+6921abfb75d6fc79c0eb@syzkaller.appspotmail.com
Fixes: f2c2e717642c ("usb: gadget: add raw-gadget interface")

INFO: task syz-executor610:7072 blocked for more than 143 seconds.
      Not tainted 5.7.0-rc7-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor610 D24336  7072   7071 0x80004002
Call Trace:
 context_switch kernel/sched/core.c:3367 [inline]
 __schedule+0x805/0xc90 kernel/sched/core.c:4083

Showing all locks held in the system:
1 lock held by khungtaskd/1134:
 #0: ffffffff892e85d0 (rcu_read_lock){....}-{1:2}, at: rcu_lock_acquire+0x0/0x30 net/mptcp/pm_netlink.c:860
1 lock held by in:imklog/6715:
 #0: ffff8880a441e6b0 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0x25d/0x2f0 fs/file.c:826
6 locks held by kworker/1:0/7064:
1 lock held by syz-executor610/7072:
 #0: ffffffff892eab20 (rcu_state.exp_mutex){+.+.}-{3:3}, at: exp_funnel_lock kernel/rcu/tree_exp.h:290 [inline]
 #0: ffffffff892eab20 (rcu_state.exp_mutex){+.+.}-{3:3}, at: synchronize_rcu_expedited+0x1bd/0x5b0 kernel/rcu/tree_exp.h:856
4 locks held by systemd-udevd/7099:
 #0: ffff8880a7fdcc70 (&p->lock){+.+.}-{3:3}, at: seq_read+0x60/0xce0 fs/seq_file.c:153
 #1: ffff888096486888 (&of->mutex){+.+.}-{3:3}, at: kernfs_seq_start+0x50/0x3b0 fs/kernfs/file.c:111
 #2: ffff88809fc0d660 (kn->count#78){.+.+}-{0:0}, at: kernfs_seq_start+0x6f/0x3b0 fs/kernfs/file.c:112
 #3: ffff8880a1df7218 (&dev->mutex){....}-{3:3}, at: device_lock_interruptible include/linux/device.h:773 [inline]
 #3: ffff8880a1df7218 (&dev->mutex){....}-{3:3}, at: serial_show+0x22/0xa0 drivers/usb/core/sysfs.c:142

=============================================

NMI backtrace for cpu 0
CPU: 0 PID: 1134 Comm: khungtaskd Not tainted 5.7.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1e9/0x30e lib/dump_stack.c:118
 nmi_cpu_backtrace+0x9f/0x180 lib/nmi_backtrace.c:101
 nmi_trigger_cpumask_backtrace+0x16a/0x280 lib/nmi_backtrace.c:62
 check_hung_uninterruptible_tasks kernel/hung_task.c:205 [inline]
 watchdog+0xd2a/0xd40 kernel/hung_task.c:289
 kthread+0x353/0x380 kernel/kthread.c:268
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:351
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 PID: 7064 Comm: kworker/1:0 Not tainted 5.7.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: usb_hub_wq hub_event
RIP: 0010:__sanitizer_cov_trace_const_cmp4+0x0/0x90 kernel/kcov.c:275
Code: 4c f2 08 48 c1 e0 03 48 83 c8 18 49 89 14 02 4d 89 44 f2 18 49 ff c1 4d 89 0a c3 0f 1f 44 00 00 66 2e 0f 1f 84 00 00 00 00 00 <4c> 8b 04 24 65 48 8b 04 25 40 1e 02 00 65 8b 0d 78 96 8e 7e f7 c1
RSP: 0018:ffffc90001676cf0 EFLAGS: 00000246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff88809fb9e240
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00000000ffffffff
RBP: ffff888092d24a04 R08: ffffffff86034f3b R09: ffffc900016790cc
R10: 0000000000000004 R11: 0000000000000000 R12: ffff888092d24a00
R13: 0000000000000000 R14: dffffc0000000000 R15: ffff888092d24a00
FS:  0000000000000000(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000004c6e68 CR3: 0000000092d41000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 hid_apply_multiplier drivers/hid/hid-core.c:1106 [inline]
 hid_setup_resolution_multiplier+0x2ab/0xbe0 drivers/hid/hid-core.c:1163
 hid_open_report+0xab2/0xdd0 drivers/hid/hid-core.c:1274
 hid_parse include/linux/hid.h:1017 [inline]
 ms_probe+0x12f/0x3f0 drivers/hid/hid-microsoft.c:388
 hid_device_probe+0x26c/0x410 drivers/hid/hid-core.c:2263
 really_probe+0x704/0xf60 drivers/base/dd.c:520
 driver_probe_device+0xe6/0x230 drivers/base/dd.c:697
 bus_for_each_drv+0x108/0x170 drivers/base/bus.c:431
 __device_attach+0x20c/0x3a0 drivers/base/dd.c:870
 bus_probe_device+0xb8/0x1f0 drivers/base/bus.c:491
 device_add+0x1828/0x1ba0 drivers/base/core.c:2557
 hid_add_device+0xa2a/0xef0 drivers/hid/hid-core.c:2419
 usbhid_probe+0x9bd/0xd10 drivers/hid/usbhid/hid-core.c:1407
 usb_probe_interface+0x614/0xac0 drivers/usb/core/driver.c:374
 really_probe+0x761/0xf60 drivers/base/dd.c:524
 driver_probe_device+0xe6/0x230 drivers/base/dd.c:697
 bus_for_each_drv+0x108/0x170 drivers/base/bus.c:431
 __device_attach+0x20c/0x3a0 drivers/base/dd.c:870
 bus_probe_device+0xb8/0x1f0 drivers/base/bus.c:491
 device_add+0x1828/0x1ba0 drivers/base/core.c:2557
 usb_set_configuration+0x19d2/0x1f20 drivers/usb/core/message.c:2032
 usb_generic_driver_probe+0x82/0x140 drivers/usb/core/generic.c:241
 usb_probe_device+0x12d/0x1d0 drivers/usb/core/driver.c:272
 really_probe+0x761/0xf60 drivers/base/dd.c:524
 driver_probe_device+0xe6/0x230 drivers/base/dd.c:697
 bus_for_each_drv+0x108/0x170 drivers/base/bus.c:431
 __device_attach+0x20c/0x3a0 drivers/base/dd.c:870
 bus_probe_device+0xb8/0x1f0 drivers/base/bus.c:491
 device_add+0x1828/0x1ba0 drivers/base/core.c:2557
 usb_new_device+0xcc3/0x1650 drivers/usb/core/hub.c:2554
 hub_port_connect drivers/usb/core/hub.c:5208 [inline]
 hub_port_connect_change drivers/usb/core/hub.c:5348 [inline]
 port_event drivers/usb/core/hub.c:5494 [inline]
 hub_event+0x2823/0x4cb0 drivers/usb/core/hub.c:5576
 process_one_work+0x76e/0xfd0 kernel/workqueue.c:2268
 worker_thread+0xa7f/0x1450 kernel/workqueue.c:2414
 kthread+0x353/0x380 kernel/kthread.c:268
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:351


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
