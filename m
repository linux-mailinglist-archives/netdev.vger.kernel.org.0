Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A61846B129
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 04:01:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232165AbhLGDFK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 22:05:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbhLGDFK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 22:05:10 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1B23C061746;
        Mon,  6 Dec 2021 19:01:40 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id y68so37038815ybe.1;
        Mon, 06 Dec 2021 19:01:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=SsU0lfOFUmbxSub/TvW3fncV252nyu9Ag0mbArXo2oU=;
        b=UVKuYWARs/LCaPOrjc9ur9OwO7QyDsizYkMeHPpzhWd2RSP2GeB6fZdA/Dvxp9Icyn
         Z2OcdKvQLIy5uhxEnRTPmsqu9hC3QgjVtw27YSMPjHf9/pU7LEe2AAsYIXzUYN1KPVxs
         cAGHIHtt2TtjbWo4xRCJ2QDPXFdnSg234AcvEAjXwLV4BilNqNd6LIFXlkEL5zyy/5Xs
         6v5/lgqgC6D2Js6e5zZe89z66a6N3XlVhPGY7OHgMHsW3AawbRIJV3F2+R+ObpGAucSO
         8VhovCC1S8QxqTu+n2gsOFXP43vbTxurR6t09sulx0pOOUNreSusig3qNOWb58FEWjuG
         IFMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=SsU0lfOFUmbxSub/TvW3fncV252nyu9Ag0mbArXo2oU=;
        b=LjCQBa9CwPINYtJ4Xnpc8VygecQPGXw5/GSc8qSTdv0lEzq6BE2okXWKbdMcsawpR3
         X2Vgoto5vUCkPnAQOeq9MEAWeiNE4x5wZcbei0WM2zzklmV7AJCXlNKd3ueQf27M6Zsu
         9XsYy1ec2OXu5WFxzwZM8h5Yc8bbaGOAinhup/WUxZyi19hNaS1kWQwO80eTPtIOOzSf
         MX1JycWsXaImY//om/w9Lmf2VOpi50L3vCygIsJHiM32spzLr3SOkR6qiJ00TXxv+PsV
         MxB2v1kEMGqlKq4eZBKmZoadx433SrRULi2ElY3+f8JmmoAMgO//vcuMHDc+WoucUxgF
         lFyw==
X-Gm-Message-State: AOAM531D4CzLY6PQojkvAO7oI4EDgGy+8tIuD4hLhbqzh8+l2XxgwhBM
        0I+udZbI/aFiQ/L/4PsLun9rjkvCN4L8BLmBJlP1Jco0aO4=
X-Google-Smtp-Source: ABdhPJy3y73wYtsVanZOUj/N03IS4Ni0e0daGAsXgE8rfFtOhCpCbCep/inYFubBO02BQaTfrCvAFb7TZMO/o9TlH7M=
X-Received: by 2002:a25:abaa:: with SMTP id v39mr47372329ybi.367.1638846099966;
 Mon, 06 Dec 2021 19:01:39 -0800 (PST)
MIME-Version: 1.0
References: <20211130142215.1237217-1-houtao1@huawei.com> <20211130142215.1237217-5-houtao1@huawei.com>
In-Reply-To: <20211130142215.1237217-5-houtao1@huawei.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 6 Dec 2021 19:01:28 -0800
Message-ID: <CAEf4BzZLsV_MoUz4VwspzVUbJaXVn0YVsKvf=bL-WPspbw6WGA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 4/5] selftests/bpf: add benchmark for
 bpf_strncmp() helper
To:     Hou Tao <houtao1@huawei.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 30, 2021 at 6:07 AM Hou Tao <houtao1@huawei.com> wrote:
>
> Add benchmark to compare the performance between home-made strncmp()
> in bpf program and bpf_strncmp() helper. In summary, the performance
> win of bpf_strncmp() under x86-64 is greater than 18% when the compared
> string length is greater than 64, and is 179% when the length is 4095.
> Under arm64 the performance win is even bigger: 33% when the length
> is greater than 64 and 600% when the length is 4095.
>
> The following is the details:
>
> no-helper-X: use home-made strncmp() to compare X-sized string
> helper-Y: use bpf_strncmp() to compare Y-sized string
>
> Under x86-64:
>
> no-helper-1          3.504 =C2=B1 0.000M/s (drops 0.000 =C2=B1 0.000M/s)
> helper-1             3.347 =C2=B1 0.001M/s (drops 0.000 =C2=B1 0.000M/s)
>
> no-helper-8          3.357 =C2=B1 0.001M/s (drops 0.000 =C2=B1 0.000M/s)
> helper-8             3.307 =C2=B1 0.001M/s (drops 0.000 =C2=B1 0.000M/s)
>
> no-helper-32         3.064 =C2=B1 0.000M/s (drops 0.000 =C2=B1 0.000M/s)
> helper-32            3.253 =C2=B1 0.001M/s (drops 0.000 =C2=B1 0.000M/s)
>
> no-helper-64         2.563 =C2=B1 0.001M/s (drops 0.000 =C2=B1 0.000M/s)
> helper-64            3.040 =C2=B1 0.001M/s (drops 0.000 =C2=B1 0.000M/s)
>
> no-helper-128        1.975 =C2=B1 0.000M/s (drops 0.000 =C2=B1 0.000M/s)
> helper-128           2.641 =C2=B1 0.000M/s (drops 0.000 =C2=B1 0.000M/s)
>
> no-helper-512        0.759 =C2=B1 0.000M/s (drops 0.000 =C2=B1 0.000M/s)
> helper-512           1.574 =C2=B1 0.000M/s (drops 0.000 =C2=B1 0.000M/s)
>
> no-helper-2048       0.329 =C2=B1 0.000M/s (drops 0.000 =C2=B1 0.000M/s)
> helper-2048          0.602 =C2=B1 0.000M/s (drops 0.000 =C2=B1 0.000M/s)
>
> no-helper-4095       0.117 =C2=B1 0.000M/s (drops 0.000 =C2=B1 0.000M/s)
> helper-4095          0.327 =C2=B1 0.000M/s (drops 0.000 =C2=B1 0.000M/s)
>
> Under arm64:
>
> no-helper-1          2.806 =C2=B1 0.004M/s (drops 0.000 =C2=B1 0.000M/s)
> helper-1             2.819 =C2=B1 0.002M/s (drops 0.000 =C2=B1 0.000M/s)
>
> no-helper-8          2.797 =C2=B1 0.109M/s (drops 0.000 =C2=B1 0.000M/s)
> helper-8             2.786 =C2=B1 0.025M/s (drops 0.000 =C2=B1 0.000M/s)
>
> no-helper-32         2.399 =C2=B1 0.011M/s (drops 0.000 =C2=B1 0.000M/s)
> helper-32            2.703 =C2=B1 0.002M/s (drops 0.000 =C2=B1 0.000M/s)
>
> no-helper-64         2.020 =C2=B1 0.015M/s (drops 0.000 =C2=B1 0.000M/s)
> helper-64            2.702 =C2=B1 0.073M/s (drops 0.000 =C2=B1 0.000M/s)
>
> no-helper-128        1.604 =C2=B1 0.001M/s (drops 0.000 =C2=B1 0.000M/s)
> helper-128           2.516 =C2=B1 0.002M/s (drops 0.000 =C2=B1 0.000M/s)
>
> no-helper-512        0.699 =C2=B1 0.000M/s (drops 0.000 =C2=B1 0.000M/s)
> helper-512           2.106 =C2=B1 0.003M/s (drops 0.000 =C2=B1 0.000M/s)
>
> no-helper-2048       0.215 =C2=B1 0.000M/s (drops 0.000 =C2=B1 0.000M/s)
> helper-2048          1.223 =C2=B1 0.003M/s (drops 0.000 =C2=B1 0.000M/s)
>
> no-helper-4095       0.112 =C2=B1 0.000M/s (drops 0.000 =C2=B1 0.000M/s)
> helper-4095          0.796 =C2=B1 0.000M/s (drops 0.000 =C2=B1 0.000M/s)
>
> Signed-off-by: Hou Tao <houtao1@huawei.com>
> ---
>  tools/testing/selftests/bpf/Makefile          |   4 +-
>  tools/testing/selftests/bpf/bench.c           |   6 +
>  .../selftests/bpf/benchs/bench_strncmp.c      | 150 ++++++++++++++++++
>  .../selftests/bpf/benchs/run_bench_strncmp.sh |  12 ++
>  .../selftests/bpf/progs/strncmp_bench.c       |  50 ++++++
>  5 files changed, 221 insertions(+), 1 deletion(-)
>  create mode 100644 tools/testing/selftests/bpf/benchs/bench_strncmp.c
>  create mode 100755 tools/testing/selftests/bpf/benchs/run_bench_strncmp.=
sh
>  create mode 100644 tools/testing/selftests/bpf/progs/strncmp_bench.c
>

[...]

> diff --git a/tools/testing/selftests/bpf/progs/strncmp_bench.c b/tools/te=
sting/selftests/bpf/progs/strncmp_bench.c
> new file mode 100644
> index 000000000000..18373a7df76e
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/strncmp_bench.c
> @@ -0,0 +1,50 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (C) 2021. Huawei Technologies Co., Ltd */
> +#include <linux/types.h>
> +#include <linux/bpf.h>
> +#include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_tracing.h>
> +
> +#define STRNCMP_STR_SZ 4096
> +
> +/* Will be updated by benchmark before program loading */
> +const volatile unsigned int cmp_str_len =3D 1;
> +const char target[STRNCMP_STR_SZ];
> +
> +long hits =3D 0;
> +char str[STRNCMP_STR_SZ];
> +
> +char _license[] SEC("license") =3D "GPL";
> +
> +static __always_inline int local_strncmp(const char *s1, unsigned int sz=
,
> +                                        const char *s2)
> +{
> +       int ret =3D 0;
> +       unsigned int i;
> +
> +       for (i =3D 0; i < sz; i++) {
> +               /* E.g. 0xff > 0x31 */
> +               ret =3D (unsigned char)s1[i] - (unsigned char)s2[i];

I'm actually not sure if it will perform subtraction in unsigned form
(and thus you'll never have a negative result) and then cast to int,
or not. Why not cast to int instead of unsigned char to be sure?

> +               if (ret || !s1[i])
> +                       break;
> +       }
> +
> +       return ret;
> +}
> +
> +SEC("tp/syscalls/sys_enter_getpgid")
> +int strncmp_no_helper(void *ctx)
> +{
> +       if (local_strncmp(str, cmp_str_len + 1, target) < 0)
> +               __sync_add_and_fetch(&hits, 1);
> +       return 0;
> +}
> +
> +SEC("tp/syscalls/sys_enter_getpgid")
> +int strncmp_helper(void *ctx)
> +{
> +       if (bpf_strncmp(str, cmp_str_len + 1, target) < 0)
> +               __sync_add_and_fetch(&hits, 1);
> +       return 0;
> +}
> +
> --
> 2.29.2
>
