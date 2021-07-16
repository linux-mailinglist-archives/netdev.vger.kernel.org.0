Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BCB33CB1BD
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 06:54:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232649AbhGPE5F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 00:57:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbhGPE5E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 00:57:04 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09664C06175F;
        Thu, 15 Jul 2021 21:54:09 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id v189so12872274ybg.3;
        Thu, 15 Jul 2021 21:54:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rQzix+JFYmfW/cepcI4Z8ROSEcKPRKu53+WeoqkDB7A=;
        b=jwefsGN2q3DMczJLbwqAjnfzjHEHa+7foEN6u4d0o+x+dLX6z5C5DJTjOIq61znv1e
         nVbrL/7csPQwxRKBvA8T62c8AqnUHH3OQ5geAtgYhkpMgEbblfVYiAGEz4nf/a8djYW0
         FALLZ+nBBqb+dJdGp4ffvY9si5KCyXXHITXs7qktzWLpDvOPJP11bEvExB2zkOU5otya
         9kB7wIqxcmQNoovVh4PguWVk/nTwiF3x1PpUObw4FMPY+iIgqF0r+LosGfvr3g0mSBEV
         OSawvw3QW/dSA33Z5K2zA8QZDapU5vplUfyP144Le+h/3+WSRDPFFnh0jJR7K3o+wI7n
         7PdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rQzix+JFYmfW/cepcI4Z8ROSEcKPRKu53+WeoqkDB7A=;
        b=jni9f/+WyR//G+F2p+28Uyv6o8DKEq8jFD1Md71YI3HL1/KblfVL+a5+B8HxvgYKLS
         OG63Y4/BnFZcyAixpWx3y+i13o2yAwab6YxceJT8GSsGYoXXpm7mgjzZ7a0mSsaSIix4
         mCnj0GS56jmHooGq1XwJ2MaJomZpTGyXtD5qgHrA8cqO5LeorHEVRuQTz7b5obce65ra
         cLITfxjO5UfusW+Ym2S2EmNVFqEqRtzjTMM0PvNyj4551xtOdw9QX3x5gOdeeW5avoz/
         UlcMxqG/M7jF+BiSvAYiOYPmbW1IH/nHRsDfY4p6B2CPI7zVmc8HL4swcytCzwPHBHlS
         2ItA==
X-Gm-Message-State: AOAM531mTOYVB3AEHgBP+7EUBSxKokXsPFPQ1J0EGUIGolSKUTqRd4H3
        u0e/C7WTx4uqNK1ZcCjnu05DzH++U0Py57Iwz98=
X-Google-Smtp-Source: ABdhPJzxj03IKaFa2qBgy45NtGwiSCFknimKCkKQAgrRypH9ACZQrA7xbGpcnh6EO3VGHtqS5jpn+5b6b7HNLZ2eOf8=
X-Received: by 2002:a25:d349:: with SMTP id e70mr10212952ybf.510.1626411248254;
 Thu, 15 Jul 2021 21:54:08 -0700 (PDT)
MIME-Version: 1.0
References: <1626180159-112996-1-git-send-email-chengshuyi@linux.alibaba.com> <1626180159-112996-4-git-send-email-chengshuyi@linux.alibaba.com>
In-Reply-To: <1626180159-112996-4-git-send-email-chengshuyi@linux.alibaba.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 15 Jul 2021 21:53:57 -0700
Message-ID: <CAEf4BzZY6WeSmox6zwxM1-jfWkaomK-3R4+W6M4tg5J=Ti9ARQ@mail.gmail.com>
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
> diff --git a/tools/testing/selftests/bpf/prog_tests/core_autosize.c b/tools/testing/selftests/bpf/prog_tests/core_autosize.c
> index 981c251..d163342 100644
> --- a/tools/testing/selftests/bpf/prog_tests/core_autosize.c
> +++ b/tools/testing/selftests/bpf/prog_tests/core_autosize.c
> @@ -54,7 +54,7 @@ void test_core_autosize(void)
>         int err, fd = -1, zero = 0;
>         int char_id, short_id, int_id, long_long_id, void_ptr_id, id;
>         struct test_core_autosize* skel = NULL;
> -       struct bpf_object_load_attr load_attr = {};
> +       struct bpf_object_open_opts open_opts = {};
>         struct bpf_program *prog;
>         struct bpf_map *bss_map;
>         struct btf *btf = NULL;
> @@ -125,9 +125,11 @@ void test_core_autosize(void)
>         fd = -1;
>
>         /* open and load BPF program with custom BTF as the kernel BTF */
> -       skel = test_core_autosize__open();
> +       open_opts.btf_custom_path = btf_file;
> +       open_opts.sz = sizeof(struct bpf_object_open_opts);
> +       skel = test_core_autosize__open_opts(&open_opts);
>         if (!ASSERT_OK_PTR(skel, "skel_open"))
> -               return;
> +               goto cleanup;
>
>         /* disable handle_signed() for now */
>         prog = bpf_object__find_program_by_name(skel->obj, "handle_signed");
> @@ -135,9 +137,7 @@ void test_core_autosize(void)
>                 goto cleanup;
>         bpf_program__set_autoload(prog, false);
>
> -       load_attr.obj = skel->obj;
> -       load_attr.target_btf_path = btf_file;
> -       err = bpf_object__load_xattr(&load_attr);
> +       err = bpf_object__load(skel->obj);
>         if (!ASSERT_OK(err, "prog_load"))
>                 goto cleanup;
>
> @@ -204,13 +204,13 @@ void test_core_autosize(void)
>         skel = NULL;
>
>         /* now re-load with handle_signed() enabled, it should fail loading */
> -       skel = test_core_autosize__open();
> +       open_opts.btf_custom_path = btf_file;
> +       open_opts.sz = sizeof(struct bpf_object_open_opts);

For opts structs libbpf provides DECLARE_LIBBPF_OPTS macro for their
initialization which zeroes the struct out and sets its sz
automatically. So I'll switch to using that instead. All the rest
looks good.

> +       skel = test_core_autosize__open_opts(&opts);
>         if (!ASSERT_OK_PTR(skel, "skel_open"))
> -               return;
> +               goto cleanup;
>
> -       load_attr.obj = skel->obj;
> -       load_attr.target_btf_path = btf_file;
> -       err = bpf_object__load_xattr(&load_attr);
> +       err = bpf_object__load(skel);
>         if (!ASSERT_ERR(err, "bad_prog_load"))
>                 goto cleanup;
>

[...]
