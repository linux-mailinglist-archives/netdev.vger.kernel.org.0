Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7AE5F8FBA
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 00:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231283AbiJIWMj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 18:12:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbiJIWLi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 18:11:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8C5229C9A;
        Sun,  9 Oct 2022 15:09:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9EFCF60CBA;
        Sun,  9 Oct 2022 22:09:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10AD1C433D7;
        Sun,  9 Oct 2022 22:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665353368;
        bh=LQc9Hq9N4qEx7hcxjs71Wwvi8yIcl8MH/VNR5qpvAe8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m61ZJ8jI5pQvYDmB9kC9GkFiYssCiMi0FJOZSDCUEEKrLt1eRWTufgLfoDFCXYYcS
         2Nyd7qADC6fa5AT7jPlFCh5x3aKUKYcVBl0pqSmLxb/QN6NIlTTNhTZYJwMMQPFf4O
         iwcsQNBvF1UGHVSc6IpF24nv3mkGFLBhS69HrC3puHkGTvrmbtQ7PXpxsIulV+2Agk
         p/lQiunJX9hAxDR7c+Lt9nABfc0Dx6d0M1PP5ysSDSmXBe1S118I+h487rGxf0t2pB
         yskA4ZEzDH7vy6XCo1g4qCRUGZLRQPt/kAHwrUEg+4+z///cMLnJy6EzZx9gRD6QRc
         fVcNMfHNpq3PQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     GUO Zihua <guozihua@huawei.com>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, khalasa@piap.pl,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 29/77] net: xscale: Fix return type for implementation of ndo_start_xmit
Date:   Sun,  9 Oct 2022 18:07:06 -0400
Message-Id: <20221009220754.1214186-29-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009220754.1214186-1-sashal@kernel.org>
References: <20221009220754.1214186-1-sashal@kernel.org>
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

[ Upstream commit 0dbaf0fa62329d9fe452d9041a707a33f6274f1f ]

Since Linux now supports CFI, it will be a good idea to fix mismatched
return type for implementation of hooks. Otherwise this might get
cought out by CFI and cause a panic.

eth_xmit() would return either NETDEV_TX_BUSY or NETDEV_TX_OK, so
change the return type to netdev_tx_t directly.

Signed-off-by: GUO Zihua <guozihua@huawei.com>
Link: https://lore.kernel.org/r/20220902081612.60405-1-guozihua@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xscale/ixp4xx_eth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/xscale/ixp4xx_eth.c b/drivers/net/ethernet/xscale/ixp4xx_eth.c
index 3591b9edc9a1..3b05287b6889 100644
--- a/drivers/net/ethernet/xscale/ixp4xx_eth.c
+++ b/drivers/net/ethernet/xscale/ixp4xx_eth.c
@@ -841,7 +841,7 @@ static void eth_txdone_irq(void *unused)
 	}
 }
 
-static int eth_xmit(struct sk_buff *skb, struct net_device *dev)
+static netdev_tx_t eth_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct port *port = netdev_priv(dev);
 	unsigned int txreadyq = port->plat->txreadyq;
-- 
2.35.1

