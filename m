Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1ED91D5A40
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 21:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726374AbgEOTm6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 15:42:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726168AbgEOTm6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 15:42:58 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31A9CC061A0C;
        Fri, 15 May 2020 12:42:58 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id i68so3015845qtb.5;
        Fri, 15 May 2020 12:42:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3FeZo7wxUKF5f4TtRFTT/9ikqtb4RICo/S0MwMu9vSo=;
        b=ntWeU88/ZODmBoBJzxsMHcHPQwhBwu/fsT+NjYCYj3tSizmOSPq+zKlQSL8S518Zvn
         FFSY2R2OrJuWcD5ry1+6WepFZBKDQ/1UMJ76idiDBu8Y2PYwv0Y6f7Fl/eotDeoow9iV
         nNEtFFTV0qoqsWYGRCL2wNLWlUrTAodVTnbBEsx83QY6BOSb8ittkAC27dJIOSx1T6gd
         /6ZEGsPYBBy/B4fBvUHffHEoP4sJfd6GwVQ0n8YPMaejW9t91Qz6uWyHwEXttgQ+AwGd
         faVnP8CNbSxSxsJWQBICNwMeaN7KNLZIFFSBTplH0z+fpDq9GFcmff4KD+PJLFVitnUf
         yCVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3FeZo7wxUKF5f4TtRFTT/9ikqtb4RICo/S0MwMu9vSo=;
        b=JLdPHbNk2sUPN/sWgLZUWtFXfWsQuG16k2KLkch9TfqfUYmMMpgNVLPIHE63T+VAyj
         sG3AKkGk6lAfP7cfptgnhrKzwNNrPmiBzc0aLKz0jUriRN/S+8PywNzdz3KXyKOZPNNW
         RjWtVPpIrLzyQOCer+4npz26EMbv/wk5kUUUrhpL1LQl2gMHuo3la5/fNghmhx2vxE9P
         DRtdbo4ccQBxPYMP9qQmNH06ElPRAN9t7DS/RCpBsG6h56CGKsmdhQs8zmUGhQThFjxo
         Z9mVhHYojnZd9gmo3D/vFnACVZOrg8xH4L7smqJwxHpmbADHt2PZPGYTQJt1gKK8fIRb
         tAPg==
X-Gm-Message-State: AOAM5319D9K0i2BXv507s4zgmudqIRnH49oocWxNpVYy3yrvRsLXsXCZ
        owlrKy/spYXd/YaQK3kOlwgeZ2Sm/oG5EmTEN0Q=
X-Google-Smtp-Source: ABdhPJydym0mkVZTYgwU9sGeeAr5aapv8UMqIAmPaxOtjLJUJJgBDkya5IjfjdAlrGdaVBwHpG6V2rczHCoOprxGlzA=
X-Received: by 2002:ac8:424b:: with SMTP id r11mr5248216qtm.171.1589571777348;
 Fri, 15 May 2020 12:42:57 -0700 (PDT)
MIME-Version: 1.0
References: <20200515165007.217120-1-irogers@google.com> <20200515170036.GA10230@kernel.org>
In-Reply-To: <20200515170036.GA10230@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 15 May 2020 12:42:46 -0700
Message-ID: <CAEf4BzZ5=_yu1kL77n+Oc0K9oaDi4J=c+7CV8D0AXs2hBxhNbw@mail.gmail.com>
Subject: Re: [PATCH v2 0/7] Copy hashmap to tools/perf/util, use in perf expr
To:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ian Rogers <irogers@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Kajol Jain <kjain@linux.ibm.com>,
        Andi Kleen <ak@linux.intel.com>,
        John Garry <john.garry@huawei.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Leo Yan <leo.yan@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 15, 2020 at 10:01 AM Arnaldo Carvalho de Melo
<arnaldo.melo@gmail.com> wrote:
>
> Em Fri, May 15, 2020 at 09:50:00AM -0700, Ian Rogers escreveu:
> > Perf's expr code currently builds an array of strings then removes
> > duplicates. The array is larger than necessary and has recently been
> > increased in size. When this was done it was commented that a hashmap
> > would be preferable.
> >
> > libbpf has a hashmap but libbpf isn't currently required to build
> > perf. To satisfy various concerns this change copies libbpf's hashmap
> > into tools/perf/util, it then adds a check in perf that the two are in
> > sync.
> >
> > Andrii's patch to hashmap from bpf-next is brought into this set to
> > fix issues with hashmap__clear.
> >
> > Two minor changes to libbpf's hashmap are made that remove an unused
> > dependency and fix a compiler warning.
>
> Andrii/Alexei/Daniel, what do you think about me merging these fixes in my
> perf-tools-next branch?

I'm ok with the idea, but it's up to maintainers to coordinate this :)

>
> - Arnaldo
>
> > Two perf test changes are also brought in as they need refactoring to
> > account for the expr API change and it is expected they will land
> > ahead of this.
> > https://lore.kernel.org/lkml/20200513062236.854-2-irogers@google.com/
> >
> > Tested with 'perf test' and 'make -C tools/perf build-test'.
> >
> > The hashmap change was originally part of an RFC:
> > https://lore.kernel.org/lkml/20200508053629.210324-1-irogers@google.com/
> >
> > v2. moves hashmap into tools/perf/util rather than libapi, to allow
> > hashmap's libbpf symbols to be visible when built statically for
> > testing.
> >
> > Andrii Nakryiko (1):
> >   libbpf: Fix memory leak and possible double-free in hashmap__clear
> >
> > Ian Rogers (6):
> >   libbpf hashmap: Remove unused #include
> >   libbpf hashmap: Fix signedness warnings
> >   tools lib/api: Copy libbpf hashmap to tools/perf/util
> >   perf test: Provide a subtest callback to ask for the reason for
> >     skipping a subtest
> >   perf test: Improve pmu event metric testing
> >   perf expr: Migrate expr ids table to a hashmap
> >
> >  tools/lib/bpf/hashmap.c         |  10 +-
> >  tools/lib/bpf/hashmap.h         |   1 -
> >  tools/perf/check-headers.sh     |   4 +
> >  tools/perf/tests/builtin-test.c |  18 ++-
> >  tools/perf/tests/expr.c         |  40 +++---
> >  tools/perf/tests/pmu-events.c   | 169 ++++++++++++++++++++++-
> >  tools/perf/tests/tests.h        |   4 +
> >  tools/perf/util/Build           |   4 +
> >  tools/perf/util/expr.c          | 129 +++++++++--------
> >  tools/perf/util/expr.h          |  26 ++--
> >  tools/perf/util/expr.y          |  22 +--
> >  tools/perf/util/hashmap.c       | 238 ++++++++++++++++++++++++++++++++
> >  tools/perf/util/hashmap.h       | 177 ++++++++++++++++++++++++
> >  tools/perf/util/metricgroup.c   |  87 ++++++------
> >  tools/perf/util/stat-shadow.c   |  49 ++++---
> >  15 files changed, 798 insertions(+), 180 deletions(-)
> >  create mode 100644 tools/perf/util/hashmap.c
> >  create mode 100644 tools/perf/util/hashmap.h
> >
> > --
> > 2.26.2.761.g0e0b3e54be-goog
> >
>
> --
>
> - Arnaldo
