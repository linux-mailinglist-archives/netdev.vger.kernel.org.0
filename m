Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 167142DE9C4
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 20:29:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733198AbgLRT3C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 14:29:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728047AbgLRT3B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 14:29:01 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 463B3C0617A7;
        Fri, 18 Dec 2020 11:28:21 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id a16so2917016ybh.5;
        Fri, 18 Dec 2020 11:28:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wnpolTQE1naHbMkiLa2YAnTdWLIqwUiPErnB2DB2JVk=;
        b=tJokmAO6LVc+K5BaD9NcE3BESVQWw+mVPCMZ8VR9CJVXdS6MLpgfnUkW6ugvpWnz5R
         mymZlQImu0PQut9q4Sk4h91uKJ90Gl1dvsu5a+CpgMZ2bHnsm8UXAiNN4fBMMSN3/5Lr
         VaiuZIEjpVNu3bJytlmyjejncug6MkkTuhflD00/XCaB3OB+S5NesPpLPypG+yT/cgTm
         TZWLUv/0rvZxtKUJ+B3o1CsrpUHhqQpyNJ1wPVMhl+fK0vBLX9z1XYA4vUQozD87AFQl
         DrskADJxHml6s0E1k5TF+BaYGpWX0ZQEK2zD21L3wQg+LQ+YVqYgPNVmE5fwuBXq6yOl
         Qe5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wnpolTQE1naHbMkiLa2YAnTdWLIqwUiPErnB2DB2JVk=;
        b=YawwB9e+Am7OAY2iFH7y5yMbcRgW3Uf0h/s8+Dxpqu74G8aXZqj+p5A5oemWL4iL1V
         UmHFp148jMqCAtFZ/68C9gamblwRjuIw67pbHD+vrTSHJbueC/WkX30TrUiMpOIhSVhf
         VHg/7CQcR0Lv/IeXXGL6cOQjSvVrRoG46WPHA5l1AR47mJyXASWwyoL+iQd+8pDqJk2f
         PnaILsjHRbG3wqQRg3s1x3XsyYsNjPU9T592RBbynI5ChxEAFvDnxeBimS5VH062nl6c
         ICeNmA9uFmcgLqNbqVlNFXU8s/95L6K+hsWWLM3NuIpDa1tSx2Ri17wayEJVw4sPugbt
         yXdA==
X-Gm-Message-State: AOAM533pTxAnTt/VlMU6NWKsBhvOUuDmTKcqWEMEAkD9Dtyt7eFW4k5C
        Z9DwNL+te0Im5TWuY3+NDxblukOAIalYojYC5DAHAurvYd0=
X-Google-Smtp-Source: ABdhPJyZ23bRiU12zQOyXzsZH+yd8qibZe3Vzsvj0NMZ+K3XCMkwN/jt9veXThGG9UWLZl/r+sKLQ5N/81pGOg73zho=
X-Received: by 2002:a25:4107:: with SMTP id o7mr8041778yba.459.1608319700465;
 Fri, 18 Dec 2020 11:28:20 -0800 (PST)
MIME-Version: 1.0
References: <20201211171138.63819-1-jonathan.lemon@gmail.com>
 <20201211171138.63819-2-jonathan.lemon@gmail.com> <39fcac29-4c93-1c76-62ba-728618a25fe5@fb.com>
 <20201218180628.qz3qjb7y3sa4rbn3@bsd-mbp>
In-Reply-To: <20201218180628.qz3qjb7y3sa4rbn3@bsd-mbp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 18 Dec 2020 11:28:09 -0800
Message-ID: <CAEf4BzbnCucxBBZ2pcD8st1k4auf4kfvDGD4870oVoNtw4i0xA@mail.gmail.com>
Subject: Re: [PATCH 1/1 v3 bpf-next] bpf: increment and use correct thread iterator
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 18, 2020 at 10:08 AM Jonathan Lemon
<jonathan.lemon@gmail.com> wrote:
>
> On Fri, Dec 18, 2020 at 08:53:22AM -0800, Yonghong Song wrote:
> >
> >
> > On 12/11/20 9:11 AM, Jonathan Lemon wrote:
> > > From: Jonathan Lemon <bsd@fb.com>
> > >
> > > On some systems, some variant of the following splat is
> > > repeatedly seen.  The common factor in all traces seems
> > > to be the entry point to task_file_seq_next().  With the
> > > patch, all warnings go away.
> > >
> > >      rcu: INFO: rcu_sched self-detected stall on CPU
> > >      rcu: \x0926-....: (20992 ticks this GP) idle=d7e/1/0x4000000000000002 softirq=81556231/81556231 fqs=4876
> > >      \x09(t=21033 jiffies g=159148529 q=223125)
> > >      NMI backtrace for cpu 26
> > >      CPU: 26 PID: 2015853 Comm: bpftool Kdump: loaded Not tainted 5.6.13-0_fbk4_3876_gd8d1f9bf80bb #1
> > >      Hardware name: Quanta Twin Lakes MP/Twin Lakes Passive MP, BIOS F09_3A12 10/08/2018
> > >      Call Trace:
> > >       <IRQ>
> > >       dump_stack+0x50/0x70
> > >       nmi_cpu_backtrace.cold.6+0x13/0x50
> > >       ? lapic_can_unplug_cpu.cold.30+0x40/0x40
> > >       nmi_trigger_cpumask_backtrace+0xba/0xca
> > >       rcu_dump_cpu_stacks+0x99/0xc7
> > >       rcu_sched_clock_irq.cold.90+0x1b4/0x3aa
> > >       ? tick_sched_do_timer+0x60/0x60
> > >       update_process_times+0x24/0x50
> > >       tick_sched_timer+0x37/0x70
> > >       __hrtimer_run_queues+0xfe/0x270
> > >       hrtimer_interrupt+0xf4/0x210
> > >       smp_apic_timer_interrupt+0x5e/0x120
> > >       apic_timer_interrupt+0xf/0x20
> > >       </IRQ>
> > >      RIP: 0010:get_pid_task+0x38/0x80
> > >      Code: 89 f6 48 8d 44 f7 08 48 8b 00 48 85 c0 74 2b 48 83 c6 55 48 c1 e6 04 48 29 f0 74 19 48 8d 78 20 ba 01 00 00 00 f0 0f c1 50 20 <85> d2 74 27 78 11 83 c2 01 78 0c 48 83 c4 08 c3 31 c0 48 83 c4 08
> > >      RSP: 0018:ffffc9000d293dc8 EFLAGS: 00000202 ORIG_RAX: ffffffffffffff13
> > >      RAX: ffff888637c05600 RBX: ffffc9000d293e0c RCX: 0000000000000000
> > >      RDX: 0000000000000001 RSI: 0000000000000550 RDI: ffff888637c05620
> > >      RBP: ffffffff8284eb80 R08: ffff88831341d300 R09: ffff88822ffd8248
> > >      R10: ffff88822ffd82d0 R11: 00000000003a93c0 R12: 0000000000000001
> > >      R13: 00000000ffffffff R14: ffff88831341d300 R15: 0000000000000000
> > >       ? find_ge_pid+0x1b/0x20
> > >       task_seq_get_next+0x52/0xc0
> > >       task_file_seq_get_next+0x159/0x220
> > >       task_file_seq_next+0x4f/0xa0
> > >       bpf_seq_read+0x159/0x390
> > >       vfs_read+0x8a/0x140
> > >       ksys_read+0x59/0xd0
> > >       do_syscall_64+0x42/0x110
> > >       entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > >      RIP: 0033:0x7f95ae73e76e
> > >      Code: Bad RIP value.
> > >      RSP: 002b:00007ffc02c1dbf8 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
> > >      RAX: ffffffffffffffda RBX: 000000000170faa0 RCX: 00007f95ae73e76e
> > >      RDX: 0000000000001000 RSI: 00007ffc02c1dc30 RDI: 0000000000000007
> > >      RBP: 00007ffc02c1ec70 R08: 0000000000000005 R09: 0000000000000006
> > >      R10: fffffffffffff20b R11: 0000000000000246 R12: 00000000019112a0
> > >      R13: 0000000000000000 R14: 0000000000000007 R15: 00000000004283c0
> > >
> > > The attached patch does 3 things:
> > >
> > > 1) If unable to obtain the file structure for the current task,
> > >     proceed to the next task number after the one returned from
> > >     task_seq_get_next(), instead of the next task number from the
> > >     original iterator.
> >
> > Looks like this fix is the real fix for the above warnings.
> > Basically, say we have
> >    info->tid = 10 and returned curr_tid = 3000 and tid 3000 has no files.
> > the current logic will go through
> >    - set curr_tid = 11 (info->tid++) and returned curr_tid = 3000
> >    - set curr_tid = 12 and returned curr_tid = 3000
> >    ...
> >    - set curr_tid = 3000 and returned curr_tid = 3000
> >    - set curr_tid = 3001 and return curr_tid >= 3001
> >
> > All the above works are redundant work, and it may cause issues
> > for non preemptable kernel.
> >
> > I suggest you factor out this change plus the following change
> > which suggested by Andrii early to a separate patch carried with
> > the below Fixes tag.
> >
> > diff --git a/kernel/bpf/task_iter.c b/kernel/bpf/task_iter.c
> > index 0458a40edf10..56bcaef72e36 100644
> > --- a/kernel/bpf/task_iter.c
> > +++ b/kernel/bpf/task_iter.c
> > @@ -158,6 +158,7 @@ task_file_seq_get_next(struct
> > bpf_iter_seq_task_file_info *info)
> >                 if (!curr_task) {
> >                         info->task = NULL;
> >                         info->files = NULL;
> > +                       info->tid = curr_tid + 1;
> >                         return NULL;
> >                 }
>
> Sure this isn't supposed to be 'curr_tid'?  task_seq_get_next() stops
> when there are no more threads found.  This increments the thread id
> past the search point, and would seem to introduce a potential off-by-one
> error.
>
> That is:
>    curr_tid = 3000.
>    call task_seq_get_next() --> return NULL, curr_tid = 3000.
>       (so there is no tid >= 3000)
>    set curr_tid = 3001.
>
>    next restart (if there is one) skips a newly created 3000.

Seems fine to me to skip 3000 in such case. 3000 didn't exist at the
time of iteration. If there was >=3001 it would have been skipped as
well.

>
> --
> Jonathan
