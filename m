Return-Path: <netdev+bounces-7835-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DFA51721C51
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 04:57:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 59BB71C20AB7
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 02:57:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CED71369;
	Mon,  5 Jun 2023 02:57:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42066198
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 02:57:02 +0000 (UTC)
Received: from smtpbg151.qq.com (smtpbg151.qq.com [18.169.211.239])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91FED109
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 19:56:40 -0700 (PDT)
X-QQ-mid: bizesmtp91t1685933687tfxphhb1
Received: from wxdbg.localdomain.com ( [60.177.99.31])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 05 Jun 2023 10:54:46 +0800 (CST)
X-QQ-SSF: 01400000000000J0Z000000A0000000
X-QQ-FEAT: PS/N6jJLnDbvBqJ7ovR9TMrTbiBWL66TzFqRGi9xbv4dGxS2jJ9VxZG7ll72U
	OWBfS/5tPZ/f74fs65+QCzVeM2X1Nl+irSOsIOnQJyI+p8mBVsw0VW7FFWJzMo9YqlI/OlO
	Zv3f/tfaBmz7N7raQTEW+jVv9XX6UBxwqgdy7Edhxd21PHnWiMt+WRKMtEh3CAPsV2i428h
	l2txulRX8sF6jO47Hq699g2VBb7PcNlYS8Xz4UouGN8K8oSvjppDKDb/0zTlVdmfo8MChDb
	sAA+H6tWSs3N6/eY+x8ib2uuk05m+LUnueuvIK9u4R2mANrBMRm0HsBCKh9xD5o3cHT+10p
	FjrxDTQJ5jCsO+MC72K0Lgxz1EevnsozMzA/J15Jv+Wj9lEEZKGcI4lxMOR03gD0lFoGWr6
	rA2l0oNMh7WuWzF9+6bR+g==
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 4719117724773436358
From: Jiawen Wu <jiawenwu@trustnetic.com>
To: netdev@vger.kernel.org,
	jarkko.nikula@linux.intel.com,
	andriy.shevchenko@linux.intel.com,
	mika.westerberg@linux.intel.com,
	jsd@semihalf.com,
	Jose.Abreu@synopsys.com,
	andrew@lunn.ch,
	hkallweit1@gmail.com,
	linux@armlinux.org.uk
Cc: linux-i2c@vger.kernel.org,
	linux-gpio@vger.kernel.org,
	mengyuanlou@net-swift.com,
	Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [PATCH net-next v11 3/9] net: txgbe: Register fixed rate clock
Date: Mon,  5 Jun 2023 10:52:05 +0800
Message-Id: <20230605025211.743823-4-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230605025211.743823-1-jiawenwu@trustnetic.com>
References: <20230605025211.743823-1-jiawenwu@trustnetic.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:trustnetic.com:qybglogicsvrgz:qybglogicsvrgz5a-1
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

In order for I2C to be able to work in standard mode, register a fixed
rate clock for each I2C device.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/ethernet/wangxun/Kconfig          |  1 +
 .../net/ethernet/wangxun/txgbe/txgbe_phy.c    | 41 +++++++++++++++++++
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   |  2 +
 3 files changed, 44 insertions(+)

diff --git a/drivers/net/ethernet/wangxun/Kconfig b/drivers/net/ethernet/wangxun/Kconfig
index c9d88673d306..190d42a203b4 100644
--- a/drivers/net/ethernet/wangxun/Kconfig
+++ b/drivers/net/ethernet/wangxun/Kconfig
@@ -40,6 +40,7 @@ config NGBE
 config TXGBE
 	tristate "Wangxun(R) 10GbE PCI Express adapters support"
 	depends on PCI
+	depends on COMMON_CLK
 	select LIBWX
 	help
 	  This driver supports Wangxun(R) 10GbE PCI Express family of
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
index be4b5ad74a3c..06506cfb8d06 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
@@ -2,6 +2,8 @@
 /* Copyright (c) 2015 - 2023 Beijing WangXun Technology Co., Ltd. */
 
 #include <linux/gpio/property.h>
+#include <linux/clk-provider.h>
+#include <linux/clkdev.h>
 #include <linux/i2c.h>
 #include <linux/pci.h>
 
@@ -70,6 +72,32 @@ static int txgbe_swnodes_register(struct txgbe *txgbe)
 	return software_node_register_node_group(nodes->group);
 }
 
+static int txgbe_clock_register(struct txgbe *txgbe)
+{
+	struct pci_dev *pdev = txgbe->wx->pdev;
+	struct clk_lookup *clock;
+	char clk_name[32];
+	struct clk *clk;
+
+	snprintf(clk_name, sizeof(clk_name), "i2c_designware.%d",
+		 (pdev->bus->number << 8) | pdev->devfn);
+
+	clk = clk_register_fixed_rate(NULL, clk_name, NULL, 0, 156250000);
+	if (IS_ERR(clk))
+		return PTR_ERR(clk);
+
+	clock = clkdev_create(clk, NULL, clk_name);
+	if (!clock) {
+		clk_unregister(clk);
+		return -ENOMEM;
+	}
+
+	txgbe->clk = clk;
+	txgbe->clock = clock;
+
+	return 0;
+}
+
 int txgbe_init_phy(struct txgbe *txgbe)
 {
 	int ret;
@@ -80,10 +108,23 @@ int txgbe_init_phy(struct txgbe *txgbe)
 		return ret;
 	}
 
+	ret = txgbe_clock_register(txgbe);
+	if (ret) {
+		wx_err(txgbe->wx, "failed to register clock: %d\n", ret);
+		goto err_unregister_swnode;
+	}
+
 	return 0;
+
+err_unregister_swnode:
+	software_node_unregister_node_group(txgbe->nodes.group);
+
+	return ret;
 }
 
 void txgbe_remove_phy(struct txgbe *txgbe)
 {
+	clkdev_drop(txgbe->clock);
+	clk_unregister(txgbe->clk);
 	software_node_unregister_node_group(txgbe->nodes.group);
 }
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
index 9aa399acd9a0..856d0f9d045b 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
@@ -147,6 +147,8 @@ struct txgbe_nodes {
 struct txgbe {
 	struct wx *wx;
 	struct txgbe_nodes nodes;
+	struct clk_lookup *clock;
+	struct clk *clk;
 };
 
 #endif /* _TXGBE_TYPE_H_ */
-- 
2.27.0


