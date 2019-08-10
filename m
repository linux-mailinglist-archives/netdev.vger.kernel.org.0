Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 320688891C
	for <lists+netdev@lfdr.de>; Sat, 10 Aug 2019 09:22:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbfHJHWV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Aug 2019 03:22:21 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:33202 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725763AbfHJHWT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Aug 2019 03:22:19 -0400
Received: by mail-pg1-f193.google.com with SMTP id n190so6130172pgn.0
        for <netdev@vger.kernel.org>; Sat, 10 Aug 2019 00:22:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=910+jA2CCo8T9/juoYypHUZPc1nu2oE10wZ3w1PIFww=;
        b=JUllOmyelcml2fbv0psniUaXJxuBW7cOyTv7VROwRN6J/dznwqPYuP79xNKOXex5//
         wVfM8gpHaL5+zAlbF4R+IG9Ark3NBqFknH07y8vGIHiKWIhbzKBQujPL2gjym2yRi2bj
         X/e7XrNBwyLTW/2/nE5oYWJQ40ZsnI25P9JKtkAWwX+FE+WIiJZKj5sND7eFLJOKFs5/
         pbRT5Vi9fT42TiEouZee2mLn2OZBjeiaJAnz1Bf6Xi6BjNBjDt7DTumVnI4ocB/WdIhL
         +y/ZClPgYqOXvTvq7N4lfI+VQ3Z1UFgEZJf/TXGBYMcO3chS2nOlHpcX/SGMzwtaOi6+
         k1sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=910+jA2CCo8T9/juoYypHUZPc1nu2oE10wZ3w1PIFww=;
        b=UdBUCqyz7rZ9tEP+omPoAhXcqkmBTaJV0PhE14iP5kyoC12FixuBnbDw4M9FWkPjUU
         1qhxWtkBr5njQDw8leTiEou3+F+c6z0URbXtNwKi6AYYZl22JnbN8wYXgQiHTH7t6SJV
         orAoLSGsDq5VYmEAZL+YUfklYbggdrTWrJEy1yxAAD5q2txV1xK0hDdqlJDFm2RD5HyC
         enaOwAVTDajgE/iLKohZvs5NcUvqWz0PpbtySgxUkbRbQNTqbu6xI8gVMMMIGQT29Xhd
         XgYCZBCuj4OiFdQnhorJ4gUk1czAhFtfGiNcNhQYsPGCCJXUfroCF0AaAuKRYE2oPZKe
         maVQ==
X-Gm-Message-State: APjAAAUqwOXoDGywc8y8w0D6HA17on3t+DgV3W7awt/DMM9KV06EAPsw
        0S1Kg2nJ4VLcJiwF0umvUBzi4A==
X-Google-Smtp-Source: APXvYqzpjvY4BjDadYCMqHrv1MJzz0JDe+YRk/7XW3b9rbhquZ9IcNOaVCNZ1MOjgi3GDQDP+DHzFw==
X-Received: by 2002:a62:174a:: with SMTP id 71mr26588503pfx.140.1565421738783;
        Sat, 10 Aug 2019 00:22:18 -0700 (PDT)
Received: from localhost.localdomain (li456-16.members.linode.com. [50.116.10.16])
        by smtp.gmail.com with ESMTPSA id l17sm24872660pgj.44.2019.08.10.00.22.12
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 10 Aug 2019 00:22:18 -0700 (PDT)
From:   Leo Yan <leo.yan@linaro.org>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Milian Wolff <milian.wolff@kdab.com>,
        Donald Yandt <donald.yandt@gmail.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Wei Li <liwei391@huawei.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Mark Drayton <mbd@fb.com>,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Cc:     Leo Yan <leo.yan@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Suzuki Poulouse <suzuki.poulose@arm.com>,
        coresight@lists.linaro.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v4 2/2] perf machine: arm/arm64: Improve completeness for kernel address space
Date:   Sat, 10 Aug 2019 15:21:35 +0800
Message-Id: <20190810072135.27072-3-leo.yan@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190810072135.27072-1-leo.yan@linaro.org>
References: <20190810072135.27072-1-leo.yan@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Arm and arm64 architecture reserve some memory regions prior to the
symbol '_stext' and these memory regions later will be used by device
module and BPF jit.  The current code misses to consider these memory
regions thus any address in the regions will be taken as user space
mode, but perf cannot find the corresponding dso with the wrong CPU
mode so we misses to generate samples for device module and BPF
related trace data.

This patch parse the link scripts to get the memory size prior to start
address and reduce this size from 'machine>->kernel_start', then can
get a fixed up kernel start address which contain memory regions for
device module and BPF.  Finally, machine__get_kernel_start() can reflect
more complete kernel memory regions and perf can successfully generate
samples.

The reason for parsing the link scripts is Arm architecture changes text
offset dependent on different platforms, which define multiple text
offsets in $kernel/arch/arm/Makefile.  This offset is decided when build
kernel and the final value is extended in the link script, so we can
extract the used value from the link script.  We use the same way to
parse arm64 link script as well.  If fail to find the link script, the
pre start memory size is assumed as zero, in this case it has no any
change caused with this patch.

Below is detailed info for testing this patch:

- Install or build LLVM/Clang;

- Configure perf with ~/.perfconfig:

  root@debian:~# cat ~/.perfconfig
  # this file is auto-generated.
  [llvm]
          clang-path = /mnt/build/llvm-build/build/install/bin/clang
          kbuild-dir = /mnt/linux-kernel/linux-cs-dev/
          clang-opt = "-g"
          dump-obj = true

  [trace]
          show_zeros = yes
          show_duration = no
          no_inherit = yes
          show_timestamp = no
          show_arg_names = no
          args_alignment = 40
          show_prefix = yes

- Run 'perf trace' command with eBPF event:

  root@debian:~# perf trace -e string \
      -e $kernel/tools/perf/examples/bpf/augmented_raw_syscalls.c

- Read eBPF program memory mapping in kernel:

  root@debian:~# echo 1 > /proc/sys/net/core/bpf_jit_kallsyms
  root@debian:~# cat /proc/kallsyms | grep -E "bpf_prog_.+_sys_[enter|exit]"
  ffff00000008a0d0 t bpf_prog_e470211b846088d5_sys_enter  [bpf]
  ffff00000008c6a4 t bpf_prog_29c7ae234d79bd5c_sys_exit   [bpf]

- Launch any program which accesses file system frequently so can hit
  the system calls trace flow with eBPF event;

- Capture CoreSight trace data with filtering eBPF program:

  root@debian:~# perf record -e cs_etm/@tmc_etr0/ \
	--filter 'filter 0xffff00000008a0d0/0x800' -a sleep 5s

- Decode the eBPF program symbol 'bpf_prog_f173133dc38ccf87_sys_enter':

  root@debian:~# perf script -F,ip,sym
  Frame deformatter: Found 4 FSYNCS
                  0 [unknown]
   ffff00000008a1ac bpf_prog_e470211b846088d5_sys_enter
   ffff00000008a250 bpf_prog_e470211b846088d5_sys_enter
                  0 [unknown]
   ffff00000008a124 bpf_prog_e470211b846088d5_sys_enter
                  0 [unknown]
   ffff00000008a14c bpf_prog_e470211b846088d5_sys_enter
   ffff00000008a13c bpf_prog_e470211b846088d5_sys_enter
   ffff00000008a14c bpf_prog_e470211b846088d5_sys_enter
                  0 [unknown]
   ffff00000008a180 bpf_prog_e470211b846088d5_sys_enter
                  0 [unknown]
   ffff00000008a1ac bpf_prog_e470211b846088d5_sys_enter
   ffff00000008a190 bpf_prog_e470211b846088d5_sys_enter
   ffff00000008a1ac bpf_prog_e470211b846088d5_sys_enter
   ffff00000008a250 bpf_prog_e470211b846088d5_sys_enter
                  0 [unknown]
   ffff00000008a124 bpf_prog_e470211b846088d5_sys_enter
                  0 [unknown]
   ffff00000008a14c bpf_prog_e470211b846088d5_sys_enter
                  0 [unknown]
   ffff00000008a180 bpf_prog_e470211b846088d5_sys_enter
   [...]

Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Suzuki Poulouse <suzuki.poulose@arm.com>
Cc: coresight@lists.linaro.org
Cc: linux-arm-kernel@lists.infradead.org
Signed-off-by: Leo Yan <leo.yan@linaro.org>
---
 tools/perf/Makefile.config           | 22 ++++++++++++++++++++++
 tools/perf/arch/arm/util/Build       |  2 ++
 tools/perf/arch/arm/util/machine.c   | 17 +++++++++++++++++
 tools/perf/arch/arm64/util/Build     |  1 +
 tools/perf/arch/arm64/util/machine.c | 17 +++++++++++++++++
 5 files changed, 59 insertions(+)
 create mode 100644 tools/perf/arch/arm/util/machine.c
 create mode 100644 tools/perf/arch/arm64/util/machine.c

diff --git a/tools/perf/Makefile.config b/tools/perf/Makefile.config
index e4988f49ea79..76e0ad0b4fd2 100644
--- a/tools/perf/Makefile.config
+++ b/tools/perf/Makefile.config
@@ -51,6 +51,17 @@ endif
 ifeq ($(SRCARCH),arm)
   NO_PERF_REGS := 0
   LIBUNWIND_LIBS = -lunwind -lunwind-arm
+  PRE_START_SIZE := 0
+  ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/kernel/vmlinux.lds),)
+    # Extract info from lds:
+    #   . = ((0xC0000000)) + 0x00208000;
+    # PRE_START_SIZE := 0x00208000
+    PRE_START_SIZE := $(shell egrep ' \. \= \({2}0x[0-9a-fA-F]+\){2}' \
+      $(srctree)/arch/$(SRCARCH)/kernel/vmlinux.lds | \
+      sed -e 's/[(|)|.|=|+|<|;|-]//g' -e 's/ \+/ /g' -e 's/^[ \t]*//' | \
+      awk -F' ' '{printf "0x%x", $$2}' 2>/dev/null)
+  endif
+  CFLAGS += -DARM_PRE_START_SIZE=$(PRE_START_SIZE)
 endif
 
 ifeq ($(SRCARCH),arm64)
@@ -58,6 +69,17 @@ ifeq ($(SRCARCH),arm64)
   NO_SYSCALL_TABLE := 0
   CFLAGS += -I$(OUTPUT)arch/arm64/include/generated
   LIBUNWIND_LIBS = -lunwind -lunwind-aarch64
+  PRE_START_SIZE := 0
+  ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/kernel/vmlinux.lds),)
+    # Extract info from lds:
+    #  . = ((((((((0xffffffffffffffff)) - (((1)) << (48)) + 1) + (0)) + (0x08000000))) + (0x08000000))) + 0x00080000;
+    # PRE_START_SIZE := (0x08000000 + 0x08000000 + 0x00080000) = 0x10080000
+    PRE_START_SIZE := $(shell egrep ' \. \= \({8}0x[0-9a-fA-F]+\){2}' \
+      $(srctree)/arch/$(SRCARCH)/kernel/vmlinux.lds | \
+      sed -e 's/[(|)|.|=|+|<|;|-]//g' -e 's/ \+/ /g' -e 's/^[ \t]*//' | \
+      awk -F' ' '{printf "0x%x", $$6+$$7+$$8}' 2>/dev/null)
+  endif
+  CFLAGS += -DARM_PRE_START_SIZE=$(PRE_START_SIZE)
 endif
 
 ifeq ($(SRCARCH),csky)
diff --git a/tools/perf/arch/arm/util/Build b/tools/perf/arch/arm/util/Build
index 296f0eac5e18..efa6b768218a 100644
--- a/tools/perf/arch/arm/util/Build
+++ b/tools/perf/arch/arm/util/Build
@@ -1,3 +1,5 @@
+perf-y += machine.o
+
 perf-$(CONFIG_DWARF) += dwarf-regs.o
 
 perf-$(CONFIG_LOCAL_LIBUNWIND)    += unwind-libunwind.o
diff --git a/tools/perf/arch/arm/util/machine.c b/tools/perf/arch/arm/util/machine.c
new file mode 100644
index 000000000000..db172894e4ea
--- /dev/null
+++ b/tools/perf/arch/arm/util/machine.c
@@ -0,0 +1,17 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/types.h>
+#include <linux/string.h>
+#include <stdlib.h>
+
+#include "../../util/machine.h"
+
+void arch__fix_kernel_text_start(u64 *start)
+{
+	/*
+	 * On arm, the 16MB virtual memory space prior to 'kernel_start' is
+	 * allocated to device modules, a PMD table if CONFIG_HIGHMEM is
+	 * enabled and a PGD table.  To reflect the complete kernel address
+	 * space, compensate the pre-defined regions for kernel start address.
+	 */
+	*start = *start - ARM_PRE_START_SIZE;
+}
diff --git a/tools/perf/arch/arm64/util/Build b/tools/perf/arch/arm64/util/Build
index 3cde540d2fcf..8081fb8a7b3d 100644
--- a/tools/perf/arch/arm64/util/Build
+++ b/tools/perf/arch/arm64/util/Build
@@ -1,4 +1,5 @@
 perf-y += header.o
+perf-y += machine.o
 perf-y += sym-handling.o
 perf-$(CONFIG_DWARF)     += dwarf-regs.o
 perf-$(CONFIG_LOCAL_LIBUNWIND) += unwind-libunwind.o
diff --git a/tools/perf/arch/arm64/util/machine.c b/tools/perf/arch/arm64/util/machine.c
new file mode 100644
index 000000000000..61058dca8c5a
--- /dev/null
+++ b/tools/perf/arch/arm64/util/machine.c
@@ -0,0 +1,17 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/types.h>
+#include <linux/string.h>
+#include <stdlib.h>
+
+#include "../../util/machine.h"
+
+void arch__fix_kernel_text_start(u64 *start)
+{
+	/*
+	 * On arm64, the root PGD table, device module memory region and
+	 * BPF jit region are prior to 'kernel_start'.  To reflect the
+	 * complete kernel address space, compensate these pre-defined
+	 * regions for kernel start address.
+	 */
+	*start = *start - ARM_PRE_START_SIZE;
+}
-- 
2.17.1

