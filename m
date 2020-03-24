Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F370D191470
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 16:31:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728201AbgCXPaI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 11:30:08 -0400
Received: from mail-yb1-f193.google.com ([209.85.219.193]:39462 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728191AbgCXPaH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 11:30:07 -0400
Received: by mail-yb1-f193.google.com with SMTP id h205so4961994ybg.6
        for <netdev@vger.kernel.org>; Tue, 24 Mar 2020 08:30:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zGzJT4lBRDfMWrKAV6fIWvWA81QqY+N9vkGkVfG1dSI=;
        b=cj0bP8gpGKJn/JLKLOYgOvr5+PBMMSJ12OC9J7p8NDzfW63ZtQ3qjg1ulm/VMRIATc
         gHw0Zdc0GyNqCWiw0HBB3VsJKvx9I5VYKwq0rX+E07BixdR2ulr1SebptImtTguxzVur
         bDYUMF1XZSgWQfB9rT5UF/FgSFHturPQNTf4zRLkw0lJfmTZUVe734stY/hlXspDws89
         UNucCbkOtar1rHP1GrTLS4RVxyV/FTXQuiVCxjAcUSaiW5sis2n1W94zZ8qGRbplanOL
         MEbpuvXDzpDefV1pdplKTJf5UQ2U1exibbHw2EsVJuS2H6Yae22K4pXnPHLyOke1pMSJ
         HoVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zGzJT4lBRDfMWrKAV6fIWvWA81QqY+N9vkGkVfG1dSI=;
        b=e5Q2cye7om4f9c0b9kb7E+I8poEQFt0fkq4EFHgMnXTpgYBkbNHMESVI13M/RKjB8Z
         xnL5u8La54QD4s2a/Rd6BFbDgwCXHc6oJuprZ7cjlm6Yf564C+3rShmSvk50hLa8SjVL
         Eh6ph5nquzwQ6VV0+PcbOeJvI/lQt46XE8x7rP6kY5q4Bsf3hUkETQUV+03DR2SP2yRo
         U0IkIQYfLL55irkPvTfydpB0cslDMN18bLz71iDDmwdyX/M8Q+EvJ5UTD50bRAbyGqrU
         /GiQo7WObxCLnZlHHVDK+sZNzDHlzlTq0feJHPSoXoRTwRvZebjltHJpRzazq0Aasxyq
         bH7g==
X-Gm-Message-State: ANhLgQ3T5ZsGGTSMgBqntuNFupDWGq7lLEM83vz7FMb1Asqkz0Rnge8R
        vucl3F9J3knwnCn0wXLgWer2LC7JojuAuyblTM3a3Q==
X-Google-Smtp-Source: ADFU+vuZ2elnKuVqU7qZYZUw8dJvvBH8C6kAq3JJauRXax/QrAStpFqR/zNRSbeNxIbm7pHs2pOGoEIScHClbipbCGU=
X-Received: by 2002:a25:b0a1:: with SMTP id f33mr41103167ybj.403.1585063804733;
 Tue, 24 Mar 2020 08:30:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200323235846.104937-1-irogers@google.com> <20200324102732.GR1534489@krava>
In-Reply-To: <20200324102732.GR1534489@krava>
From:   Ian Rogers <irogers@google.com>
Date:   Tue, 24 Mar 2020 08:29:53 -0700
Message-ID: <CAP-5=fVi3dNzXE9R3HniSfD3w97dPebbuO1zUKoPXv4Wag-JDA@mail.gmail.com>
Subject: Re: [PATCH v5] perf tools: add support for libpfm4
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Igor Lubashev <ilubashe@akamai.com>,
        Alexey Budankov <alexey.budankov@linux.intel.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Jiwei Sun <jiwei.sun@windriver.com>,
        yuzhoujian <yuzhoujian@didichuxing.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Leo Yan <leo.yan@linaro.org>,
        John Garry <john.garry@huawei.com>,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-perf-users@vger.kernel.org,
        Stephane Eranian <eranian@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 24, 2020 at 3:28 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Mon, Mar 23, 2020 at 04:58:46PM -0700, Ian Rogers wrote:
> > This patch links perf with the libpfm4 library if it is available and
> > NO_LIBPFM4 isn't passed to the build. The libpfm4 library contains hardware
> > event tables for all processors supported by perf_events. It is a helper
> > library that helps convert from a symbolic event name to the event
> > encoding required by the underlying kernel interface. This
> > library is open-source and available from: http://perfmon2.sf.net.
> >
> > With this patch, it is possible to specify full hardware events
> > by name. Hardware filters are also supported. Events must be
> > specified via the --pfm-events and not -e option. Both options
> > are active at the same time and it is possible to mix and match:
> >
> > $ perf stat --pfm-events inst_retired:any_p:c=1:i -e cycles ....
> >
> > v5 is a rebase.
> > v4 is a rebase on git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git
> >    branch perf/core and re-adds the tools/build/feature/test-libpfm4.c
> >    missed in v3.
> > v3 is against acme/perf/core and removes a diagnostic warning.
> > v2 of this patch makes the --pfm-events man page documentation
> > conditional on libpfm4 behing configured. It tidies some of the
> > documentation and adds the feature test missed in the v1 patch.
> >
> > Author: Stephane Eranian <eranian@google.com>
> > Signed-off-by: Ian Rogers <irogers@google.com>
>
> I still have some conflicts, but I merged it by hand
>
>
>         patching file tools/build/Makefile.feature
>         patching file tools/build/feature/Makefile
>         patching file tools/build/feature/test-libpfm4.c
>         patching file tools/perf/Documentation/Makefile
>         patching file tools/perf/Documentation/perf-record.txt
>         patching file tools/perf/Documentation/perf-stat.txt
>         patching file tools/perf/Documentation/perf-top.txt
>         patching file tools/perf/Makefile.config
>         patching file tools/perf/Makefile.perf
>         Hunk #3 FAILED at 834.
>         1 out of 3 hunks FAILED -- saving rejects to file tools/perf/Makefile.perf.rej
>         patching file tools/perf/builtin-list.c
>         patching file tools/perf/builtin-record.c
>         patching file tools/perf/builtin-stat.c
>         patching file tools/perf/builtin-top.c
>         Hunk #2 succeeded at 1549 (offset 2 lines).
>         Hunk #3 succeeded at 1567 (offset 2 lines).
>         patching file tools/perf/util/evsel.c
>         patching file tools/perf/util/evsel.h
>         patching file tools/perf/util/parse-events.c
>         patching file tools/perf/util/parse-events.h
>         patching file tools/perf/util/pmu.c
>         Hunk #1 succeeded at 869 (offset 5 lines).
>         patching file tools/perf/util/pmu.h
>         Hunk #1 succeeded at 65 (offset 1 line).
>
> jirka

Thanks! I did a clone of acme's linux.git branch perf/core and applied
the change with git am, then built and tested. Perhaps you are using a
different tree or branch? Anyway, hopefully this is resolved now :-)

Thanks again,
Ian
