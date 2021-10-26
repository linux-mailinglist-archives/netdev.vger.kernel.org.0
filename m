Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E88043B38B
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 16:03:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236311AbhJZOFk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 10:05:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230119AbhJZOFg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 10:05:36 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE0E2C061745;
        Tue, 26 Oct 2021 07:03:12 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id y67so20530792iof.10;
        Tue, 26 Oct 2021 07:03:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jiKBRIJ90WYjcORFiV3ORltYZSK2q2sAgdSrdSfFfbc=;
        b=B5oi/7UCVk36Kltqk5jv0UWKsgnlcJbT+p8jfJZ/39b+wWQ3ihMQCSae2vo2AfNYOV
         rGFEUlC++DoWLCCqPMJWHJOt1HSJyZFJtvVv49eAiawK7btNdoGSa1NDCwrmtXk1QKNU
         vSBGb2llMudk+OZOc4MAqtj9ZyDt/GRG5Xmh0lZMLJUQfXLqcWmfnbKyPUvZsUevSp7r
         Uav5pLsgxuo7NBSBiLlXImmOZ8jx2FcsOPxBS44VwbmHXKYUQ4BPjNlZX9zlsc+Tru3f
         yRRWGvhcXHKmK3hoxpjQGpduRdkJH6Mb3jiEyDSm0HHk/BZg1ycg8Ak+iPaRmnDBUB5W
         DujA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jiKBRIJ90WYjcORFiV3ORltYZSK2q2sAgdSrdSfFfbc=;
        b=JKmwxkkuMTKXFa90Thvjdh0ADxxPITJbFnr9TxxQpGIOeClQzQjWpmyC4sAWRawLGJ
         UzNthgk5zd74rGJTOH4bwhuOUsDDsU9rLlXtFXsONRNuIj7CDlSnkPYa8b7+1aQ9fMtB
         OrZFOKemdfjfg5j6h9d3S9/2stCoILE7UY9qmrNlefSP8xOQW+7eN+34/rAYuFK0Xg7N
         wtDu695kVwfiwmpjHz5x5PzL14+HUbZm7YXbtxD7+0ZqIW6+UnH5QIOqCgToqHfTBs/N
         JKu0W7Rv1zVFpMJr6+a5pqcfKQrrq8mAMv7Ix4Q2u85hVOPFyYHwXpRox4Z9AvacDDiG
         i3QQ==
X-Gm-Message-State: AOAM531ZEV9xo19PMmyMOejzjjpz5FduXyXAymyzOSyTQctKxHvf3xsQ
        4Sh6s3VSDgjC5PogcEDBQm8eDakQ8rVMUrAAtog=
X-Google-Smtp-Source: ABdhPJxnJMo1zj33+9fiUewOfzyLCzx56/LSGr86u1/7PYep88hWbWvGY1Pv8LiKwv9ITmco8NPZCwRW9GVoSd8560c=
X-Received: by 2002:a05:6638:2257:: with SMTP id m23mr249515jas.139.1635256992171;
 Tue, 26 Oct 2021 07:03:12 -0700 (PDT)
MIME-Version: 1.0
References: <20211025083315.4752-1-laoar.shao@gmail.com> <20211025083315.4752-9-laoar.shao@gmail.com>
 <202110251421.7056ACF84@keescook> <CALOAHbDPs-pbr5CnmuRv+b+CgMdEkzi4Yr2fSO9pKCE-chr3Yg@mail.gmail.com>
 <20211026091211.569a7ba2@gandalf.local.home> <CALOAHbBAKqbZEMvk5PVMrqFR_kjbi_kotGTNTGEW+=JWnC+_uA@mail.gmail.com>
In-Reply-To: <CALOAHbBAKqbZEMvk5PVMrqFR_kjbi_kotGTNTGEW+=JWnC+_uA@mail.gmail.com>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Tue, 26 Oct 2021 22:02:36 +0800
Message-ID: <CALOAHbAa-iMD4k2DEOun+RivUXiSMKR6ndCsqGZMseUbX_9+ww@mail.gmail.com>
Subject: Re: [PATCH v6 08/12] tools/bpf/bpftool/skeleton: make it adopt to
 task comm size change
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Petr Mladek <pmladek@suse.com>,
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
        kbuild test robot <lkp@intel.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 26, 2021 at 9:55 PM Yafang Shao <laoar.shao@gmail.com> wrote:
>
> On Tue, Oct 26, 2021 at 9:12 PM Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > On Tue, 26 Oct 2021 10:18:51 +0800
> > Yafang Shao <laoar.shao@gmail.com> wrote:
> >
> > > > So, if we're ever going to copying these buffers out of the kernel (I
> > > > don't know what the object lifetime here in bpf is for "e", etc), we
> > > > should be zero-padding (as get_task_comm() does).
> > > >
> > > > Should this, instead, be using a bounce buffer?
> > >
> > > The comment in bpf_probe_read_kernel_str_common() says
> > >
> > >   :      /*
> > >   :       * The strncpy_from_kernel_nofault() call will likely not fill the
> > >   :       * entire buffer, but that's okay in this circumstance as we're probing
> > >   :       * arbitrary memory anyway similar to bpf_probe_read_*() and might
> > >   :       * as well probe the stack. Thus, memory is explicitly cleared
> > >   :       * only in error case, so that improper users ignoring return
> > >   :       * code altogether don't copy garbage; otherwise length of string
> > >   :       * is returned that can be used for bpf_perf_event_output() et al.
> > >   :       */
> > >
> > > It seems that it doesn't matter if the buffer is filled as that is
> > > probing arbitrary memory.
> > >
> > > >
> > > > get_task_comm(comm, task->group_leader);
> > >
> > > This helper can't be used by the BPF programs, as it is not exported to BPF.
> > >
> > > > bpf_probe_read_kernel_str(&e.comm, sizeof(e.comm), comm);
> >
> > I guess Kees is worried that e.comm will have something exported to user
> > space that it shouldn't. But since e is part of the BPF program, does the
> > BPF JIT take care to make sure everything on its stack is zero'd out, such
> > that a user BPF couldn't just read various items off its stack and by doing
> > so, see kernel memory it shouldn't be seeing?
> >
>

Ah, you mean the BPF JIT has already avoided leaking information to user.
I will check the BPF JIT code first.

> Understood.
> It can leak information to the user if the user buffer is large enough.
>
>
> > I'm guessing it does, otherwise this would be a bigger issue than this
> > patch series.
> >
>
> I will think about how to fix it.
> At first glance, it seems we'd better introduce a new BPF helper like
> bpf_probe_read_kernel_str_pad().
>
> --
> Thanks
> Yafang



-- 
Thanks
Yafang
