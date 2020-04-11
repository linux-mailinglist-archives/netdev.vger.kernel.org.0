Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D97C71A56D2
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 01:19:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730501AbgDKXSJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Apr 2020 19:18:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:55954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730320AbgDKXOS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Apr 2020 19:14:18 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EBC7C20757;
        Sat, 11 Apr 2020 23:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646858;
        bh=tL5KqA/A1apd2OrNKNGGjHvAXjB7VJvNySpa1cDJy9s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ToFKF6Mfawtl5THdJOI+nV7pqAu0035gtrQNqE3GQOUXJ2dz4K9uwhTidgel79rl6
         LjPerQ3afWp2882oUdvMTOQ3VF6/JH2ybJnrHYlN5A/TbqreYI2w2jMmRa855KYTcB
         MEYGKxWwOtVripC/gN5R3Qt4UuiUKW2x4ztUKGSQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 04/26] net: phy: mscc: accept all RGMII species in vsc85xx_mac_if_set
Date:   Sat, 11 Apr 2020 19:13:51 -0400
Message-Id: <20200411231413.26911-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411231413.26911-1-sashal@kernel.org>
References: <20200411231413.26911-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit da206d65f2b293274f8082a26da4e43a1610da54 ]

The helper for configuring the pinout of the MII side of the PHY should
do so irrespective of whether RGMII delays are used or not. So accept
the ID, TXID and RXID variants as well, not just the no-delay RGMII
variant.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/mscc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/phy/mscc.c b/drivers/net/phy/mscc.c
index 77a6671d572e3..2c4de7f87c3fd 100644
--- a/drivers/net/phy/mscc.c
+++ b/drivers/net/phy/mscc.c
@@ -260,6 +260,9 @@ static int vsc85xx_mac_if_set(struct phy_device *phydev,
 	reg_val = phy_read(phydev, MSCC_PHY_EXT_PHY_CNTL_1);
 	reg_val &= ~(MAC_IF_SELECTION_MASK);
 	switch (interface) {
+	case PHY_INTERFACE_MODE_RGMII_TXID:
+	case PHY_INTERFACE_MODE_RGMII_RXID:
+	case PHY_INTERFACE_MODE_RGMII_ID:
 	case PHY_INTERFACE_MODE_RGMII:
 		reg_val |= (MAC_IF_SELECTION_RGMII << MAC_IF_SELECTION_POS);
 		break;
-- 
2.20.1

