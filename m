Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B94D52F28AA
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 08:07:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391814AbhALHHa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 02:07:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbhALHHa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 02:07:30 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30E63C061575;
        Mon, 11 Jan 2021 23:06:50 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id f13so1225055ybk.11;
        Mon, 11 Jan 2021 23:06:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S+f76NTEOkHVw13mifQvc2gu6YvEEJ5SVA6pZQpjWSE=;
        b=I+dKM2xByBdb9epVG7BkzzKJ9y6pAVMUppRUNDW8ivic4IquF6zKHe6gr5gMvz/kLl
         Ft65GFr0f7nvg284kFbiVd0JI57dB/n07Z56LqfWXUo5Wzqj6r/HgBU8vhOIsFmIZj8c
         /6nonxX9VTDx6hw2vwmgSJD8wyF72Jo8vXiN6JtVjv3SQej1d+e1lVYCeOq8GqdUHN82
         TuUA9OyPP1gyPca6M89+zrodqyrRdgqkjFq01pxHkdb9t8lLmvJTR1Ia5PwTisE2jh+Y
         ewhPqxVlpzumg84w4aL0YfWGxfNZ72kj4pzQ28pwsO++43APJuGmev/ZBSue/mxFou0b
         EEBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S+f76NTEOkHVw13mifQvc2gu6YvEEJ5SVA6pZQpjWSE=;
        b=PYC6i2KPs/CGuux5M/b4Tld3a4Q+57LGRjzs4TYnuxJxtq+1UCVlO17zdL3l3cvVz/
         8wV5/WzfDz/uGkxn9/XVaxJxm64glm7zV6rVoXcWKJkWljAYdFrUICheBu8IrNyZV827
         92AXF0/kE7NiQ5HkQtcMbL+MlWCsRZWHGYLBhCZ36oXouz6zZrSuUnsOt1Q6nULct3QU
         MQ6VGlMLsQkzB4yOT1zr9A2ZWa8/2s6q8mrQ3lBzHhRDFHHd/wKoc/0PPjtZnP6GMUJz
         /KS/M4lnU5aKJHxyRqXrf8gVPGOBLjEGrsODAXMryH4FK++vdO71IlHOBF1NMDGl8kd0
         zKRg==
X-Gm-Message-State: AOAM5337icovg6E/0swfqQ8Aun5LXKZCXV77nJRaXTNqnErLCXLC/Lk0
        h/nMDCtaU1AxcH0lGEqh39aAu5JwheQrb5+MXfbqLy4et2Y=
X-Google-Smtp-Source: ABdhPJySev7Z1tq9/M7y9SHm/izI6+EKgPjYByLfN1ZF/jdtLJDqmPZgP126IuPz/StMoXl6rDABKkIV4Uh9YOuliPg=
X-Received: by 2002:a25:48c7:: with SMTP id v190mr1176118yba.260.1610435209325;
 Mon, 11 Jan 2021 23:06:49 -0800 (PST)
MIME-Version: 1.0
References: <20210108231950.3844417-1-songliubraving@fb.com> <20210108231950.3844417-3-songliubraving@fb.com>
In-Reply-To: <20210108231950.3844417-3-songliubraving@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 11 Jan 2021 23:06:38 -0800
Message-ID: <CAEf4BzbfiAx1QuNaDxcV0zX4wxOAOLUres61B7wf6SgZKa-E7w@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/4] selftests/bpf: add non-BPF_LSM test for task
 local storage
To:     Song Liu <songliubraving@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Ziljstra <peterz@infradead.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Kernel Team <kernel-team@fb.com>, Hao Luo <haoluo@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 8, 2021 at 3:30 PM Song Liu <songliubraving@fb.com> wrote:
>
> Task local storage is enabled for tracing programs. Add a test for it
> without CONFIG_BPF_LSM.
>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  .../bpf/prog_tests/test_task_local_storage.c  | 34 +++++++++++++++++
>  .../selftests/bpf/progs/task_local_storage.c  | 37 +++++++++++++++++++
>  2 files changed, 71 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/test_task_local_storage.c
>  create mode 100644 tools/testing/selftests/bpf/progs/task_local_storage.c
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/test_task_local_storage.c b/tools/testing/selftests/bpf/prog_tests/test_task_local_storage.c
> new file mode 100644
> index 0000000000000..7de7a154ebbe6
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/test_task_local_storage.c
> @@ -0,0 +1,34 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2020 Facebook */
> +
> +#include <sys/types.h>
> +#include <unistd.h>
> +#include <test_progs.h>
> +#include "task_local_storage.skel.h"
> +
> +static unsigned int duration;
> +
> +void test_test_task_local_storage(void)

nit: let's not use "test_test_" tautology. It can be simply
test_task_local_storage() and this file itself should be called
task_local_storage.c.

> +{
> +       struct task_local_storage *skel;
> +       const int count = 10;
> +       int i, err;
> +
> +       skel = task_local_storage__open_and_load();
> +
> +       if (CHECK(!skel, "skel_open_and_load", "skeleton open and load failed\n"))

btw, can you ASSERT_OK_PTR(skel, "skel_open_and_load"); and save
yourself a bunch of typing

> +               return;
> +
> +       err = task_local_storage__attach(skel);
> +
> +       if (CHECK(err, "skel_attach", "skeleton attach failed\n"))
> +               goto out;

similarly, ASSERT_OK(err, "skel_attach")

> +
> +       for (i = 0; i < count; i++)
> +               usleep(1000);
> +       CHECK(skel->bss->value < count, "task_local_storage_value",
> +             "task local value too small\n");
> +
> +out:
> +       task_local_storage__destroy(skel);
> +}

[...]
