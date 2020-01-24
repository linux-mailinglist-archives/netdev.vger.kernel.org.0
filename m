Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC9DE148743
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 15:22:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392290AbgAXOV6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 09:21:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:43984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392277AbgAXOV4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jan 2020 09:21:56 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F5C724658;
        Fri, 24 Jan 2020 14:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579875716;
        bh=l2qtxbwG21AWKLUFUMXqPMXfxUgLx7Rl/bW6KpVZbh8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P0owBCWugg+GyEaF3WL1ZRjffA8MqhTXfV6lZYxwU+GzfCZxvW+4qXCQIKiANfuOT
         Gm911kWuzmg/D6tes2AaDq11vvxwCpikkckzhmfX9EPLM1Cq7sxQmV7PV1NyeSaA8S
         /7PEjgE4ZVWAOyfp+MwxO5qom1ecANm1N3Qz/NJo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 31/32] net: dsa: bcm_sf2: Configure IMP port for 2Gb/sec
Date:   Fri, 24 Jan 2020 09:21:18 -0500
Message-Id: <20200124142119.30484-31-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200124142119.30484-1-sashal@kernel.org>
References: <20200124142119.30484-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit 8f1880cbe8d0d49ebb7e9ae409b3b96676e5aa97 ]

With the implementation of the system reset controller we lost a setting
that is currently applied by the bootloader and which configures the IMP
port for 2Gb/sec, the default is 1Gb/sec. This is needed given the
number of ports and applications we expect to run so bring back that
setting.

Fixes: 01b0ac07589e ("net: dsa: bcm_sf2: Add support for optional reset controller line")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/bcm_sf2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index 94ad2fdd6ef0d..05440b7272615 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -137,7 +137,7 @@ static void bcm_sf2_imp_setup(struct dsa_switch *ds, int port)
 
 		/* Force link status for IMP port */
 		reg = core_readl(priv, offset);
-		reg |= (MII_SW_OR | LINK_STS);
+		reg |= (MII_SW_OR | LINK_STS | GMII_SPEED_UP_2G);
 		core_writel(priv, reg, offset);
 
 		/* Enable Broadcast, Multicast, Unicast forwarding to IMP port */
-- 
2.20.1

