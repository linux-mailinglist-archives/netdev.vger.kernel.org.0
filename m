Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C61B46BED0F
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 16:33:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231280AbjCQPdg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 11:33:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230212AbjCQPde (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 11:33:34 -0400
Received: from frasgout12.his.huawei.com (frasgout12.his.huawei.com [14.137.139.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 594C0C3CEB;
        Fri, 17 Mar 2023 08:33:04 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.18.147.228])
        by frasgout12.his.huawei.com (SkyGuard) with ESMTP id 4PdRkC08qjz9xGYt;
        Fri, 17 Mar 2023 22:45:07 +0800 (CST)
Received: from huaweicloud.com (unknown [10.204.63.22])
        by APP2 (Coremail) with SMTP id GxC2BwBnOWDafhRkaQemAQ--.41316S6;
        Fri, 17 Mar 2023 15:54:17 +0100 (CET)
From:   Roberto Sassu <roberto.sassu@huaweicloud.com>
To:     corbet@lwn.net, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        sdf@google.com, haoluo@google.com, jolsa@kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, dsahern@kernel.org, shuah@kernel.org,
        brauner@kernel.org
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, ebiederm@xmission.com,
        mcgrof@kernel.org, Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH 4/5] selftests/umd_mgmt: Add selftests for UMD management library
Date:   Fri, 17 Mar 2023 15:52:39 +0100
Message-Id: <20230317145240.363908-5-roberto.sassu@huaweicloud.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230317145240.363908-1-roberto.sassu@huaweicloud.com>
References: <20230317145240.363908-1-roberto.sassu@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: GxC2BwBnOWDafhRkaQemAQ--.41316S6
X-Coremail-Antispam: 1UD129KBjvAXoWfXr17tr4rXF4UGw1kAFyUAwb_yoW8JFyfuo
        ZxGrs8Wr409347Aw13Wr4xJrWxW393KF17JF1rW3yrJF9rAayYkryUCw13Zr4Svr4rZa40
        vF1qva1xJayrXr1kn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
        AaLaJ3UjIYCTnIWjp_UUUOo7kC6x804xWl14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK
        8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF
        0E3s1l82xGYIkIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vE
        j48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7CjxV
        AFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26r4j6F4UM28EF7xvwVC2z280aVCY1x02
        67AKxVW8Jr0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F4
        0Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC
        6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxV
        Aaw2AFwI0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2Iq
        xVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r
        4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY
        6xkF7I0E14v26r4UJVWxJr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2js
        IE14v26r4j6F4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIYCTnIWIevJa73UjIF
        yTuYvjxUI-eODUUUU
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAgATBF1jj4asxgAFsN
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roberto Sassu <roberto.sassu@huawei.com>

Introduce a simple UMD driver using the management library, for testing
purposes.

UMD Manager: sample_mgr.c
UMD Loader: sample_loader.c
UMD Handler: sample_handler.c

The UMD Manager exposes /sys/kernel/security/sample_umd and accepts an
offset between 0-128K. It invokes the UMD Loader to start the UMD Handler
and passes to the latter the offset at which it sets the byte of the
response buffer to 1. The UMD Manager verifies that and returns the number
of bytes written on success, a negative value on failure.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 MAINTAINERS                                   |   1 +
 tools/testing/selftests/Makefile              |   1 +
 tools/testing/selftests/umd_mgmt/.gitignore   |   1 +
 tools/testing/selftests/umd_mgmt/Makefile     |  14 ++
 tools/testing/selftests/umd_mgmt/config       |   1 +
 .../selftests/umd_mgmt/sample_umd/Makefile    |  22 ++++
 .../selftests/umd_mgmt/sample_umd/msgfmt.h    |  13 ++
 .../umd_mgmt/sample_umd/sample_binary_blob.S  |   7 +
 .../umd_mgmt/sample_umd/sample_handler.c      |  81 ++++++++++++
 .../umd_mgmt/sample_umd/sample_loader.c       |  28 ++++
 .../umd_mgmt/sample_umd/sample_mgr.c          | 124 ++++++++++++++++++
 tools/testing/selftests/umd_mgmt/umd_mgmt.sh  |  40 ++++++
 12 files changed, 333 insertions(+)
 create mode 100644 tools/testing/selftests/umd_mgmt/.gitignore
 create mode 100644 tools/testing/selftests/umd_mgmt/Makefile
 create mode 100644 tools/testing/selftests/umd_mgmt/config
 create mode 100644 tools/testing/selftests/umd_mgmt/sample_umd/Makefile
 create mode 100644 tools/testing/selftests/umd_mgmt/sample_umd/msgfmt.h
 create mode 100644 tools/testing/selftests/umd_mgmt/sample_umd/sample_binary_blob.S
 create mode 100644 tools/testing/selftests/umd_mgmt/sample_umd/sample_handler.c
 create mode 100644 tools/testing/selftests/umd_mgmt/sample_umd/sample_loader.c
 create mode 100644 tools/testing/selftests/umd_mgmt/sample_umd/sample_mgr.c
 create mode 100755 tools/testing/selftests/umd_mgmt/umd_mgmt.sh

diff --git a/MAINTAINERS b/MAINTAINERS
index 7b27435fd20..a0cd161843e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11251,6 +11251,7 @@ L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	include/linux/usermode_driver_mgmt.h
 F:	kernel/usermode_driver_mgmt.c
+F:	tools/testing/selftests/umd_mgmt/*
 
 KERNEL VIRTUAL MACHINE (KVM)
 M:	Paolo Bonzini <pbonzini@redhat.com>
diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 13a6837a0c6..84202d5b4fb 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -84,6 +84,7 @@ TARGETS += timers
 endif
 TARGETS += tmpfs
 TARGETS += tpm2
+TARGETS += umd_mgmt
 TARGETS += user
 TARGETS += vDSO
 TARGETS += mm
diff --git a/tools/testing/selftests/umd_mgmt/.gitignore b/tools/testing/selftests/umd_mgmt/.gitignore
new file mode 100644
index 00000000000..215c17d13e9
--- /dev/null
+++ b/tools/testing/selftests/umd_mgmt/.gitignore
@@ -0,0 +1 @@
+/sample_umd/sample_umh
diff --git a/tools/testing/selftests/umd_mgmt/Makefile b/tools/testing/selftests/umd_mgmt/Makefile
new file mode 100644
index 00000000000..f1d47eec04e
--- /dev/null
+++ b/tools/testing/selftests/umd_mgmt/Makefile
@@ -0,0 +1,14 @@
+# SPDX-License-Identifier: GPL-2.0
+TEST_GEN_PROGS_EXTENDED = sample_umd.ko
+
+$(OUTPUT)/%.ko: $(wildcard sample_umd/Makefile sample_umd/*.[ch])
+	$(call msg,MOD,,$@)
+	$(Q)$(MAKE) -C sample_umd install
+
+OVERRIDE_TARGETS := 1
+override define CLEAN
+	$(call msg,CLEAN)
+	$(Q)$(MAKE) -C sample_umd clean
+endef
+
+include ../lib.mk
diff --git a/tools/testing/selftests/umd_mgmt/config b/tools/testing/selftests/umd_mgmt/config
new file mode 100644
index 00000000000..71a078a3ac0
--- /dev/null
+++ b/tools/testing/selftests/umd_mgmt/config
@@ -0,0 +1 @@
+CONFIG_BPFILTER=y
diff --git a/tools/testing/selftests/umd_mgmt/sample_umd/Makefile b/tools/testing/selftests/umd_mgmt/sample_umd/Makefile
new file mode 100644
index 00000000000..6d950e05f3d
--- /dev/null
+++ b/tools/testing/selftests/umd_mgmt/sample_umd/Makefile
@@ -0,0 +1,22 @@
+KDIR ?= ../../../../..
+
+userprogs := sample_umh
+sample_umh-objs := sample_handler.o
+userccflags += -I $(srctree)
+
+$(obj)/sample_binary_blob.o: $(obj)/sample_umh
+
+MODULES = sample_loader_kmod.ko sample_mgr.ko
+
+obj-m += sample_loader_kmod.o sample_mgr.o
+
+sample_loader_kmod-objs = sample_loader.o sample_binary_blob.o
+
+all:
+	+$(Q)$(MAKE) -C $(KDIR) M=$$PWD modules
+
+clean:
+	+$(Q)$(MAKE) -C $(KDIR) M=$$PWD clean
+
+install: all
+	+$(Q)$(MAKE) -C $(KDIR) M=$$PWD modules_install
diff --git a/tools/testing/selftests/umd_mgmt/sample_umd/msgfmt.h b/tools/testing/selftests/umd_mgmt/sample_umd/msgfmt.h
new file mode 100644
index 00000000000..34a62d72cde
--- /dev/null
+++ b/tools/testing/selftests/umd_mgmt/sample_umd/msgfmt.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _SAMPLE_UMH_MSGFMT_H
+#define _SAMPLE_UMH_MSGFMT_H
+
+struct sample_request {
+	uint32_t offset;
+};
+
+struct sample_reply {
+	uint8_t data[128 * 1024];
+};
+
+#endif
diff --git a/tools/testing/selftests/umd_mgmt/sample_umd/sample_binary_blob.S b/tools/testing/selftests/umd_mgmt/sample_umd/sample_binary_blob.S
new file mode 100644
index 00000000000..3687dd13973
--- /dev/null
+++ b/tools/testing/selftests/umd_mgmt/sample_umd/sample_binary_blob.S
@@ -0,0 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+	.section .init.rodata, "a"
+	.global sample_umh_start
+sample_umh_start:
+	.incbin "tools/testing/selftests/umd_mgmt/sample_umd/sample_umh"
+	.global sample_umh_end
+sample_umh_end:
diff --git a/tools/testing/selftests/umd_mgmt/sample_umd/sample_handler.c b/tools/testing/selftests/umd_mgmt/sample_umd/sample_handler.c
new file mode 100644
index 00000000000..94ea6d99bbc
--- /dev/null
+++ b/tools/testing/selftests/umd_mgmt/sample_umd/sample_handler.c
@@ -0,0 +1,81 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2023 Huawei Technologies Duesseldorf GmbH
+ *
+ * Author: Roberto Sassu <roberto.sassu@huawei.com>
+ *
+ * Implement the UMD Handler.
+ */
+#include <unistd.h>
+#include <malloc.h>
+#include <stdint.h>
+
+#include "msgfmt.h"
+
+FILE *debug_f;
+
+static void loop(void)
+{
+	struct sample_request *req = NULL;
+	struct sample_reply *reply = NULL;
+
+	req = calloc(1, sizeof(*req));
+	if (!req)
+		return;
+
+	reply = calloc(1, sizeof(*reply));
+	if (!reply)
+		goto out;
+
+	while (1) {
+		int n, len, offset;
+
+		offset = 0;
+		len = sizeof(*req);
+
+		while (len) {
+			n = read(0, ((void *)req) + offset, len);
+			if (n <= 0) {
+				fprintf(debug_f, "invalid request %d\n", n);
+				goto out;
+			}
+
+			len -= n;
+			offset += n;
+		}
+
+		if (req->offset < sizeof(reply->data))
+			reply->data[req->offset] = 1;
+
+		offset = 0;
+		len = sizeof(*reply);
+
+		while (len) {
+			n = write(1, ((void *)reply) + offset, len);
+			if (n <= 0) {
+				fprintf(debug_f, "reply failed %d\n", n);
+				goto out;
+			}
+
+			len -= n;
+			offset += n;
+		}
+
+		if (req->offset < sizeof(reply->data))
+			reply->data[req->offset] = 0;
+	}
+out:
+	free(req);
+	free(reply);
+}
+
+int main(void)
+{
+	debug_f = fopen("/dev/kmsg", "w");
+	setvbuf(debug_f, 0, _IOLBF, 0);
+	fprintf(debug_f, "<5>Started sample_umh\n");
+	loop();
+	fclose(debug_f);
+
+	return 0;
+}
diff --git a/tools/testing/selftests/umd_mgmt/sample_umd/sample_loader.c b/tools/testing/selftests/umd_mgmt/sample_umd/sample_loader.c
new file mode 100644
index 00000000000..36c0e69e3f7
--- /dev/null
+++ b/tools/testing/selftests/umd_mgmt/sample_umd/sample_loader.c
@@ -0,0 +1,28 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2023 Huawei Technologies Duesseldorf GmbH
+ *
+ * Author: Roberto Sassu <roberto.sassu@huawei.com>
+ *
+ * Implement the UMD Loader (credits: bpfilter).
+ */
+#include <linux/module.h>
+#include <linux/usermode_driver_mgmt.h>
+
+extern char sample_umh_start;
+extern char sample_umh_end;
+extern struct umd_mgmt sample_mgmt_ops;
+
+static int __init load_umh(void)
+{
+	return umd_mgmt_load(&sample_mgmt_ops, &sample_umh_start,
+			     &sample_umh_end);
+}
+
+static void __exit fini_umh(void)
+{
+	umd_mgmt_unload(&sample_mgmt_ops);
+}
+module_init(load_umh);
+module_exit(fini_umh);
+MODULE_LICENSE("GPL");
diff --git a/tools/testing/selftests/umd_mgmt/sample_umd/sample_mgr.c b/tools/testing/selftests/umd_mgmt/sample_umd/sample_mgr.c
new file mode 100644
index 00000000000..75c572f9849
--- /dev/null
+++ b/tools/testing/selftests/umd_mgmt/sample_umd/sample_mgr.c
@@ -0,0 +1,124 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2023 Huawei Technologies Duesseldorf GmbH
+ *
+ * Author: Roberto Sassu <roberto.sassu@huawei.com>
+ *
+ * Implement the UMD Manager.
+ */
+#include <linux/module.h>
+#include <linux/security.h>
+#include <linux/seq_file.h>
+#include <linux/usermode_driver_mgmt.h>
+
+#include "msgfmt.h"
+
+struct umd_mgmt sample_mgmt_ops;
+EXPORT_SYMBOL_GPL(sample_mgmt_ops);
+
+struct dentry *sample_umd_dentry;
+
+static int sample_write_common(u32 offset, bool test)
+{
+	struct sample_request *req;
+	struct sample_reply *reply;
+	int ret;
+
+	req = kzalloc(sizeof(*req), GFP_KERNEL);
+	if (!req) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	reply = kzalloc(sizeof(*reply), GFP_KERNEL);
+	if (!reply) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	req->offset = offset;
+
+	if (test)
+		/* Lock is already taken. */
+		ret = umd_send_recv(&sample_mgmt_ops.info, req, sizeof(*req),
+				    reply, sizeof(*reply));
+	else
+		ret = umd_mgmt_send_recv(&sample_mgmt_ops, req, sizeof(*req),
+					 reply, sizeof(*reply));
+	if (ret < 0)
+		goto out;
+
+	if (reply->data[req->offset] != 1) {
+		ret = -EINVAL;
+		goto out;
+	}
+out:
+	kfree(req);
+	kfree(reply);
+
+	return ret;
+}
+
+static ssize_t sample_umd_write(struct file *file, const char __user *buf,
+				size_t datalen, loff_t *ppos)
+{
+	char offset_str[8];
+	u32 offset;
+	int ret;
+
+	if (datalen >= sizeof(offset_str))
+		return -EINVAL;
+
+	ret = copy_from_user(offset_str, buf, datalen);
+	if (ret < 0)
+		return ret;
+
+	offset_str[datalen] = '\0';
+
+	ret = kstrtou32(offset_str, 10, &offset);
+	if (ret < 0)
+		return ret;
+
+	if (offset >= sizeof(((struct sample_reply *)0)->data))
+		return -EINVAL;
+
+	ret = sample_write_common(offset, false);
+	if (ret < 0)
+		return ret;
+
+	return datalen;
+}
+
+static const struct file_operations sample_umd_file_ops = {
+	.write = sample_umd_write,
+};
+
+static int sample_post_start_umh(struct umd_mgmt *mgmt)
+{
+	return sample_write_common(0, true);
+}
+
+static int __init load_umh(void)
+{
+	mutex_init(&sample_mgmt_ops.lock);
+	sample_mgmt_ops.info.tgid = NULL;
+	sample_mgmt_ops.info.driver_name = "sample_umh";
+	sample_mgmt_ops.post_start = sample_post_start_umh;
+	sample_mgmt_ops.kmod = "sample_loader_kmod";
+	sample_mgmt_ops.kmod_loaded = false;
+
+	sample_umd_dentry = securityfs_create_file("sample_umd", 0200, NULL,
+						   NULL, &sample_umd_file_ops);
+	if (IS_ERR(sample_umd_dentry))
+		return PTR_ERR(sample_umd_dentry);
+
+	return 0;
+}
+
+static void __exit fini_umh(void)
+{
+	securityfs_remove(sample_umd_dentry);
+}
+module_init(load_umh);
+module_exit(fini_umh);
+MODULE_LICENSE("GPL");
diff --git a/tools/testing/selftests/umd_mgmt/umd_mgmt.sh b/tools/testing/selftests/umd_mgmt/umd_mgmt.sh
new file mode 100755
index 00000000000..9b90d737fec
--- /dev/null
+++ b/tools/testing/selftests/umd_mgmt/umd_mgmt.sh
@@ -0,0 +1,40 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# Copyright (C) 2023 Huawei Technologies Duesseldorf GmbH
+#
+# Author: Roberto Sassu <roberto.sassu@huawei.com>
+#
+# Script to test the UMD management library.
+
+# Kselftest framework defines: ksft_pass=0, ksft_fail=1, ksft_skip=4
+ksft_pass=0
+ksft_fail=1
+ksft_skip=4
+
+if ! /sbin/modprobe -q sample_mgr; then
+	echo "umd_mgmt: module sample_mgr is not found [SKIP]"
+	exit $ksft_skip
+fi
+
+if [ ! -f /sys/kernel/security/sample_umd ]; then
+	echo "umd_mgmt: kernel interface is not found [SKIP]"
+	exit $ksft_skip
+fi
+
+i=0
+
+while [ $i -lt 500 ]; do
+	if ! echo $(( RANDOM % 128 * 1024 )) > /sys/kernel/security/sample_umd; then
+		echo "umd_mgmt: test failed"
+		exit $ksft_fail
+	fi
+
+	if [ $(( i % 50 )) -eq 0 ]; then
+		rmmod sample_loader_kmod
+	fi
+
+	(( i++ ))
+done
+
+exit $ksft_pass
-- 
2.25.1

