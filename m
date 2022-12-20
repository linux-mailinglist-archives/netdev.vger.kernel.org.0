Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55AC565200B
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 13:00:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233294AbiLTMAB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 07:00:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233296AbiLTL7l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 06:59:41 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6530017598;
        Tue, 20 Dec 2022 03:59:40 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id u15-20020a17090a3fcf00b002191825cf02so11893327pjm.2;
        Tue, 20 Dec 2022 03:59:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cMexRh2hV7YkgsRsAbZsGjx/dMRsJTIV708VtJ9ksKY=;
        b=MMjfl6mHjdM5rbC5G1TnaDK+dkG6R6WuNClrWwcTFDbKxlrO+07tltWBEQZm+U6Qdz
         90e7xoARG5ipkVPAnCqBCip9nThjRQiOGCIQWNbSWQLWuvUYaAlUf4DwkKOXtIxzqTC/
         S8SLPXw14WLjZCKMAnw66LlxJb0QhjqufCCMaxTGQebWEeeLWVLYdfseonR3e2zRyy6Y
         Yt8LjnkiwpLpJKRiDYjeYra/dQMPznnLdFHLXHC+Y85nNT8HcnlQLxNP6RxXarE09Bgi
         38ARodr2kVDkBRhfebQ0DHqHeJXjkUxHmh2h07ZUZFmAnNXVvpLbHwB2xXRx0eahJmcK
         9u4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cMexRh2hV7YkgsRsAbZsGjx/dMRsJTIV708VtJ9ksKY=;
        b=uSjvzEWxAnPS+hrXFIvP+umUzRCdY1cKGNTQgIpgK6YGDbsrRlMC1hNWwGFbkn8TdS
         u0kJBZQHggYo/HN5If6R+CTbRSYWqUKBP7qPj+EsFOsbOpT+VoIyovvYi32hfJsBN04+
         UHb76yV4l06ifHjKx3Beaxqocc0EAbYEzIOdL6UpMPlmOiVxDSJpChYxRLRK5PH/ze0P
         ZHYozjoUCUCNLEGHdg0sIZ2I+C5V7at42qzchZZMWfeW0ejizaVN+yUhGtxRLolh7C51
         wt7GADjUJL2I2D4q7HDOXboRBX+XgE+JVBmGjrpH+zdKCyqu6lijPzB29aKjDWFIk2p3
         MZVw==
X-Gm-Message-State: AFqh2kqeHJ4U8cCDrJuElDTCi3Ofpf67EQvdP+AJ+uVCu5hjXSVb2cKE
        T6UQFToaGpwOyMtLqma6lg==
X-Google-Smtp-Source: AMrXdXst5WSgeJm4UHJR9rINP1UVaQexaz9krffjbJ0L1lXVyrDguLHUnIxkx+ab7pB2KCVzgsU1bw==
X-Received: by 2002:a17:90b:b17:b0:219:1a4e:349d with SMTP id bf23-20020a17090b0b1700b002191a4e349dmr14122871pjb.44.1671537579790;
        Tue, 20 Dec 2022 03:59:39 -0800 (PST)
Received: from WDIR.. ([182.209.58.25])
        by smtp.gmail.com with ESMTPSA id z10-20020a17090a170a00b00219752c8ea3sm10982482pjd.48.2022.12.20.03.59.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Dec 2022 03:59:39 -0800 (PST)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Yonghong Song <yhs@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: [bpf-next v2 3/5] samples/bpf: change _kern suffix to .bpf with syscall tracing program
Date:   Tue, 20 Dec 2022 20:59:26 +0900
Message-Id: <20221220115928.11979-4-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221220115928.11979-1-danieltimlee@gmail.com>
References: <20221220115928.11979-1-danieltimlee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently old compile rule (CLANG-bpf) doesn't contains VMLINUX_H define
flag which is essential for the bpf program that includes "vmlinux.h".
Also old compile rule doesn't directly specify the compile target as bpf,
instead it uses bunch of extra options with clang followed by long chain
of commands. (e.g. clang | opt | llvm-dis | llc)

In Makefile, there is already new compile rule which is more simple and
neat. And it also has -D__VMLINUX_H__ option. By just changing the _kern
suffix to .bpf will inherit the benefit of the new CLANG-BPF compile
target.

Also, this commit adds dummy gnu/stub.h to the samples/bpf directory.
As commit 1c2dd16add7e ("selftests/bpf: get rid of -D__x86_64__") noted,
compiling with 'clang -target bpf' will raise an error with stubs.h
unless workaround (-D__x86_64) is used. This commit solves this problem
by adding dummy stub.h to make /usr/include/features.h to follow the
expected path as the same way selftests/bpf dealt with.

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
Changes in V2:
- add gnu/stub.h hack to fix compile error with 'clang -target bpf'

 samples/bpf/Makefile                                   | 10 +++++-----
 samples/bpf/gnu/stubs.h                                |  1 +
 .../bpf/{map_perf_test_kern.c => map_perf_test.bpf.c}  |  0
 samples/bpf/map_perf_test_user.c                       |  2 +-
 ...oup_kern.c => test_current_task_under_cgroup.bpf.c} |  0
 samples/bpf/test_current_task_under_cgroup_user.c      |  2 +-
 ...e_write_user_kern.c => test_probe_write_user.bpf.c} |  0
 samples/bpf/test_probe_write_user_user.c               |  2 +-
 .../bpf/{trace_output_kern.c => trace_output.bpf.c}    |  0
 samples/bpf/trace_output_user.c                        |  2 +-
 samples/bpf/{tracex2_kern.c => tracex2.bpf.c}          |  0
 samples/bpf/tracex2_user.c                             |  2 +-
 12 files changed, 11 insertions(+), 10 deletions(-)
 create mode 100644 samples/bpf/gnu/stubs.h
 rename samples/bpf/{map_perf_test_kern.c => map_perf_test.bpf.c} (100%)
 rename samples/bpf/{test_current_task_under_cgroup_kern.c => test_current_task_under_cgroup.bpf.c} (100%)
 rename samples/bpf/{test_probe_write_user_kern.c => test_probe_write_user.bpf.c} (100%)
 rename samples/bpf/{trace_output_kern.c => trace_output.bpf.c} (100%)
 rename samples/bpf/{tracex2_kern.c => tracex2.bpf.c} (100%)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 727da3c5879b..22039a0a5b35 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -125,21 +125,21 @@ always-y += sockex1_kern.o
 always-y += sockex2_kern.o
 always-y += sockex3_kern.o
 always-y += tracex1_kern.o
-always-y += tracex2_kern.o
+always-y += tracex2.bpf.o
 always-y += tracex3_kern.o
 always-y += tracex4_kern.o
 always-y += tracex5_kern.o
 always-y += tracex6_kern.o
 always-y += tracex7_kern.o
 always-y += sock_flags_kern.o
-always-y += test_probe_write_user_kern.o
-always-y += trace_output_kern.o
+always-y += test_probe_write_user.bpf.o
+always-y += trace_output.bpf.o
 always-y += tcbpf1_kern.o
 always-y += tc_l2_redirect_kern.o
 always-y += lathist_kern.o
 always-y += offwaketime_kern.o
 always-y += spintest_kern.o
-always-y += map_perf_test_kern.o
+always-y += map_perf_test.bpf.o
 always-y += test_overhead_tp_kern.o
 always-y += test_overhead_raw_tp_kern.o
 always-y += test_overhead_kprobe_kern.o
@@ -147,7 +147,7 @@ always-y += parse_varlen.o parse_simple.o parse_ldabs.o
 always-y += test_cgrp2_tc_kern.o
 always-y += xdp1_kern.o
 always-y += xdp2_kern.o
-always-y += test_current_task_under_cgroup_kern.o
+always-y += test_current_task_under_cgroup.bpf.o
 always-y += trace_event_kern.o
 always-y += sampleip_kern.o
 always-y += lwt_len_hist_kern.o
diff --git a/samples/bpf/gnu/stubs.h b/samples/bpf/gnu/stubs.h
new file mode 100644
index 000000000000..719225b16626
--- /dev/null
+++ b/samples/bpf/gnu/stubs.h
@@ -0,0 +1 @@
+/* dummy .h to trick /usr/include/features.h to work with 'clang -target bpf' */
diff --git a/samples/bpf/map_perf_test_kern.c b/samples/bpf/map_perf_test.bpf.c
similarity index 100%
rename from samples/bpf/map_perf_test_kern.c
rename to samples/bpf/map_perf_test.bpf.c
diff --git a/samples/bpf/map_perf_test_user.c b/samples/bpf/map_perf_test_user.c
index 1bb53f4b29e1..d2fbcf963cdf 100644
--- a/samples/bpf/map_perf_test_user.c
+++ b/samples/bpf/map_perf_test_user.c
@@ -443,7 +443,7 @@ int main(int argc, char **argv)
 	if (argc > 4)
 		max_cnt = atoi(argv[4]);
 
-	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
+	snprintf(filename, sizeof(filename), "%s.bpf.o", argv[0]);
 	obj = bpf_object__open_file(filename, NULL);
 	if (libbpf_get_error(obj)) {
 		fprintf(stderr, "ERROR: opening BPF object file failed\n");
diff --git a/samples/bpf/test_current_task_under_cgroup_kern.c b/samples/bpf/test_current_task_under_cgroup.bpf.c
similarity index 100%
rename from samples/bpf/test_current_task_under_cgroup_kern.c
rename to samples/bpf/test_current_task_under_cgroup.bpf.c
diff --git a/samples/bpf/test_current_task_under_cgroup_user.c b/samples/bpf/test_current_task_under_cgroup_user.c
index 6fb25906835e..9726ed2a8a8b 100644
--- a/samples/bpf/test_current_task_under_cgroup_user.c
+++ b/samples/bpf/test_current_task_under_cgroup_user.c
@@ -21,7 +21,7 @@ int main(int argc, char **argv)
 	char filename[256];
 	int map_fd[2];
 
-	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
+	snprintf(filename, sizeof(filename), "%s.bpf.o", argv[0]);
 	obj = bpf_object__open_file(filename, NULL);
 	if (libbpf_get_error(obj)) {
 		fprintf(stderr, "ERROR: opening BPF object file failed\n");
diff --git a/samples/bpf/test_probe_write_user_kern.c b/samples/bpf/test_probe_write_user.bpf.c
similarity index 100%
rename from samples/bpf/test_probe_write_user_kern.c
rename to samples/bpf/test_probe_write_user.bpf.c
diff --git a/samples/bpf/test_probe_write_user_user.c b/samples/bpf/test_probe_write_user_user.c
index 00ccfb834e45..2a539aec4116 100644
--- a/samples/bpf/test_probe_write_user_user.c
+++ b/samples/bpf/test_probe_write_user_user.c
@@ -24,7 +24,7 @@ int main(int ac, char **argv)
 	mapped_addr_in = (struct sockaddr_in *)&mapped_addr;
 	tmp_addr_in = (struct sockaddr_in *)&tmp_addr;
 
-	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
+	snprintf(filename, sizeof(filename), "%s.bpf.o", argv[0]);
 	obj = bpf_object__open_file(filename, NULL);
 	if (libbpf_get_error(obj)) {
 		fprintf(stderr, "ERROR: opening BPF object file failed\n");
diff --git a/samples/bpf/trace_output_kern.c b/samples/bpf/trace_output.bpf.c
similarity index 100%
rename from samples/bpf/trace_output_kern.c
rename to samples/bpf/trace_output.bpf.c
diff --git a/samples/bpf/trace_output_user.c b/samples/bpf/trace_output_user.c
index 371732f9cf8e..d316fd2c8e24 100644
--- a/samples/bpf/trace_output_user.c
+++ b/samples/bpf/trace_output_user.c
@@ -51,7 +51,7 @@ int main(int argc, char **argv)
 	char filename[256];
 	FILE *f;
 
-	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
+	snprintf(filename, sizeof(filename), "%s.bpf.o", argv[0]);
 	obj = bpf_object__open_file(filename, NULL);
 	if (libbpf_get_error(obj)) {
 		fprintf(stderr, "ERROR: opening BPF object file failed\n");
diff --git a/samples/bpf/tracex2_kern.c b/samples/bpf/tracex2.bpf.c
similarity index 100%
rename from samples/bpf/tracex2_kern.c
rename to samples/bpf/tracex2.bpf.c
diff --git a/samples/bpf/tracex2_user.c b/samples/bpf/tracex2_user.c
index 089e408abd7a..2131f1648cf1 100644
--- a/samples/bpf/tracex2_user.c
+++ b/samples/bpf/tracex2_user.c
@@ -123,7 +123,7 @@ int main(int ac, char **argv)
 	int i, j = 0;
 	FILE *f;
 
-	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
+	snprintf(filename, sizeof(filename), "%s.bpf.o", argv[0]);
 	obj = bpf_object__open_file(filename, NULL);
 	if (libbpf_get_error(obj)) {
 		fprintf(stderr, "ERROR: opening BPF object file failed\n");
-- 
2.34.1

