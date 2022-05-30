Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 015AF53833D
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 16:39:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241102AbiE3OcE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 10:32:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241742AbiE3Oah (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 10:30:37 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9781F69B75;
        Mon, 30 May 2022 06:52:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 07ED0CE0FC9;
        Mon, 30 May 2022 13:52:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E39FC36AF6;
        Mon, 30 May 2022 13:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653918738;
        bh=gEvp05trtCahzfWE7DwLeU08NiFJsEmHDyAXVpflLBk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t8jePuVrf47BBPFQNGGzohhtSnnWbH6CMK2NTa0VLw+cpuycnQe1F6kqjExWNmcyA
         +AZwU7ZkTcl/cvv1xULfcQYkjj4r+sITsG3L4/mcL4g67t89dV2iqC8nfGbSD/qWgY
         YflMgLlJ78ZXQccfKgi/Z7l+wlh1UxmEfB+jwP/+fNnPRI/pLHnboeWMF/PlnDQKgI
         EMDW22YRnEOmnHeSyPJOBAXYs3lBKeiPGpHQAnzq6L5QrLuCmdt49Y/+r6M+jGYpDR
         mcJ7kRM64gW7khtrtFcajDwJ1qdjweLjudMgsfMnth0DLrhXuEevi2UwcHtOfCuONU
         YUPFESTPuhC3Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Haowen Bai <baihaowen@meizu.com>, Kalle Valo <kvalo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, Larry.Finger@lwfinger.net,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wireless@vger.kernel.org,
        b43-dev@lists.infradead.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 03/24] b43legacy: Fix assigning negative value to unsigned variable
Date:   Mon, 30 May 2022 09:51:50 -0400
Message-Id: <20220530135211.1937674-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530135211.1937674-1-sashal@kernel.org>
References: <20220530135211.1937674-1-sashal@kernel.org>
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
index 995c7d0c212a..11ee5ee48976 100644
--- a/drivers/net/wireless/broadcom/b43legacy/phy.c
+++ b/drivers/net/wireless/broadcom/b43legacy/phy.c
@@ -1148,7 +1148,7 @@ void b43legacy_phy_lo_b_measure(struct b43legacy_wldev *dev)
 	struct b43legacy_phy *phy = &dev->phy;
 	u16 regstack[12] = { 0 };
 	u16 mls;
-	u16 fval;
+	s16 fval;
 	int i;
 	int j;
 
-- 
2.35.1

