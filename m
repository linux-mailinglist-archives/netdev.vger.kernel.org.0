Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EF9025922
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 22:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727341AbfEUUkd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 16:40:33 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:44290 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727934AbfEUUkc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 16:40:32 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4LKddcm007982;
        Tue, 21 May 2019 20:39:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id :
 mime-version : date : from : to : cc : subject : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=dzORKTmOW6eLHjg096khkaNbGvVxBaY3vJ+gNoYVdl4=;
 b=PTAaryZeJ71KMvEcxCmIS2rMEIlj9SkVmQhT4Bf1YqBWOKc9EVmuPVrerdS0aCSrEnKN
 7tSXX1tC79mKHJfEuRhHNk2S+kUogZ4TxwmUBsKxYkyLLzBDnmCHC4Umk4OExGr7snWP
 ZN4dZzSuqgMg9cwjPJUbffTEZf9H/Ix7vAfXzH3s/CZEt2gJb/yPJgLQdyrZgGXuRSXh
 1QBw8USmiQnzzED+YMBDdu6kToqdAZNyx6xEQlLqYK7NECYiBBrHid2c5hbd1jlWe/SC
 Png8Lvoersy42xjLGCL6p0pymyx61L6jX+r5VtOqFU5NFSLrv0+ytZG0bXsVJmrtFguK xg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2sjapqfvv3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 May 2019 20:39:43 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4LKc3oR147795;
        Tue, 21 May 2019 20:39:43 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 2sm0476hma-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 21 May 2019 20:39:42 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x4LKdgUi150812;
        Tue, 21 May 2019 20:39:42 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2sm0476hm5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 May 2019 20:39:42 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x4LKdgaT027769;
        Tue, 21 May 2019 20:39:42 GMT
Message-Id: <201905212039.x4LKdgaT027769@aserv0122.oracle.com>
Received: from localhost (/10.159.211.99) by default (Oracle Beehive Gateway
 v4.0) with ESMTP ; Tue, 21 May 2019 20:39:41 +0000
MIME-Version: 1.0
Date:   Tue, 21 May 2019 20:39:42 +0000 (UTC)
From:   Kris Van Hees <kris.van.hees@oracle.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        dtrace-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Cc:     rostedt@goodmis.org, mhiramat@kernel.org, acme@kernel.org,
        ast@kernel.org, daniel@iogearbox.net
Subject: [RFC PATCH 04/11] trace: initial implementation of DTrace based on
 kernel
In-Reply-To: <201905202347.x4KNl0cs030532@aserv0121.oracle.com> <facilities>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9264 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905210129
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds an implementation for BPF_PROG_TYPE_DTRACE, making use of
the tail-call mechanism feature to along tail-calls between programs of a
different BPF program type.  A new config option (DTRACE) is added to
control whether to include this new feature.

The DTRACE BPF program type provides an environment for executing probe
actions within the generalized trace context, independent from the type of
probe that triggered the program.  Probe types support specific BPF program
types, and this implementation uses the tail-call mechanism to call into
the DTRACE BPF program type from probe BPF prgroam types.  This initial
implementation provides support for the KPROBE type only - more will be
added in the near future.

The implementation provides:
 - dtrace_get_func_proto() as helper validator
 - dtrace_is_valid_access() as context access validator
 - dtrace_convert_ctx_access() as context access rewriter
 - dtrace_is_valid_tail_call() to validate the calling program type
 - dtrace_convert_ctx() to convert the context of the calling program into
   a DTRACE BPF program type context
 - dtrace_finalize_context() as bpf_finalize_context() helper for the
   DTRACE BPF program type

The dtrace_bpf_ctx struct defines the DTRACE BPF program type context at
the kernel level, and stores the following members:

	struct pt_reg *regs		- register state when probe fired
	u32 ecb_id			- probe enabling ID
	u32 probe_id			- probe ID
	struct task_struct *task	- executing task when probe fired

The regs and task members are populated from dtrace_convert_ctx() which is
called during the tail-call processing.  The ecb_id and probe_id are
populated from dtrace_finalize_context().

Sample use:

	#include <linux/dtrace.h>

	/*
	 * Map to store DTRACE BPF programs that can be called using
	 * the tail-call mechanism from other BPF program types.
	 */
	struct bpf_map_def SEC("maps") progs = {
		.type = BPF_MAP_TYPE_PROG_ARRAY,
		.key_size = sizeof(u32),
		.value_size = sizeof(u32),
		.max_entries = 8192,
	};

	/*
	 * Map to store DTrace probe specific information and share
	 * it across program boundaries.  This makes it possible for
	 * DTRACE BPF program to know what probe caused them to get
	 * called.
	 */
	struct bpf_map_def SEC("maps") probemap = {
		.type = BPF_MAP_TYPE_HASH,
		.key_size = sizeof(u32),
		.value_size = sizeof(struct dtrace_ecb),
		.max_entries = NR_CPUS,
	};

	SEC("dtrace/1") int dt_probe1(struct dtrace_bpf_context *ctx)
	{
		struct dtrace_ecb	*ecb;
                char			fmt[] = "EPID %d PROBE %d\n";

		bpf_finalize_context(ctx, &probemap);
                bpf_trace_printk(fmt, sizeof(fmt),
				 ctx->ecb_id, ctx->probe_id);

		return 0;
	}

	SEC("kprobe/sys_write") int bpf_prog1(struct pt_regs *ctx)
	{
		struct dtrace_ecb	ecb;
		int			cpu;

		cpu = bpf_get_smp_processor_id();
		ecb.id = 3;
		ecb.probe_id = 123;

		/* Store the ECB. */
		bpf_map_update_elem(&probemap, &cpu, &ecb, BPF_ANY);

		/* Issue tail-call into DTRACE BPF program. */
		bpf_tail_call(ctx, &progs, 1);

		/* fall through -> program not found or call failed */
		return 0;
	}

This patch also adds DTrace as a new subsystem in the MAINTAINERS file,
with me as current maintainer and our development mailing list for
specific development discussions.

Signed-off-by: Kris Van Hees <kris.van.hees@oracle.com>
Reviewed-by: Nick Alcock <nick.alcock@oracle.com>
---
 MAINTAINERS                  |   7 +
 include/uapi/linux/dtrace.h  |  50 ++++++
 kernel/trace/dtrace/Kconfig  |   7 +
 kernel/trace/dtrace/Makefile |   3 +
 kernel/trace/dtrace/bpf.c    | 321 +++++++++++++++++++++++++++++++++++
 5 files changed, 388 insertions(+)
 create mode 100644 include/uapi/linux/dtrace.h
 create mode 100644 kernel/trace/dtrace/Kconfig
 create mode 100644 kernel/trace/dtrace/Makefile
 create mode 100644 kernel/trace/dtrace/bpf.c

diff --git a/MAINTAINERS b/MAINTAINERS
index ce573aaa04df..07da7cc69f23 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5450,6 +5450,13 @@ W:	https://linuxtv.org
 S:	Odd Fixes
 F:	drivers/media/pci/dt3155/
 
+DTRACE
+M:	Kris Van Hees <kris.van.hees@oracle.com>
+L:	dtrace-devel@oss.oracle.com
+S:	Maintained
+F:	include/uapi/linux/dtrace.h
+F:	kernel/trace/dtrace
+
 DVB_USB_AF9015 MEDIA DRIVER
 M:	Antti Palosaari <crope@iki.fi>
 L:	linux-media@vger.kernel.org
diff --git a/include/uapi/linux/dtrace.h b/include/uapi/linux/dtrace.h
new file mode 100644
index 000000000000..bbe2562c11f2
--- /dev/null
+++ b/include/uapi/linux/dtrace.h
@@ -0,0 +1,50 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/*
+ * Copyright (c) 2019, Oracle and/or its affiliates. All rights reserved.
+ */
+#ifndef _UAPI_LINUX_DTRACE_H
+#define _UAPI_LINUX_DTRACE_H
+
+#include <linux/types.h>
+#include <linux/bpf.h>
+#include <asm/bpf_perf_event.h>
+
+/*
+ * Public definition of the BPF context for DTrace BPF programs.  It stores
+ * probe firing state, probe definition information, and current task state.
+ */
+struct dtrace_bpf_context {
+	/* CPU registers */
+	bpf_user_pt_regs_t regs;
+
+	/* Probe info */
+	u32 ecb_id;
+	u32 probe_id;
+
+	/* Current task info */
+	u64 task;	/* current */
+	u64 state;	/* current->state */
+	u32 prio;	/* current->prio */
+	u32 cpu;	/* current->cpu or current->thread_info->cpu */
+	u32 tid;	/* current->pid */
+	u32 pid;	/* current->tgid */
+	u32 ppid;	/* current->real_parent->tgid */
+	u32 uid;	/* from_kuid(&init_user_ns, current_real_cred()->uid */
+	u32 gid;	/* from_kgid(&init_user_ns, current_real_cred()->gid */
+	u32 euid;	/* from_kuid(&init_user_ns, current_real_cred()->euid */
+	u32 egid;	/* from_kgid(&init_user_ns, current_real_cred()->egid */
+};
+
+/*
+ * Struct to identify BPF programs attached to probes.  The BPF program should
+ * populate a dtrace_ecb struct with a unique ID and the ID by which the probe
+ * is known to DTrace.  The struct will be stored in a map by the BPF program
+ * attached to the probe, and it is retrieved by the DTrace BPF program that
+ * implements the actual probe actions.
+ */
+struct dtrace_ecb {
+	u32	id;
+	u32	probe_id;
+};
+
+#endif /* _UAPI_LINUX_DTRACE_H */
diff --git a/kernel/trace/dtrace/Kconfig b/kernel/trace/dtrace/Kconfig
new file mode 100644
index 000000000000..e94af706ae70
--- /dev/null
+++ b/kernel/trace/dtrace/Kconfig
@@ -0,0 +1,7 @@
+config DTRACE
+	bool "DTrace"
+	depends on BPF_EVENTS
+	help
+	  Enable DTrace support.  This version of DTrace is implemented using
+	  existing kernel facilities such as BPF and the perf event output
+	  buffer.
diff --git a/kernel/trace/dtrace/Makefile b/kernel/trace/dtrace/Makefile
new file mode 100644
index 000000000000..d04a8d7be577
--- /dev/null
+++ b/kernel/trace/dtrace/Makefile
@@ -0,0 +1,3 @@
+# SPDX-License-Identifier: GPL-2.0
+
+obj-y += bpf.o
diff --git a/kernel/trace/dtrace/bpf.c b/kernel/trace/dtrace/bpf.c
new file mode 100644
index 000000000000..95f4103d749e
--- /dev/null
+++ b/kernel/trace/dtrace/bpf.c
@@ -0,0 +1,321 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2019, Oracle and/or its affiliates. All rights reserved.
+ */
+#include <linux/bpf.h>
+#include <linux/dtrace.h>
+#include <linux/filter.h>
+#include <linux/ptrace.h>
+#include <linux/sched.h>
+
+/*
+ * Actual kernel definition of the DTrace BPF context.
+ */
+struct dtrace_bpf_ctx {
+	struct pt_regs			*regs;
+	u32				ecb_id;
+	u32				probe_id;
+	struct task_struct		*task;
+};
+
+/*
+ * Helper to complete the setup of the BPF context for DTrace BPF programs.  It
+ * is to be called at the very beginning of a BPF function that is getting
+ * tail-called from another BPF program type.
+ *
+ * The provided map should be a bpf_array that holds dtrace_ecb structs as
+ * elements and is should be indexed by CPU id.
+ */
+BPF_CALL_2(dtrace_finalize_context, struct dtrace_bpf_ctx *, ctx,
+	   struct bpf_map *, map)
+{
+	struct bpf_array	*arr = container_of(map, struct bpf_array, map);
+	struct dtrace_ecb	*ecb;
+	unsigned int		cpu = smp_processor_id();
+
+	/*
+	 * There is no way to ensure that we were called with the correct map.
+	 * Perform sanity checking on the map, and ensure that the index is
+	 * not out of range.
+	 * This won't guarantee that the content is meaningful, but at least we
+	 * can ensure that accessing the map is safe.
+	 * If the content is garbage, the resulting context will be garbage
+	 * also - but it won't be unsafe.
+	 */
+	if (unlikely(map->map_type != BPF_MAP_TYPE_ARRAY))
+		return -EINVAL;
+	if (unlikely(map->value_size != sizeof(*ecb)))
+		return -EINVAL;
+	if (unlikely(cpu >= map->max_entries))
+		return -E2BIG;
+
+	ecb = READ_ONCE(arr->ptrs[cpu]);
+	if (!ecb)
+		return -ENOENT;
+
+	ctx->ecb_id = ecb->id;
+	ctx->probe_id = ecb->probe_id;
+
+	return 0;
+}
+
+static const struct bpf_func_proto dtrace_finalize_context_proto = {
+	.func           = dtrace_finalize_context,
+	.gpl_only       = false,
+	.ret_type       = RET_INTEGER,
+	.arg1_type      = ARG_PTR_TO_CTX,		/* ctx */
+	.arg2_type      = ARG_CONST_MAP_PTR,		/* map */
+};
+
+static const struct bpf_func_proto *
+dtrace_get_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
+{
+	switch (func_id) {
+	case BPF_FUNC_finalize_context:
+		return &dtrace_finalize_context_proto;
+	case BPF_FUNC_perf_event_output:
+		return bpf_get_perf_event_output_proto();
+	case BPF_FUNC_trace_printk:
+		return bpf_get_trace_printk_proto();
+	case BPF_FUNC_get_smp_processor_id:
+		return &bpf_get_smp_processor_id_proto;
+	case BPF_FUNC_map_lookup_elem:
+		return &bpf_map_lookup_elem_proto;
+	case BPF_FUNC_map_update_elem:
+		return &bpf_map_update_elem_proto;
+	case BPF_FUNC_map_delete_elem:
+		return &bpf_map_delete_elem_proto;
+	default:
+		return NULL;
+	}
+}
+
+/*
+ * Verify access to context data members.
+ */
+static bool dtrace_is_valid_access(int off, int size, enum bpf_access_type type,
+				   const struct bpf_prog *prog,
+				   struct bpf_insn_access_aux *info)
+{
+	/* Ensure offset is within the context structure. */
+	if (off < 0 || off >= sizeof(struct dtrace_bpf_context))
+		return false;
+
+	/* Only READ access is allowed. */
+	if (type != BPF_READ)
+		return false;
+
+	/* Ensure offset is aligned (verifier guarantees size > 0). */
+	if (off % size != 0)
+		return false;
+
+	switch (off) {
+	case bpf_ctx_range(struct dtrace_bpf_context, task):
+	case bpf_ctx_range(struct dtrace_bpf_context, state):
+		bpf_ctx_record_field_size(info, sizeof(u64));
+		if (bpf_ctx_narrow_access_ok(off, size, sizeof(u64)))
+			return true;
+		break;
+	case bpf_ctx_range(struct dtrace_bpf_context, ecb_id):
+	case bpf_ctx_range(struct dtrace_bpf_context, probe_id):
+	case bpf_ctx_range(struct dtrace_bpf_context, prio):
+	case bpf_ctx_range(struct dtrace_bpf_context, cpu):
+	case bpf_ctx_range(struct dtrace_bpf_context, tid):
+	case bpf_ctx_range(struct dtrace_bpf_context, pid):
+	case bpf_ctx_range(struct dtrace_bpf_context, ppid):
+	case bpf_ctx_range(struct dtrace_bpf_context, uid):
+	case bpf_ctx_range(struct dtrace_bpf_context, gid):
+	case bpf_ctx_range(struct dtrace_bpf_context, euid):
+	case bpf_ctx_range(struct dtrace_bpf_context, egid):
+		bpf_ctx_record_field_size(info, sizeof(u32));
+		if (bpf_ctx_narrow_access_ok(off, size, sizeof(u32)))
+			return true;
+		break;
+	default:
+		if (size == sizeof(unsigned long))
+			return true;
+	}
+
+	return false;
+}
+
+/*
+ * A set of macros to make the access conversion code a little easier to read:
+ *
+ *  BPF_LDX_CTX_PTR(type, member, si)
+ *	si->dst_reg = ((type *)si->src_reg)->member	[member must be a ptr]
+ *
+ *  BPF_LDX_LNK_PTR(type, member, si)
+ *	si->dst_reg = ((type *)si->dst_reg)->member	[member must be a ptr]
+ *
+ *  BPF_LDX_CTX_FIELD(type, member, si, target_size)
+ *	si->dst_reg = ((type *)si->src_reg)->member
+ *	target_size = sizeof(((type *)si->src_reg)->member)
+ *
+ *  BPF_LDX_LNK_FIELD(type, member, si, target_size)
+ *	si->dst_reg = ((type *)si->dst_reg)->member
+ *	target_size = sizeof(((type *)si->dst_reg)->member)
+ *
+ * BPF_LDX_LNK_PTR must be preceded by BPF_LDX_CTX_PTR or BPF_LDX_LNK_PTR.
+ * BPF_LDX_LNK_FIELD must be preceded by BPF_LDX_CTX_PTR or BPF_LDX_LNK_PTR.
+ */
+#define BPF_LDX_CTX_PTR(type, member, si) \
+	BPF_LDX_MEM(BPF_FIELD_SIZEOF(type, member), \
+		    (si)->dst_reg, (si)->src_reg, offsetof(type, member))
+#define BPF_LDX_LNK_PTR(type, member, si) \
+	BPF_LDX_MEM(BPF_FIELD_SIZEOF(type, member), \
+		    (si)->dst_reg, (si)->dst_reg, offsetof(type, member))
+#define BPF_LDX_CTX_FIELD(type, member, si, target_size) \
+	BPF_LDX_MEM(BPF_FIELD_SIZEOF(type, member), \
+		    (si)->dst_reg, (si)->src_reg, \
+		    ({ \
+			*(target_size) = FIELD_SIZEOF(type, member); \
+			offsetof(type, member); \
+		    }))
+#define BPF_LDX_LNK_FIELD(type, member, si, target_size) \
+	BPF_LDX_MEM(BPF_FIELD_SIZEOF(type, member), \
+		    (si)->dst_reg, (si)->dst_reg, \
+		    ({ \
+			*(target_size) = FIELD_SIZEOF(type, member); \
+			offsetof(type, member); \
+		    }))
+
+/*
+ * Generate BPF instructions to retrieve the actual value for a member in the
+ * public BPF context, based on the kernel implementation of the context.
+ */
+static u32 dtrace_convert_ctx_access(enum bpf_access_type type,
+				     const struct bpf_insn *si,
+				     struct bpf_insn *insn_buf,
+				     struct bpf_prog *prog, u32 *target_size)
+{
+	struct bpf_insn *insn = insn_buf;
+
+	switch (si->off) {
+	case offsetof(struct dtrace_bpf_context, ecb_id):
+		*insn++ = BPF_LDX_CTX_FIELD(struct dtrace_bpf_ctx, ecb_id, si,
+					    target_size);
+		break;
+	case offsetof(struct dtrace_bpf_context, probe_id):
+		*insn++ = BPF_LDX_CTX_FIELD(struct dtrace_bpf_ctx, probe_id, si,
+					    target_size);
+		break;
+	case offsetof(struct dtrace_bpf_context, task):
+		*insn++ = BPF_LDX_CTX_FIELD(struct dtrace_bpf_ctx, task, si,
+					    target_size);
+		break;
+	case offsetof(struct dtrace_bpf_context, state):
+		*insn++ = BPF_LDX_CTX_PTR(struct dtrace_bpf_ctx, task, si);
+		*insn++ = BPF_LDX_LNK_FIELD(struct task_struct, state, si,
+					    target_size);
+		break;
+	case offsetof(struct dtrace_bpf_context, prio):
+		*insn++ = BPF_LDX_CTX_PTR(struct dtrace_bpf_ctx, task, si);
+		*insn++ = BPF_LDX_LNK_FIELD(struct task_struct, prio, si,
+					    target_size);
+		break;
+	case offsetof(struct dtrace_bpf_context, cpu):
+		*insn++ = BPF_LDX_CTX_PTR(struct dtrace_bpf_ctx, task, si);
+#ifdef CONFIG_THREAD_INFO_IN_TASK
+		*insn++ = BPF_LDX_LNK_FIELD(struct task_struct, cpu, si,
+					    target_size);
+#else
+		*insn++ = BPF_LDX_LNK_PTR(struct task_struct, stack, si);
+		*insn++ = BPF_LDX_LNK_FIELD(struct thread_info, cpu, si,
+					    target_size);
+#endif
+		break;
+	case offsetof(struct dtrace_bpf_context, tid):
+		*insn++ = BPF_LDX_CTX_PTR(struct dtrace_bpf_ctx, task, si);
+		*insn++ = BPF_LDX_LNK_FIELD(struct task_struct, pid, si,
+					    target_size);
+		break;
+	case offsetof(struct dtrace_bpf_context, pid):
+		*insn++ = BPF_LDX_CTX_PTR(struct dtrace_bpf_ctx, task, si);
+		*insn++ = BPF_LDX_LNK_FIELD(struct task_struct, tgid, si,
+					    target_size);
+		break;
+	case offsetof(struct dtrace_bpf_context, ppid):
+		*insn++ = BPF_LDX_CTX_PTR(struct dtrace_bpf_ctx, task, si);
+		*insn++ = BPF_LDX_LNK_PTR(struct task_struct, real_parent, si);
+		*insn++ = BPF_LDX_LNK_FIELD(struct task_struct, tgid, si,
+					    target_size);
+		break;
+	case offsetof(struct dtrace_bpf_context, uid):
+		*insn++ = BPF_LDX_CTX_PTR(struct dtrace_bpf_ctx, task, si);
+		*insn++ = BPF_LDX_LNK_PTR(struct task_struct, cred, si);
+		*insn++ = BPF_LDX_LNK_FIELD(struct cred, uid, si, target_size);
+		break;
+	case offsetof(struct dtrace_bpf_context, gid):
+		*insn++ = BPF_LDX_CTX_PTR(struct dtrace_bpf_ctx, task, si);
+		*insn++ = BPF_LDX_LNK_PTR(struct task_struct, cred, si);
+		*insn++ = BPF_LDX_LNK_FIELD(struct cred, gid, si, target_size);
+		break;
+	case offsetof(struct dtrace_bpf_context, euid):
+		*insn++ = BPF_LDX_CTX_PTR(struct dtrace_bpf_ctx, task, si);
+		*insn++ = BPF_LDX_LNK_PTR(struct task_struct, cred, si);
+		*insn++ = BPF_LDX_LNK_FIELD(struct cred, euid, si, target_size);
+		break;
+	case offsetof(struct dtrace_bpf_context, egid):
+		*insn++ = BPF_LDX_CTX_PTR(struct dtrace_bpf_ctx, task, si);
+		*insn++ = BPF_LDX_LNK_PTR(struct task_struct, cred, si);
+		*insn++ = BPF_LDX_LNK_FIELD(struct cred, egid, si, target_size);
+		break;
+	default:
+		*insn++ = BPF_LDX_CTX_PTR(struct dtrace_bpf_ctx, regs, si);
+		*insn++ = BPF_LDX_MEM(BPF_SIZEOF(long), si->dst_reg, si->dst_reg,
+				      si->off);
+		break;
+	}
+
+	return insn - insn_buf;
+}
+
+const struct bpf_verifier_ops dtrace_verifier_ops = {
+	.get_func_proto		= dtrace_get_func_proto,
+	.is_valid_access	= dtrace_is_valid_access,
+	.convert_ctx_access	= dtrace_convert_ctx_access,
+};
+
+/*
+ * Verify whether BPF programs of the given program type can tail-call DTrace
+ * BPF programs.
+ */
+static bool dtrace_is_valid_tail_call(enum bpf_prog_type stype)
+{
+	if (stype == BPF_PROG_TYPE_KPROBE)
+		return true;
+
+	return false;
+}
+
+/*
+ * Only one BPF program can be running on a given CPU at a time, and tail-call
+ * execution is effectively a jump (no return possble).  Therefore, we never
+ * need more than one DTrace BPF context per CPU.
+ */
+DEFINE_PER_CPU(struct dtrace_bpf_ctx, dtrace_ctx);
+
+/*
+ * Create a DTrace BPF program execution context based on the provided context
+ * for the given BPF program type.
+ */
+static void *dtrace_convert_ctx(enum bpf_prog_type stype, void *ctx)
+{
+	struct dtrace_bpf_ctx *gctx;
+
+	if (stype == BPF_PROG_TYPE_KPROBE) {
+		gctx = this_cpu_ptr(&dtrace_ctx);
+		gctx->regs = (struct pt_regs *)ctx;
+		gctx->task = current;
+
+		return gctx;
+	}
+
+	return NULL;
+}
+
+const struct bpf_prog_ops dtrace_prog_ops = {
+	.is_valid_tail_call	= dtrace_is_valid_tail_call,
+	.convert_ctx		= dtrace_convert_ctx,
+};
-- 
2.20.1

