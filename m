Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3BFB652002
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 12:59:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233298AbiLTL7m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 06:59:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbiLTL7g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 06:59:36 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C93F410FFE;
        Tue, 20 Dec 2022 03:59:35 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id k88-20020a17090a4ce100b00219d0b857bcso11899639pjh.1;
        Tue, 20 Dec 2022 03:59:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TvQJZFMoxTOwekOiX/Jb1dzBuANkjKBcCXiZ5v03HBY=;
        b=WPCDGZC3YWdIIuy2QTvJC3RJb7+odpB+kKFxJDIxuW4xE0YmLYgvzyn9ri6GerPyeX
         vgFrCBmfcDQ8Ow4JvU3ZCYJJf5Dkj5mf8HfWRp4Etk3JIYpQzEAtMsgBD1RvEuUerm4b
         xh/XT+KGnx3J9eRuyswQz6fm+/WmN7wPoQqxCsuIR4ARgYcS2R/bWQ3Z1N7BmKxH3aag
         AN5tlD8HYkqGCAxAafZPcqxD1ygvdSlcnW58hCkCI4980UMJbp2qK8e0pU5eYM80FIRK
         IJav7VZOHbokN5Nl/SYXGISy2QUbIyPQS7uk1eJGSRpe82XGFrlkHrHm+y7KcnDeDtlE
         45CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TvQJZFMoxTOwekOiX/Jb1dzBuANkjKBcCXiZ5v03HBY=;
        b=q+UGCfXHrpx7iBrwm0eOusdWWApU/6DRIOn2z7xvix+8mTp4PWJFpZAyksj3lmlDjY
         Gx0yr4xYYqwoYLBAU7Bqs0TDMUY3l+o1eSCnsDmSbi68PNZZWbN+bvXlwVDuE4DXLWVW
         vpOLf2A9ojnq2CaG1lESdwoG6cRwRbxqKUrAlif+24Xvyd25OewjpP56WdpPYTe5zHSj
         o4wF9rDHqUCZBmKA3QTGJdoFVg9+VQmcY9ZzlTytDKqWROLEeqxZMaY8XAqUtj0buvjR
         j83BT9B/1q6hXX/LnA2nivp8Cfl8LZkLhp0Iyc94oIXR8udjLKaXSup69kFP7YO1p7zC
         9YxA==
X-Gm-Message-State: ANoB5pn9GN7lRUoQ0t9TNV3QB4JJGXgXnJubvRnTLRs4cvIHQLGGRHOi
        U5yia+KMYQ9sFRycMZXjfBpJ3zW414sr
X-Google-Smtp-Source: AA0mqf4IK0fXcB9ZxLN41Aa4RRKjo93be5X0PIqp5zot9hvwDQdpWJoO6YonssiJfWHnyStF4dEYfA==
X-Received: by 2002:a17:90b:1207:b0:219:5bd1:a32d with SMTP id gl7-20020a17090b120700b002195bd1a32dmr47898037pjb.39.1671537575191;
        Tue, 20 Dec 2022 03:59:35 -0800 (PST)
Received: from WDIR.. ([182.209.58.25])
        by smtp.gmail.com with ESMTPSA id z10-20020a17090a170a00b00219752c8ea3sm10982482pjd.48.2022.12.20.03.59.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Dec 2022 03:59:34 -0800 (PST)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Yonghong Song <yhs@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: [bpf-next v2 1/5] samples/bpf: use kyscall instead of kprobe in syscall tracing program
Date:   Tue, 20 Dec 2022 20:59:24 +0900
Message-Id: <20221220115928.11979-2-danieltimlee@gmail.com>
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

Syscall tracing using kprobe is quite unstable. Since it uses the exact
name of the kernel function, the program might broke due to the rename
of a function. The problem can also be caused by a changes in the
arguments of the function to which the kprobe connects.

In this commit, ksyscall is used instead of kprobe. By using ksyscall,
libbpf will detect the appropriate kernel function name.
(e.g. sys_write -> __s390_sys_write). This eliminates the need to worry
about which wrapper function to attach in order to parse arguments.

In addition, ksyscall provides more fine method with attaching system
call, the coarse SYSCALL helper at trace_common.h can be removed.

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
 samples/bpf/map_perf_test_kern.c                | 17 ++++++++---------
 .../bpf/test_current_task_under_cgroup_kern.c   |  3 +--
 samples/bpf/test_map_in_map_kern.c              |  1 -
 samples/bpf/test_probe_write_user_kern.c        |  3 +--
 samples/bpf/trace_common.h                      | 13 -------------
 samples/bpf/trace_output_kern.c                 |  3 +--
 samples/bpf/tracex2_kern.c                      |  3 +--
 7 files changed, 12 insertions(+), 31 deletions(-)
 delete mode 100644 samples/bpf/trace_common.h

diff --git a/samples/bpf/map_perf_test_kern.c b/samples/bpf/map_perf_test_kern.c
index 7342c5b2f278..874e2f7e3d5d 100644
--- a/samples/bpf/map_perf_test_kern.c
+++ b/samples/bpf/map_perf_test_kern.c
@@ -11,7 +11,6 @@
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_tracing.h>
 #include <bpf/bpf_core_read.h>
-#include "trace_common.h"
 
 #define MAX_ENTRIES 1000
 #define MAX_NR_CPUS 1024
@@ -102,7 +101,7 @@ struct {
 	__uint(max_entries, MAX_ENTRIES);
 } lru_hash_lookup_map SEC(".maps");
 
-SEC("kprobe/" SYSCALL(sys_getuid))
+SEC("ksyscall/getuid")
 int stress_hmap(struct pt_regs *ctx)
 {
 	u32 key = bpf_get_current_pid_tgid();
@@ -120,7 +119,7 @@ int stress_hmap(struct pt_regs *ctx)
 	return 0;
 }
 
-SEC("kprobe/" SYSCALL(sys_geteuid))
+SEC("ksyscall/geteuid")
 int stress_percpu_hmap(struct pt_regs *ctx)
 {
 	u32 key = bpf_get_current_pid_tgid();
@@ -137,7 +136,7 @@ int stress_percpu_hmap(struct pt_regs *ctx)
 	return 0;
 }
 
-SEC("kprobe/" SYSCALL(sys_getgid))
+SEC("ksyscall/getgid")
 int stress_hmap_alloc(struct pt_regs *ctx)
 {
 	u32 key = bpf_get_current_pid_tgid();
@@ -154,7 +153,7 @@ int stress_hmap_alloc(struct pt_regs *ctx)
 	return 0;
 }
 
-SEC("kprobe/" SYSCALL(sys_getegid))
+SEC("ksyscall/getegid")
 int stress_percpu_hmap_alloc(struct pt_regs *ctx)
 {
 	u32 key = bpf_get_current_pid_tgid();
@@ -171,7 +170,7 @@ int stress_percpu_hmap_alloc(struct pt_regs *ctx)
 	return 0;
 }
 
-SEC("kprobe/" SYSCALL(sys_connect))
+SEC("ksyscall/connect")
 int stress_lru_hmap_alloc(struct pt_regs *ctx)
 {
 	struct pt_regs *real_regs = (struct pt_regs *)PT_REGS_PARM1_CORE(ctx);
@@ -251,7 +250,7 @@ int stress_lru_hmap_alloc(struct pt_regs *ctx)
 	return 0;
 }
 
-SEC("kprobe/" SYSCALL(sys_gettid))
+SEC("ksyscall/gettid")
 int stress_lpm_trie_map_alloc(struct pt_regs *ctx)
 {
 	union {
@@ -273,7 +272,7 @@ int stress_lpm_trie_map_alloc(struct pt_regs *ctx)
 	return 0;
 }
 
-SEC("kprobe/" SYSCALL(sys_getpgid))
+SEC("ksyscall/getpgid")
 int stress_hash_map_lookup(struct pt_regs *ctx)
 {
 	u32 key = 1, i;
@@ -286,7 +285,7 @@ int stress_hash_map_lookup(struct pt_regs *ctx)
 	return 0;
 }
 
-SEC("kprobe/" SYSCALL(sys_getppid))
+SEC("ksyscall/getppid")
 int stress_array_map_lookup(struct pt_regs *ctx)
 {
 	u32 key = 1, i;
diff --git a/samples/bpf/test_current_task_under_cgroup_kern.c b/samples/bpf/test_current_task_under_cgroup_kern.c
index fbd43e2bb4d3..541fc861b984 100644
--- a/samples/bpf/test_current_task_under_cgroup_kern.c
+++ b/samples/bpf/test_current_task_under_cgroup_kern.c
@@ -10,7 +10,6 @@
 #include <linux/version.h>
 #include <bpf/bpf_helpers.h>
 #include <uapi/linux/utsname.h>
-#include "trace_common.h"
 
 struct {
 	__uint(type, BPF_MAP_TYPE_CGROUP_ARRAY);
@@ -27,7 +26,7 @@ struct {
 } perf_map SEC(".maps");
 
 /* Writes the last PID that called sync to a map at index 0 */
-SEC("kprobe/" SYSCALL(sys_sync))
+SEC("ksyscall/sync")
 int bpf_prog1(struct pt_regs *ctx)
 {
 	u64 pid = bpf_get_current_pid_tgid();
diff --git a/samples/bpf/test_map_in_map_kern.c b/samples/bpf/test_map_in_map_kern.c
index b0200c8eac09..0e17f9ade5c5 100644
--- a/samples/bpf/test_map_in_map_kern.c
+++ b/samples/bpf/test_map_in_map_kern.c
@@ -13,7 +13,6 @@
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_tracing.h>
 #include <bpf/bpf_core_read.h>
-#include "trace_common.h"
 
 #define MAX_NR_PORTS 65536
 
diff --git a/samples/bpf/test_probe_write_user_kern.c b/samples/bpf/test_probe_write_user_kern.c
index 220a96438d75..d60cabaaf753 100644
--- a/samples/bpf/test_probe_write_user_kern.c
+++ b/samples/bpf/test_probe_write_user_kern.c
@@ -11,7 +11,6 @@
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_tracing.h>
 #include <bpf/bpf_core_read.h>
-#include "trace_common.h"
 
 struct {
 	__uint(type, BPF_MAP_TYPE_HASH);
@@ -28,7 +27,7 @@ struct {
  * This example sits on a syscall, and the syscall ABI is relatively stable
  * of course, across platforms, and over time, the ABI may change.
  */
-SEC("kprobe/" SYSCALL(sys_connect))
+SEC("ksyscall/connect")
 int bpf_prog1(struct pt_regs *ctx)
 {
 	struct pt_regs *real_regs = (struct pt_regs *)PT_REGS_PARM1_CORE(ctx);
diff --git a/samples/bpf/trace_common.h b/samples/bpf/trace_common.h
deleted file mode 100644
index 8cb5400aed1f..000000000000
--- a/samples/bpf/trace_common.h
+++ /dev/null
@@ -1,13 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-#ifndef __TRACE_COMMON_H
-#define __TRACE_COMMON_H
-
-#ifdef __x86_64__
-#define SYSCALL(SYS) "__x64_" __stringify(SYS)
-#elif defined(__s390x__)
-#define SYSCALL(SYS) "__s390x_" __stringify(SYS)
-#else
-#define SYSCALL(SYS)  __stringify(SYS)
-#endif
-
-#endif
diff --git a/samples/bpf/trace_output_kern.c b/samples/bpf/trace_output_kern.c
index b64815af0943..a481abf8c4c5 100644
--- a/samples/bpf/trace_output_kern.c
+++ b/samples/bpf/trace_output_kern.c
@@ -2,7 +2,6 @@
 #include <linux/version.h>
 #include <uapi/linux/bpf.h>
 #include <bpf/bpf_helpers.h>
-#include "trace_common.h"
 
 struct {
 	__uint(type, BPF_MAP_TYPE_PERF_EVENT_ARRAY);
@@ -11,7 +10,7 @@ struct {
 	__uint(max_entries, 2);
 } my_map SEC(".maps");
 
-SEC("kprobe/" SYSCALL(sys_write))
+SEC("ksyscall/write")
 int bpf_prog1(struct pt_regs *ctx)
 {
 	struct S {
diff --git a/samples/bpf/tracex2_kern.c b/samples/bpf/tracex2_kern.c
index 93e0b7680b4f..82091facb83c 100644
--- a/samples/bpf/tracex2_kern.c
+++ b/samples/bpf/tracex2_kern.c
@@ -10,7 +10,6 @@
 #include <uapi/linux/bpf.h>
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_tracing.h>
-#include "trace_common.h"
 
 struct {
 	__uint(type, BPF_MAP_TYPE_HASH);
@@ -78,7 +77,7 @@ struct {
 	__uint(max_entries, 1024);
 } my_hist_map SEC(".maps");
 
-SEC("kprobe/" SYSCALL(sys_write))
+SEC("ksyscall/write")
 int bpf_prog3(struct pt_regs *ctx)
 {
 	long write_size = PT_REGS_PARM3(ctx);
-- 
2.34.1

