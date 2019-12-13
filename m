Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6E4E11EAEB
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 20:05:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728817AbfLMTFi convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 13 Dec 2019 14:05:38 -0500
Received: from smtprelay0069.hostedemail.com ([216.40.44.69]:38744 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728552AbfLMTFi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 14:05:38 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay08.hostedemail.com (Postfix) with ESMTP id 55395182CED2A;
        Fri, 13 Dec 2019 19:05:35 +0000 (UTC)
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::::::::::::::::::::::::::::::,RULES_HIT:69:355:371:372:379:541:599:960:966:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1513:1515:1516:1518:1521:1593:1594:1605:1730:1747:1777:1792:1981:2194:2196:2199:2200:2393:2559:2562:2689:2693:2899:2914:3138:3139:3140:3141:3142:3165:3503:3504:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4250:4321:4384:4385:4395:4560:4605:5007:6261:6742:7576:7875:7903:8603:8660:9038:9545:9592:10848:10967:11026:11232:11914:12043:12262:12294:12296:12297:12438:12555:12679:12740:12895:12986:13148:13161:13229:13230:13439:13972:14096:14097:14659:21080:21324:21433:21451:21611:21627:21740:21966:21987:21990:30034:30045:30051:30054:30056:30070:30075:30080:30083:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:1:0,LFtime:2,LUA_SUMMARY:none
X-HE-Tag: title31_87b76f816b461
X-Filterd-Recvd-Size: 60261
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (Authenticated sender: nevets@goodmis.org)
        by omf19.hostedemail.com (Postfix) with ESMTPA;
        Fri, 13 Dec 2019 19:05:32 +0000 (UTC)
Date:   Fri, 13 Dec 2019 14:05:31 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
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
Subject: Re: [RFC] btf: Some structs are doubled because of struct
 ring_buffer
Message-ID: <20191213140531.116b3200@gandalf.local.home>
In-Reply-To: <20191213140349.5a42a8af@gandalf.local.home>
References: <20191213153553.GE20583@krava>
        <20191213112438.773dff35@gandalf.local.home>
        <20191213165155.vimm27wo7brkh3yu@ast-mbp.dhcp.thefacebook.com>
        <20191213121118.236f55b8@gandalf.local.home>
        <20191213180223.GE2844@hirez.programming.kicks-ass.net>
        <20191213132941.6fa2d1bd@gandalf.local.home>
        <20191213184621.GG2844@hirez.programming.kicks-ass.net>
        <20191213140349.5a42a8af@gandalf.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Dec 2019 14:03:49 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Fri, 13 Dec 2019 19:46:21 +0100
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > >   perf_buffer and trace_buffer ?    
> > 
> > That's what I just proposed, right? So ACK on that ;-)  
> 
> Anyway, here's v2, followed by the tracing one,

And here's the one for tracing. If you want to take the first patch (I
can send it again as a proper stand alone patch), then I'll take this
one.

-- Steve

From 81bc7202413e3194f035562054c6947984010711 Mon Sep 17 00:00:00 2001
From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Date: Fri, 13 Dec 2019 13:58:57 -0500
Subject: [PATCH] tracing: Make struct ring_buffer less ambiguous

As there's two struct ring_buffers in the kernel, it causes some confusion.
The other one being the perf ring buffer. It was agreed upon that as neither
of the ring buffers are generic enough to be used globally, they should be
renamed as:

   perf's ring_buffer -> perf_buffer
   ftrace's ring_buffer -> trace_buffer

This implements the changes to the ring buffer that ftrace uses.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 drivers/oprofile/cpu_buffer.c        |   2 +-
 include/linux/ring_buffer.h          | 110 ++++++++++++------------
 include/linux/trace_events.h         |   4 +-
 include/trace/trace_events.h         |   2 +-
 kernel/trace/blktrace.c              |   4 +-
 kernel/trace/ring_buffer.c           | 124 +++++++++++++--------------
 kernel/trace/ring_buffer_benchmark.c |   2 +-
 kernel/trace/trace.c                 |  70 +++++++--------
 kernel/trace/trace.h                 |  22 ++---
 kernel/trace/trace_branch.c          |   2 +-
 kernel/trace/trace_events.c          |   2 +-
 kernel/trace/trace_events_hist.c     |   2 +-
 kernel/trace/trace_functions_graph.c |   4 +-
 kernel/trace/trace_hwlat.c           |   2 +-
 kernel/trace/trace_kprobe.c          |   4 +-
 kernel/trace/trace_mmiotrace.c       |   4 +-
 kernel/trace/trace_sched_wakeup.c    |   4 +-
 kernel/trace/trace_syscalls.c        |   4 +-
 kernel/trace/trace_uprobe.c          |   2 +-
 19 files changed, 185 insertions(+), 185 deletions(-)

diff --git a/drivers/oprofile/cpu_buffer.c b/drivers/oprofile/cpu_buffer.c
index eda2633a393d..9210a95cb4e6 100644
--- a/drivers/oprofile/cpu_buffer.c
+++ b/drivers/oprofile/cpu_buffer.c
@@ -32,7 +32,7 @@
 
 #define OP_BUFFER_FLAGS	0
 
-static struct ring_buffer *op_ring_buffer;
+static struct trace_buffer *op_ring_buffer;
 DEFINE_PER_CPU(struct oprofile_cpu_buffer, op_cpu_buffer);
 
 static void wq_sync_buffer(struct work_struct *work);
diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
index 1a40277b512c..df0124eabece 100644
--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -6,7 +6,7 @@
 #include <linux/seq_file.h>
 #include <linux/poll.h>
 
-struct ring_buffer;
+struct trace_buffer;
 struct ring_buffer_iter;
 
 /*
@@ -77,13 +77,13 @@ u64 ring_buffer_event_time_stamp(struct ring_buffer_event *event);
  *  else
  *    ring_buffer_unlock_commit(buffer, event);
  */
-void ring_buffer_discard_commit(struct ring_buffer *buffer,
+void ring_buffer_discard_commit(struct trace_buffer *buffer,
 				struct ring_buffer_event *event);
 
 /*
  * size is in bytes for each per CPU buffer.
  */
-struct ring_buffer *
+struct trace_buffer *
 __ring_buffer_alloc(unsigned long size, unsigned flags, struct lock_class_key *key);
 
 /*
@@ -97,38 +97,38 @@ __ring_buffer_alloc(unsigned long size, unsigned flags, struct lock_class_key *k
 	__ring_buffer_alloc((size), (flags), &__key);	\
 })
 
-int ring_buffer_wait(struct ring_buffer *buffer, int cpu, int full);
-__poll_t ring_buffer_poll_wait(struct ring_buffer *buffer, int cpu,
+int ring_buffer_wait(struct trace_buffer *buffer, int cpu, int full);
+__poll_t ring_buffer_poll_wait(struct trace_buffer *buffer, int cpu,
 			  struct file *filp, poll_table *poll_table);
 
 
 #define RING_BUFFER_ALL_CPUS -1
 
-void ring_buffer_free(struct ring_buffer *buffer);
+void ring_buffer_free(struct trace_buffer *buffer);
 
-int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size, int cpu);
+int ring_buffer_resize(struct trace_buffer *buffer, unsigned long size, int cpu);
 
-void ring_buffer_change_overwrite(struct ring_buffer *buffer, int val);
+void ring_buffer_change_overwrite(struct trace_buffer *buffer, int val);
 
-struct ring_buffer_event *ring_buffer_lock_reserve(struct ring_buffer *buffer,
+struct ring_buffer_event *ring_buffer_lock_reserve(struct trace_buffer *buffer,
 						   unsigned long length);
-int ring_buffer_unlock_commit(struct ring_buffer *buffer,
+int ring_buffer_unlock_commit(struct trace_buffer *buffer,
 			      struct ring_buffer_event *event);
-int ring_buffer_write(struct ring_buffer *buffer,
+int ring_buffer_write(struct trace_buffer *buffer,
 		      unsigned long length, void *data);
 
-void ring_buffer_nest_start(struct ring_buffer *buffer);
-void ring_buffer_nest_end(struct ring_buffer *buffer);
+void ring_buffer_nest_start(struct trace_buffer *buffer);
+void ring_buffer_nest_end(struct trace_buffer *buffer);
 
 struct ring_buffer_event *
-ring_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts,
+ring_buffer_peek(struct trace_buffer *buffer, int cpu, u64 *ts,
 		 unsigned long *lost_events);
 struct ring_buffer_event *
-ring_buffer_consume(struct ring_buffer *buffer, int cpu, u64 *ts,
+ring_buffer_consume(struct trace_buffer *buffer, int cpu, u64 *ts,
 		    unsigned long *lost_events);
 
 struct ring_buffer_iter *
-ring_buffer_read_prepare(struct ring_buffer *buffer, int cpu, gfp_t flags);
+ring_buffer_read_prepare(struct trace_buffer *buffer, int cpu, gfp_t flags);
 void ring_buffer_read_prepare_sync(void);
 void ring_buffer_read_start(struct ring_buffer_iter *iter);
 void ring_buffer_read_finish(struct ring_buffer_iter *iter);
@@ -140,59 +140,59 @@ ring_buffer_read(struct ring_buffer_iter *iter, u64 *ts);
 void ring_buffer_iter_reset(struct ring_buffer_iter *iter);
 int ring_buffer_iter_empty(struct ring_buffer_iter *iter);
 
-unsigned long ring_buffer_size(struct ring_buffer *buffer, int cpu);
+unsigned long ring_buffer_size(struct trace_buffer *buffer, int cpu);
 
-void ring_buffer_reset_cpu(struct ring_buffer *buffer, int cpu);
-void ring_buffer_reset(struct ring_buffer *buffer);
+void ring_buffer_reset_cpu(struct trace_buffer *buffer, int cpu);
+void ring_buffer_reset(struct trace_buffer *buffer);
 
 #ifdef CONFIG_RING_BUFFER_ALLOW_SWAP
-int ring_buffer_swap_cpu(struct ring_buffer *buffer_a,
-			 struct ring_buffer *buffer_b, int cpu);
+int ring_buffer_swap_cpu(struct trace_buffer *buffer_a,
+			 struct trace_buffer *buffer_b, int cpu);
 #else
 static inline int
-ring_buffer_swap_cpu(struct ring_buffer *buffer_a,
-		     struct ring_buffer *buffer_b, int cpu)
+ring_buffer_swap_cpu(struct trace_buffer *buffer_a,
+		     struct trace_buffer *buffer_b, int cpu)
 {
 	return -ENODEV;
 }
 #endif
 
-bool ring_buffer_empty(struct ring_buffer *buffer);
-bool ring_buffer_empty_cpu(struct ring_buffer *buffer, int cpu);
-
-void ring_buffer_record_disable(struct ring_buffer *buffer);
-void ring_buffer_record_enable(struct ring_buffer *buffer);
-void ring_buffer_record_off(struct ring_buffer *buffer);
-void ring_buffer_record_on(struct ring_buffer *buffer);
-bool ring_buffer_record_is_on(struct ring_buffer *buffer);
-bool ring_buffer_record_is_set_on(struct ring_buffer *buffer);
-void ring_buffer_record_disable_cpu(struct ring_buffer *buffer, int cpu);
-void ring_buffer_record_enable_cpu(struct ring_buffer *buffer, int cpu);
-
-u64 ring_buffer_oldest_event_ts(struct ring_buffer *buffer, int cpu);
-unsigned long ring_buffer_bytes_cpu(struct ring_buffer *buffer, int cpu);
-unsigned long ring_buffer_entries(struct ring_buffer *buffer);
-unsigned long ring_buffer_overruns(struct ring_buffer *buffer);
-unsigned long ring_buffer_entries_cpu(struct ring_buffer *buffer, int cpu);
-unsigned long ring_buffer_overrun_cpu(struct ring_buffer *buffer, int cpu);
-unsigned long ring_buffer_commit_overrun_cpu(struct ring_buffer *buffer, int cpu);
-unsigned long ring_buffer_dropped_events_cpu(struct ring_buffer *buffer, int cpu);
-unsigned long ring_buffer_read_events_cpu(struct ring_buffer *buffer, int cpu);
-
-u64 ring_buffer_time_stamp(struct ring_buffer *buffer, int cpu);
-void ring_buffer_normalize_time_stamp(struct ring_buffer *buffer,
+bool ring_buffer_empty(struct trace_buffer *buffer);
+bool ring_buffer_empty_cpu(struct trace_buffer *buffer, int cpu);
+
+void ring_buffer_record_disable(struct trace_buffer *buffer);
+void ring_buffer_record_enable(struct trace_buffer *buffer);
+void ring_buffer_record_off(struct trace_buffer *buffer);
+void ring_buffer_record_on(struct trace_buffer *buffer);
+bool ring_buffer_record_is_on(struct trace_buffer *buffer);
+bool ring_buffer_record_is_set_on(struct trace_buffer *buffer);
+void ring_buffer_record_disable_cpu(struct trace_buffer *buffer, int cpu);
+void ring_buffer_record_enable_cpu(struct trace_buffer *buffer, int cpu);
+
+u64 ring_buffer_oldest_event_ts(struct trace_buffer *buffer, int cpu);
+unsigned long ring_buffer_bytes_cpu(struct trace_buffer *buffer, int cpu);
+unsigned long ring_buffer_entries(struct trace_buffer *buffer);
+unsigned long ring_buffer_overruns(struct trace_buffer *buffer);
+unsigned long ring_buffer_entries_cpu(struct trace_buffer *buffer, int cpu);
+unsigned long ring_buffer_overrun_cpu(struct trace_buffer *buffer, int cpu);
+unsigned long ring_buffer_commit_overrun_cpu(struct trace_buffer *buffer, int cpu);
+unsigned long ring_buffer_dropped_events_cpu(struct trace_buffer *buffer, int cpu);
+unsigned long ring_buffer_read_events_cpu(struct trace_buffer *buffer, int cpu);
+
+u64 ring_buffer_time_stamp(struct trace_buffer *buffer, int cpu);
+void ring_buffer_normalize_time_stamp(struct trace_buffer *buffer,
 				      int cpu, u64 *ts);
-void ring_buffer_set_clock(struct ring_buffer *buffer,
+void ring_buffer_set_clock(struct trace_buffer *buffer,
 			   u64 (*clock)(void));
-void ring_buffer_set_time_stamp_abs(struct ring_buffer *buffer, bool abs);
-bool ring_buffer_time_stamp_abs(struct ring_buffer *buffer);
+void ring_buffer_set_time_stamp_abs(struct trace_buffer *buffer, bool abs);
+bool ring_buffer_time_stamp_abs(struct trace_buffer *buffer);
 
-size_t ring_buffer_nr_pages(struct ring_buffer *buffer, int cpu);
-size_t ring_buffer_nr_dirty_pages(struct ring_buffer *buffer, int cpu);
+size_t ring_buffer_nr_pages(struct trace_buffer *buffer, int cpu);
+size_t ring_buffer_nr_dirty_pages(struct trace_buffer *buffer, int cpu);
 
-void *ring_buffer_alloc_read_page(struct ring_buffer *buffer, int cpu);
-void ring_buffer_free_read_page(struct ring_buffer *buffer, int cpu, void *data);
-int ring_buffer_read_page(struct ring_buffer *buffer, void **data_page,
+void *ring_buffer_alloc_read_page(struct trace_buffer *buffer, int cpu);
+void ring_buffer_free_read_page(struct trace_buffer *buffer, int cpu, void *data);
+int ring_buffer_read_page(struct trace_buffer *buffer, void **data_page,
 			  size_t len, int cpu, int full);
 
 struct trace_seq;
diff --git a/include/linux/trace_events.h b/include/linux/trace_events.h
index 4c6e15605766..f20ce342400f 100644
--- a/include/linux/trace_events.h
+++ b/include/linux/trace_events.h
@@ -153,7 +153,7 @@ void tracing_generic_entry_update(struct trace_entry *entry,
 struct trace_event_file;
 
 struct ring_buffer_event *
-trace_event_buffer_lock_reserve(struct ring_buffer **current_buffer,
+trace_event_buffer_lock_reserve(struct trace_buffer **current_buffer,
 				struct trace_event_file *trace_file,
 				int type, unsigned long len,
 				unsigned long flags, int pc);
@@ -210,7 +210,7 @@ extern int trace_event_reg(struct trace_event_call *event,
 			    enum trace_reg type, void *data);
 
 struct trace_event_buffer {
-	struct ring_buffer		*buffer;
+	struct trace_buffer		*buffer;
 	struct ring_buffer_event	*event;
 	struct trace_event_file		*trace_file;
 	void				*entry;
diff --git a/include/trace/trace_events.h b/include/trace/trace_events.h
index 472b33d23a10..13a58d453992 100644
--- a/include/trace/trace_events.h
+++ b/include/trace/trace_events.h
@@ -570,7 +570,7 @@ static inline notrace int trace_event_get_offsets_##call(		\
  *	enum event_trigger_type __tt = ETT_NONE;
  *	struct ring_buffer_event *event;
  *	struct trace_event_raw_<call> *entry; <-- defined in stage 1
- *	struct ring_buffer *buffer;
+ *	struct trace_buffer *buffer;
  *	unsigned long irq_flags;
  *	int __data_size;
  *	int pc;
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 2d6e93ab0478..4ee9b78b87cc 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -69,7 +69,7 @@ static void trace_note(struct blk_trace *bt, pid_t pid, int action,
 {
 	struct blk_io_trace *t;
 	struct ring_buffer_event *event = NULL;
-	struct ring_buffer *buffer = NULL;
+	struct trace_buffer *buffer = NULL;
 	int pc = 0;
 	int cpu = smp_processor_id();
 	bool blk_tracer = blk_tracer_enabled;
@@ -216,7 +216,7 @@ static void __blk_add_trace(struct blk_trace *bt, sector_t sector, int bytes,
 {
 	struct task_struct *tsk = current;
 	struct ring_buffer_event *event = NULL;
-	struct ring_buffer *buffer = NULL;
+	struct trace_buffer *buffer = NULL;
 	struct blk_io_trace *t;
 	unsigned long flags = 0;
 	unsigned long *sequence;
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 4bf050fcfe3b..c64360b53f65 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -443,7 +443,7 @@ enum {
 struct ring_buffer_per_cpu {
 	int				cpu;
 	atomic_t			record_disabled;
-	struct ring_buffer		*buffer;
+	struct trace_buffer	*buffer;
 	raw_spinlock_t			reader_lock;	/* serialize readers */
 	arch_spinlock_t			lock;
 	struct lock_class_key		lock_key;
@@ -482,7 +482,7 @@ struct ring_buffer_per_cpu {
 	struct rb_irq_work		irq_work;
 };
 
-struct ring_buffer {
+struct trace_buffer {
 	unsigned			flags;
 	int				cpus;
 	atomic_t			record_disabled;
@@ -518,7 +518,7 @@ struct ring_buffer_iter {
  *
  * Returns the number of pages used by a per_cpu buffer of the ring buffer.
  */
-size_t ring_buffer_nr_pages(struct ring_buffer *buffer, int cpu)
+size_t ring_buffer_nr_pages(struct trace_buffer *buffer, int cpu)
 {
 	return buffer->buffers[cpu]->nr_pages;
 }
@@ -530,7 +530,7 @@ size_t ring_buffer_nr_pages(struct ring_buffer *buffer, int cpu)
  *
  * Returns the number of pages that have content in the ring buffer.
  */
-size_t ring_buffer_nr_dirty_pages(struct ring_buffer *buffer, int cpu)
+size_t ring_buffer_nr_dirty_pages(struct trace_buffer *buffer, int cpu)
 {
 	size_t read;
 	size_t cnt;
@@ -573,7 +573,7 @@ static void rb_wake_up_waiters(struct irq_work *work)
  * as data is added to any of the @buffer's cpu buffers. Otherwise
  * it will wait for data to be added to a specific cpu buffer.
  */
-int ring_buffer_wait(struct ring_buffer *buffer, int cpu, int full)
+int ring_buffer_wait(struct trace_buffer *buffer, int cpu, int full)
 {
 	struct ring_buffer_per_cpu *uninitialized_var(cpu_buffer);
 	DEFINE_WAIT(wait);
@@ -684,7 +684,7 @@ int ring_buffer_wait(struct ring_buffer *buffer, int cpu, int full)
  * Returns EPOLLIN | EPOLLRDNORM if data exists in the buffers,
  * zero otherwise.
  */
-__poll_t ring_buffer_poll_wait(struct ring_buffer *buffer, int cpu,
+__poll_t ring_buffer_poll_wait(struct trace_buffer *buffer, int cpu,
 			  struct file *filp, poll_table *poll_table)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
@@ -742,13 +742,13 @@ __poll_t ring_buffer_poll_wait(struct ring_buffer *buffer, int cpu,
 /* Up this if you want to test the TIME_EXTENTS and normalization */
 #define DEBUG_SHIFT 0
 
-static inline u64 rb_time_stamp(struct ring_buffer *buffer)
+static inline u64 rb_time_stamp(struct trace_buffer *buffer)
 {
 	/* shift to debug/test normalization and TIME_EXTENTS */
 	return buffer->clock() << DEBUG_SHIFT;
 }
 
-u64 ring_buffer_time_stamp(struct ring_buffer *buffer, int cpu)
+u64 ring_buffer_time_stamp(struct trace_buffer *buffer, int cpu)
 {
 	u64 time;
 
@@ -760,7 +760,7 @@ u64 ring_buffer_time_stamp(struct ring_buffer *buffer, int cpu)
 }
 EXPORT_SYMBOL_GPL(ring_buffer_time_stamp);
 
-void ring_buffer_normalize_time_stamp(struct ring_buffer *buffer,
+void ring_buffer_normalize_time_stamp(struct trace_buffer *buffer,
 				      int cpu, u64 *ts)
 {
 	/* Just stupid testing the normalize function and deltas */
@@ -1283,7 +1283,7 @@ static int rb_allocate_pages(struct ring_buffer_per_cpu *cpu_buffer,
 }
 
 static struct ring_buffer_per_cpu *
-rb_allocate_cpu_buffer(struct ring_buffer *buffer, long nr_pages, int cpu)
+rb_allocate_cpu_buffer(struct trace_buffer *buffer, long nr_pages, int cpu)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
 	struct buffer_page *bpage;
@@ -1374,10 +1374,10 @@ static void rb_free_cpu_buffer(struct ring_buffer_per_cpu *cpu_buffer)
  * when the buffer wraps. If this flag is not set, the buffer will
  * drop data when the tail hits the head.
  */
-struct ring_buffer *__ring_buffer_alloc(unsigned long size, unsigned flags,
+struct trace_buffer *__ring_buffer_alloc(unsigned long size, unsigned flags,
 					struct lock_class_key *key)
 {
-	struct ring_buffer *buffer;
+	struct trace_buffer *buffer;
 	long nr_pages;
 	int bsize;
 	int cpu;
@@ -1447,7 +1447,7 @@ EXPORT_SYMBOL_GPL(__ring_buffer_alloc);
  * @buffer: the buffer to free.
  */
 void
-ring_buffer_free(struct ring_buffer *buffer)
+ring_buffer_free(struct trace_buffer *buffer)
 {
 	int cpu;
 
@@ -1463,18 +1463,18 @@ ring_buffer_free(struct ring_buffer *buffer)
 }
 EXPORT_SYMBOL_GPL(ring_buffer_free);
 
-void ring_buffer_set_clock(struct ring_buffer *buffer,
+void ring_buffer_set_clock(struct trace_buffer *buffer,
 			   u64 (*clock)(void))
 {
 	buffer->clock = clock;
 }
 
-void ring_buffer_set_time_stamp_abs(struct ring_buffer *buffer, bool abs)
+void ring_buffer_set_time_stamp_abs(struct trace_buffer *buffer, bool abs)
 {
 	buffer->time_stamp_abs = abs;
 }
 
-bool ring_buffer_time_stamp_abs(struct ring_buffer *buffer)
+bool ring_buffer_time_stamp_abs(struct trace_buffer *buffer)
 {
 	return buffer->time_stamp_abs;
 }
@@ -1712,7 +1712,7 @@ static void update_pages_handler(struct work_struct *work)
  *
  * Returns 0 on success and < 0 on failure.
  */
-int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size,
+int ring_buffer_resize(struct trace_buffer *buffer, unsigned long size,
 			int cpu_id)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
@@ -1891,7 +1891,7 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size,
 }
 EXPORT_SYMBOL_GPL(ring_buffer_resize);
 
-void ring_buffer_change_overwrite(struct ring_buffer *buffer, int val)
+void ring_buffer_change_overwrite(struct trace_buffer *buffer, int val)
 {
 	mutex_lock(&buffer->mutex);
 	if (val)
@@ -2206,7 +2206,7 @@ rb_move_tail(struct ring_buffer_per_cpu *cpu_buffer,
 {
 	struct buffer_page *tail_page = info->tail_page;
 	struct buffer_page *commit_page = cpu_buffer->commit_page;
-	struct ring_buffer *buffer = cpu_buffer->buffer;
+	struct trace_buffer *buffer = cpu_buffer->buffer;
 	struct buffer_page *next_page;
 	int ret;
 
@@ -2609,7 +2609,7 @@ static void rb_commit(struct ring_buffer_per_cpu *cpu_buffer,
 }
 
 static __always_inline void
-rb_wakeups(struct ring_buffer *buffer, struct ring_buffer_per_cpu *cpu_buffer)
+rb_wakeups(struct trace_buffer *buffer, struct ring_buffer_per_cpu *cpu_buffer)
 {
 	size_t nr_pages;
 	size_t dirty;
@@ -2733,7 +2733,7 @@ trace_recursive_unlock(struct ring_buffer_per_cpu *cpu_buffer)
  * Call this function before calling another ring_buffer_lock_reserve() and
  * call ring_buffer_nest_end() after the nested ring_buffer_unlock_commit().
  */
-void ring_buffer_nest_start(struct ring_buffer *buffer)
+void ring_buffer_nest_start(struct trace_buffer *buffer)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
 	int cpu;
@@ -2753,7 +2753,7 @@ void ring_buffer_nest_start(struct ring_buffer *buffer)
  * Must be called after ring_buffer_nest_start() and after the
  * ring_buffer_unlock_commit().
  */
-void ring_buffer_nest_end(struct ring_buffer *buffer)
+void ring_buffer_nest_end(struct trace_buffer *buffer)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
 	int cpu;
@@ -2775,7 +2775,7 @@ void ring_buffer_nest_end(struct ring_buffer *buffer)
  *
  * Must be paired with ring_buffer_lock_reserve.
  */
-int ring_buffer_unlock_commit(struct ring_buffer *buffer,
+int ring_buffer_unlock_commit(struct trace_buffer *buffer,
 			      struct ring_buffer_event *event)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
@@ -2868,7 +2868,7 @@ __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
 }
 
 static __always_inline struct ring_buffer_event *
-rb_reserve_next_event(struct ring_buffer *buffer,
+rb_reserve_next_event(struct trace_buffer *buffer,
 		      struct ring_buffer_per_cpu *cpu_buffer,
 		      unsigned long length)
 {
@@ -2961,7 +2961,7 @@ rb_reserve_next_event(struct ring_buffer *buffer,
  * If NULL is returned, then nothing has been allocated or locked.
  */
 struct ring_buffer_event *
-ring_buffer_lock_reserve(struct ring_buffer *buffer, unsigned long length)
+ring_buffer_lock_reserve(struct trace_buffer *buffer, unsigned long length)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
 	struct ring_buffer_event *event;
@@ -3062,7 +3062,7 @@ rb_decrement_entry(struct ring_buffer_per_cpu *cpu_buffer,
  * If this function is called, do not call ring_buffer_unlock_commit on
  * the event.
  */
-void ring_buffer_discard_commit(struct ring_buffer *buffer,
+void ring_buffer_discard_commit(struct trace_buffer *buffer,
 				struct ring_buffer_event *event)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
@@ -3113,7 +3113,7 @@ EXPORT_SYMBOL_GPL(ring_buffer_discard_commit);
  * Note, like ring_buffer_lock_reserve, the length is the length of the data
  * and not the length of the event which would hold the header.
  */
-int ring_buffer_write(struct ring_buffer *buffer,
+int ring_buffer_write(struct trace_buffer *buffer,
 		      unsigned long length,
 		      void *data)
 {
@@ -3193,7 +3193,7 @@ static bool rb_per_cpu_empty(struct ring_buffer_per_cpu *cpu_buffer)
  *
  * The caller should call synchronize_rcu() after this.
  */
-void ring_buffer_record_disable(struct ring_buffer *buffer)
+void ring_buffer_record_disable(struct trace_buffer *buffer)
 {
 	atomic_inc(&buffer->record_disabled);
 }
@@ -3206,7 +3206,7 @@ EXPORT_SYMBOL_GPL(ring_buffer_record_disable);
  * Note, multiple disables will need the same number of enables
  * to truly enable the writing (much like preempt_disable).
  */
-void ring_buffer_record_enable(struct ring_buffer *buffer)
+void ring_buffer_record_enable(struct trace_buffer *buffer)
 {
 	atomic_dec(&buffer->record_disabled);
 }
@@ -3223,7 +3223,7 @@ EXPORT_SYMBOL_GPL(ring_buffer_record_enable);
  * it works like an on/off switch, where as the disable() version
  * must be paired with a enable().
  */
-void ring_buffer_record_off(struct ring_buffer *buffer)
+void ring_buffer_record_off(struct trace_buffer *buffer)
 {
 	unsigned int rd;
 	unsigned int new_rd;
@@ -3246,7 +3246,7 @@ EXPORT_SYMBOL_GPL(ring_buffer_record_off);
  * it works like an on/off switch, where as the enable() version
  * must be paired with a disable().
  */
-void ring_buffer_record_on(struct ring_buffer *buffer)
+void ring_buffer_record_on(struct trace_buffer *buffer)
 {
 	unsigned int rd;
 	unsigned int new_rd;
@@ -3264,7 +3264,7 @@ EXPORT_SYMBOL_GPL(ring_buffer_record_on);
  *
  * Returns true if the ring buffer is in a state that it accepts writes.
  */
-bool ring_buffer_record_is_on(struct ring_buffer *buffer)
+bool ring_buffer_record_is_on(struct trace_buffer *buffer)
 {
 	return !atomic_read(&buffer->record_disabled);
 }
@@ -3280,7 +3280,7 @@ bool ring_buffer_record_is_on(struct ring_buffer *buffer)
  * ring_buffer_record_disable(), as that is a temporary disabling of
  * the ring buffer.
  */
-bool ring_buffer_record_is_set_on(struct ring_buffer *buffer)
+bool ring_buffer_record_is_set_on(struct trace_buffer *buffer)
 {
 	return !(atomic_read(&buffer->record_disabled) & RB_BUFFER_OFF);
 }
@@ -3295,7 +3295,7 @@ bool ring_buffer_record_is_set_on(struct ring_buffer *buffer)
  *
  * The caller should call synchronize_rcu() after this.
  */
-void ring_buffer_record_disable_cpu(struct ring_buffer *buffer, int cpu)
+void ring_buffer_record_disable_cpu(struct trace_buffer *buffer, int cpu)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
 
@@ -3315,7 +3315,7 @@ EXPORT_SYMBOL_GPL(ring_buffer_record_disable_cpu);
  * Note, multiple disables will need the same number of enables
  * to truly enable the writing (much like preempt_disable).
  */
-void ring_buffer_record_enable_cpu(struct ring_buffer *buffer, int cpu)
+void ring_buffer_record_enable_cpu(struct trace_buffer *buffer, int cpu)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
 
@@ -3345,7 +3345,7 @@ rb_num_of_entries(struct ring_buffer_per_cpu *cpu_buffer)
  * @buffer: The ring buffer
  * @cpu: The per CPU buffer to read from.
  */
-u64 ring_buffer_oldest_event_ts(struct ring_buffer *buffer, int cpu)
+u64 ring_buffer_oldest_event_ts(struct trace_buffer *buffer, int cpu)
 {
 	unsigned long flags;
 	struct ring_buffer_per_cpu *cpu_buffer;
@@ -3378,7 +3378,7 @@ EXPORT_SYMBOL_GPL(ring_buffer_oldest_event_ts);
  * @buffer: The ring buffer
  * @cpu: The per CPU buffer to read from.
  */
-unsigned long ring_buffer_bytes_cpu(struct ring_buffer *buffer, int cpu)
+unsigned long ring_buffer_bytes_cpu(struct trace_buffer *buffer, int cpu)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
 	unsigned long ret;
@@ -3398,7 +3398,7 @@ EXPORT_SYMBOL_GPL(ring_buffer_bytes_cpu);
  * @buffer: The ring buffer
  * @cpu: The per CPU buffer to get the entries from.
  */
-unsigned long ring_buffer_entries_cpu(struct ring_buffer *buffer, int cpu)
+unsigned long ring_buffer_entries_cpu(struct trace_buffer *buffer, int cpu)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
 
@@ -3417,7 +3417,7 @@ EXPORT_SYMBOL_GPL(ring_buffer_entries_cpu);
  * @buffer: The ring buffer
  * @cpu: The per CPU buffer to get the number of overruns from
  */
-unsigned long ring_buffer_overrun_cpu(struct ring_buffer *buffer, int cpu)
+unsigned long ring_buffer_overrun_cpu(struct trace_buffer *buffer, int cpu)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
 	unsigned long ret;
@@ -3440,7 +3440,7 @@ EXPORT_SYMBOL_GPL(ring_buffer_overrun_cpu);
  * @cpu: The per CPU buffer to get the number of overruns from
  */
 unsigned long
-ring_buffer_commit_overrun_cpu(struct ring_buffer *buffer, int cpu)
+ring_buffer_commit_overrun_cpu(struct trace_buffer *buffer, int cpu)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
 	unsigned long ret;
@@ -3462,7 +3462,7 @@ EXPORT_SYMBOL_GPL(ring_buffer_commit_overrun_cpu);
  * @cpu: The per CPU buffer to get the number of overruns from
  */
 unsigned long
-ring_buffer_dropped_events_cpu(struct ring_buffer *buffer, int cpu)
+ring_buffer_dropped_events_cpu(struct trace_buffer *buffer, int cpu)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
 	unsigned long ret;
@@ -3483,7 +3483,7 @@ EXPORT_SYMBOL_GPL(ring_buffer_dropped_events_cpu);
  * @cpu: The per CPU buffer to get the number of events read
  */
 unsigned long
-ring_buffer_read_events_cpu(struct ring_buffer *buffer, int cpu)
+ring_buffer_read_events_cpu(struct trace_buffer *buffer, int cpu)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
 
@@ -3502,7 +3502,7 @@ EXPORT_SYMBOL_GPL(ring_buffer_read_events_cpu);
  * Returns the total number of entries in the ring buffer
  * (all CPU entries)
  */
-unsigned long ring_buffer_entries(struct ring_buffer *buffer)
+unsigned long ring_buffer_entries(struct trace_buffer *buffer)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
 	unsigned long entries = 0;
@@ -3525,7 +3525,7 @@ EXPORT_SYMBOL_GPL(ring_buffer_entries);
  * Returns the total number of overruns in the ring buffer
  * (all CPU entries)
  */
-unsigned long ring_buffer_overruns(struct ring_buffer *buffer)
+unsigned long ring_buffer_overruns(struct trace_buffer *buffer)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
 	unsigned long overruns = 0;
@@ -3949,7 +3949,7 @@ EXPORT_SYMBOL_GPL(ring_buffer_peek);
 static struct ring_buffer_event *
 rb_iter_peek(struct ring_buffer_iter *iter, u64 *ts)
 {
-	struct ring_buffer *buffer;
+	struct trace_buffer *buffer;
 	struct ring_buffer_per_cpu *cpu_buffer;
 	struct ring_buffer_event *event;
 	int nr_loops = 0;
@@ -4077,7 +4077,7 @@ rb_reader_unlock(struct ring_buffer_per_cpu *cpu_buffer, bool locked)
  * not consume the data.
  */
 struct ring_buffer_event *
-ring_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts,
+ring_buffer_peek(struct trace_buffer *buffer, int cpu, u64 *ts,
 		 unsigned long *lost_events)
 {
 	struct ring_buffer_per_cpu *cpu_buffer = buffer->buffers[cpu];
@@ -4141,7 +4141,7 @@ ring_buffer_iter_peek(struct ring_buffer_iter *iter, u64 *ts)
  * and eventually empty the ring buffer if the producer is slower.
  */
 struct ring_buffer_event *
-ring_buffer_consume(struct ring_buffer *buffer, int cpu, u64 *ts,
+ring_buffer_consume(struct trace_buffer *buffer, int cpu, u64 *ts,
 		    unsigned long *lost_events)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
@@ -4201,7 +4201,7 @@ EXPORT_SYMBOL_GPL(ring_buffer_consume);
  * This overall must be paired with ring_buffer_read_finish.
  */
 struct ring_buffer_iter *
-ring_buffer_read_prepare(struct ring_buffer *buffer, int cpu, gfp_t flags)
+ring_buffer_read_prepare(struct trace_buffer *buffer, int cpu, gfp_t flags)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
 	struct ring_buffer_iter *iter;
@@ -4332,7 +4332,7 @@ EXPORT_SYMBOL_GPL(ring_buffer_read);
  * ring_buffer_size - return the size of the ring buffer (in bytes)
  * @buffer: The ring buffer.
  */
-unsigned long ring_buffer_size(struct ring_buffer *buffer, int cpu)
+unsigned long ring_buffer_size(struct trace_buffer *buffer, int cpu)
 {
 	/*
 	 * Earlier, this method returned
@@ -4398,7 +4398,7 @@ rb_reset_cpu(struct ring_buffer_per_cpu *cpu_buffer)
  * @buffer: The ring buffer to reset a per cpu buffer of
  * @cpu: The CPU buffer to be reset
  */
-void ring_buffer_reset_cpu(struct ring_buffer *buffer, int cpu)
+void ring_buffer_reset_cpu(struct trace_buffer *buffer, int cpu)
 {
 	struct ring_buffer_per_cpu *cpu_buffer = buffer->buffers[cpu];
 	unsigned long flags;
@@ -4435,7 +4435,7 @@ EXPORT_SYMBOL_GPL(ring_buffer_reset_cpu);
  * ring_buffer_reset - reset a ring buffer
  * @buffer: The ring buffer to reset all cpu buffers
  */
-void ring_buffer_reset(struct ring_buffer *buffer)
+void ring_buffer_reset(struct trace_buffer *buffer)
 {
 	int cpu;
 
@@ -4448,7 +4448,7 @@ EXPORT_SYMBOL_GPL(ring_buffer_reset);
  * rind_buffer_empty - is the ring buffer empty?
  * @buffer: The ring buffer to test
  */
-bool ring_buffer_empty(struct ring_buffer *buffer)
+bool ring_buffer_empty(struct trace_buffer *buffer)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
 	unsigned long flags;
@@ -4478,7 +4478,7 @@ EXPORT_SYMBOL_GPL(ring_buffer_empty);
  * @buffer: The ring buffer
  * @cpu: The CPU buffer to test
  */
-bool ring_buffer_empty_cpu(struct ring_buffer *buffer, int cpu)
+bool ring_buffer_empty_cpu(struct trace_buffer *buffer, int cpu)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
 	unsigned long flags;
@@ -4510,8 +4510,8 @@ EXPORT_SYMBOL_GPL(ring_buffer_empty_cpu);
  * it is expected that the tracer handles the cpu buffer not being
  * used at the moment.
  */
-int ring_buffer_swap_cpu(struct ring_buffer *buffer_a,
-			 struct ring_buffer *buffer_b, int cpu)
+int ring_buffer_swap_cpu(struct trace_buffer *buffer_a,
+			 struct trace_buffer *buffer_b, int cpu)
 {
 	struct ring_buffer_per_cpu *cpu_buffer_a;
 	struct ring_buffer_per_cpu *cpu_buffer_b;
@@ -4590,7 +4590,7 @@ EXPORT_SYMBOL_GPL(ring_buffer_swap_cpu);
  * Returns:
  *  The page allocated, or ERR_PTR
  */
-void *ring_buffer_alloc_read_page(struct ring_buffer *buffer, int cpu)
+void *ring_buffer_alloc_read_page(struct trace_buffer *buffer, int cpu)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
 	struct buffer_data_page *bpage = NULL;
@@ -4637,7 +4637,7 @@ EXPORT_SYMBOL_GPL(ring_buffer_alloc_read_page);
  *
  * Free a page allocated from ring_buffer_alloc_read_page.
  */
-void ring_buffer_free_read_page(struct ring_buffer *buffer, int cpu, void *data)
+void ring_buffer_free_read_page(struct trace_buffer *buffer, int cpu, void *data)
 {
 	struct ring_buffer_per_cpu *cpu_buffer = buffer->buffers[cpu];
 	struct buffer_data_page *bpage = data;
@@ -4697,7 +4697,7 @@ EXPORT_SYMBOL_GPL(ring_buffer_free_read_page);
  *  >=0 if data has been transferred, returns the offset of consumed data.
  *  <0 if no data has been transferred.
  */
-int ring_buffer_read_page(struct ring_buffer *buffer,
+int ring_buffer_read_page(struct trace_buffer *buffer,
 			  void **data_page, size_t len, int cpu, int full)
 {
 	struct ring_buffer_per_cpu *cpu_buffer = buffer->buffers[cpu];
@@ -4868,12 +4868,12 @@ EXPORT_SYMBOL_GPL(ring_buffer_read_page);
  */
 int trace_rb_cpu_prepare(unsigned int cpu, struct hlist_node *node)
 {
-	struct ring_buffer *buffer;
+	struct trace_buffer *buffer;
 	long nr_pages_same;
 	int cpu_i;
 	unsigned long nr_pages;
 
-	buffer = container_of(node, struct ring_buffer, node);
+	buffer = container_of(node, struct trace_buffer, node);
 	if (cpumask_test_cpu(cpu, buffer->cpumask))
 		return 0;
 
@@ -4923,7 +4923,7 @@ int trace_rb_cpu_prepare(unsigned int cpu, struct hlist_node *node)
 static struct task_struct *rb_threads[NR_CPUS] __initdata;
 
 struct rb_test_data {
-	struct ring_buffer	*buffer;
+	struct trace_buffer *buffer;
 	unsigned long		events;
 	unsigned long		bytes_written;
 	unsigned long		bytes_alloc;
@@ -5065,7 +5065,7 @@ static __init int rb_hammer_test(void *arg)
 static __init int test_ringbuffer(void)
 {
 	struct task_struct *rb_hammer;
-	struct ring_buffer *buffer;
+	struct trace_buffer *buffer;
 	int cpu;
 	int ret = 0;
 
diff --git a/kernel/trace/ring_buffer_benchmark.c b/kernel/trace/ring_buffer_benchmark.c
index 32149e46551c..8df0aa810950 100644
--- a/kernel/trace/ring_buffer_benchmark.c
+++ b/kernel/trace/ring_buffer_benchmark.c
@@ -29,7 +29,7 @@ static int reader_finish;
 static DECLARE_COMPLETION(read_start);
 static DECLARE_COMPLETION(read_done);
 
-static struct ring_buffer *buffer;
+static struct trace_buffer *buffer;
 static struct task_struct *producer;
 static struct task_struct *consumer;
 static unsigned long read;
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 23459d53d576..37c63edc4778 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -163,7 +163,7 @@ static union trace_eval_map_item *trace_eval_maps;
 #endif /* CONFIG_TRACE_EVAL_MAP_FILE */
 
 static int tracing_set_tracer(struct trace_array *tr, const char *buf);
-static void ftrace_trace_userstack(struct ring_buffer *buffer,
+static void ftrace_trace_userstack(struct trace_buffer *buffer,
 				   unsigned long flags, int pc);
 
 #define MAX_TRACER_SIZE		100
@@ -338,7 +338,7 @@ int tracing_check_open_get_tr(struct trace_array *tr)
 }
 
 int call_filter_check_discard(struct trace_event_call *call, void *rec,
-			      struct ring_buffer *buffer,
+			      struct trace_buffer *buffer,
 			      struct ring_buffer_event *event)
 {
 	if (unlikely(call->flags & TRACE_EVENT_FL_FILTERED) &&
@@ -747,22 +747,22 @@ static inline void trace_access_lock_init(void)
 #endif
 
 #ifdef CONFIG_STACKTRACE
-static void __ftrace_trace_stack(struct ring_buffer *buffer,
+static void __ftrace_trace_stack(struct trace_buffer *buffer,
 				 unsigned long flags,
 				 int skip, int pc, struct pt_regs *regs);
 static inline void ftrace_trace_stack(struct trace_array *tr,
-				      struct ring_buffer *buffer,
+				      struct trace_buffer *buffer,
 				      unsigned long flags,
 				      int skip, int pc, struct pt_regs *regs);
 
 #else
-static inline void __ftrace_trace_stack(struct ring_buffer *buffer,
+static inline void __ftrace_trace_stack(struct trace_buffer *buffer,
 					unsigned long flags,
 					int skip, int pc, struct pt_regs *regs)
 {
 }
 static inline void ftrace_trace_stack(struct trace_array *tr,
-				      struct ring_buffer *buffer,
+				      struct trace_buffer *buffer,
 				      unsigned long flags,
 				      int skip, int pc, struct pt_regs *regs)
 {
@@ -780,7 +780,7 @@ trace_event_setup(struct ring_buffer_event *event,
 }
 
 static __always_inline struct ring_buffer_event *
-__trace_buffer_lock_reserve(struct ring_buffer *buffer,
+__trace_buffer_lock_reserve(struct trace_buffer *buffer,
 			  int type,
 			  unsigned long len,
 			  unsigned long flags, int pc)
@@ -825,7 +825,7 @@ EXPORT_SYMBOL_GPL(tracing_on);
 
 
 static __always_inline void
-__buffer_unlock_commit(struct ring_buffer *buffer, struct ring_buffer_event *event)
+__buffer_unlock_commit(struct trace_buffer *buffer, struct ring_buffer_event *event)
 {
 	__this_cpu_write(trace_taskinfo_save, true);
 
@@ -848,7 +848,7 @@ __buffer_unlock_commit(struct ring_buffer *buffer, struct ring_buffer_event *eve
 int __trace_puts(unsigned long ip, const char *str, int size)
 {
 	struct ring_buffer_event *event;
-	struct ring_buffer *buffer;
+	struct trace_buffer *buffer;
 	struct print_entry *entry;
 	unsigned long irq_flags;
 	int alloc;
@@ -898,7 +898,7 @@ EXPORT_SYMBOL_GPL(__trace_puts);
 int __trace_bputs(unsigned long ip, const char *str)
 {
 	struct ring_buffer_event *event;
-	struct ring_buffer *buffer;
+	struct trace_buffer *buffer;
 	struct bputs_entry *entry;
 	unsigned long irq_flags;
 	int size = sizeof(struct bputs_entry);
@@ -1964,7 +1964,7 @@ int __init register_tracer(struct tracer *type)
 
 static void tracing_reset_cpu(struct trace_buffer *buf, int cpu)
 {
-	struct ring_buffer *buffer = buf->buffer;
+	struct trace_buffer *buffer = buf->buffer;
 
 	if (!buffer)
 		return;
@@ -1980,7 +1980,7 @@ static void tracing_reset_cpu(struct trace_buffer *buf, int cpu)
 
 void tracing_reset_online_cpus(struct trace_buffer *buf)
 {
-	struct ring_buffer *buffer = buf->buffer;
+	struct trace_buffer *buffer = buf->buffer;
 	int cpu;
 
 	if (!buffer)
@@ -2098,7 +2098,7 @@ int is_tracing_stopped(void)
  */
 void tracing_start(void)
 {
-	struct ring_buffer *buffer;
+	struct trace_buffer *buffer;
 	unsigned long flags;
 
 	if (tracing_disabled)
@@ -2135,7 +2135,7 @@ void tracing_start(void)
 
 static void tracing_start_tr(struct trace_array *tr)
 {
-	struct ring_buffer *buffer;
+	struct trace_buffer *buffer;
 	unsigned long flags;
 
 	if (tracing_disabled)
@@ -2172,7 +2172,7 @@ static void tracing_start_tr(struct trace_array *tr)
  */
 void tracing_stop(void)
 {
-	struct ring_buffer *buffer;
+	struct trace_buffer *buffer;
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&global_trace.start_lock, flags);
@@ -2200,7 +2200,7 @@ void tracing_stop(void)
 
 static void tracing_stop_tr(struct trace_array *tr)
 {
-	struct ring_buffer *buffer;
+	struct trace_buffer *buffer;
 	unsigned long flags;
 
 	/* If global, we need to also stop the max tracer */
@@ -2442,7 +2442,7 @@ tracing_generic_entry_update(struct trace_entry *entry, unsigned short type,
 EXPORT_SYMBOL_GPL(tracing_generic_entry_update);
 
 struct ring_buffer_event *
-trace_buffer_lock_reserve(struct ring_buffer *buffer,
+trace_buffer_lock_reserve(struct trace_buffer *buffer,
 			  int type,
 			  unsigned long len,
 			  unsigned long flags, int pc)
@@ -2561,10 +2561,10 @@ void trace_buffered_event_disable(void)
 	preempt_enable();
 }
 
-static struct ring_buffer *temp_buffer;
+static struct trace_buffer *temp_buffer;
 
 struct ring_buffer_event *
-trace_event_buffer_lock_reserve(struct ring_buffer **current_rb,
+trace_event_buffer_lock_reserve(struct trace_buffer **current_rb,
 			  struct trace_event_file *trace_file,
 			  int type, unsigned long len,
 			  unsigned long flags, int pc)
@@ -2689,7 +2689,7 @@ EXPORT_SYMBOL_GPL(trace_event_buffer_commit);
 # define STACK_SKIP 3
 
 void trace_buffer_unlock_commit_regs(struct trace_array *tr,
-				     struct ring_buffer *buffer,
+				     struct trace_buffer *buffer,
 				     struct ring_buffer_event *event,
 				     unsigned long flags, int pc,
 				     struct pt_regs *regs)
@@ -2710,7 +2710,7 @@ void trace_buffer_unlock_commit_regs(struct trace_array *tr,
  * Similar to trace_buffer_unlock_commit_regs() but do not dump stack.
  */
 void
-trace_buffer_unlock_commit_nostack(struct ring_buffer *buffer,
+trace_buffer_unlock_commit_nostack(struct trace_buffer *buffer,
 				   struct ring_buffer_event *event)
 {
 	__buffer_unlock_commit(buffer, event);
@@ -2845,7 +2845,7 @@ trace_function(struct trace_array *tr,
 	       int pc)
 {
 	struct trace_event_call *call = &event_function;
-	struct ring_buffer *buffer = tr->trace_buffer.buffer;
+	struct trace_buffer *buffer = tr->trace_buffer.buffer;
 	struct ring_buffer_event *event;
 	struct ftrace_entry *entry;
 
@@ -2883,7 +2883,7 @@ struct ftrace_stacks {
 static DEFINE_PER_CPU(struct ftrace_stacks, ftrace_stacks);
 static DEFINE_PER_CPU(int, ftrace_stack_reserve);
 
-static void __ftrace_trace_stack(struct ring_buffer *buffer,
+static void __ftrace_trace_stack(struct trace_buffer *buffer,
 				 unsigned long flags,
 				 int skip, int pc, struct pt_regs *regs)
 {
@@ -2958,7 +2958,7 @@ static void __ftrace_trace_stack(struct ring_buffer *buffer,
 }
 
 static inline void ftrace_trace_stack(struct trace_array *tr,
-				      struct ring_buffer *buffer,
+				      struct trace_buffer *buffer,
 				      unsigned long flags,
 				      int skip, int pc, struct pt_regs *regs)
 {
@@ -2971,7 +2971,7 @@ static inline void ftrace_trace_stack(struct trace_array *tr,
 void __trace_stack(struct trace_array *tr, unsigned long flags, int skip,
 		   int pc)
 {
-	struct ring_buffer *buffer = tr->trace_buffer.buffer;
+	struct trace_buffer *buffer = tr->trace_buffer.buffer;
 
 	if (rcu_is_watching()) {
 		__ftrace_trace_stack(buffer, flags, skip, pc, NULL);
@@ -3018,7 +3018,7 @@ EXPORT_SYMBOL_GPL(trace_dump_stack);
 static DEFINE_PER_CPU(int, user_stack_count);
 
 static void
-ftrace_trace_userstack(struct ring_buffer *buffer, unsigned long flags, int pc)
+ftrace_trace_userstack(struct trace_buffer *buffer, unsigned long flags, int pc)
 {
 	struct trace_event_call *call = &event_user_stack;
 	struct ring_buffer_event *event;
@@ -3063,7 +3063,7 @@ ftrace_trace_userstack(struct ring_buffer *buffer, unsigned long flags, int pc)
 	preempt_enable();
 }
 #else /* CONFIG_USER_STACKTRACE_SUPPORT */
-static void ftrace_trace_userstack(struct ring_buffer *buffer,
+static void ftrace_trace_userstack(struct trace_buffer *buffer,
 				   unsigned long flags, int pc)
 {
 }
@@ -3188,7 +3188,7 @@ int trace_vbprintk(unsigned long ip, const char *fmt, va_list args)
 {
 	struct trace_event_call *call = &event_bprint;
 	struct ring_buffer_event *event;
-	struct ring_buffer *buffer;
+	struct trace_buffer *buffer;
 	struct trace_array *tr = &global_trace;
 	struct bprint_entry *entry;
 	unsigned long flags;
@@ -3245,7 +3245,7 @@ EXPORT_SYMBOL_GPL(trace_vbprintk);
 
 __printf(3, 0)
 static int
-__trace_array_vprintk(struct ring_buffer *buffer,
+__trace_array_vprintk(struct trace_buffer *buffer,
 		      unsigned long ip, const char *fmt, va_list args)
 {
 	struct trace_event_call *call = &event_print;
@@ -3326,7 +3326,7 @@ int trace_array_printk(struct trace_array *tr,
 EXPORT_SYMBOL_GPL(trace_array_printk);
 
 __printf(3, 4)
-int trace_array_printk_buf(struct ring_buffer *buffer,
+int trace_array_printk_buf(struct trace_buffer *buffer,
 			   unsigned long ip, const char *fmt, ...)
 {
 	int ret;
@@ -3382,7 +3382,7 @@ static struct trace_entry *
 __find_next_entry(struct trace_iterator *iter, int *ent_cpu,
 		  unsigned long *missing_events, u64 *ent_ts)
 {
-	struct ring_buffer *buffer = iter->trace_buffer->buffer;
+	struct trace_buffer *buffer = iter->trace_buffer->buffer;
 	struct trace_entry *ent, *next = NULL;
 	unsigned long lost_events = 0, next_lost = 0;
 	int cpu_file = iter->cpu_file;
@@ -6464,7 +6464,7 @@ tracing_mark_write(struct file *filp, const char __user *ubuf,
 	struct trace_array *tr = filp->private_data;
 	struct ring_buffer_event *event;
 	enum event_trigger_type tt = ETT_NONE;
-	struct ring_buffer *buffer;
+	struct trace_buffer *buffer;
 	struct print_entry *entry;
 	unsigned long irq_flags;
 	ssize_t written;
@@ -6544,7 +6544,7 @@ tracing_mark_raw_write(struct file *filp, const char __user *ubuf,
 {
 	struct trace_array *tr = filp->private_data;
 	struct ring_buffer_event *event;
-	struct ring_buffer *buffer;
+	struct trace_buffer *buffer;
 	struct raw_data_entry *entry;
 	unsigned long irq_flags;
 	ssize_t written;
@@ -7427,7 +7427,7 @@ static int tracing_buffers_release(struct inode *inode, struct file *file)
 }
 
 struct buffer_ref {
-	struct ring_buffer	*buffer;
+	struct trace_buffer	*buffer;
 	void			*page;
 	int			cpu;
 	refcount_t		refcount;
@@ -8264,7 +8264,7 @@ rb_simple_write(struct file *filp, const char __user *ubuf,
 		size_t cnt, loff_t *ppos)
 {
 	struct trace_array *tr = filp->private_data;
-	struct ring_buffer *buffer = tr->trace_buffer.buffer;
+	struct trace_buffer *buffer = tr->trace_buffer.buffer;
 	unsigned long val;
 	int ret;
 
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 63bf60f79398..308fcd673102 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -178,7 +178,7 @@ struct trace_option_dentry;
 
 struct trace_buffer {
 	struct trace_array		*tr;
-	struct ring_buffer		*buffer;
+	struct trace_buffer		*buffer;
 	struct trace_array_cpu __percpu	*data;
 	u64				time_start;
 	int				cpu;
@@ -705,7 +705,7 @@ struct dentry *tracing_init_dentry(void);
 struct ring_buffer_event;
 
 struct ring_buffer_event *
-trace_buffer_lock_reserve(struct ring_buffer *buffer,
+trace_buffer_lock_reserve(struct trace_buffer *buffer,
 			  int type,
 			  unsigned long len,
 			  unsigned long flags,
@@ -717,7 +717,7 @@ struct trace_entry *tracing_get_trace_entry(struct trace_array *tr,
 struct trace_entry *trace_find_next_entry(struct trace_iterator *iter,
 					  int *ent_cpu, u64 *ent_ts);
 
-void trace_buffer_unlock_commit_nostack(struct ring_buffer *buffer,
+void trace_buffer_unlock_commit_nostack(struct trace_buffer *buffer,
 					struct ring_buffer_event *event);
 
 int trace_empty(struct trace_iterator *iter);
@@ -873,7 +873,7 @@ trace_vprintk(unsigned long ip, const char *fmt, va_list args);
 extern int
 trace_array_vprintk(struct trace_array *tr,
 		    unsigned long ip, const char *fmt, va_list args);
-int trace_array_printk_buf(struct ring_buffer *buffer,
+int trace_array_printk_buf(struct trace_buffer *buffer,
 			   unsigned long ip, const char *fmt, ...);
 void trace_printk_seq(struct trace_seq *s);
 enum print_line_t print_trace_line(struct trace_iterator *iter);
@@ -1367,17 +1367,17 @@ struct trace_subsystem_dir {
 };
 
 extern int call_filter_check_discard(struct trace_event_call *call, void *rec,
-				     struct ring_buffer *buffer,
+				     struct trace_buffer *buffer,
 				     struct ring_buffer_event *event);
 
 void trace_buffer_unlock_commit_regs(struct trace_array *tr,
-				     struct ring_buffer *buffer,
+				     struct trace_buffer *buffer,
 				     struct ring_buffer_event *event,
 				     unsigned long flags, int pc,
 				     struct pt_regs *regs);
 
 static inline void trace_buffer_unlock_commit(struct trace_array *tr,
-					      struct ring_buffer *buffer,
+					      struct trace_buffer *buffer,
 					      struct ring_buffer_event *event,
 					      unsigned long flags, int pc)
 {
@@ -1390,7 +1390,7 @@ void trace_buffered_event_disable(void);
 void trace_buffered_event_enable(void);
 
 static inline void
-__trace_event_discard_commit(struct ring_buffer *buffer,
+__trace_event_discard_commit(struct trace_buffer *buffer,
 			     struct ring_buffer_event *event)
 {
 	if (this_cpu_read(trace_buffered_event) == event) {
@@ -1416,7 +1416,7 @@ __trace_event_discard_commit(struct ring_buffer *buffer,
  */
 static inline bool
 __event_trigger_test_discard(struct trace_event_file *file,
-			     struct ring_buffer *buffer,
+			     struct trace_buffer *buffer,
 			     struct ring_buffer_event *event,
 			     void *entry,
 			     enum event_trigger_type *tt)
@@ -1451,7 +1451,7 @@ __event_trigger_test_discard(struct trace_event_file *file,
  */
 static inline void
 event_trigger_unlock_commit(struct trace_event_file *file,
-			    struct ring_buffer *buffer,
+			    struct trace_buffer *buffer,
 			    struct ring_buffer_event *event,
 			    void *entry, unsigned long irq_flags, int pc)
 {
@@ -1482,7 +1482,7 @@ event_trigger_unlock_commit(struct trace_event_file *file,
  */
 static inline void
 event_trigger_unlock_commit_regs(struct trace_event_file *file,
-				 struct ring_buffer *buffer,
+				 struct trace_buffer *buffer,
 				 struct ring_buffer_event *event,
 				 void *entry, unsigned long irq_flags, int pc,
 				 struct pt_regs *regs)
diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
index 88e158d27965..b291e0422191 100644
--- a/kernel/trace/trace_branch.c
+++ b/kernel/trace/trace_branch.c
@@ -32,10 +32,10 @@ probe_likely_condition(struct ftrace_likely_data *f, int val, int expect)
 {
 	struct trace_event_call *call = &event_branch;
 	struct trace_array *tr = branch_tracer;
+	struct trace_buffer *buffer;
 	struct trace_array_cpu *data;
 	struct ring_buffer_event *event;
 	struct trace_branch *entry;
-	struct ring_buffer *buffer;
 	unsigned long flags;
 	int pc;
 	const char *p;
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index c6de3cebc127..fbf49873888d 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -3391,8 +3391,8 @@ static void __init
 function_test_events_call(unsigned long ip, unsigned long parent_ip,
 			  struct ftrace_ops *op, struct pt_regs *pt_regs)
 {
+	struct trace_buffer *buffer;
 	struct ring_buffer_event *event;
-	struct ring_buffer *buffer;
 	struct ftrace_entry *entry;
 	unsigned long flags;
 	long disabled;
diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index f49d1a36d3ae..df009a251c05 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -879,7 +879,7 @@ static notrace void trace_event_raw_event_synth(void *__data,
 	struct trace_event_file *trace_file = __data;
 	struct synth_trace_event *entry;
 	struct trace_event_buffer fbuffer;
-	struct ring_buffer *buffer;
+	struct trace_buffer *buffer;
 	struct synth_event *event;
 	unsigned int i, n_u64;
 	int fields_size = 0;
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 78af97163147..e6b9b1169a48 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -101,7 +101,7 @@ int __trace_graph_entry(struct trace_array *tr,
 {
 	struct trace_event_call *call = &event_funcgraph_entry;
 	struct ring_buffer_event *event;
-	struct ring_buffer *buffer = tr->trace_buffer.buffer;
+	struct trace_buffer *buffer = tr->trace_buffer.buffer;
 	struct ftrace_graph_ent_entry *entry;
 
 	event = trace_buffer_lock_reserve(buffer, TRACE_GRAPH_ENT,
@@ -221,7 +221,7 @@ void __trace_graph_return(struct trace_array *tr,
 {
 	struct trace_event_call *call = &event_funcgraph_exit;
 	struct ring_buffer_event *event;
-	struct ring_buffer *buffer = tr->trace_buffer.buffer;
+	struct trace_buffer *buffer = tr->trace_buffer.buffer;
 	struct ftrace_graph_ret_entry *entry;
 
 	event = trace_buffer_lock_reserve(buffer, TRACE_GRAPH_RET,
diff --git a/kernel/trace/trace_hwlat.c b/kernel/trace/trace_hwlat.c
index 6638d63f0921..cb8da2a20f59 100644
--- a/kernel/trace/trace_hwlat.c
+++ b/kernel/trace/trace_hwlat.c
@@ -104,7 +104,7 @@ static void trace_hwlat_sample(struct hwlat_sample *sample)
 {
 	struct trace_array *tr = hwlat_trace;
 	struct trace_event_call *call = &event_hwlat;
-	struct ring_buffer *buffer = tr->trace_buffer.buffer;
+	struct trace_buffer *buffer = tr->trace_buffer.buffer;
 	struct ring_buffer_event *event;
 	struct hwlat_entry *entry;
 	unsigned long flags;
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 7f890262c8a3..477b6b011e7d 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1175,8 +1175,8 @@ __kprobe_trace_func(struct trace_kprobe *tk, struct pt_regs *regs,
 		    struct trace_event_file *trace_file)
 {
 	struct kprobe_trace_entry_head *entry;
+	struct trace_buffer *buffer;
 	struct ring_buffer_event *event;
-	struct ring_buffer *buffer;
 	int size, dsize, pc;
 	unsigned long irq_flags;
 	struct trace_event_call *call = trace_probe_event_call(&tk->tp);
@@ -1223,8 +1223,8 @@ __kretprobe_trace_func(struct trace_kprobe *tk, struct kretprobe_instance *ri,
 		       struct trace_event_file *trace_file)
 {
 	struct kretprobe_trace_entry_head *entry;
+	struct trace_buffer *buffer;
 	struct ring_buffer_event *event;
-	struct ring_buffer *buffer;
 	int size, pc, dsize;
 	unsigned long irq_flags;
 	struct trace_event_call *call = trace_probe_event_call(&tk->tp);
diff --git a/kernel/trace/trace_mmiotrace.c b/kernel/trace/trace_mmiotrace.c
index b0388016b687..a03e8859e094 100644
--- a/kernel/trace/trace_mmiotrace.c
+++ b/kernel/trace/trace_mmiotrace.c
@@ -297,7 +297,7 @@ static void __trace_mmiotrace_rw(struct trace_array *tr,
 				struct mmiotrace_rw *rw)
 {
 	struct trace_event_call *call = &event_mmiotrace_rw;
-	struct ring_buffer *buffer = tr->trace_buffer.buffer;
+	struct trace_buffer *buffer = tr->trace_buffer.buffer;
 	struct ring_buffer_event *event;
 	struct trace_mmiotrace_rw *entry;
 	int pc = preempt_count();
@@ -327,7 +327,7 @@ static void __trace_mmiotrace_map(struct trace_array *tr,
 				struct mmiotrace_map *map)
 {
 	struct trace_event_call *call = &event_mmiotrace_map;
-	struct ring_buffer *buffer = tr->trace_buffer.buffer;
+	struct trace_buffer *buffer = tr->trace_buffer.buffer;
 	struct ring_buffer_event *event;
 	struct trace_mmiotrace_map *entry;
 	int pc = preempt_count();
diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index 5e43b9664eca..0fe78a8b2e86 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -378,7 +378,7 @@ tracing_sched_switch_trace(struct trace_array *tr,
 			   unsigned long flags, int pc)
 {
 	struct trace_event_call *call = &event_context_switch;
-	struct ring_buffer *buffer = tr->trace_buffer.buffer;
+	struct trace_buffer *buffer = tr->trace_buffer.buffer;
 	struct ring_buffer_event *event;
 	struct ctx_switch_entry *entry;
 
@@ -408,7 +408,7 @@ tracing_sched_wakeup_trace(struct trace_array *tr,
 	struct trace_event_call *call = &event_wakeup;
 	struct ring_buffer_event *event;
 	struct ctx_switch_entry *entry;
-	struct ring_buffer *buffer = tr->trace_buffer.buffer;
+	struct trace_buffer *buffer = tr->trace_buffer.buffer;
 
 	event = trace_buffer_lock_reserve(buffer, TRACE_WAKE,
 					  sizeof(*entry), flags, pc);
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 16fa218556fa..581b4a11b657 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -317,7 +317,7 @@ static void ftrace_syscall_enter(void *data, struct pt_regs *regs, long id)
 	struct syscall_trace_enter *entry;
 	struct syscall_metadata *sys_data;
 	struct ring_buffer_event *event;
-	struct ring_buffer *buffer;
+	struct trace_buffer *buffer;
 	unsigned long irq_flags;
 	unsigned long args[6];
 	int pc;
@@ -367,7 +367,7 @@ static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
 	struct syscall_trace_exit *entry;
 	struct syscall_metadata *sys_data;
 	struct ring_buffer_event *event;
-	struct ring_buffer *buffer;
+	struct trace_buffer *buffer;
 	unsigned long irq_flags;
 	int pc;
 	int syscall_nr;
diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 352073d36585..6c75d94f5c2f 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -938,8 +938,8 @@ static void __uprobe_trace_func(struct trace_uprobe *tu,
 				struct trace_event_file *trace_file)
 {
 	struct uprobe_trace_entry_head *entry;
+	struct trace_buffer *buffer;
 	struct ring_buffer_event *event;
-	struct ring_buffer *buffer;
 	void *data;
 	int size, esize;
 	struct trace_event_call *call = trace_probe_event_call(&tu->tp);
-- 
2.20.1

