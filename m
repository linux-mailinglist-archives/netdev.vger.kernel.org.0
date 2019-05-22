Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A43DB26A39
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 20:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729758AbfEVS4F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 14:56:05 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40539 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729710AbfEVS4A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 14:56:00 -0400
Received: by mail-wr1-f66.google.com with SMTP id f10so3477707wre.7
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 11:55:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=f/8tnLJPtm0Gb/slYuigKyqj9vpUtI5h8/DTP1nDvzk=;
        b=yR6xg896PIPb18fiB15IuXPQ/jv9r6TT909zJ4IPcUGQAnss34ex4lJRsb951WKWDx
         5Bwla1mQPlRbAmFz/dkepvszaCwaLXcO73KeNMcpetEsjyWr5hb/2lhepcQxseWDKKIL
         mGT0YxOk3CyOYB+L3Q7u4fuIffi2uI1Ud4u3hPDmotNFuVRZw15ARSrMVYC/fgTF2Kje
         DTsYZqZrLJ5CgNfEbMecWypxGRbCeiF23iXVgZt6bisphmdhbqEIjTBy062+GzOX2qeE
         VKq+kw45OF85KcF2AQ4t2Ab4v+tNe/ioncnS+E7UVFgh9KxryHrAkV2/nUmEw0x/+7/A
         wEqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=f/8tnLJPtm0Gb/slYuigKyqj9vpUtI5h8/DTP1nDvzk=;
        b=gvKc6mhzPVt/nQJrhcsY2jbNV/O+C+pEw7I0koVWvJGIPT6vBJsyUi+nUfkJhLyOWV
         TvpgZcMrdtB0Q0exYjXZWCPn0f1/OFQFlWFMTg6IDKE956wIaQYOGgEt8XS0Ps4LKXSU
         /hmViZa+fnxrcFyVLgtGQkCq5uswWyIGH6kawkmMbyqWZbFsjzzcInspfAd4tk6EWQ7Y
         3mfG4lRzv0R4odc/w7l+yQNlcYUnuqLNeQnGDX6mXree41FzHgrhV2rgZhwp4S+RviQo
         PNMpYf5850E1pza07YSeaTaDM5i3HNin/p/YLCcsuQkrCIE9dI/2IPqaqQIedGpZ0sNv
         D6sw==
X-Gm-Message-State: APjAAAWf3543mUfojF3GhGEFW0LfMXt8RuRXVKi8kF30JlNkECNV/AMw
        jirC0DfVyeYwI86TwIYZWclW9w==
X-Google-Smtp-Source: APXvYqxfkNM5DeCsf+WsvtV6ZzV5vnfgHDL2XBujVGjUsM0jtErlXOZCciN6upLp03cI04JFJUUXXg==
X-Received: by 2002:adf:f788:: with SMTP id q8mr57036622wrp.181.1558551358538;
        Wed, 22 May 2019 11:55:58 -0700 (PDT)
Received: from cbtest28.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id t12sm16328801wro.2.2019.05.22.11.55.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 22 May 2019 11:55:57 -0700 (PDT)
From:   Jiong Wang <jiong.wang@netronome.com>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, davem@davemloft.net,
        paul.burton@mips.com, udknight@gmail.com, zlim.lnx@gmail.com,
        illusionist.neo@gmail.com, naveen.n.rao@linux.ibm.com,
        sandipan@linux.ibm.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, jakub.kicinski@netronome.com,
        Jiong Wang <jiong.wang@netronome.com>
Subject: [PATCH v7 bpf-next 09/16] selftests: bpf: enable hi32 randomization for all tests
Date:   Wed, 22 May 2019 19:55:05 +0100
Message-Id: <1558551312-17081-10-git-send-email-jiong.wang@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1558551312-17081-1-git-send-email-jiong.wang@netronome.com>
References: <1558551312-17081-1-git-send-email-jiong.wang@netronome.com>
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
index 66f2dca..3f2c131 100644
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
@@ -78,9 +80,9 @@ $(OUTPUT)/test_maps: map_tests/*.c
 
 BPFOBJ := $(OUTPUT)/libbpf.a
 
-$(TEST_GEN_PROGS): $(BPFOBJ)
+$(TEST_GEN_PROGS): test_stub.o $(BPFOBJ)
 
-$(TEST_GEN_PROGS_EXTENDED): $(OUTPUT)/libbpf.a
+$(TEST_GEN_PROGS_EXTENDED): test_stub.o $(OUTPUT)/libbpf.a
 
 $(OUTPUT)/test_dev_cgroup: cgroup_helpers.c
 $(OUTPUT)/test_skb_cgroup_id_user: cgroup_helpers.c
@@ -176,7 +178,7 @@ $(ALU32_BUILD_DIR)/test_progs_32: test_progs.c $(OUTPUT)/libbpf.a\
 						$(ALU32_BUILD_DIR)/urandom_read
 	$(CC) $(TEST_PROGS_CFLAGS) $(CFLAGS) \
 		-o $(ALU32_BUILD_DIR)/test_progs_32 \
-		test_progs.c trace_helpers.c prog_tests/*.c \
+		test_progs.c test_stub.c trace_helpers.c prog_tests/*.c \
 		$(OUTPUT)/libbpf.a $(LDLIBS)
 
 $(ALU32_BUILD_DIR)/test_progs_32: $(PROG_TESTS_H)
diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c b/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c
index b74e2f6..d45d55f 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c
@@ -22,6 +22,7 @@ static int check_load(const char *file)
 	attr.file = file;
 	attr.prog_type = BPF_PROG_TYPE_SCHED_CLS;
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
index 3dcdfd4..71704de 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -879,7 +879,7 @@ static void do_test_single(struct bpf_test *test, bool unpriv,
 	if (fixup_skips != skips)
 		return;
 
-	pflags = 0;
+	pflags = BPF_F_TEST_RND_HI32;
 	if (test->flags & F_LOAD_WITH_STRICT_ALIGNMENT)
 		pflags |= BPF_F_STRICT_ALIGNMENT;
 	if (test->flags & F_NEEDS_EFFICIENT_UNALIGNED_ACCESS)
-- 
2.7.4

