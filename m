Return-Path: <netdev+bounces-1016-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 46F5A6FBD48
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 04:32:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0A5D9281219
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 02:32:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14328376;
	Tue,  9 May 2023 02:31:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 027DE611C
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 02:31:10 +0000 (UTC)
Received: from smtpbg151.qq.com (smtpbg151.qq.com [18.169.211.239])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7999449CF
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 19:31:05 -0700 (PDT)
X-QQ-mid: bizesmtp78t1683599352tb5h0xep
Received: from wxdbg.localdomain.com ( [125.119.253.217])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 09 May 2023 10:29:11 +0800 (CST)
X-QQ-SSF: 01400000000000I0Z000000A0000000
X-QQ-FEAT: qOAV9bwDT/lhWQJ2ZrgPi2WI7gl3zUtPK8vQdD6mAslKGoSuxuHbNxYEK73jg
	h+AzNCZAwGr3WZ0VNmXZb6vMShHCb1w0QS1hEY4IepNc/4GlJPGAfSTCY4d0+3MgipvSgw0
	a9i7qupYGYj48Ten7ecMLBuj6irpaKYaHxWBetU59uHeowf8vkygmB4lHNLcTnUZDZGJdTr
	mQfiPQK8li6XqFUxbz5gbaOauk21k3gELuceoUVW6wWi4xQxbRKt3ALAGOs3s9jYDE6r6q1
	i9hU4rAfJfig+do8VAD1m9IwzTqFob/W9B3S9yv1gkGDbeeKx47HC1gWv3TetMV2hgrHXyq
	dhASY7VT80MeQQCQ3S5TtSHFrjxTEVxZf6aonafmz74QHEThoWjzZlNP/2c+pP8H1UPG3v5
	TTu3MIXS+GJROnw4Y5MCjho7nNFIjYIe
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 15534940054776133587
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
Subject: [PATCH net-next v7 4/9] net: txgbe: Register I2C platform device
Date: Tue,  9 May 2023 10:27:29 +0800
Message-Id: <20230509022734.148970-5-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230509022734.148970-1-jiawenwu@trustnetic.com>
References: <20230509022734.148970-1-jiawenwu@trustnetic.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:trustnetic.com:qybglogicsvrgz:qybglogicsvrgz5a-1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Register the platform device to use Designware I2C bus master driver.
Use regmap to read/write I2C device region from given base offset.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
---
 drivers/net/ethernet/wangxun/Kconfig          |  2 +
 .../net/ethernet/wangxun/txgbe/txgbe_phy.c    | 71 +++++++++++++++++++
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   |  4 ++
 3 files changed, 77 insertions(+)

diff --git a/drivers/net/ethernet/wangxun/Kconfig b/drivers/net/ethernet/wangxun/Kconfig
index a62614eeed2e..ec058a72afb6 100644
--- a/drivers/net/ethernet/wangxun/Kconfig
+++ b/drivers/net/ethernet/wangxun/Kconfig
@@ -40,6 +40,8 @@ config NGBE
 config TXGBE
 	tristate "Wangxun(R) 10GbE PCI Express adapters support"
 	depends on PCI
+	select I2C_DESIGNWARE_PLATFORM
+	select REGMAP
 	select COMMON_CLK
 	select LIBWX
 	help
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
index 052354b650a5..7da497ebc4a8 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
@@ -1,7 +1,9 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c) 2015 - 2023 Beijing WangXun Technology Co., Ltd. */
 
+#include <linux/platform_device.h>
 #include <linux/gpio/property.h>
+#include <linux/regmap.h>
 #include <linux/clkdev.h>
 #include <linux/clk-provider.h>
 #include <linux/i2c.h>
@@ -98,6 +100,65 @@ static int txgbe_clock_register(struct txgbe *txgbe)
 	return 0;
 }
 
+static int txgbe_i2c_read(void *context, unsigned int reg, unsigned int *val)
+{
+	struct wx *wx = context;
+
+	*val = rd32(wx, reg + TXGBE_I2C_BASE);
+
+	return 0;
+}
+
+static int txgbe_i2c_write(void *context, unsigned int reg, unsigned int val)
+{
+	struct wx *wx = context;
+
+	wr32(wx, reg + TXGBE_I2C_BASE, val);
+
+	return 0;
+}
+
+static const struct regmap_config i2c_regmap_config = {
+	.reg_bits = 32,
+	.val_bits = 32,
+	.reg_read = txgbe_i2c_read,
+	.reg_write = txgbe_i2c_write,
+};
+
+static int txgbe_i2c_register(struct txgbe *txgbe)
+{
+	struct platform_device_info info = {};
+	struct platform_device *i2c_dev;
+	struct wx *wx = txgbe->wx;
+	struct regmap *i2c_regmap;
+	struct resource res = {};
+	struct pci_dev *pdev;
+
+	pdev = wx->pdev;
+	i2c_regmap = devm_regmap_init(&pdev->dev, NULL, wx,
+				      &i2c_regmap_config);
+	if (IS_ERR(i2c_regmap)) {
+		wx_err(wx, "failed to init regmap\n");
+		return PTR_ERR(i2c_regmap);
+	}
+
+	info.parent = &pdev->dev;
+	info.fwnode = software_node_fwnode(txgbe->nodes.group[SWNODE_I2C]);
+	info.name = "i2c_designware";
+	info.id = (pdev->bus->number << 8) | pdev->devfn;
+
+	res = DEFINE_RES_IRQ(pdev->irq);
+	info.res = &res;
+	info.num_res = 1;
+	i2c_dev = platform_device_register_full(&info);
+	if (IS_ERR(i2c_dev))
+		return PTR_ERR(i2c_dev);
+
+	txgbe->i2c_dev = i2c_dev;
+
+	return 0;
+}
+
 int txgbe_init_phy(struct txgbe *txgbe)
 {
 	int ret;
@@ -114,8 +175,17 @@ int txgbe_init_phy(struct txgbe *txgbe)
 		goto err_unregister_swnode;
 	}
 
+	ret = txgbe_i2c_register(txgbe);
+	if (ret) {
+		wx_err(txgbe->wx, "failed to init i2c interface: %d\n", ret);
+		goto err_unregister_clk;
+	}
+
 	return 0;
 
+err_unregister_clk:
+	clkdev_drop(txgbe->clock);
+	clk_unregister(txgbe->clk);
 err_unregister_swnode:
 	software_node_unregister_node_group(txgbe->nodes.group);
 
@@ -124,6 +194,7 @@ int txgbe_init_phy(struct txgbe *txgbe)
 
 void txgbe_remove_phy(struct txgbe *txgbe)
 {
+	platform_device_unregister(txgbe->i2c_dev);
 	clkdev_drop(txgbe->clock);
 	clk_unregister(txgbe->clk);
 	software_node_unregister_node_group(txgbe->nodes.group);
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
index cdbc4b37f832..55979abf01f2 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
@@ -55,6 +55,9 @@
 #define TXGBE_TS_CTL                            0x10300
 #define TXGBE_TS_CTL_EVAL_MD                    BIT(31)
 
+/* I2C registers */
+#define TXGBE_I2C_BASE                          0x14900
+
 /* Part Number String Length */
 #define TXGBE_PBANUM_LENGTH                     32
 
@@ -146,6 +149,7 @@ struct txgbe_nodes {
 struct txgbe {
 	struct wx *wx;
 	struct txgbe_nodes nodes;
+	struct platform_device *i2c_dev;
 	struct clk_lookup *clock;
 	struct clk *clk;
 };
-- 
2.27.0


