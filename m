Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 907794D6075
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 12:16:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348181AbiCKLRR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 06:17:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbiCKLRO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 06:17:14 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99E951B65F0;
        Fri, 11 Mar 2022 03:16:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1646997370; x=1678533370;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=UywFVtMeuqHrdvnX6PuKPfuyiyJ1glRMsirINFVL7hI=;
  b=gA16u1mXv267FUHUSeffVUhBcx2L2Vu9gsff+pzF4WZeUjQPCs2h2ttx
   L3GudgXRV+VJ3UBJvD2eukvm7xvZ85SUEbZdEEqu6J+NdVVubM52p1wXq
   PIqIq3sEf+2S5z14FKXR1/AVWye/Xe5Hbnsn501IhAbp5HIqv/cHuujdf
   QjY/QopbqMlB/ZChkk6MQ6Tps+avUv5MGIyjLFLbderGqQ5n0y9SfTTLo
   5txG8RTUFaC8pzPuPKhg/4gzVB5ST9lX56e/hjHcXcU6hZb5M4nX3DTZx
   eUi/Pv/UiDAYo9HwAxqmx+o2rAhNIU7UHtl1kciF7l5kmdRetYOI0SIyH
   w==;
X-IronPort-AV: E=Sophos;i="5.90,173,1643698800"; 
   d="scan'208";a="156564691"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Mar 2022 04:16:09 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 11 Mar 2022 04:16:09 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 11 Mar 2022 04:16:06 -0700
From:   Claudiu Beznea <claudiu.beznea@microchip.com>
To:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: [PATCH] net: dsa: microchip: add spi_device_id tables
Date:   Fri, 11 Mar 2022 13:17:16 +0200
Message-ID: <20220311111716.1481881-1-claudiu.beznea@microchip.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add spi_device_id tables to avoid logs like "SPI driver ksz9477-switch
has no spi_device_id".

Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
---
 drivers/net/dsa/microchip/ksz8795_spi.c | 11 +++++++++++
 drivers/net/dsa/microchip/ksz9477_spi.c | 12 ++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/drivers/net/dsa/microchip/ksz8795_spi.c b/drivers/net/dsa/microchip/ksz8795_spi.c
index 866767b70d65..b0a7dee27ffc 100644
--- a/drivers/net/dsa/microchip/ksz8795_spi.c
+++ b/drivers/net/dsa/microchip/ksz8795_spi.c
@@ -124,12 +124,23 @@ static const struct of_device_id ksz8795_dt_ids[] = {
 };
 MODULE_DEVICE_TABLE(of, ksz8795_dt_ids);
 
+static const struct spi_device_id ksz8795_spi_ids[] = {
+	{ "ksz8765" },
+	{ "ksz8794" },
+	{ "ksz8795" },
+	{ "ksz8863" },
+	{ "ksz8873" },
+	{ },
+};
+MODULE_DEVICE_TABLE(spi, ksz8795_spi_ids);
+
 static struct spi_driver ksz8795_spi_driver = {
 	.driver = {
 		.name	= "ksz8795-switch",
 		.owner	= THIS_MODULE,
 		.of_match_table = of_match_ptr(ksz8795_dt_ids),
 	},
+	.id_table = ksz8795_spi_ids,
 	.probe	= ksz8795_spi_probe,
 	.remove	= ksz8795_spi_remove,
 	.shutdown = ksz8795_spi_shutdown,
diff --git a/drivers/net/dsa/microchip/ksz9477_spi.c b/drivers/net/dsa/microchip/ksz9477_spi.c
index e3cb0e6c9f6f..43addeabfc25 100644
--- a/drivers/net/dsa/microchip/ksz9477_spi.c
+++ b/drivers/net/dsa/microchip/ksz9477_spi.c
@@ -98,12 +98,24 @@ static const struct of_device_id ksz9477_dt_ids[] = {
 };
 MODULE_DEVICE_TABLE(of, ksz9477_dt_ids);
 
+static const struct spi_device_id ksz9477_spi_ids[] = {
+	{ "ksz9477" },
+	{ "ksz9897" },
+	{ "ksz9893" },
+	{ "ksz9563" },
+	{ "ksz8563" },
+	{ "ksz9567" },
+	{ },
+};
+MODULE_DEVICE_TABLE(spi, ksz9477_spi_ids);
+
 static struct spi_driver ksz9477_spi_driver = {
 	.driver = {
 		.name	= "ksz9477-switch",
 		.owner	= THIS_MODULE,
 		.of_match_table = of_match_ptr(ksz9477_dt_ids),
 	},
+	.id_table = ksz9477_spi_ids,
 	.probe	= ksz9477_spi_probe,
 	.remove	= ksz9477_spi_remove,
 	.shutdown = ksz9477_spi_shutdown,
-- 
2.32.0

