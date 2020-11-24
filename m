Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B71332C20D2
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 10:05:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731037AbgKXJD5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 04:03:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731012AbgKXJDj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 04:03:39 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C35DDC0613D6;
        Tue, 24 Nov 2020 01:03:39 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id x24so5576053pfn.6;
        Tue, 24 Nov 2020 01:03:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HPngOSM82/AQhAOxg6kInXieW/P6ExxWnm99recQX+Y=;
        b=Y+cFxmPV067JCXHxVS+bM1wzmU6WESpNKsIX1IkyWRdXTb6Y574yCk1WGAIoUnTpRy
         AUpkV0znzEt6V7uW2r9jS/ww6zq/7BeuqzICUWFvQIAxkQ1uRmpGDU2WTWDneVRxtilb
         8zLUKstNFDp4AFLp4Lr5S0QtDNb54sabVRkJCconX4KHTkJAncGA6rjQFJaVNBstiX1o
         8gBGfJCSY4Eagt/E9tVxPD8l9oBmsQhr5UcA9L5Jx50Cmi5sZmMaGJj6QeIGcLaiFqdm
         vy0PlQxlzdmdqY/7WQUZpomy5M371eX10/JtLp0L2lJ8xVkHBZC2DUDhBnd8ALd37e4v
         3Ugw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HPngOSM82/AQhAOxg6kInXieW/P6ExxWnm99recQX+Y=;
        b=LSLXgNgAcs4lyNtRlblcxxnSxV5D4YIYvUJL+cW3jFvO+fqM7DtQ2JHMJsKVww6MOT
         NpxrtajilgL8WXg08TjchCJNODIH3ntcji6Otb+sHNx7CACFYnXKfzjZ3z3O7FTIdItM
         WrHyZh/NkVm6+m6PrL8enwqqEUEd5cgtcVqtlTG0yytSRG45RCYgdzvLtrkj9t/Eib4Y
         Uv42nIbxzcQTSiAD+uz0HyRvGo+LlF90X0yfu/5cWgfPhVU0PjKUF1uJTkA63dDwgGaK
         pgNJf3fr69ttKvDSrnXVeTybY2vhe8y3QfVbtFqnPyazyg7Bt+fLv8R/iBe/ohsSIycO
         TOKQ==
X-Gm-Message-State: AOAM532+iG0XENn+dj1YS1XDdyfT/T7XoOailm5Gr8IuM2Pt8B85qYdl
        jsCI2+9OMH6GvzloqlMutw==
X-Google-Smtp-Source: ABdhPJwBkA8GtKi//UIOrn1Z4j9w10HSsa5LglX9wKlzGz7uPNg7DhsgaokhDv8yuDWtp7PhfGPrFQ==
X-Received: by 2002:a63:b05:: with SMTP id 5mr2956493pgl.267.1606208619324;
        Tue, 24 Nov 2020 01:03:39 -0800 (PST)
Received: from localhost.localdomain ([182.209.58.45])
        by smtp.gmail.com with ESMTPSA id n68sm14084345pfn.161.2020.11.24.01.03.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2020 01:03:38 -0800 (PST)
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
Subject: [PATCH bpf-next v3 4/7] samples: bpf: refactor ibumad program with libbpf
Date:   Tue, 24 Nov 2020 09:03:07 +0000
Message-Id: <20201124090310.24374-5-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201124090310.24374-1-danieltimlee@gmail.com>
References: <20201124090310.24374-1-danieltimlee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit refactors the existing ibumad program with libbpf bpf
loader. Attach/detach of Tracepoint bpf programs has been managed
with the generic bpf_program__attach() and bpf_link__destroy() from
the libbpf.

Also, instead of using the previous BPF MAP definition, this commit
refactors ibumad MAP definition with the new BTF-defined MAP format.

To verify that this bpf program works without an infiniband device,
try loading ib_umad kernel module and test the program as follows:

    # modprobe ib_umad
    # ./ibumad

Moreover, TRACE_HELPERS has been removed from the Makefile since it is
not used on this program.

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
Changes in v2:
 - add static at global variable and drop {}
 - fix return error code on exit
 
 samples/bpf/Makefile      |  2 +-
 samples/bpf/ibumad_kern.c | 26 +++++++-------
 samples/bpf/ibumad_user.c | 71 +++++++++++++++++++++++++++++----------
 3 files changed, 68 insertions(+), 31 deletions(-)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 3bffd42e1482..09a249477554 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -109,7 +109,7 @@ xsk_fwd-objs := xsk_fwd.o
 xdp_fwd-objs := xdp_fwd_user.o
 task_fd_query-objs := task_fd_query_user.o $(TRACE_HELPERS)
 xdp_sample_pkts-objs := xdp_sample_pkts_user.o $(TRACE_HELPERS)
-ibumad-objs := bpf_load.o ibumad_user.o $(TRACE_HELPERS)
+ibumad-objs := ibumad_user.o
 hbm-objs := hbm.o $(CGROUP_HELPERS)
 
 # Tell kbuild to always build the programs
diff --git a/samples/bpf/ibumad_kern.c b/samples/bpf/ibumad_kern.c
index 3a91b4c1989a..26dcd4dde946 100644
--- a/samples/bpf/ibumad_kern.c
+++ b/samples/bpf/ibumad_kern.c
@@ -16,19 +16,19 @@
 #include <bpf/bpf_helpers.h>
 
 
-struct bpf_map_def SEC("maps") read_count = {
-	.type        = BPF_MAP_TYPE_ARRAY,
-	.key_size    = sizeof(u32), /* class; u32 required */
-	.value_size  = sizeof(u64), /* count of mads read */
-	.max_entries = 256, /* Room for all Classes */
-};
-
-struct bpf_map_def SEC("maps") write_count = {
-	.type        = BPF_MAP_TYPE_ARRAY,
-	.key_size    = sizeof(u32), /* class; u32 required */
-	.value_size  = sizeof(u64), /* count of mads written */
-	.max_entries = 256, /* Room for all Classes */
-};
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__type(key, u32); /* class; u32 required */
+	__type(value, u64); /* count of mads read */
+	__uint(max_entries, 256); /* Room for all Classes */
+} read_count SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__type(key, u32); /* class; u32 required */
+	__type(value, u64); /* count of mads written */
+	__uint(max_entries, 256); /* Room for all Classes */
+} write_count SEC(".maps");
 
 #undef DEBUG
 #ifndef DEBUG
diff --git a/samples/bpf/ibumad_user.c b/samples/bpf/ibumad_user.c
index fa06eef31a84..d83d8102f489 100644
--- a/samples/bpf/ibumad_user.c
+++ b/samples/bpf/ibumad_user.c
@@ -23,10 +23,15 @@
 #include <getopt.h>
 #include <net/if.h>
 
-#include "bpf_load.h"
+#include <bpf/bpf.h>
 #include "bpf_util.h"
 #include <bpf/libbpf.h>
 
+static struct bpf_link *tp_links[3];
+static struct bpf_object *obj;
+static int map_fd[2];
+static int tp_cnt;
+
 static void dump_counts(int fd)
 {
 	__u32 key;
@@ -53,6 +58,11 @@ static void dump_all_counts(void)
 static void dump_exit(int sig)
 {
 	dump_all_counts();
+	/* Detach tracepoints */
+	while (tp_cnt)
+		bpf_link__destroy(tp_links[--tp_cnt]);
+
+	bpf_object__close(obj);
 	exit(0);
 }
 
@@ -73,19 +83,11 @@ static void usage(char *cmd)
 
 int main(int argc, char **argv)
 {
+	struct bpf_program *prog;
 	unsigned long delay = 5;
+	char filename[256];
 	int longindex = 0;
-	int opt;
-	char bpf_file[256];
-
-	/* Create the eBPF kernel code path name.
-	 * This follows the pattern of all of the other bpf samples
-	 */
-	snprintf(bpf_file, sizeof(bpf_file), "%s_kern.o", argv[0]);
-
-	/* Do one final dump when exiting */
-	signal(SIGINT, dump_exit);
-	signal(SIGTERM, dump_exit);
+	int opt, err = -1;
 
 	while ((opt = getopt_long(argc, argv, "hd:rSw",
 				  long_options, &longindex)) != -1) {
@@ -107,16 +109,51 @@ int main(int argc, char **argv)
 		}
 	}
 
-	if (load_bpf_file(bpf_file)) {
-		fprintf(stderr, "ERROR: failed to load eBPF from file : %s\n",
-			bpf_file);
-		return 1;
+	/* Do one final dump when exiting */
+	signal(SIGINT, dump_exit);
+	signal(SIGTERM, dump_exit);
+
+	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
+	obj = bpf_object__open_file(filename, NULL);
+	if (libbpf_get_error(obj)) {
+		fprintf(stderr, "ERROR: opening BPF object file failed\n");
+		return err;
+	}
+
+	/* load BPF program */
+	if (bpf_object__load(obj)) {
+		fprintf(stderr, "ERROR: loading BPF object file failed\n");
+		goto cleanup;
+	}
+
+	map_fd[0] = bpf_object__find_map_fd_by_name(obj, "read_count");
+	map_fd[1] = bpf_object__find_map_fd_by_name(obj, "write_count");
+	if (map_fd[0] < 0 || map_fd[1] < 0) {
+		fprintf(stderr, "ERROR: finding a map in obj file failed\n");
+		goto cleanup;
+	}
+
+	bpf_object__for_each_program(prog, obj) {
+		tp_links[tp_cnt] = bpf_program__attach(prog);
+		if (libbpf_get_error(tp_links[tp_cnt])) {
+			fprintf(stderr, "ERROR: bpf_program__attach failed\n");
+			tp_links[tp_cnt] = NULL;
+			goto cleanup;
+		}
+		tp_cnt++;
 	}
 
 	while (1) {
 		sleep(delay);
 		dump_all_counts();
 	}
+	err = 0;
+
+cleanup:
+	/* Detach tracepoints */
+	while (tp_cnt)
+		bpf_link__destroy(tp_links[--tp_cnt]);
 
-	return 0;
+	bpf_object__close(obj);
+	return err;
 }
-- 
2.25.1

