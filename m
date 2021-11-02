Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5977442501
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 02:10:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231437AbhKBBNC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 21:13:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbhKBBNB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 21:13:01 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61536C061714;
        Mon,  1 Nov 2021 18:10:27 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id p204so12068454iod.8;
        Mon, 01 Nov 2021 18:10:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ehy0XSpOplhnJPTu2SM6YtwbIMUDDIgGBva5/Leuo6g=;
        b=kU0RbIUOhKfJFJr9pzzRahTBNVtJThLIwuxVQgVa0UWrRNIWFEIBPTbbB0qEGYvWNp
         AzPvhAt5Tfi+puIhqx1nzzkM5tZ3jcUhbuJykwycQI1Z101JFODOqr01uikeVGsur9Fv
         m5x+HGqyXbM+HSWP4l5Ez0Ah7tKirpVoDeP6hGQokvUBk/FwpHjWlXmYtS5nXhfsctbX
         tlk5ZGpMvMYsLihuUP+0uIkioIY0+DZ+fWHw+o7RmJI0PFqHXhX5ftuuk5m2BIw/66sE
         CET8s0UVR4DhKoNQ1plCJ+gNkvnVjCgz5DlSPhzTpxhn7g/Z288uSkopZgNS7p+4fAz/
         la+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ehy0XSpOplhnJPTu2SM6YtwbIMUDDIgGBva5/Leuo6g=;
        b=6ajLUcrU8/astpNoESXYpY5k2KV4vdDhn/XSBOmU4uFi6IH9EMeXVNhN0KXtGyWtdu
         +mbXIZgH1JCavKUqBQ7BbnP1y6zhn1+G7Tc0ty3KCcXQGGwgBY/YItJ4zfIz8MD7usaL
         +FUkvtvgDfvtMdkqL0/egjsg4fOrx3IcPrswv8NaN0KokPQ9He6Rtesgzxr+6FUw3HIV
         7AgkJRz6+JL4735Yp428zfyQUJ2ZGuM3eU54j1+yStEBXDKcvypRQ7LovS7N5mVPMmzi
         Hd0VsPnrygBzRUlyT/elWUvboqSfnPNTBaCZKn2nYXue7VZIczTA+66Ecfolo65G8Zdx
         z68g==
X-Gm-Message-State: AOAM533T6YHXY/lTpqCnYNp/B3In69Jt9ytEztwlz0kvg6CG7dNutKQK
        UiWruCiAdghCMQLZuszVsWtRx6og5/sLpQlw1ABphtn0nHBiEB7B0oU=
X-Google-Smtp-Source: ABdhPJzVw2x+5/HYLiwL7Md8DRLXERlLY4V+97Im04VA/lFA6YxKC1gsvipPZCBNZ/9b+5iz33+Fe76oRlCSo6q8zpc=
X-Received: by 2002:a05:6638:386:: with SMTP id y6mr3807157jap.49.1635815426525;
 Mon, 01 Nov 2021 18:10:26 -0700 (PDT)
MIME-Version: 1.0
References: <20211101060419.4682-1-laoar.shao@gmail.com> <YX/0h7j/nDwoBA+J@alley>
 <CALOAHbA61RyGVzG8SVcNG=0rdqnUCt4AxCKmtuxRnbS_SH=+MQ@mail.gmail.com> <YYAPhE9uX7OYTlpv@alley>
In-Reply-To: <YYAPhE9uX7OYTlpv@alley>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Tue, 2 Nov 2021 09:09:50 +0800
Message-ID: <CALOAHbAx55AUo3bm8ZepZSZnw7A08cvKPdPyNTf=E_tPqmw5hw@mail.gmail.com>
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

On Tue, Nov 2, 2021 at 12:02 AM Petr Mladek <pmladek@suse.com> wrote:
>
> On Mon 2021-11-01 22:34:30, Yafang Shao wrote:
> > On Mon, Nov 1, 2021 at 10:07 PM Petr Mladek <pmladek@suse.com> wrote:
> > > On Mon 2021-11-01 06:04:08, Yafang Shao wrote:
> > > > 4. Print a warning if the kthread comm is still truncated.
> > > >
> > > > 5. What will happen to the out-of-tree tools after this change?
> > > >    If the tool get task comm through kernel API, for example prctl(2),
> > > >    bpf_get_current_comm() and etc, then it doesn't matter how large the
> > > >    user buffer is, because it will always get a string with a nul
> > > >    terminator. While if it gets the task comm through direct string copy,
> > > >    the user tool must make sure the copied string has a nul terminator
> > > >    itself. As TASK_COMM_LEN is not exposed to userspace, there's no
> > > >    reason that it must require a fixed-size task comm.
> > >
> > > The amount of code that has to be updated is really high. I am pretty
> > > sure that there are more potential buffer overflows left.
> > >
> > > You did not commented on the concerns in the thread
> > > https://lore.kernel.org/all/CAADnVQKm0Ljj-w5PbkAu1ugLFnZRRPt-Vk-J7AhXxDD5xVompA@mail.gmail.com/
> > >
> > I thought Steven[1] and  Kees[2] have already clearly explained why we
> > do it like that, so I didn't give any more words on it.
> >
> > [1]. https://lore.kernel.org/all/20211025170503.59830a43@gandalf.local.home/
>
> Steven was against switching task->comm[16] into a dynamically
> allocated pointer. But he was not against storing longer names
> separately.
>
> > [2]. https://lore.kernel.org/all/202110251406.56F87A3522@keescook/
>
> Honestly, I am a bit confused by Kees' answer. IMHO, he agreed that
> switching task->comm[16] into a pointer was not worth it.
>
> But I am not sure what he meant by "Agreed -- this is a small change
> for what is already an "uncommon" corner case."
>
>
> > > Several people suggested to use a more conservative approach.
> >
> > Yes, they are Al[3] and Alexei[4].
> >
> > [3]. https://lore.kernel.org/lkml/YVkmaSUxbg%2FJtBHb@zeniv-ca.linux.org.uk/
>
> IMHO, Al suggested to store the long name separately and return it
> by proc_task_name() when available.
>
>
> > [4]. https://lore.kernel.org/all/CAADnVQKm0Ljj-w5PbkAu1ugLFnZRRPt-Vk-J7AhXxDD5xVompA@mail.gmail.com/
>
> Alexei used dentry->d_iname as an exaxmple. struct dentry uses
> d_iname[DNAME_INLINE_LEN] for short names. And dynamically
> allocated d_name for long names, see *__d_alloc() implementation.
>

Thanks for the summary.
So with Stenven's new reply[1], the opinion in common is storing long
names into a separate place. And no one is against it now.

[1]. https://lore.kernel.org/lkml/20211101120636.3cfc5afa@gandalf.local.home/

> > > I mean
> > > to keep comm[16] as is and add a new pointer to the full name. The buffer
> > > for the long name might be dynamically allocated only when needed.
> > >
> >
> > That would add a new allocation in the fork() for the threads with a long name.
> > I'm not sure if it is worth it.
>
> The allocation will be done only when needed. IMHO, the performance is
> important only for userspace processes. I am not aware of any kernel
> subsystem that would heavily create and destroy kthreads.
>

XFS may create many kthreads with longer names, especially if there're
many partitions in the disk.
For example,
    xfs-reclaim/sd{a, b, c, ...}
    xfs-blockgc/sd{a, b, c, ...}
    xfs-inodegc/sd{a, b, c, ...}

They are supposed to be created at boot time, and shouldn't be heavily
created and destroyed.

>
> > > The pointer might be either in task_struct or struct kthread. It might
> > > be used the same way as the full name stored by workqueue kthreads.
> > >
> >
> > If we decide to do it like that, I think we'd better add it in
> > task_struct, then it will work for all tasks.
>
> Is it really needed for userspace processes? For example, ps shows
> the information from /proc/*/cmdline instead.
>

Right. The userspace processes can be obtained from /proc/*/cmdline.

>
> > > The advantage of the separate pointer:
> > >
> > >    + would work for names longer than 32
> > >    + will not open security holes in code
> > >
> >
> > Yes, those are the advantages.  And the disadvantage of it is:
> >
> >  - new allocation in fork()
>
> It should not be a problem if we do it only when necessary and only
> for kthreads.
>

So if no one against, I will do it in two steps,

1. Send the task comm cleanups in a separate patchset named "task comm cleanups"
    This patchset includes patch #1, #2, #4,  #5, #6, #7 and #9.
    Cleaning them up can make it less error prone, and it will be
helpful if we want to extend task comm in the future :)

2.  Keep the current comm[16] as-is and introduce a separate pointer
to store kthread's long name
     Now we only care about kthread, so we can put the pointer into a
kthread specific struct.
     For example in the struct kthread, or in kthread->data (which may
conflict with workqueue).

     And then dynamically allocate a longer name if it is truncated,
for example,
     __kthread_create_on_node
         len = vsnprintf(name, sizeof(name), namefmt, args);
         if (len >= TASK_COMM_LEN) {
             /* create a longer name */
         }

     And then we modify proc_task_name(), so the user can get
kthread's longer name via /proc/[pid]/comm.

     And then free the allocated memory when the kthread is destroyed.

--
Thanks
Yafang
