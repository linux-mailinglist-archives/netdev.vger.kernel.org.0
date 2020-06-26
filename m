Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D62D20BA33
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 22:22:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726034AbgFZUWR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 16:22:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbgFZUWQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 16:22:16 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14EF4C03E979;
        Fri, 26 Jun 2020 13:22:16 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id l6so9980662qkc.6;
        Fri, 26 Jun 2020 13:22:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IkGkXGsVlF8YAtrTLJ08heYqji9HN61SREZdAPXTiXE=;
        b=FtoaCFxdg1PumOIK43C7AwM+BpIBEA5FWkWQvOc3fxJP+xk82Eav5/+pf0l+uJGfD7
         ZZw3WvymAWU8jbz9VYMNojwTfLIKYyFvIOBEPTYcS8ivAViaynNzC8SxeMHOeBa/UoEe
         WjDhmu/d6glt7zSHXUNY+xUIXZ57TO4fQnORefboy+47OLF+6AuGN2Db/nL/1jO1mr8L
         1gV+tL1AibaUoqif5pOxQgf5pZEfoqRV4lr2EOWFhKyPh+9q3sEycWju8yPrzJ24UVaL
         hVJLJJsCsOLPfp/73DaZLh4OF5gb3sQV3ALC5RavpmDYqBDkVNm5syIeI4gzi0+pFF9i
         VycA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IkGkXGsVlF8YAtrTLJ08heYqji9HN61SREZdAPXTiXE=;
        b=FXHcKnGBk+iH5+6ew5QKUg/bClPGMhFcNzQlIcM67K1SRbmT8HYpwbzzN36ZGCQXUS
         OjUbNTWuiGyrD+XqMpHmnknQ4Gqd10bFwT9lnX9GVgB+iOo6jj91h/OGe1L7FTFydZnX
         RSgVvJJB4WW6AX4TR0n+hrV17W9UxxAUPeCFgMtRxOimVfn5jZsXYEB2hgbA6dTh1VEF
         i93Wvfkh9I8nxr302obVsjXuM7SD1shpQVaZgiF2WwmXkCrjtUEUFxksTS9Zuqggkiqe
         3davYDgU+0UzyP1iLyb14l5Y1aLuvPIdqDvZ1BZlaaai6Q3nl8TzMMrwKPlR+XpKDroR
         RBfA==
X-Gm-Message-State: AOAM530reoYDhz/D4jWx33uQ/uxw9IRW4JXqitdtOqyb11g+CqhsMNO8
        U9FmfAJuCczHzkhME+6j5qvOJpjJ6WGtUHkncYg=
X-Google-Smtp-Source: ABdhPJzq7gqIUCa5tRA8SEt84pn9vJMJY9oNKpFNTZ8baih7oWUXsfgE/kuHAfQGYzuGJ3pClJA5SzHF6Vyqy7oYH5M=
X-Received: by 2002:a05:620a:2409:: with SMTP id d9mr4702549qkn.36.1593202935341;
 Fri, 26 Jun 2020 13:22:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200626001332.1554603-1-songliubraving@fb.com>
 <20200626001332.1554603-3-songliubraving@fb.com> <CAEf4BzZ6-s-vqp+bLiCAVgS2kmp09a1WdaSvaL_jJySx7s7inA@mail.gmail.com>
In-Reply-To: <CAEf4BzZ6-s-vqp+bLiCAVgS2kmp09a1WdaSvaL_jJySx7s7inA@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 26 Jun 2020 13:22:03 -0700
Message-ID: <CAEf4BzZ-a1gB8wjf85n=EbRUETOgrhXHa_+vAXoEeFun5GTr=g@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 2/4] bpf: introduce helper bpf_get_task_stak()
To:     Song Liu <songliubraving@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Peter Ziljstra <peterz@infradead.org>,
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

On Fri, Jun 26, 2020 at 1:17 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Thu, Jun 25, 2020 at 5:14 PM Song Liu <songliubraving@fb.com> wrote:
> >
> > Introduce helper bpf_get_task_stack(), which dumps stack trace of given
> > task. This is different to bpf_get_stack(), which gets stack track of
> > current task. One potential use case of bpf_get_task_stack() is to call
> > it from bpf_iter__task and dump all /proc/<pid>/stack to a seq_file.
> >
> > bpf_get_task_stack() uses stack_trace_save_tsk() instead of
> > get_perf_callchain() for kernel stack. The benefit of this choice is that
> > stack_trace_save_tsk() doesn't require changes in arch/. The downside of
> > using stack_trace_save_tsk() is that stack_trace_save_tsk() dumps the
> > stack trace to unsigned long array. For 32-bit systems, we need to
> > translate it to u64 array.
> >
> > Signed-off-by: Song Liu <songliubraving@fb.com>
> > ---
>
> Looks great, I just think that there are cases where user doesn't
> necessarily has valid task_struct pointer, just pid, so would be nice
> to not artificially restrict such cases by having extra helper.
>
> Acked-by: Andrii Nakryiko <andriin@fb.com>

oh, please also fix a typo in the subject, it will make grepping more
frustrating

[...]
