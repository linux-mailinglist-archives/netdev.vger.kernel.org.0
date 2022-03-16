Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 677E04DA958
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 05:34:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353536AbiCPEfF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 00:35:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353548AbiCPEex (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 00:34:53 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C71585F8F5;
        Tue, 15 Mar 2022 21:33:34 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id r11so1077983ioh.10;
        Tue, 15 Mar 2022 21:33:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rv8XGfo8/J8apTUMt+aR8vPgcR2lwR8ezZGt/y9vbe0=;
        b=IlygeSPAuIn014UP51rg6bdwGddKOrVWzdwGqOEwoWVfl0i2BY7RsBk4oVkpYUSlGm
         nK76Glbck9Q4XtUyPmjflrQdUCMYHpX3svgANUIrmLdLbRQJ8ajJSC82rGn9VgfYZxTL
         VkOZFUksFxvWOe6DZBqOVp/kJTCPVkSfe1QcX/O55qzNcheFhZfA6Es2b/vxwuMmJ0p3
         LiIbqKDiOliGCbaeVilSMc/b1u3zSDT/PI0ffPOmkh3qtXbBQJRktk2iy1620caF9RzX
         oQocS0kxQxtrFz2fCg9pkiVIzPZ5jG3crSnjC5nbfSsMO648g0CQM0F13w+GCWAd5iry
         hIBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rv8XGfo8/J8apTUMt+aR8vPgcR2lwR8ezZGt/y9vbe0=;
        b=AyeC8bV9K5EJr3sxdUFWKfv9CsPpbROgRe3LJXzfEubN3SXBYYpohJiKzeSnhkTvTj
         SJRz3VEVmT/S3crLmb9v6b76ioj9dOkbcbp+R6lJo/XqS7eFit+I5k4bEeaFq/LbWQCS
         l/bfzvCgewZ0jRtOrLyPmeHiOTAEIVHSsDJi921xuh+0L7KRl7VPVQHns0zpJ159YGs0
         kRKPLhjr/iFZQkkA667mQwUODjTCX0JcHlTvcX/PM+u/044GS3DArR65zlsNkdHbF4UJ
         MrbG5xvUq/TEybP0mJikUZX0S7OIix5DtzBmCDN1qLF/YENbgbGYBNiL920N4Tw4+POY
         4s1A==
X-Gm-Message-State: AOAM531bLLcDOb8iOR8ONPhNHMJawNVBA95Tq2ALO7kJ4xN3fHyYwB84
        wxVU5D+sQygiSi4ToRnaNQ96tbGjbJMLkq3ZM3U=
X-Google-Smtp-Source: ABdhPJxhhX8Og2z3+3Rb4KBLEHxfKyvRW6OdgjizjLlOhLk0g4jz2x2AxALX1T2E/sPHtyHxUbCDfD+kJTbora+JkuY=
X-Received: by 2002:a5d:948a:0:b0:645:b742:87c0 with SMTP id
 v10-20020a5d948a000000b00645b74287c0mr23081823ioj.79.1647405214090; Tue, 15
 Mar 2022 21:33:34 -0700 (PDT)
MIME-Version: 1.0
References: <1647000658-16149-1-git-send-email-alan.maguire@oracle.com> <1647000658-16149-5-git-send-email-alan.maguire@oracle.com>
In-Reply-To: <1647000658-16149-5-git-send-email-alan.maguire@oracle.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 15 Mar 2022 21:33:23 -0700
Message-ID: <CAEf4BzZuZukTfaD6tB8wRf_iNdxewcGc5GACennEh=CVadeQ4w@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 4/5] selftests/bpf: add tests for u[ret]probe
 attach by name
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Yucong Sun <sunyucong@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 11, 2022 at 4:11 AM Alan Maguire <alan.maguire@oracle.com> wrote:
>
> add tests that verify attaching by name for
>
> 1. local functions in a program
> 2. library functions in a shared object; and
> 3. library functions in a program
>
> ...succeed for uprobe and uretprobes using new "func_name"
> option for bpf_program__attach_uprobe_opts().  Also verify
> auto-attach works where uprobe, path to binary and function
> name are specified, but fails with -EOPNOTSUPP when the format
> does not match (the latter is to support backwards-compatibility).
>
> Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> ---
>  .../selftests/bpf/prog_tests/attach_probe.c        | 89 ++++++++++++++++++----
>  .../selftests/bpf/progs/test_attach_probe.c        | 37 +++++++++
>  2 files changed, 113 insertions(+), 13 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/attach_probe.c b/tools/testing/selftests/bpf/prog_tests/attach_probe.c
> index d48f6e5..b770e0e 100644
> --- a/tools/testing/selftests/bpf/prog_tests/attach_probe.c
> +++ b/tools/testing/selftests/bpf/prog_tests/attach_probe.c
> @@ -11,15 +11,22 @@ static void trigger_func(void)
>         asm volatile ("");
>  }
>
> +/* attach point for byname uprobe */
> +static void trigger_func2(void)
> +{
> +       asm volatile ("");
> +}
> +
>  void test_attach_probe(void)
>  {
>         DECLARE_LIBBPF_OPTS(bpf_uprobe_opts, uprobe_opts);
> -       int duration = 0;
>         struct bpf_link *kprobe_link, *kretprobe_link;
>         struct bpf_link *uprobe_link, *uretprobe_link;
>         struct test_attach_probe* skel;
>         ssize_t uprobe_offset, ref_ctr_offset;
> +       struct bpf_link *uprobe_err_link;
>         bool legacy;
> +       char *mem;
>
>         /* Check if new-style kprobe/uprobe API is supported.
>          * Kernels that support new FD-based kprobe and uprobe BPF attachment

[...]

> -       if (CHECK(skel->bss->uprobe_res != 3, "check_uprobe_res",
> -                 "wrong uprobe res: %d\n", skel->bss->uprobe_res))
> +       /* trigger & validate uprobe attached by name */
> +       trigger_func2();
> +
> +       if (!ASSERT_EQ(skel->bss->kprobe_res, 1, "check_kprobe_res"))
> +               goto cleanup;
> +       if (!ASSERT_EQ(skel->bss->kretprobe_res, 2, "check_kretprobe_res"))
> +               goto cleanup;
> +       if (!ASSERT_EQ(skel->bss->uprobe_res, 3, "check_uprobe_res"))
> +               goto cleanup;
> +       if (!ASSERT_EQ(skel->bss->uretprobe_res, 4, "check_uretprobe_res"))
> +               goto cleanup;
> +       if (!ASSERT_EQ(skel->bss->uprobe_byname_res, 5, "check_uprobe_byname_res"))
> +               goto cleanup;
> +       if (!ASSERT_EQ(skel->bss->uretprobe_byname_res, 6, "check_uretprobe_byname_res"))
> +               goto cleanup;
> +       if (!ASSERT_EQ(skel->bss->uprobe_byname2_res, 7, "check_uprobe_byname2_res"))
>                 goto cleanup;

no need for all those goto cleanup. Just do unconditional ASSERT_EQ(),
it doesn't hurt and is much cleaner.

> -       if (CHECK(skel->bss->uretprobe_res != 4, "check_uretprobe_res",
> -                 "wrong uretprobe res: %d\n", skel->bss->uretprobe_res))
> +       if (!ASSERT_EQ(skel->bss->uretprobe_byname2_res, 8, "check_uretprobe_byname2_res"))
>                 goto cleanup;
>
>  cleanup:

[...]
