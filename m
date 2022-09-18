Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC6CA5BBDF9
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 15:22:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbiIRNWO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 09:22:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiIRNWN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 09:22:13 -0400
Received: from mail-vs1-xe2d.google.com (mail-vs1-xe2d.google.com [IPv6:2607:f8b0:4864:20::e2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C96D0205CC;
        Sun, 18 Sep 2022 06:22:11 -0700 (PDT)
Received: by mail-vs1-xe2d.google.com with SMTP id o123so27382365vsc.3;
        Sun, 18 Sep 2022 06:22:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date;
        bh=//O0omMWgcCBtjjmuALMYzfccTPdn10XSKDe7Ops+fg=;
        b=NwmpWC9RxYUXuB6Dx9ARB5bkq7Jx5Qk8YLTzpVR6wabEeJTwu+0vl5pL0YskFudl4A
         5FY2yU9nRAf3IeywU4dITF1t9RJa9296uWKup70VSiIyKbOypCizdEeAifRWroxc/cA/
         uCPc/bece+kqdpqfy77lJz4tKocDFHcoJQbU4C9qnAaa1YeJOtV+nQQc9c05+0GA65F5
         1jrxc9RU8+7gJ3B7UHEymHKkZertd9zKDlIzsnSkZZQMi06+roQohAW919I09tqgQqqz
         QiuwV1UPE45jfXfHjkuR2uzFKp/o5adKFU4ONTOWWaA71CGHmKhABpTZJkyrQqKiQGvZ
         SDBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date;
        bh=//O0omMWgcCBtjjmuALMYzfccTPdn10XSKDe7Ops+fg=;
        b=NF0dA89fXnzjFZnJFjBxc9ycc2x8IMOCt2JYjmstXyfQx2iRqfGe1iieUGaF+lUZDA
         6yrjLi4MoONNzvE3N0rcc9auN7Nwq21lawis+Dj+1GYIMmFFtZrXjUj9m7YLV8yAIKjw
         4PjImGGdWV4bzD27znU07sBRNe6P9q8/CHzQR+xLJIeizb/ZVOqNY5qAlWKZAPGNowA+
         Bt8hRqeIi7FRzI+QWrW08SlPIgdihMHVz0da6D+7tTvp/UfZwWOiKvQWZ5P3ho3Y18Z9
         3Bd+TUVF6tJ5KC5sos0jzmHhrFF3upg3ximDuVrgIkBhiFTr2TK6Wt0k7pxjv90bMw1L
         JlSA==
X-Gm-Message-State: ACrzQf34utUqdoqy51fyyMjrr3yUFzd9c6hY/afaqslwNbUrxgTgOZiz
        ORyCByFlztILdqs6N3UcoPeAzZZq1fpUgwucBfHnpp1PPHo=
X-Google-Smtp-Source: AMsMyM6GkZBfHFO47gmiGKaWd3BxJxQT+8x+4Yot3DE+Pp9FyyUWM58eT9R207A2XJYUowQc/Wjs7oJLOPQwKFJJN0w=
X-Received: by 2002:a67:be16:0:b0:398:c2e4:e01f with SMTP id
 x22-20020a67be16000000b00398c2e4e01fmr4595187vsq.33.1663507330837; Sun, 18
 Sep 2022 06:22:10 -0700 (PDT)
MIME-Version: 1.0
From:   Rondreis <linhaoguo86@gmail.com>
Date:   Sun, 18 Sep 2022 21:22:00 +0800
Message-ID: <CAB7eexL3ac2jxVQ70Q06F6sK9VdwY2aoO=S6OqYu7DTgFMg6tQ@mail.gmail.com>
Subject: task hung in port100_send_cmd_sync
To:     krzysztof.kozlowski@linaro.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

When fuzzing the Linux kernel driver v6.0-rc4, the following crash was
triggered.

HEAD commit: 7e18e42e4b280c85b76967a9106a13ca61c16179
git tree: upstream

kernel config: https://pastebin.com/raw/xtrgsXP3
C reproducer: https://pastebin.com/raw/hjSnLzDh
console output: https://pastebin.com/raw/3ixbVNcR

Basically, in the c reproducer, we use the gadget module to emulate
attaching a USB device(vendor id: 0x54c, product id: 0x6c1, with the
printer function) and executing some simple sequence of system calls.
To reproduce this crash, we utilize a third-party library to emulate
the attaching process: https://github.com/linux-usb-gadgets/libusbgx.
Just clone this repository, install it, and compile the c
reproducer with ``` gcc crash.c -lusbgx -lconfig -o crash ``` will do
the trick.

I would appreciate it if you have any idea how to solve this bug.

The crash report is as follows:

INFO: task kworker/1:4:6368 blocked for more than 143 seconds.
      Not tainted 6.0.0-rc4+ #20
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/1:4     state:D stack:22128 pid: 6368 ppid:     2 flags:0x00004000
Workqueue: usb_hub_wq hub_event
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5182 [inline]
 __schedule+0x975/0x2620 kernel/sched/core.c:6494
 schedule+0xda/0x1b0 kernel/sched/core.c:6570
 schedule_timeout+0x5e5/0x890 kernel/time/timer.c:1911
 do_wait_for_common kernel/sched/completion.c:85 [inline]
 __wait_for_common kernel/sched/completion.c:106 [inline]
 wait_for_common kernel/sched/completion.c:117 [inline]
 wait_for_completion+0x182/0x360 kernel/sched/completion.c:138
 port100_send_cmd_sync+0xc1/0x120 drivers/nfc/port100.c:926
 port100_get_command_type_mask drivers/nfc/port100.c:1011 [inline]
 port100_probe+0x86b/0xea0 drivers/nfc/port100.c:1557
 usb_probe_interface+0x361/0x800 drivers/usb/core/driver.c:396
 call_driver_probe drivers/base/dd.c:560 [inline]
 really_probe+0x249/0xa90 drivers/base/dd.c:639
 __driver_probe_device+0x1df/0x4d0 drivers/base/dd.c:778
 driver_probe_device+0x4c/0x1a0 drivers/base/dd.c:808
 __device_attach_driver+0x1da/0x2d0 drivers/base/dd.c:936
 bus_for_each_drv+0x15f/0x1e0 drivers/base/bus.c:427
 __device_attach+0x283/0x480 drivers/base/dd.c:1008
 bus_probe_device+0x1e4/0x290 drivers/base/bus.c:487
 device_add+0xc96/0x1da0 drivers/base/core.c:3517
 usb_set_configuration+0x1014/0x1900 drivers/usb/core/message.c:2170
 usb_generic_driver_probe+0x9d/0xe0 drivers/usb/core/generic.c:238
 usb_probe_device+0xd4/0x2a0 drivers/usb/core/driver.c:293
 call_driver_probe drivers/base/dd.c:560 [inline]
 really_probe+0x249/0xa90 drivers/base/dd.c:639
 __driver_probe_device+0x1df/0x4d0 drivers/base/dd.c:778
 driver_probe_device+0x4c/0x1a0 drivers/base/dd.c:808
 __device_attach_driver+0x1da/0x2d0 drivers/base/dd.c:936
 bus_for_each_drv+0x15f/0x1e0 drivers/base/bus.c:427
 __device_attach+0x283/0x480 drivers/base/dd.c:1008
 bus_probe_device+0x1e4/0x290 drivers/base/bus.c:487
 device_add+0xc96/0x1da0 drivers/base/core.c:3517
 usb_new_device.cold+0x69d/0x10ef drivers/usb/core/hub.c:2573
 hub_port_connect drivers/usb/core/hub.c:5353 [inline]
 hub_port_connect_change drivers/usb/core/hub.c:5497 [inline]
 port_event drivers/usb/core/hub.c:5653 [inline]
 hub_event+0x23bd/0x4260 drivers/usb/core/hub.c:5735
 process_one_work+0x9c7/0x1650 kernel/workqueue.c:2289
 worker_thread+0x623/0x1070 kernel/workqueue.c:2436
 kthread+0x2e9/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
 </TASK>

Showing all locks held in the system:
2 locks held by kworker/u4:1/12:
1 lock held by rcu_tasks_kthre/13:
 #0: ffffffff8cb84f30 (rcu_tasks.tasks_gp_mutex){+.+.}-{3:3}, at:
rcu_tasks_one_gp+0x26/0xce0 kernel/rcu/tasks.h:507
1 lock held by rcu_tasks_trace/14:
 #0: ffffffff8cb84c30 (rcu_tasks_trace.tasks_gp_mutex){+.+.}-{3:3},
at: rcu_tasks_one_gp+0x26/0xce0 kernel/rcu/tasks.h:507
1 lock held by khungtaskd/31:
 #0: ffffffff8cb85a80 (rcu_read_lock){....}-{1:2}, at:
debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:6492
1 lock held by in:imklog/6287:
 #0: ffff888040287c68 (&f->f_pos_lock){+.+.}-{3:3}, at:
__fdget_pos+0xe3/0x100 fs/file.c:1036
5 locks held by kworker/1:4/6368:
 #0: ffff8880421b6d38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at:
arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff8880421b6d38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at:
arch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]
 #0: ffff8880421b6d38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at:
atomic_long_set include/linux/atomic/atomic-instrumented.h:1280
[inline]
 #0: ffff8880421b6d38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at:
set_work_data kernel/workqueue.c:636 [inline]
 #0: ffff8880421b6d38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at:
set_work_pool_and_clear_pending kernel/workqueue.c:663 [inline]
 #0: ffff8880421b6d38 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at:
process_one_work+0x8b0/0x1650 kernel/workqueue.c:2260
 #1: ffffc900020dfdb0 ((work_completion)(&hub->events)){+.+.}-{0:0},
at: process_one_work+0x8e4/0x1650 kernel/workqueue.c:2264
 #2: ffff888018804190 (&dev->mutex){....}-{3:3}, at: device_lock
include/linux/device.h:835 [inline]
 #2: ffff888018804190 (&dev->mutex){....}-{3:3}, at:
hub_event+0x1bc/0x4260 drivers/usb/core/hub.c:5681
 #3: ffff888065fb7190 (&dev->mutex){....}-{3:3}, at: device_lock
include/linux/device.h:835 [inline]
 #3: ffff888065fb7190 (&dev->mutex){....}-{3:3}, at:
__device_attach+0x76/0x480 drivers/base/dd.c:983
 #4: ffff888029c17118 (&dev->mutex){....}-{3:3}, at: device_lock
include/linux/device.h:835 [inline]
 #4: ffff888029c17118 (&dev->mutex){....}-{3:3}, at:
__device_attach+0x76/0x480 drivers/base/dd.c:983
1 lock held by syz-fuzzer/6404:
1 lock held by syz-fuzzer/6410:
 #0: ffff888065fb7190 (&dev->mutex){....}-{3:3}, at: device_lock
include/linux/device.h:835 [inline]
 #0: ffff888065fb7190 (&dev->mutex){....}-{3:3}, at:
usbdev_open+0x19d/0x930 drivers/usb/core/devio.c:1042
1 lock held by syz-fuzzer/6414:
1 lock held by syz-fuzzer/15233:

=============================================

NMI backtrace for cpu 0
CPU: 0 PID: 31 Comm: khungtaskd Not tainted 6.0.0-rc4+ #20
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.13.0-1ubuntu1.1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 nmi_cpu_backtrace.cold+0x46/0x14f lib/nmi_backtrace.c:111
 nmi_trigger_cpumask_backtrace+0x1c5/0x210 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:148 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:212 [inline]
 watchdog+0xcc3/0x1000 kernel/hung_task.c:369
 kthread+0x2e9/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
 </TASK>
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 PID: 20164 Comm: kworker/1:3 Not tainted 6.0.0-rc4+ #20
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.13.0-1ubuntu1.1 04/01/2014
Workqueue: events nsim_dev_trap_report_work
RIP: 0010:unwind_next_frame+0x11f4/0x1ab0 arch/x86/kernel/unwind_orc.c:629
Code: 39 d4 0f 92 c0 84 c1 74 0b 48 3b 6c 24 18 0f 86 c3 01 00 00 bf
01 00 00 00 e8 d8 ee 1b 00 b8 01 00 00 00 65 8b 15 0c e5 cb 7e <85> d2
0f 85 91 ee ff ff e8 49 ea c9 ff e9 87 ee ff ff 49 8d 78 02
RSP: 0018:ffffc9000757f6a8 EFLAGS: 00000293
RAX: 0000000000000001 RBX: 1ffff92000eafedd RCX: 0000000000000000
RDX: 0000000080000001 RSI: ffffc9000757fef0 RDI: 0000000000000001
RBP: ffffc9000757ff20 R08: ffffffff8f194e92 R09: 0000000000000001
R10: ffffc9000757f80f R11: 000000000008a07a R12: ffffc90007578000
R13: ffffc9000757f7e1 R14: ffffc9000757f7a0 R15: ffffc9000757f7e0
FS:  0000000000000000(0000) GS:ffff88807ec00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f61d1980000 CR3: 000000004580d000 CR4: 0000000000350ee0
Call Trace:
 <TASK>
 arch_stack_walk+0x7d/0xe0 arch/x86/kernel/stacktrace.c:25
 stack_trace_save+0x8c/0xc0 kernel/stacktrace.c:122
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:45 [inline]
 set_alloc_info mm/kasan/common.c:437 [inline]
 __kasan_slab_alloc+0x90/0xc0 mm/kasan/common.c:470
 kasan_slab_alloc include/linux/kasan.h:224 [inline]
 slab_post_alloc_hook+0x4d/0x4f0 mm/slab.h:727
 slab_alloc_node mm/slub.c:3243 [inline]
 kmem_cache_alloc_node+0x1b7/0x3a0 mm/slub.c:3293
 __alloc_skb+0x273/0x320 net/core/skbuff.c:418
 alloc_skb include/linux/skbuff.h:1257 [inline]
 nsim_dev_trap_skb_build drivers/net/netdevsim/dev.c:742 [inline]
 nsim_dev_trap_report drivers/net/netdevsim/dev.c:799 [inline]
 nsim_dev_trap_report_work+0x2ba/0xc40 drivers/net/netdevsim/dev.c:844
 process_one_work+0x9c7/0x1650 kernel/workqueue.c:2289
 worker_thread+0x623/0x1070 kernel/workqueue.c:2436
 kthread+0x2e9/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
 </TASK>
