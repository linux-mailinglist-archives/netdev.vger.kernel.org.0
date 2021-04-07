Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 667AF357801
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 00:52:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbhDGWwL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 18:52:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbhDGWwK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 18:52:10 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B06DC061760;
        Wed,  7 Apr 2021 15:51:58 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id n12so479297ybf.8;
        Wed, 07 Apr 2021 15:51:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AvCKY6kTchBpneTfI6T8YSNqQ2pwQt7sPTsRbmVyKsQ=;
        b=eyZCciAP8Zi0ZyxpTsjxY174TWzXbN/AXWPk2DX0CCp861EEIpI/AwcjIaAjPaHxUz
         DFqXUkP7LYutjkuXS3iNgN//7V2jBpJ4/qtQ80+HY2ccL+IyBOahikdi89uhdyQWdL8U
         UfmLIP+3CnuGPE3gMiOJgg+/NjcUbJMH+wrNnRRpSzMGm5Da3ylN8Ia87tfjaOAhQj+l
         mrtfjvXK+OYQn1GcPTM5ZcS1kD1Yzptj62FpzzCpIEmXGvYPOhi6NdFdzk6vrkRedkDi
         6WxHIP7Fzp8oWQzdhQ2g8xxn9MtzC2qFVwwbMHotrUS3yiBeNs4GREdcBKpijmRytwnf
         SCGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AvCKY6kTchBpneTfI6T8YSNqQ2pwQt7sPTsRbmVyKsQ=;
        b=SQKTVQ7t/t5W9oZ9O7o3apeKVuVo8FKvwvqu0Y1k6YH+DD90h+qTthiV/Gqspf6Jew
         TWg6fhSUGAgGRnk5rSaUG4PCJny5QLzxbxprqcmjYDTWEcAyTFgH3MelMdt5ZGA4D98X
         4/mfTu/YT+DH+1y6tfHyNc2MiIPMD/FfPpEuGnphFBQdDP9JPz2I8uThTAUpjNSmuWSl
         iyWopMS5o9OxaqgwPqcv0U1vXculUq0gDoiNqKCCQT6apTKiEYdsggKmkuXyb9I4F4C3
         mLqLEALVFgWoy9B9Yo6kAgXB+R9Cu9VjL8OyekiUpfoWUrhOtZ8AXOsvtkVvBHUpWlCJ
         +8fg==
X-Gm-Message-State: AOAM533GvyN+/t3B0L4dDx7vF9dFAKAZroohgWuhU7Z/tA11YFOtdIL9
        1er1mPJHJBvhRGorJGZ0jCg9CmVFN3P+p0bancs=
X-Google-Smtp-Source: ABdhPJxixVwRidcUNcHPCAAeSqkpmvx5eKrWQeT9MHNhVmCPEuf0GVk8+Agj9bBRJh7y9cMLiCz/GBg6RGCYFEos8fc=
X-Received: by 2002:a25:9942:: with SMTP id n2mr7633465ybo.230.1617835917777;
 Wed, 07 Apr 2021 15:51:57 -0700 (PDT)
MIME-Version: 1.0
References: <20210406212913.970917-1-jolsa@kernel.org> <20210406212913.970917-4-jolsa@kernel.org>
In-Reply-To: <20210406212913.970917-4-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 7 Apr 2021 15:51:46 -0700
Message-ID: <CAEf4BzaHCkRm0nFLtWxOJCY5sAAEGYWvLZC+BAjhv4RijAp9oQ@mail.gmail.com>
Subject: Re: [PATCHv2 bpf-next 3/5] selftests/bpf: Add re-attach test to fexit_test
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 7, 2021 at 4:21 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Adding the test to re-attach (detach/attach again) tracing
> fexit programs, plus check that already linked program can't
> be attached again.
>
> Fixing the number of check-ed results, which should be 8.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  .../selftests/bpf/prog_tests/fexit_test.c     | 48 +++++++++++++++----
>  1 file changed, 38 insertions(+), 10 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/fexit_test.c b/tools/testing/selftests/bpf/prog_tests/fexit_test.c
> index 78d7a2765c27..579e620e6612 100644
> --- a/tools/testing/selftests/bpf/prog_tests/fexit_test.c
> +++ b/tools/testing/selftests/bpf/prog_tests/fexit_test.c
> @@ -3,20 +3,24 @@
>  #include <test_progs.h>
>  #include "fexit_test.skel.h"
>
> -void test_fexit_test(void)
> +static __u32 duration;
> +
> +static int fexit_test(struct fexit_test *fexit_skel)
>  {
> -       struct fexit_test *fexit_skel = NULL;
> +       struct bpf_link *link;
>         int err, prog_fd, i;
> -       __u32 duration = 0, retval;
>         __u64 *result;
> -
> -       fexit_skel = fexit_test__open_and_load();
> -       if (CHECK(!fexit_skel, "fexit_skel_load", "fexit skeleton failed\n"))
> -               goto cleanup;
> +       __u32 retval;
>
>         err = fexit_test__attach(fexit_skel);
>         if (CHECK(err, "fexit_attach", "fexit attach failed: %d\n", err))
> -               goto cleanup;
> +               return err;
> +
> +       /* Check that already linked program can't be attached again. */
> +       link = bpf_program__attach(fexit_skel->progs.test1);
> +       if (CHECK(!IS_ERR(link), "fexit_attach_link",
> +                 "re-attach without detach should not succeed"))
> +               return -1;
>
>         prog_fd = bpf_program__fd(fexit_skel->progs.test1);
>         err = bpf_prog_test_run(prog_fd, 1, NULL, 0,
> @@ -26,12 +30,36 @@ void test_fexit_test(void)
>               err, errno, retval, duration);
>
>         result = (__u64 *)fexit_skel->bss;
> -       for (i = 0; i < 6; i++) {
> +       for (i = 0; i < 8; i++) {
>                 if (CHECK(result[i] != 1, "result",
>                           "fexit_test%d failed err %lld\n", i + 1, result[i]))
> -                       goto cleanup;
> +                       return -1;
>         }
>
> +       fexit_test__detach(fexit_skel);
> +
> +       /* zero results for re-attach test */
> +       for (i = 0; i < 8; i++)
> +               result[i] = 0;

memset(fexit_skel->bss, 0, sizeof(*fexit_skel->bss)) ? ;)

and see my nits in previous patch about ASSERT over CHECK


> +       return 0;
> +}
> +
> +void test_fexit_test(void)
> +{
> +       struct fexit_test *fexit_skel = NULL;
> +       int err;
> +
> +       fexit_skel = fexit_test__open_and_load();
> +       if (CHECK(!fexit_skel, "fexit_skel_load", "fexit skeleton failed\n"))
> +               goto cleanup;
> +
> +       err = fexit_test(fexit_skel);
> +       if (CHECK(err, "fexit_test", "first attach failed\n"))
> +               goto cleanup;
> +
> +       err = fexit_test(fexit_skel);
> +       CHECK(err, "fexit_test", "second attach failed\n");
> +
>  cleanup:
>         fexit_test__destroy(fexit_skel);
>  }
> --
> 2.30.2
>
