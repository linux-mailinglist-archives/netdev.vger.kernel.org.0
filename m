Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F94B136FF6
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 15:50:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728301AbgAJOuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 09:50:07 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:26549 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728056AbgAJOuG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 09:50:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578667805;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7mPPMOgg1rdT11VKLhfqGPbIrYZLHOhMvTiS0wn3BR8=;
        b=bRm1mG7siBP7cKe2Y9s3ZMyvcFOkJpfBw5B5l77k8JV2nknXf1vl+ma4EwHnHEQagu43vU
        ntWX5X3EfGckQLoxEBUZ2rTcqgKQbpqsJGAfbDSI1FrEIHrg6erbxjhInQktIrbaj+33DY
        YbbjWj/ezs+0q8vY1vVvjNWfxrHTsFw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-210-9Uet1PL0OC2VrKRfkBNolQ-1; Fri, 10 Jan 2020 09:50:01 -0500
X-MC-Unique: 9Uet1PL0OC2VrKRfkBNolQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AE0C980557E;
        Fri, 10 Jan 2020 14:49:57 +0000 (UTC)
Received: from krava (ovpn-205-164.brq.redhat.com [10.40.205.164])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EAEEF610D7;
        Fri, 10 Jan 2020 14:49:38 +0000 (UTC)
Date:   Fri, 10 Jan 2020 15:49:36 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-kernel@vger.kernel.org,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: Re: [PATCH 0/3] tracing: perf: Rename ring_buffer to perf_buffer and
 trace_buffer
Message-ID: <20200110144936.GF82989@krava>
References: <20200110020308.977313200@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200110020308.977313200@goodmis.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 09, 2020 at 09:03:08PM -0500, Steven Rostedt wrote:
> 
> As we discussed, to remove the generic structure "ring_buffer" from the kernel,
> and switch it to "perf_buffer" and "trace_buffer", this patch series does
> just that.
> 
> Anyone have any issues of me carrying this in my tree? I'll rebase it to
> v5.5-rc6 when it comes out, as it depends on some commits in v5.5-rc5.

ack ;-) and

Tested-by: Jiri Olsa <jolsa@kernel.org>

thanks,
jirka

> 
> -- Steve
> 
> Steven Rostedt (VMware) (3):
>       perf: Make struct ring_buffer less ambiguous
>       tracing: Rename trace_buffer to array_buffer
>       tracing: Make struct ring_buffer less ambiguous
> 
> ----
>  drivers/oprofile/cpu_buffer.c        |   2 +-
>  include/linux/perf_event.h           |   6 +-
>  include/linux/ring_buffer.h          | 110 ++++++-------
>  include/linux/trace_events.h         |   8 +-
>  include/trace/trace_events.h         |   2 +-
>  kernel/events/core.c                 |  42 ++---
>  kernel/events/internal.h             |  34 ++--
>  kernel/events/ring_buffer.c          |  54 +++----
>  kernel/trace/blktrace.c              |   8 +-
>  kernel/trace/ftrace.c                |   8 +-
>  kernel/trace/ring_buffer.c           | 124 +++++++--------
>  kernel/trace/ring_buffer_benchmark.c |   2 +-
>  kernel/trace/trace.c                 | 292 +++++++++++++++++------------------
>  kernel/trace/trace.h                 |  38 ++---
>  kernel/trace/trace_branch.c          |   6 +-
>  kernel/trace/trace_events.c          |  20 +--
>  kernel/trace/trace_events_hist.c     |   4 +-
>  kernel/trace/trace_functions.c       |   8 +-
>  kernel/trace/trace_functions_graph.c |  14 +-
>  kernel/trace/trace_hwlat.c           |   2 +-
>  kernel/trace/trace_irqsoff.c         |   8 +-
>  kernel/trace/trace_kdb.c             |   8 +-
>  kernel/trace/trace_kprobe.c          |   4 +-
>  kernel/trace/trace_mmiotrace.c       |  12 +-
>  kernel/trace/trace_output.c          |   2 +-
>  kernel/trace/trace_sched_wakeup.c    |  20 +--
>  kernel/trace/trace_selftest.c        |  26 ++--
>  kernel/trace/trace_syscalls.c        |   8 +-
>  kernel/trace/trace_uprobe.c          |   2 +-
>  29 files changed, 437 insertions(+), 437 deletions(-)
> 

