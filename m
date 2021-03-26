Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31B8834A067
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 05:05:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229474AbhCZEFC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 00:05:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbhCZEE3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 00:04:29 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30E6BC06174A;
        Thu, 25 Mar 2021 21:04:29 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id w8so4575959ybt.3;
        Thu, 25 Mar 2021 21:04:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=8AdqmG6zvPrKyqz8WgSxRSQ7HTQM6BEnNij+Zal6OSQ=;
        b=rmPAXOCQ+vXvXHB/Gqt9LKk9O2iPWsroNoagzUuJWF0xl8U/IIYwMosDQ+qnza9Lea
         qDjRbv+tX30BB+mn+LGlysR0VcxkHZOjyo0lG8uUnElyPE+GUw5McoUxlUKGCvWgg96U
         F0PNtjDA8nGfriC/qQDcI1T4PbkNhURR2M0Aey6AoRjXxsDsshyPuBkJkqHBUifACW5J
         PZ2xCSPvgI4yrNSH2wqViXgeY2YRC/7tOElvY1MzSpsDJ7DJbvru2EqBKaAIqfMFBqFv
         Wse9qPpo1XZNhlzjuAX4rfWnRoaKxQ+DlwtyEC6lJQ2Csii9I0s1wvTKLhhUDM2JPqm0
         v8eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=8AdqmG6zvPrKyqz8WgSxRSQ7HTQM6BEnNij+Zal6OSQ=;
        b=qnDl602aVYxJFPyuWdve1RktSyiuY/4X3CJYwtWaGrW9ckRU+7vqlzS3/UaJkqzttC
         IKfKyZQa1Qe6402Hgde1dIaKnFWb4qDtJHs0VUOJE1dz88bJ3WCuAe6LzXIv0QXYOg1i
         /F+QJtf6ylgs7Bkh4tc2NDFpW8moTwv6rYJn1v977wx4lXREnlaBr20vb95VJUl7lKwm
         gUCNrYlZ7Co1WVsFXfFf82u8CslFpNO27G9VXmo1ky125qvJGM2HiyFwEk8uqup4Gn5z
         PGQdFzhsOj5qKK5MW5ZSbNF5mm3kxaUN10NnXj7G8FXpg1l3I/EeeyECvFr+TzCebizn
         b5mQ==
X-Gm-Message-State: AOAM533zTvmj4wslt5yzapjWNYySijojUCvBXuLTHt876sIlQt1rHxfK
        r9/4OpjHPMy1ygdM8fYjRT2S3gKYiLB/fBL1ZgQ=
X-Google-Smtp-Source: ABdhPJyYufYKgdc8L/wqfTVcfh4qLCnrG3PJtBwO6kl0TIhfgcixSsVDFluh8Jj09J0lzNE6CviC6Q9MSxYZyuQBqRA=
X-Received: by 2002:a25:9942:: with SMTP id n2mr16401642ybo.230.1616731468370;
 Thu, 25 Mar 2021 21:04:28 -0700 (PDT)
MIME-Version: 1.0
References: <20210325211122.98620-1-toke@redhat.com> <20210325211122.98620-2-toke@redhat.com>
In-Reply-To: <20210325211122.98620-2-toke@redhat.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 25 Mar 2021 21:04:17 -0700
Message-ID: <CAEf4BzaxmrWFBJ1mzzWzu0yb_iFX528cAFVbXrncPEaJBXrd2A@mail.gmail.com>
Subject: Re: [PATCH bpf v2 2/2] bpf/selftests: test that kernel rejects a TCP
 CC with an invalid license
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Clark Williams <williams@redhat.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 25, 2021 at 2:11 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> This adds a selftest to check that the verifier rejects a TCP CC struct_o=
ps
> with a non-GPL license.
>
> v2:
> - Use a minimal struct_ops BPF program instead of rewriting bpf_dctcp's
>   license in memory.
> - Check for the verifier reject message instead of just the return code.
>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---
>  .../selftests/bpf/prog_tests/bpf_tcp_ca.c     | 44 +++++++++++++++++++
>  .../selftests/bpf/progs/bpf_nogpltcp.c        | 19 ++++++++
>  2 files changed, 63 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/progs/bpf_nogpltcp.c
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c b/tools/=
testing/selftests/bpf/prog_tests/bpf_tcp_ca.c
> index 37c5494a0381..a09c716528e1 100644
> --- a/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c
> +++ b/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c
> @@ -6,6 +6,7 @@
>  #include <test_progs.h>
>  #include "bpf_dctcp.skel.h"
>  #include "bpf_cubic.skel.h"
> +#include "bpf_nogpltcp.skel.h"

total nit, but my eyes can't read "nogpltcp"... wouldn't
"bpf_tcp_nogpl" be a bit easier?

>
>  #define min(a, b) ((a) < (b) ? (a) : (b))
>
> @@ -227,10 +228,53 @@ static void test_dctcp(void)
>         bpf_dctcp__destroy(dctcp_skel);
>  }
>
> +static char *err_str =3D NULL;
> +static bool found =3D false;
> +
> +static int libbpf_debug_print(enum libbpf_print_level level,
> +                             const char *format, va_list args)
> +{
> +       char *log_buf;
> +
> +       if (level !=3D LIBBPF_WARN ||
> +           strcmp(format, "libbpf: \n%s\n")) {
> +               vprintf(format, args);
> +               return 0;
> +       }
> +
> +       log_buf =3D va_arg(args, char *);
> +       if (!log_buf)
> +               goto out;
> +       if (err_str && strstr(log_buf, err_str) !=3D NULL)
> +               found =3D true;
> +out:
> +       printf(format, log_buf);
> +       return 0;
> +}
> +
> +static void test_invalid_license(void)
> +{
> +       libbpf_print_fn_t old_print_fn =3D NULL;
> +       struct bpf_nogpltcp *skel;
> +
> +       err_str =3D "struct ops programs must have a GPL compatible licen=
se";
> +       old_print_fn =3D libbpf_set_print(libbpf_debug_print);
> +
> +       skel =3D bpf_nogpltcp__open_and_load();
> +       if (CHECK(skel, "bpf_nogplgtcp__open_and_load()", "didn't fail\n"=
))

ASSERT_OK_PTR()

> +               bpf_nogpltcp__destroy(skel);

you should destroy unconditionally

> +
> +       CHECK(!found, "errmsg check", "expected string '%s'", err_str);

ASSERT_EQ(found, true, "expected_err_msg");

I can never be sure which way CHECK() is checking

> +
> +       libbpf_set_print(old_print_fn);
> +}
> +
>  void test_bpf_tcp_ca(void)
>  {
>         if (test__start_subtest("dctcp"))
>                 test_dctcp();
>         if (test__start_subtest("cubic"))
>                 test_cubic();
> +       if (test__start_subtest("invalid_license"))
> +               test_invalid_license();
>  }
> diff --git a/tools/testing/selftests/bpf/progs/bpf_nogpltcp.c b/tools/tes=
ting/selftests/bpf/progs/bpf_nogpltcp.c
> new file mode 100644
> index 000000000000..2ecd833dcd41
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/bpf_nogpltcp.c
> @@ -0,0 +1,19 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include <linux/bpf.h>
> +#include <linux/types.h>
> +#include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_tracing.h>
> +#include "bpf_tcp_helpers.h"
> +
> +char _license[] SEC("license") =3D "X";
> +
> +void BPF_STRUCT_OPS(nogpltcp_init, struct sock *sk)
> +{
> +}
> +
> +SEC(".struct_ops")
> +struct tcp_congestion_ops bpf_nogpltcp =3D {
> +       .init           =3D (void *)nogpltcp_init,
> +       .name           =3D "bpf_nogpltcp",
> +};
> --
> 2.31.0
>
