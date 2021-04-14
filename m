Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D3BE35EA2C
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 03:04:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348951AbhDNBEh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 21:04:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343683AbhDNBEh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 21:04:37 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20951C061574;
        Tue, 13 Apr 2021 18:04:17 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id c195so20242665ybf.9;
        Tue, 13 Apr 2021 18:04:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Jt5Bm0sT1rY+VlJDPunajUmGrJtnv9u2S8IJTi+nbHw=;
        b=I6Jl4V97/Eck56QqES+evUSe6PYbwB3UVva6vBMfnQvPQmw7Kck24aCS5Ej40JNjVY
         wD6HHcjilC56m6iwox2Nnow3QOdNY580bVraI2NAVAotOeWSm9htEFsus/cam3JRZ6f2
         S1RWWPR4DYsVj9njD+iFCK8gcS2JMnaWMGCxC9XEoXRAjevKUCWconcvLp69oCQWlQ20
         XUAhbDZpvP5UNxldp+EdFzObz8YPbLksebmvlDmGq0B92d+WUddPfXy19INFz7iyKK9d
         d0aZtPy4IVfeL3+Y1EeZK1WQBt2zOBbXPSpg+GDqxI8gIx/a3ehmK8jjjKx5rVjwgKr7
         qdxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Jt5Bm0sT1rY+VlJDPunajUmGrJtnv9u2S8IJTi+nbHw=;
        b=n8pDiotI29CVUIBetQ++bdaSZzrSy0N5iaRyikUtFpa9nk80qXaGdgqIPvgsjH+/yE
         //0kXf3FQp+X3j7igoVwsMtS7/ZDW3rIYR2OgAGjhXE9ur9hpCWBIJuazia8bCGhlLq8
         bj1W96UtLR7PN1LZ/iNZhDTf/0J+6MgEt4sdbDL+C3TdDmzdRkMOSRNKQ0PUObcrn+bO
         6JT1rmmOiFt5zmbaJoUGQHXlMmoVdKeSusW2Lk5kxnw1zCR9um0qQscKClY+uV6R6afa
         9E/2D9XmJbBmyY7jYgSopaUWK4fmLlAT+8a7NEEk9IuZlTJ61PHjUN/ev/Yx2ombRzcI
         tE5A==
X-Gm-Message-State: AOAM532o96DD92bxvyDsBz50lmhL1zjeOVPMrAJmFAz8XcJDHz4KCG59
        oQ/VML6aIvLBIC1x5pPC1Ggp8xdzaJhmgNSqZU2i9Dh0teT4OA==
X-Google-Smtp-Source: ABdhPJzm6t5dO1GlzXU8l/B4d174GTa+LXa531eKq1r4wilNradOTvfXGaEJtJ82Uoi30nSddMHiU4BpLNlK2bMJ1HE=
X-Received: by 2002:a25:c4c5:: with SMTP id u188mr47966750ybf.425.1618362256338;
 Tue, 13 Apr 2021 18:04:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210413121516.1467989-1-jolsa@kernel.org>
In-Reply-To: <20210413121516.1467989-1-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 13 Apr 2021 18:04:05 -0700
Message-ID: <CAEf4Bzazst1rBi4=LuP6_FnPXCRYBNFEtDnK3UVBj6Eo6xFNtQ@mail.gmail.com>
Subject: Re: [PATCHv2 RFC bpf-next 0/7] bpf: Add support for ftrace probe
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jesper Brouer <jbrouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Viktor Malik <vmalik@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 13, 2021 at 7:57 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> hi,
> sending another attempt on speeding up load of multiple probes
> for bpftrace and possibly other tools (first post in [1]).
>
> This patchset adds support to attach bpf program directly to
> ftrace probe as suggested by Steven and it speeds up loading
> for bpftrace commands like:
>
>    # bpftrace -e 'kfunc:_raw_spin* { @[probe] = count(); }'
>    # bpftrace -e 'kfunc:ksys_* { @[probe] = count(); }'
>
> Using ftrace with single bpf program for attachment to multiple
> functions is much faster than current approach, where we need to
> load and attach program for each probe function.
>

Ok, so first of all, I think it's super important to allow fast
attachment of a single BPF program to multiple kernel functions (I
call it mass-attachment). I've been recently prototyping a tool
(retsnoop, [0]) that allows attaching fentry/fexit to multiple
functions, and not having this feature turned into lots of extra code
and slow startup/teardown speeds. So we should definitely fix that.

But I think the approach you've taken is not the best one, even though
it's a good starting point for discussion.

First, you are saying function return attachment support is missing,
but is not needed so far. I actually think that without func return
the whole feature is extremely limiting. Not being able to measure
function latency  by tracking enter/exit events is crippling for tons
of useful applications. So I think this should go with both at the
same time.

But guess what, we already have a good BPF infra (BPF trampoline and
fexit programs) that supports func exit tracing. Additionally, it
supports the ability to read input arguments *on function exit*, which
is something that kretprobe doesn't support and which is often a very
limiting restriction, necessitating complicated logic to trace
function entry just to store input arguments. It's a killer feature
and one that makes fexit so much more useful than kretprobe.

The only problem is that currently we have a 1:1:1 relationship
between BPF trampoline, BPF program, and kernel function. I think we
should allow to have a single BPF program, using a single BPF
trampoline, but being able to attach to multiple kernel functions
(1:1:N). This will allow to validate BPF program once, allocate only
one dedicated BPF trampoline, and then (with appropriate attach API)
attach them in a batch mode.

We'll probably have to abandon direct memory read for input arguments,
but for these mass-attachment scenarios that's rarely needed at all.
Just allowing to read input args as u64 and providing traced function
IP would be enough to do a lot. BPF trampoline can just
unconditionally save the first 6 arguments, similarly how we do it
today for a specific BTF function, just always 6.

As for attachment, dedicating an entire new FD for storing functions
seems like an overkill. I think BPF_LINK_CREATE is the right place to
do this, providing an array of BTF IDs to identify all functions to be
attached to. It's both simple and efficient.

We'll get to libbpf APIs and those pseudo-regexp usage a bit later, I
don't think we need to discuss that at this stage yet :)

So, WDYT about BPF trampoline-based generic fentry/fexit with mass-attach API?

  [0] https://github.com/anakryiko/retsnoop

> Also available in
>   git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
>   bpf/ftrace
>
> thanks,
> jirka
>
>
> [1] https://lore.kernel.org/bpf/20201022082138.2322434-1-jolsa@kernel.org/
> ---
> Jiri Olsa (7):
>       bpf: Move bpf_prog_start/end functions to generic place
>       bpf: Add bpf_functions object
>       bpf: Add support to attach program to ftrace probe
>       libbpf: Add btf__find_by_pattern_kind function
>       libbpf: Add support to load and attach ftrace probe
>       selftests/bpf: Add ftrace probe to fentry test
>       selftests/bpf: Add ftrace probe test
>
>  include/uapi/linux/bpf.h                             |   8 ++++
>  kernel/bpf/syscall.c                                 | 381 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  kernel/bpf/trampoline.c                              |  97 ---------------------------------------
>  kernel/bpf/verifier.c                                |  27 +++++++++++
>  net/bpf/test_run.c                                   |   1 +
>  tools/include/uapi/linux/bpf.h                       |   8 ++++
>  tools/lib/bpf/bpf.c                                  |  12 +++++
>  tools/lib/bpf/bpf.h                                  |   5 +-
>  tools/lib/bpf/btf.c                                  |  67 +++++++++++++++++++++++++++
>  tools/lib/bpf/btf.h                                  |   3 ++
>  tools/lib/bpf/libbpf.c                               |  74 ++++++++++++++++++++++++++++++
>  tools/lib/bpf/libbpf.map                             |   1 +
>  tools/testing/selftests/bpf/prog_tests/fentry_test.c |   5 +-
>  tools/testing/selftests/bpf/prog_tests/ftrace_test.c |  48 +++++++++++++++++++
>  tools/testing/selftests/bpf/progs/fentry_test.c      |  16 +++++++
>  tools/testing/selftests/bpf/progs/ftrace_test.c      |  17 +++++++
>  16 files changed, 671 insertions(+), 99 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/ftrace_test.c
>  create mode 100644 tools/testing/selftests/bpf/progs/ftrace_test.c
>
