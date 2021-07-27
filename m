Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9040B3D7844
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 16:13:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236916AbhG0ONE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 10:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236958AbhG0ONC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 10:13:02 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59FE7C0613D5
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 07:12:59 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id z4so3518188wrv.11
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 07:12:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura-hr.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=qwa+xoI2CDwZCXWoP75fryBIWWQhf6+Djvh21ehxk/s=;
        b=B5jXowo1MEKTQwzw6BcXm2W96amte5w/etnTWTcj6Zhl7tbiWTGNZQDVHrKndwOIQd
         JesYaR1CcQVQDiIcW1jlMeXN5G2j2Y861g/NwtI6DjmDcSpjawN15OxaMT+oqiHWAIwV
         7fSjkk3bx6ozMc1cSxtAlee+QQsesEunnstoczGzOY1AMHUq49gC/Esv8OKObPSYftQ6
         cjzH2V86ZG84eWJSC0HzmdysWlqYr/8k9TL+ecOS944FJ0jM4WrQF9rcDK95Wps/vSzN
         AeU2kwI0NHufhBINRSXL0Xca68p8IBl3Wjw3U9KEwUmNBR45xs5X/48QoKGZPtdhbOU8
         ndRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qwa+xoI2CDwZCXWoP75fryBIWWQhf6+Djvh21ehxk/s=;
        b=DjtgAqggfHW+NN37vlZRaBY09SPssZINLeDXCEWAxTXbCHMxvedQmNUWqjaHIoYB9v
         EY2VU3RijNB9zfuerxbqRuIWLUNgY0qavIvtJ5s7B4bu4BwVWjRXqN+OGNU8XFnrmThi
         UVUp9SwwgW2B8Y53odotoNcAc+EQXmgm8JziAiwkWDkDh3epbFdyw5r5jOagMK3a5bDT
         /VDAmcoYQv3KorV01X4WQkFVfhdX/SAx6J8I6qbondGC9UE8zgfZLnKFdbninzjZtZLf
         CaaiZlyO1HLttTpTr+zUxGh72tyv8SmXZLvrm8lr/xwt3o6hyduL2oSmjdUHiKjPmPgI
         mKfg==
X-Gm-Message-State: AOAM531TtQOCuGIxHcCSsmCGBfHUMC43gR7N/JcG6LlrWO2851Xe/NYb
        /UL+1SZhO2oXug1CVQetpqREvQ==
X-Google-Smtp-Source: ABdhPJymk8QOoNoXgtQDsH39yKQZDnxw+nqTrnuq/dQN+y4rdWF1MHWvhEqw3VQzNu1AgOudRgaiSg==
X-Received: by 2002:a05:6000:1b02:: with SMTP id f2mr20915877wrz.274.1627395177949;
        Tue, 27 Jul 2021 07:12:57 -0700 (PDT)
Received: from localhost.localdomain ([89.18.44.40])
        by smtp.gmail.com with ESMTPSA id t1sm3403912wrm.42.2021.07.27.07.12.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 07:12:57 -0700 (PDT)
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
Subject: [PATCH 3/3] include/uapi/linux/swab: Fix potentially missing __always_inline
Date:   Tue, 27 Jul 2021 16:11:19 +0200
Message-Id: <20210727141119.19812-4-pavo.banicevic@sartura.hr>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210727141119.19812-1-pavo.banicevic@sartura.hr>
References: <20210727141119.19812-1-pavo.banicevic@sartura.hr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matt Redfearn <matt.redfearn@mips.com>

Commit bc27fb68aaad ("include/uapi/linux/byteorder, swab: force inlining
of some byteswap operations") added __always_inline to swab functions
and commit 283d75737837 ("uapi/linux/stddef.h: Provide __always_inline to
userspace headers") added a definition of __always_inline for use in
exported headers when the kernel's compiler.h is not available.

However, since swab.h does not include stddef.h, if the header soup does
not indirectly include it, the definition of __always_inline is missing,
resulting in a compilation failure, which was observed compiling the
perf tool using exported headers containing this commit:

In file included from /usr/include/linux/byteorder/little_endian.h:12:0,
                 from /usr/include/asm/byteorder.h:14,
                 from tools/include/uapi/linux/perf_event.h:20,
                 from perf.h:8,
                 from builtin-bench.c:18:
/usr/include/linux/swab.h:160:8: error: unknown type name `__always_inline'
 static __always_inline __u16 __swab16p(const __u16 *p)

Fix this by replacing the inclusion of linux/compiler.h with
linux/stddef.h to ensure that we pick up that definition if required,
without relying on it's indirect inclusion. compiler.h is then included
indirectly, via stddef.h.

Fixes: 283d75737837 ("uapi/linux/stddef.h: Provide __always_inline to userspace headers")

Signed-off-by: Matt Redfearn <matt.redfearn@mips.com>
---
 include/uapi/linux/swab.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/swab.h b/include/uapi/linux/swab.h
index 7272f85d6d6a..3736f2fe1541 100644
--- a/include/uapi/linux/swab.h
+++ b/include/uapi/linux/swab.h
@@ -3,7 +3,7 @@
 #define _UAPI_LINUX_SWAB_H
 
 #include <linux/types.h>
-#include <linux/compiler.h>
+#include <linux/stddef.h>
 #include <asm/bitsperlong.h>
 #include <asm/swab.h>
 
-- 
2.32.0

