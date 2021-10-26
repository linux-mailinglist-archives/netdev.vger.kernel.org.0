Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38C9443B36C
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 15:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236312AbhJZN7D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 09:59:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236305AbhJZN6z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 09:58:55 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55263C061767;
        Tue, 26 Oct 2021 06:56:31 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id 188so20463374iou.12;
        Tue, 26 Oct 2021 06:56:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OCNly9Pv6GVtqK5WKlYGGpWZ1IwDTUSNcWIUnGMQ4tQ=;
        b=i7RAxoJj6vRHJO/QOSjI/2wZP40Tm49lxjwUghVRA9loicQXFZNhM0MArl94d+vLjQ
         3ONCBgOGm6/Tzkk6/rbzph3fyWGtvF06KCpw5TQuJV+IYTHQLBvZq/yAsOXYH5zO2znh
         0zjKS2Yzo3vcuKLciR7vPdHTMj2n1hFo604EAkwzdVdDIC4TDCtH88vI9tlkTdFe6ovD
         fUtyJV7cBcB5modNsKwvWcaeO4hCblmIqUYnQtEfhNC7w/zLGp7dGfWhIz6QBgu1TWLw
         8Ux1Iqr2m7VjjSxbnvmsTLhMEWmkZE4cIbSrm9U8IZMkRyp3VWpS9uj1z99yX47jDUJn
         YTpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OCNly9Pv6GVtqK5WKlYGGpWZ1IwDTUSNcWIUnGMQ4tQ=;
        b=8FWOAAlleloW0xhPMxL+6GS5BexHx48d5GFmrTfGRKL214YQ4qDtQcHro6mpZHRT/f
         I/SychaEi7/a5YqNF2c3brqa5DsCp5V3ufu6zxcbPsMGFPk6fFukNH0vgLEf5HA+g6zn
         B3O1AtvPLmVFMzTybzBBt+jFq/2Y/MLH/gkoSFAMJ/uFx8Wbk3Ahy7sI4KwcZP3FP1Rb
         GNLExtKQUXIGtPUSBxl6oiQttRV1xWqLNnMbDBo60TwO7nRGDPh9/q1WOQ2TTv1f91HY
         o7eUwun0cj129c0D1qmMKl7J2fBAyxSXjh7yyKxtwCaWwX4TJrg4Ijo1CJXGWe5pcl2L
         nRyA==
X-Gm-Message-State: AOAM532aw9v9bPEw3Mmnx6gT5nYW8jfDHqwZk4ykigptZjjYWbeDRJGZ
        lIMQoS0R4Md0VIfAgzsNjaN8U6nKj1tjHSuPjDg=
X-Google-Smtp-Source: ABdhPJw6DOg4zAXK3lnhpAIkXs7o2KoNL0GRJkIrWvXjuD/QZ3ItZtbM3RgVBE1XgEfOYoA0wxJIHxgbtWr7mAbD35g=
X-Received: by 2002:a02:a483:: with SMTP id d3mr6171868jam.23.1635256590773;
 Tue, 26 Oct 2021 06:56:30 -0700 (PDT)
MIME-Version: 1.0
References: <20211025083315.4752-1-laoar.shao@gmail.com> <20211025083315.4752-9-laoar.shao@gmail.com>
 <202110251421.7056ACF84@keescook> <CALOAHbDPs-pbr5CnmuRv+b+CgMdEkzi4Yr2fSO9pKCE-chr3Yg@mail.gmail.com>
 <20211026091211.569a7ba2@gandalf.local.home>
In-Reply-To: <20211026091211.569a7ba2@gandalf.local.home>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Tue, 26 Oct 2021 21:55:54 +0800
Message-ID: <CALOAHbBAKqbZEMvk5PVMrqFR_kjbi_kotGTNTGEW+=JWnC+_uA@mail.gmail.com>
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

On Tue, Oct 26, 2021 at 9:12 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Tue, 26 Oct 2021 10:18:51 +0800
> Yafang Shao <laoar.shao@gmail.com> wrote:
>
> > > So, if we're ever going to copying these buffers out of the kernel (I
> > > don't know what the object lifetime here in bpf is for "e", etc), we
> > > should be zero-padding (as get_task_comm() does).
> > >
> > > Should this, instead, be using a bounce buffer?
> >
> > The comment in bpf_probe_read_kernel_str_common() says
> >
> >   :      /*
> >   :       * The strncpy_from_kernel_nofault() call will likely not fill the
> >   :       * entire buffer, but that's okay in this circumstance as we're probing
> >   :       * arbitrary memory anyway similar to bpf_probe_read_*() and might
> >   :       * as well probe the stack. Thus, memory is explicitly cleared
> >   :       * only in error case, so that improper users ignoring return
> >   :       * code altogether don't copy garbage; otherwise length of string
> >   :       * is returned that can be used for bpf_perf_event_output() et al.
> >   :       */
> >
> > It seems that it doesn't matter if the buffer is filled as that is
> > probing arbitrary memory.
> >
> > >
> > > get_task_comm(comm, task->group_leader);
> >
> > This helper can't be used by the BPF programs, as it is not exported to BPF.
> >
> > > bpf_probe_read_kernel_str(&e.comm, sizeof(e.comm), comm);
>
> I guess Kees is worried that e.comm will have something exported to user
> space that it shouldn't. But since e is part of the BPF program, does the
> BPF JIT take care to make sure everything on its stack is zero'd out, such
> that a user BPF couldn't just read various items off its stack and by doing
> so, see kernel memory it shouldn't be seeing?
>

Understood.
It can leak information to the user if the user buffer is large enough.


> I'm guessing it does, otherwise this would be a bigger issue than this
> patch series.
>

I will think about how to fix it.
At first glance, it seems we'd better introduce a new BPF helper like
bpf_probe_read_kernel_str_pad().

-- 
Thanks
Yafang
