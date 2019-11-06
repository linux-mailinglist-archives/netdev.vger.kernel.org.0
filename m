Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5D2DF18E5
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 15:39:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732090AbfKFOjV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 09:39:21 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:40472 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728383AbfKFOjV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 09:39:21 -0500
Received: by mail-qt1-f196.google.com with SMTP id o49so33885909qta.7;
        Wed, 06 Nov 2019 06:39:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=lPCixJQnRcBD0c5p0tZ1Pszikd0T2GsXeZOZpWPEV90=;
        b=S/H+0cHuo3kMWiR+Xz0C5SxG+JllAosLufeEsQ5zovichapVBPLp3mMQ52cAyk9ttH
         3HP7vJXXn1V4+pazSiii1SStzyMbIWvVTCkfN2mDQinJf/XdDyn5Xeu9PqA38vkqVb/8
         2iqd7+qkmCwtEt2UjDNk1Mb7qTneD7GYQmcHJ3sWrqhfKPaMof7a+kdx7oho773A0WC6
         RT6ZZgf+WVM9jGoU4BraeTp3vli82dvQ51YQxZUYDiEDehLbWnkD3josCr/7UocY/u6v
         lJgsgN7c4NTfNc55ezD+jGzo2QPBN74R6jYO2Vn3H7GIJi1z7cmk1PozJuVj3ayje/wT
         EM7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=lPCixJQnRcBD0c5p0tZ1Pszikd0T2GsXeZOZpWPEV90=;
        b=fM3ID30KUeLBAJNfdVvDemhplnFYh5IaxoomYfqcZkt1OvtyQTY33CyPd+FixwUeCZ
         e9L4fs3XFnYppQtwO3WQlJvMe7QPE9Thj6kzdcUTxAsUJY9zJ9WtQO9iXiib5jSCl0x/
         Mril4JgHzcevZFC4iOc5iNEgjaNTm0SPjU0JahHevGN3ZoYEzIbJRXhy1VFY3KDfF5gJ
         ha9tCnkEEITm012kZtnSs/wV4K80vtb+Ap07ijzuDlMhs8iEjEYaeB6HzRCHhhIM0lXN
         I02qCdLbuwVTR1523iCmq/LIajpdw7cKNDD+ZVmGV0/7Kn+xOl7d+kj1ljZfmv5dX+UP
         C26Q==
X-Gm-Message-State: APjAAAWn1guDqDTvgcWJm8f32x7/2OEjpcEiT1uElfigOLZNQFb0dk2i
        4SarTtD4kTxDqO0DhwTeVIQ=
X-Google-Smtp-Source: APXvYqwiDiXMhraahcYlpzbeNOhluE0gyBtlhGPEW4m4pSQb9qL77rPuWWs/5qGhXmX14QtQRoYXKg==
X-Received: by 2002:aed:228b:: with SMTP id p11mr2729632qtc.196.1573051159674;
        Wed, 06 Nov 2019 06:39:19 -0800 (PST)
Received: from quaco.ghostprotocols.net ([179.97.35.50])
        by smtp.gmail.com with ESMTPSA id t132sm13057929qke.51.2019.11.06.06.39.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2019 06:39:19 -0800 (PST)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 374D440B1D; Wed,  6 Nov 2019 11:39:17 -0300 (-03)
Date:   Wed, 6 Nov 2019 11:39:17 -0300
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
Subject: Re: [PATCH v5 09/10] perf tools: add a deep delete for parse event
 terms
Message-ID: <20191106143917.GG6259@kernel.org>
References: <20191025180827.191916-1-irogers@google.com>
 <20191030223448.12930-1-irogers@google.com>
 <20191030223448.12930-10-irogers@google.com>
 <20191106142444.GI30214@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191106142444.GI30214@krava>
X-Url:  http://acmel.wordpress.com
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Wed, Nov 06, 2019 at 03:24:44PM +0100, Jiri Olsa escreveu:
> On Wed, Oct 30, 2019 at 03:34:47PM -0700, Ian Rogers wrote:
> > Add a parse_events_term deep delete function so that owned strings and
> > arrays are freed.
> > 
> > Signed-off-by: Ian Rogers <irogers@google.com>
> 
> Acked-by: Jiri Olsa <jolsa@kernel.org>

Thanks, applied,

- Arnaldo
> 
> thanks,
> jirka
> 
> > ---
> >  tools/perf/util/parse-events.c | 16 +++++++++++++---
> >  tools/perf/util/parse-events.h |  1 +
> >  tools/perf/util/parse-events.y | 12 ++----------
> >  tools/perf/util/pmu.c          |  2 +-
> >  4 files changed, 17 insertions(+), 14 deletions(-)
> > 
> > diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
> > index a0a80f4e7038..6d18ff9bce49 100644
> > --- a/tools/perf/util/parse-events.c
> > +++ b/tools/perf/util/parse-events.c
> > @@ -2812,6 +2812,18 @@ int parse_events_term__clone(struct parse_events_term **new,
> >  	return new_term(new, &temp, str, 0);
> >  }
> >  
> > +void parse_events_term__delete(struct parse_events_term *term)
> > +{
> > +	if (term->array.nr_ranges)
> > +		zfree(&term->array.ranges);
> > +
> > +	if (term->type_val != PARSE_EVENTS__TERM_TYPE_NUM)
> > +		zfree(&term->val.str);
> > +
> > +	zfree(&term->config);
> > +	free(term);
> > +}
> > +
> >  int parse_events_copy_term_list(struct list_head *old,
> >  				 struct list_head **new)
> >  {
> > @@ -2842,10 +2854,8 @@ void parse_events_terms__purge(struct list_head *terms)
> >  	struct parse_events_term *term, *h;
> >  
> >  	list_for_each_entry_safe(term, h, terms, list) {
> > -		if (term->array.nr_ranges)
> > -			zfree(&term->array.ranges);
> >  		list_del_init(&term->list);
> > -		free(term);
> > +		parse_events_term__delete(term);
> >  	}
> >  }
> >  
> > diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
> > index 34f58d24a06a..5ee8ac93840c 100644
> > --- a/tools/perf/util/parse-events.h
> > +++ b/tools/perf/util/parse-events.h
> > @@ -139,6 +139,7 @@ int parse_events_term__sym_hw(struct parse_events_term **term,
> >  			      char *config, unsigned idx);
> >  int parse_events_term__clone(struct parse_events_term **new,
> >  			     struct parse_events_term *term);
> > +void parse_events_term__delete(struct parse_events_term *term);
> >  void parse_events_terms__delete(struct list_head *terms);
> >  void parse_events_terms__purge(struct list_head *terms);
> >  void parse_events__clear_array(struct parse_events_array *a);
> > diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
> > index 376b19855470..4cac830015be 100644
> > --- a/tools/perf/util/parse-events.y
> > +++ b/tools/perf/util/parse-events.y
> > @@ -49,14 +49,6 @@ static void free_list_evsel(struct list_head* list_evsel)
> >  	free(list_evsel);
> >  }
> >  
> > -static void free_term(struct parse_events_term *term)
> > -{
> > -	if (term->type_val == PARSE_EVENTS__TERM_TYPE_STR)
> > -		free(term->val.str);
> > -	zfree(&term->array.ranges);
> > -	free(term);
> > -}
> > -
> >  static void inc_group_count(struct list_head *list,
> >  		       struct parse_events_state *parse_state)
> >  {
> > @@ -99,7 +91,7 @@ static void inc_group_count(struct list_head *list,
> >  %type <str> PE_DRV_CFG_TERM
> >  %destructor { free ($$); } <str>
> >  %type <term> event_term
> > -%destructor { free_term ($$); } <term>
> > +%destructor { parse_events_term__delete ($$); } <term>
> >  %type <list_terms> event_config
> >  %type <list_terms> opt_event_config
> >  %type <list_terms> opt_pmu_config
> > @@ -694,7 +686,7 @@ event_config ',' event_term
> >  	struct parse_events_term *term = $3;
> >  
> >  	if (!head) {
> > -		free_term(term);
> > +		parse_events_term__delete(term);
> >  		YYABORT;
> >  	}
> >  	list_add_tail(&term->list, head);
> > diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
> > index f9f427d4c313..db1e57113f4b 100644
> > --- a/tools/perf/util/pmu.c
> > +++ b/tools/perf/util/pmu.c
> > @@ -1260,7 +1260,7 @@ int perf_pmu__check_alias(struct perf_pmu *pmu, struct list_head *head_terms,
> >  		info->metric_name = alias->metric_name;
> >  
> >  		list_del_init(&term->list);
> > -		free(term);
> > +		parse_events_term__delete(term);
> >  	}
> >  
> >  	/*
> > -- 
> > 2.24.0.rc1.363.gb1bccd3e3d-goog
> > 

-- 

- Arnaldo
