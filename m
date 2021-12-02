Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6520B465CBD
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 04:31:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235734AbhLBDej (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 22:34:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234054AbhLBDei (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 22:34:38 -0500
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94196C061574
        for <netdev@vger.kernel.org>; Wed,  1 Dec 2021 19:31:16 -0800 (PST)
Received: by mail-yb1-xb2c.google.com with SMTP id f186so69377341ybg.2
        for <netdev@vger.kernel.org>; Wed, 01 Dec 2021 19:31:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4TD+5AK7y3bWvN80d7Vt51weP2uZEOzHmBIeiau2SnQ=;
        b=LZS3AzoB9q3aMpIzOoTAGw4zEMCMyuhdOjXgd29hei/wZHp3AMYyrYJsVb8hcMsnDj
         qJBUtlq+mOSFEIPQdenlLUkh/ic8I1krbesp9Ap9CX7+lqFh+p/DSKoCKGUb3vODrj3t
         JY3wkH60qs9QrX3WNoHC9Tr9Qb1e/8zPzcgXg99ks+PD930cXEE92ur4rOhTQagGYJpZ
         +KTESPQaqeJ1K4+75i2ZtB1uNg4vkd9UsSJvExZosm9Gf03L+GDfcmZ5krmsdRtdwNhK
         kjYdYR85rq9hjpRRG7MZlg8ACBHwf2xGF8G2ldmC84DAQriWVSNWLkS6k8YDLt9nlOLL
         3KiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4TD+5AK7y3bWvN80d7Vt51weP2uZEOzHmBIeiau2SnQ=;
        b=GZwjMa5uxkte2QUJ+UhFeGaG7jLL2rW5s0sOxd+0YhIYd4QZwbKE55HaANz/9UmvYR
         iKV+zoBGOJPukQ1DIzbtPrIyJFtnV0l6cTA5WKbELRK2iYhdkKuMMT6b+EFuZvOm8Oyf
         djbUr3NLaHJY824hpldXSVpnYuhngllpqcmwDGc7UkjIfDdZZa2WJYphsN15pjfbLwH9
         42flVHgE96opPOXgmdlhUf631eOAK4TEJS+wHY8CdyJkLDotrAdQwQlIjiSLhfpKuqpo
         KILsfMmZ8WcstsmL5jNylXoUqPaAr68LkRikJyfHksaukWuB1bne80fpGHDa1Ru8I8gn
         5HaA==
X-Gm-Message-State: AOAM531GNVXK6hLjhSsnG5tTg6C+x6GpeMB69FPiLcFbxOW8lXFZkMNi
        tVRJanK0l1znkTgd3jPwDzS2CtguWY8XJAWPb3/waB0T787afw==
X-Google-Smtp-Source: ABdhPJwJWLDz/sPbsli9PIJucYHs0WotSrWpvptii1+J5cT2uR2lPR7WPj/QpvPNfh3oDbAdlLHNB4KIto+lUBOTkJI=
X-Received: by 2002:a25:760d:: with SMTP id r13mr13349131ybc.296.1638415875334;
 Wed, 01 Dec 2021 19:31:15 -0800 (PST)
MIME-Version: 1.0
References: <20211202032139.3156411-1-eric.dumazet@gmail.com> <20211202032139.3156411-3-eric.dumazet@gmail.com>
In-Reply-To: <20211202032139.3156411-3-eric.dumazet@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 1 Dec 2021 19:31:04 -0800
Message-ID: <CANn89iLP_7YTPMXb99zpNV0M27DUkK2-bY30_-gm2woU7jKPqQ@mail.gmail.com>
Subject: Re: [PATCH net-next 02/19] lib: add tests for reference tracker
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 1, 2021 at 7:21 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
>
> This module uses reference tracker, forcing two issues.
>
> 1) Double free of a tracker
>
> 2) leak of two trackers, one being allocated from softirq context.
>
> "modprobe test_ref_tracker" would emit the following traces.
> (Use scripts/decode_stacktrace.sh if necessary)
>
> [

> Signed-off-by: Eric Dumazet <edumazet@google.com>
> ---
>  lib/Kconfig.debug      |  10 ++++
>  lib/Makefile           |   2 +-
>  lib/test_ref_tracker.c | 116 +++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 127 insertions(+), 1 deletion(-)
>  create mode 100644 lib/test_ref_tracker.c
>
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index 5c12bde10996cf97b5f075d318089b1be73f71d7..d005f555872147e15d3e0a65d2a03e1a5c44f5f0 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -2106,6 +2106,16 @@ config BACKTRACE_SELF_TEST
>
>           Say N if you are unsure.
>
> +config TEST_REF_TRACKER
> +       tristate "Self test for reference tracker"
> +       depends on DEBUG_KERNEL
> +       select REF_TRACKER
> +       help
> +         This option provides a kernel module performing tests
> +         using reference tracker infrastructure.
> +
> +         Say N if you are unsure.
> +
>  config RBTREE_TEST
>         tristate "Red-Black tree test"
>         depends on DEBUG_KERNEL
> diff --git a/lib/Makefile b/lib/Makefile
> index c1fd9243ddb9cc1ac5252d7eb8009f9290782c4a..b213a7bbf3fda2eb9f234fb7473b8f1b617bed6b 100644
> --- a/lib/Makefile
> +++ b/lib/Makefile
> @@ -101,7 +101,7 @@ obj-$(CONFIG_TEST_LOCKUP) += test_lockup.o
>  obj-$(CONFIG_TEST_HMM) += test_hmm.o
>  obj-$(CONFIG_TEST_FREE_PAGES) += test_free_pages.o
>  obj-$(CONFIG_KPROBES_SANITY_TEST) += test_kprobes.o
> -
> +obj-$(CONFIG_TEST_REF_TRACKER) += test_ref_tracker.o
>  #
>  # CFLAGS for compiling floating point code inside the kernel. x86/Makefile turns
>  # off the generation of FPU/SSE* instructions for kernel proper but FPU_FLAGS
> diff --git a/lib/test_ref_tracker.c b/lib/test_ref_tracker.c
> new file mode 100644
> index 0000000000000000000000000000000000000000..73bf9255e03790fa50491fe8e5cd411d54827c45
> --- /dev/null
> +++ b/lib/test_ref_tracker.c
> @@ -0,0 +1,116 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Referrence tracker self test.
> + *
> + * Copyright (c) 2021 Eric Dumazet <edumazet@google.com>
> + */
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/delay.h>
> +#include <linux/ref_tracker.h>
> +#include <linux/slab.h>
> +#include <linux/timer.h>
> +
> +static struct ref_tracker_dir ref_dir;
> +static struct ref_tracker *tracker[20];
> +
> +#define TRT_ALLOC(X) static noinline void                                      \
> +       alloctest_ref_tracker_alloc##X(struct ref_tracker_dir *dir,     \
> +                                   struct ref_tracker **trackerp)      \
> +       {                                                               \
> +               ref_tracker_alloc(dir, trackerp, GFP_KERNEL);           \
> +       }
> +
> +TRT_ALLOC(0)
> +TRT_ALLOC(1)
> +TRT_ALLOC(2)
> +TRT_ALLOC(3)
> +TRT_ALLOC(4)
> +TRT_ALLOC(5)
> +TRT_ALLOC(6)
> +TRT_ALLOC(7)
> +TRT_ALLOC(8)
> +TRT_ALLOC(9)
> +TRT_ALLOC(10)
> +TRT_ALLOC(11)
> +TRT_ALLOC(12)
> +TRT_ALLOC(13)
> +TRT_ALLOC(14)
> +TRT_ALLOC(15)
> +TRT_ALLOC(16)
> +TRT_ALLOC(17)
> +TRT_ALLOC(18)
> +TRT_ALLOC(19)
> +
> +#undef TRT_ALLOC
> +
> +static noinline void
> +alloctest_ref_tracker_free(struct ref_tracker_dir *dir,
> +                          struct ref_tracker **trackerp)
> +{
> +       ref_tracker_free(dir, trackerp);
> +}
> +
> +
> +static struct timer_list test_ref_tracker_timer;
> +static atomic_t test_ref_timer_done = ATOMIC_INIT(0);
> +
> +static void test_ref_tracker_timer_func(struct timer_list *t)
> +{
> +       alloctest_ref_tracker_alloc0(&ref_dir, &tracker[0]);

This will be changed to use GFP_ATOMIC instead of GFP_KERNEL

          ref_tracker_alloc(&ref_dir, ..., GFP_ATOMIC);

> +       atomic_set(&test_ref_timer_done, 1);
> +}
> +
>
