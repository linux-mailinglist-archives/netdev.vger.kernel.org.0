Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4ECC9D19E0
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 22:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732161AbfJIUl7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 16:41:59 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:34697 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732056AbfJIUl6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 16:41:58 -0400
Received: by mail-lj1-f194.google.com with SMTP id j19so3922136lja.1
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 13:41:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=TqVgt5uW0tXMG2sk40opbI2NrMbssP1O1eKE+O8MvT0=;
        b=m4lZEO5QxxgG0iUAh/n+7T8cEuXB06R4+fN1LAS+noEfh1S4La6fqeY8VrdjGCu5f4
         U/qCnidh2zdlC6coi3ZrToWntpnvr5s6lpt3ui4ab1TMOADlVqk3BX9lrD2+GjinwK8V
         0V84OwDiyquZcuK/m9FXYotQi79M+8eI+v33LDt9xvHL2BmaDxxZAgAo60H/CUu/cWWP
         egL5pHebN+dzhMoFix7N4ankAWi/3ynKyfw5QZFj8UQcc36OAm1BS7AnE571Tr8qla8O
         Dcvx2oaL4d1d1JvyGJe7k36iJvmvSMzlEgd9u+tR3GMXcqKBabLBN2Uh8YJynQZdnFmv
         XfUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=TqVgt5uW0tXMG2sk40opbI2NrMbssP1O1eKE+O8MvT0=;
        b=aOor3BzCern6ibrurvKQr849uaBoIAgcj5KvD4IcFRHmTrf3RJDoVL5SeiIYlUICdb
         7EccMIXtjxnHX5q4ESBpLDLhugsuP1GJ8VTKnuLa/mTT4EvcDuKCWP/pt80YQwsRTDqr
         GAjUHPyfxOuajJFj0EHIzj2Mz9qrMmRKq7b2c8uy0GiRJ2H6tz0IUK93PwAg8MXS+Tet
         6RD2UJIQorchgf+2TRb6AYoaBs061qATRg0QHr0rdPL/2gbA5MAqz16BVaCHoiCV1FFU
         kTjb4jDOAI00IQe6ONCtjGvqwT62Xj5NN3n12/oxSb5sKXCDfDd4nx1eQiMv/3FQAvdA
         AY5g==
X-Gm-Message-State: APjAAAUrDnGo+WNskMXU1C9DRuthpd1A1RsvPFFKJTMFXShJM/589NZU
        kAOR+KRn6eIZi5xh6cP0ZXfr7Q==
X-Google-Smtp-Source: APXvYqzhciIS3QFbE9tJNmXm8AxC9UtqdHRFvBviZeQAY8lrhsgLrN92Bd6fDMx520UWSjkjgOoIvw==
X-Received: by 2002:a2e:964c:: with SMTP id z12mr3473099ljh.79.1570653714859;
        Wed, 09 Oct 2019 13:41:54 -0700 (PDT)
Received: from localhost.localdomain (168-200-94-178.pool.ukrtel.net. [178.94.200.168])
        by smtp.gmail.com with ESMTPSA id h3sm730871ljf.12.2019.10.09.13.41.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 13:41:54 -0700 (PDT)
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     ast@kernel.org, daniel@iogearbox.net, yhs@fb.com,
        davem@davemloft.net, jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com,
        ilias.apalodimas@linaro.org, sergei.shtylyov@cogentembedded.com,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH v4 bpf-next 11/15] libbpf: don't use cxx to test_libpf target
Date:   Wed,  9 Oct 2019 23:41:30 +0300
Message-Id: <20191009204134.26960-12-ivan.khoronzhuk@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191009204134.26960-1-ivan.khoronzhuk@linaro.org>
References: <20191009204134.26960-1-ivan.khoronzhuk@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No need to use C++ for test_libbpf target when libbpf is on C and it
can be tested with C, after this change the CXXFLAGS in makefiles can
be avoided, at least in bpf samples, when sysroot is used, passing
same C/LDFLAGS as for lib.

Add "return 0" in test_libbpf to void warn, but also remove spaces at
start of the lines to keep same style and avoid warns while apply.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
---
 tools/lib/bpf/Makefile                         | 18 +++++-------------
 .../lib/bpf/{test_libbpf.cpp => test_libbpf.c} | 14 ++++++++------
 2 files changed, 13 insertions(+), 19 deletions(-)
 rename tools/lib/bpf/{test_libbpf.cpp => test_libbpf.c} (61%)

diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
index 1270955e4845..46280b5ad48d 100644
--- a/tools/lib/bpf/Makefile
+++ b/tools/lib/bpf/Makefile
@@ -52,7 +52,7 @@ ifndef VERBOSE
 endif
 
 FEATURE_USER = .libbpf
-FEATURE_TESTS = libelf libelf-mmap bpf reallocarray cxx
+FEATURE_TESTS = libelf libelf-mmap bpf reallocarray
 FEATURE_DISPLAY = libelf bpf
 
 INCLUDES = -I. -I$(srctree)/tools/include -I$(srctree)/tools/arch/$(ARCH)/include/uapi -I$(srctree)/tools/include/uapi
@@ -142,15 +142,7 @@ GLOBAL_SYM_COUNT = $(shell readelf -s --wide $(BPF_IN) | \
 VERSIONED_SYM_COUNT = $(shell readelf -s --wide $(OUTPUT)libbpf.so | \
 			      grep -Eo '[^ ]+@LIBBPF_' | cut -d@ -f1 | sort -u | wc -l)
 
-CMD_TARGETS = $(LIB_TARGET) $(PC_FILE)
-
-CXX_TEST_TARGET = $(OUTPUT)test_libbpf
-
-ifeq ($(feature-cxx), 1)
-	CMD_TARGETS += $(CXX_TEST_TARGET)
-endif
-
-TARGETS = $(CMD_TARGETS)
+CMD_TARGETS = $(LIB_TARGET) $(PC_FILE) $(OUTPUT)test_libbpf
 
 all: fixdep
 	$(Q)$(MAKE) all_cmd
@@ -190,8 +182,8 @@ $(OUTPUT)libbpf.so.$(LIBBPF_VERSION): $(BPF_IN)
 $(OUTPUT)libbpf.a: $(BPF_IN)
 	$(QUIET_LINK)$(RM) $@; $(AR) rcs $@ $^
 
-$(OUTPUT)test_libbpf: test_libbpf.cpp $(OUTPUT)libbpf.a
-	$(QUIET_LINK)$(CXX) $(INCLUDES) $^ -lelf -o $@
+$(OUTPUT)test_libbpf: test_libbpf.c $(OUTPUT)libbpf.a
+	$(QUIET_LINK)$(CC) $(INCLUDES) $^ -lelf -o $@
 
 $(OUTPUT)libbpf.pc:
 	$(QUIET_GEN)sed -e "s|@PREFIX@|$(prefix)|" \
@@ -266,7 +258,7 @@ config-clean:
 	$(Q)$(MAKE) -C $(srctree)/tools/build/feature/ clean >/dev/null
 
 clean:
-	$(call QUIET_CLEAN, libbpf) $(RM) $(TARGETS) $(CXX_TEST_TARGET) \
+	$(call QUIET_CLEAN, libbpf) $(RM) $(CMD_TARGETS) \
 		*.o *~ *.a *.so *.so.$(LIBBPF_MAJOR_VERSION) .*.d .*.cmd \
 		*.pc LIBBPF-CFLAGS bpf_helper_defs.h
 	$(call QUIET_CLEAN, core-gen) $(RM) $(OUTPUT)FEATURE-DUMP.libbpf
diff --git a/tools/lib/bpf/test_libbpf.cpp b/tools/lib/bpf/test_libbpf.c
similarity index 61%
rename from tools/lib/bpf/test_libbpf.cpp
rename to tools/lib/bpf/test_libbpf.c
index fc134873bb6d..f0eb2727b766 100644
--- a/tools/lib/bpf/test_libbpf.cpp
+++ b/tools/lib/bpf/test_libbpf.c
@@ -7,12 +7,14 @@
 
 int main(int argc, char *argv[])
 {
-    /* libbpf.h */
-    libbpf_set_print(NULL);
+	/* libbpf.h */
+	libbpf_set_print(NULL);
 
-    /* bpf.h */
-    bpf_prog_get_fd_by_id(0);
+	/* bpf.h */
+	bpf_prog_get_fd_by_id(0);
 
-    /* btf.h */
-    btf__new(NULL, 0);
+	/* btf.h */
+	btf__new(NULL, 0);
+
+	return 0;
 }
-- 
2.17.1

