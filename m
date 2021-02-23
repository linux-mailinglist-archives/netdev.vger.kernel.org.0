Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F7D5322666
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 08:30:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231638AbhBWHac (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 02:30:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231527AbhBWHa0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 02:30:26 -0500
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68489C06174A;
        Mon, 22 Feb 2021 23:29:46 -0800 (PST)
Received: by mail-yb1-xb30.google.com with SMTP id b10so15553713ybn.3;
        Mon, 22 Feb 2021 23:29:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dzIqg+5mpCIY9E1ryqQh4KcWKABRhnP2MawesTKXueQ=;
        b=S7St8X67aOOiNfYFxneTnhIT+Ab8k0+26AJF5BmC8gcgfwsptS5jlTdT488F1fQFRx
         cMnlgv9xuPPCLsT6jETaIgiEWGq7Dpy8NG7fd14XERJ3FzdIHHru5sD4TFebef9oC5j/
         yJxW6H+VpoNlJdcoeyFgiI7MYxidc1KcOj+hERRIdCzEGdM7kS/gfi2KDhWUdyMHK8eq
         h4U5dcEf8AxGSnIPlvUWFHdACMYQ6K3R4fgB6u+EulG1pqf4mCfWe7NyrRN32+hf1ILK
         XJRJndmo0OaZnoZKadPM8g/XGZoTGfKBFFMSu7VyXis7xr9M+mqEj+nd0dfJ7oiRnmKb
         2lZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dzIqg+5mpCIY9E1ryqQh4KcWKABRhnP2MawesTKXueQ=;
        b=RssZgfE6yAQMHdsrJ9E3/E53+g5IdYGS6sJUmOiaY1piQxxzqKbRTl63wq4sMFOeFq
         uLxAggll8usAugc4EdQt4fCmEdcD1SpQEdNQulLneQr2dc1UWIR9B2blXxrAUR6QrUiY
         +Dnr2dxtK4sEtf0u+Po2rKPyoJrT9/+JEJC9MiMvWkr02PgQl+ZfBRQ1tgCGsmlWNbDQ
         t4fzAqsgD5ok/X3TMq7JtqNfz8sfdydd8rLbbJ/Py92KfQWatC+7gemcQiJsQS6MzXDi
         61QyG/BBMl6F38ukZX71FBv9bxBssfql02IpesxfB4c46FlY9hyQ8sktJyoLL/njgZ2B
         hubg==
X-Gm-Message-State: AOAM5309DgP2WqqPpMUBVFOh61d/YJVsTvYh/rDIcPDPPy61VX6J5uwr
        jAR8/MfsF2w2z2FINIxaJ/2PgoXfllueVh77Lfk=
X-Google-Smtp-Source: ABdhPJyg6KDJxS9hfvt93Ofk2h+sDRelQynJm+ay7bjzUWIJ8H0esq8YGaE0pi9gOfwI9wwu8lHH5zI8V5Ab59A5NWE=
X-Received: by 2002:a25:abb2:: with SMTP id v47mr37654491ybi.425.1614065385794;
 Mon, 22 Feb 2021 23:29:45 -0800 (PST)
MIME-Version: 1.0
References: <20210216105713.45052-1-lmb@cloudflare.com>
In-Reply-To: <20210216105713.45052-1-lmb@cloudflare.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 22 Feb 2021 23:29:34 -0800
Message-ID: <CAEf4BzYuvE-RsT5Ee+FstZ=vuy3AMd+1j7DazFSb56+hfPKPig@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/8] PROG_TEST_RUN support for sk_lookup programs
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        kernel-team <kernel-team@cloudflare.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 16, 2021 at 2:58 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
>
> We don't have PROG_TEST_RUN support for sk_lookup programs at the
> moment. So far this hasn't been a problem, since we can run our
> tests in a separate network namespace. For benchmarking it's nice
> to have PROG_TEST_RUN, so I've gone and implemented it.
>
> Multiple sk_lookup programs can be attached at once to the same
> netns. This can't be expressed with the current PROG_TEST_RUN
> API, so I'm proposing to extend it with an array of prog_fd.
>
> Patches 1-2 are clean ups. Patches 3-4 add the new UAPI and
> implement PROG_TEST_RUN for sk_lookup. Patch 5 adds a new
> function to libbpf to access multi prog tests. Patches 6-8 add
> tests.
>
> Andrii, for patch 4 I decided on the following API:
>
>     int bpf_prog_test_run_array(__u32 *prog_fds, __u32 prog_fds_cnt,
>                                 struct bpf_test_run_opts *opts)
>
> To be consistent with the rest of libbpf it would be better
> to take int *prog_fds, but I think then the function would have to
> convert the array to account for platforms where
>
>     sizeof(int) != sizeof(__u32)

Curious, is there any supported architecture where this is not the
case? I think it's fine to be consistent, tbh, and use int. Worst
case, in some obscure architecture we'd need to create a copy of an
array. Doesn't seem like a big deal (and highly unlikely anyways).

>
> Please let me know what your preference is.
>
> Lorenz Bauer (8):
>   bpf: consolidate shared test timing code
>   bpf: add for_each_bpf_prog helper
>   bpf: allow multiple programs in BPF_PROG_TEST_RUN
>   bpf: add PROG_TEST_RUN support for sk_lookup programs
>   tools: libbpf: allow testing program types with multi-prog semantics
>   selftests: bpf: convert sk_lookup multi prog tests to PROG_TEST_RUN
>   selftests: bpf: convert sk_lookup ctx access tests to PROG_TEST_RUN
>   selftests: bpf: check that PROG_TEST_RUN repeats as requested
>
>  include/linux/bpf-netns.h                     |   2 +
>  include/linux/bpf.h                           |  24 +-
>  include/linux/filter.h                        |   4 +-
>  include/uapi/linux/bpf.h                      |  11 +-
>  kernel/bpf/net_namespace.c                    |   2 +-
>  kernel/bpf/syscall.c                          |  73 +++++-
>  net/bpf/test_run.c                            | 230 +++++++++++++-----
>  net/core/filter.c                             |   1 +
>  tools/include/uapi/linux/bpf.h                |  11 +-
>  tools/lib/bpf/bpf.c                           |  16 +-
>  tools/lib/bpf/bpf.h                           |   3 +
>  tools/lib/bpf/libbpf.map                      |   1 +
>  .../selftests/bpf/prog_tests/prog_run_xattr.c |  51 +++-
>  .../selftests/bpf/prog_tests/sk_lookup.c      | 172 +++++++++----
>  .../selftests/bpf/progs/test_sk_lookup.c      |  62 +++--
>  15 files changed, 499 insertions(+), 164 deletions(-)
>
> --
> 2.27.0
>
