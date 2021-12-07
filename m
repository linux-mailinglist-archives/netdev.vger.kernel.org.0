Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBC3E46B14E
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 04:16:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233670AbhLGDTn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 22:19:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbhLGDTk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 22:19:40 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE104C061746;
        Mon,  6 Dec 2021 19:16:10 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id y68so37117715ybe.1;
        Mon, 06 Dec 2021 19:16:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LNIl78nckWjbXlFhMvmgIRUvjw5KLk7k5w+8AsbkB/Q=;
        b=pkjjpbSJYrSJIT1vUnWcBPWxYHNh5AFQzR6BgYygbMumqzzt0bk1i5HUQoiFYFymCJ
         4zQZuIbaqtYAz2/XG4Me5IpxpSMww147GWlV3VjbaEu1TrNqaYn+8Q7a/vtY95Enmhoo
         nUars06ljDV9ZOsY4qhrG9r4Oe7EZMRemIeWC9Usoars4OtU9V77b90fqNwq+ASG4UaC
         m0+Dfwa5YSt7MOA0mC/8ikgzb4OjLnMSUTO1EjtIMF7/ME3ZU2ACAU0a07iZ/KErZ1OD
         AKNidnW/vQKhpsd+9FfHUmVkdCFdAlT+4peqFGB4pVXxij/EuNKA+W63baNVFoXGYng5
         xfzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LNIl78nckWjbXlFhMvmgIRUvjw5KLk7k5w+8AsbkB/Q=;
        b=CWv+0IzKnkVOcLtgwc97FGgmx7tVa5C2dVabsiUBeK5E82CLJUCzkRplauXwYpM3BB
         SE5l7v7/eHFM4YK9hSk8yeweq0P6Wu4xRoMobQVtCY9B8I3c1/W2CbXBojX2pjKuRp7L
         kEhQHJSmdoCCsCkcOanK48C3lMvhgvnpOa9s5VJEmiDINztGD9hhkPmnoz9tu8tHV4rw
         HLP5SFOKKovdaZ5mQOPRgh2lyD/s+0syvpz+1KT/a3arBAHa+TeblVZxTkUk2OrKpS2x
         UWIDVBl/GG+OE/lh7q/svZe7tV63974JbPXeTzZxk9/wN2l7kYjWtToxrXdSe938malg
         dOog==
X-Gm-Message-State: AOAM532dsWXGsZo/0RpHFvGIQFQPeGaa4Sdih/zSLwJOxwNvYPXZ891b
        3Yx7ut4kUP9vaSG/ObLY0iuDuB+NpNJPhuA6Veo=
X-Google-Smtp-Source: ABdhPJwT8QjQbugo9c7+SC0qEVR104ES+uIjUurEnscVlr2lktlzSaC4XbZwxfkDp+yhckp2grsrS4MciWEAHIzy9kk=
X-Received: by 2002:a25:abaa:: with SMTP id v39mr47437825ybi.367.1638846970036;
 Mon, 06 Dec 2021 19:16:10 -0800 (PST)
MIME-Version: 1.0
References: <20211124084119.260239-1-jolsa@kernel.org> <20211124084119.260239-2-jolsa@kernel.org>
 <CAEf4Bzb5wyW=62fr-BzQsuFL+mt5s=+jGcdxKwZK0+AW18uD_Q@mail.gmail.com> <Yafp193RdskXofbH@krava>
In-Reply-To: <Yafp193RdskXofbH@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 6 Dec 2021 19:15:58 -0800
Message-ID: <CAEf4BzbmKffmcM3WhCthrgfbWZBZj52hGH0Ju0itXyJ=yD01NA@mail.gmail.com>
Subject: Re: [PATCH 1/8] perf/kprobe: Add support to create multiple probes
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Ravi Bangoria <ravi.bangoria@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 1, 2021 at 1:32 PM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Tue, Nov 30, 2021 at 10:53:58PM -0800, Andrii Nakryiko wrote:
> > On Wed, Nov 24, 2021 at 12:41 AM Jiri Olsa <jolsa@redhat.com> wrote:
> > >
> > > Adding support to create multiple probes within single perf event.
> > > This way we can associate single bpf program with multiple kprobes,
> > > because bpf program gets associated with the perf event.
> > >
> > > The perf_event_attr is not extended, current fields for kprobe
> > > attachment are used for multi attachment.
> >
> > I'm a bit concerned with complicating perf_event_attr further to
> > support this multi-attach. For BPF, at least, we now have
> > bpf_perf_link and corresponding BPF_LINK_CREATE command in bpf()
> > syscall which allows much simpler and cleaner API to do this. Libbpf
> > will actually pick bpf_link-based attachment if kernel supports it. I
> > think we should better do bpf_link-based approach from the get go.
> >
> > Another thing I'd like you to keep in mind and think about is BPF
> > cookie. Currently kprobe/uprobe/tracepoint allow to associate
> > arbitrary user-provided u64 value which will be accessible from BPF
> > program with bpf_get_attach_cookie(). With multi-attach kprobes this
> > because extremely crucial feature to support, otherwise it's both
> > expensive, inconvenient and complicated to be able to distinguish
> > between different instances of the same multi-attach kprobe
> > invocation. So with that, what would be the interface to specify these
> > BPF cookies for this multi-attach kprobe, if we are going through
> > perf_event_attr. Probably picking yet another unused field and
> > union-izing it with a pointer. It will work, but makes the interface
> > even more overloaded. While for LINK_CREATE we can just add another
> > pointer to a u64[] with the same size as number of kfunc names and
> > offsets.
>
> I'm not sure we could bypass perf event easily.. perhaps introduce
> BPF_PROG_TYPE_RAW_KPROBE as we did for tracepoints or just new
> type for multi kprobe attachment like BPF_PROG_TYPE_MULTI_KPROBE
> that might be that way we'd have full control over the API

Sure, new type works.

>
> >
> > But other than that, I'm super happy that you are working on these
> > complicated multi-attach capabilities! It would be great to benchmark
> > one-by-one attachment vs multi-attach to the same set of kprobes once
> > you arrive at the final implementation.
>
> I have the change for bpftrace to use this and even though there's
> some speed up, it's not as substantial as for trampolines
>
> looks like we 'only' got rid of the multiple perf syscall overheads,
> compared to rcu syncs timeouts like we eliminated for trampolines

if it's just eliminating a pretty small overhead of multiple syscalls,
then it would be quite disappointing to add a bunch of complexity just
for that. Are there any reasons we can't use the same low-level ftrace
batch attach API to speed this up considerably? I assume it's only
possible if kprobe is attached at the beginning of the function (not
sure how kretprobe is treated here), so we can either say that this
new kprobe prog type can only be attached at the beginning of each
function and enforce that (probably would be totally reasonable
assumption as that's what's happening most frequently in practice).
Worst case, should be possible to split all requested attach targets
into two groups, one fast at function entry and all the rest.

Am I too far off on this one? There might be some more complications
that I don't see.

>
> I'll make full benchmarks once we have some final solution
>
> jirka
>
