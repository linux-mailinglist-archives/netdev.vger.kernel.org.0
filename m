Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47915DDF00
	for <lists+netdev@lfdr.de>; Sun, 20 Oct 2019 17:04:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbfJTPET (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Oct 2019 11:04:19 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:42042 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726373AbfJTPES (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Oct 2019 11:04:18 -0400
Received: by mail-pg1-f195.google.com with SMTP id f14so6063636pgi.9;
        Sun, 20 Oct 2019 08:04:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6KJryP+tfJkdTokhyTPIITwV+Wsv8Q6hUTNNl5bzzlQ=;
        b=RO3Utzmv1T/sYXFpUu3+q9zHe+Wsi9u+r9LXoQagQ9syZqHCrCfd1X9lFdELC6S/f/
         I563WrsLVyg4L/CeL79q6w3+wqe7jxutMRuXqGc4ifIGBY06ETjRh8KXaJv1mc1MCkir
         3azQPpmW4gxGs4cpQvdE9LR+7VBLcJ2p63YnaaYX3ofHN41p9P4kxRYbejq2aZkTFRom
         dgtr5gd9grs587l8oCl8AAcfZrz/Cu25Ek+6neiRdqwHIiHQT++c244KUyllnhTaKDgx
         /aZidpQFg57jQo9ZsFSquuiNcM9ZOZ2Faf3R1eTlyzUScnuEuC9308Wq7tRncgFiOLB/
         U0Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6KJryP+tfJkdTokhyTPIITwV+Wsv8Q6hUTNNl5bzzlQ=;
        b=BdT1irr0gXxu0HjkkUYKlOMI34C0BZRXetoLbOEuG2OWEx7sxGLHNE7LAB+l33relX
         p+rNVV1zy9DgznaKpsS/I293iqyQ9a4REkkxsdP2F7gcN7jGR9DngzzPJAcvX4FWrbXs
         LS+GyAU2/1jXylSKIpcdnFFN1gbOev7NXzgZGgH8jL2o1eiW+YXgPbEqaEI4RQMSBjtZ
         cu4YlETkz0cbbYlmjFwgGuZ/8mFMEljgT25ANHUowE6CRZQsbp0/Brda9ifGidvVBqPq
         ZCYZiz1NgI2/1RQhtnfPDlgvREABc+gnScEkxQOcUwwboTKpSkHFqgwn9AFt8nDEmz0m
         eViQ==
X-Gm-Message-State: APjAAAUFcYaAXONqrUihnY6KR+YxM/pCHg46lNpcz5a5+zAr6VmRv5jr
        yMkKjcLjPF1IIlSadJ71bqq/57Ba
X-Google-Smtp-Source: APXvYqxnCw3hmpRBqaP4/BqEO2jPlw1xBBiIrZUWcSTeHT9FxonciwqUb5YDYe/CIlSvaLxj6C3blg==
X-Received: by 2002:a17:90a:e98d:: with SMTP id v13mr23021514pjy.64.1571583857934;
        Sun, 20 Oct 2019 08:04:17 -0700 (PDT)
Received: from haramaki ([2400:4051:c520:1e00:e0af:68c6:243:d109])
        by smtp.gmail.com with ESMTPSA id 206sm11709853pge.80.2019.10.20.08.04.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Oct 2019 08:04:16 -0700 (PDT)
Received: by haramaki (Postfix, from userid 1000)
        id 9C2B912C1F72; Mon, 21 Oct 2019 00:04:14 +0900 (JST)
From:   Kazutoshi Noguchi <noguchi.kazutosi@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, noguchi.kazutosi@gmail.com
Subject: [PATCH] r8152: add device id for Lenovo ThinkPad USB-C Dock Gen 2
Date:   Mon, 21 Oct 2019 00:03:07 +0900
Message-Id: <20191020150306.11902-1-noguchi.kazutosi@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This device is sold as 'ThinkPad USB-C Dock Gen 2 (40AS)'.
Chipset is RTL8153 and works with r8152.
Without this, the generic cdc_ether grabs the device, and the device jam
connected networks up when the machine suspends.

Signed-off-by: Kazutoshi Noguchi <noguchi.kazutosi@gmail.com>
---
 drivers/net/usb/cdc_ether.c | 7 +++++++
 drivers/net/usb/r8152.c     | 1 +
 2 files changed, 8 insertions(+)

diff --git a/drivers/net/usb/cdc_ether.c b/drivers/net/usb/cdc_ether.c
index 32f53de5b1fe..fe630438f67b 100644
--- a/drivers/net/usb/cdc_ether.c
+++ b/drivers/net/usb/cdc_ether.c
@@ -787,6 +787,13 @@ static const struct usb_device_id	products[] = {
 	.driver_info = 0,
 },
 
+/* ThinkPad USB-C Dock Gen 2 (based on Realtek RTL8153) */
+{
+	USB_DEVICE_AND_INTERFACE_INFO(LENOVO_VENDOR_ID, 0xa387, USB_CLASS_COMM,
+			USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
+	.driver_info = 0,
+},
+
 /* NVIDIA Tegra USB 3.0 Ethernet Adapters (based on Realtek RTL8153) */
 {
 	USB_DEVICE_AND_INTERFACE_INFO(NVIDIA_VENDOR_ID, 0x09ff, USB_CLASS_COMM,
diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index cee9fef925cd..d4a95b50bda6 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -5755,6 +5755,7 @@ static const struct usb_device_id rtl8152_table[] = {
 	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x7205)},
 	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x720c)},
 	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x7214)},
+	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0xa387)},
 	{REALTEK_USB_DEVICE(VENDOR_ID_LINKSYS, 0x0041)},
 	{REALTEK_USB_DEVICE(VENDOR_ID_NVIDIA,  0x09ff)},
 	{REALTEK_USB_DEVICE(VENDOR_ID_TPLINK,  0x0601)},
-- 
2.20.1

