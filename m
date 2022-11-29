Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 383CA63BD99
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 11:10:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231549AbiK2KJs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 05:09:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232389AbiK2KJE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 05:09:04 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3B115A6DD
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 02:08:25 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1ozxX1-0006yA-N7; Tue, 29 Nov 2022 11:08:03 +0100
Received: from [2a0a:edc0:0:1101:1d::28] (helo=dude02.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <sha@pengutronix.de>)
        id 1ozxWy-0012i1-Ev; Tue, 29 Nov 2022 11:08:01 +0100
Received: from sha by dude02.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <sha@pengutronix.de>)
        id 1ozxWx-00BYHC-K0; Tue, 29 Nov 2022 11:07:59 +0100
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     linux-wireless@vger.kernel.org
Cc:     Neo Jou <neojou@gmail.com>, Hans Ulli Kroll <linux@ulli-kroll.de>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        kernel@pengutronix.de, Johannes Berg <johannes@sipsolutions.net>,
        Alexander Hochbaum <alex@appudo.com>,
        Da Xue <da@libre.computer>, Po-Hao Huang <phhuang@realtek.com>,
        Viktor Petrenko <g0000ga@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH v4 09/11] wifi: rtw88: Add rtw8822bu chipset support
Date:   Tue, 29 Nov 2022 11:07:52 +0100
Message-Id: <20221129100754.2753237-10-s.hauer@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221129100754.2753237-1-s.hauer@pengutronix.de>
References: <20221129100754.2753237-1-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for the rtw8822bu chipset based on
https://github.com/ulli-kroll/rtw88-usb.git

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---

Notes:
    Changes since v3:
    - drop unnecessary rtw88212bu.h
    
    Changes since v1:
    - Add more Device IDs from https://github.com/morrownr/88x2bu-20210702.git

 drivers/net/wireless/realtek/rtw88/Kconfig    | 11 +++
 drivers/net/wireless/realtek/rtw88/Makefile   |  3 +
 drivers/net/wireless/realtek/rtw88/rtw8822b.c | 19 ++++
 .../net/wireless/realtek/rtw88/rtw8822bu.c    | 90 +++++++++++++++++++
 4 files changed, 123 insertions(+)
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822bu.c

diff --git a/drivers/net/wireless/realtek/rtw88/Kconfig b/drivers/net/wireless/realtek/rtw88/Kconfig
index 2b500dbefbc2d..10f4e7f88b858 100644
--- a/drivers/net/wireless/realtek/rtw88/Kconfig
+++ b/drivers/net/wireless/realtek/rtw88/Kconfig
@@ -42,6 +42,17 @@ config RTW88_8822BE
 
 	  802.11ac PCIe wireless network adapter
 
+config RTW88_8822BU
+	tristate "Realtek 8822BU USB wireless network adapter"
+	depends on USB
+	select RTW88_CORE
+	select RTW88_USB
+	select RTW88_8822B
+	help
+	  Select this option will enable support for 8822BU chipset
+
+	  802.11ac USB wireless network adapter
+
 config RTW88_8822CE
 	tristate "Realtek 8822CE PCI wireless network adapter"
 	depends on PCI
diff --git a/drivers/net/wireless/realtek/rtw88/Makefile b/drivers/net/wireless/realtek/rtw88/Makefile
index 552661a638def..6984bfb7a3170 100644
--- a/drivers/net/wireless/realtek/rtw88/Makefile
+++ b/drivers/net/wireless/realtek/rtw88/Makefile
@@ -26,6 +26,9 @@ rtw88_8822b-objs		:= rtw8822b.o rtw8822b_table.o
 obj-$(CONFIG_RTW88_8822BE)	+= rtw88_8822be.o
 rtw88_8822be-objs		:= rtw8822be.o
 
+obj-$(CONFIG_RTW88_8822BU)	+= rtw88_8822bu.o
+rtw88_8822bu-objs		:= rtw8822bu.o
+
 obj-$(CONFIG_RTW88_8822C)	+= rtw88_8822c.o
 rtw88_8822c-objs		:= rtw8822c.o rtw8822c_table.o
 
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822b.c b/drivers/net/wireless/realtek/rtw88/rtw8822b.c
index 690e35c98f6e5..74dfb89b2c948 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822b.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822b.c
@@ -26,6 +26,12 @@ static void rtw8822be_efuse_parsing(struct rtw_efuse *efuse,
 	ether_addr_copy(efuse->addr, map->e.mac_addr);
 }
 
+static void rtw8822bu_efuse_parsing(struct rtw_efuse *efuse,
+				    struct rtw8822b_efuse *map)
+{
+	ether_addr_copy(efuse->addr, map->u.mac_addr);
+}
+
 static int rtw8822b_read_efuse(struct rtw_dev *rtwdev, u8 *log_map)
 {
 	struct rtw_efuse *efuse = &rtwdev->efuse;
@@ -56,6 +62,9 @@ static int rtw8822b_read_efuse(struct rtw_dev *rtwdev, u8 *log_map)
 	case RTW_HCI_TYPE_PCIE:
 		rtw8822be_efuse_parsing(efuse, map);
 		break;
+	case RTW_HCI_TYPE_USB:
+		rtw8822bu_efuse_parsing(efuse, map);
+		break;
 	default:
 		/* unsupported now */
 		return -ENOTSUPP;
@@ -1588,6 +1597,15 @@ static void rtw8822b_adaptivity(struct rtw_dev *rtwdev)
 	rtw_phy_set_edcca_th(rtwdev, l2h, h2l);
 }
 
+static void rtw8822b_fill_txdesc_checksum(struct rtw_dev *rtwdev,
+					  struct rtw_tx_pkt_info *pkt_info,
+					  u8 *txdesc)
+{
+	size_t words = 32 / 2; /* calculate the first 32 bytes (16 words) */
+
+	fill_txdesc_checksum_common(txdesc, words);
+}
+
 static const struct rtw_pwr_seq_cmd trans_carddis_to_cardemu_8822b[] = {
 	{0x0086,
 	 RTW_PWR_CUT_ALL_MSK,
@@ -2163,6 +2181,7 @@ static struct rtw_chip_ops rtw8822b_ops = {
 	.cfg_csi_rate		= rtw_bf_cfg_csi_rate,
 	.adaptivity_init	= rtw8822b_adaptivity_init,
 	.adaptivity		= rtw8822b_adaptivity,
+	.fill_txdesc_checksum	= rtw8822b_fill_txdesc_checksum,
 
 	.coex_set_init		= rtw8822b_coex_cfg_init,
 	.coex_set_ant_switch	= rtw8822b_coex_cfg_ant_switch,
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822bu.c b/drivers/net/wireless/realtek/rtw88/rtw8822bu.c
new file mode 100644
index 0000000000000..ab620a0b1dfc6
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822bu.c
@@ -0,0 +1,90 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+/* Copyright(c) 2018-2019  Realtek Corporation
+ */
+
+#include <linux/module.h>
+#include <linux/usb.h>
+#include "main.h"
+#include "rtw8822b.h"
+#include "usb.h"
+
+static const struct usb_device_id rtw_8822bu_id_table[] = {
+	{ USB_DEVICE_AND_INTERFACE_INFO(RTW_USB_VENDOR_ID_REALTEK, 0xb812, 0xff, 0xff, 0xff),
+	  .driver_info = (kernel_ulong_t)&(rtw8822b_hw_spec) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(RTW_USB_VENDOR_ID_REALTEK, 0xb82c, 0xff, 0xff, 0xff),
+	  .driver_info = (kernel_ulong_t)&(rtw8822b_hw_spec) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(RTW_USB_VENDOR_ID_REALTEK, 0x2102, 0xff, 0xff, 0xff),
+	  .driver_info = (kernel_ulong_t)&(rtw8822b_hw_spec) }, /* CCNC */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x7392, 0xb822, 0xff, 0xff, 0xff),
+	  .driver_info = (kernel_ulong_t)&(rtw8822b_hw_spec) }, /* Edimax EW-7822ULC */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x7392, 0xc822, 0xff, 0xff, 0xff),
+	  .driver_info = (kernel_ulong_t)&(rtw8822b_hw_spec) }, /* Edimax EW-7822UTC */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x7392, 0xd822, 0xff, 0xff, 0xff),
+	  .driver_info = (kernel_ulong_t)&(rtw8822b_hw_spec) }, /* Edimax */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x7392, 0xe822, 0xff, 0xff, 0xff),
+	  .driver_info = (kernel_ulong_t)&(rtw8822b_hw_spec) }, /* Edimax */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x7392, 0xf822, 0xff, 0xff, 0xff),
+	  .driver_info = (kernel_ulong_t)&(rtw8822b_hw_spec) }, /* Edimax EW-7822UAD */
+	{ USB_DEVICE_AND_INTERFACE_INFO(RTW_USB_VENDOR_ID_REALTEK, 0xb81a, 0xff, 0xff, 0xff),
+	  .driver_info = (kernel_ulong_t)&(rtw8822b_hw_spec) }, /* Default ID */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x0b05, 0x1841, 0xff, 0xff, 0xff),
+	  .driver_info = (kernel_ulong_t)&(rtw8822b_hw_spec) }, /* ASUS AC1300 USB-AC55 B1 */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x0b05, 0x184c, 0xff, 0xff, 0xff),
+	  .driver_info = (kernel_ulong_t)&(rtw8822b_hw_spec) }, /* ASUS U2 */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x0B05, 0x19aa, 0xff, 0xff, 0xff),
+	  .driver_info = (kernel_ulong_t)&(rtw8822b_hw_spec) }, /* ASUS - USB-AC58 rev A1 */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x0B05, 0x1870, 0xff, 0xff, 0xff),
+	  .driver_info = (kernel_ulong_t)&(rtw8822b_hw_spec) }, /* ASUS */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x0B05, 0x1874, 0xff, 0xff, 0xff),
+	  .driver_info = (kernel_ulong_t)&(rtw8822b_hw_spec) }, /* ASUS */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x2001, 0x331e, 0xff, 0xff, 0xff),
+	  .driver_info = (kernel_ulong_t)&(rtw8822b_hw_spec) }, /* Dlink - DWA-181 */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x2001, 0x331c, 0xff, 0xff, 0xff),
+	  .driver_info = (kernel_ulong_t)&(rtw8822b_hw_spec) }, /* Dlink - DWA-182 - D1 */
+	{USB_DEVICE_AND_INTERFACE_INFO(0x2001, 0x331f, 0xff, 0xff, 0xff),
+	  .driver_info = (kernel_ulong_t)&(rtw8822b_hw_spec)}, /* Dlink - DWA-183 D Ver */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x13b1, 0x0043, 0xff, 0xff, 0xff),
+	  .driver_info = (kernel_ulong_t)&(rtw8822b_hw_spec) }, /* Linksys WUSB6400M */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x13b1, 0x0045, 0xff, 0xff, 0xff),
+	  .driver_info = (kernel_ulong_t)&(rtw8822b_hw_spec) }, /* Linksys WUSB3600 v2 */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x2357, 0x012d, 0xff, 0xff, 0xff),
+	  .driver_info = (kernel_ulong_t)&(rtw8822b_hw_spec) }, /* TP-Link Archer T3U v1 */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x2357, 0x0138, 0xff, 0xff, 0xff),
+	  .driver_info = (kernel_ulong_t)&(rtw8822b_hw_spec) }, /* TP-Link Archer T3U Plus v1 */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x2357, 0x0115, 0xff, 0xff, 0xff),
+	  .driver_info = (kernel_ulong_t)&(rtw8822b_hw_spec) }, /* TP-Link Archer T4U V3 */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x2357, 0x012e, 0xff, 0xff, 0xff),
+	  .driver_info = (kernel_ulong_t)&(rtw8822b_hw_spec) }, /* TP-LINK */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x2357, 0x0116, 0xff, 0xff, 0xff),
+	  .driver_info = (kernel_ulong_t)&(rtw8822b_hw_spec) }, /* TP-LINK */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x2357, 0x0117, 0xff, 0xff, 0xff),
+	  .driver_info = (kernel_ulong_t)&(rtw8822b_hw_spec) }, /* TP-LINK */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x0846, 0x9055, 0xff, 0xff, 0xff),
+	  .driver_info = (kernel_ulong_t)&(rtw8822b_hw_spec) }, /* Netgear A6150 */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x0e66, 0x0025, 0xff, 0xff, 0xff),
+	  .driver_info = (kernel_ulong_t)&(rtw8822b_hw_spec) }, /* Hawking HW12ACU */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x04ca, 0x8602, 0xff, 0xff, 0xff),
+	  .driver_info = (kernel_ulong_t)&(rtw8822b_hw_spec) }, /* LiteOn */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x20f4, 0x808a, 0xff, 0xff, 0xff),
+	  .driver_info = (kernel_ulong_t)&(rtw8822b_hw_spec) }, /* TRENDnet TEW-808UBM */
+	{},
+};
+MODULE_DEVICE_TABLE(usb, rtw_8822bu_id_table);
+
+static int rtw8822bu_probe(struct usb_interface *intf,
+			   const struct usb_device_id *id)
+{
+	return rtw_usb_probe(intf, id);
+}
+
+static struct usb_driver rtw_8822bu_driver = {
+	.name = "rtw_8822bu",
+	.id_table = rtw_8822bu_id_table,
+	.probe = rtw8822bu_probe,
+	.disconnect = rtw_usb_disconnect,
+};
+module_usb_driver(rtw_8822bu_driver);
+
+MODULE_AUTHOR("Realtek Corporation");
+MODULE_DESCRIPTION("Realtek 802.11ac wireless 8822bu driver");
+MODULE_LICENSE("Dual BSD/GPL");
-- 
2.30.2

