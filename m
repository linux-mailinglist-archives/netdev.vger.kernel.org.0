Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B9AB2B67FD
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 15:58:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729146AbgKQO5d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 09:57:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728735AbgKQO5c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 09:57:32 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4985EC0613CF;
        Tue, 17 Nov 2020 06:57:32 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id a18so17444419pfl.3;
        Tue, 17 Nov 2020 06:57:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OCOWn97V912XxX8GvwyAqu/EnuyWY6mSN6tb2siU3Is=;
        b=OSxcENPlI3DugsDfg4Pf00aX0EhcUrMWDDpyGJ3/NOnnGC9pEZOj5hMnZgzinaH87O
         6Qb2uI93gcF4fzTtXC76o9r//n1I/kw4zl8SwvCHbPqKwzMXdOryr+zo4C7BYGoOyn11
         3EPNJ3tlCObGxu5HUJYKL+ocJ+Rec2e/SqKilDrTR0JhZ2n0HSbfqhDKUg0DGJSaO4x5
         UHFq1kxfj1LooG+GKdTgtR6gf90PWl6LU2yP3t4r+UQ9+tjUE5/WuhEh1Bh81Uj97ELe
         0CLOBlNGOIscMaITS6JviNI9GzoR/EDiYf7jPDn+1RRE/r6uh86fwYAfuCHlxJlFOsgd
         8Z9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OCOWn97V912XxX8GvwyAqu/EnuyWY6mSN6tb2siU3Is=;
        b=uEu2e3h3OVuQrp9cjZ4CZqiMS4GXDDu1qjZIYTzHWAQHw8znktlTq6qiseSP3YpNz4
         WIf3hm+tEwftlmNhS1VfU5L+hDFtjzlXX+UVFC2rsyITZEimf+NaM2mnLDYf0Rd2jx+C
         lKJyydxPHz24z/EVrSMN8kaYUAdKIkoEqD0aib0ouNSAtJmzpV5bTFFv1rQceFsJf4Sf
         rLvxzvf8uenLd08C9z7QjaW/pcjAlT6B+FkKaNzPfhgp2OWsm6RGUnzfXvYzC3JyaUu6
         lexh/j9zj3pXfxM5KJ33MCiO0o1JdofovaMihCGeTAo8xKYPXo/rwAbjuWwKRB+r3ian
         YzgA==
X-Gm-Message-State: AOAM530hg3B0PgCv4VPINPJANHYopYm9fAN4RZLzimdVyUohVCIn8c+O
        2TEJNC1W0o0XpewnGV48Vw==
X-Google-Smtp-Source: ABdhPJyutYPncJHQxU4NWtx2gGJWW1wkrRuiE00cOuwxx8QYboffYeYe21mP8TV9LVgOx6ohuUpNRA==
X-Received: by 2002:a63:5853:: with SMTP id i19mr3988023pgm.333.1605625051805;
        Tue, 17 Nov 2020 06:57:31 -0800 (PST)
Received: from localhost.localdomain ([182.209.58.45])
        by smtp.gmail.com with ESMTPSA id q13sm3517981pjq.15.2020.11.17.06.57.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2020 06:57:31 -0800 (PST)
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
Subject: [PATCH bpf-next 1/9] selftests: bpf: move tracing helpers to trace_helper
Date:   Tue, 17 Nov 2020 14:56:36 +0000
Message-Id: <20201117145644.1166255-2-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201117145644.1166255-1-danieltimlee@gmail.com>
References: <20201117145644.1166255-1-danieltimlee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Under the samples/bpf directory, similar tracing helpers are
fragmented around. To keep consistent of tracing programs, this commit
moves the helper and define locations to increase the reuse of each
helper function.

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>

---
 samples/bpf/Makefile                        |  2 +-
 samples/bpf/hbm.c                           | 51 ++++-----------------
 tools/testing/selftests/bpf/trace_helpers.c | 33 ++++++++++++-
 tools/testing/selftests/bpf/trace_helpers.h |  3 ++
 4 files changed, 45 insertions(+), 44 deletions(-)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index aeebf5d12f32..3e83cd5ca1c2 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -110,7 +110,7 @@ xdp_fwd-objs := xdp_fwd_user.o
 task_fd_query-objs := bpf_load.o task_fd_query_user.o $(TRACE_HELPERS)
 xdp_sample_pkts-objs := xdp_sample_pkts_user.o $(TRACE_HELPERS)
 ibumad-objs := bpf_load.o ibumad_user.o $(TRACE_HELPERS)
-hbm-objs := bpf_load.o hbm.o $(CGROUP_HELPERS)
+hbm-objs := bpf_load.o hbm.o $(CGROUP_HELPERS) $(TRACE_HELPERS)
 
 # Tell kbuild to always build the programs
 always-y := $(tprogs-y)
diff --git a/samples/bpf/hbm.c b/samples/bpf/hbm.c
index 400e741a56eb..b9f9f771dd81 100644
--- a/samples/bpf/hbm.c
+++ b/samples/bpf/hbm.c
@@ -48,6 +48,7 @@
 
 #include "bpf_load.h"
 #include "bpf_rlimit.h"
+#include "trace_helpers.h"
 #include "cgroup_helpers.h"
 #include "hbm.h"
 #include "bpf_util.h"
@@ -65,51 +66,12 @@ bool no_cn_flag;
 bool edt_flag;
 
 static void Usage(void);
-static void read_trace_pipe2(void);
 static void do_error(char *msg, bool errno_flag);
 
-#define DEBUGFS "/sys/kernel/debug/tracing/"
-
 struct bpf_object *obj;
 int bpfprog_fd;
 int cgroup_storage_fd;
 
-static void read_trace_pipe2(void)
-{
-	int trace_fd;
-	FILE *outf;
-	char *outFname = "hbm_out.log";
-
-	trace_fd = open(DEBUGFS "trace_pipe", O_RDONLY, 0);
-	if (trace_fd < 0) {
-		printf("Error opening trace_pipe\n");
-		return;
-	}
-
-//	Future support of ingress
-//	if (!outFlag)
-//		outFname = "hbm_in.log";
-	outf = fopen(outFname, "w");
-
-	if (outf == NULL)
-		printf("Error creating %s\n", outFname);
-
-	while (1) {
-		static char buf[4097];
-		ssize_t sz;
-
-		sz = read(trace_fd, buf, sizeof(buf) - 1);
-		if (sz > 0) {
-			buf[sz] = 0;
-			puts(buf);
-			if (outf != NULL) {
-				fprintf(outf, "%s\n", buf);
-				fflush(outf);
-			}
-		}
-	}
-}
-
 static void do_error(char *msg, bool errno_flag)
 {
 	if (errno_flag)
@@ -392,8 +354,15 @@ static int run_bpf_prog(char *prog, int cg_id)
 		fclose(fout);
 	}
 
-	if (debugFlag)
-		read_trace_pipe2();
+	if (debugFlag) {
+		char *out_fname = "hbm_out.log";
+		/* Future support of ingress */
+		// if (!outFlag)
+		//	out_fname = "hbm_in.log";
+
+		read_trace_pipe2(out_fname);
+	}
+
 	return rc;
 err:
 	rc = 1;
diff --git a/tools/testing/selftests/bpf/trace_helpers.c b/tools/testing/selftests/bpf/trace_helpers.c
index 1bbd1d9830c8..b7c184e109e8 100644
--- a/tools/testing/selftests/bpf/trace_helpers.c
+++ b/tools/testing/selftests/bpf/trace_helpers.c
@@ -11,8 +11,6 @@
 #include <sys/mman.h>
 #include "trace_helpers.h"
 
-#define DEBUGFS "/sys/kernel/debug/tracing/"
-
 #define MAX_SYMS 300000
 static struct ksym syms[MAX_SYMS];
 static int sym_cnt;
@@ -136,3 +134,34 @@ void read_trace_pipe(void)
 		}
 	}
 }
+
+void read_trace_pipe2(char *filename)
+{
+	int trace_fd;
+	FILE *outf;
+
+	trace_fd = open(DEBUGFS "trace_pipe", O_RDONLY, 0);
+	if (trace_fd < 0) {
+		printf("Error opening trace_pipe\n");
+		return;
+	}
+
+	outf = fopen(filename, "w");
+	if (!outf)
+		printf("Error creating %s\n", filename);
+
+	while (1) {
+		static char buf[4096];
+		ssize_t sz;
+
+		sz = read(trace_fd, buf, sizeof(buf) - 1);
+		if (sz > 0) {
+			buf[sz] = 0;
+			puts(buf);
+			if (outf) {
+				fprintf(outf, "%s\n", buf);
+				fflush(outf);
+			}
+		}
+	}
+}
diff --git a/tools/testing/selftests/bpf/trace_helpers.h b/tools/testing/selftests/bpf/trace_helpers.h
index f62fdef9e589..68c23bf55897 100644
--- a/tools/testing/selftests/bpf/trace_helpers.h
+++ b/tools/testing/selftests/bpf/trace_helpers.h
@@ -2,6 +2,8 @@
 #ifndef __TRACE_HELPER_H
 #define __TRACE_HELPER_H
 
+#define DEBUGFS "/sys/kernel/debug/tracing/"
+
 #include <bpf/libbpf.h>
 
 struct ksym {
@@ -17,5 +19,6 @@ long ksym_get_addr(const char *name);
 int kallsyms_find(const char *sym, unsigned long long *addr);
 
 void read_trace_pipe(void);
+void read_trace_pipe2(char *filename);
 
 #endif
-- 
2.25.1

