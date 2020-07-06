Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 953CC215A60
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 17:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729371AbgGFPM0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 11:12:26 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:39011 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729231AbgGFPMX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 11:12:23 -0400
Received: by mail-il1-f198.google.com with SMTP id f66so22440519ilh.6
        for <netdev@vger.kernel.org>; Mon, 06 Jul 2020 08:12:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=8cjkntt87TGAwu49cqH5L6r37d1iz61filDgkTRY34c=;
        b=QoTLaf6sXtsY3kiGBjCypZpEK8rDnZA5y88L3n8TZCwFJvWmOcH5dByoRe63dzqJqm
         OGwfPk6iP18/9a0mwCeJJSoRYOIxmVnMRF+m5xvJBjjUuwL72Ma1H805LpjpMGx653D2
         8d/yUDSjuux+61IQxFCYiO7ZAkJm1fu3qnFUKCj6iiPuHTrKrewNwVJbFsa6hP18WNKg
         B7IlBnzGoKTMRR7bH9jZyKsPXL53BoeSRwKqgU7FxOp0A5a9RSNC2UiM5FHZVL0Jcbtn
         kMesIa806QguX5oKr0lSYrvQe+YAHeKeAu8McOXj8JLLf2sEjmpS6csUkACooXr6fNMI
         lJTA==
X-Gm-Message-State: AOAM5302iNlpBLgdruUJWFOyg7E1tQXXaXGwhJQIpgR0zYUsjr++f75z
        gCVAcGCZ4hxpVKf2e3Ezewd2X04ZcQEJJ8OzT5PHYHLO/BWB
X-Google-Smtp-Source: ABdhPJyWL1S4sZ9WmGXZ87KaRbRG7mjMC3zW1dSP8H7oKpM6TQ5fTpbpvU0hPuBRWLiKooSg5KjIDPt/lEAQbkdmVd5BdF4ajFMl
MIME-Version: 1.0
X-Received: by 2002:a05:6638:cc7:: with SMTP id e7mr52965354jak.87.1594048341704;
 Mon, 06 Jul 2020 08:12:21 -0700 (PDT)
Date:   Mon, 06 Jul 2020 08:12:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002985c805a9c74d76@google.com>
Subject: INFO: task hung in ath9k_hif_usb_firmware_cb
From:   syzbot <syzbot+da8c2bed7fa646ad6fcf@syzkaller.appspotmail.com>
To:     andreyknvl@google.com, ath9k-devel@qca.qualcomm.com,
        davem@davemloft.net, kuba@kernel.org, kvalo@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    768a0741 usb: dwc2: gadget: Remove assigned but never used..
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git usb-testing
console output: https://syzkaller.appspot.com/x/log.txt?x=111f235b100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=999be4eb2478ffa5
dashboard link: https://syzkaller.appspot.com/bug?extid=da8c2bed7fa646ad6fcf
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+da8c2bed7fa646ad6fcf@syzkaller.appspotmail.com

INFO: task kworker/0:0:5 blocked for more than 143 seconds.
      Not tainted 5.8.0-rc3-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kworker/0:0     D22168     5      2 0x80004000
Workqueue: events request_firmware_work_func
Call Trace:
 context_switch kernel/sched/core.c:3453 [inline]
 __schedule+0x88a/0x1cb0 kernel/sched/core.c:4178
 schedule+0xcd/0x2b0 kernel/sched/core.c:4253
 schedule_preempt_disabled+0xc/0x20 kernel/sched/core.c:4312
 __mutex_lock_common kernel/locking/mutex.c:1033 [inline]
 __mutex_lock+0x3e2/0x10a0 kernel/locking/mutex.c:1103
 device_lock include/linux/device.h:768 [inline]
 ath9k_hif_usb_firmware_fail drivers/net/wireless/ath/ath9k/hif_usb.c:1108 [inline]
 ath9k_hif_usb_firmware_cb+0x3ac/0x530 drivers/net/wireless/ath/ath9k/hif_usb.c:1241
 request_firmware_work_func+0x126/0x250 drivers/base/firmware_loader/main.c:1001
 process_one_work+0x94c/0x15f0 kernel/workqueue.c:2269
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
 kthread+0x392/0x470 kernel/kthread.c:291
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293

Showing all locks held in the system:
3 locks held by kworker/0:0/5:
 #0: ffff8881da028d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff8881da028d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff8881da028d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff8881da028d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff8881da028d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff8881da028d38 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x82b/0x15f0 kernel/workqueue.c:2240
 #1: ffff8881da1d7da8 ((work_completion)(&fw_work->work)){+.+.}-{0:0}, at: process_one_work+0x85f/0x15f0 kernel/workqueue.c:2244
 #2: ffff8881d44bb218 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:768 [inline]
 #2: ffff8881d44bb218 (&dev->mutex){....}-{3:3}, at: ath9k_hif_usb_firmware_fail drivers/net/wireless/ath/ath9k/hif_usb.c:1108 [inline]
 #2: ffff8881d44bb218 (&dev->mutex){....}-{3:3}, at: ath9k_hif_usb_firmware_cb+0x3ac/0x530 drivers/net/wireless/ath/ath9k/hif_usb.c:1241
1 lock held by khungtaskd/23:
 #0: ffffffff873124a0 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x264 kernel/locking/lockdep.c:5779
3 locks held by kworker/1:2/68:
 #0: ffff8881da028d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff8881da028d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff8881da028d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff8881da028d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff8881da028d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff8881da028d38 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x82b/0x15f0 kernel/workqueue.c:2240
 #1: ffff8881d5ae7da8 ((work_completion)(&fw_work->work)){+.+.}-{0:0}, at: process_one_work+0x85f/0x15f0 kernel/workqueue.c:2244
 #2: ffff8881d440b218 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:768 [inline]
 #2: ffff8881d440b218 (&dev->mutex){....}-{3:3}, at: ath9k_hif_usb_firmware_fail drivers/net/wireless/ath/ath9k/hif_usb.c:1108 [inline]
 #2: ffff8881d440b218 (&dev->mutex){....}-{3:3}, at: ath9k_hif_usb_firmware_cb+0x3ac/0x530 drivers/net/wireless/ath/ath9k/hif_usb.c:1241
1 lock held by in:imklog/213:
 #0: ffff8881ca60a370 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0xe9/0x100 fs/file.c:826
3 locks held by kworker/0:4/3049:
3 locks held by kworker/0:5/3055:
5 locks held by kworker/0:6/3096:
5 locks held by kworker/1:6/3310:
 #0: ffff8881d880ed38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff8881d880ed38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff8881d880ed38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff8881d880ed38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff8881d880ed38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff8881d880ed38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: process_one_work+0x82b/0x15f0 kernel/workqueue.c:2240
 #1: ffff8881d97f7da8 ((work_completion)(&hub->events)){+.+.}-{0:0}, at: process_one_work+0x85f/0x15f0 kernel/workqueue.c:2244
 #2: ffff8881d44bb218 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:768 [inline]
 #2: ffff8881d44bb218 (&dev->mutex){....}-{3:3}, at: hub_event+0x1c5/0x4390 drivers/usb/core/hub.c:5522
 #3: ffff8881d9414218 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:768 [inline]
 #3: ffff8881d9414218 (&dev->mutex){....}-{3:3}, at: __device_attach+0x7a/0x430 drivers/base/dd.c:850
 #4: ffff8881c7a8f1a8 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:768 [inline]
 #4: ffff8881c7a8f1a8 (&dev->mutex){....}-{3:3}, at: __device_attach+0x7a/0x430 drivers/base/dd.c:850
3 locks held by kworker/1:8/4172:
 #0: ffff8881d880ed38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff8881d880ed38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff8881d880ed38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff8881d880ed38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff8881d880ed38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff8881d880ed38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: process_one_work+0x82b/0x15f0 kernel/workqueue.c:2240
 #1: ffff8881c746fda8 ((work_completion)(&hub->events)){+.+.}-{0:0}, at: process_one_work+0x85f/0x15f0 kernel/workqueue.c:2244
 #2: ffff8881d440b218 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:768 [inline]
 #2: ffff8881d440b218 (&dev->mutex){....}-{3:3}, at: hub_event+0x1c5/0x4390 drivers/usb/core/hub.c:5522
2 locks held by agetty/16081:
 #0: ffff8881cba50098 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x22/0x80 drivers/tty/tty_ldisc.c:267
 #1: ffffc900102882e8 (&ldata->atomic_read_lock){+.+.}-{3:3}, at: n_tty_read+0x223/0x1a30 drivers/tty/n_tty.c:2156

=============================================

NMI backtrace for cpu 0
CPU: 0 PID: 23 Comm: khungtaskd Not tainted 5.8.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0xf6/0x16e lib/dump_stack.c:118
 nmi_cpu_backtrace.cold+0x74/0xb6 lib/nmi_backtrace.c:101
 nmi_trigger_cpumask_backtrace+0x1da/0x1f4 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:209 [inline]
 watchdog+0xd6a/0xfd0 kernel/hung_task.c:295
 kthread+0x392/0x470 kernel/kthread.c:291
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 PID: 340 Comm: syz-executor.2 Not tainted 5.8.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0033:0x45cae4
Code: Bad RIP value.
RSP: 002b:00007ffd79517e20 EFLAGS: 00000217
RAX: 0000000000000000 RBX: 00000000000d7450 RCX: 000000000045b030
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00007ffd79517e20
RBP: 00000000000002dd R08: 0000000000000001 R09: 0000000000e8b940
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffd79517e70 R14: 00000000000d7450 R15: 00007ffd79517e80
FS:  0000000000e8b940 GS:  0000000000000000


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
