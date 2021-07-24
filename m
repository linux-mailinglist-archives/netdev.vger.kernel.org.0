Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A533E3D43EB
	for <lists+netdev@lfdr.de>; Sat, 24 Jul 2021 02:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233366AbhGWXmx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 19:42:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232724AbhGWXmw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 19:42:52 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4970C061575;
        Fri, 23 Jul 2021 17:23:19 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id g76so4919738ybf.4;
        Fri, 23 Jul 2021 17:23:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6P0/lMSGus5x8nH6Sli5eLn7UASCS6seLf/0GYYIIIQ=;
        b=ECV2a2SC5urxzIS3v6v26Xqsu47wPplQLVDFny4RLSnPkXcaPBk8LKPT/2thdq/naZ
         Uep9ZNiG2ucSuQs5bBYH34AJe0JMv36D0NC6C9ho31dGbfhE0oD/VHx71Jue6SGl76AG
         Aoe9cHm6mbB0DG6ioKNIboAKoZv/4rb2gg5v2zlIRM0CjCv7FuzVPQXxmkpfhmoRLuTJ
         QUHZtbFOnchD0C6WtGeQKhQwB9oTEoHtA7rBc8/nJiQAqanIXkSdxmXSWoK7RnfdFRwa
         WFTSZV23IYWEZLYf7AiowPYuvnaoyx/YowehRGxvsKrlMxiUUnh0TG3fFWCXQcSjxaTv
         UL5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6P0/lMSGus5x8nH6Sli5eLn7UASCS6seLf/0GYYIIIQ=;
        b=C8AF4sxLx4d5QYPiEGFxTI25/4wwZJWT9f8u64A5rvoiVEt0gJxJqfOG7u5Nhtub+a
         NE/Bb0FDuuoIO2n5JOJnFBAH1Ek1Miyr5qAfu5wjchSmN871en3YWDKhYU0l3DLZQ1Xv
         Mszu/qXqckmLi9SG0DWJ7bb0TQqNufDS/WLPbNlI4OrI9nH7yAbS8NwF8JmkImRcGBzC
         Ryavmw45vhud1w4ssEqCRZ7PnQUDWqssrrfGZIEys7oE40cSG0veiS5QAZtWy+NAfTiF
         4oKoinU6yAymKIoMwnuBs9GgR6couNdQWFSHVx+0EPtZlcsg+foGA3CoQ0+ieUFetEWT
         5Erw==
X-Gm-Message-State: AOAM533QHPXkyJXyN6gGCMWtNH61TM9N0t2axbdFAIbF2lyzId6QmOPy
        bKnpHKNRtgG8v13EpnCdX/R6It3D2XIZZREFQwU=
X-Google-Smtp-Source: ABdhPJzLBWErQKPH4YlLQ60mdUkOxchsyK7uTYbYXD0tuFfyDNsX6LyiiKZ6xLL30tWWmXBclI6JE3pH3lfSePFe1So=
X-Received: by 2002:a25:b741:: with SMTP id e1mr9675263ybm.347.1627086198839;
 Fri, 23 Jul 2021 17:23:18 -0700 (PDT)
MIME-Version: 1.0
References: <20210721103822.3755111-1-johan.almbladh@anyfinetworks.com>
In-Reply-To: <20210721103822.3755111-1-johan.almbladh@anyfinetworks.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 23 Jul 2021 17:23:07 -0700
Message-ID: <CAEf4BzbchK6-4qtqnXqiAKeb=hmnJkw7UCTb4fVA67DUnRg5zA@mail.gmail.com>
Subject: Re: [PATCH] bpf/tests: do not PASS tests without actually testing the result
To:     Johan Almbladh <johan.almbladh@anyfinetworks.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Tony Ambardar <Tony.Ambardar@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 21, 2021 at 3:39 AM Johan Almbladh
<johan.almbladh@anyfinetworks.com> wrote:
>
> Each test case can have a set of sub-tests, where each sub-test can
> run the cBPF/eBPF test snippet with its own data_size and expected
> result. Before, the end of the sub-test array was indicated by both
> data_size and result being zero. However, most or all of the internal
> eBPF tests has a data_size of zero already. When such a test also had
> an expected value of zero, the test was never run but reported as
> PASS anyway.
>
> Now the test runner always runs the first sub-test, regardless of the
> data_size and result values. The sub-test array zero-termination only
> applies for any additional sub-tests.
>
> There are other ways fix it of course, but this solution at least
> removes the surprise of eBPF tests with a zero result always succeeding.
>
> Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
> ---
>  lib/test_bpf.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/lib/test_bpf.c b/lib/test_bpf.c
> index d500320778c7..baff847a02da 100644
> --- a/lib/test_bpf.c
> +++ b/lib/test_bpf.c
> @@ -6659,7 +6659,14 @@ static int run_one(const struct bpf_prog *fp, struct bpf_test *test)
>                 u64 duration;
>                 u32 ret;
>
> -               if (test->test[i].data_size == 0 &&
> +               /*
> +                * NOTE: Several sub-tests may be present, in which case
> +                * a zero {data_size, result} tuple indicates the end of
> +                * the sub-test array. The first test is always run,
> +                * even if both data_size and result happen to be zero.
> +                */
> +               if (i > 0 &&

This feels pretty arbitrary, of course, but I don't see how to improve
this easily without tons of code churn for each test specification.
Applied to bpf-next, thanks!

> +                   test->test[i].data_size == 0 &&
>                     test->test[i].result == 0)
>                         break;
>
> --
> 2.25.1
>
