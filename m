Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B8DC18ABA7
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 05:15:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725970AbgCSEP3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 00:15:29 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:40873 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbgCSEP3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 00:15:29 -0400
Received: by mail-qk1-f193.google.com with SMTP id j2so1184279qkl.7
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 21:15:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ACBUKYFz56rYSMbOM+EDRADHwdlHl87he6dVYm6MK9o=;
        b=CwG+gh5sXV9wy+tdYlPTnwWLm7qgqOCz3P6COc+q7457NMW2P3ILqA9s/+6QWv+8vy
         8poFHRcQ2iyu2WQoT18uwC8irch5rPRHfJfOodCtaENVCtj6wEn968TulTeVlJv+TbHa
         lSCnkp95AKtM8YcmZIgPfhV9Ao1mY69toKjri1Jvi/ZmATilfCNSDhkj4YI5/KwutmEx
         RqV0jUabNY0F8wmHlO0NXWuLke34ieFdeKAnbh5MQqOM67EM1lw8qUc5GpJ0NEEICGhy
         o2slQW9GqFNFy49gCEo1pT+d3GSIbd1sz30KuWJzFArsch87jxN8L7VJ0JIh/rAjUCU1
         CO1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ACBUKYFz56rYSMbOM+EDRADHwdlHl87he6dVYm6MK9o=;
        b=aqHQhqiR+GA6zDd1M/JeeODtFD+BtzW1jSV5dmmqTE40GIl0f07eXaeZDNjMzl5ShF
         12LFh5wDJxGkYW7iGQ4eQpTwuDlcIIGl1FnbqvIw3isIU/XpbJeMZz8URVO+X45GxNc/
         j85d6KgUnA/C8slrnxO/2Iobzo0OvYTuMJ+KYz9myFUNk9a7i8qv4e7EZ/DL42Xbu+jH
         WaMLmJeeCssGn1iFxWmSrjmsztXnbIcPArcyHz/Ly4bUXlr6XJegxkZ7tGR9mKAYe8IM
         gwwikNUgnSCsn40K3jBnZVYeXA2cjGOCNNrc0IFtmU12HtZV3PttLhW5kIn+V4/J7rUL
         YhIw==
X-Gm-Message-State: ANhLgQ10CK1vJEVHKB7B6fOqy1Vuzvan9ZQqtnI/muD5CZC8HErot61H
        2fD3Ugd3DGmUF3eK0Ny/BPynp1A/MLBJ5Ev4r7H70A==
X-Google-Smtp-Source: ADFU+vudYeq0nk20DXy4ZGbabaOUyEUw0/1aXSBXmC1cJBFh0dfvNlUlDrZx/nKddUUhI80erV587MhYrbNlUcW6c2Q=
X-Received: by 2002:a25:bb89:: with SMTP id y9mr1675045ybg.324.1584591327469;
 Wed, 18 Mar 2020 21:15:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200311213613.210749-1-irogers@google.com> <20200318102254.GC821557@krava>
In-Reply-To: <20200318102254.GC821557@krava>
From:   Ian Rogers <irogers@google.com>
Date:   Wed, 18 Mar 2020 21:15:16 -0700
Message-ID: <CAP-5=fU0AAmW7B5Qw+mmA9PhLYgMxKtiuxo3UcPbbowKJPhg8A@mail.gmail.com>
Subject: Re: [PATCH v3] perf tools: add support for libpfm4
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
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
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-perf-users@vger.kernel.org,
        Stephane Eranian <eranian@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 18, 2020 at 3:23 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Wed, Mar 11, 2020 at 02:36:13PM -0700, Ian Rogers wrote:
> > This patch links perf with the libpfm4 library if it is available and
> > NO_LIBPFM4 isn't passed to the build. The libpfm4 library contains hardware
> > event tables for all processors supported by perf_events. It is a helper
> > library that helps convert from a symbolic event name to the event
> > encoding required by the underlying kernel interface. This
> > library is open-source and available from: http://perfmon2.sf.net.
> >
> > With this patch, it is possible to specify full hardware events
> > by name. Hardware filters are also supported. Events must be
> > specified via the --pfm-events and not -e option. Both options
> > are active at the same time and it is possible to mix and match:
> >
> > $ perf stat --pfm-events inst_retired:any_p:c=1:i -e cycles ....
> >
> > v3 is against acme/perf/core removes a diagnostic warning
> > v2 of this patch makes the --pfm-events man page documentation
> > conditional on libpfm4 behing configured. It tidies some of the
> > documentation and adds the feature test missed in the v1 patch.
> >
> > Author: Stephane Eranian <eranian@google.com>
> > Signed-off-by: Ian Rogers <irogers@google.com>
>
> hi,
> is this the latest version? I can't apply it on Arnaldo's perf/core
>
> jirka


Sorry, I'd failed to re-add the feature test when I shifted branches.
The complete patch should be here:
https://lkml.org/lkml/2020/3/19/4

Thanks,
Ian
