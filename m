Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B85F352197
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 06:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727992AbfFYEFX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 00:05:23 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:37301 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727521AbfFYEFW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 00:05:22 -0400
Received: by mail-pf1-f195.google.com with SMTP id 19so8728648pfa.4;
        Mon, 24 Jun 2019 21:05:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=P5ZfvrfdpwcPdxORGRAqSpAtYRzseINlQkpUQtY2Ws8=;
        b=H/thxvAkmhccSFOhdG4Yzyj4HFw4dRw1wxnLtEeN4H220s85dFXYPB7QQoQgqhDSYz
         lQe3VralzjZtjvNhiTGnPLni35yOy5T5/BmHSLIpE2DEoJZ+xB7CDJu83rnkJXQUTpDn
         N6Oeahun1Pm1f1Q208+sOa1h4bdICS3pudLVvwkMzM+ivMk77jlOEkhuoiJ+/lEFAxgl
         khUkctK0fBgPhCw+8JrcXV8wJz5KaZV5pufJ8ccLm4LKtlzwaeCcRHSk1Ru+CMkcam5c
         LIVdHGvZBwVUa7elusJjg/2VwAZx2ZW8hJg8Lsp4y4TrqivRiwA/4HoqQWHJNnyZq7LI
         faag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=P5ZfvrfdpwcPdxORGRAqSpAtYRzseINlQkpUQtY2Ws8=;
        b=nyWHOqUqH6Je7ON8IkDBKYn0PxbWPkn7sUv/QSYjLQC4Hf8fcUjIKFzLblEde5aWRj
         4kk5vO7vm5UC0x9g5c8DY9Q4DwuoTs/Fim7sTTlKwQXDaVHdOPeNmpzGWOfMwC07Z1GR
         HwZDOEoigyoBwBXhkM/vgjeRrWiFoJBp+7Lt9pgs+/plM3OxzOGPHRcQ3kVtSejtuPQj
         T8RLSfruoS9ZRvy8y9ly45XO1PTpG6BirGnLyiJF+NuWf/toHtYauRuduIxszLb1xSXo
         nefR7UEUXHV2FEm/46mLd7XJq6K49IrjpoNrAYopogg0WMFCfkflY6L5LMAol7JduqCl
         /JCw==
X-Gm-Message-State: APjAAAWX8yDLRXaLJtItUNHwaSUseaQ9leUhxhLG/usqOk7HZQ7ApJk5
        5hSh/x+Uypgntp1qe1AtS0k=
X-Google-Smtp-Source: APXvYqzVX9z21NZUDUWfhMfzAAEyTfaGnYblo7+GzElYdVodS9Is62qTVne1bUjZ83rqmOFc/ZytwQ==
X-Received: by 2002:a17:90a:ac0e:: with SMTP id o14mr29411138pjq.142.1561435521875;
        Mon, 24 Jun 2019 21:05:21 -0700 (PDT)
Received: from debian.net.fpt ([58.187.168.105])
        by smtp.gmail.com with ESMTPSA id b24sm12408944pfd.98.2019.06.24.21.05.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 21:05:20 -0700 (PDT)
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
Subject: [PATCH V3 06/15] ARM: imx: cleanup cppcheck shifting errors
Date:   Tue, 25 Jun 2019 11:03:47 +0700
Message-Id: <20190625040356.27473-7-tranmanphong@gmail.com>
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

