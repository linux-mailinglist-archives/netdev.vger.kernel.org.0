Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07649366D02
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 15:41:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241066AbhDUNlh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 09:41:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36134 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229536AbhDUNlg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 09:41:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619012463;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=STcz0ul+ETL19QfN18GAZ+r8q/bNd6kMm1/aoWNmSeA=;
        b=CPiUrCPqU6QcA9y7f0E5/DiAWq+qeeUJC67rlTu3wfXk4k96sBOckZODZSuNtIJKsOfCEZ
        HyC09RZKGq0ddWWepkc+rFYpwE2zZX00//6XkWgkoexmwmLxPIYqyDK/4XyW2U3NANwe/l
        3CZh5DMgr/Y2dmeWgkUGasSxdIEu+Nw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-251-I3NGd9NBN_iruWEv8XyJwg-1; Wed, 21 Apr 2021 09:40:51 -0400
X-MC-Unique: I3NGd9NBN_iruWEv8XyJwg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B1AC21020C32;
        Wed, 21 Apr 2021 13:40:48 +0000 (UTC)
Received: from krava (unknown [10.40.195.227])
        by smtp.corp.redhat.com (Postfix) with SMTP id 583815D9C0;
        Wed, 21 Apr 2021 13:40:38 +0000 (UTC)
Date:   Wed, 21 Apr 2021 15:40:37 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Jesper Brouer <jbrouer@redhat.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Viktor Malik <vmalik@redhat.com>
Subject: Re: [PATCHv2 RFC bpf-next 0/7] bpf: Add support for ftrace probe
Message-ID: <YIArVa6IE37vsazU@krava>
References: <CAEf4BzYyVj-Tjy9ZZdAU5nOtJ8_auvVobTT6pMqg8zPb9jj-Ow@mail.gmail.com>
 <20210415111002.324b6bfa@gandalf.local.home>
 <CAEf4BzY=yBZH2Aad1hNcqCt51u0+SmNdkD6NfJRVMzF7DsvG+A@mail.gmail.com>
 <20210415170007.31420132@gandalf.local.home>
 <20210417000304.fc987dc00d706e7551b29c04@kernel.org>
 <20210416124834.05862233@gandalf.local.home>
 <YH7OXrjBIqvEZbsc@krava>
 <CAADnVQK55WzR6_JfxkMzEfUnLJnX75bRHjCkaptcVF=nQ_gWfw@mail.gmail.com>
 <YH8GxNi5VuYjwNmK@krava>
 <CAADnVQLh3tCWi=TiWnJVaMrYhJ=j-xSrJ72+XnZDP8CMZM+1mQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQLh3tCWi=TiWnJVaMrYhJ=j-xSrJ72+XnZDP8CMZM+1mQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 20, 2021 at 04:38:45PM -0700, Alexei Starovoitov wrote:

SNIP

> > >
> > > I don't see how you can do it without BTF.
> > > The mass-attach feature should prepare generic 6 or so arguments
> > > from all functions it attached to.
> > > On x86-64 it's trivial because 6 regs are the same.
> > > On arm64 is now more challenging since return value regs overlaps with
> > > first argument, so bpf trampoline (when it's ready for arm64) will look
> > > a bit different than bpf trampoline on x86-64 to preserve arg0, arg1,
> > > ..arg6, ret
> > > 64-bit values that bpf prog expects to see.
> > > On x86-32 it's even more trickier, since the same 6 args need to be copied
> > > from a combination of regs and stack.
> > > This is not some hypothetical case. We already use BTF in x86-32 JIT
> > > and btf_func_model was introduced specifically to handle such cases.
> > > So I really don't see how ftrace can do that just yet. It has to understand BTF
> > > of all of the funcs it attaches to otherwise it's just saving all regs.
> > > That approach was a pain to deal with.
> >
> > ok, my idea was to get regs from the ftrace and have arch specific code
> > to prepare 6 (or less) args for ebpf program.. that part would be
> > already in bpf code
> >
> > so you'd like to see this functionality directly in ftrace, so we don't
> > save unneeded regs, is that right?
> 
> What do you mean by "already in bpf code" ?

that it would not be part of ftrace code

> 
> The main question is an api across layers.
> If ftrace doesn't use BTF it has to prepare all regs that could be used.
> Meaning on x86-64 that has to be 6 regs for args, 1 reg for return and
> stack pointer.
> That would be enough to discover input args and return value in fexit.
> On arm64 that has to be similar, but while x86-64 can do with single pt_regs
> where %rax is updated on fexit, arm64 cannot do so, since the same register
> is used as arg1 and as a return value.
> The most generic api between ftrace and bpf layers would be two sets of
> pt_regs. One on entry and one on exit, but that's going to be very expensive.

that's what I was going for and I think it's the only way if
we use ftrace graph_ops for mass attaching

> On x86-32 it would have to be 3 regs plus stack pointer and another 2 regs
> to cover all input args and return value.
> So there will be plenty of per-arch differences.
> 
> Jiri, if you're thinking of a bpf helper like:
> u64 bpf_read_argN(pt_regs, ip, arg_num)
> that will do lookup of btf_id from ip, then it will parse btf_id and
> function proto,
> then it will translate that to btf_func_model and finally will extract the right
> argument value from a combination of stack and regs ?
> That's doable, but it's a lot of run-time overhead.
> It would be usable by bpf progs that don't care much about run-time perf
> and don't care that they're not usable 24/7 on production systems.
> Such tools exist and they're useful,
> but I'd like this mass-attach facility to be usable everywhere
> including the production and 24/7 tracing.

I did not think of this option, but yep, seems also expensive

> Hence I think it's better to do this per-arch translation during bpf
> prog attach.
> That's exactly what bpf trampoline is doing.
> Currently it's doing for single btf_id, single trampoline, and single bpf prog.
> To make the same logic work across N attach points the trampoline logic
> would need to iterate all btf_func_model-s of all btf_id-s and generate
> M trampolines (where M < N) for a combination of possible argument passing.
> On x86-64 the M will be equal to 1. On arm64 it will be equal to 1 as well.
> But on x86-32 it will depend on a set of btf_ids. It could be 1,2,..10.
> Since bpf doesn't allow to attach to struct-by-value it's only 32-bit and 64-bit
> integers to deal with and number of combinations of possible calling conventions
> is actually very small. I suspect it won't be more than 10.
> This way there will be no additional run-time overhead and bpf programs
> can be portable. They will work as-is on x86-64, x86-32, arm64.
> Just like fentry/fexit work today. Or rather they will be portable
> when bpf trampoline is supported on these archs.
> This portability is the key feature of bpf trampoline design. The bpf trampoline
> was implemented for x86-64 only so far. Arm64 patches are still wip.
> btf_func_model is used by both x86-64 and x86-32 JITs.

ok, I understand why this would be the best solution for calling
the program from multiple probes

I think it's the 'attach' layer which is the source of problems

currently there is ftrace's fgraph_ops support that allows fast mass
attach and calls callbacks for functions entry and exit:
  https://lore.kernel.org/lkml/20190525031633.811342628@goodmis.org/

these callbacks get ip/parent_ip and can get pt_regs (that's not
implemented at the moment)

but that gets us to the situation of having full pt_regs on both
entry/exit callbacks that you described above and want to avoid,
but I think it's the price for having this on top of generic
tracing layer

the way ftrace's fgraph_ops is implemented, I'm not sure it can
be as fast as current bpf entry/exit trampoline

but to better understand the pain points I think I'll try to implement
the 'mass trampolines' call to the bpf program you described above and
attach it for now to fgraph_ops callbacks

perhaps this is a good topic to discuss in one of the Thursday's BPF mtg?

thanks,
jirka

