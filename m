Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D8694F8ED0
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 08:27:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234035AbiDHD6n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 23:58:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233984AbiDHD6a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 23:58:30 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88915DD941
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 20:56:27 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id b12-20020a056902030c00b0061d720e274aso5729183ybs.20
        for <netdev@vger.kernel.org>; Thu, 07 Apr 2022 20:56:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=l17qIMDJgHlHJkmXqdwNhErpsnzRSh+81icGNnMQVKs=;
        b=CDF0VWxYUKfVOpEvH57Wcg+2Ht824//X9lGhIknOL9VIIF+EdYpmgeX3CHwN9sHeAT
         u9PeKn+tbOApjUseyK1kOHNHVP2i7a3oY6N/aX/r+Oqy5v3/FNPZf7VsQl77EpKtFjXz
         x0JMAMOcie6hoUXElxRbsp2ogGcKFaa+jDBwAQLG/kcORFBLquHUEfyiXtVheFEeeW8I
         inJLEZUd53sSTeyezcwzA/kev6gYerwGABOZqnuIZb8SbdZ2hfZ0ujxMuq3R1R3/r14V
         FxilRM0ZPu80qsZ1UH7WmH9ceYh4ckUANkk5Vjg8tXV2FCorud/XocnxT0G86KTWcY/I
         mlRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=l17qIMDJgHlHJkmXqdwNhErpsnzRSh+81icGNnMQVKs=;
        b=kGIhgcxH26zD3S+J2E9mx+c9jTMkxgOgIFAOBbFGwZF7bXg20B5qCwk9q3PfemUBo9
         1+0oXHZpN6aQp5eOcZFheTf6smbZvy7XoOMOQYwBWX/Eu0tR1l0L0bmSUEC5EzskPNEY
         EdRS8fj0uqk7LjcbhSaIhHM9RmFA9QsXj1Qn9LZx4ERv0mTmGCeNspx+meCbtlEsSqQR
         ArSKZJrqROSBKA/KeughVnMX3p2ZCAHYq+fTaYCKUsS24LwvWPi/2LbcRa6wXKk8isP7
         eU75ZgK0C5b2CSNzvjjqySbtF13jItBGu9z3/sUoVScYbKc7AXqec/liNt7TjukqXpcY
         g79g==
X-Gm-Message-State: AOAM532zryV+s7wZYjY749N+kej4nrSekR75luGvMNfmQaaKzc8k4xh2
        ry7zuOslk6FSmclV9BA3q0ng8ghtGEQC
X-Google-Smtp-Source: ABdhPJx0t6TUTcHjyQ+6Q0vxZrojw0BDHuxcmQSgV2WmscSbmIhwWv3XjfnNAnYb/FSu9l7V1FRxddn/jSqN
X-Received: from irogers.svl.corp.google.com ([2620:15c:2cd:202:560:aa27:649e:a07d])
 (user=irogers job=sendgmr) by 2002:a25:e30a:0:b0:625:3d53:91b7 with SMTP id
 z10-20020a25e30a000000b006253d5391b7mr12600758ybd.499.1649390186782; Thu, 07
 Apr 2022 20:56:26 -0700 (PDT)
Date:   Thu,  7 Apr 2022 20:56:13 -0700
In-Reply-To: <20220408035616.1356953-1-irogers@google.com>
Message-Id: <20220408035616.1356953-3-irogers@google.com>
Mime-Version: 1.0
References: <20220408035616.1356953-1-irogers@google.com>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH v3 2/5] perf tests: Additional cpumap merge tests
From:   Ian Rogers <irogers@google.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mike Leach <mike.leach@linaro.org>,
        Leo Yan <leo.yan@linaro.org>,
        John Garry <john.garry@huawei.com>,
        Will Deacon <will@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Kajol Jain <kjain@linux.ibm.com>,
        James Clark <james.clark@arm.com>,
        German Gomez <german.gomez@arm.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Riccardo Mancini <rickyman7@gmail.com>,
        Andi Kleen <ak@linux.intel.com>,
        Alexey Bayduraev <alexey.v.bayduraev@linux.intel.com>,
        Alexander Antonov <alexander.antonov@linux.intel.com>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        coresight@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Stephane Eranian <eranian@google.com>,
        Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cover cases where one cpu map is a subset of the other.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 tools/perf/tests/cpumap.c | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/tools/perf/tests/cpumap.c b/tools/perf/tests/cpumap.c
index cf205ed6b158..3b9fc549d30b 100644
--- a/tools/perf/tests/cpumap.c
+++ b/tools/perf/tests/cpumap.c
@@ -123,22 +123,36 @@ static int test__cpu_map_print(struct test_suite *test __maybe_unused, int subte
 	return 0;
 }
 
-static int test__cpu_map_merge(struct test_suite *test __maybe_unused, int subtest __maybe_unused)
+static int __test__cpu_map_merge(const char *lhs, const char *rhs, int nr, const char *expected)
 {
-	struct perf_cpu_map *a = perf_cpu_map__new("4,2,1");
-	struct perf_cpu_map *b = perf_cpu_map__new("4,5,7");
+	struct perf_cpu_map *a = perf_cpu_map__new(lhs);
+	struct perf_cpu_map *b = perf_cpu_map__new(rhs);
 	struct perf_cpu_map *c = perf_cpu_map__merge(a, b);
 	char buf[100];
 
-	TEST_ASSERT_VAL("failed to merge map: bad nr", perf_cpu_map__nr(c) == 5);
+	TEST_ASSERT_EQUAL("failed to merge map: bad nr", perf_cpu_map__nr(c), nr);
 	cpu_map__snprint(c, buf, sizeof(buf));
-	TEST_ASSERT_VAL("failed to merge map: bad result", !strcmp(buf, "1-2,4-5,7"));
+	TEST_ASSERT_VAL("failed to merge map: bad result", !strcmp(buf, expected));
 	perf_cpu_map__put(a);
 	perf_cpu_map__put(b);
 	perf_cpu_map__put(c);
 	return 0;
 }
 
+static int test__cpu_map_merge(struct test_suite *test __maybe_unused, int subtest __maybe_unused)
+{
+	int ret;
+
+	ret = __test__cpu_map_merge("4,2,1", "4,5,7", 5, "1-2,4-5,7");
+	if (ret) return ret;
+	ret = __test__cpu_map_merge("4,2,1", "1", 3, "1-2,4");
+	if (ret) return ret;
+	ret = __test__cpu_map_merge("1", "4,2,1", 3, "1-2,4");
+	if (ret) return ret;
+	ret = __test__cpu_map_merge("1", "1", 1, "1");
+	return ret;
+}
+
 DEFINE_SUITE("Synthesize cpu map", cpu_map_synthesize);
 DEFINE_SUITE("Print cpu map", cpu_map_print);
 DEFINE_SUITE("Merge cpu map", cpu_map_merge);
-- 
2.35.1.1178.g4f1659d476-goog

