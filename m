Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD25A53814A
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 16:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239839AbiE3OTH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 10:19:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240948AbiE3OQj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 10:16:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C2A910EA49;
        Mon, 30 May 2022 06:44:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E22660FD6;
        Mon, 30 May 2022 13:44:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AD43C385B8;
        Mon, 30 May 2022 13:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653918261;
        bh=Bkd23sX7Gv/V+UyqdUT5JU9g3D19EXhrLTVzmu+pFg8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ny9dOUZhzWWbWqsiwY4buRX/4viG4SEskbutNgaGfrltRbr/hombcTr3ygGYwN2Tl
         LYkkSfcJBk0zic1saUDRW6AoKNqOeelnQsR7IsZ7sZXP7Z7eVUFZiQ6aGFD/Nc5yU8
         VLT3Twmr0wp9hbFfiqqvVUIuNBtpJZ1Cr7ebe4a1nkt1jf/vgMpg8nH0zfVY2pWvWs
         QYwRnUJ3IyzidJiqg7djrrEpFTEZQ/IpxCUrDGVW8TLLsKL5MYG/5r9aoxnFCpj0O9
         Jtn1mT5mR4M/SwGD/JR8jqp7KnyBn4o2t91ihS0Fiu0aqKsSuWCqIMYee4oBROl1k6
         rVs7BAj9JWutg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Haowen Bai <baihaowen@meizu.com>, Kalle Valo <kvalo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        thunder.leizhen@huawei.com, linux-wireless@vger.kernel.org,
        b43-dev@lists.infradead.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 06/76] b43: Fix assigning negative value to unsigned variable
Date:   Mon, 30 May 2022 09:42:56 -0400
Message-Id: <20220530134406.1934928-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530134406.1934928-1-sashal@kernel.org>
References: <20220530134406.1934928-1-sashal@kernel.org>
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

From: Haowen Bai <baihaowen@meizu.com>

[ Upstream commit 11800d893b38e0e12d636c170c1abc19c43c730c ]

fix warning reported by smatch:
drivers/net/wireless/broadcom/b43/phy_n.c:585 b43_nphy_adjust_lna_gain_table()
warn: assigning (-2) to unsigned variable '*(lna_gain[0])'

Signed-off-by: Haowen Bai <baihaowen@meizu.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/1648203315-28093-1-git-send-email-baihaowen@meizu.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/b43/phy_n.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/b43/phy_n.c b/drivers/net/wireless/broadcom/b43/phy_n.c
index 665b737fbb0d..39975b7d1a16 100644
--- a/drivers/net/wireless/broadcom/b43/phy_n.c
+++ b/drivers/net/wireless/broadcom/b43/phy_n.c
@@ -582,7 +582,7 @@ static void b43_nphy_adjust_lna_gain_table(struct b43_wldev *dev)
 	u16 data[4];
 	s16 gain[2];
 	u16 minmax[2];
-	static const u16 lna_gain[4] = { -2, 10, 19, 25 };
+	static const s16 lna_gain[4] = { -2, 10, 19, 25 };
 
 	if (nphy->hang_avoid)
 		b43_nphy_stay_in_carrier_search(dev, 1);
-- 
2.35.1

