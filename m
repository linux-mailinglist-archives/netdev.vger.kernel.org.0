Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71526597681
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 21:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238619AbiHQTb2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 15:31:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236670AbiHQTbY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 15:31:24 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE74AA4062;
        Wed, 17 Aug 2022 12:31:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1660764667; x=1692300667;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VxhvjPh6nkSaaXjiUDDL88V5dgrbv2n0hTL3lDadRE4=;
  b=eVgKS3soNJDqUG84ShpkeivGVHnkOuViVDhBGd7HtUb3p3ohaphxFCNq
   iadIMJ2jNxrKZCmfLvYacVGxrNc67bywiLIgR3cLgaedCO1wh6YsoZuNl
   KDKUiG95Pxagr+3BEy1bQlr1tfDU49rVSmwwmg0KDRpqb6QoQloD/Svap
   q7GSwni8WY21WuXK0ipp2r2vKD4OEonuq54q4QDdM8txxaPVdseuFZIv0
   ayfEGMm+1MEYkloNGSVXRno+1i4fQF3Z/bPncU2nigj+cIDuE5Rf64TOU
   eqy+bdAvkvfWRDBx+aB+y3LDkR9k2H7A34PGhG0Ob62Fn6YLngb5l3tCI
   A==;
X-IronPort-AV: E=Sophos;i="5.93,244,1654585200"; 
   d="scan'208";a="176816615"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Aug 2022 12:31:05 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 17 Aug 2022 12:30:54 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Wed, 17 Aug 2022 12:30:53 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <vladimir.oltean@nxp.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v4 4/8] net: lan966x: Expose lan966x_switchdev_nb and lan966x_switchdev_blocking_nb
Date:   Wed, 17 Aug 2022 21:34:45 +0200
Message-ID: <20220817193449.1673002-5-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220817193449.1673002-1-horatiu.vultur@microchip.com>
References: <20220817193449.1673002-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Expose lan966x_switchdev_nb and lan966x_switchdev_blocking_nb to the
lan966x_main.h file because they will be needed by the lag driver.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 drivers/net/ethernet/microchip/lan966x/lan966x_main.h      | 2 ++
 drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c | 6 ++----
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index b02c1c803945..516ed8e9183d 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -297,6 +297,8 @@ struct lan966x_port {
 extern const struct phylink_mac_ops lan966x_phylink_mac_ops;
 extern const struct phylink_pcs_ops lan966x_phylink_pcs_ops;
 extern const struct ethtool_ops lan966x_ethtool_ops;
+extern struct notifier_block lan966x_switchdev_nb __read_mostly;
+extern struct notifier_block lan966x_switchdev_blocking_nb __read_mostly;
 
 bool lan966x_netdevice_check(const struct net_device *dev);
 
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c b/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
index d9fc6a9a3da1..d9b3ca5f6214 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
@@ -6,8 +6,6 @@
 #include "lan966x_main.h"
 
 static struct notifier_block lan966x_netdevice_nb __read_mostly;
-static struct notifier_block lan966x_switchdev_nb __read_mostly;
-static struct notifier_block lan966x_switchdev_blocking_nb __read_mostly;
 
 static void lan966x_port_set_mcast_ip_flood(struct lan966x_port *port,
 					    u32 pgid_ip)
@@ -572,11 +570,11 @@ static struct notifier_block lan966x_netdevice_nb __read_mostly = {
 	.notifier_call = lan966x_netdevice_event,
 };
 
-static struct notifier_block lan966x_switchdev_nb __read_mostly = {
+struct notifier_block lan966x_switchdev_nb __read_mostly = {
 	.notifier_call = lan966x_switchdev_event,
 };
 
-static struct notifier_block lan966x_switchdev_blocking_nb __read_mostly = {
+struct notifier_block lan966x_switchdev_blocking_nb __read_mostly = {
 	.notifier_call = lan966x_switchdev_blocking_event,
 };
 
-- 
2.33.0

