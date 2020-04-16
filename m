Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34DA01AD0E1
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 22:12:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728111AbgDPUKl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 16:10:41 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:58069 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727898AbgDPUKk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 16:10:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587067838;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+qvuVM962jw7kYq4Y9qfz/NOtli8L6Q3Rt5E3jbPz28=;
        b=e8fKabtcpPVL8Y3EPrtrSDMOFazOrgIkwg4koFpnRs23fgrNB/FtwYAwh8+0IFoHgRv2vo
        ednvrpUQGdB3NUYndcfuTTQUuaIiuDmeODYBVc7AScDFdlzLn0etbtIBfoLGZq5j2gdW7b
        gEgv1cONgWpeChvfB+cW6vEFL1COM/U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-197-xmXwcOAlMReTy_QwXm77Gg-1; Thu, 16 Apr 2020 16:10:31 -0400
X-MC-Unique: xmXwcOAlMReTy_QwXm77Gg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 16FC718CA243;
        Thu, 16 Apr 2020 20:10:27 +0000 (UTC)
Received: from krava (unknown [10.40.195.119])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8414E99DEE;
        Thu, 16 Apr 2020 20:10:15 +0000 (UTC)
Date:   Thu, 16 Apr 2020 22:10:11 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Ian Rogers <irogers@google.com>
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
        bpf@vger.kernel.org,
        linux-perf-users <linux-perf-users@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH v9 4/4] perf tools: add support for libpfm4
Message-ID: <20200416201011.GB414900@krava>
References: <20200416063551.47637-1-irogers@google.com>
 <20200416063551.47637-5-irogers@google.com>
 <20200416095501.GC369437@krava>
 <CAP-5=fVOb1nV2gdGGWLQvTApoMR=qzaSQHSwxsAKAXQ=wqQV+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAP-5=fVOb1nV2gdGGWLQvTApoMR=qzaSQHSwxsAKAXQ=wqQV+g@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 16, 2020 at 09:02:54AM -0700, Ian Rogers wrote:
> On Thu, Apr 16, 2020 at 2:55 AM Jiri Olsa <jolsa@redhat.com> wrote:
> >
> > On Wed, Apr 15, 2020 at 11:35:51PM -0700, Ian Rogers wrote:
> > > From: Stephane Eranian <eranian@google.com>
> > >
> > > This patch links perf with the libpfm4 library if it is available
> > > and NO_LIBPFM4 isn't passed to the build. The libpfm4 library
> > > contains hardware event tables for all processors supported by
> > > perf_events. It is a helper library that helps convert from a
> > > symbolic event name to the event encoding required by the
> > > underlying kernel interface. This library is open-source and
> > > available from: http://perfmon2.sf.net.
> > >
> > > With this patch, it is possible to specify full hardware events
> > > by name. Hardware filters are also supported. Events must be
> > > specified via the --pfm-events and not -e option. Both options
> > > are active at the same time and it is possible to mix and match:
> > >
> > > $ perf stat --pfm-events inst_retired:any_p:c=1:i -e cycles ....
> > >
> > > Signed-off-by: Stephane Eranian <eranian@google.com>
> > > Reviewed-by: Ian Rogers <irogers@google.com>
> >
> >         # perf list
> >         ...
> >         perf_raw pfm-events
> >           r0000
> >             [perf_events raw event syntax: r[0-9a-fA-F]+]
> >
> >         skl pfm-events
> >           UNHALTED_CORE_CYCLES
> >             [Count core clock cycles whenever the clock signal on the specific core is running (not halted)]
> >           UNHALTED_REFERENCE_CYCLES
> >
> > please add ':' behind the '* pfm-events' label
> 
> Thanks! Not sure I follow here. skl here is the pmu. pfm-events is
> here just to make it clearer these are --pfm-events. The event is
> selected with '--pfm-events UNHALTED_CORE_CYCLES'. Will putting
> skl:pfm-events here make it look like that is part of the event
> encoding?

aah I might have misunderstood the output here then, we have preceeding
output like:

cache:
  l1d.replacement                                   
       [L1D data line replacements]

so I thought the 'skl pfm-events' is just a label


how about we use the first current label in the middle like:

	# perf list
	List of pre-defined events (to be used in -e):

	  current events stuff

	List of pfm events (to be used in --pfm-xxx):

	  pfm events stuff

or maybe put it under 'perf list --pfm', thoughts?

jirka

