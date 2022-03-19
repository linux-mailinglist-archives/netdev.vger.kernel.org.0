Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE0624DE658
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 06:51:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242231AbiCSFwT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 01:52:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232502AbiCSFwS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 01:52:18 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBB7D1C552D;
        Fri, 18 Mar 2022 22:50:57 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id r11so7138813ila.1;
        Fri, 18 Mar 2022 22:50:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UJiHGXJ2eAmWwMN9fAhzZWE81wIepC4CBHvqvioYL/c=;
        b=Js5djmWx+pfwQ3TiK7dkibfPifuNy38a5c7MvV6XQTMUF+XxuqExND96ETL71YFl6f
         uxVRZbyNITLq9Rya+LZVlU8zFwtpAKqosX+pxz88aeyXEruG3bHk/fIRmSZme8LHD9qm
         G9L1gQxBtMd/pk/KQ7iR8g6wZtNjd6Muz8GyMP3b7WGQezjs7Lf4mLQJp0fORWsGVqfx
         ySTSy4xZhio+Sqr7sDmA9M1EU3yMrAShLT8hfVaEFzlU8ZsFQkihJPgjMlhlLc/bYhbX
         vPGJhYUoTv0yWPamL32V50g7VjjUf3Bs+/qQLoQvxXhZHMUTmXcnbdI6mxYo46jIFrEr
         lL3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UJiHGXJ2eAmWwMN9fAhzZWE81wIepC4CBHvqvioYL/c=;
        b=eXS+lME4EneQVEyvlCzEB5u6brb2s7Yk4AjOK5jcvQUFW+z4usuEcGmg9ujiTHAhzA
         UYfTp0DVOVmEtJDhVNt00cSwpEngo36FKgdVHIMfgWWBWKTy9QTYegyM7O7cgbf7OaBY
         4gujV3Kv0cM8q5N0i7GYhVmKTkJZRj57xjaW+Z2vxavqxoap+oUJLvFeDPtfh2zYLfOV
         RfNUeN51eGmOiA7AJzvhV7tQw+FBTyD37I9QMEQwZFcrZavool8ddS4uqG41G9f+w0/Y
         Y1C5p0gj3PH1VFNnbadv/UkSPeXMGFLG9T3zNx/5yalp2BYha1ly09kR3vlEePwCTq/b
         /gaQ==
X-Gm-Message-State: AOAM5321RXUC/Xk0u+p7FUSJwWR+5nuClzHFwI31MC3jscSs7DaGwgS0
        uGFaAVNt9gcKULEcJjH/18RQwa3LERe8UbzwyFI=
X-Google-Smtp-Source: ABdhPJwQcvg6jS0kqgiPNaPigqL1suTMb87ObhmtPJgoBGQw8IkTaol/oKLmy+ry5rlrgytI6iVEqWKtlkLUPT/QFj4=
X-Received: by 2002:a05:6e02:16c7:b0:2c7:e458:d863 with SMTP id
 7-20020a056e0216c700b002c7e458d863mr4985465ilx.71.1647669057012; Fri, 18 Mar
 2022 22:50:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220316122419.933957-1-jolsa@kernel.org>
In-Reply-To: <20220316122419.933957-1-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 18 Mar 2022 22:50:46 -0700
Message-ID: <CAEf4BzbpjN6ca7D9KOTiFPOoBYkciYvTz0UJNp5c-_3ptm=Mrg@mail.gmail.com>
Subject: Re: [PATCHv3 bpf-next 00/13] bpf: Add kprobe multi link
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
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

On Wed, Mar 16, 2022 at 5:24 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> hi,
> this patchset adds new link type BPF_TRACE_KPROBE_MULTI that attaches
> kprobe program through fprobe API [1] instroduced by Masami.
>
> The fprobe API allows to attach probe on multiple functions at once very
> fast, because it works on top of ftrace. On the other hand this limits
> the probe point to the function entry or return.
>
>
> With bpftrace support I see following attach speed:
>
>   # perf stat --null -r 5 ./src/bpftrace -e 'kprobe:x* { } i:ms:1 { exit(); } '
>   Attaching 2 probes...
>   Attaching 3342 functions
>   ...
>
>   1.4960 +- 0.0285 seconds time elapsed  ( +-  1.91% )
>
> v3 changes:
>   - based on latest fprobe post from Masami [2]
>   - add acks
>   - add extra comment to kprobe_multi_link_handler wrt entry ip setup [Masami]
>   - keep swap_words_64 static and swap values directly in
>     bpf_kprobe_multi_cookie_swap [Andrii]
>   - rearrange locking/migrate setup in kprobe_multi_link_prog_run [Andrii]
>   - move uapi fields [Andrii]
>   - add bpf_program__attach_kprobe_multi_opts function [Andrii]
>   - many small test changes [Andrii]
>   - added tests for bpf_program__attach_kprobe_multi_opts
>   - make kallsyms_lookup_name check for empty string [Andrii]
>
> v2 changes:
>   - based on latest fprobe changes [1]
>   - renaming the uapi interface to kprobe multi
>   - adding support for sort_r to pass user pointer for swap functions
>     and using that in cookie support to keep just single functions array
>   - moving new link to kernel/trace/bpf_trace.c file
>   - using single fprobe callback function for entry and exit
>   - using kvzalloc, libbpf_ensure_mem functions
>   - adding new k[ret]probe.multi sections instead of using current kprobe
>   - used glob_match from test_progs.c, added '?' matching
>   - move bpf_get_func_ip verifier inline change to seprate change
>   - couple of other minor fixes
>
>
> Also available at:
>   https://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
>   bpf/kprobe_multi
>
> thanks,
> jirka
>
>
> [1] https://lore.kernel.org/bpf/164458044634.586276.3261555265565111183.stgit@devnote2/
> [2] https://lore.kernel.org/bpf/164735281449.1084943.12438881786173547153.stgit@devnote2/
> ---
> Jiri Olsa (13):
>       lib/sort: Add priv pointer to swap function
>       kallsyms: Skip the name search for empty string
>       bpf: Add multi kprobe link
>       bpf: Add bpf_get_func_ip kprobe helper for multi kprobe link
>       bpf: Add support to inline bpf_get_func_ip helper on x86
>       bpf: Add cookie support to programs attached with kprobe multi link
>       libbpf: Add libbpf_kallsyms_parse function
>       libbpf: Add bpf_link_create support for multi kprobes
>       libbpf: Add bpf_program__attach_kprobe_multi_opts function
>       selftests/bpf: Add kprobe_multi attach test
>       selftests/bpf: Add kprobe_multi bpf_cookie test
>       selftests/bpf: Add attach test for bpf_program__attach_kprobe_multi_opts
>       selftests/bpf: Add cookie test for bpf_program__attach_kprobe_multi_opts
>

Ok, so I've integrated multi-attach kprobes into retsnoop. It was
pretty straightforward. Here are some numbers for the speed of
attaching and, even more importantly, detaching for a set of almost
400 functions. It's a bit less functions for fentry-based mode due to
more limited BTF information for static functions. Note that retsnoop
attaches two BPF programs for each kernel function, so it's actually
two multi-attach kprobes, each attaching to 397 functions. For
single-attach kprobe, we perform 397 * 2 = 794 attachments.

I've been invoking retsnoop with the following specified set of
functions: -e '*sys_bpf*' -a ':kernel/bpf/syscall.c' -a
':kernel/bpf/verifier.c' -a ':kernel/bpf/btf.c' -a
':kernel/bpf/core.c'. So basically bpf syscall entry functions and all
the discoverable functions from syscall.c, verifier.c, core.c and
btf.c from kernel/bpf subdirectory.

Results:

fentry attach/detach (263 kfuncs): 2133 ms / 31671  ms (33 seconds)
kprobe attach/detach (397 kfuncs): 3121 ms / 13195 ms (16 seconds)
multi-kprobe attach/detach (397 kfuncs): 9 ms / 248 ms (0.25 seconds)

So as you can see, the speed up is tremendous! API is also very
convenient, I didn't have to modify retsnoop internals much to
accommodate multi-attach API. Great job!

Now for the bad news. :(

Stack traces from multi-attach kretprobe are broken, which makes all
this way less useful.

Below, see stack traces captured with multi- and single- kretprobes
for two different use cases. Single kprobe stack traces make much more
sense. Ignore that last function doesn't have actual address
associated with it (i.e. for __sys_bpf and bpf_tracing_prog_attach,
respectively). That's just how retsnoop is doing things, I think. We
actually were capturing stack traces from inside __sys_bpf (first
case) and bpf_tracing_prog_attach (second case).

MULTI KPROBE:
ffffffff81185a80 __sys_bpf+0x0
(kernel/bpf/syscall.c:4622:1)

SINGLE KPROBE:
ffffffff81e0007c entry_SYSCALL_64_after_hwframe+0x44
(arch/x86/entry/entry_64.S:113:0)
ffffffff81cd2b15 do_syscall_64+0x35
(arch/x86/entry/common.c:80:7)
                 . do_syscall_x64
(arch/x86/entry/common.c:50:12)
ffffffff811881aa __x64_sys_bpf+0x1a
(kernel/bpf/syscall.c:4765:1)
                 __sys_bpf


MULTI KPROBE:
ffffffff811851b0 bpf_tracing_prog_attach+0x0
(kernel/bpf/syscall.c:2708:1)

SINGLE KPROBE:
ffffffff81e0007c entry_SYSCALL_64_after_hwframe+0x44
(arch/x86/entry/entry_64.S:113:0)
ffffffff81cd2b15 do_syscall_64+0x35
(arch/x86/entry/common.c:80:7)
                 . do_syscall_x64
(arch/x86/entry/common.c:50:12)
ffffffff811881aa __x64_sys_bpf+0x1a
(kernel/bpf/syscall.c:4765:1)
ffffffff81185e79 __sys_bpf+0x3f9
(kernel/bpf/syscall.c:4705:9)
ffffffff8118583a bpf_raw_tracepoint_open+0x19a
(kernel/bpf/syscall.c:3069:6)
                 bpf_tracing_prog_attach

You can see that in multi-attach kprobe we only get one entry, which
is the very last function in the stack trace. We have no parent
function captured whatsoever. Jiri, Masami, any ideas what's wrong and
how to fix this? Let's try to figure this out and fix it before the
feature makes it into the kernel release. Thanks in advance!


[...]
