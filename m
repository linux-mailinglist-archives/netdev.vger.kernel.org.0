Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E107126D170
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 05:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726093AbgIQDIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 23:08:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726009AbgIQDIE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 23:08:04 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3E4EC06121D
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 20:02:18 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id m15so340572pls.8
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 20:02:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=d5lh7dSTzYL1z77vtX8o0KhR/tEcPbvx+ghe0OFpwQg=;
        b=wsTifUWu0NhwLe+lG9x2ehjsCZyuf8lLDqq8vfkeMN60reKzcSGlXKw2kxapndmT8U
         s5eiWE4Q0GfPETJ1mkIOrofSoLxTk1PmRuyu/lUMGfvTQel4VsmpkmOe8S5XjUSNeB6r
         uaJ76nkKrSluPtYaW0YBfXRJWCyIS+NaALoL6A4heq4V1yGSKKjwN0GVqyY0hY8CGwm/
         UuqwmGwnPFGwt2qHV8nImJalUKoerPNh1I/UaFFZiSYKiKB5uBT591LIu/Q/Tsti7drr
         JoJNk4d9YNshT8cEXhBJbsrXuahaibEHByG5bvZ0EojEzQGAQF+vkzU2Ki/2AZ/my74c
         pXkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=d5lh7dSTzYL1z77vtX8o0KhR/tEcPbvx+ghe0OFpwQg=;
        b=CbTWS6rnQL5UpGNeupehsxkZdgMyYByBXWp2U1XxVfOzBEZrw+6EiwT6tJLlii7bWT
         kyIRkVtzFYVNfUQpQzaNAiwd1DY1P02P/SLHvRg0rSJHJvUwASd8wrg/rGYGluWoUx8W
         Ql96+o4vsaG+Kag2scaw3YNys16CEUGGq/qY1XbaEVIwDiwuWlNlnnFxFNoc3PBrNHxT
         jrENMcXkoSYcYfDVxXwvupitX6NqCbbg10JqHeMoWu/NwPzIw2/AnirAIdANk+TCr2Fd
         aP583WSHP0NwYPYFQHT2bJMAyBviCQPVU8JzVyRLs8wWsefXiiA7gZYATBNZ97wyZygR
         vBxg==
X-Gm-Message-State: AOAM533NEas1eJ2eGoaNP30evW8iTjNsnmtxcRfsateaBfxwt2i2LoTg
        YL94EYR4e50v6wMNVhs5ghmMgnje/tHDWQ==
X-Google-Smtp-Source: ABdhPJwh3MtBCIEPyKg9g/9L5osMGFnR0YSL/Cp0E9jidMgQNI4Y8ihdVs1Dgmdu+rQ4IJzfkMANtg==
X-Received: by 2002:a17:902:8545:b029:d1:f2e3:8dd4 with SMTP id d5-20020a1709028545b02900d1f2e38dd4mr4421493plo.65.1600311737947;
        Wed, 16 Sep 2020 20:02:17 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id b2sm12072498pfp.3.2020.09.16.20.02.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Sep 2020 20:02:17 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v4 net-next 4/5] ionic: update the fw update api
Date:   Wed, 16 Sep 2020 20:02:03 -0700
Message-Id: <20200917030204.50098-5-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200917030204.50098-1-snelson@pensando.io>
References: <20200917030204.50098-1-snelson@pensando.io>
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
index cfb90bf605fe..99e9dd15a303 100644
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

