Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1E6461E9F7
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 04:58:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231388AbiKGD6B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Nov 2022 22:58:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbiKGD5y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Nov 2022 22:57:54 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BC2310549;
        Sun,  6 Nov 2022 19:57:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1667793464; x=1699329464;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cmNTa7zVOFJxvvcO+PfybH0ef81VinhQBT/y9wv2pE4=;
  b=YNb5KPd8aaCvuN1ZeHfmPVTvZUKDCLdAHYKWUe0QDkpFsIAIZC3b26z1
   uJSgZG4ApiRi8DrcYKmy5eDD+nDEf/xMVUqjorWi+9p5xiwz+X2+Xjcw4
   aTSqTphFRg3aCsr1YDbeHajse3K37LsavRT7wRIA5sIkK/qV4lyQr5NuA
   Yru11NjqDggiFF3yqrQt5gpFDNHVVj0O4xxbvOXRTe7kLBB8c/fH7Ms7n
   yloiegjrVuJ/E36Gww+0ID+ZlwN9fOwW2J4AJeVVqxrYOXfqdAI3fZNWI
   AQ40x9ffNwj9qhTEyzq9GBn1D0GbOoJpzyvMJRmK3ow1Wg92xkTH9chBG
   w==;
X-IronPort-AV: E=Sophos;i="5.96,143,1665471600"; 
   d="scan'208";a="182188393"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Nov 2022 20:57:43 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Sun, 6 Nov 2022 20:57:43 -0700
Received: from che-lt-i67786lx.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Sun, 6 Nov 2022 20:57:39 -0700
From:   Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
Subject: [PATCH net-next v2 5/5] net: dsa: microchip: add dev_err_probe in probe functions
Date:   Mon, 7 Nov 2022 14:59:22 +0530
Message-ID: <20221107092922.5926-6-rakesh.sankaranarayanan@microchip.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221107092922.5926-1-rakesh.sankaranarayanan@microchip.com>
References: <20221107092922.5926-1-rakesh.sankaranarayanan@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Probe functions uses normal dev_err() to check error conditions
and print messages. Replace dev_err() with dev_err_probe() to
have more standardized format and error logging.

Signed-off-by: Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
---
 drivers/net/dsa/microchip/ksz8863_smi.c | 9 ++++-----
 drivers/net/dsa/microchip/ksz9477_i2c.c | 8 +++-----
 drivers/net/dsa/microchip/ksz_spi.c     | 8 +++-----
 3 files changed, 10 insertions(+), 15 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8863_smi.c b/drivers/net/dsa/microchip/ksz8863_smi.c
index ddb40838181e..2f4623f3bd85 100644
--- a/drivers/net/dsa/microchip/ksz8863_smi.c
+++ b/drivers/net/dsa/microchip/ksz8863_smi.c
@@ -152,11 +152,10 @@ static int ksz8863_smi_probe(struct mdio_device *mdiodev)
 						  &regmap_smi[i], dev,
 						  &rc);
 		if (IS_ERR(dev->regmap[i])) {
-			ret = PTR_ERR(dev->regmap[i]);
-			dev_err(&mdiodev->dev,
-				"Failed to initialize regmap%i: %d\n",
-				ksz8863_regmap_config[i].val_bits, ret);
-			return ret;
+			return dev_err_probe(&mdiodev->dev,
+					     PTR_ERR(dev->regmap[i]),
+					     "Failed to initialize regmap%i\n",
+					     ksz8863_regmap_config[i].val_bits);
 		}
 	}
 
diff --git a/drivers/net/dsa/microchip/ksz9477_i2c.c b/drivers/net/dsa/microchip/ksz9477_i2c.c
index caa9acf1495c..db4aec0a51dc 100644
--- a/drivers/net/dsa/microchip/ksz9477_i2c.c
+++ b/drivers/net/dsa/microchip/ksz9477_i2c.c
@@ -30,11 +30,9 @@ static int ksz9477_i2c_probe(struct i2c_client *i2c,
 		rc.lock_arg = &dev->regmap_mutex;
 		dev->regmap[i] = devm_regmap_init_i2c(i2c, &rc);
 		if (IS_ERR(dev->regmap[i])) {
-			ret = PTR_ERR(dev->regmap[i]);
-			dev_err(&i2c->dev,
-				"Failed to initialize regmap%i: %d\n",
-				ksz9477_regmap_config[i].val_bits, ret);
-			return ret;
+			return dev_err_probe(&i2c->dev, PTR_ERR(dev->regmap[i]),
+					     "Failed to initialize regmap%i\n",
+					     ksz9477_regmap_config[i].val_bits);
 		}
 	}
 
diff --git a/drivers/net/dsa/microchip/ksz_spi.c b/drivers/net/dsa/microchip/ksz_spi.c
index 4f2186779082..96c52e8fb51b 100644
--- a/drivers/net/dsa/microchip/ksz_spi.c
+++ b/drivers/net/dsa/microchip/ksz_spi.c
@@ -71,11 +71,9 @@ static int ksz_spi_probe(struct spi_device *spi)
 		dev->regmap[i] = devm_regmap_init_spi(spi, &rc);
 
 		if (IS_ERR(dev->regmap[i])) {
-			ret = PTR_ERR(dev->regmap[i]);
-			dev_err(&spi->dev,
-				"Failed to initialize regmap%i: %d\n",
-				regmap_config[i].val_bits, ret);
-			return ret;
+			return dev_err_probe(&spi->dev, PTR_ERR(dev->regmap[i]),
+					     "Failed to initialize regmap%i\n",
+					     regmap_config[i].val_bits);
 		}
 	}
 
-- 
2.34.1

