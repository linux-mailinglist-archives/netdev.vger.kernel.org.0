Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C85C0495656
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 23:25:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378071AbiATWYa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 17:24:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238984AbiATWY2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 17:24:28 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D5BDC061574;
        Thu, 20 Jan 2022 14:24:27 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id a18so6220984ilq.6;
        Thu, 20 Jan 2022 14:24:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6VwUv3cNz7g/RSSZ/ppqeuln5DSPNtnS50dC5TR7BTE=;
        b=T/mvfkjiHyunaL9NZ8ciJ60yKOwLwg6uxL/W13+DSK06mOhTEU1VDZgC1AaoeDtmeg
         7U/tBH3yCHIzlaepG+XHJnfbb70mhX1phtQIFFo/y3JNClJo9qQmeohE4x62vv/TKQKE
         ZdF3R6diw3clOAAhsg0dbtPag3f3awuDw8lrWRQCAQ0rAOW791UHWo1h1Ysfl5+j4bnc
         W74pGiEyq3moMLpvLkzvGd9Ep/UuvCUA8hogA8cXzDyUu6yB7h2wMA2a7PBXIf6Zi5h8
         EXe782et69S7dtlNCmpdA5dpOEdqla2lbhw6Bq1xxnQQNidLe8CAljL3EJjbz7CT67VA
         DkzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6VwUv3cNz7g/RSSZ/ppqeuln5DSPNtnS50dC5TR7BTE=;
        b=KDeo0b4H45UGT3H7NeaDgABfT4jrUXueTdvEWNN5xk/zjnvCoQCjspTJnJy2ONR/Pe
         gbt6g2OjcUKlqMj62kYW5e4Zo1D1y/w965Dvh1P+wrlloYDX5044uR+j6fCsyMy1CM81
         gUBxmASYeIsfUo+DU8Nl735MKhCbpdezsTYnovJqJd1Dik2onzaNsvgMVPjP7jvmXNfq
         D9k1bitqMTRbTMWMDriZbdDUZ+30TfpJDb9a8CdtxOCdhmV7iFT+Md8N7pO31nfE3IYM
         Ds/P1iHNrQ9+fHzmdccKz+hNj9FReFsfAaNlGqOpV3CjVjRqovpC7j5xNvFb0iDUe8+B
         A1xA==
X-Gm-Message-State: AOAM533iLxfUktM4slOMqnYgRZKcTk1h2PFVVp4dFtpGtA5qOL/cmtpU
        GWUBvqS7HKHFxoZzQVpzZMqsPPSpu5WE2/WXyDA=
X-Google-Smtp-Source: ABdhPJwhLnj4TJOCJlgZSSzP4rrkjNcKzInQf//XnyLSzUggHiSIvoZBPDiakd3GZZtcyyoxhYyVHGb7ffY0nraFqLw=
X-Received: by 2002:a05:6e02:1748:: with SMTP id y8mr572291ill.305.1642717466961;
 Thu, 20 Jan 2022 14:24:26 -0800 (PST)
MIME-Version: 1.0
References: <164260419349.657731.13913104835063027148.stgit@devnote2>
In-Reply-To: <164260419349.657731.13913104835063027148.stgit@devnote2>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 20 Jan 2022 14:24:15 -0800
Message-ID: <CAEf4Bzbbimea3ydwafXSHFiEffYx5zAcwGNKk8Zi6QZ==Vn0Ug@mail.gmail.com>
Subject: Re: [RFC PATCH v3 0/9] fprobe: Introduce fprobe function entry/exit probe
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Jiri Olsa <jolsa@redhat.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S . Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 19, 2022 at 6:56 AM Masami Hiramatsu <mhiramat@kernel.org> wrote:
>
> Hello Jiri,
>
> Here is the 3rd version of fprobe. I added some comments and
> fixed some issues. But I still saw some problems when I add
> your selftest patches.
>
> This series introduces the fprobe, the function entry/exit probe
> with multiple probe point support. This also introduces the rethook
> for hooking function return as same as kretprobe does. This
> abstraction will help us to generalize the fgraph tracer,
> because we can just switch it from rethook in fprobe, depending
> on the kernel configuration.
>
> The patch [1/9] and [7/9] are from Jiri's series[1]. Other libbpf
> patches will not be affected by this change.
>
> [1] https://lore.kernel.org/all/20220104080943.113249-1-jolsa@kernel.org/T/#u
>
> However, when I applied all other patches on top of this series,
> I saw the "#8 bpf_cookie" test case has been stacked (maybe related
> to the bpf_cookie issue which Andrii and Jiri talked?) And when I
> remove the last selftest patch[2], the selftest stopped at "#112
> raw_tp_test_run".
>
> [2] https://lore.kernel.org/all/20220104080943.113249-1-jolsa@kernel.org/T/#m242d2b3a3775eeb5baba322424b15901e5e78483
>
> Note that I used tools/testing/selftests/bpf/vmtest.sh to check it.
>
> This added 2 more out-of-tree patches. [8/9] is for adding wildcard
> support to the sample program, [9/9] is a testing patch for replacing
> kretprobe trampoline with rethook.
> According to this work, I noticed that using rethook in kretprobe
> needs 2 steps.
>  1. port the rethook on all architectures which supports kretprobes.
>     (some arch requires CONFIG_KPROBES for rethook)
>  2. replace kretprobe trampoline with rethook for all archs, at once.
>     This must be done by one treewide patch.
>
> Anyway, I'll do the kretprobe update in the next step as another series.
> (This testing patch is just for confirming the rethook is correctly
>  implemented.)
>
> BTW, on the x86, ftrace (with fentry) location address is same as
> symbol address. But on other archs, it will be different (e.g. arm64
> will need 2 instructions to save link-register and call ftrace, the
> 2nd instruction will be the ftrace location.)
> Does libbpf correctly handle it?

libbpf doesn't do anything there. The interface for kprobe is based on
function name and kernel performs name lookups internally to resolve
IP. For fentry it's similar (kernel handles IP resolution), but
instead of function name we specify BTF ID of a function type.

>
> Thank you,
>
> ---
>
> Jiri Olsa (2):
>       ftrace: Add ftrace_set_filter_ips function
>       bpf: Add kprobe link for attaching raw kprobes
>
> Masami Hiramatsu (7):
>       fprobe: Add ftrace based probe APIs
>       rethook: Add a generic return hook
>       rethook: x86: Add rethook x86 implementation
>       fprobe: Add exit_handler support
>       fprobe: Add sample program for fprobe
>       [DO NOT MERGE] Out-of-tree: Support wildcard symbol option to sample
>       [DO NOT MERGE] out-of-tree: kprobes: Use rethook for kretprobe
>
>
>  arch/x86/Kconfig                |    1
>  arch/x86/include/asm/unwind.h   |    8 +
>  arch/x86/kernel/Makefile        |    1
>  arch/x86/kernel/kprobes/core.c  |  106 --------------
>  arch/x86/kernel/rethook.c       |  115 +++++++++++++++
>  include/linux/bpf_types.h       |    1
>  include/linux/fprobe.h          |   84 +++++++++++
>  include/linux/ftrace.h          |    3
>  include/linux/kprobes.h         |   85 +----------
>  include/linux/rethook.h         |   99 +++++++++++++
>  include/linux/sched.h           |    4 -
>  include/uapi/linux/bpf.h        |   12 ++
>  kernel/bpf/syscall.c            |  195 +++++++++++++++++++++++++-
>  kernel/exit.c                   |    3
>  kernel/fork.c                   |    4 -
>  kernel/kallsyms.c               |    1
>  kernel/kprobes.c                |  265 +++++------------------------------
>  kernel/trace/Kconfig            |   22 +++
>  kernel/trace/Makefile           |    2
>  kernel/trace/fprobe.c           |  179 ++++++++++++++++++++++++
>  kernel/trace/ftrace.c           |   54 ++++++-
>  kernel/trace/rethook.c          |  295 +++++++++++++++++++++++++++++++++++++++
>  kernel/trace/trace_kprobe.c     |    4 -
>  kernel/trace/trace_output.c     |    2
>  samples/Kconfig                 |    7 +
>  samples/Makefile                |    1
>  samples/fprobe/Makefile         |    3
>  samples/fprobe/fprobe_example.c |  154 ++++++++++++++++++++
>  tools/include/uapi/linux/bpf.h  |   12 ++
>  29 files changed, 1283 insertions(+), 439 deletions(-)
>  create mode 100644 arch/x86/kernel/rethook.c
>  create mode 100644 include/linux/fprobe.h
>  create mode 100644 include/linux/rethook.h
>  create mode 100644 kernel/trace/fprobe.c
>  create mode 100644 kernel/trace/rethook.c
>  create mode 100644 samples/fprobe/Makefile
>  create mode 100644 samples/fprobe/fprobe_example.c
>
> --
> Masami Hiramatsu (Linaro) <mhiramat@kernel.org>
