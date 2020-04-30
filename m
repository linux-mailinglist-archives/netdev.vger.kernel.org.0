Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A83C1BF09C
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 08:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbgD3Gzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 02:55:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726358AbgD3Gzi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 02:55:38 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0605C035494;
        Wed, 29 Apr 2020 23:55:38 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id p13so2469231qvt.12;
        Wed, 29 Apr 2020 23:55:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XuyijJFgqu+UnV4YQxHBc4Ey7rEQnv9T0JtGpYNNon4=;
        b=romEJsf4xzAdVXHad7w7d+Ypu6f/jj9fF4JrCe93gXJrzHbJ2B4HjI2XE5vQWA+uE4
         klxyJ02DnApVVKZh14M1aZEEkNVvIyLbU/HLk89Ob+DUcKBtbWHSZXrW9q/G1mGgZECI
         6qT7zq/boTKVUhKr2Ob+a0/KZzuFK0TxyZPJGU7e8Dca4RAmFwlybbN+gjA+RRjCrqZt
         sbvKn4YArKzCjLheAvFVkwayxiVhfJrtVJHbt8R4DmxGSwR2ONqkcnFNrR3YQNUb1O5p
         mH+3s/m142CUasroQfmsFLIMdM53zXnvWwzuwSokVWb6roPS1sqlVRP9gQcl/gpKJppO
         UCmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XuyijJFgqu+UnV4YQxHBc4Ey7rEQnv9T0JtGpYNNon4=;
        b=jm6+ykuvu/nFwABqgV4WdjSKqhSAX8bsmWeZ2H+bKFpQlltKNPldqea+jjthDuqgEi
         0HFjMN6xn74bxYiYmw2fWG+U0R9uYu1sc+a7wcNpfx+yXnLuXe0qFoubjvnmQ6kuavH3
         BnRQsPk9oeuCbAg2h2szffPnDCrotkWPHiA2oXs/dgDcxEy5/cAy4vHjvhLXxCs1YJvf
         1Y//Z4UIeyT6N00wg/ayTwqi5JRr2bdZgkysH0qi/VHJo9bEgkymNmwV2GjPWHYbmJi1
         +Q3lyGFa74n+neeggHlnz7rhqDJZED9e5qpd4UDMSTAq6AaENTgBa9pFV/q9KGQh5iF5
         9F/w==
X-Gm-Message-State: AGi0PubaJlq/XVHoP0M3gkt5AO0dpHLMpZ4yT+/Ld3DhFsSSHn/bV9WP
        c8HReaxw1LsrYOCTKJ+VJHVWvfQrL0mEe3V+zuI=
X-Google-Smtp-Source: APiQypJ3biDM9QactItKFUW7x3hGoiUG3ZSlO2VJHlg1x1VSvy8oXODesJCZrDEEDGahjt8akT783fIzfnyyY0APCaw=
X-Received: by 2002:a0c:eb09:: with SMTP id j9mr1598588qvp.196.1588229737867;
 Wed, 29 Apr 2020 23:55:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200429064543.634465-1-songliubraving@fb.com>
 <20200429064543.634465-4-songliubraving@fb.com> <CAEf4BzZNbBhfS0Hxmn6Fu5+-SzxObS0w9KhMSrLz23inWVSuYQ@mail.gmail.com>
 <C9DC5EF9-0DEE-4952-B7CA-64153C8D8850@fb.com>
In-Reply-To: <C9DC5EF9-0DEE-4952-B7CA-64153C8D8850@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 29 Apr 2020 23:55:26 -0700
Message-ID: <CAEf4BzYeJZHK5hRPpETK+cJFTRx+nDFHv-dhjpOSt=-VP9T5Cg@mail.gmail.com>
Subject: Re: [PATCH v8 bpf-next 3/3] bpf: add selftest for BPF_ENABLE_STATS
To:     Song Liu <songliubraving@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 29, 2020 at 10:12 PM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Apr 29, 2020, at 7:23 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> >
> > On Tue, Apr 28, 2020 at 11:47 PM Song Liu <songliubraving@fb.com> wrote:
> >>
> >> Add test for BPF_ENABLE_STATS, which should enable run_time_ns stats.
> >>
> >> ~/selftests/bpf# ./test_progs -t enable_stats  -v
> >> test_enable_stats:PASS:skel_open_and_load 0 nsec
> >> test_enable_stats:PASS:get_stats_fd 0 nsec
> >> test_enable_stats:PASS:attach_raw_tp 0 nsec
> >> test_enable_stats:PASS:get_prog_info 0 nsec
> >> test_enable_stats:PASS:check_stats_enabled 0 nsec
> >> test_enable_stats:PASS:check_run_cnt_valid 0 nsec
> >> Summary: 1/0 PASSED, 0 SKIPPED, 0 FAILED
> >>
> >> Signed-off-by: Song Liu <songliubraving@fb.com>
> >> ---
> >> .../selftests/bpf/prog_tests/enable_stats.c   | 46 +++++++++++++++++++
> >> .../selftests/bpf/progs/test_enable_stats.c   | 18 ++++++++
> >> 2 files changed, 64 insertions(+)
> >> create mode 100644 tools/testing/selftests/bpf/prog_tests/enable_stats.c
> >> create mode 100644 tools/testing/selftests/bpf/progs/test_enable_stats.c
> >>
> >> diff --git a/tools/testing/selftests/bpf/prog_tests/enable_stats.c b/tools/testing/selftests/bpf/prog_tests/enable_stats.c
> >> new file mode 100644
> >> index 000000000000..cb5e34dcfd42
> >> --- /dev/null
> >> +++ b/tools/testing/selftests/bpf/prog_tests/enable_stats.c
> >> @@ -0,0 +1,46 @@
> >> +// SPDX-License-Identifier: GPL-2.0
> >> +#include <test_progs.h>
> >> +#include <sys/mman.h>
> >
> > is this header used for anything?
>
> Not really, will remove it.
>
> >
> >> +#include "test_enable_stats.skel.h"
> >> +
> >> +void test_enable_stats(void)
> >> +{
> >
> > [...]
> >
> >> +
> >> +char _license[] SEC("license") = "GPL";
> >> +
> >> +static __u64 count;
> >
> > this is actually very unreliable, because compiler might decide to
> > just remove this variable. It should be either `static volatile`, or
> > better use zero-initialized global variable:
> >
> > __u64 count = 0;
>
> Why would compile remove it? Is it because "static" or "no initialized?

because static, which makes compiler assume that no one else can
access it (which is not true for BPF programs).

> Would "__u64 count;" work?

unfortunately, no, libbpf enforces that all global variables are
initialized (uninitialized global variables go into special COM
section, libbpf doesn't support it).

>
> For "__u64 count = 0;", checkpatch.pl generates an error:
>
> ERROR: do not initialise globals to 0
> #92: FILE: tools/testing/selftests/bpf/progs/test_enable_stats.c:11:
> +__u64 count = 0;

ignore checkpatch.pl in this case?

>
> Thanks,
> Song
