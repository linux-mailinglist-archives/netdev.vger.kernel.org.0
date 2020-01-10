Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83750136534
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 03:05:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730712AbgAJCFL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 21:05:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:60938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730359AbgAJCFL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jan 2020 21:05:11 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1817C20678;
        Fri, 10 Jan 2020 02:05:11 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.92.3)
        (envelope-from <rostedt@goodmis.org>)
        id 1ipjfh-000Yuq-Ua; Thu, 09 Jan 2020 21:05:09 -0500
Message-Id: <20200110020308.977313200@goodmis.org>
User-Agent: quilt/0.65
Date:   Thu, 09 Jan 2020 21:03:08 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Jiri Olsa <jolsa@redhat.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
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
Subject: [PATCH 0/3] tracing: perf: Rename ring_buffer to perf_buffer and trace_buffer
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


As we discussed, to remove the generic structure "ring_buffer" from the kernel,
and switch it to "perf_buffer" and "trace_buffer", this patch series does
just that.

Anyone have any issues of me carrying this in my tree? I'll rebase it to
v5.5-rc6 when it comes out, as it depends on some commits in v5.5-rc5.

-- Steve

Steven Rostedt (VMware) (3):
      perf: Make struct ring_buffer less ambiguous
      tracing: Rename trace_buffer to array_buffer
      tracing: Make struct ring_buffer less ambiguous

----
 drivers/oprofile/cpu_buffer.c        |   2 +-
 include/linux/perf_event.h           |   6 +-
 include/linux/ring_buffer.h          | 110 ++++++-------
 include/linux/trace_events.h         |   8 +-
 include/trace/trace_events.h         |   2 +-
 kernel/events/core.c                 |  42 ++---
 kernel/events/internal.h             |  34 ++--
 kernel/events/ring_buffer.c          |  54 +++----
 kernel/trace/blktrace.c              |   8 +-
 kernel/trace/ftrace.c                |   8 +-
 kernel/trace/ring_buffer.c           | 124 +++++++--------
 kernel/trace/ring_buffer_benchmark.c |   2 +-
 kernel/trace/trace.c                 | 292 +++++++++++++++++------------------
 kernel/trace/trace.h                 |  38 ++---
 kernel/trace/trace_branch.c          |   6 +-
 kernel/trace/trace_events.c          |  20 +--
 kernel/trace/trace_events_hist.c     |   4 +-
 kernel/trace/trace_functions.c       |   8 +-
 kernel/trace/trace_functions_graph.c |  14 +-
 kernel/trace/trace_hwlat.c           |   2 +-
 kernel/trace/trace_irqsoff.c         |   8 +-
 kernel/trace/trace_kdb.c             |   8 +-
 kernel/trace/trace_kprobe.c          |   4 +-
 kernel/trace/trace_mmiotrace.c       |  12 +-
 kernel/trace/trace_output.c          |   2 +-
 kernel/trace/trace_sched_wakeup.c    |  20 +--
 kernel/trace/trace_selftest.c        |  26 ++--
 kernel/trace/trace_syscalls.c        |   8 +-
 kernel/trace/trace_uprobe.c          |   2 +-
 29 files changed, 437 insertions(+), 437 deletions(-)
