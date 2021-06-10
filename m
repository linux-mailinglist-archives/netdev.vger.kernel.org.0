Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5026D3A31A2
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 19:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbhFJREA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 13:04:00 -0400
Received: from mail-yb1-f176.google.com ([209.85.219.176]:42544 "EHLO
        mail-yb1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbhFJRD6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 13:03:58 -0400
Received: by mail-yb1-f176.google.com with SMTP id g142so272586ybf.9;
        Thu, 10 Jun 2021 10:01:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lbDIIQpuorivBg9C2L1KHDxnd0sx2nyvGXVcS+PLY3s=;
        b=hmoYJEs7xTnJzOY3EWVpPTeuicXTTODNrF8f563wrJX9zPFYgStgX++jACVm2D8nUh
         KjxK91ZfXTX1R9hx3DMdToPp+EyardrX7wkLd1PXcsJ9bxBCY4g0gdd8exrhYoD2MpXB
         LJ1kdJp70p8Sjs1DrSYq7DsuP/iOVhYp93VOz82s48Z94G2pMphD+1n8wyHK4eDhlqzU
         J3UXLKgRFu4UNJuVXXi60ZntNXzaGyjEyt23KGr2Z0n5GAqLjvZVDZToFXZs73fowzEh
         Wol2xkQIZlDjSbY4uLIEfSMp0uBaw+T6F4u88OL5fcwmx8fdNvA7ZNdI0wgSBxS2xqUq
         vdCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lbDIIQpuorivBg9C2L1KHDxnd0sx2nyvGXVcS+PLY3s=;
        b=cShRXUS9jIgTuXqQ2rIkJ9nzsQEJaUK61RYUhbITRNsNZWXBnKqBb6+XKBobxxkQBy
         MtoWv8Ufm8P001GsANXwH04LCJt1b3zduvGMLj1fxUjnMU5W/Gc8wUAZapwj8qMGYI5r
         8iER5hcjiwYE8YSZW/phA+s315JKP4TyW1Q/rH5GwuJN9UmKhlL7T2iPJ7la12YsPlau
         eKPaZpHJC8RHkJAcKJ87hW0QyUNi/szAZeUh+37kTddqrrnDZS8WN2o9ixiatc2m5ZNW
         +dMTefT3BJbM4o1AuAaJel1YOQQdD686PnTROeXpgpZok5smRaUgTEUKAuwqeJNhkmw2
         lbbg==
X-Gm-Message-State: AOAM533FCH8khCfP/O8DWBM8AA9lARnA3xeFYUVlILOGlsqG092ZHQgJ
        UMCzqH386wW2Rvkpy3cDP8KnVQfA8Eva/TK9Rpw=
X-Google-Smtp-Source: ABdhPJyk9YRtgpe69crzGu381Z8WtzrpI20TabICjIBQbJzbl31uafwZXvxqt1GrjYMK6rozrVwRYHghVjasU/Cqvzk=
X-Received: by 2002:a25:ba06:: with SMTP id t6mr8525361ybg.459.1623344445728;
 Thu, 10 Jun 2021 10:00:45 -0700 (PDT)
MIME-Version: 1.0
References: <20210605111034.1810858-1-jolsa@kernel.org> <20210605111034.1810858-17-jolsa@kernel.org>
 <CAEf4BzbBGB+hm0LJRUWDi1EXRkbj86FDOt_ZHdQbT=za47p9ZA@mail.gmail.com> <YMDQOIhRh9tDy1Tg@krava>
In-Reply-To: <YMDQOIhRh9tDy1Tg@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 10 Jun 2021 10:00:34 -0700
Message-ID: <CAEf4Bzboi7Wsf94Z-0OjyYehjazELqdR-gWgxuS_y3AqzDY=rQ@mail.gmail.com>
Subject: Re: [PATCH 16/19] selftests/bpf: Add fentry multi func test
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
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

On Wed, Jun 9, 2021 at 7:29 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Tue, Jun 08, 2021 at 10:40:24PM -0700, Andrii Nakryiko wrote:
> > On Sat, Jun 5, 2021 at 4:12 AM Jiri Olsa <jolsa@kernel.org> wrote:
> > >
> > > Adding selftest for fentry multi func test that attaches
> > > to bpf_fentry_test* functions and checks argument values
> > > based on the processed function.
> > >
> > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > > ---
> > >  tools/testing/selftests/bpf/multi_check.h     | 52 +++++++++++++++++++
> > >  .../bpf/prog_tests/fentry_multi_test.c        | 43 +++++++++++++++
> > >  .../selftests/bpf/progs/fentry_multi_test.c   | 18 +++++++
> > >  3 files changed, 113 insertions(+)
> > >  create mode 100644 tools/testing/selftests/bpf/multi_check.h
> > >  create mode 100644 tools/testing/selftests/bpf/prog_tests/fentry_multi_test.c
> > >  create mode 100644 tools/testing/selftests/bpf/progs/fentry_multi_test.c
> > >
> > > diff --git a/tools/testing/selftests/bpf/multi_check.h b/tools/testing/selftests/bpf/multi_check.h
> > > new file mode 100644
> > > index 000000000000..36c2a93f9be3
> > > --- /dev/null
> > > +++ b/tools/testing/selftests/bpf/multi_check.h
> >
> > we have a proper static linking now, we don't have to use header
> > inclusion hacks, let's do this properly?
>
> ok, will change
>
> >
> > > @@ -0,0 +1,52 @@
> > > +/* SPDX-License-Identifier: GPL-2.0 */
> > > +
> > > +#ifndef __MULTI_CHECK_H
> > > +#define __MULTI_CHECK_H
> > > +
> > > +extern unsigned long long bpf_fentry_test[8];
> > > +
> > > +static __attribute__((unused)) inline
> > > +void multi_arg_check(unsigned long ip, __u64 a, __u64 b, __u64 c, __u64 d, __u64 e, __u64 f, __u64 *test_result)
> > > +{
> > > +       if (ip == bpf_fentry_test[0]) {
> > > +               *test_result += (int) a == 1;
> > > +       } else if (ip == bpf_fentry_test[1]) {
> > > +               *test_result += (int) a == 2 && (__u64) b == 3;
> > > +       } else if (ip == bpf_fentry_test[2]) {
> > > +               *test_result += (char) a == 4 && (int) b == 5 && (__u64) c == 6;
> > > +       } else if (ip == bpf_fentry_test[3]) {
> > > +               *test_result += (void *) a == (void *) 7 && (char) b == 8 && (int) c == 9 && (__u64) d == 10;
> > > +       } else if (ip == bpf_fentry_test[4]) {
> > > +               *test_result += (__u64) a == 11 && (void *) b == (void *) 12 && (short) c == 13 && (int) d == 14 && (__u64) e == 15;
> > > +       } else if (ip == bpf_fentry_test[5]) {
> > > +               *test_result += (__u64) a == 16 && (void *) b == (void *) 17 && (short) c == 18 && (int) d == 19 && (void *) e == (void *) 20 && (__u64) f == 21;
> > > +       } else if (ip == bpf_fentry_test[6]) {
> > > +               *test_result += 1;
> > > +       } else if (ip == bpf_fentry_test[7]) {
> > > +               *test_result += 1;
> > > +       }
> >
> > why not use switch? and why the casting?
>
> hum, for switch I'd need constants right?

doh, of course :)

but! you don't need to fill out bpf_fentry_test[] array from
user-space, just use extern const void variables to get addresses of
those functions:

extern const void bpf_fentry_test1 __ksym;
extern const void bpf_fentry_test2 __ksym;
...

>
> casting is extra ;-) wanted to check the actual argument types,
> but probably makes no sense

probably doesn't given you already declared it u64 and use integer
values for comparison

>
> will check
>
> >
> > > +}
> > > +
> >
> > [...]
> >
> > > diff --git a/tools/testing/selftests/bpf/progs/fentry_multi_test.c b/tools/testing/selftests/bpf/progs/fentry_multi_test.c
> > > new file mode 100644
> > > index 000000000000..a443fc958e5a
> > > --- /dev/null
> > > +++ b/tools/testing/selftests/bpf/progs/fentry_multi_test.c
> > > @@ -0,0 +1,18 @@
> > > +// SPDX-License-Identifier: GPL-2.0
> > > +#include <linux/bpf.h>
> > > +#include <bpf/bpf_helpers.h>
> > > +#include <bpf/bpf_tracing.h>
> > > +#include "multi_check.h"
> > > +
> > > +char _license[] SEC("license") = "GPL";
> > > +
> > > +unsigned long long bpf_fentry_test[8];
> > > +
> > > +__u64 test_result = 0;
> > > +
> > > +SEC("fentry.multi/bpf_fentry_test*")
> >
> > wait, that's a regexp syntax that libc supports?.. Not .*? We should
> > definitely not provide btf__find_by_pattern_kind() API, I'd like to
> > avoid explaining what flavors of regexps libbpf supports.
>
> ok
>
> thanks,
> jirka
>
