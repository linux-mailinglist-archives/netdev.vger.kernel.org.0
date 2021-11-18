Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 444DA455DD8
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 15:19:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232240AbhKROWU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 09:22:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232009AbhKROWT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 09:22:19 -0500
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26749C061570;
        Thu, 18 Nov 2021 06:19:19 -0800 (PST)
Received: by mail-qv1-xf33.google.com with SMTP id i13so4665524qvm.1;
        Thu, 18 Nov 2021 06:19:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e6eAxrQg08U61GwOYJ6FpVD9sNYF+r9lJrh7l4b1WNE=;
        b=ceQLeWGFJlX01qZKM0k8jv8h/NV/ImHyioYkbmAt3d5LnHO1Pgd1K5ENEamypIsbeM
         dl7Pk6S1eDhQr70u1reiTESUSjldgDV8OK6VKS1LB2Ec9tLs78+TeVoAT6l5kfRR5cWy
         Uzn5r7Oyf7lf4C72vEcBPTUPRGaeKzd53YEVRtFlyThGBN+6ciYt3ABHGjTYVvBg6S6T
         LuPqtSWYF2oGzPzvtf3btc+hajGp7n1Vy3Oxbq5FWO3RacQlS0qS14WaGCjAT0d+vdUm
         uVei/f5SZJ0S5dDKWGRrRB8L1ewiBrJDvDZ6AThxrQMp3r6mfBCNDA1NdpN02tmNNoO/
         Dn9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e6eAxrQg08U61GwOYJ6FpVD9sNYF+r9lJrh7l4b1WNE=;
        b=tmVu+rBgKGWQK0ZVXVVERW7pc9HaQn0M0L5zI2bUZmQEMf1va2FuI6Wio14UQeIlDM
         IXl+IeNvfGov6pI+J1RAaS/Ih3wbmbPTrYopizyRzS+0mYKkYAnnwoJ2cyCCls1SNTEs
         O2KgDD7wXIVh8GWSfeyQHoyOAp4hl0i+9/UIUqym7Gm43vkQHcQNf2gAqLvVteDMf/1R
         yoKzG1yi8eNLKSNFGA31GsPW7hlGVvoIgHFc57ufpVWBA20HIh3ms+/J73Uz2KkLrdyb
         BoRYdKqakwfUWepbVPTLNNNhjOdzDudD6oJqWvoHkEs8leUQZ7N6ggt7OZi9r++uQMGf
         DF3g==
X-Gm-Message-State: AOAM5327L6CX8BbApQB/NWPwWEJP+HVPjvn8s8PzA2JpF8JSi/fKciIs
        ZWvLkSfeRcaz007OE44tSM1caQweiatc4JOX9uQ=
X-Google-Smtp-Source: ABdhPJz4dvN9TbvidJ1IREL08Pf8NNt1u3tGdxzzmc1QnHnlHcrTa+cHIEZ6g53Ci2pGTfQBeJENQHyAu6T8AQ7SC6M=
X-Received: by 2002:ad4:5dea:: with SMTP id jn10mr64653681qvb.17.1637245158273;
 Thu, 18 Nov 2021 06:19:18 -0800 (PST)
MIME-Version: 1.0
References: <20211101060419.4682-1-laoar.shao@gmail.com> <20211101060419.4682-9-laoar.shao@gmail.com>
 <YZUSJQqDeY06nBsB@kernel.org>
In-Reply-To: <YZUSJQqDeY06nBsB@kernel.org>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Thu, 18 Nov 2021 22:18:42 +0800
Message-ID: <CALOAHbC1Cn7RA_X5TrKQb9nmKMxuinfh+Z9j51yMoaSBPx3DuA@mail.gmail.com>
Subject: Re: [PATCH v7 08/11] tools/perf/test: make perf test adopt to task
 comm size change
To:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Petr Mladek <pmladek@suse.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Valentin Schneider <valentin.schneider@arm.com>,
        Qiang Zhang <qiang.zhang@windriver.com>,
        robdclark <robdclark@chromium.org>,
        christian <christian@brauner.io>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        mike.marciniszyn@cornelisnetworks.com, dledford@redhat.com,
        jgg@ziepe.ca, linux-rdma@vger.kernel.org,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "linux-perf-use." <linux-perf-users@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel test robot <oliver.sang@intel.com>,
        kbuild test robot <lkp@intel.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 17, 2021 at 10:31 PM Arnaldo Carvalho de Melo
<arnaldo.melo@gmail.com> wrote:
>
> Em Mon, Nov 01, 2021 at 06:04:16AM +0000, Yafang Shao escreveu:
> > kernel test robot reported a perf-test failure after I extended task comm
> > size from 16 to 24. The failure as follows,
> >
> > 2021-10-13 18:00:46 sudo /usr/src/perf_selftests-x86_64-rhel-8.3-317419b91ef4eff4e2f046088201e4dc4065caa0/tools/perf/perf test 15
> > 15: Parse sched tracepoints fields                                  : FAILED!
> >
> > The reason is perf-test requires a fixed-size task comm. If we extend
> > task comm size to 24, it will not equil with the required size 16 in perf
> > test.
> >
> > After some analyzation, I found perf itself can adopt to the size
> > change, for example, below is the output of perf-sched after I extend
> > comm size to 24 -
> >
> > task    614 (            kthreadd:        84), nr_events: 1
> > task    615 (             systemd:       843), nr_events: 1
> > task    616 (     networkd-dispat:      1026), nr_events: 1
> > task    617 (             systemd:       846), nr_events: 1
> >
> > $ cat /proc/843/comm
> > networkd-dispatcher
> >
> > The task comm can be displayed correctly as expected.
> >
> > Replace old hard-coded 16 with the new one can fix the warning, but we'd
> > better make the test accept both old and new sizes, then it can be
> > backward compatibility.
> >
> > After this patch, the perf-test succeeds no matter task comm is 16 or
> > 24 -
> >
> > 15: Parse sched tracepoints fields                                  : Ok
> >
> > This patch is a preparation for the followup patch.
> >
> > Reported-by: kernel test robot <oliver.sang@intel.com>
> > Suggested-by: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
> > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> > Cc: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
> > Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>
> > Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> > Cc: Al Viro <viro@zeniv.linux.org.uk>
> > Cc: Kees Cook <keescook@chromium.org>
> > Cc: Petr Mladek <pmladek@suse.com>
> > ---
> >  tools/include/linux/sched.h       | 11 +++++++++++
> >  tools/perf/tests/evsel-tp-sched.c | 26 ++++++++++++++++++++------
> >  2 files changed, 31 insertions(+), 6 deletions(-)
> >  create mode 100644 tools/include/linux/sched.h
> >
> > diff --git a/tools/include/linux/sched.h b/tools/include/linux/sched.h
> > new file mode 100644
> > index 000000000000..0d575afd7f43
> > --- /dev/null
> > +++ b/tools/include/linux/sched.h
> > @@ -0,0 +1,11 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +#ifndef _TOOLS_LINUX_SCHED_H
> > +#define _TOOLS_LINUX_SCHED_H
> > +
> > +/* Keep both length for backward compatibility */
> > +enum {
> > +     TASK_COMM_LEN_16 = 16,
> > +     TASK_COMM_LEN = 24,
> > +};
> > +
>
> I don't think this is a good idea, to have it in tools/include/linux/,
> we have /usr/include/linux/sched.h, this may end up confusing the build
> at some point as your proposal is for a trimmed down header while what
> is in /usr/include/linux/sched.h doesn't have just this.
>
> But since we're using enums for this, we can't check for it with:
>
> #ifdef TASK_COMM_LEN_16
> #define TASK_COMM_LEN_16 16
> #endif
>
> ditto for TASK_COMM_LEN and be future proof, so I'd say just use
> hardcoded values in tools/perf/tests/evsel-tp-sched.c?
>

Hi Arnaldo,

Thanks for the review.
This perf tests code won't be changed in the latest version as we
don't want to extend comm size any more, see also
https://lore.kernel.org/lkml/20211108083840.4627-1-laoar.shao@gmail.com/
The hard-coded 16 in tools/perf/tests/evsel-tp-sched.c is kept as-is.

>
> > +#endif  /* _TOOLS_LINUX_SCHED_H */
> > diff --git a/tools/perf/tests/evsel-tp-sched.c b/tools/perf/tests/evsel-tp-sched.c
> > index f9e34bd26cf3..029f2a8c8e51 100644
> > --- a/tools/perf/tests/evsel-tp-sched.c
> > +++ b/tools/perf/tests/evsel-tp-sched.c
> > @@ -1,11 +1,13 @@
> >  // SPDX-License-Identifier: GPL-2.0
> >  #include <linux/err.h>
> > +#include <linux/sched.h>
> >  #include <traceevent/event-parse.h>
> >  #include "evsel.h"
> >  #include "tests.h"
> >  #include "debug.h"
> >
> > -static int evsel__test_field(struct evsel *evsel, const char *name, int size, bool should_be_signed)
> > +static int evsel__test_field_alt(struct evsel *evsel, const char *name,
> > +                              int size, int alternate_size, bool should_be_signed)
> >  {
> >       struct tep_format_field *field = evsel__field(evsel, name);
> >       int is_signed;
> > @@ -23,15 +25,24 @@ static int evsel__test_field(struct evsel *evsel, const char *name, int size, bo
> >               ret = -1;
> >       }
> >
> > -     if (field->size != size) {
> > -             pr_debug("%s: \"%s\" size (%d) should be %d!\n",
> > +     if (field->size != size && field->size != alternate_size) {
> > +             pr_debug("%s: \"%s\" size (%d) should be %d",
> >                        evsel->name, name, field->size, size);
> > +             if (alternate_size > 0)
> > +                     pr_debug(" or %d", alternate_size);
> > +             pr_debug("!\n");
> >               ret = -1;
> >       }
> >
> >       return ret;
> >  }
> >
> > +static int evsel__test_field(struct evsel *evsel, const char *name,
> > +                          int size, bool should_be_signed)
> > +{
> > +     return evsel__test_field_alt(evsel, name, size, -1, should_be_signed);
> > +}
> > +
> >  int test__perf_evsel__tp_sched_test(struct test *test __maybe_unused, int subtest __maybe_unused)
> >  {
> >       struct evsel *evsel = evsel__newtp("sched", "sched_switch");
> > @@ -42,7 +53,8 @@ int test__perf_evsel__tp_sched_test(struct test *test __maybe_unused, int subtes
> >               return -1;
> >       }
> >
> > -     if (evsel__test_field(evsel, "prev_comm", 16, false))
> > +     if (evsel__test_field_alt(evsel, "prev_comm", TASK_COMM_LEN_16,
> > +                               TASK_COMM_LEN, false))
> >               ret = -1;
> >
> >       if (evsel__test_field(evsel, "prev_pid", 4, true))
> > @@ -54,7 +66,8 @@ int test__perf_evsel__tp_sched_test(struct test *test __maybe_unused, int subtes
> >       if (evsel__test_field(evsel, "prev_state", sizeof(long), true))
> >               ret = -1;
> >
> > -     if (evsel__test_field(evsel, "next_comm", 16, false))
> > +     if (evsel__test_field_alt(evsel, "next_comm", TASK_COMM_LEN_16,
> > +                               TASK_COMM_LEN, false))
> >               ret = -1;
> >
> >       if (evsel__test_field(evsel, "next_pid", 4, true))
> > @@ -72,7 +85,8 @@ int test__perf_evsel__tp_sched_test(struct test *test __maybe_unused, int subtes
> >               return -1;
> >       }
> >
> > -     if (evsel__test_field(evsel, "comm", 16, false))
> > +     if (evsel__test_field_alt(evsel, "comm", TASK_COMM_LEN_16,
> > +                               TASK_COMM_LEN, false))
> >               ret = -1;
> >
> >       if (evsel__test_field(evsel, "pid", 4, true))
> > --
> > 2.17.1
>
> --
>
> - Arnaldo



-- 
Thanks
Yafang
