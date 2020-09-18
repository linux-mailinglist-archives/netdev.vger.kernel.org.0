Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 536EE26EA59
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 03:14:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbgIRBNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 21:13:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726244AbgIRBNj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 21:13:39 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEA74C061788
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 18:13:38 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id s65so2457049pgb.0
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 18:13:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=d5lh7dSTzYL1z77vtX8o0KhR/tEcPbvx+ghe0OFpwQg=;
        b=281PuRZHrtP84ZXrK/qrQU5NAdHyN85zetso5DU1tlG84A3RyyuZWVFSgapuYAlIg2
         bqJMSmm63FyOCoIdgoAMMKD36tUQ+BAb+6ugI1ZJ5UYb419KTlZjGY81dxR3RXeBstXx
         eUhiL7EcXftyj5k6hkNziXtWbjU1Fnp80NzbZb/oHQmSCd6i/4qnnQyRt9eSVVmSX3ZS
         ctfpfRa2dz+EwubqcT+A3pwRAKJMyVklOqVUhHvNb0HCz/huWnBwhe8aqaZZmPgwYKlH
         TUqjV0j/R85cBOlp+cK6+WgkdaJATRQ9/k/+LJbLM5KjUfY6W1wNTyhh6u9mdBvKDW2m
         CE/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=d5lh7dSTzYL1z77vtX8o0KhR/tEcPbvx+ghe0OFpwQg=;
        b=Yo+WpO2+p3KtCRsA2EzmaHsEEa6lvH32KLNRENuU6MwYn3Efmt+3Qw+/uYQX7EaVLv
         TcuHAkZuBGMnUJoBuSiBTIWSLrAVDIB/HcEuaEVkS0UPc2VQgbuizwoADh6IwJim7mUV
         oec7YLxDzxcBSAJ0t7eSgZS8kRGTWODDVcGdHM46D2BrXLvdeKxecKWZpbF+diC+Pmhj
         VjQ0slQdt5aCJ8PcQ7vnHtCu0qVqnoNa0vNj4IXsVlQnU9QnGHDrW0goGkLsLVBD4/P5
         9o7o2FLhpzdtsweKQgwHAZwgP9/YRyOElPCsNDrfH4Cm576tdA900UVIJnuTIOb+ZdoK
         gQuw==
X-Gm-Message-State: AOAM533lo947ozHv6GDeJEDN1p+R959Lo9TnaflFqh5RAGfwne4tyepN
        R/MvcUBHfa7XnIxCU75eQy7+bKwPlGNRdw==
X-Google-Smtp-Source: ABdhPJxn+chDJdUn8yxFGX3Db7CxsI4T2WS6V45VWb/Ofgrb4ntIEqu2FIaBvno2/YC0fzdg3dMQjQ==
X-Received: by 2002:a62:1d51:0:b029:13e:d13d:a07f with SMTP id d78-20020a621d510000b029013ed13da07fmr29629206pfd.22.1600391618226;
        Thu, 17 Sep 2020 18:13:38 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id e19sm955701pfl.135.2020.09.17.18.13.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Sep 2020 18:13:37 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v5 net-next 4/5] ionic: update the fw update api
Date:   Thu, 17 Sep 2020 18:13:26 -0700
Message-Id: <20200918011327.31577-5-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200918011327.31577-1-snelson@pensando.io>
References: <20200918011327.31577-1-snelson@pensando.io>
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

