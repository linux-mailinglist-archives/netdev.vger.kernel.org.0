Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA3D54708B9
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 19:28:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245227AbhLJSc1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 13:32:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237062AbhLJSc1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 13:32:27 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF261C061746;
        Fri, 10 Dec 2021 10:28:51 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id f186so23303070ybg.2;
        Fri, 10 Dec 2021 10:28:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=F2fgbC4erWq9UsFudgbaV5qAPl0PQ6tDda7up6K0tTg=;
        b=IaMoXPj4bsk9XqzlYSLlR81xzprUIJEhici3JOAjOoOQiQD5sIOJzOnTKexinUCnqw
         fkw04JQNFkyFDXwvRfN0VnLQTU5PQ6ACmXfPOTI9FxQ/wAsTmr7M4zuUGoXKpiaixNh6
         5LKpiVaJW+SIaEQDuTcIP1902HsjOgtLxd2cgR+uZ20W/Nl5pc5RCqbLDA0/DDiX0RnF
         //aRahox+JjT8vW+3HhGfAaU0WnO4op03uPp1VklVhkLQ+BvH8xug0jToC9OtY5ie3eC
         2ma25sB1JmoOq6OVn8ob/lmi6Pa2QCBI4TNjfnf+Hv6uWkxiBjA2798rmZl8pOSei0XZ
         uoig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=F2fgbC4erWq9UsFudgbaV5qAPl0PQ6tDda7up6K0tTg=;
        b=4d9WIw78qmKpQKRl1oLPmayaHZF15xsqqjhCLZMEg3Kc2HUPd+TQLXemM4SIk04Zr7
         0lPUvnt1+BNM61k25TVuNoCmP92HTvOvQJhK5neswbTVJ2g/xPNO2PZUJd9uCH3NBUcn
         YTt3IiuWoSepNq1mgGvuSs0HNnGtNYf0J7vxjHffR+Zh7IVbNg50JPvQzhF243+nAu4d
         tMm2LI/r1DidQR2OlTRPQOdqYCF5qzyX9QgiTvbbm5FpDdKTyQHD1fXiXnCVtRTnuG1Z
         ZGqmpNub9jJfzdsMhzXiX5nbKzKKNuyNujHGssLDFJDvxVncSudQzXe9XPoojGPZWt1U
         NgCQ==
X-Gm-Message-State: AOAM532PlFK2DE+/ONVM78bAKY5h0Ktr4Xu4W/p2Ak1JfUnAPn1CLv50
        OfSDAtgOmVMM50QdWnW3zKRKoCq4vUHRTJ/QKDU=
X-Google-Smtp-Source: ABdhPJxzOmRVdJgVJ8ugMlkwCS3n3QBUZOwr7negMQlIqzto6w6mA4XRk02qNRD2WZui+lMa92nKQxpTauNAJiJGV54=
X-Received: by 2002:a25:e406:: with SMTP id b6mr16688360ybh.529.1639160930856;
 Fri, 10 Dec 2021 10:28:50 -0800 (PST)
MIME-Version: 1.0
References: <20211124084119.260239-1-jolsa@kernel.org> <20211124084119.260239-2-jolsa@kernel.org>
 <CAEf4Bzb5wyW=62fr-BzQsuFL+mt5s=+jGcdxKwZK0+AW18uD_Q@mail.gmail.com>
 <Yafp193RdskXofbH@krava> <CAEf4BzbmKffmcM3WhCthrgfbWZBZj52hGH0Ju0itXyJ=yD01NA@mail.gmail.com>
 <YbC4EXS3pyCbh7/i@krava> <YbNLPdrA80OMbzdS@krava>
In-Reply-To: <YbNLPdrA80OMbzdS@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 10 Dec 2021 10:28:39 -0800
Message-ID: <CAEf4Bzb_qBVqCn-A=kP7FNLKQz1mvsr3wQfSMPOJ6_5M4zC+ig@mail.gmail.com>
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

On Fri, Dec 10, 2021 at 4:42 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Wed, Dec 08, 2021 at 02:50:09PM +0100, Jiri Olsa wrote:
> > On Mon, Dec 06, 2021 at 07:15:58PM -0800, Andrii Nakryiko wrote:
> > > On Wed, Dec 1, 2021 at 1:32 PM Jiri Olsa <jolsa@redhat.com> wrote:
> > > >
> > > > On Tue, Nov 30, 2021 at 10:53:58PM -0800, Andrii Nakryiko wrote:
> > > > > On Wed, Nov 24, 2021 at 12:41 AM Jiri Olsa <jolsa@redhat.com> wrote:
> > > > > >
> > > > > > Adding support to create multiple probes within single perf event.
> > > > > > This way we can associate single bpf program with multiple kprobes,
> > > > > > because bpf program gets associated with the perf event.
> > > > > >
> > > > > > The perf_event_attr is not extended, current fields for kprobe
> > > > > > attachment are used for multi attachment.
> > > > >
> > > > > I'm a bit concerned with complicating perf_event_attr further to
> > > > > support this multi-attach. For BPF, at least, we now have
> > > > > bpf_perf_link and corresponding BPF_LINK_CREATE command in bpf()
> > > > > syscall which allows much simpler and cleaner API to do this. Libbpf
> > > > > will actually pick bpf_link-based attachment if kernel supports it. I
> > > > > think we should better do bpf_link-based approach from the get go.
> > > > >
> > > > > Another thing I'd like you to keep in mind and think about is BPF
> > > > > cookie. Currently kprobe/uprobe/tracepoint allow to associate
> > > > > arbitrary user-provided u64 value which will be accessible from BPF
> > > > > program with bpf_get_attach_cookie(). With multi-attach kprobes this
> > > > > because extremely crucial feature to support, otherwise it's both
> > > > > expensive, inconvenient and complicated to be able to distinguish
> > > > > between different instances of the same multi-attach kprobe
> > > > > invocation. So with that, what would be the interface to specify these
> > > > > BPF cookies for this multi-attach kprobe, if we are going through
> > > > > perf_event_attr. Probably picking yet another unused field and
> > > > > union-izing it with a pointer. It will work, but makes the interface
> > > > > even more overloaded. While for LINK_CREATE we can just add another
> > > > > pointer to a u64[] with the same size as number of kfunc names and
> > > > > offsets.
> > > >
> > > > I'm not sure we could bypass perf event easily.. perhaps introduce
> > > > BPF_PROG_TYPE_RAW_KPROBE as we did for tracepoints or just new
> > > > type for multi kprobe attachment like BPF_PROG_TYPE_MULTI_KPROBE
> > > > that might be that way we'd have full control over the API
> > >
> > > Sure, new type works.
> > >
> > > >
> > > > >
> > > > > But other than that, I'm super happy that you are working on these
> > > > > complicated multi-attach capabilities! It would be great to benchmark
> > > > > one-by-one attachment vs multi-attach to the same set of kprobes once
> > > > > you arrive at the final implementation.
> > > >
> > > > I have the change for bpftrace to use this and even though there's
> > > > some speed up, it's not as substantial as for trampolines
> > > >
> > > > looks like we 'only' got rid of the multiple perf syscall overheads,
> > > > compared to rcu syncs timeouts like we eliminated for trampolines
> > >
> > > if it's just eliminating a pretty small overhead of multiple syscalls,
> > > then it would be quite disappointing to add a bunch of complexity just
> > > for that.
> >
> > I meant it's not as huge save as for trampolines, but I expect some
> > noticeable speedup, I'll make more becnhmarks with current patchset
>
> so with this approach there's noticable speedup, but it's not the
> 'instant attachment speed' as for trampolines
>
> as a base I used bpftrace with change that allows to reuse bpf program
> for multiple kprobes
>
> bpftrace standard attach of 672 kprobes:
>
>   Performance counter stats for './src/bpftrace -vv -e kprobe:kvm* { @[kstack] += 1; }  i:ms:10 { printf("KRAVA\n"); exit() }':
>
>       70.548897815 seconds time elapsed
>
>        0.909996000 seconds user
>       50.622834000 seconds sys
>
>
> bpftrace using interface from this patchset attach of 673 kprobes:
>
>   Performance counter stats for './src/bpftrace -vv -e kprobe:kvm* { @[kstack] += 1; }  i:ms:10 { printf("KRAVA\n"); exit() }':
>
>       36.947586803 seconds time elapsed
>
>        0.272585000 seconds user
>       30.900831000 seconds sys
>
>
> so it's noticeable, but I wonder it's not enough ;-)

Typical retsnoop run for BPF use case is attaching to ~1200 functions.
Answer for yourself if you think the tool that takes 36 seconds to
start up is a great user experience? ;)

>
> jirka
>
> >
> > > Are there any reasons we can't use the same low-level ftrace
> > > batch attach API to speed this up considerably? I assume it's only
> > > possible if kprobe is attached at the beginning of the function (not
> > > sure how kretprobe is treated here), so we can either say that this
> > > new kprobe prog type can only be attached at the beginning of each
> > > function and enforce that (probably would be totally reasonable
> > > assumption as that's what's happening most frequently in practice).
> > > Worst case, should be possible to split all requested attach targets
> > > into two groups, one fast at function entry and all the rest.
> > >
> > > Am I too far off on this one? There might be some more complications
> > > that I don't see.
> >
> > I'd need to check more on kprobes internals, but.. ;-)
> >
> > the new ftrace interface is special for 'direct' trampolines and
> > I think that although kprobes can use ftrace for attaching, they
> > use it in a different way
> >
> > also this current 'multi attach' approach is on top of current kprobe
> > interface, if we wanted to use the new ftrace API we'd need to add new
> > kprobe interface and change the kprobe attaching to use it (for cases
> > it's attached at the function entry)
> >
> > jirka
> >
> > >
> > > >
> > > > I'll make full benchmarks once we have some final solution
> > > >
> > > > jirka
> > > >
> > >
>
