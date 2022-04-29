Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EFFD515892
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 00:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381544AbiD2Wmn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 18:42:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344050AbiD2Wmn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 18:42:43 -0400
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 259F59BACC
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 15:39:22 -0700 (PDT)
Received: by mail-io1-f71.google.com with SMTP id g16-20020a05660226d000b00638d8e1828bso7398801ioo.13
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 15:39:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=a85Cx9Q7N8whVyPw7JKCaCOclQHIgaX6Ab6qtyTfvyY=;
        b=1+4xDN+QE3smwqm6dcybqQj6InmLuDsBX5ZdgCda6s5GQETyvOoFr3GCivh0oQqiF6
         pgWZRVNyAKlWGQrm0bkroQCMs/9UG10IvcFIo7D2TjE+qhy6PUCuClazOO8BwqKVeXwA
         a3kT82tcJFhfX/k0uXroVfa+iHgpCC3z8WYdi/rraPUvEgu20/fXzQHjCNBrGLU3h4Kl
         rb54gqEOFTnMzGnYe++YtIj68TiJteCOXa3zsGSbu7q81QoHkwjdZmxkjUiusuNrHQRH
         NcKVVYYR6+MW4pq2wz4raF2UATFPKk4RzQY5V+s5daZvnBkHXUm4EFLIHf3XiECWqBVx
         HUoA==
X-Gm-Message-State: AOAM533KIivkme/Vl7ZrTmdJqyt/k2kPa6L5yftbddE2hlijkeVvy/19
        coCPxVsH2JiRALvQUaLlX3mZQofErd11uujH81K+VAgeKto5
X-Google-Smtp-Source: ABdhPJwCoPHow7m8HaZIT6ykqJRraXrCZAQaeVoRweovgVJ8yNsBYZuoa2ugNr6Oq/TWeK4W15i+FEgBgTmflV4R2kd7sQqLvKS3
MIME-Version: 1.0
X-Received: by 2002:a05:6638:16c9:b0:328:5569:fe94 with SMTP id
 g9-20020a05663816c900b003285569fe94mr636736jat.145.1651271961874; Fri, 29 Apr
 2022 15:39:21 -0700 (PDT)
Date:   Fri, 29 Apr 2022 15:39:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b71a3e05ddd2b614@google.com>
Subject: [syzbot] possible deadlock in ___bpf_prog_run
From:   syzbot <syzbot+e8a9ac8d099f6b5efa84@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, hawk@kernel.org,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com,
        netdev@vger.kernel.org, rostedt@goodmis.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
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

HEAD commit:    af2d861d4cd2 Linux 5.18-rc4
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1180aa00f00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4071c85377b36266
dashboard link: https://syzkaller.appspot.com/bug?extid=e8a9ac8d099f6b5efa84
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e8a9ac8d099f6b5efa84@syzkaller.appspotmail.com

------------[ cut here ]------------
======================================================
WARNING: possible circular locking dependency detected
5.18.0-rc4-syzkaller #0 Tainted: G S               
------------------------------------------------------
rcu_preempt/18 is trying to acquire lock:
ffffffff8bd6e0b8 ((console_sem).lock){-.-.}-{2:2}, at: down_trylock+0xe/0x60 kernel/locking/semaphore.c:138

but task is already holding lock:
ffffffff8be04df8 (trace_printk_lock){....}-{2:2}, at: ____bpf_trace_printk kernel/trace/bpf_trace.c:385 [inline]
ffffffff8be04df8 (trace_printk_lock){....}-{2:2}, at: bpf_trace_printk+0xcf/0x170 kernel/trace/bpf_trace.c:371

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #3 (trace_printk_lock){....}-{2:2}:
       __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
       _raw_spin_lock_irqsave+0x39/0x50 kernel/locking/spinlock.c:162
       ____bpf_trace_printk kernel/trace/bpf_trace.c:385 [inline]
       bpf_trace_printk+0xcf/0x170 kernel/trace/bpf_trace.c:371
       ___bpf_prog_run+0x3592/0x77d0 kernel/bpf/core.c:1835
       __bpf_prog_run32+0x8a/0xd0 kernel/bpf/core.c:2062
       bpf_dispatcher_nop_func include/linux/bpf.h:804 [inline]
       __bpf_prog_run include/linux/filter.h:628 [inline]
       bpf_prog_run include/linux/filter.h:635 [inline]
       __bpf_trace_run kernel/trace/bpf_trace.c:2022 [inline]
       bpf_trace_run4+0x124/0x360 kernel/trace/bpf_trace.c:2061
       __bpf_trace_sched_switch+0x115/0x160 include/trace/events/sched.h:222
       __traceiter_sched_switch+0x68/0xb0 include/trace/events/sched.h:222
       trace_sched_switch include/trace/events/sched.h:222 [inline]
       __schedule+0x1543/0x4cc0 kernel/sched/core.c:6385
       preempt_schedule_common+0x45/0xc0 kernel/sched/core.c:6553
       preempt_schedule_thunk+0x16/0x18 arch/x86/entry/thunk_64.S:35
       try_to_wake_up+0xa04/0x1800 kernel/sched/core.c:4204
       wake_up_process kernel/sched/core.c:4282 [inline]
       wake_up_q+0x7e/0xf0 kernel/sched/core.c:1029
       futex_wake+0x3e9/0x490 kernel/futex/waitwake.c:184
       do_futex+0x266/0x300 kernel/futex/syscalls.c:111
       __do_sys_futex kernel/futex/syscalls.c:183 [inline]
       __se_sys_futex kernel/futex/syscalls.c:164 [inline]
       __x64_sys_futex+0x1b0/0x4a0 kernel/futex/syscalls.c:164
       do_syscall_x64 arch/x86/entry/common.c:50 [inline]
       do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
       entry_SYSCALL_64_after_hwframe+0x44/0xae

-> #2 (&rq->__lock){-.-.}-{2:2}:
       _raw_spin_lock_nested+0x30/0x40 kernel/locking/spinlock.c:378
       raw_spin_rq_lock_nested+0x2b/0x120 kernel/sched/core.c:554
       raw_spin_rq_lock kernel/sched/sched.h:1297 [inline]
       rq_lock kernel/sched/sched.h:1595 [inline]
       task_fork_fair+0x68/0x520 kernel/sched/fair.c:11236
       sched_cgroup_fork+0x340/0x480 kernel/sched/core.c:4546
       copy_process+0x42f0/0x6fe0 kernel/fork.c:2351
       kernel_clone+0xe7/0xab0 kernel/fork.c:2639
       kernel_thread+0xb5/0xf0 kernel/fork.c:2691
       rest_init+0x23/0x3e0 init/main.c:691
       start_kernel+0x47f/0x4a0 init/main.c:1140
       secondary_startup_64_no_verify+0xc3/0xcb

-> #1 (&p->pi_lock){-.-.}-{2:2}:
       __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
       _raw_spin_lock_irqsave+0x39/0x50 kernel/locking/spinlock.c:162
       try_to_wake_up+0xaa/0x1800 kernel/sched/core.c:4082
       up+0x75/0xb0 kernel/locking/semaphore.c:190
       __up_console_sem+0xa4/0xc0 kernel/printk/printk.c:263
       console_unlock+0x62c/0xdd0 kernel/printk/printk.c:2794
       vga_remove_vgacon drivers/pci/vgaarb.c:189 [inline]
       vga_remove_vgacon.cold+0x99/0x9e drivers/pci/vgaarb.c:170
       drm_aperture_remove_conflicting_pci_framebuffers+0x188/0x230 drivers/gpu/drm/drm_aperture.c:350
       virtio_gpu_pci_quirk drivers/gpu/drm/virtio/virtgpu_drv.c:61 [inline]
       virtio_gpu_probe.cold+0x16a/0x189 drivers/gpu/drm/virtio/virtgpu_drv.c:118
       virtio_dev_probe+0x577/0x870 drivers/virtio/virtio.c:295
       call_driver_probe drivers/base/dd.c:542 [inline]
       really_probe+0x23e/0xb20 drivers/base/dd.c:621
       __driver_probe_device+0x338/0x4d0 drivers/base/dd.c:752
       driver_probe_device+0x4c/0x1a0 drivers/base/dd.c:782
       __driver_attach+0x22d/0x4e0 drivers/base/dd.c:1141
       bus_for_each_dev+0x147/0x1d0 drivers/base/bus.c:301
       bus_add_driver+0x41d/0x630 drivers/base/bus.c:618
       driver_register+0x220/0x3a0 drivers/base/driver.c:171
       do_one_initcall+0x103/0x650 init/main.c:1298
       do_initcall_level init/main.c:1371 [inline]
       do_initcalls init/main.c:1387 [inline]
       do_basic_setup init/main.c:1406 [inline]
       kernel_init_freeable+0x6b1/0x73a init/main.c:1613
       kernel_init+0x1a/0x1d0 init/main.c:1502
       ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:298

-> #0 ((console_sem).lock){-.-.}-{2:2}:
       check_prev_add kernel/locking/lockdep.c:3065 [inline]
       check_prevs_add kernel/locking/lockdep.c:3188 [inline]
       validate_chain kernel/locking/lockdep.c:3803 [inline]
       __lock_acquire+0x2ac6/0x56c0 kernel/locking/lockdep.c:5029
       lock_acquire kernel/locking/lockdep.c:5641 [inline]
       lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5606
       __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
       _raw_spin_lock_irqsave+0x39/0x50 kernel/locking/spinlock.c:162
       down_trylock+0xe/0x60 kernel/locking/semaphore.c:138
       __down_trylock_console_sem+0x40/0x120 kernel/printk/printk.c:246
       console_trylock kernel/printk/printk.c:2581 [inline]
       console_trylock_spinning kernel/printk/printk.c:1856 [inline]
       vprintk_emit+0x162/0x5f0 kernel/printk/printk.c:2271
       vprintk+0x80/0x90 kernel/printk/printk_safe.c:50
       _printk+0xba/0xed kernel/printk/printk.c:2293
       __warn_printk+0x9b/0xf3 kernel/panic.c:638
       rb_check_timestamp kernel/trace/ring_buffer.c:2734 [inline]
       rb_add_timestamp kernel/trace/ring_buffer.c:2772 [inline]
       rb_update_event kernel/trace/ring_buffer.c:2809 [inline]
       __rb_reserve_next+0x121a/0x1630 kernel/trace/ring_buffer.c:3565
       rb_reserve_next_event kernel/trace/ring_buffer.c:3635 [inline]
       ring_buffer_lock_reserve+0x44f/0xfa0 kernel/trace/ring_buffer.c:3694
       __trace_buffer_lock_reserve kernel/trace/trace.c:949 [inline]
       trace_event_buffer_lock_reserve+0x11e/0x730 kernel/trace/trace.c:2821
       trace_event_buffer_reserve+0x248/0x3c0 kernel/trace/trace_events.c:496
       trace_event_raw_event_bpf_trace_printk+0xe9/0x1f0 kernel/trace/./bpf_trace.h:11
       trace_bpf_trace_printk+0x116/0x220 kernel/trace/bpf_trace.h:11
       ____bpf_trace_printk kernel/trace/bpf_trace.c:388 [inline]
       bpf_trace_printk+0xfa/0x170 kernel/trace/bpf_trace.c:371
       ___bpf_prog_run+0x3592/0x77d0 kernel/bpf/core.c:1835
       __bpf_prog_run32+0x8a/0xd0 kernel/bpf/core.c:2062
       bpf_dispatcher_nop_func include/linux/bpf.h:804 [inline]
       __bpf_prog_run include/linux/filter.h:628 [inline]
       bpf_prog_run include/linux/filter.h:635 [inline]
       __bpf_trace_run kernel/trace/bpf_trace.c:2022 [inline]
       bpf_trace_run4+0x124/0x360 kernel/trace/bpf_trace.c:2061
       __bpf_trace_sched_switch+0x115/0x160 include/trace/events/sched.h:222
       __traceiter_sched_switch+0x68/0xb0 include/trace/events/sched.h:222
       trace_sched_switch include/trace/events/sched.h:222 [inline]
       __schedule+0x1543/0x4cc0 kernel/sched/core.c:6385
       schedule+0xd2/0x1f0 kernel/sched/core.c:6460
       schedule_timeout+0x14a/0x2a0 kernel/time/timer.c:1884
       rcu_gp_fqs_loop+0x186/0x810 kernel/rcu/tree.c:1971
       rcu_gp_kthread+0x1de/0x320 kernel/rcu/tree.c:2144
       kthread+0x2e9/0x3a0 kernel/kthread.c:376
       ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:298

other info that might help us debug this:

Chain exists of:
  (console_sem).lock --> &rq->__lock --> trace_printk_lock

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(trace_printk_lock);
                               lock(&rq->__lock);
                               lock(trace_printk_lock);
  lock((console_sem).lock);

 *** DEADLOCK ***

3 locks held by rcu_preempt/18:
 #0: ffff88802cc3a098 (&rq->__lock){-.-.}-{2:2}, at: raw_spin_rq_lock_nested+0x2b/0x120 kernel/sched/core.c:554
 #1: ffffffff8bd7f5e0 (rcu_read_lock){....}-{1:2}, at: bpf_trace_run4+0x0/0x360 include/linux/filter.h:628
 #2: ffffffff8be04df8 (trace_printk_lock){....}-{2:2}, at: ____bpf_trace_printk kernel/trace/bpf_trace.c:385 [inline]
 #2: ffffffff8be04df8 (trace_printk_lock){....}-{2:2}, at: bpf_trace_printk+0xcf/0x170 kernel/trace/bpf_trace.c:371

stack backtrace:
CPU: 2 PID: 18 Comm: rcu_preempt Tainted: G S                5.18.0-rc4-syzkaller #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-2 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 check_noncircular+0x25f/0x2e0 kernel/locking/lockdep.c:2145
 check_prev_add kernel/locking/lockdep.c:3065 [inline]
 check_prevs_add kernel/locking/lockdep.c:3188 [inline]
 validate_chain kernel/locking/lockdep.c:3803 [inline]
 __lock_acquire+0x2ac6/0x56c0 kernel/locking/lockdep.c:5029
 lock_acquire kernel/locking/lockdep.c:5641 [inline]
 lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5606
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
 _raw_spin_lock_irqsave+0x39/0x50 kernel/locking/spinlock.c:162
 down_trylock+0xe/0x60 kernel/locking/semaphore.c:138
 __down_trylock_console_sem+0x40/0x120 kernel/printk/printk.c:246
 console_trylock kernel/printk/printk.c:2581 [inline]
 console_trylock_spinning kernel/printk/printk.c:1856 [inline]
 vprintk_emit+0x162/0x5f0 kernel/printk/printk.c:2271
 vprintk+0x80/0x90 kernel/printk/printk_safe.c:50
 _printk+0xba/0xed kernel/printk/printk.c:2293
 __warn_printk+0x9b/0xf3 kernel/panic.c:638
 rb_check_timestamp kernel/trace/ring_buffer.c:2734 [inline]
 rb_add_timestamp kernel/trace/ring_buffer.c:2772 [inline]
 rb_update_event kernel/trace/ring_buffer.c:2809 [inline]
 __rb_reserve_next+0x121a/0x1630 kernel/trace/ring_buffer.c:3565
 rb_reserve_next_event kernel/trace/ring_buffer.c:3635 [inline]
 ring_buffer_lock_reserve+0x44f/0xfa0 kernel/trace/ring_buffer.c:3694
 __trace_buffer_lock_reserve kernel/trace/trace.c:949 [inline]
 trace_event_buffer_lock_reserve+0x11e/0x730 kernel/trace/trace.c:2821
 trace_event_buffer_reserve+0x248/0x3c0 kernel/trace/trace_events.c:496
 trace_event_raw_event_bpf_trace_printk+0xe9/0x1f0 kernel/trace/./bpf_trace.h:11
 trace_bpf_trace_printk+0x116/0x220 kernel/trace/bpf_trace.h:11
 ____bpf_trace_printk kernel/trace/bpf_trace.c:388 [inline]
 bpf_trace_printk+0xfa/0x170 kernel/trace/bpf_trace.c:371
 ___bpf_prog_run+0x3592/0x77d0 kernel/bpf/core.c:1835
 __bpf_prog_run32+0x8a/0xd0 kernel/bpf/core.c:2062
 bpf_dispatcher_nop_func include/linux/bpf.h:804 [inline]
 __bpf_prog_run include/linux/filter.h:628 [inline]
 bpf_prog_run include/linux/filter.h:635 [inline]
 __bpf_trace_run kernel/trace/bpf_trace.c:2022 [inline]
 bpf_trace_run4+0x124/0x360 kernel/trace/bpf_trace.c:2061
 __bpf_trace_sched_switch+0x115/0x160 include/trace/events/sched.h:222
 __traceiter_sched_switch+0x68/0xb0 include/trace/events/sched.h:222
 trace_sched_switch include/trace/events/sched.h:222 [inline]
 __schedule+0x1543/0x4cc0 kernel/sched/core.c:6385
 schedule+0xd2/0x1f0 kernel/sched/core.c:6460
 schedule_timeout+0x14a/0x2a0 kernel/time/timer.c:1884
 rcu_gp_fqs_loop+0x186/0x810 kernel/rcu/tree.c:1971
 rcu_gp_kthread+0x1de/0x320 kernel/rcu/tree.c:2144
 kthread+0x2e9/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:298
 </TASK>
Delta way too big! 8020330161787334413 ts=8020330481964229010 before=320176894597 after=320176894597 write stamp=8020330481964229010
WARNING: CPU: 2 PID: 18 at kernel/trace/ring_buffer.c:2734 rb_check_timestamp kernel/trace/ring_buffer.c:2734 [inline]
WARNING: CPU: 2 PID: 18 at kernel/trace/ring_buffer.c:2734 rb_add_timestamp kernel/trace/ring_buffer.c:2772 [inline]
WARNING: CPU: 2 PID: 18 at kernel/trace/ring_buffer.c:2734 rb_update_event kernel/trace/ring_buffer.c:2809 [inline]
WARNING: CPU: 2 PID: 18 at kernel/trace/ring_buffer.c:2734 __rb_reserve_next+0x121a/0x1630 kernel/trace/ring_buffer.c:3565
Modules linked in:
CPU: 2 PID: 18 Comm: rcu_preempt Tainted: G S                5.18.0-rc4-syzkaller #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-2 04/01/2014
RIP: 0010:rb_check_timestamp kernel/trace/ring_buffer.c:2734 [inline]
RIP: 0010:rb_add_timestamp kernel/trace/ring_buffer.c:2772 [inline]
RIP: 0010:rb_update_event kernel/trace/ring_buffer.c:2809 [inline]
RIP: 0010:__rb_reserve_next+0x121a/0x1630 kernel/trace/ring_buffer.c:3565
Code: 80 3c 01 00 0f 85 98 02 00 00 ff 74 24 40 49 89 d8 4c 89 f1 48 c7 c7 00 17 d1 89 49 8b 74 24 08 4c 8b 4c 24 20 e8 2d da a9 07 <0f> 0b 58 e9 89 fe ff ff e8 39 6c 48 00 e9 0f ee ff ff 48 89 ef e8
RSP: 0018:ffffc9000065f388 EFLAGS: 00010082
RAX: 0000000000000000 RBX: 0000004a8c07b285 RCX: 0000000000000000
RDX: ffff8880118da200 RSI: ffffffff815f3b38 RDI: fffff520000cbe63
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff815ee50e R11: 0000000000000000 R12: ffffc9000065f4c0
R13: ffff888011b30000 R14: 0000004a8c07b285 R15: 0000000000000b40
FS:  0000000000000000(0000) GS:ffff88802cc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fbfc11681b8 CR3: 0000000068ca0000 CR4: 0000000000150ee0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 rb_reserve_next_event kernel/trace/ring_buffer.c:3635 [inline]
 ring_buffer_lock_reserve+0x44f/0xfa0 kernel/trace/ring_buffer.c:3694
 __trace_buffer_lock_reserve kernel/trace/trace.c:949 [inline]
 trace_event_buffer_lock_reserve+0x11e/0x730 kernel/trace/trace.c:2821
 trace_event_buffer_reserve+0x248/0x3c0 kernel/trace/trace_events.c:496
 trace_event_raw_event_bpf_trace_printk+0xe9/0x1f0 kernel/trace/./bpf_trace.h:11
 trace_bpf_trace_printk+0x116/0x220 kernel/trace/bpf_trace.h:11
 ____bpf_trace_printk kernel/trace/bpf_trace.c:388 [inline]
 bpf_trace_printk+0xfa/0x170 kernel/trace/bpf_trace.c:371
 ___bpf_prog_run+0x3592/0x77d0 kernel/bpf/core.c:1835
 __bpf_prog_run32+0x8a/0xd0 kernel/bpf/core.c:2062
 bpf_dispatcher_nop_func include/linux/bpf.h:804 [inline]
 __bpf_prog_run include/linux/filter.h:628 [inline]
 bpf_prog_run include/linux/filter.h:635 [inline]
 __bpf_trace_run kernel/trace/bpf_trace.c:2022 [inline]
 bpf_trace_run4+0x124/0x360 kernel/trace/bpf_trace.c:2061
 __bpf_trace_sched_switch+0x115/0x160 include/trace/events/sched.h:222
 __traceiter_sched_switch+0x68/0xb0 include/trace/events/sched.h:222
 trace_sched_switch include/trace/events/sched.h:222 [inline]
 __schedule+0x1543/0x4cc0 kernel/sched/core.c:6385
 schedule+0xd2/0x1f0 kernel/sched/core.c:6460
 schedule_timeout+0x14a/0x2a0 kernel/time/timer.c:1884
 rcu_gp_fqs_loop+0x186/0x810 kernel/rcu/tree.c:1971
 rcu_gp_kthread+0x1de/0x320 kernel/rcu/tree.c:2144
 kthread+0x2e9/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:298
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
