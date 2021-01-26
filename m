Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5280D305C4B
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 13:59:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S313910AbhAZWtV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 17:49:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726840AbhAZEmr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 23:42:47 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82418C061573;
        Mon, 25 Jan 2021 20:42:05 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id g1so18222195edu.4;
        Mon, 25 Jan 2021 20:42:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=9yCUCO33bIUfmXmhlow4Pw9ekcWCVlpA1POTUtdkoJQ=;
        b=Vgjwia0aLiZ3/CtqZFv8K2f6XV1GJQThvTBMDSFc9bU95gVe9HQD91Cwil+w2XqMez
         40jDKtgFVBvozxmdC3kcaGVw988b54dtItr98o0MgopXE3bM/WR1W80vQcMKCeOd3n+1
         9UCY20zQyW/FY9PTXlHKTXAHxAf7mbs+rNEdBmnkjAt0b4nR8+WoHj45EOM6+MoDiHOk
         IwX4kxqAaM7Sq6/7JH0lXCodBO9lfVg3+6H3Ivzoc5mZST4yLiCOTXNdARxp8G0tHIDk
         9CPWxN6bXqLUfUae0XY6Td1dW0WtTCcxyuJUks4N3Jcmt2jurh//LfqdIjxtaxOBCf4F
         C08w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=9yCUCO33bIUfmXmhlow4Pw9ekcWCVlpA1POTUtdkoJQ=;
        b=L49QTZ5KlD+BgJCxIoMdqfOETSOfAJXkFRS5Kdto3YkwHy8V9ksA7ojLGn8BMzZ5iM
         99Pj/KPZKP9JqoHPTPG5KgqmOapkO/B+xGPoTOiP/BpdcofzUEHVPHwZX3LMje5cnls7
         sABL56iff/8vTGdM99M/deA+DNgFxYR9AQHOi+nc0cxE5N3EvIJx7ygefO4Thrv7mMkr
         NmwkkYJ2mive8/VaS3nQh8vgJi3dudC2BkDfR8rzqdXRyNQs2X0uurPpPnx6Ho4l9FaR
         FJmH1mMVoR+mg+X+5hO96gi3xtxXF6VaVk2ueJGzFlfe9GS2cZdp3j9qbuFAcq39mhFX
         4Eog==
X-Gm-Message-State: AOAM530g1Zy4+FOEdzFfQEYkJcRCEYYgQ4FL/pCMxpmvjc5hZ93ADl7K
        o5KW0681z3HcIb7IP2oFSc4=
X-Google-Smtp-Source: ABdhPJyOiMNSeKHhuLR7mEnqMqYXU4mHZjaWnODVfht1KV0ZKZrlGYDM3x+MbGPeruUkRUSbo/pFcw==
X-Received: by 2002:a50:852a:: with SMTP id 39mr3178231edr.114.1611636124170;
        Mon, 25 Jan 2021 20:42:04 -0800 (PST)
Received: from gci-Precision-M2800.fritz.box ([2a02:8109:8b00:c24:906e:aa4c:c963:8f7c])
        by smtp.googlemail.com with ESMTPSA id l17sm2240882edr.75.2021.01.25.20.42.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jan 2021 20:42:03 -0800 (PST)
From:   Giacinto Cifelli <gciofono@gmail.com>
To:     oliver@neukum.org, davem@davemloft.net, kuba@kernel.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org
Cc:     Giacinto Cifelli <gciofono@gmail.com>
Subject: [PATCH] net: usb: qmi_wwan: added support for Thales Cinterion PLSx3 modem family
Date:   Tue, 26 Jan 2021 05:41:55 +0100
Message-Id: <20210126044155.8348-1-gciofono@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bus 003 Device 009: ID 1e2d:006f
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass          239 Miscellaneous Device
  bDeviceSubClass         2 ?
  bDeviceProtocol         1 Interface Association
  bMaxPacketSize0        64
  idVendor           0x1e2d
  idProduct          0x006f
  bcdDevice            0.00
  iManufacturer           3 Cinterion Wireless Modules
  iProduct                2 PLSx3
  iSerial                 4 fa3c1419
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength          303
    bNumInterfaces          9
    bConfigurationValue     1
    iConfiguration          1 Cinterion Configuration
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower              500mA
    Interface Association:
      bLength                 8
      bDescriptorType        11
      bFirstInterface         0
      bInterfaceCount         2
      bFunctionClass          2 Communications
      bFunctionSubClass       2 Abstract (modem)
      bFunctionProtocol       1 AT-commands (v.25ter)
      iFunction               0
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         2 Communications
      bInterfaceSubClass      2 Abstract (modem)
      bInterfaceProtocol      1 AT-commands (v.25ter)
      iInterface              0
      CDC Header:
        bcdCDC               1.10
      CDC ACM:
        bmCapabilities       0x02
          line coding and serial state
      CDC Call Management:
        bmCapabilities       0x03
          call management
          use DataInterface
        bDataInterface          1
      CDC Union:
        bMasterInterface        0
        bSlaveInterface         1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               5
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass        10 CDC Data
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
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
    Interface Association:
      bLength                 8
      bDescriptorType        11
      bFirstInterface         2
      bInterfaceCount         2
      bFunctionClass          2 Communications
      bFunctionSubClass       2 Abstract (modem)
      bFunctionProtocol       1 AT-commands (v.25ter)
      iFunction               0
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        2
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         2 Communications
      bInterfaceSubClass      2 Abstract (modem)
      bInterfaceProtocol      1 AT-commands (v.25ter)
      iInterface              0
      CDC Header:
        bcdCDC               1.10
      CDC ACM:
        bmCapabilities       0x02
          line coding and serial state
      CDC Call Management:
        bmCapabilities       0x03
          call management
          use DataInterface
        bDataInterface          3
      CDC Union:
        bMasterInterface        2
        bSlaveInterface         3
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               5
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        3
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass        10 CDC Data
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x84  EP 4 IN
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
    Interface Association:
      bLength                 8
      bDescriptorType        11
      bFirstInterface         4
      bInterfaceCount         2
      bFunctionClass          2 Communications
      bFunctionSubClass       2 Abstract (modem)
      bFunctionProtocol       1 AT-commands (v.25ter)
      iFunction               0
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        4
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         2 Communications
      bInterfaceSubClass      2 Abstract (modem)
      bInterfaceProtocol      1 AT-commands (v.25ter)
      iInterface              0
      CDC Header:
        bcdCDC               1.10
      CDC ACM:
        bmCapabilities       0x02
          line coding and serial state
      CDC Call Management:
        bmCapabilities       0x03
          call management
          use DataInterface
        bDataInterface          5
      CDC Union:
        bMasterInterface        4
        bSlaveInterface         5
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x85  EP 5 IN
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
      bNumEndpoints           2
      bInterfaceClass        10 CDC Data
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x86  EP 6 IN
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
    Interface Association:
      bLength                 8
      bDescriptorType        11
      bFirstInterface         6
      bInterfaceCount         2
      bFunctionClass          2 Communications
      bFunctionSubClass       2 Abstract (modem)
      bFunctionProtocol       1 AT-commands (v.25ter)
      iFunction               0
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        6
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         2 Communications
      bInterfaceSubClass      2 Abstract (modem)
      bInterfaceProtocol      1 AT-commands (v.25ter)
      iInterface              0
      CDC Header:
        bcdCDC               1.10
      CDC ACM:
        bmCapabilities       0x02
          line coding and serial state
      CDC Call Management:
        bmCapabilities       0x03
          call management
          use DataInterface
        bDataInterface          7
      CDC Union:
        bMasterInterface        6
        bSlaveInterface         7
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x87  EP 7 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               5
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        7
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass        10 CDC Data
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x88  EP 8 IN
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
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        8
      bAlternateSetting       0
      bNumEndpoints           3
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x89  EP 9 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               5
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x8a  EP 10 IN
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
  bDeviceSubClass         2 ?
  bDeviceProtocol         1 Interface Association
  bMaxPacketSize0        64
  bNumConfigurations      1
Device Status:     0x0000
  (Bus Powered)

Signed-off-by: Giacinto Cifelli <gciofono@gmail.com>
---
 drivers/net/usb/qmi_wwan.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index af19513a9f75..262d19439b34 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1302,6 +1302,8 @@ static const struct usb_device_id products[] = {
 	{QMI_FIXED_INTF(0x0b3c, 0xc00a, 6)},	/* Olivetti Olicard 160 */
 	{QMI_FIXED_INTF(0x0b3c, 0xc00b, 4)},	/* Olivetti Olicard 500 */
 	{QMI_FIXED_INTF(0x1e2d, 0x0060, 4)},	/* Cinterion PLxx */
+	{QMI_FIXED_INTF(0x1e2d, 0x006f, 8)},	/* Cinterion PLS83/PLS63 */
+	{QMI_QUIRK_SET_DTR(0x1e2d, 0x006f, 8)},
 	{QMI_FIXED_INTF(0x1e2d, 0x0053, 4)},	/* Cinterion PHxx,PXxx */
 	{QMI_FIXED_INTF(0x1e2d, 0x0063, 10)},	/* Cinterion ALASxx (1 RmNet) */
 	{QMI_FIXED_INTF(0x1e2d, 0x0082, 4)},	/* Cinterion PHxx,PXxx (2 RmNet) */
-- 
2.17.1

