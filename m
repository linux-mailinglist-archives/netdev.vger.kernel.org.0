Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E9B2491635
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:33:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345864AbiARCcI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:32:08 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:47286 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344397AbiARC3w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:29:52 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A53D7610A3;
        Tue, 18 Jan 2022 02:29:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CF09C36AF2;
        Tue, 18 Jan 2022 02:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472991;
        bh=rpK3+TbL9U4gIt72SS2rJL1owWGxYC3tz1KHKjGihMM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BhxyuTaYLOHOYKGmjqI/V+q2Q3y6Ji/22ZNH9B/uZnrWq0vZcgHgOx8ilGVQM2X/J
         lzv0IwnlwZtHTrWLFflsxEyR6frB4MCCs6MqXYhQsGACFw1PKH4YQZy2WEYNa+Td6f
         c34SHYmbGN7wtN+Qu9hG1cI6wxksqR7JS/e81wzFTnNEiU5WyUlypGVnbkVEVBhtXN
         z982u5gwIKIFjPXqYKVyUOrW130xRtQ9HvEEEO1kFxbrrMr9a0f6cTrHxBX56XKkk/
         x+trczGgFJiFI2BTE0pqZrJtc6MTksrkfkaSNCaP/4m+POfL7pppmFHzVhU1LIYRl4
         dh/o7b87oq4Gg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Maxime Bizon <mbizon@freebox.fr>, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, hkallweit1@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 194/217] net: mdio: Demote probed message to debug print
Date:   Mon, 17 Jan 2022 21:19:17 -0500
Message-Id: <20220118021940.1942199-194-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit 7590fc6f80ac2cbf23e6b42b668bbeded070850b ]

On systems with large numbers of MDIO bus/muxes the message indicating
that a given MDIO bus has been successfully probed is repeated for as
many buses we have, which can eat up substantial boot time for no
reason, demote to a debug print.

Reported-by: Maxime Bizon <mbizon@freebox.fr>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20220103194024.2620-1-f.fainelli@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/mdio_bus.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index c198722e4871d..3f7b93d5c76fe 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -594,7 +594,7 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
 	mdiobus_setup_mdiodev_from_board_info(bus, mdiobus_create_device);
 
 	bus->state = MDIOBUS_REGISTERED;
-	pr_info("%s: probed\n", bus->name);
+	dev_dbg(&bus->dev, "probed\n");
 	return 0;
 
 error:
-- 
2.34.1

