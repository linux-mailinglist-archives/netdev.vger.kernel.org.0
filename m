Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A3271D7D2E
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 17:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728305AbgERPpK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 11:45:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727040AbgERPpK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 11:45:10 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6E2DC061A0C;
        Mon, 18 May 2020 08:45:09 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id r187so7633363qkf.6;
        Mon, 18 May 2020 08:45:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Rzkj0apKg+9dAE9ITAc0kw21NDc3bzZzChV1Zzph3jM=;
        b=eoYQijA0kQhBgOKv9S9xmjIl7acasA3cMRgnCt4EU7hUq7O3p3Izo7a9m3A4DynEEj
         kBFB7KLU/aVKPhrVcP59kJt/F+MLM9eu+w51RNa2tahs1XTJZyTfQY4uB79PxBLWROWs
         Xj6Es1MpLFAQWbn01mVGBjwP76xOFknhDjrOeWtGh9cweLHhdSbDpmSrU/VIJRM8jim6
         wJR3Gl95smJeRNGDAK+nnA5Rl3oLmU5/NhTkiDQTGD6uxACK2NMYFWU66CiDQy12zEqY
         5kUjal89YOm6/ZYzveiF2TsnfIIrD3QHxurA+Qy/5Vt5Lg0TUlHfGA9uEl2mIVASSTYs
         0K+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Rzkj0apKg+9dAE9ITAc0kw21NDc3bzZzChV1Zzph3jM=;
        b=j1L7ys1IUy1dH8+p6K/eXLPi7iEZE3URE7ZHpyqjIQjeqrWhKwVQeN0rX6cQp0XhHK
         empEbsXCoBdz5N7s25ChckhE9PixkwZu4huKpkR8S08xglQhUCcNWwM0jltju+6NbYDo
         28mCClGJTGhz1zL+pL0LVpWm4hfyPo498qMFawnbSiIrc60BsXwpuOkferkFo0OflKoO
         ED+YzeqmbLZyKxVwDSmteb/jHSYVxgGj+ty9K57ZKviiPflsXjrMDuoERT00b302QtUs
         HbDiKALrZT//0DGttkOXekCc1jZmU21kzVy70VC9KxzbT1n3XfipB8LmrQnAKxkni9nX
         t0iQ==
X-Gm-Message-State: AOAM5336lkVQzocWVLRbHFth/1RxjIrkFfU/LPhx5Ax0aZC0dAP7hjBI
        8rArW/puLgqqAVbVA+5ZI4C+Em7bBP7dSQ==
X-Google-Smtp-Source: ABdhPJxfI+1IUAtHN7pYsLjRTqhDQqKeGbS4oBXnUG5jDKgJ4GMTuEP/ADEccrcG7Bh9LNtQfO2q2A==
X-Received: by 2002:a37:8287:: with SMTP id e129mr12328386qkd.204.1589816708983;
        Mon, 18 May 2020 08:45:08 -0700 (PDT)
Received: from quaco.ghostprotocols.net ([179.97.37.151])
        by smtp.gmail.com with ESMTPSA id d196sm8538583qkg.16.2020.05.18.08.45.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2020 08:45:08 -0700 (PDT)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 4860040AFD; Mon, 18 May 2020 12:45:05 -0300 (-03)
Date:   Mon, 18 May 2020 12:45:05 -0300
To:     Ian Rogers <irogers@google.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
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
        Adrian Hunter <adrian.hunter@intel.com>,
        Leo Yan <leo.yan@linaro.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH v3 7/7] perf expr: Migrate expr ids table to a hashmap
Message-ID: <20200518154505.GE24211@kernel.org>
References: <20200515221732.44078-1-irogers@google.com>
 <20200515221732.44078-8-irogers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200515221732.44078-8-irogers@google.com>
X-Url:  http://acmel.wordpress.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Fri, May 15, 2020 at 03:17:32PM -0700, Ian Rogers escreveu:
> Use a hashmap between a char* string and a double* value. While bpf's
> hashmap entries are size_t in size, we can't guarantee sizeof(size_t) >=
> sizeof(double). Avoid a memory allocation when gathering ids by making 0.0
> a special value encoded as NULL.
> 
> Original map suggestion by Andi Kleen:
> https://lore.kernel.org/lkml/20200224210308.GQ160988@tassilo.jf.intel.com/
> and seconded by Jiri Olsa:
> https://lore.kernel.org/lkml/20200423112915.GH1136647@krava/

I'm having trouble here when building it with:

make -C tools/perf O=/tmp/build/perf

    CC       /tmp/build/perf/tests/expr.o
    INSTALL  trace_plugins
    CC       /tmp/build/perf/util/metricgroup.o
  In file included from /home/acme/git/perf/tools/lib/bpf/hashmap.h:18,
                   from /home/acme/git/perf/tools/perf/util/expr.h:6,
                   from tests/expr.c:3:
  /home/acme/git/perf/tools/lib/bpf/libbpf_internal.h:63: error: "pr_info" redefined [-Werror]
     63 | #define pr_info(fmt, ...) __pr(LIBBPF_INFO, fmt, ##__VA_ARGS__)
        |
  In file included from tests/expr.c:2:
  /home/acme/git/perf/tools/perf/util/debug.h:24: note: this is the location of the previous definition
 
It looks like libbpf's hashmap.h is being used instead of the one in
tools/perf/util/, yeah, as intended, but then since I don't have the
fixes you added to the BPF tree, the build fails, if I instead
unconditionally use

#include "util/hashmap.h"

It works. Please ack.

I.e. with the patch below, further tests:

[acme@five perf]$ perf -vv | grep -i bpf
                   bpf: [ on  ]  # HAVE_LIBBPF_SUPPORT
[acme@five perf]$ nm ~/bin/perf | grep -i libbpf_ | wc -l
39
[acme@five perf]$ nm ~/bin/perf | grep -i hashmap_ | wc -l
17
[acme@five perf]$

Explicitely building without LIBBPF:

[acme@five perf]$ perf -vv | grep -i bpf
                   bpf: [ OFF ]  # HAVE_LIBBPF_SUPPORT
[acme@five perf]$
[acme@five perf]$ nm ~/bin/perf | grep -i libbpf_ | wc -l
0
[acme@five perf]$ nm ~/bin/perf | grep -i hashmap_ | wc -l
9
[acme@five perf]$

Works,

- Arnaldo

diff --git a/tools/perf/util/expr.h b/tools/perf/util/expr.h
index d60a8feaf50b..8a2c1074f90f 100644
--- a/tools/perf/util/expr.h
+++ b/tools/perf/util/expr.h
@@ -2,11 +2,14 @@
 #ifndef PARSE_CTX_H
 #define PARSE_CTX_H 1
 
-#ifdef HAVE_LIBBPF_SUPPORT
-#include <bpf/hashmap.h>
-#else
-#include "hashmap.h"
-#endif
+// There are fixes that need to land upstream before we can use libbpf's headers,
+// for now use our copy unconditionally, since the data structures at this point
+// are exactly the same, no problem.
+//#ifdef HAVE_LIBBPF_SUPPORT
+//#include <bpf/hashmap.h>
+//#else
+#include "util/hashmap.h"
+//#endif
 
 struct expr_parse_ctx {
 	struct hashmap ids;
