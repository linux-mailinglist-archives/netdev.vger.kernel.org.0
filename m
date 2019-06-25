Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F069521A3
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 06:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728140AbfFYEFp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 00:05:45 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:37863 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbfFYEFo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 00:05:44 -0400
Received: by mail-pl1-f195.google.com with SMTP id bh12so8065436plb.4;
        Mon, 24 Jun 2019 21:05:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=3hDPzui9gf1WJ+/ZpgOxbemW+83id6X2TA1vUibRHx4=;
        b=Fo1NHV0BJqLJ4S96AdDzTs/jSOHPt9gmqGZ8TvWo98NAqyU0YU0nvg71DBudR/9RqE
         BartdV0MEmoB/P/G0UMqx5ERrP68S1hoVUwY4UZP/gu0w4zkqZ7u56a2C0PoMDXjBfuE
         wXMAvxc/yPFZwTNfG0QAemkvpZI5iDDlBcZnG5RWU0YE2vSMgeok50hEJzDd2ZfFQb2N
         ubSgi2HR/a6acvCT1kBlNinKNCu4KWpOZo6zDzJEJuC9eZkhde4FdYcdcfTs7STELFQ2
         aK3qTmP0jKsVIieMIEk+ODIXe+ap456VPMW1e8jv38MCxI4y8GMw8kdfV6OJD8H0WpaM
         7ElQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=3hDPzui9gf1WJ+/ZpgOxbemW+83id6X2TA1vUibRHx4=;
        b=rRFnkFi9Udl21uLd00V41UJzs5v1lVzFkdPSJ6KjmvQEg0meh0lOGeCHe16slqKpsH
         6TpFZPA+h7uDMhZBr7nRGw62uKTDClmVxUScFPPGO2QDFu3tcTNrmZv8Qbv5WQJ1ooH5
         pTdG8XlvMSOTCEXMB8o/Br/U87J8C3NUWMpi0QlQJaIrMFJPTgFmciWXoGGII3+slkSE
         vlTtq6VUOyRPJvh2fXP3Lf6ifutLLWtRNIpWpEe5tp0zG2Yo3JWQw7JoUGo+qDvf9dpB
         FlH75GEpCW9ryAdXz29ze8VgC/ID7FM+nTHXPqXcIFXbSi3ZDMMDIQKC4fMMiYT5TER2
         nEVA==
X-Gm-Message-State: APjAAAWfhuuCU8+flQ+siWASeWKfn1OmN9bg64kkWj/CuDhmUNX4Nj5u
        gPPy9sLqWjoNIH4U4HbzNGk=
X-Google-Smtp-Source: APXvYqwZ8lBUH7HPfJB7xYWCYlHNQRAMCUJlf+u6GBRLPOz4OFDdA7pKSMVTok+/Obo6WBtd0L5bFA==
X-Received: by 2002:a17:902:2f:: with SMTP id 44mr91323064pla.5.1561435543196;
        Mon, 24 Jun 2019 21:05:43 -0700 (PDT)
Received: from debian.net.fpt ([58.187.168.105])
        by smtp.gmail.com with ESMTPSA id b24sm12408944pfd.98.2019.06.24.21.05.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 21:05:42 -0700 (PDT)
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
Subject: [PATCH V3 08/15] ARM: mmp: cleanup cppcheck shifting errors
Date:   Tue, 25 Jun 2019 11:03:49 +0700
Message-Id: <20190625040356.27473-9-tranmanphong@gmail.com>
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
 arch/arm/mach-mmp/pm-mmp2.h   | 40 +++++++++++------------
 arch/arm/mach-mmp/pm-pxa910.h | 74 +++++++++++++++++++++----------------------
 2 files changed, 57 insertions(+), 57 deletions(-)

diff --git a/arch/arm/mach-mmp/pm-mmp2.h b/arch/arm/mach-mmp/pm-mmp2.h
index 70299a9450d3..8b1d91543676 100644
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
+#define MPMU_WUCRM_PJ_WAKEUP(x)			BIT(x)
+#define MPMU_WUCRM_PJ_RTC_ALARM			BIT(17)
 
 enum {
 	POWER_MODE_ACTIVE = 0,
diff --git a/arch/arm/mach-mmp/pm-pxa910.h b/arch/arm/mach-mmp/pm-pxa910.h
index 8e6344adaf51..fc2f9c4b9d94 100644
--- a/arch/arm/mach-mmp/pm-pxa910.h
+++ b/arch/arm/mach-mmp/pm-pxa910.h
@@ -10,53 +10,53 @@
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
 #define MPMU_AWUCRM_WAKEUP(x)			(1 << ((x) & 0x7))
 
 enum {
-- 
2.11.0

