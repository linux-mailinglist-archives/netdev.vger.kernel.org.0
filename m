Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB619271B00
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 08:42:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbgIUGml (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 02:42:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726011AbgIUGmk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 02:42:40 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96A03C061755
        for <netdev@vger.kernel.org>; Sun, 20 Sep 2020 23:42:40 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id l126so8421294pfd.5
        for <netdev@vger.kernel.org>; Sun, 20 Sep 2020 23:42:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=GtmVFQ4lCYTr0H7aswr1a1/HCrOvVgOEv9M4u4tYyRE=;
        b=NgXFLUSxTp1WqAf/B4t6UOMbutcOJptTNmNuokc0CgHh9ZAQti+7knXoORBgp6LV23
         ptkgOZmQTIxLf3wXRgLAha1i0RqgjhhZGF6BliwD0ne01kWW25e11lasIjodpQZL86d3
         aGHpZ8/5oZhdpdcnzs7ujwdJUN0Kiir3evZo4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=GtmVFQ4lCYTr0H7aswr1a1/HCrOvVgOEv9M4u4tYyRE=;
        b=DoPSlEsGX/5L/hmsIRqQ8m7sMT8qndGaE1ievhFU9jEU+0GCik/1kdyIyghPE7XQHc
         3996f8ab1TyMft2FcorjenNBnSztyEwqykNyNpO7d1s7JPWvc3AIfkNvfTiTz0kyfW5n
         lizoF2lJgBlYpsz3RhK1Wce2j+pdSsdJ8BmPLc/x36yWjh9SIuEnuYZTTFM2PYaLElNw
         G5iVOWAG9sLStNInet24rLEsEspmepTqvPxqO78ePoaCHBPgdnxco+fUnJgF2sn7jpE5
         zVLfdbJwWP+HgNfKD/ZkziGJGsKA0dsEgJ9XVbWZ0SiFDD5+M+NjjEm2RH/qjSUpVLt0
         y/2w==
X-Gm-Message-State: AOAM5327SNvGGNNUuVttncNUp39OpZ4BCH2tNmaC6+kPyGusK8MRKBTT
        K+A08bM1yWyvw7sHgAm+qyie+g==
X-Google-Smtp-Source: ABdhPJwVBe63WteEYxyhFV6W2xV4l2VQryk6TuG/MtOAB4ZTIYKAlDyH7Sw4k9vKTq0db3048+tzFQ==
X-Received: by 2002:a63:e057:: with SMTP id n23mr34247120pgj.87.1600670559817;
        Sun, 20 Sep 2020 23:42:39 -0700 (PDT)
Received: from lxpurley1.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id l21sm9733548pjq.54.2020.09.20.23.42.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 20 Sep 2020 23:42:39 -0700 (PDT)
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
To:     mkubecek@suse.cz, davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, michael.chan@broadcom.com,
        edwin.peer@broadcom.com, andrew.gospodarek@broadcom.com,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: [PATCH ethtool] bnxt: Add Broadcom driver support.
Date:   Mon, 21 Sep 2020 12:09:51 +0530
Message-Id: <1600670391-5533-1-git-send-email-vasundhara-v.volam@broadcom.com>
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
index 0000000..91ed819
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
+	{ .name = "PL Signal integrity errors     ", .offset = 0, .size = 4, .format = "%lld" },
+	{ .name = "DL Signal integrity errors     ", .offset = 4, .size = 4, .format = "%lld" },
+	{ .name = "TLP Signal integrity errors    ", .offset = 8, .size = 4, .format = "%lld" },
+	{ .name = "Link integrity                 ", .offset = 12, .size = 4, .format = "%lld" },
+	{ .name = "TX TLP traffic rate            ", .offset = 16, .size = 4, .format = "%lld" },
+	{ .name = "RX TLP traffic rate            ", .offset = 20, .size = 4, .format = "%lld" },
+	{ .name = "TX DLLP traffic rate           ", .offset = 24, .size = 4, .format = "%lld" },
+	{ .name = "RX DLLP traffic rate           ", .offset = 28, .size = 4, .format = "%lld" },
+	{ .name = "Equalization Phase 0 time(ms)  ", .offset = 33, .size = 1, .format = "0x%lx" },
+	{ .name = "Equalization Phase 1 time(ms)  ", .offset = 32, .size = 1, .format = "0x%lx" },
+	{ .name = "Equalization Phase 2 time(ms)  ", .offset = 35, .size = 1, .format = "0x%lx" },
+	{ .name = "Equalization Phase 3 time(ms)  ", .offset = 34, .size = 1, .format = "0x%lx" },
+	{ .name = "PHY LTSSM Histogram 0          ", .offset = 36, .size = 2, .format = "0x%llx"},
+	{ .name = "PHY LTSSM Histogram 1          ", .offset = 38, .size = 2, .format = "0x%llx"},
+	{ .name = "PHY LTSSM Histogram 2          ", .offset = 40, .size = 2, .format = "0x%llx"},
+	{ .name = "PHY LTSSM Histogram 3          ", .offset = 42, .size = 2, .format = "0x%llx"},
+	{ .name = "Recovery Histogram 0           ", .offset = 44, .size = 2, .format = "0x%llx"},
+	{ .name = "Recovery Histogram 1           ", .offset = 46, .size = 2, .format = "0x%llx"},
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
+		fprintf(stdout, "Length too short, expected atleast %x\n",
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
+		fprintf(stdout, "Length is too short, expected %lx\n",
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
+		fprintf(stdout, "%s", stats[i].name);
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

