Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21FE231D3AD
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 02:13:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231133AbhBQBMl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 20:12:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231466AbhBQBJz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 20:09:55 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D535EC0617A9;
        Tue, 16 Feb 2021 17:08:56 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id j12so7328580pfj.12;
        Tue, 16 Feb 2021 17:08:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HqCUBkziu5GrtC8jZXdR5IquLRlLWRFSCrlmdHa2zM8=;
        b=e/Lf/Y8VvOmA9hBvUmlL2KNcHxnrvfyKgst0Gj/Le7NuZDA66BiSJ3YxuNtW1TXjdc
         cj1IpJ9XgLG5242mrRj/uxmpWqTLbJA59n3vweAT1PJ2dUFudEi4n6Yp+T0zkUW9uzQd
         qRgDj+J+v15vDZTDrVpret8RRLeq92R0dxfO39KptAFwZ/Z1djqzC9wFiOFpRnMtAv0R
         cMpH7jhXu9lfnLBkG+EECIBbC6SM/hAHnqlA5sOXRPdZpmtRy+VunmUmn9NOSRykAkSi
         HI5n+ktVYd3VXj4ZiNelHQ0/2dCAB0DJwQxUBeQ3AYasaWYqkLyECR9DT/n73zyGpMmJ
         gnug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=HqCUBkziu5GrtC8jZXdR5IquLRlLWRFSCrlmdHa2zM8=;
        b=hNTSscJz4n5AGNqvQ+0ESPRQg2r9T+8XIw7HaXr9X2PdFqyroVSnLokUiwx+x/nkTJ
         M1RaRk4iq7NQBT6/4W+EeMHNBnrZ33Ti2ER9D6msgMc5F2YSwdrK4Bs3iHu4u4BdI4lN
         8dkYQBT/tvXfCtx0wkU5wHGJX4uLobWChhQammtADzWS/R1lh9oDlK1oBnYPYP3bUStr
         WW3bfp/lkA9SCIB3SY9r0l717XYdTmlqQU0gsFfXF+zkACZFD13jEP2nb/5OGTSQ276B
         snHsnKplSpcLvfNo+AEExrP5gDsTo9GczWQfibShO2lQ2lIB5xvvTIkUbnRlxolo1Mpn
         w8Wg==
X-Gm-Message-State: AOAM531CgRsK5thwXfcGiML3csxj2C1Rs/TzlSB2W64yiZSWU0krhUW9
        2D9HdlnhHYYpdR/4VZly8R2KJ0bs2AUfvw==
X-Google-Smtp-Source: ABdhPJyRs/QG3d+RPhMepnPwN5nz/ZgJ8UF30iiN1EUg2ZwfW0UHFxR3x6JzhjysP4KBrFimdO516w==
X-Received: by 2002:a63:e442:: with SMTP id i2mr20972838pgk.12.1613524136052;
        Tue, 16 Feb 2021 17:08:56 -0800 (PST)
Received: from localhost.localdomain (c-73-93-5-123.hsd1.ca.comcast.net. [73.93.5.123])
        by smtp.gmail.com with ESMTPSA id c22sm175770pfc.12.2021.02.16.17.08.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Feb 2021 17:08:55 -0800 (PST)
Sender: Joe Stringer <joestringernz@gmail.com>
From:   Joe Stringer <joe@wand.net.nz>
To:     bpf@vger.kernel.org
Cc:     Joe Stringer <joe@cilium.io>, netdev@vger.kernel.org,
        daniel@iogearbox.net, ast@kernel.org, mtk.manpages@gmail.com,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next 13/17] tools/bpf: Templatize man page generation
Date:   Tue, 16 Feb 2021 17:08:17 -0800
Message-Id: <20210217010821.1810741-14-joe@wand.net.nz>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210217010821.1810741-1-joe@wand.net.nz>
References: <20210217010821.1810741-1-joe@wand.net.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joe Stringer <joe@cilium.io>

Previously, the Makefile here was only targeting a single manual page so
it just hardcoded a bunch of individual rules to specifically handle
build, clean, install, uninstall for that particular page.

Upcoming commits will generate manual pages for an additional section,
so this commit prepares the makefile first by converting the existing
targets into an evaluated set of targets based on the manual page name
and section.

Reviewed-by: Quentin Monnet <quentin@isovalent.com>
Signed-off-by: Joe Stringer <joe@cilium.io>
---
 tools/bpf/Makefile.docs                  | 52 ++++++++++++++++--------
 tools/bpf/bpftool/Documentation/Makefile |  8 ++--
 2 files changed, 39 insertions(+), 21 deletions(-)

diff --git a/tools/bpf/Makefile.docs b/tools/bpf/Makefile.docs
index dc4ce82ada33..7111888ca5d8 100644
--- a/tools/bpf/Makefile.docs
+++ b/tools/bpf/Makefile.docs
@@ -29,32 +29,50 @@ MAN7_RST = $(HELPERS_RST)
 _DOC_MAN7 = $(patsubst %.rst,%.7,$(MAN7_RST))
 DOC_MAN7 = $(addprefix $(OUTPUT),$(_DOC_MAN7))
 
+DOCTARGETS := helpers
+
+docs: $(DOCTARGETS)
 helpers: man7
 man7: $(DOC_MAN7)
 
 RST2MAN_DEP := $(shell command -v rst2man 2>/dev/null)
 
-$(OUTPUT)$(HELPERS_RST): $(UP2DIR)../../include/uapi/linux/bpf.h
-	$(QUIET_GEN)$(UP2DIR)../../scripts/bpf_doc.py --filename $< > $@
+# Configure make rules for the man page bpf-$1.$2.
+# $1 - target for scripts/bpf_doc.py
+# $2 - man page section to generate the troff file
+define DOCS_RULES =
+$(OUTPUT)bpf-$1.rst: $(UP2DIR)../../include/uapi/linux/bpf.h
+	$$(QUIET_GEN)$(UP2DIR)../../scripts/bpf_doc.py $1 \
+		--filename $$< > $$@
 
-$(OUTPUT)%.7: $(OUTPUT)%.rst
+$(OUTPUT)%.$2: $(OUTPUT)%.rst
 ifndef RST2MAN_DEP
-	$(error "rst2man not found, but required to generate man pages")
+	$$(error "rst2man not found, but required to generate man pages")
 endif
-	$(QUIET_GEN)rst2man $< > $@
+	$$(QUIET_GEN)rst2man $$< > $$@
+
+docs-clean-$1:
+	$$(call QUIET_CLEAN, eBPF_$1-manpage)
+	$(Q)$(RM) $$(DOC_MAN$2) $(OUTPUT)bpf-$1.rst
+
+docs-install-$1: docs
+	$$(call QUIET_INSTALL, eBPF_$1-manpage)
+	$(Q)$(INSTALL) -d -m 755 $(DESTDIR)$$(man$2dir)
+	$(Q)$(INSTALL) -m 644 $$(DOC_MAN$2) $(DESTDIR)$$(man$2dir)
+
+docs-uninstall-$1:
+	$$(call QUIET_UNINST, eBPF_$1-manpage)
+	$(Q)$(RM) $$(addprefix $(DESTDIR)$$(man$2dir)/,$$(_DOC_MAN$2))
+	$(Q)$(RMDIR) $(DESTDIR)$$(man$2dir)
 
-helpers-clean:
-	$(call QUIET_CLEAN, eBPF_helpers-manpage)
-	$(Q)$(RM) $(DOC_MAN7) $(OUTPUT)$(HELPERS_RST)
+.PHONY: $1 docs-clean-$1 docs-install-$1 docs-uninstall-$1
+endef
 
-helpers-install: helpers
-	$(call QUIET_INSTALL, eBPF_helpers-manpage)
-	$(Q)$(INSTALL) -d -m 755 $(DESTDIR)$(man7dir)
-	$(Q)$(INSTALL) -m 644 $(DOC_MAN7) $(DESTDIR)$(man7dir)
+# Create the make targets to generate manual pages by name and section
+$(eval $(call DOCS_RULES,helpers,7))
 
-helpers-uninstall:
-	$(call QUIET_UNINST, eBPF_helpers-manpage)
-	$(Q)$(RM) $(addprefix $(DESTDIR)$(man7dir)/,$(_DOC_MAN7))
-	$(Q)$(RMDIR) $(DESTDIR)$(man7dir)
+docs-clean: $(foreach doctarget,$(DOCTARGETS), docs-clean-$(doctarget))
+docs-install: $(foreach doctarget,$(DOCTARGETS), docs-install-$(doctarget))
+docs-uninstall: $(foreach doctarget,$(DOCTARGETS), docs-uninstall-$(doctarget))
 
-.PHONY: helpers helpers-clean helpers-install helpers-uninstall
+.PHONY: docs docs-clean docs-install docs-uninstall man7
diff --git a/tools/bpf/bpftool/Documentation/Makefile b/tools/bpf/bpftool/Documentation/Makefile
index bb7842efffd6..f60b800584a5 100644
--- a/tools/bpf/bpftool/Documentation/Makefile
+++ b/tools/bpf/bpftool/Documentation/Makefile
@@ -24,7 +24,7 @@ MAN8_RST = $(wildcard bpftool*.rst)
 _DOC_MAN8 = $(patsubst %.rst,%.8,$(MAN8_RST))
 DOC_MAN8 = $(addprefix $(OUTPUT),$(_DOC_MAN8))
 
-man: man8 helpers
+man: man8 docs
 man8: $(DOC_MAN8)
 
 RST2MAN_DEP := $(shell command -v rst2man 2>/dev/null)
@@ -46,16 +46,16 @@ ifndef RST2MAN_DEP
 endif
 	$(QUIET_GEN)( cat $< ; printf "%b" $(call see_also,$<) ) | rst2man $(RST2MAN_OPTS) > $@
 
-clean: helpers-clean
+clean: docs-clean
 	$(call QUIET_CLEAN, Documentation)
 	$(Q)$(RM) $(DOC_MAN8)
 
-install: man helpers-install
+install: man docs-install
 	$(call QUIET_INSTALL, Documentation-man)
 	$(Q)$(INSTALL) -d -m 755 $(DESTDIR)$(man8dir)
 	$(Q)$(INSTALL) -m 644 $(DOC_MAN8) $(DESTDIR)$(man8dir)
 
-uninstall: helpers-uninstall
+uninstall: docs-uninstall
 	$(call QUIET_UNINST, Documentation-man)
 	$(Q)$(RM) $(addprefix $(DESTDIR)$(man8dir)/,$(_DOC_MAN8))
 	$(Q)$(RMDIR) $(DESTDIR)$(man8dir)
-- 
2.27.0

