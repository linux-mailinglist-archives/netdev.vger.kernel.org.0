Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFFD53FFD76
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 11:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235043AbhICJvU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 05:51:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:55846 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235045AbhICJvO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 05:51:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630662614;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=duzbAIH97p4oVdRMBhioaySsSuzODZFiHTrWeayFJ/A=;
        b=f4jhOG0UUgyHpuavuqdoEgeyMkyplup3sfLt1n3ryi9x9GJ39gM8AK3aKAuNdTO3a+3lV/
        1B8iFa6pUQic2DBRfux+4rTkUuRDL2U8nJgPRxdhLyn5QZx92gu5cA2sgof9fmcxsFD9R/
        CmdWQWbm+QZzs/KCAcLa94eJnS/mJbY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-11-LqiDV1rXPt6YvmOLQx1WjA-1; Fri, 03 Sep 2021 05:50:13 -0400
X-MC-Unique: LqiDV1rXPt6YvmOLQx1WjA-1
Received: by mail-wm1-f72.google.com with SMTP id s197-20020a1ca9ce000000b002e72ba822dcso2433635wme.6
        for <netdev@vger.kernel.org>; Fri, 03 Sep 2021 02:50:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=duzbAIH97p4oVdRMBhioaySsSuzODZFiHTrWeayFJ/A=;
        b=oIMUFpFJe7oR7K03+inJ5J6IXHGfgKrGCqSD2YsfNK5HF0wd41HzZGlD9l45gCfSpw
         46g3UBAjQfS/I2jlDak164TKU8iTfhbTzyhI3sl3QHJRTYDKncZCyl8CLlh3mb62xE97
         1lHN/Tcs3o9Kt1SWCq3fdzUq9do036HVN86clz0BRceskTy9vBC+X/G1ET+iRGimUPji
         79zL4xQ6yQDc5RR6rS1nZW+qe5T0hPd6nYH1lKtPWJ5U5Qgi01o9dKNivAaqBifopHjk
         82LoEyrdx7zd0Q6gPW9FmLCX4hd7/2aTl6TWlfE2KOELe59tIcunl3UpM6lK+z/JwVZE
         OjGg==
X-Gm-Message-State: AOAM532hDOjHetTJKK8ye62RL7GX2MvI4IVkTp1r+GciRvBNelcpeiAs
        EMzcvXkpXsqKWMO5uH3q2OFBUfct71MrB11O1ScgJQYjlsSn0vzMQNLvw6wSl+B71aO1Fq25RI3
        VkRUn2rHYKNATuD9J
X-Received: by 2002:adf:f747:: with SMTP id z7mr3081543wrp.194.1630662612574;
        Fri, 03 Sep 2021 02:50:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx9ylE45+6PAX7FQM5AJr/mCiW2fz9Pz8cRNkVdIEDEQvG2S68FKjGCgGqgomoOb5JaUeMWUw==
X-Received: by 2002:adf:f747:: with SMTP id z7mr3081515wrp.194.1630662612340;
        Fri, 03 Sep 2021 02:50:12 -0700 (PDT)
Received: from krava ([94.113.247.3])
        by smtp.gmail.com with ESMTPSA id d5sm4099233wra.38.2021.09.03.02.50.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Sep 2021 02:50:11 -0700 (PDT)
Date:   Fri, 3 Sep 2021 11:50:09 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Viktor Malik <vmalik@redhat.com>
Subject: Re: [PATCH bpf-next v4 18/27] bpf, x64: Store properly return value
 for trampoline with multi func programs
Message-ID: <YTHv0ao5KplMGlNU@krava>
References: <20210826193922.66204-1-jolsa@kernel.org>
 <20210826193922.66204-19-jolsa@kernel.org>
 <CAEf4BzbFxSVzu1xrUyzrgn1jKyR40RJ3UEEsUCkii3u5nN_8wg@mail.gmail.com>
 <YS+ZAbb+h9uAX6EP@krava>
 <CAEf4BzY1XhuZ5huinfTmUZGhrT=wgACOgKbbdEPmnek=nN6YgA@mail.gmail.com>
 <YTDKJ2E1fN0hPDZj@krava>
 <20210902215538.a75q7bjcgkpjync4@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210902215538.a75q7bjcgkpjync4@ast-mbp.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 02, 2021 at 02:55:38PM -0700, Alexei Starovoitov wrote:
> On Thu, Sep 02, 2021 at 02:57:11PM +0200, Jiri Olsa wrote:
> > > 
> > > Let's say we have 5 kernel functions: a, b, c, d, e. Say a, b, c all
> > > have 1 input args, and d and e have 2.
> > > 
> > > Now let's say we attach just normal fentry program A to function a.
> > > Also we attach normal fexit program E to func e.
> > > 
> > > We'll have A  attached to a with trampoline T1. We'll also have E
> > > attached to e with trampoline T2. Right?
> > > 
> > > And now we try to attach generic fentry (fentry.multi in your
> > > terminology) prog X to all 5 of them. If A and E weren't attached,
> > > we'd need two generic trampolines, one for a, b, c (because 1 input
> > > argument) and another for d,e (because 2 input arguments). But because
> > > we already have A and B attached, we'll end up needing 4:
> > > 
> > > T1 (1 arg)  for func a calling progs A and X
> > > T2 (2 args) for func e calling progs E and X
> > > T3 (1 arg)  for func b and c calling X
> > > T4 (2 args) for func d calling X
> > 
> > so current code would group T3/T4 together, but if we keep
> > them separated, then we won't need to use new model and
> > cut off some of the code, ok
> 
> We've brainstormed this idea further with Andrii.
> (thankfully we could do it in-person now ;) which saved a ton of time)
> 
> It seems the following should work:
> 5 kernel functions: a(int), b(long), c(void*), d(int, int), e(long, long).
> fentry prog A is attached to 'a'.
> fexit prog E is attached to 'e'.
> multi-prog X wants to attach to all of them.
> It can be achieved with 4 trampolines.
> 
> The trampolines called from funcs 'a' and 'e' can be patched to
> call A+X and E+X programs correspondingly.
> The multi program X needs to be able to access return values
> and arguments of all functions it was attached to.
> We can achieve that by always generating a trampoline (both multi and normal)
> with extra constant stored in the stack. This constant is the number of
> arguments served by this trampoline.
> The trampoline 'a' will store nr_args=1.
> The tramopline 'e' will store nr_args=2.
> We need two multi trampolines.
> The multi tramopline X1 that will serve 'b' and 'c' and store nr_args=1
> and multi-tramopline X2 that will serve 'd' and store nr_args=2
> into hidden stack location (like ctx[-2]).
> 
> The multi prog X can look like:
> int BPF_PROG(x, __u64 arg1, __u64 arg2, __u64 ret)
> in such case it will read correct args and ret when called from 'd' and 'e'
> and only correct arg1 when called from 'a', 'b', 'c'.
> 
> To always correctly access arguments and the return value
> the program can use two new helpers: bpf_arg(ctx, N) and bpf_ret_value(ctx).
> Both will be fully inlined helpers similar to bpf_get_func_ip().
> u64 bpf_arg(ctx, int n)
> {
>   u64 nr_args = ctx[-2]; /* that's the place where _all_ trampoline will store nr_args */
>   if (n > nr_args)
>     return 0;
>   return ctx[n];
> }
> u64 bpf_ret_value(ctx)
> {
>   u64 nr_args = ctx[-2];
>   return ctx[nr_args];
> }

ok, this is much better then rewiring args access in verifier

> 
> These helpers will be the only recommended way to access args and ret value
> in multi progs.
> The nice advantage is that normal fentry/fexit progs can use them too.
> 
> We can rearrange ctx[-1] /* func_ip */ and ctx[-2] /* nr_args */
> if it makes things easier.

so nr_args will be there all the time, while func_ip is optional
at the moment (based on get_func_ip helper presence in program),
so we can either switch that:

   func_ip in ctx[-2]
   nr_args in ctx[-1]

or make func_ip not optional to avoid confusion

I think pushing func_ip to ctx-2 is ok

> 
> If multi prog knows that it is attaching to 100 kernel functions
> and all of them have 2 arguments it can still do
> int BPF_PROG(x, __u64 arg1, __u64 arg2, __u64 ret)
> { // access arg1, arg2, ret directly
> and it will work correctly.

ok, it's user's decision, because at load time we don't know the
functions it will be attached to, so verifier can't do anything

> 
> We can make it really strict in the verifier and disallow such
> direct access to args from the multi prog and only allow
> access via bpf_arg/bpf_ret_value helpers, but I think it's overkill.
> Reading garbage values from stack isn't great, but it's not a safety issue.

we could also check it in attach time and forbid to attach if there
are attach functions with different nr_args and program does not use
arg helpers


> It means that the verifier will allow something like 16 u64-s args
> in multi program. It cannot allow large number, since ctx[1024]
> might become a safety issue, while ctx[4] could be a garbage
> or a valid value depending on the call site.
> 
> Thoughts?
> 

looks good, thanks for solving this ;-)

jirka

