Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A4933577F2
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 00:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbhDGWrw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 18:47:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbhDGWrw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 18:47:52 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35CF5C061760;
        Wed,  7 Apr 2021 15:47:42 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id g38so448035ybi.12;
        Wed, 07 Apr 2021 15:47:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/Kxh1SV1ZSpa4FNRiwzB13IqpmSzhNm8YEkJv11EKe8=;
        b=tc3FHhJvGT10Xqsvext8PxTxttgywVGxWCFVhq1QiQUWNAg2IxuAH6soW0fZtuMuiT
         +MRToFBbR1ik7WEgMNIbzmtucwgm4HWMG7HBwxK3jxv2ZtrLfHva5de+C8ztRQuGDVxd
         ZWAdZo7ZoCPUp2KNOOikmH0OlKme0y28YsIertRwDBpd/qHYrv9PBA14j4eDRk73VmcB
         y4g7cZXAYGt7J/oi1IaS/FarKeeZwgKqLQvng9G0+8u9nGD8F7QCLjtTmGIziCUa+heT
         dTnCQj8eHWQy4w1yAvtNk2z6fKKicz2HEhi+HsAkFhcQJ2Axp6D910kGP/k46xn1dqON
         vKnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/Kxh1SV1ZSpa4FNRiwzB13IqpmSzhNm8YEkJv11EKe8=;
        b=svGDcdQXphKwSxd9X8DnJXMJvhB1EuL8/3sAxeLf9NmUa3xs4aeWah8qP9UlbMw5N8
         ER3uVPskKiLcJDv0AL8HZTlxboyVKwuisi2nmiXV6ZlJQBFg1mgkSduKTBHHrSkm10ih
         af4khQpjWbsuEz35REYpNCjGxlHNYSxsxN1MALiES6ISvGP6j4h79dlS7nymUbjfOUXP
         BSA7+PySy0NVfViyqf6Pj8vpDEAGtuAOk9FNoTV+PknGEMQ+JxpIJhUDSzeu2wHxleFX
         Nmnc440dVcHWErY5iZxFGpGlNekvChkHWIfxb6YkmtagWnYVxSVjvImDW44oLgsXcMXo
         2OcA==
X-Gm-Message-State: AOAM532nnDJVp0yN98xQP2ErKSeOMbUU1Zs85Ao6n1mLzqBXxF/Jciv7
        ZPREfJ2XNq27tTWanWSKhhCtlf4c7J2AlCWxgqw=
X-Google-Smtp-Source: ABdhPJwvg/RtqIBRAlXu7XTf/+YgSy2PgQmO1wpp+uVI6PSTwbwWCSI2D9qPz9mnrMdTiTHTt0OJIp7QFCond0k6Nhg=
X-Received: by 2002:a05:6902:6a3:: with SMTP id j3mr7486243ybt.403.1617835661574;
 Wed, 07 Apr 2021 15:47:41 -0700 (PDT)
MIME-Version: 1.0
References: <20210406212913.970917-1-jolsa@kernel.org> <20210406212913.970917-3-jolsa@kernel.org>
In-Reply-To: <20210406212913.970917-3-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 7 Apr 2021 15:47:30 -0700
Message-ID: <CAEf4Bzagf5H31H8uSuMiVDpE5a6tgDOsZkJdmMK0hGhVDADRHQ@mail.gmail.com>
Subject: Re: [PATCHv2 bpf-next 2/5] selftests/bpf: Add re-attach test to fentry_test
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
> fentry programs, plus check that already linked program can't
> be attached again.
>
> Fixing the number of check-ed results, which should be 8.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  .../selftests/bpf/prog_tests/fentry_test.c    | 48 +++++++++++++++----
>  1 file changed, 38 insertions(+), 10 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/fentry_test.c b/tools/testing/selftests/bpf/prog_tests/fentry_test.c
> index 04ebbf1cb390..1f7566e772e9 100644
> --- a/tools/testing/selftests/bpf/prog_tests/fentry_test.c
> +++ b/tools/testing/selftests/bpf/prog_tests/fentry_test.c
> @@ -3,20 +3,24 @@
>  #include <test_progs.h>
>  #include "fentry_test.skel.h"
>
> -void test_fentry_test(void)
> +static __u32 duration;
> +
> +static int fentry_test(struct fentry_test *fentry_skel)
>  {
> -       struct fentry_test *fentry_skel = NULL;
> +       struct bpf_link *link;
>         int err, prog_fd, i;
> -       __u32 duration = 0, retval;
>         __u64 *result;
> -
> -       fentry_skel = fentry_test__open_and_load();
> -       if (CHECK(!fentry_skel, "fentry_skel_load", "fentry skeleton failed\n"))
> -               goto cleanup;
> +       __u32 retval;
>
>         err = fentry_test__attach(fentry_skel);
>         if (CHECK(err, "fentry_attach", "fentry attach failed: %d\n", err))
> -               goto cleanup;
> +               return err;
> +
> +       /* Check that already linked program can't be attached again. */
> +       link = bpf_program__attach(fentry_skel->progs.test1);
> +       if (CHECK(!IS_ERR(link), "fentry_attach_link",

if (!ASSERT_ERR_PTR(link, "fentry_attach_link")) ?

> +                 "re-attach without detach should not succeed"))
> +               return -1;
>
>         prog_fd = bpf_program__fd(fentry_skel->progs.test1);
>         err = bpf_prog_test_run(prog_fd, 1, NULL, 0,
> @@ -26,12 +30,36 @@ void test_fentry_test(void)
>               err, errno, retval, duration);
>
>         result = (__u64 *)fentry_skel->bss;
> -       for (i = 0; i < 6; i++) {
> +       for (i = 0; i < 8; i++) {

how about using sizeof(*fentry_skel->bss) / sizeof(__u64) ?

>                 if (CHECK(result[i] != 1, "result",
>                           "fentry_test%d failed err %lld\n", i + 1, result[i]))
> -                       goto cleanup;
> +                       return -1;
>         }
>
> +       fentry_test__detach(fentry_skel);
> +
> +       /* zero results for re-attach test */
> +       for (i = 0; i < 8; i++)
> +               result[i] = 0;
> +       return 0;
> +}
> +
> +void test_fentry_test(void)
> +{
> +       struct fentry_test *fentry_skel = NULL;
> +       int err;
> +
> +       fentry_skel = fentry_test__open_and_load();
> +       if (CHECK(!fentry_skel, "fentry_skel_load", "fentry skeleton failed\n"))
> +               goto cleanup;
> +
> +       err = fentry_test(fentry_skel);
> +       if (CHECK(err, "fentry_test", "first attach failed\n"))
> +               goto cleanup;
> +
> +       err = fentry_test(fentry_skel);
> +       CHECK(err, "fentry_test", "second attach failed\n");

overall: please try to use ASSERT_xxx macros, they are easier to
follow and require less typing
> +
>  cleanup:
>         fentry_test__destroy(fentry_skel);
>  }
> --
> 2.30.2
>
