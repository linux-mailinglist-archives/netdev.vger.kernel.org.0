Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBC2A2F1D7E
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 19:07:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390124AbhAKSHc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 13:07:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390106AbhAKSHb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 13:07:31 -0500
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AC36C0617AB;
        Mon, 11 Jan 2021 10:06:32 -0800 (PST)
Received: by mail-qk1-x734.google.com with SMTP id w79so326123qkb.5;
        Mon, 11 Jan 2021 10:06:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9lp28zoWOKLPGFRTu8+kIhpE6rBiQRtmpdJvXYx3+tY=;
        b=ez1SefshWrFxr/3XbQrkWZhJIOzAqVAKha8CL5HWT4x+mLivWRS4dkFUm7HwH2jRFj
         35RyeXAQJ1GHXy0yh6vjr2sd1FmADkpsLwXV73Eqx0FTfyI91aVGSqsGWrpB9hd9Z3Mg
         5ezoFNrH++EteGshvlRBQEMzZx+t77f48oPDqewSK7fGTUaO1+wWYAP1lq2kt+bn1Lo7
         yPIll/9SFKumsFKeGZqH0lHOfeaAkKP6HS5T6doHT5QxygwFwC7rcCi24LCEs+p+bCWm
         ZwBI0MYIGO+4Ti1un1JlgNvYPrrv0JSyPZwmh/nGNhlvBRp/HWBHY90zCUJJ8OpSDcep
         tUnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9lp28zoWOKLPGFRTu8+kIhpE6rBiQRtmpdJvXYx3+tY=;
        b=nyycVbVBFCA5cHX1K+1kZnz0C8sNAy+zEDr/+r0gwk4Z4bb3CNbRUaOCeNnALPFjDN
         sL3Gldu4LguphJk61D25g4VCuGhKrUpPqWA/WW0qvn5ro7WKC2a81GQZsavlHGmE3ZaC
         kv/kHjtCuOjODWrZJL0xoEWJd8VbG82kR/tFTna7G0kd9EQkuoFBKWBDi0O2bX7nGbpA
         Z+e/VYX0bxoFbWUsO5bAAmKUWGbiXT79Orld+rHngvys+hUI+b+kCW0ON2tq2KsrmEeD
         EhqDrqpNypsg810lbjNw+KpkF1ryDENlFGxlriMfvviJKaQ/EvrjHK2Z5l7a+GObNENH
         1leQ==
X-Gm-Message-State: AOAM5332ukz/6db0jEN5Tx7GdduoONZatvOQX3DnvZVmh/aykDipLygz
        21Feg/00s6A3mBmyrbK7tB+p4Yg9vI2Cgg==
X-Google-Smtp-Source: ABdhPJwx8k0tYOOZKUoXq0vInH3wbViiSZCtXbNbqNuIHyl1UktVYK4JCeL9x3IbIOGZ87AlhyDxtg==
X-Received: by 2002:a37:b94:: with SMTP id 142mr536071qkl.318.1610388391183;
        Mon, 11 Jan 2021 10:06:31 -0800 (PST)
Received: from localhost.localdomain ([2604:1380:45f1:1d00::1])
        by smtp.gmail.com with ESMTPSA id g28sm158752qtm.91.2021.01.11.10.06.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 10:06:30 -0800 (PST)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Nathan Chancellor <natechancellor@gmail.com>,
        Sedat Dilek <sedat.dilek@gmail.com>
Subject: [PATCH] bpf: Hoise pahole version checks into Kconfig
Date:   Mon, 11 Jan 2021 11:06:09 -0700
Message-Id: <20210111180609.713998-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After commit da5fb18225b4 ("bpf: Support pre-2.25-binutils objcopy for
vmlinux BTF"), having CONFIG_DEBUG_INFO_BTF enabled but lacking a valid
copy of pahole results in a kernel that will fully compile but fail to
link. The user then has to either install pahole or disable
CONFIG_DEBUG_INFO_BTF and rebuild the kernel but only after their build
has failed, which could have been a significant amount of time depending
on the hardware.

Avoid a poor user experience and require pahole to be installed with an
appropriate version to select and use CONFIG_DEBUG_INFO_BTF, which is
standard for options that require a specific tools version.

Suggested-by: Sedat Dilek <sedat.dilek@gmail.com>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 MAINTAINERS               |  1 +
 init/Kconfig              |  4 ++++
 lib/Kconfig.debug         |  6 ++----
 scripts/link-vmlinux.sh   | 13 -------------
 scripts/pahole-version.sh | 16 ++++++++++++++++
 5 files changed, 23 insertions(+), 17 deletions(-)
 create mode 100755 scripts/pahole-version.sh

diff --git a/MAINTAINERS b/MAINTAINERS
index b8db7637263a..6f6e24285a94 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3282,6 +3282,7 @@ F:	net/core/filter.c
 F:	net/sched/act_bpf.c
 F:	net/sched/cls_bpf.c
 F:	samples/bpf/
+F:	scripts/pahole-version.sh
 F:	tools/bpf/
 F:	tools/lib/bpf/
 F:	tools/testing/selftests/bpf/
diff --git a/init/Kconfig b/init/Kconfig
index b77c60f8b963..872c61b5d204 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -74,6 +74,10 @@ config TOOLS_SUPPORT_RELR
 config CC_HAS_ASM_INLINE
 	def_bool $(success,echo 'void foo(void) { asm inline (""); }' | $(CC) -x c - -c -o /dev/null)
 
+config PAHOLE_VERSION
+	int
+	default $(shell,$(srctree)/scripts/pahole-version.sh $(PAHOLE))
+
 config CONSTRUCTORS
 	bool
 	depends on !UML
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 7937265ef879..70c446af9664 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -267,6 +267,7 @@ config DEBUG_INFO_DWARF4
 
 config DEBUG_INFO_BTF
 	bool "Generate BTF typeinfo"
+	depends on PAHOLE_VERSION >= 116
 	depends on !DEBUG_INFO_SPLIT && !DEBUG_INFO_REDUCED
 	depends on !GCC_PLUGIN_RANDSTRUCT || COMPILE_TEST
 	help
@@ -274,12 +275,9 @@ config DEBUG_INFO_BTF
 	  Turning this on expects presence of pahole tool, which will convert
 	  DWARF type info into equivalent deduplicated BTF type info.
 
-config PAHOLE_HAS_SPLIT_BTF
-	def_bool $(success, test `$(PAHOLE) --version | sed -E 's/v([0-9]+)\.([0-9]+)/\1\2/'` -ge "119")
-
 config DEBUG_INFO_BTF_MODULES
 	def_bool y
-	depends on DEBUG_INFO_BTF && MODULES && PAHOLE_HAS_SPLIT_BTF
+	depends on DEBUG_INFO_BTF && MODULES && PAHOLE_VERSION >= 119
 	help
 	  Generate compact split BTF type information for kernel modules.
 
diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index 6eded325c837..eef40fa9485d 100755
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -139,19 +139,6 @@ vmlinux_link()
 # ${2} - file to dump raw BTF data into
 gen_btf()
 {
-	local pahole_ver
-
-	if ! [ -x "$(command -v ${PAHOLE})" ]; then
-		echo >&2 "BTF: ${1}: pahole (${PAHOLE}) is not available"
-		return 1
-	fi
-
-	pahole_ver=$(${PAHOLE} --version | sed -E 's/v([0-9]+)\.([0-9]+)/\1\2/')
-	if [ "${pahole_ver}" -lt "116" ]; then
-		echo >&2 "BTF: ${1}: pahole version $(${PAHOLE} --version) is too old, need at least v1.16"
-		return 1
-	fi
-
 	vmlinux_link ${1}
 
 	info "BTF" ${2}
diff --git a/scripts/pahole-version.sh b/scripts/pahole-version.sh
new file mode 100755
index 000000000000..6de6f734a345
--- /dev/null
+++ b/scripts/pahole-version.sh
@@ -0,0 +1,16 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+#
+# Usage: $ ./scripts/pahole-version.sh pahole
+#
+# Print the pahole version as a three digit string
+# such as `119' for pahole v1.19 etc.
+
+pahole="$*"
+
+if ! [ -x "$(command -v $pahole)" ]; then
+    echo 0
+    exit 1
+fi
+
+$pahole --version | sed -E 's/v([0-9]+)\.([0-9]+)/\1\2/'

base-commit: e22d7f05e445165e58feddb4e40cc9c0f94453bc
-- 
2.30.0

