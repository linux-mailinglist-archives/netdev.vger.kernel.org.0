Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8945443A9E8
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 03:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233641AbhJZBxn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 21:53:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231971AbhJZBxm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 21:53:42 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1E94C061745;
        Mon, 25 Oct 2021 18:51:19 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id o184so18129230iof.6;
        Mon, 25 Oct 2021 18:51:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M+TEaQB1KaSOudASCPt2E3PS4ymJyoJAqUYafZ8gI7E=;
        b=oL8HHOwwrFG5e/LmuN4agIcEJfacHoUr4ai/CCnAQSW/UKvac/ju9Spl9S9IctkdMV
         u0xR2bACpUqrjpo/d3B+q1N6PyNK5ARQbG4fte2a2ZeidUraP8oLilSHNXEM9gU0CM+I
         SbO2q5cPvNWPOqMrm+ujryeD7OZDrL2sot8WITIksRGltQ4ED6m5RR4JvhnniPEr0cIJ
         1JuVaVB6Rv7gWKPXWYUWuUxracYP9X5Yyy77zUMhI1TK6oK1YwDlTQ+j3ASsLa/eokld
         MkDGJwXZSGj2b87w6vxWYa8EEp7aHhVpWjIf4Q3+7yIsWlT4MlYFozO9j7Xg4hpf4VFu
         u+jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=M+TEaQB1KaSOudASCPt2E3PS4ymJyoJAqUYafZ8gI7E=;
        b=qfJnDPw8lTYjHE8ocNM48qavwlU/an4GeU2JrC8jppYMH0eSV9jsJ5tOy5puLTrhBc
         StaW2nJoDs2GVMEeFbQfz8B+7gUNQXd44FcA4gq6DUh7zQHA/bd2pAu7zjOpyITPeAzQ
         YGPMdxNfxlw66Q100l8glUhizE+I0zGbazaLkFgwsVUGMhMSY21TxZrG+Wj8LndkDdmY
         SaVmIcVhI3pxe8IYciO9FO2ixEK3xultBy6w+BDsK4y5hkCDOAhA1kbFSXZMBe+rVP+X
         mfAljVJGJ6NGcgJjNC6L7ckBI/gu1/OXeBIsrWQaRu5/vBKvK7LbLp870yzbrTqxtO4s
         6FEg==
X-Gm-Message-State: AOAM530a+IWBGYvHyKT5d5FPDnn5LIOXt6EwDwWzait7qB1l0ui4xsJx
        5z0Vsh2Qs/Hkq7i90P9askt6bevqr/v3Jd7spwo=
X-Google-Smtp-Source: ABdhPJzo8Pl2UbPecXV9ZclgT3FzrihDFm7Isxsh4OePzHurnJ+maCBZCvaVaerHAt6wvuSmpFvZzPlkXSA+3EMqRwA=
X-Received: by 2002:a5d:9493:: with SMTP id v19mr13031702ioj.34.1635213079114;
 Mon, 25 Oct 2021 18:51:19 -0700 (PDT)
MIME-Version: 1.0
References: <20211025083315.4752-1-laoar.shao@gmail.com> <20211025083315.4752-4-laoar.shao@gmail.com>
 <202110251411.93B477676B@keescook>
In-Reply-To: <202110251411.93B477676B@keescook>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Tue, 26 Oct 2021 09:50:43 +0800
Message-ID: <CALOAHbBwRcZoRteU7qL7rdip=cbTHc3n6-eJrd6xUoeJ+Win6Q@mail.gmail.com>
Subject: Re: [PATCH v6 03/12] drivers/connector: make connector comm always
 nul ternimated
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
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Vladimir Zapolskiy <vzapolskiy@gmail.com>,
        David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 26, 2021 at 5:14 AM Kees Cook <keescook@chromium.org> wrote:
>
> On Mon, Oct 25, 2021 at 08:33:06AM +0000, Yafang Shao wrote:
> > connector comm was introduced in commit
> > f786ecba4158 ("connector: add comm change event report to proc connector").
> > struct comm_proc_event was defined in include/linux/cn_proc.h first and
> > then been moved into file include/uapi/linux/cn_proc.h in commit
> > 607ca46e97a1 ("UAPI: (Scripted) Disintegrate include/linux").
> >
> > As this is the UAPI code, we can't change it without potentially breaking
> > things (i.e. userspace binaries have this size built in, so we can't just
> > change the size). To prepare for the followup change - extending task
> > comm, we have to use __get_task_comm() to avoid the BUILD_BUG_ON() in
> > proc_comm_connector().
>
> I wonder, looking at this again, if it might make more sense to avoid
> this cn_proc.c change, and instead, adjust get_task_comm() like so:
>
> #define get_task_comm(buf, tsk)
>         __get_task_comm(buf, __must_be_array(buf) + sizeof(buf), tsk)
>
> This would still enforce the original goal of making sure
> get_task_comm() is being used on a char array, and now that
> __get_task_comm() will truncate & pad, it's safe to use on both
> too-small and too-big arrays.
>

It Makes sense to me.  I will do it as you suggested.

-- 
Thanks
Yafang
