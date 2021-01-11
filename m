Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F0D02F1CE7
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 18:46:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389939AbhAKRpZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 12:45:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:60072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389713AbhAKRpX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 12:45:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E126A22B30
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 17:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610387083;
        bh=KU0s6aFR42/YEnNWB//zmKH10VjW/JoURuwDS5SHTtI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=pYlOUk+51hZY45roi7Llqb5B86o3KyACGSBk1brhj6gZQWk3kKVgi5FrNuVzBm8Ld
         dEJiRwscsItk11G9j9Gbk9lWF39yfMn+wu9DTIDECwaiT7zG3ShKXva17RFlH7oMix
         HW8cZyzT9hzRYISh65JXyp9ox06RuuoLYUeREcOu8lA3eJJogJDyYEoNHeqh5bDt2n
         n7i0xokwuChAoAqlmyF7up4TpzmLqgKAIe2z89rQqz7BpSVwGkPW+q6oEJR0RO6qI0
         3mZQjHZ3Q3yw44MPPrUkRHPQ59aOXXCSlDvn5ffFtn4IPwtZDUrvk/CQVFb+VOHFPW
         BUt+ehSCgSqLg==
Received: by mail-lj1-f170.google.com with SMTP id n8so135156ljg.3
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 09:44:42 -0800 (PST)
X-Gm-Message-State: AOAM532Syido4VoQda0DwD/eU2m25K1wab4Fm4fMXnj1sHMgOnqqZI/Y
        FTaDu0XWWRRkuoWhvL6vwH5a+0sP5kU303E7+Gg4QQ==
X-Google-Smtp-Source: ABdhPJwQp13EKPjYjzcMmPFpOGCQVKxs9Kp9aW9SQ7TPyTHZpJWoXmHsejficcgYU3DLN7RcmVOP52HtGN9dgZhXmEc=
X-Received: by 2002:a2e:2e19:: with SMTP id u25mr243036lju.468.1610387081105;
 Mon, 11 Jan 2021 09:44:41 -0800 (PST)
MIME-Version: 1.0
References: <20210108231950.3844417-1-songliubraving@fb.com>
 <20210108231950.3844417-3-songliubraving@fb.com> <4eac4156-9c81-ff4d-46f5-d45d9d575a16@fb.com>
In-Reply-To: <4eac4156-9c81-ff4d-46f5-d45d9d575a16@fb.com>
From:   KP Singh <kpsingh@kernel.org>
Date:   Mon, 11 Jan 2021 18:44:30 +0100
X-Gmail-Original-Message-ID: <CACYkzJ6y1xnR2vnbiJDOWftEsH-qnsdXYcoX+nUmvw0LD1bUAg@mail.gmail.com>
Message-ID: <CACYkzJ6y1xnR2vnbiJDOWftEsH-qnsdXYcoX+nUmvw0LD1bUAg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/4] selftests/bpf: add non-BPF_LSM test for task
 local storage
To:     Yonghong Song <yhs@fb.com>
Cc:     Song Liu <songliubraving@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>, mingo@redhat.com,
        Peter Zijlstra <peterz@infradead.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Kernel Team <kernel-team@fb.com>, Hao Luo <haoluo@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 11, 2021 at 6:31 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 1/8/21 3:19 PM, Song Liu wrote:
> > Task local storage is enabled for tracing programs. Add a test for it
> > without CONFIG_BPF_LSM.

Can you also explain what the test does in the commit log?

It would also be nicer to have a somewhat more realistic selftest which
represents a simple tracing + task local storage use case.

> >
> > Signed-off-by: Song Liu <songliubraving@fb.com>
> > ---
> >   .../bpf/prog_tests/test_task_local_storage.c  | 34 +++++++++++++++++
> >   .../selftests/bpf/progs/task_local_storage.c  | 37 +++++++++++++++++++
> >   2 files changed, 71 insertions(+)
> >   create mode 100644 tools/testing/selftests/bpf/prog_tests/test_task_local_storage.c
> >   create mode 100644 tools/testing/selftests/bpf/progs/task_local_storage.c
> >
> > diff --git a/tools/testing/selftests/bpf/prog_tests/test_task_local_storage.c b/tools/testing/selftests/bpf/prog_tests/test_task_local_storage.c
> > new file mode 100644
> > index 0000000000000..7de7a154ebbe6
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/prog_tests/test_task_local_storage.c
> > @@ -0,0 +1,34 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/* Copyright (c) 2020 Facebook */
>
> 2020 -> 2021
>
> > +
> > +#include <sys/types.h>
> > +#include <unistd.h>
> > +#include <test_progs.h>
> > +#include "task_local_storage.skel.h"
> > +
> > +static unsigned int duration;
> > +
> > +void test_test_task_local_storage(void)
> > +{
> > +     struct task_local_storage *skel;
> > +     const int count = 10;
> > +     int i, err;
> > +
> > +     skel = task_local_storage__open_and_load();
> > +
>
> Extra line is unnecessary here.
>
> > +     if (CHECK(!skel, "skel_open_and_load", "skeleton open and load failed\n"))
> > +             return;
> > +
> > +     err = task_local_storage__attach(skel);
> > +
>
> ditto.
>
> > +     if (CHECK(err, "skel_attach", "skeleton attach failed\n"))
> > +             goto out;
> > +
> > +     for (i = 0; i < count; i++)
> > +             usleep(1000);
>
> Does a smaller usleep value will work? If it is, recommend to have a
> smaller value here to reduce test_progs running time.
>
> > +     CHECK(skel->bss->value < count, "task_local_storage_value",
> > +           "task local value too small\n");

[...]

> > +// SPDX-License-Identifier: GPL-2.0
> > +/* Copyright (c) 2020 Facebook */
>
> 2020 -> 2021
>
> > +
> > +#include "vmlinux.h"
> > +#include <bpf/bpf_helpers.h>
> > +#include <bpf/bpf_tracing.h>
> > +
> > +char _license[] SEC("license") = "GPL";

[...]

> > +{
> > +     struct local_data *storage;
>
> If it possible that we do some filtering based on test_progs pid
> so below bpf_task_storage_get is only called for test_progs process?
> This is more targeted and can avoid counter contributions from
> other unrelated processes and make test_task_local_storage.c result
> comparison more meaningful.

Indeed, have a look at the monitored_pid approach some of the LSM programs
do.

>
> > +
> > +     storage = bpf_task_storage_get(&task_storage_map,
> > +                                    next, 0,
> > +                                    BPF_LOCAL_STORAGE_GET_F_CREATE);
> > +     if (storage) {
> > +             storage->val++;
> > +             value = storage->val;
> > +     }
> > +     return 0;
> > +}
> >
