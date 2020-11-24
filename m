Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 605082C20CF
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 10:05:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731029AbgKXJDr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 04:03:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731020AbgKXJDo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 04:03:44 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5913AC0617A6;
        Tue, 24 Nov 2020 01:03:44 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id s2so10365388plr.9;
        Tue, 24 Nov 2020 01:03:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Y4w/C+u9mn3PS9LuGNFM8q1NWwoA/E6dAzHcv8xL7lg=;
        b=FZ5wkOcfMOLqIjyfk+GGcyNEEHS1l/7bkOrqkqb0q1l1Y6RTJgPfCNXMh3mqkG9BL9
         sol9W18pSf2+q+hQNVni0fR9WCxpZIDMYjgqYkMAfNHP4qGHGy6RhiIK3Iv4CM/qpnaH
         PLrMkDgvvlt5EPwMHAl0PpGqDmoxK+JqWGJxb4795vxhi0TKFGKosm97/rMGahTLS97w
         BoNhNPFwGfooB/CKCEw8AkgoQ+iSb3zJKg76tT/PAdB5hWqcrcf/janZ+IPuOelaY9pC
         DiIC4/ziPfGNyl9DKoWKseyU1zmAacdLvi75+CvvOBkiYLUgDWXHNkTFDqDaZvTR4eNP
         DeGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Y4w/C+u9mn3PS9LuGNFM8q1NWwoA/E6dAzHcv8xL7lg=;
        b=EhSWjKkx+Ve8k/MSlLtNMkOClULiHohlMQe9lv4INFz9WNL4dsAUrNQA8C1LkUQT24
         RQ9RthfEFCTFB24jdzCpRdw7sB4uP3CJ2aHedfOXfUisoS9i/El6je9ZUGplPF1mQaW1
         WRnsqIJGq+x7AhggATNSxELbrUS4s7GopbIxTfnedSL4SNYI0CzdMm7e8oHgyjv5+jIY
         7gvUttohy9Q2jl1omap+/Mmjvk6UqnyO7FMJaGi2zupIVrEOsRAaA0PBoj+ztjp9TasK
         wZ/DSJVUxdJQLcBJKlJwEyuTwC8QM/bhjGcjFXMk7VgHd/sAC5Xi6suT7kNZzFQe9fLu
         IhOA==
X-Gm-Message-State: AOAM533yzc9T2fSy+xxwrmEIeB2hAIjM8YMa27YIOOIehw8jpdOcKo9x
        TWsaavvU50tuWVvYpj2xFg==
X-Google-Smtp-Source: ABdhPJz2fxe5wTtAa/Nwq9+iT00pAlFKB1rlTywyktjwPkDCK/tilwbKnAErTzg45cSnl8TlWc7+kw==
X-Received: by 2002:a17:902:ba8b:b029:d7:e6da:cd21 with SMTP id k11-20020a170902ba8bb02900d7e6dacd21mr3115536pls.38.1606208623901;
        Tue, 24 Nov 2020 01:03:43 -0800 (PST)
Received: from localhost.localdomain ([182.209.58.45])
        by smtp.gmail.com with ESMTPSA id n68sm14084345pfn.161.2020.11.24.01.03.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2020 01:03:43 -0800 (PST)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, brakmo <brakmo@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        David Ahern <dsa@cumulusnetworks.com>,
        Yonghong Song <yhs@fb.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Ira Weiny <ira.weiny@intel.com>, Thomas Graf <tgraf@suug.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Xdp <xdp-newbies@vger.kernel.org>
Subject: [PATCH bpf-next v3 5/7] samples: bpf: refactor test_overhead program with libbpf
Date:   Tue, 24 Nov 2020 09:03:08 +0000
Message-Id: <20201124090310.24374-6-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201124090310.24374-1-danieltimlee@gmail.com>
References: <20201124090310.24374-1-danieltimlee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit refactors the existing program with libbpf bpf loader.
Since the kprobe, tracepoint and raw_tracepoint bpf program can be
attached with single bpf_program__attach() interface, so the
corresponding function of libbpf is used here.

Rather than specifying the number of cpus inside the code, this commit
uses the number of available cpus with _SC_NPROCESSORS_ONLN.

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
---
Changes in v2:
 - add static at global variable and drop {}
 
 samples/bpf/Makefile             |  2 +-
 samples/bpf/test_overhead_user.c | 82 +++++++++++++++++++++++---------
 2 files changed, 60 insertions(+), 24 deletions(-)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 09a249477554..25380e04897e 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -78,7 +78,7 @@ lathist-objs := lathist_user.o
 offwaketime-objs := offwaketime_user.o $(TRACE_HELPERS)
 spintest-objs := spintest_user.o $(TRACE_HELPERS)
 map_perf_test-objs := map_perf_test_user.o
-test_overhead-objs := bpf_load.o test_overhead_user.o
+test_overhead-objs := test_overhead_user.o
 test_cgrp2_array_pin-objs := test_cgrp2_array_pin.o
 test_cgrp2_attach-objs := test_cgrp2_attach.o
 test_cgrp2_sock-objs := test_cgrp2_sock.o
diff --git a/samples/bpf/test_overhead_user.c b/samples/bpf/test_overhead_user.c
index 94f74112a20e..819a6fe86f89 100644
--- a/samples/bpf/test_overhead_user.c
+++ b/samples/bpf/test_overhead_user.c
@@ -18,10 +18,14 @@
 #include <time.h>
 #include <sys/resource.h>
 #include <bpf/bpf.h>
-#include "bpf_load.h"
+#include <bpf/libbpf.h>
 
 #define MAX_CNT 1000000
 
+static struct bpf_link *links[2];
+static struct bpf_object *obj;
+static int cnt;
+
 static __u64 time_get_ns(void)
 {
 	struct timespec ts;
@@ -115,20 +119,54 @@ static void run_perf_test(int tasks, int flags)
 	}
 }
 
+static int load_progs(char *filename)
+{
+	struct bpf_program *prog;
+	int err = 0;
+
+	obj = bpf_object__open_file(filename, NULL);
+	err = libbpf_get_error(obj);
+	if (err < 0) {
+		fprintf(stderr, "ERROR: opening BPF object file failed\n");
+		return err;
+	}
+
+	/* load BPF program */
+	err = bpf_object__load(obj);
+	if (err < 0) {
+		fprintf(stderr, "ERROR: loading BPF object file failed\n");
+		return err;
+	}
+
+	bpf_object__for_each_program(prog, obj) {
+		links[cnt] = bpf_program__attach(prog);
+		err = libbpf_get_error(links[cnt]);
+		if (err < 0) {
+			fprintf(stderr, "ERROR: bpf_program__attach failed\n");
+			links[cnt] = NULL;
+			return err;
+		}
+		cnt++;
+	}
+
+	return err;
+}
+
 static void unload_progs(void)
 {
-	close(prog_fd[0]);
-	close(prog_fd[1]);
-	close(event_fd[0]);
-	close(event_fd[1]);
+	while (cnt)
+		bpf_link__destroy(links[--cnt]);
+
+	bpf_object__close(obj);
 }
 
 int main(int argc, char **argv)
 {
 	struct rlimit r = {RLIM_INFINITY, RLIM_INFINITY};
-	char filename[256];
-	int num_cpu = 8;
+	int num_cpu = sysconf(_SC_NPROCESSORS_ONLN);
 	int test_flags = ~0;
+	char filename[256];
+	int err = 0;
 
 	setrlimit(RLIMIT_MEMLOCK, &r);
 
@@ -145,38 +183,36 @@ int main(int argc, char **argv)
 	if (test_flags & 0xC) {
 		snprintf(filename, sizeof(filename),
 			 "%s_kprobe_kern.o", argv[0]);
-		if (load_bpf_file(filename)) {
-			printf("%s", bpf_log_buf);
-			return 1;
-		}
+
 		printf("w/KPROBE\n");
-		run_perf_test(num_cpu, test_flags >> 2);
+		err = load_progs(filename);
+		if (!err)
+			run_perf_test(num_cpu, test_flags >> 2);
+
 		unload_progs();
 	}
 
 	if (test_flags & 0x30) {
 		snprintf(filename, sizeof(filename),
 			 "%s_tp_kern.o", argv[0]);
-		if (load_bpf_file(filename)) {
-			printf("%s", bpf_log_buf);
-			return 1;
-		}
 		printf("w/TRACEPOINT\n");
-		run_perf_test(num_cpu, test_flags >> 4);
+		err = load_progs(filename);
+		if (!err)
+			run_perf_test(num_cpu, test_flags >> 4);
+
 		unload_progs();
 	}
 
 	if (test_flags & 0xC0) {
 		snprintf(filename, sizeof(filename),
 			 "%s_raw_tp_kern.o", argv[0]);
-		if (load_bpf_file(filename)) {
-			printf("%s", bpf_log_buf);
-			return 1;
-		}
 		printf("w/RAW_TRACEPOINT\n");
-		run_perf_test(num_cpu, test_flags >> 6);
+		err = load_progs(filename);
+		if (!err)
+			run_perf_test(num_cpu, test_flags >> 6);
+
 		unload_progs();
 	}
 
-	return 0;
+	return err;
 }
-- 
2.25.1

