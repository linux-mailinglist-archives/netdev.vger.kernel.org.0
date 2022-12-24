Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C4D66558D6
	for <lists+netdev@lfdr.de>; Sat, 24 Dec 2022 08:15:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbiLXHPx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Dec 2022 02:15:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbiLXHPp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Dec 2022 02:15:45 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C7BFF32;
        Fri, 23 Dec 2022 23:15:44 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id p4so6741594pjk.2;
        Fri, 23 Dec 2022 23:15:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c4bC2r8TQM9zsvaRFp/0j9Slk8lcxESg+J4rrAXLwNg=;
        b=N5qzaKC63wpzqjmI3f3vSJ4+aw46UwbN1tq8MW2KvFYAgCloL1XRYZ90/QCVq6dLjv
         WgjzL/1U5OllJc2z20IuIPF1f6I3v1mbn34BjrgEqAap8dn0WLbZPA8o+frEYmOqR9vO
         3xSewsdVwK73yyqncprVVBItlnrqUonXevPDTr0JsseP6IsGEaSNm0H44Y0VI6/YMgW5
         dW9hKhzS8JsB6iB2ybXKDjG1HIudgFHrrwpeGDZ8xe681wKFHnqO5Etwh2gTMqtj1tqi
         VgbKRVCbvwkBPSAQBKSsItBJQQmdhs/NyrZTvgQoA4Gy9F3PJHUUirXj/eW0tG3DjmKD
         wSZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c4bC2r8TQM9zsvaRFp/0j9Slk8lcxESg+J4rrAXLwNg=;
        b=wPqsDNLXnkW2NsbJnfHmYwER5bS1yaWcuOyg6svALO+jhj6b4S/idShqAzuyB7SOpp
         5SXUghuVvQkaVt8/Y/JRsbmFPPvzoezIFjnhSwxgGg04yKeuOZXsjqF14FCwT0NAT6fR
         pC2pmGpF2EGd7VAj57+i4YV6PwGjSEAm9ip+TM4j0B7DVPZvax2nbBmarb++3/m4OU9b
         5hH1W8st80//nf9YI8LBgL1JX+txOuAyYeH+IoVDcxZLH2m2fkmbKTSoXkkeU6Cd8X34
         u9oFruVc07umLRq1zRoIlpjt3YGGRBnDzoodcAL94wf0ksfmyMSrFmc1OIbcJ58SInQc
         kPcw==
X-Gm-Message-State: AFqh2krQt5eCP0Lq6cnz1bCK+xDMYR+S170ESDLpypKpbiJ6bLgHRFG/
        96/+hF/Bdnb5IyOPD3PBuqHx+Z6URllnxbyTLQ==
X-Google-Smtp-Source: AMrXdXs+Z36jKAEJzlI+v/GQ3x8DHzl+03CnUex4/g6+y3h9d5sbtVF6juABQVjOocBN3NDyn00xVQ==
X-Received: by 2002:a17:902:eecc:b0:189:184d:f0ff with SMTP id h12-20020a170902eecc00b00189184df0ffmr13396912plb.11.1671866143572;
        Fri, 23 Dec 2022 23:15:43 -0800 (PST)
Received: from WDIR.. ([182.209.58.25])
        by smtp.gmail.com with ESMTPSA id bf4-20020a170902b90400b00186b7443082sm3433222plb.195.2022.12.23.23.15.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Dec 2022 23:15:43 -0800 (PST)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: [bpf-next v3 3/6] samples/bpf: change _kern suffix to .bpf with syscall tracing program
Date:   Sat, 24 Dec 2022 16:15:24 +0900
Message-Id: <20221224071527.2292-4-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221224071527.2292-1-danieltimlee@gmail.com>
References: <20221224071527.2292-1-danieltimlee@gmail.com>
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
index ac251a417f45..a1aaea59caee 100644
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
index dd6205c6b6a7..2ef5047e802b 100644
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

