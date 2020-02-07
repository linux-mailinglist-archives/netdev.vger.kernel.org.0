Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2D13155AF1
	for <lists+netdev@lfdr.de>; Fri,  7 Feb 2020 16:44:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727011AbgBGPoX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Feb 2020 10:44:23 -0500
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:20395 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726897AbgBGPoW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Feb 2020 10:44:22 -0500
Received-SPF: Pass (esa1.microchip.iphmx.com: domain of
  Codrin.Ciubotariu@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa1.microchip.iphmx.com;
  envelope-from="Codrin.Ciubotariu@microchip.com";
  x-sender="Codrin.Ciubotariu@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com -exists:%{i}.spf.microchip.iphmx.com
  include:servers.mcsv.net include:mktomail.com
  include:spf.protection.outlook.com ~all"
Received-SPF: None (esa1.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa1.microchip.iphmx.com;
  envelope-from="Codrin.Ciubotariu@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa1.microchip.iphmx.com; spf=Pass smtp.mailfrom=Codrin.Ciubotariu@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: LA60xnPpd62EaiIhnERTdWqGT643gCgIeIyjeXpiacNTrS5a312SxgAdYle3agXUGkPe2hRGM1
 4BS5NdE1uWuL2ciRuTYZUwmQ4EUrlRP4+kCPf45l+dSF6QuQkK3EsM4L4Cu6WogZJdI0tbRVqa
 Iut9DvcABJxzvdygJcr0PTTaemLasbTjGOhN5GHLCttMsFVEn/8kYoLxFpkvcJ3ZsT0RV1M6SP
 g2BaT6VzRj72fUe+/xbEFvGSKwOwR3rL/DOP+p7JCDiuzOETdbxITA1DyfrRtTKlKxj2hGVR6z
 s8U=
X-IronPort-AV: E=Sophos;i="5.70,413,1574146800"; 
   d="scan'208";a="67667033"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Feb 2020 08:44:21 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 7 Feb 2020 08:44:21 -0700
Received: from rob-ult-m19940.microchip.com (10.10.85.251) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Fri, 7 Feb 2020 08:44:17 -0700
From:   Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <davem@davemloft.net>,
        Razvan Stefanescu <razvan.stefanescu@microchip.com>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
Subject: [PATCH v3] net: dsa: microchip: enable module autoprobe
Date:   Fri, 7 Feb 2020 17:44:04 +0200
Message-ID: <20200207154404.1093-1-codrin.ciubotariu@microchip.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Razvan Stefanescu <razvan.stefanescu@microchip.com>

This matches /sys/devices/.../spi1.0/modalias content.

Fixes: 9b2d9f05cddf ("net: dsa: microchip: add ksz9567 to ksz9477 driver")
Fixes: d9033ae95cf4 ("net: dsa: microchip: add KSZ8563 compatibility string")
Fixes: 8c29bebb1f8a ("net: dsa: microchip: add KSZ9893 switch support")
Fixes: 45316818371d ("net: dsa: add support for ksz9897 ethernet switch")
Fixes: b987e98e50ab ("dsa: add DSA switch driver for Microchip KSZ9477")
Signed-off-by: Razvan Stefanescu <razvan.stefanescu@microchip.com>
Signed-off-by: Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---

Perhaps it is worth mentioning that the original file with the driver
was renamed in:
74a7194f15b3 ("net: dsa: microchip: rename ksz_spi.c to ksz9477_spi.c")

Changes in v3:
 - added multiple 'Fixes' tags;
 - add 'Reviewed-by' tag from Andrew;

Changes in v2:
 - added alias for all the variants of this driver

 drivers/net/dsa/microchip/ksz9477_spi.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/dsa/microchip/ksz9477_spi.c b/drivers/net/dsa/microchip/ksz9477_spi.c
index c5f64959a184..1142768969c2 100644
--- a/drivers/net/dsa/microchip/ksz9477_spi.c
+++ b/drivers/net/dsa/microchip/ksz9477_spi.c
@@ -101,6 +101,12 @@ static struct spi_driver ksz9477_spi_driver = {
 
 module_spi_driver(ksz9477_spi_driver);
 
+MODULE_ALIAS("spi:ksz9477");
+MODULE_ALIAS("spi:ksz9897");
+MODULE_ALIAS("spi:ksz9893");
+MODULE_ALIAS("spi:ksz9563");
+MODULE_ALIAS("spi:ksz8563");
+MODULE_ALIAS("spi:ksz9567");
 MODULE_AUTHOR("Woojung Huh <Woojung.Huh@microchip.com>");
 MODULE_DESCRIPTION("Microchip KSZ9477 Series Switch SPI access Driver");
 MODULE_LICENSE("GPL");
-- 
2.20.1

