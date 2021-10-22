Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17F0B437BB2
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 19:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233846AbhJVRTL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 13:19:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233570AbhJVRTK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 13:19:10 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5F8EC061764
        for <netdev@vger.kernel.org>; Fri, 22 Oct 2021 10:16:52 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id b189-20020a1c1bc6000000b0030da052dd4fso3005901wmb.3
        for <netdev@vger.kernel.org>; Fri, 22 Oct 2021 10:16:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=N1WVOZzTNh/27joMu9FrakmExxycTJXl4iU2zUCXEpI=;
        b=ewhoK45sF3Zg4VE2snLTFUbIvZlZkFthahDTUev8K4bO4AZRy6glqFt16WQ8H2t6iU
         toBBnZ4tbUoex985/Weef0BsApHAPV4pFLdVC5bHm5ES1GlsMZ6cSvKXE3en4fx8HsxK
         M/sfPnWI0jYa2iMVZgXmwyUsi1mgr/+ZxNseOOT5HVD4VdJV1d6bF5Afg+4LPNK722pW
         AFL5M+ZIlsYS/n0//0ipYHgQy0+ExdVbRLfIfmMePD2jnaAuhSppn1X7mXfcgVFCTxJ/
         HY8gnE/GxNfKoHv3bfKsu12wAur7Jvh4u+GzW5Y3kfHeCFz0T2bJmysc+GxC5QQSL/sd
         QTPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=N1WVOZzTNh/27joMu9FrakmExxycTJXl4iU2zUCXEpI=;
        b=X3Qiq/XnxqPl834apJzD6KROvUiIQxn1DaFy0zk6ZAiCVuExMVdbkD6zs6DONSLTOn
         v5WpI2ebvy/ZWiTDXCmXpqHs4XbmDM1coWZQxYK76hqezw83N/qOYqTYvMkCWdqetijY
         O0TYSeX/Hn3deqas42JYk2YtyWJeHKV79smWBClKd7DgjLmvy15lYNW1cwo0SSj71M9b
         WNQo1oWSRhBCYPFwKZpBXKuy5vTHg875zfD+PDVXFfTQwlb0scFD3cb6wXLKx18seSwu
         Nv6t/Dn6i4emax3ZS/L4vo3xU1Rx5H+c6ucM1TsYcAzia7uDjSXNiaF8jyxL5vGVz0Ko
         rN7g==
X-Gm-Message-State: AOAM533s85RNODX0ilH49FWonnbGFOoQtAFYvBiaMqEpQaMcVpY9BYlM
        yrPZANboAyfn3b5SRAbbGPSYjQ==
X-Google-Smtp-Source: ABdhPJypWgfS1g7dG9bzMdrxLMYOyBPugTPd8XUYkR2tC4IvQEbl5dOo4gJQjOxNVKtEush0lLB/qQ==
X-Received: by 2002:a1c:ac03:: with SMTP id v3mr1043816wme.127.1634923011497;
        Fri, 22 Oct 2021 10:16:51 -0700 (PDT)
Received: from localhost.localdomain ([149.86.74.50])
        by smtp.gmail.com with ESMTPSA id 6sm4427367wma.48.2021.10.22.10.16.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Oct 2021 10:16:51 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next 1/5] bpftool: Remove Makefile dep. on $(LIBBPF) for $(LIBBPF_INTERNAL_HDRS)
Date:   Fri, 22 Oct 2021 18:16:43 +0100
Message-Id: <20211022171647.27885-2-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211022171647.27885-1-quentin@isovalent.com>
References: <20211022171647.27885-1-quentin@isovalent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The dependency is only useful to make sure that the $(LIBBPF_HDRS_DIR)
directory is created before we try to install locally the required
libbpf internal header. Let's create this directory properly instead.

This is in preparation of making $(LIBBPF_INTERNAL_HDRS) a dependency to
the bootstrap bpftool version, in which case we want no dependency on
$(LIBBPF).

Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 tools/bpf/bpftool/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
index 098d762e111a..939b0fca5fb9 100644
--- a/tools/bpf/bpftool/Makefile
+++ b/tools/bpf/bpftool/Makefile
@@ -39,14 +39,14 @@ ifeq ($(BPFTOOL_VERSION),)
 BPFTOOL_VERSION := $(shell make -rR --no-print-directory -sC ../../.. kernelversion)
 endif
 
-$(LIBBPF_OUTPUT) $(BOOTSTRAP_OUTPUT) $(LIBBPF_BOOTSTRAP_OUTPUT):
+$(LIBBPF_OUTPUT) $(BOOTSTRAP_OUTPUT) $(LIBBPF_BOOTSTRAP_OUTPUT) $(LIBBPF_HDRS_DIR):
 	$(QUIET_MKDIR)mkdir -p $@
 
 $(LIBBPF): $(wildcard $(BPF_DIR)/*.[ch] $(BPF_DIR)/Makefile) | $(LIBBPF_OUTPUT)
 	$(Q)$(MAKE) -C $(BPF_DIR) OUTPUT=$(LIBBPF_OUTPUT) \
 		DESTDIR=$(LIBBPF_DESTDIR) prefix= $(LIBBPF) install_headers
 
-$(LIBBPF_INTERNAL_HDRS): $(LIBBPF_HDRS_DIR)/%.h: $(BPF_DIR)/%.h $(LIBBPF)
+$(LIBBPF_INTERNAL_HDRS): $(LIBBPF_HDRS_DIR)/%.h: $(BPF_DIR)/%.h | $(LIBBPF_HDRS_DIR)
 	$(call QUIET_INSTALL, $@)
 	$(Q)install -m 644 -t $(LIBBPF_HDRS_DIR) $<
 
-- 
2.30.2

