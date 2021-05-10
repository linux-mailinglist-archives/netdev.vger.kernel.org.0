Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A04E7379A39
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 00:37:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231200AbhEJWin (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 18:38:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230271AbhEJWil (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 18:38:41 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01054C061574
        for <netdev@vger.kernel.org>; Mon, 10 May 2021 15:37:32 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id r5so8554940lfr.5
        for <netdev@vger.kernel.org>; Mon, 10 May 2021 15:37:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=B6G5mxGS97Hap2VX00iN/xKMOsRjsnz25VwvQZShl8M=;
        b=di9E5hDHreHpWQKXKs4HfIxpZ5/VbAE/Xm0x34n76jJqgXvF+lteObqLVUVLTLEFD7
         m6rHi5D+aVyWSujvMHzMeFR430I8hDUU+mUskXR0zSSQFabznnxHUZfMM/7joI5zP2bs
         NbHdfH6Ehlm43VQNxcwMW5TwBFEcffzgkm0EA941YXr5QqlGmHwCQjthG9SvjQrQd9SO
         yidz3Mh1DY5kShZj5UjtphC6txIKdBF51B0eS4/uJ/HjmxLHCkhiCM/bR6KDEaITsCfi
         L4K7kBIkwhuyqdhz3llYiecvbI73EDhoseyRHdZuZCGCy4PWdXGLMIJn3lO40ba7dVt5
         zNgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=B6G5mxGS97Hap2VX00iN/xKMOsRjsnz25VwvQZShl8M=;
        b=cJVoZA53bbVbFd1xkNS6qJuIXp3MpkI2iN5th2kWtvFPxt990KHG9xkqZf7SFVCSt0
         IOusvtvqr6mh99xN6fCHF91eHDh4bcFHOlACf5RjQr+k+qgsB3RgzH97UQR+JesQc7s4
         VYrDzaSl+9pkRL9ZEH8tEtkQNK+J9xf+Kcia5IVQn2gYLtlqNZjr+C0z4sLr45LNqif7
         bwjqydQX8hDrjFiHMtarcPSlojVOjZoaBffF1xQOZ2EKAbWsMMjIytPoO13I4T1PQxuY
         doOl9ymREbKWiqZyK/exDiFIWcL0rBWLz0KZo0AmuAHs2NUeyQErAkzPmLeaOKwgz0oM
         kQeg==
X-Gm-Message-State: AOAM533x2gjdRqHK5X3efN11XCQo4XRffzvvL0DPanJCoTYiKvHlYmIs
        5Urf+7tvtfznY30Dbz3T7HMeJJT8o4PdJw==
X-Google-Smtp-Source: ABdhPJx6qUDnD8w6Oq5mi/6fGE5kK1YApCoxFu5cjK7gjXtmPzHgSTRfPCeGALqtG2V7DA0vN53IDQ==
X-Received: by 2002:ac2:563a:: with SMTP id b26mr18773442lff.324.1620686250416;
        Mon, 10 May 2021 15:37:30 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id d27sm2435535lfq.290.2021.05.10.15.37.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 15:37:30 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     linux-arm-kernel@lists.infradead.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Zoltan HERPAI <wigyori@uid0.hu>,
        Raylynn Knight <rayknight@me.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] soc: ixp4xx: move cpu detection to linux/soc/ixp4xx/cpu.h
Date:   Tue, 11 May 2021 00:37:21 +0200
Message-Id: <20210510223721.605455-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Generic drivers are unable to use the feature macros from mach/cpu.h
or the feature bits from mach/hardware.h, so move these into a global
header file along with some dummy helpers that list these features as
disabled elsewhere.

Cc: David S. Miller <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
Cc: Zoltan HERPAI <wigyori@uid0.hu>
Cc: Raylynn Knight <rayknight@me.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
The only part outside of arch/arm/ and drivers/soc
affected by this is drivers/net/xscale, we do not expect
any disturbances and this will likely be merged into the
ARM SoC tree unless there are protests.
---
 arch/arm/mach-ixp4xx/common.c                 |  22 ++++
 arch/arm/mach-ixp4xx/include/mach/cpu.h       |  54 ---------
 arch/arm/mach-ixp4xx/include/mach/hardware.h  |   2 +-
 .../mach-ixp4xx/include/mach/ixp4xx-regs.h    |  54 ---------
 drivers/net/ethernet/xscale/ixp4xx_eth.c      |   1 +
 drivers/net/ethernet/xscale/ptp_ixp46x.c      |   3 +-
 drivers/net/wan/ixp4xx_hss.c                  |   1 +
 drivers/soc/ixp4xx/ixp4xx-npe.c               |   1 +
 drivers/soc/ixp4xx/ixp4xx-qmgr.c              |   1 +
 include/linux/soc/ixp4xx/cpu.h                | 106 ++++++++++++++++++
 10 files changed, 134 insertions(+), 111 deletions(-)
 delete mode 100644 arch/arm/mach-ixp4xx/include/mach/cpu.h
 create mode 100644 include/linux/soc/ixp4xx/cpu.h

diff --git a/arch/arm/mach-ixp4xx/common.c b/arch/arm/mach-ixp4xx/common.c
index 007a44412e24..f86c1bf34eea 100644
--- a/arch/arm/mach-ixp4xx/common.c
+++ b/arch/arm/mach-ixp4xx/common.c
@@ -27,6 +27,7 @@
 #include <linux/cpu.h>
 #include <linux/pci.h>
 #include <linux/sched_clock.h>
+#include <linux/soc/ixp4xx/cpu.h>
 #include <linux/irqchip/irq-ixp4xx.h>
 #include <linux/platform_data/timer-ixp4xx.h>
 #include <linux/dma-map-ops.h>
@@ -44,6 +45,27 @@
 
 #include "irqs.h"
 
+u32 ixp4xx_read_feature_bits(void)
+{
+	u32 val = ~__raw_readl(IXP4XX_EXP_CFG2);
+
+	if (cpu_is_ixp42x_rev_a0())
+		return IXP42X_FEATURE_MASK & ~(IXP4XX_FEATURE_RCOMP |
+					       IXP4XX_FEATURE_AES);
+	if (cpu_is_ixp42x())
+		return val & IXP42X_FEATURE_MASK;
+	if (cpu_is_ixp43x())
+		return val & IXP43X_FEATURE_MASK;
+	return val & IXP46X_FEATURE_MASK;
+}
+EXPORT_SYMBOL(ixp4xx_read_feature_bits);
+
+void ixp4xx_write_feature_bits(u32 value)
+{
+	__raw_writel(~value, IXP4XX_EXP_CFG2);
+}
+EXPORT_SYMBOL(ixp4xx_write_feature_bits);
+
 #define IXP4XX_TIMER_FREQ 66666000
 
 /*************************************************************************
diff --git a/arch/arm/mach-ixp4xx/include/mach/cpu.h b/arch/arm/mach-ixp4xx/include/mach/cpu.h
deleted file mode 100644
index b872a5354ddd..000000000000
--- a/arch/arm/mach-ixp4xx/include/mach/cpu.h
+++ /dev/null
@@ -1,54 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-/*
- * arch/arm/mach-ixp4xx/include/mach/cpu.h
- *
- * IXP4XX cpu type detection
- *
- * Copyright (C) 2007 MontaVista Software, Inc.
- */
-
-#ifndef __ASM_ARCH_CPU_H__
-#define __ASM_ARCH_CPU_H__
-
-#include <linux/io.h>
-#include <asm/cputype.h>
-
-/* Processor id value in CP15 Register 0 */
-#define IXP42X_PROCESSOR_ID_VALUE	0x690541c0 /* including unused 0x690541Ex */
-#define IXP42X_PROCESSOR_ID_MASK	0xffffffc0
-
-#define IXP43X_PROCESSOR_ID_VALUE	0x69054040
-#define IXP43X_PROCESSOR_ID_MASK	0xfffffff0
-
-#define IXP46X_PROCESSOR_ID_VALUE	0x69054200 /* including IXP455 */
-#define IXP46X_PROCESSOR_ID_MASK	0xfffffff0
-
-#define cpu_is_ixp42x_rev_a0() ((read_cpuid_id() & (IXP42X_PROCESSOR_ID_MASK | 0xF)) == \
-				IXP42X_PROCESSOR_ID_VALUE)
-#define cpu_is_ixp42x()	((read_cpuid_id() & IXP42X_PROCESSOR_ID_MASK) == \
-			 IXP42X_PROCESSOR_ID_VALUE)
-#define cpu_is_ixp43x()	((read_cpuid_id() & IXP43X_PROCESSOR_ID_MASK) == \
-			 IXP43X_PROCESSOR_ID_VALUE)
-#define cpu_is_ixp46x()	((read_cpuid_id() & IXP46X_PROCESSOR_ID_MASK) == \
-			 IXP46X_PROCESSOR_ID_VALUE)
-
-static inline u32 ixp4xx_read_feature_bits(void)
-{
-	u32 val = ~__raw_readl(IXP4XX_EXP_CFG2);
-
-	if (cpu_is_ixp42x_rev_a0())
-		return IXP42X_FEATURE_MASK & ~(IXP4XX_FEATURE_RCOMP |
-					       IXP4XX_FEATURE_AES);
-	if (cpu_is_ixp42x())
-		return val & IXP42X_FEATURE_MASK;
-	if (cpu_is_ixp43x())
-		return val & IXP43X_FEATURE_MASK;
-	return val & IXP46X_FEATURE_MASK;
-}
-
-static inline void ixp4xx_write_feature_bits(u32 value)
-{
-	__raw_writel(~value, IXP4XX_EXP_CFG2);
-}
-
-#endif  /* _ASM_ARCH_CPU_H */
diff --git a/arch/arm/mach-ixp4xx/include/mach/hardware.h b/arch/arm/mach-ixp4xx/include/mach/hardware.h
index b884eedcd0fc..b2b7301ce503 100644
--- a/arch/arm/mach-ixp4xx/include/mach/hardware.h
+++ b/arch/arm/mach-ixp4xx/include/mach/hardware.h
@@ -23,7 +23,7 @@
 #include "ixp4xx-regs.h"
 
 #ifndef __ASSEMBLER__
-#include <mach/cpu.h>
+#include <linux/soc/ixp4xx/cpu.h>
 #endif
 
 /* Platform helper functions and definitions */
diff --git a/arch/arm/mach-ixp4xx/include/mach/ixp4xx-regs.h b/arch/arm/mach-ixp4xx/include/mach/ixp4xx-regs.h
index 708d085ce39f..e6ca5e1479ac 100644
--- a/arch/arm/mach-ixp4xx/include/mach/ixp4xx-regs.h
+++ b/arch/arm/mach-ixp4xx/include/mach/ixp4xx-regs.h
@@ -299,58 +299,4 @@
 
 #define DCMD_LENGTH	0x01fff		/* length mask (max = 8K - 1) */
 
-/* "fuse" bits of IXP_EXP_CFG2 */
-/* All IXP4xx CPUs */
-#define IXP4XX_FEATURE_RCOMP		(1 << 0)
-#define IXP4XX_FEATURE_USB_DEVICE	(1 << 1)
-#define IXP4XX_FEATURE_HASH		(1 << 2)
-#define IXP4XX_FEATURE_AES		(1 << 3)
-#define IXP4XX_FEATURE_DES		(1 << 4)
-#define IXP4XX_FEATURE_HDLC		(1 << 5)
-#define IXP4XX_FEATURE_AAL		(1 << 6)
-#define IXP4XX_FEATURE_HSS		(1 << 7)
-#define IXP4XX_FEATURE_UTOPIA		(1 << 8)
-#define IXP4XX_FEATURE_NPEB_ETH0	(1 << 9)
-#define IXP4XX_FEATURE_NPEC_ETH		(1 << 10)
-#define IXP4XX_FEATURE_RESET_NPEA	(1 << 11)
-#define IXP4XX_FEATURE_RESET_NPEB	(1 << 12)
-#define IXP4XX_FEATURE_RESET_NPEC	(1 << 13)
-#define IXP4XX_FEATURE_PCI		(1 << 14)
-#define IXP4XX_FEATURE_UTOPIA_PHY_LIMIT	(3 << 16)
-#define IXP4XX_FEATURE_XSCALE_MAX_FREQ	(3 << 22)
-#define IXP42X_FEATURE_MASK		(IXP4XX_FEATURE_RCOMP            | \
-					 IXP4XX_FEATURE_USB_DEVICE       | \
-					 IXP4XX_FEATURE_HASH             | \
-					 IXP4XX_FEATURE_AES              | \
-					 IXP4XX_FEATURE_DES              | \
-					 IXP4XX_FEATURE_HDLC             | \
-					 IXP4XX_FEATURE_AAL              | \
-					 IXP4XX_FEATURE_HSS              | \
-					 IXP4XX_FEATURE_UTOPIA           | \
-					 IXP4XX_FEATURE_NPEB_ETH0        | \
-					 IXP4XX_FEATURE_NPEC_ETH         | \
-					 IXP4XX_FEATURE_RESET_NPEA       | \
-					 IXP4XX_FEATURE_RESET_NPEB       | \
-					 IXP4XX_FEATURE_RESET_NPEC       | \
-					 IXP4XX_FEATURE_PCI              | \
-					 IXP4XX_FEATURE_UTOPIA_PHY_LIMIT | \
-					 IXP4XX_FEATURE_XSCALE_MAX_FREQ)
-
-
-/* IXP43x/46x CPUs */
-#define IXP4XX_FEATURE_ECC_TIMESYNC	(1 << 15)
-#define IXP4XX_FEATURE_USB_HOST		(1 << 18)
-#define IXP4XX_FEATURE_NPEA_ETH		(1 << 19)
-#define IXP43X_FEATURE_MASK		(IXP42X_FEATURE_MASK             | \
-					 IXP4XX_FEATURE_ECC_TIMESYNC     | \
-					 IXP4XX_FEATURE_USB_HOST         | \
-					 IXP4XX_FEATURE_NPEA_ETH)
-
-/* IXP46x CPU (including IXP455) only */
-#define IXP4XX_FEATURE_NPEB_ETH_1_TO_3	(1 << 20)
-#define IXP4XX_FEATURE_RSA		(1 << 21)
-#define IXP46X_FEATURE_MASK		(IXP43X_FEATURE_MASK             | \
-					 IXP4XX_FEATURE_NPEB_ETH_1_TO_3  | \
-					 IXP4XX_FEATURE_RSA)
-
 #endif
diff --git a/drivers/net/ethernet/xscale/ixp4xx_eth.c b/drivers/net/ethernet/xscale/ixp4xx_eth.c
index cb89323855d8..dff72abdbcc9 100644
--- a/drivers/net/ethernet/xscale/ixp4xx_eth.c
+++ b/drivers/net/ethernet/xscale/ixp4xx_eth.c
@@ -37,6 +37,7 @@
 #include <linux/module.h>
 #include <linux/soc/ixp4xx/npe.h>
 #include <linux/soc/ixp4xx/qmgr.h>
+#include <linux/soc/ixp4xx/cpu.h>
 
 #include "ixp46x_ts.h"
 
diff --git a/drivers/net/ethernet/xscale/ptp_ixp46x.c b/drivers/net/ethernet/xscale/ptp_ixp46x.c
index 9ecc395239e9..99d4d9439d05 100644
--- a/drivers/net/ethernet/xscale/ptp_ixp46x.c
+++ b/drivers/net/ethernet/xscale/ptp_ixp46x.c
@@ -12,9 +12,8 @@
 #include <linux/io.h>
 #include <linux/irq.h>
 #include <linux/kernel.h>
-#include <linux/module.h>
-
 #include <linux/ptp_clock_kernel.h>
+#include <linux/soc/ixp4xx/cpu.h>
 
 #include "ixp46x_ts.h"
 
diff --git a/drivers/net/wan/ixp4xx_hss.c b/drivers/net/wan/ixp4xx_hss.c
index ecea09fd21cb..7ebe627e9392 100644
--- a/drivers/net/wan/ixp4xx_hss.c
+++ b/drivers/net/wan/ixp4xx_hss.c
@@ -22,6 +22,7 @@
 #include <linux/slab.h>
 #include <linux/soc/ixp4xx/npe.h>
 #include <linux/soc/ixp4xx/qmgr.h>
+#include <linux/soc/ixp4xx/cpu.h>
 
 #define DEBUG_DESC		0
 #define DEBUG_RX		0
diff --git a/drivers/soc/ixp4xx/ixp4xx-npe.c b/drivers/soc/ixp4xx/ixp4xx-npe.c
index e9e56f926e2d..0e4e34bcfc9a 100644
--- a/drivers/soc/ixp4xx/ixp4xx-npe.c
+++ b/drivers/soc/ixp4xx/ixp4xx-npe.c
@@ -21,6 +21,7 @@
 #include <linux/of_platform.h>
 #include <linux/platform_device.h>
 #include <linux/soc/ixp4xx/npe.h>
+#include <linux/soc/ixp4xx/cpu.h>
 
 #define DEBUG_MSG			0
 #define DEBUG_FW			0
diff --git a/drivers/soc/ixp4xx/ixp4xx-qmgr.c b/drivers/soc/ixp4xx/ixp4xx-qmgr.c
index 8c968382cea7..c6bf6ef257c0 100644
--- a/drivers/soc/ixp4xx/ixp4xx-qmgr.c
+++ b/drivers/soc/ixp4xx/ixp4xx-qmgr.c
@@ -12,6 +12,7 @@
 #include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/soc/ixp4xx/qmgr.h>
+#include <linux/soc/ixp4xx/cpu.h>
 
 static struct qmgr_regs __iomem *qmgr_regs;
 static int qmgr_irq_1;
diff --git a/include/linux/soc/ixp4xx/cpu.h b/include/linux/soc/ixp4xx/cpu.h
new file mode 100644
index 000000000000..88bd8de0e803
--- /dev/null
+++ b/include/linux/soc/ixp4xx/cpu.h
@@ -0,0 +1,106 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * IXP4XX cpu type detection
+ *
+ * Copyright (C) 2007 MontaVista Software, Inc.
+ */
+
+#ifndef __SOC_IXP4XX_CPU_H__
+#define __SOC_IXP4XX_CPU_H__
+
+#include <linux/io.h>
+#ifdef CONFIG_ARM
+#include <asm/cputype.h>
+#endif
+
+/* Processor id value in CP15 Register 0 */
+#define IXP42X_PROCESSOR_ID_VALUE	0x690541c0 /* including unused 0x690541Ex */
+#define IXP42X_PROCESSOR_ID_MASK	0xffffffc0
+
+#define IXP43X_PROCESSOR_ID_VALUE	0x69054040
+#define IXP43X_PROCESSOR_ID_MASK	0xfffffff0
+
+#define IXP46X_PROCESSOR_ID_VALUE	0x69054200 /* including IXP455 */
+#define IXP46X_PROCESSOR_ID_MASK	0xfffffff0
+
+/* "fuse" bits of IXP_EXP_CFG2 */
+/* All IXP4xx CPUs */
+#define IXP4XX_FEATURE_RCOMP		(1 << 0)
+#define IXP4XX_FEATURE_USB_DEVICE	(1 << 1)
+#define IXP4XX_FEATURE_HASH		(1 << 2)
+#define IXP4XX_FEATURE_AES		(1 << 3)
+#define IXP4XX_FEATURE_DES		(1 << 4)
+#define IXP4XX_FEATURE_HDLC		(1 << 5)
+#define IXP4XX_FEATURE_AAL		(1 << 6)
+#define IXP4XX_FEATURE_HSS		(1 << 7)
+#define IXP4XX_FEATURE_UTOPIA		(1 << 8)
+#define IXP4XX_FEATURE_NPEB_ETH0	(1 << 9)
+#define IXP4XX_FEATURE_NPEC_ETH		(1 << 10)
+#define IXP4XX_FEATURE_RESET_NPEA	(1 << 11)
+#define IXP4XX_FEATURE_RESET_NPEB	(1 << 12)
+#define IXP4XX_FEATURE_RESET_NPEC	(1 << 13)
+#define IXP4XX_FEATURE_PCI		(1 << 14)
+#define IXP4XX_FEATURE_UTOPIA_PHY_LIMIT	(3 << 16)
+#define IXP4XX_FEATURE_XSCALE_MAX_FREQ	(3 << 22)
+#define IXP42X_FEATURE_MASK		(IXP4XX_FEATURE_RCOMP            | \
+					 IXP4XX_FEATURE_USB_DEVICE       | \
+					 IXP4XX_FEATURE_HASH             | \
+					 IXP4XX_FEATURE_AES              | \
+					 IXP4XX_FEATURE_DES              | \
+					 IXP4XX_FEATURE_HDLC             | \
+					 IXP4XX_FEATURE_AAL              | \
+					 IXP4XX_FEATURE_HSS              | \
+					 IXP4XX_FEATURE_UTOPIA           | \
+					 IXP4XX_FEATURE_NPEB_ETH0        | \
+					 IXP4XX_FEATURE_NPEC_ETH         | \
+					 IXP4XX_FEATURE_RESET_NPEA       | \
+					 IXP4XX_FEATURE_RESET_NPEB       | \
+					 IXP4XX_FEATURE_RESET_NPEC       | \
+					 IXP4XX_FEATURE_PCI              | \
+					 IXP4XX_FEATURE_UTOPIA_PHY_LIMIT | \
+					 IXP4XX_FEATURE_XSCALE_MAX_FREQ)
+
+
+/* IXP43x/46x CPUs */
+#define IXP4XX_FEATURE_ECC_TIMESYNC	(1 << 15)
+#define IXP4XX_FEATURE_USB_HOST		(1 << 18)
+#define IXP4XX_FEATURE_NPEA_ETH		(1 << 19)
+#define IXP43X_FEATURE_MASK		(IXP42X_FEATURE_MASK             | \
+					 IXP4XX_FEATURE_ECC_TIMESYNC     | \
+					 IXP4XX_FEATURE_USB_HOST         | \
+					 IXP4XX_FEATURE_NPEA_ETH)
+
+/* IXP46x CPU (including IXP455) only */
+#define IXP4XX_FEATURE_NPEB_ETH_1_TO_3	(1 << 20)
+#define IXP4XX_FEATURE_RSA		(1 << 21)
+#define IXP46X_FEATURE_MASK		(IXP43X_FEATURE_MASK             | \
+					 IXP4XX_FEATURE_NPEB_ETH_1_TO_3  | \
+					 IXP4XX_FEATURE_RSA)
+
+#ifdef CONFIG_ARCH_IXP4XX
+#define cpu_is_ixp42x_rev_a0() ((read_cpuid_id() & (IXP42X_PROCESSOR_ID_MASK | 0xF)) == \
+				IXP42X_PROCESSOR_ID_VALUE)
+#define cpu_is_ixp42x()	((read_cpuid_id() & IXP42X_PROCESSOR_ID_MASK) == \
+			 IXP42X_PROCESSOR_ID_VALUE)
+#define cpu_is_ixp43x()	((read_cpuid_id() & IXP43X_PROCESSOR_ID_MASK) == \
+			 IXP43X_PROCESSOR_ID_VALUE)
+#define cpu_is_ixp46x()	((read_cpuid_id() & IXP46X_PROCESSOR_ID_MASK) == \
+			 IXP46X_PROCESSOR_ID_VALUE)
+
+u32 ixp4xx_read_feature_bits(void);
+void ixp4xx_write_feature_bits(u32 value);
+#else
+#define cpu_is_ixp42x_rev_a0()		0
+#define cpu_is_ixp42x()			0
+#define cpu_is_ixp43x()			0
+#define cpu_is_ixp46x()			0
+static inline u32 ixp4xx_read_feature_bits(void)
+{
+	return 0;
+}
+static inline void ixp4xx_write_feature_bits(u32 value)
+{
+}
+#endif
+
+#endif  /* _ASM_ARCH_CPU_H */
-- 
2.30.2

