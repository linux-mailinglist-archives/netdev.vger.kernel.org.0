Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00D4F4A8E7C
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 21:37:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355253AbiBCUhc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 15:37:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354693AbiBCUf3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 15:35:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5A13C0613AC;
        Thu,  3 Feb 2022 12:34:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 56FF361B03;
        Thu,  3 Feb 2022 20:34:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06718C340E8;
        Thu,  3 Feb 2022 20:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920483;
        bh=ux248V0POPKjdJUJNtyaDAVvogc5sUitZJw1c/YZlj0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tBLxWYOG3BWZwvjgoPrbvTaPqv0OKQRwZol4ZLL7m2c2XCxQmgIj35l/xWcOYDbM0
         0Qm7dagjb3/FTKsYSQSA72EGZdJt/e6mTOKT5nPRDYoKUZOJ4lJ1qqSfmTs26POYxU
         NhuVkVZinBwQm9P42Tz78ibgAaJ85mduZfZnz+4IcV88p/NRTlAHt/GejRJHuZPiHP
         aEvsQsg6HKDxEA5q4NSLZsb10G5jORpY2BnZwkl4t/Wq6eQycn3ZbpgB4PjJ0h81LI
         +S6EyrqtA8E8XA2X8eHzZ01E4Ewx4Ztf+CW7QVTe83zwuuqLMJp2u+8g+hNf3YKELh
         5xCIg1HuQKysA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jisheng Zhang <jszhang@kernel.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        kuba@kernel.org, mripard@kernel.org, wens@csie.org,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev,
        linux-stm32@st-md-mailman.stormreply.com
Subject: [PATCH AUTOSEL 5.15 40/41] net: stmmac: dwmac-sun8i: use return val of readl_poll_timeout()
Date:   Thu,  3 Feb 2022 15:32:44 -0500
Message-Id: <20220203203245.3007-40-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220203203245.3007-1-sashal@kernel.org>
References: <20220203203245.3007-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jisheng Zhang <jszhang@kernel.org>

[ Upstream commit 9e0db41e7a0b6f1271cbcfb16dbf5b8641b4e440 ]

When readl_poll_timeout() timeout, we'd better directly use its return
value.

Before this patch:
[    2.145528] dwmac-sun8i: probe of 4500000.ethernet failed with error -14

After this patch:
[    2.138520] dwmac-sun8i: probe of 4500000.ethernet failed with error -110

Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Acked-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
index 4422baeed3d89..13fbb68158c66 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
@@ -756,7 +756,7 @@ static int sun8i_dwmac_reset(struct stmmac_priv *priv)
 
 	if (err) {
 		dev_err(priv->device, "EMAC reset timeout\n");
-		return -EFAULT;
+		return err;
 	}
 	return 0;
 }
-- 
2.34.1

