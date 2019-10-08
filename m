Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80D4FD004B
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 20:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729601AbfJHSAD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 14:00:03 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:46328 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726336AbfJHSAC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 14:00:02 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x98HwNeX016094
        for <netdev@vger.kernel.org>; Tue, 8 Oct 2019 11:00:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=EJuqVxx3wneXBn8L0ow1TGNSVXoUG6JajOfqx/HFdHA=;
 b=ZH6KbRKGo4dtssGiEhZb4yndZdPi6b52IIghkQPzoS+gOdyDSoSTgMr1ZuU0IHi2Qbcf
 iKcgBjTSmj77zZ/I5U0zRT/KO7+GpZ6ZgtWuClEkY7R6oyCLAxOm1EJQBxk+FJqowzDY
 AG7xLsaO2qQd3/W1ndriniMt7VifuzsclXc= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vgpq9jr14-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 11:00:01 -0700
Received: from 2401:db00:30:6012:face:0:17:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Tue, 8 Oct 2019 11:00:00 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 009D28618D3; Tue,  8 Oct 2019 10:59:59 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v5 bpf-next 5/7] libbpf: move bpf_{helpers,helper_defs,endian,tracing}.h into libbpf
Date:   Tue, 8 Oct 2019 10:59:40 -0700
Message-ID: <20191008175942.1769476-6-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191008175942.1769476-1-andriin@fb.com>
References: <20191008175942.1769476-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-08_07:2019-10-08,2019-10-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=907
 bulkscore=0 impostorscore=0 lowpriorityscore=0 spamscore=0
 priorityscore=1501 malwarescore=0 phishscore=0 clxscore=1015 adultscore=0
 mlxscore=0 suspectscore=9 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910080143
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move bpf_helpers.h, bpf_tracing.h, and bpf_endian.h into libbpf. Move
bpf_helper_defs.h generation into libbpf's Makefile. Ensure all those
headers are installed along the other libbpf headers. Also, adjust
selftests and samples include path to include libbpf now.

Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 samples/bpf/Makefile                             |  2 +-
 tools/lib/bpf/.gitignore                         |  1 +
 tools/lib/bpf/Makefile                           | 16 ++++++++++++----
 .../{testing/selftests => lib}/bpf/bpf_endian.h  |  0
 .../{testing/selftests => lib}/bpf/bpf_helpers.h |  0
 .../{testing/selftests => lib}/bpf/bpf_tracing.h |  0
 tools/testing/selftests/bpf/.gitignore           |  1 -
 tools/testing/selftests/bpf/Makefile             | 10 +++-------
 8 files changed, 17 insertions(+), 13 deletions(-)
 rename tools/{testing/selftests => lib}/bpf/bpf_endian.h (100%)
 rename tools/{testing/selftests => lib}/bpf/bpf_helpers.h (100%)
 rename tools/{testing/selftests => lib}/bpf/bpf_tracing.h (100%)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 42b571cde177..ecb3535d91e3 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -283,7 +283,7 @@ $(obj)/hbm_edt_kern.o: $(src)/hbm.h $(src)/hbm_kern.h
 $(obj)/%.o: $(src)/%.c
 	@echo "  CLANG-bpf " $@
 	$(Q)$(CLANG) $(NOSTDINC_FLAGS) $(LINUXINCLUDE) $(EXTRA_CFLAGS) -I$(obj) \
-		-I$(srctree)/tools/testing/selftests/bpf/ \
+		-I$(srctree)/tools/testing/selftests/bpf/ -I$(srctree)/tools/lib/bpf/ \
 		-D__KERNEL__ -D__BPF_TRACING__ -Wno-unused-value -Wno-pointer-sign \
 		-D__TARGET_ARCH_$(SRCARCH) -Wno-compare-distinct-pointer-types \
 		-Wno-gnu-variable-sized-type-not-at-end \
diff --git a/tools/lib/bpf/.gitignore b/tools/lib/bpf/.gitignore
index 12382b0c71c7..35bf013e368c 100644
--- a/tools/lib/bpf/.gitignore
+++ b/tools/lib/bpf/.gitignore
@@ -6,3 +6,4 @@ libbpf.so.*
 TAGS
 tags
 cscope.*
+/bpf_helper_defs.h
diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
index 10b77644a17c..974453564f01 100644
--- a/tools/lib/bpf/Makefile
+++ b/tools/lib/bpf/Makefile
@@ -157,7 +157,7 @@ all: fixdep
 
 all_cmd: $(CMD_TARGETS) check
 
-$(BPF_IN): force elfdep bpfdep
+$(BPF_IN): force elfdep bpfdep bpf_helper_defs.h
 	@(test -f ../../include/uapi/linux/bpf.h -a -f ../../../include/uapi/linux/bpf.h && ( \
 	(diff -B ../../include/uapi/linux/bpf.h ../../../include/uapi/linux/bpf.h >/dev/null) || \
 	echo "Warning: Kernel ABI header at 'tools/include/uapi/linux/bpf.h' differs from latest version at 'include/uapi/linux/bpf.h'" >&2 )) || true
@@ -175,6 +175,10 @@ $(BPF_IN): force elfdep bpfdep
 	echo "Warning: Kernel ABI header at 'tools/include/uapi/linux/if_xdp.h' differs from latest version at 'include/uapi/linux/if_xdp.h'" >&2 )) || true
 	$(Q)$(MAKE) $(build)=libbpf
 
+bpf_helper_defs.h: $(srctree)/include/uapi/linux/bpf.h
+	$(Q)$(srctree)/scripts/bpf_helpers_doc.py --header 		\
+		--file $(srctree)/include/uapi/linux/bpf.h > bpf_helper_defs.h
+
 $(OUTPUT)libbpf.so: $(OUTPUT)libbpf.so.$(LIBBPF_VERSION)
 
 $(OUTPUT)libbpf.so.$(LIBBPF_VERSION): $(BPF_IN)
@@ -236,13 +240,17 @@ install_lib: all_cmd
 		$(call do_install_mkdir,$(libdir_SQ)); \
 		cp -fpR $(LIB_FILE) $(DESTDIR)$(libdir_SQ)
 
-install_headers:
+install_headers: bpf_helper_defs.h
 	$(call QUIET_INSTALL, headers) \
 		$(call do_install,bpf.h,$(prefix)/include/bpf,644); \
 		$(call do_install,libbpf.h,$(prefix)/include/bpf,644); \
 		$(call do_install,btf.h,$(prefix)/include/bpf,644); \
 		$(call do_install,libbpf_util.h,$(prefix)/include/bpf,644); \
-		$(call do_install,xsk.h,$(prefix)/include/bpf,644);
+		$(call do_install,xsk.h,$(prefix)/include/bpf,644); \
+		$(call do_install,bpf_helpers.h,$(prefix)/include/bpf,644); \
+		$(call do_install,bpf_helper_defs.h,$(prefix)/include/bpf,644); \
+		$(call do_install,bpf_tracing.h,$(prefix)/include/bpf,644); \
+		$(call do_install,bpf_endian.h,$(prefix)/include/bpf,644);
 
 install_pkgconfig: $(PC_FILE)
 	$(call QUIET_INSTALL, $(PC_FILE)) \
@@ -259,7 +267,7 @@ config-clean:
 clean:
 	$(call QUIET_CLEAN, libbpf) $(RM) $(TARGETS) $(CXX_TEST_TARGET) \
 		*.o *~ *.a *.so *.so.$(LIBBPF_MAJOR_VERSION) .*.d .*.cmd \
-		*.pc LIBBPF-CFLAGS
+		*.pc LIBBPF-CFLAGS bpf_helper_defs.h
 	$(call QUIET_CLEAN, core-gen) $(RM) $(OUTPUT)FEATURE-DUMP.libbpf
 
 
diff --git a/tools/testing/selftests/bpf/bpf_endian.h b/tools/lib/bpf/bpf_endian.h
similarity index 100%
rename from tools/testing/selftests/bpf/bpf_endian.h
rename to tools/lib/bpf/bpf_endian.h
diff --git a/tools/testing/selftests/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
similarity index 100%
rename from tools/testing/selftests/bpf/bpf_helpers.h
rename to tools/lib/bpf/bpf_helpers.h
diff --git a/tools/testing/selftests/bpf/bpf_tracing.h b/tools/lib/bpf/bpf_tracing.h
similarity index 100%
rename from tools/testing/selftests/bpf/bpf_tracing.h
rename to tools/lib/bpf/bpf_tracing.h
diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/selftests/bpf/.gitignore
index 50063f66539d..7470327edcfe 100644
--- a/tools/testing/selftests/bpf/.gitignore
+++ b/tools/testing/selftests/bpf/.gitignore
@@ -39,4 +39,3 @@ libbpf.so.*
 test_hashmap
 test_btf_dump
 xdping
-/bpf_helper_defs.h
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 771a4e82128b..90944b7a8274 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -90,10 +90,6 @@ include ../lib.mk
 TEST_CUSTOM_PROGS = $(OUTPUT)/urandom_read
 all: $(TEST_CUSTOM_PROGS)
 
-bpf_helper_defs.h: $(APIDIR)/linux/bpf.h
-	$(BPFDIR)/../../../scripts/bpf_helpers_doc.py --header 		\
-		--file $(APIDIR)/linux/bpf.h > bpf_helper_defs.h
-
 $(OUTPUT)/urandom_read: $(OUTPUT)/%: %.c
 	$(CC) -o $@ $< -Wl,--build-id
 
@@ -127,7 +123,7 @@ $(OUTPUT)/test_cgroup_attach: cgroup_helpers.c
 # force a rebuild of BPFOBJ when its dependencies are updated
 force:
 
-$(BPFOBJ): force bpf_helper_defs.h
+$(BPFOBJ): force
 	$(MAKE) -C $(BPFDIR) OUTPUT=$(OUTPUT)/
 
 PROBE := $(shell $(LLC) -march=bpf -mcpu=probe -filetype=null /dev/null 2>&1)
@@ -152,7 +148,7 @@ $(shell $(1) -v -E - </dev/null 2>&1 \
 endef
 CLANG_SYS_INCLUDES = $(call get_sys_includes,$(CLANG))
 BPF_CFLAGS = -I. -I./include/uapi -I../../../include/uapi \
-	     -I$(OUTPUT)/../usr/include -D__TARGET_ARCH_$(SRCARCH)
+	     -I$(BPFDIR) -I$(OUTPUT)/../usr/include -D__TARGET_ARCH_$(SRCARCH)
 
 CLANG_CFLAGS = $(CLANG_SYS_INCLUDES) \
 	       -Wno-compare-distinct-pointer-types
@@ -323,4 +319,4 @@ $(VERIFIER_TESTS_H): $(VERIFIER_TEST_FILES) | $(VERIFIER_TESTS_DIR)
 
 EXTRA_CLEAN := $(TEST_CUSTOM_PROGS) $(ALU32_BUILD_DIR) $(BPF_GCC_BUILD_DIR) \
 	$(VERIFIER_TESTS_H) $(PROG_TESTS_H) $(MAP_TESTS_H) \
-	feature bpf_helper_defs.h
+	feature
-- 
2.17.1

