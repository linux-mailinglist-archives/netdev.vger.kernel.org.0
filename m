Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F39C9221C33
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 07:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726525AbgGPFz3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 01:55:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725844AbgGPFz3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 01:55:29 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 033E6C061755;
        Wed, 15 Jul 2020 22:55:28 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id x62so4048100qtd.3;
        Wed, 15 Jul 2020 22:55:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ygm0p5seVyBaEJSzhwmf20urAR1vL+SuzaS+13AqEL4=;
        b=FrcKzyDepgtIrowX3sWcJXXVW3Rj9INeqiJHLRjN6YeVmDDK4aMjBCFXyMgVCNBrbX
         SkcGtHKxnEE5ejzYFZ7enkLcL0XLG9SMGB4eJPM6Atf0ZSId4ckHDDu1RTBHRm/DmLlN
         JhZSHRLiM8KTUpMtANJjR7C23PgWCzwayM5hmVRzgD2LlJxQT6oJsKP6fPgKUfuG93P5
         3PQgM5aO29SWLCIhqfXFZg1NLwb5m+S+v3RSoBDH68KPubJHsdV13Wnf6E1Mg4AN3bMD
         6Q0TaHksY9TVWrXtNxAQqRWBxlh51yo+3PCWzCHMINnckcE8KkmE73aPbsqhpiNTtCXO
         h2Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ygm0p5seVyBaEJSzhwmf20urAR1vL+SuzaS+13AqEL4=;
        b=d23AYhUfWyBwaNB49m6SEKvZbrinZP0IkWbpajGGrDqbRPaWIhPK38rNVbdpgyc6Mp
         nDouFCPEWg34KlwPnfEbwxyohK9oGD7hrGIr4X2UY2etc9wctZ7+UHE6Pl5f+RgYdLMc
         wvq1s+EAPF/ZDGQqOvgPaObJco38NNJKAyGOO4Dza/QTgOUGE3Qok9UVZ9HWxF03zn2H
         SxnxozGL0Vw9CcY2C6jCPi0HskQlgu2ECbRz+9DKP/MTdeDT3JBimWJiZDZe27sJVd7z
         8s1L43lKO/5iW3tTk4E6QJYcuN4tQT3O8RbJLAor0DSk1zt3wbldVc4wTmM7PU8uwRnk
         QF4A==
X-Gm-Message-State: AOAM5328EiN391geTR9YLkzGKRJUzeLBALIp4n8HZieKXrnnJWw7DVVH
        gEJelqhhFNeOJWaz6Ok9DZMdZfa/s6VYsBh8JGw=
X-Google-Smtp-Source: ABdhPJxxfXcyvMx66ER9SoxtYcgYPSNZ/dWNh1B0GkeMT9u38VfvVFoEru6UiYlLoD2UH6qldfo0PK2TMEBF2Kelu4U=
X-Received: by 2002:aed:2cc5:: with SMTP id g63mr3434892qtd.59.1594878927213;
 Wed, 15 Jul 2020 22:55:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200715052601.2404533-1-songliubraving@fb.com> <20200715052601.2404533-2-songliubraving@fb.com>
In-Reply-To: <20200715052601.2404533-2-songliubraving@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 15 Jul 2020 22:55:16 -0700
Message-ID: <CAEf4BzZTYVq=oct0rUg5Y+wOc07k2Pcz-66M-NtjRFJTez0AvA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 1/2] bpf: separate bpf_get_[stack|stackid] for
 perf events BPF
To:     Song Liu <songliubraving@fb.com>
Cc:     open list <linux-kernel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Peter Ziljstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 14, 2020 at 11:08 PM Song Liu <songliubraving@fb.com> wrote:
>
> Calling get_perf_callchain() on perf_events from PEBS entries may cause
> unwinder errors. To fix this issue, the callchain is fetched early. Such
> perf_events are marked with __PERF_SAMPLE_CALLCHAIN_EARLY.
>
> Similarly, calling bpf_get_[stack|stackid] on perf_events from PEBS may
> also cause unwinder errors. To fix this, add separate version of these
> two helpers, bpf_get_[stack|stackid]_pe. These two hepers use callchain in
> bpf_perf_event_data_kern->data->callchain.
>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  include/linux/bpf.h      |   2 +
>  kernel/bpf/stackmap.c    | 204 +++++++++++++++++++++++++++++++++++----
>  kernel/trace/bpf_trace.c |   4 +-
>  3 files changed, 190 insertions(+), 20 deletions(-)
>

Glad this approach worked out! Few minor bugs below, though.

[...]

> +       if (unlikely(flags & ~(BPF_F_SKIP_FIELD_MASK | BPF_F_USER_STACK |
> +                              BPF_F_FAST_STACK_CMP | BPF_F_REUSE_STACKID)))
> +               return -EINVAL;
> +
> +       user = flags & BPF_F_USER_STACK;
> +       kernel = !user;
> +
> +       has_kernel = !event->attr.exclude_callchain_kernel;
> +       has_user = !event->attr.exclude_callchain_user;
> +
> +       if ((kernel && !has_kernel) || (user && !has_user))
> +               return -EINVAL;
> +
> +       trace = ctx->data->callchain;
> +       if (!trace || (!has_kernel && !has_user))

(!has_kernel && !has_user) can never happen, it's checked by if above
(one of kernel or user is always true => one of has_user or has_kernel
is always true).

> +               return -EFAULT;
> +
> +       if (has_kernel && has_user) {
> +               __u64 nr_kernel = count_kernel_ip(trace);
> +               int ret;
> +
> +               if (kernel) {
> +                       __u64 nr = trace->nr;
> +
> +                       trace->nr = nr_kernel;
> +                       ret = __bpf_get_stackid(map, trace, flags);
> +
> +                       /* restore nr */
> +                       trace->nr = nr;
> +               } else { /* user */
> +                       u64 skip = flags & BPF_F_SKIP_FIELD_MASK;
> +
> +                       skip += nr_kernel;
> +                       if (skip > ~BPF_F_SKIP_FIELD_MASK)

something fishy here: ~BPF_F_SKIP_FIELD_MASK is a really big number,
were you going to check that skip is not bigger than 255 (i.e., fits
within BPF_F_SKIP_FIELD_MASK)?

> +                               return -EFAULT;
> +
> +                       flags = (flags & ~BPF_F_SKIP_FIELD_MASK) |
> +                               (skip  & BPF_F_SKIP_FIELD_MASK);
> +                       ret = __bpf_get_stackid(map, trace, flags);
> +               }
> +               return ret;
> +       }
> +       return __bpf_get_stackid(map, trace, flags);
> +}
> +

[...]

> +
> +       has_kernel = !event->attr.exclude_callchain_kernel;
> +       has_user = !event->attr.exclude_callchain_user;
> +
> +       if ((kernel && !has_kernel) || (user && !has_user))
> +               goto clear;
> +
> +       err = -EFAULT;
> +       trace = ctx->data->callchain;
> +       if (!trace || (!has_kernel && !has_user))
> +               goto clear;

same as above for bpf_get_stackid, probably can be simplified

> +
> +       if (has_kernel && has_user) {
> +               __u64 nr_kernel = count_kernel_ip(trace);
> +               int ret;
> +
> +               if (kernel) {
> +                       __u64 nr = trace->nr;
> +
> +                       trace->nr = nr_kernel;
> +                       ret = __bpf_get_stack(ctx->regs, NULL, trace, buf,
> +                                             size, flags);
> +
> +                       /* restore nr */
> +                       trace->nr = nr;
> +               } else { /* user */
> +                       u64 skip = flags & BPF_F_SKIP_FIELD_MASK;
> +
> +                       skip += nr_kernel;
> +                       if (skip > ~BPF_F_SKIP_FIELD_MASK)
> +                               goto clear;
> +

and here

> +                       flags = (flags & ~BPF_F_SKIP_FIELD_MASK) |
> +                               (skip  & BPF_F_SKIP_FIELD_MASK);

actually if you check that skip <= BPF_F_SKIP_FIELD_MASK, you don't
need to mask it here, just `| skip`

> +                       ret = __bpf_get_stack(ctx->regs, NULL, trace, buf,
> +                                             size, flags);
> +               }
> +               return ret;
> +       }
> +       return __bpf_get_stack(ctx->regs, NULL, trace, buf, size, flags);
> +clear:
> +       memset(buf, 0, size);
> +       return err;
> +
> +}
> +

[...]
