Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DDEB4DEA15
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 19:26:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243203AbiCSS1o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 14:27:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233591AbiCSS1n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 14:27:43 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B87D226E027;
        Sat, 19 Mar 2022 11:26:21 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id r2so7942599ilh.0;
        Sat, 19 Mar 2022 11:26:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lNANWIYC3JPI1YjCRFPsg6S12NrqHbsTweXOTPTiyyQ=;
        b=S/GdAu1IO91TmVCe4gRDoAvKXwWR2K/eY5uH5zhgMdJ5yGz1/KylrtEpX7dS0Hv+0t
         jowreCdIl7piyamRXiBm4hAdkZEBAKDbtI00Zo+KTujLURCVgYW3ji9cb7IFxdP3XL4c
         rXx5qFm1FpLdJmWKAc03driO4g4f0RlxlKb998CFXGP3KGhYb9L81yP//gzgh7UKnIzg
         22oqN9k+VKQncy6vzWfH8h4koRvAZHsnGeXRTke9KBwPwftE7qUUQk7rlQ/PJgARdpoR
         LGh+bzK99qdxMHjaYfiTFT5eTFKvQu1Mot348MIsAFXwZpbx21ezS7HoFypX85DB7z40
         MkHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lNANWIYC3JPI1YjCRFPsg6S12NrqHbsTweXOTPTiyyQ=;
        b=00iaIRQwAKEomei7I8Mz2Keog1CTDRjdsq/XAN+ncj5VrVZf5bCB4xevcrcozKNPr2
         IKir/nq1z+Q11gg9KvPTUtDQXoY6SzNPOqd5en2cnLQfL3ag1wJs8hJUaCMdswgQcyn9
         vrJLNfY+E5NvPQUfaK7yG/GsGunDWqFErKxbpQdVjkux+VlXWoLqvXdASb/hpSvEw+uO
         UPtOOzsZDCklUl16iFAhlNCehe1GfmFZmtWgHL175A0IdJsbNXpq9WXxMBSJtnbQYIP4
         3tfqF47sgIGo9BzGSWEOwZZyrkLcY/3UX7KS/qXTORRapvpgVjphmNFN3vDzJiSn6svC
         l2/w==
X-Gm-Message-State: AOAM530f3ifTjfzL0LClPXOlUS8H4F8zyh93MsZ7tgcc9bHCQt0t+t1m
        7hzMonJs9OVdbStygLfKQRxU4y6R1sf4AqYAO4I=
X-Google-Smtp-Source: ABdhPJw/C9Wd403XA8JuQ2/x2cxv72+XPl5KjndvByLTIP9PamTSXuYX1B8QVFIFH5cNUGq0EjfS/zF5WyMdP2FnGbE=
X-Received: by 2002:a92:6406:0:b0:2bb:f1de:e13e with SMTP id
 y6-20020a926406000000b002bbf1dee13emr6528304ilb.305.1647714381039; Sat, 19
 Mar 2022 11:26:21 -0700 (PDT)
MIME-Version: 1.0
References: <20220316122419.933957-1-jolsa@kernel.org> <CAEf4BzbpjN6ca7D9KOTiFPOoBYkciYvTz0UJNp5c-_3ptm=Mrg@mail.gmail.com>
 <YjXMSg+BSSOv0xd1@krava> <YjXpTZUI10RVCGPD@krava>
In-Reply-To: <YjXpTZUI10RVCGPD@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sat, 19 Mar 2022 11:26:10 -0700
Message-ID: <CAEf4BzYbL0=ExUQOy3xZ-C2O6nQN3BVudBWESFNkgs0fr=uRmg@mail.gmail.com>
Subject: Re: [PATCHv3 bpf-next 00/13] bpf: Add kprobe multi link
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
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>
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

On Sat, Mar 19, 2022 at 7:31 AM Jiri Olsa <olsajiri@gmail.com> wrote:
>
> On Sat, Mar 19, 2022 at 01:27:56PM +0100, Jiri Olsa wrote:
> > On Fri, Mar 18, 2022 at 10:50:46PM -0700, Andrii Nakryiko wrote:
> > > On Wed, Mar 16, 2022 at 5:24 AM Jiri Olsa <jolsa@kernel.org> wrote:
> > > >
> > > > hi,
> > > > this patchset adds new link type BPF_TRACE_KPROBE_MULTI that attaches
> > > > kprobe program through fprobe API [1] instroduced by Masami.
> > > >
> > > > The fprobe API allows to attach probe on multiple functions at once very
> > > > fast, because it works on top of ftrace. On the other hand this limits
> > > > the probe point to the function entry or return.
> > > >
> > > >
> > > > With bpftrace support I see following attach speed:
> > > >
> > > >   # perf stat --null -r 5 ./src/bpftrace -e 'kprobe:x* { } i:ms:1 { exit(); } '
> > > >   Attaching 2 probes...
> > > >   Attaching 3342 functions
> > > >   ...
> > > >
> > > >   1.4960 +- 0.0285 seconds time elapsed  ( +-  1.91% )
> > > >
> > > > v3 changes:
> > > >   - based on latest fprobe post from Masami [2]
> > > >   - add acks
> > > >   - add extra comment to kprobe_multi_link_handler wrt entry ip setup [Masami]
> > > >   - keep swap_words_64 static and swap values directly in
> > > >     bpf_kprobe_multi_cookie_swap [Andrii]
> > > >   - rearrange locking/migrate setup in kprobe_multi_link_prog_run [Andrii]
> > > >   - move uapi fields [Andrii]
> > > >   - add bpf_program__attach_kprobe_multi_opts function [Andrii]
> > > >   - many small test changes [Andrii]
> > > >   - added tests for bpf_program__attach_kprobe_multi_opts
> > > >   - make kallsyms_lookup_name check for empty string [Andrii]
> > > >
> > > > v2 changes:
> > > >   - based on latest fprobe changes [1]
> > > >   - renaming the uapi interface to kprobe multi
> > > >   - adding support for sort_r to pass user pointer for swap functions
> > > >     and using that in cookie support to keep just single functions array
> > > >   - moving new link to kernel/trace/bpf_trace.c file
> > > >   - using single fprobe callback function for entry and exit
> > > >   - using kvzalloc, libbpf_ensure_mem functions
> > > >   - adding new k[ret]probe.multi sections instead of using current kprobe
> > > >   - used glob_match from test_progs.c, added '?' matching
> > > >   - move bpf_get_func_ip verifier inline change to seprate change
> > > >   - couple of other minor fixes
> > > >
> > > >
> > > > Also available at:
> > > >   https://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
> > > >   bpf/kprobe_multi
> > > >
> > > > thanks,
> > > > jirka
> > > >
> > > >
> > > > [1] https://lore.kernel.org/bpf/164458044634.586276.3261555265565111183.stgit@devnote2/
> > > > [2] https://lore.kernel.org/bpf/164735281449.1084943.12438881786173547153.stgit@devnote2/
> > > > ---
> > > > Jiri Olsa (13):
> > > >       lib/sort: Add priv pointer to swap function
> > > >       kallsyms: Skip the name search for empty string
> > > >       bpf: Add multi kprobe link
> > > >       bpf: Add bpf_get_func_ip kprobe helper for multi kprobe link
> > > >       bpf: Add support to inline bpf_get_func_ip helper on x86
> > > >       bpf: Add cookie support to programs attached with kprobe multi link
> > > >       libbpf: Add libbpf_kallsyms_parse function
> > > >       libbpf: Add bpf_link_create support for multi kprobes
> > > >       libbpf: Add bpf_program__attach_kprobe_multi_opts function
> > > >       selftests/bpf: Add kprobe_multi attach test
> > > >       selftests/bpf: Add kprobe_multi bpf_cookie test
> > > >       selftests/bpf: Add attach test for bpf_program__attach_kprobe_multi_opts
> > > >       selftests/bpf: Add cookie test for bpf_program__attach_kprobe_multi_opts
> > > >
> > >
> > > Ok, so I've integrated multi-attach kprobes into retsnoop. It was
> > > pretty straightforward. Here are some numbers for the speed of
> > > attaching and, even more importantly, detaching for a set of almost
> > > 400 functions. It's a bit less functions for fentry-based mode due to
> > > more limited BTF information for static functions. Note that retsnoop
> > > attaches two BPF programs for each kernel function, so it's actually
> > > two multi-attach kprobes, each attaching to 397 functions. For
> > > single-attach kprobe, we perform 397 * 2 = 794 attachments.
> > >
> > > I've been invoking retsnoop with the following specified set of
> > > functions: -e '*sys_bpf*' -a ':kernel/bpf/syscall.c' -a
> > > ':kernel/bpf/verifier.c' -a ':kernel/bpf/btf.c' -a
> > > ':kernel/bpf/core.c'. So basically bpf syscall entry functions and all
> > > the discoverable functions from syscall.c, verifier.c, core.c and
> > > btf.c from kernel/bpf subdirectory.
> > >
> > > Results:
> > >
> > > fentry attach/detach (263 kfuncs): 2133 ms / 31671  ms (33 seconds)
> > > kprobe attach/detach (397 kfuncs): 3121 ms / 13195 ms (16 seconds)
> > > multi-kprobe attach/detach (397 kfuncs): 9 ms / 248 ms (0.25 seconds)
> > >
> > > So as you can see, the speed up is tremendous! API is also very
> > > convenient, I didn't have to modify retsnoop internals much to
> > > accommodate multi-attach API. Great job!
> >
> > nice! thanks for doing that so quickly
> >
> > >
> > > Now for the bad news. :(
> > >
> > > Stack traces from multi-attach kretprobe are broken, which makes all
> > > this way less useful.
> > >
> > > Below, see stack traces captured with multi- and single- kretprobes
> > > for two different use cases. Single kprobe stack traces make much more
> > > sense. Ignore that last function doesn't have actual address
> > > associated with it (i.e. for __sys_bpf and bpf_tracing_prog_attach,
> > > respectively). That's just how retsnoop is doing things, I think. We
> > > actually were capturing stack traces from inside __sys_bpf (first
> > > case) and bpf_tracing_prog_attach (second case).
> > >
> > > MULTI KPROBE:
> > > ffffffff81185a80 __sys_bpf+0x0
> > > (kernel/bpf/syscall.c:4622:1)
> > >
> > > SINGLE KPROBE:
> > > ffffffff81e0007c entry_SYSCALL_64_after_hwframe+0x44
> > > (arch/x86/entry/entry_64.S:113:0)
> > > ffffffff81cd2b15 do_syscall_64+0x35
> > > (arch/x86/entry/common.c:80:7)
> > >                  . do_syscall_x64
> > > (arch/x86/entry/common.c:50:12)
> > > ffffffff811881aa __x64_sys_bpf+0x1a
> > > (kernel/bpf/syscall.c:4765:1)
> > >                  __sys_bpf
> > >
> > >
> > > MULTI KPROBE:
> > > ffffffff811851b0 bpf_tracing_prog_attach+0x0
> > > (kernel/bpf/syscall.c:2708:1)
> > >
> > > SINGLE KPROBE:
> > > ffffffff81e0007c entry_SYSCALL_64_after_hwframe+0x44
> > > (arch/x86/entry/entry_64.S:113:0)
> > > ffffffff81cd2b15 do_syscall_64+0x35
> > > (arch/x86/entry/common.c:80:7)
> > >                  . do_syscall_x64
> > > (arch/x86/entry/common.c:50:12)
> > > ffffffff811881aa __x64_sys_bpf+0x1a
> > > (kernel/bpf/syscall.c:4765:1)
> > > ffffffff81185e79 __sys_bpf+0x3f9
> > > (kernel/bpf/syscall.c:4705:9)
> > > ffffffff8118583a bpf_raw_tracepoint_open+0x19a
> > > (kernel/bpf/syscall.c:3069:6)
> > >                  bpf_tracing_prog_attach
> > >
> > > You can see that in multi-attach kprobe we only get one entry, which
> > > is the very last function in the stack trace. We have no parent
> > > function captured whatsoever. Jiri, Masami, any ideas what's wrong and
> > > how to fix this? Let's try to figure this out and fix it before the
> > > feature makes it into the kernel release. Thanks in advance!
> >
> > oops, I should have tried kstack with the bpftrace's kretprobe, I see the same:
> >
> >       # ./src/bpftrace -e 'kretprobe:x* { @[kstack] = count(); }'
> >       Attaching 1 probe...
> >       Attaching 3340probes
> >       ^C
> >
> >       @[
> >           xfs_trans_apply_dquot_deltas+0
> >       ]: 22
> >       @[
> >           xlog_cil_commit+0
> >       ]: 22
> >       @[
> >           xlog_grant_push_threshold+0
> >       ]: 22
> >       @[
> >           xfs_trans_add_item+0
> >       ]: 22
> >       @[
> >           xfs_log_reserve+0
> >       ]: 22
> >       @[
> >           xlog_space_left+0
> >       ]: 22
> >       @[
> >           xfs_buf_offset+0
> >       ]: 22
> >       @[
> >           xfs_trans_free_dqinfo+0
> >       ]: 22
> >       @[
> >           xlog_ticket_alloc+0
> >           xfs_log_reserve+5
> >       ]: 22
> >       @[
> >           xfs_cil_prepare_item+0
> >
> >
> > I think it's because we set original ip for return probe to have
> > bpf_get_func_ip working properly, but it breaks backtrace of course
> >
> > I'm not sure we could bring along the original regs for return probe,
> > but I have an idea how to workaround the bpf_get_func_ip issue and
> > keep the registers intact for other helpers
>
> change below is using bpf_run_ctx to store link and entry ip on stack,
> where helpers can find it.. it fixed the retprobe backtrace for me
>
> I had to revert the get_func_ip inline.. it's squashed in the change
> below for quick testing.. I'll send revert in separate patch with the
> formal change
>
> could you please test?
>

Yep, tried locally and now stack traces work as expected. Thanks!
Please resubmit as a proper patch and add my ack:

Acked-by: Andrii Nakryiko <andrii@kernel.org>

> thanks,
> jirka
>
>
> ---

[...]

> -static u64 bpf_kprobe_multi_cookie(struct bpf_run_ctx *ctx, u64 ip)
> +static u64 bpf_kprobe_multi_cookie(struct bpf_run_ctx *ctx)
>  {
> +       struct bpf_kprobe_multi_run_ctx *run_ctx;
>         struct bpf_kprobe_multi_link *link;
> +       u64 *cookie, entry_ip;
>         unsigned long *addr;
> -       u64 *cookie;
>
>         if (WARN_ON_ONCE(!ctx))
>                 return 0;
> -       link = container_of(ctx, struct bpf_kprobe_multi_link, run_ctx);
> +       run_ctx = container_of(current->bpf_ctx, struct bpf_kprobe_multi_run_ctx, run_ctx);
> +       link = run_ctx->link;
> +       entry_ip = run_ctx->entry_ip;

nit: this can be assigned after we checked that we have link->cookies

>         if (!link->cookies)
>                 return 0;
> -       addr = bsearch(&ip, link->addrs, link->cnt, sizeof(ip),
> +       addr = bsearch(&entry_ip, link->addrs, link->cnt, sizeof(entry_ip),
>                        __bpf_kprobe_multi_cookie_cmp);
>         if (!addr)
>                 return 0;

[...]
