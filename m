Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 493EA55470D
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 14:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357211AbiFVJHo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 05:07:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357071AbiFVJH2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 05:07:28 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FB5739695;
        Wed, 22 Jun 2022 02:06:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1655888786; x=1687424786;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QgwgRyX8o4yRJN4ShcJUdlkyfnx63f1v1svi3Wnwp3Y=;
  b=n5dKuilqcppLOrJOtygSK6kRxG7lNGWGGRsQ7LbXdcWGqgieBS7M2N1V
   MnBjVBoWJXw6bV4rn46xGre33WKYLW3BG7sNSwTGRtGmmxV/esSGYM45q
   lgPquFlCj+MwWkN3sIhnFqoFrkyL5bnBoTMZ9/gPLGW8QwBDlfpRt20le
   3gaptVVH824MYwgHQo2Adc7jxxl9dDVh+BhvNXY7LNQYeNk69bHDwDmy6
   yUbl0eOwyDQhsObheEUFiJgzazkQ0efVMmFja6vpdn+7mJsS51QeeJu+t
   +vvWgPnNev+YGJC7F2X92DTJU+gHag69XBmffYrHqqo4SZ+gMNqxlNlyO
   w==;
X-IronPort-AV: E=Sophos;i="5.92,212,1650956400"; 
   d="scan'208";a="101185305"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Jun 2022 02:06:25 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 22 Jun 2022 02:06:25 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Wed, 22 Jun 2022 02:06:20 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Woojung Huh <woojung.huh@microchip.com>,
        <UNGLinuxDriver@microchip.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Russell King" <linux@armlinux.org.uk>
Subject: [Patch net-next 01/13] net: dsa: microchip: rename shutdown to reset in ksz_dev_ops
Date:   Wed, 22 Jun 2022 14:34:13 +0530
Message-ID: <20220622090425.17709-2-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220622090425.17709-1-arun.ramadoss@microchip.com>
References: <20220622090425.17709-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch renames the shutdown to reset in ksz_dev_ops in order to use
the reset dev_ops in the ksz_setup.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz8795.c     | 4 ++--
 drivers/net/dsa/microchip/ksz8795_spi.c | 4 ++--
 drivers/net/dsa/microchip/ksz9477.c     | 4 ++--
 drivers/net/dsa/microchip/ksz9477_i2c.c | 4 ++--
 drivers/net/dsa/microchip/ksz_common.h  | 2 +-
 5 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 23ed05f4efcc..ad58112bda44 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -1379,7 +1379,7 @@ static int ksz8_setup(struct dsa_switch *ds)
 	if (!dev->vlan_cache)
 		return -ENOMEM;
 
-	ret = ksz8_reset_switch(dev);
+	ret = dev->dev_ops->reset(dev);
 	if (ret) {
 		dev_err(ds->dev, "failed to reset switch\n");
 		return ret;
@@ -1545,7 +1545,7 @@ static const struct ksz_dev_ops ksz8_dev_ops = {
 	.mirror_add = ksz8_port_mirror_add,
 	.mirror_del = ksz8_port_mirror_del,
 	.get_caps = ksz8_get_caps,
-	.shutdown = ksz8_reset_switch,
+	.reset = ksz8_reset_switch,
 	.init = ksz8_switch_init,
 	.exit = ksz8_switch_exit,
 };
diff --git a/drivers/net/dsa/microchip/ksz8795_spi.c b/drivers/net/dsa/microchip/ksz8795_spi.c
index 961a74c359a8..3f27aee9b6d3 100644
--- a/drivers/net/dsa/microchip/ksz8795_spi.c
+++ b/drivers/net/dsa/microchip/ksz8795_spi.c
@@ -110,8 +110,8 @@ static void ksz8795_spi_shutdown(struct spi_device *spi)
 	if (!dev)
 		return;
 
-	if (dev->dev_ops->shutdown)
-		dev->dev_ops->shutdown(dev);
+	if (dev->dev_ops->reset)
+		dev->dev_ops->reset(dev);
 
 	dsa_switch_shutdown(dev->ds);
 
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 5b4fc16e1692..4e0e9507e62a 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -1246,7 +1246,7 @@ static int ksz9477_setup(struct dsa_switch *ds)
 	if (!dev->vlan_cache)
 		return -ENOMEM;
 
-	ret = ksz9477_reset_switch(dev);
+	ret = dev->dev_ops->reset(dev);
 	if (ret) {
 		dev_err(ds->dev, "failed to reset switch\n");
 		return ret;
@@ -1400,7 +1400,7 @@ static const struct ksz_dev_ops ksz9477_dev_ops = {
 	.mdb_del = ksz9477_mdb_del,
 	.change_mtu = ksz9477_change_mtu,
 	.max_mtu = ksz9477_max_mtu,
-	.shutdown = ksz9477_reset_switch,
+	.reset = ksz9477_reset_switch,
 	.init = ksz9477_switch_init,
 	.exit = ksz9477_switch_exit,
 };
diff --git a/drivers/net/dsa/microchip/ksz9477_i2c.c b/drivers/net/dsa/microchip/ksz9477_i2c.c
index faa3163c86b0..4ade64387f3a 100644
--- a/drivers/net/dsa/microchip/ksz9477_i2c.c
+++ b/drivers/net/dsa/microchip/ksz9477_i2c.c
@@ -71,8 +71,8 @@ static void ksz9477_i2c_shutdown(struct i2c_client *i2c)
 	if (!dev)
 		return;
 
-	if (dev->dev_ops->shutdown)
-		dev->dev_ops->shutdown(dev);
+	if (dev->dev_ops->reset)
+		dev->dev_ops->reset(dev);
 
 	dsa_switch_shutdown(dev->ds);
 
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index ebcfa688ea2c..44f60922be92 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -204,7 +204,7 @@ struct ksz_dev_ops {
 	int (*max_mtu)(struct ksz_device *dev, int port);
 	void (*freeze_mib)(struct ksz_device *dev, int port, bool freeze);
 	void (*port_init_cnt)(struct ksz_device *dev, int port);
-	int (*shutdown)(struct ksz_device *dev);
+	int (*reset)(struct ksz_device *dev);
 	int (*init)(struct ksz_device *dev);
 	void (*exit)(struct ksz_device *dev);
 };
-- 
2.36.1

