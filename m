Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBCF764DA8E
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 12:40:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230170AbiLOLkJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 06:40:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230153AbiLOLj5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 06:39:57 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FA4D2980F;
        Thu, 15 Dec 2022 03:39:53 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id 130so6498801pfu.8;
        Thu, 15 Dec 2022 03:39:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YZV/Ygg5ZLK/icKlwhdiYUcrDkEBcDRF0QNzCkC6zPE=;
        b=Z0JO/QGuZvyYJLCO2Str8t+mMWeJLQtOMZQEG84H1JPE/fWiA91MXJ20jnM+i8FFeS
         pA3G0u250OCPHmxXNUAMX7IEzY17ngCs0BLmCmy+Pw6YhLkeUWzEiugArw4STlWFh30p
         GQD5e7Sciz/TJlX1tRkWzJgDVjCwjPszM+T+AxCA+T1TisY7WmYOXD2RM2Nt1Froxcaa
         c6UNwh3b4qWdoxhQmm1lDQVQa5Si/235OJauAmUyiwkJirbSog6WhKyXUckqIdLeMtAF
         /kfZQ+nOyrtvlFowqgmN3oSDUrmn0DlxNA9KUydsOBZtwjiMWoukU859Iq8RabZLfuDt
         SYMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YZV/Ygg5ZLK/icKlwhdiYUcrDkEBcDRF0QNzCkC6zPE=;
        b=k/qst3kQNZA9u81k7p3cyX7Tt8pVOFr9m+4RMPMCpXcSxMNpSFqDQxyGo+j/MEfHjd
         7O+qnSyPa8Ldel6qRKaVIeeFANmL+vvIFIb8aRNbw8ADWJs8YyfDsk2HNCQsKQnDy8Me
         j1jrbOXzlDZfybqmlXDNjrMcJElS75vYRKJ3/CrTvyhnI4ASx+jzibwDtLSZF/deezG+
         Sc2vymXl9RBvlhkhMf9sQXR7T30Kk1zREw7BWwQGUhEL8Qy9TfB/EBxIgmtC20bp4T4D
         ObQtmfyfcGEKzdNp66GJxG5tqSb3/xwvozKzq1jRfIdTLg+wxgynKknhLaLTxjAoHDaK
         dsyg==
X-Gm-Message-State: ANoB5pli0OX8p2txUfH21ldSxrR1ME/rZk6K19lX+GfjPM3lc43XuNEY
        +QYyWptnMT8qQAKIGp2ixg==
X-Google-Smtp-Source: AA0mqf5g5Hvdo/S5GkyexgFz462/UDBuFQhXTZeatIJ8PYLEWd0x0CXoMmfhE69IVWGQRaaQYYuhiQ==
X-Received: by 2002:a05:6a00:72f:b0:56b:e159:4d3b with SMTP id 15-20020a056a00072f00b0056be1594d3bmr25717795pfm.30.1671104393201;
        Thu, 15 Dec 2022 03:39:53 -0800 (PST)
Received: from WDIR.. ([182.209.58.25])
        by smtp.gmail.com with ESMTPSA id g30-20020aa79dde000000b00574d38f4d37sm1553440pfq.45.2022.12.15.03.39.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Dec 2022 03:39:52 -0800 (PST)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Yonghong Song <yhs@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: [bpf-next 5/5] samples: bpf: use BPF_KSYSCALL macro in syscall tracing programs
Date:   Thu, 15 Dec 2022 20:39:37 +0900
Message-Id: <20221215113937.113936-6-danieltimlee@gmail.com>
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

This commit enhances the syscall tracing programs by using the
BPF_SYSCALL macro to reduce the inconvenience of parsing arguments from
pt_regs. By simplifying argument extraction, bpf program will become
clear to understand.

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
 samples/bpf/map_perf_test.bpf.c               | 26 ++++++++-----------
 .../bpf/test_current_task_under_cgroup.bpf.c  |  4 ++-
 samples/bpf/test_probe_write_user.bpf.c       | 12 ++++-----
 3 files changed, 19 insertions(+), 23 deletions(-)

diff --git a/samples/bpf/map_perf_test.bpf.c b/samples/bpf/map_perf_test.bpf.c
index 0c7885057ffe..3cdeba2afe12 100644
--- a/samples/bpf/map_perf_test.bpf.c
+++ b/samples/bpf/map_perf_test.bpf.c
@@ -101,7 +101,7 @@ struct {
 } lru_hash_lookup_map SEC(".maps");
 
 SEC("ksyscall/getuid")
-int stress_hmap(struct pt_regs *ctx)
+int BPF_KSYSCALL(stress_hmap)
 {
 	u32 key = bpf_get_current_pid_tgid();
 	long init_val = 1;
@@ -119,7 +119,7 @@ int stress_hmap(struct pt_regs *ctx)
 }
 
 SEC("ksyscall/geteuid")
-int stress_percpu_hmap(struct pt_regs *ctx)
+int BPF_KSYSCALL(stress_percpu_hmap)
 {
 	u32 key = bpf_get_current_pid_tgid();
 	long init_val = 1;
@@ -136,7 +136,7 @@ int stress_percpu_hmap(struct pt_regs *ctx)
 }
 
 SEC("ksyscall/getgid")
-int stress_hmap_alloc(struct pt_regs *ctx)
+int BPF_KSYSCALL(stress_hmap_alloc)
 {
 	u32 key = bpf_get_current_pid_tgid();
 	long init_val = 1;
@@ -153,7 +153,7 @@ int stress_hmap_alloc(struct pt_regs *ctx)
 }
 
 SEC("ksyscall/getegid")
-int stress_percpu_hmap_alloc(struct pt_regs *ctx)
+int BPF_KSYSCALL(stress_percpu_hmap_alloc)
 {
 	u32 key = bpf_get_current_pid_tgid();
 	long init_val = 1;
@@ -168,11 +168,10 @@ int stress_percpu_hmap_alloc(struct pt_regs *ctx)
 	}
 	return 0;
 }
-
 SEC("ksyscall/connect")
-int stress_lru_hmap_alloc(struct pt_regs *ctx)
+int BPF_KSYSCALL(stress_lru_hmap_alloc, int fd, struct sockaddr_in *uservaddr,
+		 int addrlen)
 {
-	struct pt_regs *real_regs = (struct pt_regs *)PT_REGS_PARM1_CORE(ctx);
 	char fmt[] = "Failed at stress_lru_hmap_alloc. ret:%dn";
 	union {
 		u16 dst6[8];
@@ -185,14 +184,11 @@ int stress_lru_hmap_alloc(struct pt_regs *ctx)
 			u32 key;
 		};
 	} test_params;
-	struct sockaddr_in6 *in6;
+	struct sockaddr_in6 *in6 = (struct sockaddr_in6 *)uservaddr;
 	u16 test_case;
-	int addrlen, ret;
 	long val = 1;
 	u32 key = 0;
-
-	in6 = (struct sockaddr_in6 *)PT_REGS_PARM2_CORE(real_regs);
-	addrlen = (int)PT_REGS_PARM3_CORE(real_regs);
+	int ret;
 
 	if (addrlen != sizeof(*in6))
 		return 0;
@@ -250,7 +246,7 @@ int stress_lru_hmap_alloc(struct pt_regs *ctx)
 }
 
 SEC("ksyscall/gettid")
-int stress_lpm_trie_map_alloc(struct pt_regs *ctx)
+int BPF_KSYSCALL(stress_lpm_trie_map_alloc)
 {
 	union {
 		u32 b32[2];
@@ -272,7 +268,7 @@ int stress_lpm_trie_map_alloc(struct pt_regs *ctx)
 }
 
 SEC("ksyscall/getpgid")
-int stress_hash_map_lookup(struct pt_regs *ctx)
+int BPF_KSYSCALL(stress_hash_map_lookup)
 {
 	u32 key = 1, i;
 	long *value;
@@ -285,7 +281,7 @@ int stress_hash_map_lookup(struct pt_regs *ctx)
 }
 
 SEC("ksyscall/getppid")
-int stress_array_map_lookup(struct pt_regs *ctx)
+int BPF_KSYSCALL(stress_array_map_lookup)
 {
 	u32 key = 1, i;
 	long *value;
diff --git a/samples/bpf/test_current_task_under_cgroup.bpf.c b/samples/bpf/test_current_task_under_cgroup.bpf.c
index 0b059cee3cba..58b9cf7ed659 100644
--- a/samples/bpf/test_current_task_under_cgroup.bpf.c
+++ b/samples/bpf/test_current_task_under_cgroup.bpf.c
@@ -8,6 +8,8 @@
 #include "vmlinux.h"
 #include <linux/version.h>
 #include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+#include <bpf/bpf_core_read.h>
 
 struct {
 	__uint(type, BPF_MAP_TYPE_CGROUP_ARRAY);
@@ -25,7 +27,7 @@ struct {
 
 /* Writes the last PID that called sync to a map at index 0 */
 SEC("ksyscall/sync")
-int bpf_prog1(struct pt_regs *ctx)
+int BPF_KSYSCALL(bpf_prog1)
 {
 	u64 pid = bpf_get_current_pid_tgid();
 	int idx = 0;
diff --git a/samples/bpf/test_probe_write_user.bpf.c b/samples/bpf/test_probe_write_user.bpf.c
index a0f10c5ca273..a4f3798b7fb0 100644
--- a/samples/bpf/test_probe_write_user.bpf.c
+++ b/samples/bpf/test_probe_write_user.bpf.c
@@ -27,24 +27,22 @@ struct {
  * of course, across platforms, and over time, the ABI may change.
  */
 SEC("ksyscall/connect")
-int bpf_prog1(struct pt_regs *ctx)
+int BPF_KSYSCALL(bpf_prog1, int fd, struct sockaddr_in *uservaddr,
+		 int addrlen)
 {
-	struct pt_regs *real_regs = (struct pt_regs *)PT_REGS_PARM1_CORE(ctx);
-	void *sockaddr_arg = (void *)PT_REGS_PARM2_CORE(real_regs);
-	int sockaddr_len = (int)PT_REGS_PARM3_CORE(real_regs);
 	struct sockaddr_in new_addr, orig_addr = {};
 	struct sockaddr_in *mapped_addr;
 
-	if (sockaddr_len > sizeof(orig_addr))
+	if (addrlen > sizeof(orig_addr))
 		return 0;
 
-	if (bpf_probe_read_user(&orig_addr, sizeof(orig_addr), sockaddr_arg) != 0)
+	if (bpf_probe_read_user(&orig_addr, sizeof(orig_addr), uservaddr) != 0)
 		return 0;
 
 	mapped_addr = bpf_map_lookup_elem(&dnat_map, &orig_addr);
 	if (mapped_addr != NULL) {
 		memcpy(&new_addr, mapped_addr, sizeof(new_addr));
-		bpf_probe_write_user(sockaddr_arg, &new_addr,
+		bpf_probe_write_user(uservaddr, &new_addr,
 				     sizeof(new_addr));
 	}
 	return 0;
-- 
2.34.1

