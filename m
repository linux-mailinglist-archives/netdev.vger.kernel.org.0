Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 840F72C8804
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 16:32:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbgK3PcE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 10:32:04 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:56462 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726366AbgK3PcE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 10:32:04 -0500
Received: by mail-il1-f198.google.com with SMTP id g2so10547795ilb.23
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 07:31:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=FoMjz0yq2IhXV/EVLS2pl82P6uKJO5gdA0GLF+7i28k=;
        b=AIqG7NFejwSAXGrrbauwJPxBuYtp5hainHCb0uaXmOcOpdrP7XbS6fjh8jaRHFl9Kr
         nvMQrFCEq+tQzio1H/PPzupgSxNe8E3Zo0OFw2+3atsL9c9UJYyJw+HH0r/Vjq8u5i/7
         FiSZ9l2EcIpfhhSeWpB6C/LT+lq7Joj//f9Fj2o9XySbE6dAtvCOsrWNo/paQOlnH60X
         Y+I8H/FPGQMHpIuoNhD/G5JTQnaFc9WZ9TkM8Q3LfiIOB116SyECVT14KFDwp3WBx+Eo
         BYDXuJrKXaye+wQR6dw8zflOTx6sp72K+G+nF4un25UqtZfbwjNAj2MW3Qzpm7d12GGJ
         p+3g==
X-Gm-Message-State: AOAM531kKQm+qxdQ/bfH4RB69+N85EiTAMK2F8wH4uaSZYJMLfNW63qn
        lMnKe1jSdQF7cTOcdiUTQyoIzAjYj8hGuWCRtdM4xyrq4Ns8
X-Google-Smtp-Source: ABdhPJypu+WvW1Ky2XKzFU3qla7AWjIlyRnKUdvyo96RxwIHbA7xMTldzteaTfnM4qrcIGXtn/6Yxmqshvjx5Q5KVyyUIic+mP6O
MIME-Version: 1.0
X-Received: by 2002:a92:da4f:: with SMTP id p15mr18805725ilq.93.1606750276405;
 Mon, 30 Nov 2020 07:31:16 -0800 (PST)
Date:   Mon, 30 Nov 2020 07:31:16 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000077ceca05b554b3e8@google.com>
Subject: INFO: task hung in ath6kl_usb_destroy (3)
From:   syzbot <syzbot+bccb3d118a39c43b6c9d@syzkaller.appspotmail.com>
To:     andreyknvl@google.com, davem@davemloft.net, kuba@kernel.org,
        kvalo@codeaurora.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    ebad4326 Merge 5.10-rc6 into usb-next
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git usb-testing
console output: https://syzkaller.appspot.com/x/log.txt?x=1566291d500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fe8988e4dc252d01
dashboard link: https://syzkaller.appspot.com/bug?extid=bccb3d118a39c43b6c9d
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+bccb3d118a39c43b6c9d@syzkaller.appspotmail.com

INFO: task kworker/1:4:7246 blocked for more than 143 seconds.
      Not tainted 5.10.0-rc6-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/1:4     state:D stack:22864 pid: 7246 ppid:     2 flags:0x00004000
Workqueue: usb_hub_wq hub_event
Call Trace:
 context_switch kernel/sched/core.c:3779 [inline]
 __schedule+0x8a2/0x1f30 kernel/sched/core.c:4528
 schedule+0xcb/0x270 kernel/sched/core.c:4606
 schedule_timeout+0x1d8/0x250 kernel/time/timer.c:1847
 do_wait_for_common kernel/sched/completion.c:85 [inline]
 __wait_for_common kernel/sched/completion.c:106 [inline]
 wait_for_common kernel/sched/completion.c:117 [inline]
 wait_for_completion+0x168/0x270 kernel/sched/completion.c:138
 flush_workqueue+0x3ff/0x13e0 kernel/workqueue.c:2835
 flush_scheduled_work include/linux/workqueue.h:597 [inline]
 ath6kl_usb_flush_all drivers/net/wireless/ath/ath6kl/usb.c:476 [inline]
 ath6kl_usb_destroy+0xc6/0x290 drivers/net/wireless/ath/ath6kl/usb.c:609
 ath6kl_usb_probe+0xc7b/0x11f0 drivers/net/wireless/ath/ath6kl/usb.c:1166
 usb_probe_interface+0x315/0x7f0 drivers/usb/core/driver.c:396
 really_probe+0x291/0xde0 drivers/base/dd.c:554
 driver_probe_device+0x26b/0x3d0 drivers/base/dd.c:738
 __device_attach_driver+0x1d1/0x290 drivers/base/dd.c:844
 bus_for_each_drv+0x15f/0x1e0 drivers/base/bus.c:431
 __device_attach+0x228/0x4a0 drivers/base/dd.c:912
 bus_probe_device+0x1e4/0x290 drivers/base/bus.c:491
 device_add+0xbb2/0x1ce0 drivers/base/core.c:2936
 usb_set_configuration+0x113c/0x1910 drivers/usb/core/message.c:2168
 usb_generic_driver_probe+0xba/0x100 drivers/usb/core/generic.c:238
 usb_probe_device+0xd9/0x2c0 drivers/usb/core/driver.c:293
 really_probe+0x291/0xde0 drivers/base/dd.c:554
 driver_probe_device+0x26b/0x3d0 drivers/base/dd.c:738
 __device_attach_driver+0x1d1/0x290 drivers/base/dd.c:844
 bus_for_each_drv+0x15f/0x1e0 drivers/base/bus.c:431
 __device_attach+0x228/0x4a0 drivers/base/dd.c:912
 bus_probe_device+0x1e4/0x290 drivers/base/bus.c:491
 device_add+0xbb2/0x1ce0 drivers/base/core.c:2936
 usb_new_device.cold+0x71d/0xfe9 drivers/usb/core/hub.c:2555
 hub_port_connect drivers/usb/core/hub.c:5223 [inline]
 hub_port_connect_change drivers/usb/core/hub.c:5363 [inline]
 port_event drivers/usb/core/hub.c:5509 [inline]
 hub_event+0x2348/0x42d0 drivers/usb/core/hub.c:5591
 process_one_work+0x933/0x1520 kernel/workqueue.c:2272
 process_scheduled_works kernel/workqueue.c:2334 [inline]
 worker_thread+0x82b/0x1120 kernel/workqueue.c:2420
 kthread+0x38c/0x460 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296

Showing all locks held in the system:
5 locks held by kworker/0:0/5:
 #0: ffff888103c7ed38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888103c7ed38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff888103c7ed38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888103c7ed38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff888103c7ed38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff888103c7ed38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: process_one_work+0x821/0x1520 kernel/workqueue.c:2243
 #1: ffffc9000005fda8 ((work_completion)(&hub->events)){+.+.}-{0:0}, at: process_one_work+0x854/0x1520 kernel/workqueue.c:2247
 #2: ffff888108dd6218 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:731 [inline]
 #2: ffff888108dd6218 (&dev->mutex){....}-{3:3}, at: hub_event+0x1c5/0x42d0 drivers/usb/core/hub.c:5537
 #3: ffff88813b5e7218 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:731 [inline]
 #3: ffff88813b5e7218 (&dev->mutex){....}-{3:3}, at: __device_attach+0x7a/0x4a0 drivers/base/dd.c:887
 #4: ffff888102bc51a8 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:731 [inline]
 #4: ffff888102bc51a8 (&dev->mutex){....}-{3:3}, at: __device_attach+0x7a/0x4a0 drivers/base/dd.c:887
1 lock held by khungtaskd/1268:
 #0: ffffffff872495a0 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x269 kernel/locking/lockdep.c:6254
6 locks held by kworker/1:2/2207:
 #0: ffff888103c7ed38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888103c7ed38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff888103c7ed38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888103c7ed38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff888103c7ed38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff888103c7ed38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: process_one_work+0x821/0x1520 kernel/workqueue.c:2243
 #1: ffffc90005ce7da8 ((work_completion)(&hub->events)){+.+.}-{0:0}, at: process_one_work+0x854/0x1520 kernel/workqueue.c:2247
 #2: ffff888108d06218 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:731 [inline]
 #2: ffff888108d06218 (&dev->mutex){....}-{3:3}, at: hub_event+0x1c5/0x42d0 drivers/usb/core/hub.c:5537
 #3: ffff888108d49580 (&port_dev->status_lock){+.+.}-{3:3}, at: usb_lock_port drivers/usb/core/hub.c:3030 [inline]
 #3: ffff888108d49580 (&port_dev->status_lock){+.+.}-{3:3}, at: hub_port_connect drivers/usb/core/hub.c:5154 [inline]
 #3: ffff888108d49580 (&port_dev->status_lock){+.+.}-{3:3}, at: hub_port_connect_change drivers/usb/core/hub.c:5363 [inline]
 #3: ffff888108d49580 (&port_dev->status_lock){+.+.}-{3:3}, at: port_event drivers/usb/core/hub.c:5509 [inline]
 #3: ffff888108d49580 (&port_dev->status_lock){+.+.}-{3:3}, at: hub_event+0x216c/0x42d0 drivers/usb/core/hub.c:5591
 #4: ffff888108bf3068 (hcd->address0_mutex){+.+.}-{3:3}, at: hub_port_init+0x1b6/0x2e40 drivers/usb/core/hub.c:4582
 #5: ffffffff87a9c370 (ehci_cf_port_reset_rwsem){.+.+}-{3:3}, at: hub_port_reset+0x199/0x1940 drivers/usb/core/hub.c:2892
1 lock held by systemd-journal/2638:
1 lock held by in:imklog/4274:
2 locks held by login/4272:
 #0: ffff888110c96098 (
&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x22/0x80 drivers/tty/tty_ldisc.c:266
 #1: ffff888110c96130 (&tty->atomic_write_lock){+.+.}-{3:3}, at: tty_write_lock drivers/tty/tty_io.c:888 [inline]
 #1: ffff888110c96130 (&tty->atomic_write_lock){+.+.}-{3:3}, at: do_tty_write drivers/tty/tty_io.c:911 [inline]
 #1: ffff888110c96130 (&tty->atomic_write_lock){+.+.}-{3:3}, at: tty_write+0x280/0x870 drivers/tty/tty_io.c:1046
2 locks held by agetty/4278:
 #0: ffff888110c90098 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x22/0x80 drivers/tty/tty_ldisc.c:266
 #1: ffffc9000053b2e8 (&ldata->atomic_read_lock){+.+.}-{3:3}, at: n_tty_read+0x223/0x1a20 drivers/tty/n_tty.c:2156
2 locks held by agetty/4279:
 #0: ffff888110ef2098 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x22/0x80 drivers/tty/tty_ldisc.c:266
 #1: ffffc9000051b2e8 (&ldata->atomic_read_lock){+.+.}-{3:3}, at: n_tty_read+0x223/0x1a20 drivers/tty/n_tty.c:2156
3 locks held by kworker/1:3/7058:
 #0: ffff888100064d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888100064d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff888100064d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888100064d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff888100064d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff888100064d38 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x821/0x1520 kernel/workqueue.c:2243
 #1: ffffc90004457da8 ((work_completion)(&fw_work->work)){+.+.}-{0:0}, at: process_one_work+0x854/0x1520 kernel/workqueue.c:2247
 #2: ffff888108dd6218 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:731 [inline]
 #2: ffff888108dd6218 (&dev->mutex){....}-{3:3}, at: ath9k_hif_usb_firmware_fail drivers/net/wireless/ath/ath9k/hif_usb.c:1129 [inline]
 #2: ffff888108dd6218 (&dev->mutex){....}-{3:3}, at: ath9k_hif_usb_firmware_cb+0x3ac/0x530 drivers/net/wireless/ath/ath9k/hif_usb.c:1262
5 locks held by kworker/1:4/7246:
 #0: ffff888103c7ed38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888103c7ed38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff888103c7ed38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888103c7ed38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff888103c7ed38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff888103c7ed38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: process_one_work+0x821/0x1520 kernel/workqueue.c:2243
 #1: ffffc90004a07da8 ((work_completion)(&hub->events)){+.+.}-{0:0}, at: process_one_work+0x854/0x1520 kernel/workqueue.c:2247
 #2: ffff888108e0e218 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:731 [inline]
 #2: ffff888108e0e218 (&dev->mutex){....}-{3:3}, at: hub_event+0x1c5/0x42d0 drivers/usb/core/hub.c:5537
 #3: ffff88810cdf8218 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:731 [inline]
 #3: ffff88810cdf8218 (&dev->mutex){....}-{3:3}, at: __device_attach+0x7a/0x4a0 drivers/base/dd.c:887
 #4: ffff88810f1451a8 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:731 [inline]
 #4: ffff88810f1451a8 (&dev->mutex){....}-{3:3}, at: __device_attach+0x7a/0x4a0 drivers/base/dd.c:887
2 locks held by agetty/29659:
 #0: ffff8881284df098 (
&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x22/0x80 drivers/tty/tty_ldisc.c:266
 #1: 
ffffc9000037b2e8
 (
&ldata->atomic_read_lock){+.+.}-{3:3}, at: n_tty_read+0x223/0x1a20 drivers/tty/n_tty.c:2156
2 locks held by login/3442:
 #0: ffff888110ecc098 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x22/0x80 drivers/tty/tty_ldisc.c:266
 #1: ffff888110ecc130 (&tty->atomic_write_lock){+.+.}-{3:3}, at: tty_write_lock drivers/tty/tty_io.c:888 [inline]
 #1: ffff888110ecc130 (&tty->atomic_write_lock){+.+.}-{3:3}, at: do_tty_write drivers/tty/tty_io.c:911 [inline]
 #1: ffff888110ecc130 (&tty->atomic_write_lock){+.+.}-{3:3}, at: tty_write+0x280/0x870 drivers/tty/tty_io.c:1046
5 locks held by kworker/0:8/20838:
 #0: ffff888103c7ed38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888103c7ed38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff888103c7ed38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888103c7ed38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff888103c7ed38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff888103c7ed38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: process_one_work+0x821/0x1520 kernel/workqueue.c:2243
 #1: ffffc900004f7da8 ((work_completion)(&hub->events)){+.+.}-{0:0}, at: process_one_work+0x854/0x1520 kernel/workqueue.c:2247
 #2: ffff888108c4e218 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:731 [inline]
 #2: ffff888108c4e218 (&dev->mutex){....}-{3:3}, at: hub_event+0x1c5/0x42d0 drivers/usb/core/hub.c:5537
 #3: ffff888108d01580 (&port_dev->status_lock){+.+.}-{3:3}, at: usb_lock_port drivers/usb/core/hub.c:3030 [inline]
 #3: ffff888108d01580 (&port_dev->status_lock){+.+.}-{3:3}, at: hub_port_connect drivers/usb/core/hub.c:5154 [inline]
 #3: ffff888108d01580 (&port_dev->status_lock){+.+.}-{3:3}, at: hub_port_connect_change drivers/usb/core/hub.c:5363 [inline]
 #3: ffff888108d01580 (&port_dev->status_lock){+.+.}-{3:3}, at: port_event drivers/usb/core/hub.c:5509 [inline]
 #3: ffff888108d01580 (&port_dev->status_lock){+.+.}-{3:3}, at: hub_event+0x216c/0x42d0 drivers/usb/core/hub.c:5591
 #4: ffff888108bde968 (hcd->address0_mutex){+.+.}-{3:3}, at: hub_port_init+0x1b6/0x2e40 drivers/usb/core/hub.c:4582
3 locks held by kworker/1:8/26258:
2 locks held by agetty/17733:
 #0: ffff88811537e098 (&tty->ldisc_sem){++++}-{0:0}
, at: tty_ldisc_ref_wait+0x22/0x80 drivers/tty/tty_ldisc.c:266
 #1: ffffc90001eeb2e8 (&ldata->atomic_read_lock){+.+.}-{3:3}, at: n_tty_read+0x223/0x1a20 drivers/tty/n_tty.c:2156
5 locks held by kworker/1:0/25578:
 #0: ffff888103c7ed38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888103c7ed38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff888103c7ed38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888103c7ed38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff888103c7ed38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff888103c7ed38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: process_one_work+0x821/0x1520 kernel/workqueue.c:2243
 #1: ffffc90005a47da8 ((work_completion)(&hub->events)){+.+.}-{0:0}, at: process_one_work+0x854/0x1520 kernel/workqueue.c:2247
 #2: ffff888108d86218 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:731 [inline]
 #2: ffff888108d86218 (&dev->mutex){....}-{3:3}, at: hub_event+0x1c5/0x42d0 drivers/usb/core/hub.c:5537
 #3: ffff888113670218 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:731 [inline]
 #3: ffff888113670218 (&dev->mutex){....}-{3:3}, at: __device_attach+0x7a/0x4a0 drivers/base/dd.c:887
 #4: ffff8881349121a8 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:731 [inline]
 #4: ffff8881349121a8 (&dev->mutex){....}-{3:3}, at: __device_attach+0x7a/0x4a0 drivers/base/dd.c:887

=============================================

NMI backtrace for cpu 0
CPU: 0 PID: 1268 Comm: khungtaskd Not tainted 5.10.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:118
 nmi_cpu_backtrace.cold+0x46/0xe0 lib/nmi_backtrace.c:105
 nmi_trigger_cpumask_backtrace+0x1da/0x200 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:209 [inline]
 watchdog+0xd32/0xf70 kernel/hung_task.c:294
 kthread+0x38c/0x460 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 PID: 25578 Comm: kworker/1:0 Not tainted 5.10.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: usb_hub_wq hub_event
RIP: 0010:lookup_chain_cache kernel/locking/lockdep.c:3501 [inline]
RIP: 0010:lookup_chain_cache_add kernel/locking/lockdep.c:3521 [inline]
RIP: 0010:validate_chain kernel/locking/lockdep.c:3576 [inline]
RIP: 0010:__lock_acquire+0x1711/0x54f0 kernel/locking/lockdep.c:4832
Code: 48 89 44 24 10 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 80 3c 02 00 0f 85 38 3d 00 00 48 8b 44 24 08 48 8b 1c c5 00 04 88 89 <48> 85 db 74 5a 48 83 eb 08 74 54 49 bd 00 00 00 00 00 fc ff df eb
RSP: 0018:ffffc90000148af0 EFLAGS: 00000046
RAX: 0000000000002fda RBX: ffffffff892809c8 RCX: ffffffff81260fa7
RDX: 1ffffffff131305a RSI: 0000000000000008 RDI: ffffffff898cc4a0
RBP: ffff88810371e500 R08: 0000000000000000 R09: ffffffff898cc4a7
R10: fffffbfff1319894 R11: 0000000000000001 R12: ffff88810371eec8
R13: 0000000000000000 R14: 41c7dafe3d7f841d R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8881f6b00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f0260210000 CR3: 000000011564c000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
 lock_acquire kernel/locking/lockdep.c:5437 [inline]
 lock_acquire+0x288/0x700 kernel/locking/lockdep.c:5402
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
 _raw_spin_lock_irqsave+0x36/0x50 kernel/locking/spinlock.c:159
 debug_object_deactivate lib/debugobjects.c:730 [inline]
 debug_object_deactivate+0x101/0x300 lib/debugobjects.c:718
 debug_timer_deactivate kernel/time/timer.c:732 [inline]
 debug_deactivate kernel/time/timer.c:776 [inline]
 detach_timer kernel/time/timer.c:823 [inline]
 expire_timers kernel/time/timer.c:1444 [inline]
 __run_timers.part.0+0x51a/0xa10 kernel/time/timer.c:1747
 __run_timers kernel/time/timer.c:1728 [inline]
 run_timer_softirq+0x80/0x120 kernel/time/timer.c:1760
 __do_softirq+0x1b2/0x945 kernel/softirq.c:298
 asm_call_irq_on_stack+0xf/0x20
 </IRQ>
 __run_on_irqstack arch/x86/include/asm/irq_stack.h:26 [inline]
 run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:77 [inline]
 do_softirq_own_stack+0x80/0xa0 arch/x86/kernel/irq_64.c:77
 invoke_softirq kernel/softirq.c:393 [inline]
 __irq_exit_rcu kernel/softirq.c:423 [inline]
 irq_exit_rcu+0x110/0x1a0 kernel/softirq.c:435
 sysvec_apic_timer_interrupt+0x43/0xa0 arch/x86/kernel/apic/apic.c:1091
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:631
RIP: 0010:console_trylock_spinning kernel/printk/printk.c:1841 [inline]
RIP: 0010:vprintk_emit+0x36b/0x4d0 kernel/printk/printk.c:2027
Code: c7 40 ba 15 87 e8 a5 82 fd ff e8 00 1d 00 00 31 ff 48 89 ee e8 16 e7 15 00 48 85 ed 0f 85 54 01 00 00 e8 58 ee 15 00 41 55 9d <e8> 50 ee 15 00 45 31 c9 41 b8 01 00 00 00 31 c9 68 03 d7 28 81 ba
RSP: 0018:ffffc90005a46908 EFLAGS: 00000246
RAX: 0000000000040000 RBX: 0000000000000000 RCX: ffffc90010287000
RDX: 0000000000040000 RSI: ffffffff8128d708 RDI: ffffffff8128d861
RBP: 0000000000000200 R08: 0000000000000001 R09: ffffffff898cc4ef
R10: fffffbfff131989d R11: 0000000000000000 R12: 0000000000000038
R13: 0000000000000246 R14: ffff8881036ee500 R15: 0000000000000000
 dev_vprintk_emit+0x2ea/0x32e drivers/base/core.c:4128
 dev_printk_emit+0xba/0xf1 drivers/base/core.c:4139
 __dev_printk+0xcf/0xf5 drivers/base/core.c:4151
 _dev_warn+0xd7/0x109 drivers/base/core.c:4195
 hid_parser_main.cold+0xa2/0xf1 drivers/hid/hid-core.c:630
 hid_open_report+0x37f/0x660 drivers/hid/hid-core.c:1260
 hid_parse include/linux/hid.h:1035 [inline]
 ms_probe+0x12d/0x4b0 drivers/hid/hid-microsoft.c:385
 hid_device_probe+0x2bd/0x3f0 drivers/hid/hid-core.c:2281
 really_probe+0x291/0xde0 drivers/base/dd.c:554
 driver_probe_device+0x26b/0x3d0 drivers/base/dd.c:738
 __device_attach_driver+0x1d1/0x290 drivers/base/dd.c:844
 bus_for_each_drv+0x15f/0x1e0 drivers/base/bus.c:431
 __device_attach+0x228/0x4a0 drivers/base/dd.c:912
 bus_probe_device+0x1e4/0x290 drivers/base/bus.c:491
 device_add+0xbb2/0x1ce0 drivers/base/core.c:2936
 hid_add_device+0x344/0x9d0 drivers/hid/hid-core.c:2437
 usbhid_probe+0xaae/0xfc0 drivers/hid/usbhid/hid-core.c:1407
 usb_probe_interface+0x315/0x7f0 drivers/usb/core/driver.c:396
 really_probe+0x291/0xde0 drivers/base/dd.c:554
 driver_probe_device+0x26b/0x3d0 drivers/base/dd.c:738
 __device_attach_driver+0x1d1/0x290 drivers/base/dd.c:844
 bus_for_each_drv+0x15f/0x1e0 drivers/base/bus.c:431
 __device_attach+0x228/0x4a0 drivers/base/dd.c:912
 bus_probe_device+0x1e4/0x290 drivers/base/bus.c:491
 device_add+0xbb2/0x1ce0 drivers/base/core.c:2936
 usb_set_configuration+0x113c/0x1910 drivers/usb/core/message.c:2168
 usb_generic_driver_probe+0xba/0x100 drivers/usb/core/generic.c:238
 usb_probe_device+0xd9/0x2c0 drivers/usb/core/driver.c:293
 really_probe+0x291/0xde0 drivers/base/dd.c:554
 driver_probe_device+0x26b/0x3d0 drivers/base/dd.c:738
 __device_attach_driver+0x1d1/0x290 drivers/base/dd.c:844
 bus_for_each_drv+0x15f/0x1e0 drivers/base/bus.c:431
 __device_attach+0x228/0x4a0 drivers/base/dd.c:912
 bus_probe_device+0x1e4/0x290 drivers/base/bus.c:491
 device_add+0xbb2/0x1ce0 drivers/base/core.c:2936
 usb_new_device.cold+0x71d/0xfe9 drivers/usb/core/hub.c:2555
 hub_port_connect drivers/usb/core/hub.c:5223 [inline]
 hub_port_connect_change drivers/usb/core/hub.c:5363 [inline]
 port_event drivers/usb/core/hub.c:5509 [inline]
 hub_event+0x2348/0x42d0 drivers/usb/core/hub.c:5591
 process_one_work+0x933/0x1520 kernel/workqueue.c:2272
 process_scheduled_works kernel/workqueue.c:2334 [inline]
 worker_thread+0x82b/0x1120 kernel/workqueue.c:2420
 kthread+0x38c/0x460 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
