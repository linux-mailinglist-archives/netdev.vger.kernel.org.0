Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B17CE66AFB4
	for <lists+netdev@lfdr.de>; Sun, 15 Jan 2023 08:18:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231143AbjAOHSb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 02:18:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230126AbjAOHRG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 02:17:06 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCABECDCA;
        Sat, 14 Jan 2023 23:16:56 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id i65so15442731pfc.0;
        Sat, 14 Jan 2023 23:16:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vNXfcjpndi9wyIiNjD+j3biphdOzIRcH22L61plM07w=;
        b=gHVR2YI5UTS/cH5MRPogzxfem3dOg2N3RxcvnIYU/aWo3J25GvQWONCnEXxN8Z9cET
         ASme94ybWpKs0Qlc1dG9xChi9v1l4z7j5R8a6iifXz35Hz6mR/q3w0ZEn+E6RWjPVPUS
         Qn4bTBknZR6fFtRvn+kR+YBVJNk4jFuoh9QaWOXXQpawy6nLbUFjZ9GoqyLQXvAFRPIx
         3hlu3cEKrLfFv13vux9atAs1MzrqSJcJMcBPxD5r8TyGVXd7HYNg7Qw7Mk871a7H74Ll
         Zf4l2Ow2bQTXuc8fzDXGTMiRUcEvB9sZg+JwDaja24vPHOlvofUIAncWNdMbXkhKEwNG
         wbMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vNXfcjpndi9wyIiNjD+j3biphdOzIRcH22L61plM07w=;
        b=7YM6yblYx9zXEr5QmzgHgBOkCdhMCBJZiSTXJRKtSFbqew5Uvj5b92XJZDmkx9mg1l
         nfP1ETcDED8v5CmuD4G/1L9jVeDgk2k4ErzNlzkKJmAit5IXuqn6CfcaEbX9FRxzn8Xy
         fElSui5peoYDp5dJLYAldaNSDGc3X3125rUtRnrHIgfqjlXFZ2xo0M9ot2bD6qTC61B2
         LL19EgchIqVIAQFeTIZgotHEVfju8OJr/ga/KIzGB6/kN81i5vcnfd/CiLeoMfnN6OMl
         uS0O8Qq0e8HfK5Jkuw6oqWK/zFKJsZjep8w4o/Pp/RQuqtCQoHmpGOcDJNYQt1mcEb9G
         gZDw==
X-Gm-Message-State: AFqh2kod797Yml+WDz8uS3PPizdUCH5p8rIAPjcAe5D4gekFXtzxRCwJ
        wqYWaXAIReFx8VUvQaCWMg==
X-Google-Smtp-Source: AMrXdXtqqkNdeJGkDOxh0iLhZTaHoIckTCUnK1/1uyavkKn++YOTTrY9KM+n7OwgY3l/a3mdPohuXw==
X-Received: by 2002:a05:6a00:4489:b0:58d:982a:f1e9 with SMTP id cu9-20020a056a00448900b0058d982af1e9mr1694905pfb.22.1673767016414;
        Sat, 14 Jan 2023 23:16:56 -0800 (PST)
Received: from WDIR.. ([182.209.58.25])
        by smtp.gmail.com with ESMTPSA id z13-20020aa7990d000000b0058a313f4e4esm10272796pff.149.2023.01.14.23.16.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Jan 2023 23:16:55 -0800 (PST)
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
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: [bpf-next 10/10] samples/bpf: change _kern suffix to .bpf with BPF test programs
Date:   Sun, 15 Jan 2023 16:16:13 +0900
Message-Id: <20230115071613.125791-11-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230115071613.125791-1-danieltimlee@gmail.com>
References: <20230115071613.125791-1-danieltimlee@gmail.com>
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

This commit changes the _kern suffix to .bpf with the BPF test programs.
With this modification, test programs will inherit the benefit of the
new CLANG-BPF compile target.

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
 samples/bpf/Makefile                               | 14 +++++++-------
 .../{lwt_len_hist_kern.c => lwt_len_hist.bpf.c}    |  0
 samples/bpf/lwt_len_hist.sh                        |  2 +-
 .../bpf/{sock_flags_kern.c => sock_flags.bpf.c}    |  0
 samples/bpf/test_cgrp2_sock2.sh                    |  2 +-
 .../{test_cgrp2_tc_kern.c => test_cgrp2_tc.bpf.c}  |  0
 samples/bpf/test_cgrp2_tc.sh                       |  2 +-
 ...est_map_in_map_kern.c => test_map_in_map.bpf.c} |  0
 samples/bpf/test_map_in_map_user.c                 |  2 +-
 ...ad_kprobe_kern.c => test_overhead_kprobe.bpf.c} |  0
 ...ad_raw_tp_kern.c => test_overhead_raw_tp.bpf.c} |  0
 ...t_overhead_tp_kern.c => test_overhead_tp.bpf.c} |  0
 samples/bpf/test_overhead_user.c                   |  6 +++---
 13 files changed, 14 insertions(+), 14 deletions(-)
 rename samples/bpf/{lwt_len_hist_kern.c => lwt_len_hist.bpf.c} (100%)
 rename samples/bpf/{sock_flags_kern.c => sock_flags.bpf.c} (100%)
 rename samples/bpf/{test_cgrp2_tc_kern.c => test_cgrp2_tc.bpf.c} (100%)
 rename samples/bpf/{test_map_in_map_kern.c => test_map_in_map.bpf.c} (100%)
 rename samples/bpf/{test_overhead_kprobe_kern.c => test_overhead_kprobe.bpf.c} (100%)
 rename samples/bpf/{test_overhead_raw_tp_kern.c => test_overhead_raw_tp.bpf.c} (100%)
 rename samples/bpf/{test_overhead_tp_kern.c => test_overhead_tp.bpf.c} (100%)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 22039a0a5b35..615f24ebc49c 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -131,7 +131,7 @@ always-y += tracex4_kern.o
 always-y += tracex5_kern.o
 always-y += tracex6_kern.o
 always-y += tracex7_kern.o
-always-y += sock_flags_kern.o
+always-y += sock_flags.bpf.o
 always-y += test_probe_write_user.bpf.o
 always-y += trace_output.bpf.o
 always-y += tcbpf1_kern.o
@@ -140,19 +140,19 @@ always-y += lathist_kern.o
 always-y += offwaketime_kern.o
 always-y += spintest_kern.o
 always-y += map_perf_test.bpf.o
-always-y += test_overhead_tp_kern.o
-always-y += test_overhead_raw_tp_kern.o
-always-y += test_overhead_kprobe_kern.o
+always-y += test_overhead_tp.bpf.o
+always-y += test_overhead_raw_tp.bpf.o
+always-y += test_overhead_kprobe.bpf.o
 always-y += parse_varlen.o parse_simple.o parse_ldabs.o
-always-y += test_cgrp2_tc_kern.o
+always-y += test_cgrp2_tc.bpf.o
 always-y += xdp1_kern.o
 always-y += xdp2_kern.o
 always-y += test_current_task_under_cgroup.bpf.o
 always-y += trace_event_kern.o
 always-y += sampleip_kern.o
-always-y += lwt_len_hist_kern.o
+always-y += lwt_len_hist.bpf.o
 always-y += xdp_tx_iptunnel_kern.o
-always-y += test_map_in_map_kern.o
+always-y += test_map_in_map.bpf.o
 always-y += tcp_synrto_kern.o
 always-y += tcp_rwnd_kern.o
 always-y += tcp_bufs_kern.o
diff --git a/samples/bpf/lwt_len_hist_kern.c b/samples/bpf/lwt_len_hist.bpf.c
similarity index 100%
rename from samples/bpf/lwt_len_hist_kern.c
rename to samples/bpf/lwt_len_hist.bpf.c
diff --git a/samples/bpf/lwt_len_hist.sh b/samples/bpf/lwt_len_hist.sh
index ff7d1ba0f7ed..7078bfcc4f4d 100755
--- a/samples/bpf/lwt_len_hist.sh
+++ b/samples/bpf/lwt_len_hist.sh
@@ -4,7 +4,7 @@
 NS1=lwt_ns1
 VETH0=tst_lwt1a
 VETH1=tst_lwt1b
-BPF_PROG=lwt_len_hist_kern.o
+BPF_PROG=lwt_len_hist.bpf.o
 TRACE_ROOT=/sys/kernel/debug/tracing
 
 function cleanup {
diff --git a/samples/bpf/sock_flags_kern.c b/samples/bpf/sock_flags.bpf.c
similarity index 100%
rename from samples/bpf/sock_flags_kern.c
rename to samples/bpf/sock_flags.bpf.c
diff --git a/samples/bpf/test_cgrp2_sock2.sh b/samples/bpf/test_cgrp2_sock2.sh
index 00cc8d15373c..82acff93d739 100755
--- a/samples/bpf/test_cgrp2_sock2.sh
+++ b/samples/bpf/test_cgrp2_sock2.sh
@@ -5,7 +5,7 @@ BPFFS=/sys/fs/bpf
 MY_DIR=$(dirname $0)
 TEST=$MY_DIR/test_cgrp2_sock2
 LINK_PIN=$BPFFS/test_cgrp2_sock2
-BPF_PROG=$MY_DIR/sock_flags_kern.o
+BPF_PROG=$MY_DIR/sock_flags.bpf.o
 
 function config_device {
 	ip netns add at_ns0
diff --git a/samples/bpf/test_cgrp2_tc_kern.c b/samples/bpf/test_cgrp2_tc.bpf.c
similarity index 100%
rename from samples/bpf/test_cgrp2_tc_kern.c
rename to samples/bpf/test_cgrp2_tc.bpf.c
diff --git a/samples/bpf/test_cgrp2_tc.sh b/samples/bpf/test_cgrp2_tc.sh
index 37a2c9cba6d0..38e8dbc9d16e 100755
--- a/samples/bpf/test_cgrp2_tc.sh
+++ b/samples/bpf/test_cgrp2_tc.sh
@@ -4,7 +4,7 @@
 MY_DIR=$(dirname $0)
 # Details on the bpf prog
 BPF_CGRP2_ARRAY_NAME='test_cgrp2_array_pin'
-BPF_PROG="$MY_DIR/test_cgrp2_tc_kern.o"
+BPF_PROG="$MY_DIR/test_cgrp2_tc.bpf.o"
 BPF_SECTION='filter'
 
 [ -z "$TC" ] && TC='tc'
diff --git a/samples/bpf/test_map_in_map_kern.c b/samples/bpf/test_map_in_map.bpf.c
similarity index 100%
rename from samples/bpf/test_map_in_map_kern.c
rename to samples/bpf/test_map_in_map.bpf.c
diff --git a/samples/bpf/test_map_in_map_user.c b/samples/bpf/test_map_in_map_user.c
index 652ec720533d..9e79df4071f5 100644
--- a/samples/bpf/test_map_in_map_user.c
+++ b/samples/bpf/test_map_in_map_user.c
@@ -120,7 +120,7 @@ int main(int argc, char **argv)
 	struct bpf_object *obj;
 	char filename[256];
 
-	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
+	snprintf(filename, sizeof(filename), "%s.bpf.o", argv[0]);
 	obj = bpf_object__open_file(filename, NULL);
 	if (libbpf_get_error(obj)) {
 		fprintf(stderr, "ERROR: opening BPF object file failed\n");
diff --git a/samples/bpf/test_overhead_kprobe_kern.c b/samples/bpf/test_overhead_kprobe.bpf.c
similarity index 100%
rename from samples/bpf/test_overhead_kprobe_kern.c
rename to samples/bpf/test_overhead_kprobe.bpf.c
diff --git a/samples/bpf/test_overhead_raw_tp_kern.c b/samples/bpf/test_overhead_raw_tp.bpf.c
similarity index 100%
rename from samples/bpf/test_overhead_raw_tp_kern.c
rename to samples/bpf/test_overhead_raw_tp.bpf.c
diff --git a/samples/bpf/test_overhead_tp_kern.c b/samples/bpf/test_overhead_tp.bpf.c
similarity index 100%
rename from samples/bpf/test_overhead_tp_kern.c
rename to samples/bpf/test_overhead_tp.bpf.c
diff --git a/samples/bpf/test_overhead_user.c b/samples/bpf/test_overhead_user.c
index ce28d30f852e..dbd86f7b1473 100644
--- a/samples/bpf/test_overhead_user.c
+++ b/samples/bpf/test_overhead_user.c
@@ -189,7 +189,7 @@ int main(int argc, char **argv)
 
 	if (test_flags & 0xC) {
 		snprintf(filename, sizeof(filename),
-			 "%s_kprobe_kern.o", argv[0]);
+			 "%s_kprobe.bpf.o", argv[0]);
 
 		printf("w/KPROBE\n");
 		err = load_progs(filename);
@@ -201,7 +201,7 @@ int main(int argc, char **argv)
 
 	if (test_flags & 0x30) {
 		snprintf(filename, sizeof(filename),
-			 "%s_tp_kern.o", argv[0]);
+			 "%s_tp.bpf.o", argv[0]);
 		printf("w/TRACEPOINT\n");
 		err = load_progs(filename);
 		if (!err)
@@ -212,7 +212,7 @@ int main(int argc, char **argv)
 
 	if (test_flags & 0xC0) {
 		snprintf(filename, sizeof(filename),
-			 "%s_raw_tp_kern.o", argv[0]);
+			 "%s_raw_tp.bpf.o", argv[0]);
 		printf("w/RAW_TRACEPOINT\n");
 		err = load_progs(filename);
 		if (!err)
-- 
2.34.1

