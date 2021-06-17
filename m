Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 129363ABD68
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 22:30:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232021AbhFQUcH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 16:32:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231282AbhFQUcG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 16:32:06 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DBE4C061574;
        Thu, 17 Jun 2021 13:29:57 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id u30so5388458qke.7;
        Thu, 17 Jun 2021 13:29:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hmo9PgbBFNXuJWyk3PR5KBaafEgXO9bsKC9QDalJJ0Y=;
        b=YQzqHXRHbIsbTBPQFnTQMly0B2oPHdb9TiAoM73Sr85swieKb7NT8l6/U1mzDDB3y7
         ASU0a7uWtzqDl4uBmsFVgu45m/93qvmiEdGwTEngy+5FBdRcmNp4Bl6j2G9ICqj8Ar7l
         X5ZVvP4ICtu8+voFnVwmf02BjGnRGBvMIZVIhP1wkllFJJnQ19Rt3IMer7WRMjfGi5yK
         cbhkmWhKsLCPfs4r32aX4kdTulh89G1fZ0+83+IPRGYp3sfCg3xYJaLgjgR/7H/GIfzf
         3PLW6XCu5R9WgLOKKGKDRS1j36KxJ3vhKiHliL6f0Mhrk2sZeDK2KYKxXa97imWW5iwm
         LOPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hmo9PgbBFNXuJWyk3PR5KBaafEgXO9bsKC9QDalJJ0Y=;
        b=Gxh2jQlph1LPsg/I9JbjUUs8Vf5gOuFdEK+NZ+qMLMo6+DZpqjswgwkexMVIiJjDxC
         Q+my9XE0sdfagHc1+fxkXATS1OP/AYxr1Qypy1e8y8EUCO3d8c7mA1X24Z9pNzYd8Fcm
         i32oBiIDvvas+y2mrLr0W3Yg1jn3Ip3qmLS1XTp/A5aduZ6S9HiEOHrcdxLRBuG/Goet
         scc5UZz22N3uAxiILXFUtC27EY5lP8/VNnmeQx7jpp7Ki2Dw+9vxj8Vv/SzdRJnDgztY
         hRh3c5skz7y77Ibqs2n8UM9cuYIZjwBpAqOpw83k4AjhQCwdJxfXlGRUi+fi6SXLI/VL
         ufsw==
X-Gm-Message-State: AOAM531G5ICiV6YbbkGGcWQ2OEpOVq0MtQxtff+DaktXt67ZrL2j/drt
        u9EHKvQgCUKBuTK0pGzzWNKj+vrFnWrcqIe97bk=
X-Google-Smtp-Source: ABdhPJynZAmzBTKjbo1zrnPn1G9CM2FxudMBLjzvD+LzIjiMDlRzxe5j44Dj3I4vZ2/e8pVrLU5x4pFaJWZilXf91CQ=
X-Received: by 2002:a25:870b:: with SMTP id a11mr1055705ybl.260.1623961796141;
 Thu, 17 Jun 2021 13:29:56 -0700 (PDT)
MIME-Version: 1.0
References: <20210605111034.1810858-1-jolsa@kernel.org>
In-Reply-To: <20210605111034.1810858-1-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 17 Jun 2021 13:29:45 -0700
Message-ID: <CAEf4BzaK+t7zom6JHWf6XSPGDxjwhG4Wj3+CHKVshdmP3=FgnA@mail.gmail.com>
Subject: Re: [RFCv3 00/19] x86/ftrace/bpf: Add batch support for
 direct/tracing attach
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Viktor Malik <vmalik@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 5, 2021 at 4:12 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> hi,
> saga continues.. ;-) previous post is in here [1]
>
> After another discussion with Steven, he mentioned that if we fix
> the ftrace graph problem with direct functions, he'd be open to
> add batch interface for direct ftrace functions.
>
> He already had prove of concept fix for that, which I took and broke
> up into several changes. I added the ftrace direct batch interface
> and bpf new interface on top of that.
>
> It's not so many patches after all, so I thought having them all
> together will help the review, because they are all connected.
> However I can break this up into separate patchsets if necessary.
>
> This patchset contains:
>
>   1) patches (1-4) that fix the ftrace graph tracing over the function
>      with direct trampolines attached
>   2) patches (5-8) that add batch interface for ftrace direct function
>      register/unregister/modify
>   3) patches (9-19) that add support to attach BPF program to multiple
>      functions
>
> In nutshell:
>
> Ad 1) moves the graph tracing setup before the direct trampoline
> prepares the stack, so they don't clash
>
> Ad 2) uses ftrace_ops interface to register direct function with
> all functions in ftrace_ops filter.
>
> Ad 3) creates special program and trampoline type to allow attachment
> of multiple functions to single program.
>
> There're more detailed desriptions in related changelogs.
>
> I have working bpftrace multi attachment code on top this. I briefly
> checked retsnoop and I think it could use the new API as well.

Ok, so I had a bit of time and enthusiasm to try that with retsnoop.
The ugly code is at [0] if you'd like to see what kind of changes I
needed to make to use this (it won't work if you check it out because
it needs your libbpf changes synced into submodule, which I only did
locally). But here are some learnings from that experiment both to
emphasize how important it is to make this work and how restrictive
are some of the current limitations.

First, good news. Using this mass-attach API to attach to almost 1000
kernel functions goes from

Plain fentry/fexit:
===================
real    0m27.321s
user    0m0.352s
sys     0m20.919s

to

Mass-attach fentry/fexit:
=========================
real    0m2.728s
user    0m0.329s
sys     0m2.380s

It's a 10x speed up. And a good chunk of those 2.7 seconds is in some
preparatory steps not related to fentry/fexit stuff.

It's not exactly apples-to-apples, though, because the limitations you
have right now prevents attaching both fentry and fexit programs to
the same set of kernel functions. This makes it pretty useless for a
lot of cases, in particular for retsnoop. So I haven't really tested
retsnoop end-to-end, I only verified that I do see fentries triggered,
but can't have matching fexits. So the speed-up might be smaller due
to additional fexit mass-attach (once that is allowed), but it's still
a massive difference. So we absolutely need to get this optimization
in.

Few more thoughts, if you'd like to plan some more work ahead ;)

1. We need similar mass-attach functionality for kprobe/kretprobe, as
there are use cases where kprobe are more useful than fentry (e.g., >6
args funcs, or funcs with input arguments that are not supported by
BPF verifier, like struct-by-value). It's not clear how to best
represent this, given currently we attach kprobe through perf_event,
but we'll need to think about this for sure.

2. To make mass-attach fentry/fexit useful for practical purposes, it
would be really great to have an ability to fetch traced function's
IP. I.e., if we fentry/fexit func kern_func_abc, bpf_get_func_ip()
would return IP of that functions that matches the one in
/proc/kallsyms. Right now I do very brittle hacks to do that.

So all-in-all, super excited about this, but I hope all those issues
are addressed to make retsnoop possible and fast.

  [0] https://github.com/anakryiko/retsnoop/commit/8a07bc4d8c47d025f755c108f92f0583e3fda6d8

>
>
> Also available at:
>   https://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
>   bpf/batch
>
> thanks,
> jirka
>
>
> [1] https://lore.kernel.org/bpf/20210413121516.1467989-1-jolsa@kernel.org/
>
> ---
> Jiri Olsa (17):
>       x86/ftrace: Remove extra orig rax move
>       tracing: Add trampoline/graph selftest
>       ftrace: Add ftrace_add_rec_direct function
>       ftrace: Add multi direct register/unregister interface
>       ftrace: Add multi direct modify interface
>       ftrace/samples: Add multi direct interface test module
>       bpf, x64: Allow to use caller address from stack
>       bpf: Allow to store caller's ip as argument
>       bpf: Add support to load multi func tracing program
>       bpf: Add bpf_trampoline_alloc function
>       bpf: Add support to link multi func tracing program
>       libbpf: Add btf__find_by_pattern_kind function
>       libbpf: Add support to link multi func tracing program
>       selftests/bpf: Add fentry multi func test
>       selftests/bpf: Add fexit multi func test
>       selftests/bpf: Add fentry/fexit multi func test
>       selftests/bpf: Temporary fix for fentry_fexit_multi_test
>
> Steven Rostedt (VMware) (2):
>       x86/ftrace: Remove fault protection code in prepare_ftrace_return
>       x86/ftrace: Make function graph use ftrace directly
>

[...]
