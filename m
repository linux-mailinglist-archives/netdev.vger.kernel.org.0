Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB7D0B4F3E
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 15:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728301AbfIQNbf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 09:31:35 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:36271 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726230AbfIQNbd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Sep 2019 09:31:33 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 21CCF3955;
        Tue, 17 Sep 2019 09:31:31 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 17 Sep 2019 09:31:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm1; bh=GJV3QxlCo4B38
        CZxCwMYESB8BQr0ysoGirhVOVPTXPg=; b=M7/yT+YkNbwMvtjxSy9SCuuXcdnAi
        WLhAFdfva1u5YNT9qstvdzKbH808QLuPCLeOtweRAEiW+nhF/JKw3lArAx3Yx4Cc
        W7X0DqlveUpVCYo1TQzqvv2nhITqh9UggMpoicV7ZJTDCeX76YAYIoH+jR5+EPuW
        R84WkOGRjgRg2HNbmXPMazLQce6f6I0teUXKFwOlLk2GeL1OBwGudHVHRKyptJ39
        kJVNVhrCto1MCNTbOdsgJzTatsJAKXSSZztFFouiIW3170yW/IsbvM1CyJoQAVN7
        nYmWTWNdJq+e5Qqo85hcGAuoenlViGHkOPhNif8gxJRqG33hQOI6BYALA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=GJV3QxlCo4B38CZxCwMYESB8BQr0ysoGirhVOVPTXPg=; b=INF5Hsph
        D5J3bypAjbNqXX2ilbdyVPSs1rWNPSqJMJ2BeR4VvvyDNnOK0CWCWQZyI9gAKZXK
        OoprdOsY0p+GF6vODk/n095KUjG2p0EpiLHfVd+B8Vm0ttCthcB6kviuxjxpedzQ
        OuiED22CKm9vvB6GatwdXyxWYqKR/6Npt2WT+NYDU1lrL/P0iyc2/7ijpnjmf66Z
        ndodX0yg2o64NTAy5bqlHR2qEywElth3PIdWJ3xMLlL/LvnGf6WN7zHPl07HFD43
        M87HA3PWvtr/T4re5pkeiujrjpTo7Dx63mFF5LZd0UpZL+Sx8DErUVwojWChRMq2
        yMj76B8dpg+z0g==
X-ME-Sender: <xms:MuCAXXKYok16YfOfXbtdIHyyY7_1ByvTcib3bjie7Ivzd8C3kqljIA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudeigdefkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecufghrlhcuvffnffculdejtddmnecujfgurhephffvuf
    ffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeffrghnihgvlhcuighuuceougig
    uhesugiguhhuuhdrgiihiieqnecukfhppeduleelrddvtddurdeiiedrtdenucfrrghrrg
    hmpehmrghilhhfrhhomhepugiguhesugiguhhuuhdrgiihiienucevlhhushhtvghrufhi
    iigvpedt
X-ME-Proxy: <xmx:M-CAXfOX_eDP7UbdrHPiXc5jN6oWcbOukrJFZqkmZutkrC9ZusYAJw>
    <xmx:M-CAXQ3qyuYmwzJdyOTyy62-lntXqTyv71tl4Cx1klTMTVv02hXSPQ>
    <xmx:M-CAXZyzkb0qQts71EpZ24WBO7qFMIZicKmCKpCDByrqxnoxQUvJTw>
    <xmx:M-CAXcA3xKlFIy24N6ykBllis4FMrUnh0WvQC9uDv04uJappCtlUFjAv1Mg>
Received: from dlxu-fedora-R90QNFJV.thefacebook.com (unknown [199.201.66.0])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9888BD60063;
        Tue, 17 Sep 2019 09:31:29 -0400 (EDT)
From:   Daniel Xu <dxu@dxuuu.xyz>
To:     bpf@vger.kernel.org, songliubraving@fb.com, yhs@fb.com,
        andriin@fb.com, peterz@infradead.org, mingo@redhat.com,
        acme@kernel.org
Cc:     Daniel Xu <dxu@dxuuu.xyz>, ast@fb.com,
        alexander.shishkin@linux.intel.com, jolsa@redhat.com,
        namhyung@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH bpf-next 1/5] perf/core: Add PERF_FORMAT_LOST read_format
Date:   Tue, 17 Sep 2019 06:30:52 -0700
Message-Id: <20190917133056.5545-2-dxu@dxuuu.xyz>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190917133056.5545-1-dxu@dxuuu.xyz>
References: <20190917133056.5545-1-dxu@dxuuu.xyz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's useful to know kprobe's nmissed count. For example with tracing
tools, it's important to know when events may have been lost.  debugfs
currently exposes a control file to get this information, but it is not
compatible with probes registered with the perf API.

While bpf programs may be able to manually count nhit, there is no way
to gather nmissed. In other words, it is currently not possible to this
retrieve information about FD-based probes.

This patch adds a new field to perf's read_format that lets users query
misses. Misses include both misses from the underlying kprobe
infrastructure and misses from ringbuffer infrastructure.

Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
---
 include/linux/trace_events.h    |  1 +
 include/uapi/linux/perf_event.h |  5 ++++-
 kernel/events/core.c            | 39 ++++++++++++++++++++++++++++++---
 kernel/trace/trace_kprobe.c     |  8 +++++++
 4 files changed, 49 insertions(+), 4 deletions(-)

diff --git a/include/linux/trace_events.h b/include/linux/trace_events.h
index 30a8cdcfd4a4..952520c1240a 100644
--- a/include/linux/trace_events.h
+++ b/include/linux/trace_events.h
@@ -587,6 +587,7 @@ extern int bpf_get_kprobe_info(const struct perf_event *event,
 			       u32 *fd_type, const char **symbol,
 			       u64 *probe_offset, u64 *probe_addr,
 			       bool perf_type_tracepoint);
+extern u64 perf_kprobe_missed(const struct perf_event *event);
 #endif
 #ifdef CONFIG_UPROBE_EVENTS
 extern int  perf_uprobe_init(struct perf_event *event,
diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 7198ddd0c6b1..bd874c7257f0 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -273,6 +273,7 @@ enum {
  *	  { u64		time_enabled; } && PERF_FORMAT_TOTAL_TIME_ENABLED
  *	  { u64		time_running; } && PERF_FORMAT_TOTAL_TIME_RUNNING
  *	  { u64		id;           } && PERF_FORMAT_ID
+ *	  { u64		missed;       } && PERF_FORMAT_LOST
  *	} && !PERF_FORMAT_GROUP
  *
  *	{ u64		nr;
@@ -280,6 +281,7 @@ enum {
  *	  { u64		time_running; } && PERF_FORMAT_TOTAL_TIME_RUNNING
  *	  { u64		value;
  *	    { u64	id;           } && PERF_FORMAT_ID
+ *	    { u64	missed;       } && PERF_FORMAT_LOST
  *	  }		cntr[nr];
  *	} && PERF_FORMAT_GROUP
  * };
@@ -289,8 +291,9 @@ enum perf_event_read_format {
 	PERF_FORMAT_TOTAL_TIME_RUNNING		= 1U << 1,
 	PERF_FORMAT_ID				= 1U << 2,
 	PERF_FORMAT_GROUP			= 1U << 3,
+	PERF_FORMAT_LOST			= 1U << 4,
 
-	PERF_FORMAT_MAX = 1U << 4,		/* non-ABI */
+	PERF_FORMAT_MAX = 1U << 5,		/* non-ABI */
 };
 
 #define PERF_ATTR_SIZE_VER0	64	/* sizeof first published struct */
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 0463c1151bae..ee08d3ed6299 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1715,6 +1715,9 @@ static void __perf_event_read_size(struct perf_event *event, int nr_siblings)
 	if (event->attr.read_format & PERF_FORMAT_ID)
 		entry += sizeof(u64);
 
+	if (event->attr.read_format & PERF_FORMAT_LOST)
+		entry += sizeof(u64);
+
 	if (event->attr.read_format & PERF_FORMAT_GROUP) {
 		nr += nr_siblings;
 		size += sizeof(u64);
@@ -4734,6 +4737,24 @@ u64 perf_event_read_value(struct perf_event *event, u64 *enabled, u64 *running)
 }
 EXPORT_SYMBOL_GPL(perf_event_read_value);
 
+static struct pmu perf_kprobe;
+static u64 perf_event_lost(struct perf_event *event)
+{
+	struct ring_buffer *rb;
+	u64 lost = 0;
+
+	rcu_read_lock();
+	rb = rcu_dereference(event->rb);
+	if (likely(!!rb))
+		lost += local_read(&rb->lost);
+	rcu_read_unlock();
+
+	if (event->attr.type == perf_kprobe.type)
+		lost += perf_kprobe_missed(event);
+
+	return lost;
+}
+
 static int __perf_read_group_add(struct perf_event *leader,
 					u64 read_format, u64 *values)
 {
@@ -4770,11 +4791,15 @@ static int __perf_read_group_add(struct perf_event *leader,
 	values[n++] += perf_event_count(leader);
 	if (read_format & PERF_FORMAT_ID)
 		values[n++] = primary_event_id(leader);
+	if (read_format & PERF_FORMAT_LOST)
+		values[n++] = perf_event_lost(leader);
 
 	for_each_sibling_event(sub, leader) {
 		values[n++] += perf_event_count(sub);
 		if (read_format & PERF_FORMAT_ID)
 			values[n++] = primary_event_id(sub);
+		if (read_format & PERF_FORMAT_LOST)
+			values[n++] = perf_event_lost(sub);
 	}
 
 	raw_spin_unlock_irqrestore(&ctx->lock, flags);
@@ -4831,7 +4856,7 @@ static int perf_read_one(struct perf_event *event,
 				 u64 read_format, char __user *buf)
 {
 	u64 enabled, running;
-	u64 values[4];
+	u64 values[5];
 	int n = 0;
 
 	values[n++] = __perf_event_read_value(event, &enabled, &running);
@@ -4841,6 +4866,8 @@ static int perf_read_one(struct perf_event *event,
 		values[n++] = running;
 	if (read_format & PERF_FORMAT_ID)
 		values[n++] = primary_event_id(event);
+	if (read_format & PERF_FORMAT_LOST)
+		values[n++] = perf_event_lost(event);
 
 	if (copy_to_user(buf, values, n * sizeof(u64)))
 		return -EFAULT;
@@ -6141,7 +6168,7 @@ static void perf_output_read_one(struct perf_output_handle *handle,
 				 u64 enabled, u64 running)
 {
 	u64 read_format = event->attr.read_format;
-	u64 values[4];
+	u64 values[5];
 	int n = 0;
 
 	values[n++] = perf_event_count(event);
@@ -6155,6 +6182,8 @@ static void perf_output_read_one(struct perf_output_handle *handle,
 	}
 	if (read_format & PERF_FORMAT_ID)
 		values[n++] = primary_event_id(event);
+	if (read_format & PERF_FORMAT_LOST)
+		values[n++] = perf_event_lost(event);
 
 	__output_copy(handle, values, n * sizeof(u64));
 }
@@ -6165,7 +6194,7 @@ static void perf_output_read_group(struct perf_output_handle *handle,
 {
 	struct perf_event *leader = event->group_leader, *sub;
 	u64 read_format = event->attr.read_format;
-	u64 values[5];
+	u64 values[6];
 	int n = 0;
 
 	values[n++] = 1 + leader->nr_siblings;
@@ -6183,6 +6212,8 @@ static void perf_output_read_group(struct perf_output_handle *handle,
 	values[n++] = perf_event_count(leader);
 	if (read_format & PERF_FORMAT_ID)
 		values[n++] = primary_event_id(leader);
+	if (read_format & PERF_FORMAT_LOST)
+		values[n++] = perf_event_lost(leader);
 
 	__output_copy(handle, values, n * sizeof(u64));
 
@@ -6196,6 +6227,8 @@ static void perf_output_read_group(struct perf_output_handle *handle,
 		values[n++] = perf_event_count(sub);
 		if (read_format & PERF_FORMAT_ID)
 			values[n++] = primary_event_id(sub);
+		if (read_format & PERF_FORMAT_LOST)
+			values[n++] = perf_event_lost(sub);
 
 		__output_copy(handle, values, n * sizeof(u64));
 	}
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 9d483ad9bb6c..cff471c8750b 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -196,6 +196,14 @@ bool trace_kprobe_error_injectable(struct trace_event_call *call)
 	return within_error_injection_list(trace_kprobe_address(tk));
 }
 
+u64 perf_kprobe_missed(const struct perf_event *event)
+{
+	struct trace_event_call *call = event->tp_event;
+	struct trace_kprobe *tk = (struct trace_kprobe *)call->data;
+
+	return tk->rp.kp.nmissed;
+}
+
 static int register_kprobe_event(struct trace_kprobe *tk);
 static int unregister_kprobe_event(struct trace_kprobe *tk);
 
-- 
2.21.0

