Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70365311EC3
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 17:50:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbhBFQrt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 11:47:49 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:28896 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230355AbhBFQrc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Feb 2021 11:47:32 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 116GkhGt024494;
        Sat, 6 Feb 2021 08:46:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=PPmcOfrTjcHieQsKkMyjlYmkCVVcOE4m2YdaN546gCA=;
 b=G5BKNGbIylH/Rp6hJnn4K6RwP5m4qT0I9WV6NkwM4wQ5TOUzau2mrXXRlNtZG55OLp7J
 OLVf8Ivsh74Y/N30psKsLyIdNMeORsCCXAUNWZ5QZqIREmJFs4T5ulVA9aruG1yWubJI
 EZkMc/MCcvwHcVXDlysI59JOpRw9Dz47cN3PA8YiY4y+Hgov+2eubdtALIGU4Sjqq0Nx
 ojmxmHF1PlLa0ALgVxFDMvShhXRbPjhcs2VuHBGRaAcuHQG5fTV23YpwkkHpqjl4V6Q4
 yt0E9SuTfWKKkoeSNWbkitIDaVgogNjP6Oce2ZCHpkBINZ2fF1nWa1IzZmVpZ2MDUCsJ 8Q== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 36hugq09wp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 06 Feb 2021 08:46:43 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 6 Feb
 2021 08:46:41 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 6 Feb
 2021 08:46:40 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sat, 6 Feb 2021 08:46:40 -0800
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id 0DF5C3F703F;
        Sat,  6 Feb 2021 08:46:37 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>,
        <atenart@kernel.org>
Subject: [PATCH v8 net-next 03/15] net: mvpp2: add CM3 SRAM memory map
Date:   Sat, 6 Feb 2021 18:45:49 +0200
Message-ID: <1612629961-11583-4-git-send-email-stefanc@marvell.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1612629961-11583-1-git-send-email-stefanc@marvell.com>
References: <1612629961-11583-1-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-06_06:2021-02-05,2021-02-06 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Chulski <stefanc@marvell.com>

This patch adds CM3 memory map and CM3 read/write callbacks.
No functionality changes.

Signed-off-by: Stefan Chulski <stefanc@marvell.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h      |  7 +++
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 63 +++++++++++++++++++-
 2 files changed, 67 insertions(+), 3 deletions(-)

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
index a07cf60..307f9fd 100644
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
@@ -6846,6 +6847,44 @@ static int mvpp2_init(struct platform_device *pdev, struct mvpp2 *priv)
 	return 0;
 }
 
+static int mvpp2_get_sram(struct platform_device *pdev,
+			  struct mvpp2 *priv)
+{
+	struct device_node *dn = pdev->dev.of_node;
+	static bool defer_once;
+	struct resource *res;
+
+	if (has_acpi_companion(&pdev->dev)) {
+		res = platform_get_resource(pdev, IORESOURCE_MEM, 2);
+		if (!res) {
+			dev_warn(&pdev->dev, "ACPI is too old, Flow control not supported\n");
+			return 0;
+		}
+		priv->cm3_base = devm_ioremap_resource(&pdev->dev, res);
+		if (IS_ERR(priv->cm3_base))
+			return PTR_ERR(priv->cm3_base);
+	} else {
+		priv->sram_pool = of_gen_pool_get(dn, "cm3-mem", 0);
+		if (!priv->sram_pool) {
+			if (!defer_once) {
+				defer_once = true;
+				/* Try defer once */
+				return -EPROBE_DEFER;
+			}
+			dev_warn(&pdev->dev, "DT is too old, Flow control not supported\n");
+			return -ENOMEM;
+		}
+		/* cm3_base allocated with offset zero into the SRAM since mapping size
+		 * is equal to requested size.
+		 */
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
@@ -6902,6 +6941,13 @@ static int mvpp2_probe(struct platform_device *pdev)
 		priv->iface_base = devm_ioremap_resource(&pdev->dev, res);
 		if (IS_ERR(priv->iface_base))
 			return PTR_ERR(priv->iface_base);
+
+		/* Map CM3 SRAM */
+		err = mvpp2_get_sram(pdev, priv);
+		if (err == -EPROBE_DEFER)
+			return err;
+		else if (err)
+			dev_warn(&pdev->dev, "Fail to alloc CM3 SRAM\n");
 	}
 
 	if (priv->hw_version == MVPP22 && dev_of_node(&pdev->dev)) {
@@ -6947,11 +6993,13 @@ static int mvpp2_probe(struct platform_device *pdev)
 
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
@@ -7087,6 +7135,11 @@ static int mvpp2_probe(struct platform_device *pdev)
 	clk_disable_unprepare(priv->gop_clk);
 err_pp_clk:
 	clk_disable_unprepare(priv->pp_clk);
+err_cm3:
+	if (priv->sram_pool && priv->cm3_base)
+		gen_pool_free(priv->sram_pool, (unsigned long)priv->cm3_base,
+			      MSS_SRAM_SIZE);
+
 	return err;
 }
 
@@ -7127,6 +7180,10 @@ static int mvpp2_remove(struct platform_device *pdev)
 				  aggr_txq->descs_dma);
 	}
 
+	if (priv->sram_pool && priv->cm3_base)
+		gen_pool_free(priv->sram_pool, (unsigned long)priv->cm3_base,
+			      MSS_SRAM_SIZE);
+
 	if (is_acpi_node(port_fwnode))
 		return 0;
 
-- 
1.9.1

