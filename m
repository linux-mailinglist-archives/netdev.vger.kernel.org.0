Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA6CD65200C
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 13:00:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231648AbiLTMAF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 07:00:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232097AbiLTL7p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 06:59:45 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2E6D16598;
        Tue, 20 Dec 2022 03:59:44 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id fy4so12214527pjb.0;
        Tue, 20 Dec 2022 03:59:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YZV/Ygg5ZLK/icKlwhdiYUcrDkEBcDRF0QNzCkC6zPE=;
        b=KnAXW0kFi43Q478adbdX8W+JEMl1sSx3fiivWNYoQ1WAhPGMmvN9yQYcXRQaLq5O+O
         6LTMT58pWHvfDSIDbD2w1DSew8tZXkMegOxx/qz9F1HXLQbQiU3ks80bOF0SadqAs8Kf
         1bYOLZ3PrDW1RuGccmsEr8SKzaedHnRDTz8CR+n2bPpePERFCoShUNVi/gph2+TkSsjw
         YouDtAX8qHDRVaAPN7fL0zqEve5ABl8O/MZ058hPYCBQJ7LC0QJtksRZL7k6InzcWM7K
         BRP2HAYB+OSbtJed6VajdU/dqE8IFFpzvLl+YbJvJje8cGll5lAFK8CLywJCKtDR7Jbz
         +8ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YZV/Ygg5ZLK/icKlwhdiYUcrDkEBcDRF0QNzCkC6zPE=;
        b=EhgReimKL0X/issNAFFwuQMN6DofTr3ZNng1pWhSXD1jgpfhLYgQG4mSmuZ1D6pe36
         mI8k2bMx1Hbw72O20kP6T3626UoXqWbrwcaDpCngEjiISc1fh+aVM+qlv+s9NIF2yIzl
         N78mtzoYZrE6AzVj2nhamqOlQqKYtc+12LY8aDY/Tw7PaYgPyAJrJZCaY3RD6mFDgFoK
         cung8E81VUC+cpccNnELe51i+LkfcNuXQkZROIkJsFCot9GyLvXE2jVg41DKpFCV1aWW
         2qkGQrY6yx5VKhihvYYqOi0pwVbbAmTDVJm8R3eB2z/0IuAiGtSi3naUO4yEdQOrC0uc
         5Y7Q==
X-Gm-Message-State: ANoB5pk0aSrLVJzPWI1vLCXrBuOSWjA4Fz+tUyHILyLrZkUzIdY+Yj5R
        bTA0nHIVnPpJum7HWL0LkQ==
X-Google-Smtp-Source: AA0mqf4cC9ovgUH8iqDQBDUrfZ47OoxQUaOkQKsKXu3VnDq/oEimiPN5x3Wi5NkpGDsXCQyj2P7j9Q==
X-Received: by 2002:a17:90b:702:b0:219:5f68:586e with SMTP id s2-20020a17090b070200b002195f68586emr48418537pjz.18.1671537584364;
        Tue, 20 Dec 2022 03:59:44 -0800 (PST)
Received: from WDIR.. ([182.209.58.25])
        by smtp.gmail.com with ESMTPSA id z10-20020a17090a170a00b00219752c8ea3sm10982482pjd.48.2022.12.20.03.59.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Dec 2022 03:59:43 -0800 (PST)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Yonghong Song <yhs@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: [bpf-next v2 5/5] samples/bpf: use BPF_KSYSCALL macro in syscall tracing programs
Date:   Tue, 20 Dec 2022 20:59:28 +0900
Message-Id: <20221220115928.11979-6-danieltimlee@gmail.com>
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

