Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53818491BBB
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 04:13:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243989AbiARDIx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 22:08:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352602AbiARDAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 22:00:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6F96C029809;
        Mon, 17 Jan 2022 18:46:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7DB9B6093C;
        Tue, 18 Jan 2022 02:46:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2A5AC36AF3;
        Tue, 18 Jan 2022 02:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642474003;
        bh=kd999wTU3fAGULJUDrGvKzHoIuOBNt+L72OBcGIqlCE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LXD9d6ojTpOg3T4hvqJ9NG/9n6ZDMkU0YNezD59Rabff4Ig1AzCguZqCmGuVx6PuH
         j5dcH/gPf/2OVnPSPm/oYGbHTNRR0bRPM7f6UDTeKKHe8LI4CZrbcX6rGcd7Otqy1y
         P7cC97FmC8OnWlSZmKB89fqE1F9YaKkIEOHO9dAlKaBmKb7zlVreWuZRK/vK2fIcoB
         hocvrAhTrfRX+5W3pIjpmJH6PII6IVROZgNCqkCM6z1TminMkciq3hP5xuoO9HwBgG
         KgQ+NPMwhQiwwwMes0rWjwXqINJEe2MjW9/cIgi2CtkCwl8My9lAJdHbnLNgvdqRQC
         sgvp3EB2TbnrQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Maxime Bizon <mbizon@freebox.fr>, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, hkallweit1@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 63/73] net: mdio: Demote probed message to debug print
Date:   Mon, 17 Jan 2022 21:44:22 -0500
Message-Id: <20220118024432.1952028-63-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024432.1952028-1-sashal@kernel.org>
References: <20220118024432.1952028-1-sashal@kernel.org>
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
index bec73f0640d03..b0a439248ff69 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -433,7 +433,7 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
 	mdiobus_setup_mdiodev_from_board_info(bus, mdiobus_create_device);
 
 	bus->state = MDIOBUS_REGISTERED;
-	pr_info("%s: probed\n", bus->name);
+	dev_dbg(&bus->dev, "probed\n");
 	return 0;
 
 error:
-- 
2.34.1

