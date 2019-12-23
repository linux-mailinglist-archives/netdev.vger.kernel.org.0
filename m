Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BFFD1291F8
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 07:36:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726028AbfLWGgA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 01:36:00 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:40646 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725811AbfLWGgA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 01:36:00 -0500
Received: by mail-qk1-f194.google.com with SMTP id c17so12781493qkg.7;
        Sun, 22 Dec 2019 22:35:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0DzjFSTk4GUARqFpDM4bTgDw2bbAI+/uJbZ7VnbMQBM=;
        b=k9SUps3bztjSi0wnFJmvXha09GFyi7e/mLC2GiTwovXmG3H8TZn49UpjMv4QPBsmYM
         v4Aw/1e2M00sEQwIQA00KtPxxwhD5mFNbisb/6cfhtxL5PmbwbWNqLv5P4Wzs2Rnmd4Q
         79jJV316crdBAsLkoons6YqYHwgXPteVrP6HjpwmlKPRW7fc1kVVJ80b6wDu5ijXk3r1
         Uzkj3Ju15esmX7j4q8CpYupcHO7LlYyrbfiiQeybklpjUJVO2LpNQbeD7b9LAQO1g5PI
         qJLLAu1tWyo18Z7RrT82q+v8dfDf8f/KUdI2GkgU9hNwpAinQpdYcsNrqFtRt6bRBwfL
         F+Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0DzjFSTk4GUARqFpDM4bTgDw2bbAI+/uJbZ7VnbMQBM=;
        b=VRAMhfmwxbytMK69Yx1haUyymPbNxq75v559MhTNtyzgNPR8dTidSo9rD8/sl80WLA
         Mu6iL3H0oxjgJvLdl7Ro/gGN+0RK1X2ZrRN1KE609/mdiCk8zIjLRB0URUdvrp6QN5b+
         dsLDgzI7Bu6g2Tw2QpH12sCcfeIhVTencBoLgKwWLn8XRWojpg+byRSoStAMmHDmBhWp
         mtvNGgugHIrIW7rgiZd4NeperrBpkUefg7TRWHoDdoUNvAapq4oEDuVQ8V1XEWNlykcq
         pb99I2wrvWLnm+Hs4pxs70eqGaGPBMjv+pNpgJ4GgcOhFNJFv88Vha9JHajKOTF5SAAW
         +JGg==
X-Gm-Message-State: APjAAAVC/KFzqR9fPqUfSObJHvzbIqKvznYRQc+9N6iLGYJaDgb504Fm
        rAusfD05sWjTjFG0t3nR13vQzrqhSsJdWEh9Os0hvKy+
X-Google-Smtp-Source: APXvYqztFGJq3WP4/JkaL+PY/hOKDdmLZ/j+qBS59+0z43ikGnU6aLOKmC/NbEcSCFwrzAJ+i9jkTknQ50oZNYlOvvE=
X-Received: by 2002:a37:e408:: with SMTP id y8mr24666444qkf.39.1577082558207;
 Sun, 22 Dec 2019 22:29:18 -0800 (PST)
MIME-Version: 1.0
References: <CAM9d7ch1=pmgkFbgGr2YignQwdNjke2QeOAFLCFYu8L8J-Z8vw@mail.gmail.com>
 <20191223061326.843366-1-namhyung@kernel.org>
In-Reply-To: <20191223061326.843366-1-namhyung@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sun, 22 Dec 2019 22:29:07 -0800
Message-ID: <CAEf4BzY1HvhkPzR1HE7-reGhfZnfySe-LxQ-5MS7Nx-Uv4oVug@mail.gmail.com>
Subject: Re: [PATCH bpf v3] libbpf: Fix build on read-only filesystems
To:     Namhyung Kim <namhyung@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        bpf <bpf@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 22, 2019 at 10:14 PM Namhyung Kim <namhyung@kernel.org> wrote:
>
> I got the following error when I tried to build perf on a read-only
> filesystem with O=dir option.
>
>   $ cd /some/where/ro/linux/tools/perf
>   $ make O=$HOME/build/perf
>   ...
>     CC       /home/namhyung/build/perf/lib.o
>   /bin/sh: bpf_helper_defs.h: Read-only file system
>   make[3]: *** [Makefile:184: bpf_helper_defs.h] Error 1
>   make[2]: *** [Makefile.perf:778: /home/namhyung/build/perf/libbpf.a] Error 2
>   make[2]: *** Waiting for unfinished jobs....
>     LD       /home/namhyung/build/perf/libperf-in.o
>     AR       /home/namhyung/build/perf/libperf.a
>     PERF_VERSION = 5.4.0
>   make[1]: *** [Makefile.perf:225: sub-make] Error 2
>   make: *** [Makefile:70: all] Error 2
>
> It was becaused bpf_helper_defs.h was generated in current directory.
> Move it to OUTPUT directory.
>
> Tested-by: Andrii Nakryiko <andriin@fb.com>
> Acked-by: Andrii Nakryiko <andriin@fb.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/lib/bpf/Makefile                 | 15 ++++++++-------
>  tools/testing/selftests/bpf/.gitignore |  1 +
>  tools/testing/selftests/bpf/Makefile   |  6 +++---
>  3 files changed, 12 insertions(+), 10 deletions(-)
>

[...]

> diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/selftests/bpf/.gitignore
> index 419652458da4..1ff0a9f49c01 100644
> --- a/tools/testing/selftests/bpf/.gitignore
> +++ b/tools/testing/selftests/bpf/.gitignore
> @@ -40,3 +40,4 @@ xdping
>  test_cpp
>  /no_alu32
>  /bpf_gcc
> +bpf_helper_defs.h

looks good, thanks!

[...]
