Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F1C24EA266
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 23:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbiC1V1g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 17:27:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbiC1V1d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 17:27:33 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CB2E139269
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 14:25:44 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id q20so9169777wmq.1
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 14:25:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1G+GATea/gEtUw/pWJqQ7Ixi4GCktSB1NgpSqf6SUpc=;
        b=ff3pbwSNU4OAWweoWrN7aL23MQscP4KSYMsHZHsOC017RgC7WbeViHy1tfJAFmN/lQ
         qFp8xCMw3u+dl/WdgmtmFbZqfFMl58je1HZUNky8io5xTnbaPRkXQ0p9+/bqFsnrV13e
         87CnLMXfFAyqOPugLMqgnQXA6f0hv+SOIMNb34gnrh6Uz6AI78Fkp4AuyeHzB0d6uLcG
         24glXp8ngdRF5tzOTnN1VkSFOoL4g8eAO23bcA6Az6CbvyuOLOjBzyYj9FiQnp3FzjIy
         Oa0ziPsOihA8dfCKzeX/IHsSZgFu39XCtQjS47BWtppn9IvP/uTn5PoEVWvC2O2FdHiy
         1q2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1G+GATea/gEtUw/pWJqQ7Ixi4GCktSB1NgpSqf6SUpc=;
        b=U7jrbHEPzeV8WCsSigQ3jiYel8ywDgZn6XzeCf/r6hXFTjVyRsikl03sglhfT0fCmK
         +ql0iLUkmefUT5UovGcz5sOq6OQS+Mn0tgnoJPoQp9xb2yh9v8GRB8Lj8lAx4ekdtfSK
         Y38wspMQlTolKlMKeii/8yVweTRKYi5dbo5Hkyuwqc2g2Hcxp6XF5kIzNvpwBGkFGVdm
         0dXmpjslwCY9uwiM5Bol+VAuVCAW7pKxSHR1m22ZRUNge4Yy/Gn6/i0yCStmkUni/d3H
         JKx8tYzlrOYVWI++1QQ/zhwMuMSQ5ndEgOY7vN8dX7PWAwX56WF6EnLgsQlr1FwRmm/4
         q7OA==
X-Gm-Message-State: AOAM533w05muXC/Z4HwBaUpRC2F2Z7Omgng2dL+LUl5uzhsPO8T9cN6b
        Y97rfrRG5l64DuOO5e8ZcH/pcZRowbvm5bZ/LIf6ag==
X-Google-Smtp-Source: ABdhPJxqDLS9Je1WTyYK6Q9CxOUbLtpYQHy7lZgCBXI5DykbKcNLXZhVSdUAPUvSuW//+FNsHKaW+O1uZ4s6yxxHfHY=
X-Received: by 2002:a05:600c:2905:b0:381:67e2:3992 with SMTP id
 i5-20020a05600c290500b0038167e23992mr1686003wmd.182.1648502734235; Mon, 28
 Mar 2022 14:25:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220328062414.1893550-1-irogers@google.com> <20220328062414.1893550-4-irogers@google.com>
 <YkIaYq2alnNUiIfr@kernel.org> <CAP-5=fVfYtu=wcfUQEzwuJMhxexi3d8hVqF5QFLkj_FWPHLK5Q@mail.gmail.com>
 <CE94B4BA-5073-4332-A13E-2CD20379AA19@gmail.com>
In-Reply-To: <CE94B4BA-5073-4332-A13E-2CD20379AA19@gmail.com>
From:   Ian Rogers <irogers@google.com>
Date:   Mon, 28 Mar 2022 14:25:21 -0700
Message-ID: <CAP-5=fV+DiB=_+R+g+FLgLOyY5q205OGjfsaZntVKFy4jM4rcg@mail.gmail.com>
Subject: Re: [PATCH 3/5] perf cpumap: Add intersect function.
To:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mike Leach <mike.leach@linaro.org>,
        Leo Yan <leo.yan@linaro.org>,
        John Garry <john.garry@huawei.com>,
        Will Deacon <will@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Kajol Jain <kjain@linux.ibm.com>,
        James Clark <james.clark@arm.com>,
        German Gomez <german.gomez@arm.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Riccardo Mancini <rickyman7@gmail.com>,
        Andi Kleen <ak@linux.intel.com>,
        Alexey Bayduraev <alexey.v.bayduraev@linux.intel.com>,
        Alexander Antonov <alexander.antonov@linux.intel.com>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        coresight@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Stephane Eranian <eranian@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 28, 2022 at 2:00 PM Arnaldo Carvalho de Melo
<arnaldo.melo@gmail.com> wrote:
>
>
>
> On March 28, 2022 5:54:06 PM GMT-03:00, Ian Rogers <irogers@google.com> wrote:
> >On Mon, Mar 28, 2022 at 1:28 PM Arnaldo Carvalho de Melo
> ><acme@kernel.org> wrote:
> >>
> >> Em Sun, Mar 27, 2022 at 11:24:12PM -0700, Ian Rogers escreveu:
> >> > The merge function gives the union of two cpu maps. Add an intersect
> >> > function which will be used in the next change.
> >> >
> >> > Signed-off-by: Ian Rogers <irogers@google.com>
> >> > ---
> >> >  tools/lib/perf/cpumap.c              | 38 ++++++++++++++++++++++++++++
> >> >  tools/lib/perf/include/perf/cpumap.h |  2 ++
> >> >  2 files changed, 40 insertions(+)
> >> >
> >> > diff --git a/tools/lib/perf/cpumap.c b/tools/lib/perf/cpumap.c
> >> > index 953bc50b0e41..56b4d213039f 100644
> >> > --- a/tools/lib/perf/cpumap.c
> >> > +++ b/tools/lib/perf/cpumap.c
> >> > @@ -393,3 +393,41 @@ struct perf_cpu_map *perf_cpu_map__merge(struct perf_cpu_map *orig,
> >> >       perf_cpu_map__put(orig);
> >> >       return merged;
> >> >  }
> >> > +
> >> > +struct perf_cpu_map *perf_cpu_map__intersect(struct perf_cpu_map *orig,
> >> > +                                          struct perf_cpu_map *other)
> >> > +{
> >> > +     struct perf_cpu *tmp_cpus;
> >> > +     int tmp_len;
> >> > +     int i, j, k;
> >> > +     struct perf_cpu_map *merged = NULL;
> >> > +
> >> > +     if (perf_cpu_map__is_subset(other, orig))
> >> > +             return orig;
> >> > +     if (perf_cpu_map__is_subset(orig, other)) {
> >> > +             perf_cpu_map__put(orig);
> >>
> >> Why this put(orig)?
> >
> >As with merge, if orig isn't returned then it is put.
>
> For merge I can see it dropping a reference, i.e. get b and merge it into a, after that b was "consumed"
>
> But for intersect?

The current use case is the intersect of all online CPUs with the
merge of all CPU maps from evsels. So we can generally just reuse
all_cpus, or the common case of both maps contain every CPU. I think
the pattern makes code like:

evlist->cpus = perf_cpu_map__intersect(evlist->cpus, other);

not quite as messy, as without the put you need:

tmp = perf_cpu_map__intersect(evlist->cpus, other);
perf_cpu_map__put(evlist->cpus);
evlist->cpus = tmp;

I'm somewhat agnostic on what the API should be, but it'd be nice if
merge and intersect behaved in a similar way.

Thanks,
Ian

> >
> >> > +             return perf_cpu_map__get(other);
> >>
> >> And why the get here and not on the first if?
> >
> >The first argument orig is either put or returned while the second may
> >be returned only if the reference count is incremented. We could
> >change the API for merge and intersect to put both arguments, or to
> >not put either argument.
> >
> >Thanks,
> >Ian
> >
> >> > +     }
> >> > +
> >> > +     tmp_len = max(orig->nr, other->nr);
> >> > +     tmp_cpus = malloc(tmp_len * sizeof(struct perf_cpu));
> >> > +     if (!tmp_cpus)
> >> > +             return NULL;
> >> > +
> >> > +     i = j = k = 0;
> >> > +     while (i < orig->nr && j < other->nr) {
> >> > +             if (orig->map[i].cpu < other->map[j].cpu)
> >> > +                     i++;
> >> > +             else if (orig->map[i].cpu > other->map[j].cpu)
> >> > +                     j++;
> >> > +             else {
> >> > +                     j++;
> >> > +                     tmp_cpus[k++] = orig->map[i++];
> >> > +             }
> >> > +     }
> >> > +     if (k)
> >> > +             merged = cpu_map__trim_new(k, tmp_cpus);
> >> > +     free(tmp_cpus);
> >> > +     perf_cpu_map__put(orig);
> >> > +     return merged;
> >> > +}
> >> > diff --git a/tools/lib/perf/include/perf/cpumap.h b/tools/lib/perf/include/perf/cpumap.h
> >> > index 4a2edbdb5e2b..a2a7216c0b78 100644
> >> > --- a/tools/lib/perf/include/perf/cpumap.h
> >> > +++ b/tools/lib/perf/include/perf/cpumap.h
> >> > @@ -19,6 +19,8 @@ LIBPERF_API struct perf_cpu_map *perf_cpu_map__read(FILE *file);
> >> >  LIBPERF_API struct perf_cpu_map *perf_cpu_map__get(struct perf_cpu_map *map);
> >> >  LIBPERF_API struct perf_cpu_map *perf_cpu_map__merge(struct perf_cpu_map *orig,
> >> >                                                    struct perf_cpu_map *other);
> >> > +LIBPERF_API struct perf_cpu_map *perf_cpu_map__intersect(struct perf_cpu_map *orig,
> >> > +                                                      struct perf_cpu_map *other);
> >> >  LIBPERF_API void perf_cpu_map__put(struct perf_cpu_map *map);
> >> >  LIBPERF_API struct perf_cpu perf_cpu_map__cpu(const struct perf_cpu_map *cpus, int idx);
> >> >  LIBPERF_API int perf_cpu_map__nr(const struct perf_cpu_map *cpus);
> >> > --
> >> > 2.35.1.1021.g381101b075-goog
> >>
> >> --
> >>
> >> - Arnaldo
