Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAABC4FC2E
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 17:14:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbfFWPOj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 11:14:39 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:42090 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726753AbfFWPOj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jun 2019 11:14:39 -0400
Received: by mail-pf1-f193.google.com with SMTP id q10so6044773pff.9;
        Sun, 23 Jun 2019 08:14:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=gM8H3IffM8SGtYj5uFFMCYVqFOOwzVA9sNqt06xet/s=;
        b=f8qsifsiXhoPGnIabzNIsYq+PNZoDrTrdw2chhAu9ntEiJrANhfzGCJDEkggkWKiYs
         3IuFlUN0jZn8r4ybzVDqBmORpKAY/CJSvHU+QBMYca9qGlUbThkdOrskOEk4bFaQN/Du
         i02HNK6O9vJ8iqXh74k9Puvth9WlEgWNCU18XmYkKNTf/LSBOGLr5n6Ycv0rb6fi1fIl
         HvjoleAeX9oGk/4NaR9ARBa66lTJOZa9V6QmECFiC5aGYxbxof7PioxQBN6fZFY+PT6x
         AtGL8aZdeOEMoe6rmDczfs/bLPHQRiGEdau9p4KzRa4Km2H8LqIiiuF2LHpnXb12PVs+
         6HUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=gM8H3IffM8SGtYj5uFFMCYVqFOOwzVA9sNqt06xet/s=;
        b=NyjWMBKiz3Xg5TJr5MueByzomJI/oEH0+4gICfcZdpd6vI/UHwp1vjxj8wCRbhSHQC
         qWmx/RllwiX5o9r0WL3l1EEM6JEh7Wq88XOs6ta4HMDet7seY4uKRBXqu5m1uLkbU9bI
         +Xp1Sa8xWR50KSAlIRhrHpZxUTwDKFDt65pyCXS3UB3Gvb3J9CYeBG6dpluBvgAI6P74
         8ThcYRlHzWhj4QKlYghzF5Obfe5gnZu3Hy7OgCruq185reL8tTnOfwNfPb1cV10SR50f
         bx6MgV36J1DmnexM7vUCseXkm8CY5H8RoBBoHIcJJ4xqFa8VL2Ne9f4UTmJKNUnAjjbE
         fs6Q==
X-Gm-Message-State: APjAAAUAjogs0/nuCuV+TexrW1MM87E6ZcQZeKO/eMA/lyblzt09PuOQ
        156fdhRyclYVgytO1103eRQ=
X-Google-Smtp-Source: APXvYqxF6GThj5npM55hyOaeCviGC3T4QwoYdtidhncqXWe6xy8tbu4i5N7BhYi8M781WZMmVBFmrg==
X-Received: by 2002:a63:d551:: with SMTP id v17mr28960590pgi.365.1561302877926;
        Sun, 23 Jun 2019 08:14:37 -0700 (PDT)
Received: from debian.net.fpt ([1.55.47.94])
        by smtp.gmail.com with ESMTPSA id p6sm8329194pgs.77.2019.06.23.08.14.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 23 Jun 2019 08:14:37 -0700 (PDT)
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
Subject: [PATCH 03/15] ARM: ep93xx: cleanup cppcheck shifting errors
Date:   Sun, 23 Jun 2019 22:13:01 +0700
Message-Id: <20190623151313.970-4-tranmanphong@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190623151313.970-1-tranmanphong@gmail.com>
References: <20190623151313.970-1-tranmanphong@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[arch/arm/mach-ep93xx/clock.c:102]: (error) Shifting signed 32-bit value
by 31 bits is undefined behaviour
[arch/arm/mach-ep93xx/clock.c:132]: (error) Shifting signed 32-bit value
by 31 bits is undefined behaviour
[arch/arm/mach-ep93xx/clock.c:140]: (error) Shifting signed 32-bit value
by 31 bits is undefined behaviour
[arch/arm/mach-ep93xx/core.c:1001]: (error) Shifting signed 32-bit value
by 31 bits is undefined behaviour
[arch/arm/mach-ep93xx/core.c:1002]: (error) Shifting signed 32-bit value
by 31 bits is undefined behaviour

Signed-off-by: Phong Tran <tranmanphong@gmail.com>
---
 arch/arm/mach-ep93xx/soc.h | 132 ++++++++++++++++++++++-----------------------
 1 file changed, 66 insertions(+), 66 deletions(-)

diff --git a/arch/arm/mach-ep93xx/soc.h b/arch/arm/mach-ep93xx/soc.h
index f2dace1c9154..831ea5266281 100644
--- a/arch/arm/mach-ep93xx/soc.h
+++ b/arch/arm/mach-ep93xx/soc.h
@@ -109,89 +109,89 @@
 #define EP93XX_SYSCON_REG(x)		(EP93XX_SYSCON_BASE + (x))
 #define EP93XX_SYSCON_POWER_STATE	EP93XX_SYSCON_REG(0x00)
 #define EP93XX_SYSCON_PWRCNT		EP93XX_SYSCON_REG(0x04)
-#define EP93XX_SYSCON_PWRCNT_FIR_EN	(1<<31)
-#define EP93XX_SYSCON_PWRCNT_UARTBAUD	(1<<29)
-#define EP93XX_SYSCON_PWRCNT_USH_EN	(1<<28)
-#define EP93XX_SYSCON_PWRCNT_DMA_M2M1	(1<<27)
-#define EP93XX_SYSCON_PWRCNT_DMA_M2M0	(1<<26)
-#define EP93XX_SYSCON_PWRCNT_DMA_M2P8	(1<<25)
-#define EP93XX_SYSCON_PWRCNT_DMA_M2P9	(1<<24)
-#define EP93XX_SYSCON_PWRCNT_DMA_M2P6	(1<<23)
-#define EP93XX_SYSCON_PWRCNT_DMA_M2P7	(1<<22)
-#define EP93XX_SYSCON_PWRCNT_DMA_M2P4	(1<<21)
-#define EP93XX_SYSCON_PWRCNT_DMA_M2P5	(1<<20)
-#define EP93XX_SYSCON_PWRCNT_DMA_M2P2	(1<<19)
-#define EP93XX_SYSCON_PWRCNT_DMA_M2P3	(1<<18)
-#define EP93XX_SYSCON_PWRCNT_DMA_M2P0	(1<<17)
-#define EP93XX_SYSCON_PWRCNT_DMA_M2P1	(1<<16)
+#define EP93XX_SYSCON_PWRCNT_FIR_EN	(1U<<31)
+#define EP93XX_SYSCON_PWRCNT_UARTBAUD	(1U<<29)
+#define EP93XX_SYSCON_PWRCNT_USH_EN	(1U<<28)
+#define EP93XX_SYSCON_PWRCNT_DMA_M2M1	(1U<<27)
+#define EP93XX_SYSCON_PWRCNT_DMA_M2M0	(1U<<26)
+#define EP93XX_SYSCON_PWRCNT_DMA_M2P8	(1U<<25)
+#define EP93XX_SYSCON_PWRCNT_DMA_M2P9	(1U<<24)
+#define EP93XX_SYSCON_PWRCNT_DMA_M2P6	(1U<<23)
+#define EP93XX_SYSCON_PWRCNT_DMA_M2P7	(1U<<22)
+#define EP93XX_SYSCON_PWRCNT_DMA_M2P4	(1U<<21)
+#define EP93XX_SYSCON_PWRCNT_DMA_M2P5	(1U<<20)
+#define EP93XX_SYSCON_PWRCNT_DMA_M2P2	(1U<<19)
+#define EP93XX_SYSCON_PWRCNT_DMA_M2P3	(1U<<18)
+#define EP93XX_SYSCON_PWRCNT_DMA_M2P0	(1U<<17)
+#define EP93XX_SYSCON_PWRCNT_DMA_M2P1	(1U<<16)
 #define EP93XX_SYSCON_HALT		EP93XX_SYSCON_REG(0x08)
 #define EP93XX_SYSCON_STANDBY		EP93XX_SYSCON_REG(0x0c)
 #define EP93XX_SYSCON_CLKSET1		EP93XX_SYSCON_REG(0x20)
-#define EP93XX_SYSCON_CLKSET1_NBYP1	(1<<23)
+#define EP93XX_SYSCON_CLKSET1_NBYP1	(1U<<23)
 #define EP93XX_SYSCON_CLKSET2		EP93XX_SYSCON_REG(0x24)
-#define EP93XX_SYSCON_CLKSET2_NBYP2	(1<<19)
-#define EP93XX_SYSCON_CLKSET2_PLL2_EN	(1<<18)
+#define EP93XX_SYSCON_CLKSET2_NBYP2	(1U<<19)
+#define EP93XX_SYSCON_CLKSET2_PLL2_EN	(1U<<18)
 #define EP93XX_SYSCON_DEVCFG		EP93XX_SYSCON_REG(0x80)
-#define EP93XX_SYSCON_DEVCFG_SWRST	(1<<31)
-#define EP93XX_SYSCON_DEVCFG_D1ONG	(1<<30)
-#define EP93XX_SYSCON_DEVCFG_D0ONG	(1<<29)
-#define EP93XX_SYSCON_DEVCFG_IONU2	(1<<28)
-#define EP93XX_SYSCON_DEVCFG_GONK	(1<<27)
-#define EP93XX_SYSCON_DEVCFG_TONG	(1<<26)
-#define EP93XX_SYSCON_DEVCFG_MONG	(1<<25)
-#define EP93XX_SYSCON_DEVCFG_U3EN	(1<<24)
-#define EP93XX_SYSCON_DEVCFG_CPENA	(1<<23)
-#define EP93XX_SYSCON_DEVCFG_A2ONG	(1<<22)
-#define EP93XX_SYSCON_DEVCFG_A1ONG	(1<<21)
-#define EP93XX_SYSCON_DEVCFG_U2EN	(1<<20)
-#define EP93XX_SYSCON_DEVCFG_EXVC	(1<<19)
-#define EP93XX_SYSCON_DEVCFG_U1EN	(1<<18)
-#define EP93XX_SYSCON_DEVCFG_TIN	(1<<17)
-#define EP93XX_SYSCON_DEVCFG_HC3IN	(1<<15)
-#define EP93XX_SYSCON_DEVCFG_HC3EN	(1<<14)
-#define EP93XX_SYSCON_DEVCFG_HC1IN	(1<<13)
-#define EP93XX_SYSCON_DEVCFG_HC1EN	(1<<12)
-#define EP93XX_SYSCON_DEVCFG_HONIDE	(1<<11)
-#define EP93XX_SYSCON_DEVCFG_GONIDE	(1<<10)
-#define EP93XX_SYSCON_DEVCFG_PONG	(1<<9)
-#define EP93XX_SYSCON_DEVCFG_EONIDE	(1<<8)
-#define EP93XX_SYSCON_DEVCFG_I2SONSSP	(1<<7)
-#define EP93XX_SYSCON_DEVCFG_I2SONAC97	(1<<6)
-#define EP93XX_SYSCON_DEVCFG_RASONP3	(1<<4)
-#define EP93XX_SYSCON_DEVCFG_RAS	(1<<3)
-#define EP93XX_SYSCON_DEVCFG_ADCPD	(1<<2)
-#define EP93XX_SYSCON_DEVCFG_KEYS	(1<<1)
-#define EP93XX_SYSCON_DEVCFG_SHENA	(1<<0)
+#define EP93XX_SYSCON_DEVCFG_SWRST	(1U<<31)
+#define EP93XX_SYSCON_DEVCFG_D1ONG	(1U<<30)
+#define EP93XX_SYSCON_DEVCFG_D0ONG	(1U<<29)
+#define EP93XX_SYSCON_DEVCFG_IONU2	(1U<<28)
+#define EP93XX_SYSCON_DEVCFG_GONK	(1U<<27)
+#define EP93XX_SYSCON_DEVCFG_TONG	(1U<<26)
+#define EP93XX_SYSCON_DEVCFG_MONG	(1U<<25)
+#define EP93XX_SYSCON_DEVCFG_U3EN	(1U<<24)
+#define EP93XX_SYSCON_DEVCFG_CPENA	(1U<<23)
+#define EP93XX_SYSCON_DEVCFG_A2ONG	(1U<<22)
+#define EP93XX_SYSCON_DEVCFG_A1ONG	(1U<<21)
+#define EP93XX_SYSCON_DEVCFG_U2EN	(1U<<20)
+#define EP93XX_SYSCON_DEVCFG_EXVC	(1U<<19)
+#define EP93XX_SYSCON_DEVCFG_U1EN	(1U<<18)
+#define EP93XX_SYSCON_DEVCFG_TIN	(1U<<17)
+#define EP93XX_SYSCON_DEVCFG_HC3IN	(1U<<15)
+#define EP93XX_SYSCON_DEVCFG_HC3EN	(1U<<14)
+#define EP93XX_SYSCON_DEVCFG_HC1IN	(1U<<13)
+#define EP93XX_SYSCON_DEVCFG_HC1EN	(1U<<12)
+#define EP93XX_SYSCON_DEVCFG_HONIDE	(1U<<11)
+#define EP93XX_SYSCON_DEVCFG_GONIDE	(1U<<10)
+#define EP93XX_SYSCON_DEVCFG_PONG	(1U<<9)
+#define EP93XX_SYSCON_DEVCFG_EONIDE	(1U<<8)
+#define EP93XX_SYSCON_DEVCFG_I2SONSSP	(1U<<7)
+#define EP93XX_SYSCON_DEVCFG_I2SONAC97	(1U<<6)
+#define EP93XX_SYSCON_DEVCFG_RASONP3	(1U<<4)
+#define EP93XX_SYSCON_DEVCFG_RAS	(1U<<3)
+#define EP93XX_SYSCON_DEVCFG_ADCPD	(1U<<2)
+#define EP93XX_SYSCON_DEVCFG_KEYS	(1U<<1)
+#define EP93XX_SYSCON_DEVCFG_SHENA	(1U<<0)
 #define EP93XX_SYSCON_VIDCLKDIV		EP93XX_SYSCON_REG(0x84)
-#define EP93XX_SYSCON_CLKDIV_ENABLE	(1<<15)
-#define EP93XX_SYSCON_CLKDIV_ESEL	(1<<14)
-#define EP93XX_SYSCON_CLKDIV_PSEL	(1<<13)
+#define EP93XX_SYSCON_CLKDIV_ENABLE	(1U<<15)
+#define EP93XX_SYSCON_CLKDIV_ESEL	(1U<<14)
+#define EP93XX_SYSCON_CLKDIV_PSEL	(1U<<13)
 #define EP93XX_SYSCON_CLKDIV_PDIV_SHIFT	8
 #define EP93XX_SYSCON_I2SCLKDIV		EP93XX_SYSCON_REG(0x8c)
-#define EP93XX_SYSCON_I2SCLKDIV_SENA	(1<<31)
-#define EP93XX_SYSCON_I2SCLKDIV_ORIDE   (1<<29)
-#define EP93XX_SYSCON_I2SCLKDIV_SPOL	(1<<19)
+#define EP93XX_SYSCON_I2SCLKDIV_SENA	(1U<<31)
+#define EP93XX_SYSCON_I2SCLKDIV_ORIDE   (1U<<29)
+#define EP93XX_SYSCON_I2SCLKDIV_SPOL	(1U<<19)
 #define EP93XX_I2SCLKDIV_SDIV		(1 << 16)
 #define EP93XX_I2SCLKDIV_LRDIV32	(0 << 17)
 #define EP93XX_I2SCLKDIV_LRDIV64	(1 << 17)
 #define EP93XX_I2SCLKDIV_LRDIV128	(2 << 17)
 #define EP93XX_I2SCLKDIV_LRDIV_MASK	(3 << 17)
 #define EP93XX_SYSCON_KEYTCHCLKDIV	EP93XX_SYSCON_REG(0x90)
-#define EP93XX_SYSCON_KEYTCHCLKDIV_TSEN	(1<<31)
-#define EP93XX_SYSCON_KEYTCHCLKDIV_ADIV	(1<<16)
-#define EP93XX_SYSCON_KEYTCHCLKDIV_KEN	(1<<15)
-#define EP93XX_SYSCON_KEYTCHCLKDIV_KDIV	(1<<0)
+#define EP93XX_SYSCON_KEYTCHCLKDIV_TSEN	(1U<<31)
+#define EP93XX_SYSCON_KEYTCHCLKDIV_ADIV	(1U<<16)
+#define EP93XX_SYSCON_KEYTCHCLKDIV_KEN	(1U<<15)
+#define EP93XX_SYSCON_KEYTCHCLKDIV_KDIV	(1U<<0)
 #define EP93XX_SYSCON_SYSCFG		EP93XX_SYSCON_REG(0x9c)
 #define EP93XX_SYSCON_SYSCFG_REV_MASK	(0xf0000000)
 #define EP93XX_SYSCON_SYSCFG_REV_SHIFT	(28)
-#define EP93XX_SYSCON_SYSCFG_SBOOT	(1<<8)
-#define EP93XX_SYSCON_SYSCFG_LCSN7	(1<<7)
-#define EP93XX_SYSCON_SYSCFG_LCSN6	(1<<6)
-#define EP93XX_SYSCON_SYSCFG_LASDO	(1<<5)
-#define EP93XX_SYSCON_SYSCFG_LEEDA	(1<<4)
-#define EP93XX_SYSCON_SYSCFG_LEECLK	(1<<3)
-#define EP93XX_SYSCON_SYSCFG_LCSN2	(1<<1)
-#define EP93XX_SYSCON_SYSCFG_LCSN1	(1<<0)
+#define EP93XX_SYSCON_SYSCFG_SBOOT	(1U<<8)
+#define EP93XX_SYSCON_SYSCFG_LCSN7	(1U<<7)
+#define EP93XX_SYSCON_SYSCFG_LCSN6	(1U<<6)
+#define EP93XX_SYSCON_SYSCFG_LASDO	(1U<<5)
+#define EP93XX_SYSCON_SYSCFG_LEEDA	(1U<<4)
+#define EP93XX_SYSCON_SYSCFG_LEECLK	(1U<<3)
+#define EP93XX_SYSCON_SYSCFG_LCSN2	(1U<<1)
+#define EP93XX_SYSCON_SYSCFG_LCSN1	(1U<<0)
 #define EP93XX_SYSCON_SWLOCK		EP93XX_SYSCON_REG(0xc0)
 
 /* EP93xx System Controller software locked register write */
-- 
2.11.0

