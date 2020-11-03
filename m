Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEB3E2A4E3E
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 19:19:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729217AbgKCSTU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 13:19:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729170AbgKCSTR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 13:19:17 -0500
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6F57C0613D1;
        Tue,  3 Nov 2020 10:19:17 -0800 (PST)
Received: by mail-yb1-xb41.google.com with SMTP id s89so15634010ybi.12;
        Tue, 03 Nov 2020 10:19:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+MnVRGp1lkEU8jeFVY9M5pC4CJoPd8hOwGMGI5wGX8Y=;
        b=NLt5+QMBlK6xmkhKZ9Pd3e1QjMZ6sQPK4is1SEZ/HHMZt2FdrPMBZopSM4drn+pENV
         Al09VYjPrBSq6VSOO6VetvscwLEv2J7YmUKRCczB94YLbv+EZRBHOL10odCv6X6EvcZ5
         ZZK2mBrRMPXyvOxFpnIqsdZHmZvwY8bdiewMpGWLCrYcJ4aX/Yh0VycyY71TAifeGXpY
         CH5vYQet1zsFoCOy2Qi8krVQLLOpM8q8EPI2Mxgn3POO0W+Cfbg0dJBnavm67AP5p3ZT
         71NXSnE6O9x0ScCgr09WofAxfvilC1tIOpxzFsnGt6ysEb5GmDg8OAhjI+Q02SYTXQcl
         CQgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+MnVRGp1lkEU8jeFVY9M5pC4CJoPd8hOwGMGI5wGX8Y=;
        b=BKwvwFKnoLwJyNhovqger1RX045DmLgNw0YHavpZva0K77JvGh1gAvzDCD/0yQbhwj
         Ert4WGBjMY5hCshwaGZbNeMbuCxv9V4kf4bWShjszZWYn9TPYO5dsxP9jt+S2vLxxcLj
         ch0r0J3/StWvOavgQfTh6QJLHAnQg6q85dAXBtpNijHajJPlxEIlcej6MikdyNDsTpuS
         mBMGjFQWDKORVzCYpuztIBxxFJGv8i2V2Kjh+x+NoCrFbchjKlBvyvwuVxr/Ws/X6GvB
         khjhwm1RPh4t6BJCfgMtmbvIvQJJm+FGT1ttz8Ph2QHWtxUjWaHEeNTa1kS+Rh9CP5HR
         BVAw==
X-Gm-Message-State: AOAM530jmMeth8ug8iHoqKnu12fA1xA5xlzDiW2LutHB+5Yd+F70Kk88
        TMHxIISC855sK2Bm8OufI1rmJpWB7xrO7CbGsycvLFcLPdIsQw==
X-Google-Smtp-Source: ABdhPJzH7EixjMFatBDaUL1G/hXUSJa9a+R9KPXKbC+OBmV+WDHem73Isk6SQd9U+WpGdl6auIjdqx5elKEfn1nnWZg=
X-Received: by 2002:a25:c001:: with SMTP id c1mr28393208ybf.27.1604427557002;
 Tue, 03 Nov 2020 10:19:17 -0800 (PST)
MIME-Version: 1.0
References: <20201027221324.27894-1-david.verbeiren@tessares.net> <20201103154738.29809-1-david.verbeiren@tessares.net>
In-Reply-To: <20201103154738.29809-1-david.verbeiren@tessares.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 3 Nov 2020 10:19:06 -0800
Message-ID: <CAEf4Bzajj+1Kh+YcWH2K0i21ZGM7q=gt6EXGY_YsFwTcmt0nKw@mail.gmail.com>
Subject: Re: [PATCH bpf v3] bpf: zero-fill re-used per-cpu map element
To:     David Verbeiren <david.verbeiren@tessares.net>
Cc:     bpf <bpf@vger.kernel.org>, Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, Song Liu <song@kernel.org>,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 3, 2020 at 7:49 AM David Verbeiren
<david.verbeiren@tessares.net> wrote:
>
> Zero-fill element values for all other cpus than current, just as
> when not using prealloc. This is the only way the bpf program can
> ensure known initial values for all cpus ('onallcpus' cannot be
> set when coming from the bpf program).
>
> The scenario is: bpf program inserts some elements in a per-cpu
> map, then deletes some (or userspace does). When later adding
> new elements using bpf_map_update_elem(), the bpf program can
> only set the value of the new elements for the current cpu.
> When prealloc is enabled, previously deleted elements are re-used.
> Without the fix, values for other cpus remain whatever they were
> when the re-used entry was previously freed.
>
> A selftest is added to validate correct operation in above
> scenario as well as in case of LRU per-cpu map element re-use.
>
> Fixes: 6c9059817432 ("bpf: pre-allocate hash map elements")
> Acked-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> Signed-off-by: David Verbeiren <david.verbeiren@tessares.net>
> ---
>

Tests look really nice, thanks! I'm worried about still racy once
check, see suggestions below. Otherwise looks great!

> Notes:
>     v3:
>       - Added selftest that was initially provided as separate
>         patch, and reworked to
>         * use skeleton (Andrii, Song Liu)
>         * skip test if <=1 CPU (Song Liu)
>
>     v2:
>       - Moved memset() to separate pcpu_init_value() function,
>         which replaces pcpu_copy_value() but delegates to it
>         for the cases where no memset() is needed (Andrii).
>       - This function now also avoids doing the memset() for
>         the current cpu for which the value must be set
>         anyhow (Andrii).
>       - Same pcpu_init_value() used for per-cpu LRU map
>         (Andrii).
>
>  kernel/bpf/hashtab.c                          |  30 ++-
>  .../selftests/bpf/prog_tests/map_init.c       | 213 ++++++++++++++++++
>  .../selftests/bpf/progs/test_map_init.c       |  34 +++
>  3 files changed, 275 insertions(+), 2 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/map_init.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_map_init.c
>

[...]

> diff --git a/tools/testing/selftests/bpf/prog_tests/map_init.c b/tools/testing/selftests/bpf/prog_tests/map_init.c
> new file mode 100644
> index 000000000000..386d9439bad9
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/map_init.c
> @@ -0,0 +1,213 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +// Copyright (c) 2020 Tessares SA <http://www.tessares.net>
> +

nit: see below, /* */

> +#include <test_progs.h>
> +#include "test_map_init.skel.h"
> +

[...]

> diff --git a/tools/testing/selftests/bpf/progs/test_map_init.c b/tools/testing/selftests/bpf/progs/test_map_init.c
> new file mode 100644
> index 000000000000..280a45e366d6
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_map_init.c
> @@ -0,0 +1,34 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// Copyright (c) 2020 Tessares SA <http://www.tessares.net>

nit: I think copyright line has to be in /* */ comment block

> +
> +#include "vmlinux.h"
> +#include <bpf/bpf_helpers.h>
> +
> +__u64 inKey = 0;
> +__u64 inValue = 0;
> +__u32 once = 0;
> +
> +struct {
> +       __uint(type, BPF_MAP_TYPE_PERCPU_HASH);
> +       __uint(max_entries, 2);
> +       __type(key, __u64);
> +       __type(value, __u64);
> +} hashmap1 SEC(".maps");
> +
> +
> +SEC("raw_tp/sys_enter")
> +int sys_enter(const void *ctx)
> +{
> +       /* Just do it once so the value is only updated for a single CPU.
> +        * Indeed, this tracepoint will quickly be hit from different CPUs.
> +        */
> +       if (!once) {
> +               __sync_fetch_and_add(&once, 1);

This is quite racy, actually, especially for the generic sys_enter
tracepoint. The way I did this before (see progs/trigger_bench.c) was
through doing a "tp/syscalls/sys_enter_getpgid" tracepoint program and
checking for thread id. Or you can use bpf_test_run, probably, with a
different type of BPF program. I just find bpf_test_run() too
inconvenient with all the extra setup, so I usually stick to
tracepoints.

> +
> +               bpf_map_update_elem(&hashmap1, &inKey, &inValue, BPF_NOEXIST);
> +       }
> +
> +       return 0;
> +}
> +
> +char _license[] SEC("license") = "GPL";
> --
> 2.29.0
>
