Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5305125B4E0
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 21:57:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726937AbgIBT5h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 15:57:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726310AbgIBT51 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 15:57:27 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B9D8C061246
        for <netdev@vger.kernel.org>; Wed,  2 Sep 2020 12:57:27 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id h12so203604pgm.7
        for <netdev@vger.kernel.org>; Wed, 02 Sep 2020 12:57:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=k9AC4enbGJ3b0sC2EZqKVeI5FTGnaMi6W6rz9Eujrvs=;
        b=RerXIMKX5hPHEgI7BGMe08AbCRIQx0/jU6kcmFEqQpzIpgahROpPKXKVP87W2nYx3U
         4DwE9623/k9dK3lL783oV5Y876X913Bycv0oXYeFQM9gpUykSFGaU31dymv0BGJhGNNP
         ePTyZ9TDCirCGiWCzuCaQyCdPniUuz4ZgXN4gngFGuecCq5bn/HmBVyQ0yRHaqKU9UEz
         dKMnE12NwHiHXO5bPj9IK2AcPCPpW8/v+wT9qbGD+fx8YJaUstLsLM4bCo/2RHxzfZ30
         4mo1SNNQ1Msxky6GN3Uhqcyli/89zTUnaTh+FqdHtztzBoVRZ3Icas5x0Vbqh6J5ipVG
         JL4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=k9AC4enbGJ3b0sC2EZqKVeI5FTGnaMi6W6rz9Eujrvs=;
        b=YW+r1zBc3or3bTvCwNBS7VmzxDa4ytvyaGpTc4aRwfe738eJSrulZTtcEBAmnPM2pa
         numS9CV2RcFWD0Gy9jJzmIL38M/NPGIo8wWPElH8oM3p6MDHk6YOORz0JIm74nUdM+bL
         /xVZQDMQy/zFCANQ3rjN1MbOLSz61goNm560w8/80Msqb7LiBhgOBdP9LIhtlaci2Ppd
         Ye5Z9x5Ujszlt1MZsjOCur+scG5UDf8vYpRvXv4Lm1wmAFamINRQsMvdFOfpYJs3ISlp
         KaMDJsd8dtJgi8UzTGXZt0OF6/1owhbCzd2FDV+IczWVAiHLj915VRoQLT5mtWE1G3+l
         Trsg==
X-Gm-Message-State: AOAM530595a5iMB1AQ8RW65mBDj9CcIxSm9URFriHl2eaoK8lNgdYSoZ
        9fHkrDBj/kMbha2Uk7uIsc69L7dHWPnrlw==
X-Google-Smtp-Source: ABdhPJwA6y9HLnmO2+Z2RglHj4TFzdmnHEyWRxtPrJXSEH7CNhLIxTM90EbL+IAGko3ZlR9QseZ6Cw==
X-Received: by 2002:a63:e015:: with SMTP id e21mr3254174pgh.264.1599076646233;
        Wed, 02 Sep 2020 12:57:26 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id a5sm355527pfb.26.2020.09.02.12.57.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 02 Sep 2020 12:57:25 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 1/2] ionic: update the fw update api
Date:   Wed,  2 Sep 2020 12:57:16 -0700
Message-Id: <20200902195717.56830-2-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200902195717.56830-1-snelson@pensando.io>
References: <20200902195717.56830-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the rest of the firmware api bits needed to support the
driver running a firmware update.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_if.h    | 33 ++++++++++++++-----
 .../net/ethernet/pensando/ionic/ionic_main.c  |  4 +++
 2 files changed, 29 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_if.h b/drivers/net/ethernet/pensando/ionic/ionic_if.h
index acc94b244cf3..5bb56a27a50d 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_if.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_if.h
@@ -63,8 +63,10 @@ enum ionic_cmd_opcode {
 	IONIC_CMD_QOS_RESET			= 245,
 
 	/* Firmware commands */
-	IONIC_CMD_FW_DOWNLOAD			= 254,
-	IONIC_CMD_FW_CONTROL			= 255,
+	IONIC_CMD_FW_DOWNLOAD                   = 252,
+	IONIC_CMD_FW_CONTROL                    = 253,
+	IONIC_CMD_FW_DOWNLOAD_V1		= 254,
+	IONIC_CMD_FW_CONTROL_V1		        = 255,
 };
 
 /**
@@ -2069,14 +2071,23 @@ typedef struct ionic_admin_comp ionic_fw_download_comp;
 
 /**
  * enum ionic_fw_control_oper - FW control operations
- * @IONIC_FW_RESET:     Reset firmware
- * @IONIC_FW_INSTALL:   Install firmware
- * @IONIC_FW_ACTIVATE:  Activate firmware
+ * @IONIC_FW_RESET:		Reset firmware
+ * @IONIC_FW_INSTALL:		Install firmware
+ * @IONIC_FW_ACTIVATE:		Activate firmware
+ * @IONIC_FW_INSTALL_ASYNC:	Install firmware asynchronously
+ * @IONIC_FW_INSTALL_STATUS:	Firmware installation status
+ * @IONIC_FW_ACTIVATE_ASYNC:	Activate firmware asynchronously
+ * @IONIC_FW_ACTIVATE_STATUS:	Firmware activate status
  */
 enum ionic_fw_control_oper {
-	IONIC_FW_RESET		= 0,
-	IONIC_FW_INSTALL	= 1,
-	IONIC_FW_ACTIVATE	= 2,
+	IONIC_FW_RESET			= 0,
+	IONIC_FW_INSTALL		= 1,
+	IONIC_FW_ACTIVATE		= 2,
+	IONIC_FW_INSTALL_ASYNC		= 3,
+	IONIC_FW_INSTALL_STATUS		= 4,
+	IONIC_FW_ACTIVATE_ASYNC		= 5,
+	IONIC_FW_ACTIVATE_STATUS	= 6,
+	IONIC_FW_UPDATE_CLEANUP		= 7,
 };
 
 /**
@@ -2689,6 +2700,9 @@ union ionic_dev_cmd {
 	struct ionic_q_identify_cmd q_identify;
 	struct ionic_q_init_cmd q_init;
 	struct ionic_q_control_cmd q_control;
+
+	struct ionic_fw_download_cmd fw_download;
+	struct ionic_fw_control_cmd fw_control;
 };
 
 union ionic_dev_cmd_comp {
@@ -2722,6 +2736,9 @@ union ionic_dev_cmd_comp {
 
 	struct ionic_q_identify_comp q_identify;
 	struct ionic_q_init_comp q_init;
+
+	ionic_fw_download_comp fw_download;
+	struct ionic_fw_control_comp fw_control;
 };
 
 /**
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index 2b72a51be1d0..f1fd9a98ae4a 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -170,6 +170,10 @@ static const char *ionic_opcode_to_str(enum ionic_cmd_opcode opcode)
 		return "IONIC_CMD_FW_DOWNLOAD";
 	case IONIC_CMD_FW_CONTROL:
 		return "IONIC_CMD_FW_CONTROL";
+	case IONIC_CMD_FW_DOWNLOAD_V1:
+		return "IONIC_CMD_FW_DOWNLOAD_V1";
+	case IONIC_CMD_FW_CONTROL_V1:
+		return "IONIC_CMD_FW_CONTROL_V1";
 	case IONIC_CMD_VF_GETATTR:
 		return "IONIC_CMD_VF_GETATTR";
 	case IONIC_CMD_VF_SETATTR:
-- 
2.17.1

