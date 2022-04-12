Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E37424FEB09
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 01:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbiDLXXH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 19:23:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbiDLXWo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 19:22:44 -0400
Received: from mail-vs1-xe36.google.com (mail-vs1-xe36.google.com [IPv6:2607:f8b0:4864:20::e36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CCA46376;
        Tue, 12 Apr 2022 15:51:55 -0700 (PDT)
Received: by mail-vs1-xe36.google.com with SMTP id n5so28398vsc.4;
        Tue, 12 Apr 2022 15:51:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ezdzc9fwB75FHs1RJU/8xMrtLkAqryX8e9lSQiCG6+o=;
        b=cU9m/K7Eni83YVgmrXwmtrkQj72C5hzDjLWdtTFybmcwnahHAfZEs0iJx1d8hNPrL9
         xLycI8nlRheQ1e3GZSFw+o8gPaVGVlgIlQ5Ip3jUXrCXhK2FUZtv2Oco1mOXlR0rl07a
         D1x8VEftu5H+lm98oDGx1Z6quG27tqLunILzlWPwv9r+INhfInQ3G1tjUhJa84jztczf
         wU7Q2I06GHcTllXmnxqHBjlkF4E3P5+yLNQM38rUAzaUFloU0b/oP9wvTMj7SaXTSyvl
         psRBO6sjwXyjtAKMXk+JBM2B4Gbw5o+wY3ubKZkov1HV6cnIvH2yWDgQk1mKp00kX6+F
         urOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ezdzc9fwB75FHs1RJU/8xMrtLkAqryX8e9lSQiCG6+o=;
        b=Ms5KjXn+BzqAI4G07rSPr/NLU1Pn16+Qk8cGsEzKKIftJGyamedcoPrfk4kvbId6tg
         90VCCB8xGQWSchpGamRZqo0rTDhrEICR9WrBJT/6Gl/dNTHdecE7oGVJKW2ER18D+4SR
         BBuWvluHJ8M+W1vVP746Oigvr+DKo3+sbgeO49gCF3Mto7lGWlfCnIe5L7AbBhG8/9Y0
         DLCSdWkMp73lJ2BxeNP6etu2/vYCgIYAwbLfZxkK4my9r6SsvNfyHdmk3yjbWdEWHadl
         bc9he0U5nKSYmTXOezUPQt/xnrw39+keOCZJlsX0q8zDOydPgdPw82qxA/36dY0RNtOH
         +XiA==
X-Gm-Message-State: AOAM5324c5ypZFP8OWzLf9n8kvOGQGs3FaJR7SVZHk389jYjPGQZoO/3
        l+uSfRycX8TXeLs7HEnTD4sSVImO/oDgWxQsGpzS+Bbypz4=
X-Google-Smtp-Source: ABdhPJzFmqDl3FEyc+heWcRNc23/etW3e72ExFo4mTnsv5LYt8gIlxwoTVFLMaA+QTD9Uvi6pY0ytv9F1xXaDufGqkA=
X-Received: by 2002:a67:f693:0:b0:328:295b:3077 with SMTP id
 n19-20020a67f693000000b00328295b3077mr6317205vso.80.1649803914668; Tue, 12
 Apr 2022 15:51:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220407125224.310255-1-jolsa@kernel.org> <20220407125224.310255-5-jolsa@kernel.org>
 <CAEf4BzbE1n3Lie+tWTzN69RQUWgjxePorxRr9J8CuiQVUfy-kA@mail.gmail.com> <20220412094923.0abe90955e5db486b7bca279@kernel.org>
In-Reply-To: <20220412094923.0abe90955e5db486b7bca279@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 12 Apr 2022 15:51:43 -0700
Message-ID: <CAEf4BzaQRcZGMqq5wqHo3wSHZAAVvY6AhizDk_dV_GtnwHuxLQ@mail.gmail.com>
Subject: Re: [RFC bpf-next 4/4] selftests/bpf: Add attach bench test
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>, Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 11, 2022 at 5:49 PM Masami Hiramatsu <mhiramat@kernel.org> wrote:
>
> On Mon, 11 Apr 2022 15:15:40 -0700
> Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
>
> > > +#define DEBUGFS "/sys/kernel/debug/tracing/"
> > > +
> > > +static int get_syms(char ***symsp, size_t *cntp)
> > > +{
> > > +       size_t cap = 0, cnt = 0, i;
> > > +       char *name, **syms = NULL;
> > > +       struct hashmap *map;
> > > +       char buf[256];
> > > +       FILE *f;
> > > +       int err;
> > > +
> > > +       /*
> > > +        * The available_filter_functions contains many duplicates,
> > > +        * but other than that all symbols are usable in kprobe multi
> > > +        * interface.
> > > +        * Filtering out duplicates by using hashmap__add, which won't
> > > +        * add existing entry.
> > > +        */
> > > +       f = fopen(DEBUGFS "available_filter_functions", "r");
> >
> > I'm really curious how did you manage to attach to everything in
> > available_filter_functions because when I'm trying to do that I fail.
> > available_filter_functions has a bunch of functions that should not be
> > attachable (e.g., notrace functions). Look just at __bpf_tramp_exit:
> >
> >   void notrace __bpf_tramp_exit(struct bpf_tramp_image *tr);
>
> Hmm, this sounds like a bug in ftrace side. IIUC, the
> "available_filter_functions" only shows the functions which is NOT
> instrumented by mcount, we should not see any notrace functions on it.
>
> Technically, this is done by __no_instrument_function__ attribute.
>
> #if defined(CC_USING_HOTPATCH)
> #define notrace                 __attribute__((hotpatch(0, 0)))
> #elif defined(CC_USING_PATCHABLE_FUNCTION_ENTRY)
> #define notrace                 __attribute__((patchable_function_entry(0, 0)))
> #else
> #define notrace                 __attribute__((__no_instrument_function__))
> #endif
>
> >
> > So first, curious what I am doing wrong or rather why it succeeds in
> > your case ;)
> >
> > But second, just wanted to plea to "fix" available_filter_functions to
> > not list stuff that should not be attachable. Can you please take a
> > look and checks what's going on there and why do we have notrace
> > functions (and what else should *NOT* be there)?
>
> Can you share how did you reproduce the issue? I'll check it.
>

$ sudo cat /sys/kernel/debug/tracing/available_filter_functions | grep
__bpf_tramp
__bpf_tramp_image_release
__bpf_tramp_image_put_rcu_tasks
__bpf_tramp_image_put_rcu
__bpf_tramp_image_put_deferred
__bpf_tramp_exit


__bpf_tramp_exit is notrace function, so shouldn't be here. Notice
that __bpf_tramp_enter (which is also notrace) are not in
available_filter_functions.

So it's quite bizarre and inconsistent.

> Thank you,
>
>
> --
> Masami Hiramatsu <mhiramat@kernel.org>
