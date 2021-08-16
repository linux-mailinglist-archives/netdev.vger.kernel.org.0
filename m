Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD5E3EDDE3
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 21:28:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbhHPT26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 15:28:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbhHPT25 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 15:28:57 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECAA7C061764;
        Mon, 16 Aug 2021 12:28:25 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id a126so6005021ybg.6;
        Mon, 16 Aug 2021 12:28:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xOLGmKqsNdO/wte6QQWYwVypGu5lv1VOL9/PE5zzppg=;
        b=CA8ZD7TZwOAQKDSljQp1zBOxEqZoagJClVN1p/JdDItiAz55JSE7fm2HxWdD4Mbqt2
         fxChgYBx2PavugcoRDnjKuGMFoERQO9uubZC/oxrMywnQekamQULSdzvlRPVM/nuk7IQ
         6/08gnUpiEl2ZPOW+E4SgC7EW5LST560WMEsDJIr5gKiUQ3ULI9LtO6YPh3bXMyoQ16z
         F2tejZzoQw+s/yLqYDwhEMps9XJqgsQCE5KIBe2dTIjNZyZV3cYuLid/YaaW+Jtjxwb4
         GwZ5o2FC5Zbs/ljInvQlxZbj9s5lspwZfZG8Jp/wfGQfxeJ0Fw553X/LhJgxj63KT8wv
         vqWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xOLGmKqsNdO/wte6QQWYwVypGu5lv1VOL9/PE5zzppg=;
        b=b10Je8cUevDn+D5b/fy42wU+PhWG3Sli9fyj+09tT+ca3LifKGuNCeOHlwrzCtADN6
         7VfaYB2AaqduAC/eBzGC6XZbbtIJHZ6mCBz6Od/+1kn1Uh4HajVJzRttAVax1mppTl2r
         fhvs1FcOBaCV4hHJLyOWILRAzYZ8apdsm29xwy08Cr8k3r5hmy0fdg++EnXYWQwSh/1e
         3tNgf9btw31KSxdyDaU+YtgH3A9oWNQy19lDoAZ9yS05V+Z1AJnr5jXUf7GkitVvw0Tv
         8pzh5/VgggXCqK0hYs/FGH1qBSJ6Ezhhu3xEjmSpk54YNK5Qp+9tjDmNmX2gg8UZ9u6G
         zHDw==
X-Gm-Message-State: AOAM532rY6EBd7wlLS8PLwGRdLYgywBXAlli/xnCYT9Bz3uPWReh+Yhl
        sUyGU07I1aq0Y9n0VuGVkBHl02YYurS1kKAc5og=
X-Google-Smtp-Source: ABdhPJydaIx1EGJDFxukuEqSDWz/Sl0P7TDB1oBMX58voM9mT8n5uERM45Y3VwFbIt+do5gC9LOKUt5wbVPs/h9+9CQ=
X-Received: by 2002:a25:d691:: with SMTP id n139mr23296265ybg.27.1629142105099;
 Mon, 16 Aug 2021 12:28:25 -0700 (PDT)
MIME-Version: 1.0
References: <20210815103610.27887-1-falakreyaz@gmail.com>
In-Reply-To: <20210815103610.27887-1-falakreyaz@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 16 Aug 2021 12:28:14 -0700
Message-ID: <CAEf4BzZ+3hM9oPxdXsxXRKJD2TCmpXPnkWz1LPnP7mDagprdyA@mail.gmail.com>
Subject: Re: [PATCH] perflib: deprecate bpf_map__resize in favor of bpf_map_set_max_entries
To:     Muhammad Falak R Wani <falakreyaz@gmail.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Yu Kuai <yukuai3@huawei.com>,
        "linux-perf-use." <linux-perf-users@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 15, 2021 at 3:36 AM Muhammad Falak R Wani
<falakreyaz@gmail.com> wrote:
>
> As a part of libbpf 1.0 plan[0], this patch deprecates use of
> bpf_map__resize in favour of bpf_map__set_max_entries.
>
> Reference: https://github.com/libbpf/libbpf/issues/304
> [0]: https://github.com/libbpf/libbpf/wiki/Libbpf:-the-road-to-v1.0#libbpfh-high-level-apis
>
> Signed-off-by: Muhammad Falak R Wani <falakreyaz@gmail.com>
> ---

All looks good, there is an opportunity to simplify the code a bit (see below).

Arnaldo, I assume you'll take this through your tree or you'd like us
to take it through bpf-next?

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  tools/perf/util/bpf_counter.c        | 8 ++++----
>  tools/perf/util/bpf_counter_cgroup.c | 8 ++++----
>  2 files changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/tools/perf/util/bpf_counter.c b/tools/perf/util/bpf_counter.c
> index ba0f20853651..ced2dac31dcf 100644
> --- a/tools/perf/util/bpf_counter.c
> +++ b/tools/perf/util/bpf_counter.c
> @@ -127,9 +127,9 @@ static int bpf_program_profiler_load_one(struct evsel *evsel, u32 prog_id)
>
>         skel->rodata->num_cpu = evsel__nr_cpus(evsel);
>
> -       bpf_map__resize(skel->maps.events, evsel__nr_cpus(evsel));
> -       bpf_map__resize(skel->maps.fentry_readings, 1);
> -       bpf_map__resize(skel->maps.accum_readings, 1);
> +       bpf_map__set_max_entries(skel->maps.events, evsel__nr_cpus(evsel));
> +       bpf_map__set_max_entries(skel->maps.fentry_readings, 1);
> +       bpf_map__set_max_entries(skel->maps.accum_readings, 1);
>
>         prog_name = bpf_target_prog_name(prog_fd);
>         if (!prog_name) {
> @@ -399,7 +399,7 @@ static int bperf_reload_leader_program(struct evsel *evsel, int attr_map_fd,
>                 return -1;
>         }
>
> -       bpf_map__resize(skel->maps.events, libbpf_num_possible_cpus());
> +       bpf_map__set_max_entries(skel->maps.events, libbpf_num_possible_cpus());

If you set max_entries to 0 (or just skip specifying it) for events
map in util/bpf_skel/bperf_cgroup.bpf.c, you won't need to resize it,
libbpf will automatically size it to number of possible CPUs.

>         err = bperf_leader_bpf__load(skel);
>         if (err) {
>                 pr_err("Failed to load leader skeleton\n");
> diff --git a/tools/perf/util/bpf_counter_cgroup.c b/tools/perf/util/bpf_counter_cgroup.c
> index 89aa5e71db1a..cbc6c2bca488 100644
> --- a/tools/perf/util/bpf_counter_cgroup.c
> +++ b/tools/perf/util/bpf_counter_cgroup.c
> @@ -65,14 +65,14 @@ static int bperf_load_program(struct evlist *evlist)
>
>         /* we need one copy of events per cpu for reading */
>         map_size = total_cpus * evlist->core.nr_entries / nr_cgroups;
> -       bpf_map__resize(skel->maps.events, map_size);
> -       bpf_map__resize(skel->maps.cgrp_idx, nr_cgroups);
> +       bpf_map__set_max_entries(skel->maps.events, map_size);
> +       bpf_map__set_max_entries(skel->maps.cgrp_idx, nr_cgroups);
>         /* previous result is saved in a per-cpu array */
>         map_size = evlist->core.nr_entries / nr_cgroups;
> -       bpf_map__resize(skel->maps.prev_readings, map_size);
> +       bpf_map__set_max_entries(skel->maps.prev_readings, map_size);
>         /* cgroup result needs all events (per-cpu) */
>         map_size = evlist->core.nr_entries;
> -       bpf_map__resize(skel->maps.cgrp_readings, map_size);
> +       bpf_map__set_max_entries(skel->maps.cgrp_readings, map_size);
>
>         set_max_rlimit();
>
> --
> 2.17.1
>
