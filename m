Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D59A853794F
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 12:45:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234799AbiE3Kp2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 06:45:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235448AbiE3KoZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 06:44:25 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02BE97DE03;
        Mon, 30 May 2022 03:44:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1653907452; x=1685443452;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=E5BLy6gRUx5QYynXA0m1su3odBaUXpMPYruvosrgoeU=;
  b=2FQTRPt28pgcIjgt2/UENK8hnjHlGSAsuCiV8xAfHYIbUD0DyuYdD77+
   Ko2AtXmu9SSu5kOC4tBtWWQD+FvVp8mSV0O/Gtwn3hdKS/zjp/WrEKvmC
   B8DTQErWRlvokzH/e3dpL8zDaWn0IJhp7xBoCYLvT1jySKTSJHxqWmrbn
   A/Z9iE9TsiBsk7NvUe6C2k7lX/vx0ntOUZu4HjDQjyC+erUTrWDheG2R6
   w61aUdXzLJoMlPpUPSpz1KPF4c5vO5vyUTUE4SWjgOQNC9LnBgR+N0+P9
   o2BaFlm6OrLhzXGagJUM+2nAYfVkz2YMh5BA7RlHNoIvb+OOPOLo1y/w6
   A==;
X-IronPort-AV: E=Sophos;i="5.91,262,1647327600"; 
   d="scan'208";a="165913165"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 May 2022 03:44:10 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 30 May 2022 03:44:08 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Mon, 30 May 2022 03:44:03 -0700
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
Subject: [RFC Patch net-next v2 07/15] net: dsa: microchip: update the ksz_phylink_get_caps
Date:   Mon, 30 May 2022 16:12:49 +0530
Message-ID: <20220530104257.21485-8-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220530104257.21485-1-arun.ramadoss@microchip.com>
References: <20220530104257.21485-1-arun.ramadoss@microchip.com>
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
---
 drivers/net/dsa/microchip/ksz8795.c    | 9 +++------
 drivers/net/dsa/microchip/ksz9477.c    | 7 +++----
 drivers/net/dsa/microchip/ksz_common.c | 3 +++
 drivers/net/dsa/microchip/ksz_common.h | 2 ++
 4 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index e6982fa9d382..25763d89c67a 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -1353,13 +1353,9 @@ static int ksz8_setup(struct dsa_switch *ds)
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
@@ -1381,7 +1377,7 @@ static const struct dsa_switch_ops ksz8_switch_ops = {
 	.setup			= ksz8_setup,
 	.phy_read		= ksz_phy_read16,
 	.phy_write		= ksz_phy_write16,
-	.phylink_get_caps	= ksz8_get_caps,
+	.phylink_get_caps	= ksz_phylink_get_caps,
 	.phylink_mac_link_down	= ksz_mac_link_down,
 	.port_enable		= ksz_enable_port,
 	.get_strings		= ksz_get_strings,
@@ -1464,6 +1460,7 @@ static const struct ksz_dev_ops ksz8_dev_ops = {
 	.mirror_add = ksz8_port_mirror_add,
 	.mirror_del = ksz8_port_mirror_del,
 	.get_stp_reg = ksz8_get_stp_reg,
+	.get_caps = ksz8_get_caps,
 	.shutdown = ksz8_reset_switch,
 	.init = ksz8_switch_init,
 	.exit = ksz8_switch_exit,
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index f08694aba6bb..494f93e4c7f8 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -1073,11 +1073,9 @@ static void ksz9477_phy_errata_setup(struct ksz_device *dev, int port)
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
@@ -1307,7 +1305,7 @@ static const struct dsa_switch_ops ksz9477_switch_ops = {
 	.phy_read		= ksz_phy_read16,
 	.phy_write		= ksz_phy_write16,
 	.phylink_mac_link_down	= ksz_mac_link_down,
-	.phylink_get_caps	= ksz9477_get_caps,
+	.phylink_get_caps	= ksz_phylink_get_caps,
 	.port_enable		= ksz_enable_port,
 	.get_strings		= ksz_get_strings,
 	.get_ethtool_stats	= ksz_get_ethtool_stats,
@@ -1406,6 +1404,7 @@ static const struct ksz_dev_ops ksz9477_dev_ops = {
 	.mirror_add = ksz9477_port_mirror_add,
 	.mirror_del = ksz9477_port_mirror_del,
 	.get_stp_reg = ksz9477_get_stp_reg,
+	.get_caps = ksz9477_get_caps,
 	.shutdown = ksz9477_reset_switch,
 	.init = ksz9477_switch_init,
 	.exit = ksz9477_switch_exit,
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 5cf183f753d9..c1303a46a9b7 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -456,6 +456,9 @@ void ksz_phylink_get_caps(struct dsa_switch *ds, int port,
 	if (dev->info->internal_phy[port])
 		__set_bit(PHY_INTERFACE_MODE_INTERNAL,
 			  config->supported_interfaces);
+
+	if (dev->dev_ops->get_caps)
+		dev->dev_ops->get_caps(dev, port, config);
 }
 EXPORT_SYMBOL_GPL(ksz_phylink_get_caps);
 
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 2727934b7171..8124737a1170 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -193,6 +193,8 @@ struct ksz_dev_ops {
 	void (*mirror_del)(struct ksz_device *dev, int port,
 			   struct dsa_mall_mirror_tc_entry *mirror);
 	int (*get_stp_reg)(void);
+	void (*get_caps)(struct ksz_device *dev, int port,
+			 struct phylink_config *config);
 	void (*freeze_mib)(struct ksz_device *dev, int port, bool freeze);
 	void (*port_init_cnt)(struct ksz_device *dev, int port);
 	int (*shutdown)(struct ksz_device *dev);
-- 
2.36.1

