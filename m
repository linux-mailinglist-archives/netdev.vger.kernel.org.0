Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88C4A3E31D9
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 00:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242434AbhHFWks (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 18:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231281AbhHFWkr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 18:40:47 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FAF3C0613CF;
        Fri,  6 Aug 2021 15:40:30 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id j77so17858748ybj.3;
        Fri, 06 Aug 2021 15:40:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=80dsSfMEM2/OOVuLC4bXzv6yTdaVBrlMogH/dimQq7c=;
        b=UgkXVhMHF42NXB0G8m59N2rpOqow5TPa2wT2EQme0kZo9PrYyPGqmzauMqOMwf/JFr
         Hc+BjhwVdLMPLqy8BDcyGFE2F2UjDRrefsSnYCNUu7AZpAZpKTqwG6CufzCWMAb8thUD
         EESHurRzwC0uHp4f83WM53KTVmeyJ4V7MRC7H8JO/IVgjGqsARF6HriuNE/bbYlpJru1
         qq/7DGPOYXD97SYH0LRn7KcVW0cG1NNwcZoVnsUepWsksDACBZhI/81L+Byl7ySJdj6z
         KOzke2s8ZkiLnbSlWOBGiUpwbzkRgvB2WTNIhswnppR+DiEkKFfzDo0g8WKo/wwz0W/9
         KXfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=80dsSfMEM2/OOVuLC4bXzv6yTdaVBrlMogH/dimQq7c=;
        b=IZVAuHe5Y/gCiPgTaPd9EPGsptxieSgRXY74Cigbq5nBhWDkO1EInagCV0xeGmaS20
         VisAp6fReng3F9olFYKs4S7qqBEBfiF22RU0wY7Jy2x9WjMr1uDyGUepQWhxZRjE2EWB
         E9p5SuTPfQMxL6M/jdZmARl1WOUHIq4pWnst2TnYe1+qSpu43a1tDiayZh5+tMvyPtTL
         6UVqRwkkkTkMSwDxdNYmqZjY5o8v2iA27Y1GiYq/WaRJKzPHMeKS0z9KGF30jMt6WEvc
         PtaAYBCGYtr0JA0enwdEG6dD61gOLduS7zcUbFaXHiIr/R+AUaSSm3IzjYhCZjIGi4lh
         PsjQ==
X-Gm-Message-State: AOAM5338hbfxj522oQsOjsIRQAnci7WAylssVzMSjldtB7F33Xaw8Ubd
        wRvLwlWpKmZ9jwtrao7eNePnyO3+GCO9WXlP/sA=
X-Google-Smtp-Source: ABdhPJy5OB+B+A+EKSnk9A9ItdT3iGzq28Hxj4l3l0DOsGkBiUn+puLC9US3kS7+djXzqIgl8M4qK+nWpjPH58FBaFI=
X-Received: by 2002:a25:2901:: with SMTP id p1mr15804127ybp.459.1628289629951;
 Fri, 06 Aug 2021 15:40:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210802212815.3488773-1-haoluo@google.com>
In-Reply-To: <20210802212815.3488773-1-haoluo@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 6 Aug 2021 15:40:19 -0700
Message-ID: <CAEf4BzbRyf41ADFa==mT591Zh8FDOtNnm5LZQvu3X+SxmkoAew@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: support weak typed ksyms.
To:     Hao Luo <haoluo@google.com>
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

On Mon, Aug 2, 2021 at 2:29 PM Hao Luo <haoluo@google.com> wrote:
>
> Currently weak typeless ksyms have default value zero, when they don't
> exist in the kernel. However, weak typed ksyms are rejected by libbpf.
> This means that if a bpf object contains the declaration of a
> non-existing weak typed ksym, it will be rejected even if there is
> no program that references the symbol.
>
> In fact, we could let them to pass the checks in libbpf and leave the
> object to be rejected by the bpf verifier. More specifically, upon
> seeing a weak typed symbol, libbpf can assign it a zero btf_id, which
> is associated to the type 'void'. The verifier expects the symbol to
> be BTF_VAR_KIND instead, therefore will reject loading.
>
> In practice, we often add new kernel symbols and roll out the kernel
> changes to fleet. And we want to release a single bpf object that can
> be loaded on both the new and the old kernels. Passing weak typed ksyms
> in libbpf allows us to do so as long as the programs that reference the
> new symbols are disabled on the old kernel.

How do you detect whether a given ksym is present or not? You check
that from user-space and then use .rodata to turn off pieces of BPF
logic? That's quite inconvenient. It would be great if these typed
ksyms worked the same way as typeless ones:

extern const int bpf_link_fops3 __ksym __weak;

/* then in BPF program */

if (&bpf_link_fops3) {
   /* use bpf_link_fops3 */
}


I haven't tried, but I suspect it could be made to work if libbpf
replaces corresponding ldimm64 instruction (with BTF ID) into a plain
ldimm64 instruction loading 0 directly. That would allow the above
check (and it would be known false to the verifier) to succeed without
the verifier rejecting the BPF program. If actual use of non-existing
typed symbol is not guarded properly, verifier would see that register
is not PTR_TO_BTF_ID and wouldn't allow to use it for direct memory
reads or passing it to BPF helpers.

Have you considered such an approach?


Separately, please use ASSERT_XXX() macros for tests, not plain
CHECK()s. Thanks.

>
> Signed-off-by: Hao Luo <haoluo@google.com>
> ---
>  tools/lib/bpf/libbpf.c                        | 17 +++++-
>  .../selftests/bpf/prog_tests/ksyms_btf.c      | 42 +++++++++++++
>  .../selftests/bpf/progs/test_ksyms_weak.c     | 60 +++++++++++++++++++
>  3 files changed, 116 insertions(+), 3 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/progs/test_ksyms_weak.c
>

[...]
