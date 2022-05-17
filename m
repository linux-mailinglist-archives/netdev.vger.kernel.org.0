Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B59E52A9FD
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 20:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351799AbiEQSGf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 14:06:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352077AbiEQSGG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 14:06:06 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56A40205EB;
        Tue, 17 May 2022 11:05:45 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id m1so15135517qkn.10;
        Tue, 17 May 2022 11:05:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QJvn9WfhnrgL8FC+HsHuSt0YniyvHyUoKSjuV9Lcy6w=;
        b=YRGcj8jCZoitIt1Vhq2gVwOwSuyhbzpHJmi5UuabdP9QIngUp9OvmX6qobj69Gvx+K
         S7n0FIw0zF+icZ+RS8m/pnJecvfNZQYSJTIlS4tKcCQ0bhEvfL3Xzug0Msd5BpnVAa/8
         Dbzqq4HH+lirqhY7f4509VTU3aJlgevdr15YqCU00k8D3mUx9Ay8yCnqkaSgObC+j7wC
         36GIXSG9UOzlrF05rYxI5SzRDT6cz4zHuoc2ExPpAI3rPwodQHL9jSwuWLxlVs5b8Gaa
         y5mEpZBN4FlMCw7LS0X78Ag3A+ukIwUN36SZmyIOrPsr0AMsTuSRMaKx6w5l98MKAFrL
         QXug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QJvn9WfhnrgL8FC+HsHuSt0YniyvHyUoKSjuV9Lcy6w=;
        b=0xf8+36txkPUewL8V+o/HDE/+zaW2TKvOXKDMb4ud3Vn/prNMH3DcbvESirjNmPDae
         WiLrji5ytp1i3v1riSjO9udFaYg99yp29lmJy2hda+PrfXhWWPlAMu6xgwGK/ZQY6VU8
         qcMZAbTj2MFdAjqcRw9fsHYpe399+eE7iWgL+61o20S8kO/VWWc6a6i9zyxP12odtLaz
         RSRCoG0XQ6XKjRtBgrKWwKqh/cCtvcFT2QnYNzfNUqeoFRDRX503swU38kvCK3/8LbV0
         HRZO1OJp39Zsp7oL/Qi+n/Fuumj/MvG6b8Sj8P1/k4iUkSFfhPgIhh06NG6/Oh6t0zC3
         9yDg==
X-Gm-Message-State: AOAM530zv2nmElkV9H5tFIrB2DWsH4ZkICKxWxYO5HGUh07AKcWvntno
        6GOa6HjZJXtNS8t00AfjJDfVfTKuZzNnWJRV
X-Google-Smtp-Source: ABdhPJyaK8jp7X1zmXNtTzFbibFhP544mTrLSTejJK/3gQb6CF+ZbcyHpDnpR0hNUR4+7Bdm5mrAPQ==
X-Received: by 2002:a05:620a:666:b0:69f:bbd4:b9af with SMTP id a6-20020a05620a066600b0069fbbd4b9afmr17078451qkh.11.1652810744473;
        Tue, 17 May 2022 11:05:44 -0700 (PDT)
Received: from debian.lan ([98.97.182.10])
        by smtp.gmail.com with ESMTPSA id a66-20020a37b145000000b0069fc13ce231sm8115835qkf.98.2022.05.17.11.05.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 11:05:44 -0700 (PDT)
From:   David Ober <dober6023@gmail.com>
To:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, hayeswang@realtek.com, aaron.ma@canonical.com,
        bjorn@mork.no
Cc:     markpearson@lenovo.com, dober@lenovo.com,
        David Ober <dober6023@gmail.com>
Subject: [PATCH v5] net: usb: r8152: Add in new Devices that are supported for Mac-Passthru
Date:   Tue, 17 May 2022 14:05:39 -0400
Message-Id: <20220517180539.25839-1-dober6023@gmail.com>
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

Lenovo Thunderbolt 4 Dock, and other Lenovo USB Docks are using the
original Realtek USB ethernet Vendor and Product IDs
If the Network device is Realtek verify that it is on a Lenovo USB hub
before enabling the passthru feature

This also adds in the device IDs for the Lenovo USB Dongle and one other
USB-C dock

V2 fix formating of code
V3 remove Generic define for Device ID 0x8153 and change it to use value
V4 rearrange defines and case statement to put them in better order
v5 create helper function to do the testing work as suggested

Signed-off-by: David Ober <dober6023@gmail.com>
---
 drivers/net/usb/r8152.c | 33 ++++++++++++++++++++++++++-------
 1 file changed, 26 insertions(+), 7 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index c2da3438387c..7389d6ef8569 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -771,7 +771,9 @@ enum rtl8152_flags {
 };
 
 #define DEVICE_ID_THINKPAD_THUNDERBOLT3_DOCK_GEN2	0x3082
+#define DEVICE_ID_THINKPAD_USB_C_DONGLE			0x720c
 #define DEVICE_ID_THINKPAD_USB_C_DOCK_GEN2		0xa387
+#define DEVICE_ID_THINKPAD_USB_C_DOCK_GEN3		0x3062
 
 struct tally_counter {
 	__le64	tx_packets;
@@ -9562,6 +9564,29 @@ u8 rtl8152_get_version(struct usb_interface *intf)
 }
 EXPORT_SYMBOL_GPL(rtl8152_get_version);
 
+static bool rtl8152_supports_lenovo_macpassthru(struct usb_device *udev)
+{
+	int parent_vendor_id = le16_to_cpu(udev->parent->descriptor.idVendor);
+	int product_id = le16_to_cpu(udev->descriptor.idProduct);
+	int vendor_id = le16_to_cpu(udev->descriptor.idVendor);
+
+	if (vendor_id == VENDOR_ID_LENOVO) {
+		switch (product_id) {
+		case DEVICE_ID_THINKPAD_THUNDERBOLT3_DOCK_GEN2:
+		case DEVICE_ID_THINKPAD_USB_C_DOCK_GEN2:
+		case DEVICE_ID_THINKPAD_USB_C_DOCK_GEN3:
+		case DEVICE_ID_THINKPAD_USB_C_DONGLE:
+			return 1;
+		}
+	} else if (vendor_id == VENDOR_ID_REALTEK && parent_vendor_id == VENDOR_ID_LENOVO) {
+		switch (product_id) {
+		case 0x8153:
+			return 1;
+		}
+	}
+	return 0;
+}
+
 static int rtl8152_probe(struct usb_interface *intf,
 			 const struct usb_device_id *id)
 {
@@ -9642,13 +9667,7 @@ static int rtl8152_probe(struct usb_interface *intf,
 		netdev->hw_features &= ~NETIF_F_RXCSUM;
 	}
 
-	if (le16_to_cpu(udev->descriptor.idVendor) == VENDOR_ID_LENOVO) {
-		switch (le16_to_cpu(udev->descriptor.idProduct)) {
-		case DEVICE_ID_THINKPAD_THUNDERBOLT3_DOCK_GEN2:
-		case DEVICE_ID_THINKPAD_USB_C_DOCK_GEN2:
-			tp->lenovo_macpassthru = 1;
-		}
-	}
+	tp->lenovo_macpassthru = rtl8152_supports_lenovo_macpassthru(udev);
 
 	if (le16_to_cpu(udev->descriptor.bcdDevice) == 0x3011 && udev->serial &&
 	    (!strcmp(udev->serial, "000001000000") ||
-- 
2.30.2

