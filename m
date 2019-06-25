Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFBEA52188
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 06:04:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727766AbfFYEEt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 00:04:49 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:37250 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727540AbfFYEEt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 00:04:49 -0400
Received: by mail-pf1-f196.google.com with SMTP id 19so8727889pfa.4;
        Mon, 24 Jun 2019 21:04:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=F8Kb4z8RdLx6raUcS0p8FRcOvdw1X96ihV1Yk72nI3A=;
        b=gPb6jlDz4n/tvBurH30VLZbX0zlrb2hVHD6iZgQ/n3eTChM21RfGQJNr9Ijsjzmy0O
         jHmtQK8vIVWSZNlL6jCO3cYqh2EPpy35W977XVJyor8/4MW475rQQyV/ObOzarTgsHmY
         t2mqSrk/k2p/wlzaw4IRpXQdjFaQoHWqucfYM3MM2b+M8UIn3pnY8E8m+mRpI/Igb7Np
         dSybFFhRgaKFrs/64ZxAvB6OvV5FSxxlmONXBpSO4x+eVTKVobAXA0PNkSvQJV9dyi9L
         cmvwu3W1rWM7/nVeVfK1GlvJ1L8iiX3IxDfQ50+LA0xtxjcry9G6bUYrYlJQKIptdRDC
         FExQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=F8Kb4z8RdLx6raUcS0p8FRcOvdw1X96ihV1Yk72nI3A=;
        b=fGUdMl20rFFoP0eq5AKJDKV5rr7LoVcJev7C5dqzKSTGh0mQD73noZ6wxmMxz0bgew
         COqA3O61kZ/d3KEhJ0isrxZMA4dtQmfR2p/wIk4Cy0TdMC0uTbNy4xvCDie/2Kpd/qcV
         mRdZXwtSxaJp62pLgnjp4ZjKvp8+ohAIbMYLeS1Zwd3dLfiLQCiZ3RIl0HJ5b5EwNvSH
         /F80483WBzanS4UcQd+pqxZE427Rz7fIxgutEEUZbpfAn5BensEXD5oWNaj5CqgUCgGB
         3Uy5H/C6Qe/GoLzKCHxe5wBjY+hTqtaBKamH7uZwIwzneJpMHQM01v0xneziv3+lRC7L
         DTHg==
X-Gm-Message-State: APjAAAX3b7YnBfY9uiGvZANDos1OFHGNYgFACwY7Kg+jKHk6r5uNllZ5
        9JYn1sxb3toKL6v9+XivTkE=
X-Google-Smtp-Source: APXvYqwc4EoRoMUH73TQF3bNRPhcxoElD/rkwtHN5L7evWVM75uoM8ukEdrMmgLzEbhjYHGjDiICVQ==
X-Received: by 2002:a63:d4c:: with SMTP id 12mr8614724pgn.30.1561435488268;
        Mon, 24 Jun 2019 21:04:48 -0700 (PDT)
Received: from debian.net.fpt ([58.187.168.105])
        by smtp.gmail.com with ESMTPSA id b24sm12408944pfd.98.2019.06.24.21.04.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 21:04:47 -0700 (PDT)
From:   Phong Tran <tranmanphong@gmail.com>
To:     tranmanphong@gmail.com
Cc:     acme@kernel.org, alexander.shishkin@linux.intel.com,
        alexander.sverdlin@gmail.com, allison@lohutok.net, andrew@lunn.ch,
        ast@kernel.org, bgolaszewski@baylibre.com, bpf@vger.kernel.org,
        daniel@iogearbox.net, daniel@zonque.org, dmg@turingmachine.org,
        festevam@gmail.com, gerg@uclinux.org, gregkh@linuxfoundation.org,
        gregory.clement@bootlin.com, haojian.zhuang@gmail.com,
        hsweeten@visionengravers.com, illusionist.neo@gmail.com,
        info@metux.net, jason@lakedaemon.net, jolsa@redhat.com,
        kafai@fb.com, kernel@pengutronix.de, kgene@kernel.org,
        krzk@kernel.org, kstewart@linuxfoundation.org,
        linux-arm-kernel@lists.infradead.org, linux-imx@nxp.com,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux@armlinux.org.uk,
        liviu.dudau@arm.com, lkundrak@v3.sk, lorenzo.pieralisi@arm.com,
        mark.rutland@arm.com, mingo@redhat.com, namhyung@kernel.org,
        netdev@vger.kernel.org, nsekhar@ti.com, peterz@infradead.org,
        robert.jarzmik@free.fr, s.hauer@pengutronix.de,
        sebastian.hesselbarth@gmail.com, shawnguo@kernel.org,
        songliubraving@fb.com, sudeep.holla@arm.com, swinslow@gmail.com,
        tglx@linutronix.de, tony@atomide.com, will@kernel.org, yhs@fb.com
Subject: [PATCH V3 03/15] ARM: ep93xx: cleanup cppcheck shifting errors
Date:   Tue, 25 Jun 2019 11:03:44 +0700
Message-Id: <20190625040356.27473-4-tranmanphong@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190625040356.27473-1-tranmanphong@gmail.com>
References: <20190624135105.15579-1-tranmanphong@gmail.com>
 <20190625040356.27473-1-tranmanphong@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is error from cppcheck tool
"Shifting signed 32-bit value by 31 bits is undefined behaviour errors"
change to use BIT() marco for improvement.

Signed-off-by: Phong Tran <tranmanphong@gmail.com>
Acked-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Acked-by: Alexander Sverdlin <alexander.sverdlin@gmail.com>
---
 arch/arm/mach-ep93xx/soc.h | 134 ++++++++++++++++++++++-----------------------
 1 file changed, 67 insertions(+), 67 deletions(-)

diff --git a/arch/arm/mach-ep93xx/soc.h b/arch/arm/mach-ep93xx/soc.h
index f2dace1c9154..e580a22ad071 100644
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
+#define EP93XX_SYSCON_PWRCNT_FIR_EN	BIT(31)
+#define EP93XX_SYSCON_PWRCNT_UARTBAUD	BIT(29)
+#define EP93XX_SYSCON_PWRCNT_USH_EN	BIT(28)
+#define EP93XX_SYSCON_PWRCNT_DMA_M2M1	BIT(27)
+#define EP93XX_SYSCON_PWRCNT_DMA_M2M0	BIT(26)
+#define EP93XX_SYSCON_PWRCNT_DMA_M2P8	BIT(25)
+#define EP93XX_SYSCON_PWRCNT_DMA_M2P9	BIT(24)
+#define EP93XX_SYSCON_PWRCNT_DMA_M2P6	BIT(23)
+#define EP93XX_SYSCON_PWRCNT_DMA_M2P7	BIT(22)
+#define EP93XX_SYSCON_PWRCNT_DMA_M2P4	BIT(21)
+#define EP93XX_SYSCON_PWRCNT_DMA_M2P5	BIT(20)
+#define EP93XX_SYSCON_PWRCNT_DMA_M2P2	BIT(19)
+#define EP93XX_SYSCON_PWRCNT_DMA_M2P3	BIT(18)
+#define EP93XX_SYSCON_PWRCNT_DMA_M2P0	BIT(17)
+#define EP93XX_SYSCON_PWRCNT_DMA_M2P1	BIT(16)
 #define EP93XX_SYSCON_HALT		EP93XX_SYSCON_REG(0x08)
 #define EP93XX_SYSCON_STANDBY		EP93XX_SYSCON_REG(0x0c)
 #define EP93XX_SYSCON_CLKSET1		EP93XX_SYSCON_REG(0x20)
-#define EP93XX_SYSCON_CLKSET1_NBYP1	(1<<23)
+#define EP93XX_SYSCON_CLKSET1_NBYP1	BIT(23)
 #define EP93XX_SYSCON_CLKSET2		EP93XX_SYSCON_REG(0x24)
-#define EP93XX_SYSCON_CLKSET2_NBYP2	(1<<19)
-#define EP93XX_SYSCON_CLKSET2_PLL2_EN	(1<<18)
+#define EP93XX_SYSCON_CLKSET2_NBYP2	BIT(19)
+#define EP93XX_SYSCON_CLKSET2_PLL2_EN	BIT(18)
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
+#define EP93XX_SYSCON_DEVCFG_SWRST	BIT(31)
+#define EP93XX_SYSCON_DEVCFG_D1ONG	BIT(30)
+#define EP93XX_SYSCON_DEVCFG_D0ONG	BIT(29)
+#define EP93XX_SYSCON_DEVCFG_IONU2	BIT(28)
+#define EP93XX_SYSCON_DEVCFG_GONK	BIT(27)
+#define EP93XX_SYSCON_DEVCFG_TONG	BIT(26)
+#define EP93XX_SYSCON_DEVCFG_MONG	BIT(25)
+#define EP93XX_SYSCON_DEVCFG_U3EN	BIT(24)
+#define EP93XX_SYSCON_DEVCFG_CPENA	BIT(23)
+#define EP93XX_SYSCON_DEVCFG_A2ONG	BIT(22)
+#define EP93XX_SYSCON_DEVCFG_A1ONG	BIT(21)
+#define EP93XX_SYSCON_DEVCFG_U2EN	BIT(20)
+#define EP93XX_SYSCON_DEVCFG_EXVC	BIT(19)
+#define EP93XX_SYSCON_DEVCFG_U1EN	BIT(18)
+#define EP93XX_SYSCON_DEVCFG_TIN	BIT(17)
+#define EP93XX_SYSCON_DEVCFG_HC3IN	BIT(15)
+#define EP93XX_SYSCON_DEVCFG_HC3EN	BIT(14)
+#define EP93XX_SYSCON_DEVCFG_HC1IN	BIT(13)
+#define EP93XX_SYSCON_DEVCFG_HC1EN	BIT(12)
+#define EP93XX_SYSCON_DEVCFG_HONIDE	BIT(11)
+#define EP93XX_SYSCON_DEVCFG_GONIDE	BIT(10)
+#define EP93XX_SYSCON_DEVCFG_PONG	BIT(9)
+#define EP93XX_SYSCON_DEVCFG_EONIDE	BIT(8)
+#define EP93XX_SYSCON_DEVCFG_I2SONSSP	BIT(7)
+#define EP93XX_SYSCON_DEVCFG_I2SONAC97	BIT(6)
+#define EP93XX_SYSCON_DEVCFG_RASONP3	BIT(4)
+#define EP93XX_SYSCON_DEVCFG_RAS	BIT(3)
+#define EP93XX_SYSCON_DEVCFG_ADCPD	BIT(2)
+#define EP93XX_SYSCON_DEVCFG_KEYS	BIT(1)
+#define EP93XX_SYSCON_DEVCFG_SHENA	BIT(0)
 #define EP93XX_SYSCON_VIDCLKDIV		EP93XX_SYSCON_REG(0x84)
-#define EP93XX_SYSCON_CLKDIV_ENABLE	(1<<15)
-#define EP93XX_SYSCON_CLKDIV_ESEL	(1<<14)
-#define EP93XX_SYSCON_CLKDIV_PSEL	(1<<13)
+#define EP93XX_SYSCON_CLKDIV_ENABLE	BIT(15)
+#define EP93XX_SYSCON_CLKDIV_ESEL	BIT(14)
+#define EP93XX_SYSCON_CLKDIV_PSEL	BIT(13)
 #define EP93XX_SYSCON_CLKDIV_PDIV_SHIFT	8
 #define EP93XX_SYSCON_I2SCLKDIV		EP93XX_SYSCON_REG(0x8c)
-#define EP93XX_SYSCON_I2SCLKDIV_SENA	(1<<31)
-#define EP93XX_SYSCON_I2SCLKDIV_ORIDE   (1<<29)
-#define EP93XX_SYSCON_I2SCLKDIV_SPOL	(1<<19)
-#define EP93XX_I2SCLKDIV_SDIV		(1 << 16)
+#define EP93XX_SYSCON_I2SCLKDIV_SENA	BIT(31)
+#define EP93XX_SYSCON_I2SCLKDIV_ORIDE   BIT(29)
+#define EP93XX_SYSCON_I2SCLKDIV_SPOL	BIT(19)
+#define EP93XX_I2SCLKDIV_SDIV		BIT(16)
 #define EP93XX_I2SCLKDIV_LRDIV32	(0 << 17)
 #define EP93XX_I2SCLKDIV_LRDIV64	(1 << 17)
 #define EP93XX_I2SCLKDIV_LRDIV128	(2 << 17)
 #define EP93XX_I2SCLKDIV_LRDIV_MASK	(3 << 17)
 #define EP93XX_SYSCON_KEYTCHCLKDIV	EP93XX_SYSCON_REG(0x90)
-#define EP93XX_SYSCON_KEYTCHCLKDIV_TSEN	(1<<31)
-#define EP93XX_SYSCON_KEYTCHCLKDIV_ADIV	(1<<16)
-#define EP93XX_SYSCON_KEYTCHCLKDIV_KEN	(1<<15)
-#define EP93XX_SYSCON_KEYTCHCLKDIV_KDIV	(1<<0)
+#define EP93XX_SYSCON_KEYTCHCLKDIV_TSEN	BIT(31)
+#define EP93XX_SYSCON_KEYTCHCLKDIV_ADIV	BIT(16)
+#define EP93XX_SYSCON_KEYTCHCLKDIV_KEN	BIT(15)
+#define EP93XX_SYSCON_KEYTCHCLKDIV_KDIV	BIT(0)
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
+#define EP93XX_SYSCON_SYSCFG_SBOOT	BIT(8)
+#define EP93XX_SYSCON_SYSCFG_LCSN7	BIT(7)
+#define EP93XX_SYSCON_SYSCFG_LCSN6	BIT(6)
+#define EP93XX_SYSCON_SYSCFG_LASDO	BIT(5)
+#define EP93XX_SYSCON_SYSCFG_LEEDA	BIT(4)
+#define EP93XX_SYSCON_SYSCFG_LEECLK	BIT(3)
+#define EP93XX_SYSCON_SYSCFG_LCSN2	BIT(1)
+#define EP93XX_SYSCON_SYSCFG_LCSN1	BIT(0)
 #define EP93XX_SYSCON_SWLOCK		EP93XX_SYSCON_REG(0xc0)
 
 /* EP93xx System Controller software locked register write */
-- 
2.11.0

