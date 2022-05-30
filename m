Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59116537BCA
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 15:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236746AbiE3NZ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 09:25:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236655AbiE3NY5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 09:24:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 409F38020A;
        Mon, 30 May 2022 06:24:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ADC8660DD5;
        Mon, 30 May 2022 13:24:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD8B5C385B8;
        Mon, 30 May 2022 13:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917095;
        bh=nQbb+Dvg94Bd3lpBOt9d1emxz4LV6Rz434ipGpczzEo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QPyb2rVw4zDPS3x3RnmdRciRF1bbmQUYysaVbzh2VbUfRZOZ/W2FTlIWhv9oeBXBe
         zmVqZQEc6EXloTrSuZ4hMHEOubFntkgS0kjtG3AJGzuaXKPvxJsxJud4gG+7yxBWbV
         1kFr+Bu6nnyjv+uJp949ux/0La6qpmVduTUWqN0/sRnkn1mG2DzVipnoRv/HHVbI2E
         /bwej4U6eukDVWSoYtrlZ1ytO+VJOBzxR1ZTinAFOH21+r044rqXSLcXwMmAYZJfLM
         FpDhxItsGnVIMTgFF6z0RIOj3fdUuN75NGGfnrHVZdkW4mVgG0jlY5B5o726Sw0q6w
         SRY7Gzdvtv0GQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Haowen Bai <baihaowen@meizu.com>, Kalle Valo <kvalo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, Larry.Finger@lwfinger.net,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wireless@vger.kernel.org,
        b43-dev@lists.infradead.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 013/159] b43legacy: Fix assigning negative value to unsigned variable
Date:   Mon, 30 May 2022 09:21:58 -0400
Message-Id: <20220530132425.1929512-13-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530132425.1929512-1-sashal@kernel.org>
References: <20220530132425.1929512-1-sashal@kernel.org>
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

[ Upstream commit 3f6b867559b3d43a7ce1b4799b755e812fc0d503 ]

fix warning reported by smatch:
drivers/net/wireless/broadcom/b43legacy/phy.c:1181 b43legacy_phy_lo_b_measure()
warn: assigning (-772) to unsigned variable 'fval'

Signed-off-by: Haowen Bai <baihaowen@meizu.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/1648203433-8736-1-git-send-email-baihaowen@meizu.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/b43legacy/phy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/b43legacy/phy.c b/drivers/net/wireless/broadcom/b43legacy/phy.c
index 05404fbd1e70..c1395e622759 100644
--- a/drivers/net/wireless/broadcom/b43legacy/phy.c
+++ b/drivers/net/wireless/broadcom/b43legacy/phy.c
@@ -1123,7 +1123,7 @@ void b43legacy_phy_lo_b_measure(struct b43legacy_wldev *dev)
 	struct b43legacy_phy *phy = &dev->phy;
 	u16 regstack[12] = { 0 };
 	u16 mls;
-	u16 fval;
+	s16 fval;
 	int i;
 	int j;
 
-- 
2.35.1

