Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE8568C107
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 20:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727960AbfHMSsL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 14:48:11 -0400
Received: from mail-vs1-f67.google.com ([209.85.217.67]:41482 "EHLO
        mail-vs1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727144AbfHMSsK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 14:48:10 -0400
Received: by mail-vs1-f67.google.com with SMTP id 2so72836533vso.8;
        Tue, 13 Aug 2019 11:48:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=eSAARjEMPupgKmyheSmLIvfMqyHiGuzKrhRRE7cCpsU=;
        b=JHlYBXKKSzESBW7ZJV6oU6oUkdBl5Cn9dsqxthYHbFoToXi51ZZYUcRttpIEK1TMVy
         b6bACnVIDwEU9EgKZEdeHuYtEPcYUlrnxo+aVsS6vdSTjjaTzNVRm/lMyRK4uAFe5EeK
         fVWUUZ4VqVvQi8d9tP/gGJIkc/aHprvr4DSNy1gqe1WbEn/BDWJserQxzjy/dPaVKRa0
         XbYWITZC2qLV485CDXeuwk6xYr/XqeMt8wfPuzkEmh3SxhQ0DdkDOrMUCOYGfLhH+d8+
         B1ArfWh0cuN18oBc8LxXG9BVNRCVIfSOr9IJS3oeIGtIciPXBHgz0YF2TUyoAF4tnNIP
         jKqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=eSAARjEMPupgKmyheSmLIvfMqyHiGuzKrhRRE7cCpsU=;
        b=J0i3o3kAVnBciCBz/x57dJJ5b0dCXuM3DYPnimx/mfYdyYa1AHxX0UdRsYx6jFPCzb
         AbjjeOsf7bfU+MTCGtoSNpJPeJLlw6amUhhTbKrmBm61X93yrpY9okX/rM5jzoxS+Lgd
         Cdg/FeM4py0hHRt/UVy4EXGI51y8cx9oYoZRfhlqMf5CckAngkFerOcuj1fTJIZJig1z
         O/KA40sqtFbsqfqYzQg9fPnGs9s+l5VL7h1c/zyg2V/ALpIKDsSZRtBdMKrLA0CvJ/6r
         j7bxDH2VMiBsoaFI5SlvN0d5kIZqpTmwhQbmNjgcqN+s3xzAMLD00iQBlYRqhbj0FAtu
         Staw==
X-Gm-Message-State: APjAAAVR/ILMyH3ZHc/KfM4Xo2eHlKoePXVedSkkcbjVKu9VXghGi0hn
        yPCxbHz2yyjIN4jbXUUZNA6I7H5KHXGL5w==
X-Google-Smtp-Source: APXvYqyi7qV7u8wRP8QkUJamBRcHam4DCVCpVOrih3gPiCZ7Wr653OEmfd0AiOXKzQlAQpSvlC/fhg==
X-Received: by 2002:a67:ea44:: with SMTP id r4mr28426631vso.86.1565722088278;
        Tue, 13 Aug 2019 11:48:08 -0700 (PDT)
Received: from localhost.localdomain ([190.162.109.53])
        by smtp.googlemail.com with ESMTPSA id o9sm71767069vkd.27.2019.08.13.11.48.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Aug 2019 11:48:07 -0700 (PDT)
From:   Carlos Neira <cneirabustos@gmail.com>
To:     netdev@vger.kernel.org
Cc:     yhs@fb.com, ebiederm@xmission.com, brouer@redhat.com,
        cneirabustos@gmail.com, bpf@vger.kernel.org
Subject: [PATCH bpf-next V9 2/3] samples/bpf: added sample code for bpf_get_current_pidns_info.
Date:   Tue, 13 Aug 2019 11:47:46 -0700
Message-Id: <20190813184747.12225-3-cneirabustos@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190813184747.12225-1-cneirabustos@gmail.com>
References: <20190813184747.12225-1-cneirabustos@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Carlos <cneirabustos@gmail.com>

sample program to call new bpf helper bpf_get_current_pidns_info.

Signed-off-by: Carlos Neira <cneirabustos@gmail.com>
---
 samples/bpf/Makefile                  |  3 +++
 samples/bpf/trace_ns_info_user.c      | 35 ++++++++++++++++++++++++++++
 samples/bpf/trace_ns_info_user_kern.c | 44 +++++++++++++++++++++++++++++++++++
 3 files changed, 82 insertions(+)
 create mode 100644 samples/bpf/trace_ns_info_user.c
 create mode 100644 samples/bpf/trace_ns_info_user_kern.c

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 1d9be26b4edd..238453ff27d2 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -53,6 +53,7 @@ hostprogs-y += task_fd_query
 hostprogs-y += xdp_sample_pkts
 hostprogs-y += ibumad
 hostprogs-y += hbm
+hostprogs-y += trace_ns_info
 
 # Libbpf dependencies
 LIBBPF = $(TOOLS_PATH)/lib/bpf/libbpf.a
@@ -109,6 +110,7 @@ task_fd_query-objs := bpf_load.o task_fd_query_user.o $(TRACE_HELPERS)
 xdp_sample_pkts-objs := xdp_sample_pkts_user.o $(TRACE_HELPERS)
 ibumad-objs := bpf_load.o ibumad_user.o $(TRACE_HELPERS)
 hbm-objs := bpf_load.o hbm.o $(CGROUP_HELPERS)
+trace_ns_info-objs := bpf_load.o trace_ns_info_user.o
 
 # Tell kbuild to always build the programs
 always := $(hostprogs-y)
@@ -170,6 +172,7 @@ always += xdp_sample_pkts_kern.o
 always += ibumad_kern.o
 always += hbm_out_kern.o
 always += hbm_edt_kern.o
+always += trace_ns_info_user_kern.o
 
 KBUILD_HOSTCFLAGS += -I$(objtree)/usr/include
 KBUILD_HOSTCFLAGS += -I$(srctree)/tools/lib/bpf/
diff --git a/samples/bpf/trace_ns_info_user.c b/samples/bpf/trace_ns_info_user.c
new file mode 100644
index 000000000000..e06d08db6f30
--- /dev/null
+++ b/samples/bpf/trace_ns_info_user.c
@@ -0,0 +1,35 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2018 Carlos Neira cneirabustos@gmail.com
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of version 2 of the GNU General Public
+ * License as published by the Free Software Foundation.
+ */
+
+#include <stdio.h>
+#include <linux/bpf.h>
+#include <unistd.h>
+#include "bpf/libbpf.h"
+#include "bpf_load.h"
+
+/* This code was taken verbatim from tracex1_user.c, it's used
+ * to exercize bpf_get_current_pidns_info() helper call.
+ */
+int main(int ac, char **argv)
+{
+	FILE *f;
+	char filename[256];
+
+	snprintf(filename, sizeof(filename), "%s_user_kern.o", argv[0]);
+	printf("loading %s\n", filename);
+
+	if (load_bpf_file(filename)) {
+		printf("%s", bpf_log_buf);
+		return 1;
+	}
+
+	f = popen("taskset 1 ping  localhost", "r");
+	(void) f;
+	read_trace_pipe();
+	return 0;
+}
diff --git a/samples/bpf/trace_ns_info_user_kern.c b/samples/bpf/trace_ns_info_user_kern.c
new file mode 100644
index 000000000000..96675e02b707
--- /dev/null
+++ b/samples/bpf/trace_ns_info_user_kern.c
@@ -0,0 +1,44 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2018 Carlos Neira cneirabustos@gmail.com
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of version 2 of the GNU General Public
+ * License as published by the Free Software Foundation.
+ */
+#include <linux/skbuff.h>
+#include <linux/netdevice.h>
+#include <linux/version.h>
+#include <uapi/linux/bpf.h>
+#include "bpf_helpers.h"
+
+typedef __u64 u64;
+typedef __u32 u32;
+
+
+/* kprobe is NOT a stable ABI
+ * kernel functions can be removed, renamed or completely change semantics.
+ * Number of arguments and their positions can change, etc.
+ * In such case this bpf+kprobe example will no longer be meaningful
+ */
+
+/* This will call bpf_get_current_pidns_info() to display pid and ns values
+ * as seen by the current namespace, on the far left you will see the pid as
+ * seen as by the root namespace.
+ */
+
+SEC("kprobe/__netif_receive_skb_core")
+int bpf_prog1(struct pt_regs *ctx)
+{
+	char fmt[] = "nsid:%u, dev: %u,  pid:%u\n";
+	struct bpf_pidns_info nsinfo;
+	int ok = 0;
+
+	ok = bpf_get_current_pidns_info(&nsinfo, sizeof(nsinfo));
+	if (ok == 0)
+		bpf_trace_printk(fmt, sizeof(fmt), (u32)nsinfo.nsid,
+				 (u32) nsinfo.dev, (u32)nsinfo.pid);
+
+	return 0;
+}
+char _license[] SEC("license") = "GPL";
+u32 _version SEC("version") = LINUX_VERSION_CODE;
-- 
2.11.0

