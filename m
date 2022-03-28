Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 952F84EA218
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 22:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241185AbiC1U6v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 16:58:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbiC1U6t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 16:58:49 -0400
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 486B6689B2;
        Mon, 28 Mar 2022 13:57:08 -0700 (PDT)
Received: by mail-oi1-x236.google.com with SMTP id e189so16980633oia.8;
        Mon, 28 Mar 2022 13:57:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:user-agent:in-reply-to:references
         :message-id:mime-version:content-transfer-encoding;
        bh=JcBVwR8XLDQBSP8SxdAoaozEKj20bLEdjh0fLBcT41c=;
        b=pdQ/Q1QGUGjzOJukBJjP4U5oOV6QzltQSsx0ywlFcFCxlHmErpakQ71Ntftr133p/8
         FiUxg7uBYqulSwcKApicZjUwChuTc//+n5LXj0fDgjPJOQgU9TPkUxpjMFbVGtlg5CDM
         Xi0ug5YTneIlO2qI5h32eR0TqUbgrRcZLSF8VtxcWrpE1NVLGphOT31Ia4hKaege9aqD
         0SKsvPhD/qQDbCjCZm2aT6XzhjbpxJZC7TE+umvo+Qv29z2Zp71EaiOQNMPIxeMayaQ/
         E23mZCjnjnXRN/Nw377YmYdX7i74xgj5uxtYGqNUDtJ7qCI9VG+Rom988/z8VlI1XGy3
         ObGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:user-agent:in-reply-to
         :references:message-id:mime-version:content-transfer-encoding;
        bh=JcBVwR8XLDQBSP8SxdAoaozEKj20bLEdjh0fLBcT41c=;
        b=UqghicebuQWKqCYsIFwuYhTB4oPR8fnlN1jxvk6NYIsCryHNL8IoC9g4pq4Pw6zDAZ
         fFG5dhcO/ClWPFlN904nDKMvDYUgP0fQq5vU037Xpvgth1yUUkJLgMgfc+vlPfzix4QV
         XaHGDFU51ewg7eQfh8coXRWb9jXH0AAjzdtQMWuXBcWrFMPlrghpDYYWviFKHTC2iyaN
         rCY+CJVwXvfaK7fNWVH4mG546YapXBia3SvFF4C+nuo8VgmEj0OoNzryZ3xH0oUC33Zq
         ZyWtNYzxSeQCy06VPwmXYnp0f8yEHSQrwYyZ0boOGSnAKy1autngh1eazKphdYDfIhD6
         +mjA==
X-Gm-Message-State: AOAM5332vlfkCiv5z0T0cOS+TdPbmX1/eSMQKfUqYmxn29Pr6yqPFSbL
        g7ObALAXdyLDW9XYFJR1xio=
X-Google-Smtp-Source: ABdhPJx3MOEnr/6Eihy5bZZNDW1D7o+VpA7ydx7vu88ZTQ2eahIrFjmv3Vruk4sayEBSpk+UbOV7bQ==
X-Received: by 2002:aca:aa55:0:b0:2ee:e8e8:cf80 with SMTP id t82-20020acaaa55000000b002eee8e8cf80mr581870oie.64.1648501027588;
        Mon, 28 Mar 2022 13:57:07 -0700 (PDT)
Received: from [127.0.0.1] ([187.19.239.165])
        by smtp.gmail.com with ESMTPSA id u14-20020a4ad0ce000000b0032174de7c2csm7414197oor.8.2022.03.28.13.57.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Mar 2022 13:57:06 -0700 (PDT)
Date:   Mon, 28 Mar 2022 17:56:07 -0300
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
To:     Ian Rogers <irogers@google.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
CC:     Peter Zijlstra <peterz@infradead.org>,
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
Subject: Re: [PATCH 2/5] perf cpumap: More cpu map reuse by merge.
User-Agent: K-9 Mail for Android
In-Reply-To: <CAP-5=fVO6mHhGchtRZBDEYm1spK9JmpJ5OSwhNc8BAgzO_XDUg@mail.gmail.com>
References: <20220328062414.1893550-1-irogers@google.com> <20220328062414.1893550-3-irogers@google.com> <YkIZ8MNdWvtPEikz@kernel.org> <CAP-5=fVO6mHhGchtRZBDEYm1spK9JmpJ5OSwhNc8BAgzO_XDUg@mail.gmail.com>
Message-ID: <0A053E2F-284B-4C1B-B09E-AC082916DD0E@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On March 28, 2022 5:50:21 PM GMT-03:00, Ian Rogers <irogers@google=2Ecom> =
wrote:
>On Mon, Mar 28, 2022 at 1:26 PM Arnaldo Carvalho de Melo
><acme@kernel=2Eorg> wrote:
>>
>> Em Sun, Mar 27, 2022 at 11:24:11PM -0700, Ian Rogers escreveu:
>> > perf_cpu_map__merge will reuse one of its arguments if they are equal=
 or
>> > the other argument is NULL=2E The arguments could be reused if it is =
known
>> > one set of values is a subset of the other=2E For example, a map of 0=
-1
>> > and a map of just 0 when merged yields the map of 0-1=2E Currently a =
new
>> > map is created rather than adding a reference count to the original 0=
-1
>> > map=2E
>> >
>> > Signed-off-by: Ian Rogers <irogers@google=2Ecom>
>> > ---
>> >  tools/lib/perf/cpumap=2Ec | 38 ++++++++++++++++++++++++++++---------=
-
>> >  1 file changed, 28 insertions(+), 10 deletions(-)
>> >
>> > diff --git a/tools/lib/perf/cpumap=2Ec b/tools/lib/perf/cpumap=2Ec
>> > index ee66760f1e63=2E=2E953bc50b0e41 100644
>> > --- a/tools/lib/perf/cpumap=2Ec
>> > +++ b/tools/lib/perf/cpumap=2Ec
>> > @@ -319,6 +319,29 @@ struct perf_cpu perf_cpu_map__max(struct perf_cp=
u_map *map)
>> >       return map->nr > 0 ? map->map[map->nr - 1] : result;
>> >  }
>> >
>> > +/** Is 'b' a subset of 'a'=2E */
>> > +static bool perf_cpu_map__is_subset(const struct perf_cpu_map *a,
>> > +                                 const struct perf_cpu_map *b)
>> > +{
>> > +     int i, j;
>> > +
>> > +     if (a =3D=3D b || !b)
>> > +             return true;
>> > +     if (!a || b->nr > a->nr)
>> > +             return false;
>> > +     j =3D 0;
>> > +     for (i =3D 0; i < a->nr; i++) {
>>
>> Since the kernel bumped the minimum gcc version to one that supports
>> declaring loop variables locally and that perf has been using this sinc=
e
>> forever:
>>
>> =E2=AC=A2[acme@toolbox perf]$ grep -r '(int [[:alpha:]] =3D 0;' tools/p=
erf
>> tools/perf/util/block-info=2Ec:   for (int i =3D 0; i < nr_hpps; i++)
>> tools/perf/util/block-info=2Ec:   for (int i =3D 0; i < nr_hpps; i++) {
>> tools/perf/util/block-info=2Ec:   for (int i =3D 0; i < nr_reps; i++)
>> tools/perf/util/stream=2Ec:       for (int i =3D 0; i < nr_evsel; i++)
>> tools/perf/util/stream=2Ec:       for (int i =3D 0; i < nr_evsel; i++) =
{
>> tools/perf/util/stream=2Ec:       for (int i =3D 0; i < els->nr_evsel; =
i++) {
>> tools/perf/util/stream=2Ec:       for (int i =3D 0; i < es_pair->nr_str=
eams; i++) {
>> tools/perf/util/stream=2Ec:       for (int i =3D 0; i < es_base->nr_str=
eams; i++) {
>> tools/perf/util/cpumap=2Ec:               for (int j =3D 0; j < c->nr; =
j++) {
>> tools/perf/util/mem-events=2Ec:   for (int j =3D 0; j < PERF_MEM_EVENTS=
__MAX; j++) {
>> tools/perf/util/header=2Ec:       for (int i =3D 0; i < ff->ph->env=2En=
r_hybrid_cpc_nodes; i++) {
>> tools/perf/builtin-diff=2Ec:      for (int i =3D 0; i < num; i++)
>> tools/perf/builtin-diff=2Ec:              for (int i =3D 0; i < pair->b=
lock_info->num; i++) {
>> tools/perf/builtin-stat=2Ec:      for (int i =3D 0; i < perf_cpu_map__n=
r(a->core=2Ecpus); i++) {
>> =E2=AC=A2[acme@toolbox perf]$
>>
>> And this builds on all my test containers, please use:
>>
>>         for (int i =3D 0, j =3D 0; i < a->nr; i++)
>>
>> In this case to make the source code more compact=2E
>
>Ack=2E We still need to declare 'j' and it is a bit weird to declare j
>before i=2E Fwiw, Making=2Econfig has the CORE_CFLAGS set to gnu99, but
>declaring in the loop is clearly valid in c99=2E
>
>> > +             if (a->map[i]=2Ecpu > b->map[j]=2Ecpu)
>> > +                     return false;
>> > +             if (a->map[i]=2Ecpu =3D=3D b->map[j]=2Ecpu) {
>> > +                     j++;
>> > +                     if (j =3D=3D b->nr)
>> > +                             return true;
>>
>> Ok, as its guaranteed that cpu_maps are ordered=2E
>>
>> > +             }
>> > +     }
>> > +     return false;
>> > +}
>> > +
>> >  /*
>> >   * Merge two cpumaps
>> >   *
>> > @@ -335,17 +358,12 @@ struct perf_cpu_map *perf_cpu_map__merge(struct=
 perf_cpu_map *orig,
>> >       int i, j, k;
>> >       struct perf_cpu_map *merged;
>> >
>> > -     if (!orig && !other)
>> > -             return NULL;
>> > -     if (!orig) {
>> > -             perf_cpu_map__get(other);
>> > -             return other;
>> > -     }
>> > -     if (!other)
>> > -             return orig;
>> > -     if (orig->nr =3D=3D other->nr &&
>> > -         !memcmp(orig->map, other->map, orig->nr * sizeof(struct per=
f_cpu)))
>> > +     if (perf_cpu_map__is_subset(orig, other))
>> >               return orig;
>>
>> Can't we have first the introduction of perf_cpu_map__is_subset() and
>> then another patch that gets the refcount, i=2Ee=2E the four lines belo=
w?
>
>I believe that will fail as it'd be an unused static function warning
>and werror=2E

I thought that it seemed useful enough not to be a static, even if we don'=
t at first export it, i=2Ee=2E keep it as internal to libperf

>
>Thanks,
>Ian
>
>> > +     if (perf_cpu_map__is_subset(other, orig)) {
>> > +             perf_cpu_map__put(orig);
>> > +             return perf_cpu_map__get(other);
>> > +     }
>> >
>> >       tmp_len =3D orig->nr + other->nr;
>> >       tmp_cpus =3D malloc(tmp_len * sizeof(struct perf_cpu));
>> > --
>> > 2=2E35=2E1=2E1021=2Eg381101b075-goog
>>
>> --
>>
>> - Arnaldo
