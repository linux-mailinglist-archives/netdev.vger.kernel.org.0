Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFEA7379DE9
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 05:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbhEKDnZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 23:43:25 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:2688 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229465AbhEKDnY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 23:43:24 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FfNvt56gkz1BKbl;
        Tue, 11 May 2021 11:39:38 +0800 (CST)
Received: from thunder-town.china.huawei.com (10.174.177.72) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.498.0; Tue, 11 May 2021 11:42:07 +0800
From:   Zhen Lei <thunder.leizhen@huawei.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        b43-dev <b43-dev@lists.infradead.org>,
        netdev <netdev@vger.kernel.org>
CC:     Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH v2 1/1] b43: phy_n: Delete some useless TODO code
Date:   Tue, 11 May 2021 11:42:03 +0800
Message-ID: <20210511034203.4122-2-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.26.0.windows.1
In-Reply-To: <20210511034203.4122-1-thunder.leizhen@huawei.com>
References: <20210511034203.4122-1-thunder.leizhen@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.177.72]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These TODO empty code are added by
commit 9442e5b58edb ("b43: N-PHY: partly implement SPUR workaround"). It's
been more than a decade now. I don't think anyone who wants to perfect
this workaround can follow this TODO tip exactly. Instead, it limits them
to new thinking. Remove it will be better.

No functional change.

By the way, this helps reduce some binary code size.
Before:
text    data    bss     dec     hex
74472   9967    0       84439   149d7

After:
text    data    bss     dec     hex
74408   9919    0       84327   14967

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 drivers/net/wireless/broadcom/b43/phy_n.c | 47 -----------------------
 1 file changed, 47 deletions(-)

diff --git a/drivers/net/wireless/broadcom/b43/phy_n.c b/drivers/net/wireless/broadcom/b43/phy_n.c
index 665b737fbb0d820..cf3ccf4ddfe7230 100644
--- a/drivers/net/wireless/broadcom/b43/phy_n.c
+++ b/drivers/net/wireless/broadcom/b43/phy_n.c
@@ -4592,58 +4592,11 @@ static void b43_nphy_spur_workaround(struct b43_wldev *dev)
 {
 	struct b43_phy_n *nphy = dev->phy.n;
 
-	u8 channel = dev->phy.channel;
-	int tone[2] = { 57, 58 };
-	u32 noise[2] = { 0x3FF, 0x3FF };
-
 	B43_WARN_ON(dev->phy.rev < 3);
 
 	if (nphy->hang_avoid)
 		b43_nphy_stay_in_carrier_search(dev, 1);
 
-	if (nphy->gband_spurwar_en) {
-		/* TODO: N PHY Adjust Analog Pfbw (7) */
-		if (channel == 11 && b43_is_40mhz(dev)) {
-			; /* TODO: N PHY Adjust Min Noise Var(2, tone, noise)*/
-		} else {
-			; /* TODO: N PHY Adjust Min Noise Var(0, NULL, NULL)*/
-		}
-		/* TODO: N PHY Adjust CRS Min Power (0x1E) */
-	}
-
-	if (nphy->aband_spurwar_en) {
-		if (channel == 54) {
-			tone[0] = 0x20;
-			noise[0] = 0x25F;
-		} else if (channel == 38 || channel == 102 || channel == 118) {
-			if (0 /* FIXME */) {
-				tone[0] = 0x20;
-				noise[0] = 0x21F;
-			} else {
-				tone[0] = 0;
-				noise[0] = 0;
-			}
-		} else if (channel == 134) {
-			tone[0] = 0x20;
-			noise[0] = 0x21F;
-		} else if (channel == 151) {
-			tone[0] = 0x10;
-			noise[0] = 0x23F;
-		} else if (channel == 153 || channel == 161) {
-			tone[0] = 0x30;
-			noise[0] = 0x23F;
-		} else {
-			tone[0] = 0;
-			noise[0] = 0;
-		}
-
-		if (!tone[0] && !noise[0]) {
-			; /* TODO: N PHY Adjust Min Noise Var(1, tone, noise)*/
-		} else {
-			; /* TODO: N PHY Adjust Min Noise Var(0, NULL, NULL)*/
-		}
-	}
-
 	if (nphy->hang_avoid)
 		b43_nphy_stay_in_carrier_search(dev, 0);
 }
-- 
2.26.0.106.g9fadedd


