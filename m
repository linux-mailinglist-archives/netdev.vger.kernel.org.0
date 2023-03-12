Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8369A6B6ACA
	for <lists+netdev@lfdr.de>; Sun, 12 Mar 2023 20:52:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbjCLTw2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Mar 2023 15:52:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbjCLTw1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Mar 2023 15:52:27 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47DFA29421;
        Sun, 12 Mar 2023 12:52:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1678650745; x=1710186745;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=XtUA5eX+ffo8r5wc07ADNwYbe4UtkP11Oc3TihCP3HY=;
  b=DXWjrbHAu+XBpvJWeTJEUWhLm8oYD92Zv7LxtsMufNbKiCBfXyut1JPJ
   A+E2cO6jvTSqx8jq7rpgNx/yKcJPqhHJhfQLYwqJj6CBR82J/ao1w0U2A
   vbIp9o/XyQftQG1nvYDkgIVZHrkP+r3gbLY71ua9dv/jTBn0KtMIDNwM4
   pheP5V3DXDMGHcfodSJFH7+uo59Prpjw5kdwYEitsFvoNzpFgV6Y5FKS5
   uwtyMcy5zRTO1newOSs1bvn1dJT/z0s99i/neVGlNuVMFDw8f4MdPoili
   LHtvBIuP+KmfeYHWM4cJUdwjuJGv0NCb1q5quk5YWsKfc+JKW97CylIPA
   Q==;
X-IronPort-AV: E=Sophos;i="5.98,254,1673938800"; 
   d="scan'208";a="215943146"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Mar 2023 12:52:22 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Sun, 12 Mar 2023 12:52:22 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.21 via Frontend Transport; Sun, 12 Mar 2023 12:52:20 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next] net: lan966x: Change lan966x_police_del return type
Date:   Sun, 12 Mar 2023 20:51:55 +0100
Message-ID: <20230312195155.1492881-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As the function always returns 0 change the return type to be
void instead of int. In this way also remove a wrong message
in case of error which would never happen.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../net/ethernet/microchip/lan966x/lan966x_police.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_police.c b/drivers/net/ethernet/microchip/lan966x/lan966x_police.c
index 7d66fe75cd3bf..7302df2300fd2 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_police.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_police.c
@@ -49,8 +49,7 @@ static int lan966x_police_add(struct lan966x_port *port,
 	return 0;
 }
 
-static int lan966x_police_del(struct lan966x_port *port,
-			      u16 pol_idx)
+static void lan966x_police_del(struct lan966x_port *port, u16 pol_idx)
 {
 	struct lan966x *lan966x = port->lan966x;
 
@@ -67,8 +66,6 @@ static int lan966x_police_del(struct lan966x_port *port,
 	lan_wr(ANA_POL_PIR_CFG_PIR_RATE_SET(GENMASK(14, 0)) |
 	       ANA_POL_PIR_CFG_PIR_BURST_SET(0),
 	       lan966x, ANA_POL_PIR_CFG(pol_idx));
-
-	return 0;
 }
 
 static int lan966x_police_validate(struct lan966x_port *port,
@@ -186,7 +183,6 @@ int lan966x_police_port_del(struct lan966x_port *port,
 			    struct netlink_ext_ack *extack)
 {
 	struct lan966x *lan966x = port->lan966x;
-	int err;
 
 	if (port->tc.police_id != police_id) {
 		NL_SET_ERR_MSG_MOD(extack,
@@ -194,12 +190,7 @@ int lan966x_police_port_del(struct lan966x_port *port,
 		return -EINVAL;
 	}
 
-	err = lan966x_police_del(port, POL_IDX_PORT + port->chip_port);
-	if (err) {
-		NL_SET_ERR_MSG_MOD(extack,
-				   "Failed to add policer to port");
-		return err;
-	}
+	lan966x_police_del(port, POL_IDX_PORT + port->chip_port);
 
 	lan_rmw(ANA_POL_CFG_PORT_POL_ENA_SET(0) |
 		ANA_POL_CFG_POL_ORDER_SET(POL_ORDER),
-- 
2.38.0

