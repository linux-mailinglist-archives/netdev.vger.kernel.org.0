Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9429F383A25
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 18:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240274AbhEQQj0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 12:39:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240373AbhEQQjI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 12:39:08 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94769C061288
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 08:42:53 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id j19so5129675qtp.7
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 08:42:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rs8wKGuAJirIeR8pB24GlnuxBoLLyGIXXFMHW4+hs1w=;
        b=cAikG+5a+4iynx/4oTqeQfZM8HsfstVIlIpcGDnVS+fZKQ4YAVJJ97MSosr425ij9Y
         ya0pvC4B+sR2TNN0E5G4RKCO4azawWGhbJ1OPpsV4NLVPeXzMv+cTEt6FqiMWKiFzPOQ
         XWfZ9fq+c9yx432zbo136TkkBpCYU1GZkw0J+5MpWa4OXai1udsUHqtVbkSMkNmWwaHb
         tbpKFE+Gkqgkf9xBIAIt05teAOFZhwO8x2VgQZ5SH0mM52qD6I8zs0sTnkHy/M9F1YZ2
         lw4yRHS4EqEUwyiooEFBCSnXvBDGdAwQWltG5hDGcS0Vkt3ScFvXx0lGzOWkmfGld0BK
         /blQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rs8wKGuAJirIeR8pB24GlnuxBoLLyGIXXFMHW4+hs1w=;
        b=NM9aTT/Kji4PZa5xJBd/zWcUODLtseIyMP6Zzcm96V29AKSQPS7GWJ+JMvS8BKBXbQ
         hJ3huRviUBYJiQyMj55kmu+W8grpfwmin4HABNAsH4y04SzMedQa04eyG2LFbQQzsDDN
         scvRNO/HjV/7DJM7X7zWmu1xgLDzZNeVJAfRND7e5YnkrpjbiddYassPzOxhtx2kwvz0
         nUDp+ZW/WxZpyiPtTlMvy8Qh/BKYRCKDl4FREccj4iuTyi81a39uzsLNWNTIyPbWNOnI
         gG88Pv8qvJC/TuGgWONHNSM0laCRxoYeun8PjfkpAOfW5GzABUmhQb09EZ/IZFp4uI8+
         CGFA==
X-Gm-Message-State: AOAM531BjalI4KRnPMtPC/eMhFOHsSZeDvq/e5F41H5BBB1o8pK3VVS3
        1KAa0Lj6nRsCCHNis/W4ifSIeAE25ovL7xDSrs4MoQ==
X-Google-Smtp-Source: ABdhPJzBUC2UlgtxIY/TiiqefaCZcOrelPEgUS6Try6RDiLyE67cFdt6W03BqBqHnvhEYKfUBGs0M7Y/ntaiAgUFPJ8=
X-Received: by 2002:ac8:51d6:: with SMTP id d22mr110921qtn.67.1621266172503;
 Mon, 17 May 2021 08:42:52 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000e65b5d05c287fddc@google.com>
In-Reply-To: <000000000000e65b5d05c287fddc@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Mon, 17 May 2021 17:42:41 +0200
Message-ID: <CACT4Y+b2CzUxXyNJti=+7vbmQQg6=Ryjxp6orfrqvD8dmkhfGw@mail.gmail.com>
Subject: Re: [syzbot] WARNING in task_ctx_sched_out
To:     syzbot <syzbot+30189c98403be62bc05a@syzkaller.appspotmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        linux-riscv <linux-riscv@lists.infradead.org>
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Martin KaFai Lau <kafai@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 17, 2021 at 5:10 PM syzbot
<syzbot+30189c98403be62bc05a@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    18a3c5f7 Merge tag 'for_linus' of git://git.kernel.org/pub..
> git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/riscv/linux.git fixes
> console output: https://syzkaller.appspot.com/x/log.txt?x=1569c027d00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=b8ac1fe5995f69d7
> dashboard link: https://syzkaller.appspot.com/bug?extid=30189c98403be62bc05a
> userspace arch: riscv64
>
> Unfortunately, I don't have any reproducer for this issue yet.
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+30189c98403be62bc05a@syzkaller.appspotmail.com

Another perf warning on riscv64:

WARNING in __perf_install_in_context
https://syzkaller.appspot.com/bug?id=ca4bae83abaaa2be86e4dc7925343fae9abb6056
https://groups.google.com/g/syzkaller-bugs/c/sc87fhg7Vhg/m/7_cuuqu9BAAJ


> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 8711 at kernel/events/core.c:2668 task_ctx_sched_out+0x5c/0x60 kernel/events/core.c:2668
> Modules linked in:
> CPU: 0 PID: 8711 Comm: syz-executor.0 Not tainted 5.12.0-rc8-syzkaller-00011-g18a3c5f7abfd #0
> Hardware name: riscv-virtio,qemu (DT)
> epc : task_ctx_sched_out+0x5c/0x60 kernel/events/core.c:2668
>  ra : task_ctx_sched_out+0x5c/0x60 kernel/events/core.c:2668
> epc : ffffffe00027ccf0 ra : ffffffe00027ccf0 sp : ffffffe0067abb80
>  gp : ffffffe0045883c0 tp : ffffffe00db797c0 t0 : ffffffc400b23834
>  t1 : 0000000000000001 t2 : 00000000000f4240 s0 : ffffffe0067abbb0
>  s1 : ffffffe066d59e00 a0 : ffffffe066d59fa8 a1 : 00000000000f0000
>  a2 : 0000000000000002 a3 : ffffffe00027ccf0 a4 : ffffffe00db7a7c0
>  a5 : 0000000000000000 a6 : 0000000000f00000 a7 : ffffffe00028fc4c
>  s2 : ffffffe00877e400 s3 : 0000000000000003 s4 : ffffffe00df38800
>  s5 : ffffffe00db7ab48 s6 : ffffffe00db7aab8 s7 : ffffffe00877e408
>  s8 : 0000000000000000 s9 : 0000000000000025 s10: ffffffe00db797c0
>  s11: ffffffe0067abe30 t3 : 1ef9635ec2383300 t4 : ffffffc404c957b2
>  t5 : ffffffc404c957ba t6 : 0000000000040000
> status: 0000000000000100 badaddr: 0000000000000000 cause: 0000000000000003
> Call Trace:
> [<ffffffe00027ccf0>] task_ctx_sched_out+0x5c/0x60 kernel/events/core.c:2668
> [<ffffffe00028fc98>] perf_event_exit_task_context kernel/events/core.c:12483 [inline]
> [<ffffffe00028fc98>] perf_event_exit_task+0x214/0x708 kernel/events/core.c:12541
> [<ffffffe000031fc4>] do_exit+0x77a/0x1846 kernel/exit.c:834
> [<ffffffe00003319a>] do_group_exit+0xa0/0x198 kernel/exit.c:922
> [<ffffffe00004c558>] get_signal+0x31e/0x14ba kernel/signal.c:2781
> [<ffffffe000007e06>] do_signal arch/riscv/kernel/signal.c:271 [inline]
> [<ffffffe000007e06>] do_notify_resume+0xa8/0x930 arch/riscv/kernel/signal.c:317
> [<ffffffe000005586>] ret_from_exception+0x0/0x14
> irq event stamp: 3704
> hardirqs last  enabled at (3703): [<ffffffe002a9a784>] __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:160 [inline]
> hardirqs last  enabled at (3703): [<ffffffe002a9a784>] _raw_spin_unlock_irqrestore+0x68/0x98 kernel/locking/spinlock.c:191
> hardirqs last disabled at (3704): [<ffffffe002a9a41c>] __raw_spin_lock_irq include/linux/spinlock_api_smp.h:126 [inline]
> hardirqs last disabled at (3704): [<ffffffe002a9a41c>] _raw_spin_lock_irq+0x5c/0x5e kernel/locking/spinlock.c:167
> softirqs last  enabled at (3672): [<ffffffe002a9b578>] __do_softirq+0x5e0/0x8c4 kernel/softirq.c:372
> softirqs last disabled at (3667): [<ffffffe00003507e>] do_softirq_own_stack include/asm-generic/softirq_stack.h:10 [inline]
> softirqs last disabled at (3667): [<ffffffe00003507e>] invoke_softirq kernel/softirq.c:228 [inline]
> softirqs last disabled at (3667): [<ffffffe00003507e>] __irq_exit_rcu kernel/softirq.c:422 [inline]
> softirqs last disabled at (3667): [<ffffffe00003507e>] irq_exit+0x1a0/0x1b6 kernel/softirq.c:446
> ---[ end trace 2de0fbf815e6ece8 ]---
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/000000000000e65b5d05c287fddc%40google.com.
