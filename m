Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E06B9656307
	for <lists+netdev@lfdr.de>; Mon, 26 Dec 2022 15:20:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbiLZOUC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Dec 2022 09:20:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbiLZOUB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Dec 2022 09:20:01 -0500
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB7BC25CA
        for <netdev@vger.kernel.org>; Mon, 26 Dec 2022 06:19:58 -0800 (PST)
Received: by mail-io1-f72.google.com with SMTP id o22-20020a6b5a16000000b006e2d564944aso3663417iob.7
        for <netdev@vger.kernel.org>; Mon, 26 Dec 2022 06:19:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=z7KL1dQ34u8AT7PdPKa7IoRprjzFoYA+nPamgtNueJ8=;
        b=YNHS4JCvtPP+k420v9N0X2NvXDks/OkWXYZgVvScRnbUKL7ER89LV5C8sRFZvJYQBs
         790R+Z4Tql8RVvvusn3cZtv5pv7l8le02j+Uw++3YOBKl2IRxlWvwryjNcvM3JHfqlaT
         yJLa2mcxwODnsod6jp6g1yY0GuodnfG1mbc3sDa16yzVPgTE1HosteiIM97ZVcN5Xq0J
         PGjfqEA7dSdNMxUkT/Q7mv8BYD4I0jwVsqn5s/E7Bk6+yVDzGPqY4VPNEoOpQGnA3Atr
         qDHaSc5711KKztQIIGbQo+mFlbsOI6jbM/fLdkbtdRJG/tOt2LpRYG1ZyNRLyKQx/aOF
         tHzA==
X-Gm-Message-State: AFqh2krhX123QCzum8h/ZJPt4E6Z5YW3LgA4sEOBt/1w82/tXh9k924p
        Yb33sXFbeuZY3glXbjabJC+RMtUsOyR4dovudxWHR56c93Gk
X-Google-Smtp-Source: AMrXdXtP9X7bCU2iWHFEdlkHhj1vux2ROfhrx5lOxsDhPoni1f3tQe+CLJy47UOBzX5EMoEQijyv7Ze1aAEWELA4N6gpSQLZ9oG2
MIME-Version: 1.0
X-Received: by 2002:a05:6638:3895:b0:395:49aa:74c5 with SMTP id
 b21-20020a056638389500b0039549aa74c5mr1464195jav.226.1672064398221; Mon, 26
 Dec 2022 06:19:58 -0800 (PST)
Date:   Mon, 26 Dec 2022 06:19:58 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007f680e05f0bbd4da@google.com>
Subject: [syzbot] possible deadlock in p9_pollwake
From:   syzbot <syzbot+ecf48cc152f84f8c9f67@syzkaller.appspotmail.com>
To:     asmadeus@codewreck.org, davem@davemloft.net, edumazet@google.com,
        ericvh@gmail.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux_oss@crudebyte.com, lucho@ionkov.net, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com,
        v9fs-developer@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    9d2f6060fe4c Merge tag 'trace-v6.2-1' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=162f26cf880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b0e81c4eb13a67cd
dashboard link: https://syzkaller.appspot.com/bug?extid=ecf48cc152f84f8c9f67
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ecf48cc152f84f8c9f67@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
6.1.0-syzkaller-14364-g9d2f6060fe4c #0 Not tainted
------------------------------------------------------
swapper/2/0 is trying to acquire lock:
ffffffff8c8ced48 (zonelist_update_seq.seqcount){...-}-{0:0}, at: __alloc_pages+0x4aa/0x5b0 mm/page_alloc.c:5562

but task is already holding lock:
ffff88802c83ae18 (&pool->lock){-.-.}-{2:2}, at: __queue_work+0x367/0x13b0 kernel/workqueue.c:1474

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #4 (&pool->lock){-.-.}-{2:2}:
       __raw_spin_lock include/linux/spinlock_api_smp.h:133 [inline]
       _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:154
       __queue_work+0x367/0x13b0 kernel/workqueue.c:1474
       queue_work_on+0xf2/0x110 kernel/workqueue.c:1545
       queue_work include/linux/workqueue.h:503 [inline]
       schedule_work include/linux/workqueue.h:564 [inline]
       p9_pollwake+0xc1/0x1d0 net/9p/trans_fd.c:540
       __wake_up_common+0x147/0x650 kernel/sched/wait.c:107
       __wake_up_common_lock+0xd4/0x140 kernel/sched/wait.c:138
       tty_write_unlock drivers/tty/tty_io.c:939 [inline]
       do_tty_write drivers/tty/tty_io.c:1043 [inline]
       file_tty_write.constprop.0+0x504/0x890 drivers/tty/tty_io.c:1089
       __kernel_write_iter+0x262/0x730 fs/read_write.c:517
       __kernel_write fs/read_write.c:537 [inline]
       kernel_write fs/read_write.c:558 [inline]
       kernel_write+0x1c1/0x630 fs/read_write.c:548
       p9_fd_write net/9p/trans_fd.c:434 [inline]
       p9_write_work+0x25a/0xc60 net/9p/trans_fd.c:485
       process_one_work+0x9bf/0x1710 kernel/workqueue.c:2289
       worker_thread+0x669/0x1090 kernel/workqueue.c:2436
       kthread+0x2e8/0x3a0 kernel/kthread.c:376
       ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308

-> #3 (&tty->write_wait){-...}-{2:2}:
       __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
       _raw_spin_lock_irqsave+0x3d/0x60 kernel/locking/spinlock.c:162
       __wake_up_common_lock+0xb8/0x140 kernel/sched/wait.c:137
       tty_port_default_wakeup+0x2a/0x40 drivers/tty/tty_port.c:71
       serial8250_tx_chars+0x53e/0xe00 drivers/tty/serial/8250/8250_port.c:1858
       __start_tx drivers/tty/serial/8250/8250_port.c:1575 [inline]
       serial8250_start_tx+0x6d5/0x850 drivers/tty/serial/8250/8250_port.c:1681
       __uart_start.isra.0+0x16b/0x1b0 drivers/tty/serial/serial_core.c:141
       uart_write+0x2ff/0x570 drivers/tty/serial/serial_core.c:601
       process_output_block drivers/tty/n_tty.c:586 [inline]
       n_tty_write+0x4ce/0xfd0 drivers/tty/n_tty.c:2350
       do_tty_write drivers/tty/tty_io.c:1018 [inline]
       file_tty_write.constprop.0+0x452/0x890 drivers/tty/tty_io.c:1089
       redirected_tty_write+0xa5/0xc0 drivers/tty/tty_io.c:1110
       call_write_iter include/linux/fs.h:2186 [inline]
       new_sync_write fs/read_write.c:491 [inline]
       vfs_write+0x9ed/0xdd0 fs/read_write.c:584
       ksys_write+0x12b/0x250 fs/read_write.c:637
       do_syscall_x64 arch/x86/entry/common.c:50 [inline]
       do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
       entry_SYSCALL_64_after_hwframe+0x63/0xcd

-> #2 (&port_lock_key){-.-.}-{2:2}:
       __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
       _raw_spin_lock_irqsave+0x3d/0x60 kernel/locking/spinlock.c:162
       serial8250_console_write+0x4ba/0x1010 drivers/tty/serial/8250/8250_port.c:3394
       call_console_driver kernel/printk/printk.c:2031 [inline]
       console_emit_next_record.constprop.0+0x3d8/0x890 kernel/printk/printk.c:2823
       console_flush_all+0x547/0x6e0 kernel/printk/printk.c:2887
       console_unlock+0xb8/0x1f0 kernel/printk/printk.c:2964
       vprintk_emit+0x1bd/0x600 kernel/printk/printk.c:2357
       vprintk+0x84/0xa0 kernel/printk/printk_safe.c:50
       _printk+0xbe/0xf1 kernel/printk/printk.c:2378
       register_console+0x7e5/0xe10 kernel/printk/printk.c:3415
       univ8250_console_init+0x3e/0x4a drivers/tty/serial/8250/8250_core.c:688
       console_init+0x3bb/0x582 kernel/printk/printk.c:3558
       start_kernel+0x2e0/0x470 init/main.c:1077
       secondary_startup_64_no_verify+0xce/0xdb

-> #1 (console_owner){-.-.}-{0:0}:
       console_lock_spinning_enable kernel/printk/printk.c:1888 [inline]
       console_emit_next_record.constprop.0+0x2e3/0x890 kernel/printk/printk.c:2820
       console_flush_all+0x547/0x6e0 kernel/printk/printk.c:2887
       console_unlock+0xb8/0x1f0 kernel/printk/printk.c:2964
       vprintk_emit+0x1bd/0x600 kernel/printk/printk.c:2357
       vprintk+0x84/0xa0 kernel/printk/printk_safe.c:50
       _printk+0xbe/0xf1 kernel/printk/printk.c:2378
       build_zonelists.cold+0xe5/0x11f mm/page_alloc.c:6497
       __build_all_zonelists+0x122/0x180 mm/page_alloc.c:6610
       build_all_zonelists_init+0x35/0x12f mm/page_alloc.c:6635
       build_all_zonelists+0x123/0x140 mm/page_alloc.c:6668
       start_kernel+0xbd/0x470 init/main.c:971
       secondary_startup_64_no_verify+0xce/0xdb

-> #0 (zonelist_update_seq.seqcount){...-}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:3097 [inline]
       check_prevs_add kernel/locking/lockdep.c:3216 [inline]
       validate_chain kernel/locking/lockdep.c:3831 [inline]
       __lock_acquire+0x2a43/0x56d0 kernel/locking/lockdep.c:5055
       lock_acquire kernel/locking/lockdep.c:5668 [inline]
       lock_acquire+0x1e3/0x630 kernel/locking/lockdep.c:5633
       seqcount_lockdep_reader_access include/linux/seqlock.h:102 [inline]
       read_seqbegin include/linux/seqlock.h:836 [inline]
       zonelist_iter_begin mm/page_alloc.c:4722 [inline]
       __alloc_pages_slowpath.constprop.0+0x1ae/0x23d0 mm/page_alloc.c:5044
       __alloc_pages+0x4aa/0x5b0 mm/page_alloc.c:5562
       __alloc_pages_node include/linux/gfp.h:237 [inline]
       kmem_getpages mm/slab.c:1363 [inline]
       cache_grow_begin+0x94/0x390 mm/slab.c:2574
       cache_alloc_refill+0x27f/0x380 mm/slab.c:2947
       ____cache_alloc mm/slab.c:3023 [inline]
       ____cache_alloc mm/slab.c:3006 [inline]
       __do_cache_alloc mm/slab.c:3206 [inline]
       slab_alloc_node mm/slab.c:3254 [inline]
       slab_alloc mm/slab.c:3270 [inline]
       __kmem_cache_alloc_lru mm/slab.c:3447 [inline]
       kmem_cache_alloc+0x366/0x460 mm/slab.c:3456
       kmem_cache_zalloc include/linux/slab.h:710 [inline]
       fill_pool+0x264/0x5c0 lib/debugobjects.c:168
       __debug_object_init+0x7a/0xd10 lib/debugobjects.c:569
       debug_object_init lib/debugobjects.c:624 [inline]
       debug_object_activate+0x330/0x3e0 lib/debugobjects.c:710
       debug_work_activate kernel/workqueue.c:510 [inline]
       __queue_work+0x682/0x13b0 kernel/workqueue.c:1516
       call_timer_fn+0x1da/0x7c0 kernel/time/timer.c:1700
       expire_timers+0xbb/0x5c0 kernel/time/timer.c:1746
       __run_timers kernel/time/timer.c:2022 [inline]
       __run_timers kernel/time/timer.c:1995 [inline]
       run_timer_softirq+0x326/0x910 kernel/time/timer.c:2035
       __do_softirq+0x1fb/0xadc kernel/softirq.c:571
       invoke_softirq kernel/softirq.c:445 [inline]
       __irq_exit_rcu+0x123/0x180 kernel/softirq.c:650
       irq_exit_rcu+0x9/0x20 kernel/softirq.c:662
       sysvec_apic_timer_interrupt+0x97/0xc0 arch/x86/kernel/apic/apic.c:1107
       asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:649
       native_safe_halt arch/x86/include/asm/irqflags.h:51 [inline]
       arch_safe_halt arch/x86/include/asm/irqflags.h:89 [inline]
       default_idle+0xf/0x10 arch/x86/kernel/process.c:730
       default_idle_call+0x84/0xc0 kernel/sched/idle.c:109
       cpuidle_idle_call kernel/sched/idle.c:191 [inline]
       do_idle+0x410/0x590 kernel/sched/idle.c:303
       cpu_startup_entry+0x18/0x20 kernel/sched/idle.c:400
       start_secondary+0x256/0x300 arch/x86/kernel/smpboot.c:264
       secondary_startup_64_no_verify+0xce/0xdb

other info that might help us debug this:

Chain exists of:
  zonelist_update_seq.seqcount --> &tty->write_wait --> &pool->lock

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&pool->lock);
                               lock(&tty->write_wait);
                               lock(&pool->lock);
  lock(zonelist_update_seq.seqcount);

 *** DEADLOCK ***

3 locks held by swapper/2/0:
 #0: ffffc90000790d60 (net/ipv4/tcp_ipv4.c:1056){..-.}-{0:0}, at: lockdep_copy_map include/linux/lockdep.h:31 [inline]
 #0: ffffc90000790d60 (net/ipv4/tcp_ipv4.c:1056){..-.}-{0:0}, at: call_timer_fn+0xd4/0x7c0 kernel/time/timer.c:1690
 #1: ffffffff8c78e800 (rcu_read_lock){....}-{1:2}, at: __queue_work+0xca/0x13b0 kernel/workqueue.c:1437
 #2: ffff88802c83ae18 (&pool->lock){-.-.}-{2:2}, at: __queue_work+0x367/0x13b0 kernel/workqueue.c:1474

stack backtrace:
CPU: 2 PID: 0 Comm: swapper/2 Not tainted 6.1.0-syzkaller-14364-g9d2f6060fe4c #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-2 04/01/2014
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xd1/0x138 lib/dump_stack.c:106
 check_noncircular+0x25f/0x2e0 kernel/locking/lockdep.c:2177
 check_prev_add kernel/locking/lockdep.c:3097 [inline]
 check_prevs_add kernel/locking/lockdep.c:3216 [inline]
 validate_chain kernel/locking/lockdep.c:3831 [inline]
 __lock_acquire+0x2a43/0x56d0 kernel/locking/lockdep.c:5055
 lock_acquire kernel/locking/lockdep.c:5668 [inline]
 lock_acquire+0x1e3/0x630 kernel/locking/lockdep.c:5633
 seqcount_lockdep_reader_access include/linux/seqlock.h:102 [inline]
 read_seqbegin include/linux/seqlock.h:836 [inline]
 zonelist_iter_begin mm/page_alloc.c:4722 [inline]
 __alloc_pages_slowpath.constprop.0+0x1ae/0x23d0 mm/page_alloc.c:5044
 __alloc_pages+0x4aa/0x5b0 mm/page_alloc.c:5562
 __alloc_pages_node include/linux/gfp.h:237 [inline]
 kmem_getpages mm/slab.c:1363 [inline]
 cache_grow_begin+0x94/0x390 mm/slab.c:2574
 cache_alloc_refill+0x27f/0x380 mm/slab.c:2947
 ____cache_alloc mm/slab.c:3023 [inline]
 ____cache_alloc mm/slab.c:3006 [inline]
 __do_cache_alloc mm/slab.c:3206 [inline]
 slab_alloc_node mm/slab.c:3254 [inline]
 slab_alloc mm/slab.c:3270 [inline]
 __kmem_cache_alloc_lru mm/slab.c:3447 [inline]
 kmem_cache_alloc+0x366/0x460 mm/slab.c:3456
 kmem_cache_zalloc include/linux/slab.h:710 [inline]
 fill_pool+0x264/0x5c0 lib/debugobjects.c:168
 __debug_object_init+0x7a/0xd10 lib/debugobjects.c:569
 debug_object_init lib/debugobjects.c:624 [inline]
 debug_object_activate+0x330/0x3e0 lib/debugobjects.c:710
 debug_work_activate kernel/workqueue.c:510 [inline]
 __queue_work+0x682/0x13b0 kernel/workqueue.c:1516
 call_timer_fn+0x1da/0x7c0 kernel/time/timer.c:1700
 expire_timers+0xbb/0x5c0 kernel/time/timer.c:1746
 __run_timers kernel/time/timer.c:2022 [inline]
 __run_timers kernel/time/timer.c:1995 [inline]
 run_timer_softirq+0x326/0x910 kernel/time/timer.c:2035
 __do_softirq+0x1fb/0xadc kernel/softirq.c:571
 invoke_softirq kernel/softirq.c:445 [inline]
 __irq_exit_rcu+0x123/0x180 kernel/softirq.c:650
 irq_exit_rcu+0x9/0x20 kernel/softirq.c:662
 sysvec_apic_timer_interrupt+0x97/0xc0 arch/x86/kernel/apic/apic.c:1107
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:649
RIP: 0010:default_idle+0xf/0x10 arch/x86/kernel/process.c:731
Code: e8 d6 66 c5 f7 e9 8c fd ff ff 4c 89 f7 e8 c9 66 c5 f7 e9 3a fd ff ff cc cc cc cc f3 0f 1e fa 66 90 0f 00 2d c3 38 3e 00 fb f4 <c3> f3 0f 1e fa 41 54 be 08 00 00 00 53 65 48 8b 1c 25 40 ac 03 00
RSP: 0018:ffffc9000067fdf8 EFLAGS: 00000246
RAX: 00000000003e3d8d RBX: ffff88801311c240 RCX: ffffffff8a0528b5
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: dffffc0000000000 R08: 0000000000000001 R09: ffff88802c83602b
R10: ffffed1005906c05 R11: 0000000000000001 R12: 0000000000000002
R13: 0000000000000002 R14: ffffffff8e720750 R15: 0000000000000000
 default_idle_call+0x84/0xc0 kernel/sched/idle.c:109
 cpuidle_idle_call kernel/sched/idle.c:191 [inline]
 do_idle+0x410/0x590 kernel/sched/idle.c:303
 cpu_startup_entry+0x18/0x20 kernel/sched/idle.c:400
 start_secondary+0x256/0x300 arch/x86/kernel/smpboot.c:264
 secondary_startup_64_no_verify+0xce/0xdb
 </TASK>
----------------
Code disassembly (best guess):
   0:	e8 d6 66 c5 f7       	callq  0xf7c566db
   5:	e9 8c fd ff ff       	jmpq   0xfffffd96
   a:	4c 89 f7             	mov    %r14,%rdi
   d:	e8 c9 66 c5 f7       	callq  0xf7c566db
  12:	e9 3a fd ff ff       	jmpq   0xfffffd51
  17:	cc                   	int3
  18:	cc                   	int3
  19:	cc                   	int3
  1a:	cc                   	int3
  1b:	f3 0f 1e fa          	endbr64
  1f:	66 90                	xchg   %ax,%ax
  21:	0f 00 2d c3 38 3e 00 	verw   0x3e38c3(%rip)        # 0x3e38eb
  28:	fb                   	sti
  29:	f4                   	hlt
* 2a:	c3                   	retq <-- trapping instruction
  2b:	f3 0f 1e fa          	endbr64
  2f:	41 54                	push   %r12
  31:	be 08 00 00 00       	mov    $0x8,%esi
  36:	53                   	push   %rbx
  37:	65 48 8b 1c 25 40 ac 	mov    %gs:0x3ac40,%rbx
  3e:	03 00


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
