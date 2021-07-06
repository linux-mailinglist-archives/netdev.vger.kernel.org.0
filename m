Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BEC63BC455
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 02:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbhGFAXF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 20:23:05 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:43874 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbhGFAXE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Jul 2021 20:23:04 -0400
Received: by mail-io1-f71.google.com with SMTP id p7-20020a5d8d070000b02904c0978ed194so14387693ioj.10
        for <netdev@vger.kernel.org>; Mon, 05 Jul 2021 17:20:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=4Hbe7LNT/rjYiOgIuPlYq8LKShjAgKrSTxatXLy8aME=;
        b=YSF7kOrVVK8TyVMGVcJ91ZG1wng30SL37rVKt+d7vHntHfVqXH6bKGiIOnj9Wiua6C
         wgvFg9qMgL7nlDZbEZLFZRyWwgxUnW6eBmcKlFn/laCqO+iZccem5qiv5a3bThRNNRwr
         T5ftiDWkaf1d+79ygB63xh/qSCz7oblFqY6DaIfY4cD7wh1r4SkAJXqX/S/KnwF7m1Ct
         /BoOMVO+wuF2IQyH8glnWP0R0INxShdop026SpXs7OHBuMrd2ue2Cp0b5ZBbNzaeXsMk
         U3ONT9UxsT7O2qwvdY5jrEXP2p2QQ9Dolf+biauhIE9n4hmc88loCpRK0j+tkFxDhaNO
         xyDg==
X-Gm-Message-State: AOAM530ehFkHex/30DciBr2iJ/zQhKI2CpHeVfahTGQjGO4Hxf+Hy1ua
        hEsEbsS/nJ8BtBte2HApKA+xkPy3A8BeNKTcSPXsgQAPUnDe
X-Google-Smtp-Source: ABdhPJxEBtiKbN2VDK0tKqTXG8Eh4ek8L3ubU9aQTySyNapjXdKw92wfoKh69Kg8Es1CLC9h4ZE2n7PfXhhajQTsZQS24lHDZAOp
MIME-Version: 1.0
X-Received: by 2002:a92:bd06:: with SMTP id c6mr12382276ile.110.1625530826399;
 Mon, 05 Jul 2021 17:20:26 -0700 (PDT)
Date:   Mon, 05 Jul 2021 17:20:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007aa85205c669635d@google.com>
Subject: [syzbot] net boot error: possible deadlock in fs_reclaim_acquire
From:   syzbot <syzbot+0123a2b8f9e623d5b443@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    5140aaa4 s390: iucv: Avoid field over-reading memcpy()
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=15798c28300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=26b64b13fcecb7e1
dashboard link: https://syzkaller.appspot.com/bug?extid=0123a2b8f9e623d5b443

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+0123a2b8f9e623d5b443@syzkaller.appspotmail.com

usbcore: registered new interface driver spca505
usbcore: registered new interface driver spca506
usbcore: registered new interface driver spca508
usbcore: registered new interface driver spca561
usbcore: registered new interface driver spca1528
usbcore: registered new interface driver sq905
usbcore: registered new interface driver sq905c
usbcore: registered new interface driver sq930x
usbcore: registered new interface driver sunplus
usbcore: registered new interface driver stk014
usbcore: registered new interface driver stk1135
usbcore: registered new interface driver stv0680
usbcore: registered new interface driver t613
usbcore: registered new interface driver gspca_topro
usbcore: registered new interface driver touptek
usbcore: registered new interface driver tv8532
usbcore: registered new interface driver vc032x
usbcore: registered new interface driver vicam
usbcore: registered new interface driver xirlink-cit
usbcore: registered new interface driver gspca_zc3xx
usbcore: registered new interface driver ALi m5602
usbcore: registered new interface driver STV06xx
usbcore: registered new interface driver gspca_gl860
usbcore: registered new interface driver Philips webcam
usbcore: registered new interface driver airspy
usbcore: registered new interface driver hackrf
usbcore: registered new interface driver msi2500
cpia2: V4L-Driver for Vision CPiA2 based cameras v3.0.1
usbcore: registered new interface driver cpia2
au0828: au0828 driver loaded
usbcore: registered new interface driver au0828
usbcore: registered new interface driver hdpvr
usbcore: registered new interface driver pvrusb2
pvrusb2: V4L in-tree version:Hauppauge WinTV-PVR-USB2 MPEG2 Encoder/Tuner
pvrusb2: Debug mask is 31 (0x1f)
usbcore: registered new interface driver stk1160
usbcore: registered new interface driver cx231xx
usbcore: registered new interface driver tm6000
usbcore: registered new interface driver em28xx
em28xx: Registered (Em28xx v4l2 Extension) extension
em28xx: Registered (Em28xx Audio Extension) extension
em28xx: Registered (Em28xx dvb Extension) extension
em28xx: Registered (Em28xx Input Extension) extension
usbcore: registered new interface driver usbtv
usbcore: registered new interface driver go7007
usbcore: registered new interface driver go7007-loader
usbcore: registered new interface driver Abilis Systems as10x usb driver
vivid-000: using single planar format API

======================================================
WARNING: possible circular locking dependency detected
5.13.0-syzkaller #0 Not tainted
------------------------------------------------------
swapper/0/1 is trying to acquire lock:
ffffffff8c29c220 (fs_reclaim){+.+.}-{0:0}, at: fs_reclaim_acquire+0xf7/0x160 mm/page_alloc.c:4586

but task is already holding lock:
ffff8880b9c31620 (lock#2){-.-.}-{2:2}, at: __alloc_pages_bulk+0x4ad/0x1870 mm/page_alloc.c:5291

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (lock#2){-.-.}-{2:2}:
       local_lock_acquire include/linux/local_lock_internal.h:42 [inline]
       rmqueue_pcplist mm/page_alloc.c:3675 [inline]
       rmqueue mm/page_alloc.c:3713 [inline]
       get_page_from_freelist+0x4aa/0x2f80 mm/page_alloc.c:4175
       __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5386
       alloc_pages+0x18c/0x2a0 mm/mempolicy.c:2272
       stack_depot_save+0x39d/0x4e0 lib/stackdepot.c:303
       kasan_save_stack+0x32/0x40 mm/kasan/common.c:40
       kasan_record_aux_stack+0xe5/0x110 mm/kasan/generic.c:348
       __call_rcu kernel/rcu/tree.c:3038 [inline]
       call_rcu+0xb1/0x750 kernel/rcu/tree.c:3113
       put_task_struct_rcu_user+0x7f/0xb0 kernel/exit.c:179
       context_switch kernel/sched/core.c:4686 [inline]
       __schedule+0x93c/0x2710 kernel/sched/core.c:5940
       preempt_schedule_irq+0x4e/0x90 kernel/sched/core.c:6328
       irqentry_exit+0x31/0x80 kernel/entry/common.c:427
       asm_sysvec_reschedule_ipi+0x12/0x20 arch/x86/include/asm/idtentry.h:643
       lock_acquire+0x1ef/0x510 kernel/locking/lockdep.c:5593
       __fs_reclaim_acquire mm/page_alloc.c:4564 [inline]
       fs_reclaim_acquire+0x117/0x160 mm/page_alloc.c:4578
       prepare_alloc_pages+0x15c/0x580 mm/page_alloc.c:5176
       __alloc_pages+0x12f/0x500 mm/page_alloc.c:5375
       alloc_pages+0x18c/0x2a0 mm/mempolicy.c:2272
       pmd_alloc_one include/asm-generic/pgalloc.h:126 [inline]
       __pmd_alloc+0x3b/0x5c0 mm/memory.c:4728
       pmd_alloc include/linux/mm.h:2164 [inline]
       __handle_mm_fault+0xce2/0x5320 mm/memory.c:4517
       handle_mm_fault+0x1c8/0x7f0 mm/memory.c:4653
       faultin_page mm/gup.c:947 [inline]
       __get_user_pages+0x7cf/0x1490 mm/gup.c:1166
       __get_user_pages_locked mm/gup.c:1352 [inline]
       __get_user_pages_remote+0x18f/0x840 mm/gup.c:1800
       get_user_pages_remote+0x63/0x90 mm/gup.c:1873
       get_arg_page+0xba/0x200 fs/exec.c:223
       copy_string_kernel+0x1b4/0x520 fs/exec.c:634
       kernel_execve+0x25c/0x460 fs/exec.c:1964
       call_usermodehelper_exec_async+0x2e3/0x580 kernel/umh.c:112
       ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

-> #0 (fs_reclaim){+.+.}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:3051 [inline]
       check_prevs_add kernel/locking/lockdep.c:3174 [inline]
       validate_chain kernel/locking/lockdep.c:3789 [inline]
       __lock_acquire+0x2a07/0x54a0 kernel/locking/lockdep.c:5015
       lock_acquire kernel/locking/lockdep.c:5625 [inline]
       lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5590
       __fs_reclaim_acquire mm/page_alloc.c:4564 [inline]
       fs_reclaim_acquire+0x117/0x160 mm/page_alloc.c:4578
       prepare_alloc_pages+0x15c/0x580 mm/page_alloc.c:5176
       __alloc_pages+0x12f/0x500 mm/page_alloc.c:5375
       alloc_page_interleave+0x1e/0x200 mm/mempolicy.c:2147
       alloc_pages+0x238/0x2a0 mm/mempolicy.c:2270
       stack_depot_save+0x39d/0x4e0 lib/stackdepot.c:303
       save_stack+0x15e/0x1e0 mm/page_owner.c:120
       __set_page_owner+0x50/0x290 mm/page_owner.c:181
       prep_new_page mm/page_alloc.c:2445 [inline]
       __alloc_pages_bulk+0x8b9/0x1870 mm/page_alloc.c:5313
       alloc_pages_bulk_array_node include/linux/gfp.h:557 [inline]
       vm_area_alloc_pages mm/vmalloc.c:2775 [inline]
       __vmalloc_area_node mm/vmalloc.c:2845 [inline]
       __vmalloc_node_range+0x39d/0x960 mm/vmalloc.c:2947
       __vmalloc_node mm/vmalloc.c:2996 [inline]
       vzalloc+0x67/0x80 mm/vmalloc.c:3066
       vivid_create_instance drivers/media/test-drivers/vivid/vivid-core.c:1775 [inline]
       vivid_probe.cold+0x2458/0x86a5 drivers/media/test-drivers/vivid/vivid-core.c:2001
       platform_probe+0xfc/0x1f0 drivers/base/platform.c:1447
       really_probe+0x291/0xf60 drivers/base/dd.c:576
       driver_probe_device+0x298/0x410 drivers/base/dd.c:763
       device_driver_attach+0x228/0x290 drivers/base/dd.c:1039
       __driver_attach+0x190/0x340 drivers/base/dd.c:1117
       bus_for_each_dev+0x147/0x1d0 drivers/base/bus.c:305
       bus_add_driver+0x3a9/0x630 drivers/base/bus.c:622
       driver_register+0x220/0x3a0 drivers/base/driver.c:171
       vivid_init+0x37/0x64 drivers/media/test-drivers/vivid/vivid-core.c:2131
       do_one_initcall+0x103/0x650 init/main.c:1246
       do_initcall_level init/main.c:1319 [inline]
       do_initcalls init/main.c:1335 [inline]
       do_basic_setup init/main.c:1355 [inline]
       kernel_init_freeable+0x6b8/0x741 init/main.c:1557
       kernel_init+0x1a/0x1d0 init/main.c:1449
       ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(lock#2);
                               lock(fs_reclaim);
                               lock(lock#2);
  lock(fs_reclaim);

 *** DEADLOCK ***

2 locks held by swapper/0/1:
 #0: ffffffff8d484648 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:742 [inline]
 #0: ffffffff8d484648 (&dev->mutex){....}-{3:3}, at: __device_driver_lock drivers/base/dd.c:1001 [inline]
 #0: ffffffff8d484648 (&dev->mutex){....}-{3:3}, at: device_driver_attach+0xba/0x290 drivers/base/dd.c:1032
 #1: ffff8880b9c31620 (lock#2){-.-.}-{2:2}, at: __alloc_pages_bulk+0x4ad/0x1870 mm/page_alloc.c:5291

stack backtrace:
CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.13.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:96
 check_noncircular+0x25f/0x2e0 kernel/locking/lockdep.c:2131
 check_prev_add kernel/locking/lockdep.c:3051 [inline]
 check_prevs_add kernel/locking/lockdep.c:3174 [inline]
 validate_chain kernel/locking/lockdep.c:3789 [inline]
 __lock_acquire+0x2a07/0x54a0 kernel/locking/lockdep.c:5015
 lock_acquire kernel/locking/lockdep.c:5625 [inline]
 lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5590
 __fs_reclaim_acquire mm/page_alloc.c:4564 [inline]
 fs_reclaim_acquire+0x117/0x160 mm/page_alloc.c:4578
 prepare_alloc_pages+0x15c/0x580 mm/page_alloc.c:5176
 __alloc_pages+0x12f/0x500 mm/page_alloc.c:5375
 alloc_page_interleave+0x1e/0x200 mm/mempolicy.c:2147
 alloc_pages+0x238/0x2a0 mm/mempolicy.c:2270
 stack_depot_save+0x39d/0x4e0 lib/stackdepot.c:303
 save_stack+0x15e/0x1e0 mm/page_owner.c:120
 __set_page_owner+0x50/0x290 mm/page_owner.c:181
 prep_new_page mm/page_alloc.c:2445 [inline]
 __alloc_pages_bulk+0x8b9/0x1870 mm/page_alloc.c:5313
 alloc_pages_bulk_array_node include/linux/gfp.h:557 [inline]
 vm_area_alloc_pages mm/vmalloc.c:2775 [inline]
 __vmalloc_area_node mm/vmalloc.c:2845 [inline]
 __vmalloc_node_range+0x39d/0x960 mm/vmalloc.c:2947
 __vmalloc_node mm/vmalloc.c:2996 [inline]
 vzalloc+0x67/0x80 mm/vmalloc.c:3066
 vivid_create_instance drivers/media/test-drivers/vivid/vivid-core.c:1775 [inline]
 vivid_probe.cold+0x2458/0x86a5 drivers/media/test-drivers/vivid/vivid-core.c:2001
 platform_probe+0xfc/0x1f0 drivers/base/platform.c:1447
 really_probe+0x291/0xf60 drivers/base/dd.c:576
 driver_probe_device+0x298/0x410 drivers/base/dd.c:763
 device_driver_attach+0x228/0x290 drivers/base/dd.c:1039
 __driver_attach+0x190/0x340 drivers/base/dd.c:1117
 bus_for_each_dev+0x147/0x1d0 drivers/base/bus.c:305
 bus_add_driver+0x3a9/0x630 drivers/base/bus.c:622
 driver_register+0x220/0x3a0 drivers/base/driver.c:171
 vivid_init+0x37/0x64 drivers/media/test-drivers/vivid/vivid-core.c:2131
 do_one_initcall+0x103/0x650 init/main.c:1246
 do_initcall_level init/main.c:1319 [inline]
 do_initcalls init/main.c:1335 [inline]
 do_basic_setup init/main.c:1355 [inline]
 kernel_init_freeable+0x6b8/0x741 init/main.c:1557
 kernel_init+0x1a/0x1d0 init/main.c:1449
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
BUG: sleeping function called from invalid context at mm/page_alloc.c:5179
in_atomic(): 0, irqs_disabled(): 1, non_block: 0, pid: 1, name: swapper/0
INFO: lockdep is turned off.
irq event stamp: 872958
hardirqs last  enabled at (872957): [<ffffffff89226240>] __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:160 [inline]
hardirqs last  enabled at (872957): [<ffffffff89226240>] _raw_spin_unlock_irqrestore+0x50/0x70 kernel/locking/spinlock.c:191
hardirqs last disabled at (872958): [<ffffffff81b22ff7>] __alloc_pages_bulk+0x1017/0x1870 mm/page_alloc.c:5291
softirqs last  enabled at (872616): [<ffffffff8146345e>] invoke_softirq kernel/softirq.c:432 [inline]
softirqs last  enabled at (872616): [<ffffffff8146345e>] __irq_exit_rcu+0x16e/0x1c0 kernel/softirq.c:636
softirqs last disabled at (872443): [<ffffffff8146345e>] invoke_softirq kernel/softirq.c:432 [inline]
softirqs last disabled at (872443): [<ffffffff8146345e>] __irq_exit_rcu+0x16e/0x1c0 kernel/softirq.c:636
CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.13.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:96
 ___might_sleep.cold+0x1f1/0x237 kernel/sched/core.c:9153
 prepare_alloc_pages+0x3da/0x580 mm/page_alloc.c:5179
 __alloc_pages+0x12f/0x500 mm/page_alloc.c:5375
 alloc_page_interleave+0x1e/0x200 mm/mempolicy.c:2147
 alloc_pages+0x238/0x2a0 mm/mempolicy.c:2270
 stack_depot_save+0x39d/0x4e0 lib/stackdepot.c:303
 save_stack+0x15e/0x1e0 mm/page_owner.c:120
 __set_page_owner+0x50/0x290 mm/page_owner.c:181
 prep_new_page mm/page_alloc.c:2445 [inline]
 __alloc_pages_bulk+0x8b9/0x1870 mm/page_alloc.c:5313
 alloc_pages_bulk_array_node include/linux/gfp.h:557 [inline]
 vm_area_alloc_pages mm/vmalloc.c:2775 [inline]
 __vmalloc_area_node mm/vmalloc.c:2845 [inline]
 __vmalloc_node_range+0x39d/0x960 mm/vmalloc.c:2947
 __vmalloc_node mm/vmalloc.c:2996 [inline]
 vzalloc+0x67/0x80 mm/vmalloc.c:3066
 vivid_create_instance drivers/media/test-drivers/vivid/vivid-core.c:1775 [inline]
 vivid_probe.cold+0x2458/0x86a5 drivers/media/test-drivers/vivid/vivid-core.c:2001
 platform_probe+0xfc/0x1f0 drivers/base/platform.c:1447
 really_probe+0x291/0xf60 drivers/base/dd.c:576
 driver_probe_device+0x298/0x410 drivers/base/dd.c:763
 device_driver_attach+0x228/0x290 drivers/base/dd.c:1039
 __driver_attach+0x190/0x340 drivers/base/dd.c:1117
 bus_for_each_dev+0x147/0x1d0 drivers/base/bus.c:305
 bus_add_driver+0x3a9/0x630 drivers/base/bus.c:622
 driver_register+0x220/0x3a0 drivers/base/driver.c:171
 vivid_init+0x37/0x64 drivers/media/test-drivers/vivid/vivid-core.c:2131
 do_one_initcall+0x103/0x650 init/main.c:1246
 do_initcall_level init/main.c:1319 [inline]
 do_initcalls init/main.c:1335 [inline]
 do_basic_setup init/main.c:1355 [inline]
 kernel_init_freeable+0x6b8/0x741 init/main.c:1557
 kernel_init+0x1a/0x1d0 init/main.c:1449
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
vivid-000: CEC adapter cec0 registered for HDMI input 0
vivid-000: V4L2 capture device registered as video3
vivid-000: CEC adapter cec1 registered for HDMI output 0
vivid-000: V4L2 output device registered as video4
vivid-000: V4L2 capture device registered as vbi0, supports raw and sliced VBI
vivid-000: V4L2 output device registered as vbi1, supports raw and sliced VBI
vivid-000: V4L2 capture device registered as swradio0
vivid-000: V4L2 receiver device registered as radio0
vivid-000: V4L2 transmitter device registered as radio1
vivid-000: V4L2 metadata capture device registered as video5
vivid-000: V4L2 metadata output device registered as video6
vivid-000: V4L2 touch capture device registered as v4l-touch0
vivid-001: using multiplanar format API
vivid-001: CEC adapter cec2 registered for HDMI input 0
vivid-001: V4L2 capture device registered as video7
vivid-001: CEC adapter cec3 registered for HDMI output 0
vivid-001: V4L2 output device registered as video8
vivid-001: V4L2 capture device registered as vbi2, supports raw and sliced VBI
vivid-001: V4L2 output device registered as vbi3, supports raw and sliced VBI
vivid-001: V4L2 capture device registered as swradio1
vivid-001: V4L2 receiver device registered as radio2
vivid-001: V4L2 transmitter device registered as radio3
vivid-001: V4L2 metadata capture device registered as video9
vivid-001: V4L2 metadata output device registered as video10
vivid-001: V4L2 touch capture device registered as v4l-touch1
vivid-002: using single planar format API
vivid-002: CEC adapter cec4 registered for HDMI input 0
vivid-002: V4L2 capture device registered as video11
vivid-002: CEC adapter cec5 registered for HDMI output 0
vivid-002: V4L2 output device registered as video12
vivid-002: V4L2 capture device registered as vbi4, supports raw and sliced VBI
vivid-002: V4L2 output device registered as vbi5, supports raw and sliced VBI
vivid-002: V4L2 capture device registered as swradio2
vivid-002: V4L2 receiver device registered as radio4
vivid-002: V4L2 transmitter device registered as radio5
vivid-002: V4L2 metadata capture device registered as video13
vivid-002: V4L2 metadata output device registered as video14
vivid-002: V4L2 touch capture device registered as v4l-touch2
vivid-003: using multiplanar format API
vivid-003: CEC adapter cec6 registered for HDMI input 0
vivid-003: V4L2 capture device registered as video15
vivid-003: CEC adapter cec7 registered for HDMI output 0
vivid-003: V4L2 output device registered as video16
vivid-003: V4L2 capture device registered as vbi6, supports raw and sliced VBI
vivid-003: V4L2 output device registered as vbi7, supports raw and sliced VBI
vivid-003: V4L2 capture device registered as swradio3
vivid-003: V4L2 receiver device registered as radio6
vivid-003: V4L2 transmitter device registered as radio7
vivid-003: V4L2 metadata capture device registered as video17
vivid-003: V4L2 metadata output device registered as video18
vivid-003: V4L2 touch capture device registered as v4l-touch3
vivid-004: using single planar format API
vivid-004: CEC adapter cec8 registered for HDMI input 0
vivid-004: V4L2 capture device registered as video19
vivid-004: CEC adapter cec9 registered for HDMI output 0
vivid-004: V4L2 output device registered as video20
vivid-004: V4L2 capture device registered as vbi8, supports raw and sliced VBI
vivid-004: V4L2 output device registered as vbi9, supports raw and sliced VBI
vivid-004: V4L2 capture device registered as swradio4
vivid-004: V4L2 receiver device registered as radio8
vivid-004: V4L2 transmitter device registered as radio9
vivid-004: V4L2 metadata capture device registered as video21
vivid-004: V4L2 metadata output device registered as video22
vivid-004: V4L2 touch capture device registered as v4l-touch4
vivid-005: using multiplanar format API
vivid-005: CEC adapter cec10 registered for HDMI input 0
vivid-005: V4L2 capture device registered as video23
vivid-005: CEC adapter cec11 registered for HDMI output 0
vivid-005: V4L2 output device registered as video24
vivid-005: V4L2 capture device registered as vbi10, supports raw and sliced VBI
vivid-005: V4L2 output device registered as vbi11, supports raw and sliced VBI
vivid-005: V4L2 capture device registered as swradio5
vivid-005: V4L2 receiver device registered as radio10
vivid-005: V4L2 transmitter device registered as radio11
vivid-005: V4L2 metadata capture device registered as video25
vivid-005: V4L2 metadata output device registered as video26
vivid-005: V4L2 touch capture device registered as v4l-touch5
vivid-006: using single planar format API
vivid-006: CEC adapter cec12 registered for HDMI input 0
vivid-006: V4L2 capture device registered as video27
vivid-006: CEC adapter cec13 registered for HDMI output 0
vivid-006: V4L2 output device registered as video28
vivid-006: V4L2 capture device registered as vbi12, supports raw and sliced VBI
vivid-006: V4L2 output device registered as vbi13, supports raw and sliced VBI
vivid-006: V4L2 capture device registered as swradio6
vivid-006: V4L2 receiver device registered as radio12
vivid-006: V4L2 transmitter device registered as radio13
vivid-006: V4L2 metadata capture device registered as video29
vivid-006: V4L2 metadata output device registered as video30
vivid-006: V4L2 touch capture device registered as v4l-touch6
vivid-007: using multiplanar format API
vivid-007: CEC adapter cec14 registered for HDMI input 0
vivid-007: V4L2 capture device registered as video31
vivid-007: CEC adapter cec15 registered for HDMI output 0
vivid-007: V4L2 output device registered as video32
vivid-007: V4L2 capture device registered as vbi14, supports raw and sliced VBI
vivid-007: V4L2 output device registered as vbi15, supports raw and sliced VBI
vivid-007: V4L2 capture device registered as swradio7
vivid-007: V4L2 receiver device registered as radio14
vivid-007: V4L2 transmitter device registered as radio15
vivid-007: V4L2 metadata capture device registered as video33
vivid-007: V4L2 metadata output device registered as video34
vivid-007: V4L2 touch capture device registered as v4l-touch7
vivid-008: using single planar format API
vivid-008: CEC adapter cec16 registered for HDMI input 0
vivid-008: V4L2 capture device registered as video35
vivid-008: CEC adapter cec17 registered for HDMI output 0
vivid-008: V4L2 output device registered as video36
vivid-008: V4L2 capture device registered as vbi16, supports raw and sliced VBI
vivid-008: V4L2 output device registered as vbi17, supports raw and sliced VBI
vivid-008: V4L2 capture device registered as swradio8
vivid-008: V4L2 receiver device registered as radio16
vivid-008: V4L2 transmitter device registered as radio17
vivid-008: V4L2 metadata capture device registered as video37
vivid-008: V4L2 metadata output device registered as video38
vivid-008: V4L2 touch capture device registered as v4l-touch8
vivid-009: using multiplanar format API
vivid-009: CEC adapter cec18 registered for HDMI input 0
vivid-009: V4L2 capture device registered as video39
vivid-009: CEC adapter cec19 registered for HDMI output 0
vivid-009: V4L2 output device registered as video40
vivid-009: V4L2 capture device registered as vbi18, supports raw and sliced VBI
vivid-009: V4L2 output device registered as vbi19, supports raw and sliced VBI
vivid-009: V4L2 capture device registered as swradio9
vivid-009: V4L2 receiver device registered as radio18
vivid-009: V4L2 transmitter device registered as radio19
vivid-009: V4L2 metadata capture device registered as video41
vivid-009: V4L2 metadata output device registered as video42
vivid-009: V4L2 touch capture device registered as v4l-touch9
vivid-010: using single planar format API
vivid-010: CEC adapter cec20 registered for HDMI input 0
vivid-010: V4L2 capture device registered as video43
vivid-010: CEC adapter cec21 registered for HDMI output 0
vivid-010: V4L2 output device registered as video44
vivid-010: V4L2 capture device registered as vbi20, supports raw and sliced VBI
vivid-010: V4L2 output device registered as vbi21, supports raw and sliced VBI
vivid-010: V4L2 capture device registered as swradio10
vivid-010: V4L2 receiver device registered as radio20
vivid-010: V4L2 transmitter device registered as radio21
vivid-010: V4L2 metadata capture device registered as video45
vivid-010: V4L2 metadata output device registered as video46
vivid-010: V4L2 touch capture device registered as v4l-touch10
vivid-011: using multiplanar format API
vivid-011: CEC adapter cec22 registered for HDMI input 0
vivid-011: V4L2 capture device registered as video47
vivid-011: CEC adapter cec23 registered for HDMI output 0
vivid-011: V4L2 output device registered as video48
vivid-011: V4L2 capture device registered as vbi22, supports raw and sliced VBI
vivid-011: V4L2 output device registered as vbi23, supports raw and sliced VBI
vivid-011: V4L2 capture device registered as swradio11
vivid-011: V4L2 receiver device registered as radio22
vivid-011: V4L2 transmitter device registered as radio23
vivid-011: V4L2 metadata capture device registered as video49
vivid-011: V4L2 metadata output device registered as video50
vivid-011: V4L2 touch capture device registered as v4l-touch11
vivid-012: using single planar format API
vivid-012: CEC adapter cec24 registered for HDMI input 0
vivid-012: V4L2 capture device registered as video51
vivid-012: CEC adapter cec25 registered for HDMI output 0
vivid-012: V4L2 output device registered as video52
vivid-012: V4L2 capture device registered as vbi24, supports raw and sliced VBI
vivid-012: V4L2 output device registered as vbi25, supports raw and sliced VBI
vivid-012: V4L2 capture device registered as swradio12
vivid-012: V4L2 receiver device registered as radio24
vivid-012: V4L2 transmitter device registered as radio25
vivid-012: V4L2 metadata capture device registered as video53
vivid-012: V4L2 metadata output device registered as video54
vivid-012: V4L2 touch capture device registered as v4l-touch12
vivid-013: using multiplanar format API
vivid-013: CEC adapter cec26 registered for HDMI input 0
vivid-013: V4L2 capture device registered as video55
vivid-013: CEC adapter cec27 registered for HDMI output 0
vivid-013: V4L2 output device registered as video56
vivid-013: V4L2 capture device registered as vbi26, supports raw and sliced VBI
vivid-013: V4L2 output device registered as vbi27, supports raw and sliced VBI
vivid-013: V4L2 capture device registered as swradio13
vivid-013: V4L2 receiver device registered as radio26
vivid-013: V4L2 transmitter device registered as radio27
vivid-013: V4L2 metadata capture device registered as video57
vivid-013: V4L2 metadata output device registered as video58
vivid-013: V4L2 touch capture device registered as v4l-touch13
vivid-014: using single planar format API
vivid-014: CEC adapter cec28 registered for HDMI input 0
vivid-014: V4L2 capture device registered as video59
vivid-014: CEC adapter cec29 registered for HDMI output 0
vivid-014: V4L2 output device registered as video60
vivid-014: V4L2 capture device registered as vbi28, supports raw and sliced VBI
vivid-014: V4L2 output device registered as vbi29, supports raw and sliced VBI
vivid-014: V4L2 capture device registered as swradio14
vivid-014: V4L2 receiver device registered as radio28
vivid-014: V4L2 transmitter device registered as radio29
vivid-014: V4L2 metadata capture device registered as video61
vivid-014: V4L2 metadata output device registered as video62
vivid-014: V4L2 touch capture device registered as v4l-touch14
vivid-015: using multiplanar format API
vivid-015: CEC adapter cec30 registered for HDMI input 0
vivid-015: V4L2 capture device registered as video63
vivid-015: CEC adapter cec31 registered for HDMI output 0
vivid-015: V4L2 output device registered as video64
vivid-015: V4L2 capture device registered as vbi30, supports raw and sliced VBI
vivid-015: V4L2 output device registered as vbi31, supports raw and sliced VBI
vivid-015: V4L2 capture device registered as swradio15
vivid-015: V4L2 receiver device registered as radio30
vivid-015: V4L2 transmitter device registered as radio31
vivid-015: V4L2 metadata capture device registered as video65
vivid-015: V4L2 metadata output device registered as video66
vivid-015: V4L2 touch capture device registered as v4l-touch15
vim2m vim2m.0: Device registered as /dev/video0
vicodec vicodec.0: Device 'stateful-encoder' registered as /dev/video68
vicodec vicodec.0: Device 'stateful-decoder' registered as /dev/video69
vicodec vicodec.0: Device 'stateless-decoder' registered as /dev/video70
dvbdev: DVB: registering new adapter (dvb_vidtv_bridge)
i2c i2c-0: DVB: registering adapter 0 frontend 0 (Dummy demod for DVB-T/T2/C/S/S2)...
dvbdev: dvb_create_media_entity: media entity 'Dummy demod for DVB-T/T2/C/S/S2' registered.
dvbdev: dvb_create_media_entity: media entity 'dvb-demux' registered.
vidtv vidtv.0: Successfully initialized vidtv!
usbcore: registered new interface driver radioshark
usbcore: registered new interface driver radioshark2
usbcore: registered new interface driver dsbr100
usbcore: registered new interface driver radio-si470x
usbcore: registered new interface driver radio-usb-si4713
usbcore: registered new interface driver radio-mr800
usbcore: registered new interface driver radio-keene
usbcore: registered new interface driver radio-ma901
usbcore: registered new interface driver radio-raremono
general protection fault, probably for non-canonical address 0xdffffc0000000097: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x00000000000004b8-0x00000000000004bf]
CPU: 1 PID: 1 Comm: swapper/0 Tainted: G        W         5.13.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:ptp_clock_register+0x5b1/0xce0 drivers/ptp/ptp_clock.c:239
Code: 0f 85 38 06 00 00 4d 89 a7 10 01 00 00 e8 77 9d 51 fb 49 8d bd b8 04 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 35 06 00 00 4d 8b bd b8 04 00 00 4d 85 ff 74 51
RSP: 0000:ffffc90000c67cc8 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 1ffff9200018cf9f RCX: 0000000000000000
RDX: 0000000000000097 RSI: ffffffff8623e709 RDI: 00000000000004b8
RBP: ffffffff90d082a8 R08: ffff888147474648 R09: 0000000000000000
R10: ffffed1028e8eb29 R11: 0000000000000000 R12: ffff888147474000
R13: 0000000000000000 R14: 0000000000000000 R15: ffffffff90d082a8
FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000000be8e000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 ptp_kvm_init+0xe5/0x11b drivers/ptp/ptp_kvm_common.c:148
 do_one_initcall+0x103/0x650 init/main.c:1246
 do_initcall_level init/main.c:1319 [inline]
 do_initcalls init/main.c:1335 [inline]
 do_basic_setup init/main.c:1355 [inline]
 kernel_init_freeable+0x6b8/0x741 init/main.c:1557
 kernel_init+0x1a/0x1d0 init/main.c:1449
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
Modules linked in:
---[ end trace 606c4fdf75a44c40 ]---
RIP: 0010:ptp_clock_register+0x5b1/0xce0 drivers/ptp/ptp_clock.c:239
Code: 0f 85 38 06 00 00 4d 89 a7 10 01 00 00 e8 77 9d 51 fb 49 8d bd b8 04 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 35 06 00 00 4d 8b bd b8 04 00 00 4d 85 ff 74 51
RSP: 0000:ffffc90000c67cc8 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 1ffff9200018cf9f RCX: 0000000000000000
RDX: 0000000000000097 RSI: ffffffff8623e709 RDI: 00000000000004b8
RBP: ffffffff90d082a8 R08: ffff888147474648 R09: 0000000000000000
R10: ffffed1028e8eb29 R11: 0000000000000000 R12: ffff888147474000
R13: 0000000000000000 R14: 0000000000000000 R15: ffffffff90d082a8
FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000000be8e000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
