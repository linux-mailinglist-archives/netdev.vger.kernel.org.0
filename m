Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FE1EA2BCE
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 02:51:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727738AbfH3Auu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 20:50:50 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:43574 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727595AbfH3Aut (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 20:50:49 -0400
Received: by mail-lf1-f68.google.com with SMTP id q27so3951350lfo.10
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 17:50:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Q+vZM4cZektdF572TqWkVl3QkOoJAXjpmJXjWwwbKzE=;
        b=LEYfqXzZUPeIuy93SH8GAssQsvlBou/hIWteBhvmXq1F9JVWj2wTkzeZdfRJclvOXa
         Ml9kVrTIeDyM2A/3eaEvzVK9/pGt5qEqzLTWvJqdBmLcHkvvh07Ut09wAvSKXrIMNobx
         r2RNchETr9Z4KWTcRDbMNJ6rLBGv3sDWxx1Z8Z5O54FYC/zPoXMdoQJR1eWto+H3GBER
         DlMphrpkhbPZGMzNxrWnt0/mC94HVFKOY0k+/6wVxcaRK9ftaqDrp/Dypqjz3DpeV74s
         5LHndEkamECTgyLl93XSkTDSnp9E79AvMzRJuicO+St87f2BsjM+kyYugZH0KcXkbFhW
         G9ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Q+vZM4cZektdF572TqWkVl3QkOoJAXjpmJXjWwwbKzE=;
        b=t2nmsx6qJdNPFxGlMdD7G0n/iSQVDSW38DUp3XGFLiXuPTqA9miS7UgAeiXT9d+nmE
         y5EOEMnhPyCJfEvNORIrjwyF0SGUm3RInhV4rF2f3xGEzHeKcR4cldjX0bONvMGpx/2Q
         OaNSwJk7TS/pdWNZJ62EQNpbYCVqQnkCLdQrm+zw3LXHk21stHTZ3mkibVpHByomcL2A
         7ZHhPUA2Z0rpy70pkIIVH14mMEzI+iAkVR7TgXNuONytqs/HuP+b2AMyhTWlOS2LWp/A
         7RVK/KzA4Efy8XGpr5gFqx5tRFmVjdLSfLdgeCjq0eltHBapNWF602qfxjFGhMPCKcNi
         Y+Aw==
X-Gm-Message-State: APjAAAW1EmhNI18Qjf8FeTA2dfvPAqIZN0KqjXqK0u3tv0FUbkTtl5PV
        s10ZK+sw6raDVkIQ45guHpjPmg==
X-Google-Smtp-Source: APXvYqyihXTROPMaQ2wywc9lmAKFZbgnRCz1760bakTi1cPbibvD2WXzoa2W4G39kM/s/BUv/T280g==
X-Received: by 2002:a19:ae0b:: with SMTP id f11mr2637945lfc.28.1567126246924;
        Thu, 29 Aug 2019 17:50:46 -0700 (PDT)
Received: from localhost.localdomain (168-200-94-178.pool.ukrtel.net. [178.94.200.168])
        by smtp.gmail.com with ESMTPSA id f19sm628149lfk.43.2019.08.29.17.50.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 17:50:46 -0700 (PDT)
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     linux@armlinux.org.uk, ast@kernel.org, daniel@iogearbox.net,
        yhs@fb.com, davem@davemloft.net, jakub.kicinski@netronome.com,
        hawk@kernel.org, john.fastabend@gmail.com
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH RFC bpf-next 04/10] samples: bpf: use own EXTRA_CFLAGS for clang commands
Date:   Fri, 30 Aug 2019 03:50:31 +0300
Message-Id: <20190830005037.24004-5-ivan.khoronzhuk@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190830005037.24004-1-ivan.khoronzhuk@linaro.org>
References: <20190830005037.24004-1-ivan.khoronzhuk@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It can overlap with CFLAGS used for libraries built with gcc if
not now then in following patches. Correct it here for simplicity.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
---
 samples/bpf/Makefile | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index a2953357927e..cdd742c05200 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -219,10 +219,10 @@ BTF_LLVM_PROBE := $(shell echo "int main() { return 0; }" | \
 			  /bin/rm -f ./llvm_btf_verify.o)
 
 ifneq ($(BTF_LLVM_PROBE),)
-	EXTRA_CFLAGS += -g
+	CLANG_EXTRA_CFLAGS += -g
 else
 ifneq ($(and $(BTF_LLC_PROBE),$(BTF_PAHOLE_PROBE),$(BTF_OBJCOPY_PROBE)),)
-	EXTRA_CFLAGS += -g
+	CLANG_EXTRA_CFLAGS += -g
 	LLC_FLAGS += -mattr=dwarfris
 	DWARF2BTF = y
 endif
@@ -281,8 +281,8 @@ $(obj)/hbm_edt_kern.o: $(src)/hbm.h $(src)/hbm_kern.h
 # useless for BPF samples.
 $(obj)/%.o: $(src)/%.c
 	@echo "  CLANG-bpf " $@
-	$(Q)$(CLANG) $(NOSTDINC_FLAGS) $(LINUXINCLUDE) $(EXTRA_CFLAGS) -I$(obj) \
-		-I$(srctree)/tools/testing/selftests/bpf/ \
+	$(Q)$(CLANG) $(NOSTDINC_FLAGS) $(LINUXINCLUDE) $(CLANG_EXTRA_CFLAGS) \
+		-I$(obj) -I$(srctree)/tools/testing/selftests/bpf/ \
 		-D__KERNEL__ -D__BPF_TRACING__ -Wno-unused-value -Wno-pointer-sign \
 		-D__TARGET_ARCH_$(SRCARCH) -Wno-compare-distinct-pointer-types \
 		-Wno-gnu-variable-sized-type-not-at-end \
-- 
2.17.1

