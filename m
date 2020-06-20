Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8B22024DF
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 17:44:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727900AbgFTPoN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 11:44:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727826AbgFTPoC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jun 2020 11:44:02 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7712CC0613F0
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 08:44:02 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id mb16so13515916ejb.4
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 08:44:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CdWAK+QAX9FYeYFI/IjsxzxykXf6P7Sr33VfjjbsSu8=;
        b=uRdxnsDGg8oeVKPDEsfX+0SR7u4BxKjwG6JKZthTM0PLzE226rxxHc+s4Gs8Q/MTNI
         /psJY0efyjzZAQUmmcByl56gV/xQ5buf+v9dZCGt8TCckTy8ezVKn73yEISDtFDIIeBd
         sEjgXoqP8jDuluGcFrX1p6zo1qD95QYZ11qkItNT3+rJxMyLdwfZkgviqymLfc4M0MD5
         qkbAVUGgJegpbbw9jBVxHKkcLgGypqcIFp+NR0PTWj0T4ctrWbJjuxE7CMy4X4U8o/qV
         03WNmaq1qES1Gp/GnIvbiTRowx5c5YNv9F+kKLZ7HCF/X6W6pxMUv/Gc1IndiIloO08D
         jKBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CdWAK+QAX9FYeYFI/IjsxzxykXf6P7Sr33VfjjbsSu8=;
        b=WBdPD7kkXir8JZsXCBcEZnk0kRd+4BKK6yNE/3L4RZVDxyETc9zxgAOaqp+PVuMJUS
         kjhJj3Sf+FhObzK/pniE3yKMlDLnkkMDdfFQwRK7i0qbL1198Cg3yG+pceJOp7791pQK
         mRZ4UpXcrBy8B5rAbhlDWLZbM/9YO1C9QBPhqOTLKqadyTvoIQ9KHZyz+mW2QO1ZgvHW
         wIrqvVIyCay31UdFTt8biFEYlAZoWRvLUYoohCLeeMfcY0DfUoRf3KEff7iD6/eZ0V3b
         VO3oD8zPKDAck4eU2pwInFyoW2XUhmLTEMZqptLv4/4UBiG7yXjJYEGO1Q7LXnIno+ZS
         ekGg==
X-Gm-Message-State: AOAM530KlAOPkQSjhUindMx9X6U4zPzekjJG/XHELGegwtlCYwdodDtY
        v6YSMtLXzl9wQSy3JPfqK1c=
X-Google-Smtp-Source: ABdhPJyCcEJsUxuhnVG8Dy6u93/drnCUiaEm7qq75IgxxTTBAnsHGXbo8ULnLCooZkv9Jk0oixymlg==
X-Received: by 2002:a17:906:2c08:: with SMTP id e8mr8252331ejh.385.1592667841248;
        Sat, 20 Jun 2020 08:44:01 -0700 (PDT)
Received: from localhost.localdomain ([188.26.56.128])
        by smtp.gmail.com with ESMTPSA id n25sm7721222edo.56.2020.06.20.08.44.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Jun 2020 08:44:00 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     UNGLinuxDriver@microchip.com, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, xiaoliang.yang_1@nxp.com
Subject: [PATCH net-next 06/12] net: mscc: ocelot: convert MSCC_OCELOT_SWITCH into a library
Date:   Sat, 20 Jun 2020 18:43:41 +0300
Message-Id: <20200620154347.3587114-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200620154347.3587114-1-olteanv@gmail.com>
References: <20200620154347.3587114-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Hide the CONFIG_MSCC_OCELOT_SWITCH option from users. It is meant to be
only a hardware library which is selected by the drivers that use it
(ocelot, felix).

Since it is "selected" from Kconfig, all its dependencies are manually
transferred to the driver that selects it. This is because "select" in
Kconfig language is a bit of a mess, and doesn't handle dependencies of
selected options quite right.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/Kconfig     |  4 +++-
 drivers/net/ethernet/mscc/Kconfig  | 18 ++++++++++--------
 drivers/net/ethernet/mscc/Makefile | 13 ++++++++++---
 3 files changed, 23 insertions(+), 12 deletions(-)

diff --git a/drivers/net/dsa/ocelot/Kconfig b/drivers/net/dsa/ocelot/Kconfig
index a5b7cca03d09..3d3c2a6fb0c0 100644
--- a/drivers/net/dsa/ocelot/Kconfig
+++ b/drivers/net/dsa/ocelot/Kconfig
@@ -4,7 +4,9 @@ config NET_DSA_MSCC_FELIX
 	depends on NET_DSA && PCI
 	depends on NET_VENDOR_MICROSEMI
 	depends on NET_VENDOR_FREESCALE
-	select MSCC_OCELOT_SWITCH
+	depends on HAS_IOMEM
+	depends on REGMAP_MMIO
+	select MSCC_OCELOT_SWITCH_LIB
 	select NET_DSA_TAG_OCELOT
 	select FSL_ENETC_MDIO
 	help
diff --git a/drivers/net/ethernet/mscc/Kconfig b/drivers/net/ethernet/mscc/Kconfig
index bcec0587cf61..24db927e8b30 100644
--- a/drivers/net/ethernet/mscc/Kconfig
+++ b/drivers/net/ethernet/mscc/Kconfig
@@ -11,20 +11,22 @@ config NET_VENDOR_MICROSEMI
 
 if NET_VENDOR_MICROSEMI
 
-config MSCC_OCELOT_SWITCH
-	tristate "Ocelot switch driver"
-	depends on NET_SWITCHDEV
-	depends on HAS_IOMEM
-	select PHYLIB
-	select REGMAP_MMIO
+# Users should depend on NET_SWITCHDEV, HAS_IOMEM, PHYLIB and REGMAP_MMIO
+config MSCC_OCELOT_SWITCH_LIB
+	tristate
 	help
-	  This driver supports the Ocelot network switch device.
+	  This is a hardware support library for Ocelot network switches. It is
+	  used by switchdev as well as by DSA drivers.
 
 config MSCC_OCELOT_SWITCH_OCELOT
 	tristate "Ocelot switch driver on Ocelot"
-	depends on MSCC_OCELOT_SWITCH
+	depends on NET_SWITCHDEV
 	depends on GENERIC_PHY
+	depends on REGMAP_MMIO
+	depends on HAS_IOMEM
+	depends on PHYLIB
 	depends on OF_NET
+	select MSCC_OCELOT_SWITCH_LIB
 	help
 	  This driver supports the Ocelot network switch device as present on
 	  the Ocelot SoCs.
diff --git a/drivers/net/ethernet/mscc/Makefile b/drivers/net/ethernet/mscc/Makefile
index 53572bb76ccd..77222e47d63f 100644
--- a/drivers/net/ethernet/mscc/Makefile
+++ b/drivers/net/ethernet/mscc/Makefile
@@ -1,6 +1,13 @@
 # SPDX-License-Identifier: (GPL-2.0 OR MIT)
-obj-$(CONFIG_MSCC_OCELOT_SWITCH) += mscc_ocelot_common.o
-mscc_ocelot_common-y := ocelot.o ocelot_io.o
-mscc_ocelot_common-y += ocelot_regs.o ocelot_tc.o ocelot_police.o ocelot_ace.o ocelot_flower.o ocelot_ptp.o
+obj-$(CONFIG_MSCC_OCELOT_SWITCH_LIB) += mscc_ocelot_switch_lib.o
+mscc_ocelot_switch_lib-y := \
+	ocelot.o \
+	ocelot_io.o \
+	ocelot_regs.o \
+	ocelot_tc.o \
+	ocelot_police.o \
+	ocelot_ace.o \
+	ocelot_flower.o \
+	ocelot_ptp.o
 obj-$(CONFIG_MSCC_OCELOT_SWITCH_OCELOT) += mscc_ocelot.o
 mscc_ocelot-y := ocelot_vsc7514.o
-- 
2.25.1

