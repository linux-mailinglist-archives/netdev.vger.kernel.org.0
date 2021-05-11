Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5A0F37ADBB
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 20:04:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231987AbhEKSFx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 14:05:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231587AbhEKSFw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 14:05:52 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D6C8C061574;
        Tue, 11 May 2021 11:04:46 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id l7so27445806ybf.8;
        Tue, 11 May 2021 11:04:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HAd6Po8qFg5Mlb/UJtIebhM5lrb26+Q+ElIkEvDXRcQ=;
        b=uRQz8uMZNRd0jwyQ+RLtLO09ubkMg+ikbP0esgrnjTpcX+AqWnzzrmQ4gjDcJXOglw
         6xLmMl8/JX+N+90Jbf7gcmE9mZCG3WNbJM6EIDXaqVIHv8R5O67Fhkp8PyMoMeUUJYEA
         zLdQlDcMHQo7Q0Y41zrn26VmZnTfEKbssek1yMjkErXFoZFVRp2tYYdBU5Dihu3w4/r3
         k7oUCywr/nbR1vROjLTCzhTl5Rxov3fLvcawnYuFOY+1b3o0SAPZonBWde17eEF6U/yM
         PuxN4Sms17nVBUKR/XxoE/UcTFzHDZbN7LG92xSorbOJAn5nevswtwW112WF/3B5PKLJ
         cnBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HAd6Po8qFg5Mlb/UJtIebhM5lrb26+Q+ElIkEvDXRcQ=;
        b=ssFy0VNR20jshJn6tV7+M0R8GIL9PGd8MwxfllneB3mu8VIiS8dW5cG767cMpj7psk
         V5W3SHow2tpArI8aSXJT7ezzvzywgrgbhOqD8fSEPwKi3LYNJ9albrlfJ5rkJmsMRQ7h
         i8I56n8ytmAzsaQc7v70yOnmcENWt12PO3rmIeaBLnWDpDj6zghsKNdmoQged80bm8tY
         C7XSuxfoWW2MWnioIkxEqwHB7I4/ebHFNKue311fmrdcdDz1E0/6XihbRux1xQQ65PDr
         RAYq4BuGS4qpcWAKaeQgvqRfWmBKG29gdZF9+rc4gduUolxVq84nuH+AasOxu7+T1JTo
         BOPw==
X-Gm-Message-State: AOAM530DZywTdGrVQpwWLvsBzhoqMcw7n4hIDf7xjc3ZoaJS5rViGj07
        BiLWxyuljZOH+hKO1v0ooAmI7JF8PbuXQQPoIEwsEUHU
X-Google-Smtp-Source: ABdhPJy5mZoJBYABtl/ot4xHgqYqB/vPUy4Qb79xbhpE/HIZL9OrZXTN/8c9zSIDLgoRQmDzD+/QNTO+WKpmH6zXfsw=
X-Received: by 2002:a25:9942:: with SMTP id n2mr44198259ybo.230.1620756285372;
 Tue, 11 May 2021 11:04:45 -0700 (PDT)
MIME-Version: 1.0
References: <CAADnVQKo+efxMvgrqYqVvUEgiz_GXgBVOt4ddPTw_mLuvr2HUw@mail.gmail.com>
 <CAEf4BzZifOFHr4gozUuSFTh7rTWu2cE_-L4H1shLV5OKyQ92uw@mail.gmail.com>
 <CAADnVQ+h78QijAjbkNqAWn+TAFxrd6vE=mXqWRcy815hkTFvOw@mail.gmail.com>
 <CAEf4BzZOmCgmbYDUGA-s5AF6XJFkT1xKinY3Jax3Zm2OLNmguA@mail.gmail.com>
 <20210426223449.5njjmcjpu63chqbb@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzYZX9YJcoragK20cvQvr_tPTWYBQSRh7diKc1KoCtu4Dg@mail.gmail.com>
 <20210427022231.pbgtrdbxpgdx2zrw@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzZOwTp4vQxvCSXaS4-94fz_eZ7Q4n6uQfkAnMQnLRaTbQ@mail.gmail.com>
 <20210428045545.egqvhyulr4ybbad6@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzZo7_r-hsNvJt3w3kyrmmBJj7ghGY8+k4nvKF0KLjma=w@mail.gmail.com>
 <20210504044204.kpt6t5kaomj7oivq@ast-mbp> <CAADnVQ+WV8xZqJfWx8em5Ch8aKA8xcPqR0wT0BdFf9M==W5_FQ@mail.gmail.com>
 <CACAyw99uiX2rkAcqXXHivc0NZ-t2fwZSZfORpe2h_y3AvDDueQ@mail.gmail.com>
In-Reply-To: <CACAyw99uiX2rkAcqXXHivc0NZ-t2fwZSZfORpe2h_y3AvDDueQ@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 11 May 2021 11:04:34 -0700
Message-ID: <CAEf4BzYTgSTBf8+-Hqsv2SF-L17Tu9se=oZ=vEfekQY_+fLB=g@mail.gmail.com>
Subject: Re: bpf libraries and static variables. Was: [PATCH v2 bpf-next 2/6]
 libbpf: rename static variables during linking
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        John Fastabend <john.fastabend@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 11, 2021 at 7:20 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
>
> On Wed, 5 May 2021 at 06:22, Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > > All of the above is up for discussion. I'd love to hear what golang folks
> > > are thinking, since above proposal is C centric.
>
> Sorry for the late reply, I was on holiday.
>
> Regarding your conntrack library example:
> - what is the difference between impl.bpf.c and ct_api.bpf.c? If I
> understand correctly, ct_api is used to generate the skel.h, but impl
> isn't?

I don't think it matters much, the point is that your BPF library can
be compiled from multiple .c files. Same for BPF application itself,
it can be compiled from multiple .c files and use multiple BPF
libraries.

> - what file would main.bpf.c include? ct_api or skel.h?

main.bpf.c will include (if at all) anything that BPF library will
provide *for BPF side of things*. I.e., some sort of ct_api.bpf.h.
skel.h is not supposed to be included in BPF code, only user-space.

>
> Regarding Andrii's proposal in the forwarded email to use __hidden,
> __internal etc. Are these correct:
> - static int foo: this is only available in the same .o, not
> accessible from user space. Can be referenced via extern int foo?

Yes about availability only from BPF and only within single .o. Not
true about extern, you can't extern statics (just like in user-space).

> - __hidden int foo: only available in same .o, not accessible from user space
> - __internal int foo: only available in same .a via extern, not
> accessible from user space

See my last RFC patch set for details (last patch especially with more
details in commit log). It's the other way around. __hidden means
available across multiple .o files during static linking. Once static
linking is done (e.g., you compiled BPF library into my_lib.bpf.o),
__hidden is restricted and converted into __internal. __internal means
not available outside of single .o. global __internal symbol is
equivalent to static variable, except it's accessible from BPF
skeleton/sub-skeleton and we have name uniqueness guarantee.

> - int foo: available / conflicts in all .o, accessible from user space
> (aka included in skel.h)

yes, it's a plain global symbol with STV_DEFAULT visibility.

>
> When you speak of the linker, do you mean libbpf or the clang / llvm
> linker? The Go toolchain has a simplistic linker to support bpf2bpf
> calls from the same .o so I imagine libbpf has something similar.

We are talking about libbpf's struct bpf_linker linker.

>
> > I want to clarify a few things that were brought up in offline discussions.
> > There are several options:
> > 1. don't emit statics at all.
> > That will break some skeleton users and doesn't solve the name conflict issue.
> > The library authors would need to be careful and use a unique enough
> > prefix for all global vars (including attribute("hidden") ones).
> > That's no different with traditional static linking in C.
> > bpf static linker already rejects linking if file1.bpf.c is trying to
> > 'extern int foo()'
> > when it was '__hidden int foo();' in file2.bpf.c
> > That's safer than traditional linker and the same approach can be
> > applied to vars.
> > So externing of __hidden vars won't be possible, but they will name conflict.
> >

[...]

>
> --
> Lorenz Bauer  |  Systems Engineer
> 6th Floor, County Hall/The Riverside Building, SE1 7PB, UK
>
> www.cloudflare.com
