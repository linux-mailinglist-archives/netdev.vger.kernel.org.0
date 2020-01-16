Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5C313DBBA
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 14:27:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729096AbgAPN1r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 08:27:47 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:26492 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729039AbgAPN1q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 08:27:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579181265;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XuvIyltLM6t6CmNPpq0TOwT0hr9nkt4psYwYZFChnPA=;
        b=M1d/iEYRLYcaRSyd1/WUP54IlSPnhZyhBCrzWg+Ftv3plcuavOhluayjxUb0uftG0PVlqM
        Mmtmk42HkRnWXI5CaITtLmdzUv5SOHj1THX8vVCaYk/Ox189VEFAmlRNTjWsPsAo/m6DLr
        Ct0njPEkxW3UAygFv1l/Ox0bXtvPBL8=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-308-mH5yNorDNmqcfu8rEgFK-A-1; Thu, 16 Jan 2020 08:27:43 -0500
X-MC-Unique: mH5yNorDNmqcfu8rEgFK-A-1
Received: by mail-lj1-f199.google.com with SMTP id k21so5171794ljg.3
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 05:27:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=XuvIyltLM6t6CmNPpq0TOwT0hr9nkt4psYwYZFChnPA=;
        b=dOkAUObsHnahxUEcCUUlF2YvhCylshbK3Vce24/4Ix3Axnac3F8bgelnGEUnxqkGCG
         kJbWfYtXo8+TcFpx4ckVuaLJiTw1+3VhGa7XH0BYqOy2KdoJQl3sWQXkPVhFMNO2hxsi
         IViuKjQNVONnYJJ99x3CUCBk1ivO+clcwlBGBMbgldXoo8VcQBwB6AIfoXEHsEbG3by7
         Vn5BHq8E+AAeFBOWKZkVVLqQyb6IMkwfJcTVuzmHcobDrA8Av07G352ZuPoeIEYBXRgs
         7uKb123PKBrvz8BHl6GYNNuQ56jWWrH3jhuLRLGG/rker3o3SsAnwBLXS+kU8s1a12q9
         tOyg==
X-Gm-Message-State: APjAAAXAE4RsCYRq30BgcjUSm1qR5NorW2yOOvl7LO1ssT0uc35xZswV
        77IZoJii0fo8LwGiQtHzGwbh5slnsO3czCrCQ0B064yS05yOQ17xheQMjrmiELoimxjBRr4od61
        E6WW28VgVko+nPP+X
X-Received: by 2002:a2e:7e05:: with SMTP id z5mr2143919ljc.99.1579181262219;
        Thu, 16 Jan 2020 05:27:42 -0800 (PST)
X-Google-Smtp-Source: APXvYqwV2vEACriaMxMYq1+Yurp2SBRFnsPX7bITYsC6orHg17S25R+Ekjo1mt4jcs0IEhr7VeKwYg==
X-Received: by 2002:a2e:7e05:: with SMTP id z5mr2143893ljc.99.1579181261819;
        Thu, 16 Jan 2020 05:27:41 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id g27sm10722135lfj.49.2020.01.16.05.27.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 05:27:41 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id E326A1804D7; Thu, 16 Jan 2020 14:22:21 +0100 (CET)
Subject: [PATCH bpf-next v3 09/11] selftests: Remove tools/lib/bpf from
 include path
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kselftest@vger.kernel.org,
        clang-built-linux@googlegroups.com
Date:   Thu, 16 Jan 2020 14:22:21 +0100
Message-ID: <157918094179.1357254.14428494370073273452.stgit@toke.dk>
In-Reply-To: <157918093154.1357254.7616059374996162336.stgit@toke.dk>
References: <157918093154.1357254.7616059374996162336.stgit@toke.dk>
User-Agent: StGit/0.21
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

To make sure no new files are introduced that doesn't include the bpf/
prefix in its #include, remove tools/lib/bpf from the include path
entirely.

Instead, we introduce a new header files directory under the scratch tools/
dir, and add a rule to run the 'install_headers' rule from libbpf to have a
full set of consistent libbpf headers in $(OUTPUT)/tools/include/bpf, and
then use $(OUTPUT)/tools/include as the include path for selftests.

For consistency we also make sure we put all the scratch build files from
other bpftool and libbpf into tools/build/, so everything stays within
selftests/.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/testing/selftests/bpf/.gitignore |    1 +
 tools/testing/selftests/bpf/Makefile   |   50 +++++++++++++++++++-------------
 2 files changed, 31 insertions(+), 20 deletions(-)

diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/selftests/bpf/.gitignore
index 1d14e3ab70be..849be9990ad2 100644
--- a/tools/testing/selftests/bpf/.gitignore
+++ b/tools/testing/selftests/bpf/.gitignore
@@ -40,3 +40,4 @@ test_cpp
 /bpf_gcc
 /tools
 bpf_helper_defs.h
+/include/bpf
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 1fd7da49bd56..c3fa695bb028 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -20,8 +20,8 @@ CLANG		?= clang
 LLC		?= llc
 LLVM_OBJCOPY	?= llvm-objcopy
 BPF_GCC		?= $(shell command -v bpf-gcc;)
-CFLAGS += -g -Wall -O2 $(GENFLAGS) -I$(CURDIR) -I$(APIDIR) -I$(LIBDIR)  \
-	  -I$(BPFDIR) -I$(GENDIR) -I$(TOOLSINCDIR)			\
+CFLAGS += -g -Wall -O2 $(GENFLAGS) -I$(CURDIR) -I$(APIDIR)		 \
+	  -I$(INCLUDE_DIR) -I$(GENDIR) -I$(LIBDIR) -I$(TOOLSINCDIR)	\
 	  -Dbpf_prog_load=bpf_prog_test_load				\
 	  -Dbpf_load_program=bpf_test_load_program
 LDLIBS += -lcap -lelf -lz -lrt -lpthread
@@ -97,11 +97,15 @@ OVERRIDE_TARGETS := 1
 override define CLEAN
 	$(call msg,CLEAN)
 	$(RM) -r $(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED) $(TEST_GEN_FILES) $(EXTRA_CLEAN)
-	$(MAKE) -C $(BPFDIR) OUTPUT=$(OUTPUT)/ clean
 endef
 
 include ../lib.mk
 
+SCRATCH_DIR := $(OUTPUT)/tools
+BUILD_DIR := $(SCRATCH_DIR)/build
+INCLUDE_DIR := $(SCRATCH_DIR)/include
+INCLUDE_BPF := $(INCLUDE_DIR)/bpf/bpf.h
+
 # Define simple and short `make test_progs`, `make test_sysctl`, etc targets
 # to build individual tests.
 # NOTE: Semicolon at the end is critical to override lib.mk's default static
@@ -120,7 +124,7 @@ $(OUTPUT)/urandom_read: urandom_read.c
 	$(call msg,BINARY,,$@)
 	$(CC) -o $@ $< -Wl,--build-id
 
-$(OUTPUT)/test_stub.o: test_stub.c
+$(OUTPUT)/test_stub.o: test_stub.c $(INCLUDE_BPF)
 	$(call msg,CC,,$@)
 	$(CC) -c $(CFLAGS) -o $@ $<
 
@@ -129,7 +133,7 @@ $(OUTPUT)/runqslower: force
 	$(Q)$(MAKE) $(submake_extras) -C $(TOOLSDIR)/bpf/runqslower	      \
 		    OUTPUT=$(CURDIR)/tools/ VMLINUX_BTF=$(abspath ../../../../vmlinux)
 
-BPFOBJ := $(OUTPUT)/libbpf.a
+BPFOBJ := $(BUILD_DIR)/libbpf/libbpf.a
 
 $(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED): $(OUTPUT)/test_stub.o $(BPFOBJ)
 
@@ -155,17 +159,23 @@ force:
 DEFAULT_BPFTOOL := $(OUTPUT)/tools/sbin/bpftool
 BPFTOOL ?= $(DEFAULT_BPFTOOL)
 
-$(DEFAULT_BPFTOOL): force
-	$(Q)$(MAKE) $(submake_extras)  -C $(BPFTOOLDIR)			      \
+$(BUILD_DIR)/libbpf $(BUILD_DIR)/bpftool $(INCLUDE_DIR):
+	$(call msg,MKDIR,,$@)
+	mkdir -p $@
+
+$(DEFAULT_BPFTOOL): force $(BUILD_DIR)/bpftool
+	$(Q)$(MAKE) $(submake_extras)  -C $(BPFTOOLDIR)		\
+		    OUTPUT=$(BUILD_DIR)/bpftool/			\
 		    prefix= DESTDIR=$(OUTPUT)/tools/ install
 
-$(BPFOBJ): force
-	$(Q)$(MAKE) $(submake_extras) -C $(BPFDIR) OUTPUT=$(OUTPUT)/
+$(BPFOBJ): force $(BUILD_DIR)/libbpf
+	$(Q)$(MAKE) $(submake_extras) -C $(BPFDIR) \
+		OUTPUT=$(BUILD_DIR)/libbpf/
 
-BPF_HELPERS := $(OUTPUT)/bpf_helper_defs.h $(wildcard $(BPFDIR)/bpf_*.h)
-$(OUTPUT)/bpf_helper_defs.h: $(BPFOBJ)
-	$(Q)$(MAKE) $(submake_extras) -C $(BPFDIR)			      \
-		    OUTPUT=$(OUTPUT)/ $(OUTPUT)/bpf_helper_defs.h
+BPF_HELPERS := $(wildcard $(BPFDIR)/bpf_*.h) $(INCLUDE_BPF)
+$(INCLUDE_BPF): force $(BPFOBJ)
+	$(Q)$(MAKE) $(submake_extras) -C $(BPFDIR) install_headers \
+		OUTPUT=$(BUILD_DIR)/libbpf/ DESTDIR=$(SCRATCH_DIR) prefix=
 
 # Get Clang's default includes on this system, as opposed to those seen by
 # '-target bpf'. This fixes "missing" files on some architectures/distros,
@@ -185,8 +195,8 @@ MENDIAN=$(if $(IS_LITTLE_ENDIAN),-mlittle-endian,-mbig-endian)
 
 CLANG_SYS_INCLUDES = $(call get_sys_includes,$(CLANG))
 BPF_CFLAGS = -g -D__TARGET_ARCH_$(SRCARCH) $(MENDIAN) 			\
-	     -I$(OUTPUT) -I$(CURDIR) -I$(CURDIR)/include/uapi		\
-	     -I$(APIDIR) -I$(LIBDIR) -I$(BPFDIR) -I$(abspath $(OUTPUT)/../usr/include)
+	     -I$(INCLUDE_DIR) -I$(CURDIR) -I$(CURDIR)/include/uapi	\
+	     -I$(APIDIR) -I$(abspath $(OUTPUT)/../usr/include)
 
 CLANG_CFLAGS = $(CLANG_SYS_INCLUDES) \
 	       -Wno-compare-distinct-pointer-types
@@ -306,7 +316,7 @@ $(TRUNNER_TEST_OBJS): $(TRUNNER_OUTPUT)/%.test.o:			\
 		      $(TRUNNER_EXTRA_HDRS)				\
 		      $(TRUNNER_BPF_OBJS)				\
 		      $(TRUNNER_BPF_SKELS)				\
-		      $$(BPFOBJ) | $(TRUNNER_OUTPUT)
+		      $$(BPFOBJ) $$(INCLUDE_BPF) | $(TRUNNER_OUTPUT)
 	$$(call msg,TEST-OBJ,$(TRUNNER_BINARY),$$@)
 	cd $$(@D) && $$(CC) $$(CFLAGS) -c $(CURDIR)/$$< $$(LDLIBS) -o $$(@F)
 
@@ -314,7 +324,7 @@ $(TRUNNER_EXTRA_OBJS): $(TRUNNER_OUTPUT)/%.o:				\
 		       %.c						\
 		       $(TRUNNER_EXTRA_HDRS)				\
 		       $(TRUNNER_TESTS_HDR)				\
-		       $$(BPFOBJ) | $(TRUNNER_OUTPUT)
+		       $$(BPFOBJ) $$(INCLUDE_BPF) | $(TRUNNER_OUTPUT)
 	$$(call msg,EXT-OBJ,$(TRUNNER_BINARY),$$@)
 	$$(CC) $$(CFLAGS) -c $$< $$(LDLIBS) -o $$@
 
@@ -326,7 +336,7 @@ ifneq ($2,)
 endif
 
 $(OUTPUT)/$(TRUNNER_BINARY): $(TRUNNER_TEST_OBJS)			\
-			     $(TRUNNER_EXTRA_OBJS) $$(BPFOBJ)		\
+			     $(TRUNNER_EXTRA_OBJS) $$(BPFOBJ) $$(INCLUDE_BPF)		\
 			     | $(TRUNNER_BINARY)-extras
 	$$(call msg,BINARY,,$$@)
 	$$(CC) $$(CFLAGS) $$(filter %.a %.o,$$^) $$(LDLIBS) -o $$@
@@ -388,7 +398,7 @@ $(OUTPUT)/test_cpp: test_cpp.cpp $(OUTPUT)/test_core_extern.skel.h $(BPFOBJ)
 	$(call msg,CXX,,$@)
 	$(CXX) $(CFLAGS) $^ $(LDLIBS) -o $@
 
-EXTRA_CLEAN := $(TEST_CUSTOM_PROGS)					\
+EXTRA_CLEAN := $(TEST_CUSTOM_PROGS) $(SCRATCH_DIR)			\
 	prog_tests/tests.h map_tests/tests.h verifier/tests.h		\
 	feature								\
-	$(addprefix $(OUTPUT)/,*.o *.skel.h no_alu32 bpf_gcc tools)
+	$(addprefix $(OUTPUT)/,*.o *.skel.h no_alu32 bpf_gcc)

