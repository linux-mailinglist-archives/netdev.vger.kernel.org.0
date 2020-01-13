Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19E9B138C5D
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 08:32:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728841AbgAMHb7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 02:31:59 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:60900 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728827AbgAMHb6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 02:31:58 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00D7UfQi017547
        for <netdev@vger.kernel.org>; Sun, 12 Jan 2020 23:31:57 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=uMHNl+cNAZq93kqfu4Zm2nnSJLIKdYL/gUK77t3GSIw=;
 b=puNfF2wXCUVqR2ZftxUItCNfrYOcOIKvIvnWq9/TU33EGVALbk7cG3KlyNJdHo6cM0lU
 0sTa3cswRcR2NNtS36AnRedn86SpAQq8ze11hSV3EEuCLYv15GSuylCb7wUB+oB8vpC4
 DpXjbsFLUjcjLp3yGXdGWpAmL+4EX5rFn5w= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2xfxt43866-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sun, 12 Jan 2020 23:31:57 -0800
Received: from intmgw002.41.prn1.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Sun, 12 Jan 2020 23:31:56 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id EBB6C2EC2329; Sun, 12 Jan 2020 23:31:54 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 3/6] selftests/bpf: conform selftests/bpf Makefile output to libbpf and bpftool
Date:   Sun, 12 Jan 2020 23:31:40 -0800
Message-ID: <20200113073143.1779940-4-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200113073143.1779940-1-andriin@fb.com>
References: <20200113073143.1779940-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-13_01:2020-01-13,2020-01-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 clxscore=1015 mlxlogscore=999 impostorscore=0 priorityscore=1501
 spamscore=0 adultscore=0 lowpriorityscore=0 suspectscore=9 bulkscore=0
 malwarescore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001130063
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bring selftest/bpf's Makefile output to the same format used by libbpf and
bpftool: 2 spaces of padding on the left + 8-character left-aligned build step
identifier.

Also, hide feature detection output by default. Can be enabled back by setting
V=1.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/Makefile | 47 +++++++++++++++-------------
 1 file changed, 25 insertions(+), 22 deletions(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index c28e67548f45..bf9f7e415e95 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -87,14 +87,15 @@ Q =
 msg =
 else
 Q = @
-msg = @$(info $(1)$(if $(2), [$(2)]) $(notdir $(3)))$(if $(4), $(4))
+msg = @printf '  %-8s%s %s%s\n' "$(1)" "$(if $(2), [$(2)])" "$(notdir $(3))" "$(if $(4), $(4))";
 MAKEFLAGS += --no-print-directory
+submake_extras := feature_display=0
 endif
 
 # override lib.mk's default rules
 OVERRIDE_TARGETS := 1
 override define CLEAN
-	$(call msg,    CLEAN)
+	$(call msg,CLEAN)
 	$(RM) -r $(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED) $(TEST_GEN_FILES) $(EXTRA_CLEAN)
 	$(MAKE) -C $(BPFDIR) OUTPUT=$(OUTPUT)/ clean
 endef
@@ -112,15 +113,15 @@ $(notdir $(TEST_GEN_PROGS)						\
 	 $(TEST_CUSTOM_PROGS)): %: $(OUTPUT)/% ;
 
 $(OUTPUT)/%:%.c
-	$(call msg,     BINARY,,$@)
+	$(call msg,BINARY,,$@)
 	$(LINK.c) $^ $(LDLIBS) -o $@
 
 $(OUTPUT)/urandom_read: urandom_read.c
-	$(call msg,     BINARY,,$@)
+	$(call msg,BINARY,,$@)
 	$(CC) -o $@ $< -Wl,--build-id
 
 $(OUTPUT)/test_stub.o: test_stub.c
-	$(call msg,         CC,,$@)
+	$(call msg,CC,,$@)
 	$(CC) -c $(CFLAGS) -o $@ $<
 
 BPFOBJ := $(OUTPUT)/libbpf.a
@@ -146,18 +147,20 @@ $(OUTPUT)/test_sysctl: cgroup_helpers.c
 # force a rebuild of BPFOBJ when its dependencies are updated
 force:
 
-DEFAULT_BPFTOOL := $(OUTPUT)/tools/usr/local/sbin/bpftool
+DEFAULT_BPFTOOL := $(OUTPUT)/tools/sbin/bpftool
 BPFTOOL ?= $(DEFAULT_BPFTOOL)
 
 $(DEFAULT_BPFTOOL): force
-	$(Q)$(MAKE) -C $(BPFTOOLDIR) DESTDIR=$(OUTPUT)/tools install
+	$(Q)$(MAKE) $(submake_extras)  -C $(BPFTOOLDIR)			      \
+		    prefix= DESTDIR=$(OUTPUT)/tools/ install
 
 $(BPFOBJ): force
-	$(Q)$(MAKE) -C $(BPFDIR) OUTPUT=$(OUTPUT)/
+	$(Q)$(MAKE) $(submake_extras) -C $(BPFDIR) OUTPUT=$(OUTPUT)/
 
 BPF_HELPERS := $(OUTPUT)/bpf_helper_defs.h $(wildcard $(BPFDIR)/bpf_*.h)
 $(OUTPUT)/bpf_helper_defs.h: $(BPFOBJ)
-	$(Q)$(MAKE) -C $(BPFDIR) OUTPUT=$(OUTPUT)/ $(OUTPUT)/bpf_helper_defs.h
+	$(Q)$(MAKE) $(submake_extras) -C $(BPFDIR)			      \
+		    OUTPUT=$(OUTPUT)/ $(OUTPUT)/bpf_helper_defs.h
 
 # Get Clang's default includes on this system, as opposed to those seen by
 # '-target bpf'. This fixes "missing" files on some architectures/distros,
@@ -194,28 +197,28 @@ $(OUTPUT)/flow_dissector_load.o: flow_dissector_load.h
 # $3 - CFLAGS
 # $4 - LDFLAGS
 define CLANG_BPF_BUILD_RULE
-	$(call msg,  CLANG-LLC,$(TRUNNER_BINARY),$2)
+	$(call msg,CLNG-LLC,$(TRUNNER_BINARY),$2)
 	($(CLANG) $3 -O2 -target bpf -emit-llvm				\
 		-c $1 -o - || echo "BPF obj compilation failed") | 	\
 	$(LLC) -mattr=dwarfris -march=bpf -mcpu=probe $4 -filetype=obj -o $2
 endef
 # Similar to CLANG_BPF_BUILD_RULE, but with disabled alu32
 define CLANG_NOALU32_BPF_BUILD_RULE
-	$(call msg,  CLANG-LLC,$(TRUNNER_BINARY),$2)
+	$(call msg,CLNG-LLC,$(TRUNNER_BINARY),$2)
 	($(CLANG) $3 -O2 -target bpf -emit-llvm				\
 		-c $1 -o - || echo "BPF obj compilation failed") | 	\
 	$(LLC) -march=bpf -mcpu=v2 $4 -filetype=obj -o $2
 endef
 # Similar to CLANG_BPF_BUILD_RULE, but using native Clang and bpf LLC
 define CLANG_NATIVE_BPF_BUILD_RULE
-	$(call msg,  CLANG-BPF,$(TRUNNER_BINARY),$2)
+	$(call msg,CLNG-BPF,$(TRUNNER_BINARY),$2)
 	($(CLANG) $3 -O2 -emit-llvm					\
 		-c $1 -o - || echo "BPF obj compilation failed") | 	\
 	$(LLC) -march=bpf -mcpu=probe $4 -filetype=obj -o $2
 endef
 # Build BPF object using GCC
 define GCC_BPF_BUILD_RULE
-	$(call msg,    GCC-BPF,$(TRUNNER_BINARY),$2)
+	$(call msg,GCC-BPF,$(TRUNNER_BINARY),$2)
 	$(BPF_GCC) $3 $4 -O2 -c $1 -o $2
 endef
 
@@ -256,7 +259,7 @@ define DEFINE_TEST_RUNNER_RULES
 ifeq ($($(TRUNNER_OUTPUT)-dir),)
 $(TRUNNER_OUTPUT)-dir := y
 $(TRUNNER_OUTPUT):
-	$$(call msg,      MKDIR,,$$@)
+	$$(call msg,MKDIR,,$$@)
 	mkdir -p $$@
 endif
 
@@ -275,7 +278,7 @@ $(TRUNNER_BPF_OBJS): $(TRUNNER_OUTPUT)/%.o:				\
 $(TRUNNER_BPF_SKELS): $(TRUNNER_OUTPUT)/%.skel.h:			\
 		      $(TRUNNER_OUTPUT)/%.o				\
 		      | $(BPFTOOL) $(TRUNNER_OUTPUT)
-	$$(call msg,   GEN-SKEL,$(TRUNNER_BINARY),$$@)
+	$$(call msg,GEN-SKEL,$(TRUNNER_BINARY),$$@)
 	$$(BPFTOOL) gen skeleton $$< > $$@
 endif
 
@@ -283,7 +286,7 @@ endif
 ifeq ($($(TRUNNER_TESTS_DIR)-tests-hdr),)
 $(TRUNNER_TESTS_DIR)-tests-hdr := y
 $(TRUNNER_TESTS_HDR): $(TRUNNER_TESTS_DIR)/*.c
-	$$(call msg,   TEST-HDR,$(TRUNNER_BINARY),$$@)
+	$$(call msg,TEST-HDR,$(TRUNNER_BINARY),$$@)
 	$$(shell ( cd $(TRUNNER_TESTS_DIR);				\
 		  echo '/* Generated header, do not edit */';		\
 		  ls *.c 2> /dev/null |					\
@@ -299,7 +302,7 @@ $(TRUNNER_TEST_OBJS): $(TRUNNER_OUTPUT)/%.test.o:			\
 		      $(TRUNNER_BPF_OBJS)				\
 		      $(TRUNNER_BPF_SKELS)				\
 		      $$(BPFOBJ) | $(TRUNNER_OUTPUT)
-	$$(call msg,   TEST-OBJ,$(TRUNNER_BINARY),$$@)
+	$$(call msg,TEST-OBJ,$(TRUNNER_BINARY),$$@)
 	cd $$(@D) && $$(CC) $$(CFLAGS) -c $(CURDIR)/$$< $$(LDLIBS) -o $$(@F)
 
 $(TRUNNER_EXTRA_OBJS): $(TRUNNER_OUTPUT)/%.o:				\
@@ -307,20 +310,20 @@ $(TRUNNER_EXTRA_OBJS): $(TRUNNER_OUTPUT)/%.o:				\
 		       $(TRUNNER_EXTRA_HDRS)				\
 		       $(TRUNNER_TESTS_HDR)				\
 		       $$(BPFOBJ) | $(TRUNNER_OUTPUT)
-	$$(call msg,  EXTRA-OBJ,$(TRUNNER_BINARY),$$@)
+	$$(call msg,EXT-OBJ,$(TRUNNER_BINARY),$$@)
 	$$(CC) $$(CFLAGS) -c $$< $$(LDLIBS) -o $$@
 
 # only copy extra resources if in flavored build
 $(TRUNNER_BINARY)-extras: $(TRUNNER_EXTRA_FILES) | $(TRUNNER_OUTPUT)
 ifneq ($2,)
-	$$(call msg,  EXTRAS-CP,$(TRUNNER_BINARY),$(TRUNNER_EXTRA_FILES))
+	$$(call msg,EXT-COPY,$(TRUNNER_BINARY),$(TRUNNER_EXTRA_FILES))
 	cp -a $$^ $(TRUNNER_OUTPUT)/
 endif
 
 $(OUTPUT)/$(TRUNNER_BINARY): $(TRUNNER_TEST_OBJS)			\
 			     $(TRUNNER_EXTRA_OBJS) $$(BPFOBJ)		\
 			     | $(TRUNNER_BINARY)-extras
-	$$(call msg,     BINARY,,$$@)
+	$$(call msg,BINARY,,$$@)
 	$$(CC) $$(CFLAGS) $$(filter %.a %.o,$$^) $$(LDLIBS) -o $$@
 
 endef
@@ -372,12 +375,12 @@ verifier/tests.h: verifier/*.c
 		  echo '#endif' \
 		) > verifier/tests.h)
 $(OUTPUT)/test_verifier: test_verifier.c verifier/tests.h $(BPFOBJ) | $(OUTPUT)
-	$(call msg,     BINARY,,$@)
+	$(call msg,BINARY,,$@)
 	$(CC) $(CFLAGS) $(filter %.a %.o %.c,$^) $(LDLIBS) -o $@
 
 # Make sure we are able to include and link libbpf against c++.
 $(OUTPUT)/test_cpp: test_cpp.cpp $(OUTPUT)/test_core_extern.skel.h $(BPFOBJ)
-	$(call msg,        CXX,,$@)
+	$(call msg,CXX,,$@)
 	$(CXX) $(CFLAGS) $^ $(LDLIBS) -o $@
 
 EXTRA_CLEAN := $(TEST_CUSTOM_PROGS)					\
-- 
2.17.1

