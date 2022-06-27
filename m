Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8695555DEE1
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240671AbiF0UKI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 16:10:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236923AbiF0UKB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 16:10:01 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3408E1F2C3;
        Mon, 27 Jun 2022 13:09:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1656360597; x=1687896597;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=i3dTgu5cCiI1GecLKaml6iWF9+R4VX1LRaaaCSPP3wY=;
  b=kydzS1+6y3Uac9f3tEfZHVgB4chs6OyIelJ3E0gvvub6Q/iquu64R+0v
   heEUyCoiWLEFIh8/scMwwAyx4kLVskom8QZHXBY7En+ed35BDclTHB1Yp
   Kmp+oE/S/AYvZC3dUvqtk/GLeqA5DHGn4jdx1enA0L+QnPeQ/T3qQasl7
   VXqr+F9Ecf95JtgTJT/2bwvWO2VMs0SecIgcaEtPRXJ56lWGOXSi7B6Tp
   RVdCz9lhMteNOINRPzEUSrEXZIev4msF23qAcHFVcIpSjoMfVMb52ATch
   4o3WoMXmzvnjVGkbhfKSQG72Sj4lRpn6WVYcdnxdoP5YFSwDkhrPy7IuJ
   A==;
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="170092509"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Jun 2022 13:09:56 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 27 Jun 2022 13:09:53 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Mon, 27 Jun 2022 13:09:52 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <vladimir.oltean@nxp.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v2 3/7] net: lan966x: Expose lan966x_switchdev_nb and lan966x_switchdev_blocking_nb
Date:   Mon, 27 Jun 2022 22:13:26 +0200
Message-ID: <20220627201330.45219-4-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220627201330.45219-1-horatiu.vultur@microchip.com>
References: <20220627201330.45219-1-horatiu.vultur@microchip.com>
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

