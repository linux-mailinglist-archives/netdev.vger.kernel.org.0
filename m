Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8A4135E89B
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 23:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232382AbhDMV4F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 17:56:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231513AbhDMV4E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 17:56:04 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3657BC061574;
        Tue, 13 Apr 2021 14:55:44 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id k73so13541667ybf.3;
        Tue, 13 Apr 2021 14:55:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CLvG5HeMjtZ37C2UUsYYBj6Gwo07Pu8qUXpGumOhtTk=;
        b=iY5m2Vg56jo6vgnBWxMgg8mdNHTs/mJOEXpLHsf9vVaVr2IfC0jIlZw9IWEfU1uA/T
         ItCWj51LLEYfLXQiJ7qUv5xMuyu/nlLEyDvQK28WyQfT89h+iNlE3uCUSu8y0HytEZoL
         SnMc71KKsYGN1KU6FFq+oslQwZwMIQg7ixdmB1TdIr2uK86PH0ppB3Z+Dks/syJOdG0+
         PVT4NtxbtG5dBWSTpO5SwVicjKGPsRoNhWYCcqN2kQ87MPsAj4A+X8jBsH0ot9A9eBus
         mUlNfnMOy1EF4pUeymY/9vQrPSxzUkoG1FplHEbDZb/AvjZOpEBgHm463s79h21inlAL
         IsbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CLvG5HeMjtZ37C2UUsYYBj6Gwo07Pu8qUXpGumOhtTk=;
        b=FUndCPr0DBNhMQoGBD8JVkqE8eAYmnAl79QICGWQHp0qomHhr/ia9l1L1w1MSA260y
         Ain74vz//y5gBTk4gaz2s0tfOoatkC7bQ/T5o5lqxX0go/GW2hw2+pjemxeomwedmuiC
         A0KhtKT3lFBgemT6oWmbZXH22jdY4s3VmigYjOven9Der+pPGBW0F1BcvWg+OVEHqvdz
         9j/n/MSkdM6gcZ1rjNDfQhnaVq4DHsZ/i1eW/8AtlyMR7KxVUZZgghWqmjfx3JaM1Fc3
         3xy2GkEfWwOD9CLJd5d9cu/R6qh8bX3ckNkzmDctJWIYaZuv+jylcbHKSQkcCNKWx5LW
         VUSw==
X-Gm-Message-State: AOAM532twFnl7ZfJGjk5Ga4swx6N8UBCRqXRpl3UtGpwKnQ4wxefNTCf
        1CQMCaVr0ZONNxKkmScaeLF937GO98WuudFZVTw=
X-Google-Smtp-Source: ABdhPJxhAPUKwSxE9aEiCORKIs0j1QgfySaPxqlzRaGYJOhQzRq4UvPiH17Cmmfi2bKsZ0J+RHLtF5gRxYeQ8QJPRCA=
X-Received: by 2002:a25:3357:: with SMTP id z84mr38992221ybz.260.1618350943557;
 Tue, 13 Apr 2021 14:55:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210412162502.1417018-1-jolsa@kernel.org> <20210412162502.1417018-4-jolsa@kernel.org>
In-Reply-To: <20210412162502.1417018-4-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 13 Apr 2021 14:55:32 -0700
Message-ID: <CAEf4BzYv_9Sa5Sa25-9s-9Fxasn9OuoRfggyOT9JcDcfrCkhEQ@mail.gmail.com>
Subject: Re: [PATCHv4 bpf-next 3/5] selftests/bpf: Add re-attach test to fexit_test
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Julia Lawall <julia.lawall@inria.fr>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 12, 2021 at 9:30 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Adding the test to re-attach (detach/attach again) tracing
> fexit programs, plus check that already linked program can't
> be attached again.
>
> Also switching to ASSERT* macros.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  .../selftests/bpf/prog_tests/fexit_test.c     | 51 +++++++++++++------
>  1 file changed, 36 insertions(+), 15 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/fexit_test.c b/tools/testing/selftests/bpf/prog_tests/fexit_test.c
> index 78d7a2765c27..c48e10c138bc 100644
> --- a/tools/testing/selftests/bpf/prog_tests/fexit_test.c
> +++ b/tools/testing/selftests/bpf/prog_tests/fexit_test.c
> @@ -3,35 +3,56 @@
>  #include <test_progs.h>
>  #include "fexit_test.skel.h"
>
> -void test_fexit_test(void)
> +static int fexit_test(struct fexit_test *fexit_skel)
>  {
> -       struct fexit_test *fexit_skel = NULL;
>         int err, prog_fd, i;
>         __u32 duration = 0, retval;
> +       struct bpf_link *link;
>         __u64 *result;
>
> -       fexit_skel = fexit_test__open_and_load();
> -       if (CHECK(!fexit_skel, "fexit_skel_load", "fexit skeleton failed\n"))
> -               goto cleanup;
> -
>         err = fexit_test__attach(fexit_skel);
> -       if (CHECK(err, "fexit_attach", "fexit attach failed: %d\n", err))
> -               goto cleanup;
> +       if (!ASSERT_OK(err, "fexit_attach"))
> +               return err;
> +
> +       /* Check that already linked program can't be attached again. */
> +       link = bpf_program__attach(fexit_skel->progs.test1);
> +       if (!ASSERT_ERR_PTR(link, "fexit_attach_link"))
> +               return -1;
>
>         prog_fd = bpf_program__fd(fexit_skel->progs.test1);
>         err = bpf_prog_test_run(prog_fd, 1, NULL, 0,
>                                 NULL, NULL, &retval, &duration);
> -       CHECK(err || retval, "test_run",
> -             "err %d errno %d retval %d duration %d\n",
> -             err, errno, retval, duration);
> +       ASSERT_OK(err || retval, "test_run");

same as in previous patch

With this fixed, feel free to add my ack to this and previous patch. Thanks!

>
>         result = (__u64 *)fexit_skel->bss;
> -       for (i = 0; i < 6; i++) {
> -               if (CHECK(result[i] != 1, "result",
> -                         "fexit_test%d failed err %lld\n", i + 1, result[i]))
> -                       goto cleanup;
> +       for (i = 0; i < sizeof(*fexit_skel->bss) / sizeof(__u64); i++) {
> +               if (!ASSERT_EQ(result[i], 1, "fexit_result"))
> +                       return -1;
>         }
>
> +       fexit_test__detach(fexit_skel);
> +
> +       /* zero results for re-attach test */
> +       memset(fexit_skel->bss, 0, sizeof(*fexit_skel->bss));
> +       return 0;
> +}
> +
> +void test_fexit_test(void)
> +{
> +       struct fexit_test *fexit_skel = NULL;
> +       int err;
> +
> +       fexit_skel = fexit_test__open_and_load();
> +       if (!ASSERT_OK_PTR(fexit_skel, "fexit_skel_load"))
> +               goto cleanup;
> +
> +       err = fexit_test(fexit_skel);
> +       if (!ASSERT_OK(err, "fexit_first_attach"))
> +               goto cleanup;
> +
> +       err = fexit_test(fexit_skel);
> +       ASSERT_OK(err, "fexit_second_attach");
> +
>  cleanup:
>         fexit_test__destroy(fexit_skel);
>  }
> --
> 2.30.2
>
