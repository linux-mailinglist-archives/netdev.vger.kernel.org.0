Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17532215419
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 10:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728412AbgGFIkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 04:40:21 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:19301 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726001AbgGFIkV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 04:40:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1594024821; x=1625560821;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AKPFFEQgCy0hH+JLtqP39hy+yM3QSIvE4fTrTirw4/M=;
  b=nku2HZjo6bvx2JkxkCN8xYfmqOjTx28yTfGGk4koDMqqkjShbTeKiMEo
   qjrgok4o1antYRSFE0AIJRqLIfhm4BbfR4M1wNoZ6M+J2aAQ6HTQkaWQT
   3hYKNg+L8NYxAhUr0c53n/uz5wllVHsQKDirQp9FmvtR1CmAFye722G0v
   mCtq8ARSie+cLdsf4Y63wiEDgnd2DCyDS93ms5sJuFGBZ1Iraj+KcGWgE
   TuRktsrY4s/8Ye/hN8TqJkIRLBTu3iTlD+odDgNmvrRQfblGHtiYsgzq4
   dVTV8el2nRPCEyUYCpjy7WQFF+u4p9nS3gZr+rL25UpKd6YPF65R7J0KD
   Q==;
IronPort-SDR: BSlPwaXba+DcVolzECQbv2SWvO/kZTHs00XCMTUo9YbPDyFCnIoJmdejmzw3un2sTnlwesXdTz
 JGZMCOkgCugtt3aN9WlXMdUXn9RKM/YnOnh8lFQyqS61DRIJCrdODrFLSaStAg5bo6xagqQgFz
 znWrAxsGGGVi4SNg258i7DaTdRJhzFSUoR43JbKYn4oz78/V//NOalU67MevycxXprI/00gUbn
 3ak2DFHbUu2cHNZtgV36vofiCzLTbpFiQZb701v24uEGRX695GcdwnFLajiMaWgNP+rGqRJNr0
 ekw=
X-IronPort-AV: E=Sophos;i="5.75,318,1589266800"; 
   d="scan'208";a="80780532"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Jul 2020 01:40:20 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 6 Jul 2020 01:39:55 -0700
Received: from xasv.mchp-main.com (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Mon, 6 Jul 2020 01:39:55 -0700
From:   Andre Edich <andre.edich@microchip.com>
To:     <netdev@vger.kernel.org>, <UNGLinuxDriver@microchip.com>,
        <steve.glendinning@shawell.net>
CC:     <Parthiban.Veerasooran@microchip.com>,
        Andre Edich <andre.edich@microchip.com>
Subject: [PATCH net v2 1/2] smsc95xx: check return value of smsc95xx_reset
Date:   Mon, 6 Jul 2020 10:39:34 +0200
Message-ID: <20200706083935.19040-2-andre.edich@microchip.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200706083935.19040-1-andre.edich@microchip.com>
References: <20200706083935.19040-1-andre.edich@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The return value of the function smsc95xx_reset() must be checked
to avoid returning false success from the function smsc95xx_bind().

Fixes: 2f7ca802bdae2 ("net: Add SMSC LAN9500 USB2.0 10/100 ethernet adapter driver")
Signed-off-by: Andre Edich <andre.edich@microchip.com>
Signed-off-by: Parthiban Veerasooran <Parthiban.Veerasooran@microchip.com>
---
 drivers/net/usb/smsc95xx.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index 3cf4dc3433f9..eb404bb74e18 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -1287,6 +1287,8 @@ static int smsc95xx_bind(struct usbnet *dev, struct usb_interface *intf)
 
 	/* Init all registers */
 	ret = smsc95xx_reset(dev);
+	if (ret)
+		goto free_pdata;
 
 	/* detect device revision as different features may be available */
 	ret = smsc95xx_read_reg(dev, ID_REV, &val);
@@ -1317,6 +1319,10 @@ static int smsc95xx_bind(struct usbnet *dev, struct usb_interface *intf)
 	schedule_delayed_work(&pdata->carrier_check, CARRIER_CHECK_DELAY);
 
 	return 0;
+
+free_pdata:
+	kfree(pdata);
+	return ret;
 }
 
 static void smsc95xx_unbind(struct usbnet *dev, struct usb_interface *intf)
-- 
2.27.0

