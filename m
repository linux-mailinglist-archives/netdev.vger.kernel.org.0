Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B4A4274D3D
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 01:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbgIVXV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 19:21:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726629AbgIVXVy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 19:21:54 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFA8AC0613D4
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 16:21:53 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id v106so17664491ybi.6
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 16:21:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=tGcXn3sDm57uE3gVQiqH/xFvLNTI0/uhdj25yBP9OJM=;
        b=cAARJB9tQz4JFwu+kbKkxA+YQXekK4ONh76aUVGk60ANDFmn3LzczEkxUmIX4dGUqE
         5+GexyhewVbiCnAS31iStuersWlZoY0hTROpLlnUSlfVGrQHCJ2YtjP4qsvuUxs3VDh7
         0LVX4wegpTtuYdKicQnFOMYiwk5PNRomalJTdjJ5fYR0jNP2Vw9EjgKuYUk0iI+OGons
         5gnMGnR6RFuE7FhM0OmkQ375mP8hPvNt8oJ+AXJdM0lKaRwJ7H7wmg4i61m2rzjx4Aw1
         yT7rcgrxPn1Wd2aPKjHIaDsFP4mx6wTg/AFk910wUEuvevcrWly6ccaxezXXXi5tE90G
         ZlUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=tGcXn3sDm57uE3gVQiqH/xFvLNTI0/uhdj25yBP9OJM=;
        b=lhdhBLMbT7iwWDxjfsb+vgYikL0Qs23FV9KbKAD+V0MJ2X6wvsoUOkqfFa/44GmEVt
         ICscH9oEZIfX7JdDPZciNnT6jdhn35E4SbF88IBI9MiiO2YrjtrIAh33zJE3JhFAQ6N8
         oSn77GeBAuqf9qBXVWMi8qImQtlIAUztBxINHAQNLjSYKk2P9ImCWo2lW1GQCjg+uSZg
         n2gZnKlQYsfv3MwCGLiVMQOHuVsRy5Guv5rG0/O0R53EThS5LWi3ciJppplP101HMjyz
         /ZrrbzZVL1lEHOYOxtZxKwDXC6JjEDbWZOv65E5g4urD5acoM7KCGScUvg2x3Y+wUUWT
         niYA==
X-Gm-Message-State: AOAM533K+VHeSSCsFv+3cN7l87rD2v1ggCIkB/9T2enxBeNLB09cedYp
        /D53Q7N3T0pgAYmLLDq03QMdiv7Q
X-Google-Smtp-Source: ABdhPJxUgxwW4VA+vB29eR+veCkKgDowzHp+nyf81WrQ9ev1/t+X3X9+s1UrsuH08x6IBr4JM162UcMNug==
Sender: "morbo via sendgmr" <morbo@fawn.svl.corp.google.com>
X-Received: from fawn.svl.corp.google.com ([2620:15c:2cd:202:7220:84ff:fe0f:9f6a])
 (user=morbo job=sendgmr) by 2002:a25:3453:: with SMTP id b80mr10708338yba.237.1600816912562;
 Tue, 22 Sep 2020 16:21:52 -0700 (PDT)
Date:   Tue, 22 Sep 2020 16:21:40 -0700
Message-Id: <20200922232140.1994390-1-morbo@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH] kbuild: explicitly specify the build id style
From:   Bill Wendling <morbo@google.com>
To:     linux-kbuild@vger.kernel.org
Cc:     Masahiro Yamada <yamada.masahiro@socionext.com>,
        Andy Lutomirski <luto@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Will Deacon <will@kernel.org>,
        "H . Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        sparclinux@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ld's --build-id defaults to "sha1" style, while lld defaults to "fast".
The build IDs are very different between the two, which may confuse
programs that reference them.

Signed-off-by: Bill Wendling <morbo@google.com>
---
 Makefile                             | 4 ++--
 arch/arm/vdso/Makefile               | 2 +-
 arch/arm64/kernel/vdso/Makefile      | 2 +-
 arch/arm64/kernel/vdso32/Makefile    | 2 +-
 arch/mips/vdso/Makefile              | 2 +-
 arch/riscv/kernel/vdso/Makefile      | 2 +-
 arch/s390/kernel/vdso64/Makefile     | 2 +-
 arch/sparc/vdso/Makefile             | 2 +-
 arch/x86/entry/vdso/Makefile         | 2 +-
 tools/testing/selftests/bpf/Makefile | 2 +-
 10 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/Makefile b/Makefile
index 2b66d3398878..7e6f41c9803a 100644
--- a/Makefile
+++ b/Makefile
@@ -973,8 +973,8 @@ KBUILD_CPPFLAGS += $(KCPPFLAGS)
 KBUILD_AFLAGS   += $(KAFLAGS)
 KBUILD_CFLAGS   += $(KCFLAGS)
 
-KBUILD_LDFLAGS_MODULE += --build-id
-LDFLAGS_vmlinux += --build-id
+KBUILD_LDFLAGS_MODULE += --build-id=sha1
+LDFLAGS_vmlinux += --build-id=sha1
 
 ifeq ($(CONFIG_STRIP_ASM_SYMS),y)
 LDFLAGS_vmlinux	+= $(call ld-option, -X,)
diff --git a/arch/arm/vdso/Makefile b/arch/arm/vdso/Makefile
index a54f70731d9f..150ce6e6a5d3 100644
--- a/arch/arm/vdso/Makefile
+++ b/arch/arm/vdso/Makefile
@@ -19,7 +19,7 @@ ccflags-y += -DDISABLE_BRANCH_PROFILING -DBUILD_VDSO32
 ldflags-$(CONFIG_CPU_ENDIAN_BE8) := --be8
 ldflags-y := -Bsymbolic --no-undefined -soname=linux-vdso.so.1 \
 	    -z max-page-size=4096 -nostdlib -shared $(ldflags-y) \
-	    --hash-style=sysv --build-id \
+	    --hash-style=sysv --build-id=sha1 \
 	    -T
 
 obj-$(CONFIG_VDSO) += vdso.o
diff --git a/arch/arm64/kernel/vdso/Makefile b/arch/arm64/kernel/vdso/Makefile
index 45d5cfe46429..871915097f9d 100644
--- a/arch/arm64/kernel/vdso/Makefile
+++ b/arch/arm64/kernel/vdso/Makefile
@@ -24,7 +24,7 @@ btildflags-$(CONFIG_ARM64_BTI_KERNEL) += -z force-bti
 # routines, as x86 does (see 6f121e548f83 ("x86, vdso: Reimplement vdso.so
 # preparation in build-time C")).
 ldflags-y := -shared -nostdlib -soname=linux-vdso.so.1 --hash-style=sysv	\
-	     -Bsymbolic $(call ld-option, --no-eh-frame-hdr) --build-id -n	\
+	     -Bsymbolic $(call ld-option, --no-eh-frame-hdr) --build-id=sha1 -n	\
 	     $(btildflags-y) -T
 
 ccflags-y := -fno-common -fno-builtin -fno-stack-protector -ffixed-x18
diff --git a/arch/arm64/kernel/vdso32/Makefile b/arch/arm64/kernel/vdso32/Makefile
index d6adb4677c25..4fa4b3fe8efb 100644
--- a/arch/arm64/kernel/vdso32/Makefile
+++ b/arch/arm64/kernel/vdso32/Makefile
@@ -128,7 +128,7 @@ VDSO_LDFLAGS += -Wl,-Bsymbolic -Wl,--no-undefined -Wl,-soname=linux-vdso.so.1
 VDSO_LDFLAGS += -Wl,-z,max-page-size=4096 -Wl,-z,common-page-size=4096
 VDSO_LDFLAGS += -nostdlib -shared -mfloat-abi=soft
 VDSO_LDFLAGS += -Wl,--hash-style=sysv
-VDSO_LDFLAGS += -Wl,--build-id
+VDSO_LDFLAGS += -Wl,--build-id=sha1
 VDSO_LDFLAGS += $(call cc32-ldoption,-fuse-ld=bfd)
 
 
diff --git a/arch/mips/vdso/Makefile b/arch/mips/vdso/Makefile
index 57fe83235281..5810cc12bc1d 100644
--- a/arch/mips/vdso/Makefile
+++ b/arch/mips/vdso/Makefile
@@ -61,7 +61,7 @@ endif
 # VDSO linker flags.
 ldflags-y := -Bsymbolic --no-undefined -soname=linux-vdso.so.1 \
 	$(filter -E%,$(KBUILD_CFLAGS)) -nostdlib -shared \
-	-G 0 --eh-frame-hdr --hash-style=sysv --build-id -T
+	-G 0 --eh-frame-hdr --hash-style=sysv --build-id=sha1 -T
 
 CFLAGS_REMOVE_vdso.o = -pg
 
diff --git a/arch/riscv/kernel/vdso/Makefile b/arch/riscv/kernel/vdso/Makefile
index 478e7338ddc1..7d6a94d45ec9 100644
--- a/arch/riscv/kernel/vdso/Makefile
+++ b/arch/riscv/kernel/vdso/Makefile
@@ -49,7 +49,7 @@ $(obj)/vdso.so.dbg: $(src)/vdso.lds $(obj-vdso) FORCE
 # refer to these symbols in the kernel code rather than hand-coded addresses.
 
 SYSCFLAGS_vdso.so.dbg = -shared -s -Wl,-soname=linux-vdso.so.1 \
-	-Wl,--build-id -Wl,--hash-style=both
+	-Wl,--build-id=sha1 -Wl,--hash-style=both
 $(obj)/vdso-dummy.o: $(src)/vdso.lds $(obj)/rt_sigreturn.o FORCE
 	$(call if_changed,vdsold)
 
diff --git a/arch/s390/kernel/vdso64/Makefile b/arch/s390/kernel/vdso64/Makefile
index 4a66a1cb919b..edc473b32e42 100644
--- a/arch/s390/kernel/vdso64/Makefile
+++ b/arch/s390/kernel/vdso64/Makefile
@@ -19,7 +19,7 @@ KBUILD_AFLAGS_64 += -m64 -s
 KBUILD_CFLAGS_64 := $(filter-out -m64,$(KBUILD_CFLAGS))
 KBUILD_CFLAGS_64 += -m64 -fPIC -shared -fno-common -fno-builtin
 ldflags-y := -fPIC -shared -nostdlib -soname=linux-vdso64.so.1 \
-	     --hash-style=both --build-id -T
+	     --hash-style=both --build-id=sha1 -T
 
 $(targets:%=$(obj)/%.dbg): KBUILD_CFLAGS = $(KBUILD_CFLAGS_64)
 $(targets:%=$(obj)/%.dbg): KBUILD_AFLAGS = $(KBUILD_AFLAGS_64)
diff --git a/arch/sparc/vdso/Makefile b/arch/sparc/vdso/Makefile
index f44355e46f31..469dd23887ab 100644
--- a/arch/sparc/vdso/Makefile
+++ b/arch/sparc/vdso/Makefile
@@ -115,7 +115,7 @@ quiet_cmd_vdso = VDSO    $@
 		       -T $(filter %.lds,$^) $(filter %.o,$^) && \
 		sh $(srctree)/$(src)/checkundef.sh '$(OBJDUMP)' '$@'
 
-VDSO_LDFLAGS = -shared --hash-style=both --build-id -Bsymbolic
+VDSO_LDFLAGS = -shared --hash-style=both --build-id=sha1 -Bsymbolic
 GCOV_PROFILE := n
 
 #
diff --git a/arch/x86/entry/vdso/Makefile b/arch/x86/entry/vdso/Makefile
index 215376d975a2..ebba25ed9a38 100644
--- a/arch/x86/entry/vdso/Makefile
+++ b/arch/x86/entry/vdso/Makefile
@@ -176,7 +176,7 @@ quiet_cmd_vdso = VDSO    $@
 		       -T $(filter %.lds,$^) $(filter %.o,$^) && \
 		 sh $(srctree)/$(src)/checkundef.sh '$(NM)' '$@'
 
-VDSO_LDFLAGS = -shared --hash-style=both --build-id \
+VDSO_LDFLAGS = -shared --hash-style=both --build-id=sha1 \
 	$(call ld-option, --eh-frame-hdr) -Bsymbolic
 GCOV_PROFILE := n
 
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index fc946b7ac288..daf186f88a63 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -133,7 +133,7 @@ $(OUTPUT)/%:%.c
 
 $(OUTPUT)/urandom_read: urandom_read.c
 	$(call msg,BINARY,,$@)
-	$(Q)$(CC) $(LDFLAGS) -o $@ $< $(LDLIBS) -Wl,--build-id
+	$(Q)$(CC) $(LDFLAGS) -o $@ $< $(LDLIBS) -Wl,--build-id=sha1
 
 $(OUTPUT)/test_stub.o: test_stub.c $(BPFOBJ)
 	$(call msg,CC,,$@)
-- 
2.28.0.681.g6f77f65b4e-goog

