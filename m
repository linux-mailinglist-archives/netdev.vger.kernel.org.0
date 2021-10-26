Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B64B443A9F8
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 03:53:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232818AbhJZBze (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 21:55:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230344AbhJZBzd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 21:55:33 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E7DFC061745;
        Mon, 25 Oct 2021 18:53:10 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id e144so18110182iof.3;
        Mon, 25 Oct 2021 18:53:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pTf4FChHrUD4zN63gzg0O6ODWycwCgp30B2Xd0Glbns=;
        b=EWg2KyQmct77jHNB7+PnJsR5QYD0vdGQG84gJNTqxm35zMsLVcN4d4NUAshVPeb0Xu
         a5c7tarSqasBeJQYH9r5mY8NKwzU3zla+91ow63jEb7FV8hb6VOXvwDWX7rIjm196ic5
         tj+uiO6RPpHmP1SfiDg4xSd0u+ECMvc6XqgFWIX7Q1gzlzGSjaTLGpQ0jICGmVt3ej+/
         eE+3QE61HjbTv2yTVo3bsR+st1KnKvUsWNfq91bUp5D4eS9PqSJ/LeG0aU3efIlUaydl
         y3qpBqrRK0evrLS49KyFPfMRUl/cnyWe8uaO9815cS3NRcLREF+xmXXDlOfrOws/VHWq
         rqaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pTf4FChHrUD4zN63gzg0O6ODWycwCgp30B2Xd0Glbns=;
        b=xsmhhFASi9czsUNHaWocg8NunUgNyoQzX6vjDQQaGAdI3AqMfqKFVL180ocXZJq4V9
         8W6dnQBagWKv++JzR4lG9xWa7N0aJoNsVV8mAOm9z/XS+6NzYyH7xr0ycHfSYfEmoxud
         Mdfhp5fJnFgFV7ike+u0PZCTJEGZagSrnHZykr25IIfDR7cy2FSlTKxH7KiDL4ujSmCD
         +02VBfieWl7pB2iieUkuCcLMif1LtwEwfQ3n/7DbqRnhMURycQUx45TMFB4D+OVmled+
         mDJvmT+z1HDIcxJvMZgzojBWQuca6GZZr97b7piE9tnkFsp+7iGqf24ovd3kH1vbBwow
         lmEA==
X-Gm-Message-State: AOAM533XIB9zFCHsNTW+Ic3uD1jyXRLIX18DOtkUALS3u9nYS2brtaDW
        uTmWyZmKTMoLgqrMJL1fJjFe92fPaMNPhG9EdXw=
X-Google-Smtp-Source: ABdhPJyIryqDVwlMvG5xY1qfmY9kjdTWxMdRzXGeuyZ0FRySrojjoK8/YOgWLBMhL8M3gQrLG+9seph0tIe9uWJHhj0=
X-Received: by 2002:a02:a483:: with SMTP id d3mr3861810jam.23.1635213189854;
 Mon, 25 Oct 2021 18:53:09 -0700 (PDT)
MIME-Version: 1.0
References: <20211025083315.4752-1-laoar.shao@gmail.com> <20211025083315.4752-5-laoar.shao@gmail.com>
 <202110251415.9AD37837@keescook>
In-Reply-To: <202110251415.9AD37837@keescook>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Tue, 26 Oct 2021 09:52:34 +0800
Message-ID: <CALOAHbDyo1H7hg__h+aCHCa-BZX5z=wtfM+cc+gNSj+4U9nRUQ@mail.gmail.com>
Subject: Re: [PATCH v6 04/12] drivers/infiniband: make setup_ctxt always get a
 nul terminated task comm
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

On Tue, Oct 26, 2021 at 5:16 AM Kees Cook <keescook@chromium.org> wrote:
>
> On Mon, Oct 25, 2021 at 08:33:07AM +0000, Yafang Shao wrote:
> > Use strscpy_pad() instead of strlcpy() to make the comm always nul
> > terminated. As the comment above the hard-coded 16, we can replace it
> > with TASK_COMM_LEN, then it will adopt to the comm size change.
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
> > ---
> >  drivers/infiniband/hw/qib/qib.h          | 2 +-
> >  drivers/infiniband/hw/qib/qib_file_ops.c | 2 +-
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/infiniband/hw/qib/qib.h b/drivers/infiniband/hw/qib/qib.h
> > index 9363bccfc6e7..a8e1c30c370f 100644
> > --- a/drivers/infiniband/hw/qib/qib.h
> > +++ b/drivers/infiniband/hw/qib/qib.h
> > @@ -196,7 +196,7 @@ struct qib_ctxtdata {
> >       pid_t pid;
> >       pid_t subpid[QLOGIC_IB_MAX_SUBCTXT];
> >       /* same size as task_struct .comm[], command that opened context */
> > -     char comm[16];
> > +     char comm[TASK_COMM_LEN];
> >       /* pkeys set by this use of this ctxt */
> >       u16 pkeys[4];
> >       /* so file ops can get at unit */
> > diff --git a/drivers/infiniband/hw/qib/qib_file_ops.c b/drivers/infiniband/hw/qib/qib_file_ops.c
> > index 63854f4b6524..7ab2b448c183 100644
> > --- a/drivers/infiniband/hw/qib/qib_file_ops.c
> > +++ b/drivers/infiniband/hw/qib/qib_file_ops.c
> > @@ -1321,7 +1321,7 @@ static int setup_ctxt(struct qib_pportdata *ppd, int ctxt,
> >       rcd->tid_pg_list = ptmp;
> >       rcd->pid = current->pid;
> >       init_waitqueue_head(&dd->rcd[ctxt]->wait);
> > -     strlcpy(rcd->comm, current->comm, sizeof(rcd->comm));
> > +     strscpy_pad(rcd->comm, current->comm, sizeof(rcd->comm));
>
> This should use (the adjusted) get_task_comm() instead of leaving this
> open-coded.
>

Sure, that is better.

> >       ctxt_fp(fp) = rcd;
> >       qib_stats.sps_ctxts++;
> >       dd->freectxts--;
> > --
> > 2.17.1
> >
>
> --
> Kees Cook



-- 
Thanks
Yafang
