Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6D078E69
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 16:52:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728647AbfG2OwT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 10:52:19 -0400
Received: from mga03.intel.com ([134.134.136.65]:55128 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727000AbfG2OwT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 10:52:19 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Jul 2019 06:35:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,322,1559545200"; 
   d="scan'208";a="190571914"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga001.fm.intel.com with ESMTP; 29 Jul 2019 06:35:15 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id DC25A552; Mon, 29 Jul 2019 16:35:14 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     =?UTF-8?q?Cl=C3=A9ment=20Perrochaud?= 
        <clement.perrochaud@effinnov.com>,
        Charles Gorand <charles.gorand@effinnov.com>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Sedat Dilek <sedat.dilek@credativ.de>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sedat Dilek <sedat.dilek@gmail.com>
Subject: [PATCH v4 03/14] NFC: nxp-nci: Get rid of platform data
Date:   Mon, 29 Jul 2019 16:35:03 +0300
Message-Id: <20190729133514.13164-4-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190729133514.13164-1-andriy.shevchenko@linux.intel.com>
References: <20190729133514.13164-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Legacy platform data must go away. We are on the safe side here since
there are no users of it in the kernel.

If anyone by any odd reason needs it the GPIO lookup tables and
built-in device properties at your service.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
---
 MAINTAINERS                           |  1 -
 drivers/nfc/nxp-nci/core.c            |  1 -
 drivers/nfc/nxp-nci/i2c.c             |  9 +--------
 drivers/nfc/nxp-nci/nxp-nci.h         |  1 -
 include/linux/platform_data/nxp-nci.h | 19 -------------------
 5 files changed, 1 insertion(+), 30 deletions(-)
 delete mode 100644 include/linux/platform_data/nxp-nci.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 99f64e395623..f204f7a65428 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11353,7 +11353,6 @@ F:	include/net/nfc/
 F:	include/uapi/linux/nfc.h
 F:	drivers/nfc/
 F:	include/linux/platform_data/nfcmrvl.h
-F:	include/linux/platform_data/nxp-nci.h
 F:	Documentation/devicetree/bindings/net/nfc/
 
 NFS, SUNRPC, AND LOCKD CLIENTS
diff --git a/drivers/nfc/nxp-nci/core.c b/drivers/nfc/nxp-nci/core.c
index 8dafc696719f..aed18ca60170 100644
--- a/drivers/nfc/nxp-nci/core.c
+++ b/drivers/nfc/nxp-nci/core.c
@@ -14,7 +14,6 @@
 #include <linux/gpio.h>
 #include <linux/module.h>
 #include <linux/nfc.h>
-#include <linux/platform_data/nxp-nci.h>
 
 #include <net/nfc/nci_core.h>
 
diff --git a/drivers/nfc/nxp-nci/i2c.c b/drivers/nfc/nxp-nci/i2c.c
index 5db71869f04b..47b3b7e612e6 100644
--- a/drivers/nfc/nxp-nci/i2c.c
+++ b/drivers/nfc/nxp-nci/i2c.c
@@ -23,7 +23,6 @@
 #include <linux/gpio/consumer.h>
 #include <linux/of_gpio.h>
 #include <linux/of_irq.h>
-#include <linux/platform_data/nxp-nci.h>
 #include <asm/unaligned.h>
 
 #include <net/nfc/nfc.h>
@@ -304,7 +303,6 @@ static int nxp_nci_i2c_probe(struct i2c_client *client,
 			    const struct i2c_device_id *id)
 {
 	struct nxp_nci_i2c_phy *phy;
-	struct nxp_nci_nfc_platform_data *pdata;
 	int r;
 
 	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
@@ -323,17 +321,12 @@ static int nxp_nci_i2c_probe(struct i2c_client *client,
 	phy->i2c_dev = client;
 	i2c_set_clientdata(client, phy);
 
-	pdata = client->dev.platform_data;
-
-	if (!pdata && client->dev.of_node) {
+	if (client->dev.of_node) {
 		r = nxp_nci_i2c_parse_devtree(client);
 		if (r < 0) {
 			nfc_err(&client->dev, "Failed to get DT data\n");
 			goto probe_exit;
 		}
-	} else if (pdata) {
-		phy->gpio_en = pdata->gpio_en;
-		phy->gpio_fw = pdata->gpio_fw;
 	} else if (ACPI_HANDLE(&client->dev)) {
 		r = nxp_nci_i2c_acpi_config(phy);
 		if (r < 0)
diff --git a/drivers/nfc/nxp-nci/nxp-nci.h b/drivers/nfc/nxp-nci/nxp-nci.h
index 6fe7c45544bf..ae3fb2735a4e 100644
--- a/drivers/nfc/nxp-nci/nxp-nci.h
+++ b/drivers/nfc/nxp-nci/nxp-nci.h
@@ -14,7 +14,6 @@
 #include <linux/completion.h>
 #include <linux/firmware.h>
 #include <linux/nfc.h>
-#include <linux/platform_data/nxp-nci.h>
 
 #include <net/nfc/nci_core.h>
 
diff --git a/include/linux/platform_data/nxp-nci.h b/include/linux/platform_data/nxp-nci.h
deleted file mode 100644
index 97827ad468e2..000000000000
--- a/include/linux/platform_data/nxp-nci.h
+++ /dev/null
@@ -1,19 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-/*
- * Generic platform data for the NXP NCI NFC chips.
- *
- * Copyright (C) 2014  NXP Semiconductors  All rights reserved.
- *
- * Authors: Clément Perrochaud <clement.perrochaud@nxp.com>
- */
-
-#ifndef _NXP_NCI_H_
-#define _NXP_NCI_H_
-
-struct nxp_nci_nfc_platform_data {
-	unsigned int gpio_en;
-	unsigned int gpio_fw;
-	unsigned int irq;
-};
-
-#endif /* _NXP_NCI_H_ */
-- 
2.20.1

