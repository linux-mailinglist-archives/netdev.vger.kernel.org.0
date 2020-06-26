Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C74920BD14
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 01:12:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbgFZXMJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 19:12:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbgFZXMJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 19:12:09 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBA0AC03E979;
        Fri, 26 Jun 2020 16:12:08 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id j10so8735916qtq.11;
        Fri, 26 Jun 2020 16:12:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pTmR+y5xQvCfn7qLWQjIR68Juu6JdR5gHIQY84QdEd4=;
        b=IuV68Sj0SKSJ8kJjMhRBv9rc+wRa/O+XtkXwVtnjm7MTGWGuJrVPQ+E/1xuhQFFzxt
         Jst27nZ5ngYKEXFcNkh5sn4SzU1XaPQuvCbnIOAFFavbzQ4ZtH2L3Hypyu1nsdBnm3Fo
         Xq4TrdiFvw1hMdh5eep5MK7hnVkfLopKDB8T1zgcTDgaOzNhJvImLfHDMLVNRUUMyH1u
         ofMPXZrjNtIkZDcG7eTNxjr9TPWauKc8q1lUpsHfeAJIRG+lJ7MzKOF8PfAXx/CQy8tY
         5oyXfEKd7mTGriQm2etbaS/uuJgmSnC1PC+moNrG/vDJDP+zC/pylnqEnKR9aEdeuykz
         iBJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pTmR+y5xQvCfn7qLWQjIR68Juu6JdR5gHIQY84QdEd4=;
        b=hjNuAkgxBuC6MU541v63JR4e/GkEbk9LarKwWIC3oCgJ6Nb6jpi/cL5PQEEItvYzXM
         75YZYX8HtYVvN//r1SuGwREqQ7ItK8NQE/501Zw4Z+L6S0/cmUshg3+jBZxcrwqELMlX
         47aRi7+T+rJ8HVN/q/UbPyjz1V/f3TikWerarKDbyV3zH3+CoOnFCZ26XGhL51dZdNBQ
         IbGE907/X53HmXdve51QjTJIGSdowkG4RecnZAN9FSkWLqKfY2IpHVhclPVXWtxcQ2xk
         wiX2BtmkUkokDwKuobHNlttFYQDv64f3z7RJux0ihSgr+z1usyx+3kg7XnEE58ypKSIv
         sJ9Q==
X-Gm-Message-State: AOAM530jfm9d3URqi25uXulcimCMlEVwAXDupD9RfQthc2V/VE7yKn7Y
        TUY2vE2qSZrLUF5heeBc6tn8itwef76w/+ZqxxWUGBdu
X-Google-Smtp-Source: ABdhPJxzIyclZTlu3aoGsOzhVwJsAXglRMI7FIJ4PJA2sz/uUtUXt8Zh+DhIqtUNNUK+mveDG+YVuDseREIBsP1ls1s=
X-Received: by 2002:ac8:1991:: with SMTP id u17mr5099484qtj.93.1593213128220;
 Fri, 26 Jun 2020 16:12:08 -0700 (PDT)
MIME-Version: 1.0
References: <20200626001332.1554603-1-songliubraving@fb.com>
 <20200626001332.1554603-5-songliubraving@fb.com> <CAEf4Bzb6H3a48S3L4WZtPTMSLZpAe4C5_2aFwJAnNDVLVWDTQA@mail.gmail.com>
 <6B6E4195-BC5C-4A13-80A6-9493469D6A2E@fb.com>
In-Reply-To: <6B6E4195-BC5C-4A13-80A6-9493469D6A2E@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 26 Jun 2020 16:11:57 -0700
Message-ID: <CAEf4Bzb543EVJF+nU0X+1JNMaTehgiwx_0V=80W-frBYku0odA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 4/4] selftests/bpf: add bpf_iter test with bpf_get_task_stack()
To:     Song Liu <songliubraving@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Peter Ziljstra <peterz@infradead.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 26, 2020 at 4:05 PM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Jun 26, 2020, at 1:21 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> >
> > On Thu, Jun 25, 2020 at 5:15 PM Song Liu <songliubraving@fb.com> wrote:
> >>
> >> The new test is similar to other bpf_iter tests.
> >>
> >> Signed-off-by: Song Liu <songliubraving@fb.com>
> >> ---
> >> .../selftests/bpf/prog_tests/bpf_iter.c       | 17 ++++++
> >> .../selftests/bpf/progs/bpf_iter_task_stack.c | 60 +++++++++++++++++++
> >> 2 files changed, 77 insertions(+)
> >> create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_task_stack.c
> >>
> >> diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
> >> index 87c29dde1cf96..baa83328f810d 100644
> >> --- a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
> >> +++ b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
> >> @@ -5,6 +5,7 @@
> >> #include "bpf_iter_netlink.skel.h"
> >> #include "bpf_iter_bpf_map.skel.h"
> >> #include "bpf_iter_task.skel.h"
> >> +#include "bpf_iter_task_stack.skel.h"
> >> #include "bpf_iter_task_file.skel.h"
> >> #include "bpf_iter_test_kern1.skel.h"
> >> #include "bpf_iter_test_kern2.skel.h"
> >> @@ -106,6 +107,20 @@ static void test_task(void)
> >>        bpf_iter_task__destroy(skel);
> >> }
> >>
> >> +static void test_task_stack(void)
> >> +{
> >> +       struct bpf_iter_task_stack *skel;
> >> +
> >> +       skel = bpf_iter_task_stack__open_and_load();
> >> +       if (CHECK(!skel, "bpf_iter_task_stack__open_and_load",
> >> +                 "skeleton open_and_load failed\n"))
> >> +               return;
> >> +
> >> +       do_dummy_read(skel->progs.dump_task_stack);
> >> +
> >> +       bpf_iter_task_stack__destroy(skel);
> >> +}
> >> +
> >> static void test_task_file(void)
> >> {
> >>        struct bpf_iter_task_file *skel;
> >> @@ -392,6 +407,8 @@ void test_bpf_iter(void)
> >>                test_bpf_map();
> >>        if (test__start_subtest("task"))
> >>                test_task();
> >> +       if (test__start_subtest("task_stack"))
> >> +               test_task_stack();
> >>        if (test__start_subtest("task_file"))
> >>                test_task_file();
> >>        if (test__start_subtest("anon"))
> >> diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_task_stack.c b/tools/testing/selftests/bpf/progs/bpf_iter_task_stack.c
> >> new file mode 100644
> >> index 0000000000000..83aca5b1a7965
> >> --- /dev/null
> >> +++ b/tools/testing/selftests/bpf/progs/bpf_iter_task_stack.c
> >> @@ -0,0 +1,60 @@
> >> +// SPDX-License-Identifier: GPL-2.0
> >> +/* Copyright (c) 2020 Facebook */
> >> +/* "undefine" structs in vmlinux.h, because we "override" them below */
> >> +#define bpf_iter_meta bpf_iter_meta___not_used
> >> +#define bpf_iter__task bpf_iter__task___not_used
> >> +#include "vmlinux.h"
> >> +#undef bpf_iter_meta
> >> +#undef bpf_iter__task
> >> +#include <bpf/bpf_helpers.h>
> >> +#include <bpf/bpf_tracing.h>
> >> +
> >> +char _license[] SEC("license") = "GPL";
> >> +
> >> +/* bpf_get_task_stack needs a stackmap to work */
> >
> > no it doesn't anymore :) please drop
>
> We still need stack_map_alloc() to call get_callchain_buffers() in this
> case. Without an active stack map, get_callchain_buffers() may fail.

Oh... um... is it possible to do it some other way? It's extremely
confusing dependency. Does bpf_get_stack() also require stackmap?

>
> Thanks,
> Song
