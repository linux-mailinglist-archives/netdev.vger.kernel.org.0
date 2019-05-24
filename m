Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7F282A135
	for <lists+netdev@lfdr.de>; Sat, 25 May 2019 00:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404478AbfEXW1i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 18:27:38 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40441 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404451AbfEXW1f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 18:27:35 -0400
Received: by mail-wr1-f68.google.com with SMTP id t4so3110813wrx.7
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 15:27:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=wRX9/jzDizCQ0U66+3aK5XwNle8a0Yl23jxfFGFWTyY=;
        b=fZlMr2JCbu4U0+Utu0WdU08nJ0YDVsRLL+7fLgXqUyTE8avm0ONHdAc4Ja3NEy1As6
         gsbi/qAYfXjHrWpw9ZQni9r3c/1Vbn69mb8iw4NU9pzukysbvNfZOfFI/MhOgihucGik
         RPb+zwWlFcnJVQ4JZYz27fD1AyQQ47XB7zgZGC4GrKG/f3Qdum7OfQIjVndX7VaQXtuy
         khgyNzf91uE6ZB/9/EJZULgnuQ9adZqVfvD4h63eHlti+uE6cv/NoaEI2nHW9J9vDqkn
         GfyjKEaTK4n4ziSQAsWg5UrzpF9WtC35wLdn4n07t+rWYmDmbVPJjJdS7oz4ARxetbkp
         CF+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=wRX9/jzDizCQ0U66+3aK5XwNle8a0Yl23jxfFGFWTyY=;
        b=oM37sMJz2CXWBDCxZg8whPue053ttRC8vFsLs/Z1mVR+p1d2gLp+oXDGWmNGIaX+gs
         TptjCWDo0x6D+kulGE4tSbi7slD5hM58KXwcocYhCI0zTsiqJ4eavBZXIR/hVpR4yFzk
         EDnCZo7ZiVVTsRbJmqs9jVDHwF8xwGeduOFP+o20cY7kKOUXCvouwgMaDcxOEIMSV1dL
         VzSbH5wfgJz5y8rI8IJdyh7ZHjvkYoNYcsx7ZAlVUWJLNPiuDeRiuXukZbR65iJ+7fFn
         VOT0ER+wQ3EK7G8rUb5jhkZu7/BK4FDWaQ/y2SwMiJztF7Jpd4frmkXz9UhLHIcxXgWV
         JJZQ==
X-Gm-Message-State: APjAAAU6GEXksZnxY7eJlLQVEfBJjdBZpI5HvSceA9J5htHdkvZPvOFO
        NhEQX/DEkqk4mbHonj+ind0UiA==
X-Google-Smtp-Source: APXvYqzZpHMuJvYQnPkGXRxOc4NnjzvNJlL670DKAphFSbffHXKw8ZKc8XSQH8dWheDwTk0P5HHCIw==
X-Received: by 2002:adf:ce90:: with SMTP id r16mr14425724wrn.156.1558736853134;
        Fri, 24 May 2019 15:27:33 -0700 (PDT)
Received: from cbtest28.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id y10sm7194961wmg.8.2019.05.24.15.27.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 24 May 2019 15:27:32 -0700 (PDT)
From:   Jiong Wang <jiong.wang@netronome.com>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, davem@davemloft.net,
        paul.burton@mips.com, udknight@gmail.com, zlim.lnx@gmail.com,
        illusionist.neo@gmail.com, naveen.n.rao@linux.ibm.com,
        sandipan@linux.ibm.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, jakub.kicinski@netronome.com,
        Jiong Wang <jiong.wang@netronome.com>
Subject: [PATCH v9 bpf-next 10/17] selftests: bpf: enable hi32 randomization for all tests
Date:   Fri, 24 May 2019 23:25:21 +0100
Message-Id: <1558736728-7229-11-git-send-email-jiong.wang@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1558736728-7229-1-git-send-email-jiong.wang@netronome.com>
References: <1558736728-7229-1-git-send-email-jiong.wang@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The previous libbpf patch allows user to specify "prog_flags" to bpf
program load APIs. To enable high 32-bit randomization for a test, we need
to set BPF_F_TEST_RND_HI32 in "prog_flags".

To enable such randomization for all tests, we need to make sure all places
are passing BPF_F_TEST_RND_HI32. Changing them one by one is not
convenient, also, it would be better if a test could be switched to
"normal" running mode without code change.

Given the program load APIs used across bpf selftests are mostly:
  bpf_prog_load:      load from file
  bpf_load_program:   load from raw insns

A test_stub.c is implemented for bpf seltests, it offers two functions for
testing purpose:

  bpf_prog_test_load
  bpf_test_load_program

The are the same as "bpf_prog_load" and "bpf_load_program", except they
also set BPF_F_TEST_RND_HI32. Given *_xattr functions are the APIs to
customize any "prog_flags", it makes little sense to put these two
functions into libbpf.

Then, the following CFLAGS are passed to compilations for host programs:
  -Dbpf_prog_load=bpf_prog_test_load
  -Dbpf_load_program=bpf_test_load_program

They migrate the used load APIs to the test version, hence enable high
32-bit randomization for these tests without changing source code.

Besides all these, there are several testcases are using
"bpf_prog_load_attr" directly, their call sites are updated to pass
BPF_F_TEST_RND_HI32.

Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
---
 tools/testing/selftests/bpf/Makefile               | 10 +++---
 .../selftests/bpf/prog_tests/bpf_verif_scale.c     |  1 +
 tools/testing/selftests/bpf/test_sock_addr.c       |  1 +
 tools/testing/selftests/bpf/test_sock_fields.c     |  1 +
 tools/testing/selftests/bpf/test_socket_cookie.c   |  1 +
 tools/testing/selftests/bpf/test_stub.c            | 40 ++++++++++++++++++++++
 tools/testing/selftests/bpf/test_verifier.c        |  2 +-
 7 files changed, 51 insertions(+), 5 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/test_stub.c

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index cd23758..fa002da 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -15,7 +15,9 @@ LLC		?= llc
 LLVM_OBJCOPY	?= llvm-objcopy
 LLVM_READELF	?= llvm-readelf
 BTF_PAHOLE	?= pahole
-CFLAGS += -Wall -O2 -I$(APIDIR) -I$(LIBDIR) -I$(BPFDIR) -I$(GENDIR) $(GENFLAGS) -I../../../include
+CFLAGS += -Wall -O2 -I$(APIDIR) -I$(LIBDIR) -I$(BPFDIR) -I$(GENDIR) $(GENFLAGS) -I../../../include \
+	  -Dbpf_prog_load=bpf_prog_test_load \
+	  -Dbpf_load_program=bpf_test_load_program
 LDLIBS += -lcap -lelf -lrt -lpthread
 
 # Order correspond to 'make run_tests' order
@@ -79,9 +81,9 @@ $(OUTPUT)/test_maps: map_tests/*.c
 
 BPFOBJ := $(OUTPUT)/libbpf.a
 
-$(TEST_GEN_PROGS): $(BPFOBJ)
+$(TEST_GEN_PROGS): test_stub.o $(BPFOBJ)
 
-$(TEST_GEN_PROGS_EXTENDED): $(OUTPUT)/libbpf.a
+$(TEST_GEN_PROGS_EXTENDED): test_stub.o $(OUTPUT)/libbpf.a
 
 $(OUTPUT)/test_dev_cgroup: cgroup_helpers.c
 $(OUTPUT)/test_skb_cgroup_id_user: cgroup_helpers.c
@@ -177,7 +179,7 @@ $(ALU32_BUILD_DIR)/test_progs_32: test_progs.c $(OUTPUT)/libbpf.a\
 						$(ALU32_BUILD_DIR)/urandom_read
 	$(CC) $(TEST_PROGS_CFLAGS) $(CFLAGS) \
 		-o $(ALU32_BUILD_DIR)/test_progs_32 \
-		test_progs.c trace_helpers.c prog_tests/*.c \
+		test_progs.c test_stub.c trace_helpers.c prog_tests/*.c \
 		$(OUTPUT)/libbpf.a $(LDLIBS)
 
 $(ALU32_BUILD_DIR)/test_progs_32: $(PROG_TESTS_H)
diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c b/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c
index ce03289..c009113 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c
@@ -22,6 +22,7 @@ static int check_load(const char *file, enum bpf_prog_type type)
 	attr.file = file;
 	attr.prog_type = type;
 	attr.log_level = 4;
+	attr.prog_flags = BPF_F_TEST_RND_HI32;
 	err = bpf_prog_load_xattr(&attr, &obj, &prog_fd);
 	bpf_object__close(obj);
 	if (err)
diff --git a/tools/testing/selftests/bpf/test_sock_addr.c b/tools/testing/selftests/bpf/test_sock_addr.c
index 3f110ea..5d0c4f0 100644
--- a/tools/testing/selftests/bpf/test_sock_addr.c
+++ b/tools/testing/selftests/bpf/test_sock_addr.c
@@ -745,6 +745,7 @@ static int load_path(const struct sock_addr_test *test, const char *path)
 	attr.file = path;
 	attr.prog_type = BPF_PROG_TYPE_CGROUP_SOCK_ADDR;
 	attr.expected_attach_type = test->expected_attach_type;
+	attr.prog_flags = BPF_F_TEST_RND_HI32;
 
 	if (bpf_prog_load_xattr(&attr, &obj, &prog_fd)) {
 		if (test->expected_result != LOAD_REJECT)
diff --git a/tools/testing/selftests/bpf/test_sock_fields.c b/tools/testing/selftests/bpf/test_sock_fields.c
index e089477..f0fc103 100644
--- a/tools/testing/selftests/bpf/test_sock_fields.c
+++ b/tools/testing/selftests/bpf/test_sock_fields.c
@@ -414,6 +414,7 @@ int main(int argc, char **argv)
 	struct bpf_prog_load_attr attr = {
 		.file = "test_sock_fields_kern.o",
 		.prog_type = BPF_PROG_TYPE_CGROUP_SKB,
+		.prog_flags = BPF_F_TEST_RND_HI32,
 	};
 	int cgroup_fd, egress_fd, ingress_fd, err;
 	struct bpf_program *ingress_prog;
diff --git a/tools/testing/selftests/bpf/test_socket_cookie.c b/tools/testing/selftests/bpf/test_socket_cookie.c
index e51d637..cac8ee5 100644
--- a/tools/testing/selftests/bpf/test_socket_cookie.c
+++ b/tools/testing/selftests/bpf/test_socket_cookie.c
@@ -148,6 +148,7 @@ static int run_test(int cgfd)
 	memset(&attr, 0, sizeof(attr));
 	attr.file = SOCKET_COOKIE_PROG;
 	attr.prog_type = BPF_PROG_TYPE_UNSPEC;
+	attr.prog_flags = BPF_F_TEST_RND_HI32;
 
 	err = bpf_prog_load_xattr(&attr, &pobj, &prog_fd);
 	if (err) {
diff --git a/tools/testing/selftests/bpf/test_stub.c b/tools/testing/selftests/bpf/test_stub.c
new file mode 100644
index 0000000..84e81a8
--- /dev/null
+++ b/tools/testing/selftests/bpf/test_stub.c
@@ -0,0 +1,40 @@
+// SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+/* Copyright (C) 2019 Netronome Systems, Inc. */
+
+#include <bpf/bpf.h>
+#include <bpf/libbpf.h>
+#include <string.h>
+
+int bpf_prog_test_load(const char *file, enum bpf_prog_type type,
+		       struct bpf_object **pobj, int *prog_fd)
+{
+	struct bpf_prog_load_attr attr;
+
+	memset(&attr, 0, sizeof(struct bpf_prog_load_attr));
+	attr.file = file;
+	attr.prog_type = type;
+	attr.expected_attach_type = 0;
+	attr.prog_flags = BPF_F_TEST_RND_HI32;
+
+	return bpf_prog_load_xattr(&attr, pobj, prog_fd);
+}
+
+int bpf_test_load_program(enum bpf_prog_type type, const struct bpf_insn *insns,
+			  size_t insns_cnt, const char *license,
+			  __u32 kern_version, char *log_buf,
+		     size_t log_buf_sz)
+{
+	struct bpf_load_program_attr load_attr;
+
+	memset(&load_attr, 0, sizeof(struct bpf_load_program_attr));
+	load_attr.prog_type = type;
+	load_attr.expected_attach_type = 0;
+	load_attr.name = NULL;
+	load_attr.insns = insns;
+	load_attr.insns_cnt = insns_cnt;
+	load_attr.license = license;
+	load_attr.kern_version = kern_version;
+	load_attr.prog_flags = BPF_F_TEST_RND_HI32;
+
+	return bpf_load_program_xattr(&load_attr, log_buf, log_buf_sz);
+}
diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index fa9b5bf..cd0248c 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -882,7 +882,7 @@ static void do_test_single(struct bpf_test *test, bool unpriv,
 	if (fixup_skips != skips)
 		return;
 
-	pflags = 0;
+	pflags = BPF_F_TEST_RND_HI32;
 	if (test->flags & F_LOAD_WITH_STRICT_ALIGNMENT)
 		pflags |= BPF_F_STRICT_ALIGNMENT;
 	if (test->flags & F_NEEDS_EFFICIENT_UNALIGNED_ACCESS)
-- 
2.7.4

