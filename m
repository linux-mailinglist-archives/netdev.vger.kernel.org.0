Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 999DD535B78
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 10:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348357AbiE0I3X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 04:29:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234417AbiE0I3T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 04:29:19 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02D75ED8E9;
        Fri, 27 May 2022 01:29:18 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id h11so4537375eda.8;
        Fri, 27 May 2022 01:29:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YQR6JpGqUX0AIkDsDZjw9cLLiQfMbokV9puQAP8OYek=;
        b=IlDb4StC3rI4UMeMeMtzFNRpe9yH5h3CF0GqeeFvZgFpV9lTTpMTWFEKmS3SIo4y7s
         uXNbzxovv+d1tS+olhJCc4jv90RwWhjOpPFe7otjzLpx+maTF1i6yA8JPIXwBddmpp6v
         bCf32qsXjQJDxLxBgRmBx6nFASIuZEKIhy/+qaFk35uWpYTkVJ1kAbcz1NB8U0F75Th+
         H242M+SE7tmgtoYYptz7B0PDv4F2o8blYP3+D+FdKiBUeWHbXm4IY7tNYsdxrRRktpA4
         r5tIdUdcdsXCe5ggQV23mpUW+vEVPVHCqbTY0EgWxiXH++Ak59dTSXQ/hAfMLhOxtbGA
         VYDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YQR6JpGqUX0AIkDsDZjw9cLLiQfMbokV9puQAP8OYek=;
        b=tr0yzIXmyRLyDmS8S+X3jzBYiSwW49U3TWQA9xaPclfhROMdeHTCU9maFSGzwSmtqU
         d2uHtV11IDYduUdrkr3O9LjIDIaayAk/WOxG7abOvx+4Aj3LyGzBdMelLN505SIsJD80
         d38bjZIS9BH1fCXmykqtxz8sP82yzPy5AAsVtbG4IGr6o6HjburPDsf4RFwIzmWt3VzV
         7NOdpr8ISTIqvZ8lE/PDDYRIaCIxggsSGp2NWL2U1k7oeGpeqTZC+ow2QHxekYWeUnYa
         12MHmU1e9Rx89/SS4Z1yPT31DoDm8vhXiJaYMjpZGeb8X7q2OMaVmRJmf2tg05gEYA2E
         sryQ==
X-Gm-Message-State: AOAM530hPF34tB6//TvzgRUm7ZxL8UnV2xWSAQ9F+cGnpXV8IVGmKaav
        VJyAhu48iw6tzoaR/QctXNc=
X-Google-Smtp-Source: ABdhPJywcb9GOlMFBOeT2hDzkNALCzCoPmckQvXUD/U2ATY+BCRBhJMIkkMwQxfICcLs/58Y9ydA8g==
X-Received: by 2002:aa7:c952:0:b0:42a:f08f:4d4c with SMTP id h18-20020aa7c952000000b0042af08f4d4cmr43719477edt.26.1653640156395;
        Fri, 27 May 2022 01:29:16 -0700 (PDT)
Received: from lenny.home-life.hub ([91.254.5.81])
        by smtp.gmail.com with ESMTPSA id v9-20020a1709062f0900b006febce7081bsm1207934eji.163.2022.05.27.01.29.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 May 2022 01:29:15 -0700 (PDT)
From:   Carlo Lobrano <c.lobrano@gmail.com>
To:     =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Carlo Lobrano <c.lobrano@gmail.com>
Subject: [PATCH] net: usb: qmi_wwan: add Telit 0x1250 composition
Date:   Fri, 27 May 2022 10:29:06 +0200
Message-Id: <20220527082906.321165-1-c.lobrano@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for Telit LN910Cx 0x1250 composition

0x1250: rmnet, tty, tty, tty, tty

Signed-off-by: Carlo Lobrano <c.lobrano@gmail.com>
---

Hello,

here is the lsusb output, thanks.

Bus 001 Device 002: ID 1bc7:1250 Telit Wireless Solutions LE910C1-EU
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  idVendor           0x1bc7 Telit Wireless Solutions
  idProduct          0x1250 
  bcdDevice            3.18
  iManufacturer           1 Android
  iProduct                2 LE910C1-EU
  iSerial                 3 0123456789ABCDEF
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength       0x00eb
    bNumInterfaces          5
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0x80
      (Bus Powered)
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
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0008  1x 8 bytes
        bInterval               9
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
      bInterfaceSubClass      0 
      bInterfaceProtocol      0 
      iInterface              0 
      ** UNRECOGNIZED:  05 24 00 10 01
      ** UNRECOGNIZED:  05 24 01 00 00
      ** UNRECOGNIZED:  04 24 02 02
      ** UNRECOGNIZED:  05 24 06 00 00
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x84  EP 4 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x000a  1x 10 bytes
        bInterval               9
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
      bInterfaceSubClass      0 
      bInterfaceProtocol      0 
      iInterface              0 
      ** UNRECOGNIZED:  05 24 00 10 01
      ** UNRECOGNIZED:  05 24 01 00 00
      ** UNRECOGNIZED:  04 24 02 02
      ** UNRECOGNIZED:  05 24 06 00 00
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x86  EP 6 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x000a  1x 10 bytes
        bInterval               9
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
      bInterfaceSubClass      0 
      bInterfaceProtocol      0 
      iInterface              0 
      ** UNRECOGNIZED:  05 24 00 10 01
      ** UNRECOGNIZED:  05 24 01 00 00
      ** UNRECOGNIZED:  04 24 02 02
      ** UNRECOGNIZED:  05 24 06 00 00
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x88  EP 8 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x000a  1x 10 bytes
        bInterval               9
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
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        4
      bAlternateSetting       0
      bNumEndpoints           3
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0 
      bInterfaceProtocol      0 
      iInterface              0 
      ** UNRECOGNIZED:  05 24 00 10 01
      ** UNRECOGNIZED:  05 24 01 00 00
      ** UNRECOGNIZED:  04 24 02 02
      ** UNRECOGNIZED:  05 24 06 00 00
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x8a  EP 10 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x000a  1x 10 bytes
        bInterval               9
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
  bDeviceClass            0 
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  bNumConfigurations      1
Device Status:     0x0000
  (Bus Powered)

---
 drivers/net/usb/qmi_wwan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 79f8bd849..a659d6fb0 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1366,6 +1366,7 @@ static const struct usb_device_id products[] = {
 	{QMI_FIXED_INTF(0x1bc7, 0x1200, 5)},	/* Telit LE920 */
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1201, 2)},	/* Telit LE920, LE920A4 */
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1230, 2)},	/* Telit LE910Cx */
+	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1250, 0)},	/* Telit LE910Cx */
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1260, 2)},	/* Telit LE910Cx */
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1261, 2)},	/* Telit LE910Cx */
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1900, 1)},	/* Telit LN940 series */
-- 
2.32.0

