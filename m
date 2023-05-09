Return-Path: <netdev+bounces-1015-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 95CC96FBD45
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 04:31:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 13149281221
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 02:31:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17D4338B;
	Tue,  9 May 2023 02:31:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B55F3C0B
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 02:31:08 +0000 (UTC)
Received: from smtpbgjp3.qq.com (smtpbgjp3.qq.com [54.92.39.34])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CEBA4684
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 19:31:05 -0700 (PDT)
X-QQ-mid: bizesmtp78t1683599356tab69jer
Received: from wxdbg.localdomain.com ( [125.119.253.217])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 09 May 2023 10:29:15 +0800 (CST)
X-QQ-SSF: 01400000000000I0Z000000A0000000
X-QQ-FEAT: D6RqbDSxuq4pA5QlJ8mXTOuhmpRffRNjCHsRBxxDxmW5qCJjZZHmHT4lVJXew
	og8dftO9CM0yEYIdYeqfX2nluM81tl1kUm6nJUtIhtFX1ftvQlnL0kJW58QiISiBfH0Ta00
	rzFmj6ltb4a0fbeE+54D9lqi+mu8PzEtWSZXAcW3Jpy1UL6IMOup0nXhOut6VXACmuMM7xH
	r523AL8TcBKd1YdjW048m5GEs1oen6LNTLwIzlvrDCCf9rjS4Z7Y+pNprnnZGT0LNb+GIFG
	O4rwcP2hMD1gmv7Soxs8fYvo/9eVl5YutReLLDlhwkJyVa4zzUrfOWIH8wPjGbhYAh64M7W
	hIgbeqoDStdxmt3bhswc3RP5PBB35mThiwPbKdo7YnpTIVJZ221RDFUcrq090ixNiqa/Yb1
	HZVrNy/ievCVErs1PxKkbw==
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 6603716929782460025
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
Subject: [PATCH net-next v7 5/9] net: txgbe: Add SFP module identify
Date: Tue,  9 May 2023 10:27:30 +0800
Message-Id: <20230509022734.148970-6-jiawenwu@trustnetic.com>
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

Register SFP platform device to get modules information.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
---
 drivers/net/ethernet/wangxun/Kconfig          |  1 +
 .../net/ethernet/wangxun/txgbe/txgbe_phy.c    | 28 +++++++++++++++++++
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   |  1 +
 3 files changed, 30 insertions(+)

diff --git a/drivers/net/ethernet/wangxun/Kconfig b/drivers/net/ethernet/wangxun/Kconfig
index ec058a72afb6..90812d76181d 100644
--- a/drivers/net/ethernet/wangxun/Kconfig
+++ b/drivers/net/ethernet/wangxun/Kconfig
@@ -44,6 +44,7 @@ config TXGBE
 	select REGMAP
 	select COMMON_CLK
 	select LIBWX
+	select SFP
 	help
 	  This driver supports Wangxun(R) 10GbE PCI Express family of
 	  adapters.
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
index 7da497ebc4a8..23fa7311db45 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
@@ -159,6 +159,25 @@ static int txgbe_i2c_register(struct txgbe *txgbe)
 	return 0;
 }
 
+static int txgbe_sfp_register(struct txgbe *txgbe)
+{
+	struct pci_dev *pdev = txgbe->wx->pdev;
+	struct platform_device_info info = {};
+	struct platform_device *sfp_dev;
+
+	info.parent = &pdev->dev;
+	info.fwnode = software_node_fwnode(txgbe->nodes.group[SWNODE_SFP]);
+	info.name = "sfp";
+	info.id = (pdev->bus->number << 8) | pdev->devfn;
+	sfp_dev = platform_device_register_full(&info);
+	if (IS_ERR(sfp_dev))
+		return PTR_ERR(sfp_dev);
+
+	txgbe->sfp_dev = sfp_dev;
+
+	return 0;
+}
+
 int txgbe_init_phy(struct txgbe *txgbe)
 {
 	int ret;
@@ -181,8 +200,16 @@ int txgbe_init_phy(struct txgbe *txgbe)
 		goto err_unregister_clk;
 	}
 
+	ret = txgbe_sfp_register(txgbe);
+	if (ret) {
+		wx_err(txgbe->wx, "failed to register sfp\n");
+		goto err_unregister_i2c;
+	}
+
 	return 0;
 
+err_unregister_i2c:
+	platform_device_unregister(txgbe->i2c_dev);
 err_unregister_clk:
 	clkdev_drop(txgbe->clock);
 	clk_unregister(txgbe->clk);
@@ -194,6 +221,7 @@ int txgbe_init_phy(struct txgbe *txgbe)
 
 void txgbe_remove_phy(struct txgbe *txgbe)
 {
+	platform_device_unregister(txgbe->sfp_dev);
 	platform_device_unregister(txgbe->i2c_dev);
 	clkdev_drop(txgbe->clock);
 	clk_unregister(txgbe->clk);
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
index 55979abf01f2..fc91e0fc37a6 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
@@ -149,6 +149,7 @@ struct txgbe_nodes {
 struct txgbe {
 	struct wx *wx;
 	struct txgbe_nodes nodes;
+	struct platform_device *sfp_dev;
 	struct platform_device *i2c_dev;
 	struct clk_lookup *clock;
 	struct clk *clk;
-- 
2.27.0


