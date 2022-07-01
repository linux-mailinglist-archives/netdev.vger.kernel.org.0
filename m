Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF1BC563B7F
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 23:15:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232039AbiGAUtz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 16:49:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231430AbiGAUtq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 16:49:46 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FC0D5C9F9;
        Fri,  1 Jul 2022 13:49:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1656708585; x=1688244585;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RoXeYRz7w7kbCp0HfQAIZMkKwYe+VPebd78KGDKCp2s=;
  b=I4z+dHWM0h5N93yzSxahEGAHYqa8lqTxmuh01Oswklp7HjTvHfi7jGEi
   xSJq2rdjmIsOMgwNRapcWmgGNzaUjwgeiMlSaX2fO2mJA9aLJy49rPBCK
   0T6gySRhEZyIMX47KDb93Ct0pryADfb6QMG3TCADlc/GalgMWciPMy8bs
   0ex2VY1WLeGWAevDBubJi3ffHg7f4brlzMFStGsfaay+gtaYTmMhFTkfh
   K5e22MK4kPOhZfH+375GWRDMlQlYWchtj5hB+fV0gisfqphowlsTjTsif
   cZgZ5m50AD7Nn7OpPTYGM2zwwsNK1LL5IKFTf1d62Rv/H68zK7euhQxcM
   Q==;
X-IronPort-AV: E=Sophos;i="5.92,238,1650956400"; 
   d="scan'208";a="102710198"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Jul 2022 13:49:44 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 1 Jul 2022 13:49:42 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 1 Jul 2022 13:49:39 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <vladimir.oltean@nxp.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v3 3/7] net: lan966x: Expose lan966x_switchdev_nb and lan966x_switchdev_blocking_nb
Date:   Fri, 1 Jul 2022 22:52:23 +0200
Message-ID: <20220701205227.1337160-4-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220701205227.1337160-1-horatiu.vultur@microchip.com>
References: <20220701205227.1337160-1-horatiu.vultur@microchip.com>
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
index 0a4f4d27eaa7..f820b1c71c47 100644
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

