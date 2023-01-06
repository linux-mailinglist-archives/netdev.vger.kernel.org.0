Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4F4A65FF3B
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 11:59:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231665AbjAFK7L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 05:59:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbjAFK7J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 05:59:09 -0500
Received: from mx1.tq-group.com (mx1.tq-group.com [93.104.207.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D93BC6C28D;
        Fri,  6 Jan 2023 02:59:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1673002748; x=1704538748;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=L3iMh35MDqRytr4MyNasNEh2imYIgz6B3BBSnvsTzpM=;
  b=Y+AXBE7SSroEMcAnCZTYmYTz2BTz9I/cqlV804i6kCLnQJHo3U/6wmBO
   g2jYIX5tQ+koldgpL4qXnBtQI157oCoRVdis8X9H0MFFuqMnTah/qsf9Y
   7X1s0OLAGKAHf7SJukWT1p+/8ueFd40PUt82FJ83t5YK0rA11fUy5/vSi
   S265Jr5ZX2vib40SDkpFX4fiv/mziD5+gvXcdSh5KUP8tPVL+FZrzfxBJ
   DbMTi/Y0C6Sw/tzGKSaYFu84XZGpXH8KC8zWRpmFo3nvPo2fIl76DzLgf
   TECSZHXwZJ3LPEe0af9ys6ZvcAlRR+9B1asQLwxVwtiiB3PF1AnUyuGpM
   w==;
X-IronPort-AV: E=Sophos;i="5.96,305,1665439200"; 
   d="scan'208";a="28272859"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 06 Jan 2023 11:59:05 +0100
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Fri, 06 Jan 2023 11:59:05 +0100
X-PGP-Universal: processed;
        by tq-pgp-pr1.tq-net.de on Fri, 06 Jan 2023 11:59:05 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1673002745; x=1704538745;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=L3iMh35MDqRytr4MyNasNEh2imYIgz6B3BBSnvsTzpM=;
  b=LcTvFfx+HYtOvKQ1JPaQXBRLXjJ7SocvBzuzwP2arctAVv6u6KxPutH7
   P/0vi/jQpiqu7/Ywfr4jkxhFBmfFvb45AA4R0m0+HCxlrgJQvkI7/Oopr
   Ew+iuo9JJNJvP2qg3bl+v1t7pmftyP+pfCkq2WRr51iR7ObE8UPN7L7GA
   Rjckr4jiOrKY7eC66ZPqYJkwTMH7ZuIhOqGVrUIrw/3pa1nBP/aISiWow
   Cc2yzJ2z2JeP8Sn6c2S/9F9Pyt+FF9F8FB3ykDFh4vf/NrP/dqr8m/SlZ
   UOg3iwPa+1lQ5P+E435fhFidDNqJrG/rDFsUXVsXcSIxeYB/WrMM13fZE
   g==;
X-IronPort-AV: E=Sophos;i="5.96,305,1665439200"; 
   d="scan'208";a="28272858"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 06 Jan 2023 11:59:05 +0100
Received: from steina-w.tq-net.de (unknown [10.123.53.21])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by vtuxmail01.tq-net.de (Postfix) with ESMTPSA id 39159280056;
        Fri,  6 Jan 2023 11:59:05 +0100 (CET)
From:   Alexander Stein <alexander.stein@ew.tq-group.com>
To:     Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Alexander Stein <alexander.stein@ew.tq-group.com>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [RFC PATCH 0/2] ath10k USB support (QCA9377)
Date:   Fri,  6 Jan 2023 11:58:51 +0100
Message-Id: <20230106105853.3484381-1-alexander.stein@ew.tq-group.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello everyone,

apparently there have been several tries for adding ath10k USB support, see
[1] & [2]. There are probably even more.
This series is a first step for supporting my actual device,
a Silex SX-USBAC. This is a Bluetooth & WiFi combo device.

I picked commit 131da4f5a5b9 ("HACK: ath10k: add start_once support") from
[2] and extracted the ath10k_hw_params_list entry from [3].
Since v5.9, the base of [3], other required changes have already been
integrated.
For now I tested a very simple STA mode usage profile, using
wpa_supplicant on a WPA interface. AP is untested, module unloading not
supported, probably affected by the firmware start/stop patch 1 adds a
workaround.

Reading the other, older series, apparently a lot has been merged already,
but I do not know what is still missing fpr proper USB support.
I would like to have a discussion for how to add support so the device is
at least probing and can be used rudimentary.

Best regards,
Alexander

[1] https://lore.kernel.org/all/1484343309-6327-1-git-send-email-erik.stromdahl@gmail.com/
[2] https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/log/?h=ath10k-pending-sdio-usb
[3] https://customergts.silexamerica.com/gpl/backports-ath10k-5.9.12-1

For completness, here are USB IDs and 'lsusb -vvv' output

Bus 001 Device 005: ID 0cf3: Ap9378 Qualcomm Atheros Communications QCA9377-7
Bus 001 Device 004: ID 0cf3:e500 Qualcomm Atheros Communications

$ lsusb -vvv -s 1:5

Bus 001 Device 005: ID 0cf3:9378 Qualcomm Atheros Communications QCA9377-7
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.01
  bDeviceClass          255 Vendor Specific Class
  bDeviceSubClass       255 Vendor Specific Subclass
  bDeviceProtocol       255 Vendor Specific Protocol
  bMaxPacketSize0        64
  idVendor           0x0cf3 Qualcomm Atheros Communications
  idProduct          0x9378 QCA9377-7
  bcdDevice            3.00
  iManufacturer           1 Qualcomm Atheros
  iProduct                2 USBWLAN
  iSerial                 3 12345678
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength       0x006f
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xa0
      (Bus Powered)
      Remote Wakeup
    MaxPower              500mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           8
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface              2 USBWLAN
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
        bEndpointAddress     0x01  EP 1 OUT
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
      bInterfaceNumber        0
      bAlternateSetting       1
      bNumEndpoints           4
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface              2 USBWLAN
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
        bEndpointAddress     0x04  EP 4 OUT
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
Binary Object Store Descriptor:
  bLength                 5
  bDescriptorType        15
  wTotalLength       0x0016
  bNumDeviceCaps          2
  USB 2.0 Extension Device Capability:
    bLength                 7
    bDescriptorType        16
    bDevCapabilityType      2
    bmAttributes   0x0000f11e
      BESL Link Power Management (LPM) Supported
    BESL value      256 us 
    Deep BESL value    61440 us 
  SuperSpeed USB Device Capability:
    bLength                10
    bDescriptorType        16
    bDevCapabilityType      3
    bmAttributes         0x00
    wSpeedsSupported   0x000e
      Device can operate at Full Speed (12Mbps)
      Device can operate at High Speed (480Mbps)
      Device can operate at SuperSpeed (5Gbps)
    bFunctionalitySupport   2
      Lowest fully-functional device speed is High Speed (480Mbps)
    bU1DevExitLat          10 micro seconds
    bU2DevExitLat         256 micro seconds
can't get debug descriptor: Resource temporarily unavailable
Device Status:     0x0000
  (Bus Powered)

Alexander Stein (1):
  ath10k: Add support for QCA9377 hw1.1 usb

Erik Stromdahl (1):
  HACK: ath10k: add start_once support

 drivers/net/wireless/ath/ath10k/core.c | 48 +++++++++++++++++++++++---
 drivers/net/wireless/ath/ath10k/core.h |  2 ++
 drivers/net/wireless/ath/ath10k/hw.h   | 14 ++++++++
 drivers/net/wireless/ath/ath10k/mac.c  |  7 ++--
 drivers/net/wireless/ath/ath10k/usb.c  |  1 +
 5 files changed, 66 insertions(+), 6 deletions(-)

-- 
2.34.1

