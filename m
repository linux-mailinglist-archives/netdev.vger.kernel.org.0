Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A46331D7E0E
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 18:13:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728210AbgERQNt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 12:13:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727938AbgERQNt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 12:13:49 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E763AC061A0C;
        Mon, 18 May 2020 09:13:48 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id r187so7742911qkf.6;
        Mon, 18 May 2020 09:13:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GMVYcGgmCWXVXMi96UeLtdXnsMVNICFmWd3eu2GnbRY=;
        b=S9SXfDs7AuLg9S+tLzetnj4BGh4URmkncnPZmDhot6dytGVj7jkhZmzTgtEW7zg0o1
         qfCBfc7ayqBhvRkS1m/17eUu6doWlEw5c4Np8I02d+y4N6Ug0ShqlrIOil2dduJDQgy0
         L2hL8wbAoFMFNZcnfZozzStwHycKHigDtxRtk9B1u8G1zgG8zhiU48CBpVJYWl2qxBYf
         j3iNsT4eYLbqf/KHk17qPO1e5bMg0zijyVtBE3f7K7zlvna7dIBgqKcpz8652cRw2pFm
         6fOM/uil8DpwNaoK93ScthWKoKG1s0wRUzRkM3RVzA7vXXA1A+IaU8n7z+zw8RReGLkP
         qTjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GMVYcGgmCWXVXMi96UeLtdXnsMVNICFmWd3eu2GnbRY=;
        b=DCe7uDX+9SpI4K12D1QPmTu3XaUfF83xQ7YGXyh0Fhz9kImfKRACuvSid3EtL5QlxR
         6AsTe/zCt/tmfmccPtpX1DyQsiwoO5Up8pQwxjLoGFrd7jVjQIHV6sLlDjUxr89kb7yR
         /a7+W0PzGy6m4OCTFb665Pt4D9U+M7FKkl3whU0m7kzNpWwb1OhJ7mZJl2wQdszkgfng
         iwsh5o8mmDNn7Y3fnfLsGZ3b0CEU8aIJBAoMH/xtogEVtM3McrcIdJMOeXG0WXmErCgw
         4cnLGFDasY4QF4FhbUi+e/Pnqme3TN4l4sMDrxF9JhOUm6WTJlMQyE2KmOCBXFcmPcLp
         DH4g==
X-Gm-Message-State: AOAM533k7fG3iVcKlbQbV/7SY+gY0o59exVDxdsvcPRkzZaPMrj+JGqP
        nFcaECkaYFZhu2T3lCaBqFE=
X-Google-Smtp-Source: ABdhPJx1/uxU1D9aIW5llqDSDsu2XKSs3epbKft5uwWMIXVka4iApcVFYle5r/WmI9jkwH1NrVOBsw==
X-Received: by 2002:a37:8187:: with SMTP id c129mr16436860qkd.211.1589818428026;
        Mon, 18 May 2020 09:13:48 -0700 (PDT)
Received: from quaco.ghostprotocols.net ([179.97.37.151])
        by smtp.gmail.com with ESMTPSA id o23sm10077067qtf.53.2020.05.18.09.13.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2020 09:13:47 -0700 (PDT)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 44B9440AFD; Mon, 18 May 2020 13:06:48 -0300 (-03)
Date:   Mon, 18 May 2020 13:06:48 -0300
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
Message-ID: <20200518160648.GI24211@kernel.org>
References: <20200515221732.44078-1-irogers@google.com>
 <20200515221732.44078-8-irogers@google.com>
 <20200518154505.GE24211@kernel.org>
 <CAP-5=fWZwuSLaFX+-pgeE_H92Mtp7+_NrwBeRFTqyfPjVRkbWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAP-5=fWZwuSLaFX+-pgeE_H92Mtp7+_NrwBeRFTqyfPjVRkbWg@mail.gmail.com>
X-Url:  http://acmel.wordpress.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Mon, May 18, 2020 at 09:03:45AM -0700, Ian Rogers escreveu:
> On Mon, May 18, 2020 at 8:45 AM Arnaldo Carvalho de Melo
> <arnaldo.melo@gmail.com> wrote:
> >
> > Em Fri, May 15, 2020 at 03:17:32PM -0700, Ian Rogers escreveu:
> > > Use a hashmap between a char* string and a double* value. While bpf's
> > > hashmap entries are size_t in size, we can't guarantee sizeof(size_t) >=
> > > sizeof(double). Avoid a memory allocation when gathering ids by making 0.0
> > > a special value encoded as NULL.
> > >
> > > Original map suggestion by Andi Kleen:
> > > https://lore.kernel.org/lkml/20200224210308.GQ160988@tassilo.jf.intel.com/
> > > and seconded by Jiri Olsa:
> > > https://lore.kernel.org/lkml/20200423112915.GH1136647@krava/
> >
> > I'm having trouble here when building it with:
> >
> > make -C tools/perf O=/tmp/build/perf
> >
> >     CC       /tmp/build/perf/tests/expr.o
> >     INSTALL  trace_plugins
> >     CC       /tmp/build/perf/util/metricgroup.o
> >   In file included from /home/acme/git/perf/tools/lib/bpf/hashmap.h:18,
> >                    from /home/acme/git/perf/tools/perf/util/expr.h:6,
> >                    from tests/expr.c:3:
> >   /home/acme/git/perf/tools/lib/bpf/libbpf_internal.h:63: error: "pr_info" redefined [-Werror]
> >      63 | #define pr_info(fmt, ...) __pr(LIBBPF_INFO, fmt, ##__VA_ARGS__)
> >         |
> >   In file included from tests/expr.c:2:
> >   /home/acme/git/perf/tools/perf/util/debug.h:24: note: this is the location of the previous definition
> >
> > It looks like libbpf's hashmap.h is being used instead of the one in
> > tools/perf/util/, yeah, as intended, but then since I don't have the
> > fixes you added to the BPF tree, the build fails, if I instead
> > unconditionally use
> >
> > #include "util/hashmap.h"
> >
> > It works. Please ack.
> >
> > I.e. with the patch below, further tests:
> >
> > [acme@five perf]$ perf -vv | grep -i bpf
> >                    bpf: [ on  ]  # HAVE_LIBBPF_SUPPORT
> > [acme@five perf]$ nm ~/bin/perf | grep -i libbpf_ | wc -l
> > 39
> > [acme@five perf]$ nm ~/bin/perf | grep -i hashmap_ | wc -l
> > 17
> > [acme@five perf]$
> >
> > Explicitely building without LIBBPF:
> >
> > [acme@five perf]$ perf -vv | grep -i bpf
> >                    bpf: [ OFF ]  # HAVE_LIBBPF_SUPPORT
> > [acme@five perf]$
> > [acme@five perf]$ nm ~/bin/perf | grep -i libbpf_ | wc -l
> > 0
> > [acme@five perf]$ nm ~/bin/perf | grep -i hashmap_ | wc -l
> > 9
> > [acme@five perf]$
> >
> > Works,
> >
> > - Arnaldo
> 
> Hi Arnaldo,
> 
> this build issue sounds like this patch is missing:
> https://lore.kernel.org/lkml/20200515221732.44078-3-irogers@google.com/
> The commit message there could have explicitly said having this
> #include causes the conflicting definitions between perf's debug.h and
> libbpf_internal.h's definitions of pr_info, etc.

yeah, understood, but I'm not processing patches for tools/lib/bpf/,
Daniel is, I'll only get that one later, then we can go back to the way
you structured it. Just an extra bit of confusion in this process ;-)
 
> Let me know how else to help and sorry for the confusion. Thanks,
> Ian
> 
> 
> > diff --git a/tools/perf/util/expr.h b/tools/perf/util/expr.h
> > index d60a8feaf50b..8a2c1074f90f 100644
> > --- a/tools/perf/util/expr.h
> > +++ b/tools/perf/util/expr.h
> > @@ -2,11 +2,14 @@
> >  #ifndef PARSE_CTX_H
> >  #define PARSE_CTX_H 1
> >
> > -#ifdef HAVE_LIBBPF_SUPPORT
> > -#include <bpf/hashmap.h>
> > -#else
> > -#include "hashmap.h"
> > -#endif
> > +// There are fixes that need to land upstream before we can use libbpf's headers,
> > +// for now use our copy unconditionally, since the data structures at this point
> > +// are exactly the same, no problem.
> > +//#ifdef HAVE_LIBBPF_SUPPORT
> > +//#include <bpf/hashmap.h>
> > +//#else
> > +#include "util/hashmap.h"
> > +//#endif
> >
> >  struct expr_parse_ctx {
> >         struct hashmap ids;

-- 

- Arnaldo
