Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A992B4FC6B
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 17:16:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbfFWPQl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 11:16:41 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:37965 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726399AbfFWPQl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jun 2019 11:16:41 -0400
Received: by mail-pf1-f196.google.com with SMTP id y15so1412329pfn.5;
        Sun, 23 Jun 2019 08:16:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=gTw6yUmcZHJimu/ktruUQIMzL1J4HTeSTmGQzakysDY=;
        b=pRTo9t5gEbwGCdgtlgE/sRyNUZUkGzIY+GVrMnSrH5utlADoDicfMIHdIPuBgZqukn
         N/v4pDQGf2s6UHxnNq9XweGqJfmaU27n6ijPpM/UlUFQS0iKMliUDAsHbc5fvw46FGg4
         jK56RVnA7XoNtipqHCK8NYI9Vczr6+eGkeuDnPHkMzQfPwCIJEjsaSd8B1L1fInCwE6j
         5pOaikS0g9vIOIrexW2iHm5axz8mKOd9oXfu8BDF2JZVGIRehaFeaK5A/y/hwODO/483
         C0e5mqfIFvjlLlpW4fIAgvAezptIHIveBuhpj8flHEKONnawuh1W613EqtDJR4AsjbVD
         CJfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=gTw6yUmcZHJimu/ktruUQIMzL1J4HTeSTmGQzakysDY=;
        b=hyfBFzjXdh2jgtOhXeUAY+RWjCD0JhM58wqQRGQUSqpssZqc9229hXLsHT2TCmvwBt
         FUA3uehJgkkujl3XO/baDeRTjLoqL9eAA9FFCJ1J/6YGnAh8DBjGrvTWQvsFMkTLYNWE
         xYaao4yv1gKvCRONAq/u/AnQFoMoQQq6L5UUQaWgDX2R/JHL/Xe+J0A57AP7O9pmX/Yx
         T4fFdFjwkMq7k+rCSsEzSA37yJmqImgR5KpavjUQPjIcOkm8QjhnnlItI/DgPX1/xyaC
         BZPle42n8X6RCqFgEG4fTisIFGgpRujAsOB9nl6AgMn6hcXfbB83ejYn/l0uXyF2NSEQ
         NFSA==
X-Gm-Message-State: APjAAAUMbZIQUz28hbgICiUu0fhH8e6RF10U7ut5PuEgXlQj9m7aGQKG
        R3BfJs4GP6OHKsFxqb+3FFQ=
X-Google-Smtp-Source: APXvYqzDPpdUQzLN7OSl2ecKXpCU6pxiTuhlPOsPlocnkmlcQNSQFdwdUvwwGxFqETV2an13ftQR2g==
X-Received: by 2002:a17:90a:5887:: with SMTP id j7mr18995083pji.136.1561303000400;
        Sun, 23 Jun 2019 08:16:40 -0700 (PDT)
Received: from debian.net.fpt ([1.55.47.94])
        by smtp.gmail.com with ESMTPSA id p6sm8329194pgs.77.2019.06.23.08.16.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 23 Jun 2019 08:16:39 -0700 (PDT)
From:   Phong Tran <tranmanphong@gmail.com>
To:     mark.rutland@arm.com, kstewart@linuxfoundation.org,
        songliubraving@fb.com, andrew@lunn.ch, peterz@infradead.org,
        nsekhar@ti.com, ast@kernel.org, jolsa@redhat.com,
        netdev@vger.kernel.org, gerg@uclinux.org,
        lorenzo.pieralisi@arm.com, will@kernel.org,
        linux-samsung-soc@vger.kernel.org, daniel@iogearbox.net,
        tranmanphong@gmail.com, festevam@gmail.com,
        gregory.clement@bootlin.com, allison@lohutok.net,
        linux@armlinux.org.uk, krzk@kernel.org, haojian.zhuang@gmail.com,
        bgolaszewski@baylibre.com, tony@atomide.com, mingo@redhat.com,
        linux-imx@nxp.com, yhs@fb.com, sebastian.hesselbarth@gmail.com,
        illusionist.neo@gmail.com, jason@lakedaemon.net,
        liviu.dudau@arm.com, s.hauer@pengutronix.de, acme@kernel.org,
        lkundrak@v3.sk, robert.jarzmik@free.fr, dmg@turingmachine.org,
        swinslow@gmail.com, namhyung@kernel.org, tglx@linutronix.de,
        linux-omap@vger.kernel.org, alexander.sverdlin@gmail.com,
        linux-arm-kernel@lists.infradead.org, info@metux.net,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        alexander.shishkin@linux.intel.com, hsweeten@visionengravers.com,
        kgene@kernel.org, kernel@pengutronix.de, sudeep.holla@arm.com,
        bpf@vger.kernel.org, shawnguo@kernel.org, kafai@fb.com,
        daniel@zonque.org
Subject: [PATCH 15/15] ARM: vfp: cleanup cppcheck shifting errors
Date:   Sun, 23 Jun 2019 22:13:13 +0700
Message-Id: <20190623151313.970-16-tranmanphong@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190623151313.970-1-tranmanphong@gmail.com>
References: <20190623151313.970-1-tranmanphong@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[arch/arm/vfp/vfpdouble.c:397]: (error) Shifting signed 32-bit value by
31 bits is undefined behaviour
[arch/arm/vfp/vfpdouble.c:407]: (error) Shifting signed 32-bit value by
31 bits is undefined behaviour
[arch/arm/vfp/vfpmodule.c:263]: (error) Shifting signed 32-bit value by
31 bits is undefined behaviour
[arch/arm/vfp/vfpmodule.c:264]: (error) Shifting signed 32-bit value by
31 bits is undefined behaviour
[arch/arm/vfp/vfpsingle.c:441]: (error) Shifting signed 32-bit value by
31 bits is undefined behaviour
[arch/arm/vfp/vfpsingle.c:451]: (error) Shifting signed 32-bit value by
31 bits is undefined behaviour

Signed-off-by: Phong Tran <tranmanphong@gmail.com>
---
 arch/arm/vfp/vfpinstr.h | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/arm/vfp/vfpinstr.h b/arch/arm/vfp/vfpinstr.h
index 38dc154e39ff..377ab0ced8d8 100644
--- a/arch/arm/vfp/vfpinstr.h
+++ b/arch/arm/vfp/vfpinstr.h
@@ -8,8 +8,8 @@
  * VFP instruction masks.
  */
 #define INST_CPRTDO(inst)	(((inst) & 0x0f000000) == 0x0e000000)
-#define INST_CPRT(inst)		((inst) & (1 << 4))
-#define INST_CPRT_L(inst)	((inst) & (1 << 20))
+#define INST_CPRT(inst)		((inst) & (1U << 4))
+#define INST_CPRT_L(inst)	((inst) & (1U << 20))
 #define INST_CPRT_Rd(inst)	(((inst) & (15 << 12)) >> 12)
 #define INST_CPRT_OP(inst)	(((inst) >> 21) & 7)
 #define INST_CPNUM(inst)	((inst) & 0xf00)
@@ -27,7 +27,7 @@
 #define FOP_FDIV	(0x00800000)
 #define FOP_EXT		(0x00b00040)
 
-#define FOP_TO_IDX(inst)	((inst & 0x00b00000) >> 20 | (inst & (1 << 6)) >> 4)
+#define FOP_TO_IDX(inst)	((inst & 0x00b00000) >> 20 | (inst & (1U << 6)) >> 4)
 
 #define FEXT_MASK	(0x000f0080)
 #define FEXT_FCPY	(0x00000000)
@@ -46,21 +46,21 @@
 #define FEXT_FTOSI	(0x000d0000)
 #define FEXT_FTOSIZ	(0x000d0080)
 
-#define FEXT_TO_IDX(inst)	((inst & 0x000f0000) >> 15 | (inst & (1 << 7)) >> 7)
+#define FEXT_TO_IDX(inst)	((inst & 0x000f0000) >> 15 | (inst & (1U << 7)) >> 7)
 
-#define vfp_get_sd(inst)	((inst & 0x0000f000) >> 11 | (inst & (1 << 22)) >> 22)
-#define vfp_get_dd(inst)	((inst & 0x0000f000) >> 12 | (inst & (1 << 22)) >> 18)
-#define vfp_get_sm(inst)	((inst & 0x0000000f) << 1 | (inst & (1 << 5)) >> 5)
-#define vfp_get_dm(inst)	((inst & 0x0000000f) | (inst & (1 << 5)) >> 1)
-#define vfp_get_sn(inst)	((inst & 0x000f0000) >> 15 | (inst & (1 << 7)) >> 7)
-#define vfp_get_dn(inst)	((inst & 0x000f0000) >> 16 | (inst & (1 << 7)) >> 3)
+#define vfp_get_sd(inst)	((inst & 0x0000f000) >> 11 | (inst & (1U << 22)) >> 22)
+#define vfp_get_dd(inst)	((inst & 0x0000f000) >> 12 | (inst & (1U << 22)) >> 18)
+#define vfp_get_sm(inst)	((inst & 0x0000000f) << 1 | (inst & (1U << 5)) >> 5)
+#define vfp_get_dm(inst)	((inst & 0x0000000f) | (inst & (1U << 5)) >> 1)
+#define vfp_get_sn(inst)	((inst & 0x000f0000) >> 15 | (inst & (1U << 7)) >> 7)
+#define vfp_get_dn(inst)	((inst & 0x000f0000) >> 16 | (inst & (1U << 7)) >> 3)
 
 #define vfp_single(inst)	(((inst) & 0x0000f00) == 0xa00)
 
-#define FPSCR_N	(1 << 31)
-#define FPSCR_Z	(1 << 30)
-#define FPSCR_C (1 << 29)
-#define FPSCR_V	(1 << 28)
+#define FPSCR_N	(1U << 31)
+#define FPSCR_Z	(1U << 30)
+#define FPSCR_C (1U << 29)
+#define FPSCR_V	(1U << 28)
 
 /*
  * Since we aren't building with -mfpu=vfp, we need to code
-- 
2.11.0

