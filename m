Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01E783D0512
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 01:14:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233417AbhGTWbM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 18:31:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232014AbhGTWau (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 18:30:50 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6813CC0613E6
        for <netdev@vger.kernel.org>; Tue, 20 Jul 2021 16:11:18 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id v1so52730edt.6
        for <netdev@vger.kernel.org>; Tue, 20 Jul 2021 16:11:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=05UtSVUfKwNTMLK78kxEDJTAm/yjx7xPuTWlYyH+t/c=;
        b=UlNCyepq3YNi/Kw+KK8GYcy3l5nsx1v3ozrHuSxjnXErTlZDtwCoaV/FgPdcgBmzia
         VIEkZ6gQK9eK2RMEDCeyxb0b2PFJX1KBaEN7dMdOZXtrVEeTv6Lf0y1YwzFMiXxgbAKj
         dQbTjzOf9qzz6tZ3R6FfQt+Mm6vAA2cW8zHfcZs3Eaz/ONm5ARUDf45QLEMUyNcALwrm
         nH9pHMy8QNzlk3+JuBHq8uAyj+28P7OZmaAvnEl1Gy7MnA1/7ZxJ8Asyd+0SfrcTJQ2j
         o+SUSR8gbXfB/srzXk7mlGZYd7sHZ19daXBZQG3NFtSCkP1Lne96rYm/SphysqF0fm6u
         URQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=05UtSVUfKwNTMLK78kxEDJTAm/yjx7xPuTWlYyH+t/c=;
        b=li3NM7441bFlPp3kV6UUo6zvYkERPyvhWqiTUU579SbnnalYIhtxGliHYD+LcYLDme
         boMVZ0roO3BoTmex+ll2b3byOX+MPUkMXyD6Jn6f/+G0d7MB87mIMfGDrlOv2Lw1gBiv
         i5o1fdSaAjq9xHgIL2BrV3kIZ04Ya5PrsWtaEyhNjIbISGAQHRV2qNStdnzTnPhTW+I9
         rjNK4357jZr+em3enmhojzeTWac+YMt/K0d3BODZE/lLwolmzwx+3K0pPEHN8RxRkh+o
         vPPH456JeNKOJptkHJPpTPyTKTe48qtQOjdUJvD4oBWvIVPFUIiXH8rh/9zLvM11Jh7d
         hv2g==
X-Gm-Message-State: AOAM532aKUlVYjvZAIR+1wY6kv4SntkxRBHRocWmd1LSxXTeXS+KkjJX
        v9Hmk2+9lj0oMn3NWtbUmDxzkw==
X-Google-Smtp-Source: ABdhPJxY7YQG1OXTKCtnfRO9H7Hx79q5mTZtQLmCTGEfR5d0b1KFC1KJhs/O37hkZUTpcTxJUAhKiw==
X-Received: by 2002:aa7:dd8d:: with SMTP id g13mr44261821edv.336.1626822676896;
        Tue, 20 Jul 2021 16:11:16 -0700 (PDT)
Received: from anpc2.lan (static-213-115-136-2.sme.telenor.se. [213.115.136.2])
        by smtp.gmail.com with ESMTPSA id d10sm9778303edh.62.2021.07.20.16.11.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jul 2021 16:11:16 -0700 (PDT)
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
To:     Tony.Ambardar@gmail.com, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, tsbogend@alpha.franken.de, paulburton@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-mips@vger.kernel.org, ddaney@caviumnetworks.com,
        luke.r.nels@gmail.com, fancer.lancer@gmail.com, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>
Subject: [RFC PATCH 2/2] mips: bpf: enable 32-bit eBPF JIT
Date:   Wed, 21 Jul 2021 01:10:36 +0200
Message-Id: <20210720231036.3740924-3-johan.almbladh@anyfinetworks.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210720231036.3740924-1-johan.almbladh@anyfinetworks.com>
References: <20210720231036.3740924-1-johan.almbladh@anyfinetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch enables the new 32-bit eBPF JIT for MIPS. It also disables
the old cBPF JIT to so cBPF programs are converted to use the new JIT.

Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
---
 arch/mips/Kconfig | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index cee6087cd686..b87184bf18df 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -55,7 +55,6 @@ config MIPS
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE if CPU_SUPPORTS_HUGEPAGES
 	select HAVE_ASM_MODVERSIONS
-	select HAVE_CBPF_JIT if !64BIT && !CPU_MICROMIPS
 	select HAVE_CONTEXT_TRACKING
 	select HAVE_TIF_NOHZ
 	select HAVE_C_RECORDMCOUNT
@@ -63,7 +62,9 @@ config MIPS
 	select HAVE_DEBUG_STACKOVERFLOW
 	select HAVE_DMA_CONTIGUOUS
 	select HAVE_DYNAMIC_FTRACE
-	select HAVE_EBPF_JIT if 64BIT && !CPU_MICROMIPS && TARGET_ISA_REV >= 2
+	select HAVE_EBPF_JIT if ((32BIT && TARGET_ISA_REV <= 5) || \
+	                         (64BIT && TARGET_ISA_REV >= 2)) && \
+	                        !CPU_MICROMIPS
 	select HAVE_EXIT_THREAD
 	select HAVE_FAST_GUP
 	select HAVE_FTRACE_MCOUNT_RECORD
-- 
2.25.1

