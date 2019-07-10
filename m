Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FCC5647FA
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 16:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727885AbfGJOQD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 10:16:03 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:42763 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727421AbfGJOQB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 10:16:01 -0400
Received: by mail-pf1-f196.google.com with SMTP id q10so1168110pff.9
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 07:16:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=98vQqac6N+4BDAWZ6eZd2FQ5tBz4a8s/ZIoQ2kqYqQU=;
        b=jT4rr1dRIIdkKbYCMVTHZ2jKpCD13OQ/g/idVRGQ/vM8Hhd00Xsma2pTkwoIGRALKP
         x68FvAFXmQBZ6S2Qi2SPDHxjnppLoAFpyb3FTLxg/USKswIOdGBQigG+QfVdUa434Ja6
         GC2ykyqsyvETZsJEuquXZfNrr/rdVrerBxtaw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=98vQqac6N+4BDAWZ6eZd2FQ5tBz4a8s/ZIoQ2kqYqQU=;
        b=m3dcNBh3ItAiJVSRH/OSlmn8Vuj+tBha/GW0XsMXd85BIfgZxuciTt83Txd+lUwO3o
         X0bJl/9PNQIwReH3cOba6IVydEFfpO7Lru+8/813f+/8s7k71XxGlWfo+Jt9xV980aii
         V/Fz7jw6hf7Su/dFactL0Jl7f1Hd9+hForaPFCdFIKNf8JktQSLS6EgXwm7bHydJzFpS
         kbQLnUIroQmy8YW4Snp8tH1qIcaMitJmvst5+LCn0b28GOc9ndpZ/aTX3AyAmEAeKh9j
         MwuD81neQv8r3W3QPB6SlGxu+iV4e6h0Dp1I3eyPDHohzIahWUnN5G+woU+9AW7pLtim
         2qoA==
X-Gm-Message-State: APjAAAXBBvBxZV5urnPmIL/5XsjQqBqrhuwuii6HpvHMpMgAFOuk4Ei0
        uqbbda6wVpr1WapA+SkRKNebHg==
X-Google-Smtp-Source: APXvYqyVj2COh2XkJL7w391puzrxf+GO5LeBkj/huVRuoJfj6uXECXP7PK41v0m8skcXqm2b1c+vuw==
X-Received: by 2002:a63:b904:: with SMTP id z4mr1266112pge.388.1562768160724;
        Wed, 10 Jul 2019 07:16:00 -0700 (PDT)
Received: from joelaf.cam.corp.google.com ([2620:15c:6:12:9c46:e0da:efbf:69cc])
        by smtp.gmail.com with ESMTPSA id l124sm2589249pgl.54.2019.07.10.07.15.57
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 10 Jul 2019 07:16:00 -0700 (PDT)
From:   "Joel Fernandes (Google)" <joel@joelfernandes.org>
To:     linux-kernel@vger.kernel.org
Cc:     "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        Adrian Ratiu <adrian.ratiu@collabora.com>,
        Alexei Starovoitov <ast@kernel.org>, bpf@vger.kernel.org,
        Brendan Gregg <brendan.d.gregg@gmail.com>, connoro@google.com,
        Daniel Borkmann <daniel@iogearbox.net>,
        duyuchao <yuchao.du@unisoc.com>, Ingo Molnar <mingo@redhat.com>,
        jeffv@google.com, Karim Yaghmour <karim.yaghmour@opersys.com>,
        kernel-team@android.com, linux-kselftest@vger.kernel.org,
        Manali Shukla <manalishukla14@gmail.com>,
        Manjo Raja Rao <linux@manojrajarao.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Matt Mullins <mmullins@fb.com>,
        Michal Gregorczyk <michalgr@fb.com>,
        Michal Gregorczyk <michalgr@live.com>,
        Mohammad Husain <russoue@gmail.com>, namhyung@google.com,
        namhyung@kernel.org, netdev@vger.kernel.org,
        paul.chaignon@gmail.com, primiano@google.com,
        Qais Yousef <qais.yousef@arm.com>,
        Shuah Khan <shuah@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Srinivas Ramana <sramana@codeaurora.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tamir Carmeli <carmeli.tamir@gmail.com>,
        Yonghong Song <yhs@fb.com>
Subject: [PATCH RFC 1/4] Move bpf_raw_tracepoint functionality into bpf_trace.c
Date:   Wed, 10 Jul 2019 10:15:45 -0400
Message-Id: <20190710141548.132193-2-joel@joelfernandes.org>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
In-Reply-To: <20190710141548.132193-1-joel@joelfernandes.org>
References: <20190710141548.132193-1-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation to use raw tracepoints for BPF directly from ftrace, move
the bpf_raw_tracepoint functionality into bpf_trace.c

Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
---
 include/linux/bpf_trace.h   | 10 ++++++
 kernel/bpf/syscall.c        | 69 ++++++-------------------------------
 kernel/trace/bpf_trace.c    | 56 ++++++++++++++++++++++++++++++
 kernel/trace/trace_events.c |  3 ++
 4 files changed, 80 insertions(+), 58 deletions(-)

diff --git a/include/linux/bpf_trace.h b/include/linux/bpf_trace.h
index ddf896abcfb6..4a593827fd87 100644
--- a/include/linux/bpf_trace.h
+++ b/include/linux/bpf_trace.h
@@ -4,4 +4,14 @@
 
 #include <trace/events/xdp.h>
 
+#define BPF_RAW_TRACEPOINT_OPEN_LAST_FIELD raw_tracepoint.prog_fd
+
+struct bpf_raw_tracepoint {
+	struct bpf_raw_event_map *btp;
+	struct bpf_prog *prog;
+};
+
+struct bpf_raw_tracepoint *bpf_raw_tracepoint_open(char *tp_name, int prog_fd);
+void bpf_raw_tracepoint_close(struct bpf_raw_tracepoint *tp);
+
 #endif /* __LINUX_BPF_TRACE_H__ */
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 42d17f730780..2001949b33f1 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1737,21 +1737,11 @@ static int bpf_obj_get(const union bpf_attr *attr)
 				attr->file_flags);
 }
 
-struct bpf_raw_tracepoint {
-	struct bpf_raw_event_map *btp;
-	struct bpf_prog *prog;
-};
-
 static int bpf_raw_tracepoint_release(struct inode *inode, struct file *filp)
 {
 	struct bpf_raw_tracepoint *raw_tp = filp->private_data;
 
-	if (raw_tp->prog) {
-		bpf_probe_unregister(raw_tp->btp, raw_tp->prog);
-		bpf_prog_put(raw_tp->prog);
-	}
-	bpf_put_raw_tracepoint(raw_tp->btp);
-	kfree(raw_tp);
+	bpf_raw_tracepoint_close(raw_tp);
 	return 0;
 }
 
@@ -1761,64 +1751,27 @@ static const struct file_operations bpf_raw_tp_fops = {
 	.write		= bpf_dummy_write,
 };
 
-#define BPF_RAW_TRACEPOINT_OPEN_LAST_FIELD raw_tracepoint.prog_fd
-
-static int bpf_raw_tracepoint_open(const union bpf_attr *attr)
+static int bpf_raw_tracepoint_open_syscall(const union bpf_attr *attr)
 {
-	struct bpf_raw_tracepoint *raw_tp;
-	struct bpf_raw_event_map *btp;
-	struct bpf_prog *prog;
+	int tp_fd;
 	char tp_name[128];
-	int tp_fd, err;
+	struct bpf_raw_tracepoint *raw_tp;
 
 	if (strncpy_from_user(tp_name, u64_to_user_ptr(attr->raw_tracepoint.name),
 			      sizeof(tp_name) - 1) < 0)
 		return -EFAULT;
 	tp_name[sizeof(tp_name) - 1] = 0;
 
-	btp = bpf_get_raw_tracepoint(tp_name);
-	if (!btp)
-		return -ENOENT;
-
-	raw_tp = kzalloc(sizeof(*raw_tp), GFP_USER);
-	if (!raw_tp) {
-		err = -ENOMEM;
-		goto out_put_btp;
-	}
-	raw_tp->btp = btp;
-
-	prog = bpf_prog_get(attr->raw_tracepoint.prog_fd);
-	if (IS_ERR(prog)) {
-		err = PTR_ERR(prog);
-		goto out_free_tp;
-	}
-	if (prog->type != BPF_PROG_TYPE_RAW_TRACEPOINT &&
-	    prog->type != BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE) {
-		err = -EINVAL;
-		goto out_put_prog;
-	}
-
-	err = bpf_probe_register(raw_tp->btp, prog);
-	if (err)
-		goto out_put_prog;
+	raw_tp = bpf_raw_tracepoint_open(tp_name, attr->raw_tracepoint.prog_fd);
+	if (IS_ERR(raw_tp))
+		return PTR_ERR(raw_tp);
 
-	raw_tp->prog = prog;
 	tp_fd = anon_inode_getfd("bpf-raw-tracepoint", &bpf_raw_tp_fops, raw_tp,
 				 O_CLOEXEC);
-	if (tp_fd < 0) {
-		bpf_probe_unregister(raw_tp->btp, prog);
-		err = tp_fd;
-		goto out_put_prog;
-	}
-	return tp_fd;
+	if (tp_fd < 0)
+		bpf_probe_unregister(raw_tp->btp, raw_tp->prog);
 
-out_put_prog:
-	bpf_prog_put(prog);
-out_free_tp:
-	kfree(raw_tp);
-out_put_btp:
-	bpf_put_raw_tracepoint(btp);
-	return err;
+	return tp_fd;
 }
 
 static int bpf_prog_attach_check_attach_type(const struct bpf_prog *prog,
@@ -2848,7 +2801,7 @@ SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, siz
 		err = bpf_obj_get_info_by_fd(&attr, uattr);
 		break;
 	case BPF_RAW_TRACEPOINT_OPEN:
-		err = bpf_raw_tracepoint_open(&attr);
+		err = bpf_raw_tracepoint_open_syscall(&attr);
 		break;
 	case BPF_BTF_LOAD:
 		err = bpf_btf_load(&attr);
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 1c9a4745e596..c4b543bc617f 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -7,6 +7,7 @@
 #include <linux/slab.h>
 #include <linux/bpf.h>
 #include <linux/bpf_perf_event.h>
+#include <linux/bpf_trace.h>
 #include <linux/filter.h>
 #include <linux/uaccess.h>
 #include <linux/ctype.h>
@@ -1413,3 +1414,58 @@ static int __init bpf_event_init(void)
 
 fs_initcall(bpf_event_init);
 #endif /* CONFIG_MODULES */
+
+void bpf_raw_tracepoint_close(struct bpf_raw_tracepoint *raw_tp)
+{
+	if (raw_tp->prog) {
+		bpf_probe_unregister(raw_tp->btp, raw_tp->prog);
+		bpf_prog_put(raw_tp->prog);
+	}
+	bpf_put_raw_tracepoint(raw_tp->btp);
+	kfree(raw_tp);
+}
+
+struct bpf_raw_tracepoint *bpf_raw_tracepoint_open(char *tp_name, int prog_fd)
+{
+	struct bpf_raw_tracepoint *raw_tp;
+	struct bpf_raw_event_map *btp;
+	struct bpf_prog *prog;
+	int err;
+
+	btp = bpf_get_raw_tracepoint(tp_name);
+	if (!btp)
+		return ERR_PTR(-ENOENT);
+
+	raw_tp = kzalloc(sizeof(*raw_tp), GFP_USER);
+	if (!raw_tp) {
+		err = -ENOMEM;
+		goto out_put_btp;
+	}
+	raw_tp->btp = btp;
+
+	prog = bpf_prog_get(prog_fd);
+	if (IS_ERR(prog)) {
+		err = PTR_ERR(prog);
+		goto out_free_tp;
+	}
+	if (prog->type != BPF_PROG_TYPE_RAW_TRACEPOINT &&
+	    prog->type != BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE) {
+		err = -EINVAL;
+		goto out_put_prog;
+	}
+
+	err = bpf_probe_register(raw_tp->btp, prog);
+	if (err)
+		goto out_put_prog;
+
+	raw_tp->prog = prog;
+	return raw_tp;
+
+out_put_prog:
+	bpf_prog_put(prog);
+out_free_tp:
+	kfree(raw_tp);
+out_put_btp:
+	bpf_put_raw_tracepoint(btp);
+	return ERR_PTR(err);
+}
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 0ce3db67f556..67851fb66b6b 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -2017,6 +2017,9 @@ event_create_dir(struct dentry *parent, struct trace_event_file *file)
 
 		trace_create_file("trigger", 0644, file->dir, file,
 				  &event_trigger_fops);
+
+		trace_create_file("bpf_attach", 0644, file->dir, file,
+				  &bpf_attach_trigger_fops);
 	}
 
 #ifdef CONFIG_HIST_TRIGGERS
-- 
2.22.0.410.gd8fdbe21b5-goog

