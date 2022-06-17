Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1404C54F373
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 10:47:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381276AbiFQIoy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 04:44:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381234AbiFQIov (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 04:44:51 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 513486971E;
        Fri, 17 Jun 2022 01:44:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1655455489; x=1686991489;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hNuy0EDl9x6W1doovWP7BDFtKw0/P730aUtWH+iInZU=;
  b=2FFwGUZ7djQk8ec+kOF5I/Umq2VQNgZNGj/GnvXYiaq36b18kTHY83S4
   Ysy6Ncxyu71u5y0fKx1zqnBctSwZ/55S4AHFvepANpTXQOEfHIzr4Bmkh
   CIQ6NQDcIAl5e7lp+GtycJyWBrXqt6wviJfxT+xbjxx6j+BsjWK/aSFmk
   jsumX59PoF0ivy+aHl3AtoSz9CEecN/rSRtsXQM0ZNqeRK3+JukuYuE5a
   phZ7itrzD7YxWdyHqKORU5ermUMEZ10LoBLorUGJm9gUFDAqnB/L9O0gc
   PlABxUQllTnzTS6oM/RO6xziqYVK2yJqitc5Vo9S+VFyPWuyPPx0gztG3
   w==;
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="160794572"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Jun 2022 01:44:48 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 17 Jun 2022 01:44:48 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 17 Jun 2022 01:44:44 -0700
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
Subject: [Patch net-next 08/11] net: dsa: microchip: update the ksz_phylink_get_caps
Date:   Fri, 17 Jun 2022 14:12:52 +0530
Message-ID: <20220617084255.19376-9-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220617084255.19376-1-arun.ramadoss@microchip.com>
References: <20220617084255.19376-1-arun.ramadoss@microchip.com>
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

This patch assigns the phylink_get_caps in ksz8795 and ksz9477 to
ksz_phylink_get_caps. And update their mac_capabilities in the
respective ksz_dev_ops.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/microchip/ksz8795.c    | 9 +++------
 drivers/net/dsa/microchip/ksz9477.c    | 7 +++----
 drivers/net/dsa/microchip/ksz_common.c | 3 +++
 drivers/net/dsa/microchip/ksz_common.h | 2 ++
 4 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 9721c55974be..440779a2cca6 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -1348,13 +1348,9 @@ static int ksz8_setup(struct dsa_switch *ds)
 	return ksz8_handle_global_errata(ds);
 }
 
-static void ksz8_get_caps(struct dsa_switch *ds, int port,
+static void ksz8_get_caps(struct ksz_device *dev, int port,
 			  struct phylink_config *config)
 {
-	struct ksz_device *dev = ds->priv;
-
-	ksz_phylink_get_caps(ds, port, config);
-
 	config->mac_capabilities = MAC_10 | MAC_100;
 
 	/* Silicon Errata Sheet (DS80000830A):
@@ -1376,7 +1372,7 @@ static const struct dsa_switch_ops ksz8_switch_ops = {
 	.setup			= ksz8_setup,
 	.phy_read		= ksz_phy_read16,
 	.phy_write		= ksz_phy_write16,
-	.phylink_get_caps	= ksz8_get_caps,
+	.phylink_get_caps	= ksz_phylink_get_caps,
 	.phylink_mac_link_down	= ksz_mac_link_down,
 	.port_enable		= ksz_enable_port,
 	.get_strings		= ksz_get_strings,
@@ -1458,6 +1454,7 @@ static const struct ksz_dev_ops ksz8_dev_ops = {
 	.vlan_del = ksz8_port_vlan_del,
 	.mirror_add = ksz8_port_mirror_add,
 	.mirror_del = ksz8_port_mirror_del,
+	.get_caps = ksz8_get_caps,
 	.shutdown = ksz8_reset_switch,
 	.init = ksz8_switch_init,
 	.exit = ksz8_switch_exit,
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index fed16bbede0a..c90a807610c0 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -1068,11 +1068,9 @@ static void ksz9477_phy_errata_setup(struct ksz_device *dev, int port)
 	ksz9477_port_mmd_write(dev, port, 0x1c, 0x20, 0xeeee);
 }
 
-static void ksz9477_get_caps(struct dsa_switch *ds, int port,
+static void ksz9477_get_caps(struct ksz_device *dev, int port,
 			     struct phylink_config *config)
 {
-	ksz_phylink_get_caps(ds, port, config);
-
 	config->mac_capabilities = MAC_10 | MAC_100 | MAC_1000FD |
 				   MAC_ASYM_PAUSE | MAC_SYM_PAUSE;
 }
@@ -1302,7 +1300,7 @@ static const struct dsa_switch_ops ksz9477_switch_ops = {
 	.phy_read		= ksz_phy_read16,
 	.phy_write		= ksz_phy_write16,
 	.phylink_mac_link_down	= ksz_mac_link_down,
-	.phylink_get_caps	= ksz9477_get_caps,
+	.phylink_get_caps	= ksz_phylink_get_caps,
 	.port_enable		= ksz_enable_port,
 	.get_strings		= ksz_get_strings,
 	.get_ethtool_stats	= ksz_get_ethtool_stats,
@@ -1400,6 +1398,7 @@ static const struct ksz_dev_ops ksz9477_dev_ops = {
 	.vlan_del = ksz9477_port_vlan_del,
 	.mirror_add = ksz9477_port_mirror_add,
 	.mirror_del = ksz9477_port_mirror_del,
+	.get_caps = ksz9477_get_caps,
 	.shutdown = ksz9477_reset_switch,
 	.init = ksz9477_switch_init,
 	.exit = ksz9477_switch_exit,
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index d14cb50fe610..827ca7522a20 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -469,6 +469,9 @@ void ksz_phylink_get_caps(struct dsa_switch *ds, int port,
 	if (dev->info->internal_phy[port])
 		__set_bit(PHY_INTERFACE_MODE_INTERNAL,
 			  config->supported_interfaces);
+
+	if (dev->dev_ops->get_caps)
+		dev->dev_ops->get_caps(dev, port, config);
 }
 EXPORT_SYMBOL_GPL(ksz_phylink_get_caps);
 
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 39c6ae3d47f9..af5f37dbb2ab 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -193,6 +193,8 @@ struct ksz_dev_ops {
 			  bool ingress, struct netlink_ext_ack *extack);
 	void (*mirror_del)(struct ksz_device *dev, int port,
 			   struct dsa_mall_mirror_tc_entry *mirror);
+	void (*get_caps)(struct ksz_device *dev, int port,
+			 struct phylink_config *config);
 	void (*freeze_mib)(struct ksz_device *dev, int port, bool freeze);
 	void (*port_init_cnt)(struct ksz_device *dev, int port);
 	int (*shutdown)(struct ksz_device *dev);
-- 
2.36.1

