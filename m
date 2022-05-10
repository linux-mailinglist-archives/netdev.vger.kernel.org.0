Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C050E521FB5
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 17:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346467AbiEJPw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 11:52:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346648AbiEJPvQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 11:51:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 561AB28D4E1;
        Tue, 10 May 2022 08:45:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B7CFFB81D0D;
        Tue, 10 May 2022 15:45:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC4ADC385A6;
        Tue, 10 May 2022 15:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652197527;
        bh=4IYxJ6CPgg/V9tO8g9viSi66zx65sRyQ0HAkWF2gGN8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tkdMGS3kK23l3eKlkgcFK3RRl7VxntRFPo4d2WQyW2ujBmu2d77huBqVXRNUQgCxo
         hHJ1juGFNw/htyeopIpickvxrNaAcPXmX8swfXSDx43CEHVAvbY4HZvMZga4ejqhEW
         iuq2SUq0/7AA8eR58altCpc8nzAakMy1F50TMX0vVwCAZA0isxbwE8/0HGZAtdAg5m
         XfUZu89DnRNmeS8UWjckztW/KYl7efOdA+D6McqOSoDqRkjahpBt5CC8DHW9OUHi7A
         wmpKYi5moQshWFTuk9RiJil5MgOhuKhv/efq1CxWw83QR+7+GERw0DypV3A5FsOozn
         xxamTQCoKP4SA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shravya Kumbham <shravya.kumbham@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Andrew Lunn <andrew@lunn.ch>, Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, michal.simek@xilinx.com,
        yuehaibing@huawei.com, arnd@arndb.de, trix@redhat.com,
        linmq006@gmail.com, prabhakar.mahadev-lad.rj@bp.renesas.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 6/9] net: emaclite: Don't advertise 1000BASE-T and do auto negotiation
Date:   Tue, 10 May 2022 11:45:09 -0400
Message-Id: <20220510154512.153945-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220510154512.153945-1-sashal@kernel.org>
References: <20220510154512.153945-1-sashal@kernel.org>
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
index 4bd44fbc6ecf..cc0335fceec5 100644
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

