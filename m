Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 898444FEB21
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 01:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbiDLXVL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 19:21:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbiDLXUz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 19:20:55 -0400
Received: from mail-vs1-xe30.google.com (mail-vs1-xe30.google.com [IPv6:2607:f8b0:4864:20::e30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C16C556C38;
        Tue, 12 Apr 2022 15:59:52 -0700 (PDT)
Received: by mail-vs1-xe30.google.com with SMTP id k17so72990vsq.0;
        Tue, 12 Apr 2022 15:59:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j41Q8gnuZ03bJTEMpu4jn4cCVopOc2s+2i/707b4xTA=;
        b=Rv/8CMzr1P1EuG+M7mkPs4fpgcPv2fpBY85DFxDLMO8vUKweKEasvf7CsFXlB05s3a
         XyvGifsDwvj+C1NDmY8lV7cAmyPOpSLM29ZcbfJdKnAJDwjTdt8YW33csnClNdABeTor
         8b/IDcvuVYz4Xx7/96F2019V3ULYTrKXV47qYOdJuSyX5vSQrUJN4C6HX4iWED9A5cz/
         lRBxqUmukE4YsU28r/G7ESsfAhdylKADg5DYOrx4bHBPn8a8HMJueT/tinBVKgTUvhfQ
         ix4NITMLh00pCqpdKOcYu8vDajr8CGE4WXP9FRZoVk7IIaLNwkPsXmimAYkdJ1xCoM+d
         nsmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j41Q8gnuZ03bJTEMpu4jn4cCVopOc2s+2i/707b4xTA=;
        b=VKkH2/r2wcV8tuQVdAcbkJHCzs14glfdQIjGMzC4Yc287MuDxGW7K8T+SVp6Rud6qh
         M5bgCeePguWLLAaH4X2JvBXZeglWyrC5W52vs6NDiTmCbn1sJ8s/DA0KDGfiYW8FQ03C
         xctvsOFj/cxsGJVzus9ZCIACtjFepI6GUHXdco7CUJSUMxdZ9w6BmIc9yrpG/9A4rnFv
         xXnGWWcqkA8xCgefri5sqpkD0v8T9PwErX62Jo+kUd5I7THadealt09b5whzpG9me4Lb
         L09itQyNn6BtO7e1iy152+sMBPfehniV9VxWpUbdwQKj31d1ixBGUxCS8ifGxk8Bqao1
         ivQw==
X-Gm-Message-State: AOAM531Jfc7uc5xLx26/htcWwRhcva2GQBZ0dD1fJd7dxn5QK9HRnA7C
        Z8EpWhGRxTia7In5NVc/8CDxBBOKP/FYv2QJ0D6syRKglRY=
X-Google-Smtp-Source: ABdhPJxjzMzXULY3Z78JcJbteSGbO3b9q5odNlhdDJK2spnl/3+0aKaJvj2PJcUS7V7lv+XaCw3GLXkSyix8n763OXo=
X-Received: by 2002:a67:f80b:0:b0:32a:17d6:7fb2 with SMTP id
 l11-20020a67f80b000000b0032a17d67fb2mr167251vso.40.1649804391900; Tue, 12 Apr
 2022 15:59:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220407125224.310255-1-jolsa@kernel.org> <20220407125224.310255-5-jolsa@kernel.org>
 <CAEf4BzbE1n3Lie+tWTzN69RQUWgjxePorxRr9J8CuiQVUfy-kA@mail.gmail.com> <YlWeQIUaqGnbg4K0@krava>
In-Reply-To: <YlWeQIUaqGnbg4K0@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 12 Apr 2022 15:59:41 -0700
Message-ID: <CAEf4BzYL0-ykV34jTnFcVUVf7bWfB6_V9mzeO=593oAO7YT1Yw@mail.gmail.com>
Subject: Re: [RFC bpf-next 4/4] selftests/bpf: Add attach bench test
To:     Jiri Olsa <olsajiri@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
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

On Tue, Apr 12, 2022 at 8:44 AM Jiri Olsa <olsajiri@gmail.com> wrote:
>
> On Mon, Apr 11, 2022 at 03:15:40PM -0700, Andrii Nakryiko wrote:
>
> SNIP
>
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
>
> the new code makes the differece ;-) so the main problem I could not
> use available_filter_functions functions before were cases like:
>
>   # cat available_filter_functions | grep sys_ni_syscall
>   sys_ni_syscall
>   sys_ni_syscall
>   sys_ni_syscall
>   sys_ni_syscall
>   sys_ni_syscall
>   sys_ni_syscall
>   sys_ni_syscall
>   sys_ni_syscall
>   sys_ni_syscall
>   sys_ni_syscall
>   sys_ni_syscall
>   sys_ni_syscall
>   sys_ni_syscall
>   sys_ni_syscall
>   sys_ni_syscall
>
> which when you try to resolve you'll find just one address:
>
>   # cat /proc/kallsyms | egrep 'T sys_ni_syscall'
>   ffffffff81170020 T sys_ni_syscall
>
> this is caused by entries like:
>     __SYSCALL(156, sys_ni_syscall)
>
> when generating syscalls for given arch
>
> this is handled by the new code by removing duplicates when
> reading available_filter_functions
>
>
>
> another case is the other way round, like with:
>
>   # cat /proc/kallsyms | grep 't t_next'
>   ffffffff8125c3f0 t t_next
>   ffffffff8126a320 t t_next
>   ffffffff81275de0 t t_next
>   ffffffff8127efd0 t t_next
>   ffffffff814d6660 t t_next
>
> that has just one 'ftrace-able' instance:
>
>   # cat available_filter_functions | grep '^t_next$'
>   t_next
>
> and this is handled by calling ftrace_location on address when
> resolving symbols, to ensure each reasolved symbol lives in ftrace
>
> > available_filter_functions has a bunch of functions that should not be
> > attachable (e.g., notrace functions). Look just at __bpf_tramp_exit:
> >
> >   void notrace __bpf_tramp_exit(struct bpf_tramp_image *tr);
> >
> > So first, curious what I am doing wrong or rather why it succeeds in
> > your case ;)
> >
> > But second, just wanted to plea to "fix" available_filter_functions to
> > not list stuff that should not be attachable. Can you please take a
> > look and checks what's going on there and why do we have notrace
> > functions (and what else should *NOT* be there)?
>
> yes, seems like a bug ;-) it's in available_filter_functions
> but it does not have 'call __fentry__' at the entry..
>
> I was going to check on that, because you brought that up before,
> but did not get to it yet

yeah, see also my reply to Masami. __bpf_tramp_exit and
__bpf_tramp_enter are two specific examples. Both are marked notrace,
but one is in available_filter_functions and another is not. Neither
should be attachable, but doing this local change you can see that one
of them (__bpf_tramp_exit) is:

$ git diff
diff --git a/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
b/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
index b9876b55fc0c..77cff034d427 100644
--- a/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
+++ b/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
@@ -165,8 +165,8 @@ static void test_attach_api_pattern(void)
 {
        LIBBPF_OPTS(bpf_kprobe_multi_opts, opts);

-       test_attach_api("bpf_fentry_test*", &opts);
-       test_attach_api("bpf_fentry_test?", NULL);
+       test_attach_api("__bpf_tramp_enter", &opts);
+       test_attach_api("__bpf_tramp_exit", NULL);
 }


$ sudo ./test_progs -t kprobe_multi/attach_api_pattern -v
bpf_testmod.ko is already unloaded.
Loading bpf_testmod.ko...
Successfully loaded bpf_testmod.ko.
test_kprobe_multi_test:PASS:load_kallsyms 0 nsec
test_attach_api:PASS:fentry_raw_skel_load 0 nsec
libbpf: prog 'test_kprobe': failed to attach: Invalid argument
test_attach_api:FAIL:bpf_program__attach_kprobe_multi_opts unexpected error: -22
test_attach_api:PASS:fentry_raw_skel_load 0 nsec
test_attach_api:PASS:bpf_program__attach_kprobe_multi_opts 0 nsec

Quite weird.



>
> >
> >
> > > +       if (!f)
> > > +               return -EINVAL;
> > > +
> > > +       map = hashmap__new(symbol_hash, symbol_equal, NULL);
> > > +       err = libbpf_get_error(map);
> > > +       if (err)
> > > +               goto error;
> > > +
> >
> > [...]
> >
> > > +
> > > +       attach_delta_ns = (attach_end_ns - attach_start_ns) / 1000000000.0;
> > > +       detach_delta_ns = (detach_end_ns - detach_start_ns) / 1000000000.0;
> > > +
> > > +       fprintf(stderr, "%s: found %lu functions\n", __func__, cnt);
> > > +       fprintf(stderr, "%s: attached in %7.3lfs\n", __func__, attach_delta_ns);
> > > +       fprintf(stderr, "%s: detached in %7.3lfs\n", __func__, detach_delta_ns);
> > > +
> > > +       if (attach_delta_ns > 2.0)
> > > +               PRINT_FAIL("attach time above 2 seconds\n");
> > > +       if (detach_delta_ns > 2.0)
> > > +               PRINT_FAIL("detach time above 2 seconds\n");
> >
> > see my reply on the cover letter, any such "2 second" assumption are
> > guaranteed to bite us. We've dealt with a lot of timing issues due to
> > CI being slower and more unpredictable in terms of performance, I'd
> > like to avoid dealing with one more case like that.
>
> right, I'll remove the check
>
> thanks,
> jirka
