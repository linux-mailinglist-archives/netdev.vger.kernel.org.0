Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2DD41D7E00
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 18:11:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728378AbgERQLl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 12:11:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727005AbgERQLl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 12:11:41 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1348C061A0C;
        Mon, 18 May 2020 09:11:40 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id i68so8534059qtb.5;
        Mon, 18 May 2020 09:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=46lF+QtFgXZAOuFFqzwonrj3oCWIreIHncytf6FK25M=;
        b=ffEpG+9JTnfw8b1WGGfsqpwFXJN4tcAyAH4q+a3XMDgeRA3DmiN83iP7N4mpYQldUz
         ccWA6rVMzJlz/QEWFHwKUiuuiYJrW47OjOR7dvHEWDi50hRNsQx09UmWxqAXWmO6yo6r
         XvsWuyBKmcL106PtwMAvH4Vf8zNO1IiQ5g6zpuNBG3fpcRuLZjqZtctpo0djXxeo/qSc
         KWHHNZcshwWfKt9WhjrKBddLkOqn/kNlX9xeH9dqPoEhnCywifBFi37+C5uif8skBLPz
         /kgd8dYxBs5Es6nKgwkkRVZk54fZ8p78lQbEGYkkbJM5ERe0uOTImU0vWeay9siPpXX4
         hLog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=46lF+QtFgXZAOuFFqzwonrj3oCWIreIHncytf6FK25M=;
        b=GnVS7xtwTalFdXA+4fwpcqBqoKr+7Rc053BvuM+3wiiBTikdXDPgnUmf1R5nKU8Mh0
         eEZ8JSeZ2XNcvM9lhxEUxaMI5G4uzB37VY25Kk84IckrGHDiftCBT/f3bFh82AoJQ2Qu
         2RmUJ7tBdsu1sISWyx2KsYjnrJdDsjNG61ZS2ISYTxxFsG+SScb+1S0zB/q/L34IpCLD
         lkiFZ7Nwcl330rtC2Hp8yZ5PP7vmsT9rWjjxSTV+9scT+Rh4s1rOw2CGZl8uZhK9lGgU
         qhmIJSsTsRAIykzNYrxOPvidgt7VmuRODTfo88mT/iParBnmGGgMdPE6zUm2ideNp4Vj
         WSAQ==
X-Gm-Message-State: AOAM532jj5qMjLNj/p//EHTpJUeyr0aJrPFbZ4kVlokeZPGuBUx7IUor
        LBsb8ksAbHXAryzpZFGmXh0=
X-Google-Smtp-Source: ABdhPJzrG3Uf8Ibj1Saop7YWQ/ppUjCeJ5PhwgcpXGpqxRcTeDq5iC0T4at7rA212r1iKNbKThbOXA==
X-Received: by 2002:ac8:670b:: with SMTP id e11mr17679467qtp.365.1589818300012;
        Mon, 18 May 2020 09:11:40 -0700 (PDT)
Received: from quaco.ghostprotocols.net ([179.97.37.151])
        by smtp.gmail.com with ESMTPSA id h188sm8510823qke.82.2020.05.18.09.11.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2020 09:11:39 -0700 (PDT)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 61183410F5; Mon, 18 May 2020 13:11:37 -0300 (-03)
Date:   Mon, 18 May 2020 13:11:37 -0300
To:     Ian Rogers <irogers@google.com>
Cc:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
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
        Leo Yan <leo.yan@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH v3 7/7] perf expr: Migrate expr ids table to a hashmap
Message-ID: <20200518161137.GK24211@kernel.org>
References: <20200515221732.44078-1-irogers@google.com>
 <20200515221732.44078-8-irogers@google.com>
 <20200518154505.GE24211@kernel.org>
 <CAP-5=fWZwuSLaFX+-pgeE_H92Mtp7+_NrwBeRFTqyfPjVRkbWg@mail.gmail.com>
 <20200518160648.GI24211@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200518160648.GI24211@kernel.org>
X-Url:  http://acmel.wordpress.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Mon, May 18, 2020 at 01:06:48PM -0300, Arnaldo Carvalho de Melo escreveu:
> Em Mon, May 18, 2020 at 09:03:45AM -0700, Ian Rogers escreveu:
> > On Mon, May 18, 2020 at 8:45 AM Arnaldo Carvalho de Melo wrote:
> > this build issue sounds like this patch is missing:
> > https://lore.kernel.org/lkml/20200515221732.44078-3-irogers@google.com/
> > The commit message there could have explicitly said having this
> > #include causes the conflicting definitions between perf's debug.h and
> > libbpf_internal.h's definitions of pr_info, etc.
> 
> yeah, understood, but I'm not processing patches for tools/lib/bpf/,
> Daniel is, I'll only get that one later, then we can go back to the way
> you structured it. Just an extra bit of confusion in this process ;-)

So, thiis is failing on all alpine Linux containers:

  CC       /tmp/build/perf/util/metricgroup.o
  CC       /tmp/build/perf/util/header.o
In file included from util/metricgroup.c:25:0:
/git/linux/tools/lib/api/fs/fs.h:16:0: error: "FS" redefined [-Werror]
 #define FS(name)    \
 ^
In file included from /git/linux/tools/perf/util/hashmap.h:16:0,
                 from util/expr.h:11,
                 from util/metricgroup.c:14:
/usr/include/bits/reg.h:28:0: note: this is the location of the previous definition
 #define FS     25
 ^
  CC       /tmp/build/perf/util/callchain.o
  CC       /tmp/build/perf/util/values.o
  CC       /tmp/build/perf/util/debug.o
  CC       /tmp/build/perf/util/fncache.o
cc1: all warnings being treated as errors
mv: can't rename '/tmp/build/perf/util/.metricgroup.o.tmp': No such file or directory
/git/linux/tools/build/Makefile.build:96: recipe for target '/tmp/build/perf/util/metricgroup.o' failed


I'll check that soon,

- Arnaldo
