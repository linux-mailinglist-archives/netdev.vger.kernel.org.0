Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E642E306ABC
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 02:53:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231133AbhA1BwX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 20:52:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbhA1BwO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 20:52:14 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92FBDC061574;
        Wed, 27 Jan 2021 17:51:33 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id kg20so5466396ejc.4;
        Wed, 27 Jan 2021 17:51:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=APM/j64XJ64toEHsmY/3rHQUz6ZGR8j9tLguMFaF1jg=;
        b=BhtLdpqElIQ4v960FzTsQkjcTWfOx/hJJ573l0QiDZh1y2ViL9KJDWgSvzStSgMbj9
         hkvQVH0bZWL9P5fxuubMCW7wASm+/x9YZ/FkgkNh+hOypv51sYsmgzBWLP3448O0NKdx
         kIHJztUnGo9h0WXKFsrGvpU9dMhaZM94etGgallF9tDtdsQ0624l8l2pmQxYdZgwKoZo
         anmKprjGSCWxJK5zGsmsGklidj1QjYIc6SPdtnkj6XCzpdnYf/Ypq98k0eP0dUIwYobV
         ehmzQU5YEL3XXlkM3z/IknbFDPOn8Sa0RIKEeoGw55mR05gO7QFhOtdNkv+2DP02yM32
         DQTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=APM/j64XJ64toEHsmY/3rHQUz6ZGR8j9tLguMFaF1jg=;
        b=GG4zgr96dxNwOIIP+S5wOi8Br6PEJq2BxCOwkoEH1z3GOARGyrSd4dmG25pnUCDoHk
         r7J/ZiOs6QspquEFGTpEteeZQMNlVVRPU/uhSwKtwkFzSAcTorheThuze9QGtXYBR9ow
         tQdbmUPbR9hsc3jE/rWY7awELpZrGsZ8yk0k0KiZi8nCrIBKQjGKdqcbHvffzeWbpevB
         gn/qjbeFIUBE7EnPxxhOrCGGNTx5Rz/POFpPfSBlQXqP3qptOvjLFDYUPaW3wfPqKSwx
         aSgBIxxkp1pZetwev02OwsZimRtryB6uYO0Dl5GndJk0Xp/5WERYNJf0vVzO+7g9qdar
         qSQw==
X-Gm-Message-State: AOAM532bFvAlrLBERO57uRwPWSyNLY++QeHdMFw5zpv68wq5SpsZ+i67
        ux1IB42KVmae6WnwNiWiwDY=
X-Google-Smtp-Source: ABdhPJwce9SBC+OVGSSnm3XN8ibbrolKNzCaDCbl7vdBiAjsneGheJELpoxTNQxpM+wX8AHmgDJnQg==
X-Received: by 2002:a17:907:104e:: with SMTP id oy14mr8583617ejb.276.1611798692278;
        Wed, 27 Jan 2021 17:51:32 -0800 (PST)
Received: from localhost.localdomain (ip-109-40-66-249.web.vodafone.de. [109.40.66.249])
        by smtp.gmail.com with ESMTPSA id p10sm1610141ejb.82.2021.01.27.17.51.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jan 2021 17:51:31 -0800 (PST)
From:   Sedat Dilek <sedat.dilek@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Quentin Monnet <quentin@isovalent.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Tobias Klauser <tklauser@distanz.ch>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Yulia Kartseva <hex@fb.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Thomas Hebb <tommyhebb@gmail.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Davide Caratti <dcaratti@redhat.com>,
        Briana Oursler <briana.oursler@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH bpf-next] tools: Factor Clang, LLC and LLVM utils definitions
Date:   Thu, 28 Jan 2021 02:50:58 +0100
Message-Id: <20210128015117.20515-1-sedat.dilek@gmail.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When dealing with BPF/BTF/pahole and DWARF v5 I wanted to build bpftool.

While looking into the source code I found duplicate assignments
in misc tools for the LLVM eco system, e.g. clang and llvm-objcopy.

Move the Clang, LLC and/or LLVM utils definitions to
tools/scripts/Makefile.include file and add missing
includes where needed.
Honestly, I was inspired by commit c8a950d0d3b9
("tools: Factor HOSTCC, HOSTLD, HOSTAR definitions").

I tested with bpftool and perf on Debian/testing AMD64 and
LLVM/Clang v11.1.0-rc1.

Build instructions:

[ make and make-options ]
MAKE="make V=1"
MAKE_OPTS="HOSTCC=clang HOSTCXX=clang++ HOSTLD=ld.lld CC=clang LD=ld.lld LLVM=1 LLVM_IAS=1"
MAKE_OPTS="$MAKE_OPTS PAHOLE=/opt/pahole/bin/pahole"

[ clean-up ]
$MAKE $MAKE_OPTS -C tools/ clean

[ bpftool ]
$MAKE $MAKE_OPTS -C tools/bpf/bpftool/

[ perf ]
PYTHON=python3 $MAKE $MAKE_OPTS -C tools/perf/

I was careful with respecting the user's wish to override custom compiler,
linker, GNU/binutils and/or LLVM utils settings.

Some personal notes:
1. I have NOT tested with cross-toolchain for other archs (cross compiler/linker etc.).
2. This patch is on top of bpf-next.

CC: bpf@vger.kernel.org
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Jiri Olsa <jolsa@redhat.com> # tools/build and tools/perf
Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
---
 tools/bpf/bpftool/Makefile                  | 2 --
 tools/bpf/runqslower/Makefile               | 3 ---
 tools/build/feature/Makefile                | 4 ++--
 tools/perf/Makefile.perf                    | 1 -
 tools/scripts/Makefile.include              | 7 +++++++
 tools/testing/selftests/bpf/Makefile        | 2 --
 tools/testing/selftests/tc-testing/Makefile | 3 +--
 7 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
index 45ac2f9e0aa9..8ced1655fea6 100644
--- a/tools/bpf/bpftool/Makefile
+++ b/tools/bpf/bpftool/Makefile
@@ -75,8 +75,6 @@ endif
 
 INSTALL ?= install
 RM ?= rm -f
-CLANG ?= clang
-LLVM_STRIP ?= llvm-strip
 
 FEATURE_USER = .bpftool
 FEATURE_TESTS = libbfd disassembler-four-args reallocarray zlib libcap \
diff --git a/tools/bpf/runqslower/Makefile b/tools/bpf/runqslower/Makefile
index 4d5ca54fcd4c..9d9fb6209be1 100644
--- a/tools/bpf/runqslower/Makefile
+++ b/tools/bpf/runqslower/Makefile
@@ -3,9 +3,6 @@ include ../../scripts/Makefile.include
 
 OUTPUT ?= $(abspath .output)/
 
-CLANG ?= clang
-LLC ?= llc
-LLVM_STRIP ?= llvm-strip
 BPFTOOL_OUTPUT := $(OUTPUT)bpftool/
 DEFAULT_BPFTOOL := $(BPFTOOL_OUTPUT)bpftool
 BPFTOOL ?= $(DEFAULT_BPFTOOL)
diff --git a/tools/build/feature/Makefile b/tools/build/feature/Makefile
index 89ba522e377d..3e55edb3ea54 100644
--- a/tools/build/feature/Makefile
+++ b/tools/build/feature/Makefile
@@ -1,4 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
+include ../../scripts/Makefile.include
+
 FILES=                                          \
          test-all.bin                           \
          test-backtrace.bin                     \
@@ -76,8 +78,6 @@ FILES=                                          \
 FILES := $(addprefix $(OUTPUT),$(FILES))
 
 PKG_CONFIG ?= $(CROSS_COMPILE)pkg-config
-LLVM_CONFIG ?= llvm-config
-CLANG ?= clang
 
 all: $(FILES)
 
diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 62f3deb1d3a8..f4df7534026d 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -176,7 +176,6 @@ endef
 LD += $(EXTRA_LDFLAGS)
 
 PKG_CONFIG = $(CROSS_COMPILE)pkg-config
-LLVM_CONFIG ?= llvm-config
 
 RM      = rm -f
 LN      = ln -f
diff --git a/tools/scripts/Makefile.include b/tools/scripts/Makefile.include
index 1358e89cdf7d..4255e71f72b7 100644
--- a/tools/scripts/Makefile.include
+++ b/tools/scripts/Makefile.include
@@ -69,6 +69,13 @@ HOSTCC  ?= gcc
 HOSTLD  ?= ld
 endif
 
+# Some tools require Clang, LLC and/or LLVM utils
+CLANG		?= clang
+LLC		?= llc
+LLVM_CONFIG	?= llvm-config
+LLVM_OBJCOPY	?= llvm-objcopy
+LLVM_STRIP	?= llvm-strip
+
 ifeq ($(CC_NO_CLANG), 1)
 EXTRA_WARNINGS += -Wstrict-aliasing=3
 endif
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 63d6288e419c..f0674d406f40 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -19,8 +19,6 @@ ifneq ($(wildcard $(GENHDR)),)
   GENFLAGS := -DHAVE_GENHDR
 endif
 
-CLANG		?= clang
-LLVM_OBJCOPY	?= llvm-objcopy
 BPF_GCC		?= $(shell command -v bpf-gcc;)
 SAN_CFLAGS	?=
 CFLAGS += -g -rdynamic -Wall -O2 $(GENFLAGS) $(SAN_CFLAGS)		\
diff --git a/tools/testing/selftests/tc-testing/Makefile b/tools/testing/selftests/tc-testing/Makefile
index 91fee5c43274..4d639279f41e 100644
--- a/tools/testing/selftests/tc-testing/Makefile
+++ b/tools/testing/selftests/tc-testing/Makefile
@@ -1,4 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
+include ../../../scripts/Makefile.include
 
 top_srcdir = $(abspath ../../../..)
 APIDIR := $(top_scrdir)/include/uapi
@@ -7,8 +8,6 @@ TEST_GEN_FILES = action.o
 KSFT_KHDR_INSTALL := 1
 include ../lib.mk
 
-CLANG ?= clang
-LLC   ?= llc
 PROBE := $(shell $(LLC) -march=bpf -mcpu=probe -filetype=null /dev/null 2>&1)
 
 ifeq ($(PROBE),)
-- 
2.30.0

