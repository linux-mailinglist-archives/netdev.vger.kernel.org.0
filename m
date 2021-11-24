Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF5D45B6C9
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 09:43:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241595AbhKXIqZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 03:46:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44948 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241435AbhKXIpH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 03:45:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637743317;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=miD27XMNAQX20tQlwxUdiFwuYzd6DEbiAXCQZyLHmF0=;
        b=YNU0bO0eo8wLFvUiHuoA902StIYQe72UGaI39BIOLiwpYmEZss3b81ElrcnAl5x2y4CkD9
        52rhn1VGWj9FYs2UfbXq6knpNXQi0kOCasebmlzyRjSij1OtCcnhGmVYLGntrZKNeQRozv
        0JW/+CybzwsH3XiKf10+D0HvKKYVfmY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-286-B21hozlANPORcVfzQAkenA-1; Wed, 24 Nov 2021 03:41:53 -0500
X-MC-Unique: B21hozlANPORcVfzQAkenA-1
Received: by mail-wr1-f70.google.com with SMTP id h7-20020adfaa87000000b001885269a937so290002wrc.17
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 00:41:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=miD27XMNAQX20tQlwxUdiFwuYzd6DEbiAXCQZyLHmF0=;
        b=jCn9gws2czm/zFWoiL/TihedmY1v2bQN4qbMh1VZzEcN7DVeNQcFAtzXbTd/Eysthn
         ufIylTZU+LpimIVdFoN64CAU4TR1sKk4+VN4SuXNeVnSk+qjBIlMXvCxHsueqMhDYAa2
         SnbeTxSt9IJWSvua+QvikTWJr0SwXH4Vuls9loIV+CCcRaGcwCu9xO0eAp72qF/W/oxJ
         231/9s40FHQl8q7K9LA7ErAKWPyx9rUBgzPH6nP3DEItpVAkppIyLS53BZOc5B7ZwYsB
         pbqKpDkZfcfaFptWSfLUcuMPPG9FXZ755V70H2dFpnCYm0pBwYserj80xExRcAc51dNm
         tHHQ==
X-Gm-Message-State: AOAM533VHodFy+HEx7f9nRsUIq1pcRy6CcsNv4gfAEfFLXekoQ2xujQC
        J1bXTNANKRzsxErmBsKDpYMotJYWMmwUqLo3V+GOokBH+RjO8+FvgPCn4q6eNazFvOvgcvrM30l
        vuyQ0jPpEcLWXlBHt
X-Received: by 2002:a7b:c119:: with SMTP id w25mr12662426wmi.70.1637743311870;
        Wed, 24 Nov 2021 00:41:51 -0800 (PST)
X-Google-Smtp-Source: ABdhPJys9b9shmlC+yWyQlkAXSnONwW8ns8tn4LbW4PScL3CEQ4SJ7TleKl0TMJaBFZl8dBf5EvPjA==
X-Received: by 2002:a7b:c119:: with SMTP id w25mr12662393wmi.70.1637743311648;
        Wed, 24 Nov 2021 00:41:51 -0800 (PST)
Received: from krava.redhat.com (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id b6sm3955860wmq.45.2021.11.24.00.41.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 00:41:51 -0800 (PST)
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
Subject: [PATCH 5/8] libbpf: Add support to attach multiple [ku]probes
Date:   Wed, 24 Nov 2021 09:41:16 +0100
Message-Id: <20211124084119.260239-6-jolsa@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211124084119.260239-1-jolsa@kernel.org>
References: <20211124084119.260239-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding support to attach multiple [ku]probes.

Extending both bpf_kprobe_opts and bpf_uprobe_opts structs
with config values to define multiple probes within single
bpf_program__attach_[ku]probe_opts call.

For mutiple probes in bpf_program__attach_kprobe_opts function
the 'func_name' argument is ignored and probes are defined in
bpf_kprobe_opts struct with:

  struct {
          /* probes count */
          __u32 cnt;
          /* function names array */
          char **funcs;
          /* address/offset values array */
          union {
                  __u64 *addrs;
                  __u64 *offs;
          };
  } multi;

For mutiple probes in bpf_program__attach_uprobe_opts function
both 'binary_path' and 'func_offset' arguments are ignored and
probes are defined in bpf_kprobe_opts struct with:

  /* multi uprobe values */
  struct {
          /* probes count */
          __u32 cnt;
          /* paths names array */
          const char **paths;
          /* offsets values array */
          __u64 *offs;
  } multi;

The multiple probes attachment is enabled when multi.cnt != 0.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/include/uapi/linux/perf_event.h |  1 +
 tools/lib/bpf/libbpf.c                | 30 +++++++++++++++++++++++++--
 tools/lib/bpf/libbpf.h                | 25 ++++++++++++++++++++--
 3 files changed, 52 insertions(+), 4 deletions(-)

diff --git a/tools/include/uapi/linux/perf_event.h b/tools/include/uapi/linux/perf_event.h
index bd8860eeb291..eea80709d1ed 100644
--- a/tools/include/uapi/linux/perf_event.h
+++ b/tools/include/uapi/linux/perf_event.h
@@ -414,6 +414,7 @@ struct perf_event_attr {
 	union {
 		__u32		wakeup_events;	  /* wakeup every n events */
 		__u32		wakeup_watermark; /* bytes before wakeup   */
+		__u32		probe_cnt;	  /* number of [k,u] probes */
 	};
 
 	__u32			bp_type;
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 34219a0c39a7..b570e93de735 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -9631,6 +9631,11 @@ struct perf_event_open_args {
 	uint64_t offset;
 	int pid;
 	size_t ref_ctr_off;
+	struct {
+		__u32 probe_cnt;
+		__u64 config1;
+		__u64 config2;
+	} multi;
 };
 
 static int perf_event_open_probe(bool uprobe, struct perf_event_open_args *args)
@@ -9667,8 +9672,15 @@ static int perf_event_open_probe(bool uprobe, struct perf_event_open_args *args)
 	attr.size = sizeof(attr);
 	attr.type = type;
 	attr.config |= (__u64)ref_ctr_off << PERF_UPROBE_REF_CTR_OFFSET_SHIFT;
-	attr.config1 = ptr_to_u64(args->name); /* kprobe_func or uprobe_path */
-	attr.config2 = args->offset;		 /* kprobe_addr or probe_offset */
+
+	if (args->multi.probe_cnt) {
+		attr.probe_cnt = args->multi.probe_cnt;
+		attr.config1 = args->multi.config1;
+		attr.config2 = args->multi.config2;
+	} else {
+		attr.config1 = ptr_to_u64(args->name); /* kprobe_func or uprobe_path */
+		attr.config2 = args->offset;	       /* kprobe_addr or probe_offset */
+	}
 
 	/* pid filter is meaningful only for uprobes */
 	pfd = syscall(__NR_perf_event_open, &attr,
@@ -9807,7 +9819,14 @@ bpf_program__attach_kprobe_opts(const struct bpf_program *prog,
 			.pid = -1,
 			.ref_ctr_off = 0,
 		};
+		__u32 probe_cnt = OPTS_GET(opts, multi.cnt, false);
 
+		if (probe_cnt) {
+			args.multi.probe_cnt = probe_cnt;
+			args.multi.config1 = ptr_to_u64(OPTS_GET(opts, multi.funcs, false));
+			/* multi.addrs and multi.offs share the same array */
+			args.multi.config2 = ptr_to_u64(OPTS_GET(opts, multi.addrs, false));
+		}
 		pfd = perf_event_open_probe(false /* uprobe */, &args);
 	} else {
 		char probe_name[256];
@@ -10006,6 +10025,13 @@ bpf_program__attach_uprobe_opts(const struct bpf_program *prog, pid_t pid,
 			.pid = pid,
 			.ref_ctr_off = ref_ctr_off,
 		};
+		__u32 probe_cnt = OPTS_GET(opts, multi.cnt, false);
+
+		if (probe_cnt) {
+			args.multi.probe_cnt = probe_cnt;
+			args.multi.config1 = ptr_to_u64(OPTS_GET(opts, multi.paths, false));
+			args.multi.config2 = ptr_to_u64(OPTS_GET(opts, multi.offs, false));
+		}
 
 		pfd = perf_event_open_probe(true /* uprobe */, &args);
 	} else {
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index d02139fec4ac..ae072882b5dd 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -321,9 +321,21 @@ struct bpf_kprobe_opts {
 	size_t offset;
 	/* kprobe is return probe */
 	bool retprobe;
+	/* multi kprobe values */
+	struct {
+		/* probes count */
+		__u32 cnt;
+		/* function names array */
+		char **funcs;
+		/* address/offset values array */
+		union {
+			__u64 *addrs;
+			__u64 *offs;
+		};
+	} multi;
 	size_t :0;
 };
-#define bpf_kprobe_opts__last_field retprobe
+#define bpf_kprobe_opts__last_field multi.addrs
 
 LIBBPF_API struct bpf_link *
 bpf_program__attach_kprobe(const struct bpf_program *prog, bool retprobe,
@@ -344,9 +356,18 @@ struct bpf_uprobe_opts {
 	__u64 bpf_cookie;
 	/* uprobe is return probe, invoked at function return time */
 	bool retprobe;
+	/* multi uprobe values */
+	struct {
+		/* probes count */
+		__u32 cnt;
+		/* paths names array */
+		const char **paths;
+		/* offsets values array */
+		__u64 *offs;
+	} multi;
 	size_t :0;
 };
-#define bpf_uprobe_opts__last_field retprobe
+#define bpf_uprobe_opts__last_field multi.offs
 
 LIBBPF_API struct bpf_link *
 bpf_program__attach_uprobe(const struct bpf_program *prog, bool retprobe,
-- 
2.33.1

