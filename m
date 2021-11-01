Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D65E441CB9
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 15:35:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232005AbhKAOht (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 10:37:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbhKAOhs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 10:37:48 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBDC7C061714;
        Mon,  1 Nov 2021 07:35:14 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id i14so21707190ioa.13;
        Mon, 01 Nov 2021 07:35:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/dxlHLhVVeQz41NT3FXktHwc6LNqxwx1mOX2k57ETQc=;
        b=H/1G8uLzOKFUO52ObvxuuCuV2l4rLb4ppcpv63LC7y0Tk4dE973BG8DiuIgTiz+kLZ
         bpyTdkposK7jsR+F92tk48sbrLWZlxQmSwWgg+FTp8yGpCNho0MmcjII02ryAAYVxBgv
         X6yFut/50QTG4V3DM6A+ST2FkB09I5Xws9xJ0FRh68XEdS1mUzmdBat2YFQTVNv+4qjs
         iLLEx1qRt5E2fiPqF7c/BqIwMW5d8svEQl08Guopq4so8w/JOi93ZHwv4T0+34xN2ewR
         Fx/qIl+wkLAkfRBznYLmPTxdSvF+NCPooq2tubC5/sOiwajiOM3/qG0yGmIRqpwhwqo6
         /BEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/dxlHLhVVeQz41NT3FXktHwc6LNqxwx1mOX2k57ETQc=;
        b=4iSBKOQr0a1xWj2dZnXm2Cy91WtE/q4voUhbu8DCJ0cAJ959Y000xkrySJnUe47w/D
         lOHdIgCtV79cLOFJAAcVFhaVGQS9Wh6Zt9eXK5qXnS9X5aTd8n2j1W4z56OQdZrQb5Op
         Fcb3HssV6/uBM7AUM/8K7wzGfUm9Ssg4kKK9Gum+Ebtp51kiJ50KZwcxE5TcdOBft63K
         VARt1jkGHu2StDlJ9266Afu6UpD7XILelEDzCXqOiUV5Bxcud5CcQfknlo0FAkYQJVKr
         2uxbVnDYXj8w6Gh8KkQJ/JBjg7t27EXIZTUehtV9XNUMpFDLPbAANH9VQc3Dr5ev3Gqg
         Lwfw==
X-Gm-Message-State: AOAM5329l2oHn0x1am9R45dhTZFOD9Pimy/pieuClhlMwc1RWwp5/oPT
        mlcR3Gk+cKsBASKyoEWPqyN45uNeTqk0drceFqX5RWlT6CCH2iMOkzU=
X-Google-Smtp-Source: ABdhPJxML5PM3L1wF90f7Vr07fhP4LkRyBWT2Nd3AJz21DOOUbOnidR2/cTzlniPaknpj0TIA3BSov/kzpbs+lx1tXY=
X-Received: by 2002:a05:6602:2f0a:: with SMTP id q10mr4985724iow.202.1635777314146;
 Mon, 01 Nov 2021 07:35:14 -0700 (PDT)
MIME-Version: 1.0
References: <20211101060419.4682-1-laoar.shao@gmail.com> <YX/0h7j/nDwoBA+J@alley>
In-Reply-To: <YX/0h7j/nDwoBA+J@alley>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Mon, 1 Nov 2021 22:34:30 +0800
Message-ID: <CALOAHbA61RyGVzG8SVcNG=0rdqnUCt4AxCKmtuxRnbS_SH=+MQ@mail.gmail.com>
Subject: Re: [PATCH v7 00/11] extend task comm from 16 to 24
To:     Petr Mladek <pmladek@suse.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Valentin Schneider <valentin.schneider@arm.com>,
        Qiang Zhang <qiang.zhang@windriver.com>,
        robdclark <robdclark@chromium.org>,
        christian <christian@brauner.io>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        dennis.dalessandro@cornelisnetworks.com,
        mike.marciniszyn@cornelisnetworks.com, dledford@redhat.com,
        jgg@ziepe.ca, linux-rdma@vger.kernel.org,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "linux-perf-use." <linux-perf-users@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel test robot <oliver.sang@intel.com>,
        kbuild test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 1, 2021 at 10:07 PM Petr Mladek <pmladek@suse.com> wrote:
>
> On Mon 2021-11-01 06:04:08, Yafang Shao wrote:
> > There're many truncated kthreads in the kernel, which may make trouble
> > for the user, for example, the user can't get detailed device
> > information from the task comm.
> >
> > This patchset tries to improve this problem fundamentally by extending
> > the task comm size from 16 to 24, which is a very simple way.
> >
> > In order to do that, we have to do some cleanups first.
> >
> > 1. Make the copy of task comm always safe no matter what the task
> >    comm size is. For example,
> >
> >       Unsafe                 Safe
> >       strlcpy                strscpy_pad
> >       strncpy                strscpy_pad
> >       bpf_probe_read_kernel  bpf_probe_read_kernel_str
> >                              bpf_core_read_str
> >                              bpf_get_current_comm
> >                              perf_event__prepare_comm
> >                              prctl(2)
> >
> >    After this step, the comm size change won't make any trouble to the
> >    kernel or the in-tree tools for example perf, BPF programs.
> >
> > 2. Cleanup some old hard-coded 16
> >    Actually we don't need to convert all of them to TASK_COMM_LEN or
> >    TASK_COMM_LEN_16, what we really care about is if the convert can
> >    make the code more reasonable or easier to understand. For
> >    example, some in-tree tools read the comm from sched:sched_switch
> >    tracepoint, as it is derived from the kernel, we'd better make them
> >    consistent with the kernel.
>
> The above changes make sense even if we do not extend comm[] array in
> task_struct.
>
>
> > 3. Extend the task comm size from 16 to 24
> >    task_struct is growing rather regularly by 8 bytes. This size change
> >    should be acceptable. We used to think about extending the size for
> >    CONFIG_BASE_FULL only, but that would be a burden for maintenance
> >    and introduce code complexity.
> >
> > 4. Print a warning if the kthread comm is still truncated.
> >
> > 5. What will happen to the out-of-tree tools after this change?
> >    If the tool get task comm through kernel API, for example prctl(2),
> >    bpf_get_current_comm() and etc, then it doesn't matter how large the
> >    user buffer is, because it will always get a string with a nul
> >    terminator. While if it gets the task comm through direct string copy,
> >    the user tool must make sure the copied string has a nul terminator
> >    itself. As TASK_COMM_LEN is not exposed to userspace, there's no
> >    reason that it must require a fixed-size task comm.
>
> The amount of code that has to be updated is really high. I am pretty
> sure that there are more potential buffer overflows left.
>
> You did not commented on the concerns in the thread
> https://lore.kernel.org/all/CAADnVQKm0Ljj-w5PbkAu1ugLFnZRRPt-Vk-J7AhXxDD5xVompA@mail.gmail.com/
>

I thought Steven[1] and  Kees[2] have already clearly explained why we
do it like that, so I didn't give any more words on it.

[1]. https://lore.kernel.org/all/20211025170503.59830a43@gandalf.local.home/
[2]. https://lore.kernel.org/all/202110251406.56F87A3522@keescook/

> Several people suggested to use a more conservative approach.

Yes, they are Al[3] and Alexei[4].

[3]. https://lore.kernel.org/lkml/YVkmaSUxbg%2FJtBHb@zeniv-ca.linux.org.uk/
[4]. https://lore.kernel.org/all/CAADnVQKm0Ljj-w5PbkAu1ugLFnZRRPt-Vk-J7AhXxDD5xVompA@mail.gmail.com/

> I mean
> to keep comm[16] as is and add a new pointer to the full name. The buffer
> for the long name might be dynamically allocated only when needed.
>

That would add a new allocation in the fork() for the threads with a long name.
I'm not sure if it is worth it.

> The pointer might be either in task_struct or struct kthread. It might
> be used the same way as the full name stored by workqueue kthreads.
>

If we decide to do it like that, I think we'd better add it in
task_struct, then it will work for all tasks.

> The advantage of the separate pointer:
>
>    + would work for names longer than 32
>    + will not open security holes in code
>

Yes, those are the advantages.  And the disadvantage of it is:

 - new allocation in fork()


-- 
Thanks
Yafang
