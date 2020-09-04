Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84E3825CEB0
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 02:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729411AbgIDAFs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 20:05:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728134AbgIDAFo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 20:05:44 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84A8DC061245
        for <netdev@vger.kernel.org>; Thu,  3 Sep 2020 17:05:44 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id w186so3381330pgb.8
        for <netdev@vger.kernel.org>; Thu, 03 Sep 2020 17:05:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=k9AC4enbGJ3b0sC2EZqKVeI5FTGnaMi6W6rz9Eujrvs=;
        b=zKw7zHa+GqsGtKyhA/66pG9k3n+RqGvfZti96pBqVSwmjDR2az+ZL0d9CN1ACNDlUX
         MzEW+ziyIGJccCc+tHWri+E2Xh1j1eMTgbvHKNcJmBaP3hmC3RVO8PG7/h4RrFsxG0vU
         uzLm1xKFihyaBfDULpI/i3dkqmBlENF4lIG45QCN4zHmbxtO8r+33Hf1MnXJ18ExQ/bf
         1eW4PCW4AXRXEqZguD1dGUdzUl9zHow/DSedmGDfkaPuluAYZDF+TreaDWaEPEZGU5ZM
         NTWyrig3+z30Ety4zmkMA1zj40nxYsuQJGe4MGkx2GEy6pBRPJpETL2hTIy4VyL64xki
         0jng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=k9AC4enbGJ3b0sC2EZqKVeI5FTGnaMi6W6rz9Eujrvs=;
        b=mPEYQ/fenlbjzucnQTQAeKLsG7mFWf7JNoLCGCk4zWSWDjVVOh77+UkzSvPi95qm+s
         dO9IGsQpLawD7Fk9+xNVawJFhipodiavvlNl254lpa3Z4lUdfL0k4vxqCoV4GZ5RWfNU
         xdPCzl0YysPdLi9w4WNmWPpeoXBWgP4wFMAmfKnQwlDw9I7stBCz58HjJNdukf+MITzS
         cw43vPu5VV1i7uFkl+6mZVBnXnxdBYxhX2p7FbtFvbBYt3rOYLoLsSyyhrq+rbpi0T1X
         +h22hnC8BX/95PjewT7gFQeNwKWHNuYADJnvISY4HVABV0UB7EiUJxEUwiyNjbyesr4A
         uIug==
X-Gm-Message-State: AOAM53134zaAjVPPgu9OmMamUH5wsXRNTC5tZUjkCDFSuiHOl5rz+t6R
        gEJqzgEDa1gDImw9s1fIGCi3yDbOJm6oZw==
X-Google-Smtp-Source: ABdhPJwrQhx13aoBd/T3oTAl5V34fcO3060KgqYMFZiW9/IPYjeq2DvB1yszhjvGI90ueKCQ4NNIbQ==
X-Received: by 2002:a63:747:: with SMTP id 68mr4929168pgh.90.1599177943542;
        Thu, 03 Sep 2020 17:05:43 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id w5sm3924602pgk.20.2020.09.03.17.05.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 Sep 2020 17:05:42 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 1/2] ionic: update the fw update api
Date:   Thu,  3 Sep 2020 17:05:33 -0700
Message-Id: <20200904000534.58052-2-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200904000534.58052-1-snelson@pensando.io>
References: <20200904000534.58052-1-snelson@pensando.io>
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

