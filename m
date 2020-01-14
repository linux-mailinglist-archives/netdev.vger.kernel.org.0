Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E632913A04C
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 05:41:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728708AbgANElp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 23:41:45 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59816 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbgANElp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 23:41:45 -0500
Received: from 61-220-137-37.hinet-ip.hinet.net ([61.220.137.37] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1irE1I-0003Ey-69; Tue, 14 Jan 2020 04:41:37 +0000
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     davem@davemloft.net, hayeswang@realtek.com
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Prashant Malani <pmalani@chromium.org>,
        Grant Grundler <grundler@chromium.org>,
        Mario Limonciello <mario.limonciello@dell.com>,
        David Chen <david.chen7@dell.com>,
        linux-usb@vger.kernel.org (open list:USB NETWORKING DRIVERS),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] r8152: Add MAC passthrough support to new device
Date:   Tue, 14 Jan 2020 12:41:25 +0800
Message-Id: <20200114044127.20085-1-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Device 0xa387 also supports MAC passthrough, therefore add it to the
whitelst.

BugLink: https://bugs.launchpad.net/bugs/1827961/comments/30
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
 drivers/net/usb/r8152.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index c5ebf35d2488..42dcf1442cc0 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -6657,7 +6657,8 @@ static int rtl8152_probe(struct usb_interface *intf,
 	}
 
 	if (le16_to_cpu(udev->descriptor.idVendor) == VENDOR_ID_LENOVO &&
-	    le16_to_cpu(udev->descriptor.idProduct) == 0x3082)
+	    (le16_to_cpu(udev->descriptor.idProduct) == 0x3082 ||
+	     le16_to_cpu(udev->descriptor.idProduct) == 0xa387))
 		set_bit(LENOVO_MACPASSTHRU, &tp->flags);
 
 	if (le16_to_cpu(udev->descriptor.bcdDevice) == 0x3011 && udev->serial &&
-- 
2.17.1

