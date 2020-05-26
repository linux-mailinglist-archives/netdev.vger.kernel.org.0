Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A6A31BF99E
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 15:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbgD3Neu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 09:34:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726685AbgD3Net (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 09:34:49 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72B5DC035494;
        Thu, 30 Apr 2020 06:34:49 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id g26so1051587qtv.13;
        Thu, 30 Apr 2020 06:34:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2+Gwnl4hJoj86c+sSLRRCZ7jx9ijMr4McbV6NyICID8=;
        b=qYfMmsv/ib60JWaTjyRrL8eR8cxz4mXm0le0yxrdR7QukE1lHoFB4edYIaC/eOtRtn
         a+5SYFzJubmwsMb5TiwP1XeU9TGuMhNWrfR9+66wGQs6kT7PwQucGyaVbfopkULzwlAV
         JgqKtTY1ohj49KR5JNEu9fIL4uo06R5NES7thAA434NIe++XL3af5sCYyaTGOjeY91zR
         jkez+bd1WHBhuRe7s6BfxwinDZZsyirE0ybfnravqqBaAvY97u31ICJP9vXHJfhFJ0Tg
         yiBo3VozVsApUpzk/lDlZfLhKTsNeQx6GPacz8InoBbZuiVrOIp2XNNp1esGI9KUioFT
         RHvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2+Gwnl4hJoj86c+sSLRRCZ7jx9ijMr4McbV6NyICID8=;
        b=foen/+0XxkfH//1ECiSf8SVm3fzRXVzk3MA9U0T+bASYdfaE2vw0bEsrUJIXq47QDF
         Mtg3B2XxWX9xYy4qu9byQlXF6utTOhrnD9Xo6cVewhW97BfxhSDPBHCbdSOfmcXlV1j/
         L7zp5fYi3OWAtPTqy3L3W2G0m3V5++Sebh7UPf4aBz5Urfvj+Jxi3NCtMUBOPpTH8xbL
         psQmeuhoPrFP5mkp652Vgw7/5JRRU12xzYe7QTB62eWX0g9tu4Rd416I+BL2Q6NawUbA
         d95hKsgittRPwO19ZtSNIhiYZ2nWP70S77OoXVtFTz3W9q7s/mXS0rr2lwhj5/xGLKhZ
         ijNQ==
X-Gm-Message-State: AGi0PuZPuz47ul2gdl45bjMbUGCGZJCDDLY1A2KvBhA3lj0zn8iYvOEN
        NQUxOkXgltDUlrhbey7gSDFMt9xpT3cJcg==
X-Google-Smtp-Source: APiQypLto1GU0/W43oRDrpEYRD6xNAG+FMkvdv/98feZMx5NifOE61FjtJBnGtW2+Q5wvyRfJww9Aw==
X-Received: by 2002:ac8:2c0c:: with SMTP id d12mr3752611qta.284.1588253688202;
        Thu, 30 Apr 2020 06:34:48 -0700 (PDT)
Received: from quaco.ghostprotocols.net ([179.97.37.151])
        by smtp.gmail.com with ESMTPSA id j9sm1858022qkk.99.2020.04.30.06.34.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2020 06:34:47 -0700 (PDT)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id B4543409A3; Thu, 30 Apr 2020 10:34:44 -0300 (-03)
Date:   Thu, 30 Apr 2020 10:34:44 -0300
To:     Ian Rogers <irogers@google.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Igor Lubashev <ilubashe@akamai.com>,
        Alexey Budankov <alexey.budankov@linux.intel.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Jiwei Sun <jiwei.sun@windriver.com>,
        yuzhoujian <yuzhoujian@didichuxing.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Leo Yan <leo.yan@linaro.org>,
        John Garry <john.garry@huawei.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-perf-users@vger.kernel.org,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH v12 4/4] perf tools: add support for libpfm4
Message-ID: <20200430133444.GJ30487@kernel.org>
References: <20200429231443.207201-1-irogers@google.com>
 <20200429231443.207201-5-irogers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429231443.207201-5-irogers@google.com>
X-Url:  http://acmel.wordpress.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Wed, Apr 29, 2020 at 04:14:43PM -0700, Ian Rogers escreveu:
> From: Stephane Eranian <eranian@google.com>
> 
> This patch links perf with the libpfm4 library if it is available
> and LIBPFM4 is passed to the build. The libpfm4 library
> contains hardware event tables for all processors supported by
> perf_events. It is a helper library that helps convert from a
> symbolic event name to the event encoding required by the
> underlying kernel interface. This library is open-source and
> available from: http://perfmon2.sf.net.

Hey, I think we should not call libpfm_initialize() in all tools, better
leave it to when the --pfm-event callback gets called, because the user
is really using that event syntax, i.e. do it lazily, to reduce the
amount of initialization that perf does, which is already excessive and
needs triming down, to do more things only when they are really, really
needed.

I have applied the previous, preparatory patches.

- Arnaldo
 
> With this patch, it is possible to specify full hardware events
> by name. Hardware filters are also supported. Events must be
> specified via the --pfm-events and not -e option. Both options
> are active at the same time and it is possible to mix and match:
> 
> $ perf stat --pfm-events inst_retired:any_p:c=1:i -e cycles ....
> 
> Signed-off-by: Stephane Eranian <eranian@google.com>
> Reviewed-by: Ian Rogers <irogers@google.com>
> ---
>  tools/perf/Documentation/perf-record.txt |  11 +
>  tools/perf/Documentation/perf-stat.txt   |  10 +
>  tools/perf/Documentation/perf-top.txt    |  11 +
>  tools/perf/Makefile.config               |  13 ++
>  tools/perf/Makefile.perf                 |   2 +
>  tools/perf/builtin-list.c                |   3 +
>  tools/perf/builtin-record.c              |   8 +
>  tools/perf/builtin-stat.c                |   8 +
>  tools/perf/builtin-top.c                 |   8 +
>  tools/perf/tests/Build                   |   1 +
>  tools/perf/tests/builtin-test.c          |   9 +
>  tools/perf/tests/pfm.c                   | 207 +++++++++++++++++
>  tools/perf/tests/tests.h                 |   3 +
>  tools/perf/util/Build                    |   2 +
>  tools/perf/util/evsel.c                  |   2 +-
>  tools/perf/util/evsel.h                  |   1 +
>  tools/perf/util/parse-events.c           |  30 ++-
>  tools/perf/util/parse-events.h           |   4 +
>  tools/perf/util/pfm.c                    | 277 +++++++++++++++++++++++
>  tools/perf/util/pfm.h                    |  43 ++++
>  20 files changed, 645 insertions(+), 8 deletions(-)
>  create mode 100644 tools/perf/tests/pfm.c
>  create mode 100644 tools/perf/util/pfm.c
>  create mode 100644 tools/perf/util/pfm.h
> 
> diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
> index b3f3b3f1c161..ad2c41f595c2 100644
> --- a/tools/perf/Documentation/perf-record.txt
> +++ b/tools/perf/Documentation/perf-record.txt
> @@ -596,6 +596,17 @@ Make a copy of /proc/kcore and place it into a directory with the perf data file
>  Limit the sample data max size, <size> is expected to be a number with
>  appended unit character - B/K/M/G
>  
> +ifdef::HAVE_LIBPFM[]
> +--pfm-events events::
> +Select a PMU event using libpfm4 syntax (see http://perfmon2.sf.net)
> +including support for event filters. For example '--pfm-events
> +inst_retired:any_p:u:c=1:i'. More than one event can be passed to the
> +option using the comma separator. Hardware events and generic hardware
> +events cannot be mixed together. The latter must be used with the -e
> +option. The -e option and this one can be mixed and matched.  Events
> +can be grouped using the {} notation.
> +endif::HAVE_LIBPFM[]
> +
>  SEE ALSO
>  --------
>  linkperf:perf-stat[1], linkperf:perf-list[1], linkperf:perf-intel-pt[1]
> diff --git a/tools/perf/Documentation/perf-stat.txt b/tools/perf/Documentation/perf-stat.txt
> index 4d56586b2fb9..536952ad592c 100644
> --- a/tools/perf/Documentation/perf-stat.txt
> +++ b/tools/perf/Documentation/perf-stat.txt
> @@ -71,6 +71,16 @@ report::
>  --tid=<tid>::
>          stat events on existing thread id (comma separated list)
>  
> +ifdef::HAVE_LIBPFM[]
> +--pfm-events events::
> +Select a PMU event using libpfm4 syntax (see http://perfmon2.sf.net)
> +including support for event filters. For example '--pfm-events
> +inst_retired:any_p:u:c=1:i'. More than one event can be passed to the
> +option using the comma separator. Hardware events and generic hardware
> +events cannot be mixed together. The latter must be used with the -e
> +option. The -e option and this one can be mixed and matched.  Events
> +can be grouped using the {} notation.
> +endif::HAVE_LIBPFM[]
>  
>  -a::
>  --all-cpus::
> diff --git a/tools/perf/Documentation/perf-top.txt b/tools/perf/Documentation/perf-top.txt
> index 20227dabc208..ee2024691d46 100644
> --- a/tools/perf/Documentation/perf-top.txt
> +++ b/tools/perf/Documentation/perf-top.txt
> @@ -329,6 +329,17 @@ Default is to monitor all CPUS.
>  	The known limitations include exception handing such as
>  	setjmp/longjmp will have calls/returns not match.
>  
> +ifdef::HAVE_LIBPFM[]
> +--pfm-events events::
> +Select a PMU event using libpfm4 syntax (see http://perfmon2.sf.net)
> +including support for event filters. For example '--pfm-events
> +inst_retired:any_p:u:c=1:i'. More than one event can be passed to the
> +option using the comma separator. Hardware events and generic hardware
> +events cannot be mixed together. The latter must be used with the -e
> +option. The -e option and this one can be mixed and matched.  Events
> +can be grouped using the {} notation.
> +endif::HAVE_LIBPFM[]
> +
>  INTERACTIVE PROMPTING KEYS
>  --------------------------
>  
> diff --git a/tools/perf/Makefile.config b/tools/perf/Makefile.config
> index 12a8204d63c6..b67804fee1e3 100644
> --- a/tools/perf/Makefile.config
> +++ b/tools/perf/Makefile.config
> @@ -1012,6 +1012,19 @@ ifdef LIBCLANGLLVM
>    endif
>  endif
>  
> +ifdef LIBPFM4
> +  $(call feature_check,libpfm4)
> +  ifeq ($(feature-libpfm4), 1)
> +    CFLAGS += -DHAVE_LIBPFM
> +    EXTLIBS += -lpfm
> +    ASCIIDOC_EXTRA = -aHAVE_LIBPFM=1
> +    $(call detected,CONFIG_LIBPFM4)
> +  else
> +    msg := $(warning libpfm4 not found, disables libpfm4 support. Please install libpfm4-dev);
> +    NO_LIBPFM4 := 1
> +  endif
> +endif
> +
>  # Among the variables below, these:
>  #   perfexecdir
>  #   perf_include_dir
> diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
> index 94a495594e99..dc82578c8773 100644
> --- a/tools/perf/Makefile.perf
> +++ b/tools/perf/Makefile.perf
> @@ -118,6 +118,8 @@ include ../scripts/utilities.mak
>  #
>  # Define LIBBPF_DYNAMIC to enable libbpf dynamic linking.
>  #
> +# Define LIBPFM4 to enable libpfm4 events extension.
> +#
>  
>  # As per kernel Makefile, avoid funny character set dependencies
>  unexport LC_ALL
> diff --git a/tools/perf/builtin-list.c b/tools/perf/builtin-list.c
> index 965ef017496f..d2069bdcb469 100644
> --- a/tools/perf/builtin-list.c
> +++ b/tools/perf/builtin-list.c
> @@ -14,6 +14,7 @@
>  #include "util/pmu.h"
>  #include "util/debug.h"
>  #include "util/metricgroup.h"
> +#include "util/pfm.h"
>  #include <subcmd/pager.h>
>  #include <subcmd/parse-options.h>
>  #include <stdio.h>
> @@ -53,6 +54,8 @@ int cmd_list(int argc, const char **argv)
>  
>  	setup_pager();
>  
> +	libpfm_initialize();
> +
>  	if (!raw_dump && pager_in_use())
>  		printf("\nList of pre-defined events (to be used in -e):\n\n");
>  
> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> index 1ab349abe904..fc55b641849f 100644
> --- a/tools/perf/builtin-record.c
> +++ b/tools/perf/builtin-record.c
> @@ -43,6 +43,7 @@
>  #include "util/time-utils.h"
>  #include "util/units.h"
>  #include "util/bpf-event.h"
> +#include "util/pfm.h"
>  #include "asm/bug.h"
>  #include "perf.h"
>  
> @@ -2421,6 +2422,11 @@ static struct option __record_options[] = {
>  #endif
>  	OPT_CALLBACK(0, "max-size", &record.output_max_size,
>  		     "size", "Limit the maximum size of the output file", parse_output_max_size),
> +#ifdef HAVE_LIBPFM
> +	OPT_CALLBACK(0, "pfm-events", &record.evlist, "event",
> +		"libpfm4 event selector. use 'perf list' to list available events",
> +		parse_libpfm_events_option),
> +#endif
>  	OPT_END()
>  };
>  
> @@ -2461,6 +2467,8 @@ int cmd_record(int argc, const char **argv)
>  	if (rec->evlist == NULL)
>  		return -ENOMEM;
>  
> +	libpfm_initialize();
> +
>  	err = perf_config(perf_record_config, rec);
>  	if (err)
>  		return err;
> diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
> index 9207b6c45475..607920321c15 100644
> --- a/tools/perf/builtin-stat.c
> +++ b/tools/perf/builtin-stat.c
> @@ -66,6 +66,7 @@
>  #include "util/time-utils.h"
>  #include "util/top.h"
>  #include "util/affinity.h"
> +#include "util/pfm.h"
>  #include "asm/bug.h"
>  
>  #include <linux/time64.h>
> @@ -936,6 +937,11 @@ static struct option stat_options[] = {
>  		    "Use with 'percore' event qualifier to show the event "
>  		    "counts of one hardware thread by sum up total hardware "
>  		    "threads of same physical core"),
> +#ifdef HAVE_LIBPFM
> +	OPT_CALLBACK(0, "pfm-events", &evsel_list, "event",
> +		"libpfm4 event selector. use 'perf list' to list available events",
> +		parse_libpfm_events_option),
> +#endif
>  	OPT_END()
>  };
>  
> @@ -1874,6 +1880,8 @@ int cmd_stat(int argc, const char **argv)
>  	unsigned int interval, timeout;
>  	const char * const stat_subcommands[] = { "record", "report" };
>  
> +	libpfm_initialize();
> +
>  	setlocale(LC_ALL, "");
>  
>  	evsel_list = evlist__new();
> diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
> index 6b067a5ba1d5..e1f477a18f93 100644
> --- a/tools/perf/builtin-top.c
> +++ b/tools/perf/builtin-top.c
> @@ -53,6 +53,7 @@
>  
>  #include "util/debug.h"
>  #include "util/ordered-events.h"
> +#include "util/pfm.h"
>  
>  #include <assert.h>
>  #include <elf.h>
> @@ -1577,6 +1578,11 @@ int cmd_top(int argc, const char **argv)
>  		    "WARNING: should be used on grouped events."),
>  	OPT_BOOLEAN(0, "stitch-lbr", &top.stitch_lbr,
>  		    "Enable LBR callgraph stitching approach"),
> +#ifdef HAVE_LIBPFM
> +	OPT_CALLBACK(0, "pfm-events", &top.evlist, "event",
> +		"libpfm4 event selector. use 'perf list' to list available events",
> +		parse_libpfm_events_option),
> +#endif
>  	OPTS_EVSWITCH(&top.evswitch),
>  	OPT_END()
>  	};
> @@ -1590,6 +1596,8 @@ int cmd_top(int argc, const char **argv)
>  	if (status < 0)
>  		return status;
>  
> +	libpfm_initialize();
> +
>  	top.annotation_opts.min_pcnt = 5;
>  	top.annotation_opts.context  = 4;
>  
> diff --git a/tools/perf/tests/Build b/tools/perf/tests/Build
> index b3d1bf13ca07..7d2ccec9fd75 100644
> --- a/tools/perf/tests/Build
> +++ b/tools/perf/tests/Build
> @@ -56,6 +56,7 @@ perf-y += mem2node.o
>  perf-y += maps.o
>  perf-y += time-utils-test.o
>  perf-y += genelf.o
> +perf-y += pfm.o
>  
>  $(OUTPUT)tests/llvm-src-base.c: tests/bpf-script-example.c tests/Build
>  	$(call rule_mkdir)
> diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
> index b6322eb0f423..8b323151f22c 100644
> --- a/tools/perf/tests/builtin-test.c
> +++ b/tools/perf/tests/builtin-test.c
> @@ -313,6 +313,15 @@ static struct test generic_tests[] = {
>  		.desc = "maps__merge_in",
>  		.func = test__maps__merge_in,
>  	},
> +	{
> +		.desc = "Test libpfm4 support",
> +		.func = test__pfm,
> +		.subtest = {
> +			.skip_if_fail	= true,
> +			.get_nr		= test__pfm_subtest_get_nr,
> +			.get_desc	= test__pfm_subtest_get_desc,
> +		}
> +	},
>  	{
>  		.func = NULL,
>  	},
> diff --git a/tools/perf/tests/pfm.c b/tools/perf/tests/pfm.c
> new file mode 100644
> index 000000000000..1d594fd3d9c1
> --- /dev/null
> +++ b/tools/perf/tests/pfm.c
> @@ -0,0 +1,207 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Test support for libpfm4 event encodings.
> + *
> + * Copyright 2020 Google LLC.
> + */
> +#include "tests.h"
> +#include "util/debug.h"
> +#include "util/evlist.h"
> +#include "util/pfm.h"
> +
> +#include <linux/kernel.h>
> +
> +#ifdef HAVE_LIBPFM
> +static int test__pfm_events(void);
> +static int test__pfm_group(void);
> +#endif
> +
> +static const struct {
> +	int (*func)(void);
> +	const char *desc;
> +} pfm_testcase_table[] = {
> +#ifdef HAVE_LIBPFM
> +	{
> +		.func = test__pfm_events,
> +		.desc = "test of individual --pfm-events",
> +	},
> +	{
> +		.func = test__pfm_group,
> +		.desc = "test groups of --pfm-events",
> +	},
> +#endif
> +};
> +
> +#ifdef HAVE_LIBPFM
> +static int count_pfm_events(struct perf_evlist *evlist)
> +{
> +	struct perf_evsel *evsel;
> +	int count = 0;
> +
> +	perf_evlist__for_each_entry(evlist, evsel) {
> +		count++;
> +	}
> +	return count;
> +}
> +
> +static int test__pfm_events(void)
> +{
> +	struct evlist *evlist;
> +	struct option opt;
> +	size_t i;
> +	const struct {
> +		const char *events;
> +		int nr_events;
> +	} table[] = {
> +		{
> +			.events = "",
> +			.nr_events = 0,
> +		},
> +		{
> +			.events = "instructions",
> +			.nr_events = 1,
> +		},
> +		{
> +			.events = "instructions,cycles",
> +			.nr_events = 2,
> +		},
> +		{
> +			.events = "stereolab",
> +			.nr_events = 0,
> +		},
> +		{
> +			.events = "instructions,instructions",
> +			.nr_events = 2,
> +		},
> +		{
> +			.events = "stereolab,instructions",
> +			.nr_events = 0,
> +		},
> +		{
> +			.events = "instructions,stereolab",
> +			.nr_events = 1,
> +		},
> +	};
> +
> +	libpfm_initialize();
> +
> +	for (i = 0; i < ARRAY_SIZE(table); i++) {
> +		evlist = evlist__new();
> +		if (evlist == NULL)
> +			return -ENOMEM;
> +
> +		opt.value = evlist;
> +		parse_libpfm_events_option(&opt,
> +					table[i].events,
> +					0);
> +		TEST_ASSERT_EQUAL(table[i].events,
> +				count_pfm_events(&evlist->core),
> +				table[i].nr_events);
> +		TEST_ASSERT_EQUAL(table[i].events,
> +				evlist->nr_groups,
> +				0);
> +
> +		evlist__delete(evlist);
> +	}
> +	return 0;
> +}
> +
> +static int test__pfm_group(void)
> +{
> +	struct evlist *evlist;
> +	struct option opt;
> +	size_t i;
> +	const struct {
> +		const char *events;
> +		int nr_events;
> +		int nr_groups;
> +	} table[] = {
> +		{
> +			.events = "{},",
> +			.nr_events = 0,
> +			.nr_groups = 0,
> +		},
> +		{
> +			.events = "{instructions}",
> +			.nr_events = 1,
> +			.nr_groups = 1,
> +		},
> +		{
> +			.events = "{instructions},{}",
> +			.nr_events = 1,
> +			.nr_groups = 1,
> +		},
> +		{
> +			.events = "{},{instructions}",
> +			.nr_events = 0,
> +			.nr_groups = 0,
> +		},
> +		{
> +			.events = "{instructions},{instructions}",
> +			.nr_events = 2,
> +			.nr_groups = 2,
> +		},
> +		{
> +			.events = "{instructions,cycles},{instructions,cycles}",
> +			.nr_events = 4,
> +			.nr_groups = 2,
> +		},
> +		{
> +			.events = "{stereolab}",
> +			.nr_events = 0,
> +			.nr_groups = 0,
> +		},
> +		{
> +			.events =
> +			"{instructions,cycles},{instructions,stereolab}",
> +			.nr_events = 3,
> +			.nr_groups = 1,
> +		},
> +	};
> +
> +	libpfm_initialize();
> +
> +	for (i = 0; i < ARRAY_SIZE(table); i++) {
> +		evlist = evlist__new();
> +		if (evlist == NULL)
> +			return -ENOMEM;
> +
> +		opt.value = evlist;
> +		parse_libpfm_events_option(&opt,
> +					table[i].events,
> +					0);
> +		TEST_ASSERT_EQUAL(table[i].events,
> +				count_pfm_events(&evlist->core),
> +				table[i].nr_events);
> +		TEST_ASSERT_EQUAL(table[i].events,
> +				evlist->nr_groups,
> +				table[i].nr_groups);
> +
> +		evlist__delete(evlist);
> +	}
> +	return 0;
> +}
> +#endif
> +
> +const char *test__pfm_subtest_get_desc(int i)
> +{
> +	if (i < 0 || i >= (int)ARRAY_SIZE(pfm_testcase_table))
> +		return NULL;
> +	return pfm_testcase_table[i].desc;
> +}
> +
> +int test__pfm_subtest_get_nr(void)
> +{
> +	return (int)ARRAY_SIZE(pfm_testcase_table);
> +}
> +
> +int test__pfm(struct test *test __maybe_unused, int i __maybe_unused)
> +{
> +#ifdef HAVE_LIBPFM
> +	if (i < 0 || i >= (int)ARRAY_SIZE(pfm_testcase_table))
> +		return TEST_FAIL;
> +	return pfm_testcase_table[i].func();
> +#else
> +	return TEST_SKIP;
> +#endif
> +}
> diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
> index 61a1ab032080..47cbae753b42 100644
> --- a/tools/perf/tests/tests.h
> +++ b/tools/perf/tests/tests.h
> @@ -112,6 +112,9 @@ int test__mem2node(struct test *t, int subtest);
>  int test__maps__merge_in(struct test *t, int subtest);
>  int test__time_utils(struct test *t, int subtest);
>  int test__jit_write_elf(struct test *test, int subtest);
> +int test__pfm(struct test *test, int subtest);
> +const char *test__pfm_subtest_get_desc(int subtest);
> +int test__pfm_subtest_get_nr(void);
>  
>  bool test__bp_signal_is_supported(void);
>  bool test__bp_account_is_supported(void);
> diff --git a/tools/perf/util/Build b/tools/perf/util/Build
> index c0cf8dff694e..afd3d2221c83 100644
> --- a/tools/perf/util/Build
> +++ b/tools/perf/util/Build
> @@ -177,6 +177,8 @@ perf-$(CONFIG_LIBBPF) += bpf-event.o
>  
>  perf-$(CONFIG_CXX) += c++/
>  
> +perf-$(CONFIG_LIBPFM4) += pfm.o
> +
>  CFLAGS_config.o   += -DETC_PERFCONFIG="BUILD_STR($(ETC_PERFCONFIG_SQ))"
>  CFLAGS_llvm-utils.o += -DPERF_INCLUDE_DIR="BUILD_STR($(perf_include_dir_SQ))"
>  
> diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
> index 6a571d322bb2..a5c88d52c11c 100644
> --- a/tools/perf/util/evsel.c
> +++ b/tools/perf/util/evsel.c
> @@ -2433,7 +2433,7 @@ bool perf_evsel__fallback(struct evsel *evsel, int err,
>  
>  		/* Is there already the separator in the name. */
>  		if (strchr(name, '/') ||
> -		    strchr(name, ':'))
> +		    (strchr(name, ':') && !evsel->is_libpfm_event))
>  			sep = "";
>  
>  		if (asprintf(&new_name, "%s%su", name, sep) < 0)
> diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
> index a463bc65b001..709a9d494767 100644
> --- a/tools/perf/util/evsel.h
> +++ b/tools/perf/util/evsel.h
> @@ -76,6 +76,7 @@ struct evsel {
>  	bool			ignore_missing_thread;
>  	bool			forced_leader;
>  	bool			use_uncore_alias;
> +	bool			is_libpfm_event;
>  	/* parse modifier helper */
>  	int			exclude_GH;
>  	int			sample_read;
> diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
> index 10107747b361..e7e0faf36e3c 100644
> --- a/tools/perf/util/parse-events.c
> +++ b/tools/perf/util/parse-events.c
> @@ -36,6 +36,7 @@
>  #include "metricgroup.h"
>  #include "util/evsel_config.h"
>  #include "util/event.h"
> +#include "util/pfm.h"
>  
>  #define MAX_NAME_LEN 100
>  
> @@ -344,6 +345,7 @@ static char *get_config_name(struct list_head *head_terms)
>  static struct evsel *
>  __add_event(struct list_head *list, int *idx,
>  	    struct perf_event_attr *attr,
> +	    bool init_attr,
>  	    char *name, struct perf_pmu *pmu,
>  	    struct list_head *config_terms, bool auto_merge_stats,
>  	    const char *cpu_list)
> @@ -352,7 +354,8 @@ __add_event(struct list_head *list, int *idx,
>  	struct perf_cpu_map *cpus = pmu ? pmu->cpus :
>  			       cpu_list ? perf_cpu_map__new(cpu_list) : NULL;
>  
> -	event_attr_init(attr);
> +	if (init_attr)
> +		event_attr_init(attr);
>  
>  	evsel = perf_evsel__new_idx(attr, *idx);
>  	if (!evsel)
> @@ -370,15 +373,25 @@ __add_event(struct list_head *list, int *idx,
>  	if (config_terms)
>  		list_splice(config_terms, &evsel->config_terms);
>  
> -	list_add_tail(&evsel->core.node, list);
> +	if (list)
> +		list_add_tail(&evsel->core.node, list);
> +
>  	return evsel;
>  }
>  
> +struct evsel *parse_events__add_event(int idx, struct perf_event_attr *attr,
> +					char *name, struct perf_pmu *pmu)
> +{
> +	return __add_event(NULL, &idx, attr, false, name, pmu, NULL, false,
> +			   NULL);
> +}
> +
>  static int add_event(struct list_head *list, int *idx,
>  		     struct perf_event_attr *attr, char *name,
>  		     struct list_head *config_terms)
>  {
> -	return __add_event(list, idx, attr, name, NULL, config_terms, false, NULL) ? 0 : -ENOMEM;
> +	return __add_event(list, idx, attr, true, name, NULL, config_terms,
> +			   false, NULL) ? 0 : -ENOMEM;
>  }
>  
>  static int add_event_tool(struct list_head *list, int *idx,
> @@ -390,7 +403,8 @@ static int add_event_tool(struct list_head *list, int *idx,
>  		.config = PERF_COUNT_SW_DUMMY,
>  	};
>  
> -	evsel = __add_event(list, idx, &attr, NULL, NULL, NULL, false, "0");
> +	evsel = __add_event(list, idx, &attr, true, NULL, NULL, NULL, false,
> +			    "0");
>  	if (!evsel)
>  		return -ENOMEM;
>  	evsel->tool_event = tool_event;
> @@ -1446,8 +1460,8 @@ int parse_events_add_pmu(struct parse_events_state *parse_state,
>  
>  	if (!head_config) {
>  		attr.type = pmu->type;
> -		evsel = __add_event(list, &parse_state->idx, &attr, NULL, pmu, NULL,
> -				    auto_merge_stats, NULL);
> +		evsel = __add_event(list, &parse_state->idx, &attr, true, NULL,
> +				    pmu, NULL, auto_merge_stats, NULL);
>  		if (evsel) {
>  			evsel->pmu_name = name ? strdup(name) : NULL;
>  			evsel->use_uncore_alias = use_uncore_alias;
> @@ -1487,7 +1501,7 @@ int parse_events_add_pmu(struct parse_events_state *parse_state,
>  		return -EINVAL;
>  	}
>  
> -	evsel = __add_event(list, &parse_state->idx, &attr,
> +	evsel = __add_event(list, &parse_state->idx, &attr, true,
>  			    get_config_name(head_config), pmu,
>  			    &config_terms, auto_merge_stats, NULL);
>  	if (evsel) {
> @@ -2794,6 +2808,8 @@ void print_events(const char *event_glob, bool name_only, bool quiet_flag,
>  	print_sdt_events(NULL, NULL, name_only);
>  
>  	metricgroup__print(true, true, NULL, name_only, details_flag);
> +
> +	print_libpfm_events(name_only, long_desc);
>  }
>  
>  int parse_events__is_hardcoded_term(struct parse_events_term *term)
> diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
> index 27596cbd0ba0..f7f555b1ca35 100644
> --- a/tools/perf/util/parse-events.h
> +++ b/tools/perf/util/parse-events.h
> @@ -17,6 +17,7 @@ struct evlist;
>  struct parse_events_error;
>  
>  struct option;
> +struct perf_pmu;
>  
>  struct tracepoint_path {
>  	char *system;
> @@ -186,6 +187,9 @@ int parse_events_add_pmu(struct parse_events_state *parse_state,
>  			 bool auto_merge_stats,
>  			 bool use_alias);
>  
> +struct evsel *parse_events__add_event(int idx, struct perf_event_attr *attr,
> +					char *name, struct perf_pmu *pmu);
> +
>  int parse_events_multi_pmu_add(struct parse_events_state *parse_state,
>  			       char *str,
>  			       struct list_head **listp);
> diff --git a/tools/perf/util/pfm.c b/tools/perf/util/pfm.c
> new file mode 100644
> index 000000000000..4b11adf832a0
> --- /dev/null
> +++ b/tools/perf/util/pfm.c
> @@ -0,0 +1,277 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Support for libpfm4 event encoding.
> + *
> + * Copyright 2020 Google LLC.
> + */
> +#include "util/cpumap.h"
> +#include "util/debug.h"
> +#include "util/event.h"
> +#include "util/evlist.h"
> +#include "util/evsel.h"
> +#include "util/parse-events.h"
> +#include "util/pmu.h"
> +#include "util/pfm.h"
> +
> +#include <string.h>
> +#include <linux/kernel.h>
> +#include <perfmon/pfmlib_perf_event.h>
> +
> +void libpfm_initialize(void)
> +{
> +	int ret;
> +
> +	ret = pfm_initialize();
> +	if (ret != PFM_SUCCESS) {
> +		ui__warning("libpfm failed to initialize: %s\n",
> +			pfm_strerror(ret));
> +	}
> +}
> +
> +int parse_libpfm_events_option(const struct option *opt, const char *str,
> +			int unset __maybe_unused)
> +{
> +	struct evlist *evlist = *(struct evlist **)opt->value;
> +	struct perf_event_attr attr;
> +	struct perf_pmu *pmu;
> +	struct evsel *evsel, *grp_leader = NULL;
> +	char *p, *q, *p_orig;
> +	const char *sep;
> +	int grp_evt = -1;
> +	int ret;
> +
> +	p_orig = p = strdup(str);
> +	if (!p)
> +		return -1;
> +	/*
> +	 * force loading of the PMU list
> +	 */
> +	perf_pmu__scan(NULL);
> +
> +	for (q = p; strsep(&p, ",{}"); q = p) {
> +		sep = p ? str + (p - p_orig - 1) : "";
> +		if (*sep == '{') {
> +			if (grp_evt > -1) {
> +				ui__error(
> +					"nested event groups not supported\n");
> +				goto error;
> +			}
> +			grp_evt++;
> +		}
> +
> +		/* no event */
> +		if (*q == '\0')
> +			continue;
> +
> +		memset(&attr, 0, sizeof(attr));
> +		event_attr_init(&attr);
> +
> +		ret = pfm_get_perf_event_encoding(q, PFM_PLM0|PFM_PLM3,
> +						&attr, NULL, NULL);
> +
> +		if (ret != PFM_SUCCESS) {
> +			ui__error("failed to parse event %s : %s\n", str,
> +				  pfm_strerror(ret));
> +			goto error;
> +		}
> +
> +		pmu = perf_pmu__find_by_type((unsigned int)attr.type);
> +		evsel = parse_events__add_event(evlist->core.nr_entries,
> +						&attr, q, pmu);
> +		if (evsel == NULL)
> +			goto error;
> +
> +		evsel->is_libpfm_event = true;
> +
> +		evlist__add(evlist, evsel);
> +
> +		if (grp_evt == 0)
> +			grp_leader = evsel;
> +
> +		if (grp_evt > -1) {
> +			evsel->leader = grp_leader;
> +			grp_leader->core.nr_members++;
> +			grp_evt++;
> +		}
> +
> +		if (*sep == '}') {
> +			if (grp_evt < 0) {
> +				ui__error(
> +				   "cannot close a non-existing event group\n");
> +				goto error;
> +			}
> +			evlist->nr_groups++;
> +			grp_leader = NULL;
> +			grp_evt = -1;
> +		}
> +	}
> +	return 0;
> +error:
> +	free(p_orig);
> +	return -1;
> +}
> +
> +static const char *srcs[PFM_ATTR_CTRL_MAX] = {
> +	[PFM_ATTR_CTRL_UNKNOWN] = "???",
> +	[PFM_ATTR_CTRL_PMU] = "PMU",
> +	[PFM_ATTR_CTRL_PERF_EVENT] = "perf_event",
> +};
> +
> +static void
> +print_attr_flags(pfm_event_attr_info_t *info)
> +{
> +	int n = 0;
> +
> +	if (info->is_dfl) {
> +		printf("[default] ");
> +		n++;
> +	}
> +
> +	if (info->is_precise) {
> +		printf("[precise] ");
> +		n++;
> +	}
> +
> +	if (!n)
> +		printf("- ");
> +}
> +
> +static void
> +print_libpfm_events_detailed(pfm_event_info_t *info, bool long_desc)
> +{
> +	pfm_event_attr_info_t ainfo;
> +	const char *src;
> +	int j, ret;
> +
> +	ainfo.size = sizeof(ainfo);
> +
> +	printf("  %s\n", info->name);
> +	printf("    [%s]\n", info->desc);
> +	if (long_desc) {
> +		if (info->equiv)
> +			printf("      Equiv: %s\n", info->equiv);
> +
> +		printf("      Code  : 0x%"PRIx64"\n", info->code);
> +	}
> +	pfm_for_each_event_attr(j, info) {
> +		ret = pfm_get_event_attr_info(info->idx, j,
> +					      PFM_OS_PERF_EVENT_EXT, &ainfo);
> +		if (ret != PFM_SUCCESS)
> +			continue;
> +
> +		if (ainfo.type == PFM_ATTR_UMASK) {
> +			printf("      %s:%s\n", info->name, ainfo.name);
> +			printf("        [%s]\n", ainfo.desc);
> +		}
> +
> +		if (!long_desc)
> +			continue;
> +
> +		if (ainfo.ctrl >= PFM_ATTR_CTRL_MAX)
> +			ainfo.ctrl = PFM_ATTR_CTRL_UNKNOWN;
> +
> +		src = srcs[ainfo.ctrl];
> +		switch (ainfo.type) {
> +		case PFM_ATTR_UMASK:
> +			printf("        Umask : 0x%02"PRIx64" : %s: ",
> +				ainfo.code, src);
> +			print_attr_flags(&ainfo);
> +			putchar('\n');
> +			break;
> +		case PFM_ATTR_MOD_BOOL:
> +			printf("      Modif : %s: [%s] : %s (boolean)\n", src,
> +				ainfo.name, ainfo.desc);
> +			break;
> +		case PFM_ATTR_MOD_INTEGER:
> +			printf("      Modif : %s: [%s] : %s (integer)\n", src,
> +				ainfo.name, ainfo.desc);
> +			break;
> +		case PFM_ATTR_NONE:
> +		case PFM_ATTR_RAW_UMASK:
> +		case PFM_ATTR_MAX:
> +		default:
> +			printf("      Attr  : %s: [%s] : %s\n", src,
> +				ainfo.name, ainfo.desc);
> +		}
> +	}
> +}
> +
> +/*
> + * list all pmu::event:umask, pmu::event
> + * printed events may not be all valid combinations of umask for an event
> + */
> +static void
> +print_libpfm_events_raw(pfm_pmu_info_t *pinfo, pfm_event_info_t *info)
> +{
> +	pfm_event_attr_info_t ainfo;
> +	int j, ret;
> +	bool has_umask = false;
> +
> +	ainfo.size = sizeof(ainfo);
> +
> +	pfm_for_each_event_attr(j, info) {
> +		ret = pfm_get_event_attr_info(info->idx, j,
> +					      PFM_OS_PERF_EVENT_EXT, &ainfo);
> +		if (ret != PFM_SUCCESS)
> +			continue;
> +
> +		if (ainfo.type != PFM_ATTR_UMASK)
> +			continue;
> +
> +		printf("%s::%s:%s\n", pinfo->name, info->name, ainfo.name);
> +		has_umask = true;
> +	}
> +	if (!has_umask)
> +		printf("%s::%s\n", pinfo->name, info->name);
> +}
> +
> +void print_libpfm_events(bool name_only, bool long_desc)
> +{
> +	pfm_event_info_t info;
> +	pfm_pmu_info_t pinfo;
> +	int i, p, ret;
> +
> +	/* initialize to zero to indicate ABI version */
> +	info.size  = sizeof(info);
> +	pinfo.size = sizeof(pinfo);
> +
> +	if (!name_only)
> +		puts("\nList of pre-defined events (to be used in --pfm-events):\n");
> +
> +	pfm_for_all_pmus(p) {
> +		bool printed_pmu = false;
> +
> +		ret = pfm_get_pmu_info(p, &pinfo);
> +		if (ret != PFM_SUCCESS)
> +			continue;
> +
> +		/* only print events that are supported by host HW */
> +		if (!pinfo.is_present)
> +			continue;
> +
> +		/* handled by perf directly */
> +		if (pinfo.pmu == PFM_PMU_PERF_EVENT)
> +			continue;
> +
> +		for (i = pinfo.first_event; i != -1;
> +		     i = pfm_get_event_next(i)) {
> +
> +			ret = pfm_get_event_info(i, PFM_OS_PERF_EVENT_EXT,
> +						&info);
> +			if (ret != PFM_SUCCESS)
> +				continue;
> +
> +			if (!name_only && !printed_pmu) {
> +				printf("%s:\n", pinfo.name);
> +				printed_pmu = true;
> +			}
> +
> +			if (!name_only)
> +				print_libpfm_events_detailed(&info, long_desc);
> +			else
> +				print_libpfm_events_raw(&pinfo, &info);
> +		}
> +		if (!name_only && printed_pmu)
> +			putchar('\n');
> +	}
> +}
> diff --git a/tools/perf/util/pfm.h b/tools/perf/util/pfm.h
> new file mode 100644
> index 000000000000..532dafe88bc0
> --- /dev/null
> +++ b/tools/perf/util/pfm.h
> @@ -0,0 +1,43 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Support for libpfm4 event encoding.
> + *
> + * Copyright 2020 Google LLC.
> + */
> +#ifndef __PERF_PFM_H
> +#define __PERF_PFM_H
> +
> +#include <subcmd/parse-options.h>
> +
> +#ifdef HAVE_LIBPFM
> +void libpfm_initialize(void);
> +
> +int parse_libpfm_events_option(const struct option *opt, const char *str,
> +			int unset);
> +
> +void print_libpfm_events(bool name_only, bool long_desc);
> +
> +#else
> +#include <linux/compiler.h>
> +
> +static inline void libpfm_initialize(void)
> +{
> +}
> +
> +static inline int parse_libpfm_events_option(
> +	const struct option *opt __maybe_unused,
> +	const char *str __maybe_unused,
> +	int unset __maybe_unused)
> +{
> +	return 0;
> +}
> +
> +static inline void print_libpfm_events(bool name_only __maybe_unused,
> +				       bool long_desc __maybe_unused)
> +{
> +}
> +
> +#endif
> +
> +
> +#endif /* __PERF_PFM_H */
> -- 
> 2.26.2.303.gf8c07b1a785-goog
> 

-- 

- Arnaldo
