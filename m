Return-Path: <netdev+bounces-509-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 49C1B6F7DE6
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 09:31:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C515F280F88
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 07:31:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DE2E4C91;
	Fri,  5 May 2023 07:31:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EC894C8F
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 07:31:09 +0000 (UTC)
Received: from smtpbguseast2.qq.com (smtpbguseast2.qq.com [54.204.34.130])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA2C3268C
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 00:31:03 -0700 (PDT)
X-QQ-mid: bizesmtp75t1683271754th9rpqar
Received: from wxdbg.localdomain.com ( [36.24.99.3])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 05 May 2023 15:29:13 +0800 (CST)
X-QQ-SSF: 01400000000000I0Z000000A0000000
X-QQ-FEAT: OgPF8Hk2NJr5fmP4vAHMamO250ECRfpVCJeMGj5BnEqyK5C8JTYhxgy9fhzTX
	SfsE9Hzayv2vS5g76EytI3OZ/2RlbhPhcu4+dG7a9zKde3AUYoA08W8aVo8a+QKZNtyu19R
	e5woFubioWjVCwg7lWPRqX0RLnb3x0vJRpsFk/9TtrJGOlC6ULfSWFR/fUHgM2JhSTxU5CZ
	ibS2/7IZ975yrolEZsD8Lfb5YqmCU7J+rszaI7kGPvax9Z40ZNf+vaPnG7AoRKFktg9cKkL
	nzkDKWg3izzSsJNuSBj3gzKTu+w4G0uk5aV063WOtKZC0T5yaappintWXIO50duSxNKeRbF
	RbrqpCgJD1cX7GIVR+Cf9rzkPZAVVvrSSiDx0+Z8e3Q6+QqNVz3214LcR8jTf88h3gxH+2/
	uQssGe1DYVI=
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 3968767490102190876
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
Subject: [RFC PATCH net-next v6 3/9] net: txgbe: Register fixed rate clock
Date: Fri,  5 May 2023 15:42:22 +0800
Message-Id: <20230505074228.84679-4-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230505074228.84679-1-jiawenwu@trustnetic.com>
References: <20230505074228.84679-1-jiawenwu@trustnetic.com>
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
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

In order for I2C to be able to work in standard mode, register a fixed
rate clock for each I2C device.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
---
 drivers/net/ethernet/wangxun/Kconfig          |  1 +
 .../net/ethernet/wangxun/txgbe/txgbe_phy.c    | 41 +++++++++++++++++++
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   |  2 +
 3 files changed, 44 insertions(+)

diff --git a/drivers/net/ethernet/wangxun/Kconfig b/drivers/net/ethernet/wangxun/Kconfig
index c9d88673d306..a62614eeed2e 100644
--- a/drivers/net/ethernet/wangxun/Kconfig
+++ b/drivers/net/ethernet/wangxun/Kconfig
@@ -40,6 +40,7 @@ config NGBE
 config TXGBE
 	tristate "Wangxun(R) 10GbE PCI Express adapters support"
 	depends on PCI
+	select COMMON_CLK
 	select LIBWX
 	help
 	  This driver supports Wangxun(R) 10GbE PCI Express family of
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
index c0699b596d3c..47509ad54e89 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
@@ -2,6 +2,8 @@
 /* Copyright (c) 2015 - 2023 Beijing WangXun Technology Co., Ltd. */
 
 #include <linux/gpio/property.h>
+#include <linux/clkdev.h>
+#include <linux/clk-provider.h>
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
+		return PTR_ERR(clock);
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
index 5bef0f9df523..cdbc4b37f832 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
@@ -146,6 +146,8 @@ struct txgbe_nodes {
 struct txgbe {
 	struct wx *wx;
 	struct txgbe_nodes nodes;
+	struct clk_lookup *clock;
+	struct clk *clk;
 };
 
 #endif /* _TXGBE_TYPE_H_ */
-- 
2.27.0


