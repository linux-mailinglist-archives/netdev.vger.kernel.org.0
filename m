Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D4A74E3473
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 00:37:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233008AbiCUXf1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 19:35:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233000AbiCUXfY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 19:35:24 -0400
Received: from mailgw.felk.cvut.cz (mailgw.felk.cvut.cz [147.32.82.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE02D114FD5;
        Mon, 21 Mar 2022 16:33:56 -0700 (PDT)
Received: from mailgw.felk.cvut.cz (localhost.localdomain [127.0.0.1])
        by mailgw.felk.cvut.cz (Proxmox) with ESMTP id 83BB630AE00D;
        Tue, 22 Mar 2022 00:33:54 +0100 (CET)
Received: from cmp.felk.cvut.cz (haar.felk.cvut.cz [147.32.84.19])
        by mailgw.felk.cvut.cz (Proxmox) with ESMTPS id 4F37330AE009;
        Tue, 22 Mar 2022 00:33:52 +0100 (CET)
Received: from haar.felk.cvut.cz (localhost [127.0.0.1])
        by cmp.felk.cvut.cz (8.14.0/8.12.3/SuSE Linux 0.6) with ESMTP id 22LNXps9014348;
        Tue, 22 Mar 2022 00:33:51 +0100
Received: (from pisa@localhost)
        by haar.felk.cvut.cz (8.14.0/8.13.7/Submit) id 22LNXpvP014347;
        Tue, 22 Mar 2022 00:33:51 +0100
From:   Pavel Pisa <pisa@cmp.felk.cvut.cz>
To:     linux-can@vger.kernel.org, devicetree@vger.kernel.org,
        "Marc Kleine-Budde" <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        David Miller <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, mark.rutland@arm.com,
        Carsten Emde <c.emde@osadl.org>, armbru@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marin Jerabek <martin.jerabek01@gmail.com>,
        Ondrej Ille <ondrej.ille@gmail.com>,
        Jiri Novak <jnovak@fel.cvut.cz>,
        Jaroslav Beran <jara.beran@gmail.com>,
        Petr Porazil <porazil@pikron.com>, Pavel Machek <pavel@ucw.cz>,
        Drew Fustini <pdp7pdp7@gmail.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>
Subject: [PATCH v8 5/7] can: ctucanfd: CTU CAN FD open-source IP core - platform/SoC support.
Date:   Tue, 22 Mar 2022 00:32:32 +0100
Message-Id: <4d5c53499bafe7717815f948801bd5aedaa05c12.1647904780.git.pisa@cmp.felk.cvut.cz>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1647904780.git.pisa@cmp.felk.cvut.cz>
References: <cover.1647904780.git.pisa@cmp.felk.cvut.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Platform bus adaptation for CTU CAN FD open-source IP core.

The core has been tested together with OpenCores SJA1000
modified to be CAN FD frames tolerant on MicroZed Zynq based
MZ_APO education kits designed by Petr Porazil from PiKRON.com
company. FPGA design

  https://gitlab.fel.cvut.cz/canbus/zynq/zynq-can-sja1000-top.

The kit description at the Computer Architectures course pages

  https://cw.fel.cvut.cz/wiki/courses/b35apo/documentation/mz_apo/start .

Kit carrier board and mechanics design source files

  https://gitlab.com/pikron/projects/mz_apo/microzed_apo

The work is documented in Martin Jeřábek's diploma theses
Open-source and Open-hardware CAN FD Protocol Support

  https://dspace.cvut.cz/handle/10467/80366
.

Signed-off-by: Pavel Pisa <pisa@cmp.felk.cvut.cz>
Signed-off-by: Martin Jerabek <martin.jerabek01@gmail.com>
Signed-off-by: Ondrej Ille <ondrej.ille@gmail.com>
---
 drivers/net/can/ctucanfd/Kconfig             |  12 ++
 drivers/net/can/ctucanfd/Makefile            |   1 +
 drivers/net/can/ctucanfd/ctucanfd_platform.c | 132 +++++++++++++++++++
 3 files changed, 145 insertions(+)
 create mode 100644 drivers/net/can/ctucanfd/ctucanfd_platform.c

diff --git a/drivers/net/can/ctucanfd/Kconfig b/drivers/net/can/ctucanfd/Kconfig
index d6e59522f4cf0..48963efc7f199 100644
--- a/drivers/net/can/ctucanfd/Kconfig
+++ b/drivers/net/can/ctucanfd/Kconfig
@@ -20,3 +20,15 @@ config CAN_CTUCANFD_PCI
 	  The project providing FPGA design for Intel EP4CGX15 based DB4CGX15
 	  PCIe board with PiKRON.com designed transceiver riser shield is available
 	  at https://gitlab.fel.cvut.cz/canbus/pcie-ctucanfd .
+
+config CAN_CTUCANFD_PLATFORM
+	tristate "CTU CAN-FD IP core platform (FPGA, SoC) driver"
+	depends on CAN_CTUCANFD
+	depends on OF || COMPILE_TEST
+	help
+	  The core has been tested together with OpenCores SJA1000
+	  modified to be CAN FD frames tolerant on MicroZed Zynq based
+	  MZ_APO education kits designed by Petr Porazil from PiKRON.com
+	  company. FPGA design https://gitlab.fel.cvut.cz/canbus/zynq/zynq-can-sja1000-top.
+	  The kit description at the Computer Architectures course pages
+	  https://cw.fel.cvut.cz/wiki/courses/b35apo/documentation/mz_apo/start .
diff --git a/drivers/net/can/ctucanfd/Makefile b/drivers/net/can/ctucanfd/Makefile
index 48555c3511e7c..8078f1f2c30fc 100644
--- a/drivers/net/can/ctucanfd/Makefile
+++ b/drivers/net/can/ctucanfd/Makefile
@@ -7,3 +7,4 @@ obj-$(CONFIG_CAN_CTUCANFD) := ctucanfd.o
 ctucanfd-y := ctucanfd_base.o
 
 obj-$(CONFIG_CAN_CTUCANFD_PCI) += ctucanfd_pci.o
+obj-$(CONFIG_CAN_CTUCANFD_PLATFORM) += ctucanfd_platform.o
diff --git a/drivers/net/can/ctucanfd/ctucanfd_platform.c b/drivers/net/can/ctucanfd/ctucanfd_platform.c
new file mode 100644
index 0000000000000..5e48060686622
--- /dev/null
+++ b/drivers/net/can/ctucanfd/ctucanfd_platform.c
@@ -0,0 +1,132 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*******************************************************************************
+ *
+ * CTU CAN FD IP Core
+ *
+ * Copyright (C) 2015-2018 Ondrej Ille <ondrej.ille@gmail.com> FEE CTU
+ * Copyright (C) 2018-2021 Ondrej Ille <ondrej.ille@gmail.com> self-funded
+ * Copyright (C) 2018-2019 Martin Jerabek <martin.jerabek01@gmail.com> FEE CTU
+ * Copyright (C) 2018-2022 Pavel Pisa <pisa@cmp.felk.cvut.cz> FEE CTU/self-funded
+ *
+ * Project advisors:
+ *     Jiri Novak <jnovak@fel.cvut.cz>
+ *     Pavel Pisa <pisa@cmp.felk.cvut.cz>
+ *
+ * Department of Measurement         (http://meas.fel.cvut.cz/)
+ * Faculty of Electrical Engineering (http://www.fel.cvut.cz)
+ * Czech Technical University        (http://www.cvut.cz/)
+ ******************************************************************************/
+
+#include <linux/module.h>
+#include <linux/netdevice.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
+
+#include "ctucanfd.h"
+
+#define DRV_NAME	"ctucanfd"
+
+static void ctucan_platform_set_drvdata(struct device *dev,
+					struct net_device *ndev)
+{
+	struct platform_device *pdev = container_of(dev, struct platform_device,
+						    dev);
+
+	platform_set_drvdata(pdev, ndev);
+}
+
+/**
+ * ctucan_platform_probe - Platform registration call
+ * @pdev:	Handle to the platform device structure
+ *
+ * This function does all the memory allocation and registration for the CAN
+ * device.
+ *
+ * Return: 0 on success and failure value on error
+ */
+static int ctucan_platform_probe(struct platform_device *pdev)
+{
+	struct resource *res; /* IO mem resources */
+	struct device	*dev = &pdev->dev;
+	void __iomem *addr;
+	int ret;
+	unsigned int ntxbufs;
+	int irq;
+
+	/* Get the virtual base address for the device */
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	addr = devm_ioremap_resource(dev, res);
+	if (IS_ERR(addr)) {
+		dev_err(dev, "Cannot remap address.\n");
+		ret = PTR_ERR(addr);
+		goto err;
+	}
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0) {
+		dev_err(dev, "Cannot find interrupt.\n");
+		ret = irq;
+		goto err;
+	}
+
+	/* Number of tx bufs might be change in HW for future. If so,
+	 * it will be passed as property via device tree
+	 */
+	ntxbufs = 4;
+	ret = ctucan_probe_common(dev, addr, irq, ntxbufs, 0,
+				  1, ctucan_platform_set_drvdata);
+
+	if (ret < 0)
+		platform_set_drvdata(pdev, NULL);
+
+err:
+	return ret;
+}
+
+/**
+ * ctucan_platform_remove - Unregister the device after releasing the resources
+ * @pdev:	Handle to the platform device structure
+ *
+ * This function frees all the resources allocated to the device.
+ * Return: 0 always
+ */
+static int ctucan_platform_remove(struct platform_device *pdev)
+{
+	struct net_device *ndev = platform_get_drvdata(pdev);
+	struct ctucan_priv *priv = netdev_priv(ndev);
+
+	netdev_dbg(ndev, "ctucan_remove");
+
+	unregister_candev(ndev);
+	pm_runtime_disable(&pdev->dev);
+	netif_napi_del(&priv->napi);
+	free_candev(ndev);
+
+	return 0;
+}
+
+static SIMPLE_DEV_PM_OPS(ctucan_platform_pm_ops, ctucan_suspend, ctucan_resume);
+
+/* Match table for OF platform binding */
+static const struct of_device_id ctucan_of_match[] = {
+	{ .compatible = "ctu,ctucanfd-2", },
+	{ .compatible = "ctu,ctucanfd", },
+	{ /* end of list */ },
+};
+MODULE_DEVICE_TABLE(of, ctucan_of_match);
+
+static struct platform_driver ctucanfd_driver = {
+	.probe	= ctucan_platform_probe,
+	.remove	= ctucan_platform_remove,
+	.driver	= {
+		.name = DRV_NAME,
+		.pm = &ctucan_platform_pm_ops,
+		.of_match_table	= ctucan_of_match,
+	},
+};
+
+module_platform_driver(ctucanfd_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Martin Jerabek");
+MODULE_DESCRIPTION("CTU CAN FD for platform");
-- 
2.20.1


