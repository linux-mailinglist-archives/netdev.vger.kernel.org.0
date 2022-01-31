Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A78494A512A
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 22:11:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237297AbiAaVL5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 16:11:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236230AbiAaVL4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 16:11:56 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 622BCC06173B
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 13:11:56 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id n10so29420776edv.2
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 13:11:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5aN4eDoviOe13XOtMTnGt5vN/B9ENLBxYuv0yoKH2XE=;
        b=dJOK8MRvUSE4LwLroPk1jED9OxnZ8Anseuj5VQCco3DGQQZw9iEDZ6w1uKCbsc4x7/
         naSUXLy2tYrX7a0Jpel5OULIQFaU9+tx34KOvkIo2h793K15i+bAGyX6N+IuiM9HuiCo
         wXZubzIVlffuSX/HsOyB2nOtSODxfR/4iS+Uq6lIvkqBG0LZetPG/DQo+Dl6to0elSXB
         5YtFd8DuvAX3XJZXfwjiJiKVFj8j+vCrhDz0WJBw085939lsWqLV4ZNQtgeIz6XrWBLL
         cwaR/XrRK+CnE3svrtb6SwjDcLm1CTPrLhPxwvrnRDf3VaO/ipsVQnh4YXYlPB51o57F
         cj5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5aN4eDoviOe13XOtMTnGt5vN/B9ENLBxYuv0yoKH2XE=;
        b=k3n6yYRRnEL5r8TPMC48gEUTEDFQMQ67Y7PEsSQvn7Emt53XxSOoSaxrK7KaS+qJK1
         LQJGD4YIZCRNCN155y0ahYT7I/w2Ak3QiJ9t9zi3M9JYdTdkK7DyAreBNawuci/QX7h3
         raQpv4/lEuGMdHy07cCD8KUKw6KXN9iSoeHbfXfktBIOEHTrByXvJ0OqkoDOHfKC3/B+
         5MfVLLkF0AMzGlDedj52PtM29/AavWSCjGq2Ol1Jc1c597lPfUiC+g3JRDFfYeQxdLv2
         Ie3BznfbEiLBf0txu8Zb/jFsrYD2jlGSpS8895IhRP2zeGdNPjivIo0vdqy00rQ95W8q
         PQpA==
X-Gm-Message-State: AOAM5317A6Cg2ejZIoM/phSS5pI56c2CGcvnzLKx8cmSV47HTZbVMGx/
        Mhk/SkCgIpRUDq1ZbrRkQraEAA==
X-Google-Smtp-Source: ABdhPJyc6AAagL3gXDaykhgbhIOuJKxdosm0X4VNtxS/FaoHnF8MUva2kuMD5zkc+Qlp3WjgrkS6Cg==
X-Received: by 2002:a05:6402:2806:: with SMTP id h6mr22091955ede.223.1643663514997;
        Mon, 31 Jan 2022 13:11:54 -0800 (PST)
Received: from localhost.localdomain ([149.86.79.138])
        by smtp.gmail.com with ESMTPSA id v5sm13763947ejc.40.2022.01.31.13.11.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jan 2022 13:11:54 -0800 (PST)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next 2/3] bpftool: Add libbpf's version number to "bpftool version" output
Date:   Mon, 31 Jan 2022 21:11:35 +0000
Message-Id: <20220131211136.71010-3-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220131211136.71010-1-quentin@isovalent.com>
References: <20220131211136.71010-1-quentin@isovalent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To help users check what version of libbpf has been used to compile
bpftool, embed the version number and print it along with bpftool's own
version number.

Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 tools/bpf/bpftool/Documentation/common_options.rst | 3 ++-
 tools/bpf/bpftool/Makefile                         | 2 ++
 tools/bpf/bpftool/main.c                           | 3 +++
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/Documentation/common_options.rst b/tools/bpf/bpftool/Documentation/common_options.rst
index 908487b9c2ad..24166733d3ae 100644
--- a/tools/bpf/bpftool/Documentation/common_options.rst
+++ b/tools/bpf/bpftool/Documentation/common_options.rst
@@ -4,7 +4,8 @@
 	  Print short help message (similar to **bpftool help**).
 
 -V, --version
-	  Print version number (similar to **bpftool version**), and optional
+	  Print bpftool's version number (similar to **bpftool version**), the
+	  version of libbpf that was used to compile the binary, and optional
 	  features that were included when bpftool was compiled. Optional
 	  features include linking against libbfd to provide the disassembler
 	  for JIT-ted programs (**bpftool prog dump jited**) and usage of BPF
diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
index 83369f55df61..bd5a8cafac49 100644
--- a/tools/bpf/bpftool/Makefile
+++ b/tools/bpf/bpftool/Makefile
@@ -42,6 +42,7 @@ LIBBPF_BOOTSTRAP_INTERNAL_HDRS := $(addprefix $(LIBBPF_BOOTSTRAP_HDRS_DIR)/,hash
 ifeq ($(BPFTOOL_VERSION),)
 BPFTOOL_VERSION := $(shell make -rR --no-print-directory -sC ../../.. kernelversion)
 endif
+LIBBPF_VERSION := $(shell make -r --no-print-directory -sC $(BPF_DIR) libbpfversion)
 
 $(LIBBPF_OUTPUT) $(BOOTSTRAP_OUTPUT) $(LIBBPF_BOOTSTRAP_OUTPUT) $(LIBBPF_HDRS_DIR) $(LIBBPF_BOOTSTRAP_HDRS_DIR):
 	$(QUIET_MKDIR)mkdir -p $@
@@ -84,6 +85,7 @@ CFLAGS += -DPACKAGE='"bpftool"' -D__EXPORTED_HEADERS__ \
 	-I$(srctree)/tools/include \
 	-I$(srctree)/tools/include/uapi
 CFLAGS += -DBPFTOOL_VERSION='"$(BPFTOOL_VERSION)"'
+CFLAGS += -DLIBBPF_VERSION='"$(LIBBPF_VERSION)"'
 ifneq ($(EXTRA_CFLAGS),)
 CFLAGS += $(EXTRA_CFLAGS)
 endif
diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
index 9d01fa9de033..4bda73057980 100644
--- a/tools/bpf/bpftool/main.c
+++ b/tools/bpf/bpftool/main.c
@@ -89,6 +89,8 @@ static int do_version(int argc, char **argv)
 
 		jsonw_name(json_wtr, "version");
 		jsonw_printf(json_wtr, "\"%s\"", BPFTOOL_VERSION);
+		jsonw_name(json_wtr, "libbpf_version");
+		jsonw_printf(json_wtr, "\"%s\"", LIBBPF_VERSION);
 
 		jsonw_name(json_wtr, "features");
 		jsonw_start_object(json_wtr);	/* features */
@@ -102,6 +104,7 @@ static int do_version(int argc, char **argv)
 		unsigned int nb_features = 0;
 
 		printf("%s v%s\n", bin_name, BPFTOOL_VERSION);
+		printf("using libbpf v%s\n", LIBBPF_VERSION);
 		printf("features:");
 		if (has_libbfd) {
 			printf(" libbfd");
-- 
2.32.0

