Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD08939E09
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 13:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728355AbfFHLmQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 07:42:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:59552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728306AbfFHLmP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 Jun 2019 07:42:15 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23E87214C6;
        Sat,  8 Jun 2019 11:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559994134;
        bh=a+Fz5C2w5ALPHH+8BEBWFhqtAj0d9lGUc27ChqR04/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yaLFmzsAJ+vShj9AOcgktKfkHslq71xs8loOULkgXUEz41f5pyivY/I/MepH4b1nO
         bH+TKAitrEqwOoMTWSot/QBfe2Q/YeV3lo77ODIIEpyw5hGdq4yWHWDZr5Vb4d1v+L
         hRYCXkJ8Atc+envaSqnYSZUkH7iq93ovskU6hbfM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Max Uvarov <muvarov@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 64/70] net: phy: dp83867: Set up RGMII TX delay
Date:   Sat,  8 Jun 2019 07:39:43 -0400
Message-Id: <20190608113950.8033-64-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190608113950.8033-1-sashal@kernel.org>
References: <20190608113950.8033-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Max Uvarov <muvarov@gmail.com>

[ Upstream commit 2b892649254fec01678c64f16427622b41fa27f4 ]

PHY_INTERFACE_MODE_RGMII_RXID is less then TXID
so code to set tx delay is never called.

Fixes: 2a10154abcb75 ("net: phy: dp83867: Add TI dp83867 phy")
Signed-off-by: Max Uvarov <muvarov@gmail.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/dp83867.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
index ffaf67bdb140..2995a1788ceb 100644
--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -255,10 +255,8 @@ static int dp83867_config_init(struct phy_device *phydev)
 		ret = phy_write(phydev, MII_DP83867_PHYCTRL, val);
 		if (ret)
 			return ret;
-	}
 
-	if ((phydev->interface >= PHY_INTERFACE_MODE_RGMII_ID) &&
-	    (phydev->interface <= PHY_INTERFACE_MODE_RGMII_RXID)) {
+		/* Set up RGMII delays */
 		val = phy_read_mmd(phydev, DP83867_DEVADDR, DP83867_RGMIICTL);
 
 		if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID)
-- 
2.20.1

