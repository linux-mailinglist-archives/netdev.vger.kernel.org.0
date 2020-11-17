Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0185F2B6805
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 15:58:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731961AbgKQO5m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 09:57:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725779AbgKQO5l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 09:57:41 -0500
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63317C0613CF;
        Tue, 17 Nov 2020 06:57:41 -0800 (PST)
Received: by mail-pj1-x1041.google.com with SMTP id r9so579467pjl.5;
        Tue, 17 Nov 2020 06:57:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hNLmbGtRSRTodwyPLo1Qjw0giVAhsJ8X91yhlKjTtyA=;
        b=JCemuPV8165vXk40QY+wraWw4UABiltNB054EL56i6i3rzuNNCAWJalm5oxnJtguCq
         30YTUcVHyJSj62AD5MF85mQaP451fwyNtD+DeODaNFCK2VmNBDZy3GmwvzYStEluFUai
         iTFlmXPbgdccMk62VpBeVO5ehCZrINgzSeZIrmQPhldPfuI9BE1SBWge/3kxPB0EVGsX
         1r/hzvXr7o0p4b+imNI5GUSH/UKYn7XQZCk2LDIz6zOQOn+foHfEBX1Eoy+bZuyTcuEG
         r7M2hTNHkAp11uF5lxiAjccswEA7WGXlAwSn9cGkvXBMx982K9+060JSxv3Z/B6Fgh15
         G4sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hNLmbGtRSRTodwyPLo1Qjw0giVAhsJ8X91yhlKjTtyA=;
        b=kqDXVNrfyaPxWtvR9vI+TZukOHAjrWOBqS8jMd/W3Z1vUhwRYDY84EUspXOaYQnRhX
         q4ylTHEBrn99tl1GFKopp653RlD/fftha8T78/QgIc+RYQ8s3LzT7aenDaQr1JZXdHxE
         IIEWypaRlcwa71zQqdK/Bna7oYOD/InDepSwc77pwIQQuSVaSQ8BPCiIHkm/r9q01te/
         ISZ5JqxHoTCvu1Fjh/b6v3aqS4kLIEzOM8Tow8QWlLrdtHBECGCikxlaTn/p0dUiVdUE
         v8Y+tECOwFCS+jI81fT8LiptsEobNzv9pAuLv4F/10ZIoFt1gLS5bBs7WfOlnJBGzG4x
         cRDA==
X-Gm-Message-State: AOAM532vz0jYx07TJKvqJxvR2s8PYeejf+tqAITPRjNekYD11le1VEDS
        khEEjSsXtCF/AOmAmu2kGg==
X-Google-Smtp-Source: ABdhPJwKnmz1mHk0MMMNKqOVyeiGhMEjTlEWe2bgl+tWakNPcjafAWytRJXH0gjNBfsNC8Cw9kLGIA==
X-Received: by 2002:a17:90a:4a15:: with SMTP id e21mr4831216pjh.130.1605625060953;
        Tue, 17 Nov 2020 06:57:40 -0800 (PST)
Received: from localhost.localdomain ([182.209.58.45])
        by smtp.gmail.com with ESMTPSA id q13sm3517981pjq.15.2020.11.17.06.57.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2020 06:57:40 -0800 (PST)
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
Subject: [PATCH bpf-next 3/9] samples: bpf: refactor test_cgrp2_sock2 program with libbpf
Date:   Tue, 17 Nov 2020 14:56:38 +0000
Message-Id: <20201117145644.1166255-4-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201117145644.1166255-1-danieltimlee@gmail.com>
References: <20201117145644.1166255-1-danieltimlee@gmail.com>
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

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
 samples/bpf/Makefile            |  2 +-
 samples/bpf/test_cgrp2_sock2.c  | 63 ++++++++++++++++++++++++---------
 samples/bpf/test_cgrp2_sock2.sh | 21 ++++++++---
 3 files changed, 64 insertions(+), 22 deletions(-)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 01449d767122..7a643595ac6c 100644
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
index a9277b118c33..518526c7ce16 100644
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
@@ -32,37 +32,66 @@ static int usage(const char *argv0)
 
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
+		printf("err : %d\n", err);
+		goto cleanup;
+	}
+
+	ret = EXIT_SUCCESS;
+
+cleanup:
+	if (ret != EXIT_SUCCESS)
+		bpf_link__destroy(link);
+
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

