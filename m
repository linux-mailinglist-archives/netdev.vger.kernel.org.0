Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62534422E89
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 18:54:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236760AbhJEQ4b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 12:56:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236644AbhJEQ4W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 12:56:22 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0104C061749
        for <netdev@vger.kernel.org>; Tue,  5 Oct 2021 09:54:31 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id d8so1321482edx.9
        for <netdev@vger.kernel.org>; Tue, 05 Oct 2021 09:54:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sSpYqWckQN5De4SWAzfiTyGMwb6xlhm08Y9d5cl4EUw=;
        b=MOvmVT7UML8WRbH713BepTaRHyQHiaXPJIM3OD89/a22DC2OqqC5Rl9gWPfdK9DfU6
         Vi4lBbgW6SbZxrNeC8isx4sE/XovAI1hhqLFXDeeBhagEcCe+JhQYnZ0FaAfubDJq9KG
         5i7J20pdHFepGnCrmIaj1xgKKserwW8DC7yJCjTW4/3HzOgHXblfpdftJ5B4Um9Oo/dS
         /tXg7ycG/U+mTzDFvreNXbG86nY65V077DwmNP2fer8gItwRTbOzXFv8fktUFlKZvb7s
         oKgZ5RM44lWGeaW7GE9soqGpjF/vIejEf/Znjcxk6sV8Bq/ONwJTV0gna0ChXejUik78
         TW3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sSpYqWckQN5De4SWAzfiTyGMwb6xlhm08Y9d5cl4EUw=;
        b=OTJ958oX6TgTM2NEzF4YYhjKjip1MQNW7G2wi2UUeuG56nmb+CTmDBl5yz/aO2/jqB
         K2masQzyVBhnjh7Y9Akd6fur0tldIs+DZQCHAmK6SqG7HF7KqmS4TMRQcKXsGfQw29kG
         UFR+A9j+lm9Y+6evIVLe0w4GtBYRbnKXeSdzFWygK0m3NRPryTu5d6r11ChlSNy3A1L6
         U14Sv5HauEgnejXgp/fFod9EmHR1VDSBbhGXA99y1Xb0sGoD6vraiWYhWYWJXnF+6Zu9
         S2u+a4NtBPJx6+D+buGGlXkVL5fJHWh7PaylXCQTU7tJ75GpagcgXfhkw14xa6G1yhwD
         mzDA==
X-Gm-Message-State: AOAM5336HgEhg5MQ/RNvIguBDRuHfVWOaPM2JaoCgn1qc7oZ+8X+XBhi
        42KAFFIYSOd1XcYm0mJcOYhWkA==
X-Google-Smtp-Source: ABdhPJymACqQ2ebs/0N/U/cqsCfD/8+UQOpr/BvPCRCJvuTrrAHCHhtX9K1IgbT8JjgEO5UGvXYcMQ==
X-Received: by 2002:a17:906:180a:: with SMTP id v10mr26094184eje.112.1633452869832;
        Tue, 05 Oct 2021 09:54:29 -0700 (PDT)
Received: from anpc2.lan (static-213-115-136-2.sme.telenor.se. [213.115.136.2])
        by smtp.gmail.com with ESMTPSA id x16sm3447818ejj.8.2021.10.05.09.54.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 09:54:29 -0700 (PDT)
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        paulburton@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        tsbogend@alpha.franken.de, chenhuacai@kernel.org,
        jiaxun.yang@flygoat.com, yangtiezhu@loongson.cn,
        tony.ambardar@gmail.com, bpf@vger.kernel.org,
        linux-mips@vger.kernel.org, netdev@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>
Subject: [PATCH 6/7] mips: bpf: Enable eBPF JITs
Date:   Tue,  5 Oct 2021 18:54:07 +0200
Message-Id: <20211005165408.2305108-7-johan.almbladh@anyfinetworks.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211005165408.2305108-1-johan.almbladh@anyfinetworks.com>
References: <20211005165408.2305108-1-johan.almbladh@anyfinetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch enables the new eBPF JITs for 32-bit and 64-bit MIPS. It also
disables the old cBPF JIT to so cBPF programs are converted to use the
new JIT.

Workarounds for R4000 CPU errata are not implemented by the JIT, so the
JIT is disabled if any of those workarounds are configured.

Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
---
 MAINTAINERS            | 1 +
 arch/mips/Kconfig      | 6 ++++--
 arch/mips/net/Makefile | 5 +++--
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 76e0fdcdd877..407cd4235995 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3422,6 +3422,7 @@ S:	Supported
 F:	arch/arm64/net/
 
 BPF JIT for MIPS (32-BIT AND 64-BIT)
+M:	Johan Almbladh <johan.almbladh@anyfinetworks.com>
 M:	Paul Burton <paulburton@kernel.org>
 L:	netdev@vger.kernel.org
 L:	bpf@vger.kernel.org
diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 771ca53af06d..38468f47aa5e 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -57,7 +57,6 @@ config MIPS
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE if CPU_SUPPORTS_HUGEPAGES
 	select HAVE_ASM_MODVERSIONS
-	select HAVE_CBPF_JIT if !64BIT && !CPU_MICROMIPS
 	select HAVE_CONTEXT_TRACKING
 	select HAVE_TIF_NOHZ
 	select HAVE_C_RECORDMCOUNT
@@ -65,7 +64,10 @@ config MIPS
 	select HAVE_DEBUG_STACKOVERFLOW
 	select HAVE_DMA_CONTIGUOUS
 	select HAVE_DYNAMIC_FTRACE
-	select HAVE_EBPF_JIT if 64BIT && !CPU_MICROMIPS && TARGET_ISA_REV >= 2
+	select HAVE_EBPF_JIT if !CPU_MICROMIPS && \
+				!CPU_DADDI_WORKAROUNDS && \
+				!CPU_R4000_WORKAROUNDS && \
+				!CPU_R4400_WORKAROUNDS
 	select HAVE_EXIT_THREAD
 	select HAVE_FAST_GUP
 	select HAVE_FTRACE_MCOUNT_RECORD
diff --git a/arch/mips/net/Makefile b/arch/mips/net/Makefile
index e057ee4ba75e..602bf242b13f 100644
--- a/arch/mips/net/Makefile
+++ b/arch/mips/net/Makefile
@@ -2,9 +2,10 @@
 # MIPS networking code
 
 obj-$(CONFIG_MIPS_CBPF_JIT) += bpf_jit.o bpf_jit_asm.o
+obj-$(CONFIG_MIPS_EBPF_JIT) += bpf_jit_comp.o
 
 ifeq ($(CONFIG_32BIT),y)
-        obj-$(CONFIG_MIPS_EBPF_JIT) += bpf_jit_comp.o bpf_jit_comp32.o
+        obj-$(CONFIG_MIPS_EBPF_JIT) += bpf_jit_comp32.o
 else
-        obj-$(CONFIG_MIPS_EBPF_JIT) += ebpf_jit.o
+        obj-$(CONFIG_MIPS_EBPF_JIT) += bpf_jit_comp64.o
 endif
-- 
2.30.2

