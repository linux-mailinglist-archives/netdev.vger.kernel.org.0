Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79FA934C0ED
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 03:17:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230500AbhC2BRB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 21:17:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbhC2BQ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Mar 2021 21:16:59 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2789C061574;
        Sun, 28 Mar 2021 18:16:58 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id 15so14135493ljj.0;
        Sun, 28 Mar 2021 18:16:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sj989eWn9+bE629HLza6pIqfa8wPsP3aNHUHkSllV50=;
        b=kdZFPSis5HfNJP2VdT75xHeEN7mRWkznyftLT0nfBaabKzETxvlyfOzxIrNaaibnmy
         rmOd+9R8bmJvU9JHyXZ5qHi72xmDsmbIvtLalgi7fympFuJE21AgUvZkDI9dVcAi5y4h
         4se250l1/wE89VxOPcGaQ2WaZX7f2+A/rUsZSN8znJewg0JX6NA7BbdP4gXJTYYy6FTq
         ptA6fk5yl64wT0poju34LhPOsWp87mncmRd7SVHq7s23CbQYrYY8ynLOx7OxDC5yFlIh
         ke6hzk/hnWB6OoC+/GSuDqffYSyRwXYeJiytcbVKwgY/OJED1hAj4iHNqDAnDoEH9gRX
         t74Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sj989eWn9+bE629HLza6pIqfa8wPsP3aNHUHkSllV50=;
        b=StbyhU5ISn1R+tPToeYuUf8ev6yCWKeyxa9zbiWH/Lij/59rg283pUOYW6TpvUF0pO
         f8iA32fNHUCpqYlUvc3tAk8ODfYUMbYDkWAs90YS8ZaxgaSOcZfD5TRV/vB30r4R8UQE
         7ASCWbOu5eyMOScLYU1XtII2mFG5bAVWJ1ntJmnXghRayEBYo5akbQM0YV2HieQ5kAIC
         EWu5JYG/lhPPmlZjCecz9p16zYDuexu8AgqjVzFoLfh7cWq2i7DIkoxeDE+XCbr91gqu
         aheJFIh7OiRZWO6Zf35HYjrvpH7LOQ6dcqELUW5gF5tP+CSOnJEVpdr1JB5POxgNL1iN
         +SQg==
X-Gm-Message-State: AOAM531yYvyGJ0KG0ZaSIYwP3/Q05OFAVqfFurtaPzH4aX4/nypsmnq6
        yhanmybCbgFEqjHPaAMx9EDwyrxVGPWstNlL7BY=
X-Google-Smtp-Source: ABdhPJzpZpwcHPLgd0pSG5YznRSIVrZuemfocPxF+ZQTXfZlN5ON6VzrZnjTO/ZmgNxSIegM2NvIbuHnIx94mqKgzqE=
X-Received: by 2002:a2e:9198:: with SMTP id f24mr15848938ljg.32.1616980616964;
 Sun, 28 Mar 2021 18:16:56 -0700 (PDT)
MIME-Version: 1.0
References: <20210319205909.1748642-1-andrii@kernel.org> <20210319205909.1748642-4-andrii@kernel.org>
 <20210320022156.eqtmldxpzxkh45a7@ast-mbp> <CAEf4Bzarx33ENLBRyqxDz7k9t0YmTRNs5wf_xCqL2jNXvs+0Sg@mail.gmail.com>
 <20210322010734.tw2rigbr3dyk3iot@ast-mbp> <CAEf4BzbdgPnw81+diwcvAokv+S6osqvAAzSQYt_BoYbga9t-qQ@mail.gmail.com>
 <20210322175443.zflwaf7dstpg4y2b@ast-mbp> <CAEf4BzYHP00_iav1Y_vhMXBmAO3AnqqBz+uK-Yu=NGYUMEUyxw@mail.gmail.com>
In-Reply-To: <CAEf4BzYHP00_iav1Y_vhMXBmAO3AnqqBz+uK-Yu=NGYUMEUyxw@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sun, 28 Mar 2021 18:16:45 -0700
Message-ID: <CAADnVQKDOWz7fW0kxGEeLtMJLf7J5v9Un=uDXKmwhkweoVQ3Lw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/3] selftests/bpf: allow compiling BPF objects
 without BTF
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 26, 2021 at 9:44 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
> > Because they double the maintenance cost now and double the support forever.
> > We never needed to worry about skeleton without BTF and now it would be
> > a thing ? So all tests realistically need to be doubled: with and without BTF.
>
> 2x? Realistically?.. No, I wouldn't say so. :) Extra test or a few
> might be warranted, but doubling the amount of testing is a huge
> exaggeration.

It's not only doubling the test coverage, but it would double the development
effort to keep everything w/BTF and w/o BTF functional.
So 2x is far from exaggeration.

> > Even more so for static linking. If one .o has BTF and another doesn't
> > what linker suppose to do? Keep it, but the linked BTF will sort of cover
> > both .o-s, but line info in some funcs will be missing.
> > All these weird combinations would need to be tested.
>
> BPF static linker already supports that mode, btw.

Are you considering one-liner commit 78b226d48106 ("libbpf: Skip BTF
fixup if object file has no BTF")
as support for static linking w/o BTF?
Jiri's other email pointed out another place in libbpf that breaks w/o BTF.
The only thing the commit 78b226d48106 achieved is it closed
the one case of static linker crashing w/o BTF.
Does linker do anything sensible when a mix of .o with and without BTF
is given? No.
It happens not to crash w/o BTF. That's about it.

> And yes, it
> shouldn't crash the kernel. And you don't need a skeleton or static
> linker to do that to the kernel, so I don't know how that is a new
> mode of operation.
>
> > The sensible thing to do would be to reject skel generation without BTF
> > and reject linking without BTF. The user most likely forgot -g during
> > compilation of bpf prog. The bpftool should give the helpful message
> > in such case. Whether it's generating skel or linking. Silently proceeding
> > and generating half-featured skeleton is not what user wanted.
>
> Sure, a warning message makes sense. Outright disabling this - not so
> much. I still can't get why I can't get BPF skeleton and static
> linking without BTF, if I really want to. Both are useful without BTF.

What are the cases that would benefit?
So far skeleton was used by tracing progs only. Those that need CO-RE.
Which means they must have BTF.
Networking progs didn't need CO-RE and no one bothered adopting
skeleton because of that.
Are you implying that a BTF-less skeleton will be useful for
networking progs? What for?
So far I see only downsides from increasing the amount of work needed
to support skel and static linking w/o BTF. The extra 100% or just 1%
would be equally taxing, since it's extra work for the foreseeable future and
compounded 1% will add up.

Looking at it from another angle... the skeleton generation existed
for more than
a year now and it implicitly required BTF. That requirement was not
written down.
Now you're proposing to support skeleton gen w/o BTF when not a single user
requested it and not providing any advantages of such support while
ignoring the long term maintenance of such effort.

Another angle... I did git grep in selftests that use skeleton.
Only a handful of tests use it as *skel*__open_and_load() w/o global data
(which would still work w/o BTF)
and only because we forcefully converted them when skel was introduced.
bcc/libbpf-tools/* need skel with BTF.
I couldn't find a _single_ case where people use
skeleton and don't need BTF driven parts of it.

> So I don't know, it's the third different argument I'm addressing
without any conclusion on the previous two.

So far you haven't addressed the first question:
Who is asking for a BTF-less skeleton? What for? What features are requested?
I've seen none of such requests.

BTF is not a debug info of the BPF program.
If it was then I would agree that compiling with and without -g shouldn't
make a difference.
But BTF is not a debug-info. It's type and much more description of the program
that is mandatory for the verification of the program.
btf_id-based attach, CO-RE, trampoline, calling kernel funcs, etc all
require BTF.
Not because it's convenient to use BTF, but because assembly doesn't
have enough information.
There is no C, C++, Rust equivalent of BTF. There is none in the user
space world.
Traditional languages translate a language into assembly code and cpus
execute it.
Static analyzers use high level languages to understand the intent.
BPF workflow translates a language into assembly and BTF, so that the verifier
can see the intent. It could happen that BPF will gain something else beyond BTF
and it will become a mandatory part of the workflow. Just like BTF is today.
At that point all new features will be supported with that new
"annotation" only,
not because of "subjective personal preferences", but because that is
a fundamental
program description.
