Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 861C048F3E6
	for <lists+netdev@lfdr.de>; Sat, 15 Jan 2022 02:10:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231837AbiAOBIo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 20:08:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231825AbiAOBIo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 20:08:44 -0500
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38444C061574;
        Fri, 14 Jan 2022 17:08:44 -0800 (PST)
Received: by mail-il1-x132.google.com with SMTP id x15so9783016ilc.5;
        Fri, 14 Jan 2022 17:08:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SguhQSidD98goHcEcMCiT3PaDe/6KqF5jSvhZbAcwRk=;
        b=NHiGLwf83Z+J4WvcapubnWeXQNYhGQEl4VuM3PQQAStk1h36D1YBs5Nyt5g6c7HJph
         E9mOJaWWrKC6IcQqeFcM21mbbOAeTgKVNJihbPDFip4jAHUAq+9Zm0XnHHLQeyKrgs0g
         BIPZ9WM65c/A1vmsU4OTiFsk/Fz+jAdDhhhmRt4WGU9pTZNMMiY+GD/ZIBlKg4h3SB27
         qitoAMVCl/hmc6W0/F8pH+cFSOKYPVSQYFgYjaHw27oQAzEPsY2rn+zbNHG/9naRBWYO
         H4Dc64P4YstnCzG1crCDxC8V1FLG7R/7E3mFDyEAJz+gNqZG2Mdmo611Mo9baRDlVJrL
         5+wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SguhQSidD98goHcEcMCiT3PaDe/6KqF5jSvhZbAcwRk=;
        b=lG+2bSWsaGG8oYMmZWrwVeCWJwNNcXa85tIX58uZ3v5ryr99+zTeaUXqtCZjVT+TLx
         bNZ6DudOfNLN5j9nvcglRJ4MwHUrSa1Vqss4WUVAN/JwoVYJH2Slg+Z/lW25K32XO+SG
         +Sd0+BYijx5lCRlDxdNfcPGxPtun4wQ89mGGHV6QQcqY1IUkhuFV0xt+0nMygYscMmqO
         xUP61KiqijLRnzIZ1l0zMrssAc7w8uAUxjTAbugIrBGvaZ+xkCMXUd7FvCZoCJ9XXtwx
         L+ysH48SVIjmjP1BhoCxk6NrMzYfXOlMQz7J4SBo2ztOGAnok7PO6fUY5kqCQMX6he0I
         xiow==
X-Gm-Message-State: AOAM533+Xp8gMjN4gjML0QQI8CAzr7oebBAS+deoR7s3rYZp/fDVeoz2
        o4U31zkbKPEAcUPvMqi8mV/t1PtDQcIxMrUzJxM=
X-Google-Smtp-Source: ABdhPJwGLYxnU95xaDvzf6OsQToxn3hALPGJAKmy5zkq3aHdqqkbt5gl6/g9wDkG9TeB3ereYnB0dIGh1RV78ImTprE=
X-Received: by 2002:a05:6e02:1749:: with SMTP id y9mr5705696ill.252.1642208923596;
 Fri, 14 Jan 2022 17:08:43 -0800 (PST)
MIME-Version: 1.0
References: <164199616622.1247129.783024987490980883.stgit@devnote2>
In-Reply-To: <164199616622.1247129.783024987490980883.stgit@devnote2>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 14 Jan 2022 17:08:32 -0800
Message-ID: <CAEf4BzY9qmzemZ=3JSto+eWq9k-kX7hZKgugJRO9zZ61-pasqg@mail.gmail.com>
Subject: Re: [RFC PATCH v2 0/8] fprobe: Introduce fprobe function entry/exit probe
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

On Wed, Jan 12, 2022 at 6:02 AM Masami Hiramatsu <mhiramat@kernel.org> wrote:
>
> Hi Jiri and Alexei,
>
> Here is the 2nd version of fprobe. This version uses the
> ftrace_set_filter_ips() for reducing the registering overhead.
> Note that this also drops per-probe point private data, which
> is not used anyway.

This per-probe private data is necessary for the feature called BPF
cookie, in which each attachment has a unique user-provided u64 value
associated to it, accessible at runtime through
bpf_get_attach_cookie() helper. One way or another we'll need to
support this to make these multi-attach BPF programs really useful for
generic tracing applications.

Jiri,

We've discussed with Alexei this week how cookies can be supported for
multi-attach fentry (where it seems even more challenging than in
kprobe case), and agreed on rather simple solution, which roughly goes
like this. When multi-attaching either fentry/fexit program, save
sorted array of IP addresses and then sorted in the same order as IPs
list of u64 cookies. At runtime, bpf_get_attach_cookie() helper should
somehow get access to these two arrays and functions IP (that we
already have with bpf_get_func_ip()), perform binary search and locate
necessary cookie. This offloads the overhead of finding this cookie to
actual call site of bpf_get_attach_cookie() (and it's a log(N), so not
bad at all, especially if BPF program can be optimized to call this
helper just once).

I think something like that should be doable for Masami's fprobe-based
multi-attach kprobes, right? That would allow to have super-fast
attachment, but still support BPF cookie per each individual IP/kernel
function attachment. I haven't looked at code thoroughly, though,
please let me know if I'm missing something fundamental.

>
> This introduces the fprobe, the function entry/exit probe with
> multiple probe point support. This also introduces the rethook
> for hooking function return as same as kretprobe does. This
> abstraction will help us to generalize the fgraph tracer,
> because we can just switch it from rethook in fprobe, depending
> on the kernel configuration.
>
> The patch [1/8] and [7/8] are from your series[1]. Other libbpf
> patches will not be affected by this change.
>
> [1] https://lore.kernel.org/all/20220104080943.113249-1-jolsa@kernel.org/T/#u
>
> I also added an out-of-tree (just for testing) patch at the
> end of this series ([8/8]) for adding a wildcard support to
> the sample program. With that patch, it shows how long the
> registration will take;
>
> # time insmod fprobe_example.ko symbol='btrfs_*'
> [   36.130947] fprobe_init: 1028 symbols found
> [   36.177901] fprobe_init: Planted fprobe at btrfs_*
> real    0m 0.08s
> user    0m 0.00s
> sys     0m 0.07s
>
> Thank you,
>
> ---
>
> Jiri Olsa (2):
>       ftrace: Add ftrace_set_filter_ips function
>       bpf: Add kprobe link for attaching raw kprobes
>
> Masami Hiramatsu (6):
>       fprobe: Add ftrace based probe APIs
>       rethook: Add a generic return hook
>       rethook: x86: Add rethook x86 implementation
>       fprobe: Add exit_handler support
>       fprobe: Add sample program for fprobe
>       [DO NOT MERGE] Out-of-tree: Support wildcard symbol option to sample
>
>
>  arch/x86/Kconfig                |    1
>  arch/x86/kernel/Makefile        |    1
>  arch/x86/kernel/rethook.c       |  115 ++++++++++++++++++++
>  include/linux/bpf_types.h       |    1
>  include/linux/fprobe.h          |   57 ++++++++++
>  include/linux/ftrace.h          |    3 +
>  include/linux/rethook.h         |   74 +++++++++++++
>  include/linux/sched.h           |    3 +
>  include/uapi/linux/bpf.h        |   12 ++
>  kernel/bpf/syscall.c            |  195 +++++++++++++++++++++++++++++++++-
>  kernel/exit.c                   |    2
>  kernel/fork.c                   |    3 +
>  kernel/kallsyms.c               |    1
>  kernel/trace/Kconfig            |   22 ++++
>  kernel/trace/Makefile           |    2
>  kernel/trace/fprobe.c           |  168 +++++++++++++++++++++++++++++
>  kernel/trace/ftrace.c           |   54 ++++++++-
>  kernel/trace/rethook.c          |  226 +++++++++++++++++++++++++++++++++++++++
>  samples/Kconfig                 |    7 +
>  samples/Makefile                |    1
>  samples/fprobe/Makefile         |    3 +
>  samples/fprobe/fprobe_example.c |  154 +++++++++++++++++++++++++++
>  tools/include/uapi/linux/bpf.h  |   12 ++
>  23 files changed, 1103 insertions(+), 14 deletions(-)
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
