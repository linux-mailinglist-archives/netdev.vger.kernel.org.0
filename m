Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A382A50C8C
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 15:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731527AbfFXNwa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 09:52:30 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:35967 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730409AbfFXNwa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 09:52:30 -0400
Received: by mail-pf1-f196.google.com with SMTP id r7so7567414pfl.3;
        Mon, 24 Jun 2019 06:52:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=h1v1yeC0QMHUW7XIxSk7vKPuYf5GRZmsxhrCxBvq8ko=;
        b=ozdciiqy8THpW2vDVeC/wiQrLo1XMtFRz3xqHetq7vl0HuoqF/5Q4zcP2d0MLFMPcW
         jqiB7PV6/TJ6AQ2weifcdaRK6Lhqin1yzgWvTtJUUUxaB4El3O3XS1gNtspYnBQDAD0n
         c1Np5N24XwRDgNbKI6qPb29AbURPIGECVqUbQYU0r+bPGw654fzb+ymmwxzC+rNdmZCQ
         mFPtwnkuzsvxPR2I9A/EcJtCKoALZKugTn30wAWEBuwkBYQW4Uv9KhCcrVb9Kb50K9xl
         RcI//+usHfNlMxUYxYlq7q0CS4tVPNoZXHI6zznJE8VV8vseV3qe9koxPim01M39AgdY
         cQfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=h1v1yeC0QMHUW7XIxSk7vKPuYf5GRZmsxhrCxBvq8ko=;
        b=e5yMr57f7Ox1LmkSi0J5jQOLjYj71QN4rN7VJbZtut1UxF0Rk0Z3KOqs38A0bOWl33
         y+pQTTQOXGEI+xXhr7nxYQUzA+Fp1W617e2zua5dBEul6rPWtZj2MGylfk7nf6iTvRjh
         jYngQV3ILVwrE/l4w4OTRLt/tpEZ6OAhMXYV7pjCQxa5Z/kGxysFnijI/Gya4elFgnpD
         lY5z150ICpAFr7ys4Vr6iJGkL65goNVJqxuk5Ko+cLUT2NEAcbg/3WhJETdItqaa9+yX
         i8SjGkXRu3pCOoC4Ss6M3I+EFnIjP5SIH4oRz2zbfTwI6ktU9Lqzfi6LSSyGlvDTGFoh
         iHKA==
X-Gm-Message-State: APjAAAWuHBvsYmVZeZGzHBIZniT8DtK2t2jTi8GIRE9JK10hdw9nYUbJ
        N3FLqCh9f4JO3MMzdDqnhGw=
X-Google-Smtp-Source: APXvYqykm0oj5zPB490LU7Sxla+Jm6HoDhom957xePsyJhpgGXC66lglkLRNG6Sc2Rinop4HT/9PQA==
X-Received: by 2002:a17:90a:bb01:: with SMTP id u1mr24530850pjr.92.1561384349488;
        Mon, 24 Jun 2019 06:52:29 -0700 (PDT)
Received: from debian.net.fpt ([58.187.168.105])
        by smtp.gmail.com with ESMTPSA id 85sm11187901pgb.52.2019.06.24.06.52.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 06:52:28 -0700 (PDT)
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
Subject: [PATCH V2 06/15] ARM: imx: cleanup cppcheck shifting errors
Date:   Mon, 24 Jun 2019 20:50:56 +0700
Message-Id: <20190624135105.15579-7-tranmanphong@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190624135105.15579-1-tranmanphong@gmail.com>
References: <20190623151313.970-1-tranmanphong@gmail.com>
 <20190624135105.15579-1-tranmanphong@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[arch/arm/mach-imx/iomux-mx3.h:93]: (error) Shifting signed 32-bit value
by 31 bits is undefined behaviour

Signed-off-by: Phong Tran <tranmanphong@gmail.com>
---
 arch/arm/mach-imx/iomux-mx3.h | 64 +++++++++++++++++++++----------------------
 1 file changed, 32 insertions(+), 32 deletions(-)

diff --git a/arch/arm/mach-imx/iomux-mx3.h b/arch/arm/mach-imx/iomux-mx3.h
index 99270a183d47..028b683866c3 100644
--- a/arch/arm/mach-imx/iomux-mx3.h
+++ b/arch/arm/mach-imx/iomux-mx3.h
@@ -59,38 +59,38 @@ enum iomux_pad_config {
  * various IOMUX general purpose functions
  */
 enum iomux_gp_func {
-	MUX_PGP_FIRI			= 1 << 0,
-	MUX_DDR_MODE			= 1 << 1,
-	MUX_PGP_CSPI_BB			= 1 << 2,
-	MUX_PGP_ATA_1			= 1 << 3,
-	MUX_PGP_ATA_2			= 1 << 4,
-	MUX_PGP_ATA_3			= 1 << 5,
-	MUX_PGP_ATA_4			= 1 << 6,
-	MUX_PGP_ATA_5			= 1 << 7,
-	MUX_PGP_ATA_6			= 1 << 8,
-	MUX_PGP_ATA_7			= 1 << 9,
-	MUX_PGP_ATA_8			= 1 << 10,
-	MUX_PGP_UH2			= 1 << 11,
-	MUX_SDCTL_CSD0_SEL		= 1 << 12,
-	MUX_SDCTL_CSD1_SEL		= 1 << 13,
-	MUX_CSPI1_UART3			= 1 << 14,
-	MUX_EXTDMAREQ2_MBX_SEL		= 1 << 15,
-	MUX_TAMPER_DETECT_EN		= 1 << 16,
-	MUX_PGP_USB_4WIRE		= 1 << 17,
-	MUX_PGP_USB_COMMON		= 1 << 18,
-	MUX_SDHC_MEMSTICK1		= 1 << 19,
-	MUX_SDHC_MEMSTICK2		= 1 << 20,
-	MUX_PGP_SPLL_BYP		= 1 << 21,
-	MUX_PGP_UPLL_BYP		= 1 << 22,
-	MUX_PGP_MSHC1_CLK_SEL		= 1 << 23,
-	MUX_PGP_MSHC2_CLK_SEL		= 1 << 24,
-	MUX_CSPI3_UART5_SEL		= 1 << 25,
-	MUX_PGP_ATA_9			= 1 << 26,
-	MUX_PGP_USB_SUSPEND		= 1 << 27,
-	MUX_PGP_USB_OTG_LOOPBACK	= 1 << 28,
-	MUX_PGP_USB_HS1_LOOPBACK	= 1 << 29,
-	MUX_PGP_USB_HS2_LOOPBACK	= 1 << 30,
-	MUX_CLKO_DDR_MODE		= 1 << 31,
+	MUX_PGP_FIRI			= BIT(0),
+	MUX_DDR_MODE			= BIT(1),
+	MUX_PGP_CSPI_BB			= BIT(2),
+	MUX_PGP_ATA_1			= BIT(3),
+	MUX_PGP_ATA_2			= BIT(4),
+	MUX_PGP_ATA_3			= BIT(5),
+	MUX_PGP_ATA_4			= BIT(6),
+	MUX_PGP_ATA_5			= BIT(7),
+	MUX_PGP_ATA_6			= BIT(8),
+	MUX_PGP_ATA_7			= BIT(9),
+	MUX_PGP_ATA_8			= BIT(10),
+	MUX_PGP_UH2			= BIT(11),
+	MUX_SDCTL_CSD0_SEL		= BIT(12),
+	MUX_SDCTL_CSD1_SEL		= BIT(13),
+	MUX_CSPI1_UART3			= BIT(14),
+	MUX_EXTDMAREQ2_MBX_SEL		= BIT(15),
+	MUX_TAMPER_DETECT_EN		= BIT(16),
+	MUX_PGP_USB_4WIRE		= BIT(17),
+	MUX_PGP_USB_COMMON		= BIT(18),
+	MUX_SDHC_MEMSTICK1		= BIT(19),
+	MUX_SDHC_MEMSTICK2		= BIT(20),
+	MUX_PGP_SPLL_BYP		= BIT(21),
+	MUX_PGP_UPLL_BYP		= BIT(22),
+	MUX_PGP_MSHC1_CLK_SEL		= BIT(23),
+	MUX_PGP_MSHC2_CLK_SEL		= BIT(24),
+	MUX_CSPI3_UART5_SEL		= BIT(25),
+	MUX_PGP_ATA_9			= BIT(26),
+	MUX_PGP_USB_SUSPEND		= BIT(27),
+	MUX_PGP_USB_OTG_LOOPBACK	= BIT(28),
+	MUX_PGP_USB_HS1_LOOPBACK	= BIT(29),
+	MUX_PGP_USB_HS2_LOOPBACK	= BIT(30),
+	MUX_CLKO_DDR_MODE		= BIT(31),
 };
 
 /*
-- 
2.11.0

