Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C35304CE09D
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 00:11:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbiCDXL4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 18:11:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiCDXLz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 18:11:55 -0500
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D98A27B8EA;
        Fri,  4 Mar 2022 15:11:07 -0800 (PST)
Received: by mail-il1-x12a.google.com with SMTP id 9so7618652ily.11;
        Fri, 04 Mar 2022 15:11:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=X4taavSadsggKeb4rknknWXisF5e/T1PGvi3KCr5H+M=;
        b=byKIeNMTxIgFG4wc4N8atzIKr7qfxKi3ZsDIbugLOuMEx/GrOgENgE7pzsWHUFwvpP
         mXcb85HgPzUYOrbshOu7QUTmeIZ3OxAbeoT0d4xUJcA7e39qJEZTWa8kA/rKb0EhfGZ7
         uE2DfswE65IDMmuf0uGGkQ/p3BJCQ4ZxAceN3eFJAjBzLgmbeUzyD6y0+GMAeEsOXvxH
         NM80pLfwO1p6M9Idl1cIyChJhlqR+d7XOAcpOnUb1PYQeSnXMxXycvOvlUZY8RO5xXWW
         H3gK/LO0YXeZiAW+/bYHK8cAUEFEa8T7IxjvaE1Q8imoipfGWNdjqhi4eo5KC4blNS44
         w0TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=X4taavSadsggKeb4rknknWXisF5e/T1PGvi3KCr5H+M=;
        b=DfP209Wx9yEacclroRAFsCYr/deqbFCNPgooRt0jA4cvYDVOKSpG/aDrwYXRoOV5Bn
         9tpTzT/aaoeKo/t9crJHAvdAAyYBmfinmpx9zbPi8liGH1itI76EiUcVMADXBDFWcaSp
         axvPB27mAYVb71VaRYPYa5HF6Sb+ISN9asfEoXboLIsZKpWspjslaH5j/jFvDiyEPKLG
         6DifysNW2pRrTFTG9NqUznWGjJnVv5k46MYCmx70eZl7QvEYfDdql96BQxhb9QRYbgBH
         siFxRJ4cHi7FRMkODxCPxLA5ACP1SsC5NWnALSWuIyzBrqFNA7gqcxKXVSdWr+1fMbYf
         JSsg==
X-Gm-Message-State: AOAM531pD4VPTplEOtmt9aQIX6KOSVvVG+enC26rmGPoB6fHLmngNZav
        f5DcUhvgfJzNEuy68W1B++GjDqNSRHtW2iDBQk0=
X-Google-Smtp-Source: ABdhPJw+4+4MQaAZyaxo4cRT719vpWq+5BB6U7i8xVvol44pdAHUQUXqeFHlur1W3mrqR0tL0F1RMU6um9CFfwFvmdo=
X-Received: by 2002:a05:6e02:1a88:b0:2be:a472:90d9 with SMTP id
 k8-20020a056e021a8800b002bea47290d9mr842331ilv.239.1646435466848; Fri, 04 Mar
 2022 15:11:06 -0800 (PST)
MIME-Version: 1.0
References: <20220222170600.611515-1-jolsa@kernel.org>
In-Reply-To: <20220222170600.611515-1-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 4 Mar 2022 15:10:55 -0800
Message-ID: <CAEf4BzaugZWf6f_0JzA-mqaGfp52tCwEp5dWdhpeVt6GjDLQ3Q@mail.gmail.com>
Subject: Re: [PATCHv2 bpf-next 0/8] bpf: Add kprobe multi link
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

On Tue, Feb 22, 2022 at 9:06 AM Jiri Olsa <jolsa@kernel.org> wrote:
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

I think it's shaping up pretty well. Great work, Jiri! Can't wait to
adopt this in retsnoop. See below about dependency on Masami's
patches.

> Also available at:
>   https://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
>   bpf/kprobe_multi
>
> thanks,
> jirka
>
>
> [1] https://lore.kernel.org/bpf/164458044634.586276.3261555265565111183.stgit@devnote2/

Masami, Jiri, Steven, what would be the logistics here? What's the
plan for getting this upstream? Any idea about timelines? I really
hope it won't take as long as it took for kretprobe stack trace
capturing fixes last year to land. Can we take Masami's changes
through bpf-next tree? If yes, Steven, can you please review and give
your acks? Thanks for understanding!

> ---
> Jiri Olsa (10):
>       lib/sort: Add priv pointer to swap function
>       bpf: Add multi kprobe link
>       bpf: Add bpf_get_func_ip kprobe helper for multi kprobe link
>       bpf: Add support to inline bpf_get_func_ip helper on x86
>       bpf: Add cookie support to programs attached with kprobe multi link
>       libbpf: Add libbpf_kallsyms_parse function
>       libbpf: Add bpf_link_create support for multi kprobes
>       libbpf: Add bpf_program__attach_kprobe_opts support for multi kprobes
>       selftest/bpf: Add kprobe_multi attach test
>       selftest/bpf: Add kprobe_multi test for bpf_cookie values
>
>  include/linux/bpf_types.h                                   |   1 +
>  include/linux/sort.h                                        |   4 +-
>  include/linux/trace_events.h                                |   6 ++
>  include/linux/types.h                                       |   1 +
>  include/uapi/linux/bpf.h                                    |  14 ++++
>  kernel/bpf/syscall.c                                        |  26 ++++++--
>  kernel/bpf/verifier.c                                       |  21 +++++-
>  kernel/trace/bpf_trace.c                                    | 331 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  lib/sort.c                                                  |  42 +++++++++---
>  tools/include/uapi/linux/bpf.h                              |  14 ++++
>  tools/lib/bpf/bpf.c                                         |   7 ++
>  tools/lib/bpf/bpf.h                                         |   9 ++-
>  tools/lib/bpf/libbpf.c                                      | 192 +++++++++++++++++++++++++++++++++++++++++++++--------
>  tools/lib/bpf/libbpf_internal.h                             |   5 ++
>  tools/testing/selftests/bpf/prog_tests/bpf_cookie.c         |  72 ++++++++++++++++++++
>  tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c  | 115 ++++++++++++++++++++++++++++++++
>  tools/testing/selftests/bpf/progs/kprobe_multi.c            |  58 ++++++++++++++++
>  tools/testing/selftests/bpf/progs/kprobe_multi_bpf_cookie.c |  62 +++++++++++++++++
>  18 files changed, 930 insertions(+), 50 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
>  create mode 100644 tools/testing/selftests/bpf/progs/kprobe_multi.c
>  create mode 100644 tools/testing/selftests/bpf/progs/kprobe_multi_bpf_cookie.c
