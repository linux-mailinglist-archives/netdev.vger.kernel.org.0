Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 584DB65332E
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 16:26:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234668AbiLUPZy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 10:25:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234567AbiLUPZr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 10:25:47 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DBEC10C0
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 07:25:44 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id d14so22402335edj.11
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 07:25:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mDXoKkBf3QKLFoNBUr2onp8tCGWeovhpj/ofZ+JjjAU=;
        b=TMhjNigS1DyIwH8CyjsHocZyaHTt7KyK/ZCjumwTN9EBxfeVWy11UJZ/hucZ2QgmKL
         i9+S6Mr5k3JlxoN74cBxQBq5gFNneK9tZoVKVuhnXkRB+1GzIbXAOID2fxatGI5h++TP
         Zg9ZUwqOFDAJMcdoLKzmPTzBXPps2BJltJYupb2iQNZHydtKxPrU6WqFRuRBLXcQKyyd
         RSGOLfNeeYDV6fqcRTz8VyNhfGn9nhcgt20R8gwBN4q/t2Qht1mRCwJLS7+fMZZ79ntP
         IbRv940LZ2xjde+/NVeGOgUh4xPCi4R9M9R3FJQF2QijNknp5xw1uMDXBgb9s5+22ovo
         TWNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mDXoKkBf3QKLFoNBUr2onp8tCGWeovhpj/ofZ+JjjAU=;
        b=SvouRAUAnJE1YpzKQB/G3Hn4+O6gNiNeqSk5cWrQOuCBM8ZSrhBfr0RzW+9giiG8NZ
         VIC1qOabpNeD2ym9pCua89CIgtOC6QGVnbLXrUiUl1fXzZgKUKjJ7y5uq1db0hWecrAN
         fNFpX3YushZhNf3jYcbch0GUe2YsGa6CYBVwJeIEMpIkvr0WRwXakMSf8ovVbG6c8d6I
         ChpI61qEcq4SyDW8B175XD2cTsmL18CtWEQ0/yKJoaj0X1LCbPCHUoJksoEMMQWExAWp
         Jdmj05kppKWyy3S6WNQ9ZKjq++CrHczB/UHsuMJfAgS1HP4jcKFTBKtYnDOdVx3hAfGJ
         HmDQ==
X-Gm-Message-State: AFqh2kqHt1znnOaiHbKqeioKfr0YpjRo9M+Q4/ENbonx9ZbCsbdrJ+8E
        KDetLBI4DLIim5nvswyngidIpw==
X-Google-Smtp-Source: AMrXdXvDT6t1W5s5aKGrm+2dh3ZxOOswfb0M9pNKaUvRbk1dyeabzSVb+FxlWX7PhrvG+s4dg43FWA==
X-Received: by 2002:a50:fd10:0:b0:46c:97c2:8d75 with SMTP id i16-20020a50fd10000000b0046c97c28d75mr1720946eds.21.1671636342810;
        Wed, 21 Dec 2022 07:25:42 -0800 (PST)
Received: from blmsp.fritz.box ([2001:4091:a245:805c:8713:84e4:2a9e:cbe8])
        by smtp.gmail.com with ESMTPSA id n19-20020aa7c793000000b0045cf4f72b04sm7105428eds.94.2022.12.21.07.25.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Dec 2022 07:25:42 -0800 (PST)
From:   Markus Schneider-Pargmann <msp@baylibre.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>
Cc:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Markus Schneider-Pargmann <msp@baylibre.com>
Subject: [PATCH 02/18] can: tcan4x5x: Check size of mram configuration
Date:   Wed, 21 Dec 2022 16:25:21 +0100
Message-Id: <20221221152537.751564-3-msp@baylibre.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221221152537.751564-1-msp@baylibre.com>
References: <20221221152537.751564-1-msp@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To reduce debugging effort in case the mram is misconfigured, add this
size check of the DT configuration. Currently if the mram configuration
doesn't fit into the available MRAM it just overwrites other areas of
the MRAM.

Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
---
 drivers/net/can/m_can/m_can.c         | 16 ++++++++++++++++
 drivers/net/can/m_can/m_can.h         |  1 +
 drivers/net/can/m_can/tcan4x5x-core.c |  5 +++++
 3 files changed, 22 insertions(+)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 56f07f2023dd..f3ee21ce6109 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1860,6 +1860,22 @@ static int register_m_can_dev(struct net_device *dev)
 	return register_candev(dev);
 }
 
+int m_can_check_mram_cfg(struct m_can_classdev *cdev, u32 mram_max_size)
+{
+	u32 total_size;
+
+	total_size = cdev->mcfg[MRAM_TXB].off - cdev->mcfg[MRAM_SIDF].off +
+			cdev->mcfg[MRAM_TXB].num * TXB_ELEMENT_SIZE;
+	if (total_size > mram_max_size) {
+		dev_err(cdev->dev, "Total size of mram config(%u) exceeds mram(%u)\n",
+			total_size, mram_max_size);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(m_can_check_mram_cfg);
+
 static void m_can_of_parse_mram(struct m_can_classdev *cdev,
 				const u32 *mram_config_vals)
 {
diff --git a/drivers/net/can/m_can/m_can.h b/drivers/net/can/m_can/m_can.h
index 4c0267f9f297..d2c584232c1a 100644
--- a/drivers/net/can/m_can/m_can.h
+++ b/drivers/net/can/m_can/m_can.h
@@ -101,6 +101,7 @@ int m_can_class_register(struct m_can_classdev *cdev);
 void m_can_class_unregister(struct m_can_classdev *cdev);
 int m_can_class_get_clocks(struct m_can_classdev *cdev);
 int m_can_init_ram(struct m_can_classdev *priv);
+int m_can_check_mram_cfg(struct m_can_classdev *cdev, u32 mram_max_size);
 
 int m_can_class_suspend(struct device *dev);
 int m_can_class_resume(struct device *dev);
diff --git a/drivers/net/can/m_can/tcan4x5x-core.c b/drivers/net/can/m_can/tcan4x5x-core.c
index efa2381bf85b..4f5a3ade6de2 100644
--- a/drivers/net/can/m_can/tcan4x5x-core.c
+++ b/drivers/net/can/m_can/tcan4x5x-core.c
@@ -80,6 +80,7 @@
 	 TCAN4X5X_MCAN_IR_RF1F)
 
 #define TCAN4X5X_MRAM_START 0x8000
+#define TCAN4X5X_MRAM_SIZE 0x800
 #define TCAN4X5X_MCAN_OFFSET 0x1000
 
 #define TCAN4X5X_CLEAR_ALL_INT 0xffffffff
@@ -312,6 +313,10 @@ static int tcan4x5x_can_probe(struct spi_device *spi)
 	if (!mcan_class)
 		return -ENOMEM;
 
+	ret = m_can_check_mram_cfg(mcan_class, TCAN4X5X_MRAM_SIZE);
+	if (ret)
+		goto out_m_can_class_free_dev;
+
 	priv = cdev_to_priv(mcan_class);
 
 	priv->power = devm_regulator_get_optional(&spi->dev, "vsup");
-- 
2.38.1

