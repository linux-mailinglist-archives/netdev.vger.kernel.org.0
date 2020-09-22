Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01AC2273F59
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 12:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbgIVKPr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 06:15:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726423AbgIVKPr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 06:15:47 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68E68C061755
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 03:15:47 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id x22so7180927pfo.12
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 03:15:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=C4ECTPiBiSzmbjnKRnVVU6cIIDjVtaJFojWclBL6/g0=;
        b=d4DYSSskcBS6omX7D7+w6ZiGRy+x2v+yOVC58bXqahv0R/nydk9o8vw1iYua+LzT7b
         bcHSrT+moFH3YpnSE0+Nepa2Bst3oiXtWnJwG2ujN1hih85JQ3JkzaflzAGe8Kmerl5G
         OgfW0gfhJszeT6YvYyXHYhzW2avZDPgJiT3Ew=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=C4ECTPiBiSzmbjnKRnVVU6cIIDjVtaJFojWclBL6/g0=;
        b=ftpmsvZFVjCWcjhFPFh0cd+vlt/2q4JVuU0krbgy+F3gR3BK+KF0w33wvn8n5oB/1Z
         KQzfPWCuBlP/gL3Q2HhmslNgXU4aWZboeDjBRQ47bZyWri14PZntObZ3Ykuhh244X0cg
         FyYnMlRp+NEwzfYICs0HmUjeaiT0lZMExqfoUXOzK2sXN0a6PTTdeQEITpy8ebGhwU2y
         +jiQ+HXfZ0bkFjRyQkwHSETlNsJb0KHH6CYJw2/0WELd/ARwi5lpF2585XtqBifJobvw
         3Dqf1mf9XvDuzB26qtnOnVc8KyvV20cePHrv8UjGBtFMt0HPVtzWkx4VSMhSF3tnmiI/
         JsZw==
X-Gm-Message-State: AOAM531IheRaqL/Iyjj0OBBnLTM0RpAsvOszlEhFD34BUzWFE3I/wmxG
        NrnsjuxJQzRHj9WX+qMLtXnEvw==
X-Google-Smtp-Source: ABdhPJyy+jLSwdGK/2EJdzAyPAdcqS0VEXTGgq/0QGF8MzaAg02mDLFft92ko3mjSAmZk6Yx6KoG9g==
X-Received: by 2002:aa7:9565:0:b029:13e:d13d:a057 with SMTP id x5-20020aa795650000b029013ed13da057mr3354856pfq.29.1600769745291;
        Tue, 22 Sep 2020 03:15:45 -0700 (PDT)
Received: from lxpurley1.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id c12sm13529774pgd.57.2020.09.22.03.15.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Sep 2020 03:15:44 -0700 (PDT)
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
To:     mkubecek@suse.cz, davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, michael.chan@broadcom.com,
        edwin.peer@broadcom.com, andrew.gospodarek@broadcom.com,
        andrew@lunn.ch, Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: [PATCH v3 ethtool] bnxt: Add Broadcom driver support.
Date:   Tue, 22 Sep 2020 15:43:02 +0530
Message-Id: <1600769582-26467-1-git-send-email-vasundhara-v.volam@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds the initial support for parsing registers dumped
by the Broadcom driver. Currently, PXP and PCIe registers are
parsed.

Reviewed-by: Andy Gospodarek <gospo@broadcom.com>
Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
---
v3:
- Fix the memcpy to copy to the correct size variable.
- Also, fix format specifiers in bnxt_pcie_stats[] array accordingly.
v2:
- Fix format specifiers in bnxt_pcie_stats[] array.
- Use width format specifier instead of spaces in register names to
align the data.
- Add '0x' in error log messages to clarify the value is in hex.
---
 Makefile.am |  2 +-
 bnxt.c      | 97 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 ethtool.c   |  1 +
 internal.h  |  3 ++
 4 files changed, 102 insertions(+), 1 deletion(-)
 create mode 100644 bnxt.c

diff --git a/Makefile.am b/Makefile.am
index 0e237d0..e3e311d 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -17,7 +17,7 @@ ethtool_SOURCES += \
 		  smsc911x.c at76c50x-usb.c sfc.c stmmac.c	\
 		  sff-common.c sff-common.h sfpid.c sfpdiag.c	\
 		  ixgbevf.c tse.c vmxnet3.c qsfp.c qsfp.h fjes.c lan78xx.c \
-		  igc.c qsfp-dd.c qsfp-dd.h
+		  igc.c qsfp-dd.c qsfp-dd.h bnxt.c
 endif
 
 if ENABLE_BASH_COMPLETION
diff --git a/bnxt.c b/bnxt.c
new file mode 100644
index 0000000..b46db72
--- /dev/null
+++ b/bnxt.c
@@ -0,0 +1,97 @@
+/* Code to dump registers for NetXtreme-E/NetXtreme-C Broadcom devices.
+ *
+ * Copyright (c) 2020 Broadcom Inc.
+ */
+#include <stdio.h>
+#include "internal.h"
+
+#define BNXT_PXP_REG_LEN	0x3110
+#define BNXT_PCIE_STATS_LEN	(12 * sizeof(u64))
+
+struct bnxt_pcie_stat {
+	const char *name;
+	u16 offset;
+	u8 size;
+	const char *format;
+};
+
+static const struct bnxt_pcie_stat bnxt_pcie_stats[] = {
+	{ .name = "PL Signal integrity errors", .offset = 0, .size = 4, .format = "%llu" },
+	{ .name = "DL Signal integrity errors", .offset = 4, .size = 4, .format = "%llu" },
+	{ .name = "TLP Signal integrity errors", .offset = 8, .size = 4, .format = "%llu" },
+	{ .name = "Link integrity", .offset = 12, .size = 4, .format = "%llu" },
+	{ .name = "TX TLP traffic rate", .offset = 16, .size = 4, .format = "%llu" },
+	{ .name = "RX TLP traffic rate", .offset = 20, .size = 4, .format = "%llu" },
+	{ .name = "TX DLLP traffic rate", .offset = 24, .size = 4, .format = "%llu" },
+	{ .name = "RX DLLP traffic rate", .offset = 28, .size = 4, .format = "%llu" },
+	{ .name = "Equalization Phase 0 time(ms)", .offset = 33, .size = 1, .format = "0x%x" },
+	{ .name = "Equalization Phase 1 time(ms)", .offset = 32, .size = 1, .format = "0x%x" },
+	{ .name = "Equalization Phase 2 time(ms)", .offset = 35, .size = 1, .format = "0x%x" },
+	{ .name = "Equalization Phase 3 time(ms)", .offset = 34, .size = 1, .format = "0x%x" },
+	{ .name = "PHY LTSSM Histogram 0", .offset = 36, .size = 2, .format = "0x%x"},
+	{ .name = "PHY LTSSM Histogram 1", .offset = 38, .size = 2, .format = "0x%x"},
+	{ .name = "PHY LTSSM Histogram 2", .offset = 40, .size = 2, .format = "0x%x"},
+	{ .name = "PHY LTSSM Histogram 3", .offset = 42, .size = 2, .format = "0x%x"},
+	{ .name = "Recovery Histogram 0", .offset = 44, .size = 2, .format = "0x%x"},
+	{ .name = "Recovery Histogram 1", .offset = 46, .size = 2, .format = "0x%x"},
+};
+
+int bnxt_dump_regs(struct ethtool_drvinfo *info __maybe_unused, struct ethtool_regs *regs)
+{
+	const struct bnxt_pcie_stat *stats = bnxt_pcie_stats;
+	u16 *pcie_stats, pcie_stat16;
+	u32 reg, i, pcie_stat32;
+	u64 pcie_stat64;
+
+	if (regs->len < BNXT_PXP_REG_LEN) {
+		fprintf(stdout, "Length too short, expected at least 0x%x\n",
+			BNXT_PXP_REG_LEN);
+		return -1;
+	}
+
+	fprintf(stdout, "PXP Registers\n");
+	fprintf(stdout, "Offset\tValue\n");
+	fprintf(stdout, "------\t-------\n");
+	for (i = 0; i < BNXT_PXP_REG_LEN; i += sizeof(reg)) {
+		memcpy(&reg, &regs->data[i], sizeof(reg));
+		if (reg)
+			fprintf(stdout, "0x%04x\t0x%08x\n", i, reg);
+	}
+	fprintf(stdout, "\n");
+
+	if (!regs->version)
+		return 0;
+
+	if (regs->len < (BNXT_PXP_REG_LEN + BNXT_PCIE_STATS_LEN)) {
+		fprintf(stdout, "Length is too short, expected 0x%lx\n",
+			BNXT_PXP_REG_LEN + BNXT_PCIE_STATS_LEN);
+		return -1;
+	}
+
+	pcie_stats = (u16 *)(regs->data + BNXT_PXP_REG_LEN);
+	fprintf(stdout, "PCIe statistics:\n");
+	fprintf(stdout, "----------------\n");
+	for (i = 0; i < ARRAY_SIZE(bnxt_pcie_stats); i++) {
+		fprintf(stdout, "%-30s : ", stats[i].name);
+		switch (stats[i].size) {
+		case 1:
+			pcie_stat16 = 0;
+			memcpy(&pcie_stat16, &pcie_stats[stats[i].offset], sizeof(u16));
+			fprintf(stdout, stats[i].format, pcie_stat16);
+			break;
+		case 2:
+			pcie_stat32 = 0;
+			memcpy(&pcie_stat32, &pcie_stats[stats[i].offset], sizeof(u32));
+			fprintf(stdout, stats[i].format, pcie_stat32);
+			break;
+		case 4:
+			pcie_stat64 = 0;
+			memcpy(&pcie_stat64, &pcie_stats[stats[i].offset], sizeof(u64));
+			fprintf(stdout, stats[i].format, pcie_stat64);
+			break;
+		}
+		fprintf(stdout, "\n");
+	}
+
+	return 0;
+}
diff --git a/ethtool.c b/ethtool.c
index ab9b457..89bd15c 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -1072,6 +1072,7 @@ static const struct {
 	{ "dsa", dsa_dump_regs },
 	{ "fec", fec_dump_regs },
 	{ "igc", igc_dump_regs },
+	{ "bnxt_en", bnxt_dump_regs },
 #endif
 };
 
diff --git a/internal.h b/internal.h
index d096a28..935ebac 100644
--- a/internal.h
+++ b/internal.h
@@ -396,4 +396,7 @@ int fec_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs);
 /* Intel(R) Ethernet Controller I225-LM/I225-V adapter family */
 int igc_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs);
 
+/* Broadcom Ethernet Controller */
+int bnxt_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs);
+
 #endif /* ETHTOOL_INTERNAL_H__ */
-- 
1.8.3.1

