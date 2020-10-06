Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E1E2284843
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 10:19:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbgJFITT convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 6 Oct 2020 04:19:19 -0400
Received: from mail-io1-f80.google.com ([209.85.166.80]:53788 "EHLO
        mail-io1-f80.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbgJFITT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 04:19:19 -0400
Received: by mail-io1-f80.google.com with SMTP id x1so6650833iov.20
        for <netdev@vger.kernel.org>; Tue, 06 Oct 2020 01:19:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to
         :content-transfer-encoding;
        bh=+HcSobxVvGQHZab0mThAeS+WsclToV8ohddZNLV7vPs=;
        b=DCzOmBAYAXJb7DVJ+wNSF+6xMqCrl77rcLObSFaW/qS7kAhzWaYI2nB+djFk7jHc2e
         EKqBAVO4LzjIb4YXmzVSgfCfQFpM7790rSaDyxKTUQNM4YPGmrl2Z6WHh+t4MJYh6sQP
         uucyTi8fdtGLYzG/OhwHOzmDJIHcBYZydwNPd/vv1Mm0FC8O+bjU6/X5bnFNIAyLsY2T
         hVdaYFzufUykRWkEVLHxkTOmEXjk7697MAHoNMg34D3nlVbTVu9iHYSSx9hPkBYTq0SL
         GWGsqGx/EbS0vcHUkhcE1ZW7bPWDKTeBXQpmC1WO5sSjHZxVExPW8BVSWqXEzSosx3PA
         YvAw==
X-Gm-Message-State: AOAM53011h2LfrutDyhMQf5Mk2u5xyDnDXPVZlXzNtZe9pCYOhkEU2lw
        JCak8dCJ9fdBM5nIUaHchr0KEwMwAMyjJ5dNAPwR/FLVhn8w
X-Google-Smtp-Source: ABdhPJyKkjwpbIN1IH4cBrbOMObgcQ7S6a8vKtcJkVsTBQiZUXFqz8bh2OmxeV9bUTunTwKx7ep7iYV183tmmeNm7VY47yzqKtj2
MIME-Version: 1.0
X-Received: by 2002:a92:484e:: with SMTP id v75mr2682129ila.293.1601972357048;
 Tue, 06 Oct 2020 01:19:17 -0700 (PDT)
Date:   Tue, 06 Oct 2020 01:19:17 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004831d405b0fc41d2@google.com>
Subject: INFO: task hung in hub_port_init
From:   syzbot <syzbot+74d6ef051d3d2eacf428@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net,
        gregkh@linuxfoundation.org, gustavoars@kernel.org,
        ingrassia@epigenesys.com, kaber@trash.net,
        kadlec@blackhole.kfki.hu, linux-kernel@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        niklas.soderlund+renesas@ragnatech.se, pablo@netfilter.org,
        sergei.shtylyov@cogentembedded.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    d3d45f82 Merge tag 'pinctrl-v5.9-2' of git://git.kernel.or..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14c3b3db900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=89ab6a0c48f30b49
dashboard link: https://syzkaller.appspot.com/bug?extid=74d6ef051d3d2eacf428
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=153bf5bd900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=124c92af900000

The issue was bisected to:

commit 6dcf45e514974a1ff10755015b5e06746a033e5f
Author: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Date:   Mon Jan 9 15:34:04 2017 +0000

    sh_eth: use correct name for ECMR_MPDE bit

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=152bb760500000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=172bb760500000
console output: https://syzkaller.appspot.com/x/log.txt?x=132bb760500000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+74d6ef051d3d2eacf428@syzkaller.appspotmail.com
Fixes: 6dcf45e51497 ("sh_eth: use correct name for ECMR_MPDE bit")

INFO: task kworker/0:0:5 blocked for more than 143 seconds.
      Not tainted 5.9.0-rc7-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/0:0     state:D stack:27664 pid:    5 ppid:     2 flags:0x00004000
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
INFO: task kworker/1:2:2641 blocked for more than 144 seconds.
      Not tainted 5.9.0-rc7-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/1:2     state:D stack:26992 pid: 2641 ppid:     2 flags:0x00004000
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
INFO: task kworker/1:1:6862 blocked for more than 146 seconds.
      Not tainted 5.9.0-rc7-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/1:1     state:D stack:26864 pid: 6862 ppid:     2 flags:0x00004000
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
INFO: task kworker/0:1:6870 blocked for more than 148 seconds.
      Not tainted 5.9.0-rc7-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/0:1     state:D stack:27416 pid: 6870 ppid:     2 flags:0x00004000
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
INFO: task kworker/1:3:6898 blocked for more than 150 seconds.
      Not tainted 5.9.0-rc7-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/1:3     state:D stack:27256 pid: 6898 ppid:     2 flags:0x00004000
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

Showing all locks held in the system:
5 locks held by kworker/0:0/5:
 #0: ffff8880a62d8538 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff8880a62d8538 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff8880a62d8538 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff8880a62d8538 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff8880a62d8538 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff8880a62d8538 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: process_one_work+0x82b/0x1670 kernel/workqueue.c:2240
 #1: ffffc90000cbfda8 ((work_completion)(&hub->events)){+.+.}-{0:0}, at: process_one_work+0x85f/0x1670 kernel/workqueue.c:2244
 #2: ffff88809e17a218 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:785 [inline]
 #2: ffff88809e17a218 (&dev->mutex){....}-{3:3}, at: hub_event+0x1b6/0x3e60 drivers/usb/core/hub.c:5522
 #3: ffff88809e163588 (&port_dev->status_lock){+.+.}-{3:3}, at: usb_lock_port drivers/usb/core/hub.c:3012 [inline]
 #3: ffff88809e163588 (&port_dev->status_lock){+.+.}-{3:3}, at: hub_port_connect drivers/usb/core/hub.c:5139 [inline]
 #3: ffff88809e163588 (&port_dev->status_lock){+.+.}-{3:3}, at: hub_port_connect_change drivers/usb/core/hub.c:5348 [inline]
 #3: ffff88809e163588 (&port_dev->status_lock){+.+.}-{3:3}, at: port_event drivers/usb/core/hub.c:5494 [inline]
 #3: ffff88809e163588 (&port_dev->status_lock){+.+.}-{3:3}, at: hub_event+0x1e4f/0x3e60 drivers/usb/core/hub.c:5576
 #4: ffff888217aea068 (hcd->address0_mutex){+.+.}-{3:3}, at: hub_port_init+0x1b6/0x2d80 drivers/usb/core/hub.c:4563
2 locks held by kworker/u4:4/208:
1 lock held by khungtaskd/1167:
 #0: ffffffff8a067f40 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:5852
5 locks held by kworker/1:2/2641:
 #0: ffff8880a62d8538 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff8880a62d8538 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff8880a62d8538 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff8880a62d8538 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff8880a62d8538 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff8880a62d8538 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: process_one_work+0x82b/0x1670 kernel/workqueue.c:2240
 #1: ffffc90008de7da8 ((work_completion)(&hub->events)){+.+.}-{0:0}, at: process_one_work+0x85f/0x1670 kernel/workqueue.c:2244
 #2: ffff88809e5de218 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:785 [inline]
 #2: ffff88809e5de218 (&dev->mutex){....}-{3:3}, at: hub_event+0x1b6/0x3e60 drivers/usb/core/hub.c:5522
 #3: ffff88809e594588 (&port_dev->status_lock){+.+.}-{3:3}, at: usb_lock_port drivers/usb/core/hub.c:3012 [inline]
 #3: ffff88809e594588 (&port_dev->status_lock){+.+.}-{3:3}, at: hub_port_connect drivers/usb/core/hub.c:5139 [inline]
 #3: ffff88809e594588 (&port_dev->status_lock){+.+.}-{3:3}, at: hub_port_connect_change drivers/usb/core/hub.c:5348 [inline]
 #3: ffff88809e594588 (&port_dev->status_lock){+.+.}-{3:3}, at: port_event drivers/usb/core/hub.c:5494 [inline]
 #3: ffff88809e594588 (&port_dev->status_lock){+.+.}-{3:3}, at: hub_event+0x1e4f/0x3e60 drivers/usb/core/hub.c:5576
 #4: ffff888217ba0c68 (hcd->address0_mutex){+.+.}-{3:3}, at: hub_port_init+0x1b6/0x2d80 drivers/usb/core/hub.c:4563
1 lock held by in:imklog/6751:
 #0: ffff8880a25dc3f0 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0xe9/0x100 fs/file.c:930
5 locks held by kworker/1:1/6862:
 #0: ffff8880a62d8538 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff8880a62d8538 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff8880a62d8538 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff8880a62d8538 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff8880a62d8538 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff8880a62d8538 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: process_one_work+0x82b/0x1670 kernel/workqueue.c:2240
 #1: ffffc900056b7da8 ((work_completion)(&hub->events)){+.+.}-{0:0}, at: process_one_work+0x85f/0x1670 kernel/workqueue.c:2244
 #2: ffff88809e2f5218 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:785 [inline]
 #2: ffff88809e2f5218 (&dev->mutex){....}-{3:3}, at: hub_event+0x1b6/0x3e60 drivers/usb/core/hub.c:5522
 #3: ffff888217ac8588 (&port_dev->status_lock){+.+.}-{3:3}, at: usb_lock_port drivers/usb/core/hub.c:3012 [inline]
 #3: ffff888217ac8588 (&port_dev->status_lock){+.+.}-{3:3}, at: hub_port_connect drivers/usb/core/hub.c:5139 [inline]
 #3: ffff888217ac8588 (&port_dev->status_lock){+.+.}-{3:3}, at: hub_port_connect_change drivers/usb/core/hub.c:5348 [inline]
 #3: ffff888217ac8588 (&port_dev->status_lock){+.+.}-{3:3}, at: port_event drivers/usb/core/hub.c:5494 [inline]
 #3: ffff888217ac8588 (&port_dev->status_lock){+.+.}-{3:3}, at: hub_event+0x1e4f/0x3e60 drivers/usb/core/hub.c:5576
 #4: ffff888217a6c268 (hcd->address0_mutex){+.+.}-{3:3}, at: hub_port_init+0x1b6/0x2d80 drivers/usb/core/hub.c:4563
5 locks held by kworker/0:1/6870:


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
