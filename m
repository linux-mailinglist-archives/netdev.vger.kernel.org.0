Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 011A9230E3F
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 17:44:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730899AbgG1PoC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 11:44:02 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:37110 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730703AbgG1PoB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 11:44:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595951040;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FDf5+25lFZcklL9KwYj+G66FeAA38ciNootaoOX+T3U=;
        b=doXl+MlxMiwcOziNjhC5zo0yp1v323PIoLQS+4/Ag2I3bpLF0qqm3Vr6EsAXaxKksqn/q8
        3kJwv+MO5rR1luoXXEftn94keUSIUY3AjRfWBdV+R3qzsmMaOKHXiBzAeGZAdY4dM5uHgP
        5Ea6BK3Cg48xkz/sldt3Yoplapg5Irg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-423-wdmVKuviMTaLJ2WQ1NolbQ-1; Tue, 28 Jul 2020 11:43:56 -0400
X-MC-Unique: wdmVKuviMTaLJ2WQ1NolbQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 58D89E91C;
        Tue, 28 Jul 2020 15:43:53 +0000 (UTC)
Received: from krava (unknown [10.40.192.211])
        by smtp.corp.redhat.com (Postfix) with SMTP id 2FF1287B08;
        Tue, 28 Jul 2020 15:43:47 +0000 (UTC)
Date:   Tue, 28 Jul 2020 17:43:47 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Ian Rogers <irogers@google.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
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
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        David Sharp <dhsharp@google.com>
Subject: Re: [PATCH v2 1/5] perf record: Set PERF_RECORD_PERIOD if attr->freq
 is set.
Message-ID: <20200728154347.GB1319041@krava>
References: <20200728085734.609930-1-irogers@google.com>
 <20200728085734.609930-2-irogers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200728085734.609930-2-irogers@google.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 28, 2020 at 01:57:30AM -0700, Ian Rogers wrote:
> From: David Sharp <dhsharp@google.com>
> 
> evsel__config() would only set PERF_RECORD_PERIOD if it set attr->freq
> from perf record options. When it is set by libpfm events, it would not
> get set. This changes evsel__config to see if attr->freq is set outside of
> whether or not it changes attr->freq itself.
> 
> Signed-off-by: David Sharp <dhsharp@google.com>
> Signed-off-by: Ian Rogers <irogers@google.com>

Acked-by: Jiri Olsa <jolsa@redhat.com>

thanks,
jirka

> ---
>  tools/perf/util/evsel.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
> index ef802f6d40c1..811f538f7d77 100644
> --- a/tools/perf/util/evsel.c
> +++ b/tools/perf/util/evsel.c
> @@ -979,13 +979,18 @@ void evsel__config(struct evsel *evsel, struct record_opts *opts,
>  	if (!attr->sample_period || (opts->user_freq != UINT_MAX ||
>  				     opts->user_interval != ULLONG_MAX)) {
>  		if (opts->freq) {
> -			evsel__set_sample_bit(evsel, PERIOD);
>  			attr->freq		= 1;
>  			attr->sample_freq	= opts->freq;
>  		} else {
>  			attr->sample_period = opts->default_interval;
>  		}
>  	}
> +	/*
> +	 * If attr->freq was set (here or earlier), ask for period
> +	 * to be sampled.
> +	 */
> +	if (attr->freq)
> +		evsel__set_sample_bit(evsel, PERIOD);
>  
>  	if (opts->no_samples)
>  		attr->sample_freq = 0;
> -- 
> 2.28.0.163.g6104cc2f0b6-goog
> 

