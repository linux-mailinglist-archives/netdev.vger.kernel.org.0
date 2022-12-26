Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77A9A6560B0
	for <lists+netdev@lfdr.de>; Mon, 26 Dec 2022 08:14:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231611AbiLZHOh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Dec 2022 02:14:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbiLZHOf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Dec 2022 02:14:35 -0500
Received: from relmlie6.idc.renesas.com (relmlor2.renesas.com [210.160.252.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AFE242BF5;
        Sun, 25 Dec 2022 23:14:33 -0800 (PST)
X-IronPort-AV: E=Sophos;i="5.96,274,1665414000"; 
   d="scan'208";a="147425267"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie6.idc.renesas.com with ESMTP; 26 Dec 2022 16:14:33 +0900
Received: from localhost.localdomain (unknown [10.166.15.32])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 0CEC54003FA1;
        Mon, 26 Dec 2022 16:14:33 +0900 (JST)
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     linux@armlinux.org.uk, andrew@lunn.ch, hkallweit1@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH net-next 1/3] net: phylink: Set host_interfaces for a non-sfp PHY
Date:   Mon, 26 Dec 2022 16:14:23 +0900
Message-Id: <20221226071425.3895915-2-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221226071425.3895915-1-yoshihiro.shimoda.uh@renesas.com>
References: <20221226071425.3895915-1-yoshihiro.shimoda.uh@renesas.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set phy_dev->host_interfaces by pl->link_interface in
phylink_fwnode_phy_connect() for a non-sfp PHY.

Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
---
 drivers/net/phy/phylink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 09cc65c0da93..1958d6cc9ef9 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1809,6 +1809,7 @@ int phylink_fwnode_phy_connect(struct phylink *pl,
 		pl->link_interface = phy_dev->interface;
 		pl->link_config.interface = pl->link_interface;
 	}
+	__set_bit(pl->link_interface, phy_dev->host_interfaces);
 
 	ret = phy_attach_direct(pl->netdev, phy_dev, flags,
 				pl->link_interface);
-- 
2.25.1

