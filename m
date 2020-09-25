Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FCFD278F0E
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 18:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729202AbgIYQuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 12:50:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727151AbgIYQuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 12:50:15 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA067C0613CE;
        Fri, 25 Sep 2020 09:50:14 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id v60so2432424ybi.10;
        Fri, 25 Sep 2020 09:50:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kifWAoy25H8M+AEVShRaafYeeNj+IOoIn2C2AtGDAdQ=;
        b=SPdAM3TR+87Geil+9wsEzZhAv+fstzXIY/7ChJ22zgN2FfmGC9+UXrglK+cx3V19gX
         dr+13A1dxFN9eyQ93K8Ru4NMAaUzRzMR8Cvn2BYDiDzBFLQ9pKJwckgnzhruNMuNsVm6
         s7ijdybKl/w5RmDIlqFiOCnyPgqk0NfrYOPRiWnIOazsobdBKveYou7sErlkmOPCHYeL
         /aJELFNPH8HA8XqtE990AK9f5VmzLX78QJEVbaxbpzYGjSTH0cMuiySqlDgoZwoJfpOl
         GXAgQGh+5F/z/dIbMgQd7GD5XmJjyyI0xEng/B9Bso84qa4o23+bAmq+oSTImuttjn1m
         2Yrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kifWAoy25H8M+AEVShRaafYeeNj+IOoIn2C2AtGDAdQ=;
        b=refwbGCSK83jqKQ8x8NFM8g/+9PY6MqAL2lxvIjv+OnriLf1GrJkpp4mjvWf3aFFjn
         kmpEGUVX8CUuc4zc9PA1L5i8srqJvX0PNxV8UIrVwOcZHh7Kke2Z4R/wvAJENOgjSBIt
         Yiu7XGv6X6VR+sAzkkZD1zSgwpHhrDr9f6OME+ebuqexgIDW1o1O+PP1s5CDnuidW2/R
         MbaMylsk+eaIxbFiRXZB2wb9Iy7MGwv/GqsBYK43yWlScXu6rHhzIJ7EAhY87pEYDXga
         NtPqD+ufWQ7v7zhFswuq6aIfvGyNVBzUTL4unuIvDRPVXBAIV1mx+9KrGqpXE+Cj9xuZ
         GraA==
X-Gm-Message-State: AOAM531Kp1tLm46QOg0gzf1nbryYTuaKO1xvioQU2o/JJC2y29ottZR/
        JgE22Xf4YZQ2xPoh5mGyjxCfelpc+SE9PhkOexHqUkbHOEpxpA==
X-Google-Smtp-Source: ABdhPJyent8tl+cc//DzIAQdMv9u7a5jnfhuslKEaFBqofX3DZPrqnvIOk/mhxJ6qN3ztZkmGCHU66j0H4RMRLqxfL8=
X-Received: by 2002:a25:33c4:: with SMTP id z187mr121372ybz.27.1601052614084;
 Fri, 25 Sep 2020 09:50:14 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1600967205.git.daniel@iogearbox.net> <ae48d5b3c4b6b7ee1285c3167c3aa38ae3fdc093.1600967205.git.daniel@iogearbox.net>
 <CAEf4BzZ4kFGeUgpJV9MgE1iJ6Db=E-TXoF73z3Rae5zgp5LLZA@mail.gmail.com>
 <5f3850b2-7346-02d7-50f5-f63355115f35@iogearbox.net> <ec815b89-09aa-9e33-29b4-19e369ccfa21@iogearbox.net>
 <52cd972d-c183-5d14-b790-4d3a66b8fda2@iogearbox.net>
In-Reply-To: <52cd972d-c183-5d14-b790-4d3a66b8fda2@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 25 Sep 2020 09:50:03 -0700
Message-ID: <CAEf4BzZmpLOCSp4wvXWHzmfZHq5R4S32M0_V5OvGA+QQGGG43w@mail.gmail.com>
Subject: Re: [PATCH bpf-next 4/6] bpf, libbpf: add bpf_tail_call_static helper
 for bpf programs
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 25, 2020 at 8:52 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 9/25/20 5:42 PM, Daniel Borkmann wrote:
> > On 9/25/20 12:17 AM, Daniel Borkmann wrote:
> >> On 9/24/20 10:53 PM, Andrii Nakryiko wrote:
> >>> On Thu, Sep 24, 2020 at 11:22 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
> >>>>
> >>>> Port of tail_call_static() helper function from Cilium's BPF code base [0]
> >>>> to libbpf, so others can easily consume it as well. We've been using this
> >>>> in production code for some time now. The main idea is that we guarantee
> >>>> that the kernel's BPF infrastructure and JIT (here: x86_64) can patch the
> >>>> JITed BPF insns with direct jumps instead of having to fall back to using
> >>>> expensive retpolines. By using inline asm, we guarantee that the compiler
> >>>> won't merge the call from different paths with potentially different
> >>>> content of r2/r3.
> >>>>
> >>>> We're also using __throw_build_bug() macro in different places as a neat
> >>>> trick to trigger compilation errors when compiler does not remove code at
> >>>> compilation time. This works for the BPF backend as it does not implement
> >>>> the __builtin_trap().
> >>>>
> >>>>    [0] https://github.com/cilium/cilium/commit/f5537c26020d5297b70936c6b7d03a1e412a1035
> >>>>
> >>>> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> >>>> ---
> >>>>   tools/lib/bpf/bpf_helpers.h | 32 ++++++++++++++++++++++++++++++++
> >>>>   1 file changed, 32 insertions(+)
> >>>>
> >>>> diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
> >>>> index 1106777df00b..18b75a4c82e6 100644
> >>>> --- a/tools/lib/bpf/bpf_helpers.h
> >>>> +++ b/tools/lib/bpf/bpf_helpers.h
> >>>> @@ -53,6 +53,38 @@
> >>>>          })
> >>>>   #endif
> >>>>
> >>>> +/*
> >>>> + * Misc useful helper macros
> >>>> + */
> >>>> +#ifndef __throw_build_bug
> >>>> +# define __throw_build_bug()   __builtin_trap()
> >>>> +#endif
> >>>
> >>> this will become part of libbpf stable API, do we want/need to expose
> >>> it? If we want to expose it, then we should probably provide a better
> >>> description.
> >>>
> >>> But also curious, how is it better than _Static_assert() (see
> >>> test_cls_redirect.c), which also allows to provide a better error
> >>> message?
> >>
> >> Need to get back to you whether that has same semantics. We use the __throw_build_bug()
> >> also in __bpf_memzero() and friends [0] as a way to trigger a hard build bug if we hit
> >> a default switch-case [0], so we detect unsupported sizes which are not covered by the
> >> implementation yet. If _Static_assert (0, "foo") does the trick, we could also use that;
> >> will check with our code base.
> >
> > So _Static_assert() won't work here, for example consider:
> >
> >    # cat f1.c
> >    int main(void)
> >    {
> >      if (0)
> >          _Static_assert(0, "foo");
> >      return 0;
> >    }
> >    # clang -target bpf -Wall -O2 -c f1.c -o f1.o
> >    f1.c:4:3: error: expected expression
> >                  _Static_assert(0, "foo");
> >                  ^
> >    1 error generated.
>
> .. aaand it looks like I need some more coffee. ;-) But result is the same after all:
>
>    # clang -target bpf -Wall -O2 -c f1.c -o f1.o
>    f1.c:4:3: error: static_assert failed "foo"
>                  _Static_assert(0, "foo");
>                  ^              ~
>    1 error generated.
>
>    # cat f1.c
>    int main(void)
>    {
>         if (0) {
>                 _Static_assert(0, "foo");
>         }
>         return 0;
>    }

You need still more :-P. For you use case it will look like this:

$ cat test-bla.c
int bar(int x) {
       _Static_assert(!__builtin_constant_p(x), "not a constant!");
       return x;
}

int foo() {
        bar(123);
        return 0;
}
$ clang -target bpf -O2 -c test-bla.c -o test-bla.o
$ echo $?
0

But in general to ensure unreachable code it's probably useful anyway
to have this. How about calling it __bpf_build_error() or maybe even
__bpf_unreachable()?

>
> > In order for it to work as required form the use-case, the _Static_assert() must not trigger
> > here given the path is unreachable and will be optimized away. I'll add a comment to the
> > __throw_build_bug() helper. Given libbpf we should probably also prefix with bpf_. If you see
> > a better name that would fit, pls let me know.
> >
> >>    [0] https://github.com/cilium/cilium/blob/master/bpf/include/bpf/builtins.h
> > Thanks,
> > Daniel
>
