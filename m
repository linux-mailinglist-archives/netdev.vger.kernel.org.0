Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C82933D0675
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 03:37:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbhGUA4u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 20:56:50 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:48682 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbhGUA4q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 20:56:46 -0400
Received: by mail-io1-f69.google.com with SMTP id d17-20020a0566022291b029053e3f025a44so452546iod.15
        for <netdev@vger.kernel.org>; Tue, 20 Jul 2021 18:37:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=xGh5T0/2bSvJq3lfuHXcSiIvHfBY/6eeHOugnt3cUOg=;
        b=hZKBMik5kBOkmvEgLoL32gZeSP18m4O3a+nK4GmonJfPC3FI+ALJ0muIEm1PkzPFIL
         LRaFUfNt9wZemP2YExyRU3ex+/022hNa2s1IB895FLICIh9GIbUbx4Rb1ah4MeQsNrlH
         zOOf6EdTZvZIIKTQCKyQ35VhWJP2uEP/qpChRadsLBNE1CD/pZLwLFWIuF9rH9k2UeWy
         769iCt4JzwqPGr6BRL3Ml1cSmu5Y52ModlFiP+ZZ78+1Xt0CjZd9rQrkb728EzM8cNUz
         rYPto5EhcFgnhD0QWdbZXebZH5V9mVFHOgduw8OAsm2P58D7NO+hs+38SOmTv6l9qGYE
         j4Kg==
X-Gm-Message-State: AOAM531pVv3EP/5PUx+MtLvrIxz3c3YR3+mYMyvQl9HdbzEdOSHyqjrS
        uA21yA42ZNwA/NB/AVpHbd+CxF4c4HgmbWYUuTBNXdiiEmro
X-Google-Smtp-Source: ABdhPJys5aL238ywENC1LC4Rvyh/Ge8GE4MIgEeDeZNw1Q+F24tt6NkM38nFiCQZwHksQar96U5c2bRqV6zga6dtIvOXJb8iU9gw
MIME-Version: 1.0
X-Received: by 2002:a92:190e:: with SMTP id 14mr21678214ilz.70.1626831443976;
 Tue, 20 Jul 2021 18:37:23 -0700 (PDT)
Date:   Tue, 20 Jul 2021 18:37:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000053e5bb05c7983666@google.com>
Subject: [syzbot] INFO: task hung in pn533_finalize_setup
From:   syzbot <syzbot+1dc8b460d6d48d7ef9ca@syzkaller.appspotmail.com>
To:     dan.carpenter@oracle.com, davem@davemloft.net,
        gustavoars@kernel.org, krzysztof.kozlowski@canonical.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        wengjianfeng@yulong.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    d936eb238744 Revert "Makefile: Enable -Wimplicit-fallthrou..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=148e645c300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=73e52880ded966e4
dashboard link: https://syzkaller.appspot.com/bug?extid=1dc8b460d6d48d7ef9ca
compiler:       Debian clang version 11.0.1-2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1670f9bc300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=168fce54300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+1dc8b460d6d48d7ef9ca@syzkaller.appspotmail.com

INFO: task kworker/1:1:26 blocked for more than 143 seconds.
      Not tainted 5.14.0-rc1-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/1:1     state:D stack:20536 pid:   26 ppid:     2 flags:0x00004000
Workqueue: usb_hub_wq hub_event
Call Trace:
 context_switch kernel/sched/core.c:4683 [inline]
 __schedule+0xc07/0x11f0 kernel/sched/core.c:5940
 schedule+0x14b/0x210 kernel/sched/core.c:6019
 schedule_timeout+0x98/0x2f0 kernel/time/timer.c:1854
 do_wait_for_common+0x2da/0x480 kernel/sched/completion.c:85
 __wait_for_common kernel/sched/completion.c:106 [inline]
 wait_for_common kernel/sched/completion.c:117 [inline]
 wait_for_completion+0x48/0x60 kernel/sched/completion.c:138
 pn533_send_cmd_sync drivers/nfc/pn533/pn533.c:631 [inline]
 pn533_get_firmware_version drivers/nfc/pn533/pn533.c:2521 [inline]
 pn533_finalize_setup+0x2c2/0xe70 drivers/nfc/pn533/pn533.c:2718
 pn533_usb_probe+0xbdc/0xe00 drivers/nfc/pn533/usb.c:544
 usb_probe_interface+0x633/0xb40 drivers/usb/core/driver.c:396
 call_driver_probe+0x96/0x250 drivers/base/dd.c:517
 really_probe+0x223/0x9c0 drivers/base/dd.c:595
 __driver_probe_device+0x1f8/0x3e0 drivers/base/dd.c:747
 driver_probe_device+0x50/0x240 drivers/base/dd.c:777
 __device_attach_driver+0x1e1/0x3b0 drivers/base/dd.c:894
 bus_for_each_drv+0x16a/0x1f0 drivers/base/bus.c:427
 __device_attach+0x301/0x560 drivers/base/dd.c:965
 bus_probe_device+0xb8/0x1f0 drivers/base/bus.c:487
 device_add+0x1295/0x1790 drivers/base/core.c:3352
 usb_set_configuration+0x1a86/0x2100 drivers/usb/core/message.c:2170
 usb_generic_driver_probe+0x83/0x140 drivers/usb/core/generic.c:238
 usb_probe_device+0x13a/0x260 drivers/usb/core/driver.c:293
 call_driver_probe+0x96/0x250 drivers/base/dd.c:517
 really_probe+0x223/0x9c0 drivers/base/dd.c:595
 __driver_probe_device+0x1f8/0x3e0 drivers/base/dd.c:747
 driver_probe_device+0x50/0x240 drivers/base/dd.c:777
 __device_attach_driver+0x1e1/0x3b0 drivers/base/dd.c:894
 bus_for_each_drv+0x16a/0x1f0 drivers/base/bus.c:427
 __device_attach+0x301/0x560 drivers/base/dd.c:965
 bus_probe_device+0xb8/0x1f0 drivers/base/bus.c:487
 device_add+0x1295/0x1790 drivers/base/core.c:3352
 usb_new_device+0x108a/0x1940 drivers/usb/core/hub.c:2559
 hub_port_connect+0x1055/0x27a0 drivers/usb/core/hub.c:5300
 hub_port_connect_change+0x5d0/0xbf0 drivers/usb/core/hub.c:5440
 port_event+0xaee/0x1140 drivers/usb/core/hub.c:5586
 hub_event+0x48d/0xd80 drivers/usb/core/hub.c:5668
 process_one_work+0x833/0x10c0 kernel/workqueue.c:2276
 worker_thread+0xac1/0x1320 kernel/workqueue.c:2422
 kthread+0x453/0x480 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

Showing all locks held in the system:
5 locks held by kworker/1:1/26:
 #0: ffff888019825938 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: process_one_work+0x7aa/0x10c0 kernel/workqueue.c:2249
 #1: ffffc90000e0fd20 ((work_completion)(&hub->events)){+.+.}-{0:0}, at: process_one_work+0x7e8/0x10c0 kernel/workqueue.c:2251
 #2: ffff888146970220 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:754 [inline]
 #2: ffff888146970220 (&dev->mutex){....}-{3:3}, at: hub_event+0x157/0xd80 drivers/usb/core/hub.c:5614
 #3: ffff8880169b0220 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:754 [inline]
 #3: ffff8880169b0220 (&dev->mutex){....}-{3:3}, at: __device_attach+0x8a/0x560 drivers/base/dd.c:940
 #4: ffff8880169b61a8 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:754 [inline]
 #4: ffff8880169b61a8 (&dev->mutex){....}-{3:3}, at: __device_attach+0x8a/0x560 drivers/base/dd.c:940
1 lock held by khungtaskd/1636:
 #0: ffffffff8c7177c0 (rcu_read_lock){....}-{1:2}, at: rcu_lock_acquire+0x0/0x30 arch/x86/pci/mmconfig_64.c:151
1 lock held by in:imklog/8117:
 #0: ffff88801ea065f0 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0x24e/0x2f0 fs/file.c:974
1 lock held by syz-executor147/7354:
 #0: ffff8880b9c514d8 (&rq->__lock){-.-.}-{2:2}, at: raw_spin_rq_lock_nested kernel/sched/core.c:460 [inline]
 #0: ffff8880b9c514d8 (&rq->__lock){-.-.}-{2:2}, at: raw_spin_rq_lock kernel/sched/sched.h:1307 [inline]
 #0: ffff8880b9c514d8 (&rq->__lock){-.-.}-{2:2}, at: rq_lock kernel/sched/sched.h:1610 [inline]
 #0: ffff8880b9c514d8 (&rq->__lock){-.-.}-{2:2}, at: __schedule+0x150/0x11f0 kernel/sched/core.c:5854

=============================================

NMI backtrace for cpu 1
CPU: 1 PID: 1636 Comm: khungtaskd Not tainted 5.14.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x1d3/0x29f lib/dump_stack.c:105
 nmi_cpu_backtrace+0x16c/0x190 lib/nmi_backtrace.c:105
 nmi_trigger_cpumask_backtrace+0x191/0x2f0 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:210 [inline]
 watchdog+0xd06/0xd50 kernel/hung_task.c:295
 kthread+0x453/0x480 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 PID: 10 Comm: kworker/u4:1 Not tainted 5.14.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events_unbound toggle_allocation_gate
RIP: 0010:native_save_fl arch/x86/include/asm/irqflags.h:29 [inline]
RIP: 0010:arch_local_save_flags arch/x86/include/asm/irqflags.h:70 [inline]
RIP: 0010:lockdep_hardirqs_on+0x5c/0x130 kernel/locking/lockdep.c:4330
Code: 5a 29 76 a9 00 00 f0 00 75 45 65 8b 05 dd 63 29 76 85 c0 75 6c 65 8b 05 d2 60 29 76 85 c0 75 61 83 3d 47 d2 97 06 00 75 26 9c <8f> 04 24 f7 04 24 00 02 00 00 75 63 83 3d 31 d2 97 06 00 75 10 48
RSP: 0018:ffffc90000cf77b0 EFLAGS: 00000046
RAX: 0000000000000000 RBX: ffff888012371c40 RCX: ffffffff8162b4d9
RDX: dffffc0000000000 RSI: 0000000000000001 RDI: ffffffff812e156e
RBP: ffffc90000cf7990 R08: dffffc0000000000 R09: fffffbfff1f5ddb3
R10: fffffbfff1f5ddb3 R11: 0000000000000000 R12: ffffffff81c8876e
R13: dffffc0000000000 R14: ffffffff812e156e R15: ffff888012371c40
FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fe00c538000 CR3: 000000000c48e000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 __text_poke+0x6ee/0x8c0 arch/x86/kernel/alternative.c:875
 text_poke arch/x86/kernel/alternative.c:900 [inline]
 text_poke_bp_batch+0x4b0/0x940 arch/x86/kernel/alternative.c:1127
 text_poke_flush arch/x86/kernel/alternative.c:1268 [inline]
 text_poke_finish+0x16/0x30 arch/x86/kernel/alternative.c:1275
 arch_jump_label_transform_apply+0x13/0x20 arch/x86/kernel/jump_label.c:145
 static_key_enable_cpuslocked+0x12d/0x250 kernel/jump_label.c:177
 static_key_enable+0x16/0x20 kernel/jump_label.c:190
 toggle_allocation_gate+0xbf/0x440 mm/kfence/core.c:623
 process_one_work+0x833/0x10c0 kernel/workqueue.c:2276
 worker_thread+0xac1/0x1320 kernel/workqueue.c:2422
 kthread+0x453/0x480 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
