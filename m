Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFB4E2F0802
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 16:35:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbhAJPdy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 10:33:54 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:21088 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726069AbhAJPdx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jan 2021 10:33:53 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10AFV6Tk027243;
        Sun, 10 Jan 2021 07:31:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=4Cf8J/rN1vop3GO4S3VZ/AdgFp0HMFiwipE4WllP1Ek=;
 b=gClGsxmV+CEAR29ppIqsKRikEyEQCH5K1VvV+TSZgpvke2/kvsUzaadoQaoJMjBMdcx3
 XnFmkGwEqdvptv9ywvPYLOGIBQduR98+wrj6xqxgYJ5GyXEW93tb7IMVDvfgp1FJ5GOe
 WVNU1rwuWYseVBZ6DlbwBQXH1IwydZxr2G6U1f2o4Qf3Q73nOjR3YH0AYNdyTnzkR10i
 pW2S6/n7IfrIA08HjxEaQO6n3yWGmTExv2Pb/DNVSaTWk3c8mKcvwwFKGwryajNGUQd4
 l9W7qZRdJSiLRXJOr1eUn2nVwrKytQzydFIRMiB2pKfvC0RwnGXpAbyJ/r0Ix/HTh4gg pw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 35yaqsj5fa-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 10 Jan 2021 07:31:06 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 10 Jan
 2021 07:31:03 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 10 Jan
 2021 07:31:03 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 10 Jan 2021 07:31:02 -0800
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id C40283F7040;
        Sun, 10 Jan 2021 07:30:59 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>,
        <atenart@kernel.org>
Subject: [PATCH RFC net-next  03/19] net: mvpp2: add CM3 SRAM memory map
Date:   Sun, 10 Jan 2021 17:30:07 +0200
Message-ID: <1610292623-15564-4-git-send-email-stefanc@marvell.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1610292623-15564-1-git-send-email-stefanc@marvell.com>
References: <1610292623-15564-1-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-09_13:2021-01-07,2021-01-09 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Chulski <stefanc@marvell.com>

This patch adds CM3 memory map and CM3 read/write callbacks.
No functionality changes.

Change-Id: Ibae3f5e6695f3454f799568308d349addc730f01
Signed-off-by: Stefan Chulski <stefanc@marvell.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h      |  7 +++
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 66 +++++++++++++++++++-
 2 files changed, 70 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index 6bd7e40..aec9179 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
@@ -748,6 +748,9 @@
 #define MVPP2_TX_FIFO_THRESHOLD(kb)	\
 		((kb) * 1024 - MVPP2_TX_FIFO_THRESHOLD_MIN)
 
+/* MSS Flow control */
+#define MSS_SRAM_SIZE	0x800
+
 /* RX buffer constants */
 #define MVPP2_SKB_SHINFO_SIZE \
 	SKB_DATA_ALIGN(sizeof(struct skb_shared_info))
@@ -925,6 +928,7 @@ struct mvpp2 {
 	/* Shared registers' base addresses */
 	void __iomem *lms_base;
 	void __iomem *iface_base;
+	void __iomem *cm3_base;
 
 	/* On PPv2.2, each "software thread" can access the base
 	 * register through a separate address space, each 64 KB apart
@@ -996,6 +1000,9 @@ struct mvpp2 {
 
 	/* page_pool allocator */
 	struct page_pool *page_pool[MVPP2_PORT_MAX_RXQ];
+
+	/* CM3 SRAM pool */
+	struct gen_pool *sram_pool;
 };
 
 struct mvpp2_pcpu_stats {
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 3982956..5267746 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -25,6 +25,7 @@
 #include <linux/of_net.h>
 #include <linux/of_address.h>
 #include <linux/of_device.h>
+#include <linux/genalloc.h>
 #include <linux/phy.h>
 #include <linux/phylink.h>
 #include <linux/phy/phy.h>
@@ -91,6 +92,18 @@ static inline u32 mvpp2_cpu_to_thread(struct mvpp2 *priv, int cpu)
 	return cpu % priv->nthreads;
 }
 
+static inline
+void mvpp2_cm3_write(struct mvpp2 *priv, u32 offset, u32 data)
+{
+	writel(data, priv->cm3_base + offset);
+}
+
+static inline
+u32 mvpp2_cm3_read(struct mvpp2 *priv, u32 offset)
+{
+	return readl(priv->cm3_base + offset);
+}
+
 static struct page_pool *
 mvpp2_create_page_pool(struct device *dev, int num, int len,
 		       enum dma_data_direction dma_dir)
@@ -6848,6 +6861,35 @@ static int mvpp2_init(struct platform_device *pdev, struct mvpp2 *priv)
 	return 0;
 }
 
+static int mvpp2_get_sram(struct platform_device *pdev,
+			  struct mvpp2 *priv)
+{
+	struct device_node *dn = pdev->dev.of_node;
+	struct resource *res;
+
+	if (has_acpi_companion(&pdev->dev)) {
+		res = platform_get_resource(pdev, IORESOURCE_MEM, 2);
+		if (!res) {
+			dev_warn(&pdev->dev, "ACPI is too old, TX FC disabled\n");
+			return 0;
+		}
+		priv->cm3_base = devm_ioremap_resource(&pdev->dev, res);
+		if (IS_ERR(priv->cm3_base))
+			return PTR_ERR(priv->cm3_base);
+	} else {
+		priv->sram_pool = of_gen_pool_get(dn, "cm3-mem", 0);
+		if (!priv->sram_pool) {
+			dev_warn(&pdev->dev, "DT is too old, TX FC disabled\n");
+			return 0;
+		}
+		priv->cm3_base = (void __iomem *)gen_pool_alloc(priv->sram_pool,
+								MSS_SRAM_SIZE);
+		if (!priv->cm3_base)
+			return -ENOMEM;
+	}
+	return 0;
+}
+
 static int mvpp2_probe(struct platform_device *pdev)
 {
 	const struct acpi_device_id *acpi_id;
@@ -6904,6 +6946,11 @@ static int mvpp2_probe(struct platform_device *pdev)
 		priv->iface_base = devm_ioremap_resource(&pdev->dev, res);
 		if (IS_ERR(priv->iface_base))
 			return PTR_ERR(priv->iface_base);
+
+		/* Map CM3 SRAM */
+		err = mvpp2_get_sram(pdev, priv);
+		if (err)
+			dev_warn(&pdev->dev, "Fail to alloc CM3 SRAM\n");
 	}
 
 	if (priv->hw_version == MVPP22 && dev_of_node(&pdev->dev)) {
@@ -6949,11 +6996,13 @@ static int mvpp2_probe(struct platform_device *pdev)
 
 	if (dev_of_node(&pdev->dev)) {
 		priv->pp_clk = devm_clk_get(&pdev->dev, "pp_clk");
-		if (IS_ERR(priv->pp_clk))
-			return PTR_ERR(priv->pp_clk);
+		if (IS_ERR(priv->pp_clk)) {
+			err = PTR_ERR(priv->pp_clk);
+			goto err_cm3;
+		}
 		err = clk_prepare_enable(priv->pp_clk);
 		if (err < 0)
-			return err;
+			goto err_cm3;
 
 		priv->gop_clk = devm_clk_get(&pdev->dev, "gop_clk");
 		if (IS_ERR(priv->gop_clk)) {
@@ -7089,6 +7138,11 @@ static int mvpp2_probe(struct platform_device *pdev)
 	clk_disable_unprepare(priv->gop_clk);
 err_pp_clk:
 	clk_disable_unprepare(priv->pp_clk);
+err_cm3:
+	if (!has_acpi_companion(&pdev->dev) && priv->cm3_base)
+		gen_pool_free(priv->sram_pool, (unsigned long)priv->cm3_base,
+			      MSS_SRAM_SIZE);
+
 	return err;
 }
 
@@ -7129,6 +7183,12 @@ static int mvpp2_remove(struct platform_device *pdev)
 				  aggr_txq->descs_dma);
 	}
 
+	if (!has_acpi_companion(&pdev->dev) && priv->cm3_base) {
+		gen_pool_free(priv->sram_pool, (unsigned long)priv->cm3_base,
+			      MSS_SRAM_SIZE);
+		gen_pool_destroy(priv->sram_pool);
+	}
+
 	if (is_acpi_node(port_fwnode))
 		return 0;
 
-- 
1.9.1

