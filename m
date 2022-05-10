Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D66F3521F59
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 17:44:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244315AbiEJPsQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 11:48:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346226AbiEJPsL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 11:48:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07C51280E18;
        Tue, 10 May 2022 08:44:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 01810614A9;
        Tue, 10 May 2022 15:44:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAC0DC385C2;
        Tue, 10 May 2022 15:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652197446;
        bh=DNkhD6VTUM7fXUikvAIycfwNIqFBbm8FeVeT6ISDgZs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B9D5dHX0uglBH69wzaeBFTkj7Gt6xla+ijzRrG9SB1sDS/HbQBf6sVMrY8PpETEmV
         3J6cgizqEjYSbiNvBFHlBd2iQ8J1nHK7FyPfF3xaZ2p299mkwox327KpkYpUtBlHM8
         A+x824I4XUFwO9T5fcWALRCPoEDJF8mlYT1uZp6tabsKUaa/6iUu7Ph+gx0umS1aHa
         ARM10QgnVrCD2I55BjE9IhnzhOjAFSRS/VHGS1upG4e4xEgyn3VrQaT2Iln7mQ1VPf
         128lBH+w7hh7Dea9X8I3sGSQTIauVYJO/TDeSPoB8TB8CuJ3rlk19hlqU/vf+QmkdG
         4bUCNZqLpT1Pw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shravya Kumbham <shravya.kumbham@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Andrew Lunn <andrew@lunn.ch>, Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, michal.simek@xilinx.com,
        arnd@arndb.de, yuehaibing@huawei.com,
        prabhakar.mahadev-lad.rj@bp.renesas.com, linmq006@gmail.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.17 11/21] net: emaclite: Don't advertise 1000BASE-T and do auto negotiation
Date:   Tue, 10 May 2022 11:43:30 -0400
Message-Id: <20220510154340.153400-11-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220510154340.153400-1-sashal@kernel.org>
References: <20220510154340.153400-1-sashal@kernel.org>
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
index 77fa2cb03aca..29e942cd3c44 100644
--- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
+++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
@@ -926,8 +926,6 @@ static int xemaclite_open(struct net_device *dev)
 	xemaclite_disable_interrupts(lp);
 
 	if (lp->phy_node) {
-		u32 bmcr;
-
 		lp->phy_dev = of_phy_connect(lp->ndev, lp->phy_node,
 					     xemaclite_adjust_link, 0,
 					     PHY_INTERFACE_MODE_MII);
@@ -938,19 +936,6 @@ static int xemaclite_open(struct net_device *dev)
 
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

