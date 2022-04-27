Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40BDA511EE5
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240163AbiD0Pot (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 11:44:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239986AbiD0Poo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 11:44:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 612E831531
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 08:41:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE667618F7
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 15:41:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 443A8C385B0;
        Wed, 27 Apr 2022 15:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651074084;
        bh=UQ7T/ivpJnhp+Ti+c/WaKjLjgaMTqUGoKyi4mXYztSY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UsXrG1LE5E2RLtUlEospNCQSJAz+ihkIyJbeRakZD8CAipd9sUm9oe4AbidOAuVZG
         ezLMIoYTsUdjLO+6fERs2D+QXE0DrCgjaXj2fu8dELW/CKGOTX/2QaTbaNZVOjaA+m
         QihQFcX+8vr0XoAdOnG7zQQ0BLvHOqCvWgJB4qf5jRb7mGX7G9y+o6ZUb8B0Tltbwc
         B5ZLKAWErQ/SfIHnAh+kHwxsTeH7nZTIOQe6NWZfRrHP5CyQnhDEngUMgh39VJ0Ga2
         fxnYTI0e+v7bgqkNa5MLqbsMB4XRoKiKj8HU3gPJ9E2RDoPif/gs8IrtoE0lMe+7Rb
         GWgEhyJd6E5VA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, matthias.bgg@gmail.com,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH net-next 05/14] eth: mtk_eth_soc: remove a copy of the NAPI_POLL_WEIGHT define
Date:   Wed, 27 Apr 2022 08:41:02 -0700
Message-Id: <20220427154111.529975-6-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220427154111.529975-1-kuba@kernel.org>
References: <20220427154111.529975-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Defining local versions of NAPI_POLL_WEIGHT with the same
values in the drivers just makes refactoring harder.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: nbd@nbd.name
CC: john@phrozen.org
CC: sean.wang@mediatek.com
CC: Mark-MC.Lee@mediatek.com
CC: matthias.bgg@gmail.com
CC: linux-arm-kernel@lists.infradead.org
CC: linux-mediatek@lists.infradead.org
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 4 ++--
 drivers/net/ethernet/mediatek/mtk_eth_soc.h | 1 -
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 18eebcaa6a76..31c5da5d6b72 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -3298,9 +3298,9 @@ static int mtk_probe(struct platform_device *pdev)
 	 */
 	init_dummy_netdev(&eth->dummy_dev);
 	netif_napi_add(&eth->dummy_dev, &eth->tx_napi, mtk_napi_tx,
-		       MTK_NAPI_WEIGHT);
+		       NAPI_POLL_WEIGHT);
 	netif_napi_add(&eth->dummy_dev, &eth->rx_napi, mtk_napi_rx,
-		       MTK_NAPI_WEIGHT);
+		       NAPI_POLL_WEIGHT);
 
 	platform_set_drvdata(pdev, eth);
 
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index c98c7ee42c6f..b04977fa84f6 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -24,7 +24,6 @@
 #define MTK_MAX_RX_LENGTH_2K	2048
 #define MTK_TX_DMA_BUF_LEN	0x3fff
 #define MTK_DMA_SIZE		512
-#define MTK_NAPI_WEIGHT		64
 #define MTK_MAC_COUNT		2
 #define MTK_RX_ETH_HLEN		(ETH_HLEN + ETH_FCS_LEN)
 #define MTK_RX_HLEN		(NET_SKB_PAD + MTK_RX_ETH_HLEN + NET_IP_ALIGN)
-- 
2.34.1

