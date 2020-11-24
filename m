Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A89B62C20C8
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 10:05:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731008AbgKXJDg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 04:03:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730964AbgKXJDa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 04:03:30 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D990C0613D6;
        Tue, 24 Nov 2020 01:03:30 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id l17so6431610pgk.1;
        Tue, 24 Nov 2020 01:03:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tcGrIg4lu2Vq+X0LFqj+xsS0QCmfTMGdXi+7qZxwkTA=;
        b=l4fqB+xTJT0Qg+BoJcSDCFUaexwAKrtxwSbylm6jQ3ubeb/vnf0Jx0NJTIPxqczuy8
         7x9gqIZT8RbnhUQ4R5DqU4ZudplkxbdfeC2V0KyrdddGkZF3vtp51pl4cwL0sWmN+D5r
         y1Z8HIDjJxccUbJr+38LS+S9KljUAy91tnqrNq89wDXXfXOGFQlOraKso8MP0VL+KZML
         DhjjqQ60npvEwAYKYxaCyHQCJNpGWDORgOgmSkZAOjWYdOFzFWXD62P+A0CcHHK5bZyU
         uyh55LI20X3VaZV+WhK7w6bFWXDdCLoePnau00NwXsm4Zasu1LeCkJcgGRiC8mV9FaPu
         u0SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tcGrIg4lu2Vq+X0LFqj+xsS0QCmfTMGdXi+7qZxwkTA=;
        b=KYzYwHmma36gojpJe+mhMySdFlu2TpZR70h6DRdyp+D42K9KoQNqdUd1GenmmQpw85
         NYNqm2sU9qOPmT3rk9q+VDCszqqcq8h8RmuzgtLHJdHQ+afJ+vf9iZlZwsXzCnD7Qrzg
         A5kQ5u61WRXeE7Ua33MtN4s9FebbEDhq792Hm6OzqW2l9FxxH2ixGiWX5qoopHOgdSdZ
         RX6IM0rehcR92SLjlTBfBXGmrYgp446XTUeb+WNjBLDg21zhNNx6ehrVVrq2OREW82MF
         Wdr4Om4blyjVOoU+3HzDbBdRKb53IttxlHsR1kwEzuk2ejYGM17Jnz0P1a/ohaLBkIQD
         feNQ==
X-Gm-Message-State: AOAM533WbJ4FqDz9oz9Wh3XiCGffow99Rw5fio06DWEGxgAcBR5F4rIM
        PoKwtTM1cJj+EFetdnxrBA==
X-Google-Smtp-Source: ABdhPJydCXk26i1WIoolNcw04eXudgHPOJOGFvzo+4U3C+C/O8VxGySPp9uT2AolGq2Xm0nQoRcKcA==
X-Received: by 2002:aa7:9387:0:b029:18b:42dd:41c with SMTP id t7-20020aa793870000b029018b42dd041cmr3178209pfe.60.1606208610087;
        Tue, 24 Nov 2020 01:03:30 -0800 (PST)
Received: from localhost.localdomain ([182.209.58.45])
        by smtp.gmail.com with ESMTPSA id n68sm14084345pfn.161.2020.11.24.01.03.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2020 01:03:29 -0800 (PST)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, brakmo <brakmo@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        David Ahern <dsa@cumulusnetworks.com>,
        Yonghong Song <yhs@fb.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Ira Weiny <ira.weiny@intel.com>, Thomas Graf <tgraf@suug.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Xdp <xdp-newbies@vger.kernel.org>
Subject: [PATCH bpf-next v3 2/7] samples: bpf: refactor test_cgrp2_sock2 program with libbpf
Date:   Tue, 24 Nov 2020 09:03:05 +0000
Message-Id: <20201124090310.24374-3-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201124090310.24374-1-danieltimlee@gmail.com>
References: <20201124090310.24374-1-danieltimlee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit refactors the existing cgroup program with libbpf bpf
loader. The original test_cgrp2_sock2 has keeped the bpf program
attached to the cgroup hierarchy even after the exit of user program.
To implement the same functionality with libbpf, this commit uses the
BPF_LINK_PINNING to pin the link attachment even after it is closed.

Since this uses LINK instead of ATTACH, detach of bpf program from
cgroup with 'test_cgrp2_sock' is not used anymore.

The code to mount the bpf was added to the .sh file in case the bpff
was not mounted on /sys/fs/bpf. Additionally, to fix the problem that
shell script cannot find the binary object from the current path,
relative path './' has been added in front of binary.

Fixes: 554ae6e792ef3 ("samples/bpf: add userspace example for prohibiting sockets")
Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
Changes in v2:
 - change to destroy link even after link__pin()
 - enhance error message
 
 samples/bpf/Makefile            |  2 +-
 samples/bpf/test_cgrp2_sock2.c  | 61 ++++++++++++++++++++++++---------
 samples/bpf/test_cgrp2_sock2.sh | 21 +++++++++---
 3 files changed, 62 insertions(+), 22 deletions(-)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 7c61118525f7..d31e082c369e 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -82,7 +82,7 @@ test_overhead-objs := bpf_load.o test_overhead_user.o
 test_cgrp2_array_pin-objs := test_cgrp2_array_pin.o
 test_cgrp2_attach-objs := test_cgrp2_attach.o
 test_cgrp2_sock-objs := test_cgrp2_sock.o
-test_cgrp2_sock2-objs := bpf_load.o test_cgrp2_sock2.o
+test_cgrp2_sock2-objs := test_cgrp2_sock2.o
 xdp1-objs := xdp1_user.o
 # reuse xdp1 source intentionally
 xdp2-objs := xdp1_user.o
diff --git a/samples/bpf/test_cgrp2_sock2.c b/samples/bpf/test_cgrp2_sock2.c
index a9277b118c33..e7060aaa2f5a 100644
--- a/samples/bpf/test_cgrp2_sock2.c
+++ b/samples/bpf/test_cgrp2_sock2.c
@@ -20,9 +20,9 @@
 #include <net/if.h>
 #include <linux/bpf.h>
 #include <bpf/bpf.h>
+#include <bpf/libbpf.h>
 
 #include "bpf_insn.h"
-#include "bpf_load.h"
 
 static int usage(const char *argv0)
 {
@@ -32,37 +32,64 @@ static int usage(const char *argv0)
 
 int main(int argc, char **argv)
 {
-	int cg_fd, ret, filter_id = 0;
+	int cg_fd, err, ret = EXIT_FAILURE, filter_id = 0, prog_cnt = 0;
+	const char *link_pin_path = "/sys/fs/bpf/test_cgrp2_sock2";
+	struct bpf_link *link = NULL;
+	struct bpf_program *progs[2];
+	struct bpf_program *prog;
+	struct bpf_object *obj;
 
 	if (argc < 3)
 		return usage(argv[0]);
 
+	if (argc > 3)
+		filter_id = atoi(argv[3]);
+
 	cg_fd = open(argv[1], O_DIRECTORY | O_RDONLY);
 	if (cg_fd < 0) {
 		printf("Failed to open cgroup path: '%s'\n", strerror(errno));
-		return EXIT_FAILURE;
+		return ret;
 	}
 
-	if (load_bpf_file(argv[2]))
-		return EXIT_FAILURE;
-
-	printf("Output from kernel verifier:\n%s\n-------\n", bpf_log_buf);
+	obj = bpf_object__open_file(argv[2], NULL);
+	if (libbpf_get_error(obj)) {
+		printf("ERROR: opening BPF object file failed\n");
+		return ret;
+	}
 
-	if (argc > 3)
-		filter_id = atoi(argv[3]);
+	bpf_object__for_each_program(prog, obj) {
+		progs[prog_cnt] = prog;
+		prog_cnt++;
+	}
 
 	if (filter_id >= prog_cnt) {
 		printf("Invalid program id; program not found in file\n");
-		return EXIT_FAILURE;
+		goto cleanup;
+	}
+
+	/* load BPF program */
+	if (bpf_object__load(obj)) {
+		printf("ERROR: loading BPF object file failed\n");
+		goto cleanup;
 	}
 
-	ret = bpf_prog_attach(prog_fd[filter_id], cg_fd,
-			      BPF_CGROUP_INET_SOCK_CREATE, 0);
-	if (ret < 0) {
-		printf("Failed to attach prog to cgroup: '%s'\n",
-		       strerror(errno));
-		return EXIT_FAILURE;
+	link = bpf_program__attach_cgroup(progs[filter_id], cg_fd);
+	if (libbpf_get_error(link)) {
+		printf("ERROR: bpf_program__attach failed\n");
+		link = NULL;
+		goto cleanup;
 	}
 
-	return EXIT_SUCCESS;
+	err = bpf_link__pin(link, link_pin_path);
+	if (err < 0) {
+		printf("ERROR: bpf_link__pin failed: %d\n", err);
+		goto cleanup;
+	}
+
+	ret = EXIT_SUCCESS;
+
+cleanup:
+	bpf_link__destroy(link);
+	bpf_object__close(obj);
+	return ret;
 }
diff --git a/samples/bpf/test_cgrp2_sock2.sh b/samples/bpf/test_cgrp2_sock2.sh
index 0f396a86e0cb..6a3dbe642b2b 100755
--- a/samples/bpf/test_cgrp2_sock2.sh
+++ b/samples/bpf/test_cgrp2_sock2.sh
@@ -1,6 +1,9 @@
 #!/bin/bash
 # SPDX-License-Identifier: GPL-2.0
 
+BPFFS=/sys/fs/bpf
+LINK_PIN=$BPFFS/test_cgrp2_sock2
+
 function config_device {
 	ip netns add at_ns0
 	ip link add veth0 type veth peer name veth0b
@@ -21,16 +24,22 @@ function config_cgroup {
 	echo $$ >> /tmp/cgroupv2/foo/cgroup.procs
 }
 
+function config_bpffs {
+	if mount | grep $BPFFS > /dev/null; then
+		echo "bpffs already mounted"
+	else
+		echo "bpffs not mounted. Mounting..."
+		mount -t bpf none $BPFFS
+	fi
+}
 
 function attach_bpf {
-	test_cgrp2_sock2 /tmp/cgroupv2/foo sock_flags_kern.o $1
+	./test_cgrp2_sock2 /tmp/cgroupv2/foo sock_flags_kern.o $1
 	[ $? -ne 0 ] && exit 1
 }
 
 function cleanup {
-	if [ -d /tmp/cgroupv2/foo ]; then
-		test_cgrp2_sock -d /tmp/cgroupv2/foo
-	fi
+	rm -rf $LINK_PIN
 	ip link del veth0b
 	ip netns delete at_ns0
 	umount /tmp/cgroupv2
@@ -42,6 +51,7 @@ cleanup 2>/dev/null
 set -e
 config_device
 config_cgroup
+config_bpffs
 set +e
 
 #
@@ -62,6 +72,9 @@ if [ $? -eq 0 ]; then
 	exit 1
 fi
 
+rm -rf $LINK_PIN
+sleep 1                 # Wait for link detach
+
 #
 # Test 2 - fail ping
 #
-- 
2.25.1

