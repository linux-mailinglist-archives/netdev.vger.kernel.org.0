Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 457F66BA07C
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 21:13:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231142AbjCNUN1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 16:13:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230395AbjCNUNW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 16:13:22 -0400
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0BC71969E;
        Tue, 14 Mar 2023 13:13:14 -0700 (PDT)
Received: by mail-il1-f179.google.com with SMTP id j6so4793095ilr.7;
        Tue, 14 Mar 2023 13:13:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678824794;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CJlM3chLn2hYsljtdG2Gsvt+783JHIg7bd5IO9aY9nI=;
        b=2gwgZdKQFNu5DSKff+6jfaXg8i+D6yAnCSA1A9jKLoWb5Y9wO2fNkCdR+90FfhZkAu
         s74pIC/aVjtGGeoL3Pd0r2M/UimlB/nyG8HIg0AAM9tQ1n4iQSRznfj5GuEJLoRNi7XF
         riaI31Scxt+Je7OYeWGEi2BwetTNuj6Al35V3VOn7wRCBCYqjr/eLtoQ/fQSdPrMbuk7
         wPbM05IhhfaUOvBRJlviCcgZZhOhsWI7NeHYJyeJS0Pxa7Ft8mTxgSrjDxRVRFop7u0d
         OYLCXjJ82v2pSalJbChOySpX1a36bJwdy/MuDzftdOK6JUWaZNrSeb3wC9aqEqbzaYck
         ShMQ==
X-Gm-Message-State: AO0yUKUiNDRkltLMLxsq4pN0WJAGxh5wfAqqjke5Mwnobn4zh6SryG3o
        4r1sL+ucDPJfLzNV5QLnhY2VGPtaaw==
X-Google-Smtp-Source: AK7set9K4OXj5mFkbJbzAE5PFyZYK2s4RSbidcBMbfRzBKgYZAYAC+nEZtrczmuTAg708d10IQiiRw==
X-Received: by 2002:a92:7302:0:b0:315:6fc5:ea46 with SMTP id o2-20020a927302000000b003156fc5ea46mr2893332ilc.2.1678824793715;
        Tue, 14 Mar 2023 13:13:13 -0700 (PDT)
Received: from robh_at_kernel.org ([64.188.179.249])
        by smtp.gmail.com with ESMTPSA id e20-20020a056638021400b0040611a31d5fsm361854jaq.80.2023.03.14.13.13.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 13:13:13 -0700 (PDT)
Received: (nullmailer pid 995516 invoked by uid 1000);
        Tue, 14 Mar 2023 20:13:12 -0000
From:   Rob Herring <robh@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v2 1/2] nfc: mrvl: Move platform_data struct into driver
Date:   Tue, 14 Mar 2023 15:13:08 -0500
Message-Id: <20230314201309.995421-1-robh@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are no users of nfcmrvl platform_data struct outside of the
driver and none will be added, so move it into the driver.

Signed-off-by: Rob Herring <robh@kernel.org>
---
 drivers/nfc/nfcmrvl/nfcmrvl.h         | 30 +++++++++++++++--
 include/linux/platform_data/nfcmrvl.h | 48 ---------------------------
 2 files changed, 28 insertions(+), 50 deletions(-)
 delete mode 100644 include/linux/platform_data/nfcmrvl.h

diff --git a/drivers/nfc/nfcmrvl/nfcmrvl.h b/drivers/nfc/nfcmrvl/nfcmrvl.h
index 165bd0a95190..0f22b3233f73 100644
--- a/drivers/nfc/nfcmrvl/nfcmrvl.h
+++ b/drivers/nfc/nfcmrvl/nfcmrvl.h
@@ -8,8 +8,6 @@
 #ifndef _NFCMRVL_H_
 #define _NFCMRVL_H_
 
-#include <linux/platform_data/nfcmrvl.h>
-
 #include "fw_dnld.h"
 
 /* Define private flags: */
@@ -50,6 +48,34 @@ enum nfcmrvl_phy {
 	NFCMRVL_PHY_SPI		= 3,
 };
 
+struct nfcmrvl_platform_data {
+	/*
+	 * Generic
+	 */
+
+	/* GPIO that is wired to RESET_N signal */
+	int reset_n_io;
+	/* Tell if transport is muxed in HCI one */
+	unsigned int hci_muxed;
+
+	/*
+	 * UART specific
+	 */
+
+	/* Tell if UART needs flow control at init */
+	unsigned int flow_control;
+	/* Tell if firmware supports break control for power management */
+	unsigned int break_control;
+
+
+	/*
+	 * I2C specific
+	 */
+
+	unsigned int irq;
+	unsigned int irq_polarity;
+};
+
 struct nfcmrvl_private {
 
 	unsigned long flags;
diff --git a/include/linux/platform_data/nfcmrvl.h b/include/linux/platform_data/nfcmrvl.h
deleted file mode 100644
index 9e75ac8d19be..000000000000
--- a/include/linux/platform_data/nfcmrvl.h
+++ /dev/null
@@ -1,48 +0,0 @@
-/*
- * Copyright (C) 2015, Marvell International Ltd.
- *
- * This software file (the "File") is distributed by Marvell International
- * Ltd. under the terms of the GNU General Public License Version 2, June 1991
- * (the "License").  You may use, redistribute and/or modify this File in
- * accordance with the terms and conditions of the License, a copy of which
- * is available on the worldwide web at
- * http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
- *
- * THE FILE IS DISTRIBUTED AS-IS, WITHOUT WARRANTY OF ANY KIND, AND THE
- * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
- * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
- * this warranty disclaimer.
- */
-
-#ifndef _NFCMRVL_PTF_H_
-#define _NFCMRVL_PTF_H_
-
-struct nfcmrvl_platform_data {
-	/*
-	 * Generic
-	 */
-
-	/* GPIO that is wired to RESET_N signal */
-	int reset_n_io;
-	/* Tell if transport is muxed in HCI one */
-	unsigned int hci_muxed;
-
-	/*
-	 * UART specific
-	 */
-
-	/* Tell if UART needs flow control at init */
-	unsigned int flow_control;
-	/* Tell if firmware supports break control for power management */
-	unsigned int break_control;
-
-
-	/*
-	 * I2C specific
-	 */
-
-	unsigned int irq;
-	unsigned int irq_polarity;
-};
-
-#endif /* _NFCMRVL_PTF_H_ */
-- 
2.39.2

