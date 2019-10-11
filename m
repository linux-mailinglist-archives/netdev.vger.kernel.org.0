Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E9E2D4A2D
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 00:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729346AbfJKWEl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 18:04:41 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:9828 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728993AbfJKWEk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 18:04:40 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9BM3ik1023916
        for <netdev@vger.kernel.org>; Fri, 11 Oct 2019 15:04:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=w/7rYNnNANPTHWzl6P9abe3B5bXTGHBwVfxrhtNd3oc=;
 b=JNH94K2ZAHlhJebwoe9wzt/obOSBquJkGXldTWyxnZHcLbGpe3xfSh+kjo2ctT67K9Pf
 BdTCVjIrxN0Aef36NC93m6lcCIJARLfBVJmDdd/8AFkHojiy7RYZo5O9Y4ysXJ4EXxba
 OHCIG3LhbR5HNSqQQA3W3qgrNm72nWeQl/k= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vjtsujdbs-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 11 Oct 2019 15:04:39 -0700
Received: from ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) by
 ash-exhub201.TheFacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 11 Oct 2019 15:02:31 -0700
Received: from 2401:db00:12:9028:face:0:29:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 11 Oct 2019 15:02:00 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id F305D861869; Fri, 11 Oct 2019 15:01:51 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v2 bpf-next 2/2] selftests/bpf: remove obsolete pahole/BTF support detection
Date:   Fri, 11 Oct 2019 15:01:46 -0700
Message-ID: <20191011220146.3798961-3-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191011220146.3798961-1-andriin@fb.com>
References: <20191011220146.3798961-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-11_11:2019-10-10,2019-10-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 bulkscore=0 phishscore=0
 suspectscore=8 impostorscore=0 mlxlogscore=999 malwarescore=0 adultscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910110177
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Given lots of selftests won't work without recent enough Clang/LLVM that
fully supports BTF, there is no point in maintaining outdated BTF
support detection and fall-back to pahole logic. Just assume we have
everything we need.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/Makefile | 54 ++++------------------------
 1 file changed, 6 insertions(+), 48 deletions(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index f958643d36da..00d05c5e2d57 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -15,8 +15,6 @@ endif
 CLANG		?= clang
 LLC		?= llc
 LLVM_OBJCOPY	?= llvm-objcopy
-LLVM_READELF	?= llvm-readelf
-BTF_PAHOLE	?= pahole
 BPF_GCC		?= $(shell command -v bpf-gcc;)
 CFLAGS += -g -Wall -O2 -I$(APIDIR) -I$(LIBDIR) -I$(BPFDIR) -I$(GENDIR) $(GENFLAGS) -I../../../include \
 	  -Dbpf_prog_load=bpf_prog_test_load \
@@ -126,16 +124,6 @@ force:
 $(BPFOBJ): force
 	$(MAKE) -C $(BPFDIR) OUTPUT=$(OUTPUT)/
 
-PROBE := $(shell $(LLC) -march=bpf -mcpu=probe -filetype=null /dev/null 2>&1)
-
-# Let newer LLVM versions transparently probe the kernel for availability
-# of full BPF instruction set.
-ifeq ($(PROBE),)
-  CPU ?= probe
-else
-  CPU ?= generic
-endif
-
 # Get Clang's default includes on this system, as opposed to those seen by
 # '-target bpf'. This fixes "missing" files on some architectures/distros,
 # such as asm/byteorder.h, asm/socket.h, asm/sockios.h, sys/cdefs.h etc.
@@ -147,8 +135,9 @@ $(shell $(1) -v -E - </dev/null 2>&1 \
 	| sed -n '/<...> search starts here:/,/End of search list./{ s| \(/.*\)|-idirafter \1|p }')
 endef
 CLANG_SYS_INCLUDES = $(call get_sys_includes,$(CLANG))
-BPF_CFLAGS = -I. -I./include/uapi -I../../../include/uapi \
-	     -I$(BPFDIR) -I$(OUTPUT)/../usr/include -D__TARGET_ARCH_$(SRCARCH)
+BPF_CFLAGS = -g -D__TARGET_ARCH_$(SRCARCH) 				\
+	     -I. -I./include/uapi -I../../../include/uapi 		\
+	     -I$(BPFDIR) -I$(OUTPUT)/../usr/include
 
 CLANG_CFLAGS = $(CLANG_SYS_INCLUDES) \
 	       -Wno-compare-distinct-pointer-types
@@ -162,28 +151,6 @@ $(OUTPUT)/test_stack_map.o: test_queue_stack_map.h
 $(OUTPUT)/flow_dissector_load.o: flow_dissector_load.h
 $(OUTPUT)/test_progs.o: flow_dissector_load.h
 
-BTF_LLC_PROBE := $(shell $(LLC) -march=bpf -mattr=help 2>&1 | grep dwarfris)
-BTF_PAHOLE_PROBE := $(shell $(BTF_PAHOLE) --help 2>&1 | grep BTF)
-BTF_OBJCOPY_PROBE := $(shell $(LLVM_OBJCOPY) --help 2>&1 | grep -i 'usage.*llvm')
-BTF_LLVM_PROBE := $(shell echo "int main() { return 0; }" | \
-			  $(CLANG) -target bpf -O2 -g -c -x c - -o ./llvm_btf_verify.o; \
-			  $(LLVM_READELF) -S ./llvm_btf_verify.o | grep BTF; \
-			  /bin/rm -f ./llvm_btf_verify.o)
-
-ifneq ($(BTF_LLVM_PROBE),)
-	BPF_CFLAGS += -g
-else
-ifneq ($(BTF_LLC_PROBE),)
-ifneq ($(BTF_PAHOLE_PROBE),)
-ifneq ($(BTF_OBJCOPY_PROBE),)
-	BPF_CFLAGS += -g
-	LLC_FLAGS += -mattr=dwarfris
-	DWARF2BTF = y
-endif
-endif
-endif
-endif
-
 TEST_PROGS_CFLAGS := -I. -I$(OUTPUT)
 TEST_MAPS_CFLAGS := -I. -I$(OUTPUT)
 TEST_VERIFIER_CFLAGS := -I. -I$(OUTPUT) -Iverifier
@@ -212,11 +179,8 @@ $(ALU32_BUILD_DIR)/%.o: progs/%.c $(ALU32_BUILD_DIR)/test_progs_32 \
 					| $(ALU32_BUILD_DIR)
 	($(CLANG) $(BPF_CFLAGS) $(CLANG_CFLAGS) -O2 -target bpf -emit-llvm \
 		-c $< -o - || echo "clang failed") | \
-	$(LLC) -march=bpf -mattr=+alu32 -mcpu=$(CPU) $(LLC_FLAGS) \
+	$(LLC) -march=bpf -mcpu=probe -mattr=+alu32 $(LLC_FLAGS) \
 		-filetype=obj -o $@
-ifeq ($(DWARF2BTF),y)
-	$(BTF_PAHOLE) -J $@
-endif
 endif
 
 ifneq ($(BPF_GCC),)
@@ -251,19 +215,13 @@ endif
 $(OUTPUT)/test_xdp.o: progs/test_xdp.c
 	($(CLANG) $(BPF_CFLAGS) $(CLANG_CFLAGS) -O2 -emit-llvm -c $< -o - || \
 		echo "clang failed") | \
-	$(LLC) -march=bpf -mcpu=$(CPU) $(LLC_FLAGS) -filetype=obj -o $@
-ifeq ($(DWARF2BTF),y)
-	$(BTF_PAHOLE) -J $@
-endif
+	$(LLC) -march=bpf -mcpu=probe $(LLC_FLAGS) -filetype=obj -o $@
 
 # libbpf has to be built before BPF programs due to bpf_helper_defs.h
 $(OUTPUT)/%.o: progs/%.c | $(BPFOBJ)
 	($(CLANG) $(BPF_CFLAGS) $(CLANG_CFLAGS) -O2 -target bpf -emit-llvm \
 		-c $< -o - || echo "clang failed") | \
-	$(LLC) -march=bpf -mcpu=$(CPU) $(LLC_FLAGS) -filetype=obj -o $@
-ifeq ($(DWARF2BTF),y)
-	$(BTF_PAHOLE) -J $@
-endif
+	$(LLC) -march=bpf -mcpu=probe $(LLC_FLAGS) -filetype=obj -o $@
 
 PROG_TESTS_DIR = $(OUTPUT)/prog_tests
 $(PROG_TESTS_DIR):
-- 
2.17.1

