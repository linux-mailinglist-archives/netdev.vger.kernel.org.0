Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D86376558D2
	for <lists+netdev@lfdr.de>; Sat, 24 Dec 2022 08:15:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbiLXHPl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Dec 2022 02:15:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbiLXHPi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Dec 2022 02:15:38 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29B8310041;
        Fri, 23 Dec 2022 23:15:37 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id c8-20020a17090a4d0800b00225c3614161so3431690pjg.5;
        Fri, 23 Dec 2022 23:15:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0NDUOj4bd5P9okQ+fNcx9acs9ETFFICaPPmEE79XHo4=;
        b=UIYisnLPYnPv8I6/so7/vvbDnAz6Od9PV+aENtxh7ChmssYGzedHmL6A9QtgDdh4aV
         mBC2RHHjEX3Wejfpsu4C9JJ+LUcBJihYtzr/jITodzyVfaosVmvE4wgVGH+mkUEj2dED
         CiXOtbEBjULJuOLxVU8cSLT9h2sM8frr0qgAH0EE23E/EBuEr4e8VbAMh9fZseCKGCQm
         OZW4E0e8/4U+X5q9HmTXpuiy6Tpe+p6ImsyxpsKTw2Xe2bOgN9bNCGxlovOzUk1T9nBj
         jiD/nfYYSxHnOb6fy2R5It9RVp/jumwgSNVr5CjzT5XMRM+gFp++ZDnrxQA7MCc47/DS
         mDWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0NDUOj4bd5P9okQ+fNcx9acs9ETFFICaPPmEE79XHo4=;
        b=FkhVmnLjdu5eI7dmCAu6F1Fb6azOfbEE5ODptrziSbJe5lxauFtloG0MgxxX+2Uw/D
         /DKK8aZBqSAZrJ2S1ovUAuQNKZNzRJbJ7fNq49MEKQmJHKOUk6IjiPVmapvehKLCRagZ
         W1m5LZn2t+7Mr6nE6xtCHyq+2l/SZSsZwU9eygXyauNrhNC9eGAXc6BNKFWhZ+AJu06v
         uAm34KgeeFwB+o3EjOHaykjyCDq95Thl5uG3LPTzBxgpNgYuLeuipO5FzJcbQby+Ih2e
         iQgjR6vCorMMJ/dhezK766rCEk29kRA0C1WvoTmcpjoz4SvxP1KQqgitPVEijakkwQn/
         aIxA==
X-Gm-Message-State: AFqh2kqCLwrwnKw0mVHx7hM3R6bIt3vSYnQ71uTgQZdOdxro+AWvF0ii
        KRYKQ7DO7FympAVSHluNAg==
X-Google-Smtp-Source: AMrXdXsVN2ejtTMCxmmadavpGdAkP1wPuZAXsIyH9s90AUtTrVi6ndzSTNpgxE8ZXRXr653ZEGGWlw==
X-Received: by 2002:a17:902:d683:b0:189:f1de:2d4e with SMTP id v3-20020a170902d68300b00189f1de2d4emr13886939ply.45.1671866136576;
        Fri, 23 Dec 2022 23:15:36 -0800 (PST)
Received: from WDIR.. ([182.209.58.25])
        by smtp.gmail.com with ESMTPSA id bf4-20020a170902b90400b00186b7443082sm3433222plb.195.2022.12.23.23.15.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Dec 2022 23:15:36 -0800 (PST)
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
Subject: [bpf-next v3 1/6] samples/bpf: use kyscall instead of kprobe in syscall tracing program
Date:   Sat, 24 Dec 2022 16:15:22 +0900
Message-Id: <20221224071527.2292-2-danieltimlee@gmail.com>
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
index 5bc696bac27d..ecdca9620ece 100644
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

