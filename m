Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55941215AA4
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 17:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729487AbgGFPWo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 11:22:44 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:37809 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729372AbgGFPW2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 11:22:28 -0400
Received: by mail-il1-f199.google.com with SMTP id x23so25150619ilk.4
        for <netdev@vger.kernel.org>; Mon, 06 Jul 2020 08:22:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Gb4RgcknZMkUgaAzsU/N7n1yCgbCMvtJjS9ILFoCYNM=;
        b=B71WuIWMHOCmR9BsJudie0v0YJ/fr2ED9imxrJPsc6bThYD3IZ3fYRBVy9agg/k6DX
         Uc0Sg0ftAMJEf6mFUDrKKmUhQM3hU/PXcEGvoeKUXjnk7MuL7HpzczarCV+E9bU2uTsp
         fzojghWaYttqk3Sxot8F4AlNwkhdZalomxwVEjicfnOlnfIZgKZIgbZoUzf/lYUmw5XK
         Dxm2FdgSSYEE0AK/qAHnWf1oNrS2LlG4kn+o35sEb48zUNfsJpm2j38M/Ji2ZWk/NSB6
         exSYs1IbKDI4b+y8o0fDx0U/rTrdKwmmLGcmbtHpd0iQZ2FIxDwG3aXiMPuPJnO9e5yE
         x4tw==
X-Gm-Message-State: AOAM5329fKKrdBr+E0hymS78du8nvNvpNkUImYhOkbmHUwkR5sTxcbJ8
        Q0YSi6PWxaVSGX/NU6mZEa7EKilsEcr1gsh5PzJzK+xRpxWo
X-Google-Smtp-Source: ABdhPJzxZFfQ9jxAGcQKfaaN9cjzlJ8XtC2kIauSqwA0u+MTvvWtmQAPSh2OS+auUyfpl2lAZtcE+ASAcGoL/0YidMjJ8gl/8yel
MIME-Version: 1.0
X-Received: by 2002:a92:c0c8:: with SMTP id t8mr32100276ilf.229.1594048946297;
 Mon, 06 Jul 2020 08:22:26 -0700 (PDT)
Date:   Mon, 06 Jul 2020 08:22:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000032e30505a9c771e3@google.com>
Subject: INFO: task hung in ath6kl_usb_power_off
From:   syzbot <syzbot+2d6ac90723742279e101@syzkaller.appspotmail.com>
To:     andreyknvl@google.com, davem@davemloft.net, kuba@kernel.org,
        kvalo@codeaurora.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    c8d141ce USB: Fix up terminology in include files
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git usb-testing
console output: https://syzkaller.appspot.com/x/log.txt?x=15d1a9a7100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=999be4eb2478ffa5
dashboard link: https://syzkaller.appspot.com/bug?extid=2d6ac90723742279e101
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+2d6ac90723742279e101@syzkaller.appspotmail.com

INFO: task kworker/0:6:3087 blocked for more than 143 seconds.
      Not tainted 5.8.0-rc3-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kworker/0:6     D24216  3087      2 0x80004000
Workqueue: usb_hub_wq hub_event
Call Trace:
 context_switch kernel/sched/core.c:3453 [inline]
 __schedule+0x88a/0x1cb0 kernel/sched/core.c:4178
 schedule+0xcd/0x2b0 kernel/sched/core.c:4253
 schedule_timeout+0x1d8/0x250 kernel/time/timer.c:1873
 do_wait_for_common kernel/sched/completion.c:85 [inline]
 __wait_for_common kernel/sched/completion.c:106 [inline]
 wait_for_common kernel/sched/completion.c:117 [inline]
 wait_for_completion+0x168/0x270 kernel/sched/completion.c:138
 flush_workqueue+0x3ff/0x13e0 kernel/workqueue.c:2832
 flush_scheduled_work include/linux/workqueue.h:597 [inline]
 ath6kl_usb_flush_all drivers/net/wireless/ath/ath6kl/usb.c:476 [inline]
 hif_detach_htc drivers/net/wireless/ath/ath6kl/usb.c:856 [inline]
 ath6kl_usb_power_off+0xbe/0xf0 drivers/net/wireless/ath/ath6kl/usb.c:1055
 ath6kl_hif_power_off drivers/net/wireless/ath/ath6kl/hif-ops.h:143 [inline]
 ath6kl_core_init drivers/net/wireless/ath/ath6kl/core.c:255 [inline]
 ath6kl_core_init+0x236/0x10d0 drivers/net/wireless/ath/ath6kl/core.c:66
 ath6kl_usb_probe+0xc30/0x11d0 drivers/net/wireless/ath/ath6kl/usb.c:1155
 usb_probe_interface+0x315/0x7f0 drivers/usb/core/driver.c:374
 really_probe+0x291/0xc90 drivers/base/dd.c:525
 driver_probe_device+0x26b/0x3d0 drivers/base/dd.c:701
 __device_attach_driver+0x1d1/0x290 drivers/base/dd.c:807
 bus_for_each_drv+0x15f/0x1e0 drivers/base/bus.c:431
 __device_attach+0x28d/0x430 drivers/base/dd.c:873
 bus_probe_device+0x1e4/0x290 drivers/base/bus.c:491
 device_add+0xb09/0x1b40 drivers/base/core.c:2680
 usb_set_configuration+0xf05/0x18a0 drivers/usb/core/message.c:2032
 usb_generic_driver_probe+0xba/0xf2 drivers/usb/core/generic.c:241
 usb_probe_device+0xd9/0x250 drivers/usb/core/driver.c:272
 really_probe+0x291/0xc90 drivers/base/dd.c:525
 driver_probe_device+0x26b/0x3d0 drivers/base/dd.c:701
 __device_attach_driver+0x1d1/0x290 drivers/base/dd.c:807
 bus_for_each_drv+0x15f/0x1e0 drivers/base/bus.c:431
 __device_attach+0x28d/0x430 drivers/base/dd.c:873
 bus_probe_device+0x1e4/0x290 drivers/base/bus.c:491
 device_add+0xb09/0x1b40 drivers/base/core.c:2680
 usb_new_device.cold+0x71d/0xfd4 drivers/usb/core/hub.c:2554
 hub_port_connect drivers/usb/core/hub.c:5208 [inline]
 hub_port_connect_change drivers/usb/core/hub.c:5348 [inline]
 port_event drivers/usb/core/hub.c:5494 [inline]
 hub_event+0x2361/0x4390 drivers/usb/core/hub.c:5576
 process_one_work+0x94c/0x15f0 kernel/workqueue.c:2269
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
 kthread+0x392/0x470 kernel/kthread.c:291
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293
INFO: task kworker/0:7:3122 blocked for more than 143 seconds.
      Not tainted 5.8.0-rc3-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kworker/0:7     D24656  3122      2 0x80004000
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
3 locks held by kworker/1:1/21:
 #0: ffff8881d88a6138 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff8881d88a6138 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff8881d88a6138 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff8881d88a6138 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff8881d88a6138 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff8881d88a6138 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: process_one_work+0x82b/0x15f0 kernel/workqueue.c:2240
 #1: ffff8881da317da8 ((work_completion)(&hub->events)){+.+.}-{0:0}, at: process_one_work+0x85f/0x15f0 kernel/workqueue.c:2244
 #2: ffff8881d4439218 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:768 [inline]
 #2: ffff8881d4439218 (&dev->mutex){....}-{3:3}, at: hub_event+0x1c5/0x4390 drivers/usb/core/hub.c:5522
1 lock held by khungtaskd/23:
 #0: ffffffff873124a0 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x264 kernel/locking/lockdep.c:5779
3 locks held by kworker/1:2/68:
 #0: ffff8881da028d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff8881da028d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff8881da028d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff8881da028d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff8881da028d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff8881da028d38 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x82b/0x15f0 kernel/workqueue.c:2240
 #1: ffff8881d5b3fda8 ((work_completion)(&fw_work->work)){+.+.}-{0:0}, at: process_one_work+0x85f/0x15f0 kernel/workqueue.c:2244
 #2: ffff8881d4531218 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:768 [inline]
 #2: ffff8881d4531218 (&dev->mutex){....}-{3:3}, at: ath9k_hif_usb_firmware_fail drivers/net/wireless/ath/ath9k/hif_usb.c:1108 [inline]
 #2: ffff8881d4531218 (&dev->mutex){....}-{3:3}, at: ath9k_hif_usb_firmware_cb+0x3ac/0x530 drivers/net/wireless/ath/ath9k/hif_usb.c:1241
1 lock held by in:imklog/244:
 #0: ffff8881c8675270 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0xe9/0x100 fs/file.c:826
2 locks held by agetty/252:
 #0: ffff8881cfef0098 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x22/0x80 drivers/tty/tty_ldisc.c:267
 #1: ffffc900009f62e8 (&ldata->atomic_read_lock){+.+.}-{3:3}, at: n_tty_read+0x223/0x1a30 drivers/tty/n_tty.c:2156
5 locks held by kworker/0:6/3087:
 #0: ffff8881d88a6138 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff8881d88a6138 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff8881d88a6138 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff8881d88a6138 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff8881d88a6138 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff8881d88a6138 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: process_one_work+0x82b/0x15f0 kernel/workqueue.c:2240
 #1: ffff8881c6627da8 ((work_completion)(&hub->events)){+.+.}-{0:0}, at: process_one_work+0x85f/0x15f0 kernel/workqueue.c:2244
 #2: ffff8881d4471218 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:768 [inline]
 #2: ffff8881d4471218 (&dev->mutex){....}-{3:3}, at: hub_event+0x1c5/0x4390 drivers/usb/core/hub.c:5522
 #3: ffff8881cd548218 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:768 [inline]
 #3: ffff8881cd548218 (&dev->mutex){....}-{3:3}, at: __device_attach+0x7a/0x430 drivers/base/dd.c:850
 #4: ffff8881d22c31a8 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:768 [inline]
 #4: ffff8881d22c31a8 (&dev->mutex){....}-{3:3}, at: __device_attach+0x7a/0x430 drivers/base/dd.c:850
5 locks held by kworker/1:3/3121:
 #0: ffff8881d88a6138 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff8881d88a6138 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff8881d88a6138 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff8881d88a6138 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff8881d88a6138 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff8881d88a6138 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: process_one_work+0x82b/0x15f0 kernel/workqueue.c:2240
 #1: ffff8881cd83fda8 ((work_completion)(&hub->events)){+.+.}-{0:0}, at: process_one_work+0x85f/0x15f0 kernel/workqueue.c:2244
 #2: ffff8881d44d1218 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:768 [inline]
 #2: ffff8881d44d1218 (&dev->mutex){....}-{3:3}, at: hub_event+0x1c5/0x4390 drivers/usb/core/hub.c:5522
 #3: ffff8881d44d4588 (&port_dev->status_lock){+.+.}-{3:3}, at: usb_lock_port drivers/usb/core/hub.c:3012 [inline]
 #3: ffff8881d44d4588 (&port_dev->status_lock){+.+.}-{3:3}, at: hub_port_connect drivers/usb/core/hub.c:5139 [inline]
 #3: ffff8881d44d4588 (&port_dev->status_lock){+.+.}-{3:3}, at: hub_port_connect_change drivers/usb/core/hub.c:5348 [inline]
 #3: ffff8881d44d4588 (&port_dev->status_lock){+.+.}-{3:3}, at: port_event drivers/usb/core/hub.c:5494 [inline]
 #3: ffff8881d44d4588 (&port_dev->status_lock){+.+.}-{3:3}, at: hub_event+0x217c/0x4390 drivers/usb/core/hub.c:5576
 #4: ffff8881d4f69b68 (hcd->address0_mutex){+.+.}-{3:3}, at: hub_port_init+0x1b6/0x2e80 drivers/usb/core/hub.c:4563
3 locks held by kworker/0:7/3122:
 #0: ffff8881da028d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff8881da028d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff8881da028d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff8881da028d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff8881da028d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff8881da028d38 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x82b/0x15f0 kernel/workqueue.c:2240
 #1: ffff8881cd477da8 ((work_completion)(&fw_work->work)){+.+.}-{0:0}, at: process_one_work+0x85f/0x15f0 kernel/workqueue.c:2244
 #2: ffff8881d4471218 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:768 [inline]
 #2: ffff8881d4471218 (&dev->mutex){....}-{3:3}, at: ath9k_hif_usb_firmware_fail drivers/net/wireless/ath/ath9k/hif_usb.c:1108 [inline]
 #2: ffff8881d4471218 (&dev->mutex){....}-{3:3}, at: ath9k_hif_usb_firmware_cb+0x3ac/0x530 drivers/net/wireless/ath/ath9k/hif_usb.c:1241
3 locks held by kworker/0:8/3125:
6 locks held by kworker/1:5/3225:
5 locks held by kworker/1:6/3235:
 #0: ffff8881d88a6138 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff8881d88a6138 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff8881d88a6138 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff8881d88a6138 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff8881d88a6138 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff8881d88a6138 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: process_one_work+0x82b/0x15f0 kernel/workqueue.c:2240
 #1: ffff8881c90c7da8 ((work_completion)(&hub->events)){+.+.}-{0:0}, at: process_one_work+0x85f/0x15f0 kernel/workqueue.c:2244
 #2: ffff8881d4491218 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:768 [inline]
 #2: ffff8881d4491218 (&dev->mutex){....}-{3:3}, at: hub_event+0x1c5/0x4390 drivers/usb/core/hub.c:5522
 #3: ffff8881d4494588 (&port_dev->status_lock){+.+.}-{3:3}, at: usb_lock_port drivers/usb/core/hub.c:3012 [inline]
 #3: ffff8881d4494588 (&port_dev->status_lock){+.+.}-{3:3}, at: hub_port_connect drivers/usb/core/hub.c:5139 [inline]
 #3: ffff8881d4494588 (&port_dev->status_lock){+.+.}-{3:3}, at: hub_port_connect_change drivers/usb/core/hub.c:5348 [inline]
 #3: ffff8881d4494588 (&port_dev->status_lock){+.+.}-{3:3}, at: port_event drivers/usb/core/hub.c:5494 [inline]
 #3: ffff8881d4494588 (&port_dev->status_lock){+.+.}-{3:3}, at: hub_event+0x217c/0x4390 drivers/usb/core/hub.c:5576
 #4: ffff8881d4f54b68 (hcd->address0_mutex){+.+.}-{3:3}, at: hub_port_init+0x1b6/0x2e80 drivers/usb/core/hub.c:4563
2 locks held by agetty/6439:
 #0: ffff8881ce39d098 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x22/0x80 drivers/tty/tty_ldisc.c:267
 #1: ffffc9000fc9d2e8 (&ldata->atomic_read_lock){+.+.}-{3:3}, at: n_tty_read+0x223/0x1a30 drivers/tty/n_tty.c:2156

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
CPU: 1 PID: 3235 Comm: kworker/1:6 Not tainted 5.8.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: usb_hub_wq hub_event
RIP: 0010:io_serial_in+0x60/0x80 drivers/tty/serial/8250/8250_port.c:447
Code: 0f b6 8d f1 00 00 00 48 8d 7d 40 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 d3 e3 80 3c 02 00 75 13 03 5d 40 89 da ec <5b> 0f b6 c0 5d c3 e8 c5 6a 42 ff eb c9 e8 ee 6a 42 ff eb e6 66 90
RSP: 0018:ffff8881c90c7418 EFLAGS: 00000002
RAX: dffffc0000000060 RBX: 00000000000003fd RCX: 0000000000000000
RDX: 00000000000003fd RSI: ffffffff8226e15c RDI: ffffffff8a2a3be0
RBP: ffffffff8a2a3ba0 R08: 0000000000000001 R09: 0000000000000003
R10: 000000000000000a R11: 0000000000000007 R12: 0000000000000020
R13: fffffbfff14547c6 R14: fffffbfff145477e R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff8881db300000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f7a9b574000 CR3: 00000001c7596000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 serial_in drivers/tty/serial/8250/8250.h:113 [inline]
 wait_for_xmitr+0x9a/0x210 drivers/tty/serial/8250/8250_port.c:2060
 serial8250_console_putchar+0x1b/0x50 drivers/tty/serial/8250/8250_port.c:3197
 uart_console_write+0x59/0x100 drivers/tty/serial/serial_core.c:1949
 serial8250_console_write+0x8c5/0xa90 drivers/tty/serial/8250/8250_port.c:3269
 call_console_drivers kernel/printk/printk.c:1816 [inline]
 console_unlock+0x87a/0xcd0 kernel/printk/printk.c:2493
 vprintk_emit+0x1b2/0x460 kernel/printk/printk.c:2021
 dev_vprintk_emit+0x3eb/0x436 drivers/base/core.c:3883
 dev_printk_emit+0xba/0xf1 drivers/base/core.c:3894
 __dev_printk+0xcf/0xf5 drivers/base/core.c:3906
 _dev_info+0xd7/0x109 drivers/base/core.c:3952
 hub_port_init.cold+0x264/0x32f drivers/usb/core/hub.c:4628
 hub_port_connect drivers/usb/core/hub.c:5140 [inline]
 hub_port_connect_change drivers/usb/core/hub.c:5348 [inline]
 port_event drivers/usb/core/hub.c:5494 [inline]
 hub_event+0x2191/0x4390 drivers/usb/core/hub.c:5576
 process_one_work+0x94c/0x15f0 kernel/workqueue.c:2269
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
 kthread+0x392/0x470 kernel/kthread.c:291
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
