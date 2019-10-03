Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 843D0CB125
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 23:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733112AbfJCV32 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 17:29:28 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:64454 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732972AbfJCV30 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 17:29:26 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x93LSMel026756
        for <netdev@vger.kernel.org>; Thu, 3 Oct 2019 14:29:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=L5ifMEPTwBGZ88j1mHtlZ5+iXMHwx4IouNTgBNVag/8=;
 b=F6k5iyCEyS0vvgIzzCU0ujsbVLWCFGwJiOfOImuvfGUkJMrwxi4Nqe/ThKD4WD3sR6gv
 6h0f62DbxlLNm/muCuHoSgCN+ZuhNUy8mjZNHqDkp4sUAWlgHrq8hazVRhN7iziao0zE
 IEjTyG+tIn2pOcqumaNw96QJ5cBdU6+KlF0= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vdm68sfej-15
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 14:29:24 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Thu, 3 Oct 2019 14:29:08 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 072028618DE; Thu,  3 Oct 2019 14:29:05 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v3 bpf-next 4/7] selftests/bpf: split off tracing-only helpers into bpf_tracing.h
Date:   Thu, 3 Oct 2019 14:28:53 -0700
Message-ID: <20191003212856.1222735-5-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191003212856.1222735-1-andriin@fb.com>
References: <20191003212856.1222735-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-03_08:2019-10-03,2019-10-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=953
 adultscore=0 mlxscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 priorityscore=1501 bulkscore=0 impostorscore=0 suspectscore=8
 malwarescore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1908290000 definitions=main-1910030172
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Split-off PT_REGS-related helpers into bpf_tracing.h header. Adjust
selftests and samples to include it where necessary.

Acked-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 samples/bpf/map_perf_test_kern.c          |   1 +
 samples/bpf/offwaketime_kern.c            |   1 +
 samples/bpf/sampleip_kern.c               |   1 +
 samples/bpf/spintest_kern.c               |   1 +
 samples/bpf/test_map_in_map_kern.c        |   1 +
 samples/bpf/test_overhead_kprobe_kern.c   |   1 +
 samples/bpf/test_probe_write_user_kern.c  |   1 +
 samples/bpf/trace_event_kern.c            |   1 +
 samples/bpf/tracex1_kern.c                |   1 +
 samples/bpf/tracex2_kern.c                |   1 +
 samples/bpf/tracex3_kern.c                |   1 +
 samples/bpf/tracex4_kern.c                |   1 +
 samples/bpf/tracex5_kern.c                |   1 +
 tools/testing/selftests/bpf/bpf_helpers.h | 210 ++--------------------
 tools/testing/selftests/bpf/bpf_tracing.h | 195 ++++++++++++++++++++
 tools/testing/selftests/bpf/progs/loop1.c |   1 +
 tools/testing/selftests/bpf/progs/loop2.c |   1 +
 tools/testing/selftests/bpf/progs/loop3.c |   1 +
 18 files changed, 221 insertions(+), 200 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/bpf_tracing.h

diff --git a/samples/bpf/map_perf_test_kern.c b/samples/bpf/map_perf_test_kern.c
index f47ee513cb7c..5c11aefbc489 100644
--- a/samples/bpf/map_perf_test_kern.c
+++ b/samples/bpf/map_perf_test_kern.c
@@ -10,6 +10,7 @@
 #include <uapi/linux/bpf.h>
 #include "bpf_helpers.h"
 #include "bpf_legacy.h"
+#include "bpf_tracing.h"
 
 #define MAX_ENTRIES 1000
 #define MAX_NR_CPUS 1024
diff --git a/samples/bpf/offwaketime_kern.c b/samples/bpf/offwaketime_kern.c
index e7d9a0a3d45b..9cb5207a692f 100644
--- a/samples/bpf/offwaketime_kern.c
+++ b/samples/bpf/offwaketime_kern.c
@@ -6,6 +6,7 @@
  */
 #include <uapi/linux/bpf.h>
 #include "bpf_helpers.h"
+#include "bpf_tracing.h"
 #include <uapi/linux/ptrace.h>
 #include <uapi/linux/perf_event.h>
 #include <linux/version.h>
diff --git a/samples/bpf/sampleip_kern.c b/samples/bpf/sampleip_kern.c
index ceabf31079cf..4a190893894f 100644
--- a/samples/bpf/sampleip_kern.c
+++ b/samples/bpf/sampleip_kern.c
@@ -9,6 +9,7 @@
 #include <uapi/linux/bpf.h>
 #include <uapi/linux/bpf_perf_event.h>
 #include "bpf_helpers.h"
+#include "bpf_tracing.h"
 
 #define MAX_IPS		8192
 
diff --git a/samples/bpf/spintest_kern.c b/samples/bpf/spintest_kern.c
index ce0167d09cdc..6e9478aa2938 100644
--- a/samples/bpf/spintest_kern.c
+++ b/samples/bpf/spintest_kern.c
@@ -10,6 +10,7 @@
 #include <uapi/linux/bpf.h>
 #include <uapi/linux/perf_event.h>
 #include "bpf_helpers.h"
+#include "bpf_tracing.h"
 
 struct bpf_map_def SEC("maps") my_map = {
 	.type = BPF_MAP_TYPE_HASH,
diff --git a/samples/bpf/test_map_in_map_kern.c b/samples/bpf/test_map_in_map_kern.c
index 8101bf3dc7f7..4f80cbe74c72 100644
--- a/samples/bpf/test_map_in_map_kern.c
+++ b/samples/bpf/test_map_in_map_kern.c
@@ -12,6 +12,7 @@
 #include <uapi/linux/in6.h>
 #include "bpf_helpers.h"
 #include "bpf_legacy.h"
+#include "bpf_tracing.h"
 
 #define MAX_NR_PORTS 65536
 
diff --git a/samples/bpf/test_overhead_kprobe_kern.c b/samples/bpf/test_overhead_kprobe_kern.c
index 468a66a92ef9..8d2518e68db9 100644
--- a/samples/bpf/test_overhead_kprobe_kern.c
+++ b/samples/bpf/test_overhead_kprobe_kern.c
@@ -8,6 +8,7 @@
 #include <linux/ptrace.h>
 #include <uapi/linux/bpf.h>
 #include "bpf_helpers.h"
+#include "bpf_tracing.h"
 
 #define _(P) ({typeof(P) val = 0; bpf_probe_read(&val, sizeof(val), &P); val;})
 
diff --git a/samples/bpf/test_probe_write_user_kern.c b/samples/bpf/test_probe_write_user_kern.c
index 3a677c807044..a543358218e6 100644
--- a/samples/bpf/test_probe_write_user_kern.c
+++ b/samples/bpf/test_probe_write_user_kern.c
@@ -9,6 +9,7 @@
 #include <uapi/linux/bpf.h>
 #include <linux/version.h>
 #include "bpf_helpers.h"
+#include "bpf_tracing.h"
 
 struct bpf_map_def SEC("maps") dnat_map = {
 	.type = BPF_MAP_TYPE_HASH,
diff --git a/samples/bpf/trace_event_kern.c b/samples/bpf/trace_event_kern.c
index 7068fbdde951..8dc18d233a27 100644
--- a/samples/bpf/trace_event_kern.c
+++ b/samples/bpf/trace_event_kern.c
@@ -10,6 +10,7 @@
 #include <uapi/linux/bpf_perf_event.h>
 #include <uapi/linux/perf_event.h>
 #include "bpf_helpers.h"
+#include "bpf_tracing.h"
 
 struct key_t {
 	char comm[TASK_COMM_LEN];
diff --git a/samples/bpf/tracex1_kern.c b/samples/bpf/tracex1_kern.c
index 107da148820f..1a15f6605129 100644
--- a/samples/bpf/tracex1_kern.c
+++ b/samples/bpf/tracex1_kern.c
@@ -9,6 +9,7 @@
 #include <uapi/linux/bpf.h>
 #include <linux/version.h>
 #include "bpf_helpers.h"
+#include "bpf_tracing.h"
 
 #define _(P) ({typeof(P) val = 0; bpf_probe_read(&val, sizeof(val), &P); val;})
 
diff --git a/samples/bpf/tracex2_kern.c b/samples/bpf/tracex2_kern.c
index 5e11c20ce5ec..d70b3ea79ea7 100644
--- a/samples/bpf/tracex2_kern.c
+++ b/samples/bpf/tracex2_kern.c
@@ -9,6 +9,7 @@
 #include <linux/version.h>
 #include <uapi/linux/bpf.h>
 #include "bpf_helpers.h"
+#include "bpf_tracing.h"
 
 struct bpf_map_def SEC("maps") my_map = {
 	.type = BPF_MAP_TYPE_HASH,
diff --git a/samples/bpf/tracex3_kern.c b/samples/bpf/tracex3_kern.c
index ea1d4c19c132..9af546bebfa9 100644
--- a/samples/bpf/tracex3_kern.c
+++ b/samples/bpf/tracex3_kern.c
@@ -9,6 +9,7 @@
 #include <linux/version.h>
 #include <uapi/linux/bpf.h>
 #include "bpf_helpers.h"
+#include "bpf_tracing.h"
 
 struct bpf_map_def SEC("maps") my_map = {
 	.type = BPF_MAP_TYPE_HASH,
diff --git a/samples/bpf/tracex4_kern.c b/samples/bpf/tracex4_kern.c
index 6dd8e384de96..2a02cbe9d9a1 100644
--- a/samples/bpf/tracex4_kern.c
+++ b/samples/bpf/tracex4_kern.c
@@ -8,6 +8,7 @@
 #include <linux/version.h>
 #include <uapi/linux/bpf.h>
 #include "bpf_helpers.h"
+#include "bpf_tracing.h"
 
 struct pair {
 	u64 val;
diff --git a/samples/bpf/tracex5_kern.c b/samples/bpf/tracex5_kern.c
index 35cb0eed3be5..b3557b21a8fe 100644
--- a/samples/bpf/tracex5_kern.c
+++ b/samples/bpf/tracex5_kern.c
@@ -11,6 +11,7 @@
 #include <uapi/linux/unistd.h>
 #include "syscall_nrs.h"
 #include "bpf_helpers.h"
+#include "bpf_tracing.h"
 
 #define PROG(F) SEC("kprobe/"__stringify(F)) int bpf_func_##F
 
diff --git a/tools/testing/selftests/bpf/bpf_helpers.h b/tools/testing/selftests/bpf/bpf_helpers.h
index 5210cc7d7c5c..cb9d4d2224af 100644
--- a/tools/testing/selftests/bpf/bpf_helpers.h
+++ b/tools/testing/selftests/bpf/bpf_helpers.h
@@ -232,17 +232,6 @@ static long long (*bpf_tcp_gen_syncookie)(struct bpf_sock *sk, void *ip,
 					  int ip_len, void *tcp, int tcp_len) =
 	(void *) BPF_FUNC_tcp_gen_syncookie;
 
-/* a helper structure used by eBPF C program
- * to describe BPF map attributes to libbpf loader
- */
-struct bpf_map_def {
-	unsigned int type;
-	unsigned int key_size;
-	unsigned int value_size;
-	unsigned int max_entries;
-	unsigned int map_flags;
-};
-
 static int (*bpf_skb_load_bytes)(void *ctx, int off, void *to, int len) =
 	(void *) BPF_FUNC_skb_load_bytes;
 static int (*bpf_skb_load_bytes_relative)(void *ctx, int off, void *to, int len, __u32 start_header) =
@@ -292,195 +281,16 @@ static int (*bpf_skb_adjust_room)(void *ctx, __s32 len_diff, __u32 mode,
 				  unsigned long long flags) =
 	(void *) BPF_FUNC_skb_adjust_room;
 
-/* Scan the ARCH passed in from ARCH env variable (see Makefile) */
-#if defined(__TARGET_ARCH_x86)
-	#define bpf_target_x86
-	#define bpf_target_defined
-#elif defined(__TARGET_ARCH_s390)
-	#define bpf_target_s390
-	#define bpf_target_defined
-#elif defined(__TARGET_ARCH_arm)
-	#define bpf_target_arm
-	#define bpf_target_defined
-#elif defined(__TARGET_ARCH_arm64)
-	#define bpf_target_arm64
-	#define bpf_target_defined
-#elif defined(__TARGET_ARCH_mips)
-	#define bpf_target_mips
-	#define bpf_target_defined
-#elif defined(__TARGET_ARCH_powerpc)
-	#define bpf_target_powerpc
-	#define bpf_target_defined
-#elif defined(__TARGET_ARCH_sparc)
-	#define bpf_target_sparc
-	#define bpf_target_defined
-#else
-	#undef bpf_target_defined
-#endif
-
-/* Fall back to what the compiler says */
-#ifndef bpf_target_defined
-#if defined(__x86_64__)
-	#define bpf_target_x86
-#elif defined(__s390__)
-	#define bpf_target_s390
-#elif defined(__arm__)
-	#define bpf_target_arm
-#elif defined(__aarch64__)
-	#define bpf_target_arm64
-#elif defined(__mips__)
-	#define bpf_target_mips
-#elif defined(__powerpc__)
-	#define bpf_target_powerpc
-#elif defined(__sparc__)
-	#define bpf_target_sparc
-#endif
-#endif
-
-#if defined(bpf_target_x86)
-
-#ifdef __KERNEL__
-#define PT_REGS_PARM1(x) ((x)->di)
-#define PT_REGS_PARM2(x) ((x)->si)
-#define PT_REGS_PARM3(x) ((x)->dx)
-#define PT_REGS_PARM4(x) ((x)->cx)
-#define PT_REGS_PARM5(x) ((x)->r8)
-#define PT_REGS_RET(x) ((x)->sp)
-#define PT_REGS_FP(x) ((x)->bp)
-#define PT_REGS_RC(x) ((x)->ax)
-#define PT_REGS_SP(x) ((x)->sp)
-#define PT_REGS_IP(x) ((x)->ip)
-#else
-#ifdef __i386__
-/* i386 kernel is built with -mregparm=3 */
-#define PT_REGS_PARM1(x) ((x)->eax)
-#define PT_REGS_PARM2(x) ((x)->edx)
-#define PT_REGS_PARM3(x) ((x)->ecx)
-#define PT_REGS_PARM4(x) 0
-#define PT_REGS_PARM5(x) 0
-#define PT_REGS_RET(x) ((x)->esp)
-#define PT_REGS_FP(x) ((x)->ebp)
-#define PT_REGS_RC(x) ((x)->eax)
-#define PT_REGS_SP(x) ((x)->esp)
-#define PT_REGS_IP(x) ((x)->eip)
-#else
-#define PT_REGS_PARM1(x) ((x)->rdi)
-#define PT_REGS_PARM2(x) ((x)->rsi)
-#define PT_REGS_PARM3(x) ((x)->rdx)
-#define PT_REGS_PARM4(x) ((x)->rcx)
-#define PT_REGS_PARM5(x) ((x)->r8)
-#define PT_REGS_RET(x) ((x)->rsp)
-#define PT_REGS_FP(x) ((x)->rbp)
-#define PT_REGS_RC(x) ((x)->rax)
-#define PT_REGS_SP(x) ((x)->rsp)
-#define PT_REGS_IP(x) ((x)->rip)
-#endif
-#endif
-
-#elif defined(bpf_target_s390)
-
-/* s390 provides user_pt_regs instead of struct pt_regs to userspace */
-struct pt_regs;
-#define PT_REGS_S390 const volatile user_pt_regs
-#define PT_REGS_PARM1(x) (((PT_REGS_S390 *)(x))->gprs[2])
-#define PT_REGS_PARM2(x) (((PT_REGS_S390 *)(x))->gprs[3])
-#define PT_REGS_PARM3(x) (((PT_REGS_S390 *)(x))->gprs[4])
-#define PT_REGS_PARM4(x) (((PT_REGS_S390 *)(x))->gprs[5])
-#define PT_REGS_PARM5(x) (((PT_REGS_S390 *)(x))->gprs[6])
-#define PT_REGS_RET(x) (((PT_REGS_S390 *)(x))->gprs[14])
-/* Works only with CONFIG_FRAME_POINTER */
-#define PT_REGS_FP(x) (((PT_REGS_S390 *)(x))->gprs[11])
-#define PT_REGS_RC(x) (((PT_REGS_S390 *)(x))->gprs[2])
-#define PT_REGS_SP(x) (((PT_REGS_S390 *)(x))->gprs[15])
-#define PT_REGS_IP(x) (((PT_REGS_S390 *)(x))->psw.addr)
-
-#elif defined(bpf_target_arm)
-
-#define PT_REGS_PARM1(x) ((x)->uregs[0])
-#define PT_REGS_PARM2(x) ((x)->uregs[1])
-#define PT_REGS_PARM3(x) ((x)->uregs[2])
-#define PT_REGS_PARM4(x) ((x)->uregs[3])
-#define PT_REGS_PARM5(x) ((x)->uregs[4])
-#define PT_REGS_RET(x) ((x)->uregs[14])
-#define PT_REGS_FP(x) ((x)->uregs[11]) /* Works only with CONFIG_FRAME_POINTER */
-#define PT_REGS_RC(x) ((x)->uregs[0])
-#define PT_REGS_SP(x) ((x)->uregs[13])
-#define PT_REGS_IP(x) ((x)->uregs[12])
-
-#elif defined(bpf_target_arm64)
-
-/* arm64 provides struct user_pt_regs instead of struct pt_regs to userspace */
-struct pt_regs;
-#define PT_REGS_ARM64 const volatile struct user_pt_regs
-#define PT_REGS_PARM1(x) (((PT_REGS_ARM64 *)(x))->regs[0])
-#define PT_REGS_PARM2(x) (((PT_REGS_ARM64 *)(x))->regs[1])
-#define PT_REGS_PARM3(x) (((PT_REGS_ARM64 *)(x))->regs[2])
-#define PT_REGS_PARM4(x) (((PT_REGS_ARM64 *)(x))->regs[3])
-#define PT_REGS_PARM5(x) (((PT_REGS_ARM64 *)(x))->regs[4])
-#define PT_REGS_RET(x) (((PT_REGS_ARM64 *)(x))->regs[30])
-/* Works only with CONFIG_FRAME_POINTER */
-#define PT_REGS_FP(x) (((PT_REGS_ARM64 *)(x))->regs[29])
-#define PT_REGS_RC(x) (((PT_REGS_ARM64 *)(x))->regs[0])
-#define PT_REGS_SP(x) (((PT_REGS_ARM64 *)(x))->sp)
-#define PT_REGS_IP(x) (((PT_REGS_ARM64 *)(x))->pc)
-
-#elif defined(bpf_target_mips)
-
-#define PT_REGS_PARM1(x) ((x)->regs[4])
-#define PT_REGS_PARM2(x) ((x)->regs[5])
-#define PT_REGS_PARM3(x) ((x)->regs[6])
-#define PT_REGS_PARM4(x) ((x)->regs[7])
-#define PT_REGS_PARM5(x) ((x)->regs[8])
-#define PT_REGS_RET(x) ((x)->regs[31])
-#define PT_REGS_FP(x) ((x)->regs[30]) /* Works only with CONFIG_FRAME_POINTER */
-#define PT_REGS_RC(x) ((x)->regs[1])
-#define PT_REGS_SP(x) ((x)->regs[29])
-#define PT_REGS_IP(x) ((x)->cp0_epc)
-
-#elif defined(bpf_target_powerpc)
-
-#define PT_REGS_PARM1(x) ((x)->gpr[3])
-#define PT_REGS_PARM2(x) ((x)->gpr[4])
-#define PT_REGS_PARM3(x) ((x)->gpr[5])
-#define PT_REGS_PARM4(x) ((x)->gpr[6])
-#define PT_REGS_PARM5(x) ((x)->gpr[7])
-#define PT_REGS_RC(x) ((x)->gpr[3])
-#define PT_REGS_SP(x) ((x)->sp)
-#define PT_REGS_IP(x) ((x)->nip)
-
-#elif defined(bpf_target_sparc)
-
-#define PT_REGS_PARM1(x) ((x)->u_regs[UREG_I0])
-#define PT_REGS_PARM2(x) ((x)->u_regs[UREG_I1])
-#define PT_REGS_PARM3(x) ((x)->u_regs[UREG_I2])
-#define PT_REGS_PARM4(x) ((x)->u_regs[UREG_I3])
-#define PT_REGS_PARM5(x) ((x)->u_regs[UREG_I4])
-#define PT_REGS_RET(x) ((x)->u_regs[UREG_I7])
-#define PT_REGS_RC(x) ((x)->u_regs[UREG_I0])
-#define PT_REGS_SP(x) ((x)->u_regs[UREG_FP])
-
-/* Should this also be a bpf_target check for the sparc case? */
-#if defined(__arch64__)
-#define PT_REGS_IP(x) ((x)->tpc)
-#else
-#define PT_REGS_IP(x) ((x)->pc)
-#endif
-
-#endif
-
-#if defined(bpf_target_powerpc)
-#define BPF_KPROBE_READ_RET_IP(ip, ctx)		({ (ip) = (ctx)->link; })
-#define BPF_KRETPROBE_READ_RET_IP		BPF_KPROBE_READ_RET_IP
-#elif defined(bpf_target_sparc)
-#define BPF_KPROBE_READ_RET_IP(ip, ctx)		({ (ip) = PT_REGS_RET(ctx); })
-#define BPF_KRETPROBE_READ_RET_IP		BPF_KPROBE_READ_RET_IP
-#else
-#define BPF_KPROBE_READ_RET_IP(ip, ctx)		({				\
-		bpf_probe_read(&(ip), sizeof(ip), (void *)PT_REGS_RET(ctx)); })
-#define BPF_KRETPROBE_READ_RET_IP(ip, ctx)	({				\
-		bpf_probe_read(&(ip), sizeof(ip),				\
-				(void *)(PT_REGS_FP(ctx) + sizeof(ip))); })
-#endif
+/* a helper structure used by eBPF C program
+ * to describe BPF map attributes to libbpf loader
+ */
+struct bpf_map_def {
+	unsigned int type;
+	unsigned int key_size;
+	unsigned int value_size;
+	unsigned int max_entries;
+	unsigned int map_flags;
+};
 
 /*
  * bpf_core_read() abstracts away bpf_probe_read() call and captures offset
diff --git a/tools/testing/selftests/bpf/bpf_tracing.h b/tools/testing/selftests/bpf/bpf_tracing.h
new file mode 100644
index 000000000000..b0dafe8b4ebc
--- /dev/null
+++ b/tools/testing/selftests/bpf/bpf_tracing.h
@@ -0,0 +1,195 @@
+/* SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause) */
+#ifndef __BPF_TRACING_H__
+#define __BPF_TRACING_H__
+
+/* Scan the ARCH passed in from ARCH env variable (see Makefile) */
+#if defined(__TARGET_ARCH_x86)
+	#define bpf_target_x86
+	#define bpf_target_defined
+#elif defined(__TARGET_ARCH_s390)
+	#define bpf_target_s390
+	#define bpf_target_defined
+#elif defined(__TARGET_ARCH_arm)
+	#define bpf_target_arm
+	#define bpf_target_defined
+#elif defined(__TARGET_ARCH_arm64)
+	#define bpf_target_arm64
+	#define bpf_target_defined
+#elif defined(__TARGET_ARCH_mips)
+	#define bpf_target_mips
+	#define bpf_target_defined
+#elif defined(__TARGET_ARCH_powerpc)
+	#define bpf_target_powerpc
+	#define bpf_target_defined
+#elif defined(__TARGET_ARCH_sparc)
+	#define bpf_target_sparc
+	#define bpf_target_defined
+#else
+	#undef bpf_target_defined
+#endif
+
+/* Fall back to what the compiler says */
+#ifndef bpf_target_defined
+#if defined(__x86_64__)
+	#define bpf_target_x86
+#elif defined(__s390__)
+	#define bpf_target_s390
+#elif defined(__arm__)
+	#define bpf_target_arm
+#elif defined(__aarch64__)
+	#define bpf_target_arm64
+#elif defined(__mips__)
+	#define bpf_target_mips
+#elif defined(__powerpc__)
+	#define bpf_target_powerpc
+#elif defined(__sparc__)
+	#define bpf_target_sparc
+#endif
+#endif
+
+#if defined(bpf_target_x86)
+
+#ifdef __KERNEL__
+#define PT_REGS_PARM1(x) ((x)->di)
+#define PT_REGS_PARM2(x) ((x)->si)
+#define PT_REGS_PARM3(x) ((x)->dx)
+#define PT_REGS_PARM4(x) ((x)->cx)
+#define PT_REGS_PARM5(x) ((x)->r8)
+#define PT_REGS_RET(x) ((x)->sp)
+#define PT_REGS_FP(x) ((x)->bp)
+#define PT_REGS_RC(x) ((x)->ax)
+#define PT_REGS_SP(x) ((x)->sp)
+#define PT_REGS_IP(x) ((x)->ip)
+#else
+#ifdef __i386__
+/* i386 kernel is built with -mregparm=3 */
+#define PT_REGS_PARM1(x) ((x)->eax)
+#define PT_REGS_PARM2(x) ((x)->edx)
+#define PT_REGS_PARM3(x) ((x)->ecx)
+#define PT_REGS_PARM4(x) 0
+#define PT_REGS_PARM5(x) 0
+#define PT_REGS_RET(x) ((x)->esp)
+#define PT_REGS_FP(x) ((x)->ebp)
+#define PT_REGS_RC(x) ((x)->eax)
+#define PT_REGS_SP(x) ((x)->esp)
+#define PT_REGS_IP(x) ((x)->eip)
+#else
+#define PT_REGS_PARM1(x) ((x)->rdi)
+#define PT_REGS_PARM2(x) ((x)->rsi)
+#define PT_REGS_PARM3(x) ((x)->rdx)
+#define PT_REGS_PARM4(x) ((x)->rcx)
+#define PT_REGS_PARM5(x) ((x)->r8)
+#define PT_REGS_RET(x) ((x)->rsp)
+#define PT_REGS_FP(x) ((x)->rbp)
+#define PT_REGS_RC(x) ((x)->rax)
+#define PT_REGS_SP(x) ((x)->rsp)
+#define PT_REGS_IP(x) ((x)->rip)
+#endif
+#endif
+
+#elif defined(bpf_target_s390)
+
+/* s390 provides user_pt_regs instead of struct pt_regs to userspace */
+struct pt_regs;
+#define PT_REGS_S390 const volatile user_pt_regs
+#define PT_REGS_PARM1(x) (((PT_REGS_S390 *)(x))->gprs[2])
+#define PT_REGS_PARM2(x) (((PT_REGS_S390 *)(x))->gprs[3])
+#define PT_REGS_PARM3(x) (((PT_REGS_S390 *)(x))->gprs[4])
+#define PT_REGS_PARM4(x) (((PT_REGS_S390 *)(x))->gprs[5])
+#define PT_REGS_PARM5(x) (((PT_REGS_S390 *)(x))->gprs[6])
+#define PT_REGS_RET(x) (((PT_REGS_S390 *)(x))->gprs[14])
+/* Works only with CONFIG_FRAME_POINTER */
+#define PT_REGS_FP(x) (((PT_REGS_S390 *)(x))->gprs[11])
+#define PT_REGS_RC(x) (((PT_REGS_S390 *)(x))->gprs[2])
+#define PT_REGS_SP(x) (((PT_REGS_S390 *)(x))->gprs[15])
+#define PT_REGS_IP(x) (((PT_REGS_S390 *)(x))->psw.addr)
+
+#elif defined(bpf_target_arm)
+
+#define PT_REGS_PARM1(x) ((x)->uregs[0])
+#define PT_REGS_PARM2(x) ((x)->uregs[1])
+#define PT_REGS_PARM3(x) ((x)->uregs[2])
+#define PT_REGS_PARM4(x) ((x)->uregs[3])
+#define PT_REGS_PARM5(x) ((x)->uregs[4])
+#define PT_REGS_RET(x) ((x)->uregs[14])
+#define PT_REGS_FP(x) ((x)->uregs[11]) /* Works only with CONFIG_FRAME_POINTER */
+#define PT_REGS_RC(x) ((x)->uregs[0])
+#define PT_REGS_SP(x) ((x)->uregs[13])
+#define PT_REGS_IP(x) ((x)->uregs[12])
+
+#elif defined(bpf_target_arm64)
+
+/* arm64 provides struct user_pt_regs instead of struct pt_regs to userspace */
+struct pt_regs;
+#define PT_REGS_ARM64 const volatile struct user_pt_regs
+#define PT_REGS_PARM1(x) (((PT_REGS_ARM64 *)(x))->regs[0])
+#define PT_REGS_PARM2(x) (((PT_REGS_ARM64 *)(x))->regs[1])
+#define PT_REGS_PARM3(x) (((PT_REGS_ARM64 *)(x))->regs[2])
+#define PT_REGS_PARM4(x) (((PT_REGS_ARM64 *)(x))->regs[3])
+#define PT_REGS_PARM5(x) (((PT_REGS_ARM64 *)(x))->regs[4])
+#define PT_REGS_RET(x) (((PT_REGS_ARM64 *)(x))->regs[30])
+/* Works only with CONFIG_FRAME_POINTER */
+#define PT_REGS_FP(x) (((PT_REGS_ARM64 *)(x))->regs[29])
+#define PT_REGS_RC(x) (((PT_REGS_ARM64 *)(x))->regs[0])
+#define PT_REGS_SP(x) (((PT_REGS_ARM64 *)(x))->sp)
+#define PT_REGS_IP(x) (((PT_REGS_ARM64 *)(x))->pc)
+
+#elif defined(bpf_target_mips)
+
+#define PT_REGS_PARM1(x) ((x)->regs[4])
+#define PT_REGS_PARM2(x) ((x)->regs[5])
+#define PT_REGS_PARM3(x) ((x)->regs[6])
+#define PT_REGS_PARM4(x) ((x)->regs[7])
+#define PT_REGS_PARM5(x) ((x)->regs[8])
+#define PT_REGS_RET(x) ((x)->regs[31])
+#define PT_REGS_FP(x) ((x)->regs[30]) /* Works only with CONFIG_FRAME_POINTER */
+#define PT_REGS_RC(x) ((x)->regs[1])
+#define PT_REGS_SP(x) ((x)->regs[29])
+#define PT_REGS_IP(x) ((x)->cp0_epc)
+
+#elif defined(bpf_target_powerpc)
+
+#define PT_REGS_PARM1(x) ((x)->gpr[3])
+#define PT_REGS_PARM2(x) ((x)->gpr[4])
+#define PT_REGS_PARM3(x) ((x)->gpr[5])
+#define PT_REGS_PARM4(x) ((x)->gpr[6])
+#define PT_REGS_PARM5(x) ((x)->gpr[7])
+#define PT_REGS_RC(x) ((x)->gpr[3])
+#define PT_REGS_SP(x) ((x)->sp)
+#define PT_REGS_IP(x) ((x)->nip)
+
+#elif defined(bpf_target_sparc)
+
+#define PT_REGS_PARM1(x) ((x)->u_regs[UREG_I0])
+#define PT_REGS_PARM2(x) ((x)->u_regs[UREG_I1])
+#define PT_REGS_PARM3(x) ((x)->u_regs[UREG_I2])
+#define PT_REGS_PARM4(x) ((x)->u_regs[UREG_I3])
+#define PT_REGS_PARM5(x) ((x)->u_regs[UREG_I4])
+#define PT_REGS_RET(x) ((x)->u_regs[UREG_I7])
+#define PT_REGS_RC(x) ((x)->u_regs[UREG_I0])
+#define PT_REGS_SP(x) ((x)->u_regs[UREG_FP])
+
+/* Should this also be a bpf_target check for the sparc case? */
+#if defined(__arch64__)
+#define PT_REGS_IP(x) ((x)->tpc)
+#else
+#define PT_REGS_IP(x) ((x)->pc)
+#endif
+
+#endif
+
+#if defined(bpf_target_powerpc)
+#define BPF_KPROBE_READ_RET_IP(ip, ctx)		({ (ip) = (ctx)->link; })
+#define BPF_KRETPROBE_READ_RET_IP		BPF_KPROBE_READ_RET_IP
+#elif defined(bpf_target_sparc)
+#define BPF_KPROBE_READ_RET_IP(ip, ctx)		({ (ip) = PT_REGS_RET(ctx); })
+#define BPF_KRETPROBE_READ_RET_IP		BPF_KPROBE_READ_RET_IP
+#else
+#define BPF_KPROBE_READ_RET_IP(ip, ctx)					    \
+	({ bpf_probe_read(&(ip), sizeof(ip), (void *)PT_REGS_RET(ctx)); })
+#define BPF_KRETPROBE_READ_RET_IP(ip, ctx)				    \
+	({ bpf_probe_read(&(ip), sizeof(ip),				    \
+			  (void *)(PT_REGS_FP(ctx) + sizeof(ip))); })
+#endif
+
+#endif
diff --git a/tools/testing/selftests/bpf/progs/loop1.c b/tools/testing/selftests/bpf/progs/loop1.c
index 7cdb7f878310..40ac722a9da5 100644
--- a/tools/testing/selftests/bpf/progs/loop1.c
+++ b/tools/testing/selftests/bpf/progs/loop1.c
@@ -7,6 +7,7 @@
 #include <stdbool.h>
 #include <linux/bpf.h>
 #include "bpf_helpers.h"
+#include "bpf_tracing.h"
 
 char _license[] SEC("license") = "GPL";
 
diff --git a/tools/testing/selftests/bpf/progs/loop2.c b/tools/testing/selftests/bpf/progs/loop2.c
index 9b2f808a2863..bb80f29aa7f7 100644
--- a/tools/testing/selftests/bpf/progs/loop2.c
+++ b/tools/testing/selftests/bpf/progs/loop2.c
@@ -7,6 +7,7 @@
 #include <stdbool.h>
 #include <linux/bpf.h>
 #include "bpf_helpers.h"
+#include "bpf_tracing.h"
 
 char _license[] SEC("license") = "GPL";
 
diff --git a/tools/testing/selftests/bpf/progs/loop3.c b/tools/testing/selftests/bpf/progs/loop3.c
index d727657d51e2..2b9165a7afe1 100644
--- a/tools/testing/selftests/bpf/progs/loop3.c
+++ b/tools/testing/selftests/bpf/progs/loop3.c
@@ -7,6 +7,7 @@
 #include <stdbool.h>
 #include <linux/bpf.h>
 #include "bpf_helpers.h"
+#include "bpf_tracing.h"
 
 char _license[] SEC("license") = "GPL";
 
-- 
2.17.1

