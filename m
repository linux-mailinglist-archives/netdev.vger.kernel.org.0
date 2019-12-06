Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 083BC115631
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 18:11:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbfLFRLI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 12:11:08 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:46980 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726298AbfLFRLH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 12:11:07 -0500
Received: by mail-qt1-f195.google.com with SMTP id 38so7741858qtb.13;
        Fri, 06 Dec 2019 09:11:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DI7p9OTIgrgEnPGEh+lJXFr4UIv6maYDRk9V3SIdLFo=;
        b=R7quL+pPGjwkAiTw9/ofD5HZu8wpN+/ZBKG8uQsn7UMRrLtxiX2E/ye0hDpk0K30Js
         9VxaqscccQZprqW/ny0kDZKUTrf4i3vP4WVrpC6UHJSbas9LR3ZFMAOrkAzxCrxnnXmM
         g1zTRF681PI6bTIl3Iy8NrqFD1TkPOgjxfc3FIBaib8d7rujrBTet4fo3bqd6K+u6P1d
         yRD7JbUgjBmnLSDCD+YNm4eaZl5A+kakOHxui5X/ilNIRIMCbpbkIDqCd7BN8XkpVxPQ
         /pqslJXMM7pucPEUeYrS4/zMQ7piR4rk/mGI+z3KGHRtOtkPArs527wbylr7adXCoYsA
         CAOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DI7p9OTIgrgEnPGEh+lJXFr4UIv6maYDRk9V3SIdLFo=;
        b=I8qNJ5TH76b9nXo4rOOk+0L8PmhlLQ8RtePbvjO1jKcCLZHIpfgbutUuS66rfX74xU
         kqKblGYNQkRZ+OBxk5uu9GUSy5vuZOnyqGTvShrDIMWsad1Pjremekr19e6u8Y6BRgJH
         RtQ++MRAGsqUXyHwS+3GJBm90z/EgmLbTc4+C83j1eMSo2QHf2xk/5+fmTbCyAl/hIyd
         Ys6iaTuxyuMyCCnkgltXrf5WtDR5g54/ZYKNOIqlDfsapLctPh7KaBxJ3cMStvlSFVX1
         II6q/9+v6phYNqhZ/tNXhTG2MF04SCqbuJK7VWL5EwX+EQffTM19SDCr2p4pTSMNGj4e
         tCug==
X-Gm-Message-State: APjAAAWBB1oovvClUUQMfzc4P7sLpTDyUN+fHpSQYcndoSqwvkpjAgPg
        P0dMx042CaRSXGjgnCYpCkq8WX0y72lPxhwml98=
X-Google-Smtp-Source: APXvYqyC/FGP5JOPFRRbXpu2MsJ6ADyHnA7+CWiirrS+6v68+WGimIVw/C2bXr0v+wRB+PrkaRl7bfM2yu5tyDGyYQo=
X-Received: by 2002:ac8:1385:: with SMTP id h5mr13442494qtj.59.1575652266670;
 Fri, 06 Dec 2019 09:11:06 -0800 (PST)
MIME-Version: 1.0
References: <20191206001226.67825-1-dxu@dxuuu.xyz>
In-Reply-To: <20191206001226.67825-1-dxu@dxuuu.xyz>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 6 Dec 2019 09:10:48 -0800
Message-ID: <CAEf4BzY-ahRm5HPrqRWF5seOjGM+PJs+J+DTbuws3r=jd_PArg@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: Add LBR data to BPF_PROG_TYPE_PERF_EVENT prog context
To:     Daniel Xu <dxu@dxuuu.xyz>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Peter Ziljstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 5, 2019 at 4:13 PM Daniel Xu <dxu@dxuuu.xyz> wrote:
>
> Last-branch-record is an intel CPU feature that can be configured to
> record certain branches that are taken during code execution. This data
> is particularly interesting for profile guided optimizations. perf has
> had LBR support for a while but the data collection can be a bit coarse
> grained.
>
> We (Facebook) have recently run a lot of experiments with feeding
> filtered LBR data to various PGO pipelines. We've seen really good
> results (+2.5% throughput with lower cpu util and lower latency) by
> feeding high request latency LBR branches to the compiler on a
> request-oriented service. We used bpf to read a special request context
> ID (which is how we associate branches with latency) from a fixed
> userspace address. Reading from the fixed address is why bpf support is
> useful.
>
> Aside from this particular use case, having LBR data available to bpf
> progs can be useful to get stack traces out of userspace applications
> that omit frame pointers.
>
> This patch adds support for LBR data to bpf perf progs.
>
> Some notes:
> * We use `__u64 entries[BPF_MAX_LBR_ENTRIES * 3]` instead of
>   `struct perf_branch_entry[BPF_MAX_LBR_ENTRIES]` because checkpatch.pl
>   warns about including a uapi header from another uapi header
>
> * We define BPF_MAX_LBR_ENTRIES as 32 (instead of using the value from
>   arch/x86/events/perf_events.h) because including arch specific headers
>   seems wrong and could introduce circular header includes.
>
> Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
> ---
>  include/uapi/linux/bpf_perf_event.h |  5 ++++
>  kernel/trace/bpf_trace.c            | 39 +++++++++++++++++++++++++++++
>  2 files changed, 44 insertions(+)
>
> diff --git a/include/uapi/linux/bpf_perf_event.h b/include/uapi/linux/bpf_perf_event.h
> index eb1b9d21250c..dc87e3d50390 100644
> --- a/include/uapi/linux/bpf_perf_event.h
> +++ b/include/uapi/linux/bpf_perf_event.h
> @@ -10,10 +10,15 @@
>
>  #include <asm/bpf_perf_event.h>
>
> +#define BPF_MAX_LBR_ENTRIES 32
> +
>  struct bpf_perf_event_data {
>         bpf_user_pt_regs_t regs;
>         __u64 sample_period;
>         __u64 addr;
> +       __u64 nr_lbr;
> +       /* Cast to struct perf_branch_entry* before using */
> +       __u64 entries[BPF_MAX_LBR_ENTRIES * 3];
>  };
>

I wonder if instead of hard-coding this in bpf_perf_event_data, could
we achieve this and perhaps even more flexibility by letting users
access underlying bpf_perf_event_data_kern and use CO-RE to read
whatever needs to be read from perf_sample_data, perf_event, etc?
Would that work?

>  #endif /* _UAPI__LINUX_BPF_PERF_EVENT_H__ */
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index ffc91d4935ac..96ba7995b3d7 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c

[...]
