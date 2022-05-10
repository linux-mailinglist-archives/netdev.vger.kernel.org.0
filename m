Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52F7F521FD5
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 17:48:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346556AbiEJPwi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 11:52:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346813AbiEJPv1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 11:51:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FDF248306;
        Tue, 10 May 2022 08:46:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE285614AF;
        Tue, 10 May 2022 15:46:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DA81C385A6;
        Tue, 10 May 2022 15:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652197562;
        bh=oT8WAKXs8AAjuEpWukOHcm1sT3N4y4mKYyxOnqq/xs4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MbNmaiQNzXn4pIt4WSEdsgDzX9L94Y0MRZz1av3XCs6WMx7BEmtd8EHPAE83nLTOi
         1tCklBmhbp6MSq92ugGrXSyqEjVWKJeNkF+NNWD+/CX1/5UeVgF05ez5g72oc4B2Vv
         s2xgxlQxPQx/izNlScv4k/flyt9+vic8aCe/HdtYjL0bvwT38NDICrThj6sUxnPy5a
         udf5d6UUT9lFsjapmloBHo+KMQ59oJeB7PgYCl73CrXI3yGMEIVgmaNXzXom7xxd1C
         OalsqGpR6lCjdyg50IVv57rypZD1pE0suy6dZ8o6v13pgeaGYEhaf4wY3RHt9r2KN7
         769HL3F+yHKtA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shravya Kumbham <shravya.kumbham@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Andrew Lunn <andrew@lunn.ch>, Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, michal.simek@xilinx.com,
        yuehaibing@huawei.com, linmq006@gmail.com, trix@redhat.com,
        prabhakar.mahadev-lad.rj@bp.renesas.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 6/8] net: emaclite: Don't advertise 1000BASE-T and do auto negotiation
Date:   Tue, 10 May 2022 11:45:34 -0400
Message-Id: <20220510154536.154070-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220510154536.154070-1-sashal@kernel.org>
References: <20220510154536.154070-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shravya Kumbham <shravya.kumbham@xilinx.com>

[ Upstream commit b800528b97d0adc3a5ba42d78a8b0d3f07a31f44 ]

In xemaclite_open() function we are setting the max speed of
emaclite to 100Mb using phy_set_max_speed() function so,
there is no need to write the advertising registers to stop
giga-bit speed and the phy_start() function starts the
auto-negotiation so, there is no need to handle it separately
using advertising registers. Remove the phy_read and phy_write
of advertising registers in xemaclite_open() function.

Signed-off-by: Shravya Kumbham <shravya.kumbham@xilinx.com>
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xilinx/xilinx_emaclite.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
index 63a2d1bcccfb..5fae598c4f76 100644
--- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
+++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
@@ -923,8 +923,6 @@ static int xemaclite_open(struct net_device *dev)
 	xemaclite_disable_interrupts(lp);
 
 	if (lp->phy_node) {
-		u32 bmcr;
-
 		lp->phy_dev = of_phy_connect(lp->ndev, lp->phy_node,
 					     xemaclite_adjust_link, 0,
 					     PHY_INTERFACE_MODE_MII);
@@ -935,19 +933,6 @@ static int xemaclite_open(struct net_device *dev)
 
 		/* EmacLite doesn't support giga-bit speeds */
 		phy_set_max_speed(lp->phy_dev, SPEED_100);
-
-		/* Don't advertise 1000BASE-T Full/Half duplex speeds */
-		phy_write(lp->phy_dev, MII_CTRL1000, 0);
-
-		/* Advertise only 10 and 100mbps full/half duplex speeds */
-		phy_write(lp->phy_dev, MII_ADVERTISE, ADVERTISE_ALL |
-			  ADVERTISE_CSMA);
-
-		/* Restart auto negotiation */
-		bmcr = phy_read(lp->phy_dev, MII_BMCR);
-		bmcr |= (BMCR_ANENABLE | BMCR_ANRESTART);
-		phy_write(lp->phy_dev, MII_BMCR, bmcr);
-
 		phy_start(lp->phy_dev);
 	}
 
-- 
2.35.1

