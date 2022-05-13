Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64F4C52624D
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 14:49:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380446AbiEMMtR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 08:49:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380424AbiEMMtN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 08:49:13 -0400
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F8CF3CA51;
        Fri, 13 May 2022 05:49:12 -0700 (PDT)
Received: by mail-qv1-xf33.google.com with SMTP id h13so6621112qvh.0;
        Fri, 13 May 2022 05:49:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=svIteQs/NmirHKM4eZRFwtABZeeccUCbyxDdWqLOa+0=;
        b=HC0UCr1HshocpkpTbxJw7VXHvQSJnT9JJtiWj/m69a8Hw8CZRNqIUGt9YwRV/PZbgj
         olr6vDhf0xaMYG3L2ctzWc5UXbCZiY93dvx1PXiJEA73MwrB0A9XBN3XN5L45auOHbRi
         ow8Aih85uNyrJPLZmjMveuPeaJ4w4QaCm+AZrj9/bbmfsPABZLs5FDaEzUSM+xiB6yE2
         J3DS6TnCeVLetFHRotn51Q1afY8OmdXKAmM0DSc8n6hdyCRnVoSH10KzppVZHk9D+e89
         YA8Bnl+amARaAMH7P/vd3G8Gm3xRwMP1oz2Ff/+wMfTyAylyYrWDmScMCAr9ZRaPykOM
         K6LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=svIteQs/NmirHKM4eZRFwtABZeeccUCbyxDdWqLOa+0=;
        b=FzQNHq2D8D6qa9gqskqIy164hbfkTXquFGrO99zl6f+erTr8c07bNfzq/FZkp+6XBt
         Tibm0SQP8htVWhc5ZbQ3cgMWJNR989WNJbrN4UNZK27b6shaPIzlJZrfBxFFsncakSO5
         JPbG3hIyP03uPQHmW+ZBPnq3yi2c+HIT3IzQUHH+IyZR+/oGCtHQPJCEWsU1tCtqPjFU
         7q6Gn6WcpWMAJYRL1WQnJD9ncjB6Ho8UkGpsZKr6SCrCK4WZyECWCUquVDCvltlPp2Rc
         z/vMzvZC3XgvEm40ZrAXFHfS84S4QqPCS2UF4Dz0olpEi4K/yqoZ1XpfMY1wy2fO/2Ny
         u83A==
X-Gm-Message-State: AOAM532Q4xh9hTN6J22/s96kz059ZrlYNOYpiSb0ewP7gSH/CXz6yyw2
        FFcZHg0+73sfav9xT0KDXGcO0gmxILxe9lZz
X-Google-Smtp-Source: ABdhPJxK7XQfwqv4BNUlWs5dFYgXR06NJ/HFoLDVj9rprBPtDEtAxkvMgMIy1eaSJ/U5FabSvJLO7Q==
X-Received: by 2002:a0c:ec41:0:b0:456:51c6:1800 with SMTP id n1-20020a0cec41000000b0045651c61800mr4127604qvq.44.1652446151554;
        Fri, 13 May 2022 05:49:11 -0700 (PDT)
Received: from debian.lan ([98.97.182.10])
        by smtp.gmail.com with ESMTPSA id n26-20020a05620a153a00b0069fc13ce22esm1366460qkk.95.2022.05.13.05.49.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 May 2022 05:49:11 -0700 (PDT)
From:   David Ober <dober6023@gmail.com>
To:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, hayeswang@realtek.com, aaron.ma@canonical.com
Cc:     markpearson@lenovo.com, dober@lenovo.com,
        David Ober <dober6023@gmail.com>
Subject: [PATCH v4] net: usb: r8152: Add in new Devices that are supported for Mac-Passthru
Date:   Fri, 13 May 2022 08:49:06 -0400
Message-Id: <20220513124906.402630-1-dober6023@gmail.com>
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

Signed-off-by: David Ober <dober6023@gmail.com>
---
 drivers/net/usb/r8152.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index c2da3438387c..d8f2d4b85db4 100644
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
@@ -9646,6 +9648,14 @@ static int rtl8152_probe(struct usb_interface *intf,
 		switch (le16_to_cpu(udev->descriptor.idProduct)) {
 		case DEVICE_ID_THINKPAD_THUNDERBOLT3_DOCK_GEN2:
 		case DEVICE_ID_THINKPAD_USB_C_DOCK_GEN2:
+		case DEVICE_ID_THINKPAD_USB_C_DOCK_GEN3:
+		case DEVICE_ID_THINKPAD_USB_C_DONGLE:
+			tp->lenovo_macpassthru = 1;
+		}
+	} else if ((le16_to_cpu(udev->descriptor.idVendor) == VENDOR_ID_REALTEK) &&
+		   (le16_to_cpu(udev->parent->descriptor.idVendor) == VENDOR_ID_LENOVO)) {
+		switch (le16_to_cpu(udev->descriptor.idProduct)) {
+		case 0x8153:
 			tp->lenovo_macpassthru = 1;
 		}
 	}
-- 
2.30.2

