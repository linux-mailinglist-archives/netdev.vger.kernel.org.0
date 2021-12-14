Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49F834743F4
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 14:55:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234594AbhLNNy4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 08:54:56 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:15732 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230038AbhLNNyz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 08:54:55 -0500
Received: from dggpemm500021.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4JD0DB42qtzZdQ0;
        Tue, 14 Dec 2021 21:51:54 +0800 (CST)
Received: from dggpemm500019.china.huawei.com (7.185.36.180) by
 dggpemm500021.china.huawei.com (7.185.36.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 14 Dec 2021 21:54:53 +0800
Received: from ubuntu1804.huawei.com (10.67.174.98) by
 dggpemm500019.china.huawei.com (7.185.36.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 14 Dec 2021 21:54:53 +0800
From:   Pu Lehui <pulehui@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kafai@fb.com>, <songliubraving@fb.com>, <yhs@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
        <paul.walmsley@sifive.com>, <palmer@dabbelt.com>,
        <aou@eecs.berkeley.edu>, <shuah@kernel.org>
CC:     <linux-kselftest@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pulehui@huawei.com>
Subject: [PATCH bpf-next] selftests/bpf: Fix building error when using userspace pt_regs
Date:   Tue, 14 Dec 2021 21:55:55 +0800
Message-ID: <20211214135555.125348-1-pulehui@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.174.98]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500019.china.huawei.com (7.185.36.180)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When building bpf selftests on arm64, the following error will occur:

progs/loop2.c:20:7: error: incomplete definition of type 'struct
user_pt_regs'

Some archs, like arm64 and riscv, use userspace pt_regs in
bpf_tracing.h, which causes build failure when bpf prog use
macro in bpf_tracing.h. So let's use vmlinux.h directly.

Signed-off-by: Pu Lehui <pulehui@huawei.com>
---
 tools/testing/selftests/bpf/progs/loop1.c     |  8 ++------
 tools/testing/selftests/bpf/progs/loop2.c     |  8 ++------
 tools/testing/selftests/bpf/progs/loop3.c     |  8 ++------
 tools/testing/selftests/bpf/progs/loop6.c     | 20 ++++++-------------
 .../selftests/bpf/progs/test_overhead.c       |  8 ++------
 .../selftests/bpf/progs/test_probe_user.c     |  6 +-----
 6 files changed, 15 insertions(+), 43 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/loop1.c b/tools/testing/selftests/bpf/progs/loop1.c
index 50e66772c046..ea04c035719c 100644
--- a/tools/testing/selftests/bpf/progs/loop1.c
+++ b/tools/testing/selftests/bpf/progs/loop1.c
@@ -1,11 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 // Copyright (c) 2019 Facebook
-#include <linux/sched.h>
-#include <linux/ptrace.h>
-#include <stdint.h>
-#include <stddef.h>
-#include <stdbool.h>
-#include <linux/bpf.h>
+
+#include "vmlinux.h"
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_tracing.h>
 
diff --git a/tools/testing/selftests/bpf/progs/loop2.c b/tools/testing/selftests/bpf/progs/loop2.c
index 947bb7e988c2..edf07b1d310e 100644
--- a/tools/testing/selftests/bpf/progs/loop2.c
+++ b/tools/testing/selftests/bpf/progs/loop2.c
@@ -1,11 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 // Copyright (c) 2019 Facebook
-#include <linux/sched.h>
-#include <linux/ptrace.h>
-#include <stdint.h>
-#include <stddef.h>
-#include <stdbool.h>
-#include <linux/bpf.h>
+
+#include "vmlinux.h"
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_tracing.h>
 
diff --git a/tools/testing/selftests/bpf/progs/loop3.c b/tools/testing/selftests/bpf/progs/loop3.c
index 76e93b31c14b..c8d2f2c55547 100644
--- a/tools/testing/selftests/bpf/progs/loop3.c
+++ b/tools/testing/selftests/bpf/progs/loop3.c
@@ -1,11 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 // Copyright (c) 2019 Facebook
-#include <linux/sched.h>
-#include <linux/ptrace.h>
-#include <stdint.h>
-#include <stddef.h>
-#include <stdbool.h>
-#include <linux/bpf.h>
+
+#include "vmlinux.h"
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_tracing.h>
 
diff --git a/tools/testing/selftests/bpf/progs/loop6.c b/tools/testing/selftests/bpf/progs/loop6.c
index 38de0331e6b4..17ac4da5664d 100644
--- a/tools/testing/selftests/bpf/progs/loop6.c
+++ b/tools/testing/selftests/bpf/progs/loop6.c
@@ -1,8 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 
-#include <linux/ptrace.h>
-#include <stddef.h>
-#include <linux/bpf.h>
+#include "vmlinux.h"
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_tracing.h>
 
@@ -25,12 +23,6 @@ char _license[] SEC("license") = "GPL";
 #define SG_CHAIN	0x01UL
 #define SG_END		0x02UL
 
-struct scatterlist {
-	unsigned long   page_link;
-	unsigned int    offset;
-	unsigned int    length;
-};
-
 #define sg_is_chain(sg)		((sg)->page_link & SG_CHAIN)
 #define sg_is_last(sg)		((sg)->page_link & SG_END)
 #define sg_chain_ptr(sg)	\
@@ -61,8 +53,8 @@ static inline struct scatterlist *get_sgp(struct scatterlist **sgs, int i)
 	return sgp;
 }
 
-int config = 0;
-int result = 0;
+int g_config = 0;
+int g_result = 0;
 
 SEC("kprobe/virtqueue_add_sgs")
 int BPF_KPROBE(trace_virtqueue_add_sgs, void *unused, struct scatterlist **sgs,
@@ -72,7 +64,7 @@ int BPF_KPROBE(trace_virtqueue_add_sgs, void *unused, struct scatterlist **sgs,
 	__u64 length1 = 0, length2 = 0;
 	unsigned int i, n, len;
 
-	if (config != 0)
+	if (g_config != 0)
 		return 0;
 
 	for (i = 0; (i < VIRTIO_MAX_SGS) && (i < out_sgs); i++) {
@@ -93,7 +85,7 @@ int BPF_KPROBE(trace_virtqueue_add_sgs, void *unused, struct scatterlist **sgs,
 		}
 	}
 
-	config = 1;
-	result = length2 - length1;
+	g_config = 1;
+	g_result = length2 - length1;
 	return 0;
 }
diff --git a/tools/testing/selftests/bpf/progs/test_overhead.c b/tools/testing/selftests/bpf/progs/test_overhead.c
index abb7344b531f..df035e6a3143 100644
--- a/tools/testing/selftests/bpf/progs/test_overhead.c
+++ b/tools/testing/selftests/bpf/progs/test_overhead.c
@@ -1,14 +1,10 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c) 2019 Facebook */
-#include <stdbool.h>
-#include <stddef.h>
-#include <linux/bpf.h>
-#include <linux/ptrace.h>
+
+#include "vmlinux.h"
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_tracing.h>
 
-struct task_struct;
-
 SEC("kprobe/__set_task_comm")
 int BPF_KPROBE(prog1, struct task_struct *tsk, const char *buf, bool exec)
 {
diff --git a/tools/testing/selftests/bpf/progs/test_probe_user.c b/tools/testing/selftests/bpf/progs/test_probe_user.c
index 8812a90da4eb..bf6c0b864ace 100644
--- a/tools/testing/selftests/bpf/progs/test_probe_user.c
+++ b/tools/testing/selftests/bpf/progs/test_probe_user.c
@@ -1,10 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 
-#include <linux/ptrace.h>
-#include <linux/bpf.h>
-
-#include <netinet/in.h>
-
+#include "vmlinux.h"
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_tracing.h>
 
-- 
2.25.1

