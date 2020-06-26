Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A09A120BA2C
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 22:21:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725912AbgFZUVP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 16:21:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbgFZUVO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 16:21:14 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE183C03E979;
        Fri, 26 Jun 2020 13:21:14 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id di5so141450qvb.11;
        Fri, 26 Jun 2020 13:21:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XSfjPIdCIsSUipm7ILrWBk5ID/BPDxK2vNHFKOdu/U4=;
        b=lSaPK0+JPLyNdjeg44ZWhL5Sd5hWJy4APwBYm0qOhXZECdCcn4WbFgb8s3yDnw5/Fx
         iX1yc0vAALFXrPmBqCcFTmzr5mi7unSMyHRrYwAj3Cn12HlX5+BgjPFRqrCYK0S0Y8cD
         BrMztWqqLWfFtCT7Juy0sHsBdEj3d9UXLnnP+Qq/mp6h/8CYS6hzuz7QIi28sp9Eok/n
         qoHQyb4S8TBuvE7r1HT7lE1QpiK3S6iIoFeyD6Z6zb4s8RKiw8vUdEoxFfrN3Bc7dboN
         AFihQiXXTOlXXJHBmG1MbuSk4aIY/EM8v9imoRa9RDXIfWj5NWyd8YrutRXzuryKDCDR
         Nbhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XSfjPIdCIsSUipm7ILrWBk5ID/BPDxK2vNHFKOdu/U4=;
        b=NlJs8bf1qydGrdFXoxLitllEkMReXJnPWDds6vu0C13gxZojmhdJH/+Gpr6nft/WJ4
         Yb15B7hHmA2SUIgkvtQWNJkyfqCFQkcGHK6xPdjCv7YHOPGEXBwzw7tBr8O0W3XoQ2jO
         oezyZp2HC3HYadbCYDCSiUT3S/zrct1dRrTfO8rvjhpX4oOqZro7lH8trOEqaqJyWHjd
         KWnKpqMJFjB+/PAdkzIR0GEQ91zokLzPisC4iT01nW6jF6RI9OtbH/ScPbQl2Cg6fkju
         d59uLjwubMZ6RhXSi6G9900s9HJ0csMAUcDzIxY7IkKQ2eo1LRujKYCKrxVbrD+JKman
         C6WA==
X-Gm-Message-State: AOAM531xsGeRYgAZbmYgPUjqzXbuq3RWav8A90zyZoj5VWcsZxEoOj0H
        60O0f/aX9fXNQYCA1DXsu37+xLSPOW3xKQ7y5VI=
X-Google-Smtp-Source: ABdhPJy/MdxbXmq/GzaQlZLepq/e6SFCRQMz/Nma8lYTPsmMDsWzdpvoaCjHRz0PDl8l71fAxgoFtF0r35PdfNdA8uM=
X-Received: by 2002:a0c:f388:: with SMTP id i8mr4888184qvk.224.1593202874252;
 Fri, 26 Jun 2020 13:21:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200626001332.1554603-1-songliubraving@fb.com> <20200626001332.1554603-5-songliubraving@fb.com>
In-Reply-To: <20200626001332.1554603-5-songliubraving@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 26 Jun 2020 13:21:03 -0700
Message-ID: <CAEf4Bzb6H3a48S3L4WZtPTMSLZpAe4C5_2aFwJAnNDVLVWDTQA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 4/4] selftests/bpf: add bpf_iter test with bpf_get_task_stack()
To:     Song Liu <songliubraving@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Peter Ziljstra <peterz@infradead.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 25, 2020 at 5:15 PM Song Liu <songliubraving@fb.com> wrote:
>
> The new test is similar to other bpf_iter tests.
>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  .../selftests/bpf/prog_tests/bpf_iter.c       | 17 ++++++
>  .../selftests/bpf/progs/bpf_iter_task_stack.c | 60 +++++++++++++++++++
>  2 files changed, 77 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_task_stack.c
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
> index 87c29dde1cf96..baa83328f810d 100644
> --- a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
> +++ b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
> @@ -5,6 +5,7 @@
>  #include "bpf_iter_netlink.skel.h"
>  #include "bpf_iter_bpf_map.skel.h"
>  #include "bpf_iter_task.skel.h"
> +#include "bpf_iter_task_stack.skel.h"
>  #include "bpf_iter_task_file.skel.h"
>  #include "bpf_iter_test_kern1.skel.h"
>  #include "bpf_iter_test_kern2.skel.h"
> @@ -106,6 +107,20 @@ static void test_task(void)
>         bpf_iter_task__destroy(skel);
>  }
>
> +static void test_task_stack(void)
> +{
> +       struct bpf_iter_task_stack *skel;
> +
> +       skel = bpf_iter_task_stack__open_and_load();
> +       if (CHECK(!skel, "bpf_iter_task_stack__open_and_load",
> +                 "skeleton open_and_load failed\n"))
> +               return;
> +
> +       do_dummy_read(skel->progs.dump_task_stack);
> +
> +       bpf_iter_task_stack__destroy(skel);
> +}
> +
>  static void test_task_file(void)
>  {
>         struct bpf_iter_task_file *skel;
> @@ -392,6 +407,8 @@ void test_bpf_iter(void)
>                 test_bpf_map();
>         if (test__start_subtest("task"))
>                 test_task();
> +       if (test__start_subtest("task_stack"))
> +               test_task_stack();
>         if (test__start_subtest("task_file"))
>                 test_task_file();
>         if (test__start_subtest("anon"))
> diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_task_stack.c b/tools/testing/selftests/bpf/progs/bpf_iter_task_stack.c
> new file mode 100644
> index 0000000000000..83aca5b1a7965
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/bpf_iter_task_stack.c
> @@ -0,0 +1,60 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2020 Facebook */
> +/* "undefine" structs in vmlinux.h, because we "override" them below */
> +#define bpf_iter_meta bpf_iter_meta___not_used
> +#define bpf_iter__task bpf_iter__task___not_used
> +#include "vmlinux.h"
> +#undef bpf_iter_meta
> +#undef bpf_iter__task
> +#include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_tracing.h>
> +
> +char _license[] SEC("license") = "GPL";
> +
> +/* bpf_get_task_stack needs a stackmap to work */

no it doesn't anymore :) please drop


[...]
