Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1108E6296A0
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 12:02:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbiKOLCX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 06:02:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237915AbiKOLBg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 06:01:36 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD13C264B2;
        Tue, 15 Nov 2022 03:01:08 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id e189so10378451iof.1;
        Tue, 15 Nov 2022 03:01:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=kCerPG4/dIVYiG6pu2aobx55zKrbPRV4qVM/Qg/oZ1Y=;
        b=PIPQx6szR9QKl8aLceRVROj79PfcF80u789pDfauQWD6M+7h3i9jJ8+2XEFMSbTzuV
         Bgtxag/g61ubrMaZA0QJXO+ji1Bx74AH+SUU8efJ/4xNYT4YFjiuDD4EXo2Y2efIOset
         ZXE8xfUCrjbalNnY0xMsA6tiLIeeGkiy13bVJEykisSvtBEXH9VATc7PhYfUVprYwC8m
         ShIKB8uN7orDQHZITAR8MBjPKAl6KFdVYNdJGT2ejzRdnbfc7I5c8Ub1P5mSREhRG6gB
         pCJ6VDL6gLeVzcbOhvrRnI0DlthHYmMeHTYVaS1w0VjO0jQZcgLfN/niv3ZdvSn2JEkf
         eW8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kCerPG4/dIVYiG6pu2aobx55zKrbPRV4qVM/Qg/oZ1Y=;
        b=Ml9oYanCmjDLDvtoirN7FpatQyhCwG5TBEWLkClnPnUmX+6z1xd+dfV8p87ouejawz
         zKOiJoMvrwlsB/+68bPQ2TjUxPjW7cA9Q5dsw/NBPYhvcUvtHfSwFHdyPl+x/HJBiWI+
         V6zMLp5L8AcHNNLkOLxm83xZvhs4w2UZzlRssJsYIcTflqrsKGJez4eZw1n+wQoXIR1K
         UQL97MAof4+tar7nLfQWpsfMpIje31ZvoqIbEfX+ufHrunTtk2oJFeJAx4gGFuR041Hk
         DpsesZOawjjxrB+c1hXY1o3lWsBI1B5aYAeRKpxMrv3Brxkn2m9xEsetTImrLy27IhAX
         gggA==
X-Gm-Message-State: ANoB5plgYCiYdB9Ql5Bjdn3PD7CYQu5c2fhJsooFI7qlRhidw8PQlJmJ
        xPoysF7JVquLZ6nMjKIPx3dYdHNezFMRqA==
X-Google-Smtp-Source: AA0mqf7DcweC56Tp7uRKx2fD3JpxgIrpPJeuNMREHYmNxGtXFgDgDZoFUqhIl0xKeuf8r6R4k/NUig==
X-Received: by 2002:a02:85ac:0:b0:363:6dfb:afb8 with SMTP id d41-20020a0285ac000000b003636dfbafb8mr7875615jai.256.1668510068051;
        Tue, 15 Nov 2022 03:01:08 -0800 (PST)
Received: from labdl-itc-sw04.tmt.telital.com (static-82-85-31-68.clienti.tiscali.it. [82.85.31.68])
        by smtp.googlemail.com with ESMTPSA id x2-20020a92dc42000000b002f956529892sm4956702ilq.2.2022.11.15.03.01.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 03:01:07 -0800 (PST)
From:   Enrico Sau <enrico.sau@gmail.com>
To:     =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, Enrico Sau <enrico.sau@gmail.com>
Subject: [PATCH 1/1] net: usb: qmi_wwan: add Telit 0x103a composition
Date:   Tue, 15 Nov 2022 11:58:59 +0100
Message-Id: <20221115105859.14324-1-enrico.sau@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the following Telit LE910C4-WWX composition:

0x103a: rmnet

Signed-off-by: Enrico Sau <enrico.sau@gmail.com>
---

This is the lsusb verbose output:

$ lsusb -v -d 1bc7:103a

Bus 001 Device 008: ID 1bc7:103a Telit Wireless Solutions LE910C4-WWX
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  idVendor           0x1bc7 Telit Wireless Solutions
  idProduct          0x103a 
  bcdDevice            0.00
  iManufacturer           3 Telit
  iProduct                2 LE910C4-WWX
  iSerial                 4 e1b117c7
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength       0x0027
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          1 Telit Configuration
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower              500mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           3
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface              0 
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
Device Qualifier (for other device speed):
  bLength                10
  bDescriptorType         6
  bcdUSB               2.00
  bDeviceClass            0 
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  bNumConfigurations      1
can't get debug descriptor: Resource temporarily unavailable
Device Status:     0x0000
  (Bus Powered)

---
 drivers/net/usb/qmi_wwan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 30d733c81ed8..c36caf9d6553 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1358,6 +1358,7 @@ static const struct usb_device_id products[] = {
 	{QMI_FIXED_INTF(0x2357, 0x0201, 4)},	/* TP-LINK HSUPA Modem MA180 */
 	{QMI_FIXED_INTF(0x2357, 0x9000, 4)},	/* TP-LINK MA260 */
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1031, 3)}, /* Telit LE910C1-EUX */
+	{QMI_QUIRK_SET_DTR(0x1bc7, 0x103a, 0)}, /* Telit LE910C4-WWX */
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1040, 2)},	/* Telit LE922A */
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1050, 2)},	/* Telit FN980 */
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1057, 2)},	/* Telit FN980 */
-- 
2.25.1

