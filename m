Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55F94175BD7
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 14:37:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727762AbgCBNge (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 08:36:34 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53458 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727627AbgCBNge (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 08:36:34 -0500
Received: by mail-wm1-f66.google.com with SMTP id f15so11213502wml.3
        for <netdev@vger.kernel.org>; Mon, 02 Mar 2020 05:36:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DUV+M4FM2pe2arUITQiGyTVDUU7OGR93RDa7myY1wFU=;
        b=q/HoeukYhtywhF+FmkPe7JmFanGKaBrqbfBKelURhVwNnN/lz8wVDzXFg5ZIIEqdcu
         SjDkmaSuK6T0e4C+2jGZltW8N6SmzPT5BIcL9YTkJYjHcGwOdjmzIP26BkDQMgthE4Gs
         PbMs09uM1TSb5HCoYRmxbcStcvJwGpIOdZPn5qSjsfCNab0j5EZyBOjuFg5Rkn4aU/yl
         bdDVR86uvz96JnI1XfhxLNKUjeFbKCWm1sj5av+Qb8gTpiXbtTKwK4FM5M1j+fEoJv6k
         p+xk6IXCSSWoZ4QBT+KjtEIYYvDBbAgVhLkFqLUGP5R9VD84XLRBzrYOY4eFk8xc1fFS
         MhMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DUV+M4FM2pe2arUITQiGyTVDUU7OGR93RDa7myY1wFU=;
        b=le+b8jQ02Spb5jA1+gOo0pJfc+RIysvodqsLS6WseRURR0j8DyHotNdUDdkFvVqYhv
         iyhHM2qJiR2Ce8MK0i+dOgqbyI1RF0twZgusbdvbzTq/+kO0jGW9FGDka2y41OWa2Htn
         Ae8EXJhB9ES683o+OwMrpBGJ2Z7RLOZ2FRbKeN05HVD3FYHg8Wy+XuXnPAlFBK8N0Www
         PlFfNPi1cQHgrrjtWd3OG9cVLE4r5cpUOFKuUvH/a6/F8HC/nNZ8Lils/ZewyBusuReF
         SGGJyhf3PghjKex1aGR/Y2Xz2F1+RozxOksx0PPZHKucCAiI17jNoqW+4k8pgornBLKH
         1UoA==
X-Gm-Message-State: ANhLgQ1FLIg/5Wp5Z3SokNQSfCKGqWKKXfgtYMWP1JfBqfvvVCa49ug8
        b0IDkCquRPDMLa41mus1t4usYw==
X-Google-Smtp-Source: ADFU+vuMielTIHEFwhEakQzczE3SjiR/A9NRqtwh3ickpTSKwFZ5/ruY6mnjtFDfN3WYS0RFVWAeaw==
X-Received: by 2002:a1c:7719:: with SMTP id t25mr542592wmi.7.1583156191364;
        Mon, 02 Mar 2020 05:36:31 -0800 (PST)
Received: from [192.168.1.10] ([194.35.116.171])
        by smtp.gmail.com with ESMTPSA id i67sm4525671wri.50.2020.03.02.05.36.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2020 05:36:30 -0800 (PST)
Subject: Re: [PATCH v2 bpf-next 1/2] bpftool: introduce "prog profile" command
To:     Song Liu <songliubraving@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     kernel-team@fb.com, ast@kernel.org, daniel@iogearbox.net,
        arnaldo.melo@gmail.com, jolsa@kernel.org
References: <20200228234058.634044-1-songliubraving@fb.com>
 <20200228234058.634044-2-songliubraving@fb.com>
From:   Quentin Monnet <quentin@isovalent.com>
Message-ID: <c70b067d-4284-aeae-98ea-09e167c3757c@isovalent.com>
Date:   Mon, 2 Mar 2020 13:36:30 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200228234058.634044-2-songliubraving@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Song,

Thanks for this work! Some remarks (mostly nitpicks) inline.

2020-02-28 15:40 UTC-0800 ~ Song Liu <songliubraving@fb.com>
> With fentry/fexit programs, it is possible to profile BPF program with
> hardware counters. Introduce bpftool "prog profile", which measures key
> metrics of a BPF program.
> 
> bpftool prog profile command creates per-cpu perf events. Then it attaches
> fentry/fexit programs to the target BPF program. The fentry program saves
> perf event value to a map. The fexit program reads the perf event again,
> and calculates the difference, which is the instructions/cycles used by
> the target program.
> 
> Example input and output:
> 
>   ./bpftool prog profile 3 id 337 cycles instructions llc_misses
> 
>         4228 run_cnt
>      3403698 cycles                                              (84.08%)
>      3525294 instructions   #  1.04 insn per cycle               (84.05%)
>           13 llc_misses     #  3.69 LLC misses per million isns  (83.50%)
> 
> This command measures cycles and instructions for BPF program with id
> 337 for 3 seconds. The program has triggered 4228 times. The rest of the
> output is similar to perf-stat. In this example, the counters were only
> counting ~84% of the time because of time multiplexing of perf counters.
> 
> Note that, this approach measures cycles and instructions in very small
> increments. So the fentry/fexit programs introduce noticeable errors to
> the measurement results.
> 
> The fentry/fexit programs are generated with BPF skeletons. Therefore, we
> build bpftool twice. The first time _bpftool is built without skeletons.
> Then, _bpftool is used to generate the skeletons. The second time, bpftool
> is built with skeletons.
> 
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---

[...]

> diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
> index 1996e67a2f00..39f0f14464ad 100644
> --- a/tools/bpf/bpftool/prog.c
> +++ b/tools/bpf/bpftool/prog.c
> @@ -10,12 +10,16 @@
>  #include <string.h>
>  #include <time.h>
>  #include <unistd.h>
> +#include <signal.h>
>  #include <net/if.h>
>  #include <sys/types.h>
>  #include <sys/stat.h>
> +#include <sys/ioctl.h>
> +#include <sys/syscall.h>
>  
>  #include <linux/err.h>
>  #include <linux/sizes.h>
> +#include <linux/perf_event.h>

Nit: Could you please keep the includes sorted alphabetically in each
category (standard, sys/, linux/)?

>  
>  #include <bpf/bpf.h>
>  #include <bpf/btf.h>
> @@ -1537,6 +1541,425 @@ static int do_loadall(int argc, char **argv)
>  	return load_with_options(argc, argv, false);
>  }
>  
> +#ifdef BPFTOOL_WITHOUT_SKELETONS
> +
> +static int do_profile(int argc, char **argv)
> +{
> +	return 0;
> +}
> +
> +#else /* BPFTOOL_WITHOUT_SKELETONS */
> +
> +#include "profiler.skel.h"
> +
> +#define SAMPLE_PERIOD  0x7fffffffffffffffULL
> +struct profile_metric {
> +	const char *name;
> +	struct perf_event_attr attr;
> +	bool selected;
> +	struct bpf_perf_event_value val;
> +
> +	/* calculate ratios like instructions per cycle */
> +	const int ratio_metric; /* 0 for N/A, 1 for index 0 (cycles)  */

Nit: Double space "  */"

> +	const float ratio_mul;
> +	const char *ratio_desc;
> +} metrics[] = {
> +	{
> +		.name = "cycles",
> +		.attr = {
> +			.freq = 0,
> +			.sample_period = SAMPLE_PERIOD,
> +			.inherit = 0,
> +			.type = PERF_TYPE_HARDWARE,
> +			.read_format = 0,
> +			.sample_type = 0,
> +			.config = PERF_COUNT_HW_CPU_CYCLES,
> +		},
> +	},
> +	{
> +		.name = "instructions",
> +		.attr = {
> +			.freq = 0,
> +			.sample_period = SAMPLE_PERIOD,
> +			.inherit = 0,
> +			.type = PERF_TYPE_HARDWARE,
> +			.read_format = 0,
> +			.sample_type = 0,
> +			.config = PERF_COUNT_HW_INSTRUCTIONS,
> +		},
> +		.ratio_metric = 1,
> +		.ratio_mul = 1.0,
> +		.ratio_desc = "insn per cycle",
> +	},
> +	{
> +		.name = "l1d_loads",
> +		.attr = {
> +			.freq = 0,
> +			.sample_period = SAMPLE_PERIOD,
> +			.inherit = 0,
> +			.type = PERF_TYPE_HW_CACHE,
> +			.read_format = 0,
> +			.sample_type = 0,
> +			.config =
> +				PERF_COUNT_HW_CACHE_L1D |
> +				(PERF_COUNT_HW_CACHE_OP_READ << 8) |
> +				(PERF_COUNT_HW_CACHE_RESULT_ACCESS << 16),
> +		},
> +	},
> +	{
> +		.name = "llc_misses",
> +		.attr = {
> +			.freq = 0,
> +			.sample_period = SAMPLE_PERIOD,
> +			.inherit = 0,
> +			.type = PERF_TYPE_HW_CACHE,
> +			.read_format = 0,
> +			.sample_type = 0,
> +			.config =
> +				PERF_COUNT_HW_CACHE_LL |
> +				(PERF_COUNT_HW_CACHE_OP_READ << 8) |
> +				(PERF_COUNT_HW_CACHE_RESULT_MISS << 16),
> +		},
> +		.ratio_metric = 2,
> +		.ratio_mul = 1e6,
> +		.ratio_desc = "LLC misses per million isns",

s/isns/insns/, to remain consistent with "insn per cycle"?
(And if you change it, please update the example in man page)

> +	},
> +};
> +
> +u64 profile_total_count;

We should probably stick to __u64 (and __u32, etc.) in bpftool.

> +
> +#define MAX_NUM_PROFILE_METRICS 4
> +
> +static int profile_parse_metrics(int argc, char **argv)
> +{
> +	unsigned int metric_cnt;
> +	int selected_cnt = 0;
> +	unsigned int i;
> +
> +	metric_cnt = sizeof(metrics) / sizeof(struct profile_metric);
> +
> +	while (argc > 0) {
> +		for (i = 0; i < metric_cnt; i++) {
> +			if (strcmp(argv[0], metrics[i].name) == 0) {

Could we use prefixing (is_prefix() instead of strcmp()), as for the
other bpftool commands and keywords?

> +				if (!metrics[i].selected)
> +					selected_cnt++;
> +				metrics[i].selected = true;
> +				break;
> +			}
> +		}
> +		if (i == metric_cnt) {
> +			p_err("unknown metric %s", argv[0]);
> +			return -1;
> +		}
> +		NEXT_ARG();
> +	}
> +	if (selected_cnt > MAX_NUM_PROFILE_METRICS) {
> +		p_err("too many (%d) metrics, please specify no more than %d metrics at at time",
> +		      selected_cnt, MAX_NUM_PROFILE_METRICS);
> +		return -1;
> +	}
> +	return selected_cnt;
> +}

[...]

> +
> +static int do_profile(int argc, char **argv)
> +{
> +	int num_metric, num_cpu, err = -1;
> +	struct bpf_program *prog;
> +	unsigned long duration;
> +	char *endptr;
> +
> +	/* we at least need: <duration>, "id", <id>, <metric> */

Not necessarily "id" (can be "tag", "pinned", "name") but ok, probably
doesn't matter in the comment.

More important: I thought "duration" was optional?

> +	if (argc < 4)
> +		usage();

Or, as in other subcommands:

	if (!REQ_ARGS(4))
		return -EINVAL;

> +
> +	/* parse profiling duration */
> +	duration = strtoul(*argv, &endptr, 0);
> +	if (*endptr)
> +		duration = PROFILE_DEFAULT_LONG_DURATION;
> +	else
> +		NEXT_ARG();

If the field is optional, maybe it could be interesting to add a keyword
to the command line before passing it ("duration <n>"). It may turn
helpful if we add other optional parameters in the future, to know which
one we are passing (and might even help with bash completion).

> +
> +	/* parse target fd */
> +	profile_tgt_fd = prog_parse_fd(&argc, &argv);
> +	if (profile_tgt_fd < 0) {
> +		p_err("failed to parse fd");
> +		return -1;
> +	}

I would be tempted to have program handle _before_ duration on the
command line, what do you think?

    bpftool prog profile <mandatory_prog> <profile_options> <metrics>

> +
> +	num_metric = profile_parse_metrics(argc, argv);
> +	if (num_metric <= 0)
> +		goto out;
> +
> +	num_cpu = libbpf_num_possible_cpus();
> +	if (num_cpu <= 0) {
> +		p_err("failed to identify number of CPUs");
> +		goto out;
> +	}
> +
> +	profile_obj = profiler_bpf__open();
> +	if (!profile_obj) {
> +		p_err("failed to open and/or load BPF object");
> +		goto out;
> +	}
> +
> +	profile_obj->rodata->num_cpu = num_cpu;
> +	profile_obj->rodata->num_metric = num_metric;
> +
> +	/* adjust map sizes */
> +	bpf_map__resize(profile_obj->maps.events, num_metric * num_cpu);
> +	bpf_map__resize(profile_obj->maps.fentry_readings, num_metric);
> +	bpf_map__resize(profile_obj->maps.accum_readings, num_metric);
> +	bpf_map__resize(profile_obj->maps.counts, 1);
> +
> +	/* change target name */
> +	profile_tgt_name = profile_target_name(profile_tgt_fd);
> +	if (!profile_tgt_name) {
> +		p_err("failed to load target function name");
> +		goto out;
> +	}
> +
> +	bpf_object__for_each_program(prog, profile_obj->obj) {
> +		err = bpf_program__set_attach_target(prog, profile_tgt_fd,
> +						     profile_tgt_name);
> +		if (err) {
> +			p_err("failed to set attach target\n");
> +			goto out;
> +		}
> +	}
> +
> +	set_max_rlimit();
> +	err = profiler_bpf__load(profile_obj);
> +	if (err) {
> +		p_err("failed to load profile_obj");
> +		goto out;
> +	}
> +
> +	profile_open_perf_events(profile_obj);
> +
> +	err = profiler_bpf__attach(profile_obj);
> +	if (err) {
> +		p_err("failed to attach profile_obj");
> +		goto out;
> +	}
> +	signal(SIGINT, int_exit);
> +
> +	sleep(duration);
> +	profile_print_and_cleanup();
> +	return 0;
> +out:
> +	close(profile_tgt_fd);
> +	free(profile_tgt_name);
> +	return err;
> +}
> +
> +#endif /* BPFTOOL_WITHOUT_SKELETONS */
> +
>  static int do_help(int argc, char **argv)
>  {
>  	if (json_output) {
> @@ -1560,6 +1983,7 @@ static int do_help(int argc, char **argv)
>  		"                         [data_out FILE [data_size_out L]] \\\n"
>  		"                         [ctx_in FILE [ctx_out FILE [ctx_size_out M]]] \\\n"
>  		"                         [repeat N]\n"
> +		"       %s %s profile [DURATION] PROG METRICs\n"
>  		"       %s %s tracelog\n"
>  		"       %s %s help\n"
>  		"\n"
> @@ -1578,11 +2002,12 @@ static int do_help(int argc, char **argv)
>  		"       ATTACH_TYPE := { msg_verdict | stream_verdict | stream_parser |\n"
>  		"                        flow_dissector }\n"
>  		"       " HELP_SPEC_OPTIONS "\n"
> +		"       METRIC := { cycles | instructions | l1d_loads | llc_misses }\n"

Can we keep HELP_SPEC_OPTIONS at the end (below METRICS) please?

>  		"",
>  		bin_name, argv[-2], bin_name, argv[-2], bin_name, argv[-2],
>  		bin_name, argv[-2], bin_name, argv[-2], bin_name, argv[-2],
>  		bin_name, argv[-2], bin_name, argv[-2], bin_name, argv[-2],
> -		bin_name, argv[-2]);
> +		bin_name, argv[-2], bin_name, argv[-2]);
>  
>  	return 0;
>  }
> @@ -1599,6 +2024,7 @@ static const struct cmd cmds[] = {
>  	{ "detach",	do_detach },
>  	{ "tracelog",	do_tracelog },
>  	{ "run",	do_run },
> +	{ "profile",	do_profile },
>  	{ 0 }
>  };
>  
> diff --git a/tools/bpf/bpftool/skeleton/profiler.bpf.c b/tools/bpf/bpftool/skeleton/profiler.bpf.c
> new file mode 100644
> index 000000000000..abd3a7aacc1f
> --- /dev/null
> +++ b/tools/bpf/bpftool/skeleton/profiler.bpf.c
> @@ -0,0 +1,171 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// Copyright (c) 2019 Facebook

2019?

> +#include "profiler.h"
> +#include <linux/bpf.h>
> +#include <bpf/bpf_helpers.h>

[...]

> diff --git a/tools/bpf/bpftool/skeleton/profiler.h b/tools/bpf/bpftool/skeleton/profiler.h
> new file mode 100644
> index 000000000000..ae15cb0c4d43
> --- /dev/null
> +++ b/tools/bpf/bpftool/skeleton/profiler.h
> @@ -0,0 +1,47 @@
> +/* SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause) */
> +#ifndef __PROFILER_H
> +#define __PROFILER_H
> +
> +/* useful typedefs from vimlinux.h */

Typo: vimlinux.h
