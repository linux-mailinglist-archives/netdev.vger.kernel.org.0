Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C203D11EA5D
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 19:32:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728775AbfLMS3r convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 13 Dec 2019 13:29:47 -0500
Received: from smtprelay0229.hostedemail.com ([216.40.44.229]:34865 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728699AbfLMS3r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 13:29:47 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id 96A0018013515;
        Fri, 13 Dec 2019 18:29:45 +0000 (UTC)
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::::::::::::::::::::::::::::::,RULES_HIT:41:69:327:355:379:541:599:800:960:966:967:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1431:1437:1513:1515:1516:1518:1521:1593:1594:1605:1730:1747:1777:1792:1981:2194:2196:2198:2199:2200:2201:2376:2393:2525:2553:2560:2563:2682:2685:2731:2859:2895:2902:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:4321:4385:4605:5007:6119:6261:6742:7514:7576:7875:7903:7974:8603:8660:9008:9025:9040:9545:10004:10967:11026:11232:11473:11658:11914:12043:12050:12262:12294:12296:12297:12438:12555:12663:12679:12683:12740:12895:12986:13141:13148:13161:13229:13230:13439:14096:14097:14659:21063:21080:21324:21325:21433:21451:21611:21627:21740:21789:21795:21939:21990:30012:30029:30030:30051:30054:30070:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none
X-HE-Tag: house62_71f7dac873853
X-Filterd-Recvd-Size: 24570
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (Authenticated sender: nevets@goodmis.org)
        by omf09.hostedemail.com (Postfix) with ESMTPA;
        Fri, 13 Dec 2019 18:29:43 +0000 (UTC)
Date:   Fri, 13 Dec 2019 13:29:41 -0500
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
Message-ID: <20191213132941.6fa2d1bd@gandalf.local.home>
In-Reply-To: <20191213180223.GE2844@hirez.programming.kicks-ass.net>
References: <20191213153553.GE20583@krava>
        <20191213112438.773dff35@gandalf.local.home>
        <20191213165155.vimm27wo7brkh3yu@ast-mbp.dhcp.thefacebook.com>
        <20191213121118.236f55b8@gandalf.local.home>
        <20191213180223.GE2844@hirez.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Dec 2019 19:02:23 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> On Fri, Dec 13, 2019 at 12:11:18PM -0500, Steven Rostedt wrote:
> > On Fri, 13 Dec 2019 08:51:57 -0800
> > Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> >   
> > > It had two choices. Both valid. I don't know why gdb picked this one.
> > > So yeah I think renaming 'ring_buffer' either in ftrace or in perf would be
> > > good. I think renaming ftrace one would be better, since gdb picked perf one
> > > for whatever reason.  
> > 
> > Because of the sort algorithm. But from a technical perspective, the
> > ring buffer that ftrace uses is generic, where the perf ring buffer can
> > only be used for perf. Call it "event_ring_buffer" or whatever, but
> > it's not generic and should not have a generic name.  
> 
> Your ring buffer was so generic that I gave up trying to use it after
> trying for days :-( (the fundamental problem was that it was impossible
> to have a single cpu buffer; afaik that is still true today)

Yeah, but that could have been fixed, and the only reason it's not
today, is because it requires more overhead to do so.

IIRC, the main reason that you didn't use it then, is because it wasn't
fully lockless at the time (it is today), and you couldn't use it from
NMI context.

> 
> Nor is the perf buffer fundamentally specific to perf, but there not
> being another user means there has been very little effort to remove
> perf specific things from it.

I took a look at doing so, and it was not a trivial task.

> 
> There are major design differences between them, which is
> unquestionably, but I don't think it is fair to say one is more or less
> generic.
> 
> How about we rename both? I'm a bit adverse to long names, so how about
> we rename the perf one to perf_buffer and the trace one to trace_buffer?

I'm fine with this idea! Now what do we call the ring buffer that
tracing uses, as it is not specific for tracing, it was optimized for
splicing. But sure, I can rename it to trace_buffer. I just finished
renaming perf's...

Thinking about this, perhaps we should remove the word "ring" from
both. That is:

  perf_buffer and trace_buffer ?

Anyway, here's the perf update, I can go ahead and rewrite the tracing
one too, and perhaps one day we can make a truly generic ring buffer!

-- Steve

From b457e9fe8366eef0ba00937e2a9a21899ca06e06 Mon Sep 17 00:00:00 2001
From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Date: Fri, 13 Dec 2019 13:21:30 -0500
Subject: [PATCH] perf: Make struct ring_buffer less ambiguous

eBPF requires needing to know the size of the perf ring buffer structure.
But it unfortunately has the same name as the generic ring buffer used by
tracing and oprofile. To make it less ambiguous, rename the perf ring buffer
structure to "perf_ring_buffer".

Now the reason to rename the ring buffer in perf and not the one used by
tracing and oprofile, is for the following reasons:

 1) The perf ring buffer is very coupled to perf.
    The ring buffer assumes that it is used for perf, and perf alone.
    It requires to be read by perf mmapping, and reqires the perf interface
     to read it.

    The ring buffer used by tracing is stand a lone, and has no references
    to tracing. This is why oprofile was able to use it as well.

 2) The perf ring buffer is quite contained.
    It is only used within the kernel/events directory.
    Only four files reference it, and only three require to know its
     contant (include/linux/perf_event.h just declares the reference)

 3) The perf ring buffer came after the generic ring buffer.
     When this ring buffer was added, it appeared that it was only going
     to be local as it used the same name as one that already existed.

The main reason to rename the perf ring buffer is because of #1 above.
It is not a generic ring buffer at all, and other parts of the ring
buffer code has "perf_" as the prefix, it only makes sense to give the
ring buffer the "perf_" prefix as well.

Link: https://lore.kernel.org/r/20191213153553.GE20583@krava
Suggested-by: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 include/linux/perf_event.h  |  6 ++---
 kernel/events/core.c        | 42 ++++++++++++++---------------
 kernel/events/internal.h    | 34 +++++++++++------------
 kernel/events/ring_buffer.c | 54 ++++++++++++++++++-------------------
 4 files changed, 68 insertions(+), 68 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 6d4c22aee384..b9adf826c393 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -582,7 +582,7 @@ struct swevent_hlist {
 #define PERF_ATTACH_ITRACE	0x10
 
 struct perf_cgroup;
-struct ring_buffer;
+struct perf_ring_buffer;
 
 struct pmu_event_list {
 	raw_spinlock_t		lock;
@@ -694,7 +694,7 @@ struct perf_event {
 	struct mutex			mmap_mutex;
 	atomic_t			mmap_count;
 
-	struct ring_buffer		*rb;
+	struct perf_ring_buffer		*rb;
 	struct list_head		rb_entry;
 	unsigned long			rcu_batches;
 	int				rcu_pending;
@@ -854,7 +854,7 @@ struct perf_cpu_context {
 
 struct perf_output_handle {
 	struct perf_event		*event;
-	struct ring_buffer		*rb;
+	struct perf_ring_buffer		*rb;
 	unsigned long			wakeup;
 	unsigned long			size;
 	u64				aux_flags;
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 4ff86d57f9e5..95308f7b62da 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4373,7 +4373,7 @@ static void free_event_rcu(struct rcu_head *head)
 }
 
 static void ring_buffer_attach(struct perf_event *event,
-			       struct ring_buffer *rb);
+			       struct perf_ring_buffer *rb);
 
 static void detach_sb_event(struct perf_event *event)
 {
@@ -5054,7 +5054,7 @@ perf_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 static __poll_t perf_poll(struct file *file, poll_table *wait)
 {
 	struct perf_event *event = file->private_data;
-	struct ring_buffer *rb;
+	struct perf_ring_buffer *rb;
 	__poll_t events = EPOLLHUP;
 
 	poll_wait(file, &event->waitq, wait);
@@ -5296,7 +5296,7 @@ static long _perf_ioctl(struct perf_event *event, unsigned int cmd, unsigned lon
 		return perf_event_set_bpf_prog(event, arg);
 
 	case PERF_EVENT_IOC_PAUSE_OUTPUT: {
-		struct ring_buffer *rb;
+		struct perf_ring_buffer *rb;
 
 		rcu_read_lock();
 		rb = rcu_dereference(event->rb);
@@ -5432,7 +5432,7 @@ static void calc_timer_values(struct perf_event *event,
 static void perf_event_init_userpage(struct perf_event *event)
 {
 	struct perf_event_mmap_page *userpg;
-	struct ring_buffer *rb;
+	struct perf_ring_buffer *rb;
 
 	rcu_read_lock();
 	rb = rcu_dereference(event->rb);
@@ -5464,7 +5464,7 @@ void __weak arch_perf_update_userpage(
 void perf_event_update_userpage(struct perf_event *event)
 {
 	struct perf_event_mmap_page *userpg;
-	struct ring_buffer *rb;
+	struct perf_ring_buffer *rb;
 	u64 enabled, running, now;
 
 	rcu_read_lock();
@@ -5515,7 +5515,7 @@ EXPORT_SYMBOL_GPL(perf_event_update_userpage);
 static vm_fault_t perf_mmap_fault(struct vm_fault *vmf)
 {
 	struct perf_event *event = vmf->vma->vm_file->private_data;
-	struct ring_buffer *rb;
+	struct perf_ring_buffer *rb;
 	vm_fault_t ret = VM_FAULT_SIGBUS;
 
 	if (vmf->flags & FAULT_FLAG_MKWRITE) {
@@ -5548,9 +5548,9 @@ static vm_fault_t perf_mmap_fault(struct vm_fault *vmf)
 }
 
 static void ring_buffer_attach(struct perf_event *event,
-			       struct ring_buffer *rb)
+			       struct perf_ring_buffer *rb)
 {
-	struct ring_buffer *old_rb = NULL;
+	struct perf_ring_buffer *old_rb = NULL;
 	unsigned long flags;
 
 	if (event->rb) {
@@ -5608,7 +5608,7 @@ static void ring_buffer_attach(struct perf_event *event,
 
 static void ring_buffer_wakeup(struct perf_event *event)
 {
-	struct ring_buffer *rb;
+	struct perf_ring_buffer *rb;
 
 	rcu_read_lock();
 	rb = rcu_dereference(event->rb);
@@ -5619,9 +5619,9 @@ static void ring_buffer_wakeup(struct perf_event *event)
 	rcu_read_unlock();
 }
 
-struct ring_buffer *ring_buffer_get(struct perf_event *event)
+struct perf_ring_buffer *ring_buffer_get(struct perf_event *event)
 {
-	struct ring_buffer *rb;
+	struct perf_ring_buffer *rb;
 
 	rcu_read_lock();
 	rb = rcu_dereference(event->rb);
@@ -5634,7 +5634,7 @@ struct ring_buffer *ring_buffer_get(struct perf_event *event)
 	return rb;
 }
 
-void ring_buffer_put(struct ring_buffer *rb)
+void ring_buffer_put(struct perf_ring_buffer *rb)
 {
 	if (!refcount_dec_and_test(&rb->refcount))
 		return;
@@ -5672,7 +5672,7 @@ static void perf_mmap_close(struct vm_area_struct *vma)
 {
 	struct perf_event *event = vma->vm_file->private_data;
 
-	struct ring_buffer *rb = ring_buffer_get(event);
+	struct perf_ring_buffer *rb = ring_buffer_get(event);
 	struct user_struct *mmap_user = rb->mmap_user;
 	int mmap_locked = rb->mmap_locked;
 	unsigned long size = perf_data_size(rb);
@@ -5790,8 +5790,8 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 	struct perf_event *event = file->private_data;
 	unsigned long user_locked, user_lock_limit;
 	struct user_struct *user = current_user();
+	struct perf_ring_buffer *rb = NULL;
 	unsigned long locked, lock_limit;
-	struct ring_buffer *rb = NULL;
 	unsigned long vma_size;
 	unsigned long nr_pages;
 	long user_extra = 0, extra = 0;
@@ -6266,7 +6266,7 @@ static unsigned long perf_prepare_sample_aux(struct perf_event *event,
 					  size_t size)
 {
 	struct perf_event *sampler = event->aux_event;
-	struct ring_buffer *rb;
+	struct perf_ring_buffer *rb;
 
 	data->aux_size = 0;
 
@@ -6299,7 +6299,7 @@ static unsigned long perf_prepare_sample_aux(struct perf_event *event,
 	return data->aux_size;
 }
 
-long perf_pmu_snapshot_aux(struct ring_buffer *rb,
+long perf_pmu_snapshot_aux(struct perf_ring_buffer *rb,
 			   struct perf_event *event,
 			   struct perf_output_handle *handle,
 			   unsigned long size)
@@ -6338,8 +6338,8 @@ static void perf_aux_sample_output(struct perf_event *event,
 				   struct perf_sample_data *data)
 {
 	struct perf_event *sampler = event->aux_event;
+	struct perf_ring_buffer *rb;
 	unsigned long pad;
-	struct ring_buffer *rb;
 	long size;
 
 	if (WARN_ON_ONCE(!sampler || !data->aux_size))
@@ -6707,7 +6707,7 @@ void perf_output_sample(struct perf_output_handle *handle,
 		int wakeup_events = event->attr.wakeup_events;
 
 		if (wakeup_events) {
-			struct ring_buffer *rb = handle->rb;
+			struct perf_ring_buffer *rb = handle->rb;
 			int events = local_inc_return(&rb->events);
 
 			if (events >= wakeup_events) {
@@ -7150,7 +7150,7 @@ void perf_event_exec(void)
 }
 
 struct remote_output {
-	struct ring_buffer	*rb;
+	struct perf_ring_buffer	*rb;
 	int			err;
 };
 
@@ -7158,7 +7158,7 @@ static void __perf_event_output_stop(struct perf_event *event, void *data)
 {
 	struct perf_event *parent = event->parent;
 	struct remote_output *ro = data;
-	struct ring_buffer *rb = ro->rb;
+	struct perf_ring_buffer *rb = ro->rb;
 	struct stop_event_data sd = {
 		.event	= event,
 	};
@@ -10998,7 +10998,7 @@ static int perf_copy_attr(struct perf_event_attr __user *uattr,
 static int
 perf_event_set_output(struct perf_event *event, struct perf_event *output_event)
 {
-	struct ring_buffer *rb = NULL;
+	struct perf_ring_buffer *rb = NULL;
 	int ret = -EINVAL;
 
 	if (!output_event)
diff --git a/kernel/events/internal.h b/kernel/events/internal.h
index 747d67f130cb..820edf227747 100644
--- a/kernel/events/internal.h
+++ b/kernel/events/internal.h
@@ -10,7 +10,7 @@
 
 #define RING_BUFFER_WRITABLE		0x01
 
-struct ring_buffer {
+struct perf_ring_buffer {
 	refcount_t			refcount;
 	struct rcu_head			rcu_head;
 #ifdef CONFIG_PERF_USE_VMALLOC
@@ -58,17 +58,17 @@ struct ring_buffer {
 	void				*data_pages[0];
 };
 
-extern void rb_free(struct ring_buffer *rb);
+extern void rb_free(struct perf_ring_buffer *rb);
 
 static inline void rb_free_rcu(struct rcu_head *rcu_head)
 {
-	struct ring_buffer *rb;
+	struct perf_ring_buffer *rb;
 
-	rb = container_of(rcu_head, struct ring_buffer, rcu_head);
+	rb = container_of(rcu_head, struct perf_ring_buffer, rcu_head);
 	rb_free(rb);
 }
 
-static inline void rb_toggle_paused(struct ring_buffer *rb, bool pause)
+static inline void rb_toggle_paused(struct perf_ring_buffer *rb, bool pause)
 {
 	if (!pause && rb->nr_pages)
 		rb->paused = 0;
@@ -76,16 +76,16 @@ static inline void rb_toggle_paused(struct ring_buffer *rb, bool pause)
 		rb->paused = 1;
 }
 
-extern struct ring_buffer *
+extern struct perf_ring_buffer *
 rb_alloc(int nr_pages, long watermark, int cpu, int flags);
 extern void perf_event_wakeup(struct perf_event *event);
-extern int rb_alloc_aux(struct ring_buffer *rb, struct perf_event *event,
+extern int rb_alloc_aux(struct perf_ring_buffer *rb, struct perf_event *event,
 			pgoff_t pgoff, int nr_pages, long watermark, int flags);
-extern void rb_free_aux(struct ring_buffer *rb);
-extern struct ring_buffer *ring_buffer_get(struct perf_event *event);
-extern void ring_buffer_put(struct ring_buffer *rb);
+extern void rb_free_aux(struct perf_ring_buffer *rb);
+extern struct perf_ring_buffer *ring_buffer_get(struct perf_event *event);
+extern void ring_buffer_put(struct perf_ring_buffer *rb);
 
-static inline bool rb_has_aux(struct ring_buffer *rb)
+static inline bool rb_has_aux(struct perf_ring_buffer *rb)
 {
 	return !!rb->aux_nr_pages;
 }
@@ -94,7 +94,7 @@ void perf_event_aux_event(struct perf_event *event, unsigned long head,
 			  unsigned long size, u64 flags);
 
 extern struct page *
-perf_mmap_to_page(struct ring_buffer *rb, unsigned long pgoff);
+perf_mmap_to_page(struct perf_ring_buffer *rb, unsigned long pgoff);
 
 #ifdef CONFIG_PERF_USE_VMALLOC
 /*
@@ -103,25 +103,25 @@ perf_mmap_to_page(struct ring_buffer *rb, unsigned long pgoff);
  * Required for architectures that have d-cache aliasing issues.
  */
 
-static inline int page_order(struct ring_buffer *rb)
+static inline int page_order(struct perf_ring_buffer *rb)
 {
 	return rb->page_order;
 }
 
 #else
 
-static inline int page_order(struct ring_buffer *rb)
+static inline int page_order(struct perf_ring_buffer *rb)
 {
 	return 0;
 }
 #endif
 
-static inline unsigned long perf_data_size(struct ring_buffer *rb)
+static inline unsigned long perf_data_size(struct perf_ring_buffer *rb)
 {
 	return rb->nr_pages << (PAGE_SHIFT + page_order(rb));
 }
 
-static inline unsigned long perf_aux_size(struct ring_buffer *rb)
+static inline unsigned long perf_aux_size(struct perf_ring_buffer *rb)
 {
 	return rb->aux_nr_pages << PAGE_SHIFT;
 }
@@ -141,7 +141,7 @@ static inline unsigned long perf_aux_size(struct ring_buffer *rb)
 			buf += written;					\
 		handle->size -= written;				\
 		if (!handle->size) {					\
-			struct ring_buffer *rb = handle->rb;		\
+			struct perf_ring_buffer *rb = handle->rb;	\
 									\
 			handle->page++;					\
 			handle->page &= rb->nr_pages - 1;		\
diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
index 7ffd5c763f93..70230b45e6c5 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -35,7 +35,7 @@ static void perf_output_wakeup(struct perf_output_handle *handle)
  */
 static void perf_output_get_handle(struct perf_output_handle *handle)
 {
-	struct ring_buffer *rb = handle->rb;
+	struct perf_ring_buffer *rb = handle->rb;
 
 	preempt_disable();
 
@@ -49,7 +49,7 @@ static void perf_output_get_handle(struct perf_output_handle *handle)
 
 static void perf_output_put_handle(struct perf_output_handle *handle)
 {
-	struct ring_buffer *rb = handle->rb;
+	struct perf_ring_buffer *rb = handle->rb;
 	unsigned long head;
 	unsigned int nest;
 
@@ -150,7 +150,7 @@ __perf_output_begin(struct perf_output_handle *handle,
 		    struct perf_event *event, unsigned int size,
 		    bool backward)
 {
-	struct ring_buffer *rb;
+	struct perf_ring_buffer *rb;
 	unsigned long tail, offset, head;
 	int have_lost, page_shift;
 	struct {
@@ -301,7 +301,7 @@ void perf_output_end(struct perf_output_handle *handle)
 }
 
 static void
-ring_buffer_init(struct ring_buffer *rb, long watermark, int flags)
+ring_buffer_init(struct perf_ring_buffer *rb, long watermark, int flags)
 {
 	long max_size = perf_data_size(rb);
 
@@ -361,7 +361,7 @@ void *perf_aux_output_begin(struct perf_output_handle *handle,
 {
 	struct perf_event *output_event = event;
 	unsigned long aux_head, aux_tail;
-	struct ring_buffer *rb;
+	struct perf_ring_buffer *rb;
 	unsigned int nest;
 
 	if (output_event->parent)
@@ -449,7 +449,7 @@ void *perf_aux_output_begin(struct perf_output_handle *handle,
 }
 EXPORT_SYMBOL_GPL(perf_aux_output_begin);
 
-static __always_inline bool rb_need_aux_wakeup(struct ring_buffer *rb)
+static __always_inline bool rb_need_aux_wakeup(struct perf_ring_buffer *rb)
 {
 	if (rb->aux_overwrite)
 		return false;
@@ -475,7 +475,7 @@ static __always_inline bool rb_need_aux_wakeup(struct ring_buffer *rb)
 void perf_aux_output_end(struct perf_output_handle *handle, unsigned long size)
 {
 	bool wakeup = !!(handle->aux_flags & PERF_AUX_FLAG_TRUNCATED);
-	struct ring_buffer *rb = handle->rb;
+	struct perf_ring_buffer *rb = handle->rb;
 	unsigned long aux_head;
 
 	/* in overwrite mode, driver provides aux_head via handle */
@@ -532,7 +532,7 @@ EXPORT_SYMBOL_GPL(perf_aux_output_end);
  */
 int perf_aux_output_skip(struct perf_output_handle *handle, unsigned long size)
 {
-	struct ring_buffer *rb = handle->rb;
+	struct perf_ring_buffer *rb = handle->rb;
 
 	if (size > handle->size)
 		return -ENOSPC;
@@ -569,8 +569,8 @@ long perf_output_copy_aux(struct perf_output_handle *aux_handle,
 			  struct perf_output_handle *handle,
 			  unsigned long from, unsigned long to)
 {
+	struct perf_ring_buffer *rb = aux_handle->rb;
 	unsigned long tocopy, remainder, len = 0;
-	struct ring_buffer *rb = aux_handle->rb;
 	void *addr;
 
 	from &= (rb->aux_nr_pages << PAGE_SHIFT) - 1;
@@ -626,7 +626,7 @@ static struct page *rb_alloc_aux_page(int node, int order)
 	return page;
 }
 
-static void rb_free_aux_page(struct ring_buffer *rb, int idx)
+static void rb_free_aux_page(struct perf_ring_buffer *rb, int idx)
 {
 	struct page *page = virt_to_page(rb->aux_pages[idx]);
 
@@ -635,7 +635,7 @@ static void rb_free_aux_page(struct ring_buffer *rb, int idx)
 	__free_page(page);
 }
 
-static void __rb_free_aux(struct ring_buffer *rb)
+static void __rb_free_aux(struct perf_ring_buffer *rb)
 {
 	int pg;
 
@@ -662,7 +662,7 @@ static void __rb_free_aux(struct ring_buffer *rb)
 	}
 }
 
-int rb_alloc_aux(struct ring_buffer *rb, struct perf_event *event,
+int rb_alloc_aux(struct perf_ring_buffer *rb, struct perf_event *event,
 		 pgoff_t pgoff, int nr_pages, long watermark, int flags)
 {
 	bool overwrite = !(flags & RING_BUFFER_WRITABLE);
@@ -753,7 +753,7 @@ int rb_alloc_aux(struct ring_buffer *rb, struct perf_event *event,
 	return ret;
 }
 
-void rb_free_aux(struct ring_buffer *rb)
+void rb_free_aux(struct perf_ring_buffer *rb)
 {
 	if (refcount_dec_and_test(&rb->aux_refcount))
 		__rb_free_aux(rb);
@@ -766,7 +766,7 @@ void rb_free_aux(struct ring_buffer *rb)
  */
 
 static struct page *
-__perf_mmap_to_page(struct ring_buffer *rb, unsigned long pgoff)
+__perf_mmap_to_page(struct perf_ring_buffer *rb, unsigned long pgoff)
 {
 	if (pgoff > rb->nr_pages)
 		return NULL;
@@ -798,13 +798,13 @@ static void perf_mmap_free_page(void *addr)
 	__free_page(page);
 }
 
-struct ring_buffer *rb_alloc(int nr_pages, long watermark, int cpu, int flags)
+struct perf_ring_buffer *rb_alloc(int nr_pages, long watermark, int cpu, int flags)
 {
-	struct ring_buffer *rb;
+	struct perf_ring_buffer *rb;
 	unsigned long size;
 	int i;
 
-	size = sizeof(struct ring_buffer);
+	size = sizeof(struct perf_ring_buffer);
 	size += nr_pages * sizeof(void *);
 
 	if (order_base_2(size) >= PAGE_SHIFT+MAX_ORDER)
@@ -843,7 +843,7 @@ struct ring_buffer *rb_alloc(int nr_pages, long watermark, int cpu, int flags)
 	return NULL;
 }
 
-void rb_free(struct ring_buffer *rb)
+void rb_free(struct perf_ring_buffer *rb)
 {
 	int i;
 
@@ -854,13 +854,13 @@ void rb_free(struct ring_buffer *rb)
 }
 
 #else
-static int data_page_nr(struct ring_buffer *rb)
+static int data_page_nr(struct perf_ring_buffer *rb)
 {
 	return rb->nr_pages << page_order(rb);
 }
 
 static struct page *
-__perf_mmap_to_page(struct ring_buffer *rb, unsigned long pgoff)
+__perf_mmap_to_page(struct perf_ring_buffer *rb, unsigned long pgoff)
 {
 	/* The '>' counts in the user page. */
 	if (pgoff > data_page_nr(rb))
@@ -878,11 +878,11 @@ static void perf_mmap_unmark_page(void *addr)
 
 static void rb_free_work(struct work_struct *work)
 {
-	struct ring_buffer *rb;
+	struct perf_ring_buffer *rb;
 	void *base;
 	int i, nr;
 
-	rb = container_of(work, struct ring_buffer, work);
+	rb = container_of(work, struct perf_ring_buffer, work);
 	nr = data_page_nr(rb);
 
 	base = rb->user_page;
@@ -894,18 +894,18 @@ static void rb_free_work(struct work_struct *work)
 	kfree(rb);
 }
 
-void rb_free(struct ring_buffer *rb)
+void rb_free(struct perf_ring_buffer *rb)
 {
 	schedule_work(&rb->work);
 }
 
-struct ring_buffer *rb_alloc(int nr_pages, long watermark, int cpu, int flags)
+struct perf_ring_buffer *rb_alloc(int nr_pages, long watermark, int cpu, int flags)
 {
-	struct ring_buffer *rb;
+	struct perf_ring_buffer *rb;
 	unsigned long size;
 	void *all_buf;
 
-	size = sizeof(struct ring_buffer);
+	size = sizeof(struct perf_ring_buffer);
 	size += sizeof(void *);
 
 	rb = kzalloc(size, GFP_KERNEL);
@@ -939,7 +939,7 @@ struct ring_buffer *rb_alloc(int nr_pages, long watermark, int cpu, int flags)
 #endif
 
 struct page *
-perf_mmap_to_page(struct ring_buffer *rb, unsigned long pgoff)
+perf_mmap_to_page(struct perf_ring_buffer *rb, unsigned long pgoff)
 {
 	if (rb->aux_nr_pages) {
 		/* above AUX space */
-- 
2.20.1

