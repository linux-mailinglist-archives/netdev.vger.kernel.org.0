Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE826232713
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 23:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727807AbgG2VoF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 17:44:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726824AbgG2VoE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 17:44:04 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3916CC0619D2
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 14:44:04 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id c80so3994633wme.0
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 14:44:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mi/dvJTEg0t2R7l0GMM3X7cetoBeub/uyssY0Ar4p0A=;
        b=gWRerGwYPfs3GEJPSPeGiVy9kDLdfMcQWRaKWqQRAbRCMhF+ezNp3izGX6ieCUNNfb
         DOVhA2h3oTtrfy+0xgAo9sXh+CJyGVJlUzPekOtkp78dW05W/0LGJYFHJmPlYh2VRRi4
         /4Ne9R9fwpoMr/3fUhweBgVPnYjA0KAx2B3XLVUDBp+98XVxANSrVjC0i6ZuXIBkBAti
         1dB+xgApCPBucGZm7MBrXMa6TBADcfr3LQIpTjVcDXnmm/cGeSIfX2gTgTKMRE+S1Snp
         mNxh+86CTvRFKrSvtrTtKv3ZIFNIqunt0AC/J+fAGIOobLjSMl3/rZ50isad4xujLAwt
         trwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mi/dvJTEg0t2R7l0GMM3X7cetoBeub/uyssY0Ar4p0A=;
        b=SMMXhOncTCZueZLroa7Brkwq3+5h6QRnG/xCOxD4de0onhYutouR0fjc0kBJ8t5k3h
         xOHMwatD72nqY8oZ9sW7vFx8Lk+3K8ylEkgLAwOLoxhGDhN+2j/gWUZqu6Q2F0F39nAb
         uMl57+qcN5vOib3dcedjscj6/4uwY4Wqv8gwJFW+H/ptdFuhXiiGFU5WT12bSkM9xJtA
         BRA2g4F5/WTSbYlYn434h5o2JY1wIo0/i3H80MxqurjvUBq8a1ACggfdwd1MSRB7aSQy
         Kc1pS6K7i6KGahnTGlRijVT/0iO9CgCaGybjIpvK+OBfeFCl27Oo2c15wsbybBf3ru4q
         fEfw==
X-Gm-Message-State: AOAM530EB6QhP1AWh0D1K1Sp+KkSLiJaEpWFxQkS0UHzKWgWnrxPHEKk
        OB4fr8SPQdG4QtgGP0eeA1KkLpH1iUgxsUFAtb0nzQ==
X-Google-Smtp-Source: ABdhPJw7kadwtoqT/a/b33SjfuDDULDgOaiKQAdZ8qBC1fcCq16iGvHJ/Co1tBqK+wqm3KPsa75z0oXAisWugfDClQY=
X-Received: by 2002:a1c:a914:: with SMTP id s20mr10148609wme.76.1596059042636;
 Wed, 29 Jul 2020 14:44:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200728085734.609930-1-irogers@google.com> <20200728085734.609930-2-irogers@google.com>
 <20200729185212.GB433799@kernel.org>
In-Reply-To: <20200729185212.GB433799@kernel.org>
From:   Ian Rogers <irogers@google.com>
Date:   Wed, 29 Jul 2020 14:43:51 -0700
Message-ID: <CAP-5=fUJW+UkL-jZkzkCKqTLh7DC0XnFx06kdfYiu2CK85Wq1w@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] perf record: Set PERF_RECORD_PERIOD if attr->freq
 is set.
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
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
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        David Sharp <dhsharp@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 29, 2020 at 11:52 AM Arnaldo Carvalho de Melo
<acme@kernel.org> wrote:
>
> Em Tue, Jul 28, 2020 at 01:57:30AM -0700, Ian Rogers escreveu:
> > From: David Sharp <dhsharp@google.com>
> >
> > evsel__config() would only set PERF_RECORD_PERIOD if it set attr->freq
>
> There is no such thing as 'PERF_RECORD_PERIOD', its PERF_SAMPLE_PERIOD,
> also...
>
> > from perf record options. When it is set by libpfm events, it would not
> > get set. This changes evsel__config to see if attr->freq is set outside of
> > whether or not it changes attr->freq itself.
> >
> > Signed-off-by: David Sharp <dhsharp@google.com>
> > Signed-off-by: Ian Rogers <irogers@google.com>
> > ---
> >  tools/perf/util/evsel.c | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> >
> > diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
> > index ef802f6d40c1..811f538f7d77 100644
> > --- a/tools/perf/util/evsel.c
> > +++ b/tools/perf/util/evsel.c
> > @@ -979,13 +979,18 @@ void evsel__config(struct evsel *evsel, struct record_opts *opts,
> >       if (!attr->sample_period || (opts->user_freq != UINT_MAX ||
> >                                    opts->user_interval != ULLONG_MAX)) {
> >               if (opts->freq) {
> > -                     evsel__set_sample_bit(evsel, PERIOD);
> >                       attr->freq              = 1;
> >                       attr->sample_freq       = opts->freq;
> >               } else {
> >                       attr->sample_period = opts->default_interval;
> >               }
> >       }
> > +     /*
> > +      * If attr->freq was set (here or earlier), ask for period
> > +      * to be sampled.
> > +      */
> > +     if (attr->freq)
> > +             evsel__set_sample_bit(evsel, PERIOD);
>
> Why can't the libpfm code set opts?
>
> With this patch we will end up calling evsel__set_sample_bit(evsel,
> PERIOD) twice, which isn't a problem but looks strange.

Thanks Arnaldo! The case I was looking at was something like:
perf record --pfm-events cycles:freq=1000

For regular events this would be:
perf record -e cycles/freq=1000/

With libpfm4 events the perf_event_attr is set up (a public API in
linux/perf_event.h) and then parse_events__add_event is used (an
internal API) to make the evsel and this added to the evlist
(parse_libpfm_events_option). This is similar to the parse_events
function except rather than set up a perf_event_attr the regular
parsing sets up config terms that are then applied to evsel and attr
later in evsel__config, via evsel__apply_config_terms.

I think we can  update this change so that in pfm.c after
parse_events__add_event we do:
if (attr.freq)
  evsel__set_sample_bit(evsel, PERIOD);

This code could also be part of parse_events__add_event. I think the
intent in placing this code here was that it is close to the similar
evsel__apply_config_terms and setting of sample bits in the evsel. The
logic here is already dependent on reading the attr->sample_period.

I'm not sure I follow the double setting case - I think that is only
possible with a config term or with period_set (-P).

Thanks,
Ian


> - Arnaldo
>
> >
> >       if (opts->no_samples)
> >               attr->sample_freq = 0;
> > --
> > 2.28.0.163.g6104cc2f0b6-goog
> >
>
> --
>
> - Arnaldo
