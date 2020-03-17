Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F075618794C
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 06:39:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725928AbgCQFjz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 01:39:55 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:43249 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725868AbgCQFjy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 01:39:54 -0400
Received: by mail-qk1-f193.google.com with SMTP id x18so10428527qki.10;
        Mon, 16 Mar 2020 22:39:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UwZxmkvrwRhIrcZt0WEpCmuaedOj5jqgsMhumcotKKI=;
        b=TdZj3YUkubjcMVWM+zJvvlnV6euPPgCK+b/PA8f2P7433xyw9CwJ4OAVomMNsXV1Ue
         qhfCXXRLzARRDHhyaoJ8mYZvzmZx/ZmkeXoEMjrjeaSYZ00y16Dfu5OETwCTyVwDsNtG
         Zzp0sL52+McMWHkQAgii1zzLmDVFnzd+FuHRIY2vWESNlOs3UpCfua6I0rVabr5ieP4D
         YSLA4bKgmRO0PmbXji6B+NTwlI2pGRN+M94UqsGILN2jFzAhshC6Tz/Fqs8lbDK0HbdS
         WOzrgykICk6ZCvdIBdMIxIH9EsXC9jHFWXiY3k09q+0pbYQzyD8CxsiSG4aWf4x2yyFB
         kzqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UwZxmkvrwRhIrcZt0WEpCmuaedOj5jqgsMhumcotKKI=;
        b=WsrUwbvL2jTQgcwXBWndN03YPiEkBmbh7PUUf5b1m80oViDjq/op5GkIqdEZCIiBwJ
         +FKROmzfP5BwyasknmmswAx6tZBFfqSToEJ36qHvgPS//QtdceVQIa7OwxXJmJQ/I/SH
         ss9dY6THv6ReCya+q+C3v4yr2c/VtHWlBO7kpho7PYo9x4svO0shP+g8klntlVcbKPoV
         roupUB9nFuRmmtAqg6cgA0XPQO9tw9Uu56EPeZ87sJECTzAZOBwzM+jqgJDLumxDL2il
         NyzbtzEAmjPuVGJ2eeQWA62JiYtqCRnt9O7nT8MBXhUEkDtpzlz7xXJvKmaVE9wzi6lW
         pPCg==
X-Gm-Message-State: ANhLgQ0FPpum8nIKhGzl30UnE6H4AgP/dWHwIMbC3pE6EEahOnpGE02q
        o/Oz9iZF129gNEfooqTe1t0hwnVBY6MztqmaFPQ=
X-Google-Smtp-Source: ADFU+vsoWkGYO+avhdI29ZRZV4RpkK8u06r6j/11i25pQ+uRiHxLwoILi+Y75zpBQRrZB2ylpXmJCu67ogAtONt59fo=
X-Received: by 2002:a37:9104:: with SMTP id t4mr3377882qkd.449.1584423591664;
 Mon, 16 Mar 2020 22:39:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200314013932.4035712-1-andriin@fb.com> <20200314013932.4035712-3-andriin@fb.com>
 <20200317053550.uk2lzcqfrrmgsdq7@kafai-mbp>
In-Reply-To: <20200317053550.uk2lzcqfrrmgsdq7@kafai-mbp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 16 Mar 2020 22:39:40 -0700
Message-ID: <CAEf4BzaBZyeQNqnDrp5RwMqWKFUvT0LpuXg2bmT8LD6M-9UTMA@mail.gmail.com>
Subject: Re: [Potential Spoof] [PATCH bpf-next 3/3] selftests/bpf: reset
 process and thread affinity after each test/sub-test
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 16, 2020 at 10:35 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Fri, Mar 13, 2020 at 06:39:32PM -0700, Andrii Nakryiko wrote:
> > Some tests and sub-tests are setting "custom" thread/process affinity and
> > don't reset it back. Instead of requiring each test to undo all this, ensure
> > that thread affinity is restored by test_progs test runner itself.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  tools/testing/selftests/bpf/test_progs.c | 42 +++++++++++++++++++++++-
> >  tools/testing/selftests/bpf/test_progs.h |  1 +
> >  2 files changed, 42 insertions(+), 1 deletion(-)
> >
> > diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
> > index c8cb407482c6..b521e0a512b6 100644
> > --- a/tools/testing/selftests/bpf/test_progs.c
> > +++ b/tools/testing/selftests/bpf/test_progs.c
> > @@ -1,12 +1,15 @@
> >  // SPDX-License-Identifier: GPL-2.0-only
> >  /* Copyright (c) 2017 Facebook
> >   */
> > +#define _GNU_SOURCE
> >  #include "test_progs.h"
> >  #include "cgroup_helpers.h"
> >  #include "bpf_rlimit.h"
> >  #include <argp.h>
> > -#include <string.h>
> > +#include <pthread.h>
> > +#include <sched.h>
> >  #include <signal.h>
> > +#include <string.h>
> >  #include <execinfo.h> /* backtrace */
> >
> >  /* defined in test_progs.h */
> > @@ -90,6 +93,34 @@ static void skip_account(void)
> >       }
> >  }
> >
> > +static void stdio_restore(void);
> > +
> > +/* A bunch of tests set custom affinity per-thread and/or per-process. Reset
> > + * it after each test/sub-test.
> > + */
> > +static void reset_affinity() {
> > +
> > +     cpu_set_t cpuset;
> > +     int i, err;
> > +
> > +     CPU_ZERO(&cpuset);
> > +     for (i = 0; i < env.nr_cpus; i++)
> > +             CPU_SET(i, &cpuset);
> In case the user may run "taskset somemask test_progs",
> is it better to store the inital_cpuset at the beginning
> of main and then restore to inital_cpuset after each run?

Not sure it's worth it (it's test runner, not really a general-purpose
tool), but I can add that for sure.

>
> > +
> > +     err = sched_setaffinity(0, sizeof(cpuset), &cpuset);
> > +     if (err < 0) {
> > +             stdio_restore();
> > +             fprintf(stderr, "Failed to reset process affinity: %d!\n", err);
> > +             exit(-1);
> > +     }
> > +     err = pthread_setaffinity_np(pthread_self(), sizeof(cpuset), &cpuset);
> > +     if (err < 0) {
> > +             stdio_restore();
> > +             fprintf(stderr, "Failed to reset thread affinity: %d!\n", err);
> > +             exit(-1);
> > +     }
> > +}
