Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A54BB5F9179
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 00:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232558AbiJIWcp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 18:32:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232553AbiJIWbO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 18:31:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEF1D1EECB;
        Sun,  9 Oct 2022 15:19:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B41F60C19;
        Sun,  9 Oct 2022 22:19:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53CCAC433D6;
        Sun,  9 Oct 2022 22:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665353992;
        bh=Ij5A9htZ1aaTYxRKuHgCxuv73CrdE31EcdiLmiz2YEQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B/4lWGMwuPqbBZl1cuncvW2VBC42bk6FHVOXswVckwhGQca8oFdf+yV1SS026grki
         gXv0ISd774Ze5wbJy3teZIpB1h4dW9RgGB9iiPMeFUElFtKXMpKtUF6n4n+LC/txbV
         9CRjr6Om8y2kRD4kp1BLL+gLY3R8ciPK9gBQ6wR29ad9btExw/sKlijjgNsUHr//jZ
         ueGAH82HSKhXDCBRfWf/af2L/wYasWc17OVqRNRyCM0VHgbVL8cu40OTsyGkENQ1L3
         Pg0r5L1suYPA1mGi8v6F/Bu09j/CKXmV/+99jUotazzUXcdA93hFiyA3f9uRVVt6bi
         4GWSyeHXlGkgA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     GUO Zihua <guozihua@huawei.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, rafal@milecki.pl,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 15/46] net: broadcom: Fix return type for implementation of
Date:   Sun,  9 Oct 2022 18:18:40 -0400
Message-Id: <20221009221912.1217372-15-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009221912.1217372-1-sashal@kernel.org>
References: <20221009221912.1217372-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: GUO Zihua <guozihua@huawei.com>

[ Upstream commit 12f7bd252221d4f9e000e20530e50129241e3a67 ]

Since Linux now supports CFI, it will be a good idea to fix mismatched
return type for implementation of hooks. Otherwise this might get
cought out by CFI and cause a panic.

bcm4908_enet_start_xmit() would return either NETDEV_TX_BUSY or
NETDEV_TX_OK, so change the return type to netdev_tx_t directly.

Signed-off-by: GUO Zihua <guozihua@huawei.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20220902075407.52358-1-guozihua@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bcm4908_enet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bcm4908_enet.c b/drivers/net/ethernet/broadcom/bcm4908_enet.c
index 376f81796a29..f92ce8f8d751 100644
--- a/drivers/net/ethernet/broadcom/bcm4908_enet.c
+++ b/drivers/net/ethernet/broadcom/bcm4908_enet.c
@@ -507,7 +507,7 @@ static int bcm4908_enet_stop(struct net_device *netdev)
 	return 0;
 }
 
-static int bcm4908_enet_start_xmit(struct sk_buff *skb, struct net_device *netdev)
+static netdev_tx_t bcm4908_enet_start_xmit(struct sk_buff *skb, struct net_device *netdev)
 {
 	struct bcm4908_enet *enet = netdev_priv(netdev);
 	struct bcm4908_enet_dma_ring *ring = &enet->tx_ring;
-- 
2.35.1

