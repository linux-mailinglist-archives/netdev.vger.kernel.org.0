Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99E203A0BE9
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 07:40:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232569AbhFIFms (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 01:42:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230222AbhFIFmq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 01:42:46 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EE40C061574;
        Tue,  8 Jun 2021 22:40:38 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id b9so33754463ybg.10;
        Tue, 08 Jun 2021 22:40:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JhP8q7gH6T1QZhg5tj7w+ML430D5qQoWl2aC33J1NnM=;
        b=mT00yE2e8KGXmVYXaJGrFJ0Nosk36UnPglFNEGdW+hcdAeMNlG68f4SU2uCVMjmW5B
         /CqDzii1qrLUH50bD293qgXR3hR5udDJyco5our9NHdQiYjg2s54ceXTRpKVWHL7XZ/r
         ErjChBc3PA8GqPW7hW2n3+cHeIqqrb8Dp69n/fm7AWflpOIWMvlJZy5jY5+p2SuXh3V/
         Yov0BItDw6GiAT3a/a6KA7jPboPAb+0mpN5T8q+fkkj+QvEnN0ytIu+5bPQX6BGsWvEI
         i4SHaOZMduZtNRTBvMJG0IcfaP4zQbUILgb8d6mBPbN7kkkVFG0+188nQ0MuCq+RL0z4
         ymjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JhP8q7gH6T1QZhg5tj7w+ML430D5qQoWl2aC33J1NnM=;
        b=G6RwVF0NEz1P4Ei2i+F7KMJ43HTKrxuxrhdsXDjiCA/+fWbKbnUMC5GYsdYIKz9lmk
         FPGdrlYbRlHu5fkiNWXFBOavWVHXAXOPAPiE+Df9xnDLrNPoB1+ZnOMNXDdXLdgjiVkD
         fvpRY8vDHdVUv3YV3gJvTQQcyIYAX90ZNxKZrTNFVAgb8qKaIZfny0RztpFAT0hvJAhO
         pOAt/95NXCdGmozzhNCo8JPMVmkYgJ6aC9h5Y3mmc0p4xWGZe480ieYab593vTqF7AVt
         pB+WoHRXAwwoHdm7n+uY/WCsiNYk0mRjViSgSYzaY9veilhVKbx45Fe/nYo8wZyApyGm
         Axug==
X-Gm-Message-State: AOAM531qZS1Vom/y+IIvAroGCBKZwvP3yGV4alvp4MsKYuwJySGAI1PT
        6aNpWmPt4R+f4vnhBSBK94elBK4t0I4zyNk0Tng=
X-Google-Smtp-Source: ABdhPJxWQgbgN4XgdV2w6XaEHN5nUybeCDhn8QbiFx2Bh8EA3wyG56n3/A3pHR/GKW16YqihwQQ+f2LoVsiiKixW7Ag=
X-Received: by 2002:a25:4182:: with SMTP id o124mr35885933yba.27.1623217235197;
 Tue, 08 Jun 2021 22:40:35 -0700 (PDT)
MIME-Version: 1.0
References: <20210605111034.1810858-1-jolsa@kernel.org> <20210605111034.1810858-17-jolsa@kernel.org>
In-Reply-To: <20210605111034.1810858-17-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 8 Jun 2021 22:40:24 -0700
Message-ID: <CAEf4BzbBGB+hm0LJRUWDi1EXRkbj86FDOt_ZHdQbT=za47p9ZA@mail.gmail.com>
Subject: Re: [PATCH 16/19] selftests/bpf: Add fentry multi func test
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Viktor Malik <vmalik@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 5, 2021 at 4:12 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Adding selftest for fentry multi func test that attaches
> to bpf_fentry_test* functions and checks argument values
> based on the processed function.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  tools/testing/selftests/bpf/multi_check.h     | 52 +++++++++++++++++++
>  .../bpf/prog_tests/fentry_multi_test.c        | 43 +++++++++++++++
>  .../selftests/bpf/progs/fentry_multi_test.c   | 18 +++++++
>  3 files changed, 113 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/multi_check.h
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/fentry_multi_test.c
>  create mode 100644 tools/testing/selftests/bpf/progs/fentry_multi_test.c
>
> diff --git a/tools/testing/selftests/bpf/multi_check.h b/tools/testing/selftests/bpf/multi_check.h
> new file mode 100644
> index 000000000000..36c2a93f9be3
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/multi_check.h

we have a proper static linking now, we don't have to use header
inclusion hacks, let's do this properly?

> @@ -0,0 +1,52 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +#ifndef __MULTI_CHECK_H
> +#define __MULTI_CHECK_H
> +
> +extern unsigned long long bpf_fentry_test[8];
> +
> +static __attribute__((unused)) inline
> +void multi_arg_check(unsigned long ip, __u64 a, __u64 b, __u64 c, __u64 d, __u64 e, __u64 f, __u64 *test_result)
> +{
> +       if (ip == bpf_fentry_test[0]) {
> +               *test_result += (int) a == 1;
> +       } else if (ip == bpf_fentry_test[1]) {
> +               *test_result += (int) a == 2 && (__u64) b == 3;
> +       } else if (ip == bpf_fentry_test[2]) {
> +               *test_result += (char) a == 4 && (int) b == 5 && (__u64) c == 6;
> +       } else if (ip == bpf_fentry_test[3]) {
> +               *test_result += (void *) a == (void *) 7 && (char) b == 8 && (int) c == 9 && (__u64) d == 10;
> +       } else if (ip == bpf_fentry_test[4]) {
> +               *test_result += (__u64) a == 11 && (void *) b == (void *) 12 && (short) c == 13 && (int) d == 14 && (__u64) e == 15;
> +       } else if (ip == bpf_fentry_test[5]) {
> +               *test_result += (__u64) a == 16 && (void *) b == (void *) 17 && (short) c == 18 && (int) d == 19 && (void *) e == (void *) 20 && (__u64) f == 21;
> +       } else if (ip == bpf_fentry_test[6]) {
> +               *test_result += 1;
> +       } else if (ip == bpf_fentry_test[7]) {
> +               *test_result += 1;
> +       }

why not use switch? and why the casting?

> +}
> +

[...]

> diff --git a/tools/testing/selftests/bpf/progs/fentry_multi_test.c b/tools/testing/selftests/bpf/progs/fentry_multi_test.c
> new file mode 100644
> index 000000000000..a443fc958e5a
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/fentry_multi_test.c
> @@ -0,0 +1,18 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <linux/bpf.h>
> +#include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_tracing.h>
> +#include "multi_check.h"
> +
> +char _license[] SEC("license") = "GPL";
> +
> +unsigned long long bpf_fentry_test[8];
> +
> +__u64 test_result = 0;
> +
> +SEC("fentry.multi/bpf_fentry_test*")

wait, that's a regexp syntax that libc supports?.. Not .*? We should
definitely not provide btf__find_by_pattern_kind() API, I'd like to
avoid explaining what flavors of regexps libbpf supports.

> +int BPF_PROG(test, unsigned long ip, __u64 a, __u64 b, __u64 c, __u64 d, __u64 e, __u64 f)
> +{
> +       multi_arg_check(ip, a, b, c, d, e, f, &test_result);
> +       return 0;
> +}
> --
> 2.31.1
>
