Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 719A62A0524
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 13:14:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbgJ3MOl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 08:14:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726078AbgJ3MOj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 08:14:39 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA8A6C0613D4;
        Fri, 30 Oct 2020 05:14:38 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id n18so6214775wrs.5;
        Fri, 30 Oct 2020 05:14:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=22k2+2mPYYCKt816luVuB7jNmXQqv5Ahy52O1HXZvfg=;
        b=mci0cldkthbCm2ePhH31s/8V5bS1h68TJU4ScGGK5rt3c9PLqxmGSHDR3ZhrlQfYJ9
         XDg6LRe0eikRkuAdxbwBMyP6+fS+BQ8UUe37dLl3YkcMUJTVmCkCtReMpZPJpJAZ8+bc
         4z5USRs2tktHdx+8p1TpHlhGWLl2DGyloAm/bv0CFvddtITTu74nY3ks1+NQA/Ff3PU9
         q8pEYSXTEWGK2sHJV8Gqu0S5T4gdIv9U2stXnW/k5F3MV+z187xGzzk/F4xTgfptBKzq
         f5Dw2YjN+fnQdx1ccivbynqFcPrFvzAu+edbCqHkQREUm0SPEHI9tBlLXneNQnSBqZi+
         0/NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=22k2+2mPYYCKt816luVuB7jNmXQqv5Ahy52O1HXZvfg=;
        b=LGbTgzI+Q9kJFBtwnAq0pRrufJzZFw6mFXP4BIM4qDg+AsvYXarAvdO4Up7FcV5rAn
         DHt2suuzeILEyZEWiZsGYC/Jdmq+wsAoDX2EfeQBq1F7DxPJIbS3qni2Hy29KqBEDam1
         HCKJorrEjGCpmMtoSXYZNlpf53QZQFDnlPjRdCy8azZT9vHBwh6szPs2335Rnjk/gw4s
         MqETWrfK5AyyZdqJ4TzFXDdzFAaOymVWCZRQ2wXacOccBjAP/XAp6ItEJJtQBSSRdqHn
         g+ETXCJtHlTuJ9FcYLHCP7McymZrQIF9ux5wHS47NciuuINIoIYiWFpKJ5Ih+O2LyzN7
         kaBg==
X-Gm-Message-State: AOAM532+EoWL7A2OXp3XECDQy7+6TvuD72r6nkIrdYFKhyWKOWl02a7q
        lij4Z/fDzJ5aqp/x6eNjRxSY0Ten1em7cI50wqk=
X-Google-Smtp-Source: ABdhPJw9N0k8KevB5JksbSIlL6k9v/h14bzuYUUMUNuD/sW/hw7Nn8yhG6cKEK4L4R/DmGNTCFBpdA==
X-Received: by 2002:adf:9d44:: with SMTP id o4mr2962364wre.229.1604060076334;
        Fri, 30 Oct 2020 05:14:36 -0700 (PDT)
Received: from kernel-dev.chello.ie ([80.111.136.190])
        by smtp.gmail.com with ESMTPSA id 90sm10020925wrh.35.2020.10.30.05.14.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2020 05:14:35 -0700 (PDT)
From:   Weqaar Janjua <weqaar.janjua@gmail.com>
X-Google-Original-From: Weqaar Janjua <weqaar.a.janjua@intel.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        ast@kernel.org, magnus.karlsson@gmail.com, bjorn.topel@intel.com
Cc:     Weqaar Janjua <weqaar.a.janjua@intel.com>, shuah@kernel.org,
        skhan@linuxfoundation.org, linux-kselftest@vger.kernel.org,
        anders.roxell@linaro.org, jonathan.lemon@gmail.com
Subject: [PATCH bpf-next 2/5] selftests/xsk: xsk selftests - SKB POLL, NOPOLL
Date:   Fri, 30 Oct 2020 12:13:44 +0000
Message-Id: <20201030121347.26984-3-weqaar.a.janjua@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201030121347.26984-1-weqaar.a.janjua@intel.com>
References: <20201030121347.26984-1-weqaar.a.janjua@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds following tests:

1. AF_XDP SKB mode
   Generic mode XDP is driver independent, used when the driver does
   not have support for XDP. Works on any netdevice using sockets and
   generic XDP path. XDP hook from netif_receive_skb().
   a. nopoll - soft-irq processing
   b. poll - using poll() syscall

Signed-off-by: Weqaar Janjua <weqaar.a.janjua@intel.com>
---
 tools/testing/selftests/xsk/Makefile          |  20 +-
 tools/testing/selftests/xsk/README            |  35 +
 .../selftests/xsk/TEST_XSK_SKB_NOPOLL.sh      |  18 +
 .../selftests/xsk/TEST_XSK_SKB_POLL.sh        |  21 +
 tools/testing/selftests/xsk/config            |  11 +
 tools/testing/selftests/xsk/xdpprogs/Makefile |  64 ++
 .../selftests/xsk/xdpprogs/Makefile.target    |  68 ++
 .../selftests/xsk/xdpprogs/xdpxceiver.c       | 923 ++++++++++++++++++
 .../selftests/xsk/xdpprogs/xdpxceiver.h       | 152 +++
 9 files changed, 1311 insertions(+), 1 deletion(-)
 create mode 100755 tools/testing/selftests/xsk/TEST_XSK_SKB_NOPOLL.sh
 create mode 100755 tools/testing/selftests/xsk/TEST_XSK_SKB_POLL.sh
 create mode 100644 tools/testing/selftests/xsk/xdpprogs/Makefile
 create mode 100644 tools/testing/selftests/xsk/xdpprogs/Makefile.target
 create mode 100644 tools/testing/selftests/xsk/xdpprogs/xdpxceiver.c
 create mode 100644 tools/testing/selftests/xsk/xdpprogs/xdpxceiver.h

diff --git a/tools/testing/selftests/xsk/Makefile b/tools/testing/selftests/xsk/Makefile
index 6e0d657bc5e0..63008cd90ab6 100644
--- a/tools/testing/selftests/xsk/Makefile
+++ b/tools/testing/selftests/xsk/Makefile
@@ -1,10 +1,28 @@
 # SPDX-License-Identifier: GPL-2.0
 # Copyright(c) 2020 Intel Corporation.
 
+CFLAGS += -O2 -g -std=gnu99 -Wall -I../../../../usr/include/
+
+XSKDIR := $(realpath ./xdpprogs)
+XSKOBJ := xdpxceiver
+
 TEST_PROGS := TEST_PREREQUISITES.sh \
-	TEST_XSK.sh
+	TEST_XSK_SKB_NOPOLL.sh \
+	TEST_XSK_SKB_POLL.sh
 TEST_FILES := prereqs.sh xskenv.sh
 TEST_TRANSIENT_FILES := veth.spec
+TEST_PROGS_EXTENDED := $(XSKDIR)/$(XSKOBJ)
+
+all: $(TEST_PROGS_EXTENDED)
 
 KSFT_KHDR_INSTALL := 1
 include ../lib.mk
+
+$(TEST_PROGS_EXTENDED): $(XSKDIR)/$(XSKOBJ)
+
+$(XSKDIR)/$(XSKOBJ):
+	cd $(XSKDIR) && $(MAKE)
+
+override define CLEAN
+	cd $(XSKDIR) && $(MAKE) clean
+endef
diff --git a/tools/testing/selftests/xsk/README b/tools/testing/selftests/xsk/README
index a255b3050afc..db507a0057c1 100644
--- a/tools/testing/selftests/xsk/README
+++ b/tools/testing/selftests/xsk/README
@@ -34,6 +34,10 @@ contiguous memory, divided into equal-sized frames.
 Refer to AF_XDP Kernel Documentation for detailed information:
 https://www.kernel.org/doc/html/latest/networking/af_xdp.html
 
+The test program contains two threads, each thread is single socket with
+a unique UMEM. It validates in-order packet delivery and packet content
+by sending packets to each other.
+
 Prerequisites setup by script TEST_PREREQUISITES.sh:
 
    Set up veth interfaces as per the topology shown ^^:
@@ -46,6 +50,37 @@ Prerequisites setup by script TEST_PREREQUISITES.sh:
    *** xxxx and yyyy are randomly generated 4 digit numbers used to avoid
        conflict with any existing interface
 
+Tests Information:
+------------------
+These selftests test AF_XDP SKB and Native/DRV modes using veth
+Virtual Ethernet interfaces.
+
+The following tests are run:
+
+1. AF_XDP SKB mode
+   Generic mode XDP is driver independent, used when the driver does
+   not have support for XDP. Works on any netdevice using sockets and
+   generic XDP path. XDP hook from netif_receive_skb().
+   a. nopoll - soft-irq processing
+   b. poll - using poll() syscall
+
+Total tests: 2.
+
+Flow:
+* Single process spawns two threads: Tx and Rx
+* Each of these two threads attach to a veth interface within their assigned
+  namespaces
+* Each thread Creates one AF_XDP socket connected to a unique umem for each
+  veth interface
+* Tx thread Transmits 10k packets from veth<xxxx> to veth<yyyy>
+* Rx thread verifies if all 10k packets were received and delivered in-order,
+  and have the right content
+
+Enable/disable debug mode:
+--------------------------
+To enable L2 - L4 headers and payload dump of each packet on STDOUT, add
+parameter -D to params array in TEST_XSK_<TEST>.sh, i.e. params=("-S" "-D")
+
 Kernel configuration:
 ---------------------
 See "config" file for recommended kernel config options.
diff --git a/tools/testing/selftests/xsk/TEST_XSK_SKB_NOPOLL.sh b/tools/testing/selftests/xsk/TEST_XSK_SKB_NOPOLL.sh
new file mode 100755
index 000000000000..76d2681485ba
--- /dev/null
+++ b/tools/testing/selftests/xsk/TEST_XSK_SKB_NOPOLL.sh
@@ -0,0 +1,18 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright(c) 2020 Intel Corporation.
+
+. prereqs.sh
+. xskenv.sh
+
+TEST_NAME="SKB NOPOLL"
+
+vethXDPgeneric ${VETH0} ${VETH1} ${NS1}
+
+params=("-S")
+execxdpxceiver params
+
+retval=$?
+test_status $retval "${TEST_NAME}"
+
+test_exit $retval 0
diff --git a/tools/testing/selftests/xsk/TEST_XSK_SKB_POLL.sh b/tools/testing/selftests/xsk/TEST_XSK_SKB_POLL.sh
new file mode 100755
index 000000000000..4d314ed72cd8
--- /dev/null
+++ b/tools/testing/selftests/xsk/TEST_XSK_SKB_POLL.sh
@@ -0,0 +1,21 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright(c) 2020 Intel Corporation.
+
+. prereqs.sh
+. xskenv.sh
+
+TEST_NAME="SKB POLL"
+
+vethXDPgeneric ${VETH0} ${VETH1} ${NS1}
+
+params=("-S" "-p")
+execxdpxceiver params
+
+retval=$?
+test_status $retval "${TEST_NAME}"
+
+# Must be called in the last test to execute
+cleanup_exit ${VETH0} ${VETH1} ${NS1}
+
+test_exit $retval 0
diff --git a/tools/testing/selftests/xsk/config b/tools/testing/selftests/xsk/config
index 80311f71266d..6529faf51554 100644
--- a/tools/testing/selftests/xsk/config
+++ b/tools/testing/selftests/xsk/config
@@ -1 +1,12 @@
 CONFIG_VETH=m
+CONFIG_BPF=y
+CONFIG_BPF_SYSCALL=y
+CONFIG_NET_CLS_BPF=m
+CONFIG_BPF_EVENTS=y
+CONFIG_TEST_BPF=m
+CONFIG_CGROUP_BPF=y
+CONFIG_BPF_STREAM_PARSER=y
+CONFIG_XDP_SOCKETS=y
+CONFIG_BPF_JIT=y
+CONFIG_BPF_LSM=y
+CONFIG_XDP_SOCKETS_DIAG=y
diff --git a/tools/testing/selftests/xsk/xdpprogs/Makefile b/tools/testing/selftests/xsk/xdpprogs/Makefile
new file mode 100644
index 000000000000..d310b677fb8c
--- /dev/null
+++ b/tools/testing/selftests/xsk/xdpprogs/Makefile
@@ -0,0 +1,64 @@
+# SPDX-License-Identifier: GPL-2.0
+# Copyright(c) 2020 Intel Corporation.
+
+# File copied from samples/bpf/Makefile and modified for use
+
+XDPPROGS_PATH ?= $(abspath $(srctree)/$(src))
+TOOLS_PATH := $(XDPPROGS_PATH)/../../../../../tools
+
+# List of programs to build
+tprogs-y := xdpxceiver
+
+# Libbpf dependencies
+LIBBPF = $(TOOLS_PATH)/lib/bpf/libbpf.a
+
+xdpxceiver-objs := xdpxceiver.o
+
+# Tell kbuild to always build the programs
+always-y := $(tprogs-y)
+
+ifeq ($(ARCH), arm)
+# Strip all except -D__LINUX_ARM_ARCH__ option needed to handle linux
+# headers when arm instruction set identification is requested.
+ARM_ARCH_SELECTOR := $(filter -D__LINUX_ARM_ARCH__%, $(KBUILD_CFLAGS))
+BPF_EXTRA_CFLAGS := $(ARM_ARCH_SELECTOR)
+TPROGS_CFLAGS += $(ARM_ARCH_SELECTOR)
+endif
+
+TPROGS_CFLAGS += -Wall -O2
+TPROGS_CFLAGS += -Wmissing-prototypes
+TPROGS_CFLAGS += -Wstrict-prototypes
+
+TPROGS_CFLAGS += -I$(objtree)/usr/include
+TPROGS_CFLAGS += -I$(srctree)/tools/testing/selftests/bpf/
+TPROGS_CFLAGS += -I$(srctree)/tools/lib/
+TPROGS_CFLAGS += -I$(srctree)/tools/include
+TPROGS_CFLAGS += -DHAVE_ATTR_TEST=0
+
+ifdef SYSROOT
+TPROGS_CFLAGS += --sysroot=$(SYSROOT)
+TPROGS_LDFLAGS := -L$(SYSROOT)/usr/lib
+endif
+
+TPROGS_LDLIBS += $(LIBBPF) -lelf -lz
+TPROGLDLIBS_xdpxceiver += -pthread
+
+# Detect that we're cross compiling and use the cross compiler
+ifdef CROSS_COMPILE
+CLANG_ARCH_ARGS = --target=$(notdir $(CROSS_COMPILE:%-=%))
+endif
+
+# Trick to allow make to be run from this directory
+all:
+	$(MAKE) -C ../../../../../ M=$(CURDIR) XDPPROGS_PATH=$(CURDIR)
+
+clean:
+	$(MAKE) -C ../../../../../ M=$(CURDIR) clean
+	@find $(CURDIR) -type f -name '*~' -delete
+
+$(LIBBPF):
+# Fix up variables inherited from Kbuild that tools/ build system won't like
+	$(MAKE) -C $(dir $@) RM='rm -rf' EXTRA_CFLAGS="$(TPROGS_CFLAGS)" \
+		LDFLAGS=$(TPROGS_LDFLAGS) srctree=$(XDPPROGS_PATH)/../../../../../ O=
+
+-include $(XDPPROGS_PATH)/Makefile.target
diff --git a/tools/testing/selftests/xsk/xdpprogs/Makefile.target b/tools/testing/selftests/xsk/xdpprogs/Makefile.target
new file mode 100644
index 000000000000..cfd810355df9
--- /dev/null
+++ b/tools/testing/selftests/xsk/xdpprogs/Makefile.target
@@ -0,0 +1,68 @@
+# SPDX-License-Identifier: GPL-2.0
+# ==========================================================================
+# Copied from samples/bpf/Makefile.target and modified for use
+#
+# Building binaries on the host system
+# Binaries are not used during the compilation of the kernel, and intended
+# to be build for target board, target board can be host of course. Added to
+# build binaries to run not on host system.
+#
+# Derived from scripts/Makefile.host
+#
+__tprogs := $(sort $(tprogs-y))
+
+# C code
+# Executables compiled from a single .c file
+tprog-csingle := $(foreach m,$(__tprogs), \
+	$(if $($(m)-objs),,$(m)))
+
+# C executables linked based on several .o files
+tprog-cmulti := $(foreach m,$(__tprogs), \
+	$(if $($(m)-objs),$(m)))
+
+# Object (.o) files compiled from .c files
+tprog-cobjs	:= $(sort $(foreach m,$(__tprogs),$($(m)-objs)))
+
+tprog-csingle := $(addprefix $(obj)/,$(tprog-csingle))
+tprog-cmulti := $(addprefix $(obj)/,$(tprog-cmulti))
+tprog-cobjs	:= $(addprefix $(obj)/,$(tprog-cobjs))
+
+#####
+# Handle options to gcc. Support building with separate output directory
+
+_tprogc_flags = $(TPROGS_CFLAGS) \
+	$(TPROGCFLAGS_$(basetarget).o)
+
+# $(objtree)/$(obj) for including generated headers from checkin source files
+ifeq ($(KBUILD_EXTMOD),)
+ifdef building_out_of_srctree
+_tprogc_flags += -I $(objtree)/$(obj)
+endif
+endif
+
+tprogc_flags = -Wp,-MD,$(depfile) $(_tprogc_flags)
+
+# Create executable from a single .c file
+# tprog-csingle -> Executable
+quiet_cmd_tprog-csingle = CC $@
+cmd_tprog-csingle = $(CC) $(tprogc_flags) $(TPROGS_LDFLAGS) -o $@ $< \
+	$(TPROGS_LDLIBS) $(TPROGLDLIBS_$(@F))
+$(tprog-csingle): $(obj)/%: $(src)/%.c
+	$(call if_changed_dep,tprog-csingle)
+
+# Link an executable based on list of .o files, all plain c
+# tprog-cmulti -> executable
+quiet_cmd_tprog-cmulti = LD $@
+cmd_tprog-cmulti = $(CC) $(tprogc_flags) $(TPROGS_LDFLAGS) -o $@ \
+	$(addprefix $(obj)/,$($(@F)-objs)) \
+	$(TPROGS_LDLIBS) $(TPROGLDLIBS_$(@F))
+$(tprog-cmulti): $(tprog-cobjs)
+	$(call if_changed,tprog-cmulti)
+$(call multi_depend, $(tprog-cmulti), , -objs)
+
+# Create .o file from a single .c file
+# tprog-cobjs -> .o
+quiet_cmd_tprog-cobjs = CC $@
+cmd_tprog-cobjs = $(CC) $(tprogc_flags) -c -o $@ $<
+$(tprog-cobjs): $(obj)/%.o: $(src)/%.c
+	$(call if_changed_dep,tprog-cobjs)
diff --git a/tools/testing/selftests/xsk/xdpprogs/xdpxceiver.c b/tools/testing/selftests/xsk/xdpprogs/xdpxceiver.c
new file mode 100644
index 000000000000..9855a3b33fae
--- /dev/null
+++ b/tools/testing/selftests/xsk/xdpprogs/xdpxceiver.c
@@ -0,0 +1,923 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2020 Intel Corporation. */
+
+/*
+ * Some functions in this program are taken from
+ * Linux kernel samples/bpf/xdpsock* and modified
+ * for use.
+ */
+
+#define _GNU_SOURCE
+#include <fcntl.h>
+#include <asm/barrier.h>
+#include <errno.h>
+#include <getopt.h>
+#include <linux/if_link.h>
+#include <linux/ip.h>
+#include <linux/if_ether.h>
+#include <linux/udp.h>
+#include <arpa/inet.h>
+#include <net/if.h>
+#include <locale.h>
+#include <poll.h>
+#include <pthread.h>
+#include <signal.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/mman.h>
+#include <sys/resource.h>
+#include <sys/types.h>
+#include <sys/queue.h>
+#include <time.h>
+#include <unistd.h>
+#include <assert.h>
+#include <stdatomic.h>
+
+#include <bpf/xsk.h>
+#include "xdpxceiver.h"
+#include "../../kselftest.h"
+
+static void __exit_with_error(int error, const char *file, const char *func, int line)
+{
+	ksft_test_result_fail
+	    ("[%s:%s:%i]: ERROR: %d/\"%s\"\n", file, func, line, error, strerror(error));
+	ksft_exit_xfail();
+}
+
+#define exit_with_error(error) __exit_with_error(error, __FILE__, __func__, __LINE__)
+
+#define print_ksft_result(void)\
+	(ksft_test_result_pass("PASS: %s %s\n", uut ? "" : "SKB", opt_poll ? "POLL" : "NOPOLL"))
+
+static void pthread_init_mutex(void)
+{
+	pthread_mutex_init(&sync_mutex, NULL);
+	pthread_mutex_init(&sync_mutex_tx, NULL);
+	pthread_cond_init(&signal_rx_condition, NULL);
+	pthread_cond_init(&signal_tx_condition, NULL);
+}
+
+static void pthread_destroy_mutex(void)
+{
+	pthread_mutex_destroy(&sync_mutex);
+	pthread_mutex_destroy(&sync_mutex_tx);
+	pthread_cond_destroy(&signal_rx_condition);
+	pthread_cond_destroy(&signal_tx_condition);
+}
+
+static void *memset32_htonl(void *dest, u32 val, u32 size)
+{
+	u32 *ptr = (u32 *)dest;
+	int i;
+
+	val = htonl(val);
+
+	for (i = 0; i < (size & (~0x3)); i += 4)
+		ptr[i >> 2] = val;
+
+	for (; i < size; i++)
+		((char *)dest)[i] = ((char *)&val)[i & 3];
+
+	return dest;
+}
+
+/*
+ * This function code has been taken from
+ * Linux kernel lib/checksum.c
+ */
+static inline unsigned short from32to16(unsigned int x)
+{
+	/* add up 16-bit and 16-bit for 16+c bit */
+	x = (x & 0xffff) + (x >> 16);
+	/* add up carry.. */
+	x = (x & 0xffff) + (x >> 16);
+	return x;
+}
+
+/*
+ * Fold a partial checksum
+ * This function code has been taken from
+ * Linux kernel include/asm-generic/checksum.h
+ */
+static inline __sum16 csum_fold(__wsum csum)
+{
+	u32 sum = (__force u32)csum;
+
+	sum = (sum & 0xffff) + (sum >> 16);
+	sum = (sum & 0xffff) + (sum >> 16);
+	return (__force __sum16)~sum;
+}
+
+/*
+ * This function code has been taken from
+ * Linux kernel lib/checksum.c
+ */
+static inline u32 from64to32(u64 x)
+{
+	/* add up 32-bit and 32-bit for 32+c bit */
+	x = (x & 0xffffffff) + (x >> 32);
+	/* add up carry.. */
+	x = (x & 0xffffffff) + (x >> 32);
+	return (u32)x;
+}
+
+__wsum csum_tcpudp_nofold(__be32 saddr, __be32 daddr, __u32 len, __u8 proto, __wsum sum);
+
+/*
+ * This function code has been taken from
+ * Linux kernel lib/checksum.c
+ */
+__wsum csum_tcpudp_nofold(__be32 saddr, __be32 daddr, __u32 len, __u8 proto, __wsum sum)
+{
+	unsigned long long s = (__force u32)sum;
+
+	s += (__force u32)saddr;
+	s += (__force u32)daddr;
+#ifdef __BIG_ENDIAN__
+	s += proto + len;
+#else
+	s += (proto + len) << 8;
+#endif
+	return (__force __wsum)from64to32(s);
+}
+
+/*
+ * This function has been taken from
+ * Linux kernel include/asm-generic/checksum.h
+ */
+static inline __sum16
+csum_tcpudp_magic(__be32 saddr, __be32 daddr, __u32 len, __u8 proto, __wsum sum)
+{
+	return csum_fold(csum_tcpudp_nofold(saddr, daddr, len, proto, sum));
+}
+
+static inline u16 udp_csum(u32 saddr, u32 daddr, u32 len, u8 proto, u16 *udp_pkt)
+{
+	u32 csum = 0;
+	u32 cnt = 0;
+
+	/* udp hdr and data */
+	for (; cnt < len; cnt += 2)
+		csum += udp_pkt[cnt >> 1];
+
+	return csum_tcpudp_magic(saddr, daddr, len, proto, csum);
+}
+
+static void gen_eth_hdr(void *data, struct ethhdr *eth_hdr)
+{
+	memcpy(eth_hdr->h_dest, ((struct ifobject *)data)->dst_mac, ETH_ALEN);
+	memcpy(eth_hdr->h_source, ((struct ifobject *)data)->src_mac, ETH_ALEN);
+	eth_hdr->h_proto = htons(ETH_P_IP);
+}
+
+static void gen_ip_hdr(void *data, struct iphdr *ip_hdr)
+{
+	ip_hdr->version = IPVERSION;
+	ip_hdr->ihl = 0x5;
+	ip_hdr->tos = 0x0;
+	ip_hdr->tot_len = htons(IP_PKT_SIZE);
+	ip_hdr->id = 0;
+	ip_hdr->frag_off = 0;
+	ip_hdr->ttl = IPDEFTTL;
+	ip_hdr->protocol = IPPROTO_UDP;
+	ip_hdr->saddr = ((struct ifobject *)data)->src_ip;
+	ip_hdr->daddr = ((struct ifobject *)data)->dst_ip;
+	ip_hdr->check = 0;
+}
+
+static void gen_udp_hdr(void *data, void *arg, struct udphdr *udp_hdr)
+{
+	udp_hdr->source = htons(((struct ifobject *)arg)->src_port);
+	udp_hdr->dest = htons(((struct ifobject *)arg)->dst_port);
+	udp_hdr->len = htons(UDP_PKT_SIZE);
+	memset32_htonl(pkt_data + PKT_HDR_SIZE,
+		       htonl(((struct generic_data *)data)->seqnum), UDP_PKT_DATA_SIZE);
+}
+
+static void gen_udp_csum(struct udphdr *udp_hdr, struct iphdr *ip_hdr)
+{
+	udp_hdr->check = 0;
+	udp_hdr->check =
+	    udp_csum(ip_hdr->saddr, ip_hdr->daddr, UDP_PKT_SIZE, IPPROTO_UDP, (u16 *)udp_hdr);
+}
+
+static void gen_eth_frame(struct xsk_umem_info *umem, u64 addr)
+{
+	memcpy(xsk_umem__get_data(umem->buffer, addr), pkt_data, PKT_SIZE);
+}
+
+static void xsk_configure_umem(struct ifobject *data, void *buffer, u64 size)
+{
+	int ret;
+
+	data->umem = calloc(1, sizeof(struct xsk_umem_info));
+	if (!data->umem)
+		exit_with_error(errno);
+
+	ret = xsk_umem__create(&data->umem->umem, buffer, size,
+			       &data->umem->fq, &data->umem->cq, NULL);
+	if (ret)
+		exit_with_error(ret);
+
+	data->umem->buffer = buffer;
+}
+
+static void xsk_populate_fill_ring(struct xsk_umem_info *umem)
+{
+	int ret, i;
+	u32 idx;
+
+	ret = xsk_ring_prod__reserve(&umem->fq, XSK_RING_PROD__DEFAULT_NUM_DESCS, &idx);
+	if (ret != XSK_RING_PROD__DEFAULT_NUM_DESCS)
+		exit_with_error(ret);
+	for (i = 0; i < XSK_RING_PROD__DEFAULT_NUM_DESCS; i++)
+		*xsk_ring_prod__fill_addr(&umem->fq, idx++) = i * XSK_UMEM__DEFAULT_FRAME_SIZE;
+	xsk_ring_prod__submit(&umem->fq, XSK_RING_PROD__DEFAULT_NUM_DESCS);
+}
+
+static int xsk_configure_socket(struct ifobject *ifobject)
+{
+	struct xsk_socket_config cfg;
+	struct xsk_ring_cons *rxr;
+	struct xsk_ring_prod *txr;
+	int ret;
+
+	ifobject->xsk = calloc(1, sizeof(struct xsk_socket_info));
+	if (!ifobject->xsk)
+		exit_with_error(errno);
+
+	ifobject->xsk->umem = ifobject->umem;
+	cfg.rx_size = XSK_RING_CONS__DEFAULT_NUM_DESCS;
+	cfg.tx_size = XSK_RING_PROD__DEFAULT_NUM_DESCS;
+	cfg.libbpf_flags = 0;
+	cfg.xdp_flags = opt_xdp_flags;
+	cfg.bind_flags = opt_xdp_bind_flags;
+
+	rxr = (ifobject->fv.vector == rx) ? &ifobject->xsk->rx : NULL;
+	txr = (ifobject->fv.vector == tx) ? &ifobject->xsk->tx : NULL;
+
+	ret = xsk_socket__create(&ifobject->xsk->xsk, ifobject->ifname,
+				 opt_queue, ifobject->umem->umem, rxr, txr, &cfg);
+
+	if (ret)
+		return 1;
+
+	return 0;
+}
+
+static struct option long_options[] = {
+	{"interface", required_argument, 0, 'i'},
+	{"queue", optional_argument, 0, 'q'},
+	{"poll", no_argument, 0, 'p'},
+	{"xdp-skb", no_argument, 0, 'S'},
+	{"copy", no_argument, 0, 'c'},
+	{"debug", optional_argument, 0, 'D'},
+	{"tx-pkt-count", optional_argument, 0, 'C'},
+	{0, 0, 0, 0}
+};
+
+static void usage(const char *prog)
+{
+	const char *str =
+	    "  Usage: %s [OPTIONS]\n"
+	    "  Options:\n"
+	    "  -i, --interface      Use interface\n"
+	    "  -q, --queue=n        Use queue n (default 0)\n"
+	    "  -p, --poll           Use poll syscall\n"
+	    "  -S, --xdp-skb=n      Use XDP SKB mode\n"
+	    "  -c, --copy           Force copy mode\n"
+	    "  -D, --debug          Debug mode - dump packets L2 - L5\n"
+	    "  -C, --tx-pkt-count=n Number of packets to send\n";
+	ksft_print_msg(str, prog);
+}
+
+static bool switch_namespace(int idx)
+{
+	char fqns[26] = "/var/run/netns/";
+	int nsfd;
+
+	strncat(fqns, ifdict[idx]->nsname, sizeof(fqns) - strlen(fqns) - 1);
+	nsfd = open(fqns, O_RDONLY);
+
+	if (nsfd == -1)
+		exit_with_error(errno);
+
+	if (setns(nsfd, 0) == -1)
+		exit_with_error(errno);
+
+	return true;
+}
+
+static void *nsswitchthread(void *args)
+{
+	if (switch_namespace(((struct targs *)args)->idx)) {
+		ifdict[((struct targs *)args)->idx]->ifindex =
+		    if_nametoindex(ifdict[((struct targs *)args)->idx]->ifname);
+		if (!ifdict[((struct targs *)args)->idx]->ifindex) {
+			ksft_test_result_fail
+			    ("ERROR: [%s] interface \"%s\" does not exist\n",
+			     __func__, ifdict[((struct targs *)args)->idx]->ifname);
+			((struct targs *)args)->retptr = false;
+		} else {
+			ksft_print_msg("Interface found: %s\n",
+				       ifdict[((struct targs *)args)->idx]->ifname);
+			((struct targs *)args)->retptr = true;
+		}
+	} else {
+		((struct targs *)args)->retptr = false;
+	}
+	pthread_exit(NULL);
+}
+
+static int validate_interfaces(void)
+{
+	bool ret = true;
+
+	for (int i = 0; i < MAX_INTERFACES; i++) {
+		if (!strcmp(ifdict[i]->ifname, "")) {
+			ret = false;
+			ksft_test_result_fail("ERROR: interfaces: -i <int>,<ns> -i <int>,<ns>.");
+		}
+		if (strcmp(ifdict[i]->nsname, "")) {
+			struct targs *targs;
+
+			targs = (struct targs *)malloc(sizeof(struct targs));
+			if (!targs)
+				exit_with_error(errno);
+
+			targs->idx = i;
+			if (pthread_create(&ns_thread, NULL, nsswitchthread, (void *)targs))
+				exit_with_error(errno);
+
+			pthread_join(ns_thread, NULL);
+
+			if (targs->retptr)
+				ksft_print_msg("NS switched: %s\n", ifdict[i]->nsname);
+
+			free(targs);
+		} else {
+			ifdict[i]->ifindex = if_nametoindex(ifdict[i]->ifname);
+			if (!ifdict[i]->ifindex) {
+				ksft_test_result_fail
+				    ("ERROR: interface \"%s\" does not exist\n", ifdict[i]->ifname);
+				ret = false;
+			} else {
+				ksft_print_msg("Interface found: %s\n", ifdict[i]->ifname);
+			}
+		}
+	}
+	return ret;
+}
+
+static void parse_command_line(int argc, char **argv)
+{
+	int option_index, interface_index = 0, c;
+
+	opterr = 0;
+
+	for (;;) {
+		c = getopt_long(argc, argv, "i:q:pScDC:", long_options, &option_index);
+
+		if (c == -1)
+			break;
+
+		switch (c) {
+		case 'i':
+			if (interface_index == MAX_INTERFACES)
+				break;
+			char *sptr, *token;
+
+			memcpy(ifdict[interface_index]->ifname,
+			       strtok_r(optarg, ",", &sptr), MAX_INTERFACE_NAME_CHARS);
+			token = strtok_r(NULL, ",", &sptr);
+			if (token)
+				memcpy(ifdict[interface_index]->nsname, token,
+				       MAX_INTERFACES_NAMESPACE_CHARS);
+			interface_index++;
+			break;
+		case 'q':
+			opt_queue = atoi(optarg);
+			break;
+		case 'p':
+			opt_poll = 1;
+			break;
+		case 'S':
+			opt_xdp_flags |= XDP_FLAGS_SKB_MODE;
+			opt_xdp_bind_flags |= XDP_COPY;
+			uut = ORDER_CONTENT_VALIDATE_XDP_SKB;
+			break;
+		case 'c':
+			opt_xdp_bind_flags |= XDP_COPY;
+			break;
+		case 'D':
+			debug_pkt_dump = 1;
+			break;
+		case 'C':
+			opt_pkt_count = atoi(optarg);
+			break;
+		default:
+			usage(basename(argv[0]));
+			ksft_exit_xfail();
+		}
+	}
+
+	if (!validate_interfaces()) {
+		usage(basename(argv[0]));
+		ksft_exit_xfail();
+	}
+}
+
+static void kick_tx(struct xsk_socket_info *xsk)
+{
+	int ret;
+
+	ret = sendto(xsk_socket__fd(xsk->xsk), NULL, 0, MSG_DONTWAIT, NULL, 0);
+	if (ret >= 0 || errno == ENOBUFS || errno == EAGAIN || errno == EBUSY || errno == ENETDOWN)
+		return;
+	exit_with_error(errno);
+}
+
+static inline void complete_tx_only(struct xsk_socket_info *xsk, int batch_size)
+{
+	unsigned int rcvd;
+	u32 idx;
+
+	if (!xsk->outstanding_tx)
+		return;
+
+	if (!NEED_WAKEUP || xsk_ring_prod__needs_wakeup(&xsk->tx))
+		kick_tx(xsk);
+
+	rcvd = xsk_ring_cons__peek(&xsk->umem->cq, batch_size, &idx);
+	if (rcvd) {
+		xsk_ring_cons__release(&xsk->umem->cq, rcvd);
+		xsk->outstanding_tx -= rcvd;
+		xsk->tx_npkts += rcvd;
+	}
+}
+
+static void rx_pkt(struct xsk_socket_info *xsk, struct pollfd *fds)
+{
+	unsigned int rcvd, i;
+	u32 idx_rx = 0, idx_fq = 0;
+	int ret;
+
+	rcvd = xsk_ring_cons__peek(&xsk->rx, BATCH_SIZE, &idx_rx);
+	if (!rcvd) {
+		if (xsk_ring_prod__needs_wakeup(&xsk->umem->fq)) {
+			ret = poll(fds, 1, POLL_TMOUT);
+			if (ret < 0)
+				exit_with_error(ret);
+		}
+		return;
+	}
+
+	ret = xsk_ring_prod__reserve(&xsk->umem->fq, rcvd, &idx_fq);
+	while (ret != rcvd) {
+		if (ret < 0)
+			exit_with_error(ret);
+		if (xsk_ring_prod__needs_wakeup(&xsk->umem->fq)) {
+			ret = poll(fds, 1, POLL_TMOUT);
+			if (ret < 0)
+				exit_with_error(ret);
+		}
+		ret = xsk_ring_prod__reserve(&xsk->umem->fq, rcvd, &idx_fq);
+	}
+
+	for (i = 0; i < rcvd; i++) {
+		u64 addr = xsk_ring_cons__rx_desc(&xsk->rx, idx_rx)->addr;
+		(void)xsk_ring_cons__rx_desc(&xsk->rx, idx_rx++)->len;
+		u64 orig = xsk_umem__extract_addr(addr);
+
+		addr = xsk_umem__add_offset_to_addr(addr);
+		pkt_node_rx = malloc(sizeof(struct pkt) + PKT_SIZE);
+		if (!pkt_node_rx)
+			exit_with_error(errno);
+
+		pkt_node_rx->pkt_frame = (char *)malloc(PKT_SIZE);
+		if (!pkt_node_rx->pkt_frame)
+			exit_with_error(errno);
+
+		memcpy(pkt_node_rx->pkt_frame, xsk_umem__get_data(xsk->umem->buffer, addr),
+		       PKT_SIZE);
+
+		TAILQ_INSERT_HEAD(&head, pkt_node_rx, pkt_nodes);
+
+		*xsk_ring_prod__fill_addr(&xsk->umem->fq, idx_fq++) = orig;
+	}
+
+	xsk_ring_prod__submit(&xsk->umem->fq, rcvd);
+	xsk_ring_cons__release(&xsk->rx, rcvd);
+	xsk->rx_npkts += rcvd;
+}
+
+static void tx_only(struct xsk_socket_info *xsk, u32 *frameptr, int batch_size)
+{
+	u32 idx;
+	unsigned int i;
+
+	while (xsk_ring_prod__reserve(&xsk->tx, batch_size, &idx) < batch_size)
+		complete_tx_only(xsk, batch_size);
+
+	for (i = 0; i < batch_size; i++) {
+		struct xdp_desc *tx_desc = xsk_ring_prod__tx_desc(&xsk->tx, idx + i);
+
+		tx_desc->addr = (*frameptr + i) << XSK_UMEM__DEFAULT_FRAME_SHIFT;
+		tx_desc->len = PKT_SIZE;
+	}
+
+	xsk_ring_prod__submit(&xsk->tx, batch_size);
+	xsk->outstanding_tx += batch_size;
+	*frameptr += batch_size;
+	*frameptr %= num_frames;
+	complete_tx_only(xsk, batch_size);
+}
+
+static inline int get_batch_size(int pkt_cnt)
+{
+	if (!opt_pkt_count)
+		return BATCH_SIZE;
+
+	if (pkt_cnt + BATCH_SIZE <= opt_pkt_count)
+		return BATCH_SIZE;
+
+	return opt_pkt_count - pkt_cnt;
+}
+
+static void complete_tx_only_all(void *arg)
+{
+	bool pending;
+
+	do {
+		pending = false;
+		if (((struct ifobject *)arg)->xsk->outstanding_tx) {
+			complete_tx_only(((struct ifobject *)
+					  arg)->xsk, BATCH_SIZE);
+			pending = !!((struct ifobject *)arg)->xsk->outstanding_tx;
+		}
+	} while (pending);
+}
+
+static void tx_only_all(void *arg)
+{
+	struct pollfd fds[MAX_SOCKS] = { };
+	u32 frame_nb = 0;
+	int pkt_cnt = 0;
+	int ret;
+
+	fds[0].fd = xsk_socket__fd(((struct ifobject *)arg)->xsk->xsk);
+	fds[0].events = POLLOUT;
+
+	while ((opt_pkt_count && pkt_cnt < opt_pkt_count) || !opt_pkt_count) {
+		int batch_size = get_batch_size(pkt_cnt);
+
+		if (opt_poll) {
+			ret = poll(fds, 1, POLL_TMOUT);
+			if (ret <= 0)
+				continue;
+
+			if (!(fds[0].revents & POLLOUT))
+				continue;
+		}
+
+		tx_only(((struct ifobject *)arg)->xsk, &frame_nb, batch_size);
+		pkt_cnt += batch_size;
+	}
+
+	if (opt_pkt_count)
+		complete_tx_only_all(arg);
+}
+
+static void worker_pkt_dump(void)
+{
+	struct in_addr ipaddr;
+
+	fprintf(stdout, "---------------------------------------\n");
+	for (int iter = 0; iter < num_frames - 1; iter++) {
+		/*extract L2 frame */
+		fprintf(stdout, "DEBUG>> L2: dst mac: ");
+		for (int i = 0; i < ETH_ALEN; i++)
+			fprintf(stdout, "%02X", ((struct ethhdr *)
+						 pkt_buf[iter]->payload)->h_dest[i]);
+
+		fprintf(stdout, "\nDEBUG>> L2: src mac: ");
+		for (int i = 0; i < ETH_ALEN; i++)
+			fprintf(stdout, "%02X", ((struct ethhdr *)
+						 pkt_buf[iter]->payload)->h_source[i]);
+
+		/*extract L3 frame */
+		fprintf(stdout, "\nDEBUG>> L3: ip_hdr->ihl: %02X\n",
+			((struct iphdr *)(pkt_buf[iter]->payload + sizeof(struct ethhdr)))->ihl);
+
+		ipaddr.s_addr =
+		    ((struct iphdr *)(pkt_buf[iter]->payload + sizeof(struct ethhdr)))->saddr;
+		fprintf(stdout, "DEBUG>> L3: ip_hdr->saddr: %s\n", inet_ntoa(ipaddr));
+
+		ipaddr.s_addr =
+		    ((struct iphdr *)(pkt_buf[iter]->payload + sizeof(struct ethhdr)))->daddr;
+		fprintf(stdout, "DEBUG>> L3: ip_hdr->daddr: %s\n", inet_ntoa(ipaddr));
+
+		/*extract L4 frame */
+		fprintf(stdout, "DEBUG>> L4: udp_hdr->src: %d\n",
+			ntohs(((struct udphdr *)(pkt_buf[iter]->payload +
+						 sizeof(struct ethhdr) +
+						 sizeof(struct iphdr)))->source));
+
+		fprintf(stdout, "DEBUG>> L4: udp_hdr->dst: %d\n",
+			ntohs(((struct udphdr *)(pkt_buf[iter]->payload +
+						 sizeof(struct ethhdr) +
+						 sizeof(struct iphdr)))->dest));
+		/*extract L5 frame */
+		int payload = *((uint32_t *)(pkt_buf[iter]->payload + PKT_HDR_SIZE));
+
+		if (payload == EOT) {
+			ksft_print_msg("End-of-tranmission frame received\n");
+			fprintf(stdout, "---------------------------------------\n");
+			break;
+		}
+		fprintf(stdout, "DEBUG>> L5: payload: %d\n", payload);
+		fprintf(stdout, "---------------------------------------\n");
+	}
+}
+
+static void worker_pkt_validate(void)
+{
+	u32 payloadseqnum = -2;
+
+	while (1) {
+		pkt_node_rx_q = malloc(sizeof(struct pkt));
+		pkt_node_rx_q = TAILQ_LAST(&head, head_s);
+		if (!pkt_node_rx_q)
+			break;
+
+		payloadseqnum = *((uint32_t *)(pkt_node_rx_q->pkt_frame + PKT_HDR_SIZE));
+		if (debug_pkt_dump && payloadseqnum != EOT) {
+			pkt_obj = (struct pkt_frame *)malloc(sizeof(struct pkt_frame));
+			pkt_obj->payload = (char *)malloc(PKT_SIZE);
+			memcpy(pkt_obj->payload, pkt_node_rx_q->pkt_frame, PKT_SIZE);
+			pkt_buf[payloadseqnum] = pkt_obj;
+		}
+
+		if (payloadseqnum == EOT) {
+			ksft_print_msg("End-of-tranmission frame received: PASS\n");
+			sigvar = 1;
+			break;
+		}
+
+		if (prev_pkt + 1 != payloadseqnum) {
+			ksft_test_result_fail
+			    ("ERROR: [%s] prev_pkt [%d], payloadseqnum [%d]\n",
+			     __func__, prev_pkt, payloadseqnum);
+			ksft_exit_xfail();
+		}
+
+		TAILQ_REMOVE(&head, pkt_node_rx_q, pkt_nodes);
+		free(pkt_node_rx_q->pkt_frame);
+		free(pkt_node_rx_q);
+		pkt_node_rx_q = NULL;
+		prev_pkt = payloadseqnum;
+		pkt_counter++;
+	}
+}
+
+static void thread_common_ops(void *arg, void *bufs, pthread_mutex_t *mutexptr,
+			      atomic_int *spinningptr)
+{
+	int ctr = 0;
+	int ret;
+
+	xsk_configure_umem((struct ifobject *)arg, bufs, num_frames * XSK_UMEM__DEFAULT_FRAME_SIZE);
+	ret = xsk_configure_socket((struct ifobject *)arg);
+
+	/* Retry Create Socket if it fails as xsk_socket__create()
+	 * is asynchronous
+	 *
+	 * Essential to lock Mutex here to prevent Tx thread from
+	 * entering before Rx and causing a deadlock
+	 */
+	pthread_mutex_lock(mutexptr);
+	while (ret && ctr < SOCK_RECONF_CTR) {
+		atomic_store(spinningptr, 1);
+		xsk_configure_umem((struct ifobject *)arg,
+				   bufs, num_frames * XSK_UMEM__DEFAULT_FRAME_SIZE);
+		ret = xsk_configure_socket((struct ifobject *)arg);
+		usleep(USLEEP_MAX);
+		ctr++;
+	}
+	atomic_store(spinningptr, 0);
+	pthread_mutex_unlock(mutexptr);
+
+	if (ctr >= SOCK_RECONF_CTR)
+		exit_with_error(ret);
+}
+
+static void *worker_testapp_validate(void *arg)
+{
+	struct udphdr *udp_hdr =
+	    (struct udphdr *)(pkt_data + sizeof(struct ethhdr) + sizeof(struct iphdr));
+	struct generic_data *data = (struct generic_data *)malloc(sizeof(struct generic_data));
+	struct iphdr *ip_hdr = (struct iphdr *)(pkt_data + sizeof(struct ethhdr));
+	struct ethhdr *eth_hdr = (struct ethhdr *)pkt_data;
+	void *bufs;
+
+	pthread_attr_setstacksize(&attr, THREAD_STACK);
+
+	bufs = mmap(NULL, num_frames * XSK_UMEM__DEFAULT_FRAME_SIZE,
+		    PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (bufs == MAP_FAILED)
+		exit_with_error(errno);
+
+	if (strcmp(((struct ifobject *)arg)->nsname, ""))
+		switch_namespace(((struct ifobject *)arg)->ifdict_index);
+
+	if (((struct ifobject *)arg)->fv.vector == tx) {
+		int spinningrxctr = 0;
+
+		thread_common_ops(arg, bufs, &sync_mutex_tx, &spinning_tx);
+
+		while (atomic_load(&spinning_rx) && spinningrxctr < SOCK_RECONF_CTR) {
+			spinningrxctr++;
+			usleep(USLEEP_MAX);
+		}
+
+		ksft_print_msg("Interface [%s] vector [Tx]\n", ((struct ifobject *)arg)->ifname);
+		for (int i = 0; i < num_frames; i++) {
+			/*send EOT frame */
+			if (i == (num_frames - 1))
+				data->seqnum = -1;
+			else
+				data->seqnum = i;
+			gen_udp_hdr((void *)data, (void *)arg, udp_hdr);
+			gen_ip_hdr((void *)arg, ip_hdr);
+			gen_udp_csum(udp_hdr, ip_hdr);
+			gen_eth_hdr((void *)arg, eth_hdr);
+			gen_eth_frame(((struct ifobject *)arg)->umem,
+				      i * XSK_UMEM__DEFAULT_FRAME_SIZE);
+		}
+
+		free(data);
+		ksft_print_msg("Sending %d packets on interface %s\n",
+			       (opt_pkt_count - 1), ((struct ifobject *)arg)->ifname);
+		tx_only_all(arg);
+	} else if (((struct ifobject *)arg)->fv.vector == rx) {
+		struct pollfd fds[MAX_SOCKS] = { };
+		int ret;
+
+		thread_common_ops(arg, bufs, &sync_mutex_tx, &spinning_rx);
+
+		ksft_print_msg("Interface [%s] vector [Rx]\n", ((struct ifobject *)arg)->ifname);
+		xsk_populate_fill_ring(((struct ifobject *)arg)->umem);
+
+		TAILQ_INIT(&head);
+		if (debug_pkt_dump) {
+			pkt_buf = malloc(sizeof(struct pkt_frame **) * num_frames);
+			if (!pkt_buf)
+				exit_with_error(errno);
+		}
+
+		fds[0].fd = xsk_socket__fd(((struct ifobject *)arg)->xsk->xsk);
+		fds[0].events = POLLIN;
+
+		pthread_mutex_lock(&sync_mutex);
+		pthread_cond_signal(&signal_rx_condition);
+		pthread_mutex_unlock(&sync_mutex);
+
+		while (1) {
+			if (opt_poll) {
+				ret = poll(fds, 1, POLL_TMOUT);
+				if (ret <= 0)
+					continue;
+			}
+			rx_pkt(((struct ifobject *)arg)->xsk, fds);
+			worker_pkt_validate();
+
+			if (sigvar)
+				break;
+		}
+
+		ksft_print_msg("Received %d packets on interface %s\n",
+			       pkt_counter, ((struct ifobject *)arg)->ifname);
+	}
+
+	xsk_socket__delete(((struct ifobject *)arg)->xsk->xsk);
+	(void)xsk_umem__delete(((struct ifobject *)arg)->umem->umem);
+	pthread_exit(NULL);
+}
+
+static void testapp_validate(void)
+{
+	pthread_attr_init(&attr);
+	pthread_attr_setstacksize(&attr, THREAD_STACK);
+
+	pthread_mutex_lock(&sync_mutex);
+
+	/*Spawn RX thread */
+	if (pthread_create(&t0, &attr, worker_testapp_validate, (void *)ifdict[1]))
+		exit_with_error(errno);
+
+	struct timespec max_wait = { 0, 0 };
+
+	if (clock_gettime(CLOCK_REALTIME, &max_wait))
+		exit_with_error(errno);
+	max_wait.tv_sec += TMOUT_SEC;
+
+	if (pthread_cond_timedwait(&signal_rx_condition, &sync_mutex, &max_wait) == ETIMEDOUT)
+		exit_with_error(errno);
+
+	pthread_mutex_unlock(&sync_mutex);
+
+	/*Spawn TX thread */
+	if (pthread_create(&t1, &attr, worker_testapp_validate, (void *)ifdict[0]))
+		exit_with_error(errno);
+
+	pthread_join(t1, NULL);
+	pthread_join(t0, NULL);
+
+	if (debug_pkt_dump) {
+		worker_pkt_dump();
+		for (int iter = 0; iter < num_frames - 1; iter++) {
+			free(pkt_buf[iter]->payload);
+			free(pkt_buf[iter]);
+		}
+		free(pkt_buf);
+	}
+
+	print_ksft_result();
+}
+
+static void init_iface_config(void *ifaceconfig)
+{
+	/*Init interface0 */
+	ifdict[0]->fv.vector = tx;
+	memcpy(ifdict[0]->dst_mac, ((struct ifaceconfigobj *)ifaceconfig)->dst_mac, ETH_ALEN);
+	memcpy(ifdict[0]->src_mac, ((struct ifaceconfigobj *)ifaceconfig)->src_mac, ETH_ALEN);
+	ifdict[0]->dst_ip = ((struct ifaceconfigobj *)ifaceconfig)->dst_ip.s_addr;
+	ifdict[0]->src_ip = ((struct ifaceconfigobj *)ifaceconfig)->src_ip.s_addr;
+	ifdict[0]->dst_port = ((struct ifaceconfigobj *)ifaceconfig)->dst_port;
+	ifdict[0]->src_port = ((struct ifaceconfigobj *)ifaceconfig)->src_port;
+
+	/*Init interface1 */
+	ifdict[1]->fv.vector = rx;
+	memcpy(ifdict[1]->dst_mac, ((struct ifaceconfigobj *)ifaceconfig)->src_mac, ETH_ALEN);
+	memcpy(ifdict[1]->src_mac, ((struct ifaceconfigobj *)ifaceconfig)->dst_mac, ETH_ALEN);
+	ifdict[1]->dst_ip = ((struct ifaceconfigobj *)ifaceconfig)->src_ip.s_addr;
+	ifdict[1]->src_ip = ((struct ifaceconfigobj *)ifaceconfig)->dst_ip.s_addr;
+	ifdict[1]->dst_port = ((struct ifaceconfigobj *)ifaceconfig)->src_port;
+	ifdict[1]->src_port = ((struct ifaceconfigobj *)ifaceconfig)->dst_port;
+}
+
+int main(int argc, char **argv)
+{
+	struct rlimit _rlim = { RLIM_INFINITY, RLIM_INFINITY };
+
+	if (setrlimit(RLIMIT_MEMLOCK, &_rlim))
+		exit_with_error(errno);
+
+	const char *MAC1 = "\x00\x0A\x56\x9E\xEE\x62";
+	const char *MAC2 = "\x00\x0A\x56\x9E\xEE\x61";
+	const char *IP1 = "192.168.100.162";
+	const char *IP2 = "192.168.100.161";
+	u16 UDP_DST_PORT = 2020;
+	u16 UDP_SRC_PORT = 2121;
+
+	ifaceconfig = (struct ifaceconfigobj *)malloc(sizeof(struct ifaceconfigobj));
+	memcpy(ifaceconfig->dst_mac, MAC1, ETH_ALEN);
+	memcpy(ifaceconfig->src_mac, MAC2, ETH_ALEN);
+	inet_aton(IP1, &ifaceconfig->dst_ip);
+	inet_aton(IP2, &ifaceconfig->src_ip);
+	ifaceconfig->dst_port = UDP_DST_PORT;
+	ifaceconfig->src_port = UDP_SRC_PORT;
+
+	for (int i = 0; i < MAX_INTERFACES; i++) {
+		ifdict[i] = (struct ifobject *)malloc(sizeof(struct ifobject));
+		if (!ifdict[i])
+			exit_with_error(errno);
+
+		ifdict[i]->ifdict_index = i;
+	}
+
+	setlocale(LC_ALL, "");
+
+	parse_command_line(argc, argv);
+
+	num_frames = ++opt_pkt_count;
+
+	init_iface_config((void *)ifaceconfig);
+
+	pthread_init_mutex();
+
+	ksft_set_plan(1);
+
+	testapp_validate();
+
+	for (int i = 0; i < MAX_INTERFACES; i++)
+		free(ifdict[i]);
+
+	pthread_destroy_mutex();
+
+	ksft_exit_pass();
+
+	return 0;
+}
diff --git a/tools/testing/selftests/xsk/xdpprogs/xdpxceiver.h b/tools/testing/selftests/xsk/xdpprogs/xdpxceiver.h
new file mode 100644
index 000000000000..385a01ab04c0
--- /dev/null
+++ b/tools/testing/selftests/xsk/xdpprogs/xdpxceiver.h
@@ -0,0 +1,152 @@
+/* SPDX-License-Identifier: GPL-2.0
+ * Copyright(c) 2020 Intel Corporation.
+ */
+
+#ifndef XDPXCEIVER_H_
+#define XDPXCEIVER_H_
+
+#ifndef SOL_XDP
+#define SOL_XDP 283
+#endif
+
+#ifndef AF_XDP
+#define AF_XDP 44
+#endif
+
+#ifndef PF_XDP
+#define PF_XDP AF_XDP
+#endif
+
+#define MAX_INTERFACES 2
+#define MAX_INTERFACE_NAME_CHARS 7
+#define MAX_INTERFACES_NAMESPACE_CHARS 10
+#define MAX_SOCKS 1
+#define PKT_HDR_SIZE (sizeof(struct ethhdr) + sizeof(struct iphdr) + \
+			sizeof(struct udphdr))
+#define MIN_PKT_SIZE 64
+#define ETH_FCS_SIZE 4
+#define PKT_SIZE (MIN_PKT_SIZE - ETH_FCS_SIZE)
+#define IP_PKT_SIZE (PKT_SIZE - sizeof(struct ethhdr))
+#define UDP_PKT_SIZE (IP_PKT_SIZE - sizeof(struct iphdr))
+#define UDP_PKT_DATA_SIZE (UDP_PKT_SIZE - sizeof(struct udphdr))
+#define TMOUT_SEC (3)
+#define EOT (-1)
+#define USLEEP_MAX 200000
+#define THREAD_STACK 60000000
+#define SOCK_RECONF_CTR 10
+#define BATCH_SIZE 64
+#define POLL_TMOUT 1000
+#define NEED_WAKEUP true
+
+typedef __u64 u64;
+typedef __u32 u32;
+typedef __u16 u16;
+typedef __u8 u8;
+
+enum TESTS {
+	ORDER_CONTENT_VALIDATE_XDP_SKB = 0,
+};
+
+u8 uut;
+u8 debug_pkt_dump;
+u32 num_frames;
+
+static u32 opt_xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
+static int opt_queue;
+static int opt_pkt_count;
+static int opt_poll;
+static u32 opt_xdp_bind_flags = XDP_USE_NEED_WAKEUP;
+static u8 pkt_data[XSK_UMEM__DEFAULT_FRAME_SIZE];
+static u32 pkt_counter;
+static u32 prev_pkt = -1;
+static int sigvar;
+
+struct xsk_umem_info {
+	struct xsk_ring_prod fq;
+	struct xsk_ring_cons cq;
+	struct xsk_umem *umem;
+	void *buffer;
+};
+
+struct xsk_socket_info {
+	struct xsk_ring_cons rx;
+	struct xsk_ring_prod tx;
+	struct xsk_umem_info *umem;
+	struct xsk_socket *xsk;
+	unsigned long rx_npkts;
+	unsigned long tx_npkts;
+	unsigned long prev_rx_npkts;
+	unsigned long prev_tx_npkts;
+	u32 outstanding_tx;
+};
+
+struct flow_vector {
+	enum fvector {
+		tx,
+		rx,
+		bidi,
+		undef,
+	} vector;
+};
+
+struct generic_data {
+	u32 seqnum;
+};
+
+struct ifaceconfigobj {
+	u8 dst_mac[ETH_ALEN];
+	u8 src_mac[ETH_ALEN];
+	struct in_addr dst_ip;
+	struct in_addr src_ip;
+	u16 src_port;
+	u16 dst_port;
+} *ifaceconfig;
+
+struct ifobject {
+	int ifindex;
+	int ifdict_index;
+	char ifname[MAX_INTERFACE_NAME_CHARS];
+	char nsname[MAX_INTERFACES_NAMESPACE_CHARS];
+	struct flow_vector fv;
+	struct xsk_socket_info *xsk;
+	struct xsk_umem_info *umem;
+	u8 dst_mac[ETH_ALEN];
+	u8 src_mac[ETH_ALEN];
+	u32 dst_ip;
+	u32 src_ip;
+	u16 src_port;
+	u16 dst_port;
+};
+
+static struct ifobject *ifdict[MAX_INTERFACES];
+
+/*threads*/
+atomic_int spinning_tx;
+atomic_int spinning_rx;
+pthread_mutex_t sync_mutex;
+pthread_mutex_t sync_mutex_tx;
+pthread_cond_t signal_rx_condition;
+pthread_cond_t signal_tx_condition;
+pthread_t t0, t1, ns_thread;
+pthread_attr_t attr;
+
+struct targs {
+	bool retptr;
+	int idx;
+};
+
+TAILQ_HEAD(head_s, pkt) head = TAILQ_HEAD_INITIALIZER(head);
+struct head_s *head_p;
+struct pkt {
+	char *pkt_frame;
+
+	TAILQ_ENTRY(pkt) pkt_nodes;
+} *pkt_node_rx, *pkt_node_rx_q;
+
+struct pkt_frame {
+	char *payload;
+} *pkt_obj;
+
+struct pkt_frame **pkt_buf;
+
+#endif				/* XDPXCEIVER_H */
-- 
2.20.1

