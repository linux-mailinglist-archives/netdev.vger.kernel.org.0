Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F572366ABC
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 14:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239730AbhDUM1Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 08:27:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238971AbhDUM1P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 08:27:15 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3D80C06138B
        for <netdev@vger.kernel.org>; Wed, 21 Apr 2021 05:26:40 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id o21so2944535qtp.7
        for <netdev@vger.kernel.org>; Wed, 21 Apr 2021 05:26:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PfdUg8qCYc8gMXz26FZLYUj2ZZgGdRD3Vxnn3cJ18Mg=;
        b=TCFikcAU1fKwXmNOc3DUpmk0HxrFW8oOQW1rtm1jQT/c4Ug1VdKbjYRTAVcn8Qmtw2
         Nl1WYk7FbqQ8sDiCosbNJQOUO4jm7CKzlbHZWUwrNbFpALOJjIpA+382/GIxfaY+GuIZ
         df8HUd4ke/bQKOkl3cbC/SUXNKI9g7jcUeaBhwQSFMNitHWaBAwIdTBRWWEfwRfY0ban
         U5n+D2EIsHj3TL6LTBpVHzWBaJ5m4oFLeViJl7Qv4LAlFE8M39tn4OXK4sEKuok6d7CJ
         Y18RRYbpVAadfn1Ql8SnBD78P/D5ZUTqFXglyJfY8PJWrGS8uYp8HY86L8J6fiEsBJEU
         GJ0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PfdUg8qCYc8gMXz26FZLYUj2ZZgGdRD3Vxnn3cJ18Mg=;
        b=lKt23eCUBMniZpAmIluT874Dtg2oepRiJ+/W6qAdyLrQuia9wxQshNa+3Aptqr3YX/
         sZCmQsldrnJy9xLst9QcOy/LLGRzbC5fOn6uBo/5h5n9grAsOus9Y7t5mvUkYxjbtQPd
         N41wkKfEsUpi8huIs+g+MlDhHw8RdLlMaUnpNCvWmqXHU6Z11bH8Lp8HTGmRofsNfYZ9
         0sH5x/g3f+eaN+EwBdn3LrZMfzGYfUNzXlaiAFrwCodhRCtIox88OcYone+6VNIffRZE
         hljz+HO9R8zR5HdWzui7cs3TZM0YxZyWvIKdkB/6wsq0Ma8+dMhXEzwbt79gPxa18ulV
         elXg==
X-Gm-Message-State: AOAM532GtaMWaiQhq1Lqgbl7zNGVoPpDCa90WhfgYOkZxr3pRZCtDp0g
        NEqNdN1vBnReD8t8/GAUaus9EjVnCPVYPuzpzTvwUg==
X-Google-Smtp-Source: ABdhPJzKMfw3c8z2Bk0lm1xBbc0eCX4jiGr6K2CJqkalj3qV6FPnuQbXtVbVzcCk66rkIaAVNaUcDyrR54nlgxFvfiU=
X-Received: by 2002:ac8:110d:: with SMTP id c13mr21244783qtj.337.1619007999712;
 Wed, 21 Apr 2021 05:26:39 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000057102e058e722bba@google.com> <000000000000dfe1bc05c063d0fa@google.com>
 <YH/wggx86Ph1bwPi@hirez.programming.kicks-ass.net>
In-Reply-To: <YH/wggx86Ph1bwPi@hirez.programming.kicks-ass.net>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Wed, 21 Apr 2021 14:26:28 +0200
Message-ID: <CACT4Y+YnWXtoDTNL6E3=wTZWKvDhu7jp-frXrGUgvJ5YorBUKw@mail.gmail.com>
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

On Wed, Apr 21, 2021 at 11:30 AM Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Tue, Apr 20, 2021 at 02:10:22AM -0700, syzbot wrote:
> > syzbot has found a reproducer for the following issue on:
> >
> > HEAD commit:    7af08140 Revert "gcov: clang: fix clang-11+ build"
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=15416871d00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=c0a6882014fd3d45
> > dashboard link: https://syzkaller.appspot.com/bug?extid=7692cea7450c97fa2a0a
> > compiler:       Debian clang version 11.0.1-2
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=145c9ffed00000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12de31ded00000
>
> When I build that C file and run it, it completes. AFAICT that's not the
> expected outcome given we're looking for a hung-task scenario. Hmm?


I just reproduced it on some similar kernel I had. Maybe you used a
different config. Or maybe it requires a similar qemu machine.
However, the reproducer looks like a fork bomb and it produced
thousands of subprocesses and took some time.
In the past 2 years it's been happening all reproducers look similar
and involve clone and perf_event_open.



INFO: task a.out:13194 blocked for more than 143 seconds.
      Not tainted 5.12.0-rc5-next-20210330 #113
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:a.out           state:D stack:28616 pid:13194 ppid: 23696 flags:0x00004004
Call Trace:
 context_switch kernel/sched/core.c:4329 [inline]
 __schedule+0x911/0x2160 kernel/sched/core.c:5079
 schedule+0xcf/0x270 kernel/sched/core.c:5158
 perf_event_free_task+0x519/0x6c0 kernel/events/core.c:12627
 copy_process+0x4a1e/0x70b0 kernel/fork.c:2377
 kernel_clone+0xe7/0xab0 kernel/fork.c:2501
 __do_sys_clone+0xc8/0x110 kernel/fork.c:2618
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x451e49
RSP: 002b:00007fa8e0d66118 EFLAGS: 00000246 ORIG_RAX: 0000000000000038
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 0000000000451e49
RDX: 9999999999999999 RSI: 0000000000000000 RDI: 0000000022086605
RBP: 00007fa8e0d66200 R08: ffffffffffffffff R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffc688a6c7e
R13: 00007ffc688a6c7f R14: 00007fa8e0d66300 R15: 0000000000022000

Showing all locks held in the system:
3 locks held by kworker/u8:1/35:
 #0: ffff888010782938 ((wq_completion)netns){+.+.}-{0:0}, at:
arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888010782938 ((wq_completion)netns){+.+.}-{0:0}, at:
atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff888010782938 ((wq_completion)netns){+.+.}-{0:0}, at:
atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888010782938 ((wq_completion)netns){+.+.}-{0:0}, at:
set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff888010782938 ((wq_completion)netns){+.+.}-{0:0}, at:
set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff888010782938 ((wq_completion)netns){+.+.}-{0:0}, at:
process_one_work+0x871/0x1600 kernel/workqueue.c:2246
 #1: ffffc90000597da8 (net_cleanup_work){+.+.}-{0:0}, at:
process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
 #2: ffffffff8ce94f50 (pernet_ops_rwsem){++++}-{3:3}, at:
cleanup_net+0x9b/0xb10 net/core/net_namespace.c:557
3 locks held by kworker/u8:3/269:
1 lock held by khungtaskd/1654:
 #0: ffffffff8b7773a0 (rcu_read_lock){....}-{1:2}, at:
debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:6333
1 lock held by rsyslogd/8425:
 #0: ffff88801433edf0 (&f->f_pos_lock){+.+.}-{3:3}, at:
__fdget_pos+0xe9/0x100 fs/file.c:967
2 locks held by getty/8519:
 #0: ffff888020a09098 (&tty->ldisc_sem){++++}-{0:0}, at:
tty_ldisc_ref_wait+0x22/0x80 drivers/tty/tty_ldisc.c:266
 #1: ffffc9000115b2e8 (&ldata->atomic_read_lock){+.+.}-{3:3}, at:
n_tty_read+0xd5b/0x12f0 drivers/tty/n_tty.c:2178
2 locks held by getty/8520:
 #0: ffff888025793098 (&tty->ldisc_sem){++++}-{0:0}, at:
tty_ldisc_ref_wait+0x22/0x80 drivers/tty/tty_ldisc.c:266
 #1: ffffc9000113b2e8 (&ldata->atomic_read_lock){+.+.}-{3:3}, at:
n_tty_read+0xd5b/0x12f0 drivers/tty/n_tty.c:2178
2 locks held by getty/8521:
 #0: ffff8880194b5098 (&tty->ldisc_sem){++++}-{0:0}, at:
tty_ldisc_ref_wait+0x22/0x80 drivers/tty/tty_ldisc.c:266
 #1: ffffc900011ab2e8 (&ldata->atomic_read_lock){+.+.}-{3:3}, at:
n_tty_read+0xd5b/0x12f0 drivers/tty/n_tty.c:2178
2 locks held by getty/8522:
 #0: ffff888020a0f098 (&tty->ldisc_sem){++++}-{0:0}, at:
tty_ldisc_ref_wait+0x22/0x80 drivers/tty/tty_ldisc.c:266
 #1: ffffc900011db2e8 (&ldata->atomic_read_lock){+.+.}-{3:3}, at:
n_tty_read+0xd5b/0x12f0 drivers/tty/n_tty.c:2178
2 locks held by getty/8523:
 #0: ffff888019293098 (&tty->ldisc_sem){++++}-{0:0}, at:
tty_ldisc_ref_wait+0x22/0x80 drivers/tty/tty_ldisc.c:266
 #1: ffffc900011bb2e8 (&ldata->atomic_read_lock){+.+.}-{3:3}, at:
n_tty_read+0xd5b/0x12f0 drivers/tty/n_tty.c:2178
2 locks held by getty/8524:
 #0: ffff888019296098 (&tty->ldisc_sem){++++}-{0:0}, at:
tty_ldisc_ref_wait+0x22/0x80 drivers/tty/tty_ldisc.c:266
 #1: ffffc900011cb2e8 (&ldata->atomic_read_lock){+.+.}-{3:3}, at:
n_tty_read+0xd5b/0x12f0 drivers/tty/n_tty.c:2178
2 locks held by kworker/0:5/8616:
 #0: ffff88800fc64d38 ((wq_completion)events){+.+.}-{0:0}, at:
arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff88800fc64d38 ((wq_completion)events){+.+.}-{0:0}, at:
atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff88800fc64d38 ((wq_completion)events){+.+.}-{0:0}, at:
atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff88800fc64d38 ((wq_completion)events){+.+.}-{0:0}, at:
set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff88800fc64d38 ((wq_completion)events){+.+.}-{0:0}, at:
set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff88800fc64d38 ((wq_completion)events){+.+.}-{0:0}, at:
process_one_work+0x871/0x1600 kernel/workqueue.c:2246
 #1: ffffc90001d77da8 ((kfence_timer).work){+.+.}-{0:0}, at:
process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
2 locks held by bash/13876:
 #0: ffff88804e222098 (&tty->ldisc_sem){++++}-{0:0}, at:
tty_ldisc_ref_wait+0x22/0x80 drivers/tty/tty_ldisc.c:266
 #1: ffffc9000be332e8 (&ldata->atomic_read_lock){+.+.}-{3:3}, at:
n_tty_read+0xd5b/0x12f0 drivers/tty/n_tty.c:2178

=============================================

NMI backtrace for cpu 3
CPU: 3 PID: 1654 Comm: khungtaskd Not tainted 5.12.0-rc5-next-20210330 #113
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
rel-1.13.0-44-g88ab0c15525c-prebuilt.qemu.org 04/01/2014
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x141/0x1d7 lib/dump_stack.c:120
 nmi_cpu_backtrace.cold+0x44/0xd7 lib/nmi_backtrace.c:105
 nmi_trigger_cpumask_backtrace+0x1b3/0x230 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:253 [inline]
 watchdog+0xd8e/0xf40 kernel/hung_task.c:338
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
Sending NMI from CPU 3 to CPUs 0-2:
NMI backtrace for cpu 2 skipped: idling at native_safe_halt
arch/x86/include/asm/irqflags.h:51 [inline]
NMI backtrace for cpu 2 skipped: idling at arch_safe_halt
arch/x86/include/asm/irqflags.h:89 [inline]
NMI backtrace for cpu 2 skipped: idling at default_idle+0xe/0x10
arch/x86/kernel/process.c:683
NMI backtrace for cpu 0 skipped: idling at native_safe_halt
arch/x86/include/asm/irqflags.h:51 [inline]
NMI backtrace for cpu 0 skipped: idling at arch_safe_halt
arch/x86/include/asm/irqflags.h:89 [inline]
NMI backtrace for cpu 0 skipped: idling at default_idle+0xe/0x10
arch/x86/kernel/process.c:683
NMI backtrace for cpu 1 skipped: idling at native_safe_halt
arch/x86/include/asm/irqflags.h:51 [inline]
NMI backtrace for cpu 1 skipped: idling at arch_safe_halt
arch/x86/include/asm/irqflags.h:89 [inline]
NMI backtrace for cpu 1 skipped: idling at default_idle+0xe/0x10
arch/x86/kernel/process.c:683
