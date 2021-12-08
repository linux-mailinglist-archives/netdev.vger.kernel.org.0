Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E9A046D4CE
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 14:50:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234347AbhLHNxr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 08:53:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:51318 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232918AbhLHNxq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 08:53:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638971414;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ngC/o95nfjZsAGmMOXEbHrk4Lzl1lpLSiLYQBabrEsE=;
        b=LTlkIN+6UnfaIKpYvT7rYan0Uozzx660QDTU84+aJY332AqPDHCFZsEoVOIHRyEUIGN5D2
        E0chyWEJUT21P7mm/MEeUjwbOD906Y573gcyMyzgdBvxWaxF6B4LfiALNzPBhiCyIoSfBW
        +d9nMbSxOTqT7VDSD9qu7mWCWs3OP98=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-43-0fppwEX-OAGUBc1QHOqldA-1; Wed, 08 Dec 2021 08:50:13 -0500
X-MC-Unique: 0fppwEX-OAGUBc1QHOqldA-1
Received: by mail-ed1-f70.google.com with SMTP id bx28-20020a0564020b5c00b003e7c42443dbso2138070edb.15
        for <netdev@vger.kernel.org>; Wed, 08 Dec 2021 05:50:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ngC/o95nfjZsAGmMOXEbHrk4Lzl1lpLSiLYQBabrEsE=;
        b=rFvL+OnFHtE1sPpAUj4jt4PDXde1mvRPRKU6HKkNMPJ2D3kyIbMjBdWEP5K00Q+xoj
         9n08K6G4jAsVcjcipyFSJ6VFaYh6KRH/kUZQdi1jFUD5nn/8UklPaNYcUl7WuxlUWSUL
         y+ODf39E5vXJYKtgzDC1nGxUy4x3hfAuCcECO3BGif8jbMoxU6Miw9gHVQyY7NTWD08d
         VlMOfd8B0UFIXUme7VlxzLox2BnfQUjMZMfCNn+ZrolTvEkq17EYq8GF5+4/0oNYTMxL
         AQVSRhH279jooI5BHnIWhj8cqs+hSSkpC5CENgosU95ITlf5bYb49YR/X54v2vSACOTi
         pmfg==
X-Gm-Message-State: AOAM5317dKS9vmjRyAaEuz87AEd6T0FjMYUfu73s37WyfoiTrwMB1/Rp
        4Bq8DMb3I6DurLtuHOdhC4qNs9l/ORsOjsXYl597s9FeyXBWSsPDJLMWdzybqH3Y0un6SZ3rnul
        Ket6vFuczvHwJAD5E
X-Received: by 2002:a17:907:2da5:: with SMTP id gt37mr7755218ejc.316.1638971411357;
        Wed, 08 Dec 2021 05:50:11 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwLIOJXmw7FUtxfVB4W3JHtw41/6aeGGOGQ7t2H5HibrEe+DPzyGZu1rT2o5RzvOo5xplrq+A==
X-Received: by 2002:a17:907:2da5:: with SMTP id gt37mr7755187ejc.316.1638971411154;
        Wed, 08 Dec 2021 05:50:11 -0800 (PST)
Received: from krava ([83.240.60.218])
        by smtp.gmail.com with ESMTPSA id e1sm1528572ejy.82.2021.12.08.05.50.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 05:50:10 -0800 (PST)
Date:   Wed, 8 Dec 2021 14:50:09 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
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
Subject: Re: [PATCH 1/8] perf/kprobe: Add support to create multiple probes
Message-ID: <YbC4EXS3pyCbh7/i@krava>
References: <20211124084119.260239-1-jolsa@kernel.org>
 <20211124084119.260239-2-jolsa@kernel.org>
 <CAEf4Bzb5wyW=62fr-BzQsuFL+mt5s=+jGcdxKwZK0+AW18uD_Q@mail.gmail.com>
 <Yafp193RdskXofbH@krava>
 <CAEf4BzbmKffmcM3WhCthrgfbWZBZj52hGH0Ju0itXyJ=yD01NA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzbmKffmcM3WhCthrgfbWZBZj52hGH0Ju0itXyJ=yD01NA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 06, 2021 at 07:15:58PM -0800, Andrii Nakryiko wrote:
> On Wed, Dec 1, 2021 at 1:32 PM Jiri Olsa <jolsa@redhat.com> wrote:
> >
> > On Tue, Nov 30, 2021 at 10:53:58PM -0800, Andrii Nakryiko wrote:
> > > On Wed, Nov 24, 2021 at 12:41 AM Jiri Olsa <jolsa@redhat.com> wrote:
> > > >
> > > > Adding support to create multiple probes within single perf event.
> > > > This way we can associate single bpf program with multiple kprobes,
> > > > because bpf program gets associated with the perf event.
> > > >
> > > > The perf_event_attr is not extended, current fields for kprobe
> > > > attachment are used for multi attachment.
> > >
> > > I'm a bit concerned with complicating perf_event_attr further to
> > > support this multi-attach. For BPF, at least, we now have
> > > bpf_perf_link and corresponding BPF_LINK_CREATE command in bpf()
> > > syscall which allows much simpler and cleaner API to do this. Libbpf
> > > will actually pick bpf_link-based attachment if kernel supports it. I
> > > think we should better do bpf_link-based approach from the get go.
> > >
> > > Another thing I'd like you to keep in mind and think about is BPF
> > > cookie. Currently kprobe/uprobe/tracepoint allow to associate
> > > arbitrary user-provided u64 value which will be accessible from BPF
> > > program with bpf_get_attach_cookie(). With multi-attach kprobes this
> > > because extremely crucial feature to support, otherwise it's both
> > > expensive, inconvenient and complicated to be able to distinguish
> > > between different instances of the same multi-attach kprobe
> > > invocation. So with that, what would be the interface to specify these
> > > BPF cookies for this multi-attach kprobe, if we are going through
> > > perf_event_attr. Probably picking yet another unused field and
> > > union-izing it with a pointer. It will work, but makes the interface
> > > even more overloaded. While for LINK_CREATE we can just add another
> > > pointer to a u64[] with the same size as number of kfunc names and
> > > offsets.
> >
> > I'm not sure we could bypass perf event easily.. perhaps introduce
> > BPF_PROG_TYPE_RAW_KPROBE as we did for tracepoints or just new
> > type for multi kprobe attachment like BPF_PROG_TYPE_MULTI_KPROBE
> > that might be that way we'd have full control over the API
> 
> Sure, new type works.
> 
> >
> > >
> > > But other than that, I'm super happy that you are working on these
> > > complicated multi-attach capabilities! It would be great to benchmark
> > > one-by-one attachment vs multi-attach to the same set of kprobes once
> > > you arrive at the final implementation.
> >
> > I have the change for bpftrace to use this and even though there's
> > some speed up, it's not as substantial as for trampolines
> >
> > looks like we 'only' got rid of the multiple perf syscall overheads,
> > compared to rcu syncs timeouts like we eliminated for trampolines
> 
> if it's just eliminating a pretty small overhead of multiple syscalls,
> then it would be quite disappointing to add a bunch of complexity just
> for that.

I meant it's not as huge save as for trampolines, but I expect some
noticeable speedup, I'll make more becnhmarks with current patchset

> Are there any reasons we can't use the same low-level ftrace
> batch attach API to speed this up considerably? I assume it's only
> possible if kprobe is attached at the beginning of the function (not
> sure how kretprobe is treated here), so we can either say that this
> new kprobe prog type can only be attached at the beginning of each
> function and enforce that (probably would be totally reasonable
> assumption as that's what's happening most frequently in practice).
> Worst case, should be possible to split all requested attach targets
> into two groups, one fast at function entry and all the rest.
> 
> Am I too far off on this one? There might be some more complications
> that I don't see.

I'd need to check more on kprobes internals, but.. ;-)

the new ftrace interface is special for 'direct' trampolines and
I think that although kprobes can use ftrace for attaching, they
use it in a different way

also this current 'multi attach' approach is on top of current kprobe
interface, if we wanted to use the new ftrace API we'd need to add new
kprobe interface and change the kprobe attaching to use it (for cases
it's attached at the function entry)

jirka

> 
> >
> > I'll make full benchmarks once we have some final solution
> >
> > jirka
> >
> 

