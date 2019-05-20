Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC9B244C0
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 01:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727635AbfETXwV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 19:52:21 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:46454 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726619AbfETXwU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 19:52:20 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4KNiPp8157487;
        Mon, 20 May 2019 23:51:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id :
 mime-version : date : from : to : cc : subject : content-type :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=SeVzkAPYFDZrgG3UBssOmwbIoZpjwRrM3RxdQMTyWsM=;
 b=Q5yLCCxTlSJsgnvoO7+bHqd90GnXJmWvjCZq6w2sIrkCV9mvCIjNlDjkADMMgbo86HCz
 vzelLPHe1JMVXXJpifs+o0SoCIgTPAyIkRFKxSPXLuTgbmP+O26Zb1bzBhFmPO4LvYMj
 Zr2wT4VNZD8oWDrRy6eQbpK50Bw9Y0ugAbSS/0rYG8PHHYcXflxG7exaXfyp7aWzIGDE
 crJY6uFOsXYbSRXAglSxDSw8GE1vdX2kDCDNyUaw74O2FxxfWRxpSX6eVyx+cF78ZfRY
 quHmlnTTBZc3nmC5lqH8KnUQbEjjU0Mz86yj8ItDrDRxk4WCWj5cXt2C011YXxbD/PiQ LA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2sj9fta37m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 May 2019 23:51:41 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4KNpcUG188099;
        Mon, 20 May 2019 23:51:40 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 2sks1xvkfq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 20 May 2019 23:51:40 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x4KNpehM188128;
        Mon, 20 May 2019 23:51:40 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2sks1xvkfj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 May 2019 23:51:40 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x4KNpcKQ024996;
        Mon, 20 May 2019 23:51:39 GMT
Message-Id: <201905202351.x4KNpcKQ024996@userv0121.oracle.com>
Received: from localhost (/10.159.211.99) by default (Oracle Beehive Gateway
 v4.0) with ESMTP ; Mon, 20 May 2019 23:51:37 +0000
MIME-Version: 1.0
Date:   Mon, 20 May 2019 23:51:38 +0000 (UTC)
From:   Kris Van Hees <kris.van.hees@oracle.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        dtrace-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Cc:     rostedt@goodmis.org, mhiramat@kernel.org, acme@kernel.org,
        ast@kernel.org, daniel@iogearbox.net
Subject: [RFC PATCH 06/11] dtrace: tiny userspace tool to exercise DTrace
 support features
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9263 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=7 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905200146
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit provides a small tool that makes use of the following new
features in BPF, as a sample of how the DTrace userspace code will be
interacting with the kernel:

- It uses the ability to tail-call into a BPF program of a different
  type (as long as the proper context conversion is implemented).  This
  is used to attach a BPF kprobe program to a kprobe, and having it
  tail-call a BPF dtrace program.  We do this so the probe action can
  execute in a tracer specific context rather than in a probe context.
  This way, probes of different types can all execute the probe actions
  in the same probe-independent context.

- It uses the new bpf_finalize_context() helper to retrieve data that is
  set in the BPF kprobe program attached to the probe, and use that data
  to further populate the tracer context for the BPF dtrace program.

Output is generated using the bpf_perf_event_output() helper.  This tiny
proof of concept tool demonstrates that the tail-call mechanism into a
different BPF program type works correctly, and that it is possible to
create a new context that contains information that is currently not
available to BPF programs from either a context or by means of a helper
(aside from using bpf_probe_read() on an address that is derived from
the current task).

Signed-off-by: Kris Van Hees <kris.van.hees@oracle.com>
Reviewed-by: Nick Alcock <nick.alcock@oracle.com>
---
 MAINTAINERS               |   1 +
 tools/dtrace/.gitignore   |   1 +
 tools/dtrace/Makefile     |  79 ++++++++
 tools/dtrace/dt_bpf.c     |  15 ++
 tools/dtrace/dt_buffer.c  | 386 ++++++++++++++++++++++++++++++++++++++
 tools/dtrace/dt_utils.c   | 132 +++++++++++++
 tools/dtrace/dtrace.c     |  38 ++++
 tools/dtrace/dtrace.h     |  44 +++++
 tools/dtrace/probe1_bpf.c | 100 ++++++++++
 9 files changed, 796 insertions(+)
 create mode 100644 tools/dtrace/.gitignore
 create mode 100644 tools/dtrace/Makefile
 create mode 100644 tools/dtrace/dt_bpf.c
 create mode 100644 tools/dtrace/dt_buffer.c
 create mode 100644 tools/dtrace/dt_utils.c
 create mode 100644 tools/dtrace/dtrace.c
 create mode 100644 tools/dtrace/dtrace.h
 create mode 100644 tools/dtrace/probe1_bpf.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 07da7cc69f23..6d934c9f5f93 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5456,6 +5456,7 @@ L:	dtrace-devel@oss.oracle.com
 S:	Maintained
 F:	include/uapi/linux/dtrace.h
 F:	kernel/trace/dtrace
+F:	tools/dtrace
 
 DVB_USB_AF9015 MEDIA DRIVER
 M:	Antti Palosaari <crope@iki.fi>
diff --git a/tools/dtrace/.gitignore b/tools/dtrace/.gitignore
new file mode 100644
index 000000000000..d60e73526296
--- /dev/null
+++ b/tools/dtrace/.gitignore
@@ -0,0 +1 @@
+dtrace
diff --git a/tools/dtrace/Makefile b/tools/dtrace/Makefile
new file mode 100644
index 000000000000..c2ee3fb2576f
--- /dev/null
+++ b/tools/dtrace/Makefile
@@ -0,0 +1,79 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# This Makefile is shamelessly copied from samples/bpf and modified to support
+# building this prototype tracing tool.
+
+DTRACE_PATH		?= $(abspath $(srctree)/$(src))
+TOOLS_PATH		:= $(DTRACE_PATH)/..
+SAMPLES_PATH		:= $(DTRACE_PATH)/../../samples
+
+hostprogs-y		:= dtrace
+
+LIBBPF			:= $(TOOLS_PATH)/lib/bpf/libbpf.a
+OBJS			:= ../../samples/bpf/bpf_load.o dt_bpf.o dt_buffer.o dt_utils.o
+
+dtrace-objs		:= $(OBJS) dtrace.o
+
+always			:= $(hostprogs-y)
+always			+= probe1_bpf.o
+
+KBUILD_HOSTCFLAGS	+= -I$(srctree)/tools/lib
+KBUILD_HOSTCFLAGS	+= -I$(srctree)/tools/perf
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
diff --git a/tools/dtrace/dt_bpf.c b/tools/dtrace/dt_bpf.c
new file mode 100644
index 000000000000..7919fc070685
--- /dev/null
+++ b/tools/dtrace/dt_bpf.c
@@ -0,0 +1,15 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2019, Oracle and/or its affiliates. All rights reserved.
+ */
+#include <stdio.h>
+
+#include "dtrace.h"
+
+/*
+ * Load the given BPF ELF object file, and apply any necessary BPF map fixups.
+ */
+int dt_bpf_load_file(char *fn)
+{
+	return load_bpf_file_fixup_map(fn, dt_buffer_fixup_map);
+}
diff --git a/tools/dtrace/dt_buffer.c b/tools/dtrace/dt_buffer.c
new file mode 100644
index 000000000000..65c107ca8ac4
--- /dev/null
+++ b/tools/dtrace/dt_buffer.c
@@ -0,0 +1,386 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
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
+#include <linux/perf_event.h>
+
+#include "../../include/uapi/linux/dtrace.h"
+#include "dtrace.h"
+
+/*
+ * Probe data is recorded in per-CPU perf ring buffers.
+ */
+struct dtrace_buffer {
+	int	cpu;			/* ID of CPU that uses this buffer */
+	int	fd;			/* fd of perf output buffer */
+	size_t	page_size;		/* size of each page in buffer */
+	size_t	data_size;		/* total buffer size */
+	void	*base;			/* address of buffer */
+};
+
+static struct dtrace_buffer	*dt_buffers;
+
+/*
+ * File descriptor for the BPF map that holds the buffers for the online CPUs.
+ * The map is a bpf_array indexed by CPU id, and it stores a file descriptor as
+ * value (the fd for the perf_event that represents the CPU buffer).
+ */
+static int			bufmap_fd = -1;
+
+/*
+ * Create the BPF map (bpf_array) between the CPU id and the fd for the
+ * perf_event that owns the buffer for that CPU.  If the fd is 0 for a CPU id,
+ * that CPU is not particpating in the tracing session.
+ *
+ * BPF programs must use this definition of the map:
+ *
+ *	struct bpf_map_def SEC("maps") buffer_map = {
+ *		.type = BPF_MAP_TYPE_PERF_EVENT_ARRAY,
+ *		.key_size = sizeof(int),
+ *		.value_size = sizeof(u32),
+ *	};
+ *
+ * Maximum number of entries need not be specified because the map will not be
+ * created by loading the BPF program since it is being created here already.
+ */
+static int create_buffer_map(void)
+{
+	union bpf_attr	attr;
+
+	memset(&attr, 0, sizeof(attr));
+
+	attr.map_type = BPF_MAP_TYPE_PERF_EVENT_ARRAY;
+	memcpy(attr.map_name, "buffer_map", 11);
+	attr.key_size = sizeof(u32);
+	attr.value_size = sizeof(u32);
+	attr.max_entries = dt_maxcpuid;
+	attr.flags = 0;
+
+	return syscall(__NR_bpf, BPF_MAP_CREATE, &attr, sizeof(attr));
+}
+
+/*
+ * Store the (key, value) pair in the map referenced by the given fd.
+ */
+static int bpf_map_update_elem(int fd, const void *key, const void *value,
+			       u64 flags)
+{
+	union bpf_attr	attr;
+
+	memset(&attr, 0, sizeof(attr));
+
+	attr.map_fd = fd;
+	attr.key = (u64)(unsigned long)key;
+	attr.value = (u64)(unsigned long)value;
+	attr.flags = flags;
+
+	return syscall(__NR_bpf, BPF_MAP_UPDATE_ELEM, &attr, sizeof(attr));
+}
+
+/*
+ * Provide the fd of pre-created BPF maps that BPF programs refer to.
+ */
+void dt_buffer_fixup_map(struct bpf_map_data *map, int idx)
+{
+	if (!strcmp("buffer_map", map->name))
+		map->fd = bufmap_fd;
+}
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
+	 * buffers.
+	 */
+	attr.config = PERF_COUNT_SW_BPF_OUTPUT;
+	attr.type = PERF_TYPE_SOFTWARE;
+	attr.sample_type = PERF_SAMPLE_RAW;
+	attr.sample_period = 1;
+	attr.wakeup_events = 1;
+	pefd = syscall(__NR_perf_event_open, &attr, -1, buf->cpu, -1,
+		       PERF_FLAG_FD_CLOEXEC);
+	if (pefd < 0) {
+		fprintf(stderr, "perf_event_open(cpu %d): %s\n", buf->cpu,
+			strerror(errno));
+		goto fail;
+	}
+
+	buf->fd = pefd;
+	buf->base = mmap(NULL, buf->page_size + buf->data_size,
+			 PROT_READ | PROT_WRITE, MAP_SHARED, buf->fd, 0);
+	if (!buf->base)
+		goto fail;
+
+	if (ioctl(pefd, PERF_EVENT_IOC_ENABLE, 0) < 0) {
+		fprintf(stderr, "PERF_EVENT_IOC_ENABLE(cpu %d): %s\n",
+			buf->cpu, strerror(errno));
+		goto fail;
+	}
+
+	return 0;
+
+fail:
+	if (buf->base) {
+		munmap(buf->base, buf->page_size + buf->data_size);
+		buf->base = NULL;
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
+	/* Set up the buffer BPF map. */
+	bufmap_fd = create_buffer_map();
+	if (bufmap_fd < 0)
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
+		/*
+		 * We allocate a number of pages that is a power of 2, and add
+		 * one extra page as the reader page.
+		 */
+		buf->cpu = cpu;
+		buf->page_size = getpagesize();
+		buf->data_size = num_pages * buf->page_size;
+
+		/* Try to create the perf buffer for this DTrace buffer. */
+		if (perf_buffer_open(buf) == -1)
+			continue;
+
+		/* Store the perf buffer fd in the buffer map. */
+		bpf_map_update_elem(bufmap_fd, &cpu, &buf->fd, 0);
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
+ * Read the data_head offset from the header page of the ring buffer.  The
+ * argument is declared 'volatile' because it references a memory mapped page
+ * that the kernel may be writing to while we access it here.
+ */
+static u64 read_rb_head(volatile struct perf_event_mmap_page *rb_page)
+{
+	u64	head = rb_page->data_head;
+
+	asm volatile("" ::: "memory");
+
+	return head;
+}
+
+/*
+ * Write the data_tail offset in the header page of the ring buffer.  The
+ * argument is declared 'volatile' because it references a memory mapped page
+ * that the kernel may be writing to while we access it here.
+ */
+static void write_rb_tail(volatile struct perf_event_mmap_page *rb_page,
+			  u64 tail)
+{
+	asm volatile("" ::: "memory");
+
+	rb_page->data_tail = tail;
+}
+
+/*
+ * Process and output the probe data at the supplied address.
+ */
+static int output_event(u64 *buf)
+{
+	u8				*data = (u8 *)buf;
+	struct perf_event_header	*hdr;
+	u32				size;
+	u64				probe_id, task;
+	u32				pid, ppid, cpu, euid, egid, tag;
+
+	hdr = (struct perf_event_header *)data;
+	data += sizeof(struct perf_event_header);
+
+	if (hdr->type != PERF_RECORD_SAMPLE)
+		return 1;
+
+	size = *(u32 *)data;
+	data += sizeof(u32);
+
+	/*
+	 * The sample should only take up 48 bytes, but as a result of how the
+	 * BPF program stores the data (filling in a struct that resides on the
+	 * stack, and sending that off using bpf_perf_event_output()), there is
+	 * some internal padding
+	 */
+	if (size != 52) {
+		printf("Sample size is wrong (%d vs expected %d)\n", size, 52);
+		goto out;
+	}
+
+	probe_id = *(u64 *)&(data[0]);
+	pid = *(u32 *)&(data[8]);
+	ppid = *(u32 *)&(data[12]);
+	cpu = *(u32 *)&(data[16]);
+	euid = *(u32 *)&(data[20]);
+	egid = *(u32 *)&(data[24]);
+	task = *(u64 *)&(data[32]);
+	tag = *(u32 *)&(data[40]);
+
+	if (probe_id != 123)
+		printf("Corrupted data (probe_id = %ld)\n", probe_id);
+	if (tag != 0xdace)
+		printf("Corrupted data (tag = %x)\n", tag);
+
+	printf("CPU-%d: EPID %ld PID %d PPID %d EUID %d EGID %d TASK %08lx\n",
+	       cpu, probe_id, pid, ppid, euid, egid, task);
+
+out:
+	/*
+	 * We processed the perf_event_header, the size, and ;size; bytes of
+	 * probe data.
+	 */
+	return sizeof(struct perf_event_header) + sizeof(u32) + size;
+}
+
+/*
+ * Process the available probe data in the given buffer.
+ */
+static void process_data(struct dtrace_buffer *buf)
+{
+	/* This is volatile because the kernel may be updating the content. */
+	volatile struct perf_event_mmap_page	*rb_page = buf->base;
+	u8					*base = (u8 *)buf->base +
+							buf->page_size;
+	u64					head = read_rb_head(rb_page);
+
+	while (rb_page->data_tail != head) {
+		u64	tail = rb_page->data_tail;
+		u64	*ptr = (u64 *)(base + tail % buf->data_size);
+		int	len;
+
+		/*
+		 * Ensure that the buffer contains enough data for at least one
+		 * sample (header + sample size + sample data).
+		 */
+		if (head - tail < sizeof(struct perf_event_header) +
+				  sizeof(u32) + 48)
+			break;
+
+		if (*ptr)
+			len = output_event(ptr);
+		else
+			len = sizeof(*ptr);
+
+		write_rb_tail(rb_page, tail + len);
+		head = read_rb_head(rb_page);
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
diff --git a/tools/dtrace/dt_utils.c b/tools/dtrace/dt_utils.c
new file mode 100644
index 000000000000..e434a8a4769b
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
+#include "dtrace.h"
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
index 000000000000..6a6af8e3123a
--- /dev/null
+++ b/tools/dtrace/dtrace.c
@@ -0,0 +1,38 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <stdio.h>
+#include <stdlib.h>
+
+#include "dtrace.h"
+
+int main(int argc, char *argv[])
+{
+	int	epoll_fd;
+	int	cnt;
+
+	/* Get the list of online CPUs. */
+	cpu_list_populate();
+
+	/* Initialize buffers. */
+	epoll_fd = dt_buffer_init(32);
+	if (epoll_fd < 0) {
+		perror("dt_buffer_init");
+		exit(1);
+	}
+
+	/* Load the BPF program. */
+	if (argc < 2 || dt_bpf_load_file(argv[1]))
+		goto out;
+
+	printf("BPF loaded from %s...\n", argv[1]);
+
+	/* Process probe data. */
+	do {
+		cnt = dt_buffer_poll(epoll_fd, 100);
+	} while (cnt >= 0);
+
+out:
+	dt_buffer_exit(epoll_fd);
+	cpu_list_free();
+
+	exit(0);
+}
diff --git a/tools/dtrace/dtrace.h b/tools/dtrace/dtrace.h
new file mode 100644
index 000000000000..708b1477d39e
--- /dev/null
+++ b/tools/dtrace/dtrace.h
@@ -0,0 +1,44 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2019, Oracle and/or its affiliates. All rights reserved.
+ */
+#ifndef _DTRACE_H
+#define _DTRACE_H
+
+extern int	dt_numcpus;
+extern int	dt_maxcpuid;
+extern int	*dt_cpuids;
+
+extern void cpu_list_populate(void);
+extern void cpu_list_free(void);
+
+extern int dt_bpf_load_file(char *fn);
+
+extern int dt_buffer_init(int num_pages);
+extern int dt_buffer_poll(int epoll_fd, int timeout);
+extern void dt_buffer_exit(int epoll_fd);
+
+struct bpf_load_map_def {
+	unsigned int type;
+	unsigned int key_size;
+	unsigned int value_size;
+	unsigned int max_entries;
+	unsigned int map_flags;
+	unsigned int inner_map_idx;
+	unsigned int numa_node;
+};
+
+struct bpf_map_data {
+	int fd;
+	char *name;
+	size_t elf_offset;
+	struct bpf_load_map_def def;
+};
+
+typedef void (*fixup_map_cb)(struct bpf_map_data *map, int idx);
+
+extern void dt_buffer_fixup_map(struct bpf_map_data *map, int idx);
+
+extern int load_bpf_file_fixup_map(const char *path, fixup_map_cb fixup_map);
+
+#endif /* _DTRACE_H */
diff --git a/tools/dtrace/probe1_bpf.c b/tools/dtrace/probe1_bpf.c
new file mode 100644
index 000000000000..5b34edb61412
--- /dev/null
+++ b/tools/dtrace/probe1_bpf.c
@@ -0,0 +1,100 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2019, Oracle and/or its affiliates. All rights reserved.
+ *
+ * This sample BPF program was inspired by samples/bpf/tracex5_kern.c:
+ *   Copyright (c) 2015 PLUMgrid, http://plumgrid.com
+ */
+#include <uapi/linux/bpf.h>
+#include <linux/dtrace.h>
+#include <linux/version.h>
+#include <uapi/linux/unistd.h>
+#include "bpf_helpers.h"
+
+struct bpf_map_def SEC("maps") progs = {
+	.type = BPF_MAP_TYPE_PROG_ARRAY,
+	.key_size = sizeof(u32),
+	.value_size = sizeof(u32),
+	.max_entries = 8192,
+};
+
+struct bpf_map_def SEC("maps") probemap = {
+	.type = BPF_MAP_TYPE_HASH,
+	.key_size = sizeof(u32),
+	.value_size = sizeof(struct dtrace_ecb),
+	.max_entries = NR_CPUS,
+};
+
+/*
+ * Here so we have the map specification - it actually gets created by the
+ * userspace component of DTrace, and the loader code simply modifies the
+ * code by inserting the correct fd value.
+ */
+struct bpf_map_def SEC("maps") buffer_map = {
+	.type = BPF_MAP_TYPE_PERF_EVENT_ARRAY,
+	.key_size = sizeof(int),
+	.value_size = sizeof(u32),
+	.max_entries = 2,
+};
+
+struct sample {
+	u64 probe_id;
+	u32 pid;
+	u32 ppid;
+	u32 cpu;
+	u32 euid;
+	u32 egid;
+	u64 task;
+	u32 tag;
+};
+
+#define DPROG(F)	SEC("dtrace/"__stringify(F)) int bpf_func_##F
+
+/* we jump here when syscall number == __NR_write */
+DPROG(__NR_write)(struct dtrace_bpf_context *ctx)
+{
+	int			cpu = bpf_get_smp_processor_id();
+	struct dtrace_ecb	*ecb;
+	struct sample		smpl;
+
+	bpf_finalize_context(ctx, &probemap);
+
+	ecb = bpf_map_lookup_elem(&probemap, &cpu);
+	if (!ecb)
+		return 0;
+
+	memset(&smpl, 0, sizeof(smpl));
+	smpl.probe_id = ecb->probe_id;
+	smpl.pid = ctx->pid;
+	smpl.ppid = ctx->ppid;
+	smpl.cpu = ctx->cpu;
+	smpl.euid = ctx->euid;
+	smpl.egid = ctx->egid;
+	smpl.task = ctx->task;
+	smpl.tag = 0xdace;
+
+	bpf_perf_event_output(ctx, &buffer_map, cpu, &smpl, sizeof(smpl));
+
+	return 0;
+}
+
+SEC("kprobe/sys_write")
+int bpf_prog1(struct pt_regs *ctx)
+{
+	struct dtrace_ecb	ecb;
+	int			cpu = bpf_get_smp_processor_id();
+
+	ecb.id = 1;
+	ecb.probe_id = 123;
+
+	bpf_map_update_elem(&probemap, &cpu, &ecb, BPF_ANY);
+
+	/* dispatch into next BPF program depending on syscall number */
+	bpf_tail_call(ctx, &progs, __NR_write);
+
+	/* fall through -> unknown syscall */
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
+u32 _version SEC("version") = LINUX_VERSION_CODE;
-- 
2.20.1

