Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 237923CBDC7
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 22:27:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234034AbhGPUaj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 16:30:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230256AbhGPUa3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 16:30:29 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EC0CC06175F;
        Fri, 16 Jul 2021 13:27:30 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id g5so16800081ybu.10;
        Fri, 16 Jul 2021 13:27:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Fuja+LyNz+8bpE28EdXAb+X5z2zGCSBcQGCKwS58Tz4=;
        b=Gh+Kd3/+WYGpUVk+HIfN2I4zqP+p+4dODDCEr6d0hurdj/g4oYMkTwkHg0e4SPaFwO
         0hYlEE1FjFinPJEfgkPd6929XgCQyUbUBUljhyBikELYjMUsphbDc5gen96bpJh8m4en
         5aPywQXZsKMWK36ViJheRfj/EZO5Aww6E3TJF7zPzvS4dcYTdHRc06lMT0b+3CjW+Kgp
         wPyaW3d+xTemRxlk78BbxYl15nOh1U09ZZX5bkdYr0hPAIrGpac05fTppSPAA6Hn4nNZ
         DxSoSSZKmWl0j5nVg4l/2y32vMvU+1Iu9qBgkjFD18PGr+c8GW1WidcQiCI/PMpmSe+1
         +u0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Fuja+LyNz+8bpE28EdXAb+X5z2zGCSBcQGCKwS58Tz4=;
        b=hR8rB5X79IpZVMG3j7EOHoGNAib5v6qYoCcI/m59ecuzymrtmY1REH4a16kl4Z1zJ1
         L/7j2/04C5+4Kqa6s5E+B5HcAuAkjNncHYe+OemXzPkKz/fvqGJrADaK9TdzvbrWiXSX
         Jl6kBHsmG46FTcyUzhttUOv0CRpMFzGIEQNdxQBOURafsbWmwftg2oHqhlk1PEoZ3+ax
         bhvBG5DLKCQvcw96MOyFyvuBt1BI45xTShOYuA9uUHVaShqNZd/z2+foK25wWd91NTHI
         9qg8HGAuo9yLSO9BFGISCmT+BY0b1Lzn3HWr7mRti6iyAZEJW6r/neMRFWAiVuM2qCPz
         D+tQ==
X-Gm-Message-State: AOAM531RSN4YKjcJgjrEH0GKrclxXTgy53rBBp+Rooex+FvIRxt1MJ9j
        hWTxc7fdZBbsphqOIUtmQnanmARLMOj+3MkASw8=
X-Google-Smtp-Source: ABdhPJyUar9OhEg8ZRbxdS4XlvJr4AOPjGqSaRDmC4wjGHyigeraHB9lCC8nqZwMKvvPhJGp0q1sd34p109m5GBxYEg=
X-Received: by 2002:a25:3787:: with SMTP id e129mr14598431yba.459.1626467249385;
 Fri, 16 Jul 2021 13:27:29 -0700 (PDT)
MIME-Version: 1.0
References: <1626180159-112996-1-git-send-email-chengshuyi@linux.alibaba.com> <1626180159-112996-4-git-send-email-chengshuyi@linux.alibaba.com>
In-Reply-To: <1626180159-112996-4-git-send-email-chengshuyi@linux.alibaba.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 16 Jul 2021 13:27:18 -0700
Message-ID: <CAEf4Bza3X410=1ryu4xZ+5ST2=69CB9BDusBrLMX=VSsXtnuDQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 3/3] selftests/bpf: Switches existing
 selftests to using open_opts for custom BTF
To:     Shuyi Cheng <chengshuyi@linux.alibaba.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 13, 2021 at 5:43 AM Shuyi Cheng
<chengshuyi@linux.alibaba.com> wrote:
>
> This patch mainly replaces the bpf_object_load_attr of
> the core_autosize.c and core_reloc.c files with bpf_object_open_opts.
>
> Signed-off-by: Shuyi Cheng <chengshuyi@linux.alibaba.com>
> ---
>  .../selftests/bpf/prog_tests/core_autosize.c       | 22 ++++++++---------
>  .../testing/selftests/bpf/prog_tests/core_reloc.c  | 28 ++++++++++------------
>  2 files changed, 24 insertions(+), 26 deletions(-)
>

So I applied this, but it's obvious you haven't bothered even
*building* selftests, because it had at least one compilation warning
and one compilation *error*, not building test_progs at all. I've
noted stuff I fixed (and still remember) below. I understand it might
be your first kernel contribution, but it's not acceptable to submit
patches that don't build. Next time please be more thorough.

[...]

>
> -       load_attr.obj = skel->obj;
> -       load_attr.target_btf_path = btf_file;
> -       err = bpf_object__load_xattr(&load_attr);
> +       err = bpf_object__load(skel);

This didn't compile outright, because it should have been
test_core_autosize__load(skel).

>         if (!ASSERT_ERR(err, "bad_prog_load"))
>                 goto cleanup;
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/core_reloc.c b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
> index d02e064..10eb2407 100644
> --- a/tools/testing/selftests/bpf/prog_tests/core_reloc.c
> +++ b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
> @@ -816,7 +816,7 @@ static size_t roundup_page(size_t sz)
>  void test_core_reloc(void)
>  {
>         const size_t mmap_sz = roundup_page(sizeof(struct data));
> -       struct bpf_object_load_attr load_attr = {};
> +       struct bpf_object_open_opts open_opts = {};
>         struct core_reloc_test_case *test_case;
>         const char *tp_name, *probe_name;
>         int err, i, equal;
> @@ -846,9 +846,17 @@ void test_core_reloc(void)
>                                 continue;
>                 }
>
> -               obj = bpf_object__open_file(test_case->bpf_obj_file, NULL);
> +               if (test_case->btf_src_file) {
> +                       err = access(test_case->btf_src_file, R_OK);
> +                       if (!ASSERT_OK(err, "btf_src_file"))
> +                               goto cleanup;
> +               }
> +
> +               open_opts.btf_custom_path = test_case->btf_src_file;

This was reporting a valid warning about dropping const modifier. For
good reason, becyase btf_custom_path in open_opts should have been
`const char *`, I fixed that.

> +               open_opts.sz = sizeof(struct bpf_object_open_opts);
> +               obj = bpf_object__open_file(test_case->bpf_obj_file, &open_opts);
>                 if (!ASSERT_OK_PTR(obj, "obj_open"))
> -                       continue;
> +                       goto cleanup;
>
>                 probe_name = "raw_tracepoint/sys_enter";
>                 tp_name = "sys_enter";

[...]
