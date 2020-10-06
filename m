Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 261FB284851
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 10:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726737AbgJFITk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 04:19:40 -0400
Received: from mail-il1-f205.google.com ([209.85.166.205]:42438 "EHLO
        mail-il1-f205.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726299AbgJFITS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 04:19:18 -0400
Received: by mail-il1-f205.google.com with SMTP id 18so9441354ilt.9
        for <netdev@vger.kernel.org>; Tue, 06 Oct 2020 01:19:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=dQKSbS+kOJCUlmhK2n6YZyyyDGH1PGzF/zib8aCFtr0=;
        b=LEMNHuW9CURjtKqlI7V66Ur2HTNievSNsfomLsebaAJ5ZqIHmbDGosvz/deGjlwBQV
         qeTe7twL1Mrlbb9hfjZCOSQFYKM/cNV7aKcwJyhnEDfzQKIMOVpBcLweYFORml6j1Qoh
         klRbDxDuZEG2NXK0I80daBI0lS08/gs3D3Y8MupMJHjZlvz3xabCuhGT1MMgiQYih1yL
         QsJM8rIc3fR48XGY2awCjDa4c80FHlycqgXdYjW7ML0BbBlV+au5E0I4spe+b2WPi3Go
         CFptrgfxVrWsZn5hTe7noNvw5yAyZTi7bZq2bgPMVHtWBlcWOngTNMGy2kCwHET6IhAA
         HRjg==
X-Gm-Message-State: AOAM530R0SaDjkuMCTlip6eNh2+imcAHpZbCOss1J3G5JMxT4uT5DVH6
        ZM2nk6wF2V6zELh2+mukc8nkPFL/XkP3MTb3WRwvFxd/BoSz
X-Google-Smtp-Source: ABdhPJyd56cfSQaWC7WH1YoOhmEiAknO3aORwy5/MMZoQhFTFTPq0I8bjuOptYJebgGoS4TvPvAuepBwmlGfZ5IfC6qccLA7FEal
MIME-Version: 1.0
X-Received: by 2002:a05:6638:240f:: with SMTP id z15mr221000jat.38.1601972357320;
 Tue, 06 Oct 2020 01:19:17 -0700 (PDT)
Date:   Tue, 06 Oct 2020 01:19:17 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004c57c005b0fc4114@google.com>
Subject: INFO: task hung in usb_get_descriptor
From:   syzbot <syzbot+31ae6d17d115e980fd14@syzkaller.appspotmail.com>
To:     brouer@redhat.com, coreteam@netfilter.org, davem@davemloft.net,
        edumazet@google.com, gregkh@linuxfoundation.org,
        gustavoars@kernel.org, ingrassia@epigenesys.com, kaber@trash.net,
        kadlec@blackhole.kfki.hu, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    d3d45f82 Merge tag 'pinctrl-v5.9-2' of git://git.kernel.or..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1318aab7900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=89ab6a0c48f30b49
dashboard link: https://syzkaller.appspot.com/bug?extid=31ae6d17d115e980fd14
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17c69eeb900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17bebadb900000

The issue was bisected to:

commit c0303efeab7391ec51c337e0ac5740860ad01fe7
Author: Jesper Dangaard Brouer <brouer@redhat.com>
Date:   Mon Jan 9 15:04:09 2017 +0000

    net: reduce cycles spend on ICMP replies that gets rate limited

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=146872af900000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=166872af900000
console output: https://syzkaller.appspot.com/x/log.txt?x=126872af900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+31ae6d17d115e980fd14@syzkaller.appspotmail.com
Fixes: c0303efeab73 ("net: reduce cycles spend on ICMP replies that gets rate limited")

INFO: task kworker/0:0:5 blocked for more than 143 seconds.
      Not tainted 5.9.0-rc7-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/0:0     state:D stack:27376 pid:    5 ppid:     2 flags:0x00004000
Workqueue: usb_hub_wq hub_event
Call Trace:
 context_switch kernel/sched/core.c:3778 [inline]
 __schedule+0xec9/0x2280 kernel/sched/core.c:4527
 schedule+0xd0/0x2a0 kernel/sched/core.c:4602
 usb_kill_urb.part.0+0x197/0x220 drivers/usb/core/urb.c:696
 usb_kill_urb+0x7c/0x90 drivers/usb/core/urb.c:691
 usb_start_wait_urb+0x24a/0x2b0 drivers/usb/core/message.c:64
 usb_internal_control_msg drivers/usb/core/message.c:102 [inline]
 usb_control_msg+0x31c/0x4a0 drivers/usb/core/message.c:153
 usb_get_descriptor+0xc5/0x1b0 drivers/usb/core/message.c:655
 usb_get_device_descriptor+0x81/0xf0 drivers/usb/core/message.c:927
 hub_port_init+0x78f/0x2d80 drivers/usb/core/hub.c:4784
 hub_port_connect drivers/usb/core/hub.c:5140 [inline]
 hub_port_connect_change drivers/usb/core/hub.c:5348 [inline]
 port_event drivers/usb/core/hub.c:5494 [inline]
 hub_event+0x1e64/0x3e60 drivers/usb/core/hub.c:5576
 process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
 process_scheduled_works kernel/workqueue.c:2331 [inline]
 worker_thread+0x82b/0x1120 kernel/workqueue.c:2417
 kthread+0x3b5/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
INFO: task kworker/0:2:2474 blocked for more than 144 seconds.
      Not tainted 5.9.0-rc7-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/0:2     state:D stack:27416 pid: 2474 ppid:     2 flags:0x00004000
Workqueue: usb_hub_wq hub_event
Call Trace:
 context_switch kernel/sched/core.c:3778 [inline]
 __schedule+0xec9/0x2280 kernel/sched/core.c:4527
 schedule+0xd0/0x2a0 kernel/sched/core.c:4602
 usb_kill_urb.part.0+0x197/0x220 drivers/usb/core/urb.c:696
 usb_kill_urb+0x7c/0x90 drivers/usb/core/urb.c:691
 usb_start_wait_urb+0x24a/0x2b0 drivers/usb/core/message.c:64
 usb_internal_control_msg drivers/usb/core/message.c:102 [inline]
 usb_control_msg+0x31c/0x4a0 drivers/usb/core/message.c:153
 usb_get_descriptor+0xc5/0x1b0 drivers/usb/core/message.c:655
 usb_get_device_descriptor+0x81/0xf0 drivers/usb/core/message.c:927
 hub_port_init+0x78f/0x2d80 drivers/usb/core/hub.c:4784
 hub_port_connect drivers/usb/core/hub.c:5140 [inline]
 hub_port_connect_change drivers/usb/core/hub.c:5348 [inline]
 port_event drivers/usb/core/hub.c:5494 [inline]
 hub_event+0x1e64/0x3e60 drivers/usb/core/hub.c:5576
 process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
 kthread+0x3b5/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
INFO: task kworker/1:2:2597 blocked for more than 145 seconds.
      Not tainted 5.9.0-rc7-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/1:2     state:D stack:26824 pid: 2597 ppid:     2 flags:0x00004000
Workqueue: usb_hub_wq hub_event
Call Trace:
 context_switch kernel/sched/core.c:3778 [inline]
 __schedule+0xec9/0x2280 kernel/sched/core.c:4527
 schedule+0xd0/0x2a0 kernel/sched/core.c:4602
 usb_kill_urb.part.0+0x197/0x220 drivers/usb/core/urb.c:696
 usb_kill_urb+0x7c/0x90 drivers/usb/core/urb.c:691
 usb_start_wait_urb+0x24a/0x2b0 drivers/usb/core/message.c:64
 usb_internal_control_msg drivers/usb/core/message.c:102 [inline]
 usb_control_msg+0x31c/0x4a0 drivers/usb/core/message.c:153
 hub_port_init+0x11ae/0x2d80 drivers/usb/core/hub.c:4689
 hub_port_connect drivers/usb/core/hub.c:5140 [inline]
 hub_port_connect_change drivers/usb/core/hub.c:5348 [inline]
 port_event drivers/usb/core/hub.c:5494 [inline]
 hub_event+0x1e64/0x3e60 drivers/usb/core/hub.c:5576
 process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
 process_scheduled_works kernel/workqueue.c:2331 [inline]
 worker_thread+0x82b/0x1120 kernel/workqueue.c:2417
 kthread+0x3b5/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
INFO: task kworker/1:1:6869 blocked for more than 147 seconds.
      Not tainted 5.9.0-rc7-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/1:1     state:D stack:27848 pid: 6869 ppid:     2 flags:0x00004000
Workqueue: usb_hub_wq hub_event
Call Trace:
 context_switch kernel/sched/core.c:3778 [inline]
 __schedule+0xec9/0x2280 kernel/sched/core.c:4527
 schedule+0xd0/0x2a0 kernel/sched/core.c:4602
 usb_kill_urb.part.0+0x197/0x220 drivers/usb/core/urb.c:696
 usb_kill_urb+0x7c/0x90 drivers/usb/core/urb.c:691
 usb_start_wait_urb+0x24a/0x2b0 drivers/usb/core/message.c:64
 usb_internal_control_msg drivers/usb/core/message.c:102 [inline]
 usb_control_msg+0x31c/0x4a0 drivers/usb/core/message.c:153
 hub_port_init+0x11ae/0x2d80 drivers/usb/core/hub.c:4689
 hub_port_connect drivers/usb/core/hub.c:5140 [inline]
 hub_port_connect_change drivers/usb/core/hub.c:5348 [inline]
 port_event drivers/usb/core/hub.c:5494 [inline]
 hub_event+0x1e64/0x3e60 drivers/usb/core/hub.c:5576
 process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
 kthread+0x3b5/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
INFO: task kworker/1:3:6901 blocked for more than 149 seconds.
      Not tainted 5.9.0-rc7-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/1:3     state:D stack:27264 pid: 6901 ppid:     2 flags:0x00004000
Workqueue: usb_hub_wq hub_event
Call Trace:
 context_switch kernel/sched/core.c:3778 [inline]
 __schedule+0xec9/0x2280 kernel/sched/core.c:4527
 schedule+0xd0/0x2a0 kernel/sched/core.c:4602
 usb_kill_urb.part.0+0x197/0x220 drivers/usb/core/urb.c:696
 usb_kill_urb+0x7c/0x90 drivers/usb/core/urb.c:691
 usb_start_wait_urb+0x24a/0x2b0 drivers/usb/core/message.c:64
 usb_internal_control_msg drivers/usb/core/message.c:102 [inline]
 usb_control_msg+0x31c/0x4a0 drivers/usb/core/message.c:153
 hub_port_init+0x11ae/0x2d80 drivers/usb/core/hub.c:4689
 hub_port_connect drivers/usb/core/hub.c:5140 [inline]
 hub_port_connect_change drivers/usb/core/hub.c:5348 [inline]
 port_event drivers/usb/core/hub.c:5494 [inline]
 hub_event+0x1e64/0x3e60 drivers/usb/core/hub.c:5576
 process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
 process_scheduled_works kernel/workqueue.c:2331 [inline]
 worker_thread+0x82b/0x1120 kernel/workqueue.c:2417
 kthread+0x3b5/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
INFO: task kworker/0:1:6919 blocked for more than 151 seconds.
      Not tainted 5.9.0-rc7-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/0:1     state:D stack:27800 pid: 6919 ppid:     2 flags:0x00004000
Workqueue: usb_hub_wq hub_event
Call Trace:
 context_switch kernel/sched/core.c:3778 [inline]
 __schedule+0xec9/0x2280 kernel/sched/core.c:4527
 schedule+0xd0/0x2a0 kernel/sched/core.c:4602
 usb_kill_urb.part.0+0x197/0x220 drivers/usb/core/urb.c:696
 usb_kill_urb+0x7c/0x90 drivers/usb/core/urb.c:691
 usb_start_wait_urb+0x24a/0x2b0 drivers/usb/core/message.c:64
 usb_internal_control_msg drivers/usb/core/message.c:102 [inline]
 usb_control_msg+0x31c/0x4a0 drivers/usb/core/message.c:153
 hub_port_init+0x11ae/0x2d80 drivers/usb/core/hub.c:4689
 hub_port_connect drivers/usb/core/hub.c:5140 [inline]
 hub_port_connect_change drivers/usb/core/hub.c:5348 [inline]
 port_event drivers/usb/core/hub.c:5494 [inline]
 hub_event+0x1e64/0x3e60 drivers/usb/core/hub.c:5576
 process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
 process_scheduled_works kernel/workqueue.c:2331 [inline]
 worker_thread+0x82b/0x1120 kernel/workqueue.c:2417
 kthread+0x3b5/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

Showing all locks held in the system:
5 locks held by kworker/0:0/5:
 #0: ffff88821a8df938 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff88821a8df938 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff88821a8df938 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff88821a8df938 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff88821a8df938 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff88821a8df938 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: process_one_work+0x82b/0x1670 kernel/workqueue.c:2240
 #1: ffffc90000cbfda8 ((work_completion)(&hub->events)){+.+.}-{0:0}, at: process_one_work+0x85f/0x1670 kernel/workqueue.c:2244
 #2: ffff888217a2e218 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:785 [inline]
 #2: ffff888217a2e218 (&dev->mutex){....}-{3:3}, at: hub_event+0x1b6/0x3e60 drivers/usb/core/hub.c:5522
 #3: ffff888217a35588 (&port_dev->status_lock){+.+.}-{3:3}, at: usb_lock_port drivers/usb/core/hub.c:3012 [inline]
 #3: ffff888217a35588 (&port_dev->status_lock){+.+.}-{3:3}, at: hub_port_connect drivers/usb/core/hub.c:5139 [inline]
 #3: ffff888217a35588 (&port_dev->status_lock){+.+.}-{3:3}, at: hub_port_connect_change drivers/usb/core/hub.c:5348 [inline]
 #3: ffff888217a35588 (&port_dev->status_lock){+.+.}-{3:3}, at: port_event drivers/usb/core/hub.c:5494 [inline]
 #3: ffff888217a35588 (&port_dev->status_lock){+.+.}-{3:3}, at: hub_event+0x1e4f/0x3e60 drivers/usb/core/hub.c:5576
 #4: ffff888217a28468 (hcd->address0_mutex){+.+.}-{3:3}, at: hub_port_init+0x1b6/0x2d80 drivers/usb/core/hub.c:4563
2 locks held by kworker/u4:0/7:
 #0: ffff8880a7cad938 ((wq_completion)usbip_event){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff8880a7cad938 ((wq_completion)usbip_event){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff8880a7cad938 ((wq_completion)usbip_event){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff8880a7cad938 ((wq_completion)usbip_event){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff8880a7cad938 ((wq_completion)usbip_event){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff8880a7cad938 ((wq_completion)usbip_event){+.+.}-{0:0}, at: process_one_work+0x82b/0x1670 kernel/workqueue.c:2240
 #1: ffffc90000cdfda8 (usbip_work){+.+.}-{0:0}, at: process_one_work+0x85f/0x1670 kernel/workqueue.c:2244
1 lock held by khungtaskd/1172:
 #0: ffffffff8a067f40 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:5852
5 locks held by kworker/0:2/2474:
 #0: ffff88821a8df938 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff88821a8df938 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff88821a8df938 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff88821a8df938 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff88821a8df938 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff88821a8df938 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: process_one_work+0x82b/0x1670 kernel/workqueue.c:2240
 #1: ffffc9000859fda8 ((work_completion)(&hub->events)){+.+.}-{0:0}, at: process_one_work+0x85f/0x1670 kernel/workqueue.c:2244
 #2: ffff888217d02218 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:785 [inline]
 #2: ffff888217d02218 (&dev->mutex){....}-{3:3}, at: hub_event+0x1b6/0x3e60 drivers/usb/core/hub.c:5522
 #3: ffff8880a64c0588 (&port_dev->status_lock){+.+.}-{3:3}, at: usb_lock_port drivers/usb/core/hub.c:3012 [inline]
 #3: ffff8880a64c0588 (&port_dev->status_lock){+.+.}-{3:3}, at: hub_port_connect drivers/usb/core/hub.c:5139 [inline]
 #3: ffff8880a64c0588 (&port_dev->status_lock){+.+.}-{3:3}, at: hub_port_connect_change drivers/usb/core/hub.c:5348 [inline]
 #3: ffff8880a64c0588 (&port_dev->status_lock){+.+.}-{3:3}, at: port_event drivers/usb/core/hub.c:5494 [inline]
 #3: ffff8880a64c0588 (&port_dev->status_lock){+.+.}-{3:3}, at: hub_event+0x1e4f/0x3e60 drivers/usb/core/hub.c:5576
 #4: ffff8880a6c36968 (hcd->address0_mutex){+.+.}-{3:3}, at: hub_port_init+0x1b6/0x2d80 drivers/usb/core/hub.c:4563
5 locks held by kworker/1:2/2597:
 #0: ffff88821a8df938 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff88821a8df938 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff88821a8df938 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff88821a8df938 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff88821a8df938 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff88821a8df938 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: process_one_work+0x82b/0x1670 kernel/workqueue.c:2240
 #1: ffffc9000890fda8 ((work_completion)(&hub->events)){+.+.}-{0:0}, at: process_one_work+0x85f/0x1670 kernel/workqueue.c:2244
 #2: ffff8880a672c218 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:785 [inline]
 #2: ffff8880a672c218 (&dev->mutex){....}-{3:3}, at: hub_event+0x1b6/0x3e60 drivers/usb/core/hub.c:5522


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
