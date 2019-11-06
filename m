Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C224FF18BF
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 15:36:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731959AbfKFOfy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 09:35:54 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:38713 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727321AbfKFOfy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 09:35:54 -0500
Received: by mail-qt1-f194.google.com with SMTP id p20so15642551qtq.5;
        Wed, 06 Nov 2019 06:35:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=gWaWc2qSkhh0jyxJemX9BkyQA39c3n/0zxtISnFYQhM=;
        b=P1NvzCEwkmM0+gg8uED5ejPWmfxAXqQzanJBmHeoMx5xmgcfrT6y/izV5ygA0uaaCX
         cA/mha1FGQ//zo/itj3nJNEtWtJOcFvC23CrARMXVzwCFu4+o4E4pSYfxgN6VaT6t0HD
         KEQXcA/g1d4Dop+B0U9fRjf7Q6Lyz25M5sesM8N+XDB6edzDlqE1IO6rzM6K6U4ZZR6c
         WWNWrkATt4PUt9H4FZ/SMG0Z55WCb6yqyptOUXRrQKPG5hyTJp9Ee21eEg6xiZHnPrWZ
         9mNOUGiV8rghBSsCibYTZlGsWOFEN1Rk9NWzk4ibDuhNFMJxm3/PIg28pgX4th376Tkv
         X7rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=gWaWc2qSkhh0jyxJemX9BkyQA39c3n/0zxtISnFYQhM=;
        b=uGwMzAZw7JhYxEK4IE8srP+s14pzGjgUujSgu+VYbbxHuJevGRcI0QI1vU/zSang65
         W23hbSsCQlscTYG6L3TQ1ijdH5aSLBo4uJEYmTxLUfm4gUbd7vRJLVDn8qcDdYKrTjox
         PTkFykOOYjN2PK74KtLgOojv2DMO/x69GeiHykZP5CPAaWeEi/JesSo0r6j6Nz/Swp2+
         L1yix/kLixw9YBjLBPxZ419/D0/GzuX8IUrNNNilAFYVv/T+DiKxlfU0qpNFTS85ARjy
         oyfAHHqHIvrZ/d7YE4pp0T3c4/huRbETSezNSyGMtSvnuHZPr41s6oltqgr3k3VHVkb2
         mD/Q==
X-Gm-Message-State: APjAAAWYuMoy9ZAw279rtcfTWK3LVCFIfw7LtU4HKSUxDLVCMkIn2x39
        viQ6bnY5U6HKwM6utEmGcFg=
X-Google-Smtp-Source: APXvYqxwVyKRBIOEKpWvi7JRAYDjFBUsjPzsDN0466AAwomTOQI+vW4JEsykotp3uq/1ur2CpbTKyg==
X-Received: by 2002:ac8:6ec4:: with SMTP id f4mr2683702qtv.271.1573050952921;
        Wed, 06 Nov 2019 06:35:52 -0800 (PST)
Received: from quaco.ghostprotocols.net ([179.97.35.50])
        by smtp.gmail.com with ESMTPSA id l14sm9990457qkj.61.2019.11.06.06.35.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2019 06:35:52 -0800 (PST)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id C4E6B40B1D; Wed,  6 Nov 2019 11:35:49 -0300 (-03)
Date:   Wed, 6 Nov 2019 11:35:49 -0300
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
Subject: Re: [PATCH v5 06/10] perf tools: add destructors for parse event
 terms
Message-ID: <20191106143549.GD6259@kernel.org>
References: <20191025180827.191916-1-irogers@google.com>
 <20191030223448.12930-1-irogers@google.com>
 <20191030223448.12930-7-irogers@google.com>
 <20191106142424.GG30214@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191106142424.GG30214@krava>
X-Url:  http://acmel.wordpress.com
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Wed, Nov 06, 2019 at 03:24:24PM +0100, Jiri Olsa escreveu:
> On Wed, Oct 30, 2019 at 03:34:44PM -0700, Ian Rogers wrote:
> > If parsing fails then destructors are ran to clean the up the stack.
> > Rename the head union member to make the term and evlist use cases more
> > distinct, this simplifies matching the correct destructor.
> > 
> > Signed-off-by: Ian Rogers <irogers@google.com>
> 
> Acked-by: Jiri Olsa <jolsa@kernel.org>
> 
> thanks,
> jirka
> > @@ -37,6 +38,25 @@ static struct list_head* alloc_list()
> >  	return list;
> >  }
> >  
> > +static void free_list_evsel(struct list_head* list_evsel)
> > +{
> > +	struct evsel *evsel, *tmp;
> > +
> > +	list_for_each_entry_safe(evsel, tmp, list_evsel, core.node) {
> > +		list_del_init(&evsel->core.node);
> > +		perf_evsel__delete(evsel);
> > +	}
> > +	free(list_evsel);
> > +}

Applying, but later I think we should use something like:

void __perf_evlist__purge(truct list_head *list)
{
	with the above code
}

And:

void perf_evlist__purge(struct perf_evlist *evlist)
{
	__perf_evlist__purge(&evlist->entries);
	evlist->nr_entries = 0;
}

To replace the existing:

static void perf_evlist__purge(struct perf_evlist *evlist)
{
        struct perf_evsel *pos, *n;

        perf_evlist__for_each_entry_safe(evlist, n, pos) {
                list_del_init(&pos->node);
                perf_evsel__delete(pos);
        }

        evlist->nr_entries = 0;
}

Anyway, applied.

- Arnaldo

> > +static void free_term(struct parse_events_term *term)
> > +{
> > +	if (term->type_val == PARSE_EVENTS__TERM_TYPE_STR)
> > +		free(term->val.str);
> > +	zfree(&term->array.ranges);
> > +	free(term);
> > +}
> > +
> >  static void inc_group_count(struct list_head *list,
> >  		       struct parse_events_state *parse_state)
> >  {
> > @@ -66,6 +86,7 @@ static void inc_group_count(struct list_head *list,
> >  %type <num> PE_VALUE_SYM_TOOL
> >  %type <num> PE_RAW
> >  %type <num> PE_TERM
> > +%type <num> value_sym
> >  %type <str> PE_NAME
> >  %type <str> PE_BPF_OBJECT
> >  %type <str> PE_BPF_SOURCE
> > @@ -76,37 +97,43 @@ static void inc_group_count(struct list_head *list,
> >  %type <str> PE_EVENT_NAME
> >  %type <str> PE_PMU_EVENT_PRE PE_PMU_EVENT_SUF PE_KERNEL_PMU_EVENT
> >  %type <str> PE_DRV_CFG_TERM
> > -%type <num> value_sym
> > -%type <head> event_config
> > -%type <head> opt_event_config
> > -%type <head> opt_pmu_config
> > +%destructor { free ($$); } <str>
> >  %type <term> event_term
> > -%type <head> event_pmu
> > -%type <head> event_legacy_symbol
> > -%type <head> event_legacy_cache
> > -%type <head> event_legacy_mem
> > -%type <head> event_legacy_tracepoint
> > +%destructor { free_term ($$); } <term>
> > +%type <list_terms> event_config
> > +%type <list_terms> opt_event_config
> > +%type <list_terms> opt_pmu_config
> > +%destructor { parse_events_terms__delete ($$); } <list_terms>
> > +%type <list_evsel> event_pmu
> > +%type <list_evsel> event_legacy_symbol
> > +%type <list_evsel> event_legacy_cache
> > +%type <list_evsel> event_legacy_mem
> > +%type <list_evsel> event_legacy_tracepoint
> > +%type <list_evsel> event_legacy_numeric
> > +%type <list_evsel> event_legacy_raw
> > +%type <list_evsel> event_bpf_file
> > +%type <list_evsel> event_def
> > +%type <list_evsel> event_mod
> > +%type <list_evsel> event_name
> > +%type <list_evsel> event
> > +%type <list_evsel> events
> > +%type <list_evsel> group_def
> > +%type <list_evsel> group
> > +%type <list_evsel> groups
> > +%destructor { free_list_evsel ($$); } <list_evsel>
> >  %type <tracepoint_name> tracepoint_name
> > -%type <head> event_legacy_numeric
> > -%type <head> event_legacy_raw
> > -%type <head> event_bpf_file
> > -%type <head> event_def
> > -%type <head> event_mod
> > -%type <head> event_name
> > -%type <head> event
> > -%type <head> events
> > -%type <head> group_def
> > -%type <head> group
> > -%type <head> groups
> > +%destructor { free ($$.sys); free ($$.event); } <tracepoint_name>
> >  %type <array> array
> >  %type <array> array_term
> >  %type <array> array_terms
> > +%destructor { free ($$.ranges); } <array>
> >  
> >  %union
> >  {
> >  	char *str;
> >  	u64 num;
> > -	struct list_head *head;
> > +	struct list_head *list_evsel;
> > +	struct list_head *list_terms;
> >  	struct parse_events_term *term;
> >  	struct tracepoint_name {
> >  		char *sys;
> > -- 
> > 2.24.0.rc1.363.gb1bccd3e3d-goog
> > 

-- 

- Arnaldo
