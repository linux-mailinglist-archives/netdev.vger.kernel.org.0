Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7FF545B6BB
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 09:42:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241479AbhKXIp4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 03:45:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:43811 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241506AbhKXIoj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 03:44:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637743289;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VouSXcSjiyGYNn3FCu9sQIbouxSYrC5qt0JuJCkXXDo=;
        b=G7QK1EE+MM5gsltQZSYTxew7jy+43Vq0bKWebgnH+v0kV0O0P8hRaVT4k9sz1l9rG5TkIB
        h8/p2eeiXqtYe/PDXIpU038DZRtH+GwUdpR5JMTT+gAOY1IJkY5kcYo6LYbyO8aguYkeav
        OgEqrLdrvwngFgb8lM7VV+xHJo/xTTY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-603-eKg1sA97PkGghIIzJKWt2Q-1; Wed, 24 Nov 2021 03:41:28 -0500
X-MC-Unique: eKg1sA97PkGghIIzJKWt2Q-1
Received: by mail-wr1-f72.google.com with SMTP id u4-20020a5d4684000000b0017c8c1de97dso288664wrq.16
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 00:41:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VouSXcSjiyGYNn3FCu9sQIbouxSYrC5qt0JuJCkXXDo=;
        b=4iPv8Isk7ZKpltVEwWmYGw1tncPglwtVt3vCQbvsUmLxYCeipAkFe2kLV56gt33mQZ
         HGiPI/jqa0uZ8h4W/EcrlmOFKX386SrGg3j35U9LXB73vrFDsfD/2al1w+LyEtJa6uNL
         xJ8gRHYtQ0+F1HXgqLp4K/BRZY2sBV3GeG66qzSZkCH7CRatRRjsRe6UOQhLd/A1o4Bg
         vxtCeHRf5eHnIM68hlNZEWuES/TQ/69A8Qjtgoeecd8qwFoPdoYlV+LR0LA0jt+eFhOZ
         p81uzAnMR1wnhUGR5QqcZQUT0VyLXLl3vsldzvQaO8Z7hCoMMK8F6PbiiZYEJhySNAh9
         BAMg==
X-Gm-Message-State: AOAM533D6T5j2r7vwF3MiwhpGoMN3d/Nos6AHDmR64YEFrRaxm9QK4AA
        nIqVLBN9dbDE0VHHM5JsUeuh7H/3uGuBqzMt8+AyvCH97nanG8mRzG/mAQnoxvwNBHQYm6OH0AE
        t/GMjDqZELRovsyVo
X-Received: by 2002:a05:600c:1ca0:: with SMTP id k32mr12939330wms.74.1637743286925;
        Wed, 24 Nov 2021 00:41:26 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzHrRPatgHKWjJef4sF+8GTkchQ05vfLoS9QW9gWF0BXYJdsxh+4676H3EyepKA6yptDaAT1Q==
X-Received: by 2002:a05:600c:1ca0:: with SMTP id k32mr12939289wms.74.1637743286687;
        Wed, 24 Nov 2021 00:41:26 -0800 (PST)
Received: from krava.redhat.com (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id o12sm20473649wrc.85.2021.11.24.00.41.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 00:41:26 -0800 (PST)
From:   Jiri Olsa <jolsa@redhat.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Ravi Bangoria <ravi.bangoria@amd.com>
Subject: [PATCH 1/8] perf/kprobe: Add support to create multiple probes
Date:   Wed, 24 Nov 2021 09:41:12 +0100
Message-Id: <20211124084119.260239-2-jolsa@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211124084119.260239-1-jolsa@kernel.org>
References: <20211124084119.260239-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding support to create multiple probes within single perf event.
This way we can associate single bpf program with multiple kprobes,
because bpf program gets associated with the perf event.

The perf_event_attr is not extended, current fields for kprobe
attachment are used for multi attachment.

For current kprobe atachment we use either:

   kprobe_func (in config1) + probe_offset (in config2)

to define kprobe by function name with offset, or:

   kprobe_addr (in config2)

to define kprobe with direct address value.

For multi probe attach the same fields point to array of values
with the same semantic. Each probe is defined as set of values
with the same array index (idx) as:

   kprobe_func[idx]  + probe_offset[idx]

to define kprobe by function name with offset, or:

   kprobe_addr[idx]

to define kprobe with direct address value.

The number of probes is passed in probe_cnt value, which shares
the union with wakeup_events/wakeup_watermark values which are
not used for kprobes.

Since [1] it's possible to stack multiple probes events under
one head event. Using the same code to allow that for probes
defined under perf kprobe interface.

[1] https://lore.kernel.org/lkml/156095682948.28024.14190188071338900568.stgit@devnote2/
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 include/uapi/linux/perf_event.h |   1 +
 kernel/trace/trace_event_perf.c | 106 ++++++++++++++++++++++++++++----
 kernel/trace/trace_kprobe.c     |  47 ++++++++++++--
 kernel/trace/trace_probe.c      |   2 +-
 kernel/trace/trace_probe.h      |   3 +-
 5 files changed, 138 insertions(+), 21 deletions(-)

diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index bd8860eeb291..eea80709d1ed 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -414,6 +414,7 @@ struct perf_event_attr {
 	union {
 		__u32		wakeup_events;	  /* wakeup every n events */
 		__u32		wakeup_watermark; /* bytes before wakeup   */
+		__u32		probe_cnt;	  /* number of [k,u] probes */
 	};
 
 	__u32			bp_type;
diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index a114549720d6..26078e40c299 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -245,23 +245,27 @@ void perf_trace_destroy(struct perf_event *p_event)
 }
 
 #ifdef CONFIG_KPROBE_EVENTS
-int perf_kprobe_init(struct perf_event *p_event, bool is_retprobe)
+static struct trace_event_call*
+kprobe_init(bool is_retprobe, u64 kprobe_func, u64 kprobe_addr,
+	    u64 probe_offset, struct trace_event_call *old)
 {
 	int ret;
 	char *func = NULL;
 	struct trace_event_call *tp_event;
 
-	if (p_event->attr.kprobe_func) {
+	if (kprobe_func) {
 		func = kzalloc(KSYM_NAME_LEN, GFP_KERNEL);
 		if (!func)
-			return -ENOMEM;
+			return ERR_PTR(-ENOMEM);
 		ret = strncpy_from_user(
-			func, u64_to_user_ptr(p_event->attr.kprobe_func),
+			func, u64_to_user_ptr(kprobe_func),
 			KSYM_NAME_LEN);
 		if (ret == KSYM_NAME_LEN)
 			ret = -E2BIG;
-		if (ret < 0)
-			goto out;
+		if (ret < 0) {
+			kfree(func);
+			return ERR_PTR(ret);
+		}
 
 		if (func[0] == '\0') {
 			kfree(func);
@@ -270,20 +274,96 @@ int perf_kprobe_init(struct perf_event *p_event, bool is_retprobe)
 	}
 
 	tp_event = create_local_trace_kprobe(
-		func, (void *)(unsigned long)(p_event->attr.kprobe_addr),
-		p_event->attr.probe_offset, is_retprobe);
-	if (IS_ERR(tp_event)) {
-		ret = PTR_ERR(tp_event);
-		goto out;
+		func, (void *)(unsigned long)(kprobe_addr),
+		probe_offset, is_retprobe, old);
+	kfree(func);
+	return tp_event;
+}
+
+static struct trace_event_call*
+kprobe_init_multi(struct perf_event *p_event, bool is_retprobe)
+{
+	void __user *kprobe_func = u64_to_user_ptr(p_event->attr.kprobe_func);
+	void __user *kprobe_addr = u64_to_user_ptr(p_event->attr.kprobe_addr);
+	u64 *funcs = NULL, *addrs = NULL, *offs = NULL;
+	struct trace_event_call *tp_event, *tp_old = NULL;
+	u32 i, cnt = p_event->attr.probe_cnt;
+	int ret = -EINVAL;
+	size_t size;
+
+	if (!cnt)
+		return ERR_PTR(-EINVAL);
+
+	size = cnt * sizeof(u64);
+	if (kprobe_func) {
+		ret = -ENOMEM;
+		funcs = kmalloc(size, GFP_KERNEL);
+		if (!funcs)
+			goto out;
+		ret = -EFAULT;
+		if (copy_from_user(funcs, kprobe_func, size))
+			goto out;
+	}
+
+	if (kprobe_addr) {
+		ret = -ENOMEM;
+		addrs = kmalloc(size, GFP_KERNEL);
+		if (!addrs)
+			goto out;
+		ret = -EFAULT;
+		if (copy_from_user(addrs, kprobe_addr, size))
+			goto out;
+		/* addresses and ofsets share the same array */
+		offs = addrs;
 	}
 
+	for (i = 0; i < cnt; i++) {
+		tp_event = kprobe_init(is_retprobe, funcs ? funcs[i] : 0,
+				       addrs ? addrs[i] : 0, offs ? offs[i] : 0,
+				       tp_old);
+		if (IS_ERR(tp_event)) {
+			if (tp_old)
+				destroy_local_trace_kprobe(tp_old);
+			ret = PTR_ERR(tp_event);
+			goto out;
+		}
+		if (!tp_old)
+			tp_old = tp_event;
+	}
+	ret = 0;
+out:
+	kfree(funcs);
+	kfree(addrs);
+	return ret ? ERR_PTR(ret) : tp_old;
+}
+
+static struct trace_event_call*
+kprobe_init_single(struct perf_event *p_event, bool is_retprobe)
+{
+	struct perf_event_attr *attr = &p_event->attr;
+
+	return kprobe_init(is_retprobe, attr->kprobe_func, attr->kprobe_addr,
+			   attr->probe_offset, NULL);
+}
+
+int perf_kprobe_init(struct perf_event *p_event, bool is_retprobe)
+{
+	struct trace_event_call *tp_event;
+	int ret;
+
+	if (p_event->attr.probe_cnt)
+		tp_event = kprobe_init_multi(p_event, is_retprobe);
+	else
+		tp_event = kprobe_init_single(p_event, is_retprobe);
+
+	if (IS_ERR(tp_event))
+		return PTR_ERR(tp_event);
+
 	mutex_lock(&event_mutex);
 	ret = perf_trace_event_init(tp_event, p_event);
 	if (ret)
 		destroy_local_trace_kprobe(tp_event);
 	mutex_unlock(&event_mutex);
-out:
-	kfree(func);
 	return ret;
 }
 
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 33272a7b6912..86a7aada853a 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -237,13 +237,18 @@ static int kprobe_dispatcher(struct kprobe *kp, struct pt_regs *regs);
 static int kretprobe_dispatcher(struct kretprobe_instance *ri,
 				struct pt_regs *regs);
 
+static void __free_trace_kprobe(struct trace_kprobe *tk)
+{
+	kfree(tk->symbol);
+	free_percpu(tk->nhit);
+	kfree(tk);
+}
+
 static void free_trace_kprobe(struct trace_kprobe *tk)
 {
 	if (tk) {
 		trace_probe_cleanup(&tk->tp);
-		kfree(tk->symbol);
-		free_percpu(tk->nhit);
-		kfree(tk);
+		__free_trace_kprobe(tk);
 	}
 }
 
@@ -1796,7 +1801,7 @@ static int unregister_kprobe_event(struct trace_kprobe *tk)
 /* create a trace_kprobe, but don't add it to global lists */
 struct trace_event_call *
 create_local_trace_kprobe(char *func, void *addr, unsigned long offs,
-			  bool is_return)
+			  bool is_return, struct trace_event_call *old)
 {
 	enum probe_print_type ptype;
 	struct trace_kprobe *tk;
@@ -1820,6 +1825,28 @@ create_local_trace_kprobe(char *func, void *addr, unsigned long offs,
 		return ERR_CAST(tk);
 	}
 
+	if (old) {
+		struct trace_kprobe *tk_old;
+
+		tk_old = trace_kprobe_primary_from_call(old);
+		if (!tk_old) {
+			ret = -EINVAL;
+			goto error;
+		}
+
+		/* Append to existing event */
+		ret = trace_probe_append(&tk->tp, &tk_old->tp);
+		if (ret)
+			goto error;
+
+		/* Register k*probe */
+		ret = __register_trace_kprobe(tk);
+		if (ret)
+			goto error;
+
+		return trace_probe_event_call(&tk->tp);
+	}
+
 	init_trace_event_call(tk);
 
 	ptype = trace_kprobe_is_return(tk) ?
@@ -1841,6 +1868,8 @@ create_local_trace_kprobe(char *func, void *addr, unsigned long offs,
 
 void destroy_local_trace_kprobe(struct trace_event_call *event_call)
 {
+	struct trace_probe_event *event;
+	struct trace_probe *pos, *tmp;
 	struct trace_kprobe *tk;
 
 	tk = trace_kprobe_primary_from_call(event_call);
@@ -1852,9 +1881,15 @@ void destroy_local_trace_kprobe(struct trace_event_call *event_call)
 		return;
 	}
 
-	__unregister_trace_kprobe(tk);
+	event = tk->tp.event;
+	list_for_each_entry_safe(pos, tmp, &event->probes, list) {
+		tk = container_of(pos, struct trace_kprobe, tp);
+		list_del_init(&pos->list);
+		__unregister_trace_kprobe(tk);
+		__free_trace_kprobe(tk);
+	}
 
-	free_trace_kprobe(tk);
+	trace_probe_event_free(event);
 }
 #endif /* CONFIG_PERF_EVENTS */
 
diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index 3ed2a3f37297..2dff85aa21e9 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -974,7 +974,7 @@ int traceprobe_define_arg_fields(struct trace_event_call *event_call,
 	return 0;
 }
 
-static void trace_probe_event_free(struct trace_probe_event *tpe)
+void trace_probe_event_free(struct trace_probe_event *tpe)
 {
 	kfree(tpe->class.system);
 	kfree(tpe->call.name);
diff --git a/kernel/trace/trace_probe.h b/kernel/trace/trace_probe.h
index 99e7a5df025e..ba8e46c7efe8 100644
--- a/kernel/trace/trace_probe.h
+++ b/kernel/trace/trace_probe.h
@@ -333,6 +333,7 @@ int trace_probe_init(struct trace_probe *tp, const char *event,
 		     const char *group, bool alloc_filter);
 void trace_probe_cleanup(struct trace_probe *tp);
 int trace_probe_append(struct trace_probe *tp, struct trace_probe *to);
+void trace_probe_event_free(struct trace_probe_event *tpe);
 void trace_probe_unlink(struct trace_probe *tp);
 int trace_probe_register_event_call(struct trace_probe *tp);
 int trace_probe_add_file(struct trace_probe *tp, struct trace_event_file *file);
@@ -377,7 +378,7 @@ extern int traceprobe_set_print_fmt(struct trace_probe *tp, enum probe_print_typ
 #ifdef CONFIG_PERF_EVENTS
 extern struct trace_event_call *
 create_local_trace_kprobe(char *func, void *addr, unsigned long offs,
-			  bool is_return);
+			  bool is_return, struct trace_event_call *old);
 extern void destroy_local_trace_kprobe(struct trace_event_call *event_call);
 
 extern struct trace_event_call *
-- 
2.33.1

