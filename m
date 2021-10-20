Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 953F2435571
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 23:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231346AbhJTVpb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 17:45:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230181AbhJTVpa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 17:45:30 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF60DC061749;
        Wed, 20 Oct 2021 14:43:15 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id v195so14022100ybb.0;
        Wed, 20 Oct 2021 14:43:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NLxhOL21uFNIWLDSCmZGrluiBbEIb6Tp/0GJSmli5XU=;
        b=ADmPeU5eJwvh3K1oDREWtuXS/3cFrcy8kYa02+JLgbEYJ/j3RQvJexBaCipS3gg+vT
         G/HgJ2eKNg3Rc0qrBmh+Y4uA/2HkLRWw2o7cphSKQdJPEUF6DHnjXfRf0/+73dKHzUvb
         xuIvVlHrW5iatMgPBgrvC5GzCpIq/EuTfSdojiCCITnTHYfKdsJJPqM0sdNq7ed0fhrx
         sEBvgt3Ue6QyB/De3XvYMpzp/bc6I6/DATO7yE0R3j5AI3HUTrS0GtySVkbv1SvM7yQ/
         vNUoKr2jhjSMbbuEIEzCl2SsjXctxG9LlGMfYwmrYwgtHMDBiqg/lGuGqX9LBXDV3vzm
         EsxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NLxhOL21uFNIWLDSCmZGrluiBbEIb6Tp/0GJSmli5XU=;
        b=Ys0xM45Id8O5SFaV01abU5TuNJFVNtrLsjq5HMx7g4J07wXdzPhzxFiNhTnz9LsRM2
         nxj8rZxlYvO5NqfYbVVf8ucVq2zM+1Ul3nM9NPOwMOt0whinlCB7gsXFrnmaMQ5DGRZL
         g0D5c1lBYzX6HdtZY4eTQ/oiH1Ex/5qHsHmDc285+kDBoF4WGL+Sr53adQHB3OAyU1h3
         JujA0UWvAAGUBGuWMHcyDE6GvamiIuXi7PUB4BoCZQrzPQH0S3sBc4O2rqmE0QWGBq+5
         ab60Sn4OEzB8t7WvVqzpftJI/W2xje0H3jcjSY25IqjJJqFndEelqe3Q5ifDDvtxgwF6
         XQ8g==
X-Gm-Message-State: AOAM5310X2q7dJq1zoUgXriQ2qOBWkvUlAQbLemJDui9NG4SZ/yyFIGd
        ngUG6w2KBzSnIvWfkMTU4ykwJX/4vmFln8aVcAM=
X-Google-Smtp-Source: ABdhPJxgXZ85DRGdZhjSufD07NvPT0QRrDJgOWXzfWc+WJOLihVGXYqVDwjMjwvZe/EawZCezVXF1roYX527iOGeGAo=
X-Received: by 2002:a25:d3c8:: with SMTP id e191mr1712702ybf.455.1634766195138;
 Wed, 20 Oct 2021 14:43:15 -0700 (PDT)
MIME-Version: 1.0
References: <20211020082956.8359-1-lmb@cloudflare.com> <20211020082956.8359-3-lmb@cloudflare.com>
In-Reply-To: <20211020082956.8359-3-lmb@cloudflare.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 20 Oct 2021 14:43:04 -0700
Message-ID: <CAEf4BzaRUK3we69HpsFsDYirjQV52w_nb6nY6u-WqhhGR8oBHA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/2] selftests: bpf: test RENAME_EXCHANGE and
 RENAME_NOREPLACE on bpffs
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 20, 2021 at 1:30 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
>
> Add tests to exercise the behaviour of RENAME_EXCHANGE and RENAME_NOREPLACE
> on bpffs. The former checks that after an exchange the inode of two
> directories has changed. The latter checks that the source still exists
> after a failed rename.
>
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> ---
>  .../selftests/bpf/prog_tests/test_bpffs.c     | 39 +++++++++++++++++++
>  1 file changed, 39 insertions(+)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/test_bpffs.c b/tools/testing/selftests/bpf/prog_tests/test_bpffs.c
> index 172c999e523c..9c28ae9589bf 100644
> --- a/tools/testing/selftests/bpf/prog_tests/test_bpffs.c
> +++ b/tools/testing/selftests/bpf/prog_tests/test_bpffs.c
> @@ -1,6 +1,7 @@
>  // SPDX-License-Identifier: GPL-2.0
>  /* Copyright (c) 2020 Facebook */
>  #define _GNU_SOURCE
> +#include <stdio.h>
>  #include <sched.h>
>  #include <sys/mount.h>
>  #include <sys/stat.h>
> @@ -29,6 +30,7 @@ static int read_iter(char *file)
>
>  static int fn(void)
>  {
> +       struct stat a, b;
>         int err, duration = 0;
>
>         err = unshare(CLONE_NEWNS);
> @@ -67,6 +69,43 @@ static int fn(void)
>         err = read_iter(TDIR "/fs2/progs.debug");
>         if (CHECK(err, "reading " TDIR "/fs2/progs.debug", "failed\n"))
>                 goto out;
> +
> +       err = mkdir(TDIR "/fs1/a", 0777);
> +       if (CHECK(err, "creating " TDIR "/fs1/a", "failed\n"))
> +               goto out;
> +       err = mkdir(TDIR "/fs1/a/1", 0777);
> +       if (CHECK(err, "creating " TDIR "/fs1/a/1", "failed\n"))
> +               goto out;
> +       err = mkdir(TDIR "/fs1/b", 0777);
> +       if (CHECK(err, "creating " TDIR "/fs1/b", "failed\n"))
> +               goto out;
> +
> +       /* Check that RENAME_EXCHANGE works. */
> +       err = stat(TDIR "/fs1/a", &a);
> +       if (CHECK(err, "stat(" TDIR "/fs1/a)", "failed\n"))
> +               goto out;
> +       err = renameat2(0, TDIR "/fs1/a", 0, TDIR "/fs1/b", RENAME_EXCHANGE);
> +       if (CHECK(err, "renameat2(RENAME_EXCHANGE)", "failed\n"))
> +               goto out;
> +       err = stat(TDIR "/fs1/b", &b);
> +       if (CHECK(err, "stat(" TDIR "/fs1/b)", "failed\n"))
> +               goto out;
> +       if (CHECK(a.st_ino != b.st_ino, "b should have a's inode", "failed\n"))
> +               goto out;
> +       err = access(TDIR "/fs1/b/1", F_OK);
> +       if (CHECK(err, "access(" TDIR "/fs1/b/1)", "failed\n"))
> +               goto out;
> +
> +       /* Check that RENAME_NOREPLACE works. */
> +       err = renameat2(0, TDIR "/fs1/b", 0, TDIR "/fs1/a", RENAME_NOREPLACE);
> +       if (CHECK(!err, "renameat2(RENAME_NOREPLACE)", "succeeded\n")) {
> +               err = -EINVAL;
> +               goto out;
> +       }
> +       err = access(TDIR "/fs1/b", F_OK);
> +       if (CHECK(err, "access(" TDIR "/fs1/b)", "failed\n"))
> +               goto out;
> +

Please use ASSERT_xxx() for new code.

>  out:
>         umount(TDIR "/fs1");
>         umount(TDIR "/fs2");
> --
> 2.30.2
>
