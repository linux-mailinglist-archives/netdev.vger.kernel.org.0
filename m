Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AFCE1C8DFB
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 16:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727117AbgEGOKx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 10:10:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728079AbgEGOIg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 10:08:36 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 792FCC05BD0B
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 07:08:34 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id a83so5879864qkc.11
        for <netdev@vger.kernel.org>; Thu, 07 May 2020 07:08:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=8gUq3gZyaZ+fW8XLtscPZL56CqBcOzYoWmQ7LuAcGtI=;
        b=FLwhxmxE9Kn4GfmG3U0Yu/lCaNdW9kqc5eEffkTMYlq/SKBA3xID+QyQlgMVnGZpKT
         1IVUVw8AwjP3otNHvUElNrbz+jFr5KZZcYsXD5Voy2RHdAYqhcA32TncU80mhVoJq/RI
         gRXz5+FThd7TkwHO5sGBJvyrx6VImw+GqXJMLdt9mGZpVV9U8QtsQWp+Om0zJNssRyIC
         w7JuUSiWokcGnQqAcRjWv9Lm0PbI/SQmlFHMH+LXozd1NnyZO1ecYk6EIwJiQFPl1IRE
         TGu1VmFv7sLEhafn2v43RJwToe0dzQfULG1451Ok9KrizD2ONEPyDOgtRRhIJfckxgHf
         jowQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=8gUq3gZyaZ+fW8XLtscPZL56CqBcOzYoWmQ7LuAcGtI=;
        b=ao3MIvo7SPIm3g9b3/VWIUcl3GE3Pp9/zBwCNJNnDk/qGFlqL1GT87GWoWy+HwAeAM
         uZO9NQ2oehET41b9UKgAzRD4/HIWL0OZ2s5n4YzU8M+SE8idJDgsgeC4j1ieVdfHWR7b
         9LZ9SZ9TFhZF2rrWAKUuxMXwsBqZNUy9qALH7BSfwEiGno5gwJt+S3PbH/wFsi1Icawj
         M8bXw7ezGz3pVEwsaiiRFotj2LretGAACowmEIZf/GhLvqDtN0gsgZGMwxN5qrVWp6fl
         FxnFTeqgQ1mu/66x7eWjm9ycy9G/F8Kpqoryv6VSA+M/MWqIydBEiP263DlgrjGw8T8a
         lqTg==
X-Gm-Message-State: AGi0PuZByvtGC8P8mOKQwGsAVVjdH4oc9Owgyiq90cSwGZCCdX8hsuM3
        Ck7AHEa1K+b6jJjGFMJG8V+eppGX7veT
X-Google-Smtp-Source: APiQypICenctDKpj6LjD3iDGO0rD+FnV+zbkXnX+hjhzB2QyYx7BvIYqsNnoM/UlfDMRcSCq+58JuDfWQxm3
X-Received: by 2002:a0c:aa51:: with SMTP id e17mr13227862qvb.95.1588860513634;
 Thu, 07 May 2020 07:08:33 -0700 (PDT)
Date:   Thu,  7 May 2020 07:08:01 -0700
In-Reply-To: <20200507140819.126960-1-irogers@google.com>
Message-Id: <20200507140819.126960-6-irogers@google.com>
Mime-Version: 1.0
References: <20200507140819.126960-1-irogers@google.com>
X-Mailer: git-send-email 2.26.2.526.g744177e7f7-goog
Subject: [RFC PATCH v2 05/23] perf expr: increase max other
From:   Ian Rogers <irogers@google.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Kajol Jain <kjain@linux.ibm.com>,
        Andi Kleen <ak@linux.intel.com>,
        John Garry <john.garry@huawei.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Kim Phillips <kim.phillips@amd.com>,
        linux-kernel@vger.kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-perf-users@vger.kernel.org,
        Stephane Eranian <eranian@google.com>,
        Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Large metrics such as Branch_Misprediction_Cost_SMT on x86 broadwell
need more space.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 tools/perf/util/expr.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/expr.h b/tools/perf/util/expr.h
index 87d627bb699b..40fc452b0f2b 100644
--- a/tools/perf/util/expr.h
+++ b/tools/perf/util/expr.h
@@ -2,7 +2,7 @@
 #ifndef PARSE_CTX_H
 #define PARSE_CTX_H 1
 
-#define EXPR_MAX_OTHER 20
+#define EXPR_MAX_OTHER 64
 #define MAX_PARSE_ID EXPR_MAX_OTHER
 
 struct expr_parse_id {
-- 
2.26.2.526.g744177e7f7-goog

