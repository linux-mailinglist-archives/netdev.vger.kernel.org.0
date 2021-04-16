Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13FC1362BFA
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 01:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235036AbhDPXn6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 19:43:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234886AbhDPXn5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 19:43:57 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE4C0C061574;
        Fri, 16 Apr 2021 16:43:31 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id x21-20020a17090a5315b029012c4a622e4aso15421233pjh.2;
        Fri, 16 Apr 2021 16:43:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nM9D0HWgLFuOgI6wXrK5GAQnMmkrD1q1JdLDUThn0Io=;
        b=uDyGO8hPoMTn4asPVnUVGC38kCQKck+2A+/czgD7G8rsQUMDfXAE1Wa0zKfAoav0hy
         DAy31zXIa86WlJ/QhZcGRrG0gAoL/RGL1ApI8I1PXEaIDLi/dW6kuHmaIwBibH0FNtAo
         tcEV/Zzk69fmgmR4Kyug0dHiO7+fWK6MiMntEaX1S7WYH6Xbk3EAOmrTEFJDwhAVmxIl
         v1cPt3zQE4f4pZkrk6Q63yCKX3yb6Y1cGIdLwYESoX9AMJGanyBb5EfRtWX3JzvnOkEV
         XBDa0OukI0gIdXRUghJiwMAG50Mm+2pTkpiLHrpWP/S9sBY6ExviTE3Wo9du4xjfFVUV
         mfXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nM9D0HWgLFuOgI6wXrK5GAQnMmkrD1q1JdLDUThn0Io=;
        b=d6M0F5rKjYD0Stgn7Vlw83D6aLZiR56AbHboYFOMKjbRbR1Gd2lwFejWTFVXtRnwO3
         2ZnzLiov0gqUQKHFtdkU0C3YCQeORGgaN+4upwgz9vWqIs17d1fZ5befgmGwZI2mA81e
         vyVpMeUSjAmjOmzxauk78Evy8nEf+hSWsaxlFw+Ly8CJsm3l8+1t9gKUbVBhTXBVG9XV
         /ESmAh6xH+Skh+6mziPHuDrhJAz//DzOiMGPUptY6m/mbh3T9WvvdhB+CXYy/OZ/vqFz
         2qESNllZ6mIhWtK6+CFD4OmbJIzI1wErRqtv63+5rM/57Pv6adbonSnLHpjcn4k785Mq
         bCDA==
X-Gm-Message-State: AOAM530CIFhmdLNtBmvciETqPLr0if/OEgKptgd8xZ3vkfc3eMVEGCo2
        j7PoaBDsAaZjIvKpxMJ20dU=
X-Google-Smtp-Source: ABdhPJy2vxhZ66PBTTT8AR7hSuZavAcvhtHi7b2cQUCCSZ73Tn7PwZPdtoLKFBwshmtahiaMbPeviw==
X-Received: by 2002:a17:902:dacd:b029:e5:cf71:3901 with SMTP id q13-20020a170902dacdb02900e5cf713901mr11386160plx.23.1618616611440;
        Fri, 16 Apr 2021 16:43:31 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id a185sm5623947pfd.70.2021.04.16.16.43.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Apr 2021 16:43:31 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Po Liu <po.liu@nxp.com>
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, Michael Walle <michael@walle.cc>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 3/5] net: enetc: add a mini driver for the Integrated Endpoint Register Block
Date:   Sat, 17 Apr 2021 02:42:23 +0300
Message-Id: <20210416234225.3715819-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210416234225.3715819-1-olteanv@gmail.com>
References: <20210416234225.3715819-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The NXP ENETC is a 4-port Ethernet controller which 'smells' to
operating systems like 4 distinct PCIe PFs with SR-IOV, each PF having
its own driver instance, but in fact there are some hardware resources
which are shared between all ports, like for example the 256 KB SRAM
FIFO between the MACs and the Host Transfer Agent which DMAs frames to
DRAM.

To hide the stuff that cannot be neatly exposed per port, the hardware
designers came up with this idea of having a dedicated register block
which is supposed to be populated by the bootloader, and contains
everything configuration-related: MAC addresses, FIFO partitioning, etc.

When a port is reset using PCIe Function Level Reset, its defaults are
transferred from the IERB configuration. Most of the time, the settings
made through the IERB are read-only in the port's memory space (if they
are even visible), so they cannot be modified at runtime.

Linux doesn't have any advanced FIFO partitioning requirements at all,
but when reading through the hardware manual, it became clear that, even
though there are many good 'recommendations' for default values, many of
them were not actually put in practice on LS1028A. So we end up with a
default configuration that:

(a) does not have enough TX and RX byte credits to support the max MTU
    of 9600 (which the Linux driver claims already) properly (at full speed)
(b) allows the FIFO to be overrun with RX traffic, potentially
    overwriting internal data structures.

The last part sounds a bit catastrophic, but it isn't. Frames are
supposed to transit the FIFO for a very short time, but they can
actually accumulate there under 2 conditions:

(a) there is very severe congestion on DRAM memory, or
(b) the RX rings visible to the operating system were configured for
    lossless operation, and they just ran out of free buffers to copy
    the frame to. This is what is used to put backpressure onto the MAC
    with flow control.

So since ENETC has not supported flow control thus far, RX FIFO overruns
were never seen with Linux. But with the addition of flow control, we
should configure some registers to prevent this from happening. What we
are trying to protect against are bad actors which continue to send us
traffic despite the fact that we have signaled a PAUSE condition. Of
course we can't be lossless in that case, but it is best to configure
the FIFO to do tail dropping rather than letting it overrun.

So in a nutshell, this driver is a fixup for all the IERB default values
that should have been but aren't.

The IERB configuration needs to be done _before_ the PFs are enabled.
So every PF searches for the presence of the "fsl,ls1028a-enetc-ierb"
node in the device tree, and if it finds it, it "registers" with the
IERB, which means that it requests the IERB to fix up its default
values. This is done through -EPROBE_DEFER. The IERB driver is part of
the fsl_enetc module, but is technically a platform driver, since the
IERB is a good old fashioned MMIO region, as opposed to ENETC ports
which pretend to be PCIe devices.

The driver was already configuring ENETC_PTXMBAR (FIFO allocation for
TX) because due to an omission, TXMBAR is a read/write register in the
PF memory space. But the manual is quite clear that the formula for this
should depend upon the TX byte credits (TXBCR). In turn, the TX byte
credits are only readable/writable through the IERB. So if we want to
ensure that the TXBCR register also has a value that is correct and in
line with TXMBAR, there is simply no way this can be done from the PF
driver, access to the IERB is needed.

I could have modified U-Boot to fix up the IERB values, but that is
quite undesirable, as old U-Boot versions are likely to be floating
around for quite some time from now.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/Kconfig  |   9 +
 drivers/net/ethernet/freescale/enetc/Makefile |   3 +
 .../net/ethernet/freescale/enetc/enetc_ierb.c | 155 ++++++++++++++++++
 .../net/ethernet/freescale/enetc/enetc_ierb.h |  20 +++
 .../net/ethernet/freescale/enetc/enetc_pf.c   |  35 +++-
 5 files changed, 221 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/freescale/enetc/enetc_ierb.c
 create mode 100644 drivers/net/ethernet/freescale/enetc/enetc_ierb.h

diff --git a/drivers/net/ethernet/freescale/enetc/Kconfig b/drivers/net/ethernet/freescale/enetc/Kconfig
index ab92382c399a..d88f60c2bb82 100644
--- a/drivers/net/ethernet/freescale/enetc/Kconfig
+++ b/drivers/net/ethernet/freescale/enetc/Kconfig
@@ -2,6 +2,7 @@
 config FSL_ENETC
 	tristate "ENETC PF driver"
 	depends on PCI && PCI_MSI
+	depends on FSL_ENETC_IERB || FSL_ENETC_IERB=n
 	select FSL_ENETC_MDIO
 	select PHYLINK
 	select PCS_LYNX
@@ -25,6 +26,14 @@ config FSL_ENETC_VF
 
 	  If compiled as module (M), the module name is fsl-enetc-vf.
 
+config FSL_ENETC_IERB
+	tristate "ENETC IERB driver"
+	help
+	  This driver configures the Integrated Endpoint Register Block on NXP
+	  LS1028A.
+
+	  If compiled as module (M), the module name is fsl-enetc-ierb.
+
 config FSL_ENETC_MDIO
 	tristate "ENETC MDIO driver"
 	depends on PCI && MDIO_DEVRES && MDIO_BUS
diff --git a/drivers/net/ethernet/freescale/enetc/Makefile b/drivers/net/ethernet/freescale/enetc/Makefile
index 74f7ac253b8b..a139f2e9d59f 100644
--- a/drivers/net/ethernet/freescale/enetc/Makefile
+++ b/drivers/net/ethernet/freescale/enetc/Makefile
@@ -11,6 +11,9 @@ obj-$(CONFIG_FSL_ENETC_VF) += fsl-enetc-vf.o
 fsl-enetc-vf-y := enetc_vf.o $(common-objs)
 fsl-enetc-vf-$(CONFIG_FSL_ENETC_QOS) += enetc_qos.o
 
+obj-$(CONFIG_FSL_ENETC_IERB) += fsl-enetc-ierb.o
+fsl-enetc-ierb-y := enetc_ierb.o
+
 obj-$(CONFIG_FSL_ENETC_MDIO) += fsl-enetc-mdio.o
 fsl-enetc-mdio-y := enetc_pci_mdio.o enetc_mdio.o
 
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_ierb.c b/drivers/net/ethernet/freescale/enetc/enetc_ierb.c
new file mode 100644
index 000000000000..8b356c485507
--- /dev/null
+++ b/drivers/net/ethernet/freescale/enetc/enetc_ierb.c
@@ -0,0 +1,155 @@
+// SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
+/* Copyright 2021 NXP Semiconductors
+ *
+ * The Integrated Endpoint Register Block (IERB) is configured by pre-boot
+ * software and is supposed to be to ENETC what a NVRAM is to a 'real' PCIe
+ * card. Upon FLR, values from the IERB are transferred to the ENETC PFs, and
+ * are read-only in the PF memory space.
+ *
+ * This driver fixes up the power-on reset values for the ENETC shared FIFO,
+ * such that the TX and RX allocations are sufficient for jumbo frames, and
+ * that intelligent FIFO dropping is enabled before the internal data
+ * structures are corrupted.
+ *
+ * Even though not all ports might be used on a given board, we are not
+ * concerned with partitioning the FIFO, because the default values configure
+ * no strict reservations, so the entire FIFO can be used by the RX of a single
+ * port, or the TX of a single port.
+ */
+
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/of_device.h>
+#include <linux/pci.h>
+#include <linux/platform_device.h>
+#include "enetc.h"
+#include "enetc_ierb.h"
+
+/* IERB registers */
+#define ENETC_IERB_TXMBAR(port)			(((port) * 0x100) + 0x8080)
+#define ENETC_IERB_RXMBER(port)			(((port) * 0x100) + 0x8090)
+#define ENETC_IERB_RXMBLR(port)			(((port) * 0x100) + 0x8094)
+#define ENETC_IERB_RXBCR(port)			(((port) * 0x100) + 0x80a0)
+#define ENETC_IERB_TXBCR(port)			(((port) * 0x100) + 0x80a8)
+#define ENETC_IERB_FMBDTR			0xa000
+
+#define ENETC_RESERVED_FOR_ICM			1024
+
+struct enetc_ierb {
+	void __iomem *regs;
+};
+
+static void enetc_ierb_write(struct enetc_ierb *ierb, u32 offset, u32 val)
+{
+	iowrite32(val, ierb->regs + offset);
+}
+
+int enetc_ierb_register_pf(struct platform_device *pdev,
+			   struct pci_dev *pf_pdev)
+{
+	struct enetc_ierb *ierb = platform_get_drvdata(pdev);
+	int port = enetc_pf_to_port(pf_pdev);
+	u16 tx_credit, rx_credit, tx_alloc;
+
+	if (port < 0)
+		return -ENODEV;
+
+	if (!ierb)
+		return -EPROBE_DEFER;
+
+	/* By default, it is recommended to set the Host Transfer Agent
+	 * per port transmit byte credit to "1000 + max_frame_size/2".
+	 * The power-on reset value (1800 bytes) is rounded up to the nearest
+	 * 100 assuming a maximum frame size of 1536 bytes.
+	 */
+	tx_credit = roundup(1000 + ENETC_MAC_MAXFRM_SIZE / 2, 100);
+
+	/* Internal memory allocated for transmit buffering is guaranteed but
+	 * not reserved; i.e. if the total transmit allocation is not used,
+	 * then the unused portion is not left idle, it can be used for receive
+	 * buffering but it will be reclaimed, if required, from receive by
+	 * intelligently dropping already stored receive frames in the internal
+	 * memory to ensure that the transmit allocation is respected.
+	 *
+	 * PaTXMBAR must be set to a value larger than
+	 *     PaTXBCR + 2 * max_frame_size + 32
+	 * if frame preemption is not enabled, or to
+	 *     2 * PaTXBCR + 2 * p_max_frame_size (pMAC maximum frame size) +
+	 *     2 * np_max_frame_size (eMAC maximum frame size) + 64
+	 * if frame preemption is enabled.
+	 */
+	tx_alloc = roundup(2 * tx_credit + 4 * ENETC_MAC_MAXFRM_SIZE + 64, 16);
+
+	/* Initial credits, in units of 8 bytes, to the Ingress Congestion
+	 * Manager for the maximum amount of bytes the port is allocated for
+	 * pending traffic.
+	 * It is recommended to set the initial credits to 2 times the maximum
+	 * frame size (2 frames of maximum size).
+	 */
+	rx_credit = DIV_ROUND_UP(ENETC_MAC_MAXFRM_SIZE * 2, 8);
+
+	enetc_ierb_write(ierb, ENETC_IERB_TXBCR(port), tx_credit);
+	enetc_ierb_write(ierb, ENETC_IERB_TXMBAR(port), tx_alloc);
+	enetc_ierb_write(ierb, ENETC_IERB_RXBCR(port), rx_credit);
+
+	return 0;
+}
+EXPORT_SYMBOL(enetc_ierb_register_pf);
+
+static int enetc_ierb_probe(struct platform_device *pdev)
+{
+	struct enetc_ierb *ierb;
+	struct resource *res;
+	void __iomem *regs;
+
+	ierb = devm_kzalloc(&pdev->dev, sizeof(*ierb), GFP_KERNEL);
+	if (!ierb)
+		return -ENOMEM;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	regs = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(regs))
+		return PTR_ERR(regs);
+
+	ierb->regs = regs;
+
+	/* Free buffer depletion threshold in bytes.
+	 * This sets the minimum amount of free buffer memory that should be
+	 * maintained in the datapath sub system, and when the amount of free
+	 * buffer memory falls below this threshold, a depletion indication is
+	 * asserted, which may trigger "intelligent drop" frame releases from
+	 * the ingress queues in the ICM.
+	 * It is recommended to set the free buffer depletion threshold to 1024
+	 * bytes, since the ICM needs some FIFO memory for its own use.
+	 */
+	enetc_ierb_write(ierb, ENETC_IERB_FMBDTR, ENETC_RESERVED_FOR_ICM);
+
+	platform_set_drvdata(pdev, ierb);
+
+	return 0;
+}
+
+static int enetc_ierb_remove(struct platform_device *pdev)
+{
+	return 0;
+}
+
+static const struct of_device_id enetc_ierb_match[] = {
+	{ .compatible = "fsl,ls1028a-enetc-ierb", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, enetc_ierb_match);
+
+static struct platform_driver enetc_ierb_driver = {
+	.driver = {
+		.name = "fsl-enetc-ierb",
+		.of_match_table = enetc_ierb_match,
+	},
+	.probe = enetc_ierb_probe,
+	.remove = enetc_ierb_remove,
+};
+
+module_platform_driver(enetc_ierb_driver);
+
+MODULE_DESCRIPTION("NXP ENETC IERB");
+MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_ierb.h b/drivers/net/ethernet/freescale/enetc/enetc_ierb.h
new file mode 100644
index 000000000000..b3b774e0998a
--- /dev/null
+++ b/drivers/net/ethernet/freescale/enetc/enetc_ierb.h
@@ -0,0 +1,20 @@
+/* SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause) */
+/* Copyright 2021 NXP Semiconductors */
+
+#include <linux/pci.h>
+#include <linux/platform_device.h>
+
+#if IS_ENABLED(CONFIG_FSL_ENETC_IERB)
+
+int enetc_ierb_register_pf(struct platform_device *pdev,
+			   struct pci_dev *pf_pdev);
+
+#else
+
+static inline int enetc_ierb_register_pf(struct platform_device *pdev,
+					 struct pci_dev *pf_pdev)
+{
+	return -EOPNOTSUPP;
+}
+
+#endif
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index be3dde0618e7..1ae2473cbc16 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -4,8 +4,10 @@
 #include <linux/mdio.h>
 #include <linux/module.h>
 #include <linux/fsl/enetc_mdio.h>
+#include <linux/of_platform.h>
 #include <linux/of_mdio.h>
 #include <linux/of_net.h>
+#include "enetc_ierb.h"
 #include "enetc_pf.h"
 
 #define ENETC_DRV_NAME_STR "ENETC PF driver"
@@ -518,7 +520,6 @@ static void enetc_configure_port_mac(struct enetc_hw *hw)
 		      ENETC_SET_MAXFRM(ENETC_RX_MAXFRM_SIZE));
 
 	enetc_port_wr(hw, ENETC_PTCMSDUR(0), ENETC_MAC_MAXFRM_SIZE);
-	enetc_port_wr(hw, ENETC_PTXMBAR, 2 * ENETC_MAC_MAXFRM_SIZE);
 
 	enetc_port_wr(hw, ENETC_PM0_CMD_CFG, ENETC_PM0_CMD_PHY_TX_EN |
 		      ENETC_PM0_CMD_TXP	| ENETC_PM0_PROMISC);
@@ -1116,6 +1117,30 @@ static int enetc_init_port_rss_memory(struct enetc_si *si)
 	return err;
 }
 
+static int enetc_pf_register_with_ierb(struct pci_dev *pdev)
+{
+	struct device_node *node = pdev->dev.of_node;
+	struct platform_device *ierb_pdev;
+	struct device_node *ierb_node;
+
+	/* Don't register with the IERB if the PF itself is disabled */
+	if (!node || !of_device_is_available(node))
+		return 0;
+
+	ierb_node = of_find_compatible_node(NULL, NULL,
+					    "fsl,ls1028a-enetc-ierb");
+	if (!ierb_node || !of_device_is_available(ierb_node))
+		return -ENODEV;
+
+	ierb_pdev = of_find_device_by_node(ierb_node);
+	of_node_put(ierb_node);
+
+	if (!ierb_pdev)
+		return -EPROBE_DEFER;
+
+	return enetc_ierb_register_pf(ierb_pdev, pdev);
+}
+
 static int enetc_pf_probe(struct pci_dev *pdev,
 			  const struct pci_device_id *ent)
 {
@@ -1126,6 +1151,14 @@ static int enetc_pf_probe(struct pci_dev *pdev,
 	struct enetc_pf *pf;
 	int err;
 
+	err = enetc_pf_register_with_ierb(pdev);
+	if (err == -EPROBE_DEFER)
+		return err;
+	if (err)
+		dev_warn(&pdev->dev,
+			 "Could not register with IERB driver: %pe, please update the device tree\n",
+			 ERR_PTR(err));
+
 	err = enetc_pci_probe(pdev, KBUILD_MODNAME, sizeof(*pf));
 	if (err) {
 		dev_err(&pdev->dev, "PCI probing failed\n");
-- 
2.25.1

