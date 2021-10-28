Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2E1643DB44
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 08:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbhJ1Ghw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 02:37:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbhJ1Ghs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 02:37:48 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3301C061767;
        Wed, 27 Oct 2021 23:35:21 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id m14so5014929pfc.9;
        Wed, 27 Oct 2021 23:35:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IRbRvvUzpRdu2lFq4HNGdCUZyQ77poV7bmRj9EDb0uo=;
        b=YUBXcO9KzM2sDt5jMhlfSccY0tUuUmHNc0XplMsaS5991hHTqLA5qhVpNi+o7o7VXW
         nZd6enMqxYGZ7MZgJNpKapxRadUEy/V0Va+rFfzdqhrg113J1hJoq09UD7e5981OI8Ay
         CwhSDx5EJf9x3WkvdxfsgGOX0yOvxWpHzye/u3jUwFqqqURPg1EimILgVBaLZvfNZQK3
         cMVZiAkjch4PJK8FiHJVrkDRxdu+RJWT3dWyAzy2KVdy/tWp8aPmAc5PJqKmUcIzoP0q
         PhgM+sctOUiwY26MhbvJH2jqc2pCJ2WVWzuZD1JjxTmbwzGsT8eBpTUxnGv8Y6sZ/MGY
         MUZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IRbRvvUzpRdu2lFq4HNGdCUZyQ77poV7bmRj9EDb0uo=;
        b=reLx6TKLigER8iSOu8QNXMT6zdyoRTbKJ2UM9gz9oi/eSZWD+0Inds5ifcVSrOKyA5
         M9JdVObviwI1U3KnOfcKjEdsYceuqkl2nMIgFHYcwjDpTFJc9iZiRp3shwv0sd1IMNFK
         1WteWaDiwOWOr0eXjUVIlmFUQSEPJDcVSdKCFsUh8g4UZDmGZA3mZRZLef6buYCXNVUz
         /H5bPcXZvnUPe3FCs+Q0+xqdfBORKlHx5i3Pn9dXXut9cXjC0r+UjoYbsVyQX5xEIENv
         UUp/k7ajKgEIPoUPoJytQXsvL/xf0QPoR1kp6vavbdwsPbZ1wPksOkAnAXHpo4VhJst7
         BQYw==
X-Gm-Message-State: AOAM532Q0xYYIVOk9FJ4Ee6I0BI0JR0JfWt0URpZvyF9HC+XZVX4CAL5
        bxa9Cg190J1BEQSCmEMyBTNI8bAL1Ov+gA==
X-Google-Smtp-Source: ABdhPJzeSQikJ8MqGhGpRMqMTfgs/mDyVWmxjzMvnP8mvaBlW+tYJdyfXxLjYRt5qgectoelFMOwBw==
X-Received: by 2002:a62:80cb:0:b0:47c:1d1c:b763 with SMTP id j194-20020a6280cb000000b0047c1d1cb763mr2406503pfd.62.1635402921059;
        Wed, 27 Oct 2021 23:35:21 -0700 (PDT)
Received: from localhost ([2405:201:6014:d916:31fc:9e49:a605:b093])
        by smtp.gmail.com with ESMTPSA id s6sm2067761pfu.137.2021.10.27.23.35.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Oct 2021 23:35:20 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v5 6/8] selftests/bpf: Add weak/typeless ksym test for light skeleton
Date:   Thu, 28 Oct 2021 12:04:59 +0530
Message-Id: <20211028063501.2239335-7-memxor@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211028063501.2239335-1-memxor@gmail.com>
References: <20211028063501.2239335-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=25870; h=from:subject; bh=DFGgbBp5peqfSWa6+4x+d//xh8bZPNYQXK1vdTiokc8=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhekR/fHL955OGXiEafpW5U5hBh+xQwtNcklHp3dKb 7AameVeJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYXpEfwAKCRBM4MiGSL8RypajD/ kBQrE4NAAnldXi6Y5MwsJ4gCuO7knMtq/Alw9nKATQb9i4BdmpQPQhMKze2xkWOMXFZct6J05rd1Yn lAwIrHfezwVNqMA7qz1TpDvKLy2zwrJNPsqY0Qf3fR6+SC4wyxR78UUyHYIQlzVRNnLLZoV++7CxAr euvIAzYSBHHGZ1XnmIAKc1BqSun0rtsk387tA625YwjuoDbyv90pDxMNqqZGD0EvDMaYbJHB5J84IY gU95jMng3M9L8z5KF+wBj8gRPuI4muyct5837OnUrooYIpZdo6jmTVVBFznIDstruLgyjlGQhIBmPH 2P0e/8/R5JkX5qetqTsSSfMWRV+F07ixs41KVQZl3tleyPCsBF8zM+v66FjJd1G1CO0zWNVx9jgECj UvXkf8Rd/qEK2hp7HQ7h3UYuaXPk7fCH0auFhFz7YPeZ6xJPQaEemAw1N7VImbrKQ89dwyctf/JB6C xQgv/ISwxb4OxSFB/6A5JI5v7xBnBANAtsQgi31NkAWpOxqb7jL95QT8L4z4HNf/hlSWy/tKgkW56f VLD+a5IsxxH2ii3W5sIF9AygBi7DeQ8vvmRIhEiM/+YzO8IlE+lo9nga8trMrs6ZvLe4Ug0BNT0C4i dbAp8o38WLRm50DT8BbLIsW1d2tX1B2c94wX2r/uKolVOFNpbBkE96CaI8gQ==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Also, avoid using CO-RE features, as lskel doesn't support CO-RE, yet.
Include both light and libbpf skeleton in same file to test both of them
together.

In c48e51c8b07a ("bpf: selftests: Add selftests for module kfunc support"),
I added support for generating both lskel and libbpf skel for a BPF
object, however the name parameter for bpftool caused collisions when
included in same file together. This meant that every test needed a
separate file for a libbpf/light skeleton separation instead of
subtests.

Change that by appending a "_lskel" suffix to the name for files using
light skeleton, and convert all existing users.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 tools/testing/selftests/bpf/Makefile          |  4 +-
 .../selftests/bpf/prog_tests/atomics.c        | 34 ++++++++--------
 .../selftests/bpf/prog_tests/fentry_fexit.c   | 16 ++++----
 .../selftests/bpf/prog_tests/fentry_test.c    | 14 +++----
 .../selftests/bpf/prog_tests/fexit_sleep.c    | 12 +++---
 .../selftests/bpf/prog_tests/fexit_test.c     | 14 +++----
 .../selftests/bpf/prog_tests/kfunc_call.c     |  6 +--
 .../selftests/bpf/prog_tests/ksyms_btf.c      | 35 +++++++++++++++-
 .../selftests/bpf/prog_tests/ksyms_module.c   | 40 +++++++++++++++++--
 .../bpf/prog_tests/ksyms_module_libbpf.c      | 28 -------------
 .../selftests/bpf/prog_tests/ringbuf.c        | 12 +++---
 .../selftests/bpf/prog_tests/trace_printk.c   | 14 +++----
 .../selftests/bpf/prog_tests/trace_vprintk.c  | 12 +++---
 .../selftests/bpf/prog_tests/verif_stats.c    |  6 +--
 .../selftests/bpf/progs/test_ksyms_weak.c     |  2 +-
 15 files changed, 142 insertions(+), 107 deletions(-)
 delete mode 100644 tools/testing/selftests/bpf/prog_tests/ksyms_module_libbpf.c

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index ac47cf9760fc..70276cce949a 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -325,7 +325,7 @@ LINKED_SKELS := test_static_linked.skel.h linked_funcs.skel.h		\
 LSKELS := kfunc_call_test.c fentry_test.c fexit_test.c fexit_sleep.c \
 	test_ringbuf.c atomics.c trace_printk.c trace_vprintk.c
 # Generate both light skeleton and libbpf skeleton for these
-LSKELS_EXTRA := test_ksyms_module.c
+LSKELS_EXTRA := test_ksyms_module.c test_ksyms_weak.c
 SKEL_BLACKLIST += $$(LSKELS)
 
 test_static_linked.skel.h-deps := test_static_linked1.o test_static_linked2.o
@@ -404,7 +404,7 @@ $(TRUNNER_BPF_LSKELS): %.lskel.h: %.o $(BPFTOOL) | $(TRUNNER_OUTPUT)
 	$(Q)$$(BPFTOOL) gen object $$(<:.o=.linked2.o) $$(<:.o=.linked1.o)
 	$(Q)$$(BPFTOOL) gen object $$(<:.o=.linked3.o) $$(<:.o=.linked2.o)
 	$(Q)diff $$(<:.o=.linked2.o) $$(<:.o=.linked3.o)
-	$(Q)$$(BPFTOOL) gen skeleton -L $$(<:.o=.linked3.o) name $$(notdir $$(<:.o=)) > $$@
+	$(Q)$$(BPFTOOL) gen skeleton -L $$(<:.o=.linked3.o) name $$(notdir $$(<:.o=_lskel)) > $$@
 
 $(TRUNNER_BPF_SKELS_LINKED): $(TRUNNER_BPF_OBJS) $(BPFTOOL) | $(TRUNNER_OUTPUT)
 	$$(call msg,LINK-BPF,$(TRUNNER_BINARY),$$(@:.skel.h=.o))
diff --git a/tools/testing/selftests/bpf/prog_tests/atomics.c b/tools/testing/selftests/bpf/prog_tests/atomics.c
index 1486be5d3209..0f9525293881 100644
--- a/tools/testing/selftests/bpf/prog_tests/atomics.c
+++ b/tools/testing/selftests/bpf/prog_tests/atomics.c
@@ -4,13 +4,13 @@
 
 #include "atomics.lskel.h"
 
-static void test_add(struct atomics *skel)
+static void test_add(struct atomics_lskel *skel)
 {
 	int err, prog_fd;
 	__u32 duration = 0, retval;
 	int link_fd;
 
-	link_fd = atomics__add__attach(skel);
+	link_fd = atomics_lskel__add__attach(skel);
 	if (!ASSERT_GT(link_fd, 0, "attach(add)"))
 		return;
 
@@ -36,13 +36,13 @@ static void test_add(struct atomics *skel)
 	close(link_fd);
 }
 
-static void test_sub(struct atomics *skel)
+static void test_sub(struct atomics_lskel *skel)
 {
 	int err, prog_fd;
 	__u32 duration = 0, retval;
 	int link_fd;
 
-	link_fd = atomics__sub__attach(skel);
+	link_fd = atomics_lskel__sub__attach(skel);
 	if (!ASSERT_GT(link_fd, 0, "attach(sub)"))
 		return;
 
@@ -69,13 +69,13 @@ static void test_sub(struct atomics *skel)
 	close(link_fd);
 }
 
-static void test_and(struct atomics *skel)
+static void test_and(struct atomics_lskel *skel)
 {
 	int err, prog_fd;
 	__u32 duration = 0, retval;
 	int link_fd;
 
-	link_fd = atomics__and__attach(skel);
+	link_fd = atomics_lskel__and__attach(skel);
 	if (!ASSERT_GT(link_fd, 0, "attach(and)"))
 		return;
 
@@ -97,13 +97,13 @@ static void test_and(struct atomics *skel)
 	close(link_fd);
 }
 
-static void test_or(struct atomics *skel)
+static void test_or(struct atomics_lskel *skel)
 {
 	int err, prog_fd;
 	__u32 duration = 0, retval;
 	int link_fd;
 
-	link_fd = atomics__or__attach(skel);
+	link_fd = atomics_lskel__or__attach(skel);
 	if (!ASSERT_GT(link_fd, 0, "attach(or)"))
 		return;
 
@@ -126,13 +126,13 @@ static void test_or(struct atomics *skel)
 	close(link_fd);
 }
 
-static void test_xor(struct atomics *skel)
+static void test_xor(struct atomics_lskel *skel)
 {
 	int err, prog_fd;
 	__u32 duration = 0, retval;
 	int link_fd;
 
-	link_fd = atomics__xor__attach(skel);
+	link_fd = atomics_lskel__xor__attach(skel);
 	if (!ASSERT_GT(link_fd, 0, "attach(xor)"))
 		return;
 
@@ -154,13 +154,13 @@ static void test_xor(struct atomics *skel)
 	close(link_fd);
 }
 
-static void test_cmpxchg(struct atomics *skel)
+static void test_cmpxchg(struct atomics_lskel *skel)
 {
 	int err, prog_fd;
 	__u32 duration = 0, retval;
 	int link_fd;
 
-	link_fd = atomics__cmpxchg__attach(skel);
+	link_fd = atomics_lskel__cmpxchg__attach(skel);
 	if (!ASSERT_GT(link_fd, 0, "attach(cmpxchg)"))
 		return;
 
@@ -183,13 +183,13 @@ static void test_cmpxchg(struct atomics *skel)
 	close(link_fd);
 }
 
-static void test_xchg(struct atomics *skel)
+static void test_xchg(struct atomics_lskel *skel)
 {
 	int err, prog_fd;
 	__u32 duration = 0, retval;
 	int link_fd;
 
-	link_fd = atomics__xchg__attach(skel);
+	link_fd = atomics_lskel__xchg__attach(skel);
 	if (!ASSERT_GT(link_fd, 0, "attach(xchg)"))
 		return;
 
@@ -212,10 +212,10 @@ static void test_xchg(struct atomics *skel)
 
 void test_atomics(void)
 {
-	struct atomics *skel;
+	struct atomics_lskel *skel;
 	__u32 duration = 0;
 
-	skel = atomics__open_and_load();
+	skel = atomics_lskel__open_and_load();
 	if (CHECK(!skel, "skel_load", "atomics skeleton failed\n"))
 		return;
 
@@ -243,5 +243,5 @@ void test_atomics(void)
 		test_xchg(skel);
 
 cleanup:
-	atomics__destroy(skel);
+	atomics_lskel__destroy(skel);
 }
diff --git a/tools/testing/selftests/bpf/prog_tests/fentry_fexit.c b/tools/testing/selftests/bpf/prog_tests/fentry_fexit.c
index 91154c2ba256..4374ac8a8a91 100644
--- a/tools/testing/selftests/bpf/prog_tests/fentry_fexit.c
+++ b/tools/testing/selftests/bpf/prog_tests/fentry_fexit.c
@@ -6,23 +6,23 @@
 
 void test_fentry_fexit(void)
 {
-	struct fentry_test *fentry_skel = NULL;
-	struct fexit_test *fexit_skel = NULL;
+	struct fentry_test_lskel *fentry_skel = NULL;
+	struct fexit_test_lskel *fexit_skel = NULL;
 	__u64 *fentry_res, *fexit_res;
 	__u32 duration = 0, retval;
 	int err, prog_fd, i;
 
-	fentry_skel = fentry_test__open_and_load();
+	fentry_skel = fentry_test_lskel__open_and_load();
 	if (CHECK(!fentry_skel, "fentry_skel_load", "fentry skeleton failed\n"))
 		goto close_prog;
-	fexit_skel = fexit_test__open_and_load();
+	fexit_skel = fexit_test_lskel__open_and_load();
 	if (CHECK(!fexit_skel, "fexit_skel_load", "fexit skeleton failed\n"))
 		goto close_prog;
 
-	err = fentry_test__attach(fentry_skel);
+	err = fentry_test_lskel__attach(fentry_skel);
 	if (CHECK(err, "fentry_attach", "fentry attach failed: %d\n", err))
 		goto close_prog;
-	err = fexit_test__attach(fexit_skel);
+	err = fexit_test_lskel__attach(fexit_skel);
 	if (CHECK(err, "fexit_attach", "fexit attach failed: %d\n", err))
 		goto close_prog;
 
@@ -44,6 +44,6 @@ void test_fentry_fexit(void)
 	}
 
 close_prog:
-	fentry_test__destroy(fentry_skel);
-	fexit_test__destroy(fexit_skel);
+	fentry_test_lskel__destroy(fentry_skel);
+	fexit_test_lskel__destroy(fexit_skel);
 }
diff --git a/tools/testing/selftests/bpf/prog_tests/fentry_test.c b/tools/testing/selftests/bpf/prog_tests/fentry_test.c
index 174c89e7456e..12921b3850d2 100644
--- a/tools/testing/selftests/bpf/prog_tests/fentry_test.c
+++ b/tools/testing/selftests/bpf/prog_tests/fentry_test.c
@@ -3,19 +3,19 @@
 #include <test_progs.h>
 #include "fentry_test.lskel.h"
 
-static int fentry_test(struct fentry_test *fentry_skel)
+static int fentry_test(struct fentry_test_lskel *fentry_skel)
 {
 	int err, prog_fd, i;
 	__u32 duration = 0, retval;
 	int link_fd;
 	__u64 *result;
 
-	err = fentry_test__attach(fentry_skel);
+	err = fentry_test_lskel__attach(fentry_skel);
 	if (!ASSERT_OK(err, "fentry_attach"))
 		return err;
 
 	/* Check that already linked program can't be attached again. */
-	link_fd = fentry_test__test1__attach(fentry_skel);
+	link_fd = fentry_test_lskel__test1__attach(fentry_skel);
 	if (!ASSERT_LT(link_fd, 0, "fentry_attach_link"))
 		return -1;
 
@@ -31,7 +31,7 @@ static int fentry_test(struct fentry_test *fentry_skel)
 			return -1;
 	}
 
-	fentry_test__detach(fentry_skel);
+	fentry_test_lskel__detach(fentry_skel);
 
 	/* zero results for re-attach test */
 	memset(fentry_skel->bss, 0, sizeof(*fentry_skel->bss));
@@ -40,10 +40,10 @@ static int fentry_test(struct fentry_test *fentry_skel)
 
 void test_fentry_test(void)
 {
-	struct fentry_test *fentry_skel = NULL;
+	struct fentry_test_lskel *fentry_skel = NULL;
 	int err;
 
-	fentry_skel = fentry_test__open_and_load();
+	fentry_skel = fentry_test_lskel__open_and_load();
 	if (!ASSERT_OK_PTR(fentry_skel, "fentry_skel_load"))
 		goto cleanup;
 
@@ -55,5 +55,5 @@ void test_fentry_test(void)
 	ASSERT_OK(err, "fentry_second_attach");
 
 cleanup:
-	fentry_test__destroy(fentry_skel);
+	fentry_test_lskel__destroy(fentry_skel);
 }
diff --git a/tools/testing/selftests/bpf/prog_tests/fexit_sleep.c b/tools/testing/selftests/bpf/prog_tests/fexit_sleep.c
index 4e7f4b42ea29..f949647dbbc2 100644
--- a/tools/testing/selftests/bpf/prog_tests/fexit_sleep.c
+++ b/tools/testing/selftests/bpf/prog_tests/fexit_sleep.c
@@ -10,7 +10,7 @@
 
 static int do_sleep(void *skel)
 {
-	struct fexit_sleep *fexit_skel = skel;
+	struct fexit_sleep_lskel *fexit_skel = skel;
 	struct timespec ts1 = { .tv_nsec = 1 };
 	struct timespec ts2 = { .tv_sec = 10 };
 
@@ -25,16 +25,16 @@ static char child_stack[STACK_SIZE];
 
 void test_fexit_sleep(void)
 {
-	struct fexit_sleep *fexit_skel = NULL;
+	struct fexit_sleep_lskel *fexit_skel = NULL;
 	int wstatus, duration = 0;
 	pid_t cpid;
 	int err, fexit_cnt;
 
-	fexit_skel = fexit_sleep__open_and_load();
+	fexit_skel = fexit_sleep_lskel__open_and_load();
 	if (CHECK(!fexit_skel, "fexit_skel_load", "fexit skeleton failed\n"))
 		goto cleanup;
 
-	err = fexit_sleep__attach(fexit_skel);
+	err = fexit_sleep_lskel__attach(fexit_skel);
 	if (CHECK(err, "fexit_attach", "fexit attach failed: %d\n", err))
 		goto cleanup;
 
@@ -60,7 +60,7 @@ void test_fexit_sleep(void)
 	 */
 	close(fexit_skel->progs.nanosleep_fentry.prog_fd);
 	close(fexit_skel->progs.nanosleep_fexit.prog_fd);
-	fexit_sleep__detach(fexit_skel);
+	fexit_sleep_lskel__detach(fexit_skel);
 
 	/* kill the thread to unwind sys_nanosleep stack through the trampoline */
 	kill(cpid, 9);
@@ -78,5 +78,5 @@ void test_fexit_sleep(void)
 		goto cleanup;
 
 cleanup:
-	fexit_sleep__destroy(fexit_skel);
+	fexit_sleep_lskel__destroy(fexit_skel);
 }
diff --git a/tools/testing/selftests/bpf/prog_tests/fexit_test.c b/tools/testing/selftests/bpf/prog_tests/fexit_test.c
index af3dba726701..d4887d8bb396 100644
--- a/tools/testing/selftests/bpf/prog_tests/fexit_test.c
+++ b/tools/testing/selftests/bpf/prog_tests/fexit_test.c
@@ -3,19 +3,19 @@
 #include <test_progs.h>
 #include "fexit_test.lskel.h"
 
-static int fexit_test(struct fexit_test *fexit_skel)
+static int fexit_test(struct fexit_test_lskel *fexit_skel)
 {
 	int err, prog_fd, i;
 	__u32 duration = 0, retval;
 	int link_fd;
 	__u64 *result;
 
-	err = fexit_test__attach(fexit_skel);
+	err = fexit_test_lskel__attach(fexit_skel);
 	if (!ASSERT_OK(err, "fexit_attach"))
 		return err;
 
 	/* Check that already linked program can't be attached again. */
-	link_fd = fexit_test__test1__attach(fexit_skel);
+	link_fd = fexit_test_lskel__test1__attach(fexit_skel);
 	if (!ASSERT_LT(link_fd, 0, "fexit_attach_link"))
 		return -1;
 
@@ -31,7 +31,7 @@ static int fexit_test(struct fexit_test *fexit_skel)
 			return -1;
 	}
 
-	fexit_test__detach(fexit_skel);
+	fexit_test_lskel__detach(fexit_skel);
 
 	/* zero results for re-attach test */
 	memset(fexit_skel->bss, 0, sizeof(*fexit_skel->bss));
@@ -40,10 +40,10 @@ static int fexit_test(struct fexit_test *fexit_skel)
 
 void test_fexit_test(void)
 {
-	struct fexit_test *fexit_skel = NULL;
+	struct fexit_test_lskel *fexit_skel = NULL;
 	int err;
 
-	fexit_skel = fexit_test__open_and_load();
+	fexit_skel = fexit_test_lskel__open_and_load();
 	if (!ASSERT_OK_PTR(fexit_skel, "fexit_skel_load"))
 		goto cleanup;
 
@@ -55,5 +55,5 @@ void test_fexit_test(void)
 	ASSERT_OK(err, "fexit_second_attach");
 
 cleanup:
-	fexit_test__destroy(fexit_skel);
+	fexit_test_lskel__destroy(fexit_skel);
 }
diff --git a/tools/testing/selftests/bpf/prog_tests/kfunc_call.c b/tools/testing/selftests/bpf/prog_tests/kfunc_call.c
index 9611f2bc50df..5c9c0176991b 100644
--- a/tools/testing/selftests/bpf/prog_tests/kfunc_call.c
+++ b/tools/testing/selftests/bpf/prog_tests/kfunc_call.c
@@ -7,10 +7,10 @@
 
 static void test_main(void)
 {
-	struct kfunc_call_test *skel;
+	struct kfunc_call_test_lskel *skel;
 	int prog_fd, retval, err;
 
-	skel = kfunc_call_test__open_and_load();
+	skel = kfunc_call_test_lskel__open_and_load();
 	if (!ASSERT_OK_PTR(skel, "skel"))
 		return;
 
@@ -26,7 +26,7 @@ static void test_main(void)
 	ASSERT_OK(err, "bpf_prog_test_run(test2)");
 	ASSERT_EQ(retval, 3, "test2-retval");
 
-	kfunc_call_test__destroy(skel);
+	kfunc_call_test_lskel__destroy(skel);
 }
 
 static void test_subprog(void)
diff --git a/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c b/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c
index cf3acfa5a91d..79f6bd1e50d6 100644
--- a/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c
+++ b/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c
@@ -7,6 +7,7 @@
 #include "test_ksyms_btf.skel.h"
 #include "test_ksyms_btf_null_check.skel.h"
 #include "test_ksyms_weak.skel.h"
+#include "test_ksyms_weak.lskel.h"
 
 static int duration;
 
@@ -89,11 +90,11 @@ static void test_weak_syms(void)
 	int err;
 
 	skel = test_ksyms_weak__open_and_load();
-	if (CHECK(!skel, "test_ksyms_weak__open_and_load", "failed\n"))
+	if (!ASSERT_OK_PTR(skel, "test_ksyms_weak__open_and_load"))
 		return;
 
 	err = test_ksyms_weak__attach(skel);
-	if (CHECK(err, "test_ksyms_weak__attach", "skeleton attach failed: %d\n", err))
+	if (!ASSERT_OK(err, "test_ksyms_weak__attach"))
 		goto cleanup;
 
 	/* trigger tracepoint */
@@ -109,6 +110,33 @@ static void test_weak_syms(void)
 	test_ksyms_weak__destroy(skel);
 }
 
+static void test_weak_syms_lskel(void)
+{
+	struct test_ksyms_weak_lskel *skel;
+	struct test_ksyms_weak_lskel__data *data;
+	int err;
+
+	skel = test_ksyms_weak_lskel__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "test_ksyms_weak_lskel__open_and_load"))
+		return;
+
+	err = test_ksyms_weak_lskel__attach(skel);
+	if (!ASSERT_OK(err, "test_ksyms_weak_lskel__attach"))
+		goto cleanup;
+
+	/* trigger tracepoint */
+	usleep(1);
+
+	data = skel->data;
+	ASSERT_EQ(data->out__existing_typed, 0, "existing typed ksym");
+	ASSERT_NEQ(data->out__existing_typeless, -1, "existing typeless ksym");
+	ASSERT_EQ(data->out__non_existent_typeless, 0, "nonexistent typeless ksym");
+	ASSERT_EQ(data->out__non_existent_typed, 0, "nonexistent typed ksym");
+
+cleanup:
+	test_ksyms_weak_lskel__destroy(skel);
+}
+
 void test_ksyms_btf(void)
 {
 	int percpu_datasec;
@@ -136,4 +164,7 @@ void test_ksyms_btf(void)
 
 	if (test__start_subtest("weak_ksyms"))
 		test_weak_syms();
+
+	if (test__start_subtest("weak_ksyms_lskel"))
+		test_weak_syms_lskel();
 }
diff --git a/tools/testing/selftests/bpf/prog_tests/ksyms_module.c b/tools/testing/selftests/bpf/prog_tests/ksyms_module.c
index 831447878d7b..d490ad80eccb 100644
--- a/tools/testing/selftests/bpf/prog_tests/ksyms_module.c
+++ b/tools/testing/selftests/bpf/prog_tests/ksyms_module.c
@@ -4,10 +4,11 @@
 #include <test_progs.h>
 #include <network_helpers.h>
 #include "test_ksyms_module.lskel.h"
+#include "test_ksyms_module.skel.h"
 
-void test_ksyms_module(void)
+void test_ksyms_module_lskel(void)
 {
-	struct test_ksyms_module *skel;
+	struct test_ksyms_module_lskel *skel;
 	int retval;
 	int err;
 
@@ -16,8 +17,8 @@ void test_ksyms_module(void)
 		return;
 	}
 
-	skel = test_ksyms_module__open_and_load();
-	if (!ASSERT_OK_PTR(skel, "test_ksyms_module__open_and_load"))
+	skel = test_ksyms_module_lskel__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "test_ksyms_module_lskel__open_and_load"))
 		return;
 	err = bpf_prog_test_run(skel->progs.load.prog_fd, 1, &pkt_v4, sizeof(pkt_v4),
 				NULL, NULL, (__u32 *)&retval, NULL);
@@ -25,6 +26,37 @@ void test_ksyms_module(void)
 		goto cleanup;
 	ASSERT_EQ(retval, 0, "retval");
 	ASSERT_EQ(skel->bss->out_bpf_testmod_ksym, 42, "bpf_testmod_ksym");
+cleanup:
+	test_ksyms_module_lskel__destroy(skel);
+}
+
+void test_ksyms_module_libbpf(void)
+{
+	struct test_ksyms_module *skel;
+	int retval, err;
+
+	if (!env.has_testmod) {
+		test__skip();
+		return;
+	}
+
+	skel = test_ksyms_module__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "test_ksyms_module__open"))
+		return;
+	err = bpf_prog_test_run(bpf_program__fd(skel->progs.load), 1, &pkt_v4,
+				sizeof(pkt_v4), NULL, NULL, (__u32 *)&retval, NULL);
+	if (!ASSERT_OK(err, "bpf_prog_test_run"))
+		goto cleanup;
+	ASSERT_EQ(retval, 0, "retval");
+	ASSERT_EQ(skel->bss->out_bpf_testmod_ksym, 42, "bpf_testmod_ksym");
 cleanup:
 	test_ksyms_module__destroy(skel);
 }
+
+void test_ksyms_module(void)
+{
+	if (test__start_subtest("lskel"))
+		test_ksyms_module_lskel();
+	if (test__start_subtest("libbpf"))
+		test_ksyms_module_libbpf();
+}
diff --git a/tools/testing/selftests/bpf/prog_tests/ksyms_module_libbpf.c b/tools/testing/selftests/bpf/prog_tests/ksyms_module_libbpf.c
deleted file mode 100644
index e6343ef63af9..000000000000
--- a/tools/testing/selftests/bpf/prog_tests/ksyms_module_libbpf.c
+++ /dev/null
@@ -1,28 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-
-#include <test_progs.h>
-#include <network_helpers.h>
-#include "test_ksyms_module.skel.h"
-
-void test_ksyms_module_libbpf(void)
-{
-	struct test_ksyms_module *skel;
-	int retval, err;
-
-	if (!env.has_testmod) {
-		test__skip();
-		return;
-	}
-
-	skel = test_ksyms_module__open_and_load();
-	if (!ASSERT_OK_PTR(skel, "test_ksyms_module__open"))
-		return;
-	err = bpf_prog_test_run(bpf_program__fd(skel->progs.load), 1, &pkt_v4,
-				sizeof(pkt_v4), NULL, NULL, (__u32 *)&retval, NULL);
-	if (!ASSERT_OK(err, "bpf_prog_test_run"))
-		goto cleanup;
-	ASSERT_EQ(retval, 0, "retval");
-	ASSERT_EQ(skel->bss->out_bpf_testmod_ksym, 42, "bpf_testmod_ksym");
-cleanup:
-	test_ksyms_module__destroy(skel);
-}
diff --git a/tools/testing/selftests/bpf/prog_tests/ringbuf.c b/tools/testing/selftests/bpf/prog_tests/ringbuf.c
index 4706cee84360..9a80fe8a6427 100644
--- a/tools/testing/selftests/bpf/prog_tests/ringbuf.c
+++ b/tools/testing/selftests/bpf/prog_tests/ringbuf.c
@@ -58,7 +58,7 @@ static int process_sample(void *ctx, void *data, size_t len)
 	}
 }
 
-static struct test_ringbuf *skel;
+static struct test_ringbuf_lskel *skel;
 static struct ring_buffer *ringbuf;
 
 static void trigger_samples()
@@ -90,13 +90,13 @@ void test_ringbuf(void)
 	int page_size = getpagesize();
 	void *mmap_ptr, *tmp_ptr;
 
-	skel = test_ringbuf__open();
+	skel = test_ringbuf_lskel__open();
 	if (CHECK(!skel, "skel_open", "skeleton open failed\n"))
 		return;
 
 	skel->maps.ringbuf.max_entries = page_size;
 
-	err = test_ringbuf__load(skel);
+	err = test_ringbuf_lskel__load(skel);
 	if (CHECK(err != 0, "skel_load", "skeleton load failed\n"))
 		goto cleanup;
 
@@ -154,7 +154,7 @@ void test_ringbuf(void)
 	if (CHECK(!ringbuf, "ringbuf_create", "failed to create ringbuf\n"))
 		goto cleanup;
 
-	err = test_ringbuf__attach(skel);
+	err = test_ringbuf_lskel__attach(skel);
 	if (CHECK(err, "skel_attach", "skeleton attachment failed: %d\n", err))
 		goto cleanup;
 
@@ -292,8 +292,8 @@ void test_ringbuf(void)
 	CHECK(skel->bss->discarded != 1, "err_discarded", "exp %ld, got %ld\n",
 	      1L, skel->bss->discarded);
 
-	test_ringbuf__detach(skel);
+	test_ringbuf_lskel__detach(skel);
 cleanup:
 	ring_buffer__free(ringbuf);
-	test_ringbuf__destroy(skel);
+	test_ringbuf_lskel__destroy(skel);
 }
diff --git a/tools/testing/selftests/bpf/prog_tests/trace_printk.c b/tools/testing/selftests/bpf/prog_tests/trace_printk.c
index 3f7a7141265e..cade7f12315f 100644
--- a/tools/testing/selftests/bpf/prog_tests/trace_printk.c
+++ b/tools/testing/selftests/bpf/prog_tests/trace_printk.c
@@ -10,27 +10,27 @@
 
 void serial_test_trace_printk(void)
 {
+	struct trace_printk_lskel__bss *bss;
 	int err = 0, iter = 0, found = 0;
-	struct trace_printk__bss *bss;
-	struct trace_printk *skel;
+	struct trace_printk_lskel *skel;
 	char *buf = NULL;
 	FILE *fp = NULL;
 	size_t buflen;
 
-	skel = trace_printk__open();
+	skel = trace_printk_lskel__open();
 	if (!ASSERT_OK_PTR(skel, "trace_printk__open"))
 		return;
 
 	ASSERT_EQ(skel->rodata->fmt[0], 'T', "skel->rodata->fmt[0]");
 	skel->rodata->fmt[0] = 't';
 
-	err = trace_printk__load(skel);
+	err = trace_printk_lskel__load(skel);
 	if (!ASSERT_OK(err, "trace_printk__load"))
 		goto cleanup;
 
 	bss = skel->bss;
 
-	err = trace_printk__attach(skel);
+	err = trace_printk_lskel__attach(skel);
 	if (!ASSERT_OK(err, "trace_printk__attach"))
 		goto cleanup;
 
@@ -43,7 +43,7 @@ void serial_test_trace_printk(void)
 
 	/* wait for tracepoint to trigger */
 	usleep(1);
-	trace_printk__detach(skel);
+	trace_printk_lskel__detach(skel);
 
 	if (!ASSERT_GT(bss->trace_printk_ran, 0, "bss->trace_printk_ran"))
 		goto cleanup;
@@ -65,7 +65,7 @@ void serial_test_trace_printk(void)
 		goto cleanup;
 
 cleanup:
-	trace_printk__destroy(skel);
+	trace_printk_lskel__destroy(skel);
 	free(buf);
 	if (fp)
 		fclose(fp);
diff --git a/tools/testing/selftests/bpf/prog_tests/trace_vprintk.c b/tools/testing/selftests/bpf/prog_tests/trace_vprintk.c
index 46101270cb1a..7a4e313e8558 100644
--- a/tools/testing/selftests/bpf/prog_tests/trace_vprintk.c
+++ b/tools/testing/selftests/bpf/prog_tests/trace_vprintk.c
@@ -10,20 +10,20 @@
 
 void serial_test_trace_vprintk(void)
 {
+	struct trace_vprintk_lskel__bss *bss;
 	int err = 0, iter = 0, found = 0;
-	struct trace_vprintk__bss *bss;
-	struct trace_vprintk *skel;
+	struct trace_vprintk_lskel *skel;
 	char *buf = NULL;
 	FILE *fp = NULL;
 	size_t buflen;
 
-	skel = trace_vprintk__open_and_load();
+	skel = trace_vprintk_lskel__open_and_load();
 	if (!ASSERT_OK_PTR(skel, "trace_vprintk__open_and_load"))
 		goto cleanup;
 
 	bss = skel->bss;
 
-	err = trace_vprintk__attach(skel);
+	err = trace_vprintk_lskel__attach(skel);
 	if (!ASSERT_OK(err, "trace_vprintk__attach"))
 		goto cleanup;
 
@@ -36,7 +36,7 @@ void serial_test_trace_vprintk(void)
 
 	/* wait for tracepoint to trigger */
 	usleep(1);
-	trace_vprintk__detach(skel);
+	trace_vprintk_lskel__detach(skel);
 
 	if (!ASSERT_GT(bss->trace_vprintk_ran, 0, "bss->trace_vprintk_ran"))
 		goto cleanup;
@@ -61,7 +61,7 @@ void serial_test_trace_vprintk(void)
 		goto cleanup;
 
 cleanup:
-	trace_vprintk__destroy(skel);
+	trace_vprintk_lskel__destroy(skel);
 	free(buf);
 	if (fp)
 		fclose(fp);
diff --git a/tools/testing/selftests/bpf/prog_tests/verif_stats.c b/tools/testing/selftests/bpf/prog_tests/verif_stats.c
index b4bae1340cf1..a47e7c0e1ffd 100644
--- a/tools/testing/selftests/bpf/prog_tests/verif_stats.c
+++ b/tools/testing/selftests/bpf/prog_tests/verif_stats.c
@@ -8,11 +8,11 @@
 void test_verif_stats(void)
 {
 	__u32 len = sizeof(struct bpf_prog_info);
+	struct trace_vprintk_lskel *skel;
 	struct bpf_prog_info info = {};
-	struct trace_vprintk *skel;
 	int err;
 
-	skel = trace_vprintk__open_and_load();
+	skel = trace_vprintk_lskel__open_and_load();
 	if (!ASSERT_OK_PTR(skel, "trace_vprintk__open_and_load"))
 		goto cleanup;
 
@@ -24,5 +24,5 @@ void test_verif_stats(void)
 		goto cleanup;
 
 cleanup:
-	trace_vprintk__destroy(skel);
+	trace_vprintk_lskel__destroy(skel);
 }
diff --git a/tools/testing/selftests/bpf/progs/test_ksyms_weak.c b/tools/testing/selftests/bpf/progs/test_ksyms_weak.c
index 5f8379aadb29..8eadbd4caf7a 100644
--- a/tools/testing/selftests/bpf/progs/test_ksyms_weak.c
+++ b/tools/testing/selftests/bpf/progs/test_ksyms_weak.c
@@ -38,7 +38,7 @@ int pass_handler(const void *ctx)
 	/* tests existing symbols. */
 	rq = (struct rq *)bpf_per_cpu_ptr(&runqueues, 0);
 	if (rq)
-		out__existing_typed = rq->cpu;
+		out__existing_typed = 0;
 	out__existing_typeless = (__u64)&bpf_prog_active;
 
 	/* tests non-existent symbols. */
-- 
2.33.1

