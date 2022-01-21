Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CC67496459
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 18:44:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351799AbiAURoB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 12:44:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241855AbiAURoA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 12:44:00 -0500
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 327F7C06173B;
        Fri, 21 Jan 2022 09:44:00 -0800 (PST)
Received: by mail-il1-x12f.google.com with SMTP id a18so8259724ilq.6;
        Fri, 21 Jan 2022 09:44:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GplninHFlFzbdqdmhzEeftSSvF4HoGpCbqikRsKn7lI=;
        b=fDGGlBxRKn+5WGJxDyN3rutp/mIXh9hhsqeSIOwnGZU1JLU2kDiRJUsmONuxsCLb4i
         wHqTDJMS3yUARe+gneSsWBYW8ALF4M4Fwe6N6ff9kpJRQLbBjwqUax/DpVtvNcM1Hu8h
         n9DYOoRSLbS5KUugfMwvZCqqU3PSfwt1ie5ODaDAyvI9fmlV3A+Buz8/loixBb6jvtdQ
         0H4xY9mWEcH5+sjE6Ufaad1+0debx0v842frjcnhEfb83hCmrSXETKfe63uGsoHqLl3X
         qe7lIrDUjkK24YqjXkdMc8wL0mE2vIpeSVjmu27RWA3qxqULJz7ou5E5xF3/0bIkyH6J
         jkuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GplninHFlFzbdqdmhzEeftSSvF4HoGpCbqikRsKn7lI=;
        b=xZScQC9nirVBHNfVaW3j8k0PIBlyFJwYNwwZKaI2iiZdnvke+Os1U783OaQ5+WcbL8
         4UU7ZKuife/he7D9PsXp2Q7ZrEV/ECZHQgVIlGlmG1hUn8vO7V90Cu2FW2Qoto6Cv3bH
         ChvQWez76IN4vG1PrhFmmSbnUPupAoIwW3r850VMqrfDfQPwMsFXgkSXrj1QZk+EfEUX
         h9UvV73gmeGCYF7dd+pIPaobgS9bjGThpkm017fSxE187zdubFT4YWq0FDHsnucN8IZz
         omf3ldqzbZlRoprTCeGyeknApCZIAjwzWqwq8EZAkiHb1XYd+pPdrFBhs0cOl1LF9uyN
         PKFQ==
X-Gm-Message-State: AOAM532L9U0v3YJ9dJXjfEASkN8keX0T8Zp+i/P/BusI5WN+Jbjq1q2Z
        RosT+b2XLWg+jSzqMRJ0+dnDABrJGsDvNODxz0Q=
X-Google-Smtp-Source: ABdhPJwKF9Es+QvYMsOg1HDRktr99HnixuopglqMv4SgU1P3z2cKC41omoQWPinM+sihiXNf+Eu6TF7aAUiCsM2eH2g=
X-Received: by 2002:a05:6e02:190e:: with SMTP id w14mr1997765ilu.71.1642787039545;
 Fri, 21 Jan 2022 09:43:59 -0800 (PST)
MIME-Version: 1.0
References: <20220121135632.136976-1-houtao1@huawei.com> <20220121135632.136976-2-houtao1@huawei.com>
In-Reply-To: <20220121135632.136976-2-houtao1@huawei.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 21 Jan 2022 09:43:48 -0800
Message-ID: <CAEf4BzYUWzf6gL0xeixucFskV+6dcd+R0WkAeV76=nr1bDLyzQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] selftests/bpf: use raw_tp program for atomic test
To:     Hou Tao <houtao1@huawei.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        "David S . Miller" <davem@davemloft.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <jthierry@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 21, 2022 at 5:57 AM Hou Tao <houtao1@huawei.com> wrote:
>
> Now atomic tests will attach fentry program and run it through
> bpf_prog_test_run(), but attaching fentry program depends on bpf
> trampoline which is only available under x86-64. Considering many
> archs have atomic support, using raw_tp program instead.
>
> Signed-off-by: Hou Tao <houtao1@huawei.com>
> ---

Nits about using generic ASSERT_TRUE instead of dedicated ASSERT_OK
checks, but otherwise LGTM

Acked-by: Andrii Nakryiko <andrii@kernel.org>


>  .../selftests/bpf/prog_tests/atomics.c        | 114 +++++-------------
>  tools/testing/selftests/bpf/progs/atomics.c   |  29 ++---
>  2 files changed, 44 insertions(+), 99 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/atomics.c b/tools/testing/selftests/bpf/prog_tests/atomics.c
> index 86b7d5d84eec..0de292c1ec02 100644
> --- a/tools/testing/selftests/bpf/prog_tests/atomics.c
> +++ b/tools/testing/selftests/bpf/prog_tests/atomics.c
> @@ -8,18 +8,13 @@ static void test_add(struct atomics_lskel *skel)
>  {
>         int err, prog_fd;
>         __u32 duration = 0, retval;
> -       int link_fd;
> -
> -       link_fd = atomics_lskel__add__attach(skel);
> -       if (!ASSERT_GT(link_fd, 0, "attach(add)"))
> -               return;
>
> +       /* No need to attach it, just run it directly */
>         prog_fd = skel->progs.add.prog_fd;
> -       err = bpf_prog_test_run(prog_fd, 1, NULL, 0,
> +       err = bpf_prog_test_run(prog_fd, 0, NULL, 0,
>                                 NULL, NULL, &retval, &duration);
> -       if (CHECK(err || retval, "test_run add",
> -                 "err %d errno %d retval %d duration %d\n", err, errno, retval, duration))
> -               goto cleanup;
> +       if (!ASSERT_TRUE(!err && !retval, "test_run add"))

please do this as two separate asserts: ASSERT_OK(err) and ASSERT_OK(retval)

> +               return;
>
>         ASSERT_EQ(skel->data->add64_value, 3, "add64_value");
>         ASSERT_EQ(skel->bss->add64_result, 1, "add64_result");
> @@ -31,28 +26,19 @@ static void test_add(struct atomics_lskel *skel)
>         ASSERT_EQ(skel->bss->add_stack_result, 1, "add_stack_result");
>
>         ASSERT_EQ(skel->data->add_noreturn_value, 3, "add_noreturn_value");
> -
> -cleanup:
> -       close(link_fd);
>  }
>
>  static void test_sub(struct atomics_lskel *skel)
>  {
>         int err, prog_fd;
>         __u32 duration = 0, retval;
> -       int link_fd;
> -
> -       link_fd = atomics_lskel__sub__attach(skel);
> -       if (!ASSERT_GT(link_fd, 0, "attach(sub)"))
> -               return;
>
> +       /* No need to attach it, just run it directly */
>         prog_fd = skel->progs.sub.prog_fd;
> -       err = bpf_prog_test_run(prog_fd, 1, NULL, 0,
> +       err = bpf_prog_test_run(prog_fd, 0, NULL, 0,
>                                 NULL, NULL, &retval, &duration);
> -       if (CHECK(err || retval, "test_run sub",
> -                 "err %d errno %d retval %d duration %d\n",
> -                 err, errno, retval, duration))
> -               goto cleanup;
> +       if (!ASSERT_TRUE(!err && !retval, "test_run sub"))

same as above, same below for all the CHECKs replaced with ASSERT_TRUE

> +               return;
>
>         ASSERT_EQ(skel->data->sub64_value, -1, "sub64_value");
>         ASSERT_EQ(skel->bss->sub64_result, 1, "sub64_result");
> @@ -64,27 +50,19 @@ static void test_sub(struct atomics_lskel *skel)
>         ASSERT_EQ(skel->bss->sub_stack_result, 1, "sub_stack_result");
>
>         ASSERT_EQ(skel->data->sub_noreturn_value, -1, "sub_noreturn_value");
> -
> -cleanup:
> -       close(link_fd);
>  }
>

[...]
