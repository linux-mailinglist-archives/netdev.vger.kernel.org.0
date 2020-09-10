Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CCEB2654F8
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 00:22:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725769AbgIJWW2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 18:22:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725294AbgIJWWW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 18:22:22 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56EA3C061573;
        Thu, 10 Sep 2020 15:22:22 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id e11so1981678ybk.1;
        Thu, 10 Sep 2020 15:22:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Z+A4SCNAFToljw8w/XJH2Ymoq34r4ypOMBE3039GCcY=;
        b=GswCUB/wYIG+bQGbNur7KU4RAtzAa+5GwmmsmqPqhID0klUmwcIPjQJXRJnz+FR2Fl
         UU08JgoiquXePP3oh1InBFquIr78WAIu6Z4C9tm+mMZ3S4Ke7n+Q4UYwL04OtX5pWAZ9
         upDaIQFqz7/ewKqnrp6A6aMOOzQZJXpNnEYWMzXPPXzHmPYjOs4FQu7jlCiEU1pLyARX
         W72EY2YKpNJhpIjrGmEKrWBY7mQ2fYKZIviz82CPc2AgmBXOh5XxT7YN/lGyxF7lwIaB
         bJ+vesIbkFXftslFjQ5o7kc3/PiS5Dsz9K2wpG36x1a3KnJtnnRiBPy0dkOSM+gYiJPK
         B6jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Z+A4SCNAFToljw8w/XJH2Ymoq34r4ypOMBE3039GCcY=;
        b=g/+AZkSx5OaymCW9vZCUEB5oNo7JfAXZzFzZHFccW7qYPDXPGvmnO1Uj3u7zAjLEb7
         UrQwMOkOAadts++hdnOReSxhAWTGbXha+oYammbIdhiLv1efiH3R+cU/EIefDTc+12LX
         csfa2Ij/WGfjeRlGQHptTgLb+FOFqE3PDLC55VAeznApmm/awbzZm0ZojDTpLs0+ZNHb
         Mj48uaxJcq6JcwJhKyjx1q0BpmrmGY9AAmWXy7ecpcipQIP8WYIDFlnV2yszlli5hWkV
         iAhxc0IrhJrnr0bUhYwTY39zgaNl2ciyPNpLoogaPMdpy4/ECYQuuMqXPuyNVHAuCct6
         6gFw==
X-Gm-Message-State: AOAM530j/TZRNTRe7bdQfv6UNkluLllsW6DkNKvc096/Bvi47I4k6INB
        L1p+XsfDNlTtFzJgWehrxKoj4Cchz0XknWvHEGc=
X-Google-Smtp-Source: ABdhPJxOkyBIjcvJ8q21FaDnMqdsx2F8RfxM90h2Ivq4wFUFBDJWeUsv9xyhVWup6sGcrscWrYAW4oKT58GhHKQmE5g=
X-Received: by 2002:a25:e655:: with SMTP id d82mr17256744ybh.347.1599776541456;
 Thu, 10 Sep 2020 15:22:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200910122224.1683258-1-jolsa@kernel.org>
In-Reply-To: <20200910122224.1683258-1-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 10 Sep 2020 15:22:10 -0700
Message-ID: <CAEf4BzbVT+DmjPXLrcFG0ZFMCw0P_cb0W9abiaygfBAFu+nh7Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: Check trampoline execution in
 d_path test
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 10, 2020 at 5:25 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Some kernels builds might inline vfs_getattr call within
> fstat syscall code path, so fentry/vfs_getattr trampoline
> is not called.
>
> I'm not sure how to handle this in some generic way other
> than use some other function, but that might get inlined at
> some point as well.
>
> Adding flags that indicate trampolines were called and failing
> the test if neither of them got called.
>
>   $ sudo ./test_progs -t d_path
>   test_d_path:PASS:setup 0 nsec
>   ...
>   trigger_fstat_events:PASS:trigger 0 nsec
>   test_d_path:FAIL:124 trampolines not called
>   #22 d_path:FAIL
>   Summary: 0/0 PASSED, 0 SKIPPED, 1 FAILED
>
> If only one trampoline is called, it's still enough to test
> the helper, so only warn about missing trampoline call and
> continue in test.
>
>   $ sudo ./test_progs -t d_path -v
>   test_d_path:PASS:setup 0 nsec
>   ...
>   trigger_fstat_events:PASS:trigger 0 nsec
>   fentry/vfs_getattr not called
>   #22 d_path:OK
>   Summary: 1/0 PASSED, 0 SKIPPED, 0 FAILED
>
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  .../testing/selftests/bpf/prog_tests/d_path.c | 25 +++++++++++++++----
>  .../testing/selftests/bpf/progs/test_d_path.c |  7 ++++++
>  2 files changed, 27 insertions(+), 5 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/d_path.c b/tools/testing/selftests/bpf/prog_tests/d_path.c
> index fc12e0d445ff..ec15f7d1dd0a 100644
> --- a/tools/testing/selftests/bpf/prog_tests/d_path.c
> +++ b/tools/testing/selftests/bpf/prog_tests/d_path.c
> @@ -120,26 +120,41 @@ void test_d_path(void)
>         if (err < 0)
>                 goto cleanup;
>
> +       if (!bss->called_stat && !bss->called_close) {
> +               PRINT_FAIL("trampolines not called\n");
> +               goto cleanup;
> +       }
> +
> +       if (!bss->called_stat) {
> +               fprintf(stdout, "fentry/vfs_getattr not called\n");
> +               goto cleanup;
> +       }
> +
> +       if (!bss->called_close) {
> +               fprintf(stdout, "fentry/filp_close not called\n");
> +               goto cleanup;
> +       }

not sure why you didn't go with `if (CHECK(!bss->called_close, ...`
for these checks, would even save you some typing.

> +
>         for (int i = 0; i < MAX_FILES; i++) {
> -               CHECK(strncmp(src.paths[i], bss->paths_stat[i], MAX_PATH_LEN),
> +               CHECK(bss->called_stat && strncmp(src.paths[i], bss->paths_stat[i], MAX_PATH_LEN),
>                       "check",
>                       "failed to get stat path[%d]: %s vs %s\n",
>                       i, src.paths[i], bss->paths_stat[i]);
> -               CHECK(strncmp(src.paths[i], bss->paths_close[i], MAX_PATH_LEN),
> +               CHECK(bss->called_close && strncmp(src.paths[i], bss->paths_close[i], MAX_PATH_LEN),
>                       "check",
>                       "failed to get close path[%d]: %s vs %s\n",
>                       i, src.paths[i], bss->paths_close[i]);
>                 /* The d_path helper returns size plus NUL char, hence + 1 */
> -               CHECK(bss->rets_stat[i] != strlen(bss->paths_stat[i]) + 1,
> +               CHECK(bss->called_stat && bss->rets_stat[i] != strlen(bss->paths_stat[i]) + 1,
>                       "check",
>                       "failed to match stat return [%d]: %d vs %zd [%s]\n",
>                       i, bss->rets_stat[i], strlen(bss->paths_stat[i]) + 1,
>                       bss->paths_stat[i]);
> -               CHECK(bss->rets_close[i] != strlen(bss->paths_stat[i]) + 1,
> +               CHECK(bss->called_close && bss->rets_close[i] != strlen(bss->paths_close[i]) + 1,
>                       "check",
>                       "failed to match stat return [%d]: %d vs %zd [%s]\n",
>                       i, bss->rets_close[i], strlen(bss->paths_close[i]) + 1,
> -                     bss->paths_stat[i]);
> +                     bss->paths_close[i]);


those `bss->called_xxx` guard conditions are a bit lost on reading, if
you reordered CHECKs, you could be more explicit:

if (bss->called_stat) {
    CHECK(...);
    CHECK(...);
}
if (bss->called_close) { ... }

>         }
>
>  cleanup:
> diff --git a/tools/testing/selftests/bpf/progs/test_d_path.c b/tools/testing/selftests/bpf/progs/test_d_path.c
> index 61f007855649..9e7223b4a555 100644
> --- a/tools/testing/selftests/bpf/progs/test_d_path.c
> +++ b/tools/testing/selftests/bpf/progs/test_d_path.c
> @@ -15,6 +15,9 @@ char paths_close[MAX_FILES][MAX_PATH_LEN] = {};
>  int rets_stat[MAX_FILES] = {};
>  int rets_close[MAX_FILES] = {};
>
> +int called_stat = 0;
> +int called_close = 0;
> +
>  SEC("fentry/vfs_getattr")
>  int BPF_PROG(prog_stat, struct path *path, struct kstat *stat,
>              __u32 request_mask, unsigned int query_flags)
> @@ -23,6 +26,8 @@ int BPF_PROG(prog_stat, struct path *path, struct kstat *stat,
>         __u32 cnt = cnt_stat;
>         int ret;
>
> +       called_stat = 1;
> +
>         if (pid != my_pid)
>                 return 0;
>
> @@ -42,6 +47,8 @@ int BPF_PROG(prog_close, struct file *file, void *id)
>         __u32 cnt = cnt_close;
>         int ret;
>
> +       called_close = 1;
> +
>         if (pid != my_pid)
>                 return 0;
>
> --
> 2.26.2
>
