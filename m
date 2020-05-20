Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD43E1DC247
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 00:42:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728499AbgETWmQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 18:42:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728019AbgETWmP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 18:42:15 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EFF2C061A0E
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 15:42:15 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id 67so1772372ybn.11
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 15:42:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dvtn9Vcw9Mu98E89DI4uU9zUHcPKNAC6K0uYrY5V7wY=;
        b=maeJMRB/Bw0/93huxTAw8NYf3nSth3kkbZ9jMF+IJqT2fe0A1xTTw4sEh4NoG95aLe
         Po+q2bJp4eS3oJEc2sXJ28TdPUqHJomesT1sCV/yvkD5m2S/y+tyufRNDIthIIJSW7A7
         4R74ipSexjHgkb5kBTwWB0n//Uv7rtfY+XcPhEdVvWr6PMUKImP+vDaym8neM/m/akuJ
         x/ZIZragkSbzTAAi7cgYW+o7RWmwH7edNLhOggQ0iO1loGe/bCbX128N/G5Fp73Gojzp
         4bQjoHC+yDjmPHbFXbQs4Rn9HfWdBHyr/2fLKdDeBB7OWbY00I7QzxbFcrtG1pesDBJG
         jWXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dvtn9Vcw9Mu98E89DI4uU9zUHcPKNAC6K0uYrY5V7wY=;
        b=RIZ4I/gsiOdoGAbxg5x7wLFyGlFQGC7qTZA9QnDke6c8kJ+vurNiWuaImdMMuRtNYd
         jYI15xTzZ2j8WuBlzPerV/2M28OWW2RnRsl4673lIT2chxu2oL8cDHkspIRqJc9Cur0c
         SxF2izrFeBOt3Ef0DcCSjKjaH+tGNWfs83Q0BO6KvlAq1mp6Ki0e3nsDsvQl7A9mvbyS
         deuOGr3ny6lm8GAN6/tI8qjOou+c7/sfXXGquMMrs0nJ6Ob7/1MldyikuuuKOkCTqlfX
         bUFtJ2nuu8cXSMZ7AjapL23yCV/+TrjCKCQjnw1PIAiwKHz3giXdP9X78RzVljxpirK6
         yIpw==
X-Gm-Message-State: AOAM532pKY2rjIYaMIQwJHlmU0W5YBObHWFpZ4ADWPtH0FhLi8DBGiiu
        LsbmH3F/nFleWz5pYSnusuguaerSCOoJJ2HRYfjjfg==
X-Google-Smtp-Source: ABdhPJzs+ERhRHgOSK3Jl85Xe9DI8Tn03w4ppBuvTG+XjaVacohus9qdYiAG5C64Y7dMx6LihN2Z+owKtQ2E0CUdUUI=
X-Received: by 2002:a25:790e:: with SMTP id u14mr10909068ybc.324.1590014534392;
 Wed, 20 May 2020 15:42:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200520072814.128267-1-irogers@google.com> <20200520072814.128267-6-irogers@google.com>
 <20200520134847.GM157452@krava> <CAP-5=fVGf9i7hvQcht_8mnMMjzhQYdFqPzZFraE-iMR7Vcr1tw@mail.gmail.com>
 <20200520220912.GP157452@krava>
In-Reply-To: <20200520220912.GP157452@krava>
From:   Ian Rogers <irogers@google.com>
Date:   Wed, 20 May 2020 15:42:02 -0700
Message-ID: <CAP-5=fU12vP45Sg3uRSuz-xoceTPTKw9-XZieKv1PaTnREMdrw@mail.gmail.com>
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

On Wed, May 20, 2020 at 3:09 PM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Wed, May 20, 2020 at 09:50:13AM -0700, Ian Rogers wrote:
>
> SNIP
>
> > > > +             }
> > >
> > > is the groupping still enabled when we merge groups? could part
> > > of the metric (events) be now computed in different groups?
> >
> > By default the change will take two metrics and allow the shorter
> > metric (in terms of number of events) to share the events of the
> > longer metric. If the events for the shorter metric aren't in the
> > longer metric then the shorter metric must use its own group of
> > events. If sharing has occurred then the bitmap is used to work out
> > which events and groups are no longer in use.
> >
> > With --metric-no-group then any event can be used for a metric as
> > there is no grouping. This is why more events can be eliminated.
> >
> > With --metric-no-merge then the logic to share events between
> > different metrics is disabled and every metric is in a group. This
> > allows the current behavior to be had.
> >
> > There are some corner cases, such as metrics with constraints (that
> > don't group) and duration_time that is never placed into a group.
> >
> > Partial sharing, with one event in 1 weak event group and 1 in another
> > is never performed. Using --metric-no-group allows something similar.
> > Given multiplexing, I'd be concerned about accuracy problems if events
> > between groups were shared - say for IPC, were you measuring
> > instructions and cycles at the same moment?
>
> hum, I think that's also concern if you are multiplexing 2 groups and one
> metric getting events from both groups that were not meassured together
>
> it makes sense to me put all the merged events into single weak group
> anything else will have the issue you described above, no?
>
> and perhaps add command line option for merging that to make sure it's
> what user actuly wants

I'm not sure I'm following. With the patch set if we have 3 metrics
with the event groups shown:
M1: {A,B,C}:W
M2: {A,B}:W
M3: {A,B,D}:W

then what happens is we sort the metrics in to M1, M3, M2 then when we
come to match the events:

 - by default: match events allowing sharing if all events come from
the same group. So in the example M1 will first match with {A,B,C}
then M3 will fail to match the group {A,B,C} but match {A,B,D}; M2
will succeed with matching {A,B} from M1. The events/group for M2 can
be removed as they are no longer used. This kind of sharing is
opportunistic and respects existing groupings. While it may mean a
metric is computed from a group that now multiplexes, that group will
run for more of the time as there are fewer groups to multiplex with.
In this example we've gone from 3 groups down to 2, 8 events down to
6. An improvement would be to realize that A,B is in both M1 and M3,
so when we print the stat we could combine these values.

 - with --metric-no-merge: no events are shared by metrics M1, M2 and
M3 have their events and computation as things currently are. There
are 3 groups and 8 events.

 - with --metric-no-group: all groups are removed and so the evlist
has A,B,C,A,B,A,B,D in it. The matching will now match M1 to A,B,C at
the beginning of the list, M2 to the first A,B and M3 to the same A,B
and D at the end of the list. We've got no groups and the events have
gone from 8 down to 4.

It is difficult to reason about which grouping is most accurate. If we
have 4 counters (no NMI watchdog) then this example will fit with no
multiplexing. The default above should achieve less multiplexing, in
the same way merging PMU events currently does - this patch is trying
to mirror the --no-merge functionality to a degree. Considering
TopDownL1 then we go from metrics that never sum to 100%, to metrics
that do in either the default or --metric-no-group cases.

I'm not sure what user option is missing with these combinations? The
default is trying to strike a compromise and I think user interaction
is unnecessary, just as --no-merge doesn't cause interaction. If the
existing behavior is wanted using --metric-no-merge will give that.
The new default and --metric-no-group are hopefully going to reduce
the number of groups and events. I'm somewhat agnostic as to what the
flag functionality should be as what I'm working with needs either the
default or --metric-no-group, I can use whatever flag is agreed upon.

Thanks,
Ian

> thanks,
> jirka
>
>
> >
> > > I was wondering if we could merge all the hasmaps into single
> > > one before the parse the evlist.. this way we won't need removing
> > > later.. but I did not thought this through completely, so it
> > > might not work at some point
> >
> > This could be done in the --metric-no-group case reasonably easily
> > like the current hashmap. For groups you'd want something like a set
> > of sets of events, but then you'd only be able to share events if the
> > sets were the same. A directed acyclic graph could capture the events
> > and the sharing relationships, it may be possible to optimize cases
> > like {A,B,C}, {A,B,D}, {A,B} so that the small group on the end shares
> > events with both the {A,B,C} and {A,B,D} group. This may be good
> > follow up work. We could also solve this in the json, for example
> > create a "phony" group of {A,B,C,D} that all three metrics share from.
> > You could also use --metric-no-group to achieve that sharing now.
> >
> > Thanks,
> > Ian
> >
> > > jirka
> > >
> >
>
