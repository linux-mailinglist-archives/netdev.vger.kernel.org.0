Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 006951D56F3
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 19:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726302AbgEORAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 13:00:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726144AbgEORAl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 13:00:41 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05537C061A0C;
        Fri, 15 May 2020 10:00:41 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id z9so1396755qvi.12;
        Fri, 15 May 2020 10:00:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AoY0BNeS5s76CJAngCFpdWwtsXhJLMkUY02Jn749C6w=;
        b=o4lMkvd+4qZ/WovyIPQ6EY1ZKJB7R6p9MVI29CLBVNV8RK+aMzWAxwfqQBGaiIYtsc
         sywwbY/QTshA18hHqy5QODROSqiYuHtq1AbcrZG+VnMWCAKUkWCUCSE93TT0hXQ5dW5J
         fmOzRPewctvAnUseiFi6ES+/A3+338B5eaTTeFI6x5ZTLTUXVQ/R3hDcbwMSVneLTMDq
         pKpOufpFhI6NdZ1V+LC7gAku/5t9RZgcgdlUq8dA93Z8NBWQdzMaK0k3CnCwEKZXyfkR
         OsUKANWy40ax0m+YH/XOClUVbveu9LFEQCOdsEYub+OACtA8/6/w84GzpRrGPr1iH271
         CT3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AoY0BNeS5s76CJAngCFpdWwtsXhJLMkUY02Jn749C6w=;
        b=Ha1BHJFlK18D/wvJ4RKD5MnjJaLdQu00sIhBtFveaCwylsZ2OZueFKA4Tsf0ZRlOvg
         rr/NBAlrQHp3XHy0vT3T6RQlQHctQzAanuPV8aLtAOB00ainzC/tW65p/Jf5Mtu1YwuV
         1TeeWqIKHvT6bsl4Cng7n7TUq0i6+mndvcuo8+AOFdHcw1du/qerZ0GX24BjyrNLPoAc
         7faHuKIZiAPxP0L/Ch1/9QlDjALazk3pXcE9oqgjF52OJE2UNc7n2Upy3JZexWsPUjeH
         oyqSnUyedonfXw3L0frUqUYDno2eonmwxc6PycY4rLO13Qs7JvjG5tPMJe3M1QPMAZkk
         nexw==
X-Gm-Message-State: AOAM532U5ZWY34oDTMbCFM3AzISzV3XH3v/zNU29/ElhnbCgtyI5UH/H
        h4bmtf2e0PO1KnlTilA957k=
X-Google-Smtp-Source: ABdhPJzJIQEtu7koHbckefZCoV9JJZTtTJ9GEbszMEGYv4dMDGi4gfxxGpN/9rt4eWJJNV5Re93CHQ==
X-Received: by 2002:a05:6214:905:: with SMTP id dj5mr4437992qvb.222.1589562040125;
        Fri, 15 May 2020 10:00:40 -0700 (PDT)
Received: from quaco.ghostprotocols.net ([179.97.37.151])
        by smtp.gmail.com with ESMTPSA id n124sm1968608qkn.24.2020.05.15.10.00.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2020 10:00:39 -0700 (PDT)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 32E2240AFD; Fri, 15 May 2020 14:00:36 -0300 (-03)
Date:   Fri, 15 May 2020 14:00:36 -0300
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ian Rogers <irogers@google.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
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
        Leo Yan <leo.yan@linaro.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH v2 0/7] Copy hashmap to tools/perf/util, use in perf expr
Message-ID: <20200515170036.GA10230@kernel.org>
References: <20200515165007.217120-1-irogers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200515165007.217120-1-irogers@google.com>
X-Url:  http://acmel.wordpress.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Fri, May 15, 2020 at 09:50:00AM -0700, Ian Rogers escreveu:
> Perf's expr code currently builds an array of strings then removes
> duplicates. The array is larger than necessary and has recently been
> increased in size. When this was done it was commented that a hashmap
> would be preferable.
> 
> libbpf has a hashmap but libbpf isn't currently required to build
> perf. To satisfy various concerns this change copies libbpf's hashmap
> into tools/perf/util, it then adds a check in perf that the two are in
> sync.
> 
> Andrii's patch to hashmap from bpf-next is brought into this set to
> fix issues with hashmap__clear.
> 
> Two minor changes to libbpf's hashmap are made that remove an unused
> dependency and fix a compiler warning.

Andrii/Alexei/Daniel, what do you think about me merging these fixes in my
perf-tools-next branch?

- Arnaldo
 
> Two perf test changes are also brought in as they need refactoring to
> account for the expr API change and it is expected they will land
> ahead of this.
> https://lore.kernel.org/lkml/20200513062236.854-2-irogers@google.com/
> 
> Tested with 'perf test' and 'make -C tools/perf build-test'.
> 
> The hashmap change was originally part of an RFC:
> https://lore.kernel.org/lkml/20200508053629.210324-1-irogers@google.com/
> 
> v2. moves hashmap into tools/perf/util rather than libapi, to allow
> hashmap's libbpf symbols to be visible when built statically for
> testing.
> 
> Andrii Nakryiko (1):
>   libbpf: Fix memory leak and possible double-free in hashmap__clear
> 
> Ian Rogers (6):
>   libbpf hashmap: Remove unused #include
>   libbpf hashmap: Fix signedness warnings
>   tools lib/api: Copy libbpf hashmap to tools/perf/util
>   perf test: Provide a subtest callback to ask for the reason for
>     skipping a subtest
>   perf test: Improve pmu event metric testing
>   perf expr: Migrate expr ids table to a hashmap
> 
>  tools/lib/bpf/hashmap.c         |  10 +-
>  tools/lib/bpf/hashmap.h         |   1 -
>  tools/perf/check-headers.sh     |   4 +
>  tools/perf/tests/builtin-test.c |  18 ++-
>  tools/perf/tests/expr.c         |  40 +++---
>  tools/perf/tests/pmu-events.c   | 169 ++++++++++++++++++++++-
>  tools/perf/tests/tests.h        |   4 +
>  tools/perf/util/Build           |   4 +
>  tools/perf/util/expr.c          | 129 +++++++++--------
>  tools/perf/util/expr.h          |  26 ++--
>  tools/perf/util/expr.y          |  22 +--
>  tools/perf/util/hashmap.c       | 238 ++++++++++++++++++++++++++++++++
>  tools/perf/util/hashmap.h       | 177 ++++++++++++++++++++++++
>  tools/perf/util/metricgroup.c   |  87 ++++++------
>  tools/perf/util/stat-shadow.c   |  49 ++++---
>  15 files changed, 798 insertions(+), 180 deletions(-)
>  create mode 100644 tools/perf/util/hashmap.c
>  create mode 100644 tools/perf/util/hashmap.h
> 
> -- 
> 2.26.2.761.g0e0b3e54be-goog
> 

-- 

- Arnaldo
