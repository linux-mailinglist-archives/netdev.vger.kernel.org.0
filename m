Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEA9A365DED
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 18:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233266AbhDTQxN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 12:53:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56439 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233239AbhDTQxM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 12:53:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618937560;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SWluZQwf/XWaF+JoqgpVc9LhHEKvzg3vw4BFLJNp6JQ=;
        b=ReEfjKi8Ny++wTz1aHNlFyzIu3+tYr3odi5/ClytfimFndz8ZFTh8PMeXcE6jwZn3B7svF
        fTxb9420KdJwWIrs+b+at7GTxAUIyywKCXgLrXhjYeg+ZOsQfZILRA0Wjk7B7E3RCwOJNu
        /FGV2zRUk/EMYmvccbpetYLnykavLIg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-523-RtM3fOicMjSko0MV24VSig-1; Tue, 20 Apr 2021 12:52:35 -0400
X-MC-Unique: RtM3fOicMjSko0MV24VSig-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EC34C107B467;
        Tue, 20 Apr 2021 16:52:32 +0000 (UTC)
Received: from krava (unknown [10.40.196.37])
        by smtp.corp.redhat.com (Postfix) with SMTP id 1671C5D9C0;
        Tue, 20 Apr 2021 16:52:20 +0000 (UTC)
Date:   Tue, 20 Apr 2021 18:52:20 +0200
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
Message-ID: <YH8GxNi5VuYjwNmK@krava>
References: <CAEf4Bzazst1rBi4=LuP6_FnPXCRYBNFEtDnK3UVBj6Eo6xFNtQ@mail.gmail.com>
 <YHbd2CmeoaiLJj7X@krava>
 <CAEf4BzYyVj-Tjy9ZZdAU5nOtJ8_auvVobTT6pMqg8zPb9jj-Ow@mail.gmail.com>
 <20210415111002.324b6bfa@gandalf.local.home>
 <CAEf4BzY=yBZH2Aad1hNcqCt51u0+SmNdkD6NfJRVMzF7DsvG+A@mail.gmail.com>
 <20210415170007.31420132@gandalf.local.home>
 <20210417000304.fc987dc00d706e7551b29c04@kernel.org>
 <20210416124834.05862233@gandalf.local.home>
 <YH7OXrjBIqvEZbsc@krava>
 <CAADnVQK55WzR6_JfxkMzEfUnLJnX75bRHjCkaptcVF=nQ_gWfw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQK55WzR6_JfxkMzEfUnLJnX75bRHjCkaptcVF=nQ_gWfw@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 20, 2021 at 08:33:43AM -0700, Alexei Starovoitov wrote:
> On Tue, Apr 20, 2021 at 5:51 AM Jiri Olsa <jolsa@redhat.com> wrote:
> >
> > On Fri, Apr 16, 2021 at 12:48:34PM -0400, Steven Rostedt wrote:
> > > On Sat, 17 Apr 2021 00:03:04 +0900
> > > Masami Hiramatsu <mhiramat@kernel.org> wrote:
> > >
> > > > > Anyway, IIRC, Masami wasn't sure that the full regs was ever needed for the
> > > > > return (who cares about the registers on return, except for the return
> > > > > value?)
> > > >
> > > > I think kretprobe and ftrace are for a bit different usage. kretprobe can be
> > > > used for something like debugger. In that case, accessing full regs stack
> > > > will be more preferrable. (BTW, what the not "full regs" means? Does that
> > > > save partial registers?)
> > >
> > > When the REGS flag is not set in the ftrace_ops (where kprobes uses the
> > > REGS flags), the regs parameter is not a full set of regs, but holds just
> > > enough to get access to the parameters. This just happened to be what was
> > > saved in the mcount/fentry trampoline, anyway, because tracing the start of
> > > the program, you had to save the arguments before calling the trace code,
> > > otherwise you would corrupt the parameters of the function being traced.
> > >
> > > I just tweaked it so that by default, the ftrace callbacks now have access
> > > to the saved regs (call ftrace_regs, to not let a callback get confused and
> > > think it has full regs when it does not).
> > >
> > > Now for the exit of a function, what does having the full pt_regs give you?
> > > Besides the information to get the return value, the rest of the regs are
> > > pretty much meaningless. Is there any example that someone wants access to
> > > the regs at the end of a function besides getting the return value?
> >
> > for ebpf program attached to the function exit we need the functions's
> > arguments.. so original registers from time when the function was entered,
> > we don't need registers state at the time function is returning
> >
> > as we discussed in another email, we could save input registers in
> > fgraph_ops entry handler and load them in exit handler before calling
> > ebpf program
> 
> I don't see how you can do it without BTF.
> The mass-attach feature should prepare generic 6 or so arguments
> from all functions it attached to.
> On x86-64 it's trivial because 6 regs are the same.
> On arm64 is now more challenging since return value regs overlaps with
> first argument, so bpf trampoline (when it's ready for arm64) will look
> a bit different than bpf trampoline on x86-64 to preserve arg0, arg1,
> ..arg6, ret
> 64-bit values that bpf prog expects to see.
> On x86-32 it's even more trickier, since the same 6 args need to be copied
> from a combination of regs and stack.
> This is not some hypothetical case. We already use BTF in x86-32 JIT
> and btf_func_model was introduced specifically to handle such cases.
> So I really don't see how ftrace can do that just yet. It has to understand BTF
> of all of the funcs it attaches to otherwise it's just saving all regs.
> That approach was a pain to deal with.

ok, my idea was to get regs from the ftrace and have arch specific code
to prepare 6 (or less) args for ebpf program.. that part would be
already in bpf code

so you'd like to see this functionality directly in ftrace, so we don't
save unneeded regs, is that right?

jirka

> Just look at bpf code samples with ugly per architecture macros to access regs.
> BPF trampoline solved it and I don't think going back to per-arch macros
> is an option at this point.
> 

