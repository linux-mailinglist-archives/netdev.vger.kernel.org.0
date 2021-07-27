Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDACD3D783A
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 16:12:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236790AbhG0OMp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 10:12:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232419AbhG0OMo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 10:12:44 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAAF3C061757
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 07:12:43 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id o5-20020a1c4d050000b02901fc3a62af78so1976295wmh.3
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 07:12:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura-hr.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=qh2D1P9GbylvB9WoMcMMTns7dk4r496odHfS4e44Lvg=;
        b=dZJmp177mREM10LfYUmdsmKymvqT9zX8M9d5RPLo0iJkNjXevLNRLGN2N3SaMXmwG0
         vMLcK3Egi3Dx/TofYjBPkZVs7gZomoKadG+grDxLH/zhPIVWshiOWPbIRlOnhI23xx2V
         8JU1Y/mZQpn/iSv0KXvTHP3kgMnFZsLIzPMcGPaDUfIPkmo/OjpDGiYVIXj37ZxwMHCw
         GSdXIX+TYtZnqwoZQcK3nfX9Pk53gGJlNtMzXWBMdFWCxYb0uBNYFx233cwHTgvTkXz+
         bCVsfLtAaE4uD5SIZKMVIA5/cIvjop2of7YyRCNS3Z08nVO9dXrgqQQ15ovFDDCOHsXP
         nNiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qh2D1P9GbylvB9WoMcMMTns7dk4r496odHfS4e44Lvg=;
        b=W09LZ5SdPRtxijIXTn2v1yAc9L1rbQETsEvitx8JJbfL6/phhsWECmbu6mBhmUbYv8
         ZhByAUWNUAFmG6A2u1Jzp9CfSWY5cpNd5DRMmy8yTrtzdrOCBsdBrS7VkvZhx9R2gmLK
         GXqb88+0K7IUpt6eVuwLpiUiZW3wPjfI9Ut82aUvP64iHntfHCrpoIvjWay6RCSFF+Yz
         xlPpySmBlHX/BMtkDeCbesoMT4zA+IAgs8Wjo7cvubWXzX33kjn5Vcxt79xd8tSC99w2
         hhdEF7wCI9DnyEiSRRm3XnEQTMFWgH4/+QO614E5K8BsRkO68NyNiPYysnFbWfA4DAVj
         S3Gw==
X-Gm-Message-State: AOAM532cxt9ODZBedYpiE1doM4VGXWXRRa2Z80VrPcURkXGe/dwtPolj
        JPYueS0a/UlrXuW0b1LB2rXV+w==
X-Google-Smtp-Source: ABdhPJwxw8NT0xdiy200Yml8rZafYGmbp6+07m5Rczyx8Rmsxg2J5fenyyka4XSwb6wfG6tz1ibW8g==
X-Received: by 2002:a05:600c:2907:: with SMTP id i7mr4369027wmd.184.1627395162452;
        Tue, 27 Jul 2021 07:12:42 -0700 (PDT)
Received: from localhost.localdomain ([89.18.44.40])
        by smtp.gmail.com with ESMTPSA id t1sm3403912wrm.42.2021.07.27.07.12.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 07:12:42 -0700 (PDT)
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
Subject: [PATCH 1/3] arm: include: asm: swab: mask rev16 instruction for clang
Date:   Tue, 27 Jul 2021 16:11:17 +0200
Message-Id: <20210727141119.19812-2-pavo.banicevic@sartura.hr>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210727141119.19812-1-pavo.banicevic@sartura.hr>
References: <20210727141119.19812-1-pavo.banicevic@sartura.hr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>

The samples/bpf with clang -emit-llvm reuses linux headers to build
bpf samples, and this w/a only for samples (samples/bpf/Makefile
CLANG-bpf).

It allows to build samples/bpf for arm bpf using clang.
In another way clang -emit-llvm generates errors like:

CLANG-bpf  samples/bpf/tc_l2_redirect_kern.o
<inline asm>:1:2: error: invalid register/token name
rev16 r3, r0

This decision is arguable, probably there is another way, but
it doesn't have impact on samples/bpf, so it's easier just ignore
it for clang, at least for now.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
---
 arch/arm/include/asm/swab.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/include/asm/swab.h b/arch/arm/include/asm/swab.h
index c6051823048b..a9fd9cd33d5e 100644
--- a/arch/arm/include/asm/swab.h
+++ b/arch/arm/include/asm/swab.h
@@ -25,8 +25,11 @@ static inline __attribute_const__ __u32 __arch_swahb32(__u32 x)
 	__asm__ ("rev16 %0, %1" : "=r" (x) : "r" (x));
 	return x;
 }
+
+#ifndef __clang__
 #define __arch_swahb32 __arch_swahb32
 #define __arch_swab16(x) ((__u16)__arch_swahb32(x))
+#endif
 
 static inline __attribute_const__ __u32 __arch_swab32(__u32 x)
 {
-- 
2.32.0

