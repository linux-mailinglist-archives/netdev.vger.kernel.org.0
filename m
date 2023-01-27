Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64F1667DB72
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 02:48:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232689AbjA0BsY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 20:48:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231800AbjA0BsT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 20:48:19 -0500
Received: from relmlie5.idc.renesas.com (relmlor1.renesas.com [210.160.252.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 80582233C7;
        Thu, 26 Jan 2023 17:48:18 -0800 (PST)
X-IronPort-AV: E=Sophos;i="5.97,249,1669042800"; 
   d="scan'208";a="147581404"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 27 Jan 2023 10:48:16 +0900
Received: from localhost.localdomain (unknown [10.166.15.32])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 9AA5D415F68E;
        Fri, 27 Jan 2023 10:48:16 +0900 (JST)
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     linux@armlinux.org.uk, andrew@lunn.ch, hkallweit1@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH net-next v3 3/4] net: ethernet: renesas: rswitch: Enable ovr_host_interfaces
Date:   Fri, 27 Jan 2023 10:48:11 +0900
Message-Id: <20230127014812.1656340-4-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230127014812.1656340-1-yoshihiro.shimoda.uh@renesas.com>
References: <20230127014812.1656340-1-yoshihiro.shimoda.uh@renesas.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable ovr_host_interfaces to set the host_interfaces of phy_dev
for a non-sfp PHY.

Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
---
 drivers/net/ethernet/renesas/rswitch.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/renesas/rswitch.c b/drivers/net/ethernet/renesas/rswitch.c
index b0c1ea72772e..df8bc150f596 100644
--- a/drivers/net/ethernet/renesas/rswitch.c
+++ b/drivers/net/ethernet/renesas/rswitch.c
@@ -1195,6 +1195,7 @@ static int rswitch_phylink_init(struct rswitch_device *rdev)
 
 	rdev->phylink_config.dev = &rdev->ndev->dev;
 	rdev->phylink_config.type = PHYLINK_NETDEV;
+	rdev->phylink_config.ovr_host_interfaces = true;
 	__set_bit(PHY_INTERFACE_MODE_SGMII, rdev->phylink_config.supported_interfaces);
 	__set_bit(PHY_INTERFACE_MODE_USXGMII, rdev->phylink_config.supported_interfaces);
 	rdev->phylink_config.mac_capabilities = MAC_100FD | MAC_1000FD | MAC_2500FD;
-- 
2.25.1

