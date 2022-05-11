Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96C1D523472
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 15:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243915AbiEKNje (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 09:39:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230389AbiEKNjd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 09:39:33 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B28401BDAED;
        Wed, 11 May 2022 06:39:31 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id k2so1989450qtp.1;
        Wed, 11 May 2022 06:39:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aWOO/quq1svhOVB6+WysSQZaYh0NuG1Dcmlsc91McHI=;
        b=SM2ng3Wy3NqTJv3b7WlYGryPauwIw9941UW8KaAOlF7Jis4RMwHN47k0bWFNIi6IQ6
         DhpxQ/9QjKpGhaUBP/551fjuZcFfoLZpiUQFfgmVAUiXR7oRPVrIFZMxkipn6XVlQPQR
         /YvuszDsfAejdhi4XPPgfALqYHYVeT0R8ZgWC69qx8hV3jaeIu5XINkgW/1SwbxXJL2r
         8PQOowvLuduc7Aw3YPVjx8g0oL9Kzp6qvS8o7bjJHdGW/sfMI09zaUpcp1oHp0ZB2EhA
         lZ9mYNoNmOtfAfXz6z33AfjS5ditaLl6HVKNRUdBHbpwTWiHVauUNbTL88lpM4TC+FMj
         YeYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aWOO/quq1svhOVB6+WysSQZaYh0NuG1Dcmlsc91McHI=;
        b=AFaxV2AFUFoiAQ7NYvmhrduDrA21lGtQeBTgOIIFwNmZD9+bt0MXKZUH6NrBCT4p2g
         yecrchLmxSZ9p1Tap0cNSvGcbWgQEzD62VyR04HfqrHRALxxJk8JB3VvHul0z00IAhPd
         /9quP5gXUpb18Ir4jemB/As0qyqChJefwc/kU+096dIBONqBsUU44sTr1+8QGXEmnJTb
         3NXFTV38MkSs3fE0z5HU5S9T0ryKeuSbn2k1gUR4se6XxkWo0kudfWM7dwlhcXMNZPpG
         YI6P5CG8B6LtXBKKlNQoBBpViqH7AajWT+Pj1u4WuvKe7r6vmCgP2oI2YmviswZ2nDeQ
         LIDQ==
X-Gm-Message-State: AOAM532jj1lw8STQb4zm0FHveeVERlEiWfcVAMb+FG4/YD44VwAkS+0D
        OFCaVgNlhuFxFg8za7zAGaAXRFs+5V3jgGy1
X-Google-Smtp-Source: ABdhPJw89bZlWhdg5K92STGDxWd9niCTUY79Xob2uXPfEiy3zrtjb+1ATlk9YeI2Xr/Vq3Yu2fYqgQ==
X-Received: by 2002:ac8:5a4f:0:b0:2f3:ddac:fe60 with SMTP id o15-20020ac85a4f000000b002f3ddacfe60mr11447348qta.90.1652276370837;
        Wed, 11 May 2022 06:39:30 -0700 (PDT)
Received: from debian.lan ([98.97.182.206])
        by smtp.gmail.com with ESMTPSA id k14-20020a05620a414e00b0069fc2a7e7a5sm1277026qko.75.2022.05.11.06.39.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 06:39:30 -0700 (PDT)
From:   David Ober <dober6023@gmail.com>
To:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, hayeswang@realtek.com, aaron.ma@canonical.com
Cc:     mpearson@lenovo.com, dober@lenovo.com,
        David Ober <dober6023@gmail.com>
Subject: [PATCH v2] net: usb: r8152: Add in new Devices that are supported for Mac-Passthru
Date:   Wed, 11 May 2022 09:39:26 -0400
Message-Id: <20220511133926.246464-1-dober6023@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lenovo Thunderbolt 4 Dock, and other Lenovo USB Docks are using the original
Realtek USB ethernet Vendor and Product IDs
If the Network device is Realtek verify that it is on a Lenovo USB hub
before enabling the passthru feature

This also adds in the device IDs for the Lenovo USB Dongle and one other
USB-C dock

Signed-off-by: David Ober <dober6023@gmail.com>
---
 drivers/net/usb/r8152.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index c2da3438387c..c32b9bf90baa 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -771,6 +771,9 @@ enum rtl8152_flags {
 };
 
 #define DEVICE_ID_THINKPAD_THUNDERBOLT3_DOCK_GEN2	0x3082
+#define DEVICE_ID_THINKPAD_THUNDERBOLT4_DOCK_GEN1	0x8153
+#define DEVICE_ID_THINKPAD_USB_C_DOCK_GEN3		0x3062
+#define DEVICE_ID_THINKPAD_USB_C_DONGLE		0x720c
 #define DEVICE_ID_THINKPAD_USB_C_DOCK_GEN2		0xa387
 
 struct tally_counter {
@@ -9644,11 +9647,20 @@ static int rtl8152_probe(struct usb_interface *intf,
 
 	if (le16_to_cpu(udev->descriptor.idVendor) == VENDOR_ID_LENOVO) {
 		switch (le16_to_cpu(udev->descriptor.idProduct)) {
+		case DEVICE_ID_THINKPAD_USB_C_DOCK_GEN3:
+		case DEVICE_ID_THINKPAD_USB_C_DONGLE:
 		case DEVICE_ID_THINKPAD_THUNDERBOLT3_DOCK_GEN2:
 		case DEVICE_ID_THINKPAD_USB_C_DOCK_GEN2:
 			tp->lenovo_macpassthru = 1;
 		}
 	}
+	else if ((le16_to_cpu(udev->descriptor.idVendor) == VENDOR_ID_REALTEK) &&
+		(le16_to_cpu(udev->parent->descriptor.idVendor) == VENDOR_ID_LENOVO)) {
+		switch (le16_to_cpu(udev->descriptor.idProduct)) {
+		case DEVICE_ID_THINKPAD_THUNDERBOLT4_DOCK_GEN1:
+			tp->lenovo_macpassthru = 1;
+		}
+	}
 
 	if (le16_to_cpu(udev->descriptor.bcdDevice) == 0x3011 && udev->serial &&
 	    (!strcmp(udev->serial, "000001000000") ||
-- 
2.30.2

