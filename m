Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B58F1DCC50
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 13:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729137AbgEULnk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 07:43:40 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:22692 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729089AbgEULnk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 07:43:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590061419;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ttU7JtT4mKmdr4XaUlZUh0aIyxlnlTBW6EDoHbcH2pA=;
        b=SyVYQSfyx/L04v0au7evRZSVkSB1w10BsS7xpQRZiUjmLZhUe6+XUjQXzcM94h0K5gebm2
        llql2ItyRpw72qe0cLL7xF/IRV21fmGja+f3ydfhq+Vq5PkhPBepE0ErAV6nPezLqp+8rD
        EbbwVvlzwB7DWL7Njt6Hxj+j5wSBCs4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-182-7lJ8VI4JOqiE4HJAsjrIEw-1; Thu, 21 May 2020 07:43:34 -0400
X-MC-Unique: 7lJ8VI4JOqiE4HJAsjrIEw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 04A14A0C03;
        Thu, 21 May 2020 11:43:31 +0000 (UTC)
Received: from krava (unknown [10.40.195.217])
        by smtp.corp.redhat.com (Postfix) with SMTP id 3FC8F5C1B0;
        Thu, 21 May 2020 11:43:26 +0000 (UTC)
Date:   Thu, 21 May 2020 13:43:25 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Ian Rogers <irogers@google.com>
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
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-perf-users@vger.kernel.org,
        Vince Weaver <vincent.weaver@maine.edu>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH v2 0/7] Share events between metrics
Message-ID: <20200521114325.GT157452@krava>
References: <20200520182011.32236-1-irogers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200520182011.32236-1-irogers@google.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 20, 2020 at 11:20:04AM -0700, Ian Rogers wrote:

SNIP

> There are 5 out of 12 metric groups where no events are shared, such
> as Power, however, disabling grouping of events always reduces the
> number of events.
> 
> The result for Memory_BW needs explanation:
> 
> Metric group: Memory_BW
>  - No merging (old default, now --metric-no-merge): 9
>  - Merging over metrics (new default)             : 5
>  - No event groups and merging (--metric-no-group): 11
> 
> Both with and without merging the groups fail to be set up and so the
> event counts here are for broken metrics. The --metric-no-group number
> is accurate as all the events are scheduled. Ideally a constraint
> would be added for these metrics in the json code to avoid grouping.
> 
> v2. rebases on kernel/git/acme/linux.git branch tmp.perf/core, fixes a
> missing comma with metric lists (reported-by Jiri Olsa
> <jolsa@redhat.com>) and adds early returns to metricgroup__add_metric
> (suggested-by Jiri Olsa).

Acked-by: Jiri Olsa <jolsa@redhat.com>

thanks,
jirka

> 
> v1. was prepared on kernel/git/acme/linux.git branch tmp.perf/core
> 
> Compared to RFC v3: fix a bug where unnecessary commas were passed to
> parse-events and were echoed. Fix a bug where the same event could be
> matched more than once with --metric-no-group, causing there to be
> events missing.
> https://lore.kernel.org/lkml/20200508053629.210324-1-irogers@google.com/
> 
> Ian Rogers (7):
>   perf metricgroup: Always place duration_time last
>   perf metricgroup: Use early return in add_metric
>   perf metricgroup: Delay events string creation
>   perf metricgroup: Order event groups by size
>   perf metricgroup: Remove duped metric group events
>   perf metricgroup: Add options to not group or merge
>   perf metricgroup: Remove unnecessary ',' from events
> 
>  tools/perf/Documentation/perf-stat.txt |  19 ++
>  tools/perf/builtin-stat.c              |  11 +-
>  tools/perf/util/metricgroup.c          | 239 ++++++++++++++++++-------
>  tools/perf/util/metricgroup.h          |   6 +-
>  tools/perf/util/stat.h                 |   2 +
>  5 files changed, 207 insertions(+), 70 deletions(-)
> 
> -- 
> 2.26.2.761.g0e0b3e54be-goog
> 

