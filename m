Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37E9A649E9
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 17:43:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727706AbfGJPna (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 11:43:30 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:40656 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbfGJPna (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 11:43:30 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6AFcsnY145440;
        Wed, 10 Jul 2019 15:42:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id :
 mime-version : date : from : to : cc : subject : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=Q1+jJsq8prXtuxG4W90oBXadxiI4PgbnRnNlyVmH2nU=;
 b=urIvEC8kFA8fPr7A+uJnHjWo+U1Xo8WOnngfUuSjTb4fKMAIEPtFEYjshy5TzR661ghq
 134PUqdiH2Xwl2xU8Lh736BwnbT+6doDKTRAy2pq3SxYJPn5nd1UpJf4GjuT/yDYwmSE
 MSVeNeUPe8mEz7xTkWu48mTXMCiPVTtHInHDFTjjLtQI+z4k2n9TLougCWuqIOmZDret
 BycS4lji20jMkfkaI0pg1CNcz2ihy5VGVptUzpp+/qUvpkIHwWexJJ20A5AxMdPmgrtV
 jzhsTKEOTSfI3UEiRxWn/O0fKHtG8yfYREBfD484DeuTmVbcOZhzuANDlKh+KfMAbSf0 qQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2tjm9qtxsx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Jul 2019 15:42:26 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6AFc4Oj142840;
        Wed, 10 Jul 2019 15:42:26 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 2tn1j0xj6e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 10 Jul 2019 15:42:26 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x6AFgPgA153057;
        Wed, 10 Jul 2019 15:42:25 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2tn1j0xj6a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Jul 2019 15:42:25 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x6AFgOO9012232;
        Wed, 10 Jul 2019 15:42:24 GMT
Message-Id: <201907101542.x6AFgOO9012232@userv0121.oracle.com>
Received: from localhost (/10.159.211.102) by default (Oracle Beehive Gateway
 v4.0) with ESMTP ; Wed, 10 Jul 2019 08:42:22 -0700
MIME-Version: 1.0
Date:   Wed, 10 Jul 2019 08:42:24 -0700 (PDT)
From:   Kris Van Hees <kris.van.hees@oracle.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        dtrace-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Cc:     rostedt@goodmis.org, mhiramat@kernel.org, acme@kernel.org,
        ast@kernel.org, daniel@iogearbox.net,
        Peter Zijlstra <peterz@infradead.org>, Chris Mason <clm@fb.com>
Subject: [PATCH V2 0/1] tools/dtrace: initial implementation of DTrace
In-Reply-To: <201907101537.x6AFboMR015946@aserv0122.oracle.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9314 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907100177
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This initial implementation of a tiny subset of DTrace functionality
provides the following options:

	dtrace [-lvV] [-b bufsz] -s script
	    -b  set trace buffer size
	    -l  list probes (only works with '-s script' for now)
	    -s  enable or list probes for the specified BPF program
	    -V  report DTrace API version

The patch comprises quite a bit of code due to DTrace requiring a few
crucial components, even in its most basic form.

The code is structured around the command line interface implemented in
dtrace.c.  It provides option parsing and drives the three modes of
operation that are currently implemented:

1. Report DTrace API version information.
	Report the version information and terminate.

2. List probes in BPF programs.
	Initialize the list of probes that DTrace recognizes, load BPF
	programs, parse all BPF ELF section names, resolve them into
	known probes, and emit the probe names.  Then terminate.

3. Load BPF programs and collect tracing data.
	Initialize the list of probes that DTrace recognizes, load BPF
	programs and attach them to their corresponding probes, set up
	perf event output buffers, and start processing tracing data.

This implementation makes extensive use of BPF (handled by dt_bpf.c) and
the perf event output ring buffer (handled by dt_buffer.c).  DTrace-style
probe handling (dt_probe.c) offers an interface to probes that hides the
implementation details of the individual probe types by provider (dt_fbt.c
and dt_syscall.c).  Probe lookup by name uses a hashtable implementation
(dt_hash.c).  The dt_utils.c code populates a list of online CPU ids, so
we know what CPUs we can obtain tracing data from.

Building the tool is trivial because its only dependency (libbpf) is in
the kernel tree under tools/lib/bpf.  A simple 'make' in the tools/dtrace
directory suffices.

The 'dtrace' executable needs to run as root because BPF programs cannot
be loaded by non-root users.

Signed-off-by: Kris Van Hees <kris.van.hees@oracle.com>
Reviewed-by: David Mc Lean <david.mclean@oracle.com>
Reviewed-by: Eugene Loh <eugene.loh@oracle.com>
---
Changes in v2:
        - Use ring_buffer_read_head() and ring_buffer_write_tail() to
          avoid use of volatile.
        - Handle perf events that wrap around the ring buffer boundary.
        - Remove unnecessary PERF_EVENT_IOC_ENABLE.
        - Remove -I$(srctree)/tools/perf from KBUILD_HOSTCFLAGS since it
          is not actually used.
        - Use PT_REGS_PARM1(x), etc instead of my own macros.  Adding 
          PT_REGS_PARM6(x) in bpf_sample.c because we need to be able to
          support up to 6 arguments passed by registers.
---
 MAINTAINERS                |   6 +
 tools/dtrace/Makefile      |  87 ++++++++++
 tools/dtrace/bpf_sample.c  | 146 ++++++++++++++++
 tools/dtrace/dt_bpf.c      | 185 ++++++++++++++++++++
 tools/dtrace/dt_buffer.c   | 338 +++++++++++++++++++++++++++++++++++++
 tools/dtrace/dt_fbt.c      | 201 ++++++++++++++++++++++
 tools/dtrace/dt_hash.c     | 211 +++++++++++++++++++++++
 tools/dtrace/dt_probe.c    | 230 +++++++++++++++++++++++++
 tools/dtrace/dt_syscall.c  | 179 ++++++++++++++++++++
 tools/dtrace/dt_utils.c    | 132 +++++++++++++++
 tools/dtrace/dtrace.c      | 249 +++++++++++++++++++++++++++
 tools/dtrace/dtrace.h      |  13 ++
 tools/dtrace/dtrace_impl.h | 101 +++++++++++
 13 files changed, 2078 insertions(+)
 create mode 100644 tools/dtrace/Makefile
 create mode 100644 tools/dtrace/bpf_sample.c
 create mode 100644 tools/dtrace/dt_bpf.c
 create mode 100644 tools/dtrace/dt_buffer.c
 create mode 100644 tools/dtrace/dt_fbt.c
 create mode 100644 tools/dtrace/dt_hash.c
 create mode 100644 tools/dtrace/dt_probe.c
 create mode 100644 tools/dtrace/dt_syscall.c
 create mode 100644 tools/dtrace/dt_utils.c
 create mode 100644 tools/dtrace/dtrace.c
 create mode 100644 tools/dtrace/dtrace.h
 create mode 100644 tools/dtrace/dtrace_impl.h

diff --git a/MAINTAINERS b/MAINTAINERS
index cfa9ed89c031..410240732d55 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5485,6 +5485,12 @@ W:	https://linuxtv.org
 S:	Odd Fixes
 F:	drivers/media/pci/dt3155/
 
+DTRACE
+M:	Kris Van Hees <kris.van.hees@oracle.com>
+L:	dtrace-devel@oss.oracle.com
+S:	Maintained
+F:	tools/dtrace/
+
 DVB_USB_AF9015 MEDIA DRIVER
 M:	Antti Palosaari <crope@iki.fi>
 L:	linux-media@vger.kernel.org
diff --git a/tools/dtrace/Makefile b/tools/dtrace/Makefile
new file mode 100644
index 000000000000..03ae498d1429
--- /dev/null
+++ b/tools/dtrace/Makefile
@@ -0,0 +1,87 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# This Makefile is based on samples/bpf.
+#
+# Copyright (c) 2019, Oracle and/or its affiliates. All rights reserved.
+
+DT_VERSION		:= 2.0.0
+DT_GIT_VERSION		:= $(shell git rev-parse HEAD 2>/dev/null || \
+				   echo Unknown)
+
+DTRACE_PATH		?= $(abspath $(srctree)/$(src))
+TOOLS_PATH		:= $(DTRACE_PATH)/..
+SAMPLES_PATH		:= $(DTRACE_PATH)/../../samples
+
+hostprogs-y		:= dtrace
+
+LIBBPF			:= $(TOOLS_PATH)/lib/bpf/libbpf.a
+OBJS			:= dt_bpf.o dt_buffer.o dt_utils.o dt_probe.o \
+			   dt_hash.o \
+			   dt_fbt.o dt_syscall.o
+
+dtrace-objs		:= $(OBJS) dtrace.o
+
+always			:= $(hostprogs-y)
+always			+= bpf_sample.o
+
+KBUILD_HOSTCFLAGS	+= -DDT_VERSION=\"$(DT_VERSION)\"
+KBUILD_HOSTCFLAGS	+= -DDT_GIT_VERSION=\"$(DT_GIT_VERSION)\"
+KBUILD_HOSTCFLAGS	+= -I$(srctree)/tools/lib
+KBUILD_HOSTCFLAGS	+= -I$(srctree)/tools/include/uapi
+KBUILD_HOSTCFLAGS	+= -I$(srctree)/tools/include/
+KBUILD_HOSTCFLAGS	+= -I$(srctree)/usr/include
+
+KBUILD_HOSTLDLIBS	:= $(LIBBPF) -lelf
+
+LLC			?= llc
+CLANG			?= clang
+LLVM_OBJCOPY		?= llvm-objcopy
+
+ifdef CROSS_COMPILE
+HOSTCC			= $(CROSS_COMPILE)gcc
+CLANG_ARCH_ARGS		= -target $(ARCH)
+endif
+
+all:
+	$(MAKE) -C ../../ $(CURDIR)/ DTRACE_PATH=$(CURDIR)
+
+clean:
+	$(MAKE) -C ../../ M=$(CURDIR) clean
+	@rm -f *~
+
+$(LIBBPF): FORCE
+	$(MAKE) -C $(dir $@) RM='rm -rf' LDFLAGS= srctree=$(DTRACE_PATH)/../../ O=
+
+FORCE:
+
+.PHONY: verify_cmds verify_target_bpf $(CLANG) $(LLC)
+
+verify_cmds: $(CLANG) $(LLC)
+	@for TOOL in $^ ; do \
+		if ! (which -- "$${TOOL}" > /dev/null 2>&1); then \
+			echo "*** ERROR: Cannot find LLVM tool $${TOOL}" ;\
+			exit 1; \
+		else true; fi; \
+	done
+
+verify_target_bpf: verify_cmds
+	@if ! (${LLC} -march=bpf -mattr=help > /dev/null 2>&1); then \
+		echo "*** ERROR: LLVM (${LLC}) does not support 'bpf' target" ;\
+		echo "   NOTICE: LLVM version >= 3.7.1 required" ;\
+		exit 2; \
+	else true; fi
+
+$(DTRACE_PATH)/*.c: verify_target_bpf $(LIBBPF)
+$(src)/*.c: verify_target_bpf $(LIBBPF)
+
+$(obj)/%.o: $(src)/%.c
+	@echo "  CLANG-bpf " $@
+	$(Q)$(CLANG) $(NOSTDINC_FLAGS) $(LINUXINCLUDE) $(EXTRA_CFLAGS) -I$(obj) \
+		-I$(srctree)/tools/testing/selftests/bpf/ \
+		-D__KERNEL__ -D__BPF_TRACING__ -Wno-unused-value -Wno-pointer-sign \
+		-D__TARGET_ARCH_$(ARCH) -Wno-compare-distinct-pointer-types \
+		-Wno-gnu-variable-sized-type-not-at-end \
+		-Wno-address-of-packed-member -Wno-tautological-compare \
+		-Wno-unknown-warning-option $(CLANG_ARCH_ARGS) \
+		-I$(srctree)/samples/bpf/ -include asm_goto_workaround.h \
+		-O2 -emit-llvm -c $< -o -| $(LLC) -march=bpf $(LLC_FLAGS) -filetype=obj -o $@
diff --git a/tools/dtrace/bpf_sample.c b/tools/dtrace/bpf_sample.c
new file mode 100644
index 000000000000..9862f75f92d3
--- /dev/null
+++ b/tools/dtrace/bpf_sample.c
@@ -0,0 +1,146 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * This sample DTrace BPF tracing program demonstrates how actions can be
+ * associated with different probe types.
+ *
+ * The kprobe/ksys_write probe is a Function Boundary Tracing (FBT) entry probe
+ * on the ksys_write(fd, buf, count) function in the kernel.  Arguments to the
+ * function can be retrieved from the CPU registers (struct pt_regs).
+ *
+ * The tracepoint/syscalls/sys_enter_write probe is a System Call entry probe
+ * for the write(d, buf, count) system call.  Arguments to the system call can
+ * be retrieved from the tracepoint data passed to the BPF program as context
+ * struct syscall_data) when the probe fires.
+ *
+ * The BPF program associated with each probe prepares a DTrace BPF context
+ * (struct dt_bpf_context) that stores the probe ID and up to 10 arguments.
+ * Only 3 arguments are used in this sample.  Then the prorgams call a shared
+ * BPF function (bpf_action) that implements the actual action to be taken when
+ * a probe fires.  It prepares a data record to be stored in the tracing buffer
+ * and submits it to the buffer.  The data in the data record is obtained from
+ * the DTrace BPF context.
+ *
+ * Copyright (c) 2019, Oracle and/or its affiliates. All rights reserved.
+ */
+#include <uapi/linux/bpf.h>
+#include <linux/ptrace.h>
+#include <linux/version.h>
+#include <uapi/linux/unistd.h>
+#include "bpf_helpers.h"
+
+#include "dtrace.h"
+
+struct syscall_data {
+	struct pt_regs *regs;
+	long syscall_nr;
+	long arg[6];
+};
+
+struct bpf_map_def SEC("maps") buffers = {
+	.type = BPF_MAP_TYPE_PERF_EVENT_ARRAY,
+	.key_size = sizeof(u32),
+	.value_size = sizeof(u32),
+	.max_entries = NR_CPUS,
+};
+
+#if defined(bpf_target_x86)
+# define PT_REGS_PARM6(x)	((x)->r9)
+#elif defined(bpf_target_s390x)
+# define PT_REGS_PARM6(x)	((x)->gprs[7])
+#elif defined(bpf_target_arm)
+# define PT_REGS_PARM6(x)	((x)->uregs[5])
+#elif defined(bpf_target_arm64)
+# define PT_REGS_PARM6(x)	((x)->regs[5])
+#elif defined(bpf_target_mips)
+# define PT_REGS_PARM6(x)	((x)->regs[9])
+#elif defined(bpf_target_powerpc)
+# define PT_REGS_PARM6(x)	((x)->gpr[8])
+#elif defined(bpf_target_sparc)
+# define PT_REGS_PARM6(x)	((x)->u_regs[UREG_I5])
+#else
+# error Argument retrieval from pt_regs is not supported yet on this arch.
+#endif
+
+/*
+ * We must pass a valid BPF context pointer because the bpf_perf_event_output()
+ * helper requires a BPF context pointer as first argument (and the verifier is
+ * validating that we pass a value that is known to be a context pointer).
+ *
+ * This BPF function implements the following D action:
+ * {
+ *	trace(curthread);
+ *	trace(arg0);
+ *	trace(arg1);
+ *	trace(arg2);
+ * }
+ *
+ * Expected output will look like:
+ *   CPU     ID
+ *    15  70423 0xffff8c0968bf8ec0 0x00000000000001 0x0055e019eb3f60 0x0000000000002c
+ *    15  18876 0xffff8c0968bf8ec0 0x00000000000001 0x0055e019eb3f60 0x0000000000002c
+ *    |   |     +-- curthread      +--> arg0 (fd)   +--> arg1 (buf)  +-- arg2 (count)
+ *    |   |
+ *    |   +--> probe ID
+ *    |
+ *    +--> CPU the probe fired on
+ */
+static noinline int bpf_action(void *bpf_ctx, struct dt_bpf_context *ctx)
+{
+	int			cpu = bpf_get_smp_processor_id();
+	struct data {
+		u32	probe_id;	/* mandatory */
+
+		u64	task;		/* first data item (current task) */
+		u64	arg0;		/* 2nd data item (arg0, fd) */
+		u64	arg1;		/* 3rd data item (arg1, buf) */
+		u64	arg2;		/* 4th data item (arg2, count) */
+	}			rec;
+
+	memset(&rec, 0, sizeof(rec));
+
+	rec.probe_id = ctx->probe_id;
+	rec.task = bpf_get_current_task();
+	rec.arg0 = ctx->argv[0];
+	rec.arg1 = ctx->argv[1];
+	rec.arg2 = ctx->argv[2];
+
+	bpf_perf_event_output(bpf_ctx, &buffers, cpu, &rec, sizeof(rec));
+
+	return 0;
+}
+
+SEC("kprobe/ksys_write")
+int bpf_kprobe(struct pt_regs *regs)
+{
+	struct dt_bpf_context	ctx;
+
+	memset(&ctx, 0, sizeof(ctx));
+
+	ctx.probe_id = 18876;
+	ctx.argv[0] = PT_REGS_PARM1(regs);
+	ctx.argv[1] = PT_REGS_PARM2(regs);
+	ctx.argv[2] = PT_REGS_PARM3(regs);
+	ctx.argv[3] = PT_REGS_PARM4(regs);
+	ctx.argv[4] = PT_REGS_PARM5(regs);
+	ctx.argv[5] = PT_REGS_PARM6(regs);
+
+	return bpf_action(regs, &ctx);
+}
+
+SEC("tracepoint/syscalls/sys_enter_write")
+int bpf_tp(struct syscall_data *scd)
+{
+	struct dt_bpf_context	ctx;
+
+	memset(&ctx, 0, sizeof(ctx));
+
+	ctx.probe_id = 70423;
+	ctx.argv[0] = scd->arg[0];
+	ctx.argv[1] = scd->arg[1];
+	ctx.argv[2] = scd->arg[2];
+
+	return bpf_action(scd, &ctx);
+}
+
+char _license[] SEC("license") = "GPL";
+u32 _version SEC("version") = LINUX_VERSION_CODE;
diff --git a/tools/dtrace/dt_bpf.c b/tools/dtrace/dt_bpf.c
new file mode 100644
index 000000000000..78c90de016c6
--- /dev/null
+++ b/tools/dtrace/dt_bpf.c
@@ -0,0 +1,185 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * This file provides the interface for handling BPF.  It uses the bpf library
+ * to interact with BPF ELF object files.
+ *
+ * Copyright (c) 2019, Oracle and/or its affiliates. All rights reserved.
+ */
+#include <errno.h>
+#include <stdarg.h>
+#include <stdio.h>
+#include <string.h>
+#include <unistd.h>
+#include <bpf/libbpf.h>
+#include <linux/kernel.h>
+#include <linux/perf_event.h>
+#include <sys/ioctl.h>
+
+#include "dtrace_impl.h"
+
+/*
+ * Validate the output buffer map that is specified in the BPF ELF object.  It
+ * must match the following definition to be valid:
+ *
+ * struct bpf_map_def SEC("maps") buffers = {
+ *	.type = BPF_MAP_TYPE_PERF_EVENT_ARRAY,
+ *	.key_size = sizeof(u32),
+ *	.value_size = sizeof(u32),
+ *	.max_entries = num,
+ * };
+ * where num is greater than dt_maxcpuid.
+ */
+static int is_valid_buffers(const struct bpf_map_def *mdef)
+{
+	return mdef->type == BPF_MAP_TYPE_PERF_EVENT_ARRAY &&
+	       mdef->key_size == sizeof(u32) &&
+	       mdef->value_size == sizeof(u32) &&
+	       mdef->max_entries > dt_maxcpuid;
+}
+
+/*
+ * List the probes specified in the given BPF ELF object file.
+ */
+int dt_bpf_list_probes(const char *fn)
+{
+	struct bpf_object	*obj;
+	struct bpf_program	*prog;
+	int			rc, fd;
+
+	libbpf_set_print(NULL);
+
+	/*
+	 * Listing probes is done before the DTrace command line utility loads
+	 * the supplied programs.  We load them here without attaching them to
+	 * probes so that we can retrieve the ELF section names for each BPF
+	 * program.  The section name indicates the probe that the program is
+	 * associated with.
+	 */
+	rc = bpf_prog_load(fn, BPF_PROG_TYPE_UNSPEC, &obj, &fd);
+	if (rc)
+		return rc;
+
+	/*
+	 * Loop through the programs in the BPF ELF object, and try to resolve
+	 * the section names into probes.  Use the supplied callback function
+	 * to emit the probe description.
+	 */
+	for (prog = bpf_program__next(NULL, obj); prog != NULL;
+	     prog = bpf_program__next(prog, obj)) {
+		struct dt_probe	*probe;
+
+		probe = dt_probe_resolve_event(bpf_program__title(prog, false));
+
+		printf("%5d %10s %17s %33s %s\n", probe->id,
+		       probe->prv_name ? probe->prv_name : "",
+		       probe->mod_name ? probe->mod_name : "",
+		       probe->fun_name ? probe->fun_name : "",
+		       probe->prb_name ? probe->prb_name : "");
+	}
+
+
+	/* Done with the BPF ELF object.  */
+	bpf_object__close(obj);
+
+	return 0;
+}
+
+/*
+ * Load the given BPF ELF object file.
+ */
+int dt_bpf_load_file(const char *fn)
+{
+	struct bpf_object	*obj;
+	struct bpf_map		*map;
+	struct bpf_program	*prog;
+	int			rc, fd;
+
+	libbpf_set_print(NULL);
+
+	/* Load the BPF ELF object file. */
+	rc = bpf_prog_load(fn, BPF_PROG_TYPE_UNSPEC, &obj, &fd);
+	if (rc)
+		return rc;
+
+	/* Validate buffers map. */
+	map = bpf_object__find_map_by_name(obj, "buffers");
+	if (map && is_valid_buffers(bpf_map__def(map)))
+		dt_bufmap_fd = bpf_map__fd(map);
+	else
+		goto fail;
+
+	/*
+	 * Loop through the programs and resolve each into the matching probe.
+	 * Attach the program to the probe.
+	 */
+	for (prog = bpf_program__next(NULL, obj); prog != NULL;
+	     prog = bpf_program__next(prog, obj)) {
+		struct dt_probe	*probe;
+
+		probe = dt_probe_resolve_event(bpf_program__title(prog, false));
+		if (!probe)
+			return -ENOENT;
+		if (probe->prov && probe->prov->attach)
+			probe->prov->attach(bpf_program__title(prog, false),
+					    bpf_program__fd(prog));
+	}
+
+	return 0;
+
+fail:
+	bpf_object__close(obj);
+	return -EINVAL;
+}
+
+/*
+ * Store the (key, value) pair in the map referenced by the given fd.
+ */
+int dt_bpf_map_update(int fd, const void *key, const void *val)
+{
+	union bpf_attr	attr;
+
+	memset(&attr, 0, sizeof(attr));
+
+	attr.map_fd = fd;
+	attr.key = (u64)(unsigned long)key;
+	attr.value = (u64)(unsigned long)val;
+	attr.flags = 0;
+
+	return bpf(BPF_MAP_UPDATE_ELEM, &attr);
+}
+
+/*
+ * Attach a trace event and associate a BPF program with it.
+ */
+int dt_bpf_attach(int event_id, int bpf_fd)
+{
+	int			event_fd;
+	int			rc;
+	struct perf_event_attr	attr = {};
+
+	attr.type = PERF_TYPE_TRACEPOINT;
+	attr.sample_type = PERF_SAMPLE_RAW;
+	attr.sample_period = 1;
+	attr.wakeup_events = 1;
+	attr.config = event_id;
+
+	/*
+	 * Register the event (based on its id), and obtain a fd.  It gets
+	 * created as an enabled probe, so we don't have to explicitly enable
+	 * it.
+	 */
+	event_fd = perf_event_open(&attr, -1, 0, -1, 0);
+	if (event_fd < 0) {
+		perror("sys_perf_event_open");
+		return -1;
+	}
+
+	/* Associate the BPF program with the event. */
+	rc = ioctl(event_fd, PERF_EVENT_IOC_SET_BPF, bpf_fd);
+	if (rc < 0) {
+		perror("PERF_EVENT_IOC_SET_BPF");
+		return -1;
+	}
+
+	return 0;
+}
diff --git a/tools/dtrace/dt_buffer.c b/tools/dtrace/dt_buffer.c
new file mode 100644
index 000000000000..19bb7e4cfc92
--- /dev/null
+++ b/tools/dtrace/dt_buffer.c
@@ -0,0 +1,338 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * This file provides the tracing buffer handling for DTrace.  It makes use of
+ * the perf event output ring buffers that can be written to from BPF programs.
+ *
+ * Copyright (c) 2019, Oracle and/or its affiliates. All rights reserved.
+ */
+#include <errno.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <syscall.h>
+#include <unistd.h>
+#include <sys/epoll.h>
+#include <sys/ioctl.h>
+#include <sys/mman.h>
+#include <linux/bpf.h>
+#include <linux/perf_event.h>
+#include <linux/ring_buffer.h>
+
+#include "dtrace_impl.h"
+
+/*
+ * Probe data is recorded in per-CPU perf ring buffers.
+ */
+struct dtrace_buffer {
+	int	cpu;			/* ID of CPU that uses this buffer */
+	int	fd;			/* fd of perf output buffer */
+	size_t	page_size;		/* size of each page in buffer */
+	size_t	data_size;		/* total buffer size */
+	u8	*base;			/* address of buffer */
+	u8	*endp;			/* address of end of buffer */
+	u8	*tmp;			/* temporary event buffer */
+	u32	tmp_len;		/* length of temporary event buffer */
+};
+
+static struct dtrace_buffer	*dt_buffers;
+
+/*
+ * File descriptor for the BPF map that holds the buffers for the online CPUs.
+ * The map is a bpf_array indexed by CPU id, and it stores a file descriptor as
+ * value (the fd for the perf_event that represents the CPU buffer).
+ */
+int				dt_bufmap_fd = -1;
+
+/*
+ * Create a perf_event buffer for the given DTrace buffer.  This will create
+ * a perf_event ring_buffer, mmap it, and enable the perf_event that owns the
+ * buffer.
+ */
+static int perf_buffer_open(struct dtrace_buffer *buf)
+{
+	int			pefd;
+	struct perf_event_attr	attr = {};
+
+	/*
+	 * Event configuration for BPF-generated output in perf_event ring
+	 * buffers.  The event is created in enabled state.
+	 */
+	attr.config = PERF_COUNT_SW_BPF_OUTPUT;
+	attr.type = PERF_TYPE_SOFTWARE;
+	attr.sample_type = PERF_SAMPLE_RAW;
+	attr.sample_period = 1;
+	attr.wakeup_events = 1;
+	pefd = perf_event_open(&attr, -1, buf->cpu, -1, PERF_FLAG_FD_CLOEXEC);
+	if (pefd < 0) {
+		fprintf(stderr, "perf_event_open(cpu %d): %s\n", buf->cpu,
+			strerror(errno));
+		goto fail;
+	}
+
+	/*
+	 * We add buf->page_size to the buf->data_size, because perf maintains
+	 * a meta-data page at the beginning of the memory region.  That page
+	 * is used for reader/writer symchronization.
+	 */
+	buf->fd = pefd;
+	buf->base = mmap(NULL, buf->page_size + buf->data_size,
+			 PROT_READ | PROT_WRITE, MAP_SHARED, buf->fd, 0);
+	buf->endp = buf->base + buf->page_size + buf->data_size - 1;
+	if (!buf->base)
+		goto fail;
+
+	return 0;
+
+fail:
+	if (buf->base) {
+		munmap(buf->base, buf->page_size + buf->data_size);
+		buf->base = NULL;
+		buf->endp = NULL;
+	}
+	if (buf->fd) {
+		close(buf->fd);
+		buf->fd = -1;
+	}
+
+	return -1;
+}
+
+/*
+ * Close the given DTrace buffer.  This function disables the perf_event that
+ * owns the buffer, munmaps the memory space, and closes the perf buffer fd.
+ */
+static void perf_buffer_close(struct dtrace_buffer *buf)
+{
+	/*
+	 * If the perf buffer failed to open, there is no need to close it.
+	 */
+	if (buf->fd < 0)
+		return;
+
+	if (ioctl(buf->fd, PERF_EVENT_IOC_DISABLE, 0) < 0)
+		fprintf(stderr, "PERF_EVENT_IOC_DISABLE(cpu %d): %s\n",
+			buf->cpu, strerror(errno));
+
+	munmap(buf->base, buf->page_size + buf->data_size);
+
+	if (close(buf->fd))
+		fprintf(stderr, "perf buffer close(cpu %d): %s\n",
+			buf->cpu, strerror(errno));
+
+	buf->base = NULL;
+	buf->fd = -1;
+}
+
+/*
+ * Initialize the probe data buffers (one per online CPU).  Each buffer will
+ * contain the given number of pages (i.e. total size of each buffer will be
+ * num_pages * getpagesize()).  This function also sets up an event polling
+ * descriptor that monitors all CPU buffers at once.
+ */
+int dt_buffer_init(int num_pages)
+{
+	int	i;
+	int	epoll_fd;
+
+	if (dt_bufmap_fd < 0)
+		return -EINVAL;
+
+	/* Allocate the per-CPU buffer structs. */
+	dt_buffers = calloc(dt_numcpus, sizeof(struct dtrace_buffer));
+	if (dt_buffers == NULL)
+		return -ENOMEM;
+
+	/* Set up the event polling file descriptor. */
+	epoll_fd = epoll_create1(EPOLL_CLOEXEC);
+	if (epoll_fd < 0) {
+		free(dt_buffers);
+		return -errno;
+	}
+
+	for (i = 0; i < dt_numcpus; i++) {
+		int			cpu = dt_cpuids[i];
+		struct epoll_event	ev;
+		struct dtrace_buffer	*buf = &dt_buffers[i];
+
+		buf->cpu = cpu;
+		buf->page_size = getpagesize();
+		buf->data_size = num_pages * buf->page_size;
+		buf->tmp = NULL;
+		buf->tmp_len = 0;
+
+		/* Try to create the perf buffer for this DTrace buffer. */
+		if (perf_buffer_open(buf) == -1)
+			continue;
+
+		/* Store the perf buffer fd in the buffer map. */
+		dt_bpf_map_update(dt_bufmap_fd, &cpu, &buf->fd);
+
+		/* Add the buffer to the event polling descriptor. */
+		ev.events = EPOLLIN;
+		ev.data.ptr = buf;
+		if (epoll_ctl(epoll_fd, EPOLL_CTL_ADD, buf->fd, &ev) == -1) {
+			fprintf(stderr, "EPOLL_CTL_ADD(cpu %d): %s\n",
+				buf->cpu, strerror(errno));
+			continue;
+		}
+	}
+
+	return epoll_fd;
+}
+
+/*
+ * Clean up the buffers.
+ */
+void dt_buffer_exit(int epoll_fd)
+{
+	int	i;
+
+	for (i = 0; i < dt_numcpus; i++)
+		perf_buffer_close(&dt_buffers[i]);
+
+	free(dt_buffers);
+	close(epoll_fd);
+}
+
+/*
+ * Process and output the probe data at the supplied address.
+ */
+static void output_event(int cpu, u64 *buf)
+{
+	u8				*data = (u8 *)buf;
+	struct perf_event_header	*hdr;
+
+	hdr = (struct perf_event_header *)data;
+	data += sizeof(struct perf_event_header);
+
+	if (hdr->type == PERF_RECORD_SAMPLE) {
+		u8		*ptr = data;
+		u32		i, size, probe_id;
+
+		/*
+		 * struct {
+		 *	struct perf_event_header	header;
+		 *	u32				size;
+		 *	u32				probe_id;
+		 *	u32				gap;
+		 *	u64				data[n];
+		 * }
+		 * and data points to the 'size' member at this point.
+		 */
+		if (ptr > (u8 *)buf + hdr->size) {
+			fprintf(stderr, "BAD: corrupted sample header\n");
+			return;
+		}
+
+		size = *(u32 *)data;
+		data += sizeof(size);
+		ptr += sizeof(size) + size;
+		if (ptr != (u8 *)buf + hdr->size) {
+			fprintf(stderr, "BAD: invalid sample size\n");
+			return;
+		}
+
+		probe_id = *(u32 *)data;
+		data += sizeof(probe_id);
+		size -= sizeof(probe_id);
+		data += sizeof(u32);		/* skip 32-bit gap */
+		size -= sizeof(u32);
+		buf = (u64 *)data;
+
+		printf("%3d %6d ", cpu, probe_id);
+		for (i = 0, size /= sizeof(u64); i < size; i++)
+			printf("%#016lx ", buf[i]);
+		printf("\n");
+	} else if (hdr->type == PERF_RECORD_LOST) {
+		u64	lost;
+
+		/*
+		 * struct {
+		 *	struct perf_event_header	header;
+		 *	u64				id;
+		 *	u64				lost;
+		 * }
+		 * and data points to the 'id' member at this point.
+		 */
+		lost = *(u64 *)(data + sizeof(u64));
+
+		printf("[%ld probes dropped]\n", lost);
+	} else
+		fprintf(stderr, "UNKNOWN: record type %d\n", hdr->type);
+}
+
+/*
+ * Process the available probe data in the given buffer.
+ */
+static void process_data(struct dtrace_buffer *buf)
+{
+	struct perf_event_mmap_page	*rb_page = (void *)buf->base;
+	struct perf_event_header	*hdr;
+	u8				*base;
+	u64				head, tail;
+
+	/* Set base to be the start of the buffer data. */
+	base = buf->base + buf->page_size;
+
+	for (;;) {
+		head = ring_buffer_read_head(rb_page);
+		tail = rb_page->data_tail;
+
+		if (tail == head)
+			break;
+
+		do {
+			u8	*event = base + tail % buf->data_size;
+			u32	len;
+
+			hdr = (struct perf_event_header *)event;
+			len = hdr->size;
+
+			/*
+			 * If the perf event data wraps around the boundary of
+			 * the buffer, we make a copy in contiguous memory.
+			 */
+			if (event + len > buf->endp) {
+				u8	*dst;
+				u32	num;
+
+				/* Increase buffer as needed. */
+				if (buf->tmp_len < len) {
+					buf->tmp = realloc(buf->tmp, len);
+					buf->tmp_len = len;
+				}
+
+				dst = buf->tmp;
+				num = buf->endp - event + 1;
+				memcpy(dst, event, num);
+				memcpy(dst + num, base, len - num);
+
+				event = dst;
+			}
+
+			output_event(buf->cpu, (u64 *)event);
+
+			tail += hdr->size;
+		} while (tail != head);
+
+		ring_buffer_write_tail(rb_page, tail);
+	}
+}
+
+/*
+ * Wait for data to become available in any of the buffers.
+ */
+int dt_buffer_poll(int epoll_fd, int timeout)
+{
+	struct epoll_event	events[dt_numcpus];
+	int			i, cnt;
+
+	cnt = epoll_wait(epoll_fd, events, dt_numcpus, timeout);
+	if (cnt < 0)
+		return -errno;
+
+	for (i = 0; i < cnt; i++)
+		process_data((struct dtrace_buffer *)events[i].data.ptr);
+
+	return cnt;
+}
diff --git a/tools/dtrace/dt_fbt.c b/tools/dtrace/dt_fbt.c
new file mode 100644
index 000000000000..fcf95243bf97
--- /dev/null
+++ b/tools/dtrace/dt_fbt.c
@@ -0,0 +1,201 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * The Function Boundary Tracing (FBT) provider for DTrace.
+ *
+ * FBT probes are exposed by the kernel as kprobes.  They are listed in the
+ * TRACEFS/available_filter_functions file.  Some kprobes are associated with
+ * a specific kernel module, while most are in the core kernel.
+ *
+ * Mapping from event name to DTrace probe name:
+ *
+ *      <name>					fbt:vmlinux:<name>:entry
+ *						fbt:vmlinux:<name>:return
+ *   or
+ *      <name> [<modname>]			fbt:<modname>:<name>:entry
+ *						fbt:<modname>:<name>:return
+ *
+ * Mapping from BPF section name to DTrace probe name:
+ *
+ *      kprobe/<name>				fbt:vmlinux:<name>:entry
+ *      kretprobe/<name>			fbt:vmlinux:<name>:return
+ *
+ * (Note that the BPF section does not carry information about the module that
+ *  the function is found in.  This means that BPF section name cannot be used
+ *  to distinguish between functions with the same name occurring in different
+ *  modules.)
+ *
+ * Copyright (c) 2019, Oracle and/or its affiliates. All rights reserved.
+ */
+#include <fcntl.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <linux/bpf.h>
+#include <sys/stat.h>
+#include <sys/types.h>
+
+#include "dtrace_impl.h"
+
+#define KPROBE_EVENTS	TRACEFS "kprobe_events"
+#define PROBE_LIST	TRACEFS "available_filter_functions"
+
+static const char	provname[] = "fbt";
+static const char	modname[] = "vmlinux";
+
+/*
+ * Scan the PROBE_LIST file and add entry and return probes for every function
+ * that is listed.
+ */
+static int fbt_populate(void)
+{
+	FILE			*f;
+	char			buf[256];
+	char			*p;
+
+	f = fopen(PROBE_LIST, "r");
+	if (f == NULL)
+		return -1;
+
+	while (fgets(buf, sizeof(buf), f)) {
+		/*
+		 * Here buf is either "funcname\n" or "funcname [modname]\n".
+		 */
+		p = strchr(buf, '\n');
+		if (p) {
+			*p = '\0';
+			if (p > buf && *(--p) == ']')
+				*p = '\0';
+		} else {
+			/* If we didn't see a newline, the line was too long.
+			 * Report it, and continue until the end of the line.
+			 */
+			fprintf(stderr, "%s: Line too long: %s\n",
+				PROBE_LIST, buf);
+			do
+				fgets(buf, sizeof(buf), f);
+			while (strchr(buf, '\n') == NULL);
+			continue;
+		}
+
+		/*
+		 * Now buf is either "funcname" or "funcname [modname".  If
+		 * there is no module name provided, we will use the default.
+		 */
+		p = strchr(buf, ' ');
+		if (p) {
+			*p++ = '\0';
+			if (*p == '[')
+				p++;
+		}
+
+		dt_probe_new(&dt_fbt, provname, p ? p : modname, buf, "entry");
+		dt_probe_new(&dt_fbt, provname, p ? p : modname, buf, "return");
+	}
+
+	fclose(f);
+
+	return 0;
+}
+
+#define ENTRY_PREFIX	"kprobe/"
+#define EXIT_PREFIX	"kretprobe/"
+
+/*
+ * Perform a probe lookup based on an event name (BPF ELF section name).
+ */
+static struct dt_probe *fbt_resolve_event(const char *name)
+{
+	const char	*prbname;
+	struct dt_probe	tmpl;
+	struct dt_probe	*probe;
+
+	if (!name)
+		return NULL;
+
+	if (strncmp(name, ENTRY_PREFIX, sizeof(ENTRY_PREFIX) - 1) == 0) {
+		name += sizeof(ENTRY_PREFIX) - 1;
+		prbname = "entry";
+	} else if (strncmp(name, EXIT_PREFIX, sizeof(EXIT_PREFIX) - 1) == 0) {
+		name += sizeof(EXIT_PREFIX) - 1;
+		prbname = "return";
+	} else
+		return NULL;
+
+	memset(&tmpl, 0, sizeof(tmpl));
+	tmpl.prv_name = provname;
+	tmpl.mod_name = modname;
+	tmpl.fun_name = name;
+	tmpl.prb_name = prbname;
+
+	probe = dt_probe_by_name(&tmpl);
+
+	return probe;
+}
+
+/*
+ * Attach the given BPF program (identified by its file descriptor) to the
+ * kprobe identified by the given section name.
+ */
+static int fbt_attach(const char *name, int bpf_fd)
+{
+	char    efn[256];
+	char    buf[256];
+	int	event_id, fd, rc;
+
+	name += 7;				/* skip "kprobe/" */
+	snprintf(buf, sizeof(buf), "p:%s %s\n", name, name);
+
+	/*
+	 * Register the kprobe with the tracing subsystem.  This will create
+	 * a tracepoint event.
+	 */
+	fd = open(KPROBE_EVENTS, O_WRONLY | O_APPEND);
+	if (fd < 0) {
+		perror(KPROBE_EVENTS);
+		return -1;
+	}
+	rc = write(fd, buf, strlen(buf));
+	if (rc < 0) {
+		perror(KPROBE_EVENTS);
+		close(fd);
+		return -1;
+	}
+	close(fd);
+
+	/*
+	 * Read the tracepoint event id for the kprobe we just registered.
+	 */
+	strcpy(efn, EVENTSFS);
+	strcat(efn, "kprobes/");
+	strcat(efn, name);
+	strcat(efn, "/id");
+
+	fd = open(efn, O_RDONLY);
+	if (fd < 0) {
+		perror(efn);
+		return -1;
+	}
+	rc = read(fd, buf, sizeof(buf));
+	if (rc < 0 || rc >= sizeof(buf)) {
+		perror(efn);
+		close(fd);
+		return -1;
+	}
+	close(fd);
+	buf[rc] = '\0';
+	event_id = atoi(buf);
+
+	/*
+	 * Attaching a BPF program (by file descriptor) to an event (by ID) is
+	 * a generic operation provided by the BPF interface code.
+	 */
+	return dt_bpf_attach(event_id, bpf_fd);
+}
+
+struct dt_provider	dt_fbt = {
+	.name		= "fbt",
+	.populate	= &fbt_populate,
+	.resolve_event	= &fbt_resolve_event,
+	.attach		= &fbt_attach,
+};
diff --git a/tools/dtrace/dt_hash.c b/tools/dtrace/dt_hash.c
new file mode 100644
index 000000000000..b1f563bc0773
--- /dev/null
+++ b/tools/dtrace/dt_hash.c
@@ -0,0 +1,211 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * This file provides a generic hashtable implementation for probes.
+ *
+ * The hashtable is created with 4 user-provided functions:
+ *	hval(probe)		- calculate a hash value for the given probe
+ *	cmp(probe1, probe2)	- compare two probes
+ *	add(head, probe)	- add a probe to a list of probes
+ *	del(head, probe)	- delete a probe from a list of probes
+ *
+ * Probes are hashed into a hashtable slot based on the return value of
+ * hval(probe).  Each hashtable slot holds a list of buckets, with each
+ * bucket storing probes that are equal under the cmp(probe1, probe2)
+ * function. Probes are added to the list of probes in a bucket using the
+ * add(head, probe) function, and they are deleted using a call to the
+ * del(head, probe) function.
+ *
+ * Copyright (c) 2019, Oracle and/or its affiliates. All rights reserved.
+ */
+#include <errno.h>
+#include <stdint.h>
+#include <stdlib.h>
+
+#include "dtrace_impl.h"
+
+/*
+ * Hashtable implementation for probes.
+ */
+struct dt_hbucket {
+	u32			hval;
+	struct dt_hbucket	*next;
+	struct dt_probe		*head;
+	int			nprobes;
+};
+
+struct dt_htab {
+	struct dt_hbucket	**tab;
+	int			size;
+	int			mask;
+	int			nbuckets;
+	dt_hval_fn		hval;		/* calculate hash value */
+	dt_cmp_fn		cmp;		/* compare 2 probes */
+	dt_add_fn		add;		/* add probe to list */
+	dt_del_fn		del;		/* delete probe from list */
+};
+
+/*
+ * Create a new (empty) hashtable.
+ */
+struct dt_htab *dt_htab_new(dt_hval_fn hval, dt_cmp_fn cmp, dt_add_fn add,
+			    dt_del_fn del)
+{
+	struct dt_htab	*htab = malloc(sizeof(struct dt_htab));
+
+	if (!htab)
+		return NULL;
+
+	htab->size = 1;
+	htab->mask = htab->size - 1;
+	htab->nbuckets = 0;
+	htab->hval = hval;
+	htab->cmp = cmp;
+	htab->add = add;
+	htab->del = del;
+
+	htab->tab = calloc(htab->size, sizeof(struct dt_hbucket *));
+	if (!htab->tab) {
+		free(htab);
+		return NULL;
+	}
+
+	return htab;
+}
+
+/*
+ * Resize the hashtable by doubling the number of slots.
+ */
+static int resize(struct dt_htab *htab)
+{
+	int			i;
+	int			osize = htab->size;
+	int			nsize = osize << 1;
+	int			nmask = nsize - 1;
+	struct dt_hbucket	**ntab;
+
+	ntab = calloc(nsize, sizeof(struct dt_hbucket *));
+	if (!ntab)
+		return -ENOMEM;
+
+	for (i = 0; i < osize; i++) {
+		struct dt_hbucket	*bucket, *next;
+
+		for (bucket = htab->tab[i]; bucket; bucket = next) {
+			int	idx	= bucket->hval & nmask;
+
+			next = bucket->next;
+			bucket->next = ntab[idx];
+			ntab[idx] = bucket;
+		}
+	}
+
+	free(htab->tab);
+	htab->tab = ntab;
+	htab->size = nsize;
+	htab->mask = nmask;
+
+	return 0;
+}
+
+/*
+ * Add a probe to the hashtable.  Resize if necessary, and allocate a new
+ * bucket if necessary.
+ */
+int dt_htab_add(struct dt_htab *htab, struct dt_probe *probe)
+{
+	u32			hval = htab->hval(probe);
+	int			idx;
+	struct dt_hbucket	*bucket;
+
+retry:
+	idx = hval & htab->mask;
+	for (bucket = htab->tab[idx]; bucket; bucket = bucket->next) {
+		if (htab->cmp(bucket->head, probe) == 0)
+			goto add;
+	}
+
+	if ((htab->nbuckets >> 1) > htab->size) {
+		int	err;
+
+		err = resize(htab);
+		if (err)
+			return err;
+
+		goto retry;
+	}
+
+	bucket = malloc(sizeof(struct dt_hbucket));
+	if (!bucket)
+		return -ENOMEM;
+
+	bucket->hval = hval;
+	bucket->next = htab->tab[idx];
+	bucket->head = NULL;
+	bucket->nprobes = 0;
+	htab->tab[idx] = bucket;
+	htab->nbuckets++;
+
+add:
+	bucket->head = htab->add(bucket->head, probe);
+	bucket->nprobes++;
+
+	return 0;
+}
+
+/*
+ * Find a probe in the hashtable.
+ */
+struct dt_probe *dt_htab_lookup(const struct dt_htab *htab,
+				const struct dt_probe *probe)
+{
+	u32			hval = htab->hval(probe);
+	int			idx = hval & htab->mask;
+	struct dt_hbucket	*bucket;
+
+	for (bucket = htab->tab[idx]; bucket; bucket = bucket->next) {
+		if (htab->cmp(bucket->head, probe) == 0)
+			return bucket->head;
+	}
+
+	return NULL;
+}
+
+/*
+ * Remove a probe from the hashtable.  If we are deleting the last probe in a
+ * bucket, get rid of the bucket.
+ */
+int dt_htab_del(struct dt_htab *htab, struct dt_probe *probe)
+{
+	u32			hval = htab->hval(probe);
+	int			idx = hval & htab->mask;
+	struct dt_hbucket	*bucket;
+	struct dt_probe		*head;
+
+	for (bucket = htab->tab[idx]; bucket; bucket = bucket->next) {
+		if (htab->cmp(bucket->head, probe) == 0)
+			break;
+	}
+
+	if (bucket == NULL)
+		return -ENOENT;
+
+	head = htab->del(bucket->head, probe);
+	if (!head) {
+		struct dt_hbucket	*b = htab->tab[idx];
+
+		if (bucket == b)
+			htab->tab[idx] = bucket->next;
+		else {
+			while (b->next != bucket)
+				b = b->next;
+
+			b->next = bucket->next;
+		}
+
+		htab->nbuckets--;
+		free(bucket);
+	} else
+		bucket->head = head;
+
+	return 0;
+}
diff --git a/tools/dtrace/dt_probe.c b/tools/dtrace/dt_probe.c
new file mode 100644
index 000000000000..0b6228eaff29
--- /dev/null
+++ b/tools/dtrace/dt_probe.c
@@ -0,0 +1,230 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * This file implements the interface to probes grouped by provider.
+ *
+ * Probes are named by a set of 4 identifiers:
+ *	- provider name
+ *	- module name
+ *	- function name
+ *	- probe name
+ *
+ * The Fully Qualified Name (FQN) is "provider:module:function:name".
+ *
+ * Copyright (c) 2019, Oracle and/or its affiliates. All rights reserved.
+ */
+#include <errno.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <linux/bpf.h>
+#include <linux/kernel.h>
+
+#include "dtrace_impl.h"
+
+static struct dt_provider      *dt_providers[] = {
+							&dt_fbt,
+							&dt_syscall,
+						 };
+
+static struct dt_htab	*ht_byfqn;
+
+static u32		next_probe_id;
+
+/*
+ * Calculate a hash value based on a given string and an initial value.  The
+ * initial value is used to calculate compound hash values, e.g.
+ *
+ *	u32	hval;
+ *
+ *	hval = str2hval(str1, 0);
+ *	hval = str2hval(str2, hval);
+ */
+static u32 str2hval(const char *p, u32 hval)
+{
+	u32	g;
+
+	if (!p)
+		return hval;
+
+	while (*p) {
+		hval = (hval << 4) + *p++;
+		g = hval & 0xf0000000;
+		if (g != 0)
+			hval ^= g >> 24;
+
+		hval &= ~g;
+	}
+
+	return hval;
+}
+
+/*
+ * String compare function that can handle either or both strings being NULL.
+ */
+static int safe_strcmp(const char *p, const char *q)
+{
+	return (!p) ? (!q) ? 0
+			   : -1
+		    : (!q) ? 1
+			   : strcmp(p, q);
+}
+
+/*
+ * Calculate the hash value of a probe as the cummulative hash value of the
+ * FQN.
+ */
+static u32 fqn_hval(const struct dt_probe *probe)
+{
+	u32	hval = 0;
+
+	hval = str2hval(probe->prv_name, hval);
+	hval = str2hval(":", hval);
+	hval = str2hval(probe->mod_name, hval);
+	hval = str2hval(":", hval);
+	hval = str2hval(probe->fun_name, hval);
+	hval = str2hval(":", hval);
+	hval = str2hval(probe->prb_name, hval);
+
+	return hval;
+}
+
+/*
+ * Compare two probes based on the FQN.
+ */
+static int fqn_cmp(const struct dt_probe *p, const struct dt_probe *q)
+{
+	int	rc;
+
+	rc = safe_strcmp(p->prv_name, q->prv_name);
+	if (rc)
+		return rc;
+	rc = safe_strcmp(p->mod_name, q->mod_name);
+	if (rc)
+		return rc;
+	rc = safe_strcmp(p->fun_name, q->fun_name);
+	if (rc)
+		return rc;
+	rc = safe_strcmp(p->prb_name, q->prb_name);
+	if (rc)
+		return rc;
+
+	return 0;
+}
+
+/*
+ * Add the given probe 'new' to the double-linked probe list 'head'.  Probe
+ * 'new' becomes the new list head.
+ */
+static struct dt_probe *fqn_add(struct dt_probe *head, struct dt_probe *new)
+{
+	if (!head)
+		return new;
+
+	new->he_fqn.next = head;
+	head->he_fqn.prev = new;
+
+	return new;
+}
+
+/*
+ * Remove the given probe 'probe' from the double-linked probe list 'head'.
+ * If we are deleting the current head, the next probe in the list is returned
+ * as the new head.  If that value is NULL, the list is now empty.
+ */
+static struct dt_probe *fqn_del(struct dt_probe *head, struct dt_probe *probe)
+{
+	if (head == probe) {
+		if (!probe->he_fqn.next)
+			return NULL;
+
+		head = probe->he_fqn.next;
+		head->he_fqn.prev = NULL;
+		probe->he_fqn.next = NULL;
+
+		return head;
+	}
+
+	if (!probe->he_fqn.next) {
+		probe->he_fqn.prev->he_fqn.next = NULL;
+		probe->he_fqn.prev = NULL;
+
+		return head;
+	}
+
+	probe->he_fqn.prev->he_fqn.next = probe->he_fqn.next;
+	probe->he_fqn.next->he_fqn.prev = probe->he_fqn.prev;
+	probe->he_fqn.prev = probe->he_fqn.next = NULL;
+
+	return head;
+}
+
+/*
+ * Initialize the probe handling by populating the FQN hashtable with probes
+ * from all providers.
+ */
+int dt_probe_init(void)
+{
+	int	i;
+
+	ht_byfqn = dt_htab_new(fqn_hval, fqn_cmp, fqn_add, fqn_del);
+
+	for (i = 0; i < ARRAY_SIZE(dt_providers); i++) {
+		if (dt_providers[i]->populate() < 0)
+			return -1;
+	}
+
+	return 0;
+}
+
+/*
+ * Allocate a new probe and add it to the FQN hashtable.
+ */
+int dt_probe_new(const struct dt_provider *prov, const char *pname,
+		 const char *mname, const char *fname, const char *name)
+{
+	struct dt_probe	*probe;
+
+	probe = malloc(sizeof(struct dt_probe));
+	if (!probe)
+		return -ENOMEM;
+
+	memset(probe, 0, sizeof(struct dt_probe));
+	probe->id = next_probe_id++;
+	probe->prov = prov;
+	probe->prv_name = pname ? strdup(pname) : NULL;
+	probe->mod_name = mname ? strdup(mname) : NULL;
+	probe->fun_name = fname ? strdup(fname) : NULL;
+	probe->prb_name = name ? strdup(name) : NULL;
+
+	dt_htab_add(ht_byfqn, probe);
+
+	return 0;
+}
+
+/*
+ * Perform a probe lookup based on FQN.
+ */
+struct dt_probe *dt_probe_by_name(const struct dt_probe *tmpl)
+{
+	return dt_htab_lookup(ht_byfqn, tmpl);
+}
+
+/*
+ * Resolve an event name (BPF ELF section name) into a probe.  We query each
+ * provider, and as soon as we get a hit, we return the result.
+ */
+struct dt_probe *dt_probe_resolve_event(const char *name)
+{
+	int		i;
+	struct dt_probe	*probe;
+
+	for (i = 0; i < ARRAY_SIZE(dt_providers); i++) {
+		if (!dt_providers[i]->resolve_event)
+			continue;
+		probe = dt_providers[i]->resolve_event(name);
+		if (probe)
+			return probe;
+	}
+
+	return NULL;
+}
diff --git a/tools/dtrace/dt_syscall.c b/tools/dtrace/dt_syscall.c
new file mode 100644
index 000000000000..6695a4a1c701
--- /dev/null
+++ b/tools/dtrace/dt_syscall.c
@@ -0,0 +1,179 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * The syscall provider for DTrace.
+ *
+ * System call probes are exposed by the kernel as tracepoint events in the
+ * "syscalls" group.  Entry probe names start with "sys_enter_" and exit probes
+ * start with "sys_exit_".
+ *
+ * Mapping from event name to DTrace probe name:
+ *
+ *	syscalls:sys_enter_<name>		syscall:vmlinux:<name>:entry
+ *	syscalls:sys_exit_<name>		syscall:vmlinux:<name>:return
+ *
+ * Mapping from BPF section name to DTrace probe name:
+ *
+ *	tracepoint/syscalls/sys_enter_<name>	syscall:vmlinux:<name>:entry
+ *	tracepoint/syscalls/sys_exit_<name>	syscall:vmlinux:<name>:return
+ *
+ * Copyright (c) 2019, Oracle and/or its affiliates. All rights reserved.
+ */
+#include <ctype.h>
+#include <fcntl.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <linux/bpf.h>
+#include <sys/stat.h>
+#include <sys/types.h>
+
+#include "dtrace_impl.h"
+
+static const char	provname[] = "syscall";
+static const char	modname[] = "vmlinux";
+
+#define PROBE_LIST	TRACEFS "available_events"
+
+#define PROV_PREFIX	"syscalls:"
+#define ENTRY_PREFIX	"sys_enter_"
+#define EXIT_PREFIX	"sys_exit_"
+
+/*
+ * Scan the PROBE_LIST file and add probes for any syscalls events.
+ */
+static int syscall_populate(void)
+{
+	FILE			*f;
+	char			buf[256];
+
+	f = fopen(PROBE_LIST, "r");
+	if (f == NULL)
+		return -1;
+
+	while (fgets(buf, sizeof(buf), f)) {
+		char	*p;
+
+		/* * Here buf is "group:event".  */
+		p = strchr(buf, '\n');
+		if (p)
+			*p = '\0';
+		else {
+			/*
+			 * If we didn't see a newline, the line was too long.
+			 * Report it, and continue until the end of the line.
+			 */
+			fprintf(stderr, "%s: Line too long: %s\n",
+				PROBE_LIST, buf);
+			do
+				fgets(buf, sizeof(buf), f);
+			while (strchr(buf, '\n') == NULL);
+			continue;
+		}
+
+		/* We need "group:" to match "syscalls:". */
+		p = buf;
+		if (memcmp(p, PROV_PREFIX, sizeof(PROV_PREFIX) - 1) != 0)
+			continue;
+
+		p += sizeof(PROV_PREFIX) - 1;
+		/*
+		 * Now p will be just "event", and we are only interested in
+		 * events that match "sys_enter_*" or "sys_exit_*".
+		 */
+		if (!memcmp(p, ENTRY_PREFIX, sizeof(ENTRY_PREFIX) - 1)) {
+			p += sizeof(ENTRY_PREFIX) - 1;
+			dt_probe_new(&dt_syscall, provname, modname, p,
+				     "entry");
+		} else if (!memcmp(p, EXIT_PREFIX, sizeof(EXIT_PREFIX) - 1)) {
+			p += sizeof(EXIT_PREFIX) - 1;
+			dt_probe_new(&dt_syscall, provname, modname, p,
+				     "return");
+		}
+	}
+
+	fclose(f);
+
+	return 0;
+}
+
+#define EVENT_PREFIX	"tracepoint/syscalls/"
+
+/*
+ * Perform a probe lookup based on an event name (BPF ELF section name).
+ */
+static struct dt_probe *systrace_resolve_event(const char *name)
+{
+	const char	*prbname;
+	struct dt_probe	tmpl;
+	struct dt_probe	*probe;
+
+	if (!name)
+		return NULL;
+
+	/* Exclude anything that is not a syscalls tracepoint */
+	if (strncmp(name, EVENT_PREFIX, sizeof(EVENT_PREFIX) - 1) != 0)
+		return NULL;
+	name += sizeof(EVENT_PREFIX) - 1;
+
+	if (strncmp(name, ENTRY_PREFIX, sizeof(ENTRY_PREFIX) - 1) == 0) {
+		name += sizeof(ENTRY_PREFIX) - 1;
+		prbname = "entry";
+	} else if (strncmp(name, EXIT_PREFIX, sizeof(EXIT_PREFIX) - 1) == 0) {
+		name += sizeof(EXIT_PREFIX) - 1;
+		prbname = "return";
+	} else
+		return NULL;
+
+	memset(&tmpl, 0, sizeof(tmpl));
+	tmpl.prv_name = provname;
+	tmpl.mod_name = modname;
+	tmpl.fun_name = name;
+	tmpl.prb_name = prbname;
+
+	probe = dt_probe_by_name(&tmpl);
+
+	return probe;
+}
+
+#define SYSCALLSFS	EVENTSFS "syscalls/"
+
+/*
+ * Attach the given BPF program (identified by its file descriptor) to the
+ * event identified by the given section name.
+ */
+static int syscall_attach(const char *name, int bpf_fd)
+{
+	char    efn[256];
+	char    buf[256];
+	int	event_id, fd, rc;
+
+	name += sizeof(EVENT_PREFIX) - 1;
+	strcpy(efn, SYSCALLSFS);
+	strcat(efn, name);
+	strcat(efn, "/id");
+
+	fd = open(efn, O_RDONLY);
+	if (fd < 0) {
+		perror(efn);
+		return -1;
+	}
+	rc = read(fd, buf, sizeof(buf));
+	if (rc < 0 || rc >= sizeof(buf)) {
+		perror(efn);
+		close(fd);
+		return -1;
+	}
+	close(fd);
+	buf[rc] = '\0';
+	event_id = atoi(buf);
+
+	return dt_bpf_attach(event_id, bpf_fd);
+}
+
+struct dt_provider	dt_syscall = {
+	.name		= "syscall",
+	.populate	= &syscall_populate,
+	.resolve_event	= &systrace_resolve_event,
+	.attach		= &syscall_attach,
+};
diff --git a/tools/dtrace/dt_utils.c b/tools/dtrace/dt_utils.c
new file mode 100644
index 000000000000..55d51bae1d97
--- /dev/null
+++ b/tools/dtrace/dt_utils.c
@@ -0,0 +1,132 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2019, Oracle and/or its affiliates. All rights reserved.
+ */
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+
+#include "dtrace_impl.h"
+
+#define BUF_SIZE	1024		/* max size for online cpu data */
+
+int	dt_numcpus;			/* number of online CPUs */
+int	dt_maxcpuid;			/* highest CPU id */
+int	*dt_cpuids;			/* list of CPU ids */
+
+/*
+ * Populate the online CPU id information from sysfs data.  We only do this
+ * once because we do not care about CPUs coming online after we started
+ * tracing.  If a CPU goes offline during tracing, we do not care either
+ * because that simply means that it won't be writing any new probe data into
+ * its buffer.
+ */
+void cpu_list_populate(void)
+{
+	char buf[BUF_SIZE];
+	int fd, cnt, start, end, i;
+	int *cpu;
+	char *p, *q;
+
+	fd = open("/sys/devices/system/cpu/online", O_RDONLY);
+	if (fd < 0)
+		goto fail;
+	cnt = read(fd, buf, sizeof(buf));
+	close(fd);
+	if (cnt <= 0)
+		goto fail;
+
+	/*
+	 * The string should always end with a newline, but let's make sure.
+	 */
+	if (buf[cnt - 1] == '\n')
+		buf[--cnt] = 0;
+
+	/*
+	 * Count how many CPUs we have.
+	 */
+	dt_numcpus = 0;
+	p = buf;
+	do {
+		start = (int)strtol(p, &q, 10);
+		switch (*q) {
+		case '-':		/* range */
+			p = q + 1;
+			end = (int)strtol(p, &q, 10);
+			dt_numcpus += end - start + 1;
+			if (*q == 0) {	/* end of string */
+				p = q;
+				break;
+			}
+			if (*q != ',')
+				goto fail;
+			p = q + 1;
+			break;
+		case 0:			/* end of string */
+			dt_numcpus++;
+			p = q;
+			break;
+		case ',':	/* gap  */
+			dt_numcpus++;
+			p = q + 1;
+			break;
+		}
+	} while (*p != 0);
+
+	dt_cpuids = calloc(dt_numcpus,  sizeof(int));
+	cpu = dt_cpuids;
+
+	/*
+	 * Fill in the CPU ids.
+	 */
+	p = buf;
+	do {
+		start = (int)strtol(p, &q, 10);
+		switch (*q) {
+		case '-':		/* range */
+			p = q + 1;
+			end = (int)strtol(p, &q, 10);
+			for (i = start; i <= end; i++)
+				*cpu++ = i;
+			if (*q == 0) {	/* end of string */
+				p = q;
+				break;
+			}
+			if (*q != ',')
+				goto fail;
+			p = q + 1;
+			break;
+		case 0:			/* end of string */
+			*cpu = start;
+			p = q;
+			break;
+		case ',':	/* gap  */
+			*cpu++ = start;
+			p = q + 1;
+			break;
+		}
+	} while (*p != 0);
+
+	/* Record the highest CPU id of the set of online CPUs. */
+	dt_maxcpuid = *(cpu - 1);
+
+	return;
+fail:
+	if (dt_cpuids)
+		free(dt_cpuids);
+
+	dt_numcpus = 0;
+	dt_maxcpuid = 0;
+	dt_cpuids = NULL;
+}
+
+void cpu_list_free(void)
+{
+	free(dt_cpuids);
+	dt_numcpus = 0;
+	dt_maxcpuid = 0;
+	dt_cpuids = NULL;
+}
diff --git a/tools/dtrace/dtrace.c b/tools/dtrace/dtrace.c
new file mode 100644
index 000000000000..36ad526c1cd4
--- /dev/null
+++ b/tools/dtrace/dtrace.c
@@ -0,0 +1,249 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2019, Oracle and/or its affiliates. All rights reserved.
+ */
+#include <errno.h>
+#include <libgen.h>
+#include <stdarg.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <linux/log2.h>
+
+#include "dtrace_impl.h"
+
+#define DTRACE_BUFSIZE	32		/* default buffer size (in pages) */
+
+#define DMODE_VERS	0		/* display version information (-V) */
+#define DMODE_LIST	1		/* list probes (-l) */
+#define DMODE_EXEC	2		/* compile program and start tracing */
+
+#define E_SUCCESS	0
+#define E_ERROR		1
+#define E_USAGE		2
+
+#define NUM_PAGES(sz)	(((sz) + getpagesize() - 1) / getpagesize())
+
+static const char		*dtrace_options = "+b:ls:V";
+
+static char			*g_pname;
+static int			g_mode = DMODE_EXEC;
+
+static int usage(void)
+{
+	fprintf(stderr, "Usage: %s [-lV] [-b bufsz] -s script\n", g_pname);
+	fprintf(stderr,
+	"\t-b  set trace buffer size\n"
+	"\t-l  list probes matching specified criteria\n"
+	"\t-s  enable or list probes for the specified BPF program\n"
+	"\t-V  report DTrace API version\n");
+
+	return E_USAGE;
+}
+
+static u64 parse_size(const char *arg)
+{
+	long long	mul = 1;
+	long long	neg, val;
+	size_t		len;
+	char		*end;
+
+	if (!arg)
+		return -1;
+
+	len = strlen(arg);
+	if (!len)
+		return -1;
+
+	switch (arg[len - 1]) {
+	case 't':
+	case 'T':
+		mul *= 1024;
+		/* fall-through */
+	case 'g':
+	case 'G':
+		mul *= 1024;
+		/* fall-through */
+	case 'm':
+	case 'M':
+		mul *= 1024;
+		/* fall-through */
+	case 'k':
+	case 'K':
+		mul *= 1024;
+		/* fall-through */
+	default:
+		break;
+	}
+
+	neg = strtoll(arg, NULL, 0);
+	errno = 0;
+	val = strtoull(arg, &end, 0) * mul;
+
+	if ((mul > 1 && end != &arg[len - 1]) || (mul == 1 && *end != '\0') ||
+	    val < 0 || neg < 0 || errno != 0)
+		return -1;
+
+	return val;
+}
+
+int main(int argc, char *argv[])
+{
+	int	i;
+	int	modec = 0;
+	int	bufsize = DTRACE_BUFSIZE;
+	int	epoll_fd;
+	int	cnt;
+	char	**prgv;
+	int	prgc;
+
+	g_pname = basename(argv[0]);
+
+	if (argc == 1)
+		return usage();
+
+	prgc = 0;
+	prgv = calloc(argc, sizeof(char *));
+	if (!prgv) {
+		fprintf(stderr, "failed to allocate memory for arguments: %s\n",
+			strerror(errno));
+		return E_ERROR;
+	}
+
+	argv[0] = g_pname;			/* argv[0] for getopt errors */
+
+	for (optind = 1; optind < argc; optind++) {
+		int	opt;
+
+		while ((opt = getopt(argc, argv, dtrace_options)) != EOF) {
+			u64			val;
+
+			switch (opt) {
+			case 'b':
+				val = parse_size(optarg);
+				if (val < 0) {
+					fprintf(stderr, "invalid: -b %s\n",
+						optarg);
+					return E_ERROR;
+				}
+
+				/*
+				 * Bufsize needs to be a number of pages, and
+				 * must be a power of 2.  This is required by
+				 * the perf event buffer code.
+				 */
+				bufsize = roundup_pow_of_two(NUM_PAGES(val));
+				if ((u64)bufsize * getpagesize() > val)
+					fprintf(stderr,
+						"bufsize increased to %ld\n",
+						(u64)bufsize * getpagesize());
+
+				break;
+			case 'l':
+				g_mode = DMODE_LIST;
+				modec++;
+				break;
+			case 's':
+				prgv[prgc++] = optarg;
+				break;
+			case 'V':
+				g_mode = DMODE_VERS;
+				modec++;
+				break;
+			default:
+				if (strchr(dtrace_options, opt) == NULL)
+					return usage();
+			}
+		}
+
+		if (optind < argc) {
+			fprintf(stderr, "unknown option '%s'\n", argv[optind]);
+			return E_ERROR;
+		}
+	}
+
+	if (modec > 1) {
+		fprintf(stderr,
+			"only one of [-lV] can be specified at a time\n");
+		return E_USAGE;
+	}
+
+	/*
+	 * We handle requests for version information first because we do not
+	 * need probe information for it.
+	 */
+	if (g_mode == DMODE_VERS) {
+		printf("%s\n"
+		       "This is DTrace %s\n"
+		       "dtrace(1) version-control ID: %s\n",
+		       DT_VERS_STRING, DT_VERSION, DT_GIT_VERSION);
+
+		return E_SUCCESS;
+	}
+
+	/* Initialize probes. */
+	if (dt_probe_init() < 0) {
+		fprintf(stderr, "failed to initialize probes: %s\n",
+			strerror(errno));
+		return E_ERROR;
+	}
+
+	/*
+	 * We handle requests to list probes next.
+	 */
+	if (g_mode == DMODE_LIST) {
+		int	rc = 0;
+
+		printf("%5s %10s %17s %33s %s\n",
+		       "ID", "PROVIDER", "MODULE", "FUNCTION", "NAME");
+		for (i = 0; i < prgc; i++) {
+			rc = dt_bpf_list_probes(prgv[i]);
+			if (rc < 0)
+				fprintf(stderr, "failed to load %s: %s\n",
+					prgv[i], strerror(errno));
+		}
+
+		return rc ? E_ERROR : E_SUCCESS;
+	}
+
+	if (!prgc) {
+		fprintf(stderr, "missing BPF program(s)\n");
+		return E_ERROR;
+	}
+
+	/* Process the BPF program. */
+	for (i = 0; i < prgc; i++) {
+		int	err;
+
+		err = dt_bpf_load_file(prgv[i]);
+		if (err) {
+			errno = -err;
+			fprintf(stderr, "failed to load %s: %s\n",
+				prgv[i], strerror(errno));
+			return E_ERROR;
+		}
+	}
+
+	/* Get the list of online CPUs. */
+	cpu_list_populate();
+
+	/* Initialize buffers. */
+	epoll_fd = dt_buffer_init(bufsize);
+	if (epoll_fd < 0) {
+		errno = -epoll_fd;
+		fprintf(stderr, "failed to allocate buffers: %s\n",
+			strerror(errno));
+		return E_ERROR;
+	}
+
+	/* Process probe data. */
+	printf("%3s %6s\n", "CPU", "ID");
+	do {
+		cnt = dt_buffer_poll(epoll_fd, 100);
+	} while (cnt >= 0);
+
+	dt_buffer_exit(epoll_fd);
+
+	return E_SUCCESS;
+}
diff --git a/tools/dtrace/dtrace.h b/tools/dtrace/dtrace.h
new file mode 100644
index 000000000000..c79398432d17
--- /dev/null
+++ b/tools/dtrace/dtrace.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/*
+ * Copyright (c) 2019, Oracle and/or its affiliates. All rights reserved.
+ */
+#ifndef _UAPI_LINUX_DTRACE_H
+#define _UAPI_LINUX_DTRACE_H
+
+struct dt_bpf_context {
+	u32		probe_id;
+	u64		argv[10];
+};
+
+#endif /* _UAPI_LINUX_DTRACE_H */
diff --git a/tools/dtrace/dtrace_impl.h b/tools/dtrace/dtrace_impl.h
new file mode 100644
index 000000000000..9aa51b4c4aee
--- /dev/null
+++ b/tools/dtrace/dtrace_impl.h
@@ -0,0 +1,101 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2019, Oracle and/or its affiliates. All rights reserved.
+ */
+#ifndef _DTRACE_H
+#define _DTRACE_H
+
+#include <unistd.h>
+#include <bpf/libbpf.h>
+#include <linux/types.h>
+#include <linux/ptrace.h>
+#include <linux/perf_event.h>
+#include <sys/syscall.h>
+
+#include "dtrace.h"
+
+#define DT_DEBUG
+
+#define DT_VERS_STRING	"Oracle D 2.0.0"
+
+#define TRACEFS		"/sys/kernel/debug/tracing/"
+#define EVENTSFS	TRACEFS "events/"
+
+extern int	dt_numcpus;
+extern int	dt_maxcpuid;
+extern int	*dt_cpuids;
+
+extern void cpu_list_populate(void);
+extern void cpu_list_free(void);
+
+struct dt_provider {
+	char		*name;
+	int		(*populate)(void);
+	struct dt_probe *(*resolve_event)(const char *name);
+	int		(*attach)(const char *name, int bpf_fd);
+};
+
+extern struct dt_provider	dt_fbt;
+extern struct dt_provider	dt_syscall;
+
+struct dt_hentry {
+	struct dt_probe		*next;
+	struct dt_probe		*prev;
+};
+
+struct dt_htab;
+
+typedef u32 (*dt_hval_fn)(const struct dt_probe *);
+typedef int (*dt_cmp_fn)(const struct dt_probe *, const struct dt_probe *);
+typedef struct dt_probe *(*dt_add_fn)(struct dt_probe *, struct dt_probe *);
+typedef struct dt_probe *(*dt_del_fn)(struct dt_probe *, struct dt_probe *);
+
+extern struct dt_htab *dt_htab_new(dt_hval_fn hval, dt_cmp_fn cmp,
+				   dt_add_fn add, dt_del_fn del);
+extern int dt_htab_add(struct dt_htab *htab, struct dt_probe *probe);
+extern struct dt_probe *dt_htab_lookup(const struct dt_htab *htab,
+				       const struct dt_probe *probe);
+extern int dt_htab_del(struct dt_htab *htab, struct dt_probe *probe);
+
+struct dt_probe {
+	u32				id;
+	int				event_fd;
+	const struct dt_provider	*prov;
+	const char			*prv_name;	/* provider name */
+	const char			*mod_name;	/* module name */
+	const char			*fun_name;	/* function name */
+	const char			*prb_name;	/* probe name */
+	struct dt_hentry		he_fqn;
+};
+
+typedef void (*dt_probe_fn)(const struct dt_probe *probe);
+
+extern int dt_probe_init(void);
+extern int dt_probe_new(const struct dt_provider *prov, const char *pname,
+			const char *mname, const char *fname, const char *name);
+extern struct dt_probe *dt_probe_by_name(const struct dt_probe *tmpl);
+extern struct dt_probe *dt_probe_resolve_event(const char *name);
+
+extern int dt_bpf_list_probes(const char *fn);
+extern int dt_bpf_load_file(const char *fn);
+extern int dt_bpf_map_update(int fd, const void *key, const void *val);
+extern int dt_bpf_attach(int event_id, int bpf_fd);
+
+extern int dt_bufmap_fd;
+
+extern int dt_buffer_init(int num_pages);
+extern int dt_buffer_poll(int epoll_fd, int timeout);
+extern void dt_buffer_exit(int epoll_fd);
+
+static inline int perf_event_open(struct perf_event_attr *attr, pid_t pid,
+				  int cpu, int group_fd, unsigned long flags)
+{
+	return syscall(__NR_perf_event_open, attr, pid, cpu, group_fd, flags);
+}
+
+extern inline int bpf(enum bpf_cmd cmd, union bpf_attr *attr)
+{
+	return syscall(__NR_bpf, cmd, attr, sizeof(union bpf_attr));
+}
+
+#endif /* _DTRACE_H */
-- 
2.20.1

