Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 059A555B22D
	for <lists+netdev@lfdr.de>; Sun, 26 Jun 2022 15:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234491AbiFZNBo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jun 2022 09:01:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234478AbiFZNBl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jun 2022 09:01:41 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F1B911A02;
        Sun, 26 Jun 2022 06:01:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1656248500; x=1687784500;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=i3dTgu5cCiI1GecLKaml6iWF9+R4VX1LRaaaCSPP3wY=;
  b=At26ih7TA5vKxC7sKrUr50pXPpj44TYYf9csXwsF7C8i/fE1o6wDZxWK
   z8RjmfuJYtiCNyj4cphCbXSskxLGF0AtdsRW0dgEeotJB8xH7gy5/G38k
   yVHvGXUKt4TG9MjTL+br28UtJcxskWPA/SS5uLPccnlefwbu9uQSi+jKm
   MLr0i7JueGge7j74CEtvOuOEOYe8wX5FQZw17Twarcf4jIn+vH2b1R5IL
   ISYvCyanbhTYQfixvL0RMfR7ll3Nihd7Oodz+JcilzGiVhIkIXYyQsZxf
   YxrMWoEF8IgXPjPox0/kXSqU3aQm9XfufTwNDe3RWLHmcWfJy6SNyFast
   g==;
X-IronPort-AV: E=Sophos;i="5.92,224,1650956400"; 
   d="scan'208";a="165122499"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 26 Jun 2022 06:01:40 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Sun, 26 Jun 2022 06:01:40 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Sun, 26 Jun 2022 06:01:38 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 3/8] net: lan966x: Expose lan966x_switchdev_nb and lan966x_switchdev_blocking_nb
Date:   Sun, 26 Jun 2022 15:04:46 +0200
Message-ID: <20220626130451.1079933-4-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220626130451.1079933-1-horatiu.vultur@microchip.com>
References: <20220626130451.1079933-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
index 3b86ddddc756..4701c20c8393 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -296,6 +296,8 @@ struct lan966x_port {
 extern const struct phylink_mac_ops lan966x_phylink_mac_ops;
 extern const struct phylink_pcs_ops lan966x_phylink_pcs_ops;
 extern const struct ethtool_ops lan966x_ethtool_ops;
+extern struct notifier_block lan966x_switchdev_nb __read_mostly;
+extern struct notifier_block lan966x_switchdev_blocking_nb __read_mostly;
 
 bool lan966x_netdevice_check(const struct net_device *dev);
 
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c b/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
index df2bee678559..300a5850e812 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
@@ -6,8 +6,6 @@
 #include "lan966x_main.h"
 
 static struct notifier_block lan966x_netdevice_nb __read_mostly;
-static struct notifier_block lan966x_switchdev_nb __read_mostly;
-static struct notifier_block lan966x_switchdev_blocking_nb __read_mostly;
 
 static void lan966x_port_set_mcast_ip_flood(struct lan966x_port *port,
 					    u32 pgid_ip)
@@ -571,11 +569,11 @@ static struct notifier_block lan966x_netdevice_nb __read_mostly = {
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

