Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B7AC423C29
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 13:11:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238279AbhJFLM5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 07:12:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238235AbhJFLMv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 07:12:51 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D79AC06174E
        for <netdev@vger.kernel.org>; Wed,  6 Oct 2021 04:10:59 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id o20so7662916wro.3
        for <netdev@vger.kernel.org>; Wed, 06 Oct 2021 04:10:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wttACgoV6tKMmUEtTZZMd4uFXTrlO8fg19Huw+or6ig=;
        b=Sof8vhnouR7xcYsxHROh/srneffUEmIxopqrz0+J7xgN79HZIoYmcMg0uVUOfI7vtg
         Onh4hHqi/kh0kY0nuL4MbIKeDwttjcSsd9BOffm1VrEDY1UhKhuHk40ZvCHkQcJVJ6fY
         HEYpPyOr4ai3W1xg7lZL+ZkvViNv+z184NOxE+HXg5GWrlDwcM9DS0JSmTpV4vc3+lAc
         GF1OpNjcrFv9fc3hmaRHYModk7uD6r3j+uQKPuKV2naUtZMcoK7QDyxxM0e0D36nNxtj
         4shEBF+HcsVjC93L0m/BHnwOzOG28kiJZLazHAySNdkBnZBkdyzNUfkhmk65KSblAgso
         BVlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wttACgoV6tKMmUEtTZZMd4uFXTrlO8fg19Huw+or6ig=;
        b=4i18XTt1BgcJChQS5M1roQsaMBWUOsL19WpV3ZgIlbLWMJwRclkjA1OJx7OikXxgzp
         qRSAZ5Jv6fkn496dpnemMAJOnVJucMYSZzEj5Ejgtvvlc+JFHPRQ0Q8MehCPJiiVxkrw
         u690+W//qdkuTD0CDSJHqkZRfFs+6RT+egYLJYAlN/uLHG3gHuvCA644OTagpYHC+VxC
         iZqBxo6Fna7ZrNS4YnxW9IMfPeVDhxQ5mwlMEEC3RI7J13+t5VdhEH4ekyyUx1gK0L+9
         YDoJrKsXgtnIFH6jgaTXfx/rVvNZ8odjVybF9EaMT+/T3050B/5jM4HucCW/HXVvmHE5
         EYww==
X-Gm-Message-State: AOAM533Lh6Jc/pRhqgGvbxDNwcLm0qJ/z70bMVECxkpdCCANHgMIgBJt
        T/u5VP76Eg8w3xLQRVbzdX4BXg==
X-Google-Smtp-Source: ABdhPJz/bfPghFxj5r8uomyrxmZvWqu4bM71KfrMa5bGbef4tSYn7ySE/GzzWp8v+WzNd2dVSHb/Bw==
X-Received: by 2002:a1c:f405:: with SMTP id z5mr9023790wma.33.1633518657584;
        Wed, 06 Oct 2021 04:10:57 -0700 (PDT)
Received: from localhost.localdomain ([149.86.93.16])
        by smtp.gmail.com with ESMTPSA id z19sm3342618wmf.39.2021.10.06.04.10.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 04:10:57 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next] bpf: use $(pound) instead of \# in Makefiles
Date:   Wed,  6 Oct 2021 12:10:49 +0100
Message-Id: <20211006111049.20708-1-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Recent-ish versions of make do no longer consider number signs ("#") as
comment symbols when they are inserted inside of a macro reference or in
a function invocation. In such cases, the symbols should not be escaped.

There are a few occurrences of "\#" in libbpf's and samples' Makefiles.
In the former, the backslash is harmless, because grep associates no
particular meaning to the escaped symbol and reads it as a regular "#".
In samples' Makefile, recent versions of make will pass the backslash
down to the compiler, making the probe fail all the time and resulting
in the display of a warning about "make headers_install" being required,
even after headers have been installed.

A similar issue has been addressed at some other locations by commit
9564a8cf422d ("Kbuild: fix # escaping in .cmd files for future Make").
Let's address it for libbpf's and samples' Makefiles in the same
fashion, by using a "$(pound)" variable (pulled from
tools/scripts/Makefile.include for libbpf, or re-defined for the
samples).

Reference for the change in make:
https://git.savannah.gnu.org/cgit/make.git/commit/?id=c6966b323811c37acedff05b57

Fixes: 2f3830412786 ("libbpf: Make libbpf_version.h non-auto-generated")
Fixes: 07c3bbdb1a9b ("samples: bpf: print a warning about headers_install")
Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 samples/bpf/Makefile   | 4 +++-
 tools/lib/bpf/Makefile | 4 ++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 4dc20be5fb96..a5783749ec15 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -3,6 +3,8 @@
 BPF_SAMPLES_PATH ?= $(abspath $(srctree)/$(src))
 TOOLS_PATH := $(BPF_SAMPLES_PATH)/../../tools
 
+pound := \#
+
 # List of programs to build
 tprogs-y := test_lru_dist
 tprogs-y += sock_example
@@ -232,7 +234,7 @@ endif
 
 # Don't evaluate probes and warnings if we need to run make recursively
 ifneq ($(src),)
-HDR_PROBE := $(shell printf "\#include <linux/types.h>\n struct list_head { int a; }; int main() { return 0; }" | \
+HDR_PROBE := $(shell printf "$(pound)include <linux/types.h>\n struct list_head { int a; }; int main() { return 0; }" | \
 	$(CC) $(TPROGS_CFLAGS) $(TPROGS_LDFLAGS) -x c - \
 	-o /dev/null 2>/dev/null && echo okay)
 
diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
index 0f766345506f..41e4f78dbad5 100644
--- a/tools/lib/bpf/Makefile
+++ b/tools/lib/bpf/Makefile
@@ -208,8 +208,8 @@ check_abi: $(OUTPUT)libbpf.so $(VERSION_SCRIPT)
 		exit 1;							 \
 	fi
 
-HDR_MAJ_VERSION := $(shell grep -oE '^\#define LIBBPF_MAJOR_VERSION ([0-9]+)$$' libbpf_version.h | cut -d' ' -f3)
-HDR_MIN_VERSION := $(shell grep -oE '^\#define LIBBPF_MINOR_VERSION ([0-9]+)$$' libbpf_version.h | cut -d' ' -f3)
+HDR_MAJ_VERSION := $(shell grep -oE '^$(pound)define LIBBPF_MAJOR_VERSION ([0-9]+)$$' libbpf_version.h | cut -d' ' -f3)
+HDR_MIN_VERSION := $(shell grep -oE '^$(pound)define LIBBPF_MINOR_VERSION ([0-9]+)$$' libbpf_version.h | cut -d' ' -f3)
 
 check_version: $(VERSION_SCRIPT) libbpf_version.h
 	@if [ "$(HDR_MAJ_VERSION)" != "$(LIBBPF_MAJOR_VERSION)" ]; then        \
-- 
2.30.2

