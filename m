Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 566E7F18D7
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 15:38:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732024AbfKFOie (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 09:38:34 -0500
Received: from mail-qv1-f66.google.com ([209.85.219.66]:33509 "EHLO
        mail-qv1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728263AbfKFOid (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 09:38:33 -0500
Received: by mail-qv1-f66.google.com with SMTP id x14so1484735qvu.0;
        Wed, 06 Nov 2019 06:38:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=2Tb1/hKPm3+F/7SxGWBVse5bTUY23XeqNi5ZvlET660=;
        b=Stc+piijACmbqLmfIaNMerDt+3mSvPTp9EDYb8CTHWBKS97GI4Nk1wUD0j75+zcJl7
         0Jl0vxfC7Jxkejmi1+TsejqDm4KRg7vIzCwaWvfpBDt6NrRXs3pAbZejR9KPtaQ9T/e3
         5rEF2FAnsCn8zYaWjdokSrCTy9SewqRXYcbqzzIdBwACJ5WQI4jLyFbleTj2OMoVTHlK
         TVgb8mKNEBac9FQNKbqBJGPACK38k74e9toigtbANebX6amhZDU03dzzFL/5BG5biZyc
         qPLdUSEsIlUDG+0NbzcYH1Un4ytHB1ZMuywsKbpA4X/J1oAdU1V79hMJ/q8KRU74hKJF
         JPjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=2Tb1/hKPm3+F/7SxGWBVse5bTUY23XeqNi5ZvlET660=;
        b=IefuYTZl0FjBoLXr+THTpq4eHmntQsk+17WTlSvKPhUIMb6lXSriHhiEhZUjerTXZX
         vVnNrVog0mn5ieZ7YgoW/EaaHLBXq5fLbkPE+3ygpUM7y9HWfZnbyUEM6u42EHlsvenm
         PL0bsNfOkVkhHTvUcKZGcuH6pgGAnGxXIy2DTpHmqGAINBfCNJF/mqMf29+4d+/ypNQL
         rYPqNLIRPQEBfsJaZL1RyKtHkN/bh/ex5//qVzTdZkTK7R5lDkTavDGjJypceXapZHbn
         NbFYmGqYlCchXuH7vJzC/UCbRtvf5VZ59jVrzyc6J2nsWg+qRnEqwo9LiIQAfpT9crJX
         75kw==
X-Gm-Message-State: APjAAAUwVx7npPAC3NryvGE4VaMLWmD8sMOuTmP+ZdodW/WwLoBsDepx
        aW3cf2E7VeBOg3Qn765HvTM=
X-Google-Smtp-Source: APXvYqxwWl+80VoXg6lS9d2SqPUKiAy6KnGHMizGL4Ig6KpmeW1xxH36WWYTcNNr2MDRkyVXQhEGKw==
X-Received: by 2002:a0c:fecc:: with SMTP id z12mr2430282qvs.189.1573051112224;
        Wed, 06 Nov 2019 06:38:32 -0800 (PST)
Received: from quaco.ghostprotocols.net ([179.97.35.50])
        by smtp.gmail.com with ESMTPSA id r2sm14873968qtc.28.2019.11.06.06.38.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2019 06:38:31 -0800 (PST)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id A667740B1D; Wed,  6 Nov 2019 11:38:29 -0300 (-03)
Date:   Wed, 6 Nov 2019 11:38:29 -0300
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Ian Rogers <irogers@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andi Kleen <ak@linux.intel.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        John Garry <john.garry@huawei.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH v5 08/10] perf tools: if pmu configuration fails free
 terms
Message-ID: <20191106143829.GF6259@kernel.org>
References: <20191025180827.191916-1-irogers@google.com>
 <20191030223448.12930-1-irogers@google.com>
 <20191030223448.12930-9-irogers@google.com>
 <20191106142408.GF30214@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191106142408.GF30214@krava>
X-Url:  http://acmel.wordpress.com
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Wed, Nov 06, 2019 at 03:24:08PM +0100, Jiri Olsa escreveu:
> On Wed, Oct 30, 2019 at 03:34:46PM -0700, Ian Rogers wrote:
> > Avoid a memory leak when the configuration fails.
> > 
> > Signed-off-by: Ian Rogers <irogers@google.com>
> 
> Acked-by: Jiri Olsa <jolsa@kernel.org>

Thanks, applied,

- Arnaldo
 
> thanks,
> jirka
> 
> > ---
> >  tools/perf/util/parse-events.c | 9 ++++++++-
> >  1 file changed, 8 insertions(+), 1 deletion(-)
> > 
> > diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
> > index 578288c94d2a..a0a80f4e7038 100644
> > --- a/tools/perf/util/parse-events.c
> > +++ b/tools/perf/util/parse-events.c
> > @@ -1388,8 +1388,15 @@ int parse_events_add_pmu(struct parse_events_state *parse_state,
> >  	if (get_config_terms(head_config, &config_terms))
> >  		return -ENOMEM;
> >  
> > -	if (perf_pmu__config(pmu, &attr, head_config, parse_state->error))
> > +	if (perf_pmu__config(pmu, &attr, head_config, parse_state->error)) {
> > +		struct perf_evsel_config_term *pos, *tmp;
> > +
> > +		list_for_each_entry_safe(pos, tmp, &config_terms, list) {
> > +			list_del_init(&pos->list);
> > +			free(pos);
> > +		}
> >  		return -EINVAL;
> > +	}
> >  
> >  	evsel = __add_event(list, &parse_state->idx, &attr,
> >  			    get_config_name(head_config), pmu,
> > -- 
> > 2.24.0.rc1.363.gb1bccd3e3d-goog
> > 

-- 

- Arnaldo
