Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F461162BE2
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 18:14:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726865AbgBRRN1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 12:13:27 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:45975 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726750AbgBRRN0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 12:13:26 -0500
Received: by mail-ot1-f68.google.com with SMTP id 59so20239284otp.12;
        Tue, 18 Feb 2020 09:13:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4LxZR/H/qWaW6PLZe7czUDlSa5Ov9S/K1kfsaVdcFug=;
        b=Y+eIkOh/8pk4ibBhldw3l0arntaaYotKXwiF29K9P325mXl//DMJJ5zkNVaug/4nYL
         QxyS2BT+5uhwcpZtmXSQu1FoKhp0nGrIregfSKKiL08DsKekbeVrf7y2hwFGGm+4DrYo
         RHHY3XwWgBgA7d+t4bgLWfob/LcH7cJqxt6wR4zwByA4gPE13GNyqyRfOTZ8WrimDQqH
         NYgxtWncTVZP+7d/AE6vBllHbSITaEnfafPlsLurijhLCx0/L59iEL8CPkFQ3GA+2E9c
         NyzHyiIEWshdjhFRa2oJhP3OPTD42OkWPS2qTSwTfqs5WKXla0V8vUr27tdnwNMs54Yx
         nGYw==
X-Gm-Message-State: APjAAAXtoWxEyliSONOWPlZayTiwMT1c2rBDm8UveOkJaugQbWyFOT0R
        ei2xdoRadJxzUeyHpFYHMA==
X-Google-Smtp-Source: APXvYqzcQiA7Kz1hw5DSMbv4x/r+JIz0TrIbtjHbvB5jqm2ONigiZ49RPglyPaLbn09y6q4zITnNIw==
X-Received: by 2002:a05:6830:1f0c:: with SMTP id u12mr16226750otg.253.1582046005180;
        Tue, 18 Feb 2020 09:13:25 -0800 (PST)
Received: from xps15.herring.priv (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.googlemail.com with ESMTPSA id y25sm1545755oto.27.2020.02.18.09.13.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2020 09:13:24 -0800 (PST)
From:   Rob Herring <robh@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        soc@kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Robert Richter <rrichter@marvell.com>,
        Jon Loeliger <jdl@jdl.com>, Alexander Graf <graf@amazon.com>,
        Matthias Brugger <mbrugger@suse.com>,
        Mark Langsdorf <mlangsdo@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Eric Auger <eric.auger@redhat.com>,
        iommu@lists.linux-foundation.org,
        James Morse <james.morse@arm.com>,
        Jens Axboe <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>,
        kvm@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-pm@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        netdev@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Robin Murphy <robin.murphy@arm.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Will Deacon <will@kernel.org>
Subject: [RFC PATCH 01/11] vfio: Remove Calxeda XGMAC reset driver
Date:   Tue, 18 Feb 2020 11:13:11 -0600
Message-Id: <20200218171321.30990-2-robh@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200218171321.30990-1-robh@kernel.org>
References: <20200218171321.30990-1-robh@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cc: Eric Auger <eric.auger@redhat.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Cornelia Huck <cohuck@redhat.com>
Cc: kvm@vger.kernel.org
Signed-off-by: Rob Herring <robh@kernel.org>
---
Do not apply yet.

 drivers/vfio/platform/reset/Kconfig           |  8 --
 drivers/vfio/platform/reset/Makefile          |  2 -
 .../reset/vfio_platform_calxedaxgmac.c        | 74 -------------------
 3 files changed, 84 deletions(-)
 delete mode 100644 drivers/vfio/platform/reset/vfio_platform_calxedaxgmac.c

diff --git a/drivers/vfio/platform/reset/Kconfig b/drivers/vfio/platform/reset/Kconfig
index 1edbe9ee7356..3668d1d92909 100644
--- a/drivers/vfio/platform/reset/Kconfig
+++ b/drivers/vfio/platform/reset/Kconfig
@@ -1,12 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
-config VFIO_PLATFORM_CALXEDAXGMAC_RESET
-	tristate "VFIO support for calxeda xgmac reset"
-	depends on VFIO_PLATFORM
-	help
-	  Enables the VFIO platform driver to handle reset for Calxeda xgmac
-
-	  If you don't know what to do here, say N.
-
 config VFIO_PLATFORM_AMDXGBE_RESET
 	tristate "VFIO support for AMD XGBE reset"
 	depends on VFIO_PLATFORM
diff --git a/drivers/vfio/platform/reset/Makefile b/drivers/vfio/platform/reset/Makefile
index 7294c5ea122e..be7960ce5dbc 100644
--- a/drivers/vfio/platform/reset/Makefile
+++ b/drivers/vfio/platform/reset/Makefile
@@ -1,7 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
-vfio-platform-calxedaxgmac-y := vfio_platform_calxedaxgmac.o
 vfio-platform-amdxgbe-y := vfio_platform_amdxgbe.o

-obj-$(CONFIG_VFIO_PLATFORM_CALXEDAXGMAC_RESET) += vfio-platform-calxedaxgmac.o
 obj-$(CONFIG_VFIO_PLATFORM_AMDXGBE_RESET) += vfio-platform-amdxgbe.o
 obj-$(CONFIG_VFIO_PLATFORM_BCMFLEXRM_RESET) += vfio_platform_bcmflexrm.o
diff --git a/drivers/vfio/platform/reset/vfio_platform_calxedaxgmac.c b/drivers/vfio/platform/reset/vfio_platform_calxedaxgmac.c
deleted file mode 100644
index 09a9453b75c5..000000000000
--- a/drivers/vfio/platform/reset/vfio_platform_calxedaxgmac.c
+++ /dev/null
@@ -1,74 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * VFIO platform driver specialized for Calxeda xgmac reset
- * reset code is inherited from calxeda xgmac native driver
- *
- * Copyright 2010-2011 Calxeda, Inc.
- * Copyright (c) 2015 Linaro Ltd.
- *              www.linaro.org
- */
-
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/io.h>
-
-#include "../vfio_platform_private.h"
-
-#define DRIVER_VERSION  "0.1"
-#define DRIVER_AUTHOR   "Eric Auger <eric.auger@linaro.org>"
-#define DRIVER_DESC     "Reset support for Calxeda xgmac vfio platform device"
-
-/* XGMAC Register definitions */
-#define XGMAC_CONTROL           0x00000000      /* MAC Configuration */
-
-/* DMA Control and Status Registers */
-#define XGMAC_DMA_CONTROL       0x00000f18      /* Ctrl (Operational Mode) */
-#define XGMAC_DMA_INTR_ENA      0x00000f1c      /* Interrupt Enable */
-
-/* DMA Control registe defines */
-#define DMA_CONTROL_ST          0x00002000      /* Start/Stop Transmission */
-#define DMA_CONTROL_SR          0x00000002      /* Start/Stop Receive */
-
-/* Common MAC defines */
-#define MAC_ENABLE_TX           0x00000008      /* Transmitter Enable */
-#define MAC_ENABLE_RX           0x00000004      /* Receiver Enable */
-
-static inline void xgmac_mac_disable(void __iomem *ioaddr)
-{
-	u32 value = readl(ioaddr + XGMAC_DMA_CONTROL);
-
-	value &= ~(DMA_CONTROL_ST | DMA_CONTROL_SR);
-	writel(value, ioaddr + XGMAC_DMA_CONTROL);
-
-	value = readl(ioaddr + XGMAC_CONTROL);
-	value &= ~(MAC_ENABLE_TX | MAC_ENABLE_RX);
-	writel(value, ioaddr + XGMAC_CONTROL);
-}
-
-static int vfio_platform_calxedaxgmac_reset(struct vfio_platform_device *vdev)
-{
-	struct vfio_platform_region *reg = &vdev->regions[0];
-
-	if (!reg->ioaddr) {
-		reg->ioaddr =
-			ioremap(reg->addr, reg->size);
-		if (!reg->ioaddr)
-			return -ENOMEM;
-	}
-
-	/* disable IRQ */
-	writel(0, reg->ioaddr + XGMAC_DMA_INTR_ENA);
-
-	/* Disable the MAC core */
-	xgmac_mac_disable(reg->ioaddr);
-
-	return 0;
-}
-
-module_vfio_reset_handler("calxeda,hb-xgmac", vfio_platform_calxedaxgmac_reset);
-
-MODULE_VERSION(DRIVER_VERSION);
-MODULE_LICENSE("GPL v2");
-MODULE_AUTHOR(DRIVER_AUTHOR);
-MODULE_DESCRIPTION(DRIVER_DESC);
--
2.20.1
