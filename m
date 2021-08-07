Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1F653E326A
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 02:49:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbhHGAtS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 20:49:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbhHGAtR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 20:49:17 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27C8AC0613CF
        for <netdev@vger.kernel.org>; Fri,  6 Aug 2021 17:49:01 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id hw6so17943751ejc.10
        for <netdev@vger.kernel.org>; Fri, 06 Aug 2021 17:49:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Eu2KDrXHGvsVvXrn9bGbtjdk99ZR9lKUyg7uD7JNdeI=;
        b=sLNCfQlikbgidaRYypM6xT+/vzj0lEaHZZ0keFXpYJpaHE5WKKEo6eAzT8Oz8nigod
         Guw+NL6MIGC4Uh4XBzkwtV3eDTawCy9QSKjzSZ9qcRQLOeH9AX1o2HhUfaRL12YOeAqO
         AeqsbIls7MsCi7oNY4cDupYOgdP9njqCjDJvmofOwLgIyQ6A4WPUHevA0N6Iw+zEdM8k
         WDAJ0X4KD3UIYgS0W2xpiMu4Cbtf3o+LRXHyKViCrKePSaieAvCpgL1Megaxi+l6n8GB
         UxsQWdvAdaGsPObJx1579a9kOasj/8G1A3HFVVgRXOzPPpVGw/QABK+6y4ZNvofuD/iV
         oFvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Eu2KDrXHGvsVvXrn9bGbtjdk99ZR9lKUyg7uD7JNdeI=;
        b=oB3E+xmZHSRmx5SEfHABYmOR0bZ4ufY0SWyU1G/XYVPO3A7HgfSmZHjr7s8hjNz/tb
         qnbBI4j+s2vybUn613z4ZjAiIjjTCJQfs2l5rizpsMObSz79euOmbDXTokBVHRe04WOc
         69e14pNUU5XREDxjcdZ0fPy8BPh3xag03hhaFEY14QfWWFY+Uf0QbTvh1Xxl32NWWlXm
         2i4J0JoJwFv8epbr3BljqUL5H7+jzu9dJj2PPEr4BJ4Q1Z5e1ogxdX+RBi9QJZQj+TBu
         ENnAM5pz6HygPxQtWF6tntADvV0ATagjkfP3WjcfZD2U+WaohTA3K9v7W1Ytju/TyzVb
         0W6g==
X-Gm-Message-State: AOAM532DmGE30Vxf1AB+3RPM+GLPyN72N6ICrA/KZpg8hlcRs+yBlNu1
        DDMqMvN6tl7uxnpawbLFJMrLK5cHyUfz9nO3cgJK1Q==
X-Google-Smtp-Source: ABdhPJxzShJkvcLMOoPjQWH38YxQcWttagk5u5GoybUhIMeRLnc27akzSm9m8CIqA/mw1vrcY83LIExF2vKFYks+Mmg=
X-Received: by 2002:a17:906:14c8:: with SMTP id y8mr12295078ejc.475.1628297339478;
 Fri, 06 Aug 2021 17:48:59 -0700 (PDT)
MIME-Version: 1.0
References: <20210802212815.3488773-1-haoluo@google.com> <CAEf4BzbRyf41ADFa==mT591Zh8FDOtNnm5LZQvu3X+SxmkoAew@mail.gmail.com>
In-Reply-To: <CAEf4BzbRyf41ADFa==mT591Zh8FDOtNnm5LZQvu3X+SxmkoAew@mail.gmail.com>
From:   Hao Luo <haoluo@google.com>
Date:   Fri, 6 Aug 2021 17:48:48 -0700
Message-ID: <CA+khW7iC-kPhLmPa7=6rc-kY5E49znL8T1vat5-Uz+yYwBWsbw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: support weak typed ksyms.
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for taking a look.

On Fri, Aug 6, 2021 at 3:40 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Mon, Aug 2, 2021 at 2:29 PM Hao Luo <haoluo@google.com> wrote:
> >
> > Currently weak typeless ksyms have default value zero, when they don't
> > exist in the kernel. However, weak typed ksyms are rejected by libbpf.
> > This means that if a bpf object contains the declaration of a
> > non-existing weak typed ksym, it will be rejected even if there is
> > no program that references the symbol.
> >
> > In fact, we could let them to pass the checks in libbpf and leave the
> > object to be rejected by the bpf verifier. More specifically, upon
> > seeing a weak typed symbol, libbpf can assign it a zero btf_id, which
> > is associated to the type 'void'. The verifier expects the symbol to
> > be BTF_VAR_KIND instead, therefore will reject loading.
> >
> > In practice, we often add new kernel symbols and roll out the kernel
> > changes to fleet. And we want to release a single bpf object that can
> > be loaded on both the new and the old kernels. Passing weak typed ksyms
> > in libbpf allows us to do so as long as the programs that reference the
> > new symbols are disabled on the old kernel.
>
> How do you detect whether a given ksym is present or not? You check
> that from user-space and then use .rodata to turn off pieces of BPF
> logic? That's quite inconvenient. It would be great if these typed
> ksyms worked the same way as typeless ones:
>
It's not by detect. In my use case, I can add a flag to the
application to disable/enable loading a BPF program. Because we know
at which kernel version a new symbol was introduced, we can coordinate
the application flag with the kernel version to avoid the faulting
code being loaded on an old kernel.

> extern const int bpf_link_fops3 __ksym __weak;
>
> /* then in BPF program */
>
> if (&bpf_link_fops3) {
>    /* use bpf_link_fops3 */
> }
>
>
> I haven't tried, but I suspect it could be made to work if libbpf
> replaces corresponding ldimm64 instruction (with BTF ID) into a plain
> ldimm64 instruction loading 0 directly. That would allow the above
> check (and it would be known false to the verifier) to succeed without
> the verifier rejecting the BPF program. If actual use of non-existing
> typed symbol is not guarded properly, verifier would see that register
> is not PTR_TO_BTF_ID and wouldn't allow to use it for direct memory
> reads or passing it to BPF helpers.
>
> Have you considered such an approach?
>
I haven't thought about this approach. I just grabbed the quickest
solution I can think of. Will follow your suggestion and see if it
works.

>
> Separately, please use ASSERT_XXX() macros for tests, not plain
> CHECK()s. Thanks.
>
ACK.

> >
> > Signed-off-by: Hao Luo <haoluo@google.com>
> > ---
> >  tools/lib/bpf/libbpf.c                        | 17 +++++-
> >  .../selftests/bpf/prog_tests/ksyms_btf.c      | 42 +++++++++++++
> >  .../selftests/bpf/progs/test_ksyms_weak.c     | 60 +++++++++++++++++++
> >  3 files changed, 116 insertions(+), 3 deletions(-)
> >  create mode 100644 tools/testing/selftests/bpf/progs/test_ksyms_weak.c
> >
>
> [...]
