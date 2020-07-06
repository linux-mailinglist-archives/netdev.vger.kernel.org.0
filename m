Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FECF215A63
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 17:13:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729445AbgGFPMk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 11:12:40 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:57215 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729197AbgGFPM0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 11:12:26 -0400
Received: by mail-io1-f72.google.com with SMTP id a10so1232066ioc.23
        for <netdev@vger.kernel.org>; Mon, 06 Jul 2020 08:12:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=TzYgBgtLdr/DeVs0Hxvj64FqrkmyeFWyafb+XbBsR9Y=;
        b=W0+6/cVrqDjHcvOlH2GvSUsL8E0/2FX0M98k3FQAhyZqummCSMR1ouep8ZvUyxt+5p
         n1CovQLTU/5nHmkVCJ5qo34MN347o4TIAh2+a9L1xDpURwqHjK3sxIu1tegidXGGLXM3
         efvDI1KpsAgqfN46ko5nAs0Hz3AkHp7/J6H3Cqth3grcbs5pXWQoGd+xCK3YX11HOIC5
         lrGhfS5EfwVvw5t1iwb+FDRz6rdYntmhUfkagBUeqFWvkDGe6l8pZVExxWzDTcIhPPu9
         MXn5PNFVw8UwZnifqh9L1/vw42k2ONcLx5wZyBmDBKEHbQpGcjMG2avU1TGsKsRXlwJw
         A+fQ==
X-Gm-Message-State: AOAM532yAlBHShJwl7CE71ZddeMxXAJ90B+3bEVPglCgOYw87v091SQk
        hYss2KKdkDb2NSAgoliqenFKnJmkBm4PyTd2SNZq5aGBWl0f
X-Google-Smtp-Source: ABdhPJwWzB4Ug2eBl0sHsnahg2F4RVLNJ4tNxMRkMaVSpKpu6XH4rmWieOtcBhRtniedmyJAaQgohrKAsgrCq5NH9ekhaJCzUqjR
MIME-Version: 1.0
X-Received: by 2002:a05:6638:16c9:: with SMTP id g9mr42029289jat.118.1594048342622;
 Mon, 06 Jul 2020 08:12:22 -0700 (PDT)
Date:   Mon, 06 Jul 2020 08:12:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000037848f05a9c74d2a@google.com>
Subject: INFO: task hung in kaweth_control
From:   syzbot <syzbot+b85b5cbae26121d38b72@syzkaller.appspotmail.com>
To:     andreyknvl@google.com, davem@davemloft.net, hkallweit1@gmail.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, mhabets@solarflare.com, mst@redhat.com,
        netdev@vger.kernel.org, snelson@pensando.io,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    f8f02d5c USB: OTG: rename product list of devices
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git usb-testing
console output: https://syzkaller.appspot.com/x/log.txt?x=110df03d100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=63b40b2ae167bad6
dashboard link: https://syzkaller.appspot.com/bug?extid=b85b5cbae26121d38b72
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+b85b5cbae26121d38b72@syzkaller.appspotmail.com

INFO: task kworker/0:5:3300 blocked for more than 143 seconds.
      Not tainted 5.8.0-rc1-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kworker/0:5     D24656  3300      2 0x80004000
Workqueue: usb_hub_wq hub_event
Call Trace:
 context_switch kernel/sched/core.c:3430 [inline]
 __schedule+0x88a/0x1cb0 kernel/sched/core.c:4155
 schedule+0xcd/0x2b0 kernel/sched/core.c:4230
 schedule_timeout+0x148/0x250 kernel/time/timer.c:1897
 usb_start_wait_urb.constprop.0+0x2ad/0x2f0 drivers/net/usb/kaweth.c:1238
 kaweth_internal_control_msg drivers/net/usb/kaweth.c:1274 [inline]
 kaweth_control.constprop.0+0x361/0x4f0 drivers/net/usb/kaweth.c:269
 kaweth_read_configuration drivers/net/usb/kaweth.c:287 [inline]
 kaweth_probe.cold+0xaa/0x12ec drivers/net/usb/kaweth.c:1065
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
INFO: task syz-executor.1:5510 blocked for more than 143 seconds.
      Not tainted 5.8.0-rc1-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor.1  D29088  5510    340 0x80004006
Call Trace:
 context_switch kernel/sched/core.c:3430 [inline]
 __schedule+0x88a/0x1cb0 kernel/sched/core.c:4155
 schedule+0xcd/0x2b0 kernel/sched/core.c:4230
 wdm_flush+0x2e9/0x3c0 drivers/usb/class/cdc-wdm.c:590
 filp_close+0xb4/0x170 fs/open.c:1282
 close_files fs/file.c:388 [inline]
 put_files_struct fs/file.c:416 [inline]
 put_files_struct+0x1d0/0x350 fs/file.c:413
 exit_files+0x7e/0xa0 fs/file.c:445
 do_exit+0xb74/0x28f0 kernel/exit.c:800
 do_group_exit+0x125/0x310 kernel/exit.c:903
 get_signal+0x42d/0x1fd0 kernel/signal.c:2739
 do_signal+0x88/0x1a00 arch/x86/kernel/signal.c:810
 exit_to_usermode_loop arch/x86/entry/common.c:212 [inline]
 __prepare_exit_to_usermode+0x169/0x1a0 arch/x86/entry/common.c:246
 do_syscall_64+0x5c/0x90 arch/x86/entry/common.c:368
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45cb09
Code: Bad RIP value.
RSP: 002b:00007f72e3b1dcf8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: fffffffffffffe00 RBX: 000000000078c0e8 RCX: 000000000045cb09
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 000000000078c0e8
RBP: 000000000078c0e0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000078c0ec
R13: 00007fff2b7b94ff R14: 00007f72e3b1e9c0 R15: 000000000078c0ec
INFO: task syz-executor.3:5543 blocked for more than 144 seconds.
      Not tainted 5.8.0-rc1-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor.3  D29088  5543    339 0x80004006
Call Trace:
 context_switch kernel/sched/core.c:3430 [inline]
 __schedule+0x88a/0x1cb0 kernel/sched/core.c:4155
 schedule+0xcd/0x2b0 kernel/sched/core.c:4230
 wdm_flush+0x2e9/0x3c0 drivers/usb/class/cdc-wdm.c:590
 filp_close+0xb4/0x170 fs/open.c:1282
 close_files fs/file.c:388 [inline]
 put_files_struct fs/file.c:416 [inline]
 put_files_struct+0x1d0/0x350 fs/file.c:413
 exit_files+0x7e/0xa0 fs/file.c:445
 do_exit+0xb74/0x28f0 kernel/exit.c:800
 do_group_exit+0x125/0x310 kernel/exit.c:903
 get_signal+0x42d/0x1fd0 kernel/signal.c:2739
 do_signal+0x88/0x1a00 arch/x86/kernel/signal.c:810
 exit_to_usermode_loop arch/x86/entry/common.c:212 [inline]
 __prepare_exit_to_usermode+0x169/0x1a0 arch/x86/entry/common.c:246
 do_syscall_64+0x5c/0x90 arch/x86/entry/common.c:368
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45cb09
Code: Bad RIP value.
RSP: 002b:00007f0a66f3ecf8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: fffffffffffffe00 RBX: 000000000078bfa8 RCX: 000000000045cb09
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 000000000078bfa8
RBP: 000000000078bfa0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000078bfac
R13: 00007ffe67b5466f R14: 00007f0a66f3f9c0 R15: 000000000078bfac
INFO: task syz-executor.4:5573 blocked for more than 144 seconds.
      Not tainted 5.8.0-rc1-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor.4  D29280  5573    341 0x80004006
Call Trace:
 context_switch kernel/sched/core.c:3430 [inline]
 __schedule+0x88a/0x1cb0 kernel/sched/core.c:4155
 schedule+0xcd/0x2b0 kernel/sched/core.c:4230
 wdm_flush+0x2e9/0x3c0 drivers/usb/class/cdc-wdm.c:590
 filp_close+0xb4/0x170 fs/open.c:1282
 close_files fs/file.c:388 [inline]
 put_files_struct fs/file.c:416 [inline]
 put_files_struct+0x1d0/0x350 fs/file.c:413
 exit_files+0x7e/0xa0 fs/file.c:445
 do_exit+0xb74/0x28f0 kernel/exit.c:800
 do_group_exit+0x125/0x310 kernel/exit.c:903
 get_signal+0x42d/0x1fd0 kernel/signal.c:2739
 do_signal+0x88/0x1a00 arch/x86/kernel/signal.c:810
 exit_to_usermode_loop arch/x86/entry/common.c:212 [inline]
 __prepare_exit_to_usermode+0x169/0x1a0 arch/x86/entry/common.c:246
 do_syscall_64+0x5c/0x90 arch/x86/entry/common.c:368
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45cb09
Code: Bad RIP value.
RSP: 002b:00007f65c5dc3cf8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: fffffffffffffe00 RBX: 000000000078bfa8 RCX: 000000000045cb09
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 000000000078bfa8
RBP: 000000000078bfa0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000078bfac
R13: 00007fffacad4e1f R14: 00007f65c5dc49c0 R15: 000000000078bfac

Showing all locks held in the system:
1 lock held by khungtaskd/23:
 #0: ffffffff8730f960 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x264 kernel/locking/lockdep.c:5779
1 lock held by in:imklog/229:
 #0: ffff8881c58ba870 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0xe9/0x100 fs/file.c:826
5 locks held by kworker/0:3/3031:
 #0: ffff8881d880ed38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff8881d880ed38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff8881d880ed38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff8881d880ed38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff8881d880ed38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff8881d880ed38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: process_one_work+0x82b/0x15f0 kernel/workqueue.c:2240
 #1: ffff8881d0e27da8 ((work_completion)(&hub->events)){+.+.}-{0:0}, at: process_one_work+0x85f/0x15f0 kernel/workqueue.c:2244
 #2: ffff8881d453c218 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:768 [inline]
 #2: ffff8881d453c218 (&dev->mutex){....}-{3:3}, at: hub_event+0x1c5/0x4390 drivers/usb/core/hub.c:5522
 #3: ffff8881c5e92218 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:768 [inline]
 #3: ffff8881c5e92218 (&dev->mutex){....}-{3:3}, at: __device_attach+0x7a/0x430 drivers/base/dd.c:850
 #4: ffff8881c750c1a8 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:768 [inline]
 #4: ffff8881c750c1a8 (&dev->mutex){....}-{3:3}, at: __device_attach+0x7a/0x430 drivers/base/dd.c:850
5 locks held by kworker/0:5/3300:
 #0: ffff8881d880ed38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff8881d880ed38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff8881d880ed38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff8881d880ed38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff8881d880ed38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff8881d880ed38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: process_one_work+0x82b/0x15f0 kernel/workqueue.c:2240
 #1: ffff8881c9ac7da8 ((work_completion)(&hub->events)){+.+.}-{0:0}, at: process_one_work+0x85f/0x15f0 kernel/workqueue.c:2244
 #2: ffff8881d4514218 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:768 [inline]
 #2: ffff8881d4514218 (&dev->mutex){....}-{3:3}, at: hub_event+0x1c5/0x4390 drivers/usb/core/hub.c:5522
 #3: ffff8881cdeca218 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:768 [inline]
 #3: ffff8881cdeca218 (&dev->mutex){....}-{3:3}, at: __device_attach+0x7a/0x430 drivers/base/dd.c:850
 #4: ffff8881c31611a8 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:768 [inline]
 #4: ffff8881c31611a8 (&dev->mutex){....}-{3:3}, at: __device_attach+0x7a/0x430 drivers/base/dd.c:850

=============================================

NMI backtrace for cpu 1
CPU: 1 PID: 23 Comm: khungtaskd Not tainted 5.8.0-rc1-syzkaller #0
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
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0 skipped: idling at native_safe_halt arch/x86/include/asm/irqflags.h:60 [inline]
NMI backtrace for cpu 0 skipped: idling at arch_safe_halt arch/x86/include/asm/irqflags.h:103 [inline]
NMI backtrace for cpu 0 skipped: idling at acpi_safe_halt+0x72/0x90 drivers/acpi/processor_idle.c:111


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
