Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2828551814
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 14:03:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242332AbiFTMDE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 08:03:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242089AbiFTMCl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 08:02:41 -0400
Received: from smtp2.infineon.com (smtp2.infineon.com [IPv6:2a00:18f0:1e00:4::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A72D18380;
        Mon, 20 Jun 2022 05:02:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=infineon.com; i=@infineon.com; q=dns/txt; s=IFXMAIL;
  t=1655726560; x=1687262560;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mcU2zd605tdGXObukOV2l4wgt38ac82d1qr3NR5XZ4s=;
  b=Z7UDaHXgELPH/zR4+23dq3dPylvSdCLLvZULsOjkrxhe1drLZhXtgCm4
   yu65OeCcCVnrKDw8xDL93w7rwBDsRV+0G6jE/xSoUXdqzyGswgIggptlk
   nm+Bs6eHXga0f/K9FgTIsNxWQTAfc5FH4NlxYu6Wf/9K5TfeDhmxK5gRF
   k=;
X-SBRS: None
X-IronPort-AV: E=McAfee;i="6400,9594,10380"; a="184450176"
X-IronPort-AV: E=Sophos;i="5.92,306,1650924000"; 
   d="scan'208";a="184450176"
Received: from unknown (HELO mucxv002.muc.infineon.com) ([172.23.11.17])
  by smtp2.infineon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2022 14:02:35 +0200
Received: from MUCSE819.infineon.com (MUCSE819.infineon.com [172.23.29.45])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mucxv002.muc.infineon.com (Postfix) with ESMTPS;
        Mon, 20 Jun 2022 14:02:35 +0200 (CEST)
Received: from MUCSE807.infineon.com (172.23.29.33) by MUCSE819.infineon.com
 (172.23.29.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Mon, 20 Jun
 2022 14:02:35 +0200
Received: from ISCNPF0RJXQS.infineon.com (172.23.8.247) by
 MUCSE807.infineon.com (172.23.29.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Mon, 20 Jun 2022 14:02:34 +0200
From:   Hakan Jansson <hakan.jansson@infineon.com>
CC:     Hakan Jansson <hakan.jansson@infineon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "Luiz Augusto von Dentz" <luiz.dentz@gmail.com>,
        <linux-bluetooth@vger.kernel.org>
Subject: [PATCH 4/4] Bluetooth: hci_bcm: Increase host baudrate for CYW55572 in autobaud mode
Date:   Mon, 20 Jun 2022 14:01:29 +0200
Message-ID: <386b205422099c795272ad8b792091b692def3cd.1655723462.git.hakan.jansson@infineon.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1655723462.git.hakan.jansson@infineon.com>
References: <cover.1655723462.git.hakan.jansson@infineon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.23.8.247]
X-ClientProxiedBy: MUCSE805.infineon.com (172.23.29.31) To
 MUCSE807.infineon.com (172.23.29.33)
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add device specific data for max baudrate in autobaud mode. This allows the
host to use a baudrate higher than "init speed" when loading FW in autobaud
mode.

Signed-off-by: Hakan Jansson <hakan.jansson@infineon.com>
---
 drivers/bluetooth/hci_bcm.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/bluetooth/hci_bcm.c b/drivers/bluetooth/hci_bcm.c
index 0ae627c293c5..d7e0b75db8a6 100644
--- a/drivers/bluetooth/hci_bcm.c
+++ b/drivers/bluetooth/hci_bcm.c
@@ -53,10 +53,12 @@
  * struct bcm_device_data - device specific data
  * @no_early_set_baudrate: Disallow set baudrate before driver setup()
  * @drive_rts_on_open: drive RTS signal on ->open() when platform requires it
+ * @max_autobaud_speed: max baudrate supported by device in autobaud mode
  */
 struct bcm_device_data {
 	bool	no_early_set_baudrate;
 	bool	drive_rts_on_open;
+	u32	max_autobaud_speed;
 };
 
 /**
@@ -100,6 +102,7 @@ struct bcm_device_data {
  * @drive_rts_on_open: drive RTS signal on ->open() when platform requires it
  * @pcm_int_params: keep the initial PCM configuration
  * @use_autobaud_mode: start Bluetooth device in autobaud mode
+ * @max_autobaud_speed: max baudrate supported by device in autobaud mode
  */
 struct bcm_device {
 	/* Must be the first member, hci_serdev.c expects this. */
@@ -139,6 +142,7 @@ struct bcm_device {
 	bool			drive_rts_on_open;
 	bool			use_autobaud_mode;
 	u8			pcm_int_params[5];
+	u32			max_autobaud_speed;
 };
 
 /* generic bcm uart resources */
@@ -479,7 +483,10 @@ static int bcm_open(struct hci_uart *hu)
 		else if (bcm->dev->drive_rts_on_open)
 			hci_uart_set_flow_control(hu, true);
 
-		hu->init_speed = bcm->dev->init_speed;
+		if (bcm->dev->use_autobaud_mode && bcm->dev->max_autobaud_speed)
+			hu->init_speed = min(bcm->dev->oper_speed, bcm->dev->max_autobaud_speed);
+		else
+			hu->init_speed = bcm->dev->init_speed;
 
 		/* If oper_speed is set, ldisc/serdev will set the baudrate
 		 * before calling setup()
@@ -585,8 +592,8 @@ static int bcm_setup(struct hci_uart *hu)
 		return 0;
 
 	/* Init speed if any */
-	if (hu->init_speed)
-		speed = hu->init_speed;
+	if (bcm->dev && bcm->dev->init_speed)
+		speed = bcm->dev->init_speed;
 	else if (hu->proto->init_speed)
 		speed = hu->proto->init_speed;
 	else
@@ -1519,6 +1526,7 @@ static int bcm_serdev_probe(struct serdev_device *serdev)
 
 	data = device_get_match_data(bcmdev->dev);
 	if (data) {
+		bcmdev->max_autobaud_speed = data->max_autobaud_speed;
 		bcmdev->no_early_set_baudrate = data->no_early_set_baudrate;
 		bcmdev->drive_rts_on_open = data->drive_rts_on_open;
 	}
@@ -1542,6 +1550,10 @@ static struct bcm_device_data bcm43438_device_data = {
 	.drive_rts_on_open = true,
 };
 
+static struct bcm_device_data cyw55572_device_data = {
+	.max_autobaud_speed = 921600,
+};
+
 static const struct of_device_id bcm_bluetooth_of_match[] = {
 	{ .compatible = "brcm,bcm20702a1" },
 	{ .compatible = "brcm,bcm4329-bt" },
@@ -1554,7 +1566,7 @@ static const struct of_device_id bcm_bluetooth_of_match[] = {
 	{ .compatible = "brcm,bcm4349-bt", .data = &bcm43438_device_data },
 	{ .compatible = "brcm,bcm43540-bt", .data = &bcm4354_device_data },
 	{ .compatible = "brcm,bcm4335a0" },
-	{ .compatible = "infineon,cyw55572-bt" },
+	{ .compatible = "infineon,cyw55572-bt", .data = &cyw55572_device_data },
 	{ },
 };
 MODULE_DEVICE_TABLE(of, bcm_bluetooth_of_match);
-- 
2.25.1

