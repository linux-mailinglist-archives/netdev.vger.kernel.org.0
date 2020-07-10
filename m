Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D69621BECB
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 22:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728090AbgGJUzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 16:55:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726832AbgGJUzW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 16:55:22 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EA6FC08C5DC;
        Fri, 10 Jul 2020 13:55:22 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id q198so6649807qka.2;
        Fri, 10 Jul 2020 13:55:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pmcDlrw4meZJFYWX3EhmB3yugEQBs6tKcBmf6yeQHvQ=;
        b=WnOw1ejXVtSEmc0a/5XFQfNAbtJXvGUudGY5lnwPZf2AeHXAk2y7EYAGND69nYtczt
         QVFWnZl3wmOUzZqqqIFXFxNf/Ifi+U7xmHUU++nwJ1Q/WyqxwRhgczrYFxRk5W7EO6q1
         wxNvtnhOAJB6RBPB+Ns2xrYOGAz4qdZtZI5dOts5a1fnfSodSjsQuEL7v29hTf4/cqxc
         sZTlSu/cGHtxh0ewQQo2o5Pg26oOsIccjfApZLhyzrx6i5PFHahBWIsvWbUrqZnxD4tF
         YTpAbpN/qiTMOduTmwdXTeNUsWZdACs1765rTR8jbqyoieKE1AJJtQlezBe0lnv+/tOm
         dwzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pmcDlrw4meZJFYWX3EhmB3yugEQBs6tKcBmf6yeQHvQ=;
        b=cTYZ9JvnM0a5sVXpmh+7LKENnae703fE/f93xVSOJxaJrZBR1ACs7ijfhv1aV0nM0D
         1/9k2jL8TRjP4Jcy9c6nJ2P9gZV2Ie8LOXOiAtZqfLMeEcmNUR/B8Cclnu2zPBJ987Dq
         R6dV+QGHyvEiTQBES30J6RRDg4nhzC1Z3QIZX6GbazThrk4deZ/J9wzgzJ95ECY62/mV
         sERB5tLbVRZ9/J51kOfH+trfdeIZ7ojFRBisTacEPSkesA2KoVHfwQuvuG+RswDGxgYq
         x6oVJvWuDewiNpkbkbWSLAU74UqNy6R9d22w9hNFMM8qD6S6YXgtQcq+2EbP5ydP9wGp
         Lhcg==
X-Gm-Message-State: AOAM5336+Tbq5+l5y2DXDK43Gb0uuwFaQJy6nxTZxjx83w1/fRlARsP9
        ybgOFvrk0H2m/QXGFN/cg8VYn/SGbiQTzRjYODQ=
X-Google-Smtp-Source: ABdhPJzFvrDqynOy0aH+oFH6/6mPgh59gkw370MYYW2U+aV4cG+M1arimhQoEW5JcEPzj3BSsAp7rrSaKInRMZKMaqs=
X-Received: by 2002:ae9:f002:: with SMTP id l2mr61156551qkg.437.1594414521627;
 Fri, 10 Jul 2020 13:55:21 -0700 (PDT)
MIME-Version: 1.0
References: <1594390953-31757-1-git-send-email-alan.maguire@oracle.com> <1594390953-31757-3-git-send-email-alan.maguire@oracle.com>
In-Reply-To: <1594390953-31757-3-git-send-email-alan.maguire@oracle.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 10 Jul 2020 13:55:10 -0700
Message-ID: <CAEf4BzZ4X67E7dxWA8sdiBpuyFfeWZ4yNAagQpwho+FncJv=GQ@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 2/2] selftests/bpf: add selftests verifying
 bpf_trace_printk() behaviour
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 10, 2020 at 7:25 AM Alan Maguire <alan.maguire@oracle.com> wrote:
>
> Simple selftests that verifies bpf_trace_printk() returns a sensible
> value and tracing messages appear.
>
> Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> ---

see pedantic note below, but I don't think that's an issue in practice

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  .../selftests/bpf/prog_tests/trace_printk.c        | 74 ++++++++++++++++++++++
>  tools/testing/selftests/bpf/progs/trace_printk.c   | 21 ++++++
>  2 files changed, 95 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/trace_printk.c
>  create mode 100644 tools/testing/selftests/bpf/progs/trace_printk.c
>

[...]

> +
> +       /* verify our search string is in the trace buffer */
> +       while (read(fd, buf, sizeof(buf)) >= 0 || errno == EAGAIN) {

There is a minor chance that "testing,testing" won't be found, if it
so happened that the first part is in the first read buffer, and the
second is in the second. I don't think it's ever the case for our CI
and for my local testing setup, but could be a cause of some
instability if there is something else emitting data to trace_pipe,
right?

Maybe line-based reading would be more reliable (unless printk can
intermix, not sure about that, in which case there is simply no way to
solve this 100% reliably).


> +               if (strstr(buf, SEARCHMSG) != NULL)
> +                       found++;
> +               if (found == bss->trace_printk_ran)
> +                       break;
> +               if (++iter > 1000)
> +                       break;
> +       }
> +
> +       if (CHECK(!found, "message from bpf_trace_printk not found",
> +                 "no instance of %s in %s", SEARCHMSG, TRACEBUF))
> +               goto cleanup;
> +
> +       printf("ran %d times; last return value %d, with %d instances of msg\n",
> +              bss->trace_printk_ran, bss->trace_printk_ret, found);

Is this needed or it's some debug leftover?

> +cleanup:
> +       trace_printk__destroy(skel);
> +       if (fd != -1)
> +               close(fd);
> +}

[...]
