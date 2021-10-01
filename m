Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 502D141EB8A
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 13:13:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353776AbhJALPY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 07:15:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353768AbhJALLM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 07:11:12 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6C67C06177D
        for <netdev@vger.kernel.org>; Fri,  1 Oct 2021 04:09:28 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id j27so6965218wms.0
        for <netdev@vger.kernel.org>; Fri, 01 Oct 2021 04:09:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6G1NPylBOR/ww+hDOMCQFvHQVyGOy8KdOupILpftMKg=;
        b=DEpjLD8XUOVkq9OK+4GC61MdrFpn7OzEXqvo0rSNYUMbqGFks9O2vLo4IrePelQ+5s
         AaYgJ3TQXpeDY9V7ZLO4z9dEApBLZVmw6T8t4N+mDSn9DZfxTBr11N6GNfxGdC9CcMvz
         8+pC1e5jqMvVi2q08mtmhYkmkOWUTo3yKNHgT9YudQ85e9RZMFZNyYQj+pIJc/NjcWzE
         tRP7mDRm9MNEZEA6twNzDsEWzCmV2B4ceDGfnJ68/vAfUggAyOI+JIZflGn8X52UeMPJ
         /tKZOXQ/u9xcsYizRYKx7WBolDCSwf+1Zyi8T2NnZocspFwgfMaJUJURVBXTJUvpMihJ
         XnUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6G1NPylBOR/ww+hDOMCQFvHQVyGOy8KdOupILpftMKg=;
        b=UFB+tDDFlpdjAjCaZUZFIdlPHQEH/yflbrjx+SX3KiHqVeJcvciGX6ixprUbOSSMIX
         D3Defic7QjzMiikIIaRZawS6sHjTVrF9Xer6swD11MdIDTdY5E5zI4p0U9s4UVB6pYde
         dOxn7RXjg4GJ+6/KBZbQZWb7vrkgjAAKzSvFZ9/Jd896zPsKk2/OyA7WftJ/VyHgpyCC
         N7Chu0YvBg/TAjjAU8FTIUQ3jacDyFrD+GHYcc2RNWTjD0XDRcVkXclpUF1UTpOkQ02K
         AiwKrpR+TL7kdwAChqbt3C6MukKPLCYTxulU4o0E2Bu93AGXL0DD6udh7vyRNVY4zZhn
         7zxA==
X-Gm-Message-State: AOAM531PNaoDZcPagT+DH8Tb5HuPIzoQk/EIQYlJQdg8dD0xd6VecQ/t
        QiMXsariFA6W5nvOgeAFjhdDBw==
X-Google-Smtp-Source: ABdhPJyBe17Rr9mVAgncxgW1l+mOcpibCxFd+/NrPBnIB1Gtpu4Yn9dncsFE7EPhmRD/Gj5rYMbQhA==
X-Received: by 2002:a05:600c:2d45:: with SMTP id a5mr3803713wmg.39.1633086567345;
        Fri, 01 Oct 2021 04:09:27 -0700 (PDT)
Received: from localhost.localdomain ([149.86.91.69])
        by smtp.gmail.com with ESMTPSA id v17sm5903271wro.34.2021.10.01.04.09.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 04:09:27 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next v2 6/9] bpf: iterators: install libbpf headers when building
Date:   Fri,  1 Oct 2021 12:08:53 +0100
Message-Id: <20211001110856.14730-7-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211001110856.14730-1-quentin@isovalent.com>
References: <20211001110856.14730-1-quentin@isovalent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

API headers from libbpf should not be accessed directly from the
library's source directory. Instead, they should be exported with "make
install_headers". Let's make sure that bpf/preload/iterators/Makefile
installs the headers properly when building.

Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 kernel/bpf/preload/iterators/Makefile | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/kernel/bpf/preload/iterators/Makefile b/kernel/bpf/preload/iterators/Makefile
index 28fa8c1440f4..cf549dab3e20 100644
--- a/kernel/bpf/preload/iterators/Makefile
+++ b/kernel/bpf/preload/iterators/Makefile
@@ -6,9 +6,11 @@ LLVM_STRIP ?= llvm-strip
 DEFAULT_BPFTOOL := $(OUTPUT)/sbin/bpftool
 BPFTOOL ?= $(DEFAULT_BPFTOOL)
 LIBBPF_SRC := $(abspath ../../../../tools/lib/bpf)
-BPFOBJ := $(OUTPUT)/libbpf.a
-BPF_INCLUDE := $(OUTPUT)
-INCLUDES := -I$(OUTPUT) -I$(BPF_INCLUDE) -I$(abspath ../../../../tools/lib)        \
+LIBBPF_OUTPUT := $(abspath $(OUTPUT))/libbpf
+LIBBPF_DESTDIR := $(LIBBPF_OUTPUT)
+LIBBPF_INCLUDE := $(LIBBPF_DESTDIR)/include
+BPFOBJ := $(LIBBPF_OUTPUT)/libbpf.a
+INCLUDES := -I$(OUTPUT) -I$(LIBBPF_INCLUDE)				       \
        -I$(abspath ../../../../tools/include/uapi)
 CFLAGS := -g -Wall
 
@@ -44,13 +46,15 @@ $(OUTPUT)/iterators.bpf.o: iterators.bpf.c $(BPFOBJ) | $(OUTPUT)
 		 -c $(filter %.c,$^) -o $@ &&				      \
 	$(LLVM_STRIP) -g $@
 
-$(OUTPUT):
+$(OUTPUT) $(LIBBPF_OUTPUT) $(LIBBPF_INCLUDE):
 	$(call msg,MKDIR,$@)
-	$(Q)mkdir -p $(OUTPUT)
+	$(Q)mkdir -p $@
 
-$(BPFOBJ): $(wildcard $(LIBBPF_SRC)/*.[ch] $(LIBBPF_SRC)/Makefile) | $(OUTPUT)
+$(BPFOBJ): $(wildcard $(LIBBPF_SRC)/*.[ch] $(LIBBPF_SRC)/Makefile)	       \
+	   | $(LIBBPF_OUTPUT) $(LIBBPF_INCLUDE)
 	$(Q)$(MAKE) $(submake_extras) -C $(LIBBPF_SRC)			       \
-		    OUTPUT=$(abspath $(dir $@))/ $(abspath $@)
+		    OUTPUT=$(abspath $(dir $@))/ prefix=		       \
+		    DESTDIR=$(LIBBPF_DESTDIR) $(abspath $@) install_headers
 
 $(DEFAULT_BPFTOOL):
 	$(Q)$(MAKE) $(submake_extras) -C ../../../../tools/bpf/bpftool			      \
-- 
2.30.2

