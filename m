Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C4E5229171
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 08:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730325AbgGVG6A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 02:58:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727882AbgGVG6A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 02:58:00 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2653FC061794;
        Tue, 21 Jul 2020 23:58:00 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id u64so990183qka.12;
        Tue, 21 Jul 2020 23:58:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zjl8jyI4JNnQLeTVzyCzHh3c+nXxWye5Cj6ubPO13J0=;
        b=GEF78V2k9OiWRf81LyakVnVCsY+WdOadZDPh8XZnSjoWpqyVyHSBqYesBwcUVU6qn+
         A2GOiIMI7D4+BCo2X43tWNGsBUTQEV15+iF25xICpC6R75QeFwAJf9f7IL+FtnY2Ynco
         guWA3aOcbK99jE7qNpAW14da2xrh4F+sNJ+p9hT2QIbZMXkJ4Z6vapPJLeseMS20z5ki
         hH/T6IJ5Prf/pBvgnXtu03h5EckJP4dmb0vjt5PknVgmm/fm7KZtKVn5sTFZ/Ya5Ntf8
         37VXErV/NMpuNfETve3WI/+hiyztBgVpQioouREp/80KkRHIHv8x2KumKGBgXnqeSxCo
         Nzyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zjl8jyI4JNnQLeTVzyCzHh3c+nXxWye5Cj6ubPO13J0=;
        b=tWEXuWAdpbLMBpQzOm77gH8+wH6UhYMoYG5ti2dPAaFQeSJ92FUpSJKODboaFVxleZ
         uBMZeihMIEjvz81ovYPaQuZwusMsxvNTmMfV/6o3hP0tyLPrZqUhIAWP1SXo923xY69d
         29Wa3WCb4IC6HZmrTE8rQ+iXnQ+UDhWyqwUfAoDiS5Rosl1SOkAqQ2BnCaHNc2HVUFp+
         QBmoi9JepLVpIF1djjXiMWVUtyRR695g7yubl3/sqAMKkPqrTc9OlVNS48U3F6VKevks
         DARVF3f4YnS/xdp4Tj6EAA/0ccTJmvIM7ezNU5gg0R1+lnkBTWtaC8kfLpJmzoqpiB0T
         ti7A==
X-Gm-Message-State: AOAM5302ZnjhlvJAlgGB0G1ChHkUrox5OyUbMfp3aOyjGcGD8d0mMC5t
        umNiVZ9idx/Ml8rlFglA4ELyFhWGFFMu2UZjd10=
X-Google-Smtp-Source: ABdhPJyURO1mFslPp3J0AAImaBN2tPe38/iVgkWkY18Z1Rf8Lb/feerQVzkkSUH/emANzphylSQxhxBjLXImoOgFhNc=
X-Received: by 2002:a37:a655:: with SMTP id p82mr14245845qke.92.1595401079241;
 Tue, 21 Jul 2020 23:57:59 -0700 (PDT)
MIME-Version: 1.0
References: <20200722054314.2103880-1-irogers@google.com>
In-Reply-To: <20200722054314.2103880-1-irogers@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 21 Jul 2020 23:57:48 -0700
Message-ID: <CAEf4BzaBYaFJ3eUinS9nHeykJ0xEbZpwLts33ZDp1PT=bkyjww@mail.gmail.com>
Subject: Re: [RFC PATCH] bpftool btf: Add prefix option to dump C
To:     Ian Rogers <irogers@google.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 21, 2020 at 10:44 PM Ian Rogers <irogers@google.com> wrote:
>
> When bpftool dumps types and enum members into a header file for
> inclusion the names match those in the original source. If the same
> header file needs to be included in the original source and the bpf
> program, the names of structs, unions, typedefs and enum members will
> have naming collisions.

vmlinux.h is not really intended to be used from user-space, because
it's incompatible with pretty much any other header that declares any
type. Ideally we should make this better, but that might require some
compiler support. We've been discussing with Yonghong extending Clang
with a compile-time check for whether some type is defined or not,
which would allow to guard every type and only declare it
conditionally, if it's missing. But that's just an idea at this point.

Regardless, vmlinux.h is also very much Clang-specific, and shouldn't
work well with GCC. Could you elaborate on the specifics of the use
case you have in mind? That could help me see what might be the right
solution. Thanks!

>
> To avoid these collisions an approach is to redeclare the header file
> types and enum members, which leads to duplication and possible
> inconsistencies. Another approach is to use preprocessor macros
> to rename conflicting names, but this can be cumbersome if there are
> many conflicts.
>
> This patch adds a prefix option for the dumped names. Use of this option
> can avoid name conflicts and compile time errors.
>
> Signed-off-by: Ian Rogers <irogers@google.com>
> ---
>  .../bpf/bpftool/Documentation/bpftool-btf.rst |  7 ++++++-
>  tools/bpf/bpftool/btf.c                       | 18 ++++++++++++++---
>  tools/lib/bpf/btf.h                           |  1 +
>  tools/lib/bpf/btf_dump.c                      | 20 +++++++++++++------
>  4 files changed, 36 insertions(+), 10 deletions(-)
>

[...]

> diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
> index 491c7b41ffdc..fea4baab00bd 100644
> --- a/tools/lib/bpf/btf.h
> +++ b/tools/lib/bpf/btf.h
> @@ -117,6 +117,7 @@ struct btf_dump;
>
>  struct btf_dump_opts {
>         void *ctx;
> +       const char *name_prefix;
>  };

BTW, we can't do that, this breaks ABI. btf_dump_opts were added
before we understood the problem of backward/forward  compatibility of
libbpf APIs, unfortunately.

>
>  typedef void (*btf_dump_printf_fn_t)(void *ctx, const char *fmt, va_list args);
> diff --git a/tools/lib/bpf/btf_dump.c b/tools/lib/bpf/btf_dump.c
> index e1c344504cae..baf2b4d82e1e 100644
> --- a/tools/lib/bpf/btf_dump.c
> +++ b/tools/lib/bpf/btf_dump.c

[...]
