Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B3175F8FBD
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 00:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbiJIWMp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 18:12:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231296AbiJIWLk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 18:11:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55E17106;
        Sun,  9 Oct 2022 15:09:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2D07B80DDD;
        Sun,  9 Oct 2022 22:09:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05F9FC43143;
        Sun,  9 Oct 2022 22:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665353366;
        bh=+AJPGenBgFAiiPW7WrHtLVmHu2KcQ0VzgQggN5EiGNo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VnuimQhUgsJjOOtcKXZtSsu1AgAHTsldAWzHH+JlDv0rsv7VKhbgYawiDzLtqtpVr
         cyaLU0wpIf1oCi6Atd/8l6H9VAuqBp8oYQnKb+hwUXrwd6Nno6dMULKeyv1lsvZrXE
         pcBcn2EBWm+OOa4jw8XxJV7jAymxbvcR6EBy3EJIoEoYiuuZdot1sCjqflE9q2qz8J
         Ib7mDrIiieRGy+ahwOyqBumrdWS55pO+92iKcCuqzZvFET/YmwYQu7yiJVgi1p9NsD
         YHiQTgIN/6g5FYeG4o2CnF6YyekIFZc/NAHgZNpjIQkGMD4KdIyrA9LFpNRiozD1vz
         KTHZyNpsXuv9g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     GUO Zihua <guozihua@huawei.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, rafal@milecki.pl,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 28/77] net: broadcom: Fix return type for implementation of
Date:   Sun,  9 Oct 2022 18:07:05 -0400
Message-Id: <20221009220754.1214186-28-sashal@kernel.org>
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
index c131d8118489..e5e17a182f9d 100644
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

