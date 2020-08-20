Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D6FA24C889
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 01:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728765AbgHTX2y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 19:28:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728498AbgHTX2w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 19:28:52 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7147CC061385;
        Thu, 20 Aug 2020 16:28:52 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id e187so73871ybc.5;
        Thu, 20 Aug 2020 16:28:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=I4AnSFmbXVOxQA3besowBCN7vcTSIU68ZFhsXcLe040=;
        b=dQLbnegfnNarf24TQhcO5j4o8so7sVdmpA85y0UlnTwuB8QN70TF/HWC2FrrSKhFsV
         ew+WvxpPVOMPtDzkNQ8oSsmtqZ/Xu9WyZZs3hKNZQ8PLwvIBKuQhb8h13I6+vz9O4y2Q
         KbOC/xWHzfAmxC5ZLaHQB6hMgvGe6yq3ewvpniJSq6MqmkFPXqFTAkJKjpzP8D4M2z38
         7+2XK213H/pjkrONRVe+YQBaW56PGGVIyT4YB5oYXtwTayYyaE3H4GuVhxlFwRYQWXMB
         40E9HjP/RU7SnqmYXhbajJEOgatoJBX6WHNrrTuwwbWhllrPS3Y8oVj2ZKGb9RDyVPv3
         qnmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=I4AnSFmbXVOxQA3besowBCN7vcTSIU68ZFhsXcLe040=;
        b=d4jIR1MwLlC6tXCQ6jpOHd+TvPmHoX3K6V1rPsPZ5ufKapUaTtIJrR35VUAxjPuU3L
         FpDmhjEs83wbzke3WLNLvjENYqZ2QkB139BkE3jxztft+hqO6kUShjXZgeGsHkFS9zsu
         JqKa8yIiulXJ5MBivOmxCSqs9kWkM5sPAYzKvwJd9/wfH2DLLgxrxlfR/GUHuiDoCtey
         LOedMOGm5pQcI7q4H1Q1xoz3B1PqUbT1i3//BnaA7I2BSV0auExLza0F1/uolzIov5oS
         NI/JRnj9RUVYuEoB7fDaW9q2fjxh79RowJN1ClcHkDNfpYii3IHuJODSpoWsoEc1mRiO
         0ttA==
X-Gm-Message-State: AOAM533uO4m3Qn6yPhuLk/9OUOaFapFzebRzBMxCq2YHO1awpi+46ol/
        +LwRGDcEKK81ntA/3W4KN5QGeaEmIx2LqKQzhyc=
X-Google-Smtp-Source: ABdhPJzJJcTF9B51IgRt6NN4i7rAy6sn3zFoub/pGBO/2o4w7Drh+nM325OUJaGJinBsBPVsTBmX3LVJPbqXOPo2MEo=
X-Received: by 2002:a25:bc50:: with SMTP id d16mr202489ybk.230.1597966131648;
 Thu, 20 Aug 2020 16:28:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200820231250.1293069-1-andriin@fb.com> <20200820231250.1293069-13-andriin@fb.com>
In-Reply-To: <20200820231250.1293069-13-andriin@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 20 Aug 2020 16:28:40 -0700
Message-ID: <CAEf4BzZGsZdsiuufzHaV-fRdmqNotnrQR7--eXGnafUxafBBQQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 12/16] selftests/bpf: add selftest for multi-prog
 sections and bpf-to-bpf calls
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 20, 2020 at 4:13 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> Add a selftest excercising bpf-to-bpf subprogram calls, as well as multiple
> entry-point BPF programs per section. Also make sure that BPF CO-RE works for
> such set ups both for sub-programs and for multi-entry sections.
>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  .../selftests/bpf/prog_tests/subprogs.c       | 31 +++++++
>  .../selftests/bpf/progs/test_subprogs.c       | 92 +++++++++++++++++++
>  2 files changed, 123 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/subprogs.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_subprogs.c
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/subprogs.c b/tools/testing/selftests/bpf/prog_tests/subprogs.c
> new file mode 100644
> index 000000000000..a00abf58c037
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/subprogs.c
> @@ -0,0 +1,31 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2020 Facebook */
> +#include <test_progs.h>
> +#include <time.h>
> +#include "test_subprogs.skel.h"
> +
> +static int duration;
> +
> +void test_subprogs(void)
> +{
> +       struct test_subprogs *skel;
> +       int err;
> +
> +       skel = test_subprogs__open_and_load();
> +       if (CHECK(!skel, "skel_open", "failed to open skeleton\n"))
> +               return;
> +
> +       err = test_subprogs__attach(skel);
> +       if (CHECK(err, "skel_attach", "failed to attach skeleton: %d\n", err))
> +               goto cleanup;
> +
> +       usleep(1);
> +
> +       CHECK(skel->bss->res1 != 12, "res1", "got %d, exp %d\n", skel->bss->res1, 12);
> +       CHECK(skel->bss->res2 != 17, "res2", "got %d, exp %d\n", skel->bss->res2, 17);
> +       CHECK(skel->bss->res3 != 19, "res3", "got %d, exp %d\n", skel->bss->res3, 19);
> +       CHECK(skel->bss->res4 != 36, "res4", "got %d, exp %d\n", skel->bss->res4, 36);
> +

res4 was a late addition, and apparently I missed test_progs build
failure among other local warnings. I'll add res4 in BPF code in the
next version.

> +cleanup:
> +       test_subprogs__destroy(skel);
> +}

[...]
