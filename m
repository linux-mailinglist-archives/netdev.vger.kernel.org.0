Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F09892A408F
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 10:48:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727986AbgKCJrM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 04:47:12 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:38553 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727835AbgKCJrH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 04:47:07 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 0A39kwXbB013834, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexmb04.realtek.com.tw[172.21.6.97])
        by rtits2.realtek.com.tw (8.15.2/2.70/5.88) with ESMTPS id 0A39kwXbB013834
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 3 Nov 2020 17:46:58 +0800
Received: from fc32.localdomain (172.21.177.102) by RTEXMB04.realtek.com.tw
 (172.21.6.97) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Tue, 3 Nov 2020
 17:46:58 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     <netdev@vger.kernel.org>, <gregkh@linuxfoundation.org>
CC:     <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <oliver@neukum.org>,
        Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next v3 1/2] include/linux/usb: new header file for the vendor ID of USB devices
Date:   Tue, 3 Nov 2020 17:46:37 +0800
Message-ID: <1394712342-15778-390-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <1394712342-15778-389-Taiwan-albertk@realtek.com>
References: <1394712342-15778-387-Taiwan-albertk@realtek.com>
 <1394712342-15778-389-Taiwan-albertk@realtek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.21.177.102]
X-ClientProxiedBy: RTEXMB01.realtek.com.tw (172.21.6.94) To
 RTEXMB04.realtek.com.tw (172.21.6.97)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new header file usb_vendor_id.h to consolidate the definitions
of the vendor ID of USB devices which may be used by cdc_ether and
r8152 driver.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/cdc_ether.c       | 139 +++++++++++++-----------------
 drivers/net/usb/r8152.c           |  48 +++++------
 include/linux/usb/usb_vendor_id.h |  51 +++++++++++
 3 files changed, 133 insertions(+), 105 deletions(-)
 create mode 100644 include/linux/usb/usb_vendor_id.h

diff --git a/drivers/net/usb/cdc_ether.c b/drivers/net/usb/cdc_ether.c
index 8c1d61c2cbac..1f6d9b46883a 100644
--- a/drivers/net/usb/cdc_ether.c
+++ b/drivers/net/usb/cdc_ether.c
@@ -17,6 +17,7 @@
 #include <linux/usb.h>
 #include <linux/usb/cdc.h>
 #include <linux/usb/usbnet.h>
+#include <linux/usb/usb_vendor_id.h>
 
 
 #if IS_ENABLED(CONFIG_USB_NET_RNDIS_HOST)
@@ -540,22 +541,6 @@ static const struct driver_info wwan_info = {
 
 /*-------------------------------------------------------------------------*/
 
-#define HUAWEI_VENDOR_ID	0x12D1
-#define NOVATEL_VENDOR_ID	0x1410
-#define ZTE_VENDOR_ID		0x19D2
-#define DELL_VENDOR_ID		0x413C
-#define REALTEK_VENDOR_ID	0x0bda
-#define SAMSUNG_VENDOR_ID	0x04e8
-#define LENOVO_VENDOR_ID	0x17ef
-#define LINKSYS_VENDOR_ID	0x13b1
-#define NVIDIA_VENDOR_ID	0x0955
-#define HP_VENDOR_ID		0x03f0
-#define MICROSOFT_VENDOR_ID	0x045e
-#define UBLOX_VENDOR_ID		0x1546
-#define TPLINK_VENDOR_ID	0x2357
-#define AQUANTIA_VENDOR_ID	0x2eca
-#define ASIX_VENDOR_ID		0x0b95
-
 static const struct usb_device_id	products[] = {
 /* BLACKLIST !!
  *
@@ -661,49 +646,49 @@ static const struct usb_device_id	products[] = {
 
 /* Novatel USB551L and MC551 - handled by qmi_wwan */
 {
-	USB_DEVICE_AND_INTERFACE_INFO(NOVATEL_VENDOR_ID, 0xB001, USB_CLASS_COMM,
-			USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
+	USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_NOVATEL, 0xB001, USB_CLASS_COMM,
+				      USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
 	.driver_info = 0,
 },
 
 /* Novatel E362 - handled by qmi_wwan */
 {
-	USB_DEVICE_AND_INTERFACE_INFO(NOVATEL_VENDOR_ID, 0x9010, USB_CLASS_COMM,
-			USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
+	USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_NOVATEL, 0x9010, USB_CLASS_COMM,
+				      USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
 	.driver_info = 0,
 },
 
 /* Dell Wireless 5800 (Novatel E362) - handled by qmi_wwan */
 {
-	USB_DEVICE_AND_INTERFACE_INFO(DELL_VENDOR_ID, 0x8195, USB_CLASS_COMM,
-			USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
+	USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_DELL, 0x8195, USB_CLASS_COMM,
+				      USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
 	.driver_info = 0,
 },
 
 /* Dell Wireless 5800 (Novatel E362) - handled by qmi_wwan */
 {
-	USB_DEVICE_AND_INTERFACE_INFO(DELL_VENDOR_ID, 0x8196, USB_CLASS_COMM,
-			USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
+	USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_DELL, 0x8196, USB_CLASS_COMM,
+				      USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
 	.driver_info = 0,
 },
 
 /* Dell Wireless 5804 (Novatel E371) - handled by qmi_wwan */
 {
-	USB_DEVICE_AND_INTERFACE_INFO(DELL_VENDOR_ID, 0x819b, USB_CLASS_COMM,
-			USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
+	USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_DELL, 0x819b, USB_CLASS_COMM,
+				      USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
 	.driver_info = 0,
 },
 
 /* Novatel Expedite E371 - handled by qmi_wwan */
 {
-	USB_DEVICE_AND_INTERFACE_INFO(NOVATEL_VENDOR_ID, 0x9011, USB_CLASS_COMM,
-			USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
+	USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_NOVATEL, 0x9011, USB_CLASS_COMM,
+				      USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
 	.driver_info = 0,
 },
 
 /* HP lt2523 (Novatel E371) - handled by qmi_wwan */
 {
-	USB_DEVICE_AND_INTERFACE_INFO(HP_VENDOR_ID, 0x421d, USB_CLASS_COMM,
+	USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_HP, 0x421d, USB_CLASS_COMM,
 				      USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
 	.driver_info = 0,
 },
@@ -717,127 +702,127 @@ static const struct usb_device_id	products[] = {
 
 /* Huawei E1820 - handled by qmi_wwan */
 {
-	USB_DEVICE_INTERFACE_NUMBER(HUAWEI_VENDOR_ID, 0x14ac, 1),
+	USB_DEVICE_INTERFACE_NUMBER(USB_VENDOR_ID_HUAWEI, 0x14ac, 1),
 	.driver_info = 0,
 },
 
 /* Realtek RTL8152 Based USB 2.0 Ethernet Adapters */
 {
-	USB_DEVICE_AND_INTERFACE_INFO(REALTEK_VENDOR_ID, 0x8152, USB_CLASS_COMM,
-			USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
+	USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_REALTEK, 0x8152, USB_CLASS_COMM,
+				      USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
 	.driver_info = 0,
 },
 
 /* Realtek RTL8153 Based USB 3.0 Ethernet Adapters */
 {
-	USB_DEVICE_AND_INTERFACE_INFO(REALTEK_VENDOR_ID, 0x8153, USB_CLASS_COMM,
-			USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
+	USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_REALTEK, 0x8153, USB_CLASS_COMM,
+				      USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
 	.driver_info = 0,
 },
 
 /* Samsung USB Ethernet Adapters */
 {
-	USB_DEVICE_AND_INTERFACE_INFO(SAMSUNG_VENDOR_ID, 0xa101, USB_CLASS_COMM,
-			USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
+	USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_SAMSUNG, 0xa101, USB_CLASS_COMM,
+				      USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
 	.driver_info = 0,
 },
 
 #if IS_ENABLED(CONFIG_USB_RTL8152)
 /* Linksys USB3GIGV1 Ethernet Adapter */
 {
-	USB_DEVICE_AND_INTERFACE_INFO(LINKSYS_VENDOR_ID, 0x0041, USB_CLASS_COMM,
-			USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
+	USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_LINKSYS, 0x0041, USB_CLASS_COMM,
+				      USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
 	.driver_info = 0,
 },
 #endif
 
 /* ThinkPad USB-C Dock (based on Realtek RTL8153) */
 {
-	USB_DEVICE_AND_INTERFACE_INFO(LENOVO_VENDOR_ID, 0x3062, USB_CLASS_COMM,
-			USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
+	USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_LENOVO, 0x3062, USB_CLASS_COMM,
+				      USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
 	.driver_info = 0,
 },
 
 /* ThinkPad Thunderbolt 3 Dock (based on Realtek RTL8153) */
 {
-	USB_DEVICE_AND_INTERFACE_INFO(LENOVO_VENDOR_ID, 0x3069, USB_CLASS_COMM,
-			USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
+	USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_LENOVO, 0x3069, USB_CLASS_COMM,
+				      USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
 	.driver_info = 0,
 },
 
 /* ThinkPad Thunderbolt 3 Dock Gen 2 (based on Realtek RTL8153) */
 {
-	USB_DEVICE_AND_INTERFACE_INFO(LENOVO_VENDOR_ID, 0x3082, USB_CLASS_COMM,
-			USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
+	USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_LENOVO, 0x3082, USB_CLASS_COMM,
+				      USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
 	.driver_info = 0,
 },
 
 /* Lenovo Thinkpad USB 3.0 Ethernet Adapters (based on Realtek RTL8153) */
 {
-	USB_DEVICE_AND_INTERFACE_INFO(LENOVO_VENDOR_ID, 0x7205, USB_CLASS_COMM,
-			USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
+	USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_LENOVO, 0x7205, USB_CLASS_COMM,
+				      USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
 	.driver_info = 0,
 },
 
 /* Lenovo USB C to Ethernet Adapter (based on Realtek RTL8153) */
 {
-	USB_DEVICE_AND_INTERFACE_INFO(LENOVO_VENDOR_ID, 0x720c, USB_CLASS_COMM,
-			USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
+	USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_LENOVO, 0x720c, USB_CLASS_COMM,
+				      USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
 	.driver_info = 0,
 },
 
 /* Lenovo USB-C Travel Hub (based on Realtek RTL8153) */
 {
-	USB_DEVICE_AND_INTERFACE_INFO(LENOVO_VENDOR_ID, 0x7214, USB_CLASS_COMM,
-			USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
+	USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_LENOVO, 0x7214, USB_CLASS_COMM,
+				      USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
 	.driver_info = 0,
 },
 
 /* ThinkPad USB-C Dock Gen 2 (based on Realtek RTL8153) */
 {
-	USB_DEVICE_AND_INTERFACE_INFO(LENOVO_VENDOR_ID, 0xa387, USB_CLASS_COMM,
-			USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
+	USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_LENOVO, 0xa387, USB_CLASS_COMM,
+				      USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
 	.driver_info = 0,
 },
 
 /* NVIDIA Tegra USB 3.0 Ethernet Adapters (based on Realtek RTL8153) */
 {
-	USB_DEVICE_AND_INTERFACE_INFO(NVIDIA_VENDOR_ID, 0x09ff, USB_CLASS_COMM,
-			USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
+	USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_NVIDIA, 0x09ff, USB_CLASS_COMM,
+				      USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
 	.driver_info = 0,
 },
 
 /* Microsoft Surface 2 dock (based on Realtek RTL8152) */
 {
-	USB_DEVICE_AND_INTERFACE_INFO(MICROSOFT_VENDOR_ID, 0x07ab, USB_CLASS_COMM,
-			USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
+	USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_MICROSOFT, 0x07ab, USB_CLASS_COMM,
+				      USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
 	.driver_info = 0,
 },
 
 /* Microsoft Surface Ethernet Adapter (based on Realtek RTL8153) */
 {
-	USB_DEVICE_AND_INTERFACE_INFO(MICROSOFT_VENDOR_ID, 0x07c6, USB_CLASS_COMM,
-			USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
+	USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_MICROSOFT, 0x07c6, USB_CLASS_COMM,
+				      USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
 	.driver_info = 0,
 },
 
 /* Microsoft Surface Ethernet Adapter (based on Realtek RTL8153B) */
 {
-	USB_DEVICE_AND_INTERFACE_INFO(MICROSOFT_VENDOR_ID, 0x0927, USB_CLASS_COMM,
-			USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
+	USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_MICROSOFT, 0x0927, USB_CLASS_COMM,
+				      USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
 	.driver_info = 0,
 },
 
 /* TP-LINK UE300 USB 3.0 Ethernet Adapters (based on Realtek RTL8153) */
 {
-	USB_DEVICE_AND_INTERFACE_INFO(TPLINK_VENDOR_ID, 0x0601, USB_CLASS_COMM,
-			USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
+	USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_TPLINK, 0x0601, USB_CLASS_COMM,
+				      USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
 	.driver_info = 0,
 },
 
 /* Aquantia AQtion USB to 5GbE Controller (based on AQC111U) */
 {
-	USB_DEVICE_AND_INTERFACE_INFO(AQUANTIA_VENDOR_ID, 0xc101,
+	USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_AQUANTIA, 0xc101,
 				      USB_CLASS_COMM, USB_CDC_SUBCLASS_ETHERNET,
 				      USB_CDC_PROTO_NONE),
 	.driver_info = 0,
@@ -845,7 +830,7 @@ static const struct usb_device_id	products[] = {
 
 /* ASIX USB 3.1 Gen1 to 5G Multi-Gigabit Ethernet Adapter(based on AQC111U) */
 {
-	USB_DEVICE_AND_INTERFACE_INFO(ASIX_VENDOR_ID, 0x2790, USB_CLASS_COMM,
+	USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_ASIX, 0x2790, USB_CLASS_COMM,
 				      USB_CDC_SUBCLASS_ETHERNET,
 				      USB_CDC_PROTO_NONE),
 	.driver_info = 0,
@@ -853,7 +838,7 @@ static const struct usb_device_id	products[] = {
 
 /* ASIX USB 3.1 Gen1 to 2.5G Multi-Gigabit Ethernet Adapter(based on AQC112U) */
 {
-	USB_DEVICE_AND_INTERFACE_INFO(ASIX_VENDOR_ID, 0x2791, USB_CLASS_COMM,
+	USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_ASIX, 0x2791, USB_CLASS_COMM,
 				      USB_CDC_SUBCLASS_ETHERNET,
 				      USB_CDC_PROTO_NONE),
 	.driver_info = 0,
@@ -887,31 +872,31 @@ static const struct usb_device_id	products[] = {
  */
 {
 	/* ZTE (Vodafone) K3805-Z */
-	USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1003, USB_CLASS_COMM,
+	USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_ZTE, 0x1003, USB_CLASS_COMM,
 				      USB_CDC_SUBCLASS_ETHERNET,
 				      USB_CDC_PROTO_NONE),
 	.driver_info = (unsigned long)&wwan_info,
 }, {
 	/* ZTE (Vodafone) K3806-Z */
-	USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1015, USB_CLASS_COMM,
+	USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_ZTE, 0x1015, USB_CLASS_COMM,
 				      USB_CDC_SUBCLASS_ETHERNET,
 				      USB_CDC_PROTO_NONE),
 	.driver_info = (unsigned long)&wwan_info,
 }, {
 	/* ZTE (Vodafone) K4510-Z */
-	USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1173, USB_CLASS_COMM,
+	USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_ZTE, 0x1173, USB_CLASS_COMM,
 				      USB_CDC_SUBCLASS_ETHERNET,
 				      USB_CDC_PROTO_NONE),
 	.driver_info = (unsigned long)&wwan_info,
 }, {
 	/* ZTE (Vodafone) K3770-Z */
-	USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1177, USB_CLASS_COMM,
+	USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_ZTE, 0x1177, USB_CLASS_COMM,
 				      USB_CDC_SUBCLASS_ETHERNET,
 				      USB_CDC_PROTO_NONE),
 	.driver_info = (unsigned long)&wwan_info,
 }, {
 	/* ZTE (Vodafone) K3772-Z */
-	USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1181, USB_CLASS_COMM,
+	USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_ZTE, 0x1181, USB_CLASS_COMM,
 				      USB_CDC_SUBCLASS_ETHERNET,
 				      USB_CDC_PROTO_NONE),
 	.driver_info = (unsigned long)&wwan_info,
@@ -922,30 +907,30 @@ static const struct usb_device_id	products[] = {
 	.driver_info = (kernel_ulong_t) &wwan_info,
 }, {
 	/* Dell DW5580 modules */
-	USB_DEVICE_AND_INTERFACE_INFO(DELL_VENDOR_ID, 0x81ba, USB_CLASS_COMM,
-			USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
+	USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_DELL, 0x81ba, USB_CLASS_COMM,
+				      USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
 	.driver_info = (kernel_ulong_t)&wwan_info,
 }, {
 	/* Huawei ME906 and ME909 */
-	USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0x15c1, USB_CLASS_COMM,
+	USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_HUAWEI, 0x15c1, USB_CLASS_COMM,
 				      USB_CDC_SUBCLASS_ETHERNET,
 				      USB_CDC_PROTO_NONE),
 	.driver_info = (unsigned long)&wwan_info,
 }, {
 	/* ZTE modules */
-	USB_VENDOR_AND_INTERFACE_INFO(ZTE_VENDOR_ID, USB_CLASS_COMM,
+	USB_VENDOR_AND_INTERFACE_INFO(USB_VENDOR_ID_ZTE, USB_CLASS_COMM,
 				      USB_CDC_SUBCLASS_ETHERNET,
 				      USB_CDC_PROTO_NONE),
 	.driver_info = (unsigned long)&zte_cdc_info,
 }, {
 	/* U-blox TOBY-L2 */
-	USB_DEVICE_AND_INTERFACE_INFO(UBLOX_VENDOR_ID, 0x1143, USB_CLASS_COMM,
+	USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_UBLOX, 0x1143, USB_CLASS_COMM,
 				      USB_CDC_SUBCLASS_ETHERNET,
 				      USB_CDC_PROTO_NONE),
 	.driver_info = (unsigned long)&wwan_info,
 }, {
 	/* U-blox SARA-U2 */
-	USB_DEVICE_AND_INTERFACE_INFO(UBLOX_VENDOR_ID, 0x1104, USB_CLASS_COMM,
+	USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_UBLOX, 0x1104, USB_CLASS_COMM,
 				      USB_CDC_SUBCLASS_ETHERNET,
 				      USB_CDC_PROTO_NONE),
 	.driver_info = (unsigned long)&wwan_info,
@@ -972,7 +957,7 @@ static const struct usb_device_id	products[] = {
 
 }, {
 	/* Various Huawei modems with a network port like the UMG1831 */
-	USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, USB_CLASS_COMM,
+	USB_VENDOR_AND_INTERFACE_INFO(USB_VENDOR_ID_HUAWEI, USB_CLASS_COMM,
 				      USB_CDC_SUBCLASS_ETHERNET, 255),
 	.driver_info = (unsigned long)&wwan_info,
 },
diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index b1770489aca5..d8ae89aa470c 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -26,6 +26,7 @@
 #include <linux/acpi.h>
 #include <linux/firmware.h>
 #include <crypto/hash.h>
+#include <linux/usb/usb_vendor_id.h>
 
 /* Information for net-next */
 #define NETNEXT_VERSION		"11"
@@ -689,15 +690,6 @@ enum rtl8152_flags {
 	LENOVO_MACPASSTHRU,
 };
 
-/* Define these values to match your device */
-#define VENDOR_ID_REALTEK		0x0bda
-#define VENDOR_ID_MICROSOFT		0x045e
-#define VENDOR_ID_SAMSUNG		0x04e8
-#define VENDOR_ID_LENOVO		0x17ef
-#define VENDOR_ID_LINKSYS		0x13b1
-#define VENDOR_ID_NVIDIA		0x0955
-#define VENDOR_ID_TPLINK		0x2357
-
 #define DEVICE_ID_THINKPAD_THUNDERBOLT3_DOCK_GEN2	0x3082
 #define DEVICE_ID_THINKPAD_USB_C_DOCK_GEN2		0xa387
 
@@ -6753,7 +6745,7 @@ static int rtl8152_probe(struct usb_interface *intf,
 		netdev->hw_features &= ~NETIF_F_RXCSUM;
 	}
 
-	if (le16_to_cpu(udev->descriptor.idVendor) == VENDOR_ID_LENOVO) {
+	if (le16_to_cpu(udev->descriptor.idVendor) == USB_VENDOR_ID_LENOVO) {
 		switch (le16_to_cpu(udev->descriptor.idProduct)) {
 		case DEVICE_ID_THINKPAD_THUNDERBOLT3_DOCK_GEN2:
 		case DEVICE_ID_THINKPAD_USB_C_DOCK_GEN2:
@@ -6879,24 +6871,24 @@ static void rtl8152_disconnect(struct usb_interface *intf)
 
 /* table of devices that work with this driver */
 static const struct usb_device_id rtl8152_table[] = {
-	{REALTEK_USB_DEVICE(VENDOR_ID_REALTEK, 0x8050)},
-	{REALTEK_USB_DEVICE(VENDOR_ID_REALTEK, 0x8152)},
-	{REALTEK_USB_DEVICE(VENDOR_ID_REALTEK, 0x8153)},
-	{REALTEK_USB_DEVICE(VENDOR_ID_MICROSOFT, 0x07ab)},
-	{REALTEK_USB_DEVICE(VENDOR_ID_MICROSOFT, 0x07c6)},
-	{REALTEK_USB_DEVICE(VENDOR_ID_MICROSOFT, 0x0927)},
-	{REALTEK_USB_DEVICE(VENDOR_ID_SAMSUNG, 0xa101)},
-	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x304f)},
-	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x3062)},
-	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x3069)},
-	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x3082)},
-	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x7205)},
-	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x720c)},
-	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x7214)},
-	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0xa387)},
-	{REALTEK_USB_DEVICE(VENDOR_ID_LINKSYS, 0x0041)},
-	{REALTEK_USB_DEVICE(VENDOR_ID_NVIDIA,  0x09ff)},
-	{REALTEK_USB_DEVICE(VENDOR_ID_TPLINK,  0x0601)},
+	{REALTEK_USB_DEVICE(USB_VENDOR_ID_REALTEK, 0x8050)},
+	{REALTEK_USB_DEVICE(USB_VENDOR_ID_REALTEK, 0x8152)},
+	{REALTEK_USB_DEVICE(USB_VENDOR_ID_REALTEK, 0x8153)},
+	{REALTEK_USB_DEVICE(USB_VENDOR_ID_REALTEK, 0x07ab)},
+	{REALTEK_USB_DEVICE(USB_VENDOR_ID_REALTEK, 0x07c6)},
+	{REALTEK_USB_DEVICE(USB_VENDOR_ID_REALTEK, 0x0927)},
+	{REALTEK_USB_DEVICE(USB_VENDOR_ID_SAMSUNG, 0xa101)},
+	{REALTEK_USB_DEVICE(USB_VENDOR_ID_LENOVO,  0x304f)},
+	{REALTEK_USB_DEVICE(USB_VENDOR_ID_LENOVO,  0x3062)},
+	{REALTEK_USB_DEVICE(USB_VENDOR_ID_LENOVO,  0x3069)},
+	{REALTEK_USB_DEVICE(USB_VENDOR_ID_LENOVO,  0x3082)},
+	{REALTEK_USB_DEVICE(USB_VENDOR_ID_LENOVO,  0x7205)},
+	{REALTEK_USB_DEVICE(USB_VENDOR_ID_LENOVO,  0x720c)},
+	{REALTEK_USB_DEVICE(USB_VENDOR_ID_LENOVO,  0x7214)},
+	{REALTEK_USB_DEVICE(USB_VENDOR_ID_LENOVO,  0xa387)},
+	{REALTEK_USB_DEVICE(USB_VENDOR_ID_LINKSYS, 0x0041)},
+	{REALTEK_USB_DEVICE(USB_VENDOR_ID_NVIDIA,  0x09ff)},
+	{REALTEK_USB_DEVICE(USB_VENDOR_ID_TPLINK,  0x0601)},
 	{}
 };
 
diff --git a/include/linux/usb/usb_vendor_id.h b/include/linux/usb/usb_vendor_id.h
new file mode 100644
index 000000000000..23b6e6849515
--- /dev/null
+++ b/include/linux/usb/usb_vendor_id.h
@@ -0,0 +1,51 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+
+#ifndef LINUX_USB_VENDOR_ID_H
+#define LINUX_USB_VENDOR_ID_H
+
+/* Realtek Semiconductor Corp. */
+#define USB_VENDOR_ID_REALTEK				0x0bda
+
+/* Microsoft Corp */
+#define USB_VENDOR_ID_MICROSOFT				0x045e
+
+/* Samsung */
+#define USB_VENDOR_ID_SAMSUNG				0x04e8
+
+/* Lenovo */
+#define USB_VENDOR_ID_LENOVO				0x17ef
+
+/* Linksys */
+#define USB_VENDOR_ID_LINKSYS				0x13b1
+
+/* NVIDIA Corp. */
+#define USB_VENDOR_ID_NVIDIA				0x0955
+
+/* TP-Link */
+#define USB_VENDOR_ID_TPLINK				0x2357
+
+/* Huawei Technologies Co., Ltd. */
+#define USB_VENDOR_ID_HUAWEI				0x12D1
+
+/* Novatel Wireless */
+#define USB_VENDOR_ID_NOVATEL				0x1410
+
+/* ZTE WCDMA Technologies MSM */
+#define USB_VENDOR_ID_ZTE				0x19D2
+
+/* Dell Computer Corp */
+#define USB_VENDOR_ID_DELL				0x413C
+
+/* HP, Inc */
+#define USB_VENDOR_ID_HP				0x03f0
+
+/* U-Blox AG */
+#define USB_VENDOR_ID_UBLOX				0x1546
+
+/* Aquantia */
+#define USB_VENDOR_ID_AQUANTIA				0x2eca
+
+/* ASIX Electronics Corp. */
+#define USB_VENDOR_ID_ASIX				0x0b95
+
+#endif /* LINUX_USB_VENDOR_ID_H */
-- 
2.26.2

