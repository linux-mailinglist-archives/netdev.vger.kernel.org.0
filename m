Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FBDD43839D
	for <lists+netdev@lfdr.de>; Sat, 23 Oct 2021 14:05:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbhJWMHX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Oct 2021 08:07:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20252 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230301AbhJWMHW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Oct 2021 08:07:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634990703;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7pkPbCBCtSDOxDhWztoOnPzXTRu2FzqqR8ZIAj4OW+A=;
        b=O5DAtshcu6CkDlTSlYbp9ATNMN+xLFQH1mV9qHDZn+Ji/EaHfMMlCrHV/0Ma/HLt3Kt1ML
        deoNrPTGErCky4LxAj/j0hM+GN3BR2pp/mOmFBHAqjWSpEwlcJFFxyUjYt1n2DvVMO5ETQ
        0eAKGbr6PxD8/2puAXTtr7HybGGXnqY=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-152-2vCwnMSnOTC8RoC2Fd1DLQ-1; Sat, 23 Oct 2021 08:05:02 -0400
X-MC-Unique: 2vCwnMSnOTC8RoC2Fd1DLQ-1
Received: by mail-ed1-f70.google.com with SMTP id t18-20020a056402021200b003db9e6b0e57so6011551edv.10
        for <netdev@vger.kernel.org>; Sat, 23 Oct 2021 05:05:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7pkPbCBCtSDOxDhWztoOnPzXTRu2FzqqR8ZIAj4OW+A=;
        b=Gsbj6pPdf6NE/ywYchREbxwxJi2/Fd4xnmqvbhQvLuPDlbsFshTY7pvvhQamdOolJe
         7Tc4OeQlwgjLJnNG2ewcf2EyM8xXMi6KnWgToi71PqB/4PVMCnNWMuhGiqbhqsZdY2id
         exR2CPVQOZmWZl2m4ITjkelwyTMCnUDXQJOFHum/t6DfOJoBXss5VjlVRuQG9rsYduOk
         OMIRMnGD4Z1LOZuj0DPKQgw0gIwr5mWMqK1xkb6CrnEOnvd4eaTwQSkquZ1g1+7UFPL/
         5OPYk84Ihsz1o5X8Gc2GdU9oIJ8QqSFTeinlB2QIqQOKvk/gOeHccPAxSDHNbPDNOYxF
         WoPQ==
X-Gm-Message-State: AOAM5322cAUyeSwBNPC3UrhNANBhAT53DFZdsz15QXj8FMkMWB57Qpdc
        GT63NhXWoT186Xn5ckGFJ8jnBzkbOcBYwa7ilowdNk3Q2YygZwr8ve2SHLou59pQgbESO4JTP50
        DNs20uOcEAewf38Vs
X-Received: by 2002:a17:907:1112:: with SMTP id qu18mr1800236ejb.339.1634990700828;
        Sat, 23 Oct 2021 05:05:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzvZ/M4oO21mYOXJRaVLwZFvkyuM4bGGgYZ2+6RlWno479PHCZEcEWHuyzfK8kx96B1aloUSw==
X-Received: by 2002:a17:907:1112:: with SMTP id qu18mr1800211ejb.339.1634990700622;
        Sat, 23 Oct 2021 05:05:00 -0700 (PDT)
Received: from krava.cust.in.nbox.cz ([83.240.63.48])
        by smtp.gmail.com with ESMTPSA id o25sm2132927ejc.22.2021.10.23.05.04.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Oct 2021 05:05:00 -0700 (PDT)
From:   Jiri Olsa <jolsa@redhat.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: [PATCH bpf-next 1/2] kbuild: Unify options for BTF generation for vmlinux and modules
Date:   Sat, 23 Oct 2021 14:04:51 +0200
Message-Id: <20211023120452.212885-2-jolsa@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211023120452.212885-1-jolsa@kernel.org>
References: <20211023120452.212885-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Using new PAHOLE_FLAGS variable to pass extra arguments to
pahole for both vmlinux and modules BTF data generation.

Adding new scripts/pahole-flags.sh script that detect and
prints pahole options.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 Makefile                  |  3 +++
 scripts/Makefile.modfinal |  2 +-
 scripts/link-vmlinux.sh   | 11 +----------
 scripts/pahole-flags.sh   | 20 ++++++++++++++++++++
 4 files changed, 25 insertions(+), 11 deletions(-)
 create mode 100755 scripts/pahole-flags.sh

diff --git a/Makefile b/Makefile
index 437ccc66a1c2..ee514b80c62e 100644
--- a/Makefile
+++ b/Makefile
@@ -480,6 +480,8 @@ LZ4		= lz4c
 XZ		= xz
 ZSTD		= zstd
 
+PAHOLE_FLAGS	= $(shell PAHOLE=$(PAHOLE) scripts/pahole-flags.sh)
+
 CHECKFLAGS     := -D__linux__ -Dlinux -D__STDC__ -Dunix -D__unix__ \
 		  -Wbitwise -Wno-return-void -Wno-unknown-attribute $(CF)
 NOSTDINC_FLAGS :=
@@ -534,6 +536,7 @@ export KBUILD_CFLAGS CFLAGS_KERNEL CFLAGS_MODULE
 export KBUILD_AFLAGS AFLAGS_KERNEL AFLAGS_MODULE
 export KBUILD_AFLAGS_MODULE KBUILD_CFLAGS_MODULE KBUILD_LDFLAGS_MODULE
 export KBUILD_AFLAGS_KERNEL KBUILD_CFLAGS_KERNEL
+export PAHOLE_FLAGS
 
 # Files to ignore in find ... statements
 
diff --git a/scripts/Makefile.modfinal b/scripts/Makefile.modfinal
index 1fb45b011e4b..7f39599e9fae 100644
--- a/scripts/Makefile.modfinal
+++ b/scripts/Makefile.modfinal
@@ -40,7 +40,7 @@ quiet_cmd_ld_ko_o = LD [M]  $@
 quiet_cmd_btf_ko = BTF [M] $@
       cmd_btf_ko = 							\
 	if [ -f vmlinux ]; then						\
-		LLVM_OBJCOPY="$(OBJCOPY)" $(PAHOLE) -J --btf_base vmlinux $@; \
+		LLVM_OBJCOPY="$(OBJCOPY)" $(PAHOLE) -J $(PAHOLE_FLAGS) --btf_base vmlinux $@; \
 		$(RESOLVE_BTFIDS) -b vmlinux $@; 			\
 	else								\
 		printf "Skipping BTF generation for %s due to unavailability of vmlinux\n" $@ 1>&2; \
diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index d74cee5c4326..3ea7cece7c97 100755
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -205,7 +205,6 @@ vmlinux_link()
 gen_btf()
 {
 	local pahole_ver
-	local extra_paholeopt=
 
 	if ! [ -x "$(command -v ${PAHOLE})" ]; then
 		echo >&2 "BTF: ${1}: pahole (${PAHOLE}) is not available"
@@ -220,16 +219,8 @@ gen_btf()
 
 	vmlinux_link ${1}
 
-	if [ "${pahole_ver}" -ge "118" ] && [ "${pahole_ver}" -le "121" ]; then
-		# pahole 1.18 through 1.21 can't handle zero-sized per-CPU vars
-		extra_paholeopt="${extra_paholeopt} --skip_encoding_btf_vars"
-	fi
-	if [ "${pahole_ver}" -ge "121" ]; then
-		extra_paholeopt="${extra_paholeopt} --btf_gen_floats"
-	fi
-
 	info "BTF" ${2}
-	LLVM_OBJCOPY="${OBJCOPY}" ${PAHOLE} -J ${extra_paholeopt} ${1}
+	LLVM_OBJCOPY="${OBJCOPY}" ${PAHOLE} -J ${PAHOLE_FLAGS} ${1}
 
 	# Create ${2} which contains just .BTF section but no symbols. Add
 	# SHF_ALLOC because .BTF will be part of the vmlinux image. --strip-all
diff --git a/scripts/pahole-flags.sh b/scripts/pahole-flags.sh
new file mode 100755
index 000000000000..2b99fc77019c
--- /dev/null
+++ b/scripts/pahole-flags.sh
@@ -0,0 +1,20 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+
+extra_paholeopt=
+
+if ! [ -x "$(command -v ${PAHOLE})" ]; then
+	return
+fi
+
+pahole_ver=$(${PAHOLE} --version | sed -E 's/v([0-9]+)\.([0-9]+)/\1\2/')
+
+if [ "${pahole_ver}" -ge "118" ] && [ "${pahole_ver}" -le "121" ]; then
+	# pahole 1.18 through 1.21 can't handle zero-sized per-CPU vars
+	extra_paholeopt="${extra_paholeopt} --skip_encoding_btf_vars"
+fi
+if [ "${pahole_ver}" -ge "121" ]; then
+	extra_paholeopt="${extra_paholeopt} --btf_gen_floats"
+fi
+
+echo ${extra_paholeopt}
-- 
2.31.1

