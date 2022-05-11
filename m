Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19F8B523D72
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 21:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346981AbiEKTas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 15:30:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346979AbiEKTan (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 15:30:43 -0400
Received: from mail-vs1-xe33.google.com (mail-vs1-xe33.google.com [IPv6:2607:f8b0:4864:20::e33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E87002300E3;
        Wed, 11 May 2022 12:30:20 -0700 (PDT)
Received: by mail-vs1-xe33.google.com with SMTP id c62so3007608vsc.10;
        Wed, 11 May 2022 12:30:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=850TGJyEAn7HrNOjcaANAGbrun1ZcUWVKibbUsgM30E=;
        b=LvM5YAP886GR4Nf7l4ggm/a+d6QdikkRTeoher5BMcVlV2LcvS8fSfvFKckPvGUWrG
         YdlFW0sqQp3/xxAOHQiIGUGWFgsDprIzlwh22iBZDPURl2wvvJikmlVMvznTk15wcAc9
         RxYEWFX6Pw3i1amAsGFbBqQPLSYTK4BUDwsSEpx2Eww+KjdcS+Qj3HeZgv2lJaLlyGwS
         hDpKfeJEVCzNuXu9qhb40TdMDPBNfbPy7Os/sjslQzUZT8xV43pVic9QuPEmtY/KRjYJ
         vxfNvrBFr0xk00B53fH64ejvBMxpU8+ttq8qj7XxFWprw/4GMoUmX8hB7iJs/hlFoZvh
         9CnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=850TGJyEAn7HrNOjcaANAGbrun1ZcUWVKibbUsgM30E=;
        b=jgYn+QeRvCNIQMnXHlh1bQHt+Jmyh3VOyamM3Zz7Y8cOIpfsI0q06Y70KhCE0RylEF
         RAJpvjBtzbbeFrUSzmazmTWVeYvdIg545tE5lj0m85SkzLittLfp1hX7GeICnkaoC5MF
         QrLJ7P+3bdt7X62B0BH2zOOzNkmRCzigzL38lQ1u1WN4KvqFPj3KAndSabu5+5onPlGm
         hDmM/afSqFLelcXtGIavqDD6Jz3NpMYhqENJnNOs9RKgoTqslkS+KDcoNB7nAuiSYV/3
         ogiZnoKitGfYlLURhfgO3bE+eXSqD2tHIQF9F6luqP57v4WRANsocDOpZISITjePjzWb
         hbug==
X-Gm-Message-State: AOAM532QTOh9kbbhJfYSDgDjwkccQ5+lfgTHckfUamtt7d68gS6p/FHT
        KUTQxTI7qNm/WKaB7goHihADHIu5eiIcWg8R
X-Google-Smtp-Source: ABdhPJz9jeYU+ttzjSYUyZHI+x2UxOgb+QW4lCamjb54+DZF644JdfUJG04vo+n9kau4c0hde4Gi9g==
X-Received: by 2002:a67:fd04:0:b0:32d:7265:8221 with SMTP id f4-20020a67fd04000000b0032d72658221mr15305146vsr.53.1652297419899;
        Wed, 11 May 2022 12:30:19 -0700 (PDT)
Received: from debian.lan ([98.97.182.206])
        by smtp.gmail.com with ESMTPSA id f11-20020a056122044b00b0034e6f1fd042sm370176vkk.12.2022.05.11.12.30.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 12:30:19 -0700 (PDT)
From:   David Ober <dober6023@gmail.com>
To:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, hayeswang@realtek.com, aaron.ma@canonical.com
Cc:     markpearson@lenovo.com, dober@lenovo.com,
        David Ober <dober6023@gmail.com>
Subject: [PATCH v3] net: usb: r8152: Add in new Devices that are supported for Mac-Passthru
Date:   Wed, 11 May 2022 15:30:15 -0400
Message-Id: <20220511193015.248364-1-dober6023@gmail.com>
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

Signed-off-by: David Ober <dober6023@gmail.com>
---
 drivers/net/usb/r8152.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index c2da3438387c..482f54625411 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -771,6 +771,8 @@ enum rtl8152_flags {
 };
 
 #define DEVICE_ID_THINKPAD_THUNDERBOLT3_DOCK_GEN2	0x3082
+#define DEVICE_ID_THINKPAD_USB_C_DOCK_GEN3		0x3062
+#define DEVICE_ID_THINKPAD_USB_C_DONGLE			0x720c
 #define DEVICE_ID_THINKPAD_USB_C_DOCK_GEN2		0xa387
 
 struct tally_counter {
@@ -9644,10 +9646,18 @@ static int rtl8152_probe(struct usb_interface *intf,
 
 	if (le16_to_cpu(udev->descriptor.idVendor) == VENDOR_ID_LENOVO) {
 		switch (le16_to_cpu(udev->descriptor.idProduct)) {
+		case DEVICE_ID_THINKPAD_USB_C_DOCK_GEN3:
+		case DEVICE_ID_THINKPAD_USB_C_DONGLE:
 		case DEVICE_ID_THINKPAD_THUNDERBOLT3_DOCK_GEN2:
 		case DEVICE_ID_THINKPAD_USB_C_DOCK_GEN2:
 			tp->lenovo_macpassthru = 1;
 		}
+	} else if ((le16_to_cpu(udev->descriptor.idVendor) == VENDOR_ID_REALTEK) &&
+		   (le16_to_cpu(udev->parent->descriptor.idVendor) == VENDOR_ID_LENOVO)) {
+		switch (le16_to_cpu(udev->descriptor.idProduct)) {
+		case 0x8153:
+			tp->lenovo_macpassthru = 1;
+		}
 	}
 
 	if (le16_to_cpu(udev->descriptor.bcdDevice) == 0x3011 && udev->serial &&
-- 
2.30.2

