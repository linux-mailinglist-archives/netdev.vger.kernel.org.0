Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06045491D8D
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 04:39:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351931AbiARDjC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 22:39:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348938AbiARDeO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 22:34:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF284C037020;
        Mon, 17 Jan 2022 19:09:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4CB0060B3A;
        Tue, 18 Jan 2022 03:09:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4EC5C36AEB;
        Tue, 18 Jan 2022 03:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642475367;
        bh=ohSD3H6PwcHAXjnc8cPnR0pRDWhhFXJoW7p+x+J3LEw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WbZWDQubEmq2HGcsQn5+9lxcmwReMcifSP49FrlP5ZlStWrLN0ouU658AujcHhmHe
         OKOXY2WP7BHvtnM3MDc7DoYmu7TbGvJZ2wFoYpzWilGe9lykRhH8KMoHNxD0NqJguv
         QaFk+pmEuyVXEemdRw6MwvwGKeFpCZXOjOpfaHLMvYT5pkL2ml/aa1bOu9QwkSNa7s
         z6+KwaUGAQd4eFWgyvCkaXnMscT6+gIYbA5vPfh2IF+I58k7/xC3uw1TylkAJawXNv
         ey0nhpubucck3wojkFpMhnKV1LDtWonfodBkPY7fWjShQoUPcAR3bqWlwBiUDIxUk/
         kWeiuLS62Z+Fg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Maxime Bizon <mbizon@freebox.fr>, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, hkallweit1@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 24/29] net: mdio: Demote probed message to debug print
Date:   Mon, 17 Jan 2022 22:08:17 -0500
Message-Id: <20220118030822.1955469-24-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118030822.1955469-1-sashal@kernel.org>
References: <20220118030822.1955469-1-sashal@kernel.org>
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
index 4066fb5a935a7..2fb95cca33183 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -295,7 +295,7 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
 	}
 
 	bus->state = MDIOBUS_REGISTERED;
-	pr_info("%s: probed\n", bus->name);
+	dev_dbg(&bus->dev, "probed\n");
 	return 0;
 
 error:
-- 
2.34.1

