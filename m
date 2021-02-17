Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 819DF31D3A7
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 02:12:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231548AbhBQBL1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 20:11:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231424AbhBQBJa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 20:09:30 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A582C0617AA;
        Tue, 16 Feb 2021 17:08:58 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id b21so7435190pgk.7;
        Tue, 16 Feb 2021 17:08:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3coyZNplS0LrMWPP0wgM19MymToF1400w+CLXHenGHM=;
        b=jblR5dfpywIdXTajNjYPhJ5csCZ6narFit+XUpIiYKYUO+DLlfTKmxRsCDita4xcIB
         1mJ5VZiIx5cyG7bP+nvE7duPz9o5Pq5vqaz0ql1TDBk8koIjVPcYb6rqkxXdVrwqn38+
         t4SPQSkODJjAdjXLbIEbNYs95GRq2rFa6S5J+H+JzEy+LlfrfZMnLRUzRN5AU+eVhW66
         TXmVPkX6fMINzRf4SF20phDDPC8ty6lQGD78ZjrHRW7EQ8nAOk/kWHl2SEKosfN1g8Jt
         phAglXMw8tovVGdCuRXAjz1JObSOh1pfsaAdsaI7e9qDjuNm27rhjeg9tCMAykyzKfsz
         lZyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=3coyZNplS0LrMWPP0wgM19MymToF1400w+CLXHenGHM=;
        b=XVOqZ1rK6imLTKhedAu130AyaDKfDvPpEdQ/1l0gFSA5EU1B0DkuCGKycPJjuvV87G
         ZlhaA/b+VIZdZOlsS0nii8i57nvKOUcgHlFTho/vQ6o/uwqyxMglpsxCttierKjz/HA/
         +PiL9yC8cvchQee6RxhwTFhaPIu/r8Ibcd4+J1coRPC8MwF7aLltkM1xZTaZLat/2oGv
         V1S+jRlfaP/sXnDnFYtWgjbfWS9g0QRkQtqR0p18xSnJyI4+Pqt5JFUvGSldu2foMCBb
         LTgEfGentdxSgZeQPEP37fmkW8kIcwDsvuyDX5PdRRChyR9nY+8wjm4DyBdrHnxNLoLU
         nr8A==
X-Gm-Message-State: AOAM5325TPwdogUhEY3zrQZPbyxUMc1OgDeki9u8smyArZ2fEf9G6G9n
        wMZ7GonBbfCopvBugDS4E9X/8njjqs0wAw==
X-Google-Smtp-Source: ABdhPJxiTaUQhGo4hc6n7VF01FZrHfbbN/Rv7kzE4J5uUYc6QwrKgyztLAY2bE1qcpyQRsTbMS9ULA==
X-Received: by 2002:a63:5453:: with SMTP id e19mr21445728pgm.439.1613524137537;
        Tue, 16 Feb 2021 17:08:57 -0800 (PST)
Received: from localhost.localdomain (c-73-93-5-123.hsd1.ca.comcast.net. [73.93.5.123])
        by smtp.gmail.com with ESMTPSA id c22sm175770pfc.12.2021.02.16.17.08.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Feb 2021 17:08:56 -0800 (PST)
Sender: Joe Stringer <joestringernz@gmail.com>
From:   Joe Stringer <joe@wand.net.nz>
To:     bpf@vger.kernel.org
Cc:     Joe Stringer <joe@cilium.io>, netdev@vger.kernel.org,
        daniel@iogearbox.net, ast@kernel.org, mtk.manpages@gmail.com,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next 14/17] tools/bpf: Build bpf-sycall.2 in Makefile.docs
Date:   Tue, 16 Feb 2021 17:08:18 -0800
Message-Id: <20210217010821.1810741-15-joe@wand.net.nz>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210217010821.1810741-1-joe@wand.net.nz>
References: <20210217010821.1810741-1-joe@wand.net.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joe Stringer <joe@cilium.io>

Add building of the bpf(2) syscall commands documentation as part of the
docs building step in the build. This allows us to pick up on potential
parse errors from the docs generator script as part of selftests.

Reviewed-by: Quentin Monnet <quentin@isovalent.com>
Signed-off-by: Joe Stringer <joe@cilium.io>
---
 tools/bpf/Makefile.docs | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/tools/bpf/Makefile.docs b/tools/bpf/Makefile.docs
index 7111888ca5d8..47da582cdaf2 100644
--- a/tools/bpf/Makefile.docs
+++ b/tools/bpf/Makefile.docs
@@ -21,18 +21,27 @@ endif
 
 prefix ?= /usr/local
 mandir ?= $(prefix)/man
+man2dir = $(mandir)/man2
 man7dir = $(mandir)/man7
 
+SYSCALL_RST = bpf-syscall.rst
+MAN2_RST = $(SYSCALL_RST)
+
 HELPERS_RST = bpf-helpers.rst
 MAN7_RST = $(HELPERS_RST)
 
+_DOC_MAN2 = $(patsubst %.rst,%.2,$(MAN2_RST))
+DOC_MAN2 = $(addprefix $(OUTPUT),$(_DOC_MAN2))
+
 _DOC_MAN7 = $(patsubst %.rst,%.7,$(MAN7_RST))
 DOC_MAN7 = $(addprefix $(OUTPUT),$(_DOC_MAN7))
 
-DOCTARGETS := helpers
+DOCTARGETS := helpers syscall
 
 docs: $(DOCTARGETS)
+syscall: man2
 helpers: man7
+man2: $(DOC_MAN2)
 man7: $(DOC_MAN7)
 
 RST2MAN_DEP := $(shell command -v rst2man 2>/dev/null)
@@ -70,9 +79,10 @@ endef
 
 # Create the make targets to generate manual pages by name and section
 $(eval $(call DOCS_RULES,helpers,7))
+$(eval $(call DOCS_RULES,syscall,2))
 
 docs-clean: $(foreach doctarget,$(DOCTARGETS), docs-clean-$(doctarget))
 docs-install: $(foreach doctarget,$(DOCTARGETS), docs-install-$(doctarget))
 docs-uninstall: $(foreach doctarget,$(DOCTARGETS), docs-uninstall-$(doctarget))
 
-.PHONY: docs docs-clean docs-install docs-uninstall man7
+.PHONY: docs docs-clean docs-install docs-uninstall man2 man7
-- 
2.27.0

