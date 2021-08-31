Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18A103FD00C
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 01:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238102AbhHaXw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 19:52:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234343AbhHaXw0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 19:52:26 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 443DAC061575;
        Tue, 31 Aug 2021 16:51:30 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id k65so1623210yba.13;
        Tue, 31 Aug 2021 16:51:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gy3c/vPptdzHw6rjCL9JqoDyC+QFaVvuVXif+55WqAQ=;
        b=QzfIn47lfDFhCiveh1QvniOmDQpha/mSEuJpkIyg2CXu+02Zs0B5sFdNjnuRdCl2kb
         Pa52CNfqTytmHdrHMCLblmjwrFv+ILelrfKe5yJRii5jUc9z1ea7wvBCE5JkDQvCBr0A
         YtBUcaLpodPtUtHE/Mm2730370YB6LX2EpTDVpxlmxBpX5k/5AvpTEleIS//Qh2n7MMF
         mpl7JEyjXkoGKqS2dEtxwA4njMAey2745urD83gtRDULeqk2/p07/qlFQc0JIbyYaePf
         A+KTTwvtLoVpNHY7qTQ+25wz7O6JLsPnWONj0z1lW6JVPpbUO7Yw8QG++W28kdyCM2Gq
         +v+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gy3c/vPptdzHw6rjCL9JqoDyC+QFaVvuVXif+55WqAQ=;
        b=nWRXC9XMi9KTYPxvg83lDKqPx9H6Si57uFjyHxlOHf5kUz87YPE9uVTAIcAeyteeUq
         rCFmyVDHmbc7jYHbmmPzAgzgdC2j4NYfWAw35NGurJOJayEJDe3j3muDnrIisrkF3yP9
         U/7/uiJT6NLVjIYSKUj3GMADqiLztu8Dve4VIVpTQTMx6mKCtKP7Npcinkbyrx9UTzB3
         66ZIgtf1ulKx5Ji71tmPo/gDiGXoylnQP9mhIRTTIVXDV7gWZKMfdyDJ5SvLiA+ITQeh
         Dq5+MCQZlFh5E8OCtVmsxddY2nfgnhRF0Ud+G972+cHhZxPq7Du6gxJIeFTHrdptWUJI
         15bQ==
X-Gm-Message-State: AOAM532Wp5NUiwf5CFgsRcjy0vZVfO0ld1VwtrFxNe24nw5WxfN2MMoK
        fhhslljazRWgxrpmvgizSel/51vpVU+JcJWZdBQ=
X-Google-Smtp-Source: ABdhPJymUSjri2fcF2g6+pTS44mOzkMl78Ft77ILNASBhXd4qJPnwcQx+V9y3HSzRuJfP5FUUX/MR+n0yi2RqEQPFNI=
X-Received: by 2002:a25:1e03:: with SMTP id e3mr32354638ybe.459.1630453889430;
 Tue, 31 Aug 2021 16:51:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210826193922.66204-1-jolsa@kernel.org> <20210826193922.66204-19-jolsa@kernel.org>
In-Reply-To: <20210826193922.66204-19-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 31 Aug 2021 16:51:18 -0700
Message-ID: <CAEf4BzbFxSVzu1xrUyzrgn1jKyR40RJ3UEEsUCkii3u5nN_8wg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 18/27] bpf, x64: Store properly return value
 for trampoline with multi func programs
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Viktor Malik <vmalik@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 26, 2021 at 12:41 PM Jiri Olsa <jolsa@redhat.com> wrote:
>
> When we have multi func program attached, the trampoline
> switched to the function model of the multi func program.
>
> This breaks already attached standard programs, for example
> when we attach following program:
>
>   SEC("fexit/bpf_fentry_test2")
>   int BPF_PROG(test1, int a, __u64 b, int ret)
>
> the trampoline pushes on stack args 'a' and 'b' and return
> value 'ret'.
>
> When following multi func program is attached to bpf_fentry_test2:
>
>   SEC("fexit.multi/bpf_fentry_test*")
>   int BPF_PROG(test2, __u64 a, __u64 b, __u64 c, __u64 d,
>                        __u64 e, __u64 f, int ret)
>
> the trampoline takes this program model and pushes all 6 args
> and return value on stack.
>
> But we still have the original 'test1' program attached, that
> expects 'ret' value where there's 'c' argument now:
>
>   test1(a, b, c)
>
> To fix that we simply overwrite 'c' argument with 'ret' value,
> so test1 is called as expected and test2 gets called as:
>
>   test2(a, b, ret, d, e, f, ret)
>
> which is ok, because 'c' is not defined for bpf_fentry_test2
> anyway.
>

What if we change the order on the stack to be the return value first,
followed by input arguments. That would get us a bit closer to
unifying multi-trampoline and the normal one, right? BPF verifier
should be able to rewrite access to the last argument (i.e., return
value) for fexit programs to actually be at offset 0, and shift all
other arguments by 8 bytes. For fentry, if that helps to keep things
more aligned, we'd just skip the first 8 bytes on the stack and store
all the input arguments in the same offsets. So BPF verifier rewriting
logic stays consistent (except offset 0 will be disallowed).

Basically, I'm thinking how we can make normal and multi trampolines
more interoperable to remove those limitations that two
multi-trampolines can't be attached to the same function, which seems
like a pretty annoying limitation which will be easy to hit in
practice. Alexei previously proposed (as an optimization) to group all
to-be-attached functions into groups by number of arguments, so that
we can have up to 6 different trampolines tailored to actual functions
being attached. So that we don't save unnecessary extra input
arguments saving, which will be even more important once we allow more
than 6 arguments in the future.

With such logic, we should be able to split all the functions into
multiple underlying trampolines, so it seems like it should be
possible to also allow multiple multi-fentry programs to be attached
to the same function by having a separate bpf_trampoline just for
those functions. It will be just an extension of the above "just 6
trampolines" strategy to "as much as we need trampolines".

It's just a vague idea, sorry, I don't understand all the code yet.
But the limitation outlined in one of the previous patches seems very
limiting and unpleasant. I can totally see that some 24/7 running BPF
tracing app uses multi-fentry for tracing a small subset of kernel
functions non-stop, and then someone is trying to use bpftrace or
retsnoop to trace overlapping set of functions. And it immediately
fails. Very frustrating.

> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  arch/x86/net/bpf_jit_comp.c | 40 ++++++++++++++++++++++++++++++-------
>  include/linux/bpf.h         |  1 +
>  kernel/bpf/trampoline.c     |  1 +
>  3 files changed, 35 insertions(+), 7 deletions(-)
>

[...]
