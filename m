Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A107425C8B
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 21:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241984AbhJGTrI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 15:47:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241270AbhJGTq4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 15:46:56 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF0EEC061776
        for <netdev@vger.kernel.org>; Thu,  7 Oct 2021 12:44:57 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id v25so22395272wra.2
        for <netdev@vger.kernel.org>; Thu, 07 Oct 2021 12:44:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=n7oZc6djET+GnKc+NOVA6imoHLbGHu6YJTvTjBlNDjc=;
        b=LCCvHsAkqQNxKRfKd/O1AyfuxTlMBp6K45Aisy6ruIAHTctf19tnDaOQE796tbasuI
         RLJzD2iMILGpNAvbZGELeo4H9x/cAQVsmWlTRKb4zR0p12XCRQSKi9Yck3SIEdzOWoRC
         n3YgZXu2w2D8IoBrr+/6jbrGQOzMCMwi53gGNK4CdIfOpfUzbj3BpfH6OH813sdCjvAY
         79sBJFu3fbeAt22y2GpJ5xkEHd2rV/bcHbJ4zNPZAFz3HeacpWoUvMmtV540uDx6O6nS
         80U1nhsj3nazvwTKbhYagal2m9u+5if6+gvtlgwpk4GwQGh+yrW1j+sYr4VCcxrHSWcc
         bXfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=n7oZc6djET+GnKc+NOVA6imoHLbGHu6YJTvTjBlNDjc=;
        b=GNUTyKWcFfuS7/tIJeQaW/Bo4dPHBPhxcXmqbKqlR9vnlkxqpBJRuKpL493Uc2Bg/8
         xkCBSgjrjIzhYQuea4tRnruQx/wvz63NSp2d6QzY1trffCCbFjmpK3Y4P01l+hJP8lQR
         0lotlMIbFGSnHdwqFSpmOikXqnf4FYls6IAQ6kD2OVGDnqOs+Moj4Sazk1CDwbsOytDx
         fvBEyyxdRxruRFeDpnDXPDAJB3bdAx9QE8A0Y2LfaLkqqM41QTJYpmZxb+xe8w3EsMjN
         lSo022F4TijFxi+fJHqmUuC7bIQcyJGI5KQz8xC/9oA84yR22yoLkEjybyB2HmT1XMgH
         eStw==
X-Gm-Message-State: AOAM531f8ttU4yyzX4G5Al4kyiOt/JuJFbQtg2HmIqSi8R4G0sVXW6lR
        jsbLmNnokVCoXqsN31TmBxdAir0uQMpU6VDhf0s=
X-Google-Smtp-Source: ABdhPJzcPXQc/yhviX4N7ZuxdMLR54QU1S7c42bfYaAxWjoWkjqHe12GTdZp7cwfzS8meVL64Euqrw==
X-Received: by 2002:a1c:7d0c:: with SMTP id y12mr18193071wmc.6.1633635896542;
        Thu, 07 Oct 2021 12:44:56 -0700 (PDT)
Received: from localhost.localdomain ([149.86.87.165])
        by smtp.gmail.com with ESMTPSA id u2sm259747wrr.35.2021.10.07.12.44.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 12:44:56 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next v4 12/12] bpftool: add install-bin target to install binary only
Date:   Thu,  7 Oct 2021 20:44:38 +0100
Message-Id: <20211007194438.34443-13-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211007194438.34443-1-quentin@isovalent.com>
References: <20211007194438.34443-1-quentin@isovalent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With "make install", bpftool installs its binary and its bash completion
file. Usually, this is what we want. But a few components in the kernel
repository (namely, BPF iterators and selftests) also install bpftool
locally before using it. In such a case, bash completion is not
necessary and is just a useless build artifact.

Let's add an "install-bin" target to bpftool, to offer a way to install
the binary only.

Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 kernel/bpf/preload/iterators/Makefile | 2 +-
 tools/bpf/bpftool/Makefile            | 6 ++++--
 tools/testing/selftests/bpf/Makefile  | 2 +-
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/preload/iterators/Makefile b/kernel/bpf/preload/iterators/Makefile
index ec39ccc71b8e..616a7ec0232c 100644
--- a/kernel/bpf/preload/iterators/Makefile
+++ b/kernel/bpf/preload/iterators/Makefile
@@ -67,4 +67,4 @@ $(DEFAULT_BPFTOOL): $(BPFOBJ) | $(BPFTOOL_OUTPUT)
 		    OUTPUT=$(BPFTOOL_OUTPUT)/				       \
 		    LIBBPF_OUTPUT=$(LIBBPF_OUTPUT)/			       \
 		    LIBBPF_DESTDIR=$(LIBBPF_DESTDIR)/			       \
-		    prefix= DESTDIR=$(abs_out)/ install
+		    prefix= DESTDIR=$(abs_out)/ install-bin
diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
index ba02d71c39ef..9c2d13c513f0 100644
--- a/tools/bpf/bpftool/Makefile
+++ b/tools/bpf/bpftool/Makefile
@@ -226,10 +226,12 @@ clean: $(LIBBPF)-clean $(LIBBPF_BOOTSTRAP)-clean feature-detect-clean
 	$(Q)$(RM) -- $(OUTPUT)FEATURE-DUMP.bpftool
 	$(Q)$(RM) -r -- $(OUTPUT)feature/
 
-install: $(OUTPUT)bpftool
+install-bin: $(OUTPUT)bpftool
 	$(call QUIET_INSTALL, bpftool)
 	$(Q)$(INSTALL) -m 0755 -d $(DESTDIR)$(prefix)/sbin
 	$(Q)$(INSTALL) $(OUTPUT)bpftool $(DESTDIR)$(prefix)/sbin/bpftool
+
+install: install-bin
 	$(Q)$(INSTALL) -m 0755 -d $(DESTDIR)$(bash_compdir)
 	$(Q)$(INSTALL) -m 0644 bash-completion/bpftool $(DESTDIR)$(bash_compdir)
 
@@ -256,6 +258,6 @@ zdep:
 	@if [ "$(feature-zlib)" != "1" ]; then echo "No zlib found"; exit 1 ; fi
 
 .SECONDARY:
-.PHONY: all FORCE clean install uninstall zdep
+.PHONY: all FORCE clean install-bin install uninstall zdep
 .PHONY: doc doc-clean doc-install doc-uninstall
 .DEFAULT_GOAL := all
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index e023d734f7b0..498222543c37 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -216,7 +216,7 @@ $(DEFAULT_BPFTOOL): $(wildcard $(BPFTOOLDIR)/*.[ch] $(BPFTOOLDIR)/Makefile)    \
 		    OUTPUT=$(HOST_BUILD_DIR)/bpftool/			       \
 		    LIBBPF_OUTPUT=$(HOST_BUILD_DIR)/libbpf/		       \
 		    LIBBPF_DESTDIR=$(HOST_SCRATCH_DIR)/			       \
-		    prefix= DESTDIR=$(HOST_SCRATCH_DIR)/ install
+		    prefix= DESTDIR=$(HOST_SCRATCH_DIR)/ install-bin
 
 all: docs
 
-- 
2.30.2

