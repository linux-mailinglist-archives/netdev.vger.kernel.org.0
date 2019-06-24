Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 214DC50C9A
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 15:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731559AbfFXNwv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 09:52:51 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:39192 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725562AbfFXNwv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 09:52:51 -0400
Received: by mail-pf1-f193.google.com with SMTP id j2so7556652pfe.6;
        Mon, 24 Jun 2019 06:52:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=fS4UL8p8l4cJtI+V5ALEo52TlMc/49S0xmFzqwxKUhk=;
        b=hWu+lfAfs8cnDI2Qr3G6ZcC8RGr1R7aRMADclLDg4K72EokrxKQxEPQWo21XYg4lnB
         7K+7rMl3umiXZEqxM8Fh1EvEA2fGF1Dx772xtHRx2kWPpXu8L1HHiZkN3lyEDctS7Ucx
         intTaJVhYTH1piVeHP5WfoWA/IjP/7FZPcRYSpOjkhDaVBzvK1b2SUZV9BO6BvNLfLCN
         skyBOYVs0wHf8KjyYEUuEf3i9ASCBr6lESvbt/q1cTQ2rd2dlrflqMw6bsn7qXU3bIP4
         w8gXIRPKbbXXseri0/8j6RJqNg4ZW1aSz1ihyvx9nQn8OR3xU9VN2JwdHTgHPLxoi6j0
         nfnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=fS4UL8p8l4cJtI+V5ALEo52TlMc/49S0xmFzqwxKUhk=;
        b=rx90KT1/pAViS4ySP49Sl4eozc5uK6Hxi8aPsWotTZcdOgDlKVvLC2NliCwNRg3OHp
         87sTwRwi3bhLjh8e/FqW+435AFzKzGdRQPS3CWXOsOYnOTFq6flTQ0fsPmSWAn+9/Dv9
         1lYB2ng/GQ7lzl7iplqsMIswnK35Dge1vvLSU10eQpaGhRY/u0y+mOBt6WlgDYCD2NIn
         /xfKi1z7ICbPyDV5hDOJWw1XWQnhZuPJ0G3HnWvUhSOEuY/emYKl+MJjviq3vmgPEvKj
         C01+AFP56fr5yADisSfR5yOjTLZXwZKlppI0z0aZUA2tkzcXoN3XFzzM9viB65tsq6NR
         virQ==
X-Gm-Message-State: APjAAAWy5Ufe7B9B0uMMCeI4T9D+O+e/X9D/QM070BFZlT4LvijKn9Zc
        jIoRsff2OIhxcEeAnrRbzoY=
X-Google-Smtp-Source: APXvYqwnXZdR6MwQeBGcBVslGO9nN76AEuiamP3zqkKWeFQhgtiystb8KCQwFVSOEzJ5lVZUhRMDyA==
X-Received: by 2002:a63:4f53:: with SMTP id p19mr1115666pgl.327.1561384370011;
        Mon, 24 Jun 2019 06:52:50 -0700 (PDT)
Received: from debian.net.fpt ([58.187.168.105])
        by smtp.gmail.com with ESMTPSA id 85sm11187901pgb.52.2019.06.24.06.52.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 06:52:49 -0700 (PDT)
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
Subject: [PATCH V2 08/15] ARM: mmp: cleanup cppcheck shifting errors
Date:   Mon, 24 Jun 2019 20:50:58 +0700
Message-Id: <20190624135105.15579-9-tranmanphong@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190624135105.15579-1-tranmanphong@gmail.com>
References: <20190623151313.970-1-tranmanphong@gmail.com>
 <20190624135105.15579-1-tranmanphong@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[arch/arm/mach-mmp/pm-mmp2.c:121]: (error) Shifting signed 32-bit value
by 31 bits is undefined behaviour
[arch/arm/mach-mmp/pm-mmp2.c:136]: (error) Shifting signed 32-bit value
by 31 bits is undefined behaviour
[arch/arm/mach-mmp/pm-mmp2.c:244]: (error) Shifting signed 32-bit value
by 31 bits is undefined behaviour
[arch/arm/mach-mmp/pm-pxa910.c:141]: (error) Shifting signed 32-bit
value by 31 bits is undefined behaviour
[arch/arm/mach-mmp/pm-pxa910.c:159]: (error) Shifting signed 32-bit
value by 31 bits is undefined behaviour

Signed-off-by: Phong Tran <tranmanphong@gmail.com>
---
 arch/arm/mach-mmp/pm-mmp2.h   | 40 +++++++++++------------
 arch/arm/mach-mmp/pm-pxa910.h | 76 +++++++++++++++++++++----------------------
 2 files changed, 58 insertions(+), 58 deletions(-)

diff --git a/arch/arm/mach-mmp/pm-mmp2.h b/arch/arm/mach-mmp/pm-mmp2.h
index 70299a9450d3..631ba71abdbd 100644
--- a/arch/arm/mach-mmp/pm-mmp2.h
+++ b/arch/arm/mach-mmp/pm-mmp2.h
@@ -12,37 +12,37 @@
 #include "addr-map.h"
 
 #define APMU_PJ_IDLE_CFG			APMU_REG(0x018)
-#define APMU_PJ_IDLE_CFG_PJ_IDLE		(1 << 1)
-#define APMU_PJ_IDLE_CFG_PJ_PWRDWN		(1 << 5)
+#define APMU_PJ_IDLE_CFG_PJ_IDLE		BIT(1)
+#define APMU_PJ_IDLE_CFG_PJ_PWRDWN		BIT(5)
 #define APMU_PJ_IDLE_CFG_PWR_SW(x)		((x) << 16)
-#define APMU_PJ_IDLE_CFG_L2_PWR_SW		(1 << 19)
+#define APMU_PJ_IDLE_CFG_L2_PWR_SW		BIT(19)
 #define APMU_PJ_IDLE_CFG_ISO_MODE_CNTRL_MASK	(3 << 28)
 
 #define APMU_SRAM_PWR_DWN			APMU_REG(0x08c)
 
 #define MPMU_SCCR				MPMU_REG(0x038)
 #define MPMU_PCR_PJ				MPMU_REG(0x1000)
-#define MPMU_PCR_PJ_AXISD			(1 << 31)
-#define MPMU_PCR_PJ_SLPEN			(1 << 29)
-#define MPMU_PCR_PJ_SPSD			(1 << 28)
-#define MPMU_PCR_PJ_DDRCORSD			(1 << 27)
-#define MPMU_PCR_PJ_APBSD			(1 << 26)
-#define MPMU_PCR_PJ_INTCLR			(1 << 24)
-#define MPMU_PCR_PJ_SLPWP0			(1 << 23)
-#define MPMU_PCR_PJ_SLPWP1			(1 << 22)
-#define MPMU_PCR_PJ_SLPWP2			(1 << 21)
-#define MPMU_PCR_PJ_SLPWP3			(1 << 20)
-#define MPMU_PCR_PJ_VCTCXOSD			(1 << 19)
-#define MPMU_PCR_PJ_SLPWP4			(1 << 18)
-#define MPMU_PCR_PJ_SLPWP5			(1 << 17)
-#define MPMU_PCR_PJ_SLPWP6			(1 << 16)
-#define MPMU_PCR_PJ_SLPWP7			(1 << 15)
+#define MPMU_PCR_PJ_AXISD			BIT(31)
+#define MPMU_PCR_PJ_SLPEN			BIT(29)
+#define MPMU_PCR_PJ_SPSD			BIT(28)
+#define MPMU_PCR_PJ_DDRCORSD			BIT(27)
+#define MPMU_PCR_PJ_APBSD			BIT(26)
+#define MPMU_PCR_PJ_INTCLR			BIT(24)
+#define MPMU_PCR_PJ_SLPWP0			BIT(23)
+#define MPMU_PCR_PJ_SLPWP1			BIT(22)
+#define MPMU_PCR_PJ_SLPWP2			BIT(21)
+#define MPMU_PCR_PJ_SLPWP3			BIT(20)
+#define MPMU_PCR_PJ_VCTCXOSD			BIT(19)
+#define MPMU_PCR_PJ_SLPWP4			BIT(18)
+#define MPMU_PCR_PJ_SLPWP5			BIT(17)
+#define MPMU_PCR_PJ_SLPWP6			BIT(16)
+#define MPMU_PCR_PJ_SLPWP7			BIT(15)
 
 #define MPMU_PLL2_CTRL1				MPMU_REG(0x0414)
 #define MPMU_CGR_PJ				MPMU_REG(0x1024)
 #define MPMU_WUCRM_PJ				MPMU_REG(0x104c)
-#define MPMU_WUCRM_PJ_WAKEUP(x)			(1 << (x))
-#define MPMU_WUCRM_PJ_RTC_ALARM			(1 << 17)
+#define MPMU_WUCRM_PJ_WAKEUP(x)			BIT((x))
+#define MPMU_WUCRM_PJ_RTC_ALARM			BIT(17)
 
 enum {
 	POWER_MODE_ACTIVE = 0,
diff --git a/arch/arm/mach-mmp/pm-pxa910.h b/arch/arm/mach-mmp/pm-pxa910.h
index 8e6344adaf51..f4a0b9811e87 100644
--- a/arch/arm/mach-mmp/pm-pxa910.h
+++ b/arch/arm/mach-mmp/pm-pxa910.h
@@ -10,54 +10,54 @@
 #define __PXA910_PM_H__
 
 #define APMU_MOH_IDLE_CFG			APMU_REG(0x0018)
-#define APMU_MOH_IDLE_CFG_MOH_IDLE		(1 << 1)
-#define APMU_MOH_IDLE_CFG_MOH_PWRDWN		(1 << 5)
-#define APMU_MOH_IDLE_CFG_MOH_SRAM_PWRDWN	(1 << 6)
+#define APMU_MOH_IDLE_CFG_MOH_IDLE		BIT(1)
+#define APMU_MOH_IDLE_CFG_MOH_PWRDWN		BIT(5)
+#define APMU_MOH_IDLE_CFG_MOH_SRAM_PWRDWN	BIT(6)
 #define APMU_MOH_IDLE_CFG_MOH_PWR_SW(x)		(((x) & 0x3) << 16)
 #define APMU_MOH_IDLE_CFG_MOH_L2_PWR_SW(x)	(((x) & 0x3) << 18)
-#define APMU_MOH_IDLE_CFG_MOH_DIS_MC_SW_REQ	(1 << 21)
-#define APMU_MOH_IDLE_CFG_MOH_MC_WAKE_EN	(1 << 20)
+#define APMU_MOH_IDLE_CFG_MOH_DIS_MC_SW_REQ	BIT(21)
+#define APMU_MOH_IDLE_CFG_MOH_MC_WAKE_EN	BIT(20)
 
 #define APMU_SQU_CLK_GATE_CTRL			APMU_REG(0x001c)
 #define APMU_MC_HW_SLP_TYPE			APMU_REG(0x00b0)
 
 #define MPMU_FCCR				MPMU_REG(0x0008)
 #define MPMU_APCR				MPMU_REG(0x1000)
-#define MPMU_APCR_AXISD				(1 << 31)
-#define MPMU_APCR_DSPSD				(1 << 30)
-#define MPMU_APCR_SLPEN				(1 << 29)
-#define MPMU_APCR_DTCMSD			(1 << 28)
-#define MPMU_APCR_DDRCORSD			(1 << 27)
-#define MPMU_APCR_APBSD				(1 << 26)
-#define MPMU_APCR_BBSD				(1 << 25)
-#define MPMU_APCR_SLPWP0			(1 << 23)
-#define MPMU_APCR_SLPWP1			(1 << 22)
-#define MPMU_APCR_SLPWP2			(1 << 21)
-#define MPMU_APCR_SLPWP3			(1 << 20)
-#define MPMU_APCR_VCTCXOSD			(1 << 19)
-#define MPMU_APCR_SLPWP4			(1 << 18)
-#define MPMU_APCR_SLPWP5			(1 << 17)
-#define MPMU_APCR_SLPWP6			(1 << 16)
-#define MPMU_APCR_SLPWP7			(1 << 15)
-#define MPMU_APCR_MSASLPEN			(1 << 14)
-#define MPMU_APCR_STBYEN			(1 << 13)
+#define MPMU_APCR_AXISD				BIT(31)
+#define MPMU_APCR_DSPSD				BIT(30)
+#define MPMU_APCR_SLPEN				BIT(29)
+#define MPMU_APCR_DTCMSD			BIT(28)
+#define MPMU_APCR_DDRCORSD			BIT(27)
+#define MPMU_APCR_APBSD				BIT(26)
+#define MPMU_APCR_BBSD				BIT(25)
+#define MPMU_APCR_SLPWP0			BIT(23)
+#define MPMU_APCR_SLPWP1			BIT(22)
+#define MPMU_APCR_SLPWP2			BIT(21)
+#define MPMU_APCR_SLPWP3			BIT(20)
+#define MPMU_APCR_VCTCXOSD			BIT(19)
+#define MPMU_APCR_SLPWP4			BIT(18)
+#define MPMU_APCR_SLPWP5			BIT(17)
+#define MPMU_APCR_SLPWP6			BIT(16)
+#define MPMU_APCR_SLPWP7			BIT(15)
+#define MPMU_APCR_MSASLPEN			BIT(14)
+#define MPMU_APCR_STBYEN			BIT(13)
 
 #define MPMU_AWUCRM				MPMU_REG(0x104c)
-#define MPMU_AWUCRM_AP_ASYNC_INT		(1 << 25)
-#define MPMU_AWUCRM_AP_FULL_IDLE		(1 << 24)
-#define MPMU_AWUCRM_SDH1			(1 << 23)
-#define MPMU_AWUCRM_SDH2			(1 << 22)
-#define MPMU_AWUCRM_KEYPRESS			(1 << 21)
-#define MPMU_AWUCRM_TRACKBALL			(1 << 20)
-#define MPMU_AWUCRM_NEWROTARY			(1 << 19)
-#define MPMU_AWUCRM_RTC_ALARM			(1 << 17)
-#define MPMU_AWUCRM_AP2_TIMER_3			(1 << 13)
-#define MPMU_AWUCRM_AP2_TIMER_2			(1 << 12)
-#define MPMU_AWUCRM_AP2_TIMER_1			(1 << 11)
-#define MPMU_AWUCRM_AP1_TIMER_3			(1 << 10)
-#define MPMU_AWUCRM_AP1_TIMER_2			(1 << 9)
-#define MPMU_AWUCRM_AP1_TIMER_1			(1 << 8)
-#define MPMU_AWUCRM_WAKEUP(x)			(1 << ((x) & 0x7))
+#define MPMU_AWUCRM_AP_ASYNC_INT		BIT(25)
+#define MPMU_AWUCRM_AP_FULL_IDLE		BIT(24)
+#define MPMU_AWUCRM_SDH1			BIT(23)
+#define MPMU_AWUCRM_SDH2			BIT(22)
+#define MPMU_AWUCRM_KEYPRESS			BIT(21)
+#define MPMU_AWUCRM_TRACKBALL			BIT(20)
+#define MPMU_AWUCRM_NEWROTARY			BIT(19)
+#define MPMU_AWUCRM_RTC_ALARM			BIT(17)
+#define MPMU_AWUCRM_AP2_TIMER_3			BIT(13)
+#define MPMU_AWUCRM_AP2_TIMER_2			BIT(12)
+#define MPMU_AWUCRM_AP2_TIMER_1			BIT(11)
+#define MPMU_AWUCRM_AP1_TIMER_3			BIT(10)
+#define MPMU_AWUCRM_AP1_TIMER_2			BIT(9)
+#define MPMU_AWUCRM_AP1_TIMER_1			BIT(8)
+#define MPMU_AWUCRM_WAKEUP(x)			BIT(((x) & 0x7))
 
 enum {
 	POWER_MODE_ACTIVE = 0,
-- 
2.11.0

