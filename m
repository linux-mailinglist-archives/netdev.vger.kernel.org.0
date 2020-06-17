Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5261E1FC364
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 03:37:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbgFQBhD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 21:37:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbgFQBhC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 21:37:02 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23B09C061573;
        Tue, 16 Jun 2020 18:37:02 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id fc4so312968qvb.1;
        Tue, 16 Jun 2020 18:37:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c6ZTHaYJLBwQxZBoxhjnIRFJCsgEKgO1Ywt4ii7ixdk=;
        b=jch0k+iSBeBqxicS/11ksrXHMybYM/qTeYo/20WCFiEqTFKo0ZkZREV3G+kScqd4l2
         sIhFIVEof9EqXdQp794ApuripFSnYntJbq17jebnvYidVu9eIA6tYQxgbZxgp1BTzsuL
         4ST8rNr43fLdI9/aJXDOdXfw94vhn7RwwchN+GZN+XTbgzruoddwpCeyO9S5mH15cz0l
         AxKuH0oxfEZ6kVEwpATnKpq8M1JDdjFBQRg7uvRchOnoj2PkVoV8mvsZpt1CJBlNiyog
         jLlusFDUKc2SWyThKdlNySg8b19sZBYf7C3x0AW3R8zo301k0TaE/e4Zfu8VeOkK8vDT
         wuuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c6ZTHaYJLBwQxZBoxhjnIRFJCsgEKgO1Ywt4ii7ixdk=;
        b=tcrPzCSRvkAQRTUU373w/1RrEm29k7zJ4ibOu0zN2PIoIk+wgftPRF/TiWIrVnnwe2
         13EzbN+osespT2KAe5MXvxvCJYgAi3Wx0sB7URtSs8351a0RidqIHOQZpV4N0mTC8MR4
         4k7iUfDqX7lepQ+37g/VQjQNICu8Bty6IYGjTxiXtlHBs4oSEc54g8s5VlDUoDm5mUB9
         T4fTerjRVghQxjEiYKvQz0LDQ3fzHzchlAwM1oNE70VVwzAYnssXwK5bZm0oyo6ORKZA
         WBkDYXs2M3mxr4Eiv6Pee3PAizVLrs6JPQKbOVe978L5puSEz4tr/vRYhjaPN2r9ajeL
         d0ZA==
X-Gm-Message-State: AOAM533i780pRdcoaWJR5Zp0PUD4BIJQbrojNyONEjFQDqU6l+CI+4dt
        dWVp1OVU8R6uSPrYzX4x283Jm4b8mdj1X1Flijg=
X-Google-Smtp-Source: ABdhPJyL+Me4TiVD+1ge4gZY2lm8PNYEif+0vqdNYyDht+v8lfOy1zY8NFuUV1/ORwrVLn2H7tLzKLTGIvvHbFN3594=
X-Received: by 2002:ad4:598f:: with SMTP id ek15mr5260444qvb.196.1592357821294;
 Tue, 16 Jun 2020 18:37:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200612223150.1177182-1-andriin@fb.com> <20200612223150.1177182-3-andriin@fb.com>
 <CA+khW7hFZzp_K_xydSFw0O3LYB22_fC=Z4wG7i9Si+phGHn4cQ@mail.gmail.com>
 <CAEf4BzYVY-sA_SRqxr-dxrkR5DPW6tv3tnNonK=4WPx6eEiZFQ@mail.gmail.com>
 <CA+khW7iU4oT3N2fYK6ym7XtWAnyD4fmiMpkuNybrJSROJeuk8A@mail.gmail.com> <CA+khW7gRw+4o2P+cDY+D08OPa8xH3msgQC7C5+9qMy0yashOsA@mail.gmail.com>
In-Reply-To: <CA+khW7gRw+4o2P+cDY+D08OPa8xH3msgQC7C5+9qMy0yashOsA@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 16 Jun 2020 18:36:50 -0700
Message-ID: <CAEf4BzYKTjUF0-uWTUZQ1PkFGwUfx=KgMTM5t9RXewCF_XQkXg@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 2/8] libbpf: add support for extracting
 kernel symbol addresses
To:     Hao Luo <haoluo@google.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Quentin Monnet <quentin@isovalent.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 16, 2020 at 6:24 PM Hao Luo <haoluo@google.com> wrote:
>
> Andrii,
>
> Do you think we need to put the kernel's variables in one single
> DATASEC in vmlinux BTF? It looks like all the ksyms in the program
> will be under one ".ksyms" section, so we are not able to tell whether
> a ksym is from a percpu section or a .rodata section. Without this
> information, if the vmlinux has multiple DATASECs, the loader may need
> to traverse all of them. If vmlinux BTF has only one DATASEC, it
> matches the object's BTF better.
>
> Right now, the percpu vars are in a ".data..percpu" DATASEC in my
> patch and the plan seems that we will introduce more DATASECs to hold
> other data.
>
> Please let me know your insights here. Thanks.

I think we should keep original DATASECs in vmlinux's BTF, so that
they match ELF sections. Otherwise BTF is going to lie and will cause
confusion down the road in the longer term.

On the BPF program side, though, I think we'll limit it to just two
special sections: .ksyms and .ksyms.percpu. libbpf will have to
traverse all vmlinux DATASECs to find corresponding variables, but
that's ok, it has to do the linear scan either way.

>
> Hao
>
> On Tue, Jun 16, 2020 at 1:05 AM Hao Luo <haoluo@google.com> wrote:
> >
> > On Mon, Jun 15, 2020 at 12:08 PM Andrii Nakryiko
> > <andrii.nakryiko@gmail.com> wrote:
> > >
> > > On Mon, Jun 15, 2020 at 9:44 AM Hao Luo <haoluo@google.com> wrote:
> > > >
> > > > Thanks, Andrii,
> > > >
> > > > This change looks nice! A couple of comments:
> > > >
> > > > 1. A 'void' type variable looks slightly odd from a user's perspective. How about using 'u64' or 'void *'? Or at least, a named type, which aliases to 'void'?
> > >
> > > That choice is very deliberate one. `extern const void` is the right
> > > way in C language to access linker-generated symbols, for instance,
> > > which is quite similar to what the intent is her. Having void type is
> > > very explicit that you don't know/care about that value pointed to by
> > > extern address, the only operation you can perform is to get it's
> > > address.
> > >
> > > Once we add kernel variables support, that's when types will start to
> > > be specified and libbpf will do extra checks (type matching) and extra
> > > work (generating ldimm64 with BTF ID, for instance), to allow C code
> > > to access data pointed to by extern address.
> > >
> > > Switching type to u64 would be misleading in allowing C code to
> > > implicitly dereference value of extern. E.g., there is a big
> > > difference between:
> > >
> > > extern u64 bla;
> > >
> > > printf("%lld\n", bla); /* de-reference happens here, we get contents
> > > of memory pointed to by "bla" symbol */
> > >
> > > printf("%p\n", &bla); /* here we get value of linker symbol/address of
> > > extern variable */
> > >
> > > Currently I explicitly support only the latter and want to prevent the
> > > former, until we have kernel variables in BTF. Using `extern void`
> > > makes compiler enforce that only the &bla form is allowed. Everything
> > > else is compilation error.
> > >
> >
> > Ah, I see. I've been taking the extern variable as an actual variable
> > that contains the symbol's address, which is the first case. Your
> > approach makes sense. Thanks for explaining.
> >
> > > > 2. About the type size of ksym, IIUC, it looks strange that the values read from kallsyms have 8 bytes but their corresponding vs->size is 4 bytes and vs->type points to 4-byte int. Can we make them of the same size?
> > >
> > > That's a bit of a hack on my part. Variable needs to point to some
> > > type, which size will match the size of datasec's varinfo entry. This
> > > is checked and enforced by kernel. I'm looking for 4-byte int, because
> > > it's almost guaranteed that it will be present in program's BTF and I
> > > won't have to explicitly add it (it's because all BPF programs return
> > > int, so it must be in program's BTF already). While 8-byte long is
> > > less likely to be there.
> > >
> > > In the future, if we have a nicer way to extend BTF (and we will
> > > soon), we can do this a bit better, but either way that .ksyms DATASEC
> > > type isn't used for anything (there is no map with that DATASEC as a
> > > value type), so it doesn't matter.
> > >
> >
> > Thanks for explaining, Andrii.
> >
> > These explanations as comments in the code would be quite helpful, IMHO.
