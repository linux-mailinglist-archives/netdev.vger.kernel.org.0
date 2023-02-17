Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1815069B61B
	for <lists+netdev@lfdr.de>; Sat, 18 Feb 2023 00:02:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbjBQXCZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 18:02:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjBQXCY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 18:02:24 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBBD4E0;
        Fri, 17 Feb 2023 15:02:22 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id er25so9654873edb.6;
        Fri, 17 Feb 2023 15:02:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=KLO8kRgJvzgdiNMZhvSmWQDqSrZh04Kc2kD9rBHCNe8=;
        b=cTLkRKDT3VbbkuCzZZf9EIt3Nzvdx5n1hCmL9GHhwJ4ocF+WOWCgxugu3EzNvZPXAl
         kIkgR5+G0b0NGlCSjm8sjEYVBC06SuUFndo5rKrCsAv7xMJuY67HgMGIYNCs3d+SQdW8
         rqEO5AlAtLod4WTAZNlPTaUvhPTGw8VVMiJFXEnp3TL+gialzn4o6kzVsfc4Msu2Gyte
         /gUuEUayAytbmJBonCTj+834znvOspcMSeRyROQJcXkxwItdCvgypDutwgaZ5PFle4DY
         hTZIU/kFEYUVe/EKlgR50YLz2uP3lN8mOa1xENWtRYoaYOef/PvO8CGisssaWdAATCJn
         Ph9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KLO8kRgJvzgdiNMZhvSmWQDqSrZh04Kc2kD9rBHCNe8=;
        b=cdGDvdgAIwkKxk/LzcrR211CBCoI4XyGapKupHZTy6BLp+81bzV9cWfMflGHU6aMbq
         6AVkCoIMbdxWAYOGa1S68jFQep9CfBhsTTYRoJxcIqtGKvpUD/2vm3a6xiJZN/L2jIL8
         fN5SvoMrK5HpncizNOSpEilzpJxHAlTRR7xGiSOscIR/KC6WF+oIiSy12iJprYv2wxze
         zqdB4tcxO8IbJTA6jW6x1hbllz9Q8OkVvAeNpTzr1o87iz5Bk8zo5FvDZb9ZGjqtT7CK
         vNoEHZ1tnYwFhlP8+KHmkv1y5ZhuESD/3hFtm5gL96iVI2rQak5fdJf/FWY0dw1ou9uo
         AFKg==
X-Gm-Message-State: AO0yUKWRr/lQtrztag3Hr3Z7A0tsrQPuqXE8NtommAC1vWKliwzoqZ1A
        A5BAtDjh3BsVjEo5sqSY5SoA3DtO84DZznz9cFk=
X-Google-Smtp-Source: AK7set9O7/OrphumwDC/kC0yzLLrFmWTIY1FPF7Ai3P0h9NiOuG6dcJ+DQ2EbD5EozJtKggUltUFqtg5R0vrYRnC0co=
X-Received: by 2002:a50:9f2c:0:b0:4ab:4d34:9762 with SMTP id
 b41-20020a509f2c000000b004ab4d349762mr1531494edf.5.1676674941247; Fri, 17 Feb
 2023 15:02:21 -0800 (PST)
MIME-Version: 1.0
References: <20230217004150.2980689-1-martin.lau@linux.dev> <20230217004150.2980689-5-martin.lau@linux.dev>
In-Reply-To: <20230217004150.2980689-5-martin.lau@linux.dev>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 17 Feb 2023 15:02:09 -0800
Message-ID: <CAEf4BzYL_K5Z3K-M394FeaQp87YozmqyUR8i=PaSfU7aCM=P+g@mail.gmail.com>
Subject: Re: [PATCH bpf-next 4/4] selftests/bpf: Add bpf_fib_lookup test
To:     Martin KaFai Lau <martin.lau@linux.dev>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 16, 2023 at 4:42 PM Martin KaFai Lau <martin.lau@linux.dev> wrote:
>
> From: Martin KaFai Lau <martin.lau@kernel.org>
>
> This patch tests the bpf_fib_lookup helper when looking up
> a neigh in NUD_FAILED and NUD_STALE state. It also adds test
> for the new BPF_FIB_LOOKUP_SKIP_NEIGH flag.
>
> Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
> ---
>  .../selftests/bpf/prog_tests/fib_lookup.c     | 187 ++++++++++++++++++
>  .../testing/selftests/bpf/progs/fib_lookup.c  |  22 +++
>  2 files changed, 209 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/fib_lookup.c
>  create mode 100644 tools/testing/selftests/bpf/progs/fib_lookup.c
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/fib_lookup.c b/tools/testing/selftests/bpf/prog_tests/fib_lookup.c
> new file mode 100644
> index 000000000000..61ccddccf485
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/fib_lookup.c
> @@ -0,0 +1,187 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2023 Meta Platforms, Inc. and affiliates. */
> +
> +#include <sys/types.h>
> +#include <net/if.h>
> +
> +#include "test_progs.h"
> +#include "network_helpers.h"
> +#include "fib_lookup.skel.h"
> +
> +#define SYS(fmt, ...)                                          \
> +       ({                                                      \
> +               char cmd[1024];                                 \
> +               snprintf(cmd, sizeof(cmd), fmt, ##__VA_ARGS__); \
> +               if (!ASSERT_OK(system(cmd), cmd))               \
> +                       goto fail;                              \
> +       })

it's probably a high time to move this SYS() macro into test_progs.h
and stop copy/pasting it across many test?

[...]
