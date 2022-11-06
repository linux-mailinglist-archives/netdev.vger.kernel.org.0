Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BAB361E6F5
	for <lists+netdev@lfdr.de>; Sun,  6 Nov 2022 23:42:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230222AbiKFWmI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Nov 2022 17:42:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbiKFWmE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Nov 2022 17:42:04 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2122.outbound.protection.outlook.com [40.107.20.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDD1BFD26;
        Sun,  6 Nov 2022 14:42:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DSZNVBDo4O3S7zr8fDkP5efnXxxkWKyp9GMxI6Pn0UCy9IQBgyxI3vjxuhJ7cGAJKRYkF4X2KpQnGwke+XrWzWMCk7j/cZYEkIYSj2+bXeVPeQ3v81snJ8h5eodt3Nayhq6QHchddcLtq91llSt5hidhHsX4lRD7LuFbxV5dqIKHcqkeiP+9N+8hluvazIipOdrJiIzZ72CtRX1gGKl3XqZOa17J8G1fq55qb+0a0NQYp4rhrpel+UQ2vwtzW0wi2UR9DiI3BKKUuogLBDmHQKWtZK+Mfi1lwbtBPJouUg4s0JJBxutqRgYhj9Hu9Y9xefv+LeTp3+TDDIxBKsEjqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lCwhchX0QAZ7957g1T1Wb9GjZ1i4nfmE0kW65+eziwg=;
 b=CF8SCXQGFmM/o0tWvkq50XP0o52GUSraXIpVT8aEd0PF4an48uK41KEh620Ct1GGo+pPmSZL3IcYy59BTouVQcO2xBTl+mUNBF4tj9EYSymgJtuFhP42qk7pLg/4YpZxFWwgVSe6NPlZrsPg8+95nqnkvVw9SBkUItd2jRw/8V9pdJG4ZaVbAwi/erAMBcavkHnsNgRuJ7fXYdlP381+23W8Z3/4sUy8qcSUEGcJV9mIcK1iMZmCSLlKml0aQjsC/mUlvAxnkyqqSj/0wHPSsddXRbCx4QTD3zSLMAfXIv768xUd9S9DN669MGmqiDB39vQlBYrBP7mCnC0noRafYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 81.14.233.218) smtp.rcpttodomain=grandegger.com smtp.mailfrom=esd.eu;
 dmarc=bestguesspass action=none header.from=esd.eu; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lCwhchX0QAZ7957g1T1Wb9GjZ1i4nfmE0kW65+eziwg=;
 b=NXOWTqaVA2Uznb5/Xd4EmIac9aynAO3UBtmb71kj2Vo5r4hEd3dtVmBGiX4rSezFinkWkkr3rYUvxH1MeckMLt77xaTnyrjYdPpGlzQmh3H0jirAbbUxv+s+cgfscoRpcXHXI9C/IqqoJp9oQoCLcS7TaP6Vn1HEDcmSBLgh/EM=
Received: from DB6PR0801CA0046.eurprd08.prod.outlook.com (2603:10a6:4:2b::14)
 by AM7PR03MB6418.eurprd03.prod.outlook.com (2603:10a6:20b:1be::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Sun, 6 Nov
 2022 22:41:57 +0000
Received: from DB8EUR06FT068.eop-eur06.prod.protection.outlook.com
 (2603:10a6:4:2b:cafe::39) by DB6PR0801CA0046.outlook.office365.com
 (2603:10a6:4:2b::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.26 via Frontend
 Transport; Sun, 6 Nov 2022 22:41:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 81.14.233.218)
 smtp.mailfrom=esd.eu; dkim=none (message not signed)
 header.d=none;dmarc=bestguesspass action=none header.from=esd.eu;
Received-SPF: Pass (protection.outlook.com: domain of esd.eu designates
 81.14.233.218 as permitted sender) receiver=protection.outlook.com;
 client-ip=81.14.233.218; helo=esd-s7.esd; pr=C
Received: from esd-s7.esd (81.14.233.218) by
 DB8EUR06FT068.mail.protection.outlook.com (10.233.253.122) with Microsoft
 SMTP Server id 15.20.5791.20 via Frontend Transport; Sun, 6 Nov 2022 22:41:56
 +0000
Received: from esd-s20.esd.local (debby [10.0.0.190])
        by esd-s7.esd (Postfix) with ESMTPS id 6BC1B7C16C8;
        Sun,  6 Nov 2022 23:41:56 +0100 (CET)
Received: by esd-s20.esd.local (Postfix, from userid 2044)
        id 57EFB2F00DB; Sun,  6 Nov 2022 23:41:56 +0100 (CET)
From:   =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>
To:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v7 2/2] can: esd: add support for esd GmbH PCIe/402 CAN interface family
Date:   Sun,  6 Nov 2022 23:41:56 +0100
Message-Id: <20221106224156.3619334-3-stefan.maetje@esd.eu>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221106224156.3619334-1-stefan.maetje@esd.eu>
References: <20221106224156.3619334-1-stefan.maetje@esd.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB8EUR06FT068:EE_|AM7PR03MB6418:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d931660-427a-4344-d045-08dac0481c2e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J1bpHQpFT4GZLGt2TY8jFYPqM55HICsC5DgcHin2OeC/VC38wwMWNOYovyA91nah37xcFkQfr3QT7B/gFjeNZCsVnahG22xkXS+ckWtaWPFrypyCqiwXKYiWMlVrt5GdkFolJcSs+cMzYrhfOUg1Gd4FKVLKfHu4oTWZqyLYpPkv1XOrLPHK9hwDmhw9lEwqv4BCdntpsHtXxUDEC1HLavpLnrU3gntYZyEi8UUUyASX+7bGM9OvPpJcax4geCX3HhNQ+Bueiq0oVl/RxHhME+Odeeoy68zmlybnda3fQaa1kzKnizFrfzzLLTIud0CQNcadYfZatwedT+9zN7ubf2m44Di0JNWI/WSsORxINi4K0fWQsybiObOHGtYrp0gBaDux4mugB0R0wtJ5/pXrZKKzzLHWSZOsMn5htCLlkVBVM4l4wr9OV9qac9QBH2GbC6wGApmlA7m1vQkl4js7uYUgn9SKSSfdATmue0UROMeT2CBk3ySyxGZtYApwS81ZYqmfZnBCgLvy2hGMUsvC3JuP0rHgV3LIUNUV1ikBVv+jjfQb9+BBUfBBz00yyUI62a/Ffw2TzVxr3pFXrzxss+DUTCMFcGFmWTx3JiHIre7D4QtjNCdavpGdXlj+8DNcea36KPKz1WcrqCA3bAXlwgRky3lo/EWFdQXDej7dlFJO4omUvUfYcZ0+Xg+dmYdd9x6weSbDAkf4EzCEaXPJTGnoza/93XztS/kMQozzz0EgPx+A8yXgdcpafCaLThMyvV+biVBq4AHya1FApqOxeE+HZsqu7ikaZ0w6kL9+yfRuH9SubrTLl2DAIVHAen6n
X-Forefront-Antispam-Report: CIP:81.14.233.218;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:esd-s7.esd;PTR:a81-14-233-218.net-htp.de;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(136003)(39830400003)(376002)(451199015)(46966006)(36840700001)(2906002)(83380400001)(86362001)(966005)(47076005)(66574015)(36756003)(30864003)(8936002)(41300700001)(5660300002)(336012)(40480700001)(70206006)(70586007)(36860700001)(316002)(4326008)(8676002)(42186006)(110136005)(6266002)(26005)(186003)(1076003)(478600001)(2616005)(82310400005)(356005)(81166007)(559001)(579004);DIR:OUT;SFP:1102;
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2022 22:41:56.8261
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d931660-427a-4344-d045-08dac0481c2e
X-MS-Exchange-CrossTenant-Id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5a9c3a1d-52db-4235-b74c-9fd851db2e6b;Ip=[81.14.233.218];Helo=[esd-s7.esd]
X-MS-Exchange-CrossTenant-AuthSource: DB8EUR06FT068.eop-eur06.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR03MB6418
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for the PCI based PCIe/402 CAN interface family
from esd GmbH that is available with various form factors
(https://esd.eu/en/products/402-series-can-interfaces).

All boards utilize a FPGA based CAN controller solution developed
by esd (esdACC). For more information on the esdACC see
https://esd.eu/en/products/esdacc.

This driver detects all available CAN interface board variants of
the family but atm. operates the CAN-FD capable devices in
Classic-CAN mode only! A later patch will introduce the CAN-FD
functionality in this driver.

Co-developed-by: Thomas Körper <thomas.koerper@esd.eu>
Signed-off-by: Thomas Körper <thomas.koerper@esd.eu>
Signed-off-by: Stefan Mätje <stefan.maetje@esd.eu>
---
 drivers/net/can/Kconfig                |   1 +
 drivers/net/can/Makefile               |   1 +
 drivers/net/can/esd/Kconfig            |  12 +
 drivers/net/can/esd/Makefile           |   7 +
 drivers/net/can/esd/esd_402_pci-core.c | 510 ++++++++++++++++
 drivers/net/can/esd/esdacc.c           | 771 +++++++++++++++++++++++++
 drivers/net/can/esd/esdacc.h           | 393 +++++++++++++
 7 files changed, 1695 insertions(+)
 create mode 100644 drivers/net/can/esd/Kconfig
 create mode 100644 drivers/net/can/esd/Makefile
 create mode 100644 drivers/net/can/esd/esd_402_pci-core.c
 create mode 100644 drivers/net/can/esd/esdacc.c
 create mode 100644 drivers/net/can/esd/esdacc.h

diff --git a/drivers/net/can/Kconfig b/drivers/net/can/Kconfig
index cd34e8dc9394..5a1c2cbb93e0 100644
--- a/drivers/net/can/Kconfig
+++ b/drivers/net/can/Kconfig
@@ -201,6 +201,7 @@ config CAN_XILINXCAN
 source "drivers/net/can/c_can/Kconfig"
 source "drivers/net/can/cc770/Kconfig"
 source "drivers/net/can/ctucanfd/Kconfig"
+source "drivers/net/can/esd/Kconfig"
 source "drivers/net/can/ifi_canfd/Kconfig"
 source "drivers/net/can/m_can/Kconfig"
 source "drivers/net/can/mscan/Kconfig"
diff --git a/drivers/net/can/Makefile b/drivers/net/can/Makefile
index 52b0f6e10668..8ab8b30d381e 100644
--- a/drivers/net/can/Makefile
+++ b/drivers/net/can/Makefile
@@ -8,6 +8,7 @@ obj-$(CONFIG_CAN_VXCAN)		+= vxcan.o
 obj-$(CONFIG_CAN_SLCAN)		+= slcan/
 
 obj-y				+= dev/
+obj-y				+= esd/
 obj-y				+= rcar/
 obj-y				+= spi/
 obj-y				+= usb/
diff --git a/drivers/net/can/esd/Kconfig b/drivers/net/can/esd/Kconfig
new file mode 100644
index 000000000000..54bfc366634c
--- /dev/null
+++ b/drivers/net/can/esd/Kconfig
@@ -0,0 +1,12 @@
+# SPDX-License-Identifier: GPL-2.0-only
+config CAN_ESD_402_PCI
+	tristate "esd electronics gmbh CAN-PCI(e)/402 family"
+	depends on PCI && HAS_DMA
+	help
+	  Support for C402 card family from esd electronics gmbh.
+	  This card family is based on the ESDACC CAN controller and
+	  available in several form factors:  PCI, PCIe, PCIe Mini,
+	  M.2 PCIe, CPCIserial, PMC, XMC  (see https://esd.eu/en)
+
+	  This driver can also be built as a module. In this case the
+	  module will be called esd_402_pci.
diff --git a/drivers/net/can/esd/Makefile b/drivers/net/can/esd/Makefile
new file mode 100644
index 000000000000..5dd2d470c286
--- /dev/null
+++ b/drivers/net/can/esd/Makefile
@@ -0,0 +1,7 @@
+# SPDX-License-Identifier: GPL-2.0-only
+#
+#  Makefile for esd gmbh ESDACC controller driver
+#
+esd_402_pci-objs := esdacc.o esd_402_pci-core.o
+
+obj-$(CONFIG_CAN_ESD_402_PCI) += esd_402_pci.o
diff --git a/drivers/net/can/esd/esd_402_pci-core.c b/drivers/net/can/esd/esd_402_pci-core.c
new file mode 100644
index 000000000000..84be508c6344
--- /dev/null
+++ b/drivers/net/can/esd/esd_402_pci-core.c
@@ -0,0 +1,510 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (C) 2015 - 2016 Thomas Körper, esd electronic system design gmbh
+ * Copyright (C) 2017 - 2022 Stefan Mätje, esd electronics gmbh
+ */
+
+#include <linux/can/dev.h>
+#include <linux/can.h>
+#include <linux/can/netlink.h>
+#include <linux/delay.h>
+#include <linux/dma-mapping.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/netdevice.h>
+#include <linux/pci.h>
+
+#include "esdacc.h"
+
+#define ESD_PCI_DEVICE_ID_PCIE402 0x0402
+
+#define PCI402_FPGA_VER_MIN 0x003d
+#define PCI402_MAX_CORES 6
+#define PCI402_BAR 0
+#define PCI402_IO_OV_OFFS 0
+#define PCI402_IO_PCIEP_OFFS 0x10000
+#define PCI402_IO_LEN_TOTAL 0x20000
+#define PCI402_IO_LEN_CORE 0x2000
+#define PCI402_PCICFG_MSICAP 0x50
+
+#define PCI402_DMA_MASK DMA_BIT_MASK(32)
+#define PCI402_DMA_SIZE ALIGN(0x10000, PAGE_SIZE)
+
+#define PCI402_PCIEP_OF_INT_ENABLE 0x0050
+#define PCI402_PCIEP_OF_BM_ADDR_LO 0x1000
+#define PCI402_PCIEP_OF_BM_ADDR_HI 0x1004
+#define PCI402_PCIEP_OF_MSI_ADDR_LO 0x1008
+#define PCI402_PCIEP_OF_MSI_ADDR_HI 0x100c
+
+/* The BTR register capabilities described by the can_bittiming_const structures
+ * below are valid since ESDACC version 0x0032.
+ */
+
+/* Used if the ESDACC FPGA is built as CAN-Classic version. */
+static const struct can_bittiming_const pci402_bittiming_const = {
+	.name = "esd_402",
+	.tseg1_min = 1,
+	.tseg1_max = 16,
+	.tseg2_min = 1,
+	.tseg2_max = 8,
+	.sjw_max = 4,
+	.brp_min = 1,
+	.brp_max = 512,
+	.brp_inc = 1,
+};
+
+/* Used if the ESDACC FPGA is built as CAN-FD version. */
+static const struct can_bittiming_const pci402_bittiming_const_canfd = {
+	.name = "esd_402fd",
+	.tseg1_min = 1,
+	.tseg1_max = 256,
+	.tseg2_min = 1,
+	.tseg2_max = 128,
+	.sjw_max = 128,
+	.brp_min = 1,
+	.brp_max = 256,
+	.brp_inc = 1,
+};
+
+static const struct net_device_ops pci402_acc_netdev_ops = {
+	.ndo_open = acc_open,
+	.ndo_stop = acc_close,
+	.ndo_start_xmit = acc_start_xmit,
+	.ndo_change_mtu = can_change_mtu
+};
+
+struct pci402_card {
+	/* Actually mapped io space, all other iomem derived from this */
+	void __iomem *addr;
+	void __iomem *addr_pciep;
+
+	void *dma_buf;
+	dma_addr_t dma_hnd;
+
+	struct acc_ov ov;
+	struct acc_core *cores;
+
+	bool msi_enabled;
+};
+
+static irqreturn_t pci402_interrupt(int irq, void *dev_id)
+{
+	struct pci_dev *pdev = dev_id;
+	struct pci402_card *card = pci_get_drvdata(pdev);
+	irqreturn_t irq_status;
+
+	irq_status = acc_card_interrupt(&card->ov, card->cores);
+
+	return irq_status;
+}
+
+static int pci402_set_msiconfig(struct pci_dev *pdev)
+{
+	struct pci402_card *card = pci_get_drvdata(pdev);
+	u32 addr_lo_offs = 0;
+	u32 addr_lo = 0;
+	u32 addr_hi = 0;
+	u32 data = 0;
+	u16 csr = 0;
+	int err;
+
+	/* The FPGA hard IP PCIe core implements a 64-bit MSI Capability
+	 * Register Format
+	 */
+	err = pci_read_config_word(pdev, PCI402_PCICFG_MSICAP + PCI_MSI_FLAGS, &csr);
+	if (err)
+		goto failed;
+
+	err = pci_read_config_dword(pdev, PCI402_PCICFG_MSICAP + PCI_MSI_ADDRESS_LO,
+				    &addr_lo);
+	if (err)
+		goto failed;
+	err = pci_read_config_dword(pdev, PCI402_PCICFG_MSICAP + PCI_MSI_ADDRESS_HI,
+				    &addr_hi);
+	if (err)
+		goto failed;
+
+	err = pci_read_config_dword(pdev, PCI402_PCICFG_MSICAP + PCI_MSI_DATA_64,
+				    &data);
+	if (err)
+		goto failed;
+
+	addr_lo_offs = addr_lo & 0x0000ffff;
+	addr_lo &= 0xffff0000;
+
+	if (addr_hi)
+		addr_lo |= 1; /* To enable 64-Bit addressing in PCIe endpoint */
+
+	if (!(csr & PCI_MSI_FLAGS_ENABLE)) {
+		err = -EINVAL;
+		goto failed;
+	}
+
+	iowrite32(addr_lo, card->addr_pciep + PCI402_PCIEP_OF_MSI_ADDR_LO);
+	iowrite32(addr_hi, card->addr_pciep + PCI402_PCIEP_OF_MSI_ADDR_HI);
+	acc_ov_write32(&card->ov, ACC_OV_OF_MSI_ADDRESSOFFSET, addr_lo_offs);
+	acc_ov_write32(&card->ov, ACC_OV_OF_MSI_DATA, data);
+
+	return 0;
+
+failed:
+	pci_warn(pdev, "Error while setting MSI configuration:\n"
+		 "CSR: 0x%.4x, addr: 0x%.8x%.8x, offs: 0x%.4x, data: 0x%.8x\n",
+		 csr, addr_hi, addr_lo, addr_lo_offs, data);
+
+	return err;
+}
+
+static int pci402_init_card(struct pci_dev *pdev)
+{
+	struct pci402_card *card = pci_get_drvdata(pdev);
+
+	card->ov.addr = card->addr + PCI402_IO_OV_OFFS;
+	card->addr_pciep = card->addr + PCI402_IO_PCIEP_OFFS;
+
+	acc_reset_fpga(&card->ov);
+	acc_init_ov(&card->ov, &pdev->dev);
+
+	if (card->ov.version < PCI402_FPGA_VER_MIN) {
+		pci_err(pdev,
+			"ESDACC version (0x%.4x) outdated, please update\n",
+			card->ov.version);
+		return -EINVAL;
+	}
+
+	if (card->ov.timestamp_frequency != ACC_TS_FREQ_80MHZ) {
+		pci_err(pdev,
+			"esdACC timestamp frequency of %uHz not supported by driver. Aborted.\n",
+			card->ov.timestamp_frequency);
+		return -EINVAL;
+	}
+
+	if (card->ov.active_cores > PCI402_MAX_CORES) {
+		pci_err(pdev,
+			"Card has more active cores (%u) than supported by driver. Aborted.\n",
+			card->ov.active_cores);
+		return -EINVAL;
+	}
+	card->cores = devm_kcalloc(&pdev->dev, card->ov.active_cores,
+				   sizeof(struct acc_core), GFP_KERNEL);
+	if (!card->cores)
+		return -ENOMEM;
+
+	if (card->ov.features & ACC_OV_REG_FEAT_MASK_CANFD) {
+		pci_warn(pdev,
+			 "ESDACC with CAN-FD feature detected. This driver doesn't support CAN-FD yet.\n");
+	}
+
+#ifdef __LITTLE_ENDIAN
+	/* So card converts all busmastered data to LE for us: */
+	acc_ov_set_bits(&card->ov, ACC_OV_OF_MODE,
+			ACC_OV_REG_MODE_MASK_ENDIAN_LITTLE);
+#endif
+
+	return 0;
+}
+
+static int pci402_init_interrupt(struct pci_dev *pdev)
+{
+	struct pci402_card *card = pci_get_drvdata(pdev);
+	int err;
+
+	err = pci_enable_msi(pdev);
+	if (!err) {
+		err = pci402_set_msiconfig(pdev);
+		if (!err) {
+			card->msi_enabled = true;
+			acc_ov_set_bits(&card->ov, ACC_OV_OF_MODE,
+					ACC_OV_REG_MODE_MASK_MSI_ENABLE);
+			pci_info(pdev, "MSI enabled\n");
+		}
+	}
+
+	err = devm_request_irq(&pdev->dev, pdev->irq, pci402_interrupt,
+			       IRQF_SHARED, dev_name(&pdev->dev), pdev);
+	if (err)
+		goto failure_msidis;
+
+	iowrite32(1, card->addr_pciep + PCI402_PCIEP_OF_INT_ENABLE);
+
+	return 0;
+
+failure_msidis:
+	if (card->msi_enabled) {
+		acc_ov_clear_bits(&card->ov, ACC_OV_OF_MODE,
+				  ACC_OV_REG_MODE_MASK_MSI_ENABLE);
+		pci_disable_msi(pdev);
+		card->msi_enabled = false;
+	}
+
+	return err;
+}
+
+static void pci402_finish_interrupt(struct pci_dev *pdev)
+{
+	struct pci402_card *card = pci_get_drvdata(pdev);
+
+	iowrite32(0, card->addr_pciep + PCI402_PCIEP_OF_INT_ENABLE);
+	devm_free_irq(&pdev->dev, pdev->irq, pdev);
+
+	if (card->msi_enabled) {
+		acc_ov_clear_bits(&card->ov, ACC_OV_OF_MODE,
+				  ACC_OV_REG_MODE_MASK_MSI_ENABLE);
+		pci_disable_msi(pdev);
+		card->msi_enabled = false;
+	}
+}
+
+static int pci402_init_dma(struct pci_dev *pdev)
+{
+	struct pci402_card *card = pci_get_drvdata(pdev);
+	int err;
+
+	err = dma_set_coherent_mask(&pdev->dev, PCI402_DMA_MASK);
+	if (err) {
+		pci_err(pdev, "DMA set mask failed!\n");
+		return err;
+	}
+
+	/* The ESDACC DMA engine needs the DMA buffer aligned to a 64k
+	 * boundary. The DMA API guarantees to align the returned buffer to the
+	 * smallest PAGE_SIZE order which is greater than or equal to the
+	 * requested size. With PCI402_DMA_SIZE == 64kB this suffices here.
+	 */
+	card->dma_buf = dma_alloc_coherent(&pdev->dev, PCI402_DMA_SIZE,
+					   &card->dma_hnd, GFP_KERNEL);
+	if (!card->dma_buf)
+		return -ENOMEM;
+
+	acc_init_bm_ptr(&card->ov, card->cores, card->dma_buf);
+
+	iowrite32(card->dma_hnd,
+		  card->addr_pciep + PCI402_PCIEP_OF_BM_ADDR_LO);
+	iowrite32(0, card->addr_pciep + PCI402_PCIEP_OF_BM_ADDR_HI);
+
+	pci_set_master(pdev);
+
+	acc_ov_set_bits(&card->ov, ACC_OV_OF_MODE,
+			ACC_OV_REG_MODE_MASK_BM_ENABLE);
+
+	return 0;
+}
+
+static void pci402_finish_dma(struct pci_dev *pdev)
+{
+	struct pci402_card *card = pci_get_drvdata(pdev);
+	int i;
+
+	acc_ov_clear_bits(&card->ov, ACC_OV_OF_MODE,
+			  ACC_OV_REG_MODE_MASK_BM_ENABLE);
+
+	pci_clear_master(pdev);
+
+	iowrite32(0, card->addr_pciep + PCI402_PCIEP_OF_BM_ADDR_LO);
+	iowrite32(0, card->addr_pciep + PCI402_PCIEP_OF_BM_ADDR_HI);
+
+	card->ov.bmfifo.messages = NULL;
+	card->ov.bmfifo.irq_cnt = NULL;
+	for (i = 0; i < card->ov.active_cores; i++) {
+		struct acc_core *core = &card->cores[i];
+
+		core->bmfifo.messages = NULL;
+		core->bmfifo.irq_cnt = NULL;
+	}
+
+	dma_free_coherent(&pdev->dev, PCI402_DMA_SIZE, card->dma_buf,
+			  card->dma_hnd);
+	card->dma_buf = NULL;
+}
+
+static int pci402_init_cores(struct pci_dev *pdev)
+{
+	struct pci402_card *card = pci_get_drvdata(pdev);
+	int err;
+	int i;
+
+	for (i = 0; i < card->ov.active_cores; i++) {
+		struct acc_core *core = &card->cores[i];
+		struct acc_net_priv *priv;
+		struct net_device *netdev;
+		u32 fifo_config;
+
+		core->addr = card->ov.addr + (i + 1) * PCI402_IO_LEN_CORE;
+
+		fifo_config = acc_read32(core, ACC_CORE_OF_TXFIFO_CONFIG);
+		core->tx_fifo_size = (fifo_config >> 24);
+		if (core->tx_fifo_size <= 1) {
+			pci_err(pdev, "Invalid tx_fifo_size!\n");
+			err = -EINVAL;
+			goto failure;
+		}
+
+		netdev = alloc_candev(sizeof(*priv), core->tx_fifo_size);
+		if (!netdev) {
+			err = -ENOMEM;
+			goto failure;
+		}
+		core->netdev = netdev;
+
+		netdev->flags |= IFF_ECHO;
+		netdev->dev_port = i;
+		netdev->netdev_ops = &pci402_acc_netdev_ops;
+		SET_NETDEV_DEV(netdev, &pdev->dev);
+
+		priv = netdev_priv(netdev);
+		priv->can.ctrlmode_supported = CAN_CTRLMODE_LOOPBACK |
+			CAN_CTRLMODE_LISTENONLY |
+			CAN_CTRLMODE_BERR_REPORTING |
+			CAN_CTRLMODE_CC_LEN8_DLC;
+
+		priv->can.clock.freq = card->ov.core_frequency;
+		if (card->ov.features & ACC_OV_REG_FEAT_MASK_CANFD)
+			priv->can.bittiming_const = &pci402_bittiming_const_canfd;
+		else
+			priv->can.bittiming_const = &pci402_bittiming_const;
+		priv->can.do_set_bittiming = acc_set_bittiming;
+		priv->can.do_set_mode = acc_set_mode;
+		priv->can.do_get_berr_counter = acc_get_berr_counter;
+
+		priv->core = core;
+		priv->ov = &card->ov;
+
+		err = register_candev(netdev);
+		if (err) {
+			free_candev(core->netdev);
+			core->netdev = NULL;
+			goto failure;
+		}
+
+		netdev_info(netdev, "registered\n");
+	}
+
+	return 0;
+
+failure:
+	for (i--; i >= 0; i--) {
+		struct acc_core *core = &card->cores[i];
+
+		netdev_info(core->netdev, "unregistering...\n");
+		unregister_candev(core->netdev);
+
+		free_candev(core->netdev);
+		core->netdev = NULL;
+	}
+
+	return err;
+}
+
+static void pci402_finish_cores(struct pci_dev *pdev)
+{
+	struct pci402_card *card = pci_get_drvdata(pdev);
+	int i;
+
+	for (i = 0; i < card->ov.active_cores; i++) {
+		struct acc_core *core = &card->cores[i];
+
+		netdev_info(core->netdev, "unregister\n");
+		unregister_candev(core->netdev);
+
+		free_candev(core->netdev);
+		core->netdev = NULL;
+	}
+}
+
+static int pci402_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
+{
+	struct pci402_card *card = NULL;
+	int err;
+
+	err = pci_enable_device(pdev);
+	if (err)
+		return err;
+
+	card = devm_kzalloc(&pdev->dev, sizeof(*card), GFP_KERNEL);
+	if (!card)
+		goto failure_disable_pci;
+
+	pci_set_drvdata(pdev, card);
+
+	err = pci_request_regions(pdev, pci_name(pdev));
+	if (err)
+		goto failure_disable_pci;
+
+	card->addr = pci_iomap(pdev, PCI402_BAR, PCI402_IO_LEN_TOTAL);
+	if (!card->addr) {
+		err = -ENOMEM;
+		goto failure_release_regions;
+	}
+
+	err = pci402_init_card(pdev);
+	if (err)
+		goto failure_unmap;
+
+	err = pci402_init_dma(pdev);
+	if (err)
+		goto failure_unmap;
+
+	err = pci402_init_interrupt(pdev);
+	if (err)
+		goto failure_finish_dma;
+
+	err = pci402_init_cores(pdev);
+	if (err)
+		goto failure_finish_interrupt;
+
+	return 0;
+
+failure_finish_interrupt:
+	pci402_finish_interrupt(pdev);
+
+failure_finish_dma:
+	pci402_finish_dma(pdev);
+
+failure_unmap:
+	pci_iounmap(pdev, card->addr);
+
+failure_release_regions:
+	pci_release_regions(pdev);
+
+failure_disable_pci:
+	pci_disable_device(pdev);
+
+	return err;
+}
+
+static void pci402_remove(struct pci_dev *pdev)
+{
+	struct pci402_card *card = pci_get_drvdata(pdev);
+
+	pci402_finish_interrupt(pdev);
+	pci402_finish_cores(pdev);
+	pci402_finish_dma(pdev);
+	pci_iounmap(pdev, card->addr);
+	pci_release_regions(pdev);
+	pci_disable_device(pdev);
+}
+
+static const struct pci_device_id pci402_tbl[] = {
+	{
+		.vendor = PCI_VENDOR_ID_ESDGMBH,
+		.device = ESD_PCI_DEVICE_ID_PCIE402,
+		.subvendor = PCI_VENDOR_ID_ESDGMBH,
+		.subdevice = PCI_ANY_ID,
+	},
+	{ 0, }
+};
+MODULE_DEVICE_TABLE(pci, pci402_tbl);
+
+static struct pci_driver pci402_driver = {
+	.name = KBUILD_MODNAME,
+	.id_table = pci402_tbl,
+	.probe = pci402_probe,
+	.remove = pci402_remove,
+};
+module_pci_driver(pci402_driver);
+
+MODULE_DESCRIPTION("Socket-CAN driver for esd CAN 402 card family with esdACC core on PCIe");
+MODULE_AUTHOR("Thomas Körper <socketcan@esd.eu>");
+MODULE_AUTHOR("Stefan Mätje <stefan.maetje@esd.eu>");
+MODULE_LICENSE("GPL");
diff --git a/drivers/net/can/esd/esdacc.c b/drivers/net/can/esd/esdacc.c
new file mode 100644
index 000000000000..49017c986c70
--- /dev/null
+++ b/drivers/net/can/esd/esdacc.c
@@ -0,0 +1,771 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (C) 2015 - 2016 Thomas Körper, esd electronic system design gmbh
+ * Copyright (C) 2017 - 2022 Stefan Mätje, esd electronics gmbh
+ */
+
+#include "esdacc.h"
+
+#include <linux/bitfield.h>
+#include <linux/delay.h>
+#include <linux/io.h>
+#include <linux/ktime.h>
+
+/* ecc value of esdACC equals SJA1000's ECC register */
+#define ACC_ECC_SEG			0x1f
+#define ACC_ECC_DIR			0x20
+#define ACC_ECC_BIT			0x00
+#define ACC_ECC_FORM			0x40
+#define ACC_ECC_STUFF			0x80
+#define ACC_ECC_MASK			0xc0
+
+#define ACC_BM_IRQ_UNMASK_ALL		0x55555555U
+#define ACC_BM_IRQ_MASK_ALL		0xaaaaaaaaU
+#define ACC_BM_IRQ_MASK			0x2U
+#define ACC_BM_IRQ_UNMASK		0x1U
+#define ACC_BM_LENFLAG_TX		0x20
+
+#define ACC_REG_STATUS_IDX_STATUS_DOS	16
+#define ACC_REG_STATUS_IDX_STATUS_ES	17
+#define ACC_REG_STATUS_IDX_STATUS_EP	18
+#define ACC_REG_STATUS_IDX_STATUS_BS	19
+#define ACC_REG_STATUS_IDX_STATUS_RBS	20
+#define ACC_REG_STATUS_IDX_STATUS_RS	21
+#define ACC_REG_STATUS_MASK_STATUS_DOS	BIT(ACC_REG_STATUS_IDX_STATUS_DOS)
+#define ACC_REG_STATUS_MASK_STATUS_ES	BIT(ACC_REG_STATUS_IDX_STATUS_ES)
+#define ACC_REG_STATUS_MASK_STATUS_EP	BIT(ACC_REG_STATUS_IDX_STATUS_EP)
+#define ACC_REG_STATUS_MASK_STATUS_BS	BIT(ACC_REG_STATUS_IDX_STATUS_BS)
+#define ACC_REG_STATUS_MASK_STATUS_RBS	BIT(ACC_REG_STATUS_IDX_STATUS_RBS)
+#define ACC_REG_STATUS_MASK_STATUS_RS	BIT(ACC_REG_STATUS_IDX_STATUS_RS)
+
+static void acc_resetmode_enter(struct acc_core *core)
+{
+	acc_set_bits(core, ACC_CORE_OF_CTRL_MODE,
+		     ACC_REG_CONTROL_MASK_MODE_RESETMODE);
+
+	/* Read back reset mode bit to flush PCI write posting */
+	acc_resetmode_entered(core);
+}
+
+static void acc_resetmode_leave(struct acc_core *core)
+{
+	acc_clear_bits(core, ACC_CORE_OF_CTRL_MODE,
+		       ACC_REG_CONTROL_MASK_MODE_RESETMODE);
+
+	/* Read back reset mode bit to flush PCI write posting */
+	acc_resetmode_entered(core);
+}
+
+static void acc_txq_put(struct acc_core *core, u32 acc_id, u8 acc_dlc,
+			const void *data)
+{
+	acc_write32_noswap(core, ACC_CORE_OF_TXFIFO_DATA_1,
+			   *((const u32 *)(data + 4)));
+	acc_write32_noswap(core, ACC_CORE_OF_TXFIFO_DATA_0,
+			   *((const u32 *)data));
+	acc_write32(core, ACC_CORE_OF_TXFIFO_DLC, acc_dlc);
+	/* CAN id must be written at last. This write starts TX. */
+	acc_write32(core, ACC_CORE_OF_TXFIFO_ID, acc_id);
+}
+
+/* Convert timestamp from esdACC time stamp ticks to ns
+ *
+ * The conversion factor ts2ns from time stamp counts to ns is basically
+ *	ts2ns = NSEC_PER_SEC / timestamp_frequency
+ *
+ * We handle here only a fixed timestamp frequency of 80MHz. The
+ * resulting ts2ns factor would be 12.5.
+ *
+ * At the end we multiply by 12 and add the half of the HW timestamp
+ * to get a multiplication by 12.5. This way any overflow is
+ * avoided until ktime_t itself overflows.
+ */
+#define ACC_TS_FACTOR (NSEC_PER_SEC / ACC_TS_FREQ_80MHZ)
+#define ACC_TS_80MHZ_SHIFT 1
+
+static ktime_t acc_ts2ktime(struct acc_ov *ov, u64 ts)
+{
+	u64 ns;
+
+	ns = (ts * ACC_TS_FACTOR) + (ts >> ACC_TS_80MHZ_SHIFT);
+
+	return ns_to_ktime(ns);
+}
+
+void acc_init_ov(struct acc_ov *ov, struct device *dev)
+{
+	u32 temp;
+
+	temp = acc_ov_read32(ov, ACC_OV_OF_VERSION);
+	ov->version = temp;
+	ov->features = (temp >> 16);
+
+	temp = acc_ov_read32(ov, ACC_OV_OF_INFO);
+	ov->total_cores = temp;
+	ov->active_cores = (temp >> 8);
+
+	ov->core_frequency = acc_ov_read32(ov, ACC_OV_OF_CANCORE_FREQ);
+	ov->timestamp_frequency = acc_ov_read32(ov, ACC_OV_OF_TS_FREQ_LO);
+
+	/* Depending on ESDACC feature NEW_PSC enable the new prescaler
+	 * or adjust core_frequency according to the implicit division by 2.
+	 */
+	if (ov->features & ACC_OV_REG_FEAT_MASK_NEW_PSC) {
+		acc_ov_set_bits(ov, ACC_OV_OF_MODE,
+				ACC_OV_REG_MODE_MASK_NEW_PSC_ENABLE);
+	} else {
+		ov->core_frequency /= 2;
+	}
+
+	dev_info(dev,
+		 "ESDACC v%u, freq: %u/%u, feat/strap: 0x%x/0x%x, cores: %u/%u\n",
+		 ov->version, ov->core_frequency, ov->timestamp_frequency,
+		 ov->features, acc_ov_read32(ov, ACC_OV_OF_INFO) >> 16,
+		 ov->active_cores, ov->total_cores);
+}
+
+void acc_init_bm_ptr(struct acc_ov *ov, struct acc_core *cores, const void *mem)
+{
+	unsigned int u;
+
+	/* DMA buffer layout as follows where N is the number of CAN cores
+	 * implemented in the FPGA, i.e. N = ov->total_cores
+	 *
+	 *   Layout                   Section size
+	 * +-----------------------+
+	 * | FIFO Card/Overview	   |  ACC_CORE_DMABUF_SIZE
+	 * |			   |
+	 * +-----------------------+
+	 * | FIFO Core0		   |  ACC_CORE_DMABUF_SIZE
+	 * |			   |
+	 * +-----------------------+
+	 * | ...		   |  ...
+	 * |			   |
+	 * +-----------------------+
+	 * | FIFO CoreN		   |  ACC_CORE_DMABUF_SIZE
+	 * |			   |
+	 * +-----------------------+
+	 * | irq_cnt Card/Overview |  sizeof(u32)
+	 * +-----------------------+
+	 * | irq_cnt Core0	   |  sizeof(u32)
+	 * +-----------------------+
+	 * | ...		   |  ...
+	 * +-----------------------+
+	 * | irq_cnt CoreN	   |  sizeof(u32)
+	 * +-----------------------+
+	 */
+	ov->bmfifo.messages = mem;
+	ov->bmfifo.irq_cnt = mem + (ov->total_cores + 1U) * ACC_CORE_DMABUF_SIZE;
+
+	for (u = 0U; u < ov->active_cores; u++) {
+		struct acc_core *core = &cores[u];
+
+		core->bmfifo.messages = mem + (u + 1U) * ACC_CORE_DMABUF_SIZE;
+		core->bmfifo.irq_cnt = ov->bmfifo.irq_cnt + (u + 1U);
+	}
+}
+
+int acc_open(struct net_device *netdev)
+{
+	struct acc_net_priv *priv = netdev_priv(netdev);
+	struct acc_core *core = priv->core;
+	u32 tx_fifo_status;
+	u32 ctrl_mode;
+	int err;
+
+	/* Retry to enter RESET mode if out of sync. */
+	if (priv->can.state != CAN_STATE_STOPPED) {
+		netdev_warn(netdev, "Entered %s() with bad can.state: %s\n",
+			    __func__, can_get_state_str(priv->can.state));
+		acc_resetmode_enter(core);
+		priv->can.state = CAN_STATE_STOPPED;
+	}
+
+	err = open_candev(netdev);
+	if (err)
+		return err;
+
+	ctrl_mode = ACC_REG_CONTROL_MASK_IE_RXTX |
+			ACC_REG_CONTROL_MASK_IE_TXERROR |
+			ACC_REG_CONTROL_MASK_IE_ERRWARN |
+			ACC_REG_CONTROL_MASK_IE_OVERRUN |
+			ACC_REG_CONTROL_MASK_IE_ERRPASS;
+
+	if (priv->can.ctrlmode & CAN_CTRLMODE_BERR_REPORTING)
+		ctrl_mode |= ACC_REG_CONTROL_MASK_IE_BUSERR;
+
+	if (priv->can.ctrlmode & CAN_CTRLMODE_LISTENONLY)
+		ctrl_mode |= ACC_REG_CONTROL_MASK_MODE_LOM;
+
+	acc_set_bits(core, ACC_CORE_OF_CTRL_MODE, ctrl_mode);
+
+	acc_resetmode_leave(core);
+	priv->can.state = CAN_STATE_ERROR_ACTIVE;
+
+	/* Resync TX FIFO indices to HW state after (re-)start. */
+	tx_fifo_status = acc_read32(core, ACC_CORE_OF_TXFIFO_STATUS);
+	core->tx_fifo_head = tx_fifo_status & 0xff;
+	core->tx_fifo_tail = (tx_fifo_status >> 8) & 0xff;
+
+	netif_start_queue(netdev);
+	return 0;
+}
+
+int acc_close(struct net_device *netdev)
+{
+	struct acc_net_priv *priv = netdev_priv(netdev);
+	struct acc_core *core = priv->core;
+
+	acc_clear_bits(core, ACC_CORE_OF_CTRL_MODE,
+		       ACC_REG_CONTROL_MASK_IE_RXTX |
+		       ACC_REG_CONTROL_MASK_IE_TXERROR |
+		       ACC_REG_CONTROL_MASK_IE_ERRWARN |
+		       ACC_REG_CONTROL_MASK_IE_OVERRUN |
+		       ACC_REG_CONTROL_MASK_IE_ERRPASS |
+		       ACC_REG_CONTROL_MASK_IE_BUSERR);
+
+	netif_stop_queue(netdev);
+	acc_resetmode_enter(core);
+	priv->can.state = CAN_STATE_STOPPED;
+
+	/* Mark pending TX requests to be aborted after controller restart. */
+	acc_write32(core, ACC_CORE_OF_TX_ABORT_MASK, 0xffff);
+
+	/* ACC_REG_CONTROL_MASK_MODE_LOM is only accessible in RESET mode */
+	acc_clear_bits(core, ACC_CORE_OF_CTRL_MODE,
+		       ACC_REG_CONTROL_MASK_MODE_LOM);
+
+	close_candev(netdev);
+	return 0;
+}
+
+netdev_tx_t acc_start_xmit(struct sk_buff *skb, struct net_device *netdev)
+{
+	struct acc_net_priv *priv = netdev_priv(netdev);
+	struct acc_core *core = priv->core;
+	struct can_frame *cf = (struct can_frame *)skb->data;
+	u8 tx_fifo_head = core->tx_fifo_head;
+	int fifo_usage;
+	u32 acc_id;
+	u8 acc_dlc;
+
+	if (can_dropped_invalid_skb(netdev, skb))
+		return NETDEV_TX_OK;
+
+	/* Access core->tx_fifo_tail only once because it may be changed
+	 * from the interrupt level.
+	 */
+	fifo_usage = tx_fifo_head - core->tx_fifo_tail;
+	if (fifo_usage < 0)
+		fifo_usage += core->tx_fifo_size;
+
+	if (fifo_usage >= core->tx_fifo_size - 1) {
+		netdev_err(core->netdev,
+			   "BUG: TX ring full when queue awake!\n");
+		netif_stop_queue(netdev);
+		return NETDEV_TX_BUSY;
+	}
+
+	if (fifo_usage == core->tx_fifo_size - 2)
+		netif_stop_queue(netdev);
+
+	acc_dlc = can_get_cc_dlc(cf, priv->can.ctrlmode);
+	if (cf->can_id & CAN_RTR_FLAG)
+		acc_dlc |= ACC_CAN_RTR_FLAG;
+
+	if (cf->can_id & CAN_EFF_FLAG) {
+		acc_id = cf->can_id & CAN_EFF_MASK;
+		acc_id |= ACC_CAN_EFF_FLAG;
+	} else {
+		acc_id = cf->can_id & CAN_SFF_MASK;
+	}
+
+	can_put_echo_skb(skb, netdev, core->tx_fifo_head, 0);
+
+	tx_fifo_head++;
+	if (tx_fifo_head >= core->tx_fifo_size)
+		tx_fifo_head = 0U;
+	core->tx_fifo_head = tx_fifo_head;
+
+	acc_txq_put(core, acc_id, acc_dlc, cf->data);
+
+	return NETDEV_TX_OK;
+}
+
+int acc_get_berr_counter(const struct net_device *netdev,
+			 struct can_berr_counter *bec)
+{
+	struct acc_net_priv *priv = netdev_priv(netdev);
+	u32 core_status = acc_read32(priv->core, ACC_CORE_OF_STATUS);
+
+	bec->txerr = (core_status >> 8) & 0xff;
+	bec->rxerr = core_status & 0xff;
+
+	return 0;
+}
+
+int acc_set_mode(struct net_device *netdev, enum can_mode mode)
+{
+	struct acc_net_priv *priv = netdev_priv(netdev);
+
+	switch (mode) {
+	case CAN_MODE_START:
+		/* Paranoid FIFO index check. */
+		{
+			const u32 tx_fifo_status =
+				acc_read32(priv->core, ACC_CORE_OF_TXFIFO_STATUS);
+			const u8 hw_fifo_head = tx_fifo_status;
+
+			if (hw_fifo_head != priv->core->tx_fifo_head ||
+			    hw_fifo_head != priv->core->tx_fifo_tail) {
+				netdev_warn(netdev,
+					    "TX FIFO mismatch: T %2u H %2u; TFHW %#08x\n",
+					    priv->core->tx_fifo_tail,
+					    priv->core->tx_fifo_head,
+					    tx_fifo_status);
+			}
+		}
+		acc_resetmode_leave(priv->core);
+		/* To leave the bus-off state the esdACC controller begins
+		 * here a grace period where it counts 128 "idle conditions" (each
+		 * of 11 consecutive recessive bits) on the bus as required
+		 * by the CAN spec.
+		 *
+		 * During this time the TX FIFO may still contain already
+		 * aborted "zombie" frames that are only drained from the FIFO
+		 * at the end of the grace period.
+		 *
+		 * To not to interfere with this drain process we don't
+		 * call netif_wake_queue() here. When the controller reaches
+		 * the error-active state again, it informs us about that
+		 * with an acc_bmmsg_errstatechange message. Then
+		 * netif_wake_queue() is called from
+		 * handle_core_msg_errstatechange() instead.
+		 */
+		break;
+
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+int acc_set_bittiming(struct net_device *netdev)
+{
+	struct acc_net_priv *priv = netdev_priv(netdev);
+	const struct can_bittiming *bt = &priv->can.bittiming;
+	u32 brp;
+	u32 btr;
+
+	if (priv->ov->features & ACC_OV_REG_FEAT_MASK_CANFD) {
+		u32 fbtr = 0;
+
+		netdev_dbg(netdev, "bit timing: brp %u, prop %u, ph1 %u ph2 %u, sjw %u\n",
+			   bt->brp, bt->prop_seg,
+			   bt->phase_seg1, bt->phase_seg2, bt->sjw);
+
+		brp = FIELD_PREP(ACC_REG_BRP_FD_MASK_BRP, bt->brp - 1);
+
+		btr = FIELD_PREP(ACC_REG_BTR_FD_MASK_TSEG1, bt->phase_seg1 + bt->prop_seg - 1);
+		btr |= FIELD_PREP(ACC_REG_BTR_FD_MASK_TSEG2, bt->phase_seg2 - 1);
+		btr |= FIELD_PREP(ACC_REG_BTR_FD_MASK_SJW, bt->sjw - 1);
+
+		/* Keep order of accesses to ACC_CORE_OF_BRP and ACC_CORE_OF_BTR. */
+		acc_write32(priv->core, ACC_CORE_OF_BRP, brp);
+		acc_write32(priv->core, ACC_CORE_OF_BTR, btr);
+
+		netdev_dbg(netdev, "ESDACC: BRP %u, NBTR 0x%08x, DBTR 0x%08x",
+			   brp, btr, fbtr);
+	} else {
+		netdev_dbg(netdev, "bit timing: brp %u, prop %u, ph1 %u ph2 %u, sjw %u\n",
+			   bt->brp, bt->prop_seg,
+			   bt->phase_seg1, bt->phase_seg2, bt->sjw);
+
+		brp = FIELD_PREP(ACC_REG_BRP_CL_MASK_BRP, bt->brp - 1);
+
+		btr = FIELD_PREP(ACC_REG_BTR_CL_MASK_TSEG1, bt->phase_seg1 + bt->prop_seg - 1);
+		btr |= FIELD_PREP(ACC_REG_BTR_CL_MASK_TSEG2, bt->phase_seg2 - 1);
+		btr |= FIELD_PREP(ACC_REG_BTR_CL_MASK_SJW, bt->sjw - 1);
+
+		/* Keep order of accesses to ACC_CORE_OF_BRP and ACC_CORE_OF_BTR. */
+		acc_write32(priv->core, ACC_CORE_OF_BRP, brp);
+		acc_write32(priv->core, ACC_CORE_OF_BTR, btr);
+
+		netdev_dbg(netdev, "ESDACC: BRP %u, BTR 0x%08x", brp, btr);
+	}
+
+	return 0;
+}
+
+static void handle_core_msg_rxtxdone(struct acc_core *core,
+				     const struct acc_bmmsg_rxtxdone *msg)
+{
+	struct acc_net_priv *priv = netdev_priv(core->netdev);
+	struct net_device_stats *stats = &core->netdev->stats;
+	struct sk_buff *skb;
+
+	if (msg->dlc.rxtx.len & ACC_BM_LENFLAG_TX) {
+		u8 tx_fifo_tail = core->tx_fifo_tail;
+
+		if (core->tx_fifo_head == tx_fifo_tail) {
+			netdev_warn(core->netdev,
+				    "TX interrupt, but queue is empty!?\n");
+			return;
+		}
+
+		/* Direct access echo skb to attach HW time stamp. */
+		skb = priv->can.echo_skb[tx_fifo_tail];
+		if (skb) {
+			skb_hwtstamps(skb)->hwtstamp =
+				acc_ts2ktime(priv->ov, msg->ts);
+		}
+
+		stats->tx_packets++;
+		stats->tx_bytes += can_get_echo_skb(core->netdev, tx_fifo_tail,
+						    NULL);
+
+		tx_fifo_tail++;
+		if (tx_fifo_tail >= core->tx_fifo_size)
+			tx_fifo_tail = 0U;
+		core->tx_fifo_tail = tx_fifo_tail;
+
+		netif_wake_queue(core->netdev);
+
+	} else {
+		struct can_frame *cf;
+
+		skb = alloc_can_skb(core->netdev, &cf);
+		if (!skb) {
+			stats->rx_dropped++;
+			return;
+		}
+
+		cf->can_id = msg->id & CAN_EFF_MASK;
+		if (msg->id & ACC_CAN_EFF_FLAG)
+			cf->can_id |= CAN_EFF_FLAG;
+
+		can_frame_set_cc_len(cf, msg->dlc.rx.len & ACC_CAN_DLC_MASK,
+				     priv->can.ctrlmode);
+
+		if (msg->dlc.rx.len & ACC_CAN_RTR_FLAG) {
+			cf->can_id |= CAN_RTR_FLAG;
+		} else {
+			memcpy(cf->data, msg->data, cf->len);
+			stats->rx_bytes += cf->len;
+		}
+		stats->rx_packets++;
+
+		skb_hwtstamps(skb)->hwtstamp = acc_ts2ktime(priv->ov, msg->ts);
+
+		netif_rx(skb);
+	}
+}
+
+static void handle_core_msg_txabort(struct acc_core *core,
+				    const struct acc_bmmsg_txabort *msg)
+{
+	struct net_device_stats *stats = &core->netdev->stats;
+	u8 tx_fifo_tail = core->tx_fifo_tail;
+	u32 abort_mask = msg->abort_mask;   /* u32 extend to avoid warnings later */
+
+	/* The abort_mask shows which frames were aborted in ESDACC's FIFO. */
+	while (tx_fifo_tail != core->tx_fifo_head && (abort_mask)) {
+		const u32 tail_mask = (1U << tx_fifo_tail);
+
+		if (!(abort_mask & tail_mask))
+			break;
+		abort_mask &= ~tail_mask;
+
+		can_free_echo_skb(core->netdev, tx_fifo_tail, NULL);
+		stats->tx_dropped++;
+		stats->tx_aborted_errors++;
+
+		tx_fifo_tail++;
+		if (tx_fifo_tail >= core->tx_fifo_size)
+			tx_fifo_tail = 0;
+	}
+	core->tx_fifo_tail = tx_fifo_tail;
+	if (abort_mask)
+		netdev_warn(core->netdev, "Unhandled aborted messages\n");
+
+	if (!acc_resetmode_entered(core))
+		netif_wake_queue(core->netdev);
+}
+
+static void handle_core_msg_overrun(struct acc_core *core,
+				    const struct acc_bmmsg_overrun *msg)
+{
+	struct acc_net_priv *priv = netdev_priv(core->netdev);
+	struct net_device_stats *stats = &core->netdev->stats;
+	struct can_frame *cf;
+	struct sk_buff *skb;
+
+	/* lost_cnt may be 0 if not supported by ESDACC version */
+	if (msg->lost_cnt) {
+		stats->rx_errors += msg->lost_cnt;
+		stats->rx_over_errors += msg->lost_cnt;
+	} else {
+		stats->rx_errors++;
+		stats->rx_over_errors++;
+	}
+
+	skb = alloc_can_err_skb(core->netdev, &cf);
+	if (!skb) {
+		stats->rx_dropped++;
+		return;
+	}
+
+	cf->can_id |= CAN_ERR_CRTL;
+	cf->data[1] = CAN_ERR_CRTL_RX_OVERFLOW;
+
+	skb_hwtstamps(skb)->hwtstamp = acc_ts2ktime(priv->ov, msg->ts);
+
+	netif_rx(skb);
+}
+
+static void handle_core_msg_buserr(struct acc_core *core,
+				   const struct acc_bmmsg_buserr *msg)
+{
+	struct acc_net_priv *priv = netdev_priv(core->netdev);
+	struct net_device_stats *stats = &core->netdev->stats;
+	struct can_frame *cf;
+	struct sk_buff *skb;
+	const u32 reg_status = msg->reg_status;
+	const u8 rxerr = reg_status;
+	const u8 txerr = (reg_status >> 8);
+	u8 can_err_prot_type = 0U;
+
+	priv->can.can_stats.bus_error++;
+
+	/* Error occurred during transmission? */
+	if ((msg->ecc & ACC_ECC_DIR) == 0) {
+		can_err_prot_type |= CAN_ERR_PROT_TX;
+		stats->tx_errors++;
+	} else {
+		stats->rx_errors++;
+	}
+	/* Determine error type */
+	switch (msg->ecc & ACC_ECC_MASK) {
+	case ACC_ECC_BIT:
+		can_err_prot_type |= CAN_ERR_PROT_BIT;
+		break;
+	case ACC_ECC_FORM:
+		can_err_prot_type |= CAN_ERR_PROT_FORM;
+		break;
+	case ACC_ECC_STUFF:
+		can_err_prot_type |= CAN_ERR_PROT_STUFF;
+		break;
+	default:
+		can_err_prot_type |= CAN_ERR_PROT_UNSPEC;
+		break;
+	}
+
+	skb = alloc_can_err_skb(core->netdev, &cf);
+	if (!skb) {
+		stats->rx_dropped++;
+		return;
+	}
+
+	cf->can_id |= CAN_ERR_PROT | CAN_ERR_BUSERROR;
+
+	/* Set protocol error type */
+	cf->data[2] = can_err_prot_type;
+	/* Set error location */
+	cf->data[3] = msg->ecc & ACC_ECC_SEG;
+
+	/* Insert CAN TX and RX error counters. */
+	cf->data[6] = txerr;
+	cf->data[7] = rxerr;
+
+	skb_hwtstamps(skb)->hwtstamp = acc_ts2ktime(priv->ov, msg->ts);
+
+	netif_rx(skb);
+}
+
+static void
+handle_core_msg_errstatechange(struct acc_core *core,
+			       const struct acc_bmmsg_errstatechange *msg)
+{
+	struct acc_net_priv *priv = netdev_priv(core->netdev);
+	struct net_device_stats *stats = &core->netdev->stats;
+	struct can_frame *cf = NULL;
+	struct sk_buff *skb;
+	const u32 reg_status = msg->reg_status;
+	const u8 rxerr = reg_status;
+	const u8 txerr = (reg_status >> 8);
+	enum can_state new_state;
+
+	if (reg_status & ACC_REG_STATUS_MASK_STATUS_BS) {
+		new_state = CAN_STATE_BUS_OFF;
+	} else if (reg_status & ACC_REG_STATUS_MASK_STATUS_EP) {
+		new_state = CAN_STATE_ERROR_PASSIVE;
+	} else if (reg_status & ACC_REG_STATUS_MASK_STATUS_ES) {
+		new_state = CAN_STATE_ERROR_WARNING;
+	} else {
+		new_state = CAN_STATE_ERROR_ACTIVE;
+		if (priv->can.state == CAN_STATE_BUS_OFF) {
+			/* See comment in acc_set_mode() for CAN_MODE_START */
+			netif_wake_queue(core->netdev);
+		}
+	}
+
+	skb = alloc_can_err_skb(core->netdev, &cf);
+
+	if (new_state != priv->can.state) {
+		enum can_state tx_state, rx_state;
+
+		tx_state = (txerr >= rxerr) ?
+			new_state : CAN_STATE_ERROR_ACTIVE;
+		rx_state = (rxerr >= txerr) ?
+			new_state : CAN_STATE_ERROR_ACTIVE;
+
+		/* Always call can_change_state() to update the state
+		 * even if alloc_can_err_skb() may have failed.
+		 * can_change_state() can cope with a NULL cf pointer.
+		 */
+		can_change_state(core->netdev, cf, tx_state, rx_state);
+	}
+
+	if (skb) {
+		cf->data[6] = txerr;
+		cf->data[7] = rxerr;
+
+		skb_hwtstamps(skb)->hwtstamp = acc_ts2ktime(priv->ov, msg->ts);
+
+		netif_rx(skb);
+	} else {
+		stats->rx_dropped++;
+	}
+
+	if (new_state == CAN_STATE_BUS_OFF) {
+		acc_write32(core, ACC_CORE_OF_TX_ABORT_MASK, 0xffff);
+		can_bus_off(core->netdev);
+	}
+}
+
+static void handle_core_interrupt(struct acc_core *core)
+{
+	u32 msg_fifo_head = core->bmfifo.local_irq_cnt & 0xff;
+
+	while (core->bmfifo.msg_fifo_tail != msg_fifo_head) {
+		const union acc_bmmsg *msg =
+			&core->bmfifo.messages[core->bmfifo.msg_fifo_tail];
+
+		switch (msg->msg_id) {
+		case BM_MSG_ID_RXTXDONE:
+			handle_core_msg_rxtxdone(core, &msg->rxtxdone);
+			break;
+
+		case BM_MSG_ID_TXABORT:
+			handle_core_msg_txabort(core, &msg->txabort);
+			break;
+
+		case BM_MSG_ID_OVERRUN:
+			handle_core_msg_overrun(core, &msg->overrun);
+			break;
+
+		case BM_MSG_ID_BUSERR:
+			handle_core_msg_buserr(core, &msg->buserr);
+			break;
+
+		case BM_MSG_ID_ERRPASSIVE:
+		case BM_MSG_ID_ERRWARN:
+			handle_core_msg_errstatechange(core,
+						       &msg->errstatechange);
+			break;
+
+		default:
+			/* Ignore all other BM messages (like the CAN-FD messages) */
+			break;
+		}
+
+		core->bmfifo.msg_fifo_tail =
+				(core->bmfifo.msg_fifo_tail + 1) & 0xff;
+	}
+}
+
+/**
+ * acc_card_interrupt() - handle the interrupts of an esdACC FPGA
+ *
+ * @ov: overview module structure
+ * @cores: array of core structures
+ *
+ * This function handles all interrupts pending for the overview module and the
+ * CAN cores of the esdACC FPGA.
+ *
+ * It examines for all cores (the overview module core and the CAN cores)
+ * the bmfifo.irq_cnt and compares it with the previously saved
+ * bmfifo.local_irq_cnt. An IRQ is pending if they differ. The esdACC FPGA
+ * updates the bmfifo.irq_cnt values by DMA.
+ *
+ * The pending interrupts are masked by writing to the IRQ mask register at
+ * ACC_OV_OF_BM_IRQ_MASK. This register has for each core a two bit command
+ * field evaluated as follows:
+ *
+ * Define,   bit pattern: meaning
+ *                    00: no action
+ * ACC_BM_IRQ_UNMASK, 01: unmask interrupt
+ * ACC_BM_IRQ_MASK,   10: mask interrupt
+ *                    11: no action
+ *
+ * For each CAN core with a pending IRQ handle_core_interrupt() handles all
+ * busmaster messages from the message FIFO. The last handled message (FIFO
+ * index) is written to the CAN core to acknowledge its handling.
+ *
+ * Last step is to unmask all interrupts in the FPGA using
+ * ACC_BM_IRQ_UNMASK_ALL.
+ */
+irqreturn_t acc_card_interrupt(struct acc_ov *ov, struct acc_core *cores)
+{
+	u32 irqmask;
+	int i;
+
+	/* First we look for whom interrupts are pending, card/overview
+	 * or any of the cores. Two bits in irqmask are used for each;
+	 * Each two bit field is set to ACC_BM_IRQ_MASK if an IRQ is
+	 * pending.
+	 */
+	irqmask = 0;
+	if (READ_ONCE(*ov->bmfifo.irq_cnt) != ov->bmfifo.local_irq_cnt) {
+		irqmask |= ACC_BM_IRQ_MASK;
+		ov->bmfifo.local_irq_cnt = READ_ONCE(*ov->bmfifo.irq_cnt);
+	}
+
+	for (i = 0; i < ov->active_cores; i++) {
+		struct acc_core *core = &cores[i];
+
+		if (READ_ONCE(*core->bmfifo.irq_cnt) != core->bmfifo.local_irq_cnt) {
+			irqmask |= (ACC_BM_IRQ_MASK << (2 * (i + 1)));
+			core->bmfifo.local_irq_cnt = READ_ONCE(*core->bmfifo.irq_cnt);
+		}
+	}
+
+	if (!irqmask)
+		return IRQ_NONE;
+
+	/* At second we tell the card we're working on them by writing irqmask,
+	 * call handle_{ov|core}_interrupt and then acknowledge the
+	 * interrupts by writing irq_cnt:
+	 */
+	acc_ov_write32(ov, ACC_OV_OF_BM_IRQ_MASK, irqmask);
+
+	if (irqmask & ACC_BM_IRQ_MASK) {
+		/* handle_ov_interrupt(); - no use yet. */
+		acc_ov_write32(ov, ACC_OV_OF_BM_IRQ_COUNTER,
+			       ov->bmfifo.local_irq_cnt);
+	}
+
+	for (i = 0; i < ov->active_cores; i++) {
+		struct acc_core *core = &cores[i];
+
+		if (irqmask & (ACC_BM_IRQ_MASK << (2 * (i + 1)))) {
+			handle_core_interrupt(core);
+			acc_write32(core, ACC_OV_OF_BM_IRQ_COUNTER,
+				    core->bmfifo.local_irq_cnt);
+		}
+	}
+
+	acc_ov_write32(ov, ACC_OV_OF_BM_IRQ_MASK, ACC_BM_IRQ_UNMASK_ALL);
+
+	return IRQ_HANDLED;
+}
diff --git a/drivers/net/can/esd/esdacc.h b/drivers/net/can/esd/esdacc.h
new file mode 100644
index 000000000000..73651bc1d52c
--- /dev/null
+++ b/drivers/net/can/esd/esdacc.h
@@ -0,0 +1,393 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright (C) 2015 - 2016 Thomas Körper, esd electronic system design gmbh
+ * Copyright (C) 2017 - 2022 Stefan Mätje, esd electronics gmbh
+ */
+
+#include <linux/bits.h>
+#include <linux/can/dev.h>
+#include <linux/kernel.h>
+#include <linux/netdevice.h>
+#include <linux/units.h>
+
+#define ACC_TS_FREQ_80MHZ			(80 * HZ_PER_MHZ)
+
+#define ACC_CAN_EFF_FLAG			0x20000000
+#define ACC_CAN_RTR_FLAG			0x10
+#define ACC_CAN_DLC_MASK			0x0f
+
+#define ACC_OV_OF_PROBE				0x0000
+#define ACC_OV_OF_VERSION			0x0004
+#define ACC_OV_OF_INFO				0x0008
+#define ACC_OV_OF_CANCORE_FREQ			0x000c
+#define ACC_OV_OF_TS_FREQ_LO			0x0010
+#define ACC_OV_OF_TS_FREQ_HI			0x0014
+#define ACC_OV_OF_IRQ_STATUS_CORES		0x0018
+#define ACC_OV_OF_TS_CURR_LO			0x001c
+#define ACC_OV_OF_TS_CURR_HI			0x0020
+#define ACC_OV_OF_IRQ_STATUS			0x0028
+#define ACC_OV_OF_MODE				0x002c
+#define ACC_OV_OF_BM_IRQ_COUNTER		0x0070
+#define ACC_OV_OF_BM_IRQ_MASK			0x0074
+#define ACC_OV_OF_MSI_DATA			0x0080
+#define ACC_OV_OF_MSI_ADDRESSOFFSET		0x0084
+
+/* Feature flags are contained in the upper 16 bit of the version
+ * register at ACC_OV_OF_VERSION but only used with these masks after
+ * extraction into an extra variable => (xx - 16).
+ */
+#define ACC_OV_REG_FEAT_IDX_CANFD		(27 - 16)
+#define ACC_OV_REG_FEAT_IDX_NEW_PSC		(28 - 16)
+#define ACC_OV_REG_FEAT_MASK_CANFD		BIT(ACC_OV_REG_FEAT_IDX_CANFD)
+#define ACC_OV_REG_FEAT_MASK_NEW_PSC		BIT(ACC_OV_REG_FEAT_IDX_NEW_PSC)
+
+#define ACC_OV_REG_MODE_MASK_ENDIAN_LITTLE	0x00000001
+#define ACC_OV_REG_MODE_MASK_BM_ENABLE		0x00000002
+#define ACC_OV_REG_MODE_MASK_MODE_LED		0x00000004
+#define ACC_OV_REG_MODE_MASK_TIMER		0x00000070
+#define ACC_OV_REG_MODE_MASK_TIMER_ENABLE	0x00000010
+#define ACC_OV_REG_MODE_MASK_TIMER_ONE_SHOT	0x00000020
+#define ACC_OV_REG_MODE_MASK_TIMER_ABSOLUTE	0x00000040
+#define ACC_OV_REG_MODE_MASK_TS_SRC		0x00000180
+#define ACC_OV_REG_MODE_MASK_I2C_ENABLE		0x00000800
+#define ACC_OV_REG_MODE_MASK_MSI_ENABLE		0x00004000
+#define ACC_OV_REG_MODE_MASK_NEW_PSC_ENABLE	0x00008000
+#define ACC_OV_REG_MODE_MASK_FPGA_RESET		0x80000000
+
+#define ACC_CORE_OF_CTRL_MODE			0x0000
+#define ACC_CORE_OF_STATUS_IRQ			0x0008
+#define ACC_CORE_OF_BRP				0x000c
+#define ACC_CORE_OF_BTR				0x0010
+#define ACC_CORE_OF_FBTR			0x0014
+#define ACC_CORE_OF_STATUS			0x0030
+#define ACC_CORE_OF_TXFIFO_CONFIG		0x0048
+#define ACC_CORE_OF_TXFIFO_STATUS		0x004c
+#define ACC_CORE_OF_TX_STATUS_IRQ		0x0050
+#define ACC_CORE_OF_TX_ABORT_MASK		0x0054
+#define ACC_CORE_OF_BM_IRQ_COUNTER		0x0070
+#define ACC_CORE_OF_TXFIFO_ID			0x00c0
+#define ACC_CORE_OF_TXFIFO_DLC			0x00c4
+#define ACC_CORE_OF_TXFIFO_DATA_0		0x00c8
+#define ACC_CORE_OF_TXFIFO_DATA_1		0x00cc
+
+#define ACC_REG_CONTROL_IDX_MODE_RESETMODE	0
+#define ACC_REG_CONTROL_IDX_MODE_LOM		1
+#define ACC_REG_CONTROL_IDX_MODE_STM		2
+#define ACC_REG_CONTROL_IDX_MODE_TRANSEN	5
+#define ACC_REG_CONTROL_IDX_MODE_TS		6
+#define ACC_REG_CONTROL_IDX_MODE_SCHEDULE	7
+#define ACC_REG_CONTROL_MASK_MODE_RESETMODE	\
+				BIT(ACC_REG_CONTROL_IDX_MODE_RESETMODE)
+#define ACC_REG_CONTROL_MASK_MODE_LOM		\
+				BIT(ACC_REG_CONTROL_IDX_MODE_LOM)
+#define ACC_REG_CONTROL_MASK_MODE_STM		\
+				BIT(ACC_REG_CONTROL_IDX_MODE_STM)
+#define ACC_REG_CONTROL_MASK_MODE_TRANSEN	\
+				BIT(ACC_REG_CONTROL_IDX_MODE_TRANSEN)
+#define ACC_REG_CONTROL_MASK_MODE_TS		\
+				BIT(ACC_REG_CONTROL_IDX_MODE_TS)
+#define ACC_REG_CONTROL_MASK_MODE_SCHEDULE	\
+				BIT(ACC_REG_CONTROL_IDX_MODE_SCHEDULE)
+
+#define ACC_REG_CONTROL_IDX_IE_RXTX	8
+#define ACC_REG_CONTROL_IDX_IE_TXERROR	9
+#define ACC_REG_CONTROL_IDX_IE_ERRWARN	10
+#define ACC_REG_CONTROL_IDX_IE_OVERRUN	11
+#define ACC_REG_CONTROL_IDX_IE_TSI	12
+#define ACC_REG_CONTROL_IDX_IE_ERRPASS	13
+#define ACC_REG_CONTROL_IDX_IE_BUSERR	15
+#define ACC_REG_CONTROL_MASK_IE_RXTX	BIT(ACC_REG_CONTROL_IDX_IE_RXTX)
+#define ACC_REG_CONTROL_MASK_IE_TXERROR BIT(ACC_REG_CONTROL_IDX_IE_TXERROR)
+#define ACC_REG_CONTROL_MASK_IE_ERRWARN BIT(ACC_REG_CONTROL_IDX_IE_ERRWARN)
+#define ACC_REG_CONTROL_MASK_IE_OVERRUN BIT(ACC_REG_CONTROL_IDX_IE_OVERRUN)
+#define ACC_REG_CONTROL_MASK_IE_TSI	BIT(ACC_REG_CONTROL_IDX_IE_TSI)
+#define ACC_REG_CONTROL_MASK_IE_ERRPASS BIT(ACC_REG_CONTROL_IDX_IE_ERRPASS)
+#define ACC_REG_CONTROL_MASK_IE_BUSERR	BIT(ACC_REG_CONTROL_IDX_IE_BUSERR)
+
+/* BRP and BTR register layout for CAN-Classic version */
+#define ACC_REG_BRP_CL_MASK_BRP         GENMASK(8, 0)
+#define ACC_REG_BTR_CL_MASK_TSEG1       GENMASK(3, 0)
+#define ACC_REG_BTR_CL_MASK_TSEG2       GENMASK(18, 16)
+#define ACC_REG_BTR_CL_MASK_SJW         GENMASK(25, 24)
+
+/* BRP and BTR register layout for CAN-FD version */
+#define ACC_REG_BRP_FD_MASK_BRP         GENMASK(7, 0)
+#define ACC_REG_BTR_FD_MASK_TSEG1       GENMASK(7, 0)
+#define ACC_REG_BTR_FD_MASK_TSEG2       GENMASK(22, 16)
+#define ACC_REG_BTR_FD_MASK_SJW         GENMASK(30, 24)
+
+/* 256 BM_MSGs of 32 byte size */
+#define ACC_CORE_DMAMSG_SIZE		32U
+#define ACC_CORE_DMABUF_SIZE		(256U * ACC_CORE_DMAMSG_SIZE)
+
+enum acc_bmmsg_id {
+	BM_MSG_ID_RXTXDONE = 0x01,
+	BM_MSG_ID_TXABORT = 0x02,
+	BM_MSG_ID_OVERRUN = 0x03,
+	BM_MSG_ID_BUSERR = 0x04,
+	BM_MSG_ID_ERRPASSIVE = 0x05,
+	BM_MSG_ID_ERRWARN = 0x06,
+	BM_MSG_ID_TIMESLICE = 0x07,
+	BM_MSG_ID_HWTIMER = 0x08,
+	BM_MSG_ID_HOTPLUG = 0x09,
+};
+
+/* The struct acc_bmmsg_* structure declarations that follow here provide
+ * access to the ring buffer of bus master messages maintained by the FPGA
+ * bus master engine. All bus master messages have the same size of
+ * ACC_CORE_DMAMSG_SIZE and a minimum alignment of ACC_CORE_DMAMSG_SIZE in
+ * memory.
+ *
+ * All structure members are natural aligned. Therefore we should not need
+ * a __packed attribute. All struct acc_bmmsg_* declarations have at least
+ * reserved* members to fill the structure to the full ACC_CORE_DMAMSG_SIZE.
+ *
+ * A failure of this property due padding will be detected at compile time
+ * by static_assert(sizeof(union acc_bmmsg) == ACC_CORE_DMAMSG_SIZE).
+ */
+
+struct acc_bmmsg_rxtxdone {
+	u8 msg_id;
+	u8 txfifo_level;
+	u8 reserved1[2];
+	u8 txtsfifo_level;
+	u8 reserved2[3];
+	u32 id;
+	union {
+		struct {
+			u8 len;
+			u8 reserved0;
+			u8 bits;
+			u8 state;
+		} rxtx;
+		struct {
+			u8 len;
+			u8 msg_lost;
+			u8 bits;
+			u8 state;
+		} rx;
+		struct {
+			u8 len;
+			u8 txfifo_idx;
+			u8 bits;
+			u8 state;
+		} tx;
+	} dlc;
+	u8 data[8];
+	/* Time stamps in struct acc_ov::timestamp_frequency ticks. */
+	u64 ts;
+};
+
+struct acc_bmmsg_txabort {
+	u8 msg_id;
+	u8 txfifo_level;
+	u16 abort_mask;
+	u8 txtsfifo_level;
+	u8 reserved2[1];
+	u16 abort_mask_txts;
+	u64 ts;
+	u32 reserved3[4];
+};
+
+struct acc_bmmsg_overrun {
+	u8 msg_id;
+	u8 txfifo_level;
+	u8 lost_cnt;
+	u8 reserved1;
+	u8 txtsfifo_level;
+	u8 reserved2[3];
+	u64 ts;
+	u32 reserved3[4];
+};
+
+struct acc_bmmsg_buserr {
+	u8 msg_id;
+	u8 txfifo_level;
+	u8 ecc;
+	u8 reserved1;
+	u8 txtsfifo_level;
+	u8 reserved2[3];
+	u64 ts;
+	u32 reg_status;
+	u32 reg_btr;
+	u32 reserved3[2];
+};
+
+struct acc_bmmsg_errstatechange {
+	u8 msg_id;
+	u8 txfifo_level;
+	u8 reserved1[2];
+	u8 txtsfifo_level;
+	u8 reserved2[3];
+	u64 ts;
+	u32 reg_status;
+	u32 reserved3[3];
+};
+
+struct acc_bmmsg_timeslice {
+	u8 msg_id;
+	u8 txfifo_level;
+	u8 reserved1[2];
+	u8 txtsfifo_level;
+	u8 reserved2[3];
+	u64 ts;
+	u32 reserved3[4];
+};
+
+struct acc_bmmsg_hwtimer {
+	u8 msg_id;
+	u8 reserved1[3];
+	u32 reserved2[1];
+	u64 timer;
+	u32 reserved3[4];
+};
+
+struct acc_bmmsg_hotplug {
+	u8 msg_id;
+	u8 reserved1[3];
+	u32 reserved2[7];
+};
+
+union acc_bmmsg {
+	u8 msg_id;
+	struct acc_bmmsg_rxtxdone rxtxdone;
+	struct acc_bmmsg_txabort txabort;
+	struct acc_bmmsg_overrun overrun;
+	struct acc_bmmsg_buserr buserr;
+	struct acc_bmmsg_errstatechange errstatechange;
+	struct acc_bmmsg_timeslice timeslice;
+	struct acc_bmmsg_hwtimer hwtimer;
+};
+
+/* Check size of union acc_bmmsg to be of expected size. */
+static_assert(sizeof(union acc_bmmsg) == ACC_CORE_DMAMSG_SIZE);
+
+struct acc_bmfifo {
+	const union acc_bmmsg *messages;
+	/* irq_cnt points to an u32 value where the ESDACC FPGA deposits
+	 * the bm_fifo head index in coherent DMA memory. Only bits 7..0
+	 * are valid. Use READ_ONCE() to access this memory location.
+	 */
+	const u32 *irq_cnt;
+	u32 local_irq_cnt;
+	u32 msg_fifo_tail;
+};
+
+struct acc_core {
+	void __iomem *addr;
+	struct net_device *netdev;
+	struct acc_bmfifo bmfifo;
+	u8 tx_fifo_size;
+	u8 tx_fifo_head;
+	u8 tx_fifo_tail;
+};
+
+struct acc_ov {
+	void __iomem *addr;
+	struct acc_bmfifo bmfifo;
+	u32 timestamp_frequency;
+	u32 core_frequency;
+	u16 version;
+	u16 features;
+	u8 total_cores;
+	u8 active_cores;
+};
+
+struct acc_net_priv {
+	struct can_priv can; /* must be the first member! */
+	struct acc_core *core;
+	struct acc_ov *ov;
+};
+
+static inline u32 acc_read32(struct acc_core *core, unsigned short offs)
+{
+	return ioread32be(core->addr + offs);
+}
+
+static inline void acc_write32(struct acc_core *core,
+			       unsigned short offs, u32 v)
+{
+	iowrite32be(v, core->addr + offs);
+}
+
+static inline void acc_write32_noswap(struct acc_core *core,
+				      unsigned short offs, u32 v)
+{
+	iowrite32(v, core->addr + offs);
+}
+
+static inline void acc_set_bits(struct acc_core *core,
+				unsigned short offs, u32 mask)
+{
+	u32 v = acc_read32(core, offs);
+
+	v |= mask;
+	acc_write32(core, offs, v);
+}
+
+static inline void acc_clear_bits(struct acc_core *core,
+				  unsigned short offs, u32 mask)
+{
+	u32 v = acc_read32(core, offs);
+
+	v &= ~mask;
+	acc_write32(core, offs, v);
+}
+
+static inline int acc_resetmode_entered(struct acc_core *core)
+{
+	u32 ctrl = acc_read32(core, ACC_CORE_OF_CTRL_MODE);
+
+	return (ctrl & ACC_REG_CONTROL_MASK_MODE_RESETMODE) != 0;
+}
+
+static inline u32 acc_ov_read32(struct acc_ov *ov, unsigned short offs)
+{
+	return ioread32be(ov->addr + offs);
+}
+
+static inline void acc_ov_write32(struct acc_ov *ov,
+				  unsigned short offs, u32 v)
+{
+	iowrite32be(v, ov->addr + offs);
+}
+
+static inline void acc_ov_set_bits(struct acc_ov *ov,
+				   unsigned short offs, u32 b)
+{
+	u32 v = acc_ov_read32(ov, offs);
+
+	v |= b;
+	acc_ov_write32(ov, offs, v);
+}
+
+static inline void acc_ov_clear_bits(struct acc_ov *ov,
+				     unsigned short offs, u32 b)
+{
+	u32 v = acc_ov_read32(ov, offs);
+
+	v &= ~b;
+	acc_ov_write32(ov, offs, v);
+}
+
+static inline void acc_reset_fpga(struct acc_ov *ov)
+{
+	acc_ov_write32(ov, ACC_OV_OF_MODE, ACC_OV_REG_MODE_MASK_FPGA_RESET);
+
+	/* Also reset I^2C, to re-detect card addons at every driver start: */
+	acc_ov_clear_bits(ov, ACC_OV_OF_MODE, ACC_OV_REG_MODE_MASK_I2C_ENABLE);
+	mdelay(2);
+	acc_ov_set_bits(ov, ACC_OV_OF_MODE, ACC_OV_REG_MODE_MASK_I2C_ENABLE);
+	mdelay(10);
+}
+
+void acc_init_ov(struct acc_ov *ov, struct device *dev);
+void acc_init_bm_ptr(struct acc_ov *ov, struct acc_core *cores,
+		     const void *mem);
+int acc_open(struct net_device *netdev);
+int acc_close(struct net_device *netdev);
+netdev_tx_t acc_start_xmit(struct sk_buff *skb, struct net_device *netdev);
+int acc_get_berr_counter(const struct net_device *netdev,
+			 struct can_berr_counter *bec);
+int acc_set_mode(struct net_device *netdev, enum can_mode mode);
+int acc_set_bittiming(struct net_device *netdev);
+irqreturn_t acc_card_interrupt(struct acc_ov *ov, struct acc_core *cores);
-- 
2.25.1

