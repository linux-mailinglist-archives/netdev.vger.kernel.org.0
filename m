Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE6231FE61F
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 04:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731678AbgFRCbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 22:31:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:45628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729485AbgFRBPc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 21:15:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35C7521D7D;
        Thu, 18 Jun 2020 01:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442932;
        bh=VgIIpDrAuDELIijnCUKjW6fNEXXyd3TAfiapNDQUyuo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VTpn3whzooc8Y4FNfmN6HIAKK/jGql/15xjQF6SboDu+Od7z5bigCaKxEq5vXETdT
         Ea5YgaJrM7q68T8HKf3mfc+PNcFFa/9htkC8XjZW228xTnjQWeipPGOyExwHYSoPmr
         RtS52kL4+3ktlP4hC2mpsYwXunpA3XqsERagLSDY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Murphy <dmurphy@ti.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 345/388] net: marvell: Fix OF_MDIO config check
Date:   Wed, 17 Jun 2020 21:07:22 -0400
Message-Id: <20200618010805.600873-345-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Murphy <dmurphy@ti.com>

[ Upstream commit 5cd119d9a05f1c1a08778a7305b4ca0f16bc1e20 ]

When CONFIG_OF_MDIO is set to be a module the code block is not
compiled. Use the IS_ENABLED macro that checks for both built in as
well as module.

Fixes: cf41a51db8985 ("of/phylib: Use device tree properties to initialize Marvell PHYs.")
Signed-off-by: Dan Murphy <dmurphy@ti.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/marvell.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 7fc8e10c5f33..a435f7352cfb 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -337,7 +337,7 @@ static int m88e1101_config_aneg(struct phy_device *phydev)
 	return marvell_config_aneg(phydev);
 }
 
-#ifdef CONFIG_OF_MDIO
+#if IS_ENABLED(CONFIG_OF_MDIO)
 /* Set and/or override some configuration registers based on the
  * marvell,reg-init property stored in the of_node for the phydev.
  *
-- 
2.25.1

