Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBEBD273AB6
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 08:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729420AbgIVGTY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 02:19:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729268AbgIVGTX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 02:19:23 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F8EAC061755
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 23:19:23 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id z18so11506433pfg.0
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 23:19:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=oMxgPDjfwySbQfhlBasnN19F8w+foYzBSl0ZGvp5u1E=;
        b=H402K1D8Oer9W4CqCvkSaRLdXRdOFqSr86kCinmdnUH/Bug2e9ctArrrYrPbLyrqXx
         5GV9Z7Fkqg2zlz/wfwCyyGSE3VUT7dgknaGy50jOiVVPo4xHGwXD0k5noN+e/TsvK54t
         rbtBbQ1HxiXy9j3oSWYZZtgI5pwlzO9oGmC0Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=oMxgPDjfwySbQfhlBasnN19F8w+foYzBSl0ZGvp5u1E=;
        b=e5s3Q5cjkXgIx0p51m/ju4TPd4yYvAI/jrRJisqeSY4E1Rel5R0zDrseWShaGCcCHL
         316j5a7QLyWn/cPat/yfsVpgmj5kmdta4YORxg8tzsp7FwZYyRJkFHn09ux6yGLxsrz6
         SxQJPlxOOXaY2kT1vF4ec2ecwbS1Rj+KHfrZ2cdrnHe0Z/FsfI6xLjY15AI2GUgKJlM8
         tLbWoNqp1IBbBfwdxqvZlBEdrU7KqV2399PP3LhwtFTEnKTC5OO5WnBNvxDKEa92mNFs
         K1p3xO/GFh07AeqlIdgYdQa7/z+ZpRmYFQqw6sEZmq2LBNXdlF+AE61llN9ZgjnWn71v
         M22A==
X-Gm-Message-State: AOAM531JwWlUzgoliA6Wy2H5FHGu5BYpMhFRTt8B21ra+xNTeWSoKoSr
        DwDsErxTsLscPMKsquKzxrOvYA9ngxVeKcpF
X-Google-Smtp-Source: ABdhPJz7U9Aa6tSKnzrmVeWE+FjysKp1Quc3f+D19oVKDt2Wuvr/LW46dcNCn8S1CSnwIkyWNRp/fg==
X-Received: by 2002:a17:902:fe0b:b029:d1:9bd3:6e20 with SMTP id g11-20020a170902fe0bb02900d19bd36e20mr3189265plj.31.1600755562784;
        Mon, 21 Sep 2020 23:19:22 -0700 (PDT)
Received: from lxpurley1.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d17sm14364322pgn.56.2020.09.21.23.19.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Sep 2020 23:19:21 -0700 (PDT)
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
To:     mkubecek@suse.cz, davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, michael.chan@broadcom.com,
        edwin.peer@broadcom.com, andrew.gospodarek@broadcom.com,
        andrew@lunn.ch, Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: [PATCH v2 ethtool] bnxt: Add Broadcom driver support.
Date:   Tue, 22 Sep 2020 11:46:25 +0530
Message-Id: <1600755385-21789-1-git-send-email-vasundhara-v.volam@broadcom.com>
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
v2:
- Fix format specifiers in bnxt_pcie_stats[] array.
- Use width format specifier instead of spaces in register names to
align the data.
- Add '0x' in error log messages to clarify the value is in hex.
---
 Makefile.am |  2 +-
 bnxt.c      | 86 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 ethtool.c   |  1 +
 internal.h  |  3 +++
 4 files changed, 91 insertions(+), 1 deletion(-)
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
index 0000000..e449abd
--- /dev/null
+++ b/bnxt.c
@@ -0,0 +1,86 @@
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
+	{ .name = "Equalization Phase 0 time(ms)", .offset = 33, .size = 1, .format = "0x%llx" },
+	{ .name = "Equalization Phase 1 time(ms)", .offset = 32, .size = 1, .format = "0x%llx" },
+	{ .name = "Equalization Phase 2 time(ms)", .offset = 35, .size = 1, .format = "0x%llx" },
+	{ .name = "Equalization Phase 3 time(ms)", .offset = 34, .size = 1, .format = "0x%llx" },
+	{ .name = "PHY LTSSM Histogram 0", .offset = 36, .size = 2, .format = "0x%llx"},
+	{ .name = "PHY LTSSM Histogram 1", .offset = 38, .size = 2, .format = "0x%llx"},
+	{ .name = "PHY LTSSM Histogram 2", .offset = 40, .size = 2, .format = "0x%llx"},
+	{ .name = "PHY LTSSM Histogram 3", .offset = 42, .size = 2, .format = "0x%llx"},
+	{ .name = "Recovery Histogram 0", .offset = 44, .size = 2, .format = "0x%llx"},
+	{ .name = "Recovery Histogram 1", .offset = 46, .size = 2, .format = "0x%llx"},
+};
+
+int bnxt_dump_regs(struct ethtool_drvinfo *info __maybe_unused, struct ethtool_regs *regs)
+{
+	const struct bnxt_pcie_stat *stats = bnxt_pcie_stats;
+	u16 *pcie_stats;
+	u64 pcie_stat;
+	u32 reg, i;
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
+		pcie_stat = 0;
+		memcpy(&pcie_stat, &pcie_stats[stats[i].offset],
+		       stats[i].size * sizeof(u16));
+
+		fprintf(stdout, "%-30s : ", stats[i].name);
+		fprintf(stdout, stats[i].format, pcie_stat);
+		fprintf(stdout, "\n");
+	}
+
+	fprintf(stdout, "\n");
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

