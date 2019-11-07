Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AABD9F3B5A
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 23:23:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727034AbfKGWXU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 17:23:20 -0500
Received: from mail-qv1-f68.google.com ([209.85.219.68]:43649 "EHLO
        mail-qv1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbfKGWXU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 17:23:20 -0500
Received: by mail-qv1-f68.google.com with SMTP id cg2so1473526qvb.10;
        Thu, 07 Nov 2019 14:23:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=yew1kGqLdARlc4F/0Ldfg3TeatXOLJ2yXMHgCqKdarE=;
        b=HPM3WJ2iwHbv9LU9DBt53zzDpi3HBGDabp2msMh+/2nLzKLWwxKbMDTheMv3fLXRL6
         cQ/6+eBCatMW6dK/Ymb075NSdCNJ2X4XRAHseD4Npckm4eoNKwAY3lZzuN6K2NfYGVvO
         VWLf5dmFE0tMU5LqZe/dxsRDncRT7GJ4ogvTPAzFhjTlFhOF9LM7KwofD8pUqahiWjJf
         BQ6XKnOf1aIA5bOLFZEYjojWmnKgyd57GuuidefYOrcU3qSkFCNNpB+IIlhxihhEPr48
         PrUT+ibJ8pywCL9l5os6C4dTr0o3KrDuSKVtbOhOGYbtOXN7K/E9sJt9Sl+2v4MPtwZ+
         4gQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=yew1kGqLdARlc4F/0Ldfg3TeatXOLJ2yXMHgCqKdarE=;
        b=UG5mhp89cCy3jXlsZr8VCICQeD0lYxAULUh1X7wC0t/DLoBBdpO7PNS1Pm0QslsLAA
         euV4m/BHYvEfHfJAZxJD+gwd0eN3CrWoaIa7Tx5ZobVJfcWDSiHYeMeeYNnN55fTqWtJ
         IZtbWd+HUNG/2ekadPh5qcDhaDTeKHRegX7VNHUFOm6NsqU7pRqmdaemskLWDuQZx3hW
         U9ftOA19sMOlOrB2jnpB+bi/vE165R2d/ceiNEVtaRE+7TVnVcJG/Q6K7VP2dH3kmvVC
         34qq/dRwLuPV3mV8ocovn+DVW2pjZPaFmi7knNuoqqcYLm4pOr+rp6kY/SW+9oa9XeVc
         3lRg==
X-Gm-Message-State: APjAAAWTrqMa096veTAPEBgox0Yej3e5PWXWbNKHJdD8K4weAivhZy7V
        Z1lKaCf3gzjXCmaEtaMS6lENHc6nICo=
X-Google-Smtp-Source: APXvYqxW6sDS7SegH22noRhdOMu5DnRa05qbrbcI4epicbbsCZ9mcj9LA66uUMtEunO6hmcA/Ry06A==
X-Received: by 2002:a0c:c78b:: with SMTP id k11mr6109208qvj.47.1573165398694;
        Thu, 07 Nov 2019 14:23:18 -0800 (PST)
Received: from quaco.ghostprotocols.net ([179.97.35.50])
        by smtp.gmail.com with ESMTPSA id x194sm1522035qkb.66.2019.11.07.14.23.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Nov 2019 14:23:17 -0800 (PST)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id B1800411B3; Thu,  7 Nov 2019 19:23:15 -0300 (-03)
Date:   Thu, 7 Nov 2019 19:23:15 -0300
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
        Andi Kleen <ak@linux.intel.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        John Garry <john.garry@huawei.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH v6 00/10] Improvements to memory usage by parse events
Message-ID: <20191107222315.GA7261@kernel.org>
References: <20191030223448.12930-1-irogers@google.com>
 <20191107221428.168286-1-irogers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107221428.168286-1-irogers@google.com>
X-Url:  http://acmel.wordpress.com
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Thu, Nov 07, 2019 at 02:14:18PM -0800, Ian Rogers escreveu:
> The parse events parser leaks memory for certain expressions as well
> as allowing a char* to reference stack, heap or .rodata. This series
> of patches improves the hygeine and adds free-ing operations to
> reclaim memory in the parser in error and non-error situations.
> 
> The series of patches was generated with LLVM's address sanitizer and
> libFuzzer:
> https://llvm.org/docs/LibFuzzer.html
> called on the parse_events function with randomly generated input. With
> the patches no leaks or memory corruption issues were present.
> 
> The v6 patches address a C90 compilation issue.

Please take a look at what is in my perf/core branch, to see what is
left, if something needs fixing, please send a patch on top of that,

Thanks,

- Arnaldo
 
> The v5 patches add initial error print to the set, as requested by
> Jiri Olsa. They also fix additional 2 missed frees in the patch
> 'before yyabort-ing free components' and remove a redundant new_str
> variable from the patch 'add parse events handle error' as spotted by
> Stephane Eranian.
> 
> The v4 patches address review comments from Jiri Olsa, turning a long
> error message into a single warning, fixing the data type in a list
> iterator and reordering patches.
> 
> The v3 patches address review comments from Jiri Olsa improving commit
> messages, handling ENOMEM errors from strdup better, and removing a
> printed warning if an invalid event is passed.
> 
> The v2 patches are preferable to an earlier proposed patch:
>    perf tools: avoid reading out of scope array
> 
> Ian Rogers (10):
>   perf tools: add parse events handle error
>   perf tools: move ALLOC_LIST into a function
>   perf tools: avoid a malloc for array events
>   perf tools: splice events onto evlist even on error
>   perf tools: ensure config and str in terms are unique
>   perf tools: add destructors for parse event terms
>   perf tools: before yyabort-ing free components
>   perf tools: if pmu configuration fails free terms
>   perf tools: add a deep delete for parse event terms
>   perf tools: report initial event parsing error
> 
>  tools/perf/arch/powerpc/util/kvm-stat.c |   9 +-
>  tools/perf/builtin-stat.c               |   2 +
>  tools/perf/builtin-trace.c              |  16 +-
>  tools/perf/tests/parse-events.c         |   3 +-
>  tools/perf/util/metricgroup.c           |   2 +-
>  tools/perf/util/parse-events.c          | 239 +++++++++++----
>  tools/perf/util/parse-events.h          |   7 +
>  tools/perf/util/parse-events.y          | 390 +++++++++++++++++-------
>  tools/perf/util/pmu.c                   |  32 +-
>  9 files changed, 511 insertions(+), 189 deletions(-)
> 
> -- 
> 2.24.0.432.g9d3f5f5b63-goog

-- 

- Arnaldo
