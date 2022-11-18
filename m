Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB1362EA3B
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 01:27:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239771AbiKRA1e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 19:27:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240368AbiKRA1b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 19:27:31 -0500
Received: from relmlie6.idc.renesas.com (relmlor2.renesas.com [210.160.252.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AB56D70A1E;
        Thu, 17 Nov 2022 16:27:30 -0800 (PST)
X-IronPort-AV: E=Sophos;i="5.96,172,1665414000"; 
   d="scan'208";a="143045663"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie6.idc.renesas.com with ESMTP; 18 Nov 2022 09:27:30 +0900
Received: from localhost.localdomain (unknown [10.166.15.32])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id E57B7400CF07;
        Fri, 18 Nov 2022 09:27:29 +0900 (JST)
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Dan Carpenter <error27@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Saeed Mahameed <saeed@kernel.org>
Subject: [PATCH v2 net-next] net: ethernet: renesas: rswitch: Fix MAC address info
Date:   Fri, 18 Nov 2022 09:27:24 +0900
Message-Id: <20221118002724.996108-1-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.1 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Smatch detected the following warning.

    drivers/net/ethernet/renesas/rswitch.c:1717 rswitch_init() warn:
    '%pM' cannot be followed by 'n'

The 'n' should be '\n'.

Reported-by: Dan Carpenter <error27@gmail.com>
Suggested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Fixes: 3590918b5d07 ("net: ethernet: renesas: Add support for "Ethernet Switch"")
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Reviewed-by: Saeed Mahameed <saeed@kernel.org>
---
Changes from v1:
 https://lore.kernel.org/all/20221115235519.679115-1-yoshihiro.shimoda.uh@renesas.com/
 - Add Reviewed-by tag.

 drivers/net/ethernet/renesas/rswitch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/renesas/rswitch.c b/drivers/net/ethernet/renesas/rswitch.c
index f3d27aef1286..51ce5c26631b 100644
--- a/drivers/net/ethernet/renesas/rswitch.c
+++ b/drivers/net/ethernet/renesas/rswitch.c
@@ -1714,7 +1714,7 @@ static int rswitch_init(struct rswitch_private *priv)
 	}
 
 	for (i = 0; i < RSWITCH_NUM_PORTS; i++)
-		netdev_info(priv->rdev[i]->ndev, "MAC address %pMn",
+		netdev_info(priv->rdev[i]->ndev, "MAC address %pM\n",
 			    priv->rdev[i]->ndev->dev_addr);
 
 	return 0;
-- 
2.25.1

