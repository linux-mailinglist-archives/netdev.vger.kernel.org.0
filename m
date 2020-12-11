Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 040222D7FF6
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 21:26:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404264AbgLKUYu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 15:24:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392621AbgLKUY0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 15:24:26 -0500
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0315C0613D3;
        Fri, 11 Dec 2020 12:23:45 -0800 (PST)
Received: by mail-yb1-xb44.google.com with SMTP id r127so9166183yba.10;
        Fri, 11 Dec 2020 12:23:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HU5bcb4vboKKo5ZnupzWKljoLbJyTqU2QOH7sAK8KEs=;
        b=FwuyWyMB855nNdau7Gnd4oBNoX/XQ6dRrDgozztFSrPbdmeqmARyWiX6HBybTXiMNG
         PINZNh5mCZzXQCwtqyG0A4j7SXG0UzcE71Mxx17SGknQqKc9ibt4foeivwg5G8n2G+Sb
         Jy8V2dqrtQxInphspTqEGzHjGbKrZDF0UitoEZ52NTQbZkYt4gsj53PLUSZuzDE3C3/l
         GS0dU0/gaYrqIY1D7RZFOW+Sp0B5T5dlLA4iV4s4Ku6U+aJod11JDyKtltyd4OqMTDzI
         FoFJ2o01V/0x2orK6PSJn/D/z2R1PK7pxsCrd09GyPjDXzSQych6sXgrdAcXwPtaYAfN
         H/Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HU5bcb4vboKKo5ZnupzWKljoLbJyTqU2QOH7sAK8KEs=;
        b=YvmjRa9rSeD2x7XhX7YFsEn8Rzk+dTkdFqnCqWu3S7oFtJwo8loF5GY9g76WiaydPL
         NfZDCZnoAO18cr28Zan1bMzxFXBG6yy94TTibMXWM6ps8x86FoBWJXW6XbtUDzppydxo
         0+tsog6oODnkk+10K4NjibyUUnf67WAhnvH+OAROiz3/6vkiGx6nSdT/6aDU8fO+w+Oy
         GJ/cFBHtWxXyl9BSdPNmqAFEB1AifgVxe+2gfjTB5X7S3RvLlM+Nb5TKjjlnonUT2Ah1
         x8Km8ZQoDQJnpgJk2/tqVd+hChcqq/APCsF8tkdS6ZkXJXmqZaUeefodSdXLWTC5reN1
         8tqw==
X-Gm-Message-State: AOAM531STlv2BIcqB4CVNmEQl7DCl3NH0Mi05HF7m2Xv3Q03A+jR675x
        b9wuXsV+is35Vu0/5hN1e+jvl8p6ZtKIyLDqq8Q=
X-Google-Smtp-Source: ABdhPJwjhNTkcniZ46zkjO3Qw+3Nyz3dn9XCpP4BA3JU8h8EytRQjS4Q1uz4H8l0iPMyi/eKRnyDQsmYtIFTrk3q9pI=
X-Received: by 2002:a25:c7c6:: with SMTP id w189mr21229547ybe.403.1607718225131;
 Fri, 11 Dec 2020 12:23:45 -0800 (PST)
MIME-Version: 1.0
References: <20201211171138.63819-1-jonathan.lemon@gmail.com> <20201211171138.63819-2-jonathan.lemon@gmail.com>
In-Reply-To: <20201211171138.63819-2-jonathan.lemon@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 11 Dec 2020 12:23:34 -0800
Message-ID: <CAEf4BzYswHcuQNdqyOymB5MTFDKJy0xkG4+Yo_CpUGH4BVqjzg@mail.gmail.com>
Subject: Re: [PATCH 1/1 v3 bpf-next] bpf: increment and use correct thread iterator
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 11, 2020 at 10:56 AM Jonathan Lemon
<jonathan.lemon@gmail.com> wrote:
>
> From: Jonathan Lemon <bsd@fb.com>
>
> On some systems, some variant of the following splat is
> repeatedly seen.  The common factor in all traces seems
> to be the entry point to task_file_seq_next().  With the
> patch, all warnings go away.
>
>     rcu: INFO: rcu_sched self-detected stall on CPU
>     rcu: \x0926-....: (20992 ticks this GP) idle=d7e/1/0x4000000000000002 softirq=81556231/81556231 fqs=4876
>     \x09(t=21033 jiffies g=159148529 q=223125)
>     NMI backtrace for cpu 26
>     CPU: 26 PID: 2015853 Comm: bpftool Kdump: loaded Not tainted 5.6.13-0_fbk4_3876_gd8d1f9bf80bb #1
>     Hardware name: Quanta Twin Lakes MP/Twin Lakes Passive MP, BIOS F09_3A12 10/08/2018
>     Call Trace:
>      <IRQ>
>      dump_stack+0x50/0x70
>      nmi_cpu_backtrace.cold.6+0x13/0x50
>      ? lapic_can_unplug_cpu.cold.30+0x40/0x40
>      nmi_trigger_cpumask_backtrace+0xba/0xca
>      rcu_dump_cpu_stacks+0x99/0xc7
>      rcu_sched_clock_irq.cold.90+0x1b4/0x3aa
>      ? tick_sched_do_timer+0x60/0x60
>      update_process_times+0x24/0x50
>      tick_sched_timer+0x37/0x70
>      __hrtimer_run_queues+0xfe/0x270
>      hrtimer_interrupt+0xf4/0x210
>      smp_apic_timer_interrupt+0x5e/0x120
>      apic_timer_interrupt+0xf/0x20
>      </IRQ>
>     RIP: 0010:get_pid_task+0x38/0x80
>     Code: 89 f6 48 8d 44 f7 08 48 8b 00 48 85 c0 74 2b 48 83 c6 55 48 c1 e6 04 48 29 f0 74 19 48 8d 78 20 ba 01 00 00 00 f0 0f c1 50 20 <85> d2 74 27 78 11 83 c2 01 78 0c 48 83 c4 08 c3 31 c0 48 83 c4 08
>     RSP: 0018:ffffc9000d293dc8 EFLAGS: 00000202 ORIG_RAX: ffffffffffffff13
>     RAX: ffff888637c05600 RBX: ffffc9000d293e0c RCX: 0000000000000000
>     RDX: 0000000000000001 RSI: 0000000000000550 RDI: ffff888637c05620
>     RBP: ffffffff8284eb80 R08: ffff88831341d300 R09: ffff88822ffd8248
>     R10: ffff88822ffd82d0 R11: 00000000003a93c0 R12: 0000000000000001
>     R13: 00000000ffffffff R14: ffff88831341d300 R15: 0000000000000000
>      ? find_ge_pid+0x1b/0x20
>      task_seq_get_next+0x52/0xc0
>      task_file_seq_get_next+0x159/0x220
>      task_file_seq_next+0x4f/0xa0
>      bpf_seq_read+0x159/0x390
>      vfs_read+0x8a/0x140
>      ksys_read+0x59/0xd0
>      do_syscall_64+0x42/0x110
>      entry_SYSCALL_64_after_hwframe+0x44/0xa9
>     RIP: 0033:0x7f95ae73e76e
>     Code: Bad RIP value.
>     RSP: 002b:00007ffc02c1dbf8 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
>     RAX: ffffffffffffffda RBX: 000000000170faa0 RCX: 00007f95ae73e76e
>     RDX: 0000000000001000 RSI: 00007ffc02c1dc30 RDI: 0000000000000007
>     RBP: 00007ffc02c1ec70 R08: 0000000000000005 R09: 0000000000000006
>     R10: fffffffffffff20b R11: 0000000000000246 R12: 00000000019112a0
>     R13: 0000000000000000 R14: 0000000000000007 R15: 00000000004283c0
>
> The attached patch does 3 things:
>
> 1) If unable to obtain the file structure for the current task,
>    proceed to the next task number after the one returned from
>    task_seq_get_next(), instead of the next task number from the
>    original iterator.
>
> 2) Use thread_group_leader() instead of the open-coded comparision
>    of tgid vs pid.
>
> 3) Only obtain the task reference count at the end of the RCU section
>    instead of repeatedly obtaining/releasing it when iterathing though
>    a thread group.
>
> Fixes: a650da2ee52a ("bpf: Add task and task/file iterator targets")
> Fixes: 67b6b863e6ab ("bpf: Avoid iterating duplicated files for task_file iterator")
>
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> ---
>  kernel/bpf/task_iter.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/kernel/bpf/task_iter.c b/kernel/bpf/task_iter.c
> index 0458a40edf10..66a52fcf589a 100644
> --- a/kernel/bpf/task_iter.c
> +++ b/kernel/bpf/task_iter.c
> @@ -33,17 +33,17 @@ static struct task_struct *task_seq_get_next(struct pid_namespace *ns,
>         pid = find_ge_pid(*tid, ns);
>         if (pid) {
>                 *tid = pid_nr_ns(pid, ns);
> -               task = get_pid_task(pid, PIDTYPE_PID);
> +               task = pid_task(pid, PIDTYPE_PID);
>                 if (!task) {
>                         ++*tid;
>                         goto retry;
> -               } else if (skip_if_dup_files && task->tgid != task->pid &&
> +               } else if (skip_if_dup_files && !thread_group_leader(task) &&
>                            task->files == task->group_leader->files) {
> -                       put_task_struct(task);
>                         task = NULL;
>                         ++*tid;
>                         goto retry;
>                 }
> +               get_task_struct(task);
>         }

This part looks good. I'd say it deserves a separate patch, but it's minor.

>         rcu_read_unlock();
>
> @@ -164,7 +164,7 @@ task_file_seq_get_next(struct bpf_iter_seq_task_file_info *info)
>                 curr_files = get_files_struct(curr_task);
>                 if (!curr_files) {
>                         put_task_struct(curr_task);
> -                       curr_tid = ++(info->tid);
> +                       curr_tid = curr_tid + 1;

Yonghong might know definitively, but it seems like we need to update
info->tid here as well:

info->tid = curr_tid;

If the search eventually yields no task, then info->tid will stay at
some potentially much smaller value, and we'll keep re-searching tasks
from the same TID on each subsequent read (if user keeps reading the
file). So corner case, but good to have covered.

>                         info->fd = 0;
>                         goto again;
>                 }
> --
> 2.24.1
>
