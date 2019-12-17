Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE8112248A
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 07:14:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727807AbfLQGO6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 01:14:58 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:26228 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725836AbfLQGO5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 01:14:57 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBH6AD1b023333
        for <netdev@vger.kernel.org>; Mon, 16 Dec 2019 22:14:56 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=zEAPZ00dgAfQpetaVxX1P1hxvWQMrrVSaFMstS9jsP8=;
 b=G2ICYaT2DWcPEyi0vFknPVypTi5CvxUuNAW7bQCAPuRNUy3MCLpIXBoXeB1EZk++l+Q6
 pFrRraITEDmkaVI3e6OHZ9hZ+sZoJR8x5GBMOFEDqptLdig5OE6lErT1Wz5XVmM8/mnu
 IxOkZDq2Qd4MfCto35G6RvP/qbe6D3yME4Q= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2wwgayr1wj-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 16 Dec 2019 22:14:56 -0800
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 16 Dec 2019 22:14:55 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 2D2902EC1A0D; Mon, 16 Dec 2019 22:14:54 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next] selftests/bpf: more succinct Makefile output
Date:   Mon, 16 Dec 2019 22:14:25 -0800
Message-ID: <20191217061425.2346359-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-17_01:2019-12-16,2019-12-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 suspectscore=9 clxscore=1015 malwarescore=0 priorityscore=1501
 mlxlogscore=999 phishscore=0 mlxscore=0 lowpriorityscore=0 bulkscore=0
 adultscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1912170055
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similarly to bpftool/libbpf output, make selftests/bpf output succinct
per-item output line. Output is roughly as follows:

$ make
...
  CLANG-LLC [test_maps] pyperf600.o
  CLANG-LLC [test_maps] strobemeta.o
  CLANG-LLC [test_maps] pyperf100.o
  EXTRA-OBJ [test_progs] cgroup_helpers.o
  EXTRA-OBJ [test_progs] trace_helpers.o
     BINARY test_align
     BINARY test_verifier_log
   GEN-SKEL [test_progs] fexit_bpf2bpf.skel.h
   GEN-SKEL [test_progs] test_global_data.skel.h
   GEN-SKEL [test_progs] sendmsg6_prog.skel.h
...

To see the actual command invocation, verbose mode can be turned on with V=1
argument:

$ make V=1

... very verbose output ...

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/Makefile | 36 ++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index ba90621617a8..c652bd84ef0e 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -77,6 +77,24 @@ TEST_GEN_PROGS_EXTENDED = test_sock_addr test_skb_cgroup_id_user \
 
 TEST_CUSTOM_PROGS = urandom_read
 
+# Emit succinct information message describing current building step
+# $1 - generic step name (e.g., CC, LINK, etc);
+# $2 - optional "flavor" specifier; if provided, will be emitted as [flavor];
+# $3 - target (assumed to be file); only file name will be emitted;
+# $4 - optional extra arg, emitted as-is, if provided.
+ifeq ($(V),1)
+msg =
+else
+msg = @$(info $(1)$(if $(2), [$(2)]) $(notdir $(3)))$(if $(4), $(4))
+endif
+
+# override lib.mk's default rules
+OVERRIDE_TARGETS := 1
+override define CLEAN
+	$(call msg,    CLEAN)
+	$(RM) -r $(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED) $(TEST_GEN_FILES) $(EXTRA_CLEAN)
+endef
+
 include ../lib.mk
 
 # Define simple and short `make test_progs`, `make test_sysctl`, etc targets
@@ -89,10 +107,16 @@ $(notdir $(TEST_GEN_PROGS)						\
 	 $(TEST_GEN_PROGS_EXTENDED)					\
 	 $(TEST_CUSTOM_PROGS)): %: $(OUTPUT)/% ;
 
+$(OUTPUT)/%:%.c
+	$(call msg,     BINARY,,$@)
+	$(LINK.c) $^ $(LDLIBS) -o $@
+
 $(OUTPUT)/urandom_read: urandom_read.c
+	$(call msg,     BINARY,,$@)
 	$(CC) -o $@ $< -Wl,--build-id
 
 $(OUTPUT)/test_stub.o: test_stub.c
+	$(call msg,         CC,,$@)
 	$(CC) -c $(CFLAGS) -o $@ $<
 
 BPFOBJ := $(OUTPUT)/libbpf.a
@@ -167,24 +191,28 @@ $(OUTPUT)/flow_dissector_load.o: flow_dissector_load.h
 # $3 - CFLAGS
 # $4 - LDFLAGS
 define CLANG_BPF_BUILD_RULE
+	$(call msg,  CLANG-LLC,$(TRUNNER_BINARY),$2)
 	($(CLANG) $3 -O2 -target bpf -emit-llvm				\
 		-c $1 -o - || echo "BPF obj compilation failed") | 	\
 	$(LLC) -mattr=dwarfris -march=bpf -mcpu=probe $4 -filetype=obj -o $2
 endef
 # Similar to CLANG_BPF_BUILD_RULE, but with disabled alu32
 define CLANG_NOALU32_BPF_BUILD_RULE
+	$(call msg,  CLANG-LLC,$(TRUNNER_BINARY),$2)
 	($(CLANG) $3 -O2 -target bpf -emit-llvm				\
 		-c $1 -o - || echo "BPF obj compilation failed") | 	\
 	$(LLC) -march=bpf -mcpu=v2 $4 -filetype=obj -o $2
 endef
 # Similar to CLANG_BPF_BUILD_RULE, but using native Clang and bpf LLC
 define CLANG_NATIVE_BPF_BUILD_RULE
+	$(call msg,  CLANG-BPF,$(TRUNNER_BINARY),$2)
 	($(CLANG) $3 -O2 -emit-llvm					\
 		-c $1 -o - || echo "BPF obj compilation failed") | 	\
 	$(LLC) -march=bpf -mcpu=probe $4 -filetype=obj -o $2
 endef
 # Build BPF object using GCC
 define GCC_BPF_BUILD_RULE
+	$(call msg,    GCC-BPF,$(TRUNNER_BINARY),$2)
 	$(BPF_GCC) $3 $4 -O2 -c $1 -o $2
 endef
 
@@ -243,6 +271,7 @@ $(TRUNNER_BPF_OBJS): $(TRUNNER_OUTPUT)/%.o:				\
 $(TRUNNER_BPF_SKELS): $(TRUNNER_OUTPUT)/%.skel.h:			\
 		      $(TRUNNER_OUTPUT)/%.o				\
 		      | $(BPFTOOL) $(TRUNNER_OUTPUT)
+	$$(call msg,   GEN-SKEL,$(TRUNNER_BINARY),$$@)
 	$$(BPFTOOL) gen skeleton $$< > $$@
 endif
 
@@ -250,6 +279,7 @@ endif
 ifeq ($($(TRUNNER_TESTS_DIR)-tests-hdr),)
 $(TRUNNER_TESTS_DIR)-tests-hdr := y
 $(TRUNNER_TESTS_HDR): $(TRUNNER_TESTS_DIR)/*.c
+	$$(call msg,   TEST-HDR,$(TRUNNER_BINARY),$$@)
 	$$(shell ( cd $(TRUNNER_TESTS_DIR);				\
 		  echo '/* Generated header, do not edit */';		\
 		  ls *.c 2> /dev/null |					\
@@ -265,6 +295,7 @@ $(TRUNNER_TEST_OBJS): $(TRUNNER_OUTPUT)/%.test.o:			\
 		      $(TRUNNER_BPF_OBJS)				\
 		      $(TRUNNER_BPF_SKELS)				\
 		      $$(BPFOBJ) | $(TRUNNER_OUTPUT)
+	$$(call msg,   TEST-OBJ,$(TRUNNER_BINARY),$$@)
 	cd $$(@D) && $$(CC) $$(CFLAGS) -c $(CURDIR)/$$< $$(LDLIBS) -o $$(@F)
 
 $(TRUNNER_EXTRA_OBJS): $(TRUNNER_OUTPUT)/%.o:				\
@@ -272,17 +303,20 @@ $(TRUNNER_EXTRA_OBJS): $(TRUNNER_OUTPUT)/%.o:				\
 		       $(TRUNNER_EXTRA_HDRS)				\
 		       $(TRUNNER_TESTS_HDR)				\
 		       $$(BPFOBJ) | $(TRUNNER_OUTPUT)
+	$$(call msg,  EXTRA-OBJ,$(TRUNNER_BINARY),$$@)
 	$$(CC) $$(CFLAGS) -c $$< $$(LDLIBS) -o $$@
 
 # only copy extra resources if in flavored build
 $(TRUNNER_BINARY)-extras: $(TRUNNER_EXTRA_FILES) | $(TRUNNER_OUTPUT)
 ifneq ($2,)
+	$$(call msg,  EXTRAS-CP,$(TRUNNER_BINARY),$(TRUNNER_EXTRA_FILES))
 	cp -a $$^ $(TRUNNER_OUTPUT)/
 endif
 
 $(OUTPUT)/$(TRUNNER_BINARY): $(TRUNNER_TEST_OBJS)			\
 			     $(TRUNNER_EXTRA_OBJS) $$(BPFOBJ)		\
 			     | $(TRUNNER_BINARY)-extras
+	$$(call msg,     BINARY,,$$@)
 	$$(CC) $$(CFLAGS) $$(filter %.a %.o,$$^) $$(LDLIBS) -o $$@
 
 endef
@@ -334,10 +368,12 @@ verifier/tests.h: verifier/*.c
 		  echo '#endif' \
 		) > verifier/tests.h)
 $(OUTPUT)/test_verifier: test_verifier.c verifier/tests.h $(BPFOBJ) | $(OUTPUT)
+	$(call msg,     BINARY,,$@)
 	$(CC) $(CFLAGS) $(filter %.a %.o %.c,$^) $(LDLIBS) -o $@
 
 # Make sure we are able to include and link libbpf against c++.
 $(OUTPUT)/test_cpp: test_cpp.cpp $(BPFOBJ)
+	$(call msg,        CXX,,$@)
 	$(CXX) $(CFLAGS) $^ $(LDLIBS) -o $@
 
 EXTRA_CLEAN := $(TEST_CUSTOM_PROGS)					\
-- 
2.17.1

