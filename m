Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2AFD4203AA
	for <lists+netdev@lfdr.de>; Sun,  3 Oct 2021 21:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231681AbhJCTY0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Oct 2021 15:24:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231620AbhJCTYR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Oct 2021 15:24:17 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39650C061788
        for <netdev@vger.kernel.org>; Sun,  3 Oct 2021 12:22:26 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id r7so10869481wrc.10
        for <netdev@vger.kernel.org>; Sun, 03 Oct 2021 12:22:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vEX+HUR72ahF32WavI8A1JXem/G4/Ffc2RuIMJIPcLY=;
        b=hDyAkLX0Sl1tgYsPTIN5XiOT1eh63RkG478Hmm50kyHWFNeuLkQzOAGLmt1dVaY9cq
         IHrqkIFJQjaDCc8KtmipXYIg5x9BRVURHO/qO0QgO43sNY1q1fzOKyBhmm04ucE59Awb
         dPtG+cOvbkRbqOmWjVO6V5Qi3lg1gKZwqf1Wyb9zqnbFJdNK6pFwJDfqt+0cx2QK6A+s
         lkh44W/+jLOxTD/vfzXHeVuENmfOP+dCpI3dGDYE4tNp4Sn/Sq0YQL3k33OOo6LelOd1
         ZHYdFiPUCTn9qEDfHr6iIE0d+diGWrAun9gtVsNihU+g+tCfkbeSG4HFuXAWtgv7uyKd
         sxqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vEX+HUR72ahF32WavI8A1JXem/G4/Ffc2RuIMJIPcLY=;
        b=tT6cyLW2ZVGQtmhQ/o7MjZdLjNRftlzZRRZMdtXhkGS1cOR6lNz5ndCkcK9uExVNuL
         78dAg2Y91SjCDt8815bD30f3CMqcTtfD3v1ZLO0H1pcBVZUyz36P/2se036NHbQGGthW
         zDvPrt7oN1CKeAl/U3w+rgGM4xrfiwhdhvIcjb9CGqymv4NrtcRPO+oGQDSK5eIWbAfq
         IbAHN5cRK5OeDwyHAzabNyjal5VXoVawYRI4345Rd6OSwLdTryGtSW+4xiEXzY5FufPJ
         XhQ+83cpVwOraYpRJFFyJtT656ofzr5iOTR0PhMWMzqGB4TzkmiJcOXKw4XUg+QJ6QQq
         8KEA==
X-Gm-Message-State: AOAM533D+qNA2Sx6Rt20wMtpWNY427mSimWBH0XamJp2wVOZmFxMMp0H
        YeDlyBVkiuG8OKng6rxVyWt/Lw==
X-Google-Smtp-Source: ABdhPJz17Olw6AQuf7WMrMuQQ49/fd3yr76Lg7377laLO+A2sTDBxFCYUb3kca4nEav1PatsPP+YPA==
X-Received: by 2002:adf:a2d8:: with SMTP id t24mr9907628wra.30.1633288944818;
        Sun, 03 Oct 2021 12:22:24 -0700 (PDT)
Received: from localhost.localdomain ([149.86.88.77])
        by smtp.gmail.com with ESMTPSA id d3sm14124642wrb.36.2021.10.03.12.22.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Oct 2021 12:22:24 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next v3 06/10] bpf: iterators: install libbpf headers when building
Date:   Sun,  3 Oct 2021 20:22:04 +0100
Message-Id: <20211003192208.6297-7-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211003192208.6297-1-quentin@isovalent.com>
References: <20211003192208.6297-1-quentin@isovalent.com>
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
 kernel/bpf/preload/iterators/Makefile | 39 ++++++++++++++++++---------
 1 file changed, 26 insertions(+), 13 deletions(-)

diff --git a/kernel/bpf/preload/iterators/Makefile b/kernel/bpf/preload/iterators/Makefile
index 28fa8c1440f4..ec39ccc71b8e 100644
--- a/kernel/bpf/preload/iterators/Makefile
+++ b/kernel/bpf/preload/iterators/Makefile
@@ -1,18 +1,26 @@
 # SPDX-License-Identifier: GPL-2.0
 OUTPUT := .output
+abs_out := $(abspath $(OUTPUT))
+
 CLANG ?= clang
 LLC ?= llc
 LLVM_STRIP ?= llvm-strip
+
+TOOLS_PATH := $(abspath ../../../../tools)
+BPFTOOL_SRC := $(TOOLS_PATH)/bpf/bpftool
+BPFTOOL_OUTPUT := $(abs_out)/bpftool
 DEFAULT_BPFTOOL := $(OUTPUT)/sbin/bpftool
 BPFTOOL ?= $(DEFAULT_BPFTOOL)
-LIBBPF_SRC := $(abspath ../../../../tools/lib/bpf)
-BPFOBJ := $(OUTPUT)/libbpf.a
-BPF_INCLUDE := $(OUTPUT)
-INCLUDES := -I$(OUTPUT) -I$(BPF_INCLUDE) -I$(abspath ../../../../tools/lib)        \
-       -I$(abspath ../../../../tools/include/uapi)
+
+LIBBPF_SRC := $(TOOLS_PATH)/lib/bpf
+LIBBPF_OUTPUT := $(abs_out)/libbpf
+LIBBPF_DESTDIR := $(LIBBPF_OUTPUT)
+LIBBPF_INCLUDE := $(LIBBPF_DESTDIR)/include
+BPFOBJ := $(LIBBPF_OUTPUT)/libbpf.a
+
+INCLUDES := -I$(OUTPUT) -I$(LIBBPF_INCLUDE) -I$(TOOLS_PATH)/include/uapi
 CFLAGS := -g -Wall
 
-abs_out := $(abspath $(OUTPUT))
 ifeq ($(V),1)
 Q =
 msg =
@@ -44,14 +52,19 @@ $(OUTPUT)/iterators.bpf.o: iterators.bpf.c $(BPFOBJ) | $(OUTPUT)
 		 -c $(filter %.c,$^) -o $@ &&				      \
 	$(LLVM_STRIP) -g $@
 
-$(OUTPUT):
+$(OUTPUT) $(LIBBPF_OUTPUT) $(BPFTOOL_OUTPUT):
 	$(call msg,MKDIR,$@)
-	$(Q)mkdir -p $(OUTPUT)
+	$(Q)mkdir -p $@
 
-$(BPFOBJ): $(wildcard $(LIBBPF_SRC)/*.[ch] $(LIBBPF_SRC)/Makefile) | $(OUTPUT)
+$(BPFOBJ): $(wildcard $(LIBBPF_SRC)/*.[ch] $(LIBBPF_SRC)/Makefile)	       \
+	   | $(LIBBPF_OUTPUT)
 	$(Q)$(MAKE) $(submake_extras) -C $(LIBBPF_SRC)			       \
-		    OUTPUT=$(abspath $(dir $@))/ $(abspath $@)
+		    OUTPUT=$(abspath $(dir $@))/ prefix=		       \
+		    DESTDIR=$(LIBBPF_DESTDIR) $(abspath $@) install_headers
 
-$(DEFAULT_BPFTOOL):
-	$(Q)$(MAKE) $(submake_extras) -C ../../../../tools/bpf/bpftool			      \
-		    prefix= OUTPUT=$(abs_out)/ DESTDIR=$(abs_out) install
+$(DEFAULT_BPFTOOL): $(BPFOBJ) | $(BPFTOOL_OUTPUT)
+	$(Q)$(MAKE) $(submake_extras) -C $(BPFTOOL_SRC)			       \
+		    OUTPUT=$(BPFTOOL_OUTPUT)/				       \
+		    LIBBPF_OUTPUT=$(LIBBPF_OUTPUT)/			       \
+		    LIBBPF_DESTDIR=$(LIBBPF_DESTDIR)/			       \
+		    prefix= DESTDIR=$(abs_out)/ install
-- 
2.30.2

