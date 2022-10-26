Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8625960E1CC
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 15:17:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234061AbiJZNQy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 09:16:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232625AbiJZNQi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 09:16:38 -0400
Received: from mx1.tq-group.com (mx1.tq-group.com [93.104.207.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7BFCFAA60;
        Wed, 26 Oct 2022 06:16:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1666790197; x=1698326197;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uD3B1j8AxBWEwgk4/bzdEnH3IBUS1p5ckVASZEy9HSQ=;
  b=iSp/2XKnaAngenVIBu4Dpp8SnEcvEOmoe4gcUI4RTPqf0SVbfqnaBmC0
   W4zyVeTr0aIpAwCQJ3XZifMQTdJyOU/2QZMyLtX8bY6o81St3oCbhMoDJ
   eKZSuZYTXV+MitqNVmbKg1eDdLMVVhIMXgt4wKgHeVVJKsaw9AEtmVeBh
   EPxLBn/3VNL7OjzZhTKRhPlGZFPC16Owq+p5F4nxn5ybYrDUPdzoArSJI
   U2RDPJLXLgJvWmchJHi5053E2JxWECFwlxH+oV6V4/2TrmryelMx/cYFE
   O63sR5oILlAOnH5ekbODXCUNkGIcCXBLb+F5HKYPAPJeYpsHvbDXPrHfG
   Q==;
X-IronPort-AV: E=Sophos;i="5.95,214,1661810400"; 
   d="scan'208";a="26988473"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 26 Oct 2022 15:16:32 +0200
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Wed, 26 Oct 2022 15:16:32 +0200
X-PGP-Universal: processed;
        by tq-pgp-pr1.tq-net.de on Wed, 26 Oct 2022 15:16:32 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1666790192; x=1698326192;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uD3B1j8AxBWEwgk4/bzdEnH3IBUS1p5ckVASZEy9HSQ=;
  b=qtmEsX8/qH2EXnLlTpIwKrKrOgC1DZ3uM3SSju+YcoTKgV81NBav9tyt
   ZWWbw9sLueP6Niakhin9beVoVcazw7AVz/pJLa0B5Z610gajyVagK+s3s
   LHFrkECj5a/QwNicakJM64TIVDFT6Qa/OQa6On/+SBNkw27+s3yw1SENL
   TDfpF4wjXxI9d5zYwWqUnSkfZmtYx8vOk6GNA8jmsJQztpjqtZjwrMHoc
   0fRhQOy2ii6nTfGyPXmi9iKc0zjVc/3Bq0cTDjeamzWETp13EhQhn3+0S
   +oxI7nRpFYpiF5HnFM5hxkeGXGP/ZJeEa1SgJ0UKXBNobAjwYx2znZlQ+
   g==;
X-IronPort-AV: E=Sophos;i="5.95,214,1661810400"; 
   d="scan'208";a="26988472"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 26 Oct 2022 15:16:32 +0200
Received: from localhost.localdomain (SCHIFFERM-M2.tq-net.de [10.121.49.14])
        by vtuxmail01.tq-net.de (Postfix) with ESMTPA id C3A53280073;
        Wed, 26 Oct 2022 15:16:30 +0200 (CEST)
From:   Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
To:     Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux@ew.tq-group.com,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Subject: [RFC 3/5] bluetooth: hci_mrvl: select firmwares to load by match data
Date:   Wed, 26 Oct 2022 15:15:32 +0200
Message-Id: <8417016ef049fa74a3b2961fdbc91638aebaf3a6.1666786471.git.matthias.schiffer@ew.tq-group.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1666786471.git.matthias.schiffer@ew.tq-group.com>
References: <cover.1666786471.git.matthias.schiffer@ew.tq-group.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make the driver more generic by adding a driver info struct. We also add
support for devices without firmware (for example when the firmware is
loaded by the WLAN driver on a combined module).

Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
---
 drivers/bluetooth/hci_mrvl.c | 57 +++++++++++++++++++++++++++++-------
 1 file changed, 46 insertions(+), 11 deletions(-)

diff --git a/drivers/bluetooth/hci_mrvl.c b/drivers/bluetooth/hci_mrvl.c
index fbc3f7c3a5c7..5d191687a34a 100644
--- a/drivers/bluetooth/hci_mrvl.c
+++ b/drivers/bluetooth/hci_mrvl.c
@@ -14,6 +14,7 @@
 #include <linux/module.h>
 #include <linux/tty.h>
 #include <linux/of.h>
+#include <linux/of_device.h>
 #include <linux/serdev.h>
 
 #include <net/bluetooth/bluetooth.h>
@@ -33,6 +34,20 @@ enum {
 	STATE_FW_REQ_PENDING,
 };
 
+struct mrvl_driver_info {
+	const char *firmware_helper;
+	const char *firmware;
+};
+
+static const struct mrvl_driver_info mrvl_driver_info_8897 = {
+	.firmware_helper = "mrvl/helper_uart_3000000.bin",
+	.firmware = "mrvl/uart8897_bt.bin",
+};
+
+/* Fallback for non-OF instances */
+static const struct mrvl_driver_info *const mrvl_driver_info_default =
+	&mrvl_driver_info_8897;
+
 struct mrvl_data {
 	struct sk_buff *rx_skb;
 	struct sk_buff_head txq;
@@ -44,6 +59,7 @@ struct mrvl_data {
 
 struct mrvl_serdev {
 	struct hci_uart hu;
+	const struct mrvl_driver_info *info;
 };
 
 struct hci_mrvl_pkt {
@@ -353,18 +369,29 @@ static int mrvl_load_firmware(struct hci_dev *hdev, const char *name)
 
 static int mrvl_setup(struct hci_uart *hu)
 {
+	const struct mrvl_driver_info *info;
 	int err;
 
-	hci_uart_set_flow_control(hu, true);
+	if (hu->serdev) {
+		struct mrvl_serdev *mrvldev = serdev_device_get_drvdata(hu->serdev);
 
-	err = mrvl_load_firmware(hu->hdev, "mrvl/helper_uart_3000000.bin");
-	if (err) {
-		bt_dev_err(hu->hdev, "Unable to download firmware helper");
-		return -EINVAL;
+		info = mrvldev->info;
+	} else {
+		info = mrvl_driver_info_default;
 	}
 
-	/* Let the final ack go out before switching the baudrate */
-	hci_uart_wait_until_sent(hu);
+	if (info->firmware_helper) {
+		hci_uart_set_flow_control(hu, true);
+
+		err = mrvl_load_firmware(hu->hdev, info->firmware_helper);
+		if (err) {
+			bt_dev_err(hu->hdev, "Unable to download firmware helper");
+			return -EINVAL;
+		}
+
+		/* Let the final ack go out before switching the baudrate */
+		hci_uart_wait_until_sent(hu);
+	}
 
 	if (hu->serdev)
 		serdev_device_set_baudrate(hu->serdev, 3000000);
@@ -373,9 +400,11 @@ static int mrvl_setup(struct hci_uart *hu)
 
 	hci_uart_set_flow_control(hu, false);
 
-	err = mrvl_load_firmware(hu->hdev, "mrvl/uart8897_bt.bin");
-	if (err)
-		return err;
+	if (info->firmware) {
+		err = mrvl_load_firmware(hu->hdev, info->firmware);
+		if (err)
+			return err;
+	}
 
 	return 0;
 }
@@ -401,6 +430,12 @@ static int mrvl_serdev_probe(struct serdev_device *serdev)
 	if (!mrvldev)
 		return -ENOMEM;
 
+	if (IS_ENABLED(CONFIG_OF)) {
+		mrvldev->info = of_device_get_match_data(&serdev->dev);
+		if (!mrvldev->info)
+			return -ENODEV;
+	}
+
 	mrvldev->hu.serdev = serdev;
 	serdev_device_set_drvdata(serdev, mrvldev);
 
@@ -416,7 +451,7 @@ static void mrvl_serdev_remove(struct serdev_device *serdev)
 
 #ifdef CONFIG_OF
 static const struct of_device_id mrvl_bluetooth_of_match[] = {
-	{ .compatible = "mrvl,88w8897" },
+	{ .compatible = "mrvl,88w8897", .data = &mrvl_driver_info_8897 },
 	{ },
 };
 MODULE_DEVICE_TABLE(of, mrvl_bluetooth_of_match);
-- 
2.25.1

