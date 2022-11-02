Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 067B2615B5B
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 05:16:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230327AbiKBEQC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 00:16:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230161AbiKBEPZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 00:15:25 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60D03248FB;
        Tue,  1 Nov 2022 21:14:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1667362493; x=1698898493;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9GnNyz13QneI0oPfy3KJmDwliNeb7C9tr9KliRE0l1Y=;
  b=gZLsJTEVElUpMI4cqB3RQdhzTkDr4jZo3kJw52arjpoNkcIMZ8fbgeg0
   o7cWUDU+ELrQcQI5YIVIIkfTTrPetrbrprjJyFLpslVHKE358aVcuTEpd
   8WN6xPqh3nOmxB+NS9a5HbupyYj3yV0xNLtgwIBHqUoSiNjVxQbSHYaNw
   lDE2kYy4wPKCEiSXNuQX0zOPQTeJUVNs+PhaQHBWYNo1rnhBbGL2Q4JX9
   N0C4/e2Vt0MNBF+fmcV0+xPKyll3T4Cgab6BWVCFpcDWzcYWHlI41WpiN
   gKRQmuxX+lh3wJYnEMvM2JRhWEThjWebt1TCIxgLB51441qD4/mEUqMN4
   w==;
X-IronPort-AV: E=Sophos;i="5.95,232,1661842800"; 
   d="scan'208";a="181530261"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Nov 2022 21:14:53 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 1 Nov 2022 21:14:52 -0700
Received: from che-lt-i67786lx.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Tue, 1 Nov 2022 21:14:48 -0700
From:   Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
Subject: [PATCH net-next 6/6] net: dsa: microchip: add dev_err_probe in probe functions
Date:   Wed, 2 Nov 2022 09:40:58 +0530
Message-ID: <20221102041058.128779-7-rakesh.sankaranarayanan@microchip.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221102041058.128779-1-rakesh.sankaranarayanan@microchip.com>
References: <20221102041058.128779-1-rakesh.sankaranarayanan@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
index ddb40838181e..9e49c2cc0550 100644
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
+					     PTR_ERR(dev->regmap[i])
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

