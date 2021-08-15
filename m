Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DAB73EC899
	for <lists+netdev@lfdr.de>; Sun, 15 Aug 2021 12:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237532AbhHOKhU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Aug 2021 06:37:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237218AbhHOKhP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Aug 2021 06:37:15 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 539EAC061764;
        Sun, 15 Aug 2021 03:36:45 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id u1so371495plr.1;
        Sun, 15 Aug 2021 03:36:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=4mogHWA6QzT7FGmVvV4ib7TduNlR3+X2wSwpcAXlyN4=;
        b=W6omr8rOLS+SIbhoYWYcUFGTpsMcBUKcXLrG+gjYlUCJux+gBeKcI1vAAhafD0wB2A
         93LxZ5+ve2YtJFtWDJdDkpDiy6sI582s3PCmSUAw9O9JbB88v+bzkiNLgKZS9qlwdnJV
         P5UMkyMnoYyEdaJ2hDfB0Do08GnvDVifdOUKh5lXu2p2HEtrUfSOmMwo9MPQoW25whpT
         a0XwGIYMaPJyLGHNbOAipSJ9xR7e8vVPHGcFsJ4ehyLg+96+ttr90EOad0CgpQv3Hxr+
         tW6GWiTCPidK7uUMdmVW4i9X0ikauisaj80uPEzwEqNS+ABsT8VQ99OnAk/h0IWK3cEM
         OLwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=4mogHWA6QzT7FGmVvV4ib7TduNlR3+X2wSwpcAXlyN4=;
        b=KMkWg0XzeNFvYTTKjzR7EbwGTl9qCtmu6nnmIWvF1YDPrz8H9LDVGoLwR8Apj1i0ju
         o7ZDXZHTzXQic63n5jbNO6+Bg1TJiDOeE010ULfp+O9xEcfdTmf2LreouzwKDDOcYrDn
         8rqIq4qqmwdQwp7280PDNUwZXG1/aK3fR3zhNnmzb21Xv+zrxD7YSpMAdSwmu2A6wfpz
         G3gXdxHWgepOJKkQSJ7VrXkqrmvfQ+VCtbGpoDHUPOBjwaIWPkx7Bhjzdg8UXC0KbnQ+
         DPvhN6W9qJIuq0qt7u9e2WUYYS0J0vMKv/+emrE+E7Av/07u7Zt7c83DSeQeqhCqmPey
         N0hg==
X-Gm-Message-State: AOAM533Fx89osZtLvsh9rmTV3dq5Y+0vvJVYbvN+KL3PFN45mDa9okgc
        3Pyekc2j2p8P2w+YkrqnWww=
X-Google-Smtp-Source: ABdhPJxpP3qd297/qpXYquTLhToc/GzsL3OpkN1Nnd0Ea3xfWoxISAPJoelSHZKuQG/uydbXOi8ixQ==
X-Received: by 2002:a63:d34e:: with SMTP id u14mr10682967pgi.244.1629023804820;
        Sun, 15 Aug 2021 03:36:44 -0700 (PDT)
Received: from u18.mshome.net ([167.220.238.196])
        by smtp.gmail.com with ESMTPSA id j22sm8845515pgb.62.2021.08.15.03.36.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Aug 2021 03:36:44 -0700 (PDT)
From:   Muhammad Falak R Wani <falakreyaz@gmail.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Yu Kuai <yukuai3@huawei.com>, linux-perf-users@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Muhammad Falak R Wani <falakreyaz@gmail.com>
Subject: [PATCH] perflib: deprecate bpf_map__resize in favor of bpf_map_set_max_entries
Date:   Sun, 15 Aug 2021 16:06:10 +0530
Message-Id: <20210815103610.27887-1-falakreyaz@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As a part of libbpf 1.0 plan[0], this patch deprecates use of
bpf_map__resize in favour of bpf_map__set_max_entries.

Reference: https://github.com/libbpf/libbpf/issues/304
[0]: https://github.com/libbpf/libbpf/wiki/Libbpf:-the-road-to-v1.0#libbpfh-high-level-apis

Signed-off-by: Muhammad Falak R Wani <falakreyaz@gmail.com>
---
 tools/perf/util/bpf_counter.c        | 8 ++++----
 tools/perf/util/bpf_counter_cgroup.c | 8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/tools/perf/util/bpf_counter.c b/tools/perf/util/bpf_counter.c
index ba0f20853651..ced2dac31dcf 100644
--- a/tools/perf/util/bpf_counter.c
+++ b/tools/perf/util/bpf_counter.c
@@ -127,9 +127,9 @@ static int bpf_program_profiler_load_one(struct evsel *evsel, u32 prog_id)
 
 	skel->rodata->num_cpu = evsel__nr_cpus(evsel);
 
-	bpf_map__resize(skel->maps.events, evsel__nr_cpus(evsel));
-	bpf_map__resize(skel->maps.fentry_readings, 1);
-	bpf_map__resize(skel->maps.accum_readings, 1);
+	bpf_map__set_max_entries(skel->maps.events, evsel__nr_cpus(evsel));
+	bpf_map__set_max_entries(skel->maps.fentry_readings, 1);
+	bpf_map__set_max_entries(skel->maps.accum_readings, 1);
 
 	prog_name = bpf_target_prog_name(prog_fd);
 	if (!prog_name) {
@@ -399,7 +399,7 @@ static int bperf_reload_leader_program(struct evsel *evsel, int attr_map_fd,
 		return -1;
 	}
 
-	bpf_map__resize(skel->maps.events, libbpf_num_possible_cpus());
+	bpf_map__set_max_entries(skel->maps.events, libbpf_num_possible_cpus());
 	err = bperf_leader_bpf__load(skel);
 	if (err) {
 		pr_err("Failed to load leader skeleton\n");
diff --git a/tools/perf/util/bpf_counter_cgroup.c b/tools/perf/util/bpf_counter_cgroup.c
index 89aa5e71db1a..cbc6c2bca488 100644
--- a/tools/perf/util/bpf_counter_cgroup.c
+++ b/tools/perf/util/bpf_counter_cgroup.c
@@ -65,14 +65,14 @@ static int bperf_load_program(struct evlist *evlist)
 
 	/* we need one copy of events per cpu for reading */
 	map_size = total_cpus * evlist->core.nr_entries / nr_cgroups;
-	bpf_map__resize(skel->maps.events, map_size);
-	bpf_map__resize(skel->maps.cgrp_idx, nr_cgroups);
+	bpf_map__set_max_entries(skel->maps.events, map_size);
+	bpf_map__set_max_entries(skel->maps.cgrp_idx, nr_cgroups);
 	/* previous result is saved in a per-cpu array */
 	map_size = evlist->core.nr_entries / nr_cgroups;
-	bpf_map__resize(skel->maps.prev_readings, map_size);
+	bpf_map__set_max_entries(skel->maps.prev_readings, map_size);
 	/* cgroup result needs all events (per-cpu) */
 	map_size = evlist->core.nr_entries;
-	bpf_map__resize(skel->maps.cgrp_readings, map_size);
+	bpf_map__set_max_entries(skel->maps.cgrp_readings, map_size);
 
 	set_max_rlimit();
 
-- 
2.17.1

