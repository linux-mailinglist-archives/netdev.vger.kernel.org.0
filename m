Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB8E9215A67
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 17:13:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729310AbgGFPMx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 11:12:53 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:35735 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729269AbgGFPMY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 11:12:24 -0400
Received: by mail-il1-f197.google.com with SMTP id v12so6929719ilg.2
        for <netdev@vger.kernel.org>; Mon, 06 Jul 2020 08:12:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=A8AMKY8aPzdRnisOHV7tznqt6RcTPKGq2mtLpSQhRdM=;
        b=Pwh1DRomNsFXJgOuLaYrFnCi+hGv61xOQp4AVAADRzMttfcSo+f3J7mbdBSzfUlayw
         93AMg+aDkBAr0FhHvcqoZ93pZ4UEhXB5zofwgiZt28diiPGrGZOaPHnnZJyuq1hZfocL
         co0MS257VRaO+eLj+wolOeMrbfvxNdu/ApbzDZmJ0mOm5ap99U6pMUr0VOgRXK1kmu8n
         pTJDytutrEOEApkyk9PyNbGCqOFF5ReGg9pJWgJ2uAdtUQO/SLVNQYx0B0ZEoBbC2ZVW
         ehJFIMrGzSV1vdWqopQIYc6k6Qv/Gb5Ihwi+1y5HkiD2cbX4slf1OFmwe4ydUElHqi+q
         Dzhw==
X-Gm-Message-State: AOAM531iJIf5WlkNGsyHBU8mMxe4s1ykR9cH1iHFv1c2IqBqrVYaovf3
        umb3Yfni+aZRas7h58aecO/DaidIGIfSuwRQrugGkJ6lohiJ
X-Google-Smtp-Source: ABdhPJwKIbZpsvpXV+5Ek9wHgpR6MvEdpzwlMpofnHIEydYavIzgAr+goB0Sh77D4pLypL9fiFObLqRjAuesafDVFtmcTwHhFk0n
MIME-Version: 1.0
X-Received: by 2002:a92:c530:: with SMTP id m16mr31740900ili.300.1594048343040;
 Mon, 06 Jul 2020 08:12:23 -0700 (PDT)
Date:   Mon, 06 Jul 2020 08:12:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003dea2205a9c74d50@google.com>
Subject: INFO: task hung in pcpu_alloc
From:   syzbot <syzbot+9b3b388c8ccd4c8bae92@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org, mkl@pengutronix.de,
        netdev@vger.kernel.org, socketcan@hartkopp.net,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    caffb99b Merge git://git.kernel.org/pub/scm/linux/kernel/g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11df10ee100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b3368ce0cc5f5ace
dashboard link: https://syzkaller.appspot.com/bug?extid=9b3b388c8ccd4c8bae92
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+9b3b388c8ccd4c8bae92@syzkaller.appspotmail.com

INFO: task syz-executor.1:28515 blocked for more than 143 seconds.
      Not tainted 5.7.0-rc6-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor.1  D28392 28515   7206 0x00000004
Call Trace:
 context_switch kernel/sched/core.c:3367 [inline]
 __schedule+0x937/0x1ff0 kernel/sched/core.c:4083
 rwsem_down_write_slowpath+0x90a/0xf90 kernel/locking/rwsem.c:1216
 __sched_text_start+0x8/0x8
 schedule+0xd0/0x2a0 kernel/sched/core.c:4158
 rwsem_down_write_slowpath+0x706/0xf90 kernel/locking/rwsem.c:1235
 pcpu_alloc+0xfed/0x13b0 mm/percpu.c:1703
 rwsem_mark_wake+0x8d0/0x8d0 include/linux/compiler.h:199
 lock_acquire+0x1f2/0x8f0 kernel/locking/lockdep.c:4934
 register_netdevice_notifier+0x1e/0x270 net/core/dev.c:1729
 lock_release+0x800/0x800 kernel/locking/lockdep.c:4689
 __down_write kernel/locking/rwsem.c:1389 [inline]
 down_write+0x137/0x150 kernel/locking/rwsem.c:1532
 atomic64_try_cmpxchg include/asm-generic/atomic-instrumented.h:1504 [inline]
 atomic_long_try_cmpxchg_acquire include/asm-generic/atomic-long.h:442 [inline]
 __down_write kernel/locking/rwsem.c:1387 [inline]
 down_write+0xb2/0x150 kernel/locking/rwsem.c:1532
 __down_write kernel/locking/rwsem.c:1389 [inline]
 down_write+0x137/0x150 kernel/locking/rwsem.c:1532
 __down_timeout+0x2d0/0x2d0
 pcpu_alloc+0x128/0x13b0 mm/percpu.c:1740
 register_netdevice_notifier+0x1e/0x270 net/core/dev.c:1729
 raw_init+0x296/0x340 net/can/raw.c:339
 raw_sock_no_ioctlcmd+0x10/0x10 net/can/raw.c:843
 can_create+0x27c/0x500 net/can/af_can.c:168
 __sock_create+0x3cb/0x730 net/socket.c:1433
 sock_create net/socket.c:1484 [inline]
 __sys_socket+0xef/0x200 net/socket.c:1526
 move_addr_to_kernel+0x70/0x70 net/socket.c:195
 __do_sys_clock_gettime kernel/time/posix-timers.c:1094 [inline]
 __se_sys_clock_gettime kernel/time/posix-timers.c:1082 [inline]
 __x64_sys_clock_gettime+0x165/0x240 kernel/time/posix-timers.c:1082
 __ia32_sys_clock_settime+0x260/0x260 kernel/time/posix-timers.c:1410
 trace_hardirqs_off_caller+0x55/0x230 kernel/trace/trace_preemptirq.c:73
 __do_sys_socket net/socket.c:1535 [inline]
 __se_sys_socket net/socket.c:1533 [inline]
 __x64_sys_socket+0x6f/0xb0 net/socket.c:1533
 __trace_hardirqs_on_caller kernel/locking/lockdep.c:3657 [inline]
 lockdep_hardirqs_on+0x463/0x620 kernel/locking/lockdep.c:3702
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
INFO: task syz-executor.1:28577 blocked for more than 143 seconds.
      Not tainted 5.7.0-rc6-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor.1  D28392 28577   7206 0x00000004
Call Trace:
 context_switch kernel/sched/core.c:3367 [inline]
 __schedule+0x937/0x1ff0 kernel/sched/core.c:4083
 rwsem_down_write_slowpath+0x90a/0xf90 kernel/locking/rwsem.c:1216
 __sched_text_start+0x8/0x8
 schedule+0xd0/0x2a0 kernel/sched/core.c:4158
 rwsem_down_write_slowpath+0x706/0xf90 kernel/locking/rwsem.c:1235
 pcpu_alloc+0xfed/0x13b0 mm/percpu.c:1703
 rwsem_mark_wake+0x8d0/0x8d0 include/linux/compiler.h:199
 lock_acquire+0x1f2/0x8f0 kernel/locking/lockdep.c:4934
 register_netdevice_notifier+0x1e/0x270 net/core/dev.c:1729
 lock_release+0x800/0x800 kernel/locking/lockdep.c:4689
 __down_write kernel/locking/rwsem.c:1389 [inline]
 down_write+0x137/0x150 kernel/locking/rwsem.c:1532
 atomic64_try_cmpxchg include/asm-generic/atomic-instrumented.h:1504 [inline]
 atomic_long_try_cmpxchg_acquire include/asm-generic/atomic-long.h:442 [inline]
 __down_write kernel/locking/rwsem.c:1387 [inline]
 down_write+0xb2/0x150 kernel/locking/rwsem.c:1532
 __down_write kernel/locking/rwsem.c:1389 [inline]
 down_write+0x137/0x150 kernel/locking/rwsem.c:1532
 __down_timeout+0x2d0/0x2d0
 pcpu_alloc+0x128/0x13b0 mm/percpu.c:1740
 register_netdevice_notifier+0x1e/0x270 net/core/dev.c:1729
 raw_init+0x296/0x340 net/can/raw.c:339
 raw_sock_no_ioctlcmd+0x10/0x10 net/can/raw.c:843
 can_create+0x27c/0x500 net/can/af_can.c:168
 __sock_create+0x3cb/0x730 net/socket.c:1433
 sock_create net/socket.c:1484 [inline]
 __sys_socket+0xef/0x200 net/socket.c:1526
 move_addr_to_kernel+0x70/0x70 net/socket.c:195
 __do_sys_clock_gettime kernel/time/posix-timers.c:1094 [inline]
 __se_sys_clock_gettime kernel/time/posix-timers.c:1082 [inline]
 __x64_sys_clock_gettime+0x165/0x240 kernel/time/posix-timers.c:1082
 __ia32_sys_clock_settime+0x260/0x260 kernel/time/posix-timers.c:1410
 trace_hardirqs_off_caller+0x55/0x230 kernel/trace/trace_preemptirq.c:73
 __do_sys_socket net/socket.c:1535 [inline]
 __se_sys_socket net/socket.c:1533 [inline]
 __x64_sys_socket+0x6f/0xb0 net/socket.c:1533
 __trace_hardirqs_on_caller kernel/locking/lockdep.c:3657 [inline]
 lockdep_hardirqs_on+0x463/0x620 kernel/locking/lockdep.c:3702
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3

Showing all locks held in the system:
3 locks held by kworker/u4:0/7:
 #0: ffff8880ae637998 (&rq->lock){-.-.}-{2:2}, at: newidle_balance+0x9be/0xdb0 kernel/sched/fair.c:10512
 #1: ffffffff899bea80 (rcu_read_lock){....}-{1:2}, at: __update_idle_core+0x42/0x3e0 kernel/sched/fair.c:5969
 #2: ffff8880ae627598 (&base->lock){-.-.}-{2:2}, at: lock_timer_base+0x55/0x1a0 kernel/time/timer.c:936
1 lock held by khungtaskd/1131:
 #0: ffffffff899bea80 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:5754
1 lock held by in:imklog/6746:
 #0: ffff8880a68f8bb0 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0xe9/0x100 fs/file.c:826
2 locks held by agetty/6968:
 #0: ffff88809fe6f098 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x22/0x80 drivers/tty/tty_ldisc.c:267
 #1: ffffc90000fb42e8 (&ldata->atomic_read_lock){+.+.}-{3:3}, at: n_tty_read+0x220/0x1b30 drivers/tty/n_tty.c:2156
3 locks held by kworker/u4:1/3824:
 #0: ffff8880a9771938 ((wq_completion)netns){+.+.}-{0:0}, at: __write_once_size include/linux/compiler.h:226 [inline]
 #0: ffff8880a9771938 ((wq_completion)netns){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff8880a9771938 ((wq_completion)netns){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:855 [inline]
 #0: ffff8880a9771938 ((wq_completion)netns){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:40 [inline]
 #0: ffff8880a9771938 ((wq_completion)netns){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:615 [inline]
 #0: ffff8880a9771938 ((wq_completion)netns){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:642 [inline]
 #0: ffff8880a9771938 ((wq_completion)netns){+.+.}-{0:0}, at: process_one_work+0x844/0x16a0 kernel/workqueue.c:2239
 #1: ffffc90007defdc0 (net_cleanup_work){+.+.}-{0:0}, at: process_one_work+0x878/0x16a0 kernel/workqueue.c:2243
 #2: ffffffff8a57aaf0 (pernet_ops_rwsem){++++}-{3:3}, at: cleanup_net+0x9b/0xa50 net/core/net_namespace.c:565
1 lock held by syz-executor.1/28515:
 #0: ffffffff8a57aaf0 (pernet_ops_rwsem){++++}-{3:3}, at: register_netdevice_notifier+0x1e/0x270 net/core/dev.c:1729
1 lock held by syz-executor.1/28577:
 #0: ffffffff8a57aaf0 (pernet_ops_rwsem){++++}-{3:3}, at: register_netdevice_notifier+0x1e/0x270 net/core/dev.c:1729

=============================================

NMI backtrace for cpu 1
CPU: 1 PID: 1131 Comm: khungtaskd Not tainted 5.7.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 nmi_cpu_backtrace.cold+0x70/0xb1 lib/nmi_backtrace.c:101
 lapic_can_unplug_cpu.cold+0x3b/0x3b
 nmi_trigger_cpumask_backtrace+0x231/0x27e lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:205 [inline]
 watchdog+0xa8c/0x1010 kernel/hung_task.c:289
 reset_hung_task_detector+0x30/0x30 kernel/hung_task.c:243
 kthread+0x388/0x470 kernel/kthread.c:268
 kthread_mod_delayed_work+0x1a0/0x1a0 kernel/kthread.c:1090
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:351
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 PID: 4128 Comm: systemd-journal Not tainted 5.7.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__debug_check_no_obj_freed lib/debugobjects.c:958 [inline]
RIP: 0010:debug_check_no_obj_freed+0x107/0x449 lib/debugobjects.c:998
Code: 10 4c 8b 38 4d 85 ff 0f 84 26 02 00 00 31 ed 4c 89 f8 48 c1 e8 03 80 3c 18 00 0f 85 2d 02 00 00 49 8d 7f 18 83 c5 01 4d 8b 27 <48> 89 f8 48 c1 e8 03 80 3c 18 00 0f 85 29 02 00 00 4d 8b 77 18 4c
RSP: 0018:ffffc90001677bf0 EFLAGS: 00000006
RAX: 1ffff1101225c9ab RBX: dffffc0000000000 RCX: ffffffff815a8709
RDX: 1ffffffff19128ff RSI: 0000000000000082 RDI: ffff8880912e4d70
RBP: 0000000000000005 R08: 0000000000000004 R09: fffff520002cef6d
R10: 0000000000000003 R11: fffff520002cef6c R12: ffff888050a8bbd0
R13: ffffffff8c8947e8 R14: ffff88820550e8e8 R15: ffff8880912e4d58
FS:  00007f9721f0e8c0(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f971f87e000 CR3: 0000000093734000 CR4: 00000000001426f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 kmem_cache_free+0x185/0x320 mm/slab.c:3693
 putname+0xe1/0x120 fs/namei.c:259
 filename_lookup+0x282/0x3e0 fs/namei.c:2362
 nd_jump_link+0x360/0x360 fs/namei.c:895
 __phys_addr_symbol+0x2c/0x70 arch/x86/mm/physaddr.c:42
 overlaps mm/usercopy.c:110 [inline]
 check_kernel_text_object mm/usercopy.c:142 [inline]
 __check_object_size mm/usercopy.c:289 [inline]
 __check_object_size+0x171/0x437 mm/usercopy.c:256
 audit_getname include/linux/audit.h:328 [inline]
 getname_flags fs/namei.c:202 [inline]
 getname_flags+0x275/0x5b0 fs/namei.c:128
 security_prepare_creds+0xee/0x180 security/security.c:1604
 user_path_at include/linux/namei.h:59 [inline]
 do_faccessat+0x248/0x7a0 fs/open.c:398
 __ia32_sys_fallocate+0xf0/0xf0 fs/open.c:338
 trace_hardirqs_off_caller+0x55/0x230 kernel/trace/trace_preemptirq.c:73
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x7f97211ca9c7
Code: 83 c4 08 48 3d 01 f0 ff ff 73 01 c3 48 8b 0d c8 d4 2b 00 f7 d8 64 89 01 48 83 c8 ff c3 66 0f 1f 44 00 00 b8 15 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d a1 d4 2b 00 f7 d8 64 89 01 48
RSP: 002b:00007ffe13203578 EFLAGS: 00000246 ORIG_RAX: 0000000000000015
RAX: ffffffffffffffda RBX: 00007ffe13206490 RCX: 00007f97211ca9c7
RDX: 00007f9721c3ba00 RSI: 0000000000000000 RDI: 000056391a37a9a3
RBP: 00007ffe132035b0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000069 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007ffe13206490 R15: 00007ffe13203aa0


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
