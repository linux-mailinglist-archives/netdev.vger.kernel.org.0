Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7B3FE9B33
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 12:56:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726677AbfJ3L4e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 07:56:34 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:36343 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbfJ3L4e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 07:56:34 -0400
Received: by mail-qt1-f194.google.com with SMTP id x14so2810043qtq.3;
        Wed, 30 Oct 2019 04:56:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=9VRvwupe1Us8UkNQwMDn+6sFPpjxIr5st7RpNyH9QM4=;
        b=TPN+erso+wzp3wJvXdGWSctMy6KBHzbD6wR04o/Aqvn3k79RXz6tgq9PpfG5jvad+m
         GJA5uiTG3ccIQ0yhpGJellPz6PbO8XNVXF1HGw2lruzU3qv3jJslIQsq83EU+fLB8LHe
         w/VBs1tnlPR2R2DPCwckiCqKUOhHT553zr22j2JjzkoYCmuRhYS/MvxmN4GCGRMXKlgs
         1Gv6oC0g4VAFxgqnRKBp6OFtjojanjv8ZopqE6Y/sX+91nSsBhrpopvPZvTtEmxyGe0b
         FrpSCh7FDHqxe8L7e5jED6DIY72JeGgEbh6Xd7HHFHsS5ugiEoDABdqG/fII54i5S+Qd
         ZMow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=9VRvwupe1Us8UkNQwMDn+6sFPpjxIr5st7RpNyH9QM4=;
        b=dokMnhQXiOIPOcd3Orre4lvS0RSwDSOvmo45/caDaArS/rSc6zeDrs+ikSfLAoqQVJ
         KWG7e5Ig7gdG0aVX6EJRoGTC5S+zqTvl1lE8vPAw6z3lJ+CY5B08N12NoQp7eAdeUnHK
         zWNibFnuoJtqH5knJrB7y6qw8NBOP7goxwEvo//UyPgJvO6UoaXIPwPLklJMUIuIHyn2
         Yf/ryRdIE4TqSKJTbgzTQQL+JfDVbPqWR4OJ6t6iIR7Hze4lySx8HcoshimdGvhWE7zA
         CYf/JiKsti8AOBiR1J1ydUY8y+7eeAxy0W2dd/geucfeUSNxCOpMDu8qlI77eKAdta1X
         4uhA==
X-Gm-Message-State: APjAAAXS7DkSUsxEQe5bbRDL63skw4udPiX86tiCWFv4jK1qiehLE/hQ
        3W0yL3xOATwVTC2Fr2wjhdA=
X-Google-Smtp-Source: APXvYqxxqesP5RziDOAjL4/Qu38GF5afIzyj0oWgUb8Gys4rgwSK0lCEzGixCSGV08mdx8RZSN+ObQ==
X-Received: by 2002:aed:3e75:: with SMTP id m50mr4307731qtf.87.1572436593246;
        Wed, 30 Oct 2019 04:56:33 -0700 (PDT)
Received: from quaco.ghostprotocols.net ([179.97.35.50])
        by smtp.gmail.com with ESMTPSA id w15sm1200336qtk.43.2019.10.30.04.56.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Oct 2019 04:56:32 -0700 (PDT)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 28557410D7; Wed, 30 Oct 2019 08:56:30 -0300 (-03)
Date:   Wed, 30 Oct 2019 08:56:30 -0300
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
Subject: Re: [PATCH v4 4/9] perf tools: splice events onto evlist even on
 error
Message-ID: <20191030115630.GC27327@kernel.org>
References: <20191024190202.109403-1-irogers@google.com>
 <20191025180827.191916-1-irogers@google.com>
 <20191025180827.191916-5-irogers@google.com>
 <20191028210712.GB6158@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191028210712.GB6158@krava>
X-Url:  http://acmel.wordpress.com
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Mon, Oct 28, 2019 at 10:07:12PM +0100, Jiri Olsa escreveu:
> On Fri, Oct 25, 2019 at 11:08:22AM -0700, Ian Rogers wrote:
> > If event parsing fails the event list is leaked, instead splice the list
> > onto the out result and let the caller cleanup.
> > 
> > An example input for parse_events found by libFuzzer that reproduces
> > this memory leak is 'm{'.
> > 
> > Signed-off-by: Ian Rogers <irogers@google.com>
> 
> Acked-by: Jiri Olsa <jolsa@kernel.org>

Thanks, applied.
 
> thanks,
> jirka
> 
> > ---
> >  tools/perf/util/parse-events.c | 17 +++++++++++------
> >  1 file changed, 11 insertions(+), 6 deletions(-)
> > 
> > diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
> > index c516d0cce946..4c4c6f3e866a 100644
> > --- a/tools/perf/util/parse-events.c
> > +++ b/tools/perf/util/parse-events.c
> > @@ -1952,15 +1952,20 @@ int parse_events(struct evlist *evlist, const char *str,
> >  
> >  	ret = parse_events__scanner(str, &parse_state, PE_START_EVENTS);
> >  	perf_pmu__parse_cleanup();
> > +
> > +	if (!ret && list_empty(&parse_state.list)) {
> > +		WARN_ONCE(true, "WARNING: event parser found nothing\n");
> > +		return -1;
> > +	}
> > +
> > +	/*
> > +	 * Add list to the evlist even with errors to allow callers to clean up.
> > +	 */
> > +	perf_evlist__splice_list_tail(evlist, &parse_state.list);
> > +
> >  	if (!ret) {
> >  		struct evsel *last;
> >  
> > -		if (list_empty(&parse_state.list)) {
> > -			WARN_ONCE(true, "WARNING: event parser found nothing\n");
> > -			return -1;
> > -		}
> > -
> > -		perf_evlist__splice_list_tail(evlist, &parse_state.list);
> >  		evlist->nr_groups += parse_state.nr_groups;
> >  		last = evlist__last(evlist);
> >  		last->cmdline_group_boundary = true;
> > -- 
> > 2.24.0.rc0.303.g954a862665-goog
> > 

-- 

- Arnaldo
