Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFBBE6377A9
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 12:28:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbiKXL2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 06:28:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbiKXL2j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 06:28:39 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DC651114C;
        Thu, 24 Nov 2022 03:28:37 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id b12so2068120wrn.2;
        Thu, 24 Nov 2022 03:28:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DXrDoOTEYhyFidRllMXUVbVcr0Nr2ZZdPgHvg64F4k4=;
        b=f7RBSnzB6G6U2pPKX9QR/ed5UJNNyXQhvzxcf5f1TygY/KF5P4GftnkfJ9LmtgYgSd
         nJvPObNSVdGcvWBzm61a9etnRSa2iNe8eAkEmzlek2VxXDDIW/q/RMgrmRHCZUpw01fS
         NV9GjNwTzr4BaTGsYG8G32G5LM7uhBRVMttZltFVKrWMnzZZ1H+U80RRke+qz3FMS6+q
         81Z1+HNiiyLjgJMrIIWe3Mfj9VVI9Uqe+SP8BgkLC6WNBpFiYz6zl4N3AU3iBZNAr3zJ
         DCiissG634vAUc3/d1W0pFBvVz5ND1xxei0du5WCXMBNH197aDApNJpeAm2MMfw/RRdV
         GGgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DXrDoOTEYhyFidRllMXUVbVcr0Nr2ZZdPgHvg64F4k4=;
        b=G/KLTQWF2/VfPhgwUJayF1xily0K91NYwd0DcUqlFe0cImezKjckJQ/Enn2cN9y6Q2
         U2QO0kd88yQH05Ogm2YYcxOen8oShtXlFOC3Aoj7z1fDTNRUhHPme0XH7zQrRskaY7N3
         m+7cdkRQ70z7hAqgabl41V0ZHRXgz2MQtUklrcrC/q4ktkf/2NbjBRmFbty30WOcMsxu
         8FsLLArpF98C2nQ2Ve+YRsdA/69JJ8pfII/6Bj21Hc2fyJeE58L+NN/CzGf98rqFsHsV
         MKiNIN2hvzhTJyQ5J2DBdBOxGXk20cH7WE0T3FJ9UhbB5tUTi1No5Dr2RJnFWtG6gvdH
         fw9Q==
X-Gm-Message-State: ANoB5pmvvrj0l+l+sEPtu5UhQJ/xvrc3HNAr39Kwaeet3dqAEXdhOJDj
        W5lm/Lxw58+vET/OTfPd2dc=
X-Google-Smtp-Source: AA0mqf49+b10atm85FJLTMPOA6Yay6hmTbgYXgK2MXtsxnyB9Ur4Hajfb3qFuLbdJsG4FgIKxomWSA==
X-Received: by 2002:a5d:624c:0:b0:241:c4d2:259 with SMTP id m12-20020a5d624c000000b00241c4d20259mr11967646wrv.539.1669289315849;
        Thu, 24 Nov 2022 03:28:35 -0800 (PST)
Received: from testvm.ubxad.u-blox.com ([109.52.206.94])
        by smtp.googlemail.com with ESMTPSA id x7-20020a05600c188700b003c65c9a36dfsm1274991wmp.48.2022.11.24.03.28.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Nov 2022 03:28:35 -0800 (PST)
From:   Davide Tronchin <davide.tronchin.94@gmail.com>
To:     pabeni@redhat.com
Cc:     bjorn@mork.no, davide.tronchin.94@gmail.com, kuba@kernel.org,
        linux-usb@vger.kernel.org, marco.demarco@posteo.net,
        netdev@vger.kernel.org, oliver@neukum.org
Subject: [PATCH v2] net: usb: cdc_ether: add u-blox 0x1343 composition
Date:   Thu, 24 Nov 2022 12:28:11 +0100
Message-Id: <20221124112811.3548-1-davide.tronchin.94@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <59bcf09d5eabf36eda1f940b755e3bca218f9df0.camel@redhat.com>
References: <59bcf09d5eabf36eda1f940b755e3bca218f9df0.camel@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add CDC-ECM support for LARA-L6.

LARA-L6 module can be configured (by AT interface) in three different
USB modes:
* Default mode (Vendor ID: 0x1546 Product ID: 0x1341) with 4 serial
interfaces
* RmNet mode (Vendor ID: 0x1546 Product ID: 0x1342) with 4 serial
interfaces and 1 RmNet virtual network interface
* CDC-ECM mode (Vendor ID: 0x1546 Product ID: 0x1343) with 4 serial
interface and 1 CDC-ECM virtual network interface

In CDC-ECM mode LARA-L6 exposes the following interfaces:
If 0: Diagnostic
If 1: AT parser
If 2: AT parser
If 3: AT parset/alternative functions
If 4: CDC-ECM interface

Signed-off-by: Davide Tronchin <davide.tronchin.94@gmail.com>
---

V1 -> V2 add missing Signed-off

lsusb verbose output:

$ lsusb -v -d 1546:1343

Bus 001 Device 045: ID 1546:1343 U-Blox AG u-blox Modem
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass          239 Miscellaneous Device
  bDeviceSubClass         2 
  bDeviceProtocol         1 Interface Association
  bMaxPacketSize0        64
  idVendor           0x1546 U-Blox AG
  idProduct          0x1343 
  bcdDevice            0.00
  iManufacturer           4 u-blox
  iProduct                3 u-blox Modem
  iSerial                 5 d6da37e3
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength       0x00c9
    bNumInterfaces          6
    bConfigurationValue     1
    iConfiguration          2 u-blox Configuration
    bmAttributes         0xc0
      Self Powered
    MaxPower              500mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol     48 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x01  EP 1 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           3
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               5
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        2
      bAlternateSetting       0
      bNumEndpoints           3
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    254 
      bInterfaceProtocol    255 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x84  EP 4 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               5
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x85  EP 5 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x03  EP 3 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        3
      bAlternateSetting       0
      bNumEndpoints           3
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x86  EP 6 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               5
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x87  EP 7 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x04  EP 4 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
    Interface Association:
      bLength                 8
      bDescriptorType        11
      bFirstInterface         4
      bInterfaceCount         2
      bFunctionClass          2 Communications
      bFunctionSubClass       0 
      bFunctionProtocol       0 
      iFunction               0 
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        4
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         2 Communications
      bInterfaceSubClass      6 Ethernet Networking
      bInterfaceProtocol      0 
      iInterface              0 
      CDC Header:
        bcdCDC               1.10
      CDC Ethernet:
        iMacAddress                      1 00A0C6A37E30
        bmEthernetStatistics    0x00000000
        wMaxSegmentSize              16384
        wNumberMCFilters            0x0001
        bNumberPowerFilters              0
      CDC Union:
        bMasterInterface        4
        bSlaveInterface         5 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x88  EP 8 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               5
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        5
      bAlternateSetting       0
      bNumEndpoints           0
      bInterfaceClass        10 CDC Data
      bInterfaceSubClass      0 
      bInterfaceProtocol      0 
      iInterface              0 
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        5
      bAlternateSetting       1
      bNumEndpoints           2
      bInterfaceClass        10 CDC Data
      bInterfaceSubClass      0 
      bInterfaceProtocol      0 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x89  EP 9 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x05  EP 5 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
Device Qualifier (for other device speed):
  bLength                10
  bDescriptorType         6
  bcdUSB               2.00
  bDeviceClass          239 Miscellaneous Device
  bDeviceSubClass         2 
  bDeviceProtocol         1 Interface Association
  bMaxPacketSize0        64
  bNumConfigurations      1
Device Status:     0x0000
  (Bus Powered)

---
 drivers/net/usb/cdc_ether.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/usb/cdc_ether.c b/drivers/net/usb/cdc_ether.c
index e11f70911acc..8911cd2ed534 100644
--- a/drivers/net/usb/cdc_ether.c
+++ b/drivers/net/usb/cdc_ether.c
@@ -989,6 +989,12 @@ static const struct usb_device_id	products[] = {
 				      USB_CDC_SUBCLASS_ETHERNET,
 				      USB_CDC_PROTO_NONE),
 	.driver_info = (unsigned long)&wwan_info,
+}, {
+	/* U-blox LARA-L6 */
+	USB_DEVICE_AND_INTERFACE_INFO(UBLOX_VENDOR_ID, 0x1343, USB_CLASS_COMM,
+				      USB_CDC_SUBCLASS_ETHERNET,
+				      USB_CDC_PROTO_NONE),
+	.driver_info = (unsigned long)&wwan_info,
 }, {
 	/* Cinterion PLS8 modem by GEMALTO */
 	USB_DEVICE_AND_INTERFACE_INFO(0x1e2d, 0x0061, USB_CLASS_COMM,
-- 
2.34.1

