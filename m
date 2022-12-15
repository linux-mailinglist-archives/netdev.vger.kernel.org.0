Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B40764DA87
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 12:39:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbiLOLjw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 06:39:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230123AbiLOLju (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 06:39:50 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C19E27B19;
        Thu, 15 Dec 2022 03:39:49 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id m4so6575159pls.4;
        Thu, 15 Dec 2022 03:39:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vI0F02K6TsAt1ZRuqwA7C+O9iL48/aS7n0tIvEbOteI=;
        b=G5GWVootquScUWCxYu923R5I2TSUHZxHldFJH/JulUzmlHh1wfpD/La5U8uYgTPfv4
         TbvjIRZr8YSD3yj6U/NYx5xKqRv3YpzgPRAUDwLYLxp+R16v0m7QUm+NGJLC9NHrQRvq
         PXQ0Nntelc6Cp+l36CsVAoeGEj3JIiZ0+gl1z5O/TelbEW6tLBcfQdRqnCzWyqEhOGeo
         Yc+9MRoRhxAL6oHyL7PUwg1T0WA/eTQ9kKqob9GhyH9p8ETv8OfJvI9mi/C22nKCBo/H
         0RfVhJfTAtjbJbmU5a6OgxeCgiy8vT4Lc/8kSnFoB+VB5ssxYhRVwiWsMVhQcau+b0m/
         DsFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vI0F02K6TsAt1ZRuqwA7C+O9iL48/aS7n0tIvEbOteI=;
        b=7GG5mcsS2JsmhKIdueBRW3MxPiE3UaD23MaAMtth7e3u0SCoUoqdBkoPrVfUdYDdIU
         Wktp9GZP2jhjxSwSdt51dWCEiZRzq44zPoqahhBzs1JBGctm5WK+JEkTlk6PKrh89+Nj
         12ANW30tqz0s7+bRFV0mggjUF0vw533e6yyBS5MKNY9jIiA1TSn1lft/eWq+FAUb7NUm
         w5fBan98LDrCDNFoUEDkcswyVlLZk/lEOjcDKCvISfGyVEt6H4DdjYfHUUjB/wKNteT/
         pOGik7MvaCbE+QYC4HFAOnUimlWix7PXCdb5hBOut4gCJL9meoiyUqkuimc61m2/4nbz
         xmWQ==
X-Gm-Message-State: ANoB5pm4v8Y/OeW+RNbcwvW/g9UMWbwDoPvnfJuVcV47pW3t7OtjvCjJ
        +Ytxdat9Tu6N/OCalyXx2Q==
X-Google-Smtp-Source: AA0mqf5SC7bk2rnpaIWMe14CSK1V1+Pu4q1oVZfz/tH2wnhBkcCDbS7XLb4XR0wr8fUcLH2MEzgWjQ==
X-Received: by 2002:a05:6a20:a692:b0:ad:ceba:1bdc with SMTP id ba18-20020a056a20a69200b000adceba1bdcmr14971537pzb.16.1671104388545;
        Thu, 15 Dec 2022 03:39:48 -0800 (PST)
Received: from WDIR.. ([182.209.58.25])
        by smtp.gmail.com with ESMTPSA id g30-20020aa79dde000000b00574d38f4d37sm1553440pfq.45.2022.12.15.03.39.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Dec 2022 03:39:48 -0800 (PST)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Yonghong Song <yhs@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: [bpf-next 3/5] samples: bpf: change _kern suffix to .bpf with syscall tracing program
Date:   Thu, 15 Dec 2022 20:39:35 +0900
Message-Id: <20221215113937.113936-4-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221215113937.113936-1-danieltimlee@gmail.com>
References: <20221215113937.113936-1-danieltimlee@gmail.com>
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

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
 samples/bpf/Makefile                                   | 10 +++++-----
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
 11 files changed, 10 insertions(+), 10 deletions(-)
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

