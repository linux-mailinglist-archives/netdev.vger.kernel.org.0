Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC9A41DD442
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 19:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728921AbgEUR0Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 13:26:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728456AbgEUR0O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 13:26:14 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75F84C061A0E
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 10:26:14 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id g79so3211136ybf.0
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 10:26:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RR9haEy3oD7+qrZeQ4YaXrnNf25B1l42i4uERnUL4Ng=;
        b=jMYRNs3LETif9kx5lz6ZAwErHdUoxgNvUzatgY5CTVI+2qpFNoF0jsdlLTT7BtaK9e
         6i/zlBga96SljJSmQpVD3KTnBot9yqGdXl+rsNH29wtmfpAoMU6frHcOfbreOttpP+O6
         gi7FdTi+La381CLUcNheHlgZn3liaJg4J6N1q0fiKXRsH5A/nqqcJH0XTJ8/ofrE8/s8
         82Tv8w9Gt+XXnNdhgafntMNF+6FxdXCoOEPQm5PnsuYKiuDGWqW9W9xmph4h/tccDag1
         vc5XaaJwA+hNdNi7yBsBi+YEK1MtSjIBZdLzRFXJ7uYbMgtEiJbJbpr7JCp1yaNC/xFH
         GOVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RR9haEy3oD7+qrZeQ4YaXrnNf25B1l42i4uERnUL4Ng=;
        b=azZ8y84YKVn7jeltFxniu8bJm1XsoV2OiiUcjNeZ5TBbE6BJvZ07X6PjeEocrdtWGk
         AZwXmK+wy2B3cP8m+LEf5eKFKr8Yrwk7lOE2f+5DGYZKga75ufVC16R1a3IdLcSTqhAr
         SfPKtlP6l8yKGS9D8cbDQko+Ne3JS599KT328vU+TFz68oKX1VBzGA4uxw+/AKzo7L6Y
         1Dp0kXpkWoDWJcCBy79ifrCGjg4YEcJ7bwiruTBPAIaI2zURXRmp7/wxtnNFvGrJ2Zyj
         cgImC3PjNip9PdKzkiAM1BucnciVvom0f6xaiM6CzCgcBKsrvzuc2LHUKCS61iFZhkoq
         fFXw==
X-Gm-Message-State: AOAM530t4lwfzau2TJKM+GOXXdv0ha04FJFJNnGHdeWMn6tCz6hEYcyh
        oUao2pSPjHGjj+i+TkPCAV43b2BTaylUgg/PBkQrAA==
X-Google-Smtp-Source: ABdhPJzpX45EVuQ2vGLsTMipO1SgdOv5ksUZ0EuPZQY7BsULRRHlyhO8sdpwgpDrzA9rndtePhE7F+OD2XNY6NJzjuY=
X-Received: by 2002:a25:c08b:: with SMTP id c133mr16746739ybf.286.1590081973287;
 Thu, 21 May 2020 10:26:13 -0700 (PDT)
MIME-Version: 1.0
References: <20200520072814.128267-1-irogers@google.com> <20200520072814.128267-6-irogers@google.com>
 <20200520134847.GM157452@krava> <CAP-5=fVGf9i7hvQcht_8mnMMjzhQYdFqPzZFraE-iMR7Vcr1tw@mail.gmail.com>
 <20200520220912.GP157452@krava> <CAP-5=fU12vP45Sg3uRSuz-xoceTPTKw9-XZieKv1PaTnREMdrw@mail.gmail.com>
 <20200521105412.GS157452@krava>
In-Reply-To: <20200521105412.GS157452@krava>
From:   Ian Rogers <irogers@google.com>
Date:   Thu, 21 May 2020 10:26:02 -0700
Message-ID: <CAP-5=fWfV=+TY80kvTz9ZmzzzR5inYbZXRuQfsLfe9tPG7eJrQ@mail.gmail.com>
Subject: Re: [PATCH 5/7] perf metricgroup: Remove duped metric group events
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Kajol Jain <kjain@linux.ibm.com>,
        Andi Kleen <ak@linux.intel.com>,
        John Garry <john.garry@huawei.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Paul Clarke <pc@us.ibm.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        linux-perf-users <linux-perf-users@vger.kernel.org>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Stephane Eranian <eranian@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 21, 2020 at 3:54 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Wed, May 20, 2020 at 03:42:02PM -0700, Ian Rogers wrote:
>
> SNIP
>
> > >
> > > hum, I think that's also concern if you are multiplexing 2 groups and one
> > > metric getting events from both groups that were not meassured together
> > >
> > > it makes sense to me put all the merged events into single weak group
> > > anything else will have the issue you described above, no?
> > >
> > > and perhaps add command line option for merging that to make sure it's
> > > what user actuly wants
> >
> > I'm not sure I'm following. With the patch set if we have 3 metrics
> > with the event groups shown:
> > M1: {A,B,C}:W
> > M2: {A,B}:W
> > M3: {A,B,D}:W
> >
> > then what happens is we sort the metrics in to M1, M3, M2 then when we
> > come to match the events:
> >
> >  - by default: match events allowing sharing if all events come from
> > the same group. So in the example M1 will first match with {A,B,C}
> > then M3 will fail to match the group {A,B,C} but match {A,B,D}; M2
> > will succeed with matching {A,B} from M1. The events/group for M2 can
> > be removed as they are no longer used. This kind of sharing is
> > opportunistic and respects existing groupings. While it may mean a
> > metric is computed from a group that now multiplexes, that group will
> > run for more of the time as there are fewer groups to multiplex with.
> > In this example we've gone from 3 groups down to 2, 8 events down to
> > 6. An improvement would be to realize that A,B is in both M1 and M3,
> > so when we print the stat we could combine these values.
>
> ok, I misunderstood and thought you would colaps also M3 to
> have A,B computed via M1 group and with separate D ...
>
> thanks a lot for the explanation, it might be great to have it
> in the comments/changelog or even man page

Thanks Jiri! Arnaldo do you want me to copy the description above into
the commit message of this change and resend?
This patch adds some description to find_evsel_group, this is expanded
by the next patch that adds the two command line flags:
https://lore.kernel.org/lkml/20200520072814.128267-7-irogers@google.com/
When writing the patches it wasn't clear to me how much detail to
include in say the man pages.

Thanks,
Ian

> >
> >  - with --metric-no-merge: no events are shared by metrics M1, M2 and
> > M3 have their events and computation as things currently are. There
> > are 3 groups and 8 events.
> >
> >  - with --metric-no-group: all groups are removed and so the evlist
> > has A,B,C,A,B,A,B,D in it. The matching will now match M1 to A,B,C at
> > the beginning of the list, M2 to the first A,B and M3 to the same A,B
> > and D at the end of the list. We've got no groups and the events have
> > gone from 8 down to 4.
> >
> > It is difficult to reason about which grouping is most accurate. If we
> > have 4 counters (no NMI watchdog) then this example will fit with no
> > multiplexing. The default above should achieve less multiplexing, in
> > the same way merging PMU events currently does - this patch is trying
> > to mirror the --no-merge functionality to a degree. Considering
> > TopDownL1 then we go from metrics that never sum to 100%, to metrics
> > that do in either the default or --metric-no-group cases.
> >
> > I'm not sure what user option is missing with these combinations? The
> > default is trying to strike a compromise and I think user interaction
> > is unnecessary, just as --no-merge doesn't cause interaction. If the
> > existing behavior is wanted using --metric-no-merge will give that.
> > The new default and --metric-no-group are hopefully going to reduce
> > the number of groups and events. I'm somewhat agnostic as to what the
> > flag functionality should be as what I'm working with needs either the
> > default or --metric-no-group, I can use whatever flag is agreed upon.
>
> no other option is needed then
>
> thanks,
> jirka
>
