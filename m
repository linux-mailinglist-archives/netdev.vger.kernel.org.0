Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7CEB2B680B
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 15:58:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387506AbgKQO5x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 09:57:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725779AbgKQO5u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 09:57:50 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A7F8C0613CF;
        Tue, 17 Nov 2020 06:57:50 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id c66so17448892pfa.4;
        Tue, 17 Nov 2020 06:57:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CahE39cRGB7/8CV64x89V4yVQxpjtCvvdx4AZ5VZMz4=;
        b=mWhtzpqcxWthCtqZtjtIVSqbNA+k7PUF4TtPRxnMaIoLUqIsDbbG1OzeEWbeLJSU6t
         zYUG12JTnepKJwnstdCfAOm0fK6CbdV5FK0LXBmeOf/iGBjiAbU2T7py0zXRu0LVzQzl
         O4kiDG0tuJB5Ur4vk0v6XF+7Nrk+xzB/vlNpAblyU2mQWiCehhcoJaOVoiFCTMli0tu+
         N9UpM+CZKbMU31KGfW+QNmypCuK90gcrtXTX/wd6xYRHNo6rgw8Jx/wS6KDFMueyBtdY
         mf66Scdn2trVuUCJNdPkf73X8JcO0W7jbwqLZGsCccDNSGF/8Curf2jtW0CoOyeJwogV
         7ifw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CahE39cRGB7/8CV64x89V4yVQxpjtCvvdx4AZ5VZMz4=;
        b=Abs5oRNN9x8BD09VvE7ld/IKEZx7lz/SuGOPNl3W9nYFbQNjvnSTxBSaW7RDNnaCUx
         S2HSb749zOXSoVMcz7VTYZnzRaLlIzjz2E55hcv8PXmyJNQyE4lH4PQ1D4BiVz32Mt3x
         QvDCp4ehd1U3sbOXUlnNAjskYAMJVJFtzxp1ZJ+49odqaBtF2G3R9UUA32cfCMsj8oJx
         qdY6wOUBkXQoYWzioXo0Jl5c6A9PT8EDnKtNOXCjUD2rmq32Hq522wcrbIMe4UrDpyqA
         wZS6f4p2e2qLnt1Sd/5KmzsTr/8dwWlkNHOt8Xw92+0b0E4VVxE657Nu+tNBkv2w12pn
         AyVg==
X-Gm-Message-State: AOAM5336vRQujK90esuD4dakkzbzQ7iODbEq5DdhA4GZG9+Lsm6upEwy
        yb5C4R+ga4DqQxTg33drQw==
X-Google-Smtp-Source: ABdhPJyDLG7dBE51z9E9wdrOmmF16evoFpXT/ZsSe8OIaAVharKLvAmMOi2IHvad4EUZJdYO01FkfQ==
X-Received: by 2002:a63:5146:: with SMTP id r6mr3925749pgl.212.1605625070048;
        Tue, 17 Nov 2020 06:57:50 -0800 (PST)
Received: from localhost.localdomain ([182.209.58.45])
        by smtp.gmail.com with ESMTPSA id q13sm3517981pjq.15.2020.11.17.06.57.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2020 06:57:49 -0800 (PST)
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
Subject: [PATCH bpf-next 5/9] samples: bpf: refactor ibumad program with libbpf
Date:   Tue, 17 Nov 2020 14:56:40 +0000
Message-Id: <20201117145644.1166255-6-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201117145644.1166255-1-danieltimlee@gmail.com>
References: <20201117145644.1166255-1-danieltimlee@gmail.com>
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
 samples/bpf/Makefile      |  2 +-
 samples/bpf/ibumad_kern.c | 26 +++++++--------
 samples/bpf/ibumad_user.c | 66 ++++++++++++++++++++++++++++++---------
 3 files changed, 65 insertions(+), 29 deletions(-)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 36b261c7afc7..bfa595379493 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -109,7 +109,7 @@ xsk_fwd-objs := xsk_fwd.o
 xdp_fwd-objs := xdp_fwd_user.o
 task_fd_query-objs := task_fd_query_user.o $(TRACE_HELPERS)
 xdp_sample_pkts-objs := xdp_sample_pkts_user.o $(TRACE_HELPERS)
-ibumad-objs := bpf_load.o ibumad_user.o $(TRACE_HELPERS)
+ibumad-objs := ibumad_user.o
 hbm-objs := hbm.o $(CGROUP_HELPERS) $(TRACE_HELPERS)
 
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
index fa06eef31a84..66a06272f242 100644
--- a/samples/bpf/ibumad_user.c
+++ b/samples/bpf/ibumad_user.c
@@ -23,10 +23,15 @@
 #include <getopt.h>
 #include <net/if.h>
 
-#include "bpf_load.h"
+#include <bpf/bpf.h>
 #include "bpf_util.h"
 #include <bpf/libbpf.h>
 
+struct bpf_link *tp_links[3] = {};
+struct bpf_object *obj;
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
 	int opt;
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
 
 	while ((opt = getopt_long(argc, argv, "hd:rSw",
 				  long_options, &longindex)) != -1) {
@@ -107,10 +109,38 @@ int main(int argc, char **argv)
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
+		return 0;
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
@@ -118,5 +148,11 @@ int main(int argc, char **argv)
 		dump_all_counts();
 	}
 
+cleanup:
+	/* Detach tracepoints */
+	while (tp_cnt)
+		bpf_link__destroy(tp_links[--tp_cnt]);
+
+	bpf_object__close(obj);
 	return 0;
 }
-- 
2.25.1

