Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 985B94EA22C
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 23:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232617AbiC1VBt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 17:01:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiC1VBs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 17:01:48 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F19E6EB35;
        Mon, 28 Mar 2022 14:00:04 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id k25-20020a056830151900b005b25d8588dbso11507426otp.4;
        Mon, 28 Mar 2022 14:00:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:user-agent:in-reply-to:references
         :message-id:mime-version:content-transfer-encoding;
        bh=9weLHGOdub5OZw2XOarC0R5RiKNEhEhayRIziAlf8Nk=;
        b=HlW7kVJAVx6fk8jqZcDOLwfn+yROa49gqsMmmkwhup+bBzpDejyD/IXhJMktwDmIy3
         bTYAEJHRQZLAbfJ7AwnW82SJ/9xaRIprAIxqFD2TwmYK8DvWkl5kOM6Fs+c/28Mta8le
         lqHuVWovTMZXjlR5Dl1iYkeBspsTVb+bg01tQ9qeksV/wQ/QDm4HaiY2XUfuysEis/S6
         ciJ3ZVUYhh59/YHUXv8HJKRzMQ6cSP+RYgE5s7NCSP1YnF8PvOv9Ke6hS5fl2ciW3J2H
         J8PxsXWdS1O5tqCK4ryy6wG1M2g9uGQc/YD6UZEo5503dLr+EFWM9wQIRq7Z2YkQx3+R
         dDzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:user-agent:in-reply-to
         :references:message-id:mime-version:content-transfer-encoding;
        bh=9weLHGOdub5OZw2XOarC0R5RiKNEhEhayRIziAlf8Nk=;
        b=EQjs+MAR/5qFNeWzdTUhM2lWR+gGsG5XxiyYBU7nU5dNLTRiZwhv48ExQ8wPqaBwk2
         eGUuCKKT9kXJmS9lDADG1hE9hEdSmvDqeXoHfXljVeF0PHn+TLTklrdD83t20qHzGUNI
         rwAvde7NXVkrW3MeXfVGlAKfX4m+haeCePpn1B4xnTh+jkOFNA4zZu117RIt96Zkn2ZH
         col4WoJeof+RuC/lLVZFCXFtDozV3y5eOC5SJUJdx3StvtRr5YO52a61FdBEaU6YN66u
         sVSTWOh34LPLFZiL0RzzsBMtwOAShdaxFuh/mjSXFk4ER95A33+JAi2Od3U8JhelXBZs
         0xrA==
X-Gm-Message-State: AOAM532maxpGsiHFkRSEVgPhAprf2i5qykTQvAwGuhxcxG8tJvz3vf6C
        zJb9/u8FP1hQpf/XgMIOU+kGBvIXvzsBow==
X-Google-Smtp-Source: ABdhPJwldX4DAODDCtFUqD/NTUQbIo3+4mzAvTJXQ9FAHTQCRx5qO1oD1fZjm5az9lZrFqAFm7WIuQ==
X-Received: by 2002:a05:6830:812:b0:5af:6b1b:537f with SMTP id r18-20020a056830081200b005af6b1b537fmr10677769ots.194.1648501203902;
        Mon, 28 Mar 2022 14:00:03 -0700 (PDT)
Received: from [127.0.0.1] ([187.19.239.165])
        by smtp.gmail.com with ESMTPSA id m13-20020a9d7acd000000b005cda59325e6sm7591086otn.60.2022.03.28.14.00.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Mar 2022 14:00:03 -0700 (PDT)
Date:   Mon, 28 Mar 2022 17:59:02 -0300
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
Subject: Re: [PATCH 3/5] perf cpumap: Add intersect function.
User-Agent: K-9 Mail for Android
In-Reply-To: <CAP-5=fVfYtu=wcfUQEzwuJMhxexi3d8hVqF5QFLkj_FWPHLK5Q@mail.gmail.com>
References: <20220328062414.1893550-1-irogers@google.com> <20220328062414.1893550-4-irogers@google.com> <YkIaYq2alnNUiIfr@kernel.org> <CAP-5=fVfYtu=wcfUQEzwuJMhxexi3d8hVqF5QFLkj_FWPHLK5Q@mail.gmail.com>
Message-ID: <CE94B4BA-5073-4332-A13E-2CD20379AA19@gmail.com>
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



On March 28, 2022 5:54:06 PM GMT-03:00, Ian Rogers <irogers@google=2Ecom> =
wrote:
>On Mon, Mar 28, 2022 at 1:28 PM Arnaldo Carvalho de Melo
><acme@kernel=2Eorg> wrote:
>>
>> Em Sun, Mar 27, 2022 at 11:24:12PM -0700, Ian Rogers escreveu:
>> > The merge function gives the union of two cpu maps=2E Add an intersec=
t
>> > function which will be used in the next change=2E
>> >
>> > Signed-off-by: Ian Rogers <irogers@google=2Ecom>
>> > ---
>> >  tools/lib/perf/cpumap=2Ec              | 38 ++++++++++++++++++++++++=
++++
>> >  tools/lib/perf/include/perf/cpumap=2Eh |  2 ++
>> >  2 files changed, 40 insertions(+)
>> >
>> > diff --git a/tools/lib/perf/cpumap=2Ec b/tools/lib/perf/cpumap=2Ec
>> > index 953bc50b0e41=2E=2E56b4d213039f 100644
>> > --- a/tools/lib/perf/cpumap=2Ec
>> > +++ b/tools/lib/perf/cpumap=2Ec
>> > @@ -393,3 +393,41 @@ struct perf_cpu_map *perf_cpu_map__merge(struct =
perf_cpu_map *orig,
>> >       perf_cpu_map__put(orig);
>> >       return merged;
>> >  }
>> > +
>> > +struct perf_cpu_map *perf_cpu_map__intersect(struct perf_cpu_map *or=
ig,
>> > +                                          struct perf_cpu_map *other=
)
>> > +{
>> > +     struct perf_cpu *tmp_cpus;
>> > +     int tmp_len;
>> > +     int i, j, k;
>> > +     struct perf_cpu_map *merged =3D NULL;
>> > +
>> > +     if (perf_cpu_map__is_subset(other, orig))
>> > +             return orig;
>> > +     if (perf_cpu_map__is_subset(orig, other)) {
>> > +             perf_cpu_map__put(orig);
>>
>> Why this put(orig)?
>
>As with merge, if orig isn't returned then it is put=2E

For merge I can see it dropping a reference, i=2Ee=2E get b and merge it i=
nto a, after that b was "consumed"

But for intersect?


>
>> > +             return perf_cpu_map__get(other);
>>
>> And why the get here and not on the first if?
>
>The first argument orig is either put or returned while the second may
>be returned only if the reference count is incremented=2E We could
>change the API for merge and intersect to put both arguments, or to
>not put either argument=2E
>
>Thanks,
>Ian
>
>> > +     }
>> > +
>> > +     tmp_len =3D max(orig->nr, other->nr);
>> > +     tmp_cpus =3D malloc(tmp_len * sizeof(struct perf_cpu));
>> > +     if (!tmp_cpus)
>> > +             return NULL;
>> > +
>> > +     i =3D j =3D k =3D 0;
>> > +     while (i < orig->nr && j < other->nr) {
>> > +             if (orig->map[i]=2Ecpu < other->map[j]=2Ecpu)
>> > +                     i++;
>> > +             else if (orig->map[i]=2Ecpu > other->map[j]=2Ecpu)
>> > +                     j++;
>> > +             else {
>> > +                     j++;
>> > +                     tmp_cpus[k++] =3D orig->map[i++];
>> > +             }
>> > +     }
>> > +     if (k)
>> > +             merged =3D cpu_map__trim_new(k, tmp_cpus);
>> > +     free(tmp_cpus);
>> > +     perf_cpu_map__put(orig);
>> > +     return merged;
>> > +}
>> > diff --git a/tools/lib/perf/include/perf/cpumap=2Eh b/tools/lib/perf/=
include/perf/cpumap=2Eh
>> > index 4a2edbdb5e2b=2E=2Ea2a7216c0b78 100644
>> > --- a/tools/lib/perf/include/perf/cpumap=2Eh
>> > +++ b/tools/lib/perf/include/perf/cpumap=2Eh
>> > @@ -19,6 +19,8 @@ LIBPERF_API struct perf_cpu_map *perf_cpu_map__read=
(FILE *file);
>> >  LIBPERF_API struct perf_cpu_map *perf_cpu_map__get(struct perf_cpu_m=
ap *map);
>> >  LIBPERF_API struct perf_cpu_map *perf_cpu_map__merge(struct perf_cpu=
_map *orig,
>> >                                                    struct perf_cpu_ma=
p *other);
>> > +LIBPERF_API struct perf_cpu_map *perf_cpu_map__intersect(struct perf=
_cpu_map *orig,
>> > +                                                      struct perf_cp=
u_map *other);
>> >  LIBPERF_API void perf_cpu_map__put(struct perf_cpu_map *map);
>> >  LIBPERF_API struct perf_cpu perf_cpu_map__cpu(const struct perf_cpu_=
map *cpus, int idx);
>> >  LIBPERF_API int perf_cpu_map__nr(const struct perf_cpu_map *cpus);
>> > --
>> > 2=2E35=2E1=2E1021=2Eg381101b075-goog
>>
>> --
>>
>> - Arnaldo
