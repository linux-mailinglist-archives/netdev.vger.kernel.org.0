Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5C21262337
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 00:48:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728463AbgIHWsb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 18:48:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727882AbgIHWsW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 18:48:22 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC0A6C061755
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 15:48:21 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id 7so576309pgm.11
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 15:48:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=k9AC4enbGJ3b0sC2EZqKVeI5FTGnaMi6W6rz9Eujrvs=;
        b=IoLu8nqVdnqLx2sgQ6XJviLMbC0TFwWDgqKBtTDhdiHjDML28x8HbbDDLg4Bp1jjPo
         wzQJcTFpEBB/0pSbLoiPnEn8X9RtadCfXRcrY2g+WvqxfdBDPBqUwy6DzKSRZ1/vQnEO
         kIvbhrGZArVnbnnbTAZhVCt9uqVsva7/jgtXEITpL7OzvlJtFclCRI4IbcTBOGDzCZob
         NGyHl5lKMIOYFbZxlIFojcCPAjwqnlQakR+YOm7Pg3g3UomyrnrS5ASRcueMcgOYs0T2
         sveHLQ/Nm9S+Izwxco5m8g5OZAWTcCsz6KCbOXTzKsQ89PaoNy0zGRtfQyqbk2tccbHs
         8aaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=k9AC4enbGJ3b0sC2EZqKVeI5FTGnaMi6W6rz9Eujrvs=;
        b=na/G1mMR+MliOW8IB9EleuxlAyiRbdqXpAKScPtCEm9N/agjN9J9jV38LwOHdWuRtj
         cUHDZCCkaiLfL8Une6eF7paFeklgnnrzOhPDPQBU/kfSY9jbxspABfOQRFw+XMx9zmsm
         r5PR5wtuC+/LT6G6fqKIMdbg3W8fj/joBhLKVZrdhN6EYTx412bmj065cePfG+WaBhi7
         G1zs5K0gXBxXG3qkgX5bNc3RwWDX3Kfp4rYbw0vtV+sOZiONLTRuHIbDRwLXELj6NHPc
         z9ca3n8dfXGq8jXS8g0/q6aKUxKm5UwV7ofMxOSoVo9x1ftCNuR5QkALvCfwbmBGf9dX
         oNuA==
X-Gm-Message-State: AOAM531F6PMqkN/oNh+77Dtb/V6pRC2siV5CSaEF7gZgUSbgYh3lKsJ/
        qr9PXZ2Zm0uIKxIoQgcN+Kth/X19Xi+4Gw==
X-Google-Smtp-Source: ABdhPJzczGRX8OZFvOZ381MsamA/KGPwwEp+lKF1hFYM4DN6vrrWdiSPgE4TgIX8+l63FJ+sIyHt4g==
X-Received: by 2002:a65:5bcf:: with SMTP id o15mr738071pgr.126.1599605300963;
        Tue, 08 Sep 2020 15:48:20 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id v6sm435515pfi.38.2020.09.08.15.48.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Sep 2020 15:48:20 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v3 net-next 1/2] ionic: update the fw update api
Date:   Tue,  8 Sep 2020 15:48:11 -0700
Message-Id: <20200908224812.63434-2-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200908224812.63434-1-snelson@pensando.io>
References: <20200908224812.63434-1-snelson@pensando.io>
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

