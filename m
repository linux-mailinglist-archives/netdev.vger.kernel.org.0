Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66ED14FC3E
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 17:15:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbfFWPPM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 11:15:12 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:42789 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726429AbfFWPPK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jun 2019 11:15:10 -0400
Received: by mail-pg1-f194.google.com with SMTP id l19so5717340pgh.9;
        Sun, 23 Jun 2019 08:15:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=mm1dTXMWnksShv1qsoX7kjs5qFgC6/OHjmwMeM+dQy0=;
        b=PMusJSQKv2QfwzEdNIDXqQrvvtamFh5gSDyumzv3wn7ny/R+qFb/qOCPrPiK+Oauxt
         32jmczWFEhdKrYJUsfuKmnwe6H4kHn0MInzJgeJaTXrQBgku0JWg7+Omn2VJKab0pKaL
         JozGm6sU+Vx9Q0itKWxyFXLM+jELerAbdQUulyvReCpLSIqpxm2CY9oPupKqY5/I6sSE
         qTZeMlQPp28phwx55e981qqPBR5aYQBxWEDguGHSKHvJgBhANiQLMVZqHIk32PgqsR4t
         VcuafmRtOumtkLlcWt2rkWo9hMeYZB9U5sW/7vkkqbNcJG/oPBUmSLHjV8Fg9NaHt5fp
         W7Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=mm1dTXMWnksShv1qsoX7kjs5qFgC6/OHjmwMeM+dQy0=;
        b=O321D0hf8wa/CJI1+8lKVddvjr3QubSM8/m2MRXkO3gAVJeYBDnAHYCTuKqzSXfBZU
         IkVGt1Ha9VKbEz1UXG8E0ToN3y+bex/SOy+fVHGVakPpWFFZO3IOUuirjoFK3tdtf9X6
         ClB0YOIlWQnZmKhUiZRt5VfE03LVIJxb6fCxqh8Kd1HlFnFixwXDuX0Ou1FNa/5V0lCz
         6aJPZmF44dRrGL3aFFO/nVAioCiCdIbpW3JX1K3y+M/AMH2JK+nMemxo8zav6/od7ePL
         aVUEdW8OM23F49H9vE5gy+fLm36ldIlZwwYHrD8V9/BtvmE4T7ByrNbBzu/HA8M7LwVD
         /iyA==
X-Gm-Message-State: APjAAAVpxwnyu/O7HlFjJRkH2IBiLghdfogJLECIWOjDbzwX3GZ0A9pK
        Qj0P1ZJLWXbYw3ZX5SXU+EM=
X-Google-Smtp-Source: APXvYqwpDHemTjk91V1i+rnw2Nx/nfwf89c8nRaLim4HHHw3DC4Hb5Z6OkupEivXLpb4ZGXvwICHYw==
X-Received: by 2002:a63:5247:: with SMTP id s7mr27245447pgl.29.1561302909589;
        Sun, 23 Jun 2019 08:15:09 -0700 (PDT)
Received: from debian.net.fpt ([1.55.47.94])
        by smtp.gmail.com with ESMTPSA id p6sm8329194pgs.77.2019.06.23.08.14.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 23 Jun 2019 08:15:08 -0700 (PDT)
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
Subject: [PATCH 06/15] ARM: imx: cleanup cppcheck shifting errors
Date:   Sun, 23 Jun 2019 22:13:04 +0700
Message-Id: <20190623151313.970-7-tranmanphong@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190623151313.970-1-tranmanphong@gmail.com>
References: <20190623151313.970-1-tranmanphong@gmail.com>
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
index 99270a183d47..c30951dd110d 100644
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
+	MUX_PGP_FIRI			= 1U << 0,
+	MUX_DDR_MODE			= 1U << 1,
+	MUX_PGP_CSPI_BB			= 1U << 2,
+	MUX_PGP_ATA_1			= 1U << 3,
+	MUX_PGP_ATA_2			= 1U << 4,
+	MUX_PGP_ATA_3			= 1U << 5,
+	MUX_PGP_ATA_4			= 1U << 6,
+	MUX_PGP_ATA_5			= 1U << 7,
+	MUX_PGP_ATA_6			= 1U << 8,
+	MUX_PGP_ATA_7			= 1U << 9,
+	MUX_PGP_ATA_8			= 1U << 10,
+	MUX_PGP_UH2			= 1U << 11,
+	MUX_SDCTL_CSD0_SEL		= 1U << 12,
+	MUX_SDCTL_CSD1_SEL		= 1U << 13,
+	MUX_CSPI1_UART3			= 1U << 14,
+	MUX_EXTDMAREQ2_MBX_SEL		= 1U << 15,
+	MUX_TAMPER_DETECT_EN		= 1U << 16,
+	MUX_PGP_USB_4WIRE		= 1U << 17,
+	MUX_PGP_USB_COMMON		= 1U << 18,
+	MUX_SDHC_MEMSTICK1		= 1U << 19,
+	MUX_SDHC_MEMSTICK2		= 1U << 20,
+	MUX_PGP_SPLL_BYP		= 1U << 21,
+	MUX_PGP_UPLL_BYP		= 1U << 22,
+	MUX_PGP_MSHC1_CLK_SEL		= 1U << 23,
+	MUX_PGP_MSHC2_CLK_SEL		= 1U << 24,
+	MUX_CSPI3_UART5_SEL		= 1U << 25,
+	MUX_PGP_ATA_9			= 1U << 26,
+	MUX_PGP_USB_SUSPEND		= 1U << 27,
+	MUX_PGP_USB_OTG_LOOPBACK	= 1U << 28,
+	MUX_PGP_USB_HS1_LOOPBACK	= 1U << 29,
+	MUX_PGP_USB_HS2_LOOPBACK	= 1U << 30,
+	MUX_CLKO_DDR_MODE		= 1U << 31,
 };
 
 /*
-- 
2.11.0

