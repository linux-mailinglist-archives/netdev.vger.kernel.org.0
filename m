Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38A0F1AD2BC
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 00:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728955AbgDPWTW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 18:19:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728824AbgDPWTT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 18:19:19 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D45A1C061A10
        for <netdev@vger.kernel.org>; Thu, 16 Apr 2020 15:19:17 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id i16so2061677ybq.9
        for <netdev@vger.kernel.org>; Thu, 16 Apr 2020 15:19:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bEaKlFXLvZkTF1WbImU8k4TjAxStPFiDUhxy9HHTvfo=;
        b=usOSe4MzkuxL5nKsgNMMsCqcXtZVMEN45JzLMSBeGYs9/bIZkhn/EJBjHeRBszfiV2
         u6T+vjWVyfG+1qFiq/iID0tIJjuj4xPq5++MFFAvDO1aPuvlJY0ZxNAhg3SWfJu1RdQ4
         aQn+9ljr4WqDs73oyrTY0nDeBiuyLUubH6vkRXAz11xZISE5kL+V+bUimCbkljZXDHW9
         vmYqGN5tlCG9qyN9YXvVqyhJpX9i7TBGKksdAjB0wmjLs5r01eHIYFRMO+PmEBwqsqFM
         VSrhkjNIKqxdMvbAswW+XT/Irt9H4wVLbpSSlqNqCNj4MjrhM2w5DXr7Xojp3EeltJIJ
         j3uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bEaKlFXLvZkTF1WbImU8k4TjAxStPFiDUhxy9HHTvfo=;
        b=hq90rdOq/vVDwoIiFgKSCVve19wvi12oe4EHuhHNfDiXXSQj+1+T9mk2cPTA9fmS5d
         t/tmXv1Ujz3zFEWZFs82t06J4VeL4oObhfs8MySg2enCTPOA39A0qsUunpXWGAea5LDI
         gLIsd9xyK9siwTyTWaP250W4uYfZ/378Z36Xon56XXuG1PrmHTKw5FHyK88Z5/54+QAw
         ailM55mV8zLO5s0WmgXCUYrv2HePUEodhV+Krf3ZD4v4lCzkorckVIX9at5Qb7BczU3J
         Om56hHStS+ClqPGkUASsRRWq72hYpjWkaCVRr0urmJkAHxkUbCKH4IE6GEV7g6Ot7/cV
         WO9Q==
X-Gm-Message-State: AGi0PubUF16QhbiH9Ah7eVs3sd1DFRgMaXJ0sX5l/5X+pO/EwMeTHBMo
        PdxTYjw1N8UOXBsl0byhfZsotwLvVWamF6XsQOFZ9Q==
X-Google-Smtp-Source: APiQypK/Raydb2Hwqc7lQkm0BcyExmPOSBeLJJw5JSAyZGslZAHoTfuyzKiVUyTTSyLITGOUPmLumbQj4KdqQYNdmGg=
X-Received: by 2002:a05:6902:505:: with SMTP id x5mr905928ybs.286.1587075556390;
 Thu, 16 Apr 2020 15:19:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200416063551.47637-1-irogers@google.com> <20200416063551.47637-5-irogers@google.com>
 <20200416095501.GC369437@krava> <CAP-5=fVOb1nV2gdGGWLQvTApoMR=qzaSQHSwxsAKAXQ=wqQV+g@mail.gmail.com>
 <20200416201011.GB414900@krava>
In-Reply-To: <20200416201011.GB414900@krava>
From:   Ian Rogers <irogers@google.com>
Date:   Thu, 16 Apr 2020 15:19:04 -0700
Message-ID: <CAP-5=fVebXnQaQAVGszZtKg2DpUh-UXD12YDOzjo3k-SUNxYVw@mail.gmail.com>
Subject: Re: [PATCH v9 4/4] perf tools: add support for libpfm4
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
        bpf@vger.kernel.org,
        linux-perf-users <linux-perf-users@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 16, 2020 at 1:10 PM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Thu, Apr 16, 2020 at 09:02:54AM -0700, Ian Rogers wrote:
> > On Thu, Apr 16, 2020 at 2:55 AM Jiri Olsa <jolsa@redhat.com> wrote:
> > >
> > > On Wed, Apr 15, 2020 at 11:35:51PM -0700, Ian Rogers wrote:
> > > > From: Stephane Eranian <eranian@google.com>
> > > >
> > > > This patch links perf with the libpfm4 library if it is available
> > > > and NO_LIBPFM4 isn't passed to the build. The libpfm4 library
> > > > contains hardware event tables for all processors supported by
> > > > perf_events. It is a helper library that helps convert from a
> > > > symbolic event name to the event encoding required by the
> > > > underlying kernel interface. This library is open-source and
> > > > available from: http://perfmon2.sf.net.
> > > >
> > > > With this patch, it is possible to specify full hardware events
> > > > by name. Hardware filters are also supported. Events must be
> > > > specified via the --pfm-events and not -e option. Both options
> > > > are active at the same time and it is possible to mix and match:
> > > >
> > > > $ perf stat --pfm-events inst_retired:any_p:c=1:i -e cycles ....
> > > >
> > > > Signed-off-by: Stephane Eranian <eranian@google.com>
> > > > Reviewed-by: Ian Rogers <irogers@google.com>
> > >
> > >         # perf list
> > >         ...
> > >         perf_raw pfm-events
> > >           r0000
> > >             [perf_events raw event syntax: r[0-9a-fA-F]+]
> > >
> > >         skl pfm-events
> > >           UNHALTED_CORE_CYCLES
> > >             [Count core clock cycles whenever the clock signal on the specific core is running (not halted)]
> > >           UNHALTED_REFERENCE_CYCLES
> > >
> > > please add ':' behind the '* pfm-events' label
> >
> > Thanks! Not sure I follow here. skl here is the pmu. pfm-events is
> > here just to make it clearer these are --pfm-events. The event is
> > selected with '--pfm-events UNHALTED_CORE_CYCLES'. Will putting
> > skl:pfm-events here make it look like that is part of the event
> > encoding?
>
> aah I might have misunderstood the output here then, we have preceeding
> output like:
>
> cache:
>   l1d.replacement
>        [L1D data line replacements]
>
> so I thought the 'skl pfm-events' is just a label
>
>
> how about we use the first current label in the middle like:
>
>         # perf list
>         List of pre-defined events (to be used in -e):
>
>           current events stuff
>
>         List of pfm events (to be used in --pfm-xxx):
>
>           pfm events stuff
>
> or maybe put it under 'perf list --pfm', thoughts?

We decided on the former which is in the new patch set. However, the
output isn't conditional on the pager being used, which it is in the
regular event case.
https://lore.kernel.org/lkml/20200416221457.46710-1-irogers@google.com/T/#t

Let me know if there is more to address. Thanks!
Ian

> jirka
>
