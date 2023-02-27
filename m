Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B60CA6A4C4B
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 21:36:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229964AbjB0Uf7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 15:35:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbjB0Uf5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 15:35:57 -0500
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB0AB222E5
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 12:35:53 -0800 (PST)
Received: by mail-il1-x135.google.com with SMTP id o8so4720253ilt.13
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 12:35:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QBkd7dpm4S37jjGNCXD5hQsfIEshEAUQxHeDu6AVUfw=;
        b=XIlryLmUpJSmq5zan4wlIcqnL4WE3FpS03Y2i5zBop/ylkARkok542+L0m8S6MhVr6
         6vGbZyS8xJEbEqjj3llxC7ROeR1vw07vmbYjE28CfuFJ9TFBq5lE1WDnR+5ApvacSWUm
         R4JfhJbj2hPGfLpN8bRXfzGEism+esWtvr4V9fd2m0NRlkodoT/WaBW9SMm1j400lg/O
         lG51LSB1VWYKrpmY7i/d+sMIEpaGJv173CVTUvd4oEI5DpO5kMi5DVwAVxAotis7UV97
         0PydCDK1pNl4RMYhIPV9I4k5Jl+ZZWBfL84960pzuqSVex6YqQksnXgmaMV7K/GCWBMk
         LGpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QBkd7dpm4S37jjGNCXD5hQsfIEshEAUQxHeDu6AVUfw=;
        b=bXm/JxkWZk9o1kMIY/DqTUFkFT7eaTYJtDwGKGYKJmkZs7kiEXbreEbNENhEH/DPRE
         2kdCtz9gY1BIoLYN1RilzNSJIAQUakometV9cQrHJa2DbwbpBUC2gquE4V5/0+KZ9rfR
         wRDlpi1CEq3KoUZwgpLtyfoCWjzstJWsWMHJePQCfNXZMkLWCsr7qFlpIXJRdRNJKfx2
         R6jaoIoacgZ1f5zlKRPppIfDGRWIQve0u0u0XlrwfZx/B6+4dHNXrVzr3BTEhnKbwQ1V
         OMRwa+s/mb7GiyUqVQEXNl62lXPkuCgZUPI47dQWOZ+WpvzIdJsjLX99w+xd+dXtQej+
         sZdA==
X-Gm-Message-State: AO0yUKUl0Ov+kJe1seuk3uc/VMgVaZgfveFcDftDU6r/bNANZHiYezw2
        obvP7jrqE+hnIAhhjDdLPATT+C6TiqUtJLAbMM027Q==
X-Google-Smtp-Source: AK7set818wB92hWpCMlVTIuLH6C9/l2dW3zaQw6q8Ej4hXvjkLZydSVkrjZDeFCIUbivaSAmDDm4lGgYWG1S4lZjGjw=
X-Received: by 2002:a92:710a:0:b0:310:d631:cd72 with SMTP id
 m10-20020a92710a000000b00310d631cd72mr390829ilc.2.1677530152884; Mon, 27 Feb
 2023 12:35:52 -0800 (PST)
MIME-Version: 1.0
References: <000000000000e412e905f5b46201@google.com>
In-Reply-To: <000000000000e412e905f5b46201@google.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 27 Feb 2023 21:35:41 +0100
Message-ID: <CANn89iJ_kLaF0tVVUfzKQwVkQ0VtCca1dL8eF+RrXCVDTK6h2Q@mail.gmail.com>
Subject: Re: [syzbot] [net?] INFO: task hung in tls_sw_sendpage (3)
To:     syzbot <syzbot+9c0268252b8ef967c62e@syzkaller.appspotmail.com>
Cc:     borisp@nvidia.com, bpf@vger.kernel.org, davem@davemloft.net,
        john.fastabend@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SORTED_RECIPS,SPF_HELO_NONE,
        SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 27, 2023 at 9:33=E2=80=AFPM syzbot
<syzbot+9c0268252b8ef967c62e@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    d9fc1511728c Merge tag 'net-6.2-rc4' of git://git.kernel.=
o..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D1243daa648000=
0
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3D2b6ecad960fc7=
03e
> dashboard link: https://syzkaller.appspot.com/bug?extid=3D9c0268252b8ef96=
7c62e
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binuti=
ls for Debian) 2.35.2
>
> Unfortunately, I don't have any reproducer for this issue yet.
>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/7e45a73db0f3/dis=
k-d9fc1511.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/09ac811286ca/vmlinu=
x-d9fc1511.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/0985b60a6dbc/b=
zImage-d9fc1511.xz
>
> IMPORTANT: if you fix the issue, please add the following tag to the comm=
it:
> Reported-by: syzbot+9c0268252b8ef967c62e@syzkaller.appspotmail.com
>
> INFO: task syz-executor.5:30321 blocked for more than 143 seconds.
>       Not tainted 6.2.0-rc3-syzkaller-00165-gd9fc1511728c #0
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> task:syz-executor.5  state:D
>  stack:26480 pid:30321 ppid:5106   flags:0x00004004
> Call Trace:
>  <TASK>
>  context_switch kernel/sched/core.c:5293 [inline]
>  __schedule+0xb8a/0x5450 kernel/sched/core.c:6606
>  schedule+0xde/0x1b0 kernel/sched/core.c:6682
>  schedule_preempt_disabled+0x13/0x20 kernel/sched/core.c:6741
>  __mutex_lock_common kernel/locking/mutex.c:679 [inline]
>  __mutex_lock+0xa48/0x1360 kernel/locking/mutex.c:747
>  tls_sw_sendpage+0x83/0xe0 net/tls/tls_sw.c:1278
>  inet_sendpage+0xd4/0x140 net/ipv4/af_inet.c:844
>  kernel_sendpage.part.0+0x1d5/0x700 net/socket.c:3555
>  kernel_sendpage net/socket.c:3552 [inline]
>  sock_sendpage+0xe3/0x140 net/socket.c:1054
>  pipe_to_sendpage+0x2b1/0x380 fs/splice.c:361
>  splice_from_pipe_feed fs/splice.c:415 [inline]
>  __splice_from_pipe+0x449/0x8a0 fs/splice.c:559
>  splice_from_pipe fs/splice.c:594 [inline]
>  generic_splice_sendpage+0xd8/0x140 fs/splice.c:743
>  do_splice_from fs/splice.c:764 [inline]
>  direct_splice_actor+0x114/0x180 fs/splice.c:931
>  splice_direct_to_actor+0x335/0x8a0 fs/splice.c:886
>  do_splice_direct+0x1ab/0x280 fs/splice.c:974
>  do_sendfile+0xb19/0x1270 fs/read_write.c:1255
>  __do_sys_sendfile64 fs/read_write.c:1323 [inline]
>  __se_sys_sendfile64 fs/read_write.c:1309 [inline]
>  __x64_sys_sendfile64+0x1d0/0x210 fs/read_write.c:1309
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> RIP: 0033:0x7f2463e8c0c9
> RSP: 002b:00007f2464b88168 EFLAGS: 00000246 ORIG_RAX: 0000000000000028
> RAX: ffffffffffffffda RBX: 00007f2463fac050 RCX: 00007f2463e8c0c9
> RDX: 0000000000000000 RSI: 0000000000000004 RDI: 0000000000000006
> RBP: 00007f2463ee7ae9 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000800100020013 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007ffd6bb8eb7f R14: 00007f2464b88300 R15: 0000000000022000
>  </TASK>
>
> Showing all locks held in the system:
> 1 lock held by rcu_tasks_kthre/12:
>  #0: ffffffff8c790f30 (rcu_tasks.tasks_gp_mutex){+.+.}-{3:3}, at: rcu_tas=
ks_one_gp+0x26/0xc70 kernel/rcu/tasks.h:507
> 1 lock held by rcu_tasks_trace/13:
>  #0: ffffffff8c790c30 (rcu_tasks_trace.tasks_gp_mutex){+.+.}-{3:3}, at: r=
cu_tasks_one_gp+0x26/0xc70 kernel/rcu/tasks.h:507
> 1 lock held by khungtaskd/27:
>  #0: ffffffff8c791a80 (rcu_read_lock){....}-{1:2}, at: debug_show_all_loc=
ks+0x57/0x264 kernel/locking/lockdep.c:6494
> 2 locks held by kworker/u4:3/46:
> 2 locks held by getty/4749:
>  #0: ffff8880279ed098 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wa=
it+0x26/0x80 drivers/tty/tty_ldisc.c:244
>  #1: ffffc900015802f0 (&ldata->atomic_read_lock){+.+.}-{3:3}, at: n_tty_r=
ead+0xef4/0x13e0 drivers/tty/n_tty.c:2177
> 2 locks held by kworker/u4:9/5267:
>  #0: ffff888012479138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: ar=
ch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
>  #0: ffff888012479138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: ar=
ch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]
>  #0: ffff888012479138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: at=
omic_long_set include/linux/atomic/atomic-instrumented.h:1280 [inline]
>  #0: ffff888012479138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: se=
t_work_data kernel/workqueue.c:636 [inline]
>  #0: ffff888012479138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: se=
t_work_pool_and_clear_pending kernel/workqueue.c:663 [inline]
>  #0: ffff888012479138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: pr=
ocess_one_work+0x86d/0x1710 kernel/workqueue.c:2260
>  #1:
> ffffc90004e8fda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: pr=
ocess_one_work+0x8a1/0x1710 kernel/workqueue.c:2264
> 3 locks held by kworker/0:13/7504:
>  #0: ffff888012470d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomi=
c64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
>  #0: ffff888012470d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomi=
c_long_set include/linux/atomic/atomic-long.h:41 [inline]
>  #0: ffff888012470d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic_lon=
g_set include/linux/atomic/atomic-instrumented.h:1280 [inline]
>  #0: ffff888012470d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_d=
ata kernel/workqueue.c:636 [inline]
>  #0: ffff888012470d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_p=
ool_and_clear_pending kernel/workqueue.c:663 [inline]
>  #0: ffff888012470d38 ((wq_completion)events){+.+.}-{0:0}, at: process_on=
e_work+0x86d/0x1710 kernel/workqueue.c:2260
>  #1: ffffc9000317fda8 ((work_completion)(&(&sw_ctx_tx->tx_work.work)->wor=
k)){+.+.}-{0:0}, at: process_one_work+0x8a1/0x1710 kernel/workqueue.c:2264
>  #2: ffff88803bd894d8 (&ctx->tx_lock){+.+.}-{3:3}, at: tx_work_handler+0x=
12b/0x190 net/tls/tls_sw.c:2419
> 2 locks held by kworker/u4:7/21254:
>  #0: ffff888012479138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: ar=
ch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
>  #0: ffff888012479138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: ar=
ch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]
>  #0: ffff888012479138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: at=
omic_long_set include/linux/atomic/atomic-instrumented.h:1280 [inline]
>  #0: ffff888012479138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: se=
t_work_data kernel/workqueue.c:636 [inline]
>  #0: ffff888012479138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: se=
t_work_pool_and_clear_pending kernel/workqueue.c:663 [inline]
>  #0: ffff888012479138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: pr=
ocess_one_work+0x86d/0x1710 kernel/workqueue.c:2260
>  #1: ffffc9000512fda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, a=
t: process_one_work+0x8a1/0x1710 kernel/workqueue.c:2264
> 3 locks held by kworker/u4:14/22476:
> 1 lock held by syz-executor.5/30321:
>  #0: ffff88803bd894d8 (&ctx->tx_lock){+.+.}-{3:3}, at: tls_sw_sendpage+0x=
83/0xe0 net/tls/tls_sw.c:1278
> 3 locks held by syz-executor.0/1632:
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> NMI backtrace for cpu 0
> CPU: 0 PID: 27 Comm: khungtaskd Not tainted 6.2.0-rc3-syzkaller-00165-gd9=
fc1511728c #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS G=
oogle 10/26/2022
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:88 [inline]
>  dump_stack_lvl+0xd1/0x138 lib/dump_stack.c:106
>  nmi_cpu_backtrace.cold+0x24/0x18a lib/nmi_backtrace.c:111
>  nmi_trigger_cpumask_backtrace+0x333/0x3c0 lib/nmi_backtrace.c:62
>  trigger_all_cpu_backtrace include/linux/nmi.h:148 [inline]
>  check_hung_uninterruptible_tasks kernel/hung_task.c:220 [inline]
>  watchdog+0xc75/0xfc0 kernel/hung_task.c:377
>  kthread+0x2e8/0x3a0 kernel/kthread.c:376
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
>  </TASK>
> Sending NMI from CPU 0 to CPUs 1:
> NMI backtrace for cpu 1
> CPU: 1 PID: 1610 Comm: syz-executor.1 Not tainted 6.2.0-rc3-syzkaller-001=
65-gd9fc1511728c #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS G=
oogle 10/26/2022
> RIP: 0010:native_save_fl arch/x86/include/asm/irqflags.h:29 [inline]
> RIP: 0010:arch_local_save_flags arch/x86/include/asm/irqflags.h:70 [inlin=
e]
> RIP: 0010:arch_irqs_disabled arch/x86/include/asm/irqflags.h:130 [inline]
> RIP: 0010:lock_is_held_type+0xee/0x140 kernel/locking/lockdep.c:5713
> Code: c0 45 31 ed 44 39 f0 41 0f 94 c5 48 c7 c7 e0 4e 4c 8a e8 35 15 00 0=
0 b8 ff ff ff ff 65 0f c1 05 e0 60 fc 75 83 f8 01 75 29 9c <58> f6 c4 02 75=
 3d 48 f7 04 24 00 02 00 00 74 01 fb 48 83 c4 08 44
> RSP: 0018:ffffc9000320f508 EFLAGS: 00000046
> RAX: 0000000000000001 RBX: 0000000000000002 RCX: 0000000000000001
> RDX: 0000000000000000 RSI: 0000000000000002 RDI: 0000000000000000
> RBP: ffffffff8c7919c0 R08: 0000000000000000 R09: ffffffff8e72f857
> R10: fffffbfff1ce5f0a R11: 0000000000000000 R12: ffff888025e09d40
> R13: 0000000000000000 R14: 00000000ffffffff R15: ffff888025e0a7a0
> FS:  0000000000000000(0000) GS:ffff8880b9900000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f289dd821b8 CR3: 0000000032a9e000 CR4: 0000000000350ee0
> Call Trace:
>  <TASK>
>  lock_is_held include/linux/lockdep.h:283 [inline]
>  rcu_read_lock_sched_held+0x3e/0x70 kernel/rcu/update.c:125
>  trace_lock_acquire include/trace/events/lock.h:24 [inline]
>  lock_acquire+0x500/0x630 kernel/locking/lockdep.c:5639
>  rcu_lock_acquire include/linux/rcupdate.h:325 [inline]
>  rcu_read_lock include/linux/rcupdate.h:764 [inline]
>  folio_memcg_lock+0x3e/0x630 mm/memcontrol.c:2103
>  page_remove_rmap+0x5f/0x1210 mm/rmap.c:1397
>  zap_pte_range mm/memory.c:1405 [inline]
>  zap_pmd_range mm/memory.c:1529 [inline]
>  zap_pud_range mm/memory.c:1558 [inline]
>  zap_p4d_range mm/memory.c:1579 [inline]
>  unmap_page_range+0x234d/0x3c30 mm/memory.c:1600
>  unmap_single_vma+0x190/0x2a0 mm/memory.c:1646
>  unmap_vmas+0x226/0x370 mm/memory.c:1685
>  exit_mmap+0x18d/0x7b0 mm/mmap.c:3085
>  __mmput+0x128/0x4c0 kernel/fork.c:1207
>  mmput+0x60/0x70 kernel/fork.c:1229
>  exit_mm kernel/exit.c:563 [inline]
>  do_exit+0x9ac/0x2950 kernel/exit.c:854
>  do_group_exit+0xd4/0x2a0 kernel/exit.c:1012
>  get_signal+0x21c3/0x2450 kernel/signal.c:2859
>  arch_do_signal_or_restart+0x79/0x5c0 arch/x86/kernel/signal.c:306
>  exit_to_user_mode_loop kernel/entry/common.c:168 [inline]
>  exit_to_user_mode_prepare+0x15f/0x250 kernel/entry/common.c:203
>  __syscall_exit_to_user_mode_work kernel/entry/common.c:285 [inline]
>  syscall_exit_to_user_mode+0x1d/0x50 kernel/entry/common.c:296
>  do_syscall_64+0x46/0xb0 arch/x86/entry/common.c:86
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> RIP: 0033:0x7f249da8c0c9
> Code: Unable to access opcode bytes at 0x7f249da8c09f.
> RSP: 002b:00007f249e82b218 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
> RAX: 0000000000000001 RBX: 00007f249dbabf88 RCX: 00007f249da8c0c9
> RDX: 00000000000f4240 RSI: 0000000000000081 RDI: 00007f249dbabf8c
> RBP: 00007f249dbabf80 R08: 00007fffed1f8080 R09: 0000000000000000
> R10: ffffffffffffffff R11: 0000000000000246 R12: 00007f249dbabf8c
> R13: 00007fffed11f2df R14: 00007f249e82b300 R15: 0000000000022000
>  </TASK>
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

This looks suspicious to me

commit 79ffe6087e9145d2377385cac48d0d6a6b4225a5
Author: Jakub Kicinski <kuba@kernel.org>
Date:   Tue Nov 5 14:24:35 2019 -0800

    net/tls: add a TX lock


If tls_sw_sendpage() has to call sk_stream_wait_memory(),
sk_stream_wait_memory() is properly releasing the socket lock,
but knows nothing about mutex_{un}lock(&tls_ctx->tx_lock);
