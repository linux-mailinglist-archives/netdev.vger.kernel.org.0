Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 797B5365C47
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 17:34:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233040AbhDTPe3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 11:34:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232507AbhDTPe2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 11:34:28 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96351C06138A;
        Tue, 20 Apr 2021 08:33:56 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id y4so21968847lfl.10;
        Tue, 20 Apr 2021 08:33:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h1XjX61ulCn+oC3jvyFmJYPP3W1LUsOhQ1VuV/tYUlg=;
        b=LX5kv6aJvq/0MWZjdPQ8teehiYZ6oibqLtw+XwWbMQ3Iiq4cBXLa0Htp2M4MLnpvR9
         pk3d2aP2H/vxmASKbdOU4D8Xp2TikE9BInzmQvpY+MvQEGNxoTzSSo7RTBaTuTrGNyuI
         hsLyliNN8YtqFCx01A4Y068CI0dBeILaIJlu03zlIvjXXfg+0PRwgpz2mtl1EDwiifd3
         jP/dqDOUAwRZXgZklbHnJiKCA15/hlAubxzZHHfhVgCgIZlBWZ0eTyQIRdH3T5pPjlU6
         Mhr9xbYQaUfXfEC7zOQYRkUy1yxIVnParnR6C0UkaptJ4YKvCLDbKSyQSJNcwnwMtxZv
         XJMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h1XjX61ulCn+oC3jvyFmJYPP3W1LUsOhQ1VuV/tYUlg=;
        b=C0nP2zG/hjIaAnqWm4MAsow6t5xJYVY2xT35XhEgBTbFNBds5SQmCMbwfWbjiK9BW0
         Jks7BPBKnuPtFSqBmsQf6C2Lz0c4lfQF86jdlzh7H81EJ+PjI8bWesK3mPDV5AhlT+SS
         ph66BRRUail6zxQeh+cNj0oKqhznzfUjJngUiqtkHj6oZgF84mVbwbtTGU88lnrOgyir
         qiMIMg4QTVaeC36m7oXtuCJQPDdH9Mg6oYgshKIwrOETgT4/gKWLFah9cmRGY4jDXs51
         39AfTC8+kxUf2O6cs9ZBLtrMq9e+2ZmgCFPg37AfhzEa9BjqZK6/vCKeu7VPSyEvAlqb
         jSkQ==
X-Gm-Message-State: AOAM531CvFlkmqapy/dOAUB08BDjyhNTIqE0w6HnRU3m0V3RgZWXR9Gb
        C988fCX3X5SzFpxsElCLUCJVYwC8lg3kjGxVKeI=
X-Google-Smtp-Source: ABdhPJzAYsMAIzKdSoQJnNVCbxsSxFC0PyV+0h4zBuLBCVNe7B8S9fp0lUdpbvTND4u1T0CSGN/1slzl3qfXAkKCP3A=
X-Received: by 2002:a05:6512:3f93:: with SMTP id x19mr16400011lfa.182.1618932834700;
 Tue, 20 Apr 2021 08:33:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210413121516.1467989-1-jolsa@kernel.org> <CAEf4Bzazst1rBi4=LuP6_FnPXCRYBNFEtDnK3UVBj6Eo6xFNtQ@mail.gmail.com>
 <YHbd2CmeoaiLJj7X@krava> <CAEf4BzYyVj-Tjy9ZZdAU5nOtJ8_auvVobTT6pMqg8zPb9jj-Ow@mail.gmail.com>
 <20210415111002.324b6bfa@gandalf.local.home> <CAEf4BzY=yBZH2Aad1hNcqCt51u0+SmNdkD6NfJRVMzF7DsvG+A@mail.gmail.com>
 <20210415170007.31420132@gandalf.local.home> <20210417000304.fc987dc00d706e7551b29c04@kernel.org>
 <20210416124834.05862233@gandalf.local.home> <YH7OXrjBIqvEZbsc@krava>
In-Reply-To: <YH7OXrjBIqvEZbsc@krava>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 20 Apr 2021 08:33:43 -0700
Message-ID: <CAADnVQK55WzR6_JfxkMzEfUnLJnX75bRHjCkaptcVF=nQ_gWfw@mail.gmail.com>
Subject: Re: [PATCHv2 RFC bpf-next 0/7] bpf: Add support for ftrace probe
To:     Jiri Olsa <jolsa@redhat.com>
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
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Viktor Malik <vmalik@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 20, 2021 at 5:51 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Fri, Apr 16, 2021 at 12:48:34PM -0400, Steven Rostedt wrote:
> > On Sat, 17 Apr 2021 00:03:04 +0900
> > Masami Hiramatsu <mhiramat@kernel.org> wrote:
> >
> > > > Anyway, IIRC, Masami wasn't sure that the full regs was ever needed for the
> > > > return (who cares about the registers on return, except for the return
> > > > value?)
> > >
> > > I think kretprobe and ftrace are for a bit different usage. kretprobe can be
> > > used for something like debugger. In that case, accessing full regs stack
> > > will be more preferrable. (BTW, what the not "full regs" means? Does that
> > > save partial registers?)
> >
> > When the REGS flag is not set in the ftrace_ops (where kprobes uses the
> > REGS flags), the regs parameter is not a full set of regs, but holds just
> > enough to get access to the parameters. This just happened to be what was
> > saved in the mcount/fentry trampoline, anyway, because tracing the start of
> > the program, you had to save the arguments before calling the trace code,
> > otherwise you would corrupt the parameters of the function being traced.
> >
> > I just tweaked it so that by default, the ftrace callbacks now have access
> > to the saved regs (call ftrace_regs, to not let a callback get confused and
> > think it has full regs when it does not).
> >
> > Now for the exit of a function, what does having the full pt_regs give you?
> > Besides the information to get the return value, the rest of the regs are
> > pretty much meaningless. Is there any example that someone wants access to
> > the regs at the end of a function besides getting the return value?
>
> for ebpf program attached to the function exit we need the functions's
> arguments.. so original registers from time when the function was entered,
> we don't need registers state at the time function is returning
>
> as we discussed in another email, we could save input registers in
> fgraph_ops entry handler and load them in exit handler before calling
> ebpf program

I don't see how you can do it without BTF.
The mass-attach feature should prepare generic 6 or so arguments
from all functions it attached to.
On x86-64 it's trivial because 6 regs are the same.
On arm64 is now more challenging since return value regs overlaps with
first argument, so bpf trampoline (when it's ready for arm64) will look
a bit different than bpf trampoline on x86-64 to preserve arg0, arg1,
..arg6, ret
64-bit values that bpf prog expects to see.
On x86-32 it's even more trickier, since the same 6 args need to be copied
from a combination of regs and stack.
This is not some hypothetical case. We already use BTF in x86-32 JIT
and btf_func_model was introduced specifically to handle such cases.
So I really don't see how ftrace can do that just yet. It has to understand BTF
of all of the funcs it attaches to otherwise it's just saving all regs.
That approach was a pain to deal with.
Just look at bpf code samples with ugly per architecture macros to access regs.
BPF trampoline solved it and I don't think going back to per-arch macros
is an option at this point.
