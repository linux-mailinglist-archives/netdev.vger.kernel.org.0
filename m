Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA5A14050F9
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 14:42:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243551AbhIIMdB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 08:33:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:34716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353768AbhIIMYt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 08:24:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD99D61ABF;
        Thu,  9 Sep 2021 11:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188291;
        bh=oEucGP7KA0TVuE98wc3+iLQVouHdB1vVi2pdgYZ5p3g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hLTJhmGEeuMZb7KdTz+C81nFGoZYPQkF1UbfKEC/3B/ybnyJPYznPA6dx3uyhlWN7
         OABEHAD4Gs0uObt0JtII/RvLYOweFI69hhMCun/xDVyxj8plxPdDLgzIFgkbry2vVC
         EHRkOxPoUuVDIThlhV4HIhkQewkXyY2rSqVtvZ1LJ67etkLa0AYOfLvHtXRoePKs/Y
         9bZka33oN+tunna+k1nnzfeTJW77rw7/bX5/PpGmKXl9GYIBDx+RjS2WwQDIi8KkbY
         3LtFV3NouWv9Q+3lLDsbwhg8CAjSVtS8zAmSWijw8sxvAhwgO83e9btFy5AOL64Gro
         MgLthg1kgT/bA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 010/176] net: phy: Fix data type in DP83822 dp8382x_disable_wol()
Date:   Thu,  9 Sep 2021 07:48:32 -0400
Message-Id: <20210909115118.146181-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115118.146181-1-sashal@kernel.org>
References: <20210909115118.146181-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marek Vasut <marex@denx.de>

[ Upstream commit 0d6835ffe50c9c1f098b5704394331710b67af48 ]

The last argument of phy_clear_bits_mmd(..., u16 val); is u16 and not
int, just inline the value into the function call arguments.

No functional change.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/dp83822.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/dp83822.c b/drivers/net/phy/dp83822.c
index a9b058bb1be8..7bf43031cea8 100644
--- a/drivers/net/phy/dp83822.c
+++ b/drivers/net/phy/dp83822.c
@@ -305,11 +305,9 @@ static int dp83822_config_intr(struct phy_device *phydev)
 
 static int dp8382x_disable_wol(struct phy_device *phydev)
 {
-	int value = DP83822_WOL_EN | DP83822_WOL_MAGIC_EN |
-		    DP83822_WOL_SECURE_ON;
-
-	return phy_clear_bits_mmd(phydev, DP83822_DEVADDR,
-				  MII_DP83822_WOL_CFG, value);
+	return phy_clear_bits_mmd(phydev, DP83822_DEVADDR, MII_DP83822_WOL_CFG,
+				  DP83822_WOL_EN | DP83822_WOL_MAGIC_EN |
+				  DP83822_WOL_SECURE_ON);
 }
 
 static int dp83822_read_status(struct phy_device *phydev)
-- 
2.30.2

