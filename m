Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD50B4A6913
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 01:09:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231354AbiBBAJS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 19:09:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231244AbiBBAJR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 19:09:17 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8A29C061714;
        Tue,  1 Feb 2022 16:09:17 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id c188so23372232iof.6;
        Tue, 01 Feb 2022 16:09:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h3/JA9Kjrf2sssKnhkWREXvE0A1YuVOdh71JBJknGvo=;
        b=EzsitlA2IGYvG0LgoRnVrNErszE0SWnc4GlwMdh2YROhar+Q4BhKTkNFsW4g60vk57
         zUsIg+EJBJUAvWWEjHQ9sUpZD8nnTdwzjNjaDr7behviN7spLxkuwr1xZnwrlZQlgUDH
         +oKeDuhQgLZ3oGPoB0UzJ2NP1pKR+C4PMcay9l8MBifUKpQrm/Qk3wZCVhAAUd5ejf44
         ieWbgFSgS6uaJ0uO63PAwYxuIKboGeYmHBgrzgmgKFoDGNNIL837kz/bdCVflI4QVd82
         PgbkDBucGSvJercPVS1sjO+zC5wX9fVEA4bWonxZj2gJx9CEZ/gtgdzFsQNVpIYLrbC2
         /uAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h3/JA9Kjrf2sssKnhkWREXvE0A1YuVOdh71JBJknGvo=;
        b=eNLwPYUBtznmEIdx4P5m1McB7bmNoQGDgUrZqv2XLPVF6OPJm6m49ttIcuAo+t1JrS
         Ewne1VJ9JCLdTcWQEQQM8USWtMP9VfIbx17TEXl0XWDUTHSFIjQS/Cm1R4E3k04P+gLi
         2qlmAElcKiAl1T9TJgWf9WzXtwm9blWxya52qDM+0047nMKaKNBxjSRAuAyRRO7gLxvu
         zfdFcQqARbJ4+1Dg8slXoSQyBnzc/ifKscpTICSUpDIGQRRvNuN9GRMydUFxi6bHxTN1
         uWbYNYvTELpcdbhu7GhOaXBQwiAzcaH9CRkzUsxNfvSAdbY9LltXUJ3fK4b0lULl5LSQ
         2qEg==
X-Gm-Message-State: AOAM532a1h7fGU4WjUTdwIhaXZKBk6G3CZyFhPCTOQOrcn6ELt++dekM
        GNGPcjzwWC0PMUmLttbxlTyY8gC4AOcwRDrzuM4=
X-Google-Smtp-Source: ABdhPJxZr2pjkmV6p8nqm2vdMuzDQnRMY9pAhmjPG5MAgvi8i3xETI/msJo6AuUCk+g3TWOfrm0YWFgiQ90s/RshbeI=
X-Received: by 2002:a05:6638:304d:: with SMTP id u13mr12582631jak.103.1643760557134;
 Tue, 01 Feb 2022 16:09:17 -0800 (PST)
MIME-Version: 1.0
References: <164360522462.65877.1891020292202285106.stgit@devnote2> <YfnKIyTwi+F3IPdI@krava>
In-Reply-To: <YfnKIyTwi+F3IPdI@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 1 Feb 2022 16:09:05 -0800
Message-ID: <CAEf4BzYRJuTLJc=Z9P-p3BtuKu_74MtA2MyrY_ceBxofuKuzHQ@mail.gmail.com>
Subject: Re: [PATCH v7 00/10] fprobe: Introduce fprobe function entry/exit probe
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S . Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 1, 2022 at 4:02 PM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Mon, Jan 31, 2022 at 02:00:24PM +0900, Masami Hiramatsu wrote:
> > Hi,
> >
> > Here is the 7th version of fprobe. This version fixes unregister_fprobe()
> > ensures that exit_handler is not called after returning from the
> > unregister_fprobe(), and fixes some comments and documents.
> >
> > The previous version is here[1];
> >
> > [1] https://lore.kernel.org/all/164338031590.2429999.6203979005944292576.stgit@devnote2/T/#u
> >
> > This series introduces the fprobe, the function entry/exit probe
> > with multiple probe point support. This also introduces the rethook
> > for hooking function return as same as the kretprobe does. This
> > abstraction will help us to generalize the fgraph tracer,
> > because we can just switch to it from the rethook in fprobe,
> > depending on the kernel configuration.
> >
> > The patch [1/10] is from Jiri's series[2].
> >
> > [2] https://lore.kernel.org/all/20220104080943.113249-1-jolsa@kernel.org/T/#u
> >
> > And the patch [9/10] adds the FPROBE_FL_KPROBE_SHARED flag for the case
> > if user wants to share the same code (or share a same resource) on the
> > fprobe and the kprobes.
>
> hi,
> it works fine for bpf selftests, but when I use it through bpftrace
> to attach more probes with:
>
>   # ./src/bpftrace -e 'kprobe:ksys_* { }'
>   Attaching 27 probes
>
> I'm getting stalls like:
>
> krava33 login: [  988.574069] INFO: task bpftrace:4137 blocked for more than 122 seconds.
> [  988.577577]       Not tainted 5.16.0+ #89
> [  988.580173] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  988.585538] task:bpftrace        state:D stack:    0 pid: 4137 ppid:  4123 flags:0x00004004
> [  988.589869] Call Trace:
> [  988.591312]  <TASK>
> [  988.592577]  __schedule+0x3a8/0xd30
> [  988.594469]  ? wait_for_completion+0x84/0x110
> [  988.596753]  schedule+0x4e/0xc0
> [  988.598480]  schedule_timeout+0xed/0x130
> [  988.600524]  ? rcu_read_lock_sched_held+0x12/0x70
> [  988.602901]  ? lock_release+0x253/0x4a0
> [  988.604935]  ? lock_acquired+0x1b7/0x410
> [  988.607041]  ? trace_hardirqs_on+0x1b/0xe0
> [  988.609202]  wait_for_completion+0xae/0x110
> [  988.613762]  __wait_rcu_gp+0x127/0x130
> [  988.615787]  synchronize_rcu_tasks_generic+0x46/0xa0
> [  988.618329]  ? call_rcu_tasks+0x20/0x20
> [  988.620600]  ? rcu_tasks_pregp_step+0x10/0x10
> [  988.623232]  ftrace_shutdown.part.0+0x174/0x210
> [  988.625820]  unregister_ftrace_function+0x37/0x60
> [  988.628480]  unregister_fprobe+0x2d/0x50
> [  988.630928]  bpf_link_free+0x4e/0x70
> [  988.633126]  bpf_link_release+0x11/0x20
> [  988.635249]  __fput+0xae/0x270
> [  988.637022]  task_work_run+0x5c/0xa0
> [  988.639016]  exit_to_user_mode_prepare+0x251/0x260
> [  988.641294]  syscall_exit_to_user_mode+0x16/0x50
> [  988.646249]  do_syscall_64+0x48/0x90
> [  988.648218]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [  988.650787] RIP: 0033:0x7f9079e95fbb
> [  988.652761] RSP: 002b:00007ffd474fa3b0 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
> [  988.656718] RAX: 0000000000000000 RBX: 00000000011bf8d0 RCX: 00007f9079e95fbb
> [  988.660110] RDX: 0000000000000000 RSI: 00007ffd474fa3b0 RDI: 0000000000000019
> [  988.663512] RBP: 00007ffd474faaf0 R08: 0000000000000000 R09: 000000000000001a
> [  988.666673] R10: 0000000000000064 R11: 0000000000000293 R12: 0000000000000001
> [  988.669770] R13: 00000000004a19a1 R14: 00007f9083428c00 R15: 00000000008c02d8
> [  988.672601]  </TASK>
> [  988.675763] INFO: lockdep is turned off.
>
> I have't investigated yet, any idea?
>

Do you happen to have a CPU count that's not a power of 2? Check if
you have [0] in your tree, it might be that.

  [0] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=a773abf72eb0cac008743891068ca6edecc44683

> thanks,
> jirka
>
