Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72B8843AA34
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 04:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233806AbhJZCVy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 22:21:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233654AbhJZCVv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 22:21:51 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C33CAC061745;
        Mon, 25 Oct 2021 19:19:27 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id 188so18133680iou.12;
        Mon, 25 Oct 2021 19:19:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=k0RKbIIOqMFBOFiljOedZCbcAtZDA7g3jIfQe8Pm7Ic=;
        b=aoW6OTWlAGkoz5LLHjyuVeW61Uayophh62a+WB1/EWekYjdNjm+OIaF6sEZbcWwtwX
         occKhayjuggtGGnbc1xtLBNL5iw9jX+AIJgBpx9pJ/auW3IzdhtWxC9PkKi8+lo/GH4X
         fmGQ/4mcxJm6+UPYs4eeeYv1A24KKwMjyYuQm6r9b4M+K2F59SwhVyjt/0obUWXvgU9G
         QSYGUm2Jy8+JqhNZIYz14iZeOnC6WpXwOsOgQZPg5fBOia66yMZPK2tfUGrWI63BKu/8
         zXFs+Oo6I+YPCihBQeMLpcZtxy0SDmKd74abqUCteI5tzt/DBWYOVurt9Pu8bsYf5WgH
         tcVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=k0RKbIIOqMFBOFiljOedZCbcAtZDA7g3jIfQe8Pm7Ic=;
        b=O1A8EHBhM9PYvqGCIhFmRbs6a2oaY0MZ92uIFqggEWOWRc4gJl/lR6usAmrbaI0YZR
         2/txoHu5AAurqG2GTmzyiNHERxJjlHnmUAlwXJLLi80kLdAF8tL7P8SM52x2gKBn03pJ
         EJ0sa9o2EhRUzbbFpXH6D7JGx1AbbKeCTF8I9W7HL6NUYHlcBJtEakFzgBQBcRVGO6w+
         Td4z6AIqWhPsP2iM+jF07QBukmgFcNZuXhFHAZks/MD8XCTU+wtgU19+whFfgm46yRmb
         m8wjR39Zqy/eHHO7Z+NzTLdMflUukDZXjWI48Y0ZHh8tZBvrqpTgK1yxQltgV7YUZime
         3wzw==
X-Gm-Message-State: AOAM531aS917tRRUlY9YqIrxUeS4c9mCjkm6dW7kAXcHIqlV+zioXQo0
        apKHT2EcRE+qRDtChjVcIPerVRsPuiQxBx7S9tU=
X-Google-Smtp-Source: ABdhPJwrAN4fbPYm/5hVv3F2xPLmeiEevoR0k3peWC93PQke/ju+UCPMkqMqGcfkxXu+OioRuTJdpiYFOpyzOJm9wqw=
X-Received: by 2002:a05:6638:1607:: with SMTP id x7mr12892000jas.128.1635214767233;
 Mon, 25 Oct 2021 19:19:27 -0700 (PDT)
MIME-Version: 1.0
References: <20211025083315.4752-1-laoar.shao@gmail.com> <20211025083315.4752-9-laoar.shao@gmail.com>
 <202110251421.7056ACF84@keescook>
In-Reply-To: <202110251421.7056ACF84@keescook>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Tue, 26 Oct 2021 10:18:51 +0800
Message-ID: <CALOAHbDPs-pbr5CnmuRv+b+CgMdEkzi4Yr2fSO9pKCE-chr3Yg@mail.gmail.com>
Subject: Re: [PATCH v6 08/12] tools/bpf/bpftool/skeleton: make it adopt to
 task comm size change
To:     Kees Cook <keescook@chromium.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
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

On Tue, Oct 26, 2021 at 5:24 AM Kees Cook <keescook@chromium.org> wrote:
>
> On Mon, Oct 25, 2021 at 08:33:11AM +0000, Yafang Shao wrote:
> > bpf_probe_read_kernel_str() will add a nul terminator to the dst, then
> > we don't care about if the dst size is big enough.
> >
> > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> > Cc: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
> > Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> > Cc: Al Viro <viro@zeniv.linux.org.uk>
> > Cc: Kees Cook <keescook@chromium.org>
> > Cc: Petr Mladek <pmladek@suse.com>
>
> So, if we're ever going to copying these buffers out of the kernel (I
> don't know what the object lifetime here in bpf is for "e", etc), we
> should be zero-padding (as get_task_comm() does).
>
> Should this, instead, be using a bounce buffer?

The comment in bpf_probe_read_kernel_str_common() says

  :      /*
  :       * The strncpy_from_kernel_nofault() call will likely not fill the
  :       * entire buffer, but that's okay in this circumstance as we're probing
  :       * arbitrary memory anyway similar to bpf_probe_read_*() and might
  :       * as well probe the stack. Thus, memory is explicitly cleared
  :       * only in error case, so that improper users ignoring return
  :       * code altogether don't copy garbage; otherwise length of string
  :       * is returned that can be used for bpf_perf_event_output() et al.
  :       */

It seems that it doesn't matter if the buffer is filled as that is
probing arbitrary memory.

>
> get_task_comm(comm, task->group_leader);

This helper can't be used by the BPF programs, as it is not exported to BPF.

> bpf_probe_read_kernel_str(&e.comm, sizeof(e.comm), comm);
>
> -Kees
>
> > ---
> >  tools/bpf/bpftool/skeleton/pid_iter.bpf.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/tools/bpf/bpftool/skeleton/pid_iter.bpf.c b/tools/bpf/bpftool/skeleton/pid_iter.bpf.c
> > index d9b420972934..f70702fcb224 100644
> > --- a/tools/bpf/bpftool/skeleton/pid_iter.bpf.c
> > +++ b/tools/bpf/bpftool/skeleton/pid_iter.bpf.c
> > @@ -71,8 +71,8 @@ int iter(struct bpf_iter__task_file *ctx)
> >
> >       e.pid = task->tgid;
> >       e.id = get_obj_id(file->private_data, obj_type);
> > -     bpf_probe_read_kernel(&e.comm, sizeof(e.comm),
> > -                           task->group_leader->comm);
> > +     bpf_probe_read_kernel_str(&e.comm, sizeof(e.comm),
> > +                               task->group_leader->comm);
> >       bpf_seq_write(ctx->meta->seq, &e, sizeof(e));
> >
> >       return 0;
> > --
> > 2.17.1
> >
>
> --
> Kees Cook



-- 
Thanks
Yafang
