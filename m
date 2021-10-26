Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF6143A9E1
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 03:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233004AbhJZBw3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 21:52:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232987AbhJZBw2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 21:52:28 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 569F4C061745;
        Mon, 25 Oct 2021 18:50:05 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id b188so18085760iof.8;
        Mon, 25 Oct 2021 18:50:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ScHBEadlhvXJ5Ux51PKGxkHvsss0u6ctZT9nDJJQkzo=;
        b=Fx3ncUFZI8yO/PIUnaTNHz3IQgwVf1ec+igHEUtG3eIgKmfEYkRxJ6PWm0JQb9GuQJ
         aqs6xn44Rv1O5XW7VtN12VrTzhCaxBKC/PfNYDPfSoQub3BKKrGzdA+xia0FajoLpQUK
         gzWEKPB8cTjG/Y3XWkseihPfESzdoqy8tamnEgt/HF3kyWah44FujLVdRiQxa/nGOPqv
         V5X/RrU4l8zTncHMniSEs0frs++vuQNQDCHyvaBvwk6dtm8J5u9o73bEldNgR2ahmq5d
         vlDlYx7m4s4bXuNDVRCAFpjVAV9R7u69MCBK/1f4NJfFQ+r+FWxEU1+h/LLaXSTQpq6c
         k+oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ScHBEadlhvXJ5Ux51PKGxkHvsss0u6ctZT9nDJJQkzo=;
        b=GzjhHSD3Mo9mJvhSyUmQOctOHEnlKq3VLl2b9kfpXoTUHrMvvYQsFn3QMso+6cpuZ0
         Wv6haSwgtTbps6gykSYlaaVlwBXB32qu60ddhp7+Xe8zyT1LpYcvvKPEsUvWm4ebs3Pc
         5uw/pWx1fiS8cEWxeoawddGG1KRZBkpuef6SMy5zL5X/BlCvorLoWjAIQUotY87qvbRI
         q6IU27sjFuheFjhtSuK+k+TeCZeqdypzjZk3HZFJ9tDiAhDo52ARjdA2Ktd452kvv+KH
         CQ2MIHfBWI9OIXMJXPbghcjcxVT41MxVyo5weQYr55Do4WWQAHmUoC50uY09hnYx/Dzl
         YzWg==
X-Gm-Message-State: AOAM532kFIog0LmLXhKCro9EcBy9CcLC85csM9djXgF7yzka9Zv7vB6S
        XZdFWz3BhQvgH9z4AMOICYNhHT/uHbDOyts+JYs=
X-Google-Smtp-Source: ABdhPJweqQlORvX/kcER+dfOkqBBAlDqGVNYLVFUw0Z1O7FC8HmC4bC+PzzQe5iYslImeJRoEVpzyLvNvGA91aU5hCs=
X-Received: by 2002:a05:6602:2e05:: with SMTP id o5mr12805350iow.204.1635213004755;
 Mon, 25 Oct 2021 18:50:04 -0700 (PDT)
MIME-Version: 1.0
References: <20211025083315.4752-1-laoar.shao@gmail.com> <20211025083315.4752-3-laoar.shao@gmail.com>
 <202110251408.2E661E70BC@keescook>
In-Reply-To: <202110251408.2E661E70BC@keescook>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Tue, 26 Oct 2021 09:49:28 +0800
Message-ID: <CALOAHbAf2LrHMWfHwRvSkgw2BLYcKUr6y8sxpSGvrQ2ORCD2Dw@mail.gmail.com>
Subject: Re: [PATCH v6 02/12] fs/exec: make __get_task_comm always get a nul
 terminated string
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

On Tue, Oct 26, 2021 at 5:08 AM Kees Cook <keescook@chromium.org> wrote:
>
> On Mon, Oct 25, 2021 at 08:33:05AM +0000, Yafang Shao wrote:
> > If the dest buffer size is smaller than sizeof(tsk->comm), the buffer
> > will be without null ternimator, that may cause problem. We can make sure
> > the buffer size not smaller than comm at the callsite to avoid that
> > problem, but there may be callsite that we can't easily change.
> >
> > Using strscpy_pad() instead of strncpy() in __get_task_comm() can make
> > the string always nul ternimated.
> >
> > Suggested-by: Kees Cook <keescook@chromium.org>
> > Suggested-by: Steven Rostedt <rostedt@goodmis.org>
> > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> > Cc: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
> > Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> > Cc: Al Viro <viro@zeniv.linux.org.uk>
> > Cc: Kees Cook <keescook@chromium.org>
> > Cc: Petr Mladek <pmladek@suse.com>
> > ---
> >  fs/exec.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/exec.c b/fs/exec.c
> > index 404156b5b314..bf2a7a91eeea 100644
> > --- a/fs/exec.c
> > +++ b/fs/exec.c
> > @@ -1209,7 +1209,8 @@ static int unshare_sighand(struct task_struct *me)
> >  char *__get_task_comm(char *buf, size_t buf_size, struct task_struct *tsk)
> >  {
> >       task_lock(tsk);
> > -     strncpy(buf, tsk->comm, buf_size);
> > +     /* The copied value is always null terminated */
>
> This may could say "always NUL terminated and zero-padded"
>

Sure. I will change it.

> > +     strscpy_pad(buf, tsk->comm, buf_size);
> >       task_unlock(tsk);
> >       return buf;
> >  }
> > --
> > 2.17.1
> >
>
> But for the replacement with strscpy_pad(), yes please:
>
> Reviewed-by: Kees Cook <keescook@chromium.org>
>
>
> --
> Kees Cook



-- 
Thanks
Yafang
