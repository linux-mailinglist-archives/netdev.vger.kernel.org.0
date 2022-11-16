Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F56862CBAD
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 21:54:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239037AbiKPUyu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 15:54:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238497AbiKPUx5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 15:53:57 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D5BC10D2
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 12:53:34 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id kt23so47159981ejc.7
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 12:53:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=81I+3EQI2P3P+v8VM+hyFuPqC5NfWDfLreVqvTuq6Uc=;
        b=XGipdapc5eAZDNwW6fDCnAfCBr6vjHFnAILuue5kTPnrIATThKIRIsIhP+z2KZwAGM
         6xUobtU2sa5lE10jjJuuGNMVisNd9drGLcSzv6wmClcvUclmWAmCV8h2h8ZRfZofPWkk
         EuEnru3SohqNWb7K9iS8av9HqIlHgNU2e25Giu//b4SVp9G8/OrJD+9wghG9ckRYwxtE
         X4eRS4eDvt6HAqph+8CzeaqjwtSLUZ5iJ15PYapHdGYS35arY+2biLqjbCfQZ9EXjLtu
         DWd4+/L/CNt5DvXwsWmmL929RLKDfwctrtrmB45Qp5SKPT2mizdg61T0XLQntWDtK1YX
         cZpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=81I+3EQI2P3P+v8VM+hyFuPqC5NfWDfLreVqvTuq6Uc=;
        b=REUzIgaGyuijbmYJKN4AMj9RGFQ1AGvUdDobTbZYifMayde9kSG2W6o6EIo3MQVbZe
         n3L6C6UIENjpCIcvzbot38E3DgKFhyn16uFOCpW1bEa8HX0i5dOWseT2ZXJ2oPzDzbg3
         t2eqTMgvJBLwsyDWEDUhp7b+o53HJaXGQy45TcnOKoFIsc7SfAhAPgD/LDJEaR4RXAoM
         FxaT8/g7Kc4m/+9JVby0Wzzay1hw86CL2v0+TRW4ZTSYkVm4BPkxnOPAbnKIj/o2pOZZ
         QN/WUE8qmYABDMu1xQRa7/Dty5sihidO44/4fW6c3t2m+9WFUfiKtQUn+YodtYJqLKM9
         ugTw==
X-Gm-Message-State: ANoB5pnITQeAxIM6cMoe3+hqPAhPNW9OG7XrEPVQJSs2RfJJvnbZrPsD
        uv7bCyV8c1fYiUv3sbthHV/yZg==
X-Google-Smtp-Source: AA0mqf5gWZiTI+lorhmPiazyth1FJOvdr7rtTgE1xpct/bqYxkEIR1Skr1ITdAXzpk52b/fk0WKCEQ==
X-Received: by 2002:a17:906:814:b0:78e:ebd:bf96 with SMTP id e20-20020a170906081400b0078e0ebdbf96mr19030638ejd.625.1668632014449;
        Wed, 16 Nov 2022 12:53:34 -0800 (PST)
Received: from blmsp.fritz.box ([2001:4090:a244:804b:353b:565:addf:3aa7])
        by smtp.gmail.com with ESMTPSA id kv17-20020a17090778d100b007aece68483csm6782828ejc.193.2022.11.16.12.53.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 12:53:34 -0800 (PST)
From:   Markus Schneider-Pargmann <msp@baylibre.com>
To:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Markus Schneider-Pargmann <msp@baylibre.com>
Subject: [PATCH 13/15] can: tcan4x5x: Fix use of register error status mask
Date:   Wed, 16 Nov 2022 21:53:06 +0100
Message-Id: <20221116205308.2996556-14-msp@baylibre.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221116205308.2996556-1-msp@baylibre.com>
References: <20221116205308.2996556-1-msp@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TCAN4X5X_ERROR_STATUS is not a status register that needs clearing
during interrupt handling. Instead this is a masking register that masks
error interrupts. Writing TCAN4X5X_CLEAR_ALL_INT to this register
effectively masks everything.

Rename the register and mask all error interrupts only once by writing
to the register in tcan4x5x_init.

Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
---
 drivers/net/can/m_can/tcan4x5x-core.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/can/m_can/tcan4x5x-core.c b/drivers/net/can/m_can/tcan4x5x-core.c
index 1fec394b3517..efa2381bf85b 100644
--- a/drivers/net/can/m_can/tcan4x5x-core.c
+++ b/drivers/net/can/m_can/tcan4x5x-core.c
@@ -10,7 +10,7 @@
 #define TCAN4X5X_DEV_ID1 0x04
 #define TCAN4X5X_REV 0x08
 #define TCAN4X5X_STATUS 0x0C
-#define TCAN4X5X_ERROR_STATUS 0x10
+#define TCAN4X5X_ERROR_STATUS_MASK 0x10
 #define TCAN4X5X_CONTROL 0x14
 
 #define TCAN4X5X_CONFIG 0x800
@@ -204,12 +204,7 @@ static int tcan4x5x_clear_interrupts(struct m_can_classdev *cdev)
 	if (ret)
 		return ret;
 
-	ret = tcan4x5x_write_tcan_reg(cdev, TCAN4X5X_INT_FLAGS,
-				      TCAN4X5X_CLEAR_ALL_INT);
-	if (ret)
-		return ret;
-
-	return tcan4x5x_write_tcan_reg(cdev, TCAN4X5X_ERROR_STATUS,
+	return tcan4x5x_write_tcan_reg(cdev, TCAN4X5X_INT_FLAGS,
 				       TCAN4X5X_CLEAR_ALL_INT);
 }
 
@@ -229,6 +224,11 @@ static int tcan4x5x_init(struct m_can_classdev *cdev)
 	if (ret)
 		return ret;
 
+	ret = tcan4x5x_write_tcan_reg(cdev, TCAN4X5X_ERROR_STATUS_MASK,
+				      TCAN4X5X_CLEAR_ALL_INT);
+	if (ret)
+		return ret;
+
 	/* Zero out the MCAN buffers */
 	ret = m_can_init_ram(cdev);
 	if (ret)
-- 
2.38.1

