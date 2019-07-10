Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2668B64800
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 16:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727913AbfGJOQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 10:16:11 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:46683 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727912AbfGJOQJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 10:16:09 -0400
Received: by mail-pf1-f193.google.com with SMTP id c73so1161442pfb.13
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 07:16:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qaZWTPLSZP/SuE1pr+x4mGiPN4X4stJUVD9vrV0URR8=;
        b=GwgIjykLh5eqei88bOMpZHwO9qvLmQGem/1teyQxrRIg3YrPgEf4AC8HboS8y7PhCl
         sy7rYfBqLYAeSY65gUJlTPXjcgqU4IhpXMXWiHRkx7xCL6pL55RQehoZUGCSFc9yfrSt
         fHOMiuneC4CLBcIHhOEHHaXtAta0bdXQkhlFM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qaZWTPLSZP/SuE1pr+x4mGiPN4X4stJUVD9vrV0URR8=;
        b=K9c1iZFpVUbIR8tmOUaTIWW/reS4z/4gK7tRPcblPj4UJqXEQMGhCaaqoWQ+cTKZGi
         oHF0RgDTE2EShxncbsGstsG1XZ65C9SYQJBeMjNb9c2v4NWU31jOYvQOSQjJB55QG6d1
         XIH4vArgG3xo6htM1u3xPWvXVaM5pygdd6ud43mXOzeUnsYwqaeMz2kwfA2ocV9/62uX
         pvFrde+P52P+c6wdsTZywZzeKgZb/5Rkw1+NNpqDgTDxAIsxv2V0lggqe54P6aeRjX+r
         sAscZZdyBETdZPdGmWNvys89o538qPeOfm1WxHw/DOLoGqGJkGJTFxTjHuHSFZTldqdx
         4RZQ==
X-Gm-Message-State: APjAAAX7PghUCi49cIhd5aCtAuB2kza6XP5lsg8eJcLcdL2muv9id7aE
        c09MF7SiKRSMupPU7mWEKec=
X-Google-Smtp-Source: APXvYqzQgccO1TM8KZRW5WDsyupbUc+d49Jul12Ceh/xECkPSx2c0EUIk9dUXzEvGjVaaXChliSSdA==
X-Received: by 2002:a17:90a:bb94:: with SMTP id v20mr7412797pjr.88.1562768168516;
        Wed, 10 Jul 2019 07:16:08 -0700 (PDT)
Received: from joelaf.cam.corp.google.com ([2620:15c:6:12:9c46:e0da:efbf:69cc])
        by smtp.gmail.com with ESMTPSA id l124sm2589249pgl.54.2019.07.10.07.16.04
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 10 Jul 2019 07:16:07 -0700 (PDT)
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
Subject: [PATCH RFC 3/4] lib/bpf: Add support for ftrace event attach and detach
Date:   Wed, 10 Jul 2019 10:15:47 -0400
Message-Id: <20190710141548.132193-4-joel@joelfernandes.org>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
In-Reply-To: <20190710141548.132193-1-joel@joelfernandes.org>
References: <20190710141548.132193-1-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the needed library support in this commit.

Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
---
 tools/lib/bpf/bpf.c      | 53 ++++++++++++++++++++++++++++++++++++++++
 tools/lib/bpf/bpf.h      |  4 +++
 tools/lib/bpf/libbpf.map |  2 ++
 3 files changed, 59 insertions(+)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index c4a48086dc9a..28c5a7d00d14 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -24,6 +24,9 @@
 #include <stdlib.h>
 #include <string.h>
 #include <memory.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
 #include <unistd.h>
 #include <asm/unistd.h>
 #include <linux/bpf.h>
@@ -57,6 +60,8 @@
 #define min(x, y) ((x) < (y) ? (x) : (y))
 #endif
 
+#define TRACEFS "/sys/kernel/debug/tracing"
+
 static inline __u64 ptr_to_u64(const void *ptr)
 {
 	return (__u64) (unsigned long) ptr;
@@ -658,6 +663,54 @@ int bpf_raw_tracepoint_open(const char *name, int prog_fd)
 	return sys_bpf(BPF_RAW_TRACEPOINT_OPEN, &attr, sizeof(attr));
 }
 
+int bpf_raw_tracepoint_ftrace_attach(const char *subsys, const char *name,
+				     int prog_fd)
+{
+	char buf[256];
+	int len, ret, tfd;
+
+	sprintf(buf, "%s/events/%s/%s/bpf", TRACEFS, subsys, name);
+	tfd = open(buf, O_WRONLY);
+	if (tfd < 0)
+		return tfd;
+
+	sprintf(buf, "attach:%d", prog_fd);
+	len = strlen(buf);
+	ret = write(tfd, buf, len);
+
+	if (ret < 0)
+		goto err;
+	if (ret != len)
+		ret = -1;
+err:
+	close(tfd);
+	return ret;
+}
+
+int bpf_raw_tracepoint_ftrace_detach(const char *subsys, const char *name,
+				     int prog_fd)
+{
+	char buf[256];
+	int len, ret, tfd;
+
+	sprintf(buf, "%s/events/%s/%s/bpf", TRACEFS, subsys, name);
+	tfd = open(buf, O_WRONLY);
+	if (tfd < 0)
+		return tfd;
+
+	sprintf(buf, "detach:%d", prog_fd);
+	len = strlen(buf);
+	ret = write(tfd, buf, len);
+
+	if (ret < 0)
+		goto err;
+	if (ret != len)
+		ret = -1;
+err:
+	close(tfd);
+	return ret;
+}
+
 int bpf_load_btf(void *btf, __u32 btf_size, char *log_buf, __u32 log_buf_size,
 		 bool do_log)
 {
diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
index 9593fec75652..5b9c44658037 100644
--- a/tools/lib/bpf/bpf.h
+++ b/tools/lib/bpf/bpf.h
@@ -163,6 +163,10 @@ LIBBPF_API int bpf_prog_query(int target_fd, enum bpf_attach_type type,
 			      __u32 query_flags, __u32 *attach_flags,
 			      __u32 *prog_ids, __u32 *prog_cnt);
 LIBBPF_API int bpf_raw_tracepoint_open(const char *name, int prog_fd);
+LIBBPF_API int bpf_raw_tracepoint_ftrace_attach(const char *subsys,
+						const char *name, int prog_fd);
+LIBBPF_API int bpf_raw_tracepoint_ftrace_detach(const char *subsys,
+						const char *name, int prog_fd);
 LIBBPF_API int bpf_load_btf(void *btf, __u32 btf_size, char *log_buf,
 			    __u32 log_buf_size, bool do_log);
 LIBBPF_API int bpf_task_fd_query(int pid, int fd, __u32 flags, char *buf,
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 673001787cba..fca377b688c2 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -163,4 +163,6 @@ LIBBPF_0.0.3 {
 		bpf_map__is_internal;
 		bpf_map_freeze;
 		btf__finalize_data;
+		bpf_raw_tracepoint_ftrace_attach;
+		bpf_raw_tracepoint_ftrace_detach;
 } LIBBPF_0.0.2;
-- 
2.22.0.410.gd8fdbe21b5-goog

