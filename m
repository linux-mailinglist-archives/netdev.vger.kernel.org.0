Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 369E31FC357
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 03:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726600AbgFQBYg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 21:24:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbgFQBYg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 21:24:36 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2309C06174E
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 18:24:34 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id n24so505771ejd.0
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 18:24:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LSIqW5JaPcAnOUzpMadSGonBYMJj0ci6vy8jvMVGPVI=;
        b=TrlPqHJuaClVx+nMFprjxAPaXgcujsepiYAf6aA6MNK0ox18J+ZydKJD7PtBeLAGD3
         B+rOtasiL3jYbjLtDFj5iJHHmlca26k04Hv4PsFPzIkNfxCvk3i/8vzwVhpe36vu6f3F
         X8T60gJnul/IcUAeVD20fk+Hr9xl9VdHvTFo4xg6R8Dl7czAAadBS8RCwilrFTZEJMnN
         bNkbMvB2EE4r4uqnkHsqP9kz9qKCAxppnyXemVPRorBKPcHFEMHdZGmzF2xCf7OdGfAE
         /IPYQthp3VArvW4c67UMTcj0DyMXRTUcmspeKM9W8qFdlMQy7VI2jJKJSUQ4LDNMW0Oq
         uK2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LSIqW5JaPcAnOUzpMadSGonBYMJj0ci6vy8jvMVGPVI=;
        b=BwIzc5J8XDfbSnkp35YapD/E7ePzcZ1LHoDWcJ/2KBc0mKuXIE0wCOz028G3t/nbdi
         xjYS6QkJexv+GZaisNfZlzmcwBMYTfOExTk4rfaQnyjtZ+IZF16LWG7bYGNND9NDgV2n
         ocKouiVGOCMakjXhB1ny1LyvTV1ZLAJSpcY/VVshLUS5SR0BHEE7lG3U9t7yv8dLf9Sm
         rMoWxnVKFyoHHuEpWS691zI9wHG6QrWwm2kGSuQHx/N33BaQkRsUA5v1CfDrU+FTTYbo
         bxtuwK9vtryqgojFkLTmgbJEsBHwf7/L1dvg8p67gfJEeb74GCDcmQhjMGTSn9YOtks/
         HDoA==
X-Gm-Message-State: AOAM533pGEmw/387lMcyN5y9u1x8dH6taYkDD+AsLUXLL1Jhn7eT8SKS
        vP3HOIn87JxLp3b8RT1Ov8IQEeIJaqMjhFyxN/NlDw==
X-Google-Smtp-Source: ABdhPJx0DeylCJAyby2sjEKfD2w7jyvHOO9nxQjQZBiLYBLw72FhCDGS5lznk94VKqitkn6bLqTUWrgm/dHJuivso+Q=
X-Received: by 2002:a17:907:2718:: with SMTP id w24mr1386628ejk.487.1592357073192;
 Tue, 16 Jun 2020 18:24:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200612223150.1177182-1-andriin@fb.com> <20200612223150.1177182-3-andriin@fb.com>
 <CA+khW7hFZzp_K_xydSFw0O3LYB22_fC=Z4wG7i9Si+phGHn4cQ@mail.gmail.com>
 <CAEf4BzYVY-sA_SRqxr-dxrkR5DPW6tv3tnNonK=4WPx6eEiZFQ@mail.gmail.com> <CA+khW7iU4oT3N2fYK6ym7XtWAnyD4fmiMpkuNybrJSROJeuk8A@mail.gmail.com>
In-Reply-To: <CA+khW7iU4oT3N2fYK6ym7XtWAnyD4fmiMpkuNybrJSROJeuk8A@mail.gmail.com>
From:   Hao Luo <haoluo@google.com>
Date:   Tue, 16 Jun 2020 18:24:21 -0700
Message-ID: <CA+khW7gRw+4o2P+cDY+D08OPa8xH3msgQC7C5+9qMy0yashOsA@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 2/8] libbpf: add support for extracting
 kernel symbol addresses
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
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

Andrii,

Do you think we need to put the kernel's variables in one single
DATASEC in vmlinux BTF? It looks like all the ksyms in the program
will be under one ".ksyms" section, so we are not able to tell whether
a ksym is from a percpu section or a .rodata section. Without this
information, if the vmlinux has multiple DATASECs, the loader may need
to traverse all of them. If vmlinux BTF has only one DATASEC, it
matches the object's BTF better.

Right now, the percpu vars are in a ".data..percpu" DATASEC in my
patch and the plan seems that we will introduce more DATASECs to hold
other data.

Please let me know your insights here. Thanks.

Hao

On Tue, Jun 16, 2020 at 1:05 AM Hao Luo <haoluo@google.com> wrote:
>
> On Mon, Jun 15, 2020 at 12:08 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Mon, Jun 15, 2020 at 9:44 AM Hao Luo <haoluo@google.com> wrote:
> > >
> > > Thanks, Andrii,
> > >
> > > This change looks nice! A couple of comments:
> > >
> > > 1. A 'void' type variable looks slightly odd from a user's perspective. How about using 'u64' or 'void *'? Or at least, a named type, which aliases to 'void'?
> >
> > That choice is very deliberate one. `extern const void` is the right
> > way in C language to access linker-generated symbols, for instance,
> > which is quite similar to what the intent is her. Having void type is
> > very explicit that you don't know/care about that value pointed to by
> > extern address, the only operation you can perform is to get it's
> > address.
> >
> > Once we add kernel variables support, that's when types will start to
> > be specified and libbpf will do extra checks (type matching) and extra
> > work (generating ldimm64 with BTF ID, for instance), to allow C code
> > to access data pointed to by extern address.
> >
> > Switching type to u64 would be misleading in allowing C code to
> > implicitly dereference value of extern. E.g., there is a big
> > difference between:
> >
> > extern u64 bla;
> >
> > printf("%lld\n", bla); /* de-reference happens here, we get contents
> > of memory pointed to by "bla" symbol */
> >
> > printf("%p\n", &bla); /* here we get value of linker symbol/address of
> > extern variable */
> >
> > Currently I explicitly support only the latter and want to prevent the
> > former, until we have kernel variables in BTF. Using `extern void`
> > makes compiler enforce that only the &bla form is allowed. Everything
> > else is compilation error.
> >
>
> Ah, I see. I've been taking the extern variable as an actual variable
> that contains the symbol's address, which is the first case. Your
> approach makes sense. Thanks for explaining.
>
> > > 2. About the type size of ksym, IIUC, it looks strange that the values read from kallsyms have 8 bytes but their corresponding vs->size is 4 bytes and vs->type points to 4-byte int. Can we make them of the same size?
> >
> > That's a bit of a hack on my part. Variable needs to point to some
> > type, which size will match the size of datasec's varinfo entry. This
> > is checked and enforced by kernel. I'm looking for 4-byte int, because
> > it's almost guaranteed that it will be present in program's BTF and I
> > won't have to explicitly add it (it's because all BPF programs return
> > int, so it must be in program's BTF already). While 8-byte long is
> > less likely to be there.
> >
> > In the future, if we have a nicer way to extend BTF (and we will
> > soon), we can do this a bit better, but either way that .ksyms DATASEC
> > type isn't used for anything (there is no map with that DATASEC as a
> > value type), so it doesn't matter.
> >
>
> Thanks for explaining, Andrii.
>
> These explanations as comments in the code would be quite helpful, IMHO.
