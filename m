Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAAC513E2B9
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 17:58:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733292AbgAPQ54 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 11:57:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:45418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387595AbgAPQ5z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 11:57:55 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 787BF24673;
        Thu, 16 Jan 2020 16:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193870;
        bh=Xu3SCBnCRx2cW1ZPTY0JDIiHCz0C9f5+eDMvaMS1QOg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nxpQAsGPOK7Sbs58fBKGh/my7ldZ3fdC+ERhuItqU5qkjQwCAKYckp16xwbH85FS2
         dzCFyaMvIaB6zmRo/7nnl4r94hZY7I/PcytH0Zk9dzDVDNc+3zUkbfbAE3rhbY2a8j
         jbhXiS0uUuxmVw64MHxiWC8Fd94JivIskrseRCHA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 115/671] net: phy: micrel: set soft_reset callback to genphy_soft_reset for KSZ9031
Date:   Thu, 16 Jan 2020 11:45:46 -0500
Message-Id: <20200116165502.8838-115-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165502.8838-1-sashal@kernel.org>
References: <20200116165502.8838-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 1d16073a326891c2a964e4cb95bc18fbcafb5f74 ]

So far genphy_soft_reset was used automatically if the PHY driver
didn't implement the soft_reset callback. This changed with the
mentioned commit and broke KSZ9031. To fix this configure the
KSZ9031 PHY driver to use genphy_soft_reset.

Fixes: 6e2d85ec0559 ("net: phy: Stop with excessive soft reset")
Reported-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Tested-by: Tony Lindgren <tony@atomide.com>
Tested-by: Sekhar Nori <nsekhar@ti.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/micrel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 05a6ae32ff65..b4c67c3a928b 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -977,6 +977,7 @@ static struct phy_driver ksphy_driver[] = {
 	.driver_data	= &ksz9021_type,
 	.probe		= kszphy_probe,
 	.config_init	= ksz9031_config_init,
+	.soft_reset	= genphy_soft_reset,
 	.read_status	= ksz9031_read_status,
 	.ack_interrupt	= kszphy_ack_interrupt,
 	.config_intr	= kszphy_config_intr,
-- 
2.20.1

