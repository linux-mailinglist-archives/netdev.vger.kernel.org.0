Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 460B2366AE0
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 14:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239137AbhDUMf7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 08:35:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233955AbhDUMf5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 08:35:57 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 199A4C06174A
        for <netdev@vger.kernel.org>; Wed, 21 Apr 2021 05:35:24 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id u20so10407866qku.10
        for <netdev@vger.kernel.org>; Wed, 21 Apr 2021 05:35:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7skoCjh+GNo98sMmLy9ND2KA1FJkDm0GjjjjQqpSky0=;
        b=A0z5QptlexnwZXuyGk12RwwjoEM5Q9F5HsHmrb047/RhXQHmHmXM5+STRuFnLpsOtz
         I7GnqqLRiQFB3Fc7aBKzuhWW5PGxPtgRG8m37RKvfjUxR9UzIkmC+WCzeaCMOFSyutZf
         A69egtj9x/vBn9VtbMM5iRdbsVrQuj+gH+PoPU4S9mxkJwozYKBsxjgsndsO4hGNB15V
         B+MnqV6yGicS8LvWY9xx5XBrVVBzyJga9mvuKsY/OO3eAJpP6mQ0iQa9UVRsDwPSkzQw
         mAEUDRNSXuYFwo07a1DQsTgDg3jtBh528JTSjrq/hqLnOLgOmdg1NeCJVnoBE0c2hYCU
         7QYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7skoCjh+GNo98sMmLy9ND2KA1FJkDm0GjjjjQqpSky0=;
        b=FlC0UunCv6ukpSb94ou488nia+NlD0gW1FVE3Zn7rRsGYpcf3+6CzbK6ySUDxR9dgC
         ZhlmMAHmHQanKAog3NE5lBX4aqWNeNht4u6C9WoEVRNUxCGj8KRMs6mj8t5AhIH1/T2d
         aGVDf0bsoNXfJ8eE8bDid+rgt2mB/AxU//q1vthG1S2u+GKP3XrjSdu9D6xnmDJYfqsi
         jaytpGIONYK1hNvn6p/nLhvT2YaKbc46mfrPyUEhDcJj4nXc/pN5tDKzP9i8XCruEOyQ
         7TE9OcoHAG+zHUGtkudP9AgjceT8q0SvY0qXrn1KFVyo2NnE5Jtium8QH9NVg9AWSBfA
         3lpA==
X-Gm-Message-State: AOAM533pJ+7rYPpx91pCRH1W3OjlHDOkPazLQSMMCLr1fjy1eGZAJubE
        J+DbINw2ALbC5dQhq0SO14ai+OBt640EpJZvr2NWdA==
X-Google-Smtp-Source: ABdhPJweBWRA2kyBxdxDbMMEYKIVmKWi7SSdZgp7eDqMXyBV1qOjWEqNwH5vKnlBA9+zXJd34u+gAbWQqC5DJBvJjss=
X-Received: by 2002:a37:4042:: with SMTP id n63mr22034231qka.501.1619008522793;
 Wed, 21 Apr 2021 05:35:22 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000057102e058e722bba@google.com> <000000000000dfe1bc05c063d0fa@google.com>
 <YH/wggx86Ph1bwPi@hirez.programming.kicks-ass.net> <CACT4Y+YnWXtoDTNL6E3=wTZWKvDhu7jp-frXrGUgvJ5YorBUKw@mail.gmail.com>
In-Reply-To: <CACT4Y+YnWXtoDTNL6E3=wTZWKvDhu7jp-frXrGUgvJ5YorBUKw@mail.gmail.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Wed, 21 Apr 2021 14:35:11 +0200
Message-ID: <CACT4Y+aHkwuRN9by2Hiw3jAuEZnukkdCt7W4GuuRyK2poRE=-g@mail.gmail.com>
Subject: Re: [syzbot] INFO: task hung in perf_event_free_task
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     syzbot <syzbot+7692cea7450c97fa2a0a@syzkaller.appspotmail.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        andrii@kernel.org, Alexei Starovoitov <ast@kernel.org>,
        bpf <bpf@vger.kernel.org>, cobranza@ingcoecuador.com,
        Daniel Borkmann <daniel@iogearbox.net>,
        Stephane Eranian <eranian@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Martin KaFai Lau <kafai@fb.com>,
        kpsingh@kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 21, 2021 at 2:26 PM Dmitry Vyukov <dvyukov@google.com> wrote:
>
> On Wed, Apr 21, 2021 at 11:30 AM Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > On Tue, Apr 20, 2021 at 02:10:22AM -0700, syzbot wrote:
> > > syzbot has found a reproducer for the following issue on:
> > >
> > > HEAD commit:    7af08140 Revert "gcov: clang: fix clang-11+ build"
> > > git tree:       upstream
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=15416871d00000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=c0a6882014fd3d45
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=7692cea7450c97fa2a0a
> > > compiler:       Debian clang version 11.0.1-2
> > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=145c9ffed00000
> > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12de31ded00000
> >
> > When I build that C file and run it, it completes. AFAICT that's not the
> > expected outcome given we're looking for a hung-task scenario. Hmm?
>
>
> I just reproduced it on some similar kernel I had. Maybe you used a
> different config. Or maybe it requires a similar qemu machine.
> However, the reproducer looks like a fork bomb and it produced
> thousands of subprocesses and took some time.
> In the past 2 years it's been happening all reproducers look similar
> and involve clone and perf_event_open.
>
>
>
> INFO: task a.out:13194 blocked for more than 143 seconds.
>       Not tainted 5.12.0-rc5-next-20210330 #113
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> task:a.out           state:D stack:28616 pid:13194 ppid: 23696 flags:0x00004004
> Call Trace:
>  context_switch kernel/sched/core.c:4329 [inline]
>  __schedule+0x911/0x2160 kernel/sched/core.c:5079
>  schedule+0xcf/0x270 kernel/sched/core.c:5158
>  perf_event_free_task+0x519/0x6c0 kernel/events/core.c:12627
>  copy_process+0x4a1e/0x70b0 kernel/fork.c:2377
>  kernel_clone+0xe7/0xab0 kernel/fork.c:2501
>  __do_sys_clone+0xc8/0x110 kernel/fork.c:2618
>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x451e49
> RSP: 002b:00007fa8e0d66118 EFLAGS: 00000246 ORIG_RAX: 0000000000000038
> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 0000000000451e49
> RDX: 9999999999999999 RSI: 0000000000000000 RDI: 0000000022086605
> RBP: 00007fa8e0d66200 R08: ffffffffffffffff R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffc688a6c7e
> R13: 00007ffc688a6c7f R14: 00007fa8e0d66300 R15: 0000000000022000
>
> Showing all locks held in the system:
> 3 locks held by kworker/u8:1/35:
>  #0: ffff888010782938 ((wq_completion)netns){+.+.}-{0:0}, at:
> arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
>  #0: ffff888010782938 ((wq_completion)netns){+.+.}-{0:0}, at:
> atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
>  #0: ffff888010782938 ((wq_completion)netns){+.+.}-{0:0}, at:
> atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
>  #0: ffff888010782938 ((wq_completion)netns){+.+.}-{0:0}, at:
> set_work_data kernel/workqueue.c:616 [inline]
>  #0: ffff888010782938 ((wq_completion)netns){+.+.}-{0:0}, at:
> set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
>  #0: ffff888010782938 ((wq_completion)netns){+.+.}-{0:0}, at:
> process_one_work+0x871/0x1600 kernel/workqueue.c:2246
>  #1: ffffc90000597da8 (net_cleanup_work){+.+.}-{0:0}, at:
> process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
>  #2: ffffffff8ce94f50 (pernet_ops_rwsem){++++}-{3:3}, at:
> cleanup_net+0x9b/0xb10 net/core/net_namespace.c:557
> 3 locks held by kworker/u8:3/269:
> 1 lock held by khungtaskd/1654:
>  #0: ffffffff8b7773a0 (rcu_read_lock){....}-{1:2}, at:
> debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:6333
> 1 lock held by rsyslogd/8425:
>  #0: ffff88801433edf0 (&f->f_pos_lock){+.+.}-{3:3}, at:
> __fdget_pos+0xe9/0x100 fs/file.c:967
> 2 locks held by getty/8519:
>  #0: ffff888020a09098 (&tty->ldisc_sem){++++}-{0:0}, at:
> tty_ldisc_ref_wait+0x22/0x80 drivers/tty/tty_ldisc.c:266
>  #1: ffffc9000115b2e8 (&ldata->atomic_read_lock){+.+.}-{3:3}, at:
> n_tty_read+0xd5b/0x12f0 drivers/tty/n_tty.c:2178
> 2 locks held by getty/8520:
>  #0: ffff888025793098 (&tty->ldisc_sem){++++}-{0:0}, at:
> tty_ldisc_ref_wait+0x22/0x80 drivers/tty/tty_ldisc.c:266
>  #1: ffffc9000113b2e8 (&ldata->atomic_read_lock){+.+.}-{3:3}, at:
> n_tty_read+0xd5b/0x12f0 drivers/tty/n_tty.c:2178
> 2 locks held by getty/8521:
>  #0: ffff8880194b5098 (&tty->ldisc_sem){++++}-{0:0}, at:
> tty_ldisc_ref_wait+0x22/0x80 drivers/tty/tty_ldisc.c:266
>  #1: ffffc900011ab2e8 (&ldata->atomic_read_lock){+.+.}-{3:3}, at:
> n_tty_read+0xd5b/0x12f0 drivers/tty/n_tty.c:2178
> 2 locks held by getty/8522:
>  #0: ffff888020a0f098 (&tty->ldisc_sem){++++}-{0:0}, at:
> tty_ldisc_ref_wait+0x22/0x80 drivers/tty/tty_ldisc.c:266
>  #1: ffffc900011db2e8 (&ldata->atomic_read_lock){+.+.}-{3:3}, at:
> n_tty_read+0xd5b/0x12f0 drivers/tty/n_tty.c:2178
> 2 locks held by getty/8523:
>  #0: ffff888019293098 (&tty->ldisc_sem){++++}-{0:0}, at:
> tty_ldisc_ref_wait+0x22/0x80 drivers/tty/tty_ldisc.c:266
>  #1: ffffc900011bb2e8 (&ldata->atomic_read_lock){+.+.}-{3:3}, at:
> n_tty_read+0xd5b/0x12f0 drivers/tty/n_tty.c:2178
> 2 locks held by getty/8524:
>  #0: ffff888019296098 (&tty->ldisc_sem){++++}-{0:0}, at:
> tty_ldisc_ref_wait+0x22/0x80 drivers/tty/tty_ldisc.c:266
>  #1: ffffc900011cb2e8 (&ldata->atomic_read_lock){+.+.}-{3:3}, at:
> n_tty_read+0xd5b/0x12f0 drivers/tty/n_tty.c:2178
> 2 locks held by kworker/0:5/8616:
>  #0: ffff88800fc64d38 ((wq_completion)events){+.+.}-{0:0}, at:
> arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
>  #0: ffff88800fc64d38 ((wq_completion)events){+.+.}-{0:0}, at:
> atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
>  #0: ffff88800fc64d38 ((wq_completion)events){+.+.}-{0:0}, at:
> atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
>  #0: ffff88800fc64d38 ((wq_completion)events){+.+.}-{0:0}, at:
> set_work_data kernel/workqueue.c:616 [inline]
>  #0: ffff88800fc64d38 ((wq_completion)events){+.+.}-{0:0}, at:
> set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
>  #0: ffff88800fc64d38 ((wq_completion)events){+.+.}-{0:0}, at:
> process_one_work+0x871/0x1600 kernel/workqueue.c:2246
>  #1: ffffc90001d77da8 ((kfence_timer).work){+.+.}-{0:0}, at:
> process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
> 2 locks held by bash/13876:
>  #0: ffff88804e222098 (&tty->ldisc_sem){++++}-{0:0}, at:
> tty_ldisc_ref_wait+0x22/0x80 drivers/tty/tty_ldisc.c:266
>  #1: ffffc9000be332e8 (&ldata->atomic_read_lock){+.+.}-{3:3}, at:
> n_tty_read+0xd5b/0x12f0 drivers/tty/n_tty.c:2178
>
> =============================================
>
> NMI backtrace for cpu 3
> CPU: 3 PID: 1654 Comm: khungtaskd Not tainted 5.12.0-rc5-next-20210330 #113
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
> rel-1.13.0-44-g88ab0c15525c-prebuilt.qemu.org 04/01/2014
> Call Trace:
>  __dump_stack lib/dump_stack.c:79 [inline]
>  dump_stack+0x141/0x1d7 lib/dump_stack.c:120
>  nmi_cpu_backtrace.cold+0x44/0xd7 lib/nmi_backtrace.c:105
>  nmi_trigger_cpumask_backtrace+0x1b3/0x230 lib/nmi_backtrace.c:62
>  trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
>  check_hung_uninterruptible_tasks kernel/hung_task.c:253 [inline]
>  watchdog+0xd8e/0xf40 kernel/hung_task.c:338
>  kthread+0x3b1/0x4a0 kernel/kthread.c:292
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
> Sending NMI from CPU 3 to CPUs 0-2:
> NMI backtrace for cpu 2 skipped: idling at native_safe_halt
> arch/x86/include/asm/irqflags.h:51 [inline]
> NMI backtrace for cpu 2 skipped: idling at arch_safe_halt
> arch/x86/include/asm/irqflags.h:89 [inline]
> NMI backtrace for cpu 2 skipped: idling at default_idle+0xe/0x10
> arch/x86/kernel/process.c:683
> NMI backtrace for cpu 0 skipped: idling at native_safe_halt
> arch/x86/include/asm/irqflags.h:51 [inline]
> NMI backtrace for cpu 0 skipped: idling at arch_safe_halt
> arch/x86/include/asm/irqflags.h:89 [inline]
> NMI backtrace for cpu 0 skipped: idling at default_idle+0xe/0x10
> arch/x86/kernel/process.c:683
> NMI backtrace for cpu 1 skipped: idling at native_safe_halt
> arch/x86/include/asm/irqflags.h:51 [inline]
> NMI backtrace for cpu 1 skipped: idling at arch_safe_halt
> arch/x86/include/asm/irqflags.h:89 [inline]
> NMI backtrace for cpu 1 skipped: idling at default_idle+0xe/0x10
> arch/x86/kernel/process.c:683




Interestingly this reproduced with the simpler syzkaller reproducer in
~30 seconds and w/o creating fork bomb (at least I looked at the
number of processes initially and it did not jump to thousands). So
maybe the fork bomb is just a red herring.

cat /tmp/prog
perf_event_open(&(0x7f0000940000)={0x2, 0x70, 0xee6a, 0x0, 0x0, 0x0,
0x0, 0x0, 0x0, 0x0, 0x0, 0x5, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, @perf_config_ext}, 0x0, 0x0,
0xffffffffffffffff, 0x0)
clone(0x2102001ffe, 0x0, 0xfffffffffffffffe, 0x0, 0xffffffffffffffff)
ioctl$PERF_EVENT_IOC_RESET(0xffffffffffffffff, 0x2403, 0x0)

./syz-execprog -repeat=0 -procs=4 prog

2021/04/21 12:19:31 executed programs: 2986
2021/04/21 12:19:36 executed programs: 3667
2021/04/21 12:19:41 executed programs: 4323
[  254.362146][ T3344] ieee802154 phy0 wpan0: encryption failed: -22
[  254.363064][ T3344] ieee802154 phy1 wpan1: encryption failed: -22
2021/04/21 12:19:46 executed programs: 4984
2021/04/21 12:19:51 executed programs: 5649
[  315.807468][ T3344] ieee802154 phy0 wpan0: encryption failed: -22
[  315.809063][ T3344] ieee802154 phy1 wpan1: encryption failed: -22
[  328.121848][   T25] Bluetooth: hci4: command 0x0406 tx timeout
[  328.121849][ T8706] Bluetooth: hci1: command 0x0406 tx timeout
[  328.121931][ T8706] Bluetooth: hci3: command 0x0406 tx timeout
[  328.123555][   T25] Bluetooth: hci2: command 0x0406 tx timeout
[  328.128087][   T25] Bluetooth: hci5: command 0x0406 tx timeout
[  338.371924][ T2997] Bluetooth: hci0: command 0x0406 tx timeout
[  339.471747][ T1294] unregister_netdevice: waiting for ip6gre0 to
become free. Usage count = 2

Message from syslogd@syzkaller at Apr 21 12:21:10 ...
 kernel:[  339.471747][ T1294] unregister_netdevice: waiting for
ip6gre0 to become free. Usage count = 2
[  377.242537][ T3344] ieee802154 phy0 wpan0: encryption failed: -22
[  377.243562][ T3344] ieee802154 phy1 wpan1: encryption failed: -22
[  406.042164][ T1651] INFO: task syz-executor:10479 can't die for
more than 143 seconds.
[  406.045360][ T1651] task:syz-executor    state:D stack:28904
pid:10479 ppid: 11138 flags:0x00004006
[  406.048146][ T1651] Call Trace:
[  406.049143][ T1651]  __schedule+0x911/0x2160
[  406.050531][ T1651]  ? io_schedule_timeout+0x140/0x140
[  406.053016][ T1651]  ? prepare_to_wait_event+0x129/0x7e0
[  406.053825][ T1651]  schedule+0xcf/0x270
[  406.054373][ T1651]  perf_event_free_task+0x519/0x6c0
[  406.055117][ T1651]  ? perf_event_exit_task+0xf10/0xf10
[  406.055890][ T1651]  ? init_wait_var_entry+0x200/0x200
[  406.056657][ T1651]  copy_process+0x4a1e/0x70b0
[  406.057320][ T1651]  ? mark_lock+0xef/0x17b0
[  406.057952][ T1651]  ? __cleanup_sighand+0xb0/0xb0
[  406.058658][ T1651]  ? do_futex+0x165/0x1780
[  406.059283][ T1651]  ? __lock_acquire+0x16a7/0x5230
[  406.060002][ T1651]  ? kernel_clone+0x314/0xab0
[  406.060663][ T1651]  kernel_clone+0xe7/0xab0
[  406.061289][ T1651]  ? create_io_thread+0xf0/0xf0
[  406.062930][ T1651]  ? lockdep_hardirqs_on_prepare+0x400/0x400
[  406.063908][ T1651]  ? __sanitizer_cov_trace_const_cmp4+0x1c/0x70
[  406.064806][ T1651]  ? find_held_lock+0x2d/0x110
[  406.065491][ T1651]  __do_sys_clone+0xc8/0x110
[  406.066154][ T1651]  ? kernel_clone+0xab0/0xab0
[  406.066828][ T1651]  ? __context_tracking_enter+0xef/0x100
[  406.067649][ T1651]  ? syscall_enter_from_user_mode+0x27/0x70
[  406.068493][ T1651]  do_syscall_64+0x2d/0x70
[  406.069125][ T1651]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  406.069980][ T1651] RIP: 0033:0x465f69
[  406.070545][ T1651] RSP: 002b:00007f6178513188 EFLAGS: 00000246
ORIG_RAX: 0000000000000038
[  406.073140][ T1651] RAX: ffffffffffffffda RBX: 000000000056bf60
RCX: 0000000000465f69
[  406.074357][ T1651] RDX: 9999999999999999 RSI: 0000000000000000
RDI: 0000002102001ffe
[  406.075488][ T1651] RBP: 00000000004bfa8f R08: ffffffffffffffff
R09: 0000000000000000
[  406.076597][ T1651] R10: 0000000000000000 R11: 0000000000000246
R12: 000000000056bf60
[  406.077706][ T1651] R13: 00007ffcf37755cf R14: 00007f6178513300
R15: 0000000000022000
[  406.078886][ T1651] INFO: task syz-executor:10479 blocked for more
than 143 seconds.
[  406.079983][ T1651]       Not tainted 5.12.0-rc5-next-20210330 #113
[  406.080880][ T1651] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  406.082994][ T1651] task:syz-executor    state:D stack:28904
pid:10479 ppid: 11138 flags:0x00004006
[  406.084212][ T1651] Call Trace:
[  406.084638][ T1651]  __schedule+0x911/0x2160
[  406.085191][ T1651]  ? io_schedule_timeout+0x140/0x140
[  406.085887][ T1651]  ? prepare_to_wait_event+0x129/0x7e0
[  406.086566][ T1651]  schedule+0xcf/0x270
[  406.087080][ T1651]  perf_event_free_task+0x519/0x6c0
[  406.087727][ T1651]  ? perf_event_exit_task+0xf10/0xf10
[  406.088387][ T1651]  ? init_wait_var_entry+0x200/0x200
[  406.089081][ T1651]  copy_process+0x4a1e/0x70b0
[  406.089659][ T1651]  ? mark_lock+0xef/0x17b0
[  406.090214][ T1651]  ? __cleanup_sighand+0xb0/0xb0
[  406.090836][ T1651]  ? do_futex+0x165/0x1780
[  406.091448][ T1651]  ? __lock_acquire+0x16a7/0x5230
[  406.092296][ T1651]  ? kernel_clone+0x314/0xab0
[  406.093006][ T1651]  kernel_clone+0xe7/0xab0
[  406.093688][ T1651]  ? create_io_thread+0xf0/0xf0
[  406.094357][ T1651]  ? lockdep_hardirqs_on_prepare+0x400/0x400
[  406.095348][ T1651]  ? __sanitizer_cov_trace_const_cmp4+0x1c/0x70
[  406.096633][ T1651]  ? find_held_lock+0x2d/0x110
[  406.097618][ T1651]  __do_sys_clone+0xc8/0x110
[  406.098563][ T1651]  ? kernel_clone+0xab0/0xab0
[  406.099531][ T1651]  ? __context_tracking_enter+0xef/0x100
[  406.100832][ T1651]  ? syscall_enter_from_user_mode+0x27/0x70
[  406.102608][ T1651]  do_syscall_64+0x2d/0x70
[  406.103320][ T1651]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  406.104220][ T1651] RIP: 0033:0x465f69
[  406.104758][ T1651] RSP: 002b:00007f6178513188 EFLAGS: 00000246
ORIG_RAX: 0000000000000038
[  406.105898][ T1651] RAX: ffffffffffffffda RBX: 000000000056bf60
RCX: 0000000000465f69
[  406.106978][ T1651] RDX: 9999999999999999 RSI: 0000000000000000
RDI: 0000002102001ffe
[  406.108023][ T1651] RBP: 00000000004bfa8f R08: ffffffffffffffff
R09: 0000000000000000
[  406.108973][ T1651] R10: 0000000000000000 R11: 0000000000000246
R12: 000000000056bf60
[  406.109924][ T1651] R13: 00007ffcf37755cf R14: 00007f6178513300
R15: 0000000000022000
[  406.110908][ T1651]
[  406.110908][ T1651] Showing all locks held in the system:
[  406.111863][ T1651] 2 locks held by kworker/u8:3/278:
[  406.112494][ T1651] 3 locks held by kworker/u8:5/1294:
[  406.113133][ T1651]  #0: ffff888010782938
((wq_completion)netns){+.+.}-{0:0}, at: process_one_work+0x871/0x1600
[  406.114459][ T1651]  #1: ffffc90004f17da8
(net_cleanup_work){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600
[  406.115681][ T1651]  #2: ffffffff8ce94f50
(pernet_ops_rwsem){++++}-{3:3}, at: cleanup_net+0x9b/0xb10
[  406.116838][ T1651] 1 lock held by khungtaskd/1651:
[  406.117488][ T1651]  #0: ffffffff8b7773a0
(rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260
[  406.118866][ T1651] 4 locks held by rs:main Q:Reg/8514:
[  406.119589][ T1651] 1 lock held by rsyslogd/8516:
[  406.120237][ T1651]  #0: ffff888019411770
(&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0xe9/0x100
[  406.121488][ T1651] 2 locks held by getty/8614:
[  406.122287][ T1651]  #0: ffff8880153e3098
(&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x22/0x80
[  406.123642][ T1651]  #1: ffffc90000f7f2e8
(&ldata->atomic_read_lock){+.+.}-{3:3}, at: n_tty_read+0xd5b/0x12f0
[  406.125102][ T1651] 2 locks held by getty/8615:
[  406.125734][ T1651]  #0: ffff888029bfd098
(&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x22/0x80
[  406.127074][ T1651]  #1: ffffc90000f872e8
(&ldata->atomic_read_lock){+.+.}-{3:3}, at: n_tty_read+0xd5b/0x12f0
[  406.128470][ T1651] 2 locks held by getty/8616:
[  406.129104][ T1651]  #0: ffff8880197b3098
(&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x22/0x80
[  406.130444][ T1651]  #1: ffffc90000fbb2e8
(&ldata->atomic_read_lock){+.+.}-{3:3}, at: n_tty_read+0xd5b/0x12f0
[  406.132580][ T1651] 2 locks held by getty/8617:
[  406.133214][ T1651]  #0: ffff888029bff098
(&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x22/0x80
[  406.134601][ T1651]  #1: ffffc90000f7b2e8
(&ldata->atomic_read_lock){+.+.}-{3:3}, at: n_tty_read+0xd5b/0x12f0
[  406.135977][ T1651] 2 locks held by getty/8618:
[  406.136626][ T1651]  #0: ffff88801438c098
(&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x22/0x80
[  406.137949][ T1651]  #1: ffffc90000feb2e8
(&ldata->atomic_read_lock){+.+.}-{3:3}, at: n_tty_read+0xd5b/0x12f0
[  406.139321][ T1651] 2 locks held by getty/8619:
[  406.139949][ T1651]  #0: ffff8880197b2098
(&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x22/0x80
[  406.141291][ T1651]  #1: ffffc90000ffb2e8
(&ldata->atomic_read_lock){+.+.}-{3:3}, at: n_tty_read+0xd5b/0x12f0
[  406.142713][ T1651] 2 locks held by bash/8632:
[  406.143342][ T1651]  #0: ffff888026ead098
(&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x22/0x80
[  406.144751][ T1651]  #1: ffffc9000102b2e8
(&ldata->atomic_read_lock){+.+.}-{3:3}, at: n_tty_read+0xd5b/0x12f0
[  406.146158][ T1651]
[  406.146476][ T1651] =============================================
[  406.146476][ T1651]
[  406.147615][ T1651] NMI backtrace for cpu 0
[  406.148204][ T1651] CPU: 0 PID: 1651 Comm: khungtaskd Not tainted
5.12.0-rc5-next-20210330 #113
[  406.149397][ T1651] Hardware name: QEMU Standard PC (Q35 + ICH9,
2009), BIOS rel-1.13.0-44-g88ab0c15525c-prebuilt.qemu.org 04/01/2014
[  406.151034][ T1651] Call Trace:
[  406.151479][ T1651]  dump_stack+0x141/0x1d7
[  406.152081][ T1651]  nmi_cpu_backtrace.cold+0x44/0xd7
[  406.152792][ T1651]  ? lapic_can_unplug_cpu+0x80/0x80
[  406.153500][ T1651]  nmi_trigger_cpumask_backtrace+0x1b3/0x230
[  406.154378][ T1651]  watchdog+0xd8e/0xf40
[  406.154957][ T1651]  ? trace_sched_process_hang+0x280/0x280
[  406.155763][ T1651]  kthread+0x3b1/0x4a0
[  406.156321][ T1651]  ? __kthread_bind_mask+0xc0/0xc0
[  406.157029][ T1651]  ret_from_fork+0x1f/0x30
[  406.157689][ T1651] Sending NMI from CPU 0 to CPUs 1-3:
[  406.158579][    C2] NMI backtrace for cpu 2 skipped: idling at
default_idle+0xe/0x10
[  406.158601][    C1] NMI backtrace for cpu 1 skipped: idling at
default_idle+0xe/0x10
[  406.159131][    C3] NMI backtrace for cpu 3
[  406.159144][    C3] CPU: 3 PID: 8514 Comm: rs:main Q:Reg Not
tainted 5.12.0-rc5-next-20210330 #113
[  406.159156][    C3] Hardware name: QEMU Standard PC (Q35 + ICH9,
2009), BIOS rel-1.13.0-44-g88ab0c15525c-prebuilt.qemu.org 04/01/2014
[  406.159169][    C3] RIP: 0010:__sanitizer_cov_trace_pc+0x7/0x60
[.159182]
0 00 4d CMeossdagee :fr omf sfy ffsl ogbd@9sy zkfalfle r ff fatf A prf
2f1  1b2:a2 2:08 0170 . ..0
 8b 03 48 k er0nefl: [ b 4d06 .1ca 459961 3]8[ bT1 6541]5 K 00 er4ne8l
 pa6ni3c  - cno9 e9t  sy6nc4in g:f hfun g_ff ftafsk : 0blfoc ke1d fta
40 sk0s0 65 8b 0
 8e 7e <89> c1 48 8b 34 24 81 e1 00 01 00 00 65 48 8b 14 25 00 f0 01 00 a9
[  406.159200][    C3] RSP: 0018:ffffc90001467848 EFLAGS: 00000246
[  406.159214][    C3] RAX: 0000000080000000 RBX: 000000000000000e
RCX: 0000000000000000
[  406.159225][    C3] RDX: 0000000000000000 RSI: ffff888012a8c700
RDI: 0000000000000003
[  406.159235][    C3] RBP: 0000000000000000 R08: 0000000000000000
R09: 0000000000000000
[  406.159244][    C3] R10: ffffffff8197f862 R11: 0000000000000000
R12: ffffea00008fc840
[  406.159255][    C3] R13: dffffc0000000000 R14: 0000000000000000
R15: ffffea00008fc840
[  406.159265][    C3] FS:  00007f98afbad700(0000)
GS:ffff88802d180000(0000) knlGS:0000000000000000
[  406.159275][    C3] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  406.159284][    C3] CR2: ffffffffff600400 CR3: 0000000014c6d000
CR4: 0000000000750ee0
[  406.159294][    C3] DR0: 0000000000000000 DR1: 0000000000000000
DR2: 0000000000000000
[  406.159304][    C3] DR3: 0000000000000000 DR6: 00000000fffe0ff0
DR7: 0000000000000400
[  406.159312][    C3] PKRU: 55555554
[  406.159317][    C3] Call Trace:
[  406.159322][    C3]  pagecache_get_page+0xa0c/0x18d0
[  406.159329][    C3]  ? add_to_page_cache_lru+0x5b0/0x5b0
[  406.159337][    C3]  grab_cache_page_write_begin+0x64/0x90
[  406.159344][    C3]  ext4_da_write_begin+0x35c/0x1160
[  406.159351][    C3]  ? ktime_get_coarse_real_ts64+0x1b7/0x200
[  406.159359][    C3]  ? __sanitizer_cov_trace_const_cmp8+0x1d/0x70
[  406.159366][    C3]  ? ext4_write_begin+0x14b0/0x14b0
[  406.159373][    C3]  ? copyout_mc+0x110/0x110
[  406.159380][    C3]  ? __sanitizer_cov_trace_const_cmp4+0x1c/0x70
[  406.159387][    C3]  ? current_time+0x220/0x2c0
[  406.159393][    C3]  generic_perform_write+0x20a/0x4f0
[  406.159400][    C3]  ? generic_file_readonly_mmap+0x1b0/0x1b0
[  406.159408][    C3]  ? down_write_killable+0x170/0x170
[  406.159415][    C3]  ext4_buffered_write_iter+0x244/0x4d0
[  406.159422][    C3]  ext4_file_write_iter+0x423/0x14e0
[  406.159429][    C3]  ? ext4_buffered_write_iter+0x4d0/0x4d0
[  406.159437][    C3]  ? lockdep_hardirqs_on_prepare+0x400/0x400
[  406.159444][    C3]  ? __sanitizer_cov_trace_const_cmp4+0x1c/0x70
[  406.159452][    C3]  new_sync_write+0x426/0x650
[  406.159458][    C3]  ? new_sync_read+0x6e0/0x6e0
[  406.159464][    C3]  ? lock_release+0x720/0x720
[  406.159470][    C3]  vfs_write+0x796/0xa30
[  406.159476][    C3]  ksys_write+0x12d/0x250
[  406.159482][    C3]  ? __ia32_sys_read+0xb0/0xb0
[  406.159489][    C3]  ? syscall_enter_from_user_mode+0x27/0x70
[  406.159496][    C3]  do_syscall_64+0x2d/0x70
[  406.159502][    C3]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  406.159509][    C3] RIP: 0033:0x7f98b160b19d
[  406.159521][    C3] Code: d1 20 00 00 75 10 b8 01 00 00 00 0f 05 48
3d 01 f0 ff ff 73 31 c3 48 83 ec 08 e8 be fa ff ff 48 89 04 24 b8 01
00 00 00 0f 05 <48> 8b 3c 241
[  406.159539][    C3] RSP: 002b:00007f98afbac000 EFLAGS: 00000293
ORIG_RAX: 0000000000000001
[  406.159555][    C3] RAX: ffffffffffffffda RBX: 0000000000000335
RCX: 00007f98b160b19d
[  406.159565][    C3] RDX: 0000000000000335 RSI: 0000000001385a90
RDI: 0000000000000005
[  406.159575][    C3] RBP: 0000000001385a90 R08: 0000000001385db5
R09: 00007f98b0f88547
[  406.159585][    C3] R10: 0000000000000000 R11: 0000000000000293
R12: 0000000000000000
[  406.159595][    C3] R13: 00007f98afbac480 R14: 0000000000000013
R15: 0000000001385870
[  406.159613][ T1651] Kernel panic - not syncing: hung_task: blocked tasks
[  406.211961][ T1651] CPU: 0 PID: 1651 Comm: khungtaskd Not tainted
5.12.0-rc5-next-20210330 #113
[  406.213144][ T1651] Hardware name: QEMU Standard PC (Q35 + ICH9,
2009), BIOS rel-1.13.0-44-g88ab0c15525c-prebuilt.qemu.org 04/01/2014
[  406.214758][ T1651] Call Trace:
[  406.215259][ T1651]  dump_stack+0x141/0x1d7
[  406.215844][ T1651]  panic+0x306/0x73d
[  406.216373][ T1651]  ? __warn_printk+0xf3/0xf3
[  406.216994][ T1651]  ? cpumask_next+0x3c/0x40
[  406.217603][ T1651]  ? __sanitizer_cov_trace_cmp4+0x1c/0x70
[  406.218370][ T1651]  ? printk_safe_flush+0xea/0x160
[  406.219056][ T1651]  ? watchdog.cold+0x22d/0x248
[  406.219704][ T1651]  watchdog.cold+0x23e/0x248
[  406.220345][ T1651]  ? trace_sched_process_hang+0x280/0x280
[  406.221121][ T1651]  kthread+0x3b1/0x4a0
[  406.221679][ T1651]  ? __kthread_bind_mask+0xc0/0xc0
[  406.222375][ T1651]  ret_from_fork+0x1f/0x30
[  406.224241][ T1651] Kernel Offset: disabled
[  406.224783][ T1651] Rebooting in 86400 seconds..
