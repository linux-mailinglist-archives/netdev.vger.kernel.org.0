Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F14420B9E7
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 22:06:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726007AbgFZUGO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 16:06:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725803AbgFZUGN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 16:06:13 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0B8AC03E979;
        Fri, 26 Jun 2020 13:06:13 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id z2so8433452qts.5;
        Fri, 26 Jun 2020 13:06:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+JSEMagOzupfCAAdnbVKD4lMobhxRLkVJsl3yNBDaoE=;
        b=kaKkyZ9IJMgGkOwaEX0K6IT1QqedlSZCO6hJb07XRS/xHROlFY30H1u7ELJu0scHva
         VyG0iWpC0GdS+k0n5SwdKPS7S9K6x35T9hIGf844SJlaro29TWn1IFbzA+tuNvyQZOqv
         +DNT7gRwC8maXhBhbL8hhkxD35uKprnHh83Vr0wMftkPMNUSSEtEqkFe5iey8vCx0G8f
         CxAMQX6Z1RTNW7Tz/VG+3UYVFUMaBHIK0bVD1g3ML0xQE2IBkAH+RBkZfmogFblUwiIr
         gL6TnsymdGDBdjDQEsCPB/Lxy9S5G3iqDbt3DzMXT9jV2Mtt75thU5HbWMqUx5WhdDst
         oWHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+JSEMagOzupfCAAdnbVKD4lMobhxRLkVJsl3yNBDaoE=;
        b=TR3m6A28jL56afRBAn/o9yX5tKB+Vr7a0Glh8Z2aexXU3A0C0r47XCX22eK0gdzR7C
         F6o4z+ok1woFaqXeg1SGPK22k+Ab6nz6lQ07PQQ+IMDjT8EjX9JJGu0kUfafaxjTTLnJ
         QIQYjB8v8sa7YQ65RJXr0wPDv40HRWxK4xbeq7zF7t6IM4SjJXrsNslKnaxU2sv2ebMw
         vxx/u2RlkI69NKl0HoFhV6ews7Z4S+X0GJSyt6TynqfdNR8lzS3ltatCcR0QeKjcvbpK
         A4EcoLl2sWU7GMrLANp3as/TsTD7wFhE6SdOx+DR5LcY3oll4leUxkWjKIQvisIR2FWc
         15kQ==
X-Gm-Message-State: AOAM531ZG7kWgb/kMaUKc8YTnf7bzw66YwKJzf6HanSM1DZ6KVFBlqVc
        NtInz+D+uq18XmJf/HZrLWnL3/Z3mHnbAtRpgwQ=
X-Google-Smtp-Source: ABdhPJwPd00euphLZR1AATbItCjo8QAECWnT2CNBGYARmZVXEwCzlpL9TrwHvcVzhsTH46lRPy97Huzu8376JtUvyEw=
X-Received: by 2002:aed:2cc5:: with SMTP id g63mr4513062qtd.59.1593201972949;
 Fri, 26 Jun 2020 13:06:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200626001332.1554603-1-songliubraving@fb.com>
 <20200626001332.1554603-2-songliubraving@fb.com> <20200626110046.GB4817@hirez.programming.kicks-ass.net>
In-Reply-To: <20200626110046.GB4817@hirez.programming.kicks-ass.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 26 Jun 2020 13:06:01 -0700
Message-ID: <CAEf4BzbgyBWpHdxe8LdHp+48fazS6JLEdaEd09p40s=+cy4Phw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 1/4] perf: export get/put_chain_entry()
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Song Liu <songliubraving@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 26, 2020 at 5:10 AM Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Thu, Jun 25, 2020 at 05:13:29PM -0700, Song Liu wrote:
> > This would be used by bpf stack mapo.
>
> Would it make sense to sanitize the API a little before exposing it?
>
> diff --git a/kernel/events/callchain.c b/kernel/events/callchain.c
> index 334d48b16c36..016894b0d2c2 100644
> --- a/kernel/events/callchain.c
> +++ b/kernel/events/callchain.c
> @@ -159,8 +159,10 @@ static struct perf_callchain_entry *get_callchain_entry(int *rctx)
>                 return NULL;
>
>         entries = rcu_dereference(callchain_cpus_entries);
> -       if (!entries)
> +       if (!entries) {
> +               put_recursion_context(this_cpu_ptr(callchain_recursion), rctx);
>                 return NULL;
> +       }
>
>         cpu = smp_processor_id();
>
> @@ -183,12 +185,9 @@ get_perf_callchain(struct pt_regs *regs, u32 init_nr, bool kernel, bool user,
>         int rctx;
>
>         entry = get_callchain_entry(&rctx);
> -       if (rctx == -1)
> +       if (!entry || rctx == -1)
>                 return NULL;
>

isn't rctx == -1 check here not necessary anymore? Seems like
get_callchain_entry() will always return NULL if rctx == -1?

> -       if (!entry)
> -               goto exit_put;
> -
>         ctx.entry     = entry;
>         ctx.max_stack = max_stack;
>         ctx.nr        = entry->nr = init_nr;
