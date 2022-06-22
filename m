Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC70554709
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 14:11:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357201AbiFVJH7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 05:07:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357032AbiFVJHn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 05:07:43 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8A5E39BB3;
        Wed, 22 Jun 2022 02:06:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1655888801; x=1687424801;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=O+YLmbbRFsXcqHI7l6EGPHD+EO6W7uLzZnfBGwT5P7s=;
  b=pE4laODVgLXTuZjdKzcDQrRNqMinxg09XSIQxb2AzqOgsuntat4euWC3
   CZIn+5IA19BQY8h6aZdVok9NqUJyD6h3fTfgp8iYW5VR3RE4MWRHu6zhQ
   3qMm5ncNvVJLsklhqCPfe2m3IBcZU5V5eSyzX2ObAEszA5rhLgBR/78uU
   MpY3bQAXUx9lWrt5vpHf6b3L0n8TUN26tXZOJlyyqRrv8jiEtzH1XoP3T
   NiZKXGvIEpeWyDD1gFWeOmlSpBwDzdwj+R/a2ogAXetpVBObqZqz+Gjbe
   HNK1Np3f5DbujqB2LT749T5AFUyUn4TihxL10ha9cCNhNY5DGJv73dzVi
   Q==;
X-IronPort-AV: E=Sophos;i="5.92,212,1650956400"; 
   d="scan'208";a="164526716"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Jun 2022 02:06:40 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 22 Jun 2022 02:06:40 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Wed, 22 Jun 2022 02:06:35 -0700
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
Subject: [Patch net-next 02/13] net: dsa: microchip: add config_cpu_port to struct ksz_dev_ops
Date:   Wed, 22 Jun 2022 14:34:14 +0530
Message-ID: <20220622090425.17709-3-arun.ramadoss@microchip.com>
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

To have the common set of initialization in ksz_setup, introduced the
new config_cpu_port member to ksz_dev_ops. Since both the ksz8795.c and
ksz9477.c configuring the cpu port in the setup function, introduced the
member.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz8795.c    | 3 ++-
 drivers/net/dsa/microchip/ksz9477.c    | 3 ++-
 drivers/net/dsa/microchip/ksz_common.h | 1 +
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index ad58112bda44..0df2140b7ccc 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -1402,7 +1402,7 @@ static int ksz8_setup(struct dsa_switch *ds)
 			   UNICAST_VLAN_BOUNDARY | NO_EXC_COLLISION_DROP,
 			   UNICAST_VLAN_BOUNDARY | NO_EXC_COLLISION_DROP);
 
-	ksz8_config_cpu_port(ds);
+	dev->dev_ops->config_cpu_port(ds);
 
 	ksz_cfg(dev, REG_SW_CTRL_2, MULTICAST_STORM_DISABLE, true);
 
@@ -1545,6 +1545,7 @@ static const struct ksz_dev_ops ksz8_dev_ops = {
 	.mirror_add = ksz8_port_mirror_add,
 	.mirror_del = ksz8_port_mirror_del,
 	.get_caps = ksz8_get_caps,
+	.config_cpu_port = ksz8_config_cpu_port,
 	.reset = ksz8_reset_switch,
 	.init = ksz8_switch_init,
 	.exit = ksz8_switch_exit,
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 4e0e9507e62a..fef8142440cf 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -1268,7 +1268,7 @@ static int ksz9477_setup(struct dsa_switch *ds)
 	if (ret)
 		return ret;
 
-	ksz9477_config_cpu_port(ds);
+	dev->dev_ops->config_cpu_port(ds);
 
 	ksz_cfg(dev, REG_SW_MAC_CTRL_1, MULTICAST_STORM_DISABLE, true);
 
@@ -1400,6 +1400,7 @@ static const struct ksz_dev_ops ksz9477_dev_ops = {
 	.mdb_del = ksz9477_mdb_del,
 	.change_mtu = ksz9477_change_mtu,
 	.max_mtu = ksz9477_max_mtu,
+	.config_cpu_port = ksz9477_config_cpu_port,
 	.reset = ksz9477_reset_switch,
 	.init = ksz9477_switch_init,
 	.exit = ksz9477_switch_exit,
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 44f60922be92..d5b53b5b7b51 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -204,6 +204,7 @@ struct ksz_dev_ops {
 	int (*max_mtu)(struct ksz_device *dev, int port);
 	void (*freeze_mib)(struct ksz_device *dev, int port, bool freeze);
 	void (*port_init_cnt)(struct ksz_device *dev, int port);
+	void (*config_cpu_port)(struct dsa_switch *ds);
 	int (*reset)(struct ksz_device *dev);
 	int (*init)(struct ksz_device *dev);
 	void (*exit)(struct ksz_device *dev);
-- 
2.36.1

