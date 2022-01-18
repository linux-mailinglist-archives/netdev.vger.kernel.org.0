Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C121C491D9D
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 04:40:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353359AbiARDkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 22:40:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235692AbiARDGc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 22:06:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B996BC014F2B;
        Mon, 17 Jan 2022 18:48:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6249BB811CF;
        Tue, 18 Jan 2022 02:48:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E557C36AF3;
        Tue, 18 Jan 2022 02:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642474132;
        bh=G/c4LNnucpXtwkCHxSEbJWbQlWj6wH/TH00PIgn6fJM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=asakddBN9atYryl+3qlzuNcZ2rShxD0jVDxCBBbfXZ4tJYBESWSSFmDFgvE6k/HwM
         sHyGL87X47CU9KqOANbhuyTZf9TfuMyqeXfGSVxmy7PXgmQw4vygutyJCTC2zKG1MQ
         ChKBPpgWlz296R8akmBKU+XSgExnE0EUDLEzZmJ4fglfz4DW3ERhI5ivpfKgDcv5eN
         TkzCa89WcG7ki6fB4FwnG0cMDZrAczsSD6VQOE8a4f94lzDAUb/8DbT7axrjRRoS6z
         /5Sw9TTeE3CNmVuPen59RuLt2uitdyCLXlW/Lk7G+UaS43OHHs4xJqzc4b5GJL/p3p
         PXlF1CuW88LrQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Maxime Bizon <mbizon@freebox.fr>, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, hkallweit1@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 50/59] net: mdio: Demote probed message to debug print
Date:   Mon, 17 Jan 2022 21:46:51 -0500
Message-Id: <20220118024701.1952911-50-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024701.1952911-1-sashal@kernel.org>
References: <20220118024701.1952911-1-sashal@kernel.org>
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
index 3207da2224f67..eaa890a6a5d21 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -426,7 +426,7 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
 	mdiobus_setup_mdiodev_from_board_info(bus, mdiobus_create_device);
 
 	bus->state = MDIOBUS_REGISTERED;
-	pr_info("%s: probed\n", bus->name);
+	dev_dbg(&bus->dev, "probed\n");
 	return 0;
 
 error:
-- 
2.34.1

