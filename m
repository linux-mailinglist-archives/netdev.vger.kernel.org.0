Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF63A3D783E
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 16:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236881AbhG0OMx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 10:12:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236870AbhG0OMu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 10:12:50 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B215AC0613C1
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 07:12:50 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id j2so15347074wrx.9
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 07:12:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura-hr.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=QR9jJL/Uvm+62LnA1ziwlgBrfvBLKf5QTJFduM8WRLQ=;
        b=uLpt/P7SkjsqhJX0t0OKhTNfWtkTuuNKxwTa4ggmLti9bIm5TWevV39qkTnl5v9H1b
         wnLXg8RW5gJxarh083ckdVB4ipK70go02tx1WPbg5kgGO4Zg6s9gZ30k6vuCLQc1Gi3z
         SoVTssc3aZwhpayiwuj7abx2Y5LrvVkXlI3SCoxxRXfnWUs7I8pEYS/fM0yJPxcBG8m7
         svjrl21zl6B3w+4pNJv+O84zW2WysxKr8d8qDfxVhP4SONotsZf981JC/bRBi+9FTxpV
         tKSFckvkRjZzdkSUBpjUcnpHuQUfgIifJjUz+9IXjX7xQJZ2OaqJoO2gS2YFN4biFvDG
         /7IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QR9jJL/Uvm+62LnA1ziwlgBrfvBLKf5QTJFduM8WRLQ=;
        b=NTl/F/Z3A8DXWjI00axw6VQHH/xTQElMGzIwTfJgTE9eSGzxuuwkLFVr3SiBkn3EDw
         ETmhnKFZ2nZSoFWiegr5NlBxL7ljH1AHbkVbjcxDxuC4zVofwJw2kdogbSqO7zPM0QYD
         Yb3Q8B2wLUtJvh/pnyKbb6jD7XFIzbvpOS6HFPVMOCpOooWuJJzasmu8GH4Ib9OGaLUG
         nJ2xLnOHwhj3q9aNahxPomGvHPozMLBQ1MSkgZ6uFHDEmvcLaL3Ebg0uZx2QIwIDj02a
         QNouHp7FEDbFmUm9ta+kkav7s1HkGXr5z8yLF4qFLjLluNYpHErArhsCZMWwp6AtagVh
         3T+w==
X-Gm-Message-State: AOAM5331CZkmxp87c9JisWr6YKn/NF7efyjWmXbnZTp4S5XULDmjbjZs
        /N8g/ouTVZR39xDIPIo/WpHLWQ==
X-Google-Smtp-Source: ABdhPJxBASDSr17bprwY/Kaz2o4B+YEA4sd08CyoWXmUqJU5LSqIdLMb+OjdAW3akqLNxuPX7GNA9Q==
X-Received: by 2002:adf:c3c5:: with SMTP id d5mr17081357wrg.76.1627395169375;
        Tue, 27 Jul 2021 07:12:49 -0700 (PDT)
Received: from localhost.localdomain ([89.18.44.40])
        by smtp.gmail.com with ESMTPSA id t1sm3403912wrm.42.2021.07.27.07.12.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 07:12:49 -0700 (PDT)
From:   Pavo Banicevic <pavo.banicevic@sartura.hr>
To:     linux@armlinux.org.uk, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, ivan.khoronzhuk@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        clang-built-linux@googlegroups.com, matt.redfearn@mips.com,
        mingo@kernel.org, dvlasenk@redhat.com, juraj.vijtiuk@sartura.hr,
        robert.marko@sartura.hr, luka.perkov@sartura.hr,
        jakov.petrina@sartura.hr
Subject: [PATCH 2/3] arm: include: asm: unified: mask .syntax unified for clang
Date:   Tue, 27 Jul 2021 16:11:18 +0200
Message-Id: <20210727141119.19812-3-pavo.banicevic@sartura.hr>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210727141119.19812-1-pavo.banicevic@sartura.hr>
References: <20210727141119.19812-1-pavo.banicevic@sartura.hr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>

The samples/bpf reuses linux headers, with clang -emit-llvm,
so this w/a is only for samples/bpf (samples/bpf/Makefile CLANG-bpf).

It allows to build samples/bpf for arm on target board.
In another way clang -emit-llvm generates errors like:

<inline asm>:1:1: error: unknown directive
.syntax unified

I have verified it on clang 5, 6, 7, 8, 9, 10
as on native platform as for cross-compiling. This decision is
arguable, but it doesn't have impact on samples/bpf so it's easier
just ignore it for clang, at least for now...

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
---
 arch/arm/include/asm/unified.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/unified.h b/arch/arm/include/asm/unified.h
index 1e2c3eb04353..8718f313e7c4 100644
--- a/arch/arm/include/asm/unified.h
+++ b/arch/arm/include/asm/unified.h
@@ -11,7 +11,9 @@
 #if defined(__ASSEMBLY__)
 	.syntax unified
 #else
-__asm__(".syntax unified");
+
+#ifndef __clang__
+	__asm__(".syntax unified");
 #endif
 
 #ifdef CONFIG_CPU_V7M
-- 
2.32.0

