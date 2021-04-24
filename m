Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3317369DC0
	for <lists+netdev@lfdr.de>; Sat, 24 Apr 2021 02:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237243AbhDXAXW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 20:23:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233027AbhDXAXT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 20:23:19 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8765C061574;
        Fri, 23 Apr 2021 17:22:39 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id a25so44196337ljm.11;
        Fri, 23 Apr 2021 17:22:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ozXjRX7COuH6/1+kDMYDVF4Elit6ykL8LgOzFAA+UTY=;
        b=O0uU11ynWxq0gKmlwhdHVXQZqQz6Xu/wJHmeVXc/3OzFs73wfd/Y+sUZhlftPirZmz
         iC6Q2kB31sSMxndfMuXlfsPpWT4J5aTkfApAup5wenNMCOkgXxLsr6hqdYjq8qDnPXbI
         R3Cg91jN2RIlmPvQJVzVC5W4+AklxDELCkTH87Ch7vGJL8NyonBTfcjpxiSxWbzgGX9S
         acUnLrybAzlGT7VbolOdjJnAEEPlhWy8cs4+VaM1m/IY1yNu2GyW78J967DaUoIhJykQ
         OlLlvix2pgS1A0ojzWIiYY2e8Y4XzcagumqXKTtfeE66Zyr4x0OyFZefqriOSqZ8r28u
         orBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ozXjRX7COuH6/1+kDMYDVF4Elit6ykL8LgOzFAA+UTY=;
        b=quzymrDb1f9mCFxrWRHXckUJwx9KAPhFfjVl5BHpVDJfuW/5DKSPbPLN4yHD4v+pL5
         bSSyAK2hyJQjIlFqO7M9vy2gDyVK/KYiH0DbglccglXMa13F1ujBvPWa1VG19J1siHOS
         yZFxcaybQjJ8zwpDpstmp7QKHxA52gsMdXliKBwNpyFIaMmW+j9BvvttxlEQgpQxIvwR
         rEgqaJuRCvmnY3mf6HtVu15Ii4oHcjto2wYDvKkRGB8Q5fRJG7heIlERRSMid2Xfe3ht
         RdTbzIBRriG2DMew9HUQvz+ChDl3ElSoeM5X5HGMkkEnx+jMv6G6p5SJi8FxiGjX69EG
         8Icg==
X-Gm-Message-State: AOAM5335KD18Axm0RklNu1+UDaOye8Op5YJ9jS/srO3zzse3G0lvxfc3
        UrxM3MZFgy/Q6aGfrdBekHpOtRqEIyq4GEgodVndP4zs
X-Google-Smtp-Source: ABdhPJx+IssCUgNFvXJASJBHQO4AVaO+lWahbB/j7241iueBB/kmJvM1vJ29JZt6vZ4m8QQa6EGDrHIogj1Hclier6U=
X-Received: by 2002:a2e:8356:: with SMTP id l22mr4330227ljh.204.1619223758453;
 Fri, 23 Apr 2021 17:22:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210423185357.1992756-1-andrii@kernel.org> <20210423185357.1992756-3-andrii@kernel.org>
 <2b398ad6-31be-8997-4115-851d79f2d0d2@fb.com> <CAEf4BzYDiuh+OLcRKfcZDSL6esu6dK8js8pudHKvtMvAxS1=WQ@mail.gmail.com>
 <065e8768-b066-185f-48f9-7ca8f15a2547@fb.com> <CAADnVQ+h9eS0P9Jb0QZQ374WxNSF=jhFAiBV7czqhnJxV51m6A@mail.gmail.com>
 <CAEf4BzadCR+QFy4UY8NSVFjGJF4CszhjjZ48XeeqrfX3aYTnkA@mail.gmail.com>
 <CAADnVQKo+efxMvgrqYqVvUEgiz_GXgBVOt4ddPTw_mLuvr2HUw@mail.gmail.com> <CAEf4BzZifOFHr4gozUuSFTh7rTWu2cE_-L4H1shLV5OKyQ92uw@mail.gmail.com>
In-Reply-To: <CAEf4BzZifOFHr4gozUuSFTh7rTWu2cE_-L4H1shLV5OKyQ92uw@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 23 Apr 2021 17:22:27 -0700
Message-ID: <CAADnVQ+h78QijAjbkNqAWn+TAFxrd6vE=mXqWRcy815hkTFvOw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 2/6] libbpf: rename static variables during linking
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andrii@kernel.org>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 23, 2021 at 5:13 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Fri, Apr 23, 2021 at 4:48 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Fri, Apr 23, 2021 at 4:35 PM Andrii Nakryiko
> > <andrii.nakryiko@gmail.com> wrote:
> > >
> > > On Fri, Apr 23, 2021 at 4:06 PM Alexei Starovoitov
> > > <alexei.starovoitov@gmail.com> wrote:
> > > >
> > > > On Fri, Apr 23, 2021 at 2:56 PM Yonghong Song <yhs@fb.com> wrote:
> > > > > >>>
> > > > > >>> -static volatile const __u32 print_len;
> > > > > >>> -static volatile const __u32 ret1;
> > > > > >>> +volatile const __u32 print_len = 0;
> > > > > >>> +volatile const __u32 ret1 = 0;
> > > > > >>
> > > > > >> I am little bit puzzled why bpf_iter_test_kern4.c is impacted. I think
> > > > > >> this is not in a static link test, right? The same for a few tests below.
> > > > > >
> > > > > > All the selftests are passed through a static linker, so it will
> > > > > > append obj_name to each static variable. So I just minimized use of
> > > > > > static variables to avoid too much code churn. If this variable was
> > > > > > static, it would have to be accessed as
> > > > > > skel->rodata->bpf_iter_test_kern4__print_len, for example.
> > > > >
> > > > > Okay this should be fine. selftests/bpf specific. I just feel that
> > > > > some people may get confused if they write/see a single program in
> > > > > selftest and they have to use obj_varname format and thinking this
> > > > > is a new standard, but actually it is due to static linking buried
> > > > > in Makefile. Maybe add a note in selftests/README.rst so we
> > > > > can point to people if there is confusion.
> > > >
> > > > I'm not sure I understand.
> > > > Are you saying that
> > > > bpftool gen object out_file.o in_file.o
> > > > is no longer equivalent to llvm-strip ?
> > > > Since during that step static vars will get their names mangled?
> > >
> > > Yes. Static vars and static maps. We don't allow (yet?) static
> > > entry-point BPF programs, so those don't change.
> > >
> > > > So a good chunk of code that uses skeleton right now should either
> > > > 1. don't do the linking step
> > > > or
> > > > 2. adjust their code to use global vars
> > > > or
> > > > 3. adjust the usage of skel.h in their corresponding user code
> > > >   to accommodate mangled static names?
> > > > Did it get it right?
> > >
> > > Yes, you are right. But so far most cases outside of selftest that
> > > I've seen don't use static variables (partially because they need
> > > pesky volatile to be visible from user-space at all), global vars are
> > > much nicer in that regard.
> >
> > Right.
> > but wait...
> > why linker is mangling them at all and why they appear in the skeleton?
> > static vars without volatile should not be in a skeleton, since changing
> > them from user space might have no meaning on the bpf program.
> > The behavior of the bpf prog is unpredictable.
>
> It's up to the compiler. If compiler decides that it shouldn't inline
> all the uses (or e.g. if static variable is an array accessed with
> index known only at runtime, or many other cases where compiler can't
> just deduce constant value), then compiler will emit ELF symbols, will
> allocate storage, and code will use that storage. static volatile just
> forces the compiler to not assume anything at all.
>
> If the compiler does inline all the uses of static, then we won't have
> storage allocated for it and it won't be even present in BTF. So for
> libbpf, linker and skeleton statics are no different than globals.

Not quite.
The compiler can inline static values in some cases and still
keep the var in global data in others places in the same C file.
If it's a static struct the compiler is free to do any crazy optimization
on this data it can come up with.
So the presence of it in the elf symbols doesn't guarantee anything.

> Static maps are slightly different, because we use SEC() which marks
> them as used, so they should always be present.

yes. The used attribute makes the compiler keep the data,
but it can still inline it and lose the reference in the .text.

> Sub-skeleton will present those statics to the BPF library without
> name mangling, but for the final linked BPF object file we need to
> handle statics. Definitely for maps, because static means that library
> or library user shouldn't be able to just extern that definition and
> update/lookup/corrupt its state. But I think for static variables it
> should be the same. Both are visible to user-space, but invisible
> between linked BPF compilation units.

I agree with motivation and also agree that static map def is a clean
way to hide such a map inside the library.
I'm not sure yet that static + used is enough.
More study needed.
For maps it's only the reference inside .text that is relevant.
If the compiler messes with it then we might have issues.
Like two static maps might look the same to the compiler.
They will have different field names, but their contents are zeros
in both cases. I'm not sure that the compiler will not decide to merge them
into one data location. In such case .text insns will be pointing
to the same data offset. The symbol names are probably going to be different.
So we might be ok with static+used only.
